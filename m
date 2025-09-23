Return-Path: <kvm+bounces-58598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED872B97926
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 23:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B87E2E7977
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 21:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC922741C9;
	Tue, 23 Sep 2025 21:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MNU5+1Zn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C14930C60B
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758663002; cv=none; b=ZUNlc3QWT/lCip7zMLm9CCFgW0jaX3T9jprJcYEQmyLS7W7B+oQcn5U8cIx4AvojJtQ7wQLOAwGUaLUxfOo9MAmoBUK1dDJuqAjtI0ILtU2cQzu+n55DiMpQgyfKUK+VUvruk++xk4FPPEx5wmmw3O0O9pHW05816WIA77LXc0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758663002; c=relaxed/simple;
	bh=diLmI3F9ueElFIp3AVZrlwoYbNK3yJmxfOshhCFqkqA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ix2zl/+YWsVoz5Yki5/WxTfgAXDvJUmiMDfSZC6669Pe7oi7Z53cHO0uv6bque8rLW3LlQkPnpB7A1FcXcc7EzbhFX1uJ36saswcJ6+TNeVsQ/uKRfpxUXpiJkbQY1yDDbqsUO5cfI/3nOadyEmdNxlHDSeGUH4z98pKhzlWHSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MNU5+1Zn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758662999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BXIM6CPTozGtmiCIPPeqmZu4P29aqw7ByjaXAGTyiDo=;
	b=MNU5+1ZnmiuNxMRXXWR88W6eGv/QrfCNNCcL9ELUlfGe3YgRYessLPKeobiGtC8RneWK7M
	9eZxbdUQS2GYU5mRvgH6H+XKOpy7Ew9Q/SdxOxjFnSVNeJrke0MyXsNUMqzm98n4T4BcGi
	bm4NTkWctpF5lxgviqA0iTBqItKuaEg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-qUtTr_ZHMDeruT1oPWKLSQ-1; Tue, 23 Sep 2025 17:29:58 -0400
X-MC-Unique: qUtTr_ZHMDeruT1oPWKLSQ-1
X-Mimecast-MFC-AGG-ID: qUtTr_ZHMDeruT1oPWKLSQ_1758662997
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8935214d60bso141591739f.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 14:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758662997; x=1759267797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXIM6CPTozGtmiCIPPeqmZu4P29aqw7ByjaXAGTyiDo=;
        b=cTWC2YvHC1LrO4JOftvjJRRJEhhkL+hfXbDKFFwRU4mr8nOQZMz0dA01jON+D5Qjfc
         gE9uR7/SmwGwNatWfOEDKMxSCbUENrXxxzX1Al+MCeSL0fytmDvGWJ0pHXRtZxM5Qa07
         Rh9E0aRRAoW5qjKAlh696tG2ckr4XFQk42Vvi6afvEFB3LzeSvAfEZgq4tUjhuKRAmhu
         plPqChTtxZD/JdcCSe+OyfnpbIVy8nRBhSx535ZiPwng9b+AiQv67nMpBUowwtKETr4l
         hRs3XfE3Zk9oqOqXs11lvB8T9reVz1XXWhTSeBPCYZy2TupLcuQIfovkkzUwNTMKO4qL
         6LHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqEJku5Ha2XY9izjbksyPO4becX3B/s765Nwb/1NlHSq42/t+uTIt5R48bkaOf6ncC1Tw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvXrgPpReZsFO4ZVT9xhEorTH2G7nFlOhZ2uZ+oB5X4j68l9RO
	7nn100W3eaxUiu/uEt+sB0iuSbWnfZmFA75ThQa5rIcaugCrlph9mnpOoKxDYx5fUvqbp+d0b3e
	MqOHA43ykXy/1k+yHSGEKtc6kVN35GfsrhKTBTY2SLGISpplX87TbUw==
