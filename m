Return-Path: <kvm+bounces-25550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B6F966775
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 18:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20217B22CEF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC061B86F0;
	Fri, 30 Aug 2024 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aVsp92c+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171C414B949;
	Fri, 30 Aug 2024 16:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725037175; cv=fail; b=XZ91QgqEtHDztWZAmXnd6ShnOa4zRLmKbYNKrEwvRrwZ/C/BOdsfWqAHmwsJO76hI4vC2ocM617WFg9TthlhpG1DGCPbGNbzPJbaj6Qdd5C6KN0laHzwHmMAp3te2jltgDl1RFclTT921G/vrg1NErfegYT7X1aIgjz7bw4CCjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725037175; c=relaxed/simple;
	bh=NAUQlToSYIZa+1HC9C8PmTikQ+00dTN+K8x2Xb6RILk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PfhVwvh6nwiTM7IYsaeSSfJDATK8EAMIDDqO4K+gB++d6taLVbNv5JYaLMVNKbb1PR+tIK7Cv4AC1IMgewPQ+QVMMPUPngHKldRZQ0ypk036gYSSAvBdgGeZrCNDGiOD2uhKdl6hpN6KVkokjxvt/KOPOZnECNZqSC3f9iAT78M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aVsp92c+; arc=fail smtp.client-ip=40.107.243.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e1pzcaLekLYxuKywIZwxkLVhU7fFG28FcIyxrDgnMu1QItiNrC2DZCRZIFviA0dSi0RHBSyEuXkf4s8zceQMvx9Qe2YLgho7FsImN+HmYADo6iJGGALez4R5Ey+oRDOgEJisivFt6qUftpER+2jTCBKlklCqOhozjzsGS1ItDFXSToaQcHiSw888OPPBN/BNhD6WkVha393OhABEmC9tfFLOCYw3FZP3dSHlMzE/GuohLBUtwc8Tspbm9tWlVW4zVMSe4hbKR67O9wZe5WV9PdYkYxxpdcPcER7x3ntMrH6dOo1SNdjiWcLCMtabr3N2Tt3TUb6JVyyDdrgymjyWHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RENsyliQMBVhaPEPIYXZwpoQaf0SD4eb4IOhjdJVmj0=;
 b=FaGd7CQYk1Y7d79OZ6SzEu7qN3sEYo53f/ApgPyyXtEGaJ2GxzzDwarDwceRELSIJCw7f3RXe05TYJLSGOquMlmF1FKVcH8WXM9LVAbuvcEtsF2nXvm3CfO2kRCMw+jVsJn3HVKLg/vF6rzxpusf1BIfQNMWCFulVaRdedXwsbfPA+znm822VhNHY30JqBF9PH3fbNOGWeu8JqQbIs+pK4wy1eA/NSA2EHpBHPei9UQciBfR2HOJb2wF5FB1yfHiaVErZRODO4NNGlLLNpmTAQWwdy0vxwVE6+Hu0gV+pp7ZHN9KUh2dyg5+1zeFpGzNzlLN2Q5pWGePXjN88QiEvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RENsyliQMBVhaPEPIYXZwpoQaf0SD4eb4IOhjdJVmj0=;
 b=aVsp92c+W7ZSLkdpbuwSqy03C91TwpRL5XVdjC4KDwq06ZYguPEbP/HGwH+h0edG01XgMCvDLHpXRZ07tJuoS7DQSyy8E9XhDHSWh46QQl2HNMDj1bEBQoOMDUSwIXkyGu53ddfJR6O66ETgKNjFTdZoL1nJbGDHZPyHS9Epzf4g+biK6OSmJLFxKZUtOKdagUNukKKT820uFWhhwyqSy1yLRd/EN6QCj5sbrt9hEfYlViBhMu0Pvoymcwc2LpG9E/3w785+vNAHGwFTXIZW2ieu6AjssSM58JS03LS0sTpkshjz8ZDA1qDKojmFJL0npEQdoICKLpg+lkp5SxHEIQ==
