Return-Path: <kvm+bounces-49545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CFCAD988A
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 01:17:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E0A3178045
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D35428EA70;
	Fri, 13 Jun 2025 23:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="izuF9FLj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49AD2E11AE;
	Fri, 13 Jun 2025 23:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749856623; cv=fail; b=ltlZzrrPXe/hvtQh4pMO2eXS0xgp5amzZ/I4HOn1j7ZXLfsoueD2tF32IgRXkp00YvfNdocai2X4tn4F2A49/181KclwydLPFOhSb9Nj8CSnmDuv9v5Xu7Le37HnRgIHuvEPiecV9nn3BEa2pvDamGsGsXfntI6R5M07D8VTkbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749856623; c=relaxed/simple;
	bh=bSvnpB6zJxHrEoHHt28QSkZTYAm/CUhVT0AL3HUbuCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=moIyC1Rxy8Ov2Nxdan8t6w/R3hW02jdX+cpz/LbDiCsgFRbnkSUB6M+kxvDPfEwGXyIkhlYwsCW19XzFNjNfQDBTUsGIpkQpuRQHmgzmF2HUcNkYoSV0KtrI6wYVvOarEUM48T8s2T4mlewfp1/hvnL9SnpFvsW3X8+0ypsN5Lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=izuF9FLj; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MfJfvpOuL0TexNtwGXrLJwOFpGfK5tojOwvUVLUGqGCqKiuPOELv03Sa2SU+CL14BBQkApURc/nzoIHq05ThCoGvPu1Pb0CJCldsKu7N6mBGpTKRlic11q/rwolmkNHzn/DiHHfymOu4qAZUQPWgx6COcITwXA4SJyB1cXxFT3BnpTQAm8fGfjO3POpoOuY2YsWkQntQUEQ7gSYQCeHS/id2O6dD6TBJgCDqHnRpRUOh0Df7yI/Wn0NM7KFU9b/dac/CQTvIhaGMUnHXVd/TY+VmcgJwVgWwCL7dxOjKAa5xqdkhfZP3iHX7gN+AbbDzNrHge7WKshR2XQEQibf9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37ImgQf0vLy09qa2BuKPUxvHIpCkhSK0+XwtQemUkdU=;
 b=WX1VYb7atsK/P74CXqymuGynNaUANtRi5zCK6oMUj4GqPMbL4XubRoWU/uz7cZCdXlS3OfRPipKrX66HeJKvsHA/OfUCZjnOcv9rIiuuX4v8DhR/m/03IyWpx+ufvh30T7vHbiw0pvgWkhmMgeyNkNNXQDrTnPm0WP+Oe9LXsAUabVjUngpFHqkd4LNRrsNamhh867cTnhh2W7Ij28WUre9nj9cQtTqtjqjZYRaMLBoQo97warQN1+rnzYB6x211kX6Mdp9E90XZdzg2vjW178zbLYrx/oUSO/TUEKefQK+8Fe0MIIc8jh5ZkKRvr4DNeSL9Y8HvweiFE2LOHDGaRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37ImgQf0vLy09qa2BuKPUxvHIpCkhSK0+XwtQemUkdU=;
 b=izuF9FLjj3wuCUKcIUNTU8WGn2cvT2Tt4FjUp+57M4VO8d1skXLau+6+rry+MlFaLdhrvBV4eIGiBazN2C5rz2npGKnZFf+x5P+xdaQkZeta0zFEWLekrbmPFqoTOZSf/1/9RPhRSJAyAUfY5cepvZMma9pz4JP+2Db5ew3cKZW6foyijMI5KB7420qzYo+sxpy9nPRUVZKqpkBhJfvse9geNl8dMEr/oXlixW4JwPxy6vkGVuyo5gF7jWlvrOazmjmMHAA9tteuk8TxDeXmasK5763ri19aVB8extaCDsYSscxjoPhw23+qZCeXVmzVBfuhUbE6quROwKT5cgqQ6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB7877.namprd12.prod.outlook.com (2603:10b6:806:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Fri, 13 Jun
 2025 23:16:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 23:16:58 +0000
Date: Fri, 13 Jun 2025 20:16:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <20250613231657.GO1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
 <20250613142903.GL1174925@nvidia.com>
 <aExDMO5fZ_VkSPqP@x1.local>
 <20250613160956.GN1174925@nvidia.com>
 <aEx4x_tvXzgrIanl@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEx4x_tvXzgrIanl@x1.local>
X-ClientProxiedBy: YT4PR01CA0412.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB7877:EE_
X-MS-Office365-Filtering-Correlation-Id: c3d74319-8a16-4fcd-8c90-08ddaad0652b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RK9QJuAJvu4UsTO9zbyuA+yonmzwOHuO1ShKFlBU3qlEkkQDbG+YuQ8tM+sP?=
 =?us-ascii?Q?/MlUiU+D+95J4YccsukRkxS4MqTIdFi0YmGj7SVj6HXstlIt5ebzMFslst+Z?=
 =?us-ascii?Q?mlI0ZsVxbnofUMMn5VD1ICrDgpcuttUmBaGcrbIiBECPZx89KJTOIzC/g5Zc?=
 =?us-ascii?Q?5Bx56jHknEXY90mntSZ2YlETFUKX/KqUBqlrieUv+wqhAfwQN5cXmgXsEdFK?=
 =?us-ascii?Q?6JZXmpA7pNNZjFO3Rc5E1sU39RdhaNLKBvsJOpVDgYyYIc2JNO87+VlfEFjU?=
 =?us-ascii?Q?WH8QK5FHPuI97m2HlZHgEKNZsj6hCshgzhbSg10WQVfb1wIB3xCFES+sysfI?=
 =?us-ascii?Q?55nV17l6aN3VknE5n+LxcfAmTdzX/bBtlnWV3W5ch5dbOonjjVftHRsekd/F?=
 =?us-ascii?Q?IwsOzSBVb4AxDAaEGHw6PlwudJtlKDtFhgUv7FOSqgeRuehLg2yxH3S6I8Bc?=
 =?us-ascii?Q?Y7FhI9/po49Z6OnixrS7zUEmT1VmRskhOAY7FhR4QzWy6G92M9FasVaXOPrE?=
 =?us-ascii?Q?AQf+wn0hOCIXT4EP0JodsYaupREoZ5CoMEPkPpPUT1XVmoHdb0phPlvrZ9Qf?=
 =?us-ascii?Q?mX462gNl69y6FfJqEUBsI8NKxCwiX6M/UXd0rs1EbBmrphg8O+VExTsfUnZM?=
 =?us-ascii?Q?S4a59gtzOt7cN48WcAa3UobnPqJXmndb19dTzPQN1R8x9gdIeYsogeU3Sgtz?=
 =?us-ascii?Q?yoz0JHG4CxJtV2NqkI5OaGhGGQ6bDhC0eIpH4Ndkfwd8/7AL9pdY4wCls94H?=
 =?us-ascii?Q?fj/Bw5bI/wRgDUqwFrJXpqf4wegcCJHdARp14sxi+CMaO6fyS+CcC3WC7HJm?=
 =?us-ascii?Q?eu0VHbqNzliTHNmzHIWhos5tgzzZBTV/8JQHT1v/e1w+I4HPLnUsre+wQO/j?=
 =?us-ascii?Q?dul8UCPuvFwf2r3ACW7DnESGesnIA95tNV1qvrBSeIg0UBNyHJW9SKgw6R3t?=
 =?us-ascii?Q?4bt106jmConTfCgj+H4qLTXO9uViNKqpsdyPmXwZKyDlSpGmhC5QpOGDlUJh?=
 =?us-ascii?Q?U5M6ZiLgXGUjsOHuCLMAT4X5IYrWOSUwA7xEFHhMSrIoYN89C4RVdtMCLFYD?=
 =?us-ascii?Q?GueBRg9ow6v/wVnNIHITkN7/nxHM8gvACd1YYGudS4RFbGKX7rFh5bP+gHLD?=
 =?us-ascii?Q?R6scGhZGzn+fSCPabDdRg2pGoP68+dnbm4ssBjw63MiK67oENrTUOfisdRP4?=
 =?us-ascii?Q?MXrhpVv1S/tFgeu3klu9WxuDFo9kdJ0k49DF83Y6ytazc8e4S+hOcmDE7yZO?=
 =?us-ascii?Q?LBFM+kR/m5yCJujN1wXiKq3LBORQnEEBvSNNqNnEMU9Tjzrz0qA/xa3Ms/Ls?=
 =?us-ascii?Q?lFDbcLu0ntM75CEO2WSWp01kqn0lbKSK/zPBMWeJkKvJpHuPU6vJe5r59jzl?=
 =?us-ascii?Q?licXOTStTTzTmM97gbyKNs0ee98fRvs6Bzw8FqqQD2Z0YI/EKKgrq1V/Qztt?=
 =?us-ascii?Q?3aDcw7zZ9eA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GevDEWb1N7frfycA+zE31fUMo4FA8JD0rk+uRTHW0PZhUGEiDmzkBUclfH27?=
 =?us-ascii?Q?TN9WHa1sh/mzP64YIPlgVABoz5XYrnPyr5oUCNW6YQeTr5fUsrREpkdTt9dS?=
 =?us-ascii?Q?ePDrk12LcNVNX/aH1YHVmur0MO7OWVnWkouPsRSa8eqf+oWqu0jvGkdCBHpW?=
 =?us-ascii?Q?LA0hHXSGYKPjZj8l9CLMaiSozX0fdAgUCVA56SVdw2laFhSdFBzp/RbBBfLv?=
 =?us-ascii?Q?kSOYQfKMo4WgFX/IBUfK+m6/9xIITDoUp15ClJnQld+XtS5V/IZ+vCvhmU3U?=
 =?us-ascii?Q?YiJKcrUgk9MwozaE/Fv/KVes2kiKc3uEUdrBHXwjppw3hpyjzW6BhxrEpFJp?=
 =?us-ascii?Q?CvZdK+wmpl24qvl9uSK0XPw8Y1xUI2uKFBCsuYMk3+wLLQWrgC79ZdGDeKJE?=
 =?us-ascii?Q?2FESUWsqjuGetTYpES8Hs3AIPRDrFsUZwNlDJJWfPZfgzGBeUl6N4q5RsESM?=
 =?us-ascii?Q?wDENMWig2DykNfS67sMmgnJxKeWlFzvMvbvMCI114RDHVO5umHtmL4w56/8p?=
 =?us-ascii?Q?Zh9M04VKoMcRhWdcBbAxd5eC27OZMOVJQIFh+ItfsfUshm9u9IctCY3aY7nD?=
 =?us-ascii?Q?cY9nVPkpn7UJE3mZKxuM0SuEYMCJ5f/PplJh4jl12UuHKCAbeXMQP9pKP1e7?=
 =?us-ascii?Q?aOpY8ZIcrfEQfZWlj+ADw0JA+QWF5qROuy/LpJABuZYdcw13LoytWBmYjWrB?=
 =?us-ascii?Q?KmmGr+fXL1VzuulvFX8tV1zzKEHvqEAsDDvgCwFnV5TqPSkIt5otsxYUV6QI?=
 =?us-ascii?Q?vcXEJDaWpl0VOP6AsNbHcUYwXGTiT5L1XmPfj1fWxzz1Xt4ZsKOH8pK6ntgQ?=
 =?us-ascii?Q?GC6Q6UfqnOQA8to5aCVMcScWwAzCYljhyxdqT1d9Y1/nR0o/uULamkfJNNVz?=
 =?us-ascii?Q?6+8qXkWlpZo0YWEGOjow2zjKfTB5z2ZxLrwYqAIwK35wGepePphAFPUgzpby?=
 =?us-ascii?Q?5v/nVLp7fI1R2nNwDHRXrm2DAMNw3t3VgKbB6m0cLQN5eUlpi9DGV8McMvDx?=
 =?us-ascii?Q?N5y6XZLayB6jkhWeX5/V7n7scuUT4/7sN/UlWjwf2XHIMCQMZP9XQAelIit5?=
 =?us-ascii?Q?Hfh2J0jFp6vm+a/tCJoTWX1XeHMt8Lxy2wMXnfcF1d4lRJuv0p0IvIXdZOX6?=
 =?us-ascii?Q?VbgDzmLuMUclAMqy7zlTfwDhYAyNS59OHg4JnlYkdWuWy1gA+UaNqVg+DEQR?=
 =?us-ascii?Q?tvkWvmpjc0+KrLyh0PxAS9OKl5PO97LqTLt5ADlv66v1R1siqkYMB61Cei+m?=
 =?us-ascii?Q?SCF9bXJLwLi6Ki07tapOfpn2aFjs4MQP8aGLgwVLR22ZaDhcUgIbu+QOmyBS?=
 =?us-ascii?Q?Grc7U8/qRDL+dkaXfuiu9TFQ4a0PYc3ZkQB5itfG4vipA8nvDBskcS01EL8f?=
 =?us-ascii?Q?tEFGCtjLjrPLyYQILbK8hnMTAOWYYQpxZ39JUojYEOqfsHKnbRhe3FMyRcDB?=
 =?us-ascii?Q?WYqrZvMeS485NzXtKoLHeCUraPcmZtAhn+icVa2OIGW0IKRUokYEpZRXL21E?=
 =?us-ascii?Q?MYg5Je7nLz1bODXlow8jSOO2j9C6buXGTlxcABe4avrHoNQdPWlzPrAVczGs?=
 =?us-ascii?Q?mQvktUoLS4GLje4ysADDS8e4/xlfsoUQoJxDSojE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3d74319-8a16-4fcd-8c90-08ddaad0652b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 23:16:58.7777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 33Qc0etUiT4+QXQ+769maTlvaEYpvT77o6+RaebvTZlGrEhO3t/8vvNwGuH93cBw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7877

On Fri, Jun 13, 2025 at 03:15:19PM -0400, Peter Xu wrote:
> > > > > +	if (phys_len >= PMD_SIZE) {
> > > > > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > > > > +						   flags, PMD_SIZE, 0);
> > > > > +		if (ret)
> > > > > +			return ret;
> > > > > +	}
> > > > 
> > > > Hurm, we have contiguous pages now, so PMD_SIZE is not so great, eg on
> > > > 4k ARM with we can have a 16*2M=32MB contiguity, and 16k ARM uses
> > > > contiguity to get a 32*16k=1GB option.
> > > > 
> > > > Forcing to only align to the PMD or PUD seems suboptimal..
> > > 
> > > Right, however the cont-pte / cont-pmd are still not supported in huge
> > > pfnmaps in general?  It'll definitely be nice if someone could look at that
> > > from ARM perspective, then provide support of both in one shot.
> > 
> > Maybe leave behind a comment about this. I've been poking around if
> > somone would do the ARM PFNMAP support but can't report any commitment.
> 
> I didn't know what's the best part to take a note for the whole pfnmap
> effort, but I added a note into the commit message on this patch:
> 
>         Note 2: Currently continuous pgtable entries (for example, cont-pte) is not
>         yet supported for huge pfnmaps in general.  It also is not considered in
>         this patch so far.  Separate work will be needed to enable continuous
>         pgtable entries on archs that support it.
> 
> > 
> > > > > +fallback:
> > > > > +	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> > > > 
> > > > Why not put this into mm_get_unmapped_area_vmflags() and get rid of
> > > > thp_get_unmapped_area_vmflags() too?
> > > > 
> > > > Is there any reason the caller should have to do a retry?
> > > 
> > > We would still need thp_get_unmapped_area_vmflags() because that encodes
> > > PMD_SIZE for THPs; we need the flexibility of providing any size alignment
> > > as a generic helper.
> > 
> > There is only one caller for thp_get_unmapped_area_vmflags(), just
> > open code PMD_SIZE there and thin this whole thing out. It reads
> > better like that anyhow:
> > 
> > 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
> > 		   && !addr /* no hint */
> > 		   && IS_ALIGNED(len, PMD_SIZE)) {
> > 		/* Ensures that larger anonymous mappings are THP aligned. */
> > 		addr = mm_get_unmapped_area_aligned(file, 0, len, pgoff,
> > 						    flags, vm_flags, PMD_SIZE);
> > 
> > > That was ok, however that loses some flexibility when the caller wants to
> > > try with different alignments, exactly like above: currently, it was trying
> > > to do a first attempt of PUD mapping then fallback to PMD if that fails.
> > 
> > Oh, that's a good point, I didn't notice that subtle bit.
> > 
> > But then maybe that is showing the API is just wrong and the core code
> > should be trying to find the best alignment not the caller. Like we
> > can have those PUD/PMD size ifdefs inside the mm instead of in VFIO?
> > 
> > VFIO would just pass the BAR size, implying the best alignment, and
> > the core implementation will try to get the largest VMA alignment that
> > snaps to an arch supported page contiguity, testing each of the arches
> > page size possibilities in turn.
> > 
> > That sounds like a much better API than pushing this into drivers??
> 
> Yes it would be nice if the core mm can evolve to make supporting such
> easier.  Though the question is how to pass information over to core mm.

I was just thinking something simple, change how your new 
mm_get_unmapped_area_aligned() works so that the caller is expected to
pass in the size of the biggest folio/pfn page in as
align.

The mm_get_unmapped_area_aligned() returns a vm address that
will result in large mappings.

pgoff works the same way, the assumption is the biggest folio is at
pgoff 0 and followed by another biggest folio so the pgoff logic tries
to make the second folio map fully.

ie what a hugetlb fd or thp memfd would like.

Then you still hook the file operations and still figure out what BAR
and so on to call mm_get_unmapped_area_aligned() with the correct
aligned parameter.

mm_get_unmapped_area_aligned() goes through the supported page sizes
of the arch and selects the best one for the indicated biggest folio

If we were happy writing this in vfio then it can work just as well in
the core mm side.

> It's similar to many other use cases of get_unmapped_area() users.  For
> example, see v4l2_m2m_get_unmapped_area() which has similar treatment on at
> least knowing which part of the file was being mapped:
> 
> 	if (offset < DST_QUEUE_OFF_BASE) {
> 		vq = v4l2_m2m_get_src_vq(fh->m2m_ctx);
> 	} else {
> 		vq = v4l2_m2m_get_dst_vq(fh->m2m_ctx);
> 		pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
> 	}

Careful thats only use for nommu :)

Jason

