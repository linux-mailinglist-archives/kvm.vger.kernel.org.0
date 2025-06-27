Return-Path: <kvm+bounces-51020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF346AEBD44
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B49545666C1
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFEB2EB5BD;
	Fri, 27 Jun 2025 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oBznm7k3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2FD2EA724;
	Fri, 27 Jun 2025 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041612; cv=fail; b=FbHkrZ7tDKs6iOgpTT/V0PJheoTlnJHEYno3ts7orZqwJEAhcalYJqZeiF5jBteegXPc/meOv0WtR7r5pgEa7WQlT6ikQD/7iYH6o+cw3JZI2HK3hw7Dvgj1Pw9yQGPu6zMVp2D/qh+Vp9SD+NXnm4HdMyRO/k/QsnRz4WZoyMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041612; c=relaxed/simple;
	bh=Up6bx9CYmMd/yJoi4leQlUxZW6lbm71KHdW2WfuX5K0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tn9Fk1lGAg7g0jyjt4QQxZgM1CKriPDgAjVihMTnSdNoXJtPf27iX5vH30U58yWEsCDDY+m4tZSECL0GhvCsSc/yB0OvP65gi64axP1PadrYyDQhXnIbre7IYCSXUs51arTeBNV9pEkSgZnbunYarzdm9zpQ2KvirQQQkQxm3eA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oBznm7k3; arc=fail smtp.client-ip=40.107.244.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LOAwc7eRC4P3o+8g8RIFXAm+hJy63o5meXIwuMcUUZWnPUqFEVjdrR1SSEDl2+BXVwTGLBYIoSyOdL6SVwwla0yTjNqOJe/Xz4T3CvEHwVtZSG7wYwYFfuqnKaXzP4yMFIR1BygsuMJHIsVg1O3xXYjeGAJfS3SYH3/mxYTbB91mkKm9hWyXP4sGQFOeOIWa4xavmFJ/ENQJQRhzORbDf0BRpgZGdQH1k57SViFDWn9PetN9XjhJQDn/EY9D0R86qwNEJjgIh39v/vZ8fxVALOnHUswdiwpdJCeNngHTZ9YT0Q3Vw9gXMGwOrs1KNmWviDocV9zQtxWLrZqEAyR0Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gal9MrhB+5oMbC/acGDbGytqCO0Mwdh2uVOh4wiGGQc=;
 b=HqjsFuA8MlnrNTonDmWSTJAKhqs8bVb9IQZ2kPQV9McrBfjyg2fjksW2IHOuuiD/0ul6sal51VQ2Nu4EyP21pjxUhAMrPDfq59m89+464nvyeZOe2ElE1XnWKI3uJN6eKLFYcn5k3pzxs67RYZBrjI87WtWYpEB6K1Cfx3f9vMxLGD7UI6W5zyaoGwYsbSA3Y7J1VVX0AXrtiexjoRSjJtjr9k0raTSKVSbYp8SoHgNubTJUf67G6hAZYPWEAlSBBZ44nbstSYAWGZH+ocVv5GDGNTaJ13OxwzsNyyarw6wpQMCe1TWJGWFHX3Lm/jL5eufwEgAWqxyAQf7poPK/wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gal9MrhB+5oMbC/acGDbGytqCO0Mwdh2uVOh4wiGGQc=;
 b=oBznm7k3bm69Mgr9BcDg84WtknvizoSBxowWdu5SdEHld7ru9vec13QXZfgvFwAUxS0BaaDGFCic5XbCK116n+hTGbcQeVOSrMDa+/FmIaSPeShEDzlIIOXsklM6wWPaV7AJGYGNK+z6RNaEC59PkDFesjsk1kncdxgc47rFmq4=
Received: from SA1PR02CA0003.namprd02.prod.outlook.com (2603:10b6:806:2cf::9)
 by IA4PR12MB9810.namprd12.prod.outlook.com (2603:10b6:208:551::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Fri, 27 Jun
 2025 16:26:48 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:806:2cf:cafe::a4) by SA1PR02CA0003.outlook.office365.com
 (2603:10b6:806:2cf::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.23 via Frontend Transport; Fri,
 27 Jun 2025 16:26:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:48 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:44 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 08/11] KVM: SVM: Extend VMCB area for virtualized IBS registers
