Return-Path: <kvm+bounces-1571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4027E9736
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 206981C20926
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE84168DF;
	Mon, 13 Nov 2023 08:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JAYwpEsv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B45F156CF
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:11 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C22010F4
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:03:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIUEnAw/nMcAWjRJU19hoFIXEfHmjF8u+V9O90ixO0tIlrQlZ0wT+5sPfaiUrRtqt/cWCJrKxcTlDStZyhuvlZKDnM921qoJ+WayIDizDpORKP6YVg/HzeZD+D/36TCqco8fqAlpjHlcXqT+9A/SJXaL1eVPf1souiwQ4ld6MneNxWL4IW9BthbOqYhEW5AfSPNkqZGM266TpxtEBeDZzwspJkxr4qhrS74waphhYZdo1aRWsNZBVFUG/TNSSaIbtJb5zdhEBERRj3NDuG9B29f3TIxIOB3izTW7qUcPNHAtdFkTFB7VkVgn3ooFp75aHD/QnXh/GERRbf7oXUufOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8j42m/JacpVfupRxJj45AISF8yax+aXsjalqid2po0=;
 b=kzgsbVvVEnXB4Yv/GuG4MQ7iOgqK6qwz4AsJjhmTDcTP8BeBzYznnqteyphNs0ckFqcTAKtj2yHYguaEeLKDLtcO05ni0j4bOer7APHZj+j66O/3NZmne1XOQ8yHw/Q3eiRL0Uyi+bOcNkRAf+clKcEkAQs97C+r3vqclpc8O0tUjauawxZyNqc81A4KXTaPr8tARj/bYQ+KvZF41gEh4rN9J8T0VeJplQkFowOVLxCf45gwJYJWvUj9Lkf/H+dHTtzayxkEG5zlnSDYjHKkHU5YFMz8CavWHQOwffxTnCbMPXjqNCLb4IWx+gTLD4EVJe82mO250Ez2JGF5X2qRug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8j42m/JacpVfupRxJj45AISF8yax+aXsjalqid2po0=;
 b=JAYwpEsvO9uNzfVo/PAuDAZvcjL9roTOud06UimwP1LKtPRtzVJ1pza2UgdKKjrZKPz0maupU7bCEZJSBNGV+nbD9nMDGEv9hadJld+6HpBsjMym22MGyptuljx/TVYwRSzdQ8CqHbXEtJVOFhodoO4DUj8W4B9+uKxfcTKzOQ+9yaITftQBW7TqJIPPvcvuKGYdOuHKnOLT4POGHEf5OcSv14BGNeUlrMSWCN+r4Ucr1Y+6SnqrrqpHN8zZh+YgGKcbD/4JRsQWcUSelMnzqaywmqSjWploJ4B9VdZ6dD1PQ0+XQfTvFyhNZtcecQjr3Y2SVa6yyCWoGS1D+kbcnA==
Received: from SA0PR11CA0135.namprd11.prod.outlook.com (2603:10b6:806:131::20)
 by PH0PR12MB8824.namprd12.prod.outlook.com (2603:10b6:510:26f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 08:03:07 +0000
Received: from SA2PEPF000015C7.namprd03.prod.outlook.com
 (2603:10b6:806:131:cafe::eb) by SA0PR11CA0135.outlook.office365.com
 (2603:10b6:806:131::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29 via Frontend
 Transport; Mon, 13 Nov 2023 08:03:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF000015C7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.13 via Frontend Transport; Mon, 13 Nov 2023 08:03:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 13 Nov
 2023 00:03:00 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 13 Nov 2023 00:02:59 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Mon, 13 Nov 2023 00:02:55 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 vfio 1/9] virtio: Define feature bit for administration virtqueue
Date: Mon, 13 Nov 2023 10:02:14 +0200
Message-ID: <20231113080222.91795-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231113080222.91795-1-yishaih@nvidia.com>
References: <20231113080222.91795-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C7:EE_|PH0PR12MB8824:EE_
X-MS-Office365-Filtering-Correlation-Id: fb54754f-a118-4c59-2eae-08dbe41ef88c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jgE+3qx+nJpEo+ABkkYjE30prTV07d8hzosEe+YmG+ck+VV9jJQzKa8B6j6U5iYdVe9h7ggPZ7c/zPIYQRhH8/UKrsNagPlAK71unU33b95yBe7RqvBizuDXLGzsw2R+NqRW8M/0qrsTZlamIOAmBPzwBU7NADhQ2LhRNu94hVkJZNGNKYDagC31IEPPUGmzmOrdxx8Gdm1StQhofrzKMWY9gVGYsMr2t+I5ki3HiA2/VgAJ3/uM493U3xWo76/L7Th4U7f4qongUnz1RBOKgwcKju7rk7e8d+5Nj+D1fGN/xwrZazqFUXJhOvSIju+CQr+sQ1wxbKryurAO0/N8VR7PRgKFuRYtMXKpph4j8QYxnF2gJoBlZ/vvTOsc/r7pO6WOug8ITgNvbD/+OqgChrs6VZ6aqcb0GN7ScnVHz/fUQzACM8RLFHpRXkxwSj3mB1TUJxmQ69yHTnC1vc1NguRYdFYrbqQjVR2a6m4PSDHEd0NKjRmFNqGqPqdxJeP+pE0LgUCjhPpI4zGLQjVHRhVDT8CMdWZZwe6eGGNJKB7J57ofiinoyIJVEr/7pwd6t0pgUShnZG6PZZEaLd3THU9175HHj7u0c2ibucXHLFGXsEc27LOGNfaU3rt5mE5+n2roLlMhQbDAalF3bS95Ras/PM3+S0s2BOTOHxMep9eNLqbQlK/7SWAUbHbcxpTzhwPGqns3xkZ9hfP79b3QXbPukFjIPfzaY1uyXBDFaQ0h8iYJif24kiO0+5TtRglT9alD/VKgoyVLmeAqOzqT/w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(1800799009)(82310400011)(64100799003)(186009)(451199024)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(54906003)(70586007)(70206006)(110136005)(86362001)(36756003)(82740400003)(7636003)(356005)(6636002)(36860700001)(83380400001)(316002)(26005)(1076003)(107886003)(426003)(336012)(6666004)(2616005)(7696005)(41300700001)(2906002)(478600001)(5660300002)(47076005)(8676002)(8936002)(4326008)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:03:07.1895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb54754f-a118-4c59-2eae-08dbe41ef88c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8824

From: Feng Liu <feliu@nvidia.com>

Introduce VIRTIO_F_ADMIN_VQ which is used for administration virtqueue
support.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_config.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 8881aea60f6f..2445f365bce7 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		41
+#define VIRTIO_TRANSPORT_F_END		42
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -114,4 +114,10 @@
  * This feature indicates that the driver can reset a queue individually.
  */
 #define VIRTIO_F_RING_RESET		40
+
+/*
+ * This feature indicates that the device support administration virtqueues.
+ */
+#define VIRTIO_F_ADMIN_VQ		41
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
-- 
2.27.0


