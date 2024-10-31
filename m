Return-Path: <kvm+bounces-30126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 007119B7106
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A4B01F21DE2
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7155942A99;
	Thu, 31 Oct 2024 00:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vp6rLy6E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB04A1E529;
	Thu, 31 Oct 2024 00:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334074; cv=fail; b=L8mRq2t8twOuhJoPaZMj9b1R3ve39XI8uEK9pn5+bjGhRGC/JvmsnjOrKZ47NlrWghJVvtnCJ1858lhYdgv4ThL3HerorIWRKT1r0liCDaQ6fPwyxw2uxp5uZI4X+nHo1tmB/FP0YZFNvV22rtBB+OG4rI8ceFL5LGKbjnIfDn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334074; c=relaxed/simple;
	bh=jewXdDk09Ypxy6hXyuUMs6QuZJcDwSFQtpFffJCPPbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lxp/CcENu2M0jr8wV2QAuuaY/6kw37UesC1FJ0Ze2Xh2j7smvwso72TQaR1ol2y9AT42fIgc/akSXLWCNIrivynH5N37tGeS7gXsrkpHm05/55URXWYF/gmCi5ebMraC1+bg5wcku61hsRIbDjpITFyi+KYkrcIB3bLqOlVKMd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vp6rLy6E; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4V/tqfLXVbMgMy2j8qqogO5HArJdI1LDFSx9HdYmh8hdLC/HKlPnx+GnVc9g9xbxr9XPUesq30vU59HdmKPN5m7snVLokctSZ1bFYJsdMhz0JUQcaxrVXX10y8pQTlGsE8XmXhexzQiMgQNwyXffZW4y/O+Zdw4STk9gzVwfbiz/wWoYPGwHSOLEPtvW86btWf4jVx9425jAzcRRthbpkQ0UH9+k4IKrPxQO8fNIiNdd6bAsH6j0FJmIsKaOTt64it+Sg/dMD8X21MX0QqNNxc+M4qEX989naFMmA6D9Zj+QKa1tamc5pbLTaU70s7LwvvYwUbVBg3atdt5lcamPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQRHfPftorME/58aDpfc57GcioAVlyZuojbIq3ySi6A=;
 b=QAyfUxqCZ9/Y5Y4hF2V8hbw2EeUHrEhHbz0lw3kdaGSIDVEWJ2+bV/qC7sZEmkTPIkyBz/gN0CknYeFS7kNxNeQoCzGH8U/7dz0z6xUflYKRYey/bLuwt0ZfgAKUZBIhriqvSdYxYhQxNR4JDjwzZFgDQ1q40APmSpIXyvDPKFEf/b/YHL/zwruZU9Zvie3mwy6YRQgoHBunP1+JjWq9UCQgTD+KnOPTkTl+fmAM60jgx8zytOYbQ+AS3ZWbG9U/kE+KOzx8KiplEf8dK2zIMJodsTcCq3Iu3YYkvOcdgDNkZvpcvItU2Ppg5Q0byYuR7CGlf7aR86GJvFtRdJaaJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQRHfPftorME/58aDpfc57GcioAVlyZuojbIq3ySi6A=;
 b=Vp6rLy6EOFVL0T6GJBGNSPfSWUs3CnE9/3swO76sRuAxI+OBMnwCIxPiJzXG03fk97oUGXDCjW4N6f9xUm+LI3aw0Yp6KmeObX+JWrBfVSXSGljTo626dFuxz5ZJLcbn9ITFUFDhf/3cH02alFpoLsPF2ubeThL0sv/NZ6/MdITcyIp3k3WngxKkW7iAM+k1YWhejxXcvZaoAgyqQ1iPmCIPC6wYD7buOE1PfSoDbofl+iGtoBeRtysOaJD2O36rx22Dsz2W4wQZc2qf4JixPy84kS/tB6N6G+DG0xI6N7sUW3hszeAJuMxfuzCpIilcAbHqLgCmeTmMK1LTizhjCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:20:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:20:58 +0000
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
Subject: [PATCH v4 12/12] iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE using a VIOMMU object
Date: Wed, 30 Oct 2024 21:20:56 -0300
Message-ID: <12-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:408:f5::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: a250627b-ff5b-48f0-2132-08dcf941e3f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6VNd+NcAg3V9iuuAzlqVpUdLfuzq/27/3YVyjizotvJ0G5JJWizge9TzBy5S?=
 =?us-ascii?Q?L7YCHOx+RiGUvMLYsG979LQAVKTfUXw8qpVVvMUjWSZbx0JZYk9FlAljE3rd?=
 =?us-ascii?Q?wxTT124r0LGprHITt4/nKFasT1El9Elnq38AwWjH4cx/p/fvL918XAhBqX3c?=
 =?us-ascii?Q?MLkQVGvdpO0HtS3jYlP3ygbNI4YIDMkjcL8+HtHPvVZGLdxtVTEXOlOZBGwT?=
 =?us-ascii?Q?//6IA/wT2u6ZOYu4TQRozAXft7BcxZMvup2aleZwnb7y25zjivk+Dqy4c90N?=
 =?us-ascii?Q?Dp2WGLHtQWt1cTdG67VaJWcN65lB7PoZsT02c7A8bdfiTscM2SmPUokmr2Kw?=
 =?us-ascii?Q?SFlMQvhp6b37g69E7THGfAL7VTS5z5cjfffBzLAhOK22sESswvBoSwa0ZUvO?=
 =?us-ascii?Q?1Av7a/hhasjzONHqMdzEf97M0cmHH1sCtk3FdtJAWyyox6u5DBBljfKCiNCf?=
 =?us-ascii?Q?GO3qQMet0EJhVB0UnopEfpCvZhFcGCp/u3uULMV44NvKk1Z9CnbZ1KXXO3l4?=
 =?us-ascii?Q?naU2a4lclHRaSHgLYffsGv2LR/PfoNJCOryLuIYkPJhaQ6Ye184EyTd8Au7S?=
 =?us-ascii?Q?/3zbjIcNJQZV0eQWbNF/7TmDbNqls+4QVMGvb+D059cVKvNhTG17bKi94Ezt?=
 =?us-ascii?Q?sHDFFW/qPHsSkT0iVZL3do4Bqmof98n3omVWjI8Ak2a/F/vpXBL7k2HHNSRw?=
 =?us-ascii?Q?hw6VWtq4b5XNMxSkstt2kDIjbO4NeCqUM6fR81lcRVAed3bsYyVY4HWBAt5j?=
 =?us-ascii?Q?NcaAh5wa/O9A4xChT+vbsPV/OdJvc3aPk9OsA1QA42inauDulLgGREBSwkhC?=
 =?us-ascii?Q?9bWMYCyP3j5PEI0QxIIjV1buw1XU35z/L8Pdyvrwz7QOLFvvNF4mBhDPeMvt?=
 =?us-ascii?Q?LpvlgnpvH2zay6pPZbN6rLIkYdGOCXuE0bdojQjkAoRGB8K0Ri0aZIIR+Lia?=
 =?us-ascii?Q?/XBheDqXViertCPa2IDWc0jDPcgIq64FZ4V3BdL5pNqK4idUD5TsS+fLCd1W?=
 =?us-ascii?Q?igc2ltZHUU8rNucd+mIuwQkfKvaLx3++WbrLgIahgYkyTqzEFxujywwFAyVm?=
 =?us-ascii?Q?86wBgMzWEn9O/UbWvAXrU5EjHwSchlk7mto3LGKqScQ5GrJFomQKYsxesTaN?=
 =?us-ascii?Q?zYJHF+bP81QwHnBp2eymLcJa+2o7oTws/gsusEEdkOLjgJqiP/x6vl/YwyNf?=
 =?us-ascii?Q?rjTob/00TrdOK9Lrm2ZLA2qaTYsWkaNiUjANbwXqU0AqrCUQI/UZIPshcyY/?=
 =?us-ascii?Q?d4OVSEYHzd5e15YCtJQapmRUZpAa34cBGg7NEuJzuU9p2QPJk2A0qzO312zO?=
 =?us-ascii?Q?WG/xsMtvkSYvQ0Yr3sxiuVvDqtS6kUeMDPn5zi7MroLDu+W+wMOXHn4GjpJa?=
 =?us-ascii?Q?TETC8ws=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U/AIEd0S8lI69ZQU4yErwElz9YbvdIJa2F1KYh6eBe9EbA7Aot3tbMGt/Psx?=
 =?us-ascii?Q?qBaLXkD5lk4IMrXmwykA1a3pA0eaj3j2m5bTajVoU4calz6EsrVN9ctAeGVA?=
 =?us-ascii?Q?Ezgn6A7qFCFTqPA7AqaDhc6MH+MiWEm/PNcpkkQhUPbPeoBE0+DYAekHZTW9?=
 =?us-ascii?Q?CZdcIzICkX1039poBRs1J8Zg78OxuA7W/1CpOClkI9QsOjT9hlSpzgEa1Cne?=
 =?us-ascii?Q?xhxvV89aW4fbJ44t+UuF2CRyFxgT071d37BzyWN9toUfuWc3PDtH8BOVbMHP?=
 =?us-ascii?Q?SrVM5Iim0TJ7Qxf4DT7d07J/hHL8o2WuJIKTfFmL2tkr/pY4hvdsCxf7aWow?=
 =?us-ascii?Q?qnV8RojDpqEa6Z6Kj6JqjH8rK0E7mQOEWzkrEZ8LcivjW3+AWmTaorDfqt20?=
 =?us-ascii?Q?K2vu/mNd9JlPIkO/wAxbybKlFljiZWfUfY9eLP1chlACGJpCh6b/lNoJ2PNx?=
 =?us-ascii?Q?LDlg+xytTBRXC3CdCr71mta1yqRFuZMPELbwddaXK6C8/qhgGBCS+OZ+36go?=
 =?us-ascii?Q?SlU0h6Z1+3WWGstJlypvHoIwv3a74gjBaFS4tfhUmSbvh0EebFvAggwM62Ss?=
 =?us-ascii?Q?3DQRHuarAeEqSR3VgQGnlda/TkFHuJvR82JnXM4fTAnNRkuycZ03N3SDI5KI?=
 =?us-ascii?Q?lIUfrfhr/JrKyI2PB4XIKKINKT7B4/f0BiOxhow2cdyiRU6wTwSSR1DKcxxb?=
 =?us-ascii?Q?QucbZBsLW/hHIFJTQRAzgum48VXcumD2Dto+pK9AP6bfgUQx7VfidABp9CN3?=
 =?us-ascii?Q?oI2Q9uEpviCfNX7bWTaTdPuJSkRHk1PhkPjP21qypcwf6ZMQTUECQGXKWXU5?=
 =?us-ascii?Q?pHVmkGfMVRyQtR5tF/PN9xPCLlnIGPLJiO2an2e92atr3kcvo0Xde/FS4C1M?=
 =?us-ascii?Q?U16jLbKPVLRxcJ/67E0J+MD87uzvcwenIikvHRcLUmwVLLxB/u1e/oCN3F8A?=
 =?us-ascii?Q?/rkLg101cwJR8K2BJsWOMN2rQ3MGHYztStQLwigpBKrbBIwJohmzxclF3/tM?=
 =?us-ascii?Q?v2gdF61AijCqIUit6vYM41+4Ig1unEfhJXv/qoBOG2XfhOuInLO0Lq0OVIRp?=
 =?us-ascii?Q?LSrBQg5r1dDhgyzjxuSSzfmAdtkXgA8Vdag7g93bV3wO2SuAXhvWVFsdvOev?=
 =?us-ascii?Q?vu8u/sigda+IirxTZP9sMsA4QOv9jGYemSpdaejSSDuGdck6Z3xqt8nCNRMJ?=
 =?us-ascii?Q?tcMDP21jqnSzvPTwjkuFVKWTGM45gf6jK1B3jo+5Mc3KCvjPOaQ61Z11PFc4?=
 =?us-ascii?Q?Gj9SRzq1DPKR0pgKnO/QDms1yr5RSwORd5DiIOwBuB/qQKxlL9CEfX3wXl7W?=
 =?us-ascii?Q?ZRCaax11HztgmQQt3tVe4y28mtK3LeU9XIdhLQg75mX/V0RRC8T3NDvxJ18P?=
 =?us-ascii?Q?XZh6bRmiw/+pAtMPvZoVg4qgOCro7wXwVlSYPIeeKkiX0jhpv1D0kHfWPSDa?=
 =?us-ascii?Q?cOfreNgsfPZm4fUN++BGHi/6Ir91ifyIxZubJlqkA0JRYCj3X3Np1kq9LePm?=
 =?us-ascii?Q?+zcM/fdSV1QDFxtnHB4JnA1PW00umTO5oqYCuaoIkDyfSjgoo00kGDPFWVWy?=
 =?us-ascii?Q?PBWoi6S+f91xx6YR6ws=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a250627b-ff5b-48f0-2132-08dcf941e3f1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:57.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XaeoloZJaFe+WphM+iJsnCyVF+T5m64kxEgkJTER4ORtxlDgu2QDEtTAoPKKU3S+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

