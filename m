Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B09379ED5B
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjIMPkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjIMPkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0EA2122;
        Wed, 13 Sep 2023 08:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619603; x=1726155603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ftX34vX0JdE1zNe2VmRIjmPAyXIkSSsL9zQJ2PpWra4=;
  b=iyvsa/wiWJYzi4bXD8tvmY5vMkOUAk5mWgyPhe4i5FoTCQskG5i2fQ2K
   b4s8u6AABQSleHuVVjSioX+7YEJJCDIYe9JJBPoI1X0z/xvwhYfwyC2hp
   q/kumyDVlsqzIukXprALzOQBryznegPBcqx8Q49IqAoM9KSAZIFHcs3rl
   tIxmbXcrMqi5578CAHYQXyLz66lxE1TVWBlpFUAfZgLqEiAKf2hKb6/GT
   OSaATXSzgE+qrckxWkiyo2e9jBnUJ5Em9EGE4ORpiCbafsTFXVLmxoIXw
   3D3zyfPMRk6KOTEgBO9zWoPAGk9kDsGzeRYZrAdYCmZoIsXhwV0AYButS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030219"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030219"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852144"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852144"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:00 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 08/16] KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in emulator
Date:   Wed, 13 Sep 2023 20:42:19 +0800
Message-Id: <20230913124227.12574-9-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/emulate.c             |  2 +-
 arch/x86/kvm/kvm_emulate.h         |  3 +++
 arch/x86/kvm/x86.c                 | 10 ++++++++++
 5 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e3054e3e46d5..179931b73876 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -134,6 +134,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP(get_untagged_addr)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..08e94f30d376 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1751,6 +1751,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f54e1a2cafa9..7af58b8d57ac 100644
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
index 70f329a685fe..26f402616604 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -231,6 +231,9 @@ struct x86_emulate_ops {
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+
+	gva_t (*get_untagged_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
+				   unsigned int flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ea48ba87dacf..e03313287816 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8308,6 +8308,15 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
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
@@ -8352,6 +8361,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
+	.get_untagged_addr   = emulator_get_untagged_addr,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
-- 
2.25.1

