Return-Path: <kvm+bounces-24919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBDC095CE01
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD17CB20E9C
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914E3187322;
	Fri, 23 Aug 2024 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ITsEUhh3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5770E185920;
	Fri, 23 Aug 2024 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724420017; cv=fail; b=jOh0uQ2qObeydUlq+QtE36whtSZqmlsjcWlVLaDhnM/zqzw5nNwDJnj/fq7c4kLURaWOP+i8YaufvymksPLBe13s6/X8C1UU2EKkVq9uJup2D93bjeAfGnG49ER/dLs89DrlzyYm4wpj5BnYZz4jSOEyjddM9K8z/VcyC/mqAh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724420017; c=relaxed/simple;
	bh=cQInEfLb+YpCGMaA9/lL1qa/2qBqFLgxaefuUICWDzQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVB6Ti1qC5pmakb8sOJspAtJ6cLH2pYUlcmLET2TxSRkEsB2QgWgr9urLzWydNWEJ1qEeGQ8VXovMCLbl1yhcJRgAbfTYP9z5pbv4HX7oWXid3atda+NY7yLjM2jShsQyFmwSRrS3S7qT9d/U3zFRiKfNdqJShXOqV/oz+7ageU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ITsEUhh3; arc=fail smtp.client-ip=40.107.212.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbJ3cYNn5BNf5OIRmqFhWJ+O8g/6+k1DEk97RQq3H9JsSZONzM79nENnWCitmkc8ClNknDxLL4WFQQDv8V3jA8cjvTjMN70Ns8IBq7zRgIfhco6iTZlJXe63XU2uQ6SGtXj6/MrLvqjeZ9cW+sAeUrBGu/S8rci5FocepurnTqTOtzW0f3phQFSMpDTbqhkdXf1x7RYj2Q+aXye4bKnTy6ABQ//Tl41Z/LUP3g0xIJTswn9StQFhHP2fVMpBqR/oGxLAmpQXnaeVS+xmuHJysmqUVrCRQhI4wAwv/1Hn9EqmFjqs+sw+9MkhdMQF7yvdY3n4QHpo3SF30uX3eDRzkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4t3kGZG9vXAAI3X+GM/4KY5BbP775kCOx+yOmL5/QbI=;
 b=xev29ZPTwXRiHvaZUSoHkQrRcxbx2zOn86IQGhRIJtqYdHt6vV1bDwlHV+FhblZpRrvqS6fbJXxx0DSrNrdo5HEZGXwPJEeXuet8FiOxiBDfhHGs6RUbkNqIuixclLRMd1gXFXI9Z/ymDk1Esc4ZpskQuqKlW74rh3ZiFAMs6gbWxb0vSp5tFX7J5/Ep15VmQ4zk3Vrp0giWnHqz3gIcXrU6Rpvk+nLyqeac7z1OhNBHXRbKOInoqrXEBzsZmqXFpWV3FZ5uwxS1+tCZGm0Ml0KjxgoD+2vLt9J0ewMIZmA3KLR1l69UkmcUF/Axy7LcGDpX2cafJq1MegujClazwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4t3kGZG9vXAAI3X+GM/4KY5BbP775kCOx+yOmL5/QbI=;
 b=ITsEUhh3KN9HqK1PNHC2VusRaJus3E5PLko3KGjK3yneEsdjPA45B9rH81ENroHuaE0V/eWwvguCyzhk0Rjj70ZpPWT2jLoTfbFt5MWtnG2cBXe00tbzMxcYIQfGSryu8c061deoWVAhaZtcxmt28XEoMbV/FdNZdoxZ8297P8I=