From: Nicolin Chen <nicolinc@nvidia.com>

Implement the vIOMMU's cache_invalidate op for user space to invalidate
the IOTLB entries, Device ATS and CD entries that are cached by hardware.

Add struct iommu_viommu_arm_smmuv3_invalidate defining invalidation
entries that are simply in the native format of a 128-bit TLBI
command. Scan those commands against the permitted command list and fix
their VMID/SID fields to match what is stored in the vIOMMU.

Co-developed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 134 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   6 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   5 +
 include/uapi/linux/iommufd.h                  |  24 ++++
 4 files changed, 166 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index ab515706d48463..2cfa1557817bc1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -209,8 +209,134 @@ arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 	return &nested_domain->domain;
 }
 
+static int arm_vsmmu_vsid_to_sid(struct arm_vsmmu *vsmmu, u32 vsid, u32 *sid)
+{
+	struct arm_smmu_master *master;
+	struct device *dev;
+	int ret = 0;
+
+	xa_lock(&vsmmu->core.vdevs);
+	dev = iommufd_viommu_find_dev(&vsmmu->core, (unsigned long)vsid);
+	if (!dev) {
+		ret = -EIO;
+		goto unlock;
+	}
+	master = dev_iommu_priv_get(dev);
+
+	/* At this moment, iommufd only supports PCI device that has one SID */
+	if (sid)
+		*sid = master->streams[0].id;
+unlock:
+	xa_unlock(&vsmmu->core.vdevs);
+	return ret;
+}
+
+/* This is basically iommu_viommu_arm_smmuv3_invalidate in u64 for conversion */
+struct arm_vsmmu_invalidation_cmd {
+	union {
+		u64 cmd[2];
+		struct iommu_viommu_arm_smmuv3_invalidate ucmd;
+	};
+};
+
+/*
+ * Convert, in place, the raw invalidation command into an internal format that
+ * can be passed to arm_smmu_cmdq_issue_cmdlist(). Internally commands are
+ * stored in CPU endian.
+ *
+ * Enforce the VMID or SID on the command.
+ */
+static int arm_vsmmu_convert_user_cmd(struct arm_vsmmu *vsmmu,
+				      struct arm_vsmmu_invalidation_cmd *cmd)
+{
+	/* Commands are le64 stored in u64 */
+	cmd->cmd[0] = le64_to_cpu(cmd->ucmd.cmd[0]);
+	cmd->cmd[1] = le64_to_cpu(cmd->ucmd.cmd[1]);
+
+	switch (cmd->cmd[0] & CMDQ_0_OP) {
+	case CMDQ_OP_TLBI_NSNH_ALL:
+		/* Convert to NH_ALL */
+		cmd->cmd[0] = CMDQ_OP_TLBI_NH_ALL |
+			      FIELD_PREP(CMDQ_TLBI_0_VMID, vsmmu->vmid);
+		cmd->cmd[1] = 0;
+		break;
+	case CMDQ_OP_TLBI_NH_VA:
+	case CMDQ_OP_TLBI_NH_VAA:
+	case CMDQ_OP_TLBI_NH_ALL:
+	case CMDQ_OP_TLBI_NH_ASID:
+		cmd->cmd[0] &= ~CMDQ_TLBI_0_VMID;
+		cmd->cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, vsmmu->vmid);
+		break;
+	case CMDQ_OP_ATC_INV:
+	case CMDQ_OP_CFGI_CD:
+	case CMDQ_OP_CFGI_CD_ALL: {
+		u32 sid, vsid = FIELD_GET(CMDQ_CFGI_0_SID, cmd->cmd[0]);
+
+		if (arm_vsmmu_vsid_to_sid(vsmmu, vsid, &sid))
+			return -EIO;
+		cmd->cmd[0] &= ~CMDQ_CFGI_0_SID;
+		cmd->cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid);
+		break;
+	}
+	default:
+		return -EIO;
+	}
+	return 0;
+}
+
+static int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
+				      struct iommu_user_data_array *array)
+{
+	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
+	struct arm_smmu_device *smmu = vsmmu->smmu;
+	struct arm_vsmmu_invalidation_cmd *last;
+	struct arm_vsmmu_invalidation_cmd *cmds;
+	struct arm_vsmmu_invalidation_cmd *cur;
+	struct arm_vsmmu_invalidation_cmd *end;
+	int ret;
+
+	cmds = kcalloc(array->entry_num, sizeof(*cmds), GFP_KERNEL);
+	if (!cmds)
+		return -ENOMEM;
+	cur = cmds;
+	end = cmds + array->entry_num;
+
+	static_assert(sizeof(*cmds) == 2 * sizeof(u64));
+	ret = iommu_copy_struct_from_full_user_array(
+		cmds, sizeof(*cmds), array,
+		IOMMU_VIOMMU_INVALIDATE_DATA_ARM_SMMUV3);
+	if (ret)
+		goto out;
+
+	last = cmds;
+	while (cur != end) {
+		ret = arm_vsmmu_convert_user_cmd(vsmmu, cur);
+		if (ret)
+			goto out;
+
+		/* FIXME work in blocks of CMDQ_BATCH_ENTRIES and copy each block? */
+		cur++;
+		if (cur != end && (cur - last) != CMDQ_BATCH_ENTRIES - 1)
+			continue;
+
+		/* FIXME always uses the main cmdq rather than trying to group by type */
+		ret = arm_smmu_cmdq_issue_cmdlist(smmu, &smmu->cmdq, last->cmd,
+						  cur - last, true);
+		if (ret) {
+			cur--;
+			goto out;
+		}
+		last = cur;
+	}
+out:
+	array->entry_num = cur - cmds;
+	kfree(cmds);
+	return ret;
+}
+
 static const struct iommufd_viommu_ops arm_vsmmu_ops = {
 	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
+	.cache_invalidate = arm_vsmmu_cache_invalidate,
 };
 
 struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
