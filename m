Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CB54C33AA
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiBXR0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiBXR0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:26:42 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF3B278C9B
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id e7-20020a17090a4a0700b001bc5a8c533eso1738782pjh.4
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zwE5cEiZetqja2vTCL0nln/ypguSZC8fkvH9hAsICEY=;
        b=LH+vDy+8ljzpicztnBAsbYWVN/aATE2Kmw8jVkRvb5AmwHm3Ky1fKJ4iIhhozC0xfN
         00nBusB/t7F5cZwHxAuierFsQrUSZ3rCPuoDVxm8QuFjcgWpF32iwuXO6dGgAKY+D4Nk
         FvKJRHLNE5tNX0D89rzPT/YTI4nLxoktj+rfcCckFSljNttUEvkXz9xJ5EhnyKA518Pj
         Dj0Yr70wBcWcRbOGY6FVpu2plko5nX7djwY45eKlfm2KgjR2xayqTAlhashQB/NxPCEY
         oPZM50Y73mowM3F4rMjiF4pcYJIRtPl4PjMaZ52lAMHvyDQC7K2GQNNn/+3C38/C9HEm
         Cw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zwE5cEiZetqja2vTCL0nln/ypguSZC8fkvH9hAsICEY=;
        b=MGDX1Uw4DJFhJnrtgYw5GRxSiTA76J997n9d3QLNaRrl6eXEwkg6gYrZxkVGt0G6QL
         2u1Yr6TI6KbMDj3W3XZ6eTwqLSNn9Rz+t2c6Nrk07BYw0TLVpG/+FsIA2j0Kkx6chtVP
         PVYpdIGYsXTj7H3vXwWGDFQdZVYZCBYoJrl1xW5z3jYgyY7Bp4XvqBxfcK/Xq5b2CzV8
         logsq7GBqh9nAb1xK0OHy7Sa8i2qCTsM2CgFd/iUUIsVMtMaOlfBcDRYpkab8c+0ih5H
         74I/vE0KY6+kLDQO4PgMqu/QIUxHw3GnNeAdomFKKUfC73jGUbPXqNHs5xAVfJPFWuu1
         6bUw==
X-Gm-Message-State: AOAM532r3wY8AgcimNgwoC4uFbxqCEyoIBcl2en/tNLE4GTkjek9Vfk/
        bS2Ehyxnw5kzNHVKviOWLv/rxlq2wGpn
X-Google-Smtp-Source: ABdhPJwfEvyME9PSudMtl/0BdcjrGMwthB+z29yBgicXmdecZAiSEcSau/lGG27t2U3spq2A4jebc9Q1/DXt
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:6902:b0:14d:6aa4:f3f5 with SMTP id
 j2-20020a170902690200b0014d6aa4f3f5mr3575116plk.20.1645723571006; Thu, 24 Feb
 2022 09:26:11 -0800 (PST)
Date:   Thu, 24 Feb 2022 17:25:48 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-3-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 02/13] KVM: arm64: Introduce KVM_CAP_ARM_REG_SCOPE
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_[GET|SET]_ONE_REG act on per-vCPU basis. Currently certain
ARM64 registers, such as KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_[1|2],
are accessed via this interface even though the effect that
they have are really per-VM. As a result, userspace could just
waste cycles to read/write the same information for every vCPU
that it spawns, only to realize that there's absolutely no change
in the VM's state. The problem gets worse in proportion to the
number of vCPUs created.

As a result, to avoid this redundancy, introduce the capability
KVM_CAP_ARM_REG_SCOPE. If enabled, KVM_GET_REG_LIST will advertise
the registers that are VM-scoped by dynamically modifying the
register encoding. KVM_REG_ARM_SCOPE_* helper macros are introduced
to decode the same. By learning this, userspace can access such
registers only once.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/api.rst    | 16 ++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/include/uapi/asm/kvm.h |  6 ++++++
 arch/arm64/kvm/arm.c              | 13 +++++++------
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..7e7b3439f540 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7561,3 +7561,19 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.34 KVM_CAP_ARM_REG_SCOPE
+--------------------------
+
+:Architectures: arm64
+
+The capability, if enabled, amends the existing register encoding
+with additional information to the userspace if a particular register
+is scoped per-vCPU or per-VM via KVM_GET_REG_LIST. KVM provides
+KVM_REG_ARM_SCOPE_* helper macros to decode the same. Userspace can
+use this information from the register encoding to access a VM-scopped
+regiser only once, as opposed to accessing it for every vCPU for the
+same effect.
+
+On the other hand, if the capability is disabled, all the registers
+remain vCPU-scopped by default, retaining backward compatibility.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..8132de6bd718 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -136,6 +136,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* Register scoping enabled for KVM registers */
+	bool reg_scope_enabled;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..c35447cc0e0c 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -199,6 +199,12 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
 
+/* Defines if a KVM register is one per-vCPU or one per-VM */
+#define KVM_REG_ARM_SCOPE_MASK		0x0000000010000000
+#define KVM_REG_ARM_SCOPE_SHIFT		28
+#define KVM_REG_ARM_SCOPE_VCPU		0
+#define KVM_REG_ARM_SCOPE_VM		1
+
 /* Normal registers are mapped as coprocessor 16. */
 #define KVM_REG_ARM_CORE		(0x0010 << KVM_REG_ARM_COPROC_SHIFT)
 #define KVM_REG_ARM_CORE_REG(name)	(offsetof(struct kvm_regs, name) / sizeof(__u32))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..107977c82c6c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -81,26 +81,26 @@ int kvm_arch_check_processor_compat(void *opaque)
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-	int r;
+	int r = 0;
 
 	if (cap->flags)
 		return -EINVAL;
 
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
-		r = 0;
 		kvm->arch.return_nisv_io_abort_to_user = true;
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() || kvm->created_vcpus) {
+		if (!system_supports_mte() || kvm->created_vcpus)
 			r = -EINVAL;
-		} else {
-			r = 0;
+		else
 			kvm->arch.mte_enabled = true;
-		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_REG_SCOPE:
+		WRITE_ONCE(kvm->arch.reg_scope_enabled, true);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -209,6 +209,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_REG_SCOPE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..c4fe81ed9ee6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_REG_SCOPE 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.473.g83b2b277ed-goog

