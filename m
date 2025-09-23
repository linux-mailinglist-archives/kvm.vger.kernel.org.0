Return-Path: <kvm+bounces-58444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D1CB940BA
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 04:50:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D8D818A2BE5
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 02:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71A61C9DE5;
	Tue, 23 Sep 2025 02:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKEgIRsV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9A9199FBA
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 02:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758595835; cv=none; b=tpnNOkan1M+kPUF3Bkmyj5npRI6/3uEhOXbwyXqC4PIsXw2/nBOq/JJOsn/WnWXn/WF30GvJmxQUjvGs9k8Gb4s33dqZUEzqLoPpeVApFqxEhkNfWCAkDJAq85wdudyxg4T8RzAymWeGIDqAOVsVM0lWuBz5SkOQDVpQ/QcSiwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758595835; c=relaxed/simple;
	bh=B5UZq78SmLPBLQDonRYWTTxpdHcXfRxob/mh8nqKjbE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bROHd+SjFiiGDivFQi2zmcV3hNWBIKCLC168ALNBCCYPo42QFvSmcL71wYjPNk2brD4IFv0G3yra5FZ5BONJpMu9uE8wkE9wt05PLxDKOSSM7bQEpuUBARxlPAabFn4KxekjM8Apl2ZDHZ+Ufmt47Xn2ZgSfqo/EFbnmcUTvqxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKEgIRsV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758595833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4udPH4/1Y13/H09/59iHoIfRmw8jUmZ5GDbzFDDZnRs=;
	b=UKEgIRsV0hnK/eMaGiWSUGpkaTxQz3M3jwJtJFMchZs1I9ebMJkzS5dwr1nxj1ggNGcVIz
	kUpTjCZ/INbVm5I6uCNTV2rz8mC4hBotWr9Rvt3itxUq8JrrILlwiy3rQdyW1nJ1Dd17EM
	nropZwOfIEWW6uKXMd4npW94DTA5OUE=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-JSxYmr0cMnqh6jvkvqc24w-1; Mon, 22 Sep 2025 22:50:31 -0400
X-MC-Unique: JSxYmr0cMnqh6jvkvqc24w-1
X-Mimecast-MFC-AGG-ID: JSxYmr0cMnqh6jvkvqc24w_1758595831
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-42571642af9so6647515ab.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 19:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758595830; x=1759200630;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4udPH4/1Y13/H09/59iHoIfRmw8jUmZ5GDbzFDDZnRs=;
        b=k5BC6eMSWx3AxjCu6Q8aN+BXHXSUuVFQDJzrHZX4LFomCb/qhG7aAAQpK5bMZw/gMC
         tm19J1O6OtEbU84eb9udYgb570/d5PkuXAf8sk5mrpTrvr4hnMEfkNR+RBQbOlNM70TL
         YbWC+wo0XyywOHFvFjEodFrM++rHS11OPi1Uu0PwfT8vnUOhWUjAi/sUYv+fvs1iDCNy
         49W86TI/GyzzBRgtvBeHKZWv9GlqE4FuK9xSlbiXaMPsNT8bvOP6lLAGEApCyAFCOBF7
         Bie2k/pKwbUeiBi6wn5jAAEWhsThARcL81JggEP85egsigD2UOoKwhFNOruniIMoi7z4
         0N9A==
X-Forwarded-Encrypted: i=1; AJvYcCWVM6LBiMs1gO0mAIebfCWWvYlzbD4qM2kn/jarMrsTq3BX/Nybw4zmNLu9mfevo19UYXM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl20E+KN0k+C37vHHxpGvO/Nl2Gq8lxp5Aa+YGipgrjOcY6mv5
	noTKPqsVni7hPmH/q76XuBH6SNFJi/oRWmiVyNKXjvNuXtAXKlgrIgGICHux8TxReTkAqH5mo4c
	UaKYO1EPqXK8/FhZrJnNowGpDazsYtTxgf3Pq/BGKcZGPfEwJXMztqw==
X-Gm-Gg: ASbGncvuoxMAtHqHBTJP3E9969XKq62SPs0hYXTUWXOt78KrLnsC7Y+m4sk1xsZKXEl
	+IvvYqOI+L1MexG+NkcZVPLv1GWwZBMJcTVFF/TfqQUn4OGkZ7T40cCtgAwJbng6pUHcWABEOyh
	cPbqxACvGxnsrweeTc7Pqy0+cbmaDSCtPvHHFDzdlLY1lMIQ4+9kzvVGTGl+EHVaSKNI3TEdmvp
	5XiSxbEu8O+OxAoJcqrB2xMFv6gt8djd5c8otr8G9BK0ByVi+aa9avgi3gYdTiSqp1HHHN83Qzh
	+GTL5aAdnGDmRREbZBk2CjLQHLU2pfyfrQzCYhA1iQQ=
X-Received: by 2002:a05:6e02:164d:b0:424:2357:d5e with SMTP id e9e14a558f8ab-42581ea6a8emr6488285ab.4.1758595830505;
        Mon, 22 Sep 2025 19:50:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoQrJ13c3z3iAGYF/0szcdLw1mCi6EExZIWeSbCSUNM58sLO+eFzEGXdLrV3LqCv/AG2p4nA==
X-Received: by 2002:a05:6e02:164d:b0:424:2357:d5e with SMTP id e9e14a558f8ab-42581ea6a8emr6488055ab.4.1758595829980;
        Mon, 22 Sep 2025 19:50:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d401eea19sm6445439173.34.2025.09.22.19.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 19:50:29 -0700 (PDT)
