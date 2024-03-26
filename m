Return-Path: <kvm+bounces-12638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47AC088B706
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 02:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC5A81F3E5AB
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 01:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809A25A119;
	Tue, 26 Mar 2024 01:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lwst/lKW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896F620B3E;
	Tue, 26 Mar 2024 01:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711417453; cv=fail; b=E+YvC2lVGR8JNidVQ7P7W58B87kx3itfY+p7UrrdHGZPaspxmJx9guViAfuVLlQy2D8WZKxONcOqXeB1UUqCGa28L3ISJ5eQk4RixtUO/EE1Y6Y7XbsjP1P+Cxby6qijkl8BMYYKr5v2QW0YMD1ADH+huIqiKQgUPN0NOKRKJpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711417453; c=relaxed/simple;
	bh=XL1ufrS1AGRKCHACzwBPwBfqgaex6zgF2dMySZ5qfG4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iPUZ2AFC2MeA4ID0RQ9QXf5OdMuhljhf5lpUNTqiQALNDqxQPVtqh/1J+6HO2NbELxSCyIGsz4akUVstpXFyKRL5cCZxhhqIzXsmYAODrOsC21HoQ3q0q1FwtbrW732vNelrwVKzLLgbzXaixDslSvU4VA9SEMcEt+tFFPg3eC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lwst/lKW; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711417451; x=1742953451;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XL1ufrS1AGRKCHACzwBPwBfqgaex6zgF2dMySZ5qfG4=;
  b=Lwst/lKWBoqfE2HQGYKfsqENnta/5SUbhJJeyROOV7Ra+PsIrqJ0YMfm
   tPI9G/6fff8/ITi2eJqxTxEOHRMT7XoszuUW2C2X2xbsFAYUY/zn8iNAZ
   JUb+5dsJqVegEF+6n34ovbivWZZBJdD4qZ/VkcPR7KzBHI7NQjhIngk+3
   zzyxTi0g6ky8wp3FCSZEwcmPRTNRDXv7at0Md/R5C1r2Iu2jAZ0DGLM2t
   zcsJCGSs8ATjXk456wNI9X++dAifY3zOm1fLSY/vqtlrJcgPKkBRU9MWw
   ByUxX6UHwhYc7HbRk6bS0LGAtRWbZKn8FUwl1I1mR6aMCs9pJbBm/V7PW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6636076"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6636076"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 18:44:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="15865147"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 18:44:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 18:44:08 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 18:44:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 18:44:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 18:44:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQWgMZdvF9bWbiKpxYe4EQXJuXk8So3Vvgk06WXvsRTS0dbWpiKcZFfixnjWb6QjgQj3RnTIayiOxKgsBl2nFmnrEC1yVRtQjgWZ1ujauKvejSMwgcQdWao6nWe3Z2TxG2yztMtXIJwdIOspLYZ9tgF0bUmaUA2cQ2ggI1LWQtMhYxUEwTvRYmmEL31oSKVECQGLElFuEv45jA8Pf+wzFTIhSE6rcNN5LsYUHC8dh+2qUKRU1idOA2cP4pnd6TBnLBNagkOBReGJxSi+k7vx2pev1gcdFoLhgrslZdp90cY8mvAx9O9l82oY6KZAFaE5rOBwLMoflZJrdBQnTyP7RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBtDbQMR5JmCd2qzxcxxIw3qu7BVdSIMIBYfHY40YHM=;
 b=ftYqv+IWRBFyVftTzlCwOkaJa9w0bIQT04Kib0GuxSjvqZ/6hOkTJt4N+xU7ZBCOnjFQCuHxnQ0n0RhlfSnpNtabWZERXlw6uu5rV8zPd5t2G6PTsRCYvcqTPV3si+M9Cm0PCP4Vk5RR0qe/l1LwN66lyx/wabn9qhgZPF4iAvyZcx14KyHxegbjEs3ohV6XE437daZ39oh872jlZjc2Hh77G6wJkcL75gVxgZnR3kzptjO4/DWW6n40UksZYqb3R+qFL0cL/+tW+EcIjWupPA/VZVZc6eQhDOLAXysd0NzCfOkdd58voopLP43Qx0X5ShvpuRHnEmNKwJSP20L5nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB8043.namprd11.prod.outlook.com (2603:10b6:806:2ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 01:44:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.028; Tue, 26 Mar 2024
 01:44:06 +0000
Message-ID: <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
Date: Tue, 26 Mar 2024 14:43:54 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::26) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB8043:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/bek9g9LyHTk5NBcOB0wU8dJMXrMMZxCJU5iTvTWijyY7g3Vj+tEhDpJeSvsBojUm/2KROFKHeWT7ESEx9Yo/5fFs+mccJiuii23XWWBnY5zfMkjuT3AQ7HZTlzL7z3lxuYv9Z7LAYtVeCFUpfihSOS5Kt9/vzBjcKCM+WPOsJYRPpeMq6O2DgLmS0YVPq2mmKorQ6wREPQlthRrzpFjno/wMTNAgrN2hZKpQlHIAGXXmaZa83j9l0PlrUEtlRvp+IX+N22HMnIzWGpyPHU7YZnqJ+yh/AvQke9De/nKABqelwqWat8WJlKC1/+OGfDOuXSFiJu/XYG+3eGxxXDNz8giy0rKZ7db0vDsnLSc8nzAlsUhbKqK7XgFdYMdwkDY7mN3v6QojfBU9/tSe2K4iGTS3vLwKnOdXx0sBsdiW+QETDlE5QgAwc38L+GfLosA5WPuMTj7qpkefwqUXZ7NFBrBZBVUz+ehRYo2IQB/xNL9RawbovVMpinz018orf3dqCjPqTcOineUhDycn3j3cKL57wPl65q8F6bkQWHJWsmHu8VBScTgxD6cat0cjQTzdnpyByLv90pUQiVppQ/a5vdnJvQcx111s7BaP0Dk1M7j8h5XGzEtLfQPvZ5scT+N5/swWVZ8RWat6+cOh1azG1zxs0rPs+ypX18PlLEk2A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUZ1UEZhKzlxY20vbEl2VWhvR3dhOWxjb3U3M1krTXNscUFnYnREb21KUzJL?=
 =?utf-8?B?N2JaNjlMVi9ZNE9Ec3NVWU9OQVZ6UStVcU1PYVRkNG5Tbmt5d2FYU2o3VmlU?=
 =?utf-8?B?NEZ1MkJFWWpnbjNRaWJUU0dPOHMwMjdYWU1UWUMvM04xRkZCSTFrWkhISDNY?=
 =?utf-8?B?WmowZ3o4WUYxbW4wbDhlRnIrcmFRTWxTS2dIWU1TaFJYZkVQR0VVN2lTU2Yv?=
 =?utf-8?B?MnZ1d3lTM09ZMFYybFRrbDN3d2tzWFppcGVzVHJDZENabk90YVlGZjBRT1hS?=
 =?utf-8?B?bElVMEp6cEVPd2RzbXpWTmhSVjg0cld4U0J6bEpiVlVLU2VxbzhJMkhZcHZh?=
 =?utf-8?B?WW00ZWVSSGV2dko3K3EzQnpVSDhncS92YWcrYlhKUmVQaTZBQlNrejBHcVNW?=
 =?utf-8?B?aVlzdTg0S2ZSalNnY2hINXN5SFlVRVVSYVM4TCtJZ21iSFMxa1NqNmNpREdZ?=
 =?utf-8?B?RE9RT1hTSXJjT0Fxd1kxbytOa1M4K2ZLYm10cXgxeTFWUG1PVXRQQlZOOWRk?=
 =?utf-8?B?OURBa1hHQWtqZW52R013NWJmYlJHcXBKRTJrb1VFM2p5WE9aSU1mWWZQT3lp?=
 =?utf-8?B?clozaThmTVZZd21ITFJjYzRUTmVYU2VUV2pRWDhBcERiZjg0RC9lUkdVY0xO?=
 =?utf-8?B?M1M4Wm9Rb0pJQ3RVZmdrRXlQZWZmZklBazhIRFdBZDJ3ZGYyVjB5V2lNTmlD?=
 =?utf-8?B?U3NzTDRpOFREdXdoOWs0SUk3Tk1kc3BNb1lpVTlEbDRJNWRDclNFYVd4WkNz?=
 =?utf-8?B?Tm1INzNma0xNb2ZuUVVCQjRRM2h2QmZNa2dUWGxoWVRURmVaRFp1bnJPWFRQ?=
 =?utf-8?B?bWllN1JldW9nbU8wQ2MyYWhpQzd5N2dlN1hPVEZ5NlNTZjY5OHNYZ0pWYTJP?=
 =?utf-8?B?Z1FUSFN6ZjhiU2FOWStITGFVdElGUnhuMkJKNW5Jc1VFeWlJZS9XblUyN0t0?=
 =?utf-8?B?aVltUjZUWmtCTTltaDZiUTFEd0I1c2xVbUVyYnRrOXN5bDMxT0RUOEg1TGFL?=
 =?utf-8?B?SmQ3MXJYY3BpWU1NbHVWa291c3NyWisrbTVNMEJyaW55WElnbFkwd2t4bkI3?=
 =?utf-8?B?N09YSFpkNWxOSG1QWnRhdEFNV2lsWkF1bW1PYWdyU3IxQUZxdkg5RUYxdzEv?=
 =?utf-8?B?dVJabm1nTTN6NzBEZGV6RTJnVUF2aFc0dFpZNHVJNW1kYUhKeWFhNVNTaUI0?=
 =?utf-8?B?ZitoR2V3NDd0SGRxODcwUHU2bjVWcy91eVpNMmRGSHN3emRWUlBjbUEvWW14?=
 =?utf-8?B?cWNXdkpKS2ZyakdRdWNQOC9UTUNpK2tsSXhVdWZ6RTM2M2xaOHVnNlhOTDls?=
 =?utf-8?B?ZlRxUjRaUk40VTdXOGZ4bnRTRTRzSVQzN0V4U1k1bCtsd2JreU1aRHhUc0pO?=
 =?utf-8?B?Z1BCekpya3FIdk1ZUitSeXRDa28zaklCdUk5ek13cXVWdzdXQ3UyLzduNTA4?=
 =?utf-8?B?YkNZN3RGRWVOYk40c0U1dkdvM3NNMmgxam5YOFlNNjE3RE5LWTZJU2RNckFE?=
 =?utf-8?B?UjFGM1ovSU9PblRvdVlpQmdzOTBLMmUxdUJoZG1qMmtzbDFOV3hTSFYxd25w?=
 =?utf-8?B?bXREUmRVeVVMRi9sZFRhNkIzNy8zSDNTQ1Jnd3FiaVltbnkycy9odmd4Qkhs?=
 =?utf-8?B?RXpncVpiU2Y3TVAyK3B4Q1ZDVExTTVY0YTEydXdVVjRSNkJnREVkYkowV0Y0?=
 =?utf-8?B?ekpFRFNaYm1ac1NRMlNQdmJoY24vTzRwY05NdHRpaTI3UlNXN1BGay9YakZz?=
 =?utf-8?B?eG5sRlg0V05xUEtCNko1SzJ5cGRwVkR6VDRIb2s2OGIyTjQrWkM0ZTZzelBm?=
 =?utf-8?B?SkFDOVhLU0trUGxwWFl3b3dMdzIzcEpnREcybGFGMFBiQ0hNYUZOa1I3cnhF?=
 =?utf-8?B?ajluRFM0ckkxYjQ2ejZCN0lxOWpSN3B5emNBRHFqUkoyQU0yclVkOG1vdGFW?=
 =?utf-8?B?VzNNU295emxUYzgzenJkUDVidGFTQkUvampOQVYvRTFoOUdOQUpqU1pnNHdZ?=
 =?utf-8?B?MlZvanRTU080V3BSdGlrbHl2ZDFIL2RCWHE5NnlPd01JOUJJbmFBaGVOWkNZ?=
 =?utf-8?B?QzdNcE5UdytlZHZFMUVya0liM21hRDNOeEpvb1EzaEdoSjFXSktsWFFaZVpp?=
 =?utf-8?Q?fQhZk5KQjPhQSqEIyMH+aPv+k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a56d2df0-f4bc-4597-24b2-08dc4d363901
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 01:44:06.1530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnslfdR4FDRh2KJhk637foFoc/9cd/pEcIb6pnOFWYrjpUm1343gH190JR2GV3+QVPhERQhMUdCFrXZ3vmoolA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8043
X-OriginatorOrg: intel.com

