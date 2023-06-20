Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077B2736AC7
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjFTLS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 07:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjFTLSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 07:18:53 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7551FC4;
        Tue, 20 Jun 2023 04:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsrnZdZBLURqFSffYlbxkFrewqP48kaDPmCtPwonmqZ5kkJRm/bNp3AVeUU1wDkMJ5T3yFpJF7Yg4Tm0/xFidgUb1UNp6DKzZTUgplrOy7SEFhmZl2qNp0xnqCPJp71LP6cj4DqFdWKHKfIfWmMnfFVdTrKt9Hlj+h0IIbuZaYfKkrgnbhJXJSCly5nJNFk0shliNO3H4jcQVt2pt3CRi0D/xvMPSky2cuAEU0z/HjaUEzlu9KgaelkHOAuodG3vGsMZpT3M5OjJQ7tvlSv28BdXhOTmfyIekiJSD84IkFvPKZIv4RCfNvo4/9Gh4oEgSZyAYRSJGvBmGr8lvPQ3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RON3FyJ218q51xTUwnoGY4rtgJ0r2w6Gqb9v7YBdNS8=;
 b=Xwx3k+riR1hwytrRi8K/MUov9Q2hU8Fb3snQkKGU+5jDbPwu6WtoeBX+Ry82K4RfB79wAjQZ59/OWUF1AaAdO5bkSCnkHYol9LokPv5uYABMgrXqdv/OzyqflIVAF15L0dNuqfpBXShBUeVTms3Y2r5DRacbgyWMxv3Bhudgui3awjLMvKPYoU/vk3dBoAhnR5vz6iTjbmqX8VLGEwx4IVZYa535kRHWEfUR4Szlj+Z6O589EKSueRu+zbGcPSjKMYkn6Gq4eKwI0ZKTh7A4Gxiu+2MD1/daLToJ/lcA7FDvgGIFsTu+i5Du4qroASc4IeEEBgn+3QB2q2b5exg76A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RON3FyJ218q51xTUwnoGY4rtgJ0r2w6Gqb9v7YBdNS8=;
 b=QGXSFQkxNCUURFR0ZSVegp4LkvQG9UtqNVQzapOCdSnNxP4LU+cEprhJ0MwULJ1MFWYBjreXz32UluCB4mdr0E08dpYqALivsUtb49UtwNDbmXi6t/5C4Ny23Fbv4bvYEs/VwXHpyCaYlC/glK3QEUBezNaw4PCn1h12F9pnztJXO+NME5NsciRP0gNHXiDVrP/5qebSKVku48k+I1iGp5WsW92QLgoZizmm2xfL9UCIJC170OUhFo9TkAosDwVhajQkrnihjcLQgpPLM0XcZbT1XkhL5TUAi9QWPMpA+gkaedUuSGGmontZ6bTONjxfi2FdZtPwOQ1iRp9/B9gyFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 11:18:49 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d%3]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 11:18:49 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     Robin Murphy <robin.murphy@arm.com>, will@kernel.org,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>,
        Alistair Popple <apopple@nvidia.com>
