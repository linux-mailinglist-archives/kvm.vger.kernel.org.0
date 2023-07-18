Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43257757ED8
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbjGROAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjGROAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:00:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C671BE4;
        Tue, 18 Jul 2023 07:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688810; x=1721224810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=LDXkVCSBwyltuNYKnmnknvsRCJGauTD4XIMPmA3/KsU=;
  b=HCmzmvnBFUZemQgVqopA8Gy5wiSiRGGyHMpYZrwpaf+h7Old2Br055q3
   VhWoZsSl+IPuHJnOr5m1PyZIC9P/KUSsloRI+kK3zJqPqqL1sEsqVLKtj
   gvr+V2EKts8SrL1DAt6WvDz0fPFy+vAhLg9b5lP7HMouNJ6lN52oL93fa
   uD5UwmjdJq6E5JdW7x0lxO/FY6qy7BtmGcbc4cREAsPprsQB4XtoGJTDx
   v/zyBq81z6EsQNJYoPgEvYD/ob8wc12JrauTxebdE3VcSdY6QRq5uNlIs
   HtjPWr2OvqMV5T1od2NBwl+HgN7LlQUEgx5A0CcvACLh65ULO+4W976Lv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363676126"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="363676126"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="1054291147"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="1054291147"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:49 -0700
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
Subject: [PATCH v2 4/8] KVM: x86: Add X86EMUL_F_INVTLB and pass it in em_invlpg()
Date:   Tue, 18 Jul 2023 21:18:40 +0800
Message-Id: <20230718131844.5706-5-guang.zeng@intel.com>
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

Add an emulation flag X86EMUL_F_INVTLB, which is used to identify an
instruction that does TLB invalidation without true memory access.

Only invlpg & invlpga implemented in emulator belong to this kind.
invlpga doesn't need additional information for emulation. Just pass
the flag to em_invlpg().

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/emulate.c     | 4 +++-
 arch/x86/kvm/kvm_emulate.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8e706d19ae45..9b4b3ce6d52a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3443,8 +3443,10 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	ulong linear;
+	unsigned max_size;
 
-	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
+	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, ctxt->mode,
+		&linear, X86EMUL_F_INVTLB);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->ops->invlpg(ctxt, linear);
 	/* Disable writeback. */
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index c0e48f4fa7c4..c944055091e1 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -93,6 +93,7 @@ struct x86_instruction_info {
 #define X86EMUL_F_FETCH			BIT(1)
 #define X86EMUL_F_BRANCH		BIT(2)
 #define X86EMUL_F_IMPLICIT		BIT(3)
+#define X86EMUL_F_INVTLB		BIT(4)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
-- 
2.27.0

