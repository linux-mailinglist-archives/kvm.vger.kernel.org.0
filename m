Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CB83647A7
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241987AbhDSQCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:02:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241964AbhDSQCP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9RuP2dtua+2lAZ2a5p0WJ/U0MkrdiEYXpcHdY1MuY4=;
        b=RM8Y0g1PYDNfInQ2BoLTe1aWHcgny8qJFTeMCC5ctj8rmQUeO+ejvpKVzZiNNOtYU/f6Fo
        r2/WPAyZklO2RiKgm6Gc16/Uc/dYdS+LVGwzREYi+0NWC9yWOXMM+HrAajZY7mE8Gm1aL8
        z6tPZ7hE1Jr2LMv8MGazPpUiOHJMjtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-gfpM3yhPNCWvLHFiPWQ7Jg-1; Mon, 19 Apr 2021 12:01:42 -0400
X-MC-Unique: gfpM3yhPNCWvLHFiPWQ7Jg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E11F66D4F9;
        Mon, 19 Apr 2021 16:01:40 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00BD25B4B5;
        Mon, 19 Apr 2021 16:01:38 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/30] KVM: x86: hyper-v: Prepare to check access to Hyper-V MSRs
Date:   Mon, 19 Apr 2021 18:01:01 +0200
Message-Id: <20210419160127.192712-5-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce hv_check_msr_access() to check if the particular MSR
should be accessible by guest, this will be used with
KVM_CAP_HYPERV_ENFORCE_CPUID mode.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ccb298cfc933..b5bc16ea2595 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1193,12 +1193,21 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 	mutex_unlock(&hv->hv_lock);
 }
 
+
+static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
+{
+	return true;
+}
+
 static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			     bool host)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_hv *hv = to_kvm_hv(kvm);
 
+	if (unlikely(!host && !hv_check_msr_access(to_hv_vcpu(vcpu), msr)))
+		return 1;
+
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
 		hv->hv_guest_os_id = data;
@@ -1327,6 +1336,9 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
+	if (unlikely(!host && !hv_check_msr_access(hv_vcpu, msr)))
+		return 1;
+
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX: {
 		struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
@@ -1441,6 +1453,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_hv *hv = to_kvm_hv(kvm);
 
+	if (unlikely(!host && !hv_check_msr_access(to_hv_vcpu(vcpu), msr)))
+		return 1;
+
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
 		data = hv->hv_guest_os_id;
@@ -1490,6 +1505,9 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	u64 data = 0;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
+	if (unlikely(!host && !hv_check_msr_access(hv_vcpu, msr)))
+		return 1;
+
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX:
 		data = hv_vcpu->vp_index;
-- 
2.30.2

