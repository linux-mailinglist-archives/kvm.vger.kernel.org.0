Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE10722B90
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbjFEPmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbjFEPm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88937E6D
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:42:07 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b00ecabdf2so45898145ad.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979726; x=1688571726;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3oGenUq2RmcAiga8rk96QsXqWKk89kTrI2+LG1B6lNo=;
        b=hQZT1Syqd3WtW8aZx2yL/w89kYn6X8sgyQjCm8QWqksNUZOcoovtC3D3JKxG7IrK70
         DacMox7pscej6plzIkxm9QISF6CSw5o8B2RYzAnKgNBhFIim/pAoZO8+kz1jfvDA7t+2
         ToQdoWsTEdq+EFz6n5LTWOQPGGw266O1UreTXy/f8aC3wvaBXq4qFXRrGcXZqQif615L
         MqkMD+a23PbI87CKTXHgEOzqNfq56zWReyp/iXOhjOizh7jXOlpi+ph3+aIVoH6ft+vz
         vHAfHvXIO9R3XIxFnGR3cU/u2qPOmkdie7B218Ah+q7l/PSSML/BTKH6NpWTk4DO8tm0
         Quaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979726; x=1688571726;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3oGenUq2RmcAiga8rk96QsXqWKk89kTrI2+LG1B6lNo=;
        b=BXgEHWQxMPkE0Cp4AZwWsgwHAqBeufyiOnywKoqHgGlIQQF36T+MZsX3eOqr0mkDvy
         LGFgT2v4bvAlzCz8ngHqgzh0HQoQrsITOTRNwX5KvLeTDyYBIZ8C1j5mcCpWy0qcf/WQ
         WJKsu5hiNgsLqPout7+rlOP168hahIfIda/RbcEr5ppenxMor5S2nv24OscR9bVRRmH3
         YzWTPN65E9na8oIJ+IP9jJBqoe4KJsiFkP9SeCvdo7A/oevNj8EdMrFZRILqdAKNUIaj
         75fM21pUqNudStZgLRBWTWCMH7gKvNjoCYwIDY38x5ahs9JHFP7TslChLprDtsZdz9wz
         0zLw==
X-Gm-Message-State: AC+VfDyG9NmrApSM7SoHDTS6wsKbqjZu1T0fraJZW3ldn/dlePFuMGWu
        3r/YCmhGNSxkRWoUe7Kv1PfxdQ==
X-Google-Smtp-Source: ACHHUZ6/3qltkidsVKYwQs6O3CFhkrECdKQdl6va7midlwG7wplu8QV7xOfVwrVED1s5/OkG1YraQA==
X-Received: by 2002:a17:902:ea04:b0:1a9:b8c3:c2c2 with SMTP id s4-20020a170902ea0400b001a9b8c3c2c2mr9570619plg.37.1685979725981;
        Mon, 05 Jun 2023 08:42:05 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:42:05 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v21 24/27] riscv: Enable Vector code to be built
Date:   Mon,  5 Jun 2023 11:07:21 +0000
Message-Id: <20230605110724.21391-25-andy.chiu@sifive.com>
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

From: Guo Ren <guoren@linux.alibaba.com>

This patch adds configs for building Vector code. First it detects the
reqired toolchain support for building the code. Then it provides an
option setting whether Vector is implicitly enabled to userspace.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
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

