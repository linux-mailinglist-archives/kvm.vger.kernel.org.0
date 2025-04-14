Return-Path: <kvm+bounces-43279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBCF5A88CED
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 22:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E4C11899161
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 20:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6436D19048A;
	Mon, 14 Apr 2025 20:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OSxdxWY/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14391C6FF6
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 20:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744661752; cv=none; b=G3pbWm7Hyh4V46MW13n1XLQt1199AX0evwUU7nrKwu8uvcoBc3B/oZNQnWSZTFIftukQBf/a1hq/K6ipvm9VlY0VOCn08TIjd1HPfEAR3pmRa73RoYW/azmQAFbysPoiH2N+1L0vDOk32LpzH1er0ZdHIgb68q4N60zKup+2Fgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744661752; c=relaxed/simple;
	bh=LbhbCo+zbVvMZaZ4UPNWEgaPM3+UBAl8LfeZaHYhc+w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ibdgez1zJxgnRhBTKklmYe8hkU+M2ngMNLFtauvIzLCf4ZN2G0r8CqKWLVOCsy4ECEeU0DIvB1kM0aGquz9TaOuusMZ1OrxlQ48wOC0RbcivrjkpZwG5EmMnfumMK9UjKrzEgBmhvcTfBXND8lOYIi0xwnu5g+eZj4aD2zNQBbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OSxdxWY/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744661749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=67wq8uX0UDI4+mNd83RsPzYK7yn9VdDdlik8w849lpc=;
	b=OSxdxWY/qYtBYWDG2q+CUQ+AGZvCHStCAFNDFruoCrO7cC2vpTPv749HGDBqYV4zX501uq
	32H4uVtei9XbwoqMVim4Hmmcc2uslGe+kRC1zttueNdMFylrKMf4O0RdJ1cCU7FfAYSyKD
	IjGP0RyfSmyxGyN3qjwqQaQnY1sFyoI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-MRajD7-qN16ZaNGqPnC7XA-1; Mon, 14 Apr 2025 16:15:48 -0400
X-MC-Unique: MRajD7-qN16ZaNGqPnC7XA-1
X-Mimecast-MFC-AGG-ID: MRajD7-qN16ZaNGqPnC7XA_1744661748
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85b5c68c390so51574639f.0
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 13:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744661747; x=1745266547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67wq8uX0UDI4+mNd83RsPzYK7yn9VdDdlik8w849lpc=;
        b=DEOzCSROD2jjfH4QabWGIqdOG29KmSAkmK+oOYX8d2mZqZs2tPie4wsVlZ+Qap1Mip
         uV9NHYOO8YGiQWeXbDMLlMBvP7HSyHU90g2au08O0E/CjrsRFrK33aWxsKUZ4Bu3G6eV
         uKus2Rh8WRdMulan5ZC9v//rJ+O7c2ciM0aA+uuh3sSsmziLVeSwvPDNGtFHXnFFYMHP
         KULiNEDYD4H6Xf3/PGjaosdEMiKTFHSkkGbm20IxS8u0DJVYm3UYwgn3mgLJqtyY5UXj
         D57Mz6epT93Ofz4g0n50b8oj8GqUxvnhvI0ZQS3G7UgcLzvk1ZvRM6qbOfj/H9dfmcQ1
         6qTg==
X-Forwarded-Encrypted: i=1; AJvYcCVqPNg6oAAYdReXv0iqp2OJXchdbWDvxUQtluM3cpOik6EmhdDLsLlxBaXvGT6Jbqq0hNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJEdd1r00LktG6KQ3SbUspuRwzpSa1g11yCw5oyEYzLm47cLol
	jVgYlTDQePn7lbjNaQL08Y9CqSYrn/j+cNgyOmKSVKLSfHzU6EuML0JjjJ0P52iCi1obqezvHY1
	9+4b9JUxi4wFSJa1pvUop3quQRTuPK4Ux7D/uWQhBC14RKIfbsg==
X-Gm-Gg: ASbGncuixwiQBFWhlkz1zpLAfPvUHY0PVmeGa8zcxut/89ReBt1wmXUZzGXsLqUOQjA
	NctZDAF2dqUYetHqMztjddkqieomkb16BY4ap5S0LJKaijsNktzXiER6gzyWUaODlJ73N5BBTYw
	SdUuhp//egjTYPYVDIm9L1DAgs/g5ecE8u8wlbdfQwMiXED0Dl+R9qmuDUftEhnn7z6stl/LWjj
	lxS5XumfGB05DfOCQ8l2UngMTnwzhI6CcJN7gLvfkYgqk6LgFH3CQZuN0ciQU5SmbJGYBaHt5Ot
	t5q9HDFKg7+zbrI=
X-Received: by 2002:a05:6e02:1544:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3d8099c8c68mr2336055ab.6.1744661747536;
        Mon, 14 Apr 2025 13:15:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvYHcXa5XzzEeeBnhYrriz1zDFvRJNFHVKn7pAJsuo0WYw3znjjkQIP0oUx01t/dn7SlakGw==
