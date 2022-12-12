Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF7364A72E
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiLLSeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiLLSd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:33:29 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B683F19280;
        Mon, 12 Dec 2022 10:30:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGHE6/B3/cM6kcAS+4T/sKJ9VlPVeHS4bgD3MmXWfipasmHcdxF+z02hky4vn6U+U4z3d5nlQTW4Ipu0ANLI2f/gCR9zaUpCevbdzv3rBIUtIN9va/IHyxV0pqJ18aBwWlzG2GcDCVIHdOPDLEUfex0OQysl8qcZKuav/fmqZqCI11zu1FvubaQ2D0IOLMH8woy5v80xIyRTo1EgAxmiOXEhRwcK40gndO03Q5qdfHUZqLpURZVjEjvdiSvuEFAIbRy61c6QL/K+npLQbK/0zlnM8B9dfk+J+9K/sbB6b5L6/YM9fE/b0QolCcFhesiOXCs6wAcPrq2dXRA46GbZqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9h6TvgQ9p4RFTREwTZsx4rH1NjqnQCW7RM2Rq8LCNGQ=;
 b=OsNC4vT5pD6Dxxnzf/6tTkZlonkQEOQ8PGtLnWpuTtwf8rnrqLnOiAb5OjYbL4DE470g8Dbj/lrE+lABaSGHMY+vHkHFrjHL5crvl4KjcGqeBn4HxhKh0Q8RSunlgRKEpiEQ390j7MIuSzP0HFytZfxYLslkRU3pJ6SIFSbNexPUTGqeeAg+EvQKF6/M7bJr7Lke75EI35YVLWqLM2Tg7iH/UWToW4OlFYRrhIzn1po6VEvPivR4qgaiutstDhmaLLsKLbdT3Kfml9QHXK2srWA2OULKYeRDxkpqS73K7/bgcd61pFTUwhOAQaoedPTwckeE3Pr/EJLGPQ0KpsQFWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9h6TvgQ9p4RFTREwTZsx4rH1NjqnQCW7RM2Rq8LCNGQ=;
 b=R1Pxoc5k4OevOingIo83dprWuFtgmuo17GKfe3jaOdzoJLIslssUgYx6H+YoTO4kdcD/1KpfjaK7TBtcb6+gjUffR4Adl/6EdQvKu58yOzkgOP9EpT4BfoAUoYcWNbYuyuo0OpTP9YtZr/sljKHHHf18w0Se71fPTjvjg4+IIidO+Qa5k2bg2m+pEvSqCSWdx/4XEV6pHnVK+pwcbyjsqoYqWTAVv6zjObWMBML6X+DYlPASYHb6SaKTwcLGzZkdAfCmL0kMX2TFnwITvx23WIInGxCuSSif/Mc1rVAiTct7G7Ix+LoFMYN+rUYAY18dWnysY9D8koQ9VCy7UQ9zXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7974.namprd12.prod.outlook.com (2603:10b6:806:307::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:30:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:30:38 +0000
Date:   Mon, 12 Dec 2022 14:30:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <Y5dzTU8dlmXTbzoJ@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EwMXZvMXwYcrKMoO"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0304.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: a7220ab7-05f5-4f8f-a873-08dadc6ef77b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bGe3drF3EVUlU2t9MGXW6ZDkAZbR27kBqePSWIcfeTDwcapQZPNg2ZNauOIn14ti5abm/sTseWjgA5s3i+JarZJoQUHXb7ZAp3Zl/dnMBkRocwwOTdCA/rGKJqYDp93BoL/rgeFnUV5X0IUQHGBV0kY/ReQofEcrEhcQ1qkf3clQkUii5jWBIxXIcgjcR5zAIRPU5pMl3n02yZcXqzxhvVYGZPWEu7YoK+qY/4kw6MgigN9mfFuvRe0ujY+tlIxxL5XMAECWHNtOGOaQ6ErCm8m063WKW8PPUclPSPaAKER93H+XqS2D9hMuRNA+7FXpf5pjVD3vQGYKPkmlbIqahcUnYGKKINDJvgfeaXFT58YaLmihfJ9gz7ASyUOYLvnY2becp1qs03tRTxp66q3xb/oOeyqKIypnP0iOoUU1nwh6QC8IU2WLFQh6cAgsn3SgAt5fWWxtb7kjb9Hst8qzRUVnW0UwaQvD6UXHyOGOxg/aR2WEqJLJtvAgJKELt9o+d1JLpCsne1pTPrqPoF+J2O4NKHp5Pxyx5kbD2a/NWO/JGcW8G83KrmppKLuU8b8FTQClxBKhRbqG8qu73fhmhwwtL71fs8AyQUBO2g3oxLT918nWrC20JLGfEEKm4Bvc7ckKyHZe80SBuak7NdplgEN0z7DZZThOPFY5E2oay2j1IZIaqFLxKSdCRbEo6lVqT4jMEJ3l2pIfu4ZA2uvT8i/96eHfgtpqfeyFMTlYGHPyH8slelZZm9AVZDoM/nHRRO1x02ykd0KqMKZL/U3Kr6GXWld9sL65UBybQbyz/76TB4r7maBXsMTTqneJa1ce
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(8936002)(4326008)(41300700001)(5660300002)(30864003)(8676002)(66556008)(66946007)(66476007)(478600001)(966005)(36756003)(4001150100001)(2906002)(316002)(6916009)(6486002)(186003)(86362001)(6512007)(44144004)(2616005)(26005)(6506007)(21480400003)(83380400001)(38100700002)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xviyMDVJu7KrG1m9ZwsI5YKce5gTiCHBSUKN7UXYQXbZxdfmZZ9eLMeIhH1I?=
 =?us-ascii?Q?JnJL+CZGJBfNPIfJpSfEP9lS2pnlsCsDcA0YCQIiN70Of+VoP2xreI9ABx5c?=
 =?us-ascii?Q?Zfbi84HIACxMAR1FhL/Am2M8qpLi4Eq69qscfH7WMuEqgvOiPis5sSiBmp6O?=
 =?us-ascii?Q?KBCTr8CJflGqpfJxhNnixliaBCXc51RzFeI7gDv1PjmN1zolapREiLiQrMI9?=
 =?us-ascii?Q?Mc8J+drlJwKRXr1gX0Cgcmlc68On0BVm3lH5bbu0N3H+V2dFbLJVOaoCbKQM?=
 =?us-ascii?Q?ScagIFjNOivseuxhC1RD6BPzSrPgLFUpsSAV6S7sbqkD3f4FGWBfotz87JnT?=
 =?us-ascii?Q?kCPBYm1g54dStB9TJy7JZ+WOq9nIqLHK9nrfj6ye3w32IPrxC86PAd4jSPHe?=
 =?us-ascii?Q?4PFeqGsMtQ0pY0M5EG2HP3EVnAxvLv40cTsgO23JfkV4Py2Et2sHjE1XXiNI?=
 =?us-ascii?Q?k9pvD9AEikenY8Xdgx4/DaAsTTKE3Y2l5t2z6q294VYDhtgV9czUQI9MSdA0?=
 =?us-ascii?Q?6edfDpE/NH2ZZM+qKzjF4Vl5Wrv2fRxNaYEhjfBy/mhQ2QXwzNqgI7M8ImVA?=
 =?us-ascii?Q?x15h1D9VHw6IFpkxJRDERRYm01Q5my1bGi8DMDmK+N4Mw7eYjhfv3lTJ/TNu?=
 =?us-ascii?Q?M0QbgDheiSYhl5X63inxTGx5ygm2qLlK7hlYOVky4CKOzMpTeQZnnKrgNaxY?=
 =?us-ascii?Q?oUUeOaS0WPEAKeBeC6Y1xzTLTAOc1hpWWWny6pGbf38Lsv3ehuZHdCdpzdNu?=
 =?us-ascii?Q?xxLIWWZDQ3szBwfuRTDhtM7KDPdWxbcNNiQRzXgCiKOclI9ywnRstQ2ZEho+?=
 =?us-ascii?Q?XYeEU9bKFe90cayz4Rw3/7roCCvF0eFY/pbiE2Fkij0Zje5sxVKXRnXyI4q1?=
 =?us-ascii?Q?7+H6r2bRPF+okBIkkHqqy8E221DOopgljSZf9jqPY813/UkDIEX4j9FaydR/?=
 =?us-ascii?Q?inpkYd5euTUR1Db/+tUTPbijb2EtRwWeqwr7Z4UogzIDVcF0Dj9+NZWAR4DR?=
 =?us-ascii?Q?2rxdzmFC4qq9Ev+cxxrDbO7n/g+KZYVRCM9BsSkRaXFiDab6aKtEVMm9C2Fh?=
 =?us-ascii?Q?sIAH0KtTY6Kj4MxN4QpJK5Dk/2YbKjIY4Q/dBbmZCNMV60+zgKKyZm8g/fz9?=
 =?us-ascii?Q?snMR76ewwAYqhl5JFoLnyy2RW5XWV5J78yw2hbEgj6B/Tre+bVLPiuMLzgnf?=
 =?us-ascii?Q?/tj4hQjHFhw/GFr5V7rwKt9otFZmsSgWPKkiw8rhqUy94G7xk8ZOj3Y+HyJB?=
 =?us-ascii?Q?bqe3E1uNvneRy5DiMCGvVFTw+AZN+jHZti3mtM3jjZ02lvFeGSuptM5wzT2G?=
 =?us-ascii?Q?tIkPaN/sUh72MjFtywPgYhVIUJmqgVFDREi/c4tMpv+HH407hPkE6s/+ii6w?=
 =?us-ascii?Q?OFmN8aQWa75zJP6JDOpkfsTG/BMynpZAcK0o1bkrKbz2yGELRE3ko+zcQ6tD?=
 =?us-ascii?Q?ksbQ6aB0M7EX81w9L1jPp7goPMkIhjS2smYSqv1+vAYwwxnDTru9SCSmDwWg?=
 =?us-ascii?Q?c8vjAMbpXNM4o/xKeircnOgSw4iLSIVktSS22DdooNXcYKZtxLZdeY9vAH7X?=
 =?us-ascii?Q?n2S0xCl1bIbF6uNpsZY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7220ab7-05f5-4f8f-a873-08dadc6ef77b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:30:38.5279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zBILJi5DcEKZeneviwWX28ZtUSNNFyIHYZ2BMuIrZ6azmWQ2hdT00Z98j2rt7av9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7974
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--EwMXZvMXwYcrKMoO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the first PR for a new char device called 'iommufd'. This has
been in discussions for about two years now, while attempts to
implement the needed features have been tried since as far back as
2017. In January a group of us sat down and actually made it.

It may seem strange that a lowlevel, seemingly internal, function like
the iommu would have a user API. However, for performance, it has
become quite popular to setup virtual machines so that HW (eg
networking/storage devices) can have direct DMA into the virtual
machine memory itself. To achieve this requires special programming of
the IOMMU HW.

Further, we have advanced PCI features like Process Address Space ID
(PASID) and Page Request Interface (PRI) that rely on the IOMMU HW to
implement them. In particular PASID & PRI are used to create something
called Shared Virtual Addressing (SVA or SVM) where DMA from a device
can be directly delivered to a process virtual memory address by
having the IOMMU HW directly walk the CPU's page table for the
process, and trigger faults for DMA to non-present pages.

Naturally people would like to have virtualized versions of all of
this. A vIOMMU driver that can implement vPASID and vPRI to achieve
vSVA within a VM.

Thus, we get to iommufd. It is a uAPI to allow something like qemu to
have some direct control over the IOMMU to implement, in userspace, a
vIOMMU device emulation that can provide all these services to the
IOMMU driver running in the VM. Like KVM this is done in a general way
where we delegate functionality to userspace and if the userspace is
something like qemu then it will compose that functionality into an
emulated vIOMMU device. iommufd itself doesn't interact with
virtualization or KVM.

This PR is the starting point, it just gets all the infrastructure
setup so that it is as good as VFIO is right now. We see a broad need
for extended
features, some being highly IOMMU device specific:

 - Binding iommu_domain's to PASID/SSID
 - Userspace IO page tables, for ARM, x86 and S390
 - Kernel bypassed invalidation of user page tables
 - Re-use of the KVM page table in the IOMMU
 - Dirty page tracking in the IOMMU
 - Runtime Increase/Decrease of IOPTE size
 - PRI support with faults resolved in userspace

Currently vfio provides the uAPI for iommu HW, but its ioctl design
has reached a difficult point to evolve further, and has developed a
small wishlist of changes. Worse, it is tied to VFIO, and other
subystems working with direct VM DMA, like VPDA, were cloning the
iommu control with their own IOCTLs.

Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The built-in kdocs are rendered here, and make an good backgrounder, along
with the main cover letter:

 https://docs.kernel.org/next/userspace-api/iommufd.html
 https://lore.kernel.org/kvm/0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com/

Eric and Yi gave a nice presentation at KVM forum on the history and qemu s=
ide
of the project:

 https://youtu.be/PlEzLywexHE

A group discussion at LPC, though the AV is troubled enough it is not
so
good:

 https://youtu.be/tHNhegCD2tU

And a few older, related, conference presentations:

 Some AMD IOMMU HW features:
   https://static.sched.com/hosted_files/kvmforum2021/da/vIOMMU%20KVM%20For=
um%202021%20-%20v4.pdf

 Sharing the KVM page table with the IOMMU
   https://static.sched.com/hosted_files/kvmforum2021/a3/KVM_2021_sharing_T=
DP_IOMMU.pdf

 Earlier approach for nested translation/userspace page tables on ARM:
   https://archive.fosdem.org/2019/schedule/event/vai_iommu_implementation_=
using_hw_nested_paging/attachments/slides/2915/export/events/attachments/va=
i_iommu_implementation_using_hw_nested_paging/slides/2915/fosdem19_viommu_n=
ested_mode.

The PR
=3D=3D=3D=3D=3D=3D

This PR is following about 300 patches already merged that have been
restructuring parts of the iommu subsystem, VFIO, and all its
drivers. The large amount of preparatory work is the main reason why
this has been such a challenging task.

As for this PR, it is organized into parts:

 - First is a shared branch with Joerg that gets the necessary iommu
   subsystem rework required.

 - Second is the "generic iommufd" basic char dev. This is at the
   level of near functional equivalence to the current VFIO interface.

 - Third is a series to make VFIO able to use iommufd.

 - Fourth is some VFIO patches that have become conflict entangled
   with this work, but were otherwise completed this cycle.

 - Finally a few small fixup patches from late review on the mailing
   list after the commits had been frozen.

The next cycle(s) will see additional functionality land in iommufd,
and completion of the VFIO rework which will finally bring the new
features people have been seeking.

The bulk of the PR has been in linux-next since next-20221102, it
comes with a fairly complete selftest, and separately syzkaller
descriptions were created and run against the full uAPI with
reasonable coverage results. These are now pushed to syzbot and are
running continuously.

Several people have contributed directly to this work: Eric Auger,
Joao Martins, Kevin Tian, Lu Baolu, Nicolin Chen, Yi L Liu. Many more
have participated in the discussions that lead here, and provided
ideas. Thanks to all!

Merge Conflicts
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Finally, there are some interactions with other trees. Everything was
fine until rc8 then all these conflicts appeared :(

Trivial compile time failure with Greg's work to add const-ness:

  https://lore.kernel.org/r/20221206132153.074fff0c@canb.auug.org.au

--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -827,7 +827,7 @@ bool vfio_file_has_dev(struct file *file, struct vfio_d=
evice *device)
 }
 EXPORT_SYMBOL_GPL(vfio_file_has_dev);

-static char *vfio_devnode(struct device *dev, umode_t *mode)
+static char *vfio_devnode(const struct device *dev, umode_t *mode)
 {
        return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
 }

There are more ugly problems with VFIO that we didn't manage to avoid:

 https://lore.kernel.org/r/20221206125542.52ea97a7@canb.auug.org.au

And another one that Stephen hasn't written about yet. I've created a
'for-linus-iommufd-merged' tag with my resolution against Alex's
current tree and a diff is included the end of this email.

Though I don't think there will be a merge, compile, or functional
problem, changes to gup.c going through Andrew's mm tree want the
changes below. I will send a patch for this during rc1.

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 429fa3b0a239cd..12c93b7bf15793 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -707,12 +707,9 @@ static void pfn_reader_user_init(struct pfn_reader_use=
r *user,
 	user->upages_end =3D 0;
 	user->locked =3D -1;

-	if (pages->writable) {
-		user->gup_flags =3D FOLL_LONGTERM | FOLL_WRITE;
-	} else {
-		/* Still need to break COWs on read */
-		user->gup_flags =3D FOLL_LONGTERM | FOLL_FORCE | FOLL_WRITE;
-	}
+	user->gup_flags =3D FOLL_LONGTERM;
+	if (pages->writable)
+		user->gup_flags |=3D FOLL_WRITE;
 }

 static void pfn_reader_user_destroy(struct pfn_reader_user *user,
@@ -782,13 +779,9 @@ static int pfn_reader_user_pin(struct pfn_reader_user =
*user,
 			mmap_read_lock(pages->source_mm);
 			user->locked =3D 1;
 		}
-		/*
-		 * FIXME: last NULL can be &pfns->locked once the GUP patch
-		 * is merged.
-		 */
 		rc =3D pin_user_pages_remote(pages->source_mm, uptr, npages,
 					   user->gup_flags, user->upages, NULL,
-					   NULL);
+					   &user->locked);
 	}
 	if (rc <=3D 0) {
 		if (WARN_ON(!rc))

Thanks,
Jason

The tag for-linus-iommufd-merged with my merge resolution to your tree is a=
lso available to pull.

The following changes since commit b7b275e60bcd5f89771e865a8239325f86d9927d:

  Linux 6.1-rc7 (2022-11-27 13:31:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-li=
nus-iommufd

for you to fetch changes up to d6c55c0a20e5059abdde81713ddf6324a946eb3c:

  iommufd: Change the order of MSI setup (2022-12-09 15:24:30 -0400)

----------------------------------------------------------------
iommufd for 6.2

iommufd is the user API to control the IOMMU subsystem as it relates to
managing IO page tables that point at user space memory.

It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
container) which is the VFIO specific interface for a similar idea.

We see a broad need for extended features, some being highly IOMMU device
specific:
 - Binding iommu_domain's to PASID/SSID
 - Userspace IO page tables, for ARM, x86 and S390
 - Kernel bypassed invalidation of user page tables
 - Re-use of the KVM page table in the IOMMU
 - Dirty page tracking in the IOMMU
 - Runtime Increase/Decrease of IOPTE size
 - PRI support with faults resolved in userspace

Many of these HW features exist to support VM use cases - for instance the
combination of PASID, PRI and Userspace IO Page Tables allows an
implementation of DMA Shared Virtual Addressing (vSVA) within a
guest. Dirty tracking enables VM live migration with SRIOV devices and
PASID support allow creating "scalable IOV" devices, among other things.

As these features are fundamental to a VM platform they need to be
uniformly exposed to all the driver families that do DMA into VMs, which
is currently VFIO and VDPA.

----------------------------------------------------------------
Jason Gunthorpe (36):
      iommu: Add IOMMU_CAP_ENFORCE_CACHE_COHERENCY
      interval-tree: Add a utility to iterate over spans in an interval tree
      scripts/kernel-doc: support EXPORT_SYMBOL_NS_GPL() with -export
      iommufd: File descriptor, context, kconfig and makefiles
      kernel/user: Allow user_struct::locked_vm to be usable for iommufd
      iommufd: PFN handling for iopt_pages
      iommufd: Algorithms for PFN storage
      iommufd: Data structure to provide IOVA to PFN mapping
      iommufd: IOCTLs for the io_pagetable
      iommufd: Add a HW pagetable object
      iommufd: Add kAPI toward external drivers for physical devices
      iommufd: Add kAPI toward external drivers for kernel access
      iommufd: vfio container FD ioctl compatibility
      iommufd: Add kernel support for testing iommufd
      iommufd: Add some fault injection points
      iommufd: Add additional invariant assertions
      iommufd: Add a selftest
      Merge patch series "IOMMUFD Generic interface"
      vfio: Move vfio_device driver open/close code to a function
      vfio: Move vfio_device_assign_container() into vfio_device_first_open=
()
      vfio: Rename vfio_device_assign/unassign_container()
      vfio: Use IOMMU_CAP_ENFORCE_CACHE_COHERENCY for vfio_file_enforced_co=
herent()
      vfio-iommufd: Allow iommufd to be used in place of a container fd
      vfio-iommufd: Support iommufd for physical VFIO devices
      vfio-iommufd: Support iommufd for emulated VFIO devices
      vfio: Move container related MODULE_ALIAS statements into container.c
      vfio: Make vfio_container optionally compiled
      iommufd: Allow iommufd to supply /dev/vfio/vfio
      Merge patch series "Connect VFIO to IOMMUFD"
      Merge tag 'v6.1-rc7' into iommufd.git for-next
      vfio: Simplify vfio_create_group()
      vfio: Move the sanity check of the group to vfio_create_group()
      Merge patch series "Move group specific code into group.c"
      iommufd: Fix comment typos
      iommufd: Improve a few unclear bits of code
      iommufd: Change the order of MSI setup

Joerg Roedel (1):
      Merge tag 'for-joerg' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/jgg/iommufd into core

Kevin Tian (1):
      iommufd: Document overview of iommufd

Lu Baolu (14):
      iommu: Add max_pasids field in struct iommu_device
      iommu: Add max_pasids field in struct dev_iommu
      iommu: Remove SVM_FLAG_SUPERVISOR_MODE support
      PCI: Enable PASID only when ACS RR & UF enabled on upstream path
      iommu: Add attach/detach_dev_pasid iommu interfaces
      iommu: Add IOMMU SVA domain support
      iommu/vt-d: Add SVA domain support
      arm-smmu-v3/sva: Add SVA domain support
      iommu/sva: Refactoring iommu_sva_bind/unbind_device()
      iommu: Remove SVA related callbacks from iommu ops
      iommu: Prepare IOMMU domain for IOPF
      iommu: Per-domain I/O page fault handling
      iommu: Rename iommu-sva-lib.{c,h}
      iommu: Add device-centric DMA ownership interfaces

Matthew Rosato (1):
      vfio/ap: Validate iova during dma_unmap and trigger irq disable

Nicolin Chen (5):
      iommu/amd: Drop unnecessary checks in amd_iommu_attach_device()
      iommu: Add return value rules to attach_dev op and APIs
      iommu: Regulate EINVAL in ->attach_dev callback functions
      iommu: Use EINVAL for incompatible device/domain in ->attach_dev
      iommu: Propagate return value in ->attach_dev callback functions

Yi Liu (9):
      i915/gvt: Move gvt mapping cache initialization to intel_vgpu_init_de=
v()
      vfio: Create wrappers for group register/unregister
      vfio: Set device->group in helper function
      vfio: Swap order of vfio_device_container_register() and open_device()
      vfio: Make vfio_device_open() truly device specific
      vfio: Refactor vfio_device open and close
      vfio: Wrap vfio group module init/clean code into helpers
      vfio: Refactor dma APIs for emulated devices
      vfio: Move vfio group specific code into group.c

 .clang-format                                      |    3 +
 Documentation/userspace-api/index.rst              |    1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 Documentation/userspace-api/iommufd.rst            |  223 +++
 MAINTAINERS                                        |   12 +
 drivers/dma/idxd/cdev.c                            |    3 +-
 drivers/dma/idxd/init.c                            |   25 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c                   |   21 +-
 drivers/iommu/Kconfig                              |    1 +
 drivers/iommu/Makefile                             |    4 +-
 drivers/iommu/amd/iommu.c                          |   14 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |  104 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   32 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h        |   23 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |    3 -
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |    7 +-
 drivers/iommu/fsl_pamu.c                           |    2 +-
 drivers/iommu/fsl_pamu_domain.c                    |    4 +-
 drivers/iommu/intel/dmar.c                         |    7 +
 drivers/iommu/intel/iommu.c                        |   56 +-
 drivers/iommu/intel/iommu.h                        |   18 +-
 drivers/iommu/intel/pasid.c                        |    6 +-
 drivers/iommu/intel/svm.c                          |  145 +-
 drivers/iommu/io-pgfault.c                         |   77 +-
 drivers/iommu/iommu-sva-lib.c                      |   71 -
 drivers/iommu/iommu-sva.c                          |  240 +++
 drivers/iommu/{iommu-sva-lib.h =3D> iommu-sva.h}     |   14 +-
 drivers/iommu/iommu.c                              |  416 ++--
 drivers/iommu/iommufd/Kconfig                      |   44 +
 drivers/iommu/iommufd/Makefile                     |   13 +
 drivers/iommu/iommufd/device.c                     |  772 ++++++++
 drivers/iommu/iommufd/double_span.h                |   53 +
 drivers/iommu/iommufd/hw_pagetable.c               |   57 +
 drivers/iommu/iommufd/io_pagetable.c               | 1216 ++++++++++++
 drivers/iommu/iommufd/io_pagetable.h               |  241 +++
 drivers/iommu/iommufd/ioas.c                       |  398 ++++
 drivers/iommu/iommufd/iommufd_private.h            |  307 +++
 drivers/iommu/iommufd/iommufd_test.h               |   93 +
 drivers/iommu/iommufd/main.c                       |  460 +++++
 drivers/iommu/iommufd/pages.c                      | 1984 ++++++++++++++++=
++++
 drivers/iommu/iommufd/selftest.c                   |  853 +++++++++
 drivers/iommu/iommufd/vfio_compat.c                |  472 +++++
 drivers/iommu/ipmmu-vmsa.c                         |    2 -
 drivers/iommu/mtk_iommu.c                          |    4 +-
 drivers/iommu/omap-iommu.c                         |    6 +-
 drivers/iommu/sprd-iommu.c                         |    4 +-
 drivers/iommu/tegra-gart.c                         |    2 +-
 drivers/iommu/virtio-iommu.c                       |    7 +-
 drivers/misc/uacce/uacce.c                         |    2 +-
 drivers/pci/ats.c                                  |    3 +
 drivers/s390/cio/vfio_ccw_ops.c                    |    3 +
 drivers/s390/crypto/vfio_ap_ops.c                  |   21 +-
 drivers/vfio/Kconfig                               |   36 +-
 drivers/vfio/Makefile                              |    6 +-
 drivers/vfio/container.c                           |  145 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |    3 +
 drivers/vfio/group.c                               |  877 +++++++++
 drivers/vfio/iommufd.c                             |  158 ++
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |    6 +
 drivers/vfio/pci/mlx5/main.c                       |    3 +
 drivers/vfio/pci/vfio_pci.c                        |    3 +
 drivers/vfio/platform/vfio_amba.c                  |    3 +
 drivers/vfio/platform/vfio_platform.c              |    3 +
 drivers/vfio/vfio.h                                |  120 +-
 drivers/vfio/vfio_main.c                           |  983 ++--------
 include/linux/intel-svm.h                          |   13 -
 include/linux/interval_tree.h                      |   58 +
 include/linux/iommu.h                              |  145 +-
 include/linux/iommufd.h                            |   98 +
 include/linux/sched/user.h                         |    2 +-
 include/linux/vfio.h                               |   39 +
 include/uapi/linux/iommufd.h                       |  347 ++++
 kernel/user.c                                      |    1 +
 lib/Kconfig                                        |    4 +
 lib/interval_tree.c                                |  132 ++
 scripts/kernel-doc                                 |   12 +-
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/iommu/.gitignore           |    3 +
 tools/testing/selftests/iommu/Makefile             |   12 +
 tools/testing/selftests/iommu/config               |    2 +
 tools/testing/selftests/iommu/iommufd.c            | 1654 ++++++++++++++++
 tools/testing/selftests/iommu/iommufd_fail_nth.c   |  580 ++++++
 tools/testing/selftests/iommu/iommufd_utils.h      |  278 +++
 83 files changed, 12811 insertions(+), 1466 deletions(-)

diff --cc drivers/vfio/Kconfig
index 286c1663bd7564,0b8d53f63c7e5c..a8f54462946742
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@@ -46,17 -38,6 +46,12 @@@ config VFIO_NOIOMM
  	  this mode since there is no IOMMU to provide DMA translation.
 =20
  	  If you don't know what to do here, say N.
 +endif
 +
- config VFIO_SPAPR_EEH
- 	tristate
- 	depends on EEH && VFIO_IOMMU_SPAPR_TCE
- 	default VFIO
-=20
 +config VFIO_VIRQFD
- 	tristate
++	bool
 +	select EVENTFD
 +	default n
 =20
  source "drivers/vfio/pci/Kconfig"
  source "drivers/vfio/platform/Kconfig"
diff --cc drivers/vfio/Makefile
index 3783db7e8082c8,0721ed4831c92f..7eae72e2c6bf9f
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@@ -2,17 -2,12 +2,14 @@@
  obj-$(CONFIG_VFIO) +=3D vfio.o
 =20
  vfio-y +=3D vfio_main.o \
 -	  iova_bitmap.o \
 -	  container.o
 +	  group.o \
 +	  iova_bitmap.o
+ vfio-$(CONFIG_VFIO_VIRQFD) +=3D virqfd.o
 +vfio-$(CONFIG_IOMMUFD) +=3D iommufd.o
 +vfio-$(CONFIG_VFIO_CONTAINER) +=3D container.o
 =20
- obj-$(CONFIG_VFIO_VIRQFD) +=3D vfio_virqfd.o
  obj-$(CONFIG_VFIO_IOMMU_TYPE1) +=3D vfio_iommu_type1.o
  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) +=3D vfio_iommu_spapr_tce.o
