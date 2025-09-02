Return-Path: <kvm+bounces-56633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F00B40EA2
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E520E1B27E1A
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 20:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852C42E7F03;
	Tue,  2 Sep 2025 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SFx89Re6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0D63570AB
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756845764; cv=none; b=KCFpBVAwOZkfGAyYFf1ux8hRRzR3qGWP7dJU55kVQeHmhWy6H5yXRkQa6AXSl8VDUhKJM5jUo3Hhr1aVeBU7U2ukuxcWCc7MRXX4JjuM4G+bRGFLUH00xJg5L1IkjZWzP/GKtKhMQvW47/2z04V+WKaf1JSWwrykvX3VU78nO8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756845764; c=relaxed/simple;
	bh=x82Jw5wqFwf5tgn9E6Lepo4K03vc9exu43JGH/ms4I8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qxOHIESn+ttpX+qtBKoFmi+nI7j8v4TrjgcQ/f0xGA14nJaU/U210X5Z3S5t1I1XH+3P1Sv8D1LZMBonbtA5xMTzQt/jmJBNKIKpIKdcvhCyiY/s5LHWgP6LbjuHkqIj0EGJX/Ce2+8IpVx6RrFV3rqqRDRC2O/34ViKYpYlMjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--korakit.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SFx89Re6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--korakit.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24a9cc916baso25843795ad.2
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 13:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756845762; x=1757450562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=508Km/FkLLuCZMDYH1L2ZlW0Xfn9AuS1nhNltR/nWGQ=;
        b=SFx89Re6Q4jAiB3ZxO7YtKuYhxhgNIy2VYVPANZlbTulUqXZ16FH4+RyaUHX9dzLq/
         sQ/IT2uZIUUv1qCmIE8Mx8fOKbK8z3zOlpHppyCPj7KCqGWZvYAcyCQLdjJ39P95Wawi
         c8cqm7Gdgg1wUKGmdX81lMvVxwZhHPhKom9A8XNErNox90o5MUOGteDmWW4p0tKjGqQZ
         ffB2YyicQ/hisAYOdJsAfeZkblGhNaqe8mH9/5x0tMwwidizzs4cFme1OCKpfvL5KVw+
         FOk4pqMVYh7O9GEiX2QRzqNY16xU4vbzRs5NcoVfwII97EgClWSyyqeCXSglrWJZ2EzI
         Hqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756845762; x=1757450562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=508Km/FkLLuCZMDYH1L2ZlW0Xfn9AuS1nhNltR/nWGQ=;
        b=NVdCBY6w3/yszKHFIcj2i90udtGKkavlUmahjKKhdSXfn1jLAoGZEfjobZUs1sNKfq
         A680GQI+7N6bwU+HX50MitNCytwt10mpOuNIUQRQJSYme/bSS1cvoE8iNWx3MnpUenJo
         RCfqxOVO8LkfsBUpkJNiFbtzRBA0FbWKFT3Zxoit4l7EzEZx6iWS9WLgqSQPkdPzxvnO
         W0FrT1iaM1nF38+hZq7x/UbTIzMjvZ0CeIds2pQYgpFZRw5SMAg4A6Iina7F2mBuUfmo
         r8JdqROrSTu19Vx64RoebOJCuD9Z2g/uPjROxsF0j+kVgR4SbuWnVB5p3dLFd/dRduq8
         5qhw==
X-Forwarded-Encrypted: i=1; AJvYcCV4QpFGekn8cLMQWZzwVo4BlVyqunXQuvSK+9HeqMUfzUzlT6zhAq/VeeNtmt7fqEQqrmg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU+xlrsOHTG3tqGt5Gu+BKD0V0xf1NWom5gu34RFjmgsv2rW6z
	3PkLAMzGLT9Qx4BGUkOU7E5sgYZoRXhIkkn+Ul7Nwjj5opEaxf5UG6cKCwkKdvuKN1kdVigH+9K
	xROv3iTIcVA==
X-Google-Smtp-Source: AGHT+IHAiuP5Or72P4/+Vo+k5apo86uHPOLPfJOosMxeTrNNS8y3B4Gsc1FNpnkCXFHkd5/DcBnbZukmGKDX
X-Received: from pgab186.prod.google.com ([2002:a63:34c3:0:b0:b4c:73df:adff])
 (user=korakit job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41cd:b0:249:306a:edd0
 with SMTP id d9443c01a7336-24944b03328mr156215935ad.53.1756845762039; Tue, 02
 Sep 2025 13:42:42 -0700 (PDT)
Date: Tue,  2 Sep 2025 20:40:09 +0000
In-Reply-To: <20250828005249.39339-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250828005249.39339-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250902204009.221913-1-korakit@google.com>
Subject: Re: [PATCH v2] x86/kvm: Force legacy PCI hole to UC when overriding
 MTRRs for TDX/SNP
From: Korakit Seemakhupt <korakit@google.com>
To: seanjc@google.com
Cc: binbin.wu@linux.intel.com, jgross@suse.com, jxgao@google.com, 
	korakit@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nik.borisov@suse.com, pbonzini@redhat.com, pgonda@google.com, 
	thomas.lendacky@amd.com, vkuznets@redhat.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"

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
>
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

Tested on Google's VMM. The TPM driver successfully ioremap to UC with the patch.

Tested-by: Korakit Seemakhupt <korakit@google.com>


