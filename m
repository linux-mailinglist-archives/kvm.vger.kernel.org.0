Return-Path: <kvm+bounces-24308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C77AC953812
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 793DE2893A6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38B81B374C;
	Thu, 15 Aug 2024 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FxyNfmUE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7619A4C69;
	Thu, 15 Aug 2024 16:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738572; cv=fail; b=thvLmooktNN/uX8NneXI0wwpAKG0/Pq1gESIifaAA+vJ38rprh/AsWeFJWIzXhxldlCzZpUy6rXRRM7a+E9ox+3KAwNlulN6nclGtO9ldiqNFXQZ+GVSmCoV82+4zi07TfEfsrWOY/h8CSS5qroH1GUnvw1OBaIpXmnfwmcBkDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738572; c=relaxed/simple;
	bh=dbZAgKmJ5EhF3H4s5kYw5jbz9VTY/kYll8cGDcr90io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b/phxwjddvbZUfW3lZP9k0IUBvnSPBS4C0OkJt3BNpFCUN5Kl5jul3YZy1kb2ctf4+4S86o/0Dgdz7yOjarBsO8xLB8jCcDmHvVH2Carafyh28e8iJYhTBaN19j2FwoqOxoCIcMjGrbQ/X8x0zjJh96s2C6dnebntLEvENiiwys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FxyNfmUE; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dgKWqcHn4rb5aYJE3ST07el2pRVUcrslU3rIZKbYUgPRAiF5yJsrNsdQpAx0zmyPvcico9D4nKtG8EdWD9KjF7nQYoDiIvCbyi63SHq8mgWnE8VSs/qGXSOn80l9bL4NgSrmvwAmSslg5rzMWXG/DcA55KAElOOuZwP4viOE4vPeQq4/Wm3jqvTvknGSZy4dbHoy4U3Ma2qXWOEZKycYXeBVs7bSxbiUZG3n+rr7Up4V63RlwA0gta8MlXcclPXaytN5twU3hoAeGTR5GeHGwF/txzRbhhMv8spVrGII434oM3sGMX0UrIV4V41PyyLRSkK2Fvjxwayx90I4LIZInQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QI0y3QN1FoFOi6nBdUnsPUccHgXCD+tFqJGoFQrIGE=;
 b=CwImpqG6wKzp5Ah4egGN/OBeju/NCUYI3PlUYHU8rG1OgqTRtY/rwt+xQz5A1GPmkQ2LnfjQDAoXNSCjIf7xiaMRKUa2d3JkiXeBc7lIWKksx/EDgJ3WBMcxtHYOjSoPvQuskGWWuPf97IndcWBX/4jfeL/63/WxteWGkpJ4UTn6jwoD8Hl07g9TdbnxSGMuNO6M8wq2I9g6NKyZZb1G2YXzZN7VtGjXvkDGYxQL53IW1STSAfBKIdrSPLbWDmBujcS6qKwOCilgs0z5BNQLaiBReixrsIplXwndrjHZJjHtTiYFE9TrYVc3YAZix+lQ6cB+vxGhuBl4ukbJN/QvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QI0y3QN1FoFOi6nBdUnsPUccHgXCD+tFqJGoFQrIGE=;
 b=FxyNfmUEM2fn2ME1S55JHELmywA6lBr+hgWtyZyYyqyKlQ90eTrUxv9qiy68vMVKwCcWV1qftw/ecpse4ZPKYruN0eSL9AAE8pXW/1CRhf0tTf2zwgfZFtN9sf6KUAqtJSVSBsZ70rMcx7UvxOTMuUakkAC2Ub/Cz3RFqD5gexaBkd2mRrkNKt5Ju5UblxdbWttW46OIqcfUbkRUdO0Tf/CA9n/MwxAoI/ij/9ZiPtEf4z8k1mk9YAZQVhGdpeQWcT6Gt9YFw8ALOfZGUDw9uZpOVo82QHJhSGuPTRgn27tXiCRpojOxIvEbWKLfZfpxpIvLmdIx8VzCCQVDC6In1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6888.namprd12.prod.outlook.com (2603:10b6:806:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 16:16:06 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 16:16:06 +0000
Date: Thu, 15 Aug 2024 13:16:03 -0300
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
Message-ID: <20240815161603.GH2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-10-peterx@redhat.com>
 <20240814131954.GK2032816@nvidia.com>
 <Zrz2b82-Z31h4Suy@x1n>
 <20240814221441.GB2032816@nvidia.com>
 <Zr4hs8AGbPRlieY4@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr4hs8AGbPRlieY4@x1n>
X-ClientProxiedBy: MN2PR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:208:178::19) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 109749ac-901b-4930-1eda-08dcbd4590dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XEdMPK8opI9nOoKv86dWERAXdrR6BviD6JGYsSLFMkh8B4Gns+qTcXCenAwa?=
 =?us-ascii?Q?/Tcw1jurqVmuXGQALftls0/nRxG/1XC5Ag2Zzz0OXh1tkd0EOAzJPKGBez/C?=
 =?us-ascii?Q?ODEBHSzitC4Af41ZLQFfwpe82MsQ3zXFO71BEZQtqNbvmMeBs0fRQu7csFhM?=
 =?us-ascii?Q?XZD+pEkEiZk02BtFQF8zEw8x1G5o8YDRUn2NGjHMfLDPLLmHzC9dO56GluXr?=
 =?us-ascii?Q?xuBRoc5UZc8wMaczB0xDHJYFBVm0w0X5tfaqcZzdAgDOl9Rq8vkpL86vmkJN?=
 =?us-ascii?Q?qRgThQxCwhaGBnvyk2anDYdvSA7MDGYzpwJvktOlTn7MTbxf8VaHKokz3wCd?=
 =?us-ascii?Q?XW76K1MY4IjDiez/e15pXTjvzDT3MsnyJBFV31e7Y1W+qQDuT53hjaLq+YNR?=
 =?us-ascii?Q?IKFpP23era4m5KG5pcBSBM+ra9u6VQc7SBBeTKN2U3onxdQCBXHb+Nu/uVQK?=
 =?us-ascii?Q?1pJ0I1PWoAZJY5QUHnpHPhVbS8hCwUh4JRpyhwc9cMAsDpx053so59jFLmBN?=
 =?us-ascii?Q?G45le+gcBzwCMKmgx3GLH61JFB7dNwKmWBuKuaantVNxIrMtujOS//IfJkZR?=
 =?us-ascii?Q?KJVjDRMzQ1tnTZ9Ba1KU2eGCniJq9rekBdEYZq4OvOnFhnUKm1P9XKiH8alu?=
 =?us-ascii?Q?QaQ9yiRBk4z+CvLysLb1BJRl7j2JRuXkK471XdCh4xVPn2kCUQjqbEq5runx?=
 =?us-ascii?Q?r2j1widlddoPBWQr2GlHhFmXSn7vCxtIV/jQwSWy8N3m+1Ig7qPD5RxRcMnC?=
 =?us-ascii?Q?s38eKAAnkEa1WAOkh0WINO9NF9v4XOvmx0Ry4n/nHjr/SudLBCoDDgyRLni8?=
 =?us-ascii?Q?fNSHo7cF+jDifzpLh9EIxnkMkxeXoONOKEFYU2KlmLo0IsPDMcEXYK0H65rf?=
 =?us-ascii?Q?D+O9lIMnIJBRDB4gPskM0+qg3frkwl9o+IU48Eu3wpQzVdyTTbOgUf/XTD4b?=
 =?us-ascii?Q?czaPT0DQBiAxvSNLWYwG52qL3m3IyiRsrcIr3zutwT4XOS41YYE/zoPA5F9F?=
 =?us-ascii?Q?7qOkzj9DkWpRQKfUfrRg9AlwvOFdx3aYb/oM33f4umJd1wKKXWQkDSjZvFcC?=
 =?us-ascii?Q?ZTN0pwaOOR+EhMu2aGF+/hgaJbpIEZII7iY1nPMNAGe16//YRqUsE3mzwkd5?=
 =?us-ascii?Q?BtDcUCWM0UMCY4dQeFJ3iQjEcy7CMaZCJ8BsG59zl7PK8yxDCNTuRdeA85/r?=
 =?us-ascii?Q?2TXpGIKXK3sKw4l8lBAg0cwW1N3xo1dZ2RIxgt0Yaf2njyOvZsPd6uC3Ff9Q?=
 =?us-ascii?Q?t8tLsiF8M1NB15shpXBPCcNC7KO24FxpLDx4o9CJCSgfDUpGZ8cTs1SVtl7o?=
 =?us-ascii?Q?Ov1RZ/mcjjhxTuCHl9bhQYQdx9sggkQzwpUwhKXBHr2SWg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cbaj/+xJ5wGGI/ViaFDbdmD9y3Usp52n3bwYaSYMPiRR9GPJph5Q3t2uXpog?=
 =?us-ascii?Q?TydfpKKTi9gtIrEdRhmERKGYsHpRMUmcg3ccK246Jx2i1yMpZ9lM+JNCEzJM?=
 =?us-ascii?Q?DncmBMDK0L6rvQ29Pl19edOSc+B7lEfowS9U73XoH9/KFG1fFwCEb63E8Jr9?=
 =?us-ascii?Q?G4U45h4r4TyZdWaWkwWAsFyv1l8pLZZSqvXz1vcFzqEKBqGL4kor66UxAZz4?=
 =?us-ascii?Q?YeW8lhzdsk3PfW9Ly6WyjkIRRoRyJzHsjR/nrw0TshGbX2PC8r3DshMTYgBT?=
 =?us-ascii?Q?qhHhMk3/scTUAYU9vzSp3EIMYa/tJDlpU8s04eDzP+qukOmE0KzocMxEiO2x?=
 =?us-ascii?Q?sEMsXhgv5ONLv5j0k1P8lRWi3T8oMOAqDbyeed+DWk68SHFDhpe1c3omRUus?=
 =?us-ascii?Q?48A66f+/lw2o2k1MKXX5d/LK714NEqacIwtu6IISbz8U04TrCbZ5KD28tN+z?=
 =?us-ascii?Q?shT75SfklrD3VDcbZrfDmw0E2Bnkpo+mcDESshozNU2VYBOx2T2iY33K+RDU?=
 =?us-ascii?Q?CfFW3f6RXdCvNwXnJhkMh0l8mD7NnqbK/TxNhxGDkCQbN6zSeSuDb1vWp/Xh?=
 =?us-ascii?Q?jdWbPDy5JTqRa6T9GU20dMXmddYoVuH5PmmDRowMlZMBSMMWNPQBjbcmevX9?=
 =?us-ascii?Q?ew7zS7OaYHN51zlxvYpnO4Ai7Nl5+89qJdGXPiKzRlIhmA+QicQmTfxFq42U?=
 =?us-ascii?Q?YsadtR4ObPIMYr/iAw+w3nBSifrQwdsAU8Hzfyz93HQJGbTkB/m0UBxBBJNB?=
 =?us-ascii?Q?p/OmEh95WvsVredeYwiPyxYmADfuejsL5vmtZ/q9GOs+2u0Y3tcpvHYfIB8e?=
 =?us-ascii?Q?j2twjffXPG7KXCiJNy4g66hej5Wz8ndkXW03i1C60wa9tHePJgMlB3HkXkGE?=
 =?us-ascii?Q?KMILp3mDBoLBsjFY+usmpyox9T7tdLbDDjfs3BH82jkuiwVObNrRmXUWu1O5?=
 =?us-ascii?Q?CQ41kECeklrTbw+Bondov3Fyj8sbdsxActeNGe7JRmh40piIO5mXgF1a755G?=
 =?us-ascii?Q?mXgHxnLxA1hQJ5Ak18ySExmTMlfPY/lCjN5a7KHA4KeN2YWXUDAtFqSq4H5a?=
 =?us-ascii?Q?xxuaIr1OOiEywKPOR/e6X9pKIOEaWL1IFELYLsRyV99jZZl7fqxqAWmpAh1z?=
 =?us-ascii?Q?IQXND9jR9R7+/SGKuOXra+w7OS1c3J45oIxClnBAZT4C96RzEyRBZG4nkJIr?=
 =?us-ascii?Q?1kH53D65WRAlNjb4BSQc7du5OviMPTgscrbdX8VybIepOTtNb49rdbn3/3F9?=
 =?us-ascii?Q?HuFXn3qvOyFK+rJ7siOseLdTlKptLnNkVX7g/LAPQ4ods3qjMG5cctm4yiPs?=
 =?us-ascii?Q?aM7aKd+ajBubABeDoxz/kWqP8SHTciWksoD/8K7kiafgrUh7N91AaktRuRM9?=
 =?us-ascii?Q?vseWzRDGEJfKcxLD3EZjGWJ415DmgmeKdVkqxOduian/uej71Q4hV8rHgERc?=
 =?us-ascii?Q?0D8WJbG1T9U3a83BKU+6CiVS4H4S8TWoj9dBd7wBdYLZaHGoHBfqqx9DXRUB?=
 =?us-ascii?Q?wAdiiYSU0DXLZb/eAndKE62lyfBntuM2Wj6pc3c5oLqxJzWI/zqhX+uXXzpJ?=
 =?us-ascii?Q?nToLA6b7yjhYUJBH1Ns=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 109749ac-901b-4930-1eda-08dcbd4590dd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 16:16:06.2923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhhucWpJQBd1ws2WSgUBpRjoWjNjFs01irLWNB2vbMQLrYkRZCMnEcz7V6TG9zlN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6888

