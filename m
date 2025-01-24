Return-Path: <kvm+bounces-36577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF72A1BDB4
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 22:00:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69EC0188F20C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 21:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80A31DD872;
	Fri, 24 Jan 2025 21:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Dt47Kj3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756731DC759
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 20:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737752401; cv=none; b=rK6hWzK3G6fG8aTrjTCr+R779PnStA83vRCYCNhowTcyO/pfFosVj+DwvIKt3BZmG/WyikipjdDcpC5cJV/48lj+U8kdYKkiuxCY1gDOjqId70IZJsgvPYU42s5rupvF+n+sShaXnpkXHOXSooE6xF5VGsUf2NtEL9UNMz9O59E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737752401; c=relaxed/simple;
	bh=ER0QaZUU6WmX29SQ2nqs6n01MfVA1ZI3IdiLYirzO1U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=laDR3XgjSdD8oUtKMisA3K09Xr65hRKieRW8ceCiYEd02zNjnZMWUefrblPWSC9kTisDBUU8NRGx7rYh2I0IdhQKdn46E1hyJTV0ClJKANslnuKiQKjHC6V62JdkxOzcZmRJQ4+4MUs2l29Pz2+gP/nusQw0UuUCjJmC5TnajWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Dt47Kj3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f550d28f7dso4958041a91.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 12:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737752398; x=1738357198; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4TqJ0Kb7y6Y6MAEdcSk44iqKoJ3E64O44AeBxUuQFhs=;
        b=3Dt47Kj3t5YqZ+VZ1ynOLY/Yyb03MKLx9kJYuldcx6ke9OgzPf3QIvjerOlBHnvQtc
         Ai5T4hyTQMEnKo7+XBVpkEQZMuNeTSNJ5BsBHvORUWld3x8KqslF6WcUci7mHefekfoM
         giYUrVmvnbEoAu6mwoBo30SOrogFSOuwXJNvvRazRW/TqMcqIT/xge6Q3VrGRitrUcHW
         U3SHHznPAD1aaWnGZYLI9nrtSU9VOJJluBX9MHDKdOBQECOLY++ksueHb9k0vlruzTm9
         3y11qckNJFEA/tAO9/Lj9q9adEfg6s/YOO/rtYCwduxEPXWHpevLMl/flTFEr2Tnmcwk
         i8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737752398; x=1738357198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4TqJ0Kb7y6Y6MAEdcSk44iqKoJ3E64O44AeBxUuQFhs=;
        b=i6+h4GOWiqKveyv95HDhqUqWtvKC3sSbSP4Q6spO/uSn+t9772KG5bRYdmwhw7NsAG
         wQYWc3lLl1e/B1ZdI+nVZhp7GRnWUP9kKpIJqWtZkacBGBIJny1P6iGQ0iz+F/h6Dx31
         9x0DftnV11L1JqjcafFb5Kg0i6K7rTs2RZhRALB29OZ5fZ3HbCcaAFc7fsZbeqfqAMVB
         KAPaW5b2YMhtu2Oe7wi19YNEEe2k82a6OVZrZqL5DiI0PJkc9BEG3hPfH5pRfLROMVmA
         o7TmHC1ypIlc2JztpbPOMwO57MG7LWnFvIrmCszfz2GFa3MkXGpuS5BaSXaKt6zhOuda
         VHRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOwedUCC7R5Hk2+E9J18H45mnlboVLlbmGrbNn649YAWwxs0vKY1M0DLcF4B2thJkA+Iw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ4xnij1ar2q+jFE1Y8VREehDcvqVx8IYzn9n/Eb3JkWsh1Yn/
	i9FujZa36AU5jkGF9LdB21Mc7TABbOK6lZiAmFfR5lpKsyRlaYvPaLVn7PxQxEN/0gff3M/CV6W
	zzw==
