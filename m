Return-Path: <kvm+bounces-28408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0825B9981DE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6EE61F28E12
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FA041C6D;
	Thu, 10 Oct 2024 09:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MIM3Ic0P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD151A3BAD;
	Thu, 10 Oct 2024 09:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728551630; cv=none; b=ZnUePiHS7THD60YcwwYbyzBuUsNrUNKqphvLvsLcQfYNVdWqY1hrcQ9ndrtvy29toD28Bizjld6sOoK6msvRUtBstkyo2XTpEsEzofcSOfXZ81bymcqGS9bC+LqaZrg9pLbjr4CQ8u/N06HT5oerDul+PBn5+rf467nVf88d0SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728551630; c=relaxed/simple;
	bh=pC5OFkXdytYxj4kaq32/6O0umAM8dy6S3K+VeUYOvHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c5E6Jka6y9uFJGlB0rfzP2R3uDpR9s4FbCgUisMkXbKynj8NtayLDoDrH8tdThtstxiQUVwER3XQ8QCc/K9pMMxy0Em/BJorDFH59TPlv4Md3guvEZ692qH9T7gIVtU19QkBu9c1A8Fm4RgX7FYz3PPCULtAfc29fLmQlVFm3WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MIM3Ic0P; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728551628; x=1760087628;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pC5OFkXdytYxj4kaq32/6O0umAM8dy6S3K+VeUYOvHQ=;
  b=MIM3Ic0P1/TFtPjxsWYTNrBrs4Rnvval6AFmLqhG+mh2l+4G4ZPExhkG
   cD2eVihaNXoKp0mW3lzIvRIvv2PhmS98FxexuIwCwAihbZXLwYgQ9v7HQ
   AP9GDeK+OKDUhY2q8bqDrYPzco1elnjNfokSRVAFltugwVxgO55uYyb5j
   P/kCoYJ6WKjqoRNH9lVdRpyFN2ydjgN0l3xOaIK3YpYgV/6K+oHzK2ulu
   nSKauCzf4GjQ/67GlrtzcujtHXHENfAupJ86C3fO8xfq8hOPSnSiA66FQ
   Oc47Cr5pZ5pYFg2S+w1a5UNsmh1j+TgVdK8IlAqtMOWpz2YObCa43KPYP
   A==;
X-CSE-ConnectionGUID: E9rMyavvQemz1f/ic+l0yg==
X-CSE-MsgGUID: xL+Aeb7kRt+hanKepS1dgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="27981385"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="27981385"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 02:13:48 -0700
X-CSE-ConnectionGUID: NZBdQTLIQMa3zfeLmd+pMw==
X-CSE-MsgGUID: Q9FM2y4oRvaWFTBL4aFCFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="81066139"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.26]) ([10.124.240.26])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 02:13:46 -0700
Message-ID: <f04c20f6-fce1-49e3-9cc8-c696032720fc@intel.com>
Date: Thu, 10 Oct 2024 17:13:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/25] KVM: TDX: Use guest physical address to configure
 EPT level and GPAW
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-23-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240812224820.34826-23-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> KVM reports guest physical address in CPUID.0x800000008.EAX[23:16],
> which is similar to TDX's GPAW. Use this field as the interface for
> userspace to configure the GPAW and EPT level for TDs.
> 
> Note,
> 
> 1. only value 48 and 52 are supported. 52 means GPAW-52 and EPT level
>     5, and 48 means GPAW-48 and EPT level 4.
> 2. value 48, i.e., GPAW-48 is always supported. value 52 is only
>     supported when the platform supports 5 level EPT.
> 
> Current TDX module doesn't support max_gpa configuration. However
> current implementation relies on max_gpa to configure  EPT level and
> GPAW. Hack KVM to make it work.

This patch needs to be squashed into patch 14.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - New patch
> ---
>   arch/x86/kvm/vmx/tdx.c | 32 +++++++++++++++++++-------------
>   1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index fe2bbc2ced41..c6bfeb0b3cc9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -514,23 +514,22 @@ static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
>   					struct td_params *td_params)
>   {
>   	const struct kvm_cpuid_entry2 *entry;
> -	int max_pa = 36;
> +	int guest_pa;
>   
>   	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
> -	if (entry)
> -		max_pa = entry->eax & 0xff;
> +	if (!entry)
> +		return -EINVAL;
> +
> +	guest_pa = (entry->eax >> 16) & 0xff;
> +
> +	if (guest_pa != 48 && guest_pa != 52)
> +		return -EINVAL;
> +
> +	if (guest_pa == 52 && !cpu_has_vmx_ept_5levels())
> +		return -EINVAL;
>   
>   	td_params->eptp_controls = VMX_EPTP_MT_WB;
> -	/*
> -	 * No CPU supports 4-level && max_pa > 48.
> -	 * "5-level paging and 5-level EPT" section 4.1 4-level EPT
> -	 * "4-level EPT is limited to translating 48-bit guest-physical
> -	 *  addresses."
> -	 * cpu_has_vmx_ept_5levels() check is just in case.
> -	 */
> -	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
> -		return -EINVAL;
> -	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> +	if (guest_pa == 52) {
>   		td_params->eptp_controls |= VMX_EPTP_PWL_5;
>   		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
>   	} else {
> @@ -576,6 +575,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
>   		value->ebx = entry->ebx;
>   		value->ecx = entry->ecx;
>   		value->edx = entry->edx;
> +
> +		if (c->leaf == 0x80000008)
> +			value->eax &= 0xff00ffff;
>   	}
>   
>   	return 0;
> @@ -1277,6 +1279,10 @@ static int __init setup_kvm_tdx_caps(void)
>   		memcpy(dest, &source, sizeof(struct kvm_tdx_cpuid_config));
>   		if (dest->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF)
>   			dest->sub_leaf = 0;
> +
> +		/* Work around missing support on old TDX modules */
> +		if (dest->leaf == 0x80000008)
> +			dest->eax |= 0x00ff0000;
>   	}
>   
>   	return 0;


