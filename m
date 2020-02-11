Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73BC8159693
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgBKRt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbgBKRt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:49:57 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EA22206D7;
        Tue, 11 Feb 2020 17:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443397;
        bh=Q45nUi+j7GZ+5bZdrZa7v6bmgIUXdcImPx3jSm4b5vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfg5GWl4io9VLVhsodj2YrfEPfxCT8wxzicuO2HOuuR2HtyajJsr6Uy+4JQbEh9m4
         eXKqTRDVxGF2V58s9HzxO+UwIlOSGkcj3cG1E9n7v8Px9aHC6xhGLy+4E0Rb9+Jjcw
         k3HvM6YOQWR84p+7vpV9Z0cxWcCqmzGOCL5N6z+s=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZfX-004O7k-Ip; Tue, 11 Feb 2020 17:49:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 03/94] KVM: arm64: nv: Introduce nested virtualization VCPU feature
Date:   Tue, 11 Feb 2020 17:48:07 +0000
Message-Id: <20200211174938.27809-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

Introduce the feature bit and a primitive that checks if the feature is
set behind a static key check based on the cpus_have_const_cap check.

Checking nested_virt_in_use() on systems without nested virt enabled
should have neglgible overhead.

We don't yet allow userspace to actually set this feature.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_nested.h   |  9 +++++++++
 arch/arm64/include/asm/kvm_nested.h | 13 +++++++++++++
 arch/arm64/include/uapi/asm/kvm.h   |  1 +
 3 files changed, 23 insertions(+)
 create mode 100644 arch/arm/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/include/asm/kvm_nested.h

diff --git a/arch/arm/include/asm/kvm_nested.h b/arch/arm/include/asm/kvm_nested.h
new file mode 100644
index 000000000000..124ff6445f8f
--- /dev/null
+++ b/arch/arm/include/asm/kvm_nested.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM_KVM_NESTED_H
+#define __ARM_KVM_NESTED_H
+
+#include <linux/kvm_host.h>
+
+static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu) { return false; }
+
+#endif /* __ARM_KVM_NESTED_H */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
new file mode 100644
index 000000000000..f243a8acb9fc
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM64_KVM_NESTED_H
+#define __ARM64_KVM_NESTED_H
+
+#include <linux/kvm_host.h>
+
+static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
+{
+	return cpus_have_const_cap(ARM64_HAS_NESTED_VIRT) &&
+		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features);
+}
+
+#endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ba85bb23f060..5b9c58a55537 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 
 struct kvm_vcpu_init {
 	__u32 target;
-- 
2.20.1

