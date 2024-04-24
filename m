Return-Path: <kvm+bounces-15860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D6738B127D
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 515761C23950
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0361217BB9;
	Wed, 24 Apr 2024 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IC45dDp0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0B315E9B
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 18:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713983939; cv=none; b=atH/J/1agPvy7EaA86piO6mUOE5Ys4X9jQ4RKs7SHy1ygPeD8BKiY3Az0l8rmLF4or7ko+ndPrGs+dTLDkw3LhZy4RxQVBvyfZg/Fa8mWtnsiJVbmPYJhkNw4DVlZdxMa7r8y0n3PagUfQFT4mV6H/D5vuL4du7T/IEhMm4PrWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713983939; c=relaxed/simple;
	bh=udJ5HLtq+8PYFarkckyLquzps5E8ZfnLCyaUdY+DZjw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kiw/gLHC+WI2pfWGfXc27FhV2w6PEPXhLgHX7Qjc3kB1lrssL2BaZzSKUghET1bjra1Yob+ndLWJk9LEwq0w/8IphCa3GpAWo3iZOtg+oCT4U5piUOhcDxa64v4plxbqjnlssHD6BgicQ92mGfjTiSsO8T2hVkH0oJFZoPAB7bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IC45dDp0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713983936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJ7YLFnZxS7AAkZVfPRO8VEYZa8wECZjy46pv+nOVZw=;
	b=IC45dDp0NfwpfznBOSgIsHDiflDh/4bAVorX8DK6BtHp6nlXaVSFoRJ9xW6nzR51vpJuef
	73YI8AY/YOwluAfb3f6fYFXzQV4AvHOgROtsxw+NPOkgzsme0kG7tRwED6RDZxVXbRbnJk
	lgoFPt4bLB48lycDVBniPVyfshiN5ZI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-qEzhtjr6N_eSuDE1sCWM9A-1; Wed, 24 Apr 2024 14:38:54 -0400
X-MC-Unique: qEzhtjr6N_eSuDE1sCWM9A-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7d6c32ef13bso14198039f.0
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 11:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713983933; x=1714588733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJ7YLFnZxS7AAkZVfPRO8VEYZa8wECZjy46pv+nOVZw=;
        b=jST1ZYo2iXwGErKLJo3vOpJn0kExpW5a/aH04A50MsR6bF94P1rzbrfPk3IKw9B0yL
         5lxyIqvCQr9RaGpI2n3AUO1u5dl0XCpyJtus5UA/2bG4pOgsQMsK9MOVE1yn7Nc1wJli
         zcyUTPXhSgsBitw3MpOXS2Y/sSTkczPBQatuhKgje0oaiYVQNT0K47B+AHRsmAiEU3U3
         pPDQZFFovVmXsbg1aT3yvcvsZwWDCVN2ErSYrGkVwq+TmG7cT6LadAncCkCtFVOpq7BZ
         luW/AwpBFSoVtes2XHScL2vqhDBueNiGlMPPEXBmeZ6099kEseSiau94DbiJaJG8W8RN
         08/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtUly/jKgljBsAOjUamOW1ayrV3M0s2bBKkOJkjZUR31askHn36NO/1m1oTIy3Vsv7/YfeBbhYwiyVyzs8jE7DM1/n
X-Gm-Message-State: AOJu0YxqtVks1wWqoW5YFxtq4i/stUjzkMrjLMGRuMBv/7iTCkpQ2sBw
	eL8UF/1BPImreFcLzXS/t6F1HICtHLP018LfWSB5WpvZH/OO2ptpXFGp7o1jNBkomly+gCoz3TU
	UfTmFo3EGXzMr0hLexi1/RLvhHqf1ySsoGqdrFwO1vlsQFYmbzA==
X-Received: by 2002:a6b:5908:0:b0:7da:19ca:722c with SMTP id n8-20020a6b5908000000b007da19ca722cmr3703189iob.12.1713983933245;
        Wed, 24 Apr 2024 11:38:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHN/il8+JlQjH7aop/qgnU0DqcOYnd3zGCXvyRn8kvHThtQsKV4okzWPT6Ds0PZZ+SCfsfDQ==
