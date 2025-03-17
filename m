Return-Path: <kvm+bounces-41162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E56DA63F87
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 06:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE5AC16B59A
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 05:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D520217727;
	Mon, 17 Mar 2025 05:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uYPWfv/h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C19218AC4
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189013; cv=fail; b=Z5kOrZayHcs2dN1ce694Snwd1gMJpjp3SQXhLkVYFqG5jxal7E/uUMoXI/MJT8eyn43FMZf7F0WXY+xksXRo248zKM1YyZf5U1w/RjDKNDjYKyUHj0ZlcTgxFfWeznJB4pGKsQsxjDnLHMTms+u2QDjgMwjqFMEQOhFWNKaXN0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189013; c=relaxed/simple;
	bh=vvE5gSAnQ5lEWmW82n1vxVhsy9iq3iOzthiRDEpdghY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R3i8ZMdOwxX8FCno+bJ/VeHCXAOrokZwLkGDv2s/Wh6iiwy8PbSco1OUhzjrRKPul88zLLW3sPu8BhwNz1H5ZMtE4uGofydjO5dRY53guUtJgH9im1j3DsH7vmvq+dwCgiExQQs+XWLNHM/Sqrxbj6ZIWraafGyHiMy4jGODdxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uYPWfv/h; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WVeMwkglItb7aeq9MN8H4dxf9Qju5/xKeED0EgQev5Jmg34R0KKTl8jPL7CxIWQC5QVygn8OmGS0liboBHdce1ge7FMZJVoBZgvnwXiH2RuZBaE3Rf6g2BhyT1ZQwfSSnHBG2cDq0D2H3939/nJ7O4iunwSrdfw4c2ffsKfqUeV+AhEECC1SOhhwsgZgnIo8N+DGZr4CLSEomGGxGp1j3Wa5FZV+Cz/BIo3jDXuLj8pDnXIbQyqAdcARj+IXdVZrjFPYR6cEr8FVwxKtETiOLeW6rpDBqbaItD1ceNAuPjoUB+gx6Hy/7uISly+A/EtjyGrnnKP4CMSiTl/jkGXiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8dzdjTcME5sIpYgG3KHz5BrENh5we87r775lbOIz6Y=;
 b=TzqlmzHOnz33sGh5WLkL3T8EPqELR/jgTfNfUDNXzOuO/lk+Zo/I70sSv0oRhT4NhkQblLf3sWztdKR3SIYrjXFUe4YaMNHbq2T2c2nDB67I2BqefahwqVenZqtmh0/wwGgKxNabectP5pRSLGci9I2F2+7xDolDbVgTLRQtGXo+uPX+JtuLMFgRBvn/QafSw+5Kb43KoOkPAAiOPQwH6DY8AL+jlXqg/qaPN6nz/FxrJ3/M9pUGr6VcbrVavPByPWaKy9Qjw2n2MEIeepYeOde9rjU0sbuRjN4i3cfQUFoYZ15EEZD9GTiSL3Z0KtPRSPDhFtpf3yqnA8UU19Xpqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8dzdjTcME5sIpYgG3KHz5BrENh5we87r775lbOIz6Y=;
 b=uYPWfv/hQz5Uht1IS0SPcjGdrDFBNZhJ3+Sp7QpZpslfP4UofNlX/5kKRSopPRf/ahXL0com2sQ05nMd4cX1ymIzOue2FcScJCXDu7GDLgmN5o4E7DN4qntEdQ+CjpJ/p39feyzakE8YGV5GWxLG7cpByhGBlZGStyATqEEzBk0=
Received: from BL1PR13CA0196.namprd13.prod.outlook.com (2603:10b6:208:2be::21)
 by DS0PR12MB9424.namprd12.prod.outlook.com (2603:10b6:8:1b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 05:23:28 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:208:2be:cafe::85) by BL1PR13CA0196.outlook.office365.com
 (2603:10b6:208:2be::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Mon,
 17 Mar 2025 05:23:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 17 Mar 2025 05:23:27 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Mar
 2025 00:23:25 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v5 2/4] KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
