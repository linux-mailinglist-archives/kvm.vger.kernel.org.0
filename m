Return-Path: <kvm+bounces-39649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08AC9A48CD3
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 00:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66D7E7A4979
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A48A276D28;
	Thu, 27 Feb 2025 23:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Uq4ok4Uh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFAB276D15;
	Thu, 27 Feb 2025 23:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740699150; cv=fail; b=J+KG7UNGeAFrAwQpwuLc6riYkKhPhrHOmGUg6uYE6oozlAWuDkCPeBq4tuBtxfNKWfcDQUaWoUmmZXZzBpe4JyzduXnCtkLrkfuvl5V+FZ6q8W9t8ichROKvC7hFWgIGxNrITJLr3THDDbYdYzB1rqRGCW4iwLUKR/YALTfm6is=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740699150; c=relaxed/simple;
	bh=oceikjqQ8Ih/wTQ5F+yrSKyWYGiqHQbjJKVnQB3Jwuk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTR/q2IA3vzaocnjBj6AIKq113lyFaZp3Gp2DDkbGb3d0KOOa6QpnUOqT8XLCedoDSh09fHBCCtE3jtY8/YhLAJVWXu/1xCKHzuI9iGXQwPFoRK4iDzhf15wSGqx/N5ESpdwuJr8mItzBfRHhKliZ/lcGQNOyGIYTWttguvpAzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Uq4ok4Uh; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ix7JHH1oDu0uwT5nbXhBn8OATLAKG+CWUvK6SmOOzXKqTPpwyvqRldFKxAVFwXmEJgzENrQesB8cWU3LZmrX/dhPVQtE8UJB1DaJvW7TPYa92yZMoOu62iS31GWMl6CkO2Wt07VcevTdrHmO7OdWcVdLSmb21WMDhc7+ExyXpf19wycgaTudbZ5G64SM5O1EtM6ckaJKEqQXwZeBatJBV8hNsVLIQZkafWhrYBpL6ab3kddb557cW3Gst487tsAVygxssB/C2F0e1xMxdyJxar3STW78/4CSV23C+6S/XAlEssCTYiNArVUiOMp4R1Y6u6s6YiayS0YJTUkhbT/OCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EF4JZF6kcM2dZTCgTIZoVaR+s2zyR5W9HaElTnkmI5E=;
 b=jv2ZyFPTU95G3fdN3Rz3+/1wfUQ6UFSGNCK54W6LPfiVddJ9dpfaSj4m1kONscLAo/e376vg2J4sSIwFPBRm3wlBhXYTp4ZNUEO/N4miS9bd/4JR2ziyLebNvYCPoJf4DWKN4ZRukWJTWe2Z4Ni/ev6B6aLkTRLDRPSKkW0fwB1csaWZ7/F0dHJZyxAyqDAguaLVSvIaR4wfoF+nZ0LHZ5N9oAROlp3po16JBD+wkFaVpmfDLa5awTOdrV8TEvJCg50XLs3KuXRoWWaVstCkRKwI6DE3Yjp5SojHwwd+hamviSaQrqL9GBnYzouodUDZRVdLAZct5stSdSBpXheKjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EF4JZF6kcM2dZTCgTIZoVaR+s2zyR5W9HaElTnkmI5E=;
 b=Uq4ok4UhcroFFSmZbHYsfiFNx+RbAd/ABFshrEAptf4o1/+9AGTmJ0QXcKgZwv0cdt//Hy450KD7WkcDeVVbeU5qSBRPhyycq9qXYEyqgL2L03XskLo+6uXL1QyiDvC7V9dISY0OrZCwcUdrt3ucv49EWQFDZTswGN183BmWYpOId4H+2n1OzgYOMgECJsa7Gm91UtlA+b1IlffYm0jpwiKlMn4+hmAL2sSg65QjLlX9P9z5Yov30RBo6NWuS9CP5GNsKyTQlp69+j4+uPnWMQfIjO23+LZPk06GWxsAJpPWYyUymvJ/rur4Qzt1s3w+ZCvyUIpMUFIYFxBrg6mxmA==
