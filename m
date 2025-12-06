Return-Path: <kvm+bounces-65451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AC99DCA9D3C
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6E4E318DAEF
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C9925F78F;
	Sat,  6 Dec 2025 01:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mQNecxOs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B491F4CA9
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 01:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764983475; cv=none; b=XeO3RscWOKiWv8uJXcvDfDvRdIxl/FObVR6TQDgf0FxhcNJiNw09hw4FL70OcumfbMl7huNUHjLrTvQU7t7QekV4WgHndQA+Ibeiarl4OnI9z59xAqmDU05qmb03lrHx/Olc58eKR26FFZm36DICNkVxRfSkaxVrJb+mLmRRneI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764983475; c=relaxed/simple;
	bh=ZATKAQEg2XJr3LA90MeQutsxY8XZnMON4i4UR0lWMsY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W2tsxCvnGQ3E/yqGCMaCbNGGFcjl/OylFMohOvcepWUpKYJh2sfjKH/izXWBB3aGBZtaEASmM3oQ5IYKm1D5LA17jpgQ8HgJumrc4TKPnljsTD3e9fTWOlgodrBJKKRCVv+i6VVao0wBL6Oo8ehBAvJCCo/xiYg9VPga8LEZDJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mQNecxOs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3418ad76023so4790125a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 17:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764983472; x=1765588272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tAMo1PaS4H7jq5j8ypsO83hN6nYqoP5QoxyxWnbmvlI=;
        b=mQNecxOsrIajRliE2nnpcj7OJ4uoExozdfV9MbzjPYO88A245gmUsEkW52+QdQf7qO
         nZ+V6mwzulT0bOB7t1FcW6P3DvwRfmi4Yo12kPZfTcxhAPqu3fgBkJ1sGfImdu3VHyZ8
         o9XstmWsR9X2p+XSF3gaNTgD5AFtMcIKZd+heVFhOP4mLmir/txeVmQ5mdMSCmW5XrDt
         tdzFDLhr7YgxyMg8nPRSf9wKWI2ZcL7XIu64k+rvBRnGIq2kG0NxP2aMmwURF49Paa6J
         AfGv+H3RCd/JCV8iNiMivZGefkPIoxt14eFqO226N42W5i/Z3E7vtkWdfajhvSlYfpyO
         qIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764983472; x=1765588272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tAMo1PaS4H7jq5j8ypsO83hN6nYqoP5QoxyxWnbmvlI=;
        b=Cl3u6t94PWQZXBmqJqHwmCFzR3uGAgV52GIzCzbCT5pPfKHBwkjp7CtsU6lGTI2exJ
         s8/QaSsf1Y1HWzbFG8hm8k1WDytBu6WwNg2uVWbvqC0DRZ6qZzq6G7igX2pl3W9DAzcG
         dawv5lr2zD86gjU2r3KNLoPINbkcTFyCjK7RkJLEFy1lMG3I2g+63qC8lgNJPIyluF+n
         SslukvfYtgeYtts0NMkeYjdLNeGPbkNgDXABX+uod+pRuetfre9YtjzYfaXPLZt+HVOj
         sjKb2V6lGjdCtxwH4nweFBuxzg+22Q0FdtsSDkOkblomLNhHStEJTtDVsjraHAzhCbES
         24Cg==
X-Forwarded-Encrypted: i=1; AJvYcCW+HHhOogqDBDwClsG/i0Q/Hq4gF4GiRoEelS1AVNulmM+nWT6Ey3SLyvcatq3CvGRTBY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkoWMGuI+7Nxf0uROwJsupbgHJ0YKWVud5sYWBrsm/OU+4Rmnq
	FZLRB0cKFzIqUYDg9IUJ1GyH0zZ8Upr7nPLI47k+ckz8FhXtMHyitRFRO/aA1i5Cvl6HcTuPMfj
	vv1Corw==
