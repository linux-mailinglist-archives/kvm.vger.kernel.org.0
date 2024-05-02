Return-Path: <kvm+bounces-16447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 487278BA3D1
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 795C61C22D59
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28B2200C7;
	Thu,  2 May 2024 23:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xqy6CaAq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE71C2BE;
	Thu,  2 May 2024 23:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714691504; cv=none; b=JuT9w+SagOoDFpuHG3awwWFR7cybIcE6fibo0M7A/esenhzKirzuhA7ZeeCaCW8O4ocaOsi5ObupKj+qpnklrn+vhV/N4gNmnw+7BYPovfgUD+cTsevMjhSIpn3czkQ/8nU/p7Pnj8VvjS89FaXWl+NXurQCpfEKnFkVHURqjq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714691504; c=relaxed/simple;
	bh=BCu5DjqXcmPG//vCsbZOiiWzxlLCpxGZ01rex1Oz3Sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUt4bvIhPjAAbBbh9Qd8Iz/2xsOkz8CaCbcifehHq/I0yAdP42nP9a2gL9FZIy0JfDzDbHA5mhh5yKuTCikK1QJj6x6QcitDuxD8lbtA1NvhnQRcGTh8LebVrBTT8N+4YCVFJ1kEb1S20+KG1JyIEJmCsv9ebBoPBGBSZ746/uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xqy6CaAq; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714691503; x=1746227503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BCu5DjqXcmPG//vCsbZOiiWzxlLCpxGZ01rex1Oz3Sw=;
  b=Xqy6CaAqLf+VOn44b0AG/O4pMvLF65FU2OqVd/ELXmRd5z9z8JrwEj0C
   NR8da0OyOGz+WEiKTil1LK4gsrKSxjC260jxNh3U6QPhXIuC8Y5Sod3PF
   NRy0I4Elc0lZLJC4+cJBWo3FHwrdSi+P5HJKaN9JOfYpjACQBAoyixk9s
   cLXDFeYwqw3EZZMSGsySMsYIxgHPJMYew50xV2SYDayPTJb4Jyc0x2qvA
   Ohma0Bezu4vGGfSDcufjLeva48hFaZRzgvSG0cO8c/VhMDtqNESCk/oUH
   QvnvX7QBnNGprNa/1yJMEYggE37h8bclZPUc3S8Ftj4N0ZLG6QaC0cBXy
   A==;
X-CSE-ConnectionGUID: K8bMoHgMQh2ZrZADPt/NjQ==
X-CSE-MsgGUID: xJqCWu6FQU+i+mdXfaUZMw==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="10709730"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="10709730"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 16:11:42 -0700
X-CSE-ConnectionGUID: pZ7LHjPERy2vcF7eAyPTwQ==
X-CSE-MsgGUID: wVxZ/QkLRjizm+OBuZjfCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="31777977"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 16:11:41 -0700
Date: Thu, 2 May 2024 16:11:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com,
	isaku.yamahata@intel.com, isaku.yamahata@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v15 02/20] KVM: x86: Add hook for determining max NPT
 mapping level
Message-ID: <20240502231140.GC13783@ls.amr.corp.intel.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-3-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240501085210.2213060-3-michael.roth@amd.com>

On Wed, May 01, 2024 at 03:51:52AM -0500,
Michael Roth <michael.roth@amd.com> wrote:

...

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c6c5018376be..87265b73906a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1816,6 +1816,7 @@ struct kvm_x86_ops {
>  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> +	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);

Explicit private prefix is nice.


>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 510eb1117012..0d556da052f6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4271,6 +4271,20 @@ static inline u8 kvm_max_level_for_order(int order)
>  	return PG_LEVEL_4K;
>  }
>  
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +					u8 max_level, int gmem_order)
> +{
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	return min(max_level,
> +		   static_call(kvm_x86_private_max_mapping_level)(kvm, pfn));

If we don't implement this hook, OPTIONAL_RET0 causes always PG_LEVEL_NONE.
Anyway when TDX implements the hook, we can remove OPTIONAL_RET0.

This hook works for TDX by "return PG_LEVEL_4K;".
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

