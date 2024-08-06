Return-Path: <kvm+bounces-23458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C52D9949C75
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FD6E28240E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F74117A58F;
	Tue,  6 Aug 2024 23:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K8MbFPtg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71A17966D;
	Tue,  6 Aug 2024 23:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987700; cv=fail; b=lTmmJ7ctx76cqiLQxwDm6/T7oS+m1p5mBhS6KWNqiftlQOV1omjeXJQR6Yta0L0LRrQe5PhBuDdVvMwxx/8s9/SjiJaZpUzZGrhi5h1cXcVqaR8Ya9h28TBQ2yM2MLBGNWrBaa4l8I2D7RnAFVJ3hoHS2LS3R6iX7x68Ld1MJvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987700; c=relaxed/simple;
	bh=bBZJn5lvUHjg+zR9EfbvHIXFb8wD7ASEalzWJs0FKU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PDYoz8BiyBlq2FJ+GDIt5V4mS1x070vf7yP7nYIV1K1ts5PyzgprAaN5UOVYyA0oW/P7GzCAo/Pxqn8Ry6WR6TfhaF5NqkKotfF8h8CTDQKZO9Gtd+vQLJ1/CW4TJUJINafX3ulE4PKcB3P/BQMwDuDPOoWFxFVJIcZd0Kpig5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K8MbFPtg; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgUkJrUF70bn+lJdMggGWavxbpLJoA1JTGFHVAeCau1nKihHCDOhG96Cb+k6ieiAJiLmkeYCsYDDy5M4QZV5VKc4scV8vKuKN5D19txGpzDXTS1sPctz/yX6r3GUMRe8KaPl7G8KT0xj7vYlzy+tnLkh4i4GZR3eEq2oy0uN3CbTgcnB6V1ODmSgJ1CawAHg+Yl/8nfHCLdukGyt2Xeqqyf1Yfm/PSGHQDK4qCL9vIYX3lIcDGB3Fwt09ztKad3tSQNi/BvmH/KEwXLFuNpAYCdkc7ydApPjFeKIsVna7D2GbRaURy8YYkuFtV5JHYhEeqLJSuv4VQy5iXU/FYxmyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1sSWK9laM2BGthFnUvws9LO/P1JFlpBeLAmt4Rlb+A=;
 b=NggNVZ/7uXP+Y3oas7VN9NEqwOngUeLRGPu/kOVZJzrm+m3H4pP2GuMJWIK9sM6WBGzE8+xfJDhEjKUZ+mtqiJ3093stmFUFPCb7ogmaz9KFpHfcffjGDNh0KDc1g1DlsGdGfcKn8wxXS5uh95xyRAZoHNzUPR/ODJ9JRRLGjbbwmJ6FsvIl7sdXkA5LA5vp+8KOBXrE22oryyodQLFYHjvmatdho2jQ2ZeIEBibx3W0Qqyk3Bb/LhOsxCJl4XtTeSGVcsrsus9yBV5d52yiOuUhyJc++NTltGhgTuhx07TYekb0BeqZUEGH66oY4pP1Qz7KGMW9/EsH8xbmYTtX3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1sSWK9laM2BGthFnUvws9LO/P1JFlpBeLAmt4Rlb+A=;
 b=K8MbFPtge43buJWN2hjLb4pZce9ny1/z1wCKbQdz5JNqse9QgJkK5VNf7zXLqOA36UUesful1fggfFWiVOORpS9q076r+bZZ4X4pNdeAnyie52BVpC6pB8QRYnFRDT3UHV9rqcE4o/bq3zVN++iMaO+kXZAscVFqRbsxoy2sya42PxUrY/f9d5gpTt4lsTJkfQV+BPdqBSQ2HeZvBY17Q0vDUjECcKChJN0qCxJcDigjuwgEqFOjvao6BBp6Fx4pK/z4ovmJyuAy2EbI8b0JaRIdcUY5pfmMrKuyC6L+98DaFd7icP5KjBoItO3nCVB8OHHlglDtD/TJcuj9wLwh7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 23:41:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:41:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
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
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH 1/8] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Date: Tue,  6 Aug 2024 20:41:14 -0300
Message-ID: <1-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:408:e7::24) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 04c50e03-7cf1-41eb-7a3f-08dcb6714948
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kayzKn46Nl4Mpw6D5EVliY1rR/rKNTU/GcHyDSdGqnUeSVkpLQbFky1cETvw?=
 =?us-ascii?Q?liGCOxo3wqkngYnJSX5PSrK6m/ePJGrTjTVj5g8lz98Qlt9slvv4LEPcnOrg?=
 =?us-ascii?Q?DY0h3Gv9HQPqJa9szPLloXOC5PuHtn8f3Ms6EGBhLKVPXaQOuK7Z1XANogWz?=
 =?us-ascii?Q?rZpuYfW+ucLvB/cDcBrxxdvCuW4dH3zf0xzC9fwlv5lFRnFalhSR7Zp7B4OC?=
 =?us-ascii?Q?sFNx6nripfZnUGb6rIxKg+yZtGu45aqG8Q/jioX5V5IP7brt0NWggZkXjI0n?=
 =?us-ascii?Q?I2u96LdWZesUhA3+nldD6dNbjUrYulVDX7+0dEzijVFKgOxbNlTyrPmdfq7u?=
 =?us-ascii?Q?ZabJoaFE9EySp1uwBgGuL4piBtxN+XJF/e+Go6HMWvJm5U14vFhR8Ikufd/d?=
 =?us-ascii?Q?9gbilgUWd7q7nRhjvfVauT5vBfD4z3asLGq8K4JYm0c5Hpt+8hVieF97mPcq?=
 =?us-ascii?Q?vWGjkmrW/H7038ToaCtTCpqJC9dOpf92x2HiE+rcm7k9MpuLu9XJfE5PWF4m?=
 =?us-ascii?Q?1N7J1vTKvs/iUl+JPCiF8HfJxi5VtPtiWpkPi/rU/TJp6sYiozizIIWxBgAa?=
 =?us-ascii?Q?tYN9z+IWKTgzZ0xX6Tv8qbNLkswqBG6odRf1MuqXu0/DDfGhOnf7FfEne7Ct?=
 =?us-ascii?Q?Onk5E7qaiDtI51JuWRDaAE5kv6t9fQAPBpl2KeeY+Tp/oYEchpghVVefsrNc?=
 =?us-ascii?Q?SWBb1TococAYRnvvSybZhbtE3zxx5XkkmKvaj/QE3BsWdDH1ec9b5JSuVAm8?=
 =?us-ascii?Q?8aUH1hL2/TCq6qIuFeNJA9dAX00lmxbwY5X0L1UDJx1ltVweiZKWFSblvkLs?=
 =?us-ascii?Q?Ts7z/g9Stj0guMNV1Ipd9pOa5uhZZ8ubnROVNzOPAkNzJCzd1jtH41ewtUtg?=
 =?us-ascii?Q?s/Q7PznrP+CILutvpA8vNIqiYwidFh11jWOORoKzvBA3CW/+AvTJkYOFHbyy?=
 =?us-ascii?Q?EVMi0br/N3X2GIjyUgxgJR0bD7/p0IAIQd4CmUEk8RhHjgE0mYp1z1MKVlaw?=
 =?us-ascii?Q?gjyVtL1sJrJ2ippY8pn852SxHqUToIZwpfLC9m59Uo4jK/l1pkFfi3irGD0j?=
 =?us-ascii?Q?bKwr4zVDuhWnzI6jGSRbiXQC7SL1aSfYSbqTwlzgDISK0ceaScCla/GLxVUH?=
 =?us-ascii?Q?uxeu6TwOaHMOwnDLLMV8FetX0v2oFS9NSjGQuXvVE6f2A/XQAJrPt99fOrxa?=
 =?us-ascii?Q?b7kbA2UGNIMeVpKfJRlwvDdPgfEvBFya853NTiQNOZ1Z0420esZijkV9k6Gy?=
 =?us-ascii?Q?bfK+fWMMDqheuSqEdm2p6llGQOuKUbr4A7ne6uXV/cSyGsUlWGmMcfKEEX5l?=
 =?us-ascii?Q?ipQcE2fY1Y7CR3axx+CzLZ9bIpX9fJv/hmow8lbe5KbakxXqDSXGVFo6+M3Y?=
 =?us-ascii?Q?urHiu9zY4+623xc/N96AlddJOm0gHvd07kuRLsQvi2iIWP/wjw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NNDr48GkL09AXJ5DCp4f5FJ+mZ+hBdDO3cT7tZDWKjw+Oqr+kHSEfpjkbHJ2?=
 =?us-ascii?Q?2ewBqfFB5xBVYtTLyP2SQPlvNbnK/0e1JzLAd9bhErkQtidheOHd1PtPe2dQ?=
 =?us-ascii?Q?kC19CQM4JligdaI6NZGDveSYqGrZMzSYf2BGk7u6rZ8oPZn084Oz/ZyIyjQL?=
 =?us-ascii?Q?r3X2ttSfEhzXgdy9H/spMeCttuMU3jIAl41ZdJHYlJJe2vFRHt2pxQ3aH6cE?=
 =?us-ascii?Q?WiwZV7gzQ2DnVvirHotpwTUheRCctMJ37VSPWzwFi4y2uI4G0r/mz45YAHTJ?=
 =?us-ascii?Q?N21A++pgMsKEd/mdk4gtXKMugv6HDoazzfwEi6Pxu02kSi08yshnitlE+sov?=
 =?us-ascii?Q?9Jy4Ia4rjLm3lwTTIgbdWGv/4KBVOJ9OTRTbDE+qcKHzSd37gJXJizfmJVzu?=
 =?us-ascii?Q?NXu/Yebmw2HE78WB40Gf1+InDYGfyuIwplhdN0AglgDXdokyE8RFd/gAeUYo?=
 =?us-ascii?Q?EkKDF7rjcbQbkV4lsNQB9XAcwCJzMkjg86EUdjgw50mXxCk/OTwKeXTLjHwd?=
 =?us-ascii?Q?FqGNf/37D9tokI8SXVnhtA40ruR48AKya3lGh7BSbD1XcIJRAtY0zeMVrVv1?=
 =?us-ascii?Q?FO8p9JYG5/KRpvDcHhSsutsshPFlBW+FGn0wcgfIO6LwOmKwpCjxJaXBWM9V?=
 =?us-ascii?Q?0T/tKL7Yumba7dnE0napCVXVwbKq4jwwrbaTDj3yYOC252eGn5FvikXpJqJ6?=
 =?us-ascii?Q?xmd7RrSw8oRnorQbptrqdTk7Jyix3UhBe3X6Ss8vhgiUbHHg5UQaGOzPZ4JW?=
 =?us-ascii?Q?iKrqp6qNfsRlPl7baAUHdG7DPgVitz8ViaSiBGFI0XGuHpV/gSjFPC+OSTzq?=
 =?us-ascii?Q?L2/fiOc2SXc+5PsVuv1CJOl/n3180A7Cvf90MC2So5Ttzywd/kQ+35w/5pni?=
 =?us-ascii?Q?WGB6jHMlbmw3/oHGCKnph/99rV3AWEl4aK6eun7uPvDZBXrH4j28eMX+/wja?=
 =?us-ascii?Q?SIgz/BbQIXa99uJct3vZ3HbBIqVd0lTuAMQmLgO8aeiMnoPjV8V55h5LiEAK?=
 =?us-ascii?Q?l+0KH7/5/KGNXSdscwX5fbEe6Tt5vY4LaFUxIy2ywezKmlmusD93lCZDI9wX?=
 =?us-ascii?Q?JFI2LCeRPlcjnPa7KJG5LQnbB2DBrK1kczLchzo/Hj5Yg/JFMHg8DFtTRMoA?=
 =?us-ascii?Q?9OwNyKIA/ov3RG82pYqk8VJW0iRNxeo4M0GoWMdYNasfuLLm4Qh3ZzIAu0Sq?=
 =?us-ascii?Q?pC3YVbEU8310Nac57yXdX5VIu20wl0HhCZRHlGucfm3x/HSVFQjklU7bg7jH?=
 =?us-ascii?Q?KmZTpDfcWrM16W0r4ygGMLpuhBdbkKzWBEE3oMFcLl2/hBPxvGt7aPi+mGWo?=
 =?us-ascii?Q?JX2G6LXdPbzoyFgDOq0kERLKYrIyic3SXK3u8pKHJk1RAqXhujH/uwRbjFI8?=
 =?us-ascii?Q?igM2dtJH1B+abDluVGyNuYMRJkxEisume0xuPjJJ2FQ+FIVBlWYKYcH0Qb2C?=
 =?us-ascii?Q?7dO1R+9igV9yjkOEx68ygk+wEFaYf38+/OvGAVpuIb4VGHRGMJv1qCbTkcpW?=
 =?us-ascii?Q?mkYtwWNpbGFHmanx3Q4RRR3kTdNiiJooq84CW5os/oxaaE2Wz930xWpDoBko?=
 =?us-ascii?Q?j7WoTTQPY48DRbi9X9U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c50e03-7cf1-41eb-7a3f-08dcb6714948
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:25.8898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dy6oSR9+bUIhoYeHR69ZoDN7Ik7FZscNaVcp242MVpnWjMJg8sGYPhH6mtDektEX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

