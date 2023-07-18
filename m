Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8145D757ED1
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbjGROAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbjGROAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:00:13 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E56019A9;
        Tue, 18 Jul 2023 06:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688788; x=1721224788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=G5f5OxUaGuqF1xaVh2Um4pSh/J282MGxjVg91bM/270=;
  b=ValBGWoCOLcYqoRTQ73LMiL9nz/9VeR74RTf77kl93HogVK4eY9N4fNh
   A8uZVeXKq/rihDwUcKJJ+31mqWKDeG3U+kVwKiNv5CZLdJCMafAeiP380
   B3UCcUl249J+Cbpzg8DXd6h6NPhqfnIBUWX1Q+CX1/34jp0/IQKDJmplU
   qIx8bQhISWF0wy2SO9kFH7V3SBdWg2eKCr6PY2VfmPoYM+I9y5oxpy/Ot
   OXdrAbGh60oDwMmAaFaVBNJX6V/Aad2UQWSDqRmYDCptuo3eRghfdbPg5
   BeHPOLgg7lVJysbKAwr0SlaLNJ8q/a9UKECBH6UN1lKeC2JQuZ+qr9qtG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363676095"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="363676095"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="1054291124"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="1054291124"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:43 -0700
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
Subject: [PATCH v2 2/8] KVM: x86: Use a new flag for branch instructions
Date:   Tue, 18 Jul 2023 21:18:38 +0800
Message-Id: <20230718131844.5706-3-guang.zeng@intel.com>
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

Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F_FETCH in
assign_eip(), since strictly speaking it is not behavior of instruction
fetch.

Another reason is to distinguish instruction fetch and execution of branch
instruction for feature(s) that handle differently on them.

Branch instruction is not data access instruction, so skip checking against
execute-only code segment as instruction fetch.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/emulate.c     | 5 +++--
 arch/x86/kvm/kvm_emulate.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3ddfbc99fa4f..8e706d19ae45 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -721,7 +721,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 		    (flags & X86EMUL_F_WRITE))
 			goto bad;
 		/* unreadable code segment */
-		if (!(flags & X86EMUL_F_FETCH) && (desc.type & 8) && !(desc.type & 2))
+		if (!(flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH))
+			&& (desc.type & 8) && !(desc.type & 2))
 			goto bad;
 		lim = desc_limit_scaled(&desc);
 		if (!(desc.type & 8) && (desc.type & 4)) {
@@ -772,7 +773,7 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
 	rc = __linearize(ctxt, addr, &max_size, 1, ctxt->mode, &linear,
-			 X86EMUL_F_FETCH);
+			 X86EMUL_F_BRANCH);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 86bbe997162d..9fc7d34a4ac1 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -91,6 +91,7 @@ struct x86_instruction_info {
 /* x86-specific emulation flags */
 #define X86EMUL_F_WRITE			BIT(0)
 #define X86EMUL_F_FETCH			BIT(1)
+#define X86EMUL_F_BRANCH		BIT(2)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
-- 
2.27.0

