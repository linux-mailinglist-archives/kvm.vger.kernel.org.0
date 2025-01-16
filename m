Return-Path: <kvm+bounces-35664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE96A13AE9
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 14:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 657801625AB
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 13:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E569522A7FE;
	Thu, 16 Jan 2025 13:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qENmXZnc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772DB1F37AC;
	Thu, 16 Jan 2025 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737034107; cv=fail; b=pSepOJqjMXCBN4k+5TmlmpHucK53FqYREVO2zBcDnht6ezv/DkLcCk5QZweDUfxcy4vbME/otuwgt6OicOk8MNFibTp8ECraQBXTTSvjYbA0ktUObFvUGegYdMO34VRXaU0/GZShw8+SaogMVZg+1BSDpu2PSLO7ykQU5umPU8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737034107; c=relaxed/simple;
	bh=Z/f4QL2eXVB72R86aekRDH+rPSvkcHx7tzqDZFMiylY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r1NeMMesHcsvTYrxU9PvAiFhB+KtHVgcMzNXBK3ky9eMDuRz9HRrOqClftV00xes3RYWpkcwcA748e/h4OKAZIOeiX/z1q2eTfHD1T2QVbd1vx5KwuiAl12aZv9GWqXU++zZ9A9piJLMFQANjUUBLG+oz0PqG4GqvoLbFtKE2as=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qENmXZnc; arc=fail smtp.client-ip=40.107.101.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6L1q2hXD4AanQ3R6bSrzoa9GuIDJ8K8hdHon4LLYixyfIWUiccIfJAPXLsYwgGi7SYpkouiAGYUGyLMcbAouLJz30GomvS68huEnJGIOhaKWrV6ph6gGi265+NgOtbbzk5BwwcTHJdawTdDRoVR2EYTMhMC0Bs+Gwa1oEi6oY25zLzO3tV2SYl3KkHlQkfsPqLklUKQl+qPLHvf21+sYEhqO/eVYftAKuEIaeoLc3wP/llUsYA+thqqD41xe/Kop5wY6ng8VrYDI7HpfsSOSsRYChr42QFJHsdHBEFVyz9J1vRH47HnmTToWqmT8EXsbBO/eXClzxFw21ouQNNmHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGAyewpqhCaDEfWmsoUIJrMsGGnHOPM1b4EK4hjYXsg=;
 b=Zmqjgc1lfVR69qXy4FCHZSL/BPGKfFbKdSXdnImBzDIGmRo/fpcajuqCEpXZ7ekpBfDoW0YejRN1pO+Dd2fhgcZyebh+ph4caM2IUGt43g8zdPRCovFAs8asoq5fP6hbgiHvkufjLlSaU15DNE7WTP1BriOKJ7zCK0ugAgNXl8kfsS0ojxek3oroEoAlpL+bJXw47M27m3pabq4Rjd7qU7ZjEPGzxT++wP25tdX1tXGMHeEeWq7k22Tpjm3Sa2I4tWbTWtvWfeZ+tIfJncbOPGS4zEkQzH26m2Bx5Ga3NRgOiEqVXTM9YJ98hjBMtWPnDYjrlk7H7Yf6ykFBlGxZ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGAyewpqhCaDEfWmsoUIJrMsGGnHOPM1b4EK4hjYXsg=;
 b=qENmXZncKaRTzuf43sHweniJYLiUE+iwCf5YRqDBGV0LVcDjMmzqXfNA15CTzuoUBpq5n+TlsdWdFv2me5rxVekWZgPU6iVPD5kaTRjKRO06zNyQ2/x4dRcBiWP3O1VzEqOk4XVhliGydbfVQd7mkl2GmXxwAwcG4xLkym2dGbX0k0874dqL+hAxb4yNVuDluzVR5bzGGRMMPfFzQeJuXXn6EVuDV/Dew/LwAsaMrPq6+49S/ZHLiB7FdR5l2Qb3iNdiBYQpg41oTo9EkYTlEGR29FycKxUvHPw2fxzGhpcyCKEgt3u2Fp3QLzWBfrMKP8MWYR1K5NDuoODzMjFuWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8786.namprd12.prod.outlook.com (2603:10b6:8:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Thu, 16 Jan
 2025 13:28:21 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8335.017; Thu, 16 Jan 2025
 13:28:21 +0000
Date: Thu, 16 Jan 2025 09:28:20 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <20250116132820.GU5556@nvidia.com>
References: <58e97916-e6fd-41ef-84b4-bbf53ed0e8e4@amd.com>
 <Z38FCOPE7WPprYhx@yilunxu-OptiPlex-7050>
 <Z4F2X7Fu-5lprLrk@phenom.ffwll.local>
 <20250110203838.GL5556@nvidia.com>
 <Z4Z4NKqVG2Vbv98Q@phenom.ffwll.local>
 <20250114173103.GE5556@nvidia.com>
 <Z4d4AaLGrhRa5KLJ@phenom.ffwll.local>
 <20250115093234.GB6805@lst.de>
 <20250115133419.GN5556@nvidia.com>
 <20250116053348.GA24046@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116053348.GA24046@lst.de>
X-ClientProxiedBy: BN9PR03CA0453.namprd03.prod.outlook.com
 (2603:10b6:408:139::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8786:EE_
X-MS-Office365-Filtering-Correlation-Id: 335c7f0f-7970-42cb-cca7-08dd3631a558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?coVOjpyCGAPr2py4mE3mb7vnTUb4CE/O/FhkdRXJTy+hOaWwDgUgcugSIfb9?=
 =?us-ascii?Q?Y4zbfnVBbzBT5Kv+YY8yJXHMB4ZoSzj5KBXfmPDcaFEpF1aL8d0KfoCiPUjg?=
 =?us-ascii?Q?bD1aKw+SGA064+b29LEoE7hXm401feh3fFdp67rzij5ywbjqqjVL3XbpBqgY?=
 =?us-ascii?Q?o6TrUx+FRBV1wApVMyvf97K/L/HlaYuUMf1UjqaybTutofq/9VgbOeKg5mSg?=
 =?us-ascii?Q?i3g34K0/L3bBY5KhxLf2z1rEf1Js+KUE67dXcL1e4+bIeR981/AwegyB/7EQ?=
 =?us-ascii?Q?8KdF3/EB1uu7N8QeD9+Xw9+w1+TCJ8guSwIBdfL72esCJAaLN09A8Cyhjwlb?=
 =?us-ascii?Q?5XqZa0abXy5UhV2h7dVMc+E4qU12ZJTOtBiVmW/CJDzKMmBQqhnf2XnOW5if?=
 =?us-ascii?Q?RxWutM7MEq2xgvJ6ZFU9SxtWelQWwN3Ybcw0VlhR/auvTdwc+7Sva7bLgrV/?=
 =?us-ascii?Q?utbOMVQu8xVIa4RWZX6FuTxBKENRIFLONUXfPvHtM4OsrLOdH/w3k+5w7/uo?=
 =?us-ascii?Q?OojbIwMRlTYQeiaoA2zyeSHLo1t46A0cmJfCpW830OBP776XIGQO+KvDyMmB?=
 =?us-ascii?Q?5I9QUVzKku8TY8ol5ZXwV46nvKIUdsE7xRpeYkFYmRX0GBOa/nh5Rd+Icjxe?=
 =?us-ascii?Q?Ix1VV/HxUDDSJhGrOoo7im9l1yv5Ga9P/bEYGZxvM23z7qbG39y6XaSDje7C?=
 =?us-ascii?Q?fMiABGgFqrQEH1uEmT15ap9gu+gQjvLZxOxFvJzpc0s86+Hy8Wn4rOIGoHau?=
 =?us-ascii?Q?IaldKra7wdFCd9SI0aJxlDsc64Q5HTdn/idI1n0SVH4RXqhWIy3UZGhPtIRF?=
 =?us-ascii?Q?jwSIpdE0BvH8G2DRySq3Y+X9X5JucO0FcaQVrcNREiZ66ahsaj0cwTGsyxHK?=
 =?us-ascii?Q?ZK0Dl2vHPpTmelifybfUh8jyA0XjmY2+/lVfvmWxiBcf+NX3QVpe9UNyyeY0?=
 =?us-ascii?Q?3L8Xy5bxBC3aEZ0jWoboOwIeeXaoG/tm3i+7cYEJGxaUEmBY84F6FHrNQJYn?=
 =?us-ascii?Q?/rHE5ihJr5Grg8bcwhuW0+z775EgRmWGJEU4LDjpSNE9vK1MeDbMgaI61f/P?=
 =?us-ascii?Q?U5Pt+C42utPWkl7tA1/wFOvCQ1qxfx3pb01fGeuSQb2yEO5buNPnlGFiBP+h?=
 =?us-ascii?Q?7k8AkqgpKpr7RrRpRyIenipBQV7EjwSIU0kEm+KHPgbhQl4DEIeTAZTcqwan?=
 =?us-ascii?Q?oZVEh/vZdvcteTxe1JJPjq9Sn0W0Gt7jCkeeH0ZswpcahFJ30CRVIWUAiPZZ?=
 =?us-ascii?Q?gTufedpElkjFxFasKLjbsE1G+ictv8bMrnRQ09n1E+p+zWcErf1+kh0WERH7?=
 =?us-ascii?Q?aGJ7iaDoK7bjYot3uu9aXuozxxepqAbHrnXBxqoL7TQT9IpnjFMCsi1Q8syn?=
 =?us-ascii?Q?pXXXpDV9w49gCHJ0kysSbkgLzmrx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DwczygUfbgvliiJIQ9oAD3onbwGNRAFaH4ns7LpJtawMD7fvsYTUgHYDQu6x?=
 =?us-ascii?Q?f/zNoGaDqEnsxw+ubHRn0/uMTv3enrIiwd+zX6gaOMssUSJMdIPEx6luulds?=
 =?us-ascii?Q?Gpg+yqlAEvnjzoCA7r16QW1PGR0I1NBSqFWURPd8SUQLVk4Fx6dbv9TlDNGN?=
 =?us-ascii?Q?VFn7OT/QppK6MYixG5rMz/JWTvKtbu0yq70JetKYYaev56xs/QQj33dta+Sy?=
 =?us-ascii?Q?fhu0TOhxEXV1/n4kIyFqcoPj0NK0UpEGpVhJvZerIsl4H7+OFhu/MTqM4sHi?=
 =?us-ascii?Q?fgHKK5EJ8DdfxGbeAmDG+xlLJazI5TCBZlrXNv4Kkg/3f1CBIoobrs3JyhYB?=
 =?us-ascii?Q?NTcosUyd/dlJl9oV0b339R9PB1RyGLhhlFExNT5KaaLOR5wxLb/xq4YnGHwh?=
 =?us-ascii?Q?dHDkCJ5IuF2ZlxkoO9s/IgN8GpB2z+nlW01d9eFC71xGiFI4ALZIi4IE5iRH?=
 =?us-ascii?Q?PsE82hJj5LqTWjuSKyQ8E4uom7BCsRXvVmV6x+d1HPADnn/+9aLISBCFTFqX?=
 =?us-ascii?Q?x8CclmEph+3dKlcmG7vKPGOMBiAg/qiJ3fuwdfGtix3/KXl7OMSW7W4JJsj9?=
 =?us-ascii?Q?aiZBs6ZHOFBMb+Yzkammfa3VvpBVNbWi4GSp85HH0N0ETh2Y4sAUcdWPfxFp?=
 =?us-ascii?Q?/Sq+ups5pvFxfr8oFoBj8UQJzfUuAn5koufwk2Via3tphx8Uu0vvUzQJ/H8S?=
 =?us-ascii?Q?eiEj4qnKGhlx6QF2FHk6bmuKR2oATwT7DaWSuzVaGMrAQtfQnk4MFN9NPswQ?=
 =?us-ascii?Q?v9gxqvH0upASAtuVbHMmc2Izu7LKPTpm/Ghy2W63vavYOvlulCEaZ5PqR+dx?=
 =?us-ascii?Q?wo1cAjFjZmn9afaHXS6EYL+K07AEUfYdWYTE26LFTiJJhFHocgUGZk7REVTs?=
 =?us-ascii?Q?I4mdnn2mimXIWXEfIwwVMcjIDXjZsP38xWl7HnFw5hWVbmrYikIerJP8XUzI?=
 =?us-ascii?Q?KlnBYY+2VMfohKpOIGM9j39b80xU5HVTxrzFCNS+lMxYpg2ynvriuap5Qo46?=
 =?us-ascii?Q?4BHRgGjCeW0l06/VRb1rJA27KUyXZ9G0lNzMnohkAe2T0vzi7IPd009nYjb4?=
 =?us-ascii?Q?2TCJkLC6XxSbHzdvpbHEdv/aue7YSCeH/3v+LCNcFcYqFkT8Rs5dzeLdNXQD?=
 =?us-ascii?Q?tUWOCMLONEBmPns8XOcSxBEJNtYN+3/J8gs7P02Ta9pz9eXV1HIHeaoh5EkY?=
 =?us-ascii?Q?bNDs+nscAx9La5s7JHmzhP1QsD757Frk+miCX5JTipESNcpDIIjsQQ++8hkv?=
 =?us-ascii?Q?9BdLyU+ZhzcJ8nfzeltSZXZrSZoDpMDeWVWoN4Ce0Brqy51fXxT2VAXJpqPk?=
 =?us-ascii?Q?cbZDlGwc9p+2m1d3ya5ek4hmNiaoI/kL7gEeVFEK2kQrzodnS2nBLnN8Gvpl?=
 =?us-ascii?Q?GmBSLevFTsuJWrpapEFYk/LVERWud0kfh8JOrrTqlDiisQEgKWYRuRF7PeOR?=
 =?us-ascii?Q?OjSNKfonoBbC22sc/powGVvYSQTq7Af5Y+/eVv9SpiuUCb2i4to4hlE/AqVC?=
 =?us-ascii?Q?CS/uvgZnTTN5SavRjVrxmRhwQ6Px7qFjLDHHUSL/OfvzoLA0tGl2zlniCM17?=
 =?us-ascii?Q?bPM1TxuXoP4oGGo7I1M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 335c7f0f-7970-42cb-cca7-08dd3631a558
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 13:28:21.3845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+b1ApGNq+SqHp4LL7D/LjyUjVe9em/hVs15Y5H6wQyMLLEYOIV55ticfcxZUhY3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8786

On Thu, Jan 16, 2025 at 06:33:48AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 15, 2025 at 09:34:19AM -0400, Jason Gunthorpe wrote:
> > > Or do you mean some that don't have pages associated with them, and
> > > thus have pfn_valid fail on them?  They still have a PFN, just not
> > > one that is valid to use in most of the Linux MM.
> > 
> > He is talking about private interconnect hidden inside clusters of
> > devices.
> > 
> > Ie the system may have many GPUs and those GPUs have their own private
> > interconnect between them. It is not PCI, and packets don't transit
> > through the CPU SOC at all, so the IOMMU is not involved.
> > 
> > DMA can happen on that private interconnect, but from a Linux
> > perspective it is not DMA API DMA, and the addresses used to describe
> > it are not part of the CPU address space. The initiating device will
> > have a way to choose which path the DMA goes through when setting up
> > the DMA.
> 
> So how is this in any way relevant to dma_buf which operates on
> a dma_addr_t right now and thus by definition can't be used for
> these?

Oh, well since this private stuff exists the DRM folks implemented it
and used dmabuf to hook it together tough the uAPI. To make it work it
abuses scatterlist and dma_addr_t to carry this other information.

Thus the pushback in this thread we can't naively fixup dmabuf because
this non-dma_addr_t abuse exists and is uAPI. So it also needs some
improved architecture to move forward :\

Basically, the scatterlist in dmabuf API does not follow any of the
normal rules scatterlist should follow. It is not using the semantics
of dma_addr_t even though that is the type. It is really just an array
of addr/len pairs - we can't reason about it in the normal way :(

Jason

