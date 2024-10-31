Return-Path: <kvm+bounces-30145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA429B7357
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 04:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D6A61C23FE9
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 03:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B426413B280;
	Thu, 31 Oct 2024 03:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bnNE7Qlq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A261BD9DC;
	Thu, 31 Oct 2024 03:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730347177; cv=fail; b=Yyga/3FnOJhYI+tfCV8aL9Qa/xYf8SyF49giFTL4UVj66rVF7N4uBEu8Yp2L/PASmwsoSlDgPcybrlXZp/WW9fWqPaQ4SwV3rt0Z6VlameHtDqyMqSp9WMgpp2tdeX5rPTX7BYiSPQTQXBqdQq57T5aRiw9qTqaFLJ1Lw6jQ++U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730347177; c=relaxed/simple;
	bh=p7LMUMoaeQ7SRuHC4KCnfNvkwURiyYFlJEncyQhxzGE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nakfrS4RTDVDy3fFHy8H75WdbtKnpUXpdhTx4U6MuwH6scNiTMH7ASENN06q8uF8hOwNtlglJawZCAfCe3cTA4l1+0+hszTC6O18PDMkhDapMMSKgzW9IxkqFrj9FQcm2RQxCC0q9Sk7mzqkOuMlb+UPuK+tlIO52PQzy+HQeOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bnNE7Qlq; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730347175; x=1761883175;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=p7LMUMoaeQ7SRuHC4KCnfNvkwURiyYFlJEncyQhxzGE=;
  b=bnNE7Qlq0uyvYhrCbxL0tj8rTF2yfMYrUJknEQA8dzoQc45C6WeIAaDZ
   swct2a5WS8nK0Bwg+Eyjzp0gnjZHFjS3gK4z/Df0kF7877FbM+PK7a8W5
   JXhwNW92odh80rHHv6MxRvU3AW5JmROy/bNhFDgWtNtl3ryF181lJGGKe
   +rsAPPmms6RvCSYfPMJ+J65rpuNc4DfbQZy99XWJwJAWSGGkh3r34Jm1S
   MbSBX9EI9VBAxtwyLkfG9Mbox4lZAGyGJLVSVya9VMntPJ00uqQ3j0qMS
   MfTzc0162/JS2Sgjpx0hZHGLVuZn3VZFQyKpjWBzFxN3QwoaXReO5L44e
   Q==;
