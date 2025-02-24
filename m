Return-Path: <kvm+bounces-39058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67ADAA430EB
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 820633BA302
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1297E20C477;
	Mon, 24 Feb 2025 23:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T/Ln+hIt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9668E1C860F;
	Mon, 24 Feb 2025 23:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740439898; cv=fail; b=WvqDBESVnzldMuWVLJYcNxmibHK9t9lAEtZzAqQJGJrsXOCUpsYRfCfS0EeXdNgPYE3YGqGXsK/ytzAOCuC8ZQmlEZiHTlMfcqlNDEMZJZ3qrVs02GcXls/6FnQr2cY2tduHmlOmOkRFfnJoPgLfbo2nC8ScfOki7OB8DP9v0bQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740439898; c=relaxed/simple;
	bh=rUfunpQsqTtWdJsomTh0QemcwYvR8d1AYrIrQA3wpNw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=txSHS/ryf+9iYATJZ5C7PakljgedQQl+ShDMvBF22fZ2J6Eda/ZsC8VapxeKCGgu8tXpi/eYYyoHEfOrHy6zuYZGARpCOH2D3fVvK6PDNT8xKoBJeHpO8X5vL9O3utWLaJ2N+Erhz30l4YjyMiomYDB7hCQtRZRdhMs0RQ7JXsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T/Ln+hIt; arc=fail smtp.client-ip=40.107.237.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzjc/dLqAqRcxLmUCeecLoW3qeNII30eVafUAvPFXdimGZwt505nCT3Bh+CVVYm0wSlr9oZ/b84mTI7RCDj2AYReSDIUaOG2SRUDrvBVegEfbqtmk05VbMpmV1JOL9qpOIuyvKBAKZuFuKVsZGPoKWQDpB5lMpFIpeDc2SIa9i4rHzJH08LTpvKP19n6rLnU1DTp9WprmIVvfIiGZgGaK+vp/a/nkUUhSfWeWZ7dPdizkStLHw418s7B5dJgtwJE+QzBu0Sk/IU0TiUAKMxp/n+CVl3hiiywDKvIHr5AdCMM+lZGVkhAVDfIYldPrU4/e1uXiDhkZkqRU392dhK23A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrNLgSpyn6uSR7DW0g5zjHzrVANNFNRFlkP9E9uu1v8=;
 b=ShWcpoZHtYTfNdFzYLJlVwMLLa4dVyPzSCtkY/pdsw8Sq/8Zh7Gg+HfSGTlDnLMb2nftI8GHPXG/ULB8RP8QoIUTxIOJqpsEIZ5daSr80YX4hoHwDGfBTwyBf2OHu3Uqdnqp9QdDXGyGAqzYCP5dtqIM3zpaEtKOMAlFKR+1Rokss10Sqbv0wfSGz4RxPJpr8cz+00SazQxu7LGTU10ws8PUFrZRwpSNG0A8tkWNxfxxlFkxal5pY6l3n8n9J+t3d7N/7WVgOm1iMWNw7AOqbVIYjFlxUVr8ZBFdZCsXYJCJBV4mm17d/jyWys2B7ouMxwpLWvVuy/WSzI+rGG28Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrNLgSpyn6uSR7DW0g5zjHzrVANNFNRFlkP9E9uu1v8=;
 b=T/Ln+hIt77KziUJup1RSUMLDmkUzr1qS58RPb6xzVw0AJL2o15Iym8SFpiAikU0x0tR5DfS6UW8s4HXJKW4DaRegHfn7hI+WagFPPxL8Xf7Cps7uUHHddp+CDN8PQQpMwfCraKM95FkP3t7teLmCxIhb3ZYJmBchcPvxRi1qeCjZaXp89b/5lfzZW8QMPDx5W0usCcv3M8Zuw9yTGAUztojQtrFqlV1w2s/iQz9ZAq9NWNuhxLrH5jZ8GOKTj4omn+LhLHp+RXN2pSBbfT36JNXY+xNqMFnEBmcgsQxE5nkQisZG5K1sZE7s1GETwA02uQUGxufovvQYKEMTudg39g==
