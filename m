Return-Path: <kvm+bounces-28284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A91C99717F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B0461F2608D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82511E200E;
	Wed,  9 Oct 2024 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WP59PQSV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802D21E2317;
	Wed,  9 Oct 2024 16:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491018; cv=fail; b=CuhgpeZAht/fRow8CdGY9lOLdkqQG+A8VSu8aszQiQX5mBWUHpLIKEgLtDvyJiH1DTIQICxvZi5RpGn0LafQL2XV550B+fa2MrNLmxkwfaH+Dqkp8SgNnhz8f+/JvxLRCiWtuLrqXlnpGoffItcqPIMBWgbgQYzgOs7312gO/Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491018; c=relaxed/simple;
	bh=V2wjOx6gOKr155TZ6M3kkJiXVarvl9lBIltKidwRr4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ji5q+yc3PLErRBfNwqSVykZ68oqxKyI5it+xdrmyeFaSPwf1ZlneklztoDwW2siAtZFevPnq0PlwItTCDtzjyf5j15a8DKkSj5FeSiSoPnn/Lnfy0w33TRStmUAYvmky4BqbE/9Anubu5wblBYJLwr1gUapz+Ll21F7yR9V7WyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WP59PQSV; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BOJQKsvd8pGoQj6v6NjZ5eAxB5cQh9+vqiCUHAoFPT4HcAVo2AZ60pRY6XH7p1cUbVhMU2qj+U82h4Y2TX3JW5SsgV9RGPN9ycNeIsoWMpEVz6JtkCTpVrb+BKkb8TrC2piYTNk4OJQHSdKtH/oYyRn66Kl4sn1BiTy3dczBiYJgVpaFLGT5m3F4z66AfHNAN8lHTFYYHAltdvmzv06b573wTadcDHdwJXKPzRCGNTESpKESY5YR8n7d40V27sRHn0vHHXNg5nvxj0hcGo6RBPBnnL1jJFHAvEfeP2pdpSZTEbzL5GT1IWIFih4+SJqZZZsVBHIWWZwjDf2rFwjM/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtyZeUfVqQGF+J92e/Ex+NfEnCO3YPW4rt3u8dymwIs=;
 b=jJ17CGYEI595qlH07ysOnzS4lEKsVLJ+zpW5qA4O57betT3JY8rsojoxCKhuTm9GTZTvN84LPilZYPbpfdU2RZqASefBOYRYF3eJ3Nmi5XnHBQfW/r9zeFLKOKJPnN8+zB5eG4xlVmR8jSeCbt40fiq3YVH7OC5q60wiJmn6+98VAyPA9q/94fpHQ/M75Dkdy5QIGDb0MHRlaH/wjxG/X/HVEB+ZWrLNSR/0kitP3D/S4tX6cfKrR1EzOH9wT7SuvvGs0Wrt+8nc0PBq+7a34+KBJv4uey2YNKPHgWuUjoEnmc8cz4qKn0obMrLH4Tq4LqCVkNnYXjkfrId7XYMBAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtyZeUfVqQGF+J92e/Ex+NfEnCO3YPW4rt3u8dymwIs=;
 b=WP59PQSVodu260F+XMV+x2ZpSxJW5tug+aRRPJlQUfOc+Y3OdkvSNrZH8fvNhRMu5FVPdjF3LopeI/uXEYCEMbfZcgjnbH52TPIq9vAGl10RPS8CS9Y/DZPlSs51/OoecXDk11NZcUnyuk3aIBWR13rc6AuhqrCb83Vt0OP0gBgmA57nHRksBhgGZtA+GoJMTmAX/Tho/mKd0oq4R8f8eArW3+Qs1qN1MkieYEOfG9ZRh3ZuWyzFrsyD3lKOG+DXIFIJmWFUP5C6D/9PUXclAYGDJwhTN+WpCQUUxMF2PVRNJ0mHTF5QENRTZpmMw0NmjYDxXEeakYxMYwDSrJ17ew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
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
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 8/9] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Date: Wed,  9 Oct 2024 13:23:14 -0300
Message-ID: <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:208:256::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 275fb3f3-e540-466e-2cef-08dce87eaee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uDjN32kFZQexoxC52aRugyqIm6xXk7RhgbYv3jR8YTpn3ZQ8wi17jEoXzkVP?=
 =?us-ascii?Q?O8gnFc7YkGbHbx1b1/Fuf8Tf5mmZvusHaqrEaouo4XIkshurJ1oXyfv4ipM0?=
 =?us-ascii?Q?CtsCM+V4khC0IwbS2GXXo0iaLpMEK41Nlm9NJs7+2p7L5YCdIWHEr0IWBgig?=
 =?us-ascii?Q?aJSLrNBFJghgXrKKV0YGGLLzS3zojubUG91aAfeS+Jea2nOyconQdE4bVyah?=
 =?us-ascii?Q?gA19EB6I91eYKu4Kn4o23QG/waQBkBwShbFvLlWeMXxCuSkuR5tgrTS1d6+v?=
 =?us-ascii?Q?ee6DrpMwbaGwsuR12bBTW2yL7FaCnCSPNypaDWG5HvrOALR3tY5vW+MdWr1u?=
 =?us-ascii?Q?Pm/lxuTFF/l1ThMX2USycEBzJokUbO6i0KQauLXGdHaiWL0AMbQVSxT0VNAR?=
 =?us-ascii?Q?mUGLxDVam3cxtl4OXj2KbE4gIIUentDA6CoSVufODcDLs7TMH+faS6DOppI1?=
 =?us-ascii?Q?yx8Cx8ZRmF/tfyHOQRhp1R4upj4/mRg08Zlh1DsM5as8Mhw3Q/q/sd8UYesY?=
 =?us-ascii?Q?hdz3REqQBVgzhdF9DWH0C2m8APU4XsHJEXBFIuc9Iz9pviz4IvAH6EDK4AnE?=
 =?us-ascii?Q?tLjwK2plu78yvjfXQFUPjoSgewNvbFTUZgwTV7km/KDuW5xya0kXQjheLloQ?=
 =?us-ascii?Q?HE3sw+qyxGKGDUY7JHwB78UPaq7N5Cn4GILX0HJ51UW2oqJV7i4B3MWAf1FC?=
 =?us-ascii?Q?6iDUMuus08Qm3NQdcB2ry9lOO53b5X/xUkTkS7PWtpHFIujdqIoo82llQ/6k?=
 =?us-ascii?Q?wpNu69NpkiAam4pAbqMqY+Mj/ubNQr/rZFCwW2j+Ew/isXYheoOdq2Yq4pBX?=
 =?us-ascii?Q?D/JPPREuQavC+B0dD8GjE7TNsFoSqJ18gywX1Ty/cTcPC2hhl5GzucsDLpRK?=
 =?us-ascii?Q?SNLDbkOrZWRnwfqMlanKGFOXmiPBsVr9IzIJxwiMdVykqv20su0oKiMkmV13?=
 =?us-ascii?Q?yL8PETOsHD7cvztWV57PW5I5c5wefmHGKfJIjjW0rzZ/IzmCbyRRQqgqLN51?=
 =?us-ascii?Q?BJDFE992WEzdspYHjlW6JKIUKylbgD4i7PQNvKK7ILrFI3gv5Aiqm5Ar2ncU?=
 =?us-ascii?Q?fFlSBDvP+y2A6Wue+TiJ2sOOzXUeQauVaXxwYcUi1WlBN2SRQJ9///Qixmw5?=
 =?us-ascii?Q?fpCg29Oi9Q+T3IlBz5foD7q9lFrnh8jjJqnI60BtO1GciIvQsCnePyVfiuvG?=
 =?us-ascii?Q?waOoTKYD7YbJ7FERXJLyps2UiRBechGR33IPgnhwahgq6VYNblSTpCQ5xBH6?=
 =?us-ascii?Q?Nq2jkViGoRvn6ddWYO/mq9kYta40ZOrn5BU1y17357W49hOQyDfRJQJiyz5z?=
 =?us-ascii?Q?OxMupz2Ab+6Qx3AKJxfxBIfI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G7mub9zJeUEvUl4ZLcffbxwrxPP/cklt+6NX4dxmljmwaoFRR1yRWmTvL+1j?=
 =?us-ascii?Q?mVKqODsj3Ogke6jeenl3X626mMJuHJZwAuVzd0q2lw+xJdv60hqtCOTo/AKy?=
 =?us-ascii?Q?rBw0k9ZdUIZODa/C+21AxCkPtfr/SUd0BRmfIv14h4sxK4ES1wSkjVhE8s1u?=
 =?us-ascii?Q?0XkIECnh0p/S9UVlluERyA4c6bBxXfHhKJe/ElyoIOOpiEPWTYvK317nLD1i?=
 =?us-ascii?Q?TKnw//ZiqAfwXyqJKk+GhpTnbMtl2DfAoNwIWgpdwwZDErMDuLtWvTOY1kuG?=
 =?us-ascii?Q?YaVvU2TJvZQmEIIxyFZVD4zZw8lTRcrrRLpqRgKOYc8fIn980VRvP9zEQHVr?=
 =?us-ascii?Q?LDlv0/sW6xGxw9qtdZ5kFm0bl81bT8oSydqgH8H498tO2xV4putrn+AaJB1t?=
 =?us-ascii?Q?YAf7n9B7gdxe0e6eCA1+Zb/sBFXsWrGL/FnZLAabfjjRGIH2LZ0ESwI51asl?=
 =?us-ascii?Q?YzYCDa9/jYmyP3lVaCKmwczFV0Tf8ZJZtFj4ieCKfe39Y143nXXD4S6vU25m?=
 =?us-ascii?Q?9XliTjPOMCW8iJl8rSfzPoV2QFyu044LicHJJiVf2hCgkjoAqCudZVuSGsO4?=
 =?us-ascii?Q?FeK71alZuaNc3rFs5DLGZt12/eOxUOjRs163w9QctP7Jvjyvm6lj1r9mINpE?=
 =?us-ascii?Q?60Jar3958IWeIA7NyxYobfVwPkMfFKKjmV1cyqMxZAsx1lxLneIHrs6O90uw?=
 =?us-ascii?Q?/rt2i753ueqE1iHaEXqb5zBMJXePFbmfCYtWW+haczhLhIAzOC4baoPyE8w1?=
 =?us-ascii?Q?KTEJLR4ixbvFfuyCg1s0do0BhPzUramW4/FaGa/npAurCh2LZyNCUwDPyFUi?=
 =?us-ascii?Q?3JiPZm9dLlk2gDrhUdmRAViKbSzGlYDOEde0Th6CflLEOm/ErTUgu5tdyqq3?=
 =?us-ascii?Q?gBY+INr7DJeEMEa3xJK+fZcfjX52Ev7aUXs9bpimTBiLzW+DOcv2H3vo96tX?=
 =?us-ascii?Q?IQxjBZ8FlsTXaiXEkNZUaRUWJ+nGTRefdsAR9UN96Y4OjN020u/WLpkMDTZ7?=
 =?us-ascii?Q?1nwEjyfDPaT5uASno3NjLlPlHMnD87ZM2uyecezWji7Tf8AN/kZIJRaCXDky?=
 =?us-ascii?Q?FPuQa8vDwvjyffYgqXxOw/DcDTsrgH8qdhj3aJxpeOn/LeQUI9d3Cfj+XbNp?=
 =?us-ascii?Q?KAW65K3inDKSQUWnusGzPUU3xUxv0HCzSadvsCB+v2GQgR4YHaBzmf88/znx?=
 =?us-ascii?Q?e2AoN5Lu6OivNWnwy525BYGP2WE/wBqtMuZIhJvqseoPZftkVW4u8WmLs1CP?=
 =?us-ascii?Q?xYf4KD+Co3/Z6h1s7B/TlR+6aWBzUkw5CgtDbL8V9ZWA+9JpeuTxektLLahW?=
 =?us-ascii?Q?TJKHX4+77F/Pv6hdrEvPwHRzX9WxzDDWaShKZ5oFW5y6x60Z4hSajUjKREMA?=
 =?us-ascii?Q?TzDnaHYL4O6GGjlg8SKPP6DYmLeV1E5mDmcNdJF+otIinxPzkfXBxL+BERZ1?=
 =?us-ascii?Q?xqWva6cLtnr/Km8e0H13MYj4Ot74NxmpiXJ48BE6a0TyMu4wo/YYQxWO2tQR?=
 =?us-ascii?Q?1nZ5UuZl7Y1nEvEqcznGmRkLH734DuUIO+uwjPbW2MJPLy9yoY2WD7FfZeO8?=
 =?us-ascii?Q?tQl2h5ovNosv+1wGp80=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 275fb3f3-e540-466e-2cef-08dce87eaee9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:18.0294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQ8inluB3mx/TrznFevgN0AY9V1FKGD2pS87on0qWqZdoCB6FVwqnqX3RcaCPEcl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
