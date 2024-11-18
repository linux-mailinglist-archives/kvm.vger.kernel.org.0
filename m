Return-Path: <kvm+bounces-31997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C19B9D098F
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 07:24:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C888281FAE
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 06:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A087114A0B9;
	Mon, 18 Nov 2024 06:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MzXAAvCS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E46054652;
	Mon, 18 Nov 2024 06:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731910978; cv=fail; b=CqdcmBO4bF/vyuEMtMCA6xPlELaasu2w/ylILyGfZ3/IFHxaBfky5E94K9BlDB5IAF3kTl0aeY9Jn9u02JPFcOFCWrM4MJfVv0CwSgIFn3oFCUII6ApVunqeb+KbVAFsZAZPaRpN0mSn7dnrxq/pmf1Z0/VPbJ0UUQyaGVvmd+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731910978; c=relaxed/simple;
	bh=eC177r9grPG01ePKgK1g/iugNV5p8CucWPQ84/lhUfQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bn+udVJAB3shbPxz1DhhG5KGH6UPSe+YQ7iSE8ep2g9f+GOlsERD7hxCRDoPnt8fyYsGuGU7+OH1meoqN7yPq2UsmD7Ny320+Ktfs5/W5nUeaMIwkOVxhJ2ZZEupvPbMqPS7g1ltrnQA6YCUaHOU/2mCW/VOfCoudl1H6SSteSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MzXAAvCS; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731910976; x=1763446976;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eC177r9grPG01ePKgK1g/iugNV5p8CucWPQ84/lhUfQ=;
  b=MzXAAvCSMDrd3po+eMLT1cufE5s9j6EjA2Ono7A9fdIYK0bngPT+1v8X
   srvW3WS0iANfOQFExeYtej3JZzU/fpCNcdUNPtfpNPdtUv6Mo2Qc35VCj
   XYwFtdWQuEtAT3flZbBdGsBCzFSeg1Pb1wfRJwmCmpnDdZ66tO7Vjmcr8
   JKHP3ZsNfAccdFGhw1jziyF5Fz4SFTyFr0yXWI+uOJ8m7asLZy6qsB6w8
   AnQQO5XjYM5E/zZuCJzYx/cmKM77L9DQkEkWk64AiuCU1kfH2SaO4B7Le
   zQ5OYRefEG3enw2w8HTW5KS+18jH7e7mjZyqVUYCOt1Un/9CU67//UOc5
   Q==;
X-CSE-ConnectionGUID: TEjsqvIYRbSyh40wiO/73w==
X-CSE-MsgGUID: y2ZTPPHBR/+bcUtPSIgRaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11259"; a="31258786"
X-IronPort-AV: E=Sophos;i="6.12,163,1728975600"; 
   d="scan'208";a="31258786"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2024 22:22:55 -0800
