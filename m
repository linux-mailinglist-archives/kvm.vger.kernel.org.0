Return-Path: <kvm+bounces-22056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58369939068
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 16:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA3DC1F221F8
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87453DF44;
	Mon, 22 Jul 2024 14:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M0ML6lS1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABD816DC0D
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721657704; cv=none; b=BQBVX4DxIE19Ff0w48dxRhKtTmUJQ9cp3HoEzI9Lv543wdQ+zTJJNM68Mo2wBNQ9XZQfziQ1LCUzOj8mFg3uq0fwQYNwnZBFKoQWZXbUzf/gIsZWlXMdzK/xZ4AR32yqpBFXIpShNKGNX2A1Se7iSWxhR32RHWfcZvV26ocdL6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721657704; c=relaxed/simple;
	bh=6ZzsOV0SsccAhlyGxokRhWmGrLOJAiEG1PQ1JxrnUMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlBMtkl9BCB/s4iaJk8sSh6GRS2FgnYM5bPCSkfrA2UYhsyhMDoSiIbFtDXWbD2PK64K75emlFvJkDTnbcfvqd5fHyLUhY4JNqavv+k/PB2deXvLx/NMLz43U6iLiHGB1s/IPYHkGAg0cv9+SUjC+fqafBWfrCDt37L2j4RUAEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M0ML6lS1; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721657703; x=1753193703;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6ZzsOV0SsccAhlyGxokRhWmGrLOJAiEG1PQ1JxrnUMc=;
  b=M0ML6lS1y6HIVpq1caIgiMC4kr4zsEEoaMP9qoJROjKmOm5vqL/eUgqg
   FAJ4lih/kGSj+XIGtF3SoZXY+ueZhXoQqc9Qu4itzvaVNCQDiJuSCZTYP
   sKHzAevJsTI0wrzYf3QP/jqmzMC9XxGVnxSYiqx+wQpgv0oKVNLqTu+Pz
   72oVKeKNJhE6yyNbMSUJj815Sf+eRQqb1f0kA1PaJruw0RIMVKtNjyqUN
   3CcfgpqGxUVAhHo9oe8FLTtzPu0/qHb1MZ8ikRR96UK+dKBsGpKIaTL9e
   vV0jDQ3OIHsySmMWRvX6rGe6GaIyVHavlA+Ft1Nn4bOtJUi7Hha+UE0+W
   w==;
X-CSE-ConnectionGUID: cu9ejgKBR+Sv6vwnYlzUJg==
X-CSE-MsgGUID: p52TgDSTQkqLNBQpZpxF9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11141"; a="41755202"
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="41755202"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 07:14:50 -0700
X-CSE-ConnectionGUID: wDAU7JD6TwyVWg1E/NElIg==
X-CSE-MsgGUID: GZ6yDPBXRMe5vcfqwQRJXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="89346284"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa001.jf.intel.com with ESMTP; 22 Jul 2024 07:14:44 -0700
Date: Mon, 22 Jul 2024 22:30:28 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Message-ID: <Zp5tBHBoeXZy44ys@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-3-zhao1.liu@intel.com>
 <87wmld361y.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wmld361y.fsf@pond.sub.org>

Hi Markus,

On Mon, Jul 22, 2024 at 03:33:13PM +0200, Markus Armbruster wrote:
> Date: Mon, 22 Jul 2024 15:33:13 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Introduce smp-cache object so that user could define cache properties.
> >
> > In smp-cache object, define cache topology based on CPU topology level
> > with two reasons:
> >
> > 1. In practice, a cache will always be bound to the CPU container
> >    (either private in the CPU container or shared among multiple
> >    containers), and CPU container is often expressed in terms of CPU
> >    topology level.
> > 2. The x86's cache-related CPUIDs encode cache topology based on APIC
> >    ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
> >    relies on also requires CPU containers to help indicate the private
> >    shared hierarchy of the cache. Therefore, for SMP systems, it is
> >    natural to use the CPU topology hierarchy directly in QEMU to define
> >    the cache topology.
> >
> > Currently, separated L1 cache (L1 data cache and L1 instruction cache)
> > with unified higher-level cache (e.g., unified L2 and L3 caches), is the
> > most common cache architectures.
> >
> > Therefore, enumerate the L1 D-cache, L1 I-cache, L2 cache and L3 cache
> > with smp-cache object to add the basic cache topology support.
> >
> > Suggested-by: Daniel P. Berrange <berrange@redhat.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> [...]
> 
> > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> > index 82413c668bdb..8b8c0e9eeb86 100644
> > --- a/qapi/machine-common.json
> > +++ b/qapi/machine-common.json
> > @@ -64,3 +64,53 @@
> >    'prefix': 'CPU_TOPO_LEVEL',
> >    'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
> >              'die', 'socket', 'book', 'drawer', 'default' ] }
> > +
> > +##
> > +# @SMPCacheName:
> 
> Why the SMP in this name?  Because it's currently only used by SMP
> stuff?  Or is there another reason I'm missing?

Yes, I suppose it can only be used in SMP case.

