Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2025B2614
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiIHSpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiIHSpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:45:24 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BAA1F2E1
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:45:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fA+0YvWuLz7xBhsepIaXNpvTEd2/g4OBMMxOk3iZ7/9oQuLjsnZcGg5pgOXknEneYXUKdCtcOT8afnHFfDgzsWk8hZcwCvQ3FYYbISX1VnimSA9JNwp25/CcD4HLen0JJJGSp73ue0YTj75msRn9+VyxBlyPRtv8DrUMWmojhhCFXIuHqHZDTD320rtFESSe0lujuRwrU+0KOjgB1WEVH+pBFOUI+QAASRvzLKHHPITC7WktbNIBa3cs4rWxNT+AWN+10ZvQsFnklB1noB6eYwjUzHQBc1JRPi1lKrOXrWJUy9NUcEgivm0RCkz1LMLArzL8WisilV4vrukZSUTniQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNTAwS+arHRPPiIcdTF+VGctN7O7njUdFu/GGADgD3I=;
 b=f0UTi2UVPAidvBLHAfgCItML479EGp4MORkMx6cjMM2TH811HaIhgn+okXyuy3oUA08B9xptyLxH7HhZxpZ2ufDGCBfBlI5X9nwes22CnS4e/8FmYQbppXQHvCnAFyR9x1I/S9g540WJH6gNgRgrBd+MG5cY2bwhvdraLqB4kqcWXypYi6cDTsZJ6cB4Gq0ex1mbkhGbV3epGxQ6E0FQu1FdBrz/vhpZWDuXxlz+WJRGk1OV2hFtmBTyq3vLgbgf3BakjIz3gzke8eC6n39DfTR1BWe0lBQIbTpA2YZgg9tw3oZweP9zCQtaXYUvvGjfqu2eYdHs/E4TS0oc9Rnq8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNTAwS+arHRPPiIcdTF+VGctN7O7njUdFu/GGADgD3I=;
 b=BNocGcEMZpNL377Csdk+VsIvHx5v9yddAC1nVmAZxhp4XiRnVoPx27EeivXrC5iccrJafCwpa2E2qi7RTvEq7e2lPihlugz4oxQGf3wxSI8B8aTR3xBGefGrChrDs2dF3E3/s61PHHmlyZ1ry1Nm8dL+WIk5Ltn+nawieBkyUwK3WuEOPYQrJMgPoq02BHzRMlAvEgpNHLqiLbCgrD452q7CkhwajlcWv2QkZzzNTDJIVj23JssXlsxCoRFg6MpSbuDdr1zmC0z+uMqzBitZRZBu3f9R98amclIOz4glkY/7bdXBWt5P7zcNoXQq4ssJcLwg8ODAK8SOhKilTga1eA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6429.namprd12.prod.outlook.com (2603:10b6:930:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 18:45:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 18:45:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 3/4] vfio: Follow a strict lifetime for struct iommu_group *
