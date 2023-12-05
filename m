Return-Path: <kvm+bounces-3429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A9180444E
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95C711C20BAE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 01:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B5B2112;
	Tue,  5 Dec 2023 01:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="OlOdlCWd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF84B4
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 17:53:08 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-db979bbae81so1109474276.0
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 17:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701741188; x=1702345988; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oRH2uAYogUYIUa/oY+a6fjeOWjq8l8YTwpKlfGIpMx0=;
        b=OlOdlCWdPgC3l1KNYSRJV3HUwIE+S4XdiVSq+bRMVJzMzn4Je2CxyXcuTZWL5dVE1S
         Icr5hhxmK6sQYWLf26Xg/xblr/vQv53C24xfI30FzAUthcnbmrgrDRgJH3qKdst3D+TA
         +nN+0RoS1ghOKBzRaQA5L4maROKfmJz/Nm0/e/MwkrY5v9r0wB/AJkg8xaQU0fKhP8+v
         2hZJXkwbVnUhR+F50CHHUblyQo1h4uymv+itp3lEqkgYrutf+0641HO9kpUiTLfv8DMB
         Pof6QpzCD4QOFURSuhjsxcIa6PcED7u+QfzEflL2JaiJWnwH4TbzO0euxOuvWYs19YlR
         ECrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701741188; x=1702345988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oRH2uAYogUYIUa/oY+a6fjeOWjq8l8YTwpKlfGIpMx0=;
        b=PDmv+lIF90BWeNoxj8SeopTyfVJUganOxyo/+V1+y/zCT2FNX0t/2bYUmRC31OpuPd
         IlrKKYb87sqZHB+aFMn6Nh93RbAAtjw2T0xDTLgg31DaP6x2z01Bv6KvVmXHz4LfgjvE
         omyikDY3S6IdioGrlFFgjAw9U6DjnFlkmVGSagU+gDp8dX4QIqBn7Ux5kZJ+84zM4C9E
         UHjgzoFXuvJGVUFtaV3+8+SU+BJZYWavZ5whQzeFvd9/pWyVX16g3NnEMFO/Dwp4NCb1
         97xDda1/L5PIOopuBc0KdhUfad1Y3vSc5aWBz9hwcFGHcLIfDmIpAUJQhI4h24ndhKJ/
         zpkA==
X-Gm-Message-State: AOJu0YwBdSiSieVw8mBHf95zNJP0mxTkwZplPRm1CkKrlioSffwG7GhA
	QW+SbGrO5NiHghQT8vX7iDcpew==
X-Google-Smtp-Source: AGHT+IF4VBn6tyOozvzM9CVoRs+gAsRv4cTJQMkyaZ1xVdhvLbMy7MIth4hCI5Sf5Nd+zU02NLjOhA==
X-Received: by 2002:a25:9cc3:0:b0:db7:dacf:4d68 with SMTP id z3-20020a259cc3000000b00db7dacf4d68mr2426282ybo.100.1701741187849;
        Mon, 04 Dec 2023 17:53:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id i2-20020a056214030200b0067ac8bedcd4sm1356376qvu.88.2023.12.04.17.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 17:53:07 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rAKcU-00BeKU-SY;
	Mon, 04 Dec 2023 21:53:06 -0400
Date: Mon, 4 Dec 2023 21:53:06 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Message-ID: <20231205015306.GQ1489931@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>
 <20231203141414.GJ1489931@ziepe.ca>
 <2354dd69-0179-4689-bc35-f4bf4ea5a886@linux.intel.com>
 <BN9PR11MB5276999D29A133F33C3C4FEA8C86A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231204132503.GL1489931@ziepe.ca>
 <BN9PR11MB5276908231BA164E4AF8806F8C85A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276908231BA164E4AF8806F8C85A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Tue, Dec 05, 2023 at 01:32:26AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Monday, December 4, 2023 9:25 PM
> > 
> > On Mon, Dec 04, 2023 at 05:37:13AM +0000, Tian, Kevin wrote:
> > > > From: Baolu Lu <baolu.lu@linux.intel.com>
> > > > Sent: Monday, December 4, 2023 9:33 AM
> > > >
> > > > On 12/3/23 10:14 PM, Jason Gunthorpe wrote:
> > > > > On Sun, Dec 03, 2023 at 04:53:08PM +0800, Baolu Lu wrote:
> > > > >> Even if atomic replacement were to be implemented,
> > > > >> it would be necessary to ensure that all translation requests,
> > > > >> translated requests, page requests and responses for the old domain
> > are
> > > > >> drained before switching to the new domain.
> > > > >
> > > > > Again, no it isn't required.
> > > > >
> > > > > Requests simply have to continue to be acked, it doesn't matter if
> > > > > they are acked against the wrong domain because the device will simply
> > > > > re-issue them..
> > > >
> > > > Ah! I start to get your point now.
> > > >
> > > > Even a page fault response is postponed to a new address space, which
> > > > possibly be another address space or hardware blocking state, the
> > > > hardware just retries.
> > >
> > > if blocking then the device shouldn't retry.
> > 
> > It does retry.
> > 
> > The device is waiting on a PRI, it gets back an completion. It issues
> > a new ATS (this is the rety) and the new-domain responds back with a
> > failure indication.
> 
> I'm not sure that is the standard behavior defined by PCIe spec.

