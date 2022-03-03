Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060DB4CB59E
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 04:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiCCD4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 22:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiCCD4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 22:56:06 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A29A14562B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 19:55:21 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2dbfe49a4aaso31556227b3.5
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 19:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7hpXMqaCEkEB7Bx15AIkPLODG6VSJouGbjh17YaxmTc=;
        b=OLpT04cetG8fcEWG5/b5prO9PeE1zRzjatqOWS9m9F75ZeuNMmMwnRotwWDPlQaixf
         utXpi/1iwLCp6gBKiUY7SRcGDL80co1c7/yLGdrHvCuLL4SbwyWIrLcx1zvcfcc9Q0E5
         zU7Znery7da7+ng1uq0iGaNam/ATVUnQQUGqxQG7kkTn2SdqWhQ4HlHSelu0zkzHEDBY
         9CK6Cn81oYdbT3S54AV4e8RLcsmMRLhWUgXVWaAUPLAMXNket6a3SUxGtiqzeoJUvzZZ
         waUQlYvEmRwx+RLFBIZcGQbD+Qa3XJkD4vyeUcS81LaNGDKH50lfIXIM8Thxcmmslc6N
         MTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7hpXMqaCEkEB7Bx15AIkPLODG6VSJouGbjh17YaxmTc=;
        b=RvHbr9loufD4dkDDfcnAo/8peglZyCXHU4As+tM5JuUpuiNpoZLQLLrFBbB/4rN2bk
         jOghI2Y20bO9S4/jsOPJF5tegdTspqstrI8oKY5gwZd4DjulvewezdaXP2kqvCJi1xV9
         rn5AAf2C5fq2aE5axa7ltP4r2sDwtqb3MfSko6eWp8Z1dHCEC9pMBshlOXpkTtOYr/V7
         z+64vVNRPqU+sxjJb4Y+oK1V+Py08pFula6cH/8q4vXEZ0wy1aCSvK0ruPsg00FiC1NP
         LodOHFB44642WEhn6BIEwkPThRf3VwaFMOZwZe3naGwdaKrNXAzqcuzrrxpwApRM6ojp
         GPug==
X-Gm-Message-State: AOAM531aqF1uUD/Hu75NEDnvFFQtwLSkNmjXm+J+P7Kb2R3woKhqkf/Z
        9oLfVDOJj+n5TzVdyG0tNV1SHXyrmF8=
X-Google-Smtp-Source: ABdhPJzUJIgejr3blx9qXWZIWOIzHNseYmCooyAJDB7EyY/J0oalqOvUtDwIAbZy2nCrb1py0++M00oZmGU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:4454:0:b0:60a:69f9:f1c5 with SMTP id
 r81-20020a254454000000b0060a69f9f1c5mr32171447yba.285.1646279720231; Wed, 02
 Mar 2022 19:55:20 -0800 (PST)
Date:   Wed,  2 Mar 2022 19:54:06 -0800
Message-Id: <20220303035408.3708241-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 1/3] KVM: arm64: Generalise VM features into a set of flags
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
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

We currently deal with a set of booleans for VM features,
while they could be better represented as set of flags
contained in an unsigned long, similarily to what we are
doing on the CPU side.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++-----
 arch/arm64/kvm/arm.c              |  5 +++--
 arch/arm64/kvm/mmio.c             |  3 ++-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..11a7ae747ded 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -122,7 +122,10 @@ struct kvm_arch {
 	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
 	 * supported.
 	 */
-	bool return_nisv_io_abort_to_user;
+#define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
+	/* Memory Tagging Extension enabled for the guest */
+#define KVM_ARCH_FLAG_MTE_ENABLED			1
+	unsigned long flags;
 
 	/*
 	 * VM-wide PMU filter, implemented as a bitmap and big enough for
@@ -133,9 +136,6 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
-
-	/* Memory Tagging Extension enabled for the guest */
-	bool mte_enabled;
 };
 
 struct kvm_vcpu_fault_info {
@@ -786,7 +786,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
-#define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
+#define kvm_has_mte(kvm)					\
+	(system_supports_mte() &&				\
+	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..9a2d240ef6a3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -89,7 +89,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
 		r = 0;
-		kvm->arch.return_nisv_io_abort_to_user = true;
+		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+			&kvm->arch.flags);
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
@@ -97,7 +98,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			r = -EINVAL;
 		} else {
 			r = 0;
-			kvm->arch.mte_enabled = true;
+			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 		}
 		mutex_unlock(&kvm->lock);
 		break;
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3e2d8ba11a02..3dd38a151d2a 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -135,7 +135,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	 * volunteered to do so, and bail out otherwise.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
-		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
+		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
 			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
 			run->arm_nisv.fault_ipa = fault_ipa;
-- 
2.35.1.574.g5d30c73bfb-goog

