Return-Path: <kvm+bounces-20278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 444339126E5
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6D551F24818
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 053EDDDC4;
	Fri, 21 Jun 2024 13:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hpCbVHBm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FB6EEDC;
	Fri, 21 Jun 2024 13:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718977442; cv=fail; b=lyMs9Dz2kKv1/raCxhdDALuBJloJJs0DeFo/XyvtkXXIeHKk1twV/WdDoooLyYOa5ep/bw6wZouXNkJIHE4zWa+eg8/qyEPQ8We0FenNxJ/l1dv6CCPEXkhjKheika3+kGRWD7sM6RHpGWRFJ8Qcx/n/ufoZlFxMz44Swu8x7Ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718977442; c=relaxed/simple;
	bh=bmnFMGNJQVjQPw7W1CaDu1frGLMTAZ7nfYHgTswjyZI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bRSxVcGrCMGnz6yxweMMHAqCLTAHG+EM/UDOsbbrNY2Y8N8qjjWXgUkTR8s5yS7BteOSaq7F2DqVlhXPMx8m6Wr1Htggmzad1Eb72rbL37gdM0TuPG8dZAdcNkJ1FBbGER+J725rAae0eaZvW46/lzc8BFbXkPyEKovIP/XU0vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hpCbVHBm; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xd2Kx9DsEsPOsdFOObOjb8DFkPHX4uB4Zx3KHH1h8m+dyPFuMuukNudTHokjj50ce0sEfn9y4VvQy0ts9ktn3pp9Fkuy0HKwUf+7usBUW55bWGxJDXNceoYBRV9OCB3ClWZNq4C9jgLDaEzkRFmh8fReh5QEenC8GHvC1gw/F6cW9wlESQcMqoIWazriR+KUwkodEnOQYHSluXzT9Minu+z4qtCLZETtzDTvYAMqZDgTo0scG8Y3fVtd/8S9fmh6+RjZEwgL8/MqOLCYTFlwm+lrgeyZEUzt9n2rEe3qVT1urgcya55Ab1utsF/dJa2AYkZmXc8dDlen6yo3Jt6BKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fw5JP6mVkUJ2A2g82QQ77MPZ9l+2MMau0DOigE3Eptw=;
 b=kNq9iP6/wWP1IrwhtjVcv047Hyv7PhZZi0TgVK1FxLIS9zoH1SjNTUkL1WRE1yyn2COX1RHhVJbTB8Zb1tdARpgJKkf/77MSX/6eJ2a8LPa1kiHdY4q+HZzgwB5xSnOgMCw9eOYZOIqiiTJymBiOpQIMs68y8wUGRgUw9YEikJTExopkQ+w/POilCs3PoqE61Vd8kyW338W2vOgPW6N9YuTqwcqaTu2J6p0mVbkWlav+19BlstEKcftgx8/aXIRum1rDmlYwpt4JI9h7d7cromkF3i+1BH/4qHS3eBnfwyIbWahXyWIFINmTvpG6xLfopmd3MjTyTiGdj0+e+lve7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fw5JP6mVkUJ2A2g82QQ77MPZ9l+2MMau0DOigE3Eptw=;
 b=hpCbVHBmgB0mP9o8X6hyhxg7dcGP6H8cpPVGVwGUE/pRMFYbeibE+pZyBRln3ZLJdomCEI1WTEgc74rpe4xh7qNMnkJoONJtRX+jiDksM+WgfCteyh5NiCoTo//DQsnLpLb5lDYwjNhdvvBp9DTNICu6smrGVubTjYvTMkot7QY=
