Return-Path: <kvm+bounces-6249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E95C82DB8F
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 15:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6F8BB21A09
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 14:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3A0175A7;
	Mon, 15 Jan 2024 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cuI/N/M2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89C917596
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705329768; x=1736865768;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KeytAfpjTvYio2gds7krRqPVXqHJi+pnUY06Djw7X0c=;
  b=cuI/N/M2SgkshmgBgY/ZHrI7ZNPZnrVYWU19HVGPq5lsq24CeK9RHIyN
   zqC+Z934wpp7TzPOChfFvwwqQH7DKWJzRPQOG22Y19HQw6zcqG8/YZ/su
   UlQLUG8gSQUHLuAVXlkEm9PTzl3Kp2X03ACOSOF3WB+dNr9jVWWSCjgbj
   xiRjgkRHEAzNdS/eVLEILHY+O6eNURGj+V7HadgioqTav6JznOEtonw5q
   54qfzk8HRjr3ojPKGhCHZot/0v3ttBSyeF2Eta8BOI6zqLjhfmCJ/BVB8
   YBBCl0OM4oUDjm0fNQOjQl7cCFlY0331OUzwDwyZE3m7JClTVt9x1Pz4A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="12984191"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="12984191"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 06:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="1030663434"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="1030663434"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga006.fm.intel.com with ESMTP; 15 Jan 2024 06:42:43 -0800
Date: Mon, 15 Jan 2024 22:55:41 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 14/16] i386: Use CPUCacheInfo.share_level to encode
 CPUID[4]
Message-ID: <ZaVHbUo2rJgV3jtA@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-15-zhao1.liu@linux.intel.com>
 <a0cd67f2-94f2-4c4b-9212-6b7344163660@intel.com>
 <ZaSpQuQxU5UrbIf4@intel.com>
 <5a004819-b9bf-4a2e-b8b3-ed238a66245a@intel.com>
 <ZaTPvmU/6gXHNDRo@intel.com>
 <4094e712-65b9-4b47-9c3f-67970ff8a86c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4094e712-65b9-4b47-9c3f-67970ff8a86c@intel.com>

Hi Xiaoyao,

On Mon, Jan 15, 2024 at 03:00:25PM +0800, Xiaoyao Li wrote:
> Date: Mon, 15 Jan 2024 15:00:25 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 14/16] i386: Use CPUCacheInfo.share_level to encode
>  CPUID[4]
> 
> On 1/15/2024 2:25 PM, Zhao Liu wrote:
> > Hi Xiaoyao,
> > 
> > On Mon, Jan 15, 2024 at 12:25:19PM +0800, Xiaoyao Li wrote:
> > > Date: Mon, 15 Jan 2024 12:25:19 +0800
> > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Subject: Re: [PATCH v7 14/16] i386: Use CPUCacheInfo.share_level to encode
> > >   CPUID[4]
> > > 
> > > On 1/15/2024 11:40 AM, Zhao Liu wrote:
> > > > > > +{
> > > > > > +    uint32_t num_ids = 0;
> > > > > > +
> > > > > > +    switch (share_level) {
> > > > > > +    case CPU_TOPO_LEVEL_CORE:
> > > > > > +        num_ids = 1 << apicid_core_offset(topo_info);
> > > > > > +        break;
> > > > > > +    case CPU_TOPO_LEVEL_DIE:
> > > > > > +        num_ids = 1 << apicid_die_offset(topo_info);
> > > > > > +        break;
> > > > > > +    case CPU_TOPO_LEVEL_PACKAGE:
> > > > > > +        num_ids = 1 << apicid_pkg_offset(topo_info);
> > > > > > +        break;
> > > > > > +    default:
> > > > > > +        /*
> > > > > > +         * Currently there is no use case for SMT and MODULE, so use
> > > > > > +         * assert directly to facilitate debugging.
> > > > > > +         */
> > > > > > +        g_assert_not_reached();
> > > > > > +    }
> > > > > > +
> > > > > > +    return num_ids - 1;
> > > > > suggest to just return num_ids, and let the caller to do the -1 work.
> > > > Emm, SDM calls the whole "num_ids - 1" (CPUID.0x4.EAX[bits 14-25]) as
> > > > "maximum number of addressable IDs for logical processors sharing this
> > > > cache"...
> > > > 
> > > > So if this helper just names "num_ids" as max_lp_ids_share_the_cache,
> > > > I'm not sure there would be ambiguity here?
> > > 
> > > I don't think it will.
> > > 
> > > if this function is going to used anywhere else, people will need to keep in
> > > mind to do +1 stuff to get the actual number.
> > > 
> > > leaving the -1 trick to where CPUID value gets encoded. let's make this
> > > function generic.
> > 
> > This helper is the complete pattern to get addressable IDs, this is to
> > say, the "- 1" is also the part of this calculation.
> > 
> > Its own meaning is self-consistent and generic enough to meet the common
> > definitions of AMD and Intel.
> 
> OK. I stop bikeshedding on it.
>

Thanks for your review ;-).

Regards,
Zhao


