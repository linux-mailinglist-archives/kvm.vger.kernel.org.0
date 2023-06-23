Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C3B73B692
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 13:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjFWLq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 07:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjFWLqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 07:46:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DBF2965;
        Fri, 23 Jun 2023 04:45:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8hBoBS3ThNMqttxlljAc5Gf4rDGlAgna97bA3j4MEC+tKjFDlsUJMculEWua1oD2MmXeDb7DDLqP+ZYFm8GQ73TCNJZ1ma6p5aQfzxx8WEJLfkhAgiX58lyFzdsCSaDiL4SzL4A+VMgHgEdkna2PniHQv4eOXB2HcmxQ+troodJL0nLt8j30qz5Hx8Jk/P7MYFh9M0UO/qjNK04Drnu/U/jndIVnauHPay3656uqQPZ1DxBX8eLFtvu5QirbuwjvWnwQiBmic4Vyw1K4MjyftDLIrv7nijAwdyTgO3/05j5X0h6U+FBzFJvFhYHqWcdPrDxq08nti/kBz0mpEP1Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLWAiMZKRwYfwbBYDPMuj4chvM14f4nxoRK8EdBIjUg=;
 b=lKv9cJUjpYzA9RaU3/woMYqufbuc4NEVo9Bcn251IzYWK3/yydidbxGA3JAHh6bR0TMjXjELeTxnKSI+NmLfMP0iHjSZWh4xKAa5Z5eHs+cI30u3PH/fryWXsdDAS1on54u+Zf2lb0HtaZeYApfH3qGqUtRAiOPkF5OHH4R6GAdcJbXhWVxE7cASjTekflMODxvArBZLR2NHmMJsMpAStgmIhmJM3K+LVn22mNirM4h+yfLZyIXdbytXyFG3ABOR03DeV5aaLe9RLSaCZkfY+qf86eDH1sc0E0KYB7b6U/4N/ANYZEBU+0uUPI4qjt+ZReXSgj0mRvdjQpONcAL7CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLWAiMZKRwYfwbBYDPMuj4chvM14f4nxoRK8EdBIjUg=;
 b=qu+T9r5h3xvKDY8iAImqkcgcvRNdjh6r3Nf3k3/xCqjPROifgPDpCdWWFNH+dS5qVGj6xuo6DWlV3S731O6weAnpyG9bk0JmjDuVD+c3cSLcDfRRRPgc8ZIBOyXm41h8cZWXfZhfxGTLzvFFWNpdT3DJmMvVuhoK1CzZstldLI08MD/9w20tUac7if3qGiE3YGNbVanfdE6xsABfcpKqHfUTFNskd+2u2z/9iK3XjaVp+6A+uS38shfjBqrHvY+pbnLR83N1t0cQSJUgwLkiI//zGm+INF3rUcPQTTLAPNak6S+KxKYCIF19tm4kZ7H0sG/FZDdWJyZBpyldiJv5OQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4496.namprd12.prod.outlook.com (2603:10b6:806:9b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 11:45:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 11:45:36 +0000
Date:   Fri, 23 Jun 2023 08:45:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, joro@8bytes.org, robin.murphy@arm.com,
        yi.l.liu@intel.com, alex.williamson@redhat.com,
        nicolinc@nvidia.com, baolu.lu@linux.intel.com,
        eric.auger@redhat.com, pandoh@google.com, kumaranand@google.com,
        jon.grimm@amd.com, santosh.shukla@amd.com, vasant.hegde@amd.com,
        jay.chen@amd.com, joseph.chung@amd.com
Subject: Re: [RFC PATCH 00/21] iommu/amd: Introduce support for HW
 accelerated vIOMMU w/ nested page table
Message-ID: <ZJWF3oVvdj4OQmTf@nvidia.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
 <ZJRQseaYkTJGHNsk@nvidia.com>
 <7364628b-54b6-b7e3-b272-8f91198679f9@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7364628b-54b6-b7e3-b272-8f91198679f9@amd.com>