as the parent and a user provided STE fragment that defines the CD table
and related data with addresses translated by the S2 iommu_domain.

The kernel only permits userspace to control certain allowed bits of the
STE that are safe for user/guest control.

IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
translation, but there is no way of knowing which S1 entries refer to a
range of S2.

For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
flush all ASIDs from the VMID after flushing the S2 on any change to the
S2.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 172 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  25 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  37 ++++
 include/uapi/linux/iommufd.h                  |  20 ++
 4 files changed, 250 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 3d2671031c9bb5..a9aa7514e65ce4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -29,3 +29,175 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
 
 	return info;
 }
+
+static void arm_smmu_make_nested_cd_table_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	arm_smmu_make_s2_domain_ste(target, master, nested_domain->s2_parent,
+				    ats_enabled);
+
+	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
+				      FIELD_PREP(STRTAB_STE_0_CFG,
+						 STRTAB_STE_0_CFG_NESTED));
+	target->data[0] |= nested_domain->ste[0] &
+			   ~cpu_to_le64(STRTAB_STE_0_CFG);
+	target->data[1] |= nested_domain->ste[1];
+}
+
+/*
+ * Create a physical STE from the virtual STE that userspace provided when it
+ * created the nested domain. Using the vSTE userspace can request:
+ * - Non-valid STE
+ * - Abort STE
+ * - Bypass STE (install the S2, no CD table)
+ * - CD table STE (install the S2 and the userspace CD table)
+ */
+static void arm_smmu_make_nested_domain_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	unsigned int cfg =
+		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(nested_domain->ste[0]));
+
+	/*
+	 * Userspace can request a non-valid STE through the nesting interface.
+	 * We relay that into an abort physical STE with the intention that
+	 * C_BAD_STE for this SID can be generated to userspace.
+	 */
+	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V)))
+		cfg = STRTAB_STE_0_CFG_ABORT;
+
+	switch (cfg) {
+	case STRTAB_STE_0_CFG_S1_TRANS:
+		arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
+						  ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_BYPASS:
+		arm_smmu_make_s2_domain_ste(
+			target, master, nested_domain->s2_parent, ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_ABORT:
+	default:
+		arm_smmu_make_abort_ste(target);
+		break;
+	}
+}
+
+static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	struct arm_smmu_nested_domain *nested_domain =
+		to_smmu_nested_domain(domain);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
+		/* Currently invalidation of ATC is not supported */
+		.disable_ats = true,
+	};
+	struct arm_smmu_ste ste;
+	int ret;
+
+	if (nested_domain->s2_parent->smmu != master->smmu)
+		return -EINVAL;
+	if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(&state, domain);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
+
+	arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
+					state.ats_enabled);
+	arm_smmu_install_ste_for_dev(master, &ste);
+	arm_smmu_attach_commit(&state);
+	mutex_unlock(&arm_smmu_asid_lock);
+	return 0;
+}
+
+static void arm_smmu_domain_nested_free(struct iommu_domain *domain)
+{
+	kfree(to_smmu_nested_domain(domain));
+}
+
+static const struct iommu_domain_ops arm_smmu_nested_ops = {
+	.attach_dev = arm_smmu_attach_dev_nested,
+	.free = arm_smmu_domain_nested_free,
+};
+
+static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg)
+{
+	unsigned int cfg;
+
+	if (!(arg->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
+		memset(arg->ste, 0, sizeof(arg->ste));
+		return 0;
+	}
+
+	/* EIO is reserved for invalid STE data. */
+	if ((arg->ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
+	    (arg->ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
+		return -EIO;
+
+	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg->ste[0]));
+	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
+	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
+		return -EIO;
+	return 0;
+}
+
+struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
+			      struct iommu_domain *parent,
+			      const struct iommu_user_data *user_data)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_nested_domain *nested_domain;
+	struct arm_smmu_domain *smmu_parent;
+	struct iommu_hwpt_arm_smmuv3 arg;
+	int ret;
+
+	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_NESTING))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/*
+	 * Must support some way to prevent the VM from bypassing the cache
+	 * because VFIO currently does not do any cache maintenance.
+	 */
+	if (!arm_smmu_master_canwbs(master))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/*
+	 * The core code checks that parent was created with
+	 * IOMMU_HWPT_ALLOC_NEST_PARENT
+	 */
+	smmu_parent = to_smmu_domain(parent);
+	if (smmu_parent->smmu != master->smmu)
+		return ERR_PTR(-EINVAL);
+
+	ret = iommu_copy_struct_from_user(&arg, user_data,
+					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = arm_smmu_validate_vste(&arg);
+	if (ret)
+		return ERR_PTR(ret);
+
+	nested_domain = kzalloc(sizeof(*nested_domain), GFP_KERNEL_ACCOUNT);
+	if (!nested_domain)
+		return ERR_PTR(-ENOMEM);
+
+	nested_domain->domain.type = IOMMU_DOMAIN_NESTED;
+	nested_domain->domain.ops = &arm_smmu_nested_ops;
+	nested_domain->s2_parent = smmu_parent;
+	nested_domain->ste[0] = arg.ste[0];
+	nested_domain->ste[1] = arg.ste[1] & ~cpu_to_le64(STRTAB_STE_1_EATS);
+
+	return &nested_domain->domain;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b4b03206afbf48..eb401a4adfedc8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -295,6 +295,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 	case CMDQ_OP_TLBI_NH_ASID:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		fallthrough;
+	case CMDQ_OP_TLBI_NH_ALL:
 	case CMDQ_OP_TLBI_S12_VMALL:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		break;
@@ -2230,6 +2231,15 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	}
 	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
 
