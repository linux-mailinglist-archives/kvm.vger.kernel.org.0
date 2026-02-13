Return-Path: <kvm+bounces-71036-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIiSG4rVjmlFFQEAu9opvQ
	(envelope-from <kvm+bounces-71036-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 08:40:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF638133A94
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 08:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5E793079BB5
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 07:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA7C2F5321;
	Fri, 13 Feb 2026 07:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="x+19I65Q"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob01.noc.sony.co.jp (jpms-ob01.noc.sony.co.jp [211.125.140.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578983043A4;
	Fri, 13 Feb 2026 07:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770968413; cv=none; b=uUbAzFaWnbg1ErPRb7KIIpJkq1/Uq0hVtm4TPfG6jx/OL9SCg2MCq+q5c8VpavEPG1MRxwsZPqm4U1PI1a1ukSqGiQvAMP9fXllmyHsVcJVi/hXrNxrWjchcG+xX78eenauAsLi1nxK6T59DpLdeKH32TZ2FccElGGkoVmWYzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770968413; c=relaxed/simple;
	bh=fE+S91KknX0BLbc1Itp/YHqez4OEwJVurApYsMOHRl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jloHgfYE60nsVgj9mhP/eUmm1D6h56SL3RbBrVY471tvCNCXTArw0hGnXpomkUqXTi+cu+dnaY+J4aHCFDUzA+GsvWy9bAuCl+wUn6mLTgpR6MUvpbtiEXwKnz3YB6BH/in0WINxDC8P5uqFVfZGhsa5QQD8m+KDUBzRk10gW5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=x+19I65Q; arc=none smtp.client-ip=211.125.140.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770968412; x=1802504412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pzfx5lLFbK5d4r8P3rsCdaD/raTj07tQWAB1fg3LiRQ=;
  b=x+19I65QfPL1rgmZARBwzcBjaOMW+khsK1m3SCo45MpPGrgNWJc9yS4C
   qmz6JQoawLo+hbccGC9yYoX/JYSnbOzdnV98SnWO2VVjN5KTelv06w/je
   rh6G86jwfFj1pjMY/6qKf3sCqMjuvshvNoSJG4gCP//P2NdYxBZ5fv1k3
   wt+e3MC3OOtg+P3u2908PLwFU+U7hsCfvyd4RskT7YAtGeRjwnERRj+2i
   RLzlkg6zeIcr7BEBBHg4O2vHvUFVsIJ2EoCBKNwu3tk2WSJq8L0Jb4If5
   pRFCATLu9kttiI7iP9VBXzO6G5djn1jx8Rov5ulVGY96eTIxa3s4/wnxF
   g==;
Received: from unknown (HELO jpmta-ob02.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::7])
  by jpms-ob01.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 16:40:04 +0900
X-IronPort-AV: E=Sophos;i="6.21,288,1763391600"; 
   d="scan'208";a="581327796"
Received: from unknown (HELO JPC00244420) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 16:40:03 +0900
Date: Fri, 13 Feb 2026 16:39:59 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>, Sohil Mehta <sohil.mehta@intel.com>
Subject: Re: [PATCH 3/3] x86/virt: rename x2apic_available to
 x2apic_without_ir_available
Message-ID: <aY7VTwfJDREcrwJy@JPC00244420>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-3-71c8f488a88b@sony.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202-x2apic-fix-v1-3-71c8f488a88b@sony.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71036-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[sony.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sony.com:email,sony.com:dkim]
X-Rspamd-Queue-Id: BF638133A94
X-Rspamd-Action: no action

Hi x86 and virt folks,

I'd like some feedback on this patch. I realise that just updating the
name to x2apic_without_ir_available() with no indication in the code
suggesting that the hypervisor implementations may not be answering the
question "is x2apic availalble without IR?" is bad.

I suppose the options are:

1. Check seven hypervisor's x2apic_available() implementation to see if
the "x2apic_without_ir_available" semantic matches, and then do the
renaming

	Problem is, I don't know enough about the hypervisors to check
	the implementations. Some help from the virt folks would be
	great!

2. Add TODOs on the hypervisor implementations, hoping they'll be
audited in the future

	There's a chance the TODOs will just sit there rotting. It's
	ugly, even I don't like it

So how do we proceed?

On Mon, Feb 02, 2026 at 06:51:04PM +0900, Shashank Balaji wrote:
> No functional change.
> 
> x86_init.hyper.x2apic_available is used only in try_to_enable_x2apic to check if
> x2apic needs to be disabled if interrupt remapping support isn't present. But
> the name x2apic_available doesn't reflect that usage.
> 
> This is what x2apic_available is set to for various hypervisors:
> 
> 	acrn		boot_cpu_has(X86_FEATURE_X2APIC)
> 	mshyperv	boot_cpu_has(X86_FEATURE_X2APIC)
> 	xen		boot_cpu_has(X86_FEATURE_X2APIC) or false
> 	vmware		vmware_legacy_x2apic_available
> 	kvm		kvm_cpuid_base() != 0
> 	jailhouse	x2apic_enabled()
> 	bhyve		true
> 	default		false
> 
> Bare metal and vmware correctly check if x2apic is available without interrupt
> remapping. The rest of them check if x2apic is enabled/supported, and kvm just
> checks if the kernel is running on kvm. The other hypervisors may have to have
> their checks audited.
> 
> Also fix the backwards pr_info message printed on disabling x2apic because of
> lack of irq remapping support.
> 
> Compile tested with all the hypervisor guest support enabled.
> 
> Co-developed-by: Rahul Bukte <rahul.bukte@sony.com>
> Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
> Signed-off-by: Shashank Balaji <shashank.mahadasyam@sony.com>
> ---
>  arch/x86/include/asm/x86_init.h |  4 ++--
>  arch/x86/kernel/apic/apic.c     |  4 ++--
>  arch/x86/kernel/cpu/acrn.c      |  2 +-
>  arch/x86/kernel/cpu/bhyve.c     |  2 +-
>  arch/x86/kernel/cpu/mshyperv.c  |  2 +-
>  arch/x86/kernel/cpu/vmware.c    |  2 +-
>  arch/x86/kernel/jailhouse.c     |  2 +-
>  arch/x86/kernel/kvm.c           |  2 +-
>  arch/x86/kernel/x86_init.c      | 12 ++++++------
>  arch/x86/xen/enlighten_hvm.c    |  4 ++--
>  10 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 6c8a6ead84f6..b270d9eed755 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -116,7 +116,7 @@ struct x86_init_pci {
>   * struct x86_hyper_init - x86 hypervisor init functions
>   * @init_platform:		platform setup
>   * @guest_late_init:		guest late init
> - * @x2apic_available:		X2APIC detection
> + * @x2apic_without_ir_available: is x2apic available without irq remap?
>   * @msi_ext_dest_id:		MSI supports 15-bit APIC IDs
>   * @init_mem_mapping:		setup early mappings during init_mem_mapping()
>   * @init_after_bootmem:		guest init after boot allocator is finished
> @@ -124,7 +124,7 @@ struct x86_init_pci {
>  struct x86_hyper_init {
>  	void (*init_platform)(void);
>  	void (*guest_late_init)(void);
> -	bool (*x2apic_available)(void);
> +	bool (*x2apic_without_ir_available)(void);
>  	bool (*msi_ext_dest_id)(void);
>  	void (*init_mem_mapping)(void);
>  	void (*init_after_bootmem)(void);
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index cc64d61f82cf..8820b631f8a2 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1836,8 +1836,8 @@ static __init void try_to_enable_x2apic(int remap_mode)
>  		 * Using X2APIC without IR is not architecturally supported
>  		 * on bare metal but may be supported in guests.
>  		 */
> -		if (!x86_init.hyper.x2apic_available()) {
> -			pr_info("x2apic: IRQ remapping doesn't support X2APIC mode\n");
> +		if (!x86_init.hyper.x2apic_without_ir_available()) {
> +			pr_info("x2apic: Not supported without IRQ remapping\n");
>  			x2apic_disable();
>  			return;
>  		}
> diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
> index 2c5b51aad91a..9204b98d4786 100644
> --- a/arch/x86/kernel/cpu/acrn.c
> +++ b/arch/x86/kernel/cpu/acrn.c
> @@ -77,5 +77,5 @@ const __initconst struct hypervisor_x86 x86_hyper_acrn = {
>  	.detect                 = acrn_detect,
>  	.type			= X86_HYPER_ACRN,
>  	.init.init_platform     = acrn_init_platform,
> -	.init.x2apic_available  = acrn_x2apic_available,
> +	.init.x2apic_without_ir_available = acrn_x2apic_available,
>  };
> diff --git a/arch/x86/kernel/cpu/bhyve.c b/arch/x86/kernel/cpu/bhyve.c
> index f1a8ca3dd1ed..91a90a7459ce 100644
> --- a/arch/x86/kernel/cpu/bhyve.c
> +++ b/arch/x86/kernel/cpu/bhyve.c
> @@ -61,6 +61,6 @@ const struct hypervisor_x86 x86_hyper_bhyve __refconst = {
>  	.name			= "Bhyve",
>  	.detect			= bhyve_detect,
>  	.init.init_platform	= x86_init_noop,
> -	.init.x2apic_available	= bhyve_x2apic_available,
> +	.init.x2apic_without_ir_available = bhyve_x2apic_available,
>  	.init.msi_ext_dest_id	= bhyve_ext_dest_id,
>  };
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 579fb2c64cfd..61458855094a 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -760,7 +760,7 @@ const __initconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
>  	.name			= "Microsoft Hyper-V",
>  	.detect			= ms_hyperv_platform,
>  	.type			= X86_HYPER_MS_HYPERV,
> -	.init.x2apic_available	= ms_hyperv_x2apic_available,
> +	.init.x2apic_without_ir_available = ms_hyperv_x2apic_available,
>  	.init.msi_ext_dest_id	= ms_hyperv_msi_ext_dest_id,
>  	.init.init_platform	= ms_hyperv_init_platform,
>  	.init.guest_late_init	= ms_hyperv_late_init,
> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> index cb3f900c46fc..46d325818797 100644
> --- a/arch/x86/kernel/cpu/vmware.c
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -585,7 +585,7 @@ const __initconst struct hypervisor_x86 x86_hyper_vmware = {
>  	.detect				= vmware_platform,
>  	.type				= X86_HYPER_VMWARE,
>  	.init.init_platform		= vmware_platform_setup,
> -	.init.x2apic_available		= vmware_legacy_x2apic_available,
> +	.init.x2apic_without_ir_available = vmware_legacy_x2apic_available,
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  	.runtime.sev_es_hcall_prepare	= vmware_sev_es_hcall_prepare,
>  	.runtime.sev_es_hcall_finish	= vmware_sev_es_hcall_finish,
> diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
> index 9e9a591a5fec..84a0bbe15989 100644
> --- a/arch/x86/kernel/jailhouse.c
> +++ b/arch/x86/kernel/jailhouse.c
> @@ -291,6 +291,6 @@ const struct hypervisor_x86 x86_hyper_jailhouse __refconst = {
>  	.name			= "Jailhouse",
>  	.detect			= jailhouse_detect,
>  	.init.init_platform	= jailhouse_init_platform,
> -	.init.x2apic_available	= jailhouse_x2apic_available,
> +	.init.x2apic_without_ir_available = jailhouse_x2apic_available,
>  	.ignore_nopv		= true,
>  };
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 37dc8465e0f5..709eba87d58e 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1042,7 +1042,7 @@ const __initconst struct hypervisor_x86 x86_hyper_kvm = {
>  	.detect				= kvm_detect,
>  	.type				= X86_HYPER_KVM,
>  	.init.guest_late_init		= kvm_guest_init,
> -	.init.x2apic_available		= kvm_para_available,
> +	.init.x2apic_without_ir_available = kvm_para_available,
>  	.init.msi_ext_dest_id		= kvm_msi_ext_dest_id,
>  	.init.init_platform		= kvm_init_platform,
>  #if defined(CONFIG_AMD_MEM_ENCRYPT)
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index ebefb77c37bb..9ddf8c901ac6 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -112,12 +112,12 @@ struct x86_init_ops x86_init __initdata = {
>  	},
>  
>  	.hyper = {
> -		.init_platform		= x86_init_noop,
> -		.guest_late_init	= x86_init_noop,
> -		.x2apic_available	= bool_x86_init_noop,
> -		.msi_ext_dest_id	= bool_x86_init_noop,
> -		.init_mem_mapping	= x86_init_noop,
> -		.init_after_bootmem	= x86_init_noop,
> +		.init_platform			= x86_init_noop,
> +		.guest_late_init		= x86_init_noop,
> +		.x2apic_without_ir_available	= bool_x86_init_noop,
> +		.msi_ext_dest_id		= bool_x86_init_noop,
> +		.init_mem_mapping		= x86_init_noop,
> +		.init_after_bootmem		= x86_init_noop,
>  	},
>  
>  	.acpi = {
> diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
> index fe57ff85d004..42f3d21f313d 100644
> --- a/arch/x86/xen/enlighten_hvm.c
> +++ b/arch/x86/xen/enlighten_hvm.c
> @@ -311,7 +311,7 @@ static uint32_t __init xen_platform_hvm(void)
>  		 * detect PVH and panic there.
>  		 */
>  		h->init_platform = x86_init_noop;
> -		h->x2apic_available = bool_x86_init_noop;
> +		h->x2apic_without_ir_available = bool_x86_init_noop;
>  		h->init_mem_mapping = x86_init_noop;
>  		h->init_after_bootmem = x86_init_noop;
>  		h->guest_late_init = xen_hvm_guest_late_init;
> @@ -325,7 +325,7 @@ struct hypervisor_x86 x86_hyper_xen_hvm __initdata = {
>  	.detect                 = xen_platform_hvm,
>  	.type			= X86_HYPER_XEN_HVM,
>  	.init.init_platform     = xen_hvm_guest_init,
> -	.init.x2apic_available  = xen_x2apic_available,
> +	.init.x2apic_without_ir_available = xen_x2apic_available,
>  	.init.init_mem_mapping	= xen_hvm_init_mem_mapping,
>  	.init.guest_late_init	= xen_hvm_guest_late_init,
>  	.init.msi_ext_dest_id   = msi_ext_dest_id,
> 
> -- 
> 2.43.0
> 

