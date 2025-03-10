Return-Path: <kvm+bounces-40571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 384E1A58C3F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A77A4188CA84
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83D31CCEE2;
	Mon, 10 Mar 2025 06:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="go2Z0L/M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE8D29D0B
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741589147; cv=fail; b=WMuxBkkKipexsItfWn6LGgMx+EvCe8DiMP8zXEXKI7/pXrheQMG1xAJ9y8SqTvPxwcj7kHhKAhUjrMviiLoXuMHpsuCN6/KYKc30lBxjhleXIGxR3lhuBkgPqyRwHxGPTxPEPrj8my+Ka6GjPi8g80Ktwe7jOD6sGxNoHUq5kd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741589147; c=relaxed/simple;
	bh=vvE5gSAnQ5lEWmW82n1vxVhsy9iq3iOzthiRDEpdghY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WU4iTsi91J+vMSJoLyCnLIGoZ1gX5bEdHenupuTsnLxjVjJ/AFJecNljpGUQ58WpEYLQIy65CmrnXzXRiI128Y5Nh4kDx3gD6IScA0nig7Qoxnp/QFhP2md8eUDVXie9Tmuxc9RsVmYBk1eCbjXmqtTHjqPlbn5lUSPhMaU0tFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=go2Z0L/M; arc=fail smtp.client-ip=40.107.236.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YP6sD0MCLU70AF0KgySIO0r3gvWaBy0Zm/jHKeDY+rfWhND9qJeAvG8J5bnKQdLouqVbffM8gZjFRcTIKqhNpJYU6PCI0/iX+3LyAYZkgnZR+9g1bMjPrTaWcCTa0AOmJ/4/s6WassulA7eFkhn8dAk7Xm2sSis6kRc8Br9eDQn70jEL/9cQ2TMcclKv50I0iY2PDqZLQ19s1jMesbaLtmDyq4M88EN7nuI/X+LC2AnGqd8MZiNbL8Y382bhkWeeajOgOZWo6mHyr7uLwjaj3igfef8tsmY/S4ncLNruPemuI1WHsRO+HU277XreVXX515cEBAqw5yhF3X3cDad5eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8dzdjTcME5sIpYgG3KHz5BrENh5we87r775lbOIz6Y=;
 b=E/01ih4KAcH8bn5fImgt8VlVHGTRoat5hWgeLSCgbFIo3PcRX2S+V31NUXOpTGE7Mz43Kqbjq4HExBosOjYk8q3gUkV00JkeUgi6TxzHlAP+caB8MLoEkb9zlAtycE+wt4kWJbBYLXv7+2R/dREfXBxs0usH9OMONhev7QgFHQu0Vru/G5ocw1P7cCUiW74dh6MEzE/dS4AQ89zAjDO18dEnNxb+bfcCcM8SO0r9NhLtAtc/yd0XBN58+nJAr5O7eBVo+noOFuCgsaTnqKimICQqThHeVp9T5lI0M6yQ2lR99nhw/yd2haLNWp3z5NSA+xqYvx2iS+I743WLvTmppw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8dzdjTcME5sIpYgG3KHz5BrENh5we87r775lbOIz6Y=;
 b=go2Z0L/Mcj23PSAa/vN0gWYqvKYJg6bFSDwlZ1m/Wd08iy2hJMrenBFm+Vs6HjBPnWCSoZXitU7xmtnEEbrgjGajXpUn2BkzYcmBICfurnIlJ1YfKrsfB3e00U0Mr7BkYLCEG0yTgMTpOWqb6Q8z63dFSSkPgnzPPAwu3/Lxrkw=