X-CSE-ConnectionGUID: jAurD3iMSfKUUjNcy6hlng==
X-CSE-MsgGUID: BB6MRUx2R/2TpYZhhTMorw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,163,1728975600"; 
   d="scan'208";a="89133783"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Nov 2024 22:22:55 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 17 Nov 2024 22:22:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 17 Nov 2024 22:22:54 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 17 Nov 2024 22:22:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AT6HyUcqbvb6ko5sTN9o92g86uwF/HHdZ2NCmOMgmRT+Gj8/Y9AEZ+pibj0Dl0gTP3TYKwykDEhfn8TmcdIefQo3kASVzNWzZcZP1gbUXsXB8JpA1bX2HEHkna5UehEqYXQxuqqJF19ebLVtmdjOtnzKSuMDsgKTf7nOXOxhvktQyKgoYDasFJeKH1CoA0HY0tOcItlzidgl+tHNUBB9mtebfD8zWGFBDeyliMX+iQzREDWR5zkQtKt4MJ5QTGVgTTvzVwkHi953WQ//rufvry82kT7TwmfHo7tRlqfdyMECprBGw8sjy5FkhZSbBvKDILLLshtIX8hm7R8GH3wznw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KccnVHFySQz2TwWKCkd8WZbBaNZNhtr6/5tFyd1iXjo=;
 b=WtE348P54gDPnSOhSppFPz/oK9iP0M92spxOc6QKrULL+dmofgOKfmXhuo1Aofjcv7bM+inhfRWSaLDkCtb3WHW96pD+FB0WPt4/MFFGkcMv+5GGSbvV/P1972EYakrdYKwEsJA5menjIwgEcTmXdsruQ3EpW1v0XWnj2eF3EsxusajZ7H/7WzXQLXp96kIK292p69MubWVZ6Rgs2ae0NorJPKmHOmZbzzFEHvDPMF/DIRMIN/T4deeywOLekuquwfbJmQxDjc8P9bp+VZHstsooU4j7+/4sjBBG3BrTzacunGKTP2echMOpIFDkC8p8hdIlOXydkIbhfCdWTYznBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8447.namprd11.prod.outlook.com (2603:10b6:806:3ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Mon, 18 Nov
 2024 06:22:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8158.021; Mon, 18 Nov 2024
 06:22:51 +0000
Date: Mon, 18 Nov 2024 14:22:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kai Huang <kai.huang@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<reinette.chatre@intel.com>, <binbin.wu@linux.intel.com>,
	<xiaoyao.li@intel.com>, <yan.y.zhao@intel.com>, <adrian.hunter@intel.com>,
	<tony.lindgren@intel.com>, <kristen@linux.intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: VMX: Initialize TDX during KVM module load
Message-ID: <ZzrdL5iSu7/DNoBG@intel.com>
References: <cover.1731664295.git.kai.huang@intel.com>
 <162f9dee05c729203b9ad6688db1ca2960b4b502.1731664295.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <162f9dee05c729203b9ad6688db1ca2960b4b502.1731664295.git.kai.huang@intel.com>
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8447:EE_
X-MS-Office365-Filtering-Correlation-Id: 26cb5637-e92b-4e8b-2c72-08dd07996e1e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JvDlD+cMqF5Q0nl6fEj2OhhS5zCn9mB5bpiccSqW5SrfpuQiHKkMRlhDyIit?=
 =?us-ascii?Q?KVokZuD/TWxiHGonwOF1SQaT56Q7SqsGmtZ+zBrAykPwDQUpallwVlGPQm92?=
 =?us-ascii?Q?bsaV7ChMFqs1Y+tfjECabm/N8pOps5mX3+usqYXUxno8Ch9aR8RLjTBt+hNc?=
 =?us-ascii?Q?uw8i61/C4sCF51aAKT/LrNa4/vS0GAAMAlNlmmQDorRI7Vo6Sm1BXDVBdLDX?=
 =?us-ascii?Q?7JdiT/ape2QXoA54gz0XLXnpVLO3yPhuIcri/BFco1X16+HoiVn1wnucOaIt?=
 =?us-ascii?Q?B2l2daLFcX8/8WhVVWCPnacwjoq0Bu72KYQYy606tjWBA862vau8P5eG5I1w?=
 =?us-ascii?Q?Vu6ClbTNqqGJZCjS7egFUWc0Wk2ZPSXFXw8njs5OKb+zpQpOC95QtaXjljTd?=
 =?us-ascii?Q?p38iVDOA5HWLJAftNNzPWz0E4kP5lpDI16FkuzH+Ge4Uzh2TDu2OuCBBMZHi?=
 =?us-ascii?Q?DK0GMUMAJ1RF9F/RnxU5Vq0gilbJiovDafm27VCRiGpW4ObvJuIjU3+KMF1k?=
 =?us-ascii?Q?fOZXfcDsQuodTc73nBGoT3HhGzXnSoFGPHZ1zVHwrnS9f6Qn6rSrbo4kdMks?=
 =?us-ascii?Q?2RQibuaPMXp6VnbpcpDRjrtPLgEuphe8ilEj6QqHnZoJaxtaG4wpKcAK5TMH?=
 =?us-ascii?Q?YWOLwHiRgg7vHBcXdxwYPc5PR3E3GKDsu/b6ETSnJ/wvB9rvPdjTifam/kGe?=
 =?us-ascii?Q?ztU3iyuqN4Bkc2lZsy2fUmLs7rDH4FEy4BHnaWMAhlw6Zk9BA0vXAmNBHHv7?=
 =?us-ascii?Q?KUEM4ryXjN8Knsc8WIhGD7ypjF8lAk+1hlKzVEudEsD7NozR4oQqAhtDwPfN?=
 =?us-ascii?Q?5BdgfrapCFd4Ft1dQylVEQsqxcU3rXxz6A3SK54ZqnMM2jQuVYBxpBQRmMSu?=
 =?us-ascii?Q?GF9/R7yWGjvuoWpTyA/Qa4V1mj53uxHW7ZklnuiMZ+SKERQiwOD2wKgMQjZS?=
 =?us-ascii?Q?wnLJIh2Nu2CGJwW5yHut3e3hM3xBOoizBhN+8soCqtv0FYRo60wEljdoUejJ?=
 =?us-ascii?Q?nT7s07iOw5esEZYvSXpSUQaWb/o4nnsKiVS2/AyDXUhW1/TI/3HQYbW0qwK2?=
 =?us-ascii?Q?RADiu9rjPGVkU702AKD59FZUf75PvywVvOWzBFg+Wy1YB1AYucvqxMuU+/Jy?=
 =?us-ascii?Q?A930Q5OeeHM1vw6B/16H66zIERYA2FcXHOB1M+ivxLSGghAzj32Fv+Fxjt2V?=
 =?us-ascii?Q?Od+syEuTolFF3dwZYXj08K8Vxc+v7frSkdDOS9dmr74KKv9NfUbdvWY977nI?=
 =?us-ascii?Q?Rla+z1Z+2JGBFll23ZrJluM/e0ygpwnDwWAW3ZpkYkeog5YRpknVCwXRd4it?=
 =?us-ascii?Q?uAYKrUfwF8l3Z/kc/BnrHVBs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ID/dhbioTmJH9/MFMsLmMsuaO/WatYfwHnar4H3S5vJbUGz3vI75Vq5SM+UZ?=
 =?us-ascii?Q?qb0BnEyrf+qHbbv2kWheSaUqSUkO4V2n4tDwottdAXJ7cU8iOdVjnuBeS+9y?=
 =?us-ascii?Q?0oxwiNCFBSoBYKUd3yx95urwkWV3R5J9wPbQ4pfn3tpsbuMc3ERapU5SeOpy?=
 =?us-ascii?Q?jv5d+go1tkgmQvt4BPVY/TdGRynn6Fmw3h0um2YrNalVCHWIOFQ8xb4gkokj?=
 =?us-ascii?Q?AafeInudm1cXprWiKBTBAQnkMsV7NMJQAiKh5Wswjsp19szB01fIYsecAbJZ?=
 =?us-ascii?Q?g5b1uBJwH16Dj7Lm9zCBVBbP6DfHoOsX5XzK/gLTeH8xD85PFS0JOoom5T5B?=
 =?us-ascii?Q?rK55p0DKqJag3L34Strciskb5Be5Jl4I3st73DMX2vNnRugCK8V8lPWYX1lr?=
 =?us-ascii?Q?JUPymZCqpi1vhLWkS7sQKJIsIcUlW/jCEFiXFfbzy/uPvKl02RsNm14gKUL5?=
 =?us-ascii?Q?5YqOnfLCyCo3BmL0Tv34zA3bgph2gb2KXb9MaaY1qPmyTeeTBXFgAIllA4eO?=
 =?us-ascii?Q?siPjJPRzJo2/uQccOdPBRW5irjg61N8Fomy/h0ttpGKvjflcrtRq9hU0+OY5?=
 =?us-ascii?Q?P2cc4kjlrsNZ6O53y50rJq/KWseDigRoHNrlN8gCcjfflYBTFVvwXExKbG8K?=
 =?us-ascii?Q?adGvm8sXZbl1LUAHAA8UI+8Ri2tpR/PRaffEw4DUvznun21DlodF4x4qAZpO?=
 =?us-ascii?Q?7EO+Uq+IGdbkJEktg4SA7UgFYDYd6b2Pr2UTPSYQA127jFsk/xxWvlch4+ZQ?=
 =?us-ascii?Q?Xv+t4Cik4Dh3jY9DCMvs6kicNx4XKtldAGpR+bNw+OPJ67v+l0bpF02jbcPc?=
 =?us-ascii?Q?8Vyt+kp1Joqfxgo42ENQbDVnYM35iKNemGrOBDEC4LOOPSXA16SMwyNZ0rNn?=
 =?us-ascii?Q?Q5Us9+wvDz+4aoa7nqdkk1q7JAfYNoZfdb1hPE1y5Z7AHeYmK6YgueWAVXlY?=
 =?us-ascii?Q?nowWf35CopaVYa+6hLeVElAjGE1uHD6FsiDrroV3ykZtp/0JRQlG2RrXxyck?=
 =?us-ascii?Q?MuNRvkY5OpOp0XMU/SU+HC/B1kQpFnasE1lgcruyIPGADLZZMxEIfrvLhih0?=
 =?us-ascii?Q?fBijvqnb7hIZS0iBX72IK/RAB/6CZgh90wKDO5VL0c/ZKcPjxBCKRSvYT+VK?=
 =?us-ascii?Q?Elnsq6+Q4MgHkDEMmVX9y8S09fv360h1ZVFBUtPh3zd8fvjQvblOZ/tTiYVm?=
 =?us-ascii?Q?ZzmIYxygMOM+Cs7RJ9gy6MHXt+3BZrPEIxZfZ2XuesPbe97nO9MPPvcbJbNr?=
 =?us-ascii?Q?4uhjAnLZpcwo9ya/eXXmUI/GkVEOCTCzJJsfQpPUv3xidWYiZobPkBM7besm?=
 =?us-ascii?Q?e1IBUPi9nUysG1DjbHqCJzpc2/9B8cSz8LpPMC9QgX4mnG7gzuz2L284uNA2?=
 =?us-ascii?Q?7PPr56lXktx/Os421xEmT8H+ygh6uS79OtKfR6qxZT7MHcCqD3z28qjFSinM?=
 =?us-ascii?Q?nAybIm1KVP926IJZ7qCM3KVcNWo/2XZUwC4sK2zRCeeS8A8WLLx6HbwoWMyO?=
 =?us-ascii?Q?QnM3gY2trtNZuLSPTuQXjQrXwPV63ck5NszspnxPOeXGltngFOLiBQgiOCC0?=
 =?us-ascii?Q?yk8DFl2xgdZa8ksi1M2sNcbNwqAXbBYMLf2L2BeZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26cb5637-e92b-4e8b-2c72-08dd07996e1e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 06:22:51.7620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKTd+zr2sUjXldd3U6qPD8nbBiS35DZusx52yb8Qy3UvWq9p1fztAC/0LVqPGsf3xrcOKzFrK+Rj5mlPb42cdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8447
X-OriginatorOrg: intel.com

>+static int tdx_online_cpu(unsigned int cpu)
>+{
>+	unsigned long flags;
>+	int r;
>+
>+	/* Sanity check CPU is already in post-VMXON */
>+	WARN_ON_ONCE(!(cr4_read_shadow() & X86_CR4_VMXE));
>+
>+	local_irq_save(flags);
>+	r = tdx_cpu_enable();
>+	local_irq_restore(flags);

The comment above tdx_cpu_enable() is outdated because now it may be called
from CPU hotplug rather than IPI function calls only.

Can we relax the assertion lockdep_assert_irqs_disabled() in tdx_cpu_enable()?
looks the requirement is just the enabling work won't be migrated and done to
another CPU.

>+
>+	return r;
>+}
>+
>+static void __do_tdx_cleanup(void)
>+{
>+	/*
>+	 * Once TDX module is initialized, it cannot be disabled and
>+	 * re-initialized again w/o runtime update (which isn't
>+	 * supported by kernel).  Only need to remove the cpuhp here.
>+	 * The TDX host core code tracks TDX status and can handle
>+	 * 'multiple enabling' scenario.
>+	 */
>+	WARN_ON_ONCE(!tdx_cpuhp_state);
>+	cpuhp_remove_state_nocalls(tdx_cpuhp_state);

...

>+	tdx_cpuhp_state = 0;
>+}
>+
>+static int __init __do_tdx_bringup(void)
>+{
>+	int r;
>+
>+	/*
>+	 * TDX-specific cpuhp callback to call tdx_cpu_enable() on all
>+	 * online CPUs before calling tdx_enable(), and on any new
>+	 * going-online CPU to make sure it is ready for TDX guest.
>+	 */
>+	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
>+					 "kvm/cpu/tdx:online",
>+					 tdx_online_cpu, NULL);
>+	if (r < 0)
>+		return r;
>+
>+	tdx_cpuhp_state = r;
>+
>+	r = tdx_enable();
>+	if (r)
>+		__do_tdx_cleanup();

this calls cpuhp_remove_state_nocalls(), which acquires cpu locks again,
causing a potential deadlock IIUC.

>+
>+	return r;
>+}
>+
>+static bool __init kvm_can_support_tdx(void)

