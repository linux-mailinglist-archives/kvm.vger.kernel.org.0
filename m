Return-Path: <kvm+bounces-42897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B76C5A7F9C2
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 11:37:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 165777A3FAF
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 09:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA52268686;
	Tue,  8 Apr 2025 09:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kKbqgUGB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB2267F4B
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 09:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744104772; cv=fail; b=jxrGqH8PQhrUBi6cCXcRNi86Stbl1BscaCfnzlNNDhRvV0RN05YkmezAHd6mYT1e7kRElTW9Hdel/BC4p0dOXq17SNcjf8hBQmjKy/FU99DcPbTthfwfnal5BZFfrW/yiJM5f/t7JjRoCFRStlkdoEGfM4ZplNrnEPQw+QYkOag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744104772; c=relaxed/simple;
	bh=n5w47GgmBbngnTpjir5hQ+ipNcUOxJs95jyewxMi9+Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOxsVzbhDsA6cVXV7ELJayXb6ijhGKVBOyJW/ivPsl/Y8iUq/g4hhJ95ealcP9wWw7wjbwlnrmfgPFJe5FiZSv2PZB1IzRLA809ALiMF2INiP8zZu9u7JyC8qmqWNdokaLLpIPqULC8CVmLUvTBg1PfOq9uodhZ4NGKCPEf8t64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kKbqgUGB; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUsCOVj9wnmXynjws5PieM4ZaP0kS+2nAwLOuAs+J1ZAczjbwEQeLu+6FqDFnx/nUmIfKhoQylgScIUQYC0EULg++8xJzFo0ktxAwyeoRdpARSKy1lAm2nR0Ek72VcwG+1KFb6r0CKma14qd/CWREanwtvnuFpIcwZDdecly7BY6kqnHTxFXX95/QHi2mtC5VM+6uXQq6573+7NQB5V8olJy4bvRKHzmzNpWlOPsRvRw7azpmr7eFI/mxhm54OBDH4ftSeJjr4SUuF2ss+4dzJZMg3eeyTStk+iWAQ8iv0o20OG47l+kkUNpcR7GnDhk4zgZ6hN7WFZNdSNrrtPpiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQoYqCMR0e6KbanwkiaorabSqoLGFC+PCm6oYsdcq10=;
 b=UR3D/bTo5F4tdRr78V1UCytC7oaeCj+HdRUKUvoL95+D4xeldjUpBNzSJNxSHBhW5wVEcfyWcrYkucqzKRR+7LLXtHcdoO8Nz5mLMx/7RbZD2iMEGft+jxgxg0pP3R8SkR+3ZMO9f0ZvT3GiMypmAlcanLmYDAgBNsFh1oJYg76uSnaAp/6r7WNOhi/fqEGGwPoKbyrwn5DibDTIas8bmD+L+SQbfKBjeFL9CwZzrNsLmjRDqhiCEff4eDBAyajRgutu3dScb4DH1/n2ZLB5JoFZszb4PRsHMj0vfuLhi6bLmE8c6tzs8H11TQ6VkdrQJEzMlLI+0BbF0aRWW2IQgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQoYqCMR0e6KbanwkiaorabSqoLGFC+PCm6oYsdcq10=;
 b=kKbqgUGBzTurxlia8dPVaW9su3HtTNYpSkuw4pO3ciKW1ffCO9VeAH8SjJtm3RnYMLy/kAQFz0zI/ntoVEM1/ed+dfaPfSha0LjymCBouI2XmpIOxHY5BDr6xYeXBUhPWPTvnKKlZa3KvQWdhlnCNIHXHzD/cZH9W3CXh2qAmAo=
