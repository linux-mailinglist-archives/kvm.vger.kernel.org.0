Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757C96CAB0D
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjC0QwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjC0QwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:52:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122D740E1
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:42 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d13so8252322pjh.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935896;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hiu59K4ph7SyXp7BjEwK3G+rRiskRbPrjMkudHH9DX4=;
        b=QWnMeMAw76FAwhzMn4Uk36MPSLQPpKRLeS1D4hpxe1nQ57onnoaHguOj3xxhq5Kfvt
         ir/sA5vm8f1ImqHe5Ks+zV+xx8hq9zAGrinmYJjeDY8aUxYBTDEavc+EAZPQ4UdO5WWa
         0cQTcJY5x1AWOh3mq5+NlFRWuJE5txhwbsrZjDnfD4ccWgTEKcJQH2oYnkm/43BloOZX
         Bd600p/EEEP4JgYIo+5zouODY+DAe0Lq1CGBd+7fdQ9ZEXmD3kjlufXKbllCGh8go4V1
         sw9QjsQ9spUli+b+1e5OyxhJKiv6+cXGqpp8epY6B3Uv/NXbaJIJJisVMtDIfpf0DIyz
         mhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935896;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hiu59K4ph7SyXp7BjEwK3G+rRiskRbPrjMkudHH9DX4=;
        b=xS+NrayXXE0sAB4UNiPBebtzV45kl2gI+WP6F2gx6JQysRER73fI5LwN680kcZop+V
         hRI+RmXOhEDl4WFQZOglBZag9BCYqLk6pv25wSSQm5+bb2CiJVpVd6KhDN0o6R/OBdUu
         Id81aZXDWMrLv6AcZp0Ol1MAdGkvFm5wN4uSswOnMOPQwLkb3cBm7AY6mpL0+N+NBgyA
         5F/EBxMnWpdz4jzf4Jic2bvj6eIs7Cxy/nYvFLlA3vDe4SoMH3YFITKlVqugxx3i7c3W
         EjxZ3iIX7x5hbDYkKKD5GSDKYuZ5tyDbbSj9arp9Idlsy2YYNtzX7M6ScUucGcsY21Zi
         /Vhw==
X-Gm-Message-State: AO0yUKWyAI2WAt/V0wJc5jFI9GHmsxqircek/YqldmlK06ISoqbRRICw
        ntpBMQLeNbKcLJEnEJ1vvIJRAg==
X-Google-Smtp-Source: AK7set9+GC9+Bty6r5d7gOWAsOAU/walK7TMB8DnUDiKe6bQP+Vru5jrC6tUDELMN7f8lL3pTEuLiw==
X-Received: by 2002:a05:6a20:bc83:b0:d4:9fce:6c6a with SMTP id fx3-20020a056a20bc8300b000d49fce6c6amr11715440pzb.49.1679935896366;
        Mon, 27 Mar 2023 09:51:36 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:51:35 -0700 (PDT)
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
Subject: [PATCH -next v17 19/20] riscv: detect assembler support for .option arch
Date:   Mon, 27 Mar 2023 16:49:39 +0000
Message-Id: <20230327164941.20491-20-andy.chiu@sifive.com>
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
---
 arch/riscv/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d7252ced4ae6..91d5f2731f06 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -245,6 +245,12 @@ config RISCV_DMA_NONCOHERENT
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
 
@@ -443,7 +449,7 @@ config TOOLCHAIN_HAS_ZBB
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbb)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbb)
 	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
-	depends on AS_IS_GNU
+	depends on AS_HAS_OPTION_ARCH
 
 config RISCV_ISA_ZBB
 	bool "Zbb extension support for bit manipulation instructions"
-- 
2.17.1

