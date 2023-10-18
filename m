Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253307CE430
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjJRRQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjJRRQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:13 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB52C18D;
        Wed, 18 Oct 2023 10:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEj/bxhAwEkg7fQMmRVPgdsoECTbq4OB1JRCRG3nCVeHuTvvjA5eJ4K3woABvaQw/l265MLrxnwDDDyJfu2HM+JKbWQ+z44GDPAKq5epWJG/9dpj+qSSz6dF8hXx7KriTSoGdKtUsVtAbmhRrhYesFDH6fDGoVhCw4WIQd3rjBrzBpxpeKZpwL55+ZSIlrauqqSAJCHm9A6EvHEQRaCVuB04U/MBueeirjDdhSZ/wx/nWYnEaDgpR5WlkS7KejP/Ybib/1+UYGwdTx+uGfOn3vS3YI7/G2GVp7+rLopvOOh6HjGeh7Nnbq8iDILmtRRl2FxoZV96sAr3FhU2cd/Dew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u64U1vHaUjCMSpg15sklK0flAB7mos1z6H94Kmb4gsM=;
 b=ObpmFBFUcASwundJf17ouX5HXIq1+hD4eWBaFW1esQ68A9va2SltWqoJ3NfBeaCXIvOWLLMw4QKqxVh4dcpo8RdKgvrngAcRvZ8JTubWlhrli5LLZF6LNI8vFDc70NC1+iB4B325QOOrOET379xvdOnOddXYPyktm1QuHAJ0Ct+yK4buqJ1R4RtZq1eV01y+iFANdsgzTDla6WTeA+KNZdIypKmfGEILE+KvOkNWoM0fgTeHjmEpz1fFyTcQL/qOTwyjnRTpnLaMJ4ULGEWm1CkMDhy936J1e+/K4XzSNRd/oQCEjIf4IiuDDp2SKO92rsw2eKCynmFA12mHJPD06w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u64U1vHaUjCMSpg15sklK0flAB7mos1z6H94Kmb4gsM=;
 b=Y6hg2/N54tfKr/Rb30K/PwbSMwKrF1WkPOLVRLcbggk6T+khh/rsG7qE5bnVmI3AUmHY3hX3c118BZ4fwrbi4cVqPZgLrEqe131tbeO1AzSUtT1J0UKZNMM56ojI5rJtb+rrkNrQXxWOFhJamUny+55O3baP/DJy8n471G52U5Ldf6AzwYhBsEDALmLrh07p6pVXrOjIND02YfktKPTZCc8bFX0lAwX8ohjY4JwThWLPgOaELbofTfPJ+PrgvQ7We7S63oCn8QHe80tV6l28DbMooFgiiXmpltyhDuVqsRMvpNpb7pCzFCOGgOq0AgIMLCaVBmabsOq1vo+F7B9vCg==
Received: from BN0PR02CA0028.namprd02.prod.outlook.com (2603:10b6:408:e4::33)
 by DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 17:16:01 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:408:e4:cafe::cd) by BN0PR02CA0028.outlook.office365.com
 (2603:10b6:408:e4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.23 via Frontend Transport; Wed, 18 Oct 2023 17:16:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:41 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:41 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:38 -0700
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
Subject: [PATCH vhost v4 04/16] vhost-vdpa: uAPI to get dedicated descriptor group id
Date:   Wed, 18 Oct 2023 20:14:43 +0300
Message-ID: <20231018171456.1624030-6-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|DM4PR12MB5373:EE_
X-MS-Office365-Filtering-Correlation-Id: 87625a0a-753f-4aee-b47c-08dbcffde708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5h0gy9lojRRmXdsIs2ENcNTm3YEt0wrdqIZWse4NkvCh000i12j/5Vkicf4UDSmQFEN++3lXJXpyI+WxUj2tnfpViuA6dvJPxA3kdFvw74S47TNH/e0QI/qBwRA6qasmTCZlSJYYF9GZUmyA+yO6E8zb+73hc1ecJwT36SaKyaMfmS00wlj15vERCNUePwxRMHRcdAORsWVu4TQ8EaRHWdh/utRlVbZ/4tBTruPcyWW24SOK1IFCeQCXiUn9R4+6bIeuA+AalG8UHiZ1DnyZfCUSlVFKeUZ5/sADdH0wZOuJPWQmyB3R3nx6SmPa10444WCR/Tf+dHva4fkyaJGjf+C5frduPc3uLJaSxYJDREbqoWRpxo7oQWF01ueHEiQjgu9DsTnPMmzEPn5le2X7r2XwmhGLbn6yz4urMePczIfQ0bevZhdAzIFkpYalNfxcWEuxMZlm5bXdv76UahnFSM58bu2HXxzBbhuGaiRMg1ohk/66GQbuXhAc7sZrng+OAJL/6jfV70G5uFc4tGLXOnZ4c/Yuv8FGf07JXJsmedBg8PP8d5HbCud3O/ZQ+xwQNNTUHJTr015FcVCBrx/R07uVJ/mM5mcZ2Yw2mOXdljOFPB++9PjkvgpceDR3jxtwJ/aNaLgb3u3sGRPIwTnDER8aTdCqKNDptNeiOMuDjrzsw+vxy4upAWbtk4dg5j0R5GvdXH5ykmOFsHV90w6vAdYVHzUpQLDWBq/DfDV5g36ihz8GknNmNGRRz3u45Ty
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(346002)(136003)(230922051799003)(82310400011)(186009)(64100799003)(1800799009)(451199024)(36840700001)(46966006)(40470700004)(40460700003)(7636003)(356005)(26005)(2616005)(83380400001)(1076003)(41300700001)(36860700001)(336012)(47076005)(426003)(82740400003)(478600001)(6666004)(54906003)(40480700001)(70586007)(110136005)(70206006)(316002)(2906002)(36756003)(86362001)(8936002)(8676002)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:01.1433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87625a0a-753f-4aee-b47c-08dbcffde708
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5373
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

