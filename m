Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154E4398C5F
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhFBOR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:56 -0400
Received: from mail-dm3nam07on2076.outbound.protection.outlook.com ([40.107.95.76]:3297
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231732AbhFBOPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFcKEhWCuaSBCNJo0VrkYdCOpxSgT56yQMpim9jIvemXFDg6yJA7JC3aH3JNWdErX6rUlE159Pzm3aerOdxkiYIGL0g62jHeY8XbJduhJl2nw1iQdXzf1RgTE9XO9E1rjIOBhxYjSueIDKGt/ACOJOjRBITBwB9aznH3AXQl4dPTGbCb89BdSBTqFrpeGhPeFhIdCbYPA97JYIT4K/hPQFHqyc7aZI5CpA5NFL2vXV4qjqyQHj4WnRcpGxBSkFrdNcrkCsRILzw4QGmrM/kfYPv95VQMoLaNlNZRy+bTw7sYGkSFrsmHtWR0+r6rLQA5gtWeY3BdVkV5TxBzYEebXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Tl9aw51wwJjspRUscIWdOdkee0xpKTLD8cxKdNcEOo=;
 b=StZpQQZHgJvHvqcV0n4NdrjmCrGq4oO/A0gvLeUkSeOflwNnvWw0bKQgHSYmhgHrG4BUoxiyVn96hqpwKswdKUDX+LWNC56qJO+O6Lp0O/8/4RSLxRjxxknGmhumJJ1I1xb/kkchDkA+MfLFJJeHGsKBh2QLSUWkABM0pJUO/5T2wt3iQcPA2CTBBVn0jNbP62O49Sq4s9AdfIJ7gMkvJds5WonxFldTLXfwSXFz5DThWYgLsYZSIVfy3PleIgvGxw4bzv1YTH+2STdaHvuR0vYSy95z39tJbW5UIpPHS20v7Nx1WpS3YhyJwD0+9APcSH6dfCoSRp3So39hAc2LgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Tl9aw51wwJjspRUscIWdOdkee0xpKTLD8cxKdNcEOo=;
 b=r+gT8peIdi5kcgnP7INPYGxe9cE+4TR0IjBnX6Ru/Q+girvn3VJcknyuPkoH591S/nw6K8CDtq2iUkFc581Umqfg63kgfUjcHT7uPJiNB0icAuOBRmwvSQ+Cd6BdPyyFyvjF8cmXf8lHglC6Nm0+1xePbgaSNze3XZbxqcyoCVs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 14:12:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:39 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 34/37] KVM: SVM: Add support to handle the RMP nested page fault
