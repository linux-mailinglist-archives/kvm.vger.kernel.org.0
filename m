Return-Path: <kvm+bounces-36293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E09A1992B
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 20:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DEDE3A3A1F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 19:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0489B215F7B;
	Wed, 22 Jan 2025 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kpxRXRFh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6052153ED;
	Wed, 22 Jan 2025 19:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737573989; cv=fail; b=ITyED2doQLeeScC0YdUIPB1uZFvUOkTtPmKnPBsW0gEkbkf1vJdAIpD3mf0XsgSsanSFmz8PxCzHOU8J10fSQPKxf8HZhkQedAxg6RcPIdG3rC7iWmWnRe87K2yAXEvVvZY/HEcJDqQS2yxRKnBpM3JF+DoBFDADx/WQfjv8Mcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737573989; c=relaxed/simple;
	bh=CMAeBwSAl+DmU8j0YJuekPxhExajpzQPqoxD0RWlS90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iFrvCbZN+3ORMUcnGnjf9kK6gi86sx4ieliNuxNqqn3CwnN4h0q5tbslSrINacNjjeIMhYyKBwUxPbHiFoRjmiy//hovC0pdzf0wVrD4dtFlNDibwo4h+dCagGduu0ajSKVXomU+8/L3cDb5GKq909IRR6qEDhszYYLpTS0q964=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kpxRXRFh; arc=fail smtp.client-ip=40.107.236.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzFHXQBlgjjRkPIzT3j6KtX5RbG4+5M2h7ymenzyZ3rkn32T/tdVjz/K/PKryXTmntpUw/3/D6KXaS4RMs1dLnrf2A03PoWg97HpA2f1sy5SJuyTwEJZIzmk3yRjDYK/2/n82vUwFLiCcldlDnrRU2Sp/kk/e/LuxLFVM6ICrBccTLOxzv040kmQ/KD/k3SwcvDCPpXHuZcFcT1b6mJwyTs39hvTLW88n+AIYi/0mGzFvJmpc02Ez+/qppT7IQ22N107OiZeHKbJauwJdjtilKka/NB4/basZ34kM1BAbY0+6gHMvLoNox0/51ycKVSCfonmQfL/SGtERZwjEwRE5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5/QjlKd7INPe1HgojOhV/2stvDwogfZjlBdkvmc4y6I=;
 b=LKcoyTFObNR94o/wx4IfQKlNeTUWGIIqUgzP1E3hxKJ0oUjV8aauV29dj9se//crsD4YpF+juzq2GYB4SDKAUPKJWy9iJXZ1fEitcGnIfySR1WLVN9ZnE+YMSKXTFLymeiQCegJkTDKrIumWc5dJbj8IME0OLcLj7+Sxj/dyPoX9HqMe/veuBT3XyE+WutjXgVjdEZt/64kHJ0IPA6XJS5m1hrYlgo1BVs0qnA3Y+TXxlDct43EukfV7t1FHKSFA8AqyRbOBFQUM6KkZrlC+dsL/bCLk0h+13WtEI00aFVHX5hhs3OL5aplO2e0xNgbySuCfanE94pJ6SAFXk8HbDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/QjlKd7INPe1HgojOhV/2stvDwogfZjlBdkvmc4y6I=;
 b=kpxRXRFhUnUs5VAYQ/VC5q5lnuqsz/WrkilJIskVaVW0S+CM/THwilzX/nmvROGM1vDb8a6c8lM3YfsVUkvEZqoE3urkjBfPEnlssTJmssvYOHlM2Zeg8e4ha65V4L8nW2URqz3T1ZWFy6iQFC7OUQDXNGmRwl3Zdqb9m8kMgzBtddgzPhaew51lRUxGDSUAUmZRCkgntPzxv6zj5l2QJ7ib64H96VLYvwriTcsHsLx9rUdlVbmQqv6qr64t1WnNUE5zprkbsoPoPcn4M+DT6M8/a9D+z3EZ51esbNHCb9LUFHjqCyquEzdhCP61uz9m/k1Qn1O3c63TAJQPGSKbnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA0PR12MB7462.namprd12.prod.outlook.com (2603:10b6:806:24b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 19:26:24 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Wed, 22 Jan 2025
 19:26:24 +0000
Date: Wed, 22 Jan 2025 15:26:22 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, acpica-devel@lists.linux.dev,
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
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20250122192622.GA965540@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
 <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115175522.GA35230@nvidia.com>
X-ClientProxiedBy: MN0PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:208:52d::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA0PR12MB7462:EE_
X-MS-Office365-Filtering-Correlation-Id: eae9cc8b-a81e-4637-c49e-08dd3b1aa875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QQTfrl+m6tuC7g/agspPGIgff88jFgaKLzOzZnjaSvdcp5jhTsg9hTT+Dq1O?=
 =?us-ascii?Q?FiOIcdsm6rxU6B4GV8do6iPAb8HSrKcYOe2UMRq9Kd7P5IS28kE1mJ6eg19U?=
 =?us-ascii?Q?SJ9qAHtY/C09nI4LgeeYgLWW4gRGNvKorLq7irKF993PbKwpBMe9QTche7tc?=
 =?us-ascii?Q?JwzKJIHwUO1lfcwTZLoRbE9UJKaurhwDRI/WZtMOm+mjsNO0Jb5yI2v39rzV?=
 =?us-ascii?Q?vQK8gMef5AoeW4AWdboQrWphbyIz15Dl4CPbW2rDLV6ztYAgqc7Y2iHFg9l2?=
 =?us-ascii?Q?y/k4q9EjfGhF/7J1FQ12akM0zPG0enFjLU9z+eivQb2TOMMZo1pCuO86lP9a?=
 =?us-ascii?Q?u2orgu4Ehv1/zmLAppAkjNFBW0cH+DhLa+1QShD7pkWtTwWyma1w2ZPFl2VS?=
 =?us-ascii?Q?culxMnl75p/caegWyrDUK4s3S6yxX0LDtkhck47cNpksE0E5poSbt95YGXW4?=
 =?us-ascii?Q?vy46ZntvOFU5VbcYX2dnpZSh+wbb0NZFPGbt+GsB5KDMiRhxn8OlFDhtvn5r?=
 =?us-ascii?Q?gcFbEtl+tSsyacoyAnVd8bcorkI3AF0O8adclt0BCKs3jU4Q1iwlyujObTsL?=
 =?us-ascii?Q?FErsfMga+9gsOv5dunR+0ZozJsgTEjzAQzQQif/0Pd4c0G8Vj2MSKlkHhGkH?=
 =?us-ascii?Q?S13v7v4883VQQ9QM9v2skAQfXN6qiZaa8jm8wDdmQXi5m3YfPFOgji+MVb1L?=
 =?us-ascii?Q?q5fYqDLsHopEQ5Ltdgu8SQcKLtAaqjT/wNeZw7S07tVUFL7vwmCHWSHY+/iy?=
 =?us-ascii?Q?LUqWUigfF7lzpodjbVYk9abDWZgzvP8RHmyGjOnXT3iOwyQfuYZLCV5ObqOI?=
 =?us-ascii?Q?HvFfo5FikV5+YzBLVcwtcwCRf/wDC2Zd4Ry5x3ukGLUo/IUgIgSf0d7V0qrN?=
 =?us-ascii?Q?HqJbKJqLdzaC2ejg08YdtLnItO3oNrILdn+688xwy/xA/lwjb4xYZleFkx+z?=
 =?us-ascii?Q?bYTUcVGyeIdBZCepKSkoEmbxCtt4bUiTlTxvN5eITEdCzZNekS6/pm94nWG+?=
 =?us-ascii?Q?0/kLILQnmj1RPEMrqBpLLMVgo/aq4Yte6Yhm1HAiVDzI91r8pREA0QTZJD/S?=
 =?us-ascii?Q?S8Qv9uH5pQOSVGzUwlmZhvqMi0Rctkpduw+Qhkrao7HJWB5h37ZvAsRVsRJX?=
 =?us-ascii?Q?vV6ct7yHC9NpJCub51fJFNU5P0tN2c9IzS9w/uHo7iMFzedEI1F+9bfnhgBH?=
 =?us-ascii?Q?/ktQj+ke5g3EUlzN3jeaFB9qKc8eFp6ch2FtldQmD3Psxx4dAbWCIFlZ3b6y?=
 =?us-ascii?Q?LtSZHhcoux1wlDmR/KvslBBqzjV8PVdMae9qPan9mwAlWaVfdluETEMGN6J1?=
 =?us-ascii?Q?F/QYqv6C5hGrBkjWXbpBPHvRiZBId1o3VZ1UOpEGa6eJjPlyoSweSLDV0xUU?=
 =?us-ascii?Q?jegUL2uNvBZtA9VGKHCtLE3GuAOx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N/GHwMI84BCGdEOUu2o8vGQDksmhSnm79A1KejUbZsrbRSrFR0C7gtBJnhwc?=
 =?us-ascii?Q?YySpMgJ9cHT2MG9P+2+wwf15EVv5EoeSW3frThCDt2+Eb+OXQUoPquOgRunV?=
 =?us-ascii?Q?LrZnFQdj8i1r70OESGgYjVhZsMy58PaSfpoYQrElJvCFzxSroSJe6jvnaMOy?=
 =?us-ascii?Q?/bA0XvDM05XLej9SigQQb9yhdNFuotScIRnP0GiJD92OBJmVXGKMjBAeJi+b?=
 =?us-ascii?Q?PSy1r8cclCUdg4td1yoZWB4000qcCQbHFSrUU/gf2YgFzbYPmSBBIN4cyHNg?=
 =?us-ascii?Q?SwYp0cu+pu+4xLZ0j+9j04uPEGtu/RNvDpp0+40R1XUoKtwAkpM3Uo4Tv7pG?=
 =?us-ascii?Q?4h/9KiLfDKSkbbxLRtX1oRV5zKUemBJeMNJJbXcn+Gic9JLg0mJjLfkjo3yw?=
 =?us-ascii?Q?zbB8I/m82FMdk2HgSAd5RNGy/MIXyYeG6kXTDMICuL3fsxYtFEty5gPijaW6?=
 =?us-ascii?Q?t8oqK6ULKh0ct2H4qOAZ5+kgb2f77d87vuQp2zpvoj4zMYwmbb5Kr0ch2wQp?=
 =?us-ascii?Q?547smwYh3nTNyUHk86BI3dCBXUk09LIQ6JP5i3v9rDG0Yt5tgXe9ZBp/Qk52?=
 =?us-ascii?Q?5slLzyRn2XBKHOW6/XilLihAg/CvY0m9n1MO98ABd9ZGi/SqMQrzgPBwn4l9?=
 =?us-ascii?Q?/F+Ll5NN5DLEEAqT/sElunkXqd9WlNckWeI6HPg4Smnk7eOfZGF0NO/RwyWj?=
 =?us-ascii?Q?OnpBHmf27EBH3HXWFs8PGgvsvghxHcav2OQqoJR5o2SK5+mvTRerbSzGHT0t?=
 =?us-ascii?Q?CsGLuFfAH2BReECNM9p5pw6DKlB0IrSuvXPx2MHP2e6/P2oatwgPBe4Cp90S?=
 =?us-ascii?Q?g1BHRioGcR8KGqKyC5OyDyFtZjkfKPQITjwF954Sbt3QaTt+rVL84JEH+ZlY?=
 =?us-ascii?Q?Loi7tabM8X+xFko8Vek7HxggE+ZpCaSzILT5iqvqKvbUlqDTSy/TwyC3WhoA?=
 =?us-ascii?Q?V+bTHMCpWoVCZsMBO5tPAESud3Gjxf3vuDvZusbY4dqwofaSzMDco9USWCmf?=
 =?us-ascii?Q?pGhTXbCikiYzEhYGNBjrGwHvYgIFwIMNdohJ4g3jUwsKvqshjDXdlEDKxBi9?=
 =?us-ascii?Q?UfXy0XxLHuMfEsEwFNMTmneTvadBXu4uvp8LIeWsomTE6zB+LaBHKh7tVhR4?=
 =?us-ascii?Q?fTIL8MjQARZKfYmiSb2EIxHAWSqJ3ODUOP7IN1xJMejkn4kVk0P65dZLHH8S?=
 =?us-ascii?Q?IhKC3KZ9RRtX9KLpq5N3tyT1SRtPKhZvBW/xJUmWpDQ9qxCV1mvROpIH+SWG?=
 =?us-ascii?Q?gephDl6E2ZXAlURBNpZWazmHLivpCCiPbCVWTPcgv/Z1J6T842as9PTXtJSg?=
 =?us-ascii?Q?TGd5teGkGHtFIuLqdgQY58iM5oEfX7t8TegQMdS6A+dJALO4UMMjH8UgIyvW?=
 =?us-ascii?Q?z9C4NwP7q34T9x5H7NbyJSqFW5Tg9eje3yIlc1TgJ+uoUTyLZ4iwUmHN/7J1?=
 =?us-ascii?Q?5En3Buim7Ie1jOgg6owznAC0OhJouh1EYTISnuEvQOdRltddflaDgw1EAzF0?=
 =?us-ascii?Q?L9HDcTRa8z1hCL7Lw7CORNH+i/LxBuMi9R1cu0MJEAo67u857QH4h/eT+PPC?=
 =?us-ascii?Q?DSbCKhTsbHF+tm/tAoQnhzeZA4LTsIM7GBOQmzqq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eae9cc8b-a81e-4637-c49e-08dd3b1aa875
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 19:26:23.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RInY1k8gqjTyJP79e7cS27haSDWAODeeWYu6PBmUXVuCs3L1jx1OLMElD8d60IMt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7462

On Fri, Nov 15, 2024 at 01:55:22PM -0400, Jason Gunthorpe wrote:
> > > I need your help to remove IOMMU_DEV_FEAT_IOPF from the intel
> > > driver. I have a patch series that eliminates it from all the other
> > > drivers, and I wrote a patch to remove FEAT_SVA from intel..
> > 
> > Yes, sure. Let's make this happen in the next cycle.
> >
> > FEAT_IOPF could be removed. IOPF manipulation can be handled in the
> > domain attachment path. A per-device refcount can be implemented. This
> > count increments with each iopf-capable domain attachment and decrements
> > with each detachment. PCI PRI is enabled for the first iopf-capable
> > domain and disabled when the last one is removed. Probably we can also
> > solve the PF/VF sharing PRI issue.
> 
> Here is what I have so far, if you send me a patch for vt-d to move
> FEAT_IOPF into attach as you describe above (see what I did to arm for
> example), then I can send it next cycle
> 
> https://github.com/jgunthorpe/linux/commits/iommu_no_feat/

Hey Baolu, a reminder on this, lets try for it next cycle?

Thanks,
Jason

