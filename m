Return-Path: <kvm+bounces-24274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4B89536BA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC175B234B4
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE0C1AD9F5;
	Thu, 15 Aug 2024 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bSBPzaMm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29881ABEBC
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734708; cv=fail; b=OGx4upEIjYO1hND2xQAlbNQE096ltrsm/WS2o94eJzFVchEP4eRDtUih82xaqfmJWw52zgrLfeNpo7WJ/w6zuH1V1bPYwnBxWnX+JP2OiCRu5YUAYHrPRoA/triAZEIK3FuRKbGq3lOxxTYkgvALm+1WTQz3XSvnw+DrT246lMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734708; c=relaxed/simple;
	bh=coT7JfYg+gzTjn8jfvGJe+k6ETFzLmTYywGENJ3FRKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O+mpOT+HP9aFBLz3dQnIjHL9U5p7QZTYb1HG1nJn75Xbejx0K9KBMKOzuenNQMz7wW6J77Q7NFDpRAzN8DDuee2kTCdtAYsD5QYvV6YbZgoOi1M+JgC4hdlRQinHZ1amc8UxDpv3k073GdU+OjROW/AFmQXlLnLq3KIGRSz74UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bSBPzaMm; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NjyNlzlmgnGB8dY1vlvQQOUI1G9nmDrW1Deoebxg3uZdgIBSrd+14A2HuPllJcAkUxrzhDO63deHzS1V139hjxN5D1CdFjnNjuf01Dpx5i8mMvMiNlyIp96qAy+zXqlDMfP+pKkoTKNfEPYjz1VFZyWru4QxX1VRuaByosz5nKDU9T6j8SNYVv22cxWmUyDaipGns7VS2/itkbaIaIwW4lvIIRdMYPo6DIYJ4QoKaXXFfvj5UtCvEyUuPx3d2Zq5X5Y93fxu0A9jnyNEHHL+Ex8m3ko7a1wSjnYncPsYGpNBSNcjNYScqb5zSybxSch4gJ8nDorvhCNxT2w15SKPrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cYkT3FGb7Blq6PsDHirZ/rYyxXqVErAlhjUc0owqMQ=;
 b=pTvliKpVB6TC9m906p+S3IhDz0Mo/74ng9lBEIWrkY2bmvEpaHdApUKNo6xJ4WQNDIfEhDrCWgHvWEscCEW3tWG1bM23hcVafAaGJCzDh/+WOU4yzqJvfZeXlqZG/iz+YbzSZxQ5Nu5D+dk0llBTkYO5YoKx7VQnLZw9goX7D7vKxxfQxiLLg9KwmIV26F15WljRuibRJjksDgFIG55Vihg80ASdNzbHRVik8AdoZbUM1Z5Ed1lCRcWW845QJnsKmdKWijsLcgTHTAPl0oYc58ooHpH1IlwmnZGZtVa0pLOh/JjX9lSSrFWgEv6TNVIjqo4POKpjWR2xwRJDvlxxQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cYkT3FGb7Blq6PsDHirZ/rYyxXqVErAlhjUc0owqMQ=;
 b=bSBPzaMmnDHFoxUcRbiW5C3GDsyxAeUdEZQCxuJP3ddTt5cd6rEjVBE5yQvqo4RsxHHsxli3PBJhCWqOKui+z+NMFdalR4hPOb7ORJzCxtd2z7SGpPHxMwBfAnKpeFo9VH3KlMHWOmhs9Dp1I62fq+Q+SoHesq9cvkQTzv50lLzZsANlttW/SRL1DH4SWW36zADooVer7g1nphz3BWKdvXeA22YEQyxcps/U+FctUvSb4uVbju/8lXj2JUzkgIyZg17T1HNupvXKndUPYKGDSFFPHuqMPR2Wl2gRxbS/lWFFctKwI99+YmKMPtmvh1iZGJ8VzvBCSHSYRk+RMQmKVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:36 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:36 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To:
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	iommu@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 13/16] iommupt: Add the x86 PAE page table format
Date: Thu, 15 Aug 2024 12:11:29 -0300
Message-ID: <13-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF0001641D.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:12) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: a20f3de1-daee-46c7-3816-08dcbd3c8d4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tdgj4yW5szD7PrBalGKeV3/uakkPL3Pfq0XxaEwKPhfrkGZJiLkSQ7kuKYIr?=
 =?us-ascii?Q?AjvwjSekQJnGXt+7bX/GvxAVH2w/aHKg/ZoW3TjmrAEDGd3rL5ph2vGFBQOA?=
 =?us-ascii?Q?JZDzxJB3+WJ3pmAP/G0v2jXKNyrzvs4vKjdWf3V0gkEdZ0vSVnZwVP50cmQX?=
 =?us-ascii?Q?+73MB3YQH2kxWZa9SogoPEIPeUtqWi0SdkQuIRRWyzQveLgXQABwtr4Qq5I7?=
 =?us-ascii?Q?Cs4SJwA4KAlJbzUyzGR7HUEJI+rt399HI8i/e2cYDogfrOGzeTtdr+hO1lXn?=
 =?us-ascii?Q?yis1shWeFWJYjE6kleiJg8WgVDj7C1dhG6pKoj+69Rg2opsiRly/DySAZrxu?=
 =?us-ascii?Q?uS4CsDYQnO92aPsYZtD+dQFR1gRO+SeP9SlgbWn43TD6HF7wBH5dmPPN3p78?=
 =?us-ascii?Q?9hTRpvxS+P8N1s4A7OdpLS4S7HrlUKrke/+lipfO0l9vaR95NAWjWl1vHk3F?=
 =?us-ascii?Q?LlcEm9b6KT3x6EUa0hiMXMk3wm7+NzQXTJWxkntWElvfU3dEFt+sB90K7YqO?=
 =?us-ascii?Q?pIimS8GYIPZrIgE1ygjh/TxVbONyGER9a2nC4DLfUyQnnkJggaQz0tL1G7a8?=
 =?us-ascii?Q?HI2EBUeUx7EaRFTh0KFztLz8froNGB70fRR3JOyhEK/irTtPTkv2Cdgqd/6w?=
 =?us-ascii?Q?INKkGHyUKz3EteznAp1rnjgpFOX1feTC+6FYlqYrKzqTaJCeL2GumiDTmW0i?=
 =?us-ascii?Q?fropf6aaHZRkNl7RHdzPT/xRRj4uYw5u5Va7w8mDjhAYQGW2P13joeIuDQj5?=
 =?us-ascii?Q?MTJ3PV3aXbFkS3wcr2aZpdxRxUFF4ab9bbvsxzKlLGVFw5S6XdabfH/Nz2fM?=
 =?us-ascii?Q?GvaBnnU43HyV1kwH4nAhVsRAWcOCr/Ru0Cs9FlWdOoxqSU14/0TbsIu4hCe4?=
 =?us-ascii?Q?J65OrenuTgjRCX+5CfpTs0nkV8Zb+K+AX8XKaVa5EPbcWSgksXhNpTWauYv7?=
 =?us-ascii?Q?RJJrsSVi8LYseUdFy/zd0YFe0bLWJjNq+ymR45xjSvwxNsBj+q30hRJkobS1?=
 =?us-ascii?Q?cqJACvrS1G103jp5PNx3FM6Hz9c51YvHFO0tX/UExEE/PgA6smChG7QxTH2u?=
 =?us-ascii?Q?wy5bxsRQ+4TA5WpojPUuSO+Az5f2PxscH0l05c4wBaWUhyk9yRO805BOdh39?=
 =?us-ascii?Q?W5WuDDsZmymaHjaI5/yExsgUqFeff+5OlTtJHjsXugGzwTE03eGnbsgOdIcD?=
 =?us-ascii?Q?gv7FRHFtxJmP8hCB+QTtF2h7rnHeu0w/FTcT8b1HSxz7Ohy2kwH+q6z1CY9s?=
 =?us-ascii?Q?4Xfx/FGFSCoE3xg6s4IJ8tGcgDlu4vW1PRT2kQ1mMIl3rYn9xVUMur5s8E3L?=
 =?us-ascii?Q?iQHWCT2//Zh7hjxLVzXyVEMZR1rTi2oRUy8NC/P0o6/Zmg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nPSMwaVqfn3Lx6kOrYwaHByRa51gJQyqYEQ6ZZq5uQwZeACb7sWRUfJ61ESo?=
 =?us-ascii?Q?qXbevQm56ihthjmFIFWwVaLWaRlpw/ryYbgt6a649Cgtvil7csTr8Dn8TTEx?=
 =?us-ascii?Q?DV0knJ+xkq3+y56Ky9IrxkM5Njsgk6dGbSeLplgk/xGW1gID/ybhuVV77Yxb?=
 =?us-ascii?Q?jVYtXFyKLQHvMXYzFajJZT8bbYEyxfCGgDjs3aQTB4V/RFv+wnPzgH8g2Di/?=
 =?us-ascii?Q?NPORJbHM0UqZMhxm0KEIx2fyKS8PHxtblNuBwA2YtpzcZ2685h+XP3WjO6Bh?=
 =?us-ascii?Q?w960dli96zS5KaQhDGu02oYbY41y+4+Yb9Pv+cNFrQwu4bvgiG8ED/XcR2Ou?=
 =?us-ascii?Q?B0Q4gVG7oDMkf7Gtn4st707jO+b0n3TzF9Iwv8zvxn/1sDu9F9tG9vcx8ulb?=
 =?us-ascii?Q?/A9BUCcyvwq8oEyc4LwLye3tdEWK16fMTzxuZ0wIpn2fU/pIf1x1a54y33FO?=
 =?us-ascii?Q?XlGq9STHFhMkJXFsdslVI+0u+Q/9u6hIyHvBsSwGdEx+TX47C1K6tiyC0JJ4?=
 =?us-ascii?Q?lwb2ZLqMpfNC+Nk6odMwGtBCTaZNny5Y+ebY6Ju078pO3eA+Y42k/Icnt58b?=
 =?us-ascii?Q?sp/FGwBzy4oCXZhB89qk1pVJ2l/mgeiDV/Sjxvv5zORZIiTlHZCICZGP71aR?=
 =?us-ascii?Q?q6O4Fe7OAkEilQqMhnGG8Oqeqtqs4a/IbEDItM860K65psOBJATwumqD6ncd?=
 =?us-ascii?Q?5H4E0fRBYUBBuwWxgJQbVOcBKrZDy+TeYk6+X1X9VEQMami0LniiHPb3oZxJ?=
 =?us-ascii?Q?fD0nXoB9yAwIerl5VlfA12YiZ6i0ji3Hu4qsSkFxUUz3zTLzcnOwjFGYt/qa?=
 =?us-ascii?Q?bo0P2rgzyid136wxQSCWGjUk16/bsM5S45ynAF6EMfKk6gltWXeWP5Arjt8E?=
 =?us-ascii?Q?OcSsOVQ52STLUIMVBzFS/GnwSiHqH2D3bOwFn2GmCX1ObJTLg4tKktMiU5H4?=
 =?us-ascii?Q?Y5vN/wZvo9d6ijuq4nkPEdXo1tKjsyMai/5mAMijxvgJuCqfx/NRjhM/UV9K?=
 =?us-ascii?Q?swN6vILB36VKhGazwLEPQI0soLUzrRSmK96qF1bcL1hc0BO7lrdSVvro0puy?=
 =?us-ascii?Q?kqPVu2KLgBtb8UGZQqCmybdxELFx7NBSTqXP3ZfcznhxbUjoiNeNlBQyZL7i?=
 =?us-ascii?Q?3y63hK2X6PnSHRl6+WWtBMZ7Z9slBa7JTigadlAzLHF9p7q+JpCUOOGeoVXK?=
 =?us-ascii?Q?dvEN7j2Tgl9QNXABrysXagbUiXOmIeLtaRzEUNAhANI79YfL6/RK0pg0//b3?=
 =?us-ascii?Q?GRy3GV3pIaADnoEFIUr9F/xd6dsSa9L6/gWe6xOOrKIAIFSOtVPzKYxiYvhU?=
 =?us-ascii?Q?kuXarx70BayauTDQXx/Q5qCbraFOXZeRBCqmAZDNUSqb9x9i8X6yb8Q4daq/?=
 =?us-ascii?Q?raD8vK9p1RytNbeGVnvBExwVELQrKIvx7v4D4W+kwdvGTusmY9+ehckYL8Yd?=
 =?us-ascii?Q?lmRxyGOK8GYXozTBWHkBE5Uy0fN5lLKjkGPhS8P0Oz5PkRjkPMfJUUpWzb1p?=
 =?us-ascii?Q?CSFco/8KWDkdblqETqADxzT/lN/N5y2edUcSw59XaR5/e7ohsmgwMCBW0/eK?=
 =?us-ascii?Q?X9eY2u88hP/kSW9BY4c=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a20f3de1-daee-46c7-3816-08dcbd3c8d4d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:34.8480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4J+K5XWrS0LSu+03WZEEuwe7iW1ZTM04xhhKdNeA0r+Pbiqw4bLEsyQW5z29Ruz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

