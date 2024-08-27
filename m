Return-Path: <kvm+bounces-25196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FAF961829
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 21:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACDA728532A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 19:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2ED1D2F55;
	Tue, 27 Aug 2024 19:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o/65y1I4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A951C57AB;
	Tue, 27 Aug 2024 19:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724788119; cv=fail; b=l5oc3kZnB4SNvqttZg3rc9Hczj22gv0eAupN/DqdRifkFGo7CXJkoIwvohMu26qLlFLBTmrJgEJvDJo3wSjudlMcSO/HVksfkbClpEt1ggauO6Fd3mMJCAIYWueIs6skr+amB2Qxi8s1//viNCd3QL+yKN7wC45A3q7XTS62Njs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724788119; c=relaxed/simple;
	bh=s9o7CDN8m8A97EIUUcPGN2lm6tXrzn0jRv7yjqq+JTw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9owRhTqAjtl+i6sz+owtgxrxydJ9OTaOGVYpraOPn7xUk1Cqje1nttw48lQUMNjpoUruV5wzr7+JRE+XebKDH8QeVFxIxFleA3r/JyoPnILHFCKuIh7UG+EKtmrLITPj+nSc4tv/ABSS1AorF/503S2ZkoxWlczSM1qGfT8I5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o/65y1I4; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p5rI33juUwtcsG7S8OweBAjGW4Io9VnHG52eGPCFgW+uKOuyJPJ5gYhGKQWAl7pH6BJVdz6d2YOYTakh2VceARmC+G9YljeVjigXR5zGhfaDMzW50feinWDgmfGRCX8H4G7oSC3KcjiPMOQrKL+nkb3iphUObvVGhLBLclt8B/1jgplKK7mJ4llEjlEB46/fmeXx69qOwKP7CM+WkcoVDh8s99XnRpbh9oqFKLVrL8uuYAdXqkXRXFMTCX3042+PoY21VmJKXTM6cWkSDiJc/gyM4SeXMseNGAIpnSlLqtmKmq4O82mLLrtaXrHieyQbhMA4U0X79wt8Crn4bdPAww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwJAlaFEs8grcekoL74D2xlZ9vnXLKNkIAZQUu/Bo4w=;
 b=qiAHo5iHRk26Yn96rD75hkeSarHNiKHjB/QkGXGNcgCZkXp+K2YxIOKoZv3JVEpHC4LtRasyvimMmfpO2xhE0+92d+vxhS0RdG9KSLEOUfWYYq4DUDUkWVjRu4DSby8rs42HwZ0CswhF2hy9jcRs+7dNqRYzT3EVxzBVN/gXi9h6Kg7aMeKfUkpXiOec7AvBxTGiBz0enyyNqeJmgnd9ZUlnxgQphGq981d1UvkIkVbYTYpQFvfZGe+tt5E5ZgDJhGGivFuw1w2/lonGlii/SNDMn6+UXHUJ7umKB7kwlvIrt6YPDVLXgN/P+ZiNPvmdX6AWcQUnnS5TlPYdoDrHJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwJAlaFEs8grcekoL74D2xlZ9vnXLKNkIAZQUu/Bo4w=;
 b=o/65y1I4acmPjSx92plGG1JjwdOxpot4EbW7iu6IFHEllB1oBQ2rfSwXnvhqG2R5vZOsgn7tPOziUTqURiIFKi3kcEuoQ3dPf+v0E9sqbLudrBEhfPsalebzJDx2Da5aZCBf96zdMzy2F08Q3KKE3566AavrgImp5uWIWSAXEDVXQGmHdzOGINtCWC+4Uyb+VgxthmQFW89DqCV7JAQm7z2CwotDL5f9/NED2J9V4WwyFRVGbLYr5qnj7R3CtjmNZMQbHNp/EbYRomWPIP4mwNypSA881RmQlKWSoPiyTVd64jpNQtk2R4Lq3ggweYbCyHKmueqO+SIbGcdWp80/Mg==