... continue the previous review ...

> +
> +static void tdx_reclaim_control_page(unsigned long td_page_pa)
> +{
> +	WARN_ON_ONCE(!td_page_pa);

 From the name 'td_page_pa' we cannot tell whether it is a control page, 
but this function is only intended for control page AFAICT, so perhaps a 
more specific name.

> +
> +	/*
> +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID

"are" -> "is".

Are you sure it is TDCX, but not TDCS?

AFAICT TDCX is the control structure for 'vcpu', but here you are 
handling the control structure for the VM.

> +	 * assigned to the TD.  Here the cache associated to the TD
> +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> +	 * cache doesn't need to be flushed again.
> +	 */

How about put this part as the comment for this function?

/*
  * Reclaim <name of control page> page(s) which are crypto-protected
  * by TDX guest's private KeyID.  Assume the cache associated with the
  * TDX private KeyID has been flushed.
  */
> +	if (tdx_reclaim_page(td_page_pa))
> +		/*
> +		 * Leak the page on failure:
> +		 * tdx_reclaim_page() returns an error if and only if there's an
> +		 * unexpected, fatal error, e.g. a SEAMCALL with bad params,
> +		 * incorrect concurrency in KVM, a TDX Module bug, etc.
> +		 * Retrying at a later point is highly unlikely to be
> +		 * successful.
> +		 * No log here as tdx_reclaim_page() already did.

IMHO can be simplified to below, and nothing else matters.

	/*
	 * Leak the page if the kernel failed to reclaim the page.
	 * The krenel cannot use it safely anymore.
	 */

And you can put this comment above the 'if (tdx_reclaim_page())' statement.
	
> +		 */
> +		return;

Empty line.

> +	free_page((unsigned long)__va(td_page_pa));
> +}
> +
> +static void tdx_do_tdh_phymem_cache_wb(void *unused)

