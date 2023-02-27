Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA4B6A3D23
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjB0Ibe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjB0I37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:29:59 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D282E206B8;
        Mon, 27 Feb 2023 00:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486388; x=1709022388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=crRX4eJKIGYLcIqb0h3lQZf/BA+IJdNsvIu9Nezrjsc=;
  b=Z1B4RG0K6QW2X2YBAav4vB6UzBcTFTZrWwVrZ0xPQEr3qToAJxLis25o
   Zr+gvFGPmyTUrQSpPkmpc/pNSB8hXMrbJDwf46MsJWdLWfX9LyY+xay5o
   NrHPx5yoKOyEbI5z4ymiLb+c9Yp57vXW/px/ThhYPEwva2obeBnxUCmoA
   5Uyx8iFZ7gw3IGsKL9Jy5twLVz28XQn2HuBPX4JBuWCUWMC2CX4LgHrTV
   ps7xuH9Z4NHRS1osa4JrfBJwJhM0L9mnDPX4cFI2qJd9gJ7m2eZ8nbEbq
   QCPGFXWr2TRYKdB8jU3hhjNpCJWR5cSkXVbo8nZVJYGv+I0CPvVIX3ho/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609070"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609070"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242411"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242411"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:19 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 091/106] KVM: TDX: Handle TDX PV map_gpa hypercall
Date:   Mon, 27 Feb 2023 00:23:30 -0800
Message-Id: <7cf93fefc4b2164e35a6e127abcd970c9465f92e.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV map_gpa hypercall to the kvm/mmu backend.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 53 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f20fcf8325aa..08a4e63e4aea 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1225,6 +1225,57 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_map_gpa(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gpa_t gpa = tdvmcall_a0_read(vcpu);
+	gpa_t size = tdvmcall_a1_read(vcpu);
+	gpa_t end = gpa + size;
+	gfn_t s = gpa_to_gfn(gpa) & ~kvm_gfn_shared_mask(kvm);
+	gfn_t e = gpa_to_gfn(end) & ~kvm_gfn_shared_mask(kvm);
+	int i;
+
+	if (!IS_ALIGNED(gpa, 4096) || !IS_ALIGNED(size, 4096) ||
+	    end < gpa ||
+	    end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
+	    kvm_is_private_gpa(kvm, gpa) != kvm_is_private_gpa(kvm, end)) {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+		return 1;
+	}
+
+	/*
+	 * Check how the requested region overlaps with the KVM memory slots.
+	 * For simplicity, require that it must be contained within a memslot or
+	 * it must not overlap with any memslots (MMIO).
+	 */
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
+		struct kvm_memslot_iter iter;
+
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, s, e) {
+			struct kvm_memory_slot *slot = iter.slot;
+			gfn_t slot_s = slot->base_gfn;
+			gfn_t slot_e = slot->base_gfn + slot->npages;
+
+			/* no overlap */
+			if (e < slot_s || s >= slot_e)
+				continue;
+
+			/* contained in slot */
+			if (slot_s <= s && e <= slot_e) {
+				if (kvm_slot_can_be_private(slot))
+					return tdx_vp_vmcall_to_user(vcpu);
+				continue;
+			}
+
+			break;
+		}
+	}
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1250,6 +1301,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		 * guest TD doesn't make sense.  No argument check is done.
 		 */
 		return tdx_vp_vmcall_to_user(vcpu);
+	case TDG_VP_VMCALL_MAP_GPA:
+		return tdx_map_gpa(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

