Return-Path: <kvm+bounces-4857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C9F4818F62
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37E24287C18
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BB140BE4;
	Tue, 19 Dec 2023 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hzwOkIcj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB5B3EA75;
	Tue, 19 Dec 2023 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EK5sm12K7f/IcSyPuklNVwdmfe+GSDzHhYYoIqAxRC4/3hJf7OHhjuhCMZCpjpWmcczxRnCXMoPlDbTlHmKqCg77Wj2MlXqVv0gLVmSPMBzmhb5K5JQChSuUGK1xMYpVNVNLMkuuM4HAvZGM+44cpwDp5aBXznISL1qD/hlrWSLE5DmJQtpfd/xCbQlgOw+r7Z6D4oyXmYJR4BjTZCWsLAIKI4QWzmhEs51Sr6GDoPXOLdjdqhTCnD/r6JIcmL+EWLgxUat3aFqiyrKSWl8DJtZbKgfWHPAVsth0M0PzxmhsB6OcR3tXRZPbOvpC6z2MX4OfloPpkk6BwhnKTcpL5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aq1IejAJZi+jwn+fRnf3zq6axHOwHpgeCeFJajDdu4g=;
 b=JlkZ4IwZyxpotkF0vacYtmuJdo26E70/fqn5qnIL7l8ktSeHGeBe3FwXtt5gjOftVqU3tS3S1ozKJTJ/Vgp3BaCvouf8XuFakc7ozBRXvw8ENobNmqM46hqErFmyHYnsTJmvHrD/jlbHgN7y1j0IoXTOldlJlakNLQjQU3rTyHd4AYJniLlfZ0hVgL1H/5pqUAA/q/qzaOssU6g55JgX7E1udasWUYtMFCWLiCZuj+AK0ryvQ/FV6yyNPECIGlGdCwEuO3fzdLEJOqlNbqGIGGscXPbth3Y3okPEy1YIwiBF6FnQdOIiDQOuBiQ6pMOiI86KYHguS4VIRn5LPjroFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq1IejAJZi+jwn+fRnf3zq6axHOwHpgeCeFJajDdu4g=;
 b=hzwOkIcjNC21aWC65UI4KmDjvY1CvVmNj3+4gtb1oXD8KSJZ3WjnLX8IvZnMvWuLVzcR7YOcVFwvNE8bWMOj/ceUX0pSPC8VYnZzo9GTiw88KDv0EnrbPhGPCdKepBuEnKYn40XPGENDh2e8MSL8b1octp5iZ6TPKLElQLzzEvz3ZBOzJal9zWuLeDi8q1L0FCAn9MEzIyny8Mf2t2xOtc4zmyyb0cByCNPGSGp/r76PavQDgYCIlOddaC7j4tQ7mnk7HfNtWkvuHPDxrvWi992TY9iQerUVu26ym2B5PqzLDvgWWrYflb1LklSYkJo8n5DSHZpOaBEjTpb+EtyF1w==
Received: from MN2PR15CA0065.namprd15.prod.outlook.com (2603:10b6:208:237::34)
 by CH3PR12MB8849.namprd12.prod.outlook.com (2603:10b6:610:178::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 18:09:41 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2603:10b6:208:237:cafe::a9) by MN2PR15CA0065.outlook.office365.com
 (2603:10b6:208:237::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.39 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:40 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:25 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:24 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:21 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 05/15] vdpa: Accept VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND backend feature
Date: Tue, 19 Dec 2023 20:08:48 +0200
Message-ID: <20231219180858.120898-6-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231219180858.120898-1-dtatulea@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|CH3PR12MB8849:EE_
X-MS-Office365-Filtering-Correlation-Id: d935b6aa-7f37-4a78-cebd-08dc00bdaba9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JeJls1S91VzzW8knT2nQkJWAAzEa7vABhbulvFDQvEOHfKAgFK4t6iRYzyViFOuvW6Jlv8FVXBuIbA+KrlXR0UUliJoHOQ6FfCipLuILhllkLExtnQZJzKb2vngM/RYy/5Pe4wCyoEfRizil6xU9onkETzPJeQMO43U5fqLh5VYbuHm3PJ7j4fu/PbkW2uWax4H8s4+jB0rUgysPRSspQZGLG7NshwkFrdIpsbz88FvqIjFC+E9VUGJhcZutCAhp0Pb+XD3PtNWa8Zele7DxdLIVSLXPeuwVLX6CmhQMew1TLXSEFQGyxLKjTyEwWY1+jxphcgtN2lMRVsynddspU5O5Q2DiPt5qSNOomlxY07aVnO/5GB2eMSzpwpwMWKpdZskKMMmNYLbamoekwYdxs6lxK6sEdqoJlEOtfrm4Bl+WdL809N9/RvCAUtpFiBCo6uvC15zrUTqlSPpuAZEjRYI/mLRcW1JFkIaQ812LwFIbd8Yj77QtTdD0QOCazKmze4pD6aGDoDN9Q28xNNK1ViVjDEMTPrZIb71MfJLvqMrCpX++4IRA4KyymaW8SD112PmNYIzcRs8aMhwi9MhZQMwvZ7k9QeCRAIgz8wiHoVunLijJv95evnNSHmfFD4xUKzeq0zvG6vRYP1VT+bYEiynozFDmN1LOW5u5I9J2quxuLY9hfh6Py7WyLppiQ8ShLzf+Sa6y3yvWAbJaAy2bzJygb4KXFhMEJ3CKiFB8aB/gzTO2wLiVbF+p9m2yzSSS
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(396003)(346002)(230922051799003)(186009)(82310400011)(64100799003)(451199024)(1800799012)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(70206006)(36756003)(82740400003)(7636003)(356005)(70586007)(86362001)(4326008)(66574015)(1076003)(426003)(336012)(83380400001)(6636002)(2616005)(110136005)(6666004)(36860700001)(54906003)(8676002)(8936002)(316002)(2906002)(478600001)(5660300002)(4744005)(26005)(41300700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:40.6744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d935b6aa-7f37-4a78-cebd-08dc00bdaba9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8849

If userland sets this feature, allow it.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2250fcd90e5b..b4e8ddf86485 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -750,6 +750,7 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 				 BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
 				 BIT_ULL(VHOST_BACKEND_F_RESUME) |
 				 BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND) |
+				 BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND) |
 				 BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
 			return -EOPNOTSUPP;
 		if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
-- 
2.43.0


