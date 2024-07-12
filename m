Return-Path: <kvm+bounces-21526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6711392FDF6
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 913131C22BB0
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10D2174EDE;
	Fri, 12 Jul 2024 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="OFuoHy+r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA4112B171
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720799762; cv=none; b=O7lqJM6sSYPRkA0Ax/8DDE4zdaRJwOqxd26b+Kslmwmh3nVPj2mi7xVUUC/N6ycfmoLFf7t7WhVydA1qPXnzdj+dZp3GuT7Lax8P1WcRVL41CnmgFMnyVS1AHFgHAeS+h+GCdaU1fFK75DuvmMd9W3S9GBQX9nvRhslu3hwJUVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720799762; c=relaxed/simple;
	bh=1N0a4ShlQ9Wx5dPI/M+KqLPWf3LrKGn0YFctkiFVJtE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEIvX9cqDS0cXf+v45z/MA2sndpj4WVV5h1LZUacS+HvJfIGJRSpSesUUtAYQ+QLsSLF59qtELNC0p5hja/qKih8SuSZ2A1Ol1HFKt+6k+9WmLSqOkXiKoSqp+3bfbmOWoUmMmj0t3qIcnyyWe0aHQfBT3EjRFOu8GmCyF7mvOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=OFuoHy+r; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1720799761; x=1752335761;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AYmbh2c+qAz5fsp75W5mE//1f4SGo/W9sfveerPqGuw=;
  b=OFuoHy+rnaQ70DZufIsNJlavRC/4eurkl6UJtdhin9bCE8C86cfAvR9a
   Nt5wEtaxPJ5pEQTSInYt0Dg9ifGy+lwsHrQEUrQ7VZgBvUqnAjb4eXJCE
   2vtdfgJHh7LWub2Tvw5p5VH4gfIZXoZnlJLlPWgr3+w0NydMexRREpnNH
   w=;
X-IronPort-AV: E=Sophos;i="6.09,203,1716249600"; 
   d="scan'208";a="11656649"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 15:55:58 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:41322]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.169:2525] with esmtp (Farcaster)
 id 2028c054-d917-4a19-b8bb-3495d245e8a5; Fri, 12 Jul 2024 15:55:56 +0000 (UTC)
X-Farcaster-Flow-ID: 2028c054-d917-4a19-b8bb-3495d245e8a5
Received: from EX19D033EUC004.ant.amazon.com (10.252.61.133) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 12 Jul 2024 15:55:56 +0000
Received: from u40bc5e070a0153.ant.amazon.com (10.106.83.6) by
 EX19D033EUC004.ant.amazon.com (10.252.61.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 12 Jul 2024 15:55:52 +0000
Date: Fri, 12 Jul 2024 17:55:47 +0200
From: Roman Kagan <rkagan@amazon.de>
To: Ilias Stamatis <ilstam@amazon.com>
CC: <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <pdurrant@amazon.co.uk>,
	<dwmw@amazon.co.uk>, <Laurent.Vivier@bull.net>, <ghaskins@novell.com>,
	<avi@redhat.com>, <mst@redhat.com>, <levinsasha928@gmail.com>,
	<peng.hao2@zte.com.cn>, <nh-open-source@amazon.com>
Subject: Re: [PATCH 1/6] KVM: Fix coalesced_mmio_has_room()
Message-ID: <ZpFSA4CA1FaS4iWV@u40bc5e070a0153.ant.amazon.com>
Mail-Followup-To: Roman Kagan <rkagan@amazon.de>,
	Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, pdurrant@amazon.co.uk, dwmw@amazon.co.uk,
	Laurent.Vivier@bull.net, ghaskins@novell.com, avi@redhat.com,
	mst@redhat.com, levinsasha928@gmail.com, peng.hao2@zte.com.cn,
	nh-open-source@amazon.com
References: <20240710085259.2125131-1-ilstam@amazon.com>
 <20240710085259.2125131-2-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240710085259.2125131-2-ilstam@amazon.com>
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
 EX19D033EUC004.ant.amazon.com (10.252.61.133)

On Wed, Jul 10, 2024 at 09:52:54AM +0100, Ilias Stamatis wrote:
> The following calculation used in coalesced_mmio_has_room() to check
> whether the ring buffer is full is wrong and only allows half the buffer
> to be used.
> 
> avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
> if (avail == 0)
> 	/* full */
> 
> The % operator in C is not the modulo operator but the remainder
> operator. Modulo and remainder operators differ with respect to negative
> values. But all values are unsigned in this case anyway.
> 
> The above might have worked as expected in python for example:
> >>> (-86) % 170
> 84
> 
> However it doesn't work the same way in C.
> 
> printf("avail: %d\n", (-86) % 170);
> printf("avail: %u\n", (-86) % 170);
> printf("avail: %u\n", (-86u) % 170u);
> 
> Using gcc-11 these print:
> 
> avail: -86
> avail: 4294967210
> avail: 0

Where exactly do you see a problem?  As you correctly point out, all
values are unsigned, so unsigned arithmetics with wraparound applies,
and then % operator is applied to the resulting unsigned value.  Out
your three examples, only the last one is relevant, and it's perfectly
the intended behavior.

Thanks,
Roman.



Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


