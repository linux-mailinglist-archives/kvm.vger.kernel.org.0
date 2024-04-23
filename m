Return-Path: <kvm+bounces-15636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41F478AE379
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 13:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 659CB1C22083
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 11:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36A97BB06;
	Tue, 23 Apr 2024 11:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FmqnBL/s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEED26CDCC;
	Tue, 23 Apr 2024 11:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870636; cv=fail; b=b47KJCyVzY7iDNP4Gxk8WtlQ/BfckcSnMfQijtd9tbr/Gev110lu9EI7IXM4ZIXf0/m/G09MMq57gpA1XEBF2lj4kLlA+i52cqrzriZA4GDpmXrbnElIV0GPw897adx5kW3WBYX6QySAjpdn1JwCIWWWIVXQ9N4sf/FEIICLzFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870636; c=relaxed/simple;
	bh=jptgyFHFPHN7k1IQn5vmAi87H0IUSoYaBcFjFCX4ZUg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oRwYuIWAnWaBmvNmFE2ic5W+ax6iEK0uw2E185KMAkAuXVeg3iM4+PSkbwGzJiyAWJvhxRZYNEdQ3D1Y+1x+Vo2DJ5bzrFBxxOWl6xyP7sA/nLBKj0taxWrWnMtLFhxMi9OArShXkpBWt88fI1EF3OCETLy2JJuuriQTjJcTgFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FmqnBL/s; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnxdHONJsKSbWsjfby/OVgxLefwTFhc2ObK6wUnVNNJOQ47SxSbsuuxBjDLZUdPBI+QcfraOB+Q13ENEKmIu8hWTGjkJrkZQc5nwiKyvYRyzTGFD2RbEzXx/wzPdOAkgBI3TnbWkUBXvaBjpKYXgi5WqtucuaEmsTph922doYqWaKDe+l4Adnc+8+y4vFkHbwxnThRq8JnOdGmAeHH5l5wyfqaXk/RlBq0/3Q0rJ0RNTz1HWmY98VPzeSrKbKMdOk/M62J31XT2dxsnHbs7lOqvy62CVIhtVT/p3/1e7v3ED4/4X5l3D3EoyHKh/UpVIA2QitzBtKHUbaCzoFrqsUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UeDwxMvmBqzyB6p7wrPOjn8GmtWqVEL46YSjfXJV6g=;
 b=eGtU80R4EX14G1iXI5d1+NZbFxFNRWswMhNsRNDd6WTpsyE8MEAiarEgZ1f7LLoxSLwYrHUzFKzVJsH33xxgQNnRrr5oGiKDuTko236IJhvY7w9tVvCxxV9bTsF4zEElkzGp0Oj3hkLWx11FUMZR7Zj8TdCJR+b8Tv4N1RHV9jOWf3jw2TKB23ZjAHVWm6Jc3T/0dDbY54t78DoBdcQn63bTk/7eHhMqnv21bV8dwWj4YRkPLmqzI3UV0tz7rNPrP100qGmxNQYIcBXd+IWlyV4ZSF6Y6hsOon4PbGq6V2twEXQlNuMYPYzyYr/ljQLQSea6ZSroehn3lDOq+q8C6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UeDwxMvmBqzyB6p7wrPOjn8GmtWqVEL46YSjfXJV6g=;
 b=FmqnBL/s6i/Yw5+PGxYOxd1vNOTtQBsCtxYdd6qhz04QcB0ogEO3O0P8++FTlrSjER3011uxKZpt/sddHSLel2b8qaFBYlEMrwYLIrVqKLFyFP0vOhiLwcQpryvujaUOAIJ47PWHj4dVZE5u1ukskRwlgmcVYhevreJM85yHFmg=
Received: from BLAP220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::8)
 by SJ0PR12MB6879.namprd12.prod.outlook.com (2603:10b6:a03:484::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 11:10:32 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:208:32c:cafe::ce) by BLAP220CA0003.outlook.office365.com
 (2603:10b6:208:32c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.31 via Frontend
 Transport; Tue, 23 Apr 2024 11:10:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Tue, 23 Apr 2024 11:10:30 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 06:10:27 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 06:10:27 -0500
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 23 Apr 2024 06:10:23 -0500
From: Nipun Gupta <nipun.gupta@amd.com>
To: <alex.williamson@redhat.com>, <tglx@linutronix.de>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <maz@kernel.org>, <git@amd.com>, <harpreet.anand@amd.com>,
	<pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
	<michal.simek@amd.com>, <abhijit.gangurde@amd.com>, <srivatsa@csail.mit.edu>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v6 1/2] genirq/msi: add wrapper msi allocation API and export msi functions
