Return-Path: <kvm+bounces-51967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BFBCAFECBD
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A17AC1753CC
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34D02E92DE;
	Wed,  9 Jul 2025 14:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hhvDIKlY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C232E6136;
	Wed,  9 Jul 2025 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072755; cv=fail; b=Jx1JQNFfylrqYg7xSWv66OfhnZIQpdCsGomxQA7QVqdPEBXzMFIQuh+PL2Tv7Bdj4GU0fNkvmCqTjev+hxaA7NUnZoEELdQB6RchIi+aRmofspAiFiuYMbf886NJNc+7bgEBHqw36CKVA2Rp134XerGT/CcSXTlQL9M/iiv8HjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072755; c=relaxed/simple;
	bh=Fg0FYc1Ne8x8/PZnPQ+Xgf7odFMgCLBXjB1SALL0Sb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hyK9etExUxnCqNTpL5OSq52c2DgYjp8S3oJrmXpZgSkoS9q2oQSNJ5QIiC0oSJwNBtK+peJ93sYHpTIw5NsGf1TwbuwGdgaWoRdzGoEjceEO9nVJWwJMHlPrnXKtUQ5ypGnlRt7hi/7zDffiJy2clJFyCQpyMwclmwzyjYIv/SA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hhvDIKlY; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Weotl6uCIKbXWWTsXtJvB8FPUCUz7ucfAXmvS6/CuYVtlh+WuWTtNih0BvIp0vTEVE5xk3TBX52BD54SoFgigujuOJOSSNrrpy08SvQTLB9/nmXt9ctzxU1cKXwQr/v/IV3lkwpr2rn0z5gXy5yiOlcyJ5jaHZEOw6Qin1DDiO4Hyub/+wj8qJPITqnI8UvVGpSQysQSjY1Hs3psvlDZaH9Xzz6fJ+yltzEq+i2Uo+yDJnZJMUIhUKEy/3fklk7twuTrHOp8mmkUAMEFQ0FXui/qQvlO49G32B0Sj/jTQiFb1K+IWCQmArzVvsJX1w9M23aRexeKBBG92v0qJs099w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbVA381NLVDspe753K2mqK1I9dcnzwNAbozSZ/6Ze8o=;
 b=cBKgE9NXFEfzb67BAAe/GT88OPFZDhPem4Kg1H8eCdFlwyU01eXeLLFuobdkI4dLTICtQCseT2IqiaBhEKtyZChQP3tzrwhCvlFb8jewWaBhN/0Lg2zERaAuSAotR/xbgQ9dNNdG92ahMJbwzDGmzHdPwwoUYuZFHqRVIdTgG3rdiJ1jC5Z1SvLuAG4uTuQVYW3hijF+zY4OirYXkaauJpHuLXXOKMK+czHnvfyfPtZxbQY/vwR+VLvAgTOIhP997neJeXEglzTcxoDw5lVXxDNJuvDmjNb8qFJMoUeALC8wuoAxh2pmoF+Tyb/1HiyrYex8q67NUJESZSN0N4I4cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbVA381NLVDspe753K2mqK1I9dcnzwNAbozSZ/6Ze8o=;
 b=hhvDIKlYmDjZ8v22V2uECGyQbygJaZZm6C+BAiHIQ0tRlKnvqys7gk2VoTtDKweHMP3yVebps82yiar5WPS2IGeYlNmDwNT+ZVm3hfRiSTjTmHYU0xn+O1d80HDd1iMw+Zp8jfbgp9gJLCs+VbzjiUmICLoRC3vZ0QrHHyY1DjD2dhwMZX1clqXUZ3kMjOybvUzfieS1jInv/L+NfZk3wRXkfRpafGocCK6KvuA+/VeU8iaPOzIJo8EhwqoakMxkdvojk/L83BShntaLR3sQQheNV1u89wY7CUzcsFnv4jGkKC+kWMf3Mg7/fhN1QUWSwI37yPA1KG/wAo8mcs84tQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:26 +0000
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
Subject: [PATCH v2 12/16] iommu: Validate that pci_for_each_dma_alias() matches the groups
Date: Wed,  9 Jul 2025 11:52:15 -0300
Message-ID: <12-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 89765687-dbcf-45fb-ffa4-08ddbef837c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aSkDZfZJsk9MtC0e18a9klSdIFF1vfsSM2ShLQPAkiazux2aolowurBoxOsT?=
 =?us-ascii?Q?uYoGWaaU1J68IoCPY8nzRdxDldM04nr85xm/DwOEfAewc9y95YsJXaL8dCm+?=
 =?us-ascii?Q?cCbFYOwmDWPl1Bw60vlNaa9IYdzFkjtmuW2XI2kckEZQ0KRSWegitpoC+SUZ?=
 =?us-ascii?Q?zT8rj040ICsMFMTc7mhmKsIuYTVJ/n5pCThoZwSY5nz+kXDn/gXFMbCKS8c6?=
 =?us-ascii?Q?cI8UP1iG41xJDyTcA90lq4CWy9EzU34r6KP4mwyowDKCpLO6RHtQIEjfyN4w?=
 =?us-ascii?Q?jH/QWaVSjJoVflGaW/+i70b+tDXUKGSPyMTjOWezybA1sykHadsQp4VQ4ogE?=
 =?us-ascii?Q?nhHzx/YK5/4wJ8tIyPbOR+HZ9LxnA4pImWPAFYQH8R+1+5SH+JcT68lH9Jcc?=
 =?us-ascii?Q?3BSHpvW8yjh0aE1OIO1pgXNtDabg9tCekYxh9H8r008wKkcJ/wC5Rky+lVzP?=
 =?us-ascii?Q?vokZ4lrX5C8fMLxfBo/tIjGYyHja0xwS8Yooe79lMP1lmUXIBLC3WxDCpHum?=
 =?us-ascii?Q?O2eJ+X6BNveIP0Nzdv3NFIaB3dEdvUgdQAHram1+AfNvRs4QQ7xg5APyoHHR?=
 =?us-ascii?Q?3mzao/BVhUXxsV2Un4zSKBW31qm/daQV6DEZMFBxnwSA+f4Qmnmhcbc4A6vO?=
 =?us-ascii?Q?5OGIULGJR6+hy30u1AvvsUOAJSZKW4KhW+DEL9N5UPh4RyQZqkKlJA/RHlvR?=
 =?us-ascii?Q?6uOdqNyDyRF8k4U5eNVITNWwTjnghAfcp7gd3NFZeGeBnUpJC/iSc1EJyUQA?=
 =?us-ascii?Q?++4AxyM9FC5QZ6EtREuNu05NpBRSWqqfRvzoN4O56pwsizfYsQF30RJkjf+R?=
 =?us-ascii?Q?MEx42jYZTmA3ckxPIXerW68bXY+aFMbDoPaAYz0gV+KcS9oaQ0D7eMDCMaTa?=
 =?us-ascii?Q?1dpXK0IVgXaDXzbOgO/uRWWjObhcRBRfHrVYkuEUc1pmaXiSC3r2L7xp9+qw?=
 =?us-ascii?Q?Oe4RIGUiTJDFmYiXTLYsK3yck2B7x7rJWjaEJBxT7Xo28EORxuzIlsmX2+3Z?=
 =?us-ascii?Q?8TJ+TTB33S1lLunegQFgu2O9DmGTpcZ0TV04EN7IRmMj4mCfxnJl25nTxSWM?=
 =?us-ascii?Q?PsBP2YdnRgJPrnhnywLCt+qublfN0vbQdsYUYYKL2Tv+QaGGe8rh1kn68pCm?=
 =?us-ascii?Q?eHVWAgTFqH1nzl7h727qZv6USVsYxd10lRCxvXeJZu24usCJOOXm013Q06Ys?=
 =?us-ascii?Q?RzdRJy3kissv+OPq/D7grw5UZHXlOE/8WfBZwNmGpdzx58iPP9394Pk1H+fB?=
 =?us-ascii?Q?/Jwjx35WFMKSEj4PkuvQxlhv4uePP5yZIT5+CO8KLUgXbg1bpyEg3VbmZ4oS?=
 =?us-ascii?Q?nbpKDo7zx8vppTfZaefCgXvnSy/c60W+bCX3pSYnti0YvUPr8mg3WJzM4flK?=
 =?us-ascii?Q?9yvxMH9gmlK0l7DsHPxHEZx/IzVXefa+GJUEa4/5M+hfguJ7aI6Mo8kPSCJU?=
 =?us-ascii?Q?dNgAm+9KPQE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mrv6z4vthQrU0QtbdBwDd3fzUGEXnpQzw81QnaI5+sPjD7/JzQWVwUqTLAv7?=
 =?us-ascii?Q?a8B+m1eYJs57HtADXEe3gVZbX2sYRSg9Z44H+N+W0aPJG6LEf2j0Qb8kOapC?=
 =?us-ascii?Q?nJOoojKX3Q3wwe69fe03es2tpCK+HmYF9Ekpxa7IjTO+ItRmW+swlKFFyQK0?=
 =?us-ascii?Q?5mGEMdZTN2Ng8P/R0y0MErTspuGwDEBDWnwaJk2928zmPOsekyZxihFxL/UM?=
 =?us-ascii?Q?aTukwn1FhOpf4Y2gUbCCOvi79WREfqrE00SGfEGUgogaiVXRzo3tbbjKFFsc?=
 =?us-ascii?Q?8YNsgwCM8SlonKw4wJactZFhe1Kl4iPCGv/V/If6NxKmxBpLIdnkgDsUiGhn?=
 =?us-ascii?Q?mKmlUwzMLJmfcrVUwfy7j2wUY4FrpJUPGoS+7THG8ywS5QcXe4BvFac3myte?=
 =?us-ascii?Q?oI1dwDV9WPAjBsBuDFVFSfwRkydkdjT6hhPnzzW4aN8SRUmMkCmSTqjR+/Rs?=
 =?us-ascii?Q?RUMhi/JCoE2o1uKZTOEIfZ/2kCqOkHN7UPV5nMDWG87Gi7RHcTxU28yT6ojY?=
 =?us-ascii?Q?SaZOc1Q5jMyA1Rq99jAf7gYrJUo2UhWq/dQLQ0jN9DEkHiqL82joy92sMgRm?=
 =?us-ascii?Q?m8lOllvdSfSEOCQa3Nl2Du8ev6TgEhDvUY1ggttJvyUI265YBfAdOJI+YJ7b?=
 =?us-ascii?Q?Cyg0N3v5lhtIyLb5Wv3val8leOV/iPsc443+soUkl50Y2pllKeugmrHl3ECc?=
 =?us-ascii?Q?0ED5Bmu5S7208dvODx4y0WETsAKt2f6XRP0kH3+EY2wQNTokRZq6fk5BExxi?=
 =?us-ascii?Q?rl81qu0RhJlK3jx3rXygMKYSw2DY9cEKCXFoaDvyasii9yL3zl/cYSBrFKdC?=
 =?us-ascii?Q?ArMAcaAuji1fPYnZMAly6CF720+1VUi7NN6mDvcfJQD+YF3L8xCkKYBKWRge?=
 =?us-ascii?Q?wExd137wc9abRiiOYpcvhYN7W6b9m3UmEVIHeXdkvyjx1guHTJ0jSspyR0gV?=
 =?us-ascii?Q?Sd5Nx0FQ0EZygSACJfBJje4K38oKlzDsuWWm3eCGDAGYBCG2Hh1dBFajHajF?=
 =?us-ascii?Q?cdgX/EE3ETRg6Ahgx4hFimCyYjYAMdeDw6/IodSfuo2+qHAYm8wza0i9yy22?=
 =?us-ascii?Q?R77RE887IF1rr5stHEJFEwFV7wsW6ZGAnt5aQQVsH7v/ZijOIE1+Kmjo8SC+?=
 =?us-ascii?Q?EsxGBC3G3VHMMGlPC+3ni44uqWp7cxj36C7xG0MldV5wgQ8Q56HpKwFjU/Yc?=
 =?us-ascii?Q?MS0KkpazQ1kbq00zwSGQ4Auxj51NTcyU6qd/YqeKcIl1IQRFzogYqwtKgZI0?=
 =?us-ascii?Q?/y5J60SlwtwPQZkNSWhLxW71Sei60ZMy5JFRVbGzZ54IbV7mTrgc2oXScOiL?=
 =?us-ascii?Q?cocVU9Tg+SCLMW6PLSxte9m3l2qgxLCfN91VK/Ro8yLhhHeKsJPh8i9E4xmz?=
 =?us-ascii?Q?ZWZlY/6GAyfL7wjn/+griVIauswWTW3nntMX/k95cay6pxvlz+jSP6DU8yAW?=
 =?us-ascii?Q?5zgF0ehAHTK6JVQRFTWwb2lBBda4kBybPmfSofrNE5zEq2nFJapQQ7XyF5VB?=
 =?us-ascii?Q?ERR8/3pYqBGckg08vileoCfHLH1RJC3YMdqdbvfRKm9+zaIYJvp+HDByFuJA?=
 =?us-ascii?Q?M/3giS5LOc6nOYTqhWIk/tl+K5e6Clc6YxxAFEpm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89765687-dbcf-45fb-ffa4-08ddbef837c7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:25.5431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kiiwBmd+hnWAhWhfpOJHhprC8zwO8dFtpzL5MHTG2DIIzXekWFc6hVJqHAI7VF6J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

