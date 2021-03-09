Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC27332C53
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 17:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhCIQke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 11:40:34 -0500
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:17049
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230173AbhCIQkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 11:40:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCTILeBDj9K0EBh5la/WxKn83x85ELo7nmDToTZ2HtwZL5BT+euZaDqLaHO8UmTEbVF3I890pCn70f2WFd51bAZjEGX+L7s6cqpBVd94UWfTiz83/4s1yqARVF/oOnJvXL8xpU/HDb416hoXbTSrD+OTGTjlGsXSsHNE2jMEoVLic1IkAxeyqles7fKf1pZgwLhT7FIweZpmdxYBwOUzxOGql9JHCfuhKbeln/QQ54uwGFarDt7WrfdsK0SfGBuqROweISGbThWj2nD96TwnG0GEfHnANeT6V4xNRveIu7h4CvZAPitGg+8YajyKWXUhdMkdjLcmGINK63QTQvS/Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tk+5D8rtkLEupL29ZJvz9k3Ir1XLCtc10QAA2RF4jhk=;
 b=anu0LpqhRt4LkwfoOO6uZqdp3iAxM6GdoohygSC+BvZGls9ww/lOd18+N7uvzRd5D1TwFVgCVPmRoF8VjXdGepg8xDdL5TCtr+kzjkQ/pl3zEF3uCu7w39a0RplWL3BhblKUJMWa7ro+Xcg7z3mjFoBFKwM1KNfzV8IZtqxb2qPFSPvmhXq6KtDHNjfF6MOp5CHWe6ppMWeVd6WKjOFN7JkBldfnawa8hv9UKA4I8uCbS/EAeqyhoj07mITgJTXdGriyYJphw4avOZU2Nq+O9NC5XWCXY/gHJGaqEYceCT2/2qenygUly7GmJyxuAwea+ouV57BSLw8tCzocS8lYeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tk+5D8rtkLEupL29ZJvz9k3Ir1XLCtc10QAA2RF4jhk=;
 b=ig5C4zdWtXRvFTwPuZgpeNYK1Qmxf454iVPmkAfO5i2d6pVq23z1M6+sawCCzyStHiUwbHbsN0QKvQHXIJ0gsjSgg/UYq8gSDNsRiRkXSQ136KZbYNCmOQtAR2MV7dHHkDMEvTeXgbXdBrhz25ChWQvzmObkkR3DKeJ6sBY44v0/1e3tPcneZAgmL9cZx30x8CjIIEPhQfdY8guETj/u2OprFMAyMH1C/lS4c26/MpcIQ41Crp6kF0IrjLdwt7OgY5kjMJhaf1ZVan176X9ywgBVldaQLzH66r/ATaV5hyKYi94kYBk16lzN1Jff5Cj1YXNFnTo9p/yUcwoqsiAefQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3739.namprd12.prod.outlook.com (2603:10b6:5:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Tue, 9 Mar
 2021 16:40:06 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 16:40:06 +0000
Date:   Tue, 9 Mar 2021 12:40:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210309164004.GJ2356281@nvidia.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
 <20210308132106.49da42e2@omen.home.shazbot.org>
 <20210308225626.GN397383@xz-x1>
 <6b98461600f74f2385b9096203fa3611@hisilicon.com>
 <20210309124609.GG2356281@nvidia.com>
 <20210309082951.75f0eb01@x1.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309082951.75f0eb01@x1.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR1501CA0012.namprd15.prod.outlook.com
 (2603:10b6:207:17::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR1501CA0012.namprd15.prod.outlook.com (2603:10b6:207:17::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 16:40:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJfOu-00A8aI-K1; Tue, 09 Mar 2021 12:40:04 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb40d947-8e0d-4345-75e5-08d8e319fecf
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739736598155D10F2911457C2929@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vk7XrSuE/oL8vbDmRY6jXWB3ecQ9x/JT72I8yKakewWBI22ZnxWZzx3sEmxFtJJV1x7+RAP7sstmOZn0bvryEVNZGzyTldjJRL/8JM/rROIJPJtcdIfBdM4Lxd6uJYvvDoZ0KkvoMxa6RwiSbK6dmbM0HeLVzNYj2SGeO3q21NIDtm43XryO/2eQIrcq1LfP2aRo3i1IBf/P+Jl8K8fvKcyK7KoJeVTqVwxEIays00FFuJyZUEMWuTCOUX500b4Usv6LUIN1JTTG8Dt5omeibBW/xZq/OqpSlfoCjwtQPntDuj/X0CscsRnqhCu+JsOj5Iy8A2fhzVsXfBp+dHjgic+Fh1A3JfX1lxHZtxYj3FIc5JquixTmDEqgWBu/UoUadBmvSraB2DJLWRPrSUVzGmoGIXO4Z3quQCuPJsGtkT1vf+bil8jD6DSqVGJTRobqA4R7AsPdcxWM2Ht2cQamTXOigsTBpTw/J2UKVGiI3bCN7aJd4zVCqsYpCDF9PnJKu/qPBVuCHJn4jhpB8lNeeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(36756003)(1076003)(54906003)(5660300002)(2616005)(316002)(7416002)(26005)(9786002)(9746002)(8936002)(2906002)(66556008)(478600001)(66476007)(6916009)(66946007)(4326008)(33656002)(426003)(8676002)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oJCfRmwHggs6Kg2gVddPrJogc9hwy/MTFNrCWsFFszwFfztChrDlZ8dGZGTr?=
 =?us-ascii?Q?QJxOrTq8XkTSaNz2Y0NGyTqvb2y1++YyF3DC/3GC6hyg0sUeO+sU4Gsr6YyR?=
 =?us-ascii?Q?6eeTzEt/UEmm/p38KTNos2KyO6mFI8TTLbjpyjYxzxXypSQeUB/cpFOR3Kcq?=
 =?us-ascii?Q?SyxJlgc+ybNnUas7vS7uY1aLggFasHNOFM/pWu7/pErneW1HRZaJJ3nku339?=
 =?us-ascii?Q?fNicEA66B0Gwd+nI3h82LBq/4vNCm/O5kvaSBinuekoav/WcjXdalS7wINQ3?=
 =?us-ascii?Q?4VmNzyy7gdKEQfto9UhSpngwR5oAjDlEyyu7NBU3rJVgd2oH4J4OomDHMmJ3?=
 =?us-ascii?Q?UKmzG8N8j1poR4Qq1xuSI/tbInRO4Q1eTlY/d4omIcoWN5jJcM5mcWlaOxZZ?=
 =?us-ascii?Q?TsH3BII8vLmhpDc8MttBk3xBvM7LWbMtBnMwYlsHXh+9WeeWUBkpA7Jxu59j?=
 =?us-ascii?Q?NfveaAV0b3h3HQBYaNTU4XTKUon1gqB6yafmMCHT6puRYciG7p+He09FaN4M?=
 =?us-ascii?Q?ZZEIGMfrFEPCb5aR2/bBQeP9yhRdMtb+yoIZrp0SpMN4P5ZYn5ym9t9uzyy4?=
 =?us-ascii?Q?fTjy8UH36N9+/PlKY3iX63Ky3SeikbnO5W5PcNUn0d1kQQXlyz//9f1sVFDT?=
 =?us-ascii?Q?6VICx4P3dLertafb7fNq0Q1/nYw0D7or37H6ZxajBKotAK2vZs603UhVtta6?=
 =?us-ascii?Q?sDdvzeNIRYgvR7bjwDGfMSRVtfs/bDgoQgjNVXs5PP6Yf/m4aztssJ4IusCh?=
 =?us-ascii?Q?BE25hnFCw1HSiDrxXRXNkn78wSQhjb06s4CX7GIw9QDuyke5KZVD0q6R+ryk?=
 =?us-ascii?Q?KzPWXTK5Nvcf4Qv44h7Otb1as+Yn5kGvWUpjoy0XzbRBawzKrGEVVnvNVL0K?=
 =?us-ascii?Q?+aVfKKSC262rCKffTY//MHAFalE5zIaRDlNhQF5v60zz3bCJj6lWfHtcLGFd?=
 =?us-ascii?Q?5ZpxVYzgVKhbq44BrBnec6MrYynXFiS3HKM+QWz8RfpZ43A6PSNXRPzwHFFb?=
 =?us-ascii?Q?kSpHYEHrcuUHLbSSnm8kW7fFjIBHXwHp2jm8aQRGCiD9OFyg7sUiPqef+H04?=
 =?us-ascii?Q?E3RF7wwPNl6GaatkYS1r+qAkwCIQdxuY6o+37F93hiPOtskG5kQXSBXwmL6m?=
 =?us-ascii?Q?Swb7nroUr6y2bwjB1ZdR002vGe7+lFa3eghn+pX+4oe73tGZ/77wk2SVz7P7?=
 =?us-ascii?Q?h1IkB63tshCxPMFatd5G6QP7Fb7a9ik43HwmpEPMCwvBEMb7/wEnc359aNqH?=
 =?us-ascii?Q?xTX6aDiGt8IbaaOnLBpDNfTrxHELpCketEcgQkAg+gysv4zfpS0Pqjn24cPq?=
 =?us-ascii?Q?/W5gW1v9Iv6wZpKfXxqiK3zN6HDGmc+AadOh4qxBRp14Jw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb40d947-8e0d-4345-75e5-08d8e319fecf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 16:40:06.6049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpoomCUSEehEMHkmxqCYjovPRTneLMkse+tndg9xU3aTdSvnx/qVysrNpVACY0l0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 08:29:51AM -0700, Alex Williamson wrote:
> On Tue, 9 Mar 2021 08:46:09 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Mar 09, 2021 at 03:49:09AM +0000, Zengtao (B) wrote:
> > > Hi guys:
> > > 
> > > Thanks for the helpful comments, after rethinking the issue, I have proposed
> > >  the following change: 
> > > 1. follow_pte instead of follow_pfn.  
> > 
> > Still no on follow_pfn, you don't need it once you use vmf_insert_pfn
> 
> vmf_insert_pfn() only solves the BUG_ON, follow_pte() is being used
> here to determine whether the translation is already present to avoid
> both duplicate work in inserting the translation and allocating a
> duplicate vma tracking structure.
 
Oh.. Doing something stateful in fault is not nice at all

I would rather see __vfio_pci_add_vma() search the vma_list for dups
than call follow_pfn/pte..

> For the vma tracking and testing whether the fault is already
> populated.  Once we get rid of the vma list, maybe it makes sense to
> only insert the faulting page rather than the entire vma, at which
> point I think we'd have no reason to serialize.  Thanks,

Yes, the address_space stuff is a much better solution to all of this.

Jason
