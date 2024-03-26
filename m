Return-Path: <kvm+bounces-12650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA44B88B944
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 05:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49B0C1F3C81D
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 04:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AE112A17D;
	Tue, 26 Mar 2024 04:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0RhkwUC9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731141292FD;
	Tue, 26 Mar 2024 04:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711426116; cv=fail; b=OUGj9bQ13ODTRLtyseVAwKx3CBEcI+S0wIG0Xk3wk4xwkMzUAhENhB00JjJGrcSVPOBKUGnMw48M2uWh3kO8ACH2rwLcpwuTWx3AJlDONM5bu3whXax5JlWQj7Kd64OKmvF3d48ipqehFR1OX/SMQsWpgDAzwvc7sgDeB6nugiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711426116; c=relaxed/simple;
	bh=3MfbvHfZMvHx2cdIOJF5L5eMAFPXcXs5Te+ZUwM7kAI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JTckWRdhuSgYz/Qf8rfDJMseeeIC0jyLdgF5+NtmxO+dZSN5yQypd2tvw2lX/07xlYJNygGgX0QnfWMXgZd29QMbPaPVLf5OVWdHrJBP01eJ9m6K8+Hhz0aVKxwlLKZQsZGYo0W/clJSgTo/bxJKMxHckWua0/lP0jMz1infaak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0RhkwUC9; arc=fail smtp.client-ip=40.107.100.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzshYhdsjt9wrnAlONh3s+qWELBmCNCocvkSXSFNZ9YQyQ6HvIhX36wGl7+O/1smsxaIZ5Ggip7JTssfudXm4Jn+mj3AM5n+dYb4WVaICO4uPMxy5u6s/kUbAK/oA+BRWoYBUN5VqliqqPbH3MUUnxCVeJ2/tFaCCIpVQ1IMLGwo2Q/J7Gy0KGH5qkXdmo7kuHcYN0aR1GEXSxscEcCWup6WqHuKCQrf+4s0fMIJErz2x8r1PI6SSpYYcPiOOSMIH1etBj0ogfe3Htv8t/nxGzcW647yIR/EJkPYVnCI78jWhzHK6Y4EAGMQkpCsOkonGQ5GqpNJ7lECrBwyOULb1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhZgpX5T3qGDr28ATiTErkgqzVOC1njc+qjZoXkQSD0=;
 b=iPWVQOgwsxunvMQeSb+z7abLZyXc/f6vZwuwc0ixkK3/pyKwQXtguMo9gOIoVkaBZmPxgTdr0FuWIKDFpCkEClILO90FQhB9rfeAN1wuaY4l6O9TpL1zMo+yO/qfb5QM6RAsQyeH2mA+5IK1//A1SciH9GquDqjyNmsepF/bDtBfapk5SFP+3ZsxNEu3lmsMuxsVuR/xoVIqF+IXoyWDDFyZpYETogFGS55AwDjfn2C/Gj0vZQgRE4M1z4SHFQTMUVdcvn4W9oASvrkY0KCS30kjGLj166mCywCIwVDVHCrOgN0b/g03fbnbKEmvPi4/dH6pyKN8kHM92+RYaMCcwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhZgpX5T3qGDr28ATiTErkgqzVOC1njc+qjZoXkQSD0=;
 b=0RhkwUC9twUW0xQf7a6oxOuypORWYLz9giy05jrjTHTRSobz9wueTV/q0od056cxUWtzc71fBZ5cxlDRR2e0f6twg1qXMaI4ptYGxWCqznR2HA+Oxm+bBZxECvUX1haaioombcdOwz9ILplTnK/oKMaonq6RgSjrn3KxoVjMm6s=
Received: from PH8PR05CA0003.namprd05.prod.outlook.com (2603:10b6:510:2cc::24)
 by CH3PR12MB7641.namprd12.prod.outlook.com (2603:10b6:610:150::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 04:08:29 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:510:2cc:cafe::a8) by PH8PR05CA0003.outlook.office365.com
 (2603:10b6:510:2cc::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Tue, 26 Mar 2024 04:08:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 26 Mar 2024 04:08:28 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 25 Mar
 2024 23:08:13 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 25 Mar
 2024 23:08:13 -0500
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Mon, 25 Mar 2024 23:08:09 -0500
From: Nipun Gupta <nipun.gupta@amd.com>
To: <alex.williamson@redhat.com>, <tglx@linutronix.de>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <maz@kernel.org>, <git@amd.com>, <harpreet.anand@amd.com>,
	<pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
	<michal.simek@amd.com>, <abhijit.gangurde@amd.com>, <srivatsa@csail.mit.edu>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v5 1/2] genirq/msi: add wrapper msi allocation API and export msi functions
Date: Tue, 26 Mar 2024 09:38:03 +0530
Message-ID: <20240326040804.640860-1-nipun.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: aa0cf3aa-744e-4087-4091-08dc4d4a6458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wRO26eC1883RoWUWIfYhLLH7qhOdhXKP0UTaPDi/yOu+uUUVxIz0A9apcCHgmL70Jmj2TeAVMGeeRJpOV/D3EqcYC07c8q2KRL2ywU+hN4g7YAPftvkkDsRHNl4vnSGB/+ZfK13RQQ2QuGII7q7jS2sz5SIYWAU3Ipi+JVv7vwy0Fx/i3VV+BBuG+3OHXjFHBAqKUasdoC5As9Qn14zPleSZmBy1i10ohId1IcUOtAJTRASF/em559sbKwt9N9go7nkI2P2loBV8cPzrrn7WkhRAVpB1VVcNfscuuQBjQkHWCGtw+/0irOVPxu2bqYSH4ecGpSzJELCNfQKBDaO2DR9LaAeF1KgaNZZARM+Hf7iNTV5jc11KlGWctFDpich0zriEsSlljZdlsgzLMYQSRGxj1NcDnYjYCIOIY7sPRCUvz/tb4FpjGC6HCDaxO5xbelHF86kivXbEptvKPJA/TAZ8o1UNyhAgGbYM8scNrgu1j0jMh8HzS4LTrEPIMmyignj4bwEr9/hsckn6mwYcdSIz/VsMV5gYeNd81QqSVo32e2L5AUA2LqLWxzKn2BvjMstu/6WETNgiZgn7wWgpXgbt7uRorjDVVAce6j18LpJ67mZ+0IIeIzhb9E4ZXy8+n/8wKUX5g3e+0Mt+gGshuoT/fTlaAN8Ty8dRWiN71UeGOswdcL6gSO1/rZ7lF+4NQNj0BzgEnI1HcZv7NdXqiSSePdgyL0e3NIrfC9knF+iZO+uTRxhttZw6+t9B0gqh
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 04:08:28.4473
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0cf3aa-744e-4087-4091-08dc4d4a6458
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

MSI functions for allocation and free can be directly used by
the device drivers without any wrapper provided by bus drivers.
So export these MSI functions.

Also, add a wrapper API to allocate MSIs providing only the
number of interrupts rather than range for simpler driver usage.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---

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
index 26d07e23052e..765a65581a66 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -676,6 +676,12 @@ int platform_device_msi_init_and_alloc_irqs(struct device *dev, unsigned int nve
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


