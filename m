Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CFE44F08F
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhKMB0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235837AbhKMB0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:26:02 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43D1C061203
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:23:10 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id l8-20020a056a0016c800b0049ffee8cebfso6547930pfc.20
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W9jgYHrBbOBPThTYAHaXWa7wASjXvARMo5Uw/YrP4D4=;
        b=j/7E/Vu3kI/f1cEYZS/kLiJf80TELS9BMtqVtMVK14mKCIl14PK7ClNZsBgnOLnTb4
         lVpbTvKA0n9MERMBMncC6o/S7pSa2rPaxrtRdBirpDqwbpN5JEJJBTmWEwTPzze8FIr7
         35bvrbOR+puUi1tS3dolUhQN6hZZzQaN/n3bftdWd38D5u+fQelOHw7irNv2JP7eWbwh
         wJri8Ec4MSC8KRrbZcFT6sxVw50msmp7OHJALPXjoeqWsDd4JseFzc+7rPeb2PWluIri
         KXj3KQKAsv1tvIB/gMG5EQctkI1vQFgAdc3r7sWxvzlv+nzsJcmxxYGgXwtSm50PheaZ
         N5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W9jgYHrBbOBPThTYAHaXWa7wASjXvARMo5Uw/YrP4D4=;
        b=YuyLadnMshGJPohYSuGRJiE2RodfTiGizFTI/ylZiaZRne3RhvGTIefpYARs5aIS28
         b/g+FnugKNKSX2vRVMOooN9N5t7eWGekLEW/tAyZYnKWgGWhxPvHyGLG7ZE8v/ZExkPt
         HssPCbTY/Go7fU62LZRcAhXQYLymKLqe1HRDbx8pIm/rRIB6NguBjwr6ZZhJU8fgEpeu
         S8OSBiU+MQBXfcSGcVjhEhva84qCntw08aN73bXrv+OrMJzmrZeN5qqb8miAG8e/5ISD
         X3OxhomyvyyMH3oC0Xctq/zcaf7air1nU5pJvJHz6jZGmf3GlngKhL7ba7kdOZISH1ku
         5wYQ==
X-Gm-Message-State: AOAM533kToy3PuIRsHOUZybAyC8UNXEnvpOTJ8ycHu2rnjOvhc2kv6Wn
        gmkENh9NVnGHHnpxEtlJzK/0h4JQdKwL
X-Google-Smtp-Source: ABdhPJwcBcvi28OtcoG+93M1eX9jXnuPRibbcU2MahTwrQfS01Fey723ak2y8SCBZC4gDLQsXQ3mgwAI2Skg
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1305:b0:4a2:75cd:883b with SMTP
 id j5-20020a056a00130500b004a275cd883bmr6889352pfu.44.1636766590385; Fri, 12
 Nov 2021 17:23:10 -0800 (PST)
Date:   Sat, 13 Nov 2021 01:22:34 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-12-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 11/11] selftests: KVM: aarch64: Add the bitmap firmware
 registers to get-reg-list
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bitmap firmware psuedo-registers needs special handling, such as
enabling the capability KVM_CAP_ARM_HVC_FW_REG_BMAP. Since there's
no support as of yet in get-reg-list to enable a capability, add a
field 'enable_capability' in the 'struct reg_sublist' to
incorporate this. Also, to not mess with the existing configurations,
create a new vcpu_config to hold these bitmap firmware registers.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..7479d0ae501e 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -40,6 +40,7 @@ static __u64 *blessed_reg, blessed_n;
 struct reg_sublist {
 	const char *name;
 	long capability;
+	long enable_capability;
 	int feature;
 	bool finalize;
 	__u64 *regs;
@@ -397,6 +398,19 @@ static void check_supported(struct vcpu_config *c)
 	}
 }
 
+static void enable_capabilities(struct kvm_vm *vm, struct vcpu_config *c)
+{
+	struct reg_sublist *s;
+
+	for_each_sublist(c, s) {
+		if (s->enable_capability) {
+			struct kvm_enable_cap cap = {.cap = s->enable_capability};
+
+			vm_enable_cap(vm, &cap);
+		}
+	}
+}
+
 static bool print_list;
 static bool print_filtered;
 static bool fixup_core_regs;
@@ -414,6 +428,7 @@ static void run_test(struct vcpu_config *c)
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
+	enable_capabilities(vm, c);
 	finalize_vcpu(vm, 0, c);
 
 	reg_list = vcpu_get_reg_list(vm, 0);
@@ -1014,6 +1029,12 @@ static __u64 sve_rejects_set[] = {
 	KVM_REG_ARM64_SVE_VLS,
 };
 
+static __u64 fw_reg_bmap_set[] = {
+	KVM_REG_ARM_FW_REG(3),		/* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_REG(4),		/* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_REG(5),		/* KVM_REG_ARM_VENDOR_HYP_BMAP */
+};
+
 #define BASE_SUBLIST \
 	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
 #define VREGS_SUBLIST \
@@ -1025,6 +1046,10 @@ static __u64 sve_rejects_set[] = {
 	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
 	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
 	  .rejects_set = sve_rejects_set, .rejects_set_n = ARRAY_SIZE(sve_rejects_set), }
+#define FW_REG_BMAP_SUBLIST \
+	{ "fw_reg_bmap", .regs = fw_reg_bmap_set, .regs_n = ARRAY_SIZE(fw_reg_bmap_set), \
+	 .capability = KVM_CAP_ARM_HVC_FW_REG_BMAP, \
+	 .enable_capability = KVM_CAP_ARM_HVC_FW_REG_BMAP, }
 
 static struct vcpu_config vregs_config = {
 	.sublists = {
@@ -1057,10 +1082,20 @@ static struct vcpu_config sve_pmu_config = {
 	},
 };
 
+static struct vcpu_config vregs_fw_regs_bmap_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	FW_REG_BMAP_SUBLIST,
+	{0},
+	},
+};
+
 static struct vcpu_config *vcpu_configs[] = {
 	&vregs_config,
 	&vregs_pmu_config,
 	&sve_config,
 	&sve_pmu_config,
+	&vregs_fw_regs_bmap_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.34.0.rc1.387.gb447b232ab-goog

