Return-Path: <kvm+bounces-23832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5628894E953
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 11:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 126E2284058
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 09:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB68E16D4FC;
	Mon, 12 Aug 2024 09:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UBgIPHrw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2543316D4FD
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 09:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723453739; cv=none; b=Guk1EoOfT32hE8k7wJ0LMPmYXOAeGwgZVh3aPQxw0iqrRiR0TKnQotfc6HcXNDt5LGAdCXcJfkCjylxCb1ELqw61mFghDXJX8U6GgEqYw2RNCt1+5lssqovCz6wKcsjWnqPpVgfZsHicZSJXwjB02Jl9n8lxFGiQDzGfn5E9CoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723453739; c=relaxed/simple;
	bh=9upHtUme4hJXCWHnm4fE6plmVolSyA9aoEU22vIwsLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXEAZq3Wp297Eck8u307aFvsjtDr5mLdYbthI/rOotHeki0t7nBLnU9Ca3Ax84HnTwvgBDwxePvZV/bJFsCNVVDKT/LI7m3OgdywiP3F2ohsHuAnBgfkk8mmpv26S63XbuAHUdMc+lEPsvNZx2t/7g48379cm0npg3CQrt89Vx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UBgIPHrw; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723453738; x=1754989738;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9upHtUme4hJXCWHnm4fE6plmVolSyA9aoEU22vIwsLA=;
  b=UBgIPHrwkwuZp7c4eDpThM7YbsNvEUamYX58fUbHkL53lrxpXWZrCR4w
   LT0/29kchTINpSZ4ExNjGX5C5m/aZKEPeXvhAS+MYvbJWxdqtTEGUetoT
   0998+CMJx5SokNf0CRVb4g0N1zl4MnBuG6sKog7/yrkyOB8/7Fz49tAjk
   Yjr/QV7JV8+9FJIykWf1SImzq9BgFzylgnboP4f+xDgWNEK92gDQv9kW2
   g773E+21RQwa1XZYV0oB1yKTA/ItBm22aH/0CBLWDHda5tVDYyQWoSk9R
   juxI/e9LpLGl77PnfWkZ/pBdpIGMZtcyWn+7ZuzGq0LIw+BxqabB4NDQ3
   A==;
X-CSE-ConnectionGUID: fMwWwX/aSJiD320wE9T5ug==
X-CSE-MsgGUID: 98dvSY7/SoypLjTZqrtVRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="12961294"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="12961294"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 02:08:58 -0700
X-CSE-ConnectionGUID: WVglJYQSR/u4QsfjIWt7qA==
X-CSE-MsgGUID: z5WsMxXFRmm+3kttHZfn7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="88855982"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa002.jf.intel.com with ESMTP; 12 Aug 2024 02:08:53 -0700
Date: Mon, 12 Aug 2024 17:24:43 +0800
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
Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache object
Message-ID: <ZrnU25wxuqgST7x1@intel.com>
References: <20240704031603.1744546-9-zhao1.liu@intel.com>
 <87r0bl35ug.fsf@pond.sub.org>
 <Zp5vxtXWDeHAdPok@intel.com>
 <87bk2nnev2.fsf@pond.sub.org>
 <ZqEN1kZaQcuY4UPG@intel.com>
 <87le1psuv3.fsf@pond.sub.org>
 <ZqtXP9MViOlyhEsu@intel.com>
 <87mslweb38.fsf@pond.sub.org>
 <ZqyRik4UHHz3xaKl@intel.com>
 <8734ndj33j.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734ndj33j.fsf@pond.sub.org>

Hi Markus,

On Fri, Aug 09, 2024 at 02:24:48PM +0200, Markus Armbruster wrote:
> Date: Fri, 09 Aug 2024 14:24:48 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache
>  object
> 
> I apologize for the delay.

You're welcome! I appreciate your time, guidance and feedback.

> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > On Thu, Aug 01, 2024 at 01:28:27PM +0200, Markus Armbruster wrote:
> 
> [...]
> 
> >> Can you provide a brief summary of the design alternatives that have
> >> been proposed so far?  Because I've lost track.
> >
> > No problem!
> >
> > Currently, we have the following options:
> >
> > * 1st: The first one is just to configure cache topology with several
> >   options in -smp:
> >
> >   -smp l1i-cache-topo=core,l1d-cache-topo-core
> >
> >   This one lacks scalability to support the cache size that ARM will
> >   need in the future.
> 
> -smp sets machine property "smp" of QAPI type SMPConfiguration.
> 
> So this one adds members l1i-cache-topo, l1d-cache-topo, ... to
> SMPConfiguration.

Yes.

