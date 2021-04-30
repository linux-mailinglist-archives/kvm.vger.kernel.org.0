Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55E636FAB3
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhD3Mm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:42:57 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:56448
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232718AbhD3Mln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:41:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBP2Xz0lfeU8vihzE9w8vx9MlTc3SjcKxWkHzPVmUldn1HyQ7+8e5ZbWYNjU4EzydUSlgEE1v1MCIzLzA9VTs/VmRCh2jVk8LSS0fDBvuGXM/pU9bxadfbMR9WPHKsw6wX40xmiV4Vj9oFgEqUHXcaGsqT9P7xu1f/mR3Vg4wlaF2quEr988zP9EytLlzWQrZVQMGimSVaShzoPYN4MjgmGAstAkDSnwCMmP2WZe8nWwydsdV0Gkv4kG2Bw40EatjGZpLQYtSvO/D89jFeyNQUxlmMNc0N2tr4t9t88Cvw55BGsnBjZRJTE3OwPn4BdQeArqoFadJEfDgUu0gDvRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDrXWRS0Mr8SyYFVTPmqsB4jVYSoEmKEM7Yrm8+awDs=;
 b=KF8ezqmAIpLe12Zz5hBMl/8db17GViHXeW4XeJGp6Bl+RFJ5tcr++5KcFQrM5YacIGkIrWUTRs+UCsemJKRmOtESOlscNYOvGc9tIaQVWRESUeBXNZuT8P0XrRAAQGhl2F7L4Una1Z/SqPAdPdm7NE8rI1FpOGxFKIoWJ5n/V0rvqRoyQilLch1fZKhb/R6hHZ9TQsmr4oWw9NbkIcZjyT4b7s8Ak5rvDdtQg/8wC5zPKF8eTh1HybBMs4X7Dvq1dLTjb0GiKqJqrnsI1TGsWj/VxuRlFQCgolQwgFx3+cnzQ1pqQBwE4qRegFKWT+9yIAkNDmK61XOKijn/5x0yTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDrXWRS0Mr8SyYFVTPmqsB4jVYSoEmKEM7Yrm8+awDs=;
 b=OslvHGV/doLJ9dVr/wHWdp8HWRbRyxfbXToz4ihqKnnPDOGoIIPzutCT7aoHkrFUBWdkPM3pGb0omg7G2T6/IArtsCNnt7wyEeQjXkvfe+K2zkdwTYWQkGvE/IkEr9PL/kL0IaKsEWIm9oQade96Qzqk7n6I6xOVuZM3Km8htPQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:47 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:47 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 32/37] KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
