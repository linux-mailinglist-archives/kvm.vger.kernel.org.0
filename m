Return-Path: <kvm+bounces-51158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88ED4AEEE5B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 08:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E9893A7B17
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 06:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9FF253944;
	Tue,  1 Jul 2025 06:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C6Z0TWlf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB02224503E;
	Tue,  1 Jul 2025 06:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751350181; cv=none; b=MXklq5zZaFr22+7ejbdRPRzftOXJ5fylI7AWLhGfkmG7KYlwM4bU9FrmAZrc7Ad9WM7sL7EPcOcwSiCZx7ePy0IWUgELLIeeWZ9L6me40AgQB8Mtf8IHpVzspxt5eRWa5jfheljTvccRvBD5y1HhbIg4Q2fHQ2giy+1BwAS1d3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751350181; c=relaxed/simple;
	bh=YjlwFEAILUI6IdtFlpgUKI0FMv0UDJc07P0oQLm3XAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnq6HusyhcgP7LRUQ/tE/PvQbdSqOSTtI2PJhKhSr2kSQhewChVc4FKaYZwfBD4XKyKeQEGu3byMFwVwD9z13fyT1EX1866MOITAKHfcY5zH4QwAJXIvDpVhFfc7hj/XrcQFzSPkhWFw4tQzNB4GjL+RqeJKCCDPm74OXUoG7Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C6Z0TWlf; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751350180; x=1782886180;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YjlwFEAILUI6IdtFlpgUKI0FMv0UDJc07P0oQLm3XAs=;
  b=C6Z0TWlfkNilr6g09WNBaaJJVjbob4nUp/DU0Yv9iaLtfkpnbJsDxE4g
   LSsA46jaJJQz1wFyAUv/AD5Mtsl6s+b5EajlvL6oV2pffyRXzDKfrn8/A
   m0cs62zfCCCAYH5E0jis8BQC1POS6U95dwdRLzI2JTmIQ6GuHCtLhJS0s
   CRAHy2pGlR8vYYdHa52IBY/6hGML1CCA61RXL+TaoLwBZzizEAhIDHOy7
   dC3wS35WjqFLR34TVn8jdMekEu3agqZnSpqdecRW47cZ9SgG4OhzOiRJG
   RFavPVYO+FOrkXSyQVhd09D7oM57ZbJv7LsaC3R+sqjSqPEiqaVGDemaX
   g==;
X-CSE-ConnectionGUID: ywetuWkgSNS1hoeCpwqXoA==
X-CSE-MsgGUID: 1kQgbqr4TiSGO162EAMb+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="57371353"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="57371353"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 23:09:39 -0700
X-CSE-ConnectionGUID: feCFDeCnSbGfyYrdypCnzQ==
X-CSE-MsgGUID: SoDOR3kZSL2oYwG/KsN21A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153425297"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 23:09:35 -0700
Message-ID: <2d860bc1-c7ed-4e5e-8b91-ce494f9a8c54@linux.intel.com>
Date: Tue, 1 Jul 2025 14:09:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 thomas.lendacky@amd.com
Cc: x86@kernel.org, kirill.shutemov@linux.intel.com,
 rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 reinette.chatre@intel.com, isaku.yamahata@intel.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, nik.borisov@suse.com,
 sagis@google.com, Farrah Chen <farrah.chen@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
 <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/26/2025 6:48 PM, Kai Huang wrote:
> On TDX platforms, during kexec, the kernel needs to make sure there's no
> dirty cachelines of TDX private memory before booting to the new kernel
> to avoid silent memory corruption to the new kernel.
>
> During kexec, the kexec-ing CPU firstly invokes native_stop_other_cpus()
> to stop all remote CPUs before booting to the new kernel.  The remote
> CPUs will then execute stop_this_cpu() to stop themselves.
>
> The kernel has a percpu boolean to indicate whether the cache of a CPU
> may be in incoherent state.  In stop_this_cpu(), the kernel does WBINVD
> if that percpu boolean is true.
>
> TDX turns on that percpu boolean on a CPU when the kernel does SEAMCALL.
> This makes sure the caches will be flushed during kexec.
>
> However, the native_stop_other_cpus() and stop_this_cpu() have a "race"
> which is extremely rare to happen but could cause system to hang.
>
> Specifically, the native_stop_other_cpus() firstly sends normal reboot
> IPI to remote CPUs and wait one second for them to stop.  If that times
> out, native_stop_other_cpus() then sends NMIs to remote CPUs to stop
> them.
>
> The aforementioned race happens when NMIs are sent.  Doing WBINVD in
> stop_this_cpu() makes each CPU take longer time to stop and increases
> the chance of the race to happen.
>
> Register reboot notifier in KVM to explicitly flush caches upon
> receiving reboot notifier (e.g., during kexec) for TDX.  This moves the
> WBINVD to an earlier stage than stop_this_cpus(), avoiding a possibly
> lengthy operation at a time where it could cause this race.
Two nits below.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> ---
>
> v2 -> v3:
>   - Update changelog to address Paolo's comments and Add Paolo's Ack:
>     https://lore.kernel.org/lkml/3a7c0856-6e7b-4d3d-b966-6f17f1aca42e@redhat.com/
>
> ---
>   arch/x86/include/asm/tdx.h  |  3 +++
>   arch/x86/kvm/vmx/tdx.c      | 45 +++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.c |  9 ++++++++
>   3 files changed, 57 insertions(+)
>
[...]
> +
> +static int tdx_reboot_notify(struct notifier_block *nb, unsigned long code,
> +			     void *unused)
> +{
> +	/*
> +	 * Flush cache for all CPUs upon the reboot notifier.  This
> +	 * avoids having to do WBINVD in stop_this_cpu() during kexec.
> +	 *
> +	 * Kexec calls native_stop_other_cpus() to stop remote CPUs
> +	 * before booting to new kernel, but that code has a "race"
> +	 * when the normal REBOOT IPI timesout and NMIs are sent to

timesout should be times out or timeouts?

> +	 * remote CPUs to stop them.  Doing WBINVD in stop_this_cpu()
> +	 * could potentially increase the posibility of the "race".
s/posibility/possibility

> +	 */
> +	if (code == SYS_RESTART)
> +		on_each_cpu(smp_func_cpu_flush_cache, NULL, 1);
> +	return NOTIFY_DONE;
> +}
> +
>
[...]

