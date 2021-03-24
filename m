Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AC8347EBA
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbhCXRFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:53 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237057AbhCXRFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSQQpivSXDWSsjZVkEkPAuzs63+GW2wcPkSvIbfnkLMVuFfDwCKg0J6z8/pqGDPDy9fmxEK9ncDu00/GIcUMcjS3V+7aKAOLfk+0cj06K4GeR6StT/pu9wLSKYDZMfKyU6DiDX4XCa5lcZgwNc7CIuFHeRF7eMrROaZlGEmgqwriNIAToQuMQfrPb1VbVsU5WpIjAE9AwxQLB+2lM3xGSNrpOS0FRA53XbuYP+A+y6YdT+Uyb584voLCbiXfZatSAXcbq7cD541HnH1PAvwLpDE+w4GTHVnw5LGFTMHJ2GxMwAb5FAgVXEhx8U1kscOu10vx9QDfqU5Rg/xflMKd6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEeQVYXvtWtNQ+zNaDBS4s6QtTIRTEqfNIi5bXd9meY=;
 b=GsmtvsLw4lg1+/MxqdzfI6PhLcyPluxr/rzHTkuH+a5movJ3jHt1Zd1lD4cWHMdjq7DmtVFMRVhKsN/YFP+mRz2ySHekMv2eyeYfJOswJCqMWQhruL7ehlnd3wTkiLP6nMcuE/hmAGByfQeHxUOf2DeCdjTKleysQ0Cl3JcLUL1EGe9Y/LBKQy3aUwljOg8CsLBBWW+f9Nzu2O1XmFRSx851eN5goEApJOMfPxbYrVdjzOCDQWsTKEtTTeLThEFiVNb3fbYdTSwbOg26rlvbZSUre6jXmCMi0dqfrI7PwsNlEu5F/EwuZiJo7ugxg7SzMCy02oVt7j1YdkQvPNeSmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEeQVYXvtWtNQ+zNaDBS4s6QtTIRTEqfNIi5bXd9meY=;
 b=WrjxtaicxZCGDPdDMpwuzVys3zDqRKpuQ9+AT+eyyfr1YBPyDsBt+BKR9j8fLmsoblKjjAhSlorvNO9IJAHxyBD+T/EoHomHtIeppGpqwaHARgY31DvQgKPn0syg7yrC/7yCbBFqaVmM0uJrvxOH6XP4y00ZYungIHzHRoW7upw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:07 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:07 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 19/30] KVM: SVM: Reclaim the guest pages when SEV-SNP VM terminates
