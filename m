Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289AC36FAC5
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhD3MoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:44:08 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:61889
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232089AbhD3Mmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:42:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrcWAQIA5qCUy1ii6RiGFLDL4C5i1v0StQYb1NH0ul5r2sgk8HboHt31jRDjYJbaoDrFkxQEL5hEY2g9CW8suuiZSSOqWMby+Q19dLv8ga0GsRihy9sPxi81xKnZdngYHnpeZdVwu+05xililSZq5BrtLtznbPShZFf88CxzfVxi4E5qqUrTpaFkGEnrfGDRmWef6n1uJxFkZDtm3kNP9EQcLwvytG3o+87IK1k5tllcBxhEOQth9MYj/5ayULiLlaon8lGfT7PzhZmg5O5Lu0j/if+6+Whw+ZuLhnXhfSYUc0vcTxl3+VO7SM7FPOmDv8Y6zoA+r6ezHOErJBCRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqTJ+4/ex3MLgKasUoFpH6uDaj077AlYKXy7A24qtZ8=;
 b=dcN3OqYfX0Wc/i/w5pQQ0lzqXXPQ7tvyG/tpj9GYDDO6HEDvb1qGnxCyZZTQDarjISaBkx7y3AjwrBi2jWv3Y1tKWk84e9Aw08Z7HV0PUgRQl3viI/QDl6TCjIO/v4Ttca1yutf87otYmLNsCzD74kxy01gHbn7AsCkB9mnyFpwxyqU3fveulhgH2tDPhyN/TASRNDepEq01P8L1McE97rre7YRHh7W6X1mZUBMr6HPeDdaq3ZHmtgTV1zUCxuXGKwewY9tRXR2faJUcmyI6X8zpPAQxInzCV/HDfvHMLjYQ5BXTDb9F7FOPLFPDLfF/JACwgqPpeCLDEmECmTMLvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqTJ+4/ex3MLgKasUoFpH6uDaj077AlYKXy7A24qtZ8=;
 b=EkuIco5t/+Tf6Q6zDo74B/abKSglELRsRsVlWW8P1IxuoeNppMtKUzFG1A1Sxs9FmG61kJtIUuRJtK09Ykox4jgzM31A+eVxZjW6I/GY7D2G4cTwhUi7NDXHhKuQ7k4FUVB4BMK95ukDQMka7v61NCnXg8NP4nzXvknWU9+MBwQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:50 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 36/37] KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