Date:   Wed,  2 Jun 2021 09:10:54 -0500
Message-Id: <20210602141057.27107-35-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d1c9718-3550-4016-5d59-08d925d06ae5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574C47932525B9988226B5DE53D9@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sy9CXmzqxENbH9AIfmkNt6Ijvz/C6DTdAc8BcNqUiEj+ZJ58BiwSyY9ZblNtRenEgZ/gCh+xqVMoflXohw0PL587X04HcGnQFJTVfl7sXtFqEW8cXd08N3osjAz/nE131W9gNSEx6cAAfyhEQWJMBo6iXQK6yvQTNGPd+VVRhJUlPiJ38rWMhfNAW0vB0pod09/95a037cj2mCel3qsJsC3cMFpVpmDQdMyPLXfDHVTjK6N2DCm60ik8UCTFrvydeYKr+0lv3MulGvgxzFkFzH+1rPJao2/nJIY3T7W0YPNUjVyfbmMimTxeLkC1aU7obRI0N6VaRY/B0SjBIFOspfaL1TWWt2zNLOTOLZ1G9VSCiIv3eKHe8m+J+Ca7QULKRSD56Swoz+0IXGq7L/mrOQxCaOAJNXfGgNkAaJdqQVJiUXJkfb2odjUYlgTotWxv91/qk3DAQBo0cXBTU83uRdm7vafWEO8A3uxGQxl61BEuIursj5WBx8a1F0CgtHVoaV1f11rQN4vswXNyiboavv8DSojp0ph4U+nNOb2TD/yhNOjUN1/jylEdeWJkCDn2n9BHsDiGsV3B4PEarErlQSOttNL5TonZQNz0DX/ygkgfTt6907cGWmTKWaElyzDdpU7gd1K9w7X0LzqdR4FWSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(8936002)(7696005)(52116002)(956004)(478600001)(2616005)(66476007)(66946007)(2906002)(26005)(186003)(16526019)(7416002)(4326008)(1076003)(316002)(6666004)(38100700002)(38350700002)(66556008)(44832011)(83380400001)(8676002)(5660300002)(6486002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MLbFr/A9BpellT10XMQxzT9FaZCFFd3yEPoUiXgLW27IdSRviwWCLpUtstzf?=
 =?us-ascii?Q?sX2jOgyrW0l3cyozCaIkvsuaP3NgctHH6EKhBS1PJkpZZ1/ln3oZj4hB8bgK?=
 =?us-ascii?Q?NZuA5jETZbDlYNcWV7xEj6siKXs+QhN4KKlNLCRuvm38Ym9wiz2pYwHjnx0a?=
 =?us-ascii?Q?eZp976JRis/07FsotKnOWswk1JNV2592HxpZ+IPm1hUG7uLmBA41DkdmsWZh?=
 =?us-ascii?Q?3dvL1GWnvmBFPMmdD1c2YrmHVRVM8JVEA9HBai0CL8V4DRKE7VTS/hThOSEA?=
 =?us-ascii?Q?8XfmHDzv3+iZ60IgeDLDAsqHi+dB6pa/eWSFQUswa4+bNOKeLkUPm00fqeTE?=
 =?us-ascii?Q?cfuZMz+hJrsgv2A2UTLmDzh+Hb7GhSm0mywM7cZkI5KziS8mjcbaHmEKTuXR?=
 =?us-ascii?Q?YI2QcIYeB4lyLrxHAIonW+NTINkBmefvTYvb9fQku3fgO38z1eKFt/eilViv?=
 =?us-ascii?Q?9amQJI3GhzPnBbEpYeWX62+qOKAo8RCXb7CVyWBLKrZrnu4hJmZDHRXdtu70?=
 =?us-ascii?Q?8btVitMYBnodntMkGEvdSRPJbaRykN/B+Xm3AXGjc3IFZjm3si2EvSUQJj5M?=
 =?us-ascii?Q?KSsdt9aoHEQ77/cVUwQiRlQPiWplpsV+LWfomRyAuGdeyWb0eFJfmVLiARQ1?=
 =?us-ascii?Q?ZoUoT3M71m7zFgsJc5ETgpmJzBWXrExPQ+VhVa3s0VehtZmj+i2NMVvVVepK?=
 =?us-ascii?Q?NKFghrt21OdUHDdmU36ALebjsIag0pzvhXej9Z1/KEJGU0EU+WQUv6LCXunf?=
 =?us-ascii?Q?pOPTXancMDES+wNYbPARRxhH3wWfIjSc5EsfrQQa6rNtMlF2eL2q8jSr2EjC?=
 =?us-ascii?Q?WiHNqeAQ94LZS5+c5NEciMRq/IvDS6WEuRQNuq3gPi4ZQ8Wi8plAP2kjDj3J?=
 =?us-ascii?Q?c4I9DA4GVaq7YKJWeV+rfl+QmooNxE3QeZmmSOVkfz045YrFutNULOXh1XnA?=
 =?us-ascii?Q?MtYK2zttTa2XCsIjQUjkUV/cZURW1NSdrkJ6h1614asDwzr+JdbppcI7FgPx?=
 =?us-ascii?Q?E8+/Hdq0mB+QzVSfZtHdCClUtB24h+m6haV0NLZ88DU6tww1LvzkPmY5+yeC?=
 =?us-ascii?Q?ZkcQEPCDbdzVjSNmKNYjRgg7D/MEPiU5wCeS/5Qgf0CYWzu656mahE2MAHfx?=
 =?us-ascii?Q?YoeWDLqpu3DtwGY9J27w2H3+WL7UL76yzZb5hHgDZxH0n5/JfzzEHvwyHbXr?=
 =?us-ascii?Q?EJt9LMTcvax+vkVVql7tfXtLGhoy10cVzELwNahydzP9ZS+W87gy0+z+cyUa?=
 =?us-ascii?Q?U/57h8GtDjDK/OP7b46/VyXNhtGb4hXDaOImqv38DYXlPGusHZJRjygSd8vt?=
 =?us-ascii?Q?iDH3DajMAQBOwRRiW3DhkhMR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1c9718-3550-4016-5d59-08d925d06ae5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:12.8276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKVslC/S8XA58FlDTdv95LX1y6UMeeBDxRA6hnoc2Rdq7mpuzdQE93FiVv2d8U2OnvfRhJe6FYqNqL7rKPNMMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Follow the recommendation from APM2 section 15.36.10 and 15.36.11 to
resolve the RMP violation encountered during the NPT table walk.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++++
 arch/x86/kvm/svm/sev.c          | 57 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/svm/svm.h          |  2 ++
 5 files changed, 84 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 46323af09995..117e2e08d7ed 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1399,6 +1399,9 @@ struct kvm_x86_ops {
 
 	void (*write_page_begin)(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
 	void (*write_page_end)(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
+
+	int (*handle_rmp_page_fault)(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
+			int level, u64 error_code);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e60f54455cdc..b6a676ba1862 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5096,6 +5096,18 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
+static int handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
+{
+	kvm_pfn_t pfn;
+	int level;
+
+	if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &level)))
+		return RET_PF_RETRY;
+
+	kvm_x86_ops.handle_rmp_page_fault(vcpu, gpa, pfn, level, error_code);
+	return RET_PF_RETRY;
+}
+
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
@@ -5112,6 +5124,14 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 			goto emulate;
 	}
 
