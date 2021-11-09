Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5EC44A4D7
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241508AbhKICmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241574AbhKICmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:06 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861AAC061767
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:21 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x9-20020a056a00188900b0049fd22b9a27so3086710pfh.18
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V23efQreReel1ozFxcUFhqnQ3/YomiRoI5LYnXWRjFY=;
        b=HYJuwjh9Xre4+MctGxwHLrNFFy3cG3Ulns760IlOKUiCA76HVa1D/YIkjdXF7+YaVd
         5MJ0FCXO+JtGKgOdRKNmkvsPGVWo7JQxBqqg2CSAVwXfGBcizbazagrUMEnc6hDgqYnl
         uuIkPUGjDRsXf22bYDVYxvpNLCzt/6QFkpm+gSxNAQiIP9A13R7XY+SOAaWbN88iK7Us
         ALwJ3zCClW4iLiML+y/9+nZAeLtWxx/zWbhnnrljA2GZPRU59/E20ZwCKOjRH7Pkg+si
         5BRRm+VHesV4E5YDVp2vUljUMrhMCvQGNyTH3BFGpHPxVQCFIQbFsT8N3tuYD/dgWohQ
         Xl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V23efQreReel1ozFxcUFhqnQ3/YomiRoI5LYnXWRjFY=;
        b=JHhphV/+SHfO3ZOZoiYUZE+kq016dIxCK5a3pfaoOgaYur2p3DFMU+jG3h48pUJT1o
         6d2bsLaMdMJ2k7Gfb7dXl4gg3Hxrm0Nc81RYRA41IcPjszQyRauljvGUXm9/gEtetgn3
         xKRe6AX494WaZfA74KXET2WcSAbyuFI0YuQYoWEtrUIM3Y5iY1/bV0RFvCRpHEWRUwzS
         o1VsBXbhSJE6b1HQSYkBIsAqbd3j+XPRrPgNpJQrX98jMYdHlfsKlWh/bQCZVzSwVXfF
         OOZvreBOLBKdcfO70xGFePXYB4MvpFfdVjTfj1KJE4K0Geoqe+MYQ/syKEKgk1EUuP4c
         1gYw==
X-Gm-Message-State: AOAM532zpZdaPwwNosOzLHT966plN7aDWTP7iFCA9JuVP7Lrr4FgiY3Q
        y2x8rr316Z7YtqOdJaA9VmdMRFaSTZgiKmRUXTvMOq85hvloqDdI8Rwjcz12xmOpEN7uof9Oav7
        M+YeKUsOgqkudul6hi4/hmzBkJbdzZA4l9K0rv1ngfXPqYxAL47WK0HbpznwXh/I=
X-Google-Smtp-Source: ABdhPJwCFndNR00w3y5o+Z3mzR0MnzC15TZzdbkvYri6oPSzB1KiV8KnaSY6nZpga7EMDygy9OHbOX7MNsnyug==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e74a:b0:142:114c:1f1e with SMTP
 id p10-20020a170902e74a00b00142114c1f1emr4013166plf.78.1636425560906; Mon, 08
 Nov 2021 18:39:20 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:54 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 05/17] KVM: selftests: aarch64: add vGIC library functions to
 deal with vIRQ state
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a set of library functions for userspace code in selftests to deal
with vIRQ state (i.e., ioctl wrappers).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/gic.h       | 10 ++
 .../selftests/kvm/include/aarch64/vgic.h      | 14 ++-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 93 +++++++++++++++++++
 3 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index c932cf3d0771..b217ea17cac5 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -11,6 +11,16 @@ enum gic_type {
 	GIC_TYPE_MAX,
 };
 
+#define MIN_SGI			0
+#define MIN_PPI			16
+#define MIN_SPI			32
+#define MAX_SPI			1019
+#define IAR_SPURIOUS		1023
+
+#define INTID_IS_SGI(intid)	(0       <= (intid) && (intid) < MIN_PPI)
+#define INTID_IS_PPI(intid)	(MIN_PPI <= (intid) && (intid) < MIN_SPI)
+#define INTID_IS_SPI(intid)	(MIN_SPI <= (intid) && (intid) <= MAX_SPI)
+
 void gic_init(enum gic_type type, unsigned int nr_cpus,
 		void *dist_base, void *redist_base);
 void gic_irq_enable(unsigned int intid);
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index 0ecfb253893c..ec8744bb2d4b 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -17,4 +17,16 @@
 int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
 
-#endif /* SELFTEST_KVM_VGIC_H */
+#define VGIC_MAX_RESERVED	1023
+
+void kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level);
+int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level);
+
+void kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level);
+int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level);
+
+/* The vcpu arg only applies to private interrupts. */
+void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, uint32_t vcpu);
+void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, uint32_t vcpu);
+
+#endif // SELFTEST_KVM_VGIC_H
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index b9b271ff520d..a1f1f6c8e2e0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -5,11 +5,14 @@
 
 #include <linux/kvm.h>
 #include <linux/sizes.h>
+#include <asm/kvm_para.h>
 #include <asm/kvm.h>
 
 #include "kvm_util.h"
 #include "../kvm_util_internal.h"
 #include "vgic.h"
+#include "gic.h"
+#include "gic_v3.h"
 
 /*
  * vGIC-v3 default host setup
@@ -68,3 +71,93 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
 
 	return gic_fd;
 }
+
+/* should only work for level sensitive interrupts */
+int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
+{
+	uint64_t attr = 32 * (intid / 32);
+	uint64_t index = intid % 32;
+	uint64_t val;
+	int ret;
+
+	ret = _kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO,
+				 attr, &val, false);
+	if (ret != 0)
+		return ret;
+
+	val |= 1U << index;
+	ret = _kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO,
+				 attr, &val, true);
+	return ret;
+}
+
+void kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
+{
+	int ret = _kvm_irq_set_level_info(gic_fd, intid, level);
+
+	TEST_ASSERT(ret == 0, "KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO failed, "
+			"rc: %i errno: %i", ret, errno);
+}
+
+int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
+{
+	uint32_t irq = intid & KVM_ARM_IRQ_NUM_MASK;
+
+	if (INTID_IS_PPI(intid))
+		irq |= KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
+	else if (INTID_IS_SPI(intid))
+		irq |= KVM_ARM_IRQ_TYPE_SPI << KVM_ARM_IRQ_TYPE_SHIFT;
+	else
+		TEST_FAIL("KVM_IRQ_LINE can't be used with SGIs.");
+
+	return _kvm_irq_line(vm, irq, level);
+}
+
+void kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
+{
+	int ret = _kvm_arm_irq_line(vm, intid, level);
+
+	TEST_ASSERT(ret == 0, "KVM_IRQ_LINE failed, rc: %i errno: %i",
+			ret, errno);
+}
+
+static void vgic_poke_irq(int gic_fd, uint32_t intid,
+		uint32_t vcpu, uint64_t reg_off)
+{
+	uint64_t reg = intid / 32;
+	uint64_t index = intid % 32;
+	uint64_t attr = reg_off + reg * 4;
+	uint64_t val;
+	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
+
+	/* Check that the addr part of the attr is within 32 bits. */
+	assert(attr <= KVM_DEV_ARM_VGIC_OFFSET_MASK);
+
+	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
+					  : KVM_DEV_ARM_VGIC_GRP_DIST_REGS;
+
+	if (intid_is_private) {
+		/* TODO: only vcpu 0 implemented for now. */
+		assert(vcpu == 0);
+		attr += SZ_64K;
+	}
+
+	/* All calls will succeed, even with invalid intid's, as long as the
+	 * addr part of the attr is within 32 bits (checked above). An invalid
+	 * intid will just make the read/writes point to above the intended
+	 * register space (i.e., ICPENDR after ISPENDR).
+	 */
+	kvm_device_access(gic_fd, group, attr, &val, false);
+	val |= 1ULL << index;
+	kvm_device_access(gic_fd, group, attr, &val, true);
+}
+
+void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, uint32_t vcpu)
+{
+	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISPENDR);
+}
+
+void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, uint32_t vcpu)
+{
+	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISACTIVER);
+}
-- 
2.34.0.rc0.344.g81b53c2807-goog

