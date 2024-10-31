Return-Path: <kvm+bounces-30128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 905669B710A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:22:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D40A2B21341
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2477359B71;
	Thu, 31 Oct 2024 00:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t4dnD2W6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BC61CA94;
	Thu, 31 Oct 2024 00:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334077; cv=fail; b=Ra7CDp7wzYtj/ShxcgO3i5Wp4WV9U4rMIOf8nuScnSW0YsbmLcyBPB+6DhcmCqJ6mgXZd0VnXakKFk4bnTwsIv1WA0FKdkNsz/fjhUTeoDfhqvKOE1RzJPjCM8udrrUijouI1GA0dUpvzS9LwCceouKKrTCR9Yx2nvjWu99UCF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334077; c=relaxed/simple;
	bh=OWdrvXJNmz3vSlmNPfPGsAQSfbzSVDQmLjH9GSo1C0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KK+xvsg5vgiVMugRWlosvQqGdKOl/s8cPhPoZLM4p4IvNGNgxH6VxaUKq/hU1gRYSTB9/TEw0A5LTwR2Fh1KXNh71jNnLAe4b6SlYSTnmidth/5sZp4yS6YVkLqBSAsb6px9KCwRFtU4tFAoyFFEnKf8Fn7FTubG42fP38KR1iI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t4dnD2W6; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ld9qJkHZXKNVyxnszI7IoBXgq4mUmJIhVy74tQPZhV1ysrPwR688WRuZYNipA6aFIaKfImlhd1l8E4UreBhdka++0fdP1RsGe6DIhUpPij0mS14A+23rUXhov0pinO0U+xQZ6cF/WmocgQH79DF1rCdixCJUc8oHGA8jLSqG+cUFhQ0JcYzqnmeSuZgTd8BaMP8KEu4tDp8LL7Yn7weYTp+pggiInFc8rbCmOK3mGmWEVnOdtqXbD0JBuBger8fiHfh7t/eLQV/P03maT8uK8I1c30bvD5QGmrXml58CEmZgyEEe5DeFNmZgfMOOLrMtuTRINlmrwLoXjDcgtjQn4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUrizam2cKPn6hPBSPSXvm52fqIcuui6I/EjJCcz7P8=;
 b=fVRlJLSrhQDubk3Ilriur2/Bow6mf5QAKM61FM7NhHZuuG/SAlARPCbQgaJc9BuPr7xMWkXrzpTmSTh1lGGT6Hq0HFdAuKbL37KAOgCZNRgJR6rZXEvD+85KvFsQAboEKQbN6XRimkNTfoLUQZpDr13ty+O2YuXvyhDFkhGx00pe2RjpVzGS693y4QpfGruJzMotafMgOaEonsUXwqJ5WB2n+CyoxvJCzSg7F/xN3LC8YhR8AM9svFYBoj6c2lEgAXcQoBVMDXou7H3LyRj1TmccMjGrb2DlL773savUZzIrBkwsm1o9vUw/0JOQtxoopZcwBdReHvHDhZJ9SbirAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUrizam2cKPn6hPBSPSXvm52fqIcuui6I/EjJCcz7P8=;
 b=t4dnD2W6COMgcSJpdesTP2uciy/IOF2NMVjHpFExhojv274B40CeAJddtdMIvVEUly66bKXrXih6RPDMRgR3M46dBXIHhyyqNGLIr16rQ6d3P5uaHl6/dOPgV7I0vuk9ey7yLikB7BLPkYWdC1qHMaDTWdyONSRLDECOt/WSFDk1KHeqH91vFqvRw55np7PBGIbJOE9J1rAu3udrNSMMjO/AzcOdCuNzOK8lsErxdLPT80Ys3L+yV0ti6oG/v5nQGN41BR3g5EsuW6oDAmqW4WaQDfg2p4H4PW0y6Y6/lwYjdLm+MqVn+q+ajaeBHg9ErUfREU3vKRsrgsaNq4V5yA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:20:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:20:59 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 11/12] iommu/arm-smmu-v3: Allow ATS for IOMMU_DOMAIN_NESTED
