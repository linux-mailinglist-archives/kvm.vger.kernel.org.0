Return-Path: <kvm+bounces-24906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF2295CDD5
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0101D284970
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A59C186E3E;
	Fri, 23 Aug 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nhThw7Vc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FAB18661A;
	Fri, 23 Aug 2024 13:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419791; cv=fail; b=JeBUluoupzU5kvL7l9d3Hi1QsA9Sp+e+zLq9IdZP3klEhVNmcBlgHFod/hjKuOOBw0ZGGb+tcatn+HuN9pVotbM/aiL49meNcch0m+GgGu2C5H+8V2G4GilBOzsarEZTVA3F7HXn2EFJzNisXipQzDEqeTyFICG/kaO45ENmJsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419791; c=relaxed/simple;
	bh=CAXlWieY1zjmBKpKxxJEhwNSN2PPRtqtkPC/25vZYP8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NNBFKlWRqxLXiTth2zhKNzXdRhT77nlTLSv9BWSx3waOo5siyltJuQTPkrF9OpEeMKqx7WlnONATFlYB5kemxHfu47/fta3G6PB5QI1rWKq9WEzQPlq94q7cAKx5LgkpL2CXJj67S+SWiUSLEoKDRuxbbr5tUPJICUd9Y+Ob5pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nhThw7Vc; arc=fail smtp.client-ip=40.107.94.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HorBYiTO9DQLRxEO64kNR8a9pgFQY18KFOkL+U+FvO4XvQSvsiCgbWrCjBiu5pCga+rWbRyGxiUIPJFEnWHGNYIwJl8reW1V386vASrWGkCd/offL+w6dqVX89y+xZFziFlz5Ar90zxDnywBgNYRgqyLe0acz1jY6FqpRaerLq1PA1sddgVYsIbLItjS6CTSrI0jFpNqgSA1IVwKskxmeMHaeNECwqU5YP0EzOcl+1fTX4H6kAoPq8fp5u9bTNFQLLwDq4MDNXNX4txnVp4kOsG3jGynDYfY9e8RfBo7fk0MLprmUOieG+8ZF5Lq8RhyqcGr4gKf9MSw+b/8UUAwcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snyOMY4TEGnTV+OBSBT8vsszssY97q/DhEOC5BvFc4A=;
 b=IjDyGZxQbOuVzrKwAifSFdZG/c4ROHpEV9uBn7qDnwhfX+CKEXwxPNdOhrVSqMSJOgtP/P+Qe6ggZKoIgjwiGaRWoNWO4z0O1JLyA6AwhOXuJGynYg42b+7LjKxVZlnNzrsop0x4BggH3AKvuIuJoY4Vnz8ee+GV1zYGHiUGeWZOmQOg0nFhVui1eVPvuW9Fomdta3ASFcr0v4PcPWtuDKsUvTnRw9sx6ry54ilOqC9tj1Dal2IeQ4CoQ9mbjXbvoAL0B6rjRQzT0RJ+2lBYSvo264OwW/x6DH6Ch32OU92kIBFPZPMWb7unDwvAnJQckE8qY2HEawIzlRvIg1uVUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snyOMY4TEGnTV+OBSBT8vsszssY97q/DhEOC5BvFc4A=;
 b=nhThw7Vc7Pcw9rza2V0ypRvECwM/cwbspdxoXP95RSCVJZmXASkOyIN6uzhP+bzgHlrfrJr3LP61v/5NNx3fa3xsJC7ocee5GczQ4NCGxq8WwRW4e3f3dA/waBdgREFIZfKPb8/76B9G9tPwRXIV2IVw/MZ2c7Dr2KwB6CNSehw=