X-Received: by 2002:a6b:5908:0:b0:7da:19ca:722c with SMTP id n8-20020a6b5908000000b007da19ca722cmr3703169iob.12.1713983932917;
        Wed, 24 Apr 2024 11:38:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ez4-20020a056638614400b00482a9f7066csm4297271jab.151.2024.04.24.11.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 11:38:52 -0700 (PDT)
Date: Wed, 24 Apr 2024 12:38:51 -0600
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
Message-ID: <20240424123851.09a32cdf.alex.williamson@redhat.com>
In-Reply-To: <20240424141525.GN941030@nvidia.com>
References: <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
	<20240418143747.28b36750.alex.williamson@redhat.com>
	<BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
	<BN9PR11MB5276183377A6D053EFC837FD8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424141525.GN941030@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Apr 2024 11:15:25 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Apr 24, 2024 at 05:19:31AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, April 24, 2024 8:12 AM
> > > 
> > > On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:  
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Tuesday, April 23, 2024 8:02 PM
> > > > >
> > > > > It feels simpler if the indicates if PASID and ATS can be supported
> > > > > and userspace builds the capability blocks.  
> > > >
> > > > this routes back to Alex's original question about using different
> > > > interfaces (a device feature vs. PCI PASID cap) for VF and PF.  
> > > 
> > > I'm not sure it is different interfaces..
> > > 
> > > The only reason to pass the PF's PASID cap is to give free space to
> > > the VMM. If we are saying that gaps are free space (excluding a list
> > > of bad devices) then we don't acutally need to do that anymore.
> > > 
> > > VMM will always create a synthetic PASID cap and kernel will always
> > > suppress a real one.  
> > 
> > oh you suggest that there won't even be a 1:1 map for PF!  
> 
> Right. No real need..
> 
> > kind of continue with the device_feature method as this series does.
> > and it could include all VMM-emulated capabilities which are not
> > enumerated properly from vfio pci config space.  
> 
> 1) VFIO creates the iommufd idev
> 2) VMM queries IOMMUFD_CMD_GET_HW_INFO to learn if PASID, PRI, etc,
>    etc is supported
> 3) VMM locates empty space in the config space
> 4) VMM figures out where and what cap blocks to create (considering
>    migration needs/etc)
> 5) VMM synthesizes the blocks and ties emulation to other iommufd things
> 
> This works generically for any synthetic vPCI function including a
> non-vfio-pci one.

Maybe this is the actual value in implementing this in the VMM, one
implementation can support multiple device interfaces.

> Most likely due to migration needs the exact layout of the PCI config
> space should be configured to the VMM, including the location of any
> blocks copied from physical and any blocks synthezied. This is the
> only way to be sure the config space is actually 100% consistent.

Where is this concern about config space arbitrarily changing coming
from?  It's possible, yes, but vfio-pci-core or a variant driver are
going to have some sort of reasoning for exposing a capability at a
given offset.  A variant driver is necessary for supporting migration,
that variant driver should be aware that capability offsets are part of
the migration contract, and QEMU will enforce identical config space
unless we introduce exceptions.

> For non migration cases to make it automatic we can check the free
> space via gaps. The broken devices that have problems with this can
> either be told to use the explicit approach above,the VMM could
> consult some text file, or vPASID/etc can be left disabled. IMHO the
> support of PASID is so rare today this is probably fine.
> 
> Vendors should be *strongly encouraged* to wrap their special used
> config space areas in DVSEC and not hide them in free space.

As in my previous reply, this is a new approach that I had thought we
weren't comfortable making, and I'm still not very comfortable with.
The fact is random registers exist outside of capabilities today and
creating a general policy that we're going to deal with that as issues
arise from a generic "find a gap" algorithm is concerning.

> We may also want a DVSEC to indicate free space - but if vendors are
> going to change their devices I'd rather them change to mark the used
> space with DVSEC then mark the free space :)

Sure, had we proposed this and had vendor buy-in 10+yrs ago, that'd be
great.  Thanks,

Alex


