Return-Path: <kvm+bounces-21637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 589EF931138
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 11:30:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C4051C2214C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 09:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE5D186E4E;
	Mon, 15 Jul 2024 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="TVQNoNDM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239E7186E40
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 09:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721035838; cv=none; b=ux0BMHZC3hl+SJedvMg1448WlKT55ioVNfJeT8cd1NccWWoOUdh+6qfm3f3dC1NV5rO2LnUcBbzKNbAF/Qi1U0Bp2kQq8vA3piJSYf3Oe8eBUbFk3xvpTq7mkOJfXai/ByTyxMetRYqnskyH3IORs9c6kcE13LW8xygspSXolIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721035838; c=relaxed/simple;
	bh=KQxB5hLkuLP2Fvf3e1iOvIYUJjQt+XW9irxkcb/1gnU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rKsJi1JrtDoa3UbZIEnd2hY/EpYfmCMGsKMK9a0LEpXXjJvK7xNkVzfthF+73nrP6rxVEBsUNmJXLQM0OCGqeV/lRlCMc65/Kgzh6+hqQsLYd1NK0cFijxD32OHzS0h4sK8X4czkDWsfKvapp+hSCgetu+TodSC5pe/RtMGaJ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=TVQNoNDM; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1721035837; x=1752571837;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D0slsWnwgK/4ACt9MojNNdk7pvHG3CytFOgUEjPTbDc=;
  b=TVQNoNDM5JSO5Jk0aVdXaDriK6xC3GX3dDwtTAtMuDxRF3f+mr7/O2rP
   +S/IfZk7Pam7RMM8SFzuq4hiSeG7GZ+6or+wduEPhf7RpN+aUloJ+ANwT
   ZHhnLTfWSxQp8/troXPLgJ09msdVZrFPXIQZTevNcys1ri4dppztnMuqk
   4=;
X-IronPort-AV: E=Sophos;i="6.09,210,1716249600"; 
   d="scan'208";a="646218815"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 09:30:35 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:26488]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.84:2525] with esmtp (Farcaster)
 id 3c2d93d1-358c-4429-bc3a-b12b5cf7fec9; Mon, 15 Jul 2024 09:30:34 +0000 (UTC)
X-Farcaster-Flow-ID: 3c2d93d1-358c-4429-bc3a-b12b5cf7fec9
Received: from EX19D033EUC004.ant.amazon.com (10.252.61.133) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 15 Jul 2024 09:30:33 +0000
Received: from u40bc5e070a0153.ant.amazon.com (10.106.83.23) by
 EX19D033EUC004.ant.amazon.com (10.252.61.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 15 Jul 2024 09:30:30 +0000
Date: Mon, 15 Jul 2024 11:30:25 +0200
From: "Kagan, Roman" <rkagan@amazon.de>
To: "Stamatis, Ilias" <ilstam@amazon.co.uk>
CC: "Durrant, Paul" <pdurrant@amazon.co.uk>, "levinsasha928@gmail.com"
	<levinsasha928@gmail.com>, "avi@redhat.com" <avi@redhat.com>,
	"mst@redhat.com" <mst@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>
Subject: Re: [PATCH 1/6] KVM: Fix coalesced_mmio_has_room()
Message-ID: <ZpTsMbkH7X2mihZC@u40bc5e070a0153.ant.amazon.com>
Mail-Followup-To: "Kagan, Roman" <rkagan@amazon.de>,
	"Stamatis, Ilias" <ilstam@amazon.co.uk>,
	"Durrant, Paul" <pdurrant@amazon.co.uk>,
	"levinsasha928@gmail.com" <levinsasha928@gmail.com>,
	"avi@redhat.com" <avi@redhat.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>
References: <20240710085259.2125131-1-ilstam@amazon.com>
 <20240710085259.2125131-2-ilstam@amazon.com>
 <ZpFSA4CA1FaS4iWV@u40bc5e070a0153.ant.amazon.com>
 <125da420a114efe4ea1a8f8b5f98bbf5fc7f91ae.camel@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <125da420a114efe4ea1a8f8b5f98bbf5fc7f91ae.camel@amazon.co.uk>
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D033EUC004.ant.amazon.com (10.252.61.133)

On Fri, Jul 12, 2024 at 09:03:32PM +0200, Stamatis, Ilias wrote:
> On Fri, 2024-07-12 at 17:55 +0200, Roman Kagan wrote:
> > On Wed, Jul 10, 2024 at 09:52:54AM +0100, Ilias Stamatis wrote:
> > > The following calculation used in coalesced_mmio_has_room() to check
> > > whether the ring buffer is full is wrong and only allows half the buffer
> > > to be used.
> > > 
> > > avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
> > > if (avail == 0)
> > > 	/* full */
> > > 
> > > The % operator in C is not the modulo operator but the remainder
> > > operator. Modulo and remainder operators differ with respect to negative
> > > values. But all values are unsigned in this case anyway.
> > > 
> > > The above might have worked as expected in python for example:
> > > > > > (-86) % 170
> > > 84
> > > 
> > > However it doesn't work the same way in C.
> > > 
> > > printf("avail: %d\n", (-86) % 170);
> > > printf("avail: %u\n", (-86) % 170);
> > > printf("avail: %u\n", (-86u) % 170u);
> > > 
> > > Using gcc-11 these print:
> > > 
> > > avail: -86
> > > avail: 4294967210
> > > avail: 0
> > 
> > Where exactly do you see a problem?  As you correctly point out, all
> > values are unsigned, so unsigned arithmetics with wraparound applies,
> > and then % operator is applied to the resulting unsigned value.  Out
> > your three examples, only the last one is relevant, and it's perfectly
> > the intended behavior.
> > 
> > Thanks,
> > Roman.
> 
> KVM_COALESCED_MMIO_MAX on x86 is 170, which means the ring buffer has
> 170 entries (169 of which should be usable). 
> 
> If first = 0 and last = 85 then the calculation gives 0 available
> entries in which case we consider the buffer to be full and we exit to
> userspace. But we shouldn't as there are still 84 unused entries.

You want to add a stride instead

	avail = (ring->first + KVM_COALESCED_MMIO_MAX - 1 - last) %
		KVM_COALESCED_MMIO_MAX;

As long as the stride is smaller than half the wraparound, you can think
of the values being on an infinite non-negative axis.

Roman.



Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


