Return-Path: <kvm+bounces-29979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25E599B53B3
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 21:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8B9B286647
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 20:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FB220A5C0;
	Tue, 29 Oct 2024 20:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VpqeNwRE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E253209F26
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730233720; cv=none; b=qlxuUtSHV+xBkBe3Rce+hn9P8JLuzNK3oFHEyaCoGLY3GXnhC0YmRlqmdKdVWoIAABSFrFojcAfadRSDL+98aGGbzqSFjsPGosDbxyF486S6AA3diu4RaFapFqSf41lld6U4JooRpIY+5PKCE0EvWDFCQX2+GrgObOMOGXcYz74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730233720; c=relaxed/simple;
	bh=a5xIuAZIag/sepN5E+3EBOahr5lBoxT2h56exTpk7kM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AW8F/80xmBmnGSqCtCZzJca3QN8NenIz2sF6PqJamnHjnXVOcFHbmZiIjpOVXBll8Zm75hH4wMkxccE8rdKsz0XzENsphQFx7daGDgKofst1EgOHk27D3CRQ211Ay4sSpZQU1plVtneHsCY/H2zcZVNMXyifBlohai4152JuIh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VpqeNwRE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730233715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=851Ps5eN/WBcnZzS5QtOPdUJ2Lt5cNuaFi9PFnOegbw=;
	b=VpqeNwRE4diElT9k9KYP9MSb9WPYljkhfh1C8C/laV6Kq9Snlps8/ANE8jzwU/5LhqVS6w
	wfx/axtmEf1ciYbK2Qq+Uwt1LQpSxW4T4EFUgFQgQcFpzNB53Sa1sR2VqA2EBfyYCFImws
	rjJDaA9Lnmjm/AEqwJyUG/DLERc6BTE=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-Af-dW5QPPfChXxVcvC66Zw-1; Tue, 29 Oct 2024 16:28:32 -0400
X-MC-Unique: Af-dW5QPPfChXxVcvC66Zw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83ac065de2fso59544239f.0
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 13:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730233710; x=1730838510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=851Ps5eN/WBcnZzS5QtOPdUJ2Lt5cNuaFi9PFnOegbw=;
        b=cdOVi2cQbjFHDOS9DEg++6JcX0CboA3R4J8L7NCHDPfnr6xJjOeqXfuQvS6R12U8Pe
         1WB3yqR6JjldGvWjIm/kjeI9g/a7wFNuG9h3ardqF8a0x9tgO83YnX+7PmAYjGpYBBDw
         8e9/NZfOT5MjGWUP3WcfnlPSkRaKZNNUgCrOr5Die/LoQ+OrQjpKlmRim0KaM7iWcXTN
         1U4V2d43yuWUpZnVWrJLuxbJKuBzH2zAnLOM8CCyq5wrWCb1Q/p5JdSF0ZtDUHpp6LqG
         4s7siIw7WfMIOsGEeNJ0GxChBvmse+ElydHNSjFYgyHWlcCtCBWhKYLV8051goCfvbkP
         2/7g==
X-Forwarded-Encrypted: i=1; AJvYcCU7809IU2NRUNlzCHbEJuEP60t1pf2vAWA4Sg57NQ+CVCZu6S7xQvlSWEFQi6Uu6GLYmbo=@vger.kernel.org
X-Gm-Message-State: AOJu0YybodFilCXZYr5nSX2bWBUXN1Qmjo6lpWfzhu464G3s/a4XGWwq
	XapCETNy8/X18g06S+A+3O9A2UBFEvptRZ+3slbXipGdYef80nXMoETSjAWz1HVUnuf6lapDHfa
	m7pRWxmhVkO64iNP8KHFPZkE1G1V28E5scbZAJmlWadP2k2maqFMgCCqBCQ==
X-Received: by 2002:a5d:959a:0:b0:83a:acf9:fa03 with SMTP id ca18e2360f4ac-83b1c612559mr299146739f.5.1730233709987;
        Tue, 29 Oct 2024 13:28:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKReZAi6oCptitalNpW1MwvdgSb9EBWSdrx7SCMBV57J4vGIb8mYpE47sABKEVBNSy5GseDw==
X-Received: by 2002:a5d:959a:0:b0:83a:acf9:fa03 with SMTP id ca18e2360f4ac-83b1c612559mr299145339f.5.1730233709552;
        Tue, 29 Oct 2024 13:28:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b13891df4sm221458139f.46.2024.10.29.13.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 13:28:28 -0700 (PDT)
Date: Tue, 29 Oct 2024 14:28:26 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Parav Pandit <parav@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 "mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com"
 <jasowang@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, Feng Liu <feliu@nvidia.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>, "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>, Leon Romanovsky <leonro@nvidia.com>, Maor
 Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support
 live migration
