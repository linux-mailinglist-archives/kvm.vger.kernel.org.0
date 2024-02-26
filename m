Return-Path: <kvm+bounces-9880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFA98678D5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 543D11F2DE19
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513E0131E25;
	Mon, 26 Feb 2024 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lU9RktdC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0048412B15B;
	Mon, 26 Feb 2024 14:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958136; cv=none; b=gnGaL2Oh/8smFhZ3K6VEWTUiEznU5IVgVO2lSywG1jPmns3rggYZLkNOr1FNV3CFoH+jd46o/15UulAP+B2QhqWE8HlNyGuCtNxw0WH5Orcd6etOQTiIzu294Dp+P7uKdhvQIIvxOq/AomDguwdCIn4EktXaIgXFDk8J5tfSmOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958136; c=relaxed/simple;
	bh=A91XOAPWlG4UQM4/y3mhJgJbexBv/5cbd9ybcfuxCMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BtzYmFQroxggWxInA49bk95iHynjORLYKCVCxvcGlznChpKdu7n532VDWiaVjNBa3YiCvuOSQwtMhZMYc83o3J2njo0pWmAiKgVhNr/etS/RKJF/IlBoEsOTi8JKq3kpG44vkfkZfBoWrnJplN4vBnIGWqSfFjuevWrrQrSC8eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lU9RktdC; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dc9222b337so12871425ad.2;
        Mon, 26 Feb 2024 06:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958134; x=1709562934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=riQZ9ZpwPxz2QrssKIMSS0JXLxPFIoRiOKE+eD6KDsw=;
        b=lU9RktdCkXFgRdwP8zBrXTb5xpHvjpOyGWzjRHapsvywg/i3XXSBiqxmXXeM8v+o4Q
         PdhLDERYpqLpZUvTHUktdsinfoNtAkyDgKtqs8aI+s+a/k9BH0LwkCQPrFxzaHrnQFfV
         RoqWFiHdgEU2gx0rceEdp5IgbZGJzzZHkI9klPBg7vtu0QZ3Kg2dSM9cn9lxbSq6Mb+U
         bmiW8Z+3kjT1YwlRzzd2u0ZW4MDm6IEWKTx2z/eTzTCJIfAHAYWJiH2NIzabZiDN++iZ
         QqD7w5dKrrP6TWFNXVk9IYhssrsYXnxVO9LtTizjYwIqj4do3dRNGAMVyZWnifTkqPgS
         G/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958134; x=1709562934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=riQZ9ZpwPxz2QrssKIMSS0JXLxPFIoRiOKE+eD6KDsw=;
        b=hRRagJP6FHWW8b6Ck9Bi37IUpMOB5oWsBWUlPvJSaEyK51AdFF/PVhBnLHRkZcMrQ6
         EBZOG6jrcnouuZql9Qkj2bN/Lx4a3HgOGf6gFwFDrZg+M6gZ0S9JqHyrtxZuzmnGkjXa
         CwZab6larCDKTqkcVtDZZPiD89klUDEiaYBcywmBc5+Fy4CcYCYQSvimCgP/ZraurWin
         Nq9fpNPoJomQQlrzLbdy2j+5ct0qJai8c6cSeMPTRbnDUkxT3sU67aBciXnt9frikX3p
         8ryO3Ykzg4VkbXyzJuwVtKTvYQ5VuwPihi4ZJLWdgZYXWUET0lrlKSwMA6k9aHzE7iSD
         yhCA==
X-Forwarded-Encrypted: i=1; AJvYcCWbgvqPA2HnGrWMOUoaraEJRBWdIHJ1EdlPoS3P9/wDpNDCJwuK7vt6neeLH/X7Zj5rcGhupEFMevF6z874OYfGPQJK
X-Gm-Message-State: AOJu0YwMY21xl5OYs+UTYfUSM7mttVR6LP46aZX8ReuoySZL+d6a8NGM
	tGYWepY3v/pH7FMe6zgwhNcLeOZZrdbkai5YV+r+3EMOPPPLhx3KZCtp/5XV
X-Google-Smtp-Source: AGHT+IHECtnuYEhCc+LtTSqZFq0GvsQFgPnhhCjRj5C7penoqaGkEFA3+9fJ+eNcu8ruHubMNcBCaQ==
X-Received: by 2002:a17:903:1111:b0:1db:9a7d:2e6 with SMTP id n17-20020a170903111100b001db9a7d02e6mr7701854plh.48.1708958133971;
        Mon, 26 Feb 2024 06:35:33 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id d20-20020a170902c19400b001db9fa23407sm4000701pld.195.2024.02.26.06.35.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:33 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 17/73] KVM: x86/PVM: Implement module initialization related callbacks
