Return-Path: <kvm+bounces-18743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E17F8FAEC2
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 11:29:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81F061C210A8
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 09:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1CF143C47;
	Tue,  4 Jun 2024 09:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePiq7Jhq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E685143724
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717493368; cv=none; b=owzJm34qnVy6Om4k56WshfSkwp1InjtsrhuVKnVB0yxOD0vdvAjef/dt340OYv2Klkz5VWauhpnI+XWLStlayTpR7NeVvD+v9bMJ1qawEtted0yF9QA7Ihm3dNIp+7Sx1DjYOl6uSrHrH9dChvsLritX/nvOjThz7qcUyCdaXOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717493368; c=relaxed/simple;
	bh=du9JYxStMhvPl6Mg+TBJMIxibcHL8lHfhi/EYHgT9Rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/MrjaAi6ptOryiZmlYqkoimSzfI4E4CzMc5xZaxE1/g8dC2mdMiZNjGnkiZPU/AFKxGRmRPpeXHGkLrEId0anNAPXp2SHLzch6gaIHujo6/UctZe/d/Xco71OfW000I/b+ekofptlHdN5+94solV3rhyVz5dFPx0RBFKdlFD7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ePiq7Jhq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717493365;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hZ6BR7ZP0R1ebLkNmGoehN6rlFVKuR/AxIITl0TNwfA=;
	b=ePiq7JhqqDPYLr5bq7LnDQPjMgtd7Gph1+gbhFjDZuxE6JdYBS0AwGONUITuAhSkByFl/p
	hZBrA4p7UfcvvGON/KrAHb76S5tU1ZVUlN+6WPRE5L8RcjxhDq1f1bS+5xatWPv/r2nI8Q
	aw7ZKVzwfw/jItKEUSPQVwEVnyRM9o8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-ryezyYoeOaegVds3xkxEaw-1; Tue, 04 Jun 2024 05:29:21 -0400
X-MC-Unique: ryezyYoeOaegVds3xkxEaw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCF16803C81;
	Tue,  4 Jun 2024 09:29:20 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25571492BCD;
	Tue,  4 Jun 2024 09:29:17 +0000 (UTC)
Date: Tue, 4 Jun 2024 10:29:15 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 0/7] Introduce SMP Cache Topology
Message-ID: <Zl7ea2o2aaxXMj9X@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240530101539.768484-1-zhao1.liu@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Thu, May 30, 2024 at 06:15:32PM +0800, Zhao Liu wrote:
> Hi,
> 
> Now that the i386 cache model has been able to define the topology
> clearly, it's time to move on to discussing/advancing this feature about
> configuring the cache topology with -smp as the following example:
> 
> -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32,\
>      l1d-cache=core,l1i-cache=core,l2-cache=core,l3-cache=die
> 
> With the new cache topology options ("l1d-cache", "l1i-cache",
> "l2-cache" and "l3-cache"), we could adjust the cache topology via -smp.

Switching to QAPI for a second, your proposal is effectively

    { 'enum': 'SMPCacheTopo',
      'data': [ 'default','socket','die','cluster','module','core','thread'] }

   { 'struct': 'SMPConfiguration',
     'data': {
       '*cpus': 'int',
       '*drawers': 'int',
       '*books': 'int',
       '*sockets': 'int',
       '*dies': 'int',
       '*clusters': 'int',
       '*modules': 'int',
       '*cores': 'int',
       '*threads': 'int',
       '*maxcpus': 'int',
       '*l1d-cache': 'SMPCacheTopo',
       '*l1i-cache': 'SMPCacheTopo',
       '*l2-cache': 'SMPCacheTopo',
       '*l3-cache': 'SMPCacheTopo',
     } }