Date:   Fri, 30 Apr 2021 07:38:21 -0500
Message-Id: <20210430123822.13825-37-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60b8c46a-73ac-4ba6-2947-08d90bd4f9f4
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26884EEC133265C93CD69731E55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUMFp7ZRCdbhutaRd9BBC594w72tsEqYnHPUdfvQd4RAYHmTv6AGfVC0dm+08BGnb+vi4ThwhP9+ame3EVsPGgmMpxappGyj8bLII1utHxtxpOQYeTUDMdFaz/4H+Uj2WPYFlCdcdF9ByW2gIK5RObywCigYebgoIzBQ7diOlJ6tnorONZjDh1jTHQnGYDKFlbNrI+ruyxgpwOkBmcd5DmT8ycHPZhX8AKcwuXt5825vssJZoHtL9Lp40iaI9PfETHVb5/VRSD/DPB+xPlS7YzQuIgUddCwYqp+9qkHcccszgsNYehzwRD8oSXkxROEItrwMDO1o8rNNjfk7X6CM2l/wkzKIF9c/5ADg3JuF+Sr8jqnmo4vQaSVcHB4wBwYVUjQLcqjxoLmaw31nsooxDPvlpqTB3ZXtw/CMzy0ZBke9SwnROLQoS721ViL6GG05x3RqD/3GhvcgMo0Zqbn3YUcP3gph58llSxo4KNu/gwfmEOoJHb+Crn25oDnmxP29z4Ik+tstMG8VIR1DkLT/qxOqpl6feJK2oVKTliNvwuC1MWixZ22vFOtuDi/mX8CkvyjVteqZhLfEcdmpKrZtj18YR4ZqWtrV4HI/iwxkdx8ghJsR4VNDVslrvdO5rxFcR25zuTdsrJQ8mzjmhkSmLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Swv9rZhmgFnc0SxzwWNDbPuk255SdUeIeXg+kboZ5lVU/OPk/yWD+Jn1phOl?=
 =?us-ascii?Q?w5cDZQYmwgDa1duEAV/fc7bTCTaeCiYu4FWuArXggWAePQvXYWGtpWx9bnu7?=
 =?us-ascii?Q?HTAnNp/Y0fdR00tbdpuvCoK6eg1d0ny9w29d+YX/AR24GZoNDE47EWt5ddEd?=
 =?us-ascii?Q?Sin5A0yM4Gsbb54q8oZVsE3JTfafCmKAKf9r99kETn/jO12VJ0noAx9iNsIH?=
 =?us-ascii?Q?bDyvXIyxw+Ob4kB/E3hhREsDSRa5zpDAY5MuZjlcj9nTddYyz7eIAZHu77Fb?=
 =?us-ascii?Q?IYQwDepR6gEjq7g0DOIsjA3Ole0pnqmar8bWmfjlslppbGMNBCz42fC3NxFs?=
 =?us-ascii?Q?ctPyEu94UC9OipQEdfypYGY00mdrOcbsOiXXJKCBBs3taC0Ik7IpQlor4AF1?=
 =?us-ascii?Q?UB0WJq1HHDDV20Us87QMZXs7sRdtT/UOMBlWFsPJ2qC/km+1UjgnwP+SH1rQ?=
 =?us-ascii?Q?UlZLigN33X+d1fmDV1GX3QYOjLQt/PPYByPff5SekrewR6eqliQnOmUSjqDH?=
 =?us-ascii?Q?mom+/Qm/FFvMDN4Kkw4pJfbUdIMqkLT/SDqzsxD3jn/sRjuGRvbfnJn3xZJB?=
 =?us-ascii?Q?y4/Zke8XGhoT4H7Y4Z+U/yOwppGvW8mFY58uqrXTyzReAzGQ+TZwj7PmVn0C?=
 =?us-ascii?Q?2tcWPVV0TL9pkB/Mf/KzK/PjiupKD13NKUMhGBOk872lAsJvqf3hhQ0zkUm4?=
 =?us-ascii?Q?hofAI5YoKogf+z6c+RHtiIKptVPVXv43JzYrbrfVLyFVW627CmZjTrHTb7y1?=
 =?us-ascii?Q?kcsK+hek/AFuGf29GpGMYT1nc1WVQFIhxY3KzFm7wFM0czJfww6i9Eb9JhOo?=
 =?us-ascii?Q?DAOlGCSydTTbnewg1udAU7S4lz5c9V5mPeO4bC01XeI3eeNEmqhbatmBDg3Z?=
 =?us-ascii?Q?jo35uQQbhU4r2bGYvLaLCkiD7Sa/j0ibEaaOqy/t3jUZKv0XtXBwIjaitTFX?=
 =?us-ascii?Q?OPx9kOaW90tUvnZHfSUiSZTwBHi9B+cOcJ5/uc91j0rasNjeUcoKo7T2YgUG?=
 =?us-ascii?Q?2MYxOwTKLAlrIzPPby8WfdxJn7Xa+edPIf3n0ylsdP5Exeum95d2Xwc4bFuO?=
 =?us-ascii?Q?4SZtclJqgEow9ENEKLeBX4eduliGGgpv3O9nrR92xNQwqZ0U6JNSHXJer71c?=
 =?us-ascii?Q?x11mUmvWHSG/AvypGLAsic1H/fQayiPYO74HR9FbJk6a48a68M6jlLvD1AC7?=
 =?us-ascii?Q?1Yi2ua3pq45cgwhghB4x3IoDM35ikfemxWaInOBcHE4QpUmf0LEajvIajktG?=
 =?us-ascii?Q?yuJHl8IBzVtQB4CyQkr0Yk/kTD3NAmy88Ti2PFgaPG/SGbwmbyy/HdR5VnGW?=
 =?us-ascii?Q?gEHZe7OwMZYoRSXO0gsZKDEP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b8c46a-73ac-4ba6-2947-08d90bd4f9f4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:20.6145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GvnWTv4rf1p5NNbbhyd6Eu103rp+7f/dhbOONAB3UctuHHQi1WuE3jvG2UeBy+R+TykUof11gzLM23/W/Q05g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
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

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 106 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h |   3 ++
 2 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8e4783e105b9..da4158da644b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -18,6 +18,7 @@
 #include <linux/processor.h>
 #include <linux/trace_events.h>
 #include <linux/sev.h>
+#include <linux/kvm_host.h>
 #include <asm/fpu/internal.h>
 
 #include <asm/trapnr.h>
@@ -1517,6 +1518,7 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_snp_gctx_create data = {};
 	void *context;
 	int rc;
@@ -1526,14 +1528,24 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1601,6 +1613,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (rc)
 		goto e_free_context;
 
+	/* Used for rate limiting SNP guest message request, use the default settings */
+	ratelimit_default_init(&sev->snp_guest_msg_rs);
+
 	return 0;
 
 e_free_context:
@@ -2197,6 +2212,9 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	/* Free the response page. */
+	snp_free_firmware_page(sev->snp_resp_page);
+
 	return 0;
 }
 
@@ -2642,6 +2660,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HYPERVISOR_FEATURES:
 	case SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE:
+	case SVM_VMGEXIT_SNP_GUEST_REQUEST:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2996,6 +3015,81 @@ static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm, struct g
 	return rc;
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
+		pr_err("svm: guest request (%#llx) or response (%#llx) is not page aligned\n",
+			req_gpa, resp_gpa);
+		goto e_term;
+	}
+
+	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn)) {
+		pr_err("svm: guest request invalid gpa=%#llx\n", req_gpa);
+		goto e_term;
+	}
+
+	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn)) {
+		pr_err("svm: guest response invalid gpa=%#llx\n", resp_gpa);
+		goto e_term;
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
+	return;
+
+e_term:
+	ghcb_set_sw_exit_info_1(ghcb, 1);
+	ghcb_set_sw_exit_info_2(ghcb,
+				X86_TRAP_GP |
+				SVM_EVTINJ_TYPE_EXEPT |
+				SVM_EVTINJ_VALID);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3245,6 +3339,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ghcb_set_sw_exit_info_2(ghcb, rc);
 		break;
 	}
+	case SVM_VMGEXIT_SNP_GUEST_REQUEST: {
+		snp_handle_guest_request(svm, ghcb, control->exit_info_1, control->exit_info_2);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 011374e6b2b2..ecd466721c23 100644
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
-- 
2.17.1