@@ -233,6 +359,14 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 	if (s2_parent->smmu != master->smmu)
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the exact HW
+	 * defect is needed to determine if arm_vsmmu_cache_invalidate() needs
+	 * any change to remove this.
+	 */
+	if (WARN_ON(smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/*
 	 * Must support some way to prevent the VM from bypassing the cache
 	 * because VFIO currently does not do any cache maintenance. canwbs
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b47f80224781ba..2a9f2d1d3ed910 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -766,9 +766,9 @@ static void arm_smmu_cmdq_write_entries(struct arm_smmu_cmdq *cmdq, u64 *cmds,
  *   insert their own list of commands then all of the commands from one
  *   CPU will appear before any of the commands from the other CPU.
  */
-static int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
-				       struct arm_smmu_cmdq *cmdq,
-				       u64 *cmds, int n, bool sync)
+int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
+				struct arm_smmu_cmdq *cmdq, u64 *cmds, int n,
+				bool sync)
 {
 	u64 cmd_sync[CMDQ_ENT_DWORDS];
 	u32 prod;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 01c1d16dc0c81a..af25f092303f10 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -529,6 +529,7 @@ struct arm_smmu_cmdq_ent {
 		#define CMDQ_OP_TLBI_NH_ALL     0x10
 		#define CMDQ_OP_TLBI_NH_ASID	0x11
 		#define CMDQ_OP_TLBI_NH_VA	0x12
+		#define CMDQ_OP_TLBI_NH_VAA	0x13
 		#define CMDQ_OP_TLBI_EL2_ALL	0x20
 		#define CMDQ_OP_TLBI_EL2_ASID	0x21
 		#define CMDQ_OP_TLBI_EL2_VA	0x22
@@ -951,6 +952,10 @@ void arm_smmu_attach_commit(struct arm_smmu_attach_state *state);
 void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 				  const struct arm_smmu_ste *target);
 
+int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
+				struct arm_smmu_cmdq *cmdq, u64 *cmds, int n,
+				bool sync);
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 bool arm_smmu_master_sva_supported(struct arm_smmu_master *master);
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 125b51b78ad8f9..2a492e054fb7c9 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -688,9 +688,11 @@ struct iommu_hwpt_get_dirty_bitmap {
  * enum iommu_hwpt_invalidate_data_type - IOMMU HWPT Cache Invalidation
  *                                        Data Type
  * @IOMMU_HWPT_INVALIDATE_DATA_VTD_S1: Invalidation data for VTD_S1
+ * @IOMMU_VIOMMU_INVALIDATE_DATA_ARM_SMMUV3: Invalidation data for ARM SMMUv3
  */
 enum iommu_hwpt_invalidate_data_type {
 	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1 = 0,
+	IOMMU_VIOMMU_INVALIDATE_DATA_ARM_SMMUV3 = 1,
 };
 
 /**
@@ -729,6 +731,28 @@ struct iommu_hwpt_vtd_s1_invalidate {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_viommu_arm_smmuv3_invalidate - ARM SMMUv3 cahce invalidation
+ *         (IOMMU_VIOMMU_INVALIDATE_DATA_ARM_SMMUV3)
+ * @cmd: 128-bit cache invalidation command that runs in SMMU CMDQ.
+ *       Must be little-endian.
+ *
+ * Supported command list only when passing in a vIOMMU via @hwpt_id:
+ *     CMDQ_OP_TLBI_NSNH_ALL
+ *     CMDQ_OP_TLBI_NH_VA
+ *     CMDQ_OP_TLBI_NH_VAA
+ *     CMDQ_OP_TLBI_NH_ALL
+ *     CMDQ_OP_TLBI_NH_ASID
+ *     CMDQ_OP_ATC_INV
+ *     CMDQ_OP_CFGI_CD
+ *     CMDQ_OP_CFGI_CD_ALL
+ *
+ * -EIO will be returned if the command is not supported.
+ */
+struct iommu_viommu_arm_smmuv3_invalidate {
+	__aligned_le64 cmd[2];
+};
+
 /**
  * struct iommu_hwpt_invalidate - ioctl(IOMMU_HWPT_INVALIDATE)
  * @size: sizeof(struct iommu_hwpt_invalidate)
-- 
2.43.0


