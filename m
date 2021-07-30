Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAA83DB891
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhG3M04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:26:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30229 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238847AbhG3M0v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 08:26:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627648007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Btthg04Zxziwoq8x7CSj2mL2B/Aj4CJqMYr3UqrVYBw=;
        b=WKSzyUtNofwyD8nPdNTE3i5NeC11Y05uRymHVL2L11vmmDf47D02IfNs5Ov0m0nHm+LY3y
        le6pUBfkbY6yeabcRhjp3NbgxhvD9/PVaVFSvtpdMEqStWhnXOt8Uy+zwooDRC8OfJI92Z
        e/bHIzIolFTJpim1nZ9R+HAj16SX7zc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-vmUVjCA7MFGL_4rsPIXqFw-1; Fri, 30 Jul 2021 08:26:43 -0400
X-MC-Unique: vmUVjCA7MFGL_4rsPIXqFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E18BEC1A0;
        Fri, 30 Jul 2021 12:26:42 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F6C2779D0;
        Fri, 30 Jul 2021 12:26:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: x86: hyper-v: Check if guest is allowed to use XMM registers for hypercall input
Date:   Fri, 30 Jul 2021 14:26:24 +0200
Message-Id: <20210730122625.112848-4-vkuznets@redhat.com>
In-Reply-To: <20210730122625.112848-1-vkuznets@redhat.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TLFS states that "Availability of the XMM fast hypercall interface is
indicated via the “Hypervisor Feature Identification” CPUID Leaf
(0x40000003, see section 2.4.4) ... Any attempt to use this interface
when the hypervisor does not indicate availability will result in a #UD
fault."

Implement the check for 'strict' mode (KVM_CAP_HYPERV_ENFORCE_CPUID).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2945b93dbadd..0b38f944c6b6 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2140,6 +2140,7 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 
 int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_hv_hcall hc;
 	u64 ret = HV_STATUS_SUCCESS;
 
@@ -2177,13 +2178,21 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	trace_kvm_hv_hypercall(hc.code, hc.fast, hc.rep_cnt, hc.rep_idx,
 			       hc.ingpa, hc.outgpa);
 
-	if (unlikely(!hv_check_hypercall_access(to_hv_vcpu(vcpu), hc.code))) {
+	if (unlikely(!hv_check_hypercall_access(hv_vcpu, hc.code))) {
 		ret = HV_STATUS_ACCESS_DENIED;
 		goto hypercall_complete;
 	}
 
-	if (hc.fast && is_xmm_fast_hypercall(&hc))
+	if (hc.fast && is_xmm_fast_hypercall(&hc)) {
+		if (unlikely(hv_vcpu->enforce_cpuid &&
+			     !(hv_vcpu->cpuid_cache.features_edx &
+			       HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE))) {
+			kvm_queue_exception(vcpu, UD_VECTOR);
+			return 1;
+		}
+
 		kvm_hv_hypercall_read_xmm(&hc);
+	}
 
 	switch (hc.code) {
 	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
-- 
2.31.1

