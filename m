Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F9B7B22DB
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjI1QuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbjI1Qtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:49:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5903BCE3;
        Thu, 28 Sep 2023 09:49:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIaa/CxF69oMvfRMNfHd5QoO+LxTveHRSVYS+gmUD/hyf5myrZQxmqrMvUuuctGXIlIt6D/qugcr/h4Xbj2sU8sO6BMml6u8K1h90jw5UepdyWMN4NXQ+vdsoDvfBZnImoLaw1SbQQqzj3NB0J3j0LPROJ1YV/NBL6uVy5e6NBtW2S6JiIM682U6vZDCsR93N99w+ASaeABieHia8O41tk92FQZRmKssDNTuqIu3b7+o6wSZDdHBVG+1j3XhEBs0RQmIxGoUSS4gbkhJxb0tp8W6gZd4PxQlZ1p/nMl1PnjxEs4bjk0AwaDF94A7R5qR1sZkD4/Ci6jmk60I6xnzAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u64U1vHaUjCMSpg15sklK0flAB7mos1z6H94Kmb4gsM=;
 b=l89UZgGFsi4ekBIuMsrB9UkGtdT0o+L66g9GXTG9btPS0P+V/FRN446Oe1lIMcikx0UxS14NwVx2xWHBtuBSWbQ1mkXL+iggt2GSbRV2ovipetlNYfsB8Nl39iU7xRbfzbZ5luXmldwh/oz+n6YLgI3bdUa2oDJqbg7eNzzvFE5yJHkpx3wctwwuOmK7jpg5XORUyRpCX6OK/KK54nI58tczd9jAVw/EV3Yw3AY7zX+7JYIrKw1B5QWIyCSDAoZBxJfButBRg4xmlQRlzz/UDDpzx9jgnUUAvy84KNLj6o0QUgdjUAUlHPltOxop4VC+B0XYAXUKLgyD7uZbErrwmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u64U1vHaUjCMSpg15sklK0flAB7mos1z6H94Kmb4gsM=;
 b=RMqUPGWVQyzJMkle/oL496Jo2Q32omWBRHpGGcNY9nBgPtP6sJ2aIYFq0nJwH0/e7NMxyJZZh4LqicRFcPl/JcG7vAiD0XSgi7a+GrirRVwl/cjFsG412gFk8E7+bDreaod8CNr6dW25Dgvh09LykHCSteKD1Cgz7W/iRCqLs9FZlHkDOwqgn3iQoVlIA8eccRArMZ+LsWR2rQJd7uTkUJU9fdcoCCrtbPhQmAPeV/sBaGagMIbEf8+zcbipSIWAphVeMtdGKni1GUPAX4O1fCePKf8HVKxlFcvCvbzbwCzmn1J+rMqWkRTDmoWuqTRNFHSjWkcDlpga7XkGPjiQ3Q==
