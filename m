Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7927B22C9
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjI1Qt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjI1Qt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:49:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0761B1;
        Thu, 28 Sep 2023 09:49:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4R9XEtKkRpEQehDOLQIBm5g8VAVAn7T/c4vKoolht7ZX1sWx58pvywFZuIgQN4JPzLC5JerhxJxKTGQjQDdBHNxfOaJy3Ng2eE7plhOpdWIWsk7q2lrsMS5bf5Nl8oTXzHNKjeI4dVuiAc1WQ2PX1FgguUzbjNx+h9idaykA9xwPIbfUPs8Fb7RLBaoHf0IrzRHVk2k8m9YRuhhBBLwX148rlwDrpGr3M/5CSaHBDGtmMxifH4+GmgoA3sFWMBAm9Zgid1vI9YHSD8GMXjLbIHBQZ8dYanYaDo6SKzVczle1ZoNbCL+4/nhDRJYYkIsMjLoUMntg7Jsq0GW0ko8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmPn4qWmP7KfJ+WpATYZhbiwWGz86s/5qlts7hBoVyU=;
 b=RmcyoeJGvRlMgm3LSl5km1v4rX9UMzw47ULMK8FU7924FgiYOEs3s3F8rMrsrlgl4OIhCVlJ7gae8XI7U2T9x0d6QG7I/kM5btvhNAGuksDUDtHxsK3pD8ruga8lbnWBLP9gqwlvrdzmEAS2iyYmyQl0BnR6wJ/1IhjEQVrmQGdXX/GRUmvPRJuiE1z3MdBZGNJt5LTxPxoAJmVylM3g0tEUZ/LUzrRf7DhmQ+/HUnRx/q/o5T2IqJ+6LK9C0KwJKbovbxKZGXFQo4M82roGtGPZXpI4blS6nDYwsSZuPzrzt2+iDNR5rlVaOfJhW49oy3D0qtojswjLKy+xijSF3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmPn4qWmP7KfJ+WpATYZhbiwWGz86s/5qlts7hBoVyU=;
 b=AITdJdfkEGe3A9zJOBgRVszgLoA+KLWIQDKi2wMxD8G6zb0Vu8TYzJ/qkZZre86MZsuY/bp1IfmviCqadzpYiU7FOM3k7xsU+rmOFj5Ykg8P1ud2Y9IvsjxvmXbS1mv//xM9xdREhKq+Kv5Md/GCEnA4MBnlRO6lHLnC07aiU5/MOZkHmCbw3pCmkLbW1NVhwq0XxBWG0Roz41+fYGzbMDJb0NTNMJoQ/HE32BPhzKJj5Ds5Bi3y4TeOmYY2JShwcyvgn4KGOgiTpRi5FZnl3b4CxB32Zi8mKfzz+NEh6BVcb3y5C2/e9amiggRR47fG3S3KjV7z5tVGeD4ZpNmGiQ==
