Return-Path: <kvm+bounces-51968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B782AFECB3
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E24DD643372
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB3B2E9733;
	Wed,  9 Jul 2025 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cKxldeqR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933172E92AF;
	Wed,  9 Jul 2025 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072757; cv=fail; b=g9wf1F1Vaa9/l++5VRZnmZjN9nKt1maCO1Fy6Q0Yojp0NQtCJhxVVK2Z9i1/uyO46LbDpkhiiFhxG2W2l+tokPkQqhwFUGQm5wzIsMSctuKUqpd/EPapvPxW2B0TCcE2fHD2fWdCZYflqZ3KJ7vYUgfqMALzdREtLR0UBpHTjMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072757; c=relaxed/simple;
	bh=NGWI7GRZ2adJC5U2OMXAIL+rUTpidco0EvhvcLTNEtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b8P5b6JGDGonE/G1iEGC6szdGvO7gIh176CFgT2mcXwCc5e2QVPxCR1+7glko9Ph+gba++xNx8ImFKnF9XG7+1aLNhP4iSOsEO4QpRY/SGgErBX7js+3R3Koj/DASVWVoSRCq46wqLpRTu0xh14kG4jWnVLfSLkH9Fa3/Tbd/3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cKxldeqR; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jxcnHtBQxAMszVw3UQ7kEJYVLM44+w75VNFkMMANCkaFy+YlEEA74lclGiq2M28VUZR5GczRKw2K7dGIfqkEzSdu18VuHY10S5NbEXgjbMvudUIXvxVkUACDRdXbdCSvE70WyyjhUozZhAdFb3JdffvVkHn4xlIJCkzXl055/47yBGcYK3EwmTf4+C2OM9dHu36YNU373FT9fKZDbeulHL9SAzY5713B2I2bi4pvn+afm52mgKIJQEHGt/geO3r1bysS8ptj3y+poCsZkHau9me2GdfizjF/JtraLs8a1GZ6rZ3v5zK6kxxm3db/5f78++lC0k1snx55ZIiqiS9cQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4PIA7lfezTDcCfgVbySV23mjldVbNTjAqRvA4NDm/c=;
 b=vBSj42h+1fLSn350BKt9HYOK+5AjTrjnGcb6ObziVAFlVbW7DzyGSQPpyTcACAVb0YcwINxwnRbQuyYAKYZVYzgofWzdT4ieez45iKmM4FQGDyXrQxE9X2TbCTyc2K1c36wRi2BE54oyAwq3DhDqGuJXi+n0iBYt2QbgYqUpHsNdoeUW6p2NHmM/CuE7JwFQqHA56NFrvldEGc0deUuF2b6Us2VRb4UNjQ0RqbYUwknrNZoaY00l543455SmpsT1oyJ1vD6eJSxFfEEDK+KHdvobbquMAvt5WrinxUWWMvDD5bLmaQV7p5DpN6LDTopY8h6zONi76Jcd1+x9fk+qZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4PIA7lfezTDcCfgVbySV23mjldVbNTjAqRvA4NDm/c=;
 b=cKxldeqR9TEobn1vPP5n6ccuM3D7XS92kaijS2AJml478PVhAFsZCReVY+3ubFpnhMcppk1UoxVTjYyt41JDqi2DiLe+Ab2EQs8HiRFtVd+WgzH68uW9jX+iNnfE7PvMMl9SU7TsYYQ/HFKHGpYGH4BmEno9DnMK/M+hpKt8FFvdyBortNE6LmKDvJVsDd3i3tZklNDk32sq/30rFzcywMzJmE7Ijh3cq7Wq6YR3WcxwQ44yaa8gvkK9VZzvLZrSGhQ0VncwjNgyY+ZfCKm9S0dYsNzWkq57SPsiGTCAX+JkUZPmMtBLu492P4S6iw7Gv4hISxA+X/CeV7SSbpDuSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 14:52:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v2 14/16] PCI: Enable ACS Enhanced bits for enable_acs and config_acs
