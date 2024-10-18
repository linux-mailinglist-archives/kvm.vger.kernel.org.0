Return-Path: <kvm+bounces-29151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A90919A37DF
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 09:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8F691C212A3
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B585918C34B;
	Fri, 18 Oct 2024 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fIQ145qP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE90418C335
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 07:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729238306; cv=none; b=NEd6AsfD/N2FcgSSuw2Tw0nm/e+lw0evhkNjc5pxEKxqgcG77/gDUrDETjR7suUHwf0+Gdc2C1+xx5A5pLmoqS6PV8HSgijdtFp8XePvw+S/4rlzjC8mCEGmSKEJHPgWojmzi0vVrWxH25UjHGTwRGNEaRAM4ziJH2tck5TYwMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729238306; c=relaxed/simple;
	bh=SgGc938UBdrPHVEj7r2d1wHSfBvk1kWLhUVwPuVp5aI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7ecD3zuvUmJWjxyJnmCKCL9qOE6KCFSKV1UBgnPbtkM4KbP3O8NBSd7z3o5H3DH8KwjcAsKlvAVDd82LFOh/d/WCclXmgozOJlgkWzo0hdbsjQXi1HNigp+mFTMbpjVq2zO2TB2eHvhT8kv43vqu2d1dQHFXc47pBtI0F5TOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fIQ145qP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729238303;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=DTTMNicW4OjRcXbKL4oqTcLX63sd7nExpwbEaCF2IcE=;
	b=fIQ145qPi8FO8A+0i3cCB4M9i9sQKDN6WPd7ZRYZx/vohZoHRcb/oy0rYz80tnb2AuWFQH
	8fGOQ1wRAVbT42mfr8+CyB3t/oI6NDxh9xdJMDLmuEWVTa18qKnevNE+Ex1gCken3vMJoo
	L1vINdZO+yqqLQcJUjf0M+kDBtPe6oc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-7mvuoKwiMHmr0nwGMQ75mg-1; Fri,
 18 Oct 2024 03:58:18 -0400
X-MC-Unique: 7mvuoKwiMHmr0nwGMQ75mg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 253291954227;
	Fri, 18 Oct 2024 07:58:15 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EABD19560A3;
	Fri, 18 Oct 2024 07:58:06 +0000 (UTC)
Date: Fri, 18 Oct 2024 08:58:03 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v3 6/7] i386/pc: Support cache topology in -machine for
 PC machine
Message-ID: <ZxIVC-XQaMqOy6Fw@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-7-zhao1.liu@intel.com>
 <ZxEs3DGGgCqGT5yK@redhat.com>
 <ZxHcsPyqT6MLJ9hG@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZxHcsPyqT6MLJ9hG@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Oct 18, 2024 at 11:57:36AM +0800, Zhao Liu wrote:
> Hi Daniel,
> 
> > > +    ``smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel``
> > > +        Define cache properties for SMP system.
> > > +
> > > +        ``cache=cachename`` specifies the cache that the properties will be
> > > +        applied on. This field is the combination of cache level and cache
> > > +        type. It supports ``l1d`` (L1 data cache), ``l1i`` (L1 instruction
> > > +        cache), ``l2`` (L2 unified cache) and ``l3`` (L3 unified cache).
> > > +
> > > +        ``topology=topologylevel`` sets the cache topology level. It accepts
> > > +        CPU topology levels including ``thread``, ``core``, ``module``,
> > > +        ``cluster``, ``die``, ``socket``, ``book``, ``drawer`` and a special
> > > +        value ``default``. If ``default`` is set, then the cache topology will
> > > +        follow the architecture's default cache topology model. If another
> > > +        topology level is set, the cache will be shared at corresponding CPU
> > > +        topology level. For example, ``topology=core`` makes the cache shared
> > > +        by all threads within a core.
> > > +
> > > +        Example:
> > > +
> > > +        ::
> > > +
> > > +            -machine smp-cache.0.cache=l1d,smp-cache.0.topology=core,smp-cache.1.cache=l1i,smp-cache.1.topology=core
> > 
> > There are 4 cache types, l1d, l1i, l2, l3.
> > 
> > In this example you've only set properties for l1d, l1i caches.
> > 
> > What does this mean for l2 / l3 caches ?
> 
> Omitting "cache" will default to using the "default" level.
> 
> I think I should add the above description to the documentation.
> 
> > Are they reported as not existing, or are they to be reported at
> > some built-in default topology level.
> 
> It's the latter.
> 
> If a machine doesn't support l2/l3, then QEMU will also report the error
> like:
> 
> qemu-system-*: l2 cache topology not supported by this machine

Ok, that's good.

> > If the latter, how does the user know what that built-in default is, 
> 
> Currently, the default cache model for x86 is L1 per core, L2 per core,
> and L3 per die. Similar to the topology levels, there is still no way to
> expose this to users. I can descript default cache model in doc.
> 
> But I feel like we're back to the situation we discussed earlier:
> "default" CPU topology support should be related to the CPU model, but
> in practice, QEMU supports it at the machine level. The cache topology
> depends on CPU topology support and can only continue to be added on top
> of the machine.
> 
> So do you think we can add topology and cache information in CpuModelInfo
> so that query-cpu-model-expansion can expose default CPU/cache topology
> information to users?
> 
> This way, users can customize CPU/cache topology in -smp and
> -machine smp-cache. Although the QMP command is targeted at the CPU model
> while our CLI is at the machine level, at least we can expose the
> information to users.
> 
> If you agree to expose the default topology/cache info in
> query-cpu-model-expansion, can I work on this in a separate series? :)

Yeah, lets worry about that another day.

It it sufficient to just encourage users to always specify
the full set of caches.

> > Can we explicitly disable a l2/l3 cache, or must it always exists ?
> 
> Now we can't disable it through -machine smp-cache (while x86 CPU support
> l3-cache=off), but as you mentioned, I can try using "invalid" to support
> this scenario, which would be more general. Similarly, if you agree, I
> can also add this support in a separate series.

If we decide to offer a way to disable caches, probably better to have
a name like 'disabled' for such a setting, and yes, we don't need todo
that now.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


