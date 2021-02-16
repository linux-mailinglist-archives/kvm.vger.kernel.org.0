Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C57C31D221
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 22:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhBPVcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 16:32:12 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8489 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhBPVcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 16:32:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602c39b00000>; Tue, 16 Feb 2021 13:31:28 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 21:31:27 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 21:31:25 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 16 Feb 2021 21:31:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXxPmfALUSJNQKTDI8a36fcE3B4xPhcxESeIJfz86P5Bs1y3jVr2ls0UWP/7swjangiiNmkUKZ2+Yzh0WTZMKmbAQKqZP4KLezDTD+21nOzW0WBgyTUqYxs4eafOYi+AVAZcDkBL0DYNKnHw4jlKC/fKiBPEt1kfJIMUvoa/m0lkc5fxcjXjuFlZc8+mVhLLR6Hl5PnnvWo3tiv3fcAcFPGWv0BGA1tTxT1DHjuek11zQQpaP1T2Yg+UrHWaAnlJ7xHKuRKUuZqqDxkU3Fpusf0TcSBH29ggIsyTEeY1T6IaWE1gJQPbxiYGZtgXdgrCht0yAezJA/CaNLi73sOrDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/h3tKCGl1MYFt93Olhu3gKAtSNgRUmwYf9N7Q/Yz6k=;
 b=n3SCI9ScruZvGZYDC4tEsPs+JmYdtydXg0tAEZeasBIDTrI3dTv+rvgJ8G94s4z1lnczXBe7HjbiT339QtEabKCuzO55TJigdgb0q/a4OKQwEVjN/IMaHlepHpXMS6XqfBWTL2E1zliDGohDIjD/gtGSWBoV7ZaHeGKU27dU6hzRErM4ylL7aYB++Oge7EJ0cHfYIcyn6aW5TliE+Obsaebravyw6pgxtOm4G2GMHA0h7huumOFi+JTm6b4kNEc8041QmnH2DR4nsTGbqiJWVoifjwPEXSYtS+J9zHUIwSVQeLThuVXHXADiIowATsQJw/zPvCSw1kAvQEMmZ0jXLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1884.namprd12.prod.outlook.com (2603:10b6:3:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Tue, 16 Feb
 2021 21:31:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.041; Tue, 16 Feb 2021
 21:31:21 +0000
Date:   Tue, 16 Feb 2021 17:31:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     Dave Jiang <dave.jiang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kwankhede@nvidia.com>, Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, <eric.auger@redhat.com>,
        Parav Pandit <parav@mellanox.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <dmaengine@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration
 and helper functions
Message-ID: <20210216213119.GI4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com>
 <8ff16d76-6b36-0da6-03ee-aebec2d1a731@intel.com>
 <CAPcyv4jDmofa+77q_hG1EimaKxq2_hYu-kVOVbU4mN4XSdOUWA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPcyv4jDmofa+77q_hG1EimaKxq2_hYu-kVOVbU4mN4XSdOUWA@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0232.namprd13.prod.outlook.com (2603:10b6:208:2bf::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Tue, 16 Feb 2021 21:31:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lC7wF-009Lml-Io; Tue, 16 Feb 2021 17:31:19 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613511088; bh=g/h3tKCGl1MYFt93Olhu3gKAtSNgRUmwYf9N7Q/Yz6k=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=aIxy3Ax9XlIY0/siXxD6bVQ/VqLpbloK9M4jArLFvPIc0abUUv6N8HPVfECe36lqC
         Qp5a75q0nD0K4Qy6VvuKMcVS14t4KnlguHU6VbtQWJ92iy60+LoNxPokljibGrcced
         yW/awZJYb4cXUWp984UIFmH263hm4U1nt2+GnzeirapU3mUQk2i7VF/6suLisrLYJr
         TJOpIO3T2m0Rj/Dr8/CRrhOJlqeqgMyYlXXcjZoi1TPAm4FP1lm5/ckIiaAhG7+suw
         7sGo61tGntJUhKyEZfAFK68sUrXFhKC5/7JhVr/F+dpC/L8uTnwpqaGT/sF5B277yS
         68eCP1o+Bc7JA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 12:39:56PM -0800, Dan Williams wrote:
> > >> +    /*
> > >> +     * Check and see if the guest wants to map to the limited or unlimited portal.
> > >> +     * The driver will allow mapping to unlimited portal only if the the wq is a
> > >> +     * dedicated wq. Otherwise, it goes to limited.
> > >> +     */
> > >> +    virt_portal = ((offset >> PAGE_SHIFT) & 0x3) == 1;
> > >> +    phys_portal = IDXD_PORTAL_LIMITED;
> > >> +    if (virt_portal == IDXD_PORTAL_UNLIMITED && wq_dedicated(wq))
> > >> +            phys_portal = IDXD_PORTAL_UNLIMITED;
> > >> +
> > >> +    /* We always map IMS portals to the guest */
> > >> +    pgoff = (base + idxd_get_wq_portal_full_offset(wq->id, phys_portal,
> > >> +                                                   IDXD_IRQ_IMS)) >> PAGE_SHIFT;
> > >> +    dev_dbg(dev, "mmap %lx %lx %lx %lx\n", vma->vm_start, pgoff, req_size,
> > >> +            pgprot_val(pg_prot));
> > >> +    vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > >> +    vma->vm_private_data = mdev;
> > > What ensures the mdev pointer is valid strictly longer than the VMA?
> > > This needs refcounting.
> >
> > Going to take a kref at open and then put_device at close. Does that
> > sound reasonable or should I be calling get_device() in mmap() and then
> > register a notifier for when vma is released?
> 
> Where does this enabling ever look at vm_private_data again?

So long as a PCI BAR page is mapped into a VMA the pci driver cannot
be removed. Things must either wait until the fd (or at least all
VMAs) are closed, or zap the VMAs before allowing the device driver to
be removed.

There should be some logic in this whole thing where the pci_driver
destroys the mdevs which destroy the vfio's which wait for all the fds
to be closed.

There is enough going on in vfio_device_fops_release() that this might
happen already, Dave needs to investigate and confirm the whole thing
works as expected.

Presumably there is no security issue with sharing these portal pages
because I don't see a vma ops involved here to track when pages are
freed up (ie the vm_private_data is dead code cargo-cult'd from
someplace else)

But this is all sufficiently tricky, and Intel has already had
security bugs in their drivers here, that someone needs to audit it
closely before it gets posted again.

Jason
