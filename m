Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11086CAB0F
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjC0QwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjC0QwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:52:04 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1214F3C13
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:46 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d22so5551579pgw.2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935899;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3o5PKVJouT2SvH1Nibwj1rRN/GByxiY77LUZdMPikJ8=;
        b=G9khAgwEOxm9Jl9drKB+OMaSZOAPIgBWTmXJhCJ1EcK3DDiDpYQDSwWbc3kv52M2Sw
         3gIsTeGkCcaHtRmroHdv80+g6loP4Bjg/cku51fqD2RoQcUl7WxHJQSUXUKzT4HOVmPw
         ANWIANcuf1rVowl4s9sAmbjIn+z+McyPKcvQR+OtJGh4+Z79ED6Wb8Oix+GWaqf4OpL/
         OQ4HBCJsXkznnfy2xni6s6KPZV1618ycrBCPkfWA/mCquWP0mOCcO+ynLOtepjQbjY8t
         OMOYiAk4DR5yJkouFNzFnA0ItMZvUQ9Q5HOy3+oKNQcUmbfusmfL2C0JAkdgai6ycW31
         C2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935899;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3o5PKVJouT2SvH1Nibwj1rRN/GByxiY77LUZdMPikJ8=;
        b=A1XS3ssMSQhpyWL/VDREeMArdXgAYyXN9+GPffOZm6kAkbxGE3l/ZtuKf/0vSJ6x6t
         PdvoyfMIUrZ8bgK+eAbj+BPZWT1L/kUh6zIbak983RxmZYx77y/fvgVlZ+OovxX80Bga
         J0g5yQagvR3p6ho3RRRFnTdSAmQsHC2CCS2n/84GruRJstIQE9GbyazN//2xC679CYvI
         HcI2K3gNzv2XDYYOWO+RBGbMjMT4hy6p2nSpkUGtqQ4rtdO0Tu7ig8Nsv35GsHPDabXw
         md/JEl+3cHbKuub9PG/FfgAOYptza0UCkVg4b3b6VcXyihdjH+jMMvS9VnCKUT1MqsbX
         Ue1w==
X-Gm-Message-State: AAQBX9dHBkMz6MY35NgUAfw1XYCmVXRfLsXyai3brxnXK7RGlx+BVk1N
        yzdPEGgmXmebBEjhDqIATmMX0w==
X-Google-Smtp-Source: AKy350YP8LuXdyAO3EhfMm+8W/2ANf4fDQt1KF0UR5mCV9HkbaS9xfiIYB3fD122c4G835W2exXKbw==
X-Received: by 2002:a62:1d51:0:b0:622:ece1:35d3 with SMTP id d78-20020a621d51000000b00622ece135d3mr11696525pfd.5.1679935899291;
        Mon, 27 Mar 2023 09:51:39 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:51:38 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v17 20/20] riscv: Enable Vector code to be built
Date:   Mon, 27 Mar 2023 16:49:40 +0000
Message-Id: <20230327164941.20491-21-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 arch/riscv/Kconfig  | 20 ++++++++++++++++++++
 arch/riscv/Makefile |  6 +++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 91d5f2731f06..d95245311bf0 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -443,6 +443,26 @@ config RISCV_ISA_SVPBMT
 
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
index 6203c3378922..6f32c0ab32e3 100644
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

