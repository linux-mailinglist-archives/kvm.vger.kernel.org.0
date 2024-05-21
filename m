Return-Path: <kvm+bounces-17849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A808CB213
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04169282A70
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9C777105;
	Tue, 21 May 2024 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RqtLenI+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272D14C66
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 16:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716308489; cv=none; b=t+/Zg1KpiG1qROrJKxksG7nS7vMZFuRk8bNL885RoTbbl4Al/YG28fWTpc0hON8STAMvVaAC0Xr1BqTcevbq2e6nl6ROaEE4E51K6+k1t6wzzKxf+oaMdFlXhVLPRbLkVK2yxpnDzhaPCqAtm11apKfafQnYIbT3P4iWLxKwkPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716308489; c=relaxed/simple;
	bh=XS/PoMZ0vohM4lSNeJOQ/OrYk9eYCa2hb4zd9/QLyUg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UVUtxK+d232JDlBVxXWZsQQ1TrkEm7zp4lJC20JpCu8yr9dN9CxNc5OmFts/KbIwbK1f7FhnJqzYjFvA7gJnhVr1ROL1quuVO9hVZorYFB/H+oiNXnmkLBTReXUOt2FwZbp5PU3oQD8MaFyfklH4cgXjPLu0BIF1PUPScn+XqIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RqtLenI+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716308487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zBkDmR7/UY5pu+K19ObSTfPnyl9pBj1jvfc+LLqjkwU=;
	b=RqtLenI+QzUwggIUGTpPMStpUR4U9bsSW7cOf9rv0pEAiVjN+9BeYzr1LN+CnXsetVVLgH
	KS4OEAsU2B7L2e1eE9EqxbOk41wYNorzQ+0MWiJhh94BlsTRtZvhjgdaMvYiiTgQTI4CfB
	5Z1+hGfxZqZ4tcu/fuvHviqVuJxi31c=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-qgytwAEvPrKTRel3anzihQ-1; Tue, 21 May 2024 12:21:25 -0400
X-MC-Unique: qgytwAEvPrKTRel3anzihQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7e1e05c39easo1111286239f.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 09:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716308485; x=1716913285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zBkDmR7/UY5pu+K19ObSTfPnyl9pBj1jvfc+LLqjkwU=;
        b=c64mK8VuQMs0S1bL2ncKf5OCuRFg41si9G1cY7ca7Bd9PXVQYRbtArFbyjjtRrsS1s
         2ERngQ/jS8kemMsTuEstzXQTMogx+WioHUaO7+zmJBcTM4ANJDBdW9xVpzSMCwqeVMy1
         BgxzzGWksJGPYOArcct8PAjQ6beDF2FTwD2GJAO2MWjqSabGjOGUX1vTlUL4suuwbkgE
         tQ37Vk7odGaUg38EvaObMQhtRn2aKNzfL1mAhmgo1fKRDHnUUQiNO79FLKi7yXCdDHgT
         e/chj3k5shLquc8OnF4aFgrnh8QWhUhlFCSNgw4rTV6iNB2X2hvPh1IXnuuzSxxIHbUo
         c7Yg==
X-Forwarded-Encrypted: i=1; AJvYcCXHolAOGbtpOVxOCYxYy1+f1PCY7Z6HAkkstp3688mlS4Xh3foqS9uy+tvi7dGZMwgYt37eNjqLs4iG4EjRonesU2Zt
X-Gm-Message-State: AOJu0YztfZhzsfJhpdGRkJSI+OleWdOxfUm5zLEluIh7+9DpNmtjvuLJ
	GR9BIDtFZlXOXkAgAgzTV2nFsu1QbjcUijspsP5OD4BJ8EcTyA6MWvbdXuqsP5v597dEcfvwVVA
	14uheuX0Cvp0G3RbdsDfBwHysBgJ+eOb/W0M7w+UxcUN2mPjAVQ==
