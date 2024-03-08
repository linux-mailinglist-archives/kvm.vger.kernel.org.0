Return-Path: <kvm+bounces-11352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4999D875DD4
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 06:47:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE5F11F21D0F
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 05:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6343433CC4;
	Fri,  8 Mar 2024 05:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h5e/Bd1+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982512D043
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 05:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709876858; cv=none; b=Do5rjhvxKogz2eFG9nD5NGvsSRbJrG5qhIttOrVF2mheBoh+o00lY4ecre189SuDsYFd+9MUptsGTvZ63rCFYrNPolvzvn8A8rFSnrWewN8hitfd9v6waJm9TH0euOF9x0oxuauld/netCRx1dwJloPaNhbyoYIwBXSs5sF/6ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709876858; c=relaxed/simple;
	bh=+QdToqycjCmAwHEr8FWm+TPwEiTZ7Ic9KnKQHw4IXYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NbszidVbLfiKgmptk90ww3M+5TW5EPp/9qvms/2a5F1xHCPFFqQysDBGJ5DIF1vaDpVM2HzNaW2S6YB8ZWoeHYPOJP36uZwl9SomEiLTvxf4XFGH/Aezo82ZdTB88Qb+e+DwIyWvW6ygkhJBunbcgQ9KwWJOxknKnTICVZKqZHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h5e/Bd1+; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709876857; x=1741412857;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+QdToqycjCmAwHEr8FWm+TPwEiTZ7Ic9KnKQHw4IXYM=;
  b=h5e/Bd1+/FrOJfC3XEMsfS+N9xI21UAxfb5lYaT/hlX+rDi0KqD+wSgD
   sVetmOPUYk/pG5wQaSIlHkkTqJVVzNVhiKxPGESeu9kB5MZ24dZrtmMgR
   H7SN+WTE7IKPOwVRk5Z+IT3wiqyVyaLLpiGmqsivMpFnwWGXtkLIadiPw
   wFw0re2GZET4K3u1tYXM7enQDrAJ5M1uAubpXS/rNpKIVzXNhIsmn1jWn
   IYWUqnW5CTZ5ibhyUCo3PeirX2NiUE39MaoDQ5Jkf7pZBrGZv5BE7ZK+G
   wVaL4yNlRF8IWx8rcTxb1LgiE0wpNwowsyk09tal5EloOkzDMc7z0GsK+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4443035"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4443035"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 21:47:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="14856056"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 21:47:34 -0800
Message-ID: <7b179554-c002-40da-943d-8dd98cf10bde@intel.com>
Date: Fri, 8 Mar 2024 13:47:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] kvm: add support for guest physical bits
Content-Language: en-US
To: Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org
References: <20240305105233.617131-1-kraxel@redhat.com>
 <20240305105233.617131-3-kraxel@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240305105233.617131-3-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/2024 6:52 PM, Gerd Hoffmann wrote:
> Query kvm for supported guest physical address bits, in cpuid
> function 80000008, eax[23:16].  Usually this is identical to host
> physical address bits.  With NPT or EPT being used this might be
> restricted to 48 (max 4-level paging address space size) even if
> the host cpu supports more physical address bits.
> 
> When set pass this to the guest, using cpuid too.  Guest firmware
> can use this to figure how big the usable guest physical address
> space is, so PCI bar mapping are actually reachable.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>   target/i386/cpu.h     |  1 +
>   target/i386/cpu.c     |  1 +
>   target/i386/kvm/kvm.c | 17 +++++++++++++++++
>   3 files changed, 19 insertions(+)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 952174bb6f52..d427218827f6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2026,6 +2026,7 @@ struct ArchCPU {
>   
>       /* Number of physical address bits supported */
>       uint32_t phys_bits;
> +    uint32_t guest_phys_bits;
>   
>       /* in order to simplify APIC support, we leave this pointer to the
>          user */
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 2666ef380891..1a6cfc75951e 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
>               /* 64 bit processor */
>                *eax |= (cpu_x86_virtual_addr_width(env) << 8);
> +             *eax |= (cpu->guest_phys_bits << 16);
>           }
>           *ebx = env->features[FEAT_8000_0008_EBX];
>           if (cs->nr_cores * cs->nr_threads > 1) {
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 7298822cb511..ce22dfcaa661 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -238,6 +238,15 @@ static int kvm_get_tsc(CPUState *cs)
>       return 0;
>   }
>   
> +/* return cpuid fn 8000_0008 eax[23:16] aka GuestPhysBits */
> +static int kvm_get_guest_phys_bits(KVMState *s)
> +{
> +    uint32_t eax;
> +
> +    eax = kvm_arch_get_supported_cpuid(s, 0x80000008, 0, R_EAX);
> +    return (eax >> 16) & 0xff;
> +}
> +
>   static inline void do_kvm_synchronize_tsc(CPUState *cpu, run_on_cpu_data arg)
>   {
>       kvm_get_tsc(cpu);
> @@ -1730,6 +1739,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       X86CPU *cpu = X86_CPU(cs);
>       CPUX86State *env = &cpu->env;
>       uint32_t limit, i, j, cpuid_i;
> +    uint32_t guest_phys_bits;
>       uint32_t unused;
>       struct kvm_cpuid_entry2 *c;
>       uint32_t signature[3];
> @@ -1765,6 +1775,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>   
>       env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
>   
> +    guest_phys_bits = kvm_get_guest_phys_bits(cs->kvm_state);
> +    if (guest_phys_bits &&
> +        (cpu->guest_phys_bits == 0 ||
> +         cpu->guest_phys_bits > guest_phys_bits)) {
> +        cpu->guest_phys_bits = guest_phys_bits;
> +    }

suggest to move this added code block to kvm_cpu_realizefn().

Main code in kvm_arch_init_vcpu() is to consume the data in cpu or 
env->features to configure KVM specific configuration via KVM ioctls.

The preparation work of initializing the required data usually not 
happen in kvm_arch_init_vcpu();

>       /*
>        * kvm_hyperv_expand_features() is called here for the second time in case
>        * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle


