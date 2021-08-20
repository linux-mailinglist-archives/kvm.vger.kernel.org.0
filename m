Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2193A3F3104
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbhHTQGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:06:24 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:48265
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238379AbhHTQES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:04:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNtdheegf3wE8JuydpaXyJQlBXYPveC1kxvhNo/OKpSYl5mYK3C4FObg1NNl2X4ZFit50waj2xc/ScLeaPXYJhI+bHt1FMmWLOaoN+O7JJckvb+Ihqw6GVNPpiQfiMJyx61fK6206/Idn1kcIwGTnd5mBl96zE0BR0Yh2GA+2ObIynXdr+yJPztcX38RsFBT939Og9RW0SznO/780eDN3sT+AODwC3qJgxpPJyZCwLRdAkv/3OxM5dWQntzzS6iuuISWlhji1NFlmWbd/YJs5PIGt8RnlX9AviuuNzhqI6CrC9CSLO3OuGXVlVpKvSgqX6sK0YJNw34J7G1LtVydBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRGZKPT1LVLFSeaxpWyDmwYuCh+rzJbFgCIU4mfQB4Y=;
 b=LquB5KyJ1WMUFCp0qsVKDRaOFdhJ2PIRPS9KsHFZqaozV58MnF18ov5I6obWxFLegl2MkQEtP8KDjJ9FXbBy4GGZAhJoypvntL/n1O6jO/HznM7zgsMKh3iCk+fc6ZIsFggNf1sksP4hdunb5PkHhMRrLYJOctfz2igEQbjn3KecGl//7wKT9nkYA9N4apv7zkfkpXMzdtqr1GpE2YHZYiakxcgXZTOwcb0GCtDGMh3u/pFSOYfH1rgkSk36fNBnBoWH4oXYAjF98sHyeeABIZdcf30i1FjoOtr2MKA4K1B4nRi8IfwbN+FjsSe0sHQLE+Z+WX56am/hAVXWQ26kZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRGZKPT1LVLFSeaxpWyDmwYuCh+rzJbFgCIU4mfQB4Y=;
 b=cPzd20Pyovu0wokBLv8pyZKTV0vv+sAoh5gb4LmxwVyTEipfCI93HCes/a1zLSPUjJr+5LAQwl72l8Aymoi6srNI7+jn8IRq6n5u1ya1N4x3t7Jtyv8wn32iWNEE1xv/qhB8c0Fu02uSIrvn4aSgFaeWaIsdTAjX5ijTVVgYi5k=
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
Subject: [PATCH Part2 v5 42/45] KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
Date:   Fri, 20 Aug 2021 10:59:15 -0500
Message-Id: <20210820155918.7518-43-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 406c1495-5cc7-41d9-610b-08d963f3ac88
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45095DE9C7B21C52C6597464E5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dvnNlOFTrRWQhAwV8djxWjZ6Pf4Jtqx1alO6EzvA1hL7R8dA6iPHDs3qjF2IM0JrHVU+sR5bnNOkG6X5wxvrcgh1Cyz3thHaciL486SRkWjAg6Ygccl30bheSV0jUJdV4iyafGZs6TZDE2yrV8ywVw1yEsSKIZAqjKMWIDP5g9TvD5bdhUPOiz2kPtffUf2uIzGUEqPw/IrO+PgL3Fg2cMwUG+6zQkkii9m6D7TqrKRCRsyilUVQRW1GPQcj9yz57LrARQpD3oTSwE1tP114ArViB4UWyWuXLfJQnC6p89BkA6G6pAoxRTM5mNJzI0Z03aVWALoWhTp8OYDAQkAX98CGnSLrZvQ5Uahg3jLea9BFgwFt5a6dODXwE0Txp6S3JM6ant2G2wW93GDvLntsykKwuyeMbX3B8Ogc38Cw9ky/qQh47LcP0Fnprp8lq67VGhfy3zccIYqsFENSUlbvqvfq0y9vvlMK5exEjsgybb0qj5kUDHLmUfGn8u79od2P/utzFaHbEOpB+395K771AcEfJtABYKaykPeATrXhNmEmflmEgTPHlVH/eho459tFpZce2kdyy1VzaVjik0tFwUfs5at+zgHiUosIEm2yHaGFM51jOYvy/RTG+iTiZHItPEspZsrT0FwUlWbvird54mcifFE23h71q8WDL0LgDq4oIrpHFHusfW6RUOUYPO17vN/DK7R0f9DAyMZxIfpaIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6mNYwgZj45QQINxcyWOuqq1LJwpWWMypdUD2NS9wc2Vi73Yrnx8gw14ul9fi?=
 =?us-ascii?Q?poKXjB2kfXCDX8yGuTczQ5eCES5IQFtxyukbhYq0roWyDU2Kf1rT/q6x5Ka5?=
 =?us-ascii?Q?6ih9Df2aBQqb8BA9r4k5LWwEqYRFn0NSJ0Bc88gn13mMfyUElT/4j2gFY+Kn?=
 =?us-ascii?Q?B0kChleNYu7K2nX+k9x14A5xpt7sUdEzn+yT3CX6js1YXNvSoTnhlRILtgwI?=
 =?us-ascii?Q?n+e+ss01rbP3BaB/A2zrW0SEzAPtaxs+PLZ9yvGRlewujTwg3q28RLfPctPP?=
 =?us-ascii?Q?d3fZYX9KJQmmCaC+4I31+oz+RNcnF04GPX9jqFOWNnTfNNWxd2arpAeA0P8K?=
 =?us-ascii?Q?iC9anyfuIYQSJbZhvrjrNn9I5E7EEWaDOorEn0W5B7VimAb+HvhnO7rr+T9g?=
 =?us-ascii?Q?7MBJ8EiYvLqHAkHxlZwlfNohbgIkx6P7fa67RhYJjmLDjrm1I3/01WdWENsu?=
 =?us-ascii?Q?U5D7KSu/2vqrKPgVQnjm6DQOMBRKkVujhukc8imkHB/ZR4iYhjOaE+yxBYvK?=
 =?us-ascii?Q?sI5cx33lYgjBCMnfTx8+6HxmegqfSfA2pmVxPa81FSeAvaLl4ieD5MGo3mnN?=
 =?us-ascii?Q?vjjcLm1TPJdZ+S2Az0W/w6feTAIWLqDLf66Cbta0N8WqylloV0qmlePND9zH?=
 =?us-ascii?Q?xgOMGVENKzLBKckIZdPiCLU+ESS0S5gZy0RNgZ46SLG4LaH2IVdlflKSWDTm?=
 =?us-ascii?Q?ftWb1wChL4WXlBkC/ouixzdpNp86mCgyfnH4Jmk756+2YGnJsfuc5kzkWb3s?=
 =?us-ascii?Q?OCtOGaGlq7dr3BTwwe/7dDgGwUmx1anP2xeD19emgaqtbqOpe6v/M1BEzuub?=
 =?us-ascii?Q?+HJijMxaEgLldFwSVBfATeqrnUlyLnHFoZ7P8YRS5I/5fuZnSbcS5ZiPOQSU?=
 =?us-ascii?Q?YZahifD6dFUDWtQCtaTM2q3nxWSbSa2iTvF2dGdSSduaDWMzY9B3KG3bgcuL?=
 =?us-ascii?Q?0io/tp0GUJvB/X1H+un7O4xXDqkYSfwSbnn45RxahpySW3PrjWpZs1hXdD+V?=
 =?us-ascii?Q?jZyMLSCH8ly0L7lppj+It9PL+uqmEpMuG2Hjxjgoq0cA3JkpSn2PutzKe/Lg?=
 =?us-ascii?Q?MPLaZl4zZxthI+sFsbAvGsVzkyDsUxcoEcSGDuSeEwXuc+WkXj0tPE2rYqqi?=
 =?us-ascii?Q?C4puHUMuo9CD3cvJsYuJXee08zJShf/S3aJM7Qk1F1sZzcRDXau6EHMtT2Da?=
 =?us-ascii?Q?8VxeUlMRVHLMHKdyivGphZCVDzKZY0GZ0LtLM610ymNCwbYjsASK0cB6npUJ?=
 =?us-ascii?Q?UQmXFILzh0/gblCnQpbvrJwAoOogRANUoSqRTp9QNvcneItU39L9M+AKPcFk?=
 =?us-ascii?Q?FkKwohWlGt36pPYl8Y4WVsW+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 406c1495-5cc7-41d9-610b-08d963f3ac88
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:47.4446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jC1DdN1CVYrJYeoE8fY4sl/8d4eR5JYPRyyPRCGaYTyc+emDIMVOxrYj0HgkI89rqwpCEHI1SkIfNoKP9jBQPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of GHCB specification added the support for two SNP Guest
Request Message NAE events. The events allows for an SEV-SNP guest to
make request to the SEV-SNP firmware through hypervisor using the
SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.