Better to make the name explicit that it is a smp_func, and you don't 
need the "tdx_" prefix for all the 'static' functions here:

	static void smp_func_do_phymem_cache_wb(void *unused)

> +{
> +	u64 err = 0;
> +
> +	do {
> +		err = tdh_phymem_cache_wb(!!err);

		bool resume = !!err;

		err = tdh_phymem_cache_wb(resume);

So that we don't need to jump to the tdh_phymem_cache_wb() to see what 
does !!err mean.

> +	} while (err == TDX_INTERRUPTED_RESUMABLE);

Add a comment before the do {} while():

	/*
	 * TDH.PHYMEM.CACHE.WB flushes caches associated with _ANY_
	 * TDX private KeyID on the package (or logical cpu?) where
	 * it is called on.  The TDX module may not finish the cache
	 * flush but return TDX_INTERRUPTED_RESUMEABLE instead.  The
	 * kernel should retry it until it returns success w/o
	 * rescheduling.
	 */
> +
> +	/* Other thread may have done for us. */
> +	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
> +		err = TDX_SUCCESS;

Empty line.

> +	if (WARN_ON_ONCE(err))
> +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> +}
> +
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	bool packages_allocated, targets_allocated;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages, targets;
> +	u64 err;
> +	int i;
> +
> +	if (!is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (!is_td_created(kvm_tdx)) {
> +		tdx_hkid_free(kvm_tdx);
> +		return;
> +	}

I lost tracking what does "td_created()" mean.

I guess it means: KeyID has been allocated to the TDX guest, but not yet 
programmed/configured.

Perhaps add a comment to remind the reviewer?

> +
> +	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> +	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> +	cpus_read_lock();
> +
> +	/*
> +	 * We can destroy multiple guest TDs simultaneously.  Prevent
> +	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> +	 */

IMHO it's better to remind people that TDH.PHYMEM.CACHE.WB tries to grab 
the global TDX module lock:

	/*
	 * TDH.PHYMEM.CACHE.WB tries to acquire the TDX module global
	 * lock and can fail with TDX_OPERAND_BUSY when it fails to
	 * grab.  Multiple TDX guests can be destroyed simultaneously.
	 * Take the mutex to prevent it from getting error.
	 */
> +	mutex_lock(&tdx_lock);
> +
> +	/*
> +	 * Go through multiple TDX HKID state transitions with three SEAMCALLs
> +	 * to make TDH.PHYMEM.PAGE.RECLAIM() usable. 


What is "TDX HKID state transitions"?  Not mentioned before, so needs 
explanation _if_ you want to say this.

And what are the three "SEAMCALLs"?  Where are they?  The only _two_ 
SEAMCALLs that I can see here are: TDH.PHYMEM.CACHE.WB and 
TDH.MNG.KEY.FREEID.

  Make the transition atomic
> +	 * to other functions to operate private pages and Secure-EPT pages.

What's the consequence to "other functions" if we don't make it atomic here?

> +	 *
> +	 * Avoid race for kvm_gmem_release() to call kvm_mmu_unmap_gfn_range().
> +	 * This function is called via mmu notifier, mmu_release().
> +	 * kvm_gmem_release() is called via fput() on process exit.
> +	 */
> +	write_lock(&kvm->mmu_lock);

I don't fully get the race here, but it seems strange that this function 
is called via mmu notifier.

IIUC, this function is "supposedly" only be called when we tear down the 
VM, so I don't know why there's such race.

> +
> +	for_each_online_cpu(i) {
> +		if (packages_allocated &&
> +		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +					     packages))
> +			continue;
> +		if (targets_allocated)
> +			cpumask_set_cpu(i, targets);
> +	}
> +	if (targets_allocated)
> +		on_each_cpu_mask(targets, tdx_do_tdh_phymem_cache_wb, NULL, true);
> +	else
> +		on_each_cpu(tdx_do_tdh_phymem_cache_wb, NULL, true);

