Return-Path: <kvm+bounces-71476-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEPPJJl4nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71476-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:56:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 919C61792A9
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 66D273005307
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800783054EC;
	Mon, 23 Feb 2026 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D9lxcf8/"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6311A2EDD7D;
	Mon, 23 Feb 2026 15:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862137; cv=fail; b=oduGI3o6nxYzxK9rGm3cW1wn86v6Hj3OVeQTZIlB/VdXXKozfZM0oVD7F3GlqvTwn26Mqhh58U6uhiJhBQlZpHi1AOYhQln7MtPYafgGL1eF8Iczd834rGo6D+Zs04xcjxfmYEOD5DbEWC3qH8k1R9I2GjxuB9uLQEw/Me7xnFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862137; c=relaxed/simple;
	bh=QjwWbBzDV0jfkjPkTHLvn6f6lLy2egMzHRkJmWO+qnE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d3H9JokP55Rjwl3/1C8AfBMEw2pnhrblN+nGG45LIb6s68BGFp1duaQ2gSyzHuNRHWb40fmpK1y94ftCC25x6iu3KEDqomAql94Kacldl+RGMGjlePL5wxBfAsbJs36KklDofReMLeBlBPycs1RXcPiEKdKWRwJOgWzwvzS2cyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D9lxcf8/; arc=fail smtp.client-ip=52.101.61.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ujtj5G6Y3iUb3KetNXtfItehcA7EThwNOlw3PRaQSDh0OmmDF7+EqgtDYRzSOXTLqC3UsXdCN0xbXKUUzBiNko6ly0LR/khEvLVhoHaJmDiGJUF9saNBPBfpCIh79pXOuw/3beBPBe8IJIVsx3GJvzMt4kLNqi6bgU8ttcCAIDIGAurUBfcoGlh7Czb3K+NBsU2tGclsKvKIIzHd5IXtonPgTg35ld0co7ZO/kEYFb+a5k9AKd3FZBHwP79FMsRtlzfEeJ3nNSls+cc9UeG7Vn9Cqc3fcT8SmG2jqUJDYoXgCsavtJekRPSHP8W4RTEFk7W3TLhuv1FmltxAN6GXWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvsmo3F4hPWSLCxKrNqc6n4M99BGnkzxCoeujR3MgRc=;
 b=TYSDVHCdUMRNH18zzNb0ahVDHurH/7133DUllWZdXwDYLx32/kHlEbxEt0M4+dpB+kkvHA6wXQNOzhDPKqt327PHHWJR2kIcaIQ3y3KauLWs22UNEbskOucU1Z5OzRoUaUqsvBAeAtMNoH6XAYB7Oj5Om68g7nGIKaXodevII/tNIrrIFBynDiUJWEaAACUR5zyXRIpZvuZYsnpvB01jYg5bGFuHI12rOsbcONwzbjcQvTzFBsRmEXRVVnyuL2NOrq1HJCRx2bN3PZqwfDkftTroyQqRICl2XjOmTGBThNjhyAx/i3YVi332h0oWorXLa1uEqNY5DwgQBOoR/axxIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvsmo3F4hPWSLCxKrNqc6n4M99BGnkzxCoeujR3MgRc=;
 b=D9lxcf8/orUPQvr5lpTTGDGZ1xR9J3YdzC1o7Tg++9u9iwmxl5BmkTMvepbp//DFwddtn9mzd/8nB6oMUcM8eQXjbw5k8HuznpU+6+Gqfr5Jln+us3nSwK55M3UiPeP18mNGLyo5shMCZ9Jj6XnsBxKuJhzHmEFG3UGoVERGgQm8X2rA4/JmVrau0c65pCKZA1FsfWEke4TTv89CFU9oqZf/AYuu5BduV+WEa49GY4EIXkLvVfEkSf5N2cYJev1ykLbuk/vJ+cYiSC/a9G/McaQn/n+wCc+3Nx8AZIqawTjA8hIIm3+4z1wu1stC3cPgElAXKcWIXem15hHZLG9ZGQ==
