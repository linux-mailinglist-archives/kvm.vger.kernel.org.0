Return-Path: <kvm+bounces-57013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4A6B49AE6
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C092A188C5B8
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AD42DF3EC;
	Mon,  8 Sep 2025 20:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rS1fEwgd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE6E2DE200;
	Mon,  8 Sep 2025 20:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362734; cv=fail; b=bosWIABsmdXZTHbFRKLI8ClC/TtihDja7cYn2feHfwYwgQrrIRr06PpyXa01uqHzW7iOD9pLp4OZbRkcmf5lVmFm+TSJEQTckLfzh5IvRabCH4NUKuzFXIgkXTF+Z4ZXDjEgFmlWQvTDfw1PEOuAuUtq7QRFHsUqXcFH0QS6kHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362734; c=relaxed/simple;
	bh=vQG4FRmz+THi+QhN09J2WIjTl7TN1E6MPXT4P13B3l4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdHAYr8xxn7PZLkLB/kxVfwGN7lQsWd2TmaSwe4ARfeLhwn2mKqcBXESu4caKx17WpTB1bDiRSUU9sxThWLL5kPq8rTY/EI4KaZfmIZYk8zOcC+b/dE2QWWIUcJ+E3dgDvWUu/P/FOldQDu0qc7GdTL/8a2Ko0X0Be/nNSkk+LY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rS1fEwgd; arc=fail smtp.client-ip=40.107.243.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JrsO2qTVLUzWzktxQs+5LpvgUlbwTmuzKF1RJ/s5VhxV9VlR9M9CmNegjvDKKTE86qgnh645W8JKFkExZC2LGtr7+G21HCy/E72dQPuSUgeuumRrTNYsRw3qbvzK/uevPdCZfLDxyKxluqITutbaQk0NS+LOh83CKwSpyapNyxHw5XdOk8FsQlk82iLcVM3mkalisqktpkrAhLqb6Y/RDdjGAwoXS9wWef7zmq9SlJaIffdhu7rdBjnL3n8asDOI6LydWi+ALwqOYbQr0F1U7RE+F2Seg/YtXO3QPQp7BYezIYq4KV+2crCoIDYtkGsg6DUI5HA+m2obR9cvJ16WBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kxo2tq1T9luCaYRDPYPF2nmSg1dRTmAFVINo+QzRU5o=;
 b=OFDJuIwgyiOmJQOQCa5GIrD0t5XZC/YyonNjy528qZ8owkfsRjw0tyHrFurGVbePzU1wsBNjuk+tAYolOoanKDwPaePdwo0ELGJh2VoJ14RylBNFdtdwzKDVsfq3P6rbMA050XrboRK63Kr3G/ovrdnT2zwbfVwWk8mLMNQIShIb3JyAilRTz6P/FrZmQZrWComU5vDEjcU+T8+/Z3oH8HWz7a4GjS96DTNlK3xn8EwP6AN+YJBfK5uHOsfE9kU5Js+wQZ7WRNvGiL+yw57kYvYHZbvpuPFYqUTzARt+bmcmxkPmDRj8QHyZJ+InJ8D5AjowgZhK/ZumPDFdG0WTig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kxo2tq1T9luCaYRDPYPF2nmSg1dRTmAFVINo+QzRU5o=;
 b=rS1fEwgdDEMR56Pj+KCKrOlLajZLd900g5Uwpb76hlK3SdRIr7DE7+ZIxAH0hCqu2VRGmXbzhGE0sHsCPu/whrAwMIBdDZJUdNwOxFVFR3i7zZNELIlPP6XpuSm+ERYnoKrNxqzdYrH/DvUSjcXxctoz+nHPL9UmHXp2+4QRlSA=
Received: from SN4PR0501CA0066.namprd05.prod.outlook.com
 (2603:10b6:803:41::43) by MW4PR12MB7031.namprd12.prod.outlook.com
 (2603:10b6:303:1ef::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:18:42 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:803:41:cafe::99) by SN4PR0501CA0066.outlook.office365.com
 (2603:10b6:803:41::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13 via Frontend Transport; Mon,
 8 Sep 2025 20:18:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:18:42 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:18:27 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 3/5] KVM: x86: SVM: Pass through shadow stack MSRs