Date:   Wed, 24 Mar 2021 12:04:25 -0500
Message-Id: <20210324170436.31843-20-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 16fc2ff5-b5da-447c-1f5d-08d8eee6f93e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4382C41383319E8E58AB03B9E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZjWH/hMH0ykAAftn6j0VqPHfkjAcd5HcEY5ojGKaYcnHltY7CC+4QrCjl/agvZOXFxQHjZ7VF/ItO9a4rlB9dCOZ1WdBRd0bLv2fw59938/DofKQVPDMJNt1H4FuYZVXugliSOinkt8tzrzDL2051fItXRWRe2g4SlK/e8Fd85LMjReWbv3M4YT4q+fHJL3uSi8DHaH3vqh14M3Tn49b5fStBPT+3htVf+QCCrByygHut2IbBBR2EZVla6ETGV4pUrecML/X0FhXljDv7H6D+fezWWVEvFq1ut6wZbkZld4YBNvY9AMBxYpEl/068FUDyu1HPtxYVlW8CWyKNgoONPXwoIAjMJK90k1A7xUkAaxVAQtgwYMm0bPx2eWhb+cEmOpxzcvDsUmhaf0ULQfQYLVrnhYL2d1C8iTunpXhajlqUNGjzeK3RYjpsQM3v675kCOnR/BhCIx81NB2oV6hW3TzKPsYX43eyQKE0i/75XmabyrCIcnE9SzbpmxAOzOXikSMdE/HuybfDGdiQregCFp9RTkmucfN66w2ON9ZZ9sTKl+bwFz0Y0MnqVzWgTcCsBLRh/SE/FhyigKCUcSgp1KIcecbpnUvU8RptQz1I51h/IQxRYCrq7H0YpXyTaEiQEZLaRGslBpYeakKRf4xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3hYMXxRaSuYpXE9mZ5TCn1bsmUNDCPC8u4fQl2jGupYv1BGmqNItRltcsS/p?=
 =?us-ascii?Q?Jp4xRloX/Az9Sj1ZG6GQ4Mp+4k7Dqoo8uSZnrHqnRP4iT0XHHu+3RncqWihP?=
 =?us-ascii?Q?WcwRXlqsyDbPRF44tC4Uoe4Xl/nitF72OBkIMBA3/wcCLI2XJRkFccTdVLuM?=
 =?us-ascii?Q?qok7ZqSG8lUnFFkK6Kg3eJwmoKwC/vccQy6vpGbd/sdsdTmwXmdodQXqvh8T?=
 =?us-ascii?Q?9Gepx/cfVo48zv34QT73L218F+QObr4fPunIel2PUvzPRF5Z2SLWGQORQ+At?=
 =?us-ascii?Q?eYVTtmQ93iYSXdimAvDzOwBLre1U6YuMdDttyI5skiGzgECcXrZuzchDpCAw?=
 =?us-ascii?Q?I+yYPgSc+K6yQDU4tVd2iot9Lub4YZzQFCMFMFog0rIuu00j233D/QUtqbaM?=
 =?us-ascii?Q?gBvTuQZSPomM6sIkxzu6x0NO6y8qlKOUnhQvCeOrhAcAaBerTgwnsSi8pDkd?=
 =?us-ascii?Q?0DYULQXPYrE9lpTqyf0ER+jak7Id72n62pa0PEnsWdsqv7yOvoprP8TsSU+i?=
 =?us-ascii?Q?H5iCuBR76sK89981RhCtZm1l3e5JY/FC8pwJT9fSyvzxl3z5Xc3Jg1/5tCt7?=
 =?us-ascii?Q?vfMmR8fUJoh1ZpdfXbeKkIDG+pK6eDR2sD4v0O6GgO5UMiN7mgMXpPVaQ2rG?=
 =?us-ascii?Q?X7Eo8HOrcjmbGEU6VHBEwh7RAJlT1r4bKVCOGHa4tkN2Bco0YmERwJdTabRb?=
 =?us-ascii?Q?GozkMQfCS782Bd79qWVEotBXYVeklX7stdRGndGbsDOCGdfKmVrBN66sKv31?=
 =?us-ascii?Q?Tl86bC0ruBK2nn+Njp79SBtiBsJN34NMe6mnDruV7tGGshguUjpA7/tDIY9K?=
 =?us-ascii?Q?jzWryppJo2fAz3kytcSSXscaHy//NiVwItTTBphlFLZqlEgCsLCwtG2hgWub?=
 =?us-ascii?Q?WpmY7++pW/lJXy7k82PuYeTrqQX/vJfx+DWVD1chQS9A2FGsGSGupXWtiHro?=
 =?us-ascii?Q?U7Yo1CVtfm8YuckwwVZ/EMgBYpHBwNaAdqz+tAr9GDZXAt+YDtHLacKQm2Cy?=
 =?us-ascii?Q?VOsHCC4SvK2k/T4oYNAXjL05KlVpKsdz3cuWLABhDEqXRoO4JfxP2U1dc25n?=
 =?us-ascii?Q?wJ5CVb7gy8OcDB5duexVKBSqiPo3vH577/a7ITVqhO1h0+zkaA+QTgPhhzyf?=
 =?us-ascii?Q?TdSxsodbxx7uevZke0jasyPVkXxog7gEae+NFUokj1hmI01tMjlvFAEioFPl?=
 =?us-ascii?Q?6Jtt2mV1b1UQIaMcnsUW1yzW0Rr22GeTl5hgiC07ukljcSTc02yB5sh9yXpr?=
 =?us-ascii?Q?xIRh/0btG8gHFzdSar9d53CbxagEUvBRcfwberKl6FxWbEXS4mhK9+98kjQ7?=
 =?us-ascii?Q?Z32VpzKkwApVN+btzT2M259p?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fc2ff5-b5da-447c-1f5d-08d8eee6f93e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:06.6041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /A/Qghj0EtRGs24EL/jJ9JTMKRd2/ylACAK6hFK8J0BPhz14trRL1fE5w8JFGZ+vVwTIGvkH6qVi0+6ixH2sUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest pages of the SEV-SNP VM maybe added as a private page in the
RMP entry (assigned bit is set). While terminating the guest we must
unassign those pages so that pages are transitioned to the hypervisor
state before they can be freed.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1a0c8c95d178..4037430b8d56 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1517,6 +1517,47 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
 static void __unregister_enc_region_locked(struct kvm *kvm,
 					   struct enc_region *region)
 {
+	struct rmpupdate val = {};
+	unsigned long i, pfn;
+	rmpentry_t *e;
+	int level, rc;
+
+	/*
+	 * On SEV-SNP, the guest memory pages are assigned in the RMP table. Un-assigned them
+	 * before releasing the memory.
+	 */
+	if (sev_snp_guest(kvm)) {
+		for (i = 0; i < region->npages; i++) {
+			pfn = page_to_pfn(region->pages[i]);
+
+			if (need_resched())
+				schedule();
+
+			e = lookup_page_in_rmptable(region->pages[i], &level);
+			if (!e) {
+				pr_err("SEV-SNP: failed to read RMP entry (pfn 0x%lx\n", pfn);
+				continue;
+			}
+
+			/* If its not a guest assigned page then skip it */
+			if (!rmpentry_assigned(e))
+				continue;
+
+			/* Is the page part of a 2MB RMP entry? */
+			if (level == PG_LEVEL_2M) {
+				val.pagesize = RMP_PG_SIZE_2M;
+				pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+			} else {
+				val.pagesize = RMP_PG_SIZE_4K;
+			}
+
+			/* Transition the page to hypervisor owned. */
+			rc = rmptable_rmpupdate(pfn_to_page(pfn), &val);
+			if (rc)
+				pr_err("SEV-SNP: failed to release pfn 0x%lx ret=%d\n", pfn, rc);
+		}
+	}
+
 	sev_unpin_memory(kvm, region->pages, region->npages);
 	list_del(&region->list);
 	kfree(region);
-- 
2.17.1

