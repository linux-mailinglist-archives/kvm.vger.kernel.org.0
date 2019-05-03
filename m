Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3904612E0F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfECMp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:45:57 -0400
Received: from foss.arm.com ([217.140.101.70]:60432 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbfECMp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:45:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D4DC80D;
        Fri,  3 May 2019 05:45:56 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 661F63F220;
        Fri,  3 May 2019 05:45:53 -0700 (PDT)
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
Subject: [PATCH 21/56] KVM: arm/arm64: Add hook for arch-specific KVM initialisation
Date:   Fri,  3 May 2019 13:43:52 +0100
Message-Id: <20190503124427.190206-22-marc.zyngier@arm.com>
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

This patch adds a kvm_arm_init_arch_resources() hook to perform
subarch-specific initialisation when starting up KVM.

This will be used in a subsequent patch for global SVE-related
setup on arm64.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 2 ++
 arch/arm64/include/asm/kvm_host.h | 2 ++
 virt/kvm/arm/arm.c                | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 770d73257ad9..a49ee01242ff 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -53,6 +53,8 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+static inline int kvm_arm_init_arch_resources(void) { return 0; }
+
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 205438a108f6..3e8950942591 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -58,6 +58,8 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+static inline int kvm_arm_init_arch_resources(void) { return 0; }
+
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 99c37384ba7b..c69e1370a5dc 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1664,6 +1664,10 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		return err;
 
+	err = kvm_arm_init_arch_resources();
+	if (err)
+		return err;
+
 	if (!in_hyp_mode) {
 		err = init_hyp_mode();
 		if (err)
-- 
2.20.1

