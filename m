Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA3812E4A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfECMrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:25 -0400
Received: from foss.arm.com ([217.140.101.70]:60978 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbfECMrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3409C374;
        Fri,  3 May 2019 05:47:24 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F08423F220;
        Fri,  3 May 2019 05:47:20 -0700 (PDT)
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
Subject: [PATCH 46/56] KVM: arm64: Add capability to advertise ptrauth for guest
Date:   Fri,  3 May 2019 13:44:17 +0100
Message-Id: <20190503124427.190206-47-marc.zyngier@arm.com>
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

This patch advertises the capability of two cpu feature called address
pointer authentication and generic pointer authentication. These
capabilities depend upon system support for pointer authentication and
VHE mode.

The current arm64 KVM partially implements pointer authentication and
support of address/generic authentication are tied together. However,
separate ABI requirements for both of them is added so that any future
isolated implementation will not require any ABI changes.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 14 ++++++++++----
 arch/arm64/kvm/reset.c            |  5 +++++
 include/uapi/linux/kvm.h          |  2 ++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 32afe7f5c35a..fac1887f25b5 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2763,13 +2763,19 @@ Possible features:
 
 	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
 	  for arm64 only.
-	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
-	  must be requested or neither must be requested.
+	  Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
+	  If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
+	  both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
+	  KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
+	  requested.
 
 	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
 	  for arm64 only.
-	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
-	  must be requested or neither must be requested.
+	  Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
+	  If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
+	  both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
+	  KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
+	  requested.
 
 	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
 	  Depends on KVM_CAP_ARM_SVE.
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 028d0c604652..f0faf54f5857 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -101,6 +101,11 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SVE:
 		r = system_supports_sve();
 		break;
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+		r = has_vhe() && system_supports_address_auth() &&
+				 system_supports_generic_auth();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1d564445b515..4dc34f8e29f6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -989,6 +989,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
 #define KVM_CAP_HYPERV_CPUID 167
 #define KVM_CAP_ARM_SVE 168
+#define KVM_CAP_ARM_PTRAUTH_ADDRESS 169
+#define KVM_CAP_ARM_PTRAUTH_GENERIC 170
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.20.1

