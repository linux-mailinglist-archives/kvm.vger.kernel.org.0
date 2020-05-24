Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C858E1DFE8A
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgEXLSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgEXLSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:18:30 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DF0C061A0E;
        Sun, 24 May 2020 04:18:29 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n15so7577628pfd.0;
        Sun, 24 May 2020 04:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ubQHTLC5l6r2IE2JDMviN3M/YX3uMBOUaUjayM8ym0Q=;
        b=YeUnWP9v36yAC2DERhgE74NYTj1PjNQnjdJ5ZPpD2eAE5kXN/kAqukA4NZtLKO2hlx
         WmV21cZt/24lSk3eZy3PpqXbDkTAwakDYNAg+0ygkym7FWx3p0+esTuwAnJw9/7eVOrZ
         V6mZrL8Gh6MXf3f5/J3X+ahdGkyPsVGfttawzHXl1rdiGcRWjl7NIw/xiDWeJQmZtAlq
         tfSrzPUgZ2P6wHw2rQ2VqfHiD4WVijHTBMZwXIDiV2NHim0zYL9I9x2O4POSpUbny+4l
         hrA2Jyczmk3PfsM1gRbRfrPzYTnszH3qMLZ8ZOnKR1SbXAzOrIdVA009ihHWcizF2BTY
         ojIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ubQHTLC5l6r2IE2JDMviN3M/YX3uMBOUaUjayM8ym0Q=;
        b=cf3tPmJXHzTMT5ziFquxFQe3UYPKG1StEwXaBBOV883onvnqqg4YjTjQnc+y9qFB25
         VkHiM3bv1MTsv3stfuiWjA0yMtdqu3DxfFtVMsyhtyYgvChEo46lWNe7iawtWUpOe8ps
         I+6JEmDEVPpN+eTtCZxgH6MMYvjVGZgjJQiWF+AAgXMYoM9Bepnf2o2e89WMd0sAXRY3
         5IQ+11Vm+WwaCB6CdU898neM8jDFZPjS7inl1aI0GS7z32tu4Gqr/+wIlfp5h+RDev2+
         ogU6FqkZciqsD530XdZlKMIl4TiVK9VpzOcfbyex1P/ghlTVT7TD0+e5sVZdxxmBLmOx
         +JfA==
X-Gm-Message-State: AOAM531TLyB+95yEuGznwlABEFGDBuikbuFbRAY+pxK3iXYa4qUcsxm/
        LmrQdQcbbvR80hUdHWzzvV59E1TVmJxcsw==
X-Google-Smtp-Source: ABdhPJyL6Mw2R6ZynvCiLbTU9+DFlTS8Xx6AhOlOZVBprRT7UHh67Z67Fq0XFnCOjBN4mELS0FpQDA==
X-Received: by 2002:a63:5644:: with SMTP id g4mr3116775pgm.381.1590319109015;
        Sun, 24 May 2020 04:18:29 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.18.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:18:28 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 06/15] KVM: MIPS: Introduce and use cpu_guest_has_ldpte
Date:   Sun, 24 May 2020 19:13:30 +0800
Message-Id: <1590318819-24520-7-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 has lddir/ldpte instructions and their related CP0 registers
are the same as HTW. So we introduce a cpu_guest_has_ldpte flag and use
it to indicate whether we need to save/restore HTW related CP0 registers
(PWBase, PWSize, PWField and PWCtl).

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/cpu-features.h |  3 +++
 arch/mips/kernel/cpu-probe.c         |  1 +
 arch/mips/kvm/vz.c                   | 26 +++++++++++++-------------
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index de44c92..c576aad 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -665,6 +665,9 @@
 #ifndef cpu_guest_has_htw
 #define cpu_guest_has_htw	(cpu_data[0].guest.options & MIPS_CPU_HTW)
 #endif
+#ifndef cpu_guest_has_ldpte
+#define cpu_guest_has_ldpte	(cpu_data[0].guest.options & MIPS_CPU_LDPTE)
+#endif
 #ifndef cpu_guest_has_mvh
 #define cpu_guest_has_mvh	(cpu_data[0].guest.options & MIPS_CPU_MVH)
 #endif
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index f21a230..5bf0821 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1966,6 +1966,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		set_isa(c, MIPS_CPU_ISA_M64R2);
 		decode_configs(c);
 		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
+		c->guest.options |= MIPS_CPU_LDPTE;
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
 			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 17932ab..422cd06 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -1706,7 +1706,7 @@ static unsigned long kvm_vz_num_regs(struct kvm_vcpu *vcpu)
 		ret += ARRAY_SIZE(kvm_vz_get_one_regs_contextconfig);
 	if (cpu_guest_has_segments)
 		ret += ARRAY_SIZE(kvm_vz_get_one_regs_segments);
