Return-Path: <kvm+bounces-44701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84DF0AA02E3
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8E66461EF8
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD6B274FF0;
	Tue, 29 Apr 2025 06:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NPj9rj5k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D724227057C;
	Tue, 29 Apr 2025 06:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907347; cv=fail; b=tN34ZvjQ5CIJy0C/aBoJFpsznEuBaaavgl9xnyXB2eXMcDfiwkQ/MuXfYoFUIl0XXbX68JituK08TrJj0QrRTqeVynuJugB310I78Db96g3XHU1Tx+mXlLLr4mO7dPeVEE6BR/Ov78V4cFbQHilimOeNO6gmyl54aY63MzrGp3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907347; c=relaxed/simple;
	bh=0UOiL9UqgPmSKRUghChpP8cqKFvlvjYYVby+Fus4rjY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mgH94kReNgcMpd+/kj2aHvIROG4n+g9Enjj0jtoqtM3enZH2ZXKITTzdSrj1k7YtjJrFzV2pYOJrsdU6cTWelQxC/VgUK9uOscXfbVWM1oeczkhQCj9IUFx+LGIgDvqe4fOhlQQm/EUheVbQ/08ZEyq3NTstc9yB1015S8VoAJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NPj9rj5k; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNynLog6sHssDoiLvBgbGW3GGx5c9MMwLNlNb5uyH7YPDE/0FFGr3tTM8TVOeTbKIJ5igTZjmnwWES/GH3MT6ELwkZg9PUv1fvH8TkKZImtIutVytlqMeB0Ye7sM3O8MBLOndUhzMmMoAWGSaTqe+NqxkP1rZYkqk3vCt3N6m/+bx/wMZLaZT+S5WiiIFT1xFhBUf7o8bRypPvnUQcVVdiU35+lIBfCf6neUew97rsjkztxSiUeGkGvnvhaqsD8HcudZgYon9hOvb2kdOKCjMh+NqexsJmkaRq14tu2turBstplyu9a4NYOPZ8W448XFDnu2FFhXqsoGhwLix2S/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cg7fliYLKsG3PSHRY34jUkTpXHqL37Cq8/x/NmILQoQ=;
 b=EfFNOCG9qtIbWpg7Elf4ufDZFI4c1T2IoMSQAllHSPiIOL7UcGdSmZcG/oeAXjjXrwCnZUCIXqQKkPBuKmlhTwPj3NdLfthozdgffZ+pw7EeLsYVAHFQ6QnYcd0qqL6bE8Y+ul78l2aaNpw8n07gtmOzYzlgu6uPTjjJ5/6Et0zdofDsTfHWTO6G3O5cB4M4/sBGmRvFIGh0H0f421QVqZZhC4bkooQUHTz54O9lbwGlHS6uRAwq9IAl2eM8hpn5bdd1ZXXPB6fsBq8JiqdGlYTh4OTatDjDKo1xYuRqsHWOndyXa7Zzp8oHBCGlCVRtV8ewdfXUk+/T53B4bMQ/7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cg7fliYLKsG3PSHRY34jUkTpXHqL37Cq8/x/NmILQoQ=;
 b=NPj9rj5kLmJtjkAIC8Y52RWNmi8wsyA1kCI71JMjncO6JlovcqoeXgDkihvutDP1PDOoQ8Ybg+Ht8dIY/qf6ZsEkucla9n2JBuRY78z2w5Us4boML9Z7Lmqb/IVwMohVCiZJ5FMDjrcVZWxDuIqJsMUd0PE3a8zzDJsmVCX1PQU=
