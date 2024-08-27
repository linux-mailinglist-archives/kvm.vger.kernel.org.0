Return-Path: <kvm+bounces-25180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D88A961353
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C25711C22AF3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184FA1CEAB9;
	Tue, 27 Aug 2024 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gj2z0s6u"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535001CDA1B;
	Tue, 27 Aug 2024 15:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773917; cv=fail; b=Bc3w9T7gcIe/FMg1h6rSJWKjVObzWOfIKKLfGD2/kMAAief/UfvDrVhWmRWH0la9ySGrMPyB0sqNVlBaP62igBwAi3jAfVItjFhfOK3VzMNoNGVwcC5XK24BthWuyF5hDL+H0jKjCoep+ftF8dFoYo/aiUqctRPPHe0VdE2mv0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773917; c=relaxed/simple;
	bh=a8/IyaWLJkq+VE927HYHMyEuWermkViTsra6J34ZHyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OlwbBtwOUz3BxfqzSbTNQ5Y+R8MVnz48bAyX7uNUNPWtHV7kAwXRdUmnKlIE7eGkn5ez84abyXPr9Ihm/6FMpjTARYMFF3NY+tcfweOzsN03MgqJtzM3gwx47FLjcYQKeTLl619rs/E5brnaCrp2d3MgmKZZ0Zly5enD7j2rLTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gj2z0s6u; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tzo0/HGjsfUEhCFjovpwa55OfpnAdDxWjLwMigmLQwO9ynFUjdBa2HA8iENJkW1mq4X7fxc0h+0coeDbloMAmcGZ7Ag6hf+L3eJC1t3SPL5pc7DQAl/vEvQnGqp9PQ1IXoDYI5lkkYuxOOwRbIuqtRgjB+J81wGt7MGTmhNE6x1Y6AS4lFmfUqGMzVMrCCdFPombYoL1/xkrN9XSXzvn4WiHK1mfScQNyEESy+Zfg4Inz7rGVQJ7qSOqQ5IAkeLYyElABHc7ZfTPJuxBXZVxLeCrWILWv3+0hujMXkHfefbCekU4KT4TprILxeWtB7492tL2btiHFAV97eymQP3OvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WX93OvQ3W75W1i7406blpXe9zCyJ+KE/WG/ZywkZmts=;
 b=egJmRPvkZClqfdCeSUY+czHt+VDT0No1gw5/cx/nPK9ifrWKbVHSY+gkDq0hifn0oul9cNfZses1C8MIbwIbKOFuMv6eP7mpBWDoHY1NhLgx2mFQicXBKqRNjoqBenvoJnDhAI3FMlYrSiB8eANSjS3vQesid8VLzYVtfGm/N+vdaM6AKmQG708BNG9PD0xEB4678rObLC8h/zCz0yfDOuTG41KDxoVBjs1iVzaXbdtojU1juRJwxVqW4qwHPH3yt3MeVW/bLmyitbC5Zl0kwGWz+4wbYj4C6W0Oj2MkXgN5vKMjVJ5QhFpLJg4sC1A3Hd0AxqvdqfPxxu1KGjpNuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WX93OvQ3W75W1i7406blpXe9zCyJ+KE/WG/ZywkZmts=;
 b=Gj2z0s6uqIVoB0b2J4LSvyPaUW1CPxLotxuV/cV88U4nOSnd6SQUQ2Kfz2fkVlXzCDbwB8EafXev3yUANXtOD8FoJ3VFlpbqXjbKLscCijIs3H5TsPl26L4ohr4leHr2qZdymHHK6d4rG/zTPk3ge+Hc7DWEiUUPDE4qDJ6mWPH7IzZCdKo+ldmooJqmGsysFSPr96ymf77phmcVEdREhA068H2ZmDZT7R8CRBM8WXOq9+m+ek2+0CQ13NJD7hmq6DcboOkSMnHUq3/9tcLpZje8IzEX9Q+mEi3XiODPxuxFhNzIdu/Gsg5U4B/FOckVTBkBHQOKOVwitfMHQtC8FA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:43 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:43 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 4/8] ACPI/IORT: Support CANWBS memory access flag
