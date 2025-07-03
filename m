Return-Path: <kvm+bounces-51527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0C7AF8337
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 00:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA93A3B9FCA
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 22:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C79298CA1;
	Thu,  3 Jul 2025 22:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iSi5BOwd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE1A1DF985
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 22:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751581057; cv=none; b=UDPil+s4mTmarCWppvXa6a3CpQeMOoMs/BRIkBTw+mPaG8rnrgXSJ5vCgZlTHe0WK5Zu6ZdItkM1C0w32CMcBgVbLJJg8mcRJ4iJgwIkOiElVZAgbws0dDoxp3/vj47caYljGnEOu8BYVtOGTO6D9LVxa+J2s9df9CmLGrb71yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751581057; c=relaxed/simple;
	bh=4ypezCMzqx2m8rAZovbE9cWrKwtdXpCPRYKVPomZyMo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFHIpD49D8wTnew8yhGL5DhCaQ1Hd4s+Ldvw0RmvnmHcX56B2bdriJyAoI/n4F/0qZvO8xyUcYQVg0YATIn0VKs05nqwyxKm+oDQ2X25NXGzwtFRyeUS+F2zm8AoXtCa0o5V7jNAWIEFSjDTkJ62Sccf2BFWVfUZNRy0pJZ4YMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iSi5BOwd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751581053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dsjcnePffsNnJ3iYlPAnCmr2JiGAFkwGmeExoquH+U=;
	b=iSi5BOwdbreZBSgb5XU+o5m0vtZSZfWruOzZTLGWJD8RDMnZz/IuhZsP3ZDBcPZu787dHz
	N3+kXEoDr2Zhx7mltCYv8W80dDC40rZhfcQjBU7kjSo/ImH06xVxR3aPx07/K47EWk98HB
	VgcDSqyVPhCAcNDlLVvMiDuqvfA1H/s=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-9u4ssEeoNIi9k8m_jSDiUw-1; Thu, 03 Jul 2025 18:17:32 -0400
X-MC-Unique: 9u4ssEeoNIi9k8m_jSDiUw-1
X-Mimecast-MFC-AGG-ID: 9u4ssEeoNIi9k8m_jSDiUw_1751581051
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-87373f99cd5so6305539f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 15:17:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751581051; x=1752185851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4dsjcnePffsNnJ3iYlPAnCmr2JiGAFkwGmeExoquH+U=;
        b=Ujgm+R0UxT5TmQ+nCyqse1HpWRr5wm4e5/g5FPQFQvGFU70jQd9T/PV1dCmPGb7kRx
         zaKBF7MBqHwHYDRgMlIV2RoNKqcQfEsLRrIceWYBeA6wpnU9HsaIogjP0Duox7Ryelld
         n9HhHozcuAwFpw5Tm3gkB+SnEV09FbqJK7bmv0LX9ljZ00JS29n7f/CuaaCyMKz7n5wD
         qYorgHYpWp/gxUCFZMAwcYFm+PFdcGmYJYGGuPz2WLbhzNflUiizou6ve/ZQa8jMV6GE
         B134odTCCyXappa/2tqEdpD4KmBDYtlW6aPnS1Rj+ZoaMXV8e7u+NqWnBaYH6RK5fIEV
         rTJA==
X-Forwarded-Encrypted: i=1; AJvYcCVtdDUQfLNaHMxXqu6E8cgPUHoj+FLcooG05jgd3u9ERWOtNktAbxyUWmj6/B1zAVUWpEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDXWsKlaa+pSH9vVzct+s/QYk4Jssw6VBYcJOmHX+lK84CH6bL
	7RxiPXcjxQJKSd9yEdicAaBWE+3wcOrjlxj6+tVZ34byXRk49KudWIklSdkTrDFAyr7GIM5FMYi
	N+/lPmsvnEZPiI/UDIqLVpyz541l0CiDISQ4OcZQ6/A7ew3/yG+ygZg==
X-Gm-Gg: ASbGncuZ1monq2nlgwZZ1ytBdUyisLrjckcShUG2qFATHlFA8V6nXYitIYnmuDPXezT
	jVD4AOdMyQc+oz47bZpkmS7YqXxdHvUpsTcuOnpSpzfBDZTQeOTy42gYCM8L7FZ6roAGGpe6U5q
	SGXpOQIz5w04lGIq9iNoNrLp2UcNNnwRmMtdSRVN8Vf5O1FNSqMSVby5zS5LAf9sD0ey4LA7han
	SEYb41am6CXKCiJ2W36yM8qqUjCZpt1lYRj+1/ORNQDlCFvgfnfPdlQ2oPWVsUdJf9XllZxP/4V
	1RCY34KIExMQcoKG4RPD/BgUqQ==
