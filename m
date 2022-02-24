Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B91A4C33B3
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiBXR0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiBXR0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:26:44 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6347278CA4
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:13 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id z14-20020a170902ccce00b0014d7a559635so1414803ple.16
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KaCBuwIyBaYjU3K7NXFsCjZcUQNiR1GDNYO7qs8JETY=;
        b=fZLUwv+joWr/KbhO5KrM6woBx5STObKXzVBlyItFKgfFX2ppVopErWfQyAyqmXKCOx
         7jRwCDUOzx9jtL9EJrqyC/h3OjKVMzzyFz22XYWAHaCiZM7gegqLJnyaBcr8T5zHpdMc
         WxFEKpGgcJlSYHmcbY8TWDHaP1af46W4E8eFFpT51tXxeM+DuvDCrZzLSr9DJPPkwsQS
         T5eMRo5XWoO6q/1IOYfMQqIBfbOTzUbuS539VeFrhKfo6c8/nzkGGzldC/mEabJedqZ9
         yaiXtwieY8sApFSm6D1pDeaUqDdNWzspj3NWfIR4fKioNKKnUVMBh9ogvyH0g+Rk1pJ1
         zbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KaCBuwIyBaYjU3K7NXFsCjZcUQNiR1GDNYO7qs8JETY=;
        b=Rl/2IBJrqbE7xd5oAQzl6Rn4r7ZA5Ajd4el4FeE/n+UVvpHAbIv3fajGmB/zMZ6IBW
         1EF+NUP3hXUQQXa5nBxXJrv1QU5XK2gYJNPh6/2/qKeqsC9Jo+Dje7RYh1PiqWgkJVkB
         x1O5vqTPfi57AroRvbr8nvu8a90uJ8xKudq7vPE+136ypeyl0dIN7hAx6dftKh5GF7l3
         MRGHCw/U0xv6N2rGNby95ZUOeR1Kof7vMhx5dMDrgkeumRQgviOdzKL8N4R4fTPmJpIJ
         N/KvHSOA2OCcTYOFjHe/9siHyXq+tmZCQXaAmGmiUooAz6aLAOZ8s5UjvtQy7djwOega
         Lj4g==
X-Gm-Message-State: AOAM533wUsaZK+ZuM33Iam1dlaDencF8pa6ob538FC0c8YqNO/XE7IOB
        mBicblIHItRSoHlUmQw07d3kbGR2oPfr
X-Google-Smtp-Source: ABdhPJxMtaJZ3smrZYeKjDmBPhXAaNSzbfO+lVKvJuxUWaHxzZNzmp4RLYQj5GycYVgIiIBYBxCU6HzY8eFt
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:5ac6:0:b0:4df:34dc:d6c5 with SMTP id
 o189-20020a625ac6000000b004df34dcd6c5mr3940421pfb.9.1645723573162; Thu, 24
 Feb 2022 09:26:13 -0800 (PST)
Date:   Thu, 24 Feb 2022 17:25:49 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-4-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 03/13] KVM: arm64: Encode the scope for firmware registers
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The psuedo-firmware registers, KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1
and KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, can be scopped as per-VM
registers. Hence, during the KVM_GET_REG_LIST call, encode
KVM_REG_ARM_SCOPE_VM into the registers, but during
KVM_[GET|SET]_ONE_REG calls, clear the scope information such that
they can be processed like before.

For future expansion, helper functions such as
kvm_arm_reg_id_encode_scope() and kvm_arm_reg_id_clear_scope()
are introduced.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/kvm/guest.c            | 77 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c       | 31 +++++++++----
 3 files changed, 100 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8132de6bd718..657733554d98 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -794,6 +794,8 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
 int kvm_trng_call(struct kvm_vcpu *vcpu);
+int kvm_arm_reg_id_encode_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
+void kvm_arm_reg_id_clear_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
 extern phys_addr_t hyp_mem_size;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 8238e52d890d..eb061e64a7a5 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -61,6 +61,83 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
