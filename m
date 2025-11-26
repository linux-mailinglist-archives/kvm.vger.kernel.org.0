Return-Path: <kvm+bounces-64754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4B2C8C1D3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 397A94E6D79
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 21:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D58B33ADB0;
	Wed, 26 Nov 2025 21:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RMJfoniG"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE463128CA;
	Wed, 26 Nov 2025 21:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764193939; cv=fail; b=eCLKoROPxbQe5gAaJginEMohtX56wpM0WkBIlw+D/YSrmwRWOktVohBo0hqAdFIAJQG1EM9QIi7Ogiz+yIAiFdcP3M/UhfR81pLQE4rf665s6AJUCq5Ni0Z0V1rwAcHL4hmH1MOEk/WbIzsp6MIo//EjSIJkxFTfNaEv6LhbSWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764193939; c=relaxed/simple;
	bh=sU6CoUrb+EUqlL+AQz8yi7bpXWF4V3zN6QroFOycfsc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vcc/OcBXJkwP53rK1qA34mCGUBsxF6y763RTyGX+p0mM4AsC9huOXLrP0DiyyMgGNxmYHhjo3AhtdgHCE5aKRF3E+XtuO4nC+qYEd4uh+GojATH3x3AX2ftdtocmGbWl533kipNWTOzns1nWabk+pW/81Y/H+Cyh3yqJBJykVyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RMJfoniG; arc=fail smtp.client-ip=40.107.209.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=es2dGHtcqYYe9+xtYIK+EJfyWYKmRTTYo5lj+BpZlDifkbImWJXDi/D1cgNv7Pn8YGtoyvwe2q64jVL5lg03ddub7Ge6kITUYSHp6wOPnB+GSFjLbsrBYz33Z5/txOP+C7F1sTpD8HBCtU6V55jJtgxxQXaRzXibeqrrt6fMEKotOAeiE5fapr9LrxV9RF9elnlswMrnk7t6tdOgSjBGdQjkp1T0LuVsXPyGKp4nKh8z9oBkqGgsqcu5wjFC+8fr0nyonBnRGjkugAGH8/6Ke2y3D06o/qo3Vix9J/E4i8Mw6voyBuDe29FhBoG494xRywe4clcSdhb0yVKfztG2bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUv4ETNm9ri1oKyE/LQX4ukYgaHuXD3Ecb39lakpCAI=;
 b=sImza7yOmUXkcqCcDhyduO9xwyFDofTNwH/2bE/NWs4xrfvVHvSSP6UfBxW3YB7yNHf4x5cJ54aroqaXlHa7isV9sff8vITmT8alS/yYnsYQ0n+QtfO3eyeqpfUj9F+PL/i0Zb41TnaSelNP9jMHx32RbRx5pTeMO2XsglmmFErcq7RpPTu5Ae3/U1WiJhHt7+c+JG855Nfpwht2+OJqunhqfMIubLwNbU+DF1kYbuRXCjj/BVJ1f2QOqJ/C8YD0oaUVW2BW/VnZl9velCdebQEB4qyJrpFaa6iT9f3zGzpUYqL7QF/O0GLjFz93RSPc6I4bL8VvQjYppM56PKobUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUv4ETNm9ri1oKyE/LQX4ukYgaHuXD3Ecb39lakpCAI=;
 b=RMJfoniGzmDTvr9sIlfFB1Y9ZP0w47OtOQUlfsOeF9GMnV6hYULU6C//terC/g1SB+GTM76A1BaKlxwYNz6+OowhtV2yY2A7QczB1RmVj1NYYKIExWo7lpJQxv/pGGPvn3cjN3XrcQNo0OgMESkI+xIvSjHVtOoN4nc8yMkI9p65S/XG9l0Bf7qYsS3qVMOzFfWPztYozI71LAxLSUQjWrs1ehcuFLiA/xDLzSTM6lqBtLUTiimBh45kBrbnTfNDXIctLhIYLBgvNTBvaD+9OKgcCqZAU5gx8zEtntaAJwrWpKuMPwQChv4Tw8bXwyD0zsSvi7O214UpoPETXcwSAw==