Date: Mon, 8 Sep 2025 20:17:48 +0000
Message-ID: <20250908201750.98824-4-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250908201750.98824-1-john.allen@amd.com>
References: <20250908201750.98824-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|MW4PR12MB7031:EE_
X-MS-Office365-Filtering-Correlation-Id: bc6db6a2-abd7-4658-9ae4-08ddef14e7c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/BRb3NQK9G/qyRGD8BGAKFJwULIrS2fr+wIK/ftjSV0Pa9qJ4/P3lufPFCwf?=
 =?us-ascii?Q?R3AKw1reDFWJVZMM2Lv+G5ZR4Qxk7soqyQF0mGf9gN4UdbCzVvYnqgIwRhz6?=
 =?us-ascii?Q?B12efTT7ZbUniOiV4JgSGYpK2i3uTx44bVB1YizZk49zTAw5ZQyQodC9iiAk?=
 =?us-ascii?Q?6d7azyYgOnAWlhCSUML3VM+ynoC5tCiWp1obSiUeOZieZiF4W8/M60LO0DHu?=
 =?us-ascii?Q?ESzYwfgpAfyYecvKHB8PvDBhNpmKoU+pF1TLWOfblqTFqTClXT25IN/1mBOT?=
 =?us-ascii?Q?2IwNclCFX2B9Vf6pHuOVluFzros5rXCHnAnmqc/0LNdGKs/LUFc6M1jIWLyt?=
 =?us-ascii?Q?Cr5DpSMHKNxj3scvB9eFW0oZCB2LcvL9bLoRXZ9OrutvCsoZDNzGDBsBJRZl?=
 =?us-ascii?Q?hfZ2RpEiGztJa5Cr+H536Q3DhQdxAOIQFtOjgiUSWpNWgHE+ovmFeM3gZzW/?=
 =?us-ascii?Q?LG/UM09g5E7JH0PxrdRGmtVAhqDd8A0HAIrUolTxCipgS71e/8g99dJKrp4v?=
 =?us-ascii?Q?ecisI+Qavqtoe9UiQiTEamQ0w58+afVkEV4MJd2XusMV5T8bDik3f30drfxi?=
 =?us-ascii?Q?0bxP7BqHXCn01/7QexB2hvyXxFYMRwZbbqj8oXxKI8NjPUdzb/h6BPXMlwPe?=
 =?us-ascii?Q?pkzqDDr8+bKwGtLxNLmf+62oiX3BsVy8rql9zAFfWrgHNAk5Aq148z9dAC1A?=
 =?us-ascii?Q?y4pblCloEngKPHmzyRpAtmn38ipCFk85v0VnVP2KyxNU1VH83yKK04XU6hvT?=
 =?us-ascii?Q?tgUsKWyDa2pRBYlpqyXD+cYhyZ4ZNyiOwW6NPq6UGsDha1GWam43eLBEvRHZ?=
 =?us-ascii?Q?GmNqzLrhCeNLL+w9lDCzKtG79qbhuDYj0/zhb7UuqS6sYgaW88cZiFazkrhl?=
 =?us-ascii?Q?I6xg9SJdRBdPz+1YHhYV+QciSRf3SmqKHvqwxyOdHaY27eeW+2G/0k3dsAnH?=
 =?us-ascii?Q?cMPfMp53Zp6qVkuWxS20bPUrp7FzVCGBADUAKSfEYo5GLqhzDwBkXYAcu7l1?=
 =?us-ascii?Q?6fnsEzHPZoR67dYnXHE7zGe9Ox+4fuZWlu7hWwDevG7oJA5xc/9Cyp7W9l09?=
 =?us-ascii?Q?gP0eAWq81mVPK1plde9xF03V/19sT3aoVDcgHb+IzQm2UAHLrBJx/uqTzzJA?=
 =?us-ascii?Q?Fkug6tLK27lGrycDOzKSpJWV0BXV/fQsFy7g+JR6lpmpXlcqHmVgU+2Q6nCg?=
 =?us-ascii?Q?h8bw6YV/Xc8rbEdu99Dx6mR2XlIMAqzm5s6kKUzs4QtLbGbPKSUTaffW4+To?=
 =?us-ascii?Q?L3M/i8Qrk2MPNvRjY5v61gZM3BpvrKIoXTa6ZruTKAwNgtO4S6ceODlig+sv?=
 =?us-ascii?Q?TamaDSlxCb61Av57tdb2OXI0Ir5ukoJjP7D67xxdsm+PkiH6hpLDY9ICLNtT?=
 =?us-ascii?Q?1fViY8fX/e+tU4kTrGhr1LZncI1dN80q6ZDPElXvDtDwXe0LUBkoAUAlk+dt?=
 =?us-ascii?Q?03Znc5L1zWSptRtNLFpVo+5Vh+sCwddDj/3DW2YE90UbY/behDIm3ybmgWAF?=
 =?us-ascii?Q?ha+JFP4jSr90NhcqYjSyW1lH+peEOlou3rU6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:18:42.2882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6db6a2-abd7-4658-9ae4-08ddef14e7c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7031

Pass through XSAVE managed CET MSRs on SVM when KVM supports shadow
stack. These cannot be intercepted without also intercepting XSAVE which
would likely cause unacceptable performance overhead.
MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: John Allen <john.allen@amd.com>
---
v4:
  - Don't pass through MSR_IA32_INT_SSP_TAB
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aee1bb8c01d0..b18573b530aa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -844,6 +844,17 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		svm_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);
 	}
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		bool shstk_enabled = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, !shstk_enabled);
+	}
+
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_recalc_msr_intercepts(vcpu);
 
-- 
2.47.3


