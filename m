Return-Path: <kvm+bounces-55723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D91FB352CA
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 06:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E79B2067BC
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 04:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09E42E040F;
	Tue, 26 Aug 2025 04:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eVoCehhk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260EF2D322C;
	Tue, 26 Aug 2025 04:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756183155; cv=fail; b=FicPIWRLRGteJWvV4W/pZnDCphH+LJ8Lqo/IVDQ3okE9Xl2DsgUsP2JLpLXWHPzKIRLbTRgGAZSKSgMliYdxDqTtd1ZhxHISkKNNH+jK2UmxCV4Rl1AgyJ6dAQ9nPKpsOR4ECHIXubzAGICEt+2W15DL56Ds14JcpUqZoh0yWSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756183155; c=relaxed/simple;
	bh=vvAjagogF/8N0Fma4npjrHLBmb8sdyB7yzYiNKPiktY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HaFdPCbRcjuWalhtPg/yR+FJwXxOL9llVmLC3ZOxBv9Y+Y1SYvQ/HpqqONAnYUS48uC+t5ilYQU9aIKJaxs0ZeUWhlUcNkeOb60yET/inhpREK9ZLPU1B+HZ9uTACWGOwX7tS5L3W2HmmfGq97jFpuwhUAq7wP3bm/0o47DzSoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eVoCehhk; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=axNXwrlj5fj9rMEPe21P/DugT/0m+2FXrSaxA54nWyP4/Lk9kh0eoec25oQ6xsb2lKZSghGx0+5akZgTo86T9dDrCtPsr8aIqOACw9gWpHjboQd9BWkhRr/ta/P9DTYjIKlSDqUihgD55gkFcLjHYQM9ug+bqPEfxdpgrly0jHw6/229jmP9g9H+jmcdJNTlEguUc1rRsmyq0fgAqpB+p640hA7YLaKE6uGMybqlphxGthRmPPtdt9zbgpimD+axgHzpL7b1MnnYjzFHD+AleLpHgFs0F0KwDZTO0vzWHGHI0EtnE8IsjI8ZOqjHptSyqPERfiJPoE+nYUOSvuS7Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMx4Po+RE/qO+99sEhaQI5XlW92P/IpLTTGplYAYd/4=;
 b=kIq+jY/p66VL2jMSmCqQ0As2c7jjh5CGrV8rXldZtdI6g8xCaEc1BMQEmnzsX3N+SctLCNp71cTbIkU8c7GD9ReWigUNIb0Lz6RWGVHqPmZuls38G9rAVk2TGHSUejXiNOT8n99/Ne2C3fsjTcKzNGTOH3V1CGjhAz3Klk2KS6BMkcF3PbmsjVD6V71D+QkMwgYEEQgMUjGYf3FaF3jPx/oRRrr7Foh0ulKnMZt4wF6enNg0D6qp+Yz1lCwBcPlAr5ZNg6oWuHiQNNVhJoEiEqyRyIPSQKkbi0eZX7O6MzR9FxbZy48oIyBrh+I/gxiKeH4VaypngsT62/xzYH1gaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arndb.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMx4Po+RE/qO+99sEhaQI5XlW92P/IpLTTGplYAYd/4=;
 b=eVoCehhkBXqB1dKM9NrbeOgj4Mortw+7mNl6YmVrMMAdf0FNUR5A1jRbFu3q706+xCRY9w7HCzvvCuzHOr+tQDyAhZqvtQGd5dIP5MX9SGmKMpn+TpTc8o+vUGEl34z6dkcNQhPNHfSKfSiGujLaIvpWoSJ1dqYH7RF7FafXEsI=
Received: from BYAPR06CA0015.namprd06.prod.outlook.com (2603:10b6:a03:d4::28)
 by CY5PR12MB6370.namprd12.prod.outlook.com (2603:10b6:930:20::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Tue, 26 Aug
 2025 04:39:10 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::cb) by BYAPR06CA0015.outlook.office365.com
 (2603:10b6:a03:d4::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.22 via Frontend Transport; Tue,
 26 Aug 2025 04:39:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Tue, 26 Aug 2025 04:39:09 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 23:39:09 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 25 Aug
 2025 21:39:08 -0700
Received: from xhdnipung41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 23:39:03 -0500
From: Nipun Gupta <nipun.gupta@amd.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
	<alex.williamson@redhat.com>, <nikhil.agarwal@amd.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<oe-kbuild-all@lists.linux.dev>, <robin.murphy@arm.com>, <krzk@kernel.org>,
	<tglx@linutronix.de>, <maz@kernel.org>, <linux@weissschuh.net>,
	<chenqiuji666@gmail.com>, <peterz@infradead.org>, <robh@kernel.org>,
	<abhijit.gangurde@amd.com>, <nathan@kernel.org>, Nipun Gupta
	<nipun.gupta@amd.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v4 2/2] vfio/cdx: update driver to build without CONFIG_GENERIC_MSI_IRQ
