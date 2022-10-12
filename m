Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2122D5FC2B7
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 11:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJLJLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 05:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLJLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 05:11:20 -0400
Received: from out0-137.mail.aliyun.com (out0-137.mail.aliyun.com [140.205.0.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE86140F0;
        Wed, 12 Oct 2022 02:11:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047201;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---.Pa6ue-p_1665565873;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Pa6ue-p_1665565873)
          by smtp.aliyun-inc.com;
          Wed, 12 Oct 2022 17:11:13 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Mark transfer type as X86_TRANSFER_RET when loading CS in iret emulation
Date:   Wed, 12 Oct 2022 17:11:13 +0800
Message-Id: <fcaf1408d2aaaa39b33cdd3b11bf06e7e935d11a.1665565774.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When loading code segment descriptor in iret instruction emulation, the
checks are same as far return instruction emulation, so transfer type
should be X86_TRANSFER_RET in __load_segment_descriptor(). Although,
only iret in real mode is implemented now, and no checks are actually
needed for real mode, it would still be better to mark transfer type as
X86_TRANSFER_RET.

No functional change intended.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3b27622d4642..5052eb480068 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2100,6 +2100,7 @@ static int emulate_iret_real(struct x86_emulate_ctxt *ctxt)
 			     X86_EFLAGS_FIXED;
 	unsigned long vm86_mask = X86_EFLAGS_VM | X86_EFLAGS_VIF |
 				  X86_EFLAGS_VIP;
+	u8 cpl = ctxt->ops->cpl(ctxt);
 
 	/* TODO: Add stack limit check */
 
@@ -2121,7 +2122,8 @@ static int emulate_iret_real(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
+	rc = __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, cpl,
+				       X86_TRANSFER_RET, NULL);
 
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-- 
2.31.1

