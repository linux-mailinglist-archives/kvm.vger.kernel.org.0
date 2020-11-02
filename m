Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCF02A32F3
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgKBS0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:26:43 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12562 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgKBS0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 13:26:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa04f660000>; Mon, 02 Nov 2020 10:26:46 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 18:26:37 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.50) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 2 Nov 2020 18:26:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uqb+EmyWzvsTBt+xlVoKVfhcWNsUGWD7xXUWb4cqMnGi5ia8eZrtOxXU1fDNtrbVcdTNugYxroA7ZpUqhSDEVHYhgmRM1TKaTD5PTrBUQew9s8/LvrJTqcmajuIusIBPHdAG+isS4uQk7/92qVuUEWVHaTbJZ7nwx79zx9CBK4yOHktUqZ9vFHE3b2EbTlGlaVI65eCtSe8969ieeV3VIcCDyVL4ooNzhC8SMJLRafQFVmvvqx4CUUx6Ai43DQOa1iTX+7TpwC5OoDTVPpNjTHOwy766bevJPeee+0rmpE8MSqXuRWv9I3hky6Zwz5LXROO1wWDkmFWu7D6W7HZ/4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWdPexYAEXDv4lVqDjs93kChknugzk9wJ0qNPi4NJzw=;
 b=Y876if0aoaqywSd5nD3dVumAOCJCfz/8HvKD3yJfp2xKc8zR8AcsuOhkIDkd6jM5JdqqVCtBL1xAs2ub8zGuPx58k8cDkDhTkpT01hCCz1X8WFBaxT1JsBvVp69OJfBaGRmOaPpPjEVsG43wCQHOy8lbDVvBw1mQSU83re6YuZEbmavVtPezhEHqMDVuLuGlOOznQ48h+LXwVFt6QowFwHJDqJM7KysSnp3qFq2zFDvU9HLS+R6Lg3rr03yU7lb3RmOWVMHlZrLS8QOomZxigOC/CY1uw4UaQniyH4tzU+q0RSC3Bkdt5vz/NxqAqDNOmRHGHee1aHT8EDfkJs/zhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 18:26:34 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 18:26:33 +0000
Date:   Mon, 2 Nov 2020 14:26:32 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, Megha Dey <megha.dey@linux.intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201102182632.GH2620339@nvidia.com>
References: <20201030191706.GK2620339@nvidia.com>
 <20201030192325.GA105832@otc-nc-03> <20201030193045.GM2620339@nvidia.com>
 <20201030204307.GA683@otc-nc-03> <87h7qbkt18.fsf@nanos.tec.linutronix.de>
 <20201031235359.GA23878@araj-mobl1.jf.intel.com>
 <20201102132036.GX2620339@nvidia.com> <20201102162043.GB20783@otc-nc-03>
 <20201102171909.GF2620339@nvidia.com>
 <20d7c5fc-91b0-d673-d41a-335d91ca2dce@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20d7c5fc-91b0-d673-d41a-335d91ca2dce@intel.com>
X-ClientProxiedBy: BL0PR0102CA0056.prod.exchangelabs.com
 (2603:10b6:208:25::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0056.prod.exchangelabs.com (2603:10b6:208:25::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Mon, 2 Nov 2020 18:26:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kZeXI-00FQnu-9z; Mon, 02 Nov 2020 14:26:32 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604341606; bh=EWdPexYAEXDv4lVqDjs93kChknugzk9wJ0qNPi4NJzw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=hUeQpQS6gEQacOJnYbVdGxkLhFsJbuqND3/FHeADKkc42ADhBN8FFXw15dZ1iQek3
         XWhYi+BQCc1rjfk2ovqcmYUk+C8Rxvd+ljAttpzG58YlLfmueJYEgTyRR9lR7DAZiZ
         LdompiBAjNWLkQSK0OpHoqjzVEO2zTcZQnQXi9UhHJK+WdUb4Vi2cn5kPMDaisHjSD
         XBm19CWU3q6wWzaYNNF2DPuvwT+UINSBZ3LmSFqJ7OhkFwZlaP/IqblMgleC3UGS2/
         b88TY1f+sTnN04jmvXR7xSTDVFRUBbud3p93YEyIPimJWym/8zc2KmgATERuuc85c0
         zu/J+30i7gNlg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 11:18:33AM -0700, Dave Jiang wrote:
> 
> 
> On 11/2/2020 10:19 AM, Jason Gunthorpe wrote:
> > On Mon, Nov 02, 2020 at 08:20:43AM -0800, Raj, Ashok wrote:
> > > Creating these private interfaces for intra-module are just 1-1 and not
> > > general purpose and every accelerator needs to create these instances.
> > 
> > This is where we are going, auxillary bus should be merged soon which
> > is specifically to connect these kinds of devices across subsystems
> 
> I think this resolves the aux device probe/remove issue via a common bus.
> But it does not help with the mdev device needing a lot of the device
> handling calls from the parent driver as it share the same handling as the
> parent device.

The intention of auxiliary bus is that the two parts will tightly
couple across some exported function interface.

> My plan is to export all the needed call via EXPORT_SYMBOL_NS() so
> the calls can be shared in its own namespace between the modules. Do
> you have any objection with that?

I think you will be the first to use the namespace stuff for this, it
seems like a good idea and others should probably do so as well.

Jason