X-Google-Smtp-Source: AGHT+IGRx5Sq+FyKPZZbOZhw/SXysFd7xbp7ZcTgHyihLDf83RgL1VVvaV7ip4hRYCH+p9sUXwE5yrHjh/Y=
X-Received: from pfxa35.prod.google.com ([2002:a05:6a00:1d23:b0:72a:a111:742a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6088:b0:72a:a9b5:ed91
 with SMTP id d2e1a72fcca58-72daf99ed03mr42276104b3a.13.1737752397783; Fri, 24
 Jan 2025 12:59:57 -0800 (PST)
Date: Fri, 24 Jan 2025 12:59:50 -0800
In-Reply-To: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
Message-ID: <Z5P_Rj4Uc82lJBDx@google.com>
Subject: Re: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and TDX
From: Sean Christopherson <seanjc@google.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Binbin Wu <binbin.wu@intel.com>, Juergen Gross <jgross@suse.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 15, 2024, Kirill A. Shutemov wrote:
> AMD SEV-SNP and Intel TDX have limited access to MTRR: either it is not
> advertised in CPUID or it cannot be programmed (on TDX, due to #VE on
> CR0.CD clear).
> 
> This results in guests using uncached mappings where it shouldn't and
> pmd/pud_set_huge() failures due to non-uniform memory type reported by
> mtrr_type_lookup().
> 
> Override MTRR state, making it WB by default as the kernel does for
> Hyper-V guests.

In a turn of events that should have shocked no one, simply overriding the default
memtype also results in breakage.

The insanity that is ACPI relies on UC MTRR mappings to force memory that is very
obviously not RAM to use non-WB mappings.  During acpi_init(), acpi_os_map_iomem()
will attempt to map devices as WB:

  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
					      acpi_size size)
  {
       return ioremap_cache(phys, size);
  }

If acpi_init() runs before the corresponding device driver is probed, ACPI's WB
mapping will "win", and result in the driver's ioremap() failing because the
existing WB mapping isn't compatible with the requested UC-.

[    1.730459] ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
[    1.732780] tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12


Note, the '0x2' and '0x0' values refer to "enum page_cache_mode", not x86's
memtypes (which frustratingly are an almost pure inversion; 2 == WB, 0 == UC).

The above trace is from a Google-VMM based VM, but the same behavior happens with
a QEMU based VM, so unless QEMU is also building bad ACPI tables, I don't think
this is a VMM problem.

E.g. tracing mapping requests for HPET under QEMU yields

   Mapping HPET, req_type = 0
   WARNING: CPU: 5 PID: 1 at arch/x86/mm/pat/memtype.c:528 memtype_reserve+0x22f/0x3f0
   Call Trace:
    <TASK>
    __ioremap_caller.constprop.0+0xd6/0x330
    acpi_os_map_iomem+0x195/0x1b0
    acpi_ex_system_memory_space_handler+0x11c/0x2f0
    acpi_ev_address_space_dispatch+0x168/0x3b0
    acpi_ex_access_region+0xd7/0x280
    acpi_ex_field_datum_io+0x73/0x210
    acpi_ex_extract_from_field+0x267/0x2a0
    acpi_ex_read_data_from_field+0x8e/0x220
    acpi_ex_resolve_node_to_value+0xe2/0x2b0
    acpi_ds_evaluate_name_path+0xa9/0x100
    acpi_ds_exec_end_op+0x21f/0x4c0
    acpi_ps_parse_loop+0xf4/0x670
    acpi_ps_parse_aml+0x17b/0x3d0
    acpi_ps_execute_method+0x137/0x260
    acpi_ns_evaluate+0x1f0/0x2d0
    acpi_evaluate_object+0x13d/0x2e0
    acpi_evaluate_integer+0x50/0xe0
    acpi_bus_get_status+0x7b/0x140
    acpi_add_single_object+0x3f8/0x750
    acpi_bus_check_add+0xb2/0x340
    acpi_ns_walk_namespace+0xfe/0x200
    acpi_walk_namespace+0xbb/0xe0
    acpi_bus_scan+0x1b5/0x1d0
    acpi_scan_init+0xd5/0x290
    acpi_init+0x1fc/0x520
    do_one_initcall+0x41/0x1d0
    kernel_init_freeable+0x164/0x260
    kernel_init+0x16/0x1a0
    ret_from_fork+0x2d/0x50
    ret_from_fork_asm+0x11/0x20
   ---[ end trace 0000000000000000 ]---

The only reason this doesn't cause problems for HPET is because HPET gets special
treatment via x86_init.timers.timer_init(), and so gets a chance to creat its UC-
mapping before acpi_init() clobbers things.

E.g. modifying the horrid CoCo MTRR hack to apply to all VM types, and then disabling
the early call to hpet_time_init() yields the same behavior for HPET:

[    0.318264] ioremap error for 0xfed00000-0xfed01000, requested 0x2, got 0x0

---
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 7b29ebda024f..8b58024611e5 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -456,11 +456,13 @@ void mtrr_overwrite_state(struct mtrr_var_range *var, unsigned int num_var,
         * - when running as SEV-SNP or TDX guest to avoid unnecessary
         *   VMM communication/Virtualization exceptions (#VC, #VE)
         */
+#if 0
        if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) &&
            !hv_is_isolation_supported() &&
            !cpu_feature_enabled(X86_FEATURE_XENPV) &&
            !cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
                return;
+#endif
 
        /* Disable MTRR in order to disable MTRR modifications. */
        setup_clear_cpu_cap(X86_FEATURE_MTRR);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 21e9e4845354..11f08aba1b8c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -982,6 +982,8 @@ static void __init kvm_init_platform(void)
        kvmclock_init();
        x86_platform.apic_post_init = kvm_apic_init;
 
+       x86_init.timers.timer_init = x86_init_noop;
+
        /* Set WB as the default cache mode for SEV-SNP and TDX */
        mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
 }
---

This is all honestly beyond ridiculous.  As of commit 0a7b73559b39 ("KVM: x86:
Remove VMX support for virtualizing guest MTRR memtypes"), MTRRs are never
virtualized under KVM, i.e. the memtype in the MTRR has *zero* impact on the
effective memtype.  And even before that commit, KVM only virtualized MTRRs for
VMs running on Intel hosts with passthrough non-coherent DMA devices.

Even worse, the regions that are typically covered by the default MTRR are either
host MMIO or emulated MMIO.  For host MMIO, KVM darn well needs to ensure that
memory is UC.  And for emulated MMIO, even if KVM did virtualize MTRRs, there
would *still* be zero impact on the effective memtype.

In other words, irrespective of SNP and TDX, programming the MTRRs under KVM
does nothing more than give the kernel warm fuzzies.  But the _software_ tracking
of what the kernel thinks are the requisite memtypes obviously matters.

As a stopgap, rather than carry this CoCo hack, what if we add a synthetic feature
flag that says it's ok to modify MTRRs without disabling caching?  I think that'll
make TDX happy, and should avoid a long game of whack-a-mole.  Then longterm,
figure out a clean way to eliminate accessing the "real" MTRRs entirely.

This is safe even under older KVM, because KVM obviously isn't writing the real
MTRRs, and KVM invalidates all affected EPT entries (where KVM shoves the guest's
desired memtype) on an MTRR update.  If that's a concern we could do this only
for "special" guests, and/or add a PV CPUID flag to KVM to announce that MTRRs
are only emulated.

E.g.

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 645aa360628d..b5699eeaef5d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -236,6 +236,7 @@
 #define X86_FEATURE_PVUNLOCK           ( 8*32+20) /* PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT                ( 8*32+21) /* PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST          ( 8*32+22) /* "tdx_guest" Intel Trust Domain Extensions Guest */
+#define X86_FEATURE_EMULATED_MTRRS     ( 8*32+22) /* MTRRs are emulated and can be modified while caching is enabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE           ( 9*32+ 0) /* "fsgsbase" RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index e6fa03ed9172..c668032d1dc1 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -1053,6 +1053,9 @@ void cache_disable(void) __acquires(cache_disable_lock)
 {
        unsigned long cr0;
 
+       if (cpu_feature_enabled(X86_FEATURE_EMULATED_MTRRS))
+               return;
+
        /*
         * Note that this is not ideal
         * since the cache is only flushed/disabled for this CPU while the
@@ -1095,6 +1098,9 @@ void cache_disable(void) __acquires(cache_disable_lock)
 
 void cache_enable(void) __releases(cache_disable_lock)
 {
+       if (cpu_feature_enabled(X86_FEATURE_EMULATED_MTRRS))
+               return;
+
        /* Flush TLBs (no need to flush caches - they are disabled) */
        count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
        flush_tlb_local();
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 21e9e4845354..6266b132e359 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -982,8 +982,7 @@ static void __init kvm_init_platform(void)
        kvmclock_init();
        x86_platform.apic_post_init = kvm_apic_init;
 
-       /* Set WB as the default cache mode for SEV-SNP and TDX */
-       mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
+       setup_force_cpu_cap(X86_FEATURE_EMULATED_MTRRS);
 }
 
 #if defined(CONFIG_AMD_MEM_ENCRYPT)