Date: Mon, 22 Sep 2025 20:50:27 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Will Deacon
 <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250922205027.229614fa.alex.williamson@redhat.com>
In-Reply-To: <066e288e-8421-4daf-ae62-f24e54f8be68@redhat.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132905.67d29191.alex.williamson@redhat.com>
	<20250702010407.GB1051729@nvidia.com>
	<c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
	<20250717202744.GA2250220@nvidia.com>
	<2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
	<20250718133259.GD2250220@nvidia.com>
	<20250922163200.14025a41.alex.williamson@redhat.com>
	<20250922231541.GF1391379@nvidia.com>
	<20250922191029.7a000d64.alex.williamson@redhat.com>
	<066e288e-8421-4daf-ae62-f24e54f8be68@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 22:26:26 -0400
Donald Dutile <ddutile@redhat.com> wrote:

> On 9/22/25 9:10 PM, Alex Williamson wrote:
> > On Mon, 22 Sep 2025 20:15:41 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> >> On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:  
> >>> The ACS capability was only introduced in PCIe 2.0 and vendors have
> >>> only become more diligent about implementing it as it's become
> >>> important for device isolation and assignment.  
> >>
> >> IDK about this, I have very new systems and they still not have ACS
> >> flags according to this interpretation.  
> > 
> > But how can we assume that lack of a non-required capability means
> > anything at all??
> >     
> ok, I'll bite on the the dumb answer...
> lots of non-support is represented by lack of a control structure.
> ... should we assume there are hidden VFs b/c there is a lack of a vf cap structure?
> ... <insert your favorite dumb answer here> :-)

This is not how an additive specification works.  We start with a base
specification.  We add capabilities to describe features of the device.
If a device doesn't support an SR-IOV capability, it doesn't support
VFs.  But likewise we cannot add an optional capability and
retroactively declare that anything that does not support this
capability must have some specific behavior.

That's not what the spec is doing.  We're misinterpreting it.  The
sections of the spec you're quoting are saying that if a MFD function
supports ACS it must support this specific p2p set of capability and
control bits unless the device does not support internal p2p.

> I can certainly see why a hw vendor would -not- put a control structure
> into a piece of hw that is not needed, as the spec states.
> For every piece of hw one creates, one has to invest resources to verify
> it is working correctly, and if verification is done correctly, verify it
> doesn't cause unexpected errors.  I've seen this resource req back in
> my HDL days (developers design w/HDL; hw verification engineers are the
> QE equivalent to sw, verifying the hw does and does not do what it is spec'd).

As previously noted, an "empty" ACS capability serves this purpose with
minimal verification.

> Penalizing a hw vendor for following the spec, and saving resources,
> seems wrong to me, to require them to quirk their spec-correct device.

IMO, we're clearly conflating the implementation of the ACS p2p
capability bits with the implementation of the ACS extended capability
itself.

> I suspect section 6.12.1.2 was written by hw vendors, looking to reduce
> their hw design & verification efforts.  If written by sw vendors, it
> would have likely required 'empty ACS' structs as you have mentioned in other thread(s).

We've had NIC vendors implement an empty ACS capability to convey the
fact that the device does not support internal p2p.  There is precedent
for the interpretation I'm describing.

> >>> IMO, we can't assume anything at all about a multifunction device
> >>> that does not implement ACS.  
> >>
> >> Yeah this is all true.
> >>
> >> But we are already assuming. Today we assume MFDs without caps must
> >> have internal loopback in some cases, and then in other cases we
> >> assume they don't.  
> > 
> > Where?  Is this in reference to our handling of multi-function
> > endpoints vs whether downstream switch ports are represented as
> > multi-function vs multi-slot?
> > 
> > I believe we consider multifunction endpoints and root ports to lack
> > isolation if they do not expose an ACS capability and an "empty" ACS
> > capability on a multifunction endpoint is sufficient to declare that
> > the device does not support internal p2p.  Everything else is quirks.
> >   
> >> I've sent and people have tested various different rules - please tell
> >> me what you can live with.  
> > 
> > I think this interpretation that lack of an ACS capability implies
> > anything is wrong.  Lack of a specific p2p capability within an ACS
> > capability does imply lack of p2p support.
> >   
> >> Assuming the MFD does not have internal loopback, while not entirely
> >> satisfactory, is the one that gives the least practical breakage.  
> > 
> > Seems like it's fixing one gap and opening another.  I don't see that we
> > can implement ingress and egress isolation without breakage.  We may
> > need an opt-in to continue egress only isolation.
> >   
> >> I think it most accurately reflects the majority of real hardware out
> >> there.
> >>
> >> We can quirk to fix the remainder.
> >>
> >> This is the best plan I've got..  
> > 
> > And hardware vendors are going to volunteer that they lack p2p
> > isolation and we need to add a quirk to reduce the isolation... the
> > dynamics are not in our favor.  Hardware vendors have no incentive to
> > do the right thing.  Thanks,
> >   
> I gave an example above why hw vendors have every incentive not to
> add an ACS structure if they don't need it. Not doing so, when they
> can do p2p, is a clear PCIe spec violation.  Punishing the correct
> implementations for the incorrect ones is not appropriate, and is
> further incentive to continue to be incorrect.
> 
> Don't we have the hooks with kernel cmdline disable_acs_redir &
> config_acs params to solve the insecure cases that may (would) be
> found, so breaking the isolation is relatively easy to fix vs adding
> quirks as is done today for proper spec interpretation?

Are we going to expect users to opt-in to securing their system?  This
is just doubling down on an incorrect spec interpretation.  Lack of an
optional extended capability cannot convey anything about the p2p
capabilities of the device <full stop>.  Thanks,

Alex


