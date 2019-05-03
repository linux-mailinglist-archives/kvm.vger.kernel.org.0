Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8352612E48
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfECMrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:21 -0400
Received: from foss.arm.com ([217.140.101.70]:60962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbfECMrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD860165C;
        Fri,  3 May 2019 05:47:20 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75A0B3F220;
        Fri,  3 May 2019 05:47:17 -0700 (PDT)
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
Subject: [PATCH 45/56] KVM: arm64: Add userspace flag to enable pointer authentication
Date:   Fri,  3 May 2019 13:44:16 +0100
Message-Id: <20190503124427.190206-46-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Amit Daniel Kachhap <amit.kachhap@arm.com>

Now that the building blocks of pointer authentication are present, lets
add userspace flags KVM_ARM_VCPU_PTRAUTH_ADDRESS and
KVM_ARM_VCPU_PTRAUTH_GENERIC. These flags will enable pointer
authentication for the KVM guest on a per-vcpu basis through the ioctl
KVM_ARM_VCPU_INIT.

This features will allow the KVM guest to allow the handling of
pointer authentication instructions or to treat them as undefined
if not set.

Necessary documentations are added to reflect the changes done.

Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 .../arm64/pointer-authentication.txt          | 22 ++++++++++++---
 Documentation/virtual/kvm/api.txt             | 10 +++++++
 arch/arm64/include/asm/kvm_host.h             |  2 +-
 arch/arm64/include/uapi/asm/kvm.h             |  2 ++
 arch/arm64/kvm/reset.c                        | 27 +++++++++++++++++++
 5 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
index 5baca42ba146..fc71b33de87e 100644
--- a/Documentation/arm64/pointer-authentication.txt
+++ b/Documentation/arm64/pointer-authentication.txt
@@ -87,7 +87,21 @@ used to get and set the keys for a thread.
 Virtualization
 --------------
 
-Pointer authentication is not currently supported in KVM guests. KVM
-will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
-the feature will result in an UNDEFINED exception being injected into
-the guest.
+Pointer authentication is enabled in KVM guest when each virtual cpu is
+initialised by passing flags KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] and
+requesting these two separate cpu features to be enabled. The current KVM
+guest implementation works by enabling both features together, so both
+these userspace flags are checked before enabling pointer authentication.
+The separate userspace flag will allow to have no userspace ABI changes
+if support is added in the future to allow these two features to be
+enabled independently of one another.
+
+As Arm Architecture specifies that Pointer Authentication feature is
+implemented along with the VHE feature so KVM arm64 ptrauth code relies
+on VHE mode to be present.
+
+Additionally, when these vcpu feature flags are not set then KVM will
+filter out the Pointer Authentication system key registers from
+KVM_GET/SET_REG_* ioctls and mask those features from cpufeature ID
+register. Any attempt to use the Pointer Authentication instructions will
+result in an UNDEFINED exception being injected into the guest.
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index e410a9f0f0d4..32afe7f5c35a 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2761,6 +2761,16 @@ Possible features:
 	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
 	  Depends on KVM_CAP_ARM_PMU_V3.
 
+	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
+	  for arm64 only.
+	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
+	  must be requested or neither must be requested.
+
+	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
+	  for arm64 only.
+	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
+	  must be requested or neither must be requested.
+
 	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
 	  Depends on KVM_CAP_ARM_SVE.
 	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7eebea7059c6..f772ac2fb3e9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -49,7 +49,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 5
+#define KVM_VCPU_MAX_FEATURES 7
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index edd2db8e5160..7b7ac0f6cec9 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -104,6 +104,8 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
+#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
+#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3402543fdcd3..028d0c604652 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -221,6 +221,27 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
 }
 
+static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
+{
+	/* Support ptrauth only if the system supports these capabilities. */
+	if (!has_vhe())
+		return -EINVAL;
+
+	if (!system_supports_address_auth() ||
+	    !system_supports_generic_auth())
+		return -EINVAL;
+	/*
+	 * For now make sure that both address/generic pointer authentication
+	 * features are requested by the userspace together.
+	 */
+	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
+	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
+		return -EINVAL;
+
+	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
+	return 0;
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
@@ -261,6 +282,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		kvm_vcpu_reset_sve(vcpu);
 	}
 
+	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
+	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
+		if (kvm_vcpu_enable_ptrauth(vcpu))
+			goto out;
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-- 
2.20.1

