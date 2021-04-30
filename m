Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD436FAC3
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhD3MoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:44:01 -0400
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:17504
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232864AbhD3Mmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:42:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WycweyI+TpATuASTjjxHYZI/VrBTQ9T/dRki9nHnCwpa+CM3dDEAbXYqLKWq0m5x9+f+DgWPNWgJL+CQ4WMKC3gK3zcGIK5FhXzfTakYUtGh0R7qz3sbSFZ6Zq6XJvy5Alimtki8whAI/CUUN7pcdzchHhDX98PDttvRx930DPtcSl0i0Wz/YoXqq1M3zd7EZ3vNZnA9pWpKjziw8wYcCFnp/YIZRKNxj3OVXcHgZPEfu1v4jBQegbRRJSMP6uF+oH8U/gogyr9CGY7MF4P8nMNX0hkuN4A6x6JkqfqGfiqXywLpXaF/2Db6yRalaSdjlYw5bICjQxKGCqowp7nouA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbWGvY0hZXrFV5m34YOWufHKOcUq09HoI4G2ygLUeX8=;
 b=Q1VD8Ob/ADhZE7Rkyj1jq6Z6z0rWAn5NHQNfMnlICoQU128NK7F7fXIwv2WZxqcHTskmi64fbyE1vVaPEr+ibtnkeV0Vllg318g6w6yUmg5EAEQYW+9hXUS4t4r/j7Dgism+81X81qxMVNOBwCohpbAdMZJq3GKsOllVFw6EH35/7ziymkQONM+64eTxJppIGIWcCqtWrf/FWHL5tCvUsFTE5rhzYUbRkESJZC0PJMRJgm0KHPWB9aVYOmd93lhzUz0GM6bWur5+a//fJ7DiyU8FOFa42+yVjxsSouskDpVxtCQqabDzrqEZV/dhZMLGXEly3SKVE/wXqJw/uKtvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbWGvY0hZXrFV5m34YOWufHKOcUq09HoI4G2ygLUeX8=;
 b=fHCFwqzacbGWjjrRa7uucjIUwfIfjYHQBINOSvg9gADkwQaJYOTeKR9BJnAH7QYAnS8Z1dkeSdi4c0UYkaxLRFZn8j589dMzH8R4oQ8e5O+K/JudsSc4i7TX4FYJJq444MVptCHHAGAiweA/zgWjD5xaZucQQ8rdiX1LScZWWHk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:49 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:49 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 35/37] KVM: SVM: Add support to handle the RMP nested page fault