Received: from BN1PR10CA0020.namprd10.prod.outlook.com (2603:10b6:408:e0::25)
 by DS0PR12MB7558.namprd12.prod.outlook.com (2603:10b6:8:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 06:45:42 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com (2603:10b6:408:e0::4)
 by BN1PR10CA0020.outlook.office365.com (2603:10b6:408:e0::25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26
 via Frontend Transport; Mon, 10 Mar 2025 06:45:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 06:45:41 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 01:45:38 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v4 2/5] KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
Date: Mon, 10 Mar 2025 12:15:19 +0530
Message-ID: <20250310064522.14100-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250310063938.13790-1-nikunj@amd.com>
References: <20250310063938.13790-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|DS0PR12MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d54084-25a0-45b9-a336-08dd5f9f2d1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LTfsVNlnpe7tSYHCKFkLpO11r0hKUe/sUEtjcUKPVQE+Or0Zs9xQmgiBEdld?=
 =?us-ascii?Q?xfIpZwm6im8YNCZE3l8UW2v47UXTDi2CrnEBHBY3Y/jz3g9z1SjbvCEozUNx?=
 =?us-ascii?Q?KAoyAQ2KBs3ueB2mz8XvKeuWg5v4a+MAgS2h0R1vD8VXEtX9+dUCM2GWBUmm?=
 =?us-ascii?Q?LuC0l3C4+1LAPs+6Tl7xj+ee7XPhihGgPO9vDmMDajagkgznMGLUW56/nQ2x?=
 =?us-ascii?Q?+6A0X5pU95/UgFSK7CIxW3DWL33bZUfQaUKpitoCz4zgC6PqnAN8oSh9N2a5?=
 =?us-ascii?Q?wrekOr3i9+Zs2xQEBS7FtO6crdAt37TsyBT04T3LQMGZBVdaWaWcVhd/9HiN?=
 =?us-ascii?Q?U7D1re761bdNGOa7Yc70+7vdgyD3h6fWbJ2hj66X9QrG7IMYnDWlbZWM1ZZw?=
 =?us-ascii?Q?4uepVtaBRlYf3dyY5xT27yO2bdEQHT8CIdjcPnl+3XuWkz0k09+veshXL8Cd?=
 =?us-ascii?Q?D1oEvMP9GzyG/ZXYd3+G4T49qJ+YvQ0MNdgjH6EFiVZfIYYS75wQaA1NFdab?=
 =?us-ascii?Q?1kayfO+w6OehRMCSzeW6OD8VstYiSmc63e8wDljnHnKsorZeA/lhrLKRyssq?=
 =?us-ascii?Q?Z01EOgMferqHq/CYHAShl00l66HWm5PqYpiwMWDZqmQ5iChuPkzRGIRokh8a?=
 =?us-ascii?Q?AdQfWcyfFEyTd+6R5r6lPug3HvuZXp/+X7l7gprm8ccWXc5d1p+b0AWAGnwc?=
 =?us-ascii?Q?LSIvaHOQYBIymGuccyt+YFMw1K9dInUI0pXNYw/fWm71zVM7jPrSfeKNIKGr?=
 =?us-ascii?Q?bvy/fP4hN6V8nGVgKpmghj4bjebnYLTGI+Ii4i4NQfzOZAtMyNs1zxAYy3F/?=
 =?us-ascii?Q?KrJBI12O+zpi3aG/6/16bAilfnLQFwRFY9eWhfpkUB6DcOCPIPZ6C3RJxi3L?=
 =?us-ascii?Q?GCOT91P/QKWro8gC2FLHq3W12S4z7EusQ2Ooj9kbMeVfFqMkJknVSOqWcJhF?=
 =?us-ascii?Q?yHojXbDileViSQFg7NHeWm9FXc7H5r5BfJPw7oxFoh1zhnth7DiBG9Hlodlm?=
 =?us-ascii?Q?nwb216azx+k8A2FWJ9KVuie21zKBIOpmTCu11z+XtnwBqPd2j86HRII/ioAO?=
 =?us-ascii?Q?xsDnOSbEIBIbxyEXIimoT/NVv1m5svWWw+T0bgQtV/Q/+GLm5cg/wqnBBG71?=
 =?us-ascii?Q?8fE/3LEDvaPhDa0wnnIGRbvZCZb7A0U4BzRzDKHeGEIGh9MBbgVsWu0LIcP6?=
 =?us-ascii?Q?zOsEeunayyYGXAUNWyuLKnftwQ7r8NPMXTqYOVwwSUTmEVTIEEI6Nfvga9TJ?=
 =?us-ascii?Q?tlh/BbhNgkn69TktpJx4RfHtNgoxTSIhPWD1yyBsK6yhgZnBppoVPNTCY9eY?=
 =?us-ascii?Q?c7uwwa1kOl6oykuZMZksajzJQpzGM1rFB4De8bCeHZJ1NMIbWJLC141y8nEY?=
 =?us-ascii?Q?by7hvFSQF+/AsfhypUWTSb1GE5wjBqRVuTF2j0NbGlE8ObF/2/MsYaAXS/IT?=
 =?us-ascii?Q?5jxclrDGTJRhSqjzHNvov81Csy1hj1rOQOm3yrt5CXSdgqGAhNjfCJDQGUSn?=
 =?us-ascii?Q?zgXy9+xYfGDa/PU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 06:45:41.7234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d54084-25a0-45b9-a336-08dd5f9f2d1b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7558

The sev_data_snp_launch_start structure should include a 4-byte
desired_tsc_khz field before the gosvw field, which was missed in the
initial implementation. As a result, the structure is 4 bytes shorter than
expected by the firmware, causing the gosvw field to start 4 bytes early.
Fix this by adding the missing 4-byte member for the desired TSC frequency.

Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
Cc: stable@vger.kernel.org
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 include/linux/psp-sev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index f3cad182d4ef..1f3620aaa4e7 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -594,6 +594,7 @@ struct sev_data_snp_addr {
  * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
  *          purpose of guest-assisted migration.
  * @rsvd: reserved
+ * @desired_tsc_khz: hypervisor desired mean TSC freq in kHz of the guest
  * @gosvw: guest OS-visible workarounds, as defined by hypervisor
  */
 struct sev_data_snp_launch_start {
@@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
 	u32 ma_en:1;				/* In */
 	u32 imi_en:1;				/* In */
 	u32 rsvd:30;
+	u32 desired_tsc_khz;			/* In */
 	u8 gosvw[16];				/* In */
 } __packed;
 
-- 
2.43.0


