Return-Path: <kvm+bounces-64537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AB49C86A18
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7F606352DFA
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE014246781;
	Tue, 25 Nov 2025 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SdGSAXwm"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010063.outbound.protection.outlook.com [52.101.193.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA1032C93B;
	Tue, 25 Nov 2025 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095455; cv=fail; b=WPSpemqWslwF/GZAcZjGjN49/LxEWLjS7HXNH4JMR9IsQZy3zPO8xBPliJnLBuisKKWvVHk6QYghoK0Y2naeV+ofPl4r6S3/+UDK6pwUOhlewmSIOimBU7cC8b5paXQLpn28P7Fv5OOVJPc3G27ynGrdAUbncpfB5Cu7T0ZZlnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095455; c=relaxed/simple;
	bh=vk7FezfOV59XgAwjYPV6ep8xdPoRLvDBO0jQDlHQ7co=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zg8Khm68d9mg6BG9jW9nA1kgZA095ivZIdo8AhqQvhnsA22n22NgIP+J+QIjqWmsFzUtS1rVM22i0guvTOacleJtrxz//Z77VE7dXTGLj2aOWpfVwhkUrfoxJGiBhUPZRtz9u3CDiXql2DwjWqbKF5UmCVFkwaGl/MCNCHIlxgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SdGSAXwm reason="signature verification failed"; arc=fail smtp.client-ip=52.101.193.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWgR/zn+7fH6BzoyLzq9OiFeygclw6xtlxnCrSlES7H+0HTJXszXIbk0+z21qQEJUdabCO+foBQqyRic4rz7gdjj71/sjew5nYheBPlgD056SHQYHntYdQ05/OcTUIOqCA8pXsjB46NRyPdYePUBk6y18nojZaG92SMtHzi8fSM4+EOBYySMqcI46NEqTJhbLBckqb+jsJp3GxFRoRfBceqYqnkFSPHsJ5X4O+xXrt4ZmN8YXYOkT4mXe8SCQuytZgnQ8nCheUmuK4E2C55pNvGHKvXCJ+FmPRLLUcRIEllIMD0gf/SwZY6ehWgfc2T/4RVgfIfNpZ4Qd6F2VSBjyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGQpHmrX+Ql0gSf/Koep+fCjnux36oPaj5d9D5MSh8Y=;
 b=maWVfqE8l30owotF4WlF7TDXdlOBPCyQBOSvKX1vtvtqxXDrODD7nsd3H0normK0PmhQE0o/k1npZLT57iPAsd93sowVnnS6eAWGu1vFbhGZ4DCTI48ooAy0SrmdjUA3iNQ9a99Ry4zST4CLk5efFFZlOSsiVu7pC40cXS4WBCg7PlmU90bL2/fSUtliSnWVKeSbzVt26t90RrnuSd65F6Gr6e9+PHLVK7CYATah8UInRkT7scQmUvwFYuEnla3LLQRjvzo9XiBE8nT9XLlSPbbMt/SKmGSJSxBPebDcfn0O6IVC5BdlPJ4ApKfC3YVmbYxDv+0J+89sGlfx9jC6RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGQpHmrX+Ql0gSf/Koep+fCjnux36oPaj5d9D5MSh8Y=;
 b=SdGSAXwmxMYg/Nad6tATluSi5y2hOrRtDzbr8vJV+2+YKI/OCTitU+kNvGeNtTmnAsVx89igCWMPx6e4c591bjpIck5WEQf8NtbFJUJoVUXrIelwO8Dt+/E5PUV5WjUY7ndsuNFEj3+MARkVx3hIStI5GIQ8Qh4Qol3cVZi7ti+/jtnIRk6YLV2eU6rqt+Q6Y2+YrmcvOtH3wFWYLCWs83RXMpjG8mLlmPXrGIuzZ7J9TPhWnGvZi7kDAeV0aAiPsSsrdAaBvlSyvmzemb/zvpQKf5FxcvtFdvux6dTaXdYyLk5uv4ElCqWbCDMb65P3bYUr8ehfHgpd7SDfyNFE0g==
