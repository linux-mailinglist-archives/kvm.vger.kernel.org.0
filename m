Return-Path: <kvm+bounces-11715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 477B787A300
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 07:42:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDBA1282A1A
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 06:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7821428A;
	Wed, 13 Mar 2024 06:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ieyn2GPh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B106012E76
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 06:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710312148; cv=none; b=q/NGOnRjgYn0kwRM1ngYSWle+uJoHT+CggKZrjawlkwpriamPeUfP02p2ow9qGmWZm+Ewr7toQp0PatBYfvl/Vu+eB62pfk6avEf/WjN8Z4IU1gpohgKHEW5FwtaadWqQnNJSW3mrqIV9/pp/l/qQLS0lQVV6Pb9+AnPGje0Z2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710312148; c=relaxed/simple;
	bh=ZBE+YJupWeH0/Kewj5YOOn1eqy+YbjLU/TgIWDjKO4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LHNqVZAyiEPzlXt9wvQlBdAOLqJJoy9tnoXR2tMI38J0S+n4NSTgkq4XHPZ+J/t/x6TWs6Hbd/kw/p2eCoFy99B8EBUiEft2XUepKGepG62RlQCM3dD0w0iYLTGefhzdvdaYzu7NiL++00wqNG+2e0c1chQmjCYmawYsx2kaLYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ieyn2GPh; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710312147; x=1741848147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZBE+YJupWeH0/Kewj5YOOn1eqy+YbjLU/TgIWDjKO4c=;
  b=ieyn2GPhaz5vS1JcvIQduvpxaYjnwBVhgOgSo46ESXVTVta7Ak4iUp6t
   xNtf+UeuJCQsv60RqEzZYOL0QejSbvi+zG3TE6CvO5Rpj+Bx151qdX1MD
   XfycFFDgcFPAahOkeOh668zmunC7YcW4ZP+jum9Oaphkut114IPNDQkhf
   gSYb9wmTerkVON0Zvje09VtCWFVHxTmwgABjSlzvf+Tb3NDtxSyYOs7oV
   nCLD7PzTKadpwXLkBGXWXmddlXLrsE7TFrR3da3qRkPhInKB0TW9bXiTA
   7+fQTVpzhXiTbkDBcnZgvG1StbZUqV5hAPzTUmq8RLBO0tzNfs3k0j4PF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="8876151"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="8876151"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 23:42:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="16461521"
Received: from linux.bj.intel.com ([10.238.157.71])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 23:42:25 -0700
Date: Wed, 13 Mar 2024 14:39:32 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kvm: add support for guest physical bits
Message-ID: <ZfFKJPYoE5bacb6+@linux.bj.intel.com>
References: <20240305105233.617131-1-kraxel@redhat.com>
 <20240305105233.617131-3-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305105233.617131-3-kraxel@redhat.com>

On Tue, Mar 05, 2024 at 11:52:33AM +0100, Gerd Hoffmann wrote:
> Query kvm for supported guest physical address bits, in cpuid
> function 80000008, eax[23:16].  Usually this is identical to host
> physical address bits.  With NPT or EPT being used this might be
> restricted to 48 (max 4-level paging address space size) even if
> the host cpu supports more physical address bits.
> 
> When set pass this to the guest, using cpuid too.  Guest firmware
> can use this to figure how big the usable guest physical address
> space is, so PCI bar mapping are actually reachable.

If this patch is applied, do you have plans to implement it in
OVMF/Seabios?

Thanks,
Tao

> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  target/i386/cpu.h     |  1 +
>  target/i386/cpu.c     |  1 +
>  target/i386/kvm/kvm.c | 17 +++++++++++++++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 952174bb6f52..d427218827f6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2026,6 +2026,7 @@ struct ArchCPU {
>  
>      /* Number of physical address bits supported */
>      uint32_t phys_bits;
> +    uint32_t guest_phys_bits;
>  
>      /* in order to simplify APIC support, we leave this pointer to the
>         user */
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 2666ef380891..1a6cfc75951e 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
>              /* 64 bit processor */
>               *eax |= (cpu_x86_virtual_addr_width(env) << 8);
> +             *eax |= (cpu->guest_phys_bits << 16);
>          }
>          *ebx = env->features[FEAT_8000_0008_EBX];
>          if (cs->nr_cores * cs->nr_threads > 1) {
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 7298822cb511..ce22dfcaa661 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -238,6 +238,15 @@ static int kvm_get_tsc(CPUState *cs)
>      return 0;
>  }
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
>  static inline void do_kvm_synchronize_tsc(CPUState *cpu, run_on_cpu_data arg)
>  {
>      kvm_get_tsc(cpu);
> @@ -1730,6 +1739,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      X86CPU *cpu = X86_CPU(cs);
>      CPUX86State *env = &cpu->env;
>      uint32_t limit, i, j, cpuid_i;
> +    uint32_t guest_phys_bits;
>      uint32_t unused;
>      struct kvm_cpuid_entry2 *c;
>      uint32_t signature[3];
> @@ -1765,6 +1775,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>  
>      env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
>  
> +    guest_phys_bits = kvm_get_guest_phys_bits(cs->kvm_state);
> +    if (guest_phys_bits &&
> +        (cpu->guest_phys_bits == 0 ||
> +         cpu->guest_phys_bits > guest_phys_bits)) {
> +        cpu->guest_phys_bits = guest_phys_bits;
> +    }
> +
>      /*
>       * kvm_hyperv_expand_features() is called here for the second time in case
>       * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle
> -- 
> 2.44.0
> 
> 