X-Gm-Gg: ASbGnctuaDtAHJfa/xifncF7KLIEJ+a1zpIZNyimmMLUYeTglfXngVjNdUXfJRL3Agk
	hzhs3TgkKj3nDCYJpPPmwWwbkeRv/tfhh2Tz4/6gydzZdZR2KP84KCEZ7fd7fJvUS/2ZGRDZfRZ
	r73ZiUtgup+C1b7o2dGTvRf5WZdxf3Fh7yn75CxUeQWWZA856eK1enV4E122kUPScDgXmstwcuN
	7yK6JULG8MlpsLQ1KPansYb9ADt9aqAdgNyt01EnZqivkWumtzUx/9Zadrf4itl2M66sAUwuoJl
	MTm+PcaLjpYgO/fXP4tzBO/8Ziq5tLhf8yq44W1f3ZY=
X-Received: by 2002:a05:6e02:b27:b0:423:fd07:d3fe with SMTP id e9e14a558f8ab-42581e0924amr22860025ab.2.1758662997129;
        Tue, 23 Sep 2025 14:29:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFUOBnlXrTOWgoZY/P7THmX3Jn4R3nM9Okb+VwIix6He0SbPySRgexEN+IvhQOjyWjxMklug==
X-Received: by 2002:a05:6e02:b27:b0:423:fd07:d3fe with SMTP id e9e14a558f8ab-42581e0924amr22859855ab.2.1758662996625;
        Tue, 23 Sep 2025 14:29:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4257c9b22afsm25902175ab.26.2025.09.23.14.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 14:29:55 -0700 (PDT)
Date: Tue, 23 Sep 2025 15:29:52 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Donald Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Will Deacon
 <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250923152952.1f6c4b2f.alex.williamson@redhat.com>
In-Reply-To: <20250923130341.GJ1391379@nvidia.com>
References: <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132905.67d29191.alex.williamson@redhat.com>
	<20250702010407.GB1051729@nvidia.com>
	<c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
	<20250717202744.GA2250220@nvidia.com>
	<2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
	<20250718133259.GD2250220@nvidia.com>
	<20250922163200.14025a41.alex.williamson@redhat.com>
	<20250922231541.GF1391379@nvidia.com>
	<20250922191029.7a000d64.alex.williamson@redhat.com>
	<20250923130341.GJ1391379@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Sep 2025 10:03:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 22, 2025 at 07:10:29PM -0600, Alex Williamson wrote:
> > On Mon, 22 Sep 2025 20:15:41 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:  
> > > > The ACS capability was only introduced in PCIe 2.0 and vendors have
> > > > only become more diligent about implementing it as it's become
> > > > important for device isolation and assignment.      
> > > 
> > > IDK about this, I have very new systems and they still not have ACS
> > > flags according to this interpretation.  
> > 
> > But how can we assume that lack of a non-required capability means
> > anything at all??
> >    
> > > > IMO, we can't assume anything at all about a multifunction device
> > > > that does not implement ACS.    
> > > 
> > > Yeah this is all true. 
> > > 
> > > But we are already assuming. Today we assume MFDs without caps must
> > > have internal loopback in some cases, and then in other cases we
> > > assume they don't.  
> > 
> > Where?  Is this in reference to our handling of multi-function
> > endpoints vs whether downstream switch ports are represented as
> > multi-function vs multi-slot?  
> 
> If you have a MFD Linux with no ACS it will group the whole MFD if any
> of it lacks ACS caps because it assumes there is an internal loopback
> between functions.

Yes

> If the MFD has a single function with ACS then only that function is
> removed from the group. The only way we can understand this as correct
> by our grouping definition is to require the MFD have no internal
> loopback. ACS is an egress control, not an ingress control.

Yes, current grouping is focused on creating sets of devices that
cannot perform DMA outside of their group without passing through a
translation agent.  It doesn't account for ingress from other devices.

