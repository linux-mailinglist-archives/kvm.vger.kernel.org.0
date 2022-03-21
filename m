Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0B04E2C3D
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 16:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350241AbiCUP3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 11:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350219AbiCUP3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 11:29:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CF5ABFE
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 08:28:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C6321477;
        Mon, 21 Mar 2022 08:28:11 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6427A3F73D;
        Mon, 21 Mar 2022 08:28:09 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        steven.price@arm.com, vladimir.murzin@arm.com
Subject: [kvmtool PATCH 2/2] aarch64: Add support for MTE
Date:   Mon, 21 Mar 2022 15:28:20 +0000
Message-Id: <20220321152820.246700-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321152820.246700-1-alexandru.elisei@arm.com>
References: <20220321152820.246700-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MTE has been supported in Linux since commit 673638f434ee ("KVM: arm64:
Expose KVM_ARM_CAP_MTE"), add support for it in kvmtool.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/include/kvm/kvm-arch.h        |  3 +++
 arm/aarch64/include/kvm/kvm-arch.h        |  1 +
 arm/aarch64/include/kvm/kvm-config-arch.h |  2 ++
 arm/aarch64/kvm.c                         | 13 +++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/kvm.c                                 |  3 +++
 6 files changed, 23 insertions(+)

diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index bee2fc255a82..5616b27e257e 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -5,6 +5,9 @@
 
 #define kvm__arch_get_kern_offset(...)	0x8000
 
+struct kvm;
+static inline void kvm__arch_enable_mte(struct kvm *kvm) {}
+
 #define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
 
 #define MAX_PAGE_SIZE	SZ_4K
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 5e5ee41211ed..9124f6919d0f 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -6,6 +6,7 @@
 struct kvm;
 unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
 int kvm__arch_get_ipa_limit(struct kvm *kvm);
+void kvm__arch_enable_mte(struct kvm *kvm);
 
 #define ARM_MAX_MEMORY(kvm)	({					\
 	u64 max_ram;							\
diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43dfa9b2..11250365d8d5 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -6,6 +6,8 @@
 			"Run AArch32 guest"),				\
 	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
 			"Create PMUv3 device"),				\
+	OPT_BOOLEAN('\0', "mte", &(cfg)->has_mte,			\
+			"Enable memory tagging extension"),		\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 56a0aedc263d..46548f8ee96e 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -81,3 +81,16 @@ int kvm__get_vm_type(struct kvm *kvm)
 
 	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
 }
+
+void kvm__arch_enable_mte(struct kvm *kvm)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_ARM_MTE,
+	};
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_MTE))
+		die("MTE capability is not supported");
+
+	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &cap))
+		die_perror("KVM_ENABLE_CAP(KVM_CAP_ARM_MTE)");
+}
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46ab9e6..16e8d500a71b 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -9,6 +9,7 @@ struct kvm_config_arch {
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
+	bool		has_mte;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
diff --git a/arm/kvm.c b/arm/kvm.c
index 80d233f13d0b..f2db93953778 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -86,6 +86,9 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
+
+	if (kvm->cfg.arch.has_mte)
+		kvm__arch_enable_mte(kvm);
 }
 
 #define FDT_ALIGN	SZ_2M
-- 
2.35.1

