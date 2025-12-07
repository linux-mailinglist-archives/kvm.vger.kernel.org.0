Return-Path: <kvm+bounces-65474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F08CAB7B8
	for <lists+kvm@lfdr.de>; Sun, 07 Dec 2025 17:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB7CA3013EB6
	for <lists+kvm@lfdr.de>; Sun,  7 Dec 2025 16:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 754E128BA83;
	Sun,  7 Dec 2025 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WKLdH/lD"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011011.outbound.protection.outlook.com [52.101.52.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BFF2877F4;
	Sun,  7 Dec 2025 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765124803; cv=fail; b=buRElvbS15QJcrTuOjBtulrWplC9u+PmK6ibn6rSRvwYgprkXZIvTfyApJwn3oCUm3ihU2BTdl+PB+8u5l4VEWaKxCDWNpoUZHYsY80i01lpAsAzd1lZLYbyE0nztb8SxRPvOFE69FLbAmnTdI6RDRqFKrN/xhNj/74uCVnYrMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765124803; c=relaxed/simple;
	bh=YtGNBSM2XphpLAXIO67ugvgOn8oo8t/miRXA2VWWgM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=suzGV/HwnSL2Hx2KWnAazAFSrY1Zy6sHA2orn8obpUHVMSOh0HAJN5lC8PbRbiwwXzCFLW2CF1+G6cMTDcLGZUFdf0nWVOma5YOE9pe6EWeHcl9mrqvl9WGnapLlAaNxc+A60L0gN7rYM4oDlj9rk8f0XsJmmL9QkB9JyanYcDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WKLdH/lD; arc=fail smtp.client-ip=52.101.52.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+s2CSFkuqwaOluauuzSQsE7gQOEp6vJzaRP3wnuWDopdCgXP+C6QnGn+aMGe17IB2fjt4dsZpsF6pFaY2F0fdJ9V70VpRMfpKxH4yDk5X85mUVLDXlUy+gwUbnoX/kReYi8gAhdpHu7+bgt/bnLjKT1sZw9yaZaAay5XHbNIZTQkoSqZuCciUP8OqziLTMTxh7ct7cWFKyKU+a4bVp7Cc1DtYDZXZ1J3jsjZTczCA2B3rtbLwwcDmoBUphreu6AhNrBw6WZ3xdOlVtt8fZNp2tzQzSvYR9Hu4v+WjKZ5NpbSdwSUISIOMgjIpPUxr2+Np0la5ZMU6sIdPm79IQ1uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGIWkbRlS5G4LMwrXwRg2IE4ibLzrdbqlrBeT0dZ+f4=;
 b=SnNJhvocUqo26VF4rJlbLcuzrEejdExyFU5PszAQNIEfz5GsVY/xnAHwnVE1Y3QMtT4ZldiufcW+keY1djbMxt0aPBRW+1gtZCp7PVwYfRr3LwwZ48hem7eSCM9qMLHMEescELwpNNDInlahK5vxhlYG76vuPNXtVW93vEandzb5cVWkamSbtcTOdkH+RyC6HtOq5BzrIfU6TpM9oL3q6YoPKNnkRZcgro4dI0FD2UtIg6cqtdaW2CHfiZxwcyx0ugyfJzNtyOjlUMVCditJdOQefAZJujtIPL7I7MksFDxhOZg+iUj1Xww+xCieV4OqJ2ezUgw7Dj58PxmQHBjm8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGIWkbRlS5G4LMwrXwRg2IE4ibLzrdbqlrBeT0dZ+f4=;
 b=WKLdH/lD8e35jKFvTwXln09xVSrFEl6G40UQuYSXYFPK1Bs0bKaGOuIeq36CuslBWvmOUAPNhexy2XnYrzHakD/5IbALwmFHeDLgKqTrV6dqchEttnwAxySwwNCMT8KZwV1DL3rLQ5ThP1iArugajIGAZtW5Gc7KNS7VWL1/UeJ3IrUFQ4q1Fy6cj8KoFyD9+PqgiL0hgZhnd2diU7VCoqsxnvwh7wrp/j4ZqhYelBwEnhkMj0Dz1FOgSyFIEEFTKokoR+qEBxvIZVtRwSxvwBhj1Y/cLkun1e+8wFejdqU9s/hG7LLs0mIEIBWbd2p/LTeHKhOHz3syef8WOFHmfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA5PPF9BB0D8619.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.10; Sun, 7 Dec
 2025 16:26:38 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9388.013; Sun, 7 Dec 2025
 16:26:38 +0000
