Return-Path: <kvm+bounces-29087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6620D9A268C
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E406B1F2362C
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B161DED4B;
	Thu, 17 Oct 2024 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4uE3zfD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDCC1386B4
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729178870; cv=none; b=NRrh43CnjTcPWluDCsL9cZgVbeM6F5we9j8naz8fdUHFbKkjPaGzyn2x5/HM9ibEZC12WtjMTmmcn5YwmdvSSd5b2wqBXSUx2TCrPl1sfgKhD+KSQ6shpjRbqsVJHanYV5BM9f5IARZpBILEcE8H6Bx60scEPizrTjtfQvbCaac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729178870; c=relaxed/simple;
	bh=49LoP8uPMY9YCFslj9uMWi2K1sxJ01hRml+o9gtG0fU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyQQ5PY6Pavw6DRplw4E2l1Rok4M0VHOV4tI9MB5+J5OGBFDLmubj9Xn0pH0Cyb+Kwj2YT5JnvGlWtDGM1h+5yFColo9Z3LVN1D2lH4SsX3zSAi5xFq2MK2TeoFIofrASyGSvQL+FexJQvr/M1A5BywBbobkeKFvknz6eGGsOO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4uE3zfD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729178864;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=2hqjuI+0DE4xj9nC242F59bUCqjvPn6E1OOsFI7D9lQ=;
	b=X4uE3zfDEpB1gCjM2QifjmSVUWXNtneUrlCrUWbi6gUcBFi8KO0kQNoR6N9wMOFB2dOayE
	6KbsmgPQgbiBLLHHOA8Mo5ne7er7+tBQ0jthO+BYHe6Q81+EfdFF5G2g/NQbsDQqLS9/pf
	V+2H2LdaTSiJnp+VOoB1Bq5LAPWaDOU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-28IWBqzCPGeLoyD-s9Kbew-1; Thu,
 17 Oct 2024 11:27:39 -0400
X-MC-Unique: 28IWBqzCPGeLoyD-s9Kbew-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 515DB1955F41;
	Thu, 17 Oct 2024 15:27:36 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.94])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DB31300018D;
	Thu, 17 Oct 2024 15:27:27 +0000 (UTC)
Date: Thu, 17 Oct 2024 16:27:24 +0100
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
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v3 6/7] i386/pc: Support cache topology in -machine for
 PC machine
Message-ID: <ZxEs3DGGgCqGT5yK@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-7-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241012104429.1048908-7-zhao1.liu@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Sat, Oct 12, 2024 at 06:44:28PM +0800, Zhao Liu wrote:
> Allow user to configure l1d, l1i, l2 and l3 cache topologies for PC
> machine.
> 
> Additionally, add the document of "-machine smp-cache" in
> qemu-options.hx.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
> Changes since Patch v2:
>  * Polished the document. (Jonathan)
> 
> Changes since Patch v1:
>  * Merged document into this patch. (Markus)
> 
> Changes since RFC v2:
>  * Used cache_supported array.
> ---
>  hw/i386/pc.c    |  4 ++++
>  qemu-options.hx | 26 +++++++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
>              -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
> +
> +    ``smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel``
> +        Define cache properties for SMP system.
> +
> +        ``cache=cachename`` specifies the cache that the properties will be
> +        applied on. This field is the combination of cache level and cache
> +        type. It supports ``l1d`` (L1 data cache), ``l1i`` (L1 instruction
> +        cache), ``l2`` (L2 unified cache) and ``l3`` (L3 unified cache).
> +
> +        ``topology=topologylevel`` sets the cache topology level. It accepts
> +        CPU topology levels including ``thread``, ``core``, ``module``,
> +        ``cluster``, ``die``, ``socket``, ``book``, ``drawer`` and a special
> +        value ``default``. If ``default`` is set, then the cache topology will
> +        follow the architecture's default cache topology model. If another
> +        topology level is set, the cache will be shared at corresponding CPU
> +        topology level. For example, ``topology=core`` makes the cache shared
> +        by all threads within a core.
> +
> +        Example:
> +
> +        ::
> +
> +            -machine smp-cache.0.cache=l1d,smp-cache.0.topology=core,smp-cache.1.cache=l1i,smp-cache.1.topology=core

There are 4 cache types, l1d, l1i, l2, l3.

In this example you've only set properties for l1d, l1i caches.

What does this mean for l2 / l3 caches ?

Are they reported as not existing, or are they to be reported at
some built-in default topology level. If the latter, how does the
user know what that built-in default is, and avoid nonsense like
l1d being at socket level, and l3 being at the core level ? Can
we explicitly disable a l2/l3 cache, or must it always exists ?

The QAPI has an "invalid" topology level. You've not documented
that as permitted here, but the qapi parser will happily allow
it. What semantics will that have ? 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