Received: from PH8PR21CA0003.namprd21.prod.outlook.com (2603:10b6:510:2ce::14)
 by IA1PR12MB6331.namprd12.prod.outlook.com (2603:10b6:208:3e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.18; Fri, 21 Jun
 2024 13:43:56 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:510:2ce:cafe::b9) by PH8PR21CA0003.outlook.office365.com
 (2603:10b6:510:2ce::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.14 via Frontend
 Transport; Fri, 21 Jun 2024 13:43:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 13:43:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 08:43:55 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, "Alexey
 Kardashevskiy" <aik@amd.com>
Subject: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Fri, 21 Jun 2024 08:40:37 -0500
Message-ID: <20240621134041.3170480-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240621134041.3170480-1-michael.roth@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|IA1PR12MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: 26b4d2da-b40e-4d0a-4607-08dc91f83251
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|376011|7416011|82310400023|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O/zAd+YxLOpqWqHH8p9/EFTt0NTBwgHYKjEwOvjQ9v+6TMdG0QIcaOV5g3rt?=
 =?us-ascii?Q?qMeEJgggkV0EA/h7mTm0ahOZx/xICSFxiacKLkMjuhQMKTvCGYR3mAQ2eJJ1?=
 =?us-ascii?Q?8LwAzWzErhtQQYJhPJK0WWtpA+9Ezv3xbXH+Moh0GGsIBFYyK8juIwRB48lU?=
 =?us-ascii?Q?f3qVvtWA0NHTQrb4Jq7Ozn+DYbtCcpWPLb0t3hJm460yr+DnZEmkCHx8wl1M?=
 =?us-ascii?Q?LLXnxRJkWsycwpgbw0lSPdV6fQdV2R/LtKGU9DnNREdabz7TTVsil3Cv2zrh?=
 =?us-ascii?Q?YZQcmXUDDd4hqieKL2GhT/AorM9osCe3dBpTALv81A4qCfAAMZs41tEDJnOb?=
 =?us-ascii?Q?rP1ng5x0Vkm/SyYLxcotbUH6GntoqGwEWXzCpSbh7g2iYAAX6XZD34tvmNhp?=
 =?us-ascii?Q?nKmZs+g7g6d32WohHDHoSBzvvJZHv5fn5FJy90Uk3CR+p84Zi1bdPMTOwxgb?=
 =?us-ascii?Q?7qw0G66ZcZcpJk8sa4W03RiL2LkWVTm+kZ/tiRmXrBqqRomQEulfZiFZMw5q?=
 =?us-ascii?Q?f4spCoh99s+z3XfMHNkeRsAztIBPYeXODzLfML0JlsK2xMjMKbQXWpyfwI96?=
 =?us-ascii?Q?D1urBfZjURiwmHTbIgki+7BhVFLqEFLfaXJObqxevPYd362mZUzIsEKnPDNW?=
 =?us-ascii?Q?ncZ8KmNqJMH+lc0P8PuOjwydseqqIlKpgvAv3bcfT4/pt5+2Ezn7qG19kWnB?=
 =?us-ascii?Q?vQm753+M7cwKMAYG7CVmoWaZ178gaGynRM7kThEWXLHMylCdwZEcAMAQ2tGD?=
 =?us-ascii?Q?F6BX6CkGrakZ90G3WIrtw47FF4C3sppNeFUQ1UzeCXRkOTJnz66RnH2kYq+E?=
 =?us-ascii?Q?e6jeHhL66o26KR49NUoADgrRIKoq++dGSPQptpPL6Lc4x3OQWc+uiCVI8sIC?=
 =?us-ascii?Q?wNMZXnfqYO77x6SvOd74L6wZl7/qNQZgWK5scNANE6pTB/ymmQHiu0wpMir1?=
 =?us-ascii?Q?c2aSps4f/Szrc94j52Dqq8VHpA6R/h77YY5rht6TXHKnqGK15TZPoVdcSgjn?=
 =?us-ascii?Q?EEYhZyF6KZ/fi3gzhOJfPO+THlPR8EB1xOC/U1kp72T6rNquIl9cbe+kOw3P?=
 =?us-ascii?Q?4zwWOatPq0wnh4O1FzRCJQcAL31fhbqo8/LoBUkIsuMtiDw0GR9kdJ39xe1o?=
 =?us-ascii?Q?3EhUsGWgXReq/ii2EUw1gHWlHqsy7mJJa538gtSf4wvDNYXNfXa3aEWWLvoP?=
 =?us-ascii?Q?3n6hmu3WWl9Sco6qKyB44MYVDsRnaUurIYoZli1NgrlY96oiLoCADs+iCfNq?=
 =?us-ascii?Q?VEKsc7zzXeT3I7boFqljK6kAGetX66QEgtylfkV18qF/Y9oS2OC/CGUDzdMI?=
 =?us-ascii?Q?f6gr8GEAlgkoxl0QsEVz1Hd5na0PX001KnQDyym4Ar62y3yiaZO7nHE9NdaH?=
 =?us-ascii?Q?vXfVsGE9Nk0dRJI4PokHuQDssp6epX+Cm58TqQTwesfIgMtqjg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(36860700010)(376011)(7416011)(82310400023)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 13:43:56.0621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b4d2da-b40e-4d0a-4607-08dc91f83251
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6331

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
 arch/x86/kvm/svm/sev.c         | 69 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/sev-guest.h |  9 +++++
 2 files changed, 78 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index df8818759698..7338b987cadd 100644
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
@@ -3939,6 +3944,67 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
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
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
+	if (ret)
+		return ret;
+
+	/*
+	 * If reclaim fails then there's a good chance the guest will no longer
+	 * be runnable so just let userspace terminate the guest.
+	 */
+	if (snp_page_reclaim(kvm, resp_pfn)) {
+		return -EIO;
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
@@ -4213,6 +4279,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
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