Date: Wed, 30 Oct 2024 21:20:55 -0300
Message-ID: <11-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:408:f5::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 9205bb15-2a00-4249-f05f-08dcf941e434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?USnDoD16de5guSGoOCc1D7DRzaR6Jfsv0H2W9ouz9xWWPW24RdXUI9HkfYP2?=
 =?us-ascii?Q?w1RuppTP87g8LwQQSJWQfJKin8fpDvP7C4hfsVzjyQrb7SCB/b07rwqN5A4+?=
 =?us-ascii?Q?zC1Q6nxwzDFd5RkAXehKeexkNxhIdcufCVymxVAeF7gGuvytLnle1K7ZvmCY?=
 =?us-ascii?Q?5f/ai+FQqx6SOI1ozWLwWzsEaFIzpMtx5Xz9kxWJj6hWO1DvEh3a1l9d139j?=
 =?us-ascii?Q?ENskbI3Ul/mOEJnR+dBUSug2H6m6DbYq2xNGBS7x4qyduo+ZNB87vDNs+saj?=
 =?us-ascii?Q?/ldlVz5WXqakimCNZtPK36h59wNJBXDHAZLbid0oA0dgzzIBxOdLk6U6bl4R?=
 =?us-ascii?Q?1ELRhdF2RtxubYcFhwXd/m93BYTIh/XrSk4YgcIxYCcoGyC7qBe72lVBDGOo?=
 =?us-ascii?Q?oAnn1Jksk9Yk73otV2EWVw1BuQAp50q4CFvUifxskztIN9wW4QUI7OKHugF0?=
 =?us-ascii?Q?o7eoagRlYl1D1G2VCeA06GCr/zLDuujlLHzJ7AJcgAIB7KOmStj47s8MlBjp?=
 =?us-ascii?Q?QbI5b/Ouf2OJXvcWknFiH3TZA64ColybtfNFV7//ISYi9yjKHZYzrlBmKVjK?=
 =?us-ascii?Q?ozyfuo4pbFDBP6N9U8o1/AGYrL48R/4433dwImofL1YgKTRbwZ1U8ZPbWJ0S?=
 =?us-ascii?Q?aFheqoDyfUXBfeejXeqpOHfP+UOp0x6N9rZL5xC7XVJLQ8rj55vN2XiyS2br?=
 =?us-ascii?Q?O9w57F+q1G+U6U1dEGngh8N2eBzE7ikOVvt6A2QouM1vQ1lGiSGKzhWbK5ZF?=
 =?us-ascii?Q?11mpezuqLVVYPZGx6PGURHPDKtkxO5tgZZQAAvOmtaQv0YV9kqCpfAWuRNMS?=
 =?us-ascii?Q?2X2W4wPGy0ovuQUSTSovfI5wBXmD2GHUbQISd8EWQiLBi7mEN5GgNsJVxajy?=
 =?us-ascii?Q?VnZsgauX00i2JPs07b0cA7+LZv1zgiJsX/nbHDValg2FCXe0XktFTADbx6QP?=
 =?us-ascii?Q?ZahHnwMi0uw1/EGqo/9glWnXckQOc72Qm7b69Q+RDTQSNxGZJ5dswZOJEsQA?=
 =?us-ascii?Q?oDxdQX+WsMFA+c77tteQFEu/hGEP9AYJIcnj9wzovZPi9vDHafhfKvvvTzt6?=
 =?us-ascii?Q?3WEH7xZfI9xBGdhnvvDVnG5WQKD3MP5/ETExNg3Iso0aFHniDyibYpZY4Xzj?=
 =?us-ascii?Q?ZchUIL6ZTJNqVIzALQFkb7GdgZjcblC/DDu+AFL8F1DHvmZGB0udsyFM9R4C?=
 =?us-ascii?Q?TBHGIpVjrcuRRZBFA78Jj05L92AQ+rfjckpDIobXfAFxsLEQcIESSJ9VPYJN?=
 =?us-ascii?Q?60HhKnxP5yrGJzdc/5wamTFUXfTfTIOr8u878wLHKUBu0FXbPRBVlqNACkTy?=
 =?us-ascii?Q?r3fTVqTslBdvKgJmniaUAjhtf229vEcpgqIqRjIBsCoHxyyBlsT+KrxrzLdc?=
 =?us-ascii?Q?WaeKlSI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vy+2OyafwJ/IXTSqGCbckhYTGJrxJdDwXhcqGoXr4QzGCzipwQsyS3N4Bwe3?=
 =?us-ascii?Q?Xd1L6XIzV5O5SZE1et2OgcwcYw3+vN6xqT3jXOiTOjcvxLMqdcdfhXh/XC5I?=
 =?us-ascii?Q?LREYnwtJ2+qm3N4K1XVLfO0RtrEwPVb9INfradO5TkjrwwsocupcYFlu1H4k?=
 =?us-ascii?Q?i0F2toWqs99h/HkAomgEDIXDyBi6ZfYyiz9I7cU/ibISqp0GhLDSfLeIvUOz?=
 =?us-ascii?Q?Q2QBTV1dETCrVRwuBhKr0OH3JWNP6YXC5D4f5mgzVTfRWotFH5m3aPVxQ3HM?=
 =?us-ascii?Q?QYu4bDDxy+Woo5eIarRWrT2pPl9J8MDDFE8dlrMEplt6k57zgLEfotIkJ9NR?=
 =?us-ascii?Q?9uxL9C/3ddd6KH3hJEHwhNbNmricnuN93/DNJoKOp81MBaIZsfnrLyJM/jd8?=
 =?us-ascii?Q?OEiYgiaf+n410tZeku9Uqxy2W2EzG7aToUCzfUSUZVlJoDS6wyT7L3M5074k?=
 =?us-ascii?Q?Cx3z2ai+MFehCR8vp9OGRLmHktPLNHY4X2tok0LAiB6xpXPWNNpixtkSic9B?=
 =?us-ascii?Q?NDAiJzJa45PbUdC7D0S2RS8lQ+plheyQN1YLbK66c2TZMD/gVSJhvwf3Jric?=
 =?us-ascii?Q?IepTTttzqwooVz82YPzv6NcAJYJWvriwK3MnyFCOaoEL/VVI7P4PWIeMDowS?=
 =?us-ascii?Q?KN2fVEXKPawcArqckO/NoQfCXwA6Q9Q3MecvtvvwScGE86s/oEQ5SgaWH0ht?=
 =?us-ascii?Q?NSiRZHWhcoqN0u4boe3Nc8V9j2U/RFCVldFjy7H1qrUVnJ81y6guH5OhWc2h?=
 =?us-ascii?Q?GhK584K86PD/NqMai3sDybW1733tj8kOTjUgHObwfw2uoqAnbyQJN4ywcJ6B?=
 =?us-ascii?Q?vO+joqsK6jFRZYJk3sp0HDv0bnjO1b3++hQpRbfsIVdOPO66A0nyjVk5UWP3?=
 =?us-ascii?Q?OsV+bRPFffGGrQrMeMloaQsczoNBvzxMw6XEqtGpXEQ82ZTukR++LFtyEe1z?=
 =?us-ascii?Q?cISdJppx+5Jx/1mSr6hT8X4rBua+PzS6SBrLjU95d6JGLEwktmeu/5dGr1UB?=
 =?us-ascii?Q?WJdY1G5T/oyK871YqCx6yomkQg6ng4vItCyXE19Xa5onf70arBB0fbfcwNAZ?=
 =?us-ascii?Q?48NXmOZVzBq51nMVZSIUjqPkmezO1Yc0ErwGVyxAe1egKO05URGmYyCh+KZN?=
 =?us-ascii?Q?KOszopJLqeoXESKySjvVrQtfgJ0d+VGwtFFpfmrwl6WkqdG7HNvd75CdgfN9?=
 =?us-ascii?Q?ZeRnTOEdTMexPNPrAJpszSiEQoeoht4ATNo6TnkZqNDGozlhQxrZfgcNjuKm?=
 =?us-ascii?Q?4t3OUW7KGpgTtQokPRSEBbPN4mT2UP6h1PtD7ydAu9vSbEGRrZPX3tyj1Zx6?=
 =?us-ascii?Q?+G6zQjJYPCOzMU2zoynSj7qPKRaMz/4oaqSAdb6V5P3W7O2yXjWHD6ARkely?=
 =?us-ascii?Q?lEddJt4lFjVmQRdjDDjv9ZM5DG4q7FkyA/J14g5JH0nIrLHEC1sUmcQ9kCwZ?=
 =?us-ascii?Q?o4k6hT46WAs6EVYcWZ61qcY6QK91xELdz8LK9TnUDzgWYLuV+687Rg41yfsa?=
 =?us-ascii?Q?A9VtcraET+TBOVR2QCH6FQBKofMtE7TA/B//pRVbYn8mP+DkNYuMlusGMpc1?=
 =?us-ascii?Q?42JE69S6kClYM/s70eM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9205bb15-2a00-4249-f05f-08dcf941e434
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:57.8617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O8lqvmcmTKX+Bm5CtVZ5Nl2Jbhu7q35tOfwE0viXJGrmCEudFhejrI6lZ8HhU81I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