Received: from CY5PR17CA0051.namprd17.prod.outlook.com (2603:10b6:930:12::6)
 by LV2PR12MB5847.namprd12.prod.outlook.com (2603:10b6:408:174::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Thu, 28 Sep
 2023 16:49:24 +0000
Received: from CY4PEPF0000E9CF.namprd03.prod.outlook.com
 (2603:10b6:930:12:cafe::c9) by CY5PR17CA0051.outlook.office365.com
 (2603:10b6:930:12::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25 via Frontend
 Transport; Thu, 28 Sep 2023 16:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000E9CF.mail.protection.outlook.com (10.167.241.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.19 via Frontend Transport; Thu, 28 Sep 2023 16:49:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 28 Sep
 2023 09:49:11 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Thu, 28 Sep 2023 09:49:11 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Thu, 28 Sep 2023 09:49:08 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     <eperezma@redhat.com>, <gal@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     <virtualization@lists.linux-foundation.org>,
        Dragos Tatulea <dtatulea@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH vhost v2 00/16] vdpa: Add support for vq descriptor mappings
Date:   Thu, 28 Sep 2023 19:45:11 +0300
Message-ID: <20230928164550.980832-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CF:EE_|LV2PR12MB5847:EE_
X-MS-Office365-Filtering-Correlation-Id: 8db0220f-8086-40a5-dfef-08dbc042dec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SZi14fszrvs9BzkjD8+sAFU/+ddmcDw+RMNt7Szjw5xxdgHhq9zjNf+nGXxK4Y69MfiyyOIm3x3n+WgczFaU8cFNDQmQEEu1KNCHkjXI07p2kc/kciR28FLZDtEvWEAPScxvIzO7lQnqOOeA2AcoR6nA2ROjS6qFnZqG79ZwL/jr4Rgk1NtsllbHOzWrZn9VKR8S7XCP1JFA+StoITbFZBBRXkc9OEmzfCy4TMnpOFz0Inw4qp2EC639R/xSVN8jqDdbUwhd4u82E8Yvxo8SKjOFCqiWpldb5lEE2R6V+6oi+OXyRJvIdlEAUzurDBsWIfR+q//PansxuwuZOHFYihPNh3suxvJp8JH8dR3AUVtSAt4wn6rZ39w3cnuaFRnPvsIQoMsYqjXQjTVk7iBxVGxDzl/T1jstjLYdJ+cyCXbeoKw+RZT9xtQCCDTCQKpJWQ+fHStYhyh2Lm8lN5dQFtR2s4T2hFhfTEK0wgmGTmA2ChMGliYBKFR9YFs/8BFw8pSWU7kK1tbsl0kGoDKrfT+VllBMyI8dgN4dCb67KjJbLYjLzW/qZ9vXjg2PV9AXP/UqjShNzF7r0nJcbQ7A+wVWAjEkWG8URD2A8YwQES+gnPg9wZxcG323sBW4Kvgb0h+RFMgUIKR9Z+z+yYsbQyBi7fG+izB8frUMcVfGO9GhqcQlWPoJkvNnVKp1L1Uh6kIXNMnLSaL2LHwS6wMaiL4LrBrjIufidmBzHgy5EGrzYnX7cnZuH7MQXEeE2oQQvyy8q26JH/wLEqGiWOEyVoqgGE0cjzZvPziRD0cmo7s=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(136003)(346002)(396003)(230922051799003)(64100799003)(82310400011)(451199024)(186009)(1800799009)(46966006)(40470700004)(36840700001)(26005)(40460700003)(7416002)(2906002)(478600001)(356005)(336012)(966005)(2616005)(6666004)(36756003)(86362001)(47076005)(426003)(40480700001)(316002)(36860700001)(83380400001)(7636003)(41300700001)(70206006)(54906003)(82740400003)(1076003)(70586007)(110136005)(8676002)(8936002)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 16:49:23.9807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db0220f-8086-40a5-dfef-08dbc042dec2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5847
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series adds support for vq descriptor table mappings which
are used to improve vdpa live migration downtime. The improvement comes
from using smaller mappings which take less time to create and destroy
in hw.

The first part adds the vdpa core changes from Si-Wei [0].

The second part adds support in mlx5_vdpa:
- Refactor the mr code to be able to cleanly add descriptor mappings.
- Add hardware descriptor mr support.
- Properly update iotlb for cvq during ASID switch.

Changes in v2:

- The "vdpa/mlx5: Enable hw support for vq descriptor mapping" change
  was split off into two patches to avoid merge conflicts into the tree
  of Linus.

  The first patch contains only changes for mlx5_ifc.h. This must be
  applied into the mlx5-next tree [1] first. Once this patch is applied
  on mlx5-next, the change has to be pulled fom mlx5-next into the vhost
  tree and only then the remaining patches can be applied.

[0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-email-si-wei.liu@oracle.com
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-next

Dragos Tatulea (13):
  vdpa/mlx5: Expose descriptor group mkey hw capability
  vdpa/mlx5: Create helper function for dma mappings
  vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
  vdpa/mlx5: Take cvq iotlb lock during refresh
  vdpa/mlx5: Collapse "dvq" mr add/delete functions
  vdpa/mlx5: Rename mr destroy functions
  vdpa/mlx5: Allow creation/deletion of any given mr struct
  vdpa/mlx5: Move mr mutex out of mr struct
  vdpa/mlx5: Improve mr update flow
  vdpa/mlx5: Introduce mr for vq descriptor
  vdpa/mlx5: Enable hw support for vq descriptor mapping
  vdpa/mlx5: Make iotlb helper functions more generic
  vdpa/mlx5: Update cvq iotlb mapping on ASID change

Si-Wei Liu (3):
  vdpa: introduce dedicated descriptor group for virtqueue
  vhost-vdpa: introduce descriptor group backend feature
  vhost-vdpa: uAPI to get dedicated descriptor group id

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  31 +++--
 drivers/vdpa/mlx5/core/mr.c        | 191 ++++++++++++++++-------------
 drivers/vdpa/mlx5/core/resources.c |   6 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 100 ++++++++++-----
 drivers/vhost/vdpa.c               |  27 ++++
 include/linux/mlx5/mlx5_ifc.h      |   8 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
 include/linux/vdpa.h               |  11 ++
 include/uapi/linux/vhost.h         |   8 ++
 include/uapi/linux/vhost_types.h   |   5 +
 10 files changed, 264 insertions(+), 130 deletions(-)

-- 
2.41.0

