Return-Path: <kvm+bounces-12992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD28D88FC2E
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:53:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11F14B25CE7
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFEE5FB90;
	Thu, 28 Mar 2024 09:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WpLOPPCL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77B71DDFF;
	Thu, 28 Mar 2024 09:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711619600; cv=fail; b=WI/BvBSkwdn/nb70HQYfh5YKNNiOcLbDQiyCaM01tPLBPpohJv4mjF7rgfLyoLTstZA+v/0/aeG3ZUR6xS/RS3rc8JZWofTfYMu8lWoCg0/63VvgvS9UE5n8sqVgC+GwyRuA5FzC7Q4Kq5EMTRLvDGiZpJPPia/NKC55Ddgdle0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711619600; c=relaxed/simple;
	bh=tnGiCiyxNe2aFPWQfDUS/7qsZGOsFOuZZALsVoJefCo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oU1rDm5la73Yp6IDzXLZ0gruAdsnjvVgaJPtS1nQyeGwBwnFiwyvkrIfjEVmDPTk0i/yWxnR8hR3/OIbfyALLS6WaTyPXFTfdy30VO2AFq8lRno/+eEPbf5rS5uUl0x6p01CuaQZRvu8/tpcsCF+7SfW3ilFhCyt6nsutJY91VE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WpLOPPCL; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711619598; x=1743155598;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=tnGiCiyxNe2aFPWQfDUS/7qsZGOsFOuZZALsVoJefCo=;
  b=WpLOPPCLJiM33zwaA0vNf7zUY/ddnoDutdwBDVIDh+iZxp9KsHBRSnBw
   o263A0/dzNkQRpYZ5jt0LMJNy9VjmsHH7PRd2/0g8havBUf587V76loFD
   ZKp35MtewVw02iPOCb/JoN/k1l9GYIkFTJfZG2rhsLowmaqUMgXbs0EUe
   o0fU/Aa1fqsOlkIzyVhwax2NX3NEdhXbE2hiW7p7C+83Igkf0GIr7IfkI
   2495v3O/gQV+uIOWD+tLAngG4l7D7Qmh9haLuw1Li0iaefkDowUQjtNFm
   2izDnobc3doIjB4+q25JWVmVp7LDW+5ore+EPJ0LuMrPKRGLPX3udvebh
   Q==;
