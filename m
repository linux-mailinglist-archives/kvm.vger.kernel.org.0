Return-Path: <kvm+bounces-49606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B539DADAFF5
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:14:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1EB83A272C
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02D82E426F;
	Mon, 16 Jun 2025 12:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iSFnAUl3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6B32E4243;
	Mon, 16 Jun 2025 12:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750076074; cv=fail; b=F1GENvLvqzX1wpCwLk6izrv+QdidzcQRjBq6MxtxsRpiTlZi43kVEKIZ5slnorPwkjBvgX2avLZCcK63N7gIdFoCyJeFO/yTZgoBBtt9GHlfcRCsmAzGdcaKVeygXBGCCsN7diQbFXoJcwYIU2XBe5gZ3LCyfdKKbF8iebBZvSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750076074; c=relaxed/simple;
	bh=Vus9cXTr5ElMaFdYtngr2nLvpIYL1d4x55sdi6MOdcg=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PMSluuLisBEyhMmY3P3gVodmYjhD88YO8di+NcjkHxAk+bpGurRT0NWbrN5JKJjEMopXkSPjbiAtnIxqMri+ZARXNHz4nALfFTMPfOpqd3oXS1n9SUrv6G+ZeQC1fvOEvtyKlSQyrlkjexf7j+OLADlaDtpL606u3aTjqqa9YVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iSFnAUl3; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3HLNKkrAWQ5jq8uV/ds+JgktAmg9mJ4rGofg7XmmmL8/UO0Y6yxtdyl26ZZQBEAX2mBocdSKJ2siH+/wQVkYzJ/7kzRgKbzZjlfyvavQPTf2+xhltBcCQ6qLUi7l/L5rAzgJkKgX1mwrkLHRIXtNdOnKuLqrjMAYwxJoIwg9EDq66lkToHSO0q2rmOwLw9VlBCTu1DS9ZV1Q6m+Y5cblqYgOHS3F6qrCNwVXqsfCHDzjSQDrFd0Fl2X+pLdZtRT1mCmqbpeudFHX1zrYc+sNB8Um0qxzH0mGINPhYeY6V0AStVGcakjPlk3Tzhs2lG7NOPwmYNxWdUYpVfki1FeEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NT1n78CsGEHRayP4wioFdfZVorjtAGQUMEZch4XyPo=;
 b=G/kVuq9njQAwf5m/tnoO3WuqSTOieiN5cSls4d7nZWDRinYODQWpGU/5OOfQ7gYQYTWrIH6AgMN2Y+TaXvQ+NduTIysLjpGlNlgv3u4P+ySXVkwSDo+wC8hdaS5LdKTdneLkoJ2cVhnudEWvcBjJNbjUQLs4GI+WtwMJAWJA3KTqaL/lhNcbfyfO+VPxUjetLsnbMudi7ge5fbmE/TNbTC1+RuZP6oTtKcUyUqiWq2auh8G6VmWZJPVgcMGdxm+SFEGdFbuAZqMeymW889H9c6uQzCw/H9ZYOgc+R5Vyk97uIz8QurTP1sk8VcwsqyKyxwqNr4J/J7Z484SVDiuLBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NT1n78CsGEHRayP4wioFdfZVorjtAGQUMEZch4XyPo=;
 b=iSFnAUl31wu0p7nHzBmk8DPsXg6hKGpEXUfU7GZK75gfGUMnEc00hNByZW6QnFGS1/6IdWm27SVRcMQyeft112TmYpJZpFoLTvBTNyTRljI0CWvpooHpgeq5TFu/WjybFQx76alnX0Lmd1JLSD9EGw//CbPbD1E5bxRvLphvgdprv0vRanzaH6WNeDGURwzuRFwHOHT+NSiM/lVfQMD3jeb23xpoNkzL8AjiZWs08Ru5DktfXG44W4P/Eqcaz1pSQvFfxYuCpbDLMmJ80pSwru2+/SzCAyi9R0I/H25Is41KZuV3vO2rSWIXa67VEN7Dh5SqgW8j+pA7N4bnMQfaUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6370.namprd12.prod.outlook.com (2603:10b6:930:20::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Mon, 16 Jun
 2025 12:14:30 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 12:14:29 +0000
