Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF61347ECB
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbhCXRGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:06:25 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:51654
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237226AbhCXRFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNAW+QHBYkyRWXf4W6Vn00BdcBvsVxh23hERaYv30nLVWFh26uUQ9fGNShJ14W8V/Rb7l44/RipqFJTgnjz4qR6Md8zGcrhmjT4lYE7LC1/jP5+NqqN3wcEgedKtDPDtMtSo2ChYA+YXjGKuUbLSI+c9jjaht8+9kIK91TB8CNTA9J6Ll1m62LxT61ImFUFD9bzNxHYQvbNrwwyVI3dnlm75XJl6hAtQYsDh0EeSeQLjg0QPhIZumDC4M1a/kiYkw6Pq6+bEjAompoXLH9XA8BfAGODfIWqfCXPEK9MJZ2rnj2ScFvnA9cyCF/ix8NThcmHdkRcgT2C8Zfmd+vQQoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7x+N0yGmpF2otih8SQhYfsdXYY2z8SzCskGptcGBbOc=;
 b=Mt4057975D83dCIj3PCemUlz3i3N+Jk/CTG6ay2gFvCdJLbW9sZM1Y3FtVrgBYTZB4NN7sw9toKkaz4tTAGTtPKJCY80S/3XkUHDrfjLHqJEyuPlifryk9WUVxtc1DC0nBRgCmaNxrpCHTjPD/M7F0e9UEWPA9++tWqOvC7zQQjLhGiBkiCPPfrxWRFtL3ycmxJWtOWk1ZJlVT/D4orD/99ONMIEKf+zumfUrQMQwhGJWnOPo/aEPtx6HVWDUsApMSgHPYba5bG+orPZZC8nkaoKthgSqwBaZNOLvPZgnv6SmOSRnxHXhNNBFnG6zovL/ry5XW5FQUoyfpB0kdv64Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7x+N0yGmpF2otih8SQhYfsdXYY2z8SzCskGptcGBbOc=;
 b=ukxpg7sevLRGntBZ1t1CN8Ja7KwuyNeGMxQzvOZHCAuxJk2GmtJqnl3FkRVhW4q8YuYcJsB7NvXfQi3xYYiCSxN/1vTXKJ/P0yVMIVHtxK8+MiqpAuCehRcOtm4jpZCsGlv/9FqThbejV2jUzSbXfDOKFQGXT+Dmcw3PHQnsEDQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Wed, 24 Mar
 2021 17:05:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:46 +0000
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
Subject: [RFC Part2 PATCH 30/30] KVM: X86: Add support to handle the RMP nested page fault
Date:   Wed, 24 Mar 2021 12:04:36 -0500
Message-Id: <20210324170436.31843-31-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 89d29cb3-835b-413b-b818-08d8eee6feef
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB441326CC5AAEB7AB20EDF12CE5639@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4V74uXh4qNO+O0s1Z/5E137EbgrBDE/epZLTLH8c1/r0Pu2ozmEaDLuUHq38MhJyFhTQmlnGFQ1qsdgnHjdMms/7CECJ3K3W9O9NNeaTRPX/+QJD9kWEYeuWRefn9f/xmW+4qozjSS3c43gmARUH3/enPfv1Z8MLctow0brT0VaFH+I17hbI0fmxBTPHE+j9gn+fU4hlFLHQnM5PS+vleyHmsguRl9wEldqJhBDRlZrotVA32hQC3tdKJPLzO3MjTom56bfvRsLgF2xbeEbutQURpieQh1daIFJ5sxNFa3tf7tb6LxU00Kl+Waid362fyDNQa4GQ2B/v7W5YxL8Min7ujMLTuzT/KW21qRuLUkXns1B215wU7uUiQvU3+8qIeVJw1ZqbJdrXnMymdh9jlUjlCxCv8wkRtiVASzhms/qxIGgIghHQcHLR+f2991+L8wHl7x/UsUWgzr+Rs197O3R/1zj02IWXooS0MWEbDoSQQR286xlm1T4Bfgc/S07CbKnDg0lGqCEADkQG8uFuv0Be3YzXsR9ukCmQHJ+KteqWLQH/QZ9XekKb9Pyu7y43xen6new2t/LECOLixKY991GALaURCF7f1iVAUypyOD00bm4wJubfaoBbzMEHS2fCrQm/8tecK2bh7jpy3Ujjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(2616005)(6486002)(83380400001)(956004)(478600001)(44832011)(86362001)(54906003)(7416002)(186003)(66556008)(8676002)(4326008)(7696005)(66476007)(2906002)(16526019)(36756003)(8936002)(5660300002)(66946007)(6666004)(26005)(38100700001)(1076003)(52116002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tpEXq/f4RJha6AfyMTnzMvgQFnvRSRDsGbaYHy8LYjiy8jGG+GbVSlyhvYY9?=
 =?us-ascii?Q?NW/+Hw35MtwMD9iAV2iQ1JEjlZ1c2+xm4wmemkOQF0hJV2x81B1bJn1PKII8?=
 =?us-ascii?Q?yN0JpxZma2dcaFxI119/Vw4dUBofnr2BZjpFfnbrfN2y9yz8yCb44sQ0v3y/?=
 =?us-ascii?Q?faPxVlakAnL64mrnrTI3zzL/1LZxSnsnlPWHwf36NgaQZFhlIGnlKejIV6iK?=
 =?us-ascii?Q?Jmb1DnDOsGzBd3yggOyFIW2e3YVNZgnEVEWr17hXIxIOrKSMoKYuhhCdY7K0?=
 =?us-ascii?Q?rCdEjua6Xtkj2ZXKsn/3IWEeKSgjmAEJJCmuUxZ6YxmYW4U3BqY+U6m1ccZk?=
 =?us-ascii?Q?ORSnW52Enk0h09xvhmRMlZsJL7sM01SsgarvUhTtIvnd6Tn+jv2uqzoshZXB?=
 =?us-ascii?Q?dKwU/63K+TEWjpVQAHwEp2wxdQXHTsKdH3jRoJNMXig3SX6PyOHotLonjH8J?=
 =?us-ascii?Q?4/WFXrVVp3byL1u9chplKDv4csDt1TLjySRWxekMGA+rzEDOQimgGOBj64Dh?=
 =?us-ascii?Q?uX9HjUbh1JJ2CHNeIhwMnq7co9SvICvP9Ffu9gws31h7cWA6EVceiTVbHVrF?=
 =?us-ascii?Q?0KywWUchuBz91MESZ3dy2dhkhBDGEV07QzFfTBqehWw4/s2/G2GrNnIiXFHy?=
 =?us-ascii?Q?KZP8AwF6ENPPvfUXr4TZtuNl6VaxQWpi6M9PSnEVdVPnvSanljczRk5g1+Rk?=
 =?us-ascii?Q?of9DI6roZr+pVQEfHe8yJaSbYzlqtysqBViARazWTJzEWeB0ge+qhNhSnm5F?=
 =?us-ascii?Q?SdOdDxKlTT/2ozutlT5ho8ZtGD2GeNWoEB1TFktoMZOipgAGj3Otl7WwVTF9?=
 =?us-ascii?Q?0X7I64Hy3Ik9Hi51/GUDe+SmaNpKlm9YQ7m3CDXDq+M88x0D2mnqFufjhm5g?=
 =?us-ascii?Q?ViL6KB7Eps8c9TuQb3ii6Fbl03mGCkeu7QNnCfFRk5ZBB7W3AvB6ppS0NXmD?=
 =?us-ascii?Q?Yy+S2/+4ncuAYVSP143kv8mHJTQv6r+b8ftarM6wL6Kc5bbz77pgGIlB7jfY?=
 =?us-ascii?Q?4A8HwPnJnoWZdq60k3Cordp+f0KU6IGxjwuZQsG8bL9R4c2muTd0y9mqxik9?=
 =?us-ascii?Q?AmYSNVnFy3TdsOAnj6/uctewQYTlMfdFefaRCugkjjm9SKzHMdxNEw+BxojF?=
 =?us-ascii?Q?p+ccAnX2zQodvuKkjEZsqypB8ftrjizZI2l87OxZ+5gSHHoLCtyVuzT32JLt?=
 =?us-ascii?Q?Zw+oDBSkuPWJnxXYBf5HYTKcm9/gVBUvAH0Dz2jYxukhoIM/ycVvpyv7eVOJ?=
 =?us-ascii?Q?sjSlod0+91j6AR29wdtKBvM/vBFKxfStkfE5UwKYi4BB8sF5KG0fkvLWuxaH?=
 =?us-ascii?Q?lNsFbzAXdSNOB95hez7Dx+L/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89d29cb3-835b-413b-b818-08d8eee6feef
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:16.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4Hny2g9wtLGSEOHlPJQGbVq7/sFK06rut4xj/gaJm7bUiCEkwhfphydeaghuSszTfMD2NP1IID+LmFXrVZ4WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Follow the recommendation from APM2 section 15.36.10 and 15.36.11 to
resolve the RMP violation encountered during the NPT table walk.

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
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++++
 arch/x86/kvm/svm/sev.c          | 57 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  2 ++
 5 files changed, 82 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ea584606885..79dec4f93808 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1311,6 +1311,8 @@ struct kvm_x86_ops {
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*get_tdp_max_page_level)(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
+	int (*handle_rmp_page_fault)(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
+			int level, u64 error_code);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e057e046ca4..ec396169706f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5105,6 +5105,18 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
 
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
@@ -5121,6 +5133,14 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
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
index 35e7a7bbf878..dbb4f15de9ba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2924,3 +2924,60 @@ int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
 
 	return min_t(uint32_t, level, max_level);
 }
+
+int snp_handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
+			      int level, u64 error_code)
+{
+	int rlevel, rc = 0;
+	rmpentry_t *e;
+	bool private;
+	gfn_t gfn;
+
+	e = lookup_page_in_rmptable(pfn_to_page(pfn), &rlevel);
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
index 73259a3564eb..ab30c3e3956f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4564,6 +4564,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 	.get_tdp_max_page_level = sev_get_tdp_max_page_level,
+	.handle_rmp_page_fault = snp_handle_rmp_page_fault,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9fcfceb4d71e..eacae54de9b5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -637,6 +637,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_snp_init_vmcb(struct vcpu_svm *svm);
 int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
+int snp_handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
+			      int level, u64 error_code);
 
 /* vmenter.S */
 
-- 
2.17.1

