Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4D912E1E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfECMqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:18 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60574 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbfECMqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1FF3165C;
        Fri,  3 May 2019 05:46:17 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B23B3F220;
        Fri,  3 May 2019 05:46:14 -0700 (PDT)
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
Subject: [PATCH 27/56] KVM: arm64/sve: Document KVM API extensions for SVE
Date:   Fri,  3 May 2019 13:43:58 +0100
Message-Id: <20190503124427.190206-28-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

This patch adds sections to the KVM API documentation describing
the extensions for supporting the Scalable Vector Extension (SVE)
in guests.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 132 +++++++++++++++++++++++++++++-
 1 file changed, 129 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index cd920dd1195c..68509dee23e8 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1873,6 +1873,7 @@ Parameters: struct kvm_one_reg (in)
 Returns: 0 on success, negative value on failure
 Errors:
   ENOENT:   no such register
+  EPERM:    register access forbidden for architecture-dependent reasons
   EINVAL:   other errors, such as bad size encoding for a known register
 
 struct kvm_one_reg {
@@ -2127,13 +2128,20 @@ Specifically:
   0x6030 0000 0010 004c SPSR_UND    64  spsr[KVM_SPSR_UND]
   0x6030 0000 0010 004e SPSR_IRQ    64  spsr[KVM_SPSR_IRQ]
   0x6060 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
-  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]
-  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]
+  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]    (*)
+  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]    (*)
     ...
-  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]
+  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]   (*)
   0x6020 0000 0010 00d4 FPSR        32  fp_regs.fpsr
   0x6020 0000 0010 00d5 FPCR        32  fp_regs.fpcr
 
+(*) These encodings are not accepted for SVE-enabled vcpus.  See
+    KVM_ARM_VCPU_INIT.
+
+    The equivalent register content can be accessed via bits [127:0] of
+    the corresponding SVE Zn registers instead for vcpus that have SVE
+    enabled (see below).
+
 arm64 CCSIDR registers are demultiplexed by CSSELR value:
   0x6020 0000 0011 00 <csselr:8>
 
@@ -2143,6 +2151,61 @@ arm64 system registers have the following id bit patterns:
 arm64 firmware pseudo-registers have the following bit pattern:
   0x6030 0000 0014 <regno:16>
 
+arm64 SVE registers have the following bit patterns:
+  0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
+  0x6050 0000 0015 04 <n:4> <slice:5>   Pn bits[256*slice + 255 : 256*slice]
+  0x6050 0000 0015 060 <slice:5>        FFR bits[256*slice + 255 : 256*slice]
+  0x6060 0000 0015 ffff                 KVM_REG_ARM64_SVE_VLS pseudo-register
+
+Access to slices beyond the maximum vector length configured for the
+vcpu (i.e., where 16 * slice >= max_vq (**)) will fail with ENOENT.
+
+These registers are only accessible on vcpus for which SVE is enabled.
+See KVM_ARM_VCPU_INIT for details.
+
+In addition, except for KVM_REG_ARM64_SVE_VLS, these registers are not
+accessible until the vcpu's SVE configuration has been finalized
+using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE).  See KVM_ARM_VCPU_INIT
+and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
+
+KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of vector
+lengths supported by the vcpu to be discovered and configured by
+userspace.  When transferred to or from user memory via KVM_GET_ONE_REG
+or KVM_SET_ONE_REG, the value of this register is of type __u64[8], and
+encodes the set of vector lengths as follows:
+
+__u64 vector_lengths[8];
+
+if (vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX &&
+    ((vector_lengths[(vq - 1) / 64] >> ((vq - 1) % 64)) & 1))
+	/* Vector length vq * 16 bytes supported */
+else
+	/* Vector length vq * 16 bytes not supported */
+
+(**) The maximum value vq for which the above condition is true is
+max_vq.  This is the maximum vector length available to the guest on
+this vcpu, and determines which register slices are visible through
+this ioctl interface.
+
+(See Documentation/arm64/sve.txt for an explanation of the "vq"
+nomenclature.)
+
+KVM_REG_ARM64_SVE_VLS is only accessible after KVM_ARM_VCPU_INIT.
+KVM_ARM_VCPU_INIT initialises it to the best set of vector lengths that
+the host supports.
+
+Userspace may subsequently modify it if desired until the vcpu's SVE
+configuration is finalized using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE).
+
+Apart from simply removing all vector lengths from the host set that
+exceed some value, support for arbitrarily chosen sets of vector lengths
+is hardware-dependent and may not be available.  Attempting to configure
+an invalid set of vector lengths via KVM_SET_ONE_REG will fail with
+EINVAL.
+
+After the vcpu's SVE configuration is finalized, further attempts to
+write this register will fail with EPERM.
+
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -2197,6 +2260,7 @@ Parameters: struct kvm_one_reg (in and out)
 Returns: 0 on success, negative value on failure
 Errors:
   ENOENT:   no such register