Date:   Fri, 30 Apr 2021 07:38:20 -0500
Message-Id: <20210430123822.13825-36-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b3d482f-7356-4729-1fa2-08d90bd4f987
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26885C2CCC7FBC365A35D7FBE55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aK2VV5kvxV5b3os4EAhrj8QzQyW8oNHaHS1C6N1jqtP7crN+ft4rfl8zDj7U5rZMqnZnn37J2155L0wN4jXpNTI4uQEN1fWqFwaEyR43i1Ill8NFnYCOKXLI8GZ2uanw+q1odOw3SdsKp9dFWqP+fBq0mu7Q2wrDFniYmPxc1dFabnwUGbtz6h8iXeURBo1t92orzYflK4GKObMjHM/yNV0u0ypbiZYG1+piLU62wAuWWxIyLnxQSWzgblH+BKH0ABhQjo96pkmggdcF64GDpW84Vw12Z/bBrLR1Z9LJkNIB0Mbj8WZg7kg/5Z/cc3D/oYjkPkwrT0W/BA4hEwnrL8T9ilTQ+z74we6P09aJaKPt/J9Z9n3MoBAeZ2Nq4acGkMecaKaOTk65pCtO1VNAf4zWCvfmhDBHAetcQOZymv5Big+mIEVhTuX+6XkqkV2tKkWWzIk5oC2YGIe6OqMW5AOoWhaJev+Kr6OETN2BzhsM6pxOGfReuVC0ELCjqPVzii/I4iHhpqeMBgPC4ETha7o8dpjnJYyWpOndZXPCAg3MrSo5REr36mOjmnEKSNQiydrkLEnM1q4hcOBwJgYRfpHwDJCptmYrpWKQ1/+7WiovTuxaA1fOwkKdWdQ3zTSxD9d9O0aCaMdH7Ou2tiP51A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?n/qvamZVrxWnqFcTSELUoJbTIk6386YGA6G1EfJF4okREteQGC4Aj/lKAw4K?=
 =?us-ascii?Q?DYBCkwXn/+XS0IP+lPXqmljjks04DqtWSdkO8DVwtyX0CYouIaSioX2FhleH?=
 =?us-ascii?Q?NF4LZF0Qpl9S+VkQrILpApXqHYt3cxmZZdNHGlkEhhIf9Pt6cIQxm81qQ+6m?=
 =?us-ascii?Q?AKgUYDbcK8WVKOaPi1vEUy2ZOmFhVTnExyQJxirznTcoM+D+4l4Zpm1Epx+o?=
 =?us-ascii?Q?FmuBOk1vDq03ZGin8MQ1j/7UD17F42/b7EOce0ny0OGR/724lvPi2CjPcwqN?=
 =?us-ascii?Q?OBnKGhKpfhNtZp7TwqIwUK4UpCCQmtzkJCkwUZao4Y0sBejMCMAmlcMKAacT?=
 =?us-ascii?Q?L99dxWV+FF3BzIN6PASWlYN3r3HqNz7X/1qDin2TkNcdov7e0HMgnjngWGl1?=
 =?us-ascii?Q?4U2HFbsW7zchY1FcBt1K4DNCoq+kJ+wtIdBzyQ7mxLlJsXZRUgA1Ex8k5eB0?=
 =?us-ascii?Q?4DeyX6k3dNdzOtG/QueQoAToKwPeFajwiDccvwDmpFVjrVRqg20tVqGTg34L?=
 =?us-ascii?Q?frqZD2AsCE76Q5tjyr6a8DzrE6+41a5hGIK02xq5rPeH+zvGg7iM82rCYHJ7?=
 =?us-ascii?Q?Zkd4aX5zCJPlIRWFvEupsi2lbfTmRuLQjAXEIVTuPFkpfw08a6uXdEspyO+X?=
 =?us-ascii?Q?AoKZX3M7vSct+nZbS4+B4IRDh58P3BejqE7F1S8ErHOaN0UvdbGaAU7UIHYb?=
 =?us-ascii?Q?lLQ7PFTPCjfUaYQc7v36i0pi3Qak5CNe9wh9+3EFXhcB4QvgcaU122eGXb3c?=
 =?us-ascii?Q?Ui1p6KFSwDc4Eo2bpjc1V1LarsiTUMKnIzZSPA+mfFUBwp+Q91jPEMiUtvjJ?=
 =?us-ascii?Q?d6n8E9oEu0+wHh0wFxuuULqXrgt1PeMro3poSuRDBIUD34M6f4Nxr50gEl4g?=
 =?us-ascii?Q?5llk1FQhaEAfxE7P3Kht1l2Q7P2Fqrv+yR6DVARmyLthZCYm5ZFE27kOFqgV?=
 =?us-ascii?Q?gYxxS+0WUgy03Ioe6i70xUWtLmXbVldeLm2iLs6llTeFUyVuSaFVZQ8iMdmQ?=
 =?us-ascii?Q?l/yEKl0E/SUaIiS9hTMOuD7JhC4nZHTi/l9alkiGL02xEVM3bDyxq3COJXMp?=
 =?us-ascii?Q?4+GGxcQ11ekQmGnNol2y9/19PDFXXvCxh8BWlSFT0ox8O/fWv4jc27n/wrp7?=
 =?us-ascii?Q?EXJwr7kcUb/2hnc+85lXtuYBA4SHFvAMRojmQz4pTl5kAB2A+FFA9SXSpGmw?=
 =?us-ascii?Q?yv0FJJ2uKF7f/XQvCfDWsiFd/5iQQNzgcZKz7mLNWcZdH6sE5YO94nhcfYfr?=
 =?us-ascii?Q?qtWRy1gSTyhe63EEwkbW0n7EHrFBzw8cS4g9VvYxL6OIsZagj+0CNmVr3Rr4?=
 =?us-ascii?Q?VW3K49rKsQxM35COU+ySlfZx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3d482f-7356-4729-1fa2-08d90bd4f987
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:19.9209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URXLGAZcSUEv5PqmwbxLppchqoUo1jurhoROIbSKITXHvtg0y1bQvk7UcujiJ5Yy78LaA4FPtcHqLT5XqjFE8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Follow the recommendation from APM2 section 15.36.10 and 15.36.11 to
resolve the RMP violation encountered during the NPT table walk.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++++
 arch/x86/kvm/svm/sev.c          | 57 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  2 ++
 5 files changed, 82 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7d4db88b94f3..8413220f3a83 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1391,6 +1391,8 @@ struct kvm_x86_ops {
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*get_tdp_max_page_level)(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
+	int (*handle_rmp_page_fault)(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
+			int level, u64 error_code);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d484f9e8a6b5..0a2bf3c2af14 100644
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
index bd71ece35597..8e4783e105b9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3428,3 +3428,60 @@ int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
 
 	return min_t(uint32_t, level, max_level);
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
index 81a83a7c1229..fd58f7358386 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4618,6 +4618,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 	.get_tdp_max_page_level = sev_get_tdp_max_page_level,
+	.handle_rmp_page_fault = snp_handle_rmp_page_fault,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 243503fa3fd6..011374e6b2b2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -575,6 +575,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
+int snp_handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
+			      int level, u64 error_code);
 
 /* vmenter.S */
 
-- 
2.17.1

