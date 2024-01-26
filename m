Return-Path: <kvm+bounces-7045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09CA983D2EC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B3B31F23FCE
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 03:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98E3A95E;
	Fri, 26 Jan 2024 03:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dCcqA9Ow"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9678831
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 03:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706239471; cv=none; b=kzdOwcAQrKvyzGKo1V+MD+3flqKQSvU7bXIhzJI4PEmT+yJlnzQWVnUkn8WLYFVy/N/5VFNPNTMJ+s0q9Pg8GqB8sSNpcVhCVDDxQEZjaok9HDlWCcIfJunXBQNQWDcxEdW2I5BoeoFa/sYmcTOSheKbaxxn2pqAr49rBCJvho0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706239471; c=relaxed/simple;
	bh=FF75bfzHwsPefUZfv9jfTBzifIdfovWTQJGE4vE3df8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DChYMS2PVvIQZ+cnEuUUc4owcQMO48i8IFvS7YA4z+guWnqSLpD3B+ODogyjXqwqqPwGZzd0XocBz/2sMWtmNaxLaeOAU6IsW3Tgmq8RVxXut21BZhKBUTc35eefE79qcLldywC72YM1yuExSYez878uARa4SMl9iaYWHLQMpbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dCcqA9Ow; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706239470; x=1737775470;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FF75bfzHwsPefUZfv9jfTBzifIdfovWTQJGE4vE3df8=;
  b=dCcqA9Owi5uIKcGKdezbCMMDwZl+W1WSpaP2eJSooo1d8h/nVensxxPc
   cKoIFPJgYgyuXGt2NzqlvioLxBzkCWjh2vXud4h/uGDr/XiP0q3JR9b8V
   OKNNebz0X4bL9A+/2jhvaMZCwsYGZ+cOSWp7EwwqlBuPjqzBRXIMcuaX2
   SMCSyFsJ3yUDKQlglFlkKCp8MIaSYoAEs9rZrw0eWUZ7YJKp+iD8qOzY6
   nyJ+di59AOW/dp2AgcFEGYJEc/7Rhtn2mludPoys+ZXsYXiHwVPr0b01h
   UG4CIbhFc7B60uZnERJAsXJPpVzJNZUjbs9egQaBQ8NL24PYmTWBOR5v0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="2268276"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2268276"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 19:24:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="857292062"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="857292062"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2024 19:24:24 -0800
Date: Fri, 26 Jan 2024 11:37:27 +0800
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
	Yongwei Ma <yongwei.ma@intel.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH v7 10/16] i386/cpu: Introduce cluster-id to X86CPU
Message-ID: <ZbMo92iW9KL3M6et@intel.com>
References: <ZaTJyea4KMMk6x/m@intel.com>
 <1c58dd98-d4f6-4226-9a17-8b89c3ed632e@intel.com>
 <ZaVMq3v6yPoFARsF@intel.com>
 <f9f675c2-9e53-4673-a232-89b72150f092@intel.com>
 <Zaor6d1Vl/RLbqMk@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zaor6d1Vl/RLbqMk@intel.com>

Hi Xiaoyao,

> > > > generic cluster just means the cluster of processors, i.e, a group of
> > > > cpus/lps. It is just a middle level between die and core.
> > > 
> > > Not sure if you mean the "cluster" device for TCG GDB? "cluster" device
> > > is different with "cluster" option in -smp.
> > 
> > No, I just mean the word 'cluster'. And I thought what you called "generic
> > cluster" means "a cluster of logical processors"
> > 
> > Below I quote the description of Yanan's commit 864c3b5c32f0:
> > 
> >     A cluster generally means a group of CPU cores which share L2 cache
> >     or other mid-level resources, and it is the shared resources that
> >     is used to improve scheduler's behavior. From the point of view of
> >     the size range, it's between CPU die and CPU core. For example, on
> >     some ARM64 Kunpeng servers, we have 6 clusters in each NUMA node,
> >     and 4 CPU cores in each cluster. The 4 CPU cores share a separate
> >     L2 cache and a L3 cache tag, which brings cache affinity advantage.
> > 
> > What I get from it, is, cluster is just a middle level between CPU die and
> > CPU core.
> 
> Here the words "a group of CPU" is not the software concept, but a hardware
> topology.

When I found this material:

https://www.kernel.org/doc/Documentation/devicetree/bindings/cpu/cpu-topology.txt

I realized the most essential difference between cluster and module is
that cluster supports nesting, i.e. it can have nesting clusters as a
layer of CPU topology.

Even though QEMU's description of cluster looked similar to module when
it was introduced, it is impossible to envision whether ARM/RISCV and
other device tree-based arches will continue to introduce nesting
clusters in the future.

To avoid potential conflicts, it would be better to introduce modules
for x86 to differentiate them from clusters.

Thanks,
Zhao


