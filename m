Return-Path: <kvm+bounces-23743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F2694D5F5
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF4F11F227F9
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D5A1CA94;
	Fri,  9 Aug 2024 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oXD9YIBd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7D523DE;
	Fri,  9 Aug 2024 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723226602; cv=fail; b=Xmi9pQxaLDGirmCtGr0JYbd47DYu9weCbC9jouWijEqxLQi3xKf+fvLSSCMJBVlMULxk0/Trcbo7la9H74MPwOSv8i9P/I1OAH2rm489+iGWIwreQNa+b54j2S1u/U0DYiAKH31EMKuXBBrMll7iLkeEYZG/sGcCSVKSgWbVTNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723226602; c=relaxed/simple;
	bh=BQABcOpJdiB6lr2JxuX9mcH7gnMOC4E6BdFeHL514Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sYRH5gVGEW4Z23hLltkAQMzBEOpTZnoPQ/C/gfp9enJ9nW7du+r860xPN82caAOhty+LtxNw4heuvqsTU8LlA9UZcNHtAV8oUxKtIGhmHPv8PaceFfVmIlvTMDFTIX3xB6sV6whNEVgrjhmSsvakFG8CDs7/nn6yCnjxPPHKO08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oXD9YIBd; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QnjMX/C5109VUPLZhI9iLgpyM7iQCTv/9QDV5B2mc+Cg5hFFSWBUsdH5mjFQlOb8hPLFpe86oyuDWANA5T1uWXwHy9Fs+PcHxPbDpZNjHPlSaP+UpnjNHliPqboolLiHKJFPH2gZYQydN9WLrw11qgBPPgTkVNrjdwFTv0+9zgt5zYEWX9Oat1tfEoiXTB83NFUFRczDl05w7sfppDITSvjWsPXp/SVQhrnE8xdiE9zkNCxBGuwvos7bTo1vmTgUg+HjRt8ZxyGJQSZJzDcnuScsPR7sH+zAcJnLU7sfemE0NukLGKgCzl+CiCypgsl2R+AD7feVo1JpQ4ilfU5DZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuiQPMlB+Dwf/qhC9VxlPCsKgu/tsCcohJeYPkxvFt0=;
 b=x5yhYLDScRoTO+kSxxchCrhbJQcCA4vWM6L+Aelwj2jkQwFCExe8Ihgicge9J4eK/8ARje6aCe6/Tb9TzguRC8rAXiKNh2/LnKspcQ1G47073qiryXqjDUC6UC6F1E61V8JXL0axTjedIPsOjFoA5PQNbrTF8w/W4zFnirWgPsQ2Ui9KyLT+mKehlX3t/d2T1M3Gg6MZLIb69K5vDAW2l9Fn/SvnJ4ywrUregkDy5/GB4qET59pOtPvX10LAYbxapxmMpz0Vzs7zoE7zlzugn/nDKta6C8C1YAZrsO3n7OaGl9BcBBUg9DZ4NO+D2tTF6PRBUxnxMryOh4ptfky1/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuiQPMlB+Dwf/qhC9VxlPCsKgu/tsCcohJeYPkxvFt0=;
 b=oXD9YIBdzsqrg++ml5dT+PlZYhJr4JZ9A5nzBtY20D2NLaO1nSS3yfkX2h4xSLJD2zzQorIH8hfqX7f9UIGkzDRseh40wdzc7bC4kq6yXFdvfYVxoGesELSoXvY+gmihUc+CZfFizC87hc+J0XO6QwOHGNVCz6JJ3QP3axV4TGU2n+rTXoJLOy/0LIt57V+c++4n1SRjV9jnNypLaa4owqpEkxQe7CUYxHkPahJGtYZZVfCTB7uO4WeL7O4HiA8zjnIYoPPGXgZfePu6eB5kPrO84btUEWDfFKo5rjhktaRLbEGYhUZAloHn96hN19Ju1Xk8+cA3u4rzFrqoUA4FKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by LV2PR12MB5800.namprd12.prod.outlook.com (2603:10b6:408:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Fri, 9 Aug
 2024 18:03:11 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 18:03:11 +0000
Date: Fri, 9 Aug 2024 15:03:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 7/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240809180308.GK8378@nvidia.com>
References: <7-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <506de4bc-8beb-4cd3-be2b-86de004d6129@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506de4bc-8beb-4cd3-be2b-86de004d6129@arm.com>
X-ClientProxiedBy: MN0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::11) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|LV2PR12MB5800:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c4567d9-ad91-40f2-3704-08dcb89d87f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G0itM+vqy37L39l3o1xh272KXO8/tIpHb8JM3PNuXJEULc+TEa4LajsKNr1g?=
 =?us-ascii?Q?PQ2BJIaYfE/qoF8X43/OxiAcscKX8hB6J1p03eoTpKG2BIEi0gx2BzPVudjX?=
 =?us-ascii?Q?KwGXi4W5tDPVyBzj25PEiVeXHU/HBA7iCN/qHwu2W6y83TDRMSmu1ONuuZtc?=
 =?us-ascii?Q?ElpJChCMe8lF7cD6756ugRkOvkpUVO01OhxfjJ6zZuzTC+gBcKQBzvonuQuB?=
 =?us-ascii?Q?OWWW/XH3cBZefVglf/4uHqeEO3tkGndUeSq0z0EUMI3Dr4sV4LA6xSO0iCjr?=
 =?us-ascii?Q?qYWzquN03VD/xoBBwLdBvrkCFTFPyYLv+CNkw7M9Ayb3NUlsYiVsp6C7ZGTA?=
 =?us-ascii?Q?rDEblE0GvlmjVVVnO1+DAhVFgGWoAbXqOOLsk8j9RJQ7PNkSWb3/eq52JY67?=
 =?us-ascii?Q?OYwmBBYG0ZT4SFdBpsiPNe6OO7nSrIOIobM9x5Uju6EhE6tfNRre6mLISl2e?=
 =?us-ascii?Q?ys4HZACoxigc+WnZZAW/IkYWVCOsphwmG44JoHVnrgYAZsE/++o2RHWiqk3T?=
 =?us-ascii?Q?5eE9e4OtnOBHKqm8//YC3ewRl3GLZiV3Q084I897ZNxlJ/HNwomK3id2KsxY?=
 =?us-ascii?Q?KrYQCDlZphoqwYjkks6+EbjG1oW/SiRzCSUyIcLc2jwafeUwSHTk44BYMEWh?=
 =?us-ascii?Q?L/ixeixzWW+Tje7qV2qpCxhUA/M5J45jJOv0C90/Sfbb/qzbc4+59WZQmgP9?=
 =?us-ascii?Q?DZ2wvX4n1ny3oXdf6Vulyj8fhUNVfX6r15USkUovOqZxb/xpu1KC3RL0LPm5?=
 =?us-ascii?Q?Tv+3HBRPTnnTBsATAeTW4ORxNsUvWmp9Ge5rPlQDXRE4eFwWzdUyLmLFbeTh?=
 =?us-ascii?Q?pxxgCEUI/MUPmjCwjDcHQOvj2qVj4v/BC0nHjZcrw9uzwqguywP/We+LCIsI?=
 =?us-ascii?Q?iQIMMP//m0nPj4wpQ4nwk+3vbUiOrxY3krCpEiwOPrnHR3D3Qp9HkO6ezPsd?=
 =?us-ascii?Q?NY88MIApSV1D/bZRr1T071EIyzgzVwjMlg77uMcK++OPVtKn64UcEJHYLASF?=
 =?us-ascii?Q?u0uDWungROssnjAfjJzbrfOA6tHJhPpkebv3Vnni7vp4cXdQKeHHeGKLqLnh?=
 =?us-ascii?Q?z1u1VCPLFz+dQrZIPk63KMFp8YQTrm3rinVy9TRoUwIsssLV7nair8Zhxxei?=
 =?us-ascii?Q?xDFIkVH+TyxeqO9+5BmeuA8jW4gsjSQyYo235KImgmf2oq9PXQToAoZxqXOM?=
 =?us-ascii?Q?+8fpY3LOWjtl9NHpZC1ls9S/nnlaqTDJ1Aqx95LUV9rfams6x3C+uDs/s35+?=
 =?us-ascii?Q?DM3YnBvCsTG2jj9LYQc4q0NtDqycQA3r9SJNE7doinvLVaAbtTXq9U0PblHK?=
 =?us-ascii?Q?K7SOVYiy6JoT1IRC/KoOWhOn0dcznupCaspcM4fwSa94JA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qvGJghG5n3ZF3YaDp68apn8QsRca8+SJOoRpHiHpcbuwTQl/muzTWORqPB70?=
 =?us-ascii?Q?KWHRoTa+ykJBpm3rTGkEXOlneWKfZhUg5EDlv0WoDHkmIHE99EKyvkH/hTXu?=
 =?us-ascii?Q?tv0HU0V8SAtv3/4CQW3LQ810Wsekwa5H0s6VolRIqD0dTFhvuzbCutOwb5RF?=
 =?us-ascii?Q?6OpTQDlXBzYF9ivWGmQ7L2VVmm1gt/WAoBJEz+SO8T7ALD/CXXOOq67wOfQz?=
 =?us-ascii?Q?0OQ3dz19s8oBP7jNnh8snUH/e4/zaw9aodtITuj+4nGsfgl/t05cG4GnKmPM?=
 =?us-ascii?Q?DEkpYGedgMzZQQa2ksb6es3rtH68VHWNeVII5tOZHBhmc45oOr47SwAW+T39?=
 =?us-ascii?Q?QXw/h+V/ffV+jU4viggP/cpCHEI7paQ9d9sjxqeGPh4XBbUdFCGEomqJSB4q?=
 =?us-ascii?Q?0O3wQJFQ3lYfhn7+WtB6ez6/CWDcchS02GQf1Sh0s9M9CyfJ/1ZEFN9ztzoP?=
 =?us-ascii?Q?pyWhU1FHs+TSq4fy8EjBJGFAE/B+QkD8D1m50wnAXQd2hOAoNxqzGr2PoEKn?=
 =?us-ascii?Q?cTEzlPKKNc2Wi/ndRMR4WW/Uy2KMJ1l9Cyyj9MCXaAZwgjIMcnPFFwhzM7JL?=
 =?us-ascii?Q?j0jV8bvzO+D7fU3BHtL974L691d8ULpKjaOhcuN4v9s3uMx41OXzHC9mrGir?=
 =?us-ascii?Q?4aADecZJP4dUi1bv9lChTCy0Gwyc7muAr4KeWn/EU56nEjZ/XDHME6hp+hnX?=
 =?us-ascii?Q?WkiqLrxJKw7wEBnjWt3aldMOVzbgW1OVt0WAog6n0ulb+N9s6cXbR5IGCFCI?=
 =?us-ascii?Q?ln+GFBH+bES2FkS35W8wj/LflNl7TEd43/ipO9fwQuRXngw4ocVsEcMXnyxc?=
 =?us-ascii?Q?8uBLBPIdGLbb4dy4BFSyYuVvsWlDSEymbHsr4JEhNNvbRx1jP/rCOrRKTp/i?=
 =?us-ascii?Q?QxfmxJpIMK20/4+wGeHNlu/dz/zMu0Yq/FgubrvgkL4YwvlihAeOPnklzdkU?=
 =?us-ascii?Q?Fdt9pOkkKHXoAfu7JMcoKkTXPro4CjX26LlFaS60L7ZK38HHldRIugHmjU0S?=
 =?us-ascii?Q?djZv21FpszGrNTzdfs0lEiO62t24764DcXtS0Pz8fS18GMMNyc69iITEdL0E?=
 =?us-ascii?Q?sITGDBSw9ZxR8EhIre4qKJBeOaAgCtDwN3HRZcm8D4sGiD4519dJ6Tcy8+x+?=
 =?us-ascii?Q?pbg6ahyZETPRFCXFJdej8VosYfIndpNzgNYm39k14qnYqwY16eIRJqXucbRr?=
 =?us-ascii?Q?s0cWB5CdmijsXpNG6ehLkP0VCmsxdddz3+4+Ig/uyHDp7n/3Fxz7IrrhxEMA?=
 =?us-ascii?Q?jSKBsnVoYpW9GeRz2oj/07FoY6U0cIitubALVM0fpCjTnLXXZUKNjDK4qsCP?=
 =?us-ascii?Q?dg/x4mCHwrem3Fk6AKtVqb/4ZvpDw4hLrZPJi5rs3JysWnfOFd9YKUUIU4vp?=
 =?us-ascii?Q?wE3A0gC4VzjYCT0iZqUAdZL8S65OMOnNWkC98BAfTCoXDb+Xb8USXCQilx3j?=
 =?us-ascii?Q?5kGqMJGyuDPB7QWUamnKU0ZreFuH1j4id4SHHtSzFImkpNyn415bUhobMjxB?=
 =?us-ascii?Q?p8Is3RtqaRrTP1rQQij2LbwmGNdpqay/UZOmVdcVVOAU36ftBTnaFqnbDeBR?=
 =?us-ascii?Q?YYgantWNzMXYKQYzkPQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4567d9-ad91-40f2-3704-08dcb89d87f9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 18:03:11.2043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzmP7necSjc7nXR2pxN54dcVX8qQe0tfl75Hl8fpBBLsFfDOzgnv13ZN5XW8sDK6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5800