This control causes the ARM SMMU drivers to choose a stage 2
implementation for the IO pagetable (vs the stage 1 usual default),
however this choice has no significant visible impact to the VFIO
user. Further qemu never implemented this and no other userspace user is
known.

The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
SMMU translation services to the guest operating system" however the rest
of the API to set the guest table pointer for the stage 1 and manage
invalidation was never completed, or at least never upstreamed, rendering
this part useless dead code.

Upstream has now settled on iommufd as the uAPI for controlling nested
translation. Choosing the stage 2 implementation should be done by through
the IOMMU_HWPT_ALLOC_NEST_PARENT flag during domain allocation.

Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
enable_nesting iommu_domain_op.

Just in-case there is some userspace using this continue to treat
requesting it as a NOP, but do not advertise support any more.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
 drivers/iommu/iommu.c                       | 10 ----------
 drivers/iommu/iommufd/vfio_compat.c         |  7 +------
 drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
 include/linux/iommu.h                       |  3 ---
 include/uapi/linux/vfio.h                   |  2 +-
 7 files changed, 3 insertions(+), 63 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e5db5325f7eaed..531125f231b662 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3331,21 +3331,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_of_xlate(struct device *dev,
 			     const struct of_phandle_args *args)
 {
@@ -3467,7 +3452,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.free			= arm_smmu_domain_free_paging,
 	}
 };
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 723273440c2118..38dad1fd53b80a 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1558,21 +1558,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks)
 {
@@ -1656,7 +1641,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.set_pgtable_quirks	= arm_smmu_set_pgtable_quirks,
 		.free			= arm_smmu_domain_free,
 	}
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ed6c5cb60c5aee..9da63d57a53cd7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2723,16 +2723,6 @@ static int __init iommu_init(void)
 }
 core_initcall(iommu_init);
 
