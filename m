Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CB750653B
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349198AbiDSHBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349212AbiDSHBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:01:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E8C329A4
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:58:09 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id i16-20020a170902cf1000b001540b6a09e3so9278824plg.0
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3muW+LT8OOUV4To4u5OSB2G3zDFllVWSkyBrKzdGUG8=;
        b=oR9T7BXixT6xBgn18g1Hh/jt8urIrga4TxVi78S7u28dehEkOk1mrCxUQe4utw6eIt
         9TgGCVWg8ZTXowkSt0MNQ4IF/Dl79v3kcNbRFZVmDrYnKV5Kjjw1837LrBsq8ZpZpXS1
         S8Wn5eiMXb3vpuAAUWZF5rNiIQLT1B0bNHwHZI2/3+IRj88wO+nbgm1lxQG4nxW0XD5m
         wzOvLFfFvYx63UYcmNsfWATEALrBFcenk1BudVZzACBqRxe4v6y6PvSXHfZXb5eme5yG
         LkNUefaksu27K0dMkNDrFOTYMCjScbfyMMlZzg7PfWW7SbJ8s/R0hrpvpbVLWOIg6ets
         zzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3muW+LT8OOUV4To4u5OSB2G3zDFllVWSkyBrKzdGUG8=;
        b=clzQB4CFx0sYgPOIyOBT70MsVngAeVzXIuqxqLiQoKP7Y+ZfYq7nCD7oQYWG9SqexA
         nPDiWxJGKWPttaKrfjQ0kE+DYnYxH3UB0T8Y+oziHVh2ZIXJRVf5Equ5Qf/JZADthgl3
         68N6AIMWEJQqWn6dLxbhXeVjMrdL/RdyxH1UnYhibrB6vCLZz6cpj/kQQJaGFMUXRMOy
         UKv7rvG7zFXO31pH7klrZ14+fVyjGubrltgbwPDty6z2P8fMa3C0AYeRdzutlxWTXI1m
         5B6d4QcCb2jfGwAptKa/uW9e42ppuppfRUvbwM77VPBHYdUxA6CMWP+VzEE2by8ixQuI
         tMhA==
X-Gm-Message-State: AOAM530nXpvdK9SA5Pnu1AwcR45J6XcKXRCvFEHCAl1fVC0EWrzgETiJ
        boTApv0UFKt2v1YlC3hRTq/X27cs710=
X-Google-Smtp-Source: ABdhPJyB77yq+//pE7CNExrz84DDPN2e34z9v6NwPrrLkqA2BQkYhti1e7qLBpn39CuPKY5bMokIj7ORtPY=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1a8f:b0:50a:8c2d:2ee8 with SMTP id
 e15-20020a056a001a8f00b0050a8c2d2ee8mr5029299pfv.46.1650351483684; Mon, 18
 Apr 2022 23:58:03 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:42 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-37-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 36/38] KVM: arm64: selftests: Test breakpoint/watchpoint
 register access
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

Add test cases for reading and writing of dbgbcr/dbgbvr/dbgwcr/dbgwvr
registers from userspace and the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 350 +++++++++++++++++-
 1 file changed, 332 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 876257be5960..4e00100b9aa1 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -37,6 +37,26 @@ static volatile uint64_t svc_addr;
 static volatile uint64_t ss_addr[4], ss_idx;
 #define  PC(v)  ((uint64_t)&(v))
 
+struct kvm_guest_debug_arch debug_regs;
+
+static uint64_t update_bcr_lbn(uint64_t val, uint8_t lbn)
+{
+	uint64_t new;
+
+	new = val & ~((uint64_t)0xf << DBGBCR_LBN_SHIFT);
+	new |= (uint64_t)((lbn & 0xf) << DBGBCR_LBN_SHIFT);
+	return new;
+}
+
+static uint64_t update_wcr_lbn(uint64_t val, uint8_t lbn)
+{
+	uint64_t new;
+
+	new = val & ~((uint64_t)0xf << DBGWCR_LBN_SHIFT);
+	new |= (uint64_t)((lbn & 0xf) << DBGWCR_LBN_SHIFT);
+	return new;
+}
+
 #define GEN_DEBUG_WRITE_REG(reg_name)			\
 static void write_##reg_name(int num, uint64_t val)	\
 {							\
@@ -94,12 +114,77 @@ static void write_##reg_name(int num, uint64_t val)	\
 	}						\
 }
 