Date:   Thu,  8 Sep 2022 15:45:00 -0300
Message-Id: <3-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
In-Reply-To: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:208:23d::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CY5PR12MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: 7180aa52-9b41-4b46-136b-08da91ca3e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xf5qYXaO3u4DdcOZBmx/c7N8APQxi7AX6a0c5c1kA9ypXWuFssUijRX4Rkt88jTlhG++7cH3E6nRvMzruY6aVIP4vtcw8yY4oFyz1k3IoxDfS8YeovJt41nsTSiGUDUvdsqHwxrmUK9rGLCqiCYRIq/rQPS/4H7WRXyn3kJjn1FNlrG1N2gJJntP/WLZXt7+HJp4SwNilqhnz6OCP8i5iRtKva/Cc39gd988/6DnVWPUx1VFpJclcCSA4IBCQieLwF5WNBfT4aKWCNtqhAutG2ZlK5u++a2XsVDX2nNBuFtVqysFqL3VsuCCfeoFJvHG9cFyY29hOqsGAHlQnLwmYDJPCRthl0NpETndGSnQhIpfOvWOluPNH1KlISXX8cO1y0Eb6yqBCauqcEF+mJfhrHb8d5mvNG4Q/UuGMKJC2vojstShiw4/yWnpUnTa8KFTMiiZsHRpvfQv7zG/SIU9lf4XUIBM5nJI86qzPBKm7/X8Z1AgpmFjy/sD1ZrKgws26TbMmcg5M1ZjlDDHP0zUyZCyYBH2XQTXUz35jQ6mlUfXgmesVleoZAqvyLgTXddyHzr5S3k/gRUbhT9YL9sLbL7BtlaavQ3dwIno6ug4iUZvrcvYLjiaUHL0fDs1jAE5EHl9HYIOik7MCKDjRL4h8yCgNDOIR/yWxk1elWUnjrRWa7W6rnDeNRMQ4csi9Yb/318N40fsuJ6kOb5XCLUKfHxEE+kd4Fd62HXD1G4zLq9laqwAmJa0uvwoBcbgOOoa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(45080400002)(38100700002)(4326008)(66556008)(316002)(8676002)(66476007)(66946007)(110136005)(54906003)(41300700001)(8936002)(83380400001)(7416002)(5660300002)(2906002)(6512007)(186003)(2616005)(6506007)(478600001)(6486002)(36756003)(26005)(86362001)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h4HqsY2gTsrjuoWgIfspGQlhJkzYLDNY6T+ONjI86F+kpJ5OnumZqdm6M4JU?=
 =?us-ascii?Q?pdvL/DHN1LAZ98yo0VweeHwnYcLyYSU3X043Ngup/3yGkk6O4xOkD1z0YkOf?=
 =?us-ascii?Q?ikuqyq99MccgGMZUSPwWkP0EobwUskI4Z0pUsoYAsyeDsvJH2iecnWR8lUe7?=
 =?us-ascii?Q?l+sPefPUIYN8pI5/XLKpImicXEjTaJeNfe4skMJAK6+ACm/DnBNTjNbIUKAU?=
 =?us-ascii?Q?MN0E75ZLVUZ7566O198tWHV/vEreyFp+axXuYLaBwGXVGBTvNqdSwAhgA0Ua?=
 =?us-ascii?Q?Vx/R6iYptp1I7cpnV82H/LsijtqyXHR2jiwH/pt94oVtBHYyIBkRJnNEEtYq?=
 =?us-ascii?Q?1vsPn9poAkDHpf1x1FxpUQcXVAZjEHp67qs6+d3F2f9cZheUhQbg0Ym1/Kzq?=
 =?us-ascii?Q?rihWSx63O3ueEBm+drc8FInjWss9kTTHKZE/NSMxrzTYYsau8Hun4vy4kgTt?=
 =?us-ascii?Q?bPt3VVUm6vBS+3tL1c04pLMlfJlXQcetLAtwY2FMzEwVuJM73PO9jrtREqfK?=
 =?us-ascii?Q?qEzqXmctMOmPAgrDzAPPL373EecWxMC4LjN6MY3CaPk+nsP6DrKIe1u4Mjsu?=
 =?us-ascii?Q?k3noLIr58wkkV4fMUBEc239POODnLYVdj1zUI05Vmqeat9mddzdmTnP9+6aC?=
 =?us-ascii?Q?S9XSvG2tuz27PsjhqVenoqpNY9qZtsMMyJI+rUR4Tkb+j+Tp8cN1UW59guPn?=
 =?us-ascii?Q?r8UoByKDTsuDykcXkG/WR7STso82ifPyCK4CwcigqNzVKY4Ic8v34URYbN09?=
 =?us-ascii?Q?Vyfyaw4a8FYPvVun4zOeeIPHo1QMbUNmsp9FT0uSP6zYeQ9uLrlLi6Sa7zIH?=
 =?us-ascii?Q?ozHo3eSGc3hg5EIS1epxK6Khs96zD/R/7RQMY7u6ArOR4tM0K+8DWHwstDCf?=
 =?us-ascii?Q?o65Fyq1lSlBjUEO2TwV5WPhAbhBBCxMPaNIOlcMiqQv8ZGR9F5k9YiL3MHo8?=
 =?us-ascii?Q?1DKCsMSljKRFIWzngbi7M7jsbw8g9aL1dle5Q0JqeLIkbo6bYqIMAReUtWkw?=
 =?us-ascii?Q?gwaNR0Agm1CKXGk2JRM+koReJxE9g+/AOQNThJjHbTcTbS7ykRtiO2Nc2GGX?=
 =?us-ascii?Q?AvqS6Q+2HqQ9D7b3mk+DpTHu1sZa2y1jtWzORnYyldPXH2WBCm90cFijQo6i?=
 =?us-ascii?Q?R/radZvnwGXKvXAWVhy5b0diyiw0j4xUGXjrY7s1ZNJZaQL6wX+xeERWDg/B?=
 =?us-ascii?Q?soEjYSkXmnYmHNtr30fFIkpFx6ASUzkkRFIPrTucmjS6rgdRFiaNo5fkBy+5?=
 =?us-ascii?Q?WlqwvgYUQgwIVFpzLzsK2QHqzrP/Y17+1Gpf7IZdwPzASxdVh/lNiSM2sBfj?=
 =?us-ascii?Q?vTI+/f4VfEjf5vUWRid/zSkleF+9ISXo3WIQpWiv8Yl5oLtSVzYYTpUgMmyS?=
 =?us-ascii?Q?oe8MyTDCHEFiPpv601BhSOlPdJ6CpNe3Ts9qGNSl8EyFqUCTdMvIlJ08ZD/6?=
 =?us-ascii?Q?2meqNLB0IG2QJdWrpxcGiMCVqbCf3WVhTqo0+4olW7T7N9c6H/JfTipVsaOb?=
 =?us-ascii?Q?ji9t38TEvDjh4OVMnmdxHXEKjl2e0YAmY+yQp3lubUBHFNYgt1/1g3ExREge?=
 =?us-ascii?Q?3gW4AZt4IM2bhgUOJxgYZMzw1spDcSZUJtmoYUMz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7180aa52-9b41-4b46-136b-08da91ca3e56
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:45:04.4408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B21Clb9Qb/3JjR0IaGitEg63DIUBG5TU3Uvjzq6AyACQZEVSsaCUESKOX79uk9vG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu_group comes from the struct device that a driver has been bound
to and then created a struct vfio_device against. To keep the iommu layer
sane we want to have a simple rule that only an attached driver should be
using the iommu API. Particularly only an attached driver should hold
ownership.

