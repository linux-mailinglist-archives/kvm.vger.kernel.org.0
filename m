Return-Path: <kvm+bounces-54032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD960B1BA8A
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DA0D18A402F
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8692222D1;
	Tue,  5 Aug 2025 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TbcLPvY9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A30229899A
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420458; cv=none; b=Mvub5uqIX7kzSIY01RPklsc3PTS79SGSV6W6QXSZ5mkekgxCbCfugC4jGFAU8f7BcCf1WI+bgfkbze9EGmrxG18umzfZQ/EOH3qu/99JhTyNFUn4qCFH7o0hX8igVNB4QZWyflY2gWixo2t6rOY+6Z3cZK1tiVh6wCGTFnpvgco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420458; c=relaxed/simple;
	bh=cnhggfrxg+LmkAnoRP6Tbx/2r6He48RRFt0OdLrI7XY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UXO6i6FzBT7GJTdYcHiT+F2zgfLyO7kqzNhprpMrPYD88Y38ch9VAoxR1P0qd3cfEVTQsUJTi0cXT6il33jdbYKZlVpDY6gScCJ516k7cngFP7pF5Sgq5J3EfNhZQ2d2PwDNDJAby3G8GqNyhoDbhuKp+kgVMKIIpMX59Yj6MZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TbcLPvY9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754420451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DR1gLQb5QKjZZb9MJMFgzRChLi/UK4jak0Gji6107DM=;
	b=TbcLPvY9PzI0j1ozHuFFVJz9fdJUy1HXVUfzgjVqPlb3MI6vRb2PJRJA0exDShZb91UJL+
	eXG3ozXH+E161Aos4j+MclvAyymSmGrsZNB1ErwVBOSuBfzNK5FMSyO6D429r0SCiBhUZO
	bN75bQTrq7iUGKZ2e6kGc4MrCLVzlvc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-L1gPUS5SNCCk5lGPLiF9-A-1; Tue, 05 Aug 2025 15:00:50 -0400
X-MC-Unique: L1gPUS5SNCCk5lGPLiF9-A-1
X-Mimecast-MFC-AGG-ID: L1gPUS5SNCCk5lGPLiF9-A_1754420449
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-881333b71a2so19322339f.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:00:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420449; x=1755025249;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DR1gLQb5QKjZZb9MJMFgzRChLi/UK4jak0Gji6107DM=;
        b=OmpQK6024UNjTV/AifSLJQXypuMcbg1swOJXueiNkAGNVOsJVI6oEssRy5hWkCDeaA
         necpP1nBk/69yBHIZ3N1KTk6y33gddVauWKu6/NWBBEijmTWj5UoeXmNwFgmcy5HKZrU
         3/+GmMyx++zONPp+RcxEBRUb5PDWzybe9EAJs4VtOXOODh+pGsfoSyxi9OIHhFNwonia
         DsezmZxrtTWjWMnknMKgW8vWA+d2f0Q5NWHH4FqL7WRUckEiPb6y/vkHrC90yw9cByaF
         NUn+XxZrsYj/w51rpm1f9suFFlQqGnQRK+GnuP5I6Y3mfCsWluLd7U0EBFLuoEEElNxG
         uwQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMFgmEmpVeeSpznyHZaYGO2reCb33YRA7HdtVoRWMvcf6w9lMaTAo+SZJOZDMJSh3P+1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWQWdSb0IoaD6HEpUU+0KW6KLA/mST3jQooh/A+pXWJql53FtA
	MuJnbbDH6E9bFb30sVqx70n9hgnrw2qmEJ37ZgPj4fV3KFemd2ioH+SWQtJyKJkbz6w5lDTmuc1
	M8fCCaBtjC1dFEnM8OZ+cw55YYpopUtpTinHRJ8luQ6AvhXLrvQBtAw==
