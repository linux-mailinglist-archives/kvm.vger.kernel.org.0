Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C053F30FC
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhHTQGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:06:02 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:31456
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232762AbhHTQDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:03:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeyREFdj2y/Gz7rNNpyMgvE05Q8zDnzLdsg0V7jOzO5JGoYl7fyXwj+gOAk8woCC0584fEv0zzPLV4knYyCMumVe97syxbRkv3he9iYOJLYjAu/5dCRp8S41CJj5/y8L2WQD8pY+n9owYOivMNGnXlMzZ6g5tlNxEgetLEef6CM3Lq7FKqlWRqYMhGMVD19EVjXeBMzk9Tgs84VQA6w3aOWtiMYeM67hKl+4OLFrSptu2SqlmVG31zEeNicVNW75bKVch8ihcZEqjokhbbPijsdoTu2Fz+qGP/6i/5+NW3oCqGYUNEQW89/RudkI4MUukjBtzd8Y28u8cn9Whr2owA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZFq/dGo+kLu7NVgIMt7qlWNCwQLMd7WTut81kZQR7w=;
 b=MwbNoSzmX41k8xalB3sOs1/8x63obdtQfZyHKEOJxMK92OrH8oYuyZVCPC13mWUWlcqY8cPL11HwDTzJlSwhBSsNt0mAgdNsGj6vigPr85ZlCzPaYOXOvY5EN0YK1MYmlylVCy+TR22hEiMMO9wVTX1g5fxrqGSKqsd0tArv3pi4lRaOy27CQ+Q4+sA5aLThSFzinHO4zWO+8+WTEO0LNAqvKKn73XjFeXVq3+iG2tF5tPUgKikdcyOIcQMpHJHhYxOoQEyK2vsQQttWW42BeAaM8XEKxc/Nyb9qc9gW/jV6uxliHn/dLfoVvs4HNyJK8kpx3VUF1j6MZ7l7B5G7hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZFq/dGo+kLu7NVgIMt7qlWNCwQLMd7WTut81kZQR7w=;
 b=Qr8o+WFa+4tFiZBghHCrVEePlq+2XqSP/a7KFXlj0amIUMjNNMSnX7WLaOdHoB9UrFUJjV4G9WxayBGfYTQbfF9PnhXABqaDdXu4BYhlRiYNSxoJf/Z0vGu0TSVwx8P0j2LQojAIwBOmilIeEhSN4v2Kzhp6bh35jPc0KcVT51A=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:09 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:09 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 41/45] KVM: SVM: Add support to handle the RMP nested page fault