Date: Tue, 27 Aug 2024 12:51:34 -0300
Message-ID: <4-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::12) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e66d053-eb93-4b93-23c6-08dcc6b0241a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/w+K58wHUvHBiWHW5q9+11ppjqtJztBrJD99noPkBNqO1QQnIgXPkR4/oD+C?=
 =?us-ascii?Q?jziTPnsFB742LOogDGTmsYqEWvltuFh6sLlsXj3+CUUiQaaEaa+s/RAzaVqE?=
 =?us-ascii?Q?KeH01KVMxHM0N6VixOCfrIkrD6MgrjjMya3Qx1d8XWIITzkZ9h85SFtUTXU1?=
 =?us-ascii?Q?Abbbai89NYMqNGTjJ2fV8XESIt94jHRC2Bgx2UzzESamQMtSvuHvR+p0kYey?=
 =?us-ascii?Q?5y6km+9E+/hb5lXK73S7Grs8Ah9K1Kj2xDMLe3X50RRh0+ga24oHHBiLYpae?=
 =?us-ascii?Q?TWorerrUn0oHcXsvVfxSenq+B+SR/35PyPxcLyV5IT2FV6k+18YmyxYXlgUM?=
 =?us-ascii?Q?+YNuvnDDhPoZwW8vzeOyhH3Pt4lMxU9f1dCos/OziQxz9GDmVXbLdE816ftV?=
 =?us-ascii?Q?va1wo5N5qVTspSYOfaCj2EVkY0D9x87Lp+ozLIHyYYDSoYGHvTB42/Lws7Wy?=
 =?us-ascii?Q?qLPujuMojtZ/HCiTxY/KlQ5kZoXW4kliIP2Ik5nkGR0KIRF7oaEF9Podkz7r?=
 =?us-ascii?Q?Q5uSQL8FG3wUiMzKSC5wxEjvBeKCpa621n6+bthPSeXq/wUBeQBIKGtmkXRc?=
 =?us-ascii?Q?8ARQ9ARGKFUcZ7N4HmtUl+AXVKtGRheGCoIOl0Sdstp6VDakoMFj6EXuWway?=
 =?us-ascii?Q?8RczO5YHPImkfka9Ulz2pMnGbr22E7Ep/qtDd7SFoRifFmIAO25q2PmfcU8W?=
 =?us-ascii?Q?T7l8Agf0VgyZCkQ2plXmwkLO4FELuWMUy1bEqFrn8R3FyE7HMTAY56PkUTX/?=
 =?us-ascii?Q?zbyaFVVsb/IRX6belI3WWFfLLK69qNvEBbTFFSwuep0HcRNsgDhBJE7Ha65S?=
 =?us-ascii?Q?qAbMCiWm03OALSYOsmiKkR0VLftxJR6KGKXau80gsez8postndzm7TSDZUhk?=
 =?us-ascii?Q?5Z1e7XyY3suByOXM03XqRvDGEbAy69NHzccGBtzYf84IYrb250Cs5pYGEXJP?=
 =?us-ascii?Q?o1aoOuqfHTL9MfTZTa/QZde54DK83ZACUdePdrWaqYoOQzbTSvMW9b7Bjupu?=
 =?us-ascii?Q?+ESffj5AD/nW2B2pUQLjI7ecMarQnMBhErMa4s+R9pKCDRi0F+cyjeYsilH6?=
 =?us-ascii?Q?M+oeSgM6ZicYJUpGQEmi064lAH0danb77M8f34X9/4DYC1/RyjoLsaXtHFdp?=
 =?us-ascii?Q?PvRlpcG6aR0ipDrS1SPSsCoe3JaSFQMriog48n1lMwTHMMdGPOSVuQMZPFS1?=
 =?us-ascii?Q?nAhEbbaAKf5gM1ygaKo3/foszEruDBNt+hcP8yPQAMHacHCCkU//dZ3hWdK7?=
 =?us-ascii?Q?MzSlcaZoN+SHJizJb1NPWeqA3PD5f/zI0vs0SPpKfT9iX8cHDRbe9S0QMcU2?=
 =?us-ascii?Q?DePKuoWUM2otHmvq8zvL2ailtdTI4zBJ2waUiiG9zQCwE7Cvn7GrVkRoggNn?=
 =?us-ascii?Q?zPoZ2PZQqykjzjS2gn0/SaWDwiMF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wKTR5XanXdg2HCuks0mMcM5Ihmsz3dbRnRtA4LMJWk+yWgAgeersyoqjgiDS?=
 =?us-ascii?Q?aAKZiBnWd19SCrigUSTIRnPV9b5qZOg+I2ofqlDkoRu3/QNSvv4GnDkrkWbK?=
 =?us-ascii?Q?nG6/RkcwYT37B15vLT6EVGcibqEs1uuYnQXIpmIimOUB3CUIE8cW9TciHgj6?=
 =?us-ascii?Q?npPoXNQHG5zMPtKZ8X8zdLgaGYZjqVFTF0sRRC0hEIiCUPKGvt/sBj+VdMyk?=
 =?us-ascii?Q?BtsFiHPxkwVLxd/36r6JjiUht8AWjBusIP0dOvtnnMHzXvAxR+mcqHAD/+of?=
 =?us-ascii?Q?X8QPRgy3FL/TpA15mhFSYDI6Uzp5RJCFG7dcxmewug39XukpT+iyDfJYaKMv?=
 =?us-ascii?Q?QW22ykDP04Yj7TiYNt36qADakU7GNAKIQIE9yvTSs4Adl+XEUs+dT+AG/xqz?=
 =?us-ascii?Q?FcAJQ8ydTL9KRn9cbdUsAQzqUKmFKj8G9yrOXbjB6I+ABnOIQK++g2sz5WNG?=
 =?us-ascii?Q?19Uy4g3zVzuOdwVsJzZlNltW2BiNsP0A60O4hw273FnY70IReK2iTYwN0YjF?=
 =?us-ascii?Q?yLv+C46F3Eu9hpSI/rXLVsjM/fl9t8mi7kuQ8NwUDouX/zxnWYlco1My04XL?=
 =?us-ascii?Q?JxuRnLQBKugEiN/+ANnLKHyEEuJHvn7ADgxtV2C5DZ8pmooD/K48mH00zKCI?=
 =?us-ascii?Q?adb5Qk8TD/qx/9hqnOcgBId282c8e1LkQuyE7WCJOFaAsXpxShbv8ig0Rwj3?=
 =?us-ascii?Q?2v5RVaBHd7Wo4qD9kgf/UmXK9a4oVWx/GeYdArNoqQ3w0yVSSPOv5MpAYIE/?=
 =?us-ascii?Q?cUt249rbmBZOu1zfi40rNpZLlE85KP1GLQskYYEm37toJ2eKQpC/f1gPFNU3?=
 =?us-ascii?Q?kSiWOBGqw+fSEmH08WeHETgM8JBkI+ZykjFoogADMGp5Or4aNbpM2B8bpTar?=
 =?us-ascii?Q?FT/FoaI6OJ0Ttr6WFhW+lBZjZ/CG2luD3g0aRBkbcGnppHHkidBvjry4mOej?=
 =?us-ascii?Q?YLjJ8HzbbmkvciyqjDdtiRxodtZ2b74BYKWO4md/acSYvJjygOp6JkfB9Tnj?=
 =?us-ascii?Q?K1n0Ogf90ifSpaRgllWmtXpo+00h1YpaqzH+9A4nIm9nJaVwxlZf0mLV6cMu?=
 =?us-ascii?Q?AIBouI2Z//128pFlDuP4e5HFdBlKqDwI/+zQd/ZBLCZ9WP505LqNoiZ7G8qr?=
 =?us-ascii?Q?NNKVoZ6M5uMWNoqgozkGXpf/6OjeEvG7l4GKCZWiYrEslgmAHnlXtPKM4Bbx?=
 =?us-ascii?Q?p8iVCHPy7RyNxWk4zK/OTwsIvTgk1TPBmKTP/Bn+wvUigxgRSszf3VksB38b?=
 =?us-ascii?Q?8hfxf1FmQ9K/mpOWkloJ2V9uOjnb6QWxt/RyX29ztV94oqZZl1nnpXiogBA9?=
 =?us-ascii?Q?+okHlGYVRUvnMVUuW31UktBYQaMEIZMdSlX8cMjEEyNxaMWhMAGdWNNZWVYu?=
 =?us-ascii?Q?BWPCxB9ZlbfwOQ0s5hOVSHzZ4wmx4+RMiOFQTc13ZF5eoauNc1EvLgXkRH36?=
 =?us-ascii?Q?y+HHweioMHWSvjmTlbnShboQSTt+nJfTj7Dnx+ezH2Oi32HccXY+Uu1olFTP?=
 =?us-ascii?Q?YuNrNOGl+CyNbr6yvFmTnjcytCIInh/HF4dYFpqXDWiNXN7QtFVJeiTLLvmE?=
 =?us-ascii?Q?ZnlTUHSVO3UejFOjFF3fwbEEY0snZGkG8P+tkcYd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e66d053-eb93-4b93-23c6-08dcc6b0241a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:40.3419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u+FeVvAvnx6WK+0ox+0RFDj3rCQA15C6WVWGDDTQw71tV1YM9ZM48D+1SVMxCanU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

