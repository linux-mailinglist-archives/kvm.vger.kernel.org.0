Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0E77065A2
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 12:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjEQKwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 06:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjEQKwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 06:52:13 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAC05FD0
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:52:03 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6abeffced6fso498126a34.3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684320722; x=1686912722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHvC3XUJE2v3T7O+M+Nn9D7CQdvc+SW83AHyEO9FlG4=;
        b=mT8PGLXc0NBj0MLl2MBwociLi8D+TVgcuJPdFV0aJli30czNDGI5rO0Uw1CVc8G/8G
         +tB88zucpow+02IdPK6I2aQ5pgINRhnnC4vpQMRqzsPGOf1AfER/5yi6RYZ1CIAKuOt6
         XZlX7c07t0AeJrr809nyrDV2/3s2XvNbTiIyRdoBDxhpIfsOrpM+AdyBT7hx0Xx8xfxW
         a+Hulgq/lPZiLIR+BD7mW3ywkyCU0Kg9eSnlBZn85I1jWmz6KXHn6lSq6+Kr6VH6uJaG
         ikNYrkLRCmz7UA4G14aRHaFwspuPNrJ5qVEAESMbxtqAOQvNhC4XTiy//am29wHHoqiL
         r2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684320722; x=1686912722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHvC3XUJE2v3T7O+M+Nn9D7CQdvc+SW83AHyEO9FlG4=;
        b=fDupMSEwUYB5GRW/OZDSZehbt8XsuFH1uwRKRuKkWCGblX87r6MY51RrK5MKyjsjuI
         R+n63cUAb2K2avJyABVhdhVnX3TJIrk5AU9y4rAI6Tpilz65JVRTGQ0jDjhZUr51ai3u
         T4MAx/7tFQErLQFU3FlNBg5ALMf+dLZ6K0Qw8nBKEobg06CpbKnjFLEXKhF4++X/zCde
         RAAOtRTRbuiN1StcqU3vYEtdp6NFuyGclqG8iX7nscv00g8ykkqgfUSmRsAL+8s19dFM
         uWRGDpEgc4X5ytzpUXuUImUfIsgY42jy7BhGkKZMj8498fdMW2tYlxnq/w/vIYNvjSc9
         0LcQ==
X-Gm-Message-State: AC+VfDwUo1GPTCOrJUkevwvsc771/NmRIOl/f1YyQY0UUGhdFofiyzML
        6KimxBMuePLmwEOTsOkpfqcVLw==
X-Google-Smtp-Source: ACHHUZ7BKVi8bZ+sm2ebgy/Qq29+28cr+vSclh/3yoQT4Y125ntV1qhwamJ/33isZ2ldBiFMTyZ7Yg==
X-Received: by 2002:a9d:6396:0:b0:6a6:4a28:dcb0 with SMTP id w22-20020a9d6396000000b006a64a28dcb0mr14576552otk.21.1684320722389;
        Wed, 17 May 2023 03:52:02 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w1-20020a9d77c1000000b006ade3815527sm2279896otl.22.2023.05.17.03.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 03:52:02 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 03/10] RISC-V: KVM: Add APLIC related defines
Date:   Wed, 17 May 2023 16:21:28 +0530
Message-Id: <20230517105135.1871868-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517105135.1871868-1-apatel@ventanamicro.com>
References: <20230517105135.1871868-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add APLIC related defines in a separate header so that different
parts of KVM code can share it. Once AIA drivers are merged will
have a common APLIC header shared by both KVM and IRQCHIP driver.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia_aplic.h | 58 ++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h

diff --git a/arch/riscv/include/asm/kvm_aia_aplic.h b/arch/riscv/include/asm/kvm_aia_aplic.h
new file mode 100644
index 000000000000..6dd1a4809ec1
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_aia_aplic.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ * Copyright (C) 2022 Ventana Micro Systems Inc.
+ */
+#ifndef __KVM_RISCV_AIA_IMSIC_H
+#define __KVM_RISCV_AIA_IMSIC_H
+
+#include <linux/bitops.h>
+
+#define APLIC_MAX_IDC			BIT(14)
+#define APLIC_MAX_SOURCE		1024
+
+#define APLIC_DOMAINCFG			0x0000
+#define APLIC_DOMAINCFG_RDONLY		0x80000000
+#define APLIC_DOMAINCFG_IE		BIT(8)
+#define APLIC_DOMAINCFG_DM		BIT(2)
+#define APLIC_DOMAINCFG_BE		BIT(0)
+
+#define APLIC_SOURCECFG_BASE		0x0004
+#define APLIC_SOURCECFG_D		BIT(10)
+#define APLIC_SOURCECFG_CHILDIDX_MASK	0x000003ff
+#define APLIC_SOURCECFG_SM_MASK	0x00000007
+#define APLIC_SOURCECFG_SM_INACTIVE	0x0
+#define APLIC_SOURCECFG_SM_DETACH	0x1
+#define APLIC_SOURCECFG_SM_EDGE_RISE	0x4
+#define APLIC_SOURCECFG_SM_EDGE_FALL	0x5
+#define APLIC_SOURCECFG_SM_LEVEL_HIGH	0x6
+#define APLIC_SOURCECFG_SM_LEVEL_LOW	0x7
+
+#define APLIC_IRQBITS_PER_REG		32
+
+#define APLIC_SETIP_BASE		0x1c00
+#define APLIC_SETIPNUM			0x1cdc
+
+#define APLIC_CLRIP_BASE		0x1d00
+#define APLIC_CLRIPNUM			0x1ddc
+
+#define APLIC_SETIE_BASE		0x1e00
+#define APLIC_SETIENUM			0x1edc
+
+#define APLIC_CLRIE_BASE		0x1f00
+#define APLIC_CLRIENUM			0x1fdc
+
+#define APLIC_SETIPNUM_LE		0x2000
+#define APLIC_SETIPNUM_BE		0x2004
+
+#define APLIC_GENMSI			0x3000
+
+#define APLIC_TARGET_BASE		0x3004
+#define APLIC_TARGET_HART_IDX_SHIFT	18
+#define APLIC_TARGET_HART_IDX_MASK	0x3fff
+#define APLIC_TARGET_GUEST_IDX_SHIFT	12
+#define APLIC_TARGET_GUEST_IDX_MASK	0x3f
+#define APLIC_TARGET_IPRIO_MASK	0xff
+#define APLIC_TARGET_EIID_MASK	0x7ff
+
+#endif
-- 
2.34.1

