Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF4426E2D4
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 19:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgIQRsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 13:48:10 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:28346 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgIQRqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 13:46:01 -0400
X-Greylist: delayed 1065 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 13:45:40 EDT
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639c8f0001>; Fri, 18 Sep 2020 01:27:43 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:27:43 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Thu, 17 Sep 2020 10:27:43 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:27:39 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Sep 2020 17:27:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOLcm7nhFVkO54mGu8VnCqfokE64/Gnwv95aC5KZZWJ8lN/9SghkYqpmEfgzQTLvNwvTL4oX/jmTO71AtD3KuLctYgbFmVu2Gpn+0Y4ah9seobrBkP54slGo8h1PFYqtYAgFw+r1HMHS/LUqMu4tCslQsmohCjr4VerJbrxE7K0EdZBoigU0Nr0GJft20GZFTWMEo7MlCn5GB8A2qE5nOmKLWNOM70TGn92OX2uoKSkOf0wNmIoWD564PfnwnV4zf9bZ18l0ZphD/wmnKzOlgqI1nqu6gVyBYUwI9SmWMrrorf0MVK4yfOxoF4pWzF9LjydxabS09usQuvUGwFq1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAIQdb1o+TqXTuboiFpj1LQuKrJYaovCBe+643kFlus=;
 b=QES9aITHBu/83+vWqm3YqH6RQUWYEyeGFWAW/sUAVrNqjOz/WEdvztAAB2hGe5kMqgzBhiBdH0mNjJk8TLcvFoa2JktiJOkq11MqinHi94ibWz/pMkVWIgVIYreWfIyiL1VUQjeQ1142pxzzKAZTE9a6rYvel60cYFZ4T4308R6u+ancsUOqSltfZr2XFpIX8RtnFZYWDwtMg2aCi0iFF4lQVvhsMVuyAN6njYgg9gc/IMA9W1ROHI3c0+47NzqQ6mY7gsnOOVdpunm5W5oPwK5EaEnH7uAdpgN56N1UiyVEK3ykCWH8aRFhGrhb0LP8kNyMlnxtIQrqNevMuYRiCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Thu, 17 Sep
 2020 17:27:35 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 17:27:35 +0000
Date:   Thu, 17 Sep 2020 14:27:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <vkoul@kernel.org>, <megha.dey@intel.com>, <maz@kernel.org>,
        <bhelgaas@google.com>, <tglx@linutronix.de>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
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
Message-ID: <20200917172733.GU3699@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <20200917150641.GM3699@nvidia.com>
 <f4a085f1-f6de-2539-12fe-c7308d243a4a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f4a085f1-f6de-2539-12fe-c7308d243a4a@intel.com>
