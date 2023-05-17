Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84DF70659F
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 12:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjEQKwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 06:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjEQKv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 06:51:59 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5873A55AC
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:51:58 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1929818d7faso10239118fac.0
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684320717; x=1686912717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWDvDGT5NL3iW1eef6ejIvc5+67Gu1+G2Yy7gp150jQ=;
        b=IS/C/kvEwn8nYqZffOgr/UmUvVnAnK38KjYZRCOuwXqefKKTx2MUhrNuZuT7GAONs0
         kJoRSpdIlqn8qx9s7x30PhqBrSJ0rWHsyV4YkjRN9ZhFEWgNRJzP9gayTje+LuGOJUBP
         AfiB9ZrYgBWqDkkHss2HcRlbM2kakkCL4wLU1VMM4qOL4fSjWvO/KvSPFxWoqkcMMsEA
         YCXwCptXzH3PImewq10sTEUsqWvZyfS86WBuGidvVh3RS9v/LjuEfODUjcMMfpl9rYCo
         g73uI/HNIc/nrxNBF582fFXIGOloLUI47p9Z75hsFMoMK5K4ISAuYjXgHADbUUN+mP3u
         ugjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684320717; x=1686912717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JWDvDGT5NL3iW1eef6ejIvc5+67Gu1+G2Yy7gp150jQ=;
        b=R8MZdiOOceMqSelPedxfytJMqixc7FwzkQcWwLEs6IFyeGkLgb1rSPhxvJXTG5NQBT
         DLED9aYE95vP3nxLlcTTBSEmInEbxo6UShU6RkygoIr/0kIJCpGAGHVThQ4mOSDf4mjV
         20UtPkzRo6hNAKvUJ3v/muGSPbgq+xlgsKs2TRUydHswiZDBSZtZWXNiBgfMRAK3/j8f
         YHRwV70SIr1AsDSGGDO0VgDmHAKRjWoXsyP50QekiveO9JbFFA4h9LxES0u0dX2h2qm9
         r82rNb/3ndM5x6N6bRmI9ym1o19h0N7kG1WPWPlCZcmNyGNSUjCQXLyXiRGVLR9OmMdO
         5O6Q==
X-Gm-Message-State: AC+VfDyWQxJ/p9MG5zqe4OC8rWJaucC5Fe9IuLndEzwFpar1Gx8lvjIl
        L5gyrfJDfuvlKNQmUMyg0VLrOQ==
X-Google-Smtp-Source: ACHHUZ6ZsuXeHA2QKOJ6UIrVrK/VpLJT9CeWAGiHYwlEQtTyFlMxnWQIfB5QkPlSQUOEV7cCsrdDzg==
X-Received: by 2002:a05:6830:22c8:b0:6ab:641:8e19 with SMTP id q8-20020a05683022c800b006ab06418e19mr986463otc.1.1684320717587;
        Wed, 17 May 2023 03:51:57 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w1-20020a9d77c1000000b006ade3815527sm2279896otl.22.2023.05.17.03.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 03:51:57 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 02/10] RISC-V: KVM: Add IMSIC related defines
Date:   Wed, 17 May 2023 16:21:27 +0530
Message-Id: <20230517105135.1871868-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517105135.1871868-1-apatel@ventanamicro.com>
References: <20230517105135.1871868-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add IMSIC related defines in a separate header so that different
parts of KVM code can share it. Once AIA drivers are merged will
have a common IMSIC header shared by both KVM and IRQCHIP driver.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia_imsic.h | 38 ++++++++++++++++++++++++++
 arch/riscv/kvm/aia.c                   |  3 +-
 2 files changed, 39 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h

diff --git a/arch/riscv/include/asm/kvm_aia_imsic.h b/arch/riscv/include/asm/kvm_aia_imsic.h
new file mode 100644
index 000000000000..da5881d2bde0
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_aia_imsic.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ * Copyright (C) 2022 Ventana Micro Systems Inc.
+ */
+#ifndef __KVM_RISCV_AIA_IMSIC_H
+#define __KVM_RISCV_AIA_IMSIC_H
+
+#include <linux/types.h>
+#include <asm/csr.h>
+
+#define IMSIC_MMIO_PAGE_SHIFT		12
+#define IMSIC_MMIO_PAGE_SZ		(1UL << IMSIC_MMIO_PAGE_SHIFT)
+#define IMSIC_MMIO_PAGE_LE		0x00
+#define IMSIC_MMIO_PAGE_BE		0x04
+
+#define IMSIC_MIN_ID			63
+#define IMSIC_MAX_ID			2048
+
+#define IMSIC_EIDELIVERY		0x70
+
+#define IMSIC_EITHRESHOLD		0x72
+
+#define IMSIC_EIP0			0x80
+#define IMSIC_EIP63			0xbf
+#define IMSIC_EIPx_BITS			32
+
+#define IMSIC_EIE0			0xc0
+#define IMSIC_EIE63			0xff
+#define IMSIC_EIEx_BITS			32
+
+#define IMSIC_FIRST			IMSIC_EIDELIVERY
+#define IMSIC_LAST			IMSIC_EIE63
+
+#define IMSIC_MMIO_SETIPNUM_LE		0x00
+#define IMSIC_MMIO_SETIPNUM_BE		0x04
+
+#endif
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 1cee75a8c883..c78c06d99e39 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -15,6 +15,7 @@
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 #include <asm/hwcap.h>
+#include <asm/kvm_aia_imsic.h>
 
 struct aia_hgei_control {
 	raw_spinlock_t lock;
@@ -364,8 +365,6 @@ static int aia_rmw_iprio(struct kvm_vcpu *vcpu, unsigned int isel,
 	return KVM_INSN_CONTINUE_NEXT_SEPC;
 }
 
-#define IMSIC_FIRST	0x70
-#define IMSIC_LAST	0xff
 int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 				unsigned long *val, unsigned long new_val,
 				unsigned long wr_mask)
-- 
2.34.1