On Fri, Aug 09, 2024 at 05:05:36PM +0100, Robin Murphy wrote:
> > +static void arm_smmu_make_nested_domain_ste(
> > +	struct arm_smmu_ste *target, struct arm_smmu_master *master,
> > +	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
> > +{
> > +	/*
> > +	 * Userspace can request a non-valid STE through the nesting interface.
> > +	 * We relay that into a non-valid physical STE with the intention that
> > +	 * C_BAD_STE for this SID can be delivered to userspace.
> 
> NAK, that is a horrible idea. If userspace really wants to emulate that it
> can install a disabled S1 context or move the device to an empty s2 domain,
> get translation faults signalled through the normal path, and synthesise
> C_BAD_STE for itself because it knows what it's done. 

The main point is that we need the VIOMMU to become linked to the SID
though a IOMMU_DOMAIN_NESTED attachment so we know how to route events
to userspace. Some of these options won't allow that.

> Otherwise, how do you propose we would actually tell whether a real
> C_BAD_STE is due to a driver

It is the same as every other SID based event, you lookup the SID, see
there is an IOMMU_DOMAIN_NESTED attached, extract the VIOMMU and route
the whole event to the VIOMMU's event queue.

For C_BAD_STE you'd want to also check that the STE is all zeros
before doing this to detect hypervisor driver bugs. It is not perfect,
but it is not wildly unworkable either.

> Yes, userspace can spam up the event queue with translation/permission etc.
> faults, but those are at least clearly attributable and an expected part of
> normal operation; giving it free reign to spam up the event queue with what
> are currently considered *host kernel errors*, with no handling or
> mitigation, is another thing entirely.

Let's use arm_smmu_make_abort_ste():

	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
		arm_smmu_make_abort_ste(target);
		return;
	}

We can look into how to transform that into a virtual C_BAD_STE as
part of the event infrastructure patches?

> > @@ -2192,6 +2255,16 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
> >   	}
> >   	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
> > +	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
> > +	    smmu_domain->nesting_parent) {
> 
> Surely nesting_parent must never be set on anything other than S2 domains in
> the first place?

Done

> > @@ -2608,13 +2681,15 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
> >   			    ioasid_t ssid)
> >   {
> >   	struct arm_smmu_master_domain *master_domain;
> > +	bool nested_parent = smmu_domain->domain.type == IOMMU_DOMAIN_NESTED;
> >   	lockdep_assert_held(&smmu_domain->devices_lock);
> >   	list_for_each_entry(master_domain, &smmu_domain->devices,
> >   			    devices_elm) {
> >   		if (master_domain->master == master &&
> > -		    master_domain->ssid == ssid)
> > +		    master_domain->ssid == ssid &&
> > +		    master_domain->nested_parent == nested_parent)
> 
> As if nested_parent vs. nesting parent wasn't bad enough, 

Done - we used IOMMU_HWPT_ALLOC_NEST_PARENT so lets call them all nest_parent

> why would we need additional disambiguation here?

Oh there is mistake here, that is why it looks so weird, the
smmu_domain here is the S2 always we are supposed to be testing the
attaching domain:

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2677,11 +2677,10 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-                           struct arm_smmu_master *master,
-                           ioasid_t ssid)
+                           struct arm_smmu_master *master, ioasid_t ssid,
+                           bool nest_parent)
 {
        struct arm_smmu_master_domain *master_domain;
-       bool nested_parent = smmu_domain->domain.type == IOMMU_DOMAIN_NESTED;
 
        lockdep_assert_held(&smmu_domain->devices_lock);
 
@@ -2689,7 +2688,7 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
                            devices_elm) {
                if (master_domain->master == master &&
                    master_domain->ssid == ssid &&
-                   master_domain->nest_parent == nested_parent)
+                   master_domain->nest_parent == nest_parent)
                        return master_domain;
        }
        return NULL;
@@ -2727,7 +2726,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
                return;
 
        spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-       master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
+       master_domain = arm_smmu_find_master_domain(
+               smmu_domain, master, ssid, domain->type == IOMMU_DOMAIN_NESTED);
        if (master_domain) {
                list_del(&master_domain->devices_elm);
                kfree(master_domain);

> How could more than one attachment to the same SID:SSID exist at the
> same time?

The attachment logic puts both the new and old domain in this list
while it works on invalidating caches. This ensures we don't loose any
invalidation. We also directly put the S2 into the list when attaching
an IOMMU_DOMAIN_NESTED.

Thus, it is possible for the same S2 to be in the list twice for a
short time as switching between the S2 to an IOMMU_DOMAIN_NESTED will
cause it. They are not the same as one will have nest_parent set to do
heavier ATC invalidation.

It is an optimization to allow the naked S2 to be used as an identity
translation with less expensive ATC invalidation.

> > @@ -792,6 +803,14 @@ struct arm_smmu_domain {
> >   	u8				enforce_cache_coherency;
> >   	struct mmu_notifier		mmu_notifier;
> > +	bool				nesting_parent : 1;
> 
> Erm, please use bool consistently, or use integer bitfields consistently,
> but not a deranged mess of bool bitfields while also assigning true/false to
> full u8s... :/

I made it like this:

	struct list_head		devices;
	spinlock_t			devices_lock;
	bool				enforce_cache_coherency : 1;
	bool				nest_parent : 1;

Thanks,
Jason

