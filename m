Return-Path: <kvm+bounces-35380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC315A1083A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D22791882397
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 13:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1361C70819;
	Tue, 14 Jan 2025 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ht6yMadm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5164F17557
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736862903; cv=none; b=KqBmKPFB87J7vUV2ru6ujbhvCKawv0nnZrn63CnOmdaJ2k+4yBjtwcFnW6Z0cTtnXF6yrBWA9L8g85Jc/j4cKiXk+kHo9xgQcPxOhSMabUURO2Nr26IXkRcLW4cClaqZJKsAdNyw0jmpGL3JjhIGuQHjykpDM77UWAf47gbzEgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736862903; c=relaxed/simple;
	bh=KQc76jw2yVO1YzP3I6M3XTVo7DV1uXdFjbmr/DPnRL8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8wzPj8Sa8g6VJrXQV5g04aFdF6UxJ4MwPfzh7FIcOz1qqrRrdVrsJDH6Y6X+POS5eju7Q7iju3ODtB+FgI2Lp8UFxhDJQwt614kQ1EQmjhcYSOiZ+hCl1p5lC5ARXZxsF7ktMXBaK3L+z/4SnnWfOwvOOdbIDyPldSmnPNJyCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ht6yMadm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736862900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sPMtOWaxET36PC3zKH8M3ARBY50nMtMjbmhfciNkjD0=;
	b=ht6yMadmkSZNeKvT6hyKqx7udOVuPMPTYMlocDLnf4utLE5h9EqfD1WTyIok/Vf7WAs72G
	Ebm0myGuOI9HoMhhG798x1HYb1EE/C7IwWBptLoDcHfInHdhl/uDfdPX2WOQQ22An9lHtW
	fg+M4enA8IdnXNnRVNWU8jFbD10vWEY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-_nt8QI_MM4iklPgOIrHlGA-1; Tue, 14 Jan 2025 08:54:59 -0500
X-MC-Unique: _nt8QI_MM4iklPgOIrHlGA-1
X-Mimecast-MFC-AGG-ID: _nt8QI_MM4iklPgOIrHlGA
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-84cd123df74so43843839f.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 05:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736862898; x=1737467698;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sPMtOWaxET36PC3zKH8M3ARBY50nMtMjbmhfciNkjD0=;
        b=mC16VGMA7EYQ+bBTWrif5UmwXixQwJPuxpsxDLpWs0QmbFUMDkupwjn4M2NJE5l5UD
         hL+1R7OfVEkDJudxBNDa4eYGLs1zG6LR4j2RHtZOdu/2gFa1RvtbZ9655xkLz7vunl5E
         wwhcGME3pCfsjfj/pF+v44OS2HGTrnWmBEOgBU4DkuYZAuzoHbHwz/G0V0ggtTtH60XU
         c+XT840y6krXl/noYz8CD5jUXEBwWKHbzuvmXgarquhoBoiKeRVs0DAMYscwwgJ8yTey
         aw6NEHeNd9x66Zc9CnGs6t5jZ29xSohPEsirD0a1d0F+OoGW/mj9hqIz4rfghl7N03fy
         rKJA==
X-Forwarded-Encrypted: i=1; AJvYcCVBAiS90Br03YYQdwCEFCeUAZtxIUANhI+zMIea8jctu6ecAjN3iDg9hAYVJOaIT9CwyUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDIG4HRHHsZEQX/L5bTridnGdj2jfOJ3/udpTgJrmWiOJwKVVd
	+888ulO3p/rDrf4ZEpMw4Cf2ZCd1u5wrMOXpx+6tRuNuixQohcWlO8XRWr8UHN1CRrE0EO2Ne9u
	ubKPL80jaxyZFVsUDGBjvEVj23YyYx6o0rHkBOUjUE2awUeoXiQ==
X-Gm-Gg: ASbGnctKXJhBxZzVDMvsmFOHA63hwpuvSDteTT4k4OmIksWUxQHu0ZYVCR5+ZE+F07L
	WrLywJCJIQ7Bp4Cex9GftpNu6WCGG5h8SmPxOgvL/iMawW/opQtnAAIBL8VVNCHlN2HDPaLk+e6
	9xdjP164z88V0+DKnpkSwhaK8yh1L0ZOGoTOqxndMBxHop9ULe0NRUqSywjjYOYPXR7BwxOOLzf
	QMbAKTzbZfgF6b7In6Y7yZ2okwzfIo11+RLzLEBn21aPvTXFu/VSbKGBUEM
