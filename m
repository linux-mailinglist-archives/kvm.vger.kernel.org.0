Return-Path: <kvm+bounces-28220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA29B996585
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A44CB24CFC
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4614198E65;
	Wed,  9 Oct 2024 09:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AS6gkZgl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0D318E743;
	Wed,  9 Oct 2024 09:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466229; cv=fail; b=hEGm00NRkdGQuheHWwns5AF0RinNPtcfKyldmeu7l3SJqp+XgMJRGsqFzXtQL3k3arCncJqclIzC41r99ExtBD+UMlt86+LPMueHrUEldT0HWRFeHdcA4wplPLKHNJ1ZyIuJDWROhSw7fK0XULimnKFMWIVXh9QBmR99321Vqq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466229; c=relaxed/simple;
	bh=J7ITyZv4fTZN+ZfiudI2wlQZ6XlSSdAR/6O3kPxxatE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mskjKH3rFETNHiYHP3wpZpEIAxlCK0pIbeIYh/2L9XyXIf3yOhJaxss7+sYsPqrYtfQxBFq6HhFBCWgdjMfctUtD/VJyRilRxLXCRKbCKdbWv0V9lNIbIRVQeWdEx1cYT+nJlmnJW+F3gekuXD8o2yZGpGiMrgGkR0NEJ2tQ2p8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AS6gkZgl; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XiqwCmKdS3UbjE/Wug3JXjwhW8jik2Iusj80vOR9RZQFsYAKs0POK0PgS0N2/29vps2KhcvnSlC5P5ydk3wbyD4wgZVgblDzfoCjtCHiCXT/+TtSt3aZnQ2ZWZaUxM1JA74zQrXmu4B70esy3oWEMhtMhc2xQLkkaCLnVHBwpX1HWH/soYTgdIpVymsg1MCcpgLDA0HUXVqQx1MDOSZGI1HLvrc/Z2CxIug9Nu+KtAGHti4jiVh2/R//CO1djAmldS7cy5jN13vVI59tNlZekTpqiU4WhlIBoZEJVtH/U5q3+gzYmCUxBkI7K9BjsO5Fr+nK3/IZ5rd6msMeyqsdsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=Wck5xgjS8ZdltGYLTFrYNXWUl1bk+AHuFJRXa/BqqS9m9eYwi3LZrNtk47MwFIrOeDuZxIbUshVH7NBks5/bf7J8eQxTG2Uh3KeDJ983hXIliJiCmx6KFPqNNIQDdFoJHa528UwLpsiRxsJ0KdztgrQEW3dxT+WwclojCgRHr4j5b1ZgIOEhsXPAVRV24mJLgE6koF+KVi2WKFzlr+IzKZRrMlEoidqdp1Sfe9snVKvdpmtTN86Wce7uUGuCO/TJZ/la6B4FkH1M2p957ae2vhHMSuex1VHfr25tsgnkQ1TbcuXbIvbQwhsZDFEjOjUi/60a+vh9tXGSYjSMUZtrvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=AS6gkZgl6DVKJ81mF8UHYcdgSfFXy8twlCz+9nStTXD4h6YePr2g0EldwEOgP8vVaGP19izrdsoREvzwUupgJyh2ic3Cbqyccxz5+y6FWcYGOj8dfFvlrSJV26T9X+konxGK0aR0YTWbJSCexUXBNw1c4CDo6VgJgyoeOcA6vHI=