Received: from BL1PR13CA0271.namprd13.prod.outlook.com (2603:10b6:208:2bc::6)
 by BY5PR12MB4211.namprd12.prod.outlook.com (2603:10b6:a03:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Wed, 26 Nov
 2025 21:52:12 +0000
Received: from BN3PEPF0000B06C.namprd21.prod.outlook.com
 (2603:10b6:208:2bc:cafe::bb) by BL1PR13CA0271.outlook.office365.com
 (2603:10b6:208:2bc::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 21:52:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06C.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.0 via Frontend Transport; Wed, 26 Nov 2025 21:52:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 13:52:00 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 13:51:59 -0800
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 26 Nov 2025 13:51:58 -0800
Date: Wed, 26 Nov 2025 13:51:56 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
CC: <joro@8bytes.org>, <rafael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <lenb@kernel.org>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <etzhao1900@gmail.com>
Subject: Re: [PATCH v7 5/5] PCI: Suspend iommu function prior to resetting a
 device
Message-ID: <aSd2fAgUlPDKukMj@Asurada-Nvidia>
References: <4d2444cc52cf3885bfd5c8d86d5eeea8a5f67df8.1763775108.git.nicolinc@nvidia.com>
 <20251126213204.GA2852059@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251126213204.GA2852059@bhelgaas>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06C:EE_|BY5PR12MB4211:EE_
X-MS-Office365-Filtering-Correlation-Id: f5dac616-1d9a-4e40-106c-08de2d360e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ig9yjKeg98O0mxqEG/KkkuAswYJL8FvDCKkwnpWlRMB6TpUEFmqfjapkkVXw?=
 =?us-ascii?Q?dQY0ImEuH/x5PB6Bt7HnUfVkCM1yDJDNNVl4twNI7D6fZaRWTofXUQhqJf7h?=
 =?us-ascii?Q?ePE/P9ZeP+heen87fG1plRTCLy9BJDjdpKsGzWD+BlSu5UGwUIEnoFbYqTP+?=
 =?us-ascii?Q?UWmjHYq7AKqHQ6f4UX7+qvWgU4bANqB/qwsjBibOyXZQHa94bfjHtgedZrDm?=
 =?us-ascii?Q?MWYXgF+PF5wz6FWaos4t9OEHejwf2PY0rQtgcAthQ+Ywk48YtRSF9IKt0uSU?=
 =?us-ascii?Q?cHOV12tCGs7eMNCGlAg9KivchCfRE9jWBAYcVJu53NHzUtlyyJotpUuTPlQL?=
 =?us-ascii?Q?i8h2L6HNH6LS5m/OHV2d4FjoIOTp9zOUT7UkQboKz9DQbkUruVgMsP4EnOsQ?=
 =?us-ascii?Q?yb3nEeu5QMqSTJZMKWGpnp48aWbgjMMlzyrROsIw5W9DByy80MGeqOx1XYI/?=
 =?us-ascii?Q?Xq0BEl/sCSv6En33fQ4FMuF1VJJxQmoKgr/+18klRlVKkjy2XUX21HhlcUSW?=
 =?us-ascii?Q?YhqMVj2JedcxvziZeiXPX3OSaMhKxzaGdiEhhyj6A1wLkoWkyj7vquALJY6x?=
 =?us-ascii?Q?366RWMjZ0HZmX71HgCks8hw7gh4v8CKgu9KxzJsGPnERAbZ/lkYydfIwspL0?=
 =?us-ascii?Q?nPpsLG7HTbPCTrteH5AZndA5FGmwYgSYAAGJwIMtvVYiSijgWOVPjpzZQ4iD?=
 =?us-ascii?Q?FQkHukeLp9VsqzY+L32HGr/oTT8y3kD/Cfjqh4+MGLJpqTtBrhDN+vwWm57C?=
 =?us-ascii?Q?7bBACsayZ0Jn4OVWRCByyATB1qnE1v1dkOLrQT3RtLutKR2fxJzYyD5aXFxH?=
 =?us-ascii?Q?ey36Rq525irpfzoA3J7z0NCJ2Fb9uNxtoo2q955s3V6t5OEv69bJg+EYiPd8?=
 =?us-ascii?Q?yThj/Gd2lfVuB36MkGSUVCkwURpDmFg+edagGGlHR0Z9xpH5AcN4WKheh4zN?=
 =?us-ascii?Q?meEC9B856rhATKZzqT1ngeAr2ChtR69t2YteEwmv6mrRGmRqZK8dTjrnFzC2?=
 =?us-ascii?Q?p5YqHuODxI9HXfvHWmZNJTrUOpFzoOqkTJfivv9qZ0E8BTeln+2d5CtSaRwj?=
 =?us-ascii?Q?oLoCJ88TdBB2+zM4uwgEfWEXXDUVHgwBKiAC3bRX03IEhaKLSa6D9fZa0wjT?=
 =?us-ascii?Q?R6mafVuAtKdaIh+k/3QSUDdle+zj2TK2arDEFR3GkLOvEjYav/KZ9XYn0tGy?=
 =?us-ascii?Q?hpGoRkeQJv4fsjaWBJDUD864jSoYBkuWh5vBf3TPw2BK6ftMPhRv+TolCqln?=
 =?us-ascii?Q?MmQgWOqZ7/6LEEYJFUtkKEnWPY+qpvldaA9JSOCSzzcZvGlit75Ca7DlwR57?=
 =?us-ascii?Q?IzmfmoI8yCi8qSJXIGjeq41MQHzipJT4UPICfM6+PCcd3txtJ/MnQTt6DZ9I?=
 =?us-ascii?Q?tu/J7t53w1z96GJps6qlNz4AQE8NOXHiBZZrB4bEaG6ARrSc6kiPRko2Epsr?=
 =?us-ascii?Q?YqC4MuJVf2xCFuicvOpZ0i3E7ec8bCMERavrMon2cuNlV5COQW/EUd4JNRXm?=
 =?us-ascii?Q?IW7mnXFVbJpcxw0kNRqr/iyC7MIiYCAc0LlCS21dh4QmBvs3jDvb8QrasKRz?=
 =?us-ascii?Q?ySZFIn6czdQdgt6xdQs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 21:52:11.7894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dac616-1d9a-4e40-106c-08de2d360e04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4211

On Wed, Nov 26, 2025 at 03:43:13PM -0600, Bjorn Helgaas wrote:
> On Fri, Nov 21, 2025 at 05:57:32PM -0800, Nicolin Chen wrote:
> > PCIe permits a device to ignore ATS invalidation TLPs while processing a
> > reset. This creates a problem visible to the OS where an ATS invalidation
> > command will time out: e.g. an SVA domain will have no coordination with a
> > reset event and can racily issue ATS invalidations to a resetting device.
> > 
> > The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to disable and
> > block ATS before initiating a Function Level Reset. It also mentions that
> > other reset methods could have the same vulnerability as well.
> > 
> > The IOMMU subsystem provides pci_dev_reset_iommu_prepare/done() callback
> > helpers for this matter. Use them in all the existing reset functions.
> > 
> > This will attach the device to its iommu_group->blocking_domain during the
> > device reset, so as to allow IOMMU driver to:
> >  - invoke pci_disable_ats() and pci_enable_ats(), if necessary
> >  - wait for all ATS invalidations to complete
> >  - stop issuing new ATS invalidations
> >  - fence any incoming ATS queries
> > 
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks!!

