Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142AE12E0E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfECMpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:45:53 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60408 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbfECMpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:45:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 229B8374;
        Fri,  3 May 2019 05:45:53 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF6DD3F220;
        Fri,  3 May 2019 05:45:49 -0700 (PDT)
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
Subject: [PATCH 20/56] arm64/sve: In-kernel vector length availability query interface
Date:   Fri,  3 May 2019 13:43:51 +0100
Message-Id: <20190503124427.190206-21-marc.zyngier@arm.com>
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

KVM will need to interrogate the set of SVE vector lengths
available on the system.

This patch exposes the relevant bits to the kernel, along with a
sve_vq_available() helper to check whether a particular vector
length is supported.

__vq_to_bit() and __bit_to_vq() are not intended for use outside
these functions: now that these are exposed outside fpsimd.c, they
are prefixed with __ in order to provide an extra hint that they
are not intended for general-purpose use.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/fpsimd.h | 29 +++++++++++++++++++++++++++
 arch/arm64/kernel/fpsimd.c      | 35 ++++++++-------------------------
 2 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index df7a14305222..ad6d2e41eb37 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -24,10 +24,13 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/bitmap.h>
 #include <linux/build_bug.h>
+#include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/stddef.h>
+#include <linux/types.h>
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /* Masks for extracting the FPSR and FPCR from the FPSCR */
@@ -89,6 +92,32 @@ extern u64 read_zcr_features(void);
 
 extern int __ro_after_init sve_max_vl;
 extern int __ro_after_init sve_max_virtualisable_vl;
+/* Set of available vector lengths, as vq_to_bit(vq): */
+extern __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
+
+/*
+ * Helpers to translate bit indices in sve_vq_map to VQ values (and
+ * vice versa).  This allows find_next_bit() to be used to find the
+ * _maximum_ VQ not exceeding a certain value.
+ */
+static inline unsigned int __vq_to_bit(unsigned int vq)
+{
+	return SVE_VQ_MAX - vq;
+}
+
+static inline unsigned int __bit_to_vq(unsigned int bit)
+{
+	if (WARN_ON(bit >= SVE_VQ_MAX))
+		bit = SVE_VQ_MAX - 1;
+
+	return SVE_VQ_MAX - bit;
+}
+
+/* Ensure vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX before calling this function */
+static inline bool sve_vq_available(unsigned int vq)
+{
+	return test_bit(__vq_to_bit(vq), sve_vq_map);
+}
 
 #ifdef CONFIG_ARM64_SVE
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 8a93afa78600..577296bba730 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -136,7 +136,7 @@ static int sve_default_vl = -1;
 int __ro_after_init sve_max_vl = SVE_VL_MIN;
 int __ro_after_init sve_max_virtualisable_vl = SVE_VL_MIN;
 /* Set of available vector lengths, as vq_to_bit(vq): */
-static __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
+__ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 /* Set of vector lengths present on at least one cpu: */
 static __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
 static void __percpu *efi_sve_state;
@@ -269,25 +269,6 @@ void fpsimd_save(void)
 	}
 }
 
-/*
- * Helpers to translate bit indices in sve_vq_map to VQ values (and
- * vice versa).  This allows find_next_bit() to be used to find the
- * _maximum_ VQ not exceeding a certain value.
- */
-
-static unsigned int vq_to_bit(unsigned int vq)
-{
-	return SVE_VQ_MAX - vq;
-}
-
-static unsigned int bit_to_vq(unsigned int bit)
-{
-	if (WARN_ON(bit >= SVE_VQ_MAX))
-		bit = SVE_VQ_MAX - 1;
-
-	return SVE_VQ_MAX - bit;
-}
-
 /*
  * All vector length selection from userspace comes through here.
  * We're on a slow path, so some sanity-checks are included.
@@ -309,8 +290,8 @@ static unsigned int find_supported_vector_length(unsigned int vl)
 		vl = max_vl;
 
 	bit = find_next_bit(sve_vq_map, SVE_VQ_MAX,
-			    vq_to_bit(sve_vq_from_vl(vl)));
-	return sve_vl_from_vq(bit_to_vq(bit));
+			    __vq_to_bit(sve_vq_from_vl(vl)));
+	return sve_vl_from_vq(__bit_to_vq(bit));
 }
 
 #ifdef CONFIG_SYSCTL
@@ -648,7 +629,7 @@ static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
 		write_sysreg_s(zcr | (vq - 1), SYS_ZCR_EL1); /* self-syncing */
 		vl = sve_get_vl();
 		vq = sve_vq_from_vl(vl); /* skip intervening lengths */
-		set_bit(vq_to_bit(vq), map);
+		set_bit(__vq_to_bit(vq), map);
 	}
 }
 
@@ -717,7 +698,7 @@ int sve_verify_vq_map(void)
 	 * Mismatches above sve_max_virtualisable_vl are fine, since
 	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
 	 */
-	if (sve_vl_from_vq(bit_to_vq(b)) <= sve_max_virtualisable_vl) {
+	if (sve_vl_from_vq(__bit_to_vq(b)) <= sve_max_virtualisable_vl) {
 		pr_warn("SVE: cpu%d: Unsupported vector length(s) present\n",
 			smp_processor_id());
 		return -EINVAL;
@@ -801,8 +782,8 @@ void __init sve_setup(void)
 	 * so sve_vq_map must have at least SVE_VQ_MIN set.
 	 * If something went wrong, at least try to patch it up:
 	 */
-	if (WARN_ON(!test_bit(vq_to_bit(SVE_VQ_MIN), sve_vq_map)))
-		set_bit(vq_to_bit(SVE_VQ_MIN), sve_vq_map);
+	if (WARN_ON(!test_bit(__vq_to_bit(SVE_VQ_MIN), sve_vq_map)))
+		set_bit(__vq_to_bit(SVE_VQ_MIN), sve_vq_map);
 
 	zcr = read_sanitised_ftr_reg(SYS_ZCR_EL1);
 	sve_max_vl = sve_vl_from_vq((zcr & ZCR_ELx_LEN_MASK) + 1);
@@ -831,7 +812,7 @@ void __init sve_setup(void)
 		/* No virtualisable VLs?  This is architecturally forbidden. */
 		sve_max_virtualisable_vl = SVE_VQ_MIN;
 	else /* b + 1 < SVE_VQ_MAX */
-		sve_max_virtualisable_vl = sve_vl_from_vq(bit_to_vq(b + 1));
+		sve_max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b + 1));
 
 	if (sve_max_virtualisable_vl > sve_max_vl)
 		sve_max_virtualisable_vl = sve_max_vl;
-- 
2.20.1

