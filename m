Return-Path: <kvm+bounces-20300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEDB912C54
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 19:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AFC3B26379
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 17:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50361667CF;
	Fri, 21 Jun 2024 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kGT5EDvJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BCC3EA66;
	Fri, 21 Jun 2024 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718990236; cv=fail; b=mi7qB9h99Rqm+FkyoQmek5F8nuErFoRfT+Ud39+pkw08XI9gpIUEISDUDmHIP3swBKyQu0kbtBBa5XgzjVSM4wtoeoxSRIGNA0KjuZtiMEhi4xqrP7SyIzlF+YKodz9dor3rGcKxnsCJO7KY1+C5n23aBrnOWLXJMw16nhpZJj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718990236; c=relaxed/simple;
	bh=RiSwABWpjKjy1H042hg4qUuqy+dMWuTuNfzwrZyqNCA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cIc+tbxhTwsFtxNgIzregbJvLEz/SiCuEjF6iAusxyMCABVBLUGJepsHjeuqRz9GgfV2mVFol5CKEiVeB32POmQwGR+Pzn1Tx2wJa/zVxqEXfsWBhn25wQbakWTjqTEmKozRBN90XAzkB4CC/YKiyY1AOOlhFMag9vlClAQDhYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kGT5EDvJ; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPA8hAmLmYzPgsLCO2Qc//BXRut0HbXxxalGBL/BUgUz6pDtZHv/vAkcCgMyNrHbwbSQDMdvTeXCa/hDsXwJhfAHH3FOCWczT552mI63RAiUK+Ob09CteeOPobTOg0KDEwDN1eK3/12BIhg9jtum4T1tJ9vTtgs+6tEacHVh0UYx915OCeHIiU8RNlqm48Tmpb5Zo5rQur7bUBfDy70cIT8b5YxG6VpycGD2FjYGiOO9Sl1wSpt/+LiSzOnU0Gt/C1nm34wRQg74Afw9rajiESCmgCIJsap74Z37W7TaRAV3lgiElOwt8AJ5JQTz6WXXcRucBRjFXUWuhDkO8UQq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rfYDoRYg+u5KnxBUwwuzrc58vR6U9xc7UIiaDFABUU=;
 b=gXrA/7E/gy8sq3wM9fl3c+VJOgz8v4yB4atkufSGg/u2qr+xoE8YNcyAZfHUw2/u5vmCjJ5/3uzjxH3y/cQBcjLhd9BmOkbzrsopbls9iEEnhKLsld5J47rw4WHjQbY4s/PU1yNwBkdUA9F3O7EiTnhlW3OjNtSnBmWNr3LCXfaI0ckR/td6BBzDOY/XCxH1hZxOAR/qqIMtwFEGL5DqxzCi6BQ1a40ZQYBSY1JOLhgG91cnZYVG11URj77JxxtEWcyZ+NNUFRyl45VLJOzC7+KIkjXrvwWD/3cJ9FgQh2YoOqRD8YY5+kf7/CXhvGZMu9dcrKTnrHWPss1eOQmn7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rfYDoRYg+u5KnxBUwwuzrc58vR6U9xc7UIiaDFABUU=;
 b=kGT5EDvJYMB2iZeFqfzGZgEXl/2ZA/BzmljNRKGkokX+M9SKkpv4SEqEnyiSlvVVO83uV0Bnn+Foom7kNnrxjW9+7iXSypUJtM0aY6KjFEm2H6/BYj/Hb3pV8CeIQndKwx8nRHjuaAhSJeMv7Qi8Ueo95hlY3k2OSQ3QBcRMN/0=
