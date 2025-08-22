Return-Path: <kvm+bounces-55526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC43B3242E
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58806A22A23
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A5B338F2A;
	Fri, 22 Aug 2025 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K0bCvGyw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AE527B335;
	Fri, 22 Aug 2025 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897961; cv=fail; b=hZu69Agoeeq/A7RuBEzBoavgdX0xYS5xzakqVQxTlrRdAVNs0cdu/7SV77IS1sH6rCc/ATkMmIVnE4xK76O32DJJKIx1UEwHP6GIsk90mrJoXxhP0dvv1qUJUaR6Q7gwKofIsf0hLvblsOfYzjDHiAjmXKx6FwUziaUfaA58rlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897961; c=relaxed/simple;
	bh=AG/406KkjHf53+/lNdD+gwZwA57bZPiQi3eou+HDAcg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i77bHztwcd9hQbL8QFS2OpRNWu7m/BBvlpR3V5X7Vkt1htnSxYAyY1PKf/30JUUdFuoeq3R527lQSq3aa21H7tgiWAsJgKHpkoDievsodmphsOI93ExTScnzSFgPAtEMJBzs0NojP/9sSSVJzum2B7JLbICEhLw/VqL6OGmhF5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K0bCvGyw; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cXgGf1i7jcBdyl3YbiXN1Zi7pnYHr1PhtcohYGY9frDd+88GYYRvteepspugZTW125qjyOnVqQkhJewJJFyNxot6XSgwvtv3zXSQETm+OIwXNNLcaWqcslvm31hrTuIFWHohjfG6W3H0FFcgKkCRB+1YdNaoksr55v/0uYQedamKCne/97N05AaXQKJKlv5QRwrmVJpYT36QHV38PftYnwKud95EpXRBG5GhvgxbrSL42HJot/+lbbA+0w4iKv6Lbm7maZ0mmvAFRQ/Y4RwnXPXwngG+OCGpE5aNoSswLwt1VurT5gJXyCv+ywAoTlgId6QGMzROmDAg1zNyme7Uaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qpuQ04fUWNxzfM48WH84V188tdKk81YQXQcZfcnIVw=;
 b=BPj5nly14cYq/dGohkSYfAxngo4Xr2NBfn+cV6R1GHTiqDuZc6KHCrug18ZUEGs56YpYmPIipjrzABDCXbo8w4dNo76MlWpSHeB9ihWML64eJs3+axZOklLKO3KpxocaowQP3tmTPLli0svW8b/fZWcSye3vjRj55mEfDDqzcP5PH1HQx2iZNWJJOtmMM2W4VDC1DNLyr5pv/J09mS5RFuxnFbKVWtrxzPNgL+zoXTqp4kF8eBwBRdJO8VwmbPvpXWtPaBpdm9Q3jYFaB0EGtiNbOUTmXEpIOxTEJrnKfO05M5hpP9UTabWDduee5CndnX+4hD6LfpwgMz9DjMSZJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qpuQ04fUWNxzfM48WH84V188tdKk81YQXQcZfcnIVw=;
 b=K0bCvGyw/tMswViN+xPhMiLEPJbWrfI5AHrF6oij7ypFdPlG/qnwpXW7CXqK8Hsn1CihfW3lbGaRHpZWENI/YWVGnp4ph3xTQ+9fZU0LbMgzF2P6WwBybOQkVVSK+HF5GxuzhMd4TYIQowNKzySfS6mDv1EUHYQge3DnB4UrhWk=
Received: from PH1PEPF00013302.namprd07.prod.outlook.com (2603:10b6:518:1::11)
 by CH3PR12MB7666.namprd12.prod.outlook.com (2603:10b6:610:152::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 22 Aug
 2025 21:25:56 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2a01:111:f403:f910::2) by PH1PEPF00013302.outlook.office365.com
 (2603:1036:903:47::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.19 via Frontend Transport; Fri,
 22 Aug 2025 21:25:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Fri, 22 Aug 2025 21:25:56 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 22 Aug
 2025 16:25:54 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH 1/4] KVM: SEV: Publish supported SEV-SNP policy bits
