Return-Path: <kvm+bounces-60842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 060C1BFD9EA
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 19:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BF1844E1F5B
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8622D5924;
	Wed, 22 Oct 2025 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kdnE1Lgs"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307FD2C3247;
	Wed, 22 Oct 2025 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154691; cv=fail; b=g045ihPUvtf0gu63rHJKHGBt62utyKqdFYi1d+uLQvEi5bHGu4f3dUeW7PylOAhFHRqeahFWn58jSAhhY4h9r6QtSzVNWltKakBa59W1lClPpejEQ2H1ilBgmx8hP8lsJAFd11xBLx6YIQONtBz/9xUnS6/pTTCYzQGsqofmNz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154691; c=relaxed/simple;
	bh=GH0rw9JavLJ7eoT+LWwMYbYeK53WqVp27twnpQt+RMM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s1gipp9kXoVq2ZMvZyd+f0Fx89eEUv+vkGZoq7ahGVn3lNoNmBIYXyvIf9ruOXmLHu6jm5ZXLrbhgrW+mEbS7kzXXBy20SEYbstvP2Hahdq2nUXnlgRvPPUS0r4hixNcS9OeapIv4PGLHbh1v0H/0kVFR0BRwxPYVqFux/Qe89M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kdnE1Lgs; arc=fail smtp.client-ip=52.101.62.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vmNKoq/vAQQiDwYK0Q2ihKdDRIOTWJLAf1MJF9kf6JesJ8eom+NmpuU6vl0mWGM1Ug49je69Cwv+MBPPzSUb5Br4D2rMN5YBbaeCoPau5kOgF49TZrvZHBZ3vp++XW4sHLb/S9VTqJZxvIT7rf4F37gaj7FVAOkg6BsYsiY9JfnnRUdXuUIuIkEDkIQfOjlLZqFKom7M0y2zsgLjNqwScVYVGSvNKL/dr2AOwq0YCVKNqN2nICK3GLqRrTeK/csdcrjqum/v9wTD9n77KMXQyutSbwftysERCVKCC1fAL9o1kPoNx14U9Q1AlNcmv8W7q0JO5DLqe6RExifnGBaUig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WzXgEF+jbb9U3wQh/DHTiRvekdQH9f4XJA7+x5EW1wE=;
 b=am14eSiC3NIRLGOpoBOoHw3umwPHZQaDTnmhxNssdXiEnKUlXHsnwyhQ9m9vx3dl5W6EfkNAUf4PrFQG7DbFu0eTSP8fsZG7OiHOSy/KmYlonMWPVvqKVpKMqf05XcHoPIOHXDTeylHrwSdpjHxltZ0QFeiuYPoDUzTieprmMSid3IKhKsOulgRUlj4HIbb9b1DutaiyUcZFAVmdfwoIqHvmsmS+iXU9fJykr0ljKs7ZbWjAf5MA7pZ44MlLDrmQAC+re7HIj7//b80VhokiGNyNw771JQL0y2ddgxzyZ79bb5gHfqyOUuH4ySCCqQoqk81wLdAUo+ezhwsz3Lhriw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WzXgEF+jbb9U3wQh/DHTiRvekdQH9f4XJA7+x5EW1wE=;
 b=kdnE1LgsQlkMBkFLCv4q1mBYQl/jGLvgfns5GYxZ6gSjpOQocpBY1cJwl0BK6SoEUKgSiwM2dDdT4VzHa2UnJKM4JqsrhYtCjD350i3+ItO+P6XFDzwJbkt2nLtvup/4hWHCD5ahxPSIO1t1yZB9I0CtX4BP9OIthuqfREaw8J8=
Received: from SJ0PR05CA0170.namprd05.prod.outlook.com (2603:10b6:a03:339::25)
 by SJ0PR12MB7083.namprd12.prod.outlook.com (2603:10b6:a03:4ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 17:38:03 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::5e) by SJ0PR05CA0170.outlook.office365.com
 (2603:10b6:a03:339::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Wed,
 22 Oct 2025 17:37:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 17:38:01 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 22 Oct
 2025 10:37:59 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v3 1/4] KVM: SEV: Publish supported SEV-SNP policy bits