Date:   Fri, 30 Apr 2021 07:38:17 -0500
Message-Id: <20210430123822.13825-33-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5b0028f-5c4a-4b3b-20cc-08d90bd4f844
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268819F3D73BE3730743D32DE55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+MHFiUq0LnWmSBZCzH50O5zdjD5rZdBFqdWXUAP3NMLaU0FpKXDlaiXVQf4Frdsjo2ojFMTEqkeCxolpOehdNS2H4RlIK88sX0rqsZFlzJ25eLZYDDTRiCLaRa+T59YvtH6aMp2Kf9r6mLNfpyInO8j0K3snXYE0CXtUQ5MCtQ2fUvyjWyrxVgjk0b0hoOfo8YExwxrXN7EMfYxNEzxh8fnNjoqOt9oEi7ydaRdqEd5PKPJCUu8pjeMnvJA9n+zmcdh6Mbj9M7j2Z71bfKt8du8wj9Y0S02A3sHf4t4b8NIW5d4muZktkAPm97+mxBvLB8M7IPMf++bkVS56x03eOr/Fk8HZROqcERj7PhXEGTl6HRkswwLFzeZ2oayA/Ldtjn3uUs+hOMKkq49ZWNXHx7uZnx5rP1cJdcxzI5GHCPWCpTJX0oeAQFaJIgHjN8i/DOa/VLV7JpTLAKzZWG/vWrP/gd09lnQHIsrwBjik4DqIyZTIUVCCd8kfm/iSShXuMbSyuqRWvenBJ4O4TRk15SmBZSGgL47e/QMgCEMazOFEHet4DJPZf+bOMUs+7Cq6dV8fvUwO53Pv/aAF8eapjzLYq04PBTzANaQMx1IODp8iCF0uUPBR8nlXLv6COOyjpG7OOV/J8jSQHO8Qv4orQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?latTE4Oqbsbfrh/fBpa6RMZGNObp1X97ur8LBEC7bqNqouVE7aVbAGUjd/h0?=
 =?us-ascii?Q?MGH5IbNnX0rponG83BzkYRI04GqBOqfXhPZaCCL01hx2cbA0onm5AYCxd1tD?=
 =?us-ascii?Q?xK8rExBSrbhDT0pxyHijhfGF7xW/rQPdmLYmnHfJ6h7wlxNB4ONiH2xWCxNO?=
 =?us-ascii?Q?rJ1OPSVrp2sODavXHI49suTpXAHObvaH8wyorO2b7w1mn2LHII2j/q8Qd/NJ?=
 =?us-ascii?Q?cdfXoYAeLOEdel2NXStosxLL4GJOIPuQRy82A5WQWvMVBf8b1fiyAUd3MmWJ?=
 =?us-ascii?Q?CQVDwgH3ekjYlzyzLSja7BjbsxTdCNeZXBrzP0zWaigfGItzZV5VGkw5jCWF?=
 =?us-ascii?Q?eMGh82En+oO+8n2rUQZeiAnoyVjGkdE5wb29gG0XviYSxpy9TBZjgi58fdZt?=
 =?us-ascii?Q?LmuArY7gVcuNCyUHiG7d0xMxCGwqIdol3QNQZ4Mst8oXENjJrp5qMwWy5zLP?=
 =?us-ascii?Q?D+/waIVhIGp5fPnPc4EnqvtYLKEE3L3o/I3LlgUFuFp1fJ4eUD54Fe1ngFmX?=
 =?us-ascii?Q?crnMZHT5Ze1bxPX09cCI9XUL1FXGVG5m3Y6siDftlGOHMGXoVzZTkv6W2bSD?=
 =?us-ascii?Q?n8g+y9T77H2+C0W0xVLHJOH7S7pgCE+CMZ0U2TNVbJfnn7tusOboD8Ot9oVZ?=
 =?us-ascii?Q?z+slVM3W0DET4xwW5yKwJBuujrirKjT18wBxg5opGz2bamE/OoKtn6vspMb2?=
 =?us-ascii?Q?9BHAj+uXtGacjjodXXsAsov1CEsCg+S0MRriJvGBZldmp8SGNAIkIBw0w7nd?=
 =?us-ascii?Q?96RiaxaNAoCbHifxbncrsBDDfBWkmfJoA3+QJriPH/s7EVMZH4rBOTRkSnIP?=
 =?us-ascii?Q?hXzHwphZvUvKdIvDDntrbNWHAK6+i1U8rQHUUqxS6NMGKsRXXy5sQXBR4xJV?=
 =?us-ascii?Q?kZVPpkcYvbkxy0NuuGWpy1b5Eb2Svh71G2p/y6d3WYhR9AQm3E816U9t7sjg?=
 =?us-ascii?Q?9NmyArSvr6PyHCmgnBsfC4WZ5NvK2zHD9PCsrfgbePtK36B4+K50CXgIJ1yK?=
 =?us-ascii?Q?LjdfCQph37Bv4dEdw+jRUz3enaFwU6M4AflwsF0BG2e7Je5PRfQ9uxPxEbHV?=
 =?us-ascii?Q?rk1jwG6EzhF6nQo17hVaATGuDhC37ePndZLIuLbiBIoczwZhJz4wvcqajZEW?=
 =?us-ascii?Q?CedKzgq6Ts7BrGHTaeDVUeV0+XtVzSWm2u88Kssiy/N4N8SsjA7BiF8ObdfL?=
 =?us-ascii?Q?zx6uWi5WLeuUvDL5yPnAVgAu2tqkWTrMR5eVaUgx6Adt/2ftdx9kFii2LU9R?=
 =?us-ascii?Q?H12HKjBe3h66qGi5sC0Db13weMb7D3hBOz4z3FDiFrxFE7J5O2n1jlnO9kc/?=
 =?us-ascii?Q?Gd4g4Rw+AJ7yBpNJ6iQzejz3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b0028f-5c4a-4b3b-20cc-08d90bd4f844
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:17.7441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h04ze2wofgefGNcqH+h5O9FXP6ofB1Ej1JMlkn6QUHNjgbP0vqQ6LVORe2X8ujETHpviMs2BML+l2OI6HaUYZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

