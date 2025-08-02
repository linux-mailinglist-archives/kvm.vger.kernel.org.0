Return-Path: <kvm+bounces-53871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC4CB18F2F
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 17:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF680189C867
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 15:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724BD2475CF;
	Sat,  2 Aug 2025 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nNDm7oJ1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F4220E00B;
	Sat,  2 Aug 2025 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754147904; cv=fail; b=kcdbCFUMFR+fzfr3NhTM83YGEqzXQhLcXxhe+Ho0bbWYdTUCyiTgXLMPGbl65oL0qhhMP4Rr2AewafYl0BkN+Wl8T5rtXw0iR8C9NUbWrP0Oi/t9LKa6p3U8mG0S2B9ANkbmdqhKMhAfEQJjvgzb7+e+KXs2BevysY0pMNmCzj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754147904; c=relaxed/simple;
	bh=9EOVCzeRQAuDotY7+MedyDr6n1ixhnXJ9J13lTVJKrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QD0X6/Iq+ACroGk/TL7qMhcdlXSDGGpNxL0PT7HMsDvy8BFf6akLbf38VUu2mA/OeHzsdUYBaT7hi3iEGyxLqxNtyO7gbkdYVpnk7DKibC51a6E0I8oBivodoYqXt6YUu3ibDeq5evbngH7ZyA9wPKo2BUlt+Hfmy2BvZm6bemc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nNDm7oJ1; arc=fail smtp.client-ip=40.107.212.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sg5Sc43xM6onJ8Viju8gEn0cAbqjcJSnvNSwbhA30/fTs8AHgevjd/p92hHrSlHeIKWddREAZ4PCMboGqXnc8mZ4JYox4slH7r4NGrR5XBDTXobTw9gkA1lOc9YKjk9DgZmfeyp/2mJ4orBzjGYgPqSYLHvYSwT2kD7cmiTz04DuFzsxBMlk0JcOMQAoLBmDSUlCqO1HBam1tbKLnC9h2Z4OYlUDhO48iHlbbANk39JLgeF+Wg8Tz0sjL/90c1CSLHavGs/ysoRRrdaG715zRwZSus8bjvU4Am5NwP744zDfC1d3LlCzIjX3p8w8R95TdrUOTU1thXIkJMYcuk8LnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PhmBpuuuTMf8cw8s3e3J6O6LmTe9sVfraQkfb8AiwN8=;
 b=RUVRZl4tjTrLZUJMiSabM/CR+CgVKjz92as1tlHvWOGcdhFoTc3hQKHobYJyHgApgR5VgInDf5hPGqBDRUGf2v1ZCIzyCVxMN5eolaEuJtVqqp5AniH5jVWCvvyBylGm3Y9av/IgxSIv2aGsxv94L+u25vNMjoejSTZTRfMckD50erhFG0R09vs72sVcqmdG1AtTGxNx0EuS9YMhObEBRnWQXKe8utS67YHUxb0TdnwxVAWY+kajqpMOFFPLp3Tl27MyRIxoaz0wvZghFD1Y5L2ZErnkUzY45WPvz8PRfn6cA/zJbAgiEtAh+mSR5cTrCh0rdWt7hugCfJiqjRzDrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhmBpuuuTMf8cw8s3e3J6O6LmTe9sVfraQkfb8AiwN8=;
 b=nNDm7oJ1CMjvjq7Ouf+IOb8AVYjOKHLiooMcP4pXHXscesptra+XtVAA6/V8oF5pmsiF39QU+rt+7fLl1QF/Z1dIS3ptcSrOc2/VKZVVv2gcjTVd+esqi/puaFs9R4mG03Oz7xfMJGRCIfd4gIGsp2opZBGgdz1793vVYNDtEao9bm5ZbpOeQ+77MEM3A5Yy72qZezTpYyKMcbFm7wjhF7IlvR34Y0O8uwxp/8gY2eLmMZI8umJm1BVvD+ZAXM2Oj74/mR4u/GzmqIE/sH4DUTHWLvtBFMwFfqrWEvbpcQ8Adk5zDWZw/fenS3tmXShZIFDyqa7gLcEbO6c7kT6/aA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB7640.namprd12.prod.outlook.com (2603:10b6:208:424::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Sat, 2 Aug
 2025 15:18:18 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8989.011; Sat, 2 Aug 2025
 15:18:17 +0000
Date: Sat, 2 Aug 2025 12:18:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ethan Zhao <etzhao1900@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250802151816.GC184255@nvidia.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
X-ClientProxiedBy: YT3PR01CA0099.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB7640:EE_
X-MS-Office365-Filtering-Correlation-Id: 27c06469-ef9c-47d0-69a4-08ddd1d7ceeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1SSsbb8ZOZQJOaiy4h1BxtA8gAOh09HoSozwytbOvpAsifsER3f4rGEyYFgM?=
 =?us-ascii?Q?7qg7outHteGPGWd0z3BQOE+OJhU5dlai8diHiNwmy3zCFCaluESWg5FPNofL?=
 =?us-ascii?Q?+Mcqhj2vZZbkHt7aHxzRi0Wz0IVIIASFss0w2RYGB9mHXo5IVG8IdE10mcns?=
 =?us-ascii?Q?M3EbZlgNFXNwxvnuK6WtBpqsE194qyWBw1Hfrc0wXg8+4EHCMeHTzHrFscSr?=
 =?us-ascii?Q?jCVgmYOncP7tu8lt1SwHeAPKHHpkD5bpPNRjiIPQXQPn1mDLS5lz5i7/kBhr?=
 =?us-ascii?Q?5RwS0zBkWKvlygPhlrn2naGOxdIAO9L1w23I5y5/D0wmr9bkdNflgaocRWbd?=
 =?us-ascii?Q?sKUvWhof0yexWZgKmRRuRMM5trXbQUME4oe1wNNqtiUvWOsXrmCF0t/e3C4D?=
 =?us-ascii?Q?3EdE+1145v6JPmV4hn2uqN66UpDk1xrzXBdJYIdnAuDxYd9lnRXwHlKCrNc3?=
 =?us-ascii?Q?epDkFa8WZtc18j7nmXTdGI4d9InKe1xbF48uBFK+oKbx9BXEs0RePZexq6RL?=
 =?us-ascii?Q?CJOXYx+8nTIdHBxAQk2+AtWbB3sqyJpJK9I0XqXfftgkyL2W45h5LlX81RbB?=
 =?us-ascii?Q?Y2KWXFFBY8XKQD9f/v7rb3GYl0Vtt7r63d17aLGPIhOjhW6/LTWrtslzfaeQ?=
 =?us-ascii?Q?uCv17XYSkEDyvYTJ8T5ZO4L0Ot/AlypVJ1h1yzuknVxkY8+WICMPlBsg8FGg?=
 =?us-ascii?Q?qAFdIEOkrYY3pDbeZ/XPBeN9RgdWOjfsXev+xBOmgBwIjZRMBL+KJt7rjwIH?=
 =?us-ascii?Q?x1YtCzFzEqplSRRJVsKOHARiu9x1M1QXFXoQtu/bqo2M/dQm1TZYa1WiaTfb?=
 =?us-ascii?Q?WX3+4XE1gGXQTwSgYCUd4jtIfQpfhDwo1uY9mmiAcZyB0XjTcH6HDY6fxzta?=
 =?us-ascii?Q?CNanJg6EToHMTn0g0UzIgmh7E2QA8KaI19KwtmHkHzzBYG6kkg8qjF1YK3+u?=
 =?us-ascii?Q?G6ynrT6Z5ihNIVx5NTeQlf67bpC0kKG/iDSoQRqotPUn4tQMJwt3j26TcTWZ?=
 =?us-ascii?Q?mq32g8p+FGyG6evd2rdayOXjLGMVoE0C4NO1azGoJ84Vg+GmobkqxJTcdJO6?=
 =?us-ascii?Q?8Ro+G/zj6Or9QWMdmrQVONCPfreUisZPGVoFG5ULsgoh1yRCaPpC2rIMjGG9?=
 =?us-ascii?Q?3uDNzPYyzlifdx1nuhlKDzp/jXT9JYxa2O1ZFmGC+ayC5gItaLIud9bOQsIj?=
 =?us-ascii?Q?/J/ZNTMGzTVIKBBr4Mm6DAtc5aMCnOPsOQuDCJdRF4w37IAKDxgWCfUnNPza?=
 =?us-ascii?Q?cqrmOqtbbMWjVtIGGcEF8TAiHKk05Uwry/p5N+/8AjLN5Y7teHUkeeZgFGgS?=
 =?us-ascii?Q?SG01HXITCzNSJGIyVlY/+a8btaPkHiFSvclvlvxk1cB3CLqZQZo61DymPR4b?=
 =?us-ascii?Q?zxvuv8EYWOjDc7OiHPo6YEFNso6u3nzJ12Um/QrJ9D66JOOBjQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zfd2qdYs39ZpXo4ArAppSU0tqXLBhf0dB6KSPhMHFHO0plNiSTM5+FlCZ34f?=
 =?us-ascii?Q?b/N1KzmIqppCozx/Qw/A0hjI6H/5QaI8pDCptfLdetr+8XYzbd+RvBcNP2AY?=
 =?us-ascii?Q?cvWLhyIFsk9O3XVbT8AqttPjJB3uFWCYTpHsupzp0T5iwqRSb6JUqMGQm8g2?=
 =?us-ascii?Q?myZIlPf42clVfHg7BWr7pp+FGLv5buTXAhHwLTg37Cg15+20pXnZ7h3tuMKz?=
 =?us-ascii?Q?2drjvgUEqzE0IG0aZQsSr+Q+7XP634VpJNPx4d6pDSfRaT4W9S/n7mSu3IgW?=
 =?us-ascii?Q?26kimrOl0iKPPxr+FtJEeBCIy8pTxNLn3FFC50kLvLBdqoD+HmYN7RYLy1a6?=
 =?us-ascii?Q?rNx0Ve/sLLTBu2ABi/RgGb+cxZH4gUuY8OHkPryvX/MOfFUS5eFHizQtog9+?=
 =?us-ascii?Q?4VwWvm5SFMAayNfYnaAnLv54Gbb94JfnC+TtA/WIzBVM94IH7QlzTzJylPAw?=
 =?us-ascii?Q?wtJjJ5DS94oopBH/pcluMr58PIchcjcZqQd2pffPBJQrgwu2X7Gb0lE4na7l?=
 =?us-ascii?Q?Mkt/hUbXgFPgKg6x1oEheRkC/YU6hwdHlbgJk4CmOfdZJLB02Um+30yDySK4?=
 =?us-ascii?Q?Dm2w0PbTrxiUA90a1uR+hsmxX6gVW1KFYUO5qayqcMNG9Aa/kcuNKABtsyqg?=
 =?us-ascii?Q?JszbilPJP9p/GkiNUk6oqV5yx/BBqpUGi1lkVu4NTRJhB+VWVuLvpWd0jiYY?=
 =?us-ascii?Q?QLn1qaxDC0xeBHp5e7q/oa8u/an1w+NbEZgtHO0PyZEh0atOnmoG6IXxEMhG?=
 =?us-ascii?Q?HdXjrT2hx9b07VudD6yQS9axZRMJ34zbcXnMoT8AZMcvV3guGUQ75KhLsrkZ?=
 =?us-ascii?Q?Xau0VpgMVYMYKgqHUxyLpQhHeJuseMtvM5zmnYqg6rX7mQJ2gN88VLlxg49Q?=
 =?us-ascii?Q?CV4fMuBieX9qe3kRU2IFJB6S/rTvElTLQJHPeYY7o7ketCXN2X6atsMlbobX?=
 =?us-ascii?Q?TaRBvmuthHPQJRYjqidwVMWegTycpqXcsxarcccGLsvVuNVr4oVCJO2HNAON?=
 =?us-ascii?Q?bpbs+ZNp3cAw5JftB5wCEgccH4lLIdtrFdJ4/ezIFPcXeXwvzQDAxY/AFSia?=
 =?us-ascii?Q?Waplo24E9lxxSPnMGQq2ErQMIwo/Bk0E+ZBsqeHLyu77pz9X6nRzWHaVLjoh?=
 =?us-ascii?Q?PjGMYxZGGpW+sZu64aXVtDIBRMtyuPG9PL8NOMBqYWiL9lf8JegGqxssfNBT?=
 =?us-ascii?Q?IHPPUMDoufOAp8vBb34v0pBppFAlCrxmHS3FIuhdZIRThzY4QG2SsewAlLy3?=
 =?us-ascii?Q?FIqLVUluXQeYV9Prq59Mxe4uZlAcinaCdxFWM9N3PF9UeXfRa5KXGo3KZjqf?=
 =?us-ascii?Q?iHCPMeyZfRTks5tJgiIkhpG2KaJacINiSxHGgeN3drKrouWYHFc416hxiQwB?=
 =?us-ascii?Q?o68b2CvrvIA+OyUzo6B6JBpk6WSk0U39WEn27mZHHXBiOy3zy9oTRqgI3GnL?=
 =?us-ascii?Q?gfaojeCFXKH8UAIloze8CjNSH7YCI+XVYfOy3w2ZUB9iewaGSv2Z3jtz31Rl?=
 =?us-ascii?Q?XM0vobOrPd1c+C7Cszr1yqcLAcoEQfQhf39hUIBsTqilpM56PFIbTJGuKpCH?=
 =?us-ascii?Q?Aid0caZf5xXQDe5gzGk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c06469-ef9c-47d0-69a4-08ddd1d7ceeb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2025 15:18:17.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWNxN8roxtlsMPSI7IaKYOU42XnjplVVc809vWFgS5OmHBa3Tmp+bZMjoU23q4HN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7640

On Sat, Aug 02, 2025 at 09:45:08AM +0800, Ethan Zhao wrote:
> 
> 
> On 7/9/2025 10:52 PM, Jason Gunthorpe wrote:
> > The series patches have extensive descriptions as to the problem and
> > solution, but in short the ACS flags are not analyzed according to the
> > spec to form the iommu_groups that VFIO is expecting for security.
> > 
> > ACS is an egress control only. For a path the ACS flags on each hop only
> > effect what other devices the TLP is allowed to reach. It does not prevent
> > other devices from reaching into this path.

> Perhaps I was a little confused here, the egress control vector on the

Linux does not support egress control vector. Enabling that is a
different project and we would indeed need to introduce different
logic.

Jason

