Return-Path: <kvm+bounces-29175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34ED59A415B
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 16:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 555D21C2316C
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 14:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16EA1F4278;
	Fri, 18 Oct 2024 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DvFkda6I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2049.outbound.protection.outlook.com [40.107.101.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64FF42A97
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 14:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729262371; cv=fail; b=UIUNKvX+x/80NYxZRmUL+SS4BrqwMOMmfKc3imeZWAR6glXTNnujCdfVQOAw1Lcx6vuZE2+DLSq11JlrAarqzD9fou67aNRyzdv0tOKC1UxFHIatK3p4ohe+8NghQSfd0DOI1px1TiJDYyA3mBEbx/q56J9L5u+A6ThQWSizXLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729262371; c=relaxed/simple;
	bh=5OLXT3Xyoau5YYYzhjjgri7/8btrwXt3poLzW8ECk48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sJWwLGyWDHQlHROks0XLE1QWgUL7BR1lX+GDIOjaRzy6hzjyw6zDy18Cq3jeLZv4dosiS4AnGxvhmTjBU+ft3hbd/TmunI1S8DY8B0a5KCw8Vt8OZJIh3mzciK8DwQgo9ACNQr+Q89e6ToOra5QgFDZsFJbwrxS0d0tG8bcP94Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DvFkda6I; arc=fail smtp.client-ip=40.107.101.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YnQfaZYmTmjGfheizelllElILzpD4qSPHyYgnMAXJRMEFZfav8BTq8AS33WUMMWUEAzeXpuaIcfW3TFoY6inrBofFVEelO82YyMV+J30buqSKCk7vQExNyRH/RbmRvh4Dms4kODSCv1gXmo4D8aehhGpRoKWOimQscZ3NePPPqqgMTCta0rZBUoVf3tRbUwL/j6VnI3kp9Ko8AIyl3pyNx+194+O7AZ5+1nE5W+SzvWEmMv5ZYJ/C7AYYGrbu/UfoMAg/UvG1Mu9zTVZeBD1b6UitmjRbcEbXOvYQhUKuoCPwio0yrA0ySVcV6VfOOTepZG12owzNDDDh6q8NR/XyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWi5ei035bw0A/Ci1jUzmyUYSiau+u3uZhQD6f5nwqQ=;
 b=q28SZd/pIj5CkIKNmvx6NkbqdYM+ZjCGnqGNj6Ol/NTZIPXx6HG45G8nz9BMU+ibXTgX3I2G/LQEL1XqsUH+LGRGBoatJu1cwZBTmfsIU2lNnRSTZhPtdaccxvnKmJb0Mudj0BsUeuJZyVXyYf5IoahbQoOuqMGMyZrpWYGnVGvynE7832vf2TY2+2hlFovK/2Wm1f2IswAgQJogUzTXJFH2roso78Zj191bd5X16yXYI48XqBRKfpKqfQ9+Es/THFGCfDv3ABnrAE26nTbDGzAE+zubrP4t6oOYgSPbnKfb/RJ7Q5jQjnrWyBNJ0/+wYwChnX3vsjFHWdfeKukODQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWi5ei035bw0A/Ci1jUzmyUYSiau+u3uZhQD6f5nwqQ=;
 b=DvFkda6IS3m9f0vMRenfOFyPSPzQSQi5m11vajFc6gfK8V/NIVUqb22Awv+sLWDj+W+Hk2dSiUwJDZVxq4Yc9ttk4a5bmhKTYjHzwY9KJQBV+EoTNRzcWpXfrFlbreRoAEL2DDsPd546WXRTWgU09sf+ib9foPhaFped7axoQe9Xu5Fe+7nhF73MlM3bm+1nOViQCck3VdWLZkhyE766/shsCfUBFk3qBLrz+nIzRxkGfeQXGMpvbNbqpnRDaTRt0YOi1kaS6IYXvzyyWoiAcVYJYlR/5wPJvwnKVQgGc9O29GPzPqcRumEWq7l0fpcXSZazYSpC51cLub95MBpl6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Fri, 18 Oct
 2024 14:39:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 14:39:25 +0000
Date: Fri, 18 Oct 2024 11:39:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	will@kernel.org, alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 1/3] iommu: Add a wrapper for remove_dev_pasid
Message-ID: <20241018143924.GH3559746@nvidia.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018055824.24880-2-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:91::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c74b12c-26f3-47de-538c-08dcef82a9ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zaPe4DHLu6C8CMe+eI431CvkEuFyRimjZ7WO4mH8mckV8wx4QXYTBmWYIIFj?=
 =?us-ascii?Q?nCHqT6oBdb0ubBcRfWl2zjL1/CwKl3743FKOw8JwigxOEaVRqFgvw5eNdtfa?=
 =?us-ascii?Q?WH5MAV4Dy6mj1YhyEwkSe0UENH1Oc2I+i81O3j2rLFjRRewsLVhIK9vGpCwi?=
 =?us-ascii?Q?6pnS2jS5nQAI2jEZyiyqZPrtUNe/wgW0457IiVafix8EhpweOH9wVCYKbHet?=
 =?us-ascii?Q?KjR37wlb/FVOkXvs5tJsAod5gXGu37YoLzElJEmJ/fgi6eldnlh74a3GyaBX?=
 =?us-ascii?Q?mkSmSQec4KBoqz+jMakq4EwECQOnYZXZadsfiKX9HxVNUZKPfEEy501naFZN?=
 =?us-ascii?Q?kLpbCnVyanmnxPGeX6ehBIGJMtAxAJ4YseXX6d8oveR52++v3t5pQ23vTzDo?=
 =?us-ascii?Q?emPP+kd7wIGFnK7fT4WAOtfdHPNpJBQpWwVMABdwFH2QRZszX5oJt+VJzFcs?=
 =?us-ascii?Q?aO4/EL/hguDG6syTuigx/vbtD7j3e+G+i8QrLwTSRR3SeoIL5X0NVjjHVq9z?=
 =?us-ascii?Q?2jtpYtMySkr0g7tOrjIYRPkURs8/Oid6Mhg96AaEiKAZIaEoslkWJc1unxXw?=
 =?us-ascii?Q?R7Xu055talvPU8ELerV7ZRrmeSTR9TB0rNe3suEzJLShvm6XfpmESFg2cRfl?=
 =?us-ascii?Q?kOrMkhefWkJgElGog3RZU+tdaXzJtUogsGuXDhVE8fRAJ65fwRsgmUvXOGGK?=
 =?us-ascii?Q?KSESe+yfr3SRsxHIqhGdu6BceYP6bpjT+en1eTp0RQasFkYBSDbrHF39m4nW?=
 =?us-ascii?Q?3Gazpp01HUov3fKiW/w3auUs5AFGqnQB+nzYHGwDFQhWsmXOSBdkdrfSjh8C?=
 =?us-ascii?Q?fT8sxvL72+eeFP4Rg+zLRcIIX1s9/9pQTklQsWlAo+qJU9lcsrq644O8Jm2w?=
 =?us-ascii?Q?qyEKImlfvzytSrhQxmnUr/YAFGehe5s2EixbQ+ok3X5g0Lyl/35BIZrSoAiR?=
 =?us-ascii?Q?T5ZLON+M5v4IXYlUUxxm7KfMy6Ileq/HTw0/EoW9KaCZGrMoDiIvdMiRdfQB?=
 =?us-ascii?Q?mnVudJMhMrQSyZg4XYfJOlhUvBwFOzjie6CN15/uoE+6K29yIKoRTCn5jR37?=
 =?us-ascii?Q?fkmY8S+veJaMFfPwjt9UKGeuXLJBhNaSnNtgSHdvUn5Gqa1YxoRBKhD/7k2q?=
 =?us-ascii?Q?4Rx4XKAo82ezLLfwRn3gqzfQQNc0rKHaoKseywgDXbJzeGhbgCfNIEl80bIL?=
 =?us-ascii?Q?+NMwvXVFYuQe/DP/drByzQsfrJoBoEeENugBo7E79T0Zt3kwfopabnWHicto?=
 =?us-ascii?Q?hA16mDUKXGjaCrIU4e/W5DZVXv0jUiiG1BLtIzUvTqkcpNiQ4Xl3jiNmtSEn?=
 =?us-ascii?Q?dsI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CWhyuMpOFn18iMdZfabcQO19JoFKXqRD5RdRDXec6yf8HKkGF9V5bVXUiQoK?=
 =?us-ascii?Q?y+t9A5DGnkohI/stCNoDpj/5SkHH37pG1Kt6ol19l+Ol7CNm68ZbtTVmTY8I?=
 =?us-ascii?Q?RqWSbZo8tv+IIzRPryZeAkb2SWZIIgZn+4W81/i6nX9ZRilqx7hvOhYASMPR?=
 =?us-ascii?Q?ZCrdfSv9MOril5WmDSZrosm5fzhSHFPXxH1A6M2uhJMcwxufpccpTmZWqkkI?=
 =?us-ascii?Q?ZpoveAN0+bDaYR1Ckzoi9calCvjZr+aRgdMsku7bUqqYad26dlKlicfEMbxd?=
 =?us-ascii?Q?IypouX5D9hLZDJqwU+KvPd9NOUeHxSn0FPbPCuhKCvqTFUMhUsJw7f4VUutL?=
 =?us-ascii?Q?837L4JST2kaNvhZT5u1dTXS5ehwoFnZIymQE9efS2BSpMtZhFFAoxPqHqKva?=
 =?us-ascii?Q?n8eGLwlSvFxKTp0qOrRhFGhbU7LR1pvq8VdJx8rLZXugWtFfrIk3YgQRdPbo?=
 =?us-ascii?Q?CJUIbX5a1naY8k2NdGY1yUN8ZoLP1Kt0VJrJ0WE7eOwnautjLEEBJBK/D0+7?=
 =?us-ascii?Q?enzmvn0XX6pw4lMky21FFvz5o4O/JWFMyKWtOwNib+xyOdZwvOqZS7GZlY42?=
 =?us-ascii?Q?WwxGX+jdb/k0Nb9wiAx7hSC9SwqU1h1xRc9AOW0n37WYQJY81DQ0Kk2NeH00?=
 =?us-ascii?Q?GZKm77cd0HeaKHF76VCSa7yXgOcpPEAq0o8eYeuFKpFkysl/svl5rtTt9bfw?=
 =?us-ascii?Q?H+8S7sz1R0EnU8eaX6Ak05hB5sA0rRL0IPLWS0hf9rlOvUycRAvD8J5XSsT/?=
 =?us-ascii?Q?FLBCP2Dsud+gzJhQ13Z4fNuSgUbbawPgs3IPvUkpT4dMvQDNXozmxHbJCU8H?=
 =?us-ascii?Q?HtHnO1pWLoHny9HH04qy/OpAnfqOpqSQdW/NSv9UPDg0EgwsCqHH4AmD/7vw?=
 =?us-ascii?Q?qfMhb5BFe8TdfVB2h+4Rb+M/VSACdDuzGUx5V1TazT7ueneynW7a2y+TpAOW?=
 =?us-ascii?Q?Ag2rjHtqJ0HjF82ZqJzzDGX7owKv/UCMc48MZGucxqwgr1bctYUb65mtH7uZ?=
 =?us-ascii?Q?zOMdeOzGsUVl/XPI0lgBLkIhKjO9cBCLfFuFuUNklmZA7NBnDoVgxgRIjFZG?=
 =?us-ascii?Q?73JaB40NJOiTpD3FOizZIyZw3ejh+xHKXx4cCdBmEfFiMsy0QUZKT1M1ZMGz?=
 =?us-ascii?Q?ejn8rKFXrH1Tofbw169QHxK1FTCak/Nlmxcdp4NTptwH+UB48BXUpgxIA7mp?=
 =?us-ascii?Q?vaDY5lGOLhbxCf1LJ9PBcUFq63jcENjXjGK1RkjRnpf0jzfGpmlNnan+ro3Y?=
 =?us-ascii?Q?yOrY3mP17yEVc5WzjG5uKKphG0gLZ2bV7edxE5FWwEBLY5YiX9BPYpPLwD6u?=
 =?us-ascii?Q?7h+ZYWRXD7IWPEWPHR9OBpF/cysBdjg07E8f+T9yH4EABGIWid8ch4/CR/vE?=
 =?us-ascii?Q?9qInvVfCBGnLlkbf9NZEbf5zonthKjRioEuMI15Gy4+TVpkQ6cPsoy/CoY1L?=
 =?us-ascii?Q?hZx3xRnJNmuHStwMeLGTy0PSRPr4LMvclZKjChw9xrzaU3cXmt4teo3Kvcgj?=
 =?us-ascii?Q?uxzNosGZcpJZ0iqtYePWysl7eWW1rMohYF31C6opYie+Psu6XOKzsPSmBCIa?=
 =?us-ascii?Q?/AiuE8PcYhFDvrRctt0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c74b12c-26f3-47de-538c-08dcef82a9ab
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 14:39:25.3072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TDWIdXRZEWx7Yc5Y6O7ttogqPokxkObK1TKwXfb6KlT5slAIrhFBefJIRF3UOfRv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883

On Thu, Oct 17, 2024 at 10:58:22PM -0700, Yi Liu wrote:
> The iommu drivers are on the way to drop the remove_dev_pasid op by
> extending the blocked_domain to support PASID. However, this cannot be
> done in one shot. So far, the Intel iommu and the ARM SMMUv3 driver have
> supported it, while the AMD iommu driver has not yet. During this
> transition, the IOMMU core needs to support both ways to destroy the
> attachment of device/PASID and domain.

Let's just fix AMD?

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 9e25b92c68affa..806849cc997631 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2437,10 +2437,18 @@ static int blocked_domain_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
+static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
+					struct device *dev, ioasid_t pasid)
+{
+	amd_iommu_remove_dev_pasid(dev, pasid, domain);
+	return 0;
+}
+
 static struct iommu_domain blocked_domain = {
 	.type = IOMMU_DOMAIN_BLOCKED,
 	.ops = &(const struct iommu_domain_ops) {
 		.attach_dev     = blocked_domain_attach_device,
+		.set_dev_pasid  = blocked_domain_set_dev_pasid,
 	}
 };
 
Jason

