Return-Path: <kvm+bounces-25334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D66FB963C9E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 09:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E994286799
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44610171E5F;
	Thu, 29 Aug 2024 07:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jAqIkgT2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23D0210EE;
	Thu, 29 Aug 2024 07:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724916024; cv=none; b=Zrw2OzhuKsM6/7aQXLy8FLZHdUds3ZIY2muS4OaoxGjaKBlrS+kLNKbQ6C+psxeR+fuqi/GNkQbK3RMQkjPaJS9Z/DM2AmG8oY0TlWEXB/C9tY/CiH+htsLd2yuiioEhdSCsHt2bBDgWIW2hJbWGjUc7RKJ0QW+fw9uahxHClyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724916024; c=relaxed/simple;
	bh=WYPa1rZUXSZPFuRJF6ekwyZIujiw0R1PqzJqfS34Ds8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=OnOu2fY5NMNL4PLcgHfI3z2BSa79h4+RNqOID4a101WvnrTH7t8U/O3LCuth6MJWMuLLvmeeN9ni90FIxwpR5JbeDhQFceCdNg7dxU84G2lKjIVx3ycYRZ5o/FOUI05DTe+6rIhfDc1gKElrxmxXShsk8gyhReeh78p5ERx5P6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jAqIkgT2; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724916022; x=1756452022;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=WYPa1rZUXSZPFuRJF6ekwyZIujiw0R1PqzJqfS34Ds8=;
  b=jAqIkgT29KdJgbgf0TRC5EpE0fM1e/hekBunwdOZbK8Vl25U9x8GtvNH
   yI+E0Cvs+oCuX8NULUOPtJ99POQ2szdz7+JHH7r5dSc4zZRM4wHvsPH/X
   PzKtu2agPny/MZ1ElB1jn0fKAd5XeMw7ywjAhAShJ3rEgKlNIww8TJ9cf
   CUgIfQ4TBxh13oRcHIjQBeaBjpGo1oezcBaCrqr5h/zyfMAxoxWcGci05
   STYlgSvDvLsPymv+kFBOV7IjPAXMS5rPunm86SniA2CeEVkbRFC67CxK1
   43TVd6L2/Oyux9FpWMjQybKXefLscj/xw24Uwg0qYhgoD3ziiocSD+2o3
   w==;
X-CSE-ConnectionGUID: cyRhEufkSkO6F01pgykbYA==
X-CSE-MsgGUID: sjMc7uBJSUmH3MJkQwl8ew==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="34889540"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="34889540"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 00:20:21 -0700
X-CSE-ConnectionGUID: Py+tC13iS2akyApHe2FmPg==
X-CSE-MsgGUID: OdtLSfsJTN+BMSv5DMGR+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="67850445"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 00:20:15 -0700
Message-ID: <5235e05e-1d73-4f70-9b5d-b8648b1f4524@intel.com>
Date: Thu, 29 Aug 2024 10:20:11 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v3 2/8] x86/virt/tdx: Remove 'struct field_mapping' and
 implement TD_SYSINFO_MAP() macro
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/24 10:14, Kai Huang wrote:

Subject could be "Simplify the reading of Global Metadata Fields"

> TL;DR: Remove the 'struct field_mapping' structure and use another way
> to implement the TD_SYSINFO_MAP() macro to improve the current metadata
> reading code, e.g., switching to use build-time check for metadata field
> size over the existing runtime check.

Perhaps:

  Remove 'struct field_mapping' and let read_sys_metadata_field16() accept
  the member variable address, simplifying the code in preparation for adding
  support for more metadata structures and field sizes.

> 
> The TDX module provides a set of "global metadata fields".  They report

Global Metadata Fields

> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> For now the kernel only reads "TD Memory Region" (TDMR) related global
> metadata fields, and all of those fields are organized in one structure.

The patch is self-evidently simpler (21 insertions(+), 36 deletions(-))
so there doesn't seem to be any need for further elaboration.  Perhaps
just round it off and stop there.

  ... and all of those fields are organized in one structure,
  but that will change in the near future.