This is used by x86 CPUs and can be used in both x86 IOMMUs. When the x86
IOMMU is running SVA it is using this page table format.

This implementation follows the AMD v2 io-pgtable version.

There is nothing remarkable here, the format has a variable top and
limited support for different page sizes and no contiguous pages support.

In principle this can support the 32 bit configuration with fewer table
levels.

FIXME: Compare the bits against the VT-D version too.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/Kconfig            |   6 +
 drivers/iommu/generic_pt/fmt/Makefile       |   2 +
 drivers/iommu/generic_pt/fmt/defs_x86pae.h  |  21 ++
 drivers/iommu/generic_pt/fmt/iommu_x86pae.c |   8 +
 drivers/iommu/generic_pt/fmt/x86pae.h       | 283 ++++++++++++++++++++
 include/linux/generic_pt/common.h           |   4 +
 include/linux/generic_pt/iommu.h            |  12 +
 7 files changed, 336 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_x86pae.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_x86pae.c
 create mode 100644 drivers/iommu/generic_pt/fmt/x86pae.h

diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index e34be10cf8bac2..a7c006234fc218 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -70,6 +70,11 @@ config IOMMU_PT_ARMV8_64K
 
 	  If unsure, say N here.
 
+config IOMMU_PT_X86PAE
+       tristate "IOMMU page table for x86 PAE"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	default n
+
 config IOMMUT_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	select IOMMU_IO_PGTABLE