X-CSE-ConnectionGUID: GhpKamu5TPKtXViFq/6UZA==
X-CSE-MsgGUID: 3p/BGzKfQJuEwYlDHfoxZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41170623"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41170623"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 20:59:34 -0700
X-CSE-ConnectionGUID: Su1/gy2lSYuV22GT3naz2Q==
X-CSE-MsgGUID: DLlxELT5SUqB0jb7TWXURw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="87297523"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2024 20:59:34 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 30 Oct 2024 20:59:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 30 Oct 2024 20:59:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 30 Oct 2024 20:59:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZOldP+jYJJT3z0O5k9AqHnaH6lb6ePM+VhcOYmMfjlOfIGPnHGb61NbnJ0DMUck6tQuDh8ikLn2hS2WSOOZVO/ovmB1D4gSuQEXn8cC/xRnpt7XL1LpJ7kx+1b3FVzMp/8pWvZTL7Ca66NG/1yyFVlXAtwy+VzkRCMe92mAylyu4SwFbjRWXiqSQ1FojmiVaRkRRf/KGlCOzXql6Y+PiH+mLKSuvIr9aVD9uvqet2zSlA8z/iolBTVpL/SZQAquPx+MbmB0h9bVS6GR4yhfr+UZsBFMrxrerJ40bVG3ja9kiy6chxw2AksjbETpq+htvTxRGTfOmEmZpQREL5PmLYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNHZtLAy+HKS0PgZxL2A++ifH3lt+O53/KiNL7/vlbo=;
 b=F3ZSU2+3dJ5/DNo4qEaN+vrta2pv5KD5ysAsHQHS+b/AesnQ+k3tsC0JGhFB+XUAjQf70DnY6ZjU3IWAp18b5DKqziIOu6OYjIt+BL274Lr5PmgMaRMTQ1955AoMrfLv/4m/7rL1cP2/jrI6dcS/TGDytQNX80gHikux49ETNAScEggZBZEyv+zwGBwaw26vim926XD/zGtzxReaIDhjN8C/3EOWxDxQzBS+9HU0i92RLqXgvgqtsSNlAsF8kr1aENTh/ft79lqvRdSba+oBbLPCZupLpexTev3LjU7ayM8jND3pXzK5il5uxukvXjE0whA2ZdxgKCDdyiK7k3a7yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8600.namprd11.prod.outlook.com (2603:10b6:510:30a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.23; Thu, 31 Oct
 2024 03:59:31 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8093.024; Thu, 31 Oct 2024
 03:59:30 +0000
Date: Thu, 31 Oct 2024 11:57:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <isaku.yamahata@gmail.com>,
	<kai.huang@intel.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tony.lindgren@linux.intel.com>, <xiaoyao.li@intel.com>,
	<reinette.chatre@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Sean
 Christopherson" <sean.j.christopherson@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Message-ID: <ZyMAD0tSZiadZ/Yx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241030190039.77971-9-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:194::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8600:EE_
X-MS-Office365-Filtering-Correlation-Id: d2833328-4521-4cbe-f9db-08dcf9606c23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?H5+Er/atk5EwJiKr6eCzBY18aQH0MS3BwbJfi6rkbJA3vO3MRVffsusUtR9z?=
 =?us-ascii?Q?VQRf3acszLmWmTN8rUEBGQswuPrc8meyComBK/ZAvQEk8fDu+kF0mMf15ybK?=
 =?us-ascii?Q?939RsH1aYVrqdSV6mLLIePVBV1wbZaq5443zESNyRFIlsqitVKyuAkHktMEj?=
 =?us-ascii?Q?6s3LNxA8LiNd5VS7sAWKTr0Phq0Bd9saQ/qoir4XBRB0xVyaYoaqxq1SiFqA?=
 =?us-ascii?Q?gMzKVabH0dBYPVdUrctjxv64lT0Jsj2UltRkAlmvwBsvPlLNhGG5s3VbtZ9P?=
 =?us-ascii?Q?QHG1etYi9cnvXIVrSUPnT3rjA+TMEdPzbJ6k5mV7tiiKBgLBrYfpeZBTR9Bo?=
 =?us-ascii?Q?h+bWH2f1ef1NOmLiO26ZbAkbPf3dBLWM6EYkiKRUcy3O5pLbXbdSOnB4765M?=
 =?us-ascii?Q?riNDfdeMDYR5I+lSEz6mrO4oTtEDv1SwORpCcFEHMnT/n9lXMTygeYSugL29?=
 =?us-ascii?Q?pXc46zULALVD9BLmILOtE2GGwT0vkKnDdnnOu5ui4IhqUsj5QjWLrO271zwC?=
 =?us-ascii?Q?trCCeCKGfQqtbBix+NDKppv7esxexiPJJuvabhE+3wGqYqszMao72kggsA0D?=
 =?us-ascii?Q?YAM/l1qIwi4mf0by7GPrGARpZ4s8m4z3SIkYCG3LU+oBHGPrA4SDkMDYr4JP?=
 =?us-ascii?Q?Y9lqisLr0eSVRcWRCYLTYsyElLkRYLS0GyrvPv84rqnuvv06s5BJkoa3A13C?=
 =?us-ascii?Q?qV96W2gk+vWjTXqzx8xuXV8bGNk4Muqzndytj2jLjvBfcF3L4G7c28EdVmOR?=
 =?us-ascii?Q?sfPiWRPs3qxRlDkLQcjoFMBprcXEhuot3h15S4LXMnNq6LtDx3SMvkir7aD1?=
 =?us-ascii?Q?C/qW2EwMUJZF2h8sQLeljUWBGY0CkpqJZ3mBOXi7JKPf3jxj78TT5S/ctct/?=
 =?us-ascii?Q?0lPXrlOK5AceOYbjufJ7Oi/HWLV+8HuiWvRJgM4tikd5OF0fsyD9fr5l/jdh?=
 =?us-ascii?Q?a4vL7nyuX5PLk4KQ8Ma/A48jFZkso1xhO95Y+4ICt9SdKSRqMXEY5+Z2zbTz?=
 =?us-ascii?Q?xPnG0pMeJ3Aj7RDG4q7WR1OhN9fZq5fecXRD2CdqmBBnlO0gTptRFTMwStJt?=
 =?us-ascii?Q?NygGOgNFglQM/RzUlnujgIECcsg1fBzmsabmaysmoBXm6ShMm74AW4tLatVS?=
 =?us-ascii?Q?MbsGnBQ1Hxutt/ZgyCIImPk+dJjv/PfC7weO6CevqV8X34LP+VFZNWxvVwtD?=
 =?us-ascii?Q?lHLelSSKn/6QMZdleDq3j1B8wVZnRFWlgMpIxm9dwaLGW5Zx+97O1lSB1KEm?=
 =?us-ascii?Q?1tSzir+a4rfvmYqRPd4VZNmHKA02l+WYyu0njLJOFWpGhsbtniouE0SuK6q6?=
 =?us-ascii?Q?qt/H94pwmn9bYCDFBPt1u4PJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+p7qyKVG8YaO3jzUS0qgEA93W5QTQ3/RPsPAXHP68RLQica499aNvUlrOBhF?=
 =?us-ascii?Q?Dtlc61HG++M48FlktzfgLeN8PcXv5PlqXq7EJM2vT88Db5mSDFIXfKUEs/TF?=
 =?us-ascii?Q?rqhiOWT7S8ArIMraps4CILOS6hImkwLAypDlests0OrlPjrf1GE7sgYxM3pK?=
 =?us-ascii?Q?edOQDiUo8Iej0ea2ZA29b0ct8pg6QzuaZrdwP9Otn1mF1Qewj5vupJ5eFa4c?=
 =?us-ascii?Q?p9bcQFQDUAAYtUgv86qcBRlIYj3DWHgBuCL30kT8bJ24HqV0gV9QDc2tH6El?=
 =?us-ascii?Q?82vaprWuBIDeIifjpzBgnxHqwoSOyvNTt1Jwr5ChwNHtZJB+mcpEU43YNYSr?=
 =?us-ascii?Q?1+GLbfNH8QtsrtFtj61ypW7ZQyNbVhYvSyRweC7li1au3Yc5qOOnuYhspi+t?=
 =?us-ascii?Q?fvnSDZWjj8kXJQagu48uX8bvf3aQgVYk0EPQZifDor6L1XIDvkP9vY2WTwz+?=
 =?us-ascii?Q?v6ienzJM+nWxumHF5sld10dkTfQoBCHIv7jfv0Ra2GIlkM0/HxrqNwHDfufc?=
 =?us-ascii?Q?eh14o5sWehXM5XIv3nnz6HY7Q2Sy2Ws3McZjt6iOEt7jUBOPhP63S1QjDFSM?=
 =?us-ascii?Q?JaTeAE488ET6TsFA9QqCAHbOxnYDXEMIzxCcFqErar+NDzXS/VxM9pT+bHV/?=
 =?us-ascii?Q?dMg8f1L5K22bRb67KEfgxQOMOj/r3ZGhkfjrHA/2FDpoShaN5pCqw2nzx9Zz?=
 =?us-ascii?Q?USB6y8lzwM1nUikuvxLkPGECrdpHtlrXIhT+47Q/6nVOQr5K1yC4mhclN5AA?=
 =?us-ascii?Q?qJkhi3yr19LVHYt5aI0XhhGLOXj1is5midGbojLxOA4sE+5/+NOkmnX/uJVe?=
 =?us-ascii?Q?kodzPHp2M9g4Mtn2XzNx5wmYLUcrMR1AwNz73qOa1zJyVaaIUKn82TyXjQun?=
 =?us-ascii?Q?7nyrTV/8Ly8Zt+P1n+jcToIpul4wB0wt0PiQcwR+zoNZbBgW7nHVhiCRwQgt?=
 =?us-ascii?Q?lJjds1obfyi+Mlyq1KFbNC9paUNv4tpO8HvSRLU93BBlNlafnPfy5QfbHna2?=
 =?us-ascii?Q?BH/CBolSjR9EwT5Vp8Wi/blXjSLSZTme161wSTgpPmJdDP9eP4xKhpcmA86b?=
 =?us-ascii?Q?w+Eqx5Tly0gFEfr3atsLfBdzSRI/IXRfABWwPayW/4uKUQqN0rOzj5DJRlYu?=
 =?us-ascii?Q?ivPC6wqiCpQnFBrQ34Q/Xw2UEU6eo6hQCnZuZ2r6JQYIpeh39cF9t/H7P1ix?=
 =?us-ascii?Q?eYdT6XoUxd7FOCN6BV1uI0xVxKmFsIt/cW666ucAsyKISpgimdVLT+MG07Yc?=
 =?us-ascii?Q?OzDk/C/uxWDTDfvuOUGrRNAz/BZA1KTmGaJcW0hyVk6+eanMEx9i0pdAZ+4i?=
 =?us-ascii?Q?6sSbSxXOnjbz9ahWDlVZNIW/qUn31jqxj+fSH0OkhjvcMVyPC4IHeDqc/yDm?=
 =?us-ascii?Q?/zoXRcsfTFCcd/VbKwLrfrTcYPNnjZBWnScV8jZkJy0SvNQDQqoP5IYdhFml?=
 =?us-ascii?Q?eiuQxt/lMotVSkvGqGD6vgyFkvDGXzl2ShW3ySij21ySQEH9u1vTpEwiydID?=
 =?us-ascii?Q?VlRi7bfK6ry4hti8FwlCRWKqrCEPpNV+9QR6rOydhZbKiXUWvMfJjTuNsOWr?=
 =?us-ascii?Q?0mGpbzSF2WmsDmPsqVYdLfpQcKz0JeMFYJZ50ZSH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2833328-4521-4cbe-f9db-08dcf9606c23
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 03:59:30.7591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DO6s5yWM2+BrAoLKWu9+ujNji17ELkPoARASl9MdIKT6wv+Lu/p+YBdzPc/B019556rMAdz26/py/md7LMBNLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8600
X-OriginatorOrg: intel.com

On Wed, Oct 30, 2024 at 12:00:21PM -0700, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>

> Add tdh_phymem_page_reclaim() to enable KVM to call
> TDH.PHYMEM.PAGE.RECLAIM to reclaim the page for use by the host kernel.
> This effectively resets its state in the TDX module's page tracking
> (PAMT), if the page is available to be reclaimed. This will be used by KVM
> to reclaim the various types of pages owned by the TDX module. It will
> have a small wrapper in KVM that retries in the case of a relevant error
> code. Don't implement this wrapper in arch/x86 because KVM's solution
> around retrying SEAMCALLs will be better located in a single place.
With the current KVM code, it looks that KVM may not need the wrapper to retry
tdh_phymem_page_reclaim().

The logic of SEAMCALL TDH_PHYMEM_PAGE_RECLAIM is like this:                               
                                                                                 
SEAMCALL TDH_PHYMEM_PAGE_RECLAIM:
1.pamt_walk                                                                   
  case (a):if to reclaim TDR:                                           
           get shared lock of 1gb and 2mb pamt entries of TDR page,
           get exclusive lock of 4k pamt entry of TDR page.
  case (b):if to reclaim non-TDR & non-TD pages,
           get shared lock of 1gb and 2mb pamt entries of the page to reclaim,
           get exclusive lock of 4k pamt entry of the page to reclaim.
  case (c):if to reclaim TD pages,
           get exclusive lock of 1gb or 2mb or 4k pamt entry of the page to
           reclaim, depending on the page size of page to reclaim,
           get shared lock of pamt entries above the page size.
2.check the exclusively locked pamt entry of page to reclaim (e.g. page type,
  alignment)
3:case (a):if to reclaim TDR, map and check TDR page
  case (b)(c):if to reclaim non-TDR pages or TD pages,
              get shared lock of 4k pamt entry of TDR page,
              map, check of TDR page, atomically update TDR child cnt.
4.set page type to NDA to the exclusively locked pamt entry of the page to
  reclaim.

In summary,

------------------------------------------------------------------------------
page to reclaim     |        locks
--------------------|---------------------------------------------------------
     TDR            | exclusive lock of 4k pamt entry of TDR page
--------------------|---------------------------------------------------------
non-TDR and non-TD  | shared lock of 4k pamt entry of TDR page
                    | exclusive lock of 4k pamt entry of page to reclaim
--------------------|---------------------------------------------------------
   TD page          | shared lock of 4k pamt entry of TDR page
                    | exclusive lock of pamt entry of size of page to reclaim
------------------------------------------------------------------------------

When TD is tearing down,
- TD pages are removed and freed when hkid is assigned, so
  tdh_phymem_page_reclaim() will not be called for them.
- after vt_vm_destroy() releasing the hkid, kvm_arch_destroy_vm() calls
  kvm_destroy_vcpus(), kvm_mmu_uninit_tdp_mmu() and tdx_vm_free() to reclaim
  TDCX/TDVPR/EPT/TDR pages sequentially in a single thread.

So, there should be no contentions expected for current KVM to call
tdh_phymem_page_reclaim().

> +u64 tdh_phymem_page_reclaim(u64 page, u64 *rcx, u64 *rdx, u64 *r8)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = page,
> +	};
> +	u64 ret;
> +
> +	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
> +
> +	/*
> +	 * Additional error information:
> +	 *
> +	 *  - RCX: page type
> +	 *  - RDX: owner
> +	 *  - R8:  page size (4K, 2M or 1G)
> +	 */
> +	*rcx = args.rcx;
> +	*rdx = args.rdx;
> +	*r8 = args.r8;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
 

