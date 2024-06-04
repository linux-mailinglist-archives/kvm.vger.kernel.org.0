Return-Path: <kvm+bounces-18709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EADB68FA931
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 06:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EEF8B220D9
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 04:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C36B13D602;
	Tue,  4 Jun 2024 04:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AIDE97aU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA576FC3
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 04:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717475251; cv=fail; b=hWx8YCrqcTFmWe/jKpy7Ob1sT+51liykoIiDJZAJ7O8Hl+AbPt24OVc9t7o9/ugCtrwK1JoH05FXZDfJTBzw+vSvumCNb7XhgLSZA7yGCpDX6CuhbudN2pl44/rpujnUkCNtYZoShDBhHM987AkuRoxwVL09yTgUCKUwdDUUSVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717475251; c=relaxed/simple;
	bh=qa2KsP392AxZpAieWR74Ef34sWAPCrMaD/2Q8EASQxI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UnqyOKBwQiynIF1OHGob6+JFHOfCgEH8x6sNi2akAq0Jqohm+8sMjHloxHSATPb7Ilfsh4LBijs2+fSNvV/kAVcVYXUvgpmYSt6O1DIHPsVu4IDPQTzuYoGM8wICWjnkRiVRC3c+s3CdSlnwvFgTnWWFV/raH41EjJ80V4182Ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AIDE97aU; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717475249; x=1749011249;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=qa2KsP392AxZpAieWR74Ef34sWAPCrMaD/2Q8EASQxI=;
  b=AIDE97aUOp/fIHRHW4Ep8g0LOcrrtGS0pI7U/9f+3PK6HFLkAUsw9ptn
   u5hW+JhNYkocNhzUKPoWL6ikia4gs0PbBVO3FdEWfK9LF5/wEa9ltfQzF
   3o5RPAuP7bxPr7JPdZ7dbtzVvsytv2JjxNdbfpX8etGXTxyvGEnveBIil
   XXSy5KAagKfogSohkULA168MvdOiMHu6Hv2xoEdYOx2Snl1pQCmZWG56R
   kNamtjWcZ7kYDxPSXjtQPX2VpYEEMXpxCyvqJkx9saXevUN/7S1iBmSPw
   8HES6osMdj904+T0APAD1Fyiy0DfhXoCaxtJIkFGxH2EqfRVgk1zrT7HA
   g==;