Date: Wed,  9 Jul 2025 11:52:17 -0300
Message-ID: <14-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:806:6e::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ee266e1-e485-4b6b-469c-08ddbef8369f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5epCZcrw31me7eaebJIS+v+eGptkEtILO8lkWO3a4X96uUwZ8HN8akCeKi33?=
 =?us-ascii?Q?NOVoV+ya8+r58Dauuh2DcNrdLl7DlMVVes8Vm9WWrMaP5R+68tBcMk5mXLrU?=
 =?us-ascii?Q?xwli3dn/kJ5Eb2QjyTDrnyxRAR741ve5UM09NehqwTxVuP6R11CFSG0SSXrn?=
 =?us-ascii?Q?af0xhnJmH8FB/ETcGPIEv6aEzqksoC6GqcOAyI8qnbC/DnDKM8B/QUFrXjk3?=
 =?us-ascii?Q?Qbk/vVWab+PbboHb2zNQwmijLgoUlumKdnC1ha2zXBt7pRWW8qX/hQFgkGiL?=
 =?us-ascii?Q?hOrnZ9Hp9OJzNx1RKTSw/Uy6YUvqrsS2QlCnY3DRVxnxMiM98EWPsO6Te6O8?=
 =?us-ascii?Q?q1WBIO/ZN2iRiWhvqpc9uUt8qnkCTQ6sW+/kb1CTQjPXf2DunNZyDy38/4eC?=
 =?us-ascii?Q?6sQTEhPFqDEkyCBocJnijcL7wLJ6QiYqCh+wVQPmwuYYX2tfSEFTlE9VfvqP?=
 =?us-ascii?Q?XVtRq5uEe3hg0bCwn2V9jJ/7vtrX3okhH7khA3eR2MRwwEHoKi15EHC5T5wU?=
 =?us-ascii?Q?TNUeyDWs6dT1NZ1Cur02gC5BdnWrQfvDIT/8d/DItEaCVl9+nvQkk95YHEyf?=
 =?us-ascii?Q?KwdsdB9B/Aca68F5vT0hE1RZPSzBzCeDxGhyZGptRwSzNmA1T63K6PePlxfI?=
 =?us-ascii?Q?oQMAaL6uwyuGaBuLY2P6ZxwXQsRMQzIeycLUpD1AqF/6eHgk7DJha4E93CC4?=
 =?us-ascii?Q?Jx9siniexVRyn6kOl4fADT953EhRyIWgGqopx+G/qoswaKYADUcjF1KfW2Jz?=
 =?us-ascii?Q?OF0ceA5Kl1lqIWt+6D3NGFQnMWVBVxqvL8w3I4VwZGDAkogeDBuncAhSZUcP?=
 =?us-ascii?Q?aaCPIIaUc6P3XdV2j6p7WsR2WABFjwzhGIuX6a1DU7c1QJUPrKrOPIdAOIFJ?=
 =?us-ascii?Q?01L7WntLB0JIS/y5YM6RFDwt5IIBb915119hcBqUZblu4XruUASReHveUUQc?=
 =?us-ascii?Q?lhfzSPrZi2+ENpA3Pyd6+2nLt0zQgvvUMuKdn1waI1UzozeEoEWxV0ypeJ1o?=
 =?us-ascii?Q?Ifqi+v1xyRaH5nb/AfRBHjeX4eOTPFEIv6V7ImQ7cL6xHJK9tpVnAnzlft58?=
 =?us-ascii?Q?/uScFFoe0rr4D+AGaqOZMkBWaVfJosnW+yHdJRPBuesSrVP2QVYirO0FWi1/?=
 =?us-ascii?Q?TuL6JUcV08hGLI3ZFt/tbJEF/ChLeJaq64dzk37U9dwFJd/Sbm1coaw4bFQK?=
 =?us-ascii?Q?EjiojaEjK5p/nR7zU8xwb89ajltcU31is3UcQNpDw8Wb72vva73621FqvmRm?=
 =?us-ascii?Q?FCGCmEyC+9rVZsed4PD7zz6AhEsyuFCkVGm510aMVnMsimvsgaJ213njiqbi?=
 =?us-ascii?Q?MtlujpC0b3ovFUM7K1zT8pQ3HCJhpuZlrxlfheSOjShSTrhRhXK9287nRRKP?=
 =?us-ascii?Q?k9hfn9OTaRWRka3sznh+gptDFcHf0o7FeZMf9VzAPhkXsFCm8GRYzBDYct6w?=
 =?us-ascii?Q?UNwxO1SwJMY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1HjBa0aqkpaJsyC9ULR+13IfZrLpLlw/WRpvdYtDDNRygo4Tvbt5bi+Knyt5?=
 =?us-ascii?Q?9IzUueck+QdRjbqBMRoSXkLup5btoRFZz1iykFb0IR4dpeFcXC1izW4Oynm3?=
 =?us-ascii?Q?3PS/+lo6T7ZhxUmmIWrL1c6+G1EUZqN11l8ToN7gYbqlOXKB+28+NGY21ym6?=
 =?us-ascii?Q?zbayiTeL7BfuzDur/edrbztNarHEqNoC0tpSiCbJYBLVHUVSET47KoFvnXDI?=
 =?us-ascii?Q?2AR396v1Q8QlurOjLV1OK9Pq3kmz7XrLreKN4AZtbMmfeKSBq2B2gR4rGAkv?=
 =?us-ascii?Q?s+np0B+wj4zxB5vyGcWVXmRG6nkiHksfbZdsgslHBZSngUkq1ZeocDGsvJ9t?=
 =?us-ascii?Q?bquu2jbnj+owhwVywBvlOdBYe3jHkcTi1K9hNR5VMfUBVKZSEvh1LtBMTmgo?=
 =?us-ascii?Q?Bgu1wGokbJAnO5G7+G29AUNdxfenzfc+jSZ0Ymi6r2N+SH672FtfOLXcCVs2?=
 =?us-ascii?Q?B6G+oq7DRSRoZlDUUpyP0Ng8tZ2UG6ngowdZuAX0A77B2kGPvS/MzYIb8oQp?=
 =?us-ascii?Q?0rdhmkvnbnNlqqQXjznZrMm19+zhXx6SzWaRSk9V9ux2nA2UaOPGgs0kGFjJ?=
 =?us-ascii?Q?J2VWEi3iQYeM2AvdDOV+eAMEb8TnNA7t3xiENy3es0hzt4SApTxR/bqkK9+o?=
 =?us-ascii?Q?JeG9s05zI9g3uPIl1QEzyxdkO2yMV2DsFR9PQZCdbzUKUE8lnril34ee4rwu?=
 =?us-ascii?Q?s7c9Lp5wfxyitzJhCHljSB9B8dPmhddKJQdxgLSgH4u3Zx6sv+j7wlXpB0+9?=
 =?us-ascii?Q?rhJd9vN2as9w/QkIcTkaxcz6LLJlG3FMft2CgnOluvBj45QfE+g78YxagpgX?=
 =?us-ascii?Q?rzCqExxS5wvdnWqBSULTDnlgow/NmI0SHIDsSO3H2eySk+4na5DSFLWt3HWq?=
 =?us-ascii?Q?0RDc/8kcmpdu4Io9ZRTWp68zeOqMdkcaEQXXmSBuP3+LTBlvSjjywUQ/DvO2?=
 =?us-ascii?Q?3l+K6KjhV/YCUuA4LsA5xBMU7XqVhdx/GSHXu80/bdOh+vMEb0hXxJ9Xcwmp?=
 =?us-ascii?Q?RDYksoJn2yYMz9FXqARm1WOzrxsYAKtWrR6vcXXH8qd6Y0QfKjtwCY6LkQ3U?=
 =?us-ascii?Q?GCPW5uJ4vkrichcKEcA18oBvdduRzGFiew4eR3r/owsLqdxFLdlyyTbiKksS?=
 =?us-ascii?Q?l3XqaztpeFNI5lRz09ZoEbuoN/sBWdWiG8op7520Vx5aNMn0IJnlLDHLn4v3?=
 =?us-ascii?Q?lUuUn5RH4LxcrZA6usBexDeDgfG6XXhawDPv26kNvjT/mkpODfQLVH+RDW33?=
 =?us-ascii?Q?RH+D9khNuKUutvZla86fTBn9JfyygD9dynipbW2o9B3l0UdKyH4himwJIMW0?=
 =?us-ascii?Q?psBSItbMneviSG1cqQGy6NUu2Plr3jyNXeAMmHV4xqtALJeiiDnJS5A8xWrJ?=
 =?us-ascii?Q?LCuo70h38YGUiVLhnjDDOZts2sgOGb5RD1ZrC/fypZoyC5YKdLOMPKRW9y4X?=
 =?us-ascii?Q?nrO2kH9QpiGFiSGwzARirMtK9RrMTGdXzfcofetnJrYSlG2LnF4enp1jri9o?=
 =?us-ascii?Q?Sz6aM5A93mRX4S9/r5Wxno9zt5Kfkh0okPLEta8FdYF0jIJKkF7lPjXdNyYm?=
 =?us-ascii?Q?i8LcOj5MM+jYzHfWHnkxthkCAkNgXAlvUrjjlTcv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee266e1-e485-4b6b-469c-08ddbef8369f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:23.6022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dD87zse2EZiNsiGCKfYpg27TLeuyqfJMr3ik96bxVjTnqfXHP2Dd8lMZ7MrNBVCu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125

