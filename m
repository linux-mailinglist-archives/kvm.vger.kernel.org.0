Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0097085DE
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjERQUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjERQUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:20:34 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234DF1708
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:30 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso115909b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426829; x=1687018829;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UCneMDdINnXxGFonqkgOoODJ+YC49qYwF4COaw1Z14o=;
        b=GUxVbM4pzCCxfmJ1sLQJe45OkM/xPmw8ia4snr3DB9rSBBUbWxqdqg5SGaL3gt8QPN
         BNIPca9Jfoopz4JHgr0zUAv7BuNZE6UkJwsmqwjiehqioQCh2wxQHM2PKymqk9ucIfqE
         61abNkeWmBu+m9qNDu3FgPK+y05UuYLDbz+y+l8CuMwLrMscJ1d8c8kfyXQDct5UooUy
         Swtwk8CLKzJkzePV67fpwq3acbGHNarB3PUhB1Zq4dab2VM43eocYiXeyJe2dqBmcXJx
         YjyZy/gSP6Lvcg5hPqHFdXLOD3ylpmIN+/56R7P0ukMm4/JIshLodNko0ZRdEoWYTTxQ
         4cug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426829; x=1687018829;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCneMDdINnXxGFonqkgOoODJ+YC49qYwF4COaw1Z14o=;
        b=dWEiRig8DdMukCykX1kC4e3ivEfdz8Wwzbv+mf2otd40en3AP7HO2Ws+jCOhBerh4L
         xHOxqzDz+OCYhqJ0walFUf9Q+eZxi1i5fAYCAUdcsuZXRPbVVcxrI/Fh/lSgWx8P7NbM
         c+CAM3vkoU6SeW+YBhIyLXfd2I3e3e3bpTi1lW1z7rIjsPkMofgkMlKATcFjVt+yyF20
         UP6N5/LAIdOUe06auaUeJqBOrGHC9rcPlKrkLoYXDwBPtzkgQYabnHZf++kZ4zVZyPq1
         v0J4UGsgP9GweTzMSXYpBniKk+zd02aLAcOgcaa5Ms15gH7OsSEO8tkHbPXU1XiunRxJ
         FNoQ==
X-Gm-Message-State: AC+VfDwsC0yVbl5JYng6c0O5sWOoD8MPhxTCB0J6GH8TcQqGITC+OANh
        0HrrbHcYsCPixe02ZpW8qQNIrKmrfM80AxaFLz+1Gg==
X-Google-Smtp-Source: ACHHUZ4gHnZwEo4v5N/LppQGYlH/FEjfcRk20N94BNcL2iprlv2xnz7gkTmTs7GcCM6dtPmNeMDIqQ==
X-Received: by 2002:aa7:8885:0:b0:643:59ed:5dc9 with SMTP id z5-20020aa78885000000b0064359ed5dc9mr5814862pfe.12.1684426829473;
        Thu, 18 May 2023 09:20:29 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:20:28 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Evan Green <evan@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Celeste Liu <coelacanthus@outlook.com>
Subject: [PATCH -next v20 03/26] riscv: hwprobe: Add support for probing V in RISCV_HWPROBE_KEY_IMA_EXT_0
Date:   Thu, 18 May 2023 16:19:26 +0000
Message-Id: <20230518161949.11203-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Probing kernel support for Vector extension is available now. This only
add detection for V only. Extenions like Zvfh, Zk are not in this scope.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
Changelog v20:
 - Fix a typo in document, and remove duplicated probes (Heiko)
 - probe V extension in RISCV_HWPROBE_KEY_IMA_EXT_0 key only (Palmer,
   Evan)
---
 Documentation/riscv/hwprobe.rst       | 3 +++
 arch/riscv/include/uapi/asm/hwprobe.h | 1 +
 arch/riscv/kernel/sys_riscv.c         | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
index 9f0dd62dcb5d..7431d9d01c73 100644
--- a/Documentation/riscv/hwprobe.rst
+++ b/Documentation/riscv/hwprobe.rst
@@ -64,6 +64,9 @@ The following keys are defined:
   * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
     by version 2.2 of the RISC-V ISA manual.
 
+  * :c:macro:`RISCV_HWPROBE_IMA_V`: The V extension is supported, as defined by
+    version 1.0 of the RISC-V Vector extension manual.
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 8d745a4ad8a2..7c6fdcf7ced5 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -25,6 +25,7 @@ struct riscv_hwprobe {
 #define RISCV_HWPROBE_KEY_IMA_EXT_0	4
 #define		RISCV_HWPROBE_IMA_FD		(1 << 0)
 #define		RISCV_HWPROBE_IMA_C		(1 << 1)
+#define		RISCV_HWPROBE_IMA_V		(1 << 2)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 5db29683ebee..88357a848797 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -10,6 +10,7 @@
 #include <asm/cpufeature.h>
 #include <asm/hwprobe.h>
 #include <asm/sbi.h>
+#include <asm/vector.h>
 #include <asm/switch_to.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -171,6 +172,9 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
 		if (riscv_isa_extension_available(NULL, c))
 			pair->value |= RISCV_HWPROBE_IMA_C;
 
+		if (has_vector())
+			pair->value |= RISCV_HWPROBE_IMA_V;
+
 		break;
 
 	case RISCV_HWPROBE_KEY_CPUPERF_0:
-- 
2.17.1

