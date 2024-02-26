Return-Path: <kvm+bounces-9772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 315EC866E69
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B0671C24010
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C4A5F852;
	Mon, 26 Feb 2024 08:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a/E3n8eo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945CD5F85B;
	Mon, 26 Feb 2024 08:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708937309; cv=fail; b=QLFw7HigesG1YjyljOMUAdQM8s74Fi4Lpr0P/eEdcqoXJHtEwX9wGdfryz8NIefV15yLGQ4UgKhgEWGdHi5aj7CwZK6Cqt0T0w5B7QugSK6VkXghpMKoCDQAuEIwVYlnoKgiV+tUZ/BTurR/Ok+PO3zFUpCxMLBvq8v9M4pr05I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708937309; c=relaxed/simple;
	bh=ALwljT275X1oocuxixKkMr/CVnh5dDI8AARiZM459uk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YY3C/+WziJ1RStN+jzxbsvXDjInVj0BWbSYV4BWbkHNJD5nwYImoWacrErIEffqmkCKK+SfTMD3NXkrjqjhn9PNm3OtK8IbPjKDs+Xcs4OQwS056I5ZNXd9lHah61OXLmHFn8VBZ+XY3AvxTk+mDO+M37iI5YLW1sxp7MRETV64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a/E3n8eo; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjY/Ps5WZdAxF3seaZiv9asoDchNllx1zWaxL2fPW7TrFTLWSNQNL1Wi35m5jw/pe/LZ+09Y1jawFGlUyoUoCWEfU1PsZsq/9Xm8E8lWNta1Owg2MNRnHKfgLmmNaU/ADeOeliNTVkUdwBkxFH2Us8zEHlp8z0lP18Xc1yrnAAlEVbaZhXRQqTBjO4nbqe5D8NrJ3LgRuuEg8W8NdOfCjx9WwM8oa4MbWB3spuW4j7ZzuoRX4ZvZpzsdZ4Lcm4KmNpN+RVsc0xbsFGXF0Fo37dq9wOud9bTJBTnl3Sw8rjpMrBvvTKIKiUSYiCjflHPDgSdn6Y5JsWrG6zFASnQ1Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QT/p6S8B9O86DPpl4PbzwGQ4v4HXY0ioufqlPH65s54=;
 b=P84owdVbSaofftccNQOBIDrHse0uYJYsyKKoA/JA4MIqiIbBbyOj3MaoyvxhdbgJF/tbKazu58cDCUCTrNYtIAOY0BQFrhF4fIyc2DOQvO+aWpULmMWLe7CMs/SFKYACe5Vy4rZrFydmQy8A5OwVnaRqkpKbfHFe+rfeOK9L+wD+0SY5aRKyYhwcwzrDNUXyqlO6m6r0r0hGEi5osXQ76dMqUogUFy4bezpqRQvNhVKfovvDBuuGWitMMJ6BUwhr8+iUjzIamC0ZMeYZI79cHqrdA9Ldl02VlfqmV1g2PvB/7RKNVaJI1GtU1CdMnaW/NSvgmSTkqM3SQvGpzrHjyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QT/p6S8B9O86DPpl4PbzwGQ4v4HXY0ioufqlPH65s54=;
 b=a/E3n8eoFEZZuTScc+scbhorEj929OgXmL6WYn3o5YludnWllbW1eIBxy+OCCcNxzygYSfPLkn5vJjdZNdc5BnJy5y71taJilYbw/jFH8alweuYSZTYmJaXB3bsog2Hr7TjUyB1kzZV4zY4MVwXgwReWNMbB3dGNI7eqri5ymi0=
Received: from DS7PR03CA0016.namprd03.prod.outlook.com (2603:10b6:5:3b8::21)
 by SJ2PR12MB7961.namprd12.prod.outlook.com (2603:10b6:a03:4c0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 08:48:25 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:5:3b8:cafe::b4) by DS7PR03CA0016.outlook.office365.com
 (2603:10b6:5:3b8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 08:48:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 08:48:24 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 02:48:23 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 00:48:23 -0800
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Mon, 26 Feb 2024 02:48:19 -0600
From: Nipun Gupta <nipun.gupta@amd.com>
To: <alex.williamson@redhat.com>, <tglx@linutronix.de>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <maz@kernel.org>, <git@amd.com>, <harpreet.anand@amd.com>,
	<pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
	<michal.simek@amd.com>, <abhijit.gangurde@amd.com>, <srivatsa@csail.mit.edu>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v3 1/2] genirq/msi: add wrapper msi allocation API and export msi functions
