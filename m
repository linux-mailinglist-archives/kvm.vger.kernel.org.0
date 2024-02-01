Return-Path: <kvm+bounces-7684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 30BDA8453C3
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:23:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8FCDB26F90
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3784A15CD75;
	Thu,  1 Feb 2024 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D9U0vDUD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7C515CD6C
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 09:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706779324; cv=none; b=I+oW5hFZ4Rf414eyreCnvrSsm1FDgz73D8wRTsA6X8MUJWZvpa/O9fYi9uWO6XJgKEmTuBlY/FbEUOeOMoS0cu6+dkHv15bjjgtcpAZ2cX+d+c8Bzd3ypxYfI/X44GKScrKMUw2JE+MN0unKskMWgf15NuC3yAL7r3jpswT7f+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706779324; c=relaxed/simple;
	bh=QaNmKjxd3TydFJ803PRk0lFysKk3kDb8Q8TMo5CsS2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9/06aSTDDHCrvzGCqdszrsqv70OtP9ewrGzwVpW4uwH8oR/ERLzvRD5lKce3/kA/Agg8ixMf4y/n2qHsbCAKGIDZCL9GkxcHNswUvzBbBXQg4O5EPrr8rFZ40pWKswxUS7QsXbGMsZr/ICZN+WyIWm3hC1fpdCgAsmVIrJfwxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D9U0vDUD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706779321;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8+4xV17TlIOvu9XMgJXRGV7rwdSg/nzPC7T6chB0B0=;
	b=D9U0vDUDCrsS0UVdT0q8/QkirgqNrVtzfV2vC2uku83z8uXXvKvc0S9/fAxA/8JBRxq47f
	eRrYBDnSrv9/wr3WjA2nSOPOExvOFF90fGM9Eq2MJRDbW5b31RtmtMW1nODyIDhJP1eYqr
	dlbHtf/MVWygzkFyJ/CrsNTQTRkAqz8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-g12-6NZBMhCIv597y1zt0w-1; Thu, 01 Feb 2024 04:21:58 -0500
X-MC-Unique: g12-6NZBMhCIv597y1zt0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6ABF3868A04;
	Thu,  1 Feb 2024 09:21:57 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.46])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFF791BDB1;
	Thu,  1 Feb 2024 09:21:54 +0000 (UTC)
Date: Thu, 1 Feb 2024 09:21:48 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
Message-ID: <ZbtirK-orqCb5sba@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
 <Zbog2vDrrWFbujrs@redhat.com>
 <ZbsInI6Z66edm3eH@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbsInI6Z66edm3eH@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Thu, Feb 01, 2024 at 10:57:32AM +0800, Zhao Liu wrote:
> Hi Daniel,
> 
> On Wed, Jan 31, 2024 at 10:28:42AM +0000, Daniel P. Berrangé wrote:
> > Date: Wed, 31 Jan 2024 10:28:42 +0000
> > From: "Daniel P. Berrangé" <berrange@redhat.com>
> > Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> > 
> > On Wed, Jan 31, 2024 at 06:13:29PM +0800, Zhao Liu wrote:
> > > From: Zhao Liu <zhao1.liu@intel.com>
> 
> [snip]
> 
> > > However, after digging deeper into the description and use cases of
> > > cluster in the device tree [3], I realized that the essential
> > > difference between clusters and modules is that cluster is an extremely
> > > abstract concept:
> > >   * Cluster supports nesting though currently QEMU doesn't support
> > >     nested cluster topology. However, modules will not support nesting.
> > >   * Also due to nesting, there is great flexibility in sharing resources
> > >     on clusters, rather than narrowing cluster down to sharing L2 (and
> > >     L3 tags) as the lowest topology level that contains cores.
> > >   * Flexible nesting of cluster allows it to correspond to any level
> > >     between the x86 package and core.
> > > 
> > > Based on the above considerations, and in order to eliminate the naming
> > > confusion caused by the mapping between general cluster and x86 module
> > > in v7, we now formally introduce smp.modules as the new topology level.
> > 
> > What is the Linux kernel calling this topology level on x86 ?
> > It will be pretty unfortunate if Linux and QEMU end up with
> > different names for the same topology level.
> > 
> 
> Now Intel's engineers in the Linux kernel are starting to use "module"
> to refer to this layer of topology [4] to avoid confusion, where
> previously the scheduler developers referred to the share L2 hierarchy
> collectively as "cluster".
> 
> Looking at it this way, it makes more sense for QEMU to use the
> "module" for x86.

I was thinking specificially about what Linux calls this topology when
exposing it in sysfs and /proc/cpuinfo. AFAICT, it looks like it is
called 'clusters' in this context, and so this is the terminology that
applications and users are going to expect.

I think it would be a bad idea for QEMU to diverge from this and call
it modules.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


