Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996C179D18E
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbjILNCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbjILNCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:18 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30F0E50;
        Tue, 12 Sep 2023 06:02:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BssIGCypzc2H2sUzu/04EtXTM9FPgjNuQUGshb+TxWNzcz2Kns40IsEYvm3pZptTisomsQ9Meja2RRWJKIx4iN1+dxW+JawAiROexI5TBjj+5ZLcG49eMGXMklFKPNQhdJ4syh0J9JWXU84n0nWaWos+JGshhwYJ9twFJdyeO2yxI6ZNcwemzxy1K54G+TbU5u2TVVBEE2dx3LkEcGjagry1zvpnEb/l8pX9+rXiHoq1kLpqVlxEcKE29E0OQXp+0eJPrZ35AYb2Qc3rtgoGWdOaiNsditxRxAHeaTeCIcfcSFt8/unQS1KTja2mpJQ0XHl7uEQ8PU+HeNoQ3sKVtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zs2p5Im8kifm/aJ1lEAfNpIB6nh0RoaB6CA/cNIHKDA=;
 b=OQBHIX+XQQtuuLQvFwvQu+chfTbbk0oK79VCS9+pwxALqMzN8K+MakuGKv5DWPrBpXUSAmizFvwa+l27DSZkq+aoKUrNw/RzsptItg6oMSHacFYmdc7CxEFvyJ+3Cuw49rQ7s/uaJzNbI7Iye2vUYBm+a3w0U41Qrs28bzdqyeWokCib88AsUjQFoRVXN3KKFDqLUvMUe83czOBdV+xVUocV/Oa47O1mY7+dhkrMc+gjZ4DVOm+TcZnuxiwnJNQrwdXZXMVqmn/cT1w4mX0zD8cbv9HABeYMott5MspOhTuGoYoMDeUpZUlfiGcU1SjiQfTJG/d/qYTxiZuVcgr9Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs2p5Im8kifm/aJ1lEAfNpIB6nh0RoaB6CA/cNIHKDA=;
 b=IEtkpbtD1j2nvab/BD9tyDqoOuOrDOhejgSv/GKfegByGxoW/9F0E1NPONZj+sZ10OZsUWMsZHDbU7NAL3burTVKmZvDw1STTk5x6C8lFGgnbiEBJ76phgBWOcU8yHIECMCtWYYUr/u05NTqN1gF23lQnQ3nTgeYGGzleDCJf+XUiyszCnRwi6hMyJmuNmXjKeyM4WNAd2m77uvpR62YThv6XPhNrGEu8we93sWtUNFMqcnnzrIPcsITFIxvVlbfKHJTZIxsRBTyFMw1FPOJt0D2+baUjvtcaK6pAa+ilQKC+g2dlPYQiyKAw8bqNZPne5Ob+0yUKFnEBljlACIu8A==
