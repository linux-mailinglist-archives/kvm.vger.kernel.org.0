Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9897085FA
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjERQW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjERQWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:22:55 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2A9E5F
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:34 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso117516b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426944; x=1687018944;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=otAeXCQ9wHQgYb9XVLjxDELtJAEuURMD8rtVKOhLCTY=;
        b=D/9sOFm0nUPg7worQhPCe8AEkybdsphU5jCDpgLdO9TLPPtzwMLnHN4CNVbP429e3D
         eULZY3lyqSOBA1qyH0PHY7QdZLNl777TdCjPBf1rE74ioqjMdTXrdFsVY8DvG+GbMSOD
         Md4+ngoAXRWb9Qg3zYkRZa7wl7u+CQYE9+Df8UAb09fw6XXjdBAqgFHk2VNMiWrDCgEE
         byFdEbpAzIt1KIR2OsmKXQRjz/sTGjLSoWvBSh+x0JH8Ag3df79t2YgbZdahgQMMoKlS
         GtiUQBhjGH9oPM/6XGYQ8dkfVFRqub3su28Hq5uY8n/6k2vchxT1eCdiAdkgwCUZjeab
         Tylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426944; x=1687018944;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otAeXCQ9wHQgYb9XVLjxDELtJAEuURMD8rtVKOhLCTY=;
        b=K3d2sKMyFm396E5L5TANsRpbsx6j0ap3Io8opsLRO00JKWa2gRCYMmuZPJDL2ifA+v
         AqM3ffpaMB9wfgHo4c5JftCbpicwoEE3uU7YlvK1ELJcC1NgFb1NvN6Gl6q6g0JDBk36
         yA8xNIEruujU+omtLcAsfPo7fEJIQ6+v49BAqUxTXm64uS/A2wz8udilY5VZAkPQFkKK
         y4hxKT8K3W6ONuQFAIOhBiOvf6ZkVk8ivpB9jYhwZJiun+YylKeGFsWqBauDex84Fe1r
         dmPFOum8HcPD1Z+6VbeyferIa+zMBiqhUXrZEr5rvAPJRdMMamXlJfVekR2cojhsrxbW
         sJGQ==
X-Gm-Message-State: AC+VfDyE8JU3rILhxWpCZuXhAErzAxXJNBFTfG0/m2tCnimGKM1aVN8Z
        JbrZrGk11VTAYZEyfsFwW5WsPw==
X-Google-Smtp-Source: ACHHUZ7Wb2l5IYTrIfdDslfKAs+d+oKUxRkxvubNrCroZUnDUOrovMWjksdkc3+3iJAItG2BSv0b0Q==
X-Received: by 2002:a05:6a00:1acd:b0:63b:6149:7ad6 with SMTP id f13-20020a056a001acd00b0063b61497ad6mr4711081pfv.34.1684426944416;
        Thu, 18 May 2023 09:22:24 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:22:23 -0700 (PDT)
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
Subject: [PATCH -next v20 22/26] riscv: detect assembler support for .option arch
Date:   Thu, 18 May 2023 16:19:45 +0000
Message-Id: <20230518161949.11203-23-andy.chiu@sifive.com>
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
index 348c0fa1fc8c..1019b519d590 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -262,6 +262,12 @@ config RISCV_DMA_NONCOHERENT
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
 
@@ -466,7 +472,7 @@ config TOOLCHAIN_HAS_ZBB
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbb)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbb)
 	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
-	depends on AS_IS_GNU
+	depends on AS_HAS_OPTION_ARCH
 
 config RISCV_ISA_ZBB
 	bool "Zbb extension support for bit manipulation instructions"
-- 
2.17.1

