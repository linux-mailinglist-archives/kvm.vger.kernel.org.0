Return-Path: <kvm+bounces-23428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EDAB9497AE
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A84DCB2304D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45A657C6D4;
	Tue,  6 Aug 2024 18:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="drLt+mu6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8CF76035
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 18:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722969790; cv=none; b=IVtsdA/woxTfj968QcEm5k5orQ+LwQot4sYRVmRVlfaDokth2aZ/OSq2ZKVFPrx4K3TcJ3NdP8+ow5VdT+u8oy2aEb3VnvpJ50OCxqPf2zDtV1J8AjUxosM8LFUIFWDPy8IoUlqHDYtQFVeyrkyraS2LneuyBJcjpKw9eLldlYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722969790; c=relaxed/simple;
	bh=2oxF99z+HFX2lxqNOaSbzcIm9sIYSg35HEnHHe7HXJU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZB9tKFsVGPBVOwtihiQZk1RoXVOgF493JFhedp08ovdTpCM2mEOEnfmFi6j1xtJfKvntQabcaCHaT8E85J08qkiujsUFA0/R+lz8UPD+pLkssMeADpZAKXodXjaxAfby0KyXAFJX84wSK6Hj8eoZ5Kb8tETBEEA8NKqqqQcBzWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=drLt+mu6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722969787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kw/YgghhKM5KQpSgp9ZypzJ34x1omXhHRLm72XTyDkc=;
	b=drLt+mu6+me2HA5gAgwrcQkwXYLk1Xy98QyyON6ThIoYbg0wj/rX6pl1ai91RxYJFgTjIg
	sPmjMN58xlzC12sDrZJmIlV7wQ3fVmSKDF+pjIWgAKU/3xOq2HXhsshO1d3EquZ5TAtLqo
	N7QSGVLH4nzmf6DRUAwg1NLKOwJ+itI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-mrRyIu-kP16EGab-ECx2Og-1; Tue, 06 Aug 2024 14:43:06 -0400
X-MC-Unique: mrRyIu-kP16EGab-ECx2Og-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39b3c9fdbb6so14428995ab.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 11:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722969785; x=1723574585;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kw/YgghhKM5KQpSgp9ZypzJ34x1omXhHRLm72XTyDkc=;
        b=EwDxCxVSqR1y5hR70u6k3CYA2v0sMexnLin1/Ag+2ZYDMYhASclnVD72wabOR/Nm6H
         QvwCPOop3IwwR/rUkslNleST6bco5jCX8rz7AP9ZH6d4GLiGhhaqgBjgYfoOG0CGZDH4
         n47f0A47W40k0QEqj/w/JddZca70i8MikdarIxEElGMnykkB38ekqGym/XuOlgVqkyiv
         PzkoDy4k1jmhrdNLXZeUi3xkpwVW7NSUQhhISbjWCtxTm24A/rvMXg8GSjuYIP/hk376
         HEhxLO2iS9cv+wTif0Cn29PoozL7GarD6BFtTSljVEN7MtrkZz+MTeul9OtIpPDlG2Jn
         lasQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2y2sJWYYtUWsrBq7IFRzsiYWsynNilx2YC3eiMfBWgSGc+n0/3bL28/HzQWUaj+uB6cZR5yFTrxjKu2UWxIEhiVUC
X-Gm-Message-State: AOJu0Yzugi/RTT/icj0IGufPMizkZP23I1ik7wd+JjJWJbjw2Te9rzM/
	5HO9oZ+ssQt/w8qZWM26qqlqV2go7ajaHNAxn4ZVnowHH9kCwjNqSzRfeGA5eavm7Els6zbrcqN
	MAT0jvdMJIFTvrRwEgASWfzu6Yd8oRbEKowqbua8k+2jgB3OBdDuLqnIJfA==
X-Received: by 2002:a05:6e02:692:b0:374:a781:64b9 with SMTP id e9e14a558f8ab-39b1fb989b1mr176694565ab.13.1722969785311;
        Tue, 06 Aug 2024 11:43:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/FDhaqwm8BjWBhIDKmuPTw1019CGWeJx3jewa5dL3txTck9wUCW6yajbNKnYgTTwzg1uXyg==
X-Received: by 2002:a05:6e02:692:b0:374:a781:64b9 with SMTP id e9e14a558f8ab-39b1fb989b1mr176694365ab.13.1722969784886;
        Tue, 06 Aug 2024 11:43:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c8d6a27808sm2349114173.93.2024.08.06.11.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 11:43:04 -0700 (PDT)