Date: Tue, 26 Aug 2025 10:08:52 +0530
Message-ID: <20250826043852.2206008-2-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250826043852.2206008-1-nipun.gupta@amd.com>
References: <20250826043852.2206008-1-nipun.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|CY5PR12MB6370:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b0695a8-d6b9-4956-31fd-08dde45a7fd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YQ9GZGB/jQtgOhwRUUPEuzWhYfws9ka+QOkeX+IvWQ23dPK3+ru68iGmHC1G?=
 =?us-ascii?Q?9qVZiRVvRr1SXFXkyAdenBBkhLiDOkLaiRFEsD3tMnrIYNPRt1+ous+pMMXV?=
 =?us-ascii?Q?ljbefMqB8fAlgZNlEjsF9KpAVfCLITVAhoPsG9Mom/RCK9xgKcQtNVw6g2Z2?=
 =?us-ascii?Q?BzeQlDOXzqvZ6iOhjTg480pQD3G8cQxw0lI1uKcFLG+ar9RTpjPEDFBMc85p?=
 =?us-ascii?Q?n2gKtmm35mnbqttGsDh4YELbtgkUTRkA2psaRuWfBWwFOP3/oYSSZ4XJZKHy?=
 =?us-ascii?Q?cgRA5VAu4q4eZuGYC5ISTk/HU6fGiT7WYJ62NahMLMNc2Iwh6rX8HuDe2YZC?=
 =?us-ascii?Q?FFFEBKCo2I7MW5p3BbbBf8YQ4UgTzRwwnocypEZiG21r69v2FNLvlW+t5y8m?=
 =?us-ascii?Q?cLMX8y3r1GzvRshTsdLB273ksaVrnhR3bUB1c1Wzh8tMFs5ckegeznLfG3qt?=
 =?us-ascii?Q?FCLyXRluZ4mR/ZOqd/B+JphVrA5CfLxf+kesZRqBTBBCNP35Vv3XopNZw/1T?=
 =?us-ascii?Q?JzYjVC7j3iF058YShWqmIopkJOOJAAQnt8zm9Z8YBjaVMDXn3sDyJJdeK+NH?=
 =?us-ascii?Q?K9eZpkIbWnGGg6y7dGfsUWjI+IALFinxyqcgISg9EynotOLWvzeI3HEUz15b?=
 =?us-ascii?Q?JhvyTdt9Ao1fczgC09Xkh1b0j22e815TZ7Z+xhVKT3qUEuu5bfew9+L+KMRW?=
 =?us-ascii?Q?AYPsgWruyW1pBbZOQ3EUkpAZglznO6roXy5UD46k2ivDtPL2kvm+qiml7/kg?=
 =?us-ascii?Q?rbfaagTuHSvS5Kg5S/4soFIW9DwK+4x5GKtIyV0Aly6rWh2jG1BkpwO8kkY1?=
 =?us-ascii?Q?axY8tAMT7Ryfr3hUG/qA5d8TVnjKMQgQH0VrblP3E8wx0ckJ6K0ATISmIks4?=
 =?us-ascii?Q?Jm3p++6Urm/0fiwfwk9LdRqhoeAv/dguK07u7kUr6EmXlm4maTTa5eH7btS1?=
 =?us-ascii?Q?q0ljL2CfbisNMcfQU8t2caHmsX6kSnR/phHJFCpOAMy8X4SZmutSj5msJlne?=
 =?us-ascii?Q?VvR1rXwrSlIlg1rY4zQL4l6RD1cozHkjNbHC0YskUNH0hfqgVsDIQfP6F89y?=
 =?us-ascii?Q?AZxrjmVYhtgR/zaBxWDOAc52hRdNn5aetSroPbHQTz0q+7urPo1Pt8VZFTmV?=
 =?us-ascii?Q?FJxOGAFl61/jDRAdEykIRaR97S4SoNSLvdOY5cNGXYtSY67VbHyA1qOnHfzs?=
 =?us-ascii?Q?7RZkZ/2C5bsaq/8kext6N5b2xfERqoinIB2OM+dEWbuIDjzuZjHjW4LzHp91?=
 =?us-ascii?Q?qC+lFqjs+dJyBmDm/zUZuvMqs5zAyo6pJIB5vR90Q+qi7y83pOPc0fcM8oyV?=
 =?us-ascii?Q?jbeq0Ty1qLkK7T1KIDm172FJumO21TOIhJTzjLwXv8Ldd3EqscxRDroVCubQ?=
 =?us-ascii?Q?bLax30QK+cCIL9qgFO8aT6r45Zre3bMyGfB7TisFV1wBHr56pK2tHFqpC3/J?=
 =?us-ascii?Q?kfeASh2VUchdNmvazzVPvzje73Kiv5btRL3sauc4AV70HGD+aNWzlf/IuV4c?=
 =?us-ascii?Q?OAtJ29RUqF/BLH0jg7SxcBNrJ+Eze6bCJT7u?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 04:39:09.7925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0695a8-d6b9-4956-31fd-08dde45a7fd4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6370

Define dummy MSI related APIs in VFIO CDX driver to build the
driver without enabling CONFIG_GENERIC_MSI_IRQ flag.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508070308.opy5dIFX-lkp@intel.com/
Reviewed-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---

Changes v1->v2:
- fix linking intr.c file in Makefile
Changes v2->v3:
- return error from vfio_cdx_set_irqs_ioctl() when CONFIG_GENERIC_MSI_IRQ
  is disabled
Changes v3->v4:
- changed the return value to -EINVAL from -ENODEV

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
+	return -EINVAL;
+}
+
+static void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
+{
+}
+#endif
 
 #endif /* VFIO_CDX_PRIVATE_H */
-- 
2.34.1