@@ -78,6 +83,7 @@ config IOMMUT_PT_KUNIT_TEST
 	depends on IOMMU_PT_ARMV8_4K || !IOMMU_PT_ARMV8_4K
 	depends on IOMMU_PT_ARMV8_16K || !IOMMU_PT_ARMV8_16K
 	depends on IOMMU_PT_ARMV8_64K || !IOMMU_PT_ARMV8_64K
+	depends on IOMMU_PT_X86PAE || !IOMMU_PT_X86PAE
 	default KUNIT_ALL_TESTS
 endif
 endif
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 16031fc1270178..fe3d7ae3685468 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -6,6 +6,8 @@ iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_4K) += armv8_4k
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_16K) += armv8_16k
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_64K) += armv8_64k
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86PAE) += x86pae
+
 IOMMU_PT_KUNIT_TEST :=
 define create_format
 obj-$(2) += iommu_$(1).o
diff --git a/drivers/iommu/generic_pt/fmt/defs_x86pae.h b/drivers/iommu/generic_pt/fmt/defs_x86pae.h
new file mode 100644
index 00000000000000..0d93454264b5da
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_x86pae.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_X86PAE_H
+#define __GENERIC_PT_FMT_DEFS_X86PAE_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct x86pae_pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs x86pae_pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_x86pae.c b/drivers/iommu/generic_pt/fmt/iommu_x86pae.c
new file mode 100644
index 00000000000000..f7ec71c61729e3
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_x86pae.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT x86pae
+#define PT_SUPPORTED_FEATURES 0
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/x86pae.h b/drivers/iommu/generic_pt/fmt/x86pae.h
new file mode 100644
index 00000000000000..9e0ee74275fcb3
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/x86pae.h
@@ -0,0 +1,283 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * x86 PAE page table
+ *
+ * This is described in
+ *   Section "4.4 PAE Paging" of the Intel Software Developer's Manual Volume 3
+ *   Section "2.2.6 I/O Page Tables for Guest Translations" of the "AMD I/O
+ *   Virtualization Technology (IOMMU) Specification"
+ *
+ * It is used by x86 CPUs and The AMD and VT-D IOMMU HW.
+ *
+ * The named levels in the spec map to the pts->level as:
+ *   Table/PTE - 0
+ *   Directory/PDE - 1
+ *   Directory Ptr/PDPTE - 2
+ *   PML4/PML4E - 3
+ *   PML5/PML5E - 4
+ * FIXME: __sme_set
+ */
+#ifndef __GENERIC_PT_FMT_X86PAE_H
+#define __GENERIC_PT_FMT_X86PAE_H
+
+#include "defs_x86pae.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
+	PT_MAX_VA_ADDRESS_LG2 = 57,
+	PT_ENTRY_WORD_SIZE = sizeof(u64),
+	PT_MAX_TOP_LEVEL = 4,
+	PT_GRANUAL_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+};
+
+/* Shared descriptor bits */
+enum {
+	X86PAE_FMT_P = BIT(0),
+	X86PAE_FMT_RW = BIT(1),
+	X86PAE_FMT_U = BIT(2),
+	X86PAE_FMT_A = BIT(5),
+	X86PAE_FMT_D = BIT(6),
+	X86PAE_FMT_OA = GENMASK_ULL(51, 12),
+	X86PAE_FMT_XD = BIT_ULL(63),
+};
+
+/* PDPTE/PDE */
+enum {
+	X86PAE_FMT_PS = BIT(7),
+};
+
+#define common_to_x86pae_pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_x86pae, common)
+#define to_x86pae_pt(pts) common_to_x86pae_pt((pts)->range->common)
+
+static inline pt_oaddr_t x86pae_pt_table_pa(const struct pt_state *pts)
+{
+	return log2_mul(FIELD_GET(X86PAE_FMT_OA, pts->entry),
+			PT_TABLEMEM_LG2SZ);
+}
+#define pt_table_pa x86pae_pt_table_pa
+
+static inline pt_oaddr_t x86pae_pt_entry_oa(const struct pt_state *pts)
+{
+	return log2_mul(FIELD_GET(X86PAE_FMT_OA, pts->entry), PT_GRANUAL_LG2SZ);
+}
+#define pt_entry_oa x86pae_pt_entry_oa
+
+static inline bool x86pae_pt_can_have_leaf(const struct pt_state *pts)
+{
+	return pts->level <= 2;
+}
+#define pt_can_have_leaf x86pae_pt_can_have_leaf
+
+static inline unsigned int
+x86pae_pt_table_item_lg2sz(const struct pt_state *pts)
+{
+	return PT_GRANUAL_LG2SZ +
+	       (PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64))) * pts->level;
+}
+#define pt_table_item_lg2sz x86pae_pt_table_item_lg2sz
+
+static inline unsigned int x86pae_pt_num_items_lg2(const struct pt_state *pts)
+{
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 x86pae_pt_num_items_lg2
+
+static inline enum pt_entry_type x86pae_pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!(entry & X86PAE_FMT_P))
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0 ||
+	    (x86pae_pt_can_have_leaf(pts) && (pts->entry & X86PAE_FMT_PS)))
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw x86pae_pt_load_entry_raw
+
+static inline void
+x86pae_pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			     unsigned int oasz_lg2,
+			     const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	entry = X86PAE_FMT_P |
+		FIELD_PREP(X86PAE_FMT_OA, log2_div(oa, PT_GRANUAL_LG2SZ)) |
+		attrs->descriptor_bits;
+	if (pts->level != 0)
+		entry |= X86PAE_FMT_PS;
+
+	WRITE_ONCE(tablep[pts->index], entry);
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry x86pae_pt_install_leaf_entry
+
+static inline bool x86pae_pt_install_table(struct pt_state *pts,
+					   pt_oaddr_t table_pa,
+					   const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	/*
+	 * FIXME according to the SDM D is ignored by HW on table pointers?
+	 * io_pgtable_v2 sets it
+	 */
+	entry = X86PAE_FMT_P | X86PAE_FMT_RW | X86PAE_FMT_U | X86PAE_FMT_A |
+		X86PAE_FMT_D |
+		FIELD_PREP(X86PAE_FMT_OA, log2_div(table_pa, PT_GRANUAL_LG2SZ));
+	return pt_table_install64(&tablep[pts->index], entry, pts->entry);
+}
+#define pt_install_table x86pae_pt_install_table
+
+static inline void x86pae_pt_attr_from_entry(const struct pt_state *pts,
+					     struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits = pts->entry &
+				 (X86PAE_FMT_RW | X86PAE_FMT_U | X86PAE_FMT_A |
+				  X86PAE_FMT_D | X86PAE_FMT_XD);
+}
+#define pt_attr_from_entry x86pae_pt_attr_from_entry
+
+static inline void x86pae_pt_clear_entry(struct pt_state *pts,
+					 unsigned int num_contig_lg2)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+
+	WRITE_ONCE(tablep[pts->index], 0);
+}
+#define pt_clear_entry x86pae_pt_clear_entry
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_x86pae
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->x86pae_pt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, x86pae_pt.common)
+			->iommu;
+}
+
+static inline int x86pae_pt_iommu_set_prot(struct pt_common *common,
+					   struct pt_write_attrs *attrs,
+					   unsigned int iommu_prot)
+{
+	u64 pte;
+
+	pte = X86PAE_FMT_U | X86PAE_FMT_A | X86PAE_FMT_D;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= X86PAE_FMT_RW;
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot x86pae_pt_iommu_set_prot
+
+static inline int x86pae_pt_iommu_fmt_init(struct pt_iommu_x86pae *iommu_table,
+					   struct pt_iommu_x86pae_cfg *cfg)
+{
+	struct pt_x86pae *table = &iommu_table->x86pae_pt;
+
+	pt_top_set_level(&table->common, 3); // FIXME settable
+	return 0;
+}
+#define pt_iommu_fmt_init x86pae_pt_iommu_fmt_init
+
+#if defined(GENERIC_PT_KUNIT)
+static void x86pae_pt_kunit_setup_cfg(struct pt_iommu_x86pae_cfg *cfg)
+{
+}
+#define pt_kunit_setup_cfg x86pae_pt_kunit_setup_cfg
+#endif
+
+#if defined(GENERIC_PT_KUNIT) && IS_ENABLED(CONFIG_AMD_IOMMU)
+#include <linux/io-pgtable.h>
+#include "../../amd/amd_iommu_types.h"
+
+static struct io_pgtable_ops *
+x86pae_pt_iommu_alloc_io_pgtable(struct pt_iommu_x86pae_cfg *cfg,
+				 struct device *iommu_dev,
+				 struct io_pgtable_cfg **pgtbl_cfg)
+{
+	struct amd_io_pgtable *pgtable;
+	struct io_pgtable_ops *pgtbl_ops;
+
+	/*
+	 * AMD expects that io_pgtable_cfg is allocated to its type by the
+	 * caller.
+	 */
+	pgtable = kzalloc(sizeof(*pgtable), GFP_KERNEL);
+	if (!pgtable)
+		return NULL;
+
+	pgtable->iop.cfg.iommu_dev = iommu_dev;
+	pgtable->iop.cfg.amd.nid = NUMA_NO_NODE;
+	pgtbl_ops = alloc_io_pgtable_ops(AMD_IOMMU_V2, &pgtable->iop.cfg, NULL);
+	if (!pgtbl_ops) {
+		kfree(pgtable);
+		return NULL;
+	}
+	*pgtbl_cfg = &pgtable->iop.cfg;
+	return pgtbl_ops;
+}
+#define pt_iommu_alloc_io_pgtable x86pae_pt_iommu_alloc_io_pgtable
+
+static void x86pae_pt_iommu_free_pgtbl_cfg(struct io_pgtable_cfg *pgtbl_cfg)
+{
+	struct amd_io_pgtable *pgtable =
+		container_of(pgtbl_cfg, struct amd_io_pgtable, iop.cfg);
+
+	kfree(pgtable);
+}
+#define pt_iommu_free_pgtbl_cfg x86pae_pt_iommu_free_pgtbl_cfg
+
+static void x86pae_pt_iommu_setup_ref_table(struct pt_iommu_x86pae *iommu_table,
+					    struct io_pgtable_ops *pgtbl_ops)
+{
+	struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(pgtbl_ops)->cfg;
+	struct amd_io_pgtable *pgtable =
+		container_of(pgtbl_cfg, struct amd_io_pgtable, iop.cfg);
+	struct pt_common *common = &iommu_table->x86pae_pt.common;
+
+	if (pgtbl_cfg->ias == 52 && PT_MAX_TOP_LEVEL >= 3)
+		pt_top_set(common, (struct pt_table_p *)pgtable->pgd, 3);
+	else if (pgtbl_cfg->ias == 57 && PT_MAX_TOP_LEVEL >= 4)
+		pt_top_set(common, (struct pt_table_p *)pgtable->pgd, 4);
+	else
+		WARN_ON(true);
+}
+#define pt_iommu_setup_ref_table x86pae_pt_iommu_setup_ref_table
+
+static u64 x86pae_pt_kunit_cmp_mask_entry(struct pt_state *pts)
+{
+	if (pts->type == PT_ENTRY_TABLE)
+		return pts->entry & (~(u64)(X86PAE_FMT_OA));
+	return pts->entry;
+}
+#define pt_kunit_cmp_mask_entry x86pae_pt_kunit_cmp_mask_entry
+#endif
+
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index e8d489dff756a8..e35fb83657f73b 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -126,4 +126,8 @@ enum {
 	PT_FEAT_ARMV8_NS,
 };
 
+struct pt_x86pae {
+	struct pt_common common;
+};
+
 #endif
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index bf139c5657fc06..ca69bb6192d1a7 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -289,4 +289,16 @@ static inline int pt_iommu_armv8_init(struct pt_iommu_armv8 *table,
 	}
 }
 
+struct pt_iommu_x86pae {
+	struct pt_iommu iommu;
+	struct pt_x86pae x86pae_pt;
+};
+
+struct pt_iommu_x86pae_cfg {
+	struct device *iommu_device;
+	unsigned int features;
+};
+int pt_iommu_x86pae_init(struct pt_iommu_x86pae *table,
+			 struct pt_iommu_x86pae_cfg *cfg, gfp_t gfp);
+
 #endif
-- 
2.46.0


