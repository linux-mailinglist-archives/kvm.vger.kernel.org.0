Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4234E39CD
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 08:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiCVHqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 03:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiCVHq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 03:46:28 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF1C29822
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 00:42:38 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z6so9767155iot.0
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 00:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rHrnAaz5t76UG2JwgEvwPleGU0MvRMDMpxjoGYiF+CQ=;
        b=AqNqTzOP6nOh+P8EhP5YaQVXwSpBaB4EOZgmXMB0voLFwbLZUI7NgJbtOZQlaeY6Nz
         gVqNg3sl4QnKntKarOFgu/rZPofdwCq26OzT8CyuxJygAsmIGcv6V/SGCoaKagPsk6Wp
         9yE7Gc4gVL9dAO7/BST/RG+q306x2Qe/kwi4SDDP30yrio0KgPodEbHKzMacVWho7kta
         J2HGFOb+tZM1fJRBadYLB3E+O07sN1tBk4U1gSTjwCelgE0p5yzO3x10KX4tbLCJvQru
         yrFJ2+a88cR2VFFoBEIs8CA+owPGwCuypJiT50r1aYNtyOfk+XmyvCD/sU0Xu8bLaFTF
         4vPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rHrnAaz5t76UG2JwgEvwPleGU0MvRMDMpxjoGYiF+CQ=;
        b=r8SDHyiNQjwD4SkoK3luQgclgtMteLovnF6+bvj6OZM6cPYSSJ3JMJasFCpOxIucV/
         TZH3CvpWOFdRDLA8SH8+qCPYj0LIJym+xmf/YqAuurZ+vuBliqgs+ipBD5O762yuom3k
         r5sTshIRfTENvERnxIiMXBfPbk7/ByDMm4qnvZ2xpQlDlHNCBvVmbsmINWvNn3+LfzwF
         N8ntM8oFdShSBZPRJVCUJllmoa2lSee8vW2TamiMX7Y8xDWYzpKPAHicTqkK8WTViQ1z
         6aJkHhK+abupZtcCJe4buU1oz3jc19fw7KMp/XDhBisTe8wLIpNcQegPabugvq0f6D3b
         DqLA==
X-Gm-Message-State: AOAM533SLzBIcEWzrbde1wkdnCwP6qf5cRnI7/N0rQZwj7qSTYMVaTTc
        tuQDCc9InSAhA6FxbF5fKVx9Dg==
X-Google-Smtp-Source: ABdhPJxdEupF10MGveiVRreMiqsEJc59sTLObwFckWBLfHJmNdEDcg4GwP43G51CHlniwAF+42ZCBw==
X-Received: by 2002:a05:6638:2195:b0:31a:8815:f0c0 with SMTP id s21-20020a056638219500b0031a8815f0c0mr8418816jaj.301.1647934957686;
        Tue, 22 Mar 2022 00:42:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f2-20020a056e020b4200b002c805b9b4c4sm6259885ilu.16.2022.03.22.00.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 00:42:36 -0700 (PDT)
Date:   Tue, 22 Mar 2022 07:42:33 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for
 an ID register
Message-ID: <Yjl96UQ7lUovKBWD@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Jy922konoFvWkL0i"
Content-Disposition: inline
In-Reply-To: <20220311044811.1980336-2-reijiw@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Jy922konoFvWkL0i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Reiji,

On Thu, Mar 10, 2022 at 08:47:47PM -0800, Reiji Watanabe wrote:
> Introduce arm64_check_features(), which does a basic validity checking
> of an ID register value against the register's limit value, which is
> generally the host's sanitized value.
> 
> This function will be used by the following patches to check if an ID
> register value that userspace tries to set for a guest can be supported
> on the host.
> 
> The validation is done using arm64_ftr_bits_kvm, which is created from
> arm64_ftr_regs, with some entries overwritten by entries from
> arm64_ftr_bits_kvm_override.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

I have some concerns regarding the API between cpufeature and KVM that's
being proposed here. It would appear that we are adding some of KVM's
implementation details into the cpufeature code. In particular, I see
that KVM's limitations on AA64DFR0 are being copied here.

Additionally, I think it would be preferable to expose this in a manner
that does not require CONFIG_KVM guards in other parts of the kernel.

WDYT about having KVM keep its set of feature overrides and otherwise
rely on the kernel's feature tables? I messed around with the idea a
bit until I could get something workable (attached). I only compile
tested this :)

--
Thanks,
Oliver

--Jy922konoFvWkL0i
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-arm64-cpufeature-Expose-a-helper-for-validating-feat.patch"

From e095ae6f138418bdb0981b6ef2c07930736aa2c2 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oupton@google.com>
Date: Tue, 22 Mar 2022 07:22:28 +0000
Subject: [PATCH] arm64: cpufeature: Expose a helper for validating feature
 registers

