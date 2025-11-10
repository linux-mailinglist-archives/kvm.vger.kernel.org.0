Return-Path: <kvm+bounces-62529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0879C48380
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83AFD424727
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9FF31690D;
	Mon, 10 Nov 2025 16:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="TxKlYjN/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2910F2737F3;
	Mon, 10 Nov 2025 16:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762793371; cv=none; b=NQoBM8lupNrM6HXnI8R/Tcx3DQCfOWkdncdUoDZA3jcwyVx8p9mpJSG7hNi7QJOrp0zljT1KBbBx2wcQM/4Qv7Ukb0mu/Pyyu6CJwhTKB3Kk4O3GG+m8/CxneR1gBNP0XvFuxRUj7FRkQhxXSGiBXV7m2WZddFgsltIvVApRQic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762793371; c=relaxed/simple;
	bh=dAg7lV6p38a92584BWoHIvoT+pZ93ZRcc+WXnalEY/I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGB3Bq7q/1hzMJZGKxqzGTdz6C5PrizWqThRph0+N3O6to2kpLzx1RW+QLlPQKhB22yUtnwjilgofOPPndfoKtGBKqQ7INvuTwKvceNn++THNVTnFQt4Xr1pXgo9uyFJOxjRa99e7urxXT4WsM9zaY05OgnMYk0QidriHQYaCok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=TxKlYjN/; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AAFOIKB3199890;
	Mon, 10 Nov 2025 08:49:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=D+PntMDPhPtz0A95s+u1
	swkQIUSc56a8yJ/Neey5cFU=; b=TxKlYjN/GnQHdKrnyJVbKALyyPQezDVH9Xjd
	MIh69kFfgcn9ScSdgwiM+Xc5YXtwqbL3/qVmmny+SkCKIfZ3IbVWAQmWa1sXwQA9
	M21VTOefSTCuhWmee51GLf2WZGwLsa50fVNi/Y2XK5s103vbdiKzhzoRDrR1Z62J
	HznYku6RDTrGScTvEhfjmNNWjEmc9ADR2SH/G1ucHPTHu5/AN0FXZSAmtPqh+fyV
	WLQb6b6MogCerYjbHWltCumcVUqG7weElGpGxzNhusWP6NloSwxVUl5r/xCxBDt0
	VFYAVhVcbHGaLKGfHIhlL6Qr/BormukRVTpPjAgXPMuXL04XTg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4abjnqrune-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 10 Nov 2025 08:49:23 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 10 Nov 2025 16:48:51 +0000
Date: Mon, 10 Nov 2025 08:48:46 -0800
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex@shazbot.org>
CC: David Matlack <dmatlack@google.com>,
        Alex Williamson
	<alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if mapping
 returns -EINVAL
Message-ID: <aRIXboz5X4KKq/8R@devgpu015.cco6.facebook.com>
References: <20251107222058.2009244-1-dmatlack@google.com>
 <aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
 <aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com>
 <20251108143710.318702ec.alex@shazbot.org>
 <aQ/sShi4MWr6+f5l@devgpu015.cco6.facebook.com>
 <20251110081709.53b70993.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251110081709.53b70993.alex@shazbot.org>
