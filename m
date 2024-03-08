Return-Path: <kvm+bounces-11364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0539A875F86
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 09:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 996C31F21D9E
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF195208A3;
	Fri,  8 Mar 2024 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQwJWNDO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BDC846C;
	Fri,  8 Mar 2024 08:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709886721; cv=none; b=MHQnrkuauVPxzJiDRYGqLe2ZRKaYcatDTDFMEh0GqWgYuQlfD83kXU91sRXtsvucKTajPs7mCFiY19hpFeH1Z/0wO2N6/cNvYmOjzTMr2kJput/Gfcf9n64NIAqeXvV+TEsEN6lLR/jY+b7pQJ6kO7cfrlm2sHTYvy1XOL0UI3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709886721; c=relaxed/simple;
	bh=VHPu8e8Le9aHrIgBfTFS9cP5IuSy27McirEOhMqWaZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etiOQY66vdhaOxoND8oJDwe+HcgOphHzsfNTOaeP4GT9e/QDsLTbR9Cr1rPJxwhCqzOKGVeXh0qZ3GUyZJVpXFZJePch3Q5BbBBmoylSXLUw8F0Npm0NCobXzgWemLs7G8YpRyjXqAqrUqdYl62cBEOlW1rYlVmjeALu/52OobQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQwJWNDO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709886720; x=1741422720;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VHPu8e8Le9aHrIgBfTFS9cP5IuSy27McirEOhMqWaZ8=;
  b=hQwJWNDOd0OcGvLHL71ZN9DQYKrUEB39wLY4VZZhlc5LSp3SnnTBfcxi
   ZVx8k3lON0Cl0zQebabbk0Ajle/+U92Axhfv7jLtjVsnw4Mz1Z20PnMkX
   54TBkZEn8fjCo5DRjs3xTxnDSqzbZO3ydbzC4uqFe5BYcrW/u3ywspMd8
   K6kMGYB6EqKj7+b3l+v/Q0Qe2dtC15XYnLDSIOnBkM4v5CXnWdzJP1C1t
   WjCPsX757ezZ4yr88SgQqsN1to0scvqbTJCr0NQ/IyCc4o6eenBzVoAoY
   +VEj08MvY2nFwYnZClATB/Lzpa2rPEon8bz9CsmNcmXJlKqgHilhAlMbo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="22050026"
X-IronPort-AV: E=Sophos;i="6.07,109,1708416000"; 
   d="scan'208";a="22050026"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 00:31:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,109,1708416000"; 
   d="scan'208";a="33546033"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 00:31:55 -0800
Message-ID: <3d331d15-bcbf-412e-be50-9bd80715b1a2@linux.intel.com>
Date: Fri, 8 Mar 2024 16:31:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 005/130] x86/virt/tdx: Export global metadata read
 infrastructure
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eec524e07ee17961a4deb1cc7a1390c91d8708ff.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <eec524e07ee17961a4deb1cc7a1390c91d8708ff.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Kai Huang <kai.huang@intel.com>
>
> KVM will need to read a bunch of non-TDMR related metadata to create and
> run TDX guests.  Export the metadata read infrastructure for KVM to use.
>
> Specifically, export two helpers:
>
> 1) The helper which reads multiple metadata fields to a buffer of a
>     structure based on the "field ID -> structure member" mapping table.
>
> 2) The low level helper which just reads a given field ID.
>
> The two helpers cover cases when the user wants to cache a bunch of
> metadata fields to a certain structure and when the user just wants to
> query a specific metadata field on demand.  They are enough for KVM to
> use (and also should be enough for other potential users).
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/tdx.h  | 22 ++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++-----------------
>   2 files changed, 30 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index eba178996d84..709b9483f9e4 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -116,6 +116,28 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
>   int tdx_cpu_enable(void);
>   int tdx_enable(void);
>   const char *tdx_dump_mce_info(struct mce *m);
> +
> +struct tdx_metadata_field_mapping {
> +	u64 field_id;
> +	int offset;
> +	int size;
> +};
> +
> +#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
> +	{ .field_id = MD_FIELD_ID_##_field_id,		\
> +	  .offset   = offsetof(_struct, _member),	\
> +	  .size     = sizeof(typeof(((_struct *)0)->_member)) }
> +
> +/*
> + * Read multiple global metadata fields to a buffer of a structure
> + * based on the "field ID -> structure member" mapping table.
> + */
> +int tdx_sys_metadata_read(const struct tdx_metadata_field_mapping *fields,
> +			  int nr_fields, void *stbuf);
> +
> +/* Read a single global metadata field */
> +int tdx_sys_metadata_field_read(u64 field_id, u64 *data);
> +
>   #else
>   static inline void tdx_init(void) { }
>   static inline int tdx_cpu_enable(void) { return -ENODEV; }
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index a19adc898df6..dc21310776ab 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -251,7 +251,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
>   	return ret;
>   }
>   
> -static int read_sys_metadata_field(u64 field_id, u64 *data)
> +int tdx_sys_metadata_field_read(u64 field_id, u64 *data)
>   {
>   	struct tdx_module_args args = {};
>   	int ret;
> @@ -270,6 +270,7 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>   
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(tdx_sys_metadata_field_read);
>   
>   /* Return the metadata field element size in bytes */
>   static int get_metadata_field_bytes(u64 field_id)
> @@ -295,7 +296,7 @@ static int stbuf_read_sys_metadata_field(u64 field_id,
>   	if (WARN_ON_ONCE(get_metadata_field_bytes(field_id) != bytes))
>   		return -EINVAL;
>   
> -	ret = read_sys_metadata_field(field_id, &tmp);
> +	ret = tdx_sys_metadata_field_read(field_id, &tmp);
>   	if (ret)
>   		return ret;
>   
> @@ -304,19 +305,8 @@ static int stbuf_read_sys_metadata_field(u64 field_id,
>   	return 0;
>   }
>   
> -struct field_mapping {
> -	u64 field_id;
> -	int offset;
> -	int size;
> -};
> -
> -#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
> -	{ .field_id = MD_FIELD_ID_##_field_id,		\
> -	  .offset   = offsetof(_struct, _member),	\
> -	  .size     = sizeof(typeof(((_struct *)0)->_member)) }
> -
> -static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
> -			     void *stbuf)
> +int tdx_sys_metadata_read(const struct tdx_metadata_field_mapping *fields,
> +			  int nr_fields, void *stbuf)
>   {
>   	int i, ret;
>   
> @@ -331,6 +321,7 @@ static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
>   
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(tdx_sys_metadata_read);
>   
>   #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
>   	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
> @@ -338,7 +329,7 @@ static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
>   static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>   {
>   	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> -	const struct field_mapping fields[] = {
> +	const struct tdx_metadata_field_mapping fields[] = {
>   		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
>   		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
>   		TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> @@ -347,7 +338,7 @@ static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>   	};
>   
>   	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
> -	return read_sys_metadata(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
> +	return tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
>   }
>   
>   /* Calculate the actual TDMR size */


