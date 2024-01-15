Return-Path: <kvm+bounces-6195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C42182D41E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:12:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5805C1C210E3
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17043C23;
	Mon, 15 Jan 2024 06:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yk5LFxFZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4A12566
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 06:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705299130; x=1736835130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Icxs9cOG0QTkV29eLd1mD8xTYSicMFjqmusnrrSXIxY=;
  b=Yk5LFxFZjbS4CDNuoZpyUfVU4Zp1DmztYIttPpWzpaR3/kgv6ouRcU7t
   M9Ds80O/DJ4AVMMjEqvlAezGuo9qGWoMgGpZLUThWLKGhLWPM6zumjodS
   7ipl8AiIHSLu+sHYmkELMqENKyo+lruv8KdzeKCAyCeLQjTb10ULzJ4Ls
   IhXr10x5WCpPK9sCO0guviGJda/2ftqEQ+N9ylQ4VOljhZABDn34MHTr6
   skaiz+FP9Bro/K7Nf2mwIwKRJen3oXrkiFIYcts7n5CR1mVscowxh+KU0
   iwIjDbcrqpnxPgsY5UUFC4W96ZPvj1ujwSmoNPHnnNZ+H1bgsvB78QK+y
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="6636320"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="6636320"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 22:12:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="906963749"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="906963749"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga004.jf.intel.com with ESMTP; 14 Jan 2024 22:12:05 -0800
Date: Mon, 15 Jan 2024 14:25:02 +0800
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
Message-ID: <ZaTPvmU/6gXHNDRo@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-15-zhao1.liu@linux.intel.com>
 <a0cd67f2-94f2-4c4b-9212-6b7344163660@intel.com>
 <ZaSpQuQxU5UrbIf4@intel.com>
 <5a004819-b9bf-4a2e-b8b3-ed238a66245a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a004819-b9bf-4a2e-b8b3-ed238a66245a@intel.com>

Hi Xiaoyao,

On Mon, Jan 15, 2024 at 12:25:19PM +0800, Xiaoyao Li wrote:
> Date: Mon, 15 Jan 2024 12:25:19 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 14/16] i386: Use CPUCacheInfo.share_level to encode
>  CPUID[4]
> 
> On 1/15/2024 11:40 AM, Zhao Liu wrote:
> > > > +{
> > > > +    uint32_t num_ids = 0;
> > > > +
> > > > +    switch (share_level) {
> > > > +    case CPU_TOPO_LEVEL_CORE:
> > > > +        num_ids = 1 << apicid_core_offset(topo_info);
> > > > +        break;
> > > > +    case CPU_TOPO_LEVEL_DIE:
> > > > +        num_ids = 1 << apicid_die_offset(topo_info);
> > > > +        break;
> > > > +    case CPU_TOPO_LEVEL_PACKAGE:
> > > > +        num_ids = 1 << apicid_pkg_offset(topo_info);
> > > > +        break;
> > > > +    default:
> > > > +        /*
> > > > +         * Currently there is no use case for SMT and MODULE, so use
> > > > +         * assert directly to facilitate debugging.
> > > > +         */
> > > > +        g_assert_not_reached();
> > > > +    }
> > > > +
> > > > +    return num_ids - 1;
> > > suggest to just return num_ids, and let the caller to do the -1 work.
> > Emm, SDM calls the whole "num_ids - 1" (CPUID.0x4.EAX[bits 14-25]) as
> > "maximum number of addressable IDs for logical processors sharing this
> > cache"...
> > 
> > So if this helper just names "num_ids" as max_lp_ids_share_the_cache,
> > I'm not sure there would be ambiguity here?
> 
> I don't think it will.
> 
> if this function is going to used anywhere else, people will need to keep in
> mind to do +1 stuff to get the actual number.
> 
> leaving the -1 trick to where CPUID value gets encoded. let's make this
> function generic.

This helper is the complete pattern to get addressable IDs, this is to
say, the "- 1" is also the part of this calculation.

Its own meaning is self-consistent and generic enough to meet the common
definitions of AMD and Intel.

Thanks,
Zhao


