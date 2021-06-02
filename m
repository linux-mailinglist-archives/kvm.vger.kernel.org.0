Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD09398C30
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhFBOPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:15:52 -0400
Received: from mail-dm3nam07on2076.outbound.protection.outlook.com ([40.107.95.76]:3297
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231765AbhFBOOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/ONCllHpZe2SZUtiv0PdBI24gECKimv8M1GRzD5LRMdXo/I0eTE6tzSpgYxvLdkv/K4iuwlFYcMEgZvEgpm4FgzaNeO24o6qFmGAnqULblJq2mqqtft6VLxldrR9roemUVnCFv0veNS4qcXZ7mbZazW1H4wPvgx7/eK+2xSiMJbz9IW4gWD24Vu3BhbASfTIBRemYfDd5UF+bT9ElASdEZd8ZtAJgZcz7P9BLRacqbUxZEZWze/EWZKK70OM6CPbCwT85/RmyunFlPZp+j2HzcHeLviVVWngPm7P+72I4wxIiXuz24409G3LVRqBV3WyEe0H6qgpUo6lv97+fIyRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVtWgC7hpGHszr+GQ7wUzkkLKdRLKB2IIVX9lHAB/tc=;
 b=Hx9scSvcSITHGPj453PhRhGZySCBjFYaLPGyDRgoZ3sfa//0/sar4YjHPBxWo9sOnGlg8CuW3Bob3rbH5ewB8kYN5LlMxRf/NTsh9TGqdL10n0d7QaPUoMsDUPQNWMgr4nA/LK3ujXY+L9CXmN3q1BkSNd7ICT0q7MLhX0lZDlrE2aW3fZvn2W0F2Sphcs3hh63+OwWcTL4k1K3ppsnPhowJ6lihjuf6ddWrdJ1W1O1GTbAsrcPswSN4hGWVz1BO8YZOhm7oH8a+I9gXnN0Td3m3mvPx2hnwUz47K+pst/ErX/bwDmjfI3tdayRbuwECe8om4m7+VWKOX7TwiOizcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVtWgC7hpGHszr+GQ7wUzkkLKdRLKB2IIVX9lHAB/tc=;
 b=Rydro723hNpC7EPHNsG3fvBcAtZylRd0Z5A4VVnwkeUUWm/Kh/fPxttUFmibCFmYeAf6Qrs2oyJqUfttrwCeIJV51x8XXK+sXHGn/OqFHP9BPzpv+ZndwdceT6HAqPxRGOmn+0toc3glBa8R5zS73k3A1+hmSMjLEOVuRa0r7A4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 14:12:37 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:37 +0000
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
Subject: [PATCH Part2 RFC v3 30/37] KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
Date:   Wed,  2 Jun 2021 09:10:50 -0500
Message-Id: <20210602141057.27107-31-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0319594-6256-4db4-7d92-08d925d0676f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB457456D2B3EC606205FC6995E53D9@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kpCSXD9DbZ6BrJgltix/JyRFdbOzkHkhFgTvYb9xSP77LVSqrijCbI9y4ZzWlaodTrx6BvqsNiPjCeWomVlq9/GAaIi1RwnC53g0C0FLoOCWZMb2yxykBYUwyP+k+JDvVFSADJtwZAxGGUyrnmXDSd6D2xOBV4heNzsCanPKPcSGImEUpn6mPLrsAqbGUp5nclmo1N7lEg6z9OlQcpnYiWEn7AGFMxOBZdyPFapQDHNCpAuzh90/ghKp+DjjqtUlEPHmdgcC9usMMFyrC64ElAqXJBPWRRgv+wxJfHtA/ta1b1VTCmlvw5pTW3OAfWQf9jjdzjc+13ZiAREBwiR3qRw/0uzhcOE/XIfjqKICj8NSdc11TZaZdrqJXejXSKVOSxPH+1X8xKkD4ju/oW365x6Zg/xZLKMhQWq8nu1zD14oBGzE7GatQ5x+Hcg0GuHtlSKAZqnlpCItfE0aDjdGEod3JH2t+3bX4knwTd2ovKqGFsiUygl+Gr3lGj/16fjGDPhI3wMUWbSNs3eYX2z5vnsBUH40Ll9u0rMjYu44U7NYgTGf+5ofjk2uLsvKcOhZwbvpbDm06or6PskbzKwYgo+gIhqvH8QpzVr6boSScwWRzyHI7o/7OzbvN54YkzFFNgrQIywADjauIsPZPGQGUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(8936002)(7696005)(52116002)(956004)(478600001)(2616005)(66476007)(66946007)(2906002)(26005)(186003)(16526019)(7416002)(4326008)(1076003)(316002)(6666004)(38100700002)(38350700002)(66556008)(44832011)(83380400001)(8676002)(5660300002)(6486002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9cUbvnfuRL7/+TeXrjCU7HYsRogvTNxAZHfYDPhnkS2MgYq11jg8GXbQNOzQ?=
 =?us-ascii?Q?1VvlSO/bkk1PEcvPYDlT2N9STB9dTl6J4C5mdkilbt0qsrGQQj5byYyDjAa7?=
 =?us-ascii?Q?CII8VkVLw1BsRp2IC79+yolUC4MS3oVV8RX26qE6bVsqgJjbZ458dxIl/tIu?=
 =?us-ascii?Q?FkAeG2mB03FfxK3KSQMhmgCSw2tx+3Q7iWkUFf9BuX5Wl2lyNGx5+qrl4RL8?=
 =?us-ascii?Q?500q5oZqZ3QqZ3OsoOvbOILUmV8nZ7WH+PvVTUUo5GpYC0JElYCYUnH22BuE?=
 =?us-ascii?Q?RkV5YErfxTpAXFu5DF5rHrH2CIeMGf9SbXxpotNxp3TiD4PDx9VwyD1FJE0G?=
 =?us-ascii?Q?CNDuMNeFwi3M9sqAPl2W051tMB5VZt/kHeEDoj0PjqngpkWNjpGYEXkws+CE?=
 =?us-ascii?Q?q+iXP6N1rocpdIfAhrnx8DZOuACJTdF/nWg6j0RlNULbSWTSuhCMhaE/GC1Z?=
 =?us-ascii?Q?Tm/MFpnyRZyXKJsypmQOG280u4TUhbpaXN+GuzctSOSveeTO98vie9VGsY4x?=
 =?us-ascii?Q?xxzrCQp0YT+DEOW1VVa84A2Jxi9/F13E05dvMm6MpTSKrkgVtPJ+eqb901e1?=
 =?us-ascii?Q?gCBpJob64Gc2UYup9/Jbusw8npbaTnjSGyZpVVhe1+kJYB7Eq90JJSj+nw8h?=
 =?us-ascii?Q?I84OoupvNdtp/YtiGQOmkeiPzIU7519avQiJKL7Etct7dIq2RQ7FOlho2mDh?=
 =?us-ascii?Q?BdW1V3G+2D4LIsSOfHo58MLWTDuKzy41N39rlM9MXBh/WwmktsqJtaO04RAL?=
 =?us-ascii?Q?jCOKy7BnW8a17YdkhuV7jCM/FU+Q4rcdWAlFMSANWczkJdH1HYMmevrvGhWX?=
 =?us-ascii?Q?21KTDTZwn6DMyMfdhSlEGHO+7ltXtygRYqbSvWDb2ZTXIAKTV041/F00Ab4h?=
 =?us-ascii?Q?HCxfe/zY76M8Xv3MC4yyCfZYJf37Kfq1LCZDztZENAqvIdmoZvF+kQEW32Hj?=
 =?us-ascii?Q?s4rybzleUV0YphKRHQ8MfkEf7YPnDcAFDmReCcrN4mCEFX3WH/EbfRbPCYjF?=
 =?us-ascii?Q?EAjudtQkv8Cf8MbuEvAAKOtr6NBIG3u5DtPAVmCzFfvxneYSa7QD1cI1KBs8?=
 =?us-ascii?Q?TgDx283KGQCrcJzqCEnzQxv1MDnpckwytwHkZgqkTWLUCMbZkRZz/YUmqZpK?=
 =?us-ascii?Q?AcsXL9aWgCi/z9Vw1vsoN3nS6L7bkHH+z97GQpcKLcCb9sgYMW5B477yfTUy?=
 =?us-ascii?Q?utCFJHW+Pdak4o9Hgt2ic01xpy7xjvp6gFfDI2sKh/wodKkry3U4W1MsO3nl?=
 =?us-ascii?Q?6aRv8FQZZA6OqP/Ys1jkc3O+5FMuiORxW79kf3f86az4xQ7sIOO7PnVn2tDT?=
 =?us-ascii?Q?wvrfuXHBUGWIfV3REUmuQF14?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0319594-6256-4db4-7d92-08d925d0676f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:07.3937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4av2C5RhpCDbYWQVtRqNRLJma9PB2t7bPh20tsmgdBOR4591hmC/RmupUWykzB4ddlhENNbFJy/JBV8KF2I67g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
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
 arch/x86/include/asm/sev-common.h |   3 +
 arch/x86/kvm/svm/sev.c            | 141 ++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index e7c6ce2ce45e..ed417340ed42 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -82,6 +82,9 @@
 
 #define GHCB_MSR_PSC_RESP		0x015
 #define GHCB_MSR_PSC_ERROR_POS		32
+#define GHCB_MSR_PSC_ERROR_MASK		GENMASK_ULL(31, 0)
+#define GHCB_MSR_PSC_RSVD_POS		12
+#define GHCB_MSR_PSC_RSVD_MASK		GENMASK_ULL(19, 0)
 #define GHCB_MSR_PSC_RESP_VAL(val)	((val) >> GHCB_MSR_PSC_ERROR_POS)
 
 /* GHCB GPA Register */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 81c0fc883261..dac7042464be 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,6 +28,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "mmu.h"
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -2821,6 +2822,127 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
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
+		pr_warn_ratelimited("Remove RMP entry for a validated gpa 0x%llx\n", gpa);
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
+		pr_warn_ratelimited("Asked to make a pre-validated gpa %llx private\n", gpa);
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
@@ -2919,6 +3041,25 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
+		/* If failed to change the state then spec requires to return all F's */
+		if (ret)
+			ret = -1;
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

