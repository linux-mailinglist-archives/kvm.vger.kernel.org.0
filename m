Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22441A639D
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgDMHY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDMHY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:24:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85C2C008651;
        Mon, 13 Apr 2020 00:24:58 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d24so3106330pll.8;
        Mon, 13 Apr 2020 00:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P1gwtYehv6c5Vy75KJf3Vt8CPa0lZUAYATRIzQMbBOk=;
        b=Umb11kB+vrK4GG6dK2YS/9zDGze0Btb+TB8xH+f1aeMAyn7d9b4y4KbYq6TVckipGs
         2EKE1kWULMhkQC03gfAMi3soWxAwVC9G4uZaNQTS5+XYI6prSXBfG59JnLZk6CF6nXPF
         8RwCkn8HQ0KEuVBUgTk9eVsNkoDEuPcFQDWh+7hwKR/xsoZQbuLph3Qbp3Cx4H+BZ/Xp
         m+obRAWRUq9ny6JltlmAd3eTj7sSCrpR5W1JhY0pyuP8EL5MYMNpAikJm4q0LAvLmVzg
         PY+GK0djY9SaWGD/h1+5PkcCIGXAcjt3moE1USKXsdIqe5NXWMCvsgIZA3zgkgCXg1Ak
         2xOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=P1gwtYehv6c5Vy75KJf3Vt8CPa0lZUAYATRIzQMbBOk=;
        b=GxWr3LNCxQ0C+k7PYQAh4DXy8RasZr1YJkzjEc02EmEBD0hxeq/NlpmTQnd/95ZYNQ
         QhG048JhZIAw3JgnJW5KScbWV4wXtMSCO+iZT14rQHspWlTS3eKZl1DALPDJ838uUy/J
         agdv3yKKbJFeLBUb6xmWYR01dY6sVf2xy0q4kPSN9vRzGIjawSoGgV3O6pnu2SWnC7EG
         KkR6/zOPT/H0nIFMi6Fv6cIG+eoQiIXSZgT+itQYkolKSPbzfFAYfjFapJmhtfZgVviS
         PwltRZZ5vKHgNIBYtuVZ+t2P/C1k4odi/t+hxribibSRH3yxlNA+4EYFHuVUMOc4WEjb
         DLXg==
X-Gm-Message-State: AGi0Pub141GMCQOqBBcLsrS4X6E4xXNGXuxLiZjHwq12od0HnH6DOBTu
        /L2XwvcrxBgdbMxAfnGeTuLDMYWwk80=
X-Google-Smtp-Source: APiQypK9+Auw7pBt8tjztF5LAWCHIHnFGJdkSJQ2BhKbroLsKAWsSBDeoNRaSQyNzMWaFSg82HbeMA==
X-Received: by 2002:a17:90a:630b:: with SMTP id e11mr12400105pjj.167.1586762698222;
        Mon, 13 Apr 2020 00:24:58 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.24.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:24:57 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 07/15] KVM: MIPS: Introduce and use cpu_guest_has_ldpte
Date:   Mon, 13 Apr 2020 15:30:16 +0800
Message-Id: <1586763024-12197-8-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 has lddir/ldpte instructions and their related CP0 registers
are the same as HTW. So we introduce a cpu_guest_has_ldpte flag and use
it to indicate whether we need to save/restore HTW related CP0 registers
(PWBase, PWSize, PWField and PWCtl).

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

