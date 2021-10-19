Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07E3433D1A
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhJSROT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:14:19 -0400
Received: from mail-bn8nam12on2079.outbound.protection.outlook.com ([40.107.237.79]:5344
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231231AbhJSROS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 13:14:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewPbcWiLtvcNaau50QLyU+dS1CRxScgn//ztiexe7ruiE5vVAmC3kXZeK7si8YA/1/+jRDWzernWEibek47Gz024QUj9ZF34mh2nroN9yyOQ5b9Y6XYsuCsV8loiIvaPumea3hOUoI7NIBZHam/VLs63nCzBicKxN36gxtuWfqBJQNmZVut6+bw5x88FXNFPVFGTQ2CxvlL2NRvUraPmUNY11CwtQz1+Sk6uGQ6pWd3JsQtQHof9jYi12GMdAPxRyfiEvqA+xtAwjpyfVB/Rkosi81gyxOinCKMSuGVkuSrditlCZEzPCtvPJ46VX9Ar8ZQUeHMxbuzCGq3SGMKszg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAwuM+yx/J94FQOXYMxyBVO+Kc3e6LnFXL2WLLBhTKQ=;
 b=hWeSPxFDXhLfLnd7SD6OHq1dV6BDV4L2sElrn5kNZxm32Bd8k0SXObtgei4dLTkE8ha2KFKOIPt12aNoSqH8pBrm37hbjZmfUvmwkfPCUNTFDKcufg2nku5K7tQ4ejKFWaflyRLzvKkkYgaOhHlL365ZcOV1GhXY+kQO+5OUnLixpGS6Qa3RXOf+jfwk1DRH9Wha+vz1mE1J4ngxWRp1evHt1n9m2HIlgzvNT2u/XxnPJOnrmuBkFRRQ0WsNdnkz02chLEU4C9gp6KF80Vd0V0Rm6DKlaVcmcmyPckeHxFzcknfGz57GMgiDyH795WYT5w1uuigHcWC4FQSm9hdAew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAwuM+yx/J94FQOXYMxyBVO+Kc3e6LnFXL2WLLBhTKQ=;
 b=jJ9oJLr7kLZ7M058ibTpNUrm1DCv+OT56ru5gLb85D4U64309yUMnx+DA3KiorcWlifLSuXUcqaNgruLqW01kv+6/r2INmBJjuFocz+5c/FTH6E5SMJ56BEI48grUBCM/BCALX10bY/cLpD7RSJVPNJvTAJAQG4YRUMhKU8ui+1rLtVi0Ty3r/xRtquvkW8izEo9qlq1A3DHgMt3Q6/OP8VbjPV3WuSR/yOdOAa7fOKx+iKKLk/ammucOaxGjmBELJCuZiolRObMlOCksw3LA5T+U6CVZ6GEN2ftWIw/9T5SleQD+AgWqZ+d9KEiyIngcnIugecGp+CIFhC1C4yXlg==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 17:12:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.015; Tue, 19 Oct 2021
 17:12:04 +0000
Date:   Tue, 19 Oct 2021 14:12:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Message-ID: <20211019171202.GW2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
 <20210921154138.GM327412@nvidia.com>
 <PH0PR11MB56583356619B3ECC23AB1BA8C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211015111807.GD2744544@nvidia.com>
 <20211019095734.2a3fb785@jacob-builder>
 <20211019165747.GU2744544@nvidia.com>
 <20211019101134.00ee12ac@jacob-builder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019101134.00ee12ac@jacob-builder>
X-ClientProxiedBy: BL1PR13CA0367.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::12) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0367.namprd13.prod.outlook.com (2603:10b6:208:2c0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend Transport; Tue, 19 Oct 2021 17:12:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcseg-00GmMD-4K; Tue, 19 Oct 2021 14:12:02 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c657feac-03fb-4395-895f-08d993239213
X-MS-TrafficTypeDiagnostic: BL1PR12MB5222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5222EA22626553F298B9A29FC2BD9@BL1PR12MB5222.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GP5GWWjbW0B6UbSbgaw63Kdu+R+5Zw32lK1H1q0gucBWDx+tcB3VapNn1o1YMSXwbVHTK7Y/2n7Bs7XQBvicwbUAYc8Q5YZj89oUmgUtuO31cgxaEHXgiWFr+dzYH+xWHCRE0C2pFMFBpCQEHNk0tDNYip57bOe1LxLh1GVRFnlQcOg3CC/bIdJdLpIlPl/UAcRNQMQ/l1xW9hKwgTRIPE6LLFSAkKOOsQYKSv+VIt7ctE6KqHbI5pkJkyI58M7CDFM/HZpZoyev1yg6XksXP2Ta9QPYfPutslkB2fBxtkGyYQtRkYcbxImiGSHKhG8P8K726+xBaRFm2c7xNWHre3VdGgiv+Qw98t3C6F5eRbCOKrCHs0gtMKSG9UhDrEl+95IF9GW3tBdCJJ+KR2kQl3v1YewnWiFMdoCCbJbbAIDTUiQiinIO8sdN3OWJm8Qup8fj0hNWDY5DYag6ZGp0RHZCkW1aS78+ByTaY5L9ycDrLbSTwXnpkZRfxIyTh4QPshEnF9QjZz4D3Fiy6U7pYx/x8zPlYoXpG3Y7j4xHLPucaZvSaTQEzC6zn4TG53I0PwxhP3g0me/otw3YTaPWlY1mRnPO0TrjpfALEdFL5lbXDyAa4X8rGBzGn3skw7AjJ4PrTcoeonRE45pyLFQW2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(54906003)(36756003)(316002)(86362001)(2906002)(66556008)(6916009)(2616005)(107886003)(8936002)(66476007)(66946007)(9786002)(186003)(26005)(33656002)(508600001)(5660300002)(7416002)(426003)(1076003)(83380400001)(4326008)(9746002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KP++vBqt/TEDNREfMlnD7Jbn5+CzAgvJ5JENjuXABy1Y6hyPTk9twJxJwGVD?=
 =?us-ascii?Q?5ylRNq6XgNrDkESNKpzwGXnKIGaXhE7sx0FeTHfY5UGhNUw2arWXtsonFEwq?=
 =?us-ascii?Q?ctyNcuNjxtkItz7TOPmv/lzfnEs+HXlGo4QKfsHty9QnhphREn6dUvddJU1Y?=
 =?us-ascii?Q?+XSotBLEQFT1KZrfMipYmW5I+fgDvzCdo9OHxuQFjqZKizGLQRjI1vtSME9Q?=
 =?us-ascii?Q?+TNnXNTYIt8fPnCRwq2gNnKu4mi5izIk6dSFrEjZhAHtDcgfohwK6YL+88OU?=
 =?us-ascii?Q?A2cgoWUT/rihO3eOWDUrtyb562n55AR8wUxXSgRZITNHy472aYNeW9tvcOnW?=
 =?us-ascii?Q?rFwd8oOP5p+hqfGt+SoXgEyPPRwGdf30dlbvvxK0udAT6lT0C/S/9FcVUj/F?=
 =?us-ascii?Q?NFDnf9WfNvEkLpWwDbBBny64oaUasiRqZGyb9iZUDWSEjmfpJYihAjg9N13S?=
 =?us-ascii?Q?DJKY06r/GLGaZBefpQ1lSWnxjAULpM2NUzEeYmokYk5KkP/JkFBPtQ358qDz?=
 =?us-ascii?Q?Gijg2OD1CRRb/1vbtYzHLa4jOnB1935KZbsPSy457PZOPrt1Ruo+5ghYxjdk?=
 =?us-ascii?Q?Tl+qhHGtA0P0hNwv2rCHEQpsvnVbCQFqsJNBJJFbnI3/WMDNnfVpgMySGm/w?=
 =?us-ascii?Q?uPFI9sEj10hGj+bgdulFIE1ICxgsBpFaW/9M939UqW+b8TLH4o2dMaZpvo7Z?=
 =?us-ascii?Q?9yozL5oYM3RiIJLC2LYxwTvguy235B6eIJZO9A35px/yd8pmy3FNO8BwHZ9D?=
 =?us-ascii?Q?XALcUiiMj90LDeH0w8ku916KkWC8fvemFnJhFjyUykz4Ls9fuhFH9BsHzSoH?=
 =?us-ascii?Q?KJ8SbGPahcirP3KoTJqAUgrUSPy2POZnu7BwB0rY4zvcj9L8dLLujtD2Y8p2?=
 =?us-ascii?Q?eCjcmJD4T2as+yyhXzNFTbwLBu5ogq4+cPvIRgtUx+BcZ43pUGC0YFYCFT/s?=
 =?us-ascii?Q?gSqQbyAeU0C3pbV2hgMBxGLIlPfnfQ71zjyB4rg7bSvwBSQKqo4ZywyjsPht?=
 =?us-ascii?Q?BCpxjzuAySMO0GxYvqtih2Ec9/QQSW0RkFlPyXp6OnVWGCq+xuuQR/WOVub3?=
 =?us-ascii?Q?iMGomeHHM1n2CEHwy9RgKemh4aYqCsR36/8C3TH1wN2CQquWJAQ8aFclVGXF?=
 =?us-ascii?Q?S4yHIpejhYPCeJ7tWCjvXZqBn7pzWh4dcX9Yx1Lc58nASkchD1/DlUFJFCPX?=
 =?us-ascii?Q?zch/AhlWs0spbClqyn04lcTO//Ky+/0M10pttsY2sz7rDOVb3TkH1MpsVZFl?=
 =?us-ascii?Q?/grcA+qoWiSwu1nlBcDUBgLEgmrGgcBmg9nDiY0jaFAUTTqMQa1NK6yN1NlO?=
 =?us-ascii?Q?cYb451lNo6vHCDWXQ7ZMl7VJR9icOZgpi7FQWNMsG2iDiQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c657feac-03fb-4395-895f-08d993239213
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 17:12:03.8695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 10:11:34AM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Tue, 19 Oct 2021 13:57:47 -0300, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Oct 19, 2021 at 09:57:34AM -0700, Jacob Pan wrote:
> > > Hi Jason,
> > > 
> > > On Fri, 15 Oct 2021 08:18:07 -0300, Jason Gunthorpe <jgg@nvidia.com>
> > > wrote: 
> > > > On Fri, Oct 15, 2021 at 09:18:06AM +0000, Liu, Yi L wrote:
> > > >   
> > > > > >   Acquire from the xarray is
> > > > > >    rcu_lock()
> > > > > >    ioas = xa_load()
> > > > > >    if (ioas)
> > > > > >       if (down_read_trylock(&ioas->destroying_lock))    
> > > > > 
> > > > > all good suggestions, will refine accordingly. Here destroying_lock
> > > > > is a rw_semaphore. right? Since down_read_trylock() accepts a
> > > > > rwsem.    
> > > > 
> > > > Yes, you probably need a sleeping lock
> > > >   
> > > I am not following why we want a sleeping lock inside RCU protected
> > > section?  
> > 
> > trylock is not sleeping
> Of course, thanks for clarifying.
> 
> > > For ioas, do we really care about the stale data to choose rw_lock vs
> > > RCU? Destroying can be kfree_rcu?  
> > 
> > It needs a hard fence so things don't continue to use the IOS once it
> > is destroyed.
> I guess RCU can do that also perhaps can scale better?

RCU is not a fence, it is an eventual consistency mechanism and has
very bad scaling if you don't use things like kfree_rcu

Jason
