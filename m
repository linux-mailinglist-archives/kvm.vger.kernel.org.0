Return-Path: <kvm+bounces-11954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F61587D7AB
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 01:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B517282D03
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232A64C89;
	Sat, 16 Mar 2024 00:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IjM5n/xp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347BF10FD;
	Sat, 16 Mar 2024 00:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710550192; cv=none; b=kdkk5CSCIh7MA6d0bRDjbyej+jJouDYeNj6E1M74cNPCbca7PfLAb4CXy48v8HhmC2YO5c6r8Dd67OEcKgPeJmJjLjkqut5Q6XSI20tLS7WkgB5fBVbz2AejNA1waPu11F7PzsSZoTK93PndSHxBmqgQ4Jhe3RI3vg1O1VI7RF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710550192; c=relaxed/simple;
	bh=sQQiicBhSeNqbbamPsWA7WiPkkdzlPRuFofio/wpKFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZa3MnVCffYvg2WIk/zkeCzYb3gAUbmBv/ZXiqSoVM4hRAZZ5ct72xVzRyO8Q4IGYP4eqA7e2aT29Xjlsbdr1WI9mOwI5Y0bVXOuFHcs/LcflNjZX7fxvHU8FFHFYuYBzTHIs4GoBq00Ophr1cqbAmtyFY4BoIFMVNC9Jcn+57g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IjM5n/xp; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710550189; x=1742086189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sQQiicBhSeNqbbamPsWA7WiPkkdzlPRuFofio/wpKFk=;
  b=IjM5n/xpi5ksKwq6ZZe/oOHvCxyqAXKGHJ+e71KlAHyzCUOH+D/pvliM
   Ve6uK1FNd0guTJd+gQP/Zv5T4lLDNlaTOOG0udgn7YhlfnJxYf6JadKl+
   jdoqodAxmxysswEk2zvR5Tr7CjfhOjVJg+lIgfTD09Pu6gXN4iyU1JMDe
   j/MZLfUPJZXJjXIksmdT+S7lXFwkoOwrd+Jia5gAr3F4hR+AMx1yr6umj
   VkxCDyn3qJ6ErqF6+S0SUrPOoM1p0lmq3bf/pxB3hLx6+zrNjgHMCsEN2
   KmbAqvNaHOdYbXm3zJgYrPI/N0c4R6ICNAIs257dISSXTJT//9FQfKf3V
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="16087892"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="16087892"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 17:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="17449597"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 17:49:46 -0700
Date: Fri, 15 Mar 2024 17:49:45 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
	peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
	mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, isaku.yamahata@intel.com, jgross@suse.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Message-ID: <20240316004945.GL1258280@ls.amr.corp.intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
 <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>

On Sat, Mar 02, 2024 at 12:20:36AM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> For now the kernel only reads TDMR related global metadata fields for
> module initialization.  All these fields are 16-bits, and the kernel
> only supports reading 16-bits fields.
> 
> KVM will need to read a bunch of non-TDMR related metadata to create and
> run TDX guests.  It's essential to provide a generic metadata read
> infrastructure which supports reading all 8/16/32/64 bits element sizes.
> 
> Extend the metadata read to support reading all these element sizes.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 59 +++++++++++++++++++++++++------------
>  arch/x86/virt/vmx/tdx/tdx.h |  2 --
>  2 files changed, 40 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index eb208da4ff63..4ee4b8cf377c 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -271,23 +271,35 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>  	return 0;
>  }
>  
> -static int read_sys_metadata_field16(u64 field_id,
> -				     int offset,
> -				     void *stbuf)
> +/* Return the metadata field element size in bytes */
> +static int get_metadata_field_bytes(u64 field_id)
>  {
> -	u16 *st_member = stbuf + offset;
> +	/*
> +	 * TDX supports 8/16/32/64 bits metadata field element sizes.
> +	 * TDX module determines the metadata element size based on the
> +	 * "element size code" encoded in the field ID (see the comment
> +	 * of MD_FIELD_ID_ELE_SIZE_CODE macro for specific encodings).
> +	 */
> +	return 1 << MD_FIELD_ID_ELE_SIZE_CODE(field_id);
> +}
> +
> +static int stbuf_read_sys_metadata_field(u64 field_id,
> +					 int offset,
> +					 int bytes,
> +					 void *stbuf)
> +{
> +	void *st_member = stbuf + offset;
>  	u64 tmp;
>  	int ret;
>  
> -	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> -			MD_FIELD_ID_ELE_SIZE_16BIT))
> +	if (WARN_ON_ONCE(get_metadata_field_bytes(field_id) != bytes))
>  		return -EINVAL;
>  
>  	ret = read_sys_metadata_field(field_id, &tmp);
>  	if (ret)
>  		return ret;
>  
> -	*st_member = tmp;
> +	memcpy(st_member, &tmp, bytes);
>  
>  	return 0;
>  }
> @@ -295,11 +307,30 @@ static int read_sys_metadata_field16(u64 field_id,
>  struct field_mapping {
>  	u64 field_id;
>  	int offset;
> +	int size;
>  };
>  
>  #define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
>  	{ .field_id = MD_FIELD_ID_##_field_id,		\
> -	  .offset   = offsetof(_struct, _member) }
> +	  .offset   = offsetof(_struct, _member),	\
> +	  .size     = sizeof(typeof(((_struct *)0)->_member)) }

Because we use compile time constant for _field_id mostly, can we add build
time check? Something like this.

static inline metadata_size_check(u64 field_id, size_t size)
{
        BUILD_BUG_ON(get_metadata_field_bytes(field_id) != size);
}

#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
	{ .field_id = MD_FIELD_ID_##_field_id,		\
	  .offset   = offsetof(_struct, _member),	\
	  .size     = \
		({ size_t s = sizeof(typeof(((_struct *)0)->_member)); \
                metadata_size_check(MD_FIELD_ID_##_field_id, s); \
                s; }) }

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

