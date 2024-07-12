Return-Path: <kvm+bounces-21498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D66AE92F824
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 11:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05A041C21A06
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57CC15ECE3;
	Fri, 12 Jul 2024 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VAAqt6Fd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7939814F9ED;
	Fri, 12 Jul 2024 09:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777284; cv=fail; b=W6t08N+txQgAJ3rCVxGEKYPAq4Ux/hots6NtJgfsUTtpWbvW/eLx0mxaEykiV1mcd2GFWoHLSOCUVRDXIUjZBnxEj9j6xa0p0Q7Djv+iVnj86oTYqCMPDOTZEnuz38CpEIKB4JPs++ILTJPikWbfmSVXvXSiTm0AGM7cVVm93VY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777284; c=relaxed/simple;
	bh=IoVvaE3xZ9R5+M+fDsytf4UsGiS2efyI9wsyZjQMncc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RtC0alSOKCyjHvg3rDFSItHTt/aJZDJVcYBbsZXk/T4kl7oINTmti7OD0mLbPeWLe3UCnv1Mz7rV/UNsdmPZ2jYDKT2qtVxJhf8Ok/gVte0pAYEZ/kkT/PWe79GxHM6b+fAUitEfZjbG+9+i1FMpoSCxWjZDlXv5gORQ9BIb+2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VAAqt6Fd; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Krrf+ZqsMwEiPy5ANt1EtHO/jwIOlTgjXMz3WckwGBHMPNT8+IumcM+bjtPhcUpEj2nraQxamUW8AZ7HQ7hG5SszKajO34YHc1Tpf8YbX7Uk1f4OyWI+AbHaQd1WyzS4pRer9Uz7XVq91AIOhz0X4Nw1QxHUn2o9VAgIpxB7OTXrdjSUkS0gSzw+EvVokC8DSHfcL8jD4BEsaNhlYr/s3HLYAGMyTB+9rZiqe2JVS4/bGSGiCs7JqIrY8uF6MJOSzjn6i1accPX6LLn18MuiLkZsQFXB7WOFmJBLzkaRuvVCITpy1jMB3nAS0sG/UxI4dTYgPInvAwTNdFikDMlVAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrVvy5wSsYvWEH/zMIUOCM18ZLpeaOVIvu30TvxsVbA=;
 b=oUIRJBlw7QAJtkm6p4SYwk5VbCY3mgrRdMiN9raVcBHT1DBveHVzTSnbGIKsG/ew5lKM4kbLT2KltStC4VB4w3NB9cAgGF9eOvb4/ZbwznodFsZm7Pue6oA8eM/xswKwmaUo423Vz8lLQxxX/cOrLx4k5nc6XV/3cuH3iwQbGKIukrym7p+1Wp0W5f4J2MpqGVsaMsDWrB1tvH41KwC6hdyJIUxlnldUOsr5CEZ12G2KA4wc/gGGScqc8qF6qi4b5Uryng+wak1SHdHw3hbzIHOwBvCGjdzQmFnk033CRLyO6iWEuVO+L2xsGl2HXcSzIj/kAtcCG/yEtJ0vigvpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrVvy5wSsYvWEH/zMIUOCM18ZLpeaOVIvu30TvxsVbA=;
 b=VAAqt6FdbSLiSLHl6fwS/ry7XPUq9jNRNW7/kGF0YbfkuadSvYJXoJ3TXJ28+KodwLGvzkGN3K9rAz0bMPbtOGhvImv/b4w/A+a2mb1gmxHtc/motw1LTCkHFSOdneT7dDp14BkgDNwK7QU406/lwRNuaJljdVnq0v4iI8bm9eY=
