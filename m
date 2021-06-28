Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BF93B67B2
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 19:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhF1Rc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 13:32:59 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:22490
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232713AbhF1Rc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 13:32:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJ651lLnuVRr0yVx5dQQGlW4eLmT0y+T6r3D3Qqhrcok6CFuEpxI1GmL7F/0q6t+I1T7J9lFahw7c8s4F9cMXxvPk4hSGA5BGhGlhJ64RzyrFZSEXo/XXk2UAziqWw+clxZt0/ZoWw/tcO5hPwGz1qjamqhOU+ge9EVc1axbq0Jat9gEEy4F03/d6s7Va2ylZ0puZVH7mZ6fMWXxQBsgE97B12hwgZTBdj9JXnOcUZHsC+7ivuVQ4hrfTWhxeBCA1upEVvCt4KlsmSeBJuVFdSTkrluAERPubflgw+wWqCp49dEwXf0I+tIbM0uWerWKzOPBF4ym7tpIXQUsTlaDJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhTJVnSX1/ZX9odvq0z8OeCUWL+Zp3rlPAmsgmHq0gw=;
 b=EzMJ8i3/i22PzoSu1zr1QtySOCcmSkbvVGmDI5agisj0ojN68NL9qpsQzoe02YCbO4fa0eIvnjS8qt9IfcachCvC0K93zyuFnJKdg+ZI4OMy1rbNtbLbjVL3moEtGynfirfQjreW7tbPUE6ZUX7not6Mc4qu9A1ZDvBbu3gOAU03A9FrBeP+pIZm11tP4PZlpyD/FLpC6RyLFd8qZKSt7Vwv121cYTpVT0Hr4v0XbQO0pl/IEJehwhuvUEypjxrlsK7y/a5R59K4LsAqIR2cnYlnNg4Y+bok0faDkALLZk2CKD1vitP+85Xw6WHLhCgm9vJ+I+eQrgXQd8vVaizz0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhTJVnSX1/ZX9odvq0z8OeCUWL+Zp3rlPAmsgmHq0gw=;
 b=UfdWIKVCTpnlZk1EG0CFjWvPY6NW43ubfvo+uQFXz0BTXEwzAdvEMtn9cZZL8RH45Kbb+eNwgFvLv0160g+n7uiYg224Q9K8x/6UobJg5dJXWbPWhEhRwZW5WmIX7WUK7GgND7N/SjeazWTo1Q2nUcF5nJn0BYx33q8E/aUjU1lsSVY1D5kUtqrLUis/iHiMtWiKwc+tIPpxWCvnOBm/0OMYcChREviF0lMz8GDeAD/TzXcy9/givpFG7T5NtBcIS/+rM1HiYJPhspmyD/llNea90yMIn8lFtZkwKqWdDtCfuOPgFm/fd30wE/qaopi6EPSU2bCLr5Aexp0BRwnXUw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Mon, 28 Jun
 2021 17:30:30 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 17:30:30 +0000
