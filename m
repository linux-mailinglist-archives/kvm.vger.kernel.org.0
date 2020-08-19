Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7145F24A2A1
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgHSPRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:17:19 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:48186
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726899AbgHSPRH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 11:17:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWWAcdH4KXUZKQzT6yc7tnQTHG2eps9E/YMxztDc0piKCbjAxxdDRsQc4JvPKHApCVQoOfDAHNALfrsGaZqmR7pQzyCC0W+InMJAXd5U/5R7CeGwUOrxJdBF01d4pgzFRDspLLL4+zmElpB8B5fDD/EzvOIjf334Pox3FBtL0ioAATch+fTU4tMp7u48WWBdb/y+TaGQrjIw045PkY9obALrGE06kpi38Y1y/NGk2OBUlLMaGWsCxegcO9S3Mp1+ly9rUK1DXFKG7yhncikf8to/SZvmaqHuJJCeOb50meETa8SsxxIZxiFa7UHancRxS9G6G0XR+BF+R0VzGLZUQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VaKGJyweKaytkfpqj2e0PU0xmX+dpQkYsSUqtutHKgM=;
 b=i4rUieP1mMQ1BptpDPHu9684l65XG1HPPfGjlqF6Q0YJenpHQYOxNoA2zgwd7GBV6XDXT73wtvE+J8LnpdYbAs8+wYD6+YbvEnO0j8QHSn5VSokaJDtamedTFtALZgXRU2F19J1Sj7y+QLtAB+lcptJ1hkViKXaR2jY1SLsXmnUxHgm++PPyHIFic2xkCYgPHGKa7EbN450XCRd3FKbfcAgljnkN7Qu+rQ+n09TqzH9JAgj8Lzahk549FweCJ7ODCKBnEYPLtotiKIKUTZV6/NZz973gv4KYso16wgn141IVPi6EWwf1dICXSKgzibsvtDcXgKpKd0Rh6gSE+4AoIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VaKGJyweKaytkfpqj2e0PU0xmX+dpQkYsSUqtutHKgM=;
 b=doyoLTjhf4f6bkTV8ZxaIIhLjkVF6GLQi32PlnckP/WsbfMo3jNB6rRDubk0zCJBQNq3RzyPz7PSmZ2RdhI+GEPshidxnpvSZHwSs/Gcj72yVyySzA7o5AqTjy00jlHwnoaNF0R/wginSCLmD8AZapudjCzAO8xobPgDKD+4bpM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB3227.namprd12.prod.outlook.com (2603:10b6:5:18d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24; Wed, 19 Aug 2020 15:16:57 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Wed, 19 Aug
 2020 15:16:57 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bp@alien8.de, hpa@zytor.com,
        mingo@redhat.com, jmattson@google.com, joro@8bytes.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, rientjes@google.com, junaids@google.com,
        evantass@amd.com
Subject: [Patch v2 1/4] KVM:MMU: Introduce the pin_page() callback
Date:   Wed, 19 Aug 2020 10:17:39 -0500
Message-Id: <20200819151742.7892-2-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819151742.7892-1-Eric.VanTassell@amd.com>
References: <20200819151742.7892-1-Eric.VanTassell@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0045.namprd19.prod.outlook.com
 (2603:10b6:3:9a::31) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0045.namprd19.prod.outlook.com (2603:10b6:3:9a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 15:16:56 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f639cf6-edbf-4ff1-2d0f-08d84452e9dc
X-MS-TrafficTypeDiagnostic: DM6PR12MB3227:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3227543FC5E01C5F0A77E098E75D0@DM6PR12MB3227.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaSvrHAMZGNVvPkRrTSrfj189Dc22maaJdbBVJslHIp61o4JKf+N69Zg5oMrW0q17fieSYNvu0m3SGzsL6hKEqtLFbaLwGWjhm9JaZ+NKYcaob+yI7vednSyj5XA7J4mpd42RKQdVVI/nTMpoT7ys5TD9clg0V5KkIuHYRwJdywtjybg5MaTt1zpyrzGvVHCJPSj5lpO4rdUX90Y16a/bDWzkTmm3UBDxGAn6Spo0197obO4635zdNuzBxZQnXrlOkk8jNJMF8SCElc24OZCMndBf59II8c06Z7W8eQpg3ieTiYQPDPEnX5thdqlEuWZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(66556008)(66476007)(8676002)(66946007)(26005)(86362001)(1076003)(5660300002)(478600001)(6486002)(36756003)(316002)(83380400001)(6666004)(7416002)(2906002)(8936002)(6916009)(4326008)(2616005)(7696005)(16526019)(52116002)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E357RBRZowO273PDBhEUmo+B2tNkvt26FTm0WMJwPZlPWlTE2Y9/4JZ4x+x1+ZEBkppQ2me1IPwBVSGsWeQaS3jcoGI/k/G/RgB/s/L70Vi02EbtCS6dwuoElSAlWywhgrlt8ab3q+0zN0pbUo5YSiDjrs/wGDqgJkzwoJ7czfoBJBT1f+eV3c1NpuxJpyxppJSJdFdkQ1H6E/0LWD0q1lBGJZg77O3mu4OVWU1ieW93tMUxsx76Ly17Av+K2LrM9nUTMFSNAElkJL7dLu0VocZXtAuXHxjf/QZsjainoyVyodOmV6hkaqPwWm7VIKhXlDOlz9i2Lcu09uD+OQ62TIuvFU+5LzI8jwtxKvYW69p6Oi1QKeMESSWsfAgph/ZdJD9sAS13lYSr1wI7mgogqT4KqO3Ik9qyiXL3TZ2Dpc8PlaAI36daY3Na9MSBNgn1/6fTJyXGJiVDTS0CixS0bgrVFvoQl7anMYh1EZzTa040tp+3osRERmFPb+57Ok2R9gIHNVnWV87PExgnzi1QSWiB2XKU+8XGaAjBc/EVfNdzQ7KzrJxWXJTC8sQ8Uo9L800EHPSLtDnwTt6gTYslX1eeN4P2b8KtX9lBnDi34vw/0Ky9M+DCIeZdvIHo2kesfRa7ZeZBsYooL7e4hcj43g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f639cf6-edbf-4ff1-2d0f-08d84452e9dc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 15:16:57.6612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mt7HUv/gDMoA1yakRHrbZTxzzn2JjJi+3n6K37wElrhcAfIMSLYdYX4epJrFfioR2INDElMomlDlOFro0DtRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3227
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This generic callback will be called just before setting the spte.

Check the return code where not previously checked since this operation can
return an error.

Defer pinning of SEV guest pages until they're used in order to reduce SEV
guest startup time by eliminating the compute cycles required to pin all
the pages up front. Additionally, we want to reduce memory pressure due to
guests that reserve but only sparsely access a large amount of memory.

Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          | 30 ++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  | 27 ++++++++++++++++-----------
 3 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5aaef036627f..767653fa3245 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1227,6 +1227,9 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+
+	int (*pin_page)(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
+			int level, u64 *spte);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fa506aaaf019..2b60fdb79b86 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3004,6 +3004,22 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
+	if (kvm_x86_ops.pin_page && !kvm_is_mmio_pfn(pfn)) {
+		ret = kvm_x86_ops.pin_page(vcpu, gfn, pfn, level, &spte);
+		if (ret) {
+			if (WARN_ON_ONCE(ret > 0))
+				/*
+				 * pin_page() should return 0 on success
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
@@ -3086,6 +3102,9 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	set_spte_ret = set_spte(vcpu, sptep, pte_access, level, gfn, pfn,
 				speculative, true, host_writable);
+	if (set_spte_ret < 0)
+		return set_spte_ret;
+
 	if (set_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
 		if (write_fault)
 			ret = RET_PF_EMULATE;
@@ -3134,7 +3153,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	struct page *pages[PTE_PREFETCH_NUM];
 	struct kvm_memory_slot *slot;
 	unsigned int access = sp->role.access;
-	int i, ret;
+	int i, ret, error_ret = 0;
 	gfn_t gfn;
 
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
@@ -3147,12 +3166,15 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
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

