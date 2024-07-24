Return-Path: <kvm+bounces-22166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FF093B2D4
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 16:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0F2E2821DF
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 14:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9ABC15ADA0;
	Wed, 24 Jul 2024 14:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ChXOKpf3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783415884F
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721832009; cv=none; b=VcgEv7GZaJVoLZr9kOZBWELy5bUqEd9fuK/o/NJdCKRmTFva2E0scncpGHac3SoEhqn8MS93qoM7/dKW+xmf7Zh7EEsaoTjR6vpyUoYPGf7MJ72dSIeRTnP1FtyTE/XqVMD0HEDf1cC47boE1gAUsyAoa+QLp9LeBKhPsDL9G2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721832009; c=relaxed/simple;
	bh=wA5+ox4GtwSVQ1m25C8rgzKbI2kA9MhB8gChFIdvyzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0FQ+Y7N/53I6FTGXNJcfA+M+94fpDilztnhI8t4HjAGWxuZiOWp10ybv5Av25XtLvPHNr0ebK6plzG8tDjLgIiCnNfd9OJFYqrUxD1T+4Sy+qgGv+t0AFWnVbAydXRtv8jTKoK2vwnmtX4l++AvqhgIAHGXUQK+W7KF2xoYG7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ChXOKpf3; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721832008; x=1753368008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wA5+ox4GtwSVQ1m25C8rgzKbI2kA9MhB8gChFIdvyzA=;
  b=ChXOKpf3P+VESTfKTaxJT1SyafvkSGZBJLvK3GQbDnb7PJ3O9VVRf74n
   uj88apADeVcsfUtHsWGu1kjPt9yhFtXcSVSxor2zqSFrpe1qBJNEpL3Zd
   e3hQZg6uBxm8EhtYNlWTvFLFPJuVEEXxcLDje5erfeuhUh6Tq2zcBZGe4
   BaxoYdhfwNSIcnkz55MXPCKtqpvXIjZMfijXGfpnN2CvM4bP0GYdc9lZ6
   VMROoB0dlF9LRUD9dqYMaAhQJ9d++MvrgjvxqUtufkdvaM0d/UgShleHP
   8Z9P9Al2JiJYoEN4p4nWeFiU2zpzt3IdCPYWzSHECJcgQdazNdIgAWJZU
   A==;
X-CSE-ConnectionGUID: xz8d8kKSSYOYlM0AoT6ReA==
X-CSE-MsgGUID: XaghIOzWT5SIV7RfPRxk0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="12692007"
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="12692007"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 07:40:07 -0700
X-CSE-ConnectionGUID: jrk1Qh8tTY2wMt8QdoK3wA==
X-CSE-MsgGUID: U8qNAMugQUyKShDiIekrEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="52298777"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa007.fm.intel.com with ESMTP; 24 Jul 2024 07:40:02 -0700
Date: Wed, 24 Jul 2024 22:55:46 +0800
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
Message-ID: <ZqEV8uErCn+QkOw8@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-3-zhao1.liu@intel.com>
 <87wmld361y.fsf@pond.sub.org>
 <Zp5tBHBoeXZy44ys@intel.com>
 <87h6cfowei.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6cfowei.fsf@pond.sub.org>

Hi Markus,

I realized I should reply this mail first...

On Wed, Jul 24, 2024 at 01:35:17PM +0200, Markus Armbruster wrote:
> Date: Wed, 24 Jul 2024 13:35:17 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi Markus,
> >
> > On Mon, Jul 22, 2024 at 03:33:13PM +0200, Markus Armbruster wrote:
> >> Date: Mon, 22 Jul 2024 15:33:13 +0200
> >> From: Markus Armbruster <armbru@redhat.com>
> >> Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
> >> 
> >> Zhao Liu <zhao1.liu@intel.com> writes:
> >> 
> >> > Introduce smp-cache object so that user could define cache properties.
> >> >
> >> > In smp-cache object, define cache topology based on CPU topology level
> >> > with two reasons:
> >> >
> >> > 1. In practice, a cache will always be bound to the CPU container
> >> >    (either private in the CPU container or shared among multiple
> >> >    containers), and CPU container is often expressed in terms of CPU
> >> >    topology level.
> >> > 2. The x86's cache-related CPUIDs encode cache topology based on APIC
> >> >    ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
> >> >    relies on also requires CPU containers to help indicate the private
> >> >    shared hierarchy of the cache. Therefore, for SMP systems, it is
> >> >    natural to use the CPU topology hierarchy directly in QEMU to define
> >> >    the cache topology.
> >> >
> >> > Currently, separated L1 cache (L1 data cache and L1 instruction cache)
> >> > with unified higher-level cache (e.g., unified L2 and L3 caches), is the
> >> > most common cache architectures.
> >> >
> >> > Therefore, enumerate the L1 D-cache, L1 I-cache, L2 cache and L3 cache
> >> > with smp-cache object to add the basic cache topology support.
> >> >
> >> > Suggested-by: Daniel P. Berrange <berrange@redhat.com>
> >> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> >> 
> >> [...]
> >> 
> >> > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> >> > index 82413c668bdb..8b8c0e9eeb86 100644
> >> > --- a/qapi/machine-common.json
> >> > +++ b/qapi/machine-common.json
> >> > @@ -64,3 +64,53 @@
> >> >    'prefix': 'CPU_TOPO_LEVEL',
> >> >    'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
> >> >              'die', 'socket', 'book', 'drawer', 'default' ] }
> >> > +
> >> > +##
> >> > +# @SMPCacheName:
> >> 
> >> Why the SMP in this name?  Because it's currently only used by SMP
> >> stuff?  Or is there another reason I'm missing?
> >
> > Yes, I suppose it can only be used in SMP case.
> >
> > Because Intel's heterogeneous CPUs have different topologies for cache,
> > for example, Alderlake's L2, for P core, L2 is per P-core, but for E
> > core, L2 is per module (4 E cores per module). Thus I would like to keep
> > the topology semantics of this object and -smp as consistent as possible.
> >
> > Do you agree?
> 
> I don't know enough to meaningfully agree or disagree.  I know just
> enough to annoy you with questions :)