Date:   Fri, 20 Aug 2021 10:59:14 -0500
Message-Id: <20210820155918.7518-42-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b031cdf-5472-4765-09de-08d963f3abd5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB450967C371D52C4EB3A2900FE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q1oNDHqMARHmr9v1JhMNmxaypVk3nPte6KbcUb1Tnk6Qi+DE0Z0Zhqn9d/Q0PDpIKDcvhSYRDcBJUASO4fq3xwi19hBeIvFFNjC1+z1VDSOUpeIRJcHwb7fnl1Y3Snnfko5VlCzOCgQLDkOT2JyfynIaxMTzsAGzs5OelyxHtc089R+wbplEir/ZHin1ZPpvjEsFRHYlX9rexHKDww3Md0rOJql2jLreAEF+seROnvLDkjYOvoZsy6LTi1GZWXLsB0L9BU5aSpOEFRlMmFcrI5fXOnEUeWhN8Q9ud539IEn66C2jC9sMGm70FOqDs8AvI7nfEPD5CO0DPg1Bw1YSa+zUc35UdE47X3AysAZtSylVV2cHdqHiZ5iFazgBC01GpPXNm8/4S/cV7WG3o9VsGL2ZKsYg5/s14cPHfXCtLAEdbhVHe//GBonct3bWG1q+qm5rmpzRv7kiSLQmvYod7YwDOP8HcMGiGu8BqlyvzYH9PVo1p7Al1xIwLTUzmi/POnqulcpcBjAHHXLWIH86GiiTzSUdKk6Pog6Mt2xpiaOxYBKs9L1d0OmwcdSUsf1yITDzjq16zU14bnCNEZuOmJnTo2H4Eh8+lOc4rIti54g4XVHGzvZqwU6HVBz1/qqvVPnlhd+KKIjPWejnebQtwCCU4NFHRXnNUKvTadxMG38tiGrjUW0n9zLW5Kmlw+rxitVA6IFGoDo0CERTiLX8zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qws1+R0TtTyy8+w6UO72Dc6C1ISyqL7UTPb8QVRbiJiKgOJZZIIqk3qaSW2b?=
 =?us-ascii?Q?D6EeX7/wtm1GxOWptLX6MkHfSRkwz8rF5IdGHUoKhJpLVqmHAA8fTdSiLT7m?=
 =?us-ascii?Q?sX7mS746vW5scqt5e9Raa1GS4W1O7DPRLZEALzwCyO2WYCdCHzdMR0Bem8A7?=
 =?us-ascii?Q?Mpt0dX4js/1dBXasqquajvlJ5jc1P9jfnCPDMQpYwPzFmT6ss7e9RfhWWk3Q?=
 =?us-ascii?Q?WBfimlrri/8NVz5Dbylg0L5G8hywIrHghgz0hePB8M1CwdKrJvJQ/BhciXra?=
 =?us-ascii?Q?Jkbb/hKBUX1y7XiAkLMyNjtk+JqjEAudQiLLSzlbLBw6QyAedLXjSYPnl+pC?=
 =?us-ascii?Q?bMOegCwKS360EGi9Z+pR3RvemPj1RRf2iYbc4zHxYGZLEXU9Kc+x/M0+zrqW?=
 =?us-ascii?Q?qQLhZ2ZvZhLmvxdf1CRSomwE2mmQXxMjVkGlAg0KCCXXwM/SXvA8/k3BHFSu?=
 =?us-ascii?Q?3SfuGn/7DquZy6rYf1OHMjUv992edC8fU0PTgHM4YG1ndrKXhc52nXD1gbIf?=
 =?us-ascii?Q?g/ChuAOGnzJe1GmngCXm21whcUAmq7evwl4WrNd7EVmYhLw68j5vr07oabej?=
 =?us-ascii?Q?BtRDQnoZtOyEyy+D0aianCTq9X9ZPp8JcFeTYnvCUV3f2FLVET9G+jv3AMW0?=
 =?us-ascii?Q?BJ56cv3lwpp66Cqy3RB9R7h7jrVLh2wF6rUi/JzwxEk4Cd+Dv1jJ0qsc0i1B?=
 =?us-ascii?Q?EibT7qUJq2YX7gxshmeEnX4Mpb91CSaZHeUPNCG9ITNNlNX4vARH3dSRPPUe?=
 =?us-ascii?Q?d1WWgf2THlsjdF/PNCWlKLobtAWWk6JgssJdr3qm4xpICMwI1JJrvF+o2Ucp?=
 =?us-ascii?Q?b9Fpso13zUW1Kzdn9S+Lh13crpwYBZmCd8N0+Xr8W1BkBg/e/my9nvg3TSBk?=
 =?us-ascii?Q?ABSzDkruh1SuG2lauK2W4W9JkLIvK6Eu/rYT5Bf70cZpV7hnbd4x0+r4g8Ap?=
 =?us-ascii?Q?bsF+9BvhF1rhKQ2acf18QrTB72XbMjLDEL+Gy7d6UTMkAzZoQC+7t+tFe+/l?=
 =?us-ascii?Q?H05gNIJMK4eykLSSn6g10/8Jx3iigrju2zkIK1j3YIPeiqRDyjM4TduKfWgL?=
 =?us-ascii?Q?Df8qS7JmhhCBUjHx5ZAGqUUbupDRJl9XDQrCO1IYAaS1ppZ/6czfE49vwPHg?=
 =?us-ascii?Q?nW85sXgLzzS36abvg8CPyB+anEWTC7y3zhrOFBhkHYx6Q0yz9s3W2u+GoQUz?=
 =?us-ascii?Q?xoaTewqK4vQUV+awdspnFoaBcAluFokjFq0b0ZxLwZzBsSALTps1eM+YBOtx?=
 =?us-ascii?Q?rh2l2slVucrL2jSGiIPmkFelzZ5Tsr3caTZ5OTwBDbdJh65qj2J/NJqkHZsY?=
 =?us-ascii?Q?2pv2ugfsTKoA54mwZkD5vpST?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b031cdf-5472-4765-09de-08d963f3abd5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:46.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hM3NJoOXNQQ6jh/SS7wW53veguG+0idHwKBoz378JLu91HmmHWD04UPNp1qQgDt/0vnaagD+qG3Xiaj6MQ8e6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled in the guest, the hardware places restrictions on