-	if (cpu_guest_has_htw)
+	if (cpu_guest_has_htw || cpu_guest_has_ldpte)
 		ret += ARRAY_SIZE(kvm_vz_get_one_regs_htw);
 	if (cpu_guest_has_maar && !cpu_guest_has_dyn_maar)
 		ret += 1 + ARRAY_SIZE(vcpu->arch.maar);
@@ -1755,7 +1755,7 @@ static int kvm_vz_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices)
 			return -EFAULT;
 		indices += ARRAY_SIZE(kvm_vz_get_one_regs_segments);
 	}
-	if (cpu_guest_has_htw) {
+	if (cpu_guest_has_htw || cpu_guest_has_ldpte) {
 		if (copy_to_user(indices, kvm_vz_get_one_regs_htw,
 				 sizeof(kvm_vz_get_one_regs_htw)))
 			return -EFAULT;
@@ -1878,17 +1878,17 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
 		*v = read_gc0_segctl2();
 		break;
 	case KVM_REG_MIPS_CP0_PWBASE:
-		if (!cpu_guest_has_htw)
+		if (!cpu_guest_has_htw && !cpu_guest_has_ldpte)
 			return -EINVAL;
 		*v = read_gc0_pwbase();
 		break;
 	case KVM_REG_MIPS_CP0_PWFIELD:
-		if (!cpu_guest_has_htw)
+		if (!cpu_guest_has_htw && !cpu_guest_has_ldpte)
 			return -EINVAL;
 		*v = read_gc0_pwfield();
 		break;
 	case KVM_REG_MIPS_CP0_PWSIZE:
-		if (!cpu_guest_has_htw)
+		if (!cpu_guest_has_htw && !cpu_guest_has_ldpte)
 			return -EINVAL;
 		*v = read_gc0_pwsize();
 		break;
@@ -1896,7 +1896,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
 		*v = (long)read_gc0_wired();
 		break;
 	case KVM_REG_MIPS_CP0_PWCTL:
-		if (!cpu_guest_has_htw)
+		if (!cpu_guest_has_htw && !cpu_guest_has_ldpte)
 			return -EINVAL;
 		*v = read_gc0_pwctl();
 		break;
@@ -2101,17 +2101,17 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu,
 		write_gc0_segctl2(v);
 		break;
 	case KVM_REG_MIPS_CP0_PWBASE:
-		if (!cpu_guest_has_htw)
+		if (!cpu_guest_has_htw && !cpu_guest_has_ldpte)
 			return -EINVAL;
 		write_gc0_pwbase(v);
 		break;
 	case KVM_REG_MIPS_CP0_PWFIELD:
-		if (!cpu_guest_has_htw)
+		if (!cpu_guest_has_htw && !cpu_guest_has_ldpte)
 			return -EINVAL;
 		write_gc0_pwfield(v);
 		break;
 	case KVM_REG_MIPS_CP0_PWSIZE:
-		if (!cpu_guest_has_htw)
+		if (!cpu_guest_has_htw && !cpu_guest_has_ldpte)
 			return -EINVAL;
 		write_gc0_pwsize(v);
 		break;
@@ -2119,7 +2119,7 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu,
 		change_gc0_wired(MIPSR6_WIRED_WIRED, v);
 		break;
 	case KVM_REG_MIPS_CP0_PWCTL:
-		if (!cpu_guest_has_htw)
+		if (!cpu_guest_has_htw && !cpu_guest_has_ldpte)
 			return -EINVAL;
 		write_gc0_pwctl(v);
 		break;
@@ -2580,7 +2580,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	/* restore HTW registers */
-	if (cpu_guest_has_htw) {
+	if (cpu_guest_has_htw || cpu_guest_has_ldpte) {
 		kvm_restore_gc0_pwbase(cop0);
 		kvm_restore_gc0_pwfield(cop0);
 		kvm_restore_gc0_pwsize(cop0);
@@ -2685,8 +2685,8 @@ static int kvm_vz_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	/* save HTW registers if enabled in guest */
-	if (cpu_guest_has_htw &&
-	    kvm_read_sw_gc0_config3(cop0) & MIPS_CONF3_PW) {
+	if (cpu_guest_has_ldpte || (cpu_guest_has_htw &&
+	    kvm_read_sw_gc0_config3(cop0) & MIPS_CONF3_PW)) {
 		kvm_save_gc0_pwbase(cop0);
 		kvm_save_gc0_pwfield(cop0);
 		kvm_save_gc0_pwsize(cop0);
-- 
2.7.0

