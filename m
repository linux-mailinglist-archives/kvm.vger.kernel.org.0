Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D453F30CB
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbhHTQEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:33 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:48265
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233750AbhHTQC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsPfhv/KYH1As0RZPtT3bNIVszE3CwY18WUgc23fZa3vImBzUQdORUTDQU11QyuFzQVw4t5IyOk4DVRZIqPdZcyG09PZU/Hslh6l0UlzRPSX5lT0xg44VYsbDB/LcWyhpDIdu4j2Khx3iSCUam2zvHXy1W7cSU6VeHx3lgTSWt3AwcXesh4+04gHQvwI432hil+AhkqDHc4K3/TkWaXgk+F1APtMwcHEGla5UsueYu9D23XnxAsgbsJwydLoC7u/sNWT/1xi+4hXJGxLEV4knzOdgRCCIgL5TTi7uv2qVZyHESHaQIhDWUnpMBnFGOtAOgZyR75zP1ELgneLL3K1yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlUYeTGJpskcVXFwShMkiZufrtGyx+SVAJgfuVhYqKE=;
 b=Zcx/4oHAsPfSjwd3HuHjmRZUSru8bWCLcF/M04Ko0IKF1YPmDn63S7RgHTrkDM/yLA2+uUght4wVmpuTak9Op2U+SuEzv8Juilrn7lP9C7Fh8t1nLIjIeHfaQom94gKhRyW7wP2O92MSXtrB3tAtWUKlgP4JvbL6+TUZaVkoO+4d0xyD1i1FuPzF9ms0/oE52s+citv6ZiR00tE9fRlaoTrY5F4AfZ1VkAfN90ps37RumxCTQ19M6vJjc+j91OBIaGiwPbblAzwM89q5cuEYbwhjSHwswk8KzT93vXyDmHnLIS5hoE7JhJBjIjfMroyN8xQkbYxkjkKieyMxHO70mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlUYeTGJpskcVXFwShMkiZufrtGyx+SVAJgfuVhYqKE=;
 b=JNQEBXL3BRBaJkQJEysIbnJ21v8L2nvPOfmk1K5F1jBG0oWyOOVtwy/PLotfgbVBwcCozoYXFZocpjDe6qEbnl8oLs9aPU4H4PxswdKxi6uFZWnlSne/L9tFJu+qHF2SVwDnS6kD1UUTsLDUr2snmI1MctnHMVgVeNJBB1y1eQM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:08 +0000
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
Subject: [PATCH Part2 v5 37/45] KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
Date:   Fri, 20 Aug 2021 10:59:10 -0500
Message-Id: <20210820155918.7518-38-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e4103c1-2c14-4b89-8ab0-08d963f3a905
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45099C0A0D4B06F9E7B0CD1AE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnYs1BUsevUHbQchg7ZnRY3z0OuwbniyF2neBNS/MZBVoTukgkjytgnxc9IJEc3bMnkoWGJBkvc9+vTMf9yFo1da5PGJkU3GDqmGpQrjsN2elNaU0QKAPK4PMK+Aj49hve3Q9iBQp0JS7VBYwjwLXKtmuwG0XkvHAiBsVXJmhvtqIJusOj+a1Oq+KFiwSzfltzbhP5SVjooWrrvFC0HbJSpyaOZHnSbkiUGRcIqpwVdcLVU2Vx8APmCBGz1He2+HpgYENqJEqDdAGNydFa1xlAGwWmj6Ql9BMfSdKxBQCtueZyObzNrGehcDkDiPe7hXrJGLnUZy+eZAxczU1kGnyFccBJeDazdJnBnrTBhataHOkXyniMvoPLHrxwROTVVVd4FP0GSiLgAjlvdmTsTOORvZ21irQZmSP1KVaK491CpWun2GjcnGxIOgr3rQrYf7HZDKjt7GgcvLOqST5KbAPdyxf8j9mYVvmvy8K96J3iL5++azW2XUp8etGTHgz1jIV3dPP5w/A3FTvauyIhqv05Eggli3iTx4dLA8Te1ZxhwuK3+1v9AFe7TOIh/9NmkR0zkfK5MoIZRTCEA8PflY8JYrsN3TWvZpyq8ORKdH1XXmh2Ap3KRCPYWj//TlrbSTaVfVzk9T78kvgSGEYk06ZnYtK4HtXnR9sEzJqaW7WN3qKIBdtXAHvGk7XCuSJj3chYcXnpvVL3tXSiC/mayzeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vcs00I7Bo7HmhXL7q5vDu+tR+GIbLbe598ixMsrXUNoKjFziGCiQy2UhQdUd?=
 =?us-ascii?Q?Jtwj5Jst4OVK2SJ3+Pjs2LRRDN1KcNUL+PrLNfCTvm9Seb+G95/AUAsCVV4/?=
 =?us-ascii?Q?fRa/bD39r3MMb/o+Es7GgQoyboUOnZ1yOc9CnvihfXGYzf9J/2lFlyRHm27q?=
 =?us-ascii?Q?54ui8UHFgZiWlMvVDEnLDemToRyjLmgBfakOPc4sHEzmTFDxIm+COTQkqufz?=
 =?us-ascii?Q?NM2t2Gg2GBHGBhdz1zjVtQ2tGXvaFR7OOmRYjG8DPAaj1biQ/dNykAK7k7KO?=
 =?us-ascii?Q?zt6SoLGN9tCFHfNnQ+JtFhsFtqh88zH8skPGi+6aM3Y/EG20DKt8qsYoGMJP?=
 =?us-ascii?Q?GSfpnVQeJ6QQNg7B9xDP+/OmwFvTmvqUBujwFYqjpBmu9RLLcRZrHvJmkHfm?=
 =?us-ascii?Q?XLI4CcnfRKjTD20nMN+8kO8a8Nr+NqZnPeEaX6yxZgpMsuq/EsAF6o6XRojD?=
 =?us-ascii?Q?XjS0PowavBp053pgLN2bEL/5r4101jOKiTGV9wdLNWHEZzBGNfVV/isvLRhj?=
 =?us-ascii?Q?M6q1NKil0CmYCYh9mv8STUdd2H1A4Fk72ZLTkI/253XBSdq+80BUp3Ye2viV?=
 =?us-ascii?Q?5xQorewzhWJrPvnk9oQz0HBHg3idZNml3thH3JNKhc/UkWmLUxJbxLhg2Zu1?=
 =?us-ascii?Q?rrmNCjU+hfi8qIsKM1zGzM9ic9qboXJx+WegQAlB+JpDJZNYmEYOrpOztOZr?=
 =?us-ascii?Q?OYCSKv/fK9+1GiwMiqNmjOa/I9OtDdm9vo9XdYhMwsu1/tX92e1wJLfPt5Vk?=
 =?us-ascii?Q?7lYrER/gF4MuoGo6Y12zYJTXuB/zdvsq6qSGrwJL8ZsLZzZF1IGU6CZVLp+d?=
 =?us-ascii?Q?Mu4dgpjMyNhsNDX7QpcZV0tM4N+BipeerzKVWgUdTai90JIVQjjRa1NM0JEY?=
 =?us-ascii?Q?djhkW5hgF3BoJmRLP/RnHNPki5n8w7SK5735VKWhv+c53xSWGDWKo6mcwPMY?=
 =?us-ascii?Q?0ttFJvS8oDaB+nXRBNlgAlUIE6CpH5s7MODtZEoIVpfWVEzYBmlDNew0dqE1?=
 =?us-ascii?Q?dqrZEAWbS2HYpY6bvv/rw0YTmfxDB02X0Nqn7mXCk4T7dRi6DNpAeCNV9TR/?=
 =?us-ascii?Q?cCoDBZohfORUHV9gDe3IBTeuGRoEyPLRiYctLVoDhyTe+G5vw76kBg89kEme?=
 =?us-ascii?Q?ANV2PCYTWOqNdIOSJYKAZbsy+EZsuU1BKO5GytQ4LzOxSUEGHJe5ewSfZ2iw?=
 =?us-ascii?Q?m+xSrFW5RtStaCLVubMNhBFbZusooc1ISe8k7lBDMf186i9OPY8j2s5gpbQi?=
 =?us-ascii?Q?Bs1fPdXKJTR+6InOwcbkkdLjDYuvNJpbib0rZ7YyGCX8hzdWVEpc/sWiAbaI?=
 =?us-ascii?Q?XjmkCAvurwADJ54mhjKPaLxn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4103c1-2c14-4b89-8ab0-08d963f3a905
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:41.5270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSuKLYwnb1ElP4h288vA3uplOQzckKR/6vdtuThiD0bCDmO+Naaoljh9oDaMCTVD06BKFUP34/G6dUsnlzZBag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