X-Google-Smtp-Source: AGHT+IGm/V+n9o76MHvJYdn7e+iWw4CBd4GxYxhgTEzF/9IVcaC2gvinrCs5k9nTOHcKXsymWjL5Jq9uEqw=
X-Received: from pjbmz11.prod.google.com ([2002:a17:90b:378b:b0:33b:b692:47b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ecd:b0:340:a1a8:eb87
 with SMTP id 98e67ed59e1d1-349a260d6b8mr828827a91.35.1764983472272; Fri, 05
 Dec 2025 17:11:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 17:10:50 -0800
In-Reply-To: <20251206011054.494190-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206011054.494190-4-seanjc@google.com>
Subject: [PATCH v2 3/7] KVM: x86/tdx: Do VMXON and TDX-Module initialization
 during subsys init
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that VMXON can be done without bouncing through KVM, do TDX-Module
initialization during subsys init (specifically before module_init() so
that it runs before KVM when both are built-in).  Aside from the obvious
benefits of separating core TDX code from KVM, this will allow tagging a
pile of TDX functions and globals as being __init and __ro_after_init.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/arch/x86/tdx.rst |  26 -----
 arch/x86/include/asm/tdx.h     |   4 -
 arch/x86/kvm/vmx/tdx.c         | 169 ++++++--------------------------
 arch/x86/virt/vmx/tdx/tdx.c    | 170 ++++++++++++++++++---------------
 arch/x86/virt/vmx/tdx/tdx.h    |   8 --
 5 files changed, 124 insertions(+), 253 deletions(-)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index 61670e7df2f7..2e0a15d6f7d1 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -60,32 +60,6 @@ Besides initializing the TDX module, a per-cpu initialization SEAMCALL
 must be done on one cpu before any other SEAMCALLs can be made on that
 cpu.
 
-The kernel provides two functions, tdx_enable() and tdx_cpu_enable() to
-allow the user of TDX to enable the TDX module and enable TDX on local
-cpu respectively.
-
-Making SEAMCALL requires VMXON has been done on that CPU.  Currently only
-KVM implements VMXON.  For now both tdx_enable() and tdx_cpu_enable()
-don't do VMXON internally (not trivial), but depends on the caller to
-guarantee that.
-
-To enable TDX, the caller of TDX should: 1) temporarily disable CPU
-hotplug; 2) do VMXON and tdx_enable_cpu() on all online cpus; 3) call
-tdx_enable().  For example::
-
-        cpus_read_lock();
-        on_each_cpu(vmxon_and_tdx_cpu_enable());
-        ret = tdx_enable();
-        cpus_read_unlock();
-        if (ret)
-                goto no_tdx;
-        // TDX is ready to use
-
-And the caller of TDX must guarantee the tdx_cpu_enable() has been
-successfully done on any cpu before it wants to run any other SEAMCALL.
-A typical usage is do both VMXON and tdx_cpu_enable() in CPU hotplug
-online callback, and refuse to online if tdx_cpu_enable() fails.
-
 User can consult dmesg to see whether the TDX module has been initialized.
 
 If the TDX module is initialized successfully, dmesg shows something
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6b338d7f01b7..a149740b24e8 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -145,8 +145,6 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 #define seamcall(_fn, _args)		sc_retry(__seamcall, (_fn), (_args))
 #define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
 #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
-int tdx_cpu_enable(void);
-int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
@@ -223,8 +221,6 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
 #else
 static inline void tdx_init(void) { }
-static inline int tdx_cpu_enable(void) { return -ENODEV; }
-static inline int tdx_enable(void)  { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 21e67a47ad4e..d0161dc3d184 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -59,7 +59,7 @@ module_param_named(tdx, enable_tdx, bool, 0444);
 #define TDX_SHARED_BIT_PWL_5 gpa_to_gfn(BIT_ULL(51))
 #define TDX_SHARED_BIT_PWL_4 gpa_to_gfn(BIT_ULL(47))
 
-static enum cpuhp_state tdx_cpuhp_state;
+static enum cpuhp_state tdx_cpuhp_state __ro_after_init;
 
 static const struct tdx_sys_info *tdx_sysinfo;
 
@@ -3304,17 +3304,7 @@ int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 
 static int tdx_online_cpu(unsigned int cpu)
 {
-	unsigned long flags;
-	int r;
-
-	/* Sanity check CPU is already in post-VMXON */
-	WARN_ON_ONCE(!(cr4_read_shadow() & X86_CR4_VMXE));
-
-	local_irq_save(flags);
-	r = tdx_cpu_enable();
-	local_irq_restore(flags);
-
-	return r;
+	return 0;
 }
 
 static int tdx_offline_cpu(unsigned int cpu)
@@ -3353,51 +3343,6 @@ static int tdx_offline_cpu(unsigned int cpu)
 	return -EBUSY;
 }
 