The ACS Enhanced bits are intended to address a lack of precision in the
spec about what ACS P2P Request Redirect is supposed to do. While Linux
has long assumed that PCI_ACS_RR would cover MMIO BARs located in the root
port and PCIe Switch ports, the spec took the position that it is
implementation specific.

To get the behavior Linux has long assumed it should be setting:

  PCI_ACS_RR | PCI_ACS_DSP_MT_RR | PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAMED_RR

Follow this guidance in enable_acs and set the additional bits if ACS
Enhanced is supported.

Allow config_acs to control these bits if the device has ACS Enhanced.

The spec permits the HW to wire the bits, so after setting them
pci_acs_flags_enabled() does do a pci_read_config_word() to read the
actual value in effect.

Note that currently Linux sets these bits to 0, so any new HW that comes
supporting ACS Enhanced will end up with historical Linux disabling these
functions. Devices wanting to be compatible with old Linux will need to
wire the ctrl bits to follow ACS_RR. Devices that implement ACS Enhanced
and support the ctrl=0 behavior will break PASID SVA support and VFIO
isolation when ACS_RR is enabled.

Due to the above I strongly encourage backporting this change otherwise
old kernels may have issues with new generations of PCI switches.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/pci.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e9448d55113bdf..d16b92f3a0c881 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -957,6 +957,7 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
 			     const char *p, const u16 acs_mask, const u16 acs_flags)
 {
 	u16 flags = acs_flags;
+	u16 supported_flags;
 	u16 mask = acs_mask;
 	char *delimit;
 	int ret = 0;
@@ -1001,8 +1002,14 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
 			}
 		}
 
