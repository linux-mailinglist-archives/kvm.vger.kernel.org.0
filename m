Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE59485FA8
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiAFE2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiAFE2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:28:03 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED75C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:28:03 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id h9-20020a628309000000b004ba70782342so913766pfe.20
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8NK/NkjJrdr7DQJSZBjte4dAGAWNGAk0Ls9I2fpGSC8=;
        b=ObJWlgDp86+WLT4zCB70Yng3hAvf89jSUnS4VfPEeXr9/R3plCoboHB1GKoYbsu4k1
         +hE7vFzYPwmT2enSZpupB4icwP13k9fRbKVqPhAjL30Wq2dvoXU8LtBfdM2+DbydHJVt
         qFtZsLn4rFYkbedJOzcFFqGa4/CC758qMEJwxv7F1pNo/ebs1R10eruNYDX49vbcJJBe
         3P3td3m7WcFcmxqW0CltzZ6T5r+xN9NQeUbNMlCvUtJoTFNqzs3tkIHHFeTn9e7E4VVN
         Cjp5JUTmfIv3zThTW4UEvPjeys7wOqAKZcv779Dobb5+AqTvJaHS2R12Y2X6KtIHlfa6
         PruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8NK/NkjJrdr7DQJSZBjte4dAGAWNGAk0Ls9I2fpGSC8=;
        b=jhZBtwYPHclwD5g7qp6BVTsVMQ6UCWTIFMH67JY+axN7ptZ9/QHYNOGM2mFjPH6yxD
         AW4R8oZnDZrJeh15Iq08rQAUkujoSaio02vco0qDeu6bARgD/J3YeOjzLh6fXGx4y77t
         t5mF8PdeySOIqqjJz0J6Qkfg8+vPKgSTWmW5nJcl66m1A2pqkrBTNFV36PPYlDnmobqT
         t3COj50B1WfRMSqjcIRJthuF+SjI1J4C8jjOJx1JDDspWTAWHuP1KdOd39WF0RNdda+f
         vfATsoav8ByzKEP5rRYCP+DcbufEOfgnEmg5K74JyLr3CmuPWZp3YR6bQC3gxDUlfsuA
         Tf/w==
X-Gm-Message-State: AOAM530udavJamV8EBb1JG75XW94S6WmJcHGUUdMRW5t2I2vqf/xVIY/
        8B4MNhT6WlgWUjEWLQbfz7Aiw3N3ouY=
X-Google-Smtp-Source: ABdhPJxnPBO/VKijl7yM7GkobJy/nbiOAoB866hRrYTD8esun0iPMs6pZGsms8LnW7X3Nnkk8iqDrjuYV4U=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:d716:b0:149:89cc:6b23 with SMTP id
 w22-20020a170902d71600b0014989cc6b23mr41912427ply.162.1641443283019; Wed, 05
 Jan 2022 20:28:03 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:26:43 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 01/26] KVM: arm64: Introduce a validation function for
 an ID register
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

Introduce arm64_check_features(), which does a basic validity checking
of an ID register value against the register's limit value, which is
generally the host's sanitized value.

This function will be used by the following patches to check if an ID
register value that userspace tries to set for a guest can be supported
on the host.

The validation is done using arm64_ftr_bits_kvm, which is created from
arm64_ftr_regs, with some entries overwritten by entries from
arm64_ftr_bits_kvm_override.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h |   1 +
 arch/arm64/kernel/cpufeature.c      | 228 ++++++++++++++++++++++++++++
 2 files changed, 229 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..eda7ddbed8cf 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -631,6 +631,7 @@ void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
+int arm64_check_features(u32 sys_reg, u64 val, u64 limit);
 
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6f3e677d88f1..48dff8b101d9 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3140,3 +3140,231 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 		return sprintf(buf, "Vulnerable\n");
 	}
 }
