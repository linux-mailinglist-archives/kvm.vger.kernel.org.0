Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778E1371791
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhECPKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:10:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230124AbhECPKF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 11:10:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620054551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B0hgMkjrl/sFF1H21oiyFzjwKALopt21cLCCR7aO8Zg=;
        b=aWHcBdQH0Y7sDV51zEAxASGCTYb/lEoLOTDg+hfP3b3++Dy9D+F/60j8+FGIkUG/mSTfWv
        ZdAmX1klIfxWj8i8BWJnA8PwS+RnPysrR8s5szYLFos3TSpfthNp/TVEGzYjrJo1AKh1Fz
        Payx2dtMNyZ5QTsmqdrWmPrMCBf7zAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-cI4PBN18OC2tofSdLTAN3Q-1; Mon, 03 May 2021 11:09:09 -0400
X-MC-Unique: cI4PBN18OC2tofSdLTAN3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A845800D62;
        Mon,  3 May 2021 15:09:08 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2226419C45;
        Mon,  3 May 2021 15:09:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: nVMX: Map enlightened VMCS upon restore when possible
Date:   Mon,  3 May 2021 17:08:54 +0200
Message-Id: <20210503150854.1144255-5-vkuznets@redhat.com>
In-Reply-To: <20210503150854.1144255-1-vkuznets@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It now looks like a bad idea to not restore eVMCS mapping directly from
vmx_set_nested_state(). The restoration path now depends on whether KVM
will continue executing L2 (vmx_get_nested_state_pages()) or will have to
exit to L1 (nested_vmx_vmexit()), this complicates error propagation and
diverges too much from the 'native' path when 'nested.current_vmptr' is
set directly from vmx_get_nested_state_pages().

The existing solution postponing eVMCS mapping also seems to be fragile.
In multiple places the code checks whether 'vmx->nested.hv_evmcs' is not
NULL to distinguish between eVMCS and non-eVMCS cases. All these checks
are 'incomplete' as we have a weird 'eVMCS is in use but not yet mapped'
state.

Also, in case vmx_get_nested_state() is called right after
vmx_set_nested_state() without executing the guest first, the resulting
state is going to be incorrect as 'KVM_STATE_NESTED_EVMCS' flag will be
missing.

Fix all these issues by making eVMCS restoration path closer to its
'native' sibling by putting eVMCS GPA to 'struct kvm_vmx_nested_state_hdr'.
To avoid ABI incompatibility, do not introduce a new flag and keep the
original eVMCS mapping path through KVM_REQ_GET_NESTED_STATE_PAGES in
place. To distinguish between 'new' and 'old' formats consider eVMCS
GPA == 0 as an unset GPA (thus forcing KVM_REQ_GET_NESTED_STATE_PAGES
path). While technically possible, it seems to be an extremely unlikely
case.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h |  2 ++
 arch/x86/kvm/vmx/nested.c       | 27 +++++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0662f644aad9..3845977b739e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -441,6 +441,8 @@ struct kvm_vmx_nested_state_hdr {
 
 	__u32 flags;
 	__u64 preemption_timer_deadline;
+
+	__u64 evmcs_pa;
 };
 
 struct kvm_svm_nested_state_data {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 37fdc34f7afc..4261cf4755c8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6019,6 +6019,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		.hdr.vmx.vmxon_pa = -1ull,
 		.hdr.vmx.vmcs12_pa = -1ull,
 		.hdr.vmx.preemption_timer_deadline = 0,
+		.hdr.vmx.evmcs_pa = -1ull,
 	};
 	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
 		&user_kvm_nested_state->data.vmx[0];
@@ -6037,8 +6038,10 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		if (vmx_has_valid_vmcs12(vcpu)) {
 			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
 
-			if (vmx->nested.hv_evmcs)
+			if (vmx->nested.hv_evmcs) {
 				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
+				kvm_state.hdr.vmx.evmcs_pa = vmx->nested.hv_evmcs_vmptr;
+			}
 
 			if (is_guest_mode(vcpu) &&
 			    nested_cpu_has_shadow_vmcs(vmcs12) &&
@@ -6230,13 +6233,25 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 		set_current_vmptr(vmx, kvm_state->hdr.vmx.vmcs12_pa);
 	} else if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
+		u64 evmcs_gpa = kvm_state->hdr.vmx.evmcs_pa;
+
 		/*
-		 * nested_vmx_handle_enlightened_vmptrld() cannot be called
-		 * directly from here as HV_X64_MSR_VP_ASSIST_PAGE may not be
-		 * restored yet. EVMCS will be mapped from
-		 * nested_get_vmcs12_pages().
+		 * EVMCS GPA == 0 most likely indicates that the migration data is
+		 * coming from an older KVM which doesn't support 'evmcs_pa' in
+		 * 'struct kvm_vmx_nested_state_hdr'.
 		 */
-		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+		if (evmcs_gpa && (evmcs_gpa != -1ull) &&
+		    (__nested_vmx_handle_enlightened_vmptrld(vcpu, evmcs_gpa, false) !=
+		     EVMPTRLD_SUCCEEDED)) {
+			return -EINVAL;
+		} else if (!evmcs_gpa) {
+			/*
+			 * EVMCS GPA can't be acquired from VP assist page here because
+			 * HV_X64_MSR_VP_ASSIST_PAGE may not be restored yet.
+			 * EVMCS will be mapped from nested_get_evmcs_page().
+			 */
+			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+		}
 	} else {
 		return -EINVAL;
 	}
-- 
2.30.2