KVM is another part of the kernel that needs to deal with feature
registers. Subsequent changes to KVM will make the feature ID registers
writable from userspace, allowing VMMs to limit the exposed ISA to its
guests. However, KVM does not have any good constructs for validating
whether a particular register value constitutes a subset of the features
supported by the system.

Add a helper to check that a feature register value is a subset of the
system's safe value. Allow the caller to specify a set of overridden
feature fields for the case where KVM is more restrictive than the
kernel.

Signed-off-by: Oliver Upton <oupton@google.com>
Change-Id: Iffb134b5517d143377832d9236d5840183283e7f
---
 arch/arm64/include/asm/cpufeature.h |  8 +++
 arch/arm64/kernel/cpufeature.c      | 82 +++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..3cda05f5c0e9 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -63,6 +63,12 @@ struct arm64_ftr_bits {
 	s64		safe_val; /* safe value for FTR_EXACT features */
 };
 
+/* Terminator for an array of struct arm64_ftr_bits */
+#define ARM64_FTR_END					\
+	{						\
+		.width = 0,				\
+	}
+
 /*
  * Describe the early feature override to the core override code:
  *
@@ -632,6 +638,8 @@ void check_local_cpu_capabilities(void);
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
 
+bool arm64_ftr_reg_valid(u32 sys_id, u64 val, const struct arm64_ftr_bits *override);
+
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
 	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e5f23dab1c8d..ba09fbd7b2d0 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -172,11 +172,6 @@ EXPORT_SYMBOL(cpu_hwcap_keys);
 #define S_ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
 	__ARM64_FTR_BITS(FTR_SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL)
 
-#define ARM64_FTR_END					\
-	{						\
-		.width = 0,				\
-	}
-
 static void cpu_enable_cnp(struct arm64_cpu_capabilities const *cap);
 
 static bool __system_matches_cap(unsigned int n);
@@ -751,6 +746,83 @@ static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 	return ret;
 }
 
+static bool arm64_ftr_field_valid(const struct arm64_ftr_bits *ftrp, s64 new,
+				 s64 cur)
+{
+	return arm64_ftr_safe_value(ftrp, new, cur) == new;
+}
+
+bool __arm64_ftr_reg_valid(const struct arm64_ftr_bits *ftr_bits, u64 val,
+			   u64 safe_val, u64 *mask)
+{
+	const struct arm64_ftr_bits *ftrp;
+	s64 bits, safe_bits;
+	u64 ftr_mask;
+
+	for (ftrp = ftr_bits; ftrp->width; ftrp++) {
+		/*
+		 * Skip validation of the field if mask indicates the field has
+		 * already been checked.
+		 */
+		ftr_mask = arm64_ftr_mask(ftr_bits);
+		if (*mask & ftr_mask)
+			continue;
+
+		*mask |= ftr_mask;
+
+		safe_bits = arm64_ftr_value(ftr_bits, safe_val);
+		bits = arm64_ftr_value(ftr_bits, val);
+
+		/*
+		 * Check to see if 'val' attempts to advertise more than is
+		 * actually supported.
+		 */
+		if (!arm64_ftr_field_valid(ftr_bits, bits, safe_bits))
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * arm64_ftr_reg_valid() - Determines if a feature register value constitutes a
+ * subset of features supported by the system.
+ *
+ * @sys_reg: The encoded feature register ID
+ * @val: The feature value register to check
+ * @override: Pointer to an ARM64_FTR_END terminated array of overrides. Certain
+ *	      subsystems (such as KVM) are more restrictive than the kernel and
+ *	      impose tighter limits on certain feature fields.
+ *
+ * Return: true if 'val' is an allowed subset of features w.r.t. the system and
+ * the caller-provided overrides.
+ */
+bool arm64_ftr_reg_valid(u32 sys_reg, u64 val, const struct arm64_ftr_bits *override)
+{
+	const struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
+	u64 safe_val;
+	u64 mask = 0;
+
+	if (!reg)
+		return false;
+
+	safe_val = read_sanitised_ftr_reg(sys_reg);
+
+	/*
+	 * Use caller overrides for checking field validity, then check what's
+	 * remaining with our feature table.
+	 */
+	if (!__arm64_ftr_reg_valid(override, val, safe_val, &mask) ||
+	    !__arm64_ftr_reg_valid(reg->ftr_bits, val, safe_val, &mask))
+		return false;
+
+	/* Ensure that no unrecognized fields are set */
+	if (val & ~mask)
+		return false;
+
+	return true;
+}
+
 static void __init sort_ftr_regs(void)
 {
 	unsigned int i;
-- 
2.35.1.894.gb6a874cedc-goog


--Jy922konoFvWkL0i--