Date: Wed, 22 Oct 2025 12:37:21 -0500
Message-ID: <d02275b55cfb37edd3dd0f5732e92239f8ee2885.1761154644.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1761154644.git.thomas.lendacky@amd.com>
References: <cover.1761154644.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|SJ0PR12MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: 05b0be72-c2c7-4ac8-2238-08de1191bf60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cMtU3npVaUrboM4inHTTWJCOAsgRyLTQnaA8T/Ax+fMHubDCPXJ0mpyn1SSH?=
 =?us-ascii?Q?jln3G1NJCMu8DhR49HP0AtEvng6jn+bLkmd16b+HOm+xrBXj85U6mTXqLcyc?=
 =?us-ascii?Q?TjPxWfBJKgLN/3yfNGLylaDMIa73Aznxh+DI3jwMxyc3SVH83pKo2yfgvnsS?=
 =?us-ascii?Q?GkmqUdZmd+HGfGLXviOFRMiAZH4qzHeEkTsMlPvUUv2wSNCjvO78Noqran3E?=
 =?us-ascii?Q?G79C4xieMUI7IKxcBTkMGpSK3lqpARKDb8xIiq9DVdJ1CXWOP23JZpfNfCpf?=
 =?us-ascii?Q?0yd0y5JDuNcA9Z9ywEULS9W8KozEwvp00EBByHQ8d1A7UoW3kk+B7hAK1+GC?=
 =?us-ascii?Q?5weoltqTChFpcBljEsruemy3OcHMFqSqbPVm4ez8Uf/EwEhG7YCGld79bH/s?=
 =?us-ascii?Q?xQG2uvitYEMejD7SVViUNIEaFGNcf6/ltgV7xfFeaTUbKD3pOdX9/WuryJxr?=
 =?us-ascii?Q?tGP0jgc8qyP6hS65uR+LDB77+ANdrx+hwJFHzVvZBf97QOrjV/IkdMHOaIh/?=
 =?us-ascii?Q?uBfkIUpVQAXmNUsZmNezSOZ7aCJ8gwWXL79SP+k/Qc+UhmJT1Jy4qn+SND2/?=
 =?us-ascii?Q?WZNk/3e5C0RisH0nLib6vBKtSJtxlYTmIa1Issr/PsFS7TxfiseHb8q/xgAl?=
 =?us-ascii?Q?vXzc95InalsBGc6QTEpC0fD4WtUbzLYIyu6OS/jmD8pzRsM1f1H/GhVWspjx?=
 =?us-ascii?Q?9poYIuIpwv+Z7KR954+XADPQhdiFg6OR774KiM/H0t2FOA98rYWxR8zD38f0?=
 =?us-ascii?Q?OhHms1mOD73TNwqd1SqxtoFz4o9oeK2H5mCtynxUnmkfydO1xzvmi0POri+K?=
 =?us-ascii?Q?P0vWZWvrwwxIBblOACgFMCyIFIgHdRZRPboV4oLFGZTiB+76Q9HX0s9rynHF?=
 =?us-ascii?Q?9tCKA8u4q1z5tj5GfpTJO3vwqqfZtwZUhBn3GjnLOcsBDUlvoHPJAl4Q0wGF?=
 =?us-ascii?Q?SaMXFtfKhR+cV/2YiGk/QvtxBZXAksXTD+/cADSrpFQCrg2KponN/t5NriAe?=
 =?us-ascii?Q?HX0jC/p+H8GoNAIIIo3+EN0gwiSaYc+dBNZVnXDzDOawTCvPaQC8ECaMxWJc?=
 =?us-ascii?Q?E9GDadhM90HRuwL8H8P38G/QDJR7a3exzNhRSekwCy8pSrM3Ym2/zWr40qxd?=
 =?us-ascii?Q?hjUyzs+qAuziW3evFBdZCfru8WVJrTmr7D8Zmyq+Ouwkcgs2ZevbNSnuvP0U?=
 =?us-ascii?Q?u0ONGMWpTE5g2Iqib6RYb18MIt3cSBXsEpIvTl1M128bldLoM/OHtdOhi9kL?=
 =?us-ascii?Q?NTrCZrEvaM+KtwlsiWdTD7Rr+K3JNLgVGgrzuT251V3fio5CthVBVnN8FOHJ?=
 =?us-ascii?Q?nMHOCN+5+0DpzqjyLonVTODGOOxE2KdAhqwoHt9XFKKlCbtDiKBsC4j85fDL?=
 =?us-ascii?Q?3X32YPD2HbPEdNQ3fy7ItVZcyocy0tTsqgw30MaQlIhUF6jMKdwZ1iHtpHSP?=
 =?us-ascii?Q?O/HqQh+ATvlcXw5HIcMTUSCK+oT879sE3HCsA3tU3KL/6sT5M3wpFSgf2D+d?=
 =?us-ascii?Q?VMySr3L88CKArhyahe+mwpiNH3Vn16ohUUOvgPlUfuWt01J+mRzlTA0UVbWu?=
 =?us-ascii?Q?olq8HQmEWplfuuEujl0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 17:38:01.0508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b0be72-c2c7-4ac8-2238-08de1191bf60
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7083

Define the set of policy bits that KVM currently knows as not requiring
any implementation support within KVM. Provide this value to userspace
via the KVM_GET_DEVICE_ATTR ioctl.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..7ceff6583652 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -502,6 +502,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SNP_POLICY_BITS	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0835c664fbfd..72cc7cc8c9b8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -80,6 +80,8 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
 					 SNP_POLICY_MASK_DEBUG		| \
 					 SNP_POLICY_MASK_SINGLE_SOCKET)
 
+static u64 snp_supported_policy_bits __ro_after_init;
+
 #define INITIAL_VMSA_GPA 0xFFFFFFFFF000
 
 static u8 sev_enc_bit;
@@ -2143,6 +2145,10 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 		*val = sev_supported_vmsa_features;
 		return 0;
 
+	case KVM_X86_SNP_POLICY_BITS:
+		*val = snp_supported_policy_bits;
+		return 0;
+
 	default:
 		return -ENXIO;
 	}
@@ -2207,7 +2213,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.flags)
 		return -EINVAL;
 
-	if (params.policy & ~SNP_POLICY_MASK_VALID)
+	if (params.policy & ~snp_supported_policy_bits)
 		return -EINVAL;
 
 	/* Check for policy bits that must be set */
@@ -3100,8 +3106,10 @@ void __init sev_hardware_setup(void)
 		else if (sev_snp_supported)
 			sev_snp_supported = is_sev_snp_initialized();
 
-		if (sev_snp_supported)
+		if (sev_snp_supported) {
+			snp_supported_policy_bits = SNP_POLICY_MASK_VALID;
 			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
+		}
 
 		/*
 		 * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
-- 
2.51.1


