Return-Path: <kvm+bounces-18095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD738CDF48
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 03:48:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F202DB20E52
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 01:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E90C1BF53;
	Fri, 24 May 2024 01:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l0cmhgxq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA314A3C
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 01:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716515313; cv=fail; b=HnuoxJnDv4mnp6tIqUbU8bI7IYyilzGdrAG71yezksJ7e5DoCEth1emVWBJ6tF0qW1dRkALzkzjXLZSwSCV156pCibDbHZFBSQflD+gHOf+XPKA3oKsu1itetvcJUHzAdZebBUpskleGMWO581DZ+BlZ5Hjp3ullwPVuU9Guzz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716515313; c=relaxed/simple;
	bh=p/2HvA+bqLjFOrjrWpNhPYW2xxTNZe6idxUjZeAphkY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tRNL0FF1fs4miihGBGkocbLBm7issdz6N/8dDde+jqXrxxo6yzLb+WwwzImb+N9kG7PGsWxjMzwRy/RZda60mD1SJnNFnV65NN9o19MP9sIAotw9yQ4OOk3B6RKJUifuRPoYkteQUbuXnjqxt1xyT2NcKkwncOEmvv/jvq16XRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l0cmhgxq; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716515310; x=1748051310;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=p/2HvA+bqLjFOrjrWpNhPYW2xxTNZe6idxUjZeAphkY=;
  b=l0cmhgxq5xBvREQZuRdxBAHiJfOlg+sey1ooHQ8ekQR5dx3UaNofLOkC
   UgGpIYLSIzj1p3einifAettVpNhIVi+RGBkC+Wu5MhvgsnOkVkaauEnfF
   j2OMd/2gsxVdNyd3mHjAwG96U3G3VMGP6l22zMnPgiFiFeYBoIqaxNKio
   qs3TgfoI5zDhyDdJ2rah8tI7spfS9pADsg1LV/PSwAWegTqgDVpnOjQFn
   eVFpHra9RAZnxEpi3Dx0pEqxIGwzhRVaw4pqqslBOvMwH/C89xcy7w56/
   gPszAB3OIYUECymzOkU7PNim18X3dkRpzcL2TKV2klHZvnfvBpVy/UTp9
   g==;
