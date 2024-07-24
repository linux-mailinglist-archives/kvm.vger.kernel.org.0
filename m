Return-Path: <kvm+bounces-22159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F262093B108
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 14:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A966F1F22F83
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 12:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB4E15884B;
	Wed, 24 Jul 2024 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b+HzGWOO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8D013BC26
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721825258; cv=none; b=o5nVwVGa7GFZa0svzUAQ0bL2i5xZploHDnENpYDQHA4ECdag/+aswRtS13XHSPX+h3BKRfmHTUlWWoMdQuoHAG4mVX/yglmIp2YA/aVmwzqWVVOpPaMyCVUEFBAQuhfbd9Y0AbjtarOYkyatsOhYOKFBUfncAku2Um9hQezXXwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721825258; c=relaxed/simple;
	bh=NqmeJAdnT0FmgL5OsGO2hwsCqBClei7F42duCOhmnCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHjV+sxLJhzFgawMkXmRgRGfcPtY0gwr5I1jF6xa/PLYkMLjP3NsGCPHGLqtYXOjhBC2A3bIHYwR5Pc1PqEAXFvA0stcmlcPHPTLHyeMwVILzu4izY7UmqjTiBiyUsP4Pl7v8gSScWRqTkbes/HFIONzq+BqGmmAvOk6XydDO3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b+HzGWOO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721825255;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=mK4f87H4NY9/71BRSRerJJDAo9/63WdDPrXjfZ2Qy1M=;
	b=b+HzGWOO0hyypM4RiwFWrPXfkDtcySkaW2erJhqmGKfpIfyox4Ahh+xUkhEmYNn0lcm1FN
	Wqua5KdlRd9ixSrbtsGrIovKFdxdfmv85bKfLzPnKhadjhykTWUbE3YckLVpzC1p9VlHcn
	mRz+Dy6dAMXNGRUVQZqoE/zGrft1Sso=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-tIJwzxVHPJu-ibIE437_Ow-1; Wed,
 24 Jul 2024 08:47:32 -0400
X-MC-Unique: tIJwzxVHPJu-ibIE437_Ow-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A70071955F06;
	Wed, 24 Jul 2024 12:47:29 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.141])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1737019560AE;
	Wed, 24 Jul 2024 12:47:19 +0000 (UTC)
Date: Wed, 24 Jul 2024 13:47:16 +0100
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
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Message-ID: <ZqD31Oj5P0uDMs-I@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87h6cfowei.fsf@pond.sub.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jul 24, 2024 at 01:35:17PM +0200, Markus Armbruster wrote:
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi Markus,
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

Previous versions of this series were augmenting the existing
-smp command line. Now the design has switched to use -object,
I agree that it'd be simplest to just have one -object flag
added per cache level we want to defnie.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