Directly check that the devices touched by pci_for_each_dma_alias() match
the groups that were built by pci_device_group(). This helps validate that
pci_for_each_dma_alias() and pci_bus_isolated() are consistent.

This should eventually be hidden behind a debug kconfig, but for now it is
good to get feedback from more diverse systems if there are any problems.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 73 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index cd26b43916e8be..e4ae1d064554e4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1606,7 +1606,7 @@ static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
  *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
  *     that bus becomes a single group.
  */
-struct iommu_group *pci_device_group(struct device *dev)
+static struct iommu_group *__pci_device_group(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct iommu_group *group;
@@ -1713,6 +1713,77 @@ struct iommu_group *pci_device_group(struct device *dev)
 	WARN_ON(true);
 	return ERR_PTR(-EINVAL);
 }
+
+struct check_group_aliases_data {
+	struct pci_dev *pdev;
+	struct iommu_group *group;
+};
+
+static void pci_check_group(const struct check_group_aliases_data *data,
+			    u16 alias, struct pci_dev *pdev)
+{
+	struct iommu_group *group;
+
+	group = iommu_group_get(&pdev->dev);
+	if (!group)
+		return;
+
+	if (group != data->group)
+		dev_err(&data->pdev->dev,
+			"During group construction alias processing needed dev %s alias %x to have the same group but %u != %u\n",
+			pci_name(pdev), alias, data->group->id, group->id);
+	iommu_group_put(group);
+}
+
+static int pci_check_group_aliases(struct pci_dev *pdev, u16 alias,
+				   void *opaque)
+{
+	const struct check_group_aliases_data *data = opaque;
+
+	/*
+	 * Sometimes when a PCIe-PCI bridge is performing transactions on behalf
+	 * of its subordinate bus it uses devfn=0 on the subordinate bus as the
+	 * alias. This means that 0 will alias with all devfns on the
+	 * subordinate bus and so we expect to see those in the same group. pdev
+	 * in this case is the bridge itself and pdev->bus is the primary bus of
+	 * the bridge.
+	 */
+	if (pdev->bus->number != PCI_BUS_NUM(alias)) {
+		struct pci_dev *piter = NULL;
+
+		for_each_pci_dev(piter) {
+			if (pci_domain_nr(pdev->bus) ==
+				    pci_domain_nr(piter->bus) &&
+			    PCI_BUS_NUM(alias) == pdev->bus->number)
+				pci_check_group(data, alias, piter);
+		}
+	} else {
+		pci_check_group(data, alias, pdev);
+	}
+
+	return 0;
+}
+
+struct iommu_group *pci_device_group(struct device *dev)
+{
+	struct iommu_group *group = __pci_device_group(dev);
+
+	if (!IS_ERR(group)) {
+		struct check_group_aliases_data data = {
+			.pdev = to_pci_dev(dev), .group = group
+		};
+
+		/*
+		 * The IOMMU driver should use pci_for_each_dma_alias() to
+		 * figure out what RIDs to program and the core requires all the
+		 * RIDs to fall within the same group. Validate that everything
+		 * worked properly.
+		 */
+		pci_for_each_dma_alias(data.pdev, pci_check_group_aliases,
+				       &data);
+	}
+	return group;
+}
 EXPORT_SYMBOL_GPL(pci_device_group);
 
 /* Get the IOMMU group for device on fsl-mc bus */
-- 
2.43.0