Welcome and no problem!

> This series adds a way to configure caches.
> 
> Structure of the configuration data: a list
> 
>     [{"name": N, "topo": T}, ...]
> 
> where N can be "l1d", "l1i", "l2", or "l3",
>   and T can be "invalid", "thread", "core", "module", "cluster",
>                "die", "socket", "book", "drawer", or "default".
> 
> What's the use case?  The commit messages don't tell.

i386 has the default cache topology model: l1 per core/l2 per core/l3
per die.

Cache topology affects scheduler performance, e.g., kernel's cluster
scheduling.

Of course I can hardcode some cache topology model in the specific cpu
model that corresponds to the actual hardware, but for -cpu host/max,
the default i386 cache topology model has no flexibility, and the
host-cpu-cache option doesn't have enough fine-grained control over the
cache topology.

So I want to provide a way to allow user create more fleasible cache
topology. Just like cpu topology.

> Why does that use case make no sense without SMP?

As the example I mentioned, for Intel hyrbid architecture, P cores has
l2 per core and E cores has l2 per module. Then either setting the l2
topology level as core nor module, can emulate the real case.

Even considering the more extreme case of Intel 14th MTL CPU, where
some E cores have L3 and some don't even have L3. As well as the last
time you and Daniel mentioned that in the future we could consider
covering more cache properties such as cache size. But the l3 size can
be different in the same system, like AMD's x3D technology. So
generally configuring properties for @name in a list can't take into
account the differences of heterogeneous caches with the same @name.

Hope my poor english explains the problem well. :-)

> Can the same @name occur multiple times?  Documentation doesn't tell.
> If yes, what does that mean?

Yes, this means the later one will override the previous one with the same
name.

> Say we later add value "l1" for unified level 1 cache.  Would "l1" then
> conflict with "l1d" and "l1u"?

Yes, we should check in smp/machine code and ban l1 and l1i/l1d at the
same time. This check I suppose is easy to add.

> May @topo be "invalid"?  Documentation doesn't tell.  If yes, what does
> that mean?

Yes, just follow the intel's spec, invalid means the current topology
information is invalid, which is used to encode x86 CPUIDs. So when I
move this level to qapi, I just keeped this. Otherwise, I need to
re-implement the i386 specific invalid level.

