Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1081139FB4D
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 17:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhFHP5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 11:57:14 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39799 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhFHP5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 11:57:13 -0400
Received: by mail-wr1-f43.google.com with SMTP id l2so22166002wrw.6
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 08:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KHEWXTvaTgGt1BVLxIfWQF63jGSa3hhv5Aeen36ISYE=;
        b=JFN/xiy0BsolYRMuvUu/vBBp8n6h7jDdIzTqFsPh8onZqCMTUkEyfq6+dShb/4jooa
         4BfzwPmDLIIGk+APV232oFKjNH8TwCxOn945UJ6HhpeB4bqxxI4sANfxPmyky5JN68ci
         /AeQ6D6u41JuYGXQIHDrsSjX9YypR07kCATFqSrHzVd6Hna45k6evaAFB/Ta/+knrIbg
         E9OfDY92p3KvHMlQALtdInffDDrQ4cNn9DMFrpOICKsXVojgNB0T664irg2FH/xP1tkt
         nFMHjilT2SK06OxmVp0ISWLldj3mSlNHtriZZyZOaHWdkzaZHNlefhrr6r7IKTaPn8iE
         1tsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KHEWXTvaTgGt1BVLxIfWQF63jGSa3hhv5Aeen36ISYE=;
        b=lzCiDSCtQFk73t75jpjLQjSErokc/6U1+mnb1Mr/5GnTaoLW1c21aUM9EfEJ7jzCvz
         ID7XDzjkvWn0DEjLxd8sUE6qTGJrkCNEf1PNLeR+3NC2NfPiHunwHCTRudEJ9WpuwMZp
         nh2wIomVWQPxoxOYEAOsWif4QhAdirVDGBC7TT41lK8mdbWI5RI3XqmNYkNdAAdLyOrq
         vQasaTXUoSUttkNhuC4f3oipHz+v5rviRZ2mIGHJRR8sAxZsnJxKeHe+ex1V76onwP3N
         aIwV4Gs4DLgaXSIdeq7I3WlO1cavqG1n3Hh1Gjs4L/+KqdoJ6+lrRA8mo2fm6f0Jlq04
         1YyA==
X-Gm-Message-State: AOAM533ZUfpslWLR3e29v+y/B77UaZ+UXt+0VySOhqsoKj6omI6XO7br
        6RJ232HkYB7GXosg1cT+izJiRQ==
X-Google-Smtp-Source: ABdhPJxIqvImjc8EYF1I8fYhJ8WzhBv5pnbK6ynBNA3UWFEPYAyfdGSMfbYuZieceMItwHj8Wy0EPA==
X-Received: by 2002:adf:f94c:: with SMTP id q12mr6581214wrr.417.1623167646586;
        Tue, 08 Jun 2021 08:54:06 -0700 (PDT)
Received: from localhost.localdomain (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
        by smtp.gmail.com with ESMTPSA id l31sm3314180wms.16.2021.06.08.08.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:54:05 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     maz@kernel.org
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, will@kernel.org,
        lorenzo.pieralisi@arm.com, salil.mehta@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 5/5] KVM: arm64: Pass PSCI calls to userspace
Date:   Tue,  8 Jun 2021 17:48:06 +0200
Message-Id: <20210608154805.216869-6-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608154805.216869-1-jean-philippe@linaro.org>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let userspace request to handle PSCI calls, by setting the new
KVM_CAP_ARM_PSCI_TO_USER capability.

SMCCC probe requires PSCI v1.x. If userspace only implements PSCI v0.2,
the guest won't query SMCCC support through PSCI and won't use the
spectre workarounds. We could hijack PSCI_VERSION and pretend to support
v1.0 if userspace does not, then handle all v1.0 calls ourselves
(including guessing the PSCI feature set implemented by the guest), but
that seems unnecessary. After all the API already allows userspace to
force a version lower than v1.0 using the firmware pseudo-registers.

The KVM_REG_ARM_PSCI_VERSION pseudo-register currently resets to either
v0.1 if userspace doesn't set KVM_ARM_VCPU_PSCI_0_2, or
KVM_ARM_PSCI_LATEST (1.0).

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Documentation/virt/kvm/api.rst      | 14 ++++++++++++++
 Documentation/virt/kvm/arm/psci.rst |  1 +
 arch/arm64/include/asm/kvm_host.h   |  1 +
 include/kvm/arm_hypercalls.h        |  1 +
 include/uapi/linux/kvm.h            |  1 +
 arch/arm64/kvm/arm.c                | 10 +++++++---
 arch/arm64/kvm/hypercalls.c         |  2 +-
 arch/arm64/kvm/psci.c               | 13 +++++++++++++
 8 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3d8c1661e7b2..f24eb70e575d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6907,3 +6907,17 @@ available to the guest on migration.
 This capability indicates that KVM can pass unhandled hypercalls to userspace,
 if the VMM enables it. Hypercalls are passed with KVM_EXIT_HYPERCALL in
 kvm_run::hypercall.