+#define GEN_DEBUG_READ_REG(reg_name)			\
+u64 read_##reg_name(int num)				\
+{							\
+	u64 val = 0;					\
+							\
+	switch (num) {					\
+	case 0:						\
+		val = read_sysreg(reg_name##0_el1);	\
+		break;					\
+	case 1:						\
+		val = read_sysreg(reg_name##1_el1);	\
+		break;					\
+	case 2:						\
+		val = read_sysreg(reg_name##2_el1);	\
+		break;					\
+	case 3:						\
+		val = read_sysreg(reg_name##3_el1);	\
+		break;					\
+	case 4:						\
+		val = read_sysreg(reg_name##4_el1);	\
+		break;					\
+	case 5:						\
+		val = read_sysreg(reg_name##5_el1);	\
+		break;					\
+	case 6:						\
+		val = read_sysreg(reg_name##6_el1);	\
+		break;					\
+	case 7:						\
+		val = read_sysreg(reg_name##7_el1);	\
+		break;					\
+	case 8:						\
+		val = read_sysreg(reg_name##8_el1);	\
+		break;					\
+	case 9:						\
+		val = read_sysreg(reg_name##9_el1);	\
+		break;					\
+	case 10:					\
+		val = read_sysreg(reg_name##10_el1);	\
+		break;					\
+	case 11:					\
+		val = read_sysreg(reg_name##11_el1);	\
+		break;					\
+	case 12:					\
+		val = read_sysreg(reg_name##12_el1);	\
+		break;					\
+	case 13:					\
+		val = read_sysreg(reg_name##13_el1);	\
+		break;					\
+	case 14:					\
+		val = read_sysreg(reg_name##14_el1);	\
+		break;					\
+	case 15:					\
+		val = read_sysreg(reg_name##15_el1);	\
+		break;					\
+	default:					\
+		GUEST_ASSERT(0);			\
+	}						\
+	return val;					\
+}
+
 /* Define write_dbgbcr()/write_dbgbvr()/write_dbgwcr()/write_dbgwvr() */
 GEN_DEBUG_WRITE_REG(dbgbcr)
 GEN_DEBUG_WRITE_REG(dbgbvr)
 GEN_DEBUG_WRITE_REG(dbgwcr)
 GEN_DEBUG_WRITE_REG(dbgwvr)
 
+/* Define read_dbgbcr()/read_dbgbvr()/read_dbgwcr()/read_dbgwvr() */
+GEN_DEBUG_READ_REG(dbgbcr)
+GEN_DEBUG_READ_REG(dbgbvr)
+GEN_DEBUG_READ_REG(dbgwcr)
+GEN_DEBUG_READ_REG(dbgwvr)
 
 static void reset_debug_state(void)
 {
@@ -238,20 +323,126 @@ static void install_ss(void)
 	isb();
 }
 
+/*
+ * Check if the guest sees bcr/bvr/wcr/wvr register values that userspace
+ * set (by set_debug_regs()), and update them for userspace to verify
+ * the same.
+ */
+static void guest_code_bwp_reg_test(struct kvm_guest_debug_arch *dregs)
+{
+	uint64_t dfr0 = read_sysreg(id_aa64dfr0_el1);
+	uint8_t nbps, nwps;
+	int i;
+	u64 val, rval;
+
+	/* Set nbps/nwps to the number of breakpoints/watchpoints. */
+	nbps = cpuid_extract_uftr(dfr0, ID_AA64DFR0_BRPS_SHIFT) + 1;
+	nwps = cpuid_extract_uftr(dfr0, ID_AA64DFR0_WRPS_SHIFT) + 1;
+
+	for (i = 0; i < nbps; i++) {
+		/*
+		 * Check if the dbgbcr value is the same as the one set by
+		 * userspace.
+		 */
+		val = read_dbgbcr(i);
+		GUEST_ASSERT_EQ(val, dregs->dbg_bcr[i]);
+
+		/* Set dbgbcr to some value for userspace to read later */
+		val = update_bcr_lbn(0, (i + 1) % nbps);
+		write_dbgbcr(i, val);
+		rval = read_dbgbcr(i);
+
+		/* Make sure written value could be read */
+		GUEST_ASSERT_EQ(val, rval);
+
+		/* Save the written value for userspace to refer later */
+		dregs->dbg_bcr[i] = val;
+
+		/*
+		 * Check if the dbgbvr value is the same as the one set by
+		 * userspace.
+		 */
+		val = read_dbgbvr(i);
+		GUEST_ASSERT_EQ(val, dregs->dbg_bvr[i]);
+
+		/* Set dbgbvr to some value for userspace to read later */
+		val = (uint64_t)(nbps - i - 1) << 32;
+		write_dbgbvr(i, val);
+
+		/* Make sure written value could be read */
+		rval = read_dbgbvr(i);
+		GUEST_ASSERT_EQ(val, rval);
+
+		/* Save the written value for userspace to refer later */
+		dregs->dbg_bvr[i] = val;
+	}
+
+	for (i = 0; i < nwps; i++) {
+		/*
+		 * Check if the dbgwcr value is the same as the one set by
+		 * userspace.
+		 */
+		val = read_dbgwcr(i);
+		GUEST_ASSERT_EQ(val, dregs->dbg_wcr[i]);
+
+		/* Set dbgwcr to some value for userspace to read later */
+		val = update_wcr_lbn(0, (i + 1) % nbps);
+		write_dbgwcr(i, val);
+
+		/* Make sure written value could be read */
+		rval = read_dbgwcr(i);
+		GUEST_ASSERT_EQ(val, rval);
+
+		/* Save the written value for userspace to refer later */
+		dregs->dbg_wcr[i] = val;
+
+		/*
+		 * Check if the dbgwvr value is the same as the one set by
+		 * userspace.
+		 */
+		val = read_dbgwvr(i);
+		GUEST_ASSERT_EQ(val, dregs->dbg_wvr[i]);
+
+		/* Set dbgwvr to some value for userspace to read later */
+		val = (uint64_t)(nbps - i - 1) << 32;
+		write_dbgwvr(i, val);
+
+		/* Make sure written value could be read */
+		rval = read_dbgwvr(i);
+		GUEST_ASSERT_EQ(val, rval);
+
+		/* Save the written value for userspace to refer later */
+		dregs->dbg_wvr[i] = val;
+	}
+}
+
 static volatile char write_data;
 
-static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
+static void guest_code(struct kvm_guest_debug_arch *dregs,
+		       uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	uint64_t ctx = 0xc;	/* a random context number */
 
+	/*
+	 * Check if the guest sees bcr/bvr/wcr/wvr register values that
+	 * userspace set before the first KVM_RUN.
+	 */
+	guest_code_bwp_reg_test(dregs);
 	GUEST_SYNC(0);
 
+	/*
+	 * Check if the guest sees bcr/bvr/wcr/wvr register values that
+	 * userspace set after the first KVM_RUN.
+	 */
+	guest_code_bwp_reg_test(dregs);
+	GUEST_SYNC(1);
+
 	/* Software-breakpoint */
 	reset_debug_state();
 	asm volatile("sw_bp: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
 
-	GUEST_SYNC(1);
+	GUEST_SYNC(2);
 
 	/* Hardware-breakpoint */
 	reset_debug_state();
@@ -259,7 +450,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	asm volatile("hw_bp: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
 
-	GUEST_SYNC(2);
+	GUEST_SYNC(3);
 
 	/* Hardware-breakpoint + svc */
 	reset_debug_state();
@@ -268,7 +459,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
 	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
 
-	GUEST_SYNC(3);
+	GUEST_SYNC(4);
 
 	/* Hardware-breakpoint + software-breakpoint */
 	reset_debug_state();
@@ -277,7 +468,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
 
-	GUEST_SYNC(4);
+	GUEST_SYNC(5);
 
 	/* Watchpoint */
 	reset_debug_state();
@@ -286,7 +477,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
 
-	GUEST_SYNC(5);
+	GUEST_SYNC(6);
 
 	/* Single-step */
 	reset_debug_state();
@@ -301,7 +492,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
 	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
 
-	GUEST_SYNC(6);
+	GUEST_SYNC(7);
 
 	/* OS Lock does not block software-breakpoint */
 	reset_debug_state();
@@ -310,7 +501,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	asm volatile("sw_bp2: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp2));
 
-	GUEST_SYNC(7);
+	GUEST_SYNC(8);
 
 	/* OS Lock blocking hardware-breakpoint */
 	reset_debug_state();
@@ -320,7 +511,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	asm volatile("hw_bp2: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, 0);
 
-	GUEST_SYNC(8);
+	GUEST_SYNC(9);
 
 	/* OS Lock blocking watchpoint */
 	reset_debug_state();
@@ -332,7 +523,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, 0);
 
-	GUEST_SYNC(9);
+	GUEST_SYNC(10);
 
 	/* OS Lock blocking single-step */
 	reset_debug_state();
@@ -356,7 +547,7 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	asm volatile("hw_bp_ctx: nop");
 	write_sysreg(0, contextidr_el1);
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
-	GUEST_SYNC(10);
+	GUEST_SYNC(11);
 
 	/* Linked watchpoint */
 	reset_debug_state();
@@ -402,13 +593,122 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
+/*
+ * Set bcr/bwr/wcr/wbr for register read/write testing.
+ * The values that are set by userspace are saved in dregs, which will
+ * be used by the guest code (guest_code_bwp_reg_test()) to make sure
+ * that the guest sees bcr/bvr/wcr/wvr register values that are set
+ * by userspace.
+ */
+static void set_debug_regs(struct kvm_vm *vm, uint32_t vcpu,
+			       struct kvm_guest_debug_arch *dregs,
+			       uint8_t nbps, uint8_t nwps)
+{
+	int i;
+	uint64_t val;
+
+	for (i = 0; i < nbps; i++) {
+		/* Set dbgbcr to some value for the guest to read later */
+		val = update_bcr_lbn(0, i);
+		set_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGBCRn_EL1(i)), val);
+
+		/* Save the written value for the guest to refer later */
+		dregs->dbg_bcr[i] = val;
+
+		/* Make sure the written value could be read */
+		get_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGBCRn_EL1(i)), &val);
+		TEST_ASSERT(val == dregs->dbg_bcr[i],
+			    "Unexpected bcr[%d]:0x%lx (expected:0x%llx)\n",
+			    i, val, dregs->dbg_bcr[i]);
+
+		/* Set dbgbvr to some value for the guest to read later */
+		val = (uint64_t)i << 8;
+		set_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGBVRn_EL1(i)), val);
+
+		/* Save the written value for the guest to refer later */
+		dregs->dbg_bvr[i] = val;
+
+		/* Make sure the written value could be read */
+		get_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGBVRn_EL1(i)), &val);
+		TEST_ASSERT(val == dregs->dbg_bvr[i],
+			    "Unexpected bvr[%d]:0x%lx (expected:0x%llx)\n",
+			    i, val, dregs->dbg_bvr[i]);
+	}
+
+	for (i = 0; i < nwps; i++) {
+		/* Set dbgwcr to some value for the guest to read later */
+		val = update_wcr_lbn(0, i % nbps);
+		set_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGWCRn_EL1(i)), val);
+
+		/* Save the written value for the guest to refer later */
+		dregs->dbg_wcr[i] = val;
+
+		/* Make sure the written value could be read */
+		get_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGWCRn_EL1(i)), &val);
+		TEST_ASSERT(val == dregs->dbg_wcr[i],
+			    "Unexpected wcr[%d]:0x%lx (expected:0x%llx)\n",
+			    i, val, dregs->dbg_wcr[i]);
+
+		/* Set dbgwvr to some value for the guest to read later */
+		val = (uint64_t)i << 8;
+		set_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGWVRn_EL1(i)), val);
+
+		/* Save the written value for the guest to refer later */
+		dregs->dbg_wvr[i] = val;
+
+		/* Make sure the written value could be read */
+		get_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGWVRn_EL1(i)), &val);
+		TEST_ASSERT(val == dregs->dbg_wvr[i],
+			    "Unexpected wvr[%d]:0x%lx (expected:0x%llx)\n",
+			    i, val, dregs->dbg_wvr[i]);
+	}
+}
+
+/*
+ * Check if the userspace sees bcr/bvr/wcr/wvr register values that are
+ * set by the guest (guest_code_bwp_reg_test()), which are saved in the
+ * given dregs.
+ */
+static void check_debug_regs(struct kvm_vm *vm, uint32_t vcpu,
+			     struct kvm_guest_debug_arch *dregs,
+			     int nbps, int nwps)
+{
+	uint64_t val;
+	int i;
+
+	for (i = 0; i < nbps; i++) {
+		get_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGBCRn_EL1(i)), &val);
+		TEST_ASSERT(val == dregs->dbg_bcr[i],
+			    "Unexpected bcr[%d]:0x%lx (Expected: 0x%llx)\n",
+			    i, val, dregs->dbg_bcr[i]);
+
+		get_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGBVRn_EL1(i)), &val);
+		TEST_ASSERT(val == dregs->dbg_bvr[i],
+			    "Unexpected bvr[%d]:0x%lx (Expected: 0x%llx)\n",
+			    i, val, dregs->dbg_bvr[i]);
+	}
+
+	for (i = 0; i < nwps; i++) {
+		get_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGWCRn_EL1(i)), &val);
+		TEST_ASSERT(val == dregs->dbg_wcr[i],
+			    "Unexpected wcr[%d]:0x%lx (Expected: 0x%llx)\n",
+			    i, val, dregs->dbg_wcr[i]);
+
+		get_reg(vm, vcpu, KVM_ARM64_SYS_REG(SYS_DBGWVRn_EL1(i)), &val);
+		TEST_ASSERT(val == dregs->dbg_wvr[i],
+			    "Unexpected wvr[%d]:0x%lx (Expected: 0x%llx)\n",
+			    i, val, dregs->dbg_wvr[i]);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
 	uint64_t aa64dfr0;
