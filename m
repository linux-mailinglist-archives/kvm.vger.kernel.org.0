Return-Path: <kvm+bounces-25699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C279690D8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 03:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4007C1F2334E
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 01:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07CF1A3A8D;
	Tue,  3 Sep 2024 01:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oL+0omXO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498C21A4E66;
	Tue,  3 Sep 2024 01:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725326039; cv=fail; b=Wa4bdRkt/vPdNkUrU9T8O8QhoGzkQc2+Qd5wHD/WRhbWsOLoP0+dX6Q9hE8Wd5Ixbt9BKPLTe8L5ws8udw/uAG6bMjMvo6UTE/cSfXhWEVXJcOGRAk/iRHwUNKApiEGleZtIHYfyk9853LEi7h42mev5CZek/rVwfjaM1XoWIYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725326039; c=relaxed/simple;
	bh=NsBQMUNaG3+YfF6iy1N7QNMEymzP02wqTa/6eeB45G0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDLEkhyQhkEyztwCZ5jiIrQD2UiVmhcVqsjQO+wst9sDT5b1jS024gup8GeQllXO8lNxQjDqlP5oW9E2uJkQTnNj9ZkJVajaUaRuSa12sEa392T6OfFi0mYsAfNxKqQQ6mTrb4pVHdOGcYKh/MffNBbGItBqAsuH2E+QUfIIMOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oL+0omXO; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMkI3uUkm7kR1xkoyG6AV5BqCpuluGMuHAYGfIfFuER0E/72jt/kmEnjQRsdpS2hrFmFtDllCnkHcKHfPwPBSEFR5JKiu7LwI1jGtH3UVazDOc/h06v8wd26N0GZkugNHJkYsYppIKPgOr9fcRM2mzg2M0PPhcsdTOAokakkDONsFgVByht3VCjnVnKzf5oQ50GX0My9RGoHAAX1TaOogR+sI0KT1QU+eqllcQra2c+e5ND91qiLOxmQvWvLEJIvT4L/ib974cTiA3jZt8Wp3K/CQCdzy1CxjrxGPXeST6xz119VAYkfY7i9jlrZbti4x6ieUU22cYLNEHHyOSThqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8O+dEmt+sqffDFr5cTuHRjZVpQ/jW08oCUitTTh08OY=;
 b=Xw7rYsXVysieDGikawBE5t7pjy24aPegsTLcvC2rPK0ZWs34oJAT6LAAdv3dKrfkjcI6XqvuTG6o4dOQSMOTpuh7frM1xdGMg5RYHosPr7+JpTAfHuq+Y8W7HJh90JDIBIn4UX9cz6nSGHenPzNGgR6fU3w3Faa9lo5wDjNICB5JTup2nG9G8Hdlwmm2jEe802QlB2udKw80z1AxPeDYm2pezphljRnT8GpUWA2VvHABvwRsydc07HaNMTxKJlSmyxpQfxisZ57guF1WY4G9w9mJjUTQ7A5g60+0DqCz4YNRrtnwb/F6CnmniOGDQJ7hG4dI+tApKoOtVQh3MrYIFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8O+dEmt+sqffDFr5cTuHRjZVpQ/jW08oCUitTTh08OY=;
 b=oL+0omXOJmKogM6v8uZFah0f8BZL+CsVlFQEqaJvyfkgLfxBJEGc1U/CZvV0rsyo10Ta7qe0xNxGl8DcNvGAcprCvsrlvKTMr2vJGwVviicbMH6EFCpVvD/5migjO1JjtLkNupVqFJRabaYIDXLxQMkFNi1ERhnorjwXphUVSDKQrvcfoaf1HAvTvbfRFVBMy/BoYG6Mjm5J1QWohFxPHB4HWdzSOzP0i/pZGWLZV1Djk4h/srBhwIsB2pINE8IKnr4Hs1rvX4ppFAxRzAEfj2Qd7tfaUONcWibST+ATmsXPoEubZUGPrd52qu5JVXM81HTI7Atw9kClgyR/eJUfqA==
