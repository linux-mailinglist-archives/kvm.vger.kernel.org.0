Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79266FD679
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 08:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbjEJGGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 02:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbjEJGGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 02:06:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF7F40FD;
        Tue,  9 May 2023 23:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683698801; x=1715234801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DHcSo/K/a1DhncgfYG3K+M5odYSFD+jwhsKC5xOJKRg=;
  b=Mo3Y95ufWk8P6vYx6jS3nL2Orx7CwF8Ei4GrlEVl1kuhCAMjKq+nt7zz
   yh4a9M4KfzRypVkH1+MjqOB/ss+uEfHHj/s0TOhBA64b57J+iPO42Llf4
   Di/sW/meOe3fDB/LKmYYk2qRt5DRlN+c1wlgfJjzBVyDFPJGdOgXFk3pJ
   3MbKv3vlRSFFZmOxRWiD+YUVp/qzEr5BtkcVcTB4AYUKMrmRBZemIeh3Q
   7cMh5yytUwHBXCG5HfyBoP6uQ+D6enZDRIq9lUzjqR53HCm9nORSFadfw
   oxQ/BCCtx5b+A+gx4z+ukQy0ymR301jSirtLQuJkbGOZVl7fRAygavusc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="348969246"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="348969246"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="768803052"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="768803052"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.90])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:39 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
Date:   Wed, 10 May 2023 14:06:06 +0800
Message-Id: <20230510060611.12950-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230510060611.12950-1-binbin.wu@linux.intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define a 32-bit parameter and consolidate the two bools into it.

__linearize() has two bool parameters write and fetch. And new flag
will be needed to support new feature (e.g. LAM needs a flag to skip
address untag under some conditions).

No functional change intended.

In the follow-up patches, the new parameter will be extended for LAM.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/emulate.c     | 19 +++++++++++++------
 arch/x86/kvm/kvm_emulate.h |  4 ++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 936a397a08cd..9508836e8a35 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -687,8 +687,8 @@ static unsigned insn_alignment(struct x86_emulate_ctxt *ctxt, unsigned size)
 static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 				       struct segmented_address addr,
 				       unsigned *max_size, unsigned size,
-				       bool write, bool fetch,
-				       enum x86emul_mode mode, ulong *linear)
+				       u32 flags, enum x86emul_mode mode,
+				       ulong *linear)
 {
 	struct desc_struct desc;
 	bool usable;
@@ -696,6 +696,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	u32 lim;
 	u16 sel;
 	u8  va_bits;
+	bool fetch = !!(flags & X86EMUL_F_FETCH);
+	bool write = !!(flags & X86EMUL_F_WRITE);
 
 	la = seg_base(ctxt, addr.seg) + addr.ea;
 	*max_size = 0;
@@ -757,7 +759,11 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 		     ulong *linear)
 {
 	unsigned max_size;
-	return __linearize(ctxt, addr, &max_size, size, write, false,
+	u32 flags = 0;
+
+	if (write)
+		flags |= X86EMUL_F_WRITE;
+	return __linearize(ctxt, addr, &max_size, size, flags,
 			   ctxt->mode, linear);
 }
 
@@ -768,10 +774,11 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 	unsigned max_size;
 	struct segmented_address addr = { .seg = VCPU_SREG_CS,
 					   .ea = dst };
+	u32 flags = X86EMUL_F_FETCH;
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
-	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
+	rc = __linearize(ctxt, addr, &max_size, 1, flags, ctxt->mode, &linear);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
@@ -896,6 +903,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	int cur_size = ctxt->fetch.end - ctxt->fetch.data;
 	struct segmented_address addr = { .seg = VCPU_SREG_CS,
 					   .ea = ctxt->eip + cur_size };
+	u32 flags = X86EMUL_F_FETCH;
 
 	/*
 	 * We do not know exactly how many bytes will be needed, and
@@ -907,8 +915,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	 * boundary check itself.  Instead, we use max_size to check
 	 * against op_size.
 	 */
-	rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
-			 &linear);
+	rc = __linearize(ctxt, addr, &max_size, 0, flags, ctxt->mode, &linear);
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