+
+8.34 KVM_CAP_ARM_PSCI_TO_USER
+-----------------------------
+
+:Architectures: arm64
+
+When the VMM enables this capability, all PSCI calls are passed to userspace
+instead of being handled by KVM. Capability KVM_CAP_ARM_HVC_TO_USER must be
+enabled first.
+
+Userspace should support at least PSCI v1.0. Otherwise SMCCC features won't be
+available to the guest. Userspace does not need to handle the SMCCC_VERSION
+parameter for the PSCI_FEATURES function. The KVM_ARM_VCPU_PSCI_0_2 vCPU
+feature should be set even if this capability is enabled.
diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/psci.rst
index d52c2e83b5b8..110011d1fa3f 100644
--- a/Documentation/virt/kvm/arm/psci.rst
+++ b/Documentation/virt/kvm/arm/psci.rst
@@ -34,6 +34,7 @@ The following register is defined:
   - Allows any PSCI version implemented by KVM and compatible with
     v0.2 to be set with SET_ONE_REG
   - Affects the whole VM (even if the register view is per-vcpu)
+  - Defaults to PSCI 1.0 if userspace enables KVM_CAP_ARM_PSCI_TO_USER.
 
 * KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
     Holds the state of the firmware support to mitigate CVE-2017-5715, as
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 25554ce97045..5d74b769c16d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -124,6 +124,7 @@ struct kvm_arch {
 	 */
 	bool return_nisv_io_abort_to_user;
 	bool hvc_to_user;
+	bool psci_to_user;
 
 	/*
 	 * VM-wide PMU filter, implemented as a bitmap and big enough for
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 0e2509d27910..b66c6a000ef3 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -6,6 +6,7 @@
 
 #include <asm/kvm_emulate.h>
 
+int kvm_hvc_user(struct kvm_vcpu *vcpu);
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index aa831986a399..2b8e55aa7e1e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1085,6 +1085,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PTP_KVM 198
 #define KVM_CAP_ARM_MP_HALTED 199
 #define KVM_CAP_ARM_HVC_TO_USER 200
+#define KVM_CAP_ARM_PSCI_TO_USER 201
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 074197721e97..bc3e63b0b3ad 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -83,7 +83,7 @@ int kvm_arch_check_processor_compat(void *opaque)
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-	int r;
+	int r = -EINVAL;
 
 	if (cap->flags)
 		return -EINVAL;
@@ -97,8 +97,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		kvm->arch.hvc_to_user = true;
 		break;
-	default:
-		r = -EINVAL;
+	case KVM_CAP_ARM_PSCI_TO_USER:
+		if (kvm->arch.hvc_to_user) {
+			r = 0;
+			kvm->arch.psci_to_user = true;
+		}
 		break;
 	}
 
@@ -213,6 +216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_MP_HALTED:
 	case KVM_CAP_ARM_HVC_TO_USER:
+	case KVM_CAP_ARM_PSCI_TO_USER:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index ccc2015eddf9..621d5a5b7e48 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -58,7 +58,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
-static int kvm_hvc_user(struct kvm_vcpu *vcpu)
+int kvm_hvc_user(struct kvm_vcpu *vcpu)
 {
 	int i;
 	struct kvm_run *run = vcpu->run;
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 42a307ceb95f..7f44ee527966 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -353,6 +353,16 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static bool kvm_psci_call_is_user(struct kvm_vcpu *vcpu)
+{
+	/* Handle the special case of SMCCC probe through PSCI */
+	if (smccc_get_function(vcpu) == PSCI_1_0_FN_PSCI_FEATURES &&
+	    smccc_get_arg1(vcpu) == ARM_SMCCC_VERSION_FUNC_ID)
+		return false;
+
+	return vcpu->kvm->arch.psci_to_user;
+}
+
 /**
  * kvm_psci_call - handle PSCI call if r0 value is in range
  * @vcpu: Pointer to the VCPU struct
@@ -369,6 +379,9 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  */
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
+	if (kvm_psci_call_is_user(vcpu))
+		return kvm_hvc_user(vcpu);
+
 	switch (kvm_psci_version(vcpu, vcpu->kvm)) {
 	case KVM_ARM_PSCI_1_0:
 		return kvm_psci_1_0_call(vcpu);
-- 
2.31.1