+	if (unlikely(error_code & PFERR_GUEST_RMP_MASK)) {
+		r = handle_rmp_page_fault(vcpu, cr2_or_gpa, error_code);
+		if (r == RET_PF_RETRY)
+			return 1;
+		else
+			return r;
+	}
+
 	if (r == RET_PF_INVALID) {
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
 					  lower_32_bits(error_code), false);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d30419e91288..5b033d4c3b92 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3497,3 +3497,60 @@ void sev_snp_write_page_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn
 		BUG_ON(rc != 0);
 	}
 }
+
+int snp_handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
+			      int level, u64 error_code)
+{
+	struct rmpentry *e;
+	int rlevel, rc = 0;
+	bool private;
+	gfn_t gfn;
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rlevel);
+	if (!e)
+		return 1;
+
+	private = !!(error_code & PFERR_GUEST_ENC_MASK);
+
+	/*
+	 * See APM section 15.36.11 on how to handle the RMP fault for the large pages.
+	 *
+	 *  npt	     rmp    access      action
+	 *  --------------------------------------------------
+	 *  4k       2M     C=1       psmash
+	 *  x        x      C=1       if page is not private then add a new RMP entry
+	 *  x        x      C=0       if page is private then make it shared
+	 *  2M       4k     C=x       zap
+	 */
+	if ((error_code & PFERR_GUEST_SIZEM_MASK) ||
+	    ((level == PG_LEVEL_4K) && (rlevel == PG_LEVEL_2M) && private)) {
+		rc = snp_rmptable_psmash(vcpu, pfn);
+		goto zap_gfn;
+	}
+
+	/*
+	 * If it's a private access, and the page is not assigned in the RMP table, create a
+	 * new private RMP entry.
+	 */
+	if (!rmpentry_assigned(e) && private) {
+		rc = snp_make_page_private(vcpu, gpa, pfn, PG_LEVEL_4K);
+		goto zap_gfn;
+	}
+
+	/*
+	 * If it's a shared access, then make the page shared in the RMP table.
+	 */
+	if (rmpentry_assigned(e) && !private)
+		rc = snp_make_page_shared(vcpu, gpa, pfn, PG_LEVEL_4K);
+
+zap_gfn:
+	/*
+	 * Now that we have updated the RMP pagesize, zap the existing rmaps for
+	 * large entry ranges so that nested page table gets rebuilt with the updated RMP
+	 * pagesize.
+	 */
+	gfn = gpa_to_gfn(gpa) & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+	kvm_zap_gfn_range(vcpu->kvm, gfn, gfn + 512);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4ff6fc86dd18..32e35d396508 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4579,6 +4579,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_tdp_max_page_level = sev_get_tdp_max_page_level,
 
 	.write_page_begin = sev_snp_write_page_begin,
+
+	.handle_rmp_page_fault = snp_handle_rmp_page_fault,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e0276ad8a1ae..ccdaaa4e1fb1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -577,6 +577,8 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
 void sev_snp_write_page_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
+int snp_handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
+			      int level, u64 error_code);
 
 /* vmenter.S */
 
-- 
2.17.1

