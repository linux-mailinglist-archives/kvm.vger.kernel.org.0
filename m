Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48706C8BDD
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 16:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfJBOuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 10:50:55 -0400
Received: from foss.arm.com ([217.140.110.172]:46200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbfJBOuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 10:50:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DC1F1597;
        Wed,  2 Oct 2019 07:50:54 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37F153F706;
        Wed,  2 Oct 2019 07:50:52 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 01/10] KVM: arm64: Document PV-time interface
Date:   Wed,  2 Oct 2019 15:50:28 +0100
Message-Id: <20191002145037.51630-2-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002145037.51630-1-steven.price@arm.com>
References: <20191002145037.51630-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a paravirtualization interface for KVM/arm64 based on the
"Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.

This only adds the details about "Stolen Time" as the details of "Live
Physical Time" have not been fully agreed.

User space can specify a reserved area of memory for the guest and
inform KVM to populate the memory with information on time that the host
kernel has stolen from the guest.

A hypercall interface is provided for the guest to interrogate the
hypervisor's support for this interface and the location of the shared
memory structures.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 Documentation/virt/kvm/arm/pvtime.txt   | 65 +++++++++++++++++++++++++
 Documentation/virt/kvm/devices/vcpu.txt | 14 ++++++
 2 files changed, 79 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/pvtime.txt

diff --git a/Documentation/virt/kvm/arm/pvtime.txt b/Documentation/virt/kvm/arm/pvtime.txt
new file mode 100644
index 000000000000..fa15c12eec91
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pvtime.txt
@@ -0,0 +1,65 @@
+Paravirtualized time support for arm64
+======================================
+
+Arm specification DEN0057/A defined a standard for paravirtualised time
+support for AArch64 guests:
+
+https://developer.arm.com/docs/den0057/a
+
+KVM/arm64 implements the stolen time part of this specification by providing
+some hypervisor service calls to support a paravirtualized guest obtaining a
+view of the amount of time stolen from its execution.
+
+Two new SMCCC compatible hypercalls are defined:
+
+PV_FEATURES 0xC5000020
+PV_TIME_ST  0xC5000022
+
+These are only available in the SMC64/HVC64 calling convention as
+paravirtualized time is not available to 32 bit Arm guests. The existence of
+the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
+mechanism before calling it.
+
+PV_FEATURES
+    Function ID:  (uint32)  : 0xC5000020
+    PV_func_id:   (uint32)  : The function to query for support.
+                              Currently only PV_TIME_ST is supported.
+    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
+                              PV-time feature is supported by the hypervisor.
+
+PV_TIME_ST
+    Function ID:  (uint32)  : 0xC5000022
+    Return value: (int64)   : IPA of the stolen time data structure for this
+                              VCPU. On failure:
+                              NOT_SUPPORTED (-1)
+
+The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
+with inner and outer write back caching attributes, in the inner shareable
+domain. A total of 16 bytes from the IPA returned are guaranteed to be
+meaningfully filled by the hypervisor (see structure below).
+
+PV_TIME_ST returns the structure for the calling VCPU.
+
+Stolen Time
+-----------
+
+The structure pointed to by the PV_TIME_ST hypercall is as follows:
+
+  Field       | Byte Length | Byte Offset | Description
+  ----------- | ----------- | ----------- | --------------------------
+  Revision    |      4      |      0      | Must be 0 for version 0.1
+  Attributes  |      4      |      4      | Must be 0
+  Stolen time |      8      |      8      | Stolen time in unsigned
+              |             |             | nanoseconds indicating how
+              |             |             | much time this VCPU thread
+              |             |             | was involuntarily not
+              |             |             | running on a physical CPU.
+
+The structure will be updated by the hypervisor prior to scheduling a VCPU. It
+will be present within a reserved region of the normal memory given to the
+guest. The guest should not attempt to write into this memory. There is a
+structure per VCPU of the guest.
+
+For the user space interface see Documentation/virt/kvm/devices/vcpu.txt
+section "3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL".
+
diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
index 2b5dab16c4f2..6f3bd64a05b0 100644
--- a/Documentation/virt/kvm/devices/vcpu.txt
+++ b/Documentation/virt/kvm/devices/vcpu.txt
@@ -60,3 +60,17 @@ time to use the number provided for a given timer, overwriting any previously
 configured values on other VCPUs.  Userspace should configure the interrupt
 numbers on at least one VCPU after creating all VCPUs and before running any
 VCPUs.
+
+3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
+Architectures: ARM64
+
+3.1 ATTRIBUTE: KVM_ARM_VCPU_PVTIME_IPA
+Parameters: 64-bit base address
+Returns: -ENXIO:  Stolen time not implemented
+         -EEXIST: Base address already set for this VCPU
+         -EINVAL: Base address not 64 byte aligned
+
+Specifies the base address of the stolen time structure for this VCPU. The
+base address must be 64 byte aligned and exist within a valid guest memory
+region. See Documentation/virt/kvm/arm/pvtime.txt for more information
+including the layout of the stolen time structure.
-- 
2.20.1

