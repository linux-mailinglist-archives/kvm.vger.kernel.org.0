Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988E92A3357
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKBSvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:51:38 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:5588 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgKBSvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 13:51:38 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa055380000>; Tue, 03 Nov 2020 02:51:36 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 18:51:35 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 2 Nov 2020 18:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wlnpy8exy6gRW9AU/1YTywJrc+TLfGRPrlvMFDYou56qrBU3hY2SnR81x1wgfJRHNq0aOYjQ/BFuu/H7O6F2/paQYRORIRT1JGne9E8UsX6/htcN4Phn5QAHphch8efJJX3YbaVEq3PH1sSFpjrFSvGBNi09WpTl1NedzhKOpSmgLtr2AFkRWbU+nYD8A+T3Tbi2m9Qv3Sxv3vsv/T9lBGOmOPDEvJcOhweiZr0+x5vSpaCaBn/lesmxKOcUG2hsxOdA0kmuKqWASQbO8k4J/xsQQSjswuV3fGP4bHC4Lf6CcwFK9kyXpHr7O3W+TeXmIHPp0Foa29e3MO/uqjcOzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Afw655/llzzLOfVWWTyt/IVjZ826sj/GF4kenspUmMY=;
 b=M6yirDY4/dwqu7ZwNu5h0z4ChPxlW5I8VgTGUPCtpYngwFhFWdQPsqDceYTWMyk+zFfMxBFAPoH7OKG8hfdvarYrQCSpLSyplxSgDgU2tfHELS5heZ2VflMRsPhBdNGknE/WEOwsduk54HB48h7ltbBDkMpsf2kr+dCoBL++9F791dyjiKJzXvadl+J+s4VGxQ6pkqra1FmmFWrqbefeUxhnqg1g9+lFlSYaC2vo3gzO6T9CjdOSL2GptK5Px8/hHIR2XgfWgKIBmhqiQ5mBMTJ9lkFg8krRcYOhB55qL1hxlobNOOHQdYUqy7aJTd+BAbyWJ/qgmzEW3LtGu12KDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4356.namprd12.prod.outlook.com (2603:10b6:5:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 18:51:32 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 18:51:32 +0000
Date:   Mon, 2 Nov 2020 14:51:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     Dave Jiang <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>, <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Jacob jun Pan" <jacob.jun.pan@intel.com>,
        Yi L Liu <yi.l.liu@intel.com>, Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        "Parav Pandit" <parav@mellanox.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Samuel Ortiz" <samuel.ortiz@intel.com>,
        Mona Hossain <mona.hossain@intel.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        <dmaengine@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201102185130.GB3600342@nvidia.com>
References: <20201030193045.GM2620339@nvidia.com>
 <20201030204307.GA683@otc-nc-03> <87h7qbkt18.fsf@nanos.tec.linutronix.de>
 <20201031235359.GA23878@araj-mobl1.jf.intel.com>
 <20201102132036.GX2620339@nvidia.com> <20201102162043.GB20783@otc-nc-03>
 <20201102171909.GF2620339@nvidia.com>
 <20d7c5fc-91b0-d673-d41a-335d91ca2dce@intel.com>
 <20201102182632.GH2620339@nvidia.com>
 <CAPcyv4h8O+boTo-MpGRSC8RpjrsvU-P3AU7_kwbrfDkEp8bH1w@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPcyv4h8O+boTo-MpGRSC8RpjrsvU-P3AU7_kwbrfDkEp8bH1w@mail.gmail.com>
X-ClientProxiedBy: MN2PR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:208:d4::46) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR04CA0033.namprd04.prod.outlook.com (2603:10b6:208:d4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 18:51:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kZevS-00FSUS-Pl; Mon, 02 Nov 2020 14:51:30 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604343096; bh=Afw655/llzzLOfVWWTyt/IVjZ826sj/GF4kenspUmMY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=rMC5O6cMyjDQa1CQPTi/IhODP5InUMGg4CyNZ9xsl7IgSGJNKo1Qwjw6TySt79ERC
         AvlzWDHAu9Qf2yj+BRzhA6c5ITlwHGdTKgQ80Y0p05ReZdsxLMBO9X/WJ9taAu2rOj
         lpfptxL+ezsje0dkRvfegqBezfYhnvZxiaMyxl06D6iel8v0k+fJqQ7sen7OCi2Tw8
         /wiDKduFgtMTjnr2mHMMpKjM4/3JfX9uzcUQHejGNYf8xzAD9rKNixfqj9zfZo7CyR
         DBsRsjOkJlMDjNBPLgxyMEuhohZLHmFmzRk5nWyR1aLY2qFySXwBPGKbt71pwOxDNS
         +e/opjNzQDY/Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 10:38:28AM -0800, Dan Williams wrote:

> > I think you will be the first to use the namespace stuff for this, it
> > seems like a good idea and others should probably do so as well.
> 
> I was thinking either EXPORT_SYMBOL_NS, or auxiliary bus, because you
> should be able to export an ops structure with all the necessary
> callbacks. 

'or'? 

Auxiliary bus should not be used with huge arrays of function
pointers... The module providing the device should export a normal
linkable function interface. Putting that in a namespace makes a lot
of sense.

Jason
