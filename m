Return-Path: <kvm+bounces-29124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8389A3373
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 117E7285590
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 03:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1786D157465;
	Fri, 18 Oct 2024 03:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sa+GhaAq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2DD364D6
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 03:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729222891; cv=none; b=o3wFRmZ/OpxmM2zhdzHY/X2Y69Ybk1u10mlYry4kBO+9V0fpXVn0EHnbG7D48gval6U+gI/0T7o0ee7jdfEtSM+F+8wDgkaGTV6O/HMP5nUAzgnwigLZqHC8+oKzi37tpLGb893T00+5KvpJh7aqoHwvu7aRrO02e6O3e09Y0cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729222891; c=relaxed/simple;
	bh=L5YH9Y1EQZKE2ItXEjex7LOcAdkKR8Mn+jEmyjCz4xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dya1Ae/TlsiF7HjtYWxBsnEA4Fk4oVLcBxdVSjXXgnqTI934U5VKv9wqFY7g2M0+LvWYj/Kfm2n53q7vLf28hPJ3AvrseidYH7xRxSJmdal9hDjqUVzC3hICc2wYBvb0ARHusJXn7DVU2wMU9HC5olDgpzMSv+D9TwGwN+a3rP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sa+GhaAq; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729222889; x=1760758889;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L5YH9Y1EQZKE2ItXEjex7LOcAdkKR8Mn+jEmyjCz4xs=;
  b=Sa+GhaAq9b6BhvvsA79Mry7xLjC0nOHEwNzuXUAvD8/7nH5tlO7Co4+X
   1iZolcyDBHuvrNps9TIBSbq3DfRdjHrQbnJd847iOCPkwWxthv1fiPf29
   s79ZBXMGSaQivuNx4+iME+I9QfhzzbdtFRhPH+rg0iF9P4k2Q1gFxC0DR
   LEbgrakjjijh+qFrr8dEBZBMgQHBWIn8e/3xi6s/nNl9G2hv+evyUlc8d
   gnY8DXa6L+Q8+k9GwHI/on5moVa/N/IFfTcHOYyyLiQbOU/j5Ny3lHg/E
   7x3cTzeafD56BqEoESew0vX2m7/FvLzJTEr5zvoJm6biTEkkvwaOdTHlR
   A==;
X-CSE-ConnectionGUID: OTT2PVBORx6n2+VqOikLIQ==
X-CSE-MsgGUID: i0+3bh5KSZSBEZlaiOwBAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="28623134"
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="28623134"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 20:41:27 -0700
X-CSE-ConnectionGUID: uN0AIhknT6ORiSDRsmYrVw==
X-CSE-MsgGUID: oZCzeqvgTuSFPN9dk1XFsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="83818764"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa004.jf.intel.com with ESMTP; 17 Oct 2024 20:41:21 -0700
Date: Fri, 18 Oct 2024 11:57:36 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
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
Subject: Re: [PATCH v3 6/7] i386/pc: Support cache topology in -machine for
 PC machine
Message-ID: <ZxHcsPyqT6MLJ9hG@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-7-zhao1.liu@intel.com>
 <ZxEs3DGGgCqGT5yK@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxEs3DGGgCqGT5yK@redhat.com>

Hi Daniel,

> > +    ``smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel``
> > +        Define cache properties for SMP system.
> > +
> > +        ``cache=cachename`` specifies the cache that the properties will be
> > +        applied on. This field is the combination of cache level and cache
> > +        type. It supports ``l1d`` (L1 data cache), ``l1i`` (L1 instruction
> > +        cache), ``l2`` (L2 unified cache) and ``l3`` (L3 unified cache).
> > +
> > +        ``topology=topologylevel`` sets the cache topology level. It accepts
> > +        CPU topology levels including ``thread``, ``core``, ``module``,
> > +        ``cluster``, ``die``, ``socket``, ``book``, ``drawer`` and a special
> > +        value ``default``. If ``default`` is set, then the cache topology will
> > +        follow the architecture's default cache topology model. If another
> > +        topology level is set, the cache will be shared at corresponding CPU
> > +        topology level. For example, ``topology=core`` makes the cache shared
> > +        by all threads within a core.
> > +
> > +        Example:
> > +
> > +        ::
> > +
> > +            -machine smp-cache.0.cache=l1d,smp-cache.0.topology=core,smp-cache.1.cache=l1i,smp-cache.1.topology=core
> 
> There are 4 cache types, l1d, l1i, l2, l3.
> 
> In this example you've only set properties for l1d, l1i caches.
> 
> What does this mean for l2 / l3 caches ?

Omitting "cache" will default to using the "default" level.

I think I should add the above description to the documentation.

> Are they reported as not existing, or are they to be reported at
> some built-in default topology level.

It's the latter.

If a machine doesn't support l2/l3, then QEMU will also report the error
like:

qemu-system-*: l2 cache topology not supported by this machine

> If the latter, how does the user know what that built-in default is, 

Currently, the default cache model for x86 is L1 per core, L2 per core,
and L3 per die. Similar to the topology levels, there is still no way to
expose this to users. I can descript default cache model in doc.

But I feel like we're back to the situation we discussed earlier:
"default" CPU topology support should be related to the CPU model, but
in practice, QEMU supports it at the machine level. The cache topology
depends on CPU topology support and can only continue to be added on top
of the machine.

So do you think we can add topology and cache information in CpuModelInfo
so that query-cpu-model-expansion can expose default CPU/cache topology
information to users?

This way, users can customize CPU/cache topology in -smp and
-machine smp-cache. Although the QMP command is targeted at the CPU model
while our CLI is at the machine level, at least we can expose the
information to users.

If you agree to expose the default topology/cache info in
query-cpu-model-expansion, can I work on this in a separate series? :)

> and avoid nonsense like l1d being at socket level, and l3 being at the
> core level ?

Thank you! I ensured l1 must be lower than l2 and l2 must be lower than
l3, but missed l1 must be lower than l3.

The level check is incomplete due to the influence of "default." I think
the check should be placed after the arch CPU sets the cache model,
so that "default" is consumed.

> Can we explicitly disable a l2/l3 cache, or must it always exists ?

Now we can't disable it through -machine smp-cache (while x86 CPU support
l3-cache=off), but as you mentioned, I can try using "invalid" to support
this scenario, which would be more general. Similarly, if you agree, I
can also add this support in a separate series.

> The QAPI has an "invalid" topology level. You've not documented
> that as permitted here, but the qapi parser will happily allow
> it. What semantics will that have ? 

Because the current this patch throws an error for "invalid", so I didn't
included it in the doc.

Thanks,
Zhao


