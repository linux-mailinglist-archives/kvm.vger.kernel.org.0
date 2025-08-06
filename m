Return-Path: <kvm+bounces-54191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2761CB1CE0A
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E13C7A75A0
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DFF22DFA7;
	Wed,  6 Aug 2025 20:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BnkOv3ns"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DDA226D1D;
	Wed,  6 Aug 2025 20:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513188; cv=fail; b=qNHUY9X/0EkHpnwWGKMYd2PyB9pvNJDmfZEKtknIspKotwZ9g1q0HO4BidVRlDErIRlfhoBbu8TM2s/aOejqcE1K97PDcL1otUsczxcdOEh0U4RHMoZqawEi2XU5k7Vi+P8AxbinYpfg5ITInUG2HPZnkS6ROi8EQlUwIUFvmoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513188; c=relaxed/simple;
	bh=3miTNC75DdSAUyVzzbp1en1St7V0iHpKeCs+4GmD14Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RA5x4pL36l0pbP86uoWdiobEoQubzqeC+foH4zmHxPK3YFcjykcB7fgswyw8g1vf0GvBiMan1S8L4KPh0AJaSuo5C2p80diP2DBi4PphWZ+55qT8+1yG8ZiTJnpCePabB2jnENaVgRN/HCX9K69LKu51s1RQfZmEfORXJaDIERc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BnkOv3ns; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jkmwaCEkBonyKcXhg7rOp0mYnWvoPpal1NrNX7JPVScx07sjlNjfE1nKVgnK+qibzzTr+LBRCMuQsBcvzR5plDaVhXrt1spcwy8lUq0a5B8ks5djQDMbvwLJKtb5F3fdKXGtD6ugNm0Aqwfd7NvcccGOjtGE0T0Z7uA1yUA52DgNA4VSEFY+BuDrXp9csdtHBIngohDZhkg3y55ZhFHlHso0LNpqqCh8x0C7+rIbtDCTu69KZUNA1Jj1k9wdqXZTLzy9y+tBFEdFNnplRcoeJNKZSC5Pfw1IoJrU9K9K7EYPjJr3YgrY8rAAChUHW16VCXFznKHUvK9At8RzNastOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/DqTRyscTHF4EhsOatDrMY2khVMIeVy75Da9niCr2c=;
 b=Fck4Ek48+/+UfQJFp/+rkoJGiFufLVZvglLo8GL/VuwxdHtgQlQ1t7u6I7Ip8fVsft+hHujEcwrPM/wbHlawqsjzNFZcb6TXPl9R09coIq/jEfdYdaGYAw4EoCRQmCl3JJTBVK6tVW7J2VRQNsqe0fzh7MfUnrPoqzR2KvghGR0WxDqhvjp1wJhRQVkBU+gUQMcRfTu+qe0run6L4Cp+idJO8kuipK2oe8CzpewRuReIizXy+Ts0VZ983iRryVhHE1hf3gSWZiGLYNVab3kvaBLJFWGV+KchAQU3w/tvPVLZ6SioBILkneXe+3TBzeGEds1lMOIQUr1AnXR5e69s2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/DqTRyscTHF4EhsOatDrMY2khVMIeVy75Da9niCr2c=;
 b=BnkOv3nsPaSF9g4WUWs8K5S0qKWRp9DDqeIOci4bJxcIQDVYQAWoVqDyDk8yWFdMP602S9SZDAvca9IliB/4sMn8I2pofGq9/z2sz9FpefPuO8CKA38YrQLojTk/GCBaKFZMRkzEG7AD12rEjFPR9LmXBbIrLHTXucvihbvcv54=
Received: from BL0PR05CA0010.namprd05.prod.outlook.com (2603:10b6:208:91::20)
 by DS2PR12MB9685.namprd12.prod.outlook.com (2603:10b6:8:27a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 20:46:24 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:91:cafe::e7) by BL0PR05CA0010.outlook.office365.com
 (2603:10b6:208:91::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.6 via Frontend Transport; Wed, 6
 Aug 2025 20:46:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:46:21 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:46:18 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 4/5] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
