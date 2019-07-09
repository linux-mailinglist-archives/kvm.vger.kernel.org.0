Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C459635B4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGIMZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:54 -0400
Received: from foss.arm.com ([217.140.110.172]:42834 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfGIMZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AA0815AB;
        Tue,  9 Jul 2019 05:25:52 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 940AA3F59C;
        Tue,  9 Jul 2019 05:25:50 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/18] KVM: doc: Add API documentation on the KVM_REG_ARM_WORKAROUNDS register
Date:   Tue,  9 Jul 2019 13:25:05 +0100
Message-Id: <20190709122507.214494-17-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709122507.214494-1-marc.zyngier@arm.com>
References: <20190709122507.214494-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

Add documentation for the newly defined firmware registers to save and
restore any vulnerability mitigation status.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/arm/psci.txt | 31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
index aafdab887b04..559586fc9d37 100644
--- a/Documentation/virtual/kvm/arm/psci.txt
+++ b/Documentation/virtual/kvm/arm/psci.txt
@@ -28,3 +28,34 @@ The following register is defined:
   - Allows any PSCI version implemented by KVM and compatible with
     v0.2 to be set with SET_ONE_REG
   - Affects the whole VM (even if the register view is per-vcpu)
+
+* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+  Holds the state of the firmware support to mitigate CVE-2017-5715, as
+  offered by KVM to the guest via a HVC call. The workaround is described
+  under SMCCC_ARCH_WORKAROUND_1 in [1].
+  Accepted values are:
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: KVM does not offer
+      firmware support for the workaround. The mitigation status for the
+      guest is unknown.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: The workaround HVC call is
+      available to the guest and required for the mitigation.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED: The workaround HVC call
+      is available to the guest, but it is not needed on this VCPU.
+
+* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+  Holds the state of the firmware support to mitigate CVE-2018-3639, as
+  offered by KVM to the guest via a HVC call. The workaround is described
+  under SMCCC_ARCH_WORKAROUND_2 in [1].
+  Accepted values are:
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: A workaround is not
+      available. KVM does not offer firmware support for the workaround.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: The workaround state is
+      unknown. KVM does not offer firmware support for the workaround.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: The workaround is available,
+      and can be disabled by a vCPU. If
+      KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is set, it is active for
+      this vCPU.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED: The workaround is
+      always active on this vCPU or it is not needed.
+
+[1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
-- 
2.20.1

