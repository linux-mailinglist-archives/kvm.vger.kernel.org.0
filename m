Return-Path: <kvm+bounces-22163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2022493B239
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 16:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E8DF1C2030F
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 14:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C19158D69;
	Wed, 24 Jul 2024 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="azQyDKUA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67A3157E6C
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721829933; cv=none; b=fBKp3Px1qclIom/uNzF4Tx69o5u+3ZzOrFy6YYp+MzMXfvcSFwP9n7Fs6Zb8VSto/htdCtmI4bC8AFsJQr3i/Xfn2sfSxVpYc3/JsfHQdylxz8mVa7LYgTx6l7dCE6SbkdKpAvkanSRHvd5HhMy80Jh1VK7OPecti7rb3ck1KsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721829933; c=relaxed/simple;
	bh=nHiDPbIFPaMJ6FYvivlu7Y0409aOZMDmB6P2KkiCJoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnJ1/lm6vCwCyib/AYy9vttQlcsigoT4rMDua5EmSh6E3QrYziHdpmtUkLENO+PGFVeDoodt+b+oEcWSkp+MdqrV4E8ZXYS80BEfbIuTom1elDue/mtYc3mNIwmBia6pUvGJl/HuISRMNM1Wf+Jnvz0AviBJN3Ak2ru6/1JOLuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=azQyDKUA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721829932; x=1753365932;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nHiDPbIFPaMJ6FYvivlu7Y0409aOZMDmB6P2KkiCJoM=;
  b=azQyDKUAQkJkK5NExZLtAsJ4yGP93jiDO3eXSTuBor4mcK+pQI65lm2u
   C28DM1PddzSNNM7wzi4p2kird7gFcCyMOyaUJajQRTG9O4nTAQVp1izSA
   UzONv4g4xvGhuoIbN9sQsV7oA4YRQfM1ueDy7fnLC78lxzs95qRgzo46n
   Mf9Oalus5H/SMszXupZqWHFA63HDOVKS83Bk+VzuAxCGLVt8bq/F8/1rM
   T2dj9/xz8QNNGh3P1Xbn9grYtgfufPDLD/oXUEj3VsR1o0jMUbd4TFV0O
   OINvEj+HtLpVHw5jVBk4vcJ8yVDkJY4YiQv7yIs4Cd2Wm0niVeOy8p4mM
   Q==;
X-CSE-ConnectionGUID: WHxv/sVaTZSxn35JYbbMZw==
X-CSE-MsgGUID: B+B6ZoQ+TQK00e1EvprlZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="23270109"
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="23270109"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 07:05:31 -0700
X-CSE-ConnectionGUID: +ugYcPMiQx6y3EvboMm6nw==
X-CSE-MsgGUID: y6FeXgEjQiKv6wybWSsJSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="56914510"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa005.fm.intel.com with ESMTP; 24 Jul 2024 07:05:26 -0700
Date: Wed, 24 Jul 2024 22:21:10 +0800
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
Message-ID: <ZqEN1kZaQcuY4UPG@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-9-zhao1.liu@intel.com>
 <87r0bl35ug.fsf@pond.sub.org>
 <Zp5vxtXWDeHAdPok@intel.com>
 <87bk2nnev2.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bk2nnev2.fsf@pond.sub.org>

Hi Markus and Daniel,

I have the questions about the -object per cache implementation:

