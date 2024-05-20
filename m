Return-Path: <kvm+bounces-17803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 247068CA4D6
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74294B20FD8
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990E0502A9;
	Mon, 20 May 2024 23:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FRDgehym"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19A217BA0;
	Mon, 20 May 2024 23:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716246169; cv=fail; b=t+mTlSVmhqT9sD6pqwfaDQQU2QYP7WpsZ3OcQzJgKRZXcjy0gKRxJQvpDLunSu4ctrc+l6NZ5X3kd53pgAOMIvwvZdBR+8JD1RZwcHbFanLofP3Lmi0+ootJTjImBasc26/gR1AgryxbASyW0APRA97gUOKGCopvpeFgxlO9q78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716246169; c=relaxed/simple;
	bh=nB+nHu1nKy3esCOolzf/C/AgfTNx2+SC/bM4gsR8aDQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g1Xa9KCFBdvuaVXwrHloEB0HZ2MKJVxiKMrAgQli+YqwgqfciLk6diTczecjg4YACutsrfq3rAb5kQaRipmRh/u0LkQtHUAPXCor3HCGUVSuTjWw4xEe5LwnfFP/KZCaOF2dgMEUMGG9CDV/R50D9GjQIDuQ84QA0U1TU1jlO8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FRDgehym; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhyv8RhpTeEUVHsuk5RD+7qR4mrpptO6zJj5PjU24r33IataA9ZHH6QwCIvkjvkSVAwd3xgbtk8vMdSk2yG4Eu1fHUcf+C7CcDt8KTBgdYTkZH0x7yoOgMS032zPflGqtePHL2QU3IrdbHNnYzrvZsh1VrHXhNtzwIIBdisySS0r4/yuEAyKhsUiD3erlaASE7kNAF9yRO3+c7ZcpphmNJOQ4b6htjkYx7jDr74sv5cajOaaCikmGPWdrDP23NpRKNmbJq+jKegVntVdgrhfc99mE+GqJU4I4EiJKn0dnMzSo6mS8ug7ZPwhdKcji9/nTtPJKjuYcj+tyNSnPEkHlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Urcqdz+LOYdyXU9d4mbcOyW5fl9c2lnXBLJOHtg4K3M=;
 b=PE7DYiIr1dvALJQjms9vVgHbTjedN7orIC0nTvRsoP2wGSGwClyYqVUjhX69PAqy11aD5njgH/YzM+OEtwsoGkKgM492OOt5kAUAkhr3mkWRKDTjkSBo6TY5KxxMtG7OdCgzrVKO8PPI/IBJ7EB77Hnki4IDouVIju2zFm5HRdrnM0yqdQ/MKS87oyjj0LGaXw5uLRLP1j1p/oRIBQaN34x7OJbrr5hqysQoOzZ3ZgI92F+Jcl8NnAiNQwd3IR9LUNmRyoB5UTszAQgS6jo/K6vNlnSnNX4+bMilYqHN5/JEmI0oPLJaWNvGitRGndruHfM4ebIRufZYSl8Kl1884Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Urcqdz+LOYdyXU9d4mbcOyW5fl9c2lnXBLJOHtg4K3M=;
 b=FRDgehymZq0LKsaESTurYCGHVJ7dZp/dnEfm37TKRql18dx6lICgn2vpZ/0pc0ZSJkjZ2odDA5sMQ5lL8TaHCCVbTOKEUvQWTMLtzffRETurnrRvAwlG1KtIEm1kWXMWFagLWz/8y52reoS6axHAbud8Tj5V5tgbFOGzNV13qGY=
