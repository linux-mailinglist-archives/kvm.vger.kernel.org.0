Return-Path: <kvm+bounces-23572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB1994AF14
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 19:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 575D31F22BD9
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCA913D25E;
	Wed,  7 Aug 2024 17:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NhX/jk+f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E685380BEC
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 17:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723052810; cv=none; b=ngCvn0S22IeERIStvTabZ82QgZ1sW6DdPKKqxvWf0dvyzUmHbDJ4YLth2TVIpxUV2d38tN083k+kOHGAKRbOLpzlUBR4DULxHo+QNnZ8YLWh94EjmqQPMXVwAXgnnk5LxZtPAYwRCUSl/NndCuBTUGwphQwsQTwrfdUfg+XnZqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723052810; c=relaxed/simple;
	bh=tBykNAuBPyy1WPky7FqfwSDNeIzKosKeBA1Anwc/aFs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=el09n3G9o8JnasGKCF27yhDn5fV+0W3USiGVicucYA8B2YrMVc6evZhudvNcTrxQm3QMvluyO6vPDbIb757UDSwhj+IRpiHzVpI7MJG4FDAQmpI1lJDyO4oRPH9evwriFK8J9BcWa5jt2Dm15w3LGyadl+lN0ktF8Ikmg0mr2dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NhX/jk+f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723052807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sqBUhoCsiwtEvMBG/ekNtdIPOgeD2xXknFdG+i+Qp1Y=;
	b=NhX/jk+flHiTiViMB+Bih2ICi0DIP+TwOAvSlrGEbSrJKQHEGJOp7IsYBYbgpqdV6oWBEN
	V5kn5LVweqBbxIhm2LZ9cfE0JVici8M9q8XuHgr3T6EFickxzMC37y7dhVAQBVvWfb3XJP
	W/1oJozmwYOqOp4ZPmAYLm6sMpM5zhU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-M-RzrV6aP5m2e-YCmtxx-g-1; Wed, 07 Aug 2024 13:46:46 -0400
X-MC-Unique: M-RzrV6aP5m2e-YCmtxx-g-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81d1b92b559so7203139f.0
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 10:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723052806; x=1723657606;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sqBUhoCsiwtEvMBG/ekNtdIPOgeD2xXknFdG+i+Qp1Y=;
        b=AsGYq0WnnZ0sydVrhqvV5E/rKvR8kZ3J6Xlm4mZtEXvvaBCdffhFNi2rcNyKhSWc+2
         xgXdICr8FnRGDvK6+cAhhq8tf9oy2UPwyiJ7ZbvPs5XqXDRhUUVJVRKIydUWX5gJj2xM
         IeNzLyj7kgaQzlrVZz9LVs3ckwsGPLlTTPDdyADnIUbdUrDINJyY+H7EGV0+oSson3Jf
         xEIAOQ09ZXlrjcX85VOZiT2eNNMKujGVGOoZGcDWPGcpy2hUobt2uzH+HIqt5GTZC1DL
         R0CZtW06hTOp5JceAHa1mUFMH0YGM/iUgvVIV/5e9GQ/dNlmuZb9VXjhAmmqPDFdvAC+
         5cbw==
X-Forwarded-Encrypted: i=1; AJvYcCWSfx/CdUQ2WzVjXx1jOEvsiTJYVk6mi44KaAQS3TF0DhQRbtz5bh3cg4JejJkTGc4Zutj8Iodvnnxqme4ktUPtbJ5n
X-Gm-Message-State: AOJu0YwVUjP0YrBMXNzeJ2+tFs4JvE2gwyHD3dHzCLsGkjNoogTMlpsw
	v3IB4tI0KfXaG2lfDVQPqFevwJqLFs5Bl8Rzg8uemVIQF4H8KsetKO17VnDOyybORMW3PQZ+HYf
	qB67t7KV9UGGGLmZQbdS4q3UAkM+/40SphPEoyOn01u7ucVaElVi1+Weehg==
X-Received: by 2002:a05:6602:13c4:b0:7f9:b435:4f5 with SMTP id ca18e2360f4ac-81fd43d3b69mr2333299139f.11.1723052805818;
        Wed, 07 Aug 2024 10:46:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFr7fERwlYL8DWgMs/vZZQFQ+k6FXm79+VA1SwsMmyL/Sa2snRI61bt2Iha/f32kH7PNpE/bA==
