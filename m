Return-Path: <kvm+bounces-24138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AF6951BA3
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 723CA1F214A5
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF131B012D;
	Wed, 14 Aug 2024 13:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aC4tSlt3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F175695;
	Wed, 14 Aug 2024 13:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723641324; cv=fail; b=Pw5SFOihft+6W65E+Ul26A3iOIuT+DM0LJ4veaRC5blKxgdZIfUFFACoZFfdchQIhDRrGUIE3Q4k9JpViWrpeP6jESfUTbp7msk9XzU297Tkhur8vFULoC2f6EnTRQ1ASoDFe2Ax5FiPAczvMw331WnQwCnQpzk/tOEADVZGrZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723641324; c=relaxed/simple;
	bh=g4ZgDx4RQ8P3gMXj0cH2PMMyUE4JAYOKyD/7ZH2xUQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aKUxdM6IaSQR/joYINcKXkDX9VY5gkbjHfHPpQs+G18ouU/vnwE8+mlibUapv3dwQP3r/NoYQ/Vlz2uqCVGf5Ixza7DS7secd6rzQmGDNRkl1N3YRqCb/3aXWd0JEiXsStkykC/Dt4tXkJ+Do8lku3LRtQ6mPKUboF84F4L1VSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aC4tSlt3; arc=fail smtp.client-ip=40.107.100.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VA3ovXvNY53LAJXcpkqiXNLThpY4yhFklsgJn+yx05qCTlkw9p4TilUhqrpSqaDwSWNdK1GWafbOmeJF2U3VIGkHNL2IpFECqkH19MHCeV2FG6iEt6KuradHDnShTtLWywHHBzqyi90GDFGSF5i0YPbv9/usaHvuIbx0U0JofmsQ8s/seSh6B7aGtpgE1al0Q0GdL0HB4uEEXxQcgTaLAGrayv6qC/TwBffXDbnxxn642TasUyZG0OZYei+b/Te4e+8T7wriI2xG56GBj2FKLDPBZX2Jv7ETHM4WxzRgBPr/py+5ExMA3XfFyDUCJz/R2LwH8G8in4eyJyTdk9DWzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkONNSGq9odJ1ro8LOtp4KHQZg0wQ30Y7INewiXwLYE=;
 b=e4aIXsEK9iQlUZ4/5pBmrvdkpb5nDjeK+FCaHg4rSKGZBkt4crUk1BPwTyj1lJzJrF3fksxn2CUHGL6BjxUh37w3m6l6jCnU41ZpjulOYu3DQVZRBiNxfKYRlQKodMRQNJ59g7wlWixNtDtvbLruMM+yHMIKpwyStWaqD8EyT3sCnFykNXf+moUIAz982TKVx3OYR5X/eG+OgNfnjvoLRvtWMyR1JTLbF2VbkRoooRxmhvxC01zmVZAzEs9fYBLqQvLx4emE8kVh1qrWDi/Qh+IRwG2w9o4hb4vPfqa/zVH1frSpyh01FMIn8pbpCEJ6Oih9wGxGjbBN+AanKllSfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkONNSGq9odJ1ro8LOtp4KHQZg0wQ30Y7INewiXwLYE=;
 b=aC4tSlt3o6+cC6M6havyZU8IUO0Q1h8nQZrPlIE7WuhkGKbwUA/IpQVdYwUekhTL5d0rxQd9jwSMDnpm3V5lJhlDmZcLuLyx9sKQ9oMoOcPu1HtaayB67NyolzkU3iM+Onw+F16eopB5G9tVfUS9lLFjqN3XApHwJNXVvCOUNxyCLdvLIeuCaZyOhBPIy2xgbRU5Q8BSHsIk1RR1h4JfH/FUIES+lSv90rjnjefv6nm5b3buALfA9QX15ACGgdR6baNnl4kLcXbRhHh0/GmfZqerIoLR5PITpS6P+AjYqXA0wPkBNv4Mmm+rvc4BEESazVi9QjO5V/SXI8r/2C98gQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by MW6PR12MB8736.namprd12.prod.outlook.com (2603:10b6:303:244::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 13:15:16 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 13:15:16 +0000
Date: Wed, 14 Aug 2024 10:15:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 10/19] KVM: Use follow_pfnmap API
Message-ID: <20240814131514.GJ2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-11-peterx@redhat.com>
 <CAJHvVciF4riGPQBhyBwNeSWHq8m+7Zag7ewEWgLJk=VsaqKNPQ@mail.gmail.com>
 <ZrpbP9Ow9EcpQtCF@x1n>
 <CAJHvVchObsUVW2QFroA8pexyXUgKR178knLoaEacMTL6iLoHNQ@mail.gmail.com>
 <ZrqeaN2zeF8Gw-ye@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrqeaN2zeF8Gw-ye@google.com>