Received: from PH0PR07CA0079.namprd07.prod.outlook.com (2603:10b6:510:f::24)
 by PH8PR12MB6793.namprd12.prod.outlook.com (2603:10b6:510:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 18:30:43 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:510:f:cafe::eb) by PH0PR07CA0079.outlook.office365.com
 (2603:10b6:510:f::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.18 via Frontend Transport; Tue,
 25 Nov 2025 18:30:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 18:30:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 10:30:15 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 10:30:15 -0800
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 25 Nov 2025 10:30:12 -0800
Date: Tue, 25 Nov 2025 10:30:10 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>, <helgaas@kernel.org>
CC: <afael@kernel.org>, <bhelgaas@google.com>, <alex@shazbot.org>,
	<jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>,
	<lenb@kernel.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<etzhao1900@gmail.com>
Subject: Re: [PATCH v7 0/5] Disable ATS via iommu during PCI resets
Message-ID: <aSX1srhPwWC0HXNw@Asurada-Nvidia>
References: <cover.1763775108.git.nicolinc@nvidia.com>
 <iovdqkgm7std6tpbfoolpkzksbc4hy3egfqgf6wbqmga2jlo7q@uolshjbvs3sm>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <iovdqkgm7std6tpbfoolpkzksbc4hy3egfqgf6wbqmga2jlo7q@uolshjbvs3sm>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|PH8PR12MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: f410706c-8155-44d2-68bb-08de2c50be36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?wsrJ3lV4QXaRJ93BSV17eFEVDwudhOFDufBgnRWk5rcVXvb3p7sItAVrjS?=
 =?iso-8859-1?Q?8cC28Mp16JdhVCC0GQUDHTNAX1qA5OgKFblKp9fJU2xubNuewi2cIQdVmp?=
 =?iso-8859-1?Q?NMziAHdxUGjna3L7BBXDLg/qOJmyVAlYnuIUsdNpF13VfenOXyDv0QgW28?=
 =?iso-8859-1?Q?CHmTdu1H1nLbaxXaTvzRF6bB5vDLD/KgdQk+HAJuRZzcQU1ObQXUDuUYx/?=
 =?iso-8859-1?Q?A2qIZJOPeYyBkwarcRkz0MnXLxWwQqiDUeVn/c12XVTsL//zCLkMeD5Ulo?=
 =?iso-8859-1?Q?aw/GYxuV458sG31Y8fcl8D88auQ+d3+kBRoJKQ8p3kpirBH9jngdtXpbQu?=
 =?iso-8859-1?Q?0vQhwu5hdpld22LdCRqEkKwiocFiBTG8I+GvcPBqe6ZtCmJYWccpRRpkM1?=
 =?iso-8859-1?Q?cP3l40aExdEZ33DjDD2crq5YQEacnVH+H1fBMEweSX8Pbs+/+sAq5o5qBN?=
 =?iso-8859-1?Q?yUDBqD//AherkYsL/aIFCiR02dMe/Uo7lUlJ7LGuwEobNyRBzagiEZYr6h?=
 =?iso-8859-1?Q?rr/sizV+brnmkNUZxs4H15JxkZJBAxRwEc3wGyXp+lR6ICqBxyKdmp89jK?=
 =?iso-8859-1?Q?2ttvwHZX3ELuvbSt2mni4ILi9HfS0YaSnI1ossARGIrrBpc4DJygi0Xknl?=
 =?iso-8859-1?Q?AeuVGCv9ZIdrRjrEHS5eBB/dAhrLkKTR6pV7qWlEhyoU5H5ovOpwnij1Fd?=
 =?iso-8859-1?Q?VHoB3iSqB8FEvNRmDi3BvVwCwdKcpKUMtNGY26Q4xbuhP0urwI6kLG1JPu?=
 =?iso-8859-1?Q?idrRBry7yuRwrYkl8lj3beT9IpQTZ0xWBqfwN8RGv1zK2gj40Z/4hD4iMF?=
 =?iso-8859-1?Q?GhmmfGdsTRaSUWXCUxfk2qBe8iZyrWr8gh5JtJNpTUu9wCnEbUndq3YI56?=
 =?iso-8859-1?Q?9rzLnKUUNx5U2ypY/q8XHzYOIdYF4IiAkIqMoRm1uQk19gtfjBksbVpmBW?=
 =?iso-8859-1?Q?Rc7UR5b38AUZEFP8Soc470eTJv0OJdTmV6s4Rveci7QL0cdyyNU16YyyTD?=
 =?iso-8859-1?Q?Q0pGbvKbQP6FrO58snIxhtdLpZK40c5zMsRamdcmFbYWsn8eW16ZJ4QS3Q?=
 =?iso-8859-1?Q?wL/gfb6KvqCewzQWhpT6TaI7HIlPdlTz7PrCKKVt6mA2Oc/+yvb7kPO0gt?=
 =?iso-8859-1?Q?bl4PXOwUDPF/iaMuJ/pygEgpsI62MOQfnCLJxgsO0oNREjmQAjsq3qC0/3?=
 =?iso-8859-1?Q?ceZcYpPm5WL5Io6gCD1PtyTYDaQ2zznVgO6raQs2spb2yEY9r5YT0HF099?=
 =?iso-8859-1?Q?jY8yvQLEwELt+SkT6TLX7Js4DiWEu++5uJY7So5tDRY+DnQlzzcpLGaOWv?=
 =?iso-8859-1?Q?45ZrIbvnWm2ZnFev/HVKEKW626z+lvBWHYr/vb0ogeGzuVAV3CRpP2YMxD?=
 =?iso-8859-1?Q?PmZu5BkW4h/CTRfGwKPU3hn6n2S0h8NG6pqADuVAnD5LaER0Wb3pjRT2Lr?=
 =?iso-8859-1?Q?VSHxqj+JmRbwNR6/PCNtbjEKgoERqrBdqdo0nSwe8wK0HgLNwUquQgm7mZ?=
 =?iso-8859-1?Q?M7/+sxkBrhhiFQ45IZCdYsdG/fbYXG9JS4EEwNgFI9Mftu8QYuM1vil5CN?=
 =?iso-8859-1?Q?A7hmU5I7eiSS+AbsnIOX56cLPI7QAFLk96K8X/1y9rpbnOUx0fPYAg8iWs?=
 =?iso-8859-1?Q?vUL4DIRkbHlK0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 18:30:43.2483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f410706c-8155-44d2-68bb-08de2c50be36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6793

On Tue, Nov 25, 2025 at 03:22:03PM +0100, Jörg Rödel wrote:
> On Fri, Nov 21, 2025 at 05:57:27PM -0800, Nicolin Chen wrote:
> > Nicolin Chen (5):
> >   iommu: Lock group->mutex in iommu_deferred_attach()
> >   iommu: Tidy domain for iommu_setup_dma_ops()
> >   iommu: Add iommu_driver_get_domain_for_dev() helper
> >   iommu: Introduce pci_dev_reset_iommu_prepare/done()
> >   PCI: Suspend iommu function prior to resetting a device
> > 
> >  drivers/iommu/dma-iommu.h                   |   5 +-
> >  include/linux/iommu.h                       |  14 ++
> >  include/uapi/linux/vfio.h                   |   4 +
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   5 +-
> >  drivers/iommu/dma-iommu.c                   |   4 +-
> >  drivers/iommu/iommu.c                       | 220 +++++++++++++++++++-
> >  drivers/pci/pci-acpi.c                      |  13 +-
> >  drivers/pci/pci.c                           |  65 +++++-
> >  drivers/pci/quirks.c                        |  19 +-
> >  9 files changed, 326 insertions(+), 23 deletions(-)
> 
> Looks good from an IOMMU perspective, but needs Ack from PCI side.

Thanks, Joerg.

@Bjorn,

I have addressed your remarks from v5. Would you mind giving a
second look so that we might be able to make it to this cycle?

Thank you!
Nicolin

