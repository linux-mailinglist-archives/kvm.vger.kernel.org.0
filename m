Return-Path: <kvm+bounces-23799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E04E94D7F2
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 22:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0B5EB221E9
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CEF167DA8;
	Fri,  9 Aug 2024 20:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NVITl1aS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2077.outbound.protection.outlook.com [40.107.101.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794C415A851;
	Fri,  9 Aug 2024 20:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723234495; cv=fail; b=LMbJoplsdKBLfU0juLYpQ0clS/azO/Y07MfrhMOXqqh5zOkEr5sqksNa6OOqtFQYb7NL5kUMXsOa7IuBcZ3rVK3NaN2VqPMyPHTNy9V4XMavWGEW1ZV+c8nie/OU/I1V6y7JHfFnX06zNDsA3WNWljD+qribpW0cvYMUuUQAThQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723234495; c=relaxed/simple;
	bh=+EtOjZx+iNw1wEiG5/+jdfzj11ubcSWyx5d6wPyiPWY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obyRZdfO2D4bs6DvrrO5d3j7+bivhmPmMn3JuuINv3coWZyaIHsySyZUGiSdDXhdFc9yfuz+kSNeYEFk3TgEx5EvE0Ep5jJSMD5ypOdt5rIoP8LD0UOBhhUc76x7RpB4thrGuC/tg5ssOYd4TXO8vtuuIQEGA+3MxGgidUWoy44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NVITl1aS; arc=fail smtp.client-ip=40.107.101.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kEFOD+PkCI2j53oWKgsZs3ND0TChs9p4dF2lc83M3FXp6QSCFTfdLOCA/reWJvkJ3z7O5OqEmjrTZFO4WU5bP8c4pC607TP6AY4TkDkO1EgiFqZAfECTMbCbEKC1qgmPvJOheH+Kfg4ESgP6nzIXSgy4S3uUrCpKc3Tt9bTdZMuQ6YhHyaTS3qQ+v/kiqvwjQpFwANmucfndFsM32P07iNTUZGfi3hFEh7VAmm5h+QJUOPBR6wLUJLzDY/ecr4EkPVR3ZEo1KLN3kUv8fcoWg+/LmDTzgcCCcG08aWtzBTizLBUCvVHUXsVIHzlL8gL3uJ4gOTJ4NqHO5vzqITM4OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8KGlPvXrgSxlA/WN1EjxKDlUDoAIdRYQf4wo94IYx8=;
 b=X/0DONxB0waJ2VxisWepQ83Gh7ovF1YTsCFn3+3bbZYJuLLOqYDnwbDUJb4tQ+ZxNmg32gFoxvxk8U4Zb4WkzN58SdWsbSqrdSwVT9cmNm5biaLkJLcOfTgT6wz1tgQtzSVQ660h9zFd00EKFTaAh5kK8p8uBgX8qwjVBwrEcaleaFWW3VDk9ilYWpHNeTTwBb+rkCGlUNdtGeAvv1Lu4U8yKuFxVg0fNhLPG7q8C6CnsFrMpPwGrlraWv2xOgopDhtYuvYbUWB9OMlvtHXz9N83tSzZ4HMtVOqIoQLxNmt0T/EgLfPn/MHDSD7q0voabLPYA/hBmTwa1lbnW9cG4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8KGlPvXrgSxlA/WN1EjxKDlUDoAIdRYQf4wo94IYx8=;
 b=NVITl1aSNooUVElMHQvWi8d+yfLXXAsqy/6GyT+cCMXC9RyInPI8tqUlz25G7puhhLW8w4hK4A0FSzqNYoGFdllLLh5jZtqo5NWHGiENAROoAC/2UtGYZDriQH6afXhLnGVul1j/ug/eN/58Actp788M1Is3Db/eU0mbGK3mAowXCoSDKBasMoK840uuOBOUqzZFdLsKkmOjYr6kXh8FcP7J3npAL3pFQaSdTF6dMKAA6vSOuwrqX+QROp59EHofbdC27Dv5AOHH2dMkYAnNehLFfO2TMT5/xDiOctxb0dWht49Q2gG9dmt5UERa7V+IGG4iOqQ8KXXDSXP0YV4Y2w==
Received: from BL0PR02CA0127.namprd02.prod.outlook.com (2603:10b6:208:35::32)
 by CY5PR12MB6274.namprd12.prod.outlook.com (2603:10b6:930:21::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.17; Fri, 9 Aug
 2024 20:14:50 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:35:cafe::c4) by BL0PR02CA0127.outlook.office365.com
 (2603:10b6:208:35::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15 via Frontend
 Transport; Fri, 9 Aug 2024 20:14:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 9 Aug 2024 20:14:49 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 9 Aug 2024
 13:14:32 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 9 Aug 2024
 13:14:32 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 9 Aug 2024 13:14:30 -0700
Date: Fri, 9 Aug 2024 13:14:29 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Alex Williamson <alex.williamson@redhat.com>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Len
 Brown" <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Message-ID: <ZrZ4pR8vfwxezx1E@Asurada-Nvidia>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <3-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <c2dc5966ab794825a69e2ae2b2905632@huawei.com>
 <20240809145922.GH8378@nvidia.com>
 <8ccabbffaae042a9b9c727272fd352e6@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8ccabbffaae042a9b9c727272fd352e6@huawei.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|CY5PR12MB6274:EE_
X-MS-Office365-Filtering-Correlation-Id: 6883b5d1-6de9-4278-1cbd-08dcb8afec25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3e/VUJUsEfjxpIQR8eKgtHE5CV5QWnPw1FVMXTOdRk+qJuxalMOcgBuGcp5F?=
 =?us-ascii?Q?y9YAiqiAVaD0oIYKI9XIImaskUfoCQnbTkoJvNk0y0q5p/dRq+auSzaTKyft?=
 =?us-ascii?Q?arANZ3fjznTdMmgT0dflCARdqOqk161vs21/MHsHT59rq7CDnP+sV4qiF5Ri?=
 =?us-ascii?Q?X6+VHyhTNYd/aaGLQx6Orp2L0AQsvLaCs7hWLhwky1k4u4FZmz1hbwj+YK83?=
 =?us-ascii?Q?xL5xYGJQAQkl2nanDSF/PWdcq6RRT4VTqJEiFxCxddCnUfLPHxZwIpHSRvAY?=
 =?us-ascii?Q?6WlfvJy0qsgye/6KspPUUGFaU8UP1AEDjC4On31E6BMLJfasHs5o71Bydm4o?=
 =?us-ascii?Q?GW5+WYuddv9qzdG7sfPHo2dw43BHVC0EElnPUMtW2BW7lcVs12BNlfUnBUly?=
 =?us-ascii?Q?phDNZrRcvg4/s6M02YKOt7Avy+Nk/6HdR2y2AO96GLC6qhY3IA7md2eY6GJp?=
 =?us-ascii?Q?2B3eYZhe8gyClIdznzp9nYEUSIcgOzweJAqv+tsjdc1PeXOgmRC5g1A+8v2G?=
 =?us-ascii?Q?G8DiXXexdDWNWP13m5pLwt9fS5z/sN+zuZKjLJqSgrip2AMJWfFQlJkf2CeT?=
 =?us-ascii?Q?WkzsWoUJTCSH8TpVoo7BSqk5oSEcI473aPPXJzA0/qU994j6cMZrvp94ugMj?=
 =?us-ascii?Q?QhV0vilQ6IgkUVn343s+MinoDuDMOb2Bx37Q5ZWtLCBu1HJMG/e3QGk2CWfP?=
 =?us-ascii?Q?URG6Kz/AMONiPUkCGyX/NF0Xd70joDH2sz2lnPFCzdtLz6pK+h+xQ3lejEeI?=
 =?us-ascii?Q?QuiUcqVUML1Ta77QJcV+SX0KYtDtw7ecbGrsCQjuUJH4pi870khKDj6kD10B?=
 =?us-ascii?Q?W57gBgVF2W1aHPwjcl6YJ/LnnXH4yda8zsf8LZtCQPrWQMXya83U/W32BCSF?=
 =?us-ascii?Q?QMQiKIoLh1rjxAj5KtSqwnJ9X6nPBSlmSu48/EFIPe6fzRF/5i0OAXJcQgQx?=
 =?us-ascii?Q?vN0aoJJqIiyyI+aK2snGB4d6hd5CVCMsDN44bVb7cixGo0UBYI8ikBZkAGRh?=
 =?us-ascii?Q?3tCPBaIiL5v7/DsIl6rUwZanBuO0WxYemHJzJgCl7Qd6xnwWzQeOnD4iBxIm?=
 =?us-ascii?Q?c69Jepzoze47f3n8KND7v3mWQaPvf2nXLtYzLLcG4IMiei1Yyt3htpzZ2Rc7?=
 =?us-ascii?Q?7x+uocny8En1s85jDA3F/F84584+CzvIi8G4z0CQU1Tije7bfBDan6JCwIYc?=
 =?us-ascii?Q?4UgL599LSqo/e+UU/7ExUqxIW4OcyelmzHngyZVNs0r3/j+dL/SNxudnzRco?=
 =?us-ascii?Q?nuqh1TcYLN6ykqVPyA1nxvP2IyE/Qg1CLucGOYoCWCzIW/lYktLucenHJiAS?=
 =?us-ascii?Q?eBbX1UtzHTGZfd9PZxDU6c4JngeHfa3jgyrjANaujUmKuOGpk7/Lloc1c6Za?=
 =?us-ascii?Q?1RaLkoq4NenH1Au8CCsvK19xkmmUnVKY1RbpK2B7MppoKj5HJ9113QSnDqOi?=
 =?us-ascii?Q?iT6Ni+N4zqgXMih6/C9ohyyOLjCdsHJ+?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 20:14:49.8535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6883b5d1-6de9-4278-1cbd-08dcb8afec25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6274

On Fri, Aug 09, 2024 at 03:15:20PM +0000, Shameerali Kolothum Thodi wrote:
> > -----Original Message-----
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > On Fri, Aug 09, 2024 at 02:36:31PM +0000, Shameerali Kolothum Thodi wrote:
> > > > @@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
> > > >
> > > >  #define ACPI_IORT_MF_COHERENCY          (1)
> > > >  #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
> > > > +#define ACPI_IORT_MF_CANWBS             (1<<2)
> > >
> > > I think we need to update Document number to E.f in IORT section in
> > > this file. Also isn't it this file normally gets updated through ACPICA pull ?
> >
> > I don't know anything about the ACPI process..
> >
> > Can someone say for sure what to do here?
> 
> From past experience, it is normally sending a PULL request to here,
> https://github.com/acpica/acpica/pulls
> 
> And I think it then gets merged by Robert Moore and then send to LKML.

Shameer, thanks for the info!

I created a pull request: https://github.com/acpica/acpica/pull/962

By looking at one of the merged pulls, it seems this is going to
take a while. So, I think we might want to split all the CANWBS
pieces out of this series, into a followup series.

Thanks!
Nicolin

