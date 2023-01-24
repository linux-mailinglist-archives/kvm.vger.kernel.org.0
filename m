Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B46679032
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 06:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjAXFpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 00:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjAXFpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 00:45:47 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0833BDB2;
        Mon, 23 Jan 2023 21:45:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iiZ8g149rNqbvxPAbRYCg/mAZswHfCczb7F4VxWx3QN916h8yo1OyIFNubcFuiebxxlPZM3jZdFme5Hptvzbdum2IISpG2UQNxS5JXUEJ8IiF/da5b/6A5lQiAsHeSCbC3imB83IiYj1Sy++q9LMO4Xv99OeARZ185NDxskkAbL7V6I6c1JSMR2K/ZUHAZOfxAR+B9hjUzCKa//PCLTWJj5nCheJ7tsdCkfmG5v4FPMYpowbOBSySEnGCSb+U3cX8zDLq8lCPVUB+2gd88tx6dV01kVqcq3KqrCw0/b0CkrJYIAY92GINbSpeaGxu53PEux8riem99M9BiTolPxZjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nD8gOnzuByFYMkvEBPVA+p64gDK/jl6+XilYj2DMivY=;
 b=h9dsXDx1S2Oy6zSV62LGK/Qtx47oyMZdsj2FlHt3FY8A/sMeGOR6sNa4QKnxQLWC98jCN79lwhNIiutGWugjGqwaBBfJy0xGL9dY2Ar4p3p5wShVs7fuIwkSmHlu0mp0a74mfNG40tia1PPhOAWLPrlIUYvgATsLD/eLLVw7z6AKdzPXPdiasSeX4jwINek5r+oRSdaa/CoLc1tIoNSC1T5fpz9l2tYWvDJVelOC7qEHGstk6wBQArJIw2VtdsNVTVbkn0tMW8ullZz3BrAB2x1N8rx0GrFlX1ibwnB7OXAusWvBmARmkLa2XTJYPjEDE5qBFsmAteJhzEZUAUkfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nD8gOnzuByFYMkvEBPVA+p64gDK/jl6+XilYj2DMivY=;
 b=b5fIBhQy0+x/JFIklkT8yrZxAs2+ODukZzTkXjwMv3lnDsdva7NAqyd3UDoYKDDFjB1Oy1rCR5z/p1MecTvpKZHBmj84dzAr6UkDsWyK5zlt6VFwOLV7Zrk5uHGXcHbGthtN7rRTJ0o/TZU+Z7ngVz88MvdaObLV2gmGOvF8b7KH7lGo2VxZKRyiOqvQXBPHbKM2EcM3YuDgRkYsHntO2kGV59iXlhQJfGpBc/hhgUIimp/7aLKa9oT17yvo0kq1oFB194ukRPNs7loQ8BeWd+MBkEkfEQ1hM9b0zH1LEya/jmmhC4emMA6gIAJyfm6tM1pCtz7Sa/hXJwdkq1mqCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH7PR12MB7793.namprd12.prod.outlook.com (2603:10b6:510:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 05:44:49 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 05:44:49 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        Alistair Popple <apopple@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [RFC PATCH 07/19] vfio/type1: Charge pinned pages to pinned_vm instead of locked_vm
Date:   Tue, 24 Jan 2023 16:42:36 +1100
Message-Id: <1235619c5394aa67fe116f89f22fafa370707c90.1674538665.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY3PR01CA0108.ausprd01.prod.outlook.com
 (2603:10c6:0:1a::17) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|PH7PR12MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: 08ec6db1-7c20-4aa1-a716-08dafdce1b47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ckyxsZV3cU8Gxbct3IlUkPyRUJ0jpyA+Tuu+X+Y9XTseJaO60NqaAbQ8kJn4gtsrv8ilwjmeM+26B/9+oL1JUZuJpF4B2o4iD0X8n2dFRokl1NehOU4RAXKuPP3Dqnz9jCdFKst/SpdMXRVBcM8SIr2jbG1qT0ZNUiSf0x7IkEDDyADI/KRBI9oUPKXNRbtsk6atdS+wqAxyKTC+Cl6wRMET9wIhApoHgK0U7KkgpUg+xlqfjMvymg73xkeW6U1qp1t18VJqkLQZE+hS739FlNmxz7s7E2QIu5Az7Ary92eWD9EWhhagNc39No9six39gDZJgGWYbJ9MiTdg0SGf0Ed10+4Wcs6OsHLY0hJsiCvBttxBjRqwZFam1Ol3prLtsl7pwmXhYkKKIfn7eFwWQ3W0OBBUINIbs4J9N0BpN6oycZuHqVFGvQCD4FG4cQJJh6mVjj5xUW2UIHU0mcRU+AALCCyfuMzRgRdzOi3HVd30FABTBAyDcs/qN2MATULMbppVTA+z240Vdd8WlgJwlnmkRZTDzeSlRJDZfev21+OJrR8ARONHomFknXW/9EBLkv2NKnG69yaJRMhK+PHPp/VwykBZDFKFqs4FLY10vUGDPovHsYTfzVg0vEPtDf3acqwpnxgpWiz4QnyDNFKn1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199015)(36756003)(316002)(4326008)(66556008)(66476007)(8676002)(86362001)(66946007)(186003)(54906003)(26005)(6512007)(6506007)(6666004)(83380400001)(6486002)(478600001)(2616005)(7416002)(5660300002)(8936002)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ugmqBoExZdq773BJjVgPk9diRP2k5+6T+mpslsgdDMF8ZmdjXP64Ou3bZpCF?=
 =?us-ascii?Q?BmbJs/bT0amvZ4vUYu81cnq3wVM3i3Ay3s9rS8VamOUlMHBk6rHdRtY8OHfT?=
 =?us-ascii?Q?cYwtEkZOelPKfbSlTT0tZbSgUzp6bOutrGnZG5HzaxMySBW5F4x84fdBdpXv?=
 =?us-ascii?Q?qq+fudIZY5/H2rzQaRnouk8p2cJ0xmka+XNdzhbtIUfyxD3a+nqReGFDkqyG?=
 =?us-ascii?Q?U6GXETHQaYLmFIyzyfT0QJgofzXG73tAzJTNivS0pGmF4gHXlbFQdJRqqorz?=
 =?us-ascii?Q?utKCmi1P7PPQvAV7R6u/gCqE6dFD4bKGdM/SNudsfn1dPIoGCE63SB9DxzDo?=
 =?us-ascii?Q?mntWF9dkaS3L72ydZRwZmQowzheXPY1Uzjv0FAo2Z4lFqNGV3PWqNSj3L4RK?=
 =?us-ascii?Q?3ob6tlTdeliJmPdj/9txaZ0bOW2ZTFehuZee1BEefWRaDiPRJZ2u556Bj4/y?=
 =?us-ascii?Q?JDiUhU/zcYk1MjUDnpJxCe+rLfXRFpmgH275qTIupZZ4BD4vEt7sP7sByxsB?=
 =?us-ascii?Q?7GdCZfIauxeMy3lhKShImiz1Rpcn3wqeFCuLlcRzOwrWEq6u1xS0B+IDiFDE?=
 =?us-ascii?Q?JdqfzBbwODLtiYaPI6XnFb7oWR6kZoqBIr0O67Oqnc7PYh9lT4UiRbnrf4Iz?=
 =?us-ascii?Q?mY819OS7I6FAE5g0DLupRyQ5vpU9vWZKsqX9uA/ILap4VnlwnjD8B0zfK3yG?=
 =?us-ascii?Q?OclMzXL2GdLtC57jxH9Rw6FWbbpa6sy1XT0Ccdmy8IQa4KZITDOJjSDSm4a9?=
 =?us-ascii?Q?ShsgibwR3TKWlgHh6p11izQwqj5kiqg0F4dR4OiUec0wtcanRmgBWhoym8Hi?=
 =?us-ascii?Q?6zxkrL4d+B9MNQ0Eg+z9ShcJSLUOUsppFotUcy5F6lVbGIuejIzyjYwEDlGZ?=
 =?us-ascii?Q?i8dUam68U/0GMxvSnclj8aWnJPWjNBr2xuxwqksGJN1q38tZar4cufZW2KzQ?=
 =?us-ascii?Q?CMcKzuLPKeFOo+DCteyauhluVIfzBMNYeAKAWj2GHedevq6rPen7Gj3OqF8V?=
 =?us-ascii?Q?omzxfh0qvTaq0bsEZCxtaE+q5UeXNNcXeptWHT2w4kG2ipd2jjbaWISYsDfq?=
 =?us-ascii?Q?XL7+d+CWXMTItyLTFtM63eUOO/kAqcSXmksDtnQLWRwzWqvMYhck/K/57GIW?=
 =?us-ascii?Q?W7g7ixuIY1rMNMRKBdM9S23jmRMHY/Y2cSYu+YDlysV6ilOAzWfei33meOrh?=
 =?us-ascii?Q?IyTS12Uy3Ta62upz1Co+lRB3+pNLiyXsRTtx7Yga19eWy5HkccduTz9Bz6M/?=
 =?us-ascii?Q?Mv6/Tr5UlQbdvps2gQZDl61TV/r/ToHw5oMHO894yo8v71ZUciHM70/qSVuz?=
 =?us-ascii?Q?McgGnyLfznZVbC/Psx+eB+INSHtNp4viWE6jLJtP60KUYRewW2psg6TzuEWQ?=
 =?us-ascii?Q?LtR67y9lqKzLQxcUC9DSXRsY8iRWWHxmjS5FfwBYcYk4/PRbne315BzA1GB8?=
 =?us-ascii?Q?0yFOHsgoRLOkHPpbdd6SpCw3m7Yn7dG2rHvEusByBR9ZiCcDLyyAq9hC4trx?=
 =?us-ascii?Q?q3UDyiBaa9flzC57K7YKge5qI/L10TDeKXc6HV/Wjqpc2qHY/UPE74CWLqkx?=
 =?us-ascii?Q?ydbn3sb+zHjn7HN4i9j9tCmOHI/RQkraSZ+cEl4l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ec6db1-7c20-4aa1-a716-08dafdce1b47
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:44:49.0992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lz20/FDFqpX0w2MfN311iAM1LhjjmmW3WW40dGhXvzR1ci4VG2mk5UGRp8KCYxqn3EbdKQNpSkpivfiMbw0jJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7793
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This switches the charge to pinned_vm to be consistent with other
drivers that pin pages with FOLL_LONGTERM. It also allows the use of
the vm_account helper struct which makes a future change to implement
cgroup accounting of pinned pages easier to implement as that requires
a reference to the cgroup to be maintained.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/vfio/vfio_iommu_type1.c | 59 +++++++++-------------------------
 1 file changed, 16 insertions(+), 43 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe..828f6c7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -95,11 +95,11 @@ struct vfio_dma {
 	size_t			size;		/* Map size (bytes) */
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
-	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	bool			vaddr_invalid;
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct vm_account       vm_account;
 };
 
 struct vfio_batch {
@@ -412,31 +412,6 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 	return ret;
 }
 