Date: Sun, 7 Dec 2025 12:26:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aTWqvfYHWWMgKHPQ@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-5-peterx@redhat.com>
X-ClientProxiedBy: YQBPR0101CA0119.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::22) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA5PPF9BB0D8619:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b1bfe9-53b5-4641-1d0b-08de35ad65be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jhwnHoScDj5B66BekSs9X83KknYeYLOfunXyzqz63Aqd7XUnP7zaS1MQn0Al?=
 =?us-ascii?Q?kEx6zzbLrgji81DR60hCy1kcF9VbdRV4ajRyh3P53lnvEADfQdEVjsSTuEoQ?=
 =?us-ascii?Q?XPbgeBO074PL4LNkkf1V31pN4EDyLRe4YyHaPAKOzmBPfhhDDV9OHtH7UDdc?=
 =?us-ascii?Q?sJxHNW8tIKiBCiQr1frZF3v/bBS+Yn0V2+cmFk/mZYbk+enboRQRQTHtiXU8?=
 =?us-ascii?Q?TNRprlCbfOVK/WjUd/lJ3Q/DnvJeN6uqpyzUx/LBeRkrw3yqLlzMAJyQpGqi?=
 =?us-ascii?Q?DlwS2LwwMgYvfYWySjTsZ1s7Z4h7GRTjumqqx2TlrSNlJtGBTdcYNLIic4yT?=
 =?us-ascii?Q?vHLdVh3vlJJIV1PsVWlA69ZGlQs7wXUlgyA3fDl0Sed5ArG5pS/eRqBfpOBA?=
 =?us-ascii?Q?kCW2BlLAtsILEIjTo5MRYq2TV1J8gWE7lv21TqdMnYJuhoAiQDjMDeQ9tlYj?=
 =?us-ascii?Q?bcs25oPk4yxyrVAfGkTeJOfAthPwZXlbdcrQf+xGqrHKL/YSj4w/DwBeir9F?=
 =?us-ascii?Q?Esi42xNdMQhREAplgKohV9cxV7+j/g4BvVYk92cNr7U+rTekMOqgzayWWouy?=
 =?us-ascii?Q?uEJ4bbLAXiiUApYbOS6tSkMiB/NT9bfPDKUAt0XX/8WJcVV5UmcaFg6WHu4y?=
 =?us-ascii?Q?6PDoqIoIz5hWxuNnzc4/fY39i2/6Osvq+X4aDnqqo4clK2fiQtGJw+dEamIO?=
 =?us-ascii?Q?1j41j1Xssk+N8ba8bVL/BU2+5d3SQNFWH6bZ7+4IOrpJDWEhPRzt83o+nGHl?=
 =?us-ascii?Q?WR6Hit8bPIeDiPd+d0/FIGKsUGcHlPDBhbCEYJQvU1t/QSfHmXXXLXECGZwt?=
 =?us-ascii?Q?rH2geffdzfXKfCLtBjBvv29OC/wY/54HOxJb+IeGeuowum16DVax7xr/Mkfe?=
 =?us-ascii?Q?0ZDK/K5yEZDBQmbgpucsJQSvWfnHpGIShPk3jXIdxfrnQTSooslgSbimOUlQ?=
 =?us-ascii?Q?358lmMKIFiodXubKP9hwp0geinT2IqqxmNKw2iGcgdgECpvZuzhvT3lQNXHb?=
 =?us-ascii?Q?ir7+G2rABMasymkl4zRGu62FdeHF35y2lSqJSKYFWu4YZ2nIIzvhkuLIg1Mh?=
 =?us-ascii?Q?rM/8DZwH1L5yHsd7qjNNIxV3wDy+SrHgnpu+U9ASgwoX3kzUt+qtA7Novsf3?=
 =?us-ascii?Q?Nnb2T/Pen/K2JFhW9JakzZkUI/Lpyr4tr4KP+pOb0TNH2VsON4fIcSvCoQvH?=
 =?us-ascii?Q?qq9lIlf4UsbRJCXrCvlx6HKSVQBzbKgwJcna21r6a7b8gAhINhTsaKVOk8mn?=
 =?us-ascii?Q?Rlf1RDdF/uSdtrNUfgIBzTW4vUu3hUIgsGlv4g5U+hcneu6WAzys6jx+g8m9?=
 =?us-ascii?Q?r2RNgE7Vm29Tmp1Fc9bGY/WIlBS4nEuz5tZaQWVBdiKuzbxY4PEnusQyaPE7?=
 =?us-ascii?Q?Erub62rMh+4tidBe6S3UME51nz5P4hBHZo4MRGIbLXJxC4eGilfqmiXKq/6H?=
 =?us-ascii?Q?tWX1bdwWN2Hy8KW5yjpQaO2YVhziIdp/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VzhUoWWhDNoNfhq8l0tUY5Z+KUx+UrfZZ/1G0tELVBKGFJTyiawky1ORg4AE?=
 =?us-ascii?Q?hCtpvGAQ71ZuQFg5jc2sXT3wihj+17wFypi1syWRFHHtqE4Qvs0EoiQbqrha?=
 =?us-ascii?Q?L7sD0R1R7rH6o0w/3TCbRNH0dfokAKvZ0UWuIJInedNIK1jT7L4RqCRHtxAq?=
 =?us-ascii?Q?cgW0lhUfGh5fLLACG5w00zVipwhKyDthB5Tga0pFDJWVomYAQ9dzUy4C4YXD?=
 =?us-ascii?Q?U3jYaYIPkUjcAM/vD6xI5qfaL53N1B77F91JBpxnmdfpMzIKWzZWg09zH5nK?=
 =?us-ascii?Q?ZLk4S7k/rjoXWCfapf7RSO6YLcLDvzi8rB760+TENf2f4UC9/BvTzghe4w6J?=
 =?us-ascii?Q?D7hkR3RMIhPHDxnem3ib7oZEt/Yo4MX1VzCNIrW6GC99vXvO9NB3iO9t4rMV?=
 =?us-ascii?Q?O5SQj2RnTyyW3UjgmIGXind8YhjZMTSFBuUhewiFkZbjPS25wUAHqgckO1pf?=
 =?us-ascii?Q?CkHyJ+F4wR6Df/H0junmn5IEXPfIQEVdWGkasT18F/Yf059vJdh1ACx1S6M6?=
 =?us-ascii?Q?MJM4+drn4TqwfE14Ga5FhovKbgBSeTVdbHoV6DnlKCr7KhGlV0dxVJeQenJH?=
 =?us-ascii?Q?ZMrAA1/boJ6+C/ciLR8KOYm21N9OWGlGsY6LYw4FUZLhrZGqGix5jROi7TzN?=
 =?us-ascii?Q?pI32pIWP6EIKFkT602o18erUmO7camPMnyAjO0iI6nTZYv2qJ6qZTeDjcGVs?=
 =?us-ascii?Q?moUTPbO1JoGjRG4Yw7Au5jbfJyQKKA6Zwbjwdv2FyIUnMx8iVDaNs4KQVZsv?=
 =?us-ascii?Q?k4A6BAk97JfVkAL7HI86yglqhyWqDdZ8x5RjoT8ppEKaodpAZ+ejLDKZ31kc?=
 =?us-ascii?Q?4hID76AoljKjeIDnvzGXrOtwTlvJoOcdYaLJhbqsqlU6qAzSZ7cs69RCTQ6o?=
 =?us-ascii?Q?jz5bwxUnDFMpRLuEDVrX4jejBWiLYiL3moyVCG5QSE+reAMzoj0ub8ZwabvS?=
 =?us-ascii?Q?ZhoKQEZ/k4W531RWV8WdhiG19TZVq7HUS7yw2xdwCkMyYuCms5gnOsWFH9pD?=
 =?us-ascii?Q?pGW8aPi27Q2y02lksqTtVEM/gou8o+mwRJ+t821n4+u78SQLvqHK79F0vPX3?=
 =?us-ascii?Q?mIUrfjtG/PzFDTzqoGh/oLCS8R4HP6WdqUgs8zUFhiGuSSayKYdKcauWY4ov?=
 =?us-ascii?Q?EIHjsHqw5yoEXDeHrACi7/+gZgNB4UdbFrXLEncVc1feyEhS2OLiNBO6qUnD?=
 =?us-ascii?Q?sgh8lySuQS2/zQB1Y4RRSsaYJ4lj8ctyOpCe9hWD/yzj0t0X9ykZZciuKZan?=
 =?us-ascii?Q?SGq3tfLjDsMbPHZY4bIGXUSlUa6pT3zpLgU2hZwVrWggPvkMnwAPXDp2nPON?=
 =?us-ascii?Q?Jwm51CQ5l+8wq/MxxAUvMq+S8vMmylUqJFteFX0bS9rF0YSY9SLB5cbh67p0?=
 =?us-ascii?Q?Oir+sYjKjS9yPA5JsUxvktlA4EX5/hdG/7fcO+BDyg0meaUjgXNFcQoLylA2?=
 =?us-ascii?Q?mG5xU2DGkTnjKZQwyj9hIg/scekL3yCOZU5wfyrmZjcvneJQD/5RbgJ280eD?=
 =?us-ascii?Q?8mEo3HNEcIPKnJCLHjTEAfef5H6SsPQ9+APnPnbzZxNkcFeFNFcwvFU+z1tF?=
 =?us-ascii?Q?KybUI51g+tmcuwl6MVMgkqZuL/rHkReikU5J0Lq5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b1bfe9-53b5-4641-1d0b-08de35ad65be
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2025 16:26:38.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hBZFWRO3DIWrjb9El90EW1FpIqFZ7pawq/nKiOjCSpX7FuyaGfTFQl3ldgRfszK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF9BB0D8619