Date: Wed, 6 Aug 2025 20:45:09 +0000
Message-ID: <20250806204510.59083-5-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806204510.59083-1-john.allen@amd.com>
References: <20250806204510.59083-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|DS2PR12MB9685:EE_
X-MS-Office365-Filtering-Correlation-Id: bd66b95f-e496-437a-6080-08ddd52a4d64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZOcOQTr7ZyUp409KZKTaw8Hir1+k1nX16olyExQDb0puifKlUw5WVjRB6Z51?=
 =?us-ascii?Q?unVi3dSKE2jh0mE9jZQ2Ol2t6XGbBrfxutKr/djGNtjreJc41Dk2vdyhlFQD?=
 =?us-ascii?Q?sBoUeX8wJJI5I8SrkMamA/Rz4EbNrAmM+UxNG0f+FoWxYsyxTRedElNFbnA1?=
 =?us-ascii?Q?VXQRHxz4w2Uw21wAeRzlrWUZg62pQr9CmvP74Y7gi6BDCk0kcfo2CUqzf+d9?=
 =?us-ascii?Q?JX3FKW3zIRF1ObEIYe5K2IQtiDUg69sEjd2H0JUqokDybRVAlYDWok3Kdl9C?=
 =?us-ascii?Q?ymh8rdxqAcxYe8HH9VeDlgOv209reccs4QENl51HQ+nJCVlRn5qi7s7itBYf?=
 =?us-ascii?Q?XI3QksktoWz814NDpGzfbbBU3tH2XifHqPG5XzV+8z9q4PKONpMJtqp2XfF9?=
 =?us-ascii?Q?ObksIF6qp/LowNSu4mMy1x5WJRxkg44TXk9eOrVBtOMNGtgodQyKnfPt635r?=
 =?us-ascii?Q?qRNpjA/rcwLGXauiqD64sW9wQGts8mhBNV+UotooXDDuV9nPJdpJI3iw8wpD?=
 =?us-ascii?Q?bf6rYbt8YY5BiLhkqGMTBX4nMviB0G2mtOMd3oE9DIoAImT5Gmeq9LCmRF+1?=
 =?us-ascii?Q?Y5q7CAQzr9gjdJSOxBJvgPZBDjRci120mhtWrD9x91AGM2gL9R9K9wcbDR/K?=
 =?us-ascii?Q?bqunnTL1j+shNmXGCVorW9IgEBfJjbeVzez9L08V1+O51a2tAkTaekWlR4ZE?=
 =?us-ascii?Q?cAJnFhuBbMbehU6Zd02GoHoM97T4KuLcF6mgy+45WXzdvMWcczISqmqrJ0qy?=
 =?us-ascii?Q?JLGzc17huUCr2O4bI8fgwgNgPaWaJes+woSM3n/7++iFRN2HxYLCo6kt6vIx?=
 =?us-ascii?Q?eSGD0Kyngzia3aPPg7pdBAiIjLdolTJcA83ZVW8CcutqUraubcM2LixJLqMq?=
 =?us-ascii?Q?VK00F1mdYT/ldqZwqwjTCkePmRrnJmfoEttP9EwTEEyMf1qfRXtPJnSx4kT8?=
 =?us-ascii?Q?z00YhaFA+WL3SMfvA+7u1aLz4mXHTwrDwuLjZskJBgzlzW9m/QYemZToCMub?=
 =?us-ascii?Q?66zRs48Oy8o7cx4PFmFNHK1U3mM9NlQVfJmTTqyOHyOQhApkoHjl06GiQoRB?=
 =?us-ascii?Q?FjHkYIAOL7e0dhcUy0ByqRcVdcEuKLv09+YRYMBQUTg82bNOiGCLEmVTio6+?=
 =?us-ascii?Q?e1vlhddMo7nfsltBSCAn2aGn3P61ZjnUxastnnDZeGB5QtlheJ+HKUl4bcUt?=
 =?us-ascii?Q?jFrbb1nlbjA3OmUMwswfFRs7Hy8bQOfhcuJFldltj0gAMDV7hzpju/J55zro?=
 =?us-ascii?Q?zgJzf8rzWv+aNPXq4bSN90Fc3JEzzhfUSNUGUB8imFJGIG+7AlByZIeDSGRd?=
 =?us-ascii?Q?znjAPiccFz7EUCA1iJTIEhOp1XPqsiWKMIei9SPWwfGjnFvqrcg99FGSnjVt?=
 =?us-ascii?Q?xU04knMFnfso4u6ew64vHqEKkhPQ14mOu/f1TvM/YAQdg3cKLHLOWsdAA44y?=
 =?us-ascii?Q?eUnDxxQeB6T4QXjWUUgrJUzOxUTzu7KpK6vIy+6UtuIHc18cd0ahGuatfzf1?=
 =?us-ascii?Q?ZYDCqC0PZIYUqstMffyPLQqHvPSV5J5eLK76?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:46:21.9803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd66b95f-e496-437a-6080-08ddd52a4d64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9685

When a guest issues a cpuid instruction for Fn0000000D_x0B
(CetUserOffset), KVM will intercept and need to access the guest
MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
included in the GHCB to be visible to the hypervisor.

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Omit passing through XSS as this has already been properly
    implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
    accesses to MSR_IA32_XSS for SEV-ES guests")
v3:
  - Move guest kernel GHCB_ACCESSORS definition to new series.
---
 arch/x86/kvm/svm/sev.c | 9 +++++++--
 arch/x86/kvm/svm/svm.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f20f6eb1ef6..2905a62e7bf2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3239,8 +3239,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 
 	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
 
-	if (kvm_ghcb_xcr0_is_valid(svm)) {
-		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+	if (kvm_ghcb_xcr0_is_valid(svm) || kvm_ghcb_xss_is_valid(svm)) {
+		if (kvm_ghcb_xcr0_is_valid(svm))
+			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+
+		if (kvm_ghcb_xss_is_valid(svm))
+			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
+
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index dabd69d6fd15..b189647d8389 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -925,5 +925,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
 DEFINE_KVM_GHCB_ACCESSORS(xcr0)
+DEFINE_KVM_GHCB_ACCESSORS(xss)
 
 #endif
-- 
2.34.1


