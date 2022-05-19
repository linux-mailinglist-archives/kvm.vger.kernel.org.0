Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF23552D4E9
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiESNr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbiESNqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D651E3E0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECBE5617C1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBF5C34117;
        Thu, 19 May 2022 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967975;
        bh=uG8rE6eI1bG8REgLyDqei99z8VOKVa5T7JzjFS4MdB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJDWsHte1Eu+CXoQnGl0DFP2gcLbZEghMyQd/21cT5hZiCV37gyHB9wuLpFV0jDoV
         /MEFad8mDennEV68Sjjj1yF1QfMylazGmaJAO2lz4ZAY2A9jMQ2YI99lnGU16IMTs0
         6+pOTw8rog5ISVG1XBbd1+r9UTI90bRuJH6b7pa8eTb/lrPZVzpJUIL/GbiHyYYLjQ
         2c7uHgv/zJezCvj25R8lTAGAbikTAwnVfkt1XYqTYT6BV49VoHQxcJ8MQOprTKHl05
         pI6wECdwl/UN/AEd7ExrIz5xOIF34sY2ghghGgGy/zfzvb9JVXIp+BEXS836Yr5HCN
         hUu7ctyFjyuzw==
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
Subject: [PATCH 58/89] KVM: arm64: Restrict protected VM capabilities
Date:   Thu, 19 May 2022 14:41:33 +0100
Message-Id: <20220519134204.5379-59-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Restrict protected VM capabilities based on the
fixed-configuration for protected VMs.

No functional change intended in current KVM-supported modes
(nVHE, VHE).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 27 ++++++++++++
 arch/arm64/kvm/arm.c              | 69 ++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index b92440cfb5b4..6f13f62558dd 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -208,6 +208,33 @@ void kvm_shadow_destroy(struct kvm *kvm);
 	ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) \
 	)
 
+/*
+ * Returns the maximum number of breakpoints supported for protected VMs.
+ */
+static inline int pkvm_get_max_brps(void)
+{
+	int num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS),
+			    PVM_ID_AA64DFR0_ALLOW);
+
+	/*
+	 * If breakpoints are supported, the maximum number is 1 + the field.
+	 * Otherwise, return 0, which is not compliant with the architecture,
+	 * but is reserved and is used here to indicate no debug support.
+	 */
+	return num ? num + 1 : 0;
+}
+
+/*
+ * Returns the maximum number of watchpoints supported for protected VMs.
+ */
+static inline int pkvm_get_max_wrps(void)
+{
+	int num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS),
+			    PVM_ID_AA64DFR0_ALLOW);
+
+	return num ? num + 1 : 0;
+}
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7c57c14e173a..10e036bf06e3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -194,9 +194,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_unshare_hyp(kvm, kvm + 1);
 }
 
-int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+static int kvm_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
+
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 		r = vgic_present;
@@ -294,6 +295,72 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+/*
+ * Checks whether the extension specified in ext is supported in protected
+ * mode for the specified vm.
+ * The capabilities supported by kvm in general are passed in kvm_cap.
+ */
+static int pkvm_check_extension(struct kvm *kvm, long ext, int kvm_cap)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_IRQCHIP:
+	case KVM_CAP_ARM_PSCI:
+	case KVM_CAP_ARM_PSCI_0_2:
+	case KVM_CAP_NR_VCPUS:
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+	case KVM_CAP_MSI_DEVID:
+	case KVM_CAP_ARM_VM_IPA_SIZE:
+		r = kvm_cap;
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_BPS:
+		r = min(kvm_cap, pkvm_get_max_brps());
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_WPS:
+		r = min(kvm_cap, pkvm_get_max_wrps());
+		break;
+	case KVM_CAP_ARM_PMU_V3:
+		r = kvm_cap && FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
+					 PVM_ID_AA64DFR0_ALLOW);
+		break;
+	case KVM_CAP_ARM_SVE:
+		r = kvm_cap && FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_SVE),
+					 PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
+		break;
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+		r = kvm_cap &&
+		    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_API),
+			      PVM_ID_AA64ISAR1_ALLOW) &&
+		    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA),
+			      PVM_ID_AA64ISAR1_ALLOW);
+		break;
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+		r = kvm_cap &&
+		    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI),
+			      PVM_ID_AA64ISAR1_ALLOW) &&
+		    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA),
+			      PVM_ID_AA64ISAR1_ALLOW);
+		break;
+	default:
+		r = 0;
+		break;
+	}
+
+	return r;
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r = kvm_check_extension(kvm, ext);
+
+	if (kvm && kvm_vm_is_protected(kvm))
+		r = pkvm_check_extension(kvm, ext, r);
+
+	return r;
+}
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
-- 
2.36.1.124.g0e6072fb45-goog

