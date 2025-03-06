Return-Path: <kvm+bounces-40203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0157AA53F38
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DCE93AF526
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B3E1CD2C;
	Thu,  6 Mar 2025 00:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ym8fnFdY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F43F1BC20;
	Thu,  6 Mar 2025 00:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741221524; cv=fail; b=f2z1LRtv4GFei9xtN0laB3yX2KxWN+s6HEb8W2wl5fHNn3XB8/rZ7nXVEF7P6BkIVKiTmnJIewLUVdaKP1NUlcGcWWa2oULlv3uq2XQIGadn2+s/+MKV293T2cOwrneuQzbvVJxHT13kkI6Zvz4h6ms4SYZO+9EOZfiD5TtjMVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741221524; c=relaxed/simple;
	bh=yzwUzXgCiitYNC+YJQyTjNoaVMODO+8v+KTF9X73GH8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7rvUidTZgONhXDcSTu7VK4KJanGTu3CawdvkS0rYfcshrGSdxfwX2U+6Heyn6TFtlPe4peawft5661MMDyoqYBl+hBVovzYlitl9YQOo627+4kC33AeNcjBGzsuL6qIQNcYIWIovIsiKdgbbDw+LFRe2bHJrBjgTWsntBcgTcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ym8fnFdY; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YSRanO4VT+IcVeIAAXZerMnBUc4RwGECSc0SQCS5tdo3YZgQ7pNs3/Ma5Un8MhYZXuHefy3Gw2+l7fHunHiFOVRozZ69ksoTCiiNL2/3DeqzH6MYJJsrsB2Ktob8IMoTdCQBNeAFYDZELiZTzVUpTzBzENaj1ntVmcPPBzhV7ak4RR7D/tozkJ2ch71ZtbMqr7dVDRTlWPpNfbIrv5t+zmrp6uNZ4o/O1ikZTq4IkPwhCP+nGJ+cBnN4BwVmpF/Po6YcFngStU3ZLOiiYNspC7LLjvy0CMGFNC8JsU79IIrEiunq0h6EHSywYaDYtBg3E90dXY50Mxr+H6cKWegujA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5N64wSt0ImaxX+QCyvrreSuLiFSINzT67KX557XzQ8=;
 b=j8Veqh21G/FaGaU1ZLkUtSnOocFBT/giri4dYSsB83pwATFH+0GeIoIqIr8+K/Urbt5dTjcDnibeU8Zo/J7rvNESTyE7/SfkBhLGZDnDXXQQAudJhJqusy4BoybcRL3E2J3vbIcJR/sA2XtIZ28Ql4pXLypq72uCW80/lKGiGY66lS1T+Y4CjUW/F4Oc7gqkTYhm6rOobCrqOveU5Egq6ZD9yu1U85Ckb3NcqoJwsnqbCZ0YoPsu0pbuwMiXAkmsPhQKVW+ovlFDTskE4BKLX5z9B1MAgCA7H64V28SAPMdL/j/5MOMZfqnQcuyFvwevWk+vi2QFASa+fNBX2WjVVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5N64wSt0ImaxX+QCyvrreSuLiFSINzT67KX557XzQ8=;
 b=ym8fnFdY7hPXXltIlYfcRdFGqKf7HMlLE5vnZcCX+GT2m4lk8jrRVFwKxP+9qNiVkDB8MzL1XdUhuaowsgVXhbqEOrXlObtp1SmjKH9VBoFc7HigNcPCg1mN+ZySPk5bgSvomScgUTvnl0HaZz1NEEpx9qIppWsDiF+464hodVg=
