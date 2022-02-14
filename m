Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE744B4258
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241131AbiBNHCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:02:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241129AbiBNHCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:02:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F9C593BE
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:02:01 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z28-20020aa79f9c000000b004e10449d919so2497642pfr.4
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wDNL2R6b/uxvQNAartUduvQ+Nf4X45a++6d5c+9WGxE=;
        b=thWct39vJMCIgHVzQJjiRJbdgmYs/vqjjaxHRDD5XnukRMxXUnfg9ZGUkP1QAek2ey
         B2pyhSN0SlFo9bOMyPoC4buwI87WCWNj90qexrXp7OPEPqj2y04FUf1q5je4FVORU21F
         2BKdBoY1ti0EDD9WbfiziXPX/FPRRFr3CT7x26Wp/h9YAP9F4tZSG2RoP3gN3RaJ6iAF
         5ZWKwmd1HkUuwo7nRIByNR7k+VBDsEf6RWa7Syl7Di3ZqH4UqYl58NFEUWHgfVm6ntS2
         v4kdD2VsBW3dWAZ9zM3cwBlT7So119V1sUm9NEjgyIUhwMisYpqF/MsWIoKLIYjGXpDa
         LzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wDNL2R6b/uxvQNAartUduvQ+Nf4X45a++6d5c+9WGxE=;
        b=C1Ku6qdUzMTwcJDCtb5D+6WeeEfTc7sh5J18tgEZYVdezueCXxHhUu7rPvcr6bRVmq
         rwyNv4rpFwaeD6/oI66snfqjEdE72y3+o2dSlWRtGGzYb/ROoam8Di2AVmm1C3BrtSRJ
         9Vb48cCDMxEdDgKCo5lta/fnUzshrHSaG7g92DnmrqoE2K2fmzy2u3DjnqU/WIeVoDcT
         ee6Bt/7bLeUUyMCUxWSgpxtg238iizoH4RLLoAvrVEJzuFBJdVXtU9Y8HzM9rDcs3Ytr
         d9IIrHlQ3DUHj13eBolrRBSuLqr46SDIhkoFAZuUVEpUaVLdCG3ucsdJ7LInf2sMiiCO
         X/3g==
X-Gm-Message-State: AOAM532QdlRndg+phyTNQeagHWnYbnjYJaRcvG+H/b4iM3IZcV1LXI9l
        OGLVshrk8bDzQiaNgNrnYWLj9U0vWzQ=
X-Google-Smtp-Source: ABdhPJxSO1Vgn/Xn3fh2EROBsHrpgBOXYiLbD5dMMLa/1rr9IeSH93zuLETmn6/4vrSHw6pkoL5Uj5i5ohY=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4c0b:: with SMTP id
 na11mr13105933pjb.217.1644822120659; Sun, 13 Feb 2022 23:02:00 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:46 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-28-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 27/27] KVM: arm64: selftests: Introduce id_reg_test
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a test for aarch64 to validate basic behavior of
KVM_GET_ONE_REG and KVM_SET_ONE_REG for ID registers.

This test runs only when KVM_CAP_ARM_ID_REG_CONFIGURABLE is supported.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/arch/arm64/include/asm/sysreg.h         |    1 +
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/id_reg_test.c       | 1239 +++++++++++++++++
 4 files changed, 1242 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c

diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 7640fa27be94..be3947c125f1 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -793,6 +793,7 @@
 #define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..c82c1978d5bb 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,6 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
+/aarch64/id_reg_test
 /aarch64/psci_cpu_on_test
 /aarch64/vgic_init
 /aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..e713b26b21fc 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -103,6 +103,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
