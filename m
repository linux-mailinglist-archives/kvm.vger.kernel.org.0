Return-Path: <kvm+bounces-49454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFFBAD929C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13F1416580D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7405204689;
	Fri, 13 Jun 2025 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AMidsXQE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574A81E5206;
	Fri, 13 Jun 2025 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749831002; cv=fail; b=DjikT0FJexM2kHGVALSigcMvZw4prGxCGJUxk2IHGEYlDwVfi/S+A+WDt/kabf7KTA1N6gHEH8gUu7HzIuXCMN7DS/FVSO1qT9SeqeDMFaG+YNibZVKcxtiZ4iM8EwCfdeIHnZkNkgmLux4VFey1s9wSu/TXCfh5ac35nqfgY8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749831002; c=relaxed/simple;
	bh=/l5vZKrj+4/BsR7xQln+W/0QbrG0fUj1NLSYGe6r9k8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A/k8C4g+SYZXV4g6PknBlkbcZESXGiXcLin0pspedjJKy6ifEZBH+5j9Z7WyIuDkEwmb+A1Q5+gOzgDQRWbaHPJfJj9ZTcx5FstRw6znTh3ysPkgKYMSo24JV0OixOSnVJBABtNA7FU9/EXMu6sUQSK8QQq/It5dz5TToRkHZ4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AMidsXQE; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJsHgPsgwLm9FIeCRS4klBIFUjkURvU5josQ5t0rQZGUA5L/qaxUzO4f+8+gNezFW2CbqinzNvlHBANSQIAIUURx9Qy6d0jX1aMXx9Hd+KZd0OHuUuZ5PpBET2lejXoDQXgEfeIjrfmEWxn96yPkAUaN7w/SXILowoxmlHlSORtsHlLenQunjbcT3uImXxmIx/SYlE6Mii0KCJ31o3RytemEMbwC/aOm7eSsXs8X0mcWJlJ7P0GNXhaQNBCDgl2y0TJTerQwZJ3V60NpREGgfSjCV9JsOEAGyLUMTFLGIPq6zIUoApEQ9qwx33EtZbLSpyGvXWR8VwItXktRxTE7AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Me1OK0T7Wi6m3dgbrr+54UjwR+LC0P0OZFxJ4jIYu8=;
 b=myx52dP4ZETBs+AZNL4ZmZpSNo1kzmV7zg6DiSYbDK2ZCi9HnOjQfFc1bVR9oilTUpH1TuUQDA7kdpnEn1KCtSgPxZ0HciR6eyUQTiAUEZHrlQH40aGwnEN2G3QTpC2ys0kmTnoS5YMoTAnUMxpJsD+6L+pz6NFIywnfvWYe2eqWVvyF9/4KIJV0ZpPklZC92LGhauwvVRpmMHm1XjDjs1dPhIlOc7lsXrnuJRqwd/eo/H/CxGQF4d6U67NhfotW5251Pz6TBAurXEfo1pJzqHzWfhV8WD4W+zBqIk1oXkQTWskLppzSOGQCp5gJ/MF+rrtY0PmvG0rBOGKxb3hdWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Me1OK0T7Wi6m3dgbrr+54UjwR+LC0P0OZFxJ4jIYu8=;
 b=AMidsXQE+PtbF7fakUfXZK11zSc5ISEIrFD8R5PaH8gPz7dncqTupXHJr387vBzu0HyGpYyfIdh4KETZ+FfFlW+ieVYNhidG1IkYsgCrTMsq2kNz0II7RE/QwE5kM2He3IldtBMGbAtKyrUYeqkI4MXwtNp5RJkP8rjVSnLb8IJfPfvL2Xp+TTDQWcYFYcU1rovRtXGZijjdKvYx/W9oQJ5Zs9IUsFvjiIyBDdu5+FVGrRKBiJgSKVnQuZzxvdoiyyjzqx8tnAMtXFDoKxzYcXGKqR0ULGUH8KiaLFGWO+buRZQnGGI+/rKAoDiHol4sFO/Eujc4NV99sl2XpWv09A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB9545.namprd12.prod.outlook.com (2603:10b6:806:45b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 16:09:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 16:09:58 +0000
Date: Fri, 13 Jun 2025 13:09:56 -0300
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
Message-ID: <20250613160956.GN1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
 <20250613142903.GL1174925@nvidia.com>
 <aExDMO5fZ_VkSPqP@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aExDMO5fZ_VkSPqP@x1.local>
X-ClientProxiedBy: YT1PR01CA0046.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB9545:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef3a2f5-9208-4626-e607-08ddaa94be62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+wUjEt9aykkGDcvS7gCVHrqQdq77+XYOOlGpvvPaH2Mp5623avr73PbIgrpt?=
 =?us-ascii?Q?E3b4QrqHPAlOOhUln6SGaXyKj8UcKMtuMZ7URe9RErvrMCZslwfUtPGVp/FX?=
 =?us-ascii?Q?V5LofEWbznVdwmlh34m456HCDbEl8QDfBRzphCeiUwEy3VjM9jLpwwTXWjoC?=
 =?us-ascii?Q?j+RAaZVmUBFu0DFn6b10fP2yY2Pq3mIEt6O8Vw+PPRW1RrUZDczQ2rS/DCbE?=
 =?us-ascii?Q?swOW/tLGaxMm+5d269/XQOpBqHAbW5SW7bWjzT/kG0m80fDgDnqJA+UxACQn?=
 =?us-ascii?Q?CpYgXXNThTZKMUzVuIPJSZNhULYLVhevOM0ssH+VhqCaLv+Mziy3l+kbb8zD?=
 =?us-ascii?Q?sb0FydIi7vnN10pzwqQpAxjzWlCIMZxtF+bdHNvVFpk0IzvrJIYYbbHjom9b?=
 =?us-ascii?Q?TfY/jJKsusL/eU2CJJDR43jOibh7UjSa/vhvpTowaAGkuBZYer/w+Ry2iZnV?=
 =?us-ascii?Q?qoV2B3xSiQqD9KeJYPFUkVTk2nfut8/u37LfH2yXMoiuGMB5pGrcgbwYHsZL?=
 =?us-ascii?Q?q8UZGQUfN+rf9w0mQAhh+GtCd7ht/1c9sx+lVQfdIz2OOPpoR5x0seOl8qo8?=
 =?us-ascii?Q?qf/atvWIniY+tdS+NSpKUSxtp7Vvzf5ot7ZywgFw1uZJ5aHCwaMcErO2k1Ty?=
 =?us-ascii?Q?Jo36m/AzUQMa5HFF+3bOw3GU44ri5a0v6aDw8wuRLM4SzKdsvauRAlpPNUxN?=
 =?us-ascii?Q?H2ab9KC4Z3dEWt7pyRjNbNjAHreghLw5NA6rWR2h32AZWvsjEwagcwV+Tqzf?=
 =?us-ascii?Q?XWAdwCnoBevj7mWYh29QFbjybXniPyYVnC2H2sogEiYtOessw2E5EfXQRyoJ?=
 =?us-ascii?Q?irzEGda6COcPVDBLIU8OUK0aFEriET8YcvvL+qysZ+4MzU1Mcv/vp2yReHB0?=
 =?us-ascii?Q?uwqMA/JJUZsdVCFrQntHAzoHQ3gmi22Mybs1/CwPCyDdtuqR3OBfOe3jmQiq?=
 =?us-ascii?Q?YI/Cr6mBgw6YdeO0v+ZO8M/OlekVfXHhy2k4gu/eeUPqMRQO6yHMD1DElY91?=
 =?us-ascii?Q?4hcIC/DtWTkgM9lT7t6h8OWcb6JKYpt0gFhsIiYvu3e2Y/sPDWNcNItz3f1z?=
 =?us-ascii?Q?qvEYZkfx8VSVxWyybIGuL2f+Gef4XhZ5ifyENFA19N+gX2yGhN9NcR6z8S3p?=
 =?us-ascii?Q?4ZikYQrBOdy1AQdYoTxtZjBWPSFinYv0wn96VyhfOjIJx4vYjv9xKC6Z69rg?=
 =?us-ascii?Q?wX5zFDTHDuVq8bMi6LgacSipFIkEhxw0VjZ8UPpMUUUfpIilVTMtps/l0KoQ?=
 =?us-ascii?Q?lljD9RfJkwvfTXVqlTDz5YZ8pzNh0eZF2mwzVwO8o5Ovd3JU5APHnVGeDIIj?=
 =?us-ascii?Q?2UZDuAvOygafMGtcfa7zlUAY5uG8P94BAHG39alFUnKatdEe/fdX0QMgEj9y?=
 =?us-ascii?Q?rYC3uoqGx/qmBb9ybT1CSsDV4njUx6QtGPKHxMwErviM0HyLGGGC4/xtJ1Cg?=
 =?us-ascii?Q?UUzdXm6UIic=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S3nye/4lx1UiXEBdo9Nw9MAdbI9o4KawR//6hzHg5kSLSoySStJtabUb9uvT?=
 =?us-ascii?Q?ADrJ52ehjfUnrwX/PydfPk8tik9Nm3TnmzH1miC1J2KwJ6a94QTJ9dT72f8g?=
 =?us-ascii?Q?BJWz3O1bdueW1PMpVizfCzGt5AMDFiWh3+CCHybCihuNFcTIkEa9tlQhhtRo?=
 =?us-ascii?Q?2fqhMTnqu5mfTTKoWh1QjTYpT/hZhZrMdWiUueyB83u9ShGErt5vfeaJVXR/?=
 =?us-ascii?Q?Kf5iuQ7i/cYXuZJq/kID0TJEc59q0pm86+EYnVCwpQrTu+LZuSqLdMkkMi9x?=
 =?us-ascii?Q?6xHRq3Mjj6uNMIwF4icQB+qTrWLJ4UA5+amIsbVAroXqQ9nk3dXV6bH1YtEP?=
 =?us-ascii?Q?gWhp2iXmMfKhyWBCJZzwQJlZNr49Eq+iQhviEn4+6dtGbFVwCxdUfwDtIZ5m?=
 =?us-ascii?Q?ihDA780falGgrqsGQns508rzkmaxLr6BBQDK7JHKKjlAm6dq60UpSRzYtHv2?=
 =?us-ascii?Q?DcAR3QK/+2hJ3OsOSreiHiH9bzdsN6pkSHaDnX0ZzArx67erVKHP7mpCk/Kg?=
 =?us-ascii?Q?U6WUuqeeUfKHHNjMMFnGx543kUkSMaEiB4eVAfeInzDQIqP3Ov7XF4z5G64q?=
 =?us-ascii?Q?kK5u656oVWByvpw/wq7pbJP1K8kTykAPkxzc0ffQT+JbNRQUpS65TkqzMmT4?=
 =?us-ascii?Q?C/vTp9FqEMhB+4Xfc8ReLjfMJ0CgQpvDUCbDHs+c+g1Ntq8tYSFoM0Pz6zxS?=
 =?us-ascii?Q?mIFXOn4WJKzkKukXlHcWP9JYsRN62XoGmA6t5Y2Fjnwa6gI7WDdNjGkYm2DA?=
 =?us-ascii?Q?E0AluD7murfvzswDamvC8JUH2Rh3gRDfj1B2tNPfzhbEj+uvVl4UPiSQmvNK?=
 =?us-ascii?Q?5mb49CG4J5XEEY1AP8obB1+nD5aMzDgssRtIs1M8reVsYgWUQjw942t0PzX4?=
 =?us-ascii?Q?hYAFdPHpTQydwXDfkRLDAeOlu/qW0/n8iWA4LZpPvIonxyYx1JGiMHkK/AsA?=
 =?us-ascii?Q?SWFqcy4807g5FQi1frQD14vf1zVxxQOgv27eDNggz24A70ySEfBFPynquX9k?=
 =?us-ascii?Q?m6kncQYhySOBna4FDPOxFOXkkV8zH5oYfibrk6L6k7igjrVrQKA0m5SncYod?=
 =?us-ascii?Q?oeOvgx2b6z3v5/hlc234qB9OiST9JnAvFlCKLHPEpgkgqEQhiJPrGfA42azQ?=
 =?us-ascii?Q?EdnazecRs4+JZ6FzLt95Z9kRGaicJTaD/6q9dsCvWPUBhTdWm27Dxn/qSxlI?=
 =?us-ascii?Q?XF20/wK5JLpsILfNgYvn7SfZpx9kEqeX/mAfp2Q6T0+YSeumPTv3lwAEe1H8?=
 =?us-ascii?Q?Vo6xGYvflI7zD0z+fEO6auIbZsYm9bmYmgT7zJVnC88mS0NIkEQ8/P3lxOD0?=
 =?us-ascii?Q?YkhgM5oSKrWOYmnYqi3ETNWgUbPW77w8EWZFhHOhbXG+xTyoKKIOSc5IdnV2?=
 =?us-ascii?Q?gPiSuFMS/p+vWhQNh8xQtoNl7cwtBMezd/8BRDj0NjJtQYnZJD2hbGy5mXhq?=
 =?us-ascii?Q?y/NGJxzDi38PH/8/vikzbLbxZmaX4tsHDYl00Ebmrpy8fO8JQP3s6disohIV?=
 =?us-ascii?Q?k4wQh/9BwYABlsNxzg+3UY5fmVshOVXvzYlTIryfsmmU0cQeD0Eu6hfZBeXI?=
 =?us-ascii?Q?2/NQ9J3qrjfPQ3PiI3oYwv1+DRYKuM7TKsndBvAv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef3a2f5-9208-4626-e607-08ddaa94be62
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 16:09:58.6106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BYxuf79BUkpewVrO7kpT2JZwScRBhNqBjIFeTh8E3jJXcKke99+Fm8LioNduHDqx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9545

On Fri, Jun 13, 2025 at 11:26:40AM -0400, Peter Xu wrote:
> On Fri, Jun 13, 2025 at 11:29:03AM -0300, Jason Gunthorpe wrote:
> > On Fri, Jun 13, 2025 at 09:41:11AM -0400, Peter Xu wrote:
> > 
> > > +	/* Choose the alignment */
> > > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE) {
> > > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > > +						   flags, PUD_SIZE, 0);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	if (phys_len >= PMD_SIZE) {
> > > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > > +						   flags, PMD_SIZE, 0);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > 
> > Hurm, we have contiguous pages now, so PMD_SIZE is not so great, eg on
> > 4k ARM with we can have a 16*2M=32MB contiguity, and 16k ARM uses
> > contiguity to get a 32*16k=1GB option.
> > 
> > Forcing to only align to the PMD or PUD seems suboptimal..
> 
> Right, however the cont-pte / cont-pmd are still not supported in huge
> pfnmaps in general?  It'll definitely be nice if someone could look at that
> from ARM perspective, then provide support of both in one shot.