- obj-$(CONFIG_VFIO_SPAPR_EEH) +=3D vfio_spapr_eeh.o
  obj-$(CONFIG_VFIO_PCI) +=3D pci/
  obj-$(CONFIG_VFIO_PLATFORM) +=3D platform/
  obj-$(CONFIG_VFIO_MDEV) +=3D mdev/
diff --cc drivers/vfio/vfio.h
index 2e05418fd18df0,7c2cbf8a48ad1b..d5fa896b5a8562
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@@ -73,27 -60,8 +73,22 @@@ struct vfio_group=20
  	struct kvm			*kvm;
  	struct file			*opened_file;
  	struct blocking_notifier_head	notifier;
 +	struct iommufd_ctx		*iommufd;
  };
 =20
 +int vfio_device_set_group(struct vfio_device *device,
 +			  enum vfio_group_type type);
 +void vfio_device_remove_group(struct vfio_device *device);
 +void vfio_device_group_register(struct vfio_device *device);
 +void vfio_device_group_unregister(struct vfio_device *device);
 +int vfio_device_group_use_iommu(struct vfio_device *device);
 +void vfio_device_group_unuse_iommu(struct vfio_device *device);
 +void vfio_device_group_close(struct vfio_device *device);
 +bool vfio_device_has_container(struct vfio_device *device);
 +int __init vfio_group_init(void);
 +void vfio_group_cleanup(void);
 +
 +#if IS_ENABLED(CONFIG_VFIO_CONTAINER)