+	if (smmu_domain->nest_parent) {
+		/*
+		 * When the S2 domain changes all the nested S1 ASIDs have to be
+		 * flushed too.
+		 */
+		cmd.opcode = CMDQ_OP_TLBI_NH_ALL;
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu_domain->smmu, &cmd);
+	}
+
 	/*
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
@@ -2614,8 +2624,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master,
-			    ioasid_t ssid)
+			    struct arm_smmu_master *master, ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2644,6 +2653,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
 	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
+	if (domain->type == IOMMU_DOMAIN_NESTED)
+		return to_smmu_nested_domain(domain)->s2_parent;
 	return NULL;
 }
 
@@ -2716,7 +2727,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * enabled if we have arm_smmu_domain, those always have page
 		 * tables.
 		 */
-		state->ats_enabled = arm_smmu_ats_supported(master);
+		state->ats_enabled = !state->disable_ats &&
+				     arm_smmu_ats_supported(master);
 	}
 
 	if (smmu_domain) {
@@ -3107,9 +3119,13 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 	struct arm_smmu_domain *smmu_domain;
 	int ret;
 
+	if (parent)
+		return arm_smmu_domain_alloc_nesting(dev, flags, parent,
+						     user_data);
+
 	if (flags & ~PAGING_FLAGS)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent || user_data)
