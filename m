Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4F35E5568
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiIUVrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiIUVrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:47:17 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E24FA6C1E
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:47:15 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a29so7319758pfk.5
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=a9YZZj3lGUqe+IwHRLjiPb6pN/UWuamlTiBoCYoLPmI=;
        b=eM8rXH1YNLqnI3aZCrzM5BieJX3ga8duNSoe/8R5upRbhLPRd3MoHhOKs4r0GxEAqr
         pXpOPdfWgJrJWqJUAX8niFvqVNe5quwQUBoqleWQvk27EHeKkl885UO2oskB3f5asvIJ
         CZtwCokZz6WhyvpeOg/ipE2OWvmXVyYlPFjt+6CWcGhggNEbjBBKMv6cQ1+fiEK4MK5J
         1S2oYNmIYq+XpfbvdMUuI7ZSmvogwAeUIOpWfMY63z1z755SIPzSMOsoouU1fOxvP8eu
         p7dtlmVeQ3ZtamhVH/YnVjP5exxi7qKGEqIUyz2NTKGb5Gz1IwCqpphu6l7QKfUjzr/x
         doxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=a9YZZj3lGUqe+IwHRLjiPb6pN/UWuamlTiBoCYoLPmI=;
        b=bwRcZyeftbqktUWfZW1Um7h1AUoXdQdi7XYPgRfN6vBRADGGYsf3DnDwa4WdHC/IMN
         NL5+Gx/swPfsSc5nwAoNvEWWq8iCPL5df3DKLywef0Shj0oeTlpeAYaA4CPezMDvRJer
         YbTRdPIaVel4sKVLcERfZCTh/HY8VL8zNF5hikxIIpQSFewpM797Qrwss7FkcbQZP7Ic
         DUnrDNA7t3SNAuIgQf5Uoce+busqNWGb/6IoKn0/XUdnkFPCto1LnF92hBpvloAVuLRK
         v+wu4j3tiAnkd7kOQvfgY3fdJnfNgNhm7JFBq2p/LjAl+RKoWuM6bc7y7ANSl1Yn7s6x
         vx5w==
X-Gm-Message-State: ACrzQf0JhdD2G65SWSKIC1gnl3C8LUOCYEkAokfgNpR1CpZrU5/doz/h
        lMPmvFyiROC0ZtBiravhWe0E3A==
X-Google-Smtp-Source: AMsMyM60JVIQaMBi8F6B6H9VWCAEoqB3LzloqkN8qP6PRsvgKyd54CVQbymc+KSYViAOXyhEMGgkhA==
X-Received: by 2002:a62:3808:0:b0:543:8e90:2810 with SMTP id f8-20020a623808000000b005438e902810mr172763pfa.45.1663796834851;
        Wed, 21 Sep 2022 14:47:14 -0700 (PDT)
Received: from stillson.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79727000000b005484d133127sm2634536pfg.129.2022.09.21.14.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:47:14 -0700 (PDT)
From:   Chris Stillson <stillson@rivosinc.com>
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Oleg Nesterov <oleg@redhat.com>, Guo Ren <guoren@kernel.org>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Chris Stillson <stillson@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Dao Lu <daolu@rivosinc.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Changbin Du <changbin.du@intel.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Alexander Graf <graf@amazon.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Colin Cross <ccross@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Barret Rhoden <brho@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [PATCH v12 04/17] riscv: Add vector feature to compile
Date:   Wed, 21 Sep 2022 14:43:46 -0700
Message-Id: <20220921214439.1491510-4-stillson@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921214439.1491510-1-stillson@rivosinc.com>
References: <20220921214439.1491510-1-stillson@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

This patch adds a new config option which could enable assembler's
vector feature.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
---
 arch/riscv/Kconfig  | 15 +++++++++++++--
 arch/riscv/Makefile |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index ed66c31e4655..e294d85bfb7d 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -432,7 +432,17 @@ config FPU
 
 	  If you don't know what to do here, say Y.
 
-endmenu # "Platform type"
+config VECTOR
+	bool "VECTOR support"
+	depends on GCC_VERSION >= 120000 || CLANG_VERSION >= 130000
+	default n
+	help
+	  Say N here if you want to disable all vector related procedure
+	  in the kernel.
+
+	  If you don't know what to do here, say Y.
+
+endmenu
 
 menu "Kernel features"
 
@@ -556,6 +566,7 @@ config CMDLINE_EXTEND
 	  cases where the provided arguments are insufficient and
 	  you don't want to or cannot modify them.
 
+
 config CMDLINE_FORCE
 	bool "Always use the default kernel command string"
 	help
@@ -648,7 +659,7 @@ config XIP_PHYS_ADDR
 	  be linked for and stored to.  This address is dependent on your
 	  own flash usage.
 
-endmenu # "Boot options"
+endmenu
 
 config BUILTIN_DTB
 	bool
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 3fa8ef336822..1ec17f3d6d09 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -50,6 +50,7 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+riscv-march-$(CONFIG_VECTOR)		:= $(riscv-march-y)v
 
 # Newer binutils versions default to ISA spec version 20191213 which moves some
 # instructions from the I extension to the Zicsr and Zifencei extensions.
-- 
2.25.1

