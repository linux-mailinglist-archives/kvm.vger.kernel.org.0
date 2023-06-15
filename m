Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D51A7310D5
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 09:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244853AbjFOHfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 03:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245056AbjFOHes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 03:34:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B575A2973
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:13 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b506a66882so8740875ad.2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686814452; x=1689406452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n5vQwpyR3/1vG/MlBdXYEenCvwMIo2s7ZFYf5nDLaQE=;
        b=Wzl1Ykl8eOwlw+4AW6ewSJO4VQKgM5N7dvFdKlOR/mSpdA9DgVny251fYxrcO4DFzv
         MP/TXjrazhukelqOeBJ3uKasUkan0XMgyw3oWWGVRZYofoYEs1lSpHrd/oDdvSlpxeA8
         gR/9L6uWDIbVgO7ai5ZqsjIKYPkf2Sl7MZVmYuwRXya1nKZPH76w0/i542oR8dqr8uN6
         qke9O+CV/kW5+Mw9EwbSRsqKtQPbAWRxkqgr9thgAWqyOmOR6vJaCVocIISUHTzJXtOz
         WW0CJCPdeVFlmV7TE4bDABAR5DULT95/FIy3T/RsQtvRwytg6TQ+38dJWHV6vhKdF6vo
         Fjug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686814452; x=1689406452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n5vQwpyR3/1vG/MlBdXYEenCvwMIo2s7ZFYf5nDLaQE=;
        b=Jh1BDL7y766LTb3MELdbaNth3+HJaDLxwHhIF3vG9ocOMOjTOqpkmLQs0iEhGQ8FAt
         3eYT2Wgm1fGgz7YIIO7pbbfCT0wwPoEuhXZlxup93N7F4emHjr9iK871AItoc83/B2bP
         ESPHci2C5i/QgoQ43MA2DemwblM6h2BY7zLHu8xh1m+fZGDNLSekXPUVJitSxW+m48Qg
         +Su/Jl9ZvhwZOWt8qalkfnwuMSZGCiSmSLtjpM4UUDPrluFdSS2rQuJYs8+iqyD4l5Pr
         Gis4knLH2fpuChtue9EYDCS7X7j3Juvz3Ra+ZGhBv2ZDwlqQVeSf0yZN78yJuTrSWed1
         BI/g==
X-Gm-Message-State: AC+VfDyGQwK3pDpDkiAWeiBR2OPnRT1/W9Bnre/EJ7NJWA4Tc5FNg8kN
        wxabfBs6JtLXAk2llUKdKxYmXw==
X-Google-Smtp-Source: ACHHUZ54Z0ylk6QSHwqf8Rx/bzJHljB9afofIvFuNZQdqnZxhtOQfU7vwzkuSAjx7/MXeqngk3V20w==
X-Received: by 2002:a17:903:54:b0:1af:cf34:a645 with SMTP id l20-20020a170903005400b001afcf34a645mr10978937pla.21.1686814452521;
        Thu, 15 Jun 2023 00:34:12 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b016313b1dsm8049855plb.86.2023.06.15.00.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 00:34:12 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 03/10] RISC-V: KVM: Add APLIC related defines
Date:   Thu, 15 Jun 2023 13:03:46 +0530
Message-Id: <20230615073353.85435-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230615073353.85435-1-apatel@ventanamicro.com>
References: <20230615073353.85435-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add APLIC related defines in a separate header so that different
parts of KVM code can share it. Once AIA drivers are merged will
have a common APLIC header shared by both KVM and IRQCHIP driver.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
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

