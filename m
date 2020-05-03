Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5171C2B2D
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgECKLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727976AbgECKLw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:11:52 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E56AC061A0C;
        Sun,  3 May 2020 03:11:52 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s10so5608190plr.1;
        Sun, 03 May 2020 03:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+m/G7tfb0svNx8vtj8cMuMEVCeP/gSEJcYLpJDO58o4=;
        b=MtvdHdW4gEzAach/LAi2gbYK1gi7sVFhijhZbN0TfNkq12PVMkJEpCv1shsKwTdEJe
         U+lDZT3IrdJ4iBB+jCay3kpGaPjBpPgU0GqUE405naO0+ZuYTLNKPkVS5EwGv+73QBBN
         WfKU2YP9njD06iVVE51r+oMhpsR9E5ui9dEAtv4PilxuaPkLzkQODKhw6Y3hPLdj9FA4
         X885lIrvC9Yiq1pUd2Z44807241kI9OC+4cdof30qsyF5Ovqus2hJHSLxRMjw5w6qeeB
         1PW/mCfgGcrl0kanraNpKMDvne52jCqornqyUHwAlAIusGICibwlWoCkEeNQQyYts16I
         dXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=+m/G7tfb0svNx8vtj8cMuMEVCeP/gSEJcYLpJDO58o4=;
        b=c5LdGIQa8i8Ea1gWPEag7Qa0Mwm247qoHA0Dh+Edchcgz3QeISab32camVJ9AUn6kB
         VGYfXH5nlCsvGnRIVWoIsoR+O9mLHQo89wY6VXQXyx3jXut5TVpv9Ce7Xqrj72hDEcsd
         PAW20oZdK9NsizSaX9v3abNl8+xevR86ELZ0CmRyj9Nop/VYGJoHikVKeuM+drRehAhT
         8HDU5ZhzYWZBHWVEZMT1spg+nNccAP/jrPHH6kXxU9/++BZwnW/rdphCYffuqDMPUBL/
         G89dJ8LAAJss1u5kMZYgzPigfx08Cz9enex283cHXMuMgNciWW36nv2S/nswZ+C/YuIz
         f0IA==
X-Gm-Message-State: AGi0PubFpav1Tdc45AggfngZZD01xcUNFrPLiGlqFMA3vbveiX7DExXD
        k64o5NJfbh6Np9SafVQyclhsoF0jCMo=
X-Google-Smtp-Source: APiQypL7rrGkZ694SGz64CL1U8lLZxiilicg5el8j0bOFpnN2zXX3CtbtifM4hfubUK4RZM6EJuATg==
X-Received: by 2002:a17:90a:328f:: with SMTP id l15mr11021856pjb.77.1588500711892;
        Sun, 03 May 2020 03:11:51 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.11.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:11:51 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 06/14] KVM: MIPS: Introduce and use cpu_guest_has_ldpte
Date:   Sun,  3 May 2020 18:05:59 +0800
Message-Id: <1588500367-1056-7-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
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
index ca2e6f1..be1b556 100644
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

