Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5881757ECE
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbjGROAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjGROAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:00:08 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD9A199F;
        Tue, 18 Jul 2023 06:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688783; x=1721224783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ige1qJhMK8nxK8ysQ4ntbs6E03QAU78QiBh/RtIQ02Q=;
  b=nQcXUTsqpzn2r3cpt/7A4QyUClkI4K/G68gBaUewzJ9/XqZGRzvbf2L+
   yYNxiCGV/bUo5H+vDrIvP1nu7LDfczYqRrQHA7oSZSK9UGQIjjDVsx6xX
   94zFU/emSlQxYPLOiPFUDGx7wGeHhLGkJAv46RKglaG8FJwxfdgCuXK7R
   pUE9+VBTWfbqJZcriGIO6+ybieQSYmVpMQQY8U83eoGqRUN3mZRyejIlT
   BnVfd2XjT0R84Wfdk+HZpQx2V3UM3js+F4Jku5TAfvyo1vw5loJ+AgPfk
   gBXsJOTHG68WovLbuMfKp9am6UGrZlBpeuzkP5mE8FivnMbtuRgEeHnRt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363676080"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="363676080"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="1054291116"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="1054291116"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:40 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v2 1/8] KVM: x86: Consolidate flags for __linearize()
Date:   Tue, 18 Jul 2023 21:18:37 +0800
Message-Id: <20230718131844.5706-2-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230718131844.5706-1-guang.zeng@intel.com>
References: <20230718131844.5706-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Binbin Wu <binbin.wu@linux.intel.com>

Consolidate @write and @fetch of __linearize() into a set of flags so that
additional flags can be added without needing more/new boolean parameters,
to precisely identify the access type.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/emulate.c     | 21 +++++++++++----------
 arch/x86/kvm/kvm_emulate.h |  4 ++++
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 936a397a08cd..3ddfbc99fa4f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -687,8 +687,8 @@ static unsigned insn_alignment(struct x86_emulate_ctxt *ctxt, unsigned size)
 static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 				       struct segmented_address addr,
 				       unsigned *max_size, unsigned size,
-				       bool write, bool fetch,
-				       enum x86emul_mode mode, ulong *linear)
+				       enum x86emul_mode mode, ulong *linear,
+				       unsigned int flags)
 {
 	struct desc_struct desc;
 	bool usable;
@@ -717,11 +717,11 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 		if (!usable)
 			goto bad;
 		/* code segment in protected mode or read-only data segment */
-		if ((((ctxt->mode != X86EMUL_MODE_REAL) && (desc.type & 8))
-					|| !(desc.type & 2)) && write)
+		if ((((ctxt->mode != X86EMUL_MODE_REAL) && (desc.type & 8)) || !(desc.type & 2)) &&
+		    (flags & X86EMUL_F_WRITE))
 			goto bad;
 		/* unreadable code segment */
-		if (!fetch && (desc.type & 8) && !(desc.type & 2))
+		if (!(flags & X86EMUL_F_FETCH) && (desc.type & 8) && !(desc.type & 2))
 			goto bad;
 		lim = desc_limit_scaled(&desc);
 		if (!(desc.type & 8) && (desc.type & 4)) {
@@ -757,8 +757,8 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 		     ulong *linear)
 {
 	unsigned max_size;
-	return __linearize(ctxt, addr, &max_size, size, write, false,
-			   ctxt->mode, linear);
+	return __linearize(ctxt, addr, &max_size, size, ctxt->mode, linear,
+			   write ? X86EMUL_F_WRITE : 0);
 }
 
 static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
@@ -771,7 +771,8 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
-	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
+	rc = __linearize(ctxt, addr, &max_size, 1, ctxt->mode, &linear,
+			 X86EMUL_F_FETCH);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
@@ -907,8 +908,8 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	 * boundary check itself.  Instead, we use max_size to check
 	 * against op_size.
 	 */
-	rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
-			 &linear);
+	rc = __linearize(ctxt, addr, &max_size, 0, ctxt->mode, &linear,
+			 X86EMUL_F_FETCH);
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return rc;
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index ab65f3a47dfd..86bbe997162d 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -88,6 +88,10 @@ struct x86_instruction_info {
 #define X86EMUL_IO_NEEDED       5 /* IO is needed to complete emulation */
 #define X86EMUL_INTERCEPTED     6 /* Intercepted by nested VMCB/VMCS */
 
+/* x86-specific emulation flags */
+#define X86EMUL_F_WRITE			BIT(0)
+#define X86EMUL_F_FETCH			BIT(1)
+
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
 	/*
-- 
2.27.0