I think "static __init bool" is the preferred order. see

https://www.kernel.org/doc/html/latest/process/coding-style.html#function-prototypes

>+{
>+	return cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM);
>+}
>+
>+static int __init __tdx_bringup(void)
>+{
>+	int r;
>+
>+	/*
>+	 * Enabling TDX requires enabling hardware virtualization first,
>+	 * as making SEAMCALLs requires CPU being in post-VMXON state.
>+	 */
>+	r = kvm_enable_virtualization();
>+	if (r)
>+		return r;
>+
>+	cpus_read_lock();
>+	r = __do_tdx_bringup();
>+	cpus_read_unlock();
>+
>+	if (r)
>+		goto tdx_bringup_err;
>+
>+	/*
>+	 * Leave hardware virtualization enabled after TDX is enabled
>+	 * successfully.  TDX CPU hotplug depends on this.
>+	 */

Shouldn't we make enable_tdx dependent on enable_virt_at_load? Otherwise, if
someone sets enable_tdx=1 and enable_virt_at_load=0, they will get hardware
virtualization enabled at load time while enable_virt_at_load still shows 0.
This behavior is a bit confusing to me.

I think a check against enable_virt_at_load in kvm_can_support_tdx() will work.

The call of kvm_enable_virtualization() here effectively moves
kvm_init_virtualization() out of kvm_init() when enable_tdx=1. I wonder if it
makes more sense to refactor out kvm_init_virtualization() for non-TDX cases
as well, i.e.,

  vmx_init();
  kvm_init_virtualization();
  tdx_init();
  kvm_init();

I'm not sure if this was ever discussed. To me, this approach is better because
TDX code needn't handle virtualization enabling stuff. It can simply check that
enable_virt_at_load=1, assume virtualization is enabled and needn't disable
virtualization on errors.

A bonus is that on non-TDX-capable systems, hardware virtualization won't be
toggled twice at KVM load time for no good reason.

>+	return 0;
>+tdx_bringup_err:
>+	kvm_disable_virtualization();
>+	return r;
>+}

