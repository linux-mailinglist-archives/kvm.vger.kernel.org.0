Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D82C79ED56
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjIMPju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjIMPjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:39:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE1BCCD;
        Wed, 13 Sep 2023 08:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619584; x=1726155584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mdrXILVr5mOHVuLmEBugo1IrbXpyOKuvgBxnCE1W4rQ=;
  b=jU4qZqyhHSixwTeHkSlqHz2pTxmrLhCTjhVP4j2ua/spV/e0jZ2mz6+4
   KRrs8vDDcck1qqO0XR8hrcue6fXZOf9o9YYUvRh2aTwpXZob+knyMCw9y
   LisqmcW7wy/wb/WlaBPEze6p3sOdYahCB+wsuZ0fIKmtyrA8aH13c2Z0K
   QZ1vvjeNdvlaIT8s63tmmPudfgErGAIFN3xPoac4lfTxlBqe9nofy6BjE
   HP1qnNAhyE3XvBtZ7rooHFt0w70R6yzOWv6W+KEWGiLH2PVxdwCXwHfpl
   K8/zF3UhYgx8yZilL3hiMqQLwozWAUnnQlvq1yMKpPya0K57xtbMvQz1K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030100"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030100"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867851991"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867851991"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:41 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 01/16] KVM: x86: Consolidate flags for __linearize()
Date:   Wed, 13 Sep 2023 20:42:12 +0800
Message-Id: <20230913124227.12574-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate @write and @fetch of __linearize() into a set of flags so that
additional flags can be added without needing more/new boolean parameters,
to precisely identify the access type.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/emulate.c     | 21 +++++++++++----------
 arch/x86/kvm/kvm_emulate.h |  4 ++++
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2673cd5c46cb..87ee1802166a 100644
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
index be7aeb9b8ea3..e24c8ac7b930 100644
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
2.25.1