Date: Tue, 23 Apr 2024 16:40:20 +0530
Message-ID: <20240423111021.1686144-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: nipun.gupta@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|SJ0PR12MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: 7813e818-f7c5-420c-729b-08dc6385fcb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q1fbc7ZhN41cdaR57u+PmYfKOAsLGGp80M/+ZA6NPw5Vq7iUclGuTr2lP8cI?=
 =?us-ascii?Q?05VQlT14eSoA1pAI/suSTeR2ZWx33sL0AMVP4pJiiwiv0WHpyEGa37RL2lnH?=
 =?us-ascii?Q?v6gjfDvAzEKqiiUwTX3cPWyGYht/ak5+B9p9KVAR+TUzYUFKvWNqqSbrpxaH?=
 =?us-ascii?Q?pVXj8r9XPRq5baTxMmKdvv7e4X7pnpLI8RoHY+Wrqwyw6Ou2Lwk6LXmvqu5R?=
 =?us-ascii?Q?ZgJZFpulFv/t5fhEfHYOlsldGyY1ebM5jr+G54l1hcwUGw5ZDkB+q85Tg4mf?=
 =?us-ascii?Q?wIlWNoEKKZ0eP1IlhtP+6/TR9k74tzy73KedykSkHbzCACfE08xHrwBnN+wH?=
 =?us-ascii?Q?svg0Vc7Dr7p9mOusYx/5LBngIu2RMyhf7LObAOUulybpfiz+3aAhkP33rc+0?=
 =?us-ascii?Q?p49Fn4vnz4PmebE1TLZRjHS/YuGGrRN0+j0RwVyNb2pNXgRD61812+FSk7p6?=
 =?us-ascii?Q?Qyc06J/imdVu1u4Akqy6NBdfIwDX67KcF8Q1XY7W0GO6UarP8jrWwP5rf6rz?=
 =?us-ascii?Q?MGSyp/W1iiB6NWTXaoyEnaiNQO716unYeSHOdhTgczeMPf3g4Levi0fAssW5?=
 =?us-ascii?Q?f313pumRqdbx0nX+vMaHbe+M51pZ9ruxvQ5sibRbUQJUspTlMeHnabOWuMeU?=
 =?us-ascii?Q?otpIBdYYU7wJni0uRiVpDUQnDJo6+V6PEMend13BVp2Yuky3wjKfpyLe9i/l?=
 =?us-ascii?Q?em0H8yX3SFZ4BBmKcl4w0Kx1CQEPj9xs9+4lXDKba/oPPeg8WRZGPmNObD6p?=
 =?us-ascii?Q?SKQhTkmOKm13HTQHAVWQC6+0BOV0Cq1+MDPFURF8uwd3hwaMc3IV1njYiR4j?=
 =?us-ascii?Q?tKO9v1z6edFW7WXi4HzSZQA1zD8eFwIUIUOJm1XpTtIqaWLr8NMtnN7bMUTK?=
 =?us-ascii?Q?iQnQkmjLIIwS8pG6+DBWlvof4OYRFhLyttFKI3LR0E5MJYt5rV4Bm7lWBqZo?=
 =?us-ascii?Q?oanH4jiVwXkF3NSkr++yBg2LV4nZCYtByd8i2Cl/8aTzkOcmZlTEPywoCa0L?=
 =?us-ascii?Q?mkytisTTdJ8qlAP7PUCqfhbmdjeNFa1OSkwJL+zUtPfh7diwKs4A5LBWF329?=
 =?us-ascii?Q?3Gvdd+xZdsmABHyLvnGDUI2cdMUUsjxpQD5XWY8eNEvNGkaPBprtnUzsHBQu?=
 =?us-ascii?Q?1tQeha/K2wg4DIQCPPONje4CYb3dMN0AFt3DkfZBwX2zNChq0yPUe+18CrsP?=
 =?us-ascii?Q?jpDwCUPLVicqCQxtmHEWBobbm7EOXwvxm1jDPdb310G6UFm/4U0NVe1PMciA?=
 =?us-ascii?Q?fkSILgVA+9HZSH8MPP/LW6hZpmPk4HnzH5YG+bJbsRLO5gVFAFsIcpPjH4lV?=
 =?us-ascii?Q?AMIpCESEFrv3CgNMa7rmSF1JkJIYhDg7pKVqXXersLck0fLEc6t7lJ1lcDju?=
 =?us-ascii?Q?/s62K6d/+GkoQmnxs1sG05Izd05G?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 11:10:30.0652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7813e818-f7c5-420c-729b-08dc6385fcb2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6879

SI functions for allocation and free can be directly used by
the device drivers without any wrapper provided by bus drivers.
So export these MSI functions.

Also, add a wrapper API to allocate MSIs providing only the 
number of interrupts rather than range for simpler driver usage.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---

No change in v5->v6

Changes in v4->v5:
- updated commit description as per the comments.
- Rebased on 6.9-rc1

Changes in v3->v4:
- No change

Changes in v3: 
- New in this patch series. VFIO-CDX uses the new wrapper API 
  msi_domain_alloc_irqs and exported APIs. (This patch is moved
  from CDX interrupt support to vfio-cdx patch, where these APIs
  are used).

 include/linux/msi.h | 6 ++++++
 kernel/irq/msi.c    | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 84859a9aa091..dc27cf3903d5 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -674,6 +674,12 @@ int platform_device_msi_init_and_alloc_irqs(struct device *dev, unsigned int nve
 void platform_device_msi_free_irqs_all(struct device *dev);
 
 bool msi_device_has_isolated_msi(struct device *dev);
+
+static inline int msi_domain_alloc_irqs(struct device *dev, unsigned int domid, int nirqs)
+{
+	return msi_domain_alloc_irqs_range(dev, domid, 0, nirqs - 1);
+}
+
 #else /* CONFIG_GENERIC_MSI_IRQ */
 static inline bool msi_device_has_isolated_msi(struct device *dev)
 {
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index f90952ebc494..2024f89baea4 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1434,6 +1434,7 @@ int msi_domain_alloc_irqs_range(struct device *dev, unsigned int domid,
 	msi_unlock_descs(dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(msi_domain_alloc_irqs_range);
 
 /**
  * msi_domain_alloc_irqs_all_locked - Allocate all interrupts from a MSI interrupt domain
@@ -1680,6 +1681,7 @@ void msi_domain_free_irqs_range(struct device *dev, unsigned int domid,
 	msi_domain_free_irqs_range_locked(dev, domid, first, last);
 	msi_unlock_descs(dev);
 }
+EXPORT_SYMBOL_GPL(msi_domain_free_irqs_all);
 
 /**
  * msi_domain_free_irqs_all_locked - Free all interrupts from a MSI interrupt domain
-- 
2.34.1


