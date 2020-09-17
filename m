Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5545C26E2A0
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 19:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgIQRjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 13:39:44 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13022 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgIQRjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 13:39:06 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639e850003>; Thu, 17 Sep 2020 10:36:05 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:37:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 10:37:34 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:37:31 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Sep 2020 17:37:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PE8jfAU9CEsa/B33FKEYqv5zegEzQgyAIliJLhywX2rIImKXG0ZwTXgb9OYgNw1oUWTJB3cdxjZbQWgSJNYmidHJ4TtHuueyOoOuaH6WOA5hs4vVAK7aagLMykq6NojNaxvGSR+Ygyxvh/DBR51tAqs08ENF6CSHSlLV3HEVd+Poj/FckjoEmRoIhhxWSOo5NDizt2iAg7QmKLCxFZqDJBbeU1Xmp5/0vd43aa1+EyWrXgnR5AZO9bK/xqKDT5UgWo67CxMoKNVRQ9+A362M17rru2OJ+8N0iLypLFzSOYEsKSdrAKqFm3AFmX6mDUOAPNmUyMhg4vmApSR3s59Jtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xf5hg/6KTQg/I3Eyb7l+Z7hBuwaTQt9JhVuj8I23S2o=;
 b=DiL0BmAM0UVHplRS1wUhlRJM+Fadw05/UOGqxEen/fhkYjDuo7TELD+UKAlUD3h8dvVQJ5O3jXV4XqytcFIVjfXOqxDd6nlsXRCe+chVByH1VJSZv4IIfpdd2moVc6BqcTEz9Z46pV4ENrPyKj8mJ7RKPt3n9ebCPQ9kyY9X1QD72PI+xt5KXkK1Mx/H0vDfc40tz1+BIYt25CvHI0TMLuRSPwNlOtK5YMPbdAYk80YzGDcMP9XN08ybqbFuHZeVdJfZ5cJ25WYgxq6ZCI9KZJHrDcj+LtggudvDD2CSQVQBum1mVfVCZaadtuVY6goJsazW5i96KzBY/VH7awQ3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2858.namprd12.prod.outlook.com (2603:10b6:5:182::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Thu, 17 Sep
 2020 17:37:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 17:37:29 +0000
Date:   Thu, 17 Sep 2020 14:37:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <tglx@linutronix.de>, <jacob.jun.pan@intel.com>,
        <ashok.raj@intel.com>, <yi.l.liu@intel.com>, <baolu.lu@intel.com>,
        <kevin.tian@intel.com>, <sanjay.k.kumar@intel.com>,
        <tony.luck@intel.com>, <jing.lin@intel.com>,
        <dan.j.williams@intel.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <parav@mellanox.com>, <rafael@kernel.org>,
        <netanelg@mellanox.com>, <shahafs@mellanox.com>,
        <yan.y.zhao@linux.intel.com>, <pbonzini@redhat.com>,
        <samuel.ortiz@intel.com>, <mona.hossain@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20200917173727.GO6199@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <20200917150641.GM3699@nvidia.com>
 <f4a085f1-f6de-2539-12fe-c7308d243a4a@intel.com>
 <20200917113016.425dcde7@x1.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200917113016.425dcde7@x1.home>
X-ClientProxiedBy: MN2PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:208:236::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR05CA0037.namprd05.prod.outlook.com (2603:10b6:208:236::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Thu, 17 Sep 2020 17:37:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIxqZ-000aw9-UU; Thu, 17 Sep 2020 14:37:27 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f073b43-f18a-4f0f-2eb0-08d85b305969
X-MS-TrafficTypeDiagnostic: DM6PR12MB2858:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB28589910A7BB59F347297A18C23E0@DM6PR12MB2858.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0IhBZAjSa4vE/OcnEY9KcySQ4k1s9AI36OTIMEJZ5vcICwXMPZjXsDkeXq5q9/j2d5OM6AEwkCRaZwrjboeOrLgu9dqvIjiBv1Zjpo0sQ3SWI0kLb2mL7eu+yqXLVRz2sSF9gq0yk8E7MSc8oVisZAheliQXsFr6m6ruV46vmZJnN+v6s4mzHF7FJZwQcUNiD8qRWjzLLa1jcxVRAK2Lcp6OYzOrnEEcvZOgE3EJBhEidoSAMnGceJpzjDE2wt5bfYDUKAfXgy8O12MOHRV31Gt8x+aWs0sGgNHRmJHZcuulVeY0btORr+FsHlDdfQNYvQfeVb3sAoT5XmAeM1YHfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(8936002)(316002)(86362001)(186003)(33656002)(7416002)(8676002)(36756003)(2906002)(1076003)(5660300002)(66946007)(6916009)(26005)(4326008)(9786002)(9746002)(53546011)(66556008)(2616005)(66476007)(426003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: U3SnrC7z2E6Snsh0G7XMJov5Izh5QxbkFKfOFkqkRABaAJEjUflI/5Pi96voW9tDoUcVh4YK6/5jwNalJZ6cSDinHPfaNt5O5fLyS26LHZEOYB+IgoSybkAoXNXnlVhiP722DyUh+TF0+5AWeOqZIzSrrCO34wHYDLJpkD5lytzuiEnJIm55aGHvw/aKWfA8wPVuXS20RCcRPtG4jKgsezWCq0xslQkDWHKHVDGH+howuT2BSUWtyz0IC5hSl9GlWt+wTVsX0LNR67zzEzdvYbQ+o1IDrxDR4L8ZOqFMwuKiNEJPu1qAHEE5ep6/JVOL4ZGBULgyF8Kv5Sryam8VJAfg6ZvdHpRAHDz/aNBLWykJdn16TC1+IQk8L3vVJnS7z8jmbeGc1Mp3rbBm6jGwgp+IgM6drVrwjrpNfB8KMIL3bFZFU1zlvSciMzLYyTbgWWdaQ1bY+s9zZ32hXK8BIf0a66RWjiZFKyrUtdjSfdeRA7PE6i1RbuHPij+csDUic9SO0GUAHiWMtPuBIgwETUeMZ/MbkCqDNx6jRAHGccWN7DR115qqdCanRhEf1JYsksWsu67r6ShFw6muiakI46sN2h26M1RhfBwhEH+GoC+80/2GEQ5XB73rWl2J1hafXAxXeJArSwkNVaZAiZkrWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f073b43-f18a-4f0f-2eb0-08d85b305969
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 17:37:29.3076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6f3ZbMXUY7OKHX8zH+Kn4mjiqrETLIGf5inxH9K7eEgQRV/GMCOgK0l5vf2BSIF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2858
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600364165; bh=Xf5hg/6KTQg/I3Eyb7l+Z7hBuwaTQt9JhVuj8I23S2o=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-LD-Processed:
         X-MS-Exchange-Transport-Forked:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Kams5ijmXknCHef1f+Xq1+XyBeG2s/CHqXomZDEO2aT+LVzlaLTnUC14jKEsXzDJO
         QreAsMfuxq5vowAKtzVFLX2iIC6bWX/qxsQljFLqlgw/ifk3PPNRnfykEbtSQEIWPr
         TnXSM/WK2k/sFF6lBWHfbhMkkgJeylJiBotdsc8h9dNKTNTq/PcBCi6JsSGAuUqAuS
         IHeA0fR/vn6Lpamwo8bBi6mzIZGLQaNeeGyLgOx4SvswNY6AQeXj2u706BHQMPUApg
         at26ZQLE6Xk9JR8RO+7rR0OMG5+hag/E/0C64vfrbmKh2ZwIHscxYnYblhyefv2KOG
         4CK3RJy9pZURQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 11:30:16AM -0600, Alex Williamson wrote:
> On Thu, 17 Sep 2020 10:15:24 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
> > On 9/17/2020 8:06 AM, Jason Gunthorpe wrote:
> > > On Tue, Sep 15, 2020 at 04:27:35PM -0700, Dave Jiang wrote:  
> > >>   drivers/dma/idxd/idxd.h                            |   65 +
> > >>   drivers/dma/idxd/init.c                            |  100 ++
> > >>   drivers/dma/idxd/irq.c                             |    6
> > >>   drivers/dma/idxd/mdev.c                            | 1089 ++++++++++++++++++++
> > >>   drivers/dma/idxd/mdev.h                            |  118 ++  
> > > 
> > > It is common that drivers of a subsystem will be under that
> > > subsystem's directory tree. This allows the subsystem community to
> > > manage pages related to their subsystem and it's drivers.
> > > 
> > > Should the mdev parts be moved there?  
> > 
> > I personally don't have a preference. I'll defer to Alex or Kirti to provide 
> > that guidance. It may make certains things like dealing with dma fault regions 
> > and etc easier using vfio calls from vfio_pci_private.h later on for vSVM 
> > support. It also may be the better code review and maintenance domain and 
> > alleviate Vinod having to deal with that portion since it's not dmaengine domain.
> 
> TBH, I'd expect an mdev driver to be co-located with the remainder of
> its parent driver. 

Multifunction drivers are always split up according to the subsystem
their functions are part of.

See the recent lost argument about the Habanalab NIC driver not being
under net/ even though the rest of the driver is in misc/

Jason