Date: Fri, 27 Jun 2025 16:25:36 +0000
Message-ID: <20250627162550.14197-9-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|IA4PR12MB9810:EE_
X-MS-Office365-Filtering-Correlation-Id: 869c2515-290b-40ac-c7bc-08ddb5976a59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TLBPL6MMZrXADfPdGbYprX7aPwG37iKLw+hygbr+yZUOfH0YT6UT7cnEqNMJ?=
 =?us-ascii?Q?IE1esKOBdejVdDG7cE7lbSXdFk8sozj15FQrfuv6S5y7h9H3FhOtGvmbnt8O?=
 =?us-ascii?Q?O/duS9bbQ6Fy9uaXXJPdZu14fBkKMWxk5Rx57OtXE1c/rA+9dK4QzrUH8T/S?=
 =?us-ascii?Q?bnbjDJ6MoClv31xtVK16YLbqQnh3xs4mWF9T/m+z1QsVQDXHR17yy21oNddG?=
 =?us-ascii?Q?smfJzJDSFotXy6R8HjpO1PMfrGgeotT287LkhxcTQMLkkxPGEreD5lO2tDvn?=
 =?us-ascii?Q?36IPkMQXfKAzGu8FkS36OUFwU4XTZp1u3PdEBIgVFVwoRVls/NOt0O8KcDkq?=
 =?us-ascii?Q?suvr1Ccbye0QxteDlDBDjYMaDyDJ7gK0QnG8DEs3EAZaMqK3guUxh7kN16HA?=
 =?us-ascii?Q?zqD/FkGnIJlO9cBiERiVZW4UjW3RBm5sI8UlvfzmNnvKLTzar/gCvnzVzRTa?=
 =?us-ascii?Q?QjRx/cDDf4oOiUuoPFmwDbTVL4dYVPd1QGo8IjIyJN0/FGtR5XBgc/rybz1f?=
 =?us-ascii?Q?Thzom6TaNbTR5JHFH6XMBabIBLaG3XFvxz5XorTlt3RIWB0ECTgnPIhSzdyX?=
 =?us-ascii?Q?wXph7rU2eFuIp1erbrnf8pZIo0oeCLgIWckicdjDInL0HgHpdwgsn2cM0BsI?=
 =?us-ascii?Q?HBtGJjfcRMepedqdGcjjYnYy56wdfRl/a4OnxxM3EefOq01hbqgeulR7eKJm?=
 =?us-ascii?Q?mtwRdVenVsshRt1h3jfUThUUYQv61ae8Z67ESbyyOSFxEoRW/Ywimgo/oSTH?=
 =?us-ascii?Q?TxG+ELWeucHHf+i8pFuelUde/IaQZKj8/6UyNzXNDUFkKDPErIyjUZRjYhQk?=
 =?us-ascii?Q?Yvf4JFzBc8ket7myJJGthtxBjiV28VL/eP7TwJH4N+xwSB7LhGT+4aRKn6iW?=
 =?us-ascii?Q?51cPVqWxZwbAb86LKfmqbc1KC+dlvpUj7oiiFBGbSLG+2urj/mXbfsRhk0yu?=
 =?us-ascii?Q?cbXh6tYO3mhAX3C1IG5IHAQ1Akm6EP9ljnSxNaNc6bho+Jf3iRYLCAu0Kucy?=
 =?us-ascii?Q?pySLVMJ6Cu9udHW32EdmDjo0izZjOgrUo5kxSlqUrEPF9o2mo/oJ08J1EFvs?=
 =?us-ascii?Q?D0WxmdykekAOiQZx/QPmpiMwOufyLVOEj/hBBYt+wwM5OuuxToNOAE/9BhHI?=
 =?us-ascii?Q?hQgp8t22FZHwsNikOF2C4MYvY5yfp8lKP5aSakjqLjupPqXWey793XbZOpmX?=
 =?us-ascii?Q?cC1Lta9n6NqKjvYNdsCueGREaObp3cMO2ioRk1FLN2NfFKmrukX5NLNxxPC4?=
 =?us-ascii?Q?876KSI/Plnm+JcmlPmnr9lcdfCejMsDPqySVPEwOQ00dYOxfS5tbLJ3TJ5ju?=
 =?us-ascii?Q?QG4Ag9oMIktFhLPQpSP9QuNxWQO8/J/FpC44ebd4CYT9Jz/TCsfhl+DvAtk+?=
 =?us-ascii?Q?Z4EXAJsy/AG7ugGEVfc6iDCrGJW5cG3rDWv2xctIwcOVCRzBB1/qvp7VbCnT?=
 =?us-ascii?Q?UMHa37MObaGPDZuALpXgRMkSwqK51CxSkg7IVH6VnmQUkB6Pjnx630Fd1C2H?=
 =?us-ascii?Q?v0eNddFeiWHqOO6EJ1JfQkgx0BvPX9ZZN9Ik?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:48.4749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 869c2515-290b-40ac-c7bc-08ddb5976a59
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9810

From: Santosh Shukla <santosh.shukla@amd.com>

Define the new VMCB fields that will beused to save and restore the
satate of the following fetch and op IBS related MSRs.

  * MSRC001_1030 [IBS Fetch Control]
  * MSRC001_1031 [IBS Fetch Linear Address]
  * MSRC001_1033 [IBS Execution Control]
  * MSRC001_1034 [IBS Op Logical Address]
  * MSRC001_1035 [IBS Op Data]
  * MSRC001_1036 [IBS Op Data 2]
  * MSRC001_1037 [IBS Op Data 3]
  * MSRC001_1038 [IBS DC Linear Address]
  * MSRC001_103B [IBS Branch Target Address]
  * MSRC001_103C [IBS Fetch Control Extended]

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/svm.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ad954a1a6656..b62049b51ebb 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -356,6 +356,17 @@ struct vmcb_save_area {
 	u64 last_excp_to;
 	u8 reserved_0x298[72];
 	u64 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
+	u8 reserved_0x2e8[1168];
+	u64 ibs_fetch_ctl;
+	u64 ibs_fetch_linear_addr;
+	u64 ibs_op_ctl;
+	u64 ibs_op_rip;
+	u64 ibs_op_data;
+	u64 ibs_op_data2;
+	u64 ibs_op_data3;
+	u64 ibs_dc_linear_addr;
+	u64 ibs_br_target;
+	u64 ibs_fetch_extd_ctl;
 } __packed;
 
 /* Save area definition for SEV-ES and SEV-SNP guests */
@@ -538,7 +549,7 @@ struct vmcb {
 	};
 } __packed;
 
-#define EXPECTED_VMCB_SAVE_AREA_SIZE		744
+#define EXPECTED_VMCB_SAVE_AREA_SIZE		1992
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
 #define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
@@ -564,6 +575,7 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x180);
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x248);
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x298);
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x2e8);
 
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xc8);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xcc);
-- 
2.43.0


