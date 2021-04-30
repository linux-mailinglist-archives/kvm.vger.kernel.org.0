Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CFB36FA72
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhD3MjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:39:00 -0400
Received: from mail-bn8nam08on2056.outbound.protection.outlook.com ([40.107.100.56]:46240
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232276AbhD3Mi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h74nqhLooHmsdqU+GkpQbSRjiBTzZokrQAD7UDIzk/Sr+Cx0wpj6PhmkTJYD2BmFNlp0EY7VBQ3nhmhXFIPHUerviXknWt+oBeH1hQ/nVpwCgt5mEg+Ej4W/qRh7DA36Bu+0y4OFVHNm9LkB9E5upSP8OirXm1CH2gjnzwsrGMWxfb327VCYWmqCSBvuoAgTgjGMU0NVr0DyTRfHzlwY1KrYi8JM7KjoYz0qYE+HchUDEBBhOpf4tH2gfxjvuqYKcMC9IcMdSWepTpJApncseOm1RPLPmt4L/Mzc9nrt4pJVtu3gUydEfPU6Il4HO9u0iHTJ4sNKGPNMaoNVZsHcRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52GXFOl/ii9pTZEjUJQyiOxXKZOlDXL/7lqIX/JA58c=;
 b=QbuHtUZU1sY2R6X8eBdwIRlr/xMZupVwOvg+YHpcfgqkmuxm9Fkr7K1oFlq60ckV4TSSz8OcxoMfESwB57OVt+eQRyTSgEv62gMwdBE7ON7V8CuxnHDrBaK5mLynul2hC37mpBdlIe4FL3nH+g9yf96FafU66Qu9Hngv45BSow90OcZbV+ZvcDvxopurbNxbgip6lNvBwg22Ka0YO3EQT3M8nNY73KYZMyXKEaOetgFyl0jFrtpTIOWh83dNtEtDzajFVWe3oUgcpUuoTp6qip0LO133RFTryAc/icCCEUvqJUodHVrFsFG+OOmfLY/iqI/WDPcVXFWrpCYZiLGO9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52GXFOl/ii9pTZEjUJQyiOxXKZOlDXL/7lqIX/JA58c=;
 b=NSe1siURRa22mfT+Pe7oDeIwz/SMUG7WXFQnTmW1O5VuFqQpGSJmFsv5mPasIeW977vms9sh3VR8I3S3zHIeShzd5OiT9A8p7c+DDsIpnBD3I3swdI3wmk4GZ4Bh2NDIMno4PBVT+VhbuhDiXLtu+6XvaSiVmzsGmTbfog/+ClSsvH8u7QhP5Q2tj/5qH39RZwFYPg1horWlme31ZxrwrSonpKaxyi7MrLSBAeXxk5Htn19pWgKaypXviAKX8n0qszlTwfTcKfVJONOgKxej1l8TyJUqsNGcqsJ8F1NPWwb4WuMzJO22ZQCFRltqc4ql4JFkJL+kZRFclBztxY6Vxg==
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3020.namprd12.prod.outlook.com (2603:10b6:5:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 30 Apr
 2021 12:38:08 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:08 +0000
Date:   Fri, 30 Apr 2021 09:38:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Shanker Donthineni <sdonthineni@nvidia.com>,
        Marc Zyngier <maz@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vikram Sethi <vsethi@nvidia.com>,
        Jason Sequeira <jsequeira@nvidia.com>, benh@kernel.crashing.org
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210430123807.GB1370958@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210430095417.GA13686@lpieralisi>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430095417.GA13686@lpieralisi>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:610:77::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR04CA0046.namprd04.prod.outlook.com (2603:10b6:610:77::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Fri, 30 Apr 2021 12:38:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lcSPH-00Eh4x-6G; Fri, 30 Apr 2021 09:38:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99de3d75-374a-41c8-7903-08d90bd4cf08
X-MS-TrafficTypeDiagnostic: DM6PR12MB3020:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3020801D48350A201A410761C25E9@DM6PR12MB3020.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MPtfkKbafPdGzfAmzajJd1HazVDS0Cny9mhTshoUo3FnYpxcVMnC2whTR0036PaDG/kJ1ikW9gYQFYlGsKsIcXFKjswP3T3In08UhRg2qCK2xiyEDG3xu+LFizT3JFpcOD5OuBx3XcxrZ9LGUkvCgK+k+tbSIj9UzFTjroZQkYrE0uNKtbXNo2MfnxRgkdWb4Xvk2RdqIvmzefdk91jUk12ROwbJxKSQNOefERBzNBmavGLHNgG7/Hn01QskYeCs4FZiTADWh+4NjLfnhJLwNldMWBzfmzgh8BzPD/pj1e1/IKjmZdTWrDW53KvL9rbIeUrf1+J6CLL9dbq/f/sglDpCbPYDDghArMQ8AG57khoLlDhLZLhCP70DGJ5CuT2gXk/BIMZscgnhJWD/tnko4CFqFPkUVRBaEB7bSrPoJlTvr8vyDfAWdP+/g0ZuTSWRXSrjPkpvbwcjgBjq/QYsCcv/6SSh/6kh7/RnXDB+Om0XDkmTueOEZIxZypdoptJepnSqsxYwNs8VbNcK3PYFfDuSai6NbnIaZao55KCZXWwkEhGCgChIuQw59tUsfi8EDsz2WvMBAHzSVWZQuh0NDyeMQqTfvhiHKUPtHWsuLbl63bE+vl6K97f/yqmaWnO8qDUzQA05XniF2zvGSZ22esC0nVydUAs8Xtra1UPfdvrptXoOHDzoepCdGvMb9qD+ITrnhTB4kY4FaaC98k5e3CWToMSQ2WPDp4Al7Ys7100=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(316002)(33656002)(2906002)(66946007)(186003)(36756003)(54906003)(9786002)(66476007)(8676002)(9746002)(4326008)(5660300002)(66556008)(7416002)(6916009)(426003)(2616005)(83380400001)(1076003)(478600001)(8936002)(38100700002)(966005)(26005)(86362001)(3714002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sogDj5vxgMqNqCpWL7hATIas/EmaE2fIUUjktGD+i8qgOdxww2H2ANG/JQhm?=
 =?us-ascii?Q?gDc7+INkcRt5T6o55XKeMlJv/LslqOb1xvHsaw1TzeglrmL6OTIr6/dFL7VE?=
 =?us-ascii?Q?Jenl6bc/znJqqdkC+zZac57SXatM+BXNZ4vbWTlG8L/EKUnRMeImpGUWkK6+?=
 =?us-ascii?Q?8nHQ5ZHd0CqcbqdjSIExAJ7VkWBup0E6E4LWW6CjqB4RpTJHEga4e0huwsGb?=
 =?us-ascii?Q?eSFI8KFxlxFf6gvm7KZTXHNwQr8fZfrcD7LNvrxpINW7/GFrMWj12EQXQLmd?=
 =?us-ascii?Q?vdeH4PYFod/y43uxHBSMetCnxMJxiLtZt6UtMO7rBFuT5aCYJJ3abOexyurN?=
 =?us-ascii?Q?bkisDFzotfT/gEELJn7wcRcAYzAOCrclQ2z24zbujsB3whW3bjBXIXXCvwgx?=
 =?us-ascii?Q?2mHjxD7ORGLvPSeZF28vIuqIwYoolSZpHDM1NTkKesI2JBG0xaLwJtV3r0eo?=
 =?us-ascii?Q?eQ4s4V695tmKuGrFGhGGsUv4+Uf9YtRs8vE3Iahg/dJZ6AXZaGOIzMkbUVfs?=
 =?us-ascii?Q?RqY1dntHxPr0yoDG9IFRDcUgjmpoiFRKxaiuEZhJgMck5wEo7ARapJRRstQr?=
 =?us-ascii?Q?+FRpkqYqzyGrq/apwToShZVYO7O/hztMozNDRAWfdhlXrX2K6Lx15Z4NujYn?=
 =?us-ascii?Q?rpKtpTop2leVuNiGQdILFuKQE2TXLFw8VJhfNVIdSWUdHwQWBwF/rsoYlsi+?=
 =?us-ascii?Q?i3+GAZsLtp56to4ZV6iUxn3wtie718SbdzcUzZnmrfDYTyvVYvO/zwWqCzXU?=
 =?us-ascii?Q?5sdSmmHDnc6SZLAYiMVaTMOyTV1qCcYtoG+P1vjp82gKx4PbzkFSJoNonaoy?=
 =?us-ascii?Q?3hUG48ALDo7jKGEC48lwkNpI89PO6P5fGNp5y3dFH25Qam1WFWB/tDn+ahor?=
 =?us-ascii?Q?fYqqc33HRhVSiueQmB8HU8M23r6ts9BVcwI49HBu2vJw8h7Fa1OhIoDPphGd?=
 =?us-ascii?Q?5haIdDpSYWIiU/Mx1db6Fr3vHus0c++QpZSNW12r2QIfLuUMZ7rSCJUZ06z4?=
 =?us-ascii?Q?jHx9OZaBUFsE5lZoeK8X+jESoEDYMdDKPU+VVjaAX7mIi+OTPoivlRFvnsPe?=
 =?us-ascii?Q?l/d9gAaA6RBiZ4vK+dH7trlId0Nwz4BtEfggekkaWwAdNjPWWViVO1YLG56A?=
 =?us-ascii?Q?jSJItbZKxYlIk/sUIknd8vcuv04KIvDkRlWw+d3O07fzz28GmLyaXpCNJpu6?=
 =?us-ascii?Q?LTtZJ5oEqrb0REEOxmZ0JSIu9hToQRnS6QraqRPM78Sh4YGm23h2GRvKKZSP?=
 =?us-ascii?Q?39uNEGc73uaWZPPbXZsZfkgJV0zST5FgpiomDIPRxp7uKsS9FuIxN5yVFWpG?=
 =?us-ascii?Q?v6NRiTQbnJ3kdLO3xFbR3GSA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99de3d75-374a-41c8-7903-08d90bd4cf08
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:08.7075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFKw6aJfa9HR7LIuydB10DnDhefaeEWTunW1Jl8Elr0S/xE9+UBZYz0Ra/RK5rwP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3020
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 10:54:17AM +0100, Lorenzo Pieralisi wrote:
> [+Jason, Ben]
> 
> On Thu, Apr 29, 2021 at 11:29:05AM -0500, Shanker Donthineni wrote:
> > For pass-through device assignment, the ARM64 KVM hypervisor retrieves
> > the memory region properties physical address, size, and whether a
> > region backed with struct page or not from VMA. The prefetchable
> > attribute of a BAR region isn't visible to KVM to make an optimal
> > decision for stage2 attributes.
> > 
> > This patch updates vma->vm_page_prot and maps with write-combine
> > attribute if the associated BAR is prefetchable. For ARM64
> > pgprot_writecombine() is mapped to memory-type MT_NORMAL_NC which
> > has no side effects on reads and multiple writes can be combined.
> > 
> > Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> >  drivers/vfio/pci/vfio_pci.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> A bit of background information that may be useful:
> 
> https://lore.kernel.org/linux-pci/2b539df4c9ec703458e46da2fc879ee3b310b31c.camel@kernel.crashing.org

This can't happen automatically.

writecombining or not is a uABI visible change. Userspace needs to
explicitly request and know that the mmap it gets back is
writecombining.

Jason
