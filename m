Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64C51D0B1A
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732360AbgEMIp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732279AbgEMIp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:45:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F7FC061A0C;
        Wed, 13 May 2020 01:45:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x2so7708619pfx.7;
        Wed, 13 May 2020 01:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3mkjt1gC8EkLgr4Lv+xxwrIJE7zYUsDg7KCCbtJeVzU=;
        b=t6oXxeFfJKsf9izmQEfZfrNCcEVovk7BXTlVQPDF/yWq583V1mgJeyBD8xWtzEBRZ5
         7XSubiGcugq+bHdtKkZJc0XM09DiYXFGYTwWCWqXZuH1l4U6ZqW2frCjRFWQB0oYgjLD
         9yBTXJa2PQKLRvU+9hFu+ngkI5k4gFXMbsrXrKstAidef4bIdPYCEEem+DH1uaQE3x7t
         gaQmWGa+y8OsaAdFdXLIeJg2lY/ymzf4cYnX/uSubtBzvGhkrIBhkzc6VKdxNn1Xgi3E
         m58cuLD8+JALP0DUP2mF08bkX3ZA6s7VpEobNtm/K9U76VXbfByEvEs7kWh2I/65FV1i
         8DZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=3mkjt1gC8EkLgr4Lv+xxwrIJE7zYUsDg7KCCbtJeVzU=;
        b=PcT93AqwzOtwJkBoPXlwXbg7Bd3rTAXPFcY3/zcRSKeYS0Wbm56EGjae/nxzwxLy4C
         YrkgClWNqXzL0Sr+Hh/6FmYfSIHTQsdX8ZaR0AUnkIS7IwZMVaZkODLbZPpI3USvRXTC
         QUyuLc5HANVC5El15DtPdYiqjOA6Nj8zhcaGfl1HxWCxFTjAT1fXE1ryiXr3K6jbaBYb
         YD7+OwdJUR3K/jhsFeNqeASQyg+sZE8fEtxxc9t9pH+EMb68pzIXn8m+GhsoEJG5YihD
         yHMDUnl1qtfuakaYmVRdZBBl03R/pB62qjTLHMO7nfMGQ99rH4+sDQwPI25K4ToYIsmA
         GwVg==
X-Gm-Message-State: AGi0PuY5jxMoZmP2z2e1nKbz9tUWm/+m6ZBJ6n9cohIH3CW7HE8/GEiY
        jEhovIY0EH/6WEG9GPprDMA=
X-Google-Smtp-Source: APiQypIvCFfxKZcQr43Uvr12chdiQfQb4sWuVXGO/bZuEOgbHaPGGvk+VwTmtEmtOR4ByqIV4Otj0A==
X-Received: by 2002:a63:41c2:: with SMTP id o185mr23330071pga.139.1589359527177;
        Wed, 13 May 2020 01:45:27 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.45.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:45:26 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 06/15] KVM: MIPS: Introduce and use cpu_guest_has_ldpte
Date:   Wed, 13 May 2020 16:42:37 +0800
Message-Id: <1589359366-1669-7-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 has lddir/ldpte instructions and their related CP0 registers
are the same as HTW. So we introduce a cpu_guest_has_ldpte flag and use
it to indicate whether we need to save/restore HTW related CP0 registers
(PWBase, PWSize, PWField and PWCtl).

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
index a0ef21b..319c250 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2004,6 +2004,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		 * register, we correct it here.
 		 */
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