Date: Mon, 26 Feb 2024 22:35:34 +0800
Message-Id: <20240226143630.33643-18-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Implement hardware enable/disable and setup/unsetup callbacks for PVM
module initialization.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 226 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |  20 ++++
 2 files changed, 246 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 1dfa1ae57c8c..83aa2c9f42f6 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -9,18 +9,244 @@
  * the COPYING file in the top-level directory.
  *
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 
+#include <asm/pvm_para.h>
+
+#include "cpuid.h"
+#include "x86.h"
+#include "pvm.h"
+
 MODULE_AUTHOR("AntGroup");
 MODULE_LICENSE("GPL");
 
+static bool __read_mostly is_intel;
+
+static unsigned long host_idt_base;
+
+static void pvm_setup_mce(struct kvm_vcpu *vcpu)
+{
+}
+
+static bool pvm_has_emulated_msr(struct kvm *kvm, u32 index)
+{
+	switch (index) {
+	case MSR_IA32_MCG_EXT_CTL:
+	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
+		return false;
+	case MSR_AMD64_VIRT_SPEC_CTRL:
+	case MSR_AMD64_TSC_RATIO:
+		/* This is AMD SVM only. */
+		return false;
+	case MSR_IA32_SMBASE:
+		/* Currenlty we only run guest in long mode. */
+		return false;
+	default:
+		break;
+	}
+
+	return true;
+}
+
+static bool cpu_has_pvm_wbinvd_exit(void)
+{
+	return true;
+}
+
+static int hardware_enable(void)
+{
+	/* Nothing to do */
+	return 0;
+}
+
+static void hardware_disable(void)
+{
+	/* Nothing to do */
+}
+
+static int pvm_check_processor_compat(void)
+{
+	/* Nothing to do */
+	return 0;
+}
+
+static __init void pvm_set_cpu_caps(void)
+{
+	if (boot_cpu_has(X86_FEATURE_NX))
+		kvm_enable_efer_bits(EFER_NX);
+	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
+		kvm_enable_efer_bits(EFER_FFXSR);
+
+	kvm_set_cpu_caps();
+
+	/* Unloading kvm-intel.ko doesn't clean up kvm_caps.supported_mce_cap. */
+	kvm_caps.supported_mce_cap = MCG_CTL_P | MCG_SER_P;
+
+	kvm_caps.supported_xss = 0;
+
+	/* PVM supervisor mode runs on hardware ring3, so no xsaves. */
+	kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+
+	/*
+	 * PVM supervisor mode runs on hardware ring3, so SMEP and SMAP can not
+	 * be supported directly through hardware.  But they can be emulated
+	 * through other hardware feature when needed.
+	 */
+
+	/*
+	 * PVM doesn't support SMAP, but the similar protection might be
+	 * emulated via PKU in the future.
+	 */
+	kvm_cpu_cap_clear(X86_FEATURE_SMAP);
+
+	/*
+	 * PVM doesn't support SMEP.  When NX is supported and the guest can
+	 * use NX on the user pagetable to emulate the same protection as SMEP.
+	 */
+	kvm_cpu_cap_clear(X86_FEATURE_SMEP);
+
+	/*
+	 * Unlike VMX/SVM which can switches paging mode atomically, PVM
+	 * implements guest LA57 through host LA57 shadow paging.
+	 */
+	if (!pgtable_l5_enabled())
+		kvm_cpu_cap_clear(X86_FEATURE_LA57);
+
+	/*
+	 * Even host pcid is not enabled, guest pcid can be enabled to reduce
+	 * the heavy guest tlb flushing.  Guest CR4.PCIDE is not directly
+	 * mapped to the hardware and is virtualized by PVM so that it can be
+	 * enabled unconditionally.
+	 */
+	kvm_cpu_cap_set(X86_FEATURE_PCID);
+
+	/* Don't expose MSR_IA32_SPEC_CTRL to guest */
+	kvm_cpu_cap_clear(X86_FEATURE_SPEC_CTRL);
+	kvm_cpu_cap_clear(X86_FEATURE_AMD_STIBP);
+	kvm_cpu_cap_clear(X86_FEATURE_AMD_IBRS);
+	kvm_cpu_cap_clear(X86_FEATURE_AMD_SSBD);
+
+	/* PVM hypervisor hasn't implemented LAM so far */
+	kvm_cpu_cap_clear(X86_FEATURE_LAM);
+
+	/* Don't expose MSR_IA32_DEBUGCTLMSR related features. */
+	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
+}
+
+static __init int hardware_setup(void)
+{
+	struct desc_ptr dt;
+
+	store_idt(&dt);
+	host_idt_base = dt.address;
+
+	pvm_set_cpu_caps();
+
+	kvm_configure_mmu(false, 0, 0, 0);
+
+	enable_apicv = 0;
+
+	return 0;
+}
+
+static void hardware_unsetup(void)
+{
+}
+
+struct kvm_x86_nested_ops pvm_nested_ops = {};
+
+static struct kvm_x86_ops pvm_x86_ops __initdata = {
+	.name = KBUILD_MODNAME,
+
+	.check_processor_compatibility = pvm_check_processor_compat,
+
+	.hardware_unsetup = hardware_unsetup,
+	.hardware_enable = hardware_enable,
+	.hardware_disable = hardware_disable,
+	.has_emulated_msr = pvm_has_emulated_msr,
+
+	.has_wbinvd_exit = cpu_has_pvm_wbinvd_exit,
+
+	.nested_ops = &pvm_nested_ops,
+
+	.setup_mce = pvm_setup_mce,
+};
+
+static struct kvm_x86_init_ops pvm_init_ops __initdata = {
+	.hardware_setup = hardware_setup,
+
+	.runtime_ops = &pvm_x86_ops,
+};
+
 static void pvm_exit(void)
 {
+	kvm_exit();
+	kvm_x86_vendor_exit();
+	host_mmu_destroy();
+	allow_smaller_maxphyaddr = false;
+	kvm_cpuid_vendor_signature = 0;
 }
 module_exit(pvm_exit);
 