One of the few examples of this that seems to exist is something like
you're describing where we have a MFD and one of the functions is
quirked or reports an empty ACS capability to create another group.
The ACS/quirk device is believed not to have the capability to DMA into
the non-ACS/quirk devices, but the opposite is not guaranteed.  In
practice the ACS/quirk device is typically the only device that's
worthwhile to assign, so the host is still isolated from the userspace
driver.  Arguably the userspace device may not be isolated from the
host devices, but without things like TDISP, there's already a degree
of trust in other host drivers and devices.

I'm afraid that including the ingress potential in the group
configuration is going to blow up existing groups, for not much
practical gain.  I wonder if there's an approach where a group split in
this way might taint the non-ACS/quirk group to prevent vfio use cases
and whether that would sufficiently close this gap with minimal
breakage.

> If a MFD function is a bridge/port then the group doesn't propogate
> the group downstream of the bridge - again this requires assuming
> there is no internal loopback between functions.

I think that if we have a multi-function root port without ACS/quirks
that all the functions and downstream devices are grouped together.
For a long while this was the typical case on consumer grade hardware,
CPU root ports were multifunction without ACS and we only had
ACS/quirks for chipset-based root ports on such systems.

> It is taking the undefined behavior in the spec and selectively making
> both interpretations at once.

The intention is that undefined behavior should be considered
non-isolated.  We try to define that boundary of a group based on
provable egress DMA.

> > > Assuming the MFD does not have internal loopback, while not entirely
> > > satisfactory, is the one that gives the least practical breakage.  
> > 
> > Seems like it's fixing one gap and opening another.  I don't see that we
> > can implement ingress and egress isolation without breakage.    
> 
> Yeah, either we risk more insecurities or we risk large group sizes.
> 
> > We may need an opt-in to continue egress only isolation.  
> 
> It isn't "egress only isolation" - the thing is I can't really
> articulate what the current rules even fully are..
> 
> I'm not keen on an opt in. I'd rather find some rules we can live
> with.
> 
> How about we answer the question "does this MFD have internal
> loopback" as:
>  - NO if any function has an appropriate ACS cap or quirk.

In this case rather than split the one ACS/quirk function into a group
we split each function into a group.  Now we potentially have singleton
groups for non-ACS/quirk functions that we really have no basis to
believe are isolated from other similar devices.  Currently the poor
grouping of such devices generally deters assignment, narrowing the
exposure.

>  - NO if any function is bridge/port

This would hand-wave away grouping multi-function downstream ports
without ACS/quirks with no justification afaict.

>  - YES otherwise - all functions are end functions and no ACS declared
> 
> As above this is quite a bit closer to what Linux is doing now. It is
> a practical estimation of the undefined spec behavior based on the
> historical security posture of Linux.

It's really not what we're doing now.  We currently consider undefined
behavior to be non-isolated, or we try to.  The above makes broad and
unwarranted (IMO) isolation claims.

> > And hardware vendors are going to volunteer that they lack p2p
> > isolation and we need to add a quirk to reduce the isolation...
> > dynamics are not in our favor.  Hardware vendors have no incentive to
> > do the right thing.   
> 
> They do, otherwise they have major security holes in
> virtualization. In an enterprise setting I have no doubt it is already
> being done right, and has been for a decade.
> 
> I think the above rules will broadly be pessimistic toward add in
> cards and optimistic toward the root complex.

This puts data at risk more so than assuming undefined behavior is
non-isolated.  Currently bad grouping makes it difficult to attach
devices to userspace drivers.  If the bad grouping reaches a
sufficiently high profile and is the result of lack of ACS then we
reach out to the hardware vendor to determine if isolation is actually
present, create quirks if confirmed, and encourage use of ACS to avoid
such problems in the future.  If not confirmed, then the grouping is
unfortunate, users can and do patch their kernel to create overrides,
but they're on their own when they meet unreliable behavior.  I think
this model has been working.

Should we re-evaluate how we handle downstream switch ports exposed as
separate slots, certainly.  Should we consider how to handle a
potential lack of ingress isolation, probably, though we really need a
compelling example.  Should we fundamentally reverse various policies
we've been using for over a decade in determining DMA isolation, IMO no.
Thanks,

Alex


