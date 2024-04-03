Return-Path: <kvm+bounces-13496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C212D897A59
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 23:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76B5D288E13
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 21:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F3D15667D;
	Wed,  3 Apr 2024 21:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YB+l1sCe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE3615664B;
	Wed,  3 Apr 2024 21:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712178240; cv=fail; b=nD2e5rQ9AiSAQe1VXxIXiWx9P7PF+XGfjaKFVxDKceA93UVK1dfQk9+wU61sk4r7OnTbIsZWawqw3HkCzlJeQZEGnycwIvWE1p0qzFTEIwteS+jd/Lq42rSA6jjv1MYJrRG4WJBVTN/e4hLcnXSvDcXiAONfSBl+Iz6PQ9vIXcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712178240; c=relaxed/simple;
	bh=nPpBNkYvKXfuAqVGgEhuaJo5ufLR70zTxQlEiz2VEtg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H01Gz7a6JWZo6ZPFV0ZQidcz2z+7k1n4IPxF+wv6knpfTvrazk9lfkuBW9ns/3cTtqpsPKd/rpT6DlUWe2eBLQVHpBKgApm3hyJdgrSr7k9vT3j8G0HvUrZdGCIMgqwjCuFv4hRGu7kndny/XI4vrbhMLHSYvNlONz010Q5mJH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YB+l1sCe; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712178238; x=1743714238;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nPpBNkYvKXfuAqVGgEhuaJo5ufLR70zTxQlEiz2VEtg=;
  b=YB+l1sCegeF0ol2CZ9Dw/ijCPckHvKv67CdcS0yvZzTq8EiB+uzaGtXm
   zYSBOdcQPreOKCOAmhjwDNxmLzdflP2aZ7oV7vkgV9XjhQM4c2evr3f1K
   9mcu9dOODwKLrlCOUi9PFWNrGioaoNOF6Rmi3JOoz/vJfU4Oh28XVhF9g
   sVr26fi1RjNrdYqo0qdjkGuFFZ3UI1WRfjWsu/bBqcBHbksgul77Xu75M
   G2LP/0m73A3PeeKiOGx+cnccFtkZDrT4AyTN1agzJu60+6Tn6ITQzABgG
   9EStUVJJvGfm6ytxSAlJ/thg5dmmfjHAlME5Io49iUka70wC1jFR0ch2t
   Q==;
