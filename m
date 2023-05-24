Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9784170EAF7
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 03:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbjEXBrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 21:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjEXBry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 21:47:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E5184;
        Tue, 23 May 2023 18:47:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3Klz7185BB23Ywi5kcAG+hsDsGD0zsYYPEmUQJBse/8l7PURrjv38PuzfULx+HOcKBgGbIUXncloZFwZKo+WhJXUyDITIvpAyaPUsffFhokumIzkhe0AVu6Z6b+FlBKeWEWtxiCfWqW9zvMgEVbv44FGpXSJw70mM3myHOXfIU1tivO2KfGC4l3+t96ru65uT8u9rEMwQosRQesc3Vflit0SLeQ9SOWJ5qAcEQ9dWR3owcovByb4SKyGGYMHLUgt5HGf4U5FGqEbXt99CSXzHBGTOP0NttkcZbwo4IkbjSfnYNJVEKVBNoK0T71N1nSxxaWzYzmp4imx4miqsexVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0pu+6uwCEupTE/Vp/j9b7E3tO0/gX54NU2icWTyJ/I=;
 b=L4JjP3zEGhqg8efRuYMcbkW9JW4W3VgswUTs1HO4cskb+DcEW946RXo04dTsJZ4f9aZEe4lmPHkbrnL912kIp1hOMQnya6HDPgX86/79EHOaRqd8t5IFHlmqMyJ+U8AmSn8AxRXUomhSBVkzdozshYOswpCP63Bk2lklvRahomTGcoritqQzs2tCwH7nTXjZM9/E+WfQ6ZpCjvejzMl/jEbGalPNUZheSnf8ahf4sm61QACMZoMyHyCAXCNTkvj7dHIGoapTPiHd422BOwaOiKbJdKOjq3Ym1oNUYxI/jvaR99VL6nyjkqD9/qNj/Ec8eZ4XzbxXjeSHvbWgJY64JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0pu+6uwCEupTE/Vp/j9b7E3tO0/gX54NU2icWTyJ/I=;
 b=EgU9z4o7CN2t4A5NsxeA59QI90rIZokpR8n5/VmrVFSEH+GaedPXhguTWSySWjCk/dMpAPB/E5KWVU4bTjUWBPnOuuSWMfo4QC6bNjqQWbs4LSLjqhSBbMe3wAS/7tGu+Z+QOu75A+6jZft2vWYK6YWSpLv4AM63mAQ+dcrJRSh3vI5zjvvvd+kU89qmWk2qlKINj+YpCHpaJV1ggRbbSGeYr70u17TenRVZKIQ7lYvJbDjd+BLTo4GZIEddnCdELiwutiBzgLq31CzIvLKfxGTlQdac+POqPlKH1Iqm8OYl7WWHMAJj2mCdDONOIKxYON9/EhStlKQzy+AraJw5gA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3181.namprd12.prod.outlook.com (2603:10b6:208:ae::27)
 by CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Wed, 24 May
 2023 01:47:51 +0000
Received: from MN2PR12MB3181.namprd12.prod.outlook.com
 ([fe80::f0b5:271f:a7dd:9e2f]) by MN2PR12MB3181.namprd12.prod.outlook.com
 ([fe80::f0b5:271f:a7dd:9e2f%5]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 01:47:51 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        jgg@nvidia.com, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>,
        Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 2/2] arm64: Notify on pte permission upgrades
