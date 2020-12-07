Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3708C2D1EAF
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgLGX5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgLGX5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:57:19 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF909C0611CA
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:56:19 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id u19so15718336edx.2
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LofNBqvfhJD7QMio6KgUUyNv6uzg7DeNQo+Q00jFE2I=;
        b=V9ilVV6lgZi5jEhrlvG5bq2qZJXihvu5Rap8Giuho5NcoVtx5wF8SVX7R4Ey+tF1Su
         0hoOTCMT7j1o0OMx9mW9IfkuYte9u0jH6Sl3ieuiPk3UCZYi2nO/0SDE+igNm/xf7qig
         hEnhJK5AKiXYDUUtUkcNZY5/ZCPHnxoDw+YcL4yF1ZUnGjlLKkL/sGSiMfWpyzFEhElU
         U9GKSif5LafjmunsEd34yIBvncKlWWiTRU1TGcTHicAa7LA1yfA/ld2PP9+rH4zjKmfP
         KLw4T3Nb8GyInwyRlLz4PGo5S/ArbykHuNRDyAaBb/A0QMLSrimVHtfdi3Qn/EEYn2D2
         Ko9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LofNBqvfhJD7QMio6KgUUyNv6uzg7DeNQo+Q00jFE2I=;
        b=ZzYFGNRc6+ZRy5/AZEAHEmorteG9KzRkVWpsMOPG2AcALri8lBcRVZO6JueBiL0DU5
         uu1nDbeDBk8t1nRsWBljUVpkUkPp/81gv/7J+ucINFxHcQVOecBLpgNQl1ZMguhtWqCM
         eW3TZTFSx0B55wAu/qFW+kX3GsPjJPrcRLXho07h7lZ+JGo8ISj5pWvvcJS6dWK/hO1M
         ZbqzW83j9CJdWeZoCBjJAnFWTnl5bcf+gh/y8ZmSXJUtrkAEzcaPGSk12n5Ae+g3d1BW
         n8hPlvlCPyxrF9JOD9RxmuTa2+qrOZE7rELi6t+3oa6Jz7tvoOnKaA7c+LnjmVWvdyVb
         pq4g==
X-Gm-Message-State: AOAM532GLGxD3rmpK+UrVelhuJUVZc+LnFKffeRylSLXXWDta8nR2Mg9
        m6WOCuOkPLdGh5ZD7JgH/YI=
X-Google-Smtp-Source: ABdhPJwo8rv3t94SKHKrlVXonC6gHX8VzFqw2MORP0+FE3StHXSMzEuPYYvfdr6q9EXqMExEOcmGJw==
X-Received: by 2002:a05:6402:ca1:: with SMTP id cn1mr13404929edb.128.1607385378434;
        Mon, 07 Dec 2020 15:56:18 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id o3sm15757759edj.41.2020.12.07.15.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:56:17 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 7/7] target/mips: Extract FPU specific definitions to fpu_translate.h
Date:   Tue,  8 Dec 2020 00:55:39 +0100
Message-Id: <20201207235539.4070364-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207235539.4070364-1-f4bug@amsat.org>
References: <20201207235539.4070364-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract FPU specific definitions that can be used by
ISA / ASE / extensions to fpu_translate.h header.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/fpu_translate.h | 71 +++++++++++++++++++++++++++++++++++++
 target/mips/translate.c     | 70 ------------------------------------
 2 files changed, 71 insertions(+), 70 deletions(-)

diff --git a/target/mips/fpu_translate.h b/target/mips/fpu_translate.h
index 430e0b77537..f45314d2ec2 100644
--- a/target/mips/fpu_translate.h
+++ b/target/mips/fpu_translate.h
@@ -12,6 +12,77 @@
 #include "exec/translator.h"
 #include "translate.h"
 
