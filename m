Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFB6708601
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjERQW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjERQW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:22:57 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55BC130
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:34 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d2b42a8f9so211068b3a.3
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426947; x=1687018947;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b1b0xsw8eifEcqL65SiaBPERh4ugWqVSP6XmDavWWMY=;
        b=Bu4ilTdIWMMLwOpy8XcilklIFvmsG1OLuzriOCTkzbwfTbqiNCEtaBOhxbztiyfwBt
         CjgHcX+6xdognvyr8lvQr2KMYLXtUuXQITKj2rzHK1dNcc8lzlqwzC5RRbA7HHfDX3eT
         Kre9Fg0TQW7jwPTdwt5kOtnYMCa8JQpx8J5ZfIMuWgpmuMAwh8BOrpYliGHVT4ZIkWze
         JB3W3ALQUJLceu6qiy/n1YkCe538v+FxM87UuRBPcmm/gbmpK9w9wiDu4+yP0GDLqTZ1
         b2zmmu3IiCEJiJ1dN71Og53pP9cypGH7kXje3Jx3lyeU4NYBucj7SKB367wODjVB9d2Y
         vqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426947; x=1687018947;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b1b0xsw8eifEcqL65SiaBPERh4ugWqVSP6XmDavWWMY=;
        b=Fhr4qeBcZ9LWitlZkWqAn7Res8eM7jw+0PCdY3z2BSMEi4JyV/+/TKAs0tC59n0U3Y
         Z0tBCHBMWSnWeWG67LxfqHBVgJ01JQ75KzfuaDsLI04ZEbAc24HH46BizLQEkfq/IMMD
         LBpm/UFt9SW8JYjcEEPExuorTg5cA79G3MwHpUujIutgPP3KSFG+s1/cD6JGhVGsy384
         s5g62hDx1OSdc+eN+wcLuc/KYUgln3wNAjJcHuAoeVH9OqHZbvc6CSQVLY7VA9RTBtmM
         AkhDkUqzmuXKYJ7ikxviqG/fYcHAaFvhznVYJTuV9kD7F74gmFHRiouzRcxw4sGudg16
         4eHg==
X-Gm-Message-State: AC+VfDzFFaqBOXvrNXiK3EGqZ+oe4wShGzcSRGMqfQo0mdULamqrBjam
        OckAkHpbGSCLMD+shtyYGCv2hg==
X-Google-Smtp-Source: ACHHUZ5GRXU6Qwibs9ZDmbkxXzE0v0HGP/aPJjeuRkEgLEfzKhZeZnfeHFwA+sFaC/31wIIPeoVRnw==
X-Received: by 2002:aa7:888b:0:b0:64d:fd0:dd1a with SMTP id z11-20020aa7888b000000b0064d0fd0dd1amr5499091pfe.16.1684426947363;
        Thu, 18 May 2023 09:22:27 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:22:26 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v20 23/26] riscv: Enable Vector code to be built
Date:   Thu, 18 May 2023 16:19:46 +0000
Message-Id: <20230518161949.11203-24-andy.chiu@sifive.com>
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

From: Guo Ren <guoren@linux.alibaba.com>

This patch adds configs for building Vector code. First it detects the
reqired toolchain support for building the code. Then it provides an
option setting whether Vector is implicitly enabled to userspace.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Suggested-by: Conor Dooley <conor.dooley@microchip.com>>
Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
Changelog v20:
 - s/RISCV_V_DISABLE/RISCV_ISA_V_DEFAULT_ENABLE/ for better
   understanding (Conor)
 - Update commit message (Conor)
Changelog V19:
 - Add RISCV_V_DISABLE to set compile-time default.
---
 arch/riscv/Kconfig  | 31 +++++++++++++++++++++++++++++++
 arch/riscv/Makefile |  6 +++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 1019b519d590..f3ba0a8b085e 100644
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
+config RISCV_ISA_V_DEFAULT_ENABLE
+	bool "Enable userspace Vector by default"
+	depends on RISCV_ISA_V
+	default y
+	help
+	  Say Y here if you want to enable Vector in userspace by default.
+	  Otherwise, userspace has to make explicit prctl() call to enable
+	  Vector, or enable it via the sysctl interface.
+
+	  If you don't know what to do here, say Y.
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

