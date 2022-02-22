Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8E14BFC2C
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiBVPRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiBVPRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:17:08 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2074.outbound.protection.outlook.com [40.107.95.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8199DAE51;
        Tue, 22 Feb 2022 07:16:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFR8NuwRb4v0Gf0Vryc3VcDFklN7BuowGVu8qhihXbVgx61YV764qDRVI94tjAkCajhVIKhrasRK0qHTe2jbaBrmarkCr70LRhIMnmT+73ucnXbzrMpe3vxcTFPyC4utlSkpFh/RQ/22cPeiAOhSNIBI6/oWh/moAtlt5FmBAK5dYa9KLwFyBd26c4Fm1cQaqJmFb/teRHsp0s7sYrAfbOMOIkCX/2NlA//O6WE/5dkZcSrspgp71Vrc9vb2lBPThnpcu6ijioCJgN6kOb/iERyRjjJraSRoPImelASe7eOudqcUhGmhXtj7yyi/ME8IDh3+Vml/axOPGa/38cfuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9XzsfuLeJXNBW7a/VTPcYELUkge63lXlNUCPu5vD8w=;
 b=AGDJGys2dN7NS6EwQ+GH14HIFwaIKnHKcBeU9g6YHm7wNUpk1ndwO+LN+ls4gAoGP68ZXMNZmMJIACATRA/7A1KB1yt/ay+Tg9uMud868bwakrYodBZskdCM6a3Lk+oJ0uQSpBseZSTazgd0NlVf1DirZWVhjhv/OpSucKvNSttg1HbMnEv0emXzh+7XsxEhOjz8G8Hn+rhxdVs+ASQAccxIFsQPHIRy5RyUJnMvHiHrhLWRsfOxYwkfLIjPf/Hza6rbbWCvyOY/n8H/vVDDr51SE2q8flgo78ZT7u5WwHzPaq5BGI13YCP/gKyaYNnQR3lu/0ZcQHJ+XgPkiXmWiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9XzsfuLeJXNBW7a/VTPcYELUkge63lXlNUCPu5vD8w=;
 b=MRfrQhlbkwpgaF+69adru+szYgAHZqK5zdBuDLVpVoUQSQgBX2hmn1QkjW+s3DdrITYBI/WrQEFbZFnOmvuge07lw2NWF/y167cQ/Tjbcab/yiBZrDGGb4bjwtIbqu8ex6WMLgOPxVvRNwI0pHeTqYV1dGBfJbmlb/bK2zI0gwjBc3SWI6n7AFsP9rhhhnlxCN/3AAvtnwYfZAZ9yXK0JL21Pu6peyANkf8z+57F3JpjGutUi+33txXC9nZz68FUghOfMsZqVjWhraV6s+q1UAs2/joTJq17M8ymdM1hTNLngdE7Msmgha6gChtk5thvuBuFaPgO6ouVwag8hgcU6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3810.namprd12.prod.outlook.com (2603:10b6:a03:1a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 15:16:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 15:16:34 +0000
Date:   Tue, 22 Feb 2022 11:16:32 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <20220222151632.GB10061@nvidia.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-3-baolu.lu@linux.intel.com>
 <YhCdEmC2lYStmUSL@infradead.org>
 <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
 <20220221234837.GA10061@nvidia.com>
 <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
X-ClientProxiedBy: BLAP220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2afaa44-cc08-4637-15ce-08d9f6164fd5
X-MS-TrafficTypeDiagnostic: BY5PR12MB3810:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB381061159E93B3946002D85EC23B9@BY5PR12MB3810.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAd6HiL0JBSgbuLjDl1Ff1jb/C7N+9DfDhMRuuVy1CVIR9jyQQdghp3HNUrUAz4Aq8bPDEaySwJVOXVgR7mjHfwtRg00q45SPBy1RAcsXaLetsjnZaGYeW0UDf8MeSFXvTE9J0yUSsg5Dv5gC7RF/LbPKy76ZAJoQBX0bxiVYgTNTGpr5zv0sDQtIGCyVmE1JK5axNr3iE8r316noDl/mnU3Hp2xPINJvVxfX2hdd0JCviJCXnrWzMUjhxEWwNt6qJlZsZ20gow3d39MRpk0fKUUYfVcUrd9XHtpj3TEc7P16CmZv1oW0Zrs/cCxC+vGGtaLIve9GKR37GFMSXg7DlObvqx0M964ARwjZ3k5L38PJ6k4FBtR5aEHI6sLssqg3WmxDeKbPyA04IT7M51IzMKz3iRn+ZqDsjxsfb8jSPYiK2K6rMwoNnyBmqe5v7yzeu0kORYyrSGwCBk73rPDT7jSfNsRQXVLrJ/z8FhLw46myKC0xkPmnhZgivb56u5aUSWNueTSrNP6ne9dp0NqMp5/ATo1sHQpWDRbdrPYl9qofSLUlNu152vMLb4a+wOF+qOVDMxRn0EhjgdjXNmXjA6xSm25H24c+RyFXTpG0+dGaOAxSh32/A0AuTK1/BszDNHbCjGy22e9TY1FRtMowA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(6512007)(508600001)(33656002)(6486002)(1076003)(54906003)(83380400001)(7416002)(6916009)(2906002)(316002)(5660300002)(2616005)(86362001)(186003)(8676002)(38100700002)(6506007)(4326008)(26005)(53546011)(66946007)(66476007)(36756003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XYNuuFqGVvEsQTsjDMwaEjRgOr+pYUAUHJGOQ6NuESJPVWg+whJ0ObpvdBD4?=
 =?us-ascii?Q?BpKF0CKBqfyK6NnY5J/rZkMwfQTJC9pjzf9KjEo3S3RfpmR3bdvAx44Z0l7O?=
 =?us-ascii?Q?4IwGcwaVb9GBo8Ky6NJv9WCYKIDO9wqsnW/Nvr2L9TAvyxpBxXPVvp90ZsrH?=
 =?us-ascii?Q?lEA9zxaF/ZbmNIDTJLPkGS/Iwysm/BAAQ6GzdMXJWZ+ErI+Oh2RA/zsY8OK0?=
 =?us-ascii?Q?jqKbWwF1l7tudTwf80rSVbNWWs60NiB4cMyFAUj93vQsvfSPoz1PLR9pA5Ee?=
 =?us-ascii?Q?Lk3ahtQJnUNwFDzAApoO6dlVntYBj29iHFHIo5RT70ijU1ffF0SlmqKEYQXZ?=
 =?us-ascii?Q?1WkTB+B/BDHhb/oIqdgsShA02b9xGenCckMbztkxxgd1nHAwFs4hX9Z2eaCm?=
 =?us-ascii?Q?Yq4RHeKAZ8pXYcTyWwiC33pVY2EWf88cVKX0Cq7fF2AsBkGTIrDVDzGcLX0F?=
 =?us-ascii?Q?t8DSKvBHLDdvkSUiX7Fi63vfhEIm2cWi39TZpjWq6RPIKey1NPT285np999Z?=
 =?us-ascii?Q?J2xT9iBOb0t2b5FTFCl9Nv4fdksmiKj8vParfeBqxMRkSbsvNHYzDFftC82A?=
 =?us-ascii?Q?ambX8/4wJaBC6LOXKa6O7W+NQZkS1CDwDFfum0UdQ5qspXAJau3sgUD78+1Z?=
 =?us-ascii?Q?cIvJBhHZQQLCmzVUEShFmlyxGQqiRrI7suhSdQwtu+JL5LRc3nqkTkSEouvm?=
 =?us-ascii?Q?glU+1SY+dnIpfYNPtX9hdB5V8HvaZrZYtjyVOuvoqcBkBi8B+h5GC7gjMXuO?=
 =?us-ascii?Q?aqGz3MiJel2Z9emIe9vLpWn24BrgV5N8RavyAAJSlpr/QlKohwscV+Qk2uCl?=
 =?us-ascii?Q?16SVG6yEGlhEcTVSZieWlGIuijtkLTUiI19YwKXCqVxRWcrTNt9ih+qcn/3d?=
 =?us-ascii?Q?TliY954eAWTPVQSb5kRRpjkov8+L62zaPhSIXpRsDVU5ko8ats/JGYQ1yuMO?=
 =?us-ascii?Q?n96kH9OMUs/IKdAThGrdnBJGk5Jz1BSppqdt4L0ClK0W1q+/sePEyuA+2Nz+?=
 =?us-ascii?Q?eibbxq7u0GMBtn50urp8sozQIWuKYVo90n6m0zoVUDIAjIp5uMdr0kUVmbxZ?=
 =?us-ascii?Q?EATPiXQFCEre2+TL8fEyjiKnIFNBEfb2X/fifIsHYHhNcg4z4UL0uQEnEeUI?=
 =?us-ascii?Q?Ixvop4gGraoK75o9Z7MWSFPHj8U2VZt+l6kjws+OR8YKdVqI5hMUhEKBbcNa?=
 =?us-ascii?Q?Uwb2VNy1w6UIkp7d2Rm7xPgPvEZrpR2W8Y66KByX8IfbHSwo4z4hZ8P7WpY/?=
 =?us-ascii?Q?meRDv8DdOYhe0bpIMRi9YuGE+Fr+3Pz24Gzew1fvf192IQiGM4wJqkIwgNAB?=
 =?us-ascii?Q?qqE5LKbOWWsamBnQmSrbHnln1U/wbS81+fDYHUVuWjyBrF9IBWIREnmErxcj?=
 =?us-ascii?Q?Iv4h2P9B7w642tpO5+Sc4arJtgqjHdss8acgkj1TN7VvTVqdchNJguvWuuSH?=
 =?us-ascii?Q?RZvSX0BFGTENv5C+aX52Y+VA/SbmuRVg117P2z1fGbg0XHwe8QuvLMKFfpjW?=
 =?us-ascii?Q?e0xFKPbBn4+wDCmz6Mzr0azu2oOOGYbdKkNoRHpfoFvVTPYtI6nMQ+OpHmp2?=
 =?us-ascii?Q?jzbOBvIK0COTILTl7zc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2afaa44-cc08-4637-15ce-08d9f6164fd5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:16:34.2463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmxsdG+WNaeD8x39vSNrdESpKSwUJH/DEANfgs4nlknHIsD5OMDBaO5XjAZ3JgtJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3810
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 10:58:37AM +0000, Robin Murphy wrote:
> On 2022-02-21 23:48, Jason Gunthorpe wrote:
> > On Mon, Feb 21, 2022 at 08:43:33PM +0000, Robin Murphy wrote:
> > > On 2022-02-19 07:32, Christoph Hellwig wrote:
> > > > So we are back to the callback madness instead of the nice and simple
> > > > flag?  Sigh.
> > > 
> > > TBH, I *think* this part could be a fair bit simpler. It looks like this
> > > whole callback mess is effectively just to decrement
> > > group->owner_cnt, but
> > 
> > Right, the new callback is because of Greg's push to put all the work
> > into the existing bus callback. Having symetrical callbacks is
> > cleaner.
> 
> I'll continue to disagree that having tons more code purely for the sake of
> it is cleaner. The high-level requirements are fundamentally asymmetrical -
> ownership has to be actively claimed by the bus code at a point during probe
> where it can block probing if necessary, but it can be released anywhere at
> all during remove since that cannot fail. I don't personally see the value
> in a bunch of code bloat for no reason other than trying to pretend that an
> asymmetrical thing isn't.

Then we should put this in the share core code like most of us want.

If we are doing this distorted thing then it may as well make some
kind of self consistent sense with a configure/unconfigure op pair.

> group->owner?  Walking the list would only have to be done for *releasing*
> ownership and I'm pretty sure all the races there are benign - only
> probe/remove of the driver (or DMA API token) matching a current non-NULL
> owner matter; if two removes race, the first might end up releasing
> ownership "early", but the second is waiting to do that anyway so it's OK;
> if a remove races with a probe, the remove may end up leaving the owner set,
> but the probe is waiting to do that anyway so it's OK.

With a lockless algorithm the race is probably wrongly releasing an
ownership that probe just set in the multi-device group case.

Still not sure I see what you are thinking though..

How did we get from adding a few simple lines to dd.c into building
some complex lockless algorithm and hoping we did it right?

> > > It has to be s It should be pretty straightforward for
> > > iommu_bus_notifier to clear group->owner automatically upon an
> > > unbind of the matching driver when it's no longer bound to any other
> > > devices in the group either.
> > 
> > That not_bound/unbind notifier isn't currently triggred during
> > necessary failure paths of really_probe().
> 
> Eh? Just look at the context of patch #2, let alone the rest of the
> function, and tell me how, if we can't rely on BUS_NOTIFY_DRIVER_NOT_BOUND,
> calling .dma_cleanup *from the exact same place* is somehow more reliable?

Yeah, OK

> AFAICS, a notifier handling both BUS_NOTIFY_UNBOUND_DRIVER and
> BUS_NOTIFY_DRIVER_NOT_BOUND would be directly equivalent to the callers of
> .dma_cleanup here.

Yes, but why hide this in a notifier, it is still spaghetti

> > > use-case) then it should be up to VFIO to decide when it's finally
> > > finished with the whole group, rather than pretending we can keep
> > > track of nested ownership claims from inside the API.
> > 
> > What nesting?
> 
> The current implementation of iommu_group_claim_dma_owner() allows owner_cnt
> to increase beyond 1, and correspondingly requires
> iommu_group_release_dma_owner() to be called the same number of times. It
> doesn't appear that VFIO needs that, and I'm not sure I'd trust any other
> potential users to get it right either.

That isn't for "nesting" it is keeping track of multi-device
groups. Each count represents a device, not a nest.

> > > FWIW I have some ideas for re-converging .dma_configure in future
> > > which I think should probably be able to subsume this into a
> > > completely generic common path, given a common flag.
> > 
> > This would be great!
> 
> Indeed, so if we're enthusiastic about future cleanup that necessitates a
> generic flag, why not make the flag generic to start with?

Maybe when someone has patches to delete the bus ops completely they
can convince Greg. The good news is that it isn't much work to flip
the flag, Lu has already done it 3 times in the previous versions..

It has already been 8 weeks on this point, lets just move on please.

Jason
