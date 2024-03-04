Return-Path: <kvm+bounces-10743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF1D386F855
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 02:54:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ACD8B20EB9
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 01:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C60138A;
	Mon,  4 Mar 2024 01:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZUEBAM8X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E023A31
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 01:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709517287; cv=none; b=nlCU20bCCMsnO3rWzsYZsbGXOffJB77znPud6537VM9lVYh30RmLgeH5owfXlZw+hf7V3b/7BBerb1SJxM2Yko1Zh4sBx2iPSUKmgWlUdjYA8GaWkx0o7MMXYL11/obdLTkDUInonZNdbe0hC237Jw9BnDABpna/uzOHKO76h2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709517287; c=relaxed/simple;
	bh=VaVZc+NmH05m44vaFq+I+v7FffyptzHfgc+PQIJqWAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qAgS7ov5nfCmakHncm2cT4I6xNineif+YMUg0FdDu6HL3LGdPgUf7sFo6GHqWNqoLIvRahdU964D9t3Q71NH/AEDqtbk99g+FbwVbq5seeyVnsS/p6TmTmUc7vAEgt3njwur5ziB7XasuQCge3SMUyf2oPSwzh8JJIgQHkAh56c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZUEBAM8X; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709517285; x=1741053285;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VaVZc+NmH05m44vaFq+I+v7FffyptzHfgc+PQIJqWAU=;
  b=ZUEBAM8Xo8TIaUjhuFXdYKCnyd9l96RHKy4ZO5a5AHDEMJ2xcIAkaZ5h
   mU2MXqrgczGngYRoBs7NUiQc1M4dKirfJznQ4ZR8YhtvVszuhZnSceuCJ
   PbyWEbg0NTklS/G6FhguzWzatz4jVb/Z95uYg9TJRjpZL5MHf2UBQx6Q7
   QJSnZJR+C1H6sx6eM+MqszkNEEG0YZgVuu95603+PUIUgM9np+EYyNQWT
   j4sHtlCBmkXJSv5OGkw/DuPI2JDJfNFXqIwIhYgWFbd4f21TJIQweGHgp
   NcPwyUp9Xk2TomjAcMbsTVih82V7nUWdq6J8HwMkT8TM6YkFVWkwW/8Mz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="26457673"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="26457673"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 17:54:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="39677294"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 17:54:42 -0800
Message-ID: <3ab64c0f-7387-4738-b78c-cf798528d5f4@intel.com>
Date: Mon, 4 Mar 2024 09:54:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] kvm: add support for guest physical bits
To: Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240301101713.356759-1-kraxel@redhat.com>
 <20240301101713.356759-2-kraxel@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240301101713.356759-2-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/2024 6:17 PM, Gerd Hoffmann wrote:
> query kvm for supported guest physical address bits using
> KVM_CAP_VM_GPA_BITS.  Expose the value to the guest via cpuid
> (leaf 0x80000008, eax, bits 16-23).
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>   target/i386/cpu.h     | 1 +
>   target/i386/cpu.c     | 1 +
>   target/i386/kvm/kvm.c | 8 ++++++++
>   3 files changed, 10 insertions(+)
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

I think you misunderstand this field.

If you expose this field to guest, it's the information for nested 
guest. i.e., the guest itself runs as a hypervisor will know its nested 
guest can have guest_phys_bits for physical addr.

>           }
>           *ebx = env->features[FEAT_8000_0008_EBX];
>           if (cs->nr_cores * cs->nr_threads > 1) {
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 42970ab046fa..e06c9d66bb01 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1716,6 +1716,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       X86CPU *cpu = X86_CPU(cs);
>       CPUX86State *env = &cpu->env;
>       uint32_t limit, i, j, cpuid_i;
> +    uint32_t guest_phys_bits;
>       uint32_t unused;
>       struct kvm_cpuid_entry2 *c;
>       uint32_t signature[3];
> @@ -1751,6 +1752,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>   
>       env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
>   
> +    guest_phys_bits = kvm_check_extension(cs->kvm_state, KVM_CAP_VM_GPA_BITS);
> +    if (guest_phys_bits &&
> +        (cpu->guest_phys_bits == 0 ||
> +         cpu->guest_phys_bits > guest_phys_bits)) {
> +        cpu->guest_phys_bits = guest_phys_bits;
> +    }
> +
>       /*
>        * kvm_hyperv_expand_features() is called here for the second time in case
>        * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle


