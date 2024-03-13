Return-Path: <kvm+bounces-11713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E40E487A1F7
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 04:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1420B1C21882
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 03:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BEB10965;
	Wed, 13 Mar 2024 03:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mr0JILKU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426EEC13D;
	Wed, 13 Mar 2024 03:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710301457; cv=none; b=l8ZOJES6o+qCb8+Cfplh337gJvZXl4pu07c5WUaaTcPDM3hq7VaMwGeqaXHMe45GcqwIkkxkWR6vAdX4r26Hc+44kxI+tSRa0tGSHOfnWWcZrtO50XuNuQEUxZzY8JabxZaTHf239tl8v9sRV8XMWXRMALSStgN9FI9YU+Ur/r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710301457; c=relaxed/simple;
	bh=D5dYzAQq3zwc2Ykhfu8CArrsHZ7nFWtA6rWbqjK8AYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dJzXw4gxEd1NFSmEfynj2VkslKhuTZoiUf+7EL90TbAVdWCpS+XEe4A1tfexcVbgCljUyE1sH9GsIdiQbiNUyEGh9d54B5KDaUeaWoIHnTr5K365QJKBoUBUfVaeiNMHY5U1eI7SCXWrFdP8f0fa5ZaygpDe+cAy4QiZQRNO7KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mr0JILKU; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710301456; x=1741837456;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D5dYzAQq3zwc2Ykhfu8CArrsHZ7nFWtA6rWbqjK8AYg=;
  b=Mr0JILKU/4IBk7etTDAbVocvOmvvkEGoGbBq9V5ltC2yOQagGPCaNTrP
   JYO+sa5Y+nDPr4O91LWRJ10g4Iq3haIGsFu5PR5zYwBJRW5h7rwquJVbV
   jOcgXaHDWPsTRPZl+mI2Vt+1bpV1DUxz0MfS/hMGbP/B6taZ6dlUOWjbV
   UsGYUw5Dzd17pkVa5jQn0suOHiHwgIjkC6RTTAGY6btVxCZdagdTUYET5
   oLfpE5eZZ+ddd5mgWxKUrz6xFXlOtI5Zptq0SrBQLmk3wrWo04xngBePb
   eSIcN3YklWIXQ7WX5cAVGhuNuZm6bTsuj78kdpTJ1qspjBKMQBwiMh1AT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="4911377"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="4911377"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 20:44:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="11661215"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 20:44:11 -0700
Message-ID: <bd61e29d-5842-4136-b30f-929b00bdf6f9@intel.com>
Date: Wed, 13 Mar 2024 11:44:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Content-Language: en-US
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 isaku.yamahata@intel.com, jgross@suse.com
References: <cover.1709288433.git.kai.huang@intel.com>
 <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/2024 7:20 PM, Kai Huang wrote:
> KVM will need to read a bunch of non-TDMR related metadata to create and
> run TDX guests.  Export the metadata read infrastructure for KVM to use.
> 
> Specifically, export two helpers:
> 
> 1) The helper which reads multiple metadata fields to a buffer of a
>     structure based on the "field ID -> structure member" mapping table.
> 
> 2) The low level helper which just reads a given field ID.

How about introducing a helper to read a single metadata field comparing 
to 1) instead of the low level helper.

The low level helper tdx_sys_metadata_field_read() requires the data buf 
to be u64 *. So the caller needs to use a temporary variable and handle 
the memcpy when the field is less than 8 bytes.

so why not expose a high level helper to read single field, e.g.,

+int tdx_sys_metadata_read_single(u64 field_id, int bytes, void *buf)
+{
+       return stbuf_read_sys_metadata_field(field_id, 0, bytes, buf);
+}
+EXPORT_SYMBOL_GPL(tdx_sys_metadata_read_single);

> The two helpers cover cases when the user wants to cache a bunch of
> metadata fields to a certain structure and when the user just wants to
> query a specific metadata field on demand.  They are enough for KVM to
> use (and also should be enough for other potential users).
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
> index 4ee4b8cf377c..dc21310776ab 100644
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
> -static int read_sys_metadata(const struct field_mapping *fields, int nr_fields,
> -			     void *stbuf)
> +int tdx_sys_metadata_read(const struct tdx_metadata_field_mapping *fields,
> +			  int nr_fields, void *stbuf)
>   {
>   	int i, ret;
>   
> @@ -331,6 +321,7 @@ static int read_sys_metadata(const struct field_mapping *fields, int nr_fields,
>   
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(tdx_sys_metadata_read);
>   
>   #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
>   	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
> @@ -338,7 +329,7 @@ static int read_sys_metadata(const struct field_mapping *fields, int nr_fields,
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


