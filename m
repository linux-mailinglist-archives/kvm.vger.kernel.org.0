Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DEB104115
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 17:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732868AbfKTQnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 11:43:08 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:40297 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729866AbfKTQnH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 11:43:07 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iXT4C-0007RI-58; Wed, 20 Nov 2019 17:42:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Julien Grall <julien.grall@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Price <steven.price@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 03/22] KVM: arm64: Document PV-time interface
Date:   Wed, 20 Nov 2019 16:42:17 +0000
Message-Id: <20191120164236.29359-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120164236.29359-1-maz@kernel.org>
References: <20191120164236.29359-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com, drjones@redhat.com, borntraeger@de.ibm.com, christoffer.dall@arm.com, eric.auger@redhat.com, xypron.glpk@gmx.de, julien.grall@arm.com, mark.rutland@arm.com, bigeasy@linutronix.de, steven.price@arm.com, tglx@linutronix.de, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steven Price <steven.price@arm.com>

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
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/arm/pvtime.rst   | 80 +++++++++++++++++++++++++
 Documentation/virt/kvm/devices/vcpu.txt | 14 +++++
 2 files changed, 94 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/pvtime.rst

diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
new file mode 100644
index 000000000000..2357dd2d8655
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pvtime.rst
@@ -0,0 +1,80 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Paravirtualized time support for arm64
+======================================
+
+Arm specification DEN0057/A defines a standard for paravirtualised time
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
+* PV_TIME_FEATURES: 0xC5000020
+* PV_TIME_ST:       0xC5000021
+
+These are only available in the SMC64/HVC64 calling convention as
+paravirtualized time is not available to 32 bit Arm guests. The existence of
+the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
+mechanism before calling it.
+
+PV_TIME_FEATURES
+    ============= ========    ==========
+    Function ID:  (uint32)    0xC5000020
+    PV_call_id:   (uint32)    The function to query for support.
+                              Currently only PV_TIME_ST is supported.
+    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
+                              PV-time feature is supported by the hypervisor.
+    ============= ========    ==========
+
+PV_TIME_ST
+    ============= ========    ==========
+    Function ID:  (uint32)    0xC5000021
+    Return value: (int64)     IPA of the stolen time data structure for this
+                              VCPU. On failure:
+                              NOT_SUPPORTED (-1)
+    ============= ========    ==========
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
++-------------+-------------+-------------+----------------------------+
+| Field       | Byte Length | Byte Offset | Description                |
++=============+=============+=============+============================+
+| Revision    |      4      |      0      | Must be 0 for version 1.0  |
++-------------+-------------+-------------+----------------------------+
+| Attributes  |      4      |      4      | Must be 0                  |
++-------------+-------------+-------------+----------------------------+
+| Stolen time |      8      |      8      | Stolen time in unsigned    |
+|             |             |             | nanoseconds indicating how |
+|             |             |             | much time this VCPU thread |
+|             |             |             | was involuntarily not      |
+|             |             |             | running on a physical CPU. |
++-------------+-------------+-------------+----------------------------+
+
+All values in the structure are stored little-endian.
+
+The structure will be updated by the hypervisor prior to scheduling a VCPU. It
+will be present within a reserved region of the normal memory given to the
+guest. The guest should not attempt to write into this memory. There is a
+structure per VCPU of the guest.
+
+It is advisable that one or more 64k pages are set aside for the purpose of
+these structures and not used for other purposes, this enables the guest to map
+the region using 64k pages and avoids conflicting attributes with other memory.
+
+For the user space interface see Documentation/virt/kvm/devices/vcpu.txt
+section "3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL".
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