The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
difference of an additional certificate blob that can be passed through
the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
provides snp_guest_ext_guest_request() that is used by the KVM to get
both the report and certificate data at once.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 197 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h |   2 +
 2 files changed, 193 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 712e8907bc39..81ccad412e55 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/trace_events.h>
 #include <linux/sev.h>
 #include <linux/ksm.h>
+#include <linux/sev-guest.h>
 #include <asm/fpu/internal.h>
 
 #include <asm/pkru.h>
@@ -338,6 +339,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 		init_srcu_struct(&sev->psc_srcu);
 		ret = sev_snp_init(&argp->error);
+		mutex_init(&sev->guest_req_lock);
 	} else {
 		ret = sev_platform_init(&argp->error);
 	}
@@ -1602,23 +1604,39 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	void *context = NULL, *certs_data = NULL, *resp_page = NULL;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_snp_gctx_create data = {};
-	void *context;
 	int rc;
 
+	/* Allocate memory used for the certs data in SNP guest request */
+	certs_data = kmalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
+	if (!certs_data)
+		return NULL;
+
 	/* Allocate memory for context page */
 	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
 	if (!context)
-		return NULL;
+		goto e_free;
+
+	/* Allocate a firmware buffer used during the guest command handling. */
+	resp_page = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!resp_page)
+		goto e_free;
 
 	data.gctx_paddr = __psp_pa(context);
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
-	if (rc) {
-		snp_free_firmware_page(context);
-		return NULL;
-	}
+	if (rc)
+		goto e_free;
+
+	sev->snp_certs_data = certs_data;
 
 	return context;
