Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB98723CFC
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbjFFJSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjFFJSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:18:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137AE109;
        Tue,  6 Jun 2023 02:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686043132; x=1717579132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cjJCRl0RndewoxrmvCjtrWtwVty9zUQSK/RTSA+/jqM=;
  b=cDq8iU0mbN7q+Zt9Sboa9FFEWEVNozN5VJcqwT9qiY9W8j2OQ+BgfCnt
   3Xo5g4P1WcUXdz9/cCRWvF6VBnfa07qFP5RwezTTAk5y0wpyyt9wttkP1
   URnfkdjE9KYeXJl8mtnDcVMi3MjEpRB+FXZHPWjCArgIc09yKP42949zX
   5qk2OX5Lb/HU+niSdvTAXy+U6oQ+PZD6pmFAtdb3dhEj9QI+nOioAGEku
   dE4S/DnnGxEzhTXCo1BxI2PI9TVgHCXuiByur9oqqOS+rvZYtLXpZZ4UM
   vYHhqJuzZA4ExoJ3B+bIh6A1ZBBn3yZO5maN8vGMHpELFYKiLmVHKhKOK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341252812"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="341252812"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:18:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="883263616"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="883263616"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.170.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:18:48 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v9 1/6] KVM: x86: Consolidate flags for __linearize()
Date:   Tue,  6 Jun 2023 17:18:37 +0800
Message-Id: <20230606091842.13123-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230606091842.13123-1-binbin.wu@linux.intel.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate two bool parameters (write/fetch) of __linearize() into a
'u32 flags' parameter to make the function be more concise and future
extendable, i.e. to support Intel Linear Address Masking (LAM), which
allows high non-address bits of linear address to be used as metadata.

Define two flags to replace the two bools.  A new flag will be added to
to support LAM to skip masking off metadata bits of linear address
under some conditions.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/emulate.c     | 19 ++++++++++---------
 arch/x86/kvm/kvm_emulate.h |  4 ++++
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 936a397a08cd..e89afc39e56f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -687,8 +687,8 @@ static unsigned insn_alignment(struct x86_emulate_ctxt *ctxt, unsigned size)
 static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 				       struct segmented_address addr,
 				       unsigned *max_size, unsigned size,
-				       bool write, bool fetch,
-				       enum x86emul_mode mode, ulong *linear)
+				       enum x86emul_mode mode, ulong *linear,
+				       u32 flags)
 {
 	struct desc_struct desc;
 	bool usable;
@@ -718,10 +718,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 			goto bad;
 		/* code segment in protected mode or read-only data segment */
 		if ((((ctxt->mode != X86EMUL_MODE_REAL) && (desc.type & 8))
-					|| !(desc.type & 2)) && write)
+			|| !(desc.type & 2)) && (flags & X86EMUL_F_WRITE))
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
index ab65f3a47dfd..5b9ec610b2cb 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -88,6 +88,10 @@ struct x86_instruction_info {
 #define X86EMUL_IO_NEEDED       5 /* IO is needed to complete emulation */
 #define X86EMUL_INTERCEPTED     6 /* Intercepted by nested VMCB/VMCS */
 
+/* x86-specific emulation flags */
+#define X86EMUL_F_FETCH			BIT(0)
+#define X86EMUL_F_WRITE			BIT(1)
+
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
 	/*
-- 
2.25.1

