Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02D475792C
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjGRKSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjGRKSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:18:49 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00671130
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 03:18:46 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qLhn0-00E2n7-GL; Tue, 18 Jul 2023 12:18:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject
        :Cc:To:From; bh=68m02lfgzGfV+2UamKr2PKcdIjOS34wAkcx/72jE3TE=; b=po8tNdMQUMvYJ
        DW5W8jukYVm28mtckh8a8QLqCrkvgYjD7e1CBy81ecUYg9NSmNcU3Do0p9xqhQywxu28D8EDUcYYW
        sx/QE2oHE3qasFE9UCspQWPCcjaj/3/pGqLbtk4N5lU3V+ZP/uwBKEIUFiE6msjSehiYdd+3IhFPJ
        bpeRYdBpO5SBwcVu5Lv0NNJIrsyPtGqdY8PhToN5BUQnJwcZDwESKR5p3rwjA34nH3GSnai5f6AZv
        A2JL7pdaeTdGgIiyf84slJmxoDtEMUQzvya4vvQesb1rbCVS9Rd8mZp6OI5BsmJZMTKYZ+kgM4c2W
        +atuZqLSj8S9dJcUTJvgQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qLhn0-0001wm-4r; Tue, 18 Jul 2023 12:18:42 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qLhmw-0008MT-LT; Tue, 18 Jul 2023 12:18:38 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] KVM: x86: Remove x86_emulate_ops::guest_has_long_mode
Date:   Tue, 18 Jul 2023 12:15:44 +0200
Message-ID: <20230718101809.1249769-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove x86_emulate_ops::guest_has_long_mode along with its implementation,
emulator_guest_has_long_mode(). It has been unused since commit
1d0da94cdafe ("KVM: x86: do not go through ctxt->ops when emulating rsm").

No functional change intended.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/kvm_emulate.h | 1 -
 arch/x86/kvm/x86.c         | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index ab65f3a47dfd..be7aeb9b8ea3 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -213,7 +213,6 @@ struct x86_emulate_ops {
 
 	bool (*get_cpuid)(struct x86_emulate_ctxt *ctxt, u32 *eax, u32 *ebx,
 			  u32 *ecx, u32 *edx, bool exact_only);
-	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..0fca1546e029 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8229,11 +8229,6 @@ static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
 	return kvm_cpuid(emul_to_vcpu(ctxt), eax, ebx, ecx, edx, exact_only);
 }
 
-static bool emulator_guest_has_long_mode(struct x86_emulate_ctxt *ctxt)
-{
-	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_LM);
-}
-
 static bool emulator_guest_has_movbe(struct x86_emulate_ctxt *ctxt)
 {
 	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_MOVBE);
@@ -8335,7 +8330,6 @@ static const struct x86_emulate_ops emulate_ops = {
 	.fix_hypercall       = emulator_fix_hypercall,
 	.intercept           = emulator_intercept,
 	.get_cpuid           = emulator_get_cpuid,
-	.guest_has_long_mode = emulator_guest_has_long_mode,
 	.guest_has_movbe     = emulator_guest_has_movbe,
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
 	.guest_has_rdpid     = emulator_guest_has_rdpid,
-- 
2.41.0

