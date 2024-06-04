Return-Path: <kvm+bounces-18747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A40268FAEDD
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 11:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57AD328759B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 09:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA141411EB;
	Tue,  4 Jun 2024 09:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PzMuIKd0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C523776
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 09:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717493548; cv=none; b=gcMKzqLyHCkBUkZyw+E+edMyDyWU88HRiH9sLxxEYzJBLvUrAN7tF04vqjBv0Ol97h/B7aG9AERpIVSeZQtGzND1RDFVDP9EZ4DvQwpuJD6f6BsMRNMUHxtHnhAkWV9s0heAtVQPpIW1xCxKzc98sUuH+fYVfngN1EftWZhs408=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717493548; c=relaxed/simple;
	bh=+MptDze2sdII+rzcEf6HqH6gEdlc0T7Cv6mVQuZeruk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjUFEZf4Xi1pGcimDwPv2WP/dDiyRGly+OQfYXiNxfo80P3PxZqJmzREJ5ewOSQaUHyEeCjWL6J0gPhDH5cw9Jo/4vD1ykIseYKn3kHgjoMqXjSLA+FqHyV3BAOhpiZVWXa0i4eXIA5SnIFrRnxxFyywb7EB2hSAkGo/BVyfXco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PzMuIKd0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717493545;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=Kj3Af50YVLKSXNM5eVa3oxycaL5wmFR39UMS4qGQoVk=;
	b=PzMuIKd0zkF95JqUpyK36Q42TuAV/lFjOltyYBKQAKV1rhkrxkWiW8O4IlcNkZX4Wpjwh3
	adaJeTCVBG2lshBPHMC1J2Sm6FQ1aODJo+jCVaguoCss44RaZaMSuhX6A+pIDO2wGf+6By
	KK7pmBfb1cm1vKT166HlsrJkPPl+Ylg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-CB9fc94iPDG0jTlRbq3LXQ-1; Tue,
 04 Jun 2024 05:32:20 -0400
X-MC-Unique: CB9fc94iPDG0jTlRbq3LXQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9057B29AB3E0;
	Tue,  4 Jun 2024 09:32:19 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C559320230B7;
	Tue,  4 Jun 2024 09:32:16 +0000 (UTC)
Date: Tue, 4 Jun 2024 10:32:14 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 3/7] hw/core: Add cache topology options in -smp
Message-ID: <Zl7fHop_GaiJt6AE@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
 <20240530101539.768484-4-zhao1.liu@intel.com>
 <87sext9jfo.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87sext9jfo.fsf@pond.sub.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, Jun 04, 2024 at 10:54:51AM +0200, Markus Armbruster wrote:
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
> > -smp to define the cache topology for SMP system.
> >
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> [...]
> 
> > diff --git a/qapi/machine.json b/qapi/machine.json
> > index 7ac5a05bb9c9..8fa5af69b1bf 100644
> > --- a/qapi/machine.json
> > +++ b/qapi/machine.json
> > @@ -1746,6 +1746,23 @@
> >  #
> >  # @threads: number of threads per core
> >  #
> > +# @l1d-cache: topology hierarchy of L1 data cache. It accepts the CPU
> > +#     topology enumeration as the parameter, i.e., CPUs in the same
> > +#     topology container share the same L1 data cache. (since 9.1)
> > +#
> > +# @l1i-cache: topology hierarchy of L1 instruction cache. It accepts
> > +#     the CPU topology enumeration as the parameter, i.e., CPUs in the
> > +#     same topology container share the same L1 instruction cache.
> > +#     (since 9.1)
> > +#
> > +# @l2-cache: topology hierarchy of L2 unified cache. It accepts the CPU
> > +#     topology enumeration as the parameter, i.e., CPUs in the same
> > +#     topology container share the same L2 unified cache. (since 9.1)
> > +#
> > +# @l3-cache: topology hierarchy of L3 unified cache. It accepts the CPU
> > +#     topology enumeration as the parameter, i.e., CPUs in the same
> > +#     topology container share the same L3 unified cache. (since 9.1)
> > +#
> >  # Since: 6.1
> >  ##
> 
> The new members are all optional.  What does "absent" mean?  No such
> cache?  Some default topology?
> 
> Is this sufficiently general?  Do all machines of interest have a split
> level 1 cache, a level 2 cache, and a level 3 cache?

Level 4 cache is apparently a thing

https://www.guru3d.com/story/intel-confirms-l4-cache-in-upcoming-meteor-lake-cpus/

but given that any new cache levels will require new code in QEMU to
wire up, its not a big deal to add new properties at the same time.

That said see my reply just now to the cover letter, where I suggest
we should have a "caches" property that takes an array of cache
info objects.

> 
> Is the CPU topology level the only cache property we'll want to
> configure here?  If the answer isn't "yes", then we should perhaps wrap
> it in an object, so we can easily add more members later.

Cache size is a piece of info I could see us wanting to express

> Two spaces between sentences for consistency, please.
> 
> >  { 'struct': 'SMPConfiguration', 'data': {
> > @@ -1758,7 +1775,11 @@
> >       '*modules': 'int',
> >       '*cores': 'int',
> >       '*threads': 'int',
> > -     '*maxcpus': 'int' } }
> > +     '*maxcpus': 'int',
> > +     '*l1d-cache': 'CPUTopoLevel',
> > +     '*l1i-cache': 'CPUTopoLevel',
> > +     '*l2-cache': 'CPUTopoLevel',
> > +     '*l3-cache': 'CPUTopoLevel' } }
> >  
> >  ##
> >  # @x-query-irq:
> > diff --git a/system/vl.c b/system/vl.c
> 
> [...]
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