From: Nicolin Chen <nicolinc@nvidia.com>

The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memory
Access Flag field in the Memory Access Properties table, mainly for a PCI
Root Complex.

This CANWBS defines the coherency of memory accesses to be not marked IOWB
cacheable/shareable. Its value further implies the coherency impact from a
pair of mismatched memory attributes (e.g. in a nested translation case):
  0x0: Use of mismatched memory attributes for accesses made by this
       device may lead to a loss of coherency.
  0x1: Coherency of accesses made by this device to locations in
       Conventional memory are ensured as follows, even if the memory
       attributes for the accesses presented by the device or provided by
       the SMMU are different from Inner and Outer Write-back cacheable,
       Shareable.

Note that the loss of coherency on a CANWBS-unsupported HW typically could
occur to an SMMU that doesn't implement the S2FWB feature where additional
cache flush operations would be required to prevent that from happening.

Add a new ACPI_IORT_MF_CANWBS flag and set IOMMU_FWSPEC_PCI_RC_CANWBS upon
the presence of this new flag.

CANWBS and S2FWB are similar features, in that they both guarantee the VM
can not violate coherency, however S2FWB can be bypassed by PCI No Snoop
TLPs, while CANWBS cannot. Thus CANWBS meets the requirements to set
IOMMU_CAP_ENFORCE_CACHE_COHERENCY.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/acpi/arm64/iort.c | 13 +++++++++++++
 include/linux/iommu.h     |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 1b39e9ae7ac178..52f5836fa888db 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1218,6 +1218,17 @@ static bool iort_pci_rc_supports_ats(struct acpi_iort_node *node)
 	return pci_rc->ats_attribute & ACPI_IORT_ATS_SUPPORTED;
 }
 
