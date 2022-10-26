Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930E860EB0F
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 23:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiJZV7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 17:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJZV7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 17:59:15 -0400
X-Greylist: delayed 345 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Oct 2022 14:59:13 PDT
Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54C6A7CABD;
        Wed, 26 Oct 2022 14:59:13 -0700 (PDT)
Received: by cae.in-ulm.de (Postfix, from userid 1000)
        id 8C92A140306; Wed, 26 Oct 2022 23:53:26 +0200 (CEST)
From:   "Christian A. Ehrhardt" <lk@c--e.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Christian A. Ehrhardt" <lk@c--e.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/kvm: Fix state restore in em_rsm
Date:   Wed, 26 Oct 2022 23:52:54 +0200
Message-Id: <20221026215255.1063662-1-lk@c--e.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Syzkaller reports a stack-out-of-bounds access when
emulating RSM (return from system management mode).

Assume that a 64-bit capable host (i.e. CONFIG_X86_64 is true)
emulates a guest cpu that does not support 64-bit mode. In this case
RSM must use the 32-bit version of the SMM state map which only
contains space for 8 general purpose registers.
However, NR_EMULATOR_GPRS is defined to 16 due to CONFIG_X86_64.

As a result rsm_load_state_32 will try to restore 16
registers from the state save area which only contains 8
registers. Manual offset calculation easily shows that
memory beyond the end of the smstate buffer is accessed in
this case.

Revert the relevant parts of b443183a25ab and use explicit constants
for the number of general purpose registers, again. This
also ensures that the code in rsm_load_state_{32,64} matches
what is done in enter_smm_save_state_{32,64}.

Fixes: b443183a25ab ("KVM: x86: Reduce the number of emulator GPRs to '8' for 32-bit KVM")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3b27622d4642..05355ebaf4f3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2432,7 +2432,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 	ctxt->eflags =             GET_SMSTATE(u32, smstate, 0x7ff4) | X86_EFLAGS_FIXED;
 	ctxt->_eip =               GET_SMSTATE(u32, smstate, 0x7ff0);
 
-	for (i = 0; i < NR_EMULATOR_GPRS; i++)
+	for (i = 0; i < 8; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u32, smstate, 0x7fd0 + i * 4);
 
 	val = GET_SMSTATE(u32, smstate, 0x7fcc);
@@ -2489,7 +2489,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	u16 selector;
 	int i, r;
 
-	for (i = 0; i < NR_EMULATOR_GPRS; i++)
+	for (i = 0; i < 16; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u64, smstate, 0x7ff8 - i * 8);
 
 	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);
-- 
2.34.1

