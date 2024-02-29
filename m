Return-Path: <kvm+bounces-10519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E4D86CEB6
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 233451C2104D
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42679144036;
	Thu, 29 Feb 2024 16:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OOCWDKzJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2052.outbound.protection.outlook.com [40.107.212.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695827A123;
	Thu, 29 Feb 2024 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709222769; cv=fail; b=VxS02fN9Q+2e3P+5T1uStpZ9ziYskt28m0fqAX3RJgiIWYZb1ST1fTv9M2/kc9ixk8Cgo9olw+fPdCbrkwFC1K6vyU7WySMw/FXeTus7TV0FpHk4t+4RH2BV1XjRs9QxRzv+38PSCaWJV77355+LrKaVd4NZPOMcKFJFbOSQDok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709222769; c=relaxed/simple;
	bh=2fM4v7J1sZgOCAhyQ9EsScTtsQ8KG9OuMIV+OFm52Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OG24BzWqag8gvYj9nAenGdceTt0VSqeAKBkUisLS2o6EYoOnlaSDrX6HoBaN6B7A9o/r9P2+J/e6buOdLzYRZB1KkVYRu2WcRrYqf+qDMSPcmgwJ0rt6YQf7Z37prE5zdIHJGl28Jc39ehp9TNyJJGeEPmn5W+Ix6Ar86o5v18o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OOCWDKzJ; arc=fail smtp.client-ip=40.107.212.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nlv/hV5h2Yrhy/P/ZVCTl3zCsQiakskVc5m2TblRUJmEVUgHoIC5J+woTHB5KB+gxc9dmQxqRergGZv+CFnu5NZo+kdJzXMR5YZXkF2gtv4gkAPVAjI0D3GFtCp9CkLI3DyZQHjXEXCI6sDbc+/fUTB964sVsMNrJmn1s2CA5NxCCo77S2tfto7l9EKE7lLnT3o4QjQisvJkhL+u/wOXbwtcF+HXNvmxNwhZMJlfN/GysVHirHJ9nlJ0ohgsjpt3LFDKyuCgH1TlNVW9l/bn4xCLpUmPGHBiTUpZweosDH0i5dfupbNdQGhBW3UhN/8klstOmI/UwGBVbq2zvQcbCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPEtaHNeaqdNYVmqxbyfiuyhYM0uYTXe7/udKuLFKmE=;
 b=M0pDcj6zeXwnzGiTmiFwi2c59feI+u/oZGidIaCubjuGhyM0Pn2VW/hXufif55L2q3xAbPxQY1aaEwjAzjWfZgvpVZCAzG2YYy2XWcc+wN1gIZwxNpBzpOoyeunB6k62zkS+/F7dVzdKwoC6/CFSsTStOVXXPqRe1wzL4WEgY9t35Fw8ibr6f0X+C+my8+g4LY3iX+/JI9Iz06CkfM/wFmgxT+pMSoE4gheldfw/ABWSxfeLV+fOAgSF6PGeZr+KFT+p7wNjw/3Dds76Reajyr6+tgqyOfmYETjz4V7Av0INaSC0jq3siyaFNp37Bet6gOHy7D8OaeMzC7G8PBxWDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPEtaHNeaqdNYVmqxbyfiuyhYM0uYTXe7/udKuLFKmE=;
 b=OOCWDKzJvCWcsAxbY0SasJ5OVSz7YZQsIYF/iBmCtwWnEbWj20DkT/wr+O7IGIvrDVpA3+4iXo2jcH5SHQSGTwuVFMeCqB8WPztGKGbrccuOi3CMoHJmvtT9evlPySaoi1orBgnZO1M74MxcD6TgklSxz2Lrx3Gqu9Yhbi1fsnf0wPEch/OTKFswNXfmVifDFpIRRV+x1tWFvOmO+zO7iihbhTRsVonUearkycG5WdAcnsoIF6k75bEHOOpKXxE6j1FndMaO7WTItPrLB1TS3cVzrFFG98dyeFQXA1evScEY4Cob5LYUED/xuRv64oPn543fidUFYwoBU5Ar0La/Ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB7297.namprd12.prod.outlook.com (2603:10b6:806:2ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 16:06:02 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 16:06:02 +0000
Date: Thu, 29 Feb 2024 12:06:00 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ankita@nvidia.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	rrameshbabu@nvidia.com, zhiw@nvidia.com, anuaggarwal@nvidia.com,
	mochs@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] vfio/nvgrace-gpu: Convey kvm that the device is
 wc safe
Message-ID: <20240229160600.GJ9179@nvidia.com>
References: <20240228194801.2299-1-ankita@nvidia.com>
 <20240229085639.484b920c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229085639.484b920c.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:208:32f::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b65c381-4896-4722-0a6c-08dc3940534d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nrjj6MxtoPIENPKr1jGmgMmrYsMQ/vLtMxmgfjjwSfDb09TxVguc87t1PzOZViu5ej+jFmzTLiBsWzY9iusC6AIwoFhdTdCOcajdE2SNcgrr42kx8DXgNuH6eDjq8utrcc96wp57VOxkG5e818u68lE/d3/DiRbn4CT2Q0PcLoNMU4FgK4vY8vsIOsGtLXq5s1y76LEQCxoSmtux5dXCPeuCa9OfzNJISSmVe7N5WjAPLgmxwRuS77Q8KceQ2LKX8YftEFqRNlh3I4H50l7d7TxnB0sk6T1sLA6/No2HyrIchODtdiVNAx8c8+2iwnp5Tj3In5apNDRuIBvpMUDSjIAGow0wFLdrFSOiobTkNquKMWLmP7Di3aLdY3wXmnDqsmW0gafET4GID7gt5qnoLp8oLbai6n1UNUElON2AWFGM3sEGWE30VHwbgAhnT4EhNLZrYNJf+5wp4llcMmncnLB5Oc1vVnW2UjjKxCMbe6ERFU5CbRyiN4R27StIu6lZBuwFr/Xje/kaNUneSexJLf9jur1EEE4XA2+ENFfHvDjW0TSS+L42th6+CeBMcuL050IIAgKw90N7xEAxta4WHOgAMoN8rFIYAKn6T8VbYqFitf+wXtijak3wqk6nlVZRAvLzgtzenIhUQqa5W64Zgw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bUyt6VaAggAnLm9sx7M3oqF10iyVmWYKFF/04bhBGYG+Ch/JNxzoJYdzuejn?=
 =?us-ascii?Q?lW6FwV+gf1O0u1cUFJq91Y7UhVJw3qBI3XhrzIu6Lt0/PPEDJNIDCVW4igGG?=
 =?us-ascii?Q?ecMl+VkWHiF8ncRdX56fGG5JT1kf8d4HRI1EMAhPt3WBRuy+VKXWtpvV98sT?=
 =?us-ascii?Q?JQOLoLtBvgL6jBGClS1Bp5lxNIjVIp6iTTXHmM0B9ZLZcVzBMv/u9xLcAROZ?=
 =?us-ascii?Q?r66i4csE3eiBHh4ddSiyepkADXpFpy5na1It3GMWotpWSytERoXztloKBQPl?=
 =?us-ascii?Q?6HjmtyMfH/5zLQ1osB+iJKG01LE6vejCd1+vMiUy54ktAWXMGXisO+nvs3gn?=
 =?us-ascii?Q?SMb34Z4KSaMEfsR93AdzFLZgvxsmIWRhpOPJ4NxJLRDp2YESbUxsrk8DXoCA?=
 =?us-ascii?Q?jEdBwzNT2eZ/7Uv7MaBC/94Q9fNnDdHR6yA59FzzPFhzkjVkQy/1skNeqwU2?=
 =?us-ascii?Q?TEuFj4bv+ZuqTn9AB6/0Zxa94aqLjbeDftZW9fH6KQdOaX3IQTHgvZ0ijD/s?=
 =?us-ascii?Q?+ARZtuTvu8g4y+MYbcHvanEfdMpEMZkygrDg8r43S4W7QxO4mjwYYWUuzjeU?=
 =?us-ascii?Q?oUNdtjw5287y9dihfeW8a1ieTjj9cQ+xoRuvIJ5585qrYGa+9YGkLi4gsR5J?=
 =?us-ascii?Q?57IpZUTYj2xdfypw2F14QB0RrKkfqdMpVjj6mFzrm2WjuhvAnz+5Mj1wjDoU?=
 =?us-ascii?Q?fgjvCg6rA9E0e8aC+sYVGJ/RxGxjIGGHqc7evQ5JTZ4bb+qL1wetZBysvRjz?=
 =?us-ascii?Q?12z9Db44Njpb5+sagDc46RvousKN/M6qWSaM/lmq9PeDIzw8IpqsnQW1YoWL?=
 =?us-ascii?Q?5Y1hAkBM1o0WNatZYg483q43kbJ70vmqT/ftWJGlTelc7Gjk/8KSjkS2Y8xp?=
 =?us-ascii?Q?fa8Zruw8CbiBsBFSCpR2q8XILTLrNtHfM0drSVCIJTyfM6R+iRb41xedKINc?=
 =?us-ascii?Q?5aObWE3KMx9gtb7Cs2cNlvZVi6JSZJd7origgDOFSRjIdDxfU67Scsu7WFNG?=
 =?us-ascii?Q?yjgwQce7N8mzA3qHmxlwQx6Uxd999Rc2dZTWa/GMGhXFLaWNnsOcgE/xIJHn?=
 =?us-ascii?Q?J+m69Mh+Bxzx5K21mbGyGLvLiso0ZbHD7SfayzqIsbzXIphsBdN0DXeN3i6W?=
 =?us-ascii?Q?Xp9E0mEwSA+6QLwCRUQtaGsJl4MgU60drxLu673CizyCuAKOmQgtVWShjObw?=
 =?us-ascii?Q?NgxATiurFw95dxYks8V7bqyXQyjqLYHNzmGxL2yeMX2kSZEulJ6tBhsB52F0?=
 =?us-ascii?Q?ZDWlQkkcORuZfuyv5dpOsWCz0w3tLajjQUjMNIPxpb8bI/FXLnGyOgfwmiUY?=
 =?us-ascii?Q?QuO+2A54x07shhKooviF8M1FTqanLjyR9kDswxkzo8+eeoAbfkSlGkbyGt9x?=
 =?us-ascii?Q?VqY8RGQ0fA3tSslvgy2eXbor52L5kJY5IoP3S3kbsiHF6qw8HfV7t/V6tkIF?=
 =?us-ascii?Q?VtrKqeBkjNVLKbtrQE8uKmKIFHeoepmpDy4ShsxUzwd3DgjOKr+1mTxoBP/b?=
 =?us-ascii?Q?qRFk4RnOdDbNZZ6awpXwXdJ7K0d2KXaxGzuHWJW7ssA8x2u6dWMpliylEv0R?=
 =?us-ascii?Q?6kTh/3qNJvUvzUW5Aqr/iX8yTwxgCVvZwZjGL5sP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b65c381-4896-4722-0a6c-08dc3940534d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 16:06:01.9180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Gs/YjneygeSxeXH2JKMGkDdL6M9CmwI6mCXcpZLiaqpZmDrqa5sTzHGyRQWf1dq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7297

On Thu, Feb 29, 2024 at 08:56:39AM -0700, Alex Williamson wrote:
> On Wed, 28 Feb 2024 19:48:01 +0000
> <ankita@nvidia.com> wrote:
> 
> > From: Ankit Agrawal <ankita@nvidia.com>
> > 
> > The NVIDIA Grace Hopper GPUs have device memory that is supposed to be
> > used as a regular RAM. It is accessible through CPU-GPU chip-to-chip
> > cache coherent interconnect and is present in the system physical
> > address space. The device memory is split into two regions - termed
> > as usemem and resmem - in the system physical address space,
> > with each region mapped and exposed to the VM as a separate fake
> > device BAR [1].
> > 
> > Owing to a hardware defect for Multi-Instance GPU (MIG) feature [2],
> > there is a requirement - as a workaround - for the resmem BAR to
> > display uncached memory characteristics. Based on [3], on system with
> > FWB enabled such as Grace Hopper, the requisite properties
> > (uncached, unaligned access) can be achieved through a VM mapping (S1)
> > of NORMAL_NC and host mapping (S2) of MT_S2_FWB_NORMAL_NC.
> > 
> > KVM currently maps the MMIO region in S2 as MT_S2_FWB_DEVICE_nGnRE by
> > default. The fake device BARs thus displays DEVICE_nGnRE behavior in the
> > VM.
> > 
> > The following table summarizes the behavior for the various S1 and S2
> > mapping combinations for systems with FWB enabled [3].
> > S1           |  S2           | Result
> > NORMAL_WB    |  NORMAL_NC    | NORMAL_NC
> > NORMAL_WT    |  NORMAL_NC    | NORMAL_NC
> > NORMAL_NC    |  NORMAL_NC    | NORMAL_NC
> > NORMAL_WB    |  DEVICE_nGnRE | DEVICE_nGnRE
> > NORMAL_WT    |  DEVICE_nGnRE | DEVICE_nGnRE
> > NORMAL_NC    |  DEVICE_nGnRE | DEVICE_nGnRE
> > 
> > Recently a change was added that modifies this default behavior and
> > make KVM map MMIO as MT_S2_FWB_NORMAL_NC when a VMA flag
> > VM_ALLOW_ANY_UNCACHED is set. Setting S2 as MT_S2_FWB_NORMAL_NC
> > provides the desired behavior (uncached, unaligned access) for resmem.
> > 
> > Such setting is extended to the usemem as a middle-of-the-road
> > setting to take it closer to the desired final system memory
> > characteristics (cached, unaligned). This will eventually be
> > fixed with the ongoing proposal [4].
> > 
> > To use VM_ALLOW_ANY_UNCACHED flag, the platform must guarantee that
> > no action taken on the MMIO mapping can trigger an uncontained
> > failure. The Grace Hopper satisfies this requirement. So set
> > the VM_ALLOW_ANY_UNCACHED flag in the VMA.
> > 
> > Applied over next-20240227.
> > base-commit: 22ba90670a51
> > 
> > Link: https://lore.kernel.org/all/20240220115055.23546-4-ankita@nvidia.com/ [1]
> > Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [2]
> > Link: https://developer.arm.com/documentation/ddi0487/latest/ section D8.5.5 [3]
> > Link: https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/ [4]
> > 
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Vikram Sethi <vsethi@nvidia.com>
> > Cc: Zhi Wang <zhiw@nvidia.com>
> > Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> > ---
> >  drivers/vfio/pci/nvgrace-gpu/main.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> > index 25814006352d..5539c9057212 100644
> > --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> > +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> > @@ -181,6 +181,24 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
> >  
> >  	vma->vm_pgoff = start_pfn;
> >  
> > +	/*
> > +	 * The VM_ALLOW_ANY_UNCACHED VMA flag is implemented for ARM64,
> > +	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
> > +	 * rather than DEVICE_nGnRE, which allows guest mappings
> > +	 * supporting write-combining attributes (WC). This also
> > +	 * unlocks memory-like operations such as unaligned accesses.
> > +	 * This setting suits the fake BARs as they are expected to
> > +	 * demonstrate such properties within the guest.
> > +	 *
> > +	 * ARM does not architecturally guarantee this is safe, and indeed
> > +	 * some MMIO regions like the GICv2 VCPU interface can trigger
> > +	 * uncontained faults if Normal-NC is used. The nvgrace-gpu
> > +	 * however is safe in that the platform guarantees that no
> > +	 * action taken on the MMIO mapping can trigger an uncontained
> > +	 * failure. Hence VM_ALLOW_ANY_UNCACHED is set in the VMA flags.
> > +	 */
> > +	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED);
> > +
> >  	return 0;
> >  }
> >  
> 
> The commit log sort of covers it, but this comment doesn't seem to
> cover why we're setting an uncached attribute to the usemem region
> which we're specifically mapping as coherent... did we end up giving
> this flag a really poor name if it's being used here to allow unaligned
> access?  Thanks,

Yeah, I sugged to fold that hunk into this:

        if (index == RESMEM_REGION_INDEX)
                vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);

So it makes more sense. VM_ALLOW_ANY_UNCACHED shouldn't be used on the
cachable mapping. The comment should be more specific to this driver
and not so generic:

/*
 * nvgrace has no issue with uncontained failures on NORMAL_NC
 * access. Tell KVM to open up guest usage of NORMAL_NC for this mapping.
 */

Jason

