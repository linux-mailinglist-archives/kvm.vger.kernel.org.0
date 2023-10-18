Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306367CE41E
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjJRRQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjJRRP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:15:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141AAB0;
        Wed, 18 Oct 2023 10:15:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmJYR5A8aNs1/qlTyBiaF8H4uFSbrnjmuVtRv82VGjOX2Cwwz/k29fdJoVxpm0bzkN7Wc2BjBdA5D4NcXm2tZJKgvnggRK8/slYp0mKA2rj6eQoVgadwEEHPch/N6WrOfG2icEaFKCDI22nXKkNzW4NbCv6NqnXFQhU8dfhlCCJJQCDzxTfVUnZdRpH1Zsv+Mhtb3l05SIRWr9MxJmh/Ay/4if4rSmoK5qSQALk1u0LdmtslaeAv3R5Re8jFGHfhoQ0FirME+QJGPjJPdOHDungUGqUf9gyc+iixkqojx1CeWaCPT3Y/yCWk62Uyidtumjfu1HRPPbDV2rA3GuddMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zs2p5Im8kifm/aJ1lEAfNpIB6nh0RoaB6CA/cNIHKDA=;
 b=YJEZzKdlqNSSVBxtOeftWp6F+IYm1anjd92kkxaOW/AXMjMJwMt9TqlYWudhGkZA7niWOYCAAIWDMnV1UB1tnc0O4erb+dv63Lx7RvFSG0X757Y95aKOm/a6Lfz4Ael8pyXY5a+YiNx/Qnu96LCFGw/a/rW0dNsMqxWUgdVoXIt1NlcAZgDEA60LECVVRajhJK6YO30VxLaFsLR/xTsATwzMy6Li9RtY7PZvt5LgMG7MJiLMWk1ZfM95t/mUtTJhHpagLOAe9l7fQdPkeEYE75bcNb2pGC5i27dv2EQZnVUe+daOcVb7wVs1qUNh0VupBvcXkuHQ3IV7XbyKz8K8eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs2p5Im8kifm/aJ1lEAfNpIB6nh0RoaB6CA/cNIHKDA=;
 b=lZtmCB4T5+OptN5sueNbgxReNPY/IQnUGw0wFPIs5WOBBWDpZjE7X23CDZ85Skzl28oXsIHOprOjB4Tmsehi7aVz0HKBcdm1JeTMtuHfu/LdKLkAbJNsVQnoG/4D4RGpdZUQvO7QnzWpy1FL9rCvSp6MoOSCwtQtR2DTl3e85/HdPWlvuqMzr55qWAxnbF7rDBbpIffNzmwpH5wjQM/9e199i2+P0BHDHa5ljC2spNSvL7EHVuCBiA79s/d3b5wG9DnVI5z9/0WV2VEFyhurZHcu51sW632Oh63nB8oovDoIR5Bv5AW1ihmJ6mKXNZQrt++TyXPFyrWpOzSeYNf6wA==
Received: from DM6PR08CA0025.namprd08.prod.outlook.com (2603:10b6:5:80::38) by
 SA3PR12MB7857.namprd12.prod.outlook.com (2603:10b6:806:31e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 17:15:53 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:5:80:cafe::79) by DM6PR08CA0025.outlook.office365.com
 (2603:10b6:5:80::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23 via Frontend
 Transport; Wed, 18 Oct 2023 17:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.22 via Frontend Transport; Wed, 18 Oct 2023 17:15:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:34 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:34 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:31 -0700
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
Subject: [PATCH vhost v4 02/16] vdpa: introduce dedicated descriptor group for virtqueue
Date:   Wed, 18 Oct 2023 20:14:41 +0300
Message-ID: <20231018171456.1624030-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|SA3PR12MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: 6355522f-8b05-4ef0-9aac-08dbcffde20b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7XFUZzhXzDbegIFEx6hdNFO0fLI2aLS3CYZ4xCZvBC5vHfK3xXIa96JBSfvpD5nBdL8A8s/L57XYbkDtf7s/qTR9/bFIDOinS7CnoI1nQl0cnIqqGrR6IccEBtLtoQ8JNn7r9GBIfyA3qm+J7gpUF2NW/I2ohMivzAv9v3smwNlAw/f+Py7M3rxW1uydQmUYuFK+sw/qomkiEi6u+8OI8leBNXU3DbBDlN7DTZcuprCjemyOe+hQv6p4Bzm9IpOD+meIz0DPsKLBvXpi+/TABKol61P9gjKODdFOtf4zu6QB+gQA4aQYQKD6w1kdY/zUFXejcaU7Kg0jMUspb3pyCBvPMe15omkgOqX+DQGF9zm/dCwQqWKZ166PIMXoJNigzApHYiMg8SfbnqBp7pVnZyK8uKSFOLydffeT7+T/elemQdLw3gqpRS+EzUsOX3zzpCUF2MsYLfgK7ajqAoM34DwBfUfwdlo8+Qt9zK1+hM0tl0fzWoNupc1On6F2jKflgPBxcqAvCT9V8GRx4lT8YN4kjXKz5vMntVWHCR0k/h8RY5ck0u9ZVRDlHm/zxMZobRZlOgSoH3lK9ERFdxUez5bKdFH1Ymn8zCifTnvG58+VHN/o2e0q2hIhNWjzxsR/WKIbRZPpvMnnEtpfZ/vhlYV8sX55bzZFgJ6k2UGTzKRprzPybCjAlrNc/2L0kyrhXTmTiHWhUlEr71Hs5eLIE7nI867xGV7Q5zPTG0nKhNpYVkpL5/6l9TXdB7np0J8n
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(1800799009)(82310400011)(186009)(451199024)(64100799003)(46966006)(40470700004)(36840700001)(40480700001)(40460700003)(36756003)(426003)(110136005)(316002)(70206006)(7636003)(86362001)(70586007)(54906003)(82740400003)(356005)(1076003)(47076005)(83380400001)(478600001)(36860700001)(8936002)(336012)(26005)(6666004)(66574015)(2906002)(5660300002)(41300700001)(2616005)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:15:52.7737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6355522f-8b05-4ef0-9aac-08dbcffde20b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7857
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

