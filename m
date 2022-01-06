Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C767485FAA
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiAFE2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiAFE2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:28:30 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EBBC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:28:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id h9-20020a628309000000b004ba70782342so914355pfe.20
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EkoeIsqMczRcinvp0cilVSzAUE+PP6SO7Fh6sKQOBws=;
        b=FBImx4TPy9v5PSlzAR15SPjZn+YrtYuJNEaf6AQdOfIYvPoSKVJmvINnkR92uLnGrG
         OMWHfBA4FWNahAXDYlj4zpCM93icomaGW3iDKX9OOqxxgdlC2IVEoaH3lY0JV/19MboH
         2VMXO7c3CGFioM1KpjVAh6RZYYYwP5a1CEqSxrp1ukiP2sUyvlucWg6L+zcfWZUeEXCC
         vJOTHWzYRDucy6XJhdwfIA4k6b19xEvz81L8GEd6YxYXZg9ESE7m07sUmCoVR5wTFS0b
         jfcu2LNNPSIuV3KlURyTm/ub9DVurIHyJ/gw45qe2KcQf3TLEX78Sb+TYhDHrDAX2WVi
         NAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EkoeIsqMczRcinvp0cilVSzAUE+PP6SO7Fh6sKQOBws=;
        b=Y5SsUDI3bG6gdXR1Z2bgJiwtyS1v0P3LAD8j6K7r4YgfN17L34GEKmyJDTMuiYa+3l
         LPTq0/bitLM6aeLE1UGkfch5MN2RqlVWtvEIojhnMRm42P9zHI2c/Y5+QLUOxxYAMq3Q
         mi/cQJuJ1e02bpNtV038Xh/dldQzEsb/RfMSlQoSpLeUheL3QR7VE/LdDAialoiR2f2T
         /cANpL6H0fSRyNFGkSR/PBuZs8kc0enPeOTGzzUp5crG9wfNcv59/hGH73Sk/gJBcmga
         p3WSPSI4JlkrjqHK3Wfi8iJy6/ZFLrRFtjZdyJhF/WapFX4qADWceEK9D/7xRcNf9JsJ
         uCbQ==
X-Gm-Message-State: AOAM532uN9xYWWrPk3vRbq/UhKu4YbVl51hlQATy7QVFz3GbY6MYqd4o
        Zbli6YQdkYLtYEkSyr586+8WWJv+YtY=
X-Google-Smtp-Source: ABdhPJzBUsu7ZR8Jlsk519I2qtj9M1T0WfnwAR78hCj88K/fqA7TwlTGMpRjIxb/hu1t2/GiJfgqbhrvHxk=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:d702:: with SMTP id
 y2mr2397pju.1.1641443310002; Wed, 05 Jan 2022 20:28:30 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:26:44 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized value
 per guest
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

Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
and save ID registers' sanitized value in the array at KVM_CREATE_VM.
Use the saved ones when ID registers are read by the guest or
userspace (via KVM_GET_ONE_REG).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 16 ++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/sys_regs.c         | 62 ++++++++++++++++++++++---------
 3 files changed, 62 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..c789a0137f58 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -102,6 +102,17 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+/*
+ * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+ * where 0<=crm<8, 0<=op2<8.
+ */
+#define KVM_ARM_ID_REG_MAX_NUM	64
+#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
+#define is_id_reg(id)	\
+	(sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&	\
+	 sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 0 &&	\
+	 sys_reg_CRm(id) < 8)
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -137,6 +148,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* ID registers for the guest. */
+	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
 };
 
 struct kvm_vcpu_fault_info {
@@ -734,6 +748,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void set_default_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e4727dc771bf..5f497a0af254 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
+	set_default_id_regs(kvm);
 
 	return ret;
 out_free_stage2_pgd:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3ec1a44f94d..80dc62f98ef0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -33,6 +33,8 @@
 
 #include "trace.h"
 
+static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
+
 /*
  * All of this file is extremely similar to the ARM coproc.c, but the
  * types are different. My gut feeling is that it should be pretty
@@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
@@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-		struct sys_reg_desc const *r, bool raz)
+static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (raz)
-		return 0;
-
-	val = read_sanitised_ftr_reg(id);
+	u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+		       struct sys_reg_desc const *r, bool raz)
+{
+	u32 id = reg_to_encoding(r);
+
+	return raz ? 0 : __read_id_reg(vcpu, id);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -1223,9 +1225,8 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -1237,7 +1238,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct kvm_vcpu *vcpu,
+static int __set_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
@@ -1837,8 +1838,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
@@ -2850,3 +2851,30 @@ void kvm_sys_reg_table_init(void)
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
2.34.1.448.ga2b2bfdf31-goog