X-Received: by 2002:a05:6e02:1f09:b0:3a7:8720:9ded with SMTP id e9e14a558f8ab-3ce3a86b051mr49009015ab.2.1736862898445;
        Tue, 14 Jan 2025 05:54:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtgL8iY7ZCRJa4sPauV5DvThBPPh4mlMgFqmqDoh9/JUdKV2f/oArrE7hAcXlNoOXAHJFgCg==
X-Received: by 2002:a05:6e02:1f09:b0:3a7:8720:9ded with SMTP id e9e14a558f8ab-3ce3a86b051mr49008985ab.2.1736862898111;
        Tue, 14 Jan 2025 05:54:58 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce4adb378asm34022015ab.19.2025.01.14.05.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 05:54:57 -0800 (PST)
Date: Tue, 14 Jan 2025 08:54:43 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: liulongfang <liulongfang@huawei.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linuxarm@openeuler.org"
 <linuxarm@openeuler.org>
Subject: Re: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <20250114085443.17777cb0.alex.williamson@redhat.com>
In-Reply-To: <8225389dd537497c9753cf0a321964e4@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
	<20241219091800.41462-2-liulongfang@huawei.com>
	<099e0e1215f34d64a4ae698b90ee372c@huawei.com>
	<20250102153008.301730f3.alex.williamson@redhat.com>
	<4d48db10-23e1-1bb4-54ea-4c659ab85f19@huawei.com>
	<20250113083441.0fb7afa3.alex.williamson@redhat.com>
	<20250113144516.22a17af8.alex.williamson@redhat.com>
	<80a4e398-ad29-cce8-4a52-ce2a5f6a308c@huawei.com>
	<8225389dd537497c9753cf0a321964e4@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Jan 2025 08:07:43 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: liulongfang <liulongfang@huawei.com>
> > Sent: Tuesday, January 14, 2025 3:18 AM
> > To: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Shameerali Kolothum Thodi
> > <shameerali.kolothum.thodi@huawei.com>; jgg@nvidia.com; Jonathan
> > Cameron <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; linuxarm@openeuler.org
> > Subject: Re: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
> >   
> 
> [...]
> 
> > > @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct  
> > hisi_acc_vf_core_device *hisi_acc_vdev,  
> > >  	int vf_id = hisi_acc_vdev->vf_id;
> > >  	int ret;
> > >
> > > -	vf_data->acc_magic = ACC_DEV_MAGIC;
> > > +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
> > >  	/* Save device id */
> > >  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
> > >
> > > Thanks,
> > > Alex
> > >  
> > >>>
> > >>> As for the compatibility issues between old and new versions in the
> > >>> future, we do not need to reserve version numbers to deal with them
> > >>> now. Because before encountering specific problems, our design may  
> > be redundant.  
> > >>
> > >> A magic value + version number would prevent the need to replace the
> > >> magic value every time an issue is encountered, which I think was
> > >> also Shameer's commit, which is not addressed by forcing the
> > >> formatting of a portion of the magic value.  None of what you're
> > >> trying to do here precludes a new data structure for the new magic
> > >> value or defining the padding fields for different use cases.
> > >> Thanks,
> > >>
> > >> Alex  
> > >  
> > 
> > If we want to use the original magic number, we also need to add the major
> > and minor version numbers. It does not cause compatibility issues and can
> > only reuse the original u64 memory space.
> > 
> > This is also Shameerali's previous plan. Do you accept this plan?  
> 
> The suggestion here is to improve my previous plan.. ie, instead of overloading
> the V2 MAGIC with version info, introduce version(major:minor) separately.
> 
> Something like,
> 
> Rename old MAGIC as MAGIC_V1
> 
> Introduce new MAGIC as MAGIC_V2
> 
> Repurpose any padding or reserved fields in struct vf_data for major:minor
> version  fields. The idea of introducing these major:minor is for future use
> where instead of coming up with a  new MAGIC data every time we can
> increment the version for bug fixes and features if required. 

Yes, there's no suggestion to use the original magic value, that magic
number describes a non-extensible data structure.  As Shameer
indicates, use a new magic value and define within the data structure
specified by that magic value major:minor number and a scheme for
defining compatible (if any) and incompatible updates.  Thanks,

Alex