Received: from MW2PR16CA0057.namprd16.prod.outlook.com (2603:10b6:907:1::34)
 by IA0PPF64A94D5DF.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.20; Tue, 8 Apr
 2025 09:32:47 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:907:1:cafe::cd) by MW2PR16CA0057.outlook.office365.com
 (2603:10b6:907:1::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.33 via Frontend Transport; Tue,
 8 Apr 2025 09:32:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Tue, 8 Apr 2025 09:32:47 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Apr
 2025 04:32:43 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>
Subject: [PATCH v6 4/4] KVM: SVM: Enable Secure TSC for SNP guests
Date: Tue, 8 Apr 2025 15:02:13 +0530
Message-ID: <20250408093213.57962-5-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250408093213.57962-1-nikunj@amd.com>
References: <20250408093213.57962-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|IA0PPF64A94D5DF:EE_
X-MS-Office365-Filtering-Correlation-Id: 5417d65e-944e-4cdc-6a1f-08dd768052b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2BmSk12m1ilpl1RMFNHHIhrt+1yBB4DTieRnKdeQ6nubyAHY40oHkdSY9tVX?=
 =?us-ascii?Q?+YkH3/OhP3lr6FF1hzoka8Mio4zi5exHtmDKPIITX1OGkh9ZcNhcZjAlma7S?=
 =?us-ascii?Q?7mXFrYLFZR6ps3veEx7r84rE37n0GbyLHQToTZ2WLjcpuMLwO+5bvBuCbcVJ?=
 =?us-ascii?Q?+v5nEWicD4ntzC3eMHNmvBEJy6fnOqMe/USYQbjJUbCGLA8cjLTyTdbpVRv/?=
 =?us-ascii?Q?mRe+4egcj1LpxgX/+x6xkl/HOhl+L8SG1NnNbq8XS7/Dj5gxvznT5+243wQF?=
 =?us-ascii?Q?hN9SaxLd8gutS0WOBMdvlCoF/6RdH6P2N4fhcm/AAQ/sQYuE05be8xT8N669?=
 =?us-ascii?Q?g9cu9tJEDS62Zj1SixwAtL6lKdqQaNg0G9MIrQMIx5shp7Ey7np4meEBVkcM?=
 =?us-ascii?Q?fTLg/t6+tdQ1eB2bUYksmoyjtBOJ8EHwhRWPBCFojVEDOgdZN9eyvsr/xVXt?=
 =?us-ascii?Q?850ohlDjcvfitwGDRTSyL6f9hr1eRSiiNqBoBzBHBcYqlsR+4gNv/uRPMTGd?=
 =?us-ascii?Q?Vvh4n25RMCKvqqG4PKn96fPY+gtaNPUqVVGftGGkx5ZwK4D7EbqKE4yJCAbZ?=
 =?us-ascii?Q?Yg4Z06J6/VVGSUO8Tl52krrZ+i84MFnFgjYxuKKkIBam/91r7TfdUC3f9/GR?=
 =?us-ascii?Q?teKRx8cxT5smYSD8DY9jw1qoaa01a+wCpLyU04eLkB1TMPfzK4oplqzVHKSN?=
 =?us-ascii?Q?LkoO5JZQFsKutwsR9Cl3oZaLQaUQeirUjL3vcYNadFgF/+3TM215Bxj56tDs?=
 =?us-ascii?Q?3QIc4qla4myTxyxAOIK3DDh7mtZ7se/jOfKWilh6KqcyyhMaMiisjIbB65nZ?=
 =?us-ascii?Q?USVFx3Kie4VDlk/WKxHsv2KsIX2r1ZNaE5nZ8I3L/0gL64xz9T2q/j7OhFfv?=
 =?us-ascii?Q?WDgrxnDTpg6IPjouDn7TqdNZ2XPHZ8zw6uPUshQWZX3aGaoAQAJ+BSyZMI4D?=
 =?us-ascii?Q?IGZDmvevQppVEle9ygg1KfiWCk+qbZMRaIzFnC1T3DC8oFfrsfEthfFlA8wM?=
 =?us-ascii?Q?mnN4dfeZ4rXMl+Lj+9uvnktxrd63Y1VDWo6FrtDZhjYJOhdPJnOnkiOA9aY9?=
 =?us-ascii?Q?eeu4bk1SQpcRKfn81e2Puo0bcWBt32MJyekz1A2Dsx5EMcLnEc8WMD2o/Hea?=
 =?us-ascii?Q?S+rRrWswqrCPilX+W5gIW2ufDVCyU5gz8LjFHx83Hvnz/bR0dzpTtYRJG/Gj?=
 =?us-ascii?Q?UT6jh7ftOhYc6BFALjQy8k2boyvVTO3KDqAcMNQSilYW3nZBn+gcDiTl0H+c?=
 =?us-ascii?Q?AhHOR9qkk0/3MAGXWHb7MXCboFzDLWdto+MWqN25UeNhc3HTU6AHgkSKqBPQ?=
 =?us-ascii?Q?Afi6lsOAOPzW/MHsaTcxsh9kaVI/gYnHcW1/WpmjwLBUSu663aNUPnjtt0jP?=
 =?us-ascii?Q?Wt7eD5j4xRoxS6Jra+KMPS+6ESW0oWVQ62Ew/NkZ0lOYW0HP/nD2cXoy4mlu?=
 =?us-ascii?Q?i1Pl6lNUvAzP3FDps8m6Jkbq+uIXRL2cnqI0oVAYCDChdA4rSQO8D5RAjefs?=
 =?us-ascii?Q?Nti2V5S+vVs7pB8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 09:32:47.0322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5417d65e-944e-4cdc-6a1f-08dd768052b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF64A94D5DF

From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests.

As the frequency needs to be set in the SNP_LAUNCH_START command, userspace
should set the frequency using the KVM_CAP_SET_TSC_KHZ VM ioctl instead of
the VCPU ioctl. The desired_tsc_khz defaults to kvm->arch.default_tsc_khz.

Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/svm/sev.c          | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 460306b35a4b..075af0dcee25 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -839,7 +839,8 @@ struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
 	__u16 flags;
-	__u8 pad0[6];
+	__u8 pad0[2];
+	__u32 desired_tsc_khz;
 	__u64 pad1[4];
 };
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 50263b473f95..bcb262ff42bb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2205,6 +2205,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_secure_tsc_enabled(kvm)) {
+		if (!kvm->arch.default_tsc_khz)
+			return -EINVAL;
+
+		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
+	}
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
@@ -2445,7 +2453,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			return ret;
 		}
 
-		svm->vcpu.arch.guest_state_protected = true;
+		vcpu->arch.guest_state_protected = true;
+		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
+
 		/*
 		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
 		 * be _always_ ON. Enable it only after setting
@@ -3059,6 +3069,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.43.0