X-ClientProxiedBy: MN2PR20CA0051.namprd20.prod.outlook.com
 (2603:10b6:208:235::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0051.namprd20.prod.outlook.com (2603:10b6:208:235::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Thu, 17 Sep 2020 17:27:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIxgz-000anV-Vd; Thu, 17 Sep 2020 14:27:33 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adfef8a7-6826-4e79-4b6f-08d85b2ef781
X-MS-TrafficTypeDiagnostic: DM6PR12MB4388:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB438871CFEEFCB4C5DA3C0178C23E0@DM6PR12MB4388.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QF0+8ygYyDBwTAANNptG8fvWvPHTnZpSG7jMyJtPLUSlsq402AF08ZcH+D8kX34auSYw9Q9wnkFcUsX2InZFsNQuKic0azIbBwHc5tV6sxcQRElguuc7ShEs5z37HfWuy7fLGrp4Xdiq7RCl3H1OghGaSvSAsQLx8Im1kyjuThMFAZqjrCoQRA+hQm+pApMbByEOEbEoYfXpz5SUprZqhmGjwo6NKsrMaYjNGB4/t1chrWw0g5XDhueulZ93ynZT0MF10VSsXiMYBcXMV3WjldA1uFASe2p3mGHZvioT1/697zKJeizSJm8VQ58SDOjc6aGsvatlOML22y9xMkBAMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(9786002)(6916009)(186003)(4326008)(426003)(1076003)(36756003)(8936002)(478600001)(66946007)(66556008)(66476007)(7416002)(316002)(26005)(2906002)(9746002)(5660300002)(86362001)(33656002)(8676002)(2616005)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /XGzkPPEep8Nk8bgHBO+R/f72fXbrSE4PYowZXGevP9T9ami3q99mngLjIp9MMy1TqSWaEoJdaLu+iv/R3mOJ5f/6L0MWLcCx9tVCl4z7VSuBZiE9Rurm68lh8zZJRxdD98fyyQ8+g4NcnwzcMR0ZO+L/N7qkiYQcHoMYdowpZ3QAkF4IBYg85OSJON0agHesV7LvPjAExMmy0YWnita20EnFuox1jy0+At7a5hVWRByHvzW5nn6kUA97A0Fdz8cl2/LKwmgUKRP+6YI5KL9a7kJRlnxUAPXTq9Ijp8qxsbOG9v4LY8ZHG9B/b90VOShgxbuNWPE0HgLeyF5prfvxRv1sREdpcP8PL+tOSAIMNAvDi0GVCQQMHBF1W5n41H61AG/8+vL1h8p2UwQNoXH92u+DApsKw4CTvtLwSPGnVW5vxuEDK/JRyN2dZQ+Lv8fHI0KaBzX4qZey9nGJ58bJiz655IgouFYHS7ZyVldrwK4Yydh0mjLrsLb3KwpD1ALGso9tG90IGCMgEj/p6Gc1OI2ihX1pR0mnSWv5tWFEzkcN/McVW4eTV865rDEihHNyVAtLpfsBQRpJdGMOBZHXVar8bze+cm+ZCrf0rrTYroW6VooUaH9+9rnqf8ELveFQ4nCGa/J38qF7MgXrYTPIA==
X-MS-Exchange-CrossTenant-Network-Message-Id: adfef8a7-6826-4e79-4b6f-08d85b2ef781
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 17:27:35.4702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsEJrJ5qjGrqMMK5IilBTB9utFW+SApcsnyWNL0bLkosUmbu7CoPxz7yKDEk/o7U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4388
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600363664; bh=DAIQdb1o+TqXTuboiFpj1LQuKrJYaovCBe+643kFlus=;
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
        b=qhrWMDRrYz6jSZ+PmGksPiBNliFOS7eNxtq1mDwhbQuFLnuwIlssw5xP3i71Ho8bb
         aM/lIIylxkeYoHG2IyWcmzhj9M76gXhjRKrlx/PRXvKS1vmCcLh2EIg8SwXuK7i57Y
         ireJ7A+asmLuRwWIoc9qjPDMSJj7oauB5TNi09lkQrKRo9f+gUS8OrBc+GYg79nT+r
         jyl7LXbpM2rbVOhyRQqSy988LF97iRbgtMNd0LEzQiLup/bnnEgiESI1bM2Tlb7HHs
         C2SSWWCRuuxhCAJlWeXk6bfTV+ETvDklzelMcE4SeFCVAcc/rVQxNrfrWl48jfQ/xs
         CbE6sIXXZK0zA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 10:15:24AM -0700, Dave Jiang wrote:
> 
> 
> On 9/17/2020 8:06 AM, Jason Gunthorpe wrote:
> > On Tue, Sep 15, 2020 at 04:27:35PM -0700, Dave Jiang wrote:
> > >   drivers/dma/idxd/idxd.h                            |   65 +
> > >   drivers/dma/idxd/init.c                            |  100 ++
> > >   drivers/dma/idxd/irq.c                             |    6
> > >   drivers/dma/idxd/mdev.c                            | 1089 ++++++++++++++++++++
> > >   drivers/dma/idxd/mdev.h                            |  118 ++
> > 
> > It is common that drivers of a subsystem will be under that
> > subsystem's directory tree. This allows the subsystem community to
> > manage pages related to their subsystem and it's drivers.
> > 
> > Should the mdev parts be moved there?
> 
> I personally don't have a preference. I'll defer to Alex or Kirti to provide
> that guidance. It may make certains things like dealing with dma fault
> regions and etc easier using vfio calls from vfio_pci_private.h later on for
> vSVM support. It also may be the better code review and maintenance domain
> and alleviate Vinod having to deal with that portion since it's not
> dmaengine domain.

That is the general reason, yes. Asking the dmaengine maintainer to
review mdev just means it won't be reviewed properly.

This mistake has been made before and I view it as a lesson from the
ARM SOC disaggregation.

Jason
