Return-Path: <kvm+bounces-51528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D4B5AF8400
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 01:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6ED08560144
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 23:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD102D8DA5;
	Thu,  3 Jul 2025 23:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+NaAca2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CC52D46AD
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 23:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751584134; cv=none; b=LF2Dfkr8O++Us1A2kfYVk2rwKDweOb39umf/r+2JL3mTAf90gUViQ3I9AUTson20kVBBcM7WcOJFd3ilGUyuNA0Pz2k+OcAwoHzkLPHf3ASaC9jvXdpCzcyjneguFNdYaAnKMvGLRxSBAogshuIg/HT72rXolMkswfOaWpgU5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751584134; c=relaxed/simple;
	bh=kL2COggKRi2MMcxxxXVitt/0SKh/NzBOsX4IqvP2l1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RHwqWevJ8EGsPFP1fznRKK9QY2t6cNEIahmMUGZ22XOUGHJn3a1lJINRjVsK4b5hJ0e00/nP4HIRJO4Igac4KhBMcvK0zFyl/Oi7uTKf1oJS0jBPePgggjxed5pzMhi0Ek3DZkfeLPyaM/7jq2jg99cqF0xWrpgxklMXe4rfupU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c+NaAca2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751584130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YING2rD+/FRmd+v26pZBtJAEWyYAk3xy5D8dkgpzl4=;
	b=c+NaAca2ST3tJzPSQ1l14kIqNrBo8R3juBPcif8i1eUUaZ16+bTs4xiVa35gcKOaJEnAcW
	Dk0alyE5/EMm8PViHkpA3jkY2Thgh0YtAZ7r/KTO+e3o+iD8CdUstQgBR+KYkMqnV49gjB
	Sm77S+T8014uzrGNYqn2oGpp1RMRsxw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-hlIpnzJFOzu7x9Pjp5LPZQ-1; Thu, 03 Jul 2025 19:08:49 -0400
X-MC-Unique: hlIpnzJFOzu7x9Pjp5LPZQ-1
X-Mimecast-MFC-AGG-ID: hlIpnzJFOzu7x9Pjp5LPZQ_1751584129
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ddd689c2b8so770475ab.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 16:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751584129; x=1752188929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YING2rD+/FRmd+v26pZBtJAEWyYAk3xy5D8dkgpzl4=;
        b=AtYsf3I0B1tYcYr/UJBgZRtETYF8ViLmN+ceqUCu5g8WTXOZCsPLSGlnu778hGbfvk
         WK7fx+bN2dDy4C+TBwmtlkehYa5A8GyHbMpvxyy7edjX5QvKBBfn69l++7lFyuMROaLl
         y6o2haNa+VEjnlkVV8B+f1FbQDC1RKxJ1qWrKaiIe19Af0tVri11uAs7w/fM1LcobTgN
         WnjeAv6Hw0O5vlC4vYYMVzZYJfyosM4TxputpSbuVJmulQVyTif12WsiwhdmeOXasEB1
         HY93zJb0Ui8qUdOnr5g/BzCMPzn6kt1829strgelLJCsfMjWW0UOBmSwiyOl/bmFcb4l
         daYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqgwZuAZLnL4NxPSIgPZdtILauaHPcZfLAoZ7k5oBMqpFWI4GskX0N7q7hu2Mr0CSiANk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzE0/U/EZPcHA0MEm0fOZcvtW5olU9kDreHRcDZZN+dYNgbU1j6
	cppiJhYsflwhT1RxfbIZXSYe1U/jFQ1yN2h6BhKTZfpxQ2bcO/R8BFmVIr8BGGmEQJ9u536/5TS
	Y/kpiV8Qtc2hVYrH81qWXTT9ZuXDMj8zyeIGaga+vD8WHB/O+YbmAsw==
X-Gm-Gg: ASbGncscj7B6tw5KQokOqn9QKiZhb2EUk1LQLRwbYZwAlLVsYJ2ax12d5g3rfZoWgYJ
	q3HlgzjID/O5QMPx+w5NroBhPz38JsU2kJur/mOGh8Yu8m6kFfAGhC+gXtDqC0cZagHZ8I15/2Z
	3hlTKVxTQ32sQn+Io+ekS8mKxAHWXfBFHY/rOlctYlve5xXw4UEpEG9Dv7uyYglAmF9o8RFyuLK
	6IfgM4QDXxJO2JrkJSf6IR5RGnAfPTJdLEgY1Ift8VnlU0I/6a5wm2fZyIEcACz12R0JnjgrSBB
	SWDQxptEtUFUrsvWDYx0o72ZkA==
X-Received: by 2002:a05:6e02:1f12:b0:3dc:8075:ccb0 with SMTP id e9e14a558f8ab-3e135583c90mr940685ab.3.1751584128947;
        Thu, 03 Jul 2025 16:08:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZXOkCizG+2QD0k3c4R9Q17zYhNsPo1zPJTd155GX4jed8qYJ0mWeqGMBx7xHtV3Apq5n84w==