-static void __do_tdx_cleanup(void)
-{
-	/*
-	 * Once TDX module is initialized, it cannot be disabled and
-	 * re-initialized again w/o runtime update (which isn't
-	 * supported by kernel).  Only need to remove the cpuhp here.
-	 * The TDX host core code tracks TDX status and can handle
-	 * 'multiple enabling' scenario.
-	 */
-	WARN_ON_ONCE(!tdx_cpuhp_state);
-	cpuhp_remove_state_nocalls_cpuslocked(tdx_cpuhp_state);
-	tdx_cpuhp_state = 0;
-}
-
-static void __tdx_cleanup(void)
-{
-	cpus_read_lock();
-	__do_tdx_cleanup();
-	cpus_read_unlock();
-}
-
-static int __init __do_tdx_bringup(void)
-{
-	int r;
-
-	/*
-	 * TDX-specific cpuhp callback to call tdx_cpu_enable() on all
-	 * online CPUs before calling tdx_enable(), and on any new
-	 * going-online CPU to make sure it is ready for TDX guest.
-	 */
-	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
-					 "kvm/cpu/tdx:online",
-					 tdx_online_cpu, tdx_offline_cpu);
-	if (r < 0)
-		return r;
-
-	tdx_cpuhp_state = r;
-
-	r = tdx_enable();
-	if (r)
-		__do_tdx_cleanup();
-
-	return r;
-}
-
 static int __init __tdx_bringup(void)
 {
 	const struct tdx_sys_info_td_conf *td_conf;
@@ -3417,34 +3362,18 @@ static int __init __tdx_bringup(void)
 		}
 	}
 
-	/*
-	 * Enabling TDX requires enabling hardware virtualization first,
-	 * as making SEAMCALLs requires CPU being in post-VMXON state.
-	 */
-	r = kvm_enable_virtualization();
-	if (r)
-		return r;
-
-	cpus_read_lock();
-	r = __do_tdx_bringup();
-	cpus_read_unlock();
-
-	if (r)
-		goto tdx_bringup_err;
-
-	r = -EINVAL;
 	/* Get TDX global information for later use */
 	tdx_sysinfo = tdx_get_sysinfo();
-	if (WARN_ON_ONCE(!tdx_sysinfo))
-		goto get_sysinfo_err;
+	if (!tdx_sysinfo)
+		return -EINVAL;
 
 	/* Check TDX module and KVM capabilities */
 	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
 	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
-		goto get_sysinfo_err;
+		return -EINVAL;
 
 	if (!(tdx_sysinfo->features.tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM))
-		goto get_sysinfo_err;
+		return -EINVAL;
 
 	/*
 	 * TDX has its own limit of maximum vCPUs it can support for all
@@ -3479,34 +3408,31 @@ static int __init __tdx_bringup(void)
 	if (td_conf->max_vcpus_per_td < num_present_cpus()) {
 		pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
 				td_conf->max_vcpus_per_td, num_present_cpus());
-		goto get_sysinfo_err;
+		return -EINVAL;
 	}
 
 	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
-		goto get_sysinfo_err;
+		return -EINVAL;
 
 	/*
-	 * Leave hardware virtualization enabled after TDX is enabled
-	 * successfully.  TDX CPU hotplug depends on this.
+	 * TDX-specific cpuhp callback to disallow offlining the last CPU in a
+	 * packing while KVM is running one or more TDs.  Reclaiming HKIDs
+	 * requires doing PAGE.WBINVD on every package, i.e. offlining all CPUs
+	 * of a package would prevent reclaiming the HKID.
 	 */
+	r = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvm/cpu/tdx:online",
+			      tdx_online_cpu, tdx_offline_cpu);
+	if (r < 0)
+		goto err_cpuhup;
+
+	tdx_cpuhp_state = r;
 	return 0;
 
-get_sysinfo_err:
-	__tdx_cleanup();
-tdx_bringup_err:
-	kvm_disable_virtualization();
+err_cpuhup:
+	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
 	return r;
 }
 
-void tdx_cleanup(void)
-{
-	if (enable_tdx) {
-		misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
-		__tdx_cleanup();
-		kvm_disable_virtualization();
-	}
-}
-
 int __init tdx_bringup(void)
 {
 	int r, i;
@@ -3538,56 +3464,14 @@ int __init tdx_bringup(void)
 		goto success_disable_tdx;
 	}
 
-	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
-		pr_err("tdx: MOVDIR64B is required for TDX\n");
-		goto success_disable_tdx;
-	}
-
-	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
-		pr_err("Self-snoop is required for TDX\n");
-		goto success_disable_tdx;
-	}
-
 	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
-		pr_err("tdx: no TDX private KeyIDs available\n");
+		pr_err("TDX not supported by the host platform\n");
 		goto success_disable_tdx;
 	}
 