-	uint8_t max_brps;
+	uint8_t nbps, nwps;
+	bool debug_reg_test = false;
 
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
@@ -434,19 +734,28 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	/* Number of breakpoints, minus 1 */
-	max_brps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	/* Number of breakpoints */
+	nbps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT) + 1;
+	TEST_ASSERT(nbps >= 2, "Number of breakpoints must be >= 2");
 
-	/* The value of 0x0 is reserved */
-	TEST_ASSERT(max_brps > 0, "ID_AA64DFR0_EL1.BRPS must be > 0");
+	/* Number of watchpoints */
+	nwps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT) + 1;
+	TEST_ASSERT(nwps >= 2, "Number of watchpoints must be >= 2");
 
 	/*
 	 * Test with breakpoint#0 and watchpoint#0, and the higiest
 	 * numbered breakpoint (the context aware breakpoint).
 	 */
-	vcpu_args_set(vm, VCPU_ID, 3, 0, 0, max_brps);
+	vcpu_args_set(vm, VCPU_ID, 4, &debug_regs, 0, 0, nbps - 1);
+
+	for (stage = 0; stage < 13; stage++) {
+		/* First two stages are sanity debug regs read/write check */
+		if (stage < 2) {
+			set_debug_regs(vm, VCPU_ID, &debug_regs, nbps, nwps);
+			sync_global_to_guest(vm, debug_regs);
+			debug_reg_test = true;
+		}
 
-	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vm, VCPU_ID);
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
@@ -454,6 +763,11 @@ int main(int argc, char *argv[])
 			TEST_ASSERT(uc.args[1] == stage,
 				"Stage %d: Unexpected sync ucall, got %lx",
 				stage, (ulong)uc.args[1]);
+			if (debug_reg_test) {
+				debug_reg_test = false;
+				sync_global_from_guest(vm, debug_regs);
+				check_debug_regs(vm, VCPU_ID, &debug_regs, nbps, nwps);
+			}
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
-- 
2.36.0.rc0.470.gd361397f0d-goog

