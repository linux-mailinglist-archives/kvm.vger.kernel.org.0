Return-Path: <kvm+bounces-15443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7393E8AC09E
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF9CC1F21184
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A843FE4B;
	Sun, 21 Apr 2024 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TyI7gEWU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A583AC2B;
	Sun, 21 Apr 2024 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722971; cv=fail; b=lcDR7U69Uiq6QBk8zabVb0DOeJZ5qDWkDkm1H8vWF8+DIsdkJ3fuM1Z5Xp3p0OcxRfZYHtcLwedyTj67CRqCej8M6e1fuPq9MBI/FkdGszjg1Q5RYVBIhUps7ZS//F1Dyu+xkPwXvrCn9V8xPYPq7ZCGPG0aYRfr023TdwXUGx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722971; c=relaxed/simple;
	bh=pMKa5IcwzEoMzog/AhhX6W71dGNHZd5Om3r4C1Llpj4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PdlzwGRHphv5Ti1pnOVf/Wc/dnwAsrgNne3kbB54ZjXKbNPgPQAMY5te4la7MxC7sughim1qpUDvUnOlG9i2TKEXvlriPHkHSauHxHhjsu5lH7ze5qVADvStk47wE0UnFrF5nGGtwpat6f//1Vp85KlzLuNFtV7eSNkVfDZq9DA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TyI7gEWU; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFjkivabxXx8qtNwWxwbBn1QAc1+sgmRxpJ/Hn2kpKH2aNH0odV1z32nm6m0q9qHLIdR7bGstjayBKGhJGAgiEQS6R9ZM5EE3alckFMLgkcdlh2/E6V+zlijfvfVAXwHrVWRazl7Nv3IE1mcETfF94IOmmWaK4OYR87NC0zgUQ2CQyfNo+KTWZFvJ6VJTjmQ0P646aGu3/41jFvl2TFRzCXVXZDZLYDNvldWxdcwcBqjmOm6X2U1jPNUWLSvkYSR5EKdYrGryXqOru2rK2LLcOlCZGd2gC+m8YjgatVvELXGNHJtWY6YeFcFjWkbmbcUii7rPIRCjoVgv4akMNZvEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgJgGQzmEQFn3qDjiul4utVDj7Am85Us4DHS4OSv5bE=;
 b=NufusNhjKmOiYP66dpug1Gj+pepuUxEB+3xzxhQTgI6MaJwmO6n3yVkm3BwKFtwZDrAU0d+a3bdAxm+4OFB3WFRQEpy3xJUEB4PQ+sns1I56lbtsXhIKyJCsyqb/2oe7Ef18I9NOj4xR70JuSgeMm4VxuSmcsvWk3jjEzZaGpmodLfw2q8TXtUIeEe2JZx9MfEUZgv4WyDyj0DCVVv2KG+Ps7t5nqJkx4c0I5VbHt8Cj+ebeXMN9l2tZP2bncQgjx+RVf862EpmzH34PXrvJLXESha1pWQk4Qc6z6No1r/ib0rpol0RHH+G8AGQbkCkbnHqv8RU/ZHgb4lTTyFp0uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgJgGQzmEQFn3qDjiul4utVDj7Am85Us4DHS4OSv5bE=;
 b=TyI7gEWUllsimAfPIgcNHv1J/8wRYMmjRwCLEVQq0LkVW5DHkWx2UYAVT2DksGOb+4FPFXetG6Om7WZIp5h8gcl/C4myx3Fasscn1xAMUrMUTLX0tpc8fczN6XiQLJkUDT2yqVDcGA3hX10XSBJXVTwBYdltlA20Hs8ZzaY3S3s=
Received: from PH8PR22CA0021.namprd22.prod.outlook.com (2603:10b6:510:2d1::7)
 by DS0PR12MB8814.namprd12.prod.outlook.com (2603:10b6:8:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:09:25 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:510:2d1:cafe::7c) by PH8PR22CA0021.outlook.office365.com
 (2603:10b6:510:2d1::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:09:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:09:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:09:24 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v14 03/22] KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