Received: from MW3PR06CA0017.namprd06.prod.outlook.com (2603:10b6:303:2a::22)
 by DS0PR12MB7704.namprd12.prod.outlook.com (2603:10b6:8:130::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Thu, 28 Sep
 2023 16:49:45 +0000
Received: from CO1PEPF000044F8.namprd21.prod.outlook.com
 (2603:10b6:303:2a:cafe::69) by MW3PR06CA0017.outlook.office365.com
 (2603:10b6:303:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22 via Frontend
 Transport; Thu, 28 Sep 2023 16:49:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000044F8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.9 via Frontend Transport; Thu, 28 Sep 2023 16:49:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 28 Sep
 2023 09:49:37 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Thu, 28 Sep 2023 09:49:37 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Thu, 28 Sep 2023 09:49:35 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     <eperezma@redhat.com>, <gal@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH vhost 04/16] vhost-vdpa: uAPI to get dedicated descriptor group id
Date:   Thu, 28 Sep 2023 19:45:15 +0300
Message-ID: <20230928164550.980832-6-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928164550.980832-2-dtatulea@nvidia.com>
References: <20230928164550.980832-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F8:EE_|DS0PR12MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: bf69fef0-7f33-441a-5fd3-08dbc042eafb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3covqXVqV2bCvSqif165e1cjvj97aFhG3v7BAdqt8P+zGUeEV+8AJOweXKt1SlBDqE24q8CK7DPQcM/IXjmTyDYr+XnR7kGERe4ZaymPbkxNMqdPH7ZEwxwvDJd8jhmoWOtyH2NC135lk64Ui46dH9cHTHjsEq2NK9Z2x2nRepZQ5CIBhs4QqN2wU7qjC01Go3JB3dulhY+aXFmgeSzv9cRLuvioYAh5N0oBlh2qfQlr9nnsLzlyfeLJQkZg9Hvzqp+E+3L2shR9Y/1eBJL9vrM68mqcHyZk1TYnvaGbZu/l3eCzibYAxE7viTHL3l172YwKT6vvfrVZxlaBKeQ+lsaLgooAJusmhT4kG2uD9H8kvhAfyJSl8LckkzVg1TDlKabjlqSmPKEjSSgy9qkZCwsTkwFIZWiKSC5yxC8B+2OY6TXjpLdSw6IhWXmyeauCQJ+bzO9ZP2CHf7bh4uMWqu0fkCm0P1dneyc9zFBNcp7Wn5e4QlgmQMUXby7obd47REFBICS/PZG+D+iiw94ekl5W1UPY1Jo+fN+5bIWu95e2TP0kipNuxEFblhtzLabG4meLGSsAOosghpNgeVhZfHQ8zfU4HKDoLl2qEoHS4CZdjP+3puJ8XAlcwLCacSMcB8kPtfQ1RWvy7uxxQqe7ger6q8QGMWf6+q2WZOwZMMFbQiwkyQrIw/UfZB3GkAP6HkP0pZBMdNBsw0sA2/P12UgRKg/tSMkmLset4Jo3B2R13wq69x0MTdhXjEJ8Sqti
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(82310400011)(64100799003)(186009)(451199024)(1800799009)(36840700001)(40470700004)(46966006)(36756003)(40460700003)(336012)(6666004)(70206006)(356005)(82740400003)(41300700001)(478600001)(7636003)(1076003)(2906002)(26005)(110136005)(2616005)(70586007)(54906003)(47076005)(316002)(426003)(36860700001)(40480700001)(4326008)(83380400001)(5660300002)(86362001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 16:49:44.4836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf69fef0-7f33-441a-5fd3-08dbc042eafb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000044F8.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7704
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

With _F_DESC_ASID backend feature, the device can now support the
VHOST_VDPA_GET_VRING_DESC_GROUP ioctl, and it may expose the descriptor
table (including avail and used ring) in a different group than the
buffers it contains. This new uAPI will fetch the group ID of the
descriptor table.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 10 ++++++++++
 include/uapi/linux/vhost.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2f21798a37ee..851535f57b95 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -613,6 +613,16 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		else if (copy_to_user(argp, &s, sizeof(s)))
 			return -EFAULT;
 		return 0;
+	case VHOST_VDPA_GET_VRING_DESC_GROUP:
+		if (!vhost_vdpa_has_desc_group(v))
+			return -EOPNOTSUPP;
+		s.index = idx;
+		s.num = ops->get_vq_desc_group(vdpa, idx);
+		if (s.num >= vdpa->ngroups)
+			return -EIO;
+		else if (copy_to_user(argp, &s, sizeof(s)))
+			return -EFAULT;
+		return 0;
 	case VHOST_VDPA_SET_GROUP_ASID:
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index f5c48b61ab62..649560c685f1 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -219,4 +219,12 @@
  */
 #define VHOST_VDPA_RESUME		_IO(VHOST_VIRTIO, 0x7E)
 
+/* Get the group for the descriptor table including driver & device areas
+ * of a virtqueue: read index, write group in num.
+ * The virtqueue index is stored in the index field of vhost_vring_state.
+ * The group ID of the descriptor table for this specific virtqueue
+ * is returned via num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
+					      struct vhost_vring_state)
 #endif
-- 
2.41.0

