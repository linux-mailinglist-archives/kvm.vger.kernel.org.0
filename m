Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBE222D27E
	for <lists+kvm@lfdr.de>; Sat, 25 Jul 2020 01:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGXXzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 19:55:17 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:27873
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726573AbgGXXzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 19:55:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7YmVonCXHIDQIDgyz6fvSYB+G9xW2UL0tgcBGxJJ9DZmxBJ9QtHeMAx8vnKR7hAPKAS/2QM2Bp/YWgMZbg8IxuVeDgMCEQckP0HrSISfmJ9I7tNufvrkbD4RvWc6ptw1g++2V0I8BH2WCWa6Ju3HrdqxsT4m4oVaNMYKcE6kDX8qc8pUuP6U52N80MFAKtnIe7THScVwrnMdp0JDEVAG8CVPddCuCWedFzDksHLxswMFjDwg8sekJgoDrBM6yeMAkRYEXRlAfe3pxtsmH5anNNSzT1htl+P+zUKZ/7K0m/QGrGAPmPASJnC3PBBUkIQpvFq940A9l1LFwo0AXUhpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrggf88VAfYFkWBUkKD2a52QH32f/DGvAlmif/AR/GU=;
 b=egMn1WRJJrjYk2kfMOpnhbBitazsTw5l+zQaNFlbr5wF/HHcYYS2BY/hHQfaPukSQAqnPp9IWfQMLHhB9aFkO9q86am2mr+AnvS5PVM2uj0INi11hyH31gIk7jRYwwu3JPJyrFd8/Ox3na9jyWUCeCTR735o2KHFK4mLtpMffbYg95pLBAzAqvD+RG2VoaR5SRlnunJ+OKlug2RJReJPbxmMJo+nrD0W8CLcM8vXZY22gLyZphRAwimaXufYkpiRwu87FBIQgkMQ9HG6Ctf66+LLKobyBsFZ9uwjbfusBuGsNz6Y8eLOfkvzGcQwTUBdyTQpJ+XL3NQNOULyvUzUbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrggf88VAfYFkWBUkKD2a52QH32f/DGvAlmif/AR/GU=;
 b=dH+jcamp3gAWUH3Q1reXkHLx/EuJshMgi3YK9PDxj0xeA0rFX11bclx/AHlesad74Hvb3tGc/cGRaUogTnTjl5t9hljxxr6A9v5BYXOvpaXxBXn/XlDynUkaFUDNMinw+6eWZxKIeiYXmey08srnVL3SBIHUyyYUlbAhB1hMUF4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB2652.namprd12.prod.outlook.com (2603:10b6:5:41::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Fri, 24 Jul 2020 23:55:08 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48%8]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 23:55:08 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     bp@alien8.de, hpa@zytor.com, mingo@redhat.com, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        evantass@amd.com
