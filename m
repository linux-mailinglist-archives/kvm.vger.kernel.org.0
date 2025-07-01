Return-Path: <kvm+bounces-51155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2D7AEEDD8
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 07:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1727E16C161
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D383A25E448;
	Tue,  1 Jul 2025 05:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IIsfETpB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9B225D1E6;
	Tue,  1 Jul 2025 05:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751348303; cv=none; b=JX0R+je5PqMqecY6vqRIhvrsWwI1y/VOKYbBV8Wj1/EoKm9kqLzxVQD37JB9exxOnl0UeU18qhHxYHZrNYJT+Kz1aprv1Gg2f/PjSfjdzcYRIb4Wxf/ClzJNNt8QfzurrLk/eMi+gk4o6r/6IKhfPhzt4VvfrqTLqvkwJxCrhn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751348303; c=relaxed/simple;
	bh=vpmfIbh8slvY4Hxqk0yvtMVFycB8KNyPJIZQ9leW794=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MKClb6NLuuhlYnpt3KIAcMyFvX6pIi2yf//1Ut5u2GBSFIcnUmxJMIForDF+pzYUqOOxJLMuiXvos2J2lGpfnNfXayvJSIIdwEUZbXMcmWw0VcdXj9hAmya16vzKl4fEbdaCqI+D6jsXK7DAv/SDJHqlv6CXnoUIZp5/Vn9iqdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IIsfETpB; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751348301; x=1782884301;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vpmfIbh8slvY4Hxqk0yvtMVFycB8KNyPJIZQ9leW794=;
  b=IIsfETpBN38hrN8avPSZajnBRRrjkmuFxrCb2eqPlrQv9gNOoIWDG+qF
   QoD3pB/1t9fBy8TzClGiPcRw3oP8Z7ow1jSt1ZwRD7qLOWc1aTsUO1TQm
   HZC8qwKtrFq7vV2X+6tOADge0mJu3sruX5ebR9so23WaUfPS4CS14p36b
   RkP8HmsSsBAQGQPsePikLkqWOphCH7kIHs1StM7hQajQYfZlEO7NbbsLE
   ppHSwtzqsGfOMaSpMGN1Pga/xMjfO5jiw0EO5NKOmZJrwniSZ/nfh2Iyk
   cQtF8V9ftstUS7vRorP5gHCuwga5Lha7t5m2ABSjAP/xEa/zyV86JBO4F
   w==;
X-CSE-ConnectionGUID: liWpxYLmSgOMLI6CLgtXXQ==
X-CSE-MsgGUID: 2QTAV3+fQJSl7+/G9wjATw==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53530282"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53530282"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 22:37:41 -0700
X-CSE-ConnectionGUID: 0hukzfc1SGOENT542ZEYVQ==
X-CSE-MsgGUID: n18iAqNaQJOLeAg28GqHBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="190834232"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 22:37:35 -0700
Message-ID: <8a9924d8-7d73-48a4-9ed8-a031df7098e7@linux.intel.com>
Date: Tue, 1 Jul 2025 13:37:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
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
 <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/26/2025 6:48 PM, Kai Huang wrote:
> Some early TDX-capable platforms have an erratum: A kernel partial
> write (a write transaction of less than cacheline lands at memory
> controller) to TDX private memory poisons that memory, and a subsequent
> read triggers a machine check.
>
> On those platforms, the old kernel must reset TDX private memory before
> jumping to the new kernel, otherwise the new kernel may see unexpected
> machine check.  Currently the kernel doesn't track which page is a TDX
> private page.  For simplicity just fail kexec/kdump for those platforms.
>
> Leverage the existing machine_kexec_prepare() to fail kexec/kdump by
> adding the check of the presence of the TDX erratum (which is only
> checked for if the kernel is built with TDX host support).  This rejects
> kexec/kdump when the kernel is loading the kexec/kdump kernel image.
>
> The alternative is to reject kexec/kdump when the kernel is jumping to
> the new kernel.  But for kexec this requires adding a new check (e.g.,
> arch_kexec_allowed()) in the common code to fail kernel_kexec() at early
> stage.  Kdump (crash_kexec()) needs similar check, but it's hard to
> justify because crash_kexec() is not supposed to abort.
>
> It's feasible to further relax this limitation, i.e., only fail kexec
> when TDX is actually enabled by the kernel.  But this is still a half
> measure compared to resetting TDX private memory so just do the simplest
> thing for now.
>
> The impact to userspace is the users will get an error when loading the
> kexec/kdump kernel image:
>
>    kexec_load failed: Operation not supported
>
> This might be confusing to the users, thus also print the reason in the
> dmesg:
>
>    [..] kexec: not allowed on platform with tdx_pw_mce bug.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> ---
>   arch/x86/kernel/machine_kexec_64.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 4519c7b75c49..d5a85d786e61 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -347,6 +347,22 @@ int machine_kexec_prepare(struct kimage *image)
>   	unsigned long reloc_end = (unsigned long)__relocate_kernel_end;
>   	int result;
>   
> +	/*
> +	 * Some early TDX-capable platforms have an erratum.  A kernel
> +	 * partial write (a write transaction of less than cacheline
> +	 * lands at memory controller) to TDX private memory poisons that
> +	 * memory, and a subsequent read triggers a machine check.
> +	 *
Nit: About the description of the erratum, maybe it's better to refer to the
comments of check_tdx_erratum() to avoid duplication. Also it gives a link to
how/when the bug is set.

Otherwise,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


> +	 * On those platforms the old kernel must reset TDX private
> +	 * memory before jumping to the new kernel otherwise the new
> +	 * kernel may see unexpected machine check.  For simplicity
> +	 * just fail kexec/kdump on those platforms.
> +	 */
> +	if (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE)) {
> +		pr_info_once("Not allowed on platform with tdx_pw_mce bug\n");
> +		return -EOPNOTSUPP;
> +	}
> +
>   	/* Setup the identity mapped 64bit page table */
>   	result = init_pgtable(image, __pa(control_page));
>   	if (result)