Received: from BN0PR04CA0078.namprd04.prod.outlook.com (2603:10b6:408:ea::23)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Thu, 6 Mar
 2025 00:38:37 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:408:ea:cafe::c8) by BN0PR04CA0078.outlook.office365.com
 (2603:10b6:408:ea::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.16 via Frontend Transport; Thu,
 6 Mar 2025 00:38:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 00:38:37 +0000
Received: from zweier.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 5 Mar
 2025 18:38:36 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "Kishon
 Vijay Abraham I" <kvijayab@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH v4 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
Date: Wed, 5 Mar 2025 18:38:05 -0600
Message-ID: <20250306003806.1048517-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250306003806.1048517-1-kim.phillips@amd.com>
References: <20250306003806.1048517-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eacc3c1-f759-4e9f-abe7-08dd5c473bfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DOleu5rROuY+Nw+7kQGCqJmP8uHV/47cpXv7ymIUFDgiwtlbwZi5vNoBDU2V?=
 =?us-ascii?Q?pSQav88huvPZuSPbHCLafrppq+tcCPXSWmn5AOpmsN2NQ2x/2aC0eV2JH/Vg?=
 =?us-ascii?Q?CiYEG8CSC8CNOBNUB4nFVgf6LAj0AFvZkLq0zvO65DJ+4VQR+7DfCs1z2SJS?=
 =?us-ascii?Q?WpLxUTw2ZQDnROdOfznvp1dlpJD8w4yays17FEtaYakMPeZjfStHW++xQELf?=
 =?us-ascii?Q?0uVJNfMowmPEyc0stiEEcrmqgEBc+VqaSTt30Ys5kqWSWlG6UwLnPghe4b5/?=
 =?us-ascii?Q?j7Rq8lQLK7+BFNjinOLKvUqzdPpzg5W8PS0QEWg7+PjKrkrIJ4eJr1J3n+dY?=
 =?us-ascii?Q?EfTUtGQ8Tazw/zm2B72UcHuAS++PdZgIPG38QcIdEmJUPpeHH6d/Ex46QUsn?=
 =?us-ascii?Q?+m2QDUAYk1Rb5YCSxY/83DwCORDHueLlIGelVvOFaREEgc+TKy4klYu4dgjB?=
 =?us-ascii?Q?SpJi+4uxJvFQh0d4F6Wp8Va899ESQLPOjIFojtSoWoyOlJDNfGakIx0ztqdj?=
 =?us-ascii?Q?kqvUtCNwN+D3U/lZShDeWSUQwv3sYVe82o1vNB6I2FaseWST/tGO0d6I14gz?=
 =?us-ascii?Q?lz6xjvuSuj/MBi55DrRN6dLuRSgo5IoGWveYzBW1SGDLnUOMSagqn3HcKz36?=
 =?us-ascii?Q?8618wnawyI31zOccAkmkE6Yph9jWm3JlukVWXMdLp0eE6wQVtnovQf6RZls9?=
 =?us-ascii?Q?NliIZHEhMIeYAFf9wE2Dj+TnzCvim2CSA+nH2pTx+n7E5bqFvFbgtqfKOMji?=
 =?us-ascii?Q?/A3JA0kxZlwaEdrIAf+F/uiSiedGIELwN75A3y5XlWLG2FWXht9moIM2V+Zu?=
 =?us-ascii?Q?56GDnT6z8szsUKOPN9g9nLOFe+S9dxJfSQqpw+xLnlIfMFzXTBWzhQcUioB5?=
 =?us-ascii?Q?7WuCRMVVwnOtXYFAkYUny/1AYqViSv7qRwcnbnxODbgBhqXAMeNtnV/lJEF/?=
 =?us-ascii?Q?ihBBWuOms9BB0c/N1FvGzP1oeu5gzSUT1GhwmdyrakP2NodH1fA2THr55J75?=
 =?us-ascii?Q?IPyg11M9ShSsYP0qkPrz3Mpaei9g4fkK1Bu1dfH6eY4vonCMAzCScGg+jt2d?=
 =?us-ascii?Q?UJl0FqMp0tlxhpfePRU9N31rcwn7NVJWaGzs0AR8H6IXTp4cF3PJdq68unFk?=
 =?us-ascii?Q?7hytiTJXikZvKgSvBHoMGUVwDnP5BNOP1xDstX37XKBBhpauXBdYbx4lo4uv?=
 =?us-ascii?Q?5Sca6xsmI2xLJ3vr1R111+PEoaxbT+5SjBf0To3TSy6Bl5T8nod3Zw+5HPx+?=
 =?us-ascii?Q?MD9erDkUvUM0D58aqE++KJgjUGJyXh3DH0dGkNVIsZNjfQrfNVxtFbblOEz0?=
 =?us-ascii?Q?xmJ3qMAiuOzVrTGqIzSo05vU27lHI9u94uwnKhMlqEbppTLNtd+tlUR7HR4j?=
 =?us-ascii?Q?NPxN9DITWRHLsLM8XhhheF+GCv8zq8gm6q8ljJ8G23MvLx+DTBSK//CrQDwz?=
 =?us-ascii?Q?LoIV9VKXhlM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 00:38:37.4989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eacc3c1-f759-4e9f-abe7-08dd5c473bfe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

AMD EPYC 5th generation processors have introduced a feature that allows
the hypervisor to control the SEV_FEATURES that are set for, or by, a
guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
that SEV-ES and SEV-SNP guests cannot enable features that the
hypervisor does not want to be enabled.

Always enable ALLOWED_SEV_FEATURES.  A VMRUN will fail if any
non-reserved bits are 1 in SEV_FEATURES but are 0 in
ALLOWED_SEV_FEATURES.

Some SEV_FEATURES - currently PmcVirtualization and SecureAvic
(see Appendix B, Table B-4) - require an opt-in via ALLOWED_SEV_FEATURES,
i.e. are off-by-default, whereas all other features are effectively
on-by-default, but still honor ALLOWED_SEV_FEATURES.

[1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
    Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
    https://bugzilla.kernel.org/attachment.cgi?id=306250

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/svm.h |  7 ++++++-
 arch/x86/kvm/svm/sev.c     | 13 +++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9b7fa99ae951..b382fd251e5b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -159,7 +159,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 avic_physical_id;	/* Offset 0xf8 */
 	u8 reserved_7[8];
 	u64 vmsa_pa;		/* Used for an SEV-ES guest */
-	u8 reserved_8[720];
+	u8 reserved_8[40];
+	u64 allowed_sev_features;	/* Offset 0x138 */
+	u64 guest_sev_features;		/* Offset 0x140 */
+	u8 reserved_9[664];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
@@ -291,6 +294,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
 
+#define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..7f6cb950edcf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -793,6 +793,14 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static u64 allowed_sev_features(struct kvm_sev_info *sev)
+{
+	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
+		return sev->vmsa_features | VMCB_ALLOWED_SEV_FEATURES_VALID;
+
+	return 0;
+}
+
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
@@ -891,6 +899,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				    int *error)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_update_vmsa vmsa;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
@@ -900,6 +909,8 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
+
 	/* Perform some pre-encryption checks against the VMSA */
 	ret = sev_es_sync_vmsa(svm);
 	if (ret)
@@ -2426,6 +2437,8 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		struct vcpu_svm *svm = to_svm(vcpu);
 		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
 
+		svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
+
 		ret = sev_es_sync_vmsa(svm);
 		if (ret)
 			return ret;
-- 
2.43.0


