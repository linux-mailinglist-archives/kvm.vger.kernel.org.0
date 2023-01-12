Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7978F667B34
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjALQjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjALQh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:26 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B30D13F;
        Thu, 12 Jan 2023 08:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541226; x=1705077226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AWWhAnv29kovt9Uvoe7ZCMF249GNmiv/hqhdZbnfGEA=;
  b=FVqGCgJzYiAR6bz9w+NgSpZZo9zRcyJuHHY2hA0U+RHuXptSxnvgbpQ9
   znrQjaQMpsNToGYedAeUH/6mzGxxdH/OfPhG5+mO4Jp0e6kzLOtHz5IId
   0x9l90uyvqjs8ilH4Cy3UZIetygBkYNNpbIsKEuOSqVnxajxv1+mI3JOg
   FZ8luRXJ5dGiskphw6GvmhA9Cnk2J04/eafw8wf8rtHK+oNmGj67RNkFx
   JwbhogMPm5BUZIc46wZftlgKZqMsFOsgG07LMDgkVfPylqvp4Q2GGB2/t
   aYd4vWuEvvFWTE4dZvIlitb7W2r/G7JDdLa9yOwP9Iqy7zu6C6ExoLY90
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089764"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089764"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372586"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372586"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:37 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 099/113] KVM: TDX: Handle TDX PV map_gpa hypercall
Date:   Thu, 12 Jan 2023 08:32:47 -0800
Message-Id: <1a7c87931d303b2e66874e0bbbd791aa308bc918.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 4bbde58510a4..486d0f0c6dd1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1181,6 +1181,57 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
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
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
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
@@ -1206,6 +1257,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

