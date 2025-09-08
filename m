Return-Path: <kvm+bounces-57011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6830CB49AE0
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:19:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0ED1A2082DE
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA8B27E049;
	Mon,  8 Sep 2025 20:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lkYOEuHL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFC82DA76D;
	Mon,  8 Sep 2025 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362730; cv=fail; b=pshmMc1Rfsmm1RMFsJNYtuH1MNm8rUR6nTO0z43gaVXmR2qGeadVBxNtBOuMzjTcTcuNWTEbV5mtuVkkRJrEkxW5rnZxjcyTFUn4qoHmjnbr4HQe7y+M+6MDjC27l4tuEZF6OfgdO6KJLZsdyTRy3kSVJByZ8WKqFpBt6DEQ8eM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362730; c=relaxed/simple;
	bh=L/eA96Nb/Ry34p0aMdmGrFZbNDjnocY069O9xA+awF4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jec1iV1LtDCzK/z034jPQZRhCoAglc2AIccrneRTkOqBlMr6XwURRQrnF7/9mMTeme3wNFI9sFSBs4L4rW/0XFleEP+XJtTSy/X+Xmtm8WhSXICrxN0v3Jo5VeeWlzkhgp3rWL117kGAtLAzm9eeg+U1MyRbwCJnRI7KmZXe4ME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lkYOEuHL; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SXfhM023UBlQ4/AdGTCcWwfI6o0u/DycCDnSWEyREAlgRh1zbYZtGiEV1FIGIZfyRiApbYsIs51BMSyuKEuHYuLGoWB90n636xxbJ4B3QPqqCEnMliziY6ak/3WN/rI6eZARVyJdk/XlMFqV5BJ7su7Txz/vtnbZwBuLETAZu+SGRGQPOEy629MW1SBisrGv5F0JlWPXBglVgb93T5GJui5nCY+l8/t4U72FF10C73sThUDfSmtW6ICTbf9ef+4NJaHYwYVnS9oIZCiHmRxiGCxuRUr4IgygZ9Ony1b0GXV9n7p4jujL0RZc4S69T4eET6WLZ6Doooh/CaufBJGARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FwFb606ULAiqaezqrpdukoHyBqGS2WOQyoOPVLJw4zk=;
 b=E7NomZ7WqPtUj57Qer0BKKcI3SfefMrpb/Q7TvW1Df3rljovi3Rl1VIvAO4cltc4owdhVLaK2hbNO2xAYpBrn5GzZvaRH7YrbwzDzJboI9Wn5M0aSTFqOIBDfuB472Lopun9kfLz8WqUFfYUVR43aDa5kIzZZsu79eHURDeMflFw38O18WQ7IofSsgvIJUjhzTOcm9UUdTs4TYaVyEvEh0jUkdpj/DNiFpWmYo7MFvc4+BUWLwYOFUEArUqZxlLqqSnuPkx28kLjfdCM+Tyh53+ZrTwbUqDSgXfXuFjxuhEDpeVS+t+43b5uwxIKMnEHgdZ8gF/ZkYpUgc0Le7zEOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwFb606ULAiqaezqrpdukoHyBqGS2WOQyoOPVLJw4zk=;
 b=lkYOEuHLiWc6bEHaGKxQ+WJQe7I+T+ihL/bZ+sbUTd4zDIeMemGNkNvZhq7QFtZbbAVjljFy4MFQdli3zsYbEhcMGcqVUU1nOO+Hoexbm2iYZNAlCrHxIDivm4Xsaw1HxrhLNigZw4n1lpbnnf12K3Ug2MpuRVWbPAp91EoRRI8=
Received: from SN4PR0501CA0042.namprd05.prod.outlook.com
 (2603:10b6:803:41::19) by DM4PR12MB6160.namprd12.prod.outlook.com
 (2603:10b6:8:a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:18:45 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:803:41:cafe::92) by SN4PR0501CA0042.outlook.office365.com
 (2603:10b6:803:41::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.14 via Frontend Transport; Mon,
 8 Sep 2025 20:18:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:18:44 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:18:32 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 4/5] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