X-CSE-ConnectionGUID: 4bFVYpYGTg+hoar5VYb2Ow==
X-CSE-MsgGUID: HA5Bbo70SwePhM/6zlrt7g==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="24285173"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="24285173"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 18:48:30 -0700
X-CSE-ConnectionGUID: 3iAGrtpTSiK8gj+KZMXQvw==
X-CSE-MsgGUID: LGY9Y4rsRjWtj/F/4Rp/9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="38853879"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 18:48:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 18:48:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 18:48:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 18:47:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7bey2UTX3OzMe6j6ry6R75xZ4biZEyCdn7/OZ1/+BZAlS/x3GSUbyNgajsnBf1g+GMxN68/ck8sXb/ROHRHC0rTI8hZK7I97VoF5WTWtaIh7MU2DtlctnJFTnbkl9EMNrlwMFGQKIXtfHqtKNIafOyBjlQzvVo1yyRe905+Ea0y2/JEpVbyXp+t6wQxjSOZ1/FgEyqAEmcr1AbRgG9i04ReoK+YVDivfvmw61BnXNw5Zd2nFiibmxb+/q/A/Agp8nbggxkIYIoEhpoHwlVan24FS7YpRl4krBBL6/Ukf/kqfeIEWhi0aBgfeMWqo/86Yxcf6xNkvxw+KZQLX7NEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3BV30nw20tYFBYAca8yOv6AbQ0GUpZnCTls5G2Y2RvA=;
 b=PL77oLRS+otRAwck1HdNI0f1XRbaCHn1cBZnAMt4hmKiYU3si6vqcbU+GAlsc3HdK6hTBC23rnw122G6b+AK0ku1LMEbqEZgIVB2J2TLwSLkgqMjXiyRsMAqN36BBGREDBMPtbvsTCCAB/Y9/pNsW65GWsCYv04DGZIm9Lu47HXLuKTRYV4rgbxRIL8iaHo5CmbVnTrBa5EkMH0NbgbvxKdaLtsJ7HBhVQSR083gTKJSGaiU8HbxgeV7B+QXcI03Dowrkl791MWp3OS+0vwLmqE2VCfrE7REEzht6zQo9NJPrFo8B9/15jpXXDQrNpPYRgrDwTK31fbwNx37SkuUiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7744.namprd11.prod.outlook.com (2603:10b6:208:409::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Fri, 24 May
 2024 01:47:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 01:47:52 +0000
Date: Fri, 24 May 2024 09:47:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Peter Xu <peterx@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<ajones@ventanamicro.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <Zk/xlxpsDTYvCSUK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
 <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
 <Zk_j_zVp_0j75Zxr@x1n>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zk_j_zVp_0j75Zxr@x1n>
X-ClientProxiedBy: SI2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::9)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7744:EE_
X-MS-Office365-Filtering-Correlation-Id: 502c82e5-f529-4154-333d-08dc7b93863d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DxIdvXAfswqZ+SZgVPziXPnVpUAWVkFAjX/lRzKEtOyjH5jU+bKgKQe91gX0?=
 =?us-ascii?Q?pkVDC4Efkt9/L5GX8k/wK1Wh2UMb5g605BeEsnnZnTEzIG6uR31AidC++WG8?=
 =?us-ascii?Q?uHAGSAP1bjwbM8Ceiacfhy2NYKkMCU1IakWNQcZQm44FChIkZdtqO86hfuoT?=
 =?us-ascii?Q?Qt8GZZw+CLlA6ECw/gC8kEZJMNBy8N+/3iyywxXNHgh5tAlznWRm5GRKju0a?=
 =?us-ascii?Q?JdKIXZ4EnNX6v7325XakpSjgI4HzKaEEm3ydHZ5UJrvsJu2uOA4k1/+ysr65?=
 =?us-ascii?Q?VLm951TE0U4J3FItnDC/wWgC6GAW53rJVrUm16ZEZUZ0PCNb/mf46/SIj/h1?=
 =?us-ascii?Q?X+tgZvBTwXSTs3kdsQZoG5u4gBf9n50PQ+4KcAAvH/hRVb9hK8WFsxSq44hN?=
 =?us-ascii?Q?91r0gy/FwtKm6wpzAg5qWBEPxQjsaEkXcqI5LhM+Z/snJxNHQoPg0lQkn64j?=
 =?us-ascii?Q?uCKu21DLlFHegnI9I5ng8yrp/8hywdL8Wmz8bPOXAEuFbvTCWEFz/i8IlPAy?=
 =?us-ascii?Q?dOOQTS9+YQCowohDG67rnpJXHiUYDLbepUlh9TDQ97pmiq0TPnpfiIuFtEBZ?=
 =?us-ascii?Q?ZYHISKHy7bymy96VQ0TMBkLgcUmFvzeINk2ejbDUXP1XyIcRzYP3yPK9N7L7?=
 =?us-ascii?Q?hKuEKGCQ8kgTQV/OElUUCU3ybO5tlSjFp1Vh+64+UKBd7DlMRAAHyC+EaIZx?=
 =?us-ascii?Q?ZFV2P0Zvao2r7lt0S8z1kv25NRLw06Hq+uviLOsZsryItaHfj9/ZLUPzmosy?=
 =?us-ascii?Q?H/p/V6nP1OZ3hiHgc5Oj06GhiDAr2jMoiNkZ67bhViouOGQQauFx596BrBBl?=
 =?us-ascii?Q?g4Tlc/wAX0v6u4Shx90bsbQcW7ppX1Is8MHtDa3TbxqX/gpIQEPjTUunvPVX?=
 =?us-ascii?Q?YnIdkYmls/dfvTvnRtAFv9NIungkYPr30RhU6yivKeApG7VXZzvR2GzOMW+V?=
 =?us-ascii?Q?h4+Qtyp2GKKqlGpkfwNpv0b67E7Mq6X0wdZSYfcjK4bVhlt7axlKbzKYRrrM?=
 =?us-ascii?Q?tu0K71D9rmVTA/cYxCazd20idjEhv8uGs36CUkOov/kEZokSWQgtoNMMOVrN?=
 =?us-ascii?Q?F/eNfC5VcW4+7imIcWPqydENccAHm2/esgflw8/RWHvJa+Pd416kbyrR4SVJ?=
 =?us-ascii?Q?67Fkf7B2iapbouehvGer0m0QOjAedvE7hw+nd+UeUaUadbxiljvaK9bwYECi?=
 =?us-ascii?Q?swBv5EtpI59gBtSg5XQTIwlCvdYd/VtPEFd6S/cn6Egi/1egJoFcomWGQ9k?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7QRp1PS201unmlkgaK5908tkVvOpgNryVWJC7iG8urPiFtLCxrn3zMwi/IYC?=
 =?us-ascii?Q?TkmYxKy+Jfloix2DmOz/MsWdjPjeZp8tO6wc8iA4CnGW1LP9Z+kBvsdZzLIX?=
 =?us-ascii?Q?F3646TMCULZSCIBKZHh99+61OmgF1zi1Y8BZH+n7SYb9sQuUWcKiyqqndrrv?=
 =?us-ascii?Q?N2mf2iyn4CEkBlZId3BFgPgvPB03eBrlqP1wFjiDF8jRzj5JuNDopLJfK1mh?=
 =?us-ascii?Q?IN5rTWAUDWpNbHVg5s6r9V+awc4A9QxB/tER6vhJBWdYm4IHlavzd9DjPtDZ?=
 =?us-ascii?Q?d7iny71LBgE9y8PBP608vpwSt0n8Mjsp9dRJX0skiccpOtG7iNvnX9yWYSoY?=
 =?us-ascii?Q?w6/CSuM9sRoyp3pP+HFXSEc+/2IFQkvvnUi+saoQ8NRqhts6F2geT9meKOxO?=
 =?us-ascii?Q?I9t7sDRcmIvPHVuDc34YELDRQ9kpoXOIKFL4qDIcU5R6HQyIs93yMWI+qq5Q?=
 =?us-ascii?Q?JYm0+ad4NpRMZwN4mVxRhHD93euC6y11YeNco2ApIo2el8Xxvb5jmJFZslXq?=
 =?us-ascii?Q?RVQ2r5NubDXoD8CnNZOlTTh58Bn3OgkymoK4BMbudyDEBhBPko3ppdDePlrb?=
 =?us-ascii?Q?Vpe7pj2h1k+0LmJMB0wiHkumd/FmTQyjLP9TiVEsafn1SQxvFgnEt0laVuno?=
 =?us-ascii?Q?Ecx+uSkrtM5wRsIho8LyhW9a1XLPRG0tELauJrmlLPdKXHy3MnqveI1o+8nb?=
 =?us-ascii?Q?BMZSMG1g2gjcta6NuT4+HdlqggK+w6PopcKdOF/lp+wIlu3Z7ZOqLQ/3a/PL?=
 =?us-ascii?Q?hSo8bekzwjplRv1oBD18skTmpoGolRukSfw+AVSfl3NGIGS8bwq/AvkqWREB?=
 =?us-ascii?Q?xp1aNkgRdiEgvOiG3XOag+RHFN91ABA0z9wVQ0FWZNEDi1SO2FnLjxr77Nqu?=
 =?us-ascii?Q?7ejoCmFz8ITyFq5N/OF5+7fxVndT/Qe/fTZUpNH9jUD38UHTttvCH9Rgk6Ov?=
 =?us-ascii?Q?M6gmpgb18SccV32nn6mliahDTAU9IOxThx2YiLT7lEgj1TTHyvchM6OpqvZl?=
 =?us-ascii?Q?wwf/R+sKKXyM97onzjqjRir/2BV8Xkz3MQ1zfFI9rmGd8jgiyJZqYtmLRidX?=
 =?us-ascii?Q?z0LQh/euRBDCXT9wtAGoxJw9agdog2rPGDeNkQhF4NdNvzM1l+3WLLBNlQ9O?=
 =?us-ascii?Q?3XYN1Yw7Vo/lRd7muIuZXyf7jH5coVNblsvbKchFnNXpdFlVLgqjQkOEoX9g?=
 =?us-ascii?Q?64sKAdGg1RMYKVreXjK40gFRmsQYFjFVKNo1bhuhCUSa8Pv3W8SSJqVoh4h6?=
 =?us-ascii?Q?bVYdfUPY15IOTO7b0UfZyoEaIComEaw2hr7Ip7Sc2gG2YyhKugUJ/i8/pIfS?=
 =?us-ascii?Q?v/RVYN/yccU1IylcfAql3wE8DGRDk0f+qk7SrLZiILHyPqmi3H8NEeu0PYuL?=
 =?us-ascii?Q?6D59ErQZRkhcfKH35K+EnmqrO4H2kdaF60zkhTFVYbY0W4MNlgRqfgiRvWCO?=
 =?us-ascii?Q?/mWD7iXhTWsIAObZpS5dyHdkdAh5R9bo2PLOCSC2FtwllJbKL55q2ldTsdrd?=
 =?us-ascii?Q?+/TIwcRALo71XO2y/wh76alxg1f0fvWi2Rfpf71A3l5D/e0yoPyLqiYa/fzS?=
 =?us-ascii?Q?LE0HR/oJN7giypfzWocSlerg/OWgsVidbwKsfhjd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 502c82e5-f529-4154-333d-08dc7b93863d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 01:47:52.3357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHepOGv/zhwkN2IEUP9gglL2VdF8T5VV3O4smlITm50NYBL8dp4hCocsc/7nqIFTttNFhXjgEVeUIs3syIfzqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7744