-int iommu_enable_nesting(struct iommu_domain *domain)
-{
-	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
-		return -EINVAL;
-	if (!domain->ops->enable_nesting)
-		return -EINVAL;
-	return domain->ops->enable_nesting(domain);
-}
-EXPORT_SYMBOL_GPL(iommu_enable_nesting);
-
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirk)
 {
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index a3ad5f0b6c59dd..514aacd6400949 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -291,12 +291,7 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_DMA_CC_IOMMU:
 		return iommufd_vfio_cc_iommu(ictx);
 
-	/*
-	 * This is obsolete, and to be removed from VFIO. It was an incomplete
-	 * idea that got merged.
-	 * https://lore.kernel.org/kvm/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/
-	 */
-	case VFIO_TYPE1_NESTING_IOMMU:
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 		return 0;
 
 	/*
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0960699e75543e..13cf6851cc2718 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -72,7 +72,6 @@ struct vfio_iommu {
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
 	bool			v2;
-	bool			nesting;
 	bool			dirty_page_tracking;
 	struct list_head	emulated_iommu_groups;
 };
@@ -2199,12 +2198,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_free_domain;
 	}
 
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
-	}
-
 	ret = iommu_attach_group(domain->domain, group->iommu_group);
 	if (ret)
 		goto out_domain;
@@ -2545,9 +2538,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 		break;
-	case VFIO_TYPE1_NESTING_IOMMU:
-		iommu->nesting = true;
-		fallthrough;
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 		iommu->v2 = true;
 		break;
@@ -2642,7 +2633,6 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
-	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
 		return 1;
 	case VFIO_UPDATE_VADDR:
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 4d47f2c3331185..15d7657509f662 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -635,7 +635,6 @@ struct iommu_ops {
  * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
  *                           including no-snoop TLPs on PCIe or other platform
  *                           specific mechanisms.
- * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
  */
@@ -663,7 +662,6 @@ struct iommu_domain_ops {
 				    dma_addr_t iova);
 
 	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
-	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
 
@@ -846,7 +844,6 @@ extern void iommu_group_put(struct iommu_group *group);
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
-int iommu_enable_nesting(struct iommu_domain *domain);
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf1902f..c8dbf8219c4fcb 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -35,7 +35,7 @@
 #define VFIO_EEH			5
 
 /* Two-stage IOMMU */
-#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
+#define __VFIO_RESERVED_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
 
 #define VFIO_SPAPR_TCE_v2_IOMMU		7
 
-- 
2.46.0