Received: from MN2PR17CA0031.namprd17.prod.outlook.com (2603:10b6:208:15e::44)
 by LV2PR12MB5917.namprd12.prod.outlook.com (2603:10b6:408:175::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:30:23 +0000
Received: from BL02EPF00021F69.namprd02.prod.outlook.com
 (2603:10b6:208:15e:cafe::96) by MN2PR17CA0031.outlook.office365.com
 (2603:10b6:208:15e::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23 via Frontend
 Transport; Wed, 9 Oct 2024 09:30:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F69.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:30:22 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:30:18 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 19/19] x86/sev: Allow Secure TSC feature for SNP guests
Date: Wed, 9 Oct 2024 14:58:50 +0530
Message-ID: <20241009092850.197575-20-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F69:EE_|LV2PR12MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: f83bf93c-d859-4d6c-806f-08dce844fffe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r7Krx6hwJxKKzhu1l4262SfPQX1an3a+PLqA1tvCjVw/31nYN3A4fIcSGvuF?=
 =?us-ascii?Q?KBcJAcJj2w0+hgnGyNOD+QfkP/aTxdg3DtHnQ/YqqRMIdn+R9OD/kd6gWxN6?=
 =?us-ascii?Q?wpP4OPRZa/bqX2uXYwakAqPfoGPuXcXh+CVbAasrfb5r2LtBcEujDTtu6hBQ?=
 =?us-ascii?Q?Ps72NueCYgWO1T5QVDf9BzqtZfKweFuCSnLvgHCyPZMPXEC4Ov2eoRzc2F1f?=
 =?us-ascii?Q?v+zjTBE/pSw+dDRXraO+G8HLIcnHL9FGKWzED2fCA7aAi9d2SZpjNq0VGRhR?=
 =?us-ascii?Q?P5TFO3k5E3cZUJGIAAB24Z7l8aHSiRmDxCM1xRskrQnwHIBQK25LW2YKsJJA?=
 =?us-ascii?Q?efQ/CwlrLD1BYI4O6rjTJZ9OlO/ZwdfnFhAcnf48rgcoJ13KATOdekkGYQM5?=
 =?us-ascii?Q?sfHf4ZOKw4nawQOS79Qb33W2oNLiQFqj72kAojIJFHgx9NST0Xovk5TDg/dO?=
 =?us-ascii?Q?YwTrzuIAqpfZqe2H62+de4MFoRaIx3uUGVf1ADrGGwRCxLL439KBAaSKP/9X?=
 =?us-ascii?Q?PrrPuf2GJNIZL9OvYy5+bT95VvnXx3oOpD0ZHKgFAdnXT3xi5d2+Q9CJkXoy?=
 =?us-ascii?Q?pNNOmBXcJhwLLJ9Ot/C/coesoxIA6ooNlEw2y6X2PS+UhOMKdhWoaB7PsvRH?=
 =?us-ascii?Q?uIoAC3qUM85L4G/cdKdnEMXLt1XseEzkNSqqe6dO/BTjuSLuEH1UJvhxmZlm?=
 =?us-ascii?Q?a4FBEd8i4kXbmKWbU6ue4zT1xAR8galkb+LUUK5UhL/nFO4SRIccRvtYpb9R?=
 =?us-ascii?Q?lYsZgHJSxBhFSP5dNI+XI3OUTzJsAc3umlrVA5MHfrr6N/es51uIiZI12poA?=
 =?us-ascii?Q?MBl6b9T3EyrI/eQl26vE7kThEo7r4qmTSgN81BBYrli1tb1pmnm5njfY6ytX?=
 =?us-ascii?Q?AfbYCMRWY5HcMgUBVj6E/OKFsASWeHpiU4XC/8PZlvraAMuDjVLaVkWlMQAf?=
 =?us-ascii?Q?n6dRgG1hZZSOpZjB8RENmK3RTvMpQozx/zQaxg1PSmZdhTaaBOqLIoCqSMy7?=
 =?us-ascii?Q?vDEzdI7Ptni4GHSWaxpcFq5T13Jlx8CS2bauAwE2RDVnJ8Cnc/N8YDprBZ0E?=
 =?us-ascii?Q?KkOtM6/98R4q08kpOlDEk5ZRIo2ETB1lpm7VtUID5brxjvPt83FQVimcZsHQ?=
 =?us-ascii?Q?12laruLKcuOjfnFDGfD1IbC03AjZmWRcigt/CpmjXVJZQZdDDm17yKLWobKW?=
 =?us-ascii?Q?3EsdAWfxNk/FUYCIwA0qpdPg6mkGzuLoqatvrt0cMERYO9HnSX60GEJEDCFI?=
 =?us-ascii?Q?Z4wHl+rUjEQRGQUBa1CE8KKZwjTc3FymVf3V7h2CFFL03IiJtQpOj/i//mXM?=
 =?us-ascii?Q?1Qz20JkmJMDQvSumle5NanC4yo71C1aKsXioCBQ/sF7Ivc1MhA0P6cJAnyIf?=
 =?us-ascii?Q?LyWe5GjY8xG0fs7njf8MeAoqn4gA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:30:22.9275
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f83bf93c-d859-4d6c-806f-08dce844fffe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F69.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5917

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to SNP features present list.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index cd44e120fe53..bb55934c1cee 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -401,7 +401,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


