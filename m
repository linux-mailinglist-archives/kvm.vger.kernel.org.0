Return-Path: <kvm+bounces-60525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33419BF17BD
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 15:14:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBF52189456E
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C31B3191D2;
	Mon, 20 Oct 2025 13:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I9TDiMKW"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011068.outbound.protection.outlook.com [52.101.52.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE5B2D2391;
	Mon, 20 Oct 2025 13:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760966064; cv=fail; b=a0sQb7sq17uX90mfBXBPAuCAQ+n3FYU9CklH5qbNuT65URapt8U/nmTbQZfYWgBai/4xn8EbPq0VmqLMr25GLZrixf2gymdOM1VC2OOmDg1VqfLQwBSeBDmthgaH5EFm5PecYMZu6FCq8LGZEV4HrfazB4NFmR6LYlSyhS0NuTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760966064; c=relaxed/simple;
	bh=kOSuUbY76fkHiubFdTQZ+ya9FcSTnc1Hsx00J1FXeAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=okAdylIhbhFUJT2Q3p7Y4rSPO3pUkd5FMp7q1/vbrvzqi1uFt/oEx2Gg/PglDkKWlKRNupRVe77pkakrJuWxI3tFyskI+5tskfy7feDnx+ZaqAg1RgPAjHn3/b6pnhbRrDvJPH/ztIINg0kQyXlgxGNVZEO+KLqwjrS6mqwMPVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I9TDiMKW; arc=fail smtp.client-ip=52.101.52.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MrzpPA5i94EvEyx60neIius7leKRgL5pF8QF3bOo5TB/FU1zJZGUxP4zNHD+Y/7u3wqbZkk79VjyDf1uSVEkf2nT9CzZCE8hspF+BgWcFb7KsKTNDKFCDAK962uh9IBWlozCISS9BF6OVefN58MtXUHz/Hgjk9HJsMoZhghBrQzeORzDXZiKdIhpNeYXrtPWwhE5R4BWvVOTivm0X+lb00U1fOwZDePgNNjESudoyQLr/HnJbhBadUr+F9LodiJcQsEip664tt+UzPrr8v8vgPxPEAol+HSDiSAHWrMolTvhW36E95u9IjX0a2j6W9taDUSYOpRro1IA2yWJWBWS3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/xAhEPdrCK7JzGGZ23ruMt4w7fGstjGlW1v3WB/k4s=;
 b=Ap5O4/YAq/QqFmvo11OWHzVr7CtneIkGolo40xMEQFx+zPYp8SMoO6ff84Y+CpmqVIPBY8O0j81Ov7wVnIOF16C30ZNwnHo62C4NCR7SoEw0FH2stLNXOA0JqABQLzQ7/dyMRnMhlJaLHSmuZU01FIZvrEr21PKerOnBcmlY0ixRY2XUL+jsBwLrYY+YSCA4qLlndynlzT4fPXBNE/iOe6OQIxaBcH+yaAOT3hIO6OJnSoQCQYqbk+vovFlU+rCAUwWwg0mT618v3CYfzwTU0jO+Q4a+dnh7YNP5pMwO08ukSwUf7jsf0iUwZUksJDYJCr5P877fJBR6/Vi537FxRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/xAhEPdrCK7JzGGZ23ruMt4w7fGstjGlW1v3WB/k4s=;
 b=I9TDiMKW7HA+TWyHbqwbSfxrSgrHWKtbtznvfCm4jIpPSAyF5tuLlU5+Q7flcPZ695SHyewl/1DFXvWsKAbXScrHXJsSJYCDhWk/E9bf1HblK2Se9MsYxl52CjzZdzBUF/qfWsOoPqcbNBAcfybu3TUys49BsWn8mEnxR1v7Gfy0Bkmrdlmr3+vN6AFvSlSxQd5XEGDVDDsVlNKYvHMKr8Kbf8sjPNOenelxd+cX8CvRaFx91TyyBdJFof2jYy7T1p9orfRE57Gf2fRaHJqPjTYmsFTt9QnMX6btPzlBHbx1o4VTpa2kAPSXYtlbi0sJDMsn4HDiVQ6k3UHFPztTqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 13:14:19 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 13:14:19 +0000
