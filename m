Return-Path: <kvm+bounces-52538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F250FB066CB
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:27:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36D677AEBC4
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDEAC2BEFE0;
	Tue, 15 Jul 2025 19:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o/ZRrRIs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B72B26D4CF;
	Tue, 15 Jul 2025 19:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752607628; cv=fail; b=lJk9yzk9yw9LzMYDtVMisCs1Pf0WI6ZD+FD5tDgyodRkYk7XBIgH9Ca/MfiAt9iSS6pqS5KUfWYwnBUxkiJW6MddIjsH0pTXRxwj0xwJs04rzrDoCUv9BjzAuFMsb0rL8rfdGtLCMo40DT56+DqtLwfTsNXf2yAYtWFY8f7IczI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752607628; c=relaxed/simple;
	bh=HqGDQkqNVa1XfY4gD8jyEAtnH4Tszdi4l5Yh6m0emdI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jyu8dt78JOdL+aRXTOSATqU/WYEZ5oKci+OWvB2krZQc+atYvFNn/Tn3ME5RGnrNQiQ3hpGs9VSTq640mKLcYc+wahGlpIYwJ6yp4adBmXxTjcgf3yG0ATCDii9mGF5dL9BiIHkC+D2jYx1q11UAyOxryTwolv5T8kkLLIvdboo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o/ZRrRIs; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kHj/SR1xLr61hfTelj6XRe3C06bPmRzh4Ns127dmIkfCalB9x3hiYKi0Mm/6sUH/WfU3CAfzS0HAiFqnve0kATzXIbPiTJp5oQtNr1KbOlZX01YW8AaKclY2NgsWM6hCKTV9YXtqTMN21NpfBCm/wU7gBh5eFHfNcwLa93+kXXeUIYGlizVsb4/kpQw5u5eCDt91q5MQnE9MJDXpPhtfgGXPix/eVuYQmIWBhCmiTWhzIp8pAB6vXLfwSc6H2PLsMAbtE+v4KwdSj4XdXOGOue5VDEKr5Oqx2qQtBwOjgFyS8esWzoaKF33WPB4rmydU0CHQ5MbojOaj8c6Zl1BWhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B7tfcPG0qajXCwLCBFk0xVABJgmM+sjD/chUX4F5tqo=;
 b=t5VNGhXhq4QoYw4sLE4a93n2x0kI1l7rWsTVTqOvJ4sXroSaVa8ldZWvFnJdbuWNIXNHS/9jomez4831lzsaGiJMupqKh4J3v0kGKg8bgxcGBGnUh5AJciyxj1PTnKFTONkjlS/RTveZhlIj5wjQSYcG/vem1zUjOb+invEknCimjUtcTLCzub6JmwQ9vtANvhqhVG8HrDS5AOCokx16XkAbAqyHdBRaNM02HzOlQmKWLyuOXdlMZJvPRZ7C17SMD3CxjBmwcuB1+RoHiICg2ohB9hc6ZLt1gkzHsALQQOXksP/BYOoTduKHg+1iXO/CwGWh9V4Xmyjk5AkSjYqvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7tfcPG0qajXCwLCBFk0xVABJgmM+sjD/chUX4F5tqo=;
 b=o/ZRrRIsXikpdlbF45Qtx3h+YfBVR5Tmno0ZeZOpUaQEe3VlPW6k0ALy/MA5DekUpPRsvg/6s/1vU/d9qEs6bETt1ClyNolAC2ECto3F5/5CUuX637M0ZSBm5tcW1VRv8SLdtxNGos7UTRv9HpKYfY7AqqMLqQ3H+r33sp9Ggug=
