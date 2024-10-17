Return-Path: <kvm+bounces-29059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E50DF9A21A8
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A605C28932E
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 11:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37D71DDA3E;
	Thu, 17 Oct 2024 11:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fUKsN7hk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E14A1DD53C;
	Thu, 17 Oct 2024 11:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729166247; cv=fail; b=tavbZgkKS8ZFt8oTAVk0C3TQTypuogP/kiE42MZ26rbjSGuh3OcfsOFHvCNplrhRyr/1qsmNuhYcFabyqTLxFc+QxQLItzu2ybcb/vKz3qpwZcSb1Z3Ta/YCXdHU7GycG46sQCFKcGe+6IxMTTrTOm37hs71/s/mBb3SHAxLKX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729166247; c=relaxed/simple;
	bh=djxWPi3ym0HQloESlIF174elIXqlfKhNKiac+QzFBPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TyH7Zf9hpEe1Fg2XmWqMJQwe6F8JJFzxr4BYjYkY/crVovgbSfwApzpKyZC8t/6Ms/+kjQPP1msyuQghpCqX4L7CPed1/QveEhUDrYz+hRkTp8ZEx7cX3eW7jB/GgsDXU1zD+BBl/WF1WEulUQRVsGPI1HtRX4COxkWR91kS/YM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fUKsN7hk; arc=fail smtp.client-ip=40.107.220.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPkiGxmu/PZfWnqHT+hRa3as6z5HHLWABApGojn0rWapDoRCiUGJIiNj2BFD9H/EQCinLiHMSIZRFoQUEka/ipCQUMnURB9BoP/9H6OamRMKckRl7xtR8DGL6LBgw8QifXTDSLzPUbSF7cnwyFY2bR7xHAoswt24eKhl2s/EpuLlN4sS6eqrKI0rOku6XvNEKgnqlubx040vOm3Flhvha1CMuCSEZxCwGLhfOpzEM6Op/iM7ov+IT+PLiBQng5Yg635o6T+GbL6FIN45TiaaKJpKKjJuQsQXUR/xBvqGlBivG0m9R5stzUAvrnOAVOh9ZytUcrnUjml9wvdRr6Z0sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mcb6L5NGKsikl28UfwNJBKGJxamyKoRAyHDnN9UTd88=;
 b=nkrzxsXTsw5L1OQNJiSlso13jMHVWAYGtovq87nrXgbzoAiIQ3fAMEaNuhP3KILdlIVNsHGjNcoIqV8m2sX9YMFESNYMjMonX9JamqgILysdstcAxywh4SVFnIIY3oB7Hz/cqRO54lI0y0XRKRC62x0JGllJl1JLFt9qeuAn31DU+iTyDAfPjbrtkgKiid5KRHMoAgJfZPun8Gk0xjhiY7+2wSwo3/HnZ9apBNberBeimQ8ot0Bq4k5icyMJMuNTLAmtm7VqsVqRIhBOTX6Zg5DLuWPoDLz54eWyxDE0XkJ/tTvBh7uXpkXze9U6gX0Nz9H5mSpyAtgg8EAyPWfZNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mcb6L5NGKsikl28UfwNJBKGJxamyKoRAyHDnN9UTd88=;
 b=fUKsN7hkUCoZgrm8tFBnnA4HUKXLQWTNfz8M4lQKdcJAQiNWwlKBzkHsp8TU0cc03UvNHwQZ4I18Oxo6cmflGZATFgJdDstCdRfAMyrAuQqS7OxTvnDn5+CQId1q/GhMwWzqQ6QL7xkcshz0/RP/1Khuv3r0sgI69wnnpeben140KiuuGzRTx5d8cm8oXzHezXSIvUCqa6D2o7EIxNTIjU3NITlrR/DP7Lkrwi4e70LqxrK1g4zpPZghu3R0WBppdNj+eWsLO9LO1qvNPOTEZ7AMRgVvs1iDuBfLDNoUlKKKDtmoOzU9gjX3kATppzlmi6nzcYqla6TcKllPf2TWaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB8027.namprd12.prod.outlook.com (2603:10b6:806:32a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Thu, 17 Oct
 2024 11:57:20 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8069.016; Thu, 17 Oct 2024
 11:57:19 +0000
Date: Thu, 17 Oct 2024 08:57:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
	acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Message-ID: <20241017115718.GY3559746@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
 <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
 <CABQgh9ESU51ReMa1JXRanPr4AugKM6gJDGDPz9=2TfQ3BaAUyw@mail.gmail.com>
 <20241015130936.GM3394334@nvidia.com>
 <CABQgh9GF9vm=9Yv2AWe5wbN-mfr6Grn9=+c5zTgOvaMU+3bNSQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9GF9vm=9Yv2AWe5wbN-mfr6Grn9=+c5zTgOvaMU+3bNSQ@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0351.namprd03.prod.outlook.com
 (2603:10b6:408:f6::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ce0ed2b-5abc-4d03-ebf3-08dceea2da3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z26UkxfdzjgWctlaSyglOS7bXKJ/4spylxAqD7tuRyp8q+X3cyxZWN5vFpAR?=
 =?us-ascii?Q?PENM2CTbwqW4kuq989i+UEkVv8exlpWWZYW8f+cDtbd61rQ9CQhMoX8JZtRb?=
 =?us-ascii?Q?KE0jOZuPFTcuAlWnig3GI++PCpsB8k8V5hADvVJwtuFGQOgdPv2+iKSl53qc?=
 =?us-ascii?Q?faySyEvBiJpkfs+zv+TSnrXfFz97e4anjfvEV94nCSKjj6CbpnBsPlwQ5BXq?=
 =?us-ascii?Q?N0P9zul+qi9hR2oZzwdBJPhxWSLUanZkRLITRXTe8vra2YyEHIgy77/IcWK0?=
 =?us-ascii?Q?lS9lB7BrSqtgJVe0yvcNEdaDcyD3xVPsG8rZJUu6cD7R4sBFoVaxcm96Kwp9?=
 =?us-ascii?Q?z64Cv1+GZVRwNog97tGzqML1QGieo2674rNrKDQz5XmAxnJB8CuTjGqmaJEU?=
 =?us-ascii?Q?gf2X5HONeCHDTL07pnCyeNBEmp6X0NuYXAeNXsSlghAGbNc9h0T28i32SRNQ?=
 =?us-ascii?Q?GtDBeJjEVn07mHxyopePYzcMTgfF2yQ3fmuM3DWV53c0xNqqYmTjddMKnfQL?=
 =?us-ascii?Q?nXpKjSgkF5s5rcE1Ftk7I6Muk6b6+BSH/yMH1EwGmpEHZhiuDI5WVSoRvN7X?=
 =?us-ascii?Q?BT40dHAHfHH9k6OfIRPFwWpbUg9pco/SlXE1Pp4d3eIBmewz6gUFnpPRnzRp?=
 =?us-ascii?Q?nbNgOeqDryr6cei+7eE7CpoRCXRlsFZYh6m1dTtsUZzPkX3b2SulSRDFa/yi?=
 =?us-ascii?Q?sf9tqLa286CIs/dqCW5Owze0wcMrZ0/Pvfls94GtYYfvNXtvBTcBY6t8R+8m?=
 =?us-ascii?Q?pk8kIiI93siKF/9b7xmmhpHr/QgNXdb3+dd4RUtE5n+A9vJdAetfhSs+b7vn?=
 =?us-ascii?Q?aEnKuKrfKXFd4+wDO4U1zKA7DOHNjaH4VTgl0/QZbwDh9NtClxIpkop5HE0y?=
 =?us-ascii?Q?CZOfwW97OgsGoU+CNlj3FLZxMLwQfL9IE+zB7yXE5nNud3UlJ4/NvmWq6nzE?=
 =?us-ascii?Q?RXfcI8kwkMRtKq63/zmTXKy5gntFoH6v+1xeF7S3hAdASkmn9DcReYRwCVJO?=
 =?us-ascii?Q?P002g3TLcT7CCLJC0fTfjA+bCn0E6qEAq0Z530rwbvckjmswHHiHhMh7bEfH?=
 =?us-ascii?Q?oT/u7a+JA5yZmVvZuLfnsXEKgIjyG+m+3Xvx4eBuCuhkz55R5VL+ID1aeduJ?=
 =?us-ascii?Q?nKQ99oQ30sxIWm/51IzDSEiie9XGFUi7tdUJMBKmYYBGTsVLy9tZPeV9zmBL?=
 =?us-ascii?Q?+um88VjYqG0/MlkwbXs6K3YT46lns8i0jxfgbDrYkFUyNYtrcR8CX0G4zshI?=
 =?us-ascii?Q?F67ogWKhXPMXGjkc6O2Ez8yiVnicX/vG0SbTCBJphTmOhydD/kJ/iaYeLWcy?=
 =?us-ascii?Q?cNZw7vGkUUX8DJ67tqdk/qlv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GnldIV+hR6yyhXKdhrUzeo0NIGjiT26Fc4X67/MrOu9xUNLkMfnRvq98aNQO?=
 =?us-ascii?Q?mxK8ixkbjmxNZgwiaGIzsD9TZia5RMMbOuMRj3goSXmTL+tvCeDXkin6jpr5?=
 =?us-ascii?Q?rmgMMzt7fMulb6FAWGAQmQLdrgsMuRSAcymCoySKo+NkJm9/tXK2itX0jgHW?=
 =?us-ascii?Q?Uiix2RaQNN9Zxz38v1Ds30WuzFdOtXnXS9UCzWkOCK7a133CUuTFs1lc1E3J?=
 =?us-ascii?Q?6bTjnYbB8oO1Ze4VPbwdVcVWayW3RkWq9Lf/pN1aBJqDizNFvudZqyrIG+ya?=
 =?us-ascii?Q?uRb7iMWfRj6kkGCxkLLaKefxnP23g1kee/lR03EmgYionqHLYGz1lN4tkGeq?=
 =?us-ascii?Q?CTaqZYBFTFTlVJhp5X90LEGIibklu45c1A/R0NAceldFZrgnMaVzyKjqMC0F?=
 =?us-ascii?Q?aW8lop3dHz/wF2eaND3kGZzC/SPQfdQNjwSjOjBBrR8Dq5xnR7/yLxOAQ+2Y?=
 =?us-ascii?Q?IjvgtYObeocrzdheeL2YjhB0aGbvBauBy+zM0/AHe3VZnp9YUn9AiASOR9hF?=
 =?us-ascii?Q?ctXodniQnwXfg0nYqIbfTeQxy25Z8hV5aP2PAaTxbTymdHqPl83jrL1/Pxo9?=
 =?us-ascii?Q?c8sRroxWnRxXpmvj+LXmk5jYq302LtqREz0vDtAUqk6EqaiKO0UJzaM7SoGP?=
 =?us-ascii?Q?A19HbuwzW5nXVwcwzqolVgXh9NmRjmWd4UL2FAFLq+t6iUyjEjVUIJGb2Lq8?=
 =?us-ascii?Q?C4kM4N7+o2InthM4dqAyvaFElMWqBhwNERtQ2smO0NR1OaA7PzuuRIGVcaTn?=
 =?us-ascii?Q?o44IA9ey4iGaps33+iFNdMViixZ1cAUzQnXpqPrUcsWQWdWR2jyCUkgCcKRf?=
 =?us-ascii?Q?Z58ZFdi6rFFpam+uBWj7wwmfA0pPbhY3buYeSjrNUb6QiwiSy/KHkdA2nakc?=
 =?us-ascii?Q?HxB6cRAXYZcSJ/oN+qrrlNHr0Xw9QV3H+tGI4LQym0aCTSSZDsi19jSIfZ6s?=
 =?us-ascii?Q?PIgo87CI8PjmknEFfU3ZaMlVXMPiI0NbaPtL4CdCQ4NuX9rn1V6gnlPenZ15?=
 =?us-ascii?Q?Fo6bzB6JYHAf3CtP6LN7IG61PV653pv1gIN3lJx7SeYYegJqL2CDdIylSlDk?=
 =?us-ascii?Q?KW3e5ePuQaCGgT0/U98HAkGyzgqTD+zgBqHb/KCFzPMDBe81yhpGeu6Afof8?=
 =?us-ascii?Q?EBrNeSP22Ti7VvuZ68bwT3AnUzhslW/wpSaNZP9Fym0jOr8b+lO8qUuox1rY?=
 =?us-ascii?Q?d40zhPEVn+0CzZ4/Q6VEYGPPMQIZFXvkUlGFpPtkuDh/eEB2egwlO6hiP5ny?=
 =?us-ascii?Q?31eqnQgv4yTr+1+44+/nCNsndH+oYHXdUMOxHLNmWKTdg+ybiJ08nsy6byoE?=
 =?us-ascii?Q?ABWOgsCiJSlb4oyoRH7A17R4+zeyExjwIKMVgj0v/KJHaG0wXOhbMkRqdDUn?=
 =?us-ascii?Q?hsR4VGAyYth0XiL0ihxfOy/1S2rupgt01/7L3HJu9oPsCdLb3Nyl7P8viUYu?=
 =?us-ascii?Q?kvFFbo7H0cCx6lyQsDBMvwb6neN97E++0pV7d2jvYIWGyEMsJaOLhjE/Tplv?=
 =?us-ascii?Q?FZaB3GZ0fqCqWF+2/4tdqsPpyMZEl9t4zhiQWPYL7Mw9PYwnwR34ZTQl0TZ+?=
 =?us-ascii?Q?gh6RELPZMONiQ/tbJQw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce0ed2b-5abc-4d03-ebf3-08dceea2da3b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 11:57:19.6791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vn6aUL9c2ZyYJCngZFK06mJsZifcOS6wGKsaIafseRNaUMPbVLhAmrnNjsT/In0Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8027

On Thu, Oct 17, 2024 at 09:53:22AM +0800, Zhangfei Gao wrote:
> On Tue, 15 Oct 2024 at 21:09, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Tue, Oct 15, 2024 at 11:21:54AM +0800, Zhangfei Gao wrote:
> > > On Thu, 12 Sept 2024 at 12:29, Baolu Lu <baolu.lu@linux.intel.com> wrote:
> > >
> > > > > Have you tested the user page fault?
> > > > >
> > > > > I got an issue, when a user page fault happens,
> > > > >   group->attach_handle = iommu_attach_handle_get(pasid)
> > > > > return NULL.
> > > > >
> > > > > A bit confused here, only find IOMMU_NO_PASID is used when attaching
> > > > >
> > > > >   __fault_domain_replace_dev
> > > > > ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> > > > > &handle->handle);
> > > > > curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> > > > >
> > > > > not find where the code attach user pasid with the attach_handle.
> > > >
> > > > Have you set iommu_ops::user_pasid_table for SMMUv3 driver?
> > >
> > > Thanks Baolu
> > >
> > > Can we send a patch to make it as default?
> > >
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > @@ -3570,6 +3570,7 @@ static struct iommu_ops arm_smmu_ops = {
> > >         .viommu_alloc           = arm_vsmmu_alloc,
> > >         .pgsize_bitmap          = -1UL, /* Restricted during device attach */
> > >         .owner                  = THIS_MODULE,
> > > +       .user_pasid_table       = 1,
> >
> > You shouldn't need this right now as smmu3 doesn't support nesting
> > domains yet.
> 
> I am testing with  .user_pasid_table = 1 and IOMMU_NO_PASID
> It works for user page faults.

You shouldn't need user_pasid_table for that case, it is only
necessary if you are doing nesting.

Jason