Date: Mon, 16 Jun 2025 09:14:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <20250616121428.GS1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <77g4gj2l3w7osk2rsbrldgoxsnyqo4mq2ciltcb3exm5xtbjjk@wiz6qgzwhcjl>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77g4gj2l3w7osk2rsbrldgoxsnyqo4mq2ciltcb3exm5xtbjjk@wiz6qgzwhcjl>
X-ClientProxiedBy: YT4PR01CA0129.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6370:EE_
X-MS-Office365-Filtering-Correlation-Id: 249eea7c-dee0-4216-a037-08ddaccf5820
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EpzRWxQThA1G7h377EuFPLfVoOLVVtPLWXeHOnqOQ0lHfAT/AmP7NnwJwRs/?=
 =?us-ascii?Q?YbyOfBDtS2uNXQn9cdhY/oAx+ks15a2xKH6+ztj9pzIqfiCACCjLFtDSxlAP?=
 =?us-ascii?Q?/tt98qdbdz6bMpNJXqnWTNPzF7SfeoP3YCl3JH5+ELa+A1LG+rQq+mU0vVha?=
 =?us-ascii?Q?kQPmecTy3iMGHElP+NNbelWHYQETOOCWC6pTxVJmNy8qINIfQoFMJt99m+UZ?=
 =?us-ascii?Q?k6d1FfYjk5sOGlr6lQ6D7OqRC48UlnHDyJF5h9QjBKw0g9Fje3zjomrhsbf5?=
 =?us-ascii?Q?UCr0SJAY9ZldP5KAzV8/JMtxKhjrsadIdVQ/+tVWHF5G8xroNAy/4dB4liBX?=
 =?us-ascii?Q?tvWq861BdeiVkFmpTB0Cwns00cTW++tZVY3yD4rP+jwBb9J9ScgLBpP/v3sI?=
 =?us-ascii?Q?ph7bkIaf8/125AJsFQCniy7kC5AZfxLUHhW6BYs7Leu5t3XsSJ+ygGNlxGfz?=
 =?us-ascii?Q?a+GwEffDMwFRDxsFyxbB8Dmn2WQsAtSxf/9gms+ziSISNHURsyBRjykZT0zd?=
 =?us-ascii?Q?Tqh46d9a8NQjLNx01l65J9NN9+qg5ZYJaEqH0Ah3e2S/v9dUU08vJBpxr8JQ?=
 =?us-ascii?Q?kSmVLstI8tTbHq9JVCkna1FfY10fuAlfry7Pxcs4BEsa7E5JSJ89OhPXvaNf?=
 =?us-ascii?Q?B/U9Ngqr9Vr2WQTxyVinpBQhYXAIlVLh89NVSDCN1zTMxWG91bIPioP6zKmw?=
 =?us-ascii?Q?Ps1M/E1oMyHCkIWwTIB3tGlNSgKLKA7RuS+n7mHIaOufpLLvIiszl2t4G7vk?=
 =?us-ascii?Q?T1wfV29lPxW9V+AYZiDw7uGHrLKQn1yir6fjkVvZibYzJtkSRQD8LpotjXZj?=
 =?us-ascii?Q?ZyXPMjGlKyRb+oDT4q3bFbqjYlTYdmlDI/ki4SUlXI6fGxOtxJQbMCY29yzb?=
 =?us-ascii?Q?5pqpSdFNLXcZFBOCyrUocJyveLFnalS18DJg+bzJ1cV4kMzVTUPc/RUVJd2X?=
 =?us-ascii?Q?/eUqY7T1Bl+kfbaCIoAo+D5PXAv4s5vPDlqPQVNHtcdm7TgtvqUuWoQ5MY3i?=
 =?us-ascii?Q?KbO/89MbGnDy1qYFO37taS9YTHJsy2+CvArw1atZbk/wCxpdBSYNqKCJoWkU?=
 =?us-ascii?Q?yEYrAYni7qUqZABKUIsaYuKlLKfbw02BmpfR+Xqoj362HgNAzbyxqTpCMRDd?=
 =?us-ascii?Q?ACD6TkW9df0zgpRIs2d9VuIqVXgdIo7Blxs7qlMkIPNXd3y20t8Q7T5MvQS/?=
 =?us-ascii?Q?dFjLJ5ipjMZo6cHqOVsAOkzq+F7vSRTjlXT/zBL8C/Z5zVOctJuiCJqGncVD?=
 =?us-ascii?Q?OEtv4SOLeFJK1LSlsOd/M5qzAENQ92Eee523DFgq/SKi9nwbf5kxvUj4NxHj?=
 =?us-ascii?Q?0/LG9B17yKFCAepC/bJqlD129xLq43NVNQ8pYwoHqqsvOBo2obx2MhejNht6?=
 =?us-ascii?Q?+7+eFFhODv1IYjDtIye+nSaLF96XYCk75YRAazTJNVhCoZ8UE/Xjh6ys8e9v?=
 =?us-ascii?Q?1s2nEE5qWsAp5iCYxokTrhtTfQKAAQ5bb/qgth8LCO0jcyZupeBRMw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T6wcToCBhGV9pBUUidx7rxT3XHz4NADOezjYviqVOKkuVC9jp16Nujqx8m//?=
 =?us-ascii?Q?Ipih+gZdQVNDtEEFhTL7SgZDdkZwkwNDBAnexJBXjciBB/6qhfLtF7vUVm07?=
 =?us-ascii?Q?iGq6hSQWo+Y37Y0wKRPR4YEuhNvK9076BE9Y0EVk+8pknSvht8PY5It+J610?=
 =?us-ascii?Q?2RSlMIFViwFIl8/81qY01FaAJ2waOXo8GqhNOgKKvIFshS2aj++n43n46uyh?=
 =?us-ascii?Q?szfpWAO3MqtdEmbskDe3lo2iINNd4plWY/wMabCWgRkMR5P2mSA22V4Lv6/7?=
 =?us-ascii?Q?ap0fGk/oqS0B+Ci9Fu3ONombSpHFF42Mqeh02w91lKW3YJluYgaKQfS+nmp9?=
 =?us-ascii?Q?xWRrJooh6Bfpm/1E9TpcRu7d4r3QQVIEucTQruJx9B5sDBqL6FmS+POfGRjn?=
 =?us-ascii?Q?7Z2Q64X1kWklOk7uJ7BamI+gNg0yRbgQ2u6tHsz0u1oQO9ibXXFyn26KiiJP?=
 =?us-ascii?Q?MGKgapYaauiWEj1MHh6P6esUnshBKEIzggHL1RaYnYGc4fHw01r9j/+LaG+h?=
 =?us-ascii?Q?CA2ncI3uWL6jmvvIi6XcMSvA4QiuK5qlVvISty6FUkzRAterPFWzvr3cMMzk?=
 =?us-ascii?Q?j2VWDRWS3/9o+DG5KzISaN5Ci7TQmn+MUf3xgZRU+Im7AWwCZOE77T881Nby?=
 =?us-ascii?Q?hH64XXxjxzUS0ny6Btj3NjsPcy6vXyk4E0gVi1QFSAsoRI1uXLj7YBrbeKDt?=
 =?us-ascii?Q?V/xQSAhomqzKV38L9NHVZmHse8m8zjDc9+e8Sd32XXIX72oEwizT2VrgtTj+?=
 =?us-ascii?Q?c88XPKko67b572uc5+D/Yp+ndA6+ZDUjrMWfVTJ6dF8g5hMVUjvtLYHi51h4?=
 =?us-ascii?Q?qDTQu8BCvlfu6j2z5r1x/QKFZKKIODo6F28SDtDELNzcWJ73EkWl7uLA8L59?=
 =?us-ascii?Q?SfN23O3fHdvXfcEF+jxYBZp1oIllYWsFPhHHbk3gg9+a6uc4IvD6BwHjUwBQ?=
 =?us-ascii?Q?+x14iZDd2LlVg5WVn58m3u5K0dRCrQwUW9Loy5ot1dKiDG5jWBUH7NMDUG1Z?=
 =?us-ascii?Q?DAM6l3VkvuYmuo23t6ps9ex/sIXFIjUWePMGq7Uu14QhyAM03J/jcpkwNSTk?=
 =?us-ascii?Q?2y1MIJPruIlkQMaSOf0KgVW6XWPzYzH0RQehTlCDTtNglXWsuNT2QygshDVZ?=
 =?us-ascii?Q?xjeTlg0hAzUBNjORK8irckuqbv+974Q3CzM214+KqWFCwo7qlljkvtm+5Om9?=
 =?us-ascii?Q?HX0FRVBstkyBTu+WQCfZRZWFYfEHnoPbRdyX7q2sAv8btRTfSFX0KRo5ians?=
 =?us-ascii?Q?oKHrQIAkyrl0fJa2JFVrnpbYucFC54D7YRYyhcCojdlJvRIXbtut86s2ICw6?=
 =?us-ascii?Q?O9rRQxHs4B/oCasHFQNOK0Na11DKD40BfAnv5eRHX8V9OiL1Y2JxEXRndkjY?=
 =?us-ascii?Q?6HhQ3IHC9q90//z1K1bGi3y63aKsxspxkMXUr9upIC0wZg90ack556I9iYMU?=
 =?us-ascii?Q?Mq7oSmju2t+AehZTo3SENV/hjPFKqqLTIWmJcchOwkQQj5pjSB5lZn7tKkAm?=
 =?us-ascii?Q?/3ah6GtKLHT11zdwouce/8sHUWk7Zn8USSyJ4VlF5bdSn7Tz2MU2tny767P8?=
 =?us-ascii?Q?5fuBU/99w7X4+wPUS5WbQl0psXJEqoxvFIcisnri?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 249eea7c-dee0-4216-a037-08ddaccf5820
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:14:29.8667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnuLNdNjyxT4Mp6IFqg3hAM6kjsb4pEienW2ngyCsoOy4pXwje3vit9hpjGrmH/T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6370