Received: from CH0P221CA0020.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::21)
 by MW6PR12MB8913.namprd12.prod.outlook.com (2603:10b6:303:247::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 19:48:29 +0000
Received: from CH1PEPF0000AD7C.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::be) by CH0P221CA0020.outlook.office365.com
 (2603:10b6:610:11c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25 via Frontend
 Transport; Tue, 27 Aug 2024 19:48:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7C.mail.protection.outlook.com (10.167.244.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 27 Aug 2024 19:48:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 12:48:17 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 12:48:16 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 27 Aug 2024 12:48:15 -0700
Date: Tue, 27 Aug 2024 12:48:13 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <Zs4tffQ9twCLL9+6@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7C:EE_|MW6PR12MB8913:EE_
X-MS-Office365-Filtering-Correlation-Id: f098b07f-f55b-4b61-1e2b-08dcc6d13914
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AMdmrrkXfMGB7NJDlH8hHU9AaVPYh86VQ4gnBJWyVKAvMRlvACtF9FiDfacD?=
 =?us-ascii?Q?aHW+xvUQz9Rh48xqXK4icq/LjmfkhB1y+54RVxgoPOQw+dLI1hjl86hQY/iM?=
 =?us-ascii?Q?goo3Mx5891Wttd0qe/pzP2EF4uRtkqoPo5Numa7dLj/DLoOrFiI5AmN12tYX?=
 =?us-ascii?Q?O0gCLJsRAvpl5TMWqcul3kojuDI7/Ql3j0R95Exlcpu0+cA8TKGc6DpDrm/T?=
 =?us-ascii?Q?OhtyMfngmMWb1xgJUgdnulizL9zhrmYsOAtMkrrdszS3S+nYCxUwbql03ljB?=
 =?us-ascii?Q?ETSC+K4jnXJ1J7Sp4OgJPwFHALGIzh6WlASK9ZUbEuKpW85N/iEY8vtaFyTA?=
 =?us-ascii?Q?9Nr/2tFDJZo6tiyAlUHnIsCJDqKkLUr+VdzcZde/tuwetiXsyCVHIcC1DX2E?=
 =?us-ascii?Q?/4uuduYGr5WMH9BfexKa7e31RsU9Elzdy2s8wgL/lO4P7lAn+yrK1oDwaUPt?=
 =?us-ascii?Q?AJHiKOFY0EaeVBC0y4IVMyFL8nlh2b7C9WBMrIx+9kd30ubewpngUiDPiDRb?=
 =?us-ascii?Q?yI1V6VmRuOHr3OfDOhey8nXeTxkhKbxk+HJlhNPcq6nbwxwGSD5quloNBppL?=
 =?us-ascii?Q?TvRublz30iOSKZgZqnv8xbYKfYmmfs+tv2qQPWwG/LkRjANoiRbUBaEcJrX0?=
 =?us-ascii?Q?8Z6ZJJTcAuTlQBIxs3EKxSVzUPIstBVvHT+UErjCagZmNLkq16WK7tsf2XLV?=
 =?us-ascii?Q?j4qdOF65zSYNSfid3jIDTHdXDNN0guFORZQHFhmt4+A8BakKdrtTflDK1RHw?=
 =?us-ascii?Q?Sl84VYd751jftqHuqhV+lHutTsAgZMd9kjtxn9Y1GrgAg9Ir00cGMyXxvFxZ?=
 =?us-ascii?Q?+sroNY41f3cFhKUv0KVay8SMX06MjisNPDXrobb8KakAPaGj57IouR+8mciR?=
 =?us-ascii?Q?6SaVPREZWHrUG4xA83l+MUt/3sDEQhY1oiDINXBem9GuVj/33GgMdolW7VHQ?=
 =?us-ascii?Q?jCKFtrq6TaaRSRF2F/cf2YyVz2eOL23f36156ZcbfwRnlh7K2g9xKog791yj?=
 =?us-ascii?Q?0RKzKSjzADIysrYo2OBXEvfOa2kkgzCKVcVSPhZM/4cvtVVrsfsaRltZGRYQ?=
 =?us-ascii?Q?6q44GDbIWdSM/1n7hiW7Av5SHR8XdcAUqFbor/ZHpy0ixn+1BrRE6z6qmCch?=
 =?us-ascii?Q?3wGC+OxQ/xxlChH+E/Y8VQb4OFH9SPAKrMzgcCOIkwi9Bqbh2d84HFhFltYf?=
 =?us-ascii?Q?e8SAW+auGLX55ogx8v28WCEgwoNY2ouhKLCjl/b9ddmwGBq5LjI8Qj8cTq/l?=
 =?us-ascii?Q?QYcl59u2jMcF1vkQmOvOlqPFANXAq6Jo0q6ItvPH1ax7XzQrb9TkUYHXwrez?=
 =?us-ascii?Q?DcmFK+fuAFtpCe1xyezjHpd5Mmptoi4/8WLEJbiMT7mlLQMpdQ5yRYlq4LON?=
 =?us-ascii?Q?Is0ZUSyfrEA0AdxhV0z4O/GX6Pci6M9dPILHzR6z7/1ExlYvVt9EmU3eF6n1?=
 =?us-ascii?Q?Y84tV0f+VNY1MY8n3x5HJVJXNI/3Tpy7?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 19:48:28.6133
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f098b07f-f55b-4b61-1e2b-08dcc6d13914
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8913

Hi Jason,

On Tue, Aug 27, 2024 at 12:51:32PM -0300, Jason Gunthorpe wrote:
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index f5d9fd1f45bf49..9b3658aae21005 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -106,6 +106,18 @@
>  #define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
>  #define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
>  #define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
> +/*
> + * For !FWB these code to:
> + *  1111 = Normal outer write back cachable / Inner Write Back Cachable
> + *         Permit S1 to override
> + *  0101 = Normal Non-cachable / Inner Non-cachable
> + *  0001 = Device / Device-nGnRE
> + * For S2FWB these code:
> + *  0110 Force Normal Write Back
> + *  0101 Normal* is forced Normal-NC, Device unchanged
> + *  0001 Force Device-nGnRE
> + */
> +#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)

The other part looks good. Yet, would you mind sharing the location
that defines this 0x6 explicitly?

I am looking at DDI0487K, directed from 13.1.6 in SMMU RM and its
Reference:
[2] Arm Architecture Reference Manual for A-profile architecture.
    (ARM DDI 0487) Arm Ltd.

Where it has the followings in D8.6.6:
 "For stage 2 translations, if FEAT_MTE_PERM is not implemented, then
  FEAT_S2FWB has all of the following effects on the MemAttr[3:2] bits:
   - MemAttr[3] is RES0.
   - The value of MemAttr[2] determines the interpretation of the
     MemAttr[1:0] bits.
  For stage 2 translations, if FEAT_MTE_PERM is implemented, then
  MemAttr[3] is not RES0 and all bits of MemAttr[3:0] determine the
  memory region type and Cacheability attributes.
  For stage 2 translations, if FEAT_MTE_PERM is implemented, then all
  of the following values of MemAttr[3:2] apply:
   - 0b10 is Reserved.
   - All other values determine the interpretation of the MemAttr[1:0]
     bits.
  For stage 2 translations, if MemAttr[2] is 0, or if FEAT_MTE_PERM is
  implemented and MemAttr[3:2] is 0b00, then the MemAttr[1:0] bits
  define Device memory attributes as shown in the following table:"

So, MemAttr[3:2] seems to be 00b or 10b depending on FEAT_MTE_PERM,
either of which would never result in 0x6?

Thanks
Nicolin

