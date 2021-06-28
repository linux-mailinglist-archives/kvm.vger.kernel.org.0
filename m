Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6070F3B68B6
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 20:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhF1SzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 14:55:11 -0400
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:36896
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233768AbhF1SzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 14:55:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xat6Sm7Nry/wVsas+eZoUUTJZRdWEz5OOyfIePuq/Ky0ISjL6LFDQB2wyA9+A+QkJ361NcOChPd6cp17dseCCrP4WQ2HMGRLdZmsKEey/vMbKgGdBsaNx4vsL/9W0YX9uwTiyQhjiUz4HIExr8gGuDSKeN3ARKy52ScB2DajBlqfR119uGme4pffCzSxdMnfJkjQ63eQb189QFpTJch4SNu4NmX08JJXFMsKRgGtWbkXIV2E3AEWp2NjcReBcAJZQsBMWjixlum4UFyjH3XVobYklmht947gJy3ydErtw4sTm10H0bxlwiIwRJrP3V2VzFyoIpXm1ks4tXAa/nrfyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCW+SWkA0FFfLpVpAaPNaBue7rnLOQmKcUqHSoQGt6c=;
 b=DwOq7xb+WpwD6Wwx5pqgPA/04eVotIljOrz47b+onj3+8EiSBWAv1FfYv9xo/4TjHvTn1Op0pohwTK/aq+q3LN6mM/K4Y5EsehNVmZsjouuWg/uWYmIramUJ80h5/a0/PlfKkYcBzz71dL51RPMKeUJhnRmhFVjnc+Ad855phMCZMfBML3FQOLzbHj+ITMkn/CZEBwe7zogI+ODGeDsb6q2qu3Fp7xkMn8GGoi1mFJ7P5+B6nstAAR8Gf83dHql3wDrs5w0WZzl8uuOK59LR3gskEd7H73v6DpsZkYyDJj1HMHbsVqv7EfV4WDVjpDMqFaAg//uo01gaZ7TAt45YMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCW+SWkA0FFfLpVpAaPNaBue7rnLOQmKcUqHSoQGt6c=;
 b=YuWYallSXAE8xcGChvypy/B3VhRrQg/E+6G45fE/6NlCSs1sMsAPWIyB+65mjBLSDo7vmfd7YwOhf2MN1iT+oQZ06MkrBj128HgqMW1aiyKdx7oCSEX7DmNQzkYWclwjaFqy0D1e+gUcvLt6iu191WYK9iCUj057bkq93qbEC+DmcRCLmfKoQ9phIlaL0T73JF37rLdQV1VkbzCSZ2IwQ6GyYcZB8T8RVZ2QhjfNoNuHCYLKKhvaFSUcuAd4ZuHSCvunAvIgtUzre/8RX4fPwcHf41TGN4N7R8x1Jfm+5ZMfIPVBg7bPe9qgQXHVJZGqMVS4klMG5zJCtbhYzN6Rsw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5379.namprd12.prod.outlook.com (2603:10b6:208:317::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Mon, 28 Jun
 2021 18:52:43 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 18:52:43 +0000
Date:   Mon, 28 Jun 2021 15:52:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH v2] vfio/pci: Handle concurrent vma faults
Message-ID: <20210628185242.GI4459@nvidia.com>
References: <161540257788.10151.6284852774772157400.stgit@gimli.home>
 <20210628104653.4ca65921.alex.williamson@redhat.com>
 <20210628173028.GF4459@nvidia.com>
 <20210628123621.7fd36a1b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628123621.7fd36a1b.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:208:256::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0009.namprd13.prod.outlook.com (2603:10b6:208:256::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.15 via Frontend Transport; Mon, 28 Jun 2021 18:52:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lxwN8-000iVd-D4; Mon, 28 Jun 2021 15:52:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e561715-939c-46c7-3e69-08d93a65e967
X-MS-TrafficTypeDiagnostic: BL1PR12MB5379:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5379A27A6A23CFD28DACF535C2039@BL1PR12MB5379.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbFML/J4f29gs8fVmycNxU6mBpKX5grseR2DrtHKz0mgE9mMLehJHMuqoxmGIqvXSwzvkQtozbSGScjmJagSCMLz5dTinqDc9evE4+dknE04J3yfEqVWov6g2y5UNDonPEkf6Cwyn+Z6kZwmFyI2vvoYMGMtAq/YmXoNkiNIJbDh53YiDS1a9m5ZXseHZmwhHkA6KHRZDteATQO7kIrfhEHH9ueG2gQyis6aoMe6qiXPWZHSO8DELhTbHNpDfQ0WKUjmSOf3+GkGJjqyYJyZ/SLIK0TFrozI3Xen0qX6PsyfKTl2d05obU+2ayqn8TLszEYq9KCUpNqxW/tCv3YiymnZ3hGrSlsS0YFdsNNQp1WHYMFksU+ac2bJyzscJWjJ1jtvknEAAYAaPJX4e1CF/fqglBtkacVuHizq7dUgwMjvIXRkeAF7ANWH9cddxcCIfcJfSWQfYhBpXqoSQRYDtZvouTyKYY981bgXNJu91+DzftQ0oKMp77ihH3yD2zGUkHQjnofHQTBI8vkwtvJTk8bY2ycpSui3QK5KozrphnVo6nBlPLKR2Kp0GtzFEF5sdXVlNskZFjfd2PyxTkDtFLAuyZkjU06nZmIDzstEcsxPR76QewjG4M4+Tog+f9nqjy/VaqiCG7nA0/5/iu4cfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(478600001)(66946007)(9786002)(9746002)(316002)(38100700002)(2906002)(4326008)(8936002)(2616005)(36756003)(1076003)(6916009)(66476007)(8676002)(83380400001)(186003)(5660300002)(86362001)(66556008)(26005)(426003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2BJnBDdGvEwlfbXJiWNfc09c1KILxScYA4xYgz8Obb7l2aTsAf83skMvpl6c?=
 =?us-ascii?Q?no1UD+6Nr3AtW3VOUW2Ne3ylGCg6xnc69Fno7wmaHNapu+vayDYND3TK+if0?=
 =?us-ascii?Q?xF+teBvR4emlFATbLTuPgSnSvuQ9/GUBZ2q318Ge6F+zw3VFifXTrF9SOGJR?=
 =?us-ascii?Q?6K9m2S8UdRvKfx0QJ5rpqJQf7K5kYh9ZTzdVdYT1xSY2fktg6PenkgRA7Ex8?=
 =?us-ascii?Q?FeF5w0cuzaiAFTF/pReVDOrwX8NMJHabO/aEStD7yV5Fulco/X2SmqVTDrWp?=
 =?us-ascii?Q?aqQ47ckXPtxTCB9rJ+F+f4MxviRi5isM5++Jk8Y0mrzOJ+5+uT7d0ASGhbY8?=
 =?us-ascii?Q?Qok5j0XysfvABvUIZ/E0xB007iXuc6bMn5NurpYg4BWnxqfJpMves+Z+ti2C?=
 =?us-ascii?Q?IOCbxsYkkxTpRgoYg8fVPi+qYui0UQpREZ+Ko0/ijGSS1kLsMByw8Jig7QUB?=
 =?us-ascii?Q?1MFcs0k+aWtyjtTm0zsWE7ElUOdhY4z6JbqRBJAvYXKNSrgs27Yfaa4mF8Id?=
 =?us-ascii?Q?IFWa415qVQxa8dxdqDH0WMoyeupfzgZB/rNs/8gCbEDlPgASXcjIgzr1FhBL?=
 =?us-ascii?Q?mjIh8eCSkDeHvHaAapVtzW8amcksIs73TEQWYUVwxtVpQBnnHfO+LYHzr4Xq?=
 =?us-ascii?Q?/vP+ux5dyW7OX6sUoVuJhBJQ/SHzUw3GlZ9yq2+V1+Q0GTLP0lING8TBedOy?=
 =?us-ascii?Q?bD3l/n9NpciK8gwTNx7gfa0xRTmPsaPbSPAgfSsjo9+xv9NVWI0kqXTU+Nmv?=
 =?us-ascii?Q?iIzP2p9AkhIUnCZ6D5FuTi1CIt4GW6D3jmuJyuDCtOfVw/PSQGKeGSykQFRx?=
 =?us-ascii?Q?COeQ7dI/g0fzBbzNtPnErQ6vBgPH/oxYz/VO2/O2DY9zhJ2Bv7F6QIKKTlXq?=
 =?us-ascii?Q?HwKqS1PGSGF74uXJEpuZBX4Jz7z28UJlaw150jxWz6KxssNb9bkhpyQOaH1P?=
 =?us-ascii?Q?eP3s1u762n97eV6i1tp7nARWTh2zqKlqRxRXFDP7hemRUlVwAv+C/mu/TkDp?=
 =?us-ascii?Q?UQtP8lmluzgcWiwtpjG3rJIAeZrDIVgm8yz2EUl4oIspm9ncGWwvgZ7C2g4l?=
 =?us-ascii?Q?N9CN4q9+sP3v3+TB+cYy0S4PQSk5/Y99t9AFupa3VgxRBKQELC5uZ7S8HL31?=
 =?us-ascii?Q?MYq/tBbnYAHqaomrb6hcXmuOGJCMHR947adSUztnYMkeCwOeV1X2lq10lkUb?=
 =?us-ascii?Q?E0FS73RaqfvGJZwSWXKAbT/eEbBUasiKkWU3gQpKZSOEIHNNd//1JuOLvVuv?=
 =?us-ascii?Q?WYyiZJCUNOfd4O5jCoIi2f1APQbDBfi7cnoqSjAZG3fcE8+KEErH0zr47z0j?=
 =?us-ascii?Q?DE80QRmhN6qGYnqkbf94gWmw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e561715-939c-46c7-3e69-08d93a65e967
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 18:52:43.4379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xsR4lS/RNg2UE01NI5V9RigBYaMgsmWQTc1FV/vMmb1EBB47I9YQTn9pOYOTaclQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5379
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 12:36:21PM -0600, Alex Williamson wrote:
> On Mon, 28 Jun 2021 14:30:28 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Jun 28, 2021 at 10:46:53AM -0600, Alex Williamson wrote:
> > > On Wed, 10 Mar 2021 11:58:07 -0700
> > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > >   
> > > > vfio_pci_mmap_fault() incorrectly makes use of io_remap_pfn_range()
> > > > from within a vm_ops fault handler.  This function will trigger a
> > > > BUG_ON if it encounters a populated pte within the remapped range,
> > > > where any fault is meant to populate the entire vma.  Concurrent
> > > > inflight faults to the same vma will therefore hit this issue,
> > > > triggering traces such as:  
> > 
> > If it is just about concurrancy can the vma_lock enclose
> > io_remap_pfn_range() ?
> 
> We could extend vma_lock around io_remap_pfn_range(), but that alone
> would just block the concurrent faults to the same vma and once we
> released them they'd still hit the BUG_ON in io_remap_pfn_range()
> because the page is no longer pte_none().  We'd need to combine that
> with something like __vfio_pci_add_vma() returning -EEXIST to skip the
> io_remap_pfn_range(), but I've been advised that we shouldn't be
> calling io_remap_pfn_range() from within the fault handler anyway, we
> should be using something like vmf_insert_pfn() instead, which I
> understand can be called safely in the same situation.  That's rather
> the testing I was hoping someone who reproduced the issue previously
> could validate.

Yes, using the vmf_ stuff is 'righter' for sure, but there isn't
really a vmf for IO mappings..

> > I assume there is a reason why vm_lock can't be used here, so I
> > wouldn't object, though I don't especially like the loss of tracking
> > either.
> 
> There's no loss of tracking here, we were only expecting a single fault
> per vma to add the vma to our list.  This just skips adding duplicates
> in these cases where we can have multiple faults in-flight.  Thanks,

I mean the arch tracking of IO maps that is hidden inside ioremap_pfn

Jason