+static bool iort_pci_rc_supports_canwbs(struct acpi_iort_node *node)
+{
+	struct acpi_iort_memory_access *memory_access;
+	struct acpi_iort_root_complex *pci_rc;
+
+	pci_rc = (struct acpi_iort_root_complex *)node->node_data;
+	memory_access =
+		(struct acpi_iort_memory_access *)&pci_rc->memory_properties;
+	return memory_access->memory_flags & ACPI_IORT_MF_CANWBS;
+}
+
 static int iort_iommu_xlate(struct device *dev, struct acpi_iort_node *node,
 			    u32 streamid)
 {
@@ -1335,6 +1346,8 @@ int iort_iommu_configure_id(struct device *dev, const u32 *id_in)
 		fwspec = dev_iommu_fwspec_get(dev);
 		if (fwspec && iort_pci_rc_supports_ats(node))
 			fwspec->flags |= IOMMU_FWSPEC_PCI_RC_ATS;
+		if (fwspec && iort_pci_rc_supports_canwbs(node))
+			fwspec->flags |= IOMMU_FWSPEC_PCI_RC_CANWBS;
 	} else {
 		node = iort_scan_node(ACPI_IORT_NODE_NAMED_COMPONENT,
 				      iort_match_node_callback, dev);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 15d7657509f662..d1660ec23f263b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -993,6 +993,8 @@ struct iommu_fwspec {
 
 /* ATS is supported */
 #define IOMMU_FWSPEC_PCI_RC_ATS			(1 << 0)
+/* CANWBS is supported */
+#define IOMMU_FWSPEC_PCI_RC_CANWBS		(1 << 1)
 
 /*
  * An iommu attach handle represents a relationship between an iommu domain
-- 
2.46.0


