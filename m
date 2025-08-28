Return-Path: <kvm+bounces-56095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA5AB39B28
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE08C1C2848C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D77D30E843;
	Thu, 28 Aug 2025 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vWvSY7kp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082F830ACFF;
	Thu, 28 Aug 2025 11:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379525; cv=fail; b=OuCCiwUjQha/aO3oy2fpV79YgUo8IB9QHbxcT4rN789fIAUxJtpJXbpuZy77ERN2nYbxStbOAd96uc9tK/YSaPAH8QcjwP/Qa3J+TLU8hVNqgBxdIjPCYy0LSBpWGxSm4ADjfO+y3iLFzTJUTGlFnEpSTQ/p75eW3Fdtk6M9QMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379525; c=relaxed/simple;
	bh=LUybeevfvDar4RfDPkewye/fvfF450Txirnpz3FD9mo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ikxZjiN/F6x0n6zAWwZ+scf0o+Wq5yKoI5o/eZ9Zf42tRdaqgWjzz/Hh/dIEVfqlSwyqQwziLyO977u9RHpVDeRcfNOQzDaGNnUVeInCqGy0Qa1Vo8iW3EUU2f2knjuKwWGMhf/z5zkphSb/mVKVJB4qr3bigfKuhgPy77dINY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vWvSY7kp; arc=fail smtp.client-ip=40.107.237.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWvvNxlF0KeuHWWfpgBK9/l+OfHYYlJAGoPQ0GfnP1EFXtYiw+qMxdN5G4PYbr37G6OyVczgpWNlWNZRwhm1gM9RY82oGoC6axx7ODYyPUai0BPVExFCmTr63Ekqc9im9wA26gxK52wiPX5b0N8ogqeTM4IwyD2zjPFk4FhjSgzXaiJLywzfVWMBCx189Om86t4Xcm6HL0OeZAnUPskdx4kLpG0Tz3W8rf/jgzg/fu5kXrEmX43lyCaqUhWUqX0uaYABD8n8FGd8oJD2LoWsrsrDRHu5JHs8m6ah8bWfzP8vwHJk+9udZ9Q7mP9dQVXQazBEEja3veNPccG54vMi4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsthVE1stRrAm9roQk6UnvPsA7eOZNTyUJ0nFFZCAso=;
 b=uGCk5gtfQKerHhrqA2GSpFevvITvcKjZS4jFl6xwbBZmm1Bt6rldgrN6me89nwlwYMb7Pc73LLWRgZq01TnpsQGOroxWkH85lPTyBFwsIwgn+niiEwOm6eoijuo0JJCKc/+X1DHnwMSKP3WyqZviPfFJzYd2Au1j5k4MGfhyQ85J0RswqbrWIakekTsU33QRs3MfDPSd8Z6HZpzUptJNcTxtitktKcSgTjvd2+Sj+jpsyaLOlOlU93pKMNHQDEbdY00Av3fhpAkvClTyb/dJyYROVogjDXRaCZblBBe8KoBPrevyvg8vhDSQiN2fIPBe6XNPZ9/YYH6iW8k/H8gHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsthVE1stRrAm9roQk6UnvPsA7eOZNTyUJ0nFFZCAso=;
 b=vWvSY7kppScPp72WZPvIbKvI4G2F1zhUepLqzgcB6SlYhhhbiW3gRgLob5e+nMSNcA5kDKH8TW+k8GygAySiLdsaID7eicLyttDRivCmP3lsFYuMHAR+ikGilH5uMs1BQUiAaaKJNsAcZuydsOvQrkeGynMwxf/dbXMybtNmGdU=
Received: from BN1PR14CA0002.namprd14.prod.outlook.com (2603:10b6:408:e3::7)
 by IA1PR12MB9061.namprd12.prod.outlook.com (2603:10b6:208:3ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Thu, 28 Aug
 2025 11:11:57 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:408:e3:cafe::2) by BN1PR14CA0002.outlook.office365.com
 (2603:10b6:408:e3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:11:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:11:57 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:11:56 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:11:50 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 09/18] x86/sev: Initialize VGIF for secondary vCPUs for Secure AVIC
