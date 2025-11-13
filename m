Return-Path: <kvm+bounces-62983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E01C55E9E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:20:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B02DF34BF81
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA32320A0B;
	Thu, 13 Nov 2025 06:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="anc/y9bV"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010027.outbound.protection.outlook.com [52.101.201.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A8E3168E6;
	Thu, 13 Nov 2025 06:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763014840; cv=fail; b=jXEpUx27fXlmMAtFO6LOVPN+ypiEocFrckHUVsE7/F8LMTdPi2e8fo+urBhS9PZiYdLInbwDcRJDndPsYPKTRteMhk5O9STrNJsDhY3xTvJwdK56UrEBQWxGeyHLL4u1ah43ugHec6VnuqloaKix2qmCLubUvXk/vqlh9eOUP/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763014840; c=relaxed/simple;
	bh=L8YglCaIcPTBIG2zH7vh7NM20mfIKTKvMfoaKsBDqGQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IPyPcHxAPSx4Mfry5ksOaOQHQoHgsR3ge2nQCIaHjNIM7BUfXUwu0WmwT38BGAlqDSIJIXgoJ/A/gY4xaIVIzogrUjNiB9A2Kvl0EQJw/9FY5PBj4l7CNYBmT0VkC3sSn40dQPxTYecjSZXQW3eosfj9xLgjRJD71pas7hO3Ttg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=anc/y9bV; arc=fail smtp.client-ip=52.101.201.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DebE9Fy8TzLKQ1dyzfQjLAwf/oCQEc19nBNZbuzlOTpZIsqT5uB5Fxwqe6TXptKgW2dB6SKJ8xoSHDpHmHpzbHe9rlIToLSU9g5jgXJHgRbpOffEyNjVKp/JxRkxZ5Gdq9e0Hg8vaMB50uNFZRTrl++KwOp4m99aBh/LOf/rqWxaZqGtNIooHiUIOA1rW8a7sO6VB27z4r74SML83tNqX1h7zq86qypEOVJaLRsrplLfYOsK88nJ7AsIn2n2Ig2cSLSZl6KnEItns49D2WMIM9e7cfuE+FXnptoP5e0XIVQ7GTxyaWK1L5Vu8YkSdVoZqN3y1GIbNqCmCsQex2OeRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpabcVg2UDPkYnWbJJf/P4HihX/EK+hOSdfzoPCm04Y=;
 b=IWbckiXESz/IU3kVudgGFJ9ORyq61tBVTCSK3DUZUed4Dak6RKQUJ+3Y/Z3YeMGFLYWS+kR7tTcP6GZpsMLU6mw13beBupf6YtEhfIRxq2h1HaXxk+CMasRchCfHLoIWyL+GtBbT9fwe3UDzWwgnKC8bfakMQLZ9jsjSdoVxubP7YDCnfLVvGJeWSCVfI5DWC4b+tENzVwJR3MDa2Fwno1q/0DF9lRZ9j73qLVGOEWj1e5980HSPc9RtwxWR3AvKkDtI6d8wc7Gnbwjm9QYdg1/nzuYJ7PjkcNof67pzdEBRqEdZFWOdd52zqFTOZ1D7yQRGA71zmCIAIgst3RU9dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpabcVg2UDPkYnWbJJf/P4HihX/EK+hOSdfzoPCm04Y=;
 b=anc/y9bV0EWO58iZoN2fqiuO8hjDsKbUWhVVgodI3g6oeVC5Sr6wNS7A71QuboAFNJvdeVAuYP/84J+Q+r4lFl7XKt5409jpyyu1h0bC7+NXnEAOsQ5MmCWLocQM8j6g3juxi7X6Dmtyb9xsntvKTyaf6kfgh2dHV9e9fDAkSck=
Received: from PH8P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:2d7::26)
 by IA1PR12MB6388.namprd12.prod.outlook.com (2603:10b6:208:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 06:20:35 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:510:2d7:cafe::4) by PH8P222CA0016.outlook.office365.com
 (2603:10b6:510:2d7::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 06:20:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 06:20:35 +0000
Received: from sindhu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 22:20:30 -0800
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Kan Liang
	<kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	"Ananth Narayan" <ananth.narayan@amd.com>, Sandipan Das
	<sandipan.das@amd.com>
Subject: [RFC PATCH 7/7] KVM: SVM: Adjust MSR index for legacy guests
Date: Thu, 13 Nov 2025 11:48:27 +0530
Message-ID: <b7ea0609f705b1d1453110a47ffd0170a1edf1cb.1762960531.git.sandipan.das@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762960531.git.sandipan.das@amd.com>
References: <cover.1762960531.git.sandipan.das@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|IA1PR12MB6388:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e5fddc2-d794-40a3-13c3-08de227cc188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hRn++nNLitZc0xPluUXITO7mzm4DaDFRMcivcfo9HIjr+efyj/mfAU9r8jqf?=
 =?us-ascii?Q?JgPC1PWt2lrB2HfAYsd00xvSusbGPehXQ4kTXHoCJ7rCDTQTWUS88qe97YJB?=
 =?us-ascii?Q?XQQmDZaZrmsn2IekiYhXkKHgLBdpTu7tYiQPRPqOmTAN452P5mFEX4tW80jb?=
 =?us-ascii?Q?gXYr0NR0WYZSTJey01vjYyiSWNpUh3JnX74aDb9lG552HXSDTGGRBajMAKKF?=
 =?us-ascii?Q?lBRyio+aWDVg1pJx2By2o/N7jcJ0gEWw4JOiRXyz1NjIg6HLc+YA8hQfy5QW?=
 =?us-ascii?Q?/MY7W89okj0XMzvAmpyo7KJ+urZl6g8j3lC9KyKrNU/27Qpez5bifsc9T4Mv?=
 =?us-ascii?Q?xkQBWiOrQZ54scqGy2l4TN26LWgUjR2cyaJlt824fd+cppO6+7hYOqhK7jxa?=
 =?us-ascii?Q?89oydS4MiD6qWE0WfSn08cg89F4B34s0kFnHOX7PCwEkA5nehL1OqSiMyJ04?=
 =?us-ascii?Q?e0B1+w7B2xwibvQCS5NdkV2HNL/+3y/jQpJpGmCp1324CkYzOuSqbfahB0gv?=
 =?us-ascii?Q?FzCP4lFPMPldX11AzFys/09/eYoBZ9ULuUicsOq9dxiAENgjFT6XQ0lpmakS?=
 =?us-ascii?Q?pIpZaUguqMw69pCuMJgYtEfQ3URQ7lhKc5swsNREG4j5BQF5L/DAyLb7Yc8A?=
 =?us-ascii?Q?andVSxdscPTfHa6Lj10Njq+Rn7FyvwZAvzBNaig44f51JJFnAWqiwO2UJhk5?=
 =?us-ascii?Q?7q/sEgm0+JAHNVmy5K9l7cRF2j9di16Ggi5TYjqlz0Xn7ZbhwQq5+7pIL6oS?=
 =?us-ascii?Q?26ySx7wi1r6a5aGOlGNX3gelDCYS+FJIJ3zDzmQi86O0z4MdvtfL2SbYp4a5?=
 =?us-ascii?Q?vbYxkqhSPQHm3wKu+gHWe7SpYJ71jgxPbEIK+0mSuzbiCDFkpLAFglQ8O/26?=
 =?us-ascii?Q?gL/c3umY4+jt6/4kNPi9ivk+CA046frkEg/JBobNDYnweerGO2nmQsH3xb85?=
 =?us-ascii?Q?9hsRJ4PZUMLgD2QcdbYcNZSjZX0q+YgcbbMd+qn3xdO31jsQfjQiPAn2ljvL?=
 =?us-ascii?Q?j8PItwL3eBWtwx6dLEShR4cJTlBZ9V0QVCc3kaEqJq8ycRRPJImLCzQBtVOH?=
 =?us-ascii?Q?dcpGeya1UXWIiKG2B53LY19o52jmibo4/n+mbCQs2c3Y8pVKymUoGKjZqI+G?=
 =?us-ascii?Q?WBeeco/R7z2jv6JSu6bXOMIV56aXZ5MwMikTvgJJKi+Sn+QXHY7awA96NOcq?=
 =?us-ascii?Q?oQEUfexAcDt+wTy6VyYgpgHGl79F9Mxfdx+gz+4xfZF4KbED6fOiU6zNI8j8?=
 =?us-ascii?Q?sbOgh5XE3INgSzkZieH/WYUnxLYJoOqf9VmG9USmRU9UE7TezrJ6sFe/Wgmo?=
 =?us-ascii?Q?znbDnrHmXXbwFVFBxhB/W/N8W1kfiISJBIekeFgKt5Qxd8fY0JQ6mSnfoYJJ?=
 =?us-ascii?Q?dHf80kH5PqfAA1QVxAi512Va+WEUvCkW2JD0Wb1VAL4Jih9WVg+15y32ufOI?=
 =?us-ascii?Q?1ZUeiuPm1IgNiCSjsR6p50xzb49eESJ7PQWVcljW+jjKHuet8d9yQ8/6CD/V?=
 =?us-ascii?Q?6geTAAj4qkj8EDmWyilckkHmukMUX/qrmlX93vJqWwC0BaS/6SOerHAUY/FY?=
 =?us-ascii?Q?okR22b1vNfVQCV9VpCU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:20:35.0521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5fddc2-d794-40a3-13c3-08de227cc188
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6388

For legacy guests, the host-initiated requests from the hypervisor to
access PMC-related MSRs will always be for MSR_F15H_PERF_CTLx and
MSR_F15H_PERF_CTRx instead of MSR_K7_EVNTSELx and MSR_K7_PERFCTRx
because of how GP_EVENTSEL_BASE and GP_COUNTER_BASE are set in the PMU
ops. In such cases, translate the index to the equivalent legacy MSR
as get_gp_pmc_amd() will otherwise return NULL.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/svm/pmu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 63d177df4daf..c893c1bef131 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -124,6 +124,16 @@ static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return amd_msr_idx_to_pmc(vcpu, msr);
 }
 
+static inline u32 amd_pmu_adjust_msr_idx(struct kvm_vcpu *vcpu, u32 msr)
+{
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE) &&
+	    msr >= MSR_F15H_PERF_CTL0 && msr <= MSR_F15H_PERF_CTR5)
+		msr = ((msr & 0x1) ? MSR_K7_PERFCTR0 : MSR_K7_EVNTSEL0) +
+		      ((msr - MSR_F15H_PERF_CTL0) / 2);
+
+	return msr;
+}
+
 static int amd_virtualized_pmu_get_msr(struct kvm_vcpu *vcpu,
 				       struct msr_data *msr_info)
 {
@@ -142,6 +152,8 @@ static int amd_virtualized_pmu_get_msr(struct kvm_vcpu *vcpu,
 		return 0;
 	}
 
+	msr = amd_pmu_adjust_msr_idx(vcpu, msr);
+
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
@@ -203,6 +215,8 @@ static int amd_virtualized_pmu_set_msr(struct kvm_vcpu *vcpu,
 		return 0;
 	}
 
+	msr = amd_pmu_adjust_msr_idx(vcpu, msr);
+
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
-- 
2.43.0


