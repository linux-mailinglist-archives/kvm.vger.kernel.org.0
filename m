Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB61352D526
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiESNw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238965AbiESNuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:50:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC6C49F37
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C962C617A6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3E8C34116;
        Thu, 19 May 2022 13:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968094;
        bh=yfv/vQKADWjGkdBJvYkXwUJ0o4vv6c5SpCbBBPRGgJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enJFxxMLTdCW1oDtkbsEEik4y7sHN9Bev+iph2vEztvwtIMBc8d1+tbGlXB8quSpT
         UL2qz4FhDigx3GQig5rWvxsVwLdbMi6wKOzZ/NCW/0jkQwtTpTaxawnSkOa20oOorA
         wYKhGCD5N+iJq73s8m+s3PqHFb3HZ8oevAhX7T+QRhsRS4FxAxPWG6PebGOhrKXqc2
         7zRBSaoCSJbRRQwz18nrpYH/qLrdBYYo2qq9A00PUrT5nvoN+0VOLrEvTScBhAMdZS
         nJ1nQKRgPxOC3qQ6EI0XALxal/qEMkfEUUT4LjIgKl2ZAWmodutx8VrYZT/wZdHbcv
         maBd7eqbeoo/g==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 88/89] KVM: arm64: Introduce KVM_VM_TYPE_ARM_PROTECTED machine type for PVMs
Date:   Thu, 19 May 2022 14:42:03 +0100
Message-Id: <20220519134204.5379-89-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new virtual machine type, KVM_VM_TYPE_ARM_PROTECTED, which
specifies that the guest memory pages are to be unmapped from the host
stage-2 by the hypervisor.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h |  2 +-
 arch/arm64/kvm/arm.c              |  5 ++++-
 arch/arm64/kvm/mmu.c              |  3 ---
 arch/arm64/kvm/pkvm.c             | 10 +++++++++-
 include/uapi/linux/kvm.h          |  6 ++++++
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 062ae2ffbdfb..952e3c3fa32d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -16,7 +16,7 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
-int kvm_init_pvm(struct kvm *kvm);
+int kvm_init_pvm(struct kvm *kvm, unsigned long type);
 int kvm_shadow_create(struct kvm *kvm);
 void kvm_shadow_destroy(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5a935a9a73..26fd69727c81 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -141,11 +141,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	if (type & ~KVM_VM_TYPE_MASK)
+		return -EINVAL;
+
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
 
-	ret = kvm_init_pvm(kvm);
+	ret = kvm_init_pvm(kvm, type);
 	if (ret)
 		goto err_unshare_kvm;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 137d4382ed1c..392ff7b2362d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -652,9 +652,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 67aad91dc3e5..ebf93ff6a77e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -218,8 +218,16 @@ void kvm_shadow_destroy(struct kvm *kvm)
 	}
 }
 
-int kvm_init_pvm(struct kvm *kvm)
+int kvm_init_pvm(struct kvm *kvm, unsigned long type)
 {
 	mutex_init(&kvm->arch.pkvm.shadow_lock);
+
+	if (!(type & KVM_VM_TYPE_ARM_PROTECTED))
+		return 0;
+
+	if (!is_protected_kvm_enabled())
+		return -EINVAL;
+
+	kvm->arch.pkvm.enabled = true;
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 91a6fe4e02c0..fdb0289cfecc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -887,6 +887,12 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
+#define KVM_VM_TYPE_ARM_PROTECTED	(1UL << 8)
+
+#define KVM_VM_TYPE_MASK	(KVM_VM_TYPE_ARM_IPA_SIZE_MASK | \
+				 KVM_VM_TYPE_ARM_PROTECTED)
+
 /*
  * ioctls for /dev/kvm fds:
  */
-- 
2.36.1.124.g0e6072fb45-goog

