Return-Path: <kvm+bounces-22058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E114B93909C
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 16:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 974702816BD
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8069D16D9DA;
	Mon, 22 Jul 2024 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WxeUGeWV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4D316CD30
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721658398; cv=none; b=iPGb9BOAI4rb/S7vPzMlYxYNGAE7JiBhsdq8sMPBsZ00tr5LtnHcYNZppE68csdM9xuqOmzwA/5tm+fYsSyMnNOS1uKvu1LxHwQR7dFvWBB3iF+mYgBjk8/SI4aZGZdvFCCzCw2FrmprupLSe3zG8rLakTmT/8IFHWTNS6ocyFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721658398; c=relaxed/simple;
	bh=OsrIUd37YeYaTA7dO/rYy+a/KCssuHBkjLNEx5suQu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtWUqQfm6y3vMTOC967dZQ0Zf9C5ITQ1ohrmYdVAzb7Dz/6jYPw0m/J1tLGTfgwNX/Zv83MstV3nSVZ4W/Nk0cs8SMrqcfU34dCODWqjpnQ+19WzsBUq+oxdRWliCi8wxkCqorWiljtnyATIf1jGKYdIyDKHW8XZsp5JgGfFgI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WxeUGeWV; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721658397; x=1753194397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OsrIUd37YeYaTA7dO/rYy+a/KCssuHBkjLNEx5suQu0=;
  b=WxeUGeWV8gsWEKj4J1z8TcE/Ct7Ii9t+8e+N6+6lSZ7kQIToB6ydrwM4
   L+DZ98z5oud4QQPMnOwUfndzst9Br7bIdfNK3HxSFCKOUn/C9whWXg8Sg
   o7ByKiz8J+KEdH7TrMDC9AyDA6Az+Reu+6Luni5pMS/E8u1DLbdY29FN5
   bLU7gTfmj6a1bM5VfTnb06ta39jMsYZQvSf62mx/swQ3KfEieZcbmBe/0
   x6/Qo2bWkQMO3RNt9SIZFB/Hw+5Lwbdo7Zk0Mpf6bhXno2Kl2weI54Ke6
   EoQs2PxtLUeODisoPZtB7pjnS2wuQzQnrX9+Uq5/QFuFljRsTKpSH9SSW
   A==;
X-CSE-ConnectionGUID: A+t8T6xsS9W549LZ/TUGuQ==
X-CSE-MsgGUID: mpYas/VYSOaVO9PecR/VGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11141"; a="30617140"
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="30617140"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 07:26:37 -0700
X-CSE-ConnectionGUID: +SEajsCAQSm91RWdetg5tQ==
X-CSE-MsgGUID: RxjqKHH3QVySpkXovI9GSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="51555979"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 22 Jul 2024 07:26:30 -0700
Date: Mon, 22 Jul 2024 22:42:14 +0800
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
Message-ID: <Zp5vxtXWDeHAdPok@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-9-zhao1.liu@intel.com>
 <87r0bl35ug.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0bl35ug.fsf@pond.sub.org>

Hi Markus,

On Mon, Jul 22, 2024 at 03:37:43PM +0200, Markus Armbruster wrote:
> Date: Mon, 22 Jul 2024 15:37:43 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache
>  object
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> This patch is just documentation.  The code got added in some previous
> patch.  Would it make sense to squash this patch into that previous
> patch?

OK, I'll merge them.

> > ---
> > Changes since RFC v2:
> >  * Rewrote the document of smp-cache object.
> >
> > Changes since RFC v1:
> >  * Use "*_cache=topo_level" as -smp example as the original "level"
> >    term for a cache has a totally different meaning. (Jonathan)
> > ---
> >  qemu-options.hx | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 58 insertions(+)
> >
> > diff --git a/qemu-options.hx b/qemu-options.hx
> > index 8ca7f34ef0c8..4b84f4508a6e 100644
> > --- a/qemu-options.hx
> > +++ b/qemu-options.hx
> > @@ -159,6 +159,15 @@ SRST
> >          ::
> >  
> >              -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
> > +
> > +    ``smp-cache='id'``
> > +        Allows to configure cache property (now only the cache topology level).
> > +
> > +        For example:
> > +        ::
> > +
> > +            -object '{"qom-type":"smp-cache","id":"cache","caches":[{"name":"l1d","topo":"core"},{"name":"l1i","topo":"core"},{"name":"l2","topo":"module"},{"name":"l3","topo":"die"}]}'
> > +            -machine smp-cache=cache
> >  ERST
> >  
> >  DEF("M", HAS_ARG, QEMU_OPTION_M,
> > @@ -5871,6 +5880,55 @@ SRST
> >          ::
> >  
> >              (qemu) qom-set /objects/iothread1 poll-max-ns 100000
> > +
> > +    ``-object '{"qom-type":"smp-cache","id":id,"caches":[{"name":cache_name,"topo":cache_topo}]}'``
> > +        Create an smp-cache object that configures machine's cache
> > +        property. Currently, cache property only include cache topology
> > +        level.
> > +
> > +        This option must be written in JSON format to support JSON list.
> 
> Why?

I'm not familiar with this, so I hope you could educate me if I'm wrong.

All I know so far is for -object that defining a list can only be done in
JSON format and not with a numeric index like a keyval based option, like:

-object smp-cache,id=cache0,caches.0.name=l1i,caches.0.topo=core: Parameter 'caches' is missing

the above doesn't work.

Is there any other way to specify a list in command line?

> > +
> > +        The ``caches`` parameter accepts a list of cache property in JSON
> > +        format.
> > +
> > +        A list element requires the cache name to be specified in the
> > +        ``name`` parameter (currently ``l1d``, ``l1i``, ``l2`` and ``l3``
> > +        are supported). ``topo`` parameter accepts CPU topology levels
> > +        including ``thread``, ``core``, ``module``, ``cluster``, ``die``,
> > +        ``socket``, ``book``, ``drawer`` and ``default``. The ``topo``
> > +        parameter indicates CPUs winthin the same CPU topology container
> > +        are sharing the same cache.
> > +
> > +        Some machines may have their own cache topology model, and this
> > +        object may override the machine-specific cache topology setting
> > +        by specifying smp-cache object in the -machine. When specifying
> > +        the cache topology level of ``default``, it will honor the default
> > +        machine-specific cache topology setting. For other topology levels,
> > +        they will override the default setting.
> > +
> > +        An example list of caches to configure the cache model (l1d cache
> > +        per core, l1i cache per core, l2 cache per module and l3 cache per
> > +        socket) supported by PC machine might look like:
> > +
> > +        ::
> > +
> > +              {
> > +                "caches": [
> > +                   { "name": "l1d", "topo": "core" },
> > +                   { "name": "l1i", "topo": "core" },
> > +                   { "name": "l2", "topo": "module" },
> > +                   { "name": "l3", "topo": "socket" },
> > +                ]
> > +              }
> > +
> > +        An example smp-cache object would look like:()
> > +
> > +        .. parsed-literal::
> > +
> > +             # |qemu_system| \\
> > +                 ... \\
> > +                 -object '{"qom-type":"smp-cache","id":id,"caches":[{"name":cache_name,"topo":cache_topo}]}' \\
> > +                 ...
> >  ERST
> 