On Wed, Jul 24, 2024 at 02:39:29PM +0200, Markus Armbruster wrote:
> Date: Wed, 24 Jul 2024 14:39:29 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache
>  object
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi Markus,
> >
> > On Mon, Jul 22, 2024 at 03:37:43PM +0200, Markus Armbruster wrote:
> >> Date: Mon, 22 Jul 2024 15:37:43 +0200
> >> From: Markus Armbruster <armbru@redhat.com>
> >> Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache
> >>  object
> >> 
> >> Zhao Liu <zhao1.liu@intel.com> writes:
> >> 
> >> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> >> 
> >> This patch is just documentation.  The code got added in some previous
> >> patch.  Would it make sense to squash this patch into that previous
> >> patch?
> >
> > OK, I'll merge them.
> >
> >> > ---
> >> > Changes since RFC v2:
> >> >  * Rewrote the document of smp-cache object.
> >> >
> >> > Changes since RFC v1:
> >> >  * Use "*_cache=topo_level" as -smp example as the original "level"
> >> >    term for a cache has a totally different meaning. (Jonathan)
> >> > ---
> >> >  qemu-options.hx | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
> >> >  1 file changed, 58 insertions(+)
> >> >
> >> > diff --git a/qemu-options.hx b/qemu-options.hx
> >> > index 8ca7f34ef0c8..4b84f4508a6e 100644
> >> > --- a/qemu-options.hx
> >> > +++ b/qemu-options.hx
> >> > @@ -159,6 +159,15 @@ SRST
> >> >          ::
> >> >  
> >> >              -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
> >> > +
> >> > +    ``smp-cache='id'``
> >> > +        Allows to configure cache property (now only the cache topology level).
> >> > +
> >> > +        For example:
> >> > +        ::
> >> > +
> >> > +            -object '{"qom-type":"smp-cache","id":"cache","caches":[{"name":"l1d","topo":"core"},{"name":"l1i","topo":"core"},{"name":"l2","topo":"module"},{"name":"l3","topo":"die"}]}'
> >> > +            -machine smp-cache=cache
> >> >  ERST
> >> >  
> >> >  DEF("M", HAS_ARG, QEMU_OPTION_M,
> >> > @@ -5871,6 +5880,55 @@ SRST
> >> >          ::
> >> >  
> >> >              (qemu) qom-set /objects/iothread1 poll-max-ns 100000
> >> > +
> >> > +    ``-object '{"qom-type":"smp-cache","id":id,"caches":[{"name":cache_name,"topo":cache_topo}]}'``
> >> > +        Create an smp-cache object that configures machine's cache
> >> > +        property. Currently, cache property only include cache topology
> >> > +        level.
> >> > +
> >> > +        This option must be written in JSON format to support JSON list.
> >> 
> >> Why?
> >
> > I'm not familiar with this, so I hope you could educate me if I'm wrong.
> >
> > All I know so far is for -object that defining a list can only be done in
> > JSON format and not with a numeric index like a keyval based option, like:
> >
> > -object smp-cache,id=cache0,caches.0.name=l1i,caches.0.topo=core: Parameter 'caches' is missing
> >
> > the above doesn't work.
> >
> > Is there any other way to specify a list in command line?
> 
> The command line is a big, sprawling mess :)
> 
> -object supports either a JSON or a QemuOpts argument.  *Not* keyval!
> 
> Both QemuOpts and keyval parse something like KEY=VALUE,...  Keyval
> supports arrays and objects via dotted keys.  QemuOpts doesn't natively
> support arrays and objects, but its users can hack around that
> limitation in various ways.  -object doesn't.  So you're right, it's
> JSON or bust here.
> 
> However, if we used one object per cache instead, we could get something
> like
> 
>     -object smp-cache,name=l1d,...
>     -object smp-cache,name=l1u,...
>     -object smp-cache,name=l2,...
>     ...

Current, I use -object to create a smp_cache object, and link it to
MachineState by -machine,smp-cache=obj_id.

Then for the objects per cache, how could I link them to machine?

Is it possible that I create something static in smp_cache.c and expose
all the cache information to machine through some interface?

Additionally, I would like to consider for the long term heterogeneous
cache, as asked before in [1], does the object per cache conflict with
the cache device I'm considering? Considering cache device is further
because I want to create CPU/cache topology via -device and build a
topology tree.

[1]: https://lore.kernel.org/qemu-devel/Zl88DYwLE3ScDF5F@intel.com/

I think this is becoming a nightmare I can't get around. Naming is
difficult, and sorting out interface design I think is also a difficult
task.

If you feel that there is indeed a conflict, then I'm also willing
to fall back to -smp again and do it based on keyval's list, as originally
suggested by Daniel. Sorry for the repetition on thoughts/design, I hope
that discussion with you I can make sense of the current and subsequent
paths without getting out of hand!

Best Regards,
Zhao