Received: from SJ0PR03CA0025.namprd03.prod.outlook.com (2603:10b6:a03:33a::30)
 by IA1PR12MB6113.namprd12.prod.outlook.com (2603:10b6:208:3eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Tue, 15 Jul
 2025 19:27:03 +0000
Received: from SJ1PEPF00001CE4.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::e7) by SJ0PR03CA0025.outlook.office365.com
 (2603:10b6:a03:33a::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.17 via Frontend Transport; Tue,
 15 Jul 2025 19:27:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE4.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Tue, 15 Jul 2025 19:27:02 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Jul
 2025 14:26:59 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<bp@alien8.de>, <michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v3 1/4] iommu/amd: Add support to remap/unmap IOMMU buffers for kdump
Date: Tue, 15 Jul 2025 19:26:50 +0000
Message-ID: <7c7e241f960759934aced9a04d7620d204ad5d68.1752605725.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE4:EE_|IA1PR12MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: ab85c45d-5a09-4968-f89a-08ddc3d5938c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dGNmVkFRaWpQU3RGbjBMWE83STZkK0c0cytySE9rZjZ3czdSaHJBVHRURGF1?=
 =?utf-8?B?NHVXNWgxVDdldVZiNUhHSmJ4c2JUSGkwcmd3NWxiNkVzcW9uWFJ4TFFwS2Fo?=
 =?utf-8?B?ZlhvV2FTblhZbi8xdGU3LzNmSXRUbjJhVzBEekV0V3hUaE1xTk9FRlRPZFp1?=
 =?utf-8?B?NjlYNkdqdXlNdWhObm1UMmZseUdpeHRaYXNXUHphM0krRS9LYTVjS1MyeWJW?=
 =?utf-8?B?WFVJczhZK3VEcDRHNDQ0bVZnWTkwRlgwMGUxZDVIeWY4ZDRoOGFaV3ByWGVS?=
 =?utf-8?B?WDhlRmxiRHVzdXhpYVZNYmJtNXV4RWVqcVBCNFFSQXBja0pERTVBbVk1QjBS?=
 =?utf-8?B?dVpSWXZMVEhDUVRQUHRkajZRTno5SnNjcFNTQXExSmgwZnF2RUFaeUs4bEc1?=
 =?utf-8?B?cWpvUk1wSHlMQzhGdytmUVBlck5FZFp4T1llVzZNK2FRaXNxZGpVeWlQSTRq?=
 =?utf-8?B?L0U4K1I2SVZiL3hIbzd5cGVIOXhVREFFS2dvdHVoTlJiRXJjNEg3VlQwd0JS?=
 =?utf-8?B?aVJhYkd1bXh4emhUT1dHVlVTWHFlVzh3dFVhanhBbXFEUVRpYmdqYVViK2VM?=
 =?utf-8?B?dDhQWEpFRlI0aG1GYW9LZVhackdwQ1FPOUh6Y0g4WWczaHBKcVFFNUdibHk4?=
 =?utf-8?B?ODhXUUIwbmpxeDJTRXhSa1U5b0FKcXRnNmEyQkc4RHlYRlNPMGZKbHlVbmZx?=
 =?utf-8?B?UGlydzB0VE1mMW92dUMvVGJOY1NobkdFbmZaTGQwTzdFRzJvUVUxVXBCanhl?=
 =?utf-8?B?SUtoNGNGQkFVc0VUTUlTb2FPcHVITitEakgyazFqamo3MjB4U1VSR2Evb2FE?=
 =?utf-8?B?bjVIZTduZ3Y5N0xlSmtGYlFLSnQwNk9WajMxK2JraTd1Ukw4aWpPV2draFpP?=
 =?utf-8?B?MG1tNXZFVjk0alc0eVJWMVFOSGRMSWx5NmNjbG9iYm0rR2VvanY2UFdnbDgy?=
 =?utf-8?B?eS9MWnAvOTBqaGs1blRkM1paeWpFQ09tWFFaODV3TkUxVHJqNndhbDVFVXNP?=
 =?utf-8?B?MldtdUhlT1NHUTc0Njk4czB0TndKdHhsNVZTbDdDY3hPM3NvbUhZdWFFL1pH?=
 =?utf-8?B?QUVIbzJhQkladndDYWhZZGVaYWNUNHNWRFdhR3NCajJpdVA5eDFZakxjc09y?=
 =?utf-8?B?eFJYS0V3eWJqRStoT1BFbnYzSndEK0FGZUM1L2Y4OC83RjA0T1c5dmR1ODhX?=
 =?utf-8?B?SXVUK0tGcVBlSmx1Q0ZJRGZLOHBnN29hVE82UFRMeHUzNVBOQU5PWTZ1bmpN?=
 =?utf-8?B?VkJrTmgwNEJDTmZxZmd2QzNyMVdRdFRKc014NWc2L0xGbnNwSlBDMi9qdUNB?=
 =?utf-8?B?NlN2bTJsbEVldlFVV3dVQnc3VitoN0F5MVRjTy92ZXZ1YTdvYjU0Q2p4TEUw?=
 =?utf-8?B?NjY5SFhDZU8vSEQzZ2x1ZWtyS0RFR1ZsaUFDV3BmZE85bCt5WURqYU1ZejhP?=
 =?utf-8?B?Ny9rSFlLeWtEOWJSSExYdUw4dU5QL3BOZjNWUk1KWStkcE9RYVZFMmV1ZGFX?=
 =?utf-8?B?MG0wakFscVl1WEtLU2xmcmQ3NmxZUHltU05mWlZQMkFsY1V3Z28wbitMSDhw?=
 =?utf-8?B?VUVkdStPbGltS01lTnBHcEhGUzFtNjhrVTlDckpKazc2d2t6c0JtdlVsTnd3?=
 =?utf-8?B?SUpWVTVBVGhsM3BzMjJlSzNtZVQ4Zys5Z2wvNklmdUNxbmc1bEZGb1RyNjFT?=
 =?utf-8?B?cWp2a1pSd0VyNVhqaVZKb2hqeWZCVlU4OTBTVlgyTmtFKzFhblcrd1kxdFo0?=
 =?utf-8?B?TlljcDFqSmhhTzhzZEtuV25VcnpBU0xNM2VWVDJ2T0diK1VOWkZIUEV6RWZC?=
 =?utf-8?B?SEpiM05KRkN3OWtvdmVDRS9jOWE1MFU4UWM1VlhOa2NKWEJXOVRDZ0xIZ0hF?=
 =?utf-8?B?SGNEOWYvOUdhMVQ3TTQ5UG9HVENaeHNJQmc0b2NUcndwNEFPUDVidkhRTDQr?=
 =?utf-8?B?Vk8zV1NobXhCeXNuSjlLdnZiWURnWE12MzF0MGdlNXhpWTNEc3VFK2ZXUXM2?=
 =?utf-8?B?N1d4WEQ4emdZOVpKUDhRYVk4MDV0VmRTaVZUdUNRZkNzOXMzQTc2UitBMThp?=
 =?utf-8?Q?5Tin4O?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 19:27:02.6021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab85c45d-5a09-4968-f89a-08ddc3d5938c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6113

