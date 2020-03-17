Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E96518789F
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgCQExO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:34106 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgCQExN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:13 -0400
IronPort-SDR: Wto3gDoyobRhkQ8INDleCc4EJpbSSD1V65ksaAtxloTn/u1DGKdKbPkFn8M7WFTnDd0IY/Ri0r
 xZ5BRlx+YaDA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:13 -0700
IronPort-SDR: uTF8dE6CeGH0vA/YDZgrrDlyG2g5MMJQRlkGr+C/+s+zNBpkgkqTKLVISR9mn2usWbM5t8lnjV
 bswzhLV1S4pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252761"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v2 09/32] KVM: VMX: Use vpid_sync_context() directly when possible
Date:   Mon, 16 Mar 2020 21:52:15 -0700
Message-Id: <20200317045238.30434-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vpid_sync_context() directly for flows that run if and only if
enable_vpid=1, or more specifically, nested VMX flows that are gated by
vmx->nested.msrs.secondary_ctls_high.SECONDARY_EXEC_ENABLE_VPID being
set, which is allowed if and only if enable_vpid=1.  Because these flows
call __vmx_flush_tlb() with @invalidate_gpa=false, the if-statement that
decides between INVEPT and INVVPID will always go down the INVVPID path,
i.e. call vpid_sync_context() because
"enable_ept && (invalidate_gpa || !enable_vpid)" always evaluates false.

This helps pave the way toward removing @invalidate_gpa and @vpid from
__vmx_flush_tlb() and its callers.

Opportunstically drop unnecessary brackets in handle_invvpid() around an
affected __vmx_flush_tlb()->vpid_sync_context() conversion.

No functional change intended.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7bd13d207199..cc36e8da215b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2481,7 +2481,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		if (nested_cpu_has_vpid(vmcs12) && nested_has_guest_tlb_tag(vcpu)) {
 			if (vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
 				vmx->nested.last_vpid = vmcs12->virtual_processor_id;
-				__vmx_flush_tlb(vcpu, nested_get_vpid02(vcpu), false);
+				vpid_sync_context(nested_get_vpid02(vcpu));
 			}
 		} else {
 			/*
@@ -5251,21 +5251,21 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		    is_noncanonical_address(operand.gla, vcpu))
 			return nested_vmx_failValid(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		if (cpu_has_vmx_invvpid_individual_addr()) {
+		if (cpu_has_vmx_invvpid_individual_addr())
 			__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR,
 				vpid02, operand.gla);
-		} else
-			__vmx_flush_tlb(vcpu, vpid02, false);
+		else
+			vpid_sync_context(vpid02);
 		break;
 	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
 	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
 		if (!operand.vpid)
 			return nested_vmx_failValid(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		__vmx_flush_tlb(vcpu, vpid02, false);
+		vpid_sync_context(vpid02);
 		break;
 	case VMX_VPID_EXTENT_ALL_CONTEXT:
-		__vmx_flush_tlb(vcpu, vpid02, false);
+		vpid_sync_context(vpid02);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.24.1

