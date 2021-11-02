Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0248644249D
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 01:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhKBAZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 20:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbhKBAZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 20:25:01 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DD3C061764
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 17:22:27 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y124-20020a623282000000b0047a09271e49so10256708pfy.16
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 17:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hPqT43aj6nY4JmFWc0P3u2Z1LLF2JnBNG4boSS8J4fE=;
        b=mxHWwBOOucV4ivRJ4WUAygrlSxktQUTDc8uv8yPlgR1RaXnPzPDYQHKjAAhaiOGFZi
         sxMXMScEG+Vlj44ByweTMNX4aD1PRm38CB2O5bAQz7RA9gtprCuFqIoNrnhUtFIjgM8l
         99whUuqnAm4bY1OnvkUrULvNlguYxHm5lmr1WNMzPG8Q/fF/QTaTL82llwWWqH6ICifH
         hkGIwdMxL7G1Wuj5LfZRuBa9LFWHioS8wrXXOXau8rI0whlZu6J1jZv75nLCr6Uhxmt6
         D5HtTtAresWKS6qd2FIRkhSZW5y9IwF9o5oBI1z7M2uGMvnUZWvs1JLpCJb/tDF8sJis
         i5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hPqT43aj6nY4JmFWc0P3u2Z1LLF2JnBNG4boSS8J4fE=;
        b=SzflZ1ElevDNC5dVhOolsq1WTitil/LNcNJ06wsF6jYGEl74L/SLFEZqSfiZ8pRx9X
         VZ+cVEdfvxlX1y7ox06Fuq/zsaLZfNPAy0kgAHw8C/QDsh84vorC8X5RAbbEReErt4x4
         6gt6x3teF/EYGAl1tDBJvv4pV3zLnDiXThF0MPfhcf+QKS6Vx7k1MmAm8zYiNdL3Qzyh
         mifyH3b4yIEVE/v24t1YRyFPc5zo8XF/2am0+mBewiXR9NXsOhq9Mds2rvE6Fw7hgd/P
         zX3C6iC3mDaUB+pM6++SK6vxMkrBHvp8zZFGq3h6e4gfrX2pThYELkIQlAJuKG9h59g+
         sg2Q==
X-Gm-Message-State: AOAM530Ea6rjwBU+UAg2u3axnlsBnrXucw5fUtzwKSJ5eqYidrSSKRo0
        +5v6iWS9O4q9+cQGw0ZsCeGQ2Z4RUDCQ
X-Google-Smtp-Source: ABdhPJxthlYooPKxIImySxtUb93JZ9YktYOntoS3BLY4YGfcx/3dVHrNX51FUZU2jqeG/Y6UDgsSNbqVkis7
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:2ad:b0:480:fae5:2693 with SMTP id
 q13-20020a056a0002ad00b00480fae52693mr14727650pfs.37.1635812546584; Mon, 01
 Nov 2021 17:22:26 -0700 (PDT)
Date:   Tue,  2 Nov 2021 00:21:57 +0000
In-Reply-To: <20211102002203.1046069-1-rananta@google.com>
Message-Id: <20211102002203.1046069-3-rananta@google.com>
Mime-Version: 1.0
References: <20211102002203.1046069-1-rananta@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH 2/8] KVM: arm64: Setup base for hypercall firmware registers
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypercall firmware registers may hold versioning information
for a particular hypercall service. Before a VM starts, these
registers are read/write to the user-space. That is, it can freely
modify the fields as it sees fit for the guest. However, this
shouldn't be allowed once the VM is started since it may confuse
the guest as it may have read an older value. As a result, introduce
a helper interface to convert the registers to read-only once any
vCPU starts running.

Extend this interface to also clear off all the feature bitmaps of
the firmware registers upon first write. Since KVM exposes an upper
limit of the feature-set to user-space via these registers, this
action will ensure that no new features get enabled by accident if
the user-space isn't aware of a newly added register.

