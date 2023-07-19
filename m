Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017317598B5
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjGSOmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjGSOmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:42:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569282130;
        Wed, 19 Jul 2023 07:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689777715; x=1721313715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eSyEN49dy1ybzc4P/PCVjuEoticirESjNiHlig1yblM=;
  b=K77GbNF4O+p0Mnn6O6cPzGhHS3AGOfkCtuOwzvMYcoTp8X5tw4gl6xRk
   ZLMCjjrmTFUMDkm1Y/GtYeKu5p/bHJa/M23qn30JWclJkbJ2xpKqp4RYs
   ixGZRaqJCXizP+S/oVjW/qVyuOw4x7MYUUwVHneow+uZ/47SW7isOaNfZ
   OHsUadBJ74VZZ/3nGF5/6SiZMx8ihSSo/904fnc8FElcxCBkgc0j3d+tv
   qfsC/zQvsu+o01DUFGNjxpS5VLEXVZhYARVyWT5h98GgSwR9cHjOe4X3e
   MNtSunnwGFeXp29z5CFWHAIlFBFQ0QrdGmJjOG//UbB4THZOr82TpQ2Bz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346788202"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346788202"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="867503325"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.173.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:53 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v10 7/9] KVM: VMX: Implement and wire get_untagged_addr() for LAM
Date:   Wed, 19 Jul 2023 22:41:29 +0800
Message-Id: <20230719144131.29052-8-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230719144131.29052-1-binbin.wu@linux.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LAM version of get_untagged_addr() in VMX.

Skip address untag for instruction fetch, branch target and operand of INVLPG,
which LAM doesn't apply to.  Skip address untag for implicit system accesses
since LAM doesn't apply to the loading of base addresses of memory management
registers and segment registers, their values still need to be canonical (for
now, get_untagged_addr() interface is not called for implicit system accesses,
just for future proof).

Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcee5dc3dd0b..abf6d42672cd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8177,6 +8177,39 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+static gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva,
+			    unsigned int flags)
+{
+	unsigned long cr3_bits;
+	int lam_bit;
+
+	if (flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH | X86EMUL_F_IMPLICIT |
+	             X86EMUL_F_INVTLB))
+		return gva;
+
+	if (!is_64_bit_mode(vcpu))
+		return gva;
+
+	/*
+	 * Bit 63 determines if the address should be treated as user address
+	 * or a supervisor address.
+	 */
+	if (!(gva & BIT_ULL(63))) {
+		cr3_bits = kvm_get_active_cr3_lam_bits(vcpu);
+		if (!(cr3_bits & (X86_CR3_LAM_U57 | X86_CR3_LAM_U48)))
+			return gva;
+
+		/* LAM_U48 is ignored if LAM_U57 is set. */
+		lam_bit = cr3_bits & X86_CR3_LAM_U57 ? 56 : 47;
+	} else {
+		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LAM_SUP))
+			return gva;
+
+		lam_bit = kvm_is_cr4_bit_set(vcpu, X86_CR4_LA57) ? 56 : 47;
+	}
+	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8316,6 +8349,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.get_untagged_addr = vmx_get_untagged_addr,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
-- 
2.25.1

