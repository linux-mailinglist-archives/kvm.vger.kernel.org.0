Return-Path: <kvm+bounces-65802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA13ACB7575
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 00:14:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ED8B230021FF
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 23:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3425129D280;
	Thu, 11 Dec 2025 23:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WXHbBENF"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013004.outbound.protection.outlook.com [40.93.196.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6101DE4FB;
	Thu, 11 Dec 2025 23:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765494875; cv=fail; b=UVegqDG2sGHFa7fkdTjb+LdAzw14SFVj0SB8dARY9kx78zGr2xv5Ae0MDUddEwJ027bzrXIPSwMsjmiXqGsGgj6EFX1+qPYt6yz0A6Ntgc8ebuG8ex4RDJwL5sqyVMj7vPd78MOi3i+FDXlUzXXspTdudsryRAthMmR/fv/vMiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765494875; c=relaxed/simple;
	bh=BB/JZtJTt7u+yBMz3vERNstn08pUfgZPLDQSJBaGkb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bvzgKaecOdIoTL/mYkCQbCUpcTJjP0xv4pOKPoFCTzflwZIXB1xHR8dKydihMe+CWBPpMgSKsiO6vB9LXkmfvdt2e73V9E8j8VEIA6XcQyRP1KZ1QqbGC22qZ6c2jva3gWbr2pgaUVBg67TImhB6zjYf0Ca9TVvk9UzGTmHEvQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WXHbBENF; arc=fail smtp.client-ip=40.93.196.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8rkYj85JqAEbbg4GQkK1LaShN1QdSVomNXAggjLkQakLMcQBIjsb5k7i9kLP38Sl7ZokWCEnX1csWHRXTvqZsmLYNkjT3ECNtvpVBytk8syxdNvvpAYVk6eTCLZUQw/M5aqWJJxulgVbx5S41skov3TE3+vlVXLymFQIkPOJQIQbLbnfuuxDXL4E9EXbw5XcS8O6E0h2GppRa6F41tNn2YuY5N+/fNlXfy7VGDPffyLGBte6T4OHlb09UjF42nKe1l2CA8LDDQTxJWHiVFJ0eic5nTt3g3HOyM8obQz2V1My15oz/1kU7TQ/gCVUPrtdB2iz9jirB6py2cMS2q40w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGUj3XoTl3hwbWYR611GLla58ZF7C6mBFIIiqx1Xp/0=;
 b=GJQrRj3rsD+Chl4ArP/TBD7XRurt3K/ohasCBZez66UAPP7cVe9CFS8mMMbuXNOvT8yNg3StSB1Df/xC5LHmcth5xG5tZl7TqkY/J6eRdjsuDy5lSVowdV28ZuZF3ErbCUkkZcvvYE4BaUoX3aqsY5FVQgTt1qf2U4F3KYcZH+AfjQPk7E45gjTHVbNis3s+Io6PUAtCPkNBR6QA8wh4i3PUgFB5rPLf04IFvANkM/L4ZsJyR8Tal7MlH4/Fc25A0PIxInLsheLXBbzdXq1YR5+2zfOWoxAGk8c0KBKbyOuvVeisz4tshvvEGJY9ctlUib5HN8BLF7eA8zZm5MeICw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGUj3XoTl3hwbWYR611GLla58ZF7C6mBFIIiqx1Xp/0=;
 b=WXHbBENF3idTyjVRqzXFSDJoogKNM06eylERGawyz/TPQlp2MR0LogoUbajy22lMcrrgyJehbVBeYwFPeJOuiipnL2to/eh19u0KWy1uUpURiRzIx5YSMbFooMPpp699RwJ0+DfZm5Yg8cZ69owdxWO5s39aEaqJl7C+TeM/xAPUApGA4d6xvfxAbAk1ojmt5wcZZAkTTuDidx9vqdb6voS0k4Odc21aMvR4MB6aJDrL4f78CTHi5RSjM5vIlTCF/6f9PVgV70FjDk2MUQmdhyQWKqnnX+Zcgsmm7Urw2xdjRnB6xlknzArMfMvfL7ZXSi/dTy8rQvpevrOlCjVVKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB6818.namprd12.prod.outlook.com (2603:10b6:510:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 23:14:30 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 23:14:29 +0000
Date: Thu, 11 Dec 2025 19:14:22 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ankita@nvidia.com, vsethi@nvidia.com, mochs@nvidia.com,
	skolothumtho@nvidia.com, alex@shazbot.org, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, cjia@nvidia.com, zhiw@nvidia.com,
	kjaju@nvidia.com, yishaih@nvidia.com, kevin.tian@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1 0/3] mm: fixup pfnmap memory failure handling