X-Gm-Gg: ASbGncuWzSUBm3h2wwZBXxIuZBQzZzFp9x3xYsGlWqLXfxh+LX5jaeGzSN2yvceJQJC
	Cj5rfU04BOgZ3yUNSmSbDckDHKsLeudru14CVgrAGJtM70QyMU/YpNdmL7ZOg4T9cDQVTHSDr09
	4KRHx1saJEsZk32NcC/SSJ9uUaZDnilo7rQ0ugPolLb4n3X4FMchzW+Byg7QqvcIk31BD9d/54z
	XJ7pFzEvkfLTi1RQoL+RuKAUsxjLfilv1KtRtiRYJTZk8C5PXULiMy+ngzTpY3G1CTQygwjHvR7
	Lm64Oc5uIUPTHKBkmWHa9dh/Oiq3gsMZe2Oej3BbUdo=
X-Received: by 2002:a05:6e02:480f:b0:3e5:151e:6652 with SMTP id e9e14a558f8ab-3e5151e68abmr11117905ab.2.1754420448964;
        Tue, 05 Aug 2025 12:00:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3wZ2YkWmcZFDNzScuB+LwuQHGH/4VGNvZOPmbdnB6ZILZXRYloyle0co1dZLrw5EMgAtIaw==
X-Received: by 2002:a05:6e02:480f:b0:3e5:151e:6652 with SMTP id e9e14a558f8ab-3e5151e68abmr11117685ab.2.1754420448515;
        Tue, 05 Aug 2025 12:00:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55d55507sm4319653173.70.2025.08.05.12.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:00:47 -0700 (PDT)
Date: Tue, 5 Aug 2025 13:00:46 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, <kvm@vger.kernel.org>,
 <benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
 <pravkmr@amazon.de>, <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250805130046.0527d0c7.alex.williamson@redhat.com>
In-Reply-To: <lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
	<lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
	<lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 5 Aug 2025 17:48:05 +0200
Mahmoud Nagy Adam <mngyadam@amazon.de> wrote:

> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > map2 should not exist, once you introduced a vfio_mmap_ops for free
> > then the mmap op should be placed into that structure.  
> 
> Does this mean dropping mmap op completely from vfio ops? I think we
> could update mmap op in vfio to have the vmmap structure, no?
> 
> > ioctl2 is nasty, that should be the "new function op for
> > VFIO_DEVICE_GET_REGION_INFO" instead. We have been slowly moving
> > towards the core code doing more decode and dispatch of ioctls instead
> > of duplicating in drivers.  
> 
> ack.
> 
> > I still stand by the patch plan I gave in the above email. Clean up
> > how VFIO_DEVICE_GET_REGION_INFO is handled by drivers and a maple tree
> > change will trivially drop on top.
> >  
> 
> but I think also prior of migrating to use packed offsets, we would need
> to fix the previous offset calculations, which means read & write ops
> also need to access the vmmap object to convert the offset.
> 
> 
> 
> Another question is: since VFIO_DEVICE_GET_REGION_INFO will use mt and
> technically will create and return different cookie offset everytime
> it's called for the same region, do we expect that this will not break
> any userspace usage?  I'm not sure but could be that some user usage
> relying on calling the get_region_info to produce the same offset as the
> initial call, instead of caching the region offset for example?

If we're returning a different cookie every time region_info is called
we're already on the wrong track.  Userspace can call region_info an
arbitrary number of times and should get the same offset for the same
region every time.  IMO we need an interface that triggers a new
mapping cookie to be created with specific mmap attributes.  If we're
using region_info then we're dynamically introducing device specific
regions.

I think we're too concerned about this vmmap object, which ought to be
obtained via an offset into the maple tree in place of how we're using
fixed region indexes today.  Some offsets will be pre-populated to
provide the existing regions we have today, optionally those
pre-populated entries may be at compatible offsets for broken
userspaces.  New cookies will be dynamically created alongside.  Thanks,

Alex


