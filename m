Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFBA76F03D
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 19:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbjHCRA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 13:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbjHCRAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 13:00:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647553C28
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 10:00:05 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58419550c3aso12892977b3.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 10:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691082004; x=1691686804;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LdpV+DH+21J7QAEkTnfNOAQAsfcko1q6UaP1GJIDTnI=;
        b=zXo67EMFCmlR8g2/3AGxLd05dx70MvSxWD4rF+7pgg99d1xuRvHZrpbOgyGUsP3QBU
         ylvUZJY/+4n4+ZEEfTrsh+ne0dd4tnwdm3VZBLGhaQd9BJAEOVUzLpzk1zK2rNowebYt
         TmRtsvrV95AFDUiRlwg38JifdZ22CGW3+t5sLmvAfc9L+HxOB/fRmPpKGq6uw65HJnIM
         yRlVhg8xn7zxiAcfa4SOUwZthveRqF2C98mhQF9eBEmFRjzvoqTOMCVHfltJDERF2jWc
         Pd9Cz+hKIzOcz6sL8SCuxrEduMDYrGGwXbpPLXGH5AFPaOlAF2gpcH3Dc4Mh2RE1eLHv
         yh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691082004; x=1691686804;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LdpV+DH+21J7QAEkTnfNOAQAsfcko1q6UaP1GJIDTnI=;
        b=e+I6abtVOa2kwf4+er3JLLOW7Pd8qDNNhqf57d22bp3oO65l+88U36rq8BJW1Kjupe
         98SQThijlqyCD9rJcIzWSb6WYjCTzRmXz3+ttpqOIapTJFCgQhVIEC7KCraFFxVtKo4Z
         Cn7VKT0j1hmf1F29MfqkkMSoGLf/Txut9j9+fZNfVQjZIIfvydJJVcChaHTKt1n1FqZy
         mxOWUZWVzfbRFdpUrqWhiVnJrEJ6rR0wOwn4UOukePjQPRUgQWATFsi5xcMiVz2a90v1
         a/3NkMbSR0BBmw4s9NzVR+6FfMXLpuiqa43GDci4MnNENQItx6Ejsnz8AirWxpwmf/oQ
         b31Q==
X-Gm-Message-State: ABy/qLYywhw/ygTtc0pf5nstLqSZF5luh5rZOazDV1/j48XTU7iaUDh/
        r7RSdQodDfD+9NP8w07eohysRiyhRvsqpVDnk5s=
X-Google-Smtp-Source: APBJJlGksVVjGVIObIx2/mXTZpuRAMwuhKcKzs8rLj2YUL4cq0X1qaSCaYxW3X08m1IWm04TsbXN5fkglVjgnv6z5Wk=
X-Received: from ndesaulniers-desktop.svl.corp.google.com ([2620:15c:2d1:203:cd2a:c126:8d90:d5ab])
 (user=ndesaulniers job=sendgmr) by 2002:a81:b301:0:b0:576:fdbe:76b2 with SMTP
 id r1-20020a81b301000000b00576fdbe76b2mr186945ywh.3.1691082004604; Thu, 03
 Aug 2023 10:00:04 -0700 (PDT)
Date:   Thu, 03 Aug 2023 10:00:02 -0700
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABHdy2QC/x2NWwqDMBAAryL7bSBVwdKrlCJ57NaFNA27IoJ4d
 6OfwzDMDorCqPBqdhBcWfmfKzzaBsLs8hcNx8rQ2a63T9ubUsK0JM9pS4WjCRQ9DRQHGglq5J2 i8eJymK/s53RBuUQRJN7u0/tzHCfgFm7WeQAAAA==
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=UIrHvErwpgNbhCkRZAYSX0CFd/XFEwqX3D0xqtqjNug=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691082002; l=3336;
 i=ndesaulniers@google.com; s=20220923; h=from:subject:message-id;
 bh=ygrekE3OJlxoODNxNdS4zpKsCJbmF4Ej66DUNrX+sns=; b=6ESEzLXLRxfTTmoIr1ONWLU2kpm/KUS/7LVisgI5MJMLO6Evo7UTzeGnfKvWdnsvmi3aS8J/D
 F894n+V/CtADKx/l04oyCTIC06BNo6t4xFQceRgtaNdCZGsDic6Jx2o