> 
> The kernel currently uses 'struct field_mapping' to facilitate reading
> multiple metadata fields into one structure.  The 'struct field_mapping'
> records the mapping between the field ID and the offset of the structure
> to fill out.  The kernel initializes an array of 'struct field_mapping'
> for each structure member (using the TD_SYSINFO_MAP() macro) and then
> reads all metadata fields in a loop using that array.
> 
> Currently the kernel only reads TDMR related metadata fields into one
> structure, and the function to read one metadata field takes the pointer
> of that structure and the offset:
> 
>   static int read_sys_metadata_field16(u64 field_id,
>                                        int offset,
>                                        struct tdx_sys_info_tdmr *ts)
>   {...}
> 
> Future changes will need to read more metadata fields into different
> structures.  To support this the above function will need to be changed
> to take 'void *':
> 
>   static int read_sys_metadata_field16(u64 field_id,
>                                        int offset,
>                                        void *stbuf)
>   {...}
> 
> This approach loses type-safety, as Dan suggested.  A better way is to
> make it be ..
> 
>   static int read_sys_metadata_field16(u64 field_id, u16 *val) {...}
> 
> .. and let the caller calculate the buffer in a type-safe way [1].
> 
> Also, the using of the 'struct field_mapping' loses the ability to be
> able to do build-time check about the metadata field size (encoded in
> the field ID) due to the field ID is "indirectly" initialized to the
> 'struct field_mapping' and passed to the function to read.  Thus the
> current code uses runtime check instead.
> 
> Dan suggested to remove the 'struct field_mapping', unroll the loop,
> skip the array, and call the read_sys_metadata_field16() directly with
> build-time check [1][2].  And to improve the readability, reimplement
> the TD_SYSINFO_MAP() [3].
> 
> The new TD_SYSINFO_MAP() isn't perfect.  It requires the function that
> uses it to define a local variable @ret to carry the error code and set
> the initial value to 0.  It also hard-codes the variable name of the
> structure pointer used in the function.  But overall the pros of this
> approach beat the cons.
> 
> Link: https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#m7cfb3c146214d94b24e978eeb8708d92c0b14ac6 [1]
> Link: https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#mbe65f0903ff7835bc418a907f0d02d7a9e0b78be [2]
> Link: https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#m80cde5e6504b3af74d933ea0cbfc3ca9d24697d3 [3]

Probably just one link would suffice, say the permalink to Dan's
comment:

https://lore.kernel.org/kvm/66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch/

> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v2 -> v3:
>  - Remove 'struct field_mapping' and reimplement TD_SYSINFO_MAP().
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 57 ++++++++++++++-----------------------
>  1 file changed, 21 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index e979bf442929..7e75c1b10838 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -270,60 +270,45 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>  	return 0;
>  }
>  
> -static int read_sys_metadata_field16(u64 field_id,
> -				     int offset,
> -				     struct tdx_sys_info_tdmr *ts)
> +static int read_sys_metadata_field16(u64 field_id, u16 *val)
>  {
> -	u16 *ts_member = ((void *)ts) + offset;
>  	u64 tmp;
>  	int ret;
>  
> -	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> -			MD_FIELD_ID_ELE_SIZE_16BIT))
> -		return -EINVAL;
> +	BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> +			MD_FIELD_ID_ELE_SIZE_16BIT);

This gets removed next patch, so why do it

>  
>  	ret = read_sys_metadata_field(field_id, &tmp);
>  	if (ret)
>  		return ret;
>  
> -	*ts_member = tmp;
> +	*val = tmp;
>  
>  	return 0;
>  }
>  
> -struct field_mapping {
> -	u64 field_id;
> -	int offset;
> -};
> -
> -#define TD_SYSINFO_MAP(_field_id, _offset) \
> -	{ .field_id = MD_FIELD_ID_##_field_id,	   \
> -	  .offset   = offsetof(struct tdx_sys_info_tdmr, _offset) }
> -
> -/* Map TD_SYSINFO fields into 'struct tdx_sys_info_tdmr': */
> -static const struct field_mapping fields[] = {
> -	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
> -	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> -	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> -	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> -	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
> -};
> +/*
> + * Assumes locally defined @ret and @sysinfo_tdmr to convey the error
> + * code and the 'struct tdx_sys_info_tdmr' instance to fill out.
> + */
> +#define TD_SYSINFO_MAP(_field_id, _member)						\

"MAP" made sense when it was in a struct whereas
now it is reading.

> +	({										\
> +		if (!ret)								\
> +			ret = read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
> +					&sysinfo_tdmr->_member);			\
> +	})
>  
>  static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
>  {
> -	int ret;
> -	int i;
> +	int ret = 0;
>  
> -	/* Populate 'sysinfo_tdmr' fields using the mapping structure above: */
> -	for (i = 0; i < ARRAY_SIZE(fields); i++) {
> -		ret = read_sys_metadata_field16(fields[i].field_id,
> -						fields[i].offset,
> -						sysinfo_tdmr);
> -		if (ret)
> -			return ret;
> -	}
> +	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs);
> +	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
> +	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
> +	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
> +	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);

Another possibility is to put the macro at the invocation site:

#define READ_SYS_INFO(_field_id, _member)				\
	ret = ret ?: read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
					       &sysinfo_tdmr->_member)

	READ_SYS_INFO(MAX_TDMRS,             max_tdmrs);
	READ_SYS_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
	READ_SYS_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
	READ_SYS_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
	READ_SYS_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);

#undef READ_SYS_INFO

And so on in later patches:

#define READ_SYS_INFO(_field_id, _member)				\
	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
					     &sysinfo_version->_member)

	READ_SYS_INFO(MAJOR_VERSION,    major);
	READ_SYS_INFO(MINOR_VERSION,    minor);
	READ_SYS_INFO(UPDATE_VERSION,   update);
	READ_SYS_INFO(INTERNAL_VERSION, internal);
	READ_SYS_INFO(BUILD_NUM,        build_num);
	READ_SYS_INFO(BUILD_DATE,       build_date);

#undef READ_SYS_INFO


>  
> -	return 0;
> +	return ret;
>  }
>  
>  /* Calculate the actual TDMR size */


