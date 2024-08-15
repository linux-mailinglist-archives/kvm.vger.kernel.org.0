Return-Path: <kvm+bounces-24320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F6D19538F6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68133B234A0
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F4D1BA899;
	Thu, 15 Aug 2024 17:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bdiNNSCT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7428129A1;
	Thu, 15 Aug 2024 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723742693; cv=fail; b=UTdkdV+i+BSh/2gA3frc3XdNwxoGJgFtRlF4wRXV2yGGb7NLqxk0J/yW+8Di8NWc39AawkV+3O/lg3WvU23mAiIvU65fNNwLvYkJvgMUP0Z3mQUaymwZ7g4RBLcMnR1rjjfmaEVhslwV8lkXsWQr5AvhjVm5tgYQ6YwQC77gRdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723742693; c=relaxed/simple;
	bh=TObXAGe4nXyDmOM4tECh6AxU2MYXRFhVQR6hndJkkpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l/JKND8jBsxtnVN9KzDRlL+zZX9pAc6yRQmbU0gbz+ODanzl9wIY4nTbn+82aydGdTDwX/PX9nHD0zqylD2ShfZV3A8yF1p/AsR4yR3LjXmvjfsG3uWj7DUBNMcV+vf21jSknivElBr7V0fqffLL344rQQpRfxJyHgX5ISTe+RY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bdiNNSCT; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OotSV91HlwckudZiiFpbFW9QjcdzwnNqw7kkZIKEdq/zCjs+RrUpBbWyS8eK8TIjtWM0xu+1m7LRqouiB2unnFiW6SFCayd6bW7Zo9pUua80HY7mVT55cEMMaEhfDC/DqtS+J/+GBsjknCLafvfEoX1U4kzKJtoTRCuVXWWF3bLli00swMjBnTo4e7oMDUR+ffiEelTiHTe20mOrjucCzghi0sJL9F7WaKUNSObO29902C+6a8N4kbQTY3P2kVu9u/8mNNnbmrki+qYBHnm818Gh5t+4MCbuN01npSUxIoIHNLTmvx3v0cMiLWVGYlR+iYpnE3kuYT6pFT6Ydrlrag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6g2OGGjldUA1ElwpHM7uXtND8/EUf9pQk8QvCNDuTH4=;
 b=quHNJIKqTrp0B5PPULhgo8Jx1mo60LcBJsFrXti4SD44TawUOSSbyKraJecM8Gsbxj2KEyHoUM3ORgnlV80UcLhz4LOrn1MD9INHyDFY8CWgzJp9Xj40QjKvIL9vBhZQ06hp2KGnd4q2ARNYwN/tInoaKT/3/262Sojx9MKmGBMtwMuU9wBXKcZUhEHU4ERIUu8eOOYn6u4Awfd2uV3yyauGt6kNIAXe72UsmqkvJueg3JX4KT41IZUivgnSryU7XAr5RHO8c2TZqjT4ET+QiJG1MKlFZ1JRv0b7xHsZvBl61PGEIp35CG5c2rg89TBDeTuKhQ7Hlr4nrTFwVyuHaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6g2OGGjldUA1ElwpHM7uXtND8/EUf9pQk8QvCNDuTH4=;
 b=bdiNNSCTJgqWpw5vABp+hZecIMATyU3T/5ntuQNFshvpHbQa/suPDKfBOpZ2hPg6ZvGotUwGuuZV/dncln9uipsiAA3w5R6+9uNANSW7SErs0/r8VZ8h+uI78y/IQfeZ9A5IM5DXpkT2T8Kb2Liqx6BggUfFp8BRWCA2GrWqQ6ShGoh8i0iuTzzWuF7W4VEGGeckyMWIe1WfE3Jhan1FutAtvthvcfsowxF5MnSr9Tj7JTdAEQt2QJUAtgDO95LVaTXpxU5/U+TX4dRLZnJgdCU9S41dPclZNHXXthK/8cRzO6boUoU0yjEZCFGOlyxxkfcNGemcFeVR5ZzpiWlmPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN0PR12MB6054.namprd12.prod.outlook.com (2603:10b6:208:3ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Thu, 15 Aug
 2024 17:24:48 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 17:24:48 +0000
Date: Thu, 15 Aug 2024 14:24:45 -0300
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
Message-ID: <20240815172445.GK2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-10-peterx@redhat.com>
 <20240814131954.GK2032816@nvidia.com>
 <Zrz2b82-Z31h4Suy@x1n>
 <20240814221441.GB2032816@nvidia.com>
 <Zr4hs8AGbPRlieY4@x1n>
 <20240815161603.GH2032816@nvidia.com>
 <Zr44_VE_Z0qbH0yT@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr44_VE_Z0qbH0yT@x1n>
X-ClientProxiedBy: BN0PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:408:ec::23) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN0PR12MB6054:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a5c2e79-7e84-4d87-5994-08dcbd4f29d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FQ8zI3J50fNtEZZZTO+UUMPXW5+sd4PL6OaUmOXB3BGJfm5Jhj5OfUqDiuzZ?=
 =?us-ascii?Q?GjF40tTGrxQOuWsdL3r4Ikk62REF6IXEkNK2HAtq5i4dUe9WSO5RJt8H8s5o?=
 =?us-ascii?Q?33F90JAF4EAWrlzgqldQeBe7kjKO6os39Eb1pN+J35MclTWpN4UVNg19q+pv?=
 =?us-ascii?Q?BC0uylwTBMGdhYx/+T0/NObnAVo/EOSgd1OO4deISU0u+VuaHPSAk+8FcMGh?=
 =?us-ascii?Q?KsSW6ydEGq/N2XDtpLh9Gcd7DHBdI1R6fpx4V7KNZ+cewkyL84Sb0MJBsmoq?=
 =?us-ascii?Q?hFGXnBdoasFMpMn2cUjXAVhxIfjVolwdkZSHkAdW5uzUr5fTwcT0vhfe/ZZD?=
 =?us-ascii?Q?tBU3gtk1yIUvcQ2Rcg5O+iJUY1gQ88pk9bvfwh+LM6vefY69YtDoatVKcpat?=
 =?us-ascii?Q?+lhGO1xVTDzbrf2VtHybM+BF+krABjaDIvuoFiXU7NveSt2NUVKS0bHpiDlU?=
 =?us-ascii?Q?oEALiRrmL/oAudCS6bEU5mKHFTQP9eEHB8IfYdRKOsidVq7+MIEpIQy9pawE?=
 =?us-ascii?Q?jJCs0w5RHFbtJxsfVpw1bri7wh0wVzMDRm/IFc23/v4osWCHHKYa7IvUB06N?=
 =?us-ascii?Q?XaasbfjVmZcfJJCoqDUPqcJnRzJbKC3MPGU7OOUiURNOW2DgRdlrmxwP3IVk?=
 =?us-ascii?Q?NwkVVeoSm0Ge3RzRphvV3tuDSj2kivL068j7Z8fKvNbT7aZ6tvdwWWPdrTJo?=
 =?us-ascii?Q?fPplmDdz+CMqUoVHu2vF97NjVodCHU5IbR/6rVIJeheqG1Xy8iiTSyE469pT?=
 =?us-ascii?Q?nQYhYpoGt0U/kuyHJrq1AdPf9y/hCxpClIQIA/CeLMqH7YHiCQw/gKdoMnS8?=
 =?us-ascii?Q?PCPREsX6tJky39gqGU8xku52n0N84e+WcWtaU8seMeVQPPJDPO7oNLWtZtuA?=
 =?us-ascii?Q?EgmFk/vxNo+JvOkZo4zaTcfVWeA8GgGZacOW1B+JwpVKVo7f3gdGkO8CbQKc?=
 =?us-ascii?Q?Ha62P6hXhIxneJ4/Bp29ncUtse8T5tFZJ9o2Cd6G7/bLtu5vU+YPYEOs8uab?=
 =?us-ascii?Q?U8E+w+G16WSl3xBbtBvcnCMyJGZ62UB7CPwNdgUJfvYeGtfezPJZKaTIixPJ?=
 =?us-ascii?Q?zuhL7r+Tmsk2KsvQbUAsLxPvIM6iCgsgSmC1G5slHMIBh8F/i2ZUf79SnGyL?=
 =?us-ascii?Q?3PY8JOhVPnbOv/pV8x/FXKhlRz4hfweBYwxw1XWJACBIlmUz6BzZr43VbxGl?=
 =?us-ascii?Q?ZOxICPNpo0C2I7CDlQuRRvmyUEBhAW+N/nUodonDilC0+FFTU0+dEBP2AyLq?=
 =?us-ascii?Q?8vn4lHVJSFbgKEoR6FjaVkkGQVj3dJ5fBxSWoX+UxMjYqYk1kVV8HKscvg5B?=
 =?us-ascii?Q?atLkALlWvfW/ud7YlZCrKhXXSKERiQmyCOBtEBON0wV2iw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OfXirCSjbwjMno19LHDN+xk1UowRg0uMidE/XrxhM4zTc4j0j6D0G00MUjVu?=
 =?us-ascii?Q?Nomor9744bs4p84MWkYogr+5EogE2P+WhuHBdV/MCdud3NmztzU77Ygrxg7v?=
 =?us-ascii?Q?TLPP60cUbxb7D3A5EDCqwia3ZU//VNloJRMpYJR3ZAw9hQ2+cS/kc5Bj150S?=
 =?us-ascii?Q?peSjOnrvDs1NwPzT/ZG4fSJOrWBl2QWOT7SIqBnPcfbFWn0eFyWbyIZr5MYa?=
 =?us-ascii?Q?+YQ/IdBthvw4ZdtdUCntuTt0/ec7qNqJBzhFrV3tn/fsn2+mh/mZQjg/67Ea?=
 =?us-ascii?Q?t+c3o3/WsUBVfbCo8OAC6nfgon2Qs/lRTgcuxUUZ2zwOUP+WjNoLegk3JhtT?=
 =?us-ascii?Q?/9vbeN0TvpJlzHW/KUqQBjAXUglVLq1wDnVBSIdCsKMBpMiCUlE6x370iJrz?=
 =?us-ascii?Q?UuYxeTRxIfIiqCFRGlQcYhYaVpTF0/YkzWSLVR/rReZGjrtw8JASuj+pnaHN?=
 =?us-ascii?Q?knQifQVsq5piY7UfC2JnA3tneYwpbcOUbj0PreBzs0m7oh5oic7jUfL9/XHk?=
 =?us-ascii?Q?vAy5RthLtHFQoIQSj7wlz/Jwul5X1Ro3B7H/u7M0uovs4hmMF4mAAN4JdWg5?=
 =?us-ascii?Q?NN66cH4n/Ox4y4Q8bojLxuLDu78c9ylrIiN6d3JdEuxUSOrjLo8mWoOkXG1X?=
 =?us-ascii?Q?3ugLugg268x0ffVreczaoq/ufeN8DgwmgVLEqYXDpjXyKMzLGyYFma8ywA7u?=
 =?us-ascii?Q?JCW2Vm9Cx/YLLcJM0iQKmmAackwLUYl77V1LGvbcz44hBQ1eyh56mshzcePq?=
 =?us-ascii?Q?gs42FxgqoN1qSXRnHGuKNPPhvF5SzHLMVBq3c+SiwJQv5+l145bYDTzHdaaQ?=
 =?us-ascii?Q?wgUESzBrXTs/1V/rMkVA+tYiTfW9kX7V6Lz66LasSzj3ELCTF19u0Z6cFFzW?=
 =?us-ascii?Q?y8BaBngJ/JCpTFiBghjUgYFfHqUtUERqf6u6RNpXC81CV74yDPXSQjvZyKtk?=
 =?us-ascii?Q?flJDEVcdH9Ayutgr5iS7NG3PdfrhkzLaR5EBIu4Bwfa5sNvMm73rBA+PBX5I?=
 =?us-ascii?Q?OomeuqGdfvgFKb1WYRQq7nZWU7nkH9tvHJmVGpt2eZ5I6634PQClUKsEHRxZ?=
 =?us-ascii?Q?5l3rnYWciHpdKR8lXKcwHS1zyKd1+Ove3JiHsIdEuO7R4qfXLW+C3cNPfS39?=
 =?us-ascii?Q?dAJi5Q2kGUcMMtE1UWVUAakP2scrOFxCJ7+VcYgKGjx69JpsIvIpw38cOFV6?=
 =?us-ascii?Q?ke8ylfCvRHNnlV0UBP99TaV5wkRrEKHy3CQP501qUT0tVcCaNrdOM7+qH7hu?=
 =?us-ascii?Q?90AwXjaQTjAHY7aLDBKwY0dnenEF38j/S+1anabrTyh6d9RkH1cBJ60Vo/FI?=
 =?us-ascii?Q?k7AkW0i4EhwlGIS0Rgm7LEopVSrLEKNCLm3z4/Nv+L2H/rXMZJQVBME442ED?=
 =?us-ascii?Q?mQyKTvkihZTzVeTQP19v6kUf37mGmrkiRZ9HnxsurQbpSCfJCsfKUpl0TL8E?=
 =?us-ascii?Q?Jor7V/rB/gJTZSK7oK85Ippq+ZlHYYa7fbXBgktkXlHCHJtDzcDgbua9jDfS?=
 =?us-ascii?Q?L94hVJLAedKEEeCvXgvv3sQyQM87ueMHGYWoTGn/wvUAeZULFSKWlGGKAplN?=
 =?us-ascii?Q?cNQUom9GZjxJgcUwJyQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5c2e79-7e84-4d87-5994-08dcbd4f29d1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 17:24:48.3876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tiZ3Gjk9fxNZaJxiz+ROeWNSAo1uL4sX9uEJnkBK8acVzHRS8cG6NJBNp92CTm5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6054