Received: from SJ0PR13CA0181.namprd13.prod.outlook.com (2603:10b6:a03:2c3::6)
 by IA0PR12MB8423.namprd12.prod.outlook.com (2603:10b6:208:3dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 01:13:53 +0000
Received: from MWH0EPF000989E5.namprd02.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::8d) by SJ0PR13CA0181.outlook.office365.com
 (2603:10b6:a03:2c3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.12 via Frontend
 Transport; Tue, 3 Sep 2024 01:13:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E5.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 01:13:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 2 Sep 2024
 18:13:51 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 2 Sep 2024
 18:13:51 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 2 Sep 2024 18:13:50 -0700
Date: Mon, 2 Sep 2024 18:13:49 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Mostafa Saleh <smostafa@google.com>, <acpica-devel@lists.linux.dev>,
	Hanjun Guo <guohanjun@huawei.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <ZtZizdUbSylPCZAy@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <ZtWMGQAdR6sjBmer@google.com>
 <20240903003022.GF3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240903003022.GF3773488@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E5:EE_|IA0PR12MB8423:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dfaa07d-fc3e-44e8-a717-08dccbb5ac7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6k861STF/xgrhzM0NrAAyGMY0kV/IeT70g3VRfBjD6W73xnDvokW4gdkOvqn?=
 =?us-ascii?Q?9Mtuvti+XsuSG3FafixQN6Yv53lgX4u+3IbtNmQfKAO1gy935f1j/ZxoXZvR?=
 =?us-ascii?Q?mIwzAzxp42sGnzxDqiDIgwLj0jNKeFAkBzYH1vTu7kA5tNrvBCeqbS8yZtl6?=
 =?us-ascii?Q?wdmskc3sJyE08NEnkRjFQvwRI6W3BqAUuVjU2sOdybKAb9Rcv4Wzli3Ii0tp?=
 =?us-ascii?Q?ztD6MY60UrzwPbrsTBlAvLvPPibaUHL0SnoPZ78slL4tRK32QEjbBEQlJDZw?=
 =?us-ascii?Q?4qpv/94mSo757ZMzzB1g1OU21fHqIaUP39o5UcX1tuOWS942xfDdC9gadd7K?=
 =?us-ascii?Q?zw7CvQ3Kq3d5uhmmlH29ZDqWM85AqK7c0IFuY8J+23Bc8YwmJAa752lEYOW+?=
 =?us-ascii?Q?Y8sbO0SUc9rerMui4Yk31wKtTMRQZaAVvh7uN8DQ9m46FhLTDhViHmy8rdrW?=
 =?us-ascii?Q?8C7LUka1gIP01B9TF084F9GKPXfYfEGYLnyU3N9Zc8H4btBLyeeT8VNsiyMz?=
 =?us-ascii?Q?ADVaN6gsUafRphZm8X4UUtOlqyRrXSf88UJdU/8OuW1OOTSJhnJe0J/L/mC/?=
 =?us-ascii?Q?zMuPKTFRot5SOdTcJ1omPIPHltcxyM86BBwQJ+pY27Eo5wrA+OmFiWpI6ols?=
 =?us-ascii?Q?q+iyQ+EetUSM99PNwwFgvDxVh0/H1/31rqI/E82QkmBtfbMehoNu7XIxDTxW?=
 =?us-ascii?Q?tIM39RwAOqycvD3oeF0OtwVOQHtkHd4vxbvPDzmDsb5dwZpcYJfdMgTu4D2g?=
 =?us-ascii?Q?Y42tihC22WEyMZZD6pIPQgVw2XUQs3uDn3D0XkptyTEGGuHgNlaEy/C1JQea?=
 =?us-ascii?Q?/R0qqOpHseVgSl8OcyLaGjKT2475/JB0J2tTLCdzhcr7HeQ+zGILbLd4R9qe?=
 =?us-ascii?Q?7jni4aQx0LBN5WkDygIou6CioyFIN1CijZnB4jGIy3EiIVMZKd/f1GeGAK/C?=
 =?us-ascii?Q?gO2yWJQhCtkw2gENdibFMi4dEiJjXByXQXAF88Bs0ifby6bzvjTpRlJIEu75?=
 =?us-ascii?Q?sQB2L/qTPREKKPR0cfB9bGUixBHlwi9O047/IKsbUtJvQtmsUHt4tL04nx+a?=
 =?us-ascii?Q?T3v5lGXUB8cGtxWGx+qBY/lrQg9LCWgeguR/EH6iMADslzrTGXkKBcnp1a2x?=
 =?us-ascii?Q?aKWgE87dgL9EvQzbkPMOZhNqLqrkKhmGyq/4oWLLJXI5B+3n8cgc/si+mkGP?=
 =?us-ascii?Q?VPJiZoUCPlOHS2ySrJGSIb/HWBbb2CWhrwYcGUxMrh7q9MTe/NOUonJbfQJS?=
 =?us-ascii?Q?3Tq9bVAFMS6hNUPk+sQuEPXMX65P7slagWAVgtGlFSyMxfZSCXq/LBTd6eX+?=
 =?us-ascii?Q?0Fnqcb77tiOy9aPFnhajC62k7mYP/l/UA1M/JiLwrMvG3XohRvlRyQ7Fnava?=
 =?us-ascii?Q?8t+mIXi/fYqlTOaRY99nKl/JqxOFYzintjEcEs/ynXtGAdGBTloisDYMHUkM?=
 =?us-ascii?Q?eiNEorY1XdGrlRSEfdCA4iZ5Bb+xIaPx?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 01:13:52.2068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfaa07d-fc3e-44e8-a717-08dccbb5ac7a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8423

On Mon, Sep 02, 2024 at 09:30:22PM -0300, Jason Gunthorpe wrote:

> > I see you are talking in LPC about IOMMUFD:
> > https://lore.kernel.org/linux-iommu/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/T/#m2dbb08f3bf8506a492bc7dda2de662e42371e683
> > 
> > Do you have any plans to talk about this also?
> 
> Nothing specific, this is LPC so if people in the room would like to
> use the session for that then we can talk about it. Last year the room
> wanted to talk about PASID mostly.
> 
> I haven't heard if someone is going to KVM forum to talk about
> vSMMUv3? Eric? Nicolin do you know?

I am not attending for seemingly in-person option only, nor sure
if there's a topic: it doesn't seem to have an official schedule
yet..

That being said, I think we do need a thread at least, for vSMMU
in the QEMU. The multi-vSMMU design requires to change the vSMMU
module to a pluggable one via QEMU command line, while the PCI-
vSMMU topology should be implemented in libvirt, either of which
needs some effort, where I haven't got bandwidth to spare. Given
that kernel patches are in a solid shape, I think I could start
to borrow some help. I'll draft an email to the qemu-devel list.
Folks joining the forum might be able to carry out a discussion.

Thanks
Nicolin

