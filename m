Return-Path: <kvm+bounces-56011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6123B39148
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 03:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9129F980F1B
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 01:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C54A23B615;
	Thu, 28 Aug 2025 01:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/1chyoU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D950214A64;
	Thu, 28 Aug 2025 01:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756346025; cv=none; b=GNhbeNTD958/IRN+UIT12rbTeD+q9O72wbsfveTwPgxdwCIMhWX1P+zx0XnXJISdpRajW+0gEX3GPoBSFrYidmWx6zfAyteQHU6XM4snt/F7EX9M+8DwjHmfy+FA/zqZX9b8IWyNB8vACWqmGvs8RUlRLDEMmf7ayd8V7zgrbPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756346025; c=relaxed/simple;
	bh=h45WNg3OjA791DZDe+W4K9Q0bEvUnsWre9J8pgZjcMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kw7ba0OyERF9Kd0jY89g+YZjNxHjwqwFDiS7fDqv3lOOM6AfJYUIQ+9VrxNMHyCVkdd4o5/lasXUxtf+AO8ofQotMdP3IHqmnTc5bVPxx4baj5V2BzYqxlgAHRY4wqQPsX85QHVaG9s6JhH9vQ735hXIS+LtVzHD072CXUL0Ifk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/1chyoU; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756346023; x=1787882023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h45WNg3OjA791DZDe+W4K9Q0bEvUnsWre9J8pgZjcMY=;
  b=R/1chyoUZYhh5HQ2lng7XRBz7Nm7ovWiZa/r03jHIe1EVOYw87aIgu+Q
   krz0ZRNRowK7mpz2eND4ACKFSuxgQQlOyOuPNlQwQ4hxWTtCbBOHgvSgx
   acDm2Fv8rA2tfxZjuPUjihevZIIXLDqmbl2kHX8RJC2qz4u/SKHJ+JdrS
   kDqTgMv2i+p0lhWT12/mDlBsDRGmS6W6mD4iXM7hmwGNzMKq3g+J0uyKr
   M4wf+S52pdD9YkNgPZ0WbP9qWB9f5aOdbm0wqbWxi+u1IXapCgIduxPkB
   mkQn5yBh6J7HxXnjtF4yIN5FSqWoO+ltKGwwWxtAxTkoVQdVqOv/zoOxb
   g==;
X-CSE-ConnectionGUID: 5a8F5/SHRo+dkkuIm41LSw==
X-CSE-MsgGUID: hGMcZMgETfyO3AEXfCaS7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58457422"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58457422"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 18:53:42 -0700
X-CSE-ConnectionGUID: 56e0gSQyQL+yUiCLGs1GCQ==
X-CSE-MsgGUID: MPo5xU5+Tf6vOkmZyBZtKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169889714"
Received: from unknown (HELO [10.238.11.127]) ([10.238.11.127])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 18:53:39 -0700
Message-ID: <28d5fb22-5b0c-4bf9-85c7-1986d9cc005b@linux.intel.com>
Date: Thu, 28 Aug 2025 09:53:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/kvm: Force legacy PCI hole to UC when overriding
 MTRRs for TDX/SNP
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Gonda <pgonda@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?=
 <jgross@suse.com>, Korakit Seemakhupt <korakit@google.com>,
 Jianxiong Gao <jxgao@google.com>, Nikolay Borisov <nik.borisov@suse.com>
References: <20250828005249.39339-1-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250828005249.39339-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/28/2025 8:52 AM, Sean Christopherson wrote:
> When running as an SNP or TDX guest under KVM, force the legacy PCI hole,
> i.e. memory between Top of Lower Usable DRAM and 4GiB, to be mapped as UC
> via a forced variable MTRR range.
>
> In most KVM-based setups, legacy devices such as the HPET and TPM are
> enumerated via ACPI.  ACPI enumeration includes a Memory32Fixed entry, and
> optionally a SystemMemory descriptor for an OperationRegion, e.g. if the
> device needs to be accessed via a Control Method.
>
> If a SystemMemory entry is present, then the kernel's ACPI driver will
> auto-ioremap the region so that it can be accessed at will.  However, the
> ACPI spec doesn't provide a way to enumerate the memory type of
> SystemMemory regions, i.e. there's no way to tell software that a region
> must be mapped as UC vs. WB, etc.  As a result, Linux's ACPI driver always
> maps SystemMemory regions using ioremap_cache(), i.e. as WB on x86.
>
> The dedicated device drivers however, e.g. the HPET driver and TPM driver,
> want to map their associated memory as UC or WC, as accessing PCI devices
> using WB is unsupported.
>
> On bare metal and non-CoCO, the conflicting requirements "work" as firmware
> configures the PCI hole (and other device memory) to be UC in the MTRRs.
> So even though the ACPI mappings request WB, they are forced to UC due to