Received: from MW4PR03CA0170.namprd03.prod.outlook.com (2603:10b6:303:8d::25)
 by SA1PR12MB8741.namprd12.prod.outlook.com (2603:10b6:806:378::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Thu, 27 Feb
 2025 23:32:26 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:303:8d:cafe::76) by MW4PR03CA0170.outlook.office365.com
 (2603:10b6:303:8d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.22 via Frontend Transport; Thu,
 27 Feb 2025 23:32:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Thu, 27 Feb 2025 23:32:25 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 27 Feb
 2025 15:32:14 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 27 Feb
 2025 15:32:14 -0800
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 27 Feb 2025 15:32:13 -0800
Date: Thu, 27 Feb 2025 15:32:12 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <robin.murphy@arm.com>, <joro@8bytes.org>, <will@kernel.org>,
	<alex.williamson@redhat.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 2/4] iommu: Add iommu_default_domain_free helper
Message-ID: <Z8D1/BWdTY4TtoB3@Asurada-Nvidia>
References: <cover.1740600272.git.nicolinc@nvidia.com>
 <64511b5e5b2771e223799b92db40bee71e962b56.1740600272.git.nicolinc@nvidia.com>
 <20250227195036.GK39591@nvidia.com>
 <Z8DSGF0tGgvkJh41@Asurada-Nvidia>
 <20250227210336.GP39591@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250227210336.GP39591@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|SA1PR12MB8741:EE_
X-MS-Office365-Filtering-Correlation-Id: 32424fb7-603a-4600-e66c-08dd5786fdfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B6QAg3t72xHOkhuaRJBSinu9v1ylHh29GdUwJDfVPyv8cmSKq/W5tWagjVcD?=
 =?us-ascii?Q?NjMribnhNlBkcU04HrDCaOtt6ZADA1Lwons0LmyEw8VQG6nm7tMN9PV1iAUI?=
 =?us-ascii?Q?Sn8bCRDyi7KFNAgOFWh8c0071wtHBvJesi7HhwJiqWwIVecAZQRDIAWNllaj?=
 =?us-ascii?Q?+xtNg26JCIX6Dum+fmloWNODOS6eHaFE9V12dBIppAJRLCkJ2g5jEO1icgkK?=
 =?us-ascii?Q?GrVG0z4Aud4MYLf559yUa7yYDQRl/JfJYVY+FYiQ3Rge70qo7eQgPksxldQP?=
 =?us-ascii?Q?c+iKegRrD5K/6ME+arK8W1u92I2K3Ej1TkCeXo3WSbsUzuIc0PP8e/orJxRS?=
 =?us-ascii?Q?trrcrZ/cWIYIIpzIHZMO9D8Qp2UyJAnNZ1W87IldKszV4O1Z6/PwNhRq+4VG?=
 =?us-ascii?Q?H0wYyfcjtoLB0nfaLkDmalC+QOEXAeKh1Cu+llIGNHdNDaHGl8LfXjZxAxMv?=
 =?us-ascii?Q?Lq1tJgy6x1YI/pgAMq29S9RrygYGHbBoPeJfCcJ/U1Vpm4Q7OY+mwEhyhpXl?=
 =?us-ascii?Q?RcdKd/ixwFmthQBvdOdk7sy3MSdKmCqr7y6hVRcYINXgx7m9pzoqKXS91uaS?=
 =?us-ascii?Q?vyIiZqGD4l3g/nVMZnQ3GoR52IpxvEZt7KPzBtZB9ubcoFg4PLAP6MhoHIDB?=
 =?us-ascii?Q?YirzLRIbcXa7r5tUWcOsezz5aX8Pi2B8Pr1woWibvLr92aLy7Ir3cZi37ml9?=
 =?us-ascii?Q?CVgpkGnOm8jCFHmjeA+hRv+8NnCFgH7oeWDY5BTY8VgFCdqoVuhXi09T05rm?=
 =?us-ascii?Q?viIa21nNFWRy7lIwmpNG528ivIQVCfdhttyKbHbIW8W9p6PtT5oFSrr1pFje?=
 =?us-ascii?Q?rd2Wy1GHpBIIWSTc/uZOXEleRt7BwHXaiBtaNTP3u6fVaqWMgM0MH6O6yofC?=
 =?us-ascii?Q?91q+r3XKCbHREBMcO2hYmKXN62+7/rIMiiqhSb5YLT0zw7m1jEIYks5HE2rd?=
 =?us-ascii?Q?n2nt3osnkGNWFzS+gkSG6MPvozXRGPH9kNOKZ+EKOpPns91k0UbVmcEZUaEv?=
 =?us-ascii?Q?+JPAwt+fD0sXN3Oi9iU6xDPb7AGLjdnsAmK20VLN4E2Qp+mp8RuHqmf/UPAa?=
 =?us-ascii?Q?Z1XpaM3cTe5cZSaemsdmFSwD9J3ex1wkTmdLJFxOghiPZKdLIQl/7e9+0tQd?=
 =?us-ascii?Q?ydK3+eQ7OQNNBxMKNGX07ofJje+MGr1M3xWWFrTCc7m+a+MGEuYkPS4R4Lo0?=
 =?us-ascii?Q?GFb1E8M+cywpzx5sbxIBPs2R+vdXcNeqewqWFdwqrEdQB4MIG4i/PiTvTiWs?=
 =?us-ascii?Q?UMmNY2ViPz+riKc1XwDrWfsKajccKF9uZDiu6cCIahOrsu0HlzobAIkmlpyp?=
 =?us-ascii?Q?Sg+YLAuL7kVM/b7MLQLfNoRWcUI8X+b2OzHUBvSqynQzv80Ii5jjnXvRpwiI?=
 =?us-ascii?Q?Z5uai/yTdGU/gqkwnrGSNgetIsJU60p3zEzinv73Dt8cQn0EiZNPmyYT4UER?=
 =?us-ascii?Q?VM/50vmqUCfFjycv5W/SET+t4CdOJxj1L9R8a42p4S1p27RJHkfFQ4lhAthj?=
 =?us-ascii?Q?Dkv5UTv4la8qdso=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 23:32:25.3425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32424fb7-603a-4600-e66c-08dd5786fdfd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8741

