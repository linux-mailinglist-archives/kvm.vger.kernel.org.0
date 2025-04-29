Return-Path: <kvm+bounces-44774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D18AA0D71
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0791D7A5A17
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A2E2D029A;
	Tue, 29 Apr 2025 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RJCVeCeL"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FE9442C;
	Tue, 29 Apr 2025 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745933177; cv=none; b=sd1oDFvwBnuVMuztXbaaKGaaxY5dW17u6NgKhNCzmYrK4pkDf4hYysTApfmEjv5jQQfl/isP0D/EbxG0qxzXb25SNri/lCpLIeySpQTvpgIi/6dc6OSAroiaNDjgJeFnIh2RTjgi55SVwXRAZEbSQY93fXYSTQN3UqxBmo6i79o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745933177; c=relaxed/simple;
	bh=WqkAevnq1qIHx5UgfotpwNCiOEt7kjRpESqmPILC7pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1ooIVSOpaHFmRcYutA7US+OpcUWKtciTqsyUfKZYxbAgonauXotpiZWb4Rgl3US5vwyWvdEGfOhKFBS9iRngH9ESsB+bs/a2Fa+WTEsK/MyimGe//XG2NjZGNVtiMvQriXVMoUBs4mUN+E5myO7RXJLwybHD0ia4o/GpVXohhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RJCVeCeL; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EDF9E40E0219;
	Tue, 29 Apr 2025 13:26:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DHONXOjktnEZ; Tue, 29 Apr 2025 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1745933165; bh=Fir+epn6yfQ3pe4y7dsEdSkkFAODV1gWds5t0ksNP2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RJCVeCeLpYM5RKB9fpHF8+qeO5UmK7yvHPg8gKuV44c82sHVN8Va5I5vmsfXEXh0G
	 bKHaEQcEqzJbifwq31HdeFCV4VRx4d+M2YayT11V/AIfURHV1PNXib2IVk1H4URmbG
	 dQdJ0qQh1c1n0S3Tn3TuNTKU8q11tnLQpWjXCMOEfw76vgndG4ZHCR48TcmNEORmKM
	 xQdsLluKuFMr27WxSPe9f/+mvqb1yMJJ9ygzHwKLFkyAbtdS+oA53UhCMWPEOl8Egh
	 PyyXon1csd4aK/ovMvaTelW2OcQvhHB7AEbkTL9xEdc8XmpFHmHBoMu8d+IbJ0doWs
	 8Bh0mTx70GfY2sbG9qVOJZR/AkaAxdcBZsCLn8ZyJVfu5efkSmOhV5B39vXdN8VWkN
	 +gL6jt46kFWRkJcKDtjzi0w6Hs8/YQJII0+mPo1IWQQuvXWsmkKUCPeU2KEnxPeyQf
	 9SFuZF7NJJ0U27TStaLgC8huIv9H1hyBzCjcNldWnB6YQvkoM8m5QLgn9/c4VqXTJd
	 KE/UIz1OzE2dDB6PE3K79LyZ7eqInNwt0VkI2qXZuKtDVmOaK8udnfxUREU9SvX1If
	 LtClkAhwMgKoLl3xmaWRSyqLv1dHI0loU23oOYS2RlklNfcuqCjBhjse9TBF5N36Ew
	 KYDco4HkyqqnTTr8RSHbotMc=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3FD6D40E0173;
	Tue, 29 Apr 2025 13:25:52 +0000 (UTC)
Date: Tue, 29 Apr 2025 15:25:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	David Kaplan <David.Kaplan@amd.com>,
	Michael Larabel <Michael@michaellarabel.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Message-ID: <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
 <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
 <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>

On Tue, Feb 18, 2025 at 12:13:33PM +0100, Borislav Petkov wrote:
> So,
> 
> in the interest of finally making some progress here I'd like to commit this
> below (will test it one more time just in case but it should work :-P). It is
> simple and straight-forward and doesn't need an IBPB when the bit gets
> cleared.
> 
> A potential future improvement is David's suggestion that there could be a way
> for tracking when the first guest gets started, we set the bit then, we make
> sure the bit gets set on each logical CPU when the guests migrate across the
> machine and when the *last* guest exists, that bit gets cleared again.

Well, that "simplicity" was short-lived:

https://www.phoronix.com/review/linux-615-amd-regression

Sean, how about this below?

It is hacky and RFC-ish - i.e., don't look too hard at it - but basically
I'm pushing down into arch code the decision whether to enable virt on load.

And it has no effects on anything else but machines which have this
SRSO_MSR_FIX (Zen5).

And it seems to work here - the MSR is set only when I create a VM - i.e., as
expected.

Thoughts? Better ideas?

Thx.

---

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 823c0434bbad..6cc8698df1a5 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -16,6 +16,7 @@ BUILD_BUG_ON(1)
 KVM_X86_OP(check_processor_compatibility)
 KVM_X86_OP(enable_virtualization_cpu)
 KVM_X86_OP(disable_virtualization_cpu)