X-Received: by 2002:a05:6602:13c4:b0:7f9:b435:4f5 with SMTP id ca18e2360f4ac-81fd43d3b69mr2333296739f.11.1723052805412;
        Wed, 07 Aug 2024 10:46:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c8d69880bfsm2864628173.36.2024.08.07.10.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 10:46:44 -0700 (PDT)
Date: Wed, 7 Aug 2024 11:46:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240807114643.25f78652.alex.williamson@redhat.com>
In-Reply-To: <20240807141910.GG8473@ziepe.ca>
References: <20240801161130.GD3030761@ziepe.ca>
	<20240801105218.7c297f9a.alex.williamson@redhat.com>
	<20240801171355.GA4830@ziepe.ca>
	<20240801113344.1d5b5bfe.alex.williamson@redhat.com>
	<20240801175339.GB4830@ziepe.ca>
	<20240801121657.20f0fdb4.alex.williamson@redhat.com>
	<20240802115308.GA676757@ziepe.ca>
	<20240802110506.23815394.alex.williamson@redhat.com>
	<20240806165312.GI676757@ziepe.ca>
	<20240806124302.21e46cee.alex.williamson@redhat.com>
	<20240807141910.GG8473@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Aug 2024 11:19:10 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Aug 06, 2024 at 12:43:02PM -0600, Alex Williamson wrote:
> 
> > > So we don't leak this too much into the drivers? Why should all the
> > > VFIO drivers have to be changed to alter how their region indexes work
> > > just to add a single flag??  
> 
> > I don't know how you're coming to this conclusion.  
> 
> Ideally we'd want to support the WC option basically everywhere.
> 
> > > I fear we might need to do this as there may not be room in the pgoff
> > > space (at least for 32 bit) to duplicate everything....  
> 
> > We'll root out userspace drivers that hard code region offsets in doing
> > this, but otherwise it shouldn't be an issue.  
> 
> The issue is running out of pgoff bits on 32 bit. Maybe this isn't an
> issue for VFIO, but it was for RDMA. We needed tight optimal on-demand
> packing of actual requested mmaps. Allocating gigabytes of address
> space for possible mmaps ran out of pgoff bits. :\

If we only implemented WC for 64-bit, would anyone notice?
 
> > How does an "mmap cookie" not duplicate that a device range is
> > accessible through multiple offsets of the vfio device file?  
> 
> pgoff duplcation is not really an issue, from an API perspective the
> driver would call a helper to convert the pgoff into a region index
> and mmap flags. It wouldn't matter to any driver how many duplicates
> there are.

Which is exactly my point whether we call it a region or an mmap
cookie.  In one case we're trying to give a bare pgoff that effectively
aliases to a region with different mapping flags, in the other the
pgoff is exposed through a new region offset that does exactly the same
thing.

> > Well first, we're not talking about a fixed number of additional
> > regions, we're talking about defining region identifiers for each BAR
> > with a WC mapping attribute, but at worst we'd only populate
> > implemented MMIO BARs.  But then we've also mentioned that a device
> > feature could be used to allow a userspace driver to selectively bring
> > these regions into existence.  In an case, an mmap cookie also consumes
> > address space from the vfio device file, so I'm still failing to see
> > how calling them a region vs just an mmap cookie makes a substantive
> > difference.  
> 
> You'd only allocate the mmap cookie when userspace requests it.

I've suggested a mechanism using DEVICE_FEATURE that could do this for
regions.

> My original suggestion was to send a flag to REGION_INFO to
> specifically ask for the different behavior, that (and only that)
> would return new mmap cookies.

Which can't work because flags is only an output field.

> The alternative version of this might be to have a single
> 'GET_REGION_MMAP' that gives a new mmap cookie for a singular
> specified region index. Userspace would call REGION_INFO to learn the
> memory regions and then it could call GET_REGION_MMAP(REQ_WC) and will
> get back a single dynamic mmap cookie that links the WC flags.
> 
> No system call, no cookie allocation. Existing apps don't start seeing
> more regions from REGION_INFO. Drivers keep region indexes 1:1 with HW
> objects. The uAPI has room to add more mmap flags.

Please tell me how this is ultimately different from invoking a
DEVICE_FEATURE call to request that a new device specific region be
created with the desired mappings.  In the short term, if we run out of
pgoff, the user gets an -ENOSPC.  DEVICE_INFO is updated with the new
number of regions, existing region indexes are unchanged, the user
iterates new indexes with REGION_INFO to get the offset and identifies
them using the previously proposed region types.  Thanks,

Alex


