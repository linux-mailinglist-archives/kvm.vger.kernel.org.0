Return-Path: <kvm+bounces-52541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74DE3B066D5
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9363E4A0196
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E542C08A8;
	Tue, 15 Jul 2025 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N1YdCxUr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86EB26D4CF;
	Tue, 15 Jul 2025 19:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752607680; cv=fail; b=VJtNp5eG6KmOR3UGApVZeH74feUCRIHGCwMb1QZRB0mnY3A7QyW52DoaVUx8zHJn+UyGNSAkbfZmWH+HkMGXhDSSPBfa2ttvj9FY9zg6e6asSWFdufuJkn6ZCjCOuemZ7PjevucNfZ9h39+GRweEs56GgznQshjpNu//8IXGGqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752607680; c=relaxed/simple;
	bh=mL2G0JPzQZs+SpO2+UYF1eSWFe8TCZjKRsN0a5V2ER8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XCMGoNIw9fNFeD0GLt7Hd+3ZWVNWbB0L/dou2U+9d1PDnpOozolG1rX3GsrAh2+UnfMyJumHBfutTHhEBm9C+5JRzLCSJBs5Bk3Ye9mk4qECvjrmFW+hLE4mkZV+iAzvdCw5Wsze2SEyaa/gzU0eDRVzSkVT1KxP2ccRtef3FTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N1YdCxUr; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wyvAGBnK0YVMjedRQPtp1VZW7NDXO4IbDw2LjFqLm+LmAJIk9nJYfyQxmLWA5lN/0x5inuhMRCsoMJVxHHUCx9bH5OLP4G/mXgheg321bTXDfP9v+U1qig0oULS6Qj8DSauNLRd2cdgrGJrNfoB6LsXpc1293/ukWnX5zSfTDqNUmdJzm+HEFeZDL0hDflPWmPr3Ivhj9oHyLBH1AKq8wVNH9mriNyl5FFrxvSZHqcyAT8+CWqtPTK4Hp3m2lwJ6otMHh0n4GUKnJGePoyNZPhhThidUWRtsOY5cWMDHD3x3yUZMJisz5BrnWYKbBMG4QPO+xQDGhqqAugikaBQluA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvdIlzSZFTRdKJUiVddrdv7Diyg1NVa9LQHYrtZfGfo=;
 b=q2ufxifyhRMswBOcQZxV1ZUkDEfPq8oHWOWoF7Gulpge81tAXIlIqk5FWCj1botkk8FFA5R/vetoZxwpxlyUgqV04F5I8OkdTSm2BTuNaWtwq50iDysbAgTnuSkZF3lhGHijwt9FbQmB/Zk1ZjqGaFTP0DWghaSa1796KI1tCT0ASNzptQTXtFxOazleyY2o7IYiiJT3Z2OBtQ11Xi8QHnRjTN7mX65kKx9Wc3J8JJUxG2t9tsvXxOjExVD1Pex6QhGbd9ijzBAxv6n3dVew1dHCHjyMa2xDY6w7YpZADunANQQyzQzr7FdeoZO1SxDBEYVktZv6oRTZPNVGFfePaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvdIlzSZFTRdKJUiVddrdv7Diyg1NVa9LQHYrtZfGfo=;
 b=N1YdCxUr6iVeOykW8HySlGHB427kRkoTdU3X5pwFDU1C9/2ptYbGr8XYGfpU4VluGuOvsLanIAKaE95qK6OPbdKfIj7bjYicBgiGkXJtwUFzCma7WG1h2ADLoQaNyYj696hgOoli8PkG9YaBh8xOELscyHwewqOyhzNiZwHlm3c=
Received: from SJ0PR03CA0364.namprd03.prod.outlook.com (2603:10b6:a03:3a1::9)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Tue, 15 Jul
 2025 19:27:55 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::41) by SJ0PR03CA0364.outlook.office365.com
 (2603:10b6:a03:3a1::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.19 via Frontend Transport; Tue,
 15 Jul 2025 19:27:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Tue, 15 Jul 2025 19:27:54 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Jul
 2025 14:27:53 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<bp@alien8.de>, <michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v3 4/4] iommu/amd: Fix host kdump support for SNP
