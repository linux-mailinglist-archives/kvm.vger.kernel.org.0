Return-Path: <kvm+bounces-33423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 397B49EB2F6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:18:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ACFB284418
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0851A9B3F;
	Tue, 10 Dec 2024 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o64keJIv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472C023DE86;
	Tue, 10 Dec 2024 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733840293; cv=fail; b=lKh15r5Sw9+hdB8DMEKt/CvWGFjcGrJIt7n0j7BQt9zcTtep7zVeVEt78gTGrNmbTz8tfCaZ4UE+2J5Sl/1kpAWSVAMHB3d1/Bx/g3P/L+RNTrhGni7GfoF0w03qtOWZgf0AlxRhZUrlcyeUMzKQHve0h2GbjEZ6xi+81ruqh4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733840293; c=relaxed/simple;
	bh=9b3WG1zCy3WjYBQcC3e7p5oQpq3Yk8UIBjLrsHqSt+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IhWPTPnhkIBqv1RwJbR4mlElc2q0qO/Ss9Gq+LCXzPMf7oVuJtzXOpi8RS91TFlq9Ps2fq3U8G1W5khw1DDg8cMYa3+91xkcCvRX7qyQ9F6dPtuERkwyRE2LmoQfqhzTeBmN8qJgErEfq8bkHukEBfxFeYZZmY5pdKL0yUN2gRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o64keJIv; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Npkht0ngNm3CKy9B8l4ECXf3frlwg6C2V3MDAFSN/VlBPxysLQuHeuouezVVv9wQN0Jiz/B0+9iU74AlbJW/cUuNtrxTX1dwu6mGnAA1RTs2OaRXzsuaJvv4x2fb3g95E0zYKZuF5EKgpdif63OHu39VLgFht+4CGBJLOD+bag3bpCr+SR6kciXYWv3GyhXWXCCmMqT8Nc0AXalSgH/RXE9W6Ws86d0vDgYDsM+QF6csKecz4cWodEvbFv7WkZoWLJvrKc3n3hHTTR8xktCu+ox1+dUYxNCywLx8hHQOR3fS+k0ciU49uYT8An+qEn+csNjBcHB/tH7KdXXhnZwtyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKiVCfGIPAGhmL4JLlI7UkbxVYsotBE0UKaH1ZtXpEU=;
 b=QDX2zV7JyoW/j5Xwoa2Cv7LiQzVV/3xuR4WjFTxR7aZ0k4XnQIRkIsNmLVWC5QuHf76+gV+QdxCf9J7nN2jo7Q1FajyjlkO5d/VvMCkeFX3qW10RNQU1XDpbNBuhhorkiNUeQkp2gTwqWECHmCPumu724eUK8O9PuyLIEz8sKYMBt+1PPGAaWckBgtMzdLcyqnAniHTv46oRqN8EWy8sAo5IcVZdkfTEhmdFqRMjDtdgLEo9P8EtEr2DmhoLuCAs/urwPQGzSPf6K8b0atdnINUNP/R7csETqMoysHvAbvxeHf64MWf3D5houndDRxjX4auHM27AsfRSI5Lj+bzmfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKiVCfGIPAGhmL4JLlI7UkbxVYsotBE0UKaH1ZtXpEU=;
 b=o64keJIvqVaCAhdS3UcT+6LZi0nSz0HsVg3noFLIbKO/2N7ucID7HeDL/Xy0q0iii7CT+Ag9iW2twr71dyCN/WvIFAJrYqbue4Xy4GDStDIfbpAe3caOcIsoNEBYusf22SuEFvAHmPH4rYe9JOkQ3mVuXZcHYlIx60h7Y0PrvDqhaVkp+5tgINwi47GLTah6eln/xIuWOD29JpDE2VzDg9XRnL8hE1uQx8dLm8gjBekOYJI10jk5bL4sB+4yPNXXj9DzjuAw0gUNrMoCKjR/TJwJ1fKwBSkOEEp0adNA9GaFSiNDttWs1MS8F4+rfy8ggwQZFNHu+Te6wWCx6vlvvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 10 Dec
 2024 14:18:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 14:18:08 +0000
