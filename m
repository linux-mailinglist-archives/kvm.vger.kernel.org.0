Return-Path: <kvm+bounces-25459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A09C79657C3
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14B731F2420E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9631531D4;
	Fri, 30 Aug 2024 06:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jjebYwJo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8705714D71D;
	Fri, 30 Aug 2024 06:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725000234; cv=none; b=Rm7IfjfrGBJeBUfsW2V1DHbv5MllgpxY1O2cMmyJjTjaDVZsjVgVYljJc2iPrL571Q1npwhYub5e01VhQ1YAHFkgb6sfo+PyTIeAJojfKdSjPOBFv1ZJg7ZqVXOU6c4qwJUs5a4tWzYhgyrMzRN+7Tjz3WkMRwLeSaY5n7AktS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725000234; c=relaxed/simple;
	bh=nFDpNCagVXHa1wCTJEFok+5byxzQ02lj9SyW086OWk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IFp9RZ8l5rREZnb/hW3hPdBz+QiqI9JIYrI/nqgFe/67d6GO8lBzhwZ2AdguwypK+p81GXoPyZjiQWEPQdYZJq2ZAAgV0+anJITXqI1N/TQsLZrWr2IklQN3JSoZK5MqRoTcxXyM0JP2gDUZU1lS3FipG/QQJ2TSkYbCuxeA2fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jjebYwJo; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725000233; x=1756536233;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nFDpNCagVXHa1wCTJEFok+5byxzQ02lj9SyW086OWk8=;
  b=jjebYwJodBwJgj8olhi2zT8zetk8H4ezChnFhAyB7azO1l1Dh5Fi6zlP
   KwOynsIxxEjorBZLbH5U65742eWQHWutB611xkseSen+k4Tnhu4tHPZSH
   Ot5eiVVs3Uc7RywJfpr4DEcRoi8gZz9BcN95fjnhrg/GVx2R3ljoThgUa
   a7BNC302WO4oInA9ERzepjL+gdI1t64RmHEN6Y/ZW8WMfBygG86IG234R
   hTqWdZhNyY1PAGVuuAPBUW70a0X+TFk7qis8SyOXFqfbJjK1ruORHvEMo
   sgiwZG97ytbHv9h8SAR10opZezZtL5Y0sDj38nhIlBR3CUzYE/EW7GaXo
   A==;
X-CSE-ConnectionGUID: +i6F+rPFT/S0q5potPpn7w==
X-CSE-MsgGUID: jDc+7KK3RjSzjKdp8X1DZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23586845"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23586845"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:43:52 -0700
X-CSE-ConnectionGUID: 7a8nZg/ETUaSzTRyE1+kIA==
X-CSE-MsgGUID: 5b1rOAAYRu2mnBdzFZlZYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="68208169"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.96.163])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:43:47 -0700
Message-ID: <9c281652-c554-48a1-8ea5-fe7aecf822b6@intel.com>
Date: Fri, 30 Aug 2024 09:43:40 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/24 10:14, Kai Huang wrote:
> The TDX module provides a set of "global metadata fields".  They report

Global Metadata Fields

> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> For now the kernel only reads "TD Memory Region" (TDMR) related fields
> for module initialization.  There are both immediate needs to read more
> fields for module initialization and near-future needs for other kernel
> components like KVM to run TDX guests.
> will be organized in different structures depending on their meanings.

Line above seems lost

> 
> For now the kernel only reads TDMR related fields.  The TD_SYSINFO_MAP()
> macro hard-codes the 'struct tdx_sys_info_tdmr' instance name.  To make
> it work with different instances of different structures, extend it to
> take the structure instance name as an argument.
> 
> This also means the current code which uses TD_SYSINFO_MAP() must type
> 'struct tdx_sys_info_tdmr' instance name explicitly for each use.  To
> make the code easier to read, add a wrapper TD_SYSINFO_MAP_TDMR_INFO()
> which hides the instance name.

Note, were you to accept my suggestion for patch 2, TD_SYSINFO_MAP() would
have gone away, and no changes would be needed to get_tdx_sys_info_tdmr().
So the above 2 paragraphs could be dropped.

> 
> TDX also support 8/16/32/64 bits metadata field element sizes.  For now
> all TDMR related fields are 16-bit long thus the kernel only has one
> helper:
> 
>   static int read_sys_metadata_field16(u64 field_id, u16 *val) {}
> 
> Future changes will need to read more metadata fields with different
> element sizes.  To make the code short, extend the helper to take a
> 'void *' buffer and the buffer size so it can work with all element
> sizes.
> 
> Note in this way the helper loses the type safety and the build-time
> check inside the helper cannot work anymore because the compiler cannot
> determine the exact value of the buffer size.
> 
> To resolve those, add a wrapper of the helper which only works with
> u8/u16/u32/u64 directly and do build-time check, where the compiler
> can easily know both the element size (from field ID) and the buffer
> size(using sizeof()), before calling the helper.
> 
> An alternative option is to provide one helper for each element size:

IMHO, it is not necessary to describe alternative options. Better to
explain why the actual code change is good, rather than why something
that wasn't done, wasn't so good.  That discussion can stay on the
mailing list.  For example, this commit message can just have:

  Add a build-time check that the element size is correct, which
  enables a common function to safely read data of different sizes.

Perhaps end up with:

  TDX supports 8/16/32/64 bit metadata field element sizes.  For now all
  TDMR related fields are 16-bits long.  Future changes will need to read
  more metadata fields with different element sizes.

  So add a build-time check that the element size is correct, which
  enables a common function to safely read data of different sizes.

> 
>   static int read_sys_metadata_field8(u64 field_id, u8 *val) {}
>   static int read_sys_metadata_field16(u64 field_id, u16 *val) {}
>   ...
> 
> But this will result in duplicated code given those helpers will look
> exactly the same except for the type of buffer pointer.  It's feasible
> to define a macro for the body of the helper and define one entry for
> each element size to reduce the code, but it is a little bit
> over-engineering.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v2 -> v3:
>  - Rename read_sys_metadata_field() to tdh_sys_rd() so the former can be
>    used as the high level wrapper.  Get rid of "stbuf_" prefix since
>    people don't like it.
>  
>  - Rewrite after removing 'struct field_mapping' and reimplementing
>    TD_SYSINFO_MAP().
>  
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 45 +++++++++++++++++++++----------------
>  arch/x86/virt/vmx/tdx/tdx.h |  3 ++-
>  2 files changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 7e75c1b10838..1cd9035c783f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -250,7 +250,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
>  	return ret;
>  }
>  
> -static int read_sys_metadata_field(u64 field_id, u64 *data)
> +static int tdh_sys_rd(u64 field_id, u64 *data)
>  {
>  	struct tdx_module_args args = {};
>  	int ret;
> @@ -270,43 +270,50 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>  	return 0;
>  }
>  
> -static int read_sys_metadata_field16(u64 field_id, u16 *val)
> +static int __read_sys_metadata_field(u64 field_id, void *val, int size)
>  {
>  	u64 tmp;
>  	int ret;
>  
> -	BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> -			MD_FIELD_ID_ELE_SIZE_16BIT);
> -
> -	ret = read_sys_metadata_field(field_id, &tmp);
> +	ret = tdh_sys_rd(field_id, &tmp);
>  	if (ret)
>  		return ret;
>  
> -	*val = tmp;
> +	memcpy(val, &tmp, size);
>  
>  	return 0;
>  }
>  
> +/* Wrapper to read one global metadata to u8/u16/u32/u64 */
> +#define read_sys_metadata_field(_field_id, _val)					\
> +	({										\
> +		BUILD_BUG_ON(MD_FIELD_ELE_SIZE(_field_id) != sizeof(typeof(*(_val))));	\
> +		__read_sys_metadata_field(_field_id, _val, sizeof(typeof(*(_val))));	\
> +	})
> +
>  /*
> - * Assumes locally defined @ret and @sysinfo_tdmr to convey the error
> - * code and the 'struct tdx_sys_info_tdmr' instance to fill out.
> + * Read one global metadata field to a member of a structure instance,
> + * assuming locally defined @ret to convey the error code.
>   */
> -#define TD_SYSINFO_MAP(_field_id, _member)						\
> -	({										\
> -		if (!ret)								\
> -			ret = read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
> -					&sysinfo_tdmr->_member);			\
> +#define TD_SYSINFO_MAP(_field_id, _stbuf, _member)				\
> +	({									\
> +		if (!ret)							\
> +			ret = read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
> +					&_stbuf->_member);			\
>  	})
>  
>  static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
>  {
>  	int ret = 0;
>  
> -	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs);
> -	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
> -	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
> -	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
> -	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
> +#define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, sysinfo_tdmr, _member)
> +
> +	TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,	        max_tdmrs);
> +	TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
> +	TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
> +	TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
> +	TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
>  
>  	return ret;
>  }
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 148f9b4d1140..7458f6717873 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -53,7 +53,8 @@
>  #define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
>  		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
>  
> -#define MD_FIELD_ID_ELE_SIZE_16BIT	1
> +#define MD_FIELD_ELE_SIZE(_field_id)	\
> +	(1 << MD_FIELD_ID_ELE_SIZE_CODE(_field_id))
>  
>  struct tdmr_reserved_area {
>  	u64 offset;