Date: Mon, 17 Mar 2025 10:53:06 +0530
Message-ID: <20250317052308.498244-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250317052308.498244-1-nikunj@amd.com>
References: <20250317052308.498244-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|DS0PR12MB9424:EE_
X-MS-Office365-Filtering-Correlation-Id: 67249ad3-ff3c-4c00-f1ba-08dd6513d92d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m2OJwyZrjg8suCeU2uZqkRrc9JwTZyAjPJOQvV0yozXp5Ss2WqB663DB2oGo?=
 =?us-ascii?Q?hYvfcwjlvVsIbmtnRJTP1VsZqipPpxUYyP36C753D2apMQFQqPL577aJY9gt?=
 =?us-ascii?Q?UMOajHK8PyRiqQQhNley/JgPn7Ryvd/nL6GQyE4nDtwqXiKM+Jj+iOPK7s4O?=
 =?us-ascii?Q?K07X/kUPSyO06KlfWuHrkLc3UTiX6P7V5MSsL/qLt6gB+vvTImQlgaGMPXl5?=
 =?us-ascii?Q?BSpoy0iBJIEkStmDnEBdtR5HPkzO44myxfCSJU+thMWvcF2dRQGmCZXIHI4w?=
 =?us-ascii?Q?ygnlCcwndbNdmcS8jTtoN2Eig/fXBvAELGNJlAhxYlz40o9P+Idxd+mOyrU5?=
 =?us-ascii?Q?S4n6HCOSFWk9KxiS1GTecN0efO93aMPE9bxr1S3ux3fi+2H7zXbizvqXlg/v?=
 =?us-ascii?Q?QGDunMowdphUwpyBwR9/EZq+CQxNdGbga5QWDRZMPArleSwR/G/k6+Plqiu8?=
 =?us-ascii?Q?IUgP382JaE+DlRwYrb9pnChDkahmFsj4AKlQnED5DLEIh9nOa/KHjW8//wIm?=
 =?us-ascii?Q?yBS3DBN9+C2n9GEYIqKlD47rNbOeELZ7JwmTFd8KhVnjrhYi1FB6j1s+tCqk?=
 =?us-ascii?Q?ilnkYjwVkvdCLg7hvEjvJW0H4kM0BIltjELI3Kk/icnHNk64PCObYzOFeYrx?=
 =?us-ascii?Q?Qm3N/nuoD0PpE945ERdwIf8HmQ+yC5wtT1CbdQ9jgrfJkfe5NMQemg5Nfvor?=
 =?us-ascii?Q?LMmmhPOdFJcasMqPVshlV5E8qB5qMKOFulHpMFxfllb4cz8R4XxKxNDBx2oH?=
 =?us-ascii?Q?/WUZkbnJ8pcKY2bxz0td3apcuGxFgdXv2CNGZsbfBDlKPz0z2qkY89rKzgSC?=
 =?us-ascii?Q?1xuM9i5QFqqc+HCI1dSdS/paPWnnTEqO2rfAzLx0zuAoLeGQSFGtmy5IZBju?=
 =?us-ascii?Q?CSOHAxR7gvsb+Y4kTFfDwnTukGiUKxqkGpvWZU5AQbYqhwBcvaJ8ApP9oWOS?=
 =?us-ascii?Q?wSuBxmqFsKrCIIrhtWrDO6z7P3DGYfvRgIY+WUL5d6gMiHOvBWCkgJMOi7F2?=
 =?us-ascii?Q?neCR3oc7L9NJEfa7NCjdz0o7DYVncAS+x+VWUMqhlCTXFx/AkpV8xxv23ZXg?=
 =?us-ascii?Q?AA4PZ5feGhH6A9/prE+dzyJQ47haXBASSzecWBYHkWYyphcpoHD9biyisw3z?=
 =?us-ascii?Q?8mcNfRWZqSPtEeYknmD4fNZje/INppl1/ypUYraSjOrhhkUaWSPhGdluQEcj?=
 =?us-ascii?Q?UeC21/77zVw0jztCUmsvTgp+6TwelK3z7v0I8nxUZdet9lIGg9/oyboclUA/?=
 =?us-ascii?Q?PUBs5wJBryZL43AVyNgqh5wcCgNEYhqe8evRC+6llJkxfPo44QMTHAQwnzxS?=
 =?us-ascii?Q?ZVtPXg6/9Dp/Vrdkv+IOWsKaISmLBRXUWA0Ik1g9x1obcLBTiY8asdwjfHqN?=
 =?us-ascii?Q?dTG+6wlNQGQSPtmxnQHgT738Fo8dEQ6GXG0FLt8C3aJgVEC81EsixHQXWzol?=
 =?us-ascii?Q?x5ETZ3mvAYGW/0lTaHl7f8AItWStilZR1qOh1OdpbikM2ecysL8CipYCurOp?=
 =?us-ascii?Q?+5HLqiuT/9UTuF8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 05:23:27.8616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67249ad3-ff3c-4c00-f1ba-08dd6513d92d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9424

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