X-CSE-ConnectionGUID: rwEoqtIpR1+WB1zDExoAXQ==
X-CSE-MsgGUID: qlNoMXd9SMWCsmk2Wwfbmw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="29243903"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="29243903"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 02:53:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="21068677"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 02:53:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 02:53:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 02:53:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 02:53:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 02:53:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJcatQJ0Wajn0raFi6y6bPgQ5nIF92i5IYFj5zn5pCD96XNxwjPVO7vII+aN6pYAfAtJ3eCOAEzeMrjhlvbVLT0YzzVpZ6dZ7JUOK3eGCZE9z/I8EiGE3ghYHLKa8eWW/IscE7cNpjCRClRJ7iyVfZf1zbDz1jPgeTi8tnei0jv4TJmNiRTfUSj6QpEKWalvKDqWkPvkiE0lmMeBFcMQg+V+mrNDsDkDWlpsmE+aS8vNWaVDPPn+YTlRqIhjcgL1ZItQJLybE1bRxHwVQQvlez/wFSoMcfqBDvCMrmYwzaRwEQlJKgNOeu4x6kmLKsz/SFEqJs94kAwjcIHVO03x8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eel9r2OPUllpH6NvQ+I5KFgEwvwbaVkHVDGA2LUwfyU=;
 b=FB08ysLzHxBITcy9n5O6QTOxUoX/3JupKSXW9VDD1RvNZDFLGsfzDUZuubKVw395zD853MNRsaa0zDB8acm/0sxgUVpPxOmL1OwAo6HLv3ZD2ZN62AHn1sD9XcnUNIKNikdupdNDpMhUCzj3fR7lsPPBVwhRUnWsUG7dXg12E+O2tp2GLxvEP1g/T+CxDJAPDaDrbMDM1VoGwAvyXgvnTh+JB6a3H25GN5Jme7PrPNsABr4rADH+FBCuGvGhAjnZGrr1cWauwBGNwzpjTD87La9k+fmmcj0QAiOZ+Oarc697R/gWSf/OCnLOdt+i4MfGZmxT5eT2pgYcmjA/vFEH7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB8336.namprd11.prod.outlook.com (2603:10b6:208:490::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 09:53:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 09:53:14 +0000
Date: Thu, 28 Mar 2024 17:53:03 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <ZgU9/61//F17r1nw@chao-email>
References: <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
 <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB8336:EE_
X-MS-Office365-Filtering-Correlation-Id: aace672d-bcc8-4d53-f3f5-08dc4f0ce286
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Bm0DXYPARjEIEypJCgqLPBmBiE9plnNxRqa/pUHETplAXeN4HJJs3uQlrSno6ivC1m013DYwYlFw4yrm5FF6oVte8hS6uvGeI6s/LHfd8Et4QPOUixG0eYKlYHgVR1d8aUAFCMQMcDpW0Cv1EPFN7vi3abx4Hej7eHYiksIUr57lZVzt/L9TUhQNslS6Mar1xWkvt37RiollQJl4RzdpCToAa+VZzFEeWEPPzohDfvxEnQHonswV68TOxrxA/mk4LTiM00jSH7hBh/Qg8A3fkr+m3tWfDOvevKfwZt0rTCljHiurypGTw6lpQUwtEawdzrx9/ENT/rD8XpQ4krKsptzjC9qUz7paS+M6zsfvyDdQhmv+jYNIofBjt+5HE2/i1a5PZIQvlstGjRW2ZL3xzODHWsYE9waQ6Lc8qFDwoGANFLCyQPus55ViG3fyZexfCI98Q93J8xTU7eo035/7/hHIzRZ75FsCXcf0Oa9X5yEEbupfZ1yTpBl27h2IOJDOrsmOVTrJ/HQv4GbLPEp3LA501wS2QEj45mxPxEWJIFJ9Urz8wdiA6I2U52AQNLXbT5efNDk8A45bc6JvT77ODeHnn1LESIPdLOgMBad2Kn+6sIVGpXuGz4QKKT6BxA6GwIzUCHhEo/XBeMx/l4MOg/CYGoom25rFQyaDNPFAJg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmpIUTNTT1BCL091QSsxcFRJWndlSWVVVzVHNmIySk9OT1JhdFhTNVExdVFy?=
 =?utf-8?B?NmxOSVd2TFlTbFM4RDQ3UGFZTW5TdWhYYmFMbHZ5MFFzZFl0YzZYbDRlM3ds?=
 =?utf-8?B?Z3RweXVVR2VXclBDcmExRXJraVJ0bmhPZ21iWFRzcE1DU3AvUHZYRVFtRjlM?=
 =?utf-8?B?T3hHOVJlYUpNdjRudjFHN3YrNi81UE5DM1ZVZkczQjZ3VHcxeFJncXo2Q2g3?=
 =?utf-8?B?N1E0VFVlemltSlpHSkl0MTlienBZQnFyME0vT1MxNXpsQ2k3QTRINnphNXhR?=
 =?utf-8?B?SHJDRUhyQ29PRUQrRnN4Slk1bUdINVlHa3YzQ3duOW43YStCQlRzamk4bVZ5?=
 =?utf-8?B?NVVQYU1Hb1FhdkpOZXU3SGRnZzVHeU80YWhlbHJhK3BpUkgzUWpWTi9QbEdG?=
 =?utf-8?B?NVFzTG9COGhpdGhJTitLUVBXazZtdWJlb3hjR1RQRHBUdEFRUDZDU0dZNnNm?=
 =?utf-8?B?VE5UWkM5N00rYzFudWkxVVdOUmgyVUtnQ1drcytReVFwVjhxSEtUREF0NzQ1?=
 =?utf-8?B?YTRlT3VUZXBzOXJ5OTVwU0gvNndiRG5FcWxSMHNXalF2WllrQmJmT0J5bWFy?=
 =?utf-8?B?YkpwK05ldm9YUUIyUXZJbHBpeEs2czNYTTNxYjhrZm92WmF4dGVFWmxpOHo4?=
 =?utf-8?B?UEEwN2h6NHI2bld6TXhtWmdXNlhaUHVsczZGMVdsL1gxL1pSWlR4WlBKaVJM?=
 =?utf-8?B?RHNCNUQrR0QwTStldVRHVk8rY2I1SUxJU2V5Y1plL2VIandWVHlwaUt6Vk54?=
 =?utf-8?B?d1gyUmFRV2R5WmlTalNjNXJMZEEwNXNjOVZySUVUZG5uMStxMk5iUkZGZXJW?=
 =?utf-8?B?RDF0NE5EVlYrQVhXV0dlSlN0c3Ixcm1yVXBtNm9ZWVlPaTZaWXRHSUloY3M1?=
 =?utf-8?B?VGo2TXo5MzBVZ1J5Sk5PeStORkJ6L2VzKzNmUDU0NVU1WjJIQVZVeGIyL1JE?=
 =?utf-8?B?bkdHZzNwTnJVM0VuNERjang3bXN2L1NyVVF4Q1ZSQk4wcVJZckxsMDdvcWR2?=
 =?utf-8?B?d2JoakRYaTlyRExKa2UvVVBsQlNKcE90TldHZkdkR2U2M1hIcWgwUEwyS2hk?=
 =?utf-8?B?Y1FTbGJUcVZCT1ArZVI5OHdDejBmL2ZCL1BpQTAzR0dxUjNGcG44ZlNIdU5k?=
 =?utf-8?B?bUVQdTBsOGM1ZHFpZ0cvMTczc3NLdE9haWJPbGROM1hCTmRrNjl6MVhwTWF0?=
 =?utf-8?B?M0wwR1NQM0RBOEZSak1zdjg1eUxFNVdpRnRveGo4aFpsZHFGc2NMbW9aRkxo?=
 =?utf-8?B?cE1GcnpmVlRvYml5aUp5NVZiN2JyRi9xOFN2NWVjNjBpOVdQREZqbnRDNkpp?=
 =?utf-8?B?K0JYcUpVc0tXd1kzM0lLQ2lHenMyWG5NN2ZhdkdtTFhHQjZKQ0F6Nm0ycUc3?=
 =?utf-8?B?dHBsOVh2czhLck1yY1JZN0lLSWlPaGo0U2ZWQm55b1hjeW9OaGdTS0lnTEQ1?=
 =?utf-8?B?QVBjVkxFV1g1UzFKcTFGV095MlVITWJFRm5YS3BLTmJad3l0ekVFcitONFhs?=
 =?utf-8?B?Q0lHMkJ2NVQzZUNwNnY2NTF3eUZLTkhUVGRXbEx4NVhuQzJScTlVRklxT1FN?=
 =?utf-8?B?ejVNYnROOCtOQXNZWHZTeHFOb243cFhWb2FOZUNLTUR0UnhCYlVTSVEySElr?=
 =?utf-8?B?eFE3YWhkSXhJaUYzaGZwZHB3N0hTSFN0US9Jd1Vscm50eStab0UrOExzam80?=
 =?utf-8?B?VFhHV3lmMkw1Q3A2bUl3RUJuS01wYS8rVnEyZU9KV2tXaHJNU0JqSEw1c2Er?=
 =?utf-8?B?cVBqMWFrZTVYTTV6TVdPMDQyQXIvUWdxU2krbjdxMGpkUk9xUkdBdm1GdHl3?=
 =?utf-8?B?MDRGaW5IRUltazBxWHFxUE10WC9pZ1pzYjBDVklzaUpZd0tWeVBPeHRqMFJN?=
 =?utf-8?B?R3FzcXdBMGxJbjNVeS9ZSzh6bkN1R1ZKaDRiakhTTE9NOTZaUWlGY3JFYnVM?=
 =?utf-8?B?dHNmS2IwNDZRaG53VGhBZUsxMXh3eDZGbUthcmI5NlZrKzNHNzJaQjBKR2xT?=
 =?utf-8?B?SFF2OXNIVy8vMFlYM09YRHdSNHA3aHc2UWZkRnU1N2M0cldhZGN6VEJKK3BI?=
 =?utf-8?B?dkRLZVErWEwyN3hRZnN3d2FsQmtMRVRmL2ZGcFNFNDNWRTVZRkpzT0UzWDVh?=
 =?utf-8?Q?fkKSJvUjNAQVqSgnM6l0+aum1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aace672d-bcc8-4d53-f3f5-08dc4f0ce286
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 09:53:14.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOJ4Qr52aXTktmEoUDWpf69x6dKk16W6Z7S/HjGLEzKbfoVxX7UVPQQ+dpziEZl1XhcI73/BA4KWGsA8rZ9pFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8336
X-OriginatorOrg: intel.com

On Thu, Mar 28, 2024 at 08:06:53AM +0800, Xiaoyao Li wrote:
>On 3/28/2024 1:36 AM, Edgecombe, Rick P wrote:
>> On Wed, 2024-03-27 at 10:54 +0800, Xiaoyao Li wrote:
>> > > > If QEMU doesn't configure the msr filter list correctly, KVM has to handle
>> > > > guest's MTRR MSR accesses. In my understanding, the
>> > > > suggestion is KVM zap private memory mappings.
>
>TDX spec states that
>
>  18.2.1.4.1 Memory Type for Private and Opaque Access
>
>  The memory type for private and opaque access semantics, which use a
>  private HKID, is WB.
>
>  18.2.1.4.2 Memory Type for Shared Accesses
>
>  Intel SDM, Vol. 3, 28.2.7.2 Memory Type Used for Translated Guest-
>  Physical Addresses
>
>  The memory type for shared access semantics, which use a shared HKID,
>  is determined as described below. Note that this is different from the
>  way memory type is determined by the hardware during non-root mode
>  operation. Rather, it is a best-effort approximation that is designed
>  to still allow the host VMM some control over memory type.
>    • For shared access during host-side (SEAMCALL) flows, the memory
>      type is determined by MTRRs.
>    • For shared access during guest-side flows (VM exit from the guest
>      TD), the memory type is determined by a combination of the Shared
>      EPT and MTRRs.
>      o If the memory type determined during Shared EPT walk is WB, then
>        the effective memory type for the access is determined by MTRRs.
>      o Else, the effective memory type for the access is UC.
>
>My understanding is that guest MTRR doesn't affect the memory type for
>private memory. So we don't need to zap private memory mappings.

This isn't related to the discussion. IIUC, this is the memory type used
by TDX module code to access shared/private memory.

I didn't suggest zapping private memory. It is my understanding about what
we will end up with, if KVM relies on QEMU to filter MTRR MSRs but somehow
QEMU fails to do that.

