Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1746A5F46D7
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 17:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJDPkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 11:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJDPk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 11:40:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550381705F;
        Tue,  4 Oct 2022 08:40:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxFW8oaIoKWz2Z4b3AD9iBIcZFQ4kj+B4H4AKbkEW1wT9pFM9zKik45B/22AhJellmMTUSnqSh+jLuadH4EVARzpNMXB5bUQnqYBuL77gSYw23/RYS5QCS+8RiD5AbxQJrEQTgLRLGRVplt53ExojKZz7LKop6WVnT5TkwA9GV+i6bHPTL+ZxN/0vbNsdmF6LbltuDsCu0qtsubHpIYRIeMq/iJ7AXHr0tp0vbrNpjTg5L56Ka5rsy9EiV1R6W3R3ogdK3XEsED3mU5ILkXzTOm1jzkqbM70ts6Zybr7ghw3xaa1BbZ/XFJ8GTAsrfdPe+sd/q8AktgO4fQagPUYBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJZk9HuCbJgeLfMxYHiJtk8yAMzqhw04l1g4MNeqUo0=;
 b=ih9ZI52R2LA6la/FazDwwWIV6TkMfOk30IP2pZw/pPO58ce7VsJTXcARYJr5+PBUUAiU3RGEZ1C/RQdwGSwX4xsXfoOKfcx0GjS1xZaleuI8l5TokeGyU7EAMwS5t2Be/2JQ8wUbgfPboT/SFZyV/rNoHeZzlFO6ZQY+AGhmewRGZY7T8d5DSewDsns0bOjF73qkCPmXjTH8mzQHI5lRjGmqvdsTNHzVzoe5WSGEFcxC9XZRdaV19UpaFRBN1gl9JaA82jra9lVAWDJmQ6EfVybK9Mr7OHkmmULqnuVYpnCUyT9ti2qPNGSeSBlhTHlQX+Xa8iezWE68sLLI5YKU0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJZk9HuCbJgeLfMxYHiJtk8yAMzqhw04l1g4MNeqUo0=;
 b=LYvrBz4UTQ3WP5KSDupFAVPmT9X8wstop7XObCrovazZgyZXsZJCS77s4jbP2mSCkYFupId8lPWoy8OzdISWr5S+RRWMcCWUpBl7p9JLLPCySe1tnBsIza7qmaFuo94OzR+p88DSMDlqIIah8ZnRnsaCg1ELSKwrxRyjLTa+110KXggIj2vXJ8CYFqwHfbaSRleI6qHdZt51DNcQRo777l/JLW6oM9Q9mhJdOtnZACcXIKRrgUD0uLMw/dt3X5XV0ARIyGNA1NJaByRhAywrvJBJNw0z1G3GtfqKoTADCfU5sZmh95tTIRYx5yoyxI97iQGZjGBDghuP7R5/zgnRBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5383.namprd12.prod.outlook.com (2603:10b6:408:104::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 15:40:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 15:40:26 +0000
Date:   Tue, 4 Oct 2022 12:40:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Message-ID: <YzxT6Suu+272gDvP@nvidia.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
X-ClientProxiedBy: MN2PR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:208:23d::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|BN9PR12MB5383:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c0cf703-9172-4c6e-50d2-08daa61ec250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KiueZbAXJ+knQrHC9bVRjCkP8daE8KT+rSdL4BouwcEY66B4GPJcEUKXMyO2r9TsOIXS5vKo/VsD6hsib63ptTcv9ggdk540MhCTxNMrl448LRXmbPmoZFCTVZTCAzMjZrsdqy3pse0ZTyIVGGnt/J2dYVPcaWuKfQbwdvkbKLInrBQrJbzOgXTOmmN/2jec7wi0+0AYz7jsGjpek8TaBTkS8zv6yBu6CAdy0sTn4lXJ8LU3G6Z2NHEE6xBjO9P4yeZjcdmSBg/DOVLuUu31mMmP/NJbt6PPgOaNmpbbP31hCDOWBHxoG/VRnHNXcm+O5oUKGibu09eszchfCGV7ULNUPiP+YeTa9sss5r1D0bTZuqLZ4Vr3Mr0kQvG5zKFtW8ZpgmVciZVrYbJ8oQZwCXKIkop5pPw6LUUzG0m4R5ggZ9ANEHLqHM9FN2Vif3ZzzMR6We4dI0tb1jmMKtG3y70wKDm6rSCQjcLb/F5XJ2FkIAllOJp6F3tZ/sdvHyNXCc9XdzEZub+ymZy+IS5Vnj1ysJmEsxMyurryZ8DJmQM6QS5tJYsPN1lFIKZBKdZlHApNnF9D3DWGxWTS/D2PHetlmlXfHviGfeI1Dn9sWV2kUZCyD7Sje27Uptx6SXe3GgxeCfSBHFHuOY4WZWSJ+qA1Umd03WD/pyqvWDZuFgls7t3jlD33Rj5g9ZjAkBOTvCTOU0rtR4N1yjQdIQKssy0uGeEmmb4hkW/nRnztOi5tt98eY2bGNOjtck/CXPZ7zpuHWcw02Z/Uex1J8PvLP4QY1S7frrt47tNqk6wSELkzTSKYuNfvuUeu5SHTykhza283HothGq1sU5W05B/X5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199015)(966005)(6486002)(316002)(478600001)(45080400002)(54906003)(6916009)(8676002)(4326008)(66946007)(66476007)(66556008)(8936002)(5660300002)(26005)(6512007)(41300700001)(2616005)(186003)(53546011)(7416002)(2906002)(6506007)(36756003)(38100700002)(83380400001)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rxGMOxy1JGQkwlHuNc/UYR3hvQJxgcmSyICF+Hj0dq9o/YmnP4b4djFUmshJ?=
 =?us-ascii?Q?SSbeOfXC7RC9jw0L3Hjb0AYuN4c7ox783MBXeXQZM3JcpTmrex3k+mn9qBgw?=
 =?us-ascii?Q?yFAyyB0iM34WmLhrlSi4eJ4OB1LzMzXRXGoqPIljzhUoE1xoxmti8/anG6+1?=
 =?us-ascii?Q?L7SiWkxW6evYF6yoiaOdC79AQ9CJeBudWiiiTogCc1St7t7wAbR0exBThnbu?=
 =?us-ascii?Q?24QV4A3nGe+CAgOo05cYSQrq0ujhWswFh9xU8l2LEDAZWxocRIc0Aw44vwt5?=
 =?us-ascii?Q?p52pQLC5s0yeKmnt3LVtNnHVCSe+zfzYi0f7/Bu0WyZq80aF01kZHO17wOMs?=
 =?us-ascii?Q?+CfS46PDCNKiUBpt7Ck8ug3VQ071c4wNLi5dQeZeVVuFteisi8DpjZk8HACN?=
 =?us-ascii?Q?M0k6vIE9E6+HpZfTVeDyRBc4kNvlfmGVgCt2Wxzepvfv6bXnKaqM5qUKdb8c?=
 =?us-ascii?Q?gX5dZfW4WnQsRnKEANK5xRC0zcxEI0ZKUMoJJtBlwseLfbk36knIckCh/lMp?=
 =?us-ascii?Q?FX1iI/PgOKU1dFY/38sDUw369LSN3kHc9iEX6AW7c8ShXGVFK6h5/tuE9ySa?=
 =?us-ascii?Q?eHg3do9Nh6hwYtxVCKnu059z+t7126H9hUH4Neh5iRb3qNDqzA1HUF1wkViN?=
 =?us-ascii?Q?dQzDVcRNHvsA7SfSmR4uF/5+4khg41Kivl1JVd+PL69PkgYqZufkrOk+/TQE?=
 =?us-ascii?Q?1aOANeiMD7m6VqMGKt8vmAUJLIljo0yyXBQctbFWRTVr6MlICyFAYFf6kBZV?=
 =?us-ascii?Q?P7JDF+R8oo0u958NgzzcwIecUGb/RgSp73i/X1J/s3yizxWL9PYwKo/wknB4?=
 =?us-ascii?Q?GvS0jYmvnE3OTqS7lPTuVPc9qN13S2KGkDfkro3lcNgT4RQ99ctwrwhnwsed?=
 =?us-ascii?Q?lpkZFQ1DysE97YVDnzR2qwzthX3UmRZBVe3MMfL8DZfr3YRUDJFJTMMTV50I?=
 =?us-ascii?Q?aOxWugIUxplFi1TLEUhLYYq2ZqI27pnF3nWEhK5FhfZGPNZJrhpbQlZtYShm?=
 =?us-ascii?Q?b3ftEENPzxgk9i0ZzSylB9nlCWa9ZEwTa3Df+2+1K9a+82IY0KyMnfyu31J5?=
 =?us-ascii?Q?OQoQnxAeqHPIOAfI9bQ7qt3ZGBIPsEw7zWfQgXSqITVfLG3eEh9yc94zXf9o?=
 =?us-ascii?Q?k4nEw8txJGBjBDB4HcuWwTHbYPt/P9WcayGp6B+OvN83iTXRoHNd9kge9sqp?=
 =?us-ascii?Q?Hw+s9ynuPD8JVal6QY0Qoc6AK62hQrEgM+eQPYpcTUPe4xDZ0TnTQ0Ujkr6H?=
 =?us-ascii?Q?JThtmQWZ0dIRr8QMrBJwHmqeZkqsXNXc/8+pxbyWwtyP6o/LMbZzuCcj0AKu?=
 =?us-ascii?Q?QnQW7XUA/08VFY17W9OsSH9C3yC1mPoHSBdtCiAT7z+77Iie4uWrkx6rw4Xq?=
 =?us-ascii?Q?0NFYKWHgPu9totU3FwfWZeXq00T+kc6JLTyzOCHpVr2gLhtoy7nscRou+lOk?=
 =?us-ascii?Q?F1VckdNyKcShoM+iKPsx2h3xvGHTHMBL5yLfki4N83K0LuybrmxBaHcl2G4x?=
 =?us-ascii?Q?4RgkH60+8f7vIB9gnEK2VUup5Ssw4Cq1+GNgQvHnkAnvhOjaexoJObou0Jmi?=
 =?us-ascii?Q?Hp4x02asGZrW14DT6/o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0cf703-9172-4c6e-50d2-08daa61ec250
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 15:40:26.7650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5ova5G0DiFR6LQJcVblbJbOBdtdBMwi9lTAl8o5VRTuUm143iXThGj8+9KEkKD1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5383
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022 at 05:19:07PM +0200, Christian Borntraeger wrote:
> Am 27.09.22 um 22:05 schrieb Alex Williamson:
> > On Mon, 26 Sep 2022 13:03:56 -0400
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> > 
> > > On 9/22/22 8:06 PM, Jason Gunthorpe wrote:
> > > > The iommu_group comes from the struct device that a driver has been bound
> > > > to and then created a struct vfio_device against. To keep the iommu layer
> > > > sane we want to have a simple rule that only an attached driver should be
> > > > using the iommu API. Particularly only an attached driver should hold
> > > > ownership.
> > > > 
> > > > In VFIO's case since it uses the group APIs and it shares between
> > > > different drivers it is a bit more complicated, but the principle still
> > > > holds.
> > > > 
> > > > Solve this by waiting for all users of the vfio_group to stop before
> > > > allowing vfio_unregister_group_dev() to complete. This is done with a new
> > > > completion to know when the users go away and an additional refcount to
> > > > keep track of how many device drivers are sharing the vfio group. The last
> > > > driver to be unregistered will clean up the group.
> > > > 
> > > > This solves crashes in the S390 iommu driver that come because VFIO ends
> > > > up racing releasing ownership (which attaches the default iommu_domain to
> > > > the device) with the removal of that same device from the iommu
> > > > driver. This is a side case that iommu drivers should not have to cope
> > > > with.
> > > > 
> > > >     iommu driver failed to attach the default/blocking domain
> > > >     WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
> > > >     Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_ib sunrpc ib_uverbs ism smc uvdevice ib_core s390_trng eadm_sch tape_3590 tape tape_class vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 mlx5_core des_s390 libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core zfcp scsi_transport_fc pkey zcrypt rng_core autofs4
> > > >     CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
> > > >     Hardware name: IBM 3931 A01 782 (LPAR)
> > > >     Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
> > > >                R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> > > >     Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
> > > >                00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
> > > >                00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
> > > >                00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
> > > >     Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
> > > >                            000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
> > > >                           #000000095bb10d24: af000000            mc      0,0
> > > >                           >000000095bb10d28: b904002a            lgr     %r2,%r10
> > > >                            000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
> > > >                            000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
> > > >                            000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
> > > >                            000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
> > > >     Call Trace:
> > > >      [<000000095bb10d28>] iommu_detach_group+0x70/0x80
> > > >     ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
> > > >      [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
> > > >      [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
> > > >      [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
> > > >     pci 0004:00:00.0: Removing from iommu group 4
> > > >      [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
> > > >      [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
> > > >      [<000000095be6c072>] system_call+0x82/0xb0
> > > >     Last Breaking-Event-Address:
> > > >      [<000000095be4bf80>] __warn_printk+0x60/0x68
> > > > 
> > > > It indicates that domain->ops->attach_dev() failed because the driver has
> > > > already passed the point of destructing the device.
> > > > 
> > > > Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
> > > > Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > ---
> > > >   drivers/vfio/vfio.h      |  8 +++++
> > > >   drivers/vfio/vfio_main.c | 68 ++++++++++++++++++++++++++--------------
> > > >   2 files changed, 53 insertions(+), 23 deletions(-)
> > > > 
> > > > v2
> > > >   - Rebase on the vfio struct device series and the container.c series
> > > >   - Drop patches 1 & 2, we need to have working error unwind, so another
> > > >     test is not a problem
> > > >   - Fold iommu_group_remove_device() into vfio_device_remove_group() so
> > > >     that it forms a strict pairing with the two allocation functions.
> > > >   - Drop the iommu patch from the series, it needs more work and discussion
> > > > v1 https://lore.kernel.org/r/0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com
> > > > 
> > > > This could probably use another quick sanity test due to all the rebasing,
> > > > Alex if you are happy let's wait for Matthew.
> > > 
> > > I have been re-running the same series of tests on this version (on top of vfio-next) and this still resolves the reported issue.  Thanks Jason!
> > 
> > Thanks all.  Applied to vfio next branch for v6.1.  Thanks,
> 
> So now I have bisected this to a regression in our KVM CI for vfio-ap. Our testcase MultipleMdevAPMatrixTestCase hangs forever.
> I see  virtnodedevd spinning 100% and "mdevctl stop --uuid=d70d7685-a1b5-47a1-bdea-336925e0a95d" seems to wait for something:
> 
> [  186.815543] task:mdevctl         state:D stack:    0 pid: 1639 ppid:  1604 flags:0x00000001
> [  186.815546] Call Trace:
> [  186.815547]  [<0000002baf277386>] __schedule+0x296/0x650
> [  186.815549]  [<0000002baf2777a2>] schedule+0x62/0x108
> [  186.815551]  [<0000002baf27db20>] schedule_timeout+0xc0/0x108
> [  186.815553]  [<0000002baf278166>] __wait_for_common+0xc6/0x250
> [  186.815556]  [<000003ff800c263a>] vfio_device_remove_group.isra.0+0xb2/0x118 [vfio]
> [  186.815561]  [<000003ff805caadc>] vfio_ap_mdev_remove+0x2c/0x198 [vfio_ap]
> [  186.815565]  [<0000002baef1d4de>] device_release_driver_internal+0x1c6/0x288
> [  186.815570]  [<0000002baef1b27c>] bus_remove_device+0x10c/0x198
> [  186.815572]  [<0000002baef14b54>] device_del+0x19c/0x3e0
> [  186.815575]  [<000003ff800d9e3a>] mdev_device_remove+0xb2/0x108 [mdev]
> [  186.815579]  [<000003ff800da096>] remove_store+0x7e/0x90 [mdev]
> [  186.815581]  [<0000002baea53c30>] kernfs_fop_write_iter+0x138/0x210
> [  186.815586]  [<0000002bae98e310>] vfs_write+0x1a0/0x2f0
> [  186.815588]  [<0000002bae98e6d8>] ksys_write+0x70/0x100
> [  186.815590]  [<0000002baf26fe2c>] __do_syscall+0x1d4/0x200
> [  186.815593]  [<0000002baf27eb42>] system_call+0x82/0xb0

Does some userspace have the group FD open when it stucks like this,
eg what does fuser say?

Jason