X-CSE-ConnectionGUID: 4mis/3M5Q92w/5lXlw4FZw==
X-CSE-MsgGUID: Mo/kkjQORT+ZsLDmPS2FqQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="13834052"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="13834052"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 21:27:29 -0700
X-CSE-ConnectionGUID: OkC3Gy5tQ1iCRZWmcc/1IA==
X-CSE-MsgGUID: WPPmlizlQ3KsaR26xKys4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="37689600"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jun 2024 21:27:29 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 21:27:28 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 21:27:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 21:27:28 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 21:27:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqiykY9Dyh+IeFkYOYKZpAGLlpaGedyFwB3cfSucvd9+plMIgCSoJywBQI9hh+bmvqx6hf7dyrlZEqci3z56vlZnKD5wwZHFVEoueTk6P328Dzs9kUOsFih0DwDSitLB4LRX33P4EiSJyBIaS3w/9+Mz/fWRtDsEP1JnKimvbM1x9zqp1nh5E8z/wqhDUZj5YLg3+Uhtp4XjZQ08jUjlG7QrBrawxRNJ/76sUd4IEALa6QzwZ0DHraQnsnHTW0x7pAtOF2gXNCNRCNT5Kpg4gGqsbvDJwXcGTC34RuOGqUqGsQTn+ris3wFA96PXRvHX4gdAZZUty6Tjesj4jfBNiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5CPv6XTs1FkdRv45WhS/y9QpJ044zm5wSj4GII8oOc=;
 b=UlGVf85KuXSS5CGKtJUYVGiZQEbVF6e8QyheqkH3aBvXHG7kKD9XWsJU/0PArOp7lCx4O4d2Y1upgi1LSbWQN0udTpX8tJM1F9NNfTZIruExPabcR9kafiRj8hIbfE6Rm4WJ6A/itHFBmCOTQrPw3L53NDD6Wr22H+JlOG/0O/mXHR0oQUXYV9wheunDPk1SkZYteABVLjWpVmvPtqb+Lmv5jnUqW9fo29Yx5Gc1YZAf0XWRDLqr1gMNDKgV80kz6VR5sNRZkm0uWIEFRDX8QF+gfcnCazbyOSCGEQx9/7yzM13XxlajRkJ+QgYAPtDryj04s8DC0TuwA526QGqyZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB6987.namprd11.prod.outlook.com (2603:10b6:930:55::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.22; Tue, 4 Jun 2024 04:27:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 04:27:26 +0000
Date: Tue, 4 Jun 2024 12:26:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>, <kevin.tian@intel.com>,
	<jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH v2 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <Zl6XdUkt/zMMGOLF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240530045236.1005864-1-alex.williamson@redhat.com>
 <20240530045236.1005864-3-alex.williamson@redhat.com>
 <ZlpgJ6aO+4xCF1+b@yzhao56-desk.sh.intel.com>
 <20240531231815.60f243fd.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240531231815.60f243fd.alex.williamson@redhat.com>
X-ClientProxiedBy: SG2PR01CA0140.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 61761670-6065-42f9-05f0-08dc844ea325
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HVaZPlEVkm7nxlt1O8UwrajyujSsGstyMIWQzzYLINhNf6MI1MHwvkCfROFF?=
 =?us-ascii?Q?oJCeS6aqSAuX3ES/cZk+eWFt94XxXxcLJlm3JRHhYDbXJ+usPc21m9tg14v0?=
 =?us-ascii?Q?K8tF3BrwepwnHgXUHn2Sna8zQCZFTqYU6qIv5u57it/0KpnbyPwxn7GgzdqQ?=
 =?us-ascii?Q?is2UBnb4nymURquKmfi3yWv+ewzRC27KA2tueLawwRTTXRudB5SxVbj6lOlH?=
 =?us-ascii?Q?A7T4+JV4tWX14jUXFoRebI7DL1u5bRX8BfACYD1vQ00ZMXd0XR3TGuxQ25ry?=
 =?us-ascii?Q?uETbZ6aXPmqRG00o5BBRWb1BZ4izu1zORVoY3Nc+Wv2usiCotL7YuTs9Qz8l?=
 =?us-ascii?Q?5lf93mzRqK95ff9tyQBgX99oTzVFMRou+fzeo2q0CcIJs3eTUeLq+Dn4ISre?=
 =?us-ascii?Q?usk5dnynNWKc0nSEs61dzbRsTJhvriBIXKmyFVD0R9e7TC43J920mjbdOQGw?=
 =?us-ascii?Q?SGpr1HjeaZUi8XGR5XNXn36ira+Ye0OcpH63VFrQ+TfZkEVLuq9+hDkNJ0EU?=
 =?us-ascii?Q?hiYUecEdFCSuxl8t7tN1IQf6sZxSkuClqKklM8Bn3sR+pgJ+v+NG0fpirgT5?=
 =?us-ascii?Q?nhS7wp3YF5bfBoT64IqylDnjWiVSvyBcc7YnCLRH+VivWm8PO09Ona4tQ4rf?=
 =?us-ascii?Q?kisWJtdlVMixs3dD/pkfqq25k2DeI8drY886rpjCVgYA+/tLEPh/jH57Ie58?=
 =?us-ascii?Q?vwhE8MWuWfxOsjfVJCIu+1HaFs2eMP/BpvPfnkM7YdlHxOAUj/9WPuIEqWhU?=
 =?us-ascii?Q?1omrNznxyPAhusRPIGY7NBjzEvwKLE0PjfZX8QX0wsOPdXadbQ841Otj1rM5?=
 =?us-ascii?Q?AwIhy4jUYMN+S850D6wmI0V3bRQUUN135JACQ0Ui2zWsCTEysfRaAVZ4xECC?=
 =?us-ascii?Q?pggtpD6oQNtxUKvI/aqoqjxJ/EZ9Gdusx8MPfGrLftXxgAlC0qPaSxSHg8gk?=
 =?us-ascii?Q?owHIGh5iCo41wb0FTkkcGClQnHJszz3jzeZsriwiAI7/8eMuGyYGERnoN1Rg?=
 =?us-ascii?Q?eIgYzQexw1sBlgkfsjuIfVsDrSonQIxlO5h239dQ46Yo1N3WcpFdPinrRQhN?=
 =?us-ascii?Q?Go3Jf+Kvx/8I6b99Orxfm1Bqf4iDzOGo0Irk4INfRdvJFYRxBmDqbXoVm5LD?=
 =?us-ascii?Q?WCNObkMxDSlWUVzT2RuxLqavGqmJqyiaxUd3ZeeI3mLeVdFke+qbO3juMSX2?=
 =?us-ascii?Q?h+6az762Hd89v1+ATAUJRyMp7PXMoq2atdVE8mpPaUOhmuSQykzDcG1+CZba?=
 =?us-ascii?Q?Km3w+lqohToYq1oweOm2AdyT1EAxUa5mOqrUtklCIQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mjvZCEDBwUWJ/oG0DpBxFxMwsHFPRjgrtIQbg+CJRwM4szxLjLYTst7qV/DT?=
 =?us-ascii?Q?AFuM5old594Q1FyZDRCU+sCUBsS4Y+nKW2smuwio21QtgIPetwWcDGkMYPaj?=
 =?us-ascii?Q?gGope/4RviTJaPsL0cJm4CfE0uAB1XOMnOig3XZc1obOvo0g4x+tBkUQuibI?=
 =?us-ascii?Q?iaUqaBOO+ilbctLtkpcGgimje4ZDnqlWYJdnU6Kf6CmwpvDflLj6E90magxE?=
 =?us-ascii?Q?9X0JYC3x7plidYl+g2z+V/q5ZITaj93mprildej9lMPWfaYEh51zGJ+OS8zz?=
 =?us-ascii?Q?elldSWHLyt51Yoj2tEr7HZcL4RLAoVuyG3IIvGvBlWBXt/uv8fF+rQonGFof?=
 =?us-ascii?Q?PXFtWMa2mRZqwJFRZFaO4iH049TTAo9uREmknf4x+oghWKNwpUQAgrSL+Cty?=
 =?us-ascii?Q?8c95CvjW1WL4AsUFKn/RNHq0CXwnfabhFWuvSnWcScymLtRW1LgLHSMuBeeI?=
 =?us-ascii?Q?OQ5VcaRYsBceM0iRuxagtmADZCeAqoAv8w3SwD3rk9pRH7NbwmlWvme3/2NK?=
 =?us-ascii?Q?noHYAS3KYDrT+3kUjsafkZkjK3OPYI4mtr3W+6kPXP5K4N078KbkDnZWiBBi?=
 =?us-ascii?Q?ZJ/vP1hSSG/quL/cdA2/emNN+g+tHXDh5zvp1iKe6j1Y1i+LrGsFFMaiKcn/?=
 =?us-ascii?Q?85ky5dZSHxJNLX9ueGLEPxI1JmNWTua7cjpWq9LHmbNtaTygSC6JnL6mMbAy?=
 =?us-ascii?Q?Ze1zgEvhFcW6DUUC+Ne9XK98zhuKAxtq4AGtQAsqmwx5Vr5qyjIW69/4SvrQ?=
 =?us-ascii?Q?7w+2Sw2m2PGWdrQuTDCmvTUeEcP/hRuKD93WFdu++bzLPcBgxwINEJtgsUcl?=
 =?us-ascii?Q?Fobmzht1Y4Rso2iGejSY5YDduMhTKLFAoBpht+ku35JWf5wPbJ+5wA/K1Ecw?=
 =?us-ascii?Q?YFkg79Im4S9J+6FwCWp8GB2Kk++r8NxIj1mdMMd8vqyhSY8HqYuHGAOHiV5Y?=
 =?us-ascii?Q?D0lIN5/lXkb18AfItM22PHvy+o8uUscgwGeNH49jZNYdva5k7livHBvQgdxn?=
 =?us-ascii?Q?yQSm7u3C2nIPQSkrYK1DIFl6T1I//bvFgyIrtJpPf5V8+TlBrxMfVOchDAnV?=
 =?us-ascii?Q?2b3oNfFtruJRueNbaENs4li5l2Dk52WKgQmh0xfrVAfdCXgNfNocmh3zfISm?=
 =?us-ascii?Q?YUlRn2WrhG0FNlJcBuBKzyvMuBOQ5OlSiUVnj00aCtSlec9V0/OuaDansKj+?=
 =?us-ascii?Q?CMXGybyASXoPC5a/90+eb1g30m0NTwCStn023nFuYcmrykCFCCOjurBx7iFr?=
 =?us-ascii?Q?IIYxrJw8Y28I7I1UG5dFrhBeaoojblyBRTXr80/CQe/kMQ0DbKYxOlmKDw6Z?=
 =?us-ascii?Q?w6t7TfTOW4E5JLJQeq2F1q/2hbOTZb6Bys4psVoa7dZQEh86goRvBMdUP9Sm?=
 =?us-ascii?Q?UoXDBFTO5FgkxaJ61J/A7GRWnHGjn7J2AeUVOcwcQ6rx8xaDAwiuzsJ9jN05?=
 =?us-ascii?Q?sGphUV8Y1Lj5pFDrZ3sGYhWK7Nl7BYGSIOL+idf2lWW3RFeCXJ4AwAZcJw9r?=
 =?us-ascii?Q?o88BfzewVZJNmt55wxr4rTBHNHRLmx/Zxeik/kx/8PKMScTw6fhXALZZLXMu?=
 =?us-ascii?Q?2eHdQje0z+BOiz14kCm7aMJk044X/fTaSpXyAF54?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61761670-6065-42f9-05f0-08dc844ea325
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 04:27:26.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEulrs0emebxvap2QwdHt8/RROJ5r8ZjRNSLIOgJoIHVXrNmRW8noi4OKP9LNH6S3dydrNFkqfQ/qPp6f/ccNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6987
X-OriginatorOrg: intel.com

On Fri, May 31, 2024 at 11:18:15PM -0600, Alex Williamson wrote:
> On Sat, 1 Jun 2024 07:41:27 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Wed, May 29, 2024 at 10:52:31PM -0600, Alex Williamson wrote:
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
> > > because we no longer have a vma_list to avoid the concurrency problem
> > > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > > huge_fault handler to avoid the additional faulting overhead, but
> > > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> > >  
> > Do we also consider looped vmf_insert_pfn() in mmap fault handler? e.g.
> > for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE) {
> > 	offset = (i - vma->vm_start) >> PAGE_SHIFT;
> > 	ret = vmf_insert_pfn(vma, i, base_pfn + offset);
> > 	if (ret != VM_FAULT_NOPAGE) {
> > 		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
> > 		goto up_out;
> > 	}
> > }
>
What about the prefault version? e.g.

        ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
+       if (ret & VM_FAULT_ERROR)
+               goto out_disabled;
+
+       /* prefault */
+       for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE, pfn++) {
+               if (i == vmf->address)
+                       continue;
+
+               /* Don't return error on prefault */
+               if (vmf_insert_pfn(vma, i, pfn) & VM_FAULT_ERROR)
+                       break;
+       }
+
 out_disabled:
        up_read(&vdev->memory_lock);


> We can have concurrent faults, so doing this means that we need to
> continue to maintain a locked list of vmas that have faulted to avoid
But looks vfio_pci_zap_bars() always zap full PCI BAR ranges for vmas in
core_vdev->inode->i_mapping.
So, it doesn't matter whether a vma is fully mapped or partly mapped?

> duplicate insertions and all the nasty lock gymnastics that go along
> with it.  I'd rather we just support huge_fault.  Thanks,
huge_fault is better. But before that, is this prefault one good?

