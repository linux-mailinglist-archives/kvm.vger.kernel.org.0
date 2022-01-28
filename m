Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743D049F917
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348410AbiA1MTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:19:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348389AbiA1MT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:19:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E8C6B8256B
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CA6C340EB;
        Fri, 28 Jan 2022 12:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372366;
        bh=Jzt0hao+pMofidNUzSsvsIVFNGWinmEimzZT+rVNAWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjANOZHkcwXF+V/MdKe7TFgnxpxzFZemak7X6C2CvoIvuxYZpeY3Pk7Mj23CnEsdq
         +k3bZ8eLvsSP8Iyy7ysq3rKx5NaM6VKm4CeBm5r6IEGM1DpFjRgYBmySbktvuaa0tg
         1JvlGrgi6caz9TmC59Z5mi4HyxZ3U3SHMMbOamD9fIUxszX3eMSotb8VtPfLgmLZX+
         ojKj8j7KmF82wJ6+c6jBfwoAz8ZSjQcQKxq6KcFYIFDQqDMtfQ0uPTbg86/9F4BP/X
         679byK+ukp0HzGk1FmNC2hePvvVf5BT3YGiS6hQxBzTHqe6Ki5IgPUGsDZfs6fiIDK
         DQmqWFmir+IGQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDs-003njR-H8; Fri, 28 Jan 2022 12:19:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 02/64] KVM: arm64: nv: Introduce nested virtualization VCPU feature
Date:   Fri, 28 Jan 2022 12:18:10 +0000
Message-Id: <20220128121912.509006-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

Introduce the feature bit and a primitive that checks if the feature is
set behind a static key check based on the cpus_have_const_cap check.

Checking vcpu_has_nv() on systems without nested virt enabled
should have negligible overhead.

We don't yet allow userspace to actually set this feature.

Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 14 ++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h   |  1 +
 2 files changed, 15 insertions(+)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
new file mode 100644
index 000000000000..fd601ea68d13
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM64_KVM_NESTED_H
+#define __ARM64_KVM_NESTED_H
+
+#include <linux/kvm_host.h>
+
+static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
+{
+	return (!__is_defined(__KVM_NVHE_HYPERVISOR__) &&
+		cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
+		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
+}
+
+#endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..395a4c039bcc 100644
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
2.30.2

