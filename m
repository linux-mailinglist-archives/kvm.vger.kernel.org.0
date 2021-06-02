Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FEA398C18
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhFBOOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:50 -0400
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:27560
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231392AbhFBONw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdLexQJkiOqvgEwBX7TUOBmizO5ThHMgpiyT5MJv8TmbtNX5swrgBESPtBWEfFmFdvVdNU4ogBtQvFmHj7impVH+A5dKNTd6NY3K1ARq8pgZBYViUUI89CoeGd1JCJmGxUpU2k5YIVpc23ZCHnYSf7RT3D043Y8K/C973OU2yEM9yg+XD1wIRF2w7caAUzJ4mUIjdRpN/d37/JUbHlIU8rozHoVl6Vj3TxThp7HSIro85xjfzSZiUA2XTaX7UBYHBisDEyJD41oJDyWQn9ho8m7ayQvXqwfY9HM3KFaBYyM4KeO5PS8YNJg7wCPp4WlWH4g0yq7fGV9vnslpzuj+Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fj30EHwlZ9k9PEPjfuYC35sYctmpeoUpUlo67lH5/OU=;
 b=RYcf4GDtjcFEJmxU1RbsaFeZNyglIl7d3LtXcRikKwYPeSwdczOpqcQ46Ysgrcjcu55Zm8g5IVdVMOp285MsBMR7Kw78zjdp0FgHlNPvr1/t9JU3sPLFi8f3dkajpS9kUQExJUsXQ1cvMPviRIigA8jPUSDhJJKnd0KrqKPa0B3R81Qdt3Vp8ZhF4zV36/5rp7DkTwXSLi5+uzy4MgCOzwuzYijIn45OWpPIAD6Cg2benhz0loU08lUv5OxbRTJJASYIsn6yTgZkIbR7Uo1B2aSd2JeK4YXxL++AwRzvJlRZtohOzodnTpZ02OmWAatcLOtidYfGeKfqsJj2nOQTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fj30EHwlZ9k9PEPjfuYC35sYctmpeoUpUlo67lH5/OU=;
 b=yo7ysLAelDAojnk99Ov1k9PuzNwW9csWwhOSzohSFhWZGX3lVqq5ycehnmMMOpMtu+ihDJWIa0Wfcd8hj1BPxhTAL1ovIc0URYDeiNTgG6RBLXmMt0SYh+M2jSDTCRKOYUc3aXGP82AFq4Q46tm39C4hQXYv4DTgwzZw9a4e+dA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:11:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:55 +0000
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
Subject: [PATCH Part2 RFC v3 21/37] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date:   Wed,  2 Jun 2021 09:10:41 -0500
Message-Id: <20210602141057.27107-22-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37222725-8ed4-4af0-8471-08d925d06057
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45927EBCC2934875EC2AC1E4E53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTmoTivpCjx9ud+u29BpLTPIULWnsMovs9+ygRLrJGTmR9fLW6GqGxTygsvQzvg2TAr5tXmnvWIYNMffGaJfapOrz7lthprdMXg5ahHxHIKBiw7XRwdDtK+4ZHcxZtO91NIAfJeefEQkAhbWc4uCW6RQ+RaoBDcwikRimcPoqtQg34R/eREuunFhi30gEYW2Rlhjp+/Com7s7kz1IsdhgNi/hFJs9Vek14qVD+mPxfRzLifiemKktp2dES03AFhpSLD5l+sk2ihOrU+jkrG89DLWppkKS0sBCCcZAGWILih+C8SxYjMNqMy1lIZxvvaCpzRPNcQ3Ib8EsmoWOZOjhLmbshDeUb1AXTv5S9IHfLzSWq/uUNeZzpVagZNVzI292SYtsXyesxTHiFvmU7ZyRw7k6NEHYeqOy5afwp/yQPnoPumsQGrgMbfFeEPW0+Y21JWWJNUyFAoLN1OcO1fofIDUNfqhU4hwB746f7Su0dPaEjnt4qV8SV8N6rghKCo1EbcMXqbmcD/tvpT+LCjHODYhTtjtugJo8gcOQ/YejhXRX/R8SE09k0JrK0+7VnJSbvmnY5jide8Fiw46u0R4UzzK6R8qoYM0tI7dVrx3K6jbzBlXna0zIh7H3Zg2gct/Ps56m3ZpxBCttD/cbrC6wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H+xF+Gr2Fhm1ZzZ8jv86zVfSLKR4HE/1I91WUFgHiCKvzP9ls7O9dvBSmgZ5?=
 =?us-ascii?Q?rbVtauAtwzD9tHXDUXTv3H8HsG2cckIMqyCGjKi2M547aNY6d3NcfXU82fiz?=
 =?us-ascii?Q?8DLQBogvysyBNxZf1YnAuOuqPOz4Z0WoC6z023mnLC0KBeI1INKYxzthYhUJ?=
 =?us-ascii?Q?dB0+Yk9UEzabvwL7Vt1QLe+Jipme1qwEs/cmfbOQxguwc6rwBaf/oLuUz8Ze?=
 =?us-ascii?Q?8tQKckyvSECr4p9kLjOkge2fCM6gBQ+ymcGzijVfFPpBpyrTTtjtWyqc9LUT?=
 =?us-ascii?Q?I6PDzPxPtRod8oS5AcVWOJgxXEK5h/NzwjaQ2aHLilnU8Xug+obP+tbdyi+U?=
 =?us-ascii?Q?pweYI07SZYRM06mvPKeMJsjKwow34d8iMbaBMrfQzAFSVJJMesxx31ebNxjO?=
 =?us-ascii?Q?jwmVzNykn/OLThb2MLXU9/aotdtELEreM6KRS+U5tOQ2HW5sj8Iy4Dt9mqvx?=
 =?us-ascii?Q?oBzJEhaVQgwm/M1YV+jSG8XS+FRm4Jfp5Fw/3j2ICucgkxfqrES/kEChdO8R?=
 =?us-ascii?Q?RLJv4fKNtvC9qZxQIbdrgs+xSG2xuHkN6twjaxeyskVm5bZsY0pCZ81CmxRG?=
 =?us-ascii?Q?lktdgcG9kFiTA0i97aji3qN7M9q7vscsIw/tdpCl7s1hWvyXsYNn0dILHMLV?=
 =?us-ascii?Q?9Gqr43SXES92Ttx8+8rwCWd++pCfz88KxxCfggnp94is9C7k51hNhFb7uk/J?=
 =?us-ascii?Q?ADzcFCitvyILvsDM1s9HT0lt9MVuQfOOmnKU48ZERbhDXBBor+Ay2tudJ4ep?=
 =?us-ascii?Q?+dDyl1QpKa4TVoBiqYFvsIuaDvOjyrNlB8oE2AV/f0bcsKh1J2nj5jQSF0WB?=
 =?us-ascii?Q?vG/bWWu6JnMFa1Uh+ZVy+qqbZdCd7DGV2Mic8Ecqg1/Tdg8kOsSoLDj0B5Wq?=
 =?us-ascii?Q?HfahN7fONMfZWzwJ6VyqQbLI6i3WuZw7S1OsZeXZPq0sq23f/2GrZ4aDDHl7?=
 =?us-ascii?Q?BiaNDgGgyBwNbasnMuleoKLdF2ogZadTSogNxFNHOgiK4b7PAmevJFAS89/1?=
 =?us-ascii?Q?KBdEI0ZYghSuPSDUX12IX7AQ6Ujm34DzEw4qVQsI/gA9qhytTthOIxOGFPTO?=
 =?us-ascii?Q?HyNycPawPyULmGSMisNoiBLS7H3HkY8ZkJJ8EsanhiLw1EHubhp/431WyT8R?=
 =?us-ascii?Q?TZyvMlS4yXNy3bX9B952Bn0k552E3Ef52QGcKQs0/MJ4YIHEAfXWF3Zkk0kM?=
 =?us-ascii?Q?8V+pFoGXABLAWaiSyzbnytH0z2BRJyBggd8pgRSBSoxIJBEnwro+hC8E2+YO?=
 =?us-ascii?Q?aFHP7r7NhMZDCnV5t1f5TgmY7OR41tHDMlTUAdZQn3woMs2Qte2su1PisO5J?=
 =?us-ascii?Q?EwDCxCk46S+0Lzlt+XLH44sn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37222725-8ed4-4af0-8471-08d925d06057
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:55.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kuF5wglqHlcQc7AWgBs+wNnvCWnQeAspPQs6spmELInT7xYWVA9MrUveioVLarLO/G7To8uLpTTpEJ5wKvZF0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into the
guest's memory. The data is encrypted with the cryptographic context
created with the KVM_SEV_SNP_LAUNCH_START.

