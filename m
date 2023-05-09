Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1405F6FC3FF
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbjEIKdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjEIKdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:33:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BECE106FA
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:33:26 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64115eef620so41336790b3a.1
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628405; x=1686220405;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=otAeXCQ9wHQgYb9XVLjxDELtJAEuURMD8rtVKOhLCTY=;
        b=a9gJeRbmISiXvK9+ul3SdWxI8z70Xub/NyicER2OxvyXBKL8WAsFJ+NZKPU4fljCMg
         jEWPgHcpV+zQtBxAvfFc0rsrG0sq4TIjaUlrodvh0dfOo4QGlXqDcFGClwooFLaRg+iW
         f5Sea6jREl7x6Zk+llerqT3zNu0RJbFkfJow2/bAZ71mKI+rtbJWHdU+9dBVtKPfzhLH
         RfUQluZd74bWBzHBmIui7882fXj9GbBfCAuPdJ5MTXw4gTFPoDw0DaXiRulGAU9C4b6H
         fl9t9ICOqSmqf94z8fPDKhXmhLYrgX+d/g+8kGAd2ICbtYdaP/Y8K6/uZRPkW4UChHW3
         jTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628405; x=1686220405;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otAeXCQ9wHQgYb9XVLjxDELtJAEuURMD8rtVKOhLCTY=;
        b=CnRAOE5DcxyZxaaWlMBjgbwsyyPUxbBdRZ2MnDLtkfg253wnuJQC9NKXKVQMMlF8wA
         FRbnp51l7KNjtQ7IC4+RedC09G8KW16BswDm70Z5LQYs1gCIlTYRUZsZIzXQkuBsUxro
         4hHyE0NwbKKWMh9/Jsn1SsM6z0aliJJms9oPLUiHQ51/oVMKZRLu3n9AB3MIdsuuiryX
         rskrrLYkvzRDLdcF4bA2vuVeaEKlBK2E2ePX7F1lGlb22Q5yvGKbIMGWsMFKO69HL+dw
         w7J2bb1oUxAljqMZoGXIJJZ1yYJJwi81q+NuKJFBcvMyB/v5pw7GYvSMMbTz77dVaQ0V
         oQYg==
X-Gm-Message-State: AC+VfDwxMbJB0NO8cEBjgr19GjvxnEo/YbRnoICZCcvqNgfjDEzlgOMQ
        E2tHuHCuKZ7lXUnJn4SJHducWg==
X-Google-Smtp-Source: ACHHUZ7GzqAZDpDxZD2SUwiWoansXVS+z1qNjyguAay5WAkNMAyCcaNR9ja+6NBQli6ZWMZZmnBJcg==
X-Received: by 2002:a17:902:da92:b0:1ac:94b3:3ab4 with SMTP id j18-20020a170902da9200b001ac94b33ab4mr2357313plx.27.1683628405463;
        Tue, 09 May 2023 03:33:25 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:33:24 -0700 (PDT)
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
Subject: [PATCH -next v19 22/24] riscv: detect assembler support for .option arch
Date:   Tue,  9 May 2023 10:30:31 +0000
Message-Id: <20230509103033.11285-23-andy.chiu@sifive.com>
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

