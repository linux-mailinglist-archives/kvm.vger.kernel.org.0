Return-Path: <kvm+bounces-27589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B01B987B60
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53B411C232CE
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 22:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A4F1B0138;
	Thu, 26 Sep 2024 22:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kX4shDHj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073571B011E
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 22:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727391177; cv=fail; b=nov6YqnYlk+agyR4tc2gJ7ll2jSM2dAQaPZf942PnhqZQHoY/ksbF8yCpWLb+NvZlubJ4QJShFiN8bTfHe2whRSmWviJSuk3d3fDh3U0hK1RqAQAWIIvHOcYFuIcs5BlSEU13q7EC5D4OukayyLuzmYOCdhqBvr/4JCLIGqSeG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727391177; c=relaxed/simple;
	bh=vQqPp76IlJSvCDHJwCeRdYiMSrK5b3IVKiGVMxKLGis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JdQOieZRfEGN5g7YlYN/vd3SawqEzY+OD1lsSHXUIV4AQDvz9313ByB9EA7LCGrhhhXLmPh+F3k9HJg27ZX3sKBu8OQZPuqR4sPSP8boVsb1HJJJpjbL5feZX0UGLzaMkw7TajC4w+5nX9Zmm+9SxWif8JlNhAaZHxo24l8192Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kX4shDHj; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EgEDk+VGDgLVR9VCB3t3MEwKds0uatnSxKM6JV0aX2IfrAIbXPBKGTDKgEueqszwjda6hwGk9V7IguFmABuk4BAEnkLEak1Pp6eTw+iWnal9AxZeQvJeg6e+aBvNJwg6a5adLJa7b848uyfwhzlMItJbkPBbNaK//qXIakQR/h5InsAVddnjax6GagnaO5Wk8Q2/3dbDn+cid5RsZHcEzeRpQV1tEN738GXuLHaggg/SR9Waf2cwK3ZeSrrSfxY2MSuSa4N+PVUSHVo8CU05Y+PkzM4pDvn08jPX2uZo2jR9r761UxpFl6Dy9FcJduifZr+if6QAGFx6ZLKNHma00Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xz02qsYM/j0iuZ4M2uGcwp9IFziv/uOr/na0TiqshI4=;
 b=rgCOaC0A0fq/N45nTRFGM+Is3AqnSKu4YP/hvfmJ1rxSN0DktH303iOxYe7THpkIc9mUVxRUe0x1k3dqwlY2qSqq0LeuaERIpUskzZYHl8aS36ktCikVafdRATdC76LijWvWdsCwsAav1jSQawii7xtMU+OKFr4f3/y0RAvTpCIw7YIuvDn2EFJPDcotqnuqRodRQTzmlTd69Sg8JXwGF76/vjnxXsxZMcGY5iHV93i49vXpQr0BE4JsNrtOKjubdk9r0nfjYOxDPSLUqf728xHgWHlyFbixxlNWZ5EH6RW6jWTsTw/akualPEzRxPqBs8HE8RrtZEClIP9rldeE/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xz02qsYM/j0iuZ4M2uGcwp9IFziv/uOr/na0TiqshI4=;
 b=kX4shDHj4xJwD9PCU7Lele9tksRGEUAvOGH16TaQ7YUlHwCfxpBe6t7wS8MSX/eBn4KEhVJi8tRt83iZdkP1kX8JwW//46HHgqSoNWj5uvITmDvXNnDkJyrN1Fx2Jm0UDzuM14sUyWKmQv+AB5HKAoFwyUIzWw/RLY7W+qQJl009E4kt+0kusmemO2+bVtYz8ZXc1vg4G1bs0X+tlG4mxAwqBW4mnRDDn6i4gyC04i/MbO7EawMmekt/iaj6b20lHP3CmsUZtQd4ClSRpGKm6ogG8qU0KwF2A6UJ1uuLMB0cD1IF9ln+Vg2SD/v8YxXGsqVnvqOvkqG4vzlUDZeimg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21; Thu, 26 Sep
 2024 22:52:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 22:52:52 +0000
Date: Thu, 26 Sep 2024 19:52:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 05/29] nvkm/vgpu: populate GSP_VF_INFO when NVIDIA vGPU is
 enabled
