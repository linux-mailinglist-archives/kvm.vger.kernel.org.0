Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D3612E2C
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfECMqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:39 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60698 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbfECMqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4FA6374;
        Fri,  3 May 2019 05:46:38 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CB823F220;
        Fri,  3 May 2019 05:46:35 -0700 (PDT)
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
Subject: [PATCH 33/56] KVM: arm64/sve: Clean up UAPI register ID definitions
Date:   Fri,  3 May 2019 13:44:04 +0100
Message-Id: <20190503124427.190206-34-marc.zyngier@arm.com>
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

Currently, the SVE register ID macros are not all defined in the
same way, and advertise the fact that FFR maps onto the nonexistent
predicate register P16.  This is really just for kernel
convenience, and may lead userspace into bad habits.

Instead, this patch masks the ID macro arguments so that
architecturally invalid register numbers will not be passed through
any more, and uses a literal KVM_REG_ARM64_SVE_FFR_BASE macro to
define KVM_REG_ARM64_SVE_FFR(), similarly to the way the _ZREG()
and _PREG() macros are defined.

Rather than plugging in magic numbers for the number of Z- and P-
registers and the maximum possible number of register slices, this
patch provides definitions for those too.  Userspace is going to
need them in any case, and it makes sense for them to come from
<uapi/asm/kvm.h>.

sve_reg_to_region() uses convenience constants that are defined in
a different way, and also makes use of the fact that the FFR IDs
are really contiguous with the P15 IDs, so this patch retains the
existing convenience constants in guest.c, supplemented with a
couple of sanity checks to check for consistency with the UAPI
header.

Fixes: e1c9c98345b3 ("KVM: arm64/sve: Add SVE support to register access ioctl interface")
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 32 ++++++++++++++++++++++---------
 arch/arm64/kvm/guest.c            |  9 +++++++++
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 6963b7e8062b..2a04ef015469 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -35,6 +35,7 @@
 #include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/ptrace.h>
+#include <asm/sve_context.h>
 
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
@@ -233,16 +234,29 @@ struct kvm_vcpu_events {
 /* Z- and P-regs occupy blocks at the following offsets within this range: */
 #define KVM_REG_ARM64_SVE_ZREG_BASE	0
 #define KVM_REG_ARM64_SVE_PREG_BASE	0x400
+#define KVM_REG_ARM64_SVE_FFR_BASE	0x600
 
-#define KVM_REG_ARM64_SVE_ZREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
-					 KVM_REG_ARM64_SVE_ZREG_BASE |	\
-					 KVM_REG_SIZE_U2048 |		\
-					 ((n) << 5) | (i))
-#define KVM_REG_ARM64_SVE_PREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
-					 KVM_REG_ARM64_SVE_PREG_BASE |	\
-					 KVM_REG_SIZE_U256 |		\
-					 ((n) << 5) | (i))
-#define KVM_REG_ARM64_SVE_FFR(i)	KVM_REG_ARM64_SVE_PREG(16, i)
+#define KVM_ARM64_SVE_NUM_ZREGS		__SVE_NUM_ZREGS
+#define KVM_ARM64_SVE_NUM_PREGS		__SVE_NUM_PREGS
+
+#define KVM_ARM64_SVE_MAX_SLICES	32
+
+#define KVM_REG_ARM64_SVE_ZREG(n, i)					\
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | KVM_REG_ARM64_SVE_ZREG_BASE | \
+	 KVM_REG_SIZE_U2048 |						\
+	 (((n) & (KVM_ARM64_SVE_NUM_ZREGS - 1)) << 5) |			\
+	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
+
+#define KVM_REG_ARM64_SVE_PREG(n, i)					\
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | KVM_REG_ARM64_SVE_PREG_BASE | \
+	 KVM_REG_SIZE_U256 |						\
+	 (((n) & (KVM_ARM64_SVE_NUM_PREGS - 1)) << 5) |			\
+	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
+
+#define KVM_REG_ARM64_SVE_FFR(i)					\
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | KVM_REG_ARM64_SVE_FFR_BASE | \
+	 KVM_REG_SIZE_U256 |						\
+	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
 
 /* Vector lengths pseudo-register: */
 #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 4f7b26bbf671..2e449e1dea73 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -325,6 +325,15 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 
 	size_t sve_state_size;
 
+	const u64 last_preg_id = KVM_REG_ARM64_SVE_PREG(SVE_NUM_PREGS - 1,
+							SVE_NUM_SLICES - 1);
+
+	/* Verify that the P-regs and FFR really do have contiguous IDs: */
+	BUILD_BUG_ON(KVM_REG_ARM64_SVE_FFR(0) != last_preg_id + 1);
+
+	/* Verify that we match the UAPI header: */
+	BUILD_BUG_ON(SVE_NUM_SLICES != KVM_ARM64_SVE_MAX_SLICES);
+
 	/* Only the first slice ever exists, for now: */
 	if ((reg->id & SVE_REG_SLICE_MASK) != 0)
 		return -ENOENT;
-- 
2.20.1

