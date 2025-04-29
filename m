Return-Path: <kvm+bounces-44702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B330AA02F6
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9222F481F0F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B838B288C92;
	Tue, 29 Apr 2025 06:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qtjo85gp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7F6279786;
	Tue, 29 Apr 2025 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907370; cv=fail; b=DseLZjZq5JNxiCZRO2nWjEg2pX3VugHN8j0coKgxT3hRq6ui9G9qBcYgrMly/RQAj5tymuiwpyp8e7pyf49/vHJuE2DLAz8S/ubXwOcbcgUX3LWrDVI8uHJhF3UuzJM8hLE4zAaH758JieFYyMDS/hpOVaCiemWLCcq0ibwYtiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907370; c=relaxed/simple;
	bh=eKX2kWxR2HKd81OsxRF3xsRokltvx+kMpIKsWuXnw4w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d9gxegjJjQSL8janonVKQnO1N6KO41BR3lYRmx6Zd7cpfOxZrgJutmoQBg1pGdr3qppqFTZhvl6+WHiWYvOjrv5apAMqN8jfIQ+8cLb3yCYZguqpPc1ctSEWrp5mrfBtGWkOqiT1Zw1+TJPJj7uQA07N4+uUfMDCYufuyp56Y4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qtjo85gp; arc=fail smtp.client-ip=40.107.237.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ukhz9FpN9mG5DyrdQpR5qGBGnEBDHhhF/RxFVcSz3z61yo9wqXWqDkg4/a/LSWI9xfoDtz55/+8XXmNdo0a2ihgxuXorLlqjdGp42Lgyx90mMLew6zKYxCnBFLbT+6zU6DL8bC1OgO6TlECaKEiSrC9cD9JqmawrYhzCG8KzKjahynPCImWzgI19RUT+xZ5o0YZE44uA0L1Yiy/mfr6qB5MmZCJaP6yGN7N4EsabZMjiJmLCKYLlzm+Y2btb9s6m9n1wBr/jyNL59iE+dblT7CFmXzdmQEaaHPhxVO7UvCOpALtis45sc6Fd8uXr0c1ltEkCD0DsEVdZTOsw/f2Bdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+djcHnnu6CouS9Hedj74obr+8GS2Rn5z884OSRBarc=;
 b=R61okxPfxkP87bkpwvcB9EGeBdxdwnsYLpbt8jHIsxzAW+wEu6pl7ph2L1IA/cM4SxK4sSXTu79Rtmmw9jQnoBxk3Jz97zKhAnbXWofAQggKrmDVMsYXYay4wR/AJWr18q1pWAM3wc6u4wSVXDjSD+wowUMwD4W70g3hlLdlQP0brZH1KqsUMLcBNcKpf77jDFCqWeyvL0qaNoqwb/vM2okniUzMDoGeDUUoQOR21zTDQChKSRwfbkDNRsmhl0ZOtv7EP+T8qNoJ+fwDvaYTYjAMixwtwguqC1hBSqWMnByCkVv8xKuigCWqFjXDI6ui63aKH3hkVJcg6zwNcyD7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+djcHnnu6CouS9Hedj74obr+8GS2Rn5z884OSRBarc=;
 b=Qtjo85gpT6JLVNiU1pXJCLswIlZIswwEEjnb97yuu6IrweKtyuDPzJ4FGpNuzs54nGloTf4e24AbsuJur07g1ITs+tSdsxNlEhcXX7UEUVGlNo9Enj0zraBfxbkqMoS9W/0dkRO+3kSMPUC87Uo3NSSODZx0RVI0ND7MoGWyI20=
Received: from CH5PR02CA0016.namprd02.prod.outlook.com (2603:10b6:610:1ed::13)
 by SN7PR12MB7204.namprd12.prod.outlook.com (2603:10b6:806:2ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 06:16:05 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::ea) by CH5PR02CA0016.outlook.office365.com
 (2603:10b6:610:1ed::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.37 via Frontend Transport; Tue,
 29 Apr 2025 06:16:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:16:05 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:15:55 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v5 14/20] x86/sev: Enable NMI support for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:58 +0530