all memory accesses based on the contents of the RMP table. When hardware
encounters RMP check failure caused by the guest memory access it raises
the #NPF. The error code contains additional information on the access
type. See the APM volume 2 for additional information.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 14 +++++---
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 65b578463271..712e8907bc39 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3651,3 +3651,79 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int token)
 
 	srcu_read_unlock(&sev->psc_srcu, token);
 }
+
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
+{
+	int rmp_level, npt_level, rc, assigned;
+	struct kvm *kvm = vcpu->kvm;
+	gfn_t gfn = gpa_to_gfn(gpa);
+	bool need_psc = false;
+	enum psc_op psc_op;
+	kvm_pfn_t pfn;
+	bool private;
+
+	write_lock(&kvm->mmu_lock);
+
+	if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level)))
+		goto unlock;
+
+	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (unlikely(assigned < 0))
+		goto unlock;
+
+	private = !!(error_code & PFERR_GUEST_ENC_MASK);
+
+	/*
+	 * If the fault was due to size mismatch, or NPT and RMP page level's
+	 * are not in sync, then use PSMASH to split the RMP entry into 4K.
+	 */
+	if ((error_code & PFERR_GUEST_SIZEM_MASK) ||
+	    (npt_level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M && private)) {
+		rc = snp_rmptable_psmash(kvm, pfn);
+		if (rc)
+			pr_err_ratelimited("psmash failed, gpa 0x%llx pfn 0x%llx rc %d\n",
+					   gpa, pfn, rc);
+		goto out;
+	}
+
+	/*
+	 * If it's a private access, and the page is not assigned in the
+	 * RMP table, create a new private RMP entry. This can happen if
+	 * guest did not use the PSC VMGEXIT to transition the page state
+	 * before the access.
+	 */
+	if (!assigned && private) {
+		need_psc = 1;
+		psc_op = SNP_PAGE_STATE_PRIVATE;
+		goto out;
+	}
+
+	/*
+	 * If it's a shared access, but the page is private in the RMP table
+	 * then make the page shared in the RMP table. This can happen if
+	 * the guest did not use the PSC VMGEXIT to transition the page
+	 * state before the access.
+	 */
+	if (assigned && !private) {
+		need_psc = 1;
+		psc_op = SNP_PAGE_STATE_SHARED;
+	}
+
+out:
+	write_unlock(&kvm->mmu_lock);
+
+	if (need_psc)
+		rc = __snp_handle_page_state_change(vcpu, psc_op, gpa, PG_LEVEL_4K);
+
+	/*
+	 * The fault handler has updated the RMP pagesize, zap the existing
+	 * rmaps for large entry ranges so that nested page table gets rebuilt
+	 * with the updated RMP pagesize.
+	 */
+	gfn = gpa_to_gfn(gpa) & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
+	return;
+
+unlock:
+	write_unlock(&kvm->mmu_lock);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3784d389247b..3ba62f21b113 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1933,15 +1933,21 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 static int npf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int rc;
 
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	trace_kvm_page_fault(fault_address, error_code);
-	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
-			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-			svm->vmcb->control.insn_bytes : NULL,
-			svm->vmcb->control.insn_len);
+	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
+				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
+				svm->vmcb->control.insn_bytes : NULL,
+				svm->vmcb->control.insn_len);
+
+	if (error_code & PFERR_GUEST_RMP_MASK)
+		handle_rmp_page_fault(vcpu, fault_address, error_code);
+
+	return rc;
 }
 
 static int db_interception(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ff91184f9b4a..280072995306 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -626,6 +626,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level);
 int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token);
 void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int token);
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 
 /* vmenter.S */
 
-- 
2.17.1

