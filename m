Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A6E7A580A
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 05:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjISDyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 23:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjISDyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 23:54:09 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42F5111
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 20:54:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2746ab05409so3223684a91.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 20:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695095642; x=1695700442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/pyUqu/Tkd0d14pnWQAKU8r5MyttJS43LfVvYmIT30=;
        b=D0NTPo3PTexB8W/IdHWW5Ktm5i3YBEEPJElB+DWvAyDTpRUx5SvURiKqsVUg2SYnkc
         0qp6Hr1o0SDUHi/fpVoxVPoTNcexh737MjOuo0ITr9GQFh3LrJEQGexx7nECkIbrmRDw
         aFcpHsdvpkY53fnfgtJOlzQlL02ud0KDbny6FAF4DiLi9QlJoLBYuG94StcEPnIfQxqw
         HZzoMbCRQYOOFXUAc1s47NCbGv6LNDsV1jPwzd6qsvjwtWetl41VUIGYIR7SDzoz2B+f
         cZA8Yc5ThsBkq6MOTvhGiSg1MVU2Dw/ZLnZyFBRM7WAP45VjLbucUfIJdRT1xQntHA2K
         KWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695095642; x=1695700442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/pyUqu/Tkd0d14pnWQAKU8r5MyttJS43LfVvYmIT30=;
        b=O6AJkGbY7VqE6bYplSIgwwKoGz9+/LRZFiCtVYSfK0zMYGJUh7gwD7Q1WKW27wCJkS
         JoCFvn4qbfAIbD1LEN9ndOLUldaFq0OCJdkNgu4ikOqi23bF6GxMgNd2FNhOjnlRtQqT
         nSu68bfE3eIIDjfmfYlUGd+8q/X+rQZtn33PNV4JZ+pmT/OJZ9o13fHsCxJUk/aZnqON
         kBAnDNuPELDRbmk9+ZcAGRBDlYv7WpehLLamFaTrUw0ULRNsh04WY671u0ByS0nZt6lb
         pVizXO1Cy0SOAQVXysXjcrY3LUGBRTaeibo+7ZzkRfwlVltGKemdrEhqJrtnQ84tjNCE
         sQxQ==
X-Gm-Message-State: AOJu0YzQ25/2sa2t/DHUGArsaHXyXZHN8zus8URWB82rVOS9BIWOhyBr
        J/D+y2+hSJUzYm2gPrE4eYA/8g==
X-Google-Smtp-Source: AGHT+IEv2GtqSdnsDMi5LgNHnFDwtL1zsQsjYDdjeBpdLohkB2ds19n77ngsGEre26d9mHroBrq5UQ==
X-Received: by 2002:a17:90b:190d:b0:276:7907:ecf with SMTP id mp13-20020a17090b190d00b0027679070ecfmr3278208pjb.36.1695095641908;
        Mon, 18 Sep 2023 20:54:01 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a034300b00273fc850342sm4000802pjf.20.2023.09.18.20.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 20:54:01 -0700 (PDT)
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
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/7] RISC-V: Detect XVentanaCondOps from ISA string
Date:   Tue, 19 Sep 2023 09:23:37 +0530
Message-Id: <20230919035343.1399389-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230919035343.1399389-1-apatel@ventanamicro.com>
References: <20230919035343.1399389-1-apatel@ventanamicro.com>
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

The Veyron-V1 CPU supports custom conditional arithmetic and
conditional-select/move operations referred to as XVentanaCondOps
extension. In fact, QEMU RISC-V also has support for emulating
XVentanaCondOps extension.

Let us detect XVentanaCondOps extension from ISA string available
through DT or ACPI.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
 arch/riscv/include/asm/hwcap.h                          | 1 +
 arch/riscv/kernel/cpufeature.c                          | 1 +
 3 files changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 36ff6749fbba..cad8ef68eca7 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -171,6 +171,13 @@ properties:
             memory types as ratified in the 20191213 version of the privileged
             ISA specification.
 
+        - const: xventanacondops
+          description: |
+            The Ventana specific XVentanaCondOps extension for conditional
+            arithmetic and conditional-select/move operations defined by the
+            Ventana custom extensions specification v1.0.1 (or higher) at
+            https://github.com/ventanamicro/ventana-custom-extensions/releases.
+
         - const: zba
           description: |
             The standard Zba bit-manipulation extension for address generation
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 0f520f7d058a..b7efe9e2fa89 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -59,6 +59,7 @@
 #define RISCV_ISA_EXT_ZIFENCEI		41
 #define RISCV_ISA_EXT_ZIHPM		42
 #define RISCV_ISA_EXT_SMSTATEEN		43
+#define RISCV_ISA_EXT_XVENTANACONDOPS	44
 
 #define RISCV_ISA_EXT_MAX		64
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 3755a8c2a9de..3a31d34fe709 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -182,6 +182,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
+	__RISCV_ISA_EXT_DATA(xventanacondops, RISCV_ISA_EXT_XVENTANACONDOPS),
 };
 
 const size_t riscv_isa_ext_count = ARRAY_SIZE(riscv_isa_ext);
-- 
2.34.1