Date: Mon, 20 Oct 2025 10:14:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/9] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20251020131417.GN316284@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
 <aPHi2c2BQNB4eqm_@infradead.org>
 <20251017121447.GH3901471@nvidia.com>
 <aPYrEroyWVOvAu-5@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPYrEroyWVOvAu-5@infradead.org>
X-ClientProxiedBy: SA9PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:806:24::8) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MN2PR12MB4334:EE_
X-MS-Office365-Filtering-Correlation-Id: 70f5d0ca-0780-4bc8-e865-08de0fda93b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b8joZkN0/h9N0cTScTXpGlY+QCxIzckVOo2+SUUfCzclXooinPWxlpPD5y+Q?=
 =?us-ascii?Q?E/7ayuHiKwr+ke38/IJFK8Iuwc9HASoLkYnSGw0/RR2b6IYpq8sGWq1uucCS?=
 =?us-ascii?Q?7IFSpGqjGNzpKegd2gm9Z1NLMsjJdn1EVoT/qYf+3GJywLIZI7Hb0KtG8CtK?=
 =?us-ascii?Q?EulAgrq9kEEpOeAI3uCSmodlBPgVJZ8jgcASaBbVF7+FeDtqU4NQBAsZoSx6?=
 =?us-ascii?Q?Sv+xER1A0++imaYoSic5PKEy7r9MpxJCL6X4BcrdM+QjRO5xZGhhr+SmepkL?=
 =?us-ascii?Q?oLejVPK39wzuOTpBtfhtC4GWdg0VjrKZVe2i3XmXuhFMM89kUGbTdBZuLmgg?=
 =?us-ascii?Q?kaMGahdxrRs1Z1MYZgtpcmpFuD89CcxDA5tZYVO/7cH9w5Pqj3zCtHtBmFuJ?=
 =?us-ascii?Q?Tk3xNCpUepuHEy/foPy5HiG9qiZGe3DOIfGxkOgcJmUre7ttOqDRLL/U05jC?=
 =?us-ascii?Q?Qy8uWjjhYTttRlbnGlhHiq1Orp1Kn/9zMj8HnUsNSW4dvxuegdsgL7TN7Hut?=
 =?us-ascii?Q?SrGdF9QjjoRRZpBZcUqnHTndChbgKKsjhDRGQ+GOVIbv2LW95FjbEOdlT5TE?=
 =?us-ascii?Q?Zp4pBAQBuPSkzWAugGEphtgHvIQ3I04gzpNB6iz7YfVaypj+kby8e4fS+TY4?=
 =?us-ascii?Q?dRjWnKB0gusi84OGSWHzxjwLZM6TscsOhnq7F7LGAx4YJU4a5ZX6EhUuCRwK?=
 =?us-ascii?Q?KEoG8V/YtP/2r655u2eaS2YcfGngmOLnd6AjFhVtzYGy6+vdpqiSBy1x2AaT?=
 =?us-ascii?Q?lMb5nhLBa01J2QB9K2W+Y//M/t8Tv+qBuiTORmN+NcOyvJAlCKbF3MEdVCPe?=
 =?us-ascii?Q?VK6CkzUxkIBA20UzLtU/bpYHVIe/4rD9w5cLiFWoCxsoLkaB8dyPJXm+TXgZ?=
 =?us-ascii?Q?1A1BI/zT65q2xMocseJbdnp7iYI5tpYVR2Vw8vsHCXEULH4GoRwHqAZDwkwd?=
 =?us-ascii?Q?uiUTyieVDHZv2PyC2wzBQEiCYm+u0+/LGuYdK4a3lCD9S58veoljfM21ZVju?=
 =?us-ascii?Q?GW0AgnuFLcIgFFE0ThDFXM5tNV7rzGWTxk30cpXmnbvkZpT1xX/gSXGu99yl?=
 =?us-ascii?Q?3ffOf7PcxTNSb6qWsLU4LDrw04ncDxuCTMAdQ9hz/GpAXBFXt3ounjVBg+e5?=
 =?us-ascii?Q?hFVEwj6YutYz9U3ylHRCw0z1/WwUF3uIc6P+dRSH0JMslqusS4KuIulHQJr2?=
 =?us-ascii?Q?3VJbWp2SyjSGiVcaYrOUcOmBd/J0Jt3+GgEDViEFZb94Zdb2nXaXp0Z95qKR?=
 =?us-ascii?Q?ZRskr0i+jwOTI9XWH+Ly2rbYjlVsc3GROwRvLLTz7gz3WvBylQk86GC0jcHd?=
 =?us-ascii?Q?FELno61k61GZDTih8xKq3dnb1nQxoDfqk5cuBQtxjhT7BHlbF5BjR97HQTbu?=
 =?us-ascii?Q?S21LgNt7QROouxx3cpy10uBx912TUXABICySUgwAITtRDZrvA3ZTps/ap5Fp?=
 =?us-ascii?Q?/4Xp5D2bNdeNg3ohDUZVuVrAVRTeaq6Va0c+QgQuKqWBKicrd0rYIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5/FCbxZF3EcF6IVjezMmolqCLTK8l+FzsfT1KSHSMtBbKcAVMXkIj0eewVqD?=
 =?us-ascii?Q?TuKqv4QVURMbUgnRhjswyaTL1EDdzBq5XYIcQbXyuBYSOBQG76n2Jhe+7zVs?=
 =?us-ascii?Q?qTJmy6B5hynEUr3WIcLE1oDJuFGIeBg2QCweYLzGAv0+ONg2OBoBdFtAiOoD?=
 =?us-ascii?Q?SxKy3lZIdxCLUaXhm32fI7rKwWUv1DRycG82SQNAFRDGXgies+fyDl/FPbP2?=
 =?us-ascii?Q?riyWjuGmdPgGMrUhZ67/5A0zG8sjsia3vIhonnMpIxNuSIy97MYQ294uSNnY?=
 =?us-ascii?Q?viAgjJc0RMYw8stUHDtf+rp5yashs5GhW3sSql5z7Pe3hvYvODlzNv/nuGvB?=
 =?us-ascii?Q?koM7doslwd4LjLayTyGiyPF5+ZFWdcN5LjuWp7Tfv490Nbs/alMjv95YWjQj?=
 =?us-ascii?Q?ISE0/2JstBDXlrZsCixD2RLfEmWzwlsik055Kbt+wEP5SwkWLP+QpSTjEpty?=
 =?us-ascii?Q?Ssu24jFJkwgFLfKXId8fR1Ms4O/0I/VP/aLcewOXb251LhHfyYq4lkdsw9K3?=
 =?us-ascii?Q?C2htt4JkbPSjqasKuluNWZ54m7rVeuOtosL+NcrnKYPVYTaKJpV8iEx+Z6Qp?=
 =?us-ascii?Q?s0+QHYoEyvL184nJVPWyp5yRS6fBBMWtiXW5KT47aIpSIZWL0/ElgZh8kB5q?=
 =?us-ascii?Q?x9q8iEq25fVtbpOzS4hM2NWNCdTqhqzNLz6QMjAqnCeXZazgoCjkFaKs3J0P?=
 =?us-ascii?Q?GxlT61CDVi7VE3+rnR0Q/lLjjbt/iv4dP2+uH9nGwFBWXio94ZCY3cryFobZ?=
 =?us-ascii?Q?ZSGz7oy2oE+B95PUtmfFq9T2/EL+TUSlwkwgkc2Xfg51iMkxxd7UvPbgS/Z5?=
 =?us-ascii?Q?x1oGKJS7s1fNiJJUEVGj10cxWCWFsUPTJAkjm4xAIIYVq2FuG9eMSq/VjQGd?=
 =?us-ascii?Q?slaNqbIEg/H4/p5wXqNnhGCmfFxpwyy+BxZBEoEnAEQXJNQPbxbBkHH4oS72?=
 =?us-ascii?Q?ctEes0Rui37zVQV3d6Sq44Laj/m35uplqDEetwNZvLeEvUU+12TZggjyctJH?=
 =?us-ascii?Q?oDywnv+Y4+KDsa3KBD0AYluNgZySfwIUz0Ee277UnaIjBp7KrxEQNpQV7+j5?=
 =?us-ascii?Q?Xaif1cmsqUb4dda15OL996Rq76Pghgu0/VvLK80VuU/Ow9tncnI6uqEge4LG?=
 =?us-ascii?Q?Ae4pl31CTYkmX+Kzxqo6oMrPGy6mYMMeuyk9wPfGLaDB0+74ahgcKrmgwclI?=
 =?us-ascii?Q?QDVvt026JIW7Air+tkLA3nMwC3xr2oDbktuOZt1BD7zl3CbaQ1pkhhxcrnVe?=
 =?us-ascii?Q?YG3AuuLIITdALZfXQwak8hhnHiufAc0q9dqjx8gXSf6sk+R/y7S6NarpFEFv?=
 =?us-ascii?Q?q6OzmlVVnTJ2ND0Lmrba5ZpWTjMUdaSRbEarHpd5YresbVp0HyZflajkx5Vt?=
 =?us-ascii?Q?hUyclZetKzcCGiBzOxDd0PPmyhMw+fxC9HsnyuVCtzXedq5TKder6miJeKaX?=
 =?us-ascii?Q?lctUHx1hDM+NYDNwSvI6fwVKcrtT8cPbk1+WynSwGNNh12NwHkAlcn0W/j3x?=
 =?us-ascii?Q?UYEVAIpH7PLzIxuVfyupOQjOJTqawc9IaUWiZCiYXpSMfk98sZGg+dNoUOja?=
 =?us-ascii?Q?DLN39+Kkytck41uWAINLYPpYHF2n6ADRaSXTkxEJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f5d0ca-0780-4bc8-e865-08de0fda93b8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 13:14:19.2031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9sVEPkJmgkdE09DNOGndubxcCIH7wcoFoZoRf01i6x4VsEMvvKi6RXUISyr/NGs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334

On Mon, Oct 20, 2025 at 05:29:06AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 17, 2025 at 09:14:47AM -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 16, 2025 at 11:31:53PM -0700, Christoph Hellwig wrote:
> > > 
> > > Nacked-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > As explained to you multiple times, pci_p2pdma_map_type is a low-level
> > > helper that absolutely MUST be wrapper in proper accessors. 
> > 
> > You never responded to the discussion:
> > 
> > https://lore.kernel.org/all/20250727190252.GF7551@nvidia.com/
> > 
> > What is the plan here? Is the new DMA API unusable by modules? That
> > seems a little challenging.
> 
> Yes.  These are only intended to be wrapped by subsystems.

Sure, but many subsystems are fully modular too.. RDMA for example.

Well, lets see what comes in the future..

> Yes, that sounds much better.  And dmabuf in general could use some
> deduplicating of their dma mapping patterns (and eventual fixing).

Yes, it certainly could, but I wanted to tackle this later..

I think adding some 'dmabuf create a map for this list of phys on this
provider' is a good simplifed primitive. Simple drivers like VFIO that
only want to expose MMIO can just call it directly.

Once this is settled I want to have RDMA wrap some of its MMIO VMAs in
DMABUF as well, so I can see at least two users of the helper.

Jason