Received: from SN6PR01CA0009.prod.exchangelabs.com (2603:10b6:805:b6::22) by
 PH7PR12MB6563.namprd12.prod.outlook.com (2603:10b6:510:211::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Tue, 12 Sep
 2023 13:02:11 +0000
Received: from SA2PEPF000015C6.namprd03.prod.outlook.com
 (2603:10b6:805:b6:cafe::1b) by SN6PR01CA0009.outlook.office365.com
 (2603:10b6:805:b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.16 via Frontend Transport; Tue, 12 Sep 2023 13:02:11 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:01:46 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:01:46 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:01:43 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <kvm@vger.kernel.org>
Subject: [PATCH 01/16] vdpa: introduce dedicated descriptor group for virtqueue
Date:   Tue, 12 Sep 2023 16:01:11 +0300
Message-ID: <20230912130132.561193-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C6:EE_|PH7PR12MB6563:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b933107-0402-495b-3ed2-08dbb3907a95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yn1xPqP3K+26W58MnoyhosSIslV74qx/0pp3opux496KrMGoporXl5+MbMGNT5h59mcUBfwz79SxzJ8Gm3xd934svlx7+tAy5mkHG5w3gw7pK0+SGeK2mL08S1kubg8Peiou1vAKInWADJ8YVUeraZvhMCwvXzq+MYAuCkSx4/t/5EugjiK9wQQLHtQfUFBzuEQyFWTTivM/xELUJGJwNeDYxM+11NYIksWlr6/9MurM/14Tnik3iY8MJ22r4scH9yXvqZ8/s4bhkTZk8LzHLjMMwNVqHJtg2nPTHmwRLCrwngAtFvuiUG3r9Daof7u0OLpPfZZU8APmDlzHe9dBLnoEFE6BlnXHDgoIG5x4Uq/uFNNfVYdHO1GG2LJswywBIGdCZSD1YZKxLaZikwTBbIAOivnjN4bCVZEzUYxAUS1Ipx45MmN0xn5J2gbjttz1ThX5zp3fMt2Ylh05mYjbW/EuOd5BQ0Y7ryIHVi3SMawor5brFhce2/a8KZKCHlavpYFPFINA6tdQzNBBXQ/MIkBOLycvIeon8J+5jSA6cWD38iWqyx4Czi0+FgtfFrLWHD6tPyExsUutNSCAoG7HEXWJwTeBcGEvRdwqJUnZTifBxMlki15c/9E5FeHnMz7cZXj8tKRDbnZvM1QlzBLJvcYiav2z7Y0wUjKkU7IYSb9OfwmulaJMXGxodpeVucTuNhEj1VlqTDzyyvOJBOs6hWQUmMXVS876BxhNpzPZ77IImWL4RjK3P8oKxnq4uTUR
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(39860400002)(396003)(1800799009)(451199024)(82310400011)(186009)(40470700004)(36840700001)(46966006)(7636003)(356005)(82740400003)(36756003)(86362001)(41300700001)(40460700003)(36860700001)(40480700001)(6666004)(478600001)(8936002)(5660300002)(4326008)(8676002)(336012)(2906002)(47076005)(66574015)(110136005)(1076003)(2616005)(70586007)(316002)(426003)(70206006)(83380400001)(26005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:11.4914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b933107-0402-495b-3ed2-08dbb3907a95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF000015C6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6563
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

In some cases, the access to the virtqueue's descriptor area, device
and driver areas (precluding indirect descriptor table in guest memory)
may have to be confined to a different address space than where its
buffers reside. Without loss of simplicity and generality with already
established terminology, let's fold up these 3 areas and call them
as a whole as descriptor table group, or descriptor group for short.
Specifically, in case of split virtqueues, descriptor group consists of
regions for Descriptor Table, Available Ring and Used Ring; for packed
virtqueues layout, descriptor group contains Descriptor Ring, Driver
and Device Event Suppression structures.

The group ID for a dedicated descriptor group can be obtained through a
new .get_vq_desc_group() op. If driver implements this op, it means that
the descriptor, device and driver areas of the virtqueue may reside
in a dedicated group than where its buffers reside, a.k.a the default
virtqueue group through the .get_vq_group() op.

In principle, the descriptor group may or may not have same group ID
as the default group. Even if the descriptor group has a different ID,
meaning the vq's descriptor group areas can optionally move to a
separate address space than where guest memory resides, the descriptor
group may still start from a default address space, same as where its
buffers reside. To move the descriptor group to a different address
space, .set_group_asid() has to be called to change the ASID binding
for the group, which is no different than what needs to be done on any
other virtqueue group. On the other hand, the .reset() semantics also
applies on descriptor table group, meaning the device reset will clear
all ASID bindings and move all virtqueue groups including descriptor
group back to the default address space, i.e. in ASID 0.

QEMU's shadow virtqueue is going to utilize dedicated descriptor group
to speed up map and unmap operations, yielding tremendous downtime
reduction by avoiding the full and slow remap cycle in SVQ switching.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/vdpa.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 0e652026b776..d376309b99cf 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -204,6 +204,16 @@ struct vdpa_map_file {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns u32: group id for this virtqueue
+ * @get_vq_desc_group:		Get the group id for the descriptor table of
+ *				a specific virtqueue (optional)
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns u32: group id for the descriptor table
+ *				portion of this virtqueue. Could be different
+ *				than the one from @get_vq_group, in which case
+ *				the access to the descriptor table can be
+ *				confined to a separate asid, isolating from
+ *				the virtqueue's buffer address access.
  * @get_device_features:	Get virtio features supported by the device
  *				@vdev: vdpa device
  *				Returns the virtio features support by the
@@ -360,6 +370,7 @@ struct vdpa_config_ops {
 	/* Device ops */
 	u32 (*get_vq_align)(struct vdpa_device *vdev);
 	u32 (*get_vq_group)(struct vdpa_device *vdev, u16 idx);
+	u32 (*get_vq_desc_group)(struct vdpa_device *vdev, u16 idx);
 	u64 (*get_device_features)(struct vdpa_device *vdev);
 	u64 (*get_backend_features)(const struct vdpa_device *vdev);
 	int (*set_driver_features)(struct vdpa_device *vdev, u64 features);
-- 
2.41.0