X-ClientProxiedBy: MN0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:208:52d::30) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|MW6PR12MB8736:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bbe3636-4310-4084-e21d-08dcbc63235b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	pH35v9XyToc5J8gcj4KkqwF7sUJMdXNKgZiBA8qpJ1J2kUPtBsa7k3wLxuAQm8CiqqTeDbXA8noJsCE3MWFpXNjv4sb8Ms78lQbKcJZmmfYjyNU0T0dfhvOdJouoK0hUqun0Ui94EGJsmvE5je+BiulKBQNaKapGrBNb1nYTeF+kaj6JvEvm/ggu0YgMr7EF28m6YyPhdhmQS7WxaCuCzI741a20fYNJ4NzLDgbyCsR5Z7dS9UeZtOBZwnGkZE9Y6pe9bDql4u/vfiuLRz0zHNqUsw/DXIlMJY5KcdTjC3y99lh9kG22UD9fjtIiftMDtEiQv2ytMyB0R6UouP0MgI0H7jOen/WWEFalk+wSm+zlTS1G5CWhj/aafMm2a/PoSdSske6jPpamPxFq92QZGjm6VDzMWVayk5r75TxRQCQSaXw3l/E9qlb513G0uGg0T4Rch3DUoIp8TS2tS/1pnEW4xwYCihaR7pzkK4zoUD/g7vQYf7/wJQNrHEXwIDlfymqtryOQt15/KPmisXv9NCfGCcdTq1l5cyxf1XC/wqQA3DsZ1bWDuul9NU/4cGxdig/PwRY3pMMKNGhEZpN/CxiU6rtRhK2r4Nkwv9D4FXynOi9Li1T5Giuo0Rqp+0OJUgHIKxAlU/21b0JssnsJ5r0/FLW0H7iFhdZLi6zmbuQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rmYx8AoOCy8jh+YUSBpwvV/iZdQwXxqKq56vppxKdki3e3Vq1zh33tpnWqfe?=
 =?us-ascii?Q?r3N8LkgL/9fWB9NiUQpupNUI/LAkuSGDMZ4VgwrWRRQLetxC8eccRRDw6kl2?=
 =?us-ascii?Q?0+p9qKqdMElpADh/cnMefQIC1Ff44L+ZUSNq72HdZXpPcL9I7cFkUj5mpVvm?=
 =?us-ascii?Q?Mt99NO3uzYmKYUvnetlMQOKUqUFhTf+uDQEZIj8RCeuuJZ+tTyeXt2K4FMgI?=
 =?us-ascii?Q?d9DKMEorbsDlNMcgdGJNO8e0I+FNL7WXTEVFA/dq5UtEPKJDCmDQoJ03AQsU?=
 =?us-ascii?Q?NoVSVdwqMcpV5K1Yg7M8N44UE1LLfQNaBgQ88jg50qkrlHyRqgHwvLbkRc5X?=
 =?us-ascii?Q?RPWskaZxAJoVQaPSTmdwAfbY4O2CaRpgn638/p3u0Qg3eIGwVsGJIddHg4WN?=
 =?us-ascii?Q?U4X5un/rbHAIfhOJmwIDy9Bsc1+pqaQnNEW8W1sfmMYcsExBp3XCH7fRbOv1?=
 =?us-ascii?Q?80N7MCGJXTe9vFelQZz4HAHo8/JGAGZZS4Ygm1zwRjwMHhNmkxDN7F/IXN95?=
 =?us-ascii?Q?gdjRwShG3Ev0M3WYSdQwJGGT5k8ESzAQMHbX50HS7RLZG8LhmrJ1trS3H8C6?=
 =?us-ascii?Q?2WXyExnpqO2+A7wKNqUOCkmVqn6EkKOM5jKSwNeHRgQgABTbOdbe6V5mSTfu?=
 =?us-ascii?Q?yc7T/955YQRacZ352HsC9zDI/uoSJOpDypQ1AGj/V6fUI77xbuxz1XdH5K8N?=
 =?us-ascii?Q?j8SyqDhqWbcE4CVwrhQLAnEVQhO6CasUrYL6l6+eJUYjmNKfB3DIdYeAa70J?=
 =?us-ascii?Q?/wZvzZxCM29Acra27HTnlw3YLtsP+CKQ54KOYHJy5orBXPgEDWXLOWgB4/DA?=
 =?us-ascii?Q?DZcnALthkLL5tM7Gr+UOe9KUXp9e/6kNvQAC2JajxG9zGIAjMMgjquU5k70a?=
 =?us-ascii?Q?S4WOWcg6AbJu+A0rxlodj0osEWA92CkiKewEjpREUQBHKMP+SKOyxFVXKSqy?=
 =?us-ascii?Q?1b6LdUNicWIIDKNABSVCel5+qBx3uPZOf2zvfXy02FS363m1zfgOTUmBRpnK?=
 =?us-ascii?Q?y1QeC/ND8jAjVGKJrvz94/0eOn7hVk02hlrFQp+YCOq+rjrv6uA4lUugVOHF?=
 =?us-ascii?Q?vojEyeBkRLUq9AeHwYl6WcNDp1N58I8jjGdm5+StMVZNX6jMSf+Vw3/qCbUs?=
 =?us-ascii?Q?JWm8I6MhOIoAlv+i9j0lJ+SOdo/YK4NlHF3S8tut1X4g5eQLtuUpYZ6A8oDl?=
 =?us-ascii?Q?axG396kURuK+fLoDEAF6nbENNaIg+y6jR/9ggbERCFRPdgZ/YXGkXkhZ9F4u?=
 =?us-ascii?Q?qoIwEDk+XdwPoEVxMm8bsK5+1yd7x8rRljnuSToWUhk0u4P7dZmNkNcLkrxR?=
 =?us-ascii?Q?n6HmMIbzgT9aI/H8OqSmMSDKSFpD9s9RKIcUahNHgUyol+PqXPEGsw/to3Vo?=
 =?us-ascii?Q?DNu2Dlbkq4n+VE4q8YFRMPaLhLL59ybsD7gAw44D+HtwCQDfvN/zwtIDp2Kg?=
 =?us-ascii?Q?OJNJe/2ltMSO0kXy1tFNszrlIES9y1tAbDMzol4+aKfOwr6vAnKxkDXKah00?=
 =?us-ascii?Q?u+bW0tcarWR4hQDNdT8uf/6YNnpLbA8PY8CK4TEPnzrxJxBXowxVwcrHoEH9?=
 =?us-ascii?Q?AZ/IkUn6AXNKUscCh2u/2YntSmr+RH7e7DGBs3hT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bbe3636-4310-4084-e21d-08dcbc63235b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 13:15:16.2507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09EM2/ny4uFIA4ZfvHc+xP0W6Ypmo5XxA4mXiArHb8rfUJqskw8PsGCpgQvTwrWj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8736

On Mon, Aug 12, 2024 at 04:44:40PM -0700, Sean Christopherson wrote:

> > > > I don't think it has to be done in this series, but a future
> > > > optimization to consider is having follow_pfnmap just tell the caller
> > > > about the mapping level directly. It already found this information as
> > > > part of its walk. I think there's a possibility to simplify KVM /
> > > > avoid it having to do its own walk again later.
> > >
> > > AFAIU pfnmap isn't special in this case, as we do the "walk pgtable twice"
> > > idea also to a generic page here, so probably not directly relevant to this
> > > patch alone.
> 
> Ya.  My original hope was that KVM could simply walk the host page tables and get
> whatever PFN+size it found, i.e. that KVM wouldn't care about pfn-mapped versus
> regular pages.  That might be feasible after dropping all of KVM's refcounting
> shenanigans[*]?  Not sure, haven't thought too much about it, precisely because
> I too think it won't provide any meaningful performance boost.

The main thing, from my perspective, is that KVM reliably creates 1G
mappings in its table if the VMA has 1G mappings, across all arches
and scenarios. For normal memory and PFNMAP equally.

Not returning the size here makes me wonder if that actually happens?
Does KVM have another way to know what size entry to create?

Jason