-	if (!enable_virt_at_load) {
-		pr_err("tdx: tdx requires kvm.enable_virt_at_load=1\n");
-		goto success_disable_tdx;
-	}
-
-	/*
-	 * Ideally KVM should probe whether TDX module has been loaded
-	 * first and then try to bring it up.  But TDX needs to use SEAMCALL
-	 * to probe whether the module is loaded (there is no CPUID or MSR
-	 * for that), and making SEAMCALL requires enabling virtualization
-	 * first, just like the rest steps of bringing up TDX module.
-	 *
-	 * So, for simplicity do everything in __tdx_bringup(); the first
-	 * SEAMCALL will return -ENODEV when the module is not loaded.  The
-	 * only complication is having to make sure that initialization
-	 * SEAMCALLs don't return TDX_SEAMCALL_VMFAILINVALID in other
-	 * cases.
-	 */
 	r = __tdx_bringup();
-	if (r) {
-		/*
-		 * Disable TDX only but don't fail to load module if the TDX
-		 * module could not be loaded.  No need to print message saying
-		 * "module is not loaded" because it was printed when the first
-		 * SEAMCALL failed.  Don't bother unwinding the S-EPT hooks or
-		 * vm_size, as kvm_x86_ops have already been finalized (and are
-		 * intentionally not exported).  The S-EPT code is unreachable,
-		 * and allocating a few more bytes per VM in a should-be-rare
-		 * failure scenario is a non-issue.
-		 */
-		if (r == -ENODEV)
-			goto success_disable_tdx;
-
+	if (r)
 		enable_tdx = 0;
-	}
 
 	return r;
 
@@ -3596,6 +3480,15 @@ int __init tdx_bringup(void)
 	return 0;
 }
 
+void tdx_cleanup(void)
+{
+	if (!enable_tdx)
+		return;
+
+	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
+	cpuhp_remove_state(tdx_cpuhp_state);
+}
+
 void __init tdx_hardware_setup(void)
 {
 	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_tdx);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index eac403248462..8282c9b1b48b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -28,6 +28,7 @@
 #include <linux/log2.h>
 #include <linux/acpi.h>
 #include <linux/suspend.h>
+#include <linux/syscore_ops.h>
 #include <linux/idr.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
@@ -38,6 +39,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
+#include <asm/virt.h>
 #include "tdx.h"
 
 static u32 tdx_global_keyid __ro_after_init;
@@ -50,13 +52,11 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 
 static struct tdmr_info_list tdx_tdmr_list;
 
-static enum tdx_module_status_t tdx_module_status;
-static DEFINE_MUTEX(tdx_module_lock);
-
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
 static struct tdx_sys_info tdx_sysinfo;
+static bool tdx_module_initialized;
 
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
@@ -141,26 +141,15 @@ static int try_init_module_global(void)
 }
 
 /**
- * tdx_cpu_enable - Enable TDX on local cpu
- *
- * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
- * global initialization SEAMCALL if not done) on local cpu to make this
- * cpu be ready to run any other SEAMCALLs.
- *
- * Always call this function via IPI function calls.
- *
- * Return 0 on success, otherwise errors.
+ * Enable VMXON and then do one-time TDX module per-cpu initialization SEAMCALL
+ * (and TDX module global initialization SEAMCALL if not done) on local cpu to
+ * make this cpu be ready to run any other SEAMCALLs.
  */
-int tdx_cpu_enable(void)
+static int tdx_cpu_enable(void)
 {
 	struct tdx_module_args args = {};
 	int ret;
 
-	if (!boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
-		return -ENODEV;
-
-	lockdep_assert_irqs_disabled();
-
 	if (__this_cpu_read(tdx_lp_initialized))
 		return 0;
 
@@ -181,7 +170,56 @@ int tdx_cpu_enable(void)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tdx_cpu_enable);
+
+static int tdx_online_cpu(unsigned int cpu)
+{
+	int ret;
+
+	guard(irqsave)();
+
+	ret = x86_virt_get_cpu(X86_FEATURE_VMX);
+	if (ret)
+		return ret;
+
+	ret = tdx_cpu_enable();
+	if (ret)
+		x86_virt_put_cpu(X86_FEATURE_VMX);
+
+	return ret;
+}
+
+static int tdx_offline_cpu(unsigned int cpu)
+{
+	x86_virt_put_cpu(X86_FEATURE_VMX);
+	return 0;
+}
+
+static void tdx_shutdown_cpu(void *ign)
+{
+	x86_virt_put_cpu(X86_FEATURE_VMX);
+}
+
+static void tdx_shutdown(void)
+{
+	on_each_cpu(tdx_shutdown_cpu, NULL, 1);
+}
+
+static int tdx_suspend(void)
+{
+	x86_virt_put_cpu(X86_FEATURE_VMX);
+	return 0;
+}
+
+static void tdx_resume(void)
+{
+	WARN_ON_ONCE(x86_virt_get_cpu(X86_FEATURE_VMX));
+}
+
+static struct syscore_ops tdx_syscore_ops = {
+	.suspend = tdx_suspend,
+	.resume = tdx_resume,
+	.shutdown = tdx_shutdown,
+};
 
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
@@ -1156,67 +1194,50 @@ static int init_tdx_module(void)
 	goto out_put_tdxmem;
 }
 