+
+#ifdef CONFIG_KVM
+/*
+ * arm64_ftr_bits_kvm[] is used for KVM to check if features that are
+ * indicated in an ID register value for the guest are available on the host.
+ * arm64_ftr_bits_kvm[] is created based on arm64_ftr_regs[].  But, for
+ * registers for which arm64_ftr_bits_kvm_override[] has a corresponding
+ * entry, replace arm64_ftr_bits entries in arm64_ftr_bits_kvm[] with the
+ * ones in arm64_ftr_bits_kvm_override[].
+ */
+static struct __ftr_reg_bits_entry *arm64_ftr_bits_kvm;
+static size_t arm64_ftr_bits_kvm_nentries;
+static DEFINE_MUTEX(arm64_ftr_bits_kvm_lock);
+
+/*
+ * Number of arm64_ftr_bits entries for each register.
+ * (Number of 4 bits fields in 64 bit register + 1 entry for ARM64_FTR_END)
+ */
+#define	MAX_FTR_BITS_LEN	17
+
+/* Use FTR_LOWER_SAFE for AA64DFR0_EL1.PMUVER and AA64DFR0_EL1.DEBUGVER. */
+static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
+	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
+	ARM64_FTR_END,
+};
+
+#define	ARM64_FTR_REG_BITS(id, table)	{	\
+	.sys_id = id,				\
+	.ftr_bits = &((table)[0]),		\
+}
+
+struct __ftr_reg_bits_entry {
+	u32	sys_id;
+	struct arm64_ftr_bits	*ftr_bits;
+};
+
+/*
+ * All entries in arm64_ftr_bits_kvm_override[] are used to override
+ * the corresponding entries in arm64_ftr_bits_kvm[].
+ */
+static struct __ftr_reg_bits_entry arm64_ftr_bits_kvm_override[] = {
+	ARM64_FTR_REG_BITS(SYS_ID_AA64DFR0_EL1, ftr_id_aa64dfr0_kvm),
+};
+
+/*
+ * Override entries in @orig_ftrp with the ones in @new_ftrp when their shift
+ * fields match.  The last entry of @orig_ftrp and @new_ftrp must be
+ * ARM64_FTR_END (.width == 0).
+ */
+static void arm64_ftr_reg_bits_overrite(struct arm64_ftr_bits *orig_ftrp,
+					struct arm64_ftr_bits *new_ftrp)
+{
+	struct arm64_ftr_bits *o_ftrp, *n_ftrp;
+
+	for (n_ftrp = new_ftrp; n_ftrp->width; n_ftrp++) {
+		for (o_ftrp = orig_ftrp; o_ftrp->width; o_ftrp++) {
+			if (o_ftrp->shift == n_ftrp->shift) {
+				*o_ftrp = *n_ftrp;
+				break;
+			}
+		}
+	}
+}
+
+/*
+ * Copy arm64_ftr_bits entries from @src_ftrp to @dst_ftrp.  The last entries
+ * of @dst_ftrp and @src_ftrp must be ARM64_FTR_END (.width == 0).
+ */
+static void copy_arm64_ftr_bits(struct arm64_ftr_bits *dst_ftrp,
+				const struct arm64_ftr_bits *src_ftrp)
+{
+	int i = 0;
+
+	for (; src_ftrp[i].width; i++) {
+		if (WARN_ON_ONCE(i >= (MAX_FTR_BITS_LEN - 1)))
+			break;
+
+		dst_ftrp[i] = src_ftrp[i];
+	}
+
+	dst_ftrp[i].width = 0;
+}
+
+/*
+ * Initialize arm64_ftr_bits_kvm.  Copy arm64_ftr_bits for each ID register
+ * from arm64_ftr_regs to arm64_ftr_bits_kvm, and then override entries in
+ * arm64_ftr_bits_kvm with ones in arm64_ftr_bits_kvm_override.
+ */
+static int init_arm64_ftr_bits_kvm(void)
+{
+	struct arm64_ftr_bits ftr_temp[MAX_FTR_BITS_LEN];
+	static struct __ftr_reg_bits_entry *reg_bits_array, *bits, *o_bits;
+	int i, j, nent, ret;
+
+	mutex_lock(&arm64_ftr_bits_kvm_lock);
+	if (arm64_ftr_bits_kvm) {
+		/* Already initialized */
+		ret = 0;
+		goto unlock_exit;
+	}
+
+	nent = ARRAY_SIZE(arm64_ftr_regs);
+	reg_bits_array = kcalloc(nent, sizeof(struct __ftr_reg_bits_entry),
+				 GFP_KERNEL);
+	if (!reg_bits_array) {
+		ret = ENOMEM;
+		goto unlock_exit;
+	}
+
+	/* Copy entries from arm64_ftr_regs to reg_bits_array */
+	for (i = 0; i < nent; i++) {
+		bits = &reg_bits_array[i];
+		bits->sys_id = arm64_ftr_regs[i].sys_id;
+		bits->ftr_bits = (struct arm64_ftr_bits *)arm64_ftr_regs[i].reg->ftr_bits;
+	};
+
+	/*
+	 * Override the entries in reg_bits_array with the ones in
+	 * arm64_ftr_bits_kvm_override.
+	 */
+	for (i = 0; i < ARRAY_SIZE(arm64_ftr_bits_kvm_override); i++) {
+		o_bits = &arm64_ftr_bits_kvm_override[i];
+		for (j = 0; j < nent; j++) {
+			bits = &reg_bits_array[j];
+			if (bits->sys_id != o_bits->sys_id)
+				continue;
+
+			memset(ftr_temp, 0, sizeof(ftr_temp));
+
+			/*
+			 * Temporary save all entries in o_bits->ftr_bits
+			 * to ftr_temp.
+			 */
+			copy_arm64_ftr_bits(ftr_temp, o_bits->ftr_bits);
+
+			/*
+			 * Copy entries from bits->ftr_bits to o_bits->ftr_bits.
+			 */
+			copy_arm64_ftr_bits(o_bits->ftr_bits, bits->ftr_bits);
+
+			/*
+			 * Override entries in o_bits->ftr_bits with the
+			 * saved ones, and update bits->ftr_bits with
+			 * o_bits->ftr_bits.
+			 */
+			arm64_ftr_reg_bits_overrite(o_bits->ftr_bits, ftr_temp);
+			bits->ftr_bits = o_bits->ftr_bits;
+			break;
+		}
+	}
+
+	arm64_ftr_bits_kvm_nentries = nent;
+	arm64_ftr_bits_kvm = reg_bits_array;
+	ret = 0;
+
+unlock_exit:
+	mutex_unlock(&arm64_ftr_bits_kvm_lock);
+	return ret;
+}
+
+static int search_cmp_ftr_reg_bits(const void *id, const void *regp)
+{
+	return ((int)(unsigned long)id -
+		(int)((const struct __ftr_reg_bits_entry *)regp)->sys_id);
+}
+
+static const struct arm64_ftr_bits *get_arm64_ftr_bits_kvm(u32 sys_id)
+{
+	const struct __ftr_reg_bits_entry *ret;
+	int err;
+
+	if (!arm64_ftr_bits_kvm) {
+		/* arm64_ftr_bits_kvm is not initialized yet. */
+		err = init_arm64_ftr_bits_kvm();
+		if (err)
+			return NULL;
+	}
+
+	ret = bsearch((const void *)(unsigned long)sys_id,
+		      arm64_ftr_bits_kvm,
+		      arm64_ftr_bits_kvm_nentries,
+		      sizeof(arm64_ftr_bits_kvm[0]),
+		      search_cmp_ftr_reg_bits);
+	if (ret)
+		return ret->ftr_bits;
+
+	return NULL;
+}
+
+/*
+ * Check if features (or levels of features) that are indicated in the ID
+ * register value @val are also indicated in @limit.
+ * This function is for KVM to check if features that are indicated in @val,
+ * which will be used as the ID register value for its guest, are supported
+ * on the host.
+ * For AA64MMFR0_EL1.TGranX_2 fields, which don't follow the standard ID
+ * scheme, the function checks if values of the fields in @val are the same
+ * as the ones in @limit.
+ */
+int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
+{
+	const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);
+	u64 exposed_mask = 0;
+
+	if (!ftrp)
+		return -ENOENT;
+
+	for (; ftrp->width; ftrp++) {
+		s64 ftr_val = arm64_ftr_value(ftrp, val);
+		s64 ftr_lim = arm64_ftr_value(ftrp, limit);
+
+		exposed_mask |= arm64_ftr_mask(ftrp);
+
+		if (ftr_val == ftr_lim)
+			continue;
+
+		if (ftr_val != arm64_ftr_safe_value(ftrp, ftr_val, ftr_lim))
+			return -E2BIG;
+	}
+
+	/* Make sure that no unrecognized fields are set in @val. */
+	if (val & ~exposed_mask)
+		return -E2BIG;
+
+	return 0;
+}
+#endif /* CONFIG_KVM */
-- 
2.34.1.448.ga2b2bfdf31-goog

