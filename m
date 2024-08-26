Return-Path: <kvm+bounces-25057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 234E895F544
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 17:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DD681F22751
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 15:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC88193416;
	Mon, 26 Aug 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UrMMyaLz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E50153812;
	Mon, 26 Aug 2024 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724686723; cv=none; b=fuYeKXVk0jR9RuH5fGoQG9O4Fv4ydM5RBWeJHx3tXtUgeWcZpO4CoZ73vjQYB+oSK4UP4M6vLQN/2K+yOye6gLrjNMXKiWDyi8jkdpGBGpYAQ9vSH+KWhOPPLZ02sJmLqqSe40NUPPPRyEATH4V6l4Ip0DgNIn+3sCfAhB27XhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724686723; c=relaxed/simple;
	bh=reqE2nlzaPtBX5zRYpjXeyzr7y7rrdXASpCd2pGylKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGT1YFJY7D0olSYfaCfhUHg+S+xdVo4OBUI7pXXxlGl6VGsFagDvHjLTJ3OKFWxOkRutDjmhXsDZGh0ywcyRN0ymD7bnHhqd3+Bc7W86QAxx/Rr26xUmbVoKBwjaxOrMFbUdX060dmi/p+MwKh3mVekMjMNqvXP9br8vuUzdVFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UrMMyaLz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724686721; x=1756222721;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=reqE2nlzaPtBX5zRYpjXeyzr7y7rrdXASpCd2pGylKs=;
  b=UrMMyaLztBMBy2MxIVAysBrtLe+I+zYVIXSf61a33+O9omK2rf4S88Ha
   p4GLo4IVXOsIEV6/WULOEaTR4QHav1YsypxGVhD2sktTEwcZtMvG5J4VB
   cA+d+GzoVVE7jBZIktp/q834ixqGt/kf7yFTQagPPpi83UuJnYB1UgMba
   daJUGk0X5WYmJWcNHDfnXpsaaf4ndBVQVN0rLkPcladh6e0PLHx+C2U0g
   Z4dm+VRqEMMnWxyvROYQCqYEMQBD2MXJSkabXvZrxOuYYKQv8n40EZVeF
   nTJUlq+jKs4AapOxv3xpR6OxhQxsqulBPbxcBITdgSIrfPjXD6K6/r4/Y
   w==;
X-CSE-ConnectionGUID: zTQ37vPoQ7G7zCt5Vz9uBg==
X-CSE-MsgGUID: aq6UloJ+Q96MS7DbX7ioxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34275443"
X-IronPort-AV: E=Sophos;i="6.10,177,1719903600"; 
   d="scan'208";a="34275443"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 08:38:41 -0700
X-CSE-ConnectionGUID: W6pplc1lSGKmzafFv+bB0w==
X-CSE-MsgGUID: n5D4oaD2SBCYw6yCXYgRqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,177,1719903600"; 
   d="scan'208";a="62542822"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.0.178])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 08:38:34 -0700
Message-ID: <a107b067-861d-43f4-86b5-29271cb93dad@intel.com>
Date: Mon, 26 Aug 2024 18:38:28 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
 <dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
 "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
 <peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>
Cc: "Gao, Chao" <chao.gao@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
 <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
 <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
 <7b65b317-397d-4a72-beac-6b0140b1d8dd@intel.com>
 <66b178d4cfae4_4fc72944b@dwillia2-xfh.jf.intel.com.notmuch>
 <96c248b790907b14efcb0885c78e4000ba5b9694.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <96c248b790907b14efcb0885c78e4000ba5b9694.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/08/24 15:09, Huang, Kai wrote:
> On Mon, 2024-08-05 at 18:13 -0700, Dan Williams wrote:
>> Huang, Kai wrote:
>> [..]
>>>> The unrolled loop is the same amount of work as maintaining @fields.
>>>
>>> Hi Dan,
>>>
>>> Thanks for the feedback.
>>>
>>> AFAICT Dave didn't like this way:
>>>
>>> https://lore.kernel.org/lkml/cover.1699527082.git.kai.huang@intel.com/T/#me6f615d7845215c278753b57a0bce1162960209d
>>
>> I agree with Dave that the original was unreadable. However, I also
>> think he glossed over the loss of type-safety and the silliness of
>> defining an array to precisely map fields only to turn around and do a
>> runtime check that the statically defined array was filled out
>> correctly. So I think lets solve the readability problem *and* make the
>> array definition identical in appearance to unrolled type-safe
>> execution, something like (UNTESTED!):
>>
>>
> [...]
> 
>> +/*
>> + * Assumes locally defined @ret and @ts to convey the error code and the
>> + * 'struct tdx_tdmr_sysinfo' instance to fill out
>> + */
>> +#define TD_SYSINFO_MAP(_field_id, _offset)                              \
>> +	({                                                              \
>> +		if (ret == 0)                                           \
>> +			ret = read_sys_metadata_field16(                \
>> +				MD_FIELD_ID_##_field_id, &ts->_offset); \
>> +	})
>> +
> 
> We need to support u16/u32/u64 metadata field sizes, but not just u16.
> 
> E.g.:
> 
> struct tdx_sysinfo_module_info {                                        
>         u32 sys_attributes;                                             
>         u64 tdx_features0;                                              
> };
> 
> has both u32 and u64 in one structure.
> 
> To achieve type-safety for all field sizes, I think we need one helper
> for each field size.  E.g.,
> 
> #define READ_SYSMD_FIELD_FUNC(_size)                            \
> static inline int                                               \
> read_sys_metadata_field##_size(u64 field_id, u##_size *data)    \
> {                                                               \
>         u64 tmp;                                                \
>         int ret;                                                \
>                                                                 \
>         ret = read_sys_metadata_field(field_id, &tmp);          \
>         if (ret)                                                \
>                 return ret;                                     \
>                                                                 \
>         *data = tmp;                                            \
>         return 0;                                               \
> }                                                                       
> 
> /* For now only u16/u32/u64 are needed */
> READ_SYSMD_FIELD_FUNC(16)                                               
> READ_SYSMD_FIELD_FUNC(32)                                               
> READ_SYSMD_FIELD_FUNC(64)                                               
> 
> Is this what you were thinking?
> 
> (Btw, I recall that I tried this before for internal review, but AFAICT
> Dave didn't like this.)
> 
> For the build time check as you replied to the next patch, I agree it's
> better than the runtime warning check as done in the current code.
> 
> If we still use the type-less 'void *stbuf' function to read metadata
> fields for all sizes, then I think we can do below:
> 
> /*
>  * Read one global metadata field and store the data to a location of a 
>  * given buffer specified by the offset and size (in bytes).            
>  */
> static int stbuf_read_sysmd_field(u64 field_id, void *stbuf, int offset,
>                                   int size)                             
> {       
>         void *member = stbuf + offset;                                  
>         u64 tmp;                                                        
>         int ret;                                                        
> 
>         ret = read_sys_metadata_field(field_id, &tmp);                  
>         if (ret)
>                 return ret;                                             
>         
>         memcpy(member, &tmp, size);                                     
>         
>         return 0;                                                       
> }                                                                       
> 
> /* Wrapper to read one metadata field to u8/u16/u32/u64 */              
> #define stbuf_read_sysmd_single(_field_id, _pdata)      \
>         stbuf_read_sysmd_field(_field_id, _pdata, 0, 	\
> 		sizeof(typeof(*(_pdata)))) 
> 
> #define CHECK_MD_FIELD_SIZE(_field_id, _st, _member)    \
>         BUILD_BUG_ON(MD_FIELD_ELE_SIZE(MD_FIELD_ID_##_field_id) != \
>                         sizeof(_st->_member))
> 
> #define TD_SYSINFO_MAP_TEST(_field_id, _st, _member)                    \
>         ({                                                              \
>                 if (ret) {                                              \
>                         CHECK_MD_FIELD_SIZE(_field_id, _st, _member);   \
>                         ret = stbuf_read_sysmd_single(                  \
>                                         MD_FIELD_ID_##_field_id,        \
>                                         &_st->_member);                 \
>                 }                                                       \
>          })
> 
> static int get_tdx_module_info(struct tdx_sysinfo_module_info *modinfo)
> {
>         int ret = 0;
> 
> #define TD_SYSINFO_MAP_MOD_INFO(_field_id, _member)     \
>         TD_SYSINFO_MAP_TEST(_field_id, modinfo, _member)
> 
>         TD_SYSINFO_MAP_MOD_INFO(SYS_ATTRIBUTES, sys_attributes);
>         TD_SYSINFO_MAP_MOD_INFO(TDX_FEATURES0,  tdx_features0);
> 
>         return ret;
> }
> 
> With the build time check above, I think it's OK to lose the type-safe
> inside the stbuf_read_sysmd_field(), and the code is simpler IMHO.
> 
> Any comments?

BUILD_BUG_ON() requires a function, but it is still
be possible to add a build time check in TD_SYSINFO_MAP
e.g.

#define TD_SYSINFO_CHECK_SIZE(_field_id, _size)			\
	__builtin_choose_expr(MD_FIELD_ELE_SIZE(_field_id) == _size, _size, (void)0)

#define _TD_SYSINFO_MAP(_field_id, _offset, _size)		\
	{ .field_id = _field_id,				\
	  .offset   = _offset,					\
	  .size	    = TD_SYSINFO_CHECK_SIZE(_field_id, _size) }

#define TD_SYSINFO_MAP(_field_id, _struct, _member)		\
	_TD_SYSINFO_MAP(MD_FIELD_ID_##_field_id,		\
			offsetof(_struct, _member),		\
			sizeof(typeof(((_struct *)0)->_member)))



