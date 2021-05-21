Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257AF38C3DF
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhEUJx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:53:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234258AbhEUJxq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m2pdPhIlfV9batU/V3eAeeqC3u1spSKNpJxobBRk9XY=;
        b=A/nbIetYUpnNEDqCNNQWvqGAZlxjEyoKlISPoOXkcyq7lGtvKMB9G+GA6O3/+4CQXOeGoU
        n0saSaysw6HU+5WiujAxMrLXwgEInIF6rAFSiCXoNW25bEyvHHLwtfbIhSkxOkBiPRhlh7
        oggg5AfmPEkTcYR7kRX8WB3n51or8KE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-gIZhud_mPvi2_RyC-ZKGbg-1; Fri, 21 May 2021 05:52:19 -0400
X-MC-Unique: gIZhud_mPvi2_RyC-ZKGbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99A37801817;
        Fri, 21 May 2021 09:52:18 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FC91687F7;
        Fri, 21 May 2021 09:52:16 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/30] KVM: x86: hyper-v: Prepare to check access to Hyper-V MSRs
Date:   Fri, 21 May 2021 11:51:38 +0200
Message-Id: <20210521095204.2161214-5-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
2.31.1