Subject: [Patch 1/4] KVM:MMU: Introduce the set_spte_notify() callback
Date:   Fri, 24 Jul 2020 18:54:45 -0500
Message-Id: <20200724235448.106142-2-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724235448.106142-1-Eric.VanTassell@amd.com>
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0033.namprd19.prod.outlook.com
 (2603:10b6:3:9a::19) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0033.namprd19.prod.outlook.com (2603:10b6:3:9a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Fri, 24 Jul 2020 23:55:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80a4d347-c8b8-48c7-d7c3-08d8302cfe83
X-MS-TrafficTypeDiagnostic: DM6PR12MB2652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2652E61F190FA6E6A76532DEE7770@DM6PR12MB2652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YVt1SsbSte4XQaRY4xKS+gwbKA0McnFLyYBYveM/t5VyJUJqyqyWegqsQ63GNRknMOG0Pfi3TQ7CY+/ns3PsgzhMTtBpgpnYzYVdk4kegE/rep+xIDfVBAXu9CU8yYpmk7DMJvxhahvgaYH8T1VEY6QzZYkngrTjrjJWcyYdAQLayZxoKrKkmVcevTLm+Ya7GbRKXS0buLQULfTPsltMkTvqMZFwN+OixfS0tv9uThcgboQUfEldAoZ7AsHVv+hlLCoOMC+jqbJkL6qJB5BzDVhedBiMbEOg3ZLOAaCUA2odQFT/c7DhrEP5NC8W+vZn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(6486002)(6916009)(36756003)(8936002)(8676002)(26005)(86362001)(7416002)(7696005)(16526019)(2906002)(316002)(186003)(478600001)(52116002)(83380400001)(66476007)(66556008)(66946007)(6666004)(2616005)(956004)(1076003)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uPy4v+yM4i4OKcKq214m1G9RlTLs1/qYPrToHD2MnhLJKS/Zks8GoAE3mE5v9tidL+WWajv+ZRYHmjO8SkXlH+RZS+TiAo+fPStRnf6vFwzaAqa+6oh+GeLBAEiPFRTMqPXEl7/vp4OUvoBS2tACb03PsoUMtOqFPBE6Wtt0sZe59elUzD59KnEpsTjLDr/2YMJTpbMXHLMUdFqqWkiegbUV1sZwQrVhOwUalVBOIsxAvt6dU2fGpKntE5TQ+pZ2LQc+Eotiil09oBb9515ltKmAmiat4pXFXruycw49w5hzwzpybPU+cC5KacSS8ZDqO+BWwgzC3CJFAOKa5bKcoiPwtlPOEuyjU5XmfEHKLyJLoo2gfG6WYP+f63x52u+jCDuwvPty6dxQibfZX/yeyDRXavbZVK8dQildepJWu0VpzHVL8QnycJ8f/Vh/I4mMhnMn8PiGlFSKXsbSSB5UvHcBYiXtcQOsJWnZChYuVD4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a4d347-c8b8-48c7-d7c3-08d8302cfe83
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 23:55:08.2681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9/woNeoYnNbEhV5RkMfRN8rh2kD8TZ1tYUl2sIdeT8zZYlU5Zf5FMsRNC+KL32s8qCT6JRDBARrFLoMjQXJRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2652
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This generic callback will be called just before setting the spte.

Check the return code where not previously checked since this operation can
return an error.

This will be used by SVM to defer pinning of SEV guest pages until they're
used in order to reduce SEV guest startup time by eliminating the compute
cycles required to pin all the pages up front. Additionally, we want to
reduce memory pressure due to guests that reserve but only sparsely access
a large amount of memory.

Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          | 31 +++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  | 27 ++++++++++++++++-----------
 3 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5aaef036627f..e8c37e28a8ae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1227,6 +1227,9 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+
+	int (*set_spte_notify)(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
+			       int level, bool mmio, u64 *spte);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fa506aaaf019..0a6a3df8c8c8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3004,6 +3004,23 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
+	if (kvm_x86_ops.set_spte_notify) {
+		ret = kvm_x86_ops.set_spte_notify(vcpu, gfn, pfn, level,
+						  kvm_is_mmio_pfn(pfn), &spte);
+		if (ret) {
+			if (WARN_ON_ONCE(ret > 0))
+				/*
+				 * set_spte_notify() should return 0 on success
+				 * and non-zero preferably less than zero,
+				 * for failure.  We check for any unanticipated
+				 * positive return values here.
+				 */
+				ret = -EINVAL;
+
+			return ret;
+		}
+	}
+
 	if (host_writable)
 		spte |= SPTE_HOST_WRITEABLE;
 	else
@@ -3086,6 +3103,9 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	set_spte_ret = set_spte(vcpu, sptep, pte_access, level, gfn, pfn,
 				speculative, true, host_writable);
+	if (set_spte_ret < 0)
+		return set_spte_ret;
+
 	if (set_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
 		if (write_fault)
 			ret = RET_PF_EMULATE;
@@ -3134,7 +3154,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	struct page *pages[PTE_PREFETCH_NUM];
 	struct kvm_memory_slot *slot;
 	unsigned int access = sp->role.access;
-	int i, ret;
+	int i, ret, error_ret = 0;
 	gfn_t gfn;
 
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
@@ -3147,12 +3167,15 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		return -1;
 
 	for (i = 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, start, access, 0, sp->role.level, gfn,
-			     page_to_pfn(pages[i]), true, true);
+		ret = mmu_set_spte(vcpu, start, access, 0, sp->role.level, gfn,
+				   page_to_pfn(pages[i]), true, true);
+		if (ret < 0 && error_ret == 0) /* only track 1st fail */
+			error_ret = ret;
 		put_page(pages[i]);
 	}
 
-	return 0;
+	/* If there was an error for any gfn, return non-0. */
+	return error_ret;
 }
 
 static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0172a949f6a7..a777bb43dfa0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -532,6 +532,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	unsigned pte_access;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
+	int set_spte_ret;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -550,11 +551,12 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * we call mmu_set_spte() with host_writable = true because
 	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
-	mmu_set_spte(vcpu, spte, pte_access, 0, PG_LEVEL_4K, gfn, pfn,
-		     true, true);
+	set_spte_ret = mmu_set_spte(vcpu, spte, pte_access, 0,
+				    PG_LEVEL_4K, gfn, pfn, true, true);
 
 	kvm_release_pfn_clean(pfn);
-	return true;
+
+	return set_spte_ret >= 0;
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
@@ -1011,7 +1013,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	int i, nr_present = 0;
 	bool host_writable;
 	gpa_t first_pte_gpa;
-	int set_spte_ret = 0;
+	int ret;
+	int accum_set_spte_flags = 0;
 
 	/* direct kvm_mmu_page can not be unsync. */
 	BUG_ON(sp->role.direct);
@@ -1064,17 +1067,19 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			continue;
 		}
 
-		nr_present++;
-
 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
 
-		set_spte_ret |= set_spte(vcpu, &sp->spt[i],
-					 pte_access, PG_LEVEL_4K,
-					 gfn, spte_to_pfn(sp->spt[i]),
-					 true, false, host_writable);
+		ret = set_spte(vcpu, &sp->spt[i], pte_access,
+			       PG_LEVEL_4K, gfn,
+			       spte_to_pfn(sp->spt[i]), true, false,
+			       host_writable);
+		if (ret >= 0) {
+			nr_present++;
+			accum_set_spte_flags |= ret;
+		}
 	}
 
-	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)
+	if (accum_set_spte_flags & SET_SPTE_NEED_REMOTE_TLB_FLUSH)
 		kvm_flush_remote_tlbs(vcpu->kvm);
 
 	return nr_present;
-- 
2.17.1

