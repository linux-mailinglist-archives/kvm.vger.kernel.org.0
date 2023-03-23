Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167306C6BD2
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjCWPCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbjCWPCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:02:44 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2624D28E74
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so2189363pjv.5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583687;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vtoGGjKeMirMGWzivkA2ddkX532xxY9JlIIZ7C9ExVA=;
        b=LP/ip08TU4mj5NiGXR+IDitS9xcZ1lrJxRBqmYgILXm/2WMj6AuS7ovyakecDS9cah
         l0rkl15XxJiJfG1UqvnRw/+BAWAnppVdkzjFU8Zu8FVB+lWTZHWgY6SDKFGSsxUUOOMB
         0VHGRGiOwcQgNzEJaa9LaNYMT8BxDNaZ9rKXpzIP1asHGkFMWOEAqk8waZgrOnvDa7Sx
         vkmJVjA/9CRO6gv0aj4oTv6lTWMaE2psbeTBGXEZwk84BAGsOg+MWHoKzwX7aGv+NyAj
         RM+gRv7r8HOGdqyjLhWxOFhB1OmPgkdg++IDwfqJH9h03f7By9rIQUiCclMhLICHBFiS
         iAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583687;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vtoGGjKeMirMGWzivkA2ddkX532xxY9JlIIZ7C9ExVA=;
        b=Ykm92MfrKp8dsolHi/4HSzbtgNs9WxidiyMA92dk3gMuexIirAlWxgbRrKtacBO/U/
         +z8TKHB7gROvaGVvquyLwEm4Al3V4oFr2pOaHgjf7hmxYHov31n/Oos5rowIucH5etm1
         oQqBMFTrOB6dZam9UG14lqRyYUwnFH7GYIT8QAd6EtqZER1oFM8w9z6618sI+WH+HbMu
         S2VMPpYcP93bVYtiB0xW532VZEf3JNPDpXeuBXpL6uuiZ8tpOcIwHlq6hldUAwV4xeon
         H7ovDsXwKc43CHQCMJhelujI+Hlf1PT67XUE1zA88Nmthd09W+Je3YjXY76zg9UWR0Kq
         qZ1g==
X-Gm-Message-State: AO0yUKXEvC3B6G5HNMm8GN4VAvGd/tkCzVWSxD5lhJQrhVHGs/LcbcER
        xjwE4/ncqoBPM2df5psyzTdBxg==
X-Google-Smtp-Source: AK7set8RGVbK2oSYU+p7FyEM2ztkMqRmYkTbXOwkaqPpCfw5FseydH8YU6eaCSf0Vcc60jPrXr193A==
X-Received: by 2002:a17:903:2846:b0:19a:a9d8:e48a with SMTP id kq6-20020a170903284600b0019aa9d8e48amr5745288plb.22.1679583687163;
        Thu, 23 Mar 2023 08:01:27 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.08.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:01:26 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v16 20/20] riscv: Enable Vector code to be built
Date:   Thu, 23 Mar 2023 14:59:24 +0000
Message-Id: <20230323145924.4194-21-andy.chiu@sifive.com>
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
index 4f8fd4002f1d..0e0377b5319c 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -442,6 +442,26 @@ config RISCV_ISA_SVPBMT
 
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