Message-ID: <20240926225250.GU9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-6-zhiw@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922124951.1946072-6-zhiw@nvidia.com>
X-ClientProxiedBy: BN0PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:408:ee::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cb25dde-b879-40df-e7c7-08dcde7df394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PAYRunCU/sTcAj4Uk9SgQsrlUCrHeVAtipCOeqHJ/uzCQcNFIeY71CPHo4hL?=
 =?us-ascii?Q?jsHdm/T5WJsb5FkIMJ33wi6gIdjuSMt9WQ6MzK2z+fMOezwJFP5htxpwrxKY?=
 =?us-ascii?Q?0Ykro7vbB0eSuifheLw1+G86T9aktQyzGD77/9wykTy82vDnlCIbhS2oiJiP?=
 =?us-ascii?Q?aKgYTrNV/VvTOEfmNGpSO/AS5xFa6aTQ1BcmOB2mrePwnJAF6EtXPxa2Y3Rk?=
 =?us-ascii?Q?LgQfaWPtsDeEvsFcYf9FEVysz9BO972rd0Ba8tlFh4339xysJ1+w6sZMrUnG?=
 =?us-ascii?Q?syK+Fdal8GvwOWqYujtF7OujcWcXdMTMWQ8yXCQJJ985NnN8paS1BVD/Uxnl?=
 =?us-ascii?Q?g/gJoFHXjcAiza1oep/j2rIy++ZUDmlKpVGaRuwpWXANYEg4D3Wk4jPcy1kV?=
 =?us-ascii?Q?zswRRR45lX1hJ2P/Wygbc6lpaJrSmlmPiEHxa8cqERDTyaTEAJOBwPBdpT0n?=
 =?us-ascii?Q?/K6TeQSQ36GwlafvWkUH72s4j39TC4oh9x9h9y3GBXLO4mQGFdOoCWYzRUtp?=
 =?us-ascii?Q?DBpXr6F/t2a7euhB9FEbvOak/vLqwjyUeJeAxFlt7iLtkwlnAXFNyycogEyM?=
 =?us-ascii?Q?P4tW2M/sCAmOJNV1S3QdX8lPR1H3BbgqmmEYYMRwwHNoHDbStNK37t9DWsp3?=
 =?us-ascii?Q?1lF3PwlTE+yfOh7AE6YoVRh5tM5mYTjgtr49I1+b6UHV38c+esYs76ekr8bE?=
 =?us-ascii?Q?8/B+pLfEUlMGiwn34sQjych+/1X7qBpUQmdDYDYpHSt1r04Y1Ey3H5t5xrKK?=
 =?us-ascii?Q?mhOipEakhQFHTr1uMALyZ3e+MHECDDcSuKQjW8IcaYqxs2WHX4fASiZ5rf4d?=
 =?us-ascii?Q?lA0ljkm5a3/qvOkk5fSNWbbT9NphNnp33U+nCy+cwI62XIj0NoIcdHryi2GM?=
 =?us-ascii?Q?chNrdwuBOhjDs8dgotq1nETf+dTNtjs1uifgpeEtbyig40jP5GZEs3rm9xYD?=
 =?us-ascii?Q?yYEEdW8LudFtx0TihhGYr45f/UmI8UjR62A7ETS5J1Lxuex9RGxrlwejbv0z?=
 =?us-ascii?Q?pjP8gwYFV9QdOk7OwnOXGQvvim55B/zRzlFurgb5KFVm98lgCgsA5C0bZKTz?=
 =?us-ascii?Q?HPhPXUmNGuYdEsQecqcyXebWRl2mtdVS7fk5Zhg42tVQAOqVjZAVLkKVxR53?=
 =?us-ascii?Q?ySf4JhYxhVv9GPRLSkfaW4KsqGNr37C+QwhwXWvLlAcMKlAEytF6B9286Ytb?=
 =?us-ascii?Q?DdaE7cCopedqqfhcFMwmAk2R+/8YihRut10EqEJ3Jqdk3x5oEV/FzasKDIQT?=
 =?us-ascii?Q?QDt+Pm7aLM+51wpzTgENQk4Wk6/zUe5jdax1WpgAGw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UootMrUh9ZDhhhyH8CyjjgpUXwaeb5E5v47TXLXvaaZ6WaWgUZHWn2G2ZTdA?=
 =?us-ascii?Q?ZtUox9Tp4g2BTXmNnBC09+jn/rlINKM+BMgGutba/v8l9HQlgFrzNpqBtNCU?=
 =?us-ascii?Q?bRoD+eLRZgJzgHPEDnXth/XjOJ/jp7mIJTmcJfxNL/cX9VefQlV1mz0jobIG?=
 =?us-ascii?Q?fN4SyphETcY9Y1e2XPKV1/vlFJRoVR+GiScozSlMFH4E0zXCvA6iLtvY31Xv?=
 =?us-ascii?Q?VOd7wwYfbdlIMWXrVBteaIXiGsoAzhmQemTDaRQYZVu47n4If3d9h9vDVxbd?=
 =?us-ascii?Q?hEEULqdDNE5P/gaLiSkcnFCJAKYvQSbHzOxpRuEOc7H3dZP/z3aPM21KSxc0?=
 =?us-ascii?Q?JPYSF3+9ZM7Hd6IaUKo2yZcEJOsJxA6sRefZ7Rq5EgcAhE86+3DBJDj1mYU1?=
 =?us-ascii?Q?wkr/xLARDk1qlvDOUNvXYmCgYcyTfnyPYI7BFWIqhfEEDvbJBg/Kzt362zKK?=
 =?us-ascii?Q?orIhBf7KlHYDImQ45XuBtlETpRG0UwnqHW21Nn0AcZR3OmUxbYCAareziY0H?=
 =?us-ascii?Q?9VPRcv62G1To2vcTaKTvJwxgCQXdZoRwny8E0e3UMJQ6IL07R8UFqCwm0Fjq?=
 =?us-ascii?Q?ULxMMqcV/ftxwLSCDhsh8KZVEF73qVtSWJrVYYnmJdnPc40bG7YZlGnes3TP?=
 =?us-ascii?Q?lf2w15KHvNb8EPtA4/4L/81wJeqBeKEQoAhY1UeSeYk+l9K62d9HiardzZdy?=
 =?us-ascii?Q?jDIxu0fHLOuL1MzT4o0Fjku08qCfVCAZz+rJcLIaFdQkUSayfYZRHIsA5zi9?=
 =?us-ascii?Q?BubfFZyAkFUwby+6XRLdE+zErGk9ZupaQsUzyBD6LLFFVqsCjvBpA7XJEgB+?=
 =?us-ascii?Q?H9X2xavYOSGBc6XIB5eG4Cia0QCJfwy4X+S+tAnU3lIHyUjn+Y1hqPURTpwh?=
 =?us-ascii?Q?ZUo2gc9dEmklG273JSt9UEn/HVV2cozsybZCzyxZrzBPq8gXWU4b0D54ES6Z?=
 =?us-ascii?Q?WrFMdM8z5X1Sij/nb15EodTOUhh6lFWhgMeDJRTvdsjGJTVM4yayG+l47K+n?=
 =?us-ascii?Q?Q7AwdV1+I0RztKKa7spJSufDKghOuAA1PgVl5IopHDVrbIgA5sNJVrz5rRiR?=
 =?us-ascii?Q?hysvgo52ecHNkoIy5EOrWOtcQQ5ryr8pX65LJ0zvRuANXgMWlMPC5+gFuBXk?=
 =?us-ascii?Q?4UXgVkKxf+JhOg6NfrEXKg7//69aTFAOjCja8yMHYgms5zMjhJm6QK62aGJh?=
 =?us-ascii?Q?ZnAqAt6UuVK3UyiR09p2BOoc5fYC+6y+d9dCDjYCZykUAJI6M64byam/6LVf?=
 =?us-ascii?Q?XoOIVREgGZB/4aI48wWCUwITXqE6RzLcGLL8SDNINb1VtQ/WFxCd2CTHXHn6?=
 =?us-ascii?Q?7HZN0gZP0pTTM5pXoSxI2m2cizeEJesDAi47GtTaWlOy3Ln8J04/lWQ5Fdfe?=
 =?us-ascii?Q?uOecqnNfc+UU3/fgx1zmTOUXy3Z+bop9mHW7gg+KxIpykwhrgUmBe2RvKIKx?=
 =?us-ascii?Q?7wsnfjt0vGWz1nbsSoSIamchUOmNwDOxcIqAfAF9jaJzQh61072gzSRS8HvT?=
 =?us-ascii?Q?7wgAhXIwLhU5Ep1r5Q1PbofHU4HMClPHrjyG87ZSz7fAJwKpg2PltZ8iWimc?=
 =?us-ascii?Q?bMCvIRdeZ5kwE4eVOZw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb25dde-b879-40df-e7c7-08dcde7df394
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 22:52:52.0038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz7mOqauMEggKKfCpCADxqqfnLcEcsOWDwE1kRflnxV5pH8pcjdYSkCSSxabOrvB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

