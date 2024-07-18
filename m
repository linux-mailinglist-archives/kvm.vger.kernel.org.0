Return-Path: <kvm+bounces-21840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7828934D77
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 536CD1F23B13
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C0A13C801;
	Thu, 18 Jul 2024 12:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sQkMA9AM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9A054645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307098; cv=fail; b=XsgSb+F+2Fd54SJMQaOw+qsY7WzqJPMaxqs70Ot9WG7ikOsfx9buzd7rXfdtAsUJrTbC17RY9URldDwcE7YSEhQFlVM34D/ZNTxgbLebNJLnA0p6kDs2K4V79SduT/hyrwhkiBmRBGmiay//s9SGG61nqocbracxcqEqr3s7R0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307098; c=relaxed/simple;
	bh=t79R4Ca4J8ikqD0u/E3rqhgpksIJw5tfn/dxGUFXExE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V4qZpLstMIv5qOaTnfhFyY3FIsAnwDY4peBzIzh4HMyZOZgWQaTJbbbfFU7J9cebEJrdFLa0JRi7SuiEgHSb8KbFu2Zq77uQeCyGngth2v94mdvYc90LG9XIubh/rcbO/5UzoVCCFH8CToLR6drn6j8wkbHVAuWAQAkYfJyDUKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sQkMA9AM; arc=fail smtp.client-ip=40.107.223.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W0CBiqvsTsZX/XuZi0g5UJhG9VlR6d8JeDxb0y4jPdoL1ce1O3l5dX+IYPaI7D4EZd7j0koKc98HNqaeY+cxDW6UXtr9kAdNcNamWcNWCouINyaxonQIdWvFirLjwzxlkXEifpFTIO1glg8DhFQ7EKAJojcs28ChSKpGFVfFx9ZDTwWlhkd02VGzYksETYE2dP12kfAlPOPJgrocmkAHE/IQxAbEDExXkT11sEIL/FexFLdlpndAinWI9KAukEoz2iKd+sXPkQTL/gKsevRrCvILKfnYczcyUTYohpKkRoJAVxMg1BfxM47d6E5viAZBzJnlc/G5GvKZd1npZ7udgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWoWr0UDy350uX1N86rPSz39kaVrS/WM+fCZydKjJ+Y=;
 b=v4aoJom9RzPSnewHfdOEh0zKjOTZ6Jn2/cfG01jbAEDtuu0xhea4Amq/FFNjNnzYiNCs/1+u89FJBx8vD4tyu/KfsifoTcqFocMzwb2hvh3J5uiFNEbsjZIfWMOQeq4e4aZhctOD1qF1kvt0mkJJL1HpCC9TLiJESuREOegRHOCx8SJWsb9x8RxSyGEMIBOaoHqsxaxX+8UGKF/CC6Y2ttkiUtwWyTnSF6VtiwtaEyxwlU/wMPQM92mjUbf7vqc7C6lDxzAiLUc7XeTO/4/36NThhhshfsdv/+1aEukQgFA+YkgriUmYGuYbANg/gZvUgoZO8CcnJhiMDEVozR3QUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWoWr0UDy350uX1N86rPSz39kaVrS/WM+fCZydKjJ+Y=;
 b=sQkMA9AMYatITq92CdwSkzbKMJVB5cpMsAiswhgL4sj72kUpTAe5yLKGmc6ZR/nKHnX510XmXfD3pIHdZHf619Qo0ygsuqnA5+UnHsm91jiHTUq+kYJ6nH2o+zLmI/VxLtgLsBKZ/7Me1+TJ5bcKupgmRPOGk2/6Bc7vATBs6D8=