+	if (user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	smmu_domain = arm_smmu_domain_alloc();
@@ -3122,6 +3138,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			goto err_free;
 		}
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+		smmu_domain->nest_parent = true;
 	}
 
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c9e5290e995a64..b5dbf5acbfc4db 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -243,6 +243,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -294,6 +295,15 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 
 #define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
 
+/* These bits can be controlled by userspace for STRTAB_STE_0_CFG_NESTED */
+#define STRTAB_STE_0_NESTING_ALLOWED                                         \
+	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
+		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
+#define STRTAB_STE_1_NESTING_ALLOWED                            \
+	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
+		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
+		    STRTAB_STE_1_S1STALLD)
+
 /*
  * Context descriptors.
  *
@@ -513,6 +523,7 @@ struct arm_smmu_cmdq_ent {
 			};
 		} cfgi;
 
+		#define CMDQ_OP_TLBI_NH_ALL     0x10
 		#define CMDQ_OP_TLBI_NH_ASID	0x11
 		#define CMDQ_OP_TLBI_NH_VA	0x12
 		#define CMDQ_OP_TLBI_EL2_ALL	0x20
@@ -814,10 +825,18 @@ struct arm_smmu_domain {
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
+	bool				nest_parent : 1;
 
 	struct mmu_notifier		mmu_notifier;
 };
 
+struct arm_smmu_nested_domain {
+	struct iommu_domain domain;
+	struct arm_smmu_domain *s2_parent;
+
+	__le64 ste[2];
+};
+
 /* The following are exposed for testing purposes. */
 struct arm_smmu_entry_writer_ops;
 struct arm_smmu_entry_writer {
@@ -862,6 +881,12 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 	return container_of(dom, struct arm_smmu_domain, domain);
 }
 