Received: from SJ0PR13CA0047.namprd13.prod.outlook.com (2603:10b6:a03:2c2::22)
 by SN7PR12MB6815.namprd12.prod.outlook.com (2603:10b6:806:265::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Fri, 21 Jun
 2024 17:17:05 +0000
Received: from CO1PEPF000066EB.namprd05.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::6c) by SJ0PR13CA0047.outlook.office365.com
 (2603:10b6:a03:2c2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33 via Frontend
 Transport; Fri, 21 Jun 2024 17:17:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066EB.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 17:17:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 12:17:03 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, "Alexey
 Kardashevskiy" <aik@amd.com>
Subject: [PATCH v1-revised 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Fri, 21 Jun 2024 12:15:19 -0500
Message-ID: <20240621171519.3180965-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240621134041.3170480-2-michael.roth@amd.com>
References: <20240621134041.3170480-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EB:EE_|SN7PR12MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: b152ab44-9bac-45fb-530d-08dc9215f8d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|1800799021|7416011|376011|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zgb0PIVCLRPAV3mHxkMH7G0t2k97SoYoZ4gtFqaHztqcO0stiAak+trTrhZx?=
 =?us-ascii?Q?WrCu/QVlJqsudDeemFoA+7QNK5H8UtH7bUsdQ4mgYeG5bSQcComB5ZV4zsLO?=
 =?us-ascii?Q?HuRUCUlj5nLJjcqKY/HiahEPfKOUX+06LiBCYuM4ND4AmEMLNY83SYN0OZqt?=
 =?us-ascii?Q?WtA0H3n9ei1utUKkB9jt7FRZyUiDESzVynV2UydFZQkTj6nGE3mQR0iDdOmD?=
 =?us-ascii?Q?dSeyx+BwHuxJTvyusQ9fGF3LWicGppEjT9wGXgUB9ZNBjhANLShMFoLrEr8s?=
 =?us-ascii?Q?WUK1iNETRVdVItdz2BPIwP/l+aPZ1g+HW3Q/3c6D+1ry1eohu8Bi/0RpNgIi?=
 =?us-ascii?Q?8lb/7X2VjlgrmeySuFITIdGt2EwW8U7opvpM63XdTAKgsRdjuHQymfsJI3xP?=
 =?us-ascii?Q?gIwLvvqARdZKd6MbSVBMU1C9E31dGmJKt2dS6ynleFAuPos9jTZQIMQEFnZ9?=
 =?us-ascii?Q?nPvSIngkz7FFpqKUC4aL4kHnR/r8O5Uxn8A8+2YIX989Ul66rKAaRhLQlc5y?=
 =?us-ascii?Q?8wGsNG5tGliUh/wD8ebOKQjsautvz4nG9RdDOJfCOJXHmXRzDYkGZGB4wmPE?=
 =?us-ascii?Q?6oTR8Wk5X3oZZD4E1APt/IzTJBKjqHaYk+fPF5zIZWnOP07+q+U4zchcvcCK?=
 =?us-ascii?Q?5Vl+/PgswDApJjWOd3rOOCtXTQrvydgT6Z+8RE95JJ5rAKE5HY1FJsLh5qLG?=
 =?us-ascii?Q?S38H6xUsO/Z3vbJRcZSvNzM8YjKJKxnB44mdLpLCkVu3lw7ome9BfSRINR5H?=
 =?us-ascii?Q?UWm0McbNCBML3rTCvfkrsajarUNGTj0YYOJ94OX+KOCiXMlcJPsaCOjGDgY1?=
 =?us-ascii?Q?tDf/bpVTwu0Gh32gLZetaFQ2KP7b2zHmh4x1g+/3GjUnBla4ynuMlhAOXVbg?=
 =?us-ascii?Q?0iXSrog1Ptorb0DTkmdoEJ5UzPJU8bFqgaHZAPv1YkrdTbjpX9sQ2SJbnzvX?=
 =?us-ascii?Q?aUOkHygm9TyDbHFWnP9w0pp+f7+DFhgbfi1iJgK2xynXAcubLFNlq0gvWKb+?=
 =?us-ascii?Q?E1EHmNqLKUKkhP296AYgaePwukjZdeWfJ6TMIwPbn5vBmYlWXeHmztgQHrt+?=
 =?us-ascii?Q?mOnQpC8g3HkcLmRi42tdlberbuSFprKFTND1MIjJ/CP7WVgeBSFlb7EEEWaX?=
 =?us-ascii?Q?oTt4jHK7bBVt9ITcZeVa99+lK/QTnsJZhdBikHHejPRRKS5suvnrCLYKxeEZ?=
 =?us-ascii?Q?Fek67Sl6pIrBqMCy+DVMcMCXcoYAas82QDVU5+W2a0AjOSpcLtrP2UaL91gE?=
 =?us-ascii?Q?A6DopVXgXY0gHVop08G+n6Ex0sPMeZ/w51td30RdcvjdkZpfYYpk/If6l3Rk?=
 =?us-ascii?Q?KwrKgpBB3RRf5/KK6oTrZDUxBFS/jAzLglJZsk33XMHPOnR1zcL5Gs9T9sMT?=
 =?us-ascii?Q?Q7d5hPpPNU3buHKFxWNBVpccfof5tv46Nb2hXkbSB30zhnp25A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(36860700010)(1800799021)(7416011)(376011)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 17:17:04.4682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b152ab44-9bac-45fb-530d-08dc9215f8d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6815

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of GHCB specification added support for the SNP Guest Request
Message NAE event. The event allows for an SEV-SNP guest to make
requests to the SEV-SNP firmware through hypervisor using the
SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.

This is used by guests primarily to request attestation reports from
firmware. There are other request types are available as well, but the
specifics of what guest requests are being made are opaque to the
hypervisor, which only serves as a proxy for the guest requests and
firmware responses.

Implement handling for these events.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
[mdr: ensure FW command failures are indicated to guest, drop extended
 request handling to be re-written as separate patch, massage commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240501085210.2213060-19-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c         | 73 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/sev-guest.h |  9 +++++
 2 files changed, 82 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index df8818759698..d9921ea87a81 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -3321,6 +3322,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -3939,6 +3944,71 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
 }
 
+static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct sev_data_snp_guest_request data = {0};
+	struct kvm *kvm = svm->vcpu.kvm;
+	kvm_pfn_t req_pfn, resp_pfn;
+	sev_ret_code fw_err = 0;
+	int ret;
+
+	if (!sev_snp_guest(kvm) || !PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
+		return -EINVAL;
+
+	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn))
+		return -EINVAL;
+
+	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn)) {
+		ret = EINVAL;
+		goto release_req;
+	}
+
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
+		ret = -EINVAL;
+		kvm_release_pfn_clean(resp_pfn);
+		goto release_req;
+	}
+
+	data.gctx_paddr = __psp_pa(to_kvm_sev_info(kvm)->snp_context);
+	data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
+	data.res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
+
+	/* Firmware failures are propagated on to guest. */
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
+	if (ret)
+		pr_debug("%s: guest request failed, ret %d fw_err %d",
+			 __func__, ret, fw_err);
+
+	/*
+	 * If reclaim fails then there's a good chance the guest will no longer
+	 * be runnable so just let userspace terminate the guest. Don't try to
+	 * release the resp_pfn page reference in that case since it is no
+	 * longer usable for future allocations.
+	 */
+	if (snp_page_reclaim(kvm, resp_pfn)) {
+		ret = -EIO;
+		goto release_req;
+	}
+
+	/*
+	 * As per GHCB spec, firmware failures should be communicated back to
+	 * the guest via SW_EXITINFO2 rather than be treated as immediately
+	 * fatal.
+	 */
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+				SNP_GUEST_ERR(ret ? SNP_GUEST_VMM_ERR_GENERIC : 0,
+					      fw_err));
+
+	ret = 1; /* resume guest */
+	kvm_release_pfn_dirty(resp_pfn);
+
+release_req:
+	kvm_release_pfn_clean(req_pfn);
+	return ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4213,6 +4283,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		ret = snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index 154a87a1eca9..7bd78e258569 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -89,8 +89,17 @@ struct snp_ext_report_req {
 #define SNP_GUEST_FW_ERR_MASK		GENMASK_ULL(31, 0)
 #define SNP_GUEST_VMM_ERR_SHIFT		32
 #define SNP_GUEST_VMM_ERR(x)		(((u64)x) << SNP_GUEST_VMM_ERR_SHIFT)
+#define SNP_GUEST_FW_ERR(x)		((x) & SNP_GUEST_FW_ERR_MASK)
+#define SNP_GUEST_ERR(vmm_err, fw_err)	(SNP_GUEST_VMM_ERR(vmm_err) | \
+					 SNP_GUEST_FW_ERR(fw_err))
 
+/*
+ * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but define
+ * a GENERIC error code such that it won't ever conflict with GHCB-defined
+ * errors if any get added in the future.
+ */
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
+#define SNP_GUEST_VMM_ERR_GENERIC	BIT(31)
 
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
-- 
2.25.1


