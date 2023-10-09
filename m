Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576B87BD987
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346250AbjJILYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346221AbjJILYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:24:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFCAC6;
        Mon,  9 Oct 2023 04:24:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmqBsOoDIBN9/lWK3UIKJ9G3hU1UlrErXZ6Ollo6Z4vWRsUHEq/NwBlPEL6dJ9lZAVZpR9HwM906XqEgWviyA7MEFEHo9hPM7J7QvTjcdbJLg/RP3zYXXIygc033us8HU0j14tHJgJ7YNvkRrIysd3bqThW5jQvKbjW3pquu+Kar61HzbjHj8xyF8ouSC9ozLFfn7b0+A8oSGh4+NMakfZKdWR3csyQg1g+c+MAIER0QEMHx7C5+Q74pOSIIqKb38hsUhAa/1LVGAky3VxQbA0yGk7RScgoPyXgdrgkYikOt/dFcAEyDSPSL3oXppu9z6X1kFDa2LOMY0M/1t0A8Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zs2p5Im8kifm/aJ1lEAfNpIB6nh0RoaB6CA/cNIHKDA=;
 b=asC15CuIXX2TeKTj2uWytYbbmz+lsej6MQRE+zA6aF0fsItboxs6ljNcxdJPBKnxTJAPJxHAvwdGhweePm5BAd73IpKbpFEjhafi2uj02v8WVI/fkhEMPfKVAMNIm6wiKPqSkZKRmpbIZ3pPgil2BTt93uGpa3rYlPosp7UeNAqCNpAsOIvau3c+iQtVYEXxpcwBmuDqt95VfY0rht/2xTAS19VaWmG/IPN+pMTnEOFB/HOtxDyS+VqAf/jCSnnIVgAOpEhPiDWaqgS7ygAsm+o7VFxPw6CcfopmCaAbCIvQDS+8zIxDigwPdmzW2dxdU7j9dk+yDPgFOoyT6KJoTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs2p5Im8kifm/aJ1lEAfNpIB6nh0RoaB6CA/cNIHKDA=;
 b=ruk9IJ3Xl+QhzUEeutHga6vrxIq8WHa6nZIOW7/zF1B9xiABiMmp1IxHmxRVug7YTKFC/gBSM0cIYjSaopJ0RuXHS9a/8jvr4NIjuive+lRpKQBgnfIG9F5Te4FgwaLp92MVxvyviu+fH48RzJwjSWNIUWxWVR06AWeRevG/mwxIxU/xoO3h6CdU4fhgR0/z6zq2/nPHzs/qS7UJzIURoy1dJ5X4R0Azlx+iXBMEqk9dfJzvY7hR1WzAPi+tQXKqCrkOKGQapLCrt9JBBUr2Qfy++Gl2kEQ3f5Fpwd72bAcsu++FpXENMHOedeSVbiSRXjJhv7Ax3aX3gESf8TSFiw==
Received: from PR0P264CA0241.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::13) by
 CH2PR12MB5002.namprd12.prod.outlook.com (2603:10b6:610:6d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.38; Mon, 9 Oct 2023 11:24:47 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10a6:100:0:cafe::9f) by PR0P264CA0241.outlook.office365.com
 (2603:10a6:100::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36 via Frontend
 Transport; Mon, 9 Oct 2023 11:24:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:24:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:25 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:25 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:22 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 02/16] vdpa: introduce dedicated descriptor group for virtqueue
Date:   Mon, 9 Oct 2023 14:23:47 +0300
Message-ID: <20231009112401.1060447-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|CH2PR12MB5002:EE_
X-MS-Office365-Filtering-Correlation-Id: cc6402e1-76f9-4edf-0852-08dbc8ba57a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bahy9pqa1braQgeWptccs3LXAFRXcM17+sab8gAv06vD4tF29BiKAGy23hQtjeidD9K7KCnlSGEk8234wfoCYFLggT5UA0lPpvkPXHK3LkzvOOcDzeWO59ovjWalxnmH6IfkcPPegKtZeq9thIozZ8OAd6JpSvFgfkq4sDMf7yQ2ebpczNWGkyK8iYG4HMqPvscoXspX5u4vT9bRP78i6o+HWZnN5AMhE04zpxg+B9hUTeYYqeiWfYlb9lkFpHKBuUPc6CbTkA43/aMzDCFlBGFzX+J0K+RNzIcCLufdmd8UFW7OguIlpWBXtW0LMAkQ0HXDITSKZZKw38OM02YpzdvK9+CLHISOoUa4pwyUUVSl0hcF1CXK+qCngtotypYRpck0NslzRRKIJA+qiufjWqoqGlCtnXgonp2jsSjYlyFutVq6ql0aX1j5uQ4YgXlX3pvP4c3/oOS1R0jL19lAP/nG3l3lZOS1gX2Vyv0XMqzl1yhO51Kz27pYLNoFomoal0dpn66dfMZEb7jWrLhhVSA3sxJl3BPuliv9Fr5HZ+6LkQ3CJa6uC6TD8dSy6Uru9SNe5ic0qKW0PII5E3Cbx49Bu8tqlYCRc+jBmDU6xuDJHwj8vCat5LP/prYAPATYvArF/vHgSPhwwSuD4bsGD+73qAbszAzcsIK8Tg1EaH/bo9m/O+rBwP6o6EdKyegOpEYGCN26CJr3ofocBpMPmhOF6Oroz36NnXVoukyyrG9Yi3pFgWY6HNzgJvkaEzdH
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(82310400011)(46966006)(36840700001)(40470700004)(2616005)(1076003)(426003)(26005)(336012)(40460700003)(40480700001)(36756003)(86362001)(82740400003)(7636003)(356005)(83380400001)(8676002)(4326008)(2906002)(8936002)(6666004)(478600001)(47076005)(36860700001)(66574015)(41300700001)(5660300002)(316002)(54906003)(70586007)(70206006)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:24:46.1712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc6402e1-76f9-4edf-0852-08dbc8ba57a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5002
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