Date: Fri, 22 Aug 2025 16:25:31 -0500
Message-ID: <ad3dfe758bdd63256a32d9c626b8fbcb2390f26e.1755897933.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1755897933.git.thomas.lendacky@amd.com>
References: <cover.1755897933.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|CH3PR12MB7666:EE_
X-MS-Office365-Filtering-Correlation-Id: 745c90e5-6482-41ba-fa31-08dde1c27b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rrYPmPYjaW7nolNnqk8P37FG2D5JGAylfpPIyJta4PzA5osJ8Rm43lUdv+l4?=
 =?us-ascii?Q?izh+5bLrtgIxJo6XCjBJv71Hn180EZ5qjYtHqROYhrC3ZnUz6REIW+bo8NP3?=
 =?us-ascii?Q?Nm2mvh9uixlrwVHmZ2ztY/+3jG5hNAqIaFvsXRB3cVpXjHIBWZz7alrHIpHl?=
 =?us-ascii?Q?Z3QomGRqDbNBRwI5akTC/03qiTcuva5KPLqwSe+IpKZKXmf3cJl6qxWbjnoX?=
 =?us-ascii?Q?WjRQeUjajtaG7h08B/zlnH2qabKpQrKn5r1r3nx/RAQxy64i5BnN6AqF90gQ?=
 =?us-ascii?Q?zyD1PwVjBCHpFTxaSshxJ3LptDl+7LiMgaaR5PAj1xn3ZbY5wLJ78EzNuJef?=
 =?us-ascii?Q?tqKWq7oHHNQb2zH9y85Jrp/AOPhsdk9yMhS2e454WI+X2K0YEvf6w8lCLdnI?=
 =?us-ascii?Q?Nl0Rsew025LrIUQnS4ucrzKacHUHs4SKYxkqqG3HvcN4ZR4i6tUocU9Fcbh6?=
 =?us-ascii?Q?XBr6maz8gn5qU6SjHyf6L7sv//8/lYAZmG9X/7V0j1Gw339xtPpJQUCUKbQx?=
 =?us-ascii?Q?9vH+tAbH1Bvh33n+3Av+6WG4s8eKrx4yR3yaqTUPJ76USKUNwFoQhVpO6pZ6?=
 =?us-ascii?Q?g3Rpj3nHt3HVmbPeFeomJjbIOyTFMeTt0rwLjjUoZJHqvKX/Zsa6gX8g59fE?=
 =?us-ascii?Q?w8YW3RGONF+1kkDIFsOOIx3OxaTrc6/G8Z4Ij44zy5GuAALtIyvHsvU2PawE?=
 =?us-ascii?Q?3DQMIJb4XzuXSC/LIOsITebQxLB4hNQZ+6RDn7jRlJEdut+opFq+DSoiJZ3C?=
 =?us-ascii?Q?IGAieYrBS4jLG4KAcO2ZnCBPlmihpLJv10BhycFQSScTWpOl9FMZuacMfjE/?=
 =?us-ascii?Q?nAZXClC3Jp+I8iRhVbZgD9CJLmQVGTh9mwlneby94cscOx7sumYz+PxfxX6V?=
 =?us-ascii?Q?k4BTQNkwofAHG8zia/GIq4eqWH3hh8gk1bFBuPnLhELTqTtuDnZhMP9RbdDt?=
 =?us-ascii?Q?lG003h239zAYrJSBXaUnMxrEkORyZIAWk9cODRbfv7zSpKhx2rbCpnB/YlSo?=
 =?us-ascii?Q?AbHVbhN/opWYed3ANSdqkMfU7wNQC0zlcPU/wFhC9FMgT3OJHCcpldzVmsF6?=
 =?us-ascii?Q?/3nBXPYbsjBdnA7B6QnKiJYNdvH18uKTpIikGw8gLeIDsF2MIXSsBr4Ng0+j?=
 =?us-ascii?Q?BpZ2Pid/v1MJoB8TS/arJDICsRq9QXyhcQT9TBIcUS9daVMpBF0fJLh8lyos?=
 =?us-ascii?Q?he24AIgkJvttqND8ifGnfx4gVGthJjZxv9Fnar86uWxUiUDrjaINlBOMlFDL?=
 =?us-ascii?Q?i15nbmkhgK9z2UO5pTPzXXJSvVdPl/LvtOSSs3g7TWCTDvtB8G3wzQ1Fezv/?=
 =?us-ascii?Q?ywQCbgHz+TJPcVS3e32ElzgeX1CfoiaqB0/CLcW4Z7ex6RF0R7yih04hy2ue?=
 =?us-ascii?Q?mLTIp/Ue5iSe5qP8h4SPCfLsCdpZumcyG8eE0182UXMifep1SPAVbDosf8qy?=
 =?us-ascii?Q?3hk+oaG0kKAQopAexjN5KJTEbz1r1S71uO3q38KMz+owf7EsMdY4Xhr2gFGh?=
 =?us-ascii?Q?APtmOPMaXUn6bT6XtdFVrfM279EKEp5evXeD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 21:25:56.1329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 745c90e5-6482-41ba-fa31-08dde1c27b21
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7666

Define the set of policy bits that KVM currently knows as not requiring
any implementation support within KVM. Provide this value to userspace
via the KVM_GET_DEVICE_ATTR ioctl.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..90e9c4551fa6 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -468,6 +468,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SNP_POLICY_BITS	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..7e6ce092628a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -78,6 +78,8 @@ static u64 sev_supported_vmsa_features;
 					 SNP_POLICY_MASK_DEBUG		| \
 					 SNP_POLICY_MASK_SINGLE_SOCKET)
 
+static u64 snp_supported_policy_bits;
+
 #define INITIAL_VMSA_GPA 0xFFFFFFFFF000
 
 static u8 sev_enc_bit;
@@ -2113,6 +2115,10 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 		*val = sev_supported_vmsa_features;
 		return 0;
 
+	case KVM_X86_SNP_POLICY_BITS:
+		*val = snp_supported_policy_bits;
+		return 0;
+
 	default:
 		return -ENXIO;
 	}
@@ -2177,7 +2183,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.flags)
 		return -EINVAL;
 
-	if (params.policy & ~SNP_POLICY_MASK_VALID)
+	if (params.policy & ~snp_supported_policy_bits)
 		return -EINVAL;
 
 	/* Check for policy bits that must be set */
@@ -3054,6 +3060,9 @@ void __init sev_hardware_setup(void)
 			sev_supported = sev_es_supported = sev_snp_supported = false;
 		else if (sev_snp_supported)
 			sev_snp_supported = is_sev_snp_initialized();
+
+		if (sev_snp_supported)
+			snp_supported_policy_bits = SNP_POLICY_MASK_VALID;
 	}
 
 	if (boot_cpu_has(X86_FEATURE_SEV))
-- 
2.46.2