The EATS flag needs to flow through the vSTE and into the pSTE, and ensure
physical ATS is enabled on the PCI device.

The physical ATS state must match the VM's idea of EATS as we rely on the
VM to issue the ATS invalidation commands. Thus ATS must remain off at the
device until EATS on a nesting domain turns it on. Attaching a nesting
domain is the point where the invalidation responsibility transfers to
userspace.

Update the ATS logic to track EATS for nesting domains and flush the
ATC whenever the S2 nesting parent changes.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 31 ++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 26 +++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 ++-
 include/uapi/linux/iommufd.h                  |  2 +-
 4 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index b835ecce7f611d..ab515706d48463 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -95,8 +95,6 @@ static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
 		.master = master,
 		.old_domain = iommu_get_domain_for_dev(dev),
 		.ssid = IOMMU_NO_PASID,
-		/* Currently invalidation of ATC is not supported */
-		.disable_ats = true,
 	};
 	struct arm_smmu_ste ste;
 	int ret;
@@ -107,6 +105,15 @@ static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
 		return -EBUSY;
 
 	mutex_lock(&arm_smmu_asid_lock);
+	/*
+	 * The VM has to control the actual ATS state at the PCI device because
+	 * we forward the invalidations directly from the VM. If the VM doesn't
+	 * think ATS is on it will not generate ATC flushes and the ATC will
+	 * become incoherent. Since we can't access the actual virtual PCI ATS
+	 * config bit here base this off the EATS value in the STE. If the EATS
+	 * is set then the VM must generate ATC flushes.
+	 */
+	state.disable_ats = !nested_domain->enable_ats;
 	ret = arm_smmu_attach_prepare(&state, domain);
 	if (ret) {
 		mutex_unlock(&arm_smmu_asid_lock);
@@ -131,8 +138,10 @@ static const struct iommu_domain_ops arm_smmu_nested_ops = {
 	.free = arm_smmu_domain_nested_free,
 };
 
-static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg)
+static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg,
+				  bool *enable_ats)
 {
+	unsigned int eats;
 	unsigned int cfg;
 
 	if (!(arg->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
@@ -149,6 +158,18 @@ static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg)
 	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
 	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
 		return -EIO;
+
+	/*
+	 * Only Full ATS or ATS UR is supported
+	 * The EATS field will be set by arm_smmu_make_nested_domain_ste()
+	 */
+	eats = FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(arg->ste[1]));
+	arg->ste[1] &= ~cpu_to_le64(STRTAB_STE_1_EATS);
+	if (eats != STRTAB_STE_1_EATS_ABT && eats != STRTAB_STE_1_EATS_TRANS)
+		return -EIO;
+
+	if (cfg == STRTAB_STE_0_CFG_S1_TRANS)
+		*enable_ats = (eats == STRTAB_STE_1_EATS_TRANS);
 	return 0;
 }
 