I don't understand the logic here -- no comments whatever.

But I am 99% sure the logic here could be simplified.

> +	/*
> +	 * In the case of error in tdx_do_tdh_phymem_cache_wb(), the following
> +	 * tdh_mng_key_freeid() will fail.
> +	 */
> +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
> +	if (WARN_ON_ONCE(err)) {

I see KVM_BUG_ON() is normally used for SEAMCALL error.  Why this uses 
WARN_ON_ONCE() here?

> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> +		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +	} else
> +		tdx_hkid_free(kvm_tdx);
> +
> +	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&tdx_lock);
> +	cpus_read_unlock();
> +	free_cpumask_var(targets);
> +	free_cpumask_var(packages);
> +}
> +
> +void tdx_vm_free(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err;
> +	int i;
> +
> +	/*
> +	 * tdx_mmu_release_hkid() failed to reclaim HKID.  Something went wrong
> +	 * heavily with TDX module.  Give up freeing TD pages.  As the function
> +	 * already warned, don't warn it again.
> +	 */
> +	if (is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (kvm_tdx->tdcs_pa) {
> +		for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> +			if (kvm_tdx->tdcs_pa[i])
> +				tdx_reclaim_control_page(kvm_tdx->tdcs_pa[i]);

AFAICT, here tdcs_pa[i] cannot be NULL, right?  How about:

			if (!WARN_ON_ONCE(!kvm_tdx->tdcs_pa[i]))
				continue;
			
			tdx_reclaim_control_page(...);

which at least saves you some indent.

Btw, does it make sense to stop if any tdx_reclaim_control_page() fails?

It's OK to continue, but perhaps worth to add a comment to point out:

			/*
			 * Continue to reclaim other control pages and
			 * TDR page, even failed to reclaim one control
			 * page.  Do the best to reclaim these TDX
			 * private pages.
			 */
			tdx_reclaim_control_page();
> +		}
> +		kfree(kvm_tdx->tdcs_pa);
> +		kvm_tdx->tdcs_pa = NULL;
> +	}
> +
> +	if (!kvm_tdx->tdr_pa)
> +		return;
> +	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
> +		return;
> +	/*
> +	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
> +	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with > +	 * TDX global HKID is needed.
> +	 */

"Especially reclaiming TDCS" -> "especially when it is reclaiming TDCS".

Use imperative mode to describe your change:

Use the SEAMCALL to ask the TDX module to flush the cache of it using 
the global KeyID.

> +	err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(kvm_tdx->tdr_pa,
> +						     tdx_global_keyid));
> +	if (WARN_ON_ONCE(err)) {

Again, KVM_BUG_ON()?

Should't matter, though.

> +		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +		return;
> +	}
> +	tdx_clear_page(kvm_tdx->tdr_pa);
> +
> +	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +}
> +
> +static int tdx_do_tdh_mng_key_config(void *param)
> +{
> +	hpa_t *tdr_p = param;
> +	u64 err;
> +
> +	do {
> +		err = tdh_mng_key_config(*tdr_p);
> +
> +		/*
> +		 * If it failed to generate a random key, retry it because this
> +		 * is typically caused by an entropy error of the CPU's random
> +		 * number generator.
> +		 */
> +	} while (err == TDX_KEY_GENERATION_FAILED);

If you want to handle TDX_KEY_GENERTION_FAILED, it's better to have a 
retry limit similar to the TDX host code does.

> +
> +	if (WARN_ON_ONCE(err)) {

KVM_BUG_ON()?

> +		pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __tdx_td_init(struct kvm *kvm);
> +
> +int tdx_vm_init(struct kvm *kvm)
> +{
> +	/*
> +	 * TDX has its own limit of the number of vcpus in addition to
> +	 * KVM_MAX_VCPUS.
> +	 */
> +	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);

I believe this should be part of the patch that handles KVM_CAP_MAX_VCPUS.

> +
> +	/* Place holder for TDX specific logic. */
> +	return __tdx_td_init(kvm);
> +}
> +

... to be continued ...