Before changing the page state in the RMP entry, lookup the page in the
NPT to make sure that there is a valid mapping for it. If the mapping
exist then try to find a workable page level between the NPT and RMP for
the page. If the page is not mapped in the NPT, then create a fault such
that it gets mapped before we change the page state in the RMP entry.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |   9 ++
 arch/x86/kvm/svm/sev.c            | 197 ++++++++++++++++++++++++++++++
 arch/x86/kvm/trace.h              |  34 ++++++
 arch/x86/kvm/x86.c                |   1 +
 4 files changed, 241 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 91089967ab09..4980f77aa1d5 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -89,6 +89,10 @@ enum psc_op {
 };
 
 #define GHCB_MSR_PSC_REQ		0x014
+#define GHCB_MSR_PSC_GFN_POS		12
+#define GHCB_MSR_PSC_GFN_MASK		GENMASK_ULL(39, 0)
+#define GHCB_MSR_PSC_OP_POS		52
+#define GHCB_MSR_PSC_OP_MASK		0xf
 #define GHCB_MSR_PSC_REQ_GFN(gfn, op)			\
 	/* GHCBData[55:52] */				\
 	(((u64)((op) & 0xf) << 52) |			\
@@ -98,6 +102,11 @@ enum psc_op {
 	GHCB_MSR_PSC_REQ)
 
 #define GHCB_MSR_PSC_RESP		0x015
+#define GHCB_MSR_PSC_ERROR_POS		32
+#define GHCB_MSR_PSC_ERROR_MASK		GENMASK_ULL(31, 0)
+#define GHCB_MSR_PSC_ERROR		GENMASK_ULL(31, 0)
+#define GHCB_MSR_PSC_RSVD_POS		12
+#define GHCB_MSR_PSC_RSVD_MASK		GENMASK_ULL(19, 0)
 #define GHCB_MSR_PSC_RESP_VAL(val)			\
 	/* GHCBData[63:32] */				\
 	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 991b8c996fc1..6d9483ec91ab 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -31,6 +31,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "mmu.h"
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -2905,6 +2906,181 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn);
+}
+
+static int snp_make_page_shared(struct kvm *kvm, gpa_t gpa, kvm_pfn_t pfn, int level)
+{
+	int rc, rmp_level;
+
+	rc = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (rc < 0)
+		return -EINVAL;
+
+	/* If page is not assigned then do nothing */
+	if (!rc)
+		return 0;
+
+	/*
+	 * Is the page part of an existing 2MB RMP entry ? Split the 2MB into
+	 * multiple of 4K-page before making the memory shared.
+	 */
+	if (level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M) {
+		rc = snp_rmptable_psmash(kvm, pfn);
+		if (rc)
+			return rc;
+	}
+
+	return rmp_make_shared(pfn, level);
+}
+
+static int snp_check_and_build_npt(struct kvm_vcpu *vcpu, gpa_t gpa, int level)
+{
+	struct kvm *kvm = vcpu->kvm;
+	int rc, npt_level;
+	kvm_pfn_t pfn;
+
+	/*
+	 * Get the pfn and level for the gpa from the nested page table.
+	 *
+	 * If the tdp walk fails, then its safe to say that there is no
+	 * valid mapping for this gpa. Create a fault to build the map.
+	 */
+	write_lock(&kvm->mmu_lock);
+	rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
+	write_unlock(&kvm->mmu_lock);
+	if (!rc) {
+		pfn = kvm_mmu_map_tdp_page(vcpu, gpa, PFERR_USER_MASK, level);
+		if (is_error_noslot_pfn(pfn))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int snp_gpa_to_hva(struct kvm *kvm, gpa_t gpa, hva_t *hva)
+{
+	struct kvm_memory_slot *slot;
+	gfn_t gfn = gpa_to_gfn(gpa);
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		srcu_read_unlock(&kvm->srcu, idx);
+		return -EINVAL;
+	}
+
+	/*
+	 * Note, using the __gfn_to_hva_memslot() is not solely for performance,
+	 * it's also necessary to avoid the "writable" check in __gfn_to_hva_many(),
+	 * which will always fail on read-only memslots due to gfn_to_hva() assuming
+	 * writes.
+	 */
+	*hva = __gfn_to_hva_memslot(slot, gfn);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return 0;
+}
+
+static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
+					  int level)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	struct kvm *kvm = vcpu->kvm;
+	int rc, npt_level;
+	kvm_pfn_t pfn;
+	gpa_t gpa_end;
+
+	gpa_end = gpa + page_level_size(level);
+
+	while (gpa < gpa_end) {
+		/*
+		 * If the gpa is not present in the NPT then build the NPT.
+		 */
+		rc = snp_check_and_build_npt(vcpu, gpa, level);
+		if (rc)
+			return -EINVAL;
+
+		if (op == SNP_PAGE_STATE_PRIVATE) {
+			hva_t hva;
+
+			if (snp_gpa_to_hva(kvm, gpa, &hva))
+				return -EINVAL;
+
+			/*
+			 * Verify that the hva range is registered. This enforcement is
+			 * required to avoid the cases where a page is marked private
+			 * in the RMP table but never gets cleanup during the VM
+			 * termination path.
+			 */
+			mutex_lock(&kvm->lock);
+			rc = is_hva_registered(kvm, hva, page_level_size(level));
+			mutex_unlock(&kvm->lock);
+			if (!rc)
+				return -EINVAL;
+
+			/*
+			 * Mark the userspace range unmerable before adding the pages
+			 * in the RMP table.
+			 */
+			mmap_write_lock(kvm->mm);
+			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
+			mmap_write_unlock(kvm->mm);
+			if (rc)
+				return -EINVAL;
+		}
+
+		write_lock(&kvm->mmu_lock);
+
+		rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
+		if (!rc) {
+			/*
+			 * This may happen if another vCPU unmapped the page
+			 * before we acquire the lock. Retry the PSC.
+			 */
+			write_unlock(&kvm->mmu_lock);
+			return 0;
+		}
+
+		/*
+		 * Adjust the level so that we don't go higher than the backing
+		 * page level.
+		 */
+		level = min_t(size_t, level, npt_level);
+
+		trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
+
+		switch (op) {
+		case SNP_PAGE_STATE_SHARED:
+			rc = snp_make_page_shared(kvm, gpa, pfn, level);
+			break;
+		case SNP_PAGE_STATE_PRIVATE:
+			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
+			break;
+		default:
+			rc = -EINVAL;
+			break;
+		}
+
+		write_unlock(&kvm->mmu_lock);
+
+		if (rc) {
+			pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
+					   op, gpa, pfn, level, rc);
+			return rc;
+		}
+
+		gpa = gpa + page_level_size(level);
+	}
+
+	return 0;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3005,6 +3181,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ: {
+		gfn_t gfn;
+		int ret;
+		enum psc_op op;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_PSC_GFN_MASK, GHCB_MSR_PSC_GFN_POS);
+		op = get_ghcb_msr_bits(svm, GHCB_MSR_PSC_OP_MASK, GHCB_MSR_PSC_OP_POS);
+
+		ret = __snp_handle_page_state_change(vcpu, op, gfn_to_gpa(gfn), PG_LEVEL_4K);
+
+		if (ret)
+			set_ghcb_msr_bits(svm, GHCB_MSR_PSC_ERROR,
+					  GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
+		else
+			set_ghcb_msr_bits(svm, 0,
+					  GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
+
+		set_ghcb_msr_bits(svm, 0, GHCB_MSR_PSC_RSVD_MASK, GHCB_MSR_PSC_RSVD_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PSC_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 1c360e07856f..35ca1cf8440a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -7,6 +7,7 @@
 #include <asm/svm.h>
 #include <asm/clocksource.h>
 #include <asm/pvclock-abi.h>
+#include <asm/sev-common.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
@@ -1711,6 +1712,39 @@ TRACE_EVENT(kvm_vmgexit_msr_protocol_exit,
 		  __entry->vcpu_id, __entry->ghcb_gpa, __entry->result)
 );
 
+/*
+ * Tracepoint for the SEV-SNP page state change processing
+ */
+#define psc_operation					\
+	{SNP_PAGE_STATE_PRIVATE, "private"},		\
+	{SNP_PAGE_STATE_SHARED,  "shared"}		\
+
+TRACE_EVENT(kvm_snp_psc,
+	TP_PROTO(unsigned int vcpu_id, u64 pfn, u64 gpa, u8 op, int level),
+	TP_ARGS(vcpu_id, pfn, gpa, op, level),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(u64, pfn)
+		__field(u64, gpa)
+		__field(u8, op)
+		__field(int, level)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->pfn = pfn;
+		__entry->gpa = gpa;
+		__entry->op = op;
+		__entry->level = level;
+	),
+
+	TP_printk("vcpu %u, pfn %llx, gpa %llx, op %s, level %d",
+		  __entry->vcpu_id, __entry->pfn, __entry->gpa,
+		  __print_symbolic(__entry->op, psc_operation),
+		  __entry->level)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..afcdc75a99f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12371,3 +12371,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_snp_psc);
-- 
2.17.1