Date: Thu, 28 Aug 2025 16:41:41 +0530
Message-ID: <20250828111141.208920-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|IA1PR12MB9061:EE_
X-MS-Office365-Filtering-Correlation-Id: ac430e56-1284-4d9d-5ccf-08dde623b3dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b7S5npuvGvUgjqIE+7H2MP+VFVfCMSpbcvLeAVGHImG886GGKrWXQceWU5c2?=
 =?us-ascii?Q?haNoujk6B6O+CKmVM8KCYVoGgoS577TOVKxx1fWZNBAdbc00FaBBnBh4eHfN?=
 =?us-ascii?Q?CQ/4d8LwvhLxTlDFpF8afHC5KXuIvLoh4k4HAMkWCWZ6/dSx0nJ2i4IQluwu?=
 =?us-ascii?Q?jT+PxGMQM0EVqa2797ciCtLA01PeJLcYBZPaAOzofDFePDUGzLDJTK/0pva0?=
 =?us-ascii?Q?r2kO79GrRDSWoON7PB/jG0mM3/8RLTUrX7a04j9QeGDWagWfJpzHGmRMuya5?=
 =?us-ascii?Q?lQ2/Nd5y/qnyp6f49xmXj9AkewmiUlmQ4/Ihz2GKu3yl2T4eVIUPTNdzm3lr?=
 =?us-ascii?Q?BlE4hDueV0+WUgmHGz2TXXKK8RdRNXXwjkojXUzKAV34JbGzRCqkU/KQRbdL?=
 =?us-ascii?Q?xjM/h5gaFT0jcJ/zcKn78nK1qOxvFBbJLfK0Qzv3EqzZ9NyUTIp4dmBc8xLM?=
 =?us-ascii?Q?7p/i+nM3fKfK22HSRmpknQXMmdkdDnW07JDwUasKcSTcvjCPrzeZ0WDpsGJn?=
 =?us-ascii?Q?eB4yMr6CvkzAeK6Rxw6bgNsnslcaRvxI9e4Ls6vN4VDj7jBKasDJZ+bPty/1?=
 =?us-ascii?Q?AAljbBlWa5UgL63qIC3QepXb75bf91YFuKYpeXvBz/OD25aydWxEqnEAdT0r?=
 =?us-ascii?Q?VPLsGnY1xH/MrfYKKrwi+4W3mKbkyNAGEAEiIe6DpUVJPsmg9T0VVIp+oFMM?=
 =?us-ascii?Q?v3rUePuyInPQJGSUGp8Gc5jyB4+o29dzCVAZraCq1omP/qR+HgW8P8x7VtB0?=
 =?us-ascii?Q?1prJ23pVkS7ory4pqJpxk0McOxLozV8ygr6mRpLj2hGJB+3/jxUyCtp5+vb3?=
 =?us-ascii?Q?7fQS9fcXVXfwQds1AhfaCN1LrUEgRYtAOHBC0l37utbg2ItGG6mpwdNe0qK6?=
 =?us-ascii?Q?R3xUy3cXJLr5hwaH1Dr/duPuaiD1mOGiMi//tQF/djByInD5oTTiOcUpEwbu?=
 =?us-ascii?Q?ovFBsV950mJgqAESDuEXvuEWnngloSvZ7WBf93oGBf+tMXY0rNSzCE3SBT/+?=
 =?us-ascii?Q?KdDOMRBMlRp7E4d372GaKHsb5hJPNNIAFW1oNS7GTSyiIXMdsHKUqh4PBchY?=
 =?us-ascii?Q?GgZaiV613YFcqfoe9Dyo2dKhFNUL3H/58OpRnlt3NFVBYBRCcWHV+nAdLjeP?=
 =?us-ascii?Q?xE19J96Dkh9Tf9R8SVQj88zPkFGYKvBRdFVAD9BngdwpkHgZ7mIWks5Tpy5Y?=
 =?us-ascii?Q?HkGCXqtJ1EkwmJ+wtOf+u5YeIl4k0FrtqiVliXWpOIADFoNTZK8pyXJgoikf?=
 =?us-ascii?Q?6mfJpRGWiihFJxBJfzCnexP6r3rokDh8MQp0krc0NOCJFSn+6aZSuU89QNwt?=
 =?us-ascii?Q?5dL8StEdwvJ0FlI+/VMJ49i+3Y+HzS6IPkl3tc9RBzt3CXqDWxDIi6Vupd1p?=
 =?us-ascii?Q?1YN3uVNG22aIZqJUlIvYElc+NKli8dpuDg3DtOJV2NG8wTN2fZd9Fige/g2h?=
 =?us-ascii?Q?yaE6pZc93sdCW+8jTSohQoywWkaJJzgZdJlwMSm5IFDLv4T8DHu/R+C3KT+/?=
 =?us-ascii?Q?hukpwAquv5tF3vit8OqmEst/2e+dkHVJeOVr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:11:57.1846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac430e56-1284-4d9d-5ccf-08dde623b3dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9061

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Virtual GIF (VGIF) providing masking capability for when virtual
interrupts (virtual maskable interrupts, virtual NMIs) can be taken by
the guest vCPU. Secure AVIC hardware reads VGIF state from the vCPU's
VMSA. So, set VGIF for secondary CPUs (the configuration for boot CPU is
done by the hypervisor), to unmask delivery of virtual interrupts  to
the vCPU.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - Commit log update.

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index da9fa9d7254b..37b1d41e68d0 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -974,6 +974,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


