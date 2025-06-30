Return-Path: <kvm+bounces-51122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 421AAAEEA52
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 207707A58A2
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6722F2ED87C;
	Mon, 30 Jun 2025 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BpiUeoQF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8072ECD1E;
	Mon, 30 Jun 2025 22:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322537; cv=fail; b=iKBF7P7jBssnjJTXJWlScss7iguFzi/RSqO+6NTKS/T0CcYPOJRzacqlslCRYdzEJv0GCfAfhldM06vy22FjQCWgv3+B9FiBD5lVvaX7wizBWgOGzLWr6MDr14eyFrDAoJy8t3RptzCguRcw2cQjmd1Vi1p5pExpaGQTQXa4Pdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322537; c=relaxed/simple;
	bh=NGWI7GRZ2adJC5U2OMXAIL+rUTpidco0EvhvcLTNEtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EQnAWCGAoEizHh1Val6xUvKeCkOGqlU5zpx9M3k5KdRKw9M+sOSrvW/rst9TGEaOj8pw/Zy+DWviZTJDsusYbyT2YIC+BL4HhPfoqK1R9tug86y1c5+GkYaezXQKSSJ8d7qi+eFrOUZnpcVLdqjzX8fA0fxoAEkiYXX57bYjm08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BpiUeoQF; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HsV3DtOldz3FAv8VUyvwloiOxT8hnURqs/g/NVzOFgjaxvGSjtNYG07LADa3S4F1zt2OPjghZPV7fSx0cFNelpFza1q4OQpIMVLXvIX+0GnLc7esSUgBdTy+0A/OvgQVfa35WMIA4Jj2vQVq1gTQZPRYQeZ6uCUZs+zCEgbDNbwdgZj2HPd+cCVq5gHOcVwI4AuFoeiY6ywky+XgPM4TaBEd+OZzfIv8Z0Zl8H7bbR2gYy86aSd+abgc5xyKTR2/MrAVJZpM8xidrN6xUueWzqnKX2kPnaPsNNNgANb8NaSLlwNK7ClgN+UGolJ9ANzlY7YeFkIruM2xgE9llITKJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4PIA7lfezTDcCfgVbySV23mjldVbNTjAqRvA4NDm/c=;
 b=As/EsOZ7CUfXLuy78iua+vdzcfrtq6s6KFXrGCYgF2RcL3h4XIMTi6yuhdc/hfLTfaAKMKWp9rYVw7KN5P51lcxTPD5w4EhczDKaduTkr5gDb7wmqTk5QJ5KBRLL6im8RmdY6dBNSdi+rt5Ju9tfrkcavU6/cit135BUpgdjvgxyK6q2uWSDdYMoeVqz/zKcI6OpvAf5pOJSwFudd7Y7VwThN30msaS5gflAM9t0sqzJryH8l+8tYC2JvVAFQuIxwFaAqKzEME7l/5WruEQPtmyxUv9DWltLE4eUSoXvb6nmKKz8sNSZYlbHxms3lRfqkQ2L0ch99AAUFNTKNTn4Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4PIA7lfezTDcCfgVbySV23mjldVbNTjAqRvA4NDm/c=;
 b=BpiUeoQFVdWspUcf3nbprqp9qib5rhjcPrdUG68bFtdmqqwdhe/eUstzmQapY+8hzDzzlYNe+UthizCoF1lSnpTtS3M5m8Cb2eYwI0lPGgFawUObsdWID91MMZln0aabO62DPxx+Bz92pT3ZLXzLo5E5ufYG/dpNxMPOo+HolWU/8/ZcEKWoy/9Axs1gSAtotwEYQf+k2q8IYt0EurYq/aBGuFeII28ii6JzZknlBBOjPG3odNugOE1Sh04ARWCzZ4f6atST2kDwcu3vaoy2lwIYM0sAMQPZa+Dc4Pq2iUPdtkkqNo8GpZhx5/9wIv1GU9tuR10XspCGC0kTZtABWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:47 +0000
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
Subject: [PATCH 09/11] PCI: Enable ACS Enhanced bits for enable_acs and config_acs
Date: Mon, 30 Jun 2025 19:28:39 -0300
Message-ID: <9-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:a03:54::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 8415c05a-add9-41b4-d84d-08ddb8257a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1LgOGdmJM1JaJ6Ak7kruH3KAXQubFBwzb8crsst8Rl9KJ6Yk3qeEceZI5jav?=
 =?us-ascii?Q?suz5JKkpFMzPuKAA+Ya4MVHJpaG7NxXb55o18+E7OgEu/a/Le7n8i06quwgG?=
 =?us-ascii?Q?fyj4l/mDkm1JevjefBQh+miXll0dFiOmjvaRz/x+qU0aVc9ce2LHEgslAvCE?=
 =?us-ascii?Q?MLrn6xcoE3Tdb+UlIARQWyRyXntlA4TLGRoSW54lLD+tBxJnzo9jD9dbJtEJ?=
 =?us-ascii?Q?jXp4L6O9cwKrC0IcbsuHLKz3kB/pHeF1fybTezhqAcR+wjoZa394o1k3lEtH?=
 =?us-ascii?Q?/HlxeSnRwzCq3/b1uMdiTslfB08DsDQ57UR2Dbu7hhnFBsTwNdGssU6mWEfU?=
 =?us-ascii?Q?7qPUiAlpM6QlL47BIgk0Mg/pFJnm5KifGB8JjNWaQC1q/7lNokVU0QlZ/+cG?=
 =?us-ascii?Q?f497i6lZNJX4y5ejgdilnOhR4QZLXToLoiVGs3szXOqSGLqo46aKgjA1tVO/?=
 =?us-ascii?Q?CMCGBqFd4sGrkjOCbQckZcx74doEQu7RUKddMjgh9pEmewzHzTzUEdit786E?=
 =?us-ascii?Q?zzt1LdZST0CeSn9cOGeD+2kFSZYmEt91UaSMbCtWckrQHYGcgLCaoufLbhVa?=
 =?us-ascii?Q?wRhC8jaMfKb3gzRvxd6isEGBdkUmOekL89UXqK4CXLY087qE1evCNdJ2zQ46?=
 =?us-ascii?Q?/Hd/7t6zx0vatM8PZK+hUNTqiDI3QDEhvC+qkJpQ7CDBGlEas/N1BkLj2HYX?=
 =?us-ascii?Q?auHHGprnkgYZEsfOKNtedUgAXruLh0E00MKhOOvJRIHadJy2yEHUKYVYpw2F?=
 =?us-ascii?Q?ObVBAySlh2kqjaDykNQARsjxoVfkAdRNvAgC2nhmuD+i+ZnINVTYyDtOhf/d?=
 =?us-ascii?Q?Js/NiBTx60KN2baKRSL4hZQpwNLTHTcwQ6oUUuHe0Je5NjW1L6yz3xv6HMlY?=
 =?us-ascii?Q?3t+5jJJSG6F+DgJoKO4JrLS4GNDwCeN8bVLuZtFCi70Tukk0c+k5MiKuFi3v?=
 =?us-ascii?Q?kWzto11KYWyZLaa9lAdq4XP6SfDj+E1NYE2TDtoH90FWqPSBrBAnPmTca0VS?=
 =?us-ascii?Q?YmsxCcA2pfZnsdD0/PAM8ZX3kkfSmS22KNqSZkv0V+OEQy9Prd5MWZgMkYsU?=
 =?us-ascii?Q?rdoMY5mXN5LRJmC3m5LqgqX+YG4mDFq/6DeMk19C5VISDhWqQS5ozDosaoT1?=
 =?us-ascii?Q?kjWHQ7AOSwA2L3v0Gemh+Wm1Z/UWF5+SlziSLoMXtnSqSd1kid/JtnLs3ODK?=
 =?us-ascii?Q?lNZ0S21L9AWiWXQoXqrP7UJwDpAaWELWkYCZwJ3/dDqcaCJCtPAEZxQbzLcp?=
 =?us-ascii?Q?oDFeA8+V84VU+3Y+sLRXxcCITSaJBn52ZoF2pJ2LONkm2QHFk1jltw+8MZWI?=
 =?us-ascii?Q?u/GLV/p0zdWm0PyYW3fSex4E7EtQm4bGB26Dweky6LK6LmY3OyQ25onMEgkw?=
 =?us-ascii?Q?trqwfl3c40sI2RG2KXDSQvXJSYIz2ou0nSN6POKdAwVnpFp4x+3baoh8JRw7?=
 =?us-ascii?Q?FZ+rP5THZhc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wAccbhmdNE/UjiM9/9/3kzGY+fI0TjQ6LWFG6uJaSwjme3kbjYAg95mcWeDQ?=
 =?us-ascii?Q?SD3vLiQGBeQSTyEs+NaVGKI5x/oIMpc/Cw6G9B9sd/kyQJr80uNJHumMXMRs?=
 =?us-ascii?Q?tkBjx6RCr40KGBC8DvuaFps3S45XEuwqwcToyMLEp52ajItybOKigXFE1Ej1?=
 =?us-ascii?Q?kvwnyrxIB+YhN6K9bhPqjr//gYqWJmwpb52PatYKht6QQ6sXHDNBiDAxz7ys?=
 =?us-ascii?Q?J7991V/HdU9EUslCMevFWYmhXfOSBto67n5zlBnHy7i/xsmHhY2MBHQmw0oO?=
 =?us-ascii?Q?GVVh+j7dFvDJJQFqLYeoyPJQ20qv+VPB49nVoksfiifOXc/Ze43Gf35vyWCK?=
 =?us-ascii?Q?dY3GGju5JOapcZrrIoQsPI+exdfnyQewCOMpTAgdTUHhlqYwyGm5I4HRRvNj?=
 =?us-ascii?Q?TnpTofx9monLphFfBz7ROqfZJWz1Uu/CjhJu2dMce8tf5wifhV3ZNmrwjqF8?=
 =?us-ascii?Q?jIi2Tm7cV0kubpVUFTFOVhSiqQj2KXTXsaqtZmFi12jddn+QlA3uiVyhAk1w?=
 =?us-ascii?Q?uHtEYiCbWjXq1w1X8W0Sq+OKPhYT6DkzJ02N3hR6gNVHAIto8YpWFaj53mqo?=
 =?us-ascii?Q?xXJUrTPRgIjdcUmyhJXbWiwe+keEmwR1XJbAg8+K9OrageIhQql4pee3IsGp?=
 =?us-ascii?Q?gMmRZRd17mvuODqunTkchZs+c8g+DPlya2Y3MYCpgo2g3ATxiM0Hmy+WB0Jt?=
 =?us-ascii?Q?7xKm5syUpfctyCjiOhaFXSx2Q5Q0BJGS6ymRsTqK6kAWMTA+shgGnctbAxaP?=
 =?us-ascii?Q?23ynEuSe01K7sVcyOKzYf1pHq4n+K51CA/FXUCFTHxzuNfI8tYrOd+oydege?=
 =?us-ascii?Q?2piN2s3bgBn1OCO/TTrC/sgFEMKqxwHzKhaQa4WVxOVehKivx7aWUM3nIqus?=
 =?us-ascii?Q?3mvwIYEKwo5SGo9geV14P6Qvr9BsBLsOf5Y6X6siP6337CQrO1i2nUbDN/+H?=
 =?us-ascii?Q?ZkARObFhaLzVxcthpC3RjEoJEsMnGePUlyPs8TEyRwfxv2f469VKb5/o/nzX?=
 =?us-ascii?Q?mNSG6As3yixp/hUgF8deGb9vP90nuJ62D8dn3y9NP4wtIH6uv7jxILfABfB0?=
 =?us-ascii?Q?zErskuY6EKpwBsppiETUz8/P4N3n4PkAjv537ytLXxJ2BW1V01mlpy47Fr8I?=
 =?us-ascii?Q?gaV1B+x5/MoMBcjDeMJlwXJ1DbSsnU/nME2h8MVjZtxQCxnZIcP2qgTh+lyl?=
 =?us-ascii?Q?s3TA2H9PgSL6srAJWXqdhSBqOcL2DOFPbtzFArWw0ok3Lt0pI/zVAQpjpSld?=
 =?us-ascii?Q?cLZnSTLAwG2cgQhA6oi4PjYe9QBdO2yR9kDMC1CNzy98KtV2UwRhxwYv4J4W?=
 =?us-ascii?Q?Xs7HuJJOJalShXucXSKIpzI8TR7oofZldzo9DxwsP5k2fVymfM346Xk2e2gh?=
 =?us-ascii?Q?7xUOwtoSw0fB4d7v/44z5321FbgoEERqxjslYqAWwgGwEAWPqr/7kDxH2eJW?=
 =?us-ascii?Q?c6c50fubSZJg9a3JSIyDVUmrOZvn+XZY39x+PPBJ12Bgu5M/bhKErhntD5BH?=
 =?us-ascii?Q?4XytM3gVfp63aW6oNjD0MiqqwUYPlh6g7Ncnm7b0eSWNGbPp6gDgZCkF1/D4?=
 =?us-ascii?Q?G17ksURfKd1pCRPk6gaQTYumB7CsdIAw48Mj5ekj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8415c05a-add9-41b4-d84d-08ddb8257a73
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:46.9484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5+2HS5CPye5/Kq2za54NzNKHdqMvcr39PGCt686aLcNpdg0w7ODLumF7kzcvzv+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

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