Received: from PH8PR02CA0002.namprd02.prod.outlook.com (2603:10b6:510:2d0::11)
 by DM4PR12MB6037.namprd12.prod.outlook.com (2603:10b6:8:b0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.34; Mon, 20 May
 2024 23:02:40 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:510:2d0:cafe::e) by PH8PR02CA0002.outlook.office365.com
 (2603:10b6:510:2d0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36 via Frontend
 Transport; Mon, 20 May 2024 23:02:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Mon, 20 May 2024 23:02:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 20 May
 2024 18:02:39 -0500
From: Michael Roth <michael.roth@amd.com>
To: <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>
Subject: [PATCH v2] KVM: SEV: Fix guest memory leak when handling guest requests
Date: Mon, 20 May 2024 18:02:00 -0500
Message-ID: <20240520230200.1161826-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240518150457.1033295-1-michael.roth@amd.com>
References: <20240518150457.1033295-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|DM4PR12MB6037:EE_
X-MS-Office365-Filtering-Correlation-Id: a4919ada-8640-47e2-172b-08dc7920f2fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OpY60WlwuUFPwiDBXfLgiHxqHdmc3dyMJK4YJBzMvhkDofWBYpk8ZxixhAvP?=
 =?us-ascii?Q?ej6kcTRrVjT09E9cjOHAaKnIQKPb/GEYf0GuCvuW5EvBo8TDeAuknUBvj4BQ?=
 =?us-ascii?Q?9numK+r4vaa+e9D9bgYrG2+8HQ+lX7VIMp4sykVWGEedXqHeDMlarbmDw1da?=
 =?us-ascii?Q?9tG1zsvzIV3i28HH/vwlGmG9wlKmg7qA8yuT1Bzr33eY9fNrbjlbznGdRIbL?=
 =?us-ascii?Q?Kcudwp2Q0MP5n54RwWLLw48CALHoqTQ27dCZULT+dQVb1gKYvtGvuSDG0qCn?=
 =?us-ascii?Q?OhM/umPG7vba8gfmQEpc7dwbZsSTkmwPWHEbeUMUoHQNPcNhxIVeZlxPzJjP?=
 =?us-ascii?Q?qGUV9RAhCvYk4JLH+nWE1oJSiMUzCWb+bahgYFsExwtm25xzUr+J59lp81Jq?=
 =?us-ascii?Q?GahPRTZ7xRrnewvbKXm4P9I/IOydIDBdxvfsYrRTygEJVTWdUD5IPcilBVwP?=
 =?us-ascii?Q?HgEf65kw1dZyel8IighSBtG8wFkr7Rr2yCfkSkWl2nZEAdAGqwXiBfclWeN2?=
 =?us-ascii?Q?EFeFk5jHhPysNIYqiwyM2i6ih+cUFKslY3CksyCCNP055WjhF/ADNbtDtU7H?=
 =?us-ascii?Q?MAl1yEvN7mMErdEo4QpwyUu7FCtJh1prODprpm56exZq0LETHj+kGJbyj8yr?=
 =?us-ascii?Q?ObN26IgiXR/RpODaXlLvGumJ+dVnyqC6cHZDEjyfgnr8PRflcMyzckzxSJBy?=
 =?us-ascii?Q?0ovs2zO4EMgr+vzvLG+CQlSSZ7u1+BtSC02KpT1hELSQqtOEqKH21G0MEvW2?=
 =?us-ascii?Q?TtDga0iJCaR8AC7K9yPwU96hhBWJrmeG2zZfHA2TNIjdp1knQytoVdFE7t/B?=
 =?us-ascii?Q?2FD1IxE2ZIhQTAXogmVP7arMjE0jeGxODBNWRB732WAxuP6nJhuceykJgUUc?=
 =?us-ascii?Q?8ETzRMHUqqysGye1F0dqmtgz6OxIt6ssliqJ1mrvAELto7kOVix7DuXxJhAt?=
 =?us-ascii?Q?nGnuNImNTmjZWlf9Yu5AP+KQEfEGceaMvHs3n4cJVUzVP6y8vWbxTmoznwUI?=
 =?us-ascii?Q?pP7oRj4z9BTZmIXPHPDNakGu4MB5dN+rHZ4aNItl8NbGAs3Vl8He6L8e4ttQ?=
 =?us-ascii?Q?oSJ3obrkh75flPchfIuHIrYDwJ5+ZLXhRD3R008EoDkwg/TqW4mhvXgh5syW?=
 =?us-ascii?Q?vmT4wCIA2TRiy/hmdf23ODrs8492NMhkLzTbblz9SSftCN+iamSXi36vVO7F?=
 =?us-ascii?Q?ypFJYX3D+atXXjxLpjqXV1FmnlfZBkrumdcCT9K3Ea1gaBEC0R4TequPpKVH?=
 =?us-ascii?Q?Nzbn0giHkbxIBKV4Kcoi2Yz3DOWsuEM4e+n/amyQCnBWSQtdfp6YOwpKuHCY?=
 =?us-ascii?Q?JT2RGN0c0QNcT4OpzG30cKxx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 23:02:40.0792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4919ada-8640-47e2-172b-08dc7920f2fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6037

Before forwarding guest requests to firmware, KVM takes a reference on
the 2 pages the guest uses for its request/response buffers. Make sure
to release these when cleaning up after the request is completed.

Also modify the logic to fail immediately (rather than report failure to
the guest) if there is an error returning the guest pages to their
expected state after the firmware command completes. Continue to
propagate firmware errors to the guest as per the GHCB spec, however.

Suggested-by: Sean Christopherson <seanjc@google.com> #for error-handling
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
v2:
 - Fail to userspace if reclaim fails rather than trying to inform the
   guest of the error (Sean)
 - Remove the setup/cleanup helpers so that the cleanup logic is easier
   to follow (Sean)
 - Full original patch with this and other pending fix squashed in:
   https://github.com/mdroth/linux/commit/b4f51e38da22a2b163c546cb2a3aefd04446b3c7

 arch/x86/kvm/svm/sev.c | 105 ++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 252bf7564f4b..446f9811cdaf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3919,11 +3919,16 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
 }
 
