Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A98429C7E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhJLEiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhJLEiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997DCC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x16-20020a25b910000000b005b6b7f2f91cso26132800ybj.1
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Z93DnbmChJRf3NM+LBnf4mN1DuMUD7rE5aIVZuW+HL0=;
        b=PtmrX72/0sGKpcnwJcLOf/UaKOFDQ+5S9S3IlXTMv7zJdIXpUksHL2ftiSNgSk+z4k
         QOVclAU5P4X9Hn/pdysFT9NVb9xUfiDDVUgHRpOzN5LQ0JSb/wOCRbJJLEiYyco6fVbu
         0dct7uPkpb+K55Tzg9Gfo7gpLDvfMVS9w3HYEaFzgieo2h7wFwYVqKhDi16h4WNF0HM6
         sw460YgYVjor3ULd0thxbX/NpQjjrrRfhAtzLlaJ779WGCI1aVuC8OWNxBREIKeEHjkR
         hXo2+jdZnTNhicSObQee3qNLC3uIHFMl5aYoQu/ZDSiFcrcch4+zkqs/q77gbV5eKKfe
         Lvew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Z93DnbmChJRf3NM+LBnf4mN1DuMUD7rE5aIVZuW+HL0=;
        b=JIAa7oqw5V+fLZLy/06ghPyMwl47lrjfScub+uaf6UQ6KOMeymjTQbNkIoSRC+KmIM
         dNFKi9KNgpNM6i3+WoU1U7K4D34ZyxLphFahhQru4tf2xPdIanp90/JeckD4OLHNpxf5
         779ubLln8cw8i8UcHCmxiRhFJnAUOS319viBMAiupwLc4aXEbuvKZQR6YYEdlyzXkPQr
         1KrU2SZuQdUbQ1+DI6guzSQ8uxKgFixd4ZOExS4oFX1TRHl0s6KuMfs/IOxTY3F+HvY1
         NCUhJ9EP/2WEZqleZWd0sCkf1i2k48h88Nm9RpUheHHwA+WKQNvmHJXQJi7/cJ6x4qAS
         2slw==
X-Gm-Message-State: AOAM530LGKGuFToPLezljbl4asK4vQvkp4JX9whfIYEM679IQ+F7H85y
        YONg57xf7l5YDHZ59bYjnaQnnSV1svs=
X-Google-Smtp-Source: ABdhPJyItztYg/nGIOk04Hx9xUnOSJKLgu2KzOyCL+f/o2RFo4gV8CWyqEUbibEQ2BnxvEaZPLTO7gz/xB8=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a25:2e01:: with SMTP id u1mr17924282ybu.363.1634013381864;
 Mon, 11 Oct 2021 21:36:21 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:12 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-3-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value per vCPU
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

Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
registers' sanitized value in the array for the vCPU at the first
vCPU reset. Use the saved ones when ID registers are read by
userspace (via KVM_GET_ONE_REG) or the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c         | 26 ++++++++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9b5e7a3b6011..0cd351099adf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
 	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
+/*
+ * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+ * where 0<=crm<8, 0<=op2<8.
+ */
+#define KVM_ARM_ID_REG_MAX_NUM 64
+#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
+#define IDREG_SYS_IDX(id)	(ID_REG_BASE + IDREG_IDX(id))
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
@@ -209,6 +217,8 @@ enum vcpu_sysreg {
 	CNTP_CVAL_EL0,
 	CNTP_CTL_EL0,
 
+	ID_REG_BASE,
+	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
 	/* Memory Tagging Extension registers */
 	RGSR_EL1,	/* Random Allocation Tag Seed Register */
 	GCR_EL1,	/* Tag Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..72ca518e7944 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
@@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = reg_to_encoding(r);
-	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
+	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	u32 id = reg_to_encoding(rd);
+
+	if (vcpu_has_reset_once(vcpu))
+		return;
+
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
+}
+
 static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       const struct kvm_one_reg *reg, void __user *uaddr)
@@ -1219,9 +1228,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 /*
  * cpufeature ID register user accessors
  *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
+ * We don't allow the effective value to be changed.
  */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1375,6 +1382,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
 	.access	= access_id_reg,		\
+	.reset	= reset_id_reg,			\
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
@@ -1830,8 +1838,10 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = __vcpu_sys_reg(vcpu,
+					 IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
+		u64 pfr = __vcpu_sys_reg(vcpu,
+					 IDREG_SYS_IDX(SYS_ID_AA64PFR0_EL1));
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
-- 
2.33.0.882.g93a45727a2-goog

