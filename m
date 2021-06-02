Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B957398C63
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhFBOSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:18:00 -0400
Received: from mail-dm3nam07on2052.outbound.protection.outlook.com ([40.107.95.52]:43296
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232200AbhFBOQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXrreSyN4URmVXvj9DNKWnuq2WyrOcDM49TajfnGkwZW4KO52xnhlyZnyKKdkbYh8bxb+BDPa84MvGRpJiX6Np3NTwOqs9pHFREuvvEG0kfkjSo4O5TQNWUAWWnJp93oVOG0fN//pPv4MWSC7txSgmKXX/yNHIw5QsBxGQzB1HjoJRPV+TQlRflmeVvCyCnpJqHEDiijLKMLhvOBWeJQXJuFIvd9+IDl1MQ784fx8GAYOzV82ew6RbtK5IjZD6hCXEoW6235FKWBLWF8fChJcyT/nRYU7rXa610Eh4IBD0zpQDJJu4SH4fazxicZ8ptZgV87rnikQpKp004Bp4Fn8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLJXcd9y5+Qgm0yIvuFvVVGuI40kkmVzZ3F9gN7qF84=;
 b=iWspw2xKm6by2HQrvVLM94fRuxFneLOImUtFOvxqaEicOErEYC/C67eOEPxrkNt3L5wRBQOx5r52v290jYyTBc93qvleA3XWbrTHbb4IdEgwdxByxuQ46IjFuWkmtfxNjbV4OhNgalluufmbFNWA1rw67gk6190yoWVKIKR0TcjEobAWjYT8CGMO9JW2/9XyGzF0mss8CR+J/SDmungnhL1l9LkGwQTO/X2JRPNMZwTLyIK4zm8SIcBYy4J5rryI7XYBbbR8D4EVKIijzaqJD/43N6ot4DeLDfcjtH9i5SPH5EJQT1UwCJLJ3gPe2Q/6MF5TZqzffvitE7M/uGEQNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLJXcd9y5+Qgm0yIvuFvVVGuI40kkmVzZ3F9gN7qF84=;
 b=z9RbPumaTMn4LClVk1AliefdRZ2pVc5iZu280GENkSojr9XT44exgFU7TCl6EJOAh70O9AZJ5FWprJ3CErj6v1Xjl7sl8TLFvInkijxpZFp4L+rmGA5pPoIXBMDBsKNNteGUjrY2TTPq5eKHs5YK9FL4i4zdQ7v41Wb59CgcK1k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 14:12:40 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:40 +0000
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
Subject: [PATCH Part2 RFC v3 35/37] KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
Date:   Wed,  2 Jun 2021 09:10:55 -0500
Message-Id: <20210602141057.27107-36-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 928cb5a8-7659-4746-8e08-08d925d06b8f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45745DD21269CDC7E4F62626E53D9@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtdBakzDA1pUtHqZVpLs+lr/pSi5dXWot5UvBHOZGNjzAo7l+OS4wTzs/KKg/qX7X8Zm0hnjn6r6tXSgFBrkwcmAWtHfm1DfyW6gcW27Kk/hgPBFLtJkXsj9tMMHamHS2lSIr2NQ/4iDu9AiDr+FlC/Rg23pe0aJTPK2qQlvTm5QB+uh9s8obPWRMDX0qzm41xRx6RQTySuds0kr9nntJBia3HuS7wNla86mCeth46XcSMukguWfe1Exl2QXsItx122E+qpKJvM0NgXwEt5DA3Sxl3ZCVgikNcrtTfajLCOeHrJdflt10Yvrbc5tqrDv3RiL1+22iCjIwNqbx7V7nfaVW6cHFLSjD7AueWL3/h6wETHnf/kQF1O2iutCrGuhdaT4Grupt5l48t0bVd/Y0XO7MB+FULP1lGIIQatC96BnfiyWgP/bs5vn2rVoVY6hUYaQ8492qIstKas4A0RAWOCJetdRFnZrOJ/lzleeD8oLBwLfehPa9XnIZ3+maK/ArFu3B7gxrrOHmbFCGCzhQCyz0l9jCPu/oeP7Fl5bxGL53gbYTjXT1yjXr9VssIjak1MG9PH28IjTyBrL/zGsxVM6qomxH4dsSc5euAK0T3jQRObq/5RdFU+6MGS0jol+GDy/MAtjU+O3pTaquBu8Kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(8936002)(7696005)(52116002)(956004)(478600001)(2616005)(66476007)(66946007)(2906002)(26005)(186003)(16526019)(7416002)(4326008)(1076003)(316002)(6666004)(38100700002)(38350700002)(66556008)(44832011)(83380400001)(8676002)(5660300002)(6486002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zFxqQVm1BkrAHCAkdibcy/pT1hcZPIeg8dVph93YC5ONL5fZnJ7UUMGgmTfv?=
 =?us-ascii?Q?2U+5Fhq2WXTTKSQXhNlb+nNOAaEn9X2EuN0HnUeFociqrEEHEqjwc9cNtUB7?=
 =?us-ascii?Q?BuZOaC56PG058sfn7g8SAF75qZY99o8h+RFXw0w/+mBBiFi2gbyO6BqTaZmg?=
 =?us-ascii?Q?8h7hHni4mRSku1Tfm+XKZB/jSHMiB085zQZLIWf6z6S9iua+FEH0IUZOOIvZ?=
 =?us-ascii?Q?p1T7nMuM1OBnAlT0kvbtJ3GcKGOSHqha1Hqn9SU1OEUlCZsa0Bt8bmYoTODO?=
 =?us-ascii?Q?N0ooWOKDKdOseqK1oPeuaPUm2Zg7syCgfI9OHyarkNtuUKyn09oXWWj5b1Ti?=
 =?us-ascii?Q?N7tim/A1Y/WBcGkMG/OHRKdjxPw0GLkAd6HCTYiRRkAuXKeg50RzptEkF9mI?=
 =?us-ascii?Q?QJsB65s9HCBCn8TSN8lE4RaUL/qEds9NuOWysMBSRZNpIRBy3o2f543lC7sk?=
 =?us-ascii?Q?NtKo4aVj1zLx+haOku7qUcYqqgmkxv712dOMf51R/cKwgrDCoZgS/zDvxcRK?=
 =?us-ascii?Q?GdssK/WwsMjaFLmO4xvjYWDqpS4UPUbHND/f+TujAgkfpHATuphqFISxQvsx?=
 =?us-ascii?Q?R8MJliQ/4pz/aihZTvg3q8q/SQgFjcBKnvSLOzomm9gn3zt7WSeXw3md6mM3?=
 =?us-ascii?Q?q5XSrBKVPLazyX0iQkffcyK0ezXwvehlf3+eYS2TjQNnfPxa8YX48TQUiLjv?=
 =?us-ascii?Q?YKnHenvE7AsM4P5YY1D166y1gUMDupKN9BJTFt7SDaCd6F9KP99gf1bte+23?=
 =?us-ascii?Q?Mrn0/N+a7Iv/0V7g4YdK7+UWdfecoPRPgcysBaOK3wBDjppRNK6D+XeRq30V?=
 =?us-ascii?Q?hxjDnYBGU4z+X59HSjEhT+R8EN1QqYJ7kicbi9IC/TB8SDpkAbb04vdcEZf8?=
 =?us-ascii?Q?4Bs4RkHU+kfqsNnZ2vyhL2PrS70V+oBadVWusXzq+G5E6TxNIIfAWFC2bmqT?=
 =?us-ascii?Q?ivvJyd9TXniCGcUpb6n2Nb5wMog6/2LvyaHnjAh0szlMG6DRvfX5l4QufqXm?=
 =?us-ascii?Q?fTQT2qdxQbxjvLDcb7qNnoqyyLYmHV6pQQ8PXAK0h//JHWLXkZkwYWDbtl/a?=
 =?us-ascii?Q?VUKWuI21nH6668WDnPJqSw2BkNJ6BuCvVQXfo5MnQyaDaPk6FeMf0Y58Lfoe?=
 =?us-ascii?Q?GCPvdRjZnxNxxy6tufYHJ5zSifsor6kTviJfHbmuIgaEGRz6X3Q5aW3j2tVa?=
 =?us-ascii?Q?FaKTDGq9ukXusWw0vL4OcFa/1X+fgdhiyVjB12etILupb7LFdfurcjzYJQb0?=
 =?us-ascii?Q?pJecGEK7jwyxiPaH0s+eCk/H/SN6B6qxbnxfmQRgYe/FouDA2pDxEVUpxU8r?=
 =?us-ascii?Q?0XumfaBUJZzWzgk591HqPhkm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 928cb5a8-7659-4746-8e08-08d925d06b8f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:13.9680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMWXx808hVBKwjNY11hwaFNvsGOqJoAzVbooWegpHFAcjgnp5t3ufeDVtINsolMlO8103O7o1DNS+6kIclhZ1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of GHCB specification added the support SNP Guest Request Message
NAE event. The event allows for an SEV-SNP guest to make request to the
SEV-SNP firmware through hypervisor using the SNP_GUEST_REQUEST API define
in the SEV-SNP firmware specification.

The SNP_GUEST_REQUEST requires two unique pages, one page for the request
and one page for the response. The response page need to be in the firmware
state. The GHCB specification says that both the pages need to be in the
hypervisor state but before executing the SEV-SNP command the response page
need to be in the firmware state.

In order to minimize the page state transition during the command handling,
pre-allocate a firmware page on guest creation. Use the pre-allocated
firmware page to complete the command execution and copy the result in the
guest response page.

Ratelimit the handling of SNP_GUEST_REQUEST NAE to avoid the possibility
of a guest creating a denial of service attack aginst the SNP firmware.

Now that KVM supports all the VMGEXIT NAEs required for the base SEV-SNP
feature, set the hypervisor feature to advertise it.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 101 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h |   5 +-
 2 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5b033d4c3b92..5718e2e07788 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -18,6 +18,7 @@
 #include <linux/processor.h>
 #include <linux/trace_events.h>
 #include <linux/sev.h>
+#include <linux/kvm_host.h>
 #include <asm/fpu/internal.h>
 
 #include <asm/trapnr.h>
@@ -1515,6 +1516,7 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_snp_gctx_create data = {};
 	void *context;
 	int rc;
@@ -1524,14 +1526,24 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!context)
 		return NULL;
 
-	data.gctx_paddr = __psp_pa(context);
-	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
-	if (rc) {
+	/* Allocate a firmware buffer used during the guest command handling. */
+	sev->snp_resp_page = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!sev->snp_resp_page) {
 		snp_free_firmware_page(context);
 		return NULL;
 	}
 
+	data.gctx_paddr = __psp_pa(context);
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
+	if (rc)
+		goto e_free;
+
 	return context;
+
+e_free:
+	snp_free_firmware_page(context);
+	snp_free_firmware_page(sev->snp_resp_page);
+	return NULL;
 }
 
 static int snp_bind_asid(struct kvm *kvm, int *error)
