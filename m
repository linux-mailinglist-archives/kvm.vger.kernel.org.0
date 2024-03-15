Return-Path: <kvm+bounces-11917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC1387D122
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:23:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 675221F24136
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 16:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D950E45970;
	Fri, 15 Mar 2024 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EubmOCNM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA9446BA;
	Fri, 15 Mar 2024 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710519778; cv=none; b=JAK5EOh2b2AamqtucG9qsnoTs+a6siTiPocw0G0z7Y3wnQ6XFIjgb5c1kz/eBGK5Q44hulE0PWig973kAWfiCcBkEG7fkZzotRZEbFrlz83rpJordDw1IqSYDkTvNelGRvgmkHYmm9RlGlNqdf1qotCWc3qc21OqE8gjYVjs9iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710519778; c=relaxed/simple;
	bh=lngc63T678kArJFG5DVBRqDftjyrgzERehYJN68mKOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5aSz1mJ+kmwsmalCrDXnU5+DqyYNTFAiZLNDbREqADjeC4R6WOCSETVjK7kg4QoOm//7ye5Prko1Hdgjkgp3EGabU/BkUfBxSw0xGnir0HNwh0pzPXYAZwjHmzcVLc6vSPXgmfR5n9pd9+IVKKoV700kQX6oryIZThU5Vzg2PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EubmOCNM; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710519776; x=1742055776;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lngc63T678kArJFG5DVBRqDftjyrgzERehYJN68mKOM=;
  b=EubmOCNMgzjOcoqS0FoLhv3siheocDs1VGbqA/ThyiaBJygYLWh41PZ/
   7M6p4d8eLkS6FWb6rqLgdpKYtzGnYyFVAx3+ccEtzvQeGyJI47tCSBs83
   +ZUNcxCt/UckKcwhKOmmZ2llOaPdWQCPyPgbnygJe3egldBVd1SICsvhX
   GxVWDVAKrHuGUtJC1q4g0H4WWCjO8DhEvv5bGiQk/zWuU8jz+KCs5z/UF
   r0oB7yGv/SLoWnrGyd8wUYV2Nm/GkAbdYe/IUgko5DKjlH1aF8NLR8jxw
   v5NGgsTHPGRN1vHLW0Het2tFDEoFpss1VLGQkJ27zseZ77nCBnKLSDbXK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5258725"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="5258725"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 09:22:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="17186557"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 09:22:55 -0700
Date: Fri, 15 Mar 2024 09:22:55 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
Message-ID: <20240315162255.GG1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
 <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>

