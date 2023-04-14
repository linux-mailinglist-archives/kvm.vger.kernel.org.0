Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6D96E27E1
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjDNQBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjDNQBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:01:03 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B7B446
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:45 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y6so17639384plp.2
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681488045; x=1684080045;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zmWeoSmrBMtxR3vKNVKojBcvrcQrIEBGMqJAoaelw98=;
        b=G2pr/OVLqAjlZTUCowmQ8edFsVI/ipTpPtlA8Cefa/YtKrlp3dSIe1ucbn2mJkpITG
         kaI06/iiyzCch4xRRhUP3D6Vx0YcXDUKTNP+uM5XmOihjUxyuq3+Bu2SHAwoWy8DT/r3
         VfYEWh5W8jec6s26Gxzod+MN6Nb8Ua2X374Dq+UuteqPg3wCyKDMxQWvzgPfEPYYGv89
         9kL0zZV13R14WLiJN0V82KZGMhdarOvbHYu9pZouoqrqdmdtE35r/Z3Q+nd0F0XxbCFc
         1Pi0RXacB/bfcqnunIavT1H4gDROfR8Teu06QbF9UGVwqOH8v7JZhVVMaUUAcBWMjeLl
         cXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681488045; x=1684080045;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zmWeoSmrBMtxR3vKNVKojBcvrcQrIEBGMqJAoaelw98=;
        b=UK7j3oiquzqukvVBUi9VQ9Kd+D79LUCTraqvEgRdbYvbNqNIFXIGyJLX4JTF1lY/n2
         9hXqIFmUCRj8ENscr0ZF/TiwRv7TCmHNK7LmEO2IXTe3410lCOYQXGDNhoU8XuI5Vtzb
         E8TgDZfAHF5EBJAfbYyWrpkAYln7x0lSy7B29SYgdQDpp+bAdBdePJj0MoeCBPQmoL1H
         OzoJeC7ZFzhi+080EjsyGo2UTWNfVpV9qFULUOchkON6qPfMuflpxSQTFiott14I2Z9P
         85qo2oFpSgPzBvSN3To/f/pp9k184YWVkiOrT1uAhNXPTPcMmIA6sJXwrW0r3K9IRFWx
         RDog==
X-Gm-Message-State: AAQBX9cvcKEp7hKKROsIAonK3UrWPNycagHpyHzH67GUEZOfrXr02PJJ
        7uAn1jw8GzYvHbZA6tY9ml7HI6/hPb03YsrLuQY=
X-Google-Smtp-Source: AKy350ZZ8n236tZyzzCLneynVwAEUb3PwX3tobYlXJckVQxkA1mIcx2zmM9lIQADhKB5QaKuGssmRg==
X-Received: by 2002:a17:902:ceca:b0:1a2:a904:c438 with SMTP id d10-20020a170902ceca00b001a2a904c438mr3604960plg.58.1681488044928;
        Fri, 14 Apr 2023 09:00:44 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.09.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:00:44 -0700 (PDT)
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
Subject: [PATCH -next v18 19/20] riscv: detect assembler support for .option arch
Date:   Fri, 14 Apr 2023 15:58:42 +0000
Message-Id: <20230414155843.12963-20-andy.chiu@sifive.com>
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
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index cc02eb9eee1f..205ce6e009a2 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -246,6 +246,12 @@ config RISCV_DMA_NONCOHERENT
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