+TEST_GEN_PROGS_aarch64 += aarch64/id_reg_test
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/aarch64/id_reg_test.c b/tools/testing/selftests/kvm/aarch64/id_reg_test.c
new file mode 100644
index 000000000000..917abe951170
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/id_reg_test.c
@@ -0,0 +1,1239 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * id_reg_test.c - Tests reading/writing the aarch64's ID registers
+ *
+ * The test validates KVM_SET_ONE_REG/KVM_GET_ONE_REG ioctl for ID
+ * registers as well as reading ID register from the guest works fine.
+ *
+ * Copyright (c) 2022, Google LLC.
+ */
+
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <time.h>
+#include <pthread.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "vgic.h"
+
+/* Reserved ID registers */
+#define	SYS_ID_REG_3_3_EL1		sys_reg(3, 0, 0, 3, 3)
+#define	SYS_ID_REG_3_7_EL1		sys_reg(3, 0, 0, 3, 7)
+
+#define	SYS_ID_REG_4_2_EL1		sys_reg(3, 0, 0, 4, 2)
+#define	SYS_ID_REG_4_3_EL1		sys_reg(3, 0, 0, 4, 3)
+#define	SYS_ID_REG_4_5_EL1		sys_reg(3, 0, 0, 4, 5)
+#define	SYS_ID_REG_4_6_EL1		sys_reg(3, 0, 0, 4, 6)
+#define	SYS_ID_REG_4_7_EL1		sys_reg(3, 0, 0, 4, 7)
+
+#define	SYS_ID_REG_5_2_EL1		sys_reg(3, 0, 0, 5, 2)
+#define	SYS_ID_REG_5_3_EL1		sys_reg(3, 0, 0, 5, 3)
+#define	SYS_ID_REG_5_6_EL1		sys_reg(3, 0, 0, 5, 6)
+#define	SYS_ID_REG_5_7_EL1		sys_reg(3, 0, 0, 5, 7)
+
+#define	SYS_ID_REG_6_2_EL1		sys_reg(3, 0, 0, 6, 2)
+#define	SYS_ID_REG_6_3_EL1		sys_reg(3, 0, 0, 6, 3)
+#define	SYS_ID_REG_6_4_EL1		sys_reg(3, 0, 0, 6, 4)
+#define	SYS_ID_REG_6_5_EL1		sys_reg(3, 0, 0, 6, 5)
+#define	SYS_ID_REG_6_6_EL1		sys_reg(3, 0, 0, 6, 6)
+#define	SYS_ID_REG_6_7_EL1		sys_reg(3, 0, 0, 6, 7)
+
+#define	SYS_ID_REG_7_3_EL1		sys_reg(3, 0, 0, 7, 3)
+#define	SYS_ID_REG_7_4_EL1		sys_reg(3, 0, 0, 7, 4)
+#define	SYS_ID_REG_7_5_EL1		sys_reg(3, 0, 0, 7, 5)
+#define	SYS_ID_REG_7_6_EL1		sys_reg(3, 0, 0, 7, 6)
+#define	SYS_ID_REG_7_7_EL1		sys_reg(3, 0, 0, 7, 7)
+
+#define	READ_ID_REG_FN(name)	read_## name ## _EL1
+
+#define	DEFINE_READ_SYS_REG(reg_name)			\
+uint64_t read_##reg_name(void)				\
+{							\
+	return read_sysreg_s(SYS_##reg_name);		\
+}
+
+#define DEFINE_READ_ID_REG(name)	\
+	DEFINE_READ_SYS_REG(name ## _EL1)
+
+#define	__ID_REG(reg_name)		\
+	.name = #reg_name,		\
+	.id = SYS_## reg_name ##_EL1,	\
+	.read_reg = READ_ID_REG_FN(reg_name),
+
+#define	ID_REG_ENT(reg_name)	\
+	[ID_IDX(reg_name)] = { __ID_REG(reg_name) }
+
+/* Functions to read each ID register */
+/* CRm=1 */
+DEFINE_READ_ID_REG(ID_PFR0)
+DEFINE_READ_ID_REG(ID_PFR1)
+DEFINE_READ_ID_REG(ID_DFR0)
+DEFINE_READ_ID_REG(ID_AFR0)
+DEFINE_READ_ID_REG(ID_MMFR0)
+DEFINE_READ_ID_REG(ID_MMFR1)
+DEFINE_READ_ID_REG(ID_MMFR2)
+DEFINE_READ_ID_REG(ID_MMFR3)
+
+/* CRm=2 */
+DEFINE_READ_ID_REG(ID_ISAR0)
+DEFINE_READ_ID_REG(ID_ISAR1)
+DEFINE_READ_ID_REG(ID_ISAR2)
+DEFINE_READ_ID_REG(ID_ISAR3)
+DEFINE_READ_ID_REG(ID_ISAR4)
+DEFINE_READ_ID_REG(ID_ISAR5)
+DEFINE_READ_ID_REG(ID_MMFR4)
+DEFINE_READ_ID_REG(ID_ISAR6)
+
+/* CRm=3 */
+DEFINE_READ_ID_REG(MVFR0)
+DEFINE_READ_ID_REG(MVFR1)
+DEFINE_READ_ID_REG(MVFR2)
+DEFINE_READ_ID_REG(ID_REG_3_3)
+DEFINE_READ_ID_REG(ID_PFR2)
+DEFINE_READ_ID_REG(ID_DFR1)
+DEFINE_READ_ID_REG(ID_MMFR5)
+DEFINE_READ_ID_REG(ID_REG_3_7)
+
+/* CRm=4 */
+DEFINE_READ_ID_REG(ID_AA64PFR0)
+DEFINE_READ_ID_REG(ID_AA64PFR1)
+DEFINE_READ_ID_REG(ID_REG_4_2)
+DEFINE_READ_ID_REG(ID_REG_4_3)
+DEFINE_READ_ID_REG(ID_AA64ZFR0)
+DEFINE_READ_ID_REG(ID_REG_4_5)
+DEFINE_READ_ID_REG(ID_REG_4_6)
+DEFINE_READ_ID_REG(ID_REG_4_7)
+
+/* CRm=5 */
+DEFINE_READ_ID_REG(ID_AA64DFR0)
+DEFINE_READ_ID_REG(ID_AA64DFR1)
+DEFINE_READ_ID_REG(ID_REG_5_2)
+DEFINE_READ_ID_REG(ID_REG_5_3)
+DEFINE_READ_ID_REG(ID_AA64AFR0)
+DEFINE_READ_ID_REG(ID_AA64AFR1)
+DEFINE_READ_ID_REG(ID_REG_5_6)
+DEFINE_READ_ID_REG(ID_REG_5_7)
+
+/* CRm=6 */
+DEFINE_READ_ID_REG(ID_AA64ISAR0)
+DEFINE_READ_ID_REG(ID_AA64ISAR1)
+DEFINE_READ_ID_REG(ID_REG_6_2)
+DEFINE_READ_ID_REG(ID_REG_6_3)
+DEFINE_READ_ID_REG(ID_REG_6_4)
+DEFINE_READ_ID_REG(ID_REG_6_5)
+DEFINE_READ_ID_REG(ID_REG_6_6)
+DEFINE_READ_ID_REG(ID_REG_6_7)
+
+/* CRm=7 */
+DEFINE_READ_ID_REG(ID_AA64MMFR0)
+DEFINE_READ_ID_REG(ID_AA64MMFR1)
+DEFINE_READ_ID_REG(ID_AA64MMFR2)
+DEFINE_READ_ID_REG(ID_REG_7_3)
+DEFINE_READ_ID_REG(ID_REG_7_4)
+DEFINE_READ_ID_REG(ID_REG_7_5)
+DEFINE_READ_ID_REG(ID_REG_7_6)
+DEFINE_READ_ID_REG(ID_REG_7_7)
+
+#define	ID_IDX(name)	REG_IDX_## name
+
+enum id_reg_idx {
+	/* CRm=1 */
+	ID_IDX(ID_PFR0) = 0,
+	ID_IDX(ID_PFR1),
+	ID_IDX(ID_DFR0),
+	ID_IDX(ID_AFR0),
+	ID_IDX(ID_MMFR0),
+	ID_IDX(ID_MMFR1),
+	ID_IDX(ID_MMFR2),
+	ID_IDX(ID_MMFR3),
+
+	/* CRm=2 */
+	ID_IDX(ID_ISAR0),
+	ID_IDX(ID_ISAR1),
+	ID_IDX(ID_ISAR2),
+	ID_IDX(ID_ISAR3),
+	ID_IDX(ID_ISAR4),
+	ID_IDX(ID_ISAR5),
+	ID_IDX(ID_MMFR4),
+	ID_IDX(ID_ISAR6),
+
+	/* CRm=3 */
+	ID_IDX(MVFR0),
+	ID_IDX(MVFR1),
+	ID_IDX(MVFR2),
+	ID_IDX(ID_REG_3_3),
+	ID_IDX(ID_PFR2),
+	ID_IDX(ID_DFR1),
+	ID_IDX(ID_MMFR5),
+	ID_IDX(ID_REG_3_7),
+
+	/* CRm=4 */
+	ID_IDX(ID_AA64PFR0),
+	ID_IDX(ID_AA64PFR1),
+	ID_IDX(ID_REG_4_2),
+	ID_IDX(ID_REG_4_3),
+	ID_IDX(ID_AA64ZFR0),
+	ID_IDX(ID_REG_4_5),
+	ID_IDX(ID_REG_4_6),
+	ID_IDX(ID_REG_4_7),
+
+	/* CRm=5 */
+	ID_IDX(ID_AA64DFR0),
+	ID_IDX(ID_AA64DFR1),
+	ID_IDX(ID_REG_5_2),
+	ID_IDX(ID_REG_5_3),
+	ID_IDX(ID_AA64AFR0),
+	ID_IDX(ID_AA64AFR1),
+	ID_IDX(ID_REG_5_6),
+	ID_IDX(ID_REG_5_7),
+
+	/* CRm=6 */
+	ID_IDX(ID_AA64ISAR0),
+	ID_IDX(ID_AA64ISAR1),
+	ID_IDX(ID_REG_6_2),
+	ID_IDX(ID_REG_6_3),
+	ID_IDX(ID_REG_6_4),
+	ID_IDX(ID_REG_6_5),
+	ID_IDX(ID_REG_6_6),
+	ID_IDX(ID_REG_6_7),
+
+	/* CRm=7 */
+	ID_IDX(ID_AA64MMFR0),
+	ID_IDX(ID_AA64MMFR1),
+	ID_IDX(ID_AA64MMFR2),
+	ID_IDX(ID_REG_7_3),
+	ID_IDX(ID_REG_7_4),
+	ID_IDX(ID_REG_7_5),
+	ID_IDX(ID_REG_7_6),
+	ID_IDX(ID_REG_7_7),
+};
+
+struct id_reg_test_info {
+	char		*name;
+	uint32_t	id;
+	/* Indicates the register can be set to 0 */
+	bool		can_clear;
+	uint64_t	initial_value;
+	uint64_t	current_value;
+	uint64_t	(*read_reg)(void);
+};
+
+#define	ID_REG_INFO(name)	(&id_reg_list[ID_IDX(name)])
+static struct id_reg_test_info id_reg_list[] = {
+	/* CRm=1 */
+	ID_REG_ENT(ID_PFR0),
+	ID_REG_ENT(ID_PFR1),
+	ID_REG_ENT(ID_DFR0),
+	ID_REG_ENT(ID_AFR0),
+	ID_REG_ENT(ID_MMFR0),
+	ID_REG_ENT(ID_MMFR1),
+	ID_REG_ENT(ID_MMFR2),
+	ID_REG_ENT(ID_MMFR3),
+
+	/* CRm=2 */
+	ID_REG_ENT(ID_ISAR0),
+	ID_REG_ENT(ID_ISAR1),
+	ID_REG_ENT(ID_ISAR2),
+	ID_REG_ENT(ID_ISAR3),
+	ID_REG_ENT(ID_ISAR4),
+	ID_REG_ENT(ID_ISAR5),
+	ID_REG_ENT(ID_MMFR4),
+	ID_REG_ENT(ID_ISAR6),
+
+	/* CRm=3 */
+	ID_REG_ENT(MVFR0),
+	ID_REG_ENT(MVFR1),
+	ID_REG_ENT(MVFR2),
+	ID_REG_ENT(ID_REG_3_3),
+	ID_REG_ENT(ID_PFR2),
+	ID_REG_ENT(ID_DFR1),
+	ID_REG_ENT(ID_MMFR5),
+	ID_REG_ENT(ID_REG_3_7),
+
+	/* CRm=4 */
+	ID_REG_ENT(ID_AA64PFR0),
+	ID_REG_ENT(ID_AA64PFR1),
+	ID_REG_ENT(ID_REG_4_2),
+	ID_REG_ENT(ID_REG_4_3),
+	ID_REG_ENT(ID_AA64ZFR0),
+	ID_REG_ENT(ID_REG_4_5),
+	ID_REG_ENT(ID_REG_4_6),
+	ID_REG_ENT(ID_REG_4_7),
+
+	/* CRm=5 */
+	ID_REG_ENT(ID_AA64DFR0),
+	ID_REG_ENT(ID_AA64DFR1),
+	ID_REG_ENT(ID_REG_5_2),
+	ID_REG_ENT(ID_REG_5_3),
+	ID_REG_ENT(ID_AA64AFR0),
+	ID_REG_ENT(ID_AA64AFR1),
+	ID_REG_ENT(ID_REG_5_6),
+	ID_REG_ENT(ID_REG_5_7),
+
+	/* CRm=6 */
+	ID_REG_ENT(ID_AA64ISAR0),
+	ID_REG_ENT(ID_AA64ISAR1),
+	ID_REG_ENT(ID_REG_6_2),
+	ID_REG_ENT(ID_REG_6_3),
+	ID_REG_ENT(ID_REG_6_4),
+	ID_REG_ENT(ID_REG_6_5),
+	ID_REG_ENT(ID_REG_6_6),
+	ID_REG_ENT(ID_REG_6_7),
+
+	/* CRm=7 */
+	ID_REG_ENT(ID_AA64MMFR0),
+	ID_REG_ENT(ID_AA64MMFR1),
+	ID_REG_ENT(ID_AA64MMFR2),
+	ID_REG_ENT(ID_REG_7_3),
+	ID_REG_ENT(ID_REG_7_4),
+	ID_REG_ENT(ID_REG_7_5),
+	ID_REG_ENT(ID_REG_7_6),
+	ID_REG_ENT(ID_REG_7_7),
+};
+
+static bool aarch32_support = true;
+
+/* Utilities to get a feature field from ID register value */
+static inline int
+cpuid_signed_field_width(uint64_t id_val, int field, int width)
+{
+	return (s64)(id_val << (64 - width - field)) >> (64 - width);
+}
+
+static unsigned int
+cpuid_unsigned_field_width(uint64_t id_val, int field, int width)
+{
+	return (uint64_t)(id_val << (64 - width - field)) >> (64 - width);
+}
+
+static inline int __attribute_const__
+cpuid_extract_field_width(uint64_t id_val, int field, int width, bool sign)
+{
+	return (sign) ? cpuid_signed_field_width(id_val, field, width) :
+			cpuid_unsigned_field_width(id_val, field, width);
+}
+
+#define is_id_reg(id)	\
+	(sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&	\
+	 sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 0 &&	\
+	 sys_reg_CRm(id) < 8)
+
+#define	GET_ID_FIELD(regval, shift, is_signed)	\
+	cpuid_extract_field_width(regval, shift, 4, is_signed)
+
+#define	GET_ID_UFIELD(regval, shift)	\
+	cpuid_unsigned_field_width(regval, shift, 4)
+
+#define	UPDATE_ID_UFIELD(regval, shift, fval)	\
+	(((regval) & ~(0xfULL << (shift))) |	\
+	 (((uint64_t)((fval) & 0xf)) << (shift)))
+
+void pmu_init(struct kvm_vm *vm, uint32_t vcpu)
+{
+	struct kvm_device_attr attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
+	};
+	vcpu_ioctl(vm, vcpu, KVM_SET_DEVICE_ATTR, &attr);
+}
+
+void sve_init(struct kvm_vm *vm, uint32_t vcpu)
+{
+	int feature = KVM_ARM_VCPU_SVE;
+
+	vcpu_ioctl(vm, vcpu, KVM_ARM_VCPU_FINALIZE, &feature);
+}
+
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
+
+void test_vgic_init(struct kvm_vm *vm, uint32_t vcpu)
+{
+	/* We jsut need to configure gic v3 (we don't use it though) */
+	vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+}
+
+static bool is_aarch32_id_reg(uint32_t id)
+{
+	uint32_t crm, op2;
+
+	if (!is_id_reg(id))
+		return false;
+
+	crm = sys_reg_CRm(id);
+	op2 = sys_reg_Op2(id);
+	if (crm == 1 || crm == 2 || (crm == 3 && (op2 != 3 && op2 != 7)))
+		/* AArch32 ID register */
+		return true;
+
+	return false;
+}
+
+#define	MAX_CAPS	2
+struct feature_test_info {
+	char	*name;	/* Feature Name (Debug information) */
+
+	/* ID register that identifies the presence of the feature */
+	struct id_reg_test_info	*sreg;
+
+	/*
+	 * Bit position of the ID register field that identifies
+	 * the presence of the feature.
+	 */
+	int	shift;
+
+	/* Min value of the field that indicates the presence of the feature. */
+	int	min;
+	bool	is_sign;	/* Is the field signed or unsigned ? */
+	int	ncaps;		/* Number of valid Capabilities in caps[] */
+
+	/* KVM_CAP_* Capabilities to indicates that KVM supports this feature */
+	long	caps[MAX_CAPS];
+
+	/* struct kvm_enable_cap to use the capability if needed */
+	struct kvm_enable_cap	*opt_in_cap;
+
+	/* Should the guest check the ID register for this feature ? */
+	bool	run_test;
+
+	/*
+	 * Extra initialization function to enable the feature if needed.
+	 * (e.g. KVM_ARM_VCPU_FINALIZE for SVE)
+	 */
+	void	(*init_feature)(struct kvm_vm *vm, uint32_t vcpuid);
+
+	/* struct kvm_vcpu_init to opt-in the feature if needed */
+	struct kvm_vcpu_init	*vcpu_init;
+};
+
+/* Information for opt-in CPU features */
+static struct feature_test_info feature_test_info_table[] = {
+	{
+		.name = "SVE",
+		.sreg = ID_REG_INFO(ID_AA64PFR0),
+		.shift = ID_AA64PFR0_SVE_SHIFT,
+		.min = 1,
+		.caps = {KVM_CAP_ARM_SVE},
+		.ncaps = 1,
+		.init_feature = sve_init,
+		.vcpu_init = &(struct kvm_vcpu_init) {
+			.features = {1ULL << KVM_ARM_VCPU_SVE},
+		},
+	},
+	{
+		.name = "GIC",
+		.sreg = ID_REG_INFO(ID_AA64PFR0),
+		.shift = ID_AA64PFR0_GIC_SHIFT,
+		.min = 1,
+		.caps = {KVM_CAP_IRQCHIP},
+		.ncaps = 1,
+		.init_feature = test_vgic_init,
+	},
+	{
+		.name = "MTE",
+		.sreg = ID_REG_INFO(ID_AA64PFR1),
+		.shift = ID_AA64PFR1_MTE_SHIFT,
+		.min = 2,
+		.caps = {KVM_CAP_ARM_MTE},
+		.ncaps = 1,
+		.opt_in_cap = &(struct kvm_enable_cap) {
+				.cap = KVM_CAP_ARM_MTE,
+		},
+	},
+	{
+		.name = "PMUV3",
+		.sreg = ID_REG_INFO(ID_AA64DFR0),
+		.shift = ID_AA64DFR0_PMUVER_SHIFT,
+		.min = 1,
+		.init_feature = pmu_init,
+		.caps = {KVM_CAP_ARM_PMU_V3},
+		.ncaps = 1,
+		.vcpu_init = &(struct kvm_vcpu_init) {
+			.features = {1ULL << KVM_ARM_VCPU_PMU_V3},
+		},
+	},
+	{
+		.name = "PERFMON",
+		.sreg = ID_REG_INFO(ID_DFR0),
+		.shift = ID_DFR0_PERFMON_SHIFT,
+		.min = 3,
+		.init_feature = pmu_init,
+		.caps = {KVM_CAP_ARM_PMU_V3},
+		.ncaps = 1,
+		.vcpu_init = &(struct kvm_vcpu_init) {
+			.features = {1ULL << KVM_ARM_VCPU_PMU_V3},
+		},
+	},
+};
+
+static void walk_id_reg_list(void (*fn)(struct id_reg_test_info *r, void *arg),
+			     void *arg)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_list); i++)
+		fn(&id_reg_list[i], arg);
+}
+
+static void guest_code_id_reg_check_one(struct id_reg_test_info *idr, void *arg)
+{
+	uint64_t v = idr->read_reg();
+
+	GUEST_ASSERT_2(v == idr->current_value, idr->name, idr->current_value);
+}
+
+static void guest_code_id_reg_check_all(uint32_t cpu)
+{
+	walk_id_reg_list(guest_code_id_reg_check_one, NULL);
+	GUEST_DONE();
+}
+
+static void guest_code_do_nothing(uint32_t cpu)
+{
+	GUEST_DONE();
+}
+
+static void guest_code_feature_check(uint32_t cpu)
+{
+	int i;
+	struct feature_test_info *finfo;
+
+	for (i = 0; i < ARRAY_SIZE(feature_test_info_table); i++) {
+		finfo = &feature_test_info_table[i];
+		if (finfo->run_test)
+			guest_code_id_reg_check_one(finfo->sreg, NULL);
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_code_ptrauth_check(uint32_t cpuid)
+{
+	struct id_reg_test_info *sreg = ID_REG_INFO(ID_AA64ISAR1);
+	uint64_t val = sreg->read_reg();
+
+	GUEST_ASSERT_2(val == sreg->current_value, "PTRAUTH", val);
+	GUEST_DONE();
+}
+
+static void reset_id_reg_info_current_value(struct id_reg_test_info *info,
+					    void *arg)
+{
+	info->current_value = info->initial_value;
+}
+
+/* Reset current_value field of each id_reg_test_info */
+static void reset_id_reg_info(void)
+{
+	walk_id_reg_list(reset_id_reg_info_current_value, NULL);
+}
+
+static struct kvm_vm *test_vm_create(uint32_t nvcpus,
+		void (*guest_code)(uint32_t), struct kvm_vcpu_init *init,
+		struct kvm_enable_cap *cap)
+{
+	struct kvm_vm *vm;
+	uint32_t cpuid;
+	uint64_t mem_pages;
+
+	mem_pages = DEFAULT_GUEST_PHY_PAGES + DEFAULT_STACK_PGS * nvcpus;
+	mem_pages += mem_pages / (PTES_PER_MIN_PAGE * 2);
+	mem_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, mem_pages);
+
+	vm = vm_create(VM_MODE_DEFAULT, mem_pages, O_RDWR);
+	if (cap)
+		vm_enable_cap(vm, cap);
+
+	kvm_vm_elf_load(vm, program_invocation_name);
+
+	if (init && init->target == -1) {
+		struct kvm_vcpu_init preferred;
+
+		vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
+		init->target = preferred.target;
+	}
+
+	vm_init_descriptor_tables(vm);
+	for (cpuid = 0; cpuid < nvcpus; cpuid++) {
+		aarch64_vcpu_add_default(vm, cpuid, init, guest_code);
+		vcpu_init_descriptor_tables(vm, cpuid);
+	}
+
+	ucall_init(vm, NULL);
+	return vm;
+}
+
+static void test_vm_free(struct kvm_vm *vm)
+{
+	ucall_uninit(vm);
+	kvm_vm_free(vm);
+}
+
+#define	TEST_RUN(vm, cpu)	\
+	(test_vcpu_run(__func__, __LINE__, vm, cpu, true))
+
+#define	TEST_RUN_NO_SYNC_DATA(vm, cpu)	\
+	(test_vcpu_run(__func__, __LINE__, vm, cpu, false))
+
+static int test_vcpu_run(const char *test_name, int line,
+			 struct kvm_vm *vm, uint32_t vcpuid, bool sync_data)
+{
+	struct ucall uc;
+	int ret;
+
+	if (sync_data) {
+		sync_global_to_guest(vm, id_reg_list);
+		sync_global_to_guest(vm, feature_test_info_table);
+	}
+
+	vcpu_args_set(vm, vcpuid, 1, vcpuid);
+
+	ret = _vcpu_run(vm, vcpuid);
+	if (ret) {
+		ret = errno;
+		goto sync_exit;
+	}
+
+	switch (get_ucall(vm, vcpuid, &uc)) {
+	case UCALL_SYNC:
+	case UCALL_DONE:
+		ret = 0;
+		break;
+	case UCALL_ABORT:
+		TEST_FAIL(
+		    "%s (%s) at line %d (user %s at line %d), args[3]=0x%lx",
+		    (char *)uc.args[0], (char *)uc.args[2], (int)uc.args[1],
+		    test_name, line, uc.args[3]);
+		break;
+	default:
+		TEST_FAIL("Unexpected guest exit\n");
+	}
+
+sync_exit:
+	if (sync_data) {
+		sync_global_from_guest(vm, id_reg_list);
+		sync_global_from_guest(vm, feature_test_info_table);
+	}
+	return ret;
+}
+
+struct vm_vcpu_arg {
+	struct kvm_vm	*vm;
+	uint32_t	vcpuid;
+	bool		after_run;
+};
+
+/*
+ * Test if KVM_SET_ONE_REG can work with the value KVM_GET_ONE_REG returns,
+ * KVM_SET_ONE_REG with zero works before KVM_RUN (and fails after KVM_RUN),
+ * and KVM_GET_ONE_REG returns the value KVM_SET_ONE_REG sets.
+ */
+static void test_get_set_id_reg(struct id_reg_test_info *sreg, void *arg)
+{
+	struct kvm_vm *vm = ((struct vm_vcpu_arg *)arg)->vm;
+	uint32_t vcpuid = ((struct vm_vcpu_arg *)arg)->vcpuid;
+	bool after_run = ((struct vm_vcpu_arg *)arg)->after_run;
+	struct kvm_one_reg one_reg;
+	uint64_t reg_val, tval;
+	int ret;
+
+	one_reg.addr = (uint64_t)&reg_val;
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+
+	/* Check the current register value */
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+	TEST_ASSERT(reg_val == sreg->current_value,
+		    "GET(%s) didn't return 0x%lx but 0x%lx",
+		    sreg->name, sreg->current_value, reg_val);
+	tval = reg_val;
+
+	/* Try to clear the register that should be able to be cleared. */
+	if ((reg_val != 0) && (sreg->can_clear)) {
+		reg_val = 0;
+		ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
+		if (after_run) {
+			/* Expect an error after KVM_RUN */
+			TEST_ASSERT(ret,
+				    "Clearing %s unexpectedly worked\n",
+				    sreg->name);
+		} else {
+			TEST_ASSERT(!ret,
+				    "Clearing %s didn't work\n", sreg->name);
+			/*
+			 * Make sure that KVM_GET_ONE_REG provides the value
+			 * we set.
+			 */
+			vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+			TEST_ASSERT(reg_val == 0,
+				    "GET(%s) didn't return 0x%lx but 0x%lx",
+				    sreg->name, (uint64_t)0, reg_val);
+		}
+	}
+
+	/* Check if KVM_SET_ONE_REG works with the original value. */
+	reg_val = tval;
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
+	TEST_ASSERT(ret == 0, "Setting the same ID reg value should work\n");
+
+	/* Make sure that KVM_GET_ONE_REG provides the value we set. */
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+	TEST_ASSERT(reg_val == tval,
+		    "GET(%s) didn't return 0x%lx but 0x%lx",
+		    sreg->name, sreg->current_value, reg_val);
+}
+
+/*
+ * Test if KVM_SET_ONE_REG with the current value works before KVM_RUN,
+ * values of ID registers the guest sees are consistent with the ones
+ * userspace sees, and KVM_SET_ONE_REG after KVM_RUN works when the
+ * specified value is the same as the current one (fails otherwise).
+ */
+static void test_id_regs_basic(void)
+{
+	struct kvm_vm *vm;
+	struct vm_vcpu_arg arg = { .vcpuid = 0 };
+	int ret;
+
+	reset_id_reg_info();
+
+	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL, NULL);
+
+	arg.vm = vm;
+	walk_id_reg_list(test_get_set_id_reg, &arg);
+
+	ret = TEST_RUN(vm, 0);
+	assert(!ret);
+
+	arg.after_run = true;
+	walk_id_reg_list(test_get_set_id_reg, &arg);
+
+	test_vm_free(vm);
+}
+
+static bool caps_are_supported(long *caps, int ncaps)
+{
+	int i;
+
+	for (i = 0; i < ncaps; i++) {
+		if (kvm_check_cap(caps[i]) <= 0)
+			return false;
+	}
+	return true;
+}
+
+#define	NCAPS_PTRAUTH	2
+
+/*
+ * Test if the ID register value reflects the ptrauth feature configuration.
+ * KVM_SET_ONE_REG should work as long as the requested value is consistent
+ * with the ptrauth feature configuration.
+ */
+static void test_feature_ptrauth(void)
+{
+	struct kvm_one_reg one_reg;
+	struct kvm_vcpu_init init;
+	struct kvm_vm *vm = NULL;
+	struct id_reg_test_info *sreg = ID_REG_INFO(ID_AA64ISAR1);
+	uint32_t vcpu = 0;
+	int64_t rval;
+	int ret;
+	int apa, api, gpa, gpi;
+	char *name = "PTRAUTH";
+	long caps[NCAPS_PTRAUTH] = {KVM_CAP_ARM_PTRAUTH_ADDRESS,
+				    KVM_CAP_ARM_PTRAUTH_GENERIC};
+
+	reset_id_reg_info();
+	one_reg.addr = (uint64_t)&rval;
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+
+	if (caps_are_supported(caps, NCAPS_PTRAUTH)) {
+
+		/* Test with feature enabled */
+		memset(&init, 0, sizeof(init));
+		init.target = -1;
+		init.features[0] = (1ULL << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
+				    1ULL << KVM_ARM_VCPU_PTRAUTH_GENERIC);
+		vm = test_vm_create(1, guest_code_ptrauth_check, &init, NULL);
+		vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
+
+		/* Make sure values of apa/api/gpa/gpi fields are expected */
+		apa = GET_ID_UFIELD(rval, ID_AA64ISAR1_APA_SHIFT);
+		api = GET_ID_UFIELD(rval, ID_AA64ISAR1_API_SHIFT);
+		gpa = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPA_SHIFT);
+		gpi = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPI_SHIFT);
+
+		TEST_ASSERT((apa > 0) || (api > 0),
+			    "Either apa(0x%x) or api(0x%x) must be available",
+			    apa, gpa);
+		TEST_ASSERT((gpa > 0) || (gpi > 0),
+			    "Either gpa(0x%x) or gpi(0x%x) must be available",
+			    gpa, gpi);
+
+		TEST_ASSERT((apa > 0) ^ (api > 0),
+			    "Both apa(0x%x) and api(0x%x) must not be available",
+			    apa, api);
+		TEST_ASSERT((gpa > 0) ^ (gpi > 0),
+			    "Both gpa(0x%x) and gpi(0x%x) must not be available",
+			    gpa, gpi);
+
+		sreg->current_value = rval;
+
+		pr_debug("%s: Test with %s enabled (%s: 0x%lx)\n",
+			 __func__, name, sreg->name, sreg->current_value);
+
+		/* Make sure that the guest sees the same ID register value. */
+		ret = TEST_RUN(vm, vcpu);
+
+		TEST_ASSERT(!ret, "%s:KVM_RUN failed with %s enabled",
+			    __func__, name);
+		test_vm_free(vm);
+	}
+
+	reset_id_reg_info();
+
+	/* Test with feature disabled */
+	vm = test_vm_create(1, guest_code_feature_check, NULL, NULL);
+	vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
+
+	apa = GET_ID_UFIELD(rval, ID_AA64ISAR1_APA_SHIFT);
+	api = GET_ID_UFIELD(rval, ID_AA64ISAR1_API_SHIFT);
+	gpa = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPA_SHIFT);
+	gpi = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPI_SHIFT);
+	TEST_ASSERT(!apa && !api && !gpa && !gpi,
+	    "apa(0x%x), api(0x%x), gpa(0x%x), gpi(0x%x) must be zero",
+	    apa, api, gpa, gpi);
+
+	pr_debug("%s: Test with %s disabled (%s: 0x%lx)\n",
+		 __func__, name, sreg->name, sreg->current_value);
+
+	/* Make sure that the guest sees the same ID register value. */
+	ret = TEST_RUN(vm, vcpu);
+	TEST_ASSERT(!ret, "%s TEST_RUN failed with %s enabled, ret=0x%x",
+		    __func__, name, ret);
+
+	test_vm_free(vm);
+}
+
+static bool feature_caps_are_available(struct feature_test_info *finfo)
+{
+	return ((finfo->ncaps > 0) &&
+		caps_are_supported(finfo->caps, finfo->ncaps));
+}
+
+/*
+ * Test if the ID register value reflects the feature configuration.
+ * KVM_SET_ONE_REG should work as long as the requested value is
+ * consistent with the feature configuration.
+ */
+static void test_feature(struct feature_test_info *finfo)
+{
+	struct id_reg_test_info *sreg = finfo->sreg;
+	struct kvm_one_reg one_reg;
+	struct kvm_vcpu_init init, *initp = NULL;
+	struct kvm_vm *vm = NULL;
+	int64_t fval, reg_val;
+	uint32_t vcpu = 0;
+	bool is_sign = finfo->is_sign;
+	int min = finfo->min;
+	int shift = finfo->shift;
+	int ret;
+
+	pr_debug("%s: %s (reg %s)\n", __func__, finfo->name, sreg->name);
+
+	reset_id_reg_info();
+
+	if (is_aarch32_id_reg(sreg->id) && !aarch32_support)
+		/*
+		 * AArch32 is not supported. Skip testing with the AArch32
+		 * ID register.
+		 */
+		return;
+
+	/* Indicate that guest runs the test for the feature */
+	finfo->run_test = 1;
+	one_reg.addr = (uint64_t)&reg_val;
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+
+	/*
+	 * Test with feature enabled if the feature is exposed in the default
+	 * ID register value or the capabilities are supported at KVM level.
+	 */
+	if ((GET_ID_FIELD(sreg->initial_value, shift, is_sign) >= min) ||
+	    feature_caps_are_available(finfo)) {
+		if (finfo->vcpu_init) {
+			/* Need to enable the feature via KVM_ARM_VCPU_INIT. */
+			memset(&init, 0, sizeof(init));
+			init = *finfo->vcpu_init;
+			init.target = -1;
+			initp = &init;
+		}
+
+		vm = test_vm_create(1, guest_code_feature_check, initp,
+				    finfo->opt_in_cap);
+		if (finfo->init_feature)
+			/* Run any required extra process to use the feature */
+			finfo->init_feature(vm, vcpu);
+
+		/* Check if the ID register value indicates the feature */
+		vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
+		fval = GET_ID_FIELD(reg_val, shift, is_sign);
+		TEST_ASSERT(fval >= min, "%s field of %s is too small (%ld)",
+			    finfo->name, sreg->name, fval);
+		sreg->current_value = reg_val;
+
+		pr_debug("%s: Test with %s enabled (%s: 0x%lx)\n", __func__,
+			 finfo->name, sreg->name, sreg->current_value);
+
+		/* Make sure that the guest sees the same ID register value. */
+		ret = TEST_RUN(vm, vcpu);
+		TEST_ASSERT(!ret, "%s:TEST_RUN failed with %s enabled",
+			    __func__, finfo->name);
+
+		test_vm_free(vm);
+	}
+
+	reset_id_reg_info();
+
+	/* Test with feature disabled */
+	vm = test_vm_create(1, guest_code_feature_check, NULL, NULL);
+	vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
+	fval = GET_ID_FIELD(reg_val, shift, is_sign);
+	if (finfo->vcpu_init || finfo->opt_in_cap) {
+		/*
+		 * If the feature needs to be enabled with KVM_ARM_VCPU_INIT
+		 * or opt-in capabilities, the default value of the ID register
+		 * shouldn't indicate the feature.
+		 */
+		TEST_ASSERT(fval < min, "%s field of %s is too big (%ld)",
+		    finfo->name, sreg->name, fval);
+	} else {
+		/* Update the relevant field to hide the feature. */
+		fval = is_sign ? 0xf : 0x0;
+		reg_val = UPDATE_ID_UFIELD(reg_val, shift, fval);
+		ret = _vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
+		TEST_ASSERT(ret == 0, "Disabling %s failed %d\n",
+			    finfo->name, ret);
+		sreg->current_value = reg_val;
+	}
+
+	pr_debug("%s: Test with %s disabled (%s: 0x%lx)\n",
+		 __func__, finfo->name, sreg->name, sreg->current_value);
+
+	/* Make sure that the guest sees the same ID register value. */
+	ret = TEST_RUN(vm, vcpu);
+	finfo->run_test = 0;
+	test_vm_free(vm);
+}
+
+/*
+ * For each opt-in feature in feature_test_info_table[],
+ * test if KVM_GET_ONE_REG/KVM_SET_ONE_REG works appropriately according
+ * to the feature configuration.  See test_feature's comment for more detail.
+ */
+static void test_feature_all(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(feature_test_info_table); i++)
+		test_feature(&feature_test_info_table[i]);
+}
+
+int set_id_reg(struct kvm_vm *vm, uint32_t vcpu, struct id_reg_test_info *sreg,
+	       uint64_t new_val)
+{
+	int ret;
+	uint64_t reg_val;
+	struct kvm_one_reg one_reg;
+
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+	one_reg.addr = (uint64_t)&reg_val;
+
+	reg_val = new_val;
+	ret = _vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
+	if (!ret)
+		sreg->current_value = new_val;
+
+	return ret;
+}
+
+
+/*
+ * Create a new VM with one vCPU, set the ID register to @new_val.
+ */
+int set_id_reg_vm(struct id_reg_test_info *sreg, uint64_t new_val)
+{
+	struct kvm_vm *vm;
+	int ret;
+	uint32_t vcpu = 0;
+
+	reset_id_reg_info();
+
+	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL, NULL);
+	ret = set_id_reg(vm, vcpu, sreg, new_val);
+	test_vm_free(vm);
+
+	return ret;
+}
+
+struct frac_info {
+	char	*name;
+	struct id_reg_test_info *sreg;
+	struct id_reg_test_info *frac_sreg;
+	int	shift;
+	int	frac_shift;
+};
+
+struct frac_info frac_info_table[] = {
+	{
+		.name = "RAS",
+		.sreg = ID_REG_INFO(ID_AA64PFR0),
+		.shift = ID_AA64PFR0_RAS_SHIFT,
+		.frac_sreg = ID_REG_INFO(ID_AA64PFR1),
+		.frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
+	},
+	{
+		.name = "MPAM",
+		.sreg = ID_REG_INFO(ID_AA64PFR0),
+		.shift = ID_AA64PFR0_MPAM_SHIFT,
+		.frac_sreg = ID_REG_INFO(ID_AA64PFR1),
+		.frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
+	},
+	{
+		.name = "CSV2",
+		.sreg = ID_REG_INFO(ID_AA64PFR0),
+		.shift = ID_AA64PFR0_CSV2_SHIFT,
+		.frac_sreg = ID_REG_INFO(ID_AA64PFR1),
+		.frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
+	},
+};
+
+
+/*
+ * Make sure that we can set the fractional reg field even before setting
+ * the feature reg field.
+ */
+int test_feature_frac_vm(struct frac_info *frac, uint64_t new_val,
+			 uint64_t frac_new_val)
+{
+	struct kvm_vm *vm;
+	uint32_t vcpu = 0;
+	struct id_reg_test_info *sreg, *frac_sreg;
+	int ret;
+
+	sreg = frac->sreg;
+	frac_sreg = frac->frac_sreg;
+	reset_id_reg_info();
+
+	reset_id_reg_info();
+
+	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL, NULL);
+
+	/* Set fractional reg field */
+	ret = set_id_reg(vm, vcpu, frac_sreg, frac_new_val);
+	TEST_ASSERT(!ret, "SET_REG(%s=0x%lx) failed, ret=0x%x",
+		    frac_sreg->name, frac_new_val, ret);
+
+	/* Set feature reg field */
+	ret = set_id_reg(vm, vcpu, sreg, new_val);
+	TEST_ASSERT(!ret, "SET_REG(%s=0x%lx) failed, ret=0x%x",
+		    sreg->name, new_val, ret);
+
+	ret = TEST_RUN(vm, vcpu);
+	test_vm_free(vm);
+
+	return ret;
+}
+
+/*
+ * Test for setting the feature fractional field of the ID register.
+ * When the (main) feature field of the ID register is the same as the host's,
+ * the fractional field value cannot be larger than the host's.
+ * (KVM_SET_ONE_REG should work but KVM_RUN with the larger value will fail)
+ * When the (main) feature field of the ID register is smaler than the host's,
+ * the fractional field can be any values.
+ * The function tests those behaviors.
+ */
+void test_feature_frac_one(struct frac_info *frac)
+{
+	uint64_t ftr_val, ftr_fval, frac_val, frac_fval;
+	int ret, shift, frac_shift;
+	struct id_reg_test_info *sreg, *frac_sreg;
+
+	reset_id_reg_info();
+
+	sreg = frac->sreg;
+	shift = frac->shift;
+	frac_sreg = frac->frac_sreg;
+	frac_shift = frac->frac_shift;
+
+	pr_debug("%s(%s Frac) reg:%s(shift:%d) frac reg:%s(shift:%d)\n",
+		 __func__, frac->name, sreg->name, shift, frac_sreg->name,
+		 frac_shift);
+
+	/*
+	 * Use the host's feature value for the guest.
+	 * KVM_RUN with a larger frac value than the host's should fail.
+	 * Otherwise, it should work.
+	 */
+
+	frac_fval = GET_ID_UFIELD(frac_sreg->initial_value, frac_shift);
+	if (frac_fval > 0) {
+		/* Test with smaller frac value */
+		frac_val = UPDATE_ID_UFIELD(frac_sreg->initial_value,
+					    frac_shift, frac_fval - 1);
+		ret = test_feature_frac_vm(frac, sreg->initial_value, frac_val);
+		TEST_ASSERT(!ret, "Test smaller %s frac (val:%lx) failed(%d)",
+			    frac->name, frac_val, ret);
+	}
+
+	reset_id_reg_info();
+
+	if (frac_fval != 0xf) {
+		/* Test with larger frac value */
+		frac_val = UPDATE_ID_UFIELD(frac_sreg->initial_value,
+						frac_shift, frac_fval + 1);
+
+		/* Setting larger frac shouldn't fail at ioctl */
+		ret = set_id_reg_vm(frac_sreg, frac_val);
+		TEST_ASSERT(!ret,
+			"SET larger %s frac (%s org:%lx, val:%lx) failed(%d)",
+			frac->name, frac_sreg->name, frac_sreg->initial_value,
+			frac_val, ret);
+
+		/* KVM_RUN with larger frac should fail */
+		ret = test_feature_frac_vm(frac, sreg->initial_value, frac_val);
+		TEST_ASSERT(ret,
+			"Test with larger %s frac (%s org:%lx, val:%lx) worked",
+			frac->name, frac_sreg->name, frac_sreg->initial_value,
+			frac_val);
+	}
+
+	reset_id_reg_info();
+
+	/*
+	 * Test with a smaller (main) feature value than the host's.
+	 */
+	ftr_fval = GET_ID_UFIELD(sreg->initial_value, shift);
+	if (ftr_fval == 0)
+		/* Cannot set it to the smaller value */
+		return;
+
+	ftr_val = UPDATE_ID_UFIELD(sreg->initial_value, shift, ftr_fval - 1);
+	ret = test_feature_frac_vm(frac, ftr_val, frac_sreg->initial_value);
+	TEST_ASSERT(!ret, "Test with smaller %s (val:%lx) failed(%d)",
+		    frac->name, ftr_val, ret);
+
+	if (frac_fval > 0) {
+		/* Test with smaller frac value */
+		frac_val = UPDATE_ID_UFIELD(frac_sreg->initial_value,
+					    frac_shift, frac_fval - 1);
+		ret = test_feature_frac_vm(frac, ftr_val, frac_val);
+		TEST_ASSERT(!ret,
+		    "Test with smaller %s and frac (val:%lx) failed(%d)",
+		    frac->name, ftr_val, ret);
+	}
+
+	if (frac_fval != 0xf) {
+		/* Test with larger frac value */
+		frac_val = UPDATE_ID_UFIELD(frac_sreg->initial_value,
+					    frac_shift, frac_fval + 1);
+		ret = test_feature_frac_vm(frac, ftr_val, frac_val);
+		TEST_ASSERT(!ret,
+		    "Test with smaller %s and larger frac (val:%lx) failed(%d)",
+		    frac->name, ftr_val, ret);
+	}
+}
+
+/*
+ * Test for setting feature fractional fields of ID registers.
+ * See test_feature_frac_one's comments for more detail.
+ */
+void test_feature_frac_all(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(frac_info_table); i++)
+		test_feature_frac_one(&frac_info_table[i]);
+}
+
+void run_test(void)
+{
+	test_id_regs_basic();
+	test_feature_all();
+	test_feature_ptrauth();
+	test_feature_frac_all();
+}
+
+static void init_id_reg_info_one(struct id_reg_test_info *sreg, void *arg)
+{
+	struct kvm_one_reg one_reg;
+	uint64_t reg_val;
+	struct kvm_vm *vm = ((struct vm_vcpu_arg *)arg)->vm;
+	uint32_t vcpuid = ((struct vm_vcpu_arg *)arg)->vcpuid;
+	int ret;
+
+	one_reg.addr = (uint64_t)&reg_val;
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+	sreg->current_value = reg_val;
+
+	/* Keep the initial value to reset the register value later */
+	sreg->initial_value = reg_val;
+
+	/* Check if the register can be set to 0 */
+	reg_val = 0;
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
+	if (!ret)
+		sreg->can_clear = true;
+
+	pr_debug("%s (0x%x): 0x%lx%s\n", sreg->name, sreg->id,
+		 sreg->initial_value, sreg->can_clear ? ", can clear" : "");
+}
+
+/*
+ * Check if aarch32 is supported, and initialize id_reg_test_info for all
+ * the ID registers.  Loop over the idreg list and populates each id_reg
+ * info with the initial value, current value, and can_clear value.
+ */
+static void init_test_info(void)
+{
+	uint64_t reg_val;
+	int fval;
+	struct kvm_vm *vm;
+	struct kvm_one_reg one_reg;
+	struct vm_vcpu_arg arg = { .vcpuid = 0 };
+
+	vm = test_vm_create(1, guest_code_do_nothing, NULL, NULL);
+
+	/* Get ID_AA64PFR0_EL1 to check if AArch32 is supported */
+	one_reg.addr = (uint64_t)&reg_val;
+	one_reg.id = KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1);
+	vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &one_reg);
+	fval = GET_ID_UFIELD(reg_val, ID_AA64PFR0_EL0_SHIFT);
+	if (fval == 0x1)
+		/* No AArch32 support */
+		aarch32_support = false;
+
+	/* Initialize id_reg_test_info */
+	arg.vm = vm;
+	walk_id_reg_list(init_id_reg_info_one, &arg);
+	test_vm_free(vm);
+}
+
+int main(void)
+{
+
+	setbuf(stdout, NULL);
+
+	if (kvm_check_cap(KVM_CAP_ARM_ID_REG_CONFIGURABLE) <= 0) {
+		print_skip("KVM_CAP_ARM_ID_REG_CONFIGURABLE is not supported");
+		exit(KSFT_SKIP);
+	}
+
+	init_test_info();
+	run_test();
+	return 0;
+}
-- 
2.35.1.265.g69c8d7142f-goog

