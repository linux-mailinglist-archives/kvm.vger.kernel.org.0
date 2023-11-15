Return-Path: <kvm+bounces-1846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 464067ECD5A
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 20:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB1F1B20BC7
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 19:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6E6433C2;
	Wed, 15 Nov 2023 19:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LrS8Wyrp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D871AD;
	Wed, 15 Nov 2023 11:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700076953; x=1731612953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GvYvx+mKWLKYJc2e+pAjgt0Tizth739YSXCTWMvC0Ao=;
  b=LrS8WyrpCfuKe16qWWbksvx4ilHKbnIT5L1XMPJO2SbUL96lZ3n9J4XO
   uchrsGnh8IYpedKUNNE9yHjeRCj2C+xdKjhEUVauEvE6dmV9dOgLv8ExZ
   itb2XNLtVWWuCASfp2nN2dXECogsBjj6WHrPOM9E+pEupnqjnP8nXOeZw
   gJBp8W6rKBVgTzK6UF6IVqIuPmPkpHnNOMu4RUFWCCt5fu83a6X7EMCIE
   jgZbuuPJFU7TuWW9EbDqnnrl7WoX9VZNym7ofD+vEazJ25i8hLgzvFdFI
   JbgRM4+zgFws8MyKzUKSn+8BKn8r65+sv1EwbYfbQMi+dWGJ4xWquQqEJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="477162383"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="477162383"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 11:35:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="794256178"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="794256178"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 11:35:51 -0800
Date: Wed, 15 Nov 2023 11:35:50 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
	peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de,
	bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
	dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
	isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
	bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v15 09/23] x86/virt/tdx: Get module global metadata for
 module initialization
Message-ID: <20231115193550.GC1109547@ls.amr.corp.intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
 <30906e3cf94fe48d713de21a04ffd260bd1a7268.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <30906e3cf94fe48d713de21a04ffd260bd1a7268.1699527082.git.kai.huang@intel.com>