X-ClientProxiedBy: CH2PR19CA0029.namprd19.prod.outlook.com
 (2603:10b6:610:4d::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: e1779985-37c6-4240-e4b2-08db73df5c49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +U76LHpycLXYJOsWkbR8l2q1UEUQQrolKLhniEo4ZFBQ4ojRJT8FQQNu2vnOwgKRLke75QhPSEit8gcPLtAqYVqBvDB0YZHbwLma+89dteHJw8tvS24MJ/CQWdbjDBfdSLs/1vFc8DiAZT2jnNjroO4rRBi5pGeDcY/71TQEV6zP56lK1rPOFyLCIgMJEFMmRiJ0czpWXzQ78Dp5b3ExLI73o5VY75omFskcCwejzIvfYMb3PfwMCkoPytX0sEh0QDT3agzaA/8CmUGjYdaHzy2LovMsBj304OQChqSSqrcuH74HtK9qZL8Up/W2r7/+YWa6nAmz9a2JiyXCH7C7BWW1xti4q21a9f+64Jd5w+I9bJoH3XQjjFI0ohCie08KzLI5IECHC7peZWzBfCcu8ZSYm6obaMci6zykr8parARrcBC6Zra+AnIrFYit8vhN9r/sroGOAGfMNqOX/0leBd+seKndx19xXCsKMo3YudDANenSff1k7wng1tSaaVd9V0NBgGCfCk85oAidZngq/yR6nr87lHDfzGVC+Wj81z3sYZpDgTDwm1oopppX/LHH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(451199021)(5660300002)(7416002)(53546011)(6506007)(2906002)(26005)(6512007)(8936002)(8676002)(186003)(41300700001)(83380400001)(2616005)(478600001)(38100700002)(86362001)(66556008)(6916009)(66476007)(316002)(4326008)(36756003)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p8mK4zAwDu/qeGqLBMIjPVvxtIvkvbJyynUeTL0GY67ZOnzGUhjvHs3uXJGB?=
 =?us-ascii?Q?hIq8L6TaMYQ6SIBR0Utb2kN1HZTLp76mVloquLt+RA14EOHuwiqneUFrt3t6?=
 =?us-ascii?Q?gOCaEaAWL8nKoCvdpJk3F3zGBBAf1kEkdMyxePj5MLWGJM0ROAzk6lNEUYsF?=
 =?us-ascii?Q?N8kVRTv5lmdRMbM7Wcbd+povy5j4l5EPk5BQKKk2ykgrIUnzth2eW4zbL/II?=
 =?us-ascii?Q?K/qfm4JNxqALbHBINly+R9N/x2OjnuAutE2O8x23RXdfylsIn75x+CczYbS0?=
 =?us-ascii?Q?oT5XrLR4ZE1XMlyk9O07KTlT4pk9q8bhH0NcClsifmZjjp5m6Ey1WZCEyLU0?=
 =?us-ascii?Q?iTjIgCaO733951CiWkKgVyEkhwd+FfQBqe7oO/rl1S+EA35l25pcDmqYBwMB?=
 =?us-ascii?Q?DhpBnVLvg0ueHwcYdhuusKvNjgPJUxN6kzVpKDMxbwI11Y08qCO6gKd3jlSf?=
 =?us-ascii?Q?JwP178ztXMVlX7Hy0ys74jixU1tId5tfVzqoMxvOFOZE7FcFsnwy/OMfalHL?=
 =?us-ascii?Q?BCsaGUSnyiZTwNOI1tYXhDS9byws3MINzs4FK7XQIjB2R5mosIzP8PKlDHWE?=
 =?us-ascii?Q?lrKiKMDLsfsiUT4AQTLoGsM1UVlbwED/MqcP0+DgQEE2eFLXK0BRMdfkq2uh?=
 =?us-ascii?Q?BN/1OwswmWPC8xtr17YT63B4zS5I4ahRolYNAxhArGxzHTXVTAwASuLjTEUv?=
 =?us-ascii?Q?iWTtt7LNKI3oFjSCgX4Pc7O2+IeFoyKwVdz/OalDAthZ8nQ2NHlTtauEY4nX?=
 =?us-ascii?Q?OfHFiUspLUkbnpDQvHm78MhHqfR1W3PeTDc1lp1+ZB7bckpM+0IuvWmJDU7o?=
 =?us-ascii?Q?nocs4obMZmbtdHtd6pMgil+24SALrZYiF3ZkGgJQp1Jgj/wHjVqDxF8uzF23?=
 =?us-ascii?Q?UkxyO/fpbGUFU0UYgUNmk0saFVJvPYIPFF1TZnWEbGRzIeFetRHqSBMrUVPr?=
 =?us-ascii?Q?nKR6/YFH2H2cOznEeSyfmRXyBB18ECyLG/XC0t5A0zSySwsoHU+R2v/CtoJ1?=
 =?us-ascii?Q?1dlqCwa0f3XNWJLiehngKkM+bJ7Du29BqXkIeZah9TFImg4WzeIPpxdSTBOE?=
 =?us-ascii?Q?34bsVBL98X1gCR9vYm00p+3Xs7mxnsW2pRzwIghI58nvaOJ9zMOmM+8g4quc?=
 =?us-ascii?Q?JgjuALN+PY6K/go3u3sZZVUhzysHuUuor/HKXHS8SVZSLqwkYsTLJ3ECRuIn?=
 =?us-ascii?Q?3FZUmVoIk1WyWMgSEHjiJfeaLRATnu8UL9Fc968rqrpZslC3fhCexGb/CYNc?=
 =?us-ascii?Q?CmFGteIoAA5e3WKBDpXD92AmhtlqOObWb9d3OEa/o5A2iQE2V+Ij8mfLejEI?=
 =?us-ascii?Q?ZBR5sm119TfNnPLUiNTbzJJ7gLy//LI36Tlxj9cH0Ktqs3AGe1FoSQl7J3Or?=
 =?us-ascii?Q?/PlzntEWDGsndMagPZJzf7sp0KhT4CEYn6zNo335RRdLcNoWCZsnSUcWXM2Y?=
 =?us-ascii?Q?/RaCPsDgVI9knSpknGmwVoA865KWLoi5Q2tCqhb61qVDJ9UXIGCo4PSah1Y9?=
 =?us-ascii?Q?/o9R82v8yAkF9teAaSuH31FRDu4WGglP56FXi9fGfUuuf2SQR5ES7tJ47Hp2?=
 =?us-ascii?Q?DBDm+cxp1fDZWCScvi4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1779985-37c6-4240-e4b2-08db73df5c49
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 11:45:36.8588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RbMDQleZAs8rhjNmuhayCJnj0IvzqMxVqVxOoLH324PRNxYP6atUpm7L8UtT5wt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4496
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 06:15:17PM -0700, Suthikulpanit, Suravee wrote:
> Jason,
> 
> On 6/22/2023 6:46 AM, Jason Gunthorpe wrote:
> > On Wed, Jun 21, 2023 at 06:54:47PM -0500, Suravee Suthikulpanit wrote:
> > 
> > > Since the IOMMU hardware virtualizes the guest command buffer, this allows
> > > IOMMU operations to be accelerated such as invalidation of guest pages
> > > (i.e. stage1) when the command is issued by the guest kernel without
> > > intervention from the hypervisor.
> > 
> > This is similar to what we are doing on ARM as well.
> 
> Ok
> 
> > > This series is implemented on top of the IOMMUFD framework. It leverages
> > > the exisiting APIs and ioctls for providing guest iommu information
> > > (i.e. struct iommu_hw_info_amd), and allowing guest to provide guest page
> > > table information (i.e. struct iommu_hwpt_amd_v2) for setting up user
> > > domain.
> > > 
> > > Please see the [4],[5], and [6] for more detail on the AMD HW-vIOMMU.
> > > 
> > > NOTES
> > > -----
> > > This series is organized into two parts:
> > >    * Part1: Preparing IOMMU driver for HW-vIOMMU support (Patch 1-8).
> > > 
> > >    * Part2: Introducing HW-vIOMMU support (Patch 9-21).
> > > 
> > >    * Patch 12 and 21 extends the existing IOMMUFD ioctls to support
> > >      additional opterations, which can be categorized into:
> > >      - Ioctls to init/destroy AMD HW-vIOMMU instance
> > >      - Ioctls to attach/detach guest devices to the AMD HW-vIOMMU instance.
> > >      - Ioctls to attach/detach guest domains to the AMD HW-vIOMMU instance.
> > >      - Ioctls to trap certain AMD HW-vIOMMU MMIO register accesses.
> > >      - Ioctls to trap AMD HW-vIOMMU command buffer initialization.
> > 
> > No one else seems to need this kind of stuff, why is AMD different?
> > 
> > Emulation and mediation to create the vIOMMU is supposed to be in the
> > VMM side, not in the kernel. I don't want to see different models by
> > vendor.
> 
> These ioctl is not necessary for emulation, which I would agree that it
> should be done on the VMM side (e.g. QEMU). These ioctls provides necessary
> information for programming the AMD IOMMU hardware to provide
> hardware-assisted virtualized IOMMU.

You have one called 'trap', it shouldn't be like this. It seems like
this is trying to parse the command buffer in the kernel, it should be
done in the VMM.

> In this series, AMD IOMMU GCR3 table is actually setup when the
> IOMMUFD_CMD_HWPT_ALLOC is called, which the driver provides a hook to struct
> iommu_ops.domain_alloc_user(). 

That isn't entirely right either, the GCR3 should be programmed into
HW during iommu_domain attach.

> The AMD-specific information is communicated from QEMU via
> iommu_domain_user_data.iommu_hwpt_amd_v2. This is similar to INTEL
> and ARM.

This is only for requesting the iommu_domain and supplying the gcr3 VA
for later use.
> 
> Please also note that for the AMD HW-vIOMMU device model in QEMU, the guest
> memory used for IOMMU device table is trapped on when guest IOMMU driver
> programs the guest Device Table Entry (gDTE). Then QEMU reads the content of
> gDTE to extract necessary information for setting up guest (stage-1) page
> table, and calls iommufd_backend_alloc_hwpt().

This is the same as ARM. It is a two step operation, you de-duplicate
the gDTE entries (eg to share vDIDs), allocating a HWPT if it doesn't
already exist, then you attach the HWPT to the physical device the
gDTE's vRID implies.

> There are still work to be done in this to fully support PASID. I'll
> take a look at this next.

I would expect PASID work is only about invalidation?
 
> > To start focus only on user space page tables and kernel mediated
> > invalidation and fit into the same model as everyone else. This is
> > approx the same patches and uAPI you see for ARM and Intel. AFAICT
> > AMD's HW is very similar to ARM's, so you should be aligning to the
> > ARM design.
> 
> I think the user space page table is covered as described above.

I'm not sure, it doesn't look like it is what I would expect.

> it seems that user-space is supposed to call the ioctl
> IOMMUFD_CMD_HWPT_INVALIDATE for both INTEL and ARM to issue invalidation for
> stage 1 page table. Please lemme know if I misunderstand the purpose of this
> ioctl.

Yes, the VMM traps the invalidation and issues it like this.
 
> However, for AMD since the HW-vIOMMU virtualizes the guest command buffer,
> and when it sees the page table invalidation command in the guest command
> buffer, it takes care of the invalidation using information in the DomIDMap,
> which maps guest domain ID (gDomID) of a particular guest to the
> corresponding host domain ID (hDomID) of the device and invalidate the
> nested translation according to the specified PASID, DomID, and GVA.

The VMM should do all of this stuff. The VMM parses the command buffer
and the VMM converts the commands to invalidation ioctls.

I'm a unclear if AMD supports a mode where the HW can directly operate
a command/invalidation queue in the VM without virtualization. Eg DMA
from guest memory and deliver directly to the guest completion
interrupts.

If it always needs SW then the SW part should be in the VMM, not the
kernel. Then you don't need to load all these tables into the kernel.

> The DomIDMap is setup by the host IOMMU driver during VM initialization.
> When the guest IOMMU driver attaches the VFIO pass-through device to a guest
> iommu_group (i.e domain), it programs the gDTE with the gDomID. This action
> is trapped into QEMU and the gDomID is read from the gDTE and communicated
> to hypervisor via the newly proposed ioctl VIOMMU_DOMAIN_ATTACH. Now the
> DomIDMap is created for the VFIO device.

The gDomID should be supplied when the HWPT is allocated, not via new
ioctls.

> Are you referring to the IOMMU API for SVA/PASID stuff:
>   * struct iommu_domain_ops.set_dev_pasid()
>   * struct iommu_ops.remove_dev_pasid()
>   * ...

Yes
 
> If so, we are working on it separately in parallel, and will be sending out
> RFC soon.

Great

Jason