+static int __init hardware_cap_check(void)
+{
+	/*
+	 * switcher can't be used when KPTI. See the comments above
+	 * SWITCHER_SAVE_AND_SWITCH_TO_HOST_CR3
+	 */
+	if (boot_cpu_has(X86_FEATURE_PTI)) {
+		pr_warn("Support for host KPTI is not included yet.\n");
+		return -EOPNOTSUPP;
+	}
+	if (!boot_cpu_has(X86_FEATURE_FSGSBASE)) {
+		pr_warn("FSGSBASE is required per PVM specification.\n");
+		return -EOPNOTSUPP;
+	}
+	if (!boot_cpu_has(X86_FEATURE_RDTSCP)) {
+		pr_warn("RDTSCP is required to support for getcpu in guest vdso.\n");
+		return -EOPNOTSUPP;
+	}
+	if (!boot_cpu_has(X86_FEATURE_CX16)) {
+		pr_warn("CMPXCHG16B is required for guest.\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int __init pvm_init(void)
 {
+	int r;
+
+	r = hardware_cap_check();
+	if (r)
+		return r;
+
+	r = host_mmu_init();
+	if (r)
+		return r;
+
+	is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
+
+	r = kvm_x86_vendor_init(&pvm_init_ops);
+	if (r)
+		goto exit_host_mmu;
+
+	r = kvm_init(sizeof(struct vcpu_pvm), __alignof__(struct vcpu_pvm), THIS_MODULE);
+	if (r)
+		goto exit_vendor;
+
+	allow_smaller_maxphyaddr = true;
+	kvm_cpuid_vendor_signature = PVM_CPUID_SIGNATURE;
+
 	return 0;
+
+exit_vendor:
+	kvm_x86_vendor_exit();
+exit_host_mmu:
+	host_mmu_destroy();
+	return r;
 }
 module_init(pvm_init);
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 7a3732986a6d..6149cf5975a4 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -2,6 +2,8 @@
 #ifndef __KVM_X86_PVM_H
 #define __KVM_X86_PVM_H
 
+#include <linux/kvm_host.h>
+
 #define PT_L4_SHIFT		39
 #define PT_L4_SIZE		(1UL << PT_L4_SHIFT)
 #define DEFAULT_RANGE_L4_SIZE	(32 * PT_L4_SIZE)
@@ -20,4 +22,22 @@ extern u64 *host_mmu_root_pgd;
 void host_mmu_destroy(void);
 int host_mmu_init(void);
 
+struct vcpu_pvm {
+	struct kvm_vcpu vcpu;
+};
+
+struct kvm_pvm {
+	struct kvm kvm;
+};
+
+static __always_inline struct kvm_pvm *to_kvm_pvm(struct kvm *kvm)
+{
+	return container_of(kvm, struct kvm_pvm, kvm);
+}
+
+static __always_inline struct vcpu_pvm *to_pvm(struct kvm_vcpu *vcpu)
+{
+	return container_of(vcpu, struct vcpu_pvm, vcpu);
+}
+
 #endif /* __KVM_X86_PVM_H */
-- 
2.19.1.6.gb485710b