-		if (mask & ~(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR | PCI_ACS_CR |
-			    PCI_ACS_UF | PCI_ACS_EC | PCI_ACS_DT)) {
+		supported_flags = PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
+				  PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_EC |
+				  PCI_ACS_DT;
+		if (caps->cap & PCI_ACS_ENHANCED)
+			supported_flags |= PCI_ACS_USP_MT_RR |
+					   PCI_ACS_DSP_MT_RR |
+					   PCI_ACS_UNCLAIMED_RR;
+		if (mask & ~supported_flags) {
 			pci_err(dev, "Invalid ACS flags specified\n");
 			return;
 		}
@@ -1062,6 +1069,14 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
 	/* Upstream Forwarding */
 	caps->ctrl |= (caps->cap & PCI_ACS_UF);
 
+	/*
+	 * USP/DSP Memory Target Access Control and Unclaimed Request Redirect
+	 */
+	if (caps->cap & PCI_ACS_ENHANCED) {
+		caps->ctrl |= PCI_ACS_USP_MT_RR | PCI_ACS_DSP_MT_RR |
+			      PCI_ACS_UNCLAIMED_RR;
+	}
+
 	/* Enable Translation Blocking for external devices and noats */
 	if (pci_ats_disabled() || dev->external_facing || dev->untrusted)
 		caps->ctrl |= (caps->cap & PCI_ACS_TB);
-- 
2.43.0


