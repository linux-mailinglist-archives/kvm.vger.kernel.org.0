Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4940738C400
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbhEUJ4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237193AbhEUJyl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qM0wHX+VXCn/f8DtelvX6hc8+3nrzoRjyCJ5wfeLGS0=;
        b=Mn+6mg9YPgEWJ9+Ks5ZjOvwnRLMeNsRbmKRdJP6Ns8VyfY3lcq09gP1Kq43b7kMKFonAiX
        gmfmbTYUEWWF7AU1EBa7fi0NZi1D5pNxrBmvIXaykZ9VBY6sfKarQNpWtAyIcLdE5QAQVw
        T+VdaKIC1suXm3lHwuBJfY9WVwF+ZD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-VgFRGQTcN9u-FAUgecQikw-1; Fri, 21 May 2021 05:53:16 -0400
X-MC-Unique: VgFRGQTcN9u-FAUgecQikw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 691AF501E8;
        Fri, 21 May 2021 09:53:15 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC9AA687F7;
        Fri, 21 May 2021 09:53:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 20/30] KVM: x86: hyper-v: Prepare to check access to Hyper-V hypercalls
Date:   Fri, 21 May 2021 11:51:54 +0200
Message-Id: <20210521095204.2161214-21-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce hv_check_hypercallr_access() to check if the particular hypercall
should be available to guest, this will be used with
KVM_CAP_HYPERV_ENFORCE_CPUID mode.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 12b6803de1b7..4f0ab0c50c44 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2022,6 +2022,11 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
 	return HV_STATUS_SUCCESS;
 }
 
+static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
+{
+	return true;
+}
+
 int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 {
 	u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
@@ -2061,6 +2066,11 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 	trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
 
+	if (unlikely(!hv_check_hypercall_access(to_hv_vcpu(vcpu), code))) {
+		ret = HV_STATUS_ACCESS_DENIED;
+		goto hypercall_complete;
+	}
+
 	switch (code) {
 	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
 		if (unlikely(rep)) {
@@ -2167,6 +2177,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		break;
 	}
 
+hypercall_complete:
 	return kvm_hv_hypercall_complete(vcpu, ret);
 }
 
-- 
2.31.1