@@ -159,6 +180,7 @@ arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
 	struct arm_smmu_nested_domain *nested_domain;
 	struct iommu_hwpt_arm_smmuv3 arg;
+	bool enable_ats = false;
 	int ret;
 
 	if (flags)
@@ -169,7 +191,7 @@ arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 	if (ret)
 		return ERR_PTR(ret);
 
-	ret = arm_smmu_validate_vste(&arg);
+	ret = arm_smmu_validate_vste(&arg, &enable_ats);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -179,6 +201,7 @@ arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 
 	nested_domain->domain.type = IOMMU_DOMAIN_NESTED;
 	nested_domain->domain.ops = &arm_smmu_nested_ops;
+	nested_domain->enable_ats = enable_ats;
 	nested_domain->vsmmu = vsmmu;
 	nested_domain->ste[0] = arg.ste[0];
 	nested_domain->ste[1] = arg.ste[1] & ~cpu_to_le64(STRTAB_STE_1_EATS);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index de598d66b5c272..b47f80224781ba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2107,7 +2107,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 		if (!master->ats_enabled)
 			continue;
 
-		arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size, &cmd);
+		if (master_domain->nested_ats_flush) {
+			/*
+			 * If a S2 used as a nesting parent is changed we have
+			 * no option but to completely flush the ATC.
+			 */
+			arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+		} else {
+			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
+						&cmd);
+		}
 
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
@@ -2631,7 +2640,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 			    struct arm_smmu_master *master,
-			    ioasid_t ssid)
+			    ioasid_t ssid, bool nested_ats_flush)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2640,7 +2649,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
 		if (master_domain->master == master &&
-		    master_domain->ssid == ssid)
+		    master_domain->ssid == ssid &&
+		    master_domain->nested_ats_flush == nested_ats_flush)
 			return master_domain;
 	}
 	return NULL;