From: Ashish Kalra <ashish.kalra@amd.com>

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU completion wait buffers (CWBs), command buffers and event buffer
registers remain locked and exclusive to the previous kernel. Attempts
to allocate and use new buffers in the kdump kernel fail, as hardware
ignores writes to the locked MMIO registers as per AMD IOMMU spec
Section 2.12.2.1.

This results in repeated "Completion-Wait loop timed out" errors and a
second kernel panic: "Kernel panic - not syncing: timer doesn't work
through Interrupt-remapped IO-APIC"

The following MMIO registers are locked and ignore writes after failed
SNP shutdown:
Command Buffer Base Address Register
Event Log Base Address Register
Completion Store Base Register/Exclusion Base Register
Completion Store Limit Register/Exclusion Limit Register
As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
remapping, which is required for proper operation.

Reuse the pages of the previous kernel for completion wait buffers,
command buffers, event buffers and memremap them during kdump boot
and essentially work with an already enabled IOMMU configuration and
re-using the previous kernel’s data structures.

Reusing of command buffers and event buffers is now done for kdump boot
irrespective of SNP being enabled during kdump.

Re-use of completion wait buffers is only done when SNP is enabled as
the exclusion base register is used for the completion wait buffer
(CWB) address only when SNP is enabled.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h |   5 +
 drivers/iommu/amd/init.c            | 163 ++++++++++++++++++++++++++--
 drivers/iommu/amd/iommu.c           |   2 +-
 3 files changed, 157 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 9b64cd706c96..082eb1270818 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -791,6 +791,11 @@ struct amd_iommu {
 	u32 flags;
 	volatile u64 *cmd_sem;
 	atomic64_t cmd_sem_val;
+	/*
+	 * Track physical address to directly use it in build_completion_wait()
+	 * and avoid adding any special checks and handling for kdump.
+	 */
+	u64 cmd_sem_paddr;
 
 #ifdef CONFIG_AMD_IOMMU_DEBUGFS
 	/* DebugFS Info */
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index cadb2c735ffc..32295f26be1b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -710,6 +710,23 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 	pci_seg->alias_table = NULL;
 }
 