In VFIO's case since it uses the group APIs and it shares between
different drivers it is a bit more complicated, but the principle still
holds.

Solve this by waiting for all users of the vfio_group to stop before
allowing vfio_unregister_group_dev() to complete. This is done with a new
completion to know when the users go away and an additional refcount to
keep track of how many device drivers are sharing the vfio group. The last
driver to be unregistered will clean up the group.

This solves crashes in the S390 iommu driver that come because VFIO ends
up racing releasing ownership (which attaches the default iommu_domain to
the device) with the removal of that same device from the iommu
driver. This is a side case that iommu drivers should not have to cope
with.

   iommu driver failed to attach the default/blocking domain
   WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
   Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_ib sunrpc ib_uverbs ism smc uvdevice ib_core s390_trng eadm_sch tape_3590 tape tape_class vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 mlx5_core des_s390 libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core zfcp scsi_transport_fc pkey zcrypt rng_core autofs4
   CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
   Hardware name: IBM 3931 A01 782 (LPAR)
   Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
              R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
   Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
              00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
              00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
              00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
   Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
                          000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
                         #000000095bb10d24: af000000            mc      0,0
                         >000000095bb10d28: b904002a            lgr     %r2,%r10
                          000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
                          000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
                          000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
                          000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
   Call Trace:
    [<000000095bb10d28>] iommu_detach_group+0x70/0x80
   ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
    [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
    [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
    [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
   pci 0004:00:00.0: Removing from iommu group 4
    [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
    [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
    [<000000095be6c072>] system_call+0x82/0xb0
   Last Breaking-Event-Address:
    [<000000095be4bf80>] __warn_printk+0x60/0x68

It reflects that domain->ops->attach_dev() failed because the driver has
already passed the point of destructing the device.

Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 63 ++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ba8b6bed12c7e7..3bd6ec4cdd5b26 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -66,7 +66,15 @@ struct vfio_container {
 struct vfio_group {
 	struct device 			dev;
 	struct cdev			cdev;
+	/*
+	 * When drivers is non-zero a driver is attached to the struct device
+	 * that provided the iommu_group and thus the iommu_group is a valid
+	 * pointer. When drivers is 0 the driver is being detached. Once users
+	 * reaches 0 then the iommu_group is invalid.
+	 */
+	refcount_t			drivers;
 	refcount_t			users;
+	struct completion		users_comp;
 	unsigned int			container_users;
 	struct iommu_group		*iommu_group;
 	struct vfio_container		*container;
@@ -276,8 +284,6 @@ void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
 
-static void vfio_group_get(struct vfio_group *group);
-
 /*
  * Container objects - containers are created when /dev/vfio/vfio is
  * opened, but their lifecycle extends until the last user is done, so
@@ -353,6 +359,8 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	group->cdev.owner = THIS_MODULE;
 
 	refcount_set(&group->users, 1);
+	refcount_set(&group->drivers, 1);
+	init_completion(&group->users_comp);
 	init_rwsem(&group->group_rwsem);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
@@ -401,7 +409,7 @@ static struct vfio_group *vfio_get_group(struct device *dev,
 			goto out_unlock;
 		}
 		/* Found an existing group */
-		vfio_group_get(ret);
+		refcount_inc(&ret->drivers);
 		goto out_unlock;
 	}
 
@@ -437,8 +445,36 @@ static struct vfio_group *vfio_get_group(struct device *dev,
 
 static void vfio_group_put(struct vfio_group *group)
 {
-	if (!refcount_dec_and_mutex_lock(&group->users, &vfio.group_lock))
+	if (refcount_dec_and_test(&group->users))
+		complete(&group->users_comp);
+}
+
+static void vfio_group_remove(struct vfio_group *group)
+{
+	/* Pairs with vfio_create_group() */
+	if (!refcount_dec_and_mutex_lock(&group->drivers, &vfio.group_lock))
 		return;
+	list_del(&group->vfio_next);
+
+	/*
+	 * We could concurrently probe another driver in the group that might
+	 * race vfio_group_remove() with vfio_get_group(), so we have to ensure
+	 * that the sysfs is all cleaned up under lock otherwise the
+	 * cdev_device_add() will fail due to the name aready existing.
+	 */
+	cdev_device_del(&group->cdev, &group->dev);
+	mutex_unlock(&vfio.group_lock);
+
+	/* Matches the get from vfio_group_alloc() */
+	vfio_group_put(group);
+
+	/*
+	 * Before we allow the last driver in the group to be unplugged the
+	 * group must be sanitized so nothing else is or can reference it. This
+	 * is because the group->iommu_group pointer should only be used so long
+	 * as a device driver is attached to a device in the group.
+	 */
+	wait_for_completion(&group->users_comp);
 
 	/*
 	 * These data structures all have paired operations that can only be
@@ -449,19 +485,11 @@ static void vfio_group_put(struct vfio_group *group)
 	WARN_ON(!list_empty(&group->device_list));
 	WARN_ON(group->container || group->container_users);
 	WARN_ON(group->notifier.head);
-
-	list_del(&group->vfio_next);
-	cdev_device_del(&group->cdev, &group->dev);
-	mutex_unlock(&vfio.group_lock);
+	group->iommu_group = NULL;
 
 	put_device(&group->dev);
 }
 
-static void vfio_group_get(struct vfio_group *group)
-{
-	refcount_inc(&group->users);
-}
-
 /*
  * Device objects - create, release, get, put, search
  */
@@ -573,6 +601,10 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 static int __vfio_register_dev(struct vfio_device *device,
 		struct vfio_group *group)
 {
+	/*
+	 * In all cases group is the output of one of the group allocation
+	 * functions and we have group->drivers incremented for us.
+	 */
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
@@ -683,8 +715,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
 		iommu_group_remove_device(device->dev);
 
-	/* Matches the get in vfio_register_group_dev() */
-	vfio_group_put(group);
+	vfio_group_remove(group);
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
@@ -1272,7 +1303,7 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 
 	down_write(&group->group_rwsem);
 
-	/* users can be zero if this races with vfio_group_put() */
+	/* users can be zero if this races with vfio_group_remove() */
 	if (!refcount_inc_not_zero(&group->users)) {
 		ret = -ENODEV;
 		goto err_unlock;
-- 
2.37.3