-static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
-{
-	struct mm_struct *mm;
-	int ret;
-
-	if (!npage)
-		return 0;
-
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
-	if (!mm)
-		return -ESRCH; /* process exited */
-
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
-
-	if (async)
-		mmput(mm);
-
-	return ret;
-}
-
 /*
  * Some mappings aren't backed by a struct page, for example an mmap'd
  * MMIO range for our own or another device.  These use a different
@@ -715,16 +690,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
-				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
-					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
-						__func__, limit << PAGE_SHIFT);
-					ret = -ENOMEM;
-					goto unpin_out;
-				}
+			if (!rsvd && !vfio_find_vpfn(dma, iova))
 				lock_acct++;
-			}
 
 			pinned++;
 			npage--;
@@ -744,7 +711,11 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
-	ret = vfio_lock_acct(dma, lock_acct, false);
+	if (vm_account_pinned(&dma->vm_account, lock_acct)) {
+		ret = -ENOMEM;
+		lock_acct = 0;
+		pr_warn("%s: RLIMIT_MEMLOCK exceeded\n", __func__);
+	}
 
 unpin_out:
 	if (batch->size == 1 && !batch->offset) {
@@ -759,6 +730,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				put_pfn(pfn, dma->prot);
 		}
 		vfio_batch_unpin(batch, dma);
+		vm_unaccount_pinned(&dma->vm_account, lock_acct);
 
 		return ret;
 	}
@@ -782,7 +754,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 	}
 
 	if (do_accounting)
-		vfio_lock_acct(dma, locked - unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, locked - unlocked);
 
 	return unlocked;
 }
@@ -805,7 +777,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	ret = 0;
 
 	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
-		ret = vfio_lock_acct(dma, 1, true);
+		ret = vm_account_pinned(&dma->vm_account, 1);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
 			if (ret == -ENOMEM)
@@ -833,7 +805,7 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
 	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
 
 	if (do_accounting)
-		vfio_lock_acct(dma, -unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, unlocked);
 
 	return unlocked;
 }
@@ -921,7 +893,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn);
 		if (ret) {
 			if (put_pfn(phys_pfn, dma->prot) && do_accounting)
-				vfio_lock_acct(dma, -1, true);
+				vm_unaccount_pinned(&dma->vm_account, 1);
 			goto pin_unwind;
 		}
 
@@ -1162,7 +1134,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	}
 
 	if (do_accounting) {
-		vfio_lock_acct(dma, -unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, unlocked);
 		return 0;
 	}
 	return unlocked;
@@ -1674,7 +1646,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	 */
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
-	dma->lock_cap = capable(CAP_IPC_LOCK);
+	vm_account_init(&dma->vm_account, dma->task, NULL, VM_ACCOUNT_TASK |
+		(capable(CAP_IPC_LOCK) ? VM_ACCOUNT_BYPASS : 0));
 
 	dma->pfn_list = RB_ROOT;
 
@@ -2398,7 +2371,7 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 			if (!is_invalid_reserved_pfn(vpfn->pfn))
 				locked++;
 		}
-		vfio_lock_acct(dma, locked - unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, locked - unlocked);
 	}
 }
 
-- 
git-series 0.9.1
