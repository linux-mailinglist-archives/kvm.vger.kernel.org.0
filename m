Return-Path: <kvm+bounces-24137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F23D7951B77
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74C581F24412
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4651B142F;
	Wed, 14 Aug 2024 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BLo15t5n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB221B1419;
	Wed, 14 Aug 2024 13:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723640961; cv=fail; b=pQy4bKv/MBzCViPNNGj2jgzFdzkLX7aAcdI/Aw9VB3achMDdhq8R/T0Kb7fAySWe0ru03vQx8QNp8srHsvhwDyqwmGFDqjgi87OcFvmihXiCQOXSwBXGrAVqUMue1E9rFBwN5OZZn1kqvSOTiGG4HtAgkdykvdE0ugZTCyvGbRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723640961; c=relaxed/simple;
	bh=1K1TCi8CxHIWutim9Fw+JM2vfa3bz2TyshERMPz7eYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YoxFKEdFVlrimorxC4UAAIdQw0/rMTHGtUYZ+NoLFrPDMrTNX27bVi6ku8BapeiDt5/csBVd7LSbrbxJAMWXKDC/J6/3dZDuJ7fNltwa8GasdG1vK2SfN4tQw381QG1ISRbh9BKEtGBVN2btB9v/pdcONzwtjDg//xnnA5yx1SM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BLo15t5n; arc=fail smtp.client-ip=40.107.223.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uMQ3nJiELJABuJsnnZhxWFDFWMpHXzjZBlpn9Cy50/VYf6rvEBMQGE/4yyt55XJkRg2egzD1mZn3cBQACRTxgh4t2YAhJc/gscnkg6K5MgpH4P4PVijvom1mtIEMMQ1hLwSgckosEwplSe/AINV3bKRvS4CNDrby6BrSe6bEy/o8mqkLZVr3gGFiplOmb2Hte3jpd4+u5m7Yz0YLF+c+AWIR/GUw3PKVh4rf7RN6Jy1qVDsMfc6dTqzGTGizFReqTlT6mxlU+MxzL0087zD7FtSAuG99olZ7km3VgkJgSCQRAo3fHy7e8meR7FXhC6Uu2Hq2qNNQ+5pa35v+E0gxYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/TJEe73rZpagFT95/zy/wwUQhKNYVINv7n+OXIYB2w=;
 b=deOmRgEGwb4N0txst4wAAnDWyAv27rP9mpNNHJvutlfkhrb214Kdlm12KGE3firimu4FVx3Q+09dfzMchuzSgHxk65zAboIoiBw5RyV/4Z2JjcfvaiCIavhKHjsd1MFrqhuKPqAKJbtZyHkR4z/98ioiTZwFUZFKPaFzGQ5IHmEB0H65npuPjSobx4j5iWy297yiJ6JAcj+lKyCxDCx8S4o22K7pt/JTpWPB7EcoAIhALlIBgyQOIV2/fZRB2yUUrp9WcVVz85ybHR3FK6iE9lfQZ6lkp18MhEU7PlxJVUDUMj8GJgh9c+O6Gi1dgVfhXM4avI92zcvM/tu9WUn0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/TJEe73rZpagFT95/zy/wwUQhKNYVINv7n+OXIYB2w=;
 b=BLo15t5neotpVE6FAhoRuPdlDWdA2eyicXDbhzrcS0IsuePlqHVCXTyudi9n0N/HuP4CaatzshMZlQn2NdntXMA4h7/s742T4H4Ef8/vq8mjxKYUVi25aijTPgmYmmRb5EOssXSTnKzizrGMvHl7z6mQB0eQc2e30evx7vB1DjXq7w1lxN1/IAIYt8rtZPoR279mA6gZuBGRei8ITPHlD70uqN05gdJfocUsMzyqJp3F64U+NZqXVBlFw8RHaGXss8pjVnhDpd1ku9WxSEQM/LrEBxpNaxwTbxQr4ab0BsP3PmM6TWwhrnm3EDMJXJW/CS33eayr4psx8qGD6cMMAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by SJ0PR12MB6854.namprd12.prod.outlook.com (2603:10b6:a03:47c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Wed, 14 Aug
 2024 13:09:17 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 13:09:17 +0000
Date: Wed, 14 Aug 2024 10:09:15 -0300
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
Subject: Re: [PATCH 08/19] mm: Always define pxx_pgprot()
Message-ID: <20240814130915.GI2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-9-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-9-peterx@redhat.com>
X-ClientProxiedBy: BL1P221CA0016.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::29) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|SJ0PR12MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d8d4370-d164-466d-ec26-08dcbc624d3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zzNhbWwHQC4KR8O3uzAVvFZgGsliOBP9373qhbDQVEL2vc6Q4sFj3AG7l4dI?=
 =?us-ascii?Q?J/AjyjFJrHOHmOZulHWvFZ61z7AGILXidSBzbSKC7wGH/nUyVesH9uGVRHDV?=
 =?us-ascii?Q?znJxSz2ie5+1tsFxsrzazuDlXrHQvn2k2v+ubkmIg8P1FCZ33M5wb/Jm8F/b?=
 =?us-ascii?Q?eHzbKvBLKloQ4lCkoOlYKw71l8HVGGJpMqUzTErXxatsjMPJB7ixGfGDzqed?=
 =?us-ascii?Q?XZ9bm8Zs0e+6M8M9+fmw3+J9iIIXp7D04hiSA+KIL4ZvI0WQ0VtFDHO0F05h?=
 =?us-ascii?Q?GeDK+4BItNPcVpuqNJR6Bx/4YYg1UlnKp6MlZxj9XjklYMVl3zqhomQfQScl?=
 =?us-ascii?Q?rSO/IUkoW+lf4ejhf1Aop0wh00gzGzTFkSY5mJu8zBAH2HDSIBA1+w8RzbDO?=
 =?us-ascii?Q?Pl4FXfCSajC9PykkvYOISAGywG2gxdGsAEdRImyXfMApRsxALWzXw91f0OEO?=
 =?us-ascii?Q?SbVEWvRCniRoiJs8ITrHooVF7DJiEDPqKB+DL0rarNqyoI/oSGK0iLmrr4zl?=
 =?us-ascii?Q?xacjaIZtVgvEcpy2m696AslJluzg/C07Qaylb4XmzreSghLoPIBHfbjiUd7F?=
 =?us-ascii?Q?Ox/Uxqc1/cZDvyqXYUCyW0Nj2o4u5a+9GSS2l8n5FWMGeiqc8a/++qLsWn7O?=
 =?us-ascii?Q?YMBVOcxOuBV2dC/ADyzpSeqrbaOjaM7BkG+Zwoj7BRS4ZMxV1G+kG5ZOUY/L?=
 =?us-ascii?Q?9SfasAdQyw88Wqb/tZg6o0dFHQHb+bHYEl40Ovq5ZwCeLYAAKtqf4Y0Lyoj0?=
 =?us-ascii?Q?8rAxV/T3i8u8v8Z3QxOscvcq23HoE/FnuUW+wLPZMSet/3XUurFEsawloeCN?=
 =?us-ascii?Q?gchiqE8Ya+RMP8KZMse/spr1OKAjZk5xM80EolIC//bO8ArSyx+Ohna2CZyi?=
 =?us-ascii?Q?mhjvRkjzvHwfabPHqo//3U0zW39Fnf/l1NkPu6EUcFdQ9YkQIJ3kNo5Tsflh?=
 =?us-ascii?Q?6TIolv0Xqjq8GzPDQjT4asUP62f+L+0geHDdhh769Bbfvh9xg3pZU7KSZ8Uj?=
 =?us-ascii?Q?gt3sSiLyUCMAxaYhGkZn7kbsAVw4Droec3ZB4VDKHDAuGEXbrYsNLwXCgX+1?=
 =?us-ascii?Q?sM8ZxQucSFi76YT+lr3mW/qY6nQMHz5RQHTFs9mWvJlpGnQbl6LYPZ/ZAWwM?=
 =?us-ascii?Q?LJwqnb9On4cAzSXRaXIDbKgFBd1Do4VUmyZBYTj8UKUVaLD46Z4cyFlOIwxO?=
 =?us-ascii?Q?xdG/ClWxDLQhjK2UIVrrkkKdeYprIz1fE2yNYsy39cpyqQugA7NcaE+g8LGr?=
 =?us-ascii?Q?jzdwa6cSDU0mdvACg88i8rYetfY9WIhXwYfPLJ6ENdpHj7XJmGCCnoHI8hNM?=
 =?us-ascii?Q?29kH/0Q9Z3qsJkeFaOCmY0GdBnF2afptA4UyT8ltb2efGg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NoYf40ZAoLkvFxSawH3NYj2wfHj4RILuAr9gUn1hxgchWofArUHc//A6s5TA?=
 =?us-ascii?Q?sZdfyuQVeKaAUhoY8zqPaN5DwSQSuSgsqLnwMpsB3bF1SmNZ+017u36xg0M/?=
 =?us-ascii?Q?CHNZhDDCTTXJypHzuIEct0S97i8sIzoDRfXTvkxL6K8JTpeE4RUKkrsL6Fns?=
 =?us-ascii?Q?UZcSqTjgY4RduPh/NCTu0tuuLNPvUZmLd/AM2I2JgQE+4nC//NYsM0k93FQG?=
 =?us-ascii?Q?zOdx5ANtk/wMXdGkPbDANWmqvscsSnvrBunNIWfOnn77O5hwhRmUnwOF8QSL?=
 =?us-ascii?Q?aCPyTUelJ9IYi0IbYO0zgVEvZMD8wCJs+Ywi/b4N0Krk/JaJTIl4Rr/wczHH?=
 =?us-ascii?Q?H32GVqtc71USdP7BX8bfhsRXchM60DPCe4C4MrTk9xSiL9CRR5R/fptRU5NN?=
 =?us-ascii?Q?gkOL3FJOLbV5o6nDGCDP0W4OAU2iOkoSA7xpUpcJ6y/EjG5Y2Lbq07Kd7w/7?=
 =?us-ascii?Q?MdbR1rcclRR5njOW4A2CJC3tQNYmbRGRumYb0r8atCtexTjzHTE+Bc1ciF9F?=
 =?us-ascii?Q?5bQcwnrqlq28gQxg3vuSouWeclKeA/uh2YRe+V75+G65m43dp7q1wc7XrKnZ?=
 =?us-ascii?Q?f5f7DynYkzahEQWvBJYDemJ8UckOaRJthLFARG0AWT4/GXded3BrhWvdJ+ex?=
 =?us-ascii?Q?ipHFJQYl6KRXH6/mFL7Gum3CMek/OppZRM+zClwnkkEW+eApR+q1j90lh/wY?=
 =?us-ascii?Q?iuZYOwMRSv45FquOsQgvz+6FQL7Z4eom9jfuW9nTtkknfLqSnK7AVoRWqYnQ?=
 =?us-ascii?Q?HU/lkcCrWt+/dTKhKWokxW0OU/x7BSFZ0R7YO3gKjkNJANdRDatETYwj8Z2L?=
 =?us-ascii?Q?I0HBImZWE04fyo7Px5KPHHsGn4KxH6pnlnZKVhHbMsNr89wNMPWxgaVDqxWm?=
 =?us-ascii?Q?YrCmQo7BSQ6Gn00kDJ7cw0ifQRfoCnhhOHeVSQ5q3kMJw/WcwF/5SuxnKOO9?=
 =?us-ascii?Q?ZOFlNpjF+2uYSQUK9RxOGOPTdv0wRfhK2ZHp6y8a7qAEcjr0FYgPanNBzA6O?=
 =?us-ascii?Q?92ONHgK1gSUtzgs09rqdhknT1bftMnxGhSc+i+kwkLL1OegG2ZAsUMjE9w4X?=
 =?us-ascii?Q?UIsEtjWTWU2NBUbVRPTSwULtHtLelFt+gTwjXRpmSxPIxFkwggGhtvaL/wLe?=
 =?us-ascii?Q?aP6FQdyPSOO+bhlm1DMPa/ve7i6INLx/M4KVxIF01HVSceVjsnnvE8AF0WR8?=
 =?us-ascii?Q?GggtdYnk2/QPPCjLbn7VhSar6s1nx551EWJLpf1ocqfMFtyFuZGFpXTXSGgU?=
 =?us-ascii?Q?WBDjoM3BzEw8Pwwvhx0BJvDoiWuimRM6e+XhLbDn2caiui2elZamcoQoru68?=
 =?us-ascii?Q?EGsY2SW8CPOyjh9JoAHjRh9OcBpliJSsT+Jxu3ZwoyepL8eEhGQM7hS2VpLq?=
 =?us-ascii?Q?UW5oHZ1oTs/fKD0wuZwhFHpPE40KKi1XoBKV86sdTfJLS8Cl6I/xgKRbTae0?=
 =?us-ascii?Q?9bh3PBgSs3x9iDEm5P54trvgzeM4TIz+zEY9iI/qa1fRVdN2ugaaE2KWL5IY?=
 =?us-ascii?Q?B39OSaSIabKtxm6gwGJc0ZQcECC7+SS4lL6QGwlT9T18RU/U3kUpx5USbF1p?=
 =?us-ascii?Q?NAij+W4dEgw9FQHi+43yvuDMBcs5gA7kFeRLjZ0r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8d4370-d164-466d-ec26-08dcbc624d3a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 13:09:17.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBdfUpeLn9en4stQZEc+CgQFbBCfOkmbPGCqcGPSEYz85NqBr+X8zgg5qjopmyXN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6854

