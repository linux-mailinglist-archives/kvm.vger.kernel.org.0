Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9C53F09AB
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhHRQ45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 12:56:57 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:33793
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230342AbhHRQ44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 12:56:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPge4shWUqAiZTSc8+h1UIkXZ2sgr4GkwyQk5Ex6GQBoe9ih8DgRXQVlePcUNEGKnho5FTh3h6mPXfGQ55+rC1w3jIIdQhwXqNC5cYqfWtenqxgmdccw0RUNXUk0I+bdmTIoLQYfl9zlMx6OgpATzWxVwp6LJniauIguuPqApo45es1HAJ2ToFRJyWkIWELxTnbuWXVJI8cd6OSHbM8H9uc7OMeGVXCqdPx1UxRWi89f9oMjDcvWpteyG5DyWaB4bihFT/9d8qcFMyXfnYrgiZeEDF9/Zef/ZOc+Xie3V1NNm545vV1UNBPtAVS2inyWhvigbdvYtefkTKIgFeYJdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqm+XUi4p4BSrRV6tfuo1QiLju4eKL13fEIEG8zJrNA=;
 b=Q11GK6udB2e0tC9ItTtaPzld8IuXVuW98SlNXyo8owjKT3WFMpnCVs6rWOOsgsZcf/MNNsTHyLFOVkPAeqac9r2AEekTR0g3IZvFj4riw7K5tRZRdXPqECVMusHxOdjeC0b7raO5L4VrlZctvRmmhOWVSlgEhDqAmpGi+bmM0eQQMFWS5sZrbnUvf50lpFNJzv1+IWNBfOvp/QQbFrmOn0tjQRxKbN3g1RINjYAvO1/Q2qRSrIlXpf0pUo54xN7Lq7BP/Mv3A48cCqBvxZfzGY4TTT2x9e9leqd+g77PIKMLriiecT3O/LUR3ZWyWGGpdjQJeej/72q5h3shm9knAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqm+XUi4p4BSrRV6tfuo1QiLju4eKL13fEIEG8zJrNA=;
 b=474hlYBVKT+jbdeCeob/N24fXruXA/Lw1Z79WLwIzGJcmtoUBEcgKOYR2dcwOKbV3iuqo7pfVY4+TvQGhq7bDeqNf7TZKxMbAj5uSZtC4puT5DWrei998QfqJCLGZISxQlfqABz6bbDSM/qBz4lB0TOetbBY2Zc8aYlWJipLbDs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Wed, 18 Aug
 2021 16:56:20 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 16:56:20 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        wei.huang2@amd.com