X-OriginatorOrg: intel.com

On Thu, May 23, 2024 at 08:49:03PM -0400, Peter Xu wrote:
> Hi, Yan,
> 
> On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:
> > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:
> > > With the vfio device fd tied to the address space of the pseudo fs
> > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > device BARs, which removes our vma_list and all the complicated lock
> > > ordering necessary to manually zap each related vma.
> > > 
> > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > unmap_mapping_range() to zap a selective portion of the device fd
> > > corresponding to BAR mappings.
> > > 
> > > This also converts our mmap fault handler to use vmf_insert_pfn()
> > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
> > for the PFN on x86 as what's done in io_remap_pfn_range().
> > 
> > Instead, it just calls lookup_memtype() and determine the final prot based on
> > the result from this lookup, which might not prevent others from reserving the
> > PFN to other memory types.
> 
> I didn't worry too much on others reserving the same pfn range, as that
> should be the mmio region for this device, and this device should be owned
> by vfio driver.
> 
> However I share the same question, see:
> 
> https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> 
> So far I think it's not a major issue as VFIO always use UC- mem type, and
> that's also the default.  But I do also feel like there's something we can
Right, but I feel that it may lead to inconsistency in reserved mem type if VFIO
(or the variant driver) opts to use WC for certain BAR as mem type in future.
Not sure if it will be true though :)

> do better, and I'll keep you copied too if I'll resend the series.
Thanks. 

> 
> 
> > 
> > Does that matter?
> > > because we no longer have a vma_list to avoid the concurrency problem
> > > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > > huge_fault handler to avoid the additional faulting overhead, but
> > > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> > >
> > > Also, Jason notes that a race exists between unmap_mapping_range() and
> > > the fops mmap callback if we were to call io_remap_pfn_range() to
> > > populate the vma on mmap.  Specifically, mmap_region() does call_mmap()
> > > before it does vma_link_file() which gives a window where the vma is
> > > populated but invisible to unmap_mapping_range().
> > > 
> > 
> 
> -- 
> Peter Xu
> 

