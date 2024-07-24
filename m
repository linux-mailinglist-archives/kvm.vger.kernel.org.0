Return-Path: <kvm+bounces-22157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BDAB93B071
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 13:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8129E1F24C49
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 11:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5FB1581E1;
	Wed, 24 Jul 2024 11:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JevaaGJX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315E322EF2
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721820932; cv=none; b=eqXjOoIe2/p9Ew/ywhTItzSxstQCzsCpODgqnJAWJiw5iqx5pjwe0giZ7XZAcaeJi3xjACT0M0Sj2YO9MxZIR4YEyCaACb7N5g94O0fcUYrFdvnBB5pdvTV55zdifylTXj0Z5i3UBMXxPv3QcNMSOY549JPt5GyeU/kQy7TSjwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721820932; c=relaxed/simple;
	bh=J3iIIgVIX82QTIk1SVlCZc/OskIeeJQXgYZBal4zayk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Vy3dbucYxZAZ/D6SgnV05DOAeAUcRW2eIxmJijDkEyCpJfhUEVuGJiMnqvVcuzudBut9OhwPPG2P86gA+yznP5w6iLoRLGKcynd+bQBtZbd/AziA3trM/U/7NqQdkSPf3PgM5i0f9b9vETnWf0jIJ05CHv8WVXLVLC5jn2uXlMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JevaaGJX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721820928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gt7oiq2zOPx1WuxF9YFCkLZSWSfZxFkV5gZ9VyQnc1s=;
	b=JevaaGJXvRx7GGdoy42SdCjbUjwYx8Z9q/NSiGfu9Zl8ltFBAH48KZejmpmO1A1Y9sPjKg
	PkJt6bjTDeTatbnOUUqKjbkrZ0uBLee5nM1NRvJDctscuEP+yw6clis6ftIhac3XWX9mzB
	Fkj/f91RggCOQutQ2qaMlaOvdGWUv2k=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-hYveDVixMB6AwlyQEuIL6A-1; Wed,
 24 Jul 2024 07:35:25 -0400
X-MC-Unique: hYveDVixMB6AwlyQEuIL6A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEE841955D44;
	Wed, 24 Jul 2024 11:35:22 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B24519560AE;
	Wed, 24 Jul 2024 11:35:20 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 53C4321E668A; Wed, 24 Jul 2024 13:35:17 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Daniel P . =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Eduardo
 Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S . Tsirkin" <mst@redhat.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Eric Blake <eblake@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
  Peter Maydell <peter.maydell@linaro.org>,  Jonathan Cameron
 <Jonathan.Cameron@huawei.com>,  Sia Jee Heng
 <jeeheng.sia@starfivetech.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org,  qemu-riscv@nongnu.org,  qemu-arm@nongnu.org,
  Zhenyu Wang <zhenyu.z.wang@intel.com>,  Dapeng Mi
 <dapeng1.mi@linux.intel.com>,  Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