> According to "10.4.2 Page Request Group Response Message", function's
> response to Page Request failure is implementation specific.
> 
> so a new ATS is optional and likely the device will instead abort the DMA
> if PRI response already indicates a failure.

I didn't said the PRI would fail, I said the ATS would fail with a
non-present.

It has to work this way or it is completely broken with respect to
existing races in the mm side. Agents must retry non-present ATS
answers until you get a present or a ATS failure.

> > Again, all racy. If a DMA is ongoing at the same instant things are
> > changed there is no definitive way to say if it resolved before or
> > after.
> > 
> > The only thing we care about is that dmas that are completed before
> > see the before translation and dmas that are started after see the
> > after translation.
> > 
> > DMAs that cross choose one at random.
> 
> Yes that makes sense for replacement.
> 
> But here we are talking about a draining requirement when disabling
> a pasid entry, which is certainly not involved in replacement.

It is the same argument, you are replacing a PTE that was non-present
with one that is failing/blocking - the result of a DMA that crosses
this event can be either.

> > > I don't think atomic replace is the main usage for this draining
> > > requirement. Instead I'm more interested in the basic popular usage:
> > > attach-detach-attach and not convinced that no draining is required
> > > between iommu/device to avoid interference between activities
> > > from old/new address space.
> > 
> > Something like IDXD needs to halt DMAs on the PASID and flush all
> > outstanding DMA to get to a state where the PASID is quiet from the
> > device perspective. This is the only way to stop interference.
> 
> why is it IDXD specific behavior? I suppose all devices need to quiesce
> the outstanding DMAs when tearing down the binding between the
> PASID and previous address space.

Because it is so simple HW I assume this is why this code is being
pushed here :)

> but there are also terminal conditions e.g. when a workqueue is
> reset after hang hence additional draining is required from the 
> iommu side to ensure all the outstanding page requests/responses
> are properly handled.

Then it should be coded as an explicit drain request from device when
and where they need it.

It should not be integrated into the iommu side because it is
nonsensical. Devices expecting consistent behavior must stop DMA
before changing translation, and if they need help to do it they must
call APIs. Changing translation is not required after a so called
"terminal event".

> vt-d spec defines a draining process to cope with those terminal
> conditions (see 7.9 Pending Page Request Handling on Terminal
> Conditions). intel-iommu driver just implements it by default for
> simplicity (one may consider providing explicit API for drivers to
> call but not sure of the necessity if such terminal conditions
> apply to most devices). anyway this is not a fast path.

It is not "by default" it is in the wrong place. These terminal
conditions are things like FLR. FLR has nothing to do with changing
the translation. I can trigger FLR and keep the current translation
and still would want to flush out all the PRIs before starting DMA
again to avoid protocol confusion.

An API is absolutely necessary. Confusing the cases that need draining
with translation change is just not logically right.

eg we do need to modify VFIO to do the drain on FLR like the spec
explains!

Draining has to be ordered correctly with whatever the device is
doing. Drain needs to come after FLR, for instance. It needs to come
after a work queue reset, because drain doesn't make any sense unless
it is coupled with a DMA stop at the device.

Hacking a DMA stop by forcing a blocking translation is not logically
correct, with wrong ordering the device may see unexpected translation
failures which may trigger AERs or bad things..

> another example might be stop marker. A device using stop marker
> doesn't need to wait for outstanding page requests. According to PCIe
> spec (10.4.1.2 Managing PASID Usage on PRG Requests) the device
> simply marks outstanding page request as stale and sends a stop
> marker message to the IOMMU. Page responses for those stale
> requests are ignored. But presumably the iommu driver still needs
> to drain those requests until the stop marker message in unbind
> to avoid them incorrectly routed to a new address space in case the
> PASID is rebound to another process immediately.

Stop marker doesn't change anything, in all processing it just removes
requests that have yet to complete. If a device is using stop then
most likely the whole thing is racy and the OS simply has to be ready
to handle stop at any time.

Jason