On Thu, Dec 04, 2025 at 10:10:03AM -0500, Peter Xu wrote:

> +/*
> + * Hint function for mmap() about the size of mapping to be carried out.
> + * This helps to enable huge pfnmaps as much as possible on BAR mappings.
> + *
> + * This function does the minimum check on mmap() parameters to make the
> + * hint valid only. The majority of mmap() sanity check will be done later
> + * in mmap().
> + */
> +int vfio_pci_core_get_mapping_order(struct vfio_device *device,
> +				    unsigned long pgoff, size_t len)
> +{
> +	struct vfio_pci_core_device *vdev =
> +	    container_of(device, struct vfio_pci_core_device, vdev);
> +	struct pci_dev *pdev = vdev->pdev;
> +	unsigned int index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	unsigned long req_start;
> +	size_t phys_len;
> +
> +	/* Currently, only bars 0-5 supports huge pfnmap */
> +	if (index >= VFIO_PCI_ROM_REGION_INDEX)
> +		return 0;
> +
> +	/*
> +	 * NOTE: we're keeping things simple as of now, assuming the
> +	 * physical address of BARs (aka, pci_resource_start(pdev, index))
> +	 * should always be aligned with pgoff in vfio-pci's address space.
> +	 */
> +	req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
> +	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
> +
> +	/*
> +	 * If this happens, it will probably fail mmap() later.. mapping
> +	 * hint isn't important anymore.
> +	 */
> +	if (req_start >= phys_len)
> +		return 0;
> +
> +	phys_len = MIN(phys_len - req_start, len);
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE)
> +		return PUD_ORDER;
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && phys_len >= PMD_SIZE)
> +		return PMD_ORDER;
> +

This seems a bit weird, the vma length is already known, it is len,
why do we go to all this trouble to recalculate len in terms of phys?

If the length is wrong the mmap will fail, so there is no issue with
returning a larger order here.

I feel this should just return the order based on pci_resource_len()?

And shouldn't the mm be the one aligning it to what the arch can do
not drives?

Jason

