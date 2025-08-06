Return-Path: <kvm+bounces-54113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3C8B1C6EE
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 15:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 730535627B6
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 13:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5E628C2BE;
	Wed,  6 Aug 2025 13:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="inDUSm7O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28152289369;
	Wed,  6 Aug 2025 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754487615; cv=fail; b=RJQpR/kk8hT5Hoh3YLpo0K31t7u/QnNO1IYLLgDD4wxQUldTqKSE78Bh9fFkp+YePbRlC7KSTVU21Nvhl8rBjnX7++Y/oOXVguRBC8xGqRTc6CDG1oE8cymzDWDJdMh0B4S9wcLP7BnPnzNOiqw3upRZQujCmT0+pp95Wy5hvls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754487615; c=relaxed/simple;
	bh=vfmD/tYI0lAGO9EJARRfMxQWJJg2tm4lyWsQuS8Yp+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nPpfpwY1/t24QLE1WHZeX/W41Gh2K8elFYL1T0b5y9FFBMY3oxnaAEBo7huWILYmyP9LcKy/9FWlut2BdhSfKSAxOKH5yjnf61aFrjH5DUAaox3d5rbt9MfuTkaPnPJpHnLzqtQ+5Dzefrcy4/rgLzq9L4q5K+R6Z8YEKfqlF+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=inDUSm7O; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HMwTQHG9p1BqiwiksV8gsOtiRfwOTbHVnzMCqQwQeRDAAJ5s8cESoTp8p6PXmiBuvoukOL9jE3L2f6jJNovSUJGjg71LEbj50ZFIDKRLzipzC75orABUcuGJwcXIBbyYcrqSS8LHIclJZEFcHUkOsLaYOzTUAbJTs4MRXMRgjR61HgUqDQFy/4YMdEntGe3TWNXHwZsxFVzKnsnxY3+kFCu3l2NuIi4ViEjjfYzTM9o3IvH9SSwEZpgDACXj1xSen8YqGO8Cu+WUB3hTWMBtgdYVYxddihdByvvp9Mnts8iEukhZe5ByXBimp5e6vdJheKFf5B5gp2byt/st1BPEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82SJzRHwCoJDCbO7Z7gMwE3isZnLUfYFJc1EDvCpXlE=;
 b=WBX43xL/8bPhF2+2CfUXhh2mZQV8HPeaFbH7ihbW4EixqXNjMUhbrlNMUcpFyPzai6IwxurnaDdK264ACFUYDeTRmIes6D/3oNl6+/flLx4lXDe0wJaaOOYg+mxG7bimMRlJi3UaPG4c4Tui8QG6lg7qbhqnwbXBtw9PPJ2KiRRJMcBx7Kx2544gIPk8XLaLUpIOT68PulqcCA3GCXKHTr0PWkxnF7z8JgZfRNey8b40bP5YZfKMnH0MjsYJz4lkpLuFOhImGU4Df+wTIj0Zw/o87TkycdlhLAATEJQ5ASHzZ4JWofkcdlseYLQ6fG/dNEJ5R7JW5axmga+0Fn0UEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82SJzRHwCoJDCbO7Z7gMwE3isZnLUfYFJc1EDvCpXlE=;
 b=inDUSm7Oc/JYo/CVZx0HJYZChQkUBjLgWZjlJ06zXjkKwWNYVT5Krt82RmVHL1Zm3NyOgNd+AEnklYoFy2aoDWpW0NKXM0qcA2YrxbMt1PaVsXdx428b0KAPgHUwR5TItXQlZwY5wpJ1BEhkVccj9uREnKT+lubN6ByswrFgXpi7pKMlXyMa1llzHL5N8o3vj4OF937bjU6wTytuBqi6R2HYhHsUamyWyV7hrqh1Ln3/jkmvuRpdr81UTanMzJa3Mnmoag6g95up1G3QLdRKLzWkcrQBSBFiEl4RVkhzFrpLly3AQ97dU6/Igd0RAjdL9dBItleHF7dpyKCK0PROdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB6420.namprd12.prod.outlook.com (2603:10b6:510:1fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.22; Wed, 6 Aug
 2025 13:40:11 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 13:40:11 +0000
Date: Wed, 6 Aug 2025 10:40:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Ethan Zhao <etzhao1900@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250806134010.GS184255@nvidia.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
 <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
 <20250805123555.GI184255@nvidia.com>
 <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
 <20250805144301.GO184255@nvidia.com>
 <6ca56de5-01df-4636-9c6a-666ccc10b7ff@gmail.com>
 <3abaf43b-0b81-46e9-a313-0120d30541cc@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3abaf43b-0b81-46e9-a313-0120d30541cc@linux.intel.com>
X-ClientProxiedBy: YT4PR01CA0416.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB6420:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d7c3fe7-73d5-4379-c660-08ddd4eec3fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hs63DOj2hIxO2QpnmTmkSZRfNu/cEr20IdSE55b27wQAjyuvPVgly1HWTB5f?=
 =?us-ascii?Q?3nvmGd45bU/EvpjQmWuk2/2XiHwKEtoqUTV0yZKgVcNdESlWAs4PHClTzxZZ?=
 =?us-ascii?Q?xrWePtW86C6ViovIEGyA1ZT+v0Pn+5QGItza8HgDYqff1Rh/lLdDCE0ktuXX?=
 =?us-ascii?Q?w9BzySdyFJJdF7fATaovgtJO/Ppe3oM+iQdSf/1MBZgIKBUlwq+ehxWOfvL2?=
 =?us-ascii?Q?XGlTCeCOgbN9YP9r17KRg4YNLCYC5sT1nsNE/eePZzbwIoNddv0KBwpfc4nw?=
 =?us-ascii?Q?9qyyRahEhwO3Hbfw84Aq8cT6otbVeN78ggA/+B9G6W2o/B9e2p7Go8o26OvH?=
 =?us-ascii?Q?sHut8ou7RoglLEcP1iwvXlhNT26W+ZTfETvWaoWHLBSsxTkBTNABQUzwYu2E?=
 =?us-ascii?Q?JjSCAJv/z6/meeMyEJ3zs7jvkua0Hz6lUItxy1wmKMZYHwU3rnGSIDu3ZX8/?=
 =?us-ascii?Q?u5sPYLRdyZSwf1TXnaTBeSoxJWXMo+K/9CRJrbuDKw+mKCYySnGrWDyFDVV6?=
 =?us-ascii?Q?zNneWppwbzGNcBP9Xi/vUGSeOO0EXfiHolLSgAjoF9hkRLdFVB2yJDKZfD1H?=
 =?us-ascii?Q?LSOkV2KNEuIYxT8pMILW7IMreoke0J6GbGrH7Wmw8Bf+7bEjjy0RlxgYoSS7?=
 =?us-ascii?Q?wkd+6KZEmZwKTRphtnfp1Vo5K7nCrknUSXf/ChjEDQ06/orp6EhdI0lG5pm6?=
 =?us-ascii?Q?A+ivnlqb60jl2E6u7xx2ehrFfL/VRqTxEPp/OUiQlDb1JbZ01tzj05bL9Tpf?=
 =?us-ascii?Q?vwcxk9+lmiIFeTzTK5i7kcUJ03S850lmHCTw1PsLBdjCt+mVrMjy6cIHJV0b?=
 =?us-ascii?Q?AvFXJammKH/jVAc5MlJOmUj7kQ5VwvNTqKTGkN0o5sLaMJjxICXt8oCw2JQ1?=
 =?us-ascii?Q?uqUwlBvUVuE1jZbh/4aCGyx0aZfj05jwALjht9LNOQDJR6zKChtlLdyy6Q6p?=
 =?us-ascii?Q?FhD17TWwI3FqK+hQiMWrmuVHCdTCoLGj5uNVpNQVI7vjXZeaBc2PQ1cNNHgs?=
 =?us-ascii?Q?3EOCWivGlXJIsw3YtmqaJ4ia+P9ybC4k9gaC16XMANov/zDhs7JkV/62y2j5?=
 =?us-ascii?Q?CdX/f6AX4r2e3AFFUBJPl/t6n+wnFa8o9u7TW69kkb1+BNfbnFX5wMInqF8U?=
 =?us-ascii?Q?wO9g+VumPs39VHXm7pgZXt37w39ey9yVY5rS5CABsELS9FbdmiYmrvOMAvQG?=
 =?us-ascii?Q?veNmq9Cyw5Np/T76kbJRhASYY5rBM3n4oRrwTHu4Nrf7sh6mzxRGcM3Gc7iO?=
 =?us-ascii?Q?ImwMep1iLjcPont0dLLfvoTAOx9Q/I1ds3v/LDVtdtkdBIEjlmJnGRMo64Rj?=
 =?us-ascii?Q?+pa4P774zZwsaD7rFAwAkIizP085mtOw12TzEpfOOY0Pc8JgKlpU7Vj41tGt?=
 =?us-ascii?Q?fEmaUpjzvC+UZX3Vido+VaKU0PlHzMLuly7FCQoPCkDZZ3CSnjFk4iZEuiH1?=
 =?us-ascii?Q?8HXJDYgG5/A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?APBCla+zcz66x910Fl4yPQCqkbWF+yMYYVyEqzXSst+diwn51jLa3meJoLsb?=
 =?us-ascii?Q?Kr6V0UYZ+DIXN6o8/zIQnZNsor14YmTKjAN6CZUNlVQX3nvprQw4eqAc2YBQ?=
 =?us-ascii?Q?ZGAo2QfInpPtnGUu+YGPKzm4CseaqjmKmf26zHkhVjAsZxMNPdInhBZAqsmA?=
 =?us-ascii?Q?QvPmi+V7GeVtWxBVaQskw68+d4VlFWFP7OwslW1HqmrNj7SvvgiSnCRM69F3?=
 =?us-ascii?Q?gpC7IVPdsMKsbD8HE13N1n/I9QfswKOKK73zNKJ3TjnNgc2fkbQzFayLFhTH?=
 =?us-ascii?Q?UWTsjZdFJlA4f3399PmFjpa/jMoYuINhrZJLCUHgnITJHjrpaYHXDjOs4qvk?=
 =?us-ascii?Q?UYKzWKYKQe9pNbLwIXeBHm7QBzJmBBBIJhSuvuRUY5zJ9OwcJWmd13mghT4S?=
 =?us-ascii?Q?wsXeSa1EcT8OlXhfok2V/gRt+sJEwUZDd25LiF+yv42sArb/vUFTUsQXTLUY?=
 =?us-ascii?Q?R/PkuFaiXFS0MKSMnEJRE0CXce+F2XuQvvmGqSzY69Lagf24eXKMDI6WX/xD?=
 =?us-ascii?Q?ZcdERkvQjvfWRXSpyVfcSxN8KOeIIqCzTVm2MDYWSc6O5GquR0MaILpU8Cwp?=
 =?us-ascii?Q?OljNgKiZC+mIpe0UYTLCMUqy808RVZHNsBAjSERgfon0VlNDXQLlgrVUnQX+?=
 =?us-ascii?Q?rSY/yApi+Nhqs/RstLY8PsyBzlNFM/viK8ayhMerTJpZG64zyAJrPkbwTdzf?=
 =?us-ascii?Q?CW/dTZ/b0IWSVt2CHteIzZhYADXWY1y5HyaSOLZgWA1ncGRgRunRjY35u7nw?=
 =?us-ascii?Q?bzNKuNmv0kzVoKPuaVetueRutJPspA3JbzyTu+1pG19iRh0D6xYWE8YwJvvt?=
 =?us-ascii?Q?ALoHWf52HGjiN6rHqmQfjnG9yLvQGlHD72d0Ly6l4QHoHQ0dQdSIAoMCsK/e?=
 =?us-ascii?Q?jO/sQdTf44TuRgtaYrs0DR2+CxFjzEx1FdgVBOTKKgVSHd9ndOWa2FG1OdWm?=
 =?us-ascii?Q?V/MGaOqgW+cr2mOGGGIyvxibFMwZDiWaAHpFQ1WG81w72FOVf/NrdnsvU8o+?=
 =?us-ascii?Q?sgbLtH4PZT9aCosCRu2pYiH5RoJf5+oG8EaAaIMN0xuRQbrL3DnsVjq9etE8?=
 =?us-ascii?Q?pldliUprgsED+XxhKR5tTKIXuRU/rFC/ERpO07SSqHMhuY26KVanpQEn+6iU?=
 =?us-ascii?Q?7jb/QpS6pS2K5pkykRt7/7VLO+4c5kANymxmn/lBaHQWJIvvBB+QFB/k2yCC?=
 =?us-ascii?Q?AyGci8GaF+SADSiaBg5rsV1kx6c8+majgbu01jxv/YL21p492gbzyI6mVPfM?=
 =?us-ascii?Q?kHdEDxMrlaOtJRFdgv+Tmx2SjppkedSgOp8hilFje6ceEQ90FtEYkjZeQmw1?=
 =?us-ascii?Q?0zH6dvHGQQYhegOTtDNvulmuqsBkdiPg1hSHJe1nQo6k85XJy29yhZ5x/0PZ?=
 =?us-ascii?Q?x+rJ6CQuQojTxLhoajYasaUKtYu/VPNOVaCjQde0e1Rgk40lmqJou9yZbD8W?=
 =?us-ascii?Q?nNHK/+cSpJAjBK2q1gV1tuRwtUz3tsxu6iaqV2j7np+EA/g/KeXkKr/UIO1G?=
 =?us-ascii?Q?ul3eKL/v32GLfMG1SHIvQD7MzMcXRSbYDTXpQe0rv17TBUNPJfoJVeCZG48Z?=
 =?us-ascii?Q?dQ7XUxXCC0xCizlllKI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7c3fe7-73d5-4379-c660-08ddd4eec3fc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 13:40:11.3648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /RKWS/Bs4T8+OQ3a0QA2Nczo1m2Lf7zS6iioO7ar6bQY+s9WBCMXIAqXnnfA3jiG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6420

On Wed, Aug 06, 2025 at 10:41:41AM +0800, Baolu Lu wrote:
> > > Any change to ACS after boot is "not supported" - iommu groups are one
> > > time only using boot config only. If someone wants to customize ACS
> > > they need to use the new config_acs kernel parameter.
> > That would leave ACS to boot time configuration only. Linux never
> > limits tools to access(write) hardware directly even it could do that.
> > Would it be better to have interception/configure-able policy for such
> > hardware access behavior in kernel like what hypervisor does to MSR etc ?
> 
> A root user could even clear the BME or MSE bits of a device's PCIe
> configuration space, even if the device is already bound to a driver and
> operating normally. I don't think there's a mechanism to prevent that
> from happening, besides permission enforcement. I believe that the same
> applies to the ACS control.

Yes, we let the user do set_pci and they get to deal with the
resulting mess. Practically the kernel can't restructure the
iommu_groups once they are created.

Jason