X-Proofpoint-ORIG-GUID: Oiga7WGzTg6NXT49QFGeJsRppwyHIy0v
X-Authority-Analysis: v=2.4 cv=RMq+3oi+ c=1 sm=1 tr=0 ts=69121793 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=r1p2_3pzAAAA:8 a=FOH2dFAWAAAA:8 a=-7Oq7wjPLrkyoNOUAdIA:9
 a=CjuIK1q_8ugA:10 a=r_pkcD-q9-ctt7trBg_g:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE0MSBTYWx0ZWRfX7BMpE22kGDB1
 k3hKpd/L27vShvc1uIQrsQpOHcw0ikR6L1JDeV9NquWxiJMfTELVRQ9/i5qT5/hcGSDD27mvyzg
 e1PaVIBRx33pshs7k0Gv6JvT//q0EbCIh0tc1CN66kVE+/FGk/b0MS0A4tb6pxoxNEea6ygFY4t
 140E7gvaavaaqHgZEo+GVQAulgmn9LaTBSjWaVu48HIx4uOBirAABTxzcT3GBSWKeI8H/Ixy1Ve
 JHtWQ0YtnLalczxU200RI3m7UTNtKLvOLJ2fpTCVzJ0Q3E3l4goNkRn66YbaPXTjb41+31/RvPe
 +apQ17hqbqpFv8tN4A/vjC07i9HlELucwqHz+KE07OHBOO9uIHEaxpwhB2YZYunGG3uGyO0B3aF
 7Na9Y94JHEDbSLi0bChRYbnN9hMaIQ==
X-Proofpoint-GUID: Oiga7WGzTg6NXT49QFGeJsRppwyHIy0v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01

On Mon, Nov 10, 2025 at 08:17:09AM -0700, Alex Williamson wrote:
> On Sat, 8 Nov 2025 17:20:10 -0800
> Alex Mastro <amastro@fb.com> wrote:
> 
> > On Sat, Nov 08, 2025 at 02:37:10PM -0700, Alex Williamson wrote:
> > > On Sat, 8 Nov 2025 12:19:48 -0800
> > > Alex Mastro <amastro@fb.com> wrote:  
> > > > Here's my attempt at adding some machinery to query iova ranges, with
> > > > normalization to iommufd's struct. I kept the vfio capability chain stuff
> > > > relatively generic so we can use it for other things in the future if needed.  
> > > 
> > > Seems we were both hacking on this, I hadn't seen you posted this
> > > before sending:
> > > 
> > > https://lore.kernel.org/kvm/20251108212954.26477-1-alex@shazbot.org/T/#u
> > > 
> > > Maybe we can combine the best merits of each.  Thanks,  
> > 
> > Yes! I have been thinking along the following lines
> > - Your idea to change the end of address space test to allocate at the end of
> >   the supported range is better and more general than my idea of skipping the
> >   test if ~(iova_t)0 is out of bounds. We should do that.
> > - Introducing the concept iova allocator makes sense.
> > - I think it's worthwhile to keep common test concepts like vfio_pci_device
> >   less opinionated/stateful so as not to close the door on certain categories of
> >   testing in the future. For example, if we ever wanted to test IOVA range
> >   contraction after binding additional devices to an IOAS or vfio container.
> 
> Yes, fetching the IOVA ranges should really occur after all the devices
> are attached to the container/ioas rather than in device init.  We need
> another layer of abstraction for the shared IOMMU state.  We can
> probably work on that incrementally.
> 
> I certainly like the idea of testing range contraction, but I don't
> know where we can reliably see that behavior.

I'm not sure about the exact testing strategy for that yet either actually.

> > - What do you think about making the concept of an IOVA allocator something
> >   standalone for which tests that need it can create one? I think it would
> >   compose pretty cleanly on top of my vfio_pci_iova_ranges().
> 
> Yep, that sounds good.  Obviously what's there is just the simplest
> possible linear, aligned allocator with no attempt to fill gaps or
> track allocations for freeing.  We're not likely to exhaust the address
> space in an individual unit test, I just wanted to relieve the test
> from the burden of coming up with a valid IOVA, while leaving some
> degree of geometry info for exploring the boundaries.

Keeping the simple linear allocator makes sense to me.

> Are you interested in generating a combined v2?

Sure -- I can put up a v2 series which stages like so
- adds stateless low level iova ranges queries
- adds iova allocator utility object
- fixes end of ranges tests, uses iova allocator instead of iova=vaddr 

> TBH I'm not sure that just marking a test as skipped based on the DMA
> mapping return is worthwhile with a couple proposals to add IOVA range
> support already on the table.  Thanks,

I'll put up the new series rooted on linux-vfio/next soon.