X-Received: by 2002:a05:6e02:1544:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3d8099c8c68mr2335905ab.6.1744661747096;
        Mon, 14 Apr 2025 13:15:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2f3f9sm2726409173.129.2025.04.14.13.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 13:15:46 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:15:44 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Nishanth Aravamudan <naravamudan@nvidia.com>, Bjorn Helgaas
 <bhelgaas@google.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Amey
 Narkhede <ameynarkhede03@gmail.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Yishai
 Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org
Subject: Re: [PATCH v3] PCI: account for sysfs-disabled reset in
 pci_{slot,bus}_resettable()
Message-ID: <20250414141544.22ebd4c9.alex.williamson@redhat.com>
In-Reply-To: <20250304234050.GA265524@bhelgaas>
References: <20250207205600.1846178-1-naravamudan@nvidia.com>
	<20250304234050.GA265524@bhelgaas>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Mar 2025 17:40:50 -0600
Bjorn Helgaas <helgaas@kernel.org> wrote:

> On Fri, Feb 07, 2025 at 02:56:00PM -0600, Nishanth Aravamudan wrote:
> > Commit d88f521da3ef ("PCI: Allow userspace to query and set
> > device reset mechanism") added support for userspace to disable reset of
> > specific PCI devices (by echo'ing "" into reset_method) and
> > pci_{slot,bus}_resettable() methods do not check pci_reset_supported()
> > to see if userspace has disabled reset.

The reset_method attribute selects which reset mechanism is available
to pci_reset_function().  It is not intended to interact with the
slot and bus scope reset mechanisms.

> > 
> > __pci_reset_bus()  
> > 	-> pci_bus_reset(..., PCI_RESET_PROBE)
> > 		-> pci_bus_resettable()  
> > 
> > __pci_reset_slot()  
> > 	-> pci_slot_reset(..., PCI_RESET_PROBE)
> > 		-> pci_slot_resettable()  
> > 
> > pci_reset_bus()  
> > 	-> pci_probe_reset_slot()
> > 		-> pci_slot_reset(..., PCI_RESET_PROBE)
> > 			-> pci_bus_resettable()  
> > 	if true:
> > 		__pci_reset_slot()
> > 	else:
> > 		__pci_reset_bus()
> > 
> > I was able to reproduce this issue with a vfio device passed to a qemu
> > guest, where I had disabled PCI reset via sysfs. Both
> > vfio_pci_ioctl_get_pci_hot_reset_info() and
> > vfio_pci_ioctl_pci_hot_reset() check if either the vdev's slot or bus is
> > not resettable by calling pci_probe_reset_slot(). Before my change, this
> > ends up ignoring the sysfs file contents and vfio-pci happily ends up
> > issuing a reset to that device.

And that's exactly how it's supposed to work, bus and slot resets are
different mechanisms.  This change has broken vfio-pci's ability to
perform bus/slot reset for the vast majority of use cases, where the
reset_methods array is empty because we have devices that have no reset
mechanism other than bus reset.  This is seen for example in the
trivial case of a multi-function GPU and audio device.  We can no
longer perform a bus reset here because audio function has no reset
mechanism[1].

The irony here is that the bus/slot reset is meant to provide resets
when the device does not support function level reset, but now we need
function level reset support in order to perform a bus/slot reset.

This change has been pushed to stable trees and is already beginning to
cause problems:

https://lore.kernel.org/all/808e1111-27b7-f35b-6d5c-5b275e73677b@absolutedigital.net/

Please revert this change with a cc to stable.  Thanks,

Alex

[1] Both the GPU and the audio device should report no available reset,
but I suspect we have an ordering problem that function 1 hadn't been
discovered before we probed bus reset on function 0.

> > 
> > Add an explicit check of pci_reset_supported() in both
> > pci_slot_resettable() and pci_bus_resettable() to ensure both the reset
> > status and reset execution are both bypassed if an administrator
> > disables it for a device.
> > 
> > Fixes: d88f521da3ef ("PCI: Allow userspace to query and set device reset mechanism")
> > Signed-off-by: Nishanth Aravamudan <naravamudan@nvidia.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>
> > Cc: Amey Narkhede <ameynarkhede03@gmail.com>
> > Cc: linux-pci@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Yishai Hadas <yishaih@nvidia.com>
> > Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: kvm@vger.kernel.org  
> 
> Applied to pci/reset for v6.15, thanks!
> 
> > ---
> > 
> > Changes since v2:
> >  - update commit message to include more details
> > 
> > Changes since v1:
> >  - fix capitalization and ()s
> >  - clarify same checks are done in reset path
> > 
> >  drivers/pci/pci.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 869d204a70a3..738d29375ad3 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -5405,6 +5405,8 @@ static bool pci_bus_resettable(struct pci_bus *bus)
> >  		return false;
> >  
> >  	list_for_each_entry(dev, &bus->devices, bus_list) {
> > +		if (!pci_reset_supported(dev))
> > +			return false;
> >  		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
> >  		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
> >  			return false;
> > @@ -5481,6 +5483,8 @@ static bool pci_slot_resettable(struct pci_slot *slot)
> >  	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
> >  		if (!dev->slot || dev->slot != slot)
> >  			continue;
> > +		if (!pci_reset_supported(dev))
> > +			return false;
> >  		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
> >  		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
> >  			return false;
> > -- 
> > 2.34.1
> >   
> 