Date: Tue, 6 Aug 2024 12:43:02 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240806124302.21e46cee.alex.williamson@redhat.com>
In-Reply-To: <20240806165312.GI676757@ziepe.ca>
References: <20240801141914.GC3030761@ziepe.ca>
	<20240801094123.4eda2e91.alex.williamson@redhat.com>
	<20240801161130.GD3030761@ziepe.ca>
	<20240801105218.7c297f9a.alex.williamson@redhat.com>
	<20240801171355.GA4830@ziepe.ca>
	<20240801113344.1d5b5bfe.alex.williamson@redhat.com>
	<20240801175339.GB4830@ziepe.ca>
	<20240801121657.20f0fdb4.alex.williamson@redhat.com>
	<20240802115308.GA676757@ziepe.ca>
	<20240802110506.23815394.alex.williamson@redhat.com>
	<20240806165312.GI676757@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Aug 2024 13:53:12 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Aug 02, 2024 at 11:05:06AM -0600, Alex Williamson wrote:
> 
> > > Well, again, it is not a region, it is just a record that this mmap
> > > cookie uses X region with Y mapping flags. The number of regions don't
> > > change. Critically from a driver perspective the number of regions and
> > > region indexes wouldn't change.  
> > 
> > Why is this critical?  
> 
> So we don't leak this too much into the drivers? Why should all the
> VFIO drivers have to be changed to alter how their region indexes work
> just to add a single flag?? 

I don't know how you're coming to this conclusion.  A driver that wants
this new mapping flag needs to do something different but the existing
use case is absolutely unchanged.  Look for example at how the IGD code
in vfio adds several device specific regions.  This doesn't affect
anything other than new code in userspace that wants to iterate these
regions.  It doesn't change the indexes of any of the statically
defined regions.
 
> > > Well, that is just the current implementation. What we did in RDMA
> > > when we switched from hard coded mmap cookies to dynamic ones is
> > > use an xarray (today this should be a maple tree) to dynamically
> > > allocate mmap cookies whenever the driver returns something to
> > > userspace. During the mmap fop the pgoff is fed back through the maple
> > > tree to get the description of what the cookie represents.  
> > 
> > Sure, we could do that too, the current implementation (not uAPI) just
> > uses some upper bits to create fixed region address spaces.  The only
> > thing we should need to keep consistent is the mapping of indexes to
> > device resources up through VFIO_PCI_NUM_REGIONS.  
> 
> I fear we might need to do this as there may not be room in the pgoff
> space (at least for 32 bit) to duplicate everything....

We'll root out userspace drivers that hard code region offsets in doing
this, but otherwise it shouldn't be an issue.  If the collateral is too
large the standard regions can use the fixed offsets and device
specific regions can use dynamic offsets.

> > > My point is to not confuse the pgoff encoding with the driver concept
> > > of a region. The region is a single peice of memory, the "mmap cookie"s
> > > are just handles to it. Adding more data to the handle is not the same
> > > as adding more regions.  
> > 
> > I don't get it.  Take for instance PCI config space.  Given the right
> > GPU, I can get to config space through an I/O port region, an MMIO
> > region (possibly multiple ways), and the config space region itself.
> > Therefore based on this hardware implementation there is no unique
> > mapping that says that config space is uniquely accessible via a single
> > region.    
> 
> That doesn't seem like this sitation. Those are multiple different HW
> paths with different HW addresses, sure they can have different
> regions.
> 
> Here we are talking about the same HW path with the same HW
> addresses. It shouldn't be duplicated.

How does an "mmap cookie" not duplicate that a device range is
accessible through multiple offsets of the vfio device file?

> > BAR can only be accessed via a signle region and we need to play games
> > with terminology to call it an mmap cookie rather than officially
> > creating a region with WC mmap semantics?  
> 
> Because if you keep adding more regions for what are attributes of a
> mapping we may end up with a combinatoral explosion of regions.
> 
> I already know there is interest in doing non-cache/cache mapping
> attributes too.

This sounds like variant driver space, we can't generically create
cachable mappings to MMIO.  vfio-nvgrace-gpu already does this, but
they usurp the standard BAR region, there's no longer uncached access.

> Approaching this as a fixed number of regions reflecting the HW
> addresses and a variable number of flags requested by the user is alot
> more reasonable than trying to have a list of every permutation of
> every address for every combination of flags.

Well first, we're not talking about a fixed number of additional
regions, we're talking about defining region identifiers for each BAR
with a WC mapping attribute, but at worst we'd only populate
implemented MMIO BARs.  But then we've also mentioned that a device
feature could be used to allow a userspace driver to selectively bring
these regions into existence.  In an case, an mmap cookie also consumes
address space from the vfio device file, so I'm still failing to see
how calling them a region vs just an mmap cookie makes a substantive
difference.  Thanks,

Alex


