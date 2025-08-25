Return-Path: <kvm+bounces-55591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 836D7B33510
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 06:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6006D189C833
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 04:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF692550D8;
	Mon, 25 Aug 2025 04:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Bg35a/3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582011D5CF2;
	Mon, 25 Aug 2025 04:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756096328; cv=fail; b=gD29y3PILllVC4wB7gianPejq/4Rxw6DXIaL5N2I58lYAM+x+wd74Q9rAK4dLzGAT7ojyUoLXD7rjBnInHOARyTCWgAsrbmVNWHwDLkA6syeipGYDYOm4sWb8tvduLAqReBzsga5iq5NxQcq4XNikkJ8q7P/Yl1+RAvJkY4FT6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756096328; c=relaxed/simple;
	bh=TOCuV7zGG2TN6r5pBkree5UQjsYBQnE9iTg2fUzmYAg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dmHNo9pRcMQgQWKk5+1a6hXm4w8Id18Cr/yKci2MzwYaW/UFdKJ4RVjCnwU6OCgk3tL/llCFSBlDC+oUdPkcaxjcsSpI2YtCO5bXL7qMlbzeta6IFHw+MLhvuHjt7g+AmJsRkO5KL8ssdc3BifuVjXUiJIeBYQ+1Ag5LzjiNRUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Bg35a/3; arc=fail smtp.client-ip=40.107.236.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JFLz/jdeX2L022f3AoPfBUaBOan1hZHujeeyVtOqkRsCm61yYQMsRflJBsKry4BYqe3Ox7YHjXZ1rlnTe6bTfeaNkZObXT1r21QQXHpQ7sYxdILZXQX+/zBEyZyNyZJDuOjA3z9bznbjsYtehg8Jz+R4m1AI6Jp/5tT9Q863rnhNLYLbrv9WdN1Q7erq9V/YS6aXKGXzBqyDv+uBcD12MQmePWmth/067afh3m2yIZcAfOK98N1JdIICa3KmZBknNOCT+kzWA1XelWHB55SF3vnhGO7tshXLSCodyYyxehshGwtLaNxuY4CDLG8YQqa8mW2iGoI4rAy8c6dTlBk+aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4YqbUcTEEyqJIzQedxGCI6uSimngAWUROAgllw8udI=;
 b=DOXi0ByODgN6N5F0ff77Z9Vmu+Yc1zrBWWqmFyKbXuP7/RxvKq+4YdMo71x3aAS+WHDkmoHKdUFgjcBhMbsl3NBUDhPpmUfIo3hrmt4dgLP9oQCkWReJZfndWamOaOmRmxjM/7lOf7134j24dLQx0VYrh9opBq3vMSGmo1DXs9By6Oe//1UYKMwLVu1dpBwd5sWFsPojrnRF/u1YCjrwIEOBhqWaOuOAcNy9W8BkBcmENNn54LoHfNmDdtl7KeGSkEfxybIO6ngXOtqdd7b5w3jo7YJsxkUVVkQUJNQNm9hRGNdIihXtVk4+FOECW3Dziw2KzpqilUvvCJ5X/jl/2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arndb.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4YqbUcTEEyqJIzQedxGCI6uSimngAWUROAgllw8udI=;
 b=4Bg35a/3B49oH+NK/vGVbo51fHfmHusKO8rkHABqXIu6KXiHitk/dNZOdA2NqL9izqHtE33mripJXeVZnDFAKINW512U2SyRSS6VzSgMRLBXpdZSykF4LMfuCXL4DLb24eSNiSsm0toIa/1nXl/LKzEU/JEVl+76N2ryH60YtU8=
