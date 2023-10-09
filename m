Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87F57BD97D
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346227AbjJILYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346216AbjJILYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:24:23 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9D199;
        Mon,  9 Oct 2023 04:24:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpDOAcZaZgUI/xcrNVuxvrYnl7NZwy5+a+pG++0VLcif17DWUAPuY8z0zoIFx4Pdzuvu+3MyyrHNPhceYzwrJnw3h+HrPEQBKrZZhpcM3Bu5JeF4lqHpQzOjv8fqkY1f3puIrela5j363gLO1JI9S+KOc9xaa+3jll2E3nLrEW+32yrj1YEh5IELzHzzZNkNaF75ORIe1tUisk+D6aMd1N4+JWX+gGOi5tNqQuS8GuDNFxh/7FTAAs+hJmYN/yyRLDlv/JhWu94ZFVpPd0Tm8WYhdiSgKoYJ3dyjgVKuJapMBfmy+IlgNFgAcrw8+n8uBRgHgfn3E6JtjINiJE500A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSKXXaq7kBQ38l9cJDymAs54GfVV6WHIZxlWYN2QFHg=;
 b=D2x44twsARrxzh0b9Ns0Pu5MyjG5vkET3y99IK9HhSI7MFYDIpeMFaU74Ln5/cJHyFISQqJ6s1+JGgFCj5K9z+EqmtYf6/3p5Q38GcAk2lNZ1FkF/ALAPcKPkui44/EfkCM7mgHyGmUOXslclUrwvKUuWdyIjXkkbzsjpqoodECp0ImOiMW4p3vVtMkTHRNIlZZ2p8Ub7QzA05iRSyoDU9Ucq/wGCSPvQGSimatPhFV3pjNYqkWAFernIAB7+CO6QDNJdjsM9Kzd0/gFhK52erhEm5x9njOZGFGx2sXNk3OJtsbG6DgfO/7+r2wUkg4MOhBIuauZH3k4hbtr3/+LfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSKXXaq7kBQ38l9cJDymAs54GfVV6WHIZxlWYN2QFHg=;
 b=FU6cEbMkBxiLHy4k+t5tSKWeAUYM2DD5n72UP9R7oiw0VeVUuzI3biPdMmkHALWHHwZ6wDLrKwniDjXbdqJqJnFK+RvFfWXzh4lTuDidFxD/tPCcIXv+rIfBW5T5qHBgxc22RJx0w5KoQHdu73V+XalKzfUVMqyVunmfbbBgIYzq7qycF2V6k4rFw83/bcuzVcI77a4AnPs860WUG2BvVoYL5JFOmtNAI+PQhPp1ssXMBh4K3tmx74kJaediRHWzcthBNZJcu35gzRW52BxBAjpX0tPrZxTzzJc0Ps7jYJdDqFt0Nug6igL+9nfumL6UsEiUb/t9svXtdmrPnFYuPA==
Received: from PR0P264CA0263.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::35) by
 SA0PR12MB4560.namprd12.prod.outlook.com (2603:10b6:806:97::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.37; Mon, 9 Oct 2023 11:24:19 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10a6:100:0:cafe::1f) by PR0P264CA0263.outlook.office365.com
 (2603:10a6:100::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36 via Frontend
 Transport; Mon, 9 Oct 2023 11:24:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:24:17 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:07 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:07 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:04 -0700
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
Subject: [PATCH vhost v3 00/16] vdpa: Add support for vq descriptor mappings
Date:   Mon, 9 Oct 2023 14:23:45 +0300
Message-ID: <20231009112401.1060447-1-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|SA0PR12MB4560:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c80567-e890-4b4e-7b40-08dbc8ba46a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DrK8E2HjzifH64dttlag5usSdkKIWpx2vb8oyS5fxyiEX/SqXysjtBiuWhrDCDKdxZ794X/2CYHH+IR+8a77i9xJY/o38H5ORXT2sIW9hNIO0nfiFspmIppFy+7M+mBnZs7bd4W/Zk1kUffTUC+SBHYNPHXLQjvBfvQPpyCWqvqMbrK13ucQaqDoPc+MwKY2NRJ76fHdIHUQLO/pUqbs/ek4q9LazzgJepLHQj4wPns9S4zrDaECYzNX3VlNC3c4f77Z0fWw6Z2/LE9oXkDuS1C/v3gIOA6+sHhbXXoJICzQmUffHZNjDTCIerSAygPvW9PF/Agkw2CT64XC741r3xY6QgM1Xgsu9bF3Kx+AiCqLqZA+pLk9tW7u26WYZNK1Wl8Iqk4GOCCnp6xUEYRDXDiiyFPkIlXOf//6NKX3+H/TBhR/ceRqNCwiCNATHeZZ8gG6ib0dWmCMxdbugxwR8p1EYHZ06OSdNaAaukUL2P+EC+bgq1MoK6dbZ8uyerkWRRrQxqP1g4uRDvGHV3FO30FL5mroRxWvBXwEoeJM8oYRTBZSqTfu7F1IG1htHoIK2ok70TWkxYMrURNNBlMpf8dzbE9DLyIuLIiWsDX4wmw4hMTOnmlJwvH/J97SQxrEMGDG/o1p4o1o5IJx6Dt3bAm0XLN0obOC+kX5VdOvo7CQaEMY+t1xU3VUEqrsw6VdvZWQ4Pr/nCf9PVZRv70Sgk8u0mtxf48BNVt4Aaq9fqVZFMCDj9TucttnJJNOyGi8YJ20BRKzmjkihDHkjqIkDF2rlvG1Iz2ixSNbm1UYeBw=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(230922051799003)(1800799009)(82310400011)(451199024)(64100799003)(186009)(40470700004)(46966006)(36840700001)(7636003)(356005)(86362001)(36756003)(40460700003)(40480700001)(2906002)(478600001)(966005)(82740400003)(41300700001)(8936002)(5660300002)(4326008)(8676002)(6666004)(83380400001)(426003)(336012)(2616005)(1076003)(36860700001)(54906003)(70586007)(70206006)(110136005)(316002)(26005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:24:17.6241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c80567-e890-4b4e-7b40-08dbc8ba46a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4560
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

Changes in v3:

- dup_iotlb now checks for src == dst case and returns an error.
- Renamed iotlb parameter in dup_iotlb to dst.
- Removed a redundant check of the asid value.
- Fixed a commit message.
- mx5_ifc.h patch has been applied to mlx5-vhost tree. When applying
  this series please pull from that tree first.

Changes in v2:

- The "vdpa/mlx5: Enable hw support for vq descriptor mapping" change
  was split off into two patches to avoid merge conflicts into the tree
  of Linus.

  The first patch contains only changes for mlx5_ifc.h. This must be
  applied into the mlx5-vdpa tree [1] first. Once this patch is applied
  on mlx5-vdpa, the change has to be pulled fom mlx5-vdpa into the vhost
  tree and only then the remaining patches can be applied.

[0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-email-si-wei.liu@oracle.com
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost

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
 drivers/vdpa/mlx5/core/mr.c        | 194 ++++++++++++++++-------------
 drivers/vdpa/mlx5/core/resources.c |   6 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  98 ++++++++++-----
 drivers/vhost/vdpa.c               |  27 ++++
 include/linux/mlx5/mlx5_ifc.h      |   8 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
 include/linux/vdpa.h               |  11 ++
 include/uapi/linux/vhost.h         |   8 ++
 include/uapi/linux/vhost_types.h   |   5 +
 10 files changed, 266 insertions(+), 129 deletions(-)

-- 
2.41.0

