Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A298E74ABA2
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 09:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjGGHOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 03:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjGGHOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 03:14:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175741BF4;
        Fri,  7 Jul 2023 00:14:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jN4AhUA4c9urj78TWnneygeLKIbNge47/LNB9PIbxm7mKtfEqVgEogRkafulCsmOEvKl/LRyz/1+s2tmeKKQMds1GI3PYk8U4NDJjh5NoT/vwDSvdjjJEf/b5IF8YADTyyri5oCCVjnTtRUOGW52i1Pkcabv+1BTbt9cx4Ba58QiyfGgZi1r5U/syIklItIcQFOIx7UF1fu15V1lvkfl1IAygVjx5P3kVdzbhLdxrDLzv+3gbdyyHB9+/mU0l7NEY4AI3Dotu+qo9+hJ3zt0bE8fiAhXRLJLV0UWO2WSYtg98KMUqoLdM2zg4Q76NMe4ag0MvDYcCxlATCxvVxZL4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smwsHN2nRzIVTXui5aZE5eAU68m04FgnihM4zVMiziw=;
 b=mDb5M6tOxBvY0W0EP8Ni69MQoj8FEzylRMBxoMr8Xtr+BPBRA+ZxZC9iL3rDGoOW46b1pvPjXnqiTmoQ6tVaC+z6e5yuHzJTcS5g1iZad9EioWvpHjF23Y4jVGqPAgvu6f/F7j6akFnjzMY2mXzWz0rMfLa+ZJSaok7Ca4nIAFXgbvE5VjCBaCukQDP4pC/0jLOpQ0n00X4egvlJvmgHmS1tAL4WbIxGy9nYIRNKZQjgdu3L9u7YP+TpIMbseHP0rCxyANa4cmy/s1vvIx14YxLrevAS6gYC6B5DLGDIzSAIDITPuLNRS7wWBwaxZftDHJ8EHZHvBI2Fbs0XXGQC5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smwsHN2nRzIVTXui5aZE5eAU68m04FgnihM4zVMiziw=;
 b=KiEFN3WrYRYpEFxd4jSdj27NuYEU6+T7Bw2URoRqO5B9+G3uVj6MiERd3HoN+8GXZXZ/+zfff/9V/1RLzeb4M45e2RFMuOrdxxHJsb7RrxHoSO12ib86Gf6/2XFnPoOIcTSugdibQYMpA8YCqVK03Jy6MV6doAA5U4fpoBqVgDyp/VHPa7UVyZF3WguZQ8JB4qamOZbtGJ1B52aBwHsQc6Or94SRlqVCtkFRhGd2hcde7I0x2iOmVszo08HRt1JhoojfHBQhEu/SYsDbTF5OqWLvupL9T9cn/huBiqkrSzC/7KQXfgN5Ys+whyiadNKxNb+hXsAWi14onKYvE5v1fA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SA0PR12MB7075.namprd12.prod.outlook.com (2603:10b6:806:2d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Fri, 7 Jul
 2023 07:14:35 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::6cea:921f:eb00:c1e7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::6cea:921f:eb00:c1e7%6]) with mapi id 15.20.6565.025; Fri, 7 Jul 2023
 07:14:35 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     akpm@linux-foundation.org
Cc:     jgg@ziepe.ca, npiggin@gmail.com, catalin.marinas@arm.com,
        jhubbard@nvidia.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nicolinc@nvidia.com, robin.murphy@arm.com,
        seanjc@google.com, will@kernel.org, zhi.wang.linux@gmail.com,
        mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        rtummala@nvidia.com, kevin.tian@intel.com, iommu@lists.linux.dev,
        x86@kernel.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        Alistair Popple <apopple@nvidia.com>