Date: Sun, 21 Apr 2024 13:01:03 -0500
Message-ID: <20240421180122.1650812-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|DS0PR12MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: fbb9d9f2-33ec-4297-c822-08dc622e2d6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TuCZ4d/xlryLJ/cd8oAhxCsR/JgoPRQlSPbbn3ctk9eAN3PhTTrZ8e6hs57q?=
 =?us-ascii?Q?Vm9t2dhNJR9132b8vzeQ8Qzo/57hcIoDphNvoJj0pUXKkS7Od7vFwMX7eAC3?=
 =?us-ascii?Q?mJfCmagAF/THNh2cOiifF/9qZ9je8Mlhxu1+fd0zxl1TTKqGz1k9pzwS8mij?=
 =?us-ascii?Q?VzQeiV+fJqh3p5TNlhN5h9oj3onb5H+tQ5mTQ23pkNpgX6GSR9AOkkH19zhr?=
 =?us-ascii?Q?nYzPsrYpdJW9la7e9TaIYRL1rQ6gMjJwRDqtVBU4MZFFYNeiw9CxSoDgI5iT?=
 =?us-ascii?Q?4x6sg4ykxyo4/Ghmn/S4LkoTSWv+/LLNRNKPhyW09bppVl+Nw5gutrHOmKYG?=
 =?us-ascii?Q?T0lP1owSXooCSVAZKzeCp5gKLpZSwCouqyoZGo+7V8nHamsxt4hrlgIy6AeT?=
 =?us-ascii?Q?44WGDXsEL3u4GA2u3B3qS4T7pAKB4ravE9w76rIW4fs3WTa4lge7UCY+CybQ?=
 =?us-ascii?Q?khDRreERxubflH1BsSFR/Qa4WAgpIjkKxsyZ4Eklwx5lgl7XrUTg4mOIbj8x?=
 =?us-ascii?Q?VMB72T/FhJYeNKshPltb1Si26Bh0UGbYAWfxfiXsgKEZxjL4mQ0vMgjyDc5e?=
 =?us-ascii?Q?BJNr0t19ZqTyI4TEXL7YCi/sYdKfd4DAtBeRVSwqbrLIRmFpzjaVRENrP9QW?=
 =?us-ascii?Q?ctJzfvbVBCO33o4LrlGZwOHReBoCKh5YFAZJJexuGBI78+OR8Ci2Lb5ti1sg?=
 =?us-ascii?Q?VncDY+y0qQx+HFQZ4K+W3UVKafdIynbD+SxASLx/uUzPEF6Yus+jcAbZiTTO?=
 =?us-ascii?Q?GmWRAcM798OaBHwX3BXm3SqpEM4pZMNKgloMlPlyhbRRsTobWfZPh+sj80Ae?=
 =?us-ascii?Q?nz8XZnfll+zFnTgQnE54oFgx+k6U/P77eSqFY2wov7k0izdfx4MvMG+JI72n?=
 =?us-ascii?Q?psI4Ucev+vqJFPqAgRAAIuWKUk6DDdt8fakkuKqRp7e/1oQMylOBEPuX4QtN?=
 =?us-ascii?Q?ut9w8z5HZ+Ya9ENjVR65LNb6Pirq8wdaoCCnqZpLWfN0zVKiSNbD3HDqypSw?=
 =?us-ascii?Q?JBkraGp/MnWF0jeScp/o/4Gpe3R8h49tnGb4bBun5rZkkFIVvolaqTkc9DCL?=
 =?us-ascii?Q?BBtsSqgFviMfccRFi+g7kwPbfgHihmy5i292ZZdsxJ7KAbNW9ehHY7N+euf6?=
 =?us-ascii?Q?DDLaCVkmON3elNPB30tw0o8RaCge8MJDVKnhwnUSADVwEV9HpNHqphSv43Ef?=
 =?us-ascii?Q?cM59HjJqeIS1od+ScBgkIbyFxIEmzq0LZpI70ZvJA93oIDV7jk4lnbyaOLa4?=
 =?us-ascii?Q?itJhRtfpgNtHbBiBl6XPbJaELNO3EPgogNOqQOuRtn12+hci4UcW9O8aZjhz?=
 =?us-ascii?Q?8bjYamASphS4OLlTbwiRY20cn0w4Lk4rcf1341SYFy4xuD5LcSUJKG/71Lnt?=
 =?us-ascii?Q?ngFTkRo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(82310400014)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:09:24.8992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb9d9f2-33ec-4297-c822-08dc622e2d6f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8814

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 01261f7054ad..5a8246dd532f 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,6 +101,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6e31cb408dd8..1d2264e93afe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -33,9 +33,11 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+
 /* enable/disable SEV support */
 static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -2701,6 +2703,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2961,6 +2964,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ:
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3085,6 +3094,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES:
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