In-Reply-To: <Zp5tBHBoeXZy44ys@intel.com> (Zhao Liu's message of "Mon, 22 Jul
	2024 22:30:28 +0800")
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
	<20240704031603.1744546-3-zhao1.liu@intel.com>
	<87wmld361y.fsf@pond.sub.org> <Zp5tBHBoeXZy44ys@intel.com>
Date: Wed, 24 Jul 2024 13:35:17 +0200
Message-ID: <87h6cfowei.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Zhao Liu <zhao1.liu@intel.com> writes:

> Hi Markus,
>
> On Mon, Jul 22, 2024 at 03:33:13PM +0200, Markus Armbruster wrote:
>> Date: Mon, 22 Jul 2024 15:33:13 +0200
>> From: Markus Armbruster <armbru@redhat.com>
>> Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
>> 
>> Zhao Liu <zhao1.liu@intel.com> writes:
>> 
>> > Introduce smp-cache object so that user could define cache properties.
>> >
>> > In smp-cache object, define cache topology based on CPU topology level
>> > with two reasons:
>> >
>> > 1. In practice, a cache will always be bound to the CPU container
>> >    (either private in the CPU container or shared among multiple
>> >    containers), and CPU container is often expressed in terms of CPU
>> >    topology level.
>> > 2. The x86's cache-related CPUIDs encode cache topology based on APIC
>> >    ID's CPU topology layout. And the ACPI PPTT table that ARM/RISCV
>> >    relies on also requires CPU containers to help indicate the private
>> >    shared hierarchy of the cache. Therefore, for SMP systems, it is
>> >    natural to use the CPU topology hierarchy directly in QEMU to define
>> >    the cache topology.
>> >
>> > Currently, separated L1 cache (L1 data cache and L1 instruction cache)
>> > with unified higher-level cache (e.g., unified L2 and L3 caches), is the
>> > most common cache architectures.
>> >
>> > Therefore, enumerate the L1 D-cache, L1 I-cache, L2 cache and L3 cache
>> > with smp-cache object to add the basic cache topology support.
>> >
>> > Suggested-by: Daniel P. Berrange <berrange@redhat.com>
>> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
>> 
>> [...]
>> 
>> > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
>> > index 82413c668bdb..8b8c0e9eeb86 100644
>> > --- a/qapi/machine-common.json
>> > +++ b/qapi/machine-common.json
>> > @@ -64,3 +64,53 @@
>> >    'prefix': 'CPU_TOPO_LEVEL',
>> >    'data': [ 'invalid', 'thread', 'core', 'module', 'cluster',
>> >              'die', 'socket', 'book', 'drawer', 'default' ] }
>> > +
>> > +##
>> > +# @SMPCacheName:
>> 
>> Why the SMP in this name?  Because it's currently only used by SMP
>> stuff?  Or is there another reason I'm missing?
>
> Yes, I suppose it can only be used in SMP case.
>
> Because Intel's heterogeneous CPUs have different topologies for cache,
> for example, Alderlake's L2, for P core, L2 is per P-core, but for E
> core, L2 is per module (4 E cores per module). Thus I would like to keep
> the topology semantics of this object and -smp as consistent as possible.
>
> Do you agree?

I don't know enough to meaningfully agree or disagree.  I know just
enough to annoy you with questions :)

This series adds a way to configure caches.

Structure of the configuration data: a list

    [{"name": N, "topo": T}, ...]

where N can be "l1d", "l1i", "l2", or "l3",
  and T can be "invalid", "thread", "core", "module", "cluster",
               "die", "socket", "book", "drawer", or "default".

What's the use case?  The commit messages don't tell.

Why does that use case make no sense without SMP?

Can the same @name occur multiple times?  Documentation doesn't tell.
If yes, what does that mean?

Say we later add value "l1" for unified level 1 cache.  Would "l1" then
conflict with "l1d" and "l1u"?

May @topo be "invalid"?  Documentation doesn't tell.  If yes, what does
that mean?

