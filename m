Return-Path: <kvm+bounces-3091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA238008EB
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DF5FB2137D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3456C20B0F;
	Fri,  1 Dec 2023 10:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dckyIJtj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC60B196;
	Fri,  1 Dec 2023 02:49:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSA0KTtQir9HYsmW0RBX64q0cwy+a1xgEa81zPt1MFa17mpxxWQbscQcCtIzpM/npXewgqlO3cBMamV1cNHhAXHWHD5xsUH+o1oK5k64BtO93JeZGMMtISXlOGQef++HrmgweKaZfNch59udxBHntMt2kavlePvrHaTn6Kiw1M8PMi6u8eIGt98Bro8Fge7iModrht5SZ2SIeZBhLx8YbfuIpPfNPv/4q8vtYgp8CoM+DD7vkyoqo+Xpf9N2I1Ua9tQDFL4+CNic0aQPdnqy4GIXNA+3PQiATYZYuyl8qsRfHLAuMswHKSpWSMu3JDbPcPIlkvI9lPM09tg1pHZZrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBN3VhtLOxK0QpYiOrL3s1k0DcnOLMnsNwxCZKecFEI=;
 b=M4RQdSG4IrIXTcZ/UH3hqaYG6yqxcARCdfZQRsu4iGHaOZ8y2M9ezBSXKa8vr1TD11O3wOuskfiw/AVK20B/8r4X8/Q5Ge32GYMcWWzqAk/GMxZ7R+7je0uyIoEcPaR5IkPghYoKSQgTwKQSCTQdE1viuwTwCuMDgv1Ax42vx6k8F3irmcBWrLYMJOKLK5iJPLZHFtoCgmzy48Ffl8K4hDQuQkxkGn28fBsyx5G0KW/k5yIj4464qKeYh08XUzYdGykudYtwsZuyprC5QZhGNFW6BiBKGvxgs1JqdLD+OET+Hzp6uj6tAXr0vzJqGq9XP0J3x/6aX1heLvHQyMDSZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBN3VhtLOxK0QpYiOrL3s1k0DcnOLMnsNwxCZKecFEI=;
 b=dckyIJtjNq2HsUT28qtDw/0g//OgjMcUMbDalgD6Yzc2D+HWoAWC1GCkSVKafs73LfwoUZvAkJawmMtc3BTCA3APN/LSExjJR9CL1iFcWhTxBO+U7Wtd/GwJTpcl10h8dR3KJuD8pyV2YZgJ28gZTrdEFw3ccCGj2F1z1kkc0zBLu0BTEOUnGUEtHutReTvw+7+E1u3c2emN2nueA5PJ5gCQXimJcXhhOUwbdRqYVg3cXhsOdta+RvDy4W7IEXV3apIqCsdYs0f1TIE8+q6RSnoCtCzThmtqje92pnKa2YEY/ITGFqvCoeCk67+K1MhnDUUhYINSbtCkfVgEVNrgaw==
Received: from MN2PR18CA0014.namprd18.prod.outlook.com (2603:10b6:208:23c::19)
 by DM6PR12MB4338.namprd12.prod.outlook.com (2603:10b6:5:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 10:49:27 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:208:23c:cafe::64) by MN2PR18CA0014.outlook.office365.com
 (2603:10b6:208:23c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24 via Frontend
 Transport; Fri, 1 Dec 2023 10:49:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Fri, 1 Dec 2023 10:49:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:13 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:13 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 1 Dec 2023 02:49:10 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <galp@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 0/7] vdpa/mlx5: Add support for resumable vqs
