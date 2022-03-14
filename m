Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536F84D7ABC
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 07:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiCNGXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 02:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiCNGXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 02:23:50 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53495403E3
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 23:22:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u4-20020a63b544000000b0037c62d8b0ecso9442745pgo.13
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 23:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xenb/1ISCk7dcRLaKlYQ+e2AP/GZy2ZjysoZ1kcszrY=;
        b=DSUsF7N3aIFH1i1fTiCK9CjN0QW6D948QKOUlGlh2UuiOkdNkXd8RKrg5hzi2McXzo
         Yby/XWXIvNWGESZTDF8EZBUzIjSXbtani23vt4vvf6d5zF+x20Ga5ICMET2gIZ/dvsUX
         QWYoNcTbBByUQiyuTCQYOj9Zti+Di3oUzex757zRF2Ny3h3//N1l284qlz1H1lufVjeg
         l5XOd+QHb3g5ky4wLgKXg5hj0zQZ9TTjtJciJm1xrJ+zgNPRZQb1eMmSeLfRIh9JcB30
         8YS6rj1msDgtrUUuH45JJCSCpPjfij2qrjZgxUxpaXdQdKONK+7IhD224Vxfb1Xkkvln
         Cqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xenb/1ISCk7dcRLaKlYQ+e2AP/GZy2ZjysoZ1kcszrY=;
        b=ar7wrYw9le/TgowQmzGJMZMWNG+a/R7l3/Zzd29e8/VTPe8Pv274MBJnEXAvW7hQLy
         LZRYpiEBN/NarQqrTcYNJgk/thXtQC+Tub8Lx57Q0tLdQd4m5vLI1blOE0MhHtYi5V/g
         zc0tmcKRgyGe1+T+u9V/nlyyVxxvhwESUkLTi4hWn3nmiVOgrWkpALOtBTcRWEWdJuty
         j+UrIK7gkL7X9IgcTELZHLBzpfDppMmTTJ9G+a2+ViOn+bDUZ7PdLYt1RbIfEJWDJCee
         gUQjMiqBUw0qz0dagu7FmgE6MSahgDVch3kTDsEHulFHCzbZPjA3dAkJFUwLlOXM5LhY
         mzlQ==
X-Gm-Message-State: AOAM532R8DRQl3rh29JlkIW0QLdoWJiLNJlZVftchEnL5fSHe2JyYjQc
        fltiDrr1mjr1RyDndVZXI6uY/89XP9E=
X-Google-Smtp-Source: ABdhPJzOI3/KfFAuIBvluYrBdn2RPKcQ0dKj9zPVWBd0OLQsXs16GIBzPmI+10IH5RnAHwVrLDsOYvjMMZ8=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:f708:b0:153:839f:bf2c with SMTP id
 h8-20020a170902f70800b00153839fbf2cmr1817565plo.113.1647238960836; Sun, 13
 Mar 2022 23:22:40 -0700 (PDT)
Date:   Sun, 13 Mar 2022 23:19:57 -0700
In-Reply-To: <20220314061959.3349716-1-reijiw@google.com>
Message-Id: <20220314061959.3349716-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220314061959.3349716-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 1/3] KVM: arm64: Generalise VM features into a set of flags
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
2.35.1.723.g4982287a31-goog

