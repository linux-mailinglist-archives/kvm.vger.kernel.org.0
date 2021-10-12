Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC6B429CAF
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhJLEjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbhJLEjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:39:05 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F4AC0613E6
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:58 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d5-20020a63ed05000000b002688d3aff8aso8041426pgi.2
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F4iS/JS5o366hKiMrkuWZ9m27Iy2Dx1PXZ2dYLdTzsw=;
        b=Z4DOHzlv3tDZnYeYvu36Uh28AvRZsjq87djOQFxTy0xXLdMlCQ8Q80Xuu8J97J1XIs
         P6f266jDcLR3Ql4nFzGzv8mcuwt9b3hJ6YmU2SZgKRhspV0Ad3QhyrYQAmMS9psKGnCu
         q4bhGDa8BixzYSMcynwhcPL9adtMzR6MakRKWMyBwZ2ChCRA2OLR7+VjyiXZifng9HrI
         Dx/vYD69rbLEAGhR+p2BbO5tDIfLHwUIuFtdFPWWI3e/KS9/FTl8OVFG2WmJ2zNO3Ygr
         /cZdol0rxa8u4EZp43JLZjgewoWssfK38QhJFiy6GYAIQWC02aa2xKo9DTOrrmZ4fQYx
         Rk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F4iS/JS5o366hKiMrkuWZ9m27Iy2Dx1PXZ2dYLdTzsw=;
        b=I8NMeFos+c7kYuHFdCWO59kvBcKoJ1c/iadvNJxWoEWfYyDzty02EzsuJMipwN44xP
         z/jw7dv6PAZkK183dsCOa+/MkXin6Ub+sNL2Y8Q0pRvVTpdTCacFUpSxqaajOuDBXk7v
         rSFrkKggDriF8L56yTh66Vetdv+PVqoXFp0qpD9NZ6PXYMP+EZsY3dH5RA4DP2y0hDwN
         R+t1Ef8UL6EbedfYRn3KlLGWJmF8MSd09jdTPXvZuIV/OuRyxEUZi5M1dPc5N9wZ7PRK
         s0aBvNzWaaSNj1Apba6HixY8tDaTHFo8MgPSQgBsu7VqzMGS0zOWRmBxzaXPOfrq0+YK
         LUKQ==
X-Gm-Message-State: AOAM532rZFbH+kKnaISB0hf7Kn9UYB9+Sd3op3FZi59NzVaG/tfAQ3u2
        lFPDw2HSsuRG9FMlsQm/zcjy8oFSzKU=
X-Google-Smtp-Source: ABdhPJzCS/0Tl2lU28MAYcr0P0HLgAbzU7JMD1Kf0OX1f2fMyWnGT06D5oJk7H+5kedIqmlF7J+VtCj64lo=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90b:1649:: with SMTP id
 il9mr3464381pjb.167.1634013417679; Mon, 11 Oct 2021 21:36:57 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:35 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-26-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 25/25] KVM: arm64: selftests: Introduce id_reg_test
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a test for aarch64 to validate basic behavior of
KVM_GET_ONE_REG and KVM_SET_ONE_REG for ID registers.