X-Received: by 2002:a05:6602:1607:b0:864:9c2b:f842 with SMTP id ca18e2360f4ac-876e13a009dmr22655039f.0.1751581051204;
        Thu, 03 Jul 2025 15:17:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHK1hmIX7xtD4BcGg0tZpgeCzpZcsDTIoTx2ZGihjZIL7CUA+/RzY0cwRoZX1T3Wpx/+Vp+hg==
X-Received: by 2002:a05:6602:1607:b0:864:9c2b:f842 with SMTP id ca18e2360f4ac-876e13a009dmr22652739f.0.1751581050636;
        Thu, 03 Jul 2025 15:17:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-503b599c53csm153978173.24.2025.07.03.15.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 15:17:29 -0700 (PDT)
Date: Thu, 3 Jul 2025 16:17:27 -0600
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
Message-ID: <20250703161727.09316904.alex.williamson@redhat.com>
In-Reply-To: <20250703153030.GA1322329@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132859.2a6661a7.alex.williamson@redhat.com>
	<20250703153030.GA1322329@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Jul 2025 12:30:30 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jul 01, 2025 at 01:28:59PM -0600, Alex Williamson wrote:
> > > +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> > > +{
> > > +	struct pci_dev *bridge = bus->self;
> > > +	int type;
> > > +
> > > +	/* Consider virtual busses isolated */
> > > +	if (!bridge)
> > > +		return PCIE_ISOLATED;
> > > +	if (pci_is_root_bus(bus))
> > > +		return PCIE_ISOLATED;  
> > 
> > How do we know the root bus isn't conventional?  
> 
> If I read this right this is dead code..
> 
> /*
>  * Returns true if the PCI bus is root (behind host-PCI bridge),
>  * false otherwise
>  *
>  * Some code assumes that "bus->self == NULL" means that bus is a root bus.
>  * This is incorrect because "virtual" buses added for SR-IOV (via
>  * virtfn_add_bus()) have "bus->self == NULL" but are not root buses.
>  */
> static inline bool pci_is_root_bus(struct pci_bus *pbus)
> {
> 	return !(pbus->parent);
> 
> Looking at the call chain of pci_alloc_bus():
>  pci_alloc_child_bus() - Parent bus may not be NULL
>  pci_add_new_bus() - All callers pass !NULL bus
>  pci_register_host_bridge() - Sets self and parent to NULL
> 
> Thus if pci_is_root() == true implies bus->self == NULL so we can't
> get here.

Yep, seems correct.

> So I will change it to be like:
> 
> 	/*
> 	 * This bus was created by pci_register_host_bridge(). There is nothing
> 	 * upstream of this, assume it contains the TA and that the root complex
> 	 * does not allow P2P without going through the IOMMU.
> 	 */
> 	if (pci_is_root_bus(bus))
> 		return PCIE_ISOLATED;

Ok, but did we sidestep the question of whether the root bus can be
conventional?

> 
> 	/*
> 	 * Sometimes SRIOV VFs can have a "virtual" bus if the SRIOV RID's
> 	 * extend past the bus numbers of the parent. The spec says that SRIOV
> 	 * VFs and PFs should act the same as functions in a MFD. MFD isolation
> 	 * is handled outside this function.
> 	 */
> 	if (!bridge)
> 		return PCIE_ISOLATED;
> 
> And now it seems we never took care with SRIOV, along with the PF
> every SRIOV VF needs to have its ACS checked as though it was a MFD..

There's actually evidence that we did take care to make sure VFs never
flag themselves as multifunction in order to avoid the multifunction
ACS tests.  I think we'd see lots of devices suddenly unusable for one
of their intended use cases if we grouped VFs that don't expose an ACS
capability.  Also VFs from multiple PFs exist on the same virtual bus,
so I imagine if the PF supports ACS but the VF doesn't, you'd end up
with multiple isolation domains on the same bus.  Thus, we've so far
take the approach that "surely the hw vendor intended these to be used
independently", and only considered the isolation upstream from the VFs.
Thanks,

Alex


