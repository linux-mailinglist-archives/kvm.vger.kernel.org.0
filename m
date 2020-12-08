Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45A2D1F14
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgLHAiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgLHAiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957F4C061257
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:32 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b2so15789275edm.3
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p4PZklhHw+Sb6s6FhLRnOXfQjuCQxkl6HaSQzV1xL0k=;
        b=AocFYn/OeGLM5fAC++aIXp7BCu8C9tkHnnrVydtHXjs6E9fqhW56MWeIdDpPSowXnh
         PV2RQSHQNoMECkD1X3IqwzibgIBqV+DAiBg6Zvx/m9a469QWHABV5DRTGfuSLIzIxBxw
         6oYo4MT19IbFUB6nLNTVsDhOkyVhlOpk02GGZe1vSBalHyHsNHtC0HuERHzFR1OcxgKZ
         Et/5gZ3Ndh5LjkIk1UJF52eeNIglF6cICMxjpI2FhxmOPFRIS9Sxwjmt/vTEIms5IyYi
         gjNnLCiZwTvYOVfD35TXWZLz5qZttQdB/gh8SfUYZjLomSLZdLKcJfIpW0Q8irzgXpmi
         n0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=p4PZklhHw+Sb6s6FhLRnOXfQjuCQxkl6HaSQzV1xL0k=;
        b=L0FYjXSJ43GJ8XfxfgKs3jWLgE2JFwK9Y/ZjYZIOD1bxldP1H58SsYbzzvoMr0bQcy
         B9n4Ka9NXRSVLJPvWpykRiEGguS6MDBP2P83m1uq468CNNVi3bZuzRNzYHeHjQwKcSy5
         /9MZygACItjxLKepgb38TkMFUUAjCRdOYW7xGAcaxKtzLEIzShR5p6s1cGfkzvbsRQZn
         dYqCCInZqapbeTj6SSvzggecQRUshLLPKWohOFHBzeUNuTZsaF9wKMS6E4MxljIY7jG2
         9ve5D1BkkaI4H3Dk0yTQXVvARfpG+6VFwnO+K7Y/LThW0XHVKKJWa5/HVptM9XQLqVk9
         nnLQ==
X-Gm-Message-State: AOAM530iM4aCECoMByZyw+taN2KhrYENxlcVl1PExYbo9vlw12k4SM5X
        6oIkwgWX01AzbLlqJhrsjoo=
X-Google-Smtp-Source: ABdhPJwAnXIX7aszxc3Sf9KqxOLgCmeV/WG207FQq1EpZP60tAeQRn9j0oicEGIuDOZQOGynRjz0dw==
X-Received: by 2002:aa7:d6c9:: with SMTP id x9mr21868250edr.96.1607387851347;
        Mon, 07 Dec 2020 16:37:31 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c12sm15438706edw.55.2020.12.07.16.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:30 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 05/17] target/mips: Remove now unused ASE_MSA definition
Date:   Tue,  8 Dec 2020 01:36:50 +0100
Message-Id: <20201208003702.4088927-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't use ASE_MSA anymore (replaced by ase_msa_available()
checking MSAP bit from CP0_Config3). Remove it.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/mips-defs.h          | 1 -
 target/mips/translate_init.c.inc | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index ed6a7a9e545..805034b8956 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -45,7 +45,6 @@
 #define ASE_MT            0x0000000040000000ULL
 #define ASE_SMARTMIPS     0x0000000080000000ULL
 #define ASE_MICROMIPS     0x0000000100000000ULL
-#define ASE_MSA           0x0000000200000000ULL
 /*
  *   bits 40-51: vendor-specific base instruction sets
  */
diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index 3c9ec7e940a..f6752d00afe 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -408,7 +408,7 @@ const mips_def_t mips_defs[] =
         .CP1_fcr31_rw_bitmask = 0xFF83FFFF,
         .SEGBITS = 32,
         .PABITS = 40,
-        .insn_flags = CPU_MIPS32R5 | ASE_MSA,
+        .insn_flags = CPU_MIPS32R5,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -721,7 +721,7 @@ const mips_def_t mips_defs[] =
         .MSAIR = 0x03 << MSAIR_ProcID,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_MIPS64R6 | ASE_MSA,
+        .insn_flags = CPU_MIPS64R6,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -761,7 +761,7 @@ const mips_def_t mips_defs[] =
         .MSAIR = 0x03 << MSAIR_ProcID,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_MIPS64R6 | ASE_MSA,
+        .insn_flags = CPU_MIPS64R6,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -887,7 +887,7 @@ const mips_def_t mips_defs[] =
         .CP1_fcr31_rw_bitmask = 0xFF83FFFF,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_LOONGSON3A | ASE_MSA,
+        .insn_flags = CPU_LOONGSON3A,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
-- 
2.26.2