Before changing the page state in the RMP entry, we lookup the page in
the TDP to make sure that there is a valid mapping for it. If the mapping
exist then try to find a workable page level between the TDP and RMP for
the page. If the page is not mapped in the TDP, then create a fault such
that it gets mapped before we change the page state in the RMP entry.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 137 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1cba9d770860..cc2628d8ef1b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,6 +28,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "mmu.h"
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -2825,6 +2826,127 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(struct kvm_vcpu *vcpu, kvm_pfn_t pfn)
+{
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn_to_page(pfn));
+}
+
+static int snp_make_page_shared(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
+{
+	struct rmpupdate val;
+	int rc, rmp_level;
+	struct rmpentry *e;
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
+	if (!e)
+		return -EINVAL;
+
+	if (!rmpentry_assigned(e))
+		return 0;
+
+	/* Log if the entry is validated */
+	if (rmpentry_validated(e))
+		pr_debug_ratelimited("Remove RMP entry for a validated gpa 0x%llx\n", gpa);
+
+	/*
+	 * Is the page part of an existing 2M RMP entry ? Split the 2MB into multiple
+	 * of 4K-page before making the memory shared.
+	 */
+	if ((level == PG_LEVEL_4K) && (rmp_level == PG_LEVEL_2M)) {
+		rc = snp_rmptable_psmash(vcpu, pfn);
+		if (rc)
+			return rc;
+	}
+
+	memset(&val, 0, sizeof(val));
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+	return rmpupdate(pfn_to_page(pfn), &val);
+}
+
+static int snp_make_page_private(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	struct rmpupdate val;
+	struct rmpentry *e;
+	int rmp_level;
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
+	if (!e)
+		return -EINVAL;
+
+	/* Log if the entry is validated */
+	if (rmpentry_validated(e))
+		pr_err_ratelimited("Asked to make a pre-validated gpa %llx private\n", gpa);
+
+	memset(&val, 0, sizeof(val));
+	val.gpa = gpa;
+	val.asid = sev->asid;
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+	val.assigned = true;
+
+	return rmpupdate(pfn_to_page(pfn), &val);
+}
+
+static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t gpa, int level)
+{
+	struct kvm *kvm = vcpu->kvm;
+	int rc, tdp_level;
+	kvm_pfn_t pfn;
+	gpa_t gpa_end;
+
+	gpa_end = gpa + page_level_size(level);
+
+	while (gpa < gpa_end) {
+		/*
+		 * Get the pfn and level for the gpa from the nested page table.
+		 *
+		 * If the TDP walk failed, then its safe to say that we don't have a valid
+		 * mapping for the gpa in the nested page table. Create a fault to map the
+		 * page is nested page table.
+		 */
+		if (!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &tdp_level)) {
+			pfn = kvm_mmu_map_tdp_page(vcpu, gpa, PFERR_USER_MASK, level);
+			if (is_error_noslot_pfn(pfn))
+				goto out;
+
+			if (!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &tdp_level))
+				goto out;
+		}
+
+		/* Adjust the level so that we don't go higher than the backing page level */
+		level = min_t(size_t, level, tdp_level);
+
+		write_lock(&kvm->mmu_lock);
+
+		switch (op) {
+		case SNP_PAGE_STATE_SHARED:
+			rc = snp_make_page_shared(vcpu, gpa, pfn, level);
+			break;
+		case SNP_PAGE_STATE_PRIVATE:
+			rc = snp_make_page_private(vcpu, gpa, pfn, level);
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
+			goto out;
+		}
+
+		gpa = gpa + page_level_size(level);
+	}
+
+out:
+	return rc;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2923,6 +3045,21 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ: {
+		gfn_t gfn;
+		int ret;
+		u8 op;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_PSC_GFN_MASK, GHCB_MSR_PSC_GFN_POS);
+		op = get_ghcb_msr_bits(svm, GHCB_MSR_PSC_OP_MASK, GHCB_MSR_PSC_OP_POS);
+
+		ret = __snp_handle_page_state_change(vcpu, op, gfn_to_gpa(gfn), PG_LEVEL_4K);
+
+		set_ghcb_msr_bits(svm, ret, GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
+		set_ghcb_msr_bits(svm, 0, GHCB_MSR_PSC_RSVD_MASK, GHCB_MSR_PSC_RSVD_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PSC_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
-- 
2.17.1

