Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19F2761BC
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIWUNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 16:13:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:27768 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgIWUNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 16:13:51 -0400
IronPort-SDR: p+TXUlaKsndBTPniUCquuBFiyLrYjZ3Y236qyxFkWSdItuWXhd+mtMH39fksnUjd5X0X+Tui2P
 DlCL+o1mibeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="141018739"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="141018739"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 13:13:51 -0700
IronPort-SDR: itQnvj8DiFtRSDGe6OrdD3HXv/HF/aTqM/mnVxhxJhIo1ER+sFwxqlZlM2eLu7WB1OJxJ9+10l
 1VsM3kYVCK3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="349004954"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2020 13:13:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] KVM: nVMX: Read EXIT_QUAL and INTR_INFO only when needed for nested exit
Date:   Wed, 23 Sep 2020 13:13:49 -0700
Message-Id: <20200923201349.16097-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923201349.16097-1-sean.j.christopherson@intel.com>
References: <20200923201349.16097-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Read vmcs.EXIT_QUALIFICATION and vmcs.VM_EXIT_INTR_INFO only if the
VM-Exit is being reflected to L1 now that they are no longer passed
directly to the kvm_nested_vmexit tracepoint.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 39828823adfe..4c4cac48e432 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5918,9 +5918,6 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 		goto reflect_vmexit;
 	}
 
-	exit_intr_info = vmx_get_intr_info(vcpu);
-	exit_qual = vmx_get_exit_qual(vcpu);
-
 	trace_kvm_nested_vmexit(exit_reason, vcpu, KVM_ISA_VMX);
 
 	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
@@ -5937,12 +5934,14 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	 * need to be synthesized by querying the in-kernel LAPIC, but external
 	 * interrupts are never reflected to L1 so it's a non-issue.
 	 */
+	exit_intr_info = vmx_get_intr_info(vcpu);
 	if (is_exception_with_error_code(exit_intr_info)) {
 		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 		vmcs12->vm_exit_intr_error_code =
 			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	}
+	exit_qual = vmx_get_exit_qual(vcpu);
 
 reflect_vmexit:
 	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
-- 
2.28.0

