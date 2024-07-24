Return-Path: <kvm+bounces-22158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A2A93B0FA
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 14:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C822A1F213C5
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 12:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE750156F2C;
	Wed, 24 Jul 2024 12:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LudzYaNx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5ED148FFA
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 12:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721824787; cv=none; b=X6NV/+l7Zb/Vlu7EXv1B9/V3AzgEk/opOiTt4+Dv4pCXSfFyu2VRbEf98I+Y2ZmZLYGvEVzaNzcjmLK2MKwX79ZPKfeyXRzmj1/PK11/jaS0Okubaz9j3cRhwInDaeVC5ghK4DnK/tIsxztto/xnpGCJs0/HsGhqWVIufbDasA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721824787; c=relaxed/simple;
	bh=rCkMD4bfWfuYv1sctW1jP2d0Z7i7RV94jGudmM0LnyU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fqbWBLCGSFTK5mxEy3aPonNBT3qqk4V3WuqdQ2riLNyUacENiOD0M9tOxjHSGtuol+TpzWyQBuOIxsUU3KHHjkPtgqlwAbbUDPwol/AD+VK3XT8NCMjV+m9MNsCOXGFwj/uA+zGlDukWM8nS3u42kYau5a5UoZp3wEUoxwe125I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LudzYaNx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721824783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4doG7FgGWPcNGWJJHJPJk0rNm/M14H0MAca/J2UMVFc=;
	b=LudzYaNxZ82Q+u+9xGM8ReG0O0PjeMgv2xsj7dzaLfDzlVdYcOcO4Ug1DmmUz2r9IMw18l
	lcPvFyfmgsVwq0xhlS/kqRXpMyjGGw+slf4pvWZRWdFj9EnSzwsn6fMUokmi9Xiuw3dBGN
	yq347BnEvxJMMs7gQMmO6urQ2bGSH9c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-TcfKgXheMR-ID3bfodM32w-1; Wed,
 24 Jul 2024 08:39:39 -0400