X-Received: by 2002:a5e:9515:0:b0:7e1:83ee:7263 with SMTP id ca18e2360f4ac-7e1b5217d31mr3432547939f.19.1716308485136;
        Tue, 21 May 2024 09:21:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPMptMWyo0jbfKOTtQpGxuYSbiSfgve0+756eiZhQ4Fl8lA8G4jDvEgV+jrxZwDY6cLELV/Q==
X-Received: by 2002:a5e:9515:0:b0:7e1:83ee:7263 with SMTP id ca18e2360f4ac-7e1b5217d31mr3432546639f.19.1716308484853;
        Tue, 21 May 2024 09:21:24 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1be57e690sm615576439f.39.2024.05.21.09.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 09:21:24 -0700 (PDT)
Date: Tue, 21 May 2024 10:21:23 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Vetter, Daniel"
 <daniel.vetter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
 <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
 "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240521102123.7baaf85a.alex.williamson@redhat.com>
In-Reply-To: <20240521160714.GJ20229@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
	<20240507062138.20465-1-yan.y.zhao@intel.com>
	<20240509121049.58238a6f.alex.williamson@redhat.com>
	<Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
	<20240510105728.76d97bbb.alex.williamson@redhat.com>
	<ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
	<BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240516143159.0416d6c7.alex.williamson@redhat.com>
	<20240517171117.GB20229@nvidia.com>
	<BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240521160714.GJ20229@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 May 2024 13:07:14 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, May 20, 2024 at 02:52:43AM +0000, Tian, Kevin wrote:
> > +Daniel
> >   
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Saturday, May 18, 2024 1:11 AM
> > > 
> > > On Thu, May 16, 2024 at 02:31:59PM -0600, Alex Williamson wrote:
> > >   
> > > > Yes, exactly.  Zero'ing the page would obviously reestablish the
> > > > coherency, but the page could be reallocated without being zero'd and as
> > > > you describe the owner of that page could then get inconsistent
> > > > results.  
> > > 
> > > I think if we care about the performance of this stuff enough to try
> > > and remove flushes we'd be better off figuring out how to disable no
> > > snoop in PCI config space and trust the device not to use it and avoid
> > > these flushes.
> > > 
> > > iommu enforcement is nice, but at least ARM has been assuming that the
> > > PCI config space bit is sufficient.
> > > 
> > > Intel/AMD are probably fine here as they will only flush for weird GPU
> > > cases, but I expect ARM is going to be unhappy.
> > >   
> > 
> > My impression was that Intel GPU is not usable w/o non-coherent DMA,
> > but I don't remember whether it's unusable being a functional breakage
> > or a user experience breakage. e.g. I vaguely recalled that the display
> > engine cannot afford high resolution/high refresh rate using the snoop
> > way so the IOMMU dedicated for the GPU doesn't implement the force
> > snoop capability.
> > 
> > Daniel, can you help explain the behavior of Intel GPU in case nosnoop
> > is disabled in the PCI config space?
> > 
> > Overall it sounds that we are talking about different requirements. For
> > Intel GPU nosnoop is a must but it is not currently done securely so we
> > need add proper flush to fix it, while for ARM looks you don't have a
> > case which relies on nosnoop so finding a way to disable it is more
> > straightforward?  
> 
> Intel GPU weirdness should not leak into making other devices
> insecure/slow. If necessary Intel GPU only should get some variant
> override to keep no snoop working.
> 
> It would make alot of good sense if VFIO made the default to disable
> no-snoop via the config space.

We can certainly virtualize the config space no-snoop enable bit, but
I'm not sure what it actually accomplishes.  We'd then be relying on
the device to honor the bit and not have any backdoors to twiddle the
bit otherwise (where we know that GPUs often have multiple paths to get
to config space).  We also then have the question of does the device
function correctly if we disable no-snoop.  The more secure approach
might be that we need to do these cache flushes for any IOMMU that
doesn't maintain coherency, even for no-snoop transactions.  Thanks,

Alex