+static inline struct arm_smmu_nested_domain *
+to_smmu_nested_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct arm_smmu_nested_domain, domain);
+}
+
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
@@ -908,6 +933,7 @@ struct arm_smmu_attach_state {
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
 	bool cd_needs_ats;
+	bool disable_ats;
 	ioasid_t ssid;
 	/* Resulting state */
 	bool ats_enabled;
@@ -978,8 +1004,19 @@ tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
 
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
 void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
+struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
+			      struct iommu_domain *parent,
+			      const struct iommu_user_data *user_data);
 #else
 #define arm_smmu_hw_info NULL
+static inline struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
+			      struct iommu_domain *parent,
+			      const struct iommu_user_data *user_data)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif /* CONFIG_ARM_SMMU_V3_IOMMUFD */
 
 #endif /* _ARM_SMMU_V3_H */
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b5c94fecb94ca5..cd4920886ad05e 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -394,14 +394,34 @@ struct iommu_hwpt_vtd_s1 {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
+ *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
+ *
+ * @ste: The first two double words of the user space Stream Table Entry for
+ *       a user stage-1 Context Descriptor Table. Must be little-endian.
+ *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
+ *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
+ *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
+ *
+ * -EIO will be returned if @ste is not legal or contains any non-allowed field.
+ * Cfg can be used to select a S1, Bypass or Abort configuration. A Bypass
+ * nested domain will translate the same as the nesting parent.
+ */
+struct iommu_hwpt_arm_smmuv3 {
+	__aligned_le64 ste[2];
+};
+
 /**
  * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
  * @IOMMU_HWPT_DATA_NONE: no data
  * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
+ * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
  */
 enum iommu_hwpt_data_type {
 	IOMMU_HWPT_DATA_NONE = 0,
 	IOMMU_HWPT_DATA_VTD_S1 = 1,
+	IOMMU_HWPT_DATA_ARM_SMMUV3 = 2,
 };
 
 /**
-- 
2.46.2


