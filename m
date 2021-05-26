Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B9F3918AB
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhEZNX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233424AbhEZNXK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8w6fuCmbYRJwE5+eJUWAEMJM2Cdgs+vWfKI0axWm6hg=;
        b=XWKMmUSLovYPl/eJyv8gKQiSE73xjmpy137b+IrOToCTLVqbtxtzw/3ls84/7tGj22j5fy
        7ghHzeHlF9JVg6ha+S8UV8Miurrzx0HPTIOI2YLC6Bc0bmtetEtgOafwmfxJxbfzBh4Bus
        9yrXWSWnTb75tVxNtlIA7NUTGqevVNU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-foulFVrBOGqPKM4aTb7k9Q-1; Wed, 26 May 2021 09:21:36 -0400
X-MC-Unique: foulFVrBOGqPKM4aTb7k9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49D9719253C2;
        Wed, 26 May 2021 13:21:35 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B04D45D9C6;
        Wed, 26 May 2021 13:21:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/11] KVM: nVMX: Introduce 'EVMPTR_MAP_PENDING' post-migration state
Date:   Wed, 26 May 2021 15:20:20 +0200
Message-Id: <20210526132026.270394-6-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unlike regular set_current_vmptr(), nested_vmx_handle_enlightened_vmptrld()
can not be called directly from vmx_set_nested_state() as KVM may not have
all the information yet (e.g. HV_X64_MSR_VP_ASSIST_PAGE MSR may not be
restored yet). Enlightened VMCS is mapped later while getting nested state
pages. In the meantime, vmx->nested.hv_evmcs_vmptr remains 'EVMPTR_INVALID'
and it's indistinguishable from 'evmcs is not in use' case. This leads to
certain issues, in particular, if KVM_GET_NESTED_STATE is called right
after KVM_SET_NESTED_STATE, KVM_STATE_NESTED_EVMCS flag in the resulting
state will be unset (and such state will later fail to load).

Introduce 'EVMPTR_MAP_PENDING' state to detect not-yet-mapped eVMCS after
restore. With this, the 'is_guest_mode(vcpu)' hack in vmx_has_valid_vmcs12()
is no longer needed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.h  |  3 ++-
 arch/x86/kvm/vmx/nested.c |  6 ++++--
 arch/x86/kvm/vmx/nested.h | 11 +++--------
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 47f802f71f6a..2ec9b46f0d0c 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -198,10 +198,11 @@ static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
+#define EVMPTR_MAP_PENDING (-2ULL)
 
 static inline bool evmptr_is_valid(u64 evmptr)
 {
-	return evmptr != EVMPTR_INVALID;
+	return evmptr != EVMPTR_INVALID && evmptr != EVMPTR_MAP_PENDING;
 }
 
 enum nested_evmptrld_status {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3640a86f1ce3..4d0867d5e94b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3093,7 +3093,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 	 * properly reflected.
 	 */
 	if (vmx->nested.enlightened_vmcs_enabled &&
-	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
+	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
 		enum nested_evmptrld_status evmptrld_status =
 			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
 
@@ -6058,7 +6058,8 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		if (vmx_has_valid_vmcs12(vcpu)) {
 			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
 
-			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+			/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
+			if (vmx->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
 				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
 
 			if (is_guest_mode(vcpu) &&
@@ -6257,6 +6258,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		 * restored yet. EVMCS will be mapped from
 		 * nested_get_vmcs12_pages().
 		 */
+		vmx->nested.hv_evmcs_vmptr = EVMPTR_MAP_PENDING;
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	} else {
 		return -EINVAL;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index c4397e83614d..b69a80f43b37 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -56,14 +56,9 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/*
-	 * In case we do two consecutive get/set_nested_state()s while L2 was
-	 * running hv_evmcs may end up not being mapped (we map it from
-	 * nested_vmx_run()/vmx_vcpu_run()). Check is_guest_mode() as we always
-	 * have vmcs12 if it is true.
-	 */
-	return is_guest_mode(vcpu) || vmx->nested.current_vmptr != -1ull ||
-		evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
+	/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
+	return vmx->nested.current_vmptr != -1ull ||
+		vmx->nested.hv_evmcs_vmptr != EVMPTR_INVALID;
 }
 
 static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
-- 
2.31.1

