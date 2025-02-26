Return-Path: <kvm+bounces-39397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A2DA46C2C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A473D188D186
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD722586FE;
	Wed, 26 Feb 2025 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M7MpuI+L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C3522332E;
	Wed, 26 Feb 2025 20:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601010; cv=fail; b=BiMkkwK0s6pOIn7jg2ODhHVPQyn2ii62Bl+l5zptNB9AlzCkl71KReScLeb2iLns+DZQXkYBt1yCvhnW9029qpmCfGzmwkS6HMMOIOSWBtXOnqo5apnEamI9vn8OtqjDo0d4zMP23dCiQqIpJGhraPXIKsdBeUXewklUJTvlkFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601010; c=relaxed/simple;
	bh=4TSgE6aow4y/CI0OOQrokPEy6qGfm7Iq5sn8GyDMrs4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JOrSmcrpaxBcGebYJfG1oPV6tfvccLRJEZJlrXG3U2rv/DcynOTRBGo1458imSQP/MUnghIUS16tLfMTtsO+Ls93sT+mjFsQdTDW5phY+qzDP/Ic6DxSNjSCDs4QcgxiyvphT/zKkU+5enUo660uQCGZw0AuO1xx3yfLLo63BMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M7MpuI+L; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TkmkQXazz2Ag7UAN7+S7AEaO9zcucIahukYfMjuMWYXiYHSl3HNgzy30+haCrUNzG+9MjTPZmAA9Q39xIs4UflRzOomSKAiaQ44A7Er8wRU3Ja8AD0ayssuPsIl3cg7RUyvRDkFouabGIGPPNXH/agSr44eS0KCASrC4MO1k8H4x04LMreM1tri2nDfsn/GWbBhPgFtf27/BkrJSOOmj4RXXOTIT1H43ZnzJxAMUTWsT7DpLpRM/mY5Kg4abcLjRk99USmCA2v70DCwG0lgifROakc4iAcUzwubezrATeO04OtgRMPU5bWLhOwcaJids5Na+Sfft5OJtpLETp2CtBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ADqWT4qaXL0SmK0U22God431q3y5RDr8U/+AT+sTRs=;
 b=zHZcJoUtqyrQwL0BKE2XIqet50+Hi9gy72kWHqI8Kio3DqTokqSFb3bd6jqM3lFYmfFtYZPwnFbkTwjJ9TjgTDW1xTfGHp/AshkO268WzdaJHB2U+Q23k8Kk6w9YcLMlTyCBcG/STA8sW1QqJ0Ymue8fJ5yYRV/Hj2DuxciXdXD6QRiP/kKgUTQRAfvb90IqiMMnE0Q7BLlvc+ExvA11vIgVCEMLEroGPxERimSP/AX2188WHsp/rRnzIJsszYycEHXmtuEAUx+NNiquyUjtecFBa4BB4DI8MfCK38LKpoE78rN7qhuccL5ogPEqGiMB7N+ieQhUZuNi94lfMojBiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ADqWT4qaXL0SmK0U22God431q3y5RDr8U/+AT+sTRs=;
 b=M7MpuI+LFJaJ6h7fdQSKKFmfG6eS7Fj0MxeGFx49k38MJ+hkzbt1oPjEbwOT/sSXXQJl3v6uYp0RA4utmqwpKttFxoJ8DZKMPqbep04UPwrOcjZwlGwrwowVtc2LBwFOrONabxAwvGZlD9J/9AujgMvYVQV/AL9/JtN1OvHDkwBW/kqU68FHoCOFa7Xw1TpdGELo+C/0J3Xa5UtnRlL62Ri7oD+MDUJ0XYtdlujv8sfxdNA9PVFuBNbQ8oGjD4sSye/vKQcEWbhJhV1szIYCrvJZ829AAznBfXVi84j9VsR78/TROJ7cEtQkG7rTmRum9Gq3wm8EGATKTj3uZHDyzg==
Received: from PH7P221CA0082.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::21)
 by LV2PR12MB5965.namprd12.prod.outlook.com (2603:10b6:408:172::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.22; Wed, 26 Feb
 2025 20:16:44 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:510:328:cafe::28) by PH7P221CA0082.outlook.office365.com
 (2603:10b6:510:328::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.18 via Frontend Transport; Wed,
 26 Feb 2025 20:16:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 20:16:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Feb
 2025 12:16:27 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Feb 2025 12:16:27 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 26 Feb 2025 12:16:26 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <robin.murphy@arm.com>, <joro@8bytes.org>, <will@kernel.org>,
	<alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v1 0/4] iommu: Isolate iova_cookie to actual owners