+/* Registers that are VM scopped */
+static const u64 kvm_arm_vm_scope_fw_regs[] = {
+	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
+	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
+};
+
+/**
+ * kvm_arm_reg_id_encode_scope - Encode the KVM_REG_ARM_SCOPE info into the
+ *				 register-id
+ * @vcpu: The vcpu pointer
+ * @reg_id: Pointer to the register
+ *
+ * The function adds the register's scoping information into its encoding.
+ * If it's explicitly marked as a per-VM register, it's encoded with
+ * KVM_REG_ARM_SCOPE_VM. Else, it's marked as KVM_REG_ARM_SCOPE_VCPU, which
+ * is also the default if KVM_CAP_ARM_REG_SCOPE is disabled.
+ *
+ * For any error cases, the function returns an error code, else it returns
+ * the integer value of the encoding.
+ */
+int kvm_arm_reg_id_encode_scope(struct kvm_vcpu *vcpu, u64 *reg_id)
+{
+	const u64 *vm_scope_reg_arr;
+	unsigned int arr_size, idx;
+
+	if (!READ_ONCE(vcpu->kvm->arch.reg_scope_enabled))
+		return KVM_REG_ARM_SCOPE_VCPU;
+
+	if (!reg_id)
+		return -EINVAL;
+
+	switch (*reg_id & KVM_REG_ARM_COPROC_MASK) {
+	case KVM_REG_ARM_FW:
+		vm_scope_reg_arr = kvm_arm_vm_scope_fw_regs;
+		arr_size = ARRAY_SIZE(kvm_arm_vm_scope_fw_regs);
+		break;
+	default:
+		/* All the other register classes are currently
+		 * treated as per-vCPU registers.
+		 */
+		return KVM_REG_ARM_SCOPE_VCPU;
+	}
+
+	/* By default, all the registers encodings are scoped as vCPU.
+	 * Modify the scope only if a register is marked as per-VM.
+	 */
+	for (idx = 0; idx < arr_size; idx++) {
+		if (vm_scope_reg_arr[idx] == *reg_id) {
+			*reg_id |=
+				KVM_REG_ARM_SCOPE_VM << KVM_REG_ARM_SCOPE_SHIFT;
+			return KVM_REG_ARM_SCOPE_VM;
+		}
+	}
+
+	return KVM_REG_ARM_SCOPE_VCPU;
+}
+
+/**
+ * kvm_arm_reg_id_clear_scope - Clear the KVM_REG_ARM_SCOPE info from the
+ *				 register-id
+ * @vcpu: The vcpu pointer
+ * @reg_id: Pointer to the register
+ *
+ * The function clears the register's scoping information, which ultimately
+ * is the raw encoding of the register. Note that the result is same as that
+ * of re-encoding the register as KVM_REG_ARM_SCOPE_VCPU.
+ * The function can be helpful to the existing code that uses the original
+ * register encoding to operate on the register.
+ */
+void kvm_arm_reg_id_clear_scope(struct kvm_vcpu *vcpu, u64 *reg_id)
+{
+	if (!READ_ONCE(vcpu->kvm->arch.reg_scope_enabled) || !reg_id)
+		return;
+
+	*reg_id &= ~(1 << KVM_REG_ARM_SCOPE_SHIFT);
+}
+
 static bool core_reg_offset_is_vreg(u64 off)
 {
 	return off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs) &&
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 3c2fcf31ad3d..8624e6964940 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -160,10 +160,17 @@ int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	int i;
+	int i, ret;
+	u64 reg_id;
 
 	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
-		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
+		reg_id = kvm_arm_fw_reg_ids[i];
+
+		ret = kvm_arm_reg_id_encode_scope(vcpu, &reg_id);
+		if (ret < 0)
+			return ret;
+
+		if (put_user(reg_id, uindices++))
 			return -EFAULT;
 	}
 
@@ -214,21 +221,23 @@ static int get_kernel_wa_level(u64 regid)
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
-	u64 val;
+	u64 val, reg_id = reg->id;
 
-	switch (reg->id) {
+	kvm_arm_reg_id_clear_scope(vcpu, &reg_id);
+
+	switch (reg_id) {
 	case KVM_REG_ARM_PSCI_VERSION:
 		val = kvm_psci_version(vcpu, vcpu->kvm);
 		break;
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
-		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
+		val = get_kernel_wa_level(reg_id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
 	default:
 		return -ENOENT;
 	}
 
-	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
+	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg_id)))
 		return -EFAULT;
 
 	return 0;
@@ -237,13 +246,15 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
-	u64 val;
+	u64 val, reg_id = reg->id;
 	int wa_level;
 
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
-	switch (reg->id) {
+	kvm_arm_reg_id_clear_scope(vcpu, &reg_id);
+
+	switch (reg_id) {
 	case KVM_REG_ARM_PSCI_VERSION:
 	{
 		bool wants_02;
@@ -270,7 +281,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
 			return -EINVAL;
 
-		if (get_kernel_wa_level(reg->id) < val)
+		if (get_kernel_wa_level(reg_id) < val)
 			return -EINVAL;
 
 		return 0;
@@ -306,7 +317,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		 * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
 		 * other way around.
 		 */
-		if (get_kernel_wa_level(reg->id) < wa_level)
+		if (get_kernel_wa_level(reg_id) < wa_level)
 			return -EINVAL;
 
 		return 0;
-- 
2.35.1.473.g83b2b277ed-goog

