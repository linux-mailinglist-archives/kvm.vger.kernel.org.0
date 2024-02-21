Return-Path: <kvm+bounces-9311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D585F85E06E
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60B501F24550
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 15:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432847FBD4;
	Wed, 21 Feb 2024 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8W301vW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A338769D05
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708527747; cv=none; b=qzNpxN7KFL2vxw7+SIqmp0v5eLR/bDs2e+T31VCnHcQpc5kG5HEkQDCLwQ56NbJL8zuAQ+FOATZTgSsulVAkp1Uy4vS2h2T5Y62aiYLTXTcUeklUcdbECF0YbJs6TIT3Ku8KN/xAawSVihLHoEhpWilLdqVQormlMMNNx7Hl8WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708527747; c=relaxed/simple;
	bh=WBX3JEE0xCgQeTqxHcs0E/t5LnwAQFvPmM5yZF0rXjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kao1o9S9P1/EB00uSyjGTrsN2NpkQUt3TqrfuGH++cf3t5sXRNRU3LYJIdeLLXH0oOqgIDgMm/2irEcAvdKYcVSWuZGbYevI/zJ2GYbVJSyW2ZbT5P8RAmRhuub7UOYcGxIWUSMqLC09MZ06dIuNwLIu0bsanQLplebekWVg96c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8W301vW; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708527746; x=1740063746;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WBX3JEE0xCgQeTqxHcs0E/t5LnwAQFvPmM5yZF0rXjs=;
  b=W8W301vWF5HHGz0UeC3pt0VAg7NBwDSLl+FVIku9rE69LPmzVDJkuhme
   Zyz51Y/qqbLz+7hl/O98bFf4dRlHgwrcigB2+1eaxRfqmLYroM3s5g49U
   55hyjEgp3C1I92Mw4eGezl45VPZAowZKPuM80L6I1jV4P9zAHIuUjdn3g
   NQHfaO6ojowKqUy8UZoZdsojdOuEF5M+MRZesDyr4KfdVHmAd0HlmelrC
   DXVONlVd1oZ5H5d7Qwc7lWsxGZjJSvh7M/PpRflOmzvswgd5Oj/EzwoD+
   3ewLiP/bBp4X7iMgbIjQCm4cWdpziTVH5FJG2lXdkTRBZMSR6YDVvrBaz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="3173975"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="3173975"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 07:02:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="9753224"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 21 Feb 2024 07:02:18 -0800
Date: Wed, 21 Feb 2024 23:15:58 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
Message-ID: <ZdYTrlTpLg3iR10Y@intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
 <87plwqgfb4.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plwqgfb4.fsf@pond.sub.org>

On Wed, Feb 21, 2024 at 01:41:35PM +0100, Markus Armbruster wrote:
> Date: Wed, 21 Feb 2024 13:41:35 +0100
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> 
> Zhao Liu <zhao1.liu@linux.intel.com> writes:
> 
> > From: Zhao Liu <zhao1.liu@intel.com>
> >
> > Hi list,
> >
> > This is the our v8 patch series, rebased on the master branch at the
> > commit 11be70677c70 ("Merge tag 'pull-vfio-20240129' of
> > https://github.com/legoater/qemu into staging").
> >
> > Compared with v7 [1], v8 mainly has the following changes:
> >   * Introduced smp.modules for x86 instead of reusing current
> >     smp.clusters.
> >   * Reworte the CPUID[0x1F] encoding.
> >
> > Given the code change, I dropped the most previously gotten tags
> > (Acked-by/Reviewed-by/Tested-by from Michael & Babu, thanks for your
> > previous reviews and tests!) in v8.
> >
> > With the description of the new modules added to x86 arch code in v7 [1]
> > cover letter, the following sections are mainly the description of
> > the newly added smp.modules (since v8) as supplement.
> >
> > Welcome your comments!
> >
> >
> > Why We Need a New CPU Topology Level
> > ====================================
> >
> > For the discussion in v7 about whether we should reuse current
> > smp.clusters for x86 module, the core point is what's the essential
> > differences between x86 module and general cluster.
> >
> > Since, cluster (for ARM/riscv) lacks a comprehensive and rigorous
> > hardware definition, and judging from the description of smp.clusters
> > [2] when it was introduced by QEMU, x86 module is very similar to
> > general smp.clusters: they are all a layer above existing core level
> > to organize the physical cores and share L2 cache.
> >
> > However, after digging deeper into the description and use cases of
> > cluster in the device tree [3], I realized that the essential
> > difference between clusters and modules is that cluster is an extremely
> > abstract concept:
> >   * Cluster supports nesting though currently QEMU doesn't support
> >     nested cluster topology. However, modules will not support nesting.
> >   * Also due to nesting, there is great flexibility in sharing resources
> >     on clusters, rather than narrowing cluster down to sharing L2 (and
> >     L3 tags) as the lowest topology level that contains cores.
> >   * Flexible nesting of cluster allows it to correspond to any level
> >     between the x86 package and core.
> >
> > Based on the above considerations, and in order to eliminate the naming
> > confusion caused by the mapping between general cluster and x86 module
> > in v7, we now formally introduce smp.modules as the new topology level.
> >
> >
> > Where to Place Module in Existing Topology Levels
> > =================================================
> >
> > The module is, in existing hardware practice, the lowest layer that
> > contains the core, while the cluster is able to have a higher topological
> > scope than the module due to its nesting.
> >
> > Thereby, we place the module between the cluster and the core, viz:
> >
> >     drawer/book/socket/die/cluster/module/core/thread
> >
> >
> > Additional Consideration on CPU Topology
> > ========================================
> >
> > Beyond this patchset, nowadays, different arches have different topology
> > requirements, and maintaining arch-agnostic general topology in SMP
> > becomes to be an increasingly difficult thing due to differences in
> > sharing resources and special flexibility (e.g., nesting):
> >   * It becomes difficult to put together all CPU topology hierarchies of
> >     different arches to define complete topology order.
> >   * It also becomes complex to ensure the correctness of the topology
> >     calculations.
> >       - Now the max_cpus is calculated by multiplying all topology
> >         levels, and too many topology levels can easily cause omissions.
> >
> > Maybe we should consider implementing arch-specfic topology hierarchies.
> >
> >
> > [1]: https://lore.kernel.org/qemu-devel/20240108082727.420817-1-zhao1.liu@linux.intel.com/
> > [2]: https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg04051.html
> > [3]: https://www.kernel.org/doc/Documentation/devicetree/bindings/cpu/cpu-topology.txt
> 
> Have you considered putting an abridged version of your lovely rationale
> into a commit message, so it can be found later more easily?
>

Sure, I'll. Thanks for helping me improve my commit message. ;-)

Regards,
Zhao