+  EPERM:    register access forbidden for architecture-dependent reasons
   EINVAL:   other errors, such as bad size encoding for a known register
 
 This ioctl allows to receive the value of a single register implemented
@@ -2690,6 +2754,33 @@ Possible features:
 	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
 	  Depends on KVM_CAP_ARM_PMU_V3.
 
+	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
+	  Depends on KVM_CAP_ARM_SVE.
+	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
+
+	   * After KVM_ARM_VCPU_INIT:
+
+	      - KVM_REG_ARM64_SVE_VLS may be read using KVM_GET_ONE_REG: the
+	        initial value of this pseudo-register indicates the best set of
+	        vector lengths possible for a vcpu on this host.
+
+	   * Before KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
+
+	      - KVM_RUN and KVM_GET_REG_LIST are not available;
+
+	      - KVM_GET_ONE_REG and KVM_SET_ONE_REG cannot be used to access
+	        the scalable archietctural SVE registers
+	        KVM_REG_ARM64_SVE_ZREG(), KVM_REG_ARM64_SVE_PREG() or
+	        KVM_REG_ARM64_SVE_FFR;
+
+	      - KVM_REG_ARM64_SVE_VLS may optionally be written using
+	        KVM_SET_ONE_REG, to modify the set of vector lengths available
+	        for the vcpu.
+
+	   * After KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
+
+	      - the KVM_REG_ARM64_SVE_VLS pseudo-register is immutable, and can
+	        no longer be written using KVM_SET_ONE_REG.
 
 4.83 KVM_ARM_PREFERRED_TARGET
 
@@ -3904,6 +3995,41 @@ number of valid entries in the 'entries' array, which is then filled.
 'index' and 'flags' fields in 'struct kvm_cpuid_entry2' are currently reserved,
 userspace should not expect to get any particular value there.
 
+4.119 KVM_ARM_VCPU_FINALIZE
+
+Capability: KVM_CAP_ARM_SVE
+Architectures: arm, arm64
+Type: vcpu ioctl
+Parameters: int feature (in)
+Returns: 0 on success, -1 on error
+Errors:
+  EPERM:     feature not enabled, needs configuration, or already finalized
+  EINVAL:    unknown feature
+
+Recognised values for feature:
+  arm64      KVM_ARM_VCPU_SVE
+
+Finalizes the configuration of the specified vcpu feature.
+
+The vcpu must already have been initialised, enabling the affected feature, by
+means of a successful KVM_ARM_VCPU_INIT call with the appropriate flag set in
+features[].
+
+For affected vcpu features, this is a mandatory step that must be performed
+before the vcpu is fully usable.
+
+Between KVM_ARM_VCPU_INIT and KVM_ARM_VCPU_FINALIZE, the feature may be
+configured by use of ioctls such as KVM_SET_ONE_REG.  The exact configuration
+that should be performaned and how to do it are feature-dependent.
+
+Other calls that depend on a particular feature being finalized, such as
+KVM_RUN, KVM_GET_REG_LIST, KVM_GET_ONE_REG and KVM_SET_ONE_REG, will fail with
+-EPERM unless the feature has already been finalized by means of a
+KVM_ARM_VCPU_FINALIZE call.
+
+See KVM_ARM_VCPU_INIT for details of vcpu features that require finalization
+using this ioctl.
+
 5. The kvm_run structure
 ------------------------
 
-- 
2.20.1

