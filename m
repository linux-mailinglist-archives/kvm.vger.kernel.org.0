Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B7C12E25
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfECMq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:28 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60642 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbfECMq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 287CD16A3;
        Fri,  3 May 2019 05:46:28 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E539B3F220;
        Fri,  3 May 2019 05:46:24 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 30/56] KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to just set up SVE
Date:   Fri,  3 May 2019 13:44:01 +0100
Message-Id: <20190503124427.190206-31-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

The introduction of kvm_arm_init_arch_resources() looks like
premature factoring, since nothing else uses this hook yet and it
is not clear what will use it in the future.

For now, let's not pretend that this is a general thing:

This patch simply renames the function to kvm_arm_init_sve(),
retaining the arm stub version under the new name.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 2 +-
 virt/kvm/arm/arm.c                | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index e80cfc18412b..d95627393353 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -54,7 +54,7 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
-static inline int kvm_arm_init_arch_resources(void) { return 0; }
+static inline int kvm_arm_init_sve(void) { return 0; }
 
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
 int __attribute_const__ kvm_target_cpu(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9d57cf8be879..6adf08ba9277 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -59,7 +59,7 @@
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int kvm_sve_max_vl;
-int kvm_arm_init_arch_resources(void);
+int kvm_arm_init_sve(void);
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f13378d0a0ad..8847f389f56d 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -110,7 +110,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 unsigned int kvm_sve_max_vl;
 
-int kvm_arm_init_arch_resources(void)
+int kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9edbf0f676e7..7039c99cc217 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1682,7 +1682,7 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		return err;
 
-	err = kvm_arm_init_arch_resources();
+	err = kvm_arm_init_sve();
 	if (err)
 		return err;
 
-- 
2.20.1