Message-ID: <aTtQTj98gZBgaVXV@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
 <20251211121119.0ebfd65ed69b5d5f6537710a@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211121119.0ebfd65ed69b5d5f6537710a@linux-foundation.org>
X-ClientProxiedBy: MW4PR03CA0319.namprd03.prod.outlook.com
 (2603:10b6:303:dd::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB6818:EE_
X-MS-Office365-Filtering-Correlation-Id: c99e3003-7712-4360-ab22-08de390b0956
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wzOOohbJpMeAs5+QTh7TElvw3MC2WCD3UkzycW53oWLDF5XxXwSkiIcxinfU?=
 =?us-ascii?Q?5JJ0QSL2wZyqYRq+KXVRC4U17e8lxK1GLt/Hdql4BAMmHqBdjhP2gOyffaXl?=
 =?us-ascii?Q?7IgSAJbAnOQhwlSEuLT7wZVIur9DSULEQcjjjQowpNuvQdudcW4I3aiUBDl3?=
 =?us-ascii?Q?KzXRq83/H/IClNyEGC4bvkHMmQi5+owbiGOwoCuz9OWXEujPQq+7P3ciA1eQ?=
 =?us-ascii?Q?bNSEqHj2gIFQpB0SHi0RVXaiHAASMDD5y4+ktzHJGiMRuBPLr1RBGfjVvxCh?=
 =?us-ascii?Q?ji0ssLkz5grNnZPapDREP36wueJBpBwcK08anwhKXUYDEKnS5uWgOCWzOggd?=
 =?us-ascii?Q?f/aU5EReFJMzp3aOIIRP7VdsERwx7TGYewufGVeCuAEtTKYdmE6F+ngTfeK3?=
 =?us-ascii?Q?E8pMo3lMfYdF99mOeBgDjaKOmvk7YMItny8m9ekbdcSvxgRqbskEt3hjp7cN?=
 =?us-ascii?Q?gejNjTz8Yxz3rFNBv84tAfsAPJ7rCQlaMB27lNArm6UF9bHZ1WlgIRSFns+s?=
 =?us-ascii?Q?VteXa/t0Tg+LtH+HpqcqQvaNVaMH3vwfqVsahVkLUeQRyXExQq6G/7xHjPIp?=
 =?us-ascii?Q?R3/1IJCRVgF4xkwhthKE74okUIKuuVk6EzbD4XCkJIYGuewcL7JooVOFkZ67?=
 =?us-ascii?Q?21dC8UEQvlhDD6Z6wMBeay/04HCKJQmlKySjMjN4M/wcnux9NWhduKpaF9Kv?=
 =?us-ascii?Q?Dnap2yHagy5weg/aPIU00NVqFkPwSx+EH09POTwFGnVOoBaeZPAWq/5HRlZJ?=
 =?us-ascii?Q?tYMWe+R+DkDH/eYc/0+B8hmCw3zv2izTOpguoIJFLWe8+oMzzuwjlVrOVaW2?=
 =?us-ascii?Q?FdzwYh3Bc7A2EQrBGVjJSCncjhA9sKVIxk9Q7suwiuDaUZzlJEStO/s4n4FH?=
 =?us-ascii?Q?HG9ZKbLr5YLSSqPs41XQRoGsgLOfqOA/VROnegI7QIeZXKk7HDykvu9luFxb?=
 =?us-ascii?Q?RsE6lonexpQMchdTBWD/q6piBnI4yNtZIfaocFSuAZwwej/2OFaC0A6qhJz5?=
 =?us-ascii?Q?w4xt62luFF1hzRianpSKZUd13w3od8bXDZlX9iKN9tPQ8kPn9nwel7GKFGG7?=
 =?us-ascii?Q?clF3E3VAhOBgFZDiXMGLaBmLyTuHbqGDjemcr7rNk9Org6ZMbT+L9NG0Dk9d?=
 =?us-ascii?Q?mVDpu+7lKaPls5IhYYyguFJNdGkRAW4NOAw5UBA9W8Jbbp/ToWc/clkwfTa8?=
 =?us-ascii?Q?MAcnPlpfcoFMuX1vdJE1gtDpk8pkJhWZwWduQfj4gK6evsXXKYOGDbAXohhF?=
 =?us-ascii?Q?0VIR8ihz8oGFFT5Y1KUSHjzRKK9VzjYuJvTz2ow4zNmF26Fu51jAKDDvsPeG?=
 =?us-ascii?Q?C5vj3q+gO7MypKFzsJydM2OMpurcaSkEtchlIvlUDOeRZn06UVUZzBkfvTnA?=
 =?us-ascii?Q?azmbmOaY22WNAoxa6EslCLqu5bTpSqCwCc1Cubh5noHPT5CRnVYKZWORrB9j?=
 =?us-ascii?Q?cKhEJekEV0YMiKhAiRb0KNySFj1RDkoZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p5/DIbAUTAmgdzWmy4pnfLUV6TORzHgwGcxE5z7MlVikfzhadbWTv6DZqc8H?=
 =?us-ascii?Q?HGFDdj/IoeGeEXh4GMjKYQxRE6lUCngBc27EZbF+nxo203SRA4Hucu79cQsL?=
 =?us-ascii?Q?hhsi6tv+xetzBE+MIW2RewTcEfut4DG9pD2CFCVAXNqIEghM6Mdy/90rjgZL?=
 =?us-ascii?Q?TjAmkfSXdUgJjbKn5eJ/w6cqn3W0Iy01yKzYxNkTfA75ygZP47tu3KKwQWEc?=
 =?us-ascii?Q?wx1E96CYC3okCl0fupzdXObxA4HiM2fm/LQ683Xl0TXQmzPrd1xW4L0sjRIg?=
 =?us-ascii?Q?GsY1sXt/X6G/ml3chxnbtlt6C3hgYnRjhxzToEslVhtgAFVkD1MXaj1AhszU?=
 =?us-ascii?Q?cF5R/HnA6WjjfgoGFp4AJPLLiOEla2OV4IS2EaKLiMJpmiSBfQmVRtQxJCDf?=
 =?us-ascii?Q?oH1xBri7gglKeybHHitoy3XPr1cg9LFDfM/sO8B82lfp+Q5vD5FGfIEwi7/h?=
 =?us-ascii?Q?tt7Y+WeIOYYwanPZJTp7aYFRC0q68Y1HbYlnwmIlKXZgTMIGscBfnknOAPXz?=
 =?us-ascii?Q?Tk1SnKqJW7kwjrzsDqEpIo5H7AgCMmitT9mWfa1AG519K/tjBUOwR1OdDlwa?=
 =?us-ascii?Q?OXnpUHuZn3601e/zlkkT9qVrDT/JOqEftcorU5Sqekh2jzE7TkzI3qSlvxKg?=
 =?us-ascii?Q?XAX32jjsg2ojAOumEvGvGB44RSuKGl04zQm+sZvRWFvsvIXAsByndii/tLaX?=
 =?us-ascii?Q?0tfV4/pRR0+PHqb52jpLD0lR7HnndknKVZ3Bi/F0BZlB48F7CjxLru5fmUIq?=
 =?us-ascii?Q?HXIBeDZySVWOq80A2+kQj3RCG0+15ob4b8vY2Cs8HH7HJz0MRX3zej1Fwc0E?=
 =?us-ascii?Q?eBQ2vMdAoNs3osd11sDsS0JVw0LGCFOtZyAUcgin4u3yDZuQAjc1C/rPZBxB?=
 =?us-ascii?Q?ekqycWTzUVEwhkFidgwDQ/aJDnB0FcMmU//YJjsnNLRUDl45d4s2PTZ1oK0I?=
 =?us-ascii?Q?POkbqQpBqsBjsMzNIoUr70TJMdd67DS2Wtoh2bvYk07GZLki26fYLvwfKqYQ?=
 =?us-ascii?Q?u7fd/gThKRd8Z3bKYBHw2kXy7WrJmNz9bvRrDBNInuUOUazeAGa+Wz9VJU7y?=
 =?us-ascii?Q?LyIhGWz+MfFkvs/QwPPwJgFjMJ6bEV8adWelMaRzIWu9OtfvJK1NcwDQpBET?=
 =?us-ascii?Q?0eAVy2nfdnLxTqv9/meI9Z9a+a1mOMgE7vCo/38zRLpreANEJgxRNprYQqWu?=
 =?us-ascii?Q?fkDDzi/8+hPOB6PlS65YJwY8+FR/cCZ1PYMu4X5rjOeumBQ5Js1J+VjBMCHy?=
 =?us-ascii?Q?XIw+YoQFbkQPOSmwfUz2iJRNsfDc6J2i2RtiVwZvnwJrFiIl2/k8dRNg/wKv?=
 =?us-ascii?Q?1FFZYUrWennRmY/CnXph770Z0ZdAbsv+wuLYj2UMZrpiy095C99I/tt+ULDH?=
 =?us-ascii?Q?NbbHQMNerR60KJ/TTIlxEjAeq3f5oTosa8sQrLlkvcNiQ1pAQ2z+JfHo0VRH?=
 =?us-ascii?Q?wOt6DZ5TQeEqg+PjqX2ipsoq34GKVc14fMBOQ6vSAOCH79q6VHh1wK/hs7k/?=
 =?us-ascii?Q?jaBQ4ynunHp3aeePULB69xZ43A/Grk0kt90xV0kgGPDRhLSMORqI3XAfqlXK?=
 =?us-ascii?Q?LVuTTeMD4iAkeHvNZWjyRg7sTKO9YGZxalLPWiCv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99e3003-7712-4360-ab22-08de390b0956
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 23:14:29.8821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQYKlkrRBfrmsT6lcR1VSsOAM0990VzeJgypvT+w2msgj4rA3POkZAsNHkTSTGFv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6818

On Thu, Dec 11, 2025 at 12:11:19PM -0800, Andrew Morton wrote:
> On Thu, 11 Dec 2025 07:06:00 +0000 <ankita@nvidia.com> wrote:
> 
> > It was noticed during 6.19 merge window that the patch series [1] to
> > introduce memory failure handling for the PFNMAP memory is broken.
> > 
> > The expected behaviour of the series is to allow a driver (such as
> > nvgrace-gpu) to register its device memory with the mm. The mm would
> > then handle the poison on that registered memory region.
> > 
> > However, the following issues were identified in the patch series.
> > 1. Faulty use of PFN instead of mapping file page offset to derive
> > the usermode process VA corresponding to the mapping to PFN.
> > 2. nvgrace-gpu code called the registration at mmap, exposing it
> > to corruption. This may happen, when multiple mmap were called on the
> > same BAR. This issue was also noticed by Linus Torvalds who reverted
> > the patch [2].
> > 
> > This patch series addresses those issues.
> > 
> > Patch 1/3 fixes the first issue by translating PFN to page offset
> > and using that information to send the SIGBUS to the mapping process.
> > Patch 2/3 add stubs for CONFIG_MEMORY_FAILURE disabled.
> > Patch 3/3 is a resend of the reverted change to register the device
> > memory at the time of open instead of mmap.
> > 
> 
> Strictly speaking, [1/3] is suitable for merging in the 6.19-rcX cycle
> because it fixes a 6.19-rcX thing.  But [2/3] and [3/3] don't fix
> anything and hence should be considered 6.20-rc1 material.  Yes?

Well, technically, none of this is "rc" because Linus removed the only
user in the merge..
 
> So unless I'm missing something, I'll grab [1/3] as a 6.19-rcX hotfix. 
> Please prepare the other two patches as a standalone series for
> addition to mm.git after 6.19-rc1 is released.

The plan was to unrevert the revert that Linus did during the merge
while the merge window is still open as an alternative bug fix to the
revert that Linus did.

So it would be great if you could grab this for the trailing merge
window period.

Jason

