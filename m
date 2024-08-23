Return-Path: <kvm+bounces-24900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0144095CDC4
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:28:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7697B1F2452A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C98186E51;
	Fri, 23 Aug 2024 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E+YIARNa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19FA186E2E;
	Fri, 23 Aug 2024 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419697; cv=fail; b=T5acpEZWfVB+aKLGBcbe53hznJDrO/YBsYdFr54/AKPMzcKKOeRV4Y6lZTqAL+LLu65ab454JxT7noukmQDx9rpxKwioHibRPXuI4Gz1rJD4gcREXiILj7QU0Y5vjA+JZdKBEryL1dILykucPzs2+hORR7RC7es78S7SJS92IZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419697; c=relaxed/simple;
	bh=cgmQ4ZyBdo1nDOdqDWpiK6RX7psT+/mLZf9PRsToARk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nxF+KG+qYAM/wAVwebhaq8RYFJ1Y4CmSv6NDB8CUjVPLBiYzlpOXZIeOUDI/j8KbFmXN11ePgzqCXkVyo1xg9umishkXaU1bgVM+30AGjddRcCAzGiEaIdaFPPe15G0VykK1jPpH6Ewqx8GCi8vwxR8OCS9JOuhX7SVepjsawA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E+YIARNa; arc=fail smtp.client-ip=40.107.96.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=soXzfpfs7Veqvjq3Tn58x4EwjAunt+hj4MGsolIZTwj/zOrqomn4M1DK/CEf12jXThF+OG0t3y+W6//6IAQPeY8KKc/IAmDTpjeNIWSRT1eTjna1H8Y74D4tjQEU/N223APkUbXrnjv5crw+BvGnb5Gry2Rsapcw8cZgYWg21aIfu/BE7y0CZENclrBGN6OeIMgel/qvwnQk4RK9MMMw/UrSrVo85ArnIGiFyBAudH7vo92cwv33eN66td2jclK0Pp0yTXpVl9BvX/Bdr2f3Rwl+2/DiDT5sg4eYAZ5iggM0/FiG4o52otLVKobQgr+0Z471z5dqUFhn47fBWfjX/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4MfnhXbC6eEvw4KXOfYX4A7QfJIE1AMdSlfvO6KhLNU=;
 b=asVvwhZ28LnitFes4aV3EX9hxoqSDk+DeNTBRjGosXjk1v0v6srlqmLdClgAtLU4vin8Z13DdjTCv7cO3HCVcytTF8DjyvdxqwbM7ImekmF5qJC+SL2Whj2Azi9Mzt388Ec7GIJuYaqGKf0UPub63A1HnD8Nie+S2hMPqR7XqEp9oWtaMOUVYzU0LlgB+U5bUa2OiOOKMuPYWSOkaG/f+yePI+8Uosr1uL30BbLrhkInnHpMbYwB9WqfGlG3MqhDrYBqPosAjXBOi1vliU9zhMTm9Ga+PxBsYlIUOj6hNBj4AM1WyxsnxtEuCG9JRbqBC8k0K+LSjUTZsFvVuuqrSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MfnhXbC6eEvw4KXOfYX4A7QfJIE1AMdSlfvO6KhLNU=;
 b=E+YIARNaTea4eZcgPYaxN0rE2E1PlDlTyXCY+qnt7bWE4u8goWTNOvzrNUj997OvVFE1fn489VYoUUXX/jKKfpEMsLsHPmcxo9ZD9pOW5zi2gC+V8mo47DTcU1vTYIg+Msf91tBsafw58jOT0M/5GMGh/Dn4hc3wIN6rcYAZr1s=
Received: from CH2PR04CA0009.namprd04.prod.outlook.com (2603:10b6:610:52::19)
 by IA1PR12MB6458.namprd12.prod.outlook.com (2603:10b6:208:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:28:11 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:610:52:cafe::50) by CH2PR04CA0009.outlook.office365.com
 (2603:10b6:610:52::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:28:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:28:11 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:28:06 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 03/21] pci: Define TEE-IO bit in PCIe device capabilities