-static int __tdx_enable(void)
+static int tdx_enable(void)
 {
+	enum cpuhp_state state;
 	int ret;
 
+	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
+		pr_err("TDX not supported by the host platform\n");
+		return -ENODEV;
+	}
+
+	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
+		pr_err("XSAVE is required for TDX\n");
+		return -EINVAL;
+	}
+
+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
+		pr_err("MOVDIR64B is required for TDX\n");
+		return -EINVAL;
+	}
+
+	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
+		pr_err("Self-snoop is required for TDX\n");
+		return -ENODEV;
+	}
+
+	state = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "virt/tdx:online",
+				  tdx_online_cpu, tdx_offline_cpu);
+	if (state < 0)
+		return state;
+
 	ret = init_tdx_module();
 	if (ret) {
-		pr_err("module initialization failed (%d)\n", ret);
-		tdx_module_status = TDX_MODULE_ERROR;
+		pr_err("TDX-Module initialization failed (%d)\n", ret);
+		cpuhp_remove_state(state);
 		return ret;
 	}
 
-	pr_info("module initialized\n");
-	tdx_module_status = TDX_MODULE_INITIALIZED;
+	register_syscore_ops(&tdx_syscore_ops);
 
+	tdx_module_initialized = true;
+	pr_info("TDX-Module initialized\n");
 	return 0;
 }
-
-/**
- * tdx_enable - Enable TDX module to make it ready to run TDX guests
- *
- * This function assumes the caller has: 1) held read lock of CPU hotplug
- * lock to prevent any new cpu from becoming online; 2) done both VMXON
- * and tdx_cpu_enable() on all online cpus.
- *
- * This function requires there's at least one online cpu for each CPU
- * package to succeed.
- *
- * This function can be called in parallel by multiple callers.
- *
- * Return 0 if TDX is enabled successfully, otherwise error.
- */
-int tdx_enable(void)
-{
-	int ret;
-
-	if (!boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
-		return -ENODEV;
-
-	lockdep_assert_cpus_held();
-
-	mutex_lock(&tdx_module_lock);
-
-	switch (tdx_module_status) {
-	case TDX_MODULE_UNINITIALIZED:
-		ret = __tdx_enable();
-		break;
-	case TDX_MODULE_INITIALIZED:
-		/* Already initialized, great, tell the caller. */
-		ret = 0;
-		break;
-	default:
-		/* Failed to initialize in the previous attempts */
-		ret = -EINVAL;
-		break;
-	}
-
-	mutex_unlock(&tdx_module_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(tdx_enable);
+subsys_initcall(tdx_enable);
 
 static bool is_pamt_page(unsigned long phys)
 {
@@ -1467,15 +1488,10 @@ void __init tdx_init(void)
 
 const struct tdx_sys_info *tdx_get_sysinfo(void)
 {
-	const struct tdx_sys_info *p = NULL;
+	if (!tdx_module_initialized)
+		return NULL;
 
-	/* Make sure all fields in @tdx_sysinfo have been populated */
-	mutex_lock(&tdx_module_lock);
-	if (tdx_module_status == TDX_MODULE_INITIALIZED)
-		p = (const struct tdx_sys_info *)&tdx_sysinfo;
-	mutex_unlock(&tdx_module_lock);
-
-	return p;
+	return (const struct tdx_sys_info *)&tdx_sysinfo;
 }
 EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..dde219c823b4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -91,14 +91,6 @@ struct tdmr_info {
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
  */
-
-/* Kernel defined TDX module status during module initialization. */
-enum tdx_module_status_t {
-	TDX_MODULE_UNINITIALIZED,
-	TDX_MODULE_INITIALIZED,
-	TDX_MODULE_ERROR
-};
-
 struct tdx_memblock {
 	struct list_head list;
 	unsigned long start_pfn;
-- 
2.52.0.223.gf5cc29aaa4-goog