Date: Fri, 1 Dec 2023 12:48:50 +0200
Message-ID: <20231201104857.665737-1-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|DM6PR12MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d2c6d0-8a0e-4229-b24e-08dbf25b3088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZN8kHCAn27B1dQTHbmTpXfGlfJw0CvspC2PlpK2+SBSPDLj3sGgfMjvDQBayC8aMq8kbOYdDXyfklh0BbXx5tGKtea4PFIjU2GqTxR3pFK1jmdRSoovs2IwsqiVWesdngwysw46Bw+yT/KgSXok7wDkYrX/+4+WufGxLMjoeioesBdJ9XR5Rg9o/M28P1SJlAMYgyHDbfe2Jy86os5CBbr1lhWuxzzDqhtw+jnW8EsBFZxglidyk83ansC1FLxNzSjbNiOg4ICmr+Dbb2D8S8KMYQq5uJk3O1r/Li4AMamEa5vKAVmisybX9RVjNuCc+sDNiuttxZhutTcKjAkAWvtQsq1jgQObaknqtFYPuwVD6bofR/KoGynJf9r1RCUf6Ry6F6cqi2zRitQLl0uUn/+y55baeAOtz3NoahydKQWkxnDjvGc9X32RTE96ApQ1a9gjtHWhH7CwqhYJRGg0htQ/btbo2LmdKccG2t+M4d/sjN4wySywPx7OmV++NqA0LaJkNB+vK+hbt9YlX2BTHmbhVwvfa+Tfjm3RgOuw7ljq+eZcSa53Md+ErAtjPeouxIguK+4zYEYJbkZuq5irGvqQfr6iXRpNoDk92d9nLqbpwfFCeFAWAhAx9EsEOf7FRIeWiZwzDsIaC0c/UD6A+Qh0XAmIq6P1blRAz22eeDpoX94XdSSfNpHXf3s/erpU7eJzzpN45Hd/TfE+tygVIyjK6PSaI7O6DSI0ew0QT4kHOJlX8ZReTTg2i0BEeXhMVs57SNZNf+a3KiaKsrNNQs4YmLc3NKeIZErMe2A1WyX8=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(82310400011)(46966006)(40470700004)(36840700001)(40480700001)(40460700003)(2906002)(36860700001)(7636003)(82740400003)(47076005)(356005)(36756003)(41300700001)(5660300002)(86362001)(83380400001)(6666004)(336012)(1076003)(426003)(26005)(2616005)(966005)(478600001)(110136005)(316002)(70586007)(54906003)(4326008)(70206006)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 10:49:27.1236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d2c6d0-8a0e-4229-b24e-08dbf25b3088
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4338

Add support for resumable vqs in the driver. This is a firmware feature
that can be used for the following benefits:
- Full device .suspend/.resume.
- .set_map doesn't need to destroy and create new vqs anymore just to
  update the map. When resumable vqs are supported it is enough to
  suspend the vqs, set the new maps, and then resume the vqs.

The first patch exposes the relevant bits in mlx5_ifc.h. That means it
needs to be applied to the mlx5-vhost tree [0] first. Once applied
there, the change has to be pulled from mlx5-vhost into the vhost tree
and only then the remaining patches can be applied. Same flow as the vq
descriptor mappings patchset [1].

To be able to use resumable vqs properly, support for selectively modifying
vq parameters was needed. This is what the middle part of the series
consists of.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost
[1] https://lore.kernel.org/virtualization/20231018171456.1624030-2-dtatulea@nvidia.com/

Dragos Tatulea (7):
  vdpa/mlx5: Expose resumable vq capability
  vdpa/mlx5: Split function into locked and unlocked variants
  vdpa/mlx5: Allow modifying multiple vq fields in one modify command
  vdpa/mlx5: Introduce per vq and device resume
  vdpa/mlx5: Mark vq addrs for modification in hw vq
  vdpa/mlx5: Mark vq state for modification in hw vq
  vdpa/mlx5: Use vq suspend/resume during .set_map

 drivers/vdpa/mlx5/core/mr.c        |  31 +++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 172 +++++++++++++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h      |   3 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h |   4 +
 4 files changed, 174 insertions(+), 36 deletions(-)

-- 
2.42.0