On Sat, Jun 14, 2025 at 01:23:30AM -0400, Liam R. Howlett wrote:

> vm_unmapped_area_info has an align_mask, and that's only used for
> hugepages. It is wrong to have a generic function that does not use the
> generic struct element that exists for this reason.  Is there a reason
> that align_mask doesn't work, or why it's not used?

I had the same question and looked into it for a bit. It does seem
desirable, but also not entirely straightforward. I think the arch
code for arch_get_unmapped_area() needs some redesign to produce
the vm_unmapped_area_info() that the core code can update.

Unfortunately there are numerous weird things in the arches :\

Like x86 shouldn't be setting alignment for huge tlbfs files, that
should be done in the core code by huge tlbfs caling the new
mm_get_unmapped_area_aligned() on its own..

So I think we should leave this hacky implementation for now and start
building out the generic side to call it in the right places, then we
can consider how to implement a better integration with the arch code.

Also, probably 'aligned' is not the right name. This new function
should be called by VMA owners that know they have pgoff aligned high
order folios/pfns inside their mapping. The 'align' argument is the
max order of their pgoff aligned folio/pfns.

The purpose of the function is to adjust the resulting area to
optimize for the high order folios that are present while following
the uAPI rules for mmap.

Maybe call it something like _order and document it like the above?


> I also am not okay to export it for no reason.

The next patches are the reason.
 
> Also, is it okay to export something as gpl or does the copyright holder
> need to do that (I have no idea about this stuff, or maybe you work for
> the copyright holder)?

Yes, you are always safe to use the GPL export.
 
> The hint (addr) is also never checked for alignment in this function and
> we are appending _aligned() to the name.  With this change we can now
> get an unaligned _aligned() address.  This (probably) can happen with
> MAP_FIXED today, but I don't think we imply it's going to be aligned
> elsewhere.

Should be documented at least..

Jason