Date: Fri, 23 Aug 2024 23:21:17 +1000
Message-ID: <20240823132137.336874-4-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|IA1PR12MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: 236fd4ef-5e67-4ed1-1bd0-08dcc3776f60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MgiTxUAzToOIbvvngD/AFQc3b4VRARG7xMABCNGfGhqm5lXy0WWUrOL3BVjp?=
 =?us-ascii?Q?Fnowy9Tc4lvHjY7x82q9/jjvfholFC7tEHHuOjCTBp34ENHYTiWEqOAF3WrV?=
 =?us-ascii?Q?6Jf44XekLK5BYhxnaveQj7b4ftptArXAD9Ndb1HK+gVmc4PKOHI0ON/H9vQ1?=
 =?us-ascii?Q?bqlBtwrW0/EImuraSZ7RM0LwfyokWUg2bAFwQUrA/B87rZdYDv+UgUNB0WFl?=
 =?us-ascii?Q?pmqmTytTJ/MgzNWsL94/o80gqUAtmU+qqvS/CBn3/xEr4xYhWoadosttWS1d?=
 =?us-ascii?Q?ruQJ+9vqrdUvmPbuWe70nS0inZyCUHM2kFtqEpRPIBQSe464CWTbdy5iOrgd?=
 =?us-ascii?Q?sCyG0ixfs0tyvkrf2m+FeGpTIDoa+ORlbXNpQTXKzcwc2ivBjuPvcpAZqyBQ?=
 =?us-ascii?Q?p86uTn907i6Jqc2vPT3jQmdygzOcuwKBKsdxNSkp82bN/F01HPjXSlUgUP06?=
 =?us-ascii?Q?ZY5Jbz6yWJWBGU1DGbD9fvHA3LSqAMAj8qRV+07JCtVi/XC/WUVM1/cNvejH?=
 =?us-ascii?Q?8IEBZfuRs+JA9O6e34Oh98uZd9JJSRhqeAe6IJNuG0Pk+6sCcWwaW9a007l8?=
 =?us-ascii?Q?jliZRIG0kMD2dOu09zfwtPm+u1BtxBcCimWT989+CduIC3bYUSoeyDUA2iZy?=
 =?us-ascii?Q?2bwtC/jUgV90BDS/FPton76DNmrEt/EYMsqhMIuDvzDYDWf7iz8gXvF//JHk?=
 =?us-ascii?Q?gkT8mnFeXX9Ki6e5aK3M1hP5n4FsvF9RWyCEc/5CMZZlYQa0BeWWv+cS55B+?=
 =?us-ascii?Q?vuNr+LuLoJL5PVHqzOj9sMpo2nrZ8f808IeSFM5io7gfm+N1uTKCFowyDplQ?=
 =?us-ascii?Q?Zu8VLVVj3gUTELW4iH5rg369weCBexM4Exmb6Hk/1unRw3bHk2vHzvgRt+BR?=
 =?us-ascii?Q?j/annhYrDXBCwkih0Qm8dG9s69gMyZZAFUo8oeQqPV2ngtcbui8TBJSXmbPb?=
 =?us-ascii?Q?RdNB9CTwqncvPhP04ocWeolyNyfcqZ7tsGmguWD7Jb/8ZHsDIPOhO/mb+Omm?=
 =?us-ascii?Q?IS5EfE21vDRfiuUXzULtP3NGNgUimCJeGaaZFcNcVuOewKUkEiqvGTTJONhw?=
 =?us-ascii?Q?/7hv9ydPJh6JF0ENv8sIjZFaC/Zp+UeEeI6laZL88hbhnlTk/389vBixZmLi?=
 =?us-ascii?Q?Tf69w+6sdNSAu+kxj+fMml913MjJXjBBX9i3bzuTLMggMrun79mVm2pPWbiu?=
 =?us-ascii?Q?BkHSj8fREEt0/RPfSMMGG1I5UlbPZqkJebegchIMWROb7FlZznXqN/zy7zg0?=
 =?us-ascii?Q?NzPQXva1/3cDmB4Qlhkg5U9KSxQxNYky1NZUdhMdPiR5ajwyGMN3WOL/4kOd?=
 =?us-ascii?Q?3sFqtI+bpleCCRPz5FBj4aoXUemo1i2SHyBaQugdO14Tzp5C+PdkD8azwO+G?=
 =?us-ascii?Q?V+Pmb1XBcsS4Kd8USFXgwvexGg/O9MxPB+plm4BsmC1TRbyCa1KJMpsBNCnG?=
 =?us-ascii?Q?XFmIKzNmDm3JVUcS/63tkGIK1jNjLSXA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:28:11.5924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 236fd4ef-5e67-4ed1-1bd0-08dcc3776f60
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6458

A new bit #30 from the PCI Express Device Capabilities Register is defined
in PCIe 6.1 as "TEE Device Interface Security Protocol (TDISP)".

Define the macro.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/uapi/linux/pci_regs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 94c00996e633..0011a301b8c5 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -498,6 +498,7 @@
 #define  PCI_EXP_DEVCAP_PWR_VAL	0x03fc0000 /* Slot Power Limit Value */
 #define  PCI_EXP_DEVCAP_PWR_SCL	0x0c000000 /* Slot Power Limit Scale */
 #define  PCI_EXP_DEVCAP_FLR     0x10000000 /* Function Level Reset */
+#define  PCI_EXP_DEVCAP_TEE_IO  0x40000000 /* TEE-IO Supported (TDISP) */
 #define PCI_EXP_DEVCTL		0x08	/* Device Control */
 #define  PCI_EXP_DEVCTL_CERE	0x0001	/* Correctable Error Reporting En. */
 #define  PCI_EXP_DEVCTL_NFERE	0x0002	/* Non-Fatal Error Reporting Enable */
-- 
2.45.2


