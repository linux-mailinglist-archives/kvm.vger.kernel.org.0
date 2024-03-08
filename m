Return-Path: <kvm+bounces-11361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE80875ECB
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:46:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE9301C21BC7
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5A74F61D;
	Fri,  8 Mar 2024 07:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QiaBxAH8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885654EB2F;
	Fri,  8 Mar 2024 07:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709883972; cv=none; b=Qs3hdVZ1WTs418knTQ6Z2q8DcItVZkDbjbqDh0LJdiPcoHJh+DUKJOZl4cFfnHqz4jevDrpms5oOhly/aLuYeVq0ezBRzYnyNlGFz/nYdTDxLfPbWv7S+tjkyPOeYZA/1F2HEan60Fv5fE9p11tmq8YWAaK7ygWN2SG57WHLzQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709883972; c=relaxed/simple;
	bh=SU/y7eEP7nRNmSd87woC458+unvPZtN0wfjyjyZJNHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r08WJbuTTTtGhggDHTDTg5hnAHD9HegJ+8kV8ERzdyLOym8dgfVfAqg9aqV4Esu0O1rfAOlyFu6AC9JnhbFHAEQyFf6JxsFmPU9k/6VwzBH/LV3HEjfeN6x7nWaJeiul/x3Xwsq9oynYxBgx1HbIap5+mPisyhLr0zKad7opywc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QiaBxAH8; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709883971; x=1741419971;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SU/y7eEP7nRNmSd87woC458+unvPZtN0wfjyjyZJNHM=;
  b=QiaBxAH8pyk1cMUOdLc8WBHy1WIL33ZPg4CvK84WBQpWGuhnk/nRU4sZ
   KkfvMiq+yPOH2X/4wdW3Si3GE7ACMBYJ3ZzcKdVTYn24fowxQrmnZth0T
   dHVDoflmH6KApRTGboaRTJkquzzIoLZxae/F4zjWVEO13xJ9/Sp3EZ9qY
   lTved9XeJmkZzl4iebZ7NAJPEaZy15YRqdTPArH10qi697OsUdrGXnU1t
   5F0wZ72yrRvj4Ouvt7sApIoE0pzBQqv31JDa710tCSQB7YUsilTF2YMlE
   K95mRgivmnm+bRNtFvad1QUFD2xEz9X/ZhLv6vWCtcPOW9vK5ISGdh9G8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4474766"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4474766"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:46:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="14968970"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:46:06 -0800
Message-ID: <5af738d6-626d-49d5-9bf9-e2140ac50155@linux.intel.com>
Date: Fri, 8 Mar 2024 15:46:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 003/130] x86/virt/tdx: Unbind global metadata read
 with 'struct tdx_tdmr_sysinfo'
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <96c21cc1d283cf59ecba003cd5a19bfbce83675d.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <96c21cc1d283cf59ecba003cd5a19bfbce83675d.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Kai Huang <kai.huang@intel.com>
>
> For now the kernel only reads TDMR related global metadata fields for
> module initialization, and the metadata read code only works with the
> 'struct tdx_tdmr_sysinfo'.
>
> KVM will need to read a bunch of non-TDMR related metadata to create and
> run TDX guests.  It's essential to provide a generic metadata read
> infrastructure which is not bound to any specific structure.
>
> To start providing such infrastructure, unbound the metadata read with
> the 'struct tdx_tdmr_sysinfo'.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++++++++-----------
>   1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index cdcb3332bc5d..eb208da4ff63 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -273,9 +273,9 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>   
>   static int read_sys_metadata_field16(u64 field_id,
>   				     int offset,
> -				     struct tdx_tdmr_sysinfo *ts)
> +				     void *stbuf)
>   {
> -	u16 *ts_member = ((void *)ts) + offset;
> +	u16 *st_member = stbuf + offset;
>   	u64 tmp;
>   	int ret;
>   
> @@ -287,7 +287,7 @@ static int read_sys_metadata_field16(u64 field_id,
>   	if (ret)
>   		return ret;
>   
> -	*ts_member = tmp;
> +	*st_member = tmp;
>   
>   	return 0;
>   }
> @@ -297,19 +297,22 @@ struct field_mapping {
>   	int offset;
>   };
>   
> -#define TD_SYSINFO_MAP(_field_id, _member) \
> -	{ .field_id = MD_FIELD_ID_##_field_id,	   \
> -	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
> +#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
> +	{ .field_id = MD_FIELD_ID_##_field_id,		\
> +	  .offset   = offsetof(_struct, _member) }
> +
> +#define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
>   
>   static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>   {
>   	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
>   	const struct field_mapping fields[] = {
> -		TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
> -		TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> -		TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> -		TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> -		TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
> +		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
> +		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
>   	};
>   	int ret;
>   	int i;