+#define OPC_CP1 (0x11 << 26)
+
+/* Coprocessor 1 (rs field) */
+#define MASK_CP1(op)                (MASK_OP_MAJOR(op) | (op & (0x1F << 21)))
+
+/* Values for the fmt field in FP instructions */
+enum {
+    /* 0 - 15 are reserved */
+    FMT_S = 16,          /* single fp */
+    FMT_D = 17,          /* double fp */
+    FMT_E = 18,          /* extended fp */
+    FMT_Q = 19,          /* quad fp */
+    FMT_W = 20,          /* 32-bit fixed */
+    FMT_L = 21,          /* 64-bit fixed */
+    FMT_PS = 22,         /* paired single fp */
+    /* 23 - 31 are reserved */
+};
+
+enum {
+    OPC_MFC1     = (0x00 << 21) | OPC_CP1,
+    OPC_DMFC1    = (0x01 << 21) | OPC_CP1,
+    OPC_CFC1     = (0x02 << 21) | OPC_CP1,
+    OPC_MFHC1    = (0x03 << 21) | OPC_CP1,
+    OPC_MTC1     = (0x04 << 21) | OPC_CP1,
+    OPC_DMTC1    = (0x05 << 21) | OPC_CP1,
+    OPC_CTC1     = (0x06 << 21) | OPC_CP1,
+    OPC_MTHC1    = (0x07 << 21) | OPC_CP1,
+    OPC_BC1      = (0x08 << 21) | OPC_CP1, /* bc */
+    OPC_BC1ANY2  = (0x09 << 21) | OPC_CP1,
+    OPC_BC1ANY4  = (0x0A << 21) | OPC_CP1,
+    OPC_BZ_V     = (0x0B << 21) | OPC_CP1,
+    OPC_BNZ_V    = (0x0F << 21) | OPC_CP1,
+    OPC_S_FMT    = (FMT_S << 21) | OPC_CP1,
+    OPC_D_FMT    = (FMT_D << 21) | OPC_CP1,
+    OPC_E_FMT    = (FMT_E << 21) | OPC_CP1,
+    OPC_Q_FMT    = (FMT_Q << 21) | OPC_CP1,
+    OPC_W_FMT    = (FMT_W << 21) | OPC_CP1,
+    OPC_L_FMT    = (FMT_L << 21) | OPC_CP1,
+    OPC_PS_FMT   = (FMT_PS << 21) | OPC_CP1,
+    OPC_BC1EQZ   = (0x09 << 21) | OPC_CP1,
+    OPC_BC1NEZ   = (0x0D << 21) | OPC_CP1,
+    OPC_BZ_B     = (0x18 << 21) | OPC_CP1,
+    OPC_BZ_H     = (0x19 << 21) | OPC_CP1,
+    OPC_BZ_W     = (0x1A << 21) | OPC_CP1,
+    OPC_BZ_D     = (0x1B << 21) | OPC_CP1,
+    OPC_BNZ_B    = (0x1C << 21) | OPC_CP1,
+    OPC_BNZ_H    = (0x1D << 21) | OPC_CP1,
+    OPC_BNZ_W    = (0x1E << 21) | OPC_CP1,
+    OPC_BNZ_D    = (0x1F << 21) | OPC_CP1,
+};
+
+#define MASK_CP1_FUNC(op)           (MASK_CP1(op) | (op & 0x3F))
+#define MASK_BC1(op)                (MASK_CP1(op) | (op & (0x3 << 16)))
+
+enum {
+    OPC_BC1F     = (0x00 << 16) | OPC_BC1,
+    OPC_BC1T     = (0x01 << 16) | OPC_BC1,
+    OPC_BC1FL    = (0x02 << 16) | OPC_BC1,
+    OPC_BC1TL    = (0x03 << 16) | OPC_BC1,
+};
+
+enum {
+    OPC_BC1FANY2     = (0x00 << 16) | OPC_BC1ANY2,
+    OPC_BC1TANY2     = (0x01 << 16) | OPC_BC1ANY2,
+};
+
+enum {
+    OPC_BC1FANY4     = (0x00 << 16) | OPC_BC1ANY4,
+    OPC_BC1TANY4     = (0x01 << 16) | OPC_BC1ANY4,
+};
+
 extern TCGv_i32 fpu_fcr0, fpu_fcr31;
 extern TCGv_i64 fpu_f64[32];
 