Subject: [RFC PATCH v2 0/3] Invalidate secondary IOMMU TLB on permission upgrade
Date:   Fri,  7 Jul 2023 17:14:22 +1000
Message-Id: <cover.2c09c745ade01a7ef661733d0bbc39d645b6bde0.1688714027.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYCPR01CA0024.ausprd01.prod.outlook.com
 (2603:10c6:10:31::36) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|SA0PR12MB7075:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a2713a6-9010-416b-7ef7-08db7eb9d14e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: exYVpFKjEaEYon4yfvZbZ/X8U7LPasBqVRpuIUg2FwdwB48DAcqJkfVJKhSSXSb8rc5uRo8Mt1XolhBHYI/PNeFIwKRBD+9coTCAip3WgtS70MKQALpCmXoADDmwhVJiDUPtTfDoOQDg/vVoQKv+86MtMws2p2u8Sd+FFfLBr0GycoD1kX/npUaugXC6+0D+V+KDsRe4TZoQ8wK959VvKP7D5q1DQVyi8vKELvnykIAb9VtE/E5cvSFpqeF8fHsItCK7YuFJZ0CwmYnXyjZDA0GQoyutwhZsYKOT3ZSjmK76pUzTtnajDJ/R+n8P6QyQRGBGYgMdGzgAG9RrFiILWg6qx2zpKcVLPYCAET6wRnCqnSJUofEl8Pn5/xMgU/FqLVDHJXbbaS1kuSZMowfyUvcypeaCW8v7VOPoEAhzBkDW22bjEti7hIyrot4hN+9wrnF7O/f5bEzJvhPparndVrgbb28OhuvzDYCHOAxvJP97XgoQVdCiZMsgocdEQbe0YbyxXwdzjjtKg4skUYdKwQyIMkGC4y3shAq+oaTDbeThDp8T/zrlAp+uzlHazgACsLMIBXY+OH/d5HdtJnid2FDhZZcTw1Chi5Vxdz7N2u0asHtXf0y6GmJ8w0J1qEvirJj5VnHqmfXJgOjF5Z885A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199021)(6916009)(38100700002)(66476007)(4326008)(66946007)(66556008)(2616005)(6666004)(186003)(6486002)(36756003)(966005)(107886003)(86362001)(478600001)(6506007)(26005)(6512007)(8676002)(8936002)(5660300002)(7416002)(41300700001)(66899021)(2906002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GkTXYi87vh0Et3SNUDYvNdlq/P9hze4+OjGdy0/ipjEAbsSlqyhI0VH7lyJo?=
 =?us-ascii?Q?SVY+mIjEJC1Vb/n91QPNwmKPaFMtUGgitktQIM9Zh1+vnTC5LTQ498+U+lE6?=
 =?us-ascii?Q?4CWPXbz4qQPeRPI6Xu4IBErqVsNcJEoDkvUYnJW+nPz6GIKfOk1tWHBkGEmg?=
 =?us-ascii?Q?BOEvzEEOJlILCKo0/gzLQ4sKljaiSAPP3i4GU+/00azfrMkpzBV507BDypI2?=
 =?us-ascii?Q?qYQMtIeAI+bfEJifGMndL1CbsbJm1j0b/zltL6d6Kw7yApW+CV4b1Z+HHfjl?=
 =?us-ascii?Q?Tzl5PTPbD1hxK7K8kPdWU+tyi9lmKbihgfhB1/4hfDktqSgpHNWJ1Ks+UUSH?=
 =?us-ascii?Q?bEJFztSY1bWex0+uSiI6N7IQkygKk1c7mjYnKGuSsApxz/2uR5nnNJJFNHZF?=
 =?us-ascii?Q?lzpA4wA5ffPRrPM3u4oYDmmQEOJs9wm90LSrqZwDC2KvaSKdT+Enl0BhOm2E?=
 =?us-ascii?Q?UlcFWvo9OGtKWrP53no9iPxoTF0ciMxUlsbROPxqtXfNb77mIR90gE/4gKr2?=
 =?us-ascii?Q?cNokYgaWD3YmIJIM+/2QOlX69tIXolhLvgeLQTTIl8x/Z6YZK767tLUh8pNd?=
 =?us-ascii?Q?aR3WMwVRUxNOAOXBOb+fipkoXhHTmSPc7lMSgKHcKydJFujetRfePLUELJX0?=
 =?us-ascii?Q?wPNlh2B0MUwtAX4qxSW6YzGDWkYi3y2iPVsxXMfxNc5zWAoVgm8kaOWkb+oN?=
 =?us-ascii?Q?OdSrdZ8cd7fBKhKHaiG9+HsFSNH6P6Wq6tNLPV4t6BQZdpc8jNMgE2j4NtxX?=
 =?us-ascii?Q?x68NwtYaHG3FfvmsWarUXA6CJxUlDSlO5Ih4C/8PVV2NQpys2Ady9CZdZ/fb?=
 =?us-ascii?Q?jQmz/E3LC4IzbhbRw2wREM/ETOoQ4JwzxvFcVulOF8fOXjevGKoPrHLu0VEB?=
 =?us-ascii?Q?ckukoLpYUfjiY3uwvhxWHweqVRN//3XyLf2rhhsR1cXsocjTp2Sexc+0bkLf?=
 =?us-ascii?Q?c1CcCU9a2JOp2zHYiE+cid1RRCUKFBM6Lq+0IZ3XDntWiwalqqUoir/LEdWp?=
 =?us-ascii?Q?h7zG05t3jmuUPJrLDNgSBTkhpg1lOKz6Y2IRs/JIKk9G36Dq8DWmWlignemW?=
 =?us-ascii?Q?zOg1/QGDGT0kKpj1DFn91mq2WAoyfauSQyewDOtqoAL1bfJZ1mYmGOo+CeVw?=
 =?us-ascii?Q?Gfu1eD3B/YrP3IODr7Ilieh+Q71MCvUK5i1bVeEHtBJ5R3b92uQ/n4r36v1Y?=
 =?us-ascii?Q?Mxs0Lgzf0IKsJwvgaxwZe0J1usbRVdB4ymrSheI1nWyGTizg0eEVi4e82Vwv?=
 =?us-ascii?Q?uJ8v76l1TzCMw5s9IseQffWrigoaqTWzsesVxg+xOvCesfIBOd6htpjcC+5R?=
 =?us-ascii?Q?wn0vUXvVOpcUrKrVqtwrEIKZAvmaYtUH/cJUBAzC8mTnMpe6/hLPHAn8jL61?=
 =?us-ascii?Q?doXNNsmLfiOxqkqTjrIGxzCUfLjFfOcwnEGls9EDpmkKBXILgrq9+JHMwlPm?=
 =?us-ascii?Q?QU/NJu9qpxkFBjysj8mmzVhZcGXm2WOXZk/RTt4NHbv3JKxh8Xc8y7d7UBT1?=
 =?us-ascii?Q?dCa82gFDp4nbcuTc9VNCSMOYaV1NCw5oewPKnYQdd2PO0vI2mwDMjKQ6Y7lO?=
 =?us-ascii?Q?kZ5Vyij4/g6pLgwF+7XPkBfPkqhOvQkhZc2is8G/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2713a6-9010-416b-7ef7-08db7eb9d14e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 07:14:35.1712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39fwQTVLKt66rvdOfL3t/7G+fbtAy6599Y2uOwNX7c819kYaebrxXUBCF3emiCOWbZpteWTisS9e7Cg6FE58yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7075
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

This is a follow up to the initial RFC posted here -
https://lore.kernel.org/linux-mm/cover.063f3dc2100ae7cbe3a6527689589646ea787216.1687259597.git-series.apopple@nvidia.com/

The main change is to move secondary TLB invalidation mmu notifier
callbacks into the architecture specific TLB flushing functions. This
makes secondary TLB invalidation mostly match CPU invalidation while
still allowing efficient range based invalidations based on the
existing TLB bathing code.

There are some known issues with this series. What I am looking for
here is comments with regards to the overall approach. These issues
will be fixed if we continue with this approach.

==========
Background
==========

The arm64 architecture specifies TLB permission bits may be cached and
therefore the TLB must be invalidated during permission upgrades. For
the CPU this currently occurs in the architecture specific
ptep_set_access_flags() routine.

Secondary TLBs such as implemented by the SMMU IOMMU match the CPU
architecture specification and may also cache permission bits and
require the same TLB invalidations. This may be achieved in one of two
ways.

Some SMMU implementations implement broadcast TLB maintenance
(BTM). This snoops CPU TLB invalidates and will invalidate any
secondary TLB at the same time as the CPU. However implementations are
not required to implement BTM.

Implementations without BTM rely on mmu notifier callbacks to send
explicit TLB invalidation commands to invalidate SMMU TLB. Therefore
either generic kernel code or architecture specific code needs to call
the mmu notifier on permission upgrade.

Currently that doesn't happen so devices will fault indefinitely when
writing to a PTE that was previously read-only as nothing invalidates
the SMMU TLB.

========
Solution
========

To fix this the series first renames the .invalidate_range() callback
to .arch_invalidate_secondary_tlbs() as suggested by Jason and Sean to
make it clear this callback is only used for secondary TLBs. That was
made possible thanks to Sean's series [1] to remove KVM's incorrect
usage.

Based on feedback from Jason [2] the proposed solution to the bug is
to move the calls to mmu_notifier_arch_invalidate_secondary_tlbs()
closer to the architecture specific TLB invalidation code. This
ensures the secondary TLB won't miss invalidations, including the
existing invalidation in the ARM64 code to deal with permission
upgrade.

Currently only ARM64, PowerPC and x86 have IOMMU with secondary TLBs
requiring SW invalidation so the notifier is only called for those
architectures. It's also not called for invalidation of kernel
mappings as that doesn't currently happen anyway so it is assumed to
not be required.

============
Known Issues
============

Not all TLB invalidation call sites have been updated to call a
notifier when required. This results in test failures due to incorrect
TLB entries. Obviously that will be fixed if this general approach to
fixing the bug is adopted.

The kernel TLB flushing functions may also need updating (see comments
in patch 2).

[1] - https://lore.kernel.org/all/20230602011518.787006-1-seanjc@google.com/
[2] - https://lore.kernel.org/linux-mm/ZJMR5bw8l+BbzdJ7@ziepe.ca/

Alistair Popple (3):
  mm_notifiers: Rename invalidate_range notifier
  mmu_notifiers: Call arch_invalidate_secondary_tlbs() when invalidating TLBs
  mmu_notifiers: Don't invalidate secondary TLBs as part of mmu_notifier_invalidate_range_end()

 arch/arm64/include/asm/tlbflush.h               |   5 +-
 arch/powerpc/include/asm/book3s/64/tlbflush.h   |   1 +-
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c    |   1 +-
 arch/powerpc/mm/book3s64/radix_tlb.c            |   6 +-
 arch/x86/mm/tlb.c                               |   3 +-
 drivers/iommu/amd/iommu_v2.c                    |  10 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |  13 +-
 drivers/iommu/intel/svm.c                       |   8 +-
 drivers/misc/ocxl/link.c                        |   8 +-
 include/asm-generic/tlb.h                       |   1 +-
 include/linux/mmu_notifier.h                    | 104 ++++-------------
 kernel/events/uprobes.c                         |   2 +-
 mm/huge_memory.c                                |  29 +----
 mm/hugetlb.c                                    |   8 +-
 mm/memory.c                                     |   8 +-
 mm/migrate_device.c                             |   9 +-
 mm/mmu_notifier.c                               |  47 +++-----
 mm/rmap.c                                       |  40 +-------
 18 files changed, 96 insertions(+), 207 deletions(-)

base-commit: a452483508d7b70b0f6c69e249ec0b3ea2330b5c
-- 
git-series 0.9.1