Date: Tue, 15 Jul 2025 19:27:43 +0000
Message-ID: <ce33833e743a6018efe19aa2d0e555eba41dcb96.1752605725.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752605725.git.ashish.kalra@amd.com>
References: <cover.1752605725.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|MN2PR12MB4334:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ceb163d-17b0-4473-f862-08ddc3d5b2b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlNiOTErRUNwaUVSQ1RVQ1hNUXlVZ3pnVXl6K0tkZHJCOUcwSWtBR2FiTEhw?=
 =?utf-8?B?UEMrS3FpcUllZjIvZFFQTUpKaFNwRk9ocTlyNXhhU3JDb2pIM1lLWjBPV011?=
 =?utf-8?B?ckw2cFlLNVZsb3A4SS8vWlRQNit0Z2JCMVhHT0NsUmY3VUQ0bnkxNlJGb3VH?=
 =?utf-8?B?Q2VXUXpPditnT09QWG9sUy83UXJzaHpPOXRnY29oRGppNzAzSXJmWjhEcFQ4?=
 =?utf-8?B?T1h5allCTEM3WUljTERQaXNTaHl2M1JlbWtnUE0rSUxPR0ZHK3RlUHFwb1Rw?=
 =?utf-8?B?SThVeG1oV1pROEVYZ0U5WE1pZTZFYmFUN3NjUm9iaVpJNHpNKytGOVRNZXQ5?=
 =?utf-8?B?ajlCejE5YlZWcWQySzN3N3lTS1hiQmtyNTc0YW52dGdFdnh5ZVpKM2kwWStu?=
 =?utf-8?B?cXJJUER6b2NxWlRjRkRGdzNoQXdkY1d6Q1FsdHJldkhUVm04ZzRwajFnVDEz?=
 =?utf-8?B?ZTBpdEdQZnNGOTNQS2JLN1I3YXVHWGtheXM2RHoyK0JQdk95MWExeGpsTStZ?=
 =?utf-8?B?NG90U0JPS3FENE1Veis2TEdyMFRTUHlHeFppV0Z4a0YrWDQ4c3V2R0Q2N1lQ?=
 =?utf-8?B?RWFjTUhmVmdxSFFKdGRMWFBONTFzU1JRZ0JiY3hnTFcyMVZTL3BLZ1B4SEhZ?=
 =?utf-8?B?V1BKZzcwWGFXTGd1MlA5bDN3VDhEcHZnclNzS0JCU3A3WitIa1h6RURFS0pK?=
 =?utf-8?B?N1JpVU5kSWZVeC9aWW5GTGZ0UTNMdkEzVEh0RXkybitja1FINm1SQUlMeTBk?=
 =?utf-8?B?M0hxeDlvMlNDQjMzelZNOEtZTnFuY1JoUG5UNE0vSmpvd1BwWm9zWDRnNDlj?=
 =?utf-8?B?VGtCRXpacllZRWwwVnA0L0NSbnphWE9KSlc3cHdrcW01bUh3K2dPamxmdmg1?=
 =?utf-8?B?YXJPQ0N1VG50ZExlTHEzVlkwZVRPRW9ic1hKcXRrUXVNT1lTMHZRV2N3bXN5?=
 =?utf-8?B?N0tONFhNZk1mejZQNU9aZ21VTkpjTC9ZQUFXbTN3RS9adTZteW5XbW5sSFY5?=
 =?utf-8?B?N21vWWtGRHdaa1h5RDdXc1ZoSUFYYUJUMFpDbitSQnE3SktUbTVnMk1YMDFh?=
 =?utf-8?B?bE1ySS9HZGFLVDZYbDNHMHZ0UzEzSm80bmFFRlY4WlFic2VkUDJJa05TajRL?=
 =?utf-8?B?UWhRQlZtY3pRb2MzQ0UvWGRMdHNwQU84TWtqRHNRZW9GZWx0RVdLZVZEVnpQ?=
 =?utf-8?B?UmFCZDM5eWRNUzdhbkRxT2dxeGc1bmhHdkJSZzJOZkp4Y3dBME1JSSs4Yzgx?=
 =?utf-8?B?N2hneVFDMCtjT2hFbTJVQW55YzZuRWlZS3U5TVVoVCtyYXZQcCs5cytzMXFy?=
 =?utf-8?B?UkpRWHFNanVBM0lFV3FFUTE3U0NPOHplTGR2REtYOVV0TjB0MnpjRDZYM2c3?=
 =?utf-8?B?dk5KcVVVRm1DSU5tN2JsemNaNVJxMUFQRTNRS0JwVXduZjFyN09uMjdsRFJw?=
 =?utf-8?B?djhxUGVVVHkrbEh0UHBHbzY5TTNZRC9zbUpQRi9UV0toMVU1NmxDV0FzR3Jw?=
 =?utf-8?B?T3hudjUyQjc2SmcwUlRnN3hKNFpyWXAzVzRZZ1dkc3c3eVdJN2Vhb1pRMHdj?=
 =?utf-8?B?ZUZWYUZYelpDSUJSVXpROFNHQ1ZqaGtvbkRJeEJGU0lNSGlnbDRPS0RGN0Qw?=
 =?utf-8?B?Q05XdmpiaE40bUpuVGFZRHJ5QmxqeEZ4alBTWEdNOGJrVmZBQ1ZQUUprZTVD?=
 =?utf-8?B?RjAvUnBPZExPL1FuTE1sRGVBME52NWlqeDlOUVY0SmhLMlJBdnlrNzFpbEh0?=
 =?utf-8?B?ejdsWXFRdXVqRWV5VjNqKzd6Y0RIejEwQWFFS2pDTWRYV3BwL3pYTEFFY0li?=
 =?utf-8?B?V1BwV0YrUVdDYzBBM1hxZVZ4M1YwNUY1Y3dMRkJWZnJyOHlTRm44dUk0ZWZ2?=
 =?utf-8?B?OSs0aVR1VmRwQy9VbExvS2lkaW5ZSHdSRHZIaVFWT1FjK2hrMGhzSVVDTXB4?=
 =?utf-8?B?ekJEbEpod3RZWW1XY0k5NHZ4TkgvQVBwMy9naFlnRTgvNWZCQ0ovQ1lLQ2Ur?=
 =?utf-8?B?NHlSTFBDZldLT0RiRy9Xd1Vwa3BzSXFNZUVaOUtOejdHRkQ3QVZLRUovRUs4?=
 =?utf-8?Q?0Cz+IW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 19:27:54.8574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ceb163d-17b0-4473-f862-08ddc3d5b2b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334

