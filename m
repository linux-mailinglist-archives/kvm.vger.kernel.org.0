Return-Path: <kvm+bounces-21641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 686809313ED
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 14:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C9F01C221FD
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 12:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB3818C165;
	Mon, 15 Jul 2024 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="juP2jXP5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C12018E750
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 12:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721045775; cv=fail; b=Kmx254WDD4PCeIGS5Lgp83rNLUFSeiJTaMKkgOlUyCgUYhPPJ3asMUqhaelEXrYEwQiwQQsJ6/b3IAPAj6ovmCb9ClBBqUy1w3uXIlcbJzwEdBQmeHHIFc3zIc8TKQiNnWLIfMrkUfpt3yZHzQiN8xdgCzhJWGaFsDdXPZlGhNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721045775; c=relaxed/simple;
	bh=7ewjxak3boNfl57AFlYYGwQkngSzsduesWKHjMYOBt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k6KBMqcAzfU7WpQQMlqzc3w+rJrIyGGo9JVf4BkdjFuS9QqnkVfkVMulmZSkQ+t23yDHlI0eAQ60grPJLH2si5OIh8lcY1kEwsAGnVQJ+iXnkuBz/aAi8xu3Rv5tOgIzdh8VMWqEaDeJDLfA94AfWrnJHO6QbRFZb/eCyxyoa/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=juP2jXP5; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hh/v6Y0Ro1kGcj2VfQft3BkP6z/6ntb3KdDHVJJy7hDHBzuYuGxGVj+AQX3c1u9cR9haPSF8W/H2oaTIJWT2DOfuDB/U2GSG8GirYuk3qbG0IWavAklq/eGdkpkDYIAuj29PJaLOFs1mWc4mr+QNkiGV9ZwiekMOJTy/zikSDu5hWkvpHKl+4yCJAHqtoXcGzciKESHR3ShYfo3bjazFekwHcZ+7soeJYpDt753mEWOlKvWbeFkvBI6HWjPLo8ZJWQqWLIO0340YVqywfCmXBR7hnXqbgpKOGhzxa17L+4nYDf04s+5yIqsHbQ5MEPTqd7k7tNWfdZuxsxkdJMEzgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t735E922QjYACC5ipKtqqdBA8a2GYcntIPBOsiogXsY=;
 b=qqePi7rdx7qViZ1zwuGKal5EYqbI8YAbHi/JvsgruDkQ1Y+l3nLskjO2Fj5sVqV6+7Me3qA48nBQpbIpdYN8uip8t98vWdEYovjoq5BbEN88NWAIOxbE+d9++0qt/89yOd9CiNMfNcGXrZi6WdGZd/03msYsqDhped6NTCOuLiZks1WBnnpaYPNv76eQXDBZaBOnQV8jfKiH6GZ27KZWVaVxh3ddu9KDDFNk9qS7449dvDcWh5fQq6rTg8mGTP+QjEGQBiD8JeU7bequRcvVfe8Rldiz3Wf7xe7VWA2rDeIEV7s7CdkTTlgjA6VJgfxZWLwhEMOrL6mj5qGL/q4SKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t735E922QjYACC5ipKtqqdBA8a2GYcntIPBOsiogXsY=;
 b=juP2jXP5QzEYO3CdXvRMGDr+15sXJgNXVC4x6xjSVKsmtXJvxYu/AXzdsVNhztNzZ0ZIV0i0CyMiRHCOnjfgRmuzB6UJ0M5+VeQ8oLi9UjmRuZcnkOk2xD5a0vfLl3MX0+KU0MmziZPLVxk8RA8+/AjVox5duQKwHN0rPTIjWLmOVmo2FdCZQDPDHy2R2qDC9p6w/f+545ZLM7JN3XxKN6FUYFwHMdyOktBQN7XgSWZo/dobZ4pMZ4rVu4PyxSpYNWb0lciSCUjo5XBw+yxmE6wALBDdzZruNk0k4+B4q4mqzlCE4gLYgpMhLbGph4tbtU2Gb8IkJQNZ7JG9KSooww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB8779.namprd12.prod.outlook.com (2603:10b6:510:26b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 12:16:09 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 12:16:09 +0000
Date: Mon, 15 Jul 2024 09:16:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Message-ID: <20240715121607.GR1482543@nvidia.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240711183727.GK1482543@nvidia.com>
 <f05200e4-fcec-404e-9a5f-6eaadfbc362b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f05200e4-fcec-404e-9a5f-6eaadfbc362b@intel.com>
X-ClientProxiedBy: MN0PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:208:530::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB8779:EE_
X-MS-Office365-Filtering-Correlation-Id: f6382145-ae1e-479e-c077-08dca4c7e8c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4MC0dgkKuuYYHsz/HgNkB70QhC6xTnaX4lGmUgp1z3ZsUKEiKuEVnrgwo2mO?=
 =?us-ascii?Q?Ye23Zz+6Fbo90/lJiDdgnU6kcz1oYTjIumXO/HIOPZcANaAI4zNugarEtoR1?=
 =?us-ascii?Q?Qrjn/NmhwfljSPmnEVRHx0k0kl/J+q7gFEOcpmClOv0vNW62VV3ta/4XdMGB?=
 =?us-ascii?Q?TnJdZCrN1EVOSYCEYeO3kJ8jDi/qBVWsn/lTMZ1Gff+IBEomI/qNDlXbWio3?=
 =?us-ascii?Q?D1PNh2q5CrI85avLIQ9ODOMe1CByowOSIHz7gXyXf+iYbgE+N55H2rJbI2gR?=
 =?us-ascii?Q?josvAzkeuzTQXRsKdH44A1MWE5FiuVFTfIPvQzuxuAQE7lqo2ZH3ca1k0hJc?=
 =?us-ascii?Q?mkyUsSqMR9bwgiilcqKUYQVDwETiCQodIzoUUzKdG+DIpNt5HoWjJeG18xhg?=
 =?us-ascii?Q?Wb+6I2/QEbjTOic4dewvhR/t4Jvxo8kiR9zBmdH+LKHiGpA8Ruhep7864+GJ?=
 =?us-ascii?Q?bxwMoLLLnShE2EdJb3r5BAf+7lRDPeClib7Pg8IvGPYI7odhP9aW4wQfTaKq?=
 =?us-ascii?Q?T0V+budMwlzoUqMdw6iv6H3WtZAOe6KnsK2K9yoFMKpG7wG7yUITlnvY0t9Y?=
 =?us-ascii?Q?c2plHu6p9A8993/MmDvPT0BuJeNmHZ1+hIDvUxyVE9pRFZ4E0Vt+mYWm2Fh4?=
 =?us-ascii?Q?E1SB5bLe/v4RIQmFdK13T097qGNnJKGooOHqVUwK2uL+4NIYu4CC/JDWlhXO?=
 =?us-ascii?Q?yT9O5i5reeEPhWgVAqLqdKogf982fxo12d3vlE2DUHK0Y3IWxx4kwz0B9Qw6?=
 =?us-ascii?Q?VhjzoCEQFd/C70woGkA5VihtVOsvPSlb7o0id5x1sLwucYeIaeuGyUkSFI0Q?=
 =?us-ascii?Q?HWHxyv9081nOLvJeez2mpxPft/1mhA5UgqusLeXyTYIFZHXVfJquLTjpNiqL?=
 =?us-ascii?Q?TiwF10eudUDig6pzZCG4pKDaSHJJiC8ROPzidctXlZ0G0bZrDSdLB2oJ/5Tg?=
 =?us-ascii?Q?Ufk9fJ9si8JQwTTZAA3yGIJGuWieZc43vblFKV4ZY/c4FqoW5gN96gpKae2V?=
 =?us-ascii?Q?88gLmTCZ0RbkVYLFQoUUVl3zSspKuDCpHS1L04OQLi8HkprNRLTFSQVI9FwA?=
 =?us-ascii?Q?BQjhD6n88TY3o1h5UsvsmAzNErgK4PfERs71haSqxbbB0wUtAn3rTavwjcrp?=
 =?us-ascii?Q?bAPy+bsokfJ/JviPYTYS2b5bOzggpql9R0Bzib1qORJEcSFnqC5tMNl1P2Ie?=
 =?us-ascii?Q?VPla+5KB5tK9paToUAgTqLfSU4xgx3tB0BoVCZQ3rFvad3r3CFv4tb4B9WNQ?=
 =?us-ascii?Q?shdpXa7vz8XDIKcrtqiCMb1sq6Vnu4/CtTBtBPtQzXWMxI2QUQmQzoq0bEtD?=
 =?us-ascii?Q?5rO5wlbMJa0df4daxEcO+ACG2Qgdmc9Erx7mj3oOaLn/hg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L5mtgynkVhq0h99Uzi3f6I9huvGc9AxbS6dp3+gAEqALG9KlyiY4Izb01YIT?=
 =?us-ascii?Q?lR81YGBquXyd8kseM97PjVgZ0Kgdvt0igI3fqAZgYAjn89T9pSEMut5BgNTR?=
 =?us-ascii?Q?UwLbroAX7vjy4bAo5ZyPoyshFNBD2twoHDEBCtmntyDbigMi7mICWO6yk4uT?=
 =?us-ascii?Q?kpofLsn2kEuSD9DDg4H6zB+/hwjTtdXrN5gAzmJ9c3rjdKM6XwQt2+f0i+kQ?=
 =?us-ascii?Q?Le/dHaTIHE5etXKCSWebAuTjuLCF3ORR3s7hQ3lcirhwaiSays91ZdXa6bqV?=
 =?us-ascii?Q?GWd06xJdP1mYkjMom07QXIzffw51YnHXZcmfv/dG2AYuw2J97BxxtQwjoLgT?=
 =?us-ascii?Q?FkURW+H/zLSqcsnh/t8wDTMYh6x2B9sNnY539JLxZEaxv1uvTOW+JRS60bds?=
 =?us-ascii?Q?skc1NGZKmvCTvW+xAFz7zIIoTbGZC6qGrmqmeDoUAkSICnQ8ug2WNakNK+H3?=
 =?us-ascii?Q?vT5a+ybcy5NEYMxlH7z2vz2gPnr051CNRb+9YS7Pr6gixi/inWQRgIE3HG80?=
 =?us-ascii?Q?/cjQEBXzcuL+yHVAGpPjuGN6bm9uqww7k+LlR5tfuLbFJ/XJDEFfji/VWP9u?=
 =?us-ascii?Q?KxkF+hCLe8M076vOaIw4ocVneN3+mY6GOTgpW/hBm3aFX3uYINT14YBw4Eqy?=
 =?us-ascii?Q?ZaT6pCW3R4OZEiRzFZ8JdEzWh6o6h6ezcPBdBn3F8KGj+Ok43tai2r5OLBQA?=
 =?us-ascii?Q?HwQ/U/VzsrAR9ERhl3MwdnTNL/fn60/F0qcu80zTEsro8yKc/ZBMdYDPQgsy?=
 =?us-ascii?Q?q4qCcR+3728EpPe0sxWleHwTfVtGl6xiXQWF9wcjK3d+Ff1XgLpyKGIJ4GzF?=
 =?us-ascii?Q?NBbiec83f7dXAyD9vVq4e4GMXQhtG0CUXFLeL82UGcxYBbjiINc9vgAdZjBE?=
 =?us-ascii?Q?jt+qUIFgI16wVFsWSP2+aSE/+VVxDc4BZcjGD0FsPFtfjXv58fIqBr0y+ZpL?=
 =?us-ascii?Q?+zEO1QErzzgiMmQZnqNgoYxz+ksoey5Sia1ALJUlvqnccmqVGxV5fIjQc31N?=
 =?us-ascii?Q?HaLJwQ3UMPkLDp+RbCk+fTvUwJ2bFdAlKPxhoeHjZpj+4tfyUDRq9dOzdpkI?=
 =?us-ascii?Q?op90Q+me3KhltDr99UJMOD0jD90Sq+qhBArvCsLwobhklGV8sZwzty/tmBQ+?=
 =?us-ascii?Q?6DZysDqOGh9pLRd1oevoDnO+M8Ao31bJQDt8vYF4uDf6Rjt+5wJGxle5LIDs?=
 =?us-ascii?Q?U5QwU79hfC8ghBNuuwgRwdwnhCha6/Czt4zXcA5/yprJaD403rwSXHY0xn09?=
 =?us-ascii?Q?K5LacNGCbL9vI6xvGrZs0fqz0YRfWsxbRoZlKilCOSLZEoD7SdtM/JRVYZ5X?=
 =?us-ascii?Q?F89rH8M5qXwsujCdoOfzemJMqJ2xMsYxiFojdDd6+26vrkBwRNSpW9NBc+XZ?=
 =?us-ascii?Q?P68QQ1TJmAr8o2AW3HCM4MG0jnwlopJMn8vrZ1CDw+kYMBe0WJtrLFSlJC+L?=
 =?us-ascii?Q?wWAPlAym5rEQMlr3MIGQ1ocLlpQ3BqopjQPuw6vxQIrVq1pXLGEAWMaOfEI6?=
 =?us-ascii?Q?GfTcoH3OsAulepFfu0hhJXfbQNOfUtmyAnVMlR5HsVjGyIAQPVqsI5YZXbwU?=
 =?us-ascii?Q?eTHLhxMSoI5ycMOosnI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6382145-ae1e-479e-c077-08dca4c7e8c3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 12:16:09.2124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MhMYt0BFRKKlXhpjV70j3mWjGCd2bgNduXzWIWdM3XBWUurnP+p72YAamSiRi2pV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8779

On Mon, Jul 15, 2024 at 04:11:43PM +0800, Yi Liu wrote:
> On 2024/7/12 02:37, Jason Gunthorpe wrote:
> > On Fri, Jun 28, 2024 at 01:55:32AM -0700, Yi Liu wrote:
> > > This splits the preparation works of the iommu and the Intel iommu driver
> > > out from the iommufd pasid attach/replace series. [1]
> > > 
> > > To support domain replacement, the definition of the set_dev_pasid op
> > > needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
> > > should be extended as well to suit the new definition.
> > > 
> > > pasid attach/replace is mandatory on Intel VT-d given the PASID table
> > > locates in the physical address space hence must be managed by the kernel,
> > > both for supporting vSVA and coming SIOV. But it's optional on ARM/AMD
> > > which allow configuring the PASID/CD table either in host physical address
> > > space or nested on top of an GPA address space. This series only extends
> > > the Intel iommu driver as the minimal requirement.
> > 
> > Sicne this will be pushed to the next cyle that will have my ARM code
> > the smmuv3 will need to be updated too. It is already prepped to
> > support replace, just add this please:
> 
> thanks. So your related series has made the internal helpers to support
> domain replacement in set_dev_pasid path. The below diff just passes the
> old_domain across the helpers. Is it? Just to double confirm with you. :)

Yes

Jason