diff --git a/target/mips/translate.c b/target/mips/translate.c
index bc54eb58c70..80c9c17819f 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -49,7 +49,6 @@ enum {
     OPC_SPECIAL  = (0x00 << 26),
     OPC_REGIMM   = (0x01 << 26),
     OPC_CP0      = (0x10 << 26),
-    OPC_CP1      = (0x11 << 26),
     OPC_CP2      = (0x12 << 26),
     OPC_CP3      = (0x13 << 26),
     OPC_SPECIAL2 = (0x1C << 26),
@@ -1002,75 +1001,6 @@ enum {
     OPC_WAIT     = 0x20 | OPC_C0,
 };
 
-/* Coprocessor 1 (rs field) */
-#define MASK_CP1(op)                (MASK_OP_MAJOR(op) | (op & (0x1F << 21)))
-
-/* Values for the fmt field in FP instructions */
-enum {
-    /* 0 - 15 are reserved */
-    FMT_S = 16,          /* single fp */
-    FMT_D = 17,          /* double fp */
-    FMT_E = 18,          /* extended fp */
-    FMT_Q = 19,          /* quad fp */
-    FMT_W = 20,          /* 32-bit fixed */
-    FMT_L = 21,          /* 64-bit fixed */
-    FMT_PS = 22,         /* paired single fp */
-    /* 23 - 31 are reserved */
-};
-
-enum {
-    OPC_MFC1     = (0x00 << 21) | OPC_CP1,
-    OPC_DMFC1    = (0x01 << 21) | OPC_CP1,
-    OPC_CFC1     = (0x02 << 21) | OPC_CP1,
-    OPC_MFHC1    = (0x03 << 21) | OPC_CP1,
-    OPC_MTC1     = (0x04 << 21) | OPC_CP1,
-    OPC_DMTC1    = (0x05 << 21) | OPC_CP1,
-    OPC_CTC1     = (0x06 << 21) | OPC_CP1,
-    OPC_MTHC1    = (0x07 << 21) | OPC_CP1,
-    OPC_BC1      = (0x08 << 21) | OPC_CP1, /* bc */
-    OPC_BC1ANY2  = (0x09 << 21) | OPC_CP1,
-    OPC_BC1ANY4  = (0x0A << 21) | OPC_CP1,
-    OPC_BZ_V     = (0x0B << 21) | OPC_CP1,
-    OPC_BNZ_V    = (0x0F << 21) | OPC_CP1,
-    OPC_S_FMT    = (FMT_S << 21) | OPC_CP1,
-    OPC_D_FMT    = (FMT_D << 21) | OPC_CP1,
-    OPC_E_FMT    = (FMT_E << 21) | OPC_CP1,
-    OPC_Q_FMT    = (FMT_Q << 21) | OPC_CP1,
-    OPC_W_FMT    = (FMT_W << 21) | OPC_CP1,
-    OPC_L_FMT    = (FMT_L << 21) | OPC_CP1,
-    OPC_PS_FMT   = (FMT_PS << 21) | OPC_CP1,
-    OPC_BC1EQZ   = (0x09 << 21) | OPC_CP1,
-    OPC_BC1NEZ   = (0x0D << 21) | OPC_CP1,
-    OPC_BZ_B     = (0x18 << 21) | OPC_CP1,
-    OPC_BZ_H     = (0x19 << 21) | OPC_CP1,
-    OPC_BZ_W     = (0x1A << 21) | OPC_CP1,
-    OPC_BZ_D     = (0x1B << 21) | OPC_CP1,
-    OPC_BNZ_B    = (0x1C << 21) | OPC_CP1,
-    OPC_BNZ_H    = (0x1D << 21) | OPC_CP1,
-    OPC_BNZ_W    = (0x1E << 21) | OPC_CP1,
-    OPC_BNZ_D    = (0x1F << 21) | OPC_CP1,
-};
-
-#define MASK_CP1_FUNC(op)           (MASK_CP1(op) | (op & 0x3F))
-#define MASK_BC1(op)                (MASK_CP1(op) | (op & (0x3 << 16)))
-
-enum {
-    OPC_BC1F     = (0x00 << 16) | OPC_BC1,
-    OPC_BC1T     = (0x01 << 16) | OPC_BC1,
-    OPC_BC1FL    = (0x02 << 16) | OPC_BC1,
-    OPC_BC1TL    = (0x03 << 16) | OPC_BC1,
-};
-
-enum {
-    OPC_BC1FANY2     = (0x00 << 16) | OPC_BC1ANY2,
-    OPC_BC1TANY2     = (0x01 << 16) | OPC_BC1ANY2,
-};
-
-enum {
-    OPC_BC1FANY4     = (0x00 << 16) | OPC_BC1ANY4,
-    OPC_BC1TANY4     = (0x01 << 16) | OPC_BC1ANY4,
-};
-
 #define MASK_CP2(op)                (MASK_OP_MAJOR(op) | (op & (0x1F << 21)))
 
 enum {
-- 
2.26.2

