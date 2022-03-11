Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22194D5A04
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiCKEtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346463AbiCKEtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:49:46 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1924F1AAFEB
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:34 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j9-20020a170903024900b0015195e68490so3903460plh.19
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=glthwEK6ZgvlT5BCv3FygX03+dB4t3Wompz6ZLZl/V4=;
        b=oviYyd1hL6FXW8xYwUit8H/JinCSV5FQkoO3lcvrchXcQFvfEiSq1X3c9NPTP7/j9d
         qTg5Fl6CX7dEBMl+88l0cCWi2zq0tyvG3mtfS4gFalQJ0YwYzamZ86x01f6n3pq0dXyp
         vN0gbdRRdKvSFLmojQIab9Ya9ZYaOVtOFX9HQGKJkllCYLQExOkmgw5HewYzzsahrafn
         Aj1lUK0Dn4B8o6PJ6V3opL61uVO2pHF8po63kJVpRRIW+y2oMBBP5J4hx7OgyirSpHT+
         QIN7GB2gBKoDJFzJ9Z07xJKB24YK8XhJ7zVVeaQdV9vLEBdDkylJajXhrEPlQ/t5qrWr
         vUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=glthwEK6ZgvlT5BCv3FygX03+dB4t3Wompz6ZLZl/V4=;
        b=WsHd9F9eSEDsa+E+1qUBut/PgUhSD1lh8r1SQeY8ij28tTeLhJRzq7lvHiyXz9Ya9F
         DEdVh6kcz0VWbvMybi73/DwThpqvo42/RkNrV2BfSd42//CVOpdLV1S5tGD9Nm7KzEa2
         UYmMNnNFuyhuq9JE5WdLHatqsHJXbQ4vZ2enr8dSPhryRFex0PxVRtKP5KaVvKpl5Y1/
         ToSmyNT1ZkwCPDzFf3oqgJVzXpWajA9fAudJLZNejsDr5KhCt+sVb+e+8VBjOe6e51h5
         iMwqv9MKQXZE5DaGbZM/deLTS2JXYQjW+KWfXDOCCxfIcT5d8lmRvw3k+ldQAc+PAF3f
         0hXg==
X-Gm-Message-State: AOAM530Zv9vPaM+atXqXI6TVC9l+Bjnm6LhWUdWGOp/ze5EoM96+oNi5
        yiGUgootpTa/y1K5h6TCLNJ2VHOAD8c=
X-Google-Smtp-Source: ABdhPJyDl7llyO11kbEl8dR7kC5MFAqZY1r0+1cYoSOlTioTkSnQq8vl9f4N+JpB633eoMtJSJWLqXRsVXU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:9043:b0:14f:aa08:8497 with SMTP id
 w3-20020a170902904300b0014faa088497mr8396367plz.109.1646974113545; Thu, 10
 Mar 2022 20:48:33 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:47 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for an
 ID register
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
 arch/arm64/kernel/cpufeature.c      | 229 ++++++++++++++++++++++++++++
 2 files changed, 230 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..a9edf1ca7dcb 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -631,6 +631,7 @@ void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
+int arm64_check_features_kvm(u32 sys_reg, u64 val, u64 limit);
 
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e5f23dab1c8d..bc0ed09aa1b5 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -928,6 +928,10 @@ static void init_32bit_cpu_features(struct cpuinfo_32bit *info)
 	init_cpu_ftr_reg(SYS_MVFR2_EL1, info->reg_mvfr2);
 }
 
+#ifdef CONFIG_KVM
+static void init_arm64_ftr_bits_kvm(void);
+#endif
+
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
 	/* Before we start using the tables, make sure it is sorted */
@@ -970,6 +974,14 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	 * after we have initialised the CPU feature infrastructure.
 	 */
 	setup_boot_cpu_capabilities();
+
+#ifdef CONFIG_KVM
+	/*
+	 * Initialize arm64_ftr_bits_kvm, which will be used to provide
+	 * KVM with general feature checking for its guests.
+	 */
+	init_arm64_ftr_bits_kvm();
+#endif
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -3156,3 +3168,220 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
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
+ *
+ * What to add to arm64_ftr_bits_kvm_override[] shouldn't be decided according
+ * to KVM's implementation, but according to schemes of ID register fields.
+ * (e.g. For ID_AA64DFR0_EL1.PMUVER, a higher value on the field indicates
+ * more features. So, the arm64_ftr_bits' type for the field can be
+ * FTR_LOWER_SAFE instead of FTR_EXACT unlike arm64_ftr_regs)
+ */
+
+/*
+ * The number of __ftr_reg_bits_entry entries in arm64_ftr_bits_kvm must be
+ * the same as the number of __ftr_reg_entry entries in arm64_ftr_regs.
+ */
+static struct __ftr_reg_bits_entry {
+	u32	sys_id;
+	struct arm64_ftr_bits	*ftr_bits;
+} arm64_ftr_bits_kvm[ARRAY_SIZE(arm64_ftr_regs)];
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
+static void arm64_ftr_reg_bits_override(struct arm64_ftr_bits *orig_ftrp,
+					const struct arm64_ftr_bits *new_ftrp)
+{
+	const struct arm64_ftr_bits *n_ftrp;
+	struct arm64_ftr_bits *o_ftrp;
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
+static void init_arm64_ftr_bits_kvm(void)
+{
+	struct arm64_ftr_bits ftr_temp[MAX_FTR_BITS_LEN];
+	static struct __ftr_reg_bits_entry *bits, *o_bits;
+	int i, j;
+
+	/* Copy entries from arm64_ftr_regs to arm64_ftr_bits_kvm */
+	for (i = 0; i < ARRAY_SIZE(arm64_ftr_bits_kvm); i++) {
+		bits = &arm64_ftr_bits_kvm[i];
+		bits->sys_id = arm64_ftr_regs[i].sys_id;
+		bits->ftr_bits = (struct arm64_ftr_bits *)arm64_ftr_regs[i].reg->ftr_bits;
+	};
+
+	/*
+	 * Override the entries in arm64_ftr_bits_kvm with the ones in
+	 * arm64_ftr_bits_kvm_override.
+	 */
+	for (i = 0; i < ARRAY_SIZE(arm64_ftr_bits_kvm_override); i++) {
+		o_bits = &arm64_ftr_bits_kvm_override[i];
+		for (j = 0; j < ARRAY_SIZE(arm64_ftr_bits_kvm); j++) {
+			bits = &arm64_ftr_bits_kvm[j];
+			if (bits->sys_id != o_bits->sys_id)
+				continue;
+
+			/*
+			 * The code below tries to sustain the ordering of
+			 * entries in bits even in o_bits, just in case
+			 * arm64_ftr_bits entries in arm64_ftr_regs have
+			 * any ordering requirements in the future (so that
+			 * the ones in arm64_ftr_bits_kvm_override doesn't
+			 * have to care).
+			 * So, rather than directly copying them to empty
+			 * slots in o_bits, the code simply copies entries
+			 * from bits to o_bits first, then overrides them with
+			 * original entries in o_bits.
+			 */
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
+			arm64_ftr_reg_bits_override(o_bits->ftr_bits, ftr_temp);
+			bits->ftr_bits = o_bits->ftr_bits;
+			break;
+		}
+	}
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
+
+	ret = bsearch((const void *)(unsigned long)sys_id,
+		      arm64_ftr_bits_kvm,
+		      ARRAY_SIZE(arm64_ftr_bits_kvm),
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
+int arm64_check_features_kvm(u32 sys_reg, u64 val, u64 limit)
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
2.35.1.723.g4982287a31-goog