Maybe leave behind a comment about this. I've been poking around if
somone would do the ARM PFNMAP support but can't report any commitment.

> > > +fallback:
> > > +	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> > 
> > Why not put this into mm_get_unmapped_area_vmflags() and get rid of
> > thp_get_unmapped_area_vmflags() too?
> > 
> > Is there any reason the caller should have to do a retry?
> 
> We would still need thp_get_unmapped_area_vmflags() because that encodes
> PMD_SIZE for THPs; we need the flexibility of providing any size alignment
> as a generic helper.

There is only one caller for thp_get_unmapped_area_vmflags(), just
open code PMD_SIZE there and thin this whole thing out. It reads
better like that anyhow:

	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
		   && !addr /* no hint */
		   && IS_ALIGNED(len, PMD_SIZE)) {
		/* Ensures that larger anonymous mappings are THP aligned. */
		addr = mm_get_unmapped_area_aligned(file, 0, len, pgoff,
						    flags, vm_flags, PMD_SIZE);

> That was ok, however that loses some flexibility when the caller wants to
> try with different alignments, exactly like above: currently, it was trying
> to do a first attempt of PUD mapping then fallback to PMD if that fails.

Oh, that's a good point, I didn't notice that subtle bit.

But then maybe that is showing the API is just wrong and the core code
should be trying to find the best alignment not the caller. Like we
can have those PUD/PMD size ifdefs inside the mm instead of in VFIO?

VFIO would just pass the BAR size, implying the best alignment, and
the core implementation will try to get the largest VMA alignment that
snaps to an arch supported page contiguity, testing each of the arches
page size possibilities in turn.

That sounds like a much better API than pushing this into drivers??

Jason