Linux kernel forces the type as UC- in this case.

> the kernel properly handling the MTRR overrides, and thus are compatible
> with the drivers' requested WC/UC-.
>
> With force WB MTRRs on SNP and TDX guests, the ACPI mappings get their
> requested WB if the ACPI mappings are established before the dedicated
> driver code attempts to initialize the device.  E.g. if acpi_init()
> runs before the corresponding device driver is probed, ACPI's WB mapping
> will "win", and result in the driver's ioremap() failing because the
> existing WB mapping isn't compatible with the requested WC/UC-.
>
> E.g. when a TPM is emulated by the hypervisor (ignoring the security
> implications of relying on what is allegedly an untrusted entity to store
> measurements), the TPM driver will request UC and fail:
>
>    [  1.730459] ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
>    [  1.732780] tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12
>
> Note, the '0x2' and '0x0' values refer to "enum page_cache_mode", not x86's
> memtypes (which frustratingly are an almost pure inversion; 2 == WB, 0 == UC).
> E.g. tracing mapping requests for TPM TIS yields:
>
>   Mapping TPM TIS with req_type = 0
>   WARNING: CPU: 22 PID: 1 at arch/x86/mm/pat/memtype.c:530 memtype_reserve+0x2ab/0x460
>   Modules linked in:
>   CPU: 22 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.16.0-rc7+ #2 VOLUNTARY
>   Tainted: [W]=WARN
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/29/2025
>   RIP: 0010:memtype_reserve+0x2ab/0x460
>    __ioremap_caller+0x16d/0x3d0
>    ioremap_cache+0x17/0x30
>    x86_acpi_os_ioremap+0xe/0x20
>    acpi_os_map_iomem+0x1f3/0x240
>    acpi_os_map_memory+0xe/0x20
>    acpi_ex_system_memory_space_handler+0x273/0x440
>    acpi_ev_address_space_dispatch+0x176/0x4c0
>    acpi_ex_access_region+0x2ad/0x530
>    acpi_ex_field_datum_io+0xa2/0x4f0
>    acpi_ex_extract_from_field+0x296/0x3e0
>    acpi_ex_read_data_from_field+0xd1/0x460
>    acpi_ex_resolve_node_to_value+0x2ee/0x530
>    acpi_ex_resolve_to_value+0x1f2/0x540
>    acpi_ds_evaluate_name_path+0x11b/0x190
>    acpi_ds_exec_end_op+0x456/0x960
>    acpi_ps_parse_loop+0x27a/0xa50
>    acpi_ps_parse_aml+0x226/0x600
>    acpi_ps_execute_method+0x172/0x3e0
>    acpi_ns_evaluate+0x175/0x5f0
>    acpi_evaluate_object+0x213/0x490
>    acpi_evaluate_integer+0x6d/0x140
>    acpi_bus_get_status+0x93/0x150
>    acpi_add_single_object+0x43a/0x7c0
>    acpi_bus_check_add+0x149/0x3a0
>    acpi_bus_check_add_1+0x16/0x30
>    acpi_ns_walk_namespace+0x22c/0x360
>    acpi_walk_namespace+0x15c/0x170
>    acpi_bus_scan+0x1dd/0x200
>    acpi_scan_init+0xe5/0x2b0
>    acpi_init+0x264/0x5b0
>    do_one_initcall+0x5a/0x310
>    kernel_init_freeable+0x34f/0x4f0
>    kernel_init+0x1b/0x200
>    ret_from_fork+0x186/0x1b0
>    ret_from_fork_asm+0x1a/0x30
>    </TASK>
>
> The above traces are from a Google-VMM based VM, but the same behavior
> happens with a QEMU based VM that is modified to add a SystemMemory range
> for the TPM TIS address space.
>
> The only reason this doesn't cause problems for HPET, which appears to
> require a SystemMemory region, is because HPET gets special treatment via
> x86_init.timers.timer_init(), and so gets a chance to create its UC-
> mapping before acpi_init() clobbers things.  Disabling the early call to
> hpet_time_init() yields the same behavior for HPET:
>
>    [  0.318264] ioremap error for 0xfed00000-0xfed01000, requested 0x2, got 0x0
>
> Hack around the ACPI gap by forcing the legacy PCI hole to UC when
> overriding the (virtual) MTRRs for CoCo guest, so that ioremap handling
> of MTRRs naturally kicks in and forces the ACPI mappings to be UC.
>
> Note, the requested/mapped memtype doesn't actually matter in terms of
> accessing the device.  In practically every setup, legacy PCI devices are
> emulated by the hypervisor, and accesses are intercepted and handled as
> emulated MMIO, i.e. never access physical memory and thus don't have an
> effective memtype.
>
> Even in a theoretical setup where such devices are passed through by the
> host, i.e. point at real MMIO memory, it is KVM's (as the hypervisor)
> responsibility to force the memory to be WC/UC, e.g. via EPT memtype
> under TDX or real hardware MTRRs under SNP.  Not doing so cannot work,
> and the hypervisor is highly motivated to do the right thing as letting
> the guest access hardware MMIO with WB would likely result in a variety
> of fatal #MCs.
>
> In other words, forcing the range to be UC is all about coercing the
> kernel's tracking into thinking that it has established UC mappings, so
> that the ioremap code doesn't reject mappings from e.g. the TPM driver and
> thus prevent the driver from loading and the device from functioning.
>
> Note #2, relying on guest firmware to handle this scenario, e.g. by setting
> virtual MTRRs and then consuming them in Linux, is not a viable option, as
> the virtual MTRR state is managed by the untrusted hypervisor, and because
> OVMF at least has stopped programming virtual MTRRs when running as a TDX
> guest.

