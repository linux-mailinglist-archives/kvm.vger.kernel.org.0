Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4226A4F82C7
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344606AbiDGPZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344609AbiDGPZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:25:55 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2072.outbound.protection.outlook.com [40.107.102.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBF221794C
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:23:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWV69AV281H9Gmg/3AX6pDWc+y8XacG35fLnI8wZbcYXHZApUoPhNYhGh5iP7blrDm9pewUidOsWDBP53u1x/0z8DBYldbrkAN1p3YY7WroJPiYmIxe/AO+081029ipv/JFHe9miwBiEcDJxldGRbOUYzXF+uY3IyR9WRYMdWAg//AU6WN3WZnlFAfQcydR/bfUc8WgJaI3FR9uoQYq6aAoJ4CGx4g3wi6bkhehm7XqCWoEkTC7kNOsfBOhacJWhlBbv7DpBEEHAmfxcQXaSAzz72uAecon/534Grlfbfb55+9HWQok9xIQvDdXEpltEbx0t1FCTYk70j5ZNx0iDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fE8JqbOF9AFUcc8b9RBDT0+xfDpHZCXXNz6iZIyPZI=;
 b=A8/QzcZU8eS2QzAkmtgcz4WtbMS6u6Yj9E3gcgVXxNn7v7FqGXVege62GozYNGu6qekoLjxJqtXm6zguT88TjUJHuGjmMkBgtcVX8h2sN3xvmJapHfSmQ49BxNOp28aO6Nx78oVO3vzGtY7Pl2MRmr4KirgQahCaFXOZGIRrR9IBGwkaYOtcAcT6INZS2nDYza+1srv0t+4riZF1Nj0Ul+gIglKE7HbEO5ZIF188JAC9i3hb8KOWVjzEnzOelkGuiRRgYxC+pziwZ3kbh2pOK6f3NbTKrW3up0Rx+hF+0BnotZyGxiAjN2sq1LWLXtup0/p59Po1Ge0cKDAzRX2wxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fE8JqbOF9AFUcc8b9RBDT0+xfDpHZCXXNz6iZIyPZI=;
 b=DE4D+IbtIL3gH2B8EOugWcmIYjWgpXAhtihGSExhp8XRsFX4nLOOI1zM23/ibjT+PtjRaYFzq4NEv2Tc1V7LCm9LKsq8DPpvaBXbojAoXzjBiNR6mWtjG34iBWdUMcHuPKcS5KyG53MCVmzA2RgKnrVf6uQb6WkCmaoEYnpshC1dmNBqncGMllQuSxHa4OQkXnkCdyexlPwasYeu7Ikxhz/JmsTmxq3a/h+DBFbRajkrNLtFc6cl+veVmswh3ImaKqB13iq6GiV71zASBKYZ+emtPMRU3oLQbPLqIBGlxZguWMLtVXORPFa2agjrQDEqCFYkJkKVyTxQLbhMaa8qnA==
Received: from MN2PR12MB3422.namprd12.prod.outlook.com (2603:10b6:208:ce::27)
 by BN6PR12MB1330.namprd12.prod.outlook.com (2603:10b6:404:1e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:23:50 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3422.namprd12.prod.outlook.com (2603:10b6:208:ce::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:23:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:23:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 0/4] Make the iommu driver no-snoop block feature consistent
Date:   Thu,  7 Apr 2022 12:23:43 -0300
Message-Id: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0010.namprd12.prod.outlook.com
 (2603:10b6:610:57::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faf3ebb8-64af-458b-99a0-08da18aa9d6e
X-MS-TrafficTypeDiagnostic: MN2PR12MB3422:EE_|BN6PR12MB1330:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3422D7DDB1CC18E7620D218DC2E69@MN2PR12MB3422.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q2IHFYn2ul1AvhDJBHy53M8U5DPMqkyYvF9WeY33euGvo8FYlDxK/N4QOpBzWHjHeRJegrspgXhjOSNyVbTkwEku3x0v6XVdef9ePa+Crxmz/2DBD7pRvQx3FcvNncCJgVF05b/S303PWWc48WqEEx5Kxk6jW0FRXW+PJoOBgpeQi2DKRgI2Ursnj83Tq+Utr9WeOvNPy1ABNHnhZRZKMR1TzyLB4mBDlohRZRC7XI0B3bS8hbFTAMQ1/FkTYuFTUmvCVHgM5X8w7JKq6Nw5eS1PDTPcjdhj9Ecg4i5m0ulLsrmWvqtH53pmvHCPbK3B5BSlpQDWm8CpKDvsFLrOwJh418MLMVkcfc07lABRZ0K2sziAI7aP8X2ZHBKJCzF+WGDEyLrvL4iCHWIWyLHifdnaYVXeBGpvN52GITX7KnEGTwqEEcRnwN4qDPIwo+t9n9Rv8xcu+9rtMG1K/cb3iXU6Kmx36/zcw41mYK05JKm+WCqska3WxKiYxAdEgR3JEomuGo0Lxa0vZp6Bv+TOY6mC+b3GoHEKaUgr3GapBUzkeqeUWobI23UEr2eNfeLcaTn5j4G6K6gbkEo5z9b3XbqcQTXAr5JxMS7VLfTmMmRs3m5DCiNmntYSux08EbC8CMjDPuLL25cy1ihLPaBvSnPKRv29hLjHK8xolxuJzfCYfq6T1dE2Fqb1zTpsGz0po7lEoP0cymxY4Rd+IEzAU2u3nsAjTs+wiDEomrQV7+JRSUawh/bQrBHmU73+bqaTESNVpU0pfexQUOioNqOhq04W7WqWE8U1fx/1UgvkAzqjlawil7uAMVbLg4mh33zH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3422.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6486002)(316002)(6666004)(110136005)(966005)(54906003)(66946007)(8676002)(66476007)(508600001)(4326008)(186003)(26005)(66556008)(6512007)(8936002)(5660300002)(83380400001)(7416002)(36756003)(2616005)(2906002)(38100700002)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l3i5mTJFL0Ojid7UXRaEBlrLb5Uw6ho82SXQ+e2KXE2h1LYE7j6aPyHWeJvJ?=
 =?us-ascii?Q?c3ptltCJRNGwoOFCeQ6bh6w8sV1nQoXgijeSxjTJ7kdwrH00yeJP/7iyrkyl?=
 =?us-ascii?Q?+ByNxyfLOTLu+v671lFveAxAzbrEzcH2j6UnUarEUXqbHsPT+UkD1kuosu2l?=
 =?us-ascii?Q?nQKMExTpXAomVlcvZf7F1nra8iBA1jBHVY9rd1FNwgdF5gMKBRPxWCxUD7oo?=
 =?us-ascii?Q?/5b6geMJmAXjR7e3TPBr7ifInWVWsWeDVHKo6XtbsuxmMdVOgHZvzG7jzju+?=
 =?us-ascii?Q?eBPU5Rn74jWxpa9Ae6jIJYerW5ncctuakhlPIsCmSAEefNj1Rxyo3azHQdf3?=
 =?us-ascii?Q?xw+Medzn1lDwvR04Rz+TBhXHFEo/OYXo9tLRxDmhqBpoZYLHb3o8VXTdL/Me?=
 =?us-ascii?Q?S26Cn0P1tUjwBxKPWd1qV07JeVC72d/cvmFMJ1hL3CMD/9ea4iG+VaqGIhYN?=
 =?us-ascii?Q?Atw7BHWOYqe7ojobkP7COcGdiq/JbD6JI/8OG46gt5HI2Z08mF/dR70kLXR1?=
 =?us-ascii?Q?WrJHrRA09K9FpEOv0jYIezkDc5nqaI7+KSLD9JhNu2BCi0tZjTj5lPdnr9JQ?=
 =?us-ascii?Q?b5ekSoZA25V1M8tzOe14KrWtiSpGbWrSob/ZQg4VYqHI733eeoaR62ghKhUs?=
 =?us-ascii?Q?KIuX9PSK0Y23df9Ot4DWOAN+VihCcjBNv/o6PTkgn/Yk0vqtlxVs+1igsN95?=
 =?us-ascii?Q?GJGP1n4+Xsctbzp1BNNQs0aeleqIjS9nDUFWuxzYJFfIk82R1ybEFJtOB/Cu?=
 =?us-ascii?Q?iuLuelxI/FibDJr0244zEnrHPrO7d8CFvEtxEEo9q4i7ZV6NQKvw0/OAeAeB?=
 =?us-ascii?Q?2/SxqgZaDOlvbMxK7FDh79TNYyZHBrjLjt/eYkO01qMTKAvWUMFLmdi1RAYs?=
 =?us-ascii?Q?vShvLqNpSQ+vNLEbuFugvRZWe5npADi09xDW61N8y6RWIkcN0O3dabdtTMI1?=
 =?us-ascii?Q?WFOWy2udslJaHJ8fsZA2TUqQvb4Bm6NvNCt1wsmbO0YHBI3mS1FvVR4Tqj6z?=
 =?us-ascii?Q?mSJguzFN4I6bV3BjuEOaqyH98QMOWO/SXYyFIYL7VO4zN36fbHyEEE9QLDAA?=
 =?us-ascii?Q?g1rvudxrb22ghazXk7dSpvneMfjBj9VyQ4HRXkd4hk28qJO7Pq5oHX1PPTJa?=
 =?us-ascii?Q?5MDUnNZs2Nz08TMrrH7JfOSNu9IpNJ3KyxBs7cAM3hWwgMjMha0/TU+Wnj3+?=
 =?us-ascii?Q?nR0PD20zd+eiikuavCnzVsGgXJXyW2c5rCOjgF6p2vO6cHR7zk9QLIpJXV3f?=
 =?us-ascii?Q?/vHqd8vvhRGZT8Jy+fJlwda7SolhqSNk1AmdhYQNbgk6+HYxKqhxPc6/DFkG?=
 =?us-ascii?Q?teO4Kx22CnEDSSTGUwHrr4QQoY6kIWZH81A0Pl3Z7XfBOF9nUL13+pJAxitt?=
 =?us-ascii?Q?5FUG3j5O+6mRWkKPToywjOvevl6LqlSHjaLkvt4tDzaBeyovUdHDt88neYWD?=
 =?us-ascii?Q?+meDKPsql33IWTlvtqlLK9REb1NgD6uuO6bqT65Gp9AxU1cm8eWulhZ34Quo?=
 =?us-ascii?Q?Sls3+Hh65PORatPtz5X8QRiGEPlOlAghrTdM8n/okc9HVWLOh9P1P13wKoZJ?=
 =?us-ascii?Q?W2ZLLY5ftjq0XMH9dZmUcLxgmFzQ9dm8SWzi/4cP77mL3Q3/yRXQWUeXsolD?=
 =?us-ascii?Q?DgFgzi/A44EfZ4UTti+GoJ2rUdLUCgSoutZQq2mIiep7HZ73pyg10TqK8kFU?=
 =?us-ascii?Q?8IRf8YVnR+HmBF3hzixWGSqY/B1OcI0jlOOgnr/TdD6NUuwbJwxwsbNW9Gu+?=
 =?us-ascii?Q?cIaG/+XKnQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf3ebb8-64af-458b-99a0-08da18aa9d6e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:23:49.1905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFyogTZ7XKrOCy4MJSXhhRm0UcSoaqFIngnqIuiFNqsbsKkJGmtkncMRQpZc68DB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1330
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

PCIe defines a 'no-snoop' bit in each the TLP which is usually implemented
by a platform as bypassing elements in the DMA coherent CPU cache
hierarchy. A driver can command a device to set this bit on some of its
transactions as a micro-optimization.

However, the driver is now responsible to synchronize the CPU cache with
the DMA that bypassed it. On x86 this may be done through the wbinvd
instruction, and the i915 GPU driver is the only Linux DMA driver that
calls it.

The problem comes that KVM on x86 will normally disable the wbinvd
instruction in the guest and render it a NOP. As the driver running in the
guest is not aware the wbinvd doesn't work it may still cause the device
to set the no-snoop bit and the platform will bypass the CPU cache.
Without a working wbinvd there is no way to re-synchronize the CPU cache
and the driver in the VM has data corruption.

Thus, we see a general direction on x86 that the IOMMU HW is able to block
the no-snoop bit in the TLP. This NOP's the optimization and allows KVM to
to NOP the wbinvd without causing any data corruption.

This control for Intel IOMMU was exposed by using IOMMU_CACHE and
IOMMU_CAP_CACHE_COHERENCY, however these two values now have multiple
meanings and usages beyond blocking no-snoop and the whole thing has
become confused. AMD IOMMU has the same feature and same IOPTE bits
however it unconditionally blocks no-snoop.

Change it so that:
 - IOMMU_CACHE is only about the DMA coherence of normal DMAs from a
   device. It is used by the DMA API/VFIO/etc when the user of the
   iommu_domain will not be doing manual cache coherency operations.

 - IOMMU_CAP_CACHE_COHERENCY indicates if IOMMU_CACHE can be used with the
   device.

 - The new optional domain op enforce_cache_coherency() will cause the
   entire domain to block no-snoop requests - ie there is no way for any
   device attached to the domain to opt out of the IOMMU_CACHE behavior.
   This is permanent on the domain and must apply to any future devices
   attached to it.

Ideally an iommu driver should implement enforce_cache_coherency() so that
by DMA API domains allow the no-snoop optimization. This leaves it
available to kernel drivers like i915. VFIO will call
enforce_cache_coherency() before establishing any mappings and the domain
should then permanently block no-snoop.

If enforce_cache_coherency() fails VFIO will communicate back through to
KVM into the arch code via kvm_arch_register_noncoherent_dma()
(only implemented by x86) which triggers a working wbinvd to be made
available to the VM.

While other iommu drivers are certainly welcome to implement
enforce_cache_coherency(), it is not clear there is any benefit in doing
so right now.

This is on github: https://github.com/jgunthorpe/linux/commits/intel_no_snoop

v2:
 - Abandon removing IOMMU_CAP_CACHE_COHERENCY - instead make it the cap
   flag that indicates IOMMU_CACHE is supported
 - Put the VFIO tests for IOMMU_CACHE at VFIO device registration
 - In the Intel driver remove the domain->iommu_snooping value, this is
   global not per-domain
v1: https://lore.kernel.org/r/0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com

Jason Gunthorpe (4):
  iommu: Introduce the domain op enforce_cache_coherency()
  vfio: Move the Intel no-snoop control off of IOMMU_CACHE
  iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the cap flag for
    IOMMU_CACHE
  vfio: Require that devices support DMA cache coherence

 drivers/iommu/amd/iommu.c       |  7 +++++++
 drivers/iommu/intel/iommu.c     | 17 +++++++++++++----
 drivers/vfio/vfio.c             |  7 +++++++
 drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
 include/linux/intel-iommu.h     |  2 +-
 include/linux/iommu.h           |  7 +++++--
 6 files changed, 52 insertions(+), 18 deletions(-)


base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
2.35.1