Date: Wed, 26 Feb 2025 12:16:03 -0800
Message-ID: <cover.1740600272.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|LV2PR12MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c5f15b-5d2b-4d1a-ec93-08dd56a27ccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WCUDC1+7WIw5xLhDO49d0La4d6ko7HQDikrIHG5S/eTQrk76dZH2F5ALgzvj?=
 =?us-ascii?Q?NJFTlu8Em5NMoU8POP56eVLO/y3m0+iB9BQ/s7hooYuOL/tlP0FsXQxa4Nj0?=
 =?us-ascii?Q?07R9TatH3MUkzgj4xOsFlx6ZaroTMzX2Cr9W5MVLtpMtECBvuV8kWAg/293K?=
 =?us-ascii?Q?Zl+lpJEVVCwDDKOadggLGrnvakqEkeXtWzPrQKe7uY9G0RM8ZREENIxC8xrH?=
 =?us-ascii?Q?AWCrwOfJinyjkhBZIcdop/jl/9Gsfz1k/aWU7sMQFcY8Jgu+KAmIhWS8wydg?=
 =?us-ascii?Q?7v9Or2PtmJqcJqlXNtIGz3ESsEP87ioCjd8Ew/ue0JP07uJ7LtffajMfJXEq?=
 =?us-ascii?Q?+ar9RAa2FnV+9Dnb0olmHgW6DZIEiUlKD+BT6MWW2kjA87aoSynpGjdC7U6s?=
 =?us-ascii?Q?5vDknW4SEapYGrw4efTgEQWsh5Wd47uJwTACPNgFUnypv+K2PE2+UTNbrN6l?=
 =?us-ascii?Q?wa9xjZdNFGA7trpE7mcHt0XuD18/uTH8l8YYNS4xkiMJp6u5RAg2otycvfWX?=
 =?us-ascii?Q?E4OsLE0jvxstQYIEgKz7dAVyNVM4vvim+9Ky9DM91WKRvu4OHQPfLdazrcj9?=
 =?us-ascii?Q?NVqUITgucq0skRsTjbV3DSItkmKLp1DyScOJZp63qb87tU44kXP1BEVTz4IO?=
 =?us-ascii?Q?j5XNZQjqvUn4ZN6pMTw1wtWcmTcXH4KABjnV/ZpMFecvpK/j/EYyzGbkzuWz?=
 =?us-ascii?Q?rgqGVxlqiW2GNbYs+YgtbP+Lc72kG1TDxIkmdugc7CP26q3t+O6OTaDX8/s9?=
 =?us-ascii?Q?iC1ZaU/jYuVZASF4gNsmIPT3JxhP3z17PTEOSAVcEQ+PJoKTQKYaqwYgGYCt?=
 =?us-ascii?Q?RWCLb6Yq7Tqdu3H8IoqYfEe7VsLWvHr3yjGxstxwZtMzWVO72Yb+8Wh97dKY?=
 =?us-ascii?Q?bVS+dMGPJOm0tuVAxxEqsBHY/qlqeHRT0WELVSCgw/BOtKpvWkIRQ/ty154r?=
 =?us-ascii?Q?73XCHGz97e7i38hgpB1djriz/e3Wv/3oMqUoUpbbfxgnMe0Szo2yMwiA46v8?=
 =?us-ascii?Q?2y0RuAltucP6mcKMNRUO/vzxutpqVLTC0ophhI7xUilkC8/+QxxYx+wx4SZZ?=
 =?us-ascii?Q?ty0lCu3RJAT34yXSHqP4lvYepV+Ze5F42b7J1HcSPHr6/cMtDv+dd2AMVohS?=
 =?us-ascii?Q?Rh5YUhw0ifKrlcsuLrnbtXHH2R4GYov/yYoKYgQx+TDcMDcpYTJPtkw3Jrx7?=
 =?us-ascii?Q?G4kvv8yGK3WUusTcI9PuMAQc5TZoQQi7LYcli15nJTBTOxRxgzn/UNBp3oAO?=
 =?us-ascii?Q?HMrInnzOFPeA2YwJWh3E7ZQpYvYbXcRL8xaZIfFpn/hVDmupFVSSgsr4ObmU?=
 =?us-ascii?Q?XYRD+wDCF1jM/thHLufQeLpORGsX3lmfp1SPw0T7ZeS23owO1VPOkvdZemp9?=
 =?us-ascii?Q?wPgwXg+ayqI4pMm3mdLIf2Bif/wHPEezTO5ys9IiFxu5MQdCnoP/CVa+RP9D?=
 =?us-ascii?Q?kpPjZIWPYsAlO3Cy5W4XIzzh7nFpBXHS77AN6PuNX2X37XmYa5gHF5X8QLwx?=
 =?us-ascii?Q?u6uhRzps/9ESCMo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 20:16:43.3633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c5f15b-5d2b-4d1a-ec93-08dd56a27ccd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5965

Now, iommufd implements its own sw_msi function that does not touch the
domain->iova_cookie but domain->iommufd_hwpt, as a domain owner pointer.

Isolate the iova_cookie from iommufd by putting it into the union where
the iommufd_hwpt is located.

This requires a set of preparations to move iommu_put_dma_cookie() out
of the common path of iommu_domain_free() that iommufd still calls.

Make thing cleaner that any caller of iommu_get_dma/msi_cookie() should
explicitly call the pairing iommu_put_dma/msi_cookie().

This is a clean-up series for the sw_msi Part-1 core series, prior to
the Part-2/3 series. It's on github:
https://github.com/nicolinc/iommufd/commits/iommufd_msi_cleanup-v1

Thanks
Nicolin

Nicolin Chen (4):
  iommu: Define iommu_get/put_msi_cookie() under CONFIG_IRQ_MSI_IOMMU
  iommu: Add iommu_default_domain_free helper
  iommu: Request iova_cookie owner to put cookie explicitly
  iommu: Turn iova_cookie to dma-iommu private pointer

 include/linux/iommu.h           | 12 ++++++++----
 drivers/iommu/dma-iommu.c       | 12 ++++++++++++
 drivers/iommu/iommu.c           | 13 +++++++++----
 drivers/vfio/vfio_iommu_type1.c |  4 ++++
 4 files changed, 33 insertions(+), 8 deletions(-)


base-commit: 598749522d4254afb33b8a6c1bea614a95896868
-- 
2.43.0