On Thu, Aug 15, 2024 at 11:41:39AM -0400, Peter Xu wrote:
> On Wed, Aug 14, 2024 at 07:14:41PM -0300, Jason Gunthorpe wrote:
> > On Wed, Aug 14, 2024 at 02:24:47PM -0400, Peter Xu wrote:
> > > On Wed, Aug 14, 2024 at 10:19:54AM -0300, Jason Gunthorpe wrote:
> > > > On Fri, Aug 09, 2024 at 12:08:59PM -0400, Peter Xu wrote:
> > > > 
> > > > > +/**
> > > > > + * follow_pfnmap_start() - Look up a pfn mapping at a user virtual address
> > > > > + * @args: Pointer to struct @follow_pfnmap_args
> > > > > + *
> > > > > + * The caller needs to setup args->vma and args->address to point to the
> > > > > + * virtual address as the target of such lookup.  On a successful return,
> > > > > + * the results will be put into other output fields.
> > > > > + *
> > > > > + * After the caller finished using the fields, the caller must invoke
> > > > > + * another follow_pfnmap_end() to proper releases the locks and resources
> > > > > + * of such look up request.
> > > > > + *
> > > > > + * During the start() and end() calls, the results in @args will be valid
> > > > > + * as proper locks will be held.  After the end() is called, all the fields
> > > > > + * in @follow_pfnmap_args will be invalid to be further accessed.
> > > > > + *
> > > > > + * If the PTE maps a refcounted page, callers are responsible to protect
> > > > > + * against invalidation with MMU notifiers; otherwise access to the PFN at
> > > > > + * a later point in time can trigger use-after-free.
> > > > > + *
> > > > > + * Only IO mappings and raw PFN mappings are allowed.  
> > > > 
> > > > What does this mean? The paragraph before said this can return a
> > > > refcounted page?
> > > 
> > > This came from the old follow_pte(), I kept that as I suppose we should
> > > allow VM_IO | VM_PFNMAP just like before, even if in this case I suppose
> > > only the pfnmap matters where huge mappings can start to appear.
> > 
> > If that is the intention it should actively block returning anything
> > that is vm_normal_page() not check the VM flags, see the other
> > discussion..
> 
> The restriction should only be applied to the vma attributes, not a
> specific pte mapping, IMHO.
> 
> I mean, the comment was describing "which VMA is allowed to use this
> function", reflecting that we'll fail at anything !PFNMAP && !IO.
> 
> It seems legal to have private mappings of them, where vm_normal_page() can
> return true here for some of the mappings under PFNMAP|IO. IIUC either the
> old follow_pte() or follow_pfnmap*() API cared much on this part yet so
> far.

Why? Either the function only returns PFN map no-struct page things or
it returns struct page stuff too, in which case why bother to check
the VMA flags if the caller already has to be correct for struct page
backed results?

This function is only safe to use under the proper locking, and under
those rules it doesn't matter at all what the result is..
> > > > > + * The mmap semaphore
> > > > > + * should be taken for read, and the mmap semaphore cannot be released
> > > > > + * before the end() is invoked.
> > > > 
> > > > This function is not safe for IO mappings and PFNs either, VFIO has a
> > > > known security issue to call it. That should be emphasised in the
> > > > comment.
> > > 
> > > Any elaboration on this?  I could have missed that..
> > 
> > Just because the memory is a PFN or IO doesn't mean it is safe to
> > access it without a refcount. There are many driver scenarios where
> > revoking a PFN from mmap needs to be a hard fence that nothing else
> > has access to that PFN. Otherwise it is a security problem for that
> > driver.
> 
> Oh ok, I suppose you meant the VFIO whole thing on "zapping mapping when
> MMIO disabled"?  If so I get it.  More below.

And more..

> > > The user needs to do proper mapping if they need an usable address,
> > > e.g. generic_access_phys() does ioremap_prot() and recheck the pfn didn't
> > > change.
> > 
> > No, you can't take the phys_addr_t outside the start/end region that
> > explicitly holds the lock protecting it. This is what the comment must
> > warn against doing.
> 
> I think the comment has that part covered more or less:
> 
>  * During the start() and end() calls, the results in @args will be valid
>  * as proper locks will be held.  After the end() is called, all the fields
>  * in @follow_pfnmap_args will be invalid to be further accessed.
> 
> Feel free to suggest anything that will make it better.

Be much more specific and scary:

  Any physical address obtained through this API is only valid while
  the @follow_pfnmap_args. Continuing to use the address after end(),
  without some other means to synchronize with page table updates
  will create a security bug.
 
> For generic_access_phys() as a specific example: I think it is safe to map
> the pfn even after end(). 

The map could be safe, but also the memory could be hot unplugged as a
race. I don't know either way if all arch code is safe for that.

> After the map, it rewalks the pgtable, making sure PFN is still there and
> valid, and it'll only access it this time before end():
> 
> 	if (write)
> 		memcpy_toio(maddr + offset, buf, len);
> 	else
> 		memcpy_fromio(buf, maddr + offset, len);
> 	ret = len;
> 	follow_pfnmap_end(&args);

Yes
 
> If PFN changed, it properly releases the mapping:
> 
> 	if ((prot != pgprot_val(args.pgprot)) ||
> 	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
> 	    (writable != args.writable)) {
> 		follow_pfnmap_end(&args);
> 		iounmap(maddr);
> 		goto retry;
> 	}
> 
> Then taking the example of VFIO: there's no risk of racing with a
> concurrent zapping as far as I can see, because otherwise it'll see pfn
> changed.

VFIO dumps the physical address into the IOMMU and ignores
zap. Concurrent zap results in a UAF through the IOMMU mapping.

Jason

