Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0A46FC401
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbjEIKeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbjEIKdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:33:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5EA106FF
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:33:30 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64115e652eeso41451460b3a.0
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628408; x=1686220408;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tnXXiygjZrZ2nYQZcu1XSE2OAbXCB6jkIWrGS8Lz/3Q=;
        b=IR3iXP3SDmxJ/rPrizGRos8/ObgSjWdTQdkW3fRxoUTzbLKnjqc6Oxcb4DF3Izln/H
         8AZCqVbmImpoC/l8GrCzcLTxwa9Yj0xuj7D7Mz92ec7BjELInCJJy4gTVvUyxRezuR9M
         zECoLoEU7mNOq/xHSu1cs2GlytbDOJ99vYIq6fKDvMMPITHlthy/2Etb1HKrvQbZKfH7
         zNqNIAuNfFLRuuOdHiRmq5X7sKkq7aQVhUSPztHNLZzAyXBFv/pLq5Ti0KZzSlajA2x8
         +a1PoFgQDzIMM2X1ZE5rNn3sm4MsTMxGs4F+tCatjRS79wZfXqrM4xL0Q3Havcq/b5nO
         oPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628408; x=1686220408;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnXXiygjZrZ2nYQZcu1XSE2OAbXCB6jkIWrGS8Lz/3Q=;
        b=Jf8oviBeyyrDaDZjOhoMO3/YyMvwHvy7r36ELwI+RSjS3EJB+L8EGHOCzFgREf/fVv
         DLHkgFdMdwaeKr5IZlW0WGZ51Mm2Z+nJjMk7xoJRBjhh5ygCtwd7SUVdPKNzfJ68QQvO
         IJOgvmxvraOLwpMpqYw5V4TH0lNwm+ZdBcRxP+/lOZowi1s7sn7SqsTe8sVGf+SLVYNX
         b2ZdKNs/ZDkz4ZqNTi/eIaB3gV6PWCkMxo+1l+B52XEaMvxVwNgso6udxMtMMHtDXhJ8
         qUy5a24EmO0yxh2skQuda+nKPN9PjBnifrnBdtEDR5EtG4FZ0dxAc4KPlNA6R1Kl8he/
         yHyg==
X-Gm-Message-State: AC+VfDyCU+WmR7o2XFU9/wyUgazQABfPZ6YI0PLxNIMvV4ydE6Y1v2Ch
        7QzSqL2zU6Osdq15usIm2yXWaNkeh32nNw2DwGM=
X-Google-Smtp-Source: ACHHUZ5H9al3o7R9DVJ8noKHqXN/Z6PK0n9zsnGfLVf4cZOf/4z90B0NyME5n2HJdo21x+D4YU0/wg==
X-Received: by 2002:a17:902:d505:b0:1a6:f93a:a136 with SMTP id b5-20020a170902d50500b001a6f93aa136mr22651724plg.22.1683628408433;
        Tue, 09 May 2023 03:33:28 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:33:27 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v19 23/24] riscv: Enable Vector code to be built
Date:   Tue,  9 May 2023 10:30:32 +0000
Message-Id: <20230509103033.11285-24-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

This patch adds a config which enables vector feature from the kernel
space.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
Suggested-by: Atish Patra <atishp@atishpatra.org>
Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
Changelog V19:
 - Add RISCV_V_DISABLE to set compile-time default.

 arch/riscv/Kconfig  | 31 +++++++++++++++++++++++++++++++
 arch/riscv/Makefile |  6 +++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 1019b519d590..fa256f2e23c1 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -466,6 +466,37 @@ config RISCV_ISA_SVPBMT
 
 	   If you don't know what to do here, say Y.
 
+config TOOLCHAIN_HAS_V
+	bool
+	default y
+	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64iv)
+	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32iv)
+	depends on LLD_VERSION >= 140000 || LD_VERSION >= 23800
+	depends on AS_HAS_OPTION_ARCH
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
+config RISCV_V_DISABLE
+	bool "Disable userspace Vector by default"
+	depends on RISCV_ISA_V
+	default n
+	help
+	  Say Y here if you want to disable default enablement state of Vector
+	  in u-mode. This way userspace has to make explicit prctl() call to
+	  enable Vector, or enable it via sysctl interface.
+
+	  If you don't know what to do here, say N.
+
 config TOOLCHAIN_HAS_ZBB
 	bool
 	default y
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 0fb256bf8270..6ec6d52a4180 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -60,6 +60,7 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+riscv-march-$(CONFIG_RISCV_ISA_V)	:= $(riscv-march-y)v
 
 ifdef CONFIG_TOOLCHAIN_NEEDS_OLD_ISA_SPEC
 KBUILD_CFLAGS += -Wa,-misa-spec=2.2
@@ -71,7 +72,10 @@ endif
 # Check if the toolchain supports Zihintpause extension
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause
 
-KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
+# Remove F,D,V from isa string for all. Keep extensions between "fd" and "v" by
+# matching non-v and non-multi-letter extensions out with the filter ([^v_]*)
+KBUILD_CFLAGS += -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
 KBUILD_CFLAGS += -mno-save-restore
-- 
2.17.1

