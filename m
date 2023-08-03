Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFEE76F0B1
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 19:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbjHCRdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 13:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbjHCRdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 13:33:39 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCACA3AA0
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 10:33:32 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5734d919156so13155557b3.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 10:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691084012; x=1691688812;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0pu/AbS0HKjXzXWiPYnMLO2Amc72EsgDe6tRMstBdak=;
        b=KC193m6YkfKMgU1V5pk0nLnwEMaKH+pCPxR6oyeWGiIkaM4A2w8Pp69NstZno0wmB1
         ZDjO/BuWqE7adFEoyq3k08am+VD+HDLkdlXGSfaOrrWJLfoTTrC8zC2MD/8zr3IwpcGS
         o72PCx2btOf54qsSVe5aRfxxbauOWdb1xXriKdpgIWMYv8OxBaHbQe3OkHX+1ExgQT45
         4fi2EEVVuwEfD4HoT72VhlIbFGq1san8AhAwlOpsM/inO6HtwB2deOg08vibUNXNZbAS
         PKBRwsPLy2Rp5beitfEyzkusmkTZvL9/MuWg+1nxQ2xObOdCIZbE25I+cpJg67GqrUbV
         EF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691084012; x=1691688812;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pu/AbS0HKjXzXWiPYnMLO2Amc72EsgDe6tRMstBdak=;
        b=PQxw4yO4ZQWjFGRUHelRXtFRHFjAbLl3/gpzbCIsKi/RMMrUOlCsP34nOt4e28zthW
         EnERuhGpt82sYNBG+P77ujM+B2+uLqCFyoIuP05h9jFjpDm8kLy5hByUBYKsWzYgICpL
         XsLvthUHnp2JLveMLCgONZj9dnZKqwZqOjUHzTeUt7tyMcDvMaWg5PtHHQ+8dDESRbil
         lU5wDMuBoK3zejusLmivXeoOLIVJohsCynd555jAvzBKt+o/xvU5Pnj1k0i8+rCGfez4
         kjWHPGvpZ/2nHY/OH3cDeOCxyRgL5fkJQgoHUvFAJ/uCnLHvbu5mFvzCZmu6zEhP22Q9
         Wn/Q==
X-Gm-Message-State: ABy/qLZUPY7tX68AfGxLvH8hZG7HsmYzYkN86ZYbck5fhzdPqqrg68S/
        CNA7HBKVdprFFmx8PMXe/nRch2Rb8BVRqIca8+Q=
X-Google-Smtp-Source: APBJJlEJdivYv8+b0csxVKGpKeftEtW6vp2C3Qo3RNq++FnZzd8sjOXFBRON9kXJ/6W7O/EGTSqXhU2ZwUIF7yQaems=
X-Received: from ndesaulniers-desktop.svl.corp.google.com ([2620:15c:2d1:203:cd2a:c126:8d90:d5ab])
 (user=ndesaulniers job=sendgmr) by 2002:a81:b646:0:b0:569:e04a:238f with SMTP
 id h6-20020a81b646000000b00569e04a238fmr187846ywk.4.1691084012010; Thu, 03
 Aug 2023 10:33:32 -0700 (PDT)
Date:   Thu, 03 Aug 2023 10:33:27 -0700
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAObky2QC/3WNQQ6CMBBFr2JmbQ0FVHTlPQwx7XQKkxTatIRgC
 He3sHf5/s/LWyFRZErwPK0QaebEfsxQnk+AvRo7EmwyQ1mUVdEUlQgBP5PT7BYX2Ai0Rtvamtr
 eLWRJq0RCRzViv2uDShPF/QiRLC9H6d1m7jlNPn6P8Cz39W9jlkKKplZS4xXt41a9Ou87Rxf0A 7Tbtv0Aeg6LYsYAAAA=
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=UIrHvErwpgNbhCkRZAYSX0CFd/XFEwqX3D0xqtqjNug=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691084010; l=3497;
 i=ndesaulniers@google.com; s=20220923; h=from:subject:message-id;
 bh=67hlOu38BB7CQZwIwTCku7kE6/CaycFqUpDIAeyUINw=; b=bEhP7KO3a79AFAV5eK8xUw0gGcjsqOcYWQS5seKyBUjoRQ1L5F0wGAVdqGIdML0+QnIFkiFCZ
 aVyNKTTHEi8Bvs5TOuBZ3doktaLzVfwNxT210gHDiu1vK3zkunVW0w1
X-Mailer: b4 0.12.3
Message-ID: <20230803-ppc_tlbilxlpid-v2-1-211ffa1df194@google.com>
Subject: [PATCH v2] powerpc/inst: add PPC_TLBILX_LPID
From:   Nick Desaulniers <ndesaulniers@google.com>
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
Changes in v2:
- add 2 missing tabs to PPC_RAW_TLBILX_LPID
- Link to v1: https://lore.kernel.org/r/20230803-ppc_tlbilxlpid-v1-1-84a1bc5cf963@google.com
---
 arch/powerpc/include/asm/ppc-opcode.h |  4 +++-
 arch/powerpc/kvm/e500mc.c             | 10 +++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index ef6972aa33b9..f37d8d8cbec6 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -397,7 +397,8 @@
 #define PPC_RAW_RFCI			(0x4c000066)
 #define PPC_RAW_RFDI			(0x4c00004e)
 #define PPC_RAW_RFMCI			(0x4c00004c)
-#define PPC_RAW_TLBILX(t, a, b)		(0x7c000024 | __PPC_T_TLB(t) | 	__PPC_RA0(a) | __PPC_RB(b))
+#define PPC_RAW_TLBILX_LPID		(0x7c000024)
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

