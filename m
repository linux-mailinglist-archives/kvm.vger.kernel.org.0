Return-Path: <kvm+bounces-25507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BB3965FE6
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 155F21C22EA5
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A69199FC5;
	Fri, 30 Aug 2024 11:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J8I/Qr4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C23419992E
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015711; cv=none; b=ZiZMM7Pmn/Tif0BkJBwle8ZecBwJV8xz3d/xsb/Rhkuof/UIcEUJfUoWCTo2vQwUWSwnnbFjFpIhrIuShwtnre0F/JeZiIcHultPyNYdfiEucAzNVqKxDFy4CbMcN/WZw0e1ysGoC3prjMNvKNUsAXA+xxpOOXCOzLRyJ3Ev3Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015711; c=relaxed/simple;
	bh=vKuqrREFoyvNII2hKWu6ERx+NwtKfKPfclPhKNWBpcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oUEiGUYYDCGiHRB4yiEAhaNQ2N+BhHIl6Tx2n5BGbkqig0AIACXQLJWv8oa3yF5w7FzY+hI50gbuKUf8F9JJ+IwcvngCOaY241d5YbBldnuWrMvqc6OvlDuU6TT/x8b0dyYt252+ypRF4nPRvmpKfvUWUnOMHJUGZawyLwXV8Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J8I/Qr4O; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a86933829dcso206005366b.3
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 04:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725015708; x=1725620508; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2EYt5CjZw8GMvNmBrdKaiFdyeo95V7Mi0tOgxw58DFA=;
        b=J8I/Qr4ObV02wpXlORZ6FZtS7DV083WRP0PhxIztYVTddfGpGZWqoOyaNp4sldwBl3
         IjwOthhCbFpX1sU/LWw9XUMentS9hxlHpiJL8Hv+YSK03XAiFmEM7ujpc+QWkTPugdBK
         9bdIXXnpmtN4KUPaIgdliCq4Vau1qpIYS99wBi7TaGno9cZcMs3xm+k5t5RTyiIRwoqY
         +z1t0KrRNgrXQgWqYd43C0eW2Qz1tAzUv0IWCP9MKHVC85sGDo9Ui0gWxuGnpUuDvjKG
         wAYXS9+qm/4mRWXclkl0csCC+KTUk3F22aDP3lTVvP5yLj5h2+yfPWURmna2r+pY96gK
         rTAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725015708; x=1725620508;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2EYt5CjZw8GMvNmBrdKaiFdyeo95V7Mi0tOgxw58DFA=;
        b=cvbLTTF/vcDnjhwnx9UsQ0xreC8wCzWrlCNNKdrg4PBVFH0KvA83GoC3dD3No5TS//
         yLoKQaA9B7RPkCnt4Sva4U0VtGH5o891BTGymT0pOOf1jvjU1F/+ryA5dZAZhK8R8ZYS
         VHvd2KXvKK3bDko9q9tdHj/6jQXpjUUeZXVwqgdtYKq+6vjosAPSonvJZF2PZzNMsH3u
         hAzztwf3mB12B4pN3eegy9xtPrCTO/CsI6zQczUu+onjtbUSrhiPXloTjoPGPMgnMUEx
         QIGfOvcLGBcj4BXP2J0Bpr+cIqI+vbyFBgWc769lLb5O5baSCz1uCWfjXPFTsGOLobjE
         Rhyg==
X-Forwarded-Encrypted: i=1; AJvYcCUzm/q6us3ttJhtKkfscbugN0MuH+7E2UU9uWz7WU4RNXezwfM8urwQuinxfjRetaINDQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsW/07amL6Ripvjc1Eg+Tx6nd4W7rCWsEyPANUvkxBYB0S5itS
	qoyDRf8wFX2l7dx+E3cp7gzKTs3MOVFSS5b1xISImO3e1iroIzXUWqodxXxnnYw=
X-Google-Smtp-Source: AGHT+IGJSthKCfRuG0EfBT7hp8LTjNlZyvfJkFtLrLvBxC+A+ma+JX+ok/9kRYFdp3AvMkYm1QW9xw==
X-Received: by 2002:a17:907:1c22:b0:a86:85eb:bdd1 with SMTP id a640c23a62f3a-a897f8bcb7dmr447901466b.31.1725015707149;
        Fri, 30 Aug 2024 04:01:47 -0700 (PDT)