>> The more idiomatic QAPI name would be SmpCacheName.  Likewise for the
>> other type names below.
>
> I hesitated here as well, but considering that SMPConfiguration is "SMP"
> and not "Smp", it has that name. I'll change to SmpCacheName for strict
> initial capitalization.
>
>> > +#
>> > +# An enumeration of cache for SMP systems.  The cache name here is
>> > +# a combination of cache level and cache type.
>> 
>> The first sentence feels awkward.  Maybe
>> 
>>    # Caches an SMP system may have.
>> 
>> > +#
>> > +# @l1d: L1 data cache.
>> > +#
>> > +# @l1i: L1 instruction cache.
>> > +#
>> > +# @l2: L2 (unified) cache.
>> > +#
>> > +# @l3: L3 (unified) cache
>> > +#
>> > +# Since: 9.1
>> > +##
>> 
>> This assumes the L1 cache is split, and L2 and L3 are unified.
>> 
>> If we model a system with say a unified L1 cache, we'd simply extend
>> this enum.  No real difference to extending it for additional levels.
>> Correct?
>
> Yes. For unified L1, we just need add a "l1" which is opposed to l1i/l1d.
>
>> > +{ 'enum': 'SMPCacheName',
>> > +  'prefix': 'SMP_CACHE',
>> 
>> Why not call it SmpCache, and ditch 'prefix'?
>
> Because the SMPCache structure in smp_cache.h uses the similar name:
>
> +#define TYPE_SMP_CACHE "smp-cache"
> +OBJECT_DECLARE_SIMPLE_TYPE(SMPCache, SMP_CACHE)
> +
> +struct SMPCache {
> +    Object parent_obj;
> +
> +    SMPCacheProperty props[SMP_CACHE__MAX];
> +};
>
> Naming is always difficult,

Oh yes.

>                             so I would use Smpcache here if you feel that
> SmpCache is sufficient to distinguish it from SMPCache, or I would also
> rename the SMPCache structure to SMPCacheState in smp_cache.h.
>
> Which way do you prefer?

Having both QAPI enum SmpCache and handwritten type SMPCache is clearly
undesirable.

I retract my suggestion to name the enum SmpCache.  The thing clearly is
not a cache.  SmpCacheName is better.

If you drop 'prefix', the generated C enum values look like
SMP_CACHE_NAME_FOO.  Would that work for you?

The "name" part bothers me a bit.  A name doesn't define what something
is.  A type does.  SmpCacheType?

>> > +  'data': [ 'l1d', 'l1i', 'l2', 'l3' ] }
>> 
>> > +
>> > +##
>> > +# @SMPCacheProperty:
>> 
>> Sure we want to call this "property" (singular) and not "properties"?
>> What if we add members to this type?
>> 
>> > +#
>> > +# Cache information for SMP systems.
>> > +#
>> > +# @name: Cache name.
>> > +#
>> > +# @topo: Cache topology level.  It accepts the CPU topology
>> > +#     enumeration as the parameter, i.e., CPUs in the same
>> > +#     topology container share the same cache.
>> > +#
>> > +# Since: 9.1
>> > +##
>> > +{ 'struct': 'SMPCacheProperty',
>> > +  'data': {
>> > +  'name': 'SMPCacheName',
>> > +  'topo': 'CpuTopologyLevel' } }
>> 
>> We tend to avoid abbreviations in the QAPI schema.  Please consider
>> naming this 'topology'.
>
> Sure!
>
>> > +
>> > +##
>> > +# @SMPCacheProperties:
>> > +#
>> > +# List wrapper of SMPCacheProperty.
>> > +#
>> > +# @caches: the SMPCacheProperty list.
>> > +#
>> > +# Since 9.1
>> > +##
>> > +{ 'struct': 'SMPCacheProperties',
>> > +  'data': { 'caches': ['SMPCacheProperty'] } }
>> 
>> Ah, now I see why you used the singular above!
>> 
>> However, this type holds the properties of call caches.  It is a list

"of all caches" (can't type).

>> where each element holds the properties of a single cache.  Calling the
>> former "cache property" and the latter "cache properties" is confusing.
>
> Yes...
>
>> SmpCachesProperties and SmpCacheProperties would put the singular
>> vs. plural where it belongs.  Sounds a bit awkward to me, though.
>> Naming is hard.
>
> For SmpCachesProperties, it's easy to overlook the first "s".
>
>> Other ideas, anybody?
>
> Maybe SmpCacheOptions or SmpCachesPropertyWrapper?

I wonder why we have a single QOM object to configure all caches, and
not one QOM object per cache.

>> > diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
>> > index b1581988e4eb..25394f2cda50 100644
>> > --- a/qapi/qapi-schema.json
>> > +++ b/qapi/qapi-schema.json
>> > @@ -64,11 +64,11 @@
>> >  { 'include': 'compat.json' }
>> >  { 'include': 'control.json' }
>> >  { 'include': 'introspect.json' }
>> > -{ 'include': 'qom.json' }
>> > -{ 'include': 'qdev.json' }
>> >  { 'include': 'machine-common.json' }
>> >  { 'include': 'machine.json' }
>> >  { 'include': 'machine-target.json' }
>> > +{ 'include': 'qom.json' }
>> > +{ 'include': 'qdev.json' }
>> >  { 'include': 'replay.json' }
>> >  { 'include': 'yank.json' }
>> >  { 'include': 'misc.json' }
>> 
>> Worth explaining in the commit message, I think.
>
> Because of the include relationship between the json files, I need to
> change the order. I had a "crazy" proposal to clean up this:
> https://lore.kernel.org/qemu-devel/20240517062748.782366-1-zhao1.liu@intel.com/
>
> Thanks,
> Zhao


