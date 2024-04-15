Return-Path: <kvm+bounces-14680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8DB78A5921
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8352D282CE2
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 17:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604E883A1D;
	Mon, 15 Apr 2024 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O9+/NAit"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128061E87C
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713202312; cv=none; b=KyuOZZJMAUELS5L+5yOlPXXPCgoAhRh2IHXdw1qYCr1xisidw++FRzG+eZERwfDZrbDhfs6b1NIbymmEFKjZL5G2VlvFL7Xwdd6CL61Vqs8631QGIYxzyiMQSgx+9VJXCyHZPuol0ryGOCTDrKeCTDhoLWvJ8fEgLAO/5NfCSFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713202312; c=relaxed/simple;
	bh=o/i3rNPQfxzHkk9xiPN/DP28k7FlEdJHfAyQQfZ4Htk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edcmSZJVjpiuE/hUqmmq37J2ayqY05eL3aW5OnZwG9U4xoeJ3XfQJqcpjUbwQpJOfX457jtBJjySUtEfyp9yaZDstOQq999lVPsn4l1BI1RuPsye+OqBq0GEfB+LYAA8NBEgmJ93rVUN7ZuqAzgZJLsqIbiPj8A3PBUay0biVfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O9+/NAit; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713202310;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AydjyBs6LzOYz3Jy9BRREvazpy+lYPG1Un3sEr91ddI=;
	b=O9+/NAit8h8hajjkUrQZDpW89iXG1LWWLfDZIzWlASsXM7sl/gk1a2MiwsWnaXPm5uxmck
	/giKIY0e1dDRImlfiti2e4iAG2IOpcK+5Vj0cTSaqCIO+avu4MtyZr9M/YyqKog65aCGxY
	dcMtdi5SAw1ODrY5wpTki6np4eOgdKk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-52EMPevqN2m2nyBg4_8NjQ-1; Mon, 15 Apr 2024 13:31:46 -0400
X-MC-Unique: 52EMPevqN2m2nyBg4_8NjQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19D401887314;
	Mon, 15 Apr 2024 17:31:46 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B455CC13FA2;
	Mon, 15 Apr 2024 17:31:44 +0000 (UTC)
Date: Mon, 15 Apr 2024 18:31:38 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Kevin Wolf <kwolf@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, armbru@redhat.com
Subject: Re: [PATCH v8] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Message-ID: <Zh1ketp8cvLoYjok@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240312074849.71475-1-shahuang@redhat.com>
 <Zf2bbcpWYMWKZpNy@redhat.com>
 <1881554f-9183-4e01-8cda-0934f7829abf@redhat.com>
 <ZgE71v8uGDNihQ5H@redhat.com>
 <46f0c5ab-dee7-4cd4-844d-c418818e187c@redhat.com>
 <ZgwBvuCrTwKmA0IK@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZgwBvuCrTwKmA0IK@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Tue, Apr 02, 2024 at 03:01:50PM +0200, Kevin Wolf wrote:
> Am 29.03.2024 um 04:45 hat Shaoqin Huang geschrieben:
> > Hi Daniel,
> > 
> > On 3/25/24 16:55, Daniel P. Berrangé wrote:
> > > On Mon, Mar 25, 2024 at 01:35:58PM +0800, Shaoqin Huang wrote:
> > > > Hi Daniel,
> > > > 
> > > > Thanks for your reviewing. I see your comments in the v7.
> > > > 
> > > > I have some doubts about what you said about the QAPI. Do you want me to
> > > > convert the current design into the QAPI parsing like the
> > > > IOThreadVirtQueueMapping? And we need to add new json definition in the
> > > > qapi/ directory?
> > 
> > I have defined the QAPI for kvm-pmu-filter like below:

> > @@ -2439,6 +2441,7 @@ static Property arm_cpu_properties[] = {
> >                          mp_affinity, ARM64_AFFINITY_INVALID),
> >      DEFINE_PROP_INT32("node-id", ARMCPU, node_id, CPU_UNSET_NUMA_NODE_ID),
> >      DEFINE_PROP_INT32("core-count", ARMCPU, core_count, -1),
> > +    DEFINE_PROP_KVM_PMU_FILTER("kvm-pmu-filter", ARMCPU, kvm_pmu_filter),
> >      DEFINE_PROP_END_OF_LIST()
> >  };
> > 
> > And I guess I can use the new json format input like below:
> > 
> > qemu-system-aarch64 \
> > 	-cpu host, '{"filter": [{"action": "a", "start": 0x10, "end": "0x11"}]}'
> > 
> > But it doesn't work. It seems like because the -cpu option doesn't
> > support json format parameter.
> > 
> > Maybe I'm wrong. So I want to double check with if the -cpu option
> > support json format nowadays?
> 
> As far as I can see, -cpu doesn't support JSON yet. But even if it did,
> your command line would be invalid because the 'host,' part isn't JSON.
> 
> > If the -cpu option doesn't support json format, how I can use the QAPI
> > for kvm-pmu-filter property?
> 
> This would probably mean QAPIfying all CPUs first, which sounds like a
> major effort.

I wonder if we can do a half-way house where we parse the JSON and
turn it into regular QemuOpts internally, and then just use QAPI
parsing for the filter property. IOW, publically give the illusion
that -cpu has been QAPI-ified, but without actually doing the hard
part yet. The idea being to avoid inventing a new cli syntax that
has no analogue to QAPI.
With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