Date:   Mon, 28 Jun 2021 14:30:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH v2] vfio/pci: Handle concurrent vma faults
Message-ID: <20210628173028.GF4459@nvidia.com>
References: <161540257788.10151.6284852774772157400.stgit@gimli.home>
 <20210628104653.4ca65921.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628104653.4ca65921.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:208:23c::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR18CA0029.namprd18.prod.outlook.com (2603:10b6:208:23c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Mon, 28 Jun 2021 17:30:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lxv5Y-000gtU-CM; Mon, 28 Jun 2021 14:30:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 096b87b2-e720-407d-b60f-08d93a5a6ce1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5349:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53497B8D08E845DF622B88FFC2039@BL1PR12MB5349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QXxYePQ358HDsXs0YmBzU/U6FZMxw0NPSoOc4P3SfbNdcNaGZcKF9E5CVgLVrBQeXDJj/nIuFFcIW1fNCDTuEqHly2wBYv7oqvIjrmtfeedw00uG1mACchmJDKYc3PtApVdvBBlXp8FuztF5E5d1rAK8Ct7cOAF5IheUJuk8F5WZNapU95/9METksWF9r6vAszZvaAuqQm7XsUNGgmMQo//dQNhI7VolyUB8sYBBZmzW/gLss/g087MIaizte5pfHbTLi3/7KGfMwyd+9BUCOb8jzJT8+BPgY/D0qBBQiSAAhW8iz1kg/UR8D3m5Fi8ruO8xTVd81Faff2ZzT21ElEcQ7O0LiJLpRnI5HReNYv+A2A20B7zhYadwIYPbj4YqcqHKsOznjTtRbD4qyZlTq30mvWBczO/IznvAZ+2OXki/Q2gb9GNZeld7rfRxnAbmefFwoL2bscBare7b1V0zyu7P4Q2hTd7m7s6nz1HA5X04Jw38KLatIyLYoUotEjm5x2pSTiffU/mBbAXDxjovp5AnB02oltUj1rJTPwLfFu9zRiDCH2BuG56oe7BlrY/6hj1ZlblV100kDUEs0eVfoFvYa7slSq6PhAjtZ8dSkOdihQ5hb26CLq9jcc3grzfqpsbCpzYI3aSxlWdmmydLpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(2906002)(86362001)(6916009)(4326008)(2616005)(1076003)(8936002)(426003)(36756003)(38100700002)(186003)(33656002)(8676002)(9746002)(9786002)(66946007)(83380400001)(26005)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CfSGWdYT42n1Finhknb7wkrr/ka558jhGkyXsbQFyRi4h165I6P5pr24yg6u?=
 =?us-ascii?Q?ozP2l0bpym3IXwqv5i9fPQmXex3GWQVSYeTuZJzv2x1qYDf1go32jmrGFrEI?=
 =?us-ascii?Q?w13+KvbR02BZdQvwICGjq3H9haSMw07s4sGDV+wReJhf9RdhiNgf0uoqE1rv?=
 =?us-ascii?Q?cSs3P0PNqlNvIfGEhdiW9hyGpwxV0rKROh/ImDY/Fm/lckde+Fy9FV5ZEN2p?=
 =?us-ascii?Q?MKpYiCTCuGeOnUk6AuwIuwTrHtZPkSuBxBq+rACVyKL70fA/DEr6dWL1fNTZ?=
 =?us-ascii?Q?S+Wmcs3AHPx9douIRbJgIg/LFgEztull46ofHoAt04DiE7w5i71LxVCVfshj?=
 =?us-ascii?Q?hoXTq8i+OpO/oleco4hrGcaMZX+xJQCMM848x+5Xo5jVSfBz2PHwv3AMcoCU?=
 =?us-ascii?Q?j9JKa7oPEbV0OkHmGhM2taSfLYRuwwvcZKK4PTo0D5EGf2JyKQjisfAsbrpI?=
 =?us-ascii?Q?Y9byv8UtneNpbtCPnQDDb8YJSrHwXx6Paxu3MC/TvKJ4LW4JYg6V6KlOmAYU?=
 =?us-ascii?Q?eRBdxvp/B9MxoOeX5I2vBOUsOkJXM0y+5e82YOixo4I1IV0u+qe+Td/juPwN?=
 =?us-ascii?Q?oONj32lJ41RleOmLn0XYeAA++syO9pO34lgc2rq573GYWJ2ZaXQiZZZwg4n0?=
 =?us-ascii?Q?KnkhPMWjaVuayaArPKm+FuqKYBrU9zwzv+5WfxS3x1jUjmWvyrhHlQ+k2vJT?=
 =?us-ascii?Q?Ur7ucpO1xbdobBwhmvVQf9pmviRdPYWFEmQp4fPCTeSrjENxL65NVu4QaOrS?=
 =?us-ascii?Q?DZDccCdS1O8nOurgg1gWNb5uIwEDp1y5UV1ayEwwv+W7rPDjuqh1C0Rw0RmH?=
 =?us-ascii?Q?4l7a+owkXduaMn2f4aDcVYlhsNwXO/bI+aW8qxVPI0unZd+0D2rfY/01Jo9p?=
 =?us-ascii?Q?6R1Su3ubZEWYBUsLynPsUq9WG4BCKFk/JN0jE8U3u0ikZpO0w+GUCbJfxnRJ?=
 =?us-ascii?Q?k7c5PXqisSVyw3dGRR825+cWRUQMqVhoC7bk1+8o4AeH1NnSzVqV+q+47hJb?=
 =?us-ascii?Q?aI3IJkB4rp+vtA561n5I0UFd87E0ZyELrwm7CrXW5xz++wKA39pgQFqOJiPH?=
 =?us-ascii?Q?3DUc9jj1+hLOuu1z4n1DUHbvveFIaygNEsqBhpnPsLEmt9LN1NejcrAY0CV6?=
 =?us-ascii?Q?O0MeVTRAbnBke3mxpULCmun+GimXDO/QTgnHF/Pt76v3xVsfm+wb6liYCh+6?=
 =?us-ascii?Q?EKtk5p67yT2wvIQHoZWr9/hhxUtYjtZ/kD7Yy2N4ZaIWy4Z3Rbsy1ajeM59K?=
 =?us-ascii?Q?atlrwXpgR/r42x+H4ht2FwGVU9+m5K8IUgxpTr8HxvaeAAJSIof7CLh/DqFE?=
 =?us-ascii?Q?MygCCHYeEpzaprZx3sflDdiG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 096b87b2-e720-407d-b60f-08d93a5a6ce1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 17:30:29.9388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e183qpwCog+cPbiJPbe45fVQQ2UxLG99PnEJHpnJYMl3Y9hvkZeG6O2CejUVmq/T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 10:46:53AM -0600, Alex Williamson wrote:
> On Wed, 10 Mar 2021 11:58:07 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > vfio_pci_mmap_fault() incorrectly makes use of io_remap_pfn_range()
> > from within a vm_ops fault handler.  This function will trigger a
> > BUG_ON if it encounters a populated pte within the remapped range,
> > where any fault is meant to populate the entire vma.  Concurrent
> > inflight faults to the same vma will therefore hit this issue,
> > triggering traces such as:

If it is just about concurrancy can the vma_lock enclose
io_remap_pfn_range() ?

> IIRC, there were no blocking issues on this patch as an interim fix to
> resolve the concurrent fault issues with io_remap_pfn_range().
> Unfortunately it also got no Reviewed-by or Tested-by feedback.  I'd
> like to put this in for v5.14 (should have gone in earlier).  Any final
> comments?  Thanks,

I assume there is a reason why vm_lock can't be used here, so I
wouldn't object, though I don't especially like the loss of tracking
either.

Jason
