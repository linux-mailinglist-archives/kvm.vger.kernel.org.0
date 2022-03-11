Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3884D5A16
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346479AbiCKEuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346472AbiCKEtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:49:47 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E5E1AAFC9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:35 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id f21-20020a633815000000b0038105768c61so933130pga.21
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qTyrhuTFJ7wTiM9tvbSBgyvkTis1ZeMrxQeZx92tj2A=;
        b=kxXwwKf76XJVgOlrOSM6DlfVqX/r3m6LuNum/WvCEBqF/qgCmnns+PpZ8/o1y+g5G/
         Kbg7RIzj8TfV2IM1veJH+op06M5dxHq0f+2obySLhGc7P1v4e3CM7YEyyaDkYRCNSaGi
         3+3SoFIcPnUZEePvQcDX8xI6VQRkzZFCBP3HBnxusnXLd/G+F1Aw6hmn5kA2WJ4axU2j
         HcAulUblFsyadSuQYww+KZFE94Mr4Qs60zf37KZMZnXwYP53R4ZBJAUBMEBRSw6xjZgy
         GqbLJiTK/yAFQuzzk2KLg4iIn6jvN1ffGHq9Qs4rH284leJGJ1SfOb68WDW2kpB2PxTJ
         A5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qTyrhuTFJ7wTiM9tvbSBgyvkTis1ZeMrxQeZx92tj2A=;
        b=Vcc6N1yeMcTEGMYeBESHzgEKHWnk71rD9P+jjwyHxdGRv5Zc+KDqgNEuUe0yY/0+HV
         n3kO/ntr8lCWKqOr1CuyCMPQL3uotNBZB3RLW6BSQskCa340fgtEsmOMgnloHnrPR31g
         BozaGLs4r4zzHg86LdKvjWIT9/2Ta751mMXTEX2tN9W7eBnbeQrdaRbgj7QWfthlIpCb
         wJDPBjqsswOvOcmQkyDucPQi5UK80PQCWlNp1FVKjI+NEeivEJEVM0OfTzMv+KyiW5Le
         cc8DBppFK+o9JX2eO09wedANnTOXtGZ3S3PdVgTgBQAYPgdlUfvBUylV5izBPgVDcvta
         Obww==
X-Gm-Message-State: AOAM531/Bw03bwhIF5UXuHpqkWkXNWvTZx+Zhj9eaFWmYU8ZkwC6XVyN
        bU5tFPMeFdJ3/8PM6Uj+8atAQ9YdPLI=
X-Google-Smtp-Source: ABdhPJxPyEOxxqDIYNwgjAeeZrHfimY7GNc7Ltn9lvGWCQ9Lw0fZekJQj1mHokO+KyKBt5e/7m5MR2Yd05I=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:cf12:b0:14f:e0c2:1515 with SMTP id
 i18-20020a170902cf1200b0014fe0c21515mr8814824plg.4.1646974115128; Thu, 10 Mar
 2022 20:48:35 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:48 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value per guest
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

Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
and save ID registers' sanitized value in the array at KVM_CREATE_VM.
Use the saved ones when ID registers are read by the guest or
userspace (via KVM_GET_ONE_REG).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/sys_regs.c         | 65 ++++++++++++++++++++++++-------
 3 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2869259e10c0..c041e5afe3d2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -101,6 +101,13 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+/*
+ * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+ * where 0<=crm<8, 0<=op2<8.
+ */
+#define KVM_ARM_ID_REG_MAX_NUM	64
+#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -137,6 +144,9 @@ struct kvm_arch {
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
 	bool ran_once;
+
+	/* ID registers for the guest. */
+	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
 };
 
 struct kvm_vcpu_fault_info {
@@ -736,6 +746,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void set_default_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4783dbf66df2..91110d996ed6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
+	set_default_id_regs(kvm);
 
 	return ret;
 out_free_stage2_pgd:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4dc2fba316ff..d2b3ad32ab5a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,8 @@
 
 #include "trace.h"
 
+static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
+
 /*
  * All of this file is extremely similar to the ARM coproc.c, but the
  * types are different. My gut feeling is that it should be pretty
@@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
@@ -1059,17 +1061,16 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-		struct sys_reg_desc const *r, bool raz)
+static bool is_id_reg(u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (raz)
-		return 0;
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 0 &&
+		sys_reg_CRm(id) < 8);
+}
 
-	val = read_sanitised_ftr_reg(id);
+static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
+{
+	u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1119,6 +1120,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+		       struct sys_reg_desc const *r, bool raz)
+{
+	u32 id = reg_to_encoding(r);
+
+	return raz ? 0 : read_id_reg_with_encoding(vcpu, id);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -1223,9 +1232,8 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 /*
  * cpufeature ID register user accessors
  *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
+ * For now, these registers are immutable for userspace, so for set_id_reg()
+ * we don't allow the effective value to be changed.
  */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1837,8 +1845,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = read_id_reg_with_encoding(vcpu, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = read_id_reg_with_encoding(vcpu, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
@@ -2850,3 +2858,30 @@ void kvm_sys_reg_table_init(void)
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
 }
+
+/*
+ * Set the guest's ID registers that are defined in sys_reg_descs[]
+ * with ID_SANITISED() to the host's sanitized value.
+ */
+void set_default_id_regs(struct kvm *kvm)
+{
+	int i;
+	u32 id;
+	const struct sys_reg_desc *rd;
+	u64 val;
+
+	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		rd = &sys_reg_descs[i];
+		if (rd->access != access_id_reg)
+			/* Not ID register, or hidden/reserved ID register */
+			continue;
+
+		id = reg_to_encoding(rd);
+		if (WARN_ON_ONCE(!is_id_reg(id)))
+			/* Shouldn't happen */
+			continue;
+
+		val = read_sanitised_ftr_reg(id);
+		kvm->arch.id_regs[IDREG_IDX(id)] = val;
+	}
+}
-- 
2.35.1.723.g4982287a31-goog

