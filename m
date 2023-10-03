Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161C97B5FA1
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 05:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbjJCDw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 23:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbjJCDwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 23:52:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F0DE1
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 20:52:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1c0ecb9a075so3480275ad.2
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 20:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696305170; x=1696909970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yycPMI9rC/acogS1vs0h8BRUvc4a6Kod+MRuzLqJ/0g=;
        b=eYod/e1R9rPAN+Lcj0so8LwAml04Wl/WzcFrIfCgC81dpEoK7EcH5aHxlKTX95tJxP
         mHIYp7ajloshl6RkNrEWp8HdYDoNolaS1bzGcOmkEfKQ65rsKDB+iiDgIN/TxBl6mvXX
         HvUyMyzIpI08lAO1nFzzHTVR3U+wfR0UtT91zT0LjPutA73nn8uHnc6Ced+ZTKyUbWiY
         bC9MasG0uW+u/3aG5OGaGTRVpbDG68m1ZyiLbAllgJGF9a91iUkKY8RhQetRk00RzuP0
         4MQml9OBOeYoeo6KO14UwkfYKVYuFqM4wcZO6KsvuXdCsfGJigCb9BIX29CI/ZG2fGA0
         eiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696305170; x=1696909970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yycPMI9rC/acogS1vs0h8BRUvc4a6Kod+MRuzLqJ/0g=;
        b=rv9+Ntpj5IpWYJAz+jEK2Dgsy64H7f+TD7j2LCeib6wHGRdl8BvGWTHVAKlql5mQq3
         Odx0dv8LBWp1KcQyj0nxC6nlWuu05Pn7CvptOEq35p6gQ1PJQe8t+0kG2sIs0+LLQrDi
         QR1S8dKBoXwgvPvA83ouiH4syQ4TTfABo045jjP2z9YZ3nNFYowDpvIqCewaP8gXOFN0
         seMppdGYEGdRNTzuLzTWb8C6dPGbgtOybqtmSdaM/zKH8rJxcEsAM1ayIwhCMt7dg2+Y
         YVj5MgTJ4tASKi7+2v0smZM/PGkW5QMfuYjBIPcDHv7lyWtR3miMhmyXsv/tiwnnDJ4x
         Bm0A==
X-Gm-Message-State: AOJu0YxUTNnM5D5677L7Z83sGxgeyJOvPxjVfd+gSZYd8HWx3RE7n08O
        6oU58saiSRXiEEPMqwRyjNysTg==
X-Google-Smtp-Source: AGHT+IFTxF070rx7YJkcoy2/BdnPUrtJEvwz7nDRRqveimSHvcZ4nNWjTlHA1gEQmD/xbZ6UMOx4KQ==
X-Received: by 2002:a17:902:f7d1:b0:1bc:10cf:50d8 with SMTP id h17-20020a170902f7d100b001bc10cf50d8mr10607315plw.23.1696305170384;
        Mon, 02 Oct 2023 20:52:50 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.84.132])
        by smtp.gmail.com with ESMTPSA id ja7-20020a170902efc700b001bf846dd2d0sm277381plb.13.2023.10.02.20.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 20:52:49 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Conor Dooley <conor@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Andrew Jones <ajones@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        devicetree@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v3 2/6] RISC-V: Detect Zicond from ISA string
Date:   Tue,  3 Oct 2023 09:22:22 +0530
Message-Id: <20231003035226.1945725-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003035226.1945725-1-apatel@ventanamicro.com>
References: <20231003035226.1945725-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RISC-V integer conditional (Zicond) operation extension defines
standard conditional arithmetic and conditional-select/move operations
which are inspired from the XVentanaCondOps extension. In fact, QEMU
RISC-V also has support for emulating Zicond extension.

Let us detect Zicond extension from ISA string available through
DT or ACPI.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 0f520f7d058a..6fc51c1b34cf 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -59,6 +59,7 @@
 #define RISCV_ISA_EXT_ZIFENCEI		41
 #define RISCV_ISA_EXT_ZIHPM		42
 #define RISCV_ISA_EXT_SMSTATEEN		43
+#define RISCV_ISA_EXT_ZICOND		44
 
 #define RISCV_ISA_EXT_MAX		64
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 3755a8c2a9de..e3803822ab5a 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -167,6 +167,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
 	__RISCV_ISA_EXT_DATA(zicboz, RISCV_ISA_EXT_ZICBOZ),
 	__RISCV_ISA_EXT_DATA(zicntr, RISCV_ISA_EXT_ZICNTR),
+	__RISCV_ISA_EXT_DATA(zicond, RISCV_ISA_EXT_ZICOND),
 	__RISCV_ISA_EXT_DATA(zicsr, RISCV_ISA_EXT_ZICSR),
 	__RISCV_ISA_EXT_DATA(zifencei, RISCV_ISA_EXT_ZIFENCEI),
 	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
-- 
2.34.1