X-MC-Unique: TcfKgXheMR-ID3bfodM32w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3672E1955D4A;
	Wed, 24 Jul 2024 12:39:35 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F367C1955E80;
	Wed, 24 Jul 2024 12:39:31 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id B0E0421E668A; Wed, 24 Jul 2024 14:39:29 +0200 (CEST)
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
Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache object
In-Reply-To: <Zp5vxtXWDeHAdPok@intel.com> (Zhao Liu's message of "Mon, 22 Jul
	2024 22:42:14 +0800")
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
	<20240704031603.1744546-9-zhao1.liu@intel.com>
	<87r0bl35ug.fsf@pond.sub.org> <Zp5vxtXWDeHAdPok@intel.com>
Date: Wed, 24 Jul 2024 14:39:29 +0200
Message-ID: <87bk2nnev2.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Zhao Liu <zhao1.liu@intel.com> writes:

> Hi Markus,
>
> On Mon, Jul 22, 2024 at 03:37:43PM +0200, Markus Armbruster wrote:
>> Date: Mon, 22 Jul 2024 15:37:43 +0200
>> From: Markus Armbruster <armbru@redhat.com>
>> Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache
>>  object
>> 
>> Zhao Liu <zhao1.liu@intel.com> writes:
>> 
>> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
>> 
>> This patch is just documentation.  The code got added in some previous
>> patch.  Would it make sense to squash this patch into that previous
>> patch?
>
> OK, I'll merge them.
>
>> > ---
>> > Changes since RFC v2:
>> >  * Rewrote the document of smp-cache object.
>> >
>> > Changes since RFC v1:
>> >  * Use "*_cache=topo_level" as -smp example as the original "level"
>> >    term for a cache has a totally different meaning. (Jonathan)
>> > ---
>> >  qemu-options.hx | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 58 insertions(+)
>> >
>> > diff --git a/qemu-options.hx b/qemu-options.hx
>> > index 8ca7f34ef0c8..4b84f4508a6e 100644
>> > --- a/qemu-options.hx
>> > +++ b/qemu-options.hx
>> > @@ -159,6 +159,15 @@ SRST
>> >          ::
>> >  
>> >              -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
>> > +
>> > +    ``smp-cache='id'``
>> > +        Allows to configure cache property (now only the cache topology level).
>> > +
>> > +        For example:
>> > +        ::
>> > +
>> > +            -object '{"qom-type":"smp-cache","id":"cache","caches":[{"name":"l1d","topo":"core"},{"name":"l1i","topo":"core"},{"name":"l2","topo":"module"},{"name":"l3","topo":"die"}]}'
>> > +            -machine smp-cache=cache
>> >  ERST
>> >  
>> >  DEF("M", HAS_ARG, QEMU_OPTION_M,
>> > @@ -5871,6 +5880,55 @@ SRST
>> >          ::
>> >  
>> >              (qemu) qom-set /objects/iothread1 poll-max-ns 100000
>> > +
>> > +    ``-object '{"qom-type":"smp-cache","id":id,"caches":[{"name":cache_name,"topo":cache_topo}]}'``
>> > +        Create an smp-cache object that configures machine's cache
>> > +        property. Currently, cache property only include cache topology
>> > +        level.
>> > +
>> > +        This option must be written in JSON format to support JSON list.
>> 
>> Why?
>
> I'm not familiar with this, so I hope you could educate me if I'm wrong.
>
> All I know so far is for -object that defining a list can only be done in
> JSON format and not with a numeric index like a keyval based option, like:
>
> -object smp-cache,id=cache0,caches.0.name=l1i,caches.0.topo=core: Parameter 'caches' is missing
>
> the above doesn't work.
>
> Is there any other way to specify a list in command line?

The command line is a big, sprawling mess :)

-object supports either a JSON or a QemuOpts argument.  *Not* keyval!

Both QemuOpts and keyval parse something like KEY=VALUE,...  Keyval
supports arrays and objects via dotted keys.  QemuOpts doesn't natively
support arrays and objects, but its users can hack around that
limitation in various ways.  -object doesn't.  So you're right, it's
JSON or bust here.

However, if we used one object per cache instead, we could get something
like

    -object smp-cache,name=l1d,...
    -object smp-cache,name=l1u,...
    -object smp-cache,name=l2,...
    ...

>> > +
>> > +        The ``caches`` parameter accepts a list of cache property in JSON
>> > +        format.
>> > +
>> > +        A list element requires the cache name to be specified in the
>> > +        ``name`` parameter (currently ``l1d``, ``l1i``, ``l2`` and ``l3``
>> > +        are supported). ``topo`` parameter accepts CPU topology levels
>> > +        including ``thread``, ``core``, ``module``, ``cluster``, ``die``,
>> > +        ``socket``, ``book``, ``drawer`` and ``default``. The ``topo``
>> > +        parameter indicates CPUs winthin the same CPU topology container
>> > +        are sharing the same cache.
>> > +
>> > +        Some machines may have their own cache topology model, and this
>> > +        object may override the machine-specific cache topology setting
>> > +        by specifying smp-cache object in the -machine. When specifying
>> > +        the cache topology level of ``default``, it will honor the default
>> > +        machine-specific cache topology setting. For other topology levels,
>> > +        they will override the default setting.
>> > +
>> > +        An example list of caches to configure the cache model (l1d cache
>> > +        per core, l1i cache per core, l2 cache per module and l3 cache per
>> > +        socket) supported by PC machine might look like:
>> > +
>> > +        ::
>> > +
>> > +              {
>> > +                "caches": [
>> > +                   { "name": "l1d", "topo": "core" },
>> > +                   { "name": "l1i", "topo": "core" },
>> > +                   { "name": "l2", "topo": "module" },
>> > +                   { "name": "l3", "topo": "socket" },
>> > +                ]
>> > +              }
>> > +
>> > +        An example smp-cache object would look like:()
>> > +
>> > +        .. parsed-literal::
>> > +
>> > +             # |qemu_system| \\
>> > +                 ... \\
>> > +                 -object '{"qom-type":"smp-cache","id":id,"caches":[{"name":cache_name,"topo":cache_topo}]}' \\
>> > +                 ...
>> >  ERST
>> 