Not sure if it needs to mention that with this option, Linux kernel will set
CR0.CD=1 when programming MTRRs, which will trigger unexpected #VE in TDX guest.

>
> Link: https://lore.kernel.org/all/8137d98e-8825-415b-9282-1d2a115bb51a@linux.intel.com
> Fixes: 8e690b817e38 ("x86/kvm: Override default caching mode for SEV-SNP and TDX")
> Cc: stable@vger.kernel.org
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Jürgen Groß <jgross@suse.com>
> Cc: Korakit Seemakhupt <korakit@google.com>
> Cc: Jianxiong Gao <jxgao@google.com>
> Cc: Nikolay Borisov <nik.borisov@suse.com>
> Suggested-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Two nits above.

Otherwise,

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>
> v2: Force the PCI hole to be UC via synthetic variable MTRR range instead
>      of hijacking is_untracked_pat_range() (which was horrific and apparently
>      didn't work). [Binbin]
>
> v1:
>   - https://lore.kernel.org/all/20250201005048.657470-1-seanjc@google.com
>   - https://lore.kernel.org/all/CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com
>
>   arch/x86/kernel/kvm.c | 21 +++++++++++++++++++--
>   1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 8ae750cde0c6..57379698015e 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -933,6 +933,19 @@ static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
>   
>   static void __init kvm_init_platform(void)
>   {
> +	u64 tolud = PFN_PHYS(e820__end_of_low_ram_pfn());
> +	/*
> +	 * Note, hardware requires variable MTRR ranges to be power-of-2 sized
> +	 * and naturally aligned.  But when forcing guest MTRR state, Linux
> +	 * doesn't program the forced ranges into hardware.  Don't bother doing
> +	 * the math to generate a technically-legal range.
> +	 */
> +	struct mtrr_var_range pci_hole = {
> +		.base_lo = tolud | X86_MEMTYPE_UC,
> +		.mask_lo = (u32)(~(SZ_4G - tolud - 1)) | MTRR_PHYSMASK_V,
> +		.mask_hi = (BIT_ULL(boot_cpu_data.x86_phys_bits) - 1) >> 32,
> +	};
> +
>   	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
>   	    kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
>   		unsigned long nr_pages;
> @@ -982,8 +995,12 @@ static void __init kvm_init_platform(void)
>   	kvmclock_init();
>   	x86_platform.apic_post_init = kvm_apic_init;
>   
> -	/* Set WB as the default cache mode for SEV-SNP and TDX */
> -	guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
> +	/*
> +	 * Set WB as the default cache mode for SEV-SNP and TDX, with a single
> +	 * UC range for the legacy PCI hole, e.g. so that devices that expect
> +	 * to get UC/WC mappings don't get surprised with WB.
> +	 */
> +	guest_force_mtrr_state(&pci_hole, 1, MTRR_TYPE_WRBACK);
>   }
>   
>   #if defined(CONFIG_AMD_MEM_ENCRYPT)
>
> base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00