Received: from SA9PR13CA0112.namprd13.prod.outlook.com (2603:10b6:806:24::27)
 by IA0PPF7646FEBB5.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Mon, 25 Aug
 2025 04:32:02 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:806:24:cafe::16) by SA9PR13CA0112.outlook.office365.com
 (2603:10b6:806:24::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Mon,
 25 Aug 2025 04:32:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 04:32:02 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 24 Aug
 2025 23:31:41 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 24 Aug
 2025 21:31:40 -0700
Received: from xhdnipung41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 24 Aug 2025 23:31:35 -0500
From: Nipun Gupta <nipun.gupta@amd.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
	<alex.williamson@redhat.com>, <nikhil.agarwal@amd.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<oe-kbuild-all@lists.linux.dev>, <robin.murphy@arm.com>, <krzk@kernel.org>,
	<tglx@linutronix.de>, <maz@kernel.org>, <linux@weissschuh.net>,
	<chenqiuji666@gmail.com>, <peterz@infradead.org>, <robh@kernel.org>,
	<abhijit.gangurde@amd.com>, <nathan@kernel.org>, Nipun Gupta
	<nipun.gupta@amd.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v3 2/2] vfio/cdx: update driver to build without CONFIG_GENERIC_MSI_IRQ
Date: Mon, 25 Aug 2025 10:01:22 +0530
Message-ID: <20250825043122.2126859-2-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250825043122.2126859-1-nipun.gupta@amd.com>
References: <20250825043122.2126859-1-nipun.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|IA0PPF7646FEBB5:EE_
X-MS-Office365-Filtering-Correlation-Id: 00ca8b1b-368f-4d29-3cf7-08dde39056b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KUMJcNc+dTVZEt1hxB6NZ9OS6vAG4wR6ryCRAdky5wrto3N1Z9by7vLcjcSU?=
 =?us-ascii?Q?O7ss3xMPTsncdr9uU4WoHtACvTZs6zis67r13at/EXJ6k4CpfTS3ZRDg4994?=
 =?us-ascii?Q?TP4qH5MEnnotAOep0T4uTkzGiBi1DMcoJqfRSgp4FJia0dWKqLpNYmguvgLF?=
 =?us-ascii?Q?2ZFfZIqn9c5fpew9+9K1J0oGzXU4URrHrFHhuCYI4UZJz1sae8b3UNScGNg9?=
 =?us-ascii?Q?Jvc1AvhGptjF4n78h1sD3oXf6NYE1ondlEoo0F7SZuUHw67hvEUtpW1TrKYt?=
 =?us-ascii?Q?wbbDRa2RC0nP0Uqi8IDHi3O3mQGfsfzosxP04ogAOEjx8Vudt9RoKdhmhmZU?=
 =?us-ascii?Q?yD0ivL0hWx6Nv4hOb89ot87hAU7YboHPC3aqa7VTGLfODDn0dgQWwBmBY48x?=
 =?us-ascii?Q?e0v7OcDeUua4F6Agj8bzlUhGKr3idGRt/hU2GCtERg2Tk55sAGYAfZ5EusDG?=
 =?us-ascii?Q?xa6x5/uDdcM79VwBYBQUOlNXuMbnEDxjX6oeIbWSsI1zAjy7NZGvWm7BqPef?=
 =?us-ascii?Q?osFEhW+EZO9id1x7/fH/7a0/j1JE0W48iH1IvlWCDQB1AqLVuahHnKrdGrpr?=
 =?us-ascii?Q?VNpt+3UMddRS48idZ7YmAC3hVkSZl+vVryxq6NsBFRpNrX1oTZjHTO11cNbP?=
 =?us-ascii?Q?BWPNEysMeEwp1HBZYZwBqcIMYi5js52ex22ncHlkPc92tSsAsAIO1RACjYyA?=
 =?us-ascii?Q?+amHcPR/dWnmaDwPE0mpp+arfIXLo3vJZpZM3uwth1lWcf2Cg65qrk9aBg69?=
 =?us-ascii?Q?4Prz4QxkmNuzIMfSf/HGz1kqtnt2Gck+MH4vxxwQvX6qaTQ39HdtzmjjRfmT?=
 =?us-ascii?Q?fpzFcI02m1PUWuexhLnXGSu1G4uZjH0/0/kV3aX8pmwBApIf2HyC44MJQgxm?=
 =?us-ascii?Q?6pjfCgPvwd+CtliHdX5ZXL6RotuBQsZCe/7o9ohE00ewI0zrvqS6R7+wnrmz?=
 =?us-ascii?Q?A6wNeY5EEw8De7KHky7xhDhLul1/JjLgfDyd128xrseH6wVbYozhwavqUqbd?=
 =?us-ascii?Q?im5pSHYThP3wFkgZg9Z0cEnbTb/DVH0avUP3blRAxmTbkF7psyDe0bNRGWA+?=
 =?us-ascii?Q?dOlE7hHFJ0tQNgvvHkK2ViWFogz5S8l5q/4HTOnnpTgFTMZOHuxaJpq5WWZd?=
 =?us-ascii?Q?bGTx15zS0/fosQMzWENVQlxFL9C+snUrOgqVrdhT4xGyz1emrjV4f/Jlxud4?=
 =?us-ascii?Q?ucc0jBotYLhsnXPU9BVLRJy6eMR41H4b5F9XdD4iD6zCi/fI/kKD0SDdYgLH?=
 =?us-ascii?Q?qyNFQg6rf3YoHeSb9PfUpVWQdF0IuBwXvxqFVd4XAP2Lvw2WStigo+T9Zygi?=
 =?us-ascii?Q?mPdiOeQpQ/9ESpWdrhvUwYJNlHE7XuRSdKYctTRViVOFq7sdJvAcEAapEnDL?=
 =?us-ascii?Q?vQH06r3r4PmzSGs5LLl/sivVrOjXEXRtPqH7Z8klIl0R041qB1EvBfLgWcxQ?=
 =?us-ascii?Q?MevAXDv+JvKU5Gw8ngKTLqK198v1WUHr8isa6yEd9PU0lnykkyEssafucIYZ?=
 =?us-ascii?Q?5xoOlmR8kUZfJP6R0JbBZajromMHcAZ2TSzBXLb1ZcDwT2fwyecIjpdUow?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 04:32:02.5014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ca8b1b-368f-4d29-3cf7-08dde39056b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF7646FEBB5