Received: from CH0P221CA0015.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::25)
 by CY8PR12MB7415.namprd12.prod.outlook.com (2603:10b6:930:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Thu, 18 Jul
 2024 12:51:33 +0000
Received: from CH3PEPF00000014.namprd21.prod.outlook.com
 (2603:10b6:610:11c:cafe::61) by CH0P221CA0015.outlook.office365.com
 (2603:10b6:610:11c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Thu, 18 Jul 2024 12:51:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000014.mail.protection.outlook.com (10.167.244.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:51:33 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:51:32 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 09/16] x86: Introduce gva to gpa address translation helper
Date: Thu, 18 Jul 2024 07:49:25 -0500
Message-ID: <20240718124932.114121-10-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000014:EE_|CY8PR12MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fc6a028-9fb8-48a5-64f1-08dca7285a39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AbvJPBwD2UTDkxjm/7W0w1HCYRFqW3WxzppfZJ81uuHbDGs08U96bJ1eJyp9?=
 =?us-ascii?Q?jvhsVVLoLHBHpwFaoyJvW/Cn0mpvhG4zS8HsaTc0cCaNG0CNyUrsw1pJji/3?=
 =?us-ascii?Q?lt8wQAJDDzHHtRb5G7lJG121BnW4iLGhacXHNlh+tOudl3fWW1Ky2xkm6vsn?=
 =?us-ascii?Q?2oURequPnsbnfoCBzSDfJH4sVQTOrpBwgc0yLddxVhQG9tMcxpbB2UQTMVz4?=
 =?us-ascii?Q?1VhG2YVOxTHRTX8UwtxPgnjX5eIUxThpb9beqgcgf41BfHMqXdMgHyKh/1JL?=
 =?us-ascii?Q?EN3zFfxpX680uzdO1Yim8X04EKR25N1rB6X/q0zAA4cmDCsKLaOGPmrArfTJ?=
 =?us-ascii?Q?CjydU4a0pKU/N1znWu2FcrFcgGIywlwYXXaTIgiwSBR/K9gjiNOlIs9idaX3?=
 =?us-ascii?Q?IuZHF3vqUcIal/Aauvhz3mC6KlaBJO63B/dQPqlVWBjnqFl+E49h9HKACVG9?=
 =?us-ascii?Q?lgsXlHzDrUZxtPTdgVGBRosAKH/4RVn4atHbt/hz6godSXOCKAT1Zw4ora/s?=
 =?us-ascii?Q?0l5PppZ86Qq9EixvV6aNp1GylpFMBVpXZ+BiwOzB3q1hyHTxSDy3RL1oSVwx?=
 =?us-ascii?Q?hU24fG3hU4smS5YCD8YwYWoNEvmCFo2RAn/gnh9XoQxmRoYP3A4p43i0RQJs?=
 =?us-ascii?Q?ug5coTMj0A7OI9YwJdKRpnXUHQkYuCU1tKERxcIK5htPw/X3QomtKhgCYGkT?=
 =?us-ascii?Q?e/MWU/3tOsBF8KaBE3QHeV7q7A15d34riCj3GmwrVEqi6nZtCCD/+WfPniHm?=
 =?us-ascii?Q?WzyhT8LoakYklFo2ylz26v3w3XVwE0zPOmF1eBK3uaTZTOFZI63dNNLTfCDH?=
 =?us-ascii?Q?qzQrnnfjSkznkebqAaQNTzBoDNBPfb1cTnu3tW9y+m2Ah57Ht1uyNmFOzuwH?=
 =?us-ascii?Q?amRaE0i3RulmpWmPdCgs2bcXZtVHi2MJBsMqvVJmKi2gTI/TKui2G6fauGY6?=
 =?us-ascii?Q?oIwqxLL6Dz6Tl9SpDFXezUMlJ1DhzMLSup8Wj8uUFh8JiKUpF2iitTAMHqiw?=
 =?us-ascii?Q?wuNA3qS1gxiKt6cXWHj65Nd33/yqDZgDzo88MLa0NRNTon7A6a6nNnq9N32v?=
 =?us-ascii?Q?SqAUlvmG6SiFlAHXR7ZZVU7FLBXAOYLqd5gBVopCl1rNddBOseg/d6XyYrbn?=
 =?us-ascii?Q?MBJeQJnt4g0FQcIWGibO1SmbFYYTHlw37dxOnLsE9dkxMKOgqrS4OYSpBU6p?=
 =?us-ascii?Q?oxxV7R6OyvVI0JQTyVyXASPBsMXCZiGT+0pp/Rsvrke1YzqAA5uQKH1fvHXq?=
 =?us-ascii?Q?cJRvfB76w8std8JZi8Nlcu5JCYd9A3uZrpN9sjxAqJ6YwL7AWdtDSWP7NCt6?=
 =?us-ascii?Q?0EzXJbRnWP2KXJSnC2xc9K+5IOTI5gCEkhacpCPU1nqioP//NYsonDxDKmCA?=
 =?us-ascii?Q?7UwsuEcdK0DZ734DWrcOI2V2HLkrQJy7qJqNbvRSZkthO+GuT22N4UswevSU?=
 =?us-ascii?Q?3AbrXb5x40mcK2xratsX2xrt5HOQJnME?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:51:33.3227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc6a028-9fb8-48a5-64f1-08dca7285a39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000014.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7415

Perform the translation of a guest virtual address to a guest physical
address using the currently installed page tables. This must be used for
virtual addresses that are not identity mapped addresses, e.g. a virtual
address returned by alloc_vpage(), where virt_to_phys() won't work.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/vm.c | 24 ++++++++++++++++++++++++
 lib/x86/vm.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index ce2063aee75d..078665b2faf4 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -332,3 +332,27 @@ void walk_pte(void *virt, size_t len, pte_callback_t callback)
         callback(search, (void *)curr);
     }
 }
+
+unsigned long pgtable_va_to_pa(unsigned long va)
+{
+	pteval_t *pt = (pgd_t *)read_cr3();
+	unsigned long offset, paddr;
+	int level;
+
+	for (level = PAGE_LEVEL; level; level--) {
+		offset = PGDIR_OFFSET((uintptr_t)va, level);
+		assert_msg(pt[offset], "PTE absent");
+
+		if (level == 1 ||
+		    (level <= 3 && (pt[offset] & PT_PAGE_SIZE_MASK))) {
+			paddr = pt[offset] & PT_ADDR_MASK;
+			paddr += va & ((1UL << PGDIR_BITS(level)) - 1);
+
+			return paddr;
+		}
+
+		pt = phys_to_virt(pt[offset] & PT_ADDR_MASK);
+	}
+
+	__builtin_unreachable();
+}
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index a5bd8d4ecf7c..9f72c267086d 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -59,6 +59,7 @@ static inline void *current_page_table(void)
 
 void split_large_page(unsigned long *ptep, int level);
 void force_4k_page(void *addr);
+unsigned long pgtable_va_to_pa(unsigned long vaddr);
 
 struct vm_vcpu_info {
         u64 cr3;
-- 
2.34.1