> >> The more idiomatic QAPI name would be SmpCacheName.  Likewise for the
> >> other type names below.
> >
> > I hesitated here as well, but considering that SMPConfiguration is "SMP"
> > and not "Smp", it has that name. I'll change to SmpCacheName for strict
> > initial capitalization.
> >
> >> > +#
> >> > +# An enumeration of cache for SMP systems.  The cache name here is
> >> > +# a combination of cache level and cache type.
> >> 
> >> The first sentence feels awkward.  Maybe
> >> 
> >>    # Caches an SMP system may have.
> >> 
> >> > +#
> >> > +# @l1d: L1 data cache.
> >> > +#
> >> > +# @l1i: L1 instruction cache.
> >> > +#
> >> > +# @l2: L2 (unified) cache.
> >> > +#
> >> > +# @l3: L3 (unified) cache
> >> > +#
> >> > +# Since: 9.1
> >> > +##
> >> 
> >> This assumes the L1 cache is split, and L2 and L3 are unified.
> >> 
> >> If we model a system with say a unified L1 cache, we'd simply extend
> >> this enum.  No real difference to extending it for additional levels.
> >> Correct?
> >
> > Yes. For unified L1, we just need add a "l1" which is opposed to l1i/l1d.
> >
> >> > +{ 'enum': 'SMPCacheName',
> >> > +  'prefix': 'SMP_CACHE',
> >> 
> >> Why not call it SmpCache, and ditch 'prefix'?
> >
> > Because the SMPCache structure in smp_cache.h uses the similar name:
> >
> > +#define TYPE_SMP_CACHE "smp-cache"
> > +OBJECT_DECLARE_SIMPLE_TYPE(SMPCache, SMP_CACHE)
> > +
> > +struct SMPCache {
> > +    Object parent_obj;
> > +
> > +    SMPCacheProperty props[SMP_CACHE__MAX];
> > +};
> >
> > Naming is always difficult,
> 
> Oh yes.
> 
> >                             so I would use Smpcache here if you feel that
> > SmpCache is sufficient to distinguish it from SMPCache, or I would also
> > rename the SMPCache structure to SMPCacheState in smp_cache.h.
> >
> > Which way do you prefer?
> 
> Having both QAPI enum SmpCache and handwritten type SMPCache is clearly
> undesirable.
> 
> I retract my suggestion to name the enum SmpCache.  The thing clearly is
> not a cache.  SmpCacheName is better.
> 
> If you drop 'prefix', the generated C enum values look like
> SMP_CACHE_NAME_FOO.  Would that work for you?

I think the SmpCacheName is ok, since there's no other better names.

> The "name" part bothers me a bit.  A name doesn't define what something
> is.  A type does.  SmpCacheType?

Ah, I also considerred this. I didn't use "type" because people usually
uses cache type to indicate INSTRUCTION/DATA/UNIFIED and cache level to
indicate LEVEL 1/LEVEL 2/LEVEL 3. The enumeration here is a combination of
type+level. So I think it's better to avoid the type term.

> >> > +  'data': [ 'l1d', 'l1i', 'l2', 'l3' ] }
> >> 
> >> > +
> >> > +##
> >> > +# @SMPCacheProperty:
> >> 
> >> Sure we want to call this "property" (singular) and not "properties"?
> >> What if we add members to this type?
> >> 
> >> > +#
> >> > +# Cache information for SMP systems.
> >> > +#
> >> > +# @name: Cache name.
> >> > +#
> >> > +# @topo: Cache topology level.  It accepts the CPU topology
> >> > +#     enumeration as the parameter, i.e., CPUs in the same
> >> > +#     topology container share the same cache.
> >> > +#
> >> > +# Since: 9.1
> >> > +##
> >> > +{ 'struct': 'SMPCacheProperty',
> >> > +  'data': {
> >> > +  'name': 'SMPCacheName',
> >> > +  'topo': 'CpuTopologyLevel' } }
> >> 
> >> We tend to avoid abbreviations in the QAPI schema.  Please consider
> >> naming this 'topology'.
> >
> > Sure!
> >
> >> > +
> >> > +##
> >> > +# @SMPCacheProperties:
> >> > +#
> >> > +# List wrapper of SMPCacheProperty.
> >> > +#
> >> > +# @caches: the SMPCacheProperty list.
> >> > +#
> >> > +# Since 9.1
> >> > +##
> >> > +{ 'struct': 'SMPCacheProperties',
> >> > +  'data': { 'caches': ['SMPCacheProperty'] } }
> >> 
> >> Ah, now I see why you used the singular above!
> >> 
> >> However, this type holds the properties of call caches.  It is a list
> 
> "of all caches" (can't type).

Sorry I didn't get your point?

> >> where each element holds the properties of a single cache.  Calling the
> >> former "cache property" and the latter "cache properties" is confusing.
> >
> > Yes...
> >
> >> SmpCachesProperties and SmpCacheProperties would put the singular
> >> vs. plural where it belongs.  Sounds a bit awkward to me, though.
> >> Naming is hard.
> >
> > For SmpCachesProperties, it's easy to overlook the first "s".
> >
> >> Other ideas, anybody?
> >
> > Maybe SmpCacheOptions or SmpCachesPropertyWrapper?
> 
> I wonder why we have a single QOM object to configure all caches, and
> not one QOM object per cache.

I have the thoughts and questions here:

https://lore.kernel.org/qemu-devel/20240704031603.1744546-1-zhao1.liu@intel.com/T/#m8adba8ba14ebac0c9935fbf45983cc71e53ccf45

We could discuss this issue in that thread :-).

> >> > diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
> >> > index b1581988e4eb..25394f2cda50 100644
> >> > --- a/qapi/qapi-schema.json
> >> > +++ b/qapi/qapi-schema.json
> >> > @@ -64,11 +64,11 @@
> >> >  { 'include': 'compat.json' }
> >> >  { 'include': 'control.json' }
> >> >  { 'include': 'introspect.json' }
> >> > -{ 'include': 'qom.json' }
> >> > -{ 'include': 'qdev.json' }
> >> >  { 'include': 'machine-common.json' }
> >> >  { 'include': 'machine.json' }
> >> >  { 'include': 'machine-target.json' }
> >> > +{ 'include': 'qom.json' }
> >> > +{ 'include': 'qdev.json' }
> >> >  { 'include': 'replay.json' }
> >> >  { 'include': 'yank.json' }
> >> >  { 'include': 'misc.json' }
> >> 
> >> Worth explaining in the commit message, I think.
> >
> > Because of the include relationship between the json files, I need to
> > change the order. I had a "crazy" proposal to clean up this:
> > https://lore.kernel.org/qemu-devel/20240517062748.782366-1-zhao1.liu@intel.com/
> >
> > Thanks,
> > Zhao
> 