@@ -1599,6 +1611,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (rc)
 		goto e_free_context;
 
+	/* Used for rate limiting SNP guest message request, use the default settings */
+	ratelimit_default_init(&sev->snp_guest_msg_rs);
+
 	return 0;
 
 e_free_context:
@@ -2196,6 +2211,9 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	/* Free the response page. */
+	snp_free_firmware_page(sev->snp_resp_page);
+
 	return 0;
 }
 
@@ -2641,6 +2659,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FT:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_GUEST_REQUEST:
 		break;
 	default:
 		goto vmgexit_err;
@@ -3031,6 +3050,76 @@ static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm, struct g
 	return rc ? map_to_psc_vmgexit_code(rc) : 0;
 }
 
+static void snp_handle_guest_request(struct vcpu_svm *svm, struct ghcb *ghcb,
+				    gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct sev_data_snp_guest_request data = {};
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	kvm_pfn_t req_pfn, resp_pfn;
+	struct kvm_sev_info *sev;
+	int rc, err = 0;
+
+	if (!sev_snp_guest(vcpu->kvm)) {
+		rc = -ENODEV;
+		goto e_fail;
+	}
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!__ratelimit(&sev->snp_guest_msg_rs)) {
+		pr_info_ratelimited("svm: too many guest message requests\n");
+		rc = -EAGAIN;
+		goto e_fail;
+	}
+
+	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE)) {
+		pr_err_ratelimited("svm: guest request (%#llx) or response (%#llx) is not page aligned\n",
+			req_gpa, resp_gpa);
+		rc = -EINVAL;
+		goto e_fail;
+	}
+
+	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn)) {
+		pr_err_ratelimited("svm: guest request invalid gpa=%#llx\n", req_gpa);
+		rc = -EINVAL;
+		goto e_fail;
+	}
+
+	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn)) {
+		pr_err_ratelimited("svm: guest response invalid gpa=%#llx\n", resp_gpa);
+		rc = -EINVAL;
+		goto e_fail;
+	}
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
+	data.res_paddr = __psp_pa(sev->snp_resp_page);
+
+	mutex_lock(&kvm->lock);
+
+	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
+	if (rc) {
+		mutex_unlock(&kvm->lock);
+
+		/* If we have a firmware error code then use it. */
+		if (err)
+			rc = err;
+
+		goto e_fail;
+	}
+
+	/* Copy the response after the firmware returns success. */
+	rc = kvm_write_guest(kvm, resp_gpa, sev->snp_resp_page, PAGE_SIZE);
+
+	mutex_unlock(&kvm->lock);
+
+e_fail:
+	ghcb_set_sw_exit_info_2(ghcb, rc);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3284,6 +3373,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ghcb_set_sw_exit_info_2(ghcb, rc);
 		break;
 	}
+	case SVM_VMGEXIT_GUEST_REQUEST: {
+		snp_handle_guest_request(svm, ghcb, control->exit_info_1, control->exit_info_2);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ccdaaa4e1fb1..d4efcda3070d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -18,6 +18,7 @@
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/bits.h>
+#include <linux/ratelimit.h>
 
 #include <asm/svm.h>
 #include <asm/sev-common.h>
@@ -68,6 +69,8 @@ struct kvm_sev_info {
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	void *snp_context;      /* SNP guest context page */
+	void *snp_resp_page;	/* SNP guest response page */
+	struct ratelimit_state snp_guest_msg_rs; /* Rate limit the SNP guest message */
 };
 
 struct kvm_svm {
@@ -550,7 +553,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	0
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
 
 extern unsigned int max_sev_asid;
 
-- 
2.17.1