+KVM_X86_OP_OPTIONAL(enable_virt_on_load)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3131abcac4f1..c1a29d7fee45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1664,6 +1664,7 @@ struct kvm_x86_ops {
 
 	int (*enable_virtualization_cpu)(void);
 	void (*disable_virtualization_cpu)(void);
+	bool (*enable_virt_on_load)(void);
 	cpu_emergency_virt_cb *emergency_disable_virtualization_cpu;
 
 	void (*hardware_unsetup)(void);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 67657b3a36ce..dcbba55cb949 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -693,6 +693,16 @@ static int svm_enable_virtualization_cpu(void)
 	return 0;
 }
 
+static bool svm_enable_virt_on_load(void)
+{
+	bool ret = true;
+
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		ret = false;
+
+	return ret;
+}
+
 static void svm_cpu_uninit(int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
@@ -5082,6 +5092,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_unsetup,
 	.enable_virtualization_cpu = svm_enable_virtualization_cpu,
 	.disable_virtualization_cpu = svm_disable_virtualization_cpu,
+	.enable_virt_on_load = svm_enable_virt_on_load,
 	.emergency_disable_virtualization_cpu = svm_emergency_disable_virtualization_cpu,
 	.has_emulated_msr = svm_has_emulated_msr,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c6553985e75..a09dc8cbd59f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12576,9 +12576,15 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
-void kvm_arch_enable_virtualization(void)
+bool kvm_arch_enable_virtualization(bool allow_arch_override)
 {
+	if (allow_arch_override)
+		if (!kvm_x86_call(enable_virt_on_load)())
+			return false;
+
 	cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
+
+	return true;
 }
 
 void kvm_arch_disable_virtualization(void)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 291d49b9bf05..4353ef54d45d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1599,7 +1599,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
  * kvm_usage_count, i.e. at the beginning of the generic hardware enabling
  * sequence, and at the end of the generic hardware disabling sequence.
  */
-void kvm_arch_enable_virtualization(void);
+bool kvm_arch_enable_virtualization(bool);
 void kvm_arch_disable_virtualization(void);
 /*
  * kvm_arch_{enable,disable}_virtualization_cpu() are called on "every" CPU to
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a92624..0009661dee1d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -143,8 +143,8 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int kvm_enable_virtualization(void);
-static void kvm_disable_virtualization(void);
+static int kvm_enable_virtualization(bool allow_arch_override);
+static void kvm_disable_virtualization(bool allow_arch_override);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1187,7 +1187,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = kvm_enable_virtualization();
+	r = kvm_enable_virtualization(false);
 	if (r)
 		goto out_err_no_disable;
 
@@ -1224,7 +1224,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	kvm_disable_virtualization();
+	kvm_disable_virtualization(false);
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
@@ -1320,7 +1320,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
-	kvm_disable_virtualization();
+	kvm_disable_virtualization(false);
 	mmdrop(mm);
 }
 
@@ -5489,9 +5489,9 @@ static DEFINE_PER_CPU(bool, virtualization_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
-__weak void kvm_arch_enable_virtualization(void)
+__weak bool kvm_arch_enable_virtualization(bool)
 {
-
+	return false;
 }
 
 __weak void kvm_arch_disable_virtualization(void)
@@ -5589,8 +5589,9 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-static int kvm_enable_virtualization(void)
+static int kvm_enable_virtualization(bool allow_arch_override)
 {
+	bool do_init;
 	int r;
 
 	guard(mutex)(&kvm_usage_lock);
@@ -5598,7 +5599,9 @@ static int kvm_enable_virtualization(void)
 	if (kvm_usage_count++)
 		return 0;
 
-	kvm_arch_enable_virtualization();
+	do_init = kvm_arch_enable_virtualization(allow_arch_override);
+	if (!do_init)
+		goto out;
 
 	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
 			      kvm_online_cpu, kvm_offline_cpu);
@@ -5631,11 +5634,13 @@ static int kvm_enable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 err_cpuhp:
 	kvm_arch_disable_virtualization();
+
+out:
 	--kvm_usage_count;
 	return r;
 }
 
-static void kvm_disable_virtualization(void)
+static void kvm_disable_virtualization(bool allow_arch_override)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5650,7 +5655,7 @@ static void kvm_disable_virtualization(void)
 static int kvm_init_virtualization(void)
 {
 	if (enable_virt_at_load)
-		return kvm_enable_virtualization();
+		return kvm_enable_virtualization(true);
 
 	return 0;
 }
@@ -5658,10 +5663,10 @@ static int kvm_init_virtualization(void)
 static void kvm_uninit_virtualization(void)
 {
 	if (enable_virt_at_load)
-		kvm_disable_virtualization();
+		kvm_disable_virtualization(true);
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-static int kvm_enable_virtualization(void)
+static int kvm_enable_virtualization(bool allow_arch_override)
 {
 	return 0;
 }
@@ -5671,7 +5676,7 @@ static int kvm_init_virtualization(void)
 	return 0;
 }
 
-static void kvm_disable_virtualization(void)
+static void kvm_disable_virtualization(bool allow_arch_override)
 {
 
 }


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