- /* events for the backend driver notify callback */
- enum vfio_iommu_notify_type {
- 	VFIO_IOMMU_CONTAINER_CLOSE =3D 0,
- };
-=20
  /**
   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
   */
diff --cc drivers/vfio/vfio_main.c
index e21ff965141e69,03dbcd3d96f0e5..d4087fe7419996
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@@ -1260,27 -1902,59 +1348,34 @@@ static int __init vfio_init(void
  	if (ret)
  		return ret;
 =20
+ 	ret =3D vfio_virqfd_init();
+ 	if (ret)
 -		goto err_virqfd;
 -
 -	/* /dev/vfio/$GROUP */
 -	vfio.class =3D class_create(THIS_MODULE, "vfio");
 -	if (IS_ERR(vfio.class)) {
 -		ret =3D PTR_ERR(vfio.class);
 -		goto err_group_class;
 -	}
 -
 -	vfio.class->devnode =3D vfio_devnode;
++		goto err_group;
+=20
  	/* /sys/class/vfio-dev/vfioX */
  	vfio.device_class =3D class_create(THIS_MODULE, "vfio-dev");
  	if (IS_ERR(vfio.device_class)) {
  		ret =3D PTR_ERR(vfio.device_class);
--		goto err_dev_class;
++		goto err_virqfd;
  	}
 =20
 -	ret =3D alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");
 -	if (ret)
 -		goto err_alloc_chrdev;
 -
  	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
  	return 0;
 =20
 -err_alloc_chrdev:
 -	class_destroy(vfio.device_class);
 -	vfio.device_class =3D NULL;
--err_dev_class:
 -	class_destroy(vfio.class);
 -	vfio.class =3D NULL;
 -err_group_class:
 -	vfio_virqfd_exit();
+ err_virqfd:
 -	vfio_container_cleanup();
++	vfio_virqfd_exit();
++err_group:
 +	vfio_group_cleanup();
  	return ret;
  }
 =20
  static void __exit vfio_cleanup(void)
  {
 -	WARN_ON(!list_empty(&vfio.group_list));
 -
  	ida_destroy(&vfio.device_ida);
 -	ida_destroy(&vfio.group_ida);
 -	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
  	class_destroy(vfio.device_class);
  	vfio.device_class =3D NULL;
 -	class_destroy(vfio.class);
+ 	vfio_virqfd_exit();
 -	vfio_container_cleanup();
 -	vfio.class =3D NULL;
 +	vfio_group_cleanup();
  	xa_destroy(&vfio_device_set_xa);
  }
 =20

--EwMXZvMXwYcrKMoO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCY5dzSwAKCRCFwuHvBreF
YfXCAQDL5Ss50rtu7sVdVNsTnjk64ZRl2xEuyrQ2W8yDIAdoPAEA/bIRoducoHPv
8XM9+KBXzKjvQubyfrKsN7KgkIcQogY=
=yWvJ
-----END PGP SIGNATURE-----

--EwMXZvMXwYcrKMoO--
