Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38C21DF5DB
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 10:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbgEWH77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 03:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387500AbgEWH77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 03:59:59 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E445EC061A0E;
        Sat, 23 May 2020 00:59:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k7so5991179pjs.5;
        Sat, 23 May 2020 00:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uvxbohdTcYktiH8V5tIMdDfRGgFusopevxW5sUNe1cM=;
        b=AvckXMftEzFoDtcgA1wKtQUIPTYu5Rx/lRJJhmGT1xyYH161XLIkdjZ4CAbea4/X1J
         qg0oQ4EZB3i7Yp5tryck0FgI1LFpJ6VuyJJi+tWjJ4XP2jZ3xgDVBsvuRWR6p59Fynwt
         lADy4MaDwiGuFvk+FRecqS2QYeVZ1i6fL0eoMPBBBJGtu1y0biWyRsASqS4Aqvr7UBsc
         SvbJjc9E9+Y9yIydvTvmXhd1SpDCD+jWFBWufc363G3zhBRCz37HmuZuV7cgfRk4nTp3
         XQun9gFfWqCMgUe5o5E8PmEjoEohqSNHTcMTZejxiUTg8i/w7Bk5F0/xoNn8/EEtOVFR
         TQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=uvxbohdTcYktiH8V5tIMdDfRGgFusopevxW5sUNe1cM=;
        b=MAgNglv53Zq54dxf3cjNDiPr3H7RLHqhn9AR6m7DTrxfK24VHC1avvzuRnpLkPos6l
         PmyCMKnLa6zjIkt6aaGZP1TIxmckfQBhV+ee4I5ospU73QjQRKcVm37/Dicqm6ZgnE3z
         4znd0FgES3JfmNT/mL8iPxUGz4Ka9q1J2xuOd2W1I1qR7QGGH6GOPmwturPcvSaCXRaF
         4dyNWW7uY67b/hBKG/VqgwWc19DmwaPwja7MNPAEE5zhmymbRuDiOv+9VVK02e9vZY5+
         AR+AGjWP5qYPec/pPD6c9egaNtgmKRrx8mCY28ujnJeqNJRceha51U8xZj+XAjCIFOXM
         DUIA==
X-Gm-Message-State: AOAM5326pl6OLc/PmZtmfa8ZmAssY00XJ+tM/vtnRXxnlInqNsgYVdd/
        BVpmBUNeikoDHLkWLU/mXhk=
X-Google-Smtp-Source: ABdhPJyKVABLEsZKmAfGKDTD2ybUC6zYcN3BZuE0PwKpzb1rkIVdgygElEC7e/7h1WDujQBvdVe5kA==
X-Received: by 2002:a17:90b:f8c:: with SMTP id ft12mr9254370pjb.127.1590220798516;
        Sat, 23 May 2020 00:59:58 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.00.59.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 00:59:58 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 06/15] KVM: MIPS: Introduce and use cpu_guest_has_ldpte
Date:   Sat, 23 May 2020 15:56:33 +0800
Message-Id: <1590220602-3547-7-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
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
index 400b123..e127495 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -659,6 +659,9 @@
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
index a0ef21b..e464c7e 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1950,8 +1950,10 @@ static inline void decode_cpucfg(struct cpuinfo_mips *c)
 	if (cfg2 & LOONGSON_CFG2_LEXT2)
 		c->ases |= MIPS_ASE_LOONGSON_EXT2;
 
-	if (cfg2 & LOONGSON_CFG2_LSPW)
+	if (cfg2 & LOONGSON_CFG2_LSPW) {
 		c->options |= MIPS_CPU_LDPTE;
+		c->guest.options |= MIPS_CPU_LDPTE;
+	}
 
 	if (cfg3 & LOONGSON_CFG3_LCAMP)
 		c->ases |= MIPS_ASE_LOONGSON_CAM;
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

