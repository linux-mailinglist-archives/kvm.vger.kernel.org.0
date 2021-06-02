Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9BF39960E
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 00:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhFBWrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 18:47:24 -0400
Received: from mail-mw2nam12on2044.outbound.protection.outlook.com ([40.107.244.44]:13185
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhFBWrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 18:47:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOjtbVyhdbcRQlHM/PEFPKWjX+yFoGKbWar0FLLZTloPLvAek0vrg0wIuFVhbdPF53vxBg17ObZXqb0jgqHben8xsYpnCSndBOaL1PzCCPS8wjdvcF75mpFtOA8n0KKU+9yAnYOzDpbtRqASG82h3saD8E+yOqiVrq1EekMOVgsbYWCsIIC45/DEtCE07RaDiVuVmo0mG57Gx5GwbfZosVLnrWqnFs6/kaMY+MNvs55qbUGMFatz3MmnUXy5SOatOX5FsvL1eUBwWN3VEaeM9pgO/+Vt+k1XGdwOIsrzpJJnunTllEPkjOlhQyAl+xcmnfeOKKqmUt8wB40dmBvIBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deSCmlsCTHLY0GUJC9+5x2cw2I5JsqKTKGDeJKK6Ftw=;
 b=knnwK7C/lgHo0O2wtgfChWDCGV4VMLjg+g+K7ycNizHTkDAQsM0ZV0R2oxnbiBDLPU2+leixi5QUgJ98deuo8x+QF1iIXLYpjryJ/6Ux8xW2pJX/88bY+2EcY3X1fvxrCusOKoJ5JWTcBuYd86iOtm6AysXFy17zKDGuWlEYSh/TPuGB8I+BpxzncyBgRUVwaxB+fu+KLSFEX9SMtG73hulIa+Zvo9uPpgeRDJVnsXd39dpziEmP9RseHkA6PLime7B0CNezmowmfSZvq7J7cStPneIuzxsXMnzSPtXeaaylmwpKOBRRBnSo3ueNUMit3KPf4jsPc2JMiT79PxLzjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deSCmlsCTHLY0GUJC9+5x2cw2I5JsqKTKGDeJKK6Ftw=;
 b=WNa8HR01X3dboHyhaRUgjGRISbiKHgRzzS53cm9MDumCT1iCDG9oAhFzyKO0MRuVFxs2bPaLwTw1Uangs3D5Zd4Rp5SjDaCbF2NxvhmbA+wKuy9lIgcER/g062EUfIuFOLeWqXnf7T0AalfD5kZskxymLrL+YsRfIJLU24MBXyJBgCsmydQH9Ltum/tSFS/dNXMdcO/qjmw9dNOXUIkzG2bunLC1tSKcuwXacGZKq69T35vd2pfLTU5vzIkBdXGM6bVqGInA0Alhqr3QOdu8AQFGZvzfybXT2udUTjTP3X/+S24YMC6JrmGMJa935vN6RA9pxfUTjQ/7snWXoX47MQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 22:45:38 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 22:45:38 +0000
Date:   Wed, 2 Jun 2021 19:45:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602224536.GJ1002214@nvidia.com>
References: <20210601162225.259923bc.alex.williamson@redhat.com>
 <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160140.GV1002214@nvidia.com>
 <20210602111117.026d4a26.alex.williamson@redhat.com>
 <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602143734.72fb4fa4.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR0102CA0028.prod.exchangelabs.com
 (2603:10b6:207:18::41) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR0102CA0028.prod.exchangelabs.com (2603:10b6:207:18::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Wed, 2 Jun 2021 22:45:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loZcG-000e0c-8P; Wed, 02 Jun 2021 19:45:36 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ee42dc2-6f5e-488d-fda6-08d926182428
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5539B2383BA7FFAE30973784C23D9@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwIuYnJnkm+p+zULsrEDEOQZBgfGs7dbA8rCSydAeUaXfdBdo4ApZJwg1Y3Ce12kFGd7B0WhJwEbtS0Vk8lnc3GTyzxd64CdSdQP0xea9rW9BQBqqHlBHCinkMVrvxz206Pv7mD0+1B3cbP71331WwGctwpd7ZPVQEa9Jja4r2UTGMMmYVOcOQ1EIv5MkGSM9q0Cczt4YN9zt1wLmlgRzL+5dYuMuVwWWlk6ccLiUP0mTDap1egO0FVCxmTAiH9HKIEVJ5I8K/nUqyt+kG9HemAas1D0doK6am2sILxEiKeN+OXRtVBPOTLfHGiOhgPlVvmJ0FHgS/PG87ZUEgOmM73mAP+H1nmDGCgWDhdAV2CFIjQHlBsH0Rg39M5yAECiguLWxz/2dQ2e95NwuLC4SWQ4TbOtmaXjD8zsdcQQL01zkGExP5iAqAOTywyDjRJPA9qDKtvAiI90Xd+XZQvArRuk9XNz49XKWy9Y3dGv1fnVWSL8GoZZNoW7nuaTBKCZBSV2bluoq8DcF6nJVzasNELB9FY3LOVoWY7MVZ876c8EzLuMnJqix+dJS3kscNVjJMxdSbWlL6Rh8ukzv88VQluUCVdNDKvePgoXwHRiMh0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(5660300002)(9786002)(7416002)(66476007)(86362001)(9746002)(4326008)(66556008)(1076003)(38100700002)(66946007)(54906003)(8936002)(33656002)(83380400001)(8676002)(478600001)(186003)(26005)(2616005)(2906002)(36756003)(6916009)(316002)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OKQ3WZKNqF9JTACPmchSpOnmZta0+zPGiwzrdhZ5ULORb14EmEKO8mksU3Y1?=
 =?us-ascii?Q?lIUfiQm5YkxJTxZJ93NFY8pvi6WeoxWavnUpoYjGHAVrpRtopqyqdmbM/C/W?=
 =?us-ascii?Q?QAX171hYbGabC0iglz7P/uAkb1LavOk/vRmTi+kPDmCxGJGOoR3i41Hd7X4J?=
 =?us-ascii?Q?c6Xn/0WC+e0jFvn8AOSDMrqDvpGLO+iDMscWomDOZAOSsqnSNlYdSiDm+kZY?=
 =?us-ascii?Q?qFEOpl5CB1yt09mwGbMkFHDB8w/0d7d9TZoFaslQPIkc7NrwST/G0j5b3Vfp?=
 =?us-ascii?Q?jmI7jGfDiB7QbXK/QbOFaEL0DXjgoXa87VzIwm5Pd8EcY8IEPPLZSSj+XAji?=
 =?us-ascii?Q?8mPB235KWnQ2QRxu1ckwoFfat9KF5WV1/mNvU8wTCAJjd185CdGkXnEsFpTT?=
 =?us-ascii?Q?oAivEDrZsF/CfreePYionrH+MxCDDckS/O6gIXOEnFlSRmIrN+++cV29HNzk?=
 =?us-ascii?Q?8LVK/K+XnfKIaeSAbCyermfW+hzf9cXCJqfzJSlEA5EQqBrvZp4sHEqd8LIk?=
 =?us-ascii?Q?j07hcWbKmC3Ks4QG+lVHulnDCLxFyUWfn8wWOPNCkRSTR298l6NF4BQJZHnu?=
 =?us-ascii?Q?I8R3omC2nGsQqbsjwaUIVI1SN0eaRVoTP1wRU1QI/0JdPxzxOoyogw8BsHnH?=
 =?us-ascii?Q?89dqYGqMU3NCNWVwscHlpOGpzoJIpIF7yD0oWlygoeyuqXXM6CutCIYnksA5?=
 =?us-ascii?Q?2kcb/W34/PzNh0eQHevVf2v4kDLZhR+HB5pnwDqLdxVXNKUbuqKuK7bwjEBf?=
 =?us-ascii?Q?VfiE5jel/X34cVM5wF35jcbnUPd2D8VqSml+jAn0RA8FyqabRY+IF5jmCeJq?=
 =?us-ascii?Q?z0qBHxETVky6KJ882WE9tWf1XBKKBBgfk3U4cZVoiXGPQwyiZ15Dee034Ju3?=
 =?us-ascii?Q?JHEZSJgTQI+HkCGbBhQjC0EOjQ9hmxPnUWGKieb39DxLE0BEQb8wnJJi/3fg?=
 =?us-ascii?Q?P0vtKG6RyoFqH8UGq6yy05qVwSyR2FaxxyU1AEbI76h5plv0ifJENPU5AtBT?=
 =?us-ascii?Q?nvUrgqmPe0iM0JXULN+NiP9jnMj5iP8vTyx3sUqATh8LXMy8GmEScI8Dt0+u?=
 =?us-ascii?Q?nwmk44OR1aHVCNgADQDZKg29q40bWOefLVh8LWmHn8rRc2PdABApUpT0lM9y?=
 =?us-ascii?Q?qKZshAnaaEzZFn22XmDYwviixwvDOMZiaLqklRr5c9Snx0sXVebJQqjJaop6?=
 =?us-ascii?Q?0jb130whpf2dcnk1RlanenOV0k0aOPPuYtdT8LITbUBavvE1HWoqC1BpzF6P?=
 =?us-ascii?Q?OtKmXFTd8j13UpWv+sV63EgHs4Kybm++ZiO548YRRYSqKiA+QjoAdQ1ejn3G?=
 =?us-ascii?Q?9ZIvA8n3YECSE5U+FfGAY+SG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ee42dc2-6f5e-488d-fda6-08d926182428
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 22:45:37.9692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 89Xn8Dej4y00SO5fCZDnoFyjpE6Eaj2z9Z7YXVijG6AYkjbiiB6b+QyK1akdsvZn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 02:37:34PM -0600, Alex Williamson wrote:

> Right.  I don't follow where you're jumping to relaying DMA_PTE_SNP
> from the guest page table... what page table?  

I see my confusion now, the phrasing in your earlier remark led me
think this was about allowing the no-snoop performance enhancement in
some restricted way.

It is really about blocking no-snoop 100% of the time and then
disabling the dangerous wbinvd when the block is successful.

Didn't closely read the kvm code :\

If it was about allowing the optimization then I'd expect the guest to
enable no-snoopable regions via it's vIOMMU and realize them to the
hypervisor and plumb the whole thing through. Hence my remark about
the guest page tables..

So really the test is just 'were we able to block it' ?

> This support existed before mdev, IIRC we needed it for direct
> assignment of NVIDIA GPUs.

Probably because they ignored the disable no-snoop bits in the control
block, or reset them in some insane way to "fix" broken bioses and
kept using it even though by all rights qemu would have tried hard to
turn it off via the config space. Processing no-snoop without a
working wbinvd would be fatal. Yeesh

But Ok, back the /dev/ioasid. This answers a few lingering questions I
had..

1) Mixing IOMMU_CAP_CACHE_COHERENCY and !IOMMU_CAP_CACHE_COHERENCY
   domains.

   This doesn't actually matter. If you mix them together then kvm
   will turn on wbinvd anyhow, so we don't need to use the DMA_PTE_SNP
   anywhere in this VM.

   This if two IOMMU's are joined together into a single /dev/ioasid
   then we can just make them both pretend to be
   !IOMMU_CAP_CACHE_COHERENCY and both not set IOMMU_CACHE.

2) How to fit this part of kvm in some new /dev/ioasid world

   What we want to do here is iterate over every ioasid associated
   with the group fd that is passed into kvm.

   Today the group fd has a single container which specifies the
   single ioasid so this is being done trivially.

   To reorg we want to get the ioasid from the device not the
   group (see my note to David about the groups vs device rational)

   This is just iterating over each vfio_device in the group and
   querying the ioasid it is using.

   Or perhaps more directly: an op attaching the vfio_device to the
   kvm and having some simple helper 
         '(un)register ioasid with kvm (kvm, ioasid)'
   that the vfio_device driver can call that just sorts this out.

   It is not terrible..

Jason
