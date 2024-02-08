Return-Path: <kvm+bounces-8354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC50584E57D
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 17:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0C2D1C23F74
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 16:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF227F7CF;
	Thu,  8 Feb 2024 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bGormSP6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06347F470
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707411164; cv=none; b=Q7B02bNm0jpqs7OVHZzh/K7ktEcBxBO20eialbMe5eUmyAbMmW1uWe8U7iA3eXwZtjFCogX7djaqCeb9ywEiIalOKFjVxFQnR8jlISUfmTOMg5XntHH0htj/xqjLfxq5fwXyhiRoDqnbMo65qEDTL/Uz78DC/fPwvzieFNq39C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707411164; c=relaxed/simple;
	bh=4GRScazr9z6cqgfVD6Rsf15gpA4ix02MJ80O8DrS20E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNL0fo8uvEpW/BJUMWndKuCQKudhGlN/Gp+ka5cCRY9JUI6uqFFhYhf1WbUhuj3b6+P+jIIl/rLXT3JCIqf3XYkxyJS7Qa8SFllc78gzJy6uWpODDdX82dEPJwJRmMx1+Pnxraml/kakdOF9JzGnEnr5hCp3gFX91W0E6seQGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bGormSP6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707411161;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HnFPdWA5EVpY9l0ZaXfI71Ps/9IZ7jMzjXiDCC35kwI=;
	b=bGormSP6g0vw9yN35gHSpFTlCwK/VSTtZZBVM7gBiellOCa2vXx/qJk080p6zkIyF3RX+J
	2gtE2sxNnpMLtfJulMwPpiCHBtHNoH1r4ahsecGbCsPmb5lNBVJLlyChqXS3krN+4wY56F
	KEjKMomOFngM2rWdXm4YtY8Pp9pLtxo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-noKUIWZTNZCHdQvA0-KxkA-1; Thu,
 08 Feb 2024 11:52:39 -0500
X-MC-Unique: noKUIWZTNZCHdQvA0-KxkA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61249282D3D7;
	Thu,  8 Feb 2024 16:52:38 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.60])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72C30492BF0;
	Thu,  8 Feb 2024 16:52:35 +0000 (UTC)
Date: Thu, 8 Feb 2024 16:52:33 +0000
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
Message-ID: <ZcUG0Uc8KylEQhUW@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
 <Zbog2vDrrWFbujrs@redhat.com>
 <ZbsInI6Z66edm3eH@intel.com>
 <ZbtirK-orqCb5sba@redhat.com>
 <ZbvCktGZFj4v3I/P@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbvCktGZFj4v3I/P@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Fri, Feb 02, 2024 at 12:10:58AM +0800, Zhao Liu wrote:
> Hi Daniel,
> 
> On Thu, Feb 01, 2024 at 09:21:48AM +0000, Daniel P. Berrangé wrote:
> > Date: Thu, 1 Feb 2024 09:21:48 +0000
> > From: "Daniel P. Berrangé" <berrange@redhat.com>
> > Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> > 
> > On Thu, Feb 01, 2024 at 10:57:32AM +0800, Zhao Liu wrote:
> > > Hi Daniel,
> > > 
> > > On Wed, Jan 31, 2024 at 10:28:42AM +0000, Daniel P. Berrangé wrote:
> > > > Date: Wed, 31 Jan 2024 10:28:42 +0000
> > > > From: "Daniel P. Berrangé" <berrange@redhat.com>
> > > > Subject: Re: [PATCH v8 00/21] Introduce smp.modules for x86 in QEMU
> > > > 
> > > > On Wed, Jan 31, 2024 at 06:13:29PM +0800, Zhao Liu wrote:
> > > > > From: Zhao Liu <zhao1.liu@intel.com>
> > > 
> > > [snip]
> > > 
> > > > > However, after digging deeper into the description and use cases of
> > > > > cluster in the device tree [3], I realized that the essential
> > > > > difference between clusters and modules is that cluster is an extremely
> > > > > abstract concept:
> > > > >   * Cluster supports nesting though currently QEMU doesn't support
> > > > >     nested cluster topology. However, modules will not support nesting.
> > > > >   * Also due to nesting, there is great flexibility in sharing resources
> > > > >     on clusters, rather than narrowing cluster down to sharing L2 (and
> > > > >     L3 tags) as the lowest topology level that contains cores.
> > > > >   * Flexible nesting of cluster allows it to correspond to any level
> > > > >     between the x86 package and core.
> > > > > 
> > > > > Based on the above considerations, and in order to eliminate the naming
> > > > > confusion caused by the mapping between general cluster and x86 module
> > > > > in v7, we now formally introduce smp.modules as the new topology level.
> > > > 
> > > > What is the Linux kernel calling this topology level on x86 ?
> > > > It will be pretty unfortunate if Linux and QEMU end up with
> > > > different names for the same topology level.
> > > > 
> > > 
> > > Now Intel's engineers in the Linux kernel are starting to use "module"
> > > to refer to this layer of topology [4] to avoid confusion, where
> > > previously the scheduler developers referred to the share L2 hierarchy
> > > collectively as "cluster".
> > > 
> > > Looking at it this way, it makes more sense for QEMU to use the
> > > "module" for x86.
> > 
> > I was thinking specificially about what Linux calls this topology when
> > exposing it in sysfs and /proc/cpuinfo. AFAICT, it looks like it is
> > called 'clusters' in this context, and so this is the terminology that
> > applications and users are going to expect.
> 
> The cluster related topology information under "/sys/devices/system/cpu/
> cpu*/topology" indicates the L2 cache topology (CPUID[0x4]), not module
> level CPU topology (CPUID[0x1f]).
> 
> So far, kernel hasn't exposed module topology related sysfs. But we will
> add new "module" related information in sysfs. The relevant patches are
> ready internally, but not posted yet.
> 
> In the future, we will use "module" in sysfs to indicate module level CPU
> topology, and "cluster" will be only used to refer to the l2 cache domain
> as it is now.

So, if they're distinct concepts both relevant to x86 CPUs, then from
the QEMU POV, should this patch series be changing the -smp arg to
allowing configuration of both 'clusters' and 'modules' for x86 ?

An earlier version of this series just supported 'clusters', and this
changed to 'modules', but your description of Linux reporting both
suggests QEMU would need both.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


