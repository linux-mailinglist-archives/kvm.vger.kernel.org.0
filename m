Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED836C6BD1
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjCWPCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbjCWPCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:02:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E5C3403F
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so2373778pjb.0
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583684;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BYoTKoh2oaNxCYlsCt/bFwPgHo97od34r6h8Ka1Tses=;
        b=DqXgOrNCmgxCkO3fN35n3mAne+CXZvia4w/MJIDLeN/j4ng68vuqyGlut4wg/LgD65
         FMoBupViafdgAxEwWtpxM1jGxDs8Eq5TfJH39bZPjjy4XjPw6oJYMPdWqcNAI+Lr72a+
         z+vlDU1MLIVbrE25YIrwwYOY4qyhqpSTOjqrvVVUUjpmD5khBvkAhYAEQIq57s9yRQbS
         96R+DnB4++T9fg/aa+CjPJj+RhwLcORGIxw///qvNgt6pZ/tXodW9FicF4J3RR2Htfhk
         l+VMx+IsicS05FfKuYe/EDLu6mjD0IsUdCUPUuUOGxXWD0atth/9Uj3ugHrtUxbJOJ1S
         Ja4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583684;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BYoTKoh2oaNxCYlsCt/bFwPgHo97od34r6h8Ka1Tses=;
        b=ttpowa8LpNkIplAb6i/gN2AucTgsrAAnpZoXL91ZrStkGA3O1WMD4TcghSJpmiETjr
         etjyaXdin3HUQ9cnh00dXzkR7GJdLK1Hcyl8e4mvABHfVzXMnoLBHyWp22H0QjRekjuR
         l5LFs/jVsGxG8d0YKJ/APMk6us7Bw/l/tUr4QQwmEQA7vmJs6heEaZGBpyM+JrM1C/Bq
         CyDxbslBvKOEQ9piNH7mBFkevz74oa+sFAko4uWDL/ZYJzQATQK1V7eSlAbzz0o4kSCK
         dVn/1OzJ/O8NX+GBypPk2bSt9Ut0U9XkQ0NESjOHMslj94PM92wcGdj1VKn7Yg55BvQ5
         +wQA==
X-Gm-Message-State: AO0yUKVi5ssW/woIXz1b8v/mSu/xootUmxiOiAAwhfjoUKBcrcDFFeL3
        HBfj3l0lr6Megf/z60tb+CDL09wpvfFNJC0UvmI=
X-Google-Smtp-Source: AK7set/RqhPy57RVMl+b0k//9zMeEBHGG9QTpL++qz91v0jRmKZ3Kkxa9Cz2bI1AWk/Tldw55GeoLQ==
X-Received: by 2002:a17:903:288c:b0:1a1:9842:2020 with SMTP id ku12-20020a170903288c00b001a198422020mr5872275plb.43.1679583684117;
        Thu, 23 Mar 2023 08:01:24 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.08.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:01:23 -0700 (PDT)
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
Subject: [PATCH -next v16 19/20] riscv: detect assembler support for .option arch
Date:   Thu, 23 Mar 2023 14:59:23 +0000
Message-Id: <20230323145924.4194-20-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some extensions use .option arch directive to selectively enable certain
extensions in parts of its assembly code. For example, Zbb uses it to
inform assmebler to emit bit manipulation instructions. However,
supporting of this directive only exist on GNU assembler and has not
landed on clang at the moment, making TOOLCHAIN_HAS_ZBB depend on
AS_IS_GNU.

While it is still under review at https://reviews.llvm.org/D123515, the
upcoming Vector patch also requires this feature in assembler. Thus,
provide Kconfig AS_HAS_OPTION_ARCH to detect such feature. Then
TOOLCHAIN_HAS_XXX will be turned on automatically when the feature land.

Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 36a5b6fed0d3..4f8fd4002f1d 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -244,6 +244,12 @@ config RISCV_DMA_NONCOHERENT
 config AS_HAS_INSN
 	def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) t0$(comma) t0$(comma) zero)
 
+config AS_HAS_OPTION_ARCH
+	# https://reviews.llvm.org/D123515
+	def_bool y
+	depends on $(as-instr, .option arch$(comma) +m)
+	depends on !$(as-instr, .option arch$(comma) -i)
+
 source "arch/riscv/Kconfig.socs"
 source "arch/riscv/Kconfig.errata"
 
@@ -442,7 +448,7 @@ config TOOLCHAIN_HAS_ZBB
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbb)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbb)
 	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
-	depends on AS_IS_GNU
+	depends on AS_HAS_OPTION_ARCH
 
 config RISCV_ISA_ZBB
 	bool "Zbb extension support for bit manipulation instructions"
-- 
2.17.1

