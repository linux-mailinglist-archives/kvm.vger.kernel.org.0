Return-Path: <kvm+bounces-57009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E88B49AD9
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB4097A4ACE
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96EE22DAFBA;
	Mon,  8 Sep 2025 20:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hBqTlD61"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CC526CE07;
	Mon,  8 Sep 2025 20:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362715; cv=fail; b=Yw1F7Yl2iwtannIyBkAo3I+v+3E/u9Ndnl41L/nX/+iegz9CFQOv53T4cXJU60WtLRiVX/m3u398sHm9u7I0ygfdi8PvR0cPXl8D8NxsfUpPOnMGQXsxOrqs2AGJ3RKiDKfrKSmJNrjtRKOj3BWvr3d+57m1W5q2InLElDLb58s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362715; c=relaxed/simple;
	bh=eZDGU0mOy74QJK2L/sO41YZ2RArNFBV2rQ812qn2vMs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UtH5gZN6VJ5hEtUFtnVEf1nHUFORDU+j7ZUQrbj4xzYUw6Lgm+upk7ldHkYatfLS2SrxgvnrKXUN1Wh++r053cJOl/ups3a1+Ec2isimiF392ZIBoNxkJeeLDgQGfJnOZyDBZCdrcGlA7aSLNpwKydwRyz2g93btFp+h/3Cg5qA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hBqTlD61; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tE0TilkOo5y5J1nAwbzdT9wMHOwBMMSge3aGPTee7zf0/+d1jCHhFM6175P7glCV49tESawV7IBjnsA6KICE3Yb5GHCKBEIC9XbGbinKKlFgrPt3advQH7QrMdRixfHkJZj6tgzkm52hKFerY8N0YVrBnU4Y2UxEn9VPAg/TSk0sjDWFZu1OOath3+1ZXwwwtpcWw9FKP5NxfZw5oqJpfjZwOMzqJbnSTlD4opAqzSuFcUqEKNSF2bB17Vh/x3KNSwdEIzQ/mxh1/NR+vwpJIVj6azMSyxtcaMAETRCX1YmnWQlen2C81nj9fBhL0DfReVpKQr4RabDBXeBgvUvILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWQaZZ0ju9oOKTc5WJF6pNREFplEwEuJwLH8qRpTetY=;
 b=jKuoo3fuSJPfG/mC2wdots+yy6472xIAKW4qJWtaasNorENiqqAfqnKC0ik9NTt1E1BfyjiLmpJ5oKsuk5uBEg63TpkZFRWy4q8XH/eTpooN949E6U1TyrEA/PLZNQNoARhtL3Smz0079Y6uFy+WGKt0rvx+KjywmCGsLDS1O9GYrMREu604p9BfW8DbevaeHWCfgtipnpv9CH3tw/WnVbhmJrC8UzDArOJfUPJEWMTv3dYNRWJtBMTfnOf8qB23SJ7BjiDWYSDl0wpJQS8seI9ycLEhS+qqfgO66dVCsIJ7ueN0KRT/2D7nPW1wwtr9VpI9E92ddR+Aj9+kCxiiAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWQaZZ0ju9oOKTc5WJF6pNREFplEwEuJwLH8qRpTetY=;
 b=hBqTlD61JkhSEGPfMhORofijPx9WEfvJy8bm8a/hTD6JrLR92EWQrhPP7pIS7sy1Mo/9J2oCfpcq39ENLhWPHLdaiibOSgXkQhJd6Ub33/0KK2/hqDcE//wA6pqGEwQW4DcqgA+bN4TfR3+kd77TptdKdhqfzd979JinvTvuk1c=
Received: from SN4PR0501CA0038.namprd05.prod.outlook.com
 (2603:10b6:803:41::15) by SA1PR12MB6996.namprd12.prod.outlook.com
 (2603:10b6:806:24f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:18:28 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:803:41:cafe::fb) by SN4PR0501CA0038.outlook.office365.com
 (2603:10b6:803:41::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13 via Frontend Transport; Mon,
 8 Sep 2025 20:18:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:18:28 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:18:17 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 1/5] KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