On Fri, Aug 09, 2024 at 12:08:58PM -0400, Peter Xu wrote:
> There're:
> 
>   - 8 archs (arc, arm64, include, mips, powerpc, s390, sh, x86) that
>   support pte_pgprot().
> 
>   - 2 archs (x86, sparc) that support pmd_pgprot().
> 
>   - 1 arch (x86) that support pud_pgprot().
> 
> Always define them to be used in generic code, and then we don't need to
> fiddle with "#ifdef"s when doing so.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/arm64/include/asm/pgtable.h    |  1 +
>  arch/powerpc/include/asm/pgtable.h  |  1 +
>  arch/s390/include/asm/pgtable.h     |  1 +
>  arch/sparc/include/asm/pgtable_64.h |  1 +
>  include/linux/pgtable.h             | 12 ++++++++++++
>  5 files changed, 16 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 7a4f5604be3f..b78cc4a6758b 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -384,6 +384,7 @@ static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
>  /*
>   * Select all bits except the pfn
>   */
> +#define pte_pgprot pte_pgprot
>  static inline pgprot_t pte_pgprot(pte_t pte)
>  {
>  	unsigned long pfn = pte_pfn(pte);

Stylistically I've been putting the #defines after the function body,
I wonder if there is a common pattern..

Jason