In addition to the inserting data, it can insert a two special pages
into the guests memory: the secrets page and the CPUID page.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 139 +++++++++++++++++++++++++++++++++++++++
 include/linux/sev.h      |   2 +
 include/uapi/linux/kvm.h |  18 +++++
 3 files changed, 159 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dac71bdedac4..dc9343ecca14 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,6 +17,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <linux/sev.h>
 #include <asm/fpu/internal.h>
 
 #include <asm/trapnr.h>
@@ -1605,6 +1606,141 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm, unsigned long hva)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot;
+
+	kvm_for_each_memslot(memslot, slots) {
+		if (hva >= memslot->userspace_addr &&
+		    hva < memslot->userspace_addr + (memslot->npages << PAGE_SHIFT))
+			return memslot;
+	}
+
+	return NULL;
+}
+
+static bool hva_to_gpa(struct kvm *kvm, unsigned long hva, gpa_t *gpa)
+{
+	struct kvm_memory_slot *memslot;
+	gpa_t gpa_offset;
+
+	memslot = hva_to_memslot(kvm, hva);
+	if (!memslot)
+		return false;
+
+	gpa_offset = hva - memslot->userspace_addr;
+	*gpa = ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
+
+	return true;
+}
+
+static int snp_page_reclaim(struct page *page, int rmppage_size)
+{
+	struct sev_data_snp_page_reclaim data = {};
+	struct rmpupdate e = {};
+	int rc, err;
+
+	data.paddr = __sme_page_pa(page) | rmppage_size;
+	rc = snp_guest_page_reclaim(&data, &err);
+	if (rc)
+		return rc;
+
+	return rmpupdate(page, &e);
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	unsigned long npages, vaddr, vaddr_end, i, next_vaddr;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {};
+	struct kvm_sev_snp_launch_update params;
+	int *error = &argp->error;
+	struct kvm_vcpu *vcpu;
+	struct page **inpages;
+	struct rmpupdate e;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+
+	/* Lock the user memory. */
+	inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
+	if (!inpages)
+		return -ENOMEM;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	vaddr = params.uaddr;
+	vaddr_end = vaddr + params.len;
+
+	for (i = 0; vaddr < vaddr_end; vaddr = next_vaddr, i++) {
+		unsigned long psize, pmask;
+		int level = PG_LEVEL_4K;
+		gpa_t gpa;
+
+		if (!hva_to_gpa(kvm, vaddr, &gpa)) {
+			ret = -EINVAL;
+			goto e_unpin;
+		}
+
+		psize = page_level_size(level);
+		pmask = page_level_mask(level);
+		gpa = gpa & pmask;
+
+		/* Transition the page state to pre-guest */
+		memset(&e, 0, sizeof(e));
+		e.assigned = 1;
+		e.gpa = gpa;
+		e.asid = sev_get_asid(kvm);
+		e.immutable = true;
+		e.pagesize = X86_TO_RMP_PG_LEVEL(level);
+		ret = rmpupdate(inpages[i], &e);
+		if (ret) {
+			ret = -EFAULT;
+			goto e_unpin;
+		}
+
+		data.address = __sme_page_pa(inpages[i]);
+		data.page_size = e.pagesize;
+		data.page_type = params.page_type;
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
+		if (ret) {
+			snp_page_reclaim(inpages[i], e.pagesize);
+			goto e_unpin;
+		}
+
+		next_vaddr = (vaddr & pmask) + psize;
+	}
+
+e_unpin:
+	/* Content of memory is updated, mark pages dirty */
+	memset(&e, 0, sizeof(e));
+	for (i = 0; i < npages; i++) {
+		set_page_dirty_lock(inpages[i]);
+		mark_page_accessed(inpages[i]);
+
+		/*
+		 * If its an error, then update RMP entry to change page ownership
+		 * to the hypervisor.
+		 */
+		if (ret)
+			rmpupdate(inpages[i], &e);
+	}
+
+	/* Unlock the user pages */
+	sev_unpin_memory(kvm, inpages, npages);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1697,6 +1833,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r = snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r = snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/linux/sev.h b/include/linux/sev.h
index bcd4d75d87c8..82e804a2ee0d 100644
--- a/include/linux/sev.h
+++ b/include/linux/sev.h
@@ -36,8 +36,10 @@ struct __packed rmpentry {
 
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
+#define RMP_PG_SIZE_2M			1
 
 #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
 
 struct rmpupdate {
 	u64 gpa;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 56ab5576741e..8890d5a340be 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1681,6 +1681,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT = 255,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1786,6 +1787,23 @@ struct kvm_sev_snp_launch_start {
 	__u8 gosvw[16];
 };
 
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 uaddr;
+	__u32 len;
+	__u8 imi_page;
+	__u8 page_type;
+	__u8 vmpl3_perms;
+	__u8 vmpl2_perms;
+	__u8 vmpl1_perms;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