X-Received: by 2002:a05:6e02:1f12:b0:3dc:8075:ccb0 with SMTP id e9e14a558f8ab-3e135583c90mr940495ab.3.1751584128553;
        Thu, 03 Jul 2025 16:08:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e0fe22116bsm2415475ab.38.2025.07.03.16.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 16:08:47 -0700 (PDT)
Date: Thu, 3 Jul 2025 17:08:46 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, galshalom@nvidia.com, Joerg Roedel
 <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu
 <tony.zhu@intel.com>
Subject: Re: [PATCH 02/11] PCI: Add pci_bus_isolation()
Message-ID: <20250703170846.2aa614d1.alex.williamson@redhat.com>
In-Reply-To: <20250703161727.09316904.alex.williamson@redhat.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132859.2a6661a7.alex.williamson@redhat.com>
	<20250703153030.GA1322329@nvidia.com>
	<20250703161727.09316904.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Jul 2025 16:17:27 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 3 Jul 2025 12:30:30 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jul 01, 2025 at 01:28:59PM -0600, Alex Williamson wrote:  
> > > > +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> > > > +{
> > > > +	struct pci_dev *bridge = bus->self;
> > > > +	int type;
> > > > +
> > > > +	/* Consider virtual busses isolated */
> > > > +	if (!bridge)
> > > > +		return PCIE_ISOLATED;
> > > > +	if (pci_is_root_bus(bus))
> > > > +		return PCIE_ISOLATED;    
> > > 
> > > How do we know the root bus isn't conventional?    
> > 
> > If I read this right this is dead code..
> > 
> > /*
> >  * Returns true if the PCI bus is root (behind host-PCI bridge),
> >  * false otherwise
> >  *
> >  * Some code assumes that "bus->self == NULL" means that bus is a root bus.
> >  * This is incorrect because "virtual" buses added for SR-IOV (via
> >  * virtfn_add_bus()) have "bus->self == NULL" but are not root buses.
> >  */
> > static inline bool pci_is_root_bus(struct pci_bus *pbus)
> > {
> > 	return !(pbus->parent);
> > 
> > Looking at the call chain of pci_alloc_bus():
> >  pci_alloc_child_bus() - Parent bus may not be NULL
> >  pci_add_new_bus() - All callers pass !NULL bus
> >  pci_register_host_bridge() - Sets self and parent to NULL
> > 
> > Thus if pci_is_root() == true implies bus->self == NULL so we can't
> > get here.  
> 
> Yep, seems correct.
> 
> > So I will change it to be like:
> > 
> > 	/*
> > 	 * This bus was created by pci_register_host_bridge(). There is nothing
> > 	 * upstream of this, assume it contains the TA and that the root complex
> > 	 * does not allow P2P without going through the IOMMU.
> > 	 */
> > 	if (pci_is_root_bus(bus))
> > 		return PCIE_ISOLATED;  
> 
> Ok, but did we sidestep the question of whether the root bus can be
> conventional?
> 
> > 
> > 	/*
> > 	 * Sometimes SRIOV VFs can have a "virtual" bus if the SRIOV RID's
> > 	 * extend past the bus numbers of the parent. The spec says that SRIOV
> > 	 * VFs and PFs should act the same as functions in a MFD. MFD isolation
> > 	 * is handled outside this function.
> > 	 */
> > 	if (!bridge)
> > 		return PCIE_ISOLATED;
> > 
> > And now it seems we never took care with SRIOV, along with the PF
> > every SRIOV VF needs to have its ACS checked as though it was a MFD..  
> 
> There's actually evidence that we did take care to make sure VFs never
> flag themselves as multifunction in order to avoid the multifunction
> ACS tests.  I think we'd see lots of devices suddenly unusable for one
> of their intended use cases if we grouped VFs that don't expose an ACS
> capability.  Also VFs from multiple PFs exist on the same virtual bus,
> so I imagine if the PF supports ACS but the VF doesn't, you'd end up
> with multiple isolation domains on the same bus.  Thus, we've so far
> take the approach that "surely the hw vendor intended these to be used
> independently", and only considered the isolation upstream from the VFs.

BTW, spec 6.0.1, section 6.12:

  For ACS requirements, single-Function devices that are SR-IOV capable
  must be handled as if they were Multi-Function Devices, since they
  essentially behave as Multi-Function Devices after their Virtual
  Functions (VFs) are enabled.

Also, section 7.7.11:

  If an SR-IOV Capable Device other than one in a Root Complex
  implements internal peer-to-peer transactions, ACS is required, and
  ACS P2P Egress Control must be supported.

The latter says to me that a non root complex SR-IOV device that does
not implement ACS does not implement internal p2p routing.  OTOH, the
former seems to suggest that we need to consider VFs as peers of the
PF, maybe even governed by ACS on the PF, relative to MF routing.  I'm
not really finding anything that says the VF itself needs to implement
ACS.  Thanks,

Alex