-static int snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest_request *data,
-			       gpa_t req_gpa, gpa_t resp_gpa)
+static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_guest_request data = {0};
+	struct kvm *kvm = svm->vcpu.kvm;
 	kvm_pfn_t req_pfn, resp_pfn;
+	sev_ret_code fw_err = 0;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -EINVAL;
 
 	if (!PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
 		return -EINVAL;
@@ -3933,64 +3938,49 @@ static int snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest_reques
 		return -EINVAL;
 
 	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
-	if (is_error_noslot_pfn(resp_pfn))
-		return -EINVAL;
-
-	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
-		return -EINVAL;
-
-	data->gctx_paddr = __psp_pa(sev->snp_context);
-	data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
-	data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
-
-	return 0;
-}
-
-static int snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data)
-{
-	u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
-
-	if (snp_page_reclaim(pfn) || rmp_make_shared(pfn, PG_LEVEL_4K))
-		return -EINVAL;
-
-	return 0;
-}
-
-static int __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t resp_gpa,
-				  sev_ret_code *fw_err)
-{
-	struct sev_data_snp_guest_request data = {0};
-	int ret;
-
-	if (!sev_snp_guest(kvm))
-		return -EINVAL;
-
-	ret = snp_setup_guest_buf(kvm, &data, req_gpa, resp_gpa);
-	if (ret)
-		return ret;
+	if (is_error_noslot_pfn(resp_pfn)) {
+		ret = -EINVAL;
+		goto release_req;
+	}
 
-	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err);
-	if (ret)
-		return ret;
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
+		ret = -EINVAL;
+		kvm_release_pfn_clean(resp_pfn);
+		goto release_req;
+	}
 
-	ret = snp_cleanup_guest_buf(&data);
-	if (ret)
-		return ret;
+	data.gctx_paddr = __psp_pa(to_kvm_sev_info(kvm)->snp_context);
+	data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
+	data.res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
 
-	return 0;
-}
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
 
-static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
-{
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct kvm *kvm = vcpu->kvm;
-	sev_ret_code fw_err = 0;
-	int vmm_ret = 0;
-
-	if (__snp_handle_guest_req(kvm, req_gpa, resp_gpa, &fw_err))
-		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+	/*
+	 * If the pages can't be placed back in the expected state then it is
+	 * more reliable to always report the error to userspace than to try to
+	 * let the guest deal with it somehow. Either way, the guest would
+	 * likely terminate itself soon after a guest request failure anyway.
+	 */
+	if (snp_page_reclaim(resp_pfn) ||
+	    host_rmp_make_shared(resp_pfn, PG_LEVEL_4K)) {
+		ret = -EIO;
+		goto release_req;
+	}
 
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+	/*
+	 * Unlike with reclaim failures, firmware failures should be
+	 * communicated back to the guest via SW_EXITINFO2 rather than be
+	 * treated as immediately fatal.
+	 */
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+				SNP_GUEST_ERR(ret ? SNP_GUEST_VMM_ERR_GENERIC : 0,
+					      fw_err));
+	ret = 1; /* resume guest */
+	kvm_release_pfn_dirty(resp_pfn);
+
+release_req:
+	kvm_release_pfn_clean(req_pfn);
+	return ret;
 }
 
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
@@ -4268,8 +4258,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_GUEST_REQUEST:
-		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
-		ret = 1;
+		ret = snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
-- 
2.25.1


