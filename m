Return-Path: <kvm+bounces-24207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A445495255B
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6195F2893B3
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0198149DE8;
	Wed, 14 Aug 2024 22:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BLGORsvB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC941494B9;
	Wed, 14 Aug 2024 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723673692; cv=fail; b=AUOX2cK1X55w0p6wCXGk8btQwqW+EbD6ySRuxPq3JXotHMOaD1xhwbagYNh/s9MAlj9Aifq4av2a7D+CKU10JnxkMcenUoZI3IP/wLUNGlKacSuEXipZSSpPOzqmlQI46Wa8oM2gx1UOXoQ1TosNDhz0EgkYRd3cmTpwCCqDEpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723673692; c=relaxed/simple;
	bh=cghXwVPgPMYWxwFGOmIk020IkdgVXT9yWcRIncdkz8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eC8/eIQvlJ32jhp3BB/i6CZZIJCESmCrQpuHVdQMrVI7LKHpOG90HlY+B2CntX9425GI6ceaK9rtLLUSnp4D6vVsMV54QUclXKNIQuo5GN7i3YcbziztCdoQOhOf5M8dGq1VwWQJkVVQLu/Dx2f0JuGQX4B7nBlowj1WsNya0SY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BLGORsvB; arc=fail smtp.client-ip=40.107.236.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cAs+v9+XLqBVy2GBR8Cw6pz9Huiy7c00MBW1s/j2alNky6YSePC3EiE+51dJs00iOf+jZIMPkkvbrw0pO6hgrsfK+CNK1RB1aeQEieUWDuTBOWGyTWZJ/YB7b0Znl0Jz3pk2ROiIXwSWRQM997Y5b1ou9B8LnCLnrDu9iZ6wvNZ2JLYtGQJ9aGFuQobH1eAaEB8hhdV3hbs99/NuwGBRm4qu5QFM1xnx1bDscbx3JPS0+jxWqrW+LvGbC1S1PguW5IAn/Oqdol3l+a0cyb4wGCsDCnSsWA2D5Zy5k4veBPcP1tx3E/xa7YBakf3hnHel5ZpP4tmB0dwyIzW+RbqF7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glYGzTBqvDDJ5Qp6VAm4DOCq9eEx3qfz2l+/1M1l/OU=;
 b=WSl2Y9Z4+kuvfAsPpqLB7to8nVPBffgfEkRxIrQu6abmjAIxHFmrqRL6iOGHJ65cCH3DW7GIe7sy7HCUGZPDUroUZwI71QKVd3js2LSFhAXc2mcgIgLnzWnhN73q5U5Sq2CZ3hDaUEBTyAlnzTXoeIIA4vsOBbZ0BF3peLhm96kIuQkVuXPsT4WK1e1kzLaul6Kmo8NVsSWMTxRHcNIrdIwQfvDZ/ioaOafHADYY15sDJxcDWCEjEYrQVHAJDwPAgmMFzk8VQCykUTXRO8w1cR6+25entaMRdkVLeVwcBlw4sjrli+Y8Iq8VEv3tVP4LxkXqm9VWM3KQT7bmK/j6/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glYGzTBqvDDJ5Qp6VAm4DOCq9eEx3qfz2l+/1M1l/OU=;
 b=BLGORsvBw7JBu+vlpnHeh9GlJzjUXWBKX4RZC+flcpCqv9Bdpfsx4KuhtPRW70e6nGPWgVu2FiHowv2YsaEB46CLtoP2UOlPZSef9ZwQVq0DcvFl9r46exR1jTLgkc3a5xTUAwfxQnJVzSJ3z5iw0fbSDije9CUZMpqKhmtL1LBAHjW29tMTP2wbpEqgW68M4MpkD+R4/zaLoZFFZss48GQCCPmGa8QvJlaA384h6ih+yL3MM4TFT5TyUBCudrgZa1zyTUIMu9oZvqWVLFZmCUooHeD7ANHtgWKw0CZbagE3ccWTbNA4FAJayS8LrjOUPMeiI2UwnjL94zBKXn+Edg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8429.namprd12.prod.outlook.com (2603:10b6:510:258::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 22:14:44 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Wed, 14 Aug 2024
 22:14:43 +0000
Date: Wed, 14 Aug 2024 19:14:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
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
Subject: Re: [PATCH 09/19] mm: New follow_pfnmap API
Message-ID: <20240814221441.GB2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-10-peterx@redhat.com>
 <20240814131954.GK2032816@nvidia.com>
 <Zrz2b82-Z31h4Suy@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zrz2b82-Z31h4Suy@x1n>
X-ClientProxiedBy: MN2PR12CA0036.namprd12.prod.outlook.com
 (2603:10b6:208:a8::49) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f932bb3-2998-4bbb-cdc8-08dcbcae7fe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kdTdt/zS+JqKYbvs10MluAYWGULwdVhr81LUoHF4HOu5Ocp18m9pl8oy0JxA?=
 =?us-ascii?Q?qESMSyQnvc5OuV5gAyp58REbEZIf3cCLRSN2DcjxDCnNcifKIHZJrOA7Re2y?=
 =?us-ascii?Q?/aU2oOhUjwx1IgV7bM9yA69finj10N0VQ5W0GpRJ1TZ1E7Po6eliUEQq311l?=
 =?us-ascii?Q?nWYhKhU7gaZVL0LPHsBti3xdCImVQg+IYasMsgcim1Sd7dEwLfbqxCbMDSiC?=
 =?us-ascii?Q?gTcvH9Ul7hKubm6znnlV4pUbLA64dYkVbBWVFd9T395DRlz3X6JpAXz3jq7u?=
 =?us-ascii?Q?mPGoq9wZO/X8l9/7vN0AYMfj6ahLiJ7AIVCKxGXK8MvnJpHMg0JdwyYLt51a?=
 =?us-ascii?Q?v+rNJjMPp0eJkxskMgmrV4H6sUH/5Ir74m8rOwagq08L6NvPKh7HyQndFQdI?=
 =?us-ascii?Q?ffp7RwkuY7PZnXvm2OTwijA7nipXDdVQnnE5qEiDOTcMVqZ2ZveZN/DbpsRA?=
 =?us-ascii?Q?OAlZHNfY3tlqsyLhXQC4q7Xac2rcAKtbuS9M0ZR6Lm1i44QvfVNwttNU7du6?=
 =?us-ascii?Q?WnHqO3RklHacYQk5PqgX0CyiUmbXnvVAlbVoFSBrrzNWnzgd4hzjHQa4ZFc2?=
 =?us-ascii?Q?+w99Va9wqd1y9ZG/YuIUA7eeyj4Qd5ThmoMl9QhilHPDotRNCHvCeKKjw5E7?=
 =?us-ascii?Q?2+TxNIz3vPOXvf7s3SWYrqt5sIc4TI7t5zJZ3eGjFco/h/gccGyjbDWAENy1?=
 =?us-ascii?Q?IVR5MS+vqeuJWF5JnPTr0N82P4GTwKyN9+Zj1yMHNmOj83Jy84IMRp3pWq2a?=
 =?us-ascii?Q?8MSoTCHIkiMv1WOtfzdLnlxbziW0y+kB6XyuGxGNNCDtpS47ngsvYO15NZKq?=
 =?us-ascii?Q?sXaMV4BK1Ee4tflL82/HxWSJ6FvOL/2eYbVFFK6zO/nuetPi3i5w2waQJtL8?=
 =?us-ascii?Q?DhqYSKIqbu+94+nAWYE5vKcSRzJQDT7HBwcjvpTi9PSNVRIt8yDJsZJ2nzSY?=
 =?us-ascii?Q?ToYq0CdBPkP4keZUDIwrFBAd2H3U3a/9CNXYGU6NjgjY10UZnDcqEFiuMVfi?=
 =?us-ascii?Q?gv9A3shtx3P7yqbKQ3Dg0Wr0MeoFKnjJIq2sV9mOR+RaUpmmhqyvcKSTETOM?=
 =?us-ascii?Q?ghlrGvtkE7CjA7UEw6CO4jdYdkqB5pZZCou+OwMDzWs/60oHI4hdHFaGSyin?=
 =?us-ascii?Q?yMETkinFahBs6/KezI+l5Q9X7F3JUaW0EHEw7NxZ9VC1ReCydHFjjveEK4/p?=
 =?us-ascii?Q?l8rzW2xW3ltCMDSsBdmLVDI6nyGrrdjU/jC3YUOpgrBBCmB/iQmoxbiw8g0v?=
 =?us-ascii?Q?K/HieHndfh+IPGxLHx2osK1DRZpnz3xixwbhVs5a9cC6y53+oqMp60f0M2Qz?=
 =?us-ascii?Q?8NDq42PX4NHt+sMUNN3KELXPfxijvNdwuJaR6PJQnpVwSg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SMEb13DMIpf0z3bcBRtU7FITKI8slwjoBWuNZMqknIwGLlw1hKM1vbv95oRS?=
 =?us-ascii?Q?JOONvkwZW0J1iB6f9R2nXbAeICn06GRZg/QLlyQW93xUuhDCpZyt9uGPQmce?=
 =?us-ascii?Q?66LBmFJry0y1vV7mVGEuXU00WyngCX2jZzcVBfaHuwG8Mfhz/xm0AyP097KL?=
 =?us-ascii?Q?WI5AdBPwFEX2TobFPAocElPSxx2PpQisb40fg6AcvSEcRsVL0kDHfbbD9m3Q?=
 =?us-ascii?Q?dpXhuoiv0fZHaeSptYd+qPKoqu7UUqc8I+UDVKKI8maqsbTxI0CAcP71rmWX?=
 =?us-ascii?Q?d4EwqORsDmkLGLpyJmJeAM8yE67cRaTrm7Papf10CAD6KccC8ofneHYPCUZQ?=
 =?us-ascii?Q?9yQa9GhgzRkRTxOuoUxnbXOeeL6BG3YyDqbYCACGL/cWLhlGCKKPDlL9Umif?=
 =?us-ascii?Q?0Gkxevl5Ydd+DfznVkVUyDH510BDKkY3YsNFEV0lYTtbzEicL4slJqmGhKdS?=
 =?us-ascii?Q?5S9VuVoMxAxn6Ek0kmci8BgyDPHyEjcwCRHslYjlHVJ0kTc1c3V2wv1dQMDi?=
 =?us-ascii?Q?W5Ffo9uNmrfuLBJnkz/SrxpXmdnJz14FVH1LVoqYas7eovG+DMbAe+vFrn1Q?=
 =?us-ascii?Q?kZpRrlMUW7USrk7cOtUQ1yT8S05qeF4aecBTAoVYdkm1I+fURkUxXf4iDmM0?=
 =?us-ascii?Q?kH7SGOGklwf8jxDNoFEIYfjLGh+y7Scjo+0yAw5vk+gRJDr7S68Onk2QAbZZ?=
 =?us-ascii?Q?GyCebg7oB3JTwqCuPtl9DsGLDIo4N8d4UhAbdFo8qzQkkd+roTc4IYBZ8TlB?=
 =?us-ascii?Q?RKuZ71XhlyL//HTkzz71hlPr7OdAIdXaq2t1l2+zuM0XglzcYkMc+MdAVYdR?=
 =?us-ascii?Q?9oOSon9RH+61BZSaBWEDyMnPnFgjRMcqtvPzPjrBDjL1h1niZ0JgLI1igzSy?=
 =?us-ascii?Q?fiXqbatjMd/OQH47hdxQr1oEIDMdi+ONn9lOwCsgx2c59TruES7gUi2x4BVc?=
 =?us-ascii?Q?Wp98gAYPE52c6TVj1y2ie+KZ+FBy2V46utFjmYa3iHw2YsWlx3FdMfomME4K?=
 =?us-ascii?Q?Bz53khP8g/ZFLKqO568/dizeytQ/ZG3gH49kjhd8sjvTWCJr9pQq2UUUMGEC?=
 =?us-ascii?Q?0nHaxEDUZs1KCobBOl7tVJJF5+cH8MReP4EDTlmEe8riNhXgFfsBxM9JYNjM?=
 =?us-ascii?Q?EVsuU+TMFGovjVtiHJ1RDsm+jV79MTuH+DWdNIyHIViAaU2g1F6ckzc12I4y?=
 =?us-ascii?Q?S7PaWExEahIWMNAg3JuXyft7B/kWtRqHxzlk0M9PlTZnL1OaWTbGIAJEQBMb?=
 =?us-ascii?Q?ikwugfDmdyiwYDhfqg6zl07pxuna1LoW1vQ9ruM4sS69Fqzv4drWkvXeyzdb?=
 =?us-ascii?Q?H+N0S4Zch4z9p6ltzhTCl38OXaELBWwlXP3vMeRBsX7a1NBz4us6SAc3Dyuo?=
 =?us-ascii?Q?qh6RFrNLFbwqGXGtoA2lkTHYFJ2kysBF6SNQowgFGq8I6mkMhoQx6w+tD5La?=
 =?us-ascii?Q?UVsLHhgm6dUPPRyRdLcl9P6X07h1ulffgl40jLVvSqr0AWwu+f8hJyysKJzM?=
 =?us-ascii?Q?blgxfZpAkd5DPlJI4wMcgRn8xZapKDwYiYJQwwl6yQbdjqRh65uXOiqLyeK3?=
 =?us-ascii?Q?g1ljA6KscaMMQl3EnKo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f932bb3-2998-4bbb-cdc8-08dcbcae7fe6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 22:14:43.7776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xQbT33GDKxD/cJL05MgflbPbonGYfSGsCUPUDRPWMWPqUCljGrmzQ8DqIYwqz5B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8429

On Wed, Aug 14, 2024 at 02:24:47PM -0400, Peter Xu wrote:
> On Wed, Aug 14, 2024 at 10:19:54AM -0300, Jason Gunthorpe wrote:
> > On Fri, Aug 09, 2024 at 12:08:59PM -0400, Peter Xu wrote:
> > 
> > > +/**
> > > + * follow_pfnmap_start() - Look up a pfn mapping at a user virtual address
> > > + * @args: Pointer to struct @follow_pfnmap_args
> > > + *
> > > + * The caller needs to setup args->vma and args->address to point to the
> > > + * virtual address as the target of such lookup.  On a successful return,
> > > + * the results will be put into other output fields.
> > > + *
> > > + * After the caller finished using the fields, the caller must invoke
> > > + * another follow_pfnmap_end() to proper releases the locks and resources
> > > + * of such look up request.
> > > + *
> > > + * During the start() and end() calls, the results in @args will be valid
> > > + * as proper locks will be held.  After the end() is called, all the fields
> > > + * in @follow_pfnmap_args will be invalid to be further accessed.
> > > + *
> > > + * If the PTE maps a refcounted page, callers are responsible to protect
> > > + * against invalidation with MMU notifiers; otherwise access to the PFN at
> > > + * a later point in time can trigger use-after-free.
> > > + *
> > > + * Only IO mappings and raw PFN mappings are allowed.  
> > 
> > What does this mean? The paragraph before said this can return a
> > refcounted page?
> 
> This came from the old follow_pte(), I kept that as I suppose we should
> allow VM_IO | VM_PFNMAP just like before, even if in this case I suppose
> only the pfnmap matters where huge mappings can start to appear.

If that is the intention it should actively block returning anything
that is vm_normal_page() not check the VM flags, see the other
discussion..

It makes sense as a restriction if you call the API follow pfnmap.

> > > + * The mmap semaphore
> > > + * should be taken for read, and the mmap semaphore cannot be released
> > > + * before the end() is invoked.
> > 
> > This function is not safe for IO mappings and PFNs either, VFIO has a
> > known security issue to call it. That should be emphasised in the
> > comment.
> 
> Any elaboration on this?  I could have missed that..

Just because the memory is a PFN or IO doesn't mean it is safe to
access it without a refcount. There are many driver scenarios where
revoking a PFN from mmap needs to be a hard fence that nothing else
has access to that PFN. Otherwise it is a security problem for that
driver.

> I suppose so?  As the pgtable is stable, I thought it means it's safe, but
> I'm not sure now when you mentioned there's a VFIO known issue, so I could
> have overlooked something.  There's no address returned, but pfn, pgprot,
> write, etc.

zap/etc will wait on the PTL, I think, so it should be safe for at
least the issues I am thinking of.

> The user needs to do proper mapping if they need an usable address,
> e.g. generic_access_phys() does ioremap_prot() and recheck the pfn didn't
> change.

No, you can't take the phys_addr_t outside the start/end region that
explicitly holds the lock protecting it. This is what the comment must
warn against doing.

Jason

