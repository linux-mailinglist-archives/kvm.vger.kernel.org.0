Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CFE6BE86C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjCQLjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCQLi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:38:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2DAC97FB
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:23 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cn6so4792821pjb.2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053087;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7nse4H651gQWwjvfzxuALEV9PWCwDtW7Vpp5QzRUQkA=;
        b=KAJhzfoxouXhNmh0BnXcUeZzTs5NSiUJQMo1bTi4zg4ppXg2UPO0WxbHxP8DljsfXl
         d7ucZh+9Q7FJhsOArs9/u+ulxMpThUs/OvczGoUnzimq90pJX/YvQ7k5JCQfR1kNrOFq
         xzEhUVFRNgBZ6h2IN+NjHKnuBj0ApSNXYadrvVYeQLcqzMMILyaCjswPyFNpsnrD3gVB
         UUOQsxNVqGEr2f9TArWBY68ygO6Eic+F1OR6fVQCtJ1qdzzm9+YL0RDXN6sdwH16johl
         aAJ0qd3FolMzPuyNbO5iomX52JVZ2fLDRIm5zNtsUn7cPrBAIfIomd1OqvRmOFdlzpkL
         4zKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053087;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7nse4H651gQWwjvfzxuALEV9PWCwDtW7Vpp5QzRUQkA=;
        b=bPnjAaFtDf1f70VoE4rD4tptgy3oa2BgBsPWl7xfj1Yayp4aiKuGoo6HG3USalayOD
         DPBi73wnSnwbZEFlcooVjOfqEeRRZy74nZcXJtnK8YBaVfbfu+JMlCsqK9/4nDmA/teE
         2j5ATGcxjQOaXE6WLv0k4MuZn4xNBI/JCq1qAWD8SEBq8BaurDjKn+yrhVTOPlw9OH48
         9KlPoopYOE2SQmcfFt0F1VsqcxxhOygK1ovDSHo88DYwkXod0DT44/VoJafFHnihJ1Qk
         aw/Qe31SFMyskEcHxl/1naH7qdhgfhqxLiAECOA0kckNubz21GJ2fyTaItPHjUA+XH5k
         Na6Q==
X-Gm-Message-State: AO0yUKWX2wUdBoECRnizcPeUEEC9NXKm+5O4kqSN6wngKMEWCa4lCqMb
        4X1R9S48RNw4Oi4K0vOOIW76aA==
X-Google-Smtp-Source: AK7set9d9gXmb6m6eq9N88b1+NY1wOjkacSI7ZS9r8acOoqbX8Z+nye5qbASkA+KMYYjEtVhjDnjvg==
X-Received: by 2002:a17:90b:388d:b0:23d:1948:6681 with SMTP id mu13-20020a17090b388d00b0023d19486681mr8142191pjb.39.1679053087270;
        Fri, 17 Mar 2023 04:38:07 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:38:06 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH -next v15 19/19] riscv: Enable Vector code to be built
Date:   Fri, 17 Mar 2023 11:35:38 +0000
Message-Id: <20230317113538.10878-20-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

This patch adds a config which enables vector feature from the kernel
space.

Support for RISC_V_ISA_V is limited to GNU-assembler for now, as LLVM
has not acquired the functionality to selectively change the arch option
in assembly code. This is still under review at
    https://reviews.llvm.org/D123515

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
Suggested-by: Atish Patra <atishp@atishpatra.org>
Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/Kconfig  | 20 ++++++++++++++++++++
 arch/riscv/Makefile |  6 +++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index c736dc8e2593..bf9aba2f2811 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -436,6 +436,26 @@ config RISCV_ISA_SVPBMT
 
 	   If you don't know what to do here, say Y.
 
+config TOOLCHAIN_HAS_V
+	bool
+	default y
+	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64iv)
+	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32iv)
+	depends on LLD_VERSION >= 140000 || LD_VERSION >= 23800
+	depends on AS_IS_GNU
+
+config RISCV_ISA_V
+	bool "VECTOR extension support"
+	depends on TOOLCHAIN_HAS_V
+	depends on FPU
+	select DYNAMIC_SIGFRAME
+	default y
+	help
+	  Say N here if you want to disable all vector related procedure
+	  in the kernel.
+
+	  If you don't know what to do here, say Y.
+
 config TOOLCHAIN_HAS_ZBB
 	bool
 	default y
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 6203c3378922..84a50cfaedf9 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -56,6 +56,7 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+riscv-march-$(CONFIG_RISCV_ISA_V)	:= $(riscv-march-y)v
 
 # Newer binutils versions default to ISA spec version 20191213 which moves some
 # instructions from the I extension to the Zicsr and Zifencei extensions.
@@ -65,7 +66,10 @@ riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
 # Check if the toolchain supports Zihintpause extension
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause
 
-KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
+# Remove F,D,V from isa string for all. Keep extensions between "fd" and "v" by
+# keep non-v and multi-letter extensions out with the filter ([^v_]*)
+KBUILD_CFLAGS += -march=$(shell echo $(riscv-march-y) | sed  -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
 KBUILD_CFLAGS += -mno-save-restore
-- 
2.17.1