Received: from PH7PR10CA0006.namprd10.prod.outlook.com (2603:10b6:510:23d::25)
 by PH7PR12MB5901.namprd12.prod.outlook.com (2603:10b6:510:1d5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:33:32 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:510:23d:cafe::91) by PH7PR10CA0006.outlook.office365.com
 (2603:10b6:510:23d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:33:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:33:31 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:33:25 -0500
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
Subject: [RFC PATCH 21/21] pci: Define pci_iomap_range_encrypted
Date: Fri, 23 Aug 2024 23:21:35 +1000
Message-ID: <20240823132137.336874-22-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|PH7PR12MB5901:EE_
X-MS-Office365-Filtering-Correlation-Id: 42e32eb1-6997-4d38-5189-08dcc3782df5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dhlz3GlVofy7STNa8XIb5cur/jAnm6CXKDtHv38GIr/CAlYmQrY9l/hJZrrX?=
 =?us-ascii?Q?3ANgQst8LLRQ1y44i9SNZ+2UKl2gXd3aGo4DJG+BW14f0wTwYJCSd6/N5bvp?=
 =?us-ascii?Q?r38e2U6e9FWeYJln6JcBRE54f1+ENFLec/3+egBlf0CEagwN1Kpdjy6cjSGc?=
 =?us-ascii?Q?2jtnrl36wSddNIB8vAEQBvfiph8puqSe4Av/FuTp8wCR3F1/86mCvpcXJ7+v?=
 =?us-ascii?Q?hjwaUXlsJCpGnbjAA7S9RFU3QjrBb52KBF8JCAlq5bDgoUeuLq4YbKP89b3Q?=
 =?us-ascii?Q?8euf/5MgH6KRY7l11bUU/hS88iV44J/Wh5F+ykx1v46cNXJc0e/kTLOlECcI?=
 =?us-ascii?Q?+8TxAqDNsEEa916V6BKREt04ypo9I+Qk8HeZfHPmM8jVYCVrpifqFdmjF3w6?=
 =?us-ascii?Q?do21xnPJYoa4jncYgXOWeMyb80h/h4tcGF4E5gtnKC1QzsglydEAjtMaRPKa?=
 =?us-ascii?Q?Vg/VKnSvJZUygoJQ3ujZWUnaGvE4ysp+QOvZSVhF2/7vp6OioLwv8ruBcX/N?=
 =?us-ascii?Q?rHa5aB4/3NYzQXLutGelcY6BO+bz1TDLPsvrLerLGdGdGeYb/m452rL1l0xu?=
 =?us-ascii?Q?dYOiRpvELq7zlJFrYJAISODWNMbWEHwXXb7a/aBOewb7vn/DSk0pa6+jJ/cC?=
 =?us-ascii?Q?9bDxnc+rqdywQZVK+sOCf85Qt7twJpR7vRahiliub7lWPgsqqFEt+EZGACXB?=
 =?us-ascii?Q?HopvEuUp4I4xiFaMKGAgkHY0chP/5muvU/jWsM7jxPuTzB04QKQuMK1AacYu?=
 =?us-ascii?Q?ojukm61BY8KpKq4oJFYTrPeF4/FbTzc4vSuhjfXekbkP+a7Ne9SNf4EdR9nC?=
 =?us-ascii?Q?WqrQ1wGJa5vJ5KXZ9uuli2K+WU4Omcr8qhhTQJIjuzPIE660zLWtOVl5crKZ?=
 =?us-ascii?Q?uB/029LuQL62sAPPKamf+Fs/QbuGEwW2FZfSTdNkUcCtn8os78TJ2Rxw7/80?=
 =?us-ascii?Q?P6VXyH+LXWbgvqWzGbCNOb2DyK3fnGKg9kn0xdbtwqJNf4Orsy762+7nPrjd?=
 =?us-ascii?Q?Xj9ZFLpE7c5HACpRYrUdvPBfhrb7xbtYfNg7rHrqDBWNQN2+c9c8J8LzRkIL?=
 =?us-ascii?Q?KupORIMtuFpkLc7fVUr2aljoLpi8rMGY3YKntiDWIr3BCGFoVL9cdoN6sKLn?=
 =?us-ascii?Q?m4imm8STRzuUA1E1U956eSa/SFeTwj2z9jXln/Xp92GmCyvf5g0wldsnUmnI?=
 =?us-ascii?Q?i4RXJdHbmATNNA0gYnbzHzNx3KkZN/lt4MmIaYbd3UQRgYkbdkq/sR/Idrq1?=
 =?us-ascii?Q?hNb9o0ebH+E+ozRdityOEKdUqICa1nCVLZyyRHCznlZ8fXuyDjl6CcNy40zk?=
 =?us-ascii?Q?QqJdPndrmm1OoX5om3d+tBy/rgBa1/6xH7aMl+c3t3bDqMTd0cmInxFntqxO?=
 =?us-ascii?Q?ht2s6Z3gL2OR/F+UOWjMVrtFL5m1BHgW4zDmWzk4Tu5c/sPLwgwZz8KPJY+o?=
 =?us-ascii?Q?aw2fEFiOv7lVoFXOa8Pwu6MUfC+2fCWK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:33:31.3061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e32eb1-6997-4d38-5189-08dcc3782df5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5901

So far PCI BARs could not be mapped as encrypted so there was no
need in API supporting encrypted mappings. TDISP is adding such
support so add pci_iomap_range_encrypted() to allow PCI drivers
do the encrypted mapping when needed.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/asm-generic/pci_iomap.h |  4 ++++
 drivers/pci/iomap.c             | 24 ++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
index 8fbb0a55545d..d7b922c5ab86 100644
--- a/include/asm-generic/pci_iomap.h
+++ b/include/asm-generic/pci_iomap.h
@@ -15,6 +15,10 @@ extern void __iomem *pci_iomap_wc(struct pci_dev *dev, int bar, unsigned long ma
 extern void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
 				     unsigned long offset,
 				     unsigned long maxlen);
+extern void __iomem *pci_iomap_range_encrypted(struct pci_dev *dev,
+					       int bar,
+					       unsigned long offset,
+					       unsigned long maxlen);
 extern void __iomem *pci_iomap_wc_range(struct pci_dev *dev, int bar,
 					unsigned long offset,
 					unsigned long maxlen);
diff --git a/drivers/pci/iomap.c b/drivers/pci/iomap.c
index a715a4803c95..2bf8ef4f672b 100644
--- a/drivers/pci/iomap.c
+++ b/drivers/pci/iomap.c
@@ -52,6 +52,30 @@ void __iomem *pci_iomap_range(struct pci_dev *dev,
 }
 EXPORT_SYMBOL(pci_iomap_range);
 
+void __iomem *pci_iomap_range_encrypted(struct pci_dev *dev,
+					int bar,
+					unsigned long offset,
+					unsigned long maxlen)
+{
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
+	unsigned long flags = pci_resource_flags(dev, bar);
+
+	if (len <= offset || !start)
+		return NULL;
+	len -= offset;
+	start += offset;
+	if (maxlen && len > maxlen)
+		len = maxlen;
+	if (flags & IORESOURCE_IO)
+		return NULL;
+	if (flags & IORESOURCE_MEM)
+		return ioremap_encrypted(start, len);
+	/* What? */
+	return NULL;
+}
+EXPORT_SYMBOL(pci_iomap_range_encrypted);
+
 /**
  * pci_iomap_wc_range - create a virtual WC mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
-- 
2.45.2