Message-ID: <20250429061004.205839-15-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|SN7PR12MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: 47341fa3-8c63-40c7-0f81-08dd86e552da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iiQnkl7TdBV+o9ggL1o11+xcDyL60kzqPERpvPhYGtFMBU3SOUgjovjoq+fY?=
 =?us-ascii?Q?wZbwCV1t5O+jvBKzq1bVLJmfGKG/ZzHwsdHM5Wj+0ub1AlRnhA5LTI0Gc6Vp?=
 =?us-ascii?Q?YKmmMn7VoM0gft2+ce/LETgHl39IDrNHmfmH79Gsaxt1kVPlI7igyquVy1b7?=
 =?us-ascii?Q?gvkznDZ1NnBuQEUdb1jDT8HWnDxvm7KQ2LgWNVqw+WaZ+0sxXC0JDxREpESA?=
 =?us-ascii?Q?YlFhrP4g7jRSn3P8VG8Pv+y8JM1kvRl7WFCM7FnQMN7xPKuiLBi31fDO/BmH?=
 =?us-ascii?Q?3nBhdE67NaUfUxixJdTc8+Ff7wF29EFBsPcjouD93Ers/+DFklKVY2+GVcHF?=
 =?us-ascii?Q?XchOfF4+qHBXCU5zeQxf8TcS9dPMOoX3dbCb3q6iiH+hhcyvgVYV1NlhYdvT?=
 =?us-ascii?Q?8iBs9Uo9d/5LnYR8HvuXGXrKXGvnuQNMwbddOzvX0GwSfBq4dNSYYpyf78xX?=
 =?us-ascii?Q?JPROmqV7vrEt7m2fMXxPw23GJpUp8oBUTP87/LzdRINjcFob6no5hpc/vsfF?=
 =?us-ascii?Q?89oXS0rsnFrsXjyyqWSsMTJLK1GSW4cDq5yJLGM7WbfnebXStz9ReZi13XF6?=
 =?us-ascii?Q?oHalTfKe54yuylorsQGDHVt6tCfCbb7/0OXMqiJdm3MlV5WwlcNKb5wDLR4x?=
 =?us-ascii?Q?PUnPr4+l+zCEMu+CUHLcdKcRHrsNph40la5TF+OzoUfVmPu7PBE0sOnHheZG?=
 =?us-ascii?Q?Aj1L+3Gm136hi/rkR+07CKIOPI/4Y09tPf6VBy3eIreo1CUZDEHrVFXiJEfy?=
 =?us-ascii?Q?1XVil0Go0mlPWYzp9DZvhKsWbfSSTS/q5hi9Hq2cEjCPOjT/AU0FiXoUe1Te?=
 =?us-ascii?Q?mFdtaVR6jocBTmUkQ8kIGZ8LKn7S2WkUpxpjqjIisPowhfaHOlDMTFV9T5OO?=
 =?us-ascii?Q?UNOC5yQ9IDnCS0NudxoY8uvdmEHdoVWda4HyMm2Z4R/yq3UCUxHr16V8Lsu+?=
 =?us-ascii?Q?eWmoyigUxLginQp9X222ClyB+875bUv2KEg87A3pgOVzrzNSxXhCwUhJRHPz?=
 =?us-ascii?Q?/b05B9WobESq9YYzVuoPeV/4OzWeKBCJRl2bv7oauOH6Iht+8ealIbKGLFXq?=
 =?us-ascii?Q?rwFRghVyeW27fQDz5ScttAYK6gWhNb8lhFiCKNGt0BTaU2xh9NGYLIkPakxm?=
 =?us-ascii?Q?uIOEeY3AXOoxbmos0EprSagjo7fT+hsc0Ev8jZw+wvZkOj7CswDH7+9kMa/E?=
 =?us-ascii?Q?j6yuiEeRdeuz46xnQrfR5XZc3bT/ehO82CC1B83OGuVdcqia5VLT0IUwRB0U?=
 =?us-ascii?Q?ln718e7ktYkWVynkkrzH/kcMpSgtdM80TsGiilGwPX2CapXTuCW1yZsT/zda?=
 =?us-ascii?Q?15AY/mUlRFahKM49Xlx7r9f2MQokA1GUkFIbFGwSaZAilsSf8/UQPDZgOa4E?=
 =?us-ascii?Q?pDL1ODZdIZik+NwS8Al6cQphk8e+qYgmSsEpvwvj3s0fRbzMouITxu93KmBL?=
 =?us-ascii?Q?f3C/jR5ZML6nw76iZyMwyNImsBMqXAw6IzDqDk2QLfUraC+AUhvB71lRzd8C?=
 =?us-ascii?Q?z3a5IyTg2xJNF/ZRUuI8vfv7xHCMpWOUmTei?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:16:05.1331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47341fa3-8c63-40c7-0f81-08dd86e552da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7204

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
field of VMSA to enable NMI for Secure AVIC guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - No change.

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 1c6028f2ff3c..4cc8c4361b97 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -858,7 +858,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1