+static inline void *iommu_memremap(unsigned long paddr, size_t size)
+{
+	phys_addr_t phys;
+
+	if (!paddr)
+		return NULL;
+
+	/*
+	 * Obtain true physical address in kdump kernel when SME is enabled.
+	 * Currently, IOMMU driver does not support booting into an unencrypted
+	 * kdump kernel.
+	 */
+	phys = __sme_clr(paddr);
+
+	return ioremap_encrypted(phys, size);
+}
+
 /*
  * Allocates the command buffer. This buffer is per AMD IOMMU. We can
  * write commands to that buffer later and the IOMMU will execute them
@@ -942,8 +959,105 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
 {
 	iommu->cmd_sem = iommu_alloc_4k_pages(iommu, GFP_KERNEL, 1);
+	if (!iommu->cmd_sem)
+		return -ENOMEM;
+	iommu->cmd_sem_paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
+	return 0;
+}
+
+static int __init remap_event_buffer(struct amd_iommu *iommu)
+{
+	u64 paddr;
+
+	pr_info_once("Re-using event buffer from the previous kernel\n");
+	/*
+	 * Read-back the event log base address register and apply
+	 * PM_ADDR_MASK to obtain the event log base address.
+	 */
+	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
+	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
+
+	return iommu->evt_buf ? 0 : -ENOMEM;
+}
+
+static int __init remap_command_buffer(struct amd_iommu *iommu)
+{
+	u64 paddr;
+
+	pr_info_once("Re-using command buffer from the previous kernel\n");
+	/*
+	 * Read-back the command buffer base address register and apply
+	 * PM_ADDR_MASK to obtain the command buffer base address.
+	 */
+	paddr = readq(iommu->mmio_base + MMIO_CMD_BUF_OFFSET) & PM_ADDR_MASK;
+	iommu->cmd_buf = iommu_memremap(paddr, CMD_BUFFER_SIZE);
+
+	return iommu->cmd_buf ? 0 : -ENOMEM;
+}
+
+static int __init remap_cwwb_sem(struct amd_iommu *iommu)
+{
+	u64 paddr;
+
+	if (check_feature(FEATURE_SNP)) {
+		/*
+		 * When SNP is enabled, the exclusion base register is used for the
+		 * completion wait buffer (CWB) address. Read and re-use it.
+		 */
+		pr_info_once("Re-using CWB buffers from the previous kernel\n");
+		/*
+		 * Read-back the exclusion base register and apply PM_ADDR_MASK
+		 * to obtain the exclusion range base address.
+		 */
+		paddr = readq(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET) & PM_ADDR_MASK;
+		iommu->cmd_sem = iommu_memremap(paddr, PAGE_SIZE);
+		if (!iommu->cmd_sem)
+			return -ENOMEM;
+		iommu->cmd_sem_paddr = paddr;
+	} else {
+		return alloc_cwwb_sem(iommu);
+	}
+
+	return 0;
+}
+
+static int __init alloc_iommu_buffers(struct amd_iommu *iommu)
+{
+	int ret;
+
+	/*
+	 * IOMMU Completion Store Base MMIO, Command Buffer Base Address MMIO
+	 * registers are locked if SNP is enabled during kdump, reuse/remap
+	 * the previous kernel's allocated completion wait and command buffers
+	 * for kdump boot.
+	 */
+	if (is_kdump_kernel()) {
+		ret = remap_cwwb_sem(iommu);
+		if (ret)
+			return ret;
+
+		ret = remap_command_buffer(iommu);
+		if (ret)
+			return ret;
+
+		ret = remap_event_buffer(iommu);
+		if (ret)
+			return ret;
+	} else {
+		ret = alloc_cwwb_sem(iommu);
+		if (ret)
+			return ret;
+
+		ret = alloc_command_buffer(iommu);
+		if (ret)
+			return ret;
 
-	return iommu->cmd_sem ? 0 : -ENOMEM;
+		ret = alloc_event_buffer(iommu);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static void __init free_cwwb_sem(struct amd_iommu *iommu)
@@ -951,6 +1065,38 @@ static void __init free_cwwb_sem(struct amd_iommu *iommu)
 	if (iommu->cmd_sem)
 		iommu_free_pages((void *)iommu->cmd_sem);
 }
+static void __init unmap_cwwb_sem(struct amd_iommu *iommu)
+{
+	if (iommu->cmd_sem) {
+		if (check_feature(FEATURE_SNP))
+			memunmap((void *)iommu->cmd_sem);
+		else
+			iommu_free_pages((void *)iommu->cmd_sem);
+	}
+}
+
+static void __init unmap_command_buffer(struct amd_iommu *iommu)
+{
+	memunmap((void *)iommu->cmd_buf);
+}
+
+static void __init unmap_event_buffer(struct amd_iommu *iommu)
+{
+	memunmap(iommu->evt_buf);
+}
+
+static void __init free_iommu_buffers(struct amd_iommu *iommu)
+{
+	if (is_kdump_kernel()) {
+		unmap_cwwb_sem(iommu);
+		unmap_command_buffer(iommu);
+		unmap_event_buffer(iommu);
+	} else {
+		free_cwwb_sem(iommu);
+		free_command_buffer(iommu);
+		free_event_buffer(iommu);
+	}
+}
 
 static void iommu_enable_xt(struct amd_iommu *iommu)
 {
@@ -1655,9 +1801,7 @@ static void __init free_sysfs(struct amd_iommu *iommu)
 static void __init free_iommu_one(struct amd_iommu *iommu)
 {
 	free_sysfs(iommu);
-	free_cwwb_sem(iommu);
-	free_command_buffer(iommu);
-	free_event_buffer(iommu);
+	free_iommu_buffers(iommu);
 	amd_iommu_free_ppr_log(iommu);
 	free_ga_log(iommu);
 	iommu_unmap_mmio_space(iommu);
@@ -1821,14 +1965,9 @@ static int __init init_iommu_one_late(struct amd_iommu *iommu)
 {
 	int ret;
 
-	if (alloc_cwwb_sem(iommu))
-		return -ENOMEM;
-
-	if (alloc_command_buffer(iommu))
-		return -ENOMEM;
-
-	if (alloc_event_buffer(iommu))
-		return -ENOMEM;
+	ret = alloc_iommu_buffers(iommu);
+	if (ret)
+		return ret;
 
 	iommu->int_enabled = false;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 7dc6d2dd8dd1..8e1b475e39c7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1201,7 +1201,7 @@ static void build_completion_wait(struct iommu_cmd *cmd,
 				  struct amd_iommu *iommu,
 				  u64 data)
 {
-	u64 paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
+	u64 paddr = iommu->cmd_sem_paddr;
 
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->data[0] = lower_32_bits(paddr) | CMD_COMPL_WAIT_STORE_MASK;
-- 
2.34.1