Received: from DM6PR14CA0046.namprd14.prod.outlook.com (2603:10b6:5:18f::23)
 by IA0PR12MB8302.namprd12.prod.outlook.com (2603:10b6:208:40f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:32 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::c4) by DM6PR14CA0046.outlook.office365.com
 (2603:10b6:5:18f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:14 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:14 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 01/15] vfio/nvgrace-gpu: Expand module_pci_driver to allow custom module init
Date: Mon, 23 Feb 2026 15:55:00 +0000
Message-ID: <20260223155514.152435-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|IA0PR12MB8302:EE_
X-MS-Office365-Filtering-Correlation-Id: d22c1ea9-d190-45c8-cc71-08de72f3f98e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iJZbGftxDxkUHlx+0j6UItEJwswH9EqciCkYfGmfC0nDJi3a9WaAhI9EdUro?=
 =?us-ascii?Q?yMwsLbcfb+vXzUC6ljuDvL01XOx/W3rDX3BY8rHXNQVINrP1U4skkRXTk/NL?=
 =?us-ascii?Q?oObbGS5MZueHkhj+bGVmDg2rTNybM9lOp5FqDJt0/jJLmslyJp+ww/xUE616?=
 =?us-ascii?Q?qZQU2FzJE2Jggf0Mc5nh+OJv2c/lFR+aP0OBoqose1z+1RP1JZRnfhUWQRbl?=
 =?us-ascii?Q?ahS6o0Y0PfQJ2OjuKxAie1X5lSafaLcJSY4q6C3nMSpTqyycLb3tuoWXzYX8?=
 =?us-ascii?Q?BhoZemVygHgRjgZ8L6sqB6nvifoB7j4oxXoE3vZkt0tBjrxNg5rXmMfqFSQ0?=
 =?us-ascii?Q?f69R3/+sUxwSzH2OyoBrNIpdJmyaTfGNMUi5+XveAfIyIcn+wJQleEom+PbU?=
 =?us-ascii?Q?zqQ6fI5VqfwwjI7CuGv+ji0mvAwtr+OcrNSHR9yiDnvsIWvbjPpwhKxkCZqa?=
 =?us-ascii?Q?HthXX8nzqFIvC++Qha9vx+mownTtYgVTtrMy3udTwbR1eZG5vKupe85NfD1c?=
 =?us-ascii?Q?afjd+C8BjeTRuv0jW1hKaMOTAQe7ta9qU2eT7APR0mpFS0rzi3Sc6x2n2wkK?=
 =?us-ascii?Q?kMIIf33Ba3rQuXq0dNZs+Kv/NOdFIvd3aORE+B1Nbe5a4cwtjZOy1jFs14nb?=
 =?us-ascii?Q?q5XlgBuEE/KkcDCR+z7wXPN9qgX+9jRmx7L1H8zUSDmivE7bUW31HNhRJ/XY?=
 =?us-ascii?Q?QFi0K4GnAdyaokfZfE+dqCplpmoLqvrrRl1y9WruLGtOCn4EhCXZClRptEN8?=
 =?us-ascii?Q?ozvqX9vBmmkb7Ibw10tdOhR5Mno7AOdAu2EgviT+l18od7tvRmWaocWzyJMV?=
 =?us-ascii?Q?i2qcsW5LFSiZ/mzliUsyZxxHulke5qPZ3Xx5gJy4lTnYImVLWgCTBFUZC3PT?=
 =?us-ascii?Q?p92xHSrG0uvGgoxVYFhuphTDlWgtIx20jlmtVjEA5TJJwefZKlx1YBWFyB5d?=
 =?us-ascii?Q?FrePGrai4C48ePN2JLonIf0ZmjQzSED4vkuSSrgUgJnZF9Mc1mCwJDZb1T9Y?=
 =?us-ascii?Q?bhGl4p4nop/moOcQG8OUfNz9PE4tWarHCeayvr/1MH48u/jSL/YF7zhDghIH?=
 =?us-ascii?Q?ULeAA9crdjzYuSn4SQI2PCZE2U9rSAXDnmmYlFVy0XSaJDz66WPKv8bJJSZ8?=
 =?us-ascii?Q?+z2BXqWoAKWR4ntQpz/PWB7DY8bvdsBtel8TK/4xkpC5ZGLXxUkJhTLfexbG?=
 =?us-ascii?Q?qzMYb+rGOOExlUPMGN8lztG5pignJDyXsw6Cj9vG3XV3JZtWKz+BpLOQUzzN?=
 =?us-ascii?Q?tUHhOTCYPgOwWpr7UVbYU4PrYNH8XGJeiWWktU0iVSu+sA0yijjW+kNazn5X?=
 =?us-ascii?Q?55pT5S2T0+9tc9Rbui2e4cpiCQLQLbyBDuFDzddJj/rCe74GMzzah4s3IeEe?=
 =?us-ascii?Q?aHrHkWKUWExlCmITQmFaIClo8v9I8bWEjdcKnqfhC0dFGPGyO9mPJfoZ/9tV?=
 =?us-ascii?Q?5potw9VaIKSGa3KwrSDYi48izXwfvWmOTCjJC8WG7wNMDm4pf60Rj2N5FhrF?=
 =?us-ascii?Q?vNauKZ93R26sogkVk1buPw7dq76Su2A4AMnk/CldG6d8xutot5xv08izC7ZO?=
 =?us-ascii?Q?NwBMAJfspvTjbdYJODNmDgPYO4gKnOG/c1hc+0c79A6v1GWhUcL0iB4JhBlx?=
 =?us-ascii?Q?QylegT0urbWuFrkayItIvCAK49GPvM9BuRfCa5cbDTpgquwsTZXXOhnC2rFT?=
 =?us-ascii?Q?+GQIuw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9qqkJWzp56Fi96+gw824T0IzOgdwTwv1jkbqEg9vGA8kTqlzFTqUe3RV0BvvDFq4L2rJlqUH+WrqSCBIjiExZIR+MQxRy6o0+nXSV7bG4WPY0Gx0jjsIPhR+jGnEC71t6jbXoQ1fq6FYvm/IkBC46A0deRLpOAI76C6FqpJCnTRzXO8xrnPaEGooNUuL3hy4HtFB+7GKEI4IwiZ9Cpt+sYNLXdPN27hoZuQyzjyeWBY0EUtLs5CB14Kpn60kym+GPTSwP5d0L+z0KuCKxo39sXHxHJ5hoRtwTzV61XTbQQ4FamwOkaR4NohMzykT7vxvLw0ih5a+hf19zqjjbBNaKKmmB9AQi4XUELBFlLwDw++mUBYOruaQH83CvcJnP7uf3iNJ4jc9q+TycJgBTvvSyVipSIBj8A+B22oil28vpF/Bs2tU2vk0PKWTXq7sS0wu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:32.0211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d22c1ea9-d190-45c8-cc71-08de72f3f98e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8302
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71476-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 919C61792A9
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

Allow custom changes to the nvgrace-gpu module init functions by
expanding definition of module_pci_driver.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d3e5fee29180..7c4d51f5c701 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -1287,7 +1287,17 @@ static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
 	.driver_managed_dma = true,
 };
 
-module_pci_driver(nvgrace_gpu_vfio_pci_driver);
+static int __init nvgrace_gpu_vfio_pci_init(void)
+{
+	return pci_register_driver(&nvgrace_gpu_vfio_pci_driver);
+}
+module_init(nvgrace_gpu_vfio_pci_init);
+
+static void __exit nvgrace_gpu_vfio_pci_cleanup(void)
+{
+	pci_unregister_driver(&nvgrace_gpu_vfio_pci_driver);
+}
+module_exit(nvgrace_gpu_vfio_pci_cleanup);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
-- 
2.34.1


