Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1621367B43E
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbjAYOXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjAYOXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:23:14 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5C359549
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:41 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so2136488pjb.4
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2C3HjWrZB+7wSfjrD6r343Y4MWemAjdetwdnRYMFDS8=;
        b=WHskQHqaOrEN26WyhV97d7Bg1iUstUPltyWS3O/fjmP+aSMAy1DoSKn7CMZml+K0yJ
         d+5PX44kEX/Q/gqJGcM2zTd5Lewm76vjAC0t2yD253Vji1Ci06HxX5599SPKXI9C0Kci
         U4LYPdODDXEl5pERcWF41p5r4kJ7emeU7czoNtpPSCM6rBgj79Tlkv5c7u6ABrGXAcwv
         Zr7WdrtZWuuHr/dw7sn5sp0O4FZZtC11h9t1pQvsiyfGQEgKhgAT9DUwmYzv2LL+3cxH
         Tai7bu2utXuMArBGP49Gh8EDJL4QrkKuQczUvWgJkIiz2/TKKTeUSqtJCmXmtRlhkn7E
         tyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2C3HjWrZB+7wSfjrD6r343Y4MWemAjdetwdnRYMFDS8=;
        b=SrnK01uZIFsaXVUz2FT4o50xJHIlUWGdwrYNOuB8P2+pSf/Gr2vDp9P1uDRse2cgK2
         kXbyAtYsCG5GO4DFHPPna/GYiYY2FyFO7V7vaIqz4FSQvgOBlRe9DS8TSBNFkUQUtD/B
         M2JSCwniOJ0Yk7MSVLu6CD9IYy43yHHNNr4zlYCwvtkSVQKKMogpSWNSp8QYGB92k4Ss
         sBR8Wes9IZF2Njme5t5bAxfojonQiy0C4wD8otnfPcww6pDJqhG2Yc6XPgg5rgmmnEZ4
         UU8+pKIRuKuwI3FF34TFoSw2S02Y1Tp8yXrsHdSw6tsl+/sYjU1+oqMLm8BU9/jn+rdZ
         5Tlg==
X-Gm-Message-State: AFqh2kpV5XJCoSUvi6KygpPXfQ2p+fRhf9UXMyltUh/Mg50RiXms+tcp
        SthXrzJFsWrWsGipVzD/OxgQWw==
X-Google-Smtp-Source: AMrXdXtxy2JSAotwxjD+LLAsHQS6lJjbYHIewFy59htIOvhSpptE3SMPHca/oLJ27jZ+84EGJbLR7w==
X-Received: by 2002:a05:6a20:4998:b0:b8:652a:79f2 with SMTP id fs24-20020a056a20499800b000b8652a79f2mr29889418pzb.11.1674656561421;
        Wed, 25 Jan 2023 06:22:41 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:22:41 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
Date:   Wed, 25 Jan 2023 14:20:56 +0000
Message-Id: <20230125142056.18356-20-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/Kconfig  | 10 ++++++++++
 arch/riscv/Makefile |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index e2b656043abf..f4299ba9a843 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -416,6 +416,16 @@ config RISCV_ISA_SVPBMT
 
 	   If you don't know what to do here, say Y.
 
+config RISCV_ISA_V
+	bool "VECTOR extension support"
+	depends on GCC_VERSION >= 120000 || CLANG_VERSION >= 130000
+	default n
+	help
+	  Say N here if you want to disable all vector related procedure
+	  in the kernel.
+
+	  If you don't know what to do here, say Y.
+
 config TOOLCHAIN_HAS_ZICBOM
 	bool
 	default y
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 12d91b0a73d8..67411cdc836f 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -52,6 +52,13 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+riscv-march-$(CONFIG_RISCV_ISA_V)	:= $(riscv-march-y)v
+
+ifeq ($(CONFIG_RISCV_ISA_V), y)
+ifeq ($(CONFIG_CC_IS_CLANG), y)
+        riscv-march-y += -mno-implicit-float -menable-experimental-extensions
+endif
+endif
 
 # Newer binutils versions default to ISA spec version 20191213 which moves some
 # instructions from the I extension to the Zicsr and Zifencei extensions.
-- 
2.17.1

