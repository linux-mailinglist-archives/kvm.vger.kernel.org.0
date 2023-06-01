Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8427271A200
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbjFAPFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbjFAPEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:04:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6054519A1;
        Thu,  1 Jun 2023 08:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685631816; x=1717167816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9N6ybH8Es2bCCrJEhSwD0nBm9Sy9h0sJf/DV0HQeEMk=;
  b=mIaJYOAiBux8Q+MLpEDrEBdBuwzNCEZUx+iOtYIC4Jy6ZdBu4C4xnJE7
   5H1276cvfPCGDuK0TjK2Y0fSyLBcB8vVbWAc/LZKoeFYJVRXvDNPcCTW5
   0wEWRcj3JABmt6wl5NO9tnU5XOmZ7YzkwX+dH5gSlKVDWD/lWEt020rr7
   LHcZbcsWNFAbCNTGMak8vkRQOVtsLb9EiS1v+NXWqlPK7FlHogfURutmU
   4q/uN7oWpSZvyR8KkD7cnq//I0otQMuDDe7bW3/lERqH3q9YGsB70Dp0N
   VKGi+WzyCCyhhoVsZzlmtcNCF5RSxBsBoFtL27mFVvk9o1CdYqV6r9c+n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="383853345"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="383853345"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="657828163"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="657828163"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:38 -0700
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
Subject: [PATCH v1 1/6] KVM: x86: Consolidate flags for __linearize()
Date:   Thu,  1 Jun 2023 22:23:04 +0800
Message-Id: <20230601142309.6307-2-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230601142309.6307-1-guang.zeng@intel.com>
References: <20230601142309.6307-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Binbin Wu <binbin.wu@linux.intel.com>

Define a 32-bit parameter and consolidate the two bools into it.

__linearize() has two bool parameters write and fetch. And new flag
will be needed to support new feature (e.g. LAM needs a flag to skip
address untag under some conditions).

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
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
2.27.0

