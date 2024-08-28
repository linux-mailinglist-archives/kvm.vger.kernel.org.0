Return-Path: <kvm+bounces-25307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F5A963650
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 01:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 058A0B2538D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 23:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3ECB1B011F;
	Wed, 28 Aug 2024 23:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="HvekDgVc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8B01AD40E
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 23:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724888565; cv=none; b=pSySQvB/9zskdrTzFDe9I/Fecfl9Sbnp3epHRmX9++oANZiHwBXJd4Dfn4Oz+7uJvGlEw0bsUy/DhtL+HDgAHnbK8jmvbjbALbA2g4rJ9I84iBzbw0ELyIJW9z+yWDaTkDdowaSrEyjnLnaSXMRLH11YWtcNcVEFJtqS7VFXPfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724888565; c=relaxed/simple;
	bh=W5uolkqDwgsWdSean2w7EiUZlwf6BZ0RGmrOWG3KAts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpXzS8ZxAkK+Z7AIF6wgciU5P9AhumIDN+tQHgAhqxeE1jCxuBA0y7W9Wz7pqwRhfBk6texVpSEHzL8XGLICC4qOf9+2DOVY8AXlXIxjlOjRZIQ57+R/u6mksed8R1dcOYa9A3jmgZJLYhKMYS5uk/NxX1Lyxt+hCWXuxRHWLPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=HvekDgVc; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-45327512c3eso110281cf.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1724888562; x=1725493362; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0rwIUi17tsjeH1VmJPms0B2GoXRPH3G8D0KT2rkLg3Y=;
        b=HvekDgVchBBPbzrzu3YkeYqpDC3AuqCLJ2RTqVnRZs/aTPAKy47Atjfi4b7XnvxZMu
         38mlJkzVTor4Ug7XsY4NfEwqlS49TNVA9fkBMFwUOLf314qMK9/QtK1EJo7x+xQ63Dnm
         ARci+/X9NXlF1Ye50ILCpZP0YTvpsPvJMlseivwyJ3Bk/IXGI4Q0W2o0aHzYrGZi7D/q
         l81WFVBEeaIYr5vEOqBiXgCBUlGkRC8admVOik3A8AM+X/TQyBfdiJn8D69kKVHZdAvf
         zzvxeowFdkTK7sHTgFs2F17nZGWiI01ABwfshjPk1R6BDvHzEo4rarw3DC0fhjs5HODN
         AYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724888562; x=1725493362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rwIUi17tsjeH1VmJPms0B2GoXRPH3G8D0KT2rkLg3Y=;
        b=FP90E+VXLSAmL+YgftEb9n7S+Yuxzt/wvguS6rkMRw59G/77hMECQ+eEEeY7a/MNSj
         tE6zlWlEs5GkWassa+qtW7gHOScoO2fvjSGFPekju/jqdH9PySbmJc0YTv4VN+5Vxzs0
         2rBSGvb5q2Gz1INg0aDJeJP6LE+KNcJGG9G8MjwpU+ydch4jnlaw0wK+xOFY84DweGg9
         QxV8Ib4/HeksVUqsbSY0WsxZKX+HzLVAxiYm1It2xkS6BfMAANXF01jrfvSN701krCUt
         AkyaJrxW8WSJOzbw/fk0c6py0O/ee7o6wjEnX9e7HruHmr3BkSEi3ibBMg//7BkZFalu
         caug==
X-Gm-Message-State: AOJu0Yy8zt45Q+SswzRl7Tw1Cj4cpCS0jPx2KSB0rfaBDD49i2O+V5VN
	VXhy2WXy6g6vzY4baKstLeApezF9X35gbJF5WFiYfWMAYf7SKODYeTtDKo2orLo=
X-Google-Smtp-Source: AGHT+IHEcKouyVFR1WkcCDWhLufxB/kd0gjuitct1+jIU+BLxqDtsKTkt3UjERwCooXxsxHYmrhtIA==
X-Received: by 2002:a05:622a:548d:b0:456:8172:972c with SMTP id d75a77b69052e-4568172981dmr4371791cf.5.1724888561761;
        Wed, 28 Aug 2024 16:42:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45682d97716sm169421cf.85.2024.08.28.16.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 16:42:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sjSJE-006MUq-9P;
	Wed, 28 Aug 2024 20:42:40 -0300
Date: Wed, 28 Aug 2024 20:42:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <20240828234240.GR3468552@ziepe.ca>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
 <20240827123242.GM3468552@ziepe.ca>
 <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>

On Wed, Aug 28, 2024 at 01:00:46PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 27/8/24 22:32, Jason Gunthorpe wrote:
> > On Fri, Aug 23, 2024 at 11:21:21PM +1000, Alexey Kardashevskiy wrote:
> > > The module responsibilities are:
> > > 1. detect TEE support in a device and create nodes in the device's sysfs
> > > entry;
> > > 2. allow binding a PCI device to a VM for passing it through in a trusted
> > > manner;
> > 
> > Binding devices to VMs and managing their lifecycle is the purvue of
> > VFIO and iommufd, it should not be exposed via weird sysfs calls like
> > this. You can't build the right security model without being inside
> > the VFIO context.
> 
> Is "extend the MAP_DMA uAPI to accept {gmemfd, offset}" enough for the VFIO
> context, or there is more and I am missing it?

No, you need to have all the virtual PCI device creation stuff linked
to a VFIO cdev to prove you have rights to do things to the physical
device.
 
> > I'm not convinced this should be in some side module - it seems like
> > this is possibly more logically integrated as part of the iommu..
> 
> There are two things which the module's sysfs interface tries dealing with:
> 
> 1) device authentication (by the PSP, contrary to Lukas'es host-based CMA)
> and PCIe link encryption (PCIe IDE keys only programmable via the PSP);

So when I look at the spec I think that probably TIO_DEV_* should be
connected to VFIO, somewhere as vfio/kvm/iommufd ioctls. This needs to
be coordinated with everyone else because everyone has *some kind* of
"trusted world create for me a vPCI device in the secure VM" set of
verbs.

TIO_TDI is presumably the device authentication stuff?

This is why I picked on tsm_dev_connect_store()..

> Besides sysfs, the module provides common "verbs" to be defined by the
> platform (which is right now a reduced set of the AMD PSP operations but the
> hope is it can be generalized); and the module also does PCIe DOE bouncing
> (which is also not uncommon). Part of this exercise is trying to find some
> common ground (if it is possible), hence routing everything via this module.

I think there is a seperation between how the internal stuff in the
kernel works and how/what the uAPIs are.

General stuff like authenticate/accept/authorize a PCI device needs
to be pretty cross platform.

Stuff like creating vPCIs needs to be ioctls linked to KVM/VFIO
somehow and can have more platform specific components.

I would try to split your topics up more along those lines..

Jason