From: Ashish Kalra <ashish.kalra@amd.com>

When a crash is triggered the kernel attempts to shut down SEV-SNP
using the SNP_SHUTDOWN_EX command. If active SNP VMs are present,
SNP_SHUTDOWN_EX fails as firmware checks all encryption-capable ASIDs
to ensure none are in use and that a DF_FLUSH is not required. If a
DF_FLUSH is required, the firmware returns DFFLUSH_REQUIRED, causing
SNP_SHUTDOWN_EX to fail.

This casues the kdump kernel to boot with IOMMU SNP enforcement still
enabled and IOMMU completion wait buffers (CWBs), command buffers,
device tables and event buffer registers remain locked and exclusive
to the previous kernel. Attempts to allocate and use new buffers in
the kdump kernel fail, as the hardware ignores writes to the locked
MMIO registers (per AMD IOMMU spec Section 2.12.2.1).

As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
remapping which is required for proper operation.

This results in repeated "Completion-Wait loop timed out" errors and a
second kernel panic: "Kernel panic - not syncing: timer doesn't work
through Interrupt-remapped IO-APIC"

The following MMIO registers are locked and ignore writes after failed
SNP shutdown:
Device Table Base Address Register
Command Buffer Base Address Register
Event Buffer Base Address Register
Completion Store Base Register/Exclusion Base Register
Completion Store Limit Register/Exclusion Range Limit Register

Instead of allocating new buffers, re-use the previous kernel’s pages
for completion wait buffers, command buffers, event buffers and device
tables and operate with the already enabled SNP configuration and
existing data structures.

This approach is now used for kdump boot regardless of whether SNP is
enabled during kdump.

The fix enables successful crashkernel/kdump operation on SNP hosts
even when SNP_SHUTDOWN_EX fails.

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/init.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 18bd869a82d9..3f24fd775d6e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -818,11 +818,16 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->cmd_buf == NULL);
 
-	entry = iommu_virt_to_phys(iommu->cmd_buf);
-	entry |= MMIO_CMD_SIZE_512;
-
-	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-		    &entry, sizeof(entry));
+	if (!is_kdump_kernel()) {
+		/*
+		 * Command buffer is re-used for kdump kernel and setting
+		 * of MMIO register is not required.
+		 */
+		entry = iommu_virt_to_phys(iommu->cmd_buf);
+		entry |= MMIO_CMD_SIZE_512;
+		memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
+			    &entry, sizeof(entry));
+	}
 
 	amd_iommu_reset_cmd_buffer(iommu);
 }
@@ -873,10 +878,15 @@ static void iommu_enable_event_buffer(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->evt_buf == NULL);
 
-	entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
-
-	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-		    &entry, sizeof(entry));
+	if (!is_kdump_kernel()) {
+		/*
+		 * Event buffer is re-used for kdump kernel and setting
+		 * of MMIO register is not required.
+		 */
+		entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+			    &entry, sizeof(entry));
+	}
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
-- 
2.34.1