Subject: [PATCH v3 2/3] KVM: x86: Handle the case of 5-level shadow page table
Date:   Wed, 18 Aug 2021 11:55:48 -0500
Message-Id: <20210818165549.3771014-3-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818165549.3771014-1-wei.huang2@amd.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0172.namprd13.prod.outlook.com
 (2603:10b6:806:28::27) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SA9PR13CA0172.namprd13.prod.outlook.com (2603:10b6:806:28::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Wed, 18 Aug 2021 16:56:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b65ea8c-ebef-4fe1-9d29-08d962691a47
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2487DA7D37920EC13F63CBD2CFFF9@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jqO5xlsL5OXoX9k9kHJmVkmhyIxFpyg+X4S9GcSc7QAuwyNqpo/xXtYXngfkpDCCCFDsdfcTbO9ULXSmiSgAkaAAtSXaKMeARDalPI1SFQFc5CVRHruxOuvAH955A6J/aPOTUw8R7+mHa3ZxBEFUY879docC5YrnilUORSsszXr6Z0dyGz1o0OiQxCYtsdhlUHqC5scIvV3oCKbWmWmf012GU7B9UWwUql4ybN5SLA7tuSJE39izD8+QquGzG+aHrTNAeGkMJXhSPiTcDuH66nADNUnH4oIcwh9MeT0sev1mpLt71MbtueRmFETMtn7BX9cWimhbu4pTESEwsDrxSQbXXAmgmX5UydmxJnTv33SVEx6sLmSAG4KVLjvoex3EXXV7ErB7Q7k0Ev9xmcuElDli7YLNO96yIVDObcBHqkNYi6YuvhRe/ICyaxMRPg+CJr7zd96oz/Z5DUpmcAvcoiFlqyn/B/+zCzJiY0w8R5irfcIsA6ln6/qItUvWNVc8Zdz4nCtT+EwRCUDYFuGI2jUZxGH6lrlJbCv8wNS+REeK2NuuldjkryPph48Pb9WDoNhO3fAegwqmIliuuc/WlrgHgrTZ82Bm9Z8hT/9eKlI/qQtWUDD+hrhRRSKyJ3AoOlGSMLSPeWlbBfXpguiVKurQV0Dkma5xmsT9UkIYcI2X9UrQQ+2Dca66LJiBETP9DHzOwQlgQRgSpNwzo5WMJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(478600001)(26005)(38350700002)(52116002)(66946007)(66556008)(66476007)(7696005)(4326008)(6486002)(38100700002)(2906002)(6916009)(6666004)(36756003)(83380400001)(2616005)(1076003)(956004)(8676002)(8936002)(7416002)(86362001)(316002)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1a8qqVFKOBKg7qlLfcRdTgGoGPRWAF/syAVdlJEZK9oelexfZy7saThQZR35?=
 =?us-ascii?Q?lTQfAqyGxbuCzSR4jOS1zjhrJfekp/qkvuXFC6/XYQ9PZggdLZKm64ATyQah?=
 =?us-ascii?Q?xX5FLRB80jipLGMUxK5crzYfps1DCpPHLBn5J5wSutZ14j1NxBWqV3U+s236?=
 =?us-ascii?Q?eyEH8/ePw5cOTcoaWaPvfAuf+4oDGt3+RDMMLmoZ9VTKRCm8m0nd7gHF9Njw?=
 =?us-ascii?Q?x3kwpGjbE3d/fOa+xqi/v6dP01WR2N3O4a6f9F+XtBkP+r6T7qVUxyc/YsPQ?=
 =?us-ascii?Q?hqAWLwIA96Ri5+JHu8FNzofxhx0KTqN1QnY5Ip2WrAfOqCbqXP18oOlNfJt9?=
 =?us-ascii?Q?wrCaToOX4vxynAtRw5bHpYuYSLZO/s6uyBN0eNDJ4dknuJOQ/nKR3AZX/1Gz?=
 =?us-ascii?Q?OvuNMIR47CR1925vd70U5uEnGA27nK3ouJF6IZXJUV6c3u6AB4npUFxJpgLy?=
 =?us-ascii?Q?JyDFsFmCHcAoLIYvlD9ALmiuZmV4YQ00L9blqVtIYBIxOmG9g2YM0fbspTxV?=
 =?us-ascii?Q?iujPslDqhtrA02/tazM+E8le0nwbYkWPAeSYHXxUb00X+peJf0e0PFRZCmLL?=
 =?us-ascii?Q?EKRNLccvJ+/W4qRAdTDcOIrlo4U0CHnZ4CHViO+RuH/svmQ88FJfi0fDSNR4?=
 =?us-ascii?Q?Qnkss1CgrOQBTCySeAQxGGWiEPX3Y6cA2z4Ng9fYMDFodDi1QhX6u7SENuSk?=
 =?us-ascii?Q?foCupEJjAxDajAvaSE6fGxi8Lm7eP+9S0q4b+UJ5C5NuMiwH4k/C6gx8CrJS?=
 =?us-ascii?Q?23jjFtbhtixcGPxtZyexFXxPTzeOsjOHDqpz7rJIeYHHyvvrH9svch3mjAEA?=
 =?us-ascii?Q?vzOss780pCo5ncdL1ARNuArFVu9+fn+M/6aj9PwIMCrobHHoFwavJL5TY0sw?=
 =?us-ascii?Q?k2Y9Ylw6Ytvcby15qgaQK4NdNVpFGn1Q82yXEmFeA6YEjpDiup/tQdCKDkHY?=
 =?us-ascii?Q?qTjVxhbCIVG5XsWS3rW4na6eUrSicc5QslCABgtaIZ7fmNImvuUUDTkb7KqI?=
 =?us-ascii?Q?DfUEY+22dF+R7OW3Fyq2KtrhNr+WZ9YUyXZdIIZKE7pKfRWBwww1OvLvaXOa?=
 =?us-ascii?Q?E+wBIEroBg/7dcdztwq7Xr2/9ss8VRc8xh+Of0X6DeCx3H4qUP4bbiMgajl1?=
 =?us-ascii?Q?Z0eg5sk6Gk0y/7yb0GCYlmq1lK61uoEX1H9e4bcKlM40Zvwm3IxGM/+Hmozn?=
 =?us-ascii?Q?Rhk/9wFkYeun+I/LmsUJvU/Hz2cRns2Q47bhVA07GXMtX7Ej8tiL30yuC3Nk?=
 =?us-ascii?Q?yIfvTj0T/shzVXgPrm+8wjLe2pIn4ve62v3pkQ0oeCMYyyy1zrxxtNXMKPDb?=
 =?us-ascii?Q?PFUOU2UqyUvZk5Hqxuy+3W7k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b65ea8c-ebef-4fe1-9d29-08d962691a47
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 16:56:20.2484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFNpAFRM5DyMK/C9r6CCmeTJiSYsjqKqLWYCkZBE/xZAd6jl6+vjt3wnw7cZVXuD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the 5-level page table CPU flag is exposed, KVM code needs to handle
this case by pointing mmu->root_hpa to a properly-constructed 5-level page
table.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 46 +++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9daa86aa5649..0024b72a2b32 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -447,6 +447,7 @@ struct kvm_mmu {
 
 	u64 *pae_root;
 	u64 *pml4_root;
+	u64 *pml5_root;
 
 	/*
 	 * check zero bits on shadow page table entries, these
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 14eac57bdaaa..0fb0937c1ea7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3456,15 +3456,22 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
-	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
+	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
 		if (WARN_ON_ONCE(!mmu->pml4_root)) {
 			r = -EIO;
 			goto out_unlock;
 		}
-
 		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
+
+		if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
+			if (WARN_ON_ONCE(!mmu->pml5_root)) {
+				r = -EIO;
+				goto out_unlock;
+			}
+			mmu->pml5_root[0] = __pa(mmu->pml4_root) | pm_mask;
+		}
 	}
 
 	for (i = 0; i < 4; ++i) {
@@ -3483,7 +3490,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
+	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL)
+		mmu->root_hpa = __pa(mmu->pml5_root);
+	else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
 		mmu->root_hpa = __pa(mmu->pml4_root);
 	else
 		mmu->root_hpa = __pa(mmu->pae_root);
@@ -3499,7 +3508,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 *pml4_root, *pae_root;
+	u64 *pml5_root, *pml4_root, *pae_root;
 
 	/*
 	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
@@ -3511,21 +3520,15 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
 		return 0;
 
-	/*
-	 * This mess only works with 4-level paging and needs to be updated to
-	 * work with 5-level paging.
-	 */
-	if (WARN_ON_ONCE(mmu->shadow_root_level != PT64_ROOT_4LEVEL))
-		return -EIO;
-
-	if (mmu->pae_root && mmu->pml4_root)
+	if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
 		return 0;
 
 	/*
 	 * The special roots should always be allocated in concert.  Yell and
 	 * bail if KVM ends up in a state where only one of the roots is valid.
 	 */
-	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root))
+	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root ||
+			 mmu->pml5_root))
 		return -EIO;
 
 	/*
@@ -3537,15 +3540,25 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!pml4_root) {
-		free_page((unsigned long)pae_root);
-		return -ENOMEM;
+	if (!pml4_root)
+		goto err_pml4;
+
+	if (mmu->shadow_root_level > PT64_ROOT_4LEVEL) {
+		pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		if (!pml5_root)
+			goto err_pml5;
 	}
 
 	mmu->pae_root = pae_root;
 	mmu->pml4_root = pml4_root;
+	mmu->pml5_root = pml5_root;
 
 	return 0;
+err_pml5:
+	free_page((unsigned long)pml4_root);
+err_pml4:
+	free_page((unsigned long)pae_root);
+	return -ENOMEM;
 }
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
@@ -5364,6 +5377,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
 	free_page((unsigned long)mmu->pml4_root);
+	free_page((unsigned long)mmu->pml5_root);
 }
 
 static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
-- 
2.31.1