Date: Mon, 8 Sep 2025 20:17:46 +0000
Message-ID: <20250908201750.98824-2-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|SA1PR12MB6996:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cdf661f-6ba0-4ad9-def9-08ddef14df4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZRKZ9XMqAhO9pZEdFbaM6jjx3KlyzXFHHK/qkDI+pBYFCXkruULwjQhGg14F?=
 =?us-ascii?Q?ZAJYgKaN6+I7xa5Ghu3Bmm9KW4hmQ5rA5WdITnHfPzi89Tnqdt5gdYxyDhG0?=
 =?us-ascii?Q?RJd+KoKXveB4L8cWLhuwqCgqkLw/43JZ0qEL51vvtFpHlGkhq2s8wKl3W73v?=
 =?us-ascii?Q?w2kgUmXqXg8XodE21S6xBtLgiWb7guaLO/spZNvIzsBZmaAI3JxOriSkXPhG?=
 =?us-ascii?Q?O9WoJ/i9K3WLk1M5H+uFdJ2K+2tuQ10zC4lFePSEEaYfyCS1obUNcDIMOjPo?=
 =?us-ascii?Q?eiImWhQPNMJTutijpwZzYW79edi025+NYKzUGP9A+ZHGllBFoHBs9eBh3Inr?=
 =?us-ascii?Q?xtSftlM8earyI8fy2J9E+JDqnfmvK82T05w/0Uyx5hlk0kQj6YeSvBDFzWZ/?=
 =?us-ascii?Q?QqafHlpr7yEt31kWA/jPBNkoVfFIQYx6Byr3w3Aqk6HeebsOVb1IVqKMSL7i?=
 =?us-ascii?Q?z/a+Ch6lqPWBIkddmIEeckWMLWKn6n2l85wuz5J9hOVsn6BI6m4VjZU+Ad9u?=
 =?us-ascii?Q?qDeDuKFi7Q9LQEORDZ+zfOrcQt9eYqrDMtBZS2OH26Wf0VAmADl41jCappnL?=
 =?us-ascii?Q?w/oamCwZpsaHyw/kqvKTUpSRKyipqngaDLIe+rmtPRpxJoxklcK125mpjJI+?=
 =?us-ascii?Q?3hOVXKvJpgD87EDPlQKheVfmpYpSEyKE5Uot+pJPtzIyM32GVqSE5RoWj7RX?=
 =?us-ascii?Q?n70u/NZmtBlh1oCbVVBAvBU2C3hfMrdLEe6wsPiDjugApOPcubNLwFEHhrON?=
 =?us-ascii?Q?hLx83o7FXBwdR40pKknrHMFC9nVH73Ym/qhZck6CkoZjCQnW2H+ZAbFvbJdL?=
 =?us-ascii?Q?EbhqVIsrAit8BhMnemTgov6ETkA98M4ep42bPyX5mKDvzYpP//ESguXct9HQ?=
 =?us-ascii?Q?1UBo0t8XshMuBytkBbc8x0EXNTTTuOYEzRgs0sM9xfzpO/Rb7qFyV4G8dDWw?=
 =?us-ascii?Q?BigjfJ8ur9Iw3foCGp5324tYgRAAmQERGuh23OPUgui4GCgGFLdYk21qV5pp?=
 =?us-ascii?Q?rpuMoTuso1mcw5qe1BttXTep12ichH1uHv65tN0Pgeo32v7WtHQg4IbSdGNv?=
 =?us-ascii?Q?3qt5PRP/g1hEnQKfKWPZ/o8tkIghZv762F1/Pj9RtiTOu+8i2YoVBYBIyGW1?=
 =?us-ascii?Q?k5NWilJgV8BRYdqD9FJpG3w++cXbSX9B0JZilsMzSzsJfj4jgBKshuUJeiJi?=
 =?us-ascii?Q?q6vcxG15JGOpdtm4F2+lj1bNIWKIWNIDhCb76NTql/nhNKkDMr/SqxDrdAVv?=
 =?us-ascii?Q?RNPO55nKW5b/aOGqIQHSGe3ShmcyDN7umbzcPp5PzmSnjOGSl9tuuuVogZaO?=
 =?us-ascii?Q?fyrFVqc3qvZx8q8kiPKM0rQbbUrr/JMsU4/ApE6qS7bz1dccZJPeXTcRpY1c?=
 =?us-ascii?Q?1eui26Bk4+I5+J1ilbtMRU2jwFWRz2aoaTe+mUfPsQ8z0Q8w7fKUUoqybYlG?=
 =?us-ascii?Q?gwuKNEznHVCWWBkYqDlBJmY9bzD6o4k5fgZ3Wyx9yiIXIPzguK6E3GeN2h8L?=
 =?us-ascii?Q?EjoZJKsuepyNaNXq6yBi+p7y+Ar8jQkCGe6/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:18:28.0501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cdf661f-6ba0-4ad9-def9-08ddef14df4c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6996

Emulate shadow stack MSR access by reading and writing to the
corresponding fields in the VMCB.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e4af4907c7d8..fee60f3378e1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2767,6 +2767,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel_compatible(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -2999,6 +3008,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel_compatible(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		svm->vmcb->save.s_cet = data;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		svm->vmcb->save.isst_addr = data;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		svm->vmcb->save.ssp = data;
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is always virtualized for SEV-ES guests when the
-- 
2.47.3


