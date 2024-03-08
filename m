Return-Path: <kvm+bounces-11360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50640875EA1
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 058261F22BAE
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53444F895;
	Fri,  8 Mar 2024 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HqwbC9Yf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240EC4F1FB;
	Fri,  8 Mar 2024 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709883417; cv=none; b=IbV7AHb/VXjcBItI8Af0q4FmK4mJIj7SgHYMzjLKRuHIyuZdZizsWjn+eFQrbJsK/X83pLRLKht44iKsgMqtzMRxWgW0RxbDyZl+TYPrtLKna56nA72+zP2Ychspp2baNDy/qF9g5EufiKA9h2gveOH8lsFAntWwiyVsGLfuGN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709883417; c=relaxed/simple;
	bh=q54CEwR1ccTp6ApwGLg7vchnUylayo5XvRfKnbSfVzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RdDq4xTlyJ6pnQ6tPgdbIuWgo8yf/+TiIs01c0004oZSrnRbM29JFg1gpQbl9m39lANj66SgfuGjgC/t/nGyqmvhyCFaHEUTklgqMZ6mOHSZHcc3dI4PFd8NpY2RGmpQ6+8bkorieKlxR8ZkjouTNat2rJ68mlsqWOe8ky9U6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HqwbC9Yf; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709883416; x=1741419416;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q54CEwR1ccTp6ApwGLg7vchnUylayo5XvRfKnbSfVzY=;
  b=HqwbC9YfYrR2Fk1EbdGAkdl0cPf9nfPqsbqfvqjMx2nhflD6tYKj+rlF
   99fvO/H48Z7jTI4e46u2cTeDHgk3GjJO58IDHrUxArRoOYko5VWTd44mW
   5pdGAB4C50qtPqhGUU4/J4ZVKC9jL96g4Q67COFQ9cr3FFpRkeoId24Tk
   GG1O3UH1mqq2NRdmp6B2xmu93ZJuRQZ3YeCDyI+WJHSsXnIvGltuav9aM
   gmYu+GUqKKTvZIY3kmMKTdr8cmqgCCMLnq1/fJJ+WJWZ1mI8qpSiCnMKP
   Vmw+UMdd+CvAD6wUEn4KgRuUq64QDhpPz87kJLj8QRMm/uP6c+B9wkABF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="16024647"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="16024647"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:36:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="15049243"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:36:48 -0800
Message-ID: <fe3f712b-de49-409f-b9c0-7456d1aaa015@linux.intel.com>
Date: Fri, 8 Mar 2024 15:36:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 002/130] x86/virt/tdx: Move TDMR metadata fields map
 table to local variable
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <44d9530187b4b0b1c05e150fa73fe22ab54fc911.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <44d9530187b4b0b1c05e150fa73fe22ab54fc911.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Kai Huang <kai.huang@intel.com>
>
> The kernel reads all TDMR related global metadata fields based on a
> table which maps the metadata fields to the corresponding members of
> 'struct tdx_tdmr_sysinfo'.  Currently this table is a static variable.
>
> But this table is only used by the function which reads these metadata
> fields and becomes useless after reading is done.  Change the table
> to function local variable.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 17 ++++++++---------
>   1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 2aee64d2f27f..cdcb3332bc5d 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -301,17 +301,16 @@ struct field_mapping {
>   	{ .field_id = MD_FIELD_ID_##_field_id,	   \
>   	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
>   
> -/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> -static const struct field_mapping fields[] = {
> -	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
> -	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> -	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> -	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> -	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
> -};
> -
>   static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>   {
> +	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> +	const struct field_mapping fields[] = {
> +		TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
> +		TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> +		TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> +		TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> +		TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
> +	};
>   	int ret;
>   	int i;
>   


