Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B863D2A2B5B
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 14:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgKBNWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 08:22:06 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13440 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgKBNWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 08:22:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa008010000>; Mon, 02 Nov 2020 05:22:09 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 13:22:02 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 2 Nov 2020 13:22:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EED55EXPmd+OphiJQWGeESG8yUm/V2Xq5TJJitYUsM/mGlRql1cDzMr6La+LFFuh18Meazfxiz1LZchffzP3BQL4QPp3gHaNmCdEJg7lySXCtPB0QE9rdNDo7kxYirDgSn97BaMSVnSMy4z9H07rYLE9c5MYQy3aaIEjS7MaveYTa/rv3qRgWUZk9VdNXCFwkuHp5Hw0DaaiwypFQ/ueNnnntY3OYh6wchR/EzJVODa+NTV0w4ZlduVRbPCwLpkC+3nn7Au7tYvcVsoGq73xFaCv6am4i1ItNU4/0rQs+mjxBbql46lemksjeDkUpeV6ZXcOH4nb5nybqoSYidhkxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUYoVtIU02fFt28vDH50Q7a6CyGVgq4MIbit569l2sY=;
 b=EkyAvPDHYuM6MIliPGEvJuvaHLA86JCJHCu82N3HyXcnHreTdA93kfy+4OI+lHhcPxRfR91X2SQGsrmmM/uYhQ1gzvEh2+xk1NJOCEIrZ4322jEYYIdrcFwjW2F/vQ+smhjOEbDflyfIeQLd8XzRHz/W+KwOL60fJnPIPOP3NYL7DGt9qsnFphM2Ih/uGJQog1qRLLr7Pc9D/FEzMnOx+/sYgrk2/z2H+r0VrmyVpBeCc3LSAjhwmC9urqMBinkzDLD+ZokZILpHYK+qOT+M3eSH02Oj0QI/vIsAqS8DC2jgu/FRl54AWi0PbFzOsvXIpounjCwv3m2ibAvekCjn0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4810.namprd12.prod.outlook.com (2603:10b6:5:1f7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 2 Nov
 2020 13:22:01 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 13:22:01 +0000
Date:   Mon, 2 Nov 2020 09:21:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     Bjorn Helgaas <helgaas@kernel.org>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <tglx@linutronix.de>, <alex.williamson@redhat.com>,
        <jacob.jun.pan@intel.com>, <ashok.raj@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201102132158.GA3352700@nvidia.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
X-ClientProxiedBy: BL0PR0102CA0068.prod.exchangelabs.com
 (2603:10b6:208:25::45) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0068.prod.exchangelabs.com (2603:10b6:208:25::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 13:22:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kZZmY-00F5qE-UL; Mon, 02 Nov 2020 09:21:58 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604323329; bh=GUYoVtIU02fFt28vDH50Q7a6CyGVgq4MIbit569l2sY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=qtCgIBia4z+8te/t6cLhiw4Vw5DGlpCmodklokxK+k/9ri92A5AAg9zPE9pqNzAh2
         7DJNDrNBRcQeknp+MS6eS4QTFpC9GkSJ495g7s/tumJb3FjYcmp4K4Bapo9LbO3HwB
         mvyExe7k893RzIdSb4SfKI8QgDsqEjd/7OUp86bhaIDWQZ/Jq2dXAAqfA8g6WcPzja
         nkh4ddFhVqkMzI4TlVKQ/lQwFMJp3OfqzEsxr+TGPL1lSyyUC2oCVeJuCMz0cxF1AV
         kBlDmt4fiS0H4yz/WIH8nWeMmuRrN4iyXHKYbR3ngUz8r0JXgl+HmR7X82EmO99tPC
         PcQvLnQPmFXig==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 03:49:22PM -0700, Dave Jiang wrote:
> 
> 
> On 10/30/2020 3:45 PM, Jason Gunthorpe wrote:
> > On Fri, Oct 30, 2020 at 02:20:03PM -0700, Dave Jiang wrote:
> > > So the intel-iommu driver checks for the SIOV cap. And the idxd driver
> > > checks for SIOV and IMS cap. There will be other upcoming drivers that will
> > > check for such cap too. It is Intel vendor specific right now, but SIOV is
> > > public and other vendors may implement to the spec. Is there a good place to
> > > put the common capability check for that?
> > 
> > I'm still really unhappy with these SIOV caps. It was explained this
> > is just a hack to make up for pci_ims_array_create_msi_irq_domain()
> > succeeding in VM cases when it doesn't actually work.
> > 
> > Someday this is likely to get fixed, so tying platform behavior to PCI
> > caps is completely wrong.
> > 
> > This needs to be solved in the platform code,
> > pci_ims_array_create_msi_irq_domain() should not succeed in these
> > cases.
> 
> That sounds reasonable. Are you asking that the IMS cap check should gate
> the success/failure of pci_ims_array_create_msi_irq_domain() rather than the
> driver?

There shouldn't be an IMS cap at all

As I understand, the problem here is the only way to establish new
VT-d IRQ routing is by trapping and emulating MSI/MSI-X related
activities and triggering routing of the vectors into the guest.

There is a missing hypercall to allow the guest to do this on its own,
presumably it will someday be fixed so IMS can work in guests.

Until the hypercall is added pci_ims_array_create_msi_irq_domain()
should simply fail in guests. No PCI cap check required.

Jason