On Thu, Aug 15, 2024 at 01:21:01PM -0400, Peter Xu wrote:
> > Why? Either the function only returns PFN map no-struct page things or
> > it returns struct page stuff too, in which case why bother to check
> > the VMA flags if the caller already has to be correct for struct page
> > backed results?
> > 
> > This function is only safe to use under the proper locking, and under
> > those rules it doesn't matter at all what the result is..
> 
> Do you mean we should drop the PFNMAP|IO check?

Yeah

>  I didn't see all the
> callers to say that they won't rely on proper failing of !PFNMAP&&!IO vmas
> to work alright.  So I assume we should definitely keep them around.

But as before, if we care about this we should be using vm_normal_page
as that is sort of abusing the PFNMAP flags.

> >   Any physical address obtained through this API is only valid while
> >   the @follow_pfnmap_args. Continuing to use the address after end(),
> >   without some other means to synchronize with page table updates
> >   will create a security bug.
> 
> Some misuse on wordings here (e.g. we don't return PA but PFN), and some
> sentence doesn't seem to be complete.. but I think I get the "scary" part
> of it.  How about this, appending the scary part to the end?
> 
>  * During the start() and end() calls, the results in @args will be valid
>  * as proper locks will be held.  After the end() is called, all the fields
>  * in @follow_pfnmap_args will be invalid to be further accessed.  Further
>  * use of such information after end() may require proper synchronizations
>  * by the caller with page table updates, otherwise it can create a
>  * security bug.

I would specifically emphasis that the pfn may not be used after
end. That is the primary mistake people have made.

They think it is a PFN so it is safe.

> It sounds like we need some mmu notifiers when mapping the IOMMU pgtables,
> as long as there's MMIO-region / P2P involved.  It'll make sure when
> tearing down the BAR mappings, the devices will at least see the same view
> as the processors.

I think the mmu notifiers can trigger too often for this to be
practical for DMA :(

Jason