Received: from SJ0PR13CA0190.namprd13.prod.outlook.com (2603:10b6:a03:2c3::15)
 by LV8PR12MB9417.namprd12.prod.outlook.com (2603:10b6:408:204::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Fri, 30 Aug
 2024 16:59:28 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::17) by SJ0PR13CA0190.outlook.office365.com
 (2603:10b6:a03:2c3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.21 via Frontend
 Transport; Fri, 30 Aug 2024 16:59:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 16:59:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 09:59:11 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 09:59:10 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 30 Aug 2024 09:59:08 -0700
Date: Fri, 30 Aug 2024 09:59:07 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, <acpica-devel@lists.linux.dev>, "Hanjun
 Guo" <guohanjun@huawei.com>, <iommu@lists.linux.dev>, Joerg Roedel
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
Message-ID: <ZtH6W827wAXmN+Gn@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZtHuoDWbe54H1nhZ@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|LV8PR12MB9417:EE_
X-MS-Office365-Filtering-Correlation-Id: 9266d592-0308-4172-84db-08dcc9151c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ja57kSFCi2t5STLnIyqNL8l748yY7pX8hfqaHdH6HCNz5qTkbPrVTpG0GtKH?=
 =?us-ascii?Q?a54ffgBoMZIEcrgF5Eo5A++1rMRvCprvBOK2fqK+qOJ5JkzSLPBNeZCVeFmD?=
 =?us-ascii?Q?HW6vY6mJ75sTnWLqrGhmzIm4sxUgV8gH/yxdpR7C5qjkoIqZnoIKY2Fn0uDD?=
 =?us-ascii?Q?SmWnMwUPlpXy2xyTWdQ6yl8U74puxqtTnmo2TCr/UGZg5mybHmH2APFWOP86?=
 =?us-ascii?Q?TlFeYMmugiyfb2hcBqrjMn66Nj1RudAxPJxX6Q357+ZNcWqP9VCropmSrPeK?=
 =?us-ascii?Q?TGdkybF5Jbgjvu42AM4l4RLh9Dzps9SMC6N/BfwNgr0zCuM6H6E02Rbk7ND7?=
 =?us-ascii?Q?BBwZm/Obux1dnL7/VYy7hxFTPHWSVyUYGFxzGJ38G2BY4HUjulGwwszA7ahr?=
 =?us-ascii?Q?SjxdcGt1ufK1ftcQKXlzt/Kv0TIP4Sdn2ECeXRtInFlSwEw/yuIb34SH1+OC?=
 =?us-ascii?Q?jgE7zJtwLjcKfohHy/hdIMlDVN9SsSgMuWWrZIoTQdzhgAjFarH4wblUcDXc?=
 =?us-ascii?Q?O0Baou7bMuOYd1KmUqIomLxwEV1COwIszY/wf4mDwstT6rOQuARN5s0Gz114?=
 =?us-ascii?Q?T1qPVIe0Igt9ObsbOVUok5O2coiZ7vJ03BpeoYqtNx5d05zOfUi6hv+wtO9j?=
 =?us-ascii?Q?kaL80/1O3KgDB+qXSLhpNdPQc6LkHjRXn/OX2Tu1m91Lb68XLScVX6WxXNYT?=
 =?us-ascii?Q?5ejUYtn+1SPdMHmva8g2sgdIPhb/uXd2XMhA0PsKMUiVq/RzNt0EpUVWMMTJ?=
 =?us-ascii?Q?nZWVz3pY+eLhOtwySz3Ctfxa+3ZrCvfRSXwVfYDHISQSt9yb95EBgjmAZhSu?=
 =?us-ascii?Q?lPk+t/ZYi9WlTJhzyeuox/HhdThYUWOTdLNOZJRaVMVDEfg9iS9BvDw3RYGl?=
 =?us-ascii?Q?TEMYB8j/+j9V3LYiUPrTl7G8a2HMuS96oyf2+2W0jcatMJK9HKklfkTH7YOc?=
 =?us-ascii?Q?ZN1D7eiMOZGlZsPWVun5qN48K5hOdnhPHYx6GIIxKbFYclz3sbbwjFmn/cok?=
 =?us-ascii?Q?3qZ16RYlyO493utCV58ccOhY/0/0O8EG7TOVONVh0fAM8fx3pVGxWHboECSY?=
 =?us-ascii?Q?L1K5cVOVCMGY9lBEpTO0YYnqz6G62ZnEaOPzRlCY6oFODsNuRO2w4vTbhh9O?=
 =?us-ascii?Q?RRWDsBXkcK6DPKCgC4DJl/0uJOa7adYa6vJls0qCYeB+mc3J6r/RpDHcL1sM?=
 =?us-ascii?Q?5rqW/cTejGnI1bFIRmYKYyidmW6b3WsyXfe1UprTe0/V9BD7x9b0IvUriNRy?=
 =?us-ascii?Q?D4Iz8m5dT6NP8ZJunr2Fo4PVAUpJqyvBxkRoTIyVNcOTqNXH2jk1dVEYRp5+?=
 =?us-ascii?Q?/+AW8Pzn1TL8SJaRk4DeELhnj6llUFaugIutfscQj+f2Kbz4gWVoKxOoSm+G?=
 =?us-ascii?Q?JMiIKByL2XE9phqmR6Vt8oTdP+5NLAv9Z58Sm2PNly2BwBInkOo+0JKBofPn?=
 =?us-ascii?Q?LLi7TAUCJKG+hZdqbGM08HDUerirG/CQ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 16:59:28.0122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9266d592-0308-4172-84db-08dcc9151c00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9417

On Fri, Aug 30, 2024 at 04:09:04PM +0000, Mostafa Saleh wrote:
 
> On Tue, Aug 27, 2024 at 12:51:38PM -0300, Jason Gunthorpe wrote:
> > For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
> > as the parent and a user provided STE fragment that defines the CD table
> > and related data with addresses translated by the S2 iommu_domain.
> >
> > The kernel only permits userspace to control certain allowed bits of the
> > STE that are safe for user/guest control.
> >
> > IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> > translation, but there is no way of knowing which S1 entries refer to a
> > range of S2.
> >
> > For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> > flush all ASIDs from the VMID after flushing the S2 on any change to the
> > S2.
> >
> > Similarly we have to flush the entire ATC if the S2 is changed.
> >
> 
> I am still reviewing this patch, but just some quick questions.
> 
> 1) How does userspace do IOTLB maintenance for S1 in that case?

We do all the TLBI/ATC/CD invalidations via the VIOMMU uapi:
https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com/

In another word, nesting support requires the VIOMMU p1 series
at least.

> 2) Is there a reason the UAPI is designed this way?
> The way I imagined this, is that userspace will pass the pointer to the CD
> (+ format) not the STE (or part of it).
> Making user space messing with shareability and cacheability of S1 CD access
> feels odd. (Although CD configure page table access which is similar).

Given that STE.S1ContextPtr itself is an IPA/GPA, it feels to me
that the HW is designed in such a fashion of user space managing
the CD table and its entries?

CD cache will be flushed if CFGI_CD{_ALL} is trapped. This would
be the same if we pass CD info via the uAPI.

What's the concern for shareability?

Thanks
Nicolin