This test runs only when KVM_CAP_ARM_ID_REG_WRITABLE is supported.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/arch/arm64/include/asm/sysreg.h         |    1 +
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/id_reg_test.c       | 1296 +++++++++++++++++
 4 files changed, 1299 insertions(+)
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
index 02444fc69bae..82f37dd7faa2 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,6 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
+/aarch64/id_reg_test
 /aarch64/psci_cpu_on_test
 /aarch64/vgic_init
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 79947dde0b66..65e4bb1ebfcb 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -89,6 +89,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
+TEST_GEN_PROGS_aarch64 += aarch64/id_reg_test
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/id_reg_test.c b/tools/testing/selftests/kvm/aarch64/id_reg_test.c
new file mode 100644
index 000000000000..c3ac955e6b2d
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/id_reg_test.c
@@ -0,0 +1,1296 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#define _GNU_SOURCE
+
+#include <stdlib.h>
+#include <time.h>
+#include <pthread.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+
+/*
+ * id_reg_test.c - Tests reading/writing the aarch64's ID registers
+ *
+ * The test validates KVM_SET_ONE_REG/KVM_GET_ONE_REG ioctl for ID
+ * registers as well as reading ID register from the guest works fine.
+ */
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
+	bool		can_clear;
+	uint64_t	fixed_mask;
+	uint64_t	org_val;
+	uint64_t	user_val;
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
+void test_pmu_init(struct kvm_vm *vm, uint32_t vcpu)
+{
+	struct kvm_device_attr attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
+	};
+	vcpu_ioctl(vm, vcpu, KVM_SET_DEVICE_ATTR, &attr);
+}
+
+void test_sve_init(struct kvm_vm *vm, uint32_t vcpu)
+{
+	int feature = KVM_ARM_VCPU_SVE;
+
+	vcpu_ioctl(vm, vcpu, KVM_ARM_VCPU_FINALIZE, &feature);
+}
+
+#define	MAX_CAPS	2
+struct feature_test_info {
+	char	*name;	/* Feature Name (Debug information) */
+	struct id_reg_test_info	*sreg;	/* ID register for the feature */
+	int	shift;	/* Field of the ID register for the feature */
+	int	min;	/* Min value to indicate the feature */
+	bool	is_sign;	/* Is the field signed or unsigned ? */
+	int	ncaps;		/* Number of valid Capabilities in caps[] */
+	long	caps[MAX_CAPS];	/* Capabilities to indicate this feature */
+	/* struct kvm_enable_cap to use the capability if needed */
+	struct kvm_enable_cap	*opt_in_cap;
+	bool	run_test;	/* Does guest run test for this feature ? */
+	/* Initialization function for the feature as needed */
+	void	(*init_feature)(struct kvm_vm *vm, uint32_t vcpuid);
+	/* struct kvm_vcpu_init to opt-in the feature if needed */
+	struct kvm_vcpu_init	*vcpu_init;
+};
+
+/* Test for optin CPU features */
+static struct feature_test_info feature_test_info_table[] = {
+	{
+		.name = "SVE",
+		.sreg = ID_REG_INFO(ID_AA64PFR0),
+		.shift = ID_AA64PFR0_SVE_SHIFT,
+		.min = 1,
+		.caps = {KVM_CAP_ARM_SVE},
+		.ncaps = 1,
+		.init_feature = test_sve_init,
+		.vcpu_init = &(struct kvm_vcpu_init) {
+			.features = {1ULL << KVM_ARM_VCPU_SVE},
+		},
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
+		.init_feature = test_pmu_init,
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
+		.init_feature = test_pmu_init,
+		.caps = {KVM_CAP_ARM_PMU_V3},
+		.ncaps = 1,
+		.vcpu_init = &(struct kvm_vcpu_init) {
+			.features = {1ULL << KVM_ARM_VCPU_PMU_V3},
+		},
+	},
+};
+
+static int walk_id_reg_list(int (*fn)(struct id_reg_test_info *sreg, void *arg),
+			    void *arg)
+{
+	int ret = 0, i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_list); i++) {
+		ret = fn(&id_reg_list[i], arg);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+static int guest_code_id_reg_check_one(struct id_reg_test_info *sreg, void *arg)
+{
+	uint64_t val = sreg->read_reg();
+
+	GUEST_ASSERT_2(val == sreg->user_val, sreg->name, sreg->user_val);
+	return 0;
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
+	GUEST_ASSERT_2(val == sreg->user_val, "PTRAUTH", val);
+	GUEST_DONE();
+}
+
+static int reset_id_reg_info_one(struct id_reg_test_info *sreg, void *arg)
+{
+	sreg->user_val = sreg->org_val;
+	return 0;
+}
+
+static void reset_id_reg_info(void)
+{
+	walk_id_reg_list(reset_id_reg_info_one, NULL);
+}
+
+static struct kvm_vm *test_vm_create_cap(uint32_t nvcpus,
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
+	vm = vm_create(VM_MODE_DEFAULT,
+		DEFAULT_GUEST_PHY_PAGES + (DEFAULT_STACK_PGS * nvcpus),
+		O_RDWR);
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
+		if (init)
+			aarch64_vcpu_add_default(vm, cpuid, init, guest_code);
+		else
+			vm_vcpu_add_default(vm, cpuid, guest_code);
+
+		vcpu_init_descriptor_tables(vm, cpuid);
+	}
+
+	ucall_init(vm, NULL);
+	return vm;
+}
+
+static struct kvm_vm *test_vm_create(uint32_t nvcpus,
+				     void (*guest_code)(uint32_t),
+				     struct kvm_vcpu_init *init)
+{
+	return test_vm_create_cap(nvcpus, guest_code, init, NULL);
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
+static int set_id_regs_after_run_test_one(struct id_reg_test_info *sreg,
+					  void *arg)
+{
+	struct kvm_vm *vm = arg;
+	struct kvm_one_reg one_reg;
+	uint32_t vcpuid = 0;
+	uint64_t reg_val;
+	int ret;
+
+	one_reg.addr = (uint64_t)&reg_val;
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+	if ((reg_val != 0) && (sreg->can_clear)) {
+		reg_val = 0;
+		ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
+		TEST_ASSERT(ret && errno == EINVAL,
+			    "Changing ID reg value should fail\n");
+	}
+
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
+	TEST_ASSERT(ret == 0, "Setting the same ID reg value should work\n");
+
+	return 0;
+}
+
+static int set_id_regs_test_one(struct id_reg_test_info *sreg, void *arg)
+{
+	struct kvm_vm *vm = arg;
+	struct kvm_one_reg one_reg;
+	uint32_t vcpuid = 0;
+	uint64_t reg_val;
+
+	one_reg.addr = (uint64_t)&reg_val;
+	reset_id_reg_info();
+
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+	if (sreg->can_clear) {
+		/* Change the register to 0 when possible */
+		reg_val = 0;
+		vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
+		vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+		TEST_ASSERT(reg_val == 0,
+		    "GET(%s) didn't return 0 but 0x%lx", sreg->name, reg_val);
+	}
+
+	/* Check if we can restore the initial value */
+	reg_val = sreg->org_val;
+	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+	TEST_ASSERT(reg_val == sreg->org_val,
+		    "GET(%s) didn't return 0x%lx but 0x%lx",
+		    sreg->name, sreg->org_val, reg_val);
+	sreg->user_val = sreg->org_val;
+	return 0;
+}
+
+static void set_id_regs_test(void)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	reset_id_reg_info();
+	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL);
+
+	ret = walk_id_reg_list(set_id_regs_test_one, vm);
+	assert(!ret);
+
+	ret = TEST_RUN(vm, 0);
+	TEST_ASSERT(!ret, "%s TEST_RUN failed, ret=0x%x", __func__, ret);
+
+	ret = walk_id_reg_list(set_id_regs_after_run_test_one, vm);
+	assert(!ret);
+}
+
+static int clear_id_reg_when_possible(struct id_reg_test_info *sreg, void *arg)
+{
+	uint64_t reg_val = 0;
+	struct kvm_one_reg one_reg;
+	struct kvm_vm *vm = (struct kvm_vm *)((uint64_t *)arg)[0];
+	uint32_t vcpu = ((uint64_t *)arg)[1];
+
+	if (sreg->can_clear) {
+		assert(sreg->org_val);
+		one_reg.addr = (uint64_t)&reg_val;
+		one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+		vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
+		sreg->user_val = 0;
+	}
+	return sreg->can_clear;
+}
+
+static void clear_any_id_reg(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	int ret;
+	uint64_t args[2] = {(uint64_t)vm, vcpuid};
+
+	ret = walk_id_reg_list(clear_id_reg_when_possible, args);
+
+	/* Return non-zero means one of non-zero registers was cleared */
+	assert(ret);
+	sync_global_to_guest(vm, id_reg_list);
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
+	long caps[2] = {KVM_CAP_ARM_PTRAUTH_ADDRESS,
+			KVM_CAP_ARM_PTRAUTH_GENERIC};
+
+	reset_id_reg_info();
+	one_reg.addr = (uint64_t)&rval;
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+
+	if (caps_are_supported(caps, 2)) {
+
+		/* Test with feature enabled */
+		memset(&init, 0, sizeof(init));
+		init.target = -1;
+		init.features[0] = (1ULL << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
+				    1ULL << KVM_ARM_VCPU_PTRAUTH_GENERIC);
+		vm = test_vm_create_cap(1, guest_code_ptrauth_check, &init,
+					NULL);
+		vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
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
+		sreg->user_val = rval;
+
+		pr_debug("%s: Test with %s enabled (%s: 0x%lx)\n",
+			 __func__, name, sreg->name, sreg->user_val);
+		ret = TEST_RUN(vm, vcpu);
+		TEST_ASSERT(!ret, "%s:KVM_RUN failed with %s enabled",
+			    __func__, name);
+		test_vm_free(vm);
+	}
+
+	/* Test with feature disabled */
+	reset_id_reg_info();
+
+	vm = test_vm_create(1, guest_code_feature_check, NULL);
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
+		 __func__, name, sreg->name, sreg->user_val);
+
+	ret = TEST_RUN(vm, vcpu);
+	TEST_ASSERT(!ret, "%s TEST_RUN failed with %s enabled, ret=0x%x",
+		    __func__, name, ret);
+
+	test_vm_free(vm);
+}
+
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
+	finfo->run_test = 1;	/* Indicate that guest runs the test on it */
+	one_reg.addr = (uint64_t)&reg_val;
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+
+	/* Test with feature enabled */
+
+	/* Need KVM_ARM_VCPU_INIT or opt-in capability ? */
+	if (finfo->vcpu_init || finfo->opt_in_cap) {
+		if ((finfo->ncaps == 0) ||
+		    (caps_are_supported(finfo->caps, finfo->ncaps))) {
+			if (finfo->vcpu_init) {
+				/*
+				 * Need to enable the feature via
+				 * KVM_ARM_VCPU_INIT.
+				 */
+				memset(&init, 0, sizeof(init));
+				init = *finfo->vcpu_init;
+				init.target = -1;
+				initp = &init;
+			}
+
+			vm = test_vm_create_cap(1, guest_code_feature_check,
+						initp, finfo->opt_in_cap);
+			vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
+			fval = GET_ID_FIELD(reg_val, shift, is_sign);
+			TEST_ASSERT(fval >= min,
+				    "%s field of %s is too small (%ld)",
+				    finfo->name, sreg->name, fval);
+			sreg->user_val = reg_val;
+		}
+	} else {
+		/* Check if the feature is available */
+		if (GET_ID_FIELD(sreg->org_val, shift, is_sign) >= min)
+			vm = test_vm_create(1, guest_code_feature_check, NULL);
+	}
+
+	if (vm) {
+		if (finfo->init_feature)
+			/* Run any required extra process to use the feature */
+			finfo->init_feature(vm, vcpu);
+
+		pr_debug("%s: Test with %s enabled (%s: 0x%lx)\n",
+			 __func__, finfo->name, sreg->name, sreg->user_val);
+
+		ret = TEST_RUN(vm, vcpu);
+		TEST_ASSERT(!ret, "%s:TEST_RUN failed with %s enabled",
+			    __func__, finfo->name);
+		test_vm_free(vm);
+	}
+
+	/* Test with feature disabled */
+	reset_id_reg_info();
+
+	vm = test_vm_create(1, guest_code_feature_check, NULL);
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
+		sreg->user_val = reg_val;
+	}
+
+	pr_debug("%s: Test with %s disabled (%s: 0x%lx)\n",
+		 __func__, finfo->name, sreg->name, sreg->user_val);
+
+	ret = TEST_RUN(vm, vcpu);
+	finfo->run_test = 0;
+	test_vm_free(vm);
+}
+
+static void test_feature_all(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(feature_test_info_table); i++)
+		test_feature(&feature_test_info_table[i]);
+}
+
+int test_set_reg(struct id_reg_test_info *sreg, uint64_t new_val,
+		 bool guest_run)
+{
+	struct kvm_vm *vm;
+	int ret;
+	uint32_t vcpu = 0;
+	uint64_t reg_val;
+	struct kvm_one_reg one_reg;
+
+	reset_id_reg_info();
+
+	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL);
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+	one_reg.addr = (uint64_t)&reg_val;
+
+	reg_val = new_val;
+	ret = _vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
+	if (!guest_run)
+		return ret;
+
+	TEST_ASSERT(!ret, "SET_REG(%s=0x%lx) failed, ret=0x%x",
+		    sreg->name, new_val, ret);
+	sreg->user_val = new_val;
+	ret = TEST_RUN(vm, vcpu);
+	test_vm_free(vm);
+	return ret;
+}
+
+int test_feature_frac_vm(struct id_reg_test_info *sreg, uint64_t new_val,
+		      struct id_reg_test_info *frac_sreg, uint64_t frac_new_val)
+{
+	struct kvm_vm *vm;
+	int ret;
+	uint32_t vcpu = 0;
+	uint64_t reg_val;
+	struct kvm_one_reg one_reg;
+
+	reset_id_reg_info();
+
+	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL);
+
+	/* Set feature reg field */
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+	one_reg.addr = (uint64_t)&reg_val;
+	reg_val = new_val;
+	ret = _vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
+	TEST_ASSERT(!ret, "SET_REG(%s=0x%lx) failed, ret=0x%x",
+		    sreg->name, new_val, ret);
+	sreg->user_val = new_val;
+
+	/* Set fractional reg field */
+	one_reg.id = KVM_ARM64_SYS_REG(frac_sreg->id);
+	one_reg.addr = (uint64_t)&reg_val;
+	reg_val = frac_new_val;
+	vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
+	TEST_ASSERT(!ret, "SET_REG(%s=0x%lx) failed, ret=0x%x",
+		    frac_sreg->name, frac_new_val, ret);
+
+	frac_sreg->user_val = frac_new_val;
+	ret = TEST_RUN(vm, vcpu);
+	test_vm_free(vm);
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
+void test_feature_frac_one(struct frac_info *frac)
+{
+	uint64_t reg_val, org_fval, frac_reg_val, frac_org_fval;
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
+		__func__, frac->name, sreg->name, shift,
+		frac_sreg->name, frac_shift);
+
+	frac_org_fval = GET_ID_UFIELD(frac_sreg->org_val, frac_shift);
+	if (frac_org_fval > 0) {
+		/* Test with smaller frac value */
+		frac_reg_val = UPDATE_ID_UFIELD(frac_sreg->org_val,
+						frac_shift, frac_org_fval - 1);
+		ret = test_set_reg(frac_sreg, frac_reg_val, false);
+		TEST_ASSERT(!ret, "SET smaller %s frac (val:%lx) failed(%d)",
+			    frac->name, frac_reg_val, ret);
+
+		ret = test_feature_frac_vm(sreg, sreg->org_val,
+					   frac_sreg, frac_reg_val);
+		TEST_ASSERT(!ret, "Test smaller %s frac (val:%lx) failed(%d)",
+			    frac->name, frac_reg_val, ret);
+	}
+
+	reset_id_reg_info();
+
+	if (frac_org_fval != 0xf) {
+		/* Test with larger frac value */
+		frac_reg_val = UPDATE_ID_UFIELD(frac_sreg->org_val, frac_shift,
+						frac_org_fval + 1);
+
+		/* Setting larger frac shouldn't fail (at ioctl) */
+		ret = test_set_reg(frac_sreg, frac_reg_val, false);
+		TEST_ASSERT(!ret,
+			"SET larger %s frac (%s org:%lx, val:%lx) failed(%d)",
+			frac->name, frac_sreg->name, frac_sreg->org_val,
+			frac_reg_val, ret);
+
+		/* KVM_RUN with larger frac should fail */
+		ret = test_feature_frac_vm(sreg, sreg->org_val,
+					   frac_sreg, frac_reg_val);
+		TEST_ASSERT(ret,
+			"Test with larger %s frac (%s org:%lx, val:%lx) worked",
+			frac->name, frac_sreg->name, frac_sreg->org_val,
+			frac_reg_val);
+	}
+
+	reset_id_reg_info();
+
+	org_fval = GET_ID_UFIELD(sreg->org_val, shift);
+	if (org_fval == 0) {
+		/* Setting larger val for the feature should fail */
+		reg_val = UPDATE_ID_UFIELD(sreg->org_val, shift, org_fval + 1);
+		ret = test_set_reg(sreg, reg_val, false);
+		TEST_ASSERT(ret, "SET larger %s (val:%lx) worked",
+			    frac->name, reg_val);
+		return;
+	}
+
+	/* Test with smaller feature value */
+	reg_val = UPDATE_ID_UFIELD(sreg->org_val, shift, org_fval - 1);
+	ret = test_set_reg(sreg, reg_val, false);
+	TEST_ASSERT(!ret, "SET smaller %s (val:%lx) failed(%d)",
+		    frac->name, reg_val, ret);
+
+	ret = test_feature_frac_vm(sreg, reg_val, frac_sreg, frac_sreg->org_val);
+	TEST_ASSERT(!ret, "Test with smaller %s (val:%lx) failed(%d)",
+		    frac->name, reg_val, ret);
+
+	if (frac_org_fval > 0) {
+		/* Test with smaller feature and frac value */
+		frac_reg_val = UPDATE_ID_UFIELD(frac_sreg->org_val,
+						frac_shift, frac_org_fval - 1);
+		ret = test_feature_frac_vm(sreg, reg_val, frac_sreg,
+					   frac_reg_val);
+		TEST_ASSERT(!ret,
+		    "Test with smaller %s and frac (val:%lx) failed(%d)",
+		    frac->name, reg_val, ret);
+	}
+
+	if (frac_org_fval != 0xf) {
+		/* Test with smaller feature and larger frac value */
+		frac_reg_val = UPDATE_ID_UFIELD(frac_sreg->org_val,
+						frac_shift, frac_org_fval + 1);
+		ret = test_feature_frac_vm(sreg, reg_val, frac_sreg,
+					   frac_reg_val);
+		TEST_ASSERT(!ret,
+		    "Test with smaller %s and larger frac (val:%lx) failed(%d)",
+		    frac->name, reg_val, ret);
+	}
+}
+
+void test_feature_frac_all(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(frac_info_table); i++)
+		test_feature_frac_one(&frac_info_table[i]);
+}
+
+/* Structure for test_consistent_vcpus/test_inconsistent_vcpus */
+struct thread_args {
+	pthread_t	thread;
+	struct kvm_vm	*vm;
+	uint32_t	vcpuid;
+	void		*data;
+};
+
+/* Structures for test_inconsistent_vcpus */
+struct run_inconsistent_test {
+	bool		modify_id_reg;
+	volatile bool	complete;
+};
+
+struct inconsistent_test_info {
+	uint32_t nvcpus;
+	struct run_inconsistent_test *vcpu_run;
+};
+
+static void *inconsistent_test_thread(void *arg)
+{
+	struct thread_args *targs = arg;
+	struct kvm_vm *vm = targs->vm;
+	uint32_t vcpuid = targs->vcpuid;
+	struct inconsistent_test_info *info = targs->data;
+	int64_t ret;
+	int i;
+	struct timespec ts = {
+		.tv_sec = 0,
+		.tv_nsec = 1000000,
+	};
+
+	if (info->vcpu_run[vcpuid].modify_id_reg) {
+		/* Make inconsistency in ID regs between vCPUs */
+		clear_any_id_reg(vm, vcpuid);
+
+		/* Wait for all other vCPUs to exit from KVM_RUN */
+		for (i = 0; i < info->nvcpus; i++) {
+			if (i == vcpuid)
+				continue;
+
+			while (!info->vcpu_run[i].complete)
+				nanosleep(&ts, NULL);
+		}
+	}
+
+	ret = TEST_RUN_NO_SYNC_DATA(vm, vcpuid);
+	if (info->vcpu_run[vcpuid].modify_id_reg) {
+		TEST_ASSERT(ret == EPERM,
+			    "%s: KVM_RUN retturned unexpected result (ret=%ld)",
+			    __func__, ret);
+	} else {
+		TEST_ASSERT(ret == 0, "%s: KVM_RUN failed (ret=%ld)",
+			    __func__, ret);
+		info->vcpu_run[vcpuid].complete = true;
+	}
+
+	return (void *)ret;
+}
+
+static int start_test_thread(struct kvm_vm *vm, uint32_t nvcpus,
+			     void *(*test_func)(void *arg), void *data)
+{
+	int i, ret, test_ret;
+	uint64_t thread_ret;
+	pthread_t *threads;
+	struct thread_args *args;
+
+	threads = calloc(nvcpus, sizeof(pthread_t));
+	TEST_ASSERT(threads, "Failed to allocate threads.");
+
+	args = calloc(nvcpus, sizeof(struct thread_args));
+	TEST_ASSERT(args, "Failed to allocate args.");
+
+	for (i = 0; i < nvcpus; i++) {
+		args[i].vm = vm;
+		args[i].vcpuid = i;
+		args[i].data = data;
+		ret = pthread_create(&threads[i], NULL, test_func, &args[i]);
+		TEST_ASSERT(!ret, "pthread_create failed: %d\n", ret);
+	}
+
+	test_ret = 0;
+	for (i = 0; i < nvcpus; i++) {
+		thread_ret = 0;
+		ret = pthread_join(threads[i], (void **)&thread_ret);
+		TEST_ASSERT(!ret, "pthread_join failed: %d\n", ret);
+		if (thread_ret != 0)
+			test_ret = (int32_t)thread_ret;
+	}
+	free(args);
+	free(threads);
+	return test_ret;
+}
+
+/*
+ * Create multiple vCPUs and we will set ID registers to different values
+ * from others to make sure that KVM_RUN will fail when it detects inconsistent
+ * ID registers across vCPUs.
+ */
+void test_inconsistent_vcpus(uint32_t nvcpus)
+{
+	struct kvm_vm *vm;
+	int ret;
+	struct inconsistent_test_info info;
+
+	assert(nvcpus > 1);
+
+	reset_id_reg_info();
+	info.nvcpus = nvcpus;
+	info.vcpu_run = calloc(nvcpus, sizeof(struct run_inconsistent_test));
+	assert(info.vcpu_run);
+
+	vm = test_vm_create(nvcpus, guest_code_do_nothing, NULL);
+
+	sync_global_to_guest(vm, id_reg_list);
+
+	/* Let vCPU0 modify its ID register */
+	info.vcpu_run[0].modify_id_reg = 1;
+	ret = start_test_thread(vm, nvcpus, inconsistent_test_thread, &info);
+	TEST_ASSERT(ret == EPERM, "inconsistent_test_thread failed\n");
+	test_vm_free(vm);
+	free(info.vcpu_run);
+}
+
+static void *test_vcpu_thread(void *arg)
+{
+	struct thread_args *targs = arg;
+	int64_t ret;
+
+	ret = TEST_RUN_NO_SYNC_DATA(targs->vm, targs->vcpuid);
+	return (void *)ret;
+}
+
+void test_consistent_vcpus(uint32_t nvcpus)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	assert(nvcpus > 1);
+	reset_id_reg_info();
+
+	vm = test_vm_create(nvcpus, guest_code_do_nothing, NULL);
+	sync_global_to_guest(vm, id_reg_list);
+
+	ret = start_test_thread(vm, nvcpus, test_vcpu_thread, NULL);
+	TEST_ASSERT(!ret, "test_vcpu_thread failed\n");
+	test_vm_free(vm);
+}
+
+void run_test(void)
+{
+	uint32_t nvcpus = 3;
+
+	set_id_regs_test();
+	test_feature_all();
+	test_feature_ptrauth();
+	test_feature_frac_all();
+	test_consistent_vcpus(nvcpus);
+	test_inconsistent_vcpus(nvcpus);
+}
+
+static int init_id_reg_info_one(struct id_reg_test_info *sreg, void *arg)
+{
+	uint64_t reg_val;
+	uint32_t vcpuid = 0;
+	int ret;
+	struct kvm_one_reg one_reg;
+	struct kvm_vm *vm = arg;
+
+	one_reg.addr = (uint64_t)&reg_val;
+	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
+	sreg->org_val = reg_val;
+	sreg->user_val = reg_val;
+	if (sreg->org_val) {
+		reg_val = 0;
+		ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
+		if (!ret)
+			sreg->can_clear = true;
+	}
+
+	pr_debug("%s (0x%x): 0x%lx, %s\n", sreg->name, sreg->id,
+		 sreg->org_val, sreg->can_clear ? "can clear" : "");
+
+	return 0;
+}
+
+static void init_id_reg_info(void)
+{
+	struct kvm_vm *vm;
+
+	vm = test_vm_create(1, guest_code_do_nothing, NULL);
+	walk_id_reg_list(init_id_reg_info_one, vm);
+	test_vm_free(vm);
+}
+
+int main(void)
+{
+
+	setbuf(stdout, NULL);
+
+	if (kvm_check_cap(KVM_CAP_ARM_ID_REG_WRITABLE) <= 0) {
+		print_skip("KVM_CAP_ARM_ID_REG_WRITABLE is not supported\n");
+		exit(KSFT_SKIP);
+	}
+
+	init_id_reg_info();
+	run_test();
+	return 0;
+}
-- 
2.33.0.882.g93a45727a2-goog

