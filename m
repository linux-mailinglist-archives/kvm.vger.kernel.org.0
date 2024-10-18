Return-Path: <kvm+bounces-29125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA86F9A3398
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 06:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F0451F22B64
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 04:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182EA16B3B7;
	Fri, 18 Oct 2024 04:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mpGYVH1t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C6D2A1A4
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 04:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729224622; cv=none; b=NFTiRfLisfOIrVABO0c04AWnVtr/102GRzfr+wKkTTlG383aWW2CI2KG1OxwhtvAe1HYe9lsrhh7us/LBDVnP5aFTO88whCuNi1FSyEaVm/tr3nskeTd9WAJkgf7+MS1xxk/R+8JlGl5u04hOeoQtMMKYtBS1olvGklmv40kyso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729224622; c=relaxed/simple;
	bh=UO03l2WlkbGHRPPhQ1W7PzTfDWTByRjaEAMTt2eMXo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZTyRjzdRy9h+wJ4hgDJDiQ+QxoWDpNZfp7+7OWf//gN4JsRtX9SjjnqQWYNG/ZoYjUx6qK9Xvq0ZaiEXo+X21sn7GwBV9tSi+Ja84X/g0VU+mz2d9/VYDdYy+dOvMlKu07fkqKVnX+dMgm500Fa3+Q6MYyri980Bi8MkIA8G2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mpGYVH1t; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729224621; x=1760760621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=UO03l2WlkbGHRPPhQ1W7PzTfDWTByRjaEAMTt2eMXo4=;
  b=mpGYVH1t4mmP3R3JsWlSN9ZJEDDr2gbtas9R4QZtF0ZxJJ/B+ezEbVxs
   ZQseEo2RkPka0IBQ3GNKrkaetNh0wMufiB/cEnvywoNmmKdLbCKwWVgJb
   HYvAPOTa3qhLnORW8dsZNnIBpXMz55H0Lttg12uEE614Dt2Y9p7szwTVj
   0i8fXB+DMyTB2eho/whVgdbb6PNuYf0v1oKqczJ4TqYGW3RRgv5sWvDf1
   GsVfSRYqBpGuX2dZb9u+sTbzdiq7SV8fx2VMkiguq6ssZHVW6XnRPk5Yv
   DNCU5lc5mv6qa9LDInV6KsGLwgzLyjcGVTElyLoYdL0PtEUqnenHSx2tF
   g==;
X-CSE-ConnectionGUID: arw6QUUeT8+E8SMaD9z4DA==
X-CSE-MsgGUID: cpGvCmdWRziKFXbueseP1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28621479"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28621479"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 21:10:20 -0700
X-CSE-ConnectionGUID: 7spyyLOrQh+idBbFxWPV8A==
X-CSE-MsgGUID: 9z7etmnrTL23n7mV1FIhiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="109568860"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa002.jf.intel.com with ESMTP; 17 Oct 2024 21:10:14 -0700
Date: Fri, 18 Oct 2024 12:26:29 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
 arch-agnostic
Message-ID: <ZxHjdWSXyYKBAVWZ@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-2-zhao1.liu@intel.com>
 <0b884126-1fcb-40d2-9fc2-ab0944370fd9@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b884126-1fcb-40d2-9fc2-ab0944370fd9@linaro.org>

Hi Marcin,

On Thu, Oct 17, 2024 at 06:19:59PM +0200, Marcin Juszkiewicz wrote:
> Date: Thu, 17 Oct 2024 18:19:59 +0200
> From: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
> Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
>  arch-agnostic
> 
> W dniu 12.10.2024 o 12:44, Zhao Liu pisze:
> > Cache topology needs to be defined based on CPU topology levels. Thus,
> > define CPU topology enumeration in qapi/machine.json to make it generic
> > for all architectures.
> 
> I have a question: how to create other than default cache topology in C
> source?

What does "C source" mean? Does it refer to the C code for sbsa-ref?

There's the ARM change to support cache topology for virt machine:

https://lore.kernel.org/qemu-devel/20241010111822.345-5-alireza.sanaee@huawei.com/

If you're looking to store cache information for some common purposes,
you could also define a cache model structure similar to how it's done
for x86:

static const CPUCaches epyc_cache_info = {
    .l1d_cache = &(CPUCacheInfo) {
        .type = DATA_CACHE,
        .level = 1,
        .size = 32 * KiB,
        .line_size = 64,
        .associativity = 8,
        .partitions = 1,
        .sets = 64,
        .lines_per_tag = 1,
        .self_init = 1,
        .no_invd_sharing = true,
        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
    },
    .l1i_cache = &(CPUCacheInfo) {
        .type = INSTRUCTION_CACHE,
        .level = 1,
        .size = 64 * KiB,
        .line_size = 64,
        .associativity = 4,
        .partitions = 1,
        .sets = 256,
        .lines_per_tag = 1,
        .self_init = 1,
        .no_invd_sharing = true,
        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
    },
    .l2_cache = &(CPUCacheInfo) {
        .type = UNIFIED_CACHE,
        .level = 2,
        .size = 512 * KiB,
        .line_size = 64,
        .associativity = 8,
        .partitions = 1,
        .sets = 1024,
        .lines_per_tag = 1,
        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
    },
    .l3_cache = &(CPUCacheInfo) {
        .type = UNIFIED_CACHE,
        .level = 3,
        .size = 8 * MiB,
        .line_size = 64,
        .associativity = 16,
        .partitions = 1,
        .sets = 8192,
        .lines_per_tag = 1,
        .self_init = true,
        .inclusive = true,
        .complex_indexing = true,
        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
    },
};

> If I would like to change default cache structure for sbsa-ref then how
> would I do it?

I'm not very familiar with sbsa-ref. How is the cache model defined? Does
it use ACPI PPTT like the virt machine? If so, you can refer to the virt
machine series link I provided above.

> QEMU has powerful set of command line options. But it is hard to convert set
> of cli options into C code.

The CLI is currently quite complex, as different machine configurations
may vary. But don't worry. The general steps for enabling smp-cache here
are:

1. Set cache levels support in sbsa_ref_class_init(). You can refer my
   patch 6, to set ture for which cache level you need.
2. Then, the cli can support "-machine smp-cache" for sbsa-ref machine.
   You can refer the doc in my patch 6 to get the correct format.
3. Next, the MachineState will store the user's cache topology in "smp_cache".
   You can refer my patch 5 to get cache topology level from machine.
4. Finally, it's architecture-specific code, depending on whether you
   want to express cache information in the same pptt table as virt
   machine.

Regards,
Zhao



