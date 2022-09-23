Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061C85E707D
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 02:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiIWAGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 20:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiIWAGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 20:06:23 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF62DF042
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:06:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ip4ldLx2eT0Q3AfJKGmuBEQC01Ndm8mFgh7kWN9nrtKjiL/JynTZucy9nDrHW6qNjsz/RN27OMWtxXi0AAAgZiHnHelWVe5xIEndzuBnmXnjLe5ofxR+snpschrUe5U7vjNqUB0iHuE+r4RX1WhMHS51KCSp3CkvK+UZpeW2Br6/ZCBT0nxQypOcjGS3/fwKJ6bntPvlHn6QAZBG80b32S0yDIvly+0mWIeaiMKyz7tl8l7eywGr4HPfB040dKutiPOai/LjLeieuaSkqi3dW/JZrO5Bfv2ch8kOScTe+/3D5uyQnSOf3WkwRoDlhsdRZpoizITXsg1LR39X0+skpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAgY8ptxq4Z0zvSqEQFc3NNSqeVugQ+PY9R+nLpWkgU=;
 b=G/R1LNe3UVNDv8+1FSNlytZdnbeeKkjCbBBwkAGdLPxho8dtSiIritZfPEe2vpmU0xNs1Fnnx04CUiaBz1egfqnVXFEQu4fPnqlGUtupq8xuCP9kGFoDLtLt3NScwEqZESUDDTdftgN5yPkjOzzlogevMTguo0z0Cpr6kPDBtiVMcV2lFyhb7unvdLAGrV4fqZkBA3GAOBLpz9UEDU2VIGE1+wp+4KcuCYvV7tFzrdwqvDOFMW8Urw/CR8cqpDXTWJIE/jZ/duXteLob0T1FaTOKhxQcexTm+V1EkYNngnqi6s7cB2WSZ3xj879nF3zWKgHgUJYsS4SzOlz0gSqZ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAgY8ptxq4Z0zvSqEQFc3NNSqeVugQ+PY9R+nLpWkgU=;
 b=aOFSzMHLIsmpycKswz/k5+HsToEB2BoxiggxlINs1IAUEVPdI5Dmn6ven9PbWfeed+kmECgDirVYqO06PkMTD4xRvL6gfImkw9Sg/sJ1010LklXl4z/FvHAmuGY5CWalAV1AcZ/kotRs1DL9RJ2m8JBLLYtf0I8AOI84fT1H7by8relCG5AmhCUJ/rm7K9u9oilAPYNNmGrZIdbD+sTCC3hYoXtDVgOwifmbz2T6yXhdPc7pxA38h4dqZjBLLGaeSaxwUQ7jNNWv348REksxChOtjS8cOs7BKnSqD3UCMcmEIROf1cp8oXUfyx4K5pPz1GUgzZWt2ctXI3vDJS8OgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6611.namprd12.prod.outlook.com (2603:10b6:510:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Fri, 23 Sep
 2022 00:06:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Fri, 23 Sep 2022
 00:06:19 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Date:   Thu, 22 Sep 2022 21:06:10 -0300
Message-Id: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0052.prod.exchangelabs.com
 (2603:10b6:208:25::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|PH7PR12MB6611:EE_
X-MS-Office365-Filtering-Correlation-Id: 378363d7-e509-4e50-d0bd-08da9cf77102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z0T25oMMJ8cYoiC4QRrTjHtsAqgDlNU14tbnTbYK64iqGqifYf+xU7IB5WIGu4ivUiJ6NhcnkvA+wZU0D44E6rmQEvynIR8lTUJhGm4Y5CH3A4QdukE03RAMBRFJhWTyNig0ve7rp0hQMiOqKIBGhg/wjPUHR/bkTOOJ+I4oqiMkK3m081BsggvirM6nRioz+WHtyS96kZNCzfzsUlvLpstLQPEaw3TmikdO4YFdZ2p9H8bKTpesCSVO5C8qxxrlWrkf9eenWQCe/0YxvfFJHPl+Dufp/SG9LvK7s2G+5nuZHeVxOs7nfqZ0qYKlTvsdqKsx2uL1/yC8DZlUPOy+InFqcFXZYlSh6lCJuIsGUH8ZrUhc7/SbcdkYt0nG0Gjw/Ar/LzILqBEqzdRd0SVlygE0fdZuDUPqtUGpPSogvVgArC0cPty/hPf4YhZgsPJth3NFEksk6AFaT04PMTQCGODhR4yo75b2boWz6SbMK1G6GUIthMjVN1zW5z1VQibBfiieRJftLZ2lxVWfThWG4xNm0HAzgj5RMGPPRPzbMV5aeZKWqeske05fWWLpFBf+u6Bqf/mNv0PHoLNnoOWyOD2ZYeW4jy5IAIg+Hj+YsDDsHY7p8Cv/D8I4s4w+mb67xfxoq9Cm5yjqiu2W0HvYVuToZyLCunegsTRvA6xsSE6mA7m73OZEubVFe6Hc9aRGNiouxUR7Cqov9DTYFtsRCQh8N/CePaEwsheBREmLtNfQIfJ1iD0ct8J/NdrinO5322yTv4iqKf6PKpcoOoETRbFN66BD+r1Kz1j91OzCNu+1v3EqC0iwwg9LR+GwbVpJSrUpBfbrY92nqh7hV13w9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(366004)(451199015)(6486002)(478600001)(45080400002)(966005)(316002)(36756003)(83380400001)(186003)(66476007)(2616005)(86362001)(8676002)(38100700002)(54906003)(4326008)(5660300002)(6666004)(2906002)(110136005)(6506007)(66556008)(6512007)(8936002)(66946007)(26005)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t0seo+Mgb8OxmUJ5T+YEu1ytaLOWF6Y4fffCepc8uC7Thq2RehpMaNeGpjfr?=
 =?us-ascii?Q?4XnjRWcqBZ+9yXXbQQ0C+lhSCQxheikb7Al82SCwcHD2G9Kia0SzYlxsm8CK?=
 =?us-ascii?Q?TDrD6XZW288YZI096Mf9p2C3bqn5N5Rb5hllFfxXhC8Hv7EUn/BwmayZzzKJ?=
 =?us-ascii?Q?vfHE7S10PdIc90W3LkwF9Y3fPTHfuUmPPWEp1TXoWPuXewN3Boh6cH/hNuB0?=
 =?us-ascii?Q?N0LUF7XczMH8bHdprkCd94d6OM3shaPmt5f+cazGnqScwjHpHgtwVY+uJigN?=
 =?us-ascii?Q?c5ReIP4VUv37Eu78nYgUfY6KZeUkGb6whgd8ZAamsbpSQPen+LChVmk3NXhw?=
 =?us-ascii?Q?Oj0rkF2ImjAWU5W6I2liGuHPCo7WlSz/DDL/5376Rav/eg2LQgWs03Cb6OhO?=
 =?us-ascii?Q?P/OnaU3CWmV8CMhTHhObO/qdrVhl4TijycacK4SrSNX/rflg5ede03/qkecY?=
 =?us-ascii?Q?00FnSJ96Sc1Y5CnYgM3fNzps03enjyODpMugjRVFqD8vD2FI/omfyeZ/q+DP?=
 =?us-ascii?Q?oSAVwTPsibvrhNYiPn7EjzxQDqmC48q/4moV1wbJiThBSdKETgERSjCOQCNQ?=
 =?us-ascii?Q?6HCye7EXUmmNubDy1MI5sCgEmI8kHhI7chFUtfBtjS+n7dqkVb+BmbnDXfDE?=
 =?us-ascii?Q?GdzP4a44uNf6rCNOA69o4izft2jwbeiDddC6b7uLiH9jRqGBIs8NlYCRyCLp?=
 =?us-ascii?Q?aqBahiCiO6wEW3l4ZKT7XI6nIdmM0WSUOnKsy86Mk/xa3t8U0JcsH7rYLxpQ?=
 =?us-ascii?Q?Go7bdfIAA1mUI/YVh3wGINBFA3HfxfIiXe1WA0SREkKEw0wnzgqe8/a0ITqT?=
 =?us-ascii?Q?eyF9CzJU+BxGnGQQH0Ob0cWR9V9qJxT1aQNSoIpuMfFI8drHmesiKfeWEz9N?=
 =?us-ascii?Q?2Nbm6Y09e+50E1mIy3JW9w/S3r78of7nK6N+qkGno4Dmmu0ChvGRnrJ10PTT?=
 =?us-ascii?Q?OnGlix6fQDmc7n90oQXnMT3sLraJf92dU85qmQqttdJRW6S3YW41Ec93KFJz?=
 =?us-ascii?Q?FA35T7dDcQiOzOGJF/dIr2qPqH6DPOcRBp98Y3bw+vSSJ8LOyiGRI59fBIuZ?=
 =?us-ascii?Q?89iO+v5fCnqzI13s7FXXHyokeqyZo+6PC54GYy3AFj8/ZHGAwnkOp515hWT7?=
 =?us-ascii?Q?dYAegg0bO9aOe7kBeA2fOgMgEpLpE1o9Q3psMZ38zhUywREr+Xmh85oQiaFP?=
 =?us-ascii?Q?d3sFnZE89dEd8MIzkGH6PSyX9J6zo9MRNgcpiezYIe7ZAQN8gwVJ/fv5u1c3?=
 =?us-ascii?Q?DLYnBwWBJOWI8BA+vSAOhnIUqcNEHel4L2TbQfIUE9uooGYHrtRTCRbuGI/l?=
 =?us-ascii?Q?b8pQy7B/1dllmjfrrDLoMR5vTQsRjnfA9xetGCn1i73rM39N45kiguYUT2Fo?=
 =?us-ascii?Q?7K/gcdKTWUkdsxvg7CWTYv2/8UBvrxkVg4wKxTYyqnF2oX2iaAXTT3fJkPYo?=
 =?us-ascii?Q?BeFr8Yw7WePVfIrYdKPn66//UfKxfSrunxi3D1oqPWiVBcBY6WP/dWiX715X?=
 =?us-ascii?Q?WTltG8RE+feSujv6gQw7Kk+dGYKV5plhJI7KHV7bLlTeX9n7zrLgyyw1/ENb?=
 =?us-ascii?Q?DHLlf/A4jGO1azB6qrHdAzX7J4wrkXUbabNSzKmK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 378363d7-e509-4e50-d0bd-08da9cf77102
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 00:06:19.5256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uUdaaInrTWuCPgwpIaFmbfEwkjB7NvmWSqRODmHK70QOo8J3Lxw5HXOH4WojpjxV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6611
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

It indicates that domain->ops->attach_dev() failed because the driver has
already passed the point of destructing the device.

Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.h      |  8 +++++
 drivers/vfio/vfio_main.c | 68 ++++++++++++++++++++++++++--------------
 2 files changed, 53 insertions(+), 23 deletions(-)

v2
 - Rebase on the vfio struct device series and the container.c series
 - Drop patches 1 & 2, we need to have working error unwind, so another
   test is not a problem
 - Fold iommu_group_remove_device() into vfio_device_remove_group() so
   that it forms a strict pairing with the two allocation functions.
 - Drop the iommu patch from the series, it needs more work and discussion
v1 https://lore.kernel.org/r/0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com

This could probably use another quick sanity test due to all the rebasing,
Alex if you are happy let's wait for Matthew.

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 56fab31f8e0ff8..039e3208d286fa 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -41,7 +41,15 @@ enum vfio_group_type {
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
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index af5945c71c4175..f19171cad9a25f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -125,8 +125,6 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
-static void vfio_group_get(struct vfio_group *group);
-
 /*
  * Group objects - create, release, get, put, search
  */
@@ -137,7 +135,7 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
 
 	list_for_each_entry(group, &vfio.group_list, vfio_next) {
 		if (group->iommu_group == iommu_group) {
-			vfio_group_get(group);
+			refcount_inc(&group->drivers);
 			return group;
 		}
 	}
@@ -189,6 +187,8 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	group->cdev.owner = THIS_MODULE;
 
 	refcount_set(&group->users, 1);
+	refcount_set(&group->drivers, 1);
+	init_completion(&group->users_comp);
 	init_rwsem(&group->group_rwsem);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
@@ -247,8 +247,41 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 
 static void vfio_group_put(struct vfio_group *group)
 {
-	if (!refcount_dec_and_mutex_lock(&group->users, &vfio.group_lock))
+	if (refcount_dec_and_test(&group->users))
+		complete(&group->users_comp);
+}
+
+static void vfio_device_remove_group(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+
+	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
+		iommu_group_remove_device(device->dev);
+
+	/* Pairs with vfio_create_group() / vfio_group_get_from_iommu() */
+	if (!refcount_dec_and_mutex_lock(&group->drivers, &vfio.group_lock))
 		return;
+	list_del(&group->vfio_next);
+
+	/*
+	 * We could concurrently probe another driver in the group that might
+	 * race vfio_device_remove_group() with vfio_get_group(), so we have to
+	 * ensure that the sysfs is all cleaned up under lock otherwise the
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
@@ -259,19 +292,11 @@ static void vfio_group_put(struct vfio_group *group)
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
@@ -494,6 +519,10 @@ static int __vfio_register_dev(struct vfio_device *device,
 	struct vfio_device *existing_device;
 	int ret;
 
+	/*
+	 * In all cases group is the output of one of the group allocation
+	 * functions and we have group->drivers incremented for us.
+	 */
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
@@ -533,10 +562,7 @@ static int __vfio_register_dev(struct vfio_device *device,
 
 	return 0;
 err_out:
-	if (group->type == VFIO_NO_IOMMU ||
-	    group->type == VFIO_EMULATED_IOMMU)
-		iommu_group_remove_device(device->dev);
-	vfio_group_put(group);
+	vfio_device_remove_group(device);
 	return ret;
 }
 
@@ -627,11 +653,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	/* Balances device_add in register path */
 	device_del(&device->device);
 
-	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
-		iommu_group_remove_device(device->dev);
-
-	/* Matches the get in vfio_register_group_dev() */
-	vfio_group_put(group);
+	vfio_device_remove_group(device);
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
@@ -884,7 +906,7 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 
 	down_write(&group->group_rwsem);
 
-	/* users can be zero if this races with vfio_group_put() */
+	/* users can be zero if this races with vfio_device_remove_group() */
 	if (!refcount_inc_not_zero(&group->users)) {
 		ret = -ENODEV;
 		goto err_unlock;

base-commit: 48a93f393ac698fedde0e63b8bb0b280d81d9021
-- 
2.37.3

