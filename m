Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FED76E27E2
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjDNQBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjDNQBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:01:06 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B04A276
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z11-20020a17090abd8b00b0024721c47ceaso5101904pjr.3
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681488048; x=1684080048;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E9XECObCyZpUedK9knyGwZy3BMqflVOS6gxHGxGLKTE=;
        b=gkc5s6HPzym+RHUm++bVdfv9jb1/AkXmpyekQHGNyDGRRDRYGjsm+T5pPdbkIedgdV
         ZFQ6LrmUfO+1WkSx2IgoF4ZBZCNi62pkkDd2LecWTiR0dGThihYtuuKD3qAYYgyp4scN
         6dSaca2jMax/dpE1eRXkip1mPWJVjhnFxU4OsG9dCgtR/38nce7UO6rc31M/0niyugTY
         OGZBDUSrCItNQk5ZhcxqJNi+vl4rQPEd4dLts6y+fkwyPmztt2QGc3F1zJKebU4pVnFG
         0z5VwwXgPyU4CL8P1dX+GDezKB2ciU51Yp3dyrXKzingm/2BiEBojiIbxgZVrF+8FpuD
         77VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681488048; x=1684080048;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9XECObCyZpUedK9knyGwZy3BMqflVOS6gxHGxGLKTE=;
        b=l1rVzpvZHxeQUq+IzGyZ7Zd6ZKaQwJKasbjul10B7VropxBbIfV8xnesZR77FLlsgq
         yuczfHos+7Mf9Q89/TyMb2HaMa+28N/AOyVAv8Fn8JsmDNYZGwxQcvTeK6lcfsqfLxCL
         Trp/CZySl8NK597Gn4fnbPY7hTwaRKdhP1TfR4hI3cMdJE5eIJBkxQUh9ABiE9QHbtm1
         ac5Vg0LNEgXXOlbG2BYWRfSIzBsHsaDl0Q8WJdyBJ1I2hpPBNTiv4bpfPsUzf0rANZpw
         zRsBSDjsrO5TQsgZfsdIAeEz43ZmaqClek6/OdhF8sSIdRKS4TCIdTu+bAU0N1j1VVQ1
         fqgQ==
X-Gm-Message-State: AAQBX9eFLvDvtu0vu/V79kMon5lhwX5g+9iowj6/Cw7bSz/4vmjr7j9s
        8fn92WNHsRervm0TMNT6ZjbFTw==
X-Google-Smtp-Source: AKy350bAtaGvhnaI4rhSGJ+v1XE5PL7wflyiii5/XGq5ELK2D7RWeVxXUPMbdb1aQIpE7CzaET8gZQ==
X-Received: by 2002:a17:90b:f0a:b0:23f:582d:f45f with SMTP id br10-20020a17090b0f0a00b0023f582df45fmr5745324pjb.1.1681488047968;
        Fri, 14 Apr 2023 09:00:47 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.09.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:00:47 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v18 20/20] riscv: Enable Vector code to be built
Date:   Fri, 14 Apr 2023 15:58:43 +0000
Message-Id: <20230414155843.12963-21-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230414155843.12963-1-andy.chiu@sifive.com>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/Kconfig  | 20 ++++++++++++++++++++
 arch/riscv/Makefile |  6 +++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 205ce6e009a2..5edfc545aafd 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -442,6 +442,26 @@ config RISCV_ISA_SVPBMT
 
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
 config TOOLCHAIN_HAS_ZBB
 	bool
 	default y
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 1b276f62f22b..94684dbe3b36 100644
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
+# matching non-v and non-multi-letter extensions out with the filter ([^v_]*)
+KBUILD_CFLAGS += -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
 KBUILD_CFLAGS += -mno-save-restore
-- 
2.17.1

