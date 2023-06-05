Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027D4722B8E
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbjFEPml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbjFEPm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:26 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1E01B4
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:42:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b041ccea75so25803645ad.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979723; x=1688571723;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=otAeXCQ9wHQgYb9XVLjxDELtJAEuURMD8rtVKOhLCTY=;
        b=GICIV0NT3It7ucO3UJ2gZ3jwWoXXmy+OwT1H5NbInsfp5nA4wkafaRhlHFTstvSRBh
         HrgwpW4h5xWhdHU5ITjegRyaHLqfW/L89qevzwb/bAUBVlOWqU/GD9cTUDJw+9R0DgPD
         ZNa/KLi6O4dbI/4ZDzUkMkfn4AfssCHHZJ5Pm0FE7BbjdNhDoxhx+H7EdiUDcz9LSAWr
         byidMK6H48ZqoRk44q3djMvlCoVRFxk+nACOTzIASAunp7MtsAYRVcijCCZK1YtiHUlK
         24/fRBlKkn6Tztjd2kjYHpbXuK6mIt/MK7OyBI9bq1b05GLmBZ8siaMHqDSlmWIZ5sL4
         dDzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979723; x=1688571723;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otAeXCQ9wHQgYb9XVLjxDELtJAEuURMD8rtVKOhLCTY=;
        b=Wf7v6QrIJv0vxOUbBzTDdvxnu7ZSm3jChyhVI0sy0cN1DgRiQkWY41rYZVlAY0xLKQ
         X8tIXqaOdnNJih0jqFf+dJKnwhUxBIZrHeM4kSzvagKuuA7lUpyDmdjs4IzxshxhTE0+
         2oImmwp+pJIFSHkwwK6BTf5eDtl4YRLbWeEeQqLwCL0yVC+xBp5ib2o97wMicVJ9Lazj
         VPRqDNtK6EKPjjzcvMb/Nd4ZoTmIWurwz6VSs/geFQEdRFFhZr3ikZWPodlP7N3/GxsU
         a+oL48EHunpTkQ63cqCFSWp4BRd7jaYryxqcyPe7LM/ZhjoodY0D5QOYyMuIRyuBw45l
         Ydeg==
X-Gm-Message-State: AC+VfDyx9UWSTRQxBBnFw7lpWeSWVZwvyt1ACcHeVhH6DYhvtmuRk/nl
        ZGL/wEnflGJYvpY8/Sm3ASlLFA==
X-Google-Smtp-Source: ACHHUZ43cS6OalvTGtWBOXIW7qcclVUVLOPKWYSft4n7VdSMybpc1v45G04KlhkE9QfwM2PE1BpY6A==
X-Received: by 2002:a17:902:7008:b0:1ab:eee:c5d7 with SMTP id y8-20020a170902700800b001ab0eeec5d7mr4014641plk.48.1685979723069;
        Mon, 05 Jun 2023 08:42:03 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:42:02 -0700 (PDT)
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
Subject: [PATCH -next v21 23/27] riscv: detect assembler support for .option arch
Date:   Mon,  5 Jun 2023 11:07:20 +0000
Message-Id: <20230605110724.21391-24-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
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