Date:   Wed, 24 May 2023 11:47:29 +1000
Message-Id: <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYAPR01CA0045.ausprd01.prod.outlook.com (2603:10c6:1:1::33)
 To MN2PR12MB3181.namprd12.prod.outlook.com (2603:10b6:208:ae::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3181:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: f9449404-5998-4bf7-901c-08db5bf8e252
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hy36ZKSiMTOnSjGoyuau+MeWoFJ80Um/81u/lmfEjEDv5uQ6EPNXY+YZl7zMBKrmvWQ2qkIFdWsLdvSX/iXIAuB9EBt0akXleagCbHQ2ENphFsgJ6oGicms2dZ8YRcxlxgcJ4/yS0xq//pIVKRozD9uYuh6KGKyL4HvLdqYBZtjCsHQkUWL8pTjno8GqZeDtg5aysEr6YT7V+um5+dX0Mri8k/LlzUJpETbqRdL39wIPGHMaqIdHsd63oS66Oru0ByDG8zhmEMOtmPJKFok1gJ4MXJoMpUdRN2b1dfRK2WHpCec+j4L4HU/cCpOMzT8QQCQYfr2rsAWnw+j9zPeU5spSMOIRVrE7cHZEv4wVpQk4KOTT+7BvEPzXYcUW13OPJbEB2ACYXqc6sJhDfxbdvTReHA8ErJwNm3Ab7BCzifG0Pyd58ktB27YwmvBeteoxUO2g7XzeYvcz1hl/mIFj0ocUQe6PKkf0fOOpwE/DXTiCLSh5MFRixqSgyBYUEjH2U866tk5zMVTwK5XvmFKrndnFxNnL72W9y3bX8VIF/2gy7b3moa1ejX8nNttVw2OpJ0CpoD2Q5F21xze6A1kQjNZ2ksbJ4idMj0de9tFEl1Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199021)(8676002)(8936002)(5660300002)(7416002)(186003)(83380400001)(107886003)(26005)(6506007)(6512007)(38100700002)(86362001)(2616005)(41300700001)(6486002)(966005)(66946007)(66556008)(66476007)(4326008)(6666004)(478600001)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xM/cr1Cl3aJDRb4TgNiMzYmMk+0Y6wjzbCgFgcCqijcQD0mtjbwv2mfBASAW?=
 =?us-ascii?Q?Ge0EEYs/F2OCB0M8jY/fMU+nqrF+De06WMgcvgWyoRY90dUot/fhc1a/LtP+?=
 =?us-ascii?Q?xOXi1sG0UeubZ+uJRs+Nld1tazbCy+qJu3yhNGWUaRLY91U+aasVKB3dtf+Z?=
 =?us-ascii?Q?2l9tXIIwfDpomJ2oUjyTQnmlSD2EjeeXujtJLhGkXavHFqB1af2RCy4x0h3u?=
 =?us-ascii?Q?Btm9o8/8eGZuFxyskhVcLxlGB0IQnYpFrKKB4LYdR0yzcM3lC44B/vr6z4PD?=
 =?us-ascii?Q?08JxW0o+WTdif+yeyYY0acpLsC5x1gYijiPYHS0JwLGQV4spQNJ9cI++dsMd?=
 =?us-ascii?Q?/kRKJvbQ7pouu1UHSSqMobonUlmWnkbhmj7O53jtO11LYVVXb6w27LAkgYJ/?=
 =?us-ascii?Q?cOMWNHOerpoFlEp2WYrOB1azbsTVPRmyIF4Dyam7FXK77/D5t3xNBY5jyP3/?=
 =?us-ascii?Q?OvjUJdSL3dknWGk82EwLHJHhH1ATyluEO10nFwKajxdY22ZkyKp2gOik0j6W?=
 =?us-ascii?Q?0aobmqk54w0zFVw77mRpCiFm6GJPH72dOoequUtyI5dklSj3C88Di3C5RhQL?=
 =?us-ascii?Q?hQAmkmOsk6e3ozSJ+fyqiYwjUUhpqKf/iWdxbNjuferpstV6vkTwN+IChLlt?=
 =?us-ascii?Q?4WAkRkTCM3Z1X6xgeQiZjMBNZHcA8oHBAansLU8iNMzvHb+iidkhKorBkaMR?=
 =?us-ascii?Q?T4t9DaX/9riTu38Ss4lkD1nlpaJAMLNsCuvnpJ/KcVT5u5xmrlYSPKGcCOz5?=
 =?us-ascii?Q?FxF+oTOs/S9up4HC7CZGjopbiBoHAAvtm3/CcLY6ncz80d91NC9cod5aYsC/?=
 =?us-ascii?Q?dgTU+Vkj08jV0elhhg96N+DTBq5DN86bC+82Ox37gsny8Wt06KPl/YjE5DDA?=
 =?us-ascii?Q?fiPe1OiueZDM9PhAa8Zt4TKgXlUnO7qTdgFLy9GLyzcqwMDygjztco57FwIQ?=
 =?us-ascii?Q?4LeXHj4zAwkWWTVjkiTMP/pMiOIr8q/P+5jprkVpS/k8Pvvb1TzTUzUMvPL9?=
 =?us-ascii?Q?n6/SUlpPVWyJ3sSH0wsZcwjiLdpgtq63ti+F4c2DUHjVNMdIM7W4bZP0oSlB?=
 =?us-ascii?Q?eshBfvIyuQ/+IqNb9PsDbNDoiRPhtAPmOmf2L0CWv7GSklhloKbU5DCCyEc/?=
 =?us-ascii?Q?SkHLMI/XSwZiAKMFCCQgMBSxMYPBXSGDSF4b6UM/Fx4+DNF0IOibNPt361dm?=
 =?us-ascii?Q?qWvzle0nYOv4hnn8aHKUzzaCMtGcyWw3S5yINdGIVqqEIOmoHOCfg6/lBD30?=
 =?us-ascii?Q?mUtKa/yj0Zhy5CZvEVNLp7IKKMrYwS167ljyWvXymMy8/7ui9L3mfoBgqMDa?=
 =?us-ascii?Q?bM22vCg46+hOjJOZ7eEubemKFat5xizdRefDJR0XNDiSngHgdlmZ6bjdubhi?=
 =?us-ascii?Q?V/INLy5YRPMU9bxR3mCqbdTMTSijIkXNYQ+MYn41sDNY0WE3mHE/k0zuShyA?=
 =?us-ascii?Q?kg4IlwVSmyHKoHSDw5V3xJKBLCF726oTnrUKT103+x2afbpfZzfl22/DRkTA?=
 =?us-ascii?Q?6qM6v4ao23givcfcMEfR1KVYFuCCVlfq433vAtFSrdx1eXHPQksbhVvhSrPG?=
 =?us-ascii?Q?KWsj6GFpkF71eO9y8YY/oiVHn2fAvVpu58YYKd6G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9449404-5998-4bf7-901c-08db5bf8e252
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 01:47:51.1495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1nhejWHcB6xGC5KlNF5h12IBbyY85kk33gGUsam5jrG52WqEVJMbCyZqsqVy6E0qQe2Coqd7g6arsjomMDOamA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492
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

ARM64 requires TLB invalidates when upgrading pte permission from
read-only to read-write. However mmu_notifiers assume upgrades do not
need notifications and none are sent. This causes problems when a
secondary TLB such as implemented by an ARM SMMU doesn't support
broadcast TLB maintenance (BTM) and caches a read-only PTE.

As no notification is sent and the SMMU does not snoop TLB invalidates
it will continue to return read-only entries to a device even though
the CPU page table contains a writable entry. This leads to a
continually faulting device and no way of handling the fault.

The ARM SMMU driver already registers for mmu notifier events to keep
any secondary TLB synchronised. Therefore sending a notifier on
permission upgrade fixes the problem.

Rather than adding notifier calls to generic architecture independent
code where it may cause performance regressions on architectures that
don't require it add it to the architecture specific
ptep_set_access_flags() where the CPU TLB is invalidated.

Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

A version of this fix was previously posted here:

https://lore.kernel.org/linux-mm/ZGxg+I8FWz3YqBMk@infradead.org/T/

That fix updated generic architecture independent code by adding a new
mmu notifier range event that would allow filtering by
architectures/drivers that didn't require flushing for upgrades.

This was done because calling notifiers from architecture specific
code requires calling the notifier while holding the ptl. It wasn't
immediately obvious that that was safe, but review comments and git
history suggests it must be hence the updated approach here.
---
 arch/arm64/mm/fault.c       |  6 +++++-
 arch/arm64/mm/hugetlbpage.c |  9 +++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index cb21ccd..1ee45a8 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/perf_event.h>
 #include <linux/preempt.h>
 #include <linux/hugetlb.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/acpi.h>
 #include <asm/bug.h>
@@ -225,8 +226,11 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	} while (pteval != old_pteval);
 
 	/* Invalidate a stale read-only entry */
-	if (dirty)
+	if (dirty) {
 		flush_tlb_page(vma, address);
+		mmu_notifier_invalidate_range(vma->vm_mm, address & PAGE_MASK,
+					(address & PAGE_MASK) + PAGE_SIZE);
+	}
 	return 1;
 }
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 95364e8..677f0d1 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/err.h>
 #include <linux/sysctl.h>
+#include <linux/mmu_notifier.h>
 #include <asm/mman.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
@@ -487,6 +488,14 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 
 	orig_pte = get_clear_contig_flush(mm, addr, ptep, pgsize, ncontig);
 
+	/*
+	 * Make sure any cached read-only entries are removed from
+	 * secondary TLBs.
+	 */
+	if (dirty)
+		mmu_notifier_invalidate_range(mm, addr,
+					addr + (pgsize + ncontig));
+
 	/* Make sure we don't lose the dirty or young state */
 	if (pte_dirty(orig_pte))
 		pte = pte_mkdirty(pte);
-- 
git-series 0.9.1
