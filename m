Return-Path: <kvm+bounces-15027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3881B8A8F13
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4A022822F2
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189FB86158;
	Wed, 17 Apr 2024 23:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+3s34Sc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8FC85C79
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 23:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713394947; cv=none; b=qYWEF21dkcMkqV1G6otDwL2vKmhEP3FMwzk3FoNFClz+Qezv1CStrrBym4NAF7sQhEcFkykSYR6Fyq2DV8weBiCr0fkJQXjMEVQWrcexYRa674DLUcUva6M3oNSShbLiV54UCtggXAsXyp7EzowN10wlsLaK/GAv81Y6guU8Fwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713394947; c=relaxed/simple;
	bh=LBU3fLFom8vb/7JkuEvy+I6UW8qanTPcmH2t8cVFq8c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMFOgty1Vo1/LcnMCLAtjqBubj2lyWtEmFFK/ZgwkeqB4GSXYM/NDLJqnCOps9YJu0dC51WX8ESLEAPlCB5Y1AZ0ih5e05doAndoRH8BjFFpD/gB0VqqE1JTB47ce6Z9KTMOEYflLnas4O9geneJjyRBipQbUewZdHS1g8ZIM+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+3s34Sc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713394944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LV6Nb717r/ECNUv4GKXXSYG0oYIZ4itZI6Tnma6j0S4=;
	b=e+3s34ScGJhxVpe5z+CkZAiPZpPGZ4X+kyRHB9D8++vD/9phHMKEerWt7L4ZByH6U4IlnI
	1PNm70Sq5ZKquGh/5wDwMMwQcaUEVPjEx9ucVOpxUa7pvWvFs+8MB8qMQ20XZac+lgrHFy
	HrwMqf8dH5FtP+b6XkHWdpTXjCBqehQ=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-E-Y_yBlvPwODgeTlcaEyFQ-1; Wed, 17 Apr 2024 19:02:21 -0400
X-MC-Unique: E-Y_yBlvPwODgeTlcaEyFQ-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5aa3c983f88so325774eaf.3
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713394940; x=1713999740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LV6Nb717r/ECNUv4GKXXSYG0oYIZ4itZI6Tnma6j0S4=;
        b=kO2R6DyDKA/bNr3pfDogTBQ8dhvjgq964hLKVYk2voT5BHRnmUf5aNtrim3XOBcHKs
         7kDyUB8v+33zhDL2SRIE6rPaCgU7X7/zaV/XBoUBHItw6Fnk05qeG+yYyKzIFGF4uxRp
         kfhsXLROHo+6LRr+9UTfHtyyIbRroQcm+k5sjw+hF3dsCXXmd/l3FAj3kqzytAXzxn2H
         rl558tBv/d8lgtoq3BBQfl68NcfKt/SozsC5Q7LHnwRwdkAhKW0NAC77AFWNM77jLcz3
         6H4QTcfjX0B6y8iDoNpVXPMMe292sW2ZOiAdwjC8vInFH2DOJUxNcA4VvH3P7yYTL8ek
         8Zug==
X-Forwarded-Encrypted: i=1; AJvYcCUxk6rAwceKFW3Sq32D6QGeZq1m+2fRjnHvU4T6hVxtsZ+nb5tS2CkhEdk6XVubcns9L8xgprPuik+YnaDISG9Eyp+Y
X-Gm-Message-State: AOJu0Yyxp67bUAZuW8NMiWqU4CM/M72NxRsBOvVy/bL94OQzxePiALXn
	xCVCcROwTCrmZi0a2QmF/LPEOQ8Ar1uW902ZEotOhlyepDXG55PQCk/gYha6dBtz2RyzoYc8b/E
	DnBeYYZlAXMttGkKL1GzOTNwSjw8MUOSStz+iEDZ5rG02ZmCtnQ==
X-Received: by 2002:a4a:98c6:0:b0:5aa:5252:6efc with SMTP id b6-20020a4a98c6000000b005aa52526efcmr1287486ooj.9.1713394940289;
        Wed, 17 Apr 2024 16:02:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzaXJdXFiq9LMPiWxQaCBmqb2idfqAHM9IG+BCrxxovArqOWEnbc06EItG1q9EXTRxNzWIYg==
X-Received: by 2002:a4a:98c6:0:b0:5aa:5252:6efc with SMTP id b6-20020a4a98c6000000b005aa52526efcmr1287472ooj.9.1713394940025;
        Wed, 17 Apr 2024 16:02:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id m7-20020a4aab87000000b005a4a656860bsm77843oon.2.2024.04.17.16.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 16:02:19 -0700 (PDT)
Date: Wed, 17 Apr 2024 17:02:16 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240417170216.1db4334a.alex.williamson@redhat.com>
In-Reply-To: <20240417122051.GN3637727@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240416175018.GJ3637727@nvidia.com>
	<BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240417122051.GN3637727@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Apr 2024 09:20:51 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Apr 17, 2024 at 07:16:05AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, April 17, 2024 1:50 AM
> > > 
> > > On Tue, Apr 16, 2024 at 08:38:50AM +0000, Tian, Kevin wrote:  
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Friday, April 12, 2024 4:21 PM
> > > > >
> > > > > A userspace VMM is supposed to get the details of the device's PASID
> > > > > capability
> > > > > and assemble a virtual PASID capability in a proper offset in the virtual  
> > > PCI  
> > > > > configuration space. While it is still an open on how to get the available
> > > > > offsets. Devices may have hidden bits that are not in the PCI cap chain.  
> > > For  
> > > > > now, there are two options to get the available offsets.[2]
> > > > >
> > > > > - Report the available offsets via ioctl. This requires device-specific logic
> > > > >   to provide available offsets. e.g., vfio-pci variant driver. Or may the  
> > > device  
> > > > >   provide the available offset by DVSEC.
> > > > > - Store the available offsets in a static table in userspace VMM. VMM gets  
> > > the  
> > > > >   empty offsets from this table.
> > > > >  
> > > >
> > > > I'm not a fan of requesting a variant driver for every PASID-capable
> > > > VF just for the purpose of reporting a free range in the PCI config space.
> > > >
> > > > It's easier to do that quirk in userspace.
> > > >
> > > > But I like Alex's original comment that at least for PF there is no reason
> > > > to hide the offset. there could be a flag+field to communicate it. or
> > > > if there will be a new variant VF driver for other purposes e.g. migration
> > > > it can certainly fill the field too.  
> > > 
> > > Yes, since this has been such a sticking point can we get a clean
> > > series that just enables it for PF and then come with a solution for
> > > VF?
> > >   
> > 
> > sure but we at least need to reach consensus on a minimal required
> > uapi covering both PF/VF to move forward so the user doesn't need
> > to touch different contracts for PF vs. VF.  
> 
> Do we? The situation where the VMM needs to wholly make a up a PASID
> capability seems completely new and seperate from just using an
> existing PASID capability as in the PF case.

But we don't actually expose the PASID capability on the PF and as
argued in path 4/ we can't because it would break existing userspace.

> If it needs to make another system call or otherwise to do that then
> that seems fine to do incrementally??

With PASID currently hidden, VF and PF support really seem too similar
not to handle them both at the same time.  What's missing is a
mechanism to describe unused config space where userspace can implement
an emulated PASID capability.  Defining a DVSEC capability to handle
this seemed to be the preferred solution from the LPC discussion.  PF
and VF devices that implement a TBD DVSEC capability could avoid
needing a variant driver.  Until then we need to be careful not to
undermine a future world with that preferred solution by introducing
side-band mechanisms which only work for variant drivers and PF
devices.  Thanks,

Alex