Since the upcoming changes introduces more firmware registers,
rename the documentation to PSCI (psci.rst) to a more generic
hypercall.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../virt/kvm/arm/{psci.rst => hypercalls.rst} | 24 +++----
 Documentation/virt/kvm/arm/index.rst          |  2 +-
 arch/arm64/include/asm/kvm_host.h             |  8 +++
 arch/arm64/kvm/arm.c                          |  7 +++
 arch/arm64/kvm/hypercalls.c                   | 62 +++++++++++++++++++
 5 files changed, 90 insertions(+), 13 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (81%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 81%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
index d52c2e83b5b8..85dfd682d811 100644
--- a/Documentation/virt/kvm/arm/psci.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -1,22 +1,19 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=========================================
-Power State Coordination Interface (PSCI)
-=========================================
+=======================
+ARM Hypercall Interface
+=======================
 
-KVM implements the PSCI (Power State Coordination Interface)
-specification in order to provide services such as CPU on/off, reset
-and power-off to the guest.
-
-The PSCI specification is regularly updated to provide new features,
-and KVM implements these updates if they make sense from a virtualization
+New hypercalls are regularly added by ARM specifications (or KVM), and
+are made available to the guests if they make sense from a virtualization
 point of view.
 
 This means that a guest booted on two different versions of KVM can
 observe two different "firmware" revisions. This could cause issues if
-a given guest is tied to a particular PSCI revision (unlikely), or if
-a migration causes a different PSCI version to be exposed out of the
-blue to an unsuspecting guest.
+a given guest is tied to a particular version of a specific hypercall
+(PSCI revision for instance (unlikely)), or if a migration causes a
+different (PSCI) version to be exposed out of the blue to an unsuspecting
+guest.
 
 In order to remedy this situation, KVM exposes a set of "firmware
 pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
@@ -26,6 +23,9 @@ to a convenient value if required.
 The following register is defined:
 
 * KVM_REG_ARM_PSCI_VERSION:
+    KVM implements the PSCI (Power State Coordination Interface)
+    specification in order to provide services such as CPU on/off, reset
+    and power-off to the guest.
 
   - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
     (and thus has already been initialized)
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 78a9b670aafe..e84848432158 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -8,6 +8,6 @@ ARM
    :maxdepth: 2
 
    hyp-abi
-   psci
+   hypercalls
    pvtime
    ptp_kvm
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d0221fb69a60..0b2502494a17 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -102,6 +102,11 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+struct hvc_reg_desc {
+	bool write_disabled;
+	bool write_attempted;
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -137,6 +142,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* Hypercall firmware registers' information */
+	struct hvc_reg_desc hvc_desc;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 24a1e86d7128..f9a25e439e99 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -630,6 +630,13 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
+	/* Mark the hypercall firmware registers as read-only since
+	 * at least once vCPU is about to start running.
+	 */
+	mutex_lock(&kvm->lock);
+	kvm->arch.hvc_desc.write_disabled = true;
+	mutex_unlock(&kvm->lock);
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index d030939c5929..7e873206a05b 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -58,6 +58,12 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
+static u64 *kvm_fw_reg_to_bmap(struct kvm *kvm, u64 fw_reg)
+{
+	/* No firmware registers supporting hvc bitmaps exits yet */
+	return NULL;
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -234,15 +240,71 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return 0;
 }
 
+static void kvm_fw_regs_sanitize(struct kvm *kvm, struct hvc_reg_desc *hvc_desc)
+{
+	unsigned int i;
+	u64 *hc_bmap = NULL;
+
+	mutex_lock(&kvm->lock);
+
+	if (hvc_desc->write_attempted)
+		goto out;
+
+	hvc_desc->write_attempted = true;
+
+	for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
+		hc_bmap = kvm_fw_reg_to_bmap(kvm, fw_reg_ids[i]);
+		if (hc_bmap)
+			*hc_bmap = 0;
+	}
+
+out:
+	mutex_unlock(&kvm->lock);
+}
+
+static bool
+kvm_fw_regs_block_write(struct kvm *kvm, struct hvc_reg_desc *hvc_desc, u64 val)
+{
+	bool ret = false;
+	unsigned int i;
+	u64 *hc_bmap = NULL;
+
+	mutex_lock(&kvm->lock);
+
+	for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
+		hc_bmap = kvm_fw_reg_to_bmap(kvm, fw_reg_ids[i]);
+		if (hc_bmap)
+			break;
+	}
+
+	if (!hc_bmap)
+		goto out;
+
+	/* Do not allow any updates if the VM has already started */
+	if (hvc_desc->write_disabled && val != *hc_bmap)
+		ret = true;
+
+out:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
+	struct kvm *kvm = vcpu->kvm;
+	struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
 	u64 val;
 	int wa_level;
 
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
+	if (kvm_fw_regs_block_write(kvm, hvc_desc, val))
+		return -EBUSY;
+
+	kvm_fw_regs_sanitize(kvm, hvc_desc);
+
 	switch (reg->id) {
 	case KVM_REG_ARM_PSCI_VERSION:
 		return kvm_arm_set_psci_fw_reg(vcpu, val);
-- 
2.33.1.1089.g2158813163f-goog