Received: from DM6PR07CA0110.namprd07.prod.outlook.com (2603:10b6:5:330::26)
 by DM4PR12MB8572.namprd12.prod.outlook.com (2603:10b6:8:17d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.21; Tue, 29 Apr
 2025 06:15:40 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:5:330:cafe::a2) by DM6PR07CA0110.outlook.office365.com
 (2603:10b6:5:330::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Tue,
 29 Apr 2025 06:15:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:15:40 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:15:28 -0500
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
Subject: [PATCH v5 13/20] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:57 +0530
Message-ID: <20250429061004.205839-14-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|DM4PR12MB8572:EE_
X-MS-Office365-Filtering-Correlation-Id: 9911e161-e67f-420d-45bc-08dd86e5442d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dTVQAt8X/MIOHzIh/TBUkl4EAo9tvZl6C6tey7w4h6tL7jMS6jOOWZza1HnZ?=
 =?us-ascii?Q?uKT0mh8qlmLZd7rr9MQ2X7n+V0XWtsA3Hp0J/yNK1mKRpE+Jk4vfDouMF46V?=
 =?us-ascii?Q?8Mlxwg9kB1YP0Ubswt+69xloWKkWaz3UXyG5hhlVhFpzSJwQsZRX5XG6kIYE?=
 =?us-ascii?Q?Io9BjPDm21nDWNvfXhdpKC+gEnDSC7HyPi0SEVwT3ditnDuiOHOfd7uBi5hq?=
 =?us-ascii?Q?qhHLrydxu7WbMU7OoMwBL5Nnw1OsvtcMiMVlyQ/RRhSA8QWoeloXqJ88zAqp?=
 =?us-ascii?Q?PNAlOBHn7hXESM8vBUxQ/XsTSMbz9X8Rf/VajCJRcYRkWgOKiERKkMZYcyit?=
 =?us-ascii?Q?oQIaXTZFx6gvX/kp6I6nQGX4vxUs4PQPeXEvna6g7cGo3YNQEtGqvyQ2eovz?=
 =?us-ascii?Q?iUcPqLYgmjl19KbdpEbxlpmY23svGfojKIGRIpkj4oAOYrQ4/Ox0j9viup+5?=
 =?us-ascii?Q?F20IZ2XlPzAE4dAqmxKnOof9w3E/BPiFYQ4y2B4yVDGapy7S/zsLnPBwn70R?=
 =?us-ascii?Q?KlvoZzOHvU1oJWKmgwxdQVNYp7RLrgivRtobNW+Yrs3irm3QZH1zIkw9p1wd?=
 =?us-ascii?Q?vCwUz56VXXHHPVjjDhYU8AN7oEuZmWWkh5R8824GvpypzKpu8D5QNVcQOUgf?=
 =?us-ascii?Q?KPRsqIyIB+PdxuGeMPigAzPMQhIl4BbU1Mo91onssEp8hYxSnvAAChLnsi2m?=
 =?us-ascii?Q?tpaVUV84elO0Ch7Io7MRVtRtXFJd4CFzNFgsJ6fayirxPg7zztk4p0Aqe0m8?=
 =?us-ascii?Q?rqFgRgq58iCfCdLb+lA+DcsCfi+j7XfXkLM3pXzP8Dxy+IMK5K9DC0GDs6tU?=
 =?us-ascii?Q?j2PTkFv3iZaJLxcMi1fyYI+l0xlDMnBxa3tWXN8N1/payPVNlynawe7Be7iJ?=
 =?us-ascii?Q?EttzIYbOU7WrCL/Hbuph8PYRumNZJhx5zN99iLPksejCPFgyvwuOzmaiag+n?=
 =?us-ascii?Q?WHbKObVazwExx0g2jil+dIiK7Ixe4mD9VXEBN5O1LWZcUme8tVXwUJD3AJuX?=
 =?us-ascii?Q?L4HpVddMM/MmiwNkIlFVMUprLTo2hNm2TP5HrhqroJF5d+V5HELzf9QpTAQq?=
 =?us-ascii?Q?5JvKYg0s/KU3BV64NWWr1n78btcUrPHCqP3bogGQQud8/iBO4ASkgcKZqB6f?=
 =?us-ascii?Q?kLOLzGsrGy6KRSbvXxnZ1GTRb/c3QENYsnqi0oO+x1/arCJO1Xc8xwTo/03a?=
 =?us-ascii?Q?95CR2kPP+5qXW9hWlRAE4OQvuN3J/zgXGkgSq8YgYHPEzmiPTUUIOWS/zAsn?=
 =?us-ascii?Q?vfne5DXasUp+Rt/QOxSk4939hMcXQey+nRHcp+1Uh6ag+SxqXmHONYdQ/f3u?=
 =?us-ascii?Q?hdffUwF3KuO572/dBB9phFl69WGYDBnztGzBzbvbpe7ZnstUfEf3XvPtrEHR?=
 =?us-ascii?Q?o2qoOowzE245ZuONudZVZ9S8lcDypMv72aqQ9lc/fcAdH7FYeYXH+ZtFBp5F?=
 =?us-ascii?Q?p+yCfTlVOqJQjelYbNLy3071xKXrVkU1AbDhT3DJOboXqk5Idr3k3aOmZANn?=
 =?us-ascii?Q?DH28HLmhnJU3Hbt5nR/MDgwAEuwa2j+TZMtS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:15:40.5135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9911e161-e67f-420d-45bc-08dd86e5442d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8572

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - No change.

 arch/x86/include/asm/msr-index.h    | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d32908b93b30..9f3c4dbd6385 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -693,6 +693,9 @@
 #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
+#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
 #define MSR_AMD64_RMP_CFG		0xc0010136
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 97abea90eed6..d7b9067fe996 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -29,6 +29,11 @@ struct apic_page {
 
 static struct apic_page __percpu *apic_page __ro_after_init;
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -351,6 +356,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