+
+e_free:
+	snp_free_firmware_page(context);
+	kfree(certs_data);
+	return NULL;
 }
 
 static int snp_bind_asid(struct kvm *kvm, int *error)
@@ -2248,6 +2266,8 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	kfree(sev->snp_certs_data);
+
 	return 0;
 }
 
@@ -2746,6 +2766,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		goto vmgexit_err;
@@ -3161,6 +3183,155 @@ static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm)
 	return rc ? map_to_psc_vmgexit_code(rc) : 0;
 }
 
+static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
+					 struct sev_data_snp_guest_request *data,
+					 gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	kvm_pfn_t req_pfn, resp_pfn;
+	struct kvm_sev_info *sev;
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))
+		return SEV_RET_INVALID_PARAM;
+
+	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn))
+		return SEV_RET_INVALID_ADDRESS;
+
+	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn))
+		return SEV_RET_INVALID_ADDRESS;
+
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
+		return SEV_RET_INVALID_ADDRESS;
+
+	data->gctx_paddr = __psp_pa(sev->snp_context);
+	data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
+	data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
+
+	return 0;
+}
+
+static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsigned long *rc)
+{
+	u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
+	int ret;
+
+	ret = snp_page_reclaim(pfn);
+	if (ret)
+		*rc = SEV_RET_INVALID_ADDRESS;
+
+	ret = rmp_make_shared(pfn, PG_LEVEL_4K);
+	if (ret)
+		*rc = SEV_RET_INVALID_ADDRESS;
+}
+
+static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct sev_data_snp_guest_request data = {0};
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sev_info *sev;
+	unsigned long rc;
+	int err;
+
+	if (!sev_snp_guest(vcpu->kvm)) {
+		rc = SEV_RET_INVALID_GUEST;
+		goto e_fail;
+	}
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	mutex_lock(&sev->guest_req_lock);
+
+	rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
+	if (rc)
+		goto unlock;
+
+	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
+	if (rc)
+		/* use the firmware error code */
+		rc = err;
+
+	snp_cleanup_guest_buf(&data, &rc);
+
+unlock:
+	mutex_unlock(&sev->guest_req_lock);
+
+e_fail:
+	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
+}
+
+static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct sev_data_snp_guest_request req = {0};
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long data_npages;
+	struct kvm_sev_info *sev;
+	unsigned long rc, err;
+	u64 data_gpa;
+
+	if (!sev_snp_guest(vcpu->kvm)) {
+		rc = SEV_RET_INVALID_GUEST;
+		goto e_fail;
+	}
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+
+	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
+		rc = SEV_RET_INVALID_ADDRESS;
+		goto e_fail;
+	}
+
+	/* Verify that requested blob will fit in certificate buffer */
+	if ((data_npages << PAGE_SHIFT) > SEV_FW_BLOB_MAX_SIZE) {
+		rc = SEV_RET_INVALID_PARAM;
+		goto e_fail;
+	}
+
+	mutex_lock(&sev->guest_req_lock);
+
+	rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
+	if (rc)
+		goto unlock;
+
+	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
+					 &data_npages, &err);
+	if (rc) {
+		/*
+		 * If buffer length is small then return the expected
+		 * length in rbx.
+		 */
+		if (err == SNP_GUEST_REQ_INVALID_LEN)
+			vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
+
+		/* pass the firmware error code */
+		rc = err;
+		goto cleanup;
+	}
+
+	/* Copy the certificate blob in the guest memory */
+	if (data_npages &&
+	    kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
+		rc = SEV_RET_INVALID_ADDRESS;
+
+cleanup:
+	snp_cleanup_guest_buf(&req, &rc);
+
+unlock:
+	mutex_unlock(&sev->guest_req_lock);
+
+e_fail:
+	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3404,6 +3575,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		svm_set_ghcb_sw_exit_info_2(vcpu, rc);
 		break;
 	}
+	case SVM_VMGEXIT_GUEST_REQUEST: {
+		snp_handle_guest_request(svm, control->exit_info_1, control->exit_info_2);
+
+		ret = 1;
+		break;
+	}
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST: {
+		snp_handle_ext_guest_request(svm,
+					     control->exit_info_1,
+					     control->exit_info_2);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 280072995306..71fe46a778f3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -92,6 +92,8 @@ struct kvm_sev_info {
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
 	struct srcu_struct psc_srcu;
+	void *snp_certs_data;
+	struct mutex guest_req_lock;
 };
 
 struct kvm_svm {
-- 
2.17.1

