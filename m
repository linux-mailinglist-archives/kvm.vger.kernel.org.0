Return-Path: <kvm+bounces-10864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 518F98714BF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 05:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D26361F21B09
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 04:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7591E45BF6;
	Tue,  5 Mar 2024 04:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i/MUe9OH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62CC44361;
	Tue,  5 Mar 2024 04:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709613053; cv=fail; b=kYjJxS3Ont2dleikjAFtk3NJYrEw3HT/0uGQnIO2mwkU0ik8hregvPN+RYmjQ2/Y7rYAV3eBTra6FQmCPwjrsYMTC36BDh/8jawCsm/FhotW5WwI2d27HNxCpNt1LiqibTdQjguIys+fzh0MrSMCQv6zviLC4DCnMvZelBqA9gU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709613053; c=relaxed/simple;
	bh=WtQSmFuetJjpO7srKjXzwUdQNO3vRPMreayAYGRbr4o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AfvitFFlSewNfs/QwaTbs0Ws+1xqP7E9m6tKl3VMrNOBAf69SRNylzrP5Fc4nzN5Kohp3g5yLEofvdl/xDsesRTujV/7bT1U3jcNrbGutB8fAJq9RY7ftY8Gnm4Utw8AlEVIsaP79Oh8gUJ8b9dErQffYL8jGWDLxeWW6CanLts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i/MUe9OH; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxuDrH4vH6oH8x4mXLWp1RvIZd+ngsSj388ofrr67r2BWDFhR7Bgi6sAvnAzTPMkfY4HeA3XapFMOu6F5JTtZGI2eM5e/DlsB0CnGYWJFDAuNKG2PUb94Z6ReZ7pFL4tXsEqWgk1ebj2fHCvLr7tWHWnytnYhOwdZtSmZAFFQ5nA5wg7lMc2SdqP42Qazdnj/Vurq5EVpZd91BFJljyaaadpDSOWHIm4kixUSm+ZvYhb8tj7LRjr9rvfYo1W64g8cEWdLCIhJc8z5+NOg5qcTU22w00L7OHyknHyf15Yo9PYRFYWOXwgGE0uZsY2G3n+CpfDYqdoALzY8clyuwYnlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wk40rfQiLdRtwADoGeZi3X/SHJB2YDD7lowroH1yu1Y=;
 b=hPsC3MSd+k4FLG0BCJmFlVhkxPqr32o4Sc8GrUynBxPOdcG3KvTCMG2v3XK2hHSARk7oArBKXgs928pNgadR1wxicok1znM0ftsh2WWs/4gLuKMrqL7JF+lNk0l3cWOpbRBWkYp+hIL6agScxwmzTN6czDjjFyz8SjhiOGEO16/ZriW6VcUg/z1cMMogN47NstXuHWIltSZVB+we1k4QguGwJH4brlNpL2FNtmmAwduXiq0wT2n2wMjJgJuFsVoW7/4XBa3iGQooyuVGPTbWSNGnxyPVsyjcj9zQMND7P/A5cDwn/ZKb8keb3bIdlu89ICSr+VJokwhJrX/cjN0cxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wk40rfQiLdRtwADoGeZi3X/SHJB2YDD7lowroH1yu1Y=;
 b=i/MUe9OHVJXQaJj1aJM9C8yC51xFTgug5CxT1/qFBSZQKzwLe31kfog2Due7Emfnliz8OF23qGyk9J45wrMGpOjkM7QVGCyXsQO4W7BXmsipYvOEetUKXBVasi6feKk4lRfqUv1D+GWCaaRR91tJvUPsvsX2jwEN8hVBdLrI9tw=
Received: from BN0PR02CA0031.namprd02.prod.outlook.com (2603:10b6:408:e5::6)
 by SA1PR12MB7198.namprd12.prod.outlook.com (2603:10b6:806:2bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Tue, 5 Mar
 2024 04:30:49 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com (2603:10b6:408:e5::4)
 by BN0PR02CA0031.outlook.office365.com (2603:10b6:408:e5::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39 via Frontend Transport; Tue, 5 Mar 2024 04:30:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7362.11 via Frontend Transport; Tue, 5 Mar 2024 04:30:49 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 4 Mar
 2024 22:30:48 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 4 Mar
 2024 22:30:48 -0600
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Mon, 4 Mar 2024 22:30:44 -0600
From: Nipun Gupta <nipun.gupta@amd.com>
To: <alex.williamson@redhat.com>, <tglx@linutronix.de>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <maz@kernel.org>, <git@amd.com>, <harpreet.anand@amd.com>,
	<pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
	<michal.simek@amd.com>, <abhijit.gangurde@amd.com>, <srivatsa@csail.mit.edu>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v4 1/2] genirq/msi: add wrapper msi allocation API and export msi functions
Date: Tue, 5 Mar 2024 10:00:39 +0530
Message-ID: <20240305043040.224127-1-nipun.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|SA1PR12MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: b19e608d-73c5-4112-b0d6-08dc3ccd08ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TamSvcE74Ui6h5kdWF/sMl8JoHAjCcBgQpf5guOkKmYB8gnEPoHpEeYYV/I9V9mt3nkJPPMiXFq4oqiickUG0NsL7hr/7nG+1co9Qsi/yTqhZY5bUbxv5uDXEvR7p8czChYGLhnBp0VgHZwZeN9VRk8u02goatBrsq93TXfOeFNF0yR1vZfRrYNvdWtCg/LzuXt4uh5q3al1pUbNleBF93+8RylrmoH9CFjyRuYaDwUCH/fuznC6VC8LvGeWHvwa7c+tXF3Zs9j7iCicFbBZ/uTPHHmg2H/UDbrQZ1YtXx8uU5VFgeOxWAqZEBX7jv/5RHQ6v1M9VkUtQV2harYUorNjv10Jg0SKOw7Qlu1dIn4TDII8e0SWTwpnY9JQn3diGlUtD2l2MLVk9tt76WmyYff2HGdlNn5/RIlGedH0FLFTwLw2unMUYBuhY9VlO6xvYAK/DZnBdVcIf9vM3p98iOFRCT+d0RHojUGRcYIaSsZ5eZqW0KSpnY6wSr2Tl9fJkohK7aq50LQU5Q92UkUuCHaLZYjz8gPb7I0DM7tozt7vQMTVNp2ppyZYQtOPk88RwSAgujK83N5FuFdhkQm98+/OdB4AV+LafIHXs0G0Fm08zLLBqHC9GrvleIJN0eCHnFIfYiwaelHu65Hi59Y2IMce0N4Sv+XZdoq5ndkWdxC/j40pza6Bkh8T8KccgKFrypexTFaT3sdXDUfuBpkmgU64wRMX41u/WVdqwKtnyq9gr/mx/EqftkhA6dGd9xWF
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 04:30:49.0796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b19e608d-73c5-4112-b0d6-08dc3ccd08ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7198

MSI functions can be for allocation and free can be directly
used by the device drivers without any wrapper provided by
bus drivers. So export these MSI functions.

Also, add a wrapper API to allocate MSIs providing only the
number of IRQ's rather than range for simpler driver usage.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---

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