Date: Mon, 26 Feb 2024 14:18:12 +0530
Message-ID: <20240226084813.101432-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|SJ2PR12MB7961:EE_
X-MS-Office365-Filtering-Correlation-Id: dcc006a5-5f7a-4303-7a76-08dc36a7b190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Eyg5+OQLU1gBD3foB+iuZMNTXbVWreVmayNF+A20MznMTPi0wBNOzuTb6knS5NfLIVGXxMZZk0viNYGdPIKMmFVuBL7L+zlWwTozcRJBWXaw0vh1vsnuIPRMV2A1e3KY3iQiSHPkWGdEsriq642QPu+7OQLoNPlgdGMn7qcZG1WW1G8IVW2c4u60wjdzklsEVOL3M88EHFbSXpa632LfZa5QSB5obNmOnglITDv9VaoPxkI9OOuSHc7zJb/Zn69140d4tPEzZhVkvaFIf5kFwD+eDVEYHIg3g2zaxfSAFIVFjNgJ5UKePPrvAliXPkTtZiyncCiF+Rwls7jelzEZanSgK194ysrIA7CbVTCk9s8CU6BsO/9iJyZ+7vu1tl35gIl+gLrGQSyWptvPSs//5MXzEXxnuMKxFpKqrZ0P/gzkihQjTnchFULovvQgfQ09HtiJkbSijhQDb04bzeZVtdD8AdcNaRY5JkMjkBwMfOk95hOhVbvlTevg+ADIDljoi2RW+DrvNOp0wgWMBLrqXNoMU6tV2/RrnSR3e4qjjG1ONWSQ1QEGZ1dD81zGrtGn8FT4CHWUt5GmA3iI6+hdcR6Lr+DQ86uKBbHTc5pDGutaN3jroI01BBANZcPt0GtnMHPzwsLugFxTh5MezgHsy1jenhCrse+uwXzTBbWsuv1IwC4FVj2jCu1KWrssp9sNJHsDH0f4gajlhJz+hLIFt/y6Lh3Ni9hqi0wXoG9x374sS294+MrGctlvO83/dLLw
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 08:48:24.5148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc006a5-5f7a-4303-7a76-08dc36a7b190
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7961

MSI functions can be for allocation and free can be directly
used by the device drivers without any wrapper provided by
bus drivers. So export these MSI functions.

Also, add a wrapper API to allocate MSIs providing only the
number of IRQ's rather than range for simpler driver usage.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---

Changes in v3:
- New in this patch series. VFIO-CDX uses the new wrapper API
  msi_domain_alloc_irqs and exported APIs. (This patch is moved
  from CDX interrupt support to vfio-cdx patch, where these APIs
  are used).

 include/linux/msi.h | 6 ++++++
 kernel/irq/msi.c    | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index ddace8c34dcf..a9f77cbc8847 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -658,6 +658,12 @@ void platform_msi_device_domain_free(struct irq_domain *domain, unsigned int vir
 void *platform_msi_get_host_data(struct irq_domain *domain);
 
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
index 79b4a58ba9c3..4a324f683858 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1404,6 +1404,7 @@ int msi_domain_alloc_irqs_range(struct device *dev, unsigned int domid,
 	msi_unlock_descs(dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(msi_domain_alloc_irqs_range);
 
 /**
  * msi_domain_alloc_irqs_all_locked - Allocate all interrupts from a MSI interrupt domain
@@ -1596,6 +1597,7 @@ void msi_domain_free_irqs_range(struct device *dev, unsigned int domid,
 	msi_domain_free_irqs_range_locked(dev, domid, first, last);
 	msi_unlock_descs(dev);
 }
+EXPORT_SYMBOL_GPL(msi_domain_free_irqs_all);
 
 /**
  * msi_domain_free_irqs_all_locked - Free all interrupts from a MSI interrupt domain
-- 
2.34.1