On Fri, Nov 10, 2023 at 12:55:46AM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> The TDX module global metadata provides system-wide information about
> the module.  The TDX module provides SEAMCALls to allow the kernel to
> query one specific global metadata field (entry) or all fields.
> 
> TL;DR:
> 
> Use the TDH.SYS.RD SEAMCALL to read the essential global metadata for
> module initialization, and at the same time, to only initialize TDX
> module with version 1.5 and later.
> 
> Long Version:
> 
> 1) Only initialize TDX module with version 1.5 and later
> 
> TDX module 1.0 has some compatibility issues with the later versions of
> module, as documented in the "Intel TDX module ABI incompatibilities
> between TDX1.0 and TDX1.5" spec.  Basically there's no value to use TDX
> module 1.0 when TDX module 1.5 and later versions are already available.
> To keep things simple, just support initializing the TDX module 1.5 and
> later.
> 
> 2) Get the essential global metadata for module initialization
> 
> TDX reports a list of "Convertible Memory Region" (CMR) to tell the
> kernel which memory is TDX compatible.  The kernel needs to build a list
> of memory regions (out of CMRs) as "TDX-usable" memory and pass them to
> the TDX module.  The kernel does this by constructing a list of "TD
> Memory Regions" (TDMRs) to cover all these memory regions and passing
> them to the TDX module.
> 
> Each TDMR is a TDX architectural data structure containing the memory
> region that the TDMR covers, plus the information to track (within this
> TDMR): a) the "Physical Address Metadata Table" (PAMT) to track each TDX
> memory page's status (such as which TDX guest "owns" a given page, and
> b) the "reserved areas" to tell memory holes that cannot be used as TDX
> memory.
> 
> The kernel needs to get below metadata from the TDX module to build the
> list of TDMRs: a) the maximum number of supported TDMRs, b) the maximum
> number of supported reserved areas per TDMR and, c) the PAMT entry size
> for each TDX-supported page size.
> 
> Note the TDX module internally checks whether the "TDX-usable" memory
> regions passed via TDMRs are truly convertible.  Just skipping reading
> the CMRs and manually checking memory regions against them, but let the
> TDX module do the check.
> 
> == Implementation ==
> 
> TDX module 1.0 uses TDH.SYS.INFO SEAMCALL to report the global metadata
> in a fixed-size (1024-bytes) structure 'TDSYSINFO_STRUCT'.  TDX module
> 1.5 adds more metadata fields, and introduces the new TDH.SYS.{RD|RDALL}
> SEAMCALLs for reading the metadata.  The new metadata mechanism removes
> the fixed-size limitation of the structure 'TDSYSINFO_STRUCT' and allows
> the TDX module to support unlimited number of metadata fields.
> 
> TDX module 1.5 and later versions still support the TDH.SYS.INFO for
> compatibility to the TDX module 1.0, but it may only report part of
> metadata via the 'TDSYSINFO_STRUCT'.  For any new metadata the kernel
> must use TDH.SYS.{RD|RDALL} to read.
> 
> To achieve the above two goals mentioned in 1) and 2), just use the
> TDH.SYS.RD to read the essential metadata fields related to the TDMRs.
> 
> TDH.SYS.RD returns *one* metadata field at a given "Metadata Field ID".
> It is enough for getting these few fields for module initialization.
> On the other hand, TDH.SYS.RDALL reports all metadata fields to a 4KB
> buffer provided by the kernel which is a little bit overkill here.
> 
> It may be beneficial to get all metadata fields at once here so they can
> also be used by KVM (some are essential for creating basic TDX guests),
> but technically it's unknown how many 4K pages are needed to fill all
> the metadata.  Thus it's better to read metadata when needed.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v14 -> v15:
>  - New patch to use TDH.SYS.RD to read TDX module global metadata for
>    module initialization and stop initializing 1.0 module.
> 
> ---
>  arch/x86/include/asm/shared/tdx.h |  1 +
>  arch/x86/virt/vmx/tdx/tdx.c       | 75 ++++++++++++++++++++++++++++++-
>  arch/x86/virt/vmx/tdx/tdx.h       | 39 ++++++++++++++++
>  3 files changed, 114 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
> index a4036149c484..fdfd41511b02 100644
> --- a/arch/x86/include/asm/shared/tdx.h
> +++ b/arch/x86/include/asm/shared/tdx.h
> @@ -59,6 +59,7 @@
>  #define TDX_PS_4K	0
>  #define TDX_PS_2M	1
>  #define TDX_PS_1G	2
> +#define TDX_PS_NR	(TDX_PS_1G + 1)
>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index d1affb30f74d..d24027993983 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -235,8 +235,75 @@ static int build_tdx_memlist(struct list_head *tmb_list)
>  	return ret;
>  }
>  
> +static int read_sys_metadata_field(u64 field_id, u64 *data)
> +{
> +	struct tdx_module_args args = {};
> +	int ret;
> +
> +	/*
> +	 * TDH.SYS.RD -- reads one global metadata field
> +	 *  - RDX (in): the field to read
> +	 *  - R8 (out): the field data
> +	 */
> +	args.rdx = field_id;
> +	ret = seamcall_prerr_ret(TDH_SYS_RD, &args);
> +	if (ret)
> +		return ret;
> +
> +	*data = args.r8;
> +
> +	return 0;
> +}
> +
> +static int read_sys_metadata_field16(u64 field_id, u16 *data)
> +{
> +	u64 _data;
> +	int ret;
> +
> +	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> +			MD_FIELD_ID_ELE_SIZE_16BIT))
> +		return -EINVAL;
> +
> +	ret = read_sys_metadata_field(field_id, &_data);
> +	if (ret)
> +		return ret;
> +
> +	*data = (u16)_data;
> +
> +	return 0;
> +}
> +
> +static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
> +{
> +	int ret;
> +
> +	ret = read_sys_metadata_field16(MD_FIELD_ID_MAX_TDMRS,
> +			&tdmr_sysinfo->max_tdmrs);
> +	if (ret)
> +		return ret;
> +
> +	ret = read_sys_metadata_field16(MD_FIELD_ID_MAX_RESERVED_PER_TDMR,
> +			&tdmr_sysinfo->max_reserved_per_tdmr);
> +	if (ret)
> +		return ret;
> +
> +	ret = read_sys_metadata_field16(MD_FIELD_ID_PAMT_4K_ENTRY_SIZE,
> +			&tdmr_sysinfo->pamt_entry_size[TDX_PS_4K]);
> +	if (ret)
> +		return ret;
> +
> +	ret = read_sys_metadata_field16(MD_FIELD_ID_PAMT_2M_ENTRY_SIZE,
> +			&tdmr_sysinfo->pamt_entry_size[TDX_PS_2M]);
> +	if (ret)
> +		return ret;
> +
> +	return read_sys_metadata_field16(MD_FIELD_ID_PAMT_1G_ENTRY_SIZE,
> +			&tdmr_sysinfo->pamt_entry_size[TDX_PS_1G]);
> +}
> +

Now we don't query the versions, build info, attributes, and etc.  Because it's
important to know its version/attributes, can we query and print them
as before? Maybe with another path.
In long term, those info would be exported via sysfs, though.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