I think that would be more natural to express as an array of structs
thus:

    { 'enum': 'SMPCacheTopo',
      'data': [ 'default','socket','die','cluster','module','core','thread'] }

    { 'enum': 'SMPCacheType',
      'data': [ 'l1d', 'l1i', 'l2', 'l3' ] }
     
    { 'struct': 'SMPCache',
      'data': {
        'type': 'SMPCacheType',
        'topo': 'SMPCacheTopo',
      } }

   { 'struct': 'SMPConfiguration',
     'data': {
       '*cpus': 'int',
       '*drawers': 'int',
       '*books': 'int',
       '*sockets': 'int',
       '*dies': 'int',
       '*clusters': 'int',
       '*modules': 'int',
       '*cores': 'int',
       '*threads': 'int',
       '*maxcpus': 'int',
       'caches': [ 'SMPCache' ]
     } }

Giving an example in (hypothetical) JSON cli syntax of:

  -smp  "{'cpus':32,'sockets':2,'dies':2,'modules':2,
          'cores':2,'threads':2,'maxcpus':32,'caches': [
	    {'type':'l1d','topo':'core' },
	    {'type':'l1i','topo':'core' },
	    {'type':'l2','topo':'core' },
	    {'type':'l3','topo':'die' },
	  ]}"


> Open about How to Handle the Default Options
> ============================================
> 
> (For the detailed description of this series, pls skip this "long"
> section and review the subsequent content.)
> 
> 
> Background of OPEN
> ------------------
> 
> Daniel and I discussed initial thoughts on cache topology, and there was
> an idea that the default *cache_topo is on the CORE level [3]:
> 
> > simply preferring "cores" for everything is a reasonable
> > default long term plan for everything, unless the specific
> > architecture target has no concept of "cores".

FYI, when I wrote that I wasn't specifically thinking about cache
mappings. I just meant that when exposing SMP topology to guests,
'cores' is a good default, compared to 'sockets', or 'threads',etc.

Defaults for cache <-> topology  mappings should be whatever makes
most sense to the architecture target/cpu.

> Problem with this OPEN
> ----------------------
> 
> Some arches have their own arch-specific cache topology, such as l1 per
> core/l2 per core/l3 per die for i386. And as Jeehang proposed for
> RISC-V, the cache topologies are like: l1/l2 per core and l3 per
> cluster. 
> 
> Taking L3 as an example, logically there is a difference between the two
> starting points of user-specified core level and with the default core
> level.
> 
> For example,
> 
> "(user-specified) l3-cache-topo=core" should override i386's default l3
> per core, but i386's default l3 per core should also override
> "(default) l3-cache-topo=core" because this default value is like a
> placeholder that specifies nothing.
> 
> However, from a command line parsing perspective, it's impossible to
> tell what the “l3-cache-topo=core” setting is for...

Yes, we need to explicitly distinguish built-in defaults from
user specified data, otherwise we risk too many mistakes.

> Options to solve OPEN
> ---------------------
> 
> So, I think we have the following options:
> 
> 
> 1. Can we avoid such default parameters?
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This would reduce the pain in QEMU, but I'm not sure if it's possible to
> make libvirt happy?

I think having an explicit "defualt" value is inevitable, not simply
because of libvirt. Long experiance with QEMU shows that we need to
be able to reliably distinguish direct user input from  built-in
defaults in cases like this.

> 
> It is also possible to expose Cache topology information as the CPU
> properties in “query-cpu-model-expansion type=full”, but that adds
> arch-specific work.
> 
> If omitted, I think it's just like omitting “cores”/“sockets”,
> leaving it up to the machine to decide based on the specific CPU model
> (and now the cache topology is indeed determined by the CPU model as
> well).
> 
> 
> 2. If default is required, can we use a specific abstract word?
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> That is, is it possible to use a specific word like “auto”/“invalid”
> /“default” and avoid a specific topology level?

"invalid" feels a bit wierd, but 'auto' or 'default' are fine,
and possibly "unspecified"

> Like setting “l3-cache-topo=invalid” (since I've only added the invalid
> hierarchy so far ;-) ).
> 
> I found the cache topology of arches varies so much that I'm sorry to
> say it's hard to have a uniform default cache topology.
> 
> 
> I apologize for the very lengthy note and appreciate you reviewing it
> here as well as your time!

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