@@ -2671,13 +2681,18 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
+	bool nested_ats_flush = false;
 	unsigned long flags;
 
 	if (!smmu_domain)
 		return;
 
+	if (domain->type == IOMMU_DOMAIN_NESTED)
+		nested_ats_flush = to_smmu_nested_domain(domain)->enable_ats;
+
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid,
+						    nested_ats_flush);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2744,6 +2759,9 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 			return -ENOMEM;
 		master_domain->master = master;
 		master_domain->ssid = state->ssid;
+		if (new_domain->type == IOMMU_DOMAIN_NESTED)
+			master_domain->nested_ats_flush =
+				to_smmu_nested_domain(new_domain)->enable_ats;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5a025d310dbeb5..01c1d16dc0c81a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -305,7 +305,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_1_NESTING_ALLOWED                            \
 	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
 		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
-		    STRTAB_STE_1_S1STALLD)
+		    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_EATS)
 
 /*
  * Context descriptors.
@@ -837,6 +837,7 @@ struct arm_smmu_domain {
 struct arm_smmu_nested_domain {
 	struct iommu_domain domain;
 	struct arm_vsmmu *vsmmu;
+	bool enable_ats : 1;
 
 	__le64 ste[2];
 };
@@ -878,6 +879,7 @@ struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
 	ioasid_t ssid;
+	bool nested_ats_flush : 1;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 47ee35ce050b63..125b51b78ad8f9 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -404,7 +404,7 @@ struct iommu_hwpt_vtd_s1 {
  *       the translation. Must be little-endian.
  *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
  *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
- *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
+ *       - word-1: EATS, S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
  *
  * -EIO will be returned if @ste is not legal or contains any non-allowed field.
  * Cfg can be used to select a S1, Bypass or Abort configuration. A Bypass
-- 
2.43.0