Received: from DM6PR21CA0015.namprd21.prod.outlook.com (2603:10b6:5:174::25)
 by CH3PR12MB9220.namprd12.prod.outlook.com (2603:10b6:610:198::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Fri, 23 Aug
 2024 13:29:41 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:174:cafe::95) by DM6PR21CA0015.outlook.office365.com
 (2603:10b6:5:174::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.13 via Frontend
 Transport; Fri, 23 Aug 2024 13:29:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:29:41 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:29:35 -0500
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
Subject: [RFC PATCH 08/21] crypto/ccp: Implement SEV TIO firmware interface
Date: Fri, 23 Aug 2024 23:21:22 +1000
Message-ID: <20240823132137.336874-9-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|CH3PR12MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f9e323d-85c8-43e2-852f-08dcc377a4fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z01VVkRpUjJ2NXNDYW5ZR2ovd3dwM1ZScmc1TzFZU0ZmRFlsb2RJbXBzUUNV?=
 =?utf-8?B?YjR4bmhub0swUlE2UFFRZGErNWdyT3FDcnN2eG9NL1pQWG1MbVc4Wk1seWZH?=
 =?utf-8?B?RGtCSjBLZ0d5U0pBd2FDOU5ZTjdCY1dodFdrVmhHMHhBdUJjN2pCYWtWUnJD?=
 =?utf-8?B?M0FCb1dIUklHM1FKT0pjeGdRelFKOGtCamtoVlJGZVc2REJqblVRQmFhazFm?=
 =?utf-8?B?MzNvejRRUGVuTUR5VXZ2YW1CQjRMeWJYTHM5OTZLOWRRbTFHa0FUVUNtcDhU?=
 =?utf-8?B?WGtWV04vcnhiU0c2NWRPV3c0Q24vb3IwTjErWnVGV1psTDlOWnRQdzZhUGd6?=
 =?utf-8?B?YmJ6WDhnTE1FK21NVm11T1Z3bEhvSTJZUjI4VzVQUlV4bHU3WkJBV25zUFdY?=
 =?utf-8?B?QUpDTUZEc1JUV1I5ZU5CUGowK1NmZ2phVHVnaXR0allTM2U5R0l4OFUvdkF3?=
 =?utf-8?B?Y2wzSEVXSUFDaUwwMityS1ZIdTI2ZVpCUFAxYWZQMXZ0WmNRcXBlZ0E5eGVX?=
 =?utf-8?B?V0RlUVFyVTdoSzJQbVh3TXorUkVZU3UxVVJmRlNJYW85V1hZRllQYXp0QVhp?=
 =?utf-8?B?d3dkeTFSa3pxSkZxUDZ5RnBZdEM4SkFLWUR1Y2UrWDhJWkVUVXk3VmRIbVJI?=
 =?utf-8?B?bm5KM0NHb3Z2K3NBM3RuNldZdVhMNmNpV2RmT2FKTVo2YytnNGpmZHdXVDQ5?=
 =?utf-8?B?cW5lUzV2dU9jSS96QUNJN2J3bnRDakQ0TkJjYjJaam9GdEtPaENNRzQrWk9N?=
 =?utf-8?B?UE0wbnJtcWtENHVYTXBoYVpYMWZvczYzUTRLQ0xUV3ZwekMvUi9OYVdmSFlF?=
 =?utf-8?B?djdFNEozdWRheitBVEpZcUIvLzh3RndsaHNMSGYzWVJKaFErc0QvRGJJQUZG?=
 =?utf-8?B?eWZyc0RXVWpaVkhGMXlvVjlrRmhBeEpwVE52ZFY0b2YrK3EzNVVBeTd1ck5Y?=
 =?utf-8?B?VThmNXR1Um1meHlQaTcwRUVNMG9Nc3ZZRlJsd08xd1AxUGo3TEdUREtZOVBL?=
 =?utf-8?B?UVd1Sms2WEQ0bjJzQVY5a1YvSGlTeUd6RGRTUWZjYzNKcUtETm1IMVl6RS9W?=
 =?utf-8?B?Si96UXgveFVQbWQ0Q3Z0dEtOdnJReCtSV1haL1RjUGVrdzBrMzYrOTRHaElP?=
 =?utf-8?B?dk1FTDNnTHZuaFdNSS9oMDcxTGlUazFoaGVEekNLRGRkRnJiTXEzNHZiVnJT?=
 =?utf-8?B?cXFwaGFMMUx4aHdObkYwVVpKbE91NWIvWkUwNmZzeXlJNElyaVNUQWxuL0tt?=
 =?utf-8?B?c3hoQnNqRkl3VENLeDhrMkNZVmc0Qk0zQW90VXR3bzhZc05DaHJDTlNYbVBQ?=
 =?utf-8?B?OE9iakZDamRwMENjcE4wemV5M3V6bm44M0hXYXlRTVVDREJsdjVWa1pNcUlL?=
 =?utf-8?B?VjRsSlNWWkQwT0lGK1lEYkV4dzB1WDQwRFlLN3o5NkdUZXJKNmxYWk03amN3?=
 =?utf-8?B?RUkvQ2pQYUJHV2RuQzRrOTVmd2xsdGJqc0xvc0gzQjRUTiszNU4wWGdLMzBS?=
 =?utf-8?B?RzE5UktnbGFYV3dGSStKM3RFWGlXL3FnTWJnaVJGSituQU12eWJlZy9ydFdD?=
 =?utf-8?B?UEhlZEJDRlBJd3BvcTNlck14d2FIbFA1SFF6NkxYYlc5NUJFTjlGeWROdDFm?=
 =?utf-8?B?aGU5YlZBK1R4SXFWVjlqdDNtK2lsRHJJdEhsbjNmWUtVaGd2N0NHdHBiYXdS?=
 =?utf-8?B?eDBzQjZ2TytLTnNRaWptcDdCRjY2alIrbGVYb0FreXI1YkdyeUFEbHpIS21k?=
 =?utf-8?B?b1BIaTZMQVB4eExpL3pydlI0b05kSXpGYXE0UTFYK2ZOWXUwa0w4akRGZ3ZZ?=
 =?utf-8?B?bk45UllmMEVSbGFWK2IralJrUjQyd0huR0pZRllPSGc5T0xJUVJ5YU1aZjh5?=
 =?utf-8?B?WFJuV1pWK1RlWFJRRFBxaUE5VUlrMjlyRzhESm9ET3ZWRmNrSTlPZWV0NG52?=
 =?utf-8?Q?x/lw+NXsqlUN7JuRZADJ0gQbKD4P/AcB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:29:41.4767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9e323d-85c8-43e2-852f-08dcc377a4fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9220

Implement SEV TIO PSP command wrappers in sev-dev-tio.c, these make
SPDM calls and store the data in the SEV-TIO-specific structs.

Implement tsm_ops for the hypervisor, the TSM module will call these
when loaded on the host and its tsm_set_ops() is called. The HV ops
are implemented in sev-dev-tsm.c.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/Makefile      |    2 +
 arch/x86/include/asm/sev.h       |   20 +
 drivers/crypto/ccp/sev-dev-tio.h |  105 ++
 drivers/crypto/ccp/sev-dev.h     |    2 +
 include/linux/psp-sev.h          |   60 +
 drivers/crypto/ccp/sev-dev-tio.c | 1565 ++++++++++++++++++++
 drivers/crypto/ccp/sev-dev-tsm.c |  397 +++++
 drivers/crypto/ccp/sev-dev.c     |   10 +-
 8 files changed, 2159 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 394484929dae..d9871465dd08 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -11,6 +11,8 @@ ccp-$(CONFIG_PCI) += sp-pci.o
 ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
                                    sev-dev.o \
                                    tee-dev.o \
+				   sev-dev-tio.o \
+				   sev-dev-tsm.o \
                                    platform-access.o \
                                    dbc.o \
                                    hsti.o
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 79bbe2be900e..80d9aa16fe61 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -138,6 +138,14 @@ enum msg_type {
 	SNP_MSG_ABSORB_RSP,
 	SNP_MSG_VMRK_REQ,
 	SNP_MSG_VMRK_RSP,
+	TIO_MSG_TDI_INFO_REQ        = 0x81,
+	TIO_MSG_TDI_INFO_RSP        = 0x01,
+	TIO_MSG_MMIO_VALIDATE_REQ   = 0x82,
+	TIO_MSG_MMIO_VALIDATE_RSP   = 0x02,
+	TIO_MSG_MMIO_CONFIG_REQ     = 0x83,
+	TIO_MSG_MMIO_CONFIG_RSP     = 0x03,
+	TIO_MSG_SDTE_WRITE_REQ      = 0x84,
+	TIO_MSG_SDTE_WRITE_RSP      = 0x04,
 
 	SNP_MSG_TYPE_MAX
 };
@@ -171,6 +179,18 @@ struct sev_guest_platform_data {
 	u64 secrets_gpa;
 };
 
+/* SPDM algorithms used for TDISP, used in TIO_MSG_TDI_INFO_REQ */
+#define TIO_SPDM_ALGOS_DHE_SECP256R1			0
+#define TIO_SPDM_ALGOS_DHE_SECP384R1			1
+#define TIO_SPDM_ALGOS_AEAD_AES_128_GCM			(0<<8)
+#define TIO_SPDM_ALGOS_AEAD_AES_256_GCM			(1<<8)
+#define TIO_SPDM_ALGOS_ASYM_TPM_ALG_RSASSA_3072		(0<<16)
+#define TIO_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P256	(1<<16)
+#define TIO_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P384	(2<<16)
+#define TIO_SPDM_ALGOS_HASH_TPM_ALG_SHA_256		(0<<24)
+#define TIO_SPDM_ALGOS_HASH_TPM_ALG_SHA_384		(1<<24)
+#define TIO_SPDM_ALGOS_KEY_SCHED_SPDM_KEY_SCHEDULE	(0ULL<<32)
+
 /*
  * The secrets page contains 96-bytes of reserved field that can be used by
  * the guest OS. The guest OS uses the area to save the message sequence
diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
new file mode 100644
index 000000000000..761cc88699c4
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev-tio.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __PSP_SEV_TIO_H__
+#define __PSP_SEV_TIO_H__
+
+#include <linux/tsm.h>
+#include <uapi/linux/psp-sev.h>
+
+#if defined(CONFIG_CRYPTO_DEV_SP_PSP) || defined(CONFIG_CRYPTO_DEV_SP_PSP_MODULE)
+
+int sev_tio_cmd_buffer_len(int cmd);
+
+struct sla_addr_t {
+	union {
+		u64 sla;
+		struct {
+			u64 page_type:1;
+			u64 page_size:1;
+			u64 reserved1:10;
+			u64 pfn:40;
+			u64 reserved2:12;
+		};
+	};
+} __packed;
+
+#define SEV_TIO_MAX_COMMAND_LENGTH	128
+#define SEV_TIO_MAX_DATA_LENGTH		256
+
+/* struct tsm_dev::data */
+struct tsm_dev_tio {
+	struct sla_addr_t dev_ctx;
+	struct sla_addr_t req;
+	struct sla_addr_t resp;
+	struct sla_addr_t scratch;
+	struct sla_addr_t output;
+	struct sla_buffer_hdr *reqbuf; /* vmap'ed @req for DOE */
+	struct sla_buffer_hdr *respbuf; /* vmap'ed @resp for DOE */
+
+	int cmd;
+	int psp_ret;
+	u8 cmd_data[SEV_TIO_MAX_COMMAND_LENGTH];
+	u8 data[SEV_TIO_MAX_DATA_LENGTH]; /* Data page for SPDM-aware commands returning some data */
+};
+
+/* struct tsm_tdi::data */
+struct tsm_tdi_tio {
+	struct sla_addr_t tdi_ctx;
+	u64 gctx_paddr;
+
+	u64 vmid;
+	u32 asid;
+};
+
+#define SPDM_DOBJ_ID_NONE		0
+#define SPDM_DOBJ_ID_REQ		1
+#define SPDM_DOBJ_ID_RESP		2
+#define SPDM_DOBJ_ID_CERTIFICATE	4
+#define SPDM_DOBJ_ID_MEASUREMENT	5
+#define SPDM_DOBJ_ID_REPORT		6
+
+void sev_tio_cleanup(void);
+
+void tio_save_output(struct tsm_blob **blob, struct sla_addr_t sla, u32 dobjid);
+
+int sev_tio_status(void);
+int sev_tio_continue(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm);
+
+int sev_tio_dev_measurements(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm);
+int sev_tio_dev_certificates(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm);
+int sev_tio_dev_create(struct tsm_dev_tio *dev_data, u16 device_id, u16 root_port_id,
+		       u8 segment_id);
+int sev_tio_dev_connect(struct tsm_dev_tio *dev_data, u8 tc_mask, u8 cert_slot,
+			struct tsm_spdm *spdm);
+int sev_tio_dev_disconnect(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm);
+int sev_tio_dev_reclaim(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm);
+int sev_tio_dev_status(struct tsm_dev_tio *dev_data, struct tsm_dev_status *status);
+int sev_tio_ide_refresh(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm);
+
+int sev_tio_tdi_create(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data, u16 dev_id,
+		       u8 rseg, u8 rseg_valid);
+void sev_tio_tdi_reclaim(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data);
+int sev_tio_guest_request(void *data, u32 guest_rid, u64 gctx_paddr,
+			  struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+			  struct tsm_spdm *spdm);
+
+int sev_tio_tdi_bind(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		     __u32 guest_rid, u64 gctx_paddr, struct tsm_spdm *spdm);
+int sev_tio_tdi_unbind(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		       struct tsm_spdm *spdm);
+int sev_tio_tdi_report(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		       u64 gctx_paddr, struct tsm_spdm *spdm);
+
+int sev_tio_asid_fence_clear(u16 device_id, u8 segment_id, u64 gctx_paddr, int *psp_ret);
+int sev_tio_asid_fence_status(struct tsm_dev_tio *dev_data, u16 device_id, u8 segment_id,
+			      u32 asid, bool *fenced);
+
+int sev_tio_tdi_info(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		     struct tsm_tdi_status *ts);
+int sev_tio_tdi_status(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		       struct tsm_spdm *spdm);
+int sev_tio_tdi_status_fin(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+			   enum tsm_tdisp_state *state);
+
+#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
+
+#endif	/* __PSP_SEV_TIO_H__ */
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 59842157e9d1..a74698a1e433 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -67,4 +67,6 @@ void sev_pci_exit(void);
 
 bool sev_version_greater_or_equal(u8 maj, u8 min);
 
+void sev_tsm_set_ops(bool set);
+
 #endif /* __SEV_DEV_H */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 1d63044f66be..adf40e0316dc 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -12,6 +12,7 @@
 #ifndef __PSP_SEV_H__
 #define __PSP_SEV_H__
 
+#include <linux/tsm.h>
 #include <uapi/linux/psp-sev.h>
 
 #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
@@ -109,6 +110,27 @@ enum sev_cmd {
 	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
 	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
 
+	/* SEV-TIO commands */
+	SEV_CMD_TIO_STATUS		= 0x0D0,
+	SEV_CMD_TIO_INIT		= 0x0D1,
+	SEV_CMD_TIO_DEV_CREATE		= 0x0D2,
+	SEV_CMD_TIO_DEV_RECLAIM		= 0x0D3,
+	SEV_CMD_TIO_DEV_CONNECT		= 0x0D4,
+	SEV_CMD_TIO_DEV_DISCONNECT	= 0x0D5,
+	SEV_CMD_TIO_DEV_STATUS		= 0x0D6,
+	SEV_CMD_TIO_DEV_MEASUREMENTS	= 0x0D7,
+	SEV_CMD_TIO_DEV_CERTIFICATES	= 0x0D8,
+	SEV_CMD_TIO_TDI_CREATE		= 0x0DA,
+	SEV_CMD_TIO_TDI_RECLAIM		= 0x0DB,
+	SEV_CMD_TIO_TDI_BIND		= 0x0DC,
+	SEV_CMD_TIO_TDI_UNBIND		= 0x0DD,
+	SEV_CMD_TIO_TDI_REPORT		= 0x0DE,
+	SEV_CMD_TIO_TDI_STATUS		= 0x0DF,
+	SEV_CMD_TIO_GUEST_REQUEST	= 0x0E0,
+	SEV_CMD_TIO_ASID_FENCE_CLEAR	= 0x0E1,
+	SEV_CMD_TIO_ASID_FENCE_STATUS	= 0x0E2,
+	SEV_CMD_TIO_TDI_INFO		= 0x0E3,
+	SEV_CMD_TIO_ROLL_KEY		= 0x0E4,
 	SEV_CMD_MAX,
 };
 
@@ -147,6 +169,7 @@ struct sev_data_init_ex {
 } __packed;
 
 #define SEV_INIT_FLAGS_SEV_ES	0x01
+#define SEV_INIT_FLAGS_SEV_TIO_EN	BIT(2)
 
 /**
  * struct sev_data_pek_csr - PEK_CSR command parameters
@@ -752,6 +775,11 @@ struct sev_data_snp_guest_request {
 	u64 res_paddr;				/* In */
 } __packed;
 
+struct tio_guest_request {
+	struct sev_data_snp_guest_request data;
+	int fw_err;
+};
+
 /**
  * struct sev_data_snp_init_ex - SNP_INIT_EX structure
  *
@@ -1007,4 +1035,36 @@ static inline void snp_free_firmware_page(void *addr) { }
 
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
+/*
+ * TIO_GUEST_REQUEST's TIO_MSG_MMIO_VALIDATE_REQ
+ * encoding for MMIO in RDX:
+ *
+ * ........ ....GGGG GGGGGGGG GGGGGGGG GGGGGGGG GGGGGGGG GGGGOOOO OOOO.rrr
+ * Where:
+ *	G - guest physical address
+ *	O - order of 4K pages
+ *	r - range id == BAR
+ */
+#define MMIO_VALIDATE_GPA(r)      ((r) & 0x000FFFFFFFFFF000ULL)
+#define MMIO_VALIDATE_LEN(r)      (1ULL << (12 + (((r) >> 4) & 0xFF)))
+#define MMIO_VALIDATE_RANGEID(r)  ((r) & 0x7)
+#define MMIO_VALIDATE_RESERVED(r) ((r) & 0xFFF0000000000008ULL)
+
+/* Optional Certificates/measurements/report data from TIO_GUEST_REQUEST */
+struct tio_blob_table_entry {
+	guid_t guid;
+	u32 offset;
+	u32 length;
+};
+
+/* Measurement’s blob: 5caa80c6-12ef-401a-b364-ec59a93abe3f */
+#define TIO_GUID_MEASUREMENTS \
+	GUID_INIT(0x5caa80c6, 0x12ef, 0x401a, 0xb3, 0x64, 0xec, 0x59, 0xa9, 0x3a, 0xbe, 0x3f)
+/* Certificates blob: 078ccb75-2644-49e8-afe7-5686c5cf72f1 */
+#define TIO_GUID_CERTIFICATES \
+	GUID_INIT(0x078ccb75, 0x2644, 0x49e8, 0xaf, 0xe7, 0x56, 0x86, 0xc5, 0xcf, 0x72, 0xf1)
+/* Attestation report: 70dc5b0e-0cc0-4cd5-97bb-ff0ba25bf320 */
+#define TIO_GUID_REPORT \
+	GUID_INIT(0x70dc5b0e, 0x0cc0, 0x4cd5, 0x97, 0xbb, 0xff, 0x0b, 0xa2, 0x5b, 0xf3, 0x20)
+
 #endif	/* __PSP_SEV_H__ */
diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
new file mode 100644
index 000000000000..42741b17c747
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev-tio.c
@@ -0,0 +1,1565 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+// Interface to PSP for CCP/SEV-TIO/SNP-VM
+
+#include <linux/pci.h>
+#include <linux/pci-doe.h>
+#include <linux/tsm.h>
+#include <linux/psp.h>
+#include <linux/file.h>
+#include <linux/vmalloc.h>
+#include <linux/smp.h>
+
+#include <asm/sev-common.h>
+#include <asm/sev.h>
+#include <asm/page.h>
+
+#include "psp-dev.h"
+#include "sev-dev.h"
+#include "sev-dev-tio.h"
+
+#define SLA_PAGE_TYPE_DATA	0
+#define SLA_PAGE_TYPE_SCATTER	1
+#define SLA_PAGE_SIZE_4K	0
+#define SLA_PAGE_SIZE_2M	1
+#define SLA_SZ(s)		((s).page_size == SLA_PAGE_SIZE_2M ? SZ_2M : SZ_4K)
+#define SLA_SCATTER_LEN(s)	(SLA_SZ(s) / sizeof(struct sla_addr_t))
+#define SLA_EOL			((struct sla_addr_t) { .pfn = 0xFFFFFFFFFFUL })
+#define SLA_NULL		((struct sla_addr_t) { 0 })
+#define IS_SLA_NULL(s)		((s).sla == SLA_NULL.sla)
+#define IS_SLA_EOL(s)		((s).sla == SLA_EOL.sla)
+
+/* the BUFFER Structure */
+struct sla_buffer_hdr {
+	u32 capacity_sz;
+	u32 payload_sz; /* The size of BUFFER_PAYLOAD in bytes. Must be multiple of 32B */
+	union {
+		u32 flags;
+		struct {
+			u32 encryption:1;
+		};
+	};
+	u32 reserved1;
+	u8 iv[16];	/* IV used for the encryption of this buffer */
+	u8 authtag[16]; /* Authentication tag for this buffer */
+	u8 reserved2[16];
+} __packed;
+
+struct spdm_dobj_hdr {
+	u32 id;     /* Data object type identifier */
+	u32 length; /* Length of the data object, INCLUDING THIS HEADER. Must be a multiple of 32B */
+	union {
+		u16 ver; /* Version of the data object structure */
+		struct {
+			u8 minor;
+			u8 major;
+		} version;
+	};
+} __packed;
+
+enum spdm_data_type_t {
+	DOBJ_DATA_TYPE_SPDM = 0x1,
+	DOBJ_DATA_TYPE_SECURE_SPDM = 0x2,
+};
+
+struct spdm_dobj_hdr_req {
+	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_REQ */
+	u8 data_type; /* spdm_data_type_t */
+	u8 reserved2[5];
+} __packed;
+
+struct spdm_dobj_hdr_resp {
+	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_RESP */
+	u8 data_type; /* spdm_data_type_t */
+	u8 reserved2[5];
+} __packed;
+
+struct spdm_dobj_hdr_cert {
+	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_CERTIFICATE */
+	u8 reserved1[6];
+	u16 device_id;
+	u8 segment_id;
+	u8 type; /* 1h: SPDM certificate. 0h, 2h–FFh: Reserved. */
+	u8 reserved2[12];
+} __packed;
+
+struct spdm_dobj_hdr_meas {
+	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_MEASUREMENT */
+	u8 reserved1[6];
+	u16 device_id;
+	u8 segment_id;
+	u8 type; /* 1h: SPDM measurement. 0h, 2h–FFh: Reserved. */
+	u8 reserved2[12];
+} __packed;
+
+struct spdm_dobj_hdr_report {
+	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_REPORT */
+	u8 reserved1[6];
+	u16 device_id;
+	u8 segment_id;
+	u8 type; /* 1h: TDISP interface report. 0h, 2h–FFh: Reserved */
+	u8 reserved2[12];
+} __packed;
+
+/* Used in all SPDM-aware TIO commands */
+struct spdm_ctrl {
+	struct sla_addr_t req;
+	struct sla_addr_t resp;
+	struct sla_addr_t scratch;
+	struct sla_addr_t output;
+} __packed;
+
+static size_t sla_dobj_id_to_size(u8 id)
+{
+	size_t n;
+
+	BUILD_BUG_ON(sizeof(struct spdm_dobj_hdr_resp) != 0x10);
+	switch (id) {
+	case SPDM_DOBJ_ID_REQ:
+		n = sizeof(struct spdm_dobj_hdr_req);
+		break;
+	case SPDM_DOBJ_ID_RESP:
+		n = sizeof(struct spdm_dobj_hdr_resp);
+		break;
+	case SPDM_DOBJ_ID_CERTIFICATE:
+		n = sizeof(struct spdm_dobj_hdr_cert);
+		break;
+	case SPDM_DOBJ_ID_MEASUREMENT:
+		n = sizeof(struct spdm_dobj_hdr_meas);
+		break;
+	case SPDM_DOBJ_ID_REPORT:
+		n = sizeof(struct spdm_dobj_hdr_report);
+		break;
+	default:
+		WARN_ON(1);
+		n = 0;
+		break;
+	}
+
+	return n;
+}
+
+#define SPDM_DOBJ_HDR_SIZE(hdr)		sla_dobj_id_to_size((hdr)->id)
+#define SPDM_DOBJ_DATA(hdr)		((u8 *)(hdr) + SPDM_DOBJ_HDR_SIZE(hdr))
+#define SPDM_DOBJ_LEN(hdr)		((hdr)->length - SPDM_DOBJ_HDR_SIZE(hdr))
+
+#define sla_to_dobj_resp_hdr(buf)	((struct spdm_dobj_hdr_resp *) \
+					sla_to_dobj_hdr_check((buf), SPDM_DOBJ_ID_RESP))
+#define sla_to_dobj_req_hdr(buf)	((struct spdm_dobj_hdr_req *) \
+					sla_to_dobj_hdr_check((buf), SPDM_DOBJ_ID_REQ))
+
+static struct spdm_dobj_hdr *sla_to_dobj_hdr(struct sla_buffer_hdr *buf)
+{
+	if (!buf)
+		return NULL;
+
+	return (struct spdm_dobj_hdr *) &buf[1];
+}
+
+static struct spdm_dobj_hdr *sla_to_dobj_hdr_check(struct sla_buffer_hdr *buf, u32 check_dobjid)
+{
+	struct spdm_dobj_hdr *hdr = sla_to_dobj_hdr(buf);
+
+	if (hdr && hdr->id == check_dobjid)
+		return hdr;
+
+	pr_err("! ERROR: expected %d, found %d\n", check_dobjid, hdr->id);
+	return NULL;
+}
+
+static void *sla_to_data(struct sla_buffer_hdr *buf, u32 dobjid)
+{
+	struct spdm_dobj_hdr *hdr = sla_to_dobj_hdr(buf);
+
+	if (WARN_ON_ONCE(dobjid != SPDM_DOBJ_ID_REQ && dobjid != SPDM_DOBJ_ID_RESP))
+		return NULL;
+
+	if (!hdr)
+		return NULL;
+
+	return (u8 *) hdr + sla_dobj_id_to_size(dobjid);
+}
+
+/**
+ * struct sev_tio_status - TIO_STATUS command's info_paddr buffer
+ *
+ * @length: Length of this structure in bytes.
+ * @tio_init_done: Indicates TIO_INIT has been invoked
+ * @tio_en: Indicates that SNP_INIT_EX initialized the RMP for SEV-TIO.
+ * @spdm_req_size_min: Minimum SPDM request buffer size in bytes.
+ * @spdm_req_size_max: Maximum SPDM request buffer size in bytes.
+ * @spdm_scratch_size_min: Minimum  SPDM scratch buffer size in bytes.
+ * @spdm_scratch_size_max: Maximum SPDM scratch buffer size in bytes.
+ * @spdm_out_size_min: Minimum SPDM output buffer size in bytes
+ * @spdm_out_size_max: Maximum for the SPDM output buffer size in bytes.
+ * @spdm_rsp_size_min: Minimum SPDM response buffer size in bytes.
+ * @spdm_rsp_size_max: Maximum SPDM response buffer size in bytes.
+ * @devctx_size: Size of a device context buffer in bytes.
+ * @tdictx_size: Size of a TDI context buffer in bytes.
+ */
+struct sev_tio_status {
+	u32 length;
+	union {
+		u32 flags;
+		struct {
+			u32 tio_en:1;
+			u32 tio_init_done:1;
+		};
+	};
+	u32 spdm_req_size_min;
+	u32 spdm_req_size_max;
+	u32 spdm_scratch_size_min;
+	u32 spdm_scratch_size_max;
+	u32 spdm_out_size_min;
+	u32 spdm_out_size_max;
+	u32 spdm_rsp_size_min;
+	u32 spdm_rsp_size_max;
+	u32 devctx_size;
+	u32 tdictx_size;
+};
+
+/**
+ * struct sev_data_tio_status - SEV_CMD_TIO_STATUS command
+ *
+ * @length: Length of this command buffer in bytes
+ * @status_paddr: SPA of the TIO_STATUS structure
+ */
+struct sev_data_tio_status {
+	u32 length;
+	u32 reserved;
+	u64 status_paddr;
+} __packed;
+
+/* TIO_INIT */
+struct sev_data_tio_init {
+	u32 length;
+	u32 reserved[3];
+} __packed;
+
+static struct sev_tio_status *tio_status;
+
+void sev_tio_cleanup(void)
+{
+	kfree(tio_status);
+	tio_status = NULL;
+}
+
+/**
+ * struct sev_data_tio_dev_create - TIO_DEV_CREATE command
+ *
+ * @length: Length in bytes of this command buffer.
+ * @dev_ctx_sla: A scatter list address pointing to a buffer to be used as a device context buffer.
+ * @device_id: The PCIe Routing Identifier of the device to connect to.
+ * @root_port_id: FiXME: The PCIe Routing Identifier of the root port of the device.
+ * @segment_id: The PCIe Segment Identifier of the device to connect to.
+ */
+struct sev_data_tio_dev_create {
+	u32 length;
+	u32 reserved1;
+	struct sla_addr_t dev_ctx_sla;
+	u16 device_id;
+	u16 root_port_id;
+	u8 segment_id;
+	u8 reserved2[11];
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_connect - TIO_DEV_CONNECT
+ *
+ * @length: Length in bytes of this command buffer.
+ * @spdm_ctrl: SPDM control structure defined in Section 5.1.
+ * @device_id: The PCIe Routing Identifier of the device to connect to.
+ * @root_port_id: The PCIe Routing Identifier of the root port of the device.
+ * @segment_id: The PCIe Segment Identifier of the device to connect to.
+ * @dev_ctx_sla: Scatter list address of the device context buffer.
+ * @tc_mask: Bitmask of the traffic classes to initialize for SEV-TIO usage.
+ *           Setting the kth bit of the TC_MASK to 1 indicates that the traffic
+ *           class k will be initialized.
+ * @cert_slot: Slot number of the certificate requested for constructing the SPDM session.
+ * @ide_stream_id: IDE stream IDs to be associated with this device.
+ *                 Valid only if corresponding bit in TC_MASK is set.
+ */
+struct sev_data_tio_dev_connect {
+	u32 length;
+	u32 reserved1;
+	struct spdm_ctrl spdm_ctrl;
+	u8 reserved2[8];
+	struct sla_addr_t dev_ctx_sla;
+	u8 tc_mask;
+	u8 cert_slot;
+	u8 reserved3[6];
+	u8 ide_stream_id[8];
+	u8 reserved4[8];
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_disconnect - TIO_DEV_DISCONNECT
+ *
+ * @length: Length in bytes of this command buffer.
+ * @force: Force device disconnect without SPDM traffic.
+ * @spdm_ctrl: SPDM control structure defined in Section 5.1.
+ * @dev_ctx_sla: Scatter list address of the device context buffer.
+ */
+struct sev_data_tio_dev_disconnect {
+	u32 length;
+	union {
+		u32 flags;
+		struct {
+			u32 force:1;
+		};
+	};
+	struct spdm_ctrl spdm_ctrl;
+	struct sla_addr_t dev_ctx_sla;
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_meas - TIO_DEV_MEASUREMENTS
+ *
+ * @length: Length in bytes of this command buffer
+ * @raw_bitstream: 0: Requests the digest form of the attestation report
+ *                 1: Requests the raw bitstream form of the attestation report
+ * @spdm_ctrl: SPDM control structure defined in Section 5.1.
+ * @dev_ctx_sla: Scatter list address of the device context buffer.
+ */
+struct sev_data_tio_dev_meas {
+	u32 length;
+	union {
+		u32 flags;
+		struct {
+			u32 raw_bitstream:1;
+		};
+	};
+	struct spdm_ctrl spdm_ctrl;
+	struct sla_addr_t dev_ctx_sla;
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_certs - TIO_DEV_CERTIFICATES
+ *
+ * @length: Length in bytes of this command buffer
+ * @spdm_ctrl: SPDM control structure defined in Section 5.1.
+ * @dev_ctx_sla: Scatter list address of the device context buffer.
+ */
+struct sev_data_tio_dev_certs {
+	u32 length;
+	u32 reserved;
+	struct spdm_ctrl spdm_ctrl;
+	struct sla_addr_t dev_ctx_sla;
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_reclaim - TIO_DEV_RECLAIM command
+ *
+ * @length: Length in bytes of this command buffer
+ * @dev_ctx_paddr: SPA of page donated by hypervisor
+ */
+struct sev_data_tio_dev_reclaim {
+	u32 length;
+	u32 reserved;
+	struct sla_addr_t dev_ctx_sla;
+} __packed;
+
+/**
+ * struct sev_tio_dev_status - sev_data_tio_dev_status::status_paddr of
+ * TIO_DEV_STATUS command
+ *
+ */
+struct sev_tio_dev_status {
+	u32 length;
+	u8 ctx_state;
+	u8 reserved1;
+	union {
+		u8 p1;
+		struct {
+			u8 request_pending:1;
+			u8 request_pending_tdi:1;
+		};
+	};
+	u8 certs_slot;
+	u16 device_id;
+	u8 segment_id;
+	u8 tc_mask;
+	u16 request_pending_command;
+	u16 reserved2;
+	struct tdisp_interface_id request_pending_interface_id;
+	union {
+		u8 p2;
+		struct {
+			u8 meas_digest_valid:1;
+			u8 no_fw_update:1;
+		};
+	};
+	u8 reserved3[3];
+	u16 ide_stream_id[8];
+	u8 reserved4[8];
+	u8 certs_digest[48];
+	u8 meas_digest[48];
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_status - TIO_DEV_STATUS command
+ *
+ * @length: Length in bytes of this command buffer
+ * @dev_ctx_paddr: SPA of a device context page
+ * @status_length: Length in bytes of the sev_tio_dev_status buffer
+ * @status_paddr: SPA of the status buffer. See Table 16
+ */
+struct sev_data_tio_dev_status {
+	u32 length;				/* In */
+	u32 reserved;
+	struct sla_addr_t dev_ctx_paddr;		/* In */
+	u32 status_length;			/* In */
+	u64 status_paddr;			/* In */
+} __packed;
+
+/**
+ * struct sev_data_tio_tdi_create - TIO_TDI_CREATE command
+ *
+ * @length: Length in bytes of this command buffer
+ * @spdm_ctrl: SPDM control structure
+ * @dev_ctx_paddr: SPA of a device context page
+ * @tdi_ctx_paddr: SPA of page donated by hypervisor
+ * @interface_id: Interface ID of the TDI as defined by TDISP (host PCIID)
+ */
+struct sev_data_tio_tdi_create {
+	u32 length;				/* In */
+	u32 reserved;
+	struct sla_addr_t dev_ctx_sla;			/* In */
+	struct sla_addr_t tdi_ctx_sla;			/* In */
+	struct tdisp_interface_id interface_id;	/* In */
+	u8 reserved2[12];
+} __packed;
+
+struct sev_data_tio_tdi_reclaim {
+	u32 length;				/* In */
+	u32 reserved;
+	struct sla_addr_t dev_ctx_sla;			/* In */
+	struct sla_addr_t tdi_ctx_sla;			/* In */
+	u64 reserved2;
+} __packed;
+
+/*
+ * struct sev_data_tio_tdi_bind - TIO_TDI_BIND command
+ *
+ * @length: Length in bytes of this command buffer
+ * @spdm_ctrl: SPDM control structure defined in Chapter 2.
+ * @tdi_ctx_paddr: SPA of page donated by hypervisor
+ * @guest_ctx_paddr: SPA of guest context page
+ * @flags:
+ *  4 ALL_REQUEST_REDIRECT Requires ATS translated requests to route through
+ *                         the root complex. Must be 1.
+ *  3 BIND_P2P Enables direct P2P. Must be 0
+ *  2 LOCK_MSIX Lock the MSI-X table and PBA.
+ *  1 CACHE_LINE_SIZE Indicates the cache line size. 0 indicates 64B. 1 indicates 128B.
+ *                    Must be 0.
+ *  0 NO_FW_UPDATE Indicates that no firmware updates are allowed while the interface
+ *                 is locked.
+ * @mmio_reporting_offset: Offset added to the MMIO range addresses in the interface
+ *                         report.
+ * @guest_interface_id: Hypervisor provided identifier used by the guest to identify
+ *                      the TDI in guest messages
+ */
+struct sev_data_tio_tdi_bind {
+	u32 length;				/* In */
+	u32 reserved;
+	struct spdm_ctrl spdm_ctrl;		/* In */
+	struct sla_addr_t dev_ctx_sla;
+	struct sla_addr_t tdi_ctx_sla;
+	u64 gctx_paddr;
+	u16 guest_device_id;
+	union {
+		u16 flags;
+		/* These are TDISP's LOCK_INTERFACE_REQUEST flags */
+		struct {
+			u16 no_fw_update:1;
+			u16 reservedf1:1;
+			u16 lock_msix:1;
+			u16 bind_p2p:1;
+			u16 all_request_redirect:1;
+		};
+	} tdisp_lock_if;
+	u16 reserved2;
+} __packed;
+
+/*
+ * struct sev_data_tio_tdi_unbind - TIO_TDI_UNBIND command
+ *
+ * @length: Length in bytes of this command buffer
+ * @spdm_ctrl: SPDM control structure defined in Chapter 2.
+ * @tdi_ctx_paddr: SPA of page donated by hypervisor
+ */
+struct sev_data_tio_tdi_unbind {
+	u32 length;				/* In */
+	u32 reserved;
+	struct spdm_ctrl spdm_ctrl;		/* In */
+	struct sla_addr_t dev_ctx_sla;
+	struct sla_addr_t tdi_ctx_sla;
+	u64 gctx_paddr;			/* In */
+} __packed;
+
+/*
+ * struct sev_data_tio_tdi_report - TIO_TDI_REPORT command
+ *
+ * @length: Length in bytes of this command buffer
+ * @spdm_ctrl: SPDM control structure defined in Chapter 2.
+ * @dev_ctx_sla: Scatter list address of the device context buffer
+ * @tdi_ctx_paddr: Scatter list address of a TDI context buffer
+ * @guest_ctx_paddr: System physical address of a guest context page
+ */
+struct sev_data_tio_tdi_report {
+	u32 length;
+	u32 reserved;
+	struct spdm_ctrl spdm_ctrl;
+	struct sla_addr_t dev_ctx_sla;
+	struct sla_addr_t tdi_ctx_sla;
+	u64 gctx_paddr;
+} __packed;
+
+struct sev_data_tio_asid_fence_clear {
+	u32 length;				/* In */
+	u32 reserved1;
+	u64 gctx_paddr;			/* In */
+	u16 device_id;
+	u8 segment_id;
+	u8 reserved[13];
+} __packed;
+
+struct sev_data_tio_asid_fence_status {
+	u32 length;				/* In */
+	u32 asid;				/* In */
+	u64 status_pa;
+	u16 device_id;
+	u8 segment_id;
+	u8 reserved[13];
+} __packed;
+
+/**
+ * struct sev_data_tio_guest_request - TIO_GUEST_REQUEST command
+ *
+ * @length: Length in bytes of this command buffer
+ * @spdm_ctrl: SPDM control structure defined in Chapter 2.
+ * @gctx_paddr: system physical address of guest context page
+ * @tdi_ctx_paddr: SPA of page donated by hypervisor
+ * @req_paddr: system physical address of request page
+ * @res_paddr: system physical address of response page
+ */
+struct sev_data_tio_guest_request {
+	u32 length;				/* In */
+	u32 reserved;
+	struct spdm_ctrl spdm_ctrl;		/* In */
+	struct sla_addr_t dev_ctx_sla;
+	struct sla_addr_t tdi_ctx_sla;
+	u64 gctx_paddr;
+	u64 req_paddr;				/* In */
+	u64 res_paddr;				/* In */
+} __packed;
+
+struct sev_data_tio_roll_key {
+	u32 length;				/* In */
+	u32 reserved;
+	struct spdm_ctrl spdm_ctrl;		/* In */
+	struct sla_addr_t dev_ctx_sla;			/* In */
+} __packed;
+
+static struct sla_buffer_hdr *sla_buffer_map(struct sla_addr_t sla)
+{
+	struct sla_buffer_hdr *buf;
+
+	BUILD_BUG_ON(sizeof(struct sla_buffer_hdr) != 0x40);
+	if (IS_SLA_NULL(sla))
+		return NULL;
+
+	if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
+		struct sla_addr_t *scatter = __va(sla.pfn << PAGE_SHIFT);
+		unsigned int i, npages = 0;
+		struct page **pp;
+
+		for (i = 0; i < SLA_SCATTER_LEN(sla); ++i) {
+			if (WARN_ON_ONCE(SLA_SZ(scatter[i]) > SZ_4K))
+				return NULL;
+
+			if (WARN_ON_ONCE(scatter[i].page_type == SLA_PAGE_TYPE_SCATTER))
+				return NULL;
+
+			if (IS_SLA_EOL(scatter[i])) {
+				npages = i;
+				break;
+			}
+		}
+		if (WARN_ON_ONCE(!npages))
+			return NULL;
+
+		pp = kmalloc_array(npages, sizeof(pp[0]), GFP_KERNEL);
+		if (!pp)
+			return NULL;
+
+		for (i = 0; i < npages; ++i)
+			pp[i] = pfn_to_page(scatter[i].pfn);
+
+		buf = vm_map_ram(pp, npages, 0);
+		kfree(pp);
+	} else {
+		struct page *pg = pfn_to_page(sla.pfn);
+
+		buf = vm_map_ram(&pg, 1, 0);
+	}
+
+	return buf;
+}
+
+static void sla_buffer_unmap(struct sla_addr_t sla, struct sla_buffer_hdr *buf)
+{
+	if (!buf)
+		return;
+
+	if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
+		struct sla_addr_t *scatter = __va(sla.pfn << PAGE_SHIFT);
+		unsigned int i, npages = 0;
+
+		for (i = 0; i < SLA_SCATTER_LEN(sla); ++i) {
+			if (IS_SLA_EOL(scatter[i])) {
+				npages = i;
+				break;
+			}
+		}
+		if (!npages)
+			return;
+
+		vm_unmap_ram(buf, npages);
+	} else {
+		vm_unmap_ram(buf, 1);
+	}
+}
+
+static void dobj_response_init(struct sla_buffer_hdr *buf)
+{
+	struct spdm_dobj_hdr *dobj = sla_to_dobj_hdr(buf);
+
+	dobj->id = SPDM_DOBJ_ID_RESP;
+	dobj->version.major = 0x1;
+	dobj->version.minor = 0;
+	dobj->length = 0;
+	buf->payload_sz = sla_dobj_id_to_size(dobj->id) + dobj->length;
+}
+
+static void sla_free(struct sla_addr_t sla, size_t len, bool firmware_state)
+{
+	unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	struct sla_addr_t *scatter = NULL;
+	int ret = 0, i;
+
+	if (IS_SLA_NULL(sla))
+		return;
+
+	if (firmware_state) {
+		if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
+			scatter = __va(sla.pfn << PAGE_SHIFT);
+
+			for (i = 0; i < npages; ++i) {
+				if (IS_SLA_EOL(scatter[i]))
+					break;
+
+				ret = snp_reclaim_pages(scatter[i].pfn << PAGE_SHIFT, 1, false);
+				if (ret)
+					break;
+			}
+		} else {
+			pr_err("Reclaiming %llx\n", (u64)sla.pfn << PAGE_SHIFT);
+			ret = snp_reclaim_pages(sla.pfn << PAGE_SHIFT, 1, false);
+		}
+	}
+
+	if (WARN_ON(ret))
+		return;
+
+	if (scatter) {
+		for (i = 0; i < npages; ++i) {
+			if (IS_SLA_EOL(scatter[i]))
+				break;
+			free_page((unsigned long)__va(scatter[i].pfn << PAGE_SHIFT));
+		}
+	}
+
+	free_page((unsigned long)__va(sla.pfn << PAGE_SHIFT));
+}
+
+static struct sla_addr_t sla_alloc(size_t len, bool firmware_state)
+{
+	unsigned long i, npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	struct sla_addr_t *scatter = NULL;
+	struct sla_addr_t ret = SLA_NULL;
+	struct sla_buffer_hdr *buf;
+	struct page *pg;
+
+	if (npages == 0)
+		return ret;
+
+	if (WARN_ON_ONCE(npages > ((PAGE_SIZE / sizeof(struct sla_addr_t)) + 1)))
+		return ret;
+
+	BUILD_BUG_ON(PAGE_SIZE < SZ_4K);
+
+	if (npages > 1) {
+		pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pg)
+			return SLA_NULL;
+
+		ret.pfn = page_to_pfn(pg);
+		ret.page_size = SLA_PAGE_SIZE_4K;
+		ret.page_type = SLA_PAGE_TYPE_SCATTER;
+
+		scatter = page_to_virt(pg);
+		for (i = 0; i < npages; ++i) {
+			pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+			if (!pg)
+				goto no_reclaim_exit;
+
+			scatter[i].pfn = page_to_pfn(pg);
+			scatter[i].page_type = SLA_PAGE_TYPE_DATA;
+			scatter[i].page_size = SLA_PAGE_SIZE_4K;
+		}
+		scatter[i] = SLA_EOL;
+	} else {
+		pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pg)
+			return SLA_NULL;
+
+		ret.pfn = page_to_pfn(pg);
+		ret.page_size = SLA_PAGE_SIZE_4K;
+		ret.page_type = SLA_PAGE_TYPE_DATA;
+	}
+
+	buf = sla_buffer_map(ret);
+	if (!buf)
+		goto no_reclaim_exit;
+
+	buf->capacity_sz = (npages << PAGE_SHIFT);
+	sla_buffer_unmap(ret, buf);
+
+	if (firmware_state) {
+		if (scatter) {
+			for (i = 0; i < npages; ++i) {
+				if (rmp_make_private(scatter[i].pfn, 0, PG_LEVEL_4K, 0, true))
+					goto free_exit;
+			}
+		} else {
+			if (rmp_make_private(ret.pfn, 0, PG_LEVEL_4K, 0, true))
+				goto no_reclaim_exit;
+		}
+	}
+
+	return ret;
+
+no_reclaim_exit:
+	firmware_state = false;
+free_exit:
+	sla_free(ret, len, firmware_state);
+	return SLA_NULL;
+}
+
+static void tio_blob_release(struct tsm_blob *b)
+{
+	memset(b->data, 0, b->len);
+}
+
+void tio_save_output(struct tsm_blob **blob, struct sla_addr_t sla, u32 check_dobjid)
+{
+	struct sla_buffer_hdr *buf;
+	struct spdm_dobj_hdr *hdr;
+
+	tsm_blob_put(*blob);
+	*blob = NULL;
+
+	buf = sla_buffer_map(sla);
+	if (!buf)
+		return;
+
+	hdr = sla_to_dobj_hdr_check(buf, check_dobjid);
+	if (hdr)
+		*blob = tsm_blob_new(SPDM_DOBJ_DATA(hdr), hdr->length, tio_blob_release);
+
+	sla_buffer_unmap(sla, buf);
+}
+
+static int sev_tio_do_cmd(int cmd, void *data, size_t data_len, int *psp_ret,
+			  struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	int rc;
+
+	*psp_ret = 0;
+	rc = sev_do_cmd(cmd, data, psp_ret);
+
+	if (WARN_ON(!spdm && !rc && *psp_ret == SEV_RET_SPDM_REQUEST))
+		return -EIO;
+
+	if (spdm && (rc == 0 || rc == -EIO) && *psp_ret == SEV_RET_SPDM_REQUEST) {
+		struct spdm_dobj_hdr_resp *resp_hdr;
+		struct spdm_dobj_hdr_req *req_hdr;
+
+		if (!dev_data->cmd) {
+			if (WARN_ON_ONCE(!data_len || (data_len != *(u32 *) data)))
+				return -EINVAL;
+			if (WARN_ON(data_len > sizeof(dev_data->cmd_data)))
+				return -EFAULT;
+			memcpy(dev_data->cmd_data, data, data_len);
+			memset(&dev_data->cmd_data[data_len], 0xFF,
+			       sizeof(dev_data->cmd_data) - data_len);
+			dev_data->cmd = cmd;
+		}
+
+		req_hdr = sla_to_dobj_req_hdr(dev_data->reqbuf);
+		resp_hdr = sla_to_dobj_resp_hdr(dev_data->respbuf);
+		switch (req_hdr->data_type) {
+		case DOBJ_DATA_TYPE_SPDM:
+			rc = PCI_DOE_PROTOCOL_CMA_SPDM;
+			break;
+		case DOBJ_DATA_TYPE_SECURE_SPDM:
+			rc = PCI_DOE_PROTOCOL_SECURED_CMA_SPDM;
+			break;
+		default:
+			rc = -EINVAL;
+			return rc;
+		}
+		resp_hdr->data_type = req_hdr->data_type;
+		spdm->req_len = req_hdr->hdr.length;
+		spdm->rsp_len = tio_status->spdm_req_size_max -
+			(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) + sizeof(struct sla_buffer_hdr));
+	} else if (dev_data && dev_data->cmd) {
+		/* For either error or success just stop the bouncing */
+		memset(dev_data->cmd_data, 0, sizeof(dev_data->cmd_data));
+		dev_data->cmd = 0;
+	}
+
+	return rc;
+}
+
+int sev_tio_continue(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	struct spdm_dobj_hdr_resp *resp_hdr;
+	int ret;
+
+	if (!dev_data || !dev_data->cmd)
+		return -EINVAL;
+
+	resp_hdr = sla_to_dobj_resp_hdr(dev_data->respbuf);
+	resp_hdr->hdr.length = ALIGN(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) + spdm->rsp_len, 32);
+	dev_data->respbuf->payload_sz = resp_hdr->hdr.length;
+
+	ret = sev_tio_do_cmd(dev_data->cmd, dev_data->cmd_data, 0, &dev_data->psp_ret,
+			     dev_data, spdm);
+
+	return ret;
+}
+
+static int spdm_ctrl_init(struct tsm_spdm *spdm, struct spdm_ctrl *ctrl,
+			  struct tsm_dev_tio *dev_data)
+{
+	ctrl->req = dev_data->req;
+	ctrl->resp = dev_data->resp;
+	ctrl->scratch = dev_data->scratch;
+	ctrl->output = dev_data->output;
+
+	spdm->req = sla_to_data(dev_data->reqbuf, SPDM_DOBJ_ID_REQ);
+	spdm->rsp = sla_to_data(dev_data->respbuf, SPDM_DOBJ_ID_RESP);
+	if (!spdm->req || !spdm->rsp)
+		return -EFAULT;
+
+	return 0;
+}
+
+static void spdm_ctrl_free(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	size_t len = tio_status->spdm_req_size_max -
+		(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) +
+		 sizeof(struct sla_buffer_hdr));
+
+	sla_buffer_unmap(dev_data->resp, dev_data->respbuf);
+	sla_buffer_unmap(dev_data->req, dev_data->reqbuf);
+	spdm->rsp = NULL;
+	spdm->req = NULL;
+	sla_free(dev_data->req, len, true);
+	sla_free(dev_data->resp, len, false);
+	sla_free(dev_data->scratch, tio_status->spdm_scratch_size_max, true);
+
+	dev_data->req.sla = 0;
+	dev_data->resp.sla = 0;
+	dev_data->scratch.sla = 0;
+	dev_data->respbuf = NULL;
+	dev_data->reqbuf = NULL;
+	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
+}
+
+static int spdm_ctrl_alloc(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	int ret;
+
+	dev_data->req = sla_alloc(tio_status->spdm_req_size_max, true);
+	dev_data->resp = sla_alloc(tio_status->spdm_req_size_max, false);
+	dev_data->scratch = sla_alloc(tio_status->spdm_scratch_size_max, true);
+	dev_data->output = sla_alloc(tio_status->spdm_out_size_max, true);
+
+	if (IS_SLA_NULL(dev_data->req) || IS_SLA_NULL(dev_data->resp) ||
+	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->dev_ctx)) {
+		ret = -ENOMEM;
+		goto free_spdm_exit;
+	}
+
+	dev_data->reqbuf = sla_buffer_map(dev_data->req);
+	dev_data->respbuf = sla_buffer_map(dev_data->resp);
+	if (!dev_data->reqbuf || !dev_data->respbuf) {
+		ret = -EFAULT;
+		goto free_spdm_exit;
+	}
+
+	dobj_response_init(dev_data->respbuf);
+
+	return 0;
+
+free_spdm_exit:
+	spdm_ctrl_free(dev_data, spdm);
+	return ret;
+}
+
+int sev_tio_status(void)
+{
+	struct sev_data_tio_status data_status = {
+		.length = sizeof(data_status),
+	};
+	int ret = 0, psp_ret = 0;
+
+	if (!sev_version_greater_or_equal(1, 55))
+		return -EPERM;
+
+	WARN_ON(tio_status);
+
+	tio_status = kzalloc(sizeof(*tio_status), GFP_KERNEL);
+	// "8-byte aligned, and does not cross a page boundary"
+	// BUG_ON(tio_status & ~PAGE_MASK > PAGE_SIZE - sizeof(*tio_status));
+
+	if (!tio_status)
+		return -ENOMEM;
+
+	tio_status->length = sizeof(*tio_status);
+	data_status.status_paddr = __psp_pa(tio_status);
+
+	ret = sev_do_cmd(SEV_CMD_TIO_STATUS, &data_status, &psp_ret);
+	if (ret)
+		goto free_exit;
+
+	if (tio_status->flags & 0xFFFFFF00) {
+		ret = -EFAULT;
+		goto free_exit;
+	}
+
+	if (!tio_status->tio_en && !tio_status->tio_init_done) {
+		ret = -ENOENT;
+		goto free_exit;
+	}
+
+	if (tio_status->tio_en && !tio_status->tio_init_done) {
+		struct sev_data_tio_init ti = { .length = sizeof(ti) };
+
+		ret = sev_do_cmd(SEV_CMD_TIO_INIT, &ti, &psp_ret);
+		if (ret)
+			goto free_exit;
+
+		ret = sev_do_cmd(SEV_CMD_TIO_STATUS, &data_status, &psp_ret);
+		if (ret)
+			goto free_exit;
+	}
+
+	pr_notice("SEV-TIO status: EN=%d INIT_DONE=%d rq=%d..%d rs=%d..%d scr=%d..%d out=%d..%d dev=%d tdi=%d\n",
+		  tio_status->tio_en, tio_status->tio_init_done,
+		  tio_status->spdm_req_size_min, tio_status->spdm_req_size_max,
+		  tio_status->spdm_rsp_size_min, tio_status->spdm_rsp_size_max,
+		  tio_status->spdm_scratch_size_min, tio_status->spdm_scratch_size_max,
+		  tio_status->spdm_out_size_min, tio_status->spdm_out_size_max,
+		  tio_status->devctx_size, tio_status->tdictx_size);
+
+	return 0;
+
+free_exit:
+	pr_err("Failed to enable SEV-TIO: ret=%d en=%d initdone=%d SEV=%d\n",
+	       ret, tio_status->tio_en, tio_status->tio_init_done,
+	       boot_cpu_has(X86_FEATURE_SEV));
+	pr_err("Check BIOS for: SMEE, SEV Control, SEV-ES ASID Space Limit=99,\n"
+	       "SNP Memory (RMP Table) Coverage, RMP Coverage for 64Bit MMIO Ranges\n"
+	       "SEV-SNP Support, SEV-TIO Support, PCIE IDE Capability\n");
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		pr_err("mem_encrypt=on is currently broken\n");
+
+	kfree(tio_status);
+	return ret;
+}
+
+int sev_tio_dev_create(struct tsm_dev_tio *dev_data, u16 device_id,
+		       u16 root_port_id, u8 segment_id)
+{
+	struct sev_data_tio_dev_create create = {
+		.length = sizeof(create),
+		.device_id = device_id,
+		.root_port_id = root_port_id,
+		.segment_id = segment_id,
+	};
+
+	dev_data->dev_ctx = sla_alloc(tio_status->devctx_size, true);
+	if (IS_SLA_NULL(dev_data->dev_ctx))
+		return -ENOMEM;
+
+	create.dev_ctx_sla = dev_data->dev_ctx;
+	return sev_tio_do_cmd(SEV_CMD_TIO_DEV_CREATE, &create, sizeof(create),
+			      &dev_data->psp_ret, dev_data, NULL);
+}
+
+int sev_tio_dev_reclaim(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_dev_reclaim r = {
+		.length = sizeof(r),
+		.dev_ctx_sla = dev_data->dev_ctx,
+	};
+	int ret;
+
+	if (IS_SLA_NULL(dev_data->dev_ctx))
+		return 0;
+
+	ret = sev_do_cmd(SEV_CMD_TIO_DEV_RECLAIM, &r, &dev_data->psp_ret);
+
+	sla_free(dev_data->dev_ctx, tio_status->devctx_size, true);
+	dev_data->dev_ctx = SLA_NULL;
+
+	spdm_ctrl_free(dev_data, spdm);
+
+	return ret;
+}
+
+int sev_tio_dev_connect(struct tsm_dev_tio *dev_data, u8 tc_mask, u8 cert_slot,
+			struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_dev_connect connect = {
+		.length = sizeof(connect),
+		.tc_mask = tc_mask,
+		.cert_slot = cert_slot,
+		.dev_ctx_sla = dev_data->dev_ctx,
+		.ide_stream_id = { 0 },
+	};
+	int ret;
+
+	if (WARN_ON(IS_SLA_NULL(dev_data->dev_ctx)))
+		return -EFAULT;
+	if (!(tc_mask & 1))
+		return -EINVAL;
+
+	ret = spdm_ctrl_alloc(dev_data, spdm);
+	if (ret)
+		return ret;
+	ret = spdm_ctrl_init(spdm, &connect.spdm_ctrl, dev_data);
+	if (ret)
+		return ret;
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_DEV_CONNECT, &connect, sizeof(connect),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+int sev_tio_dev_disconnect(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_dev_disconnect dc = {
+		.length = sizeof(dc),
+		.dev_ctx_sla = dev_data->dev_ctx,
+	};
+	int ret;
+
+	if (WARN_ON_ONCE(IS_SLA_NULL(dev_data->dev_ctx)))
+		return -EFAULT;
+
+	ret = spdm_ctrl_init(spdm, &dc.spdm_ctrl, dev_data);
+	if (ret)
+		return ret;
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_DEV_DISCONNECT, &dc, sizeof(dc),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+int sev_tio_dev_measurements(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_dev_meas meas = {
+		.length = sizeof(meas),
+		.raw_bitstream = 1,
+	};
+	int ret;
+
+	if (WARN_ON(IS_SLA_NULL(dev_data->dev_ctx)))
+		return -EFAULT;
+
+	spdm_ctrl_init(spdm, &meas.spdm_ctrl, dev_data);
+	meas.dev_ctx_sla = dev_data->dev_ctx;
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_DEV_MEASUREMENTS, &meas, sizeof(meas),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+int sev_tio_dev_certificates(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_dev_certs c = {
+		.length = sizeof(c),
+	};
+	int ret;
+
+	if (WARN_ON(IS_SLA_NULL(dev_data->dev_ctx)))
+		return -EFAULT;
+
+	spdm_ctrl_init(spdm, &c.spdm_ctrl, dev_data);
+	c.dev_ctx_sla = dev_data->dev_ctx;
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_DEV_CERTIFICATES, &c, sizeof(c),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+int sev_tio_dev_status(struct tsm_dev_tio *dev_data, struct tsm_dev_status *s)
+{
+	struct sev_tio_dev_status *status = (struct sev_tio_dev_status *) dev_data->data;
+	struct sev_data_tio_dev_status data_status = {
+		.length = sizeof(data_status),
+		.dev_ctx_paddr = dev_data->dev_ctx,
+		.status_length = sizeof(*status),
+		.status_paddr = __psp_pa(status),
+	};
+	int ret;
+
+	if (!dev_data)
+		return -ENODEV;
+
+	if (IS_SLA_NULL(dev_data->dev_ctx))
+		return -ENXIO;
+
+	memset(status, 0, sizeof(*status));
+
+	ret = sev_do_cmd(SEV_CMD_TIO_DEV_STATUS, &data_status, &dev_data->psp_ret);
+	if (ret)
+		return ret;
+
+	s->ctx_state = status->ctx_state;
+	s->device_id = status->device_id;
+	s->tc_mask = status->tc_mask;
+	memcpy(s->ide_stream_id, status->ide_stream_id, sizeof(status->ide_stream_id));
+	s->certs_slot = status->certs_slot;
+	s->no_fw_update = status->no_fw_update;
+
+	return 0;
+}
+
+int sev_tio_ide_refresh(struct tsm_dev_tio *dev_data, struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_roll_key rk = {
+		.length = sizeof(rk),
+		.dev_ctx_sla = dev_data->dev_ctx,
+	};
+	int ret;
+
+	if (WARN_ON(IS_SLA_NULL(dev_data->dev_ctx)))
+		return -EFAULT;
+
+	ret = spdm_ctrl_init(spdm, &rk.spdm_ctrl, dev_data);
+	if (ret)
+		return ret;
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_ROLL_KEY, &rk, sizeof(rk),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+int sev_tio_tdi_create(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data, u16 dev_id,
+		       u8 rseg, u8 rseg_valid)
+{
+	struct sev_data_tio_tdi_create c = {
+		.length = sizeof(c),
+	};
+	int ret;
+
+	if (!dev_data || !tdi_data) /* Device is not "connected" */
+		return -EPERM;
+
+	if (WARN_ON_ONCE(IS_SLA_NULL(dev_data->dev_ctx) || !IS_SLA_NULL(tdi_data->tdi_ctx)))
+		return -EFAULT;
+
+	tdi_data->tdi_ctx = sla_alloc(tio_status->tdictx_size, true);
+	if (IS_SLA_NULL(tdi_data->tdi_ctx))
+		return -ENOMEM;
+
+	c.dev_ctx_sla = dev_data->dev_ctx;
+	c.tdi_ctx_sla = tdi_data->tdi_ctx;
+	c.interface_id.rid = dev_id;
+	c.interface_id.rseg = rseg;
+	c.interface_id.rseg_valid = rseg_valid;
+
+	ret = sev_do_cmd(SEV_CMD_TIO_TDI_CREATE, &c, &dev_data->psp_ret);
+	if (ret)
+		goto free_exit;
+
+	return 0;
+
+free_exit:
+	sla_free(tdi_data->tdi_ctx, tio_status->tdictx_size, true);
+	tdi_data->tdi_ctx = SLA_NULL;
+	return ret;
+}
+
+void sev_tio_tdi_reclaim(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data)
+{
+	struct sev_data_tio_tdi_reclaim r = {
+		.length = sizeof(r),
+	};
+
+	if (WARN_ON(!dev_data || !tdi_data))
+		return;
+	if (IS_SLA_NULL(dev_data->dev_ctx) || IS_SLA_NULL(tdi_data->tdi_ctx))
+		return;
+
+	r.dev_ctx_sla = dev_data->dev_ctx;
+	r.tdi_ctx_sla = tdi_data->tdi_ctx;
+
+	sev_do_cmd(SEV_CMD_TIO_TDI_RECLAIM, &r, &dev_data->psp_ret);
+
+	sla_free(tdi_data->tdi_ctx, tio_status->tdictx_size, true);
+	tdi_data->tdi_ctx = SLA_NULL;
+}
+
+int sev_tio_tdi_bind(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		     __u32 guest_rid, u64 gctx_paddr, struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_tdi_bind b = {
+		.length = sizeof(b),
+	};
+	int ret;
+
+	if (WARN_ON_ONCE(IS_SLA_NULL(dev_data->dev_ctx) || IS_SLA_NULL(tdi_data->tdi_ctx)))
+		return -EFAULT;
+
+	spdm_ctrl_init(spdm, &b.spdm_ctrl, dev_data);
+	b.dev_ctx_sla = dev_data->dev_ctx;
+	b.tdi_ctx_sla = tdi_data->tdi_ctx;
+	b.guest_device_id = guest_rid;
+	b.gctx_paddr = gctx_paddr;
+
+	tdi_data->gctx_paddr = gctx_paddr;
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_TDI_BIND, &b, sizeof(b),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+int sev_tio_tdi_unbind(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		       struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_tdi_unbind ub = {
+		.length = sizeof(ub),
+	};
+	int ret;
+
+	if (WARN_ON(!tdi_data || !dev_data))
+		return 0;
+
+	if (WARN_ON(!tdi_data->gctx_paddr))
+		return -EFAULT;
+
+	spdm_ctrl_init(spdm, &ub.spdm_ctrl, dev_data);
+	ub.dev_ctx_sla = dev_data->dev_ctx;
+	ub.tdi_ctx_sla = tdi_data->tdi_ctx;
+	ub.gctx_paddr = tdi_data->gctx_paddr;
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_TDI_UNBIND, &ub, sizeof(ub),
+			     &dev_data->psp_ret, dev_data, spdm);
+	return ret;
+}
+
+int sev_tio_tdi_report(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		       u64 gctx_paddr, struct tsm_spdm *spdm)
+{
+	struct sev_data_tio_tdi_report r = {
+		.length = sizeof(r),
+		.dev_ctx_sla = dev_data->dev_ctx,
+		.tdi_ctx_sla = tdi_data->tdi_ctx,
+		.gctx_paddr = gctx_paddr,
+	};
+	int ret;
+
+	if (WARN_ON_ONCE(IS_SLA_NULL(dev_data->dev_ctx) || IS_SLA_NULL(tdi_data->tdi_ctx)))
+		return -EFAULT;
+
+	spdm_ctrl_init(spdm, &r.spdm_ctrl, dev_data);
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_TDI_REPORT, &r, sizeof(r),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+int sev_tio_asid_fence_clear(u16 device_id, u8 segment_id, u64 gctx_paddr, int *psp_ret)
+{
+	struct sev_data_tio_asid_fence_clear c = {
+		.length = sizeof(c),
+		.gctx_paddr = gctx_paddr,
+		.device_id = device_id,
+		.segment_id = segment_id,
+	};
+	int ret;
+
+	ret = sev_do_cmd(SEV_CMD_TIO_ASID_FENCE_CLEAR, &c, psp_ret);
+
+	return ret;
+}
+
+int sev_tio_asid_fence_status(struct tsm_dev_tio *dev_data, u16 device_id, u8 segment_id,
+			      u32 asid, bool *fenced)
+{
+	u64 *status = (u64 *) dev_data->data;
+	struct sev_data_tio_asid_fence_status s = {
+		.length = sizeof(s),
+		.asid = asid,
+		.status_pa = __psp_pa(status),
+		.device_id = device_id,
+		.segment_id = segment_id,
+	};
+	int ret;
+
+	*status = 0;
+
+	ret = sev_do_cmd(SEV_CMD_TIO_ASID_FENCE_STATUS, &s, &dev_data->psp_ret);
+
+	if (ret == SEV_RET_SUCCESS) {
+		switch (*status) {
+		case 0:
+			*fenced = false;
+			break;
+		case 1:
+			*fenced = true;
+			break;
+		default:
+			pr_err("%04x:%x:%x.%d: undefined fence state %#llx\n",
+			       segment_id, PCI_BUS_NUM(device_id),
+			       PCI_SLOT(device_id), PCI_FUNC(device_id), *status);
+			*fenced = true;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+int sev_tio_guest_request(void *data, u32 guest_rid, u64 gctx_paddr,
+			  struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+			  struct tsm_spdm *spdm)
+{
+	struct tio_guest_request *tgr = data;
+	struct sev_data_tio_guest_request gr = {
+		.length = sizeof(gr),
+		.dev_ctx_sla = dev_data->dev_ctx,
+		.tdi_ctx_sla = tdi_data->tdi_ctx,
+		.gctx_paddr = tgr->data.gctx_paddr,
+		.req_paddr = tgr->data.req_paddr,
+		.res_paddr = tgr->data.res_paddr,
+	};
+	int ret;
+
+	if (WARN_ON(!tdi_data || !dev_data))
+		return -EINVAL;
+
+	spdm_ctrl_init(spdm, &gr.spdm_ctrl, dev_data);
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_GUEST_REQUEST, &gr, sizeof(gr),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+struct sev_tio_tdi_info_data {
+	u32 length;
+	struct tdisp_interface_id interface_id;
+	union {
+		u32 p1;
+		struct {
+			u32 meas_digest_valid:1;
+			u32 meas_digest_fresh:1;
+		};
+	};
+	union {
+		u32 p2;
+		struct {
+			u32 no_fw_update:1;
+			u32 cache_line_size:1;
+			u32 lock_msix:1;
+			u32 bind_p2p:1;
+			u32 all_request_redirect:1;
+		};
+	};
+	u64 spdm_algos;
+	u8 certs_digest[48];
+	u8 meas_digest[48];
+	u8 interface_report_digest[48];
+	u8 guest_report_id[16];
+} __packed;
+
+struct sev_data_tio_tdi_info {
+	u32 length;
+	u32 reserved1;
+	struct sla_addr_t dev_ctx_sla;
+	struct sla_addr_t tdi_ctx_sla;
+	u32 status_length;
+	u32 reserved2;
+	u64 status_paddr;
+} __packed;
+
+int sev_tio_tdi_info(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		     struct tsm_tdi_status *ts)
+{
+	struct sev_tio_tdi_info_data *data = (struct sev_tio_tdi_info_data *) dev_data->data;
+	struct sev_data_tio_tdi_info info = {
+		.length = sizeof(info),
+		.dev_ctx_sla = dev_data->dev_ctx,
+		.tdi_ctx_sla = tdi_data->tdi_ctx,
+		.status_length = sizeof(*data),
+		.status_paddr = __psp_pa(data),
+	};
+	int ret;
+
+	if (IS_SLA_NULL(dev_data->dev_ctx) || IS_SLA_NULL(tdi_data->tdi_ctx))
+		return -ENXIO;
+
+	memset(data, 0, sizeof(*data));
+
+	ret = sev_do_cmd(SEV_CMD_TIO_TDI_INFO, &info, &dev_data->psp_ret);
+	if (ret)
+		return ret;
+
+	ts->id = data->interface_id;
+	ts->meas_digest_valid = data->meas_digest_valid;
+	ts->meas_digest_fresh = data->meas_digest_fresh;
+	ts->no_fw_update = data->no_fw_update;
+	ts->cache_line_size = data->cache_line_size == 0 ? 64 : 128;
+	ts->lock_msix = data->lock_msix;
+	ts->bind_p2p = data->bind_p2p;
+	ts->all_request_redirect = data->all_request_redirect;
+
+#define __ALGO(x, n, y) \
+	((((x) & (0xFFUL << (n))) == TIO_SPDM_ALGOS_##y) ? \
+	 (1ULL << TSM_TDI_SPDM_ALGOS_##y) : 0)
+	ts->spdm_algos =
+		__ALGO(data->spdm_algos, 0, DHE_SECP256R1) |
+		__ALGO(data->spdm_algos, 0, DHE_SECP384R1) |
+		__ALGO(data->spdm_algos, 8, AEAD_AES_128_GCM) |
+		__ALGO(data->spdm_algos, 8, AEAD_AES_256_GCM) |
+		__ALGO(data->spdm_algos, 16, ASYM_TPM_ALG_RSASSA_3072) |
+		__ALGO(data->spdm_algos, 16, ASYM_TPM_ALG_ECDSA_ECC_NIST_P256) |
+		__ALGO(data->spdm_algos, 16, ASYM_TPM_ALG_ECDSA_ECC_NIST_P384) |
+		__ALGO(data->spdm_algos, 24, HASH_TPM_ALG_SHA_256) |
+		__ALGO(data->spdm_algos, 24, HASH_TPM_ALG_SHA_384) |
+		__ALGO(data->spdm_algos, 32, KEY_SCHED_SPDM_KEY_SCHEDULE);
+#undef __ALGO
+	memcpy(ts->certs_digest, data->certs_digest, sizeof(ts->certs_digest));
+	memcpy(ts->meas_digest, data->meas_digest, sizeof(ts->meas_digest));
+	memcpy(ts->interface_report_digest, data->interface_report_digest,
+	       sizeof(ts->interface_report_digest));
+	memcpy(ts->guest_report_id, data->guest_report_id, sizeof(ts->guest_report_id));
+	ts->valid = true;
+
+	return 0;
+}
+
+struct sev_tio_tdi_status_data {
+	u32 length;
+	u8 tdisp_state;
+	u8 reserved1[3];
+} __packed;
+
+struct sev_data_tio_tdi_status {
+	u32 length;
+	u32 reserved1;
+	struct spdm_ctrl spdm_ctrl;
+	struct sla_addr_t dev_ctx_sla;
+	struct sla_addr_t tdi_ctx_sla;
+	u64 status_paddr;
+} __packed;
+
+int sev_tio_tdi_status(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+		       struct tsm_spdm *spdm)
+{
+	struct sev_tio_tdi_status_data *data = (struct sev_tio_tdi_status_data *) dev_data->data;
+	struct sev_data_tio_tdi_status status = {
+		.length = sizeof(status),
+		.dev_ctx_sla = dev_data->dev_ctx,
+		.tdi_ctx_sla = tdi_data->tdi_ctx,
+	};
+	int ret;
+
+	if (IS_SLA_NULL(dev_data->dev_ctx) || IS_SLA_NULL(tdi_data->tdi_ctx))
+		return -ENXIO;
+
+	memset(data, 0, sizeof(*data));
+
+	spdm_ctrl_init(spdm, &status.spdm_ctrl, dev_data);
+	status.status_paddr = __psp_pa(data);
+
+	ret = sev_tio_do_cmd(SEV_CMD_TIO_TDI_STATUS, &status, sizeof(status),
+			     &dev_data->psp_ret, dev_data, spdm);
+
+	return ret;
+}
+
+#define TIO_TDISP_STATE_CONFIG_UNLOCKED	0
+#define TIO_TDISP_STATE_CONFIG_LOCKED	1
+#define TIO_TDISP_STATE_RUN		2
+#define TIO_TDISP_STATE_ERROR		3
+
+int sev_tio_tdi_status_fin(struct tsm_dev_tio *dev_data, struct tsm_tdi_tio *tdi_data,
+			   enum tsm_tdisp_state *state)
+{
+	struct sev_tio_tdi_status_data *data = (struct sev_tio_tdi_status_data *) dev_data->data;
+
+	switch (data->tdisp_state) {
+#define __TDISP_STATE(y) case TIO_TDISP_STATE_##y: *state = TDISP_STATE_##y; break
+	__TDISP_STATE(CONFIG_UNLOCKED);
+	__TDISP_STATE(CONFIG_LOCKED);
+	__TDISP_STATE(RUN);
+	__TDISP_STATE(ERROR);
+#undef __TDISP_STATE
+	}
+	memset(dev_data->data, 0, sizeof(dev_data->data));
+
+	return 0;
+}
+
+int sev_tio_cmd_buffer_len(int cmd)
+{
+	switch (cmd) {
+	case SEV_CMD_TIO_STATUS:		return sizeof(struct sev_data_tio_status);
+	case SEV_CMD_TIO_INIT:			return sizeof(struct sev_data_tio_init);
+	case SEV_CMD_TIO_DEV_CREATE:		return sizeof(struct sev_data_tio_dev_create);
+	case SEV_CMD_TIO_DEV_RECLAIM:		return sizeof(struct sev_data_tio_dev_reclaim);
+	case SEV_CMD_TIO_DEV_CONNECT:		return sizeof(struct sev_data_tio_dev_connect);
+	case SEV_CMD_TIO_DEV_DISCONNECT:	return sizeof(struct sev_data_tio_dev_disconnect);
+	case SEV_CMD_TIO_DEV_STATUS:		return sizeof(struct sev_data_tio_dev_status);
+	case SEV_CMD_TIO_DEV_MEASUREMENTS:	return sizeof(struct sev_data_tio_dev_meas);
+	case SEV_CMD_TIO_DEV_CERTIFICATES:	return sizeof(struct sev_data_tio_dev_certs);
+	case SEV_CMD_TIO_TDI_CREATE:		return sizeof(struct sev_data_tio_tdi_create);
+	case SEV_CMD_TIO_TDI_RECLAIM:		return sizeof(struct sev_data_tio_tdi_reclaim);
+	case SEV_CMD_TIO_TDI_BIND:		return sizeof(struct sev_data_tio_tdi_bind);
+	case SEV_CMD_TIO_TDI_UNBIND:		return sizeof(struct sev_data_tio_tdi_unbind);
+	case SEV_CMD_TIO_TDI_REPORT:		return sizeof(struct sev_data_tio_tdi_report);
+	case SEV_CMD_TIO_TDI_STATUS:		return sizeof(struct sev_data_tio_tdi_status);
+	case SEV_CMD_TIO_GUEST_REQUEST:		return sizeof(struct sev_data_tio_guest_request);
+	case SEV_CMD_TIO_ASID_FENCE_CLEAR:	return sizeof(struct sev_data_tio_asid_fence_clear);
+	case SEV_CMD_TIO_ASID_FENCE_STATUS: return sizeof(struct sev_data_tio_asid_fence_status);
+	case SEV_CMD_TIO_TDI_INFO:		return sizeof(struct sev_data_tio_tdi_info);
+	case SEV_CMD_TIO_ROLL_KEY:		return sizeof(struct sev_data_tio_roll_key);
+	default:				return 0;
+	}
+}
diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
new file mode 100644
index 000000000000..a11dea482d4b
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -0,0 +1,397 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+// Interface to CCP/SEV-TIO for generic PCIe TDISP module
+
+#include <linux/pci.h>
+#include <linux/pci-doe.h>
+#include <linux/tsm.h>
+
+#include <linux/smp.h>
+#include <asm/sev-common.h>
+
+#include "psp-dev.h"
+#include "sev-dev.h"
+#include "sev-dev-tio.h"
+
+static int mkret(int ret, struct tsm_dev_tio *dev_data)
+{
+	if (ret)
+		return ret;
+
+	if (dev_data->psp_ret == SEV_RET_SUCCESS)
+		return 0;
+
+	pr_err("PSP returned an error %d\n", dev_data->psp_ret);
+	return -EINVAL;
+}
+
+static int dev_connect(struct tsm_dev *tdev, void *private_data)
+{
+	u16 device_id = pci_dev_id(tdev->pdev);
+	u16 root_port_id = 0; // FIXME: this is NOT PCI id, need to figure out how to calculate this
+	u8 segment_id = tdev->pdev->bus ? pci_domain_nr(tdev->pdev->bus) : 0;
+	struct tsm_dev_tio *dev_data = tdev->data;
+	int ret;
+
+	if (!dev_data) {
+		dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
+		if (!dev_data)
+			return -ENOMEM;
+
+		ret = sev_tio_dev_create(dev_data, device_id, root_port_id, segment_id);
+		if (ret)
+			goto free_exit;
+
+		tdev->data = dev_data;
+	}
+
+	if (dev_data->cmd == 0) {
+		ret = sev_tio_dev_connect(dev_data, tdev->tc_mask, tdev->cert_slot, &tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret > 0)
+			return ret;
+		if (ret < 0)
+			goto free_exit;
+
+		tio_save_output(&tdev->certs, dev_data->output, SPDM_DOBJ_ID_CERTIFICATE);
+	}
+
+	if (dev_data->cmd == SEV_CMD_TIO_DEV_CONNECT) {
+		ret = sev_tio_continue(dev_data, &tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		tio_save_output(&tdev->certs, dev_data->output, SPDM_DOBJ_ID_CERTIFICATE);
+	}
+
+	if (dev_data->cmd == 0) {
+		ret = sev_tio_dev_measurements(dev_data, &tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		tio_save_output(&tdev->meas, dev_data->output, SPDM_DOBJ_ID_MEASUREMENT);
+	}
+
+	if (dev_data->cmd == SEV_CMD_TIO_DEV_MEASUREMENTS) {
+		ret = sev_tio_continue(dev_data, &tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		tio_save_output(&tdev->meas, dev_data->output, SPDM_DOBJ_ID_MEASUREMENT);
+	}
+
+	if (dev_data->cmd == 0) {
+		ret = sev_tio_dev_certificates(dev_data, &tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		tio_save_output(&tdev->certs, dev_data->output, SPDM_DOBJ_ID_CERTIFICATE);
+	}
+
+	if (dev_data->cmd == SEV_CMD_TIO_DEV_CERTIFICATES) {
+		ret = sev_tio_continue(dev_data, &tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		tio_save_output(&tdev->certs, dev_data->output, SPDM_DOBJ_ID_CERTIFICATE);
+	}
+
+	return 0;
+
+free_exit:
+	sev_tio_dev_reclaim(dev_data, &tdev->spdm);
+	kfree(dev_data);
+
+	return ret;
+}
+
+static int dev_reclaim(struct tsm_dev *tdev, void *private_data)
+{
+	struct tsm_dev_tio *dev_data = tdev->data;
+	int ret;
+
+	if (!dev_data)
+		return -ENODEV;
+
+	if (dev_data->cmd == 0) {
+		ret = sev_tio_dev_disconnect(dev_data, &tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+	} else if (dev_data->cmd == SEV_CMD_TIO_DEV_DISCONNECT) {
+		ret = sev_tio_continue(dev_data, &tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+	} else {
+		dev_err(&tdev->pdev->dev, "Wrong state, cmd 0x%x in flight\n",
+			dev_data->cmd);
+	}
+
+	ret = sev_tio_dev_reclaim(dev_data, &tdev->spdm);
+	ret = mkret(ret, dev_data);
+
+	tsm_blob_put(tdev->meas);
+	tdev->meas = NULL;
+	tsm_blob_put(tdev->certs);
+	tdev->certs = NULL;
+	kfree(tdev->data);
+	tdev->data = NULL;
+
+	return ret;
+}
+
+static int dev_status(struct tsm_dev *tdev, void *private_data, struct tsm_dev_status *s)
+{
+	struct tsm_dev_tio *dev_data = tdev->data;
+	int ret;
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ret = sev_tio_dev_status(dev_data, s);
+	ret = mkret(ret, dev_data);
+	if (!ret)
+		WARN_ON(s->device_id != pci_dev_id(tdev->pdev));
+
+	return ret;
+}
+
+static int ide_refresh(struct tsm_dev *tdev, void *private_data)
+{
+	struct tsm_dev_tio *dev_data = tdev->data;
+	int ret;
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ret = sev_tio_ide_refresh(dev_data, &tdev->spdm);
+
+	return ret;
+}
+
+static int tdi_reclaim(struct tsm_tdi *tdi, void *private_data)
+{
+	struct tsm_dev_tio *dev_data;
+	int ret;
+
+	if (!tdi->data)
+		return -ENODEV;
+
+	dev_data = tdi->tdev->data;
+	if (tdi->vmid) {
+		if (dev_data->cmd == 0) {
+			ret = sev_tio_tdi_unbind(tdi->tdev->data, tdi->data, &tdi->tdev->spdm);
+			ret = mkret(ret, dev_data);
+			if (ret)
+				return ret;
+		} else if (dev_data->cmd == SEV_CMD_TIO_TDI_UNBIND) {
+			ret = sev_tio_continue(dev_data, &tdi->tdev->spdm);
+			ret = mkret(ret, dev_data);
+			if (ret)
+				return ret;
+		}
+	}
+
+	/* Reclaim TDI if DEV is connected */
+	if (tdi->tdev->data) {
+		struct tsm_tdi_tio *tdi_data = tdi->data;
+		struct tsm_dev *tdev = tdi->tdev;
+		struct pci_dev *rootport = tdev->pdev->bus->self;
+		u8 segment_id = pci_domain_nr(rootport->bus);
+		u16 device_id = pci_dev_id(rootport);
+		bool fenced = false;
+
+		sev_tio_tdi_reclaim(tdi->tdev->data, tdi->data);
+
+		if (!sev_tio_asid_fence_status(dev_data, device_id, segment_id,
+					       tdi_data->asid, &fenced)) {
+			if (fenced) {
+				ret = sev_tio_asid_fence_clear(device_id, segment_id,
+							       tdi_data->vmid, &dev_data->psp_ret);
+				pci_notice(rootport, "Unfenced VM=%llx ASID=%d ret=%d %d",
+					   tdi_data->vmid, tdi_data->asid, ret,
+					   dev_data->psp_ret);
+			}
+		}
+
+		tsm_blob_put(tdi->report);
+		tdi->report = NULL;
+	}
+
+	kfree(tdi->data);
+	tdi->data = NULL;
+
+	return 0;
+}
+
+static int tdi_create(struct tsm_tdi *tdi)
+{
+	struct tsm_tdi_tio *tdi_data = tdi->data;
+	int ret;
+
+	if (tdi_data)
+		return -EBUSY;
+
+	tdi_data = kzalloc(sizeof(*tdi_data), GFP_KERNEL);
+	if (!tdi_data)
+		return -ENOMEM;
+
+	ret = sev_tio_tdi_create(tdi->tdev->data, tdi_data, pci_dev_id(tdi->pdev),
+				 tdi->rseg, tdi->rseg_valid);
+	if (ret)
+		kfree(tdi_data);
+	else
+		tdi->data = tdi_data;
+
+	return ret;
+}
+
+static int tdi_bind(struct tsm_tdi *tdi, u32 bdfn, u64 vmid, u32 asid, void *private_data)
+{
+	struct tsm_dev_tio *dev_data = tdi->tdev->data;
+	struct tsm_tdi_tio *tdi_data;
+
+	int ret;
+
+	if (!tdi->data) {
+		ret = tdi_create(tdi);
+		if (ret)
+			return ret;
+	}
+
+	if (dev_data->cmd == 0) {
+		ret = sev_tio_tdi_bind(dev_data, tdi->data, bdfn, vmid, &tdi->tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		tio_save_output(&tdi->report, dev_data->output, SPDM_DOBJ_ID_REPORT);
+	}
+
+	if (dev_data->cmd == SEV_CMD_TIO_TDI_BIND) {
+		ret = sev_tio_continue(dev_data, &tdi->tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		tio_save_output(&tdi->report, dev_data->output, SPDM_DOBJ_ID_REPORT);
+	}
+
+	tdi_data = tdi->data;
+	tdi_data->vmid = vmid;
+	tdi_data->asid = asid;
+
+	return 0;
+}
+
+static int guest_request(struct tsm_tdi *tdi, u32 guest_rid, u64 kvmid, void *req_data,
+			 enum tsm_tdisp_state *state, void *private_data)
+{
+	struct tsm_dev_tio *dev_data = tdi->tdev->data;
+	struct tio_guest_request *req = req_data;
+	int ret;
+
+	if (!tdi->data)
+		return -EFAULT;
+
+	if (dev_data->cmd == 0) {
+		ret = sev_tio_guest_request(&req->data, guest_rid, kvmid,
+					    dev_data, tdi->data, &tdi->tdev->spdm);
+		req->fw_err = dev_data->psp_ret;
+		ret = mkret(ret, dev_data);
+		if (ret > 0)
+			return ret;
+	} else if (dev_data->cmd == SEV_CMD_TIO_GUEST_REQUEST) {
+		ret = sev_tio_continue(dev_data, &tdi->tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret > 0)
+			return ret;
+	}
+
+	if (dev_data->cmd == 0 && state) {
+		ret = sev_tio_tdi_status(tdi->tdev->data, tdi->data, &tdi->tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret > 0)
+			return ret;
+	} else if (dev_data->cmd == SEV_CMD_TIO_TDI_STATUS) {
+		ret = sev_tio_continue(dev_data, &tdi->tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret > 0)
+			return ret;
+
+		ret = sev_tio_tdi_status_fin(tdi->tdev->data, tdi->data, state);
+	}
+
+	return ret;
+}
+
+static int tdi_status(struct tsm_tdi *tdi, void *private_data, struct tsm_tdi_status *ts)
+{
+	struct tsm_dev_tio *dev_data = tdi->tdev->data;
+	int ret;
+
+	if (!tdi->data)
+		return -ENODEV;
+
+#if 0 /* Not implemented yet */
+	if (dev_data->cmd == 0) {
+		ret = sev_tio_tdi_info(tdi->tdev->data, tdi->data, ts);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+	}
+#endif
+
+	if (dev_data->cmd == 0) {
+		ret = sev_tio_tdi_status(tdi->tdev->data, tdi->data, &tdi->tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		ret = sev_tio_tdi_status_fin(tdi->tdev->data, tdi->data, &ts->state);
+	} else if (dev_data->cmd == SEV_CMD_TIO_TDI_STATUS) {
+		ret = sev_tio_continue(dev_data, &tdi->tdev->spdm);
+		ret = mkret(ret, dev_data);
+		if (ret)
+			return ret;
+
+		ret = sev_tio_tdi_status_fin(tdi->tdev->data, tdi->data, &ts->state);
+	} else {
+		pci_err(tdi->pdev, "Wrong state, cmd 0x%x in flight\n",
+			dev_data->cmd);
+	}
+
+	return ret;
+}
+
+struct tsm_ops sev_tsm_ops = {
+	.dev_connect = dev_connect,
+	.dev_reclaim = dev_reclaim,
+	.dev_status = dev_status,
+	.ide_refresh = ide_refresh,
+	.tdi_bind = tdi_bind,
+	.tdi_reclaim = tdi_reclaim,
+	.guest_request = guest_request,
+	.tdi_status = tdi_status,
+};
+
+void sev_tsm_set_ops(bool set)
+{
+	if (set) {
+		int ret = sev_tio_status();
+
+		if (ret)
+			pr_warn("SEV-TIO STATUS failed with %d\n", ret);
+		else
+			tsm_set_ops(&sev_tsm_ops, NULL);
+	} else {
+		tsm_set_ops(NULL, NULL);
+		sev_tio_cleanup();
+	}
+}
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index a49fe54b8dd8..ce6f327304e0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -36,6 +36,7 @@
 
 #include "psp-dev.h"
 #include "sev-dev.h"
+#include "sev-dev-tio.h"
 
 #define DEVICE_NAME		"sev"
 #define SEV_FW_FILE		"amd/sev.fw"
@@ -224,7 +225,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
-	default:				return 0;
+	default:				return sev_tio_cmd_buffer_len(cmd);
 	}
 
 	return 0;
@@ -1033,7 +1034,7 @@ static int __sev_init_ex_locked(int *error)
 		 */
 		data.tmr_address = __pa(sev_es_tmr);
 
-		data.flags |= SEV_INIT_FLAGS_SEV_ES;
+		data.flags |= SEV_INIT_FLAGS_SEV_ES | SEV_INIT_FLAGS_SEV_TIO_EN;
 		data.tmr_len = sev_es_tmr_size;
 	}
 
@@ -2493,6 +2494,10 @@ void sev_pci_init(void)
 
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &snp_panic_notifier);
+
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		sev_tsm_set_ops(true);
+
 	return;
 
 err:
@@ -2506,6 +2511,7 @@ void sev_pci_exit(void)
 	if (!sev)
 		return;
 
+	sev_tsm_set_ops(false);
 	sev_firmware_shutdown(sev);
 
 	atomic_notifier_chain_unregister(&panic_notifier_list,
-- 
2.45.2


