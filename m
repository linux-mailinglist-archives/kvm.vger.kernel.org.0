Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1074667434
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 15:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjALOD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 09:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjALOD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 09:03:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17635132E
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:03:26 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso19219450pjl.2
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgHRkFPpyUb1zPgUZ8Z5/eq4ALXxizOkU21iNrwXDT4=;
        b=EAGSFs1hkLM765+88mQ0b4gLIqycLnieeWFPSGU2I8nhlEZQjS5zWlRmhMbWgKGfhX
         o3CvnOHM5wUmh+69nsVQ14zhVlxaSTx0/EKRIpIc6MfLFOpbM5/3xZCcKpv/JkFMO7V4
         MsushEeJfjTxU6wfk5Kg6Q+mBHaFufUU1N41RcfkYiGY5a/pBTIdyAjrBgtDd0UhZ9TS
         vlErdKrAeF/4FyRrvURRxsLvLN6lLtEH24ImBmrV26vkp2JdH8V3b26uSjIvBBtX2QUS
         XLGkTmzGWLWz0P0si5a7YFT4MecJY/sxH5KM7qxZfOIXAR7ZruaFgf2JfUP6xHxWZaea
         W3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IgHRkFPpyUb1zPgUZ8Z5/eq4ALXxizOkU21iNrwXDT4=;
        b=TGfDM5F70KuDJjSjLPPxrkuK9BkHvmJAJ0p2gOpZTf0Qdex4P8/aF6P8GPPvqxiU81
         mzfoMoVnnzrvdNxY0N3HvpMAEIAaYWbYrwEiaOSyv4EKtY5f/wmh1rJm4PeZcO4oMdQa
         LqrNKS2GxZGKpEOVyvtjQ7Wz2y7U0d1PYXg7GhoAu2Jeyd5W+tpU7km2UEhqbAdQG+kM
         fy+aiiLIbx2R+yf5B6LN60/7G8++TrcX/rr77XZTnGOEPGjgkPjdsYoEbak0nrJuTbrh
         VRcAJLOSvtRKGk3dG999CBvSU76Vkamdjvty7KXXjnkodeQiIYGADezUrp+xw0o/gh5D
         j7Ew==
X-Gm-Message-State: AFqh2kqBXx9fXfIuTqAUCwHTxOsyA2WCAvslKlwD5ISquzgdRugoPhCC
        7QAsgc+yrDpTNwjlGWvlRloV0g==
X-Google-Smtp-Source: AMrXdXvVfqOdttUAhm3BBlUd33vNJ7jLX3PtRHk6qkzl6HU7bHbo3EQNB+e7PwLHWUiA88Uw94QgUg==
X-Received: by 2002:a17:902:f544:b0:194:65c8:da70 with SMTP id h4-20020a170902f54400b0019465c8da70mr1199404plf.45.1673532205861;
        Thu, 12 Jan 2023 06:03:25 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b001925016e34bsm12351455plg.79.2023.01.12.06.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:03:25 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/7] RISC-V: Add AIA related CSR defines
Date:   Thu, 12 Jan 2023 19:32:58 +0530
Message-Id: <20230112140304.1830648-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112140304.1830648-1-apatel@ventanamicro.com>
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
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

The RISC-V AIA specification improves handling per-HART local interrupts
in a backward compatible manner. This patch adds defines for new RISC-V
AIA CSRs.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/csr.h | 93 ++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 0e571f6483d9..d608dac4b19f 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -73,7 +73,10 @@
 #define IRQ_S_EXT		9
 #define IRQ_VS_EXT		10
 #define IRQ_M_EXT		11
+#define IRQ_S_GEXT		12
 #define IRQ_PMU_OVF		13
+#define IRQ_LOCAL_MAX		(IRQ_PMU_OVF + 1)
+#define IRQ_LOCAL_MASK		((_AC(1, UL) << IRQ_LOCAL_MAX) - 1)
 
 /* Exception causes */
 #define EXC_INST_MISALIGNED	0
@@ -156,6 +159,27 @@
 				 (_AC(1, UL) << IRQ_S_TIMER) | \
 				 (_AC(1, UL) << IRQ_S_EXT))
 
+/* AIA CSR bits */
+#define TOPI_IID_SHIFT		16
+#define TOPI_IID_MASK		_AC(0xfff, UL)
+#define TOPI_IPRIO_MASK		_AC(0xff, UL)
+#define TOPI_IPRIO_BITS		8
+
+#define TOPEI_ID_SHIFT		16
+#define TOPEI_ID_MASK		_AC(0x7ff, UL)
+#define TOPEI_PRIO_MASK		_AC(0x7ff, UL)
+
+#define ISELECT_IPRIO0		0x30
+#define ISELECT_IPRIO15		0x3f
+#define ISELECT_MASK		_AC(0x1ff, UL)
+
+#define HVICTL_VTI		_AC(0x40000000, UL)
+#define HVICTL_IID		_AC(0x0fff0000, UL)
+#define HVICTL_IID_SHIFT	16
+#define HVICTL_DPR		_AC(0x00000200, UL)
+#define HVICTL_IPRIOM		_AC(0x00000100, UL)
+#define HVICTL_IPRIO		_AC(0x000000ff, UL)
+
 /* xENVCFG flags */
 #define ENVCFG_STCE			(_AC(1, ULL) << 63)
 #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