X-Mailer: b4 0.12.2
Message-ID: <20230803-ppc_tlbilxlpid-v1-1-84a1bc5cf963@google.com>
Subject: [PATCH] powerpc/inst: add PPC_TLBILX_LPID
From:   ndesaulniers@google.com
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        kernel test robot <lkp@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang didn't recognize the instruction tlbilxlpid. This was fixed in
clang-18 [0] then backported to clang-17 [1].  To support clang-16 and
older, rather than using that instruction bare in inline asm, add it to
ppc-opcode.h and use that macro as is done elsewhere for other
instructions.

Link: https://github.com/ClangBuiltLinux/linux/issues/1891
Link: https://github.com/llvm/llvm-project/issues/64080
Link: https://github.com/llvm/llvm-project/commit/53648ac1d0c953ae6d008864dd2eddb437a92468 [0]
Link: https://github.com/llvm/llvm-project-release-prs/commit/0af7e5e54a8c7ac665773ac1ada328713e8338f5 [1]
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/llvm/202307211945.TSPcyOhh-lkp@intel.com/
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/powerpc/include/asm/ppc-opcode.h |  4 +++-
 arch/powerpc/kvm/e500mc.c             | 10 +++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index ef6972aa33b9..72f184e06bec 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -397,7 +397,8 @@
 #define PPC_RAW_RFCI			(0x4c000066)
 #define PPC_RAW_RFDI			(0x4c00004e)
 #define PPC_RAW_RFMCI			(0x4c00004c)
-#define PPC_RAW_TLBILX(t, a, b)		(0x7c000024 | __PPC_T_TLB(t) | 	__PPC_RA0(a) | __PPC_RB(b))
+#define PPC_RAW_TLBILX_LPID (0x7c000024)
+#define PPC_RAW_TLBILX(t, a, b)		(PPC_RAW_TLBILX_LPID | __PPC_T_TLB(t) | __PPC_RA0(a) | __PPC_RB(b))
 #define PPC_RAW_WAIT_v203		(0x7c00007c)
 #define PPC_RAW_WAIT(w, p)		(0x7c00003c | __PPC_WC(w) | __PPC_PL(p))
 #define PPC_RAW_TLBIE(lp, a)		(0x7c000264 | ___PPC_RB(a) | ___PPC_RS(lp))
@@ -616,6 +617,7 @@
 #define PPC_TLBILX(t, a, b)	stringify_in_c(.long PPC_RAW_TLBILX(t, a, b))
 #define PPC_TLBILX_ALL(a, b)	PPC_TLBILX(0, a, b)
 #define PPC_TLBILX_PID(a, b)	PPC_TLBILX(1, a, b)
+#define PPC_TLBILX_LPID		stringify_in_c(.long PPC_RAW_TLBILX_LPID)
 #define PPC_TLBILX_VA(a, b)	PPC_TLBILX(3, a, b)
 #define PPC_WAIT_v203		stringify_in_c(.long PPC_RAW_WAIT_v203)
 #define PPC_WAIT(w, p)		stringify_in_c(.long PPC_RAW_WAIT(w, p))
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index d58df71ace58..dc054b8b5032 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -16,10 +16,11 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 
-#include <asm/reg.h>
 #include <asm/cputable.h>
-#include <asm/kvm_ppc.h>
 #include <asm/dbell.h>
+#include <asm/kvm_ppc.h>
+#include <asm/ppc-opcode.h>
+#include <asm/reg.h>
 
 #include "booke.h"
 #include "e500.h"
@@ -92,7 +93,10 @@ void kvmppc_e500_tlbil_all(struct kvmppc_vcpu_e500 *vcpu_e500)
 
 	local_irq_save(flags);
 	mtspr(SPRN_MAS5, MAS5_SGS | get_lpid(&vcpu_e500->vcpu));
-	asm volatile("tlbilxlpid");
+	/* clang-17 and older could not assemble tlbilxlpid.
+	 * https://github.com/ClangBuiltLinux/linux/issues/1891
+	 */
+	asm volatile (PPC_TLBILX_LPID);
 	mtspr(SPRN_MAS5, 0);
 	local_irq_restore(flags);
 }

---
base-commit: 7bafbd4027ae86572f308c4ddf93120c90126332
change-id: 20230803-ppc_tlbilxlpid-cfdbf4fd4f7f

Best regards,
-- 
Nick Desaulniers <ndesaulniers@google.com>

