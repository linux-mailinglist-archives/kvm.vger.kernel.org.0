Return-Path: <kvm+bounces-29150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC7F9A37BF
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 09:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E6741C2597B
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF50D18C34C;
	Fri, 18 Oct 2024 07:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJTommeU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F26B18C031
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 07:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729238154; cv=none; b=QsdZLQITQkIgb5y1wiVWLpvjPCqxM8hxWp+P6SKp68IxbGf6cnKo3ieHGiq22E8yViBUSHkCRaNOOzhq/7GVB066WbI6ZmEOFjI/SPxYvcIWOv7fQM0mz8cjUvqBSyz2w3tAC5F3yYtsgtazndp7pV3/ozFIwaZlhfXEUcOkVQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729238154; c=relaxed/simple;
	bh=8asUYfjnaUsiA5EFMOoRsQABRXkZFCtTM4jh2+oP37Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D8kwyRZvzhm/T6fIIAqniEjDiwDPEBdJagCvmi500NJKnj0Ikb3T9vqu/mEt1wjxeLaBhoqMptGP/YLH/1iVPsAVTEPryNtA1ksjmd+6IyjS4dsaPsw+CDoNpuZOv1lPd+s0DGlPuawoBo+0hcDpq7CwSkxri0YxkJmBoOsLNuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YJTommeU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729238151;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=gNyzRNiHs0oc+XzfsXtXom6AwYaOyQqog0N49F4HPNQ=;
	b=YJTommeUu/j4QcKxnHGi5XI6x0mFGYVvcIyguOvdeFsR+jAIBLNVPAIFSuaCfF38N3ChHV
	XnSd8eEtv6leNFSCuj6UwaD420e/dH9QLVyQ552Gzv7fRqGOn5Kcanu3WOsFGwqfj4/yWk
	VCYhn6l+ahyvGJOwvo2CjK3JaSlEjDU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-316-Sj6d6TAHOwuj_38ez3pBHw-1; Fri,
 18 Oct 2024 03:55:49 -0400
X-MC-Unique: Sj6d6TAHOwuj_38ez3pBHw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC94E19560B8;
	Fri, 18 Oct 2024 07:55:45 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.61])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBA3A19560AD;
	Fri, 18 Oct 2024 07:55:38 +0000 (UTC)
Date: Fri, 18 Oct 2024 08:55:35 +0100
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
Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
 arch-agnostic
Message-ID: <ZxIUd9tMi9o1UVOS@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-2-zhao1.liu@intel.com>
 <ZxEte1KBwWuCdkb1@redhat.com>
 <ZxHJri+rgdGKf/0L@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZxHJri+rgdGKf/0L@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Oct 18, 2024 at 10:36:30AM +0800, Zhao Liu wrote:
> Hi Daniel,
> 
> > > -/*
> > > - * CPUTopoLevel is the general i386 topology hierarchical representation,
> > > - * ordered by increasing hierarchical relationship.
> > > - * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
> > > - * or AMD (CPUID[0x80000026]).
> > > - */
> > > -enum CPUTopoLevel {
> > > -    CPU_TOPO_LEVEL_INVALID,
> > > -    CPU_TOPO_LEVEL_SMT,
> > > -    CPU_TOPO_LEVEL_CORE,
> > > -    CPU_TOPO_LEVEL_MODULE,
> > > -    CPU_TOPO_LEVEL_DIE,
> > > -    CPU_TOPO_LEVEL_PACKAGE,
> > > -    CPU_TOPO_LEVEL_MAX,
> > > -};
> > > -
> > 
> > snip
> > 
> > > @@ -18,3 +18,47 @@
> > >  ##
> > >  { 'enum': 'S390CpuEntitlement',
> > >    'data': [ 'auto', 'low', 'medium', 'high' ] }
> > > +
> > > +##
> > > +# @CpuTopologyLevel:
> > > +#
> > > +# An enumeration of CPU topology levels.
> > > +#
> > > +# @invalid: Invalid topology level.
> > 
> > Previously all topology levels were internal to QEMU, and IIUC
> > this CPU_TOPO_LEVEL_INVALID appears to have been a special
> > value to indicate  the cache was absent ?
> 
> Now I haven't support this logic.
> x86 CPU has a "l3-cache" property, and maybe that property can be
> implemented or replaced by the "invalid" level support you mentioned.
> 
> > Now we're exposing this directly to the user as a settable
> > option. We need to explain what effect setting 'invalid'
> > has on the CPU cache config.
> 
> If user set "invalid", QEMU will report the error message:
> 
> qemu-system-x86_64: Invalid cache topology level: invalid. The topology should match valid CPU topology level
> 
> Do you think this error message is sufficient?

If the user cannot set 'invalid' as an input, and no QEMU interface
will emit, then ideally we would not define 'invalid' in the QAPI
schema at all.

This woudl require us to have some internal only way to record
"invalid", separately from the topology level, or with a magic
internal only constant that doesn't clash with the public enum
constants. I guess the latter would be less work e.g. we could
"abuse" the 'MAX' constant value

   #define CPU_TOPOLOGY_LEVEL_INVALID CPU_TOPOLOGY_LEVEL_MAX

or separate it with a negative value

   #define CPU_TOPOLOGY_LEVEL_INVALID -1


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