X-CSE-ConnectionGUID: f8luOEb5Tzew2Lhr2ov07Q==
X-CSE-MsgGUID: fz71X5oOTFCPyBWCtWWwyw==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7626713"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="7626713"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 14:03:30 -0700
X-CSE-ConnectionGUID: DfSHl4QNTrWbKmOTvqVYhg==
X-CSE-MsgGUID: qykw0xnkSvidzDdZ0sEpYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="23211568"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2024 14:03:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 14:03:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Apr 2024 14:03:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 14:03:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uk3hthrIdaZAlporY8FwHlQ26rRPbn8x1zUJgFyV5r98T6HdgU+vJaoZ6h6i2/Y6qOidER+b6nALBMQ6tNO/Vgr8B7YlVSEMlLy1WdaDq0iI7uR1zzRXnQ2PTAyMrP10H6K8pTeho25Hdgogjc5zCYT9FX+pFSAplC42oSs212oanGSP5R3ZEKvTL3kggD8cZGMaiNZlm+P0vdK+MO9g7Ttwu89BKWnK6DflgiOJMp+Iyyr5Icod7wA7fzAsEZaQRIsFwQaFUOdv3nEWkwyiacqfZHb/ELxSTAaI995ovMA3PNjsFL7Txs3fFaBVsXkjjt0cZBp17cAb+iP50TkQVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcy40OgUMOBRj2Y11L8nviv9+gOjaX+O7fE0slcBw18=;
 b=fzMHrBWxwKeoeJMeEM1UmQW3Im2TrdpHACbEr0MRQjmfOgNEP5BWWbLQQ3JH1Jn8Qy+Y0ZD1DD8hU9R62XAZpgcrXxAs5tyNO79PJu5XT7P3DTLgHMfRz0YEo7FhTUiZjGxQIrzBhzb+M3tXbN7YWeGOUbjdSgDbVDCzQ6epbbVWxvsSJzwvXTusS8t4hQ4a/vU6Nfgtc4Cd1wbCOFieHN8jkkM9dYm59M2yKbPfRLoS4ZSbz2ELrkFJBaojdlDW23htaez04GPJphaykJevpImRsxhU/80byqQNFO2DzCpLFEkzOCd8RdojHX6bM9AmV6p+6jo1IVqFui/o0LCMiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5035.namprd11.prod.outlook.com (2603:10b6:806:116::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Wed, 3 Apr
 2024 21:03:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 21:03:28 +0000
Message-ID: <4c5d27ee-1e79-4b67-9b1d-354328e47388@intel.com>
Date: Thu, 4 Apr 2024 10:03:18 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] x86/cpu: KVM: Move macro to encode PAT value to
 common header
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
	"Peter Zijlstra" <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Shan Kang
	<shan.kang@intel.com>, Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-3-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240309012725.1409949-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0283.namprd04.prod.outlook.com
 (2603:10b6:303:89::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA2PR11MB5035:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+UIEwQqHdWeWxYryJaJdiYCo3SI6BbH6QzEKuXDXljqeCNcZzSF9ZeFGCPMFRoZ5zrUvBNhGA7tHsVFhjc0kJ4mj9cAfafpI6e1C9PuhCo79gy8Hv/47DQyXem1Z97/zjS+h/NihgM0Wilo+BJmCj7NJ1L7YU8Jf+oqIhcw8gM7Y+9sVqJW5hMtc3scTQmy8hCW36LZ17LLf+reiIL5y2WygfR2r5KPOmxcU48Dc/ujDAA0jAr3lR3PDlnUL/79HPhzx0PLOdGxAjeT1SXx3TjgiDlOO9XEB82E6sxzO8gXkk9uZkdyEZWSg+QM5YZUeWgQGFth/VgskOPxAkPPqPLt928hXrto3QWSaCFoxn7sdLPLKXAWqNpG9VDixNVCMgXxGgF0g3zE21gWeYHP27yvanThX1T2ikOfgf9HWNr6YI7JiQNPZL63+e8kACRTeoAO6ZLUhlP7+JqxbVoVpf/F/hT9H8rF+Chziut2jirG7HwjlBKXvKwcQp4/BoPdrWM64EO7e/xA/UQg2JeLyyppeSeoce+PHzFn3dpvhQKGvnZ1z0RuT0OJSj9kVy/ecCiMjDPh89KF4doWKB3mBobicYCHteo/250Dn3TJDGbC+NK67aoopzud5rlR8DSaYOwAg9Ut/LZf/Q7yQKHOQgVwXRrXZ5pbUBg4kkoZpEA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDdGR1pQQ28xQ25NOW05QVRadkFqb1B4c1Q2ZDRhcGtwWldQTXZoVTZqYUxB?=
 =?utf-8?B?UWUzYlVuL1hOaUdaWW1NUkQxK0MwcDJ0S1ZEVWU4N3VPaUVFWENwZUtJS2N2?=
 =?utf-8?B?T1pkU0JXSHROY0hwQmh2UlNENHBGdmMzNVJtU0V6bW9uS2hHVEFBeDc2Y2pC?=
 =?utf-8?B?NlY3QUNOSllIZXZocHFxcXJBTzFDbUdyM0YwYnp1V09wejM0RXFuM1ozM1dM?=
 =?utf-8?B?aW43YVBtUk9QNHVLWE1zUXB5NTl6QlRPKzV0cEx5azJFRFFhU0EvUmplcGph?=
 =?utf-8?B?MUc0dEdkeHBUdjhMeXlpVmxiUHFYODRuNUtuK1EzclpPMWxPenI1U2dIaXRQ?=
 =?utf-8?B?QXRSaTZLMmwxQ0NNR1hOQkd0WmZQdFZEbjh6MU0xZi9vVWRhMTQrY2NGbmdF?=
 =?utf-8?B?SlRwVmFMQ0VlaWZTaStXMFhMalhjTUFXbVJSN043cWJDQ1h5dGdxcDNDa0dQ?=
 =?utf-8?B?cFhBK2NaMllseVQ0YVRnRUJNbEZlaEZjMzJKUDUzWnJLYzVWRW9sdHI3WEZk?=
 =?utf-8?B?aHhHb2ZRT1F1SkRyNTdKa2t3TVdPVUd5ampZdyt3dmZ5K29ybW9qdHVhZDVm?=
 =?utf-8?B?VlVGOEMyV2JvNnZaWGwxYUJDdlVTNlY3TzQ2ZFpabEtGTDk4QVZadlZyYU05?=
 =?utf-8?B?ckx5aStGSDFhOEpPWDFJSGtUMUNRM25JRlN2ZlA2dTk4RkVsWEpSOWxOSkhi?=
 =?utf-8?B?MTNmcVdEaHZhM0IwNkxmK1FvVFZ5K204RVVjTHg4dndlSEdQQUhjSnJVUjZr?=
 =?utf-8?B?TXRqVjU1SjY0VjFHY1ZUQllQYXMzS09xRTVJYWtKejEwaHhmd0hHam5sSzBZ?=
 =?utf-8?B?NDc2VzlBN2YwQ0hQZU5mRmt2djlmRHlXYzQ3bUpvc29FNEpMWVhWRGR4Z1Jl?=
 =?utf-8?B?QnVDUW1aMUFqZEZpUlVLTEVPTGJFcFg4eGI2WlRTUmpUcDQ0QkV5QkszVUtS?=
 =?utf-8?B?TlFua3Z4OE1YSm9CMkNlNFFodGpCVkovU0c4WjlsT0FiRWJjeWk1Y2ZuZTZN?=
 =?utf-8?B?UGdFYnpNeURXcEtHdVVJVDkydjhiaXYzeE1rN0xoUzFxekNwTXA0RzVMWndG?=
 =?utf-8?B?VjRvZ0UxQnpqUklZNlFCSS9yeUxna1hpdWtzT3Z0QTRzbmhobTFGdUhqdkg5?=
 =?utf-8?B?WENyZHQwSlVVVHp4b3RRZTNITHF4R1FCbEFtNzZMNzVDM1BJbmFTR2NLbkdU?=
 =?utf-8?B?dW8wYUhLZVNZRVdzOFZlUDA2djZrNFNPZWppVVNCQjg0anUzWjNELzBsLzVi?=
 =?utf-8?B?eGtpdWhzS0pDelQ5WTRUL2FjYW9EbytYdmpmeFprU05PaDJkK2VwdTZpeExT?=
 =?utf-8?B?OHNhSDJab3ZCV096QnI3R1RqMnZRTjNJZmhGeE5RVEpxdmt2L3ZKbW1tYXR4?=
 =?utf-8?B?ejFwN0tCUWhGN2pYNkZPRDFaSEFOV2QyanpDMkpOZGdSWGwzWDFmc3ljSSt6?=
 =?utf-8?B?ZVYzOVlieCt5SmhLWHNLVWZDY2Q0WEg2S0FIaEZ5a2J2eWlEYWdQY0R0S2c3?=
 =?utf-8?B?K0VZT0dpNFFSTEhuOHcycWVOSDhPSDM0SXJSWjYvQWppczh3S3duMkI1N0ZG?=
 =?utf-8?B?ZzhnQVhyVzZxVXNxVGdpQ1ByS3ppaDF2cjdQL20wK0MrWHhnajBBOEdyY2hF?=
 =?utf-8?B?dVI0NlBYaHN3WDEwMDBSQ3V1aHlGZmdsazRseHQ0bkE1WEZPUllON05DbDF6?=
 =?utf-8?B?VWg2MGdQbG1ULzVzU24wbVU1ZUhNUU5DbldDMmk0MFphWkpNV3F6QWx2YnZu?=
 =?utf-8?B?NTgzbnlUQ05OK3g2ajE2MjYybWZtODI4amZ4eC9SQ1R5MWY0QnZZeFZQZXQy?=
 =?utf-8?B?UlJOMkU5MllPekpYdmZSZWZOZ1Y2a3lQZVMyTzRYd0E5cGd1TnIwakphdEQz?=
 =?utf-8?B?REczL3Qyd0o4SXNwM1hwUy9WUWVncEpXWnJZQi90a1crOExqS3A0R2xJTXQ4?=
 =?utf-8?B?N3pBVFFHaldYc1dlUUZNeXlDN3h3Q1haTDRhSDRNYjhrcWpjdEJhQUpQNFhp?=
 =?utf-8?B?SThmbFdGYXduQ1k2cW9nWmdWWGEvZ1k5NHM0NTRkMXozdXVSbFNTSTlPUXhu?=
 =?utf-8?B?YUI1Y0Y4SjAvTUVjYmJnL0F3R3Q0T2cyazNEWFBZUXo4K0hPbFRFa2ZlNk55?=
 =?utf-8?Q?b86iwY7LcHUepAqY/VWv0xq5H?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3dea50-ad40-40ca-d621-08dc542182d3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 21:03:28.7792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtTNWqSfPfsfuHLSA3xwu3KScNLq/XaHy5oz4RWqIKEtfVgQ+WkhpccpZpn5SR0jnuk2uOXjDq3cwP9pExEibA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5035
X-OriginatorOrg: intel.com


>   void __init pat_bp_init(void)
>   {
>   	struct cpuinfo_x86 *c = &boot_cpu_data;
> -#define PAT(p0, p1, p2, p3, p4, p5, p6, p7)				\
> -	((X86_MEMTYPE_ ## p0)      | (X86_MEMTYPE_ ## p1 << 8)  |	\
> -	(X86_MEMTYPE_ ## p2 << 16) | (X86_MEMTYPE_ ## p3 << 24) |	\
> -	(X86_MEMTYPE_ ## p4 << 32) | (X86_MEMTYPE_ ## p5 << 40) |	\
> -	(X86_MEMTYPE_ ## p6 << 48) | (X86_MEMTYPE_ ## p7 << 56))
> -
>   
>   	if (!IS_ENABLED(CONFIG_X86_PAT))
>   		pr_info_once("x86/PAT: PAT support disabled because CONFIG_X86_PAT is disabled in the kernel.\n");
> @@ -281,7 +275,7 @@ void __init pat_bp_init(void)
>   		 * NOTE: When WC or WP is used, it is redirected to UC- per
>   		 * the default setup in __cachemode2pte_tbl[].
>   		 */
> -		pat_msr_val = PAT(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC);
> +		pat_msr_val = PAT_VALUE(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC);
>   	}
>   
>   	/*
> @@ -321,7 +315,7 @@ void __init pat_bp_init(void)
>   		 * NOTE: When WT or WP is used, it is redirected to UC- per
>   		 * the default setup in __cachemode2pte_tbl[].
>   		 */
> -		pat_msr_val = PAT(WB, WC, UC_MINUS, UC, WB, WC, UC_MINUS, UC);
> +		pat_msr_val = PAT_VALUE(WB, WC, UC_MINUS, UC, WB, WC, UC_MINUS, UC);
>   	} else {
>   		/*
>   		 * Full PAT support.  We put WT in slot 7 to improve
> @@ -349,7 +343,7 @@ void __init pat_bp_init(void)
>   		 * The reserved slots are unused, but mapped to their
>   		 * corresponding types in the presence of PAT errata.
>   		 */
> -		pat_msr_val = PAT(WB, WC, UC_MINUS, UC, WB, WP, UC_MINUS, WT);
> +		pat_msr_val = PAT_VALUE(WB, WC, UC_MINUS, UC, WB, WP, UC_MINUS, WT);
>   	}
>   
>   	memory_caching_control |= CACHE_PAT;

I found there's one "#undef PAT" at the end of pat_bp_init() and it 
should be removed:

void __init pat_bp_init(void)
{
         struct cpuinfo_x86 *c = &boot_cpu_data;
#define PAT(p0, p1, p2, p3, p4, p5, p6, p7)                     \
         (((u64)PAT_ ## p0) | ((u64)PAT_ ## p1 << 8) |           \
         ((u64)PAT_ ## p2 << 16) | ((u64)PAT_ ## p3 << 24) |     \
         ((u64)PAT_ ## p4 << 32) | ((u64)PAT_ ## p5 << 40) |     \
         ((u64)PAT_ ## p6 << 48) | ((u64)PAT_ ## p7 << 56))

	...

         memory_caching_control |= CACHE_PAT;

         init_cache_modes(pat_msr_val);
#undef PAT
}