Date: Mon, 8 Sep 2025 20:17:49 +0000
Message-ID: <20250908201750.98824-5-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 309bc9b3-0241-47d1-ca22-08ddef14e953
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jAk3Y+CNvUg/iqYzDiavtHzd4HpQUZ+t68qPJfDxz9Q5MrHnsX2A7zt6TD7V?=
 =?us-ascii?Q?vT2qPMfYV4WFmuU2xfJQj5cnhPHwQOFW6XmkKUnlfB6MwaddtDmwU7+PP9p4?=
 =?us-ascii?Q?MpmhSFTDYiWDKHBThY6o+RJQm3XT/X0dUUnEtTT1QzLhF3wmegS545f5zupG?=
 =?us-ascii?Q?q7uZin6ljjEzUPn6tJRTkQyS75S2fMwJP5E/T/I49y7rZdQLRif0Moo9B+8y?=
 =?us-ascii?Q?DvY1tsZe0j260qAqyWbYr9AvkJCvaXmNV7gnUl2VvIV+nUKwjRJJVYA1HM3F?=
 =?us-ascii?Q?eOPCltvv9/PxLjPSAgINyTPEuSKOVfwcy99jbdduJbse2kZnCOBNt4QOuj3z?=
 =?us-ascii?Q?Bdihux57Rs0etFgAcGgDxTdtad5/jqUV8zLGdbIDEuf0wfSn5QttDrsTGKp4?=
 =?us-ascii?Q?gfztXkk2GBg8M0BR/sgVIa4CP/vC4DCVEWi0Dq4RIaW6jLNrH3E8YObR47tt?=
 =?us-ascii?Q?+wZw+hx6TLErA5/GfXTcTG64lF9ovBkUJTHYLM/lxUMNQaZS5Gv9zdTl09Bt?=
 =?us-ascii?Q?xhLxijO6ahGzeshXY2Sf2Kr6H73KzNrQCKHRdGeW553gQXc5ri/OmILaOV7q?=
 =?us-ascii?Q?/aWNMT6YJ3zUpYml5QzPIOcTzQMuLAY41daBl4+B5MuK6fFoR1gEg3mvQMYl?=
 =?us-ascii?Q?9kmdCKB/yQz75ADzlupYZ0YYpHjM+prCaGHfZWHrVVAScDxLYWCc01OuuoNG?=
 =?us-ascii?Q?L/zbZnaJHybzdFLYCV1YTLIRYistAy6G1niB3vuOWQ0q8z+64nSU1ZqPSYg2?=
 =?us-ascii?Q?ZqR2tExqAz59Ff0M/txIPIZde49XYU8ophS42eYoLQ1hJeaKxEiMTMv/zs5u?=
 =?us-ascii?Q?j/AandKWDGRNU40SpG1/ql5Cl7h1b76GU8QtvEOwLv+ESdaVp43/TzP2Q/0h?=
 =?us-ascii?Q?nvEZY8XHQ0f85ZS/Q66DhrnyMZGfVLkD+nLyrKif75I31WEUByxTTvlT+5cv?=
 =?us-ascii?Q?W0Ivqp/L+dEEHs/NTq4JSP/6cM86iK0wO7VfmKImTqSt9gMeD7o0VEq43ykt?=
 =?us-ascii?Q?fEtbEgjKBLwKiktycCx2hL3Mu9Qmi7F5gy8qN5eF6evBcrUhCcZ8/kItQp49?=
 =?us-ascii?Q?Mj5q8bIGdKP/2vxPAlPqfsF6fMCeGKcuEkXmJujdx3gDetywVwU7lFuCnXtA?=
 =?us-ascii?Q?9Oi21iU1kq0JqxHXQVrPVANN+O6bwuZaOFifGi1YdKfza1PQ2FBrKdmbVLSN?=
 =?us-ascii?Q?vymfEuLP+ysJ+A6NdKvL20V9wHRhBXOrPFI7TPYnKoErgt+tXmk3XzRkpf/e?=
 =?us-ascii?Q?9HD3sLFmO+vlzuIFbuioU5gFzdj8zPc1cLuE7jOTD3sfxaVQNwV6vebqmzDQ?=
 =?us-ascii?Q?Dnu1fgj7uS+soGU6pc6DIycN6CACNyj4635pqNA6gw961f+YEhaY21jHBGbc?=
 =?us-ascii?Q?pzReYMdCwMhzbjzobd7H8LOonpYUg+DQQpPsbC8L15ryquYRSgoVRIICS0Z4?=
 =?us-ascii?Q?RSNAadgODXbS3mpm4xPBlmAaXkT/BIi9LZ1X8+OFG4oM2yqBqyoCbwI57dBY?=
 =?us-ascii?Q?wu0Qhd0PhP4t/7kcWJJCWYkZiQCQCtecFvlx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:18:44.8719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 309bc9b3-0241-47d1-ca22-08ddef14e953
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160

When a guest issues a cpuid instruction for Fn0000000D_x0B_{x00,x01}, KVM will
be intercepting the CPUID instruction and will need to access the guest
MSR_IA32_XSS value. For SEV-ES, the XSS value is encrypted and needs to be
included in the GHCB to be visible to the hypervisor.

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Omit passing through XSS as this has already been properly
    implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
    accesses to MSR_IA32_XSS for SEV-ES guests")
v3:
  - Move guest kernel GHCB_ACCESSORS definition to new series.
v4:
  - Change logic structure to be more intuitive.
---
 arch/x86/kvm/svm/sev.c | 5 +++++
 arch/x86/kvm/svm/svm.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f4381878a9e5..33c42dd853b3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3310,6 +3310,11 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 	}
 
+	if (kvm_ghcb_xss_is_valid(svm)) {
+		vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
+		vcpu->arch.cpuid_dynamic_bits_dirty = true;
+	}
+
 	/* Copy the GHCB exit information into the VMCB fields */
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 	control->exit_code = lower_32_bits(exit_code);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3c7f208b7935..552c58b050f1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -935,5 +935,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
 DEFINE_KVM_GHCB_ACCESSORS(xcr0)
+DEFINE_KVM_GHCB_ACCESSORS(xss)
 
 #endif
-- 
2.47.3