> > * 2nd: The cache list object in -smp.
> >
> >   The idea was to use JSON to configure the cache list. However, the
> >   underlying implementation of -smp at the moment is keyval parsing,
> >   which is not compatible with JSON.
> 
> Keyval is a variation of the QEMU's traditional KEY=VALUE,... syntax
> that can serve as an alternative to JSON, with certain restrictions.
> Ideally, we provide both JSON and keyval syntax on the command line.

I see. It's the ideal state of the CLI, and -machine and -smp haven't
arrived here yet.

> Example: -blockdev supports both JSON and keyval.
>     JSON:   -blockdev '{"driver": "null-co", "node-name": "node0"}'
>     keyval: -blockdev null-co,node-name=node0
> 
> Unfortunately, we have many old interfaces that still lack JSON support.
> 
> >   If we can not insist on JSON format, then cache lists can also be
> >   implemented in the following way:
> >   
> >   -smp caches.0.name=l1i,caches.0.topo=core,\
> >        caches.1.name=l1d,caches.1.topo=core
> 
> This one adds a single member caches to SMPConfiguration.  It is an
> array of objects.

Yes.

> > * 3rd: The cache list object linked in -machine.
> >
> >   Considering that -object is JSON-compatible so that defining lists via
> >   JSON is more friendly, I implemented the caches list via -object and
> >   linked it to MachineState:
> >
> >   -object '{"qom-type":"smp-cache","id":"obj","caches":[{"name":"l1d","topo":"core"},{"name":"l1i","topo":"core"}]}'
> >   -machine smp-caches=obj
> 
> This one wraps the same array of objects in a new user-creatable object,
> then sets machine property "smp-caches" to that object.
> 
> We can set machine properties directly with -machine.  But -machine
> doesn't support JSON, yet.
> 
> Wrapping in an object moves the configuration to -object, which does
> support JSON.
> 
> Half way between 2nd and 3rd:
> 
>   * Cache list object in machine
> 
>     -machine caches.0.name=l1i,caches.0.topo=core,\
>              caches.1.name=l1d,caches.1.topo=core

I got your point, and putting the array in -machine does align with the
design of the other machine options nowadays.

> > * 4th: The per cache object without any list:
> >
> >   -object smp-cache,id=cache0,name=l1i,topo=core \
> >   -object smp-cache,id=cache1,name=l1d,topo=core
> >
> >   This proposal is clearer, but there are a few opens:
> >   - I plan to push qom-topo forward, which would abstract CPU related
> >     topology levels and cache to "device" instead of object. Is there a
> >     conflict here?
> 
> Can't say, since I don't understand where you want to go.
> 
> Looks like your trying to design an interface for what you want to do
> now, and are wondering whether it could evolve to accomodate what you
> want to do later.
> 
> It's often better to design the interface for everything you already
> know you want to do, then take out the parts you want to do later.

Thanks! From this point of view, then per cache of objects does not meet
my needs.

> >   - Multiple cache objects can't be linked to the machine on the command
> >     line, so I maintain a static cache list in smp_cache.c and expose
> >     the cache information to the machine through some interface. is this
> >     way acceptable?
> >
> >
> > In summary, the 4th proposal was the most up in the air, as it looked to
> > be conflict with the hybrid topology I wanted to do (and while hybrid
> > topology may not be accepted by the community either, I thought it would
> > be best for the two work to be in the same direction).
> >
> > The difference between 2nd and 3rd is about the JSON requirement, if JSON
> > is mandatory for now then it's 3rd, if it's not mandatory (or accept to
> > make -machine/-smp support JSON in the future), 2nd looks cleaner, which
> > puts the caches list in -smp.
> 
> I'd rather not let syntactic limitations of our CLI dictate the
> structure of our configuration data.  Design the structure *first*.
> Only then start to think about CLI.  Our CLI is an unholy mess, and
> thinking about it too early risks getting lost in the weeds.  I fear
> this is what happened to you.

Indeed, that's my dilemma, lost in the world of CLIs.

> If I forcibly ignore all the considerations related to concrete syntax
> in your message, a structure seems to emerge: there's a set of caches
> identified by name (l1i, l1d, ...), and for each cache, we have a number
> of configurable properties (topology level, ...).  Makes sense?

Yes, you're right!

> What else will you need to configure in the future?

Maybe cache size, as Jonathan mentioned for Arm side.

> By the way, extending -machine to support JSON looks feasible to me at a
> glance.
 
Thanks again! Then I made it clear that it would be most appropriate to
place the cache array in -machine, i.e., it's extensible and consistent
with the design of the rest of the machine's properties, as well as
consistent with my long-term needs.

Later on, if -machine is able to support JSON, it will also benefit from
it. If I have time, I will also think about how -machine can support
JSON.

Regards,
Zhao