Because Intel's heterogeneous CPUs have different topologies for cache,
for example, Alderlake's L2, for P core, L2 is per P-core, but for E
core, L2 is per module (4 E cores per module). Thus I would like to keep
the topology semantics of this object and -smp as consistent as possible.

Do you agree?

> The more idiomatic QAPI name would be SmpCacheName.  Likewise for the
> other type names below.

I hesitated here as well, but considering that SMPConfiguration is "SMP"
and not "Smp", it has that name. I'll change to SmpCacheName for strict
initial capitalization.

> > +#
> > +# An enumeration of cache for SMP systems.  The cache name here is
> > +# a combination of cache level and cache type.
> 
> The first sentence feels awkward.  Maybe
> 
>    # Caches an SMP system may have.
> 
> > +#
> > +# @l1d: L1 data cache.
> > +#
> > +# @l1i: L1 instruction cache.
> > +#
> > +# @l2: L2 (unified) cache.
> > +#
> > +# @l3: L3 (unified) cache
> > +#
> > +# Since: 9.1
> > +##
> 
> This assumes the L1 cache is split, and L2 and L3 are unified.
> 
> If we model a system with say a unified L1 cache, we'd simply extend
> this enum.  No real difference to extending it for additional levels.
> Correct?

Yes. For unified L1, we just need add a "l1" which is opposed to l1i/l1d.

> > +{ 'enum': 'SMPCacheName',
> > +  'prefix': 'SMP_CACHE',
> 
> Why not call it SmpCache, and ditch 'prefix'?

Because the SMPCache structure in smp_cache.h uses the similar name:

+#define TYPE_SMP_CACHE "smp-cache"
+OBJECT_DECLARE_SIMPLE_TYPE(SMPCache, SMP_CACHE)
+
+struct SMPCache {
+    Object parent_obj;
+
+    SMPCacheProperty props[SMP_CACHE__MAX];
+};

Naming is always difficult, so I would use Smpcache here if you feel that
SmpCache is sufficient to distinguish it from SMPCache, or I would also
rename the SMPCache structure to SMPCacheState in smp_cache.h.

Which way do you prefer?

> > +  'data': [ 'l1d', 'l1i', 'l2', 'l3' ] }
> 
> > +
> > +##
> > +# @SMPCacheProperty:
> 
> Sure we want to call this "property" (singular) and not "properties"?
> What if we add members to this type?
> 
> > +#
> > +# Cache information for SMP systems.
> > +#
> > +# @name: Cache name.
> > +#
> > +# @topo: Cache topology level.  It accepts the CPU topology
> > +#     enumeration as the parameter, i.e., CPUs in the same
> > +#     topology container share the same cache.
> > +#
> > +# Since: 9.1
> > +##
> > +{ 'struct': 'SMPCacheProperty',
> > +  'data': {
> > +  'name': 'SMPCacheName',
> > +  'topo': 'CpuTopologyLevel' } }
> 
> We tend to avoid abbreviations in the QAPI schema.  Please consider
> naming this 'topology'.

Sure!

> > +
> > +##
> > +# @SMPCacheProperties:
> > +#
> > +# List wrapper of SMPCacheProperty.
> > +#
> > +# @caches: the SMPCacheProperty list.
> > +#
> > +# Since 9.1
> > +##
> > +{ 'struct': 'SMPCacheProperties',
> > +  'data': { 'caches': ['SMPCacheProperty'] } }
> 
> Ah, now I see why you used the singular above!
> 
> However, this type holds the properties of call caches.  It is a list
> where each element holds the properties of a single cache.  Calling the
> former "cache property" and the latter "cache properties" is confusing.

Yes...

> SmpCachesProperties and SmpCacheProperties would put the singular
> vs. plural where it belongs.  Sounds a bit awkward to me, though.
> Naming is hard.

For SmpCachesProperties, it's easy to overlook the first "s".

> Other ideas, anybody?

Maybe SmpCacheOptions or SmpCachesPropertyWrapper?

> > diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
> > index b1581988e4eb..25394f2cda50 100644
> > --- a/qapi/qapi-schema.json
> > +++ b/qapi/qapi-schema.json
> > @@ -64,11 +64,11 @@
> >  { 'include': 'compat.json' }
> >  { 'include': 'control.json' }
> >  { 'include': 'introspect.json' }
> > -{ 'include': 'qom.json' }
> > -{ 'include': 'qdev.json' }
> >  { 'include': 'machine-common.json' }
> >  { 'include': 'machine.json' }
> >  { 'include': 'machine-target.json' }
> > +{ 'include': 'qom.json' }
> > +{ 'include': 'qdev.json' }
> >  { 'include': 'replay.json' }
> >  { 'include': 'yank.json' }
> >  { 'include': 'misc.json' }
> 
> Worth explaining in the commit message, I think.

Because of the include relationship between the json files, I need to
change the order. I had a "crazy" proposal to clean up this:
https://lore.kernel.org/qemu-devel/20240517062748.782366-1-zhao1.liu@intel.com/

Thanks,
Zhao