@@ -250,6 +274,18 @@
 #define CSR_STIMECMP		0x14D
 #define CSR_STIMECMPH		0x15D
 
+/* Supervisor-Level Window to Indirectly Accessed Registers (AIA) */
+#define CSR_SISELECT		0x150
+#define CSR_SIREG		0x151
+
+/* Supervisor-Level Interrupts (AIA) */
+#define CSR_STOPEI		0x15c
+#define CSR_STOPI		0xdb0
+
+/* Supervisor-Level High-Half CSRs (AIA) */
+#define CSR_SIEH		0x114
+#define CSR_SIPH		0x154
+
 #define CSR_VSSTATUS		0x200
 #define CSR_VSIE		0x204
 #define CSR_VSTVEC		0x205
@@ -279,8 +315,32 @@
 #define CSR_HGATP		0x680
 #define CSR_HGEIP		0xe12
 
+/* Virtual Interrupts and Interrupt Priorities (H-extension with AIA) */
+#define CSR_HVIEN		0x608
+#define CSR_HVICTL		0x609
+#define CSR_HVIPRIO1		0x646
+#define CSR_HVIPRIO2		0x647
+
+/* VS-Level Window to Indirectly Accessed Registers (H-extension with AIA) */
+#define CSR_VSISELECT		0x250
+#define CSR_VSIREG		0x251
+
+/* VS-Level Interrupts (H-extension with AIA) */
+#define CSR_VSTOPEI		0x25c
+#define CSR_VSTOPI		0xeb0
+
+/* Hypervisor and VS-Level High-Half CSRs (H-extension with AIA) */
+#define CSR_HIDELEGH		0x613
+#define CSR_HVIENH		0x618
+#define CSR_HVIPH		0x655
+#define CSR_HVIPRIO1H		0x656
+#define CSR_HVIPRIO2H		0x657
+#define CSR_VSIEH		0x214
+#define CSR_VSIPH		0x254
+
 #define CSR_MSTATUS		0x300
 #define CSR_MISA		0x301
+#define CSR_MIDELEG		0x303
 #define CSR_MIE			0x304
 #define CSR_MTVEC		0x305
 #define CSR_MENVCFG		0x30a
@@ -297,6 +357,25 @@
 #define CSR_MIMPID		0xf13
 #define CSR_MHARTID		0xf14
 
+/* Machine-Level Window to Indirectly Accessed Registers (AIA) */
+#define CSR_MISELECT		0x350
+#define CSR_MIREG		0x351
+
+/* Machine-Level Interrupts (AIA) */
+#define CSR_MTOPEI		0x35c
+#define CSR_MTOPI		0xfb0
+
+/* Virtual Interrupts for Supervisor Level (AIA) */
+#define CSR_MVIEN		0x308
+#define CSR_MVIP		0x309
+
+/* Machine-Level High-Half CSRs (AIA) */
+#define CSR_MIDELEGH		0x313
+#define CSR_MIEH		0x314
+#define CSR_MVIENH		0x318
+#define CSR_MVIPH		0x319
+#define CSR_MIPH		0x354
+
 #ifdef CONFIG_RISCV_M_MODE
 # define CSR_STATUS	CSR_MSTATUS
 # define CSR_IE		CSR_MIE
@@ -307,6 +386,13 @@
 # define CSR_TVAL	CSR_MTVAL
 # define CSR_IP		CSR_MIP
 
+# define CSR_IEH		CSR_MIEH
+# define CSR_ISELECT	CSR_MISELECT
+# define CSR_IREG	CSR_MIREG
+# define CSR_IPH		CSR_MIPH
+# define CSR_TOPEI	CSR_MTOPEI
+# define CSR_TOPI	CSR_MTOPI
+
 # define SR_IE		SR_MIE
 # define SR_PIE		SR_MPIE
 # define SR_PP		SR_MPP
@@ -324,6 +410,13 @@
 # define CSR_TVAL	CSR_STVAL
 # define CSR_IP		CSR_SIP
 
+# define CSR_IEH		CSR_SIEH
+# define CSR_ISELECT	CSR_SISELECT
+# define CSR_IREG	CSR_SIREG
+# define CSR_IPH		CSR_SIPH
+# define CSR_TOPEI	CSR_STOPEI
+# define CSR_TOPI	CSR_STOPI
+
 # define SR_IE		SR_SIE
 # define SR_PIE		SR_SPIE
 # define SR_PP		SR_SPP
-- 
2.34.1