Received: from [10.20.4.146] (212-5-158-102.ip.btc-net.bg. [212.5.158.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a89891daf81sm201796966b.163.2024.08.30.04.01.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2024 04:01:46 -0700 (PDT)
Message-ID: <412ea31c-5edb-4985-9bc5-3e3f628d4945@suse.com>
Date: Fri, 30 Aug 2024 14:01:43 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/8] x86/virt/tdx: Start to track all global metadata
 in one structure
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com, adrian.hunter@intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <994a0df50534c404d1b243a95067860fc296172a.1724741926.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <994a0df50534c404d1b243a95067860fc296172a.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 27.08.24 г. 10:14 ч., Kai Huang wrote:
> The TDX module provides a set of "global metadata fields".  They report
> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> Currently the kernel only reads "TD Memory Region" (TDMR) related fields
> for module initialization.  There are immediate needs which require the
> TDX module initialization to read more global metadata including module
> version, supported features and "Convertible Memory Regions" (CMRs).
> 
> Also, KVM will need to read more metadata fields to support baseline TDX
> guests.  In the longer term, other TDX features like TDX Connect (which
> supports assigning trusted IO devices to TDX guest) may also require
> other kernel components such as pci/vt-d to access global metadata.
> 
> To meet all those requirements, the idea is the TDX host core-kernel to
> to provide a centralized, canonical, and read-only structure for the
> global metadata that comes out from the TDX module for all kernel
> components to use.
> 
> As the first step, introduce a new 'struct tdx_sys_info' to track all
> global metadata fields.
> 
> TDX categories global metadata fields into different "Class"es.  E.g.,
> the TDMR related fields are under class "TDMR Info".  Instead of making
> 'struct tdx_sys_info' a plain structure to contain all metadata fields,
> organize them in smaller structures based on the "Class".
> 
> This allows those metadata fields to be used in finer granularity thus
> makes the code more clear.  E.g., the construct_tdmr() can just take the
> structure which contains "TDMR Info" metadata fields.
> 
> Add a new function get_tdx_sys_info() as the placeholder to read all
> metadata fields, and call it at the beginning of init_tdx_module().  For
> now it only calls get_tdx_sys_info_tdmr() to read TDMR related fields.
> 
> Note there is a functional change: get_tdx_sys_info_tdmr() is moved from
> after build_tdx_memlist() to before it, but it is fine to do so.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v2 -> v3:
>   - Split out the part to rename 'struct tdx_tdmr_sysinfo' to 'struct
>     tdx_sys_info_tdmr'.
> 
> 
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 19 ++++++++++++-------
>   arch/x86/virt/vmx/tdx/tdx.h | 36 +++++++++++++++++++++++++++++-------
>   2 files changed, 41 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 1cd9035c783f..24eb289c80e8 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -318,6 +318,11 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
>   	return ret;
>   }
>   
> +static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)

A more apt name for this function would be init_tdx_sys_info, because it 
will be executed only once during module initialization and it's really 
initialising those values.

Given how complex TDX turns out to be it will be best if one off init 
functions are prefixed with 'init_'.


> +{
> +	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
> +}
> +
>   /* Calculate the actual TDMR size */
>   static int tdmr_size_single(u16 max_reserved_per_tdmr)
>   {
> @@ -1090,9 +1095,13 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
>   
>   static int init_tdx_module(void)
>   {
> -	struct tdx_sys_info_tdmr sysinfo_tdmr;
> +	struct tdx_sys_info sysinfo;
>   	int ret;
>   
> +	ret = get_tdx_sys_info(&sysinfo);
> +	if (ret)
> +		return ret;
> +
>   	/*
>   	 * To keep things simple, assume that all TDX-protected memory
>   	 * will come from the page allocator.  Make sure all pages in the
> @@ -1109,17 +1118,13 @@ static int init_tdx_module(void)
>   	if (ret)
>   		goto out_put_tdxmem;
>   
> -	ret = get_tdx_sys_info_tdmr(&sysinfo_tdmr);
> -	if (ret)
> -		goto err_free_tdxmem;
> -
>   	/* Allocate enough space for constructing TDMRs */
> -	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo_tdmr);
> +	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo.tdmr);
>   	if (ret)
>   		goto err_free_tdxmem;
>   
>   	/* Cover all TDX-usable memory regions in TDMRs */
> -	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo_tdmr);
> +	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr);
>   	if (ret)
>   		goto err_free_tdmrs;
>   
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 8aabd03d8bf5..4cddbb035b9f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -100,13 +100,6 @@ struct tdx_memblock {
>   	int nid;
>   };
>   
> -/* "TDMR info" part of "Global Scope Metadata" for constructing TDMRs */
> -struct tdx_sys_info_tdmr {
> -	u16 max_tdmrs;
> -	u16 max_reserved_per_tdmr;
> -	u16 pamt_entry_size[TDX_PS_NR];
> -};
> -
>   /* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
>   #define TDMR_NR_WARN 4
>   
> @@ -119,4 +112,33 @@ struct tdmr_info_list {
>   	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
>   };
>   
> +/*
> + * Kernel-defined structures to contain "Global Scope Metadata".
> + *
> + * TDX global metadata fields are categorized by "Class"es.  See the
> + * "global_metadata.json" in the "TDX 1.5 ABI Definitions".
> + *
> + * 'struct tdx_sys_info' is the main structure to contain all metadata
> + * used by the kernel.  It contains sub-structures with each reflecting
> + * the "Class" in the 'global_metadata.json'.
> + *
> + * Note the structure name may not exactly follow the name of the
> + * "Class" in the TDX spec, but the comment of that structure always
> + * reflect that.
> + *
> + * Also note not all metadata fields in each class are defined, only
> + * those used by the kernel are.
> + */
> +
> +/* Class "TDMR info" */
> +struct tdx_sys_info_tdmr {
> +	u16 max_tdmrs;
> +	u16 max_reserved_per_tdmr;
> +	u16 pamt_entry_size[TDX_PS_NR];
> +};
> +
> +struct tdx_sys_info {
> +	struct tdx_sys_info_tdmr tdmr;
> +};
> +
>   #endif

