Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429E77598B3
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjGSOmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjGSOmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:42:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF0A1722;
        Wed, 19 Jul 2023 07:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689777713; x=1721313713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MpxBMCMMtjUkoDvrA5NeF+Ka8LUevhEDyqLD5c1ULn0=;
  b=OCIQk1NjSF7mCRLiNMOJK3zPmCwZcCVLTTs2b12fQz/9sQ0wB8L3iAsA
   0Y9iSzBwYimn326RX/YDVPyrCeov/6TyTXtiBQc8FFuczVpvvo0AtKxI8
   t7JA7TFkKJdRKXCqsNJBYGLDWTiutMlIkjemZA5u6TOt0Z/fcJCgkQJpE
   XV3Qle2VeOdbYWp5dYmxTZ8iAshYrJTdGIlZ5EOWeJfr1dutZEdn3vgXS
   o2OuAiZbyo9umnfam/j4eoD95Dv8cPTqO5rP+Bq8R8Gh9O9WzIBJtQEv1
   XFWRq7yToQPrX8krJUtalpvMqayaPLQNFUjB5lDXAzHiSq9kyaxcvr5lc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346788185"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346788185"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="867503308"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.173.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:50 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v10 6/9] KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in emulator
Date:   Wed, 19 Jul 2023 22:41:28 +0800
Message-Id: <20230719144131.29052-7-binbin.wu@linux.intel.com>
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

Introduce a new interface get_untagged_addr() to kvm_x86_ops to untag
the metadata from linear address.  Call the interface in linearization
of instruction emulator for 64-bit mode.

When enabled feature like Intel Linear Address Masking or AMD Upper Address
Ignore, linear address may be tagged with metadata. Linear address should be
checked for modified canonicality and untagged in instruction emulator.

Introduce get_untagged_addr() to kvm_x86_ops to hide the vendor specific code.
Pass the 'flags' to allow vendor specific implementation to precisely identify
the access type.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/emulate.c             |  2 +-
 arch/x86/kvm/kvm_emulate.h         |  3 +++
 arch/x86/kvm/x86.c                 | 10 ++++++++++
 5 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 13bc212cd4bc..052652073a4b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -133,6 +133,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP(get_untagged_addr)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 881a0be862e1..36267ee7806a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1743,6 +1743,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9b4b3ce6d52a..25983ebd95fa 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -701,7 +701,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	*max_size = 0;
 	switch (mode) {
 	case X86EMUL_MODE_PROT64:
-		*linear = la;
+		*linear = la = ctxt->ops->get_untagged_addr(ctxt, la, flags);
 		va_bits = ctxt_virt_addr_bits(ctxt);
 		if (!__is_canonical_address(la, va_bits))
 			goto bad;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index c944055091e1..790cf2dea75b 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -232,6 +232,9 @@ struct x86_emulate_ops {
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+
+	gva_t (*get_untagged_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
+				   unsigned int flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6a6d08238e8d..339a113b45af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8300,6 +8300,15 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
 		kvm_vm_bugged(kvm);
 }
 
+static gva_t emulator_get_untagged_addr(struct x86_emulate_ctxt *ctxt,
+					gva_t addr, unsigned int flags)
+{
+	if (!kvm_x86_ops.get_untagged_addr)
+		return addr;
+
+	return static_call(kvm_x86_get_untagged_addr)(emul_to_vcpu(ctxt), addr, flags);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8345,6 +8354,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
+	.get_untagged_addr   = emulator_get_untagged_addr,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
-- 
2.25.1