On Thu, Feb 27, 2025 at 05:03:36PM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 27, 2025 at 12:59:04PM -0800, Nicolin Chen wrote:
> > On Thu, Feb 27, 2025 at 03:50:36PM -0400, Jason Gunthorpe wrote:
> > > On Wed, Feb 26, 2025 at 12:16:05PM -0800, Nicolin Chen wrote:
> > > > The iommu_put_dma_cookie() will be moved out of iommu_domain_free(). For a
> > > > default domain, iommu_put_dma_cookie() can be simply added to this helper.
> > > > 
> > > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > ---
> > > >  drivers/iommu/iommu.c | 11 ++++++++---
> > > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > 
> > > Let's try to do what Robin suggested and put a private_data_owner
> > > value in the struct then this patch isn't used, we'd just do
> > > 
> > >       if (domain->private_data_owner == DMA)
> > > 	iommu_put_dma_cookie(domain);
> > > 
> > > Instead of this change and the similar VFIO change
> > 
> > Ack. I assume I should go with a smaller series starting with this
> > "private_data_owner", and then later a bigger series for the other
> > bits like translation_type that you mentioned in the other thread.
> 
> That could work, you could bitfiled type and steal a few bits for
> "private_data_owner" ?
> 
> Then try the sw_msi removal at the same time too?

Ack. I drafted four patches:
  iommu: Add private_data_owner to iommu_domain_free
  iommu: Turn iova_cookie to dma-iommu private pointer
  iommufd: Move iommufd_sw_msi and related functions to driver.c
  iommu: Drop sw_msi from iommu_domain

Will do some proper build tests and then wrap them up.

Thanks
Nicolin