Received: from BN9PR03CA0085.namprd03.prod.outlook.com (2603:10b6:408:fc::30)
 by DS0PR12MB6485.namprd12.prod.outlook.com (2603:10b6:8:c6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.19; Mon, 24 Feb 2025 23:31:29 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:408:fc:cafe::51) by BN9PR03CA0085.outlook.office365.com
 (2603:10b6:408:fc::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Mon,
 24 Feb 2025 23:31:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 23:31:28 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 15:31:10 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 24 Feb
 2025 15:31:10 -0800
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 15:31:06 -0800
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <israelr@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>,
	<linux-block@vger.kernel.org>
CC: <oren@nvidia.com>, <nitzanc@nvidia.com>, <dbenbasat@nvidia.com>,
	<smalin@nvidia.com>, <larora@nvidia.com>, <izach@nvidia.com>,
	<aaptel@nvidia.com>, <parav@nvidia.com>, <kvm@vger.kernel.org>, Max Gurtovoy
	<mgurtovoy@nvidia.com>
Subject: [PATCH v1 0/2] virtio: Add length checks for device writable portions
Date: Tue, 25 Feb 2025 01:31:04 +0200
Message-ID: <20250224233106.8519-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|DS0PR12MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: ee36eec9-7c9c-4eb2-c39d-08dd552b5d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S3MQA7oplWAWqXATnJd3Lw33O6v9wseWho5rvwnUAsAQ2Pk7hI2QKxKQ6QBR?=
 =?us-ascii?Q?R+1Ehs16fwU28B6wTbki9DSqi1NgVh9t6PaGIcQZ6veFwrSutdLhtjHcafy2?=
 =?us-ascii?Q?Wr8Ov2/LH6IM4wjwoy4/dTDqByeP4rXD+xSBDeoV6t3qiBSu2sgZ3xecRvwZ?=
 =?us-ascii?Q?fyXTVpP2t+SJPZaBh3Vy9oSsEyZvy6L75UJ/RCHjsksAbjZqfEGiqzZzWXnm?=
 =?us-ascii?Q?85GjJyW5vJ5LI7L38iC9MMpnLtq0n2W4jAhmi1mAIDWwbKFmW6FCpS3TX44v?=
 =?us-ascii?Q?WRDSbeW97q5bCBxUMULeK9I6N0ysBl5Wu4CCn62uduEN/4hIik8xHUGWENWL?=
 =?us-ascii?Q?cUewFK3iu3s83Da3ViURGAOgRW99rJzplfX2sazl7sdXP4b3apHMgbNg7vJT?=
 =?us-ascii?Q?ilhoguevvMDybgPGGvjx/7G/MnlRTDn0Bm37gYzSnKjYs+r0VTCa7u2DI/rd?=
 =?us-ascii?Q?aB4wcJm4EErJ4tPPBMRmRbNOmXkCdr4jhjLMqnqddR55fF5gMAhN4vOKLrRC?=
 =?us-ascii?Q?LPwqDDx7a/FTdyW9+I45xOizUhxcSqOM3+tbdXD+vvOi+fiwhOw9Obl+XolO?=
 =?us-ascii?Q?0CiQp5ofxc9Cze/e2Gx/LS1Qd17KRG7iHsOABQHLVcZfY0rXR1+6Hyo4lZ46?=
 =?us-ascii?Q?vf0dgNCP/fgmPiwKvHLQws1pdc0cZimPJ2jxFMtXRrkZfYPHkeIMbQTju9DR?=
 =?us-ascii?Q?E5kYoSDaJ9cNS4FCY/v7pfpUKSYIQ5ee73J2KH/fq80tP0Big3g7CCdmPDL6?=
 =?us-ascii?Q?iSd4QSfFU/zbhrYjEqz2w8fG3oGDoDsuRnSIszYj6uWNFtKFqRDUzZfRot9c?=
 =?us-ascii?Q?VQGP0qw6aKSjeEI7qoaMqMdmd4LaXXpUThzPJWTMgMGx7Ny6HKHJ1WLmXORz?=
 =?us-ascii?Q?8QkKNYF8nYp92sN5JJQbWSDBVBgpaCfLp7erR7/Xh/mGBtOg7L11E3m0gx/3?=
 =?us-ascii?Q?zXMEP6+7F9A1oyswQlsrRL7zWTJAMjoJG/9YO2k9TdSsqfmPWTmI9K0I3JpE?=
 =?us-ascii?Q?nLpRnSRIlFlTG93RleINSQ9zyT+09M9shOtmxWt2hmCKQUIl0VyxLXGphRuB?=
 =?us-ascii?Q?IqKJJuEWEioyKkbl8ZI4J8iA1JzXICAK6wcHFlAs35CiYaJgXt6K0zcbrh3b?=
 =?us-ascii?Q?YwFZ+eqfZ1mCugfBfKzeftssM++Iwje9zh0JD6l0QMuigUn6uXzdMr4W6uAq?=
 =?us-ascii?Q?/bDN7SesIgUZR8IMbPC45q+MN5k67+48yyadZ5mlSSbiLm99/iaqyWNVswqh?=
 =?us-ascii?Q?MeGjmPMsIyX5sK4PGiTjxpLP7jFlf5WJXX/Kin5xftKJSq4L+mj+36q//r2Z?=
 =?us-ascii?Q?D1+/g1AufcQv4Qfy0XVUAs5+eShEB7WmlRH7hdHpQELYaSGsorb2kvO5mtgF?=
 =?us-ascii?Q?IZOPpFkJDFc3oqrDDvhyW0Pp+39NfKqe0UFYw2wmO/k0YRsDsts2eZ03wbgN?=
 =?us-ascii?Q?xu/++FuSy8vVRd++ZOaBovNDRjS1cKKxw1BGkPQmBMBJEWk+vFIo9QvbxRo8?=
 =?us-ascii?Q?fchLZkYtP/SBY7U=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 23:31:28.7650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee36eec9-7c9c-4eb2-c39d-08dd552b5d0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6485

Hi,

This patch series introduces safety checks in virtio-blk and virtio-fs
drivers to ensure proper handling of device-writable buffer lengths as
specified by the virtio specification.

The virtio specification states:
"The driver MUST NOT make assumptions about data in device-writable
buffers beyond the first len bytes, and SHOULD ignore this data."

To align with this requirement, we introduce checks in both drivers to
verify that the length of data written by the device is at least as
large as the expected/needed payload.

If this condition is not met, we set an I/O error status to prevent
processing of potentially invalid or incomplete data.

These changes improve the robustness of the drivers and ensure better
compliance with the virtio specification.

Max Gurtovoy (2):
  virtio_blk: add length check for device writable portion
  virtio_fs: add length check for device writable portion

 drivers/block/virtio_blk.c | 20 ++++++++++++++++++++
 fs/fuse/virtio_fs.c        |  9 +++++++++
 2 files changed, 29 insertions(+)

-- 
2.18.1


