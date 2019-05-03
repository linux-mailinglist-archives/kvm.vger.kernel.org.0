Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26E212E04
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfECMpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:45:39 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60318 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727710AbfECMpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:45:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1ED44165C;
        Fri,  3 May 2019 05:45:39 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB6713F220;
        Fri,  3 May 2019 05:45:35 -0700 (PDT)
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
Subject: [PATCH 16/56] KVM: arm64: Factor out core register ID enumeration
Date:   Fri,  3 May 2019 13:43:47 +0100
Message-Id: <20190503124427.190206-17-marc.zyngier@arm.com>
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

In preparation for adding logic to filter out some KVM_REG_ARM_CORE
registers from the KVM_GET_REG_LIST output, this patch factors out
the core register enumeration into a separate function and rebuilds
num_core_regs() on top of it.

This may be a little more expensive (depending on how good a job
the compiler does of specialising the code), but KVM_GET_REG_LIST
is not a hot path.

This will make it easier to consolidate ID filtering code in one
place.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3e38eb28b03c..a391a61b1033 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -23,6 +23,7 @@
 #include <linux/err.h>
 #include <linux/kvm_host.h>
 #include <linux/module.h>
+#include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
@@ -194,9 +195,28 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
+static int kvm_arm_copy_core_reg_indices(u64 __user *uindices)
+{
+	unsigned int i;
+	int n = 0;
+	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
+
+	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
+		if (uindices) {
+			if (put_user(core_reg | i, uindices))
+				return -EFAULT;
+			uindices++;
+		}
+
+		n++;
+	}
+
+	return n;
+}
+
 static unsigned long num_core_regs(void)
 {
-	return sizeof(struct kvm_regs) / sizeof(__u32);
+	return kvm_arm_copy_core_reg_indices(NULL);
 }
 
 /**
@@ -276,15 +296,12 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
  */
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	unsigned int i;
-	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
 	int ret;
 
-	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		if (put_user(core_reg | i, uindices))
-			return -EFAULT;
-		uindices++;
-	}
+	ret = kvm_arm_copy_core_reg_indices(uindices);
+	if (ret)
+		return ret;
+	uindices += ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)
-- 
2.20.1