Subject: [RFC PATCH 0/2] Invalidate secondary IOMMU TLB on permission upgrade
Date:   Tue, 20 Jun 2023 21:18:24 +1000
Message-Id: <cover.063f3dc2100ae7cbe3a6527689589646ea787216.1687259597.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0040.ausprd01.prod.outlook.com
 (2603:10c6:10:1f8::6) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|IA1PR12MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: ce89a065-45a9-45c4-4277-08db71801f1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uMzN2pbYEr9GM6/DfrLEK3qGW9HNTJUvy63jyvuShBWybG144RD25dKu/kCB8nbrhfGJQS6ZG4+0WluGKj+QoRtJulH5xVvA117hVnEU4XXS5TXD7CYzo2MjPLf6QICT1wmccVdNmAzDQGZenVVwW6UuPnS/WU0f1M7n8r/NBCNjFzQw5dRWWV1wdEnHDnvPsF8bVCsFtL0fgu6SjpDv9FbzZPuiwVWWm/P+qZTfaNHWKaABznIdjwbO/YfMYJnvhc/rQEWVUU17bQzjxDh8Ll+L2FXtFIlhxOXtgrnShPS40HeeHeVCaZbnUcOC4ScUp+VgTu6oi+tb60VURhSitg8b0y5bDzhIb8p/BB0/K/pyOT4q9lSaPsyvIwRiNgnXkZABYyH5q8duUv2VQMINElUM+MdPmSluiBJBHeaGxTeijlN+X1HBJ/ehdKYSFadRf6hZVDTQ7fbrluHyyvTXpQ/d6w4jdsQVv534vScqCP28PdTxxjPoDqOXJBcXl0+5d06zbc4uhPLdN+SI2rXEXZwE9n27oUc2r/hVp0M+G/XN7S9+XSmJjdykiEvpGn43XX/k4xFaHHGWPz2keqom4GiPB2DNb5nrLZ1TzfUUfJe/8ZFa4UTXZICx8nNF2EoChrtjl17mOHv/rugfYwZEXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199021)(8676002)(8936002)(66946007)(186003)(66556008)(66476007)(66899021)(5660300002)(54906003)(4326008)(26005)(6666004)(6486002)(316002)(478600001)(41300700001)(36756003)(966005)(6506007)(6512007)(38100700002)(107886003)(7416002)(86362001)(2906002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G/eBYveVd1JkDZXnI22LGrgqBDiX3i2/hwLtDRLZoqgeemsSyUNW69Vdq1G3?=
 =?us-ascii?Q?2RiPH/k+RVQFGxBktPZsNcrRQVleYNIK6DW2Zw/5s80s3OtQ5neBKhC2yDyw?=
 =?us-ascii?Q?sPGkUmd9C6PcBGqM1WgwEHPfqmLit71xnXICF7roUOnlEgP3dyCVQfT6Ukuw?=
 =?us-ascii?Q?flbmn04KzlqfYHebjFT4rVnI2PRPvDv8wSCL8X/g+fvQ3ff1j+OdOwrKhHm1?=
 =?us-ascii?Q?dCHbwudLTVubeMDcLbFFFmh70WrwCGyYWYITuBITO3jJBN1YYF+1TVLwSYAc?=
 =?us-ascii?Q?tnzk8XpEtIgJzIl2fY+ytqU3GOBFstv0V7fAUhsnHELMV5LpW2EzSBoo0/nb?=
 =?us-ascii?Q?xW4AijRGWDn47BjDA7I47yGfVWL+SU6cE1PSI3sf82oPeyB+2GN+sOCTmpRT?=
 =?us-ascii?Q?WtadlOzP9K87Nj643X0dYraBKY1DBxhqOVS0wNSUjyZ/8dTI2K0p1uOgzK1a?=
 =?us-ascii?Q?lpsMkqQAg1/9JlKHd7TztGmb5Ch8Dw4afiEXJbc0RP3t4bpPx6AnPKcm7AvE?=
 =?us-ascii?Q?CSwgPMGYOTWgVj6rdV+jd0tMNIinQPAb8l33+RzFBri1xJpfx+AUm0N87DFR?=
 =?us-ascii?Q?mrElCyjBu15D7DeQqwkFZOAhFS7KAR29t3mfCtWwKopkIH23ekViyn8eiss7?=
 =?us-ascii?Q?FhjoQxOERyOAup3EXPaUawCGd4vxpPrbaBst0enQFSvGM6jL79CIE5JBzSNB?=
 =?us-ascii?Q?GgNzjhpCw9pRtD2z7LHzQFXa82uBfFZ3IXFKE8sQ/WSSslyPwjGl8Zs06BLv?=
 =?us-ascii?Q?8DL/w4aXj3NWOjo6NU3opHqgSSO4U05hTx97QpyEm7CiqLBzZIHwo25mLhBe?=
 =?us-ascii?Q?beTWTqrUVz5u/1dlAiwm+ZAMSNvaU6WWx57LIjSdVOi5SW9M6AKZPwwvnBay?=
 =?us-ascii?Q?1gorkiNRpQRE3bl0hb92pm+G/fheGFz9YigB7RCRmQiUx1Ht4JWVDtfQOHZI?=
 =?us-ascii?Q?ZNJN+yncphgX8SPiMP7+/C8L7w0ZgDySZ0j4QHgqA2K91S8WsNVjWiroSPqK?=
 =?us-ascii?Q?UhSlEPUsAXrG4k+7CiLOsQYBwilevGLLjBQ/QT5Rbq5P7naCx0bPHAiP0Rlk?=
 =?us-ascii?Q?GvobXrXPQpXhAAiIpAG1n5bjymNHd3jyp2h67APhKa5pIIKp1MnWg35O9XJK?=
 =?us-ascii?Q?3HWS7h1HS9DJWeVS5Aavncdb1UKEu5wTsqk55OH9Xp252hmAe2dCtPR8bG+B?=
 =?us-ascii?Q?JNeL23DK1UsdpGp5eOOrj7JBTNgylniaHWrkc7P3FLuOEMAXKZwGWR6yPozZ?=
 =?us-ascii?Q?E9M9SaO3834p9Xj62PaMpCh/6XDr6VdAuzdczhN1k9ADMzoOit7nNjtqK7d3?=
 =?us-ascii?Q?1O62xwB0S/ogSH1cw9GaZHIEPagmE54hzoPKr+PDuo48h15dMhlJmcI4+Bge?=
 =?us-ascii?Q?QbJoYryoCIyTNhQq1PVYsbDoVD9Ic/PuDaL7ejOV2qVXnTQzahnkhgbpeV5T?=
 =?us-ascii?Q?Mnz3y2gRaXXAI9yA4DWa2iwpzSHusElo6KkOXtMNqYEM/GaS/3SPCWEJ4Pqe?=
 =?us-ascii?Q?yKwI++tmeR5Y5HwFVrMXSQN/wD3T4N8TT3Gwg5EDy4Q0raOD2Qiv/wIF/LQO?=
 =?us-ascii?Q?7hNdaPMxKYjrjNb3sJxe0G5e0kfJiVgKzoRAxRGW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce89a065-45a9-45c4-4277-08db71801f1e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 11:18:49.6452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvutrk7GOIlB9abPjywN6A6sm4oCzePqBIY0mLbx/Sj0gvbKiZkjnDDyiUDBwXxDPUMk9dwp35bkIzLCFTmJKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9031
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

To fix that this series first renames the .invalidate_range() callback
to .invalidate_secondary_tlbs() as suggested by Jason and Sean to make
it clear this callback is only used for secondary TLBs. That was made
possible thanks to Sean's series [1] to remove KVM incorrect
usage. This series is currently in linux-next.

From here there are several possible solutions for which I would like
some feedback on a preferred approach.

=========
Solutions
=========

1. Add a call to mmu_notifier_invalidate_secondary_tlbs() to the arm64
   version of ptep_set_access_flags().

This is what this RFC series does as it is the simplest
solution. Arguably this call should be made by generic kernel code
though to catch other platforms that need it.

However only ARM64, IA64 and Sparc flush the TLB in
ptep_set_access_flags() and AFAIK only ARM64 has an IOMMU that uses
shared page-tables and is therefore the only platform affected by
this.

2. Add a call to mmu_notifier_invalidate_secondary_tlbs() to generic
   kernel code.

The problem with this approach is generic kernel code has no way of
knowing if it can be skipped or not for a given IOMMU. That leads to
over invalidation and subsequent performance loss on the majority of
platforms that don't need it.

3. Implement a new set of notifier operations (eg. tlb_notifier_ops)
specifically for secondary TLBs with a range of operations that can be
called by generic kernel code for every PTE modification.

See [2] for a prototype implementation of this idea.

This solves the problems of (1) and (2) because an IOMMU would only
implement the operations it needs. It also keeps the layering nice as
theoretically there is no reason a secondary TLB has to follow the
main CPU architecture specification so is free to implement its own
operations (although I know of no hardware that does this).

However it adds complexity for dealing with a problem that only exists
on some implementations of a particular feature on one
architecture. For that reason I think (1) is the best path forward due
to simplicity but would appreciate any feedback here.

============
Other Issues
============

It is unclear if mmu_notifier_invalidate_secondary_tlbs() should be
called from mmu_notifier_range_end(). Currently it is, as an analysis
of existing code shows most code doesn't explicitly invalidate
secondary TLBs and relies on it being called as part of the end()
call.

The disadvantage of changing code to explicitly invalidate secondary
TLBs is generally it can't take advantage of IOMMU specific range
based TLB invalidation commands because explicit invalidations happen
one page at a time under PTL.

To solve that we could add secondary TLB invalidation calls to the TLB
batching code, but that adds complexity so I'm not sure it's worth it
but would appreciate feedback.

[1] - https://lore.kernel.org/all/20230602011518.787006-1-seanjc@google.com/
[2] - https://lore.kernel.org/all/87h6rhw4i0.fsf@nvidia.com/

Alistair Popple (2):
  mm_notifiers: Rename invalidate_range notifier
  arm64: Notify on pte permission upgrades

 arch/arm64/mm/fault.c                           |  7 +-
 arch/arm64/mm/hugetlbpage.c                     |  9 +++-
 drivers/iommu/amd/iommu_v2.c                    | 10 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 13 ++--
 drivers/iommu/intel/svm.c                       |  8 +--
 drivers/misc/ocxl/link.c                        |  8 +--
 include/asm-generic/tlb.h                       |  2 +-
 include/linux/mmu_notifier.h                    | 55 +++++++++---------
 mm/huge_memory.c                                |  4 +-
 mm/hugetlb.c                                    | 10 +--
 mm/mmu_notifier.c                               | 52 ++++++++++-------
 mm/rmap.c                                       | 42 +++++++-------
 12 files changed, 125 insertions(+), 95 deletions(-)

base-commit: b16049b21162bb649cdd8519642a35972b7910fe
-- 
git-series 0.9.1