Date: Tue, 10 Dec 2024 10:18:06 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Message-ID: <20241210141806.GI2347147@nvidia.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241210140739.GC15607@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210140739.GC15607@willie-the-truck>
X-ClientProxiedBy: BN9P223CA0020.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d7bcc32-a9e9-4b37-7747-08dd19257884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4PS/ENpRRXNMCPIqqal4Mk0RUBpxy294zFxse9hjeXsMsHfGvA8twrClTb2T?=
 =?us-ascii?Q?3yNxCOjkwDWHwdCrKSM6bJCEwcXNMDIHFMZOImIqun39P6xBqsdTj2E8pPpT?=
 =?us-ascii?Q?P36NUHKCpzn8IuMzCPgMj5gBl/6wVAdz5WfefGSPQXaZ9e8P9TfGskOJ+Wv5?=
 =?us-ascii?Q?iU0zQyeOGm2MImdqIQyEsIRxG7ltPfnT0pmHKT0tT3ePjA/TPQK4N8sTbuvj?=
 =?us-ascii?Q?WuvCdBgOcK5GY52Z8TSJF81cWqiA+Amqpl2Zg2Cpdhvn98ukDYM3MMCFSEor?=
 =?us-ascii?Q?tIKP6zAxH0BBgj+cCnEfeMu9epBaVZd2eUNUqA7z3poqXduIQEifPjx+CinL?=
 =?us-ascii?Q?uPTBOQYgrkVFJF/H3ONCt6SBpTcen2UGM7KZIj7Zdgb/xbcypy4ns9MTXaff?=
 =?us-ascii?Q?THtXpkbovUgjPo7JWorjGAuxs47GM9AJsaGvGvaBEPEVYPo86lcRmys6CT0r?=
 =?us-ascii?Q?ryEJyP7xEFSqlp/lQC0JbWsnx642FyZsIGm4thwjo3MS/mQmYwrjeUfOBWo0?=
 =?us-ascii?Q?UOeyDqW1MY2uUGz4HJy0Ro5J+MAAUJzWB7K2L7bKV3e9DCElsA1Ee4fDKPMS?=
 =?us-ascii?Q?StQFLRNmAB/WTpXu/t68g6X82uoj3vF4D57RcpuXTRgrA4hqRc6yz8FdJ3FA?=
 =?us-ascii?Q?yXeC0Rrcs1fVtsV70Bn/Fmax2BEOvyzMOPRnN5koRQjmS1A9L+SsChd1yUdO?=
 =?us-ascii?Q?1S7zoUroRe0YIRmsloXdB5yBWhzQ2BzMIwGgnauNvZ5fTM4krU281olNApxX?=
 =?us-ascii?Q?Kd3PULnBDeIRcoYx0CKzVgdJHQhtQrkIiBhj64ie69RCgYLpbRf4nywSR6gy?=
 =?us-ascii?Q?X5Zg4ZqBstNBAjBaqs+1T/GHK2f34FWbkljPiocIc3wEu6DLVU91zXJ+ymgy?=
 =?us-ascii?Q?poumK2tV0blYzwZu/LcLFDGvVzzkEAHziFW0ny9NRMG3xwxivqePNtxo++Jk?=
 =?us-ascii?Q?/4jrkgmeupYS8jijAc5HJ8Rd7uLuXTWnDXTP4rOh6ZXvpTjz5Oh06uRrGlIq?=
 =?us-ascii?Q?9PQSKeKVm2dbZus9a1OE6/0p/tmhhOlNeTs2cnxy4ZtgghFHiGVGptba43Pc?=
 =?us-ascii?Q?EDUQGtqe9RCVdUfkABVQrDSF5FOK1tNQBJzpoDYmZ8khCuwim5TvfERq0zIH?=
 =?us-ascii?Q?oDoJ/8dJp43QDusiPKr7yqUbO1Z5PexmVL3283AIhxE2dOpbEPQsjN4pfPeO?=
 =?us-ascii?Q?Lw9HGHWcLhYdrHeRYzTvL1sg4EPVQSkZKXZFjQ3FUFpjvbcwY086gXCWgrB/?=
 =?us-ascii?Q?pE4GWN+IlMb1rXTEI2VaDxi8+h8m6r1iS9q25j7pevNr2jR0zzw7sVrY8TDT?=
 =?us-ascii?Q?EHBfGur41V+fKy89Lv4FZOIf05xV7edZVb+Gtz0hGspB+Us+TAuOcCqealZy?=
 =?us-ascii?Q?VldpsBA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eibW1OTnzZNRVa8OhzUibVDYbWkjj0OvvKKsCGPZvbQMq8yMFm8u4r9JIY0T?=
 =?us-ascii?Q?P9mrRc1+kOeOhWI9fw5/C3MbitWqqVu6PTxHwTFaPNy6LBsSxQl/ce/jpAt+?=
 =?us-ascii?Q?88RNOrx9DuZ3NiXVREk0b0Pb11MHIjKhs/1lFyUkGlHE/MCelbXHKHuimK7S?=
 =?us-ascii?Q?G+JgLW0vKsDOt9ag4gOF2FVCDX5D/38VOfzWC+iklL/Md729h3kU3jp8db1m?=
 =?us-ascii?Q?jcPdJgxALKXnGLp/af8ukcDBhQVqulbR+PHbhH7vfK1bl3YCCVjBosOVM4Zs?=
 =?us-ascii?Q?uCkGxt0nuEIIWq2YWD0VD5GhAoFmK885ZAU1uHkvr3XoT95FwmJk5qTwU8/4?=
 =?us-ascii?Q?r1NwwWG3MMmIDohDb6ofsxL853Pe087TY0fZGlzUCnLsmuuLWnmVR1Q6pi8W?=
 =?us-ascii?Q?YkmhCZMug1a0nwk5p9bydDcXEkflQA/3iJ7LYjAsgM9v4F8ixe6VHE9i33At?=
 =?us-ascii?Q?d3Ob5VX3soYCUAbLY8SH5emu3r4UzCYVQMJJaJynd4iOoDq4zsR/2nf1ftSB?=
 =?us-ascii?Q?3oiE3mlITBV4nyBS6uzuSMFRvTTzCPF9VxzJlz4zkaL1mC53yeDnQsM7h5gG?=
 =?us-ascii?Q?QZUAds79Zj30EfH8eD79Ayb9wZNNahG889D13h1KZX4rP9NXrF1TYPTADwx0?=
 =?us-ascii?Q?t+qoKSWYAfIUmCyKWeXYkr1QlVxBoAQPm9NHQayF/3ab0cXFrPSXiSYJjlxw?=
 =?us-ascii?Q?HRB/ZbUP/ql0KNibVdlR/x7PHfhP+FZ6HilZHs5iwRtDgomXHL8X/cwkcp4n?=
 =?us-ascii?Q?2jpDKDeZgD8GRS6aVk0sgvX0pAjsIdIoEy84L9BO89mt6U/cV8rm64kJz7QT?=
 =?us-ascii?Q?/gr4imxBeeLPIzxNy76L/LvLBXV5+4pINghwTfw5raKbiPdL+Uhab8Eut2r4?=
 =?us-ascii?Q?0aNlvCf47R7ioKY0BRWSa5rTpTbkm2LwHAmbQSp7KULWPc5sXRxoPIVZPg8x?=
 =?us-ascii?Q?rsDEm2KCtWGrBqZ5DwM5C7lrVdUuPnnf/VFN7iWUhDP5mI9J6bjh5dJgt7pL?=
 =?us-ascii?Q?hJ+4+a2mNKVgTQfYT+8x1c8V6K8SHdsQZQZIBm0AxheGHc4s2JS/V2rwR6N+?=
 =?us-ascii?Q?PFTAH52mlj2La2jpqSgKZTYVq7D3CRufokJlYPpSilKGEd1nPYB5xSTMMdnv?=
 =?us-ascii?Q?Cglb3vQwKzDekJgvL8wCx6yJPo3hW8Xbo+ZvzsFu0JHuA9sWisrhuy1kvrLB?=
 =?us-ascii?Q?/jSKWOuuYyhb6BR9DXOt1CwnyLuvnwXBGCw51izc3QjwpPVy9JT3lznSk1RA?=
 =?us-ascii?Q?m2pH5pgTFtGSkkvQ+i2iOOFuDTUC26PAP6a9dE9gD8/HpAT4ZchW+NTw/PSO?=
 =?us-ascii?Q?1ruG1fQ8ToNXGNSihdgkuGe5Lu12zczgPRgxk7sc1lSV5DW5QPkfST3FprB1?=
 =?us-ascii?Q?tp8pGlsl/Etcw3loiUQzyhwcMV31C7VS5kuteyG675bQEKRYwk9iY32uplcv?=
 =?us-ascii?Q?2Z3yXC1y+zE6ZEl5aH+XVb/x4HoA1hYrXkc8wIO0HfHj9rB6h3K7o6B45Dnv?=
 =?us-ascii?Q?gjvspwYPY8RWzkaY61phvDDl3UV64ADC8TUmpKzc2NvWYzbCrKBfTprskC0D?=
 =?us-ascii?Q?KFs4yJ0VCmhLg/9P5KCuTxtxMA+DVX+QeFuoSDtd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7bcc32-a9e9-4b37-7747-08dd19257884
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 14:18:08.5174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +98Nje+IwCKP6wTKWk6wdpculf1mcOxX6crIVNhB22nWrz6N/miRBJcmU+h0qcjX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154

On Tue, Dec 10, 2024 at 02:07:40PM +0000, Will Deacon wrote:
> On Mon, Nov 18, 2024 at 01:19:57PM +0000, ankita@nvidia.com wrote:
> > The changes are heavily influenced by the insightful discussions between
> > Catalin Marinas and Jason Gunthorpe [1] on v1. Many thanks for their
> > valuable suggestions.
> > 
> > Link: https://lore.kernel.org/lkml/20230907181459.18145-2-ankita@nvidia.com [1]
> 
> That's a different series, no? It got merged at v9:

I was confused by this too. v1 of that series included this patch, as
that series went along it became focused only on enabling WC
(Normal-NC) in a VM for device MMIO and this patch for device cachable
memory was dropped off.

There are two related things:
 1) Device MMIO memory should be able to be Normal-NC in a VM. Already
    merged
 2) Device Cachable memory (ie CXL and pre-CXL coherently attached
    memory) should be Normal Cachable in a VM, even if it doesn't have
    struct page/etc. (this patch)

IIRC this part was dropped off because of the MTE complexity that
Catalin raised.

Jason