Received: from DM6PR13CA0066.namprd13.prod.outlook.com (2603:10b6:5:134::43)
 by LV3PR12MB9412.namprd12.prod.outlook.com (2603:10b6:408:211::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.22; Fri, 12 Jul
 2024 09:41:19 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:5:134:cafe::b5) by DM6PR13CA0066.outlook.office365.com
 (2603:10b6:5:134::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20 via Frontend
 Transport; Fri, 12 Jul 2024 09:41:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Fri, 12 Jul 2024 09:41:19 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 12 Jul
 2024 04:41:11 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>,
	<jmattson@google.com>
Subject: [PATCH v2 3/4] KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is missing
Date: Fri, 12 Jul 2024 09:39:42 +0000
Message-ID: <20240712093943.1288-4-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240712093943.1288-1-ravi.bangoria@amd.com>
References: <20240712093943.1288-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|LV3PR12MB9412:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9915ff-1382-4908-5be1-08dca256c85d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wNYvxpjsWQPQjF02Xbc55SgTukK7RsbBfSzHZBg8VZHer7qkv4xU6zYezbLw?=
 =?us-ascii?Q?ES+xqM/9Pqc7g2aaxR7Vv/JfjKPtZSL1Sv3/B5HBeUzwT9OvIM5KCVEp0haD?=
 =?us-ascii?Q?UWYgJcrWQcFazPEMD//7zEfCvWhBWcsnuTldEvw2k75QV52XQBXAjtDGhaLV?=
 =?us-ascii?Q?6bZh6nyxqhNVQG9j0uJsiOWcTIveOz30eCyXdHKJDMoQJ8X8LCvhAX/ZeZQB?=
 =?us-ascii?Q?iHiqYwjJVpQXNLuwHcCJZD+B9RjYo1oqExXqYUwy1tRNo6sZj1F28ukglXD/?=
 =?us-ascii?Q?l0+rdSuphCUBIffS5wTxuF9lb9avCLE8swmi6WpsJx5/RhqMxgWpszqmNQ4X?=
 =?us-ascii?Q?scnnaZTcUed4zBahpGLlGJrvgSCYcMBhQZmxv1XJQFTDRtlbu3z8nB79kWq+?=
 =?us-ascii?Q?VDPWeO70YmMt8T9UBnGbSfjvNlfjZacRHhf74JxjzqdwhauXUAHlD8F2Lb49?=
 =?us-ascii?Q?x+qZSSvdVZ1ITG1su97ACfNbmcHffZp5CnfN0Uyp9//ANGUt/CIt5CeVZXTB?=
 =?us-ascii?Q?NWc6omedJwCMhD6xKBuEf7xtnkFcz0EjOHbs5/2orQMrf6bTJ36KbLZ64DZ8?=
 =?us-ascii?Q?OkoAOf6PX+JwPs/Hfk97NlqY/biI7J0tcuIuHR/2X3gZCWaVzKcJVtjGIVkp?=
 =?us-ascii?Q?vJGMaBCYBDJCTTspiDhOztx62oOKRtv5adtvO4xpSfDH8oyeUOvX06yj05UA?=
 =?us-ascii?Q?+aThkeCNy1L0noygFtWZyBo0deBNcOg87y8ffBhCyZErcgL8S0bEq74ZmmvV?=
 =?us-ascii?Q?T8OCZaGJ2oQI1EEMtvFTETFpt0mgWWcsXEmTnELpc5UGvM+bySd+LdeMvkd2?=
 =?us-ascii?Q?p0SKvWyLssoVM6qMdbNB0kC78Tnfqc/plOpvJUzTA649XU71pRWpcadtVST3?=
 =?us-ascii?Q?SZAl8Lb904s26SajE6Hwe3VdqdBduxVBpMBDlE2Qqhl2EpBMJsD0aRJPkYnB?=
 =?us-ascii?Q?O09J5qZx2B1xtkj37jjGnq4h5mrnEEke5k+utdP4ecQP9eY4JUi80Jyn0QDE?=
 =?us-ascii?Q?R7u16KHMPeszz7JbYyjcj81tXqoBBaEfJJBk/cbUC0IW/ZST2EZ+tEFypBlW?=
 =?us-ascii?Q?WK6ygxE20b/Wx5I/0iYyK0TMMfUxbzNKi/rYFnfzccuVwFHq5uTCExlQXa/7?=
 =?us-ascii?Q?0ikR6kOtOONXF7Ti2N+OiSqn4Jh1VnwjguuWSvLS4EjM+Pw8zDXoQaeATgWc?=
 =?us-ascii?Q?saWqulE7XUO388vsM5cztu0IjpvG38V3VUEgYTMWpPd2XmFt/WNoz79wvbfq?=
 =?us-ascii?Q?YzzNdQrN+MnKkNvrO4UnDjEYXN/asFi965Y6eYhNw3Igqkb0iW8N6JLfu/e5?=
 =?us-ascii?Q?gsN5OxOLz93V2Vz5OsAqdD8T3J1cT1RsIzErktONQRh4r+C1+4gRVFG6VBNx?=
 =?us-ascii?Q?RKPJN6ExIkE5rTezu2/rG89nXEcnQphpice2FutVR3W9MkRJtA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 09:41:19.1279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9915ff-1382-4908-5be1-08dca256c85d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9412

If host supports Bus Lock Detect, KVM advertises it to guests even if
SVM support is absent. Additionally, guest wouldn't be able to use it
despite guest CPUID bit being set. Fix it by unconditionally clearing
the feature bit in KVM cpu capability.

Reported-by: Jim Mattson <jmattson@google.com>
Closes: https://lore.kernel.org/r/CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com
Fixes: 76ea438b4afc ("KVM: X86: Expose bus lock debug exception to guest")
Cc: stable@vger.kernel.org
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c95d3900fe56..4a1d0a8478a5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5211,6 +5211,9 @@ static __init void svm_set_cpu_caps(void)
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
+
+	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
+	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 }
 
 static __init int svm_hardware_setup(void)
-- 
2.34.1