Define dummy MSI related APIs in VFIO CDX driver to build the
driver without enabling CONFIG_GENERIC_MSI_IRQ flag.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508070308.opy5dIFX-lkp@intel.com/
Reviewed-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---

Changes v1->v2:
- fix linking intr.c file in Makefile
Changes v2->v3:
- return error from vfio_cdx_set_irqs_ioctl() when CONFIG_GENERIC_MSI_IRQ
  is disabled

 drivers/vfio/cdx/Makefile  |  6 +++++-
 drivers/vfio/cdx/private.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
index df92b320122a..dadbef2419ea 100644
--- a/drivers/vfio/cdx/Makefile
+++ b/drivers/vfio/cdx/Makefile
@@ -5,4 +5,8 @@
 
 obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
 
-vfio-cdx-objs := main.o intr.o
+vfio-cdx-objs := main.o
+
+ifdef CONFIG_GENERIC_MSI_IRQ
+vfio-cdx-objs += intr.o
+endif
diff --git a/drivers/vfio/cdx/private.h b/drivers/vfio/cdx/private.h
index dc56729b3114..5343eb61bec4 100644
--- a/drivers/vfio/cdx/private.h
+++ b/drivers/vfio/cdx/private.h
@@ -38,11 +38,25 @@ struct vfio_cdx_device {
 	u8			config_msi;
 };
 
+#ifdef CONFIG_GENERIC_MSI_IRQ
 int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
 			    u32 flags, unsigned int index,
 			    unsigned int start, unsigned int count,
 			    void *data);
 
 void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev);
+#else
+static int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
+				   u32 flags, unsigned int index,
+				   unsigned int start, unsigned int count,
+				   void *data)
+{
+	return -ENODEV;
+}
+
+static void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
+{
+}
+#endif
 
 #endif /* VFIO_CDX_PRIVATE_H */
-- 
2.34.1