On Fri, Mar 15, 2024 at 12:09:29PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> > +struct tdx_info {
> > +	u64 features0;
> > +	u64 attributes_fixed0;
> > +	u64 attributes_fixed1;
> > +	u64 xfam_fixed0;
> > +	u64 xfam_fixed1;
> > +
> > +	u16 num_cpuid_config;
> > +	/* This must the last member. */
> > +	DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
> > +};
> > +
> > +/* Info about the TDX module. */
> > +static struct tdx_info *tdx_info;
> > +
> >   #define TDX_MD_MAP(_fid, _ptr)			\
> >   	{ .fid = MD_FIELD_ID_##_fid,		\
> >   	  .ptr = (_ptr), }
> > @@ -66,7 +81,7 @@ static size_t tdx_md_element_size(u64 fid)
> >   	}
> >   }
> > -static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> > +static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> >   {
> >   	struct tdx_md_map *m;
> >   	int ret, i;
> > @@ -84,9 +99,26 @@ static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> >   	return 0;
> >   }
> > +#define TDX_INFO_MAP(_field_id, _member)			\
> > +	TD_SYSINFO_MAP(_field_id, struct tdx_info, _member)
> > +
> >   static int __init tdx_module_setup(void)
> >   {
> > +	u16 num_cpuid_config;
> >   	int ret;
> > +	u32 i;
> > +
> > +	struct tdx_md_map mds[] = {
> > +		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
> > +	};
> > +
> > +	struct tdx_metadata_field_mapping fields[] = {
> > +		TDX_INFO_MAP(FEATURES0, features0),
> > +		TDX_INFO_MAP(ATTRS_FIXED0, attributes_fixed0),
> > +		TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
> > +		TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
> > +		TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
> > +	};
> >   	ret = tdx_enable();
> >   	if (ret) {
> > @@ -94,7 +126,48 @@ static int __init tdx_module_setup(void)
> >   		return ret;
> >   	}
> > +	ret = tdx_md_read(mds, ARRAY_SIZE(mds));
> > +	if (ret)
> > +		return ret;
> > +
> > +	tdx_info = kzalloc(sizeof(*tdx_info) +
> > +			   sizeof(*tdx_info->cpuid_configs) * num_cpuid_config,
> > +			   GFP_KERNEL);
> > +	if (!tdx_info)
> > +		return -ENOMEM;
> > +	tdx_info->num_cpuid_config = num_cpuid_config;
> > +
> > +	ret = tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdx_info);
> > +	if (ret)
> > +		goto error_out;
> > +
> > +	for (i = 0; i < num_cpuid_config; i++) {
> > +		struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
> > +		u64 leaf, eax_ebx, ecx_edx;
> > +		struct tdx_md_map cpuids[] = {
> > +			TDX_MD_MAP(CPUID_CONFIG_LEAVES + i, &leaf),
> > +			TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2, &eax_ebx),
> > +			TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2 + 1, &ecx_edx),
> > +		};
> > +
> > +		ret = tdx_md_read(cpuids, ARRAY_SIZE(cpuids));
> > +		if (ret)
> > +			goto error_out;
> > +
> > +		c->leaf = (u32)leaf;
> > +		c->sub_leaf = leaf >> 32;
> > +		c->eax = (u32)eax_ebx;
> > +		c->ebx = eax_ebx >> 32;
> > +		c->ecx = (u32)ecx_edx;
> > +		c->edx = ecx_edx >> 32;
> 
> OK I can see why you don't want to use ...
> 
> 	struct tdx_metadata_field_mapping fields[] = {
> 		TDX_INFO_MAP(NUM_CPUID_CONFIG, num_cpuid_config),
> 	};
> 
> ... to read num_cpuid_config first, because the memory to hold @tdx_info
> hasn't been allocated, because its size depends on the num_cpuid_config.
> 
> And I confess it's because the tdx_sys_metadata_field_read() that got
> exposed in patch ("x86/virt/tdx: Export global metadata read
> infrastructure") only returns 'u64' for all metadata field, and you didn't
> want to use something like this:
> 
> 	u64 num_cpuid_config;
> 	
> 	tdx_sys_metadata_field_read(..., &num_cpuid_config);
> 
> 	...
> 
> 	tdx_info->num_cpuid_config = num_cpuid_config;
> 
> Or you can explicitly cast:
> 
> 	tdx_info->num_cpuid_config = (u16)num_cpuid_config;
> 
> (I know people may don't like the assigning 'u64' to 'u16', but it seems
> nothing wrong to me, because the way done in (1) below effectively has the
> same result comparing to type case).
> 
> But there are other (better) ways to do:
> 
> 1) you can introduce a helper as suggested by Xiaoyao in [*]:
> 
> 
> 	int tdx_sys_metadata_read_single(u64 field_id,
> 					int bytes,  void *buf)
> 	{
> 		return stbuf_read_sys_metadata_field(field_id, 0,
> 						bytes, buf);
> 	}
> 
> And do:
> 
> 	tdx_sys_metadata_read_single(NUM_CPUID_CONFIG,
> 		sizeof(num_cpuid_config), &num_cpuid_config);
> 
> That's _much_ cleaner than the 'struct tdx_md_map', which only confuses
> people.
> 
> But I don't think we need to do this as mentioned above -- we just do type
> cast.
> 
> 2) You can just preallocate enough memory.  It cannot be larger than 1024B,
> right?  You can even just allocate one page.  It's just 4K, no one cares.
> 
> Then you can do:
> 
> 	struct tdx_metadata_field_mapping tdx_info_fields = {
> 		...
> 		TDX_INFO_MAP(NUM_CPUID_CONFIG, num_cpuid_config),
> 	};
> 
> 	tdx_sys_metadata_read(tdx_info_fields,
> 			ARRAY_SIZE(tdx_info_fields, tdx_info);
> 
> And then you read the CPUID_CONFIG array one by one using the same 'struct
> tdx_metadata_field_mapping' and tdx_sys_metadata_read():
> 
> 
> 	for (i = 0; i < tdx_info->num_cpuid_config; i++) {
> 		struct tdx_metadata_field_mapping cpuid_fields = {
> 			TDX_CPUID_CONFIG_MAP(CPUID_CONFIG_LEAVES + i,
> 						leaf),
> 			...
> 		};
> 		struct kvm_tdx_cpuid_config *c =
> 				&tdx_info->cpuid_configs[i];
> 
> 		tdx_sys_metadata_read(cpuid_fields,
> 				ARRAY_SIZE(cpuid_fields), c);
> 
> 		....
> 	}
> 
> So stopping having the duplicated 'struct tdx_md_map' and related staff, as
> they are absolutely unnecessary and only confuses people.


Ok, I'll rewrite the code to use tdx_sys_metadata_read() by introducng
tentative struct in a function scope.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