Message-ID: <20241029142826.1b148685.alex.williamson@redhat.com>
In-Reply-To: <CY8PR12MB7195FCA5172D7829B1ABC773DC4A2@CY8PR12MB7195.namprd12.prod.outlook.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
	<20241028101348.37727579.alex.williamson@redhat.com>
	<20241028162354.GS6956@nvidia.com>
	<20241028105404.4858dcc2.alex.williamson@redhat.com>
	<CY8PR12MB7195FCA5172D7829B1ABC773DC4A2@CY8PR12MB7195.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Oct 2024 17:46:57 +0000
Parav Pandit <parav@nvidia.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Monday, October 28, 2024 10:24 PM
> > 
> > On Mon, 28 Oct 2024 13:23:54 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Oct 28, 2024 at 10:13:48AM -0600, Alex Williamson wrote:
> > >  
> > > > If the virtio spec doesn't support partial contexts, what makes it
> > > > beneficial here?  
> > >
> > > It stil lets the receiver 'warm up', like allocating memory and
> > > approximately sizing things.
> > >  
> > > > If it is beneficial, why is it beneficial to send initial data more than
> > > > once?  
> > >
> > > I guess because it is allowed to change and the benefit is highest
> > > when the pre copy data closely matches the final data..  
> > 
> > It would be useful to see actual data here.  For instance, what is the latency
> > advantage to allocating anything in the warm-up and what's the probability
> > that allocation is simply refreshed versus starting over?
> >   
> 
> Allocating everything during the warm-up phase, compared to no
> allocation, reduced the total VM downtime from 439 ms to 128 ms. This
> was tested using two PCI VF hardware devices per VM.
>
> The benefit comes from the device state staying mostly the same.
> 
> We tested with different configurations from 1 to 4 devices per VM,
> varied with vcpus and memory. Also, more detailed test results are
> captured in Figure-2 on page 6 at [1].

Those numbers seems to correspond to column 1 of Figure 2 in the
referenced document, but that's looking only at downtime.  To me that
chart seems to show a step function where there's ~400ms of downtime
per device, which suggests we're serializing device resume in the
stop-copy phase on the target without pre-copy.

Figure 3 appears to look at total VM migration time, where pre-copy
tends to show marginal improvements in smaller configurations, but up
to 60% worse overall migration time as the vCPU, device, and VM memory
size increase.  The paper comes to the conclusion:

	It can be concluded that either of increasing the VM memory or
	device configuration has equal effect on the VM total migration
	time, but no effect on the VM downtime due to pre-copy
	enablement.

Noting specifically "downtime" here ignores that the overall migration
time actually got worse with pre-copy.

Between columns 10 & 11 the device count is doubled.  With pre-copy
enabled, the migration time increases by 135% while with pre-copy
disabled we only only see a 113% increase.  Between columns 11 & 12 the
VM memory is further doubled.  This results in another 33% increase in
migration time with pre-copy enabled and only a 3% increase with
pre-copy disabled.  For the most part this entire figure shows that
overall migration time with pre-copy enabled is either on par with or
worse than the same with pre-copy disabled.

We then move on to Tables 1 & 2, which are again back to specifically
showing timing of operations related to downtime rather than overall
migration time.  The notable thing here seems to be that we've
amortized the 300ms per device load time across the pre-copy phase,
leaving only 11ms per device contributing to downtime.

However, the paper also goes into this tangent:

	Our observations indicate that enabling device-level pre-copy
	results in more pre-copy operations of the system RAM and
	device state. This leads to a 50% reduction in memory (RAM)
	copy time in the device pre-copy method in the micro-benchmark
	results, saving 100 milliseconds of downtime.

I'd argue that this is an anti-feature.  A less generous interpretation
is that pre-copy extended the migration time, likely resulting in more
RAM transfer during pre-copy, potentially to the point that the VM
undershot its prescribed downtime.  Further analysis should also look
at the total data transferred for the migration and adherence to the
configured VM downtime, rather than just the absolute downtime.

At the end of the paper, I think we come to the same conclusion shown
in Figure 1, where device load seems to be serialized and therefore
significantly limits scalability.  That could be parallelized, but
even 300-400ms for loading all devices is still too much contribution to
downtime.  I'd therefore agree that pre-loading the device during
pre-copy improves the scaling by an order of magnitude, but it doesn't
solve the scaling problem.  Also, it should not come with the cost of
drawing out pre-copy and thus the overall migration time to this
extent.  The reduction in downtime related to RAM copy time should be
evidence that the pre-copy behavior here has exceeded its scope and is
interfering with the balance between pre- and post- copy elsewhere.
Thanks,

Alex

> 
> [1] https://netdevconf.info/0x18/docs/netdev-0x18-paper22-talk-paper.pdf
> 