On Sun, Sep 22, 2024 at 05:49:27AM -0700, Zhi Wang wrote:
> +void nvkm_vgpu_mgr_populate_gsp_vf_info(struct nvkm_device *device,
> +					void *info)
> +{
> +	struct pci_dev *pdev = nvkm_to_pdev(device);
> +	GspSystemInfo *gsp_info = info;
> +	GSP_VF_INFO *vf_info = &gsp_info->gspVFInfo;
> +	u32 lo, hi;
> +	u16 v;
> +	int pos;
> +
> +	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
> +
> +	pci_read_config_word(pdev, pos + PCI_SRIOV_TOTAL_VF, &v);
> +	vf_info->totalVFs = v;
> +
> +	pci_read_config_word(pdev, pos + PCI_SRIOV_VF_OFFSET, &v);
> +	vf_info->firstVFOffset = v;
> +
> +	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR, &lo);
> +	vf_info->FirstVFBar0Address = lo & 0xFFFFFFF0;
> +
> +	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR + 4, &lo);
> +	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR + 8, &hi);
> +
> +	vf_info->FirstVFBar1Address = (((u64)hi) << 32) + (lo & 0xFFFFFFF0);
> +
> +	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR + 12, &lo);
> +	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR + 16, &hi);
> +
> +	vf_info->FirstVFBar2Address = (((u64)hi) << 32) + (lo & 0xFFFFFFF0);
> +
> +#define IS_BAR_64(i) (((i) & 0x00000006) == 0x00000004)

This should come from the PCI core not be re-read with pci_read_config
and hand rolled macros.

From a mlx perspective this is really weird, I'd expect the FW to be
able to read its own config space.

Jason

