Return-Path: <kvm+bounces-11847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D14DD87C5C2
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 901CF28201F
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6130411185;
	Thu, 14 Mar 2024 23:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kgdzU7bV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A692610A03;
	Thu, 14 Mar 2024 23:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710457787; cv=fail; b=aoFekiEmaFGbp0Sknzk1x6T4HR/j0xcTgRQM60MbHBQMbAxKNwYXMfZQnl+JZ8C2IypBQVGdXxwc678onkq1g2tYKOxRcy4mg5QUP2dkPzbYg7lc50XxBMNg+ROrtlWH0uPsATgK5ednUQUQonvqpu4WZOt1+aBNiOPt8mZU+3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710457787; c=relaxed/simple;
	bh=2vR0V+dTJYYPwhPYc9TaiQdrFQAKNYjol71tBHX+U/g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PMzKcyyxKh2l/FFLm9zRWoP9yDjI5WCJ3EsysQMCSwi6/v9qGJtkg+7oaAVG8y2hkLUslF1tMQiCavHnZR4YDfQLf/paEkxCD2OIcxH4t5wHvuPsZB7GRDyJgbOa3Uk5A8HNEvEAuR9gxMIudDPawAeBkqmC6rNLYGLtnOlBNLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kgdzU7bV; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710457786; x=1741993786;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2vR0V+dTJYYPwhPYc9TaiQdrFQAKNYjol71tBHX+U/g=;
  b=kgdzU7bVCOzautw+WW5UV/I6sW/CaHt3TNlhPdHrktr9ysRMoMUGHrjE
   ewcoc4qEVtJDTanJLg0QeLBHhOeUrV57l0KfTQtfhk9lvTpuLW+M19BGL
   viMWof/JZs2zMzrj2p7L0fzlEYkgPEBBGlcL5e9vjSVAZ3B270ICCDADT
   Sn7Uoq1+QO1s1BddIvjC5wo9ajKVdw0UTwt2ldxQxpOVCisSqtxvDhVro
   s+Bvlw0GPmDPbXdYaLSv/ZLnler7HdRDIa+j0KoUQSsnszNPDNtHZ+yl3
   KH14WIZM5QzYZYX0iIYEmIw5btFL4iYcY4F+NDSYK/OOkGxHThgl9dHII
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="9092159"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="9092159"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 16:09:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="12911719"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 16:09:44 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 16:09:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 16:09:44 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 16:09:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZIR4s7nC7dXXNNihuRsCKF7OAE8leAO5bMYveIGh2ubX+Hrdnu4IBEj8wQ7zbVYsug1nUMjqrkEP8NXA0rR+xJAuJBAVausOSEGy0LL8gey17wetYj2e9N2L9fJYDcVfnh+tAJxvv6IJV6tBnVHFF+qtcrD6zHpP2CT8NYCnFj8hg67toRPTpkuY8arkpJYR4NtMZwMmmBDKTYj1+tawtwzxj4QUB9MVFnAAEPQ9yw1hbIAgh6QxheuYx6eHQdGrv1XrZvFw2AkkwlthESccv62xP/hDz6igZ7/WUJV8XT34yylHg0xkkvNMxCZ42qpZv7eRNiaJBpE8lmfQ9Zm1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqXktikUG98F60BHEOIeOJgRtB4y+keNbMknb0JZpl8=;
 b=MYC5mCpwuk87Ieqt2vhQbkI7y7GVtE4GPmUbdn0QU5aEI3madaAxnQ9PeRdVFp5YXj+KmlIle3YuthM4CDgsUHOai683nUEqvKeoHuQfqnMiydzALkBAYT6ltJOXO9Z0i7rrRDQ2TQtDyOdbxhhfuLqY6UPi3I+2yVJvn0+EdhlULjNyfVtHUs3K/qebGNiGE7ssXXZcyR8YDS9psb/uW+xIarN1gd8a2DX9qeJRMw0SjOwpjp/46rNQC5jrhSkbE7K7OHV7CH6Zgv27/1FaY3HfZZV5H7pRQHjsJ2jNq53nBO0gXSXhiw36Smatu4dB1IpDUgRVwuPYMOtXFN/Vww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5222.namprd11.prod.outlook.com (2603:10b6:208:313::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Thu, 14 Mar
 2024 23:09:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Thu, 14 Mar 2024
 23:09:39 +0000
Message-ID: <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>
Date: Fri, 15 Mar 2024 12:09:29 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
Content-Language: en-US
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0038.namprd04.prod.outlook.com
 (2603:10b6:303:6a::13) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL1PR11MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: f0dd64ae-f680-4e98-eef6-08dc447bd2cc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jyuNAzG/PaYw8401D/JrAO5wAsa6vFYm4zIhmsk+KWU0NH3qTrrRzRaELP9KZf+QC02+tdKdqeuccXuJ5jNGL4tF8z/qx6cEciOngNuP1Fh2eiZhwyN9Qa+Vjki6Ljnr67lBzmfoLp/0CNrqRGWsFJzKzCGy3JSoF1hMqQK1S7J8WPcr4ZA3hNFsBlQKSUCK7rrhSU+WvWsCBnxC2Q7vjL6i8hPeJsjSkq+cP4YnIfId3YOLd5yvxaYO0974PhiEvS7Q88wpvrUnXucmCCCvrS2UcqyYrqiQ+GokC0LM/YQBh+2oUepanJNI9cJakmeiyNXq1g2Jv1L0NV2Pt5ylo1CpgOC0AkM5HYAB5PvIsbK6i9eoG9VrPspCPuzE31yJN8H+WOLXsOny47KjzdpXbYUqnc4aAJYvNTfFrp2V06PPTJLk/gARk10QDv6lyE5+GzgRDzwj7A2PecqVpSTDUL+2U8EG6HtZ1OMZ3L8TtpVxqRciPxH0f4QZb4lsxnQLmdD9ebvlsF4/Qf/xlpxXgph9qxe9JAHd4I/13IJNCv4LU2peQt7kq4mg4v0Cb2H5AcjICp7o+7yCxjj5FWwkBcOmIdP3M1ZC8w5OuHxycNE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlBLRjhjVjE5NktQeVQxQ3R0U3dmbEJNY1RKQlVzQ2hWelBSb0VGWlByaEg4?=
 =?utf-8?B?Y0EvZzFIbUVqRjQ0cWNPTUYxbTJqWUNXMHlwd3IvT01XMkdyN01UOEhxQUVH?=
 =?utf-8?B?bldaWmh6TW9IbnBWbGJrZWVGWDQzN2RKdmNvRVp4TmtaazhoaGxKTDQ4UkVy?=
 =?utf-8?B?aklnRFU5a3lvVHM5TlpDeFk0ZExYdTNxUjRxaUZ4ZkVYcFB1WEFsQ2lSUHVa?=
 =?utf-8?B?emsvRjBJck55K0UxdTJVbnFESWlVRHNKRmd4anE5dmZKVmpvWlpUSjVwRURF?=
 =?utf-8?B?ZlQ5ZC94RVdoNzBueFhCYzlQTi9yVzFKa3pnUFhCRTRkWEJkelYwZll6clRa?=
 =?utf-8?B?bWp0KzJ3dDd4SU9LR0VXVElDSlJZM043aVZhUFRMMklacnBPcmV2NGFHZVFZ?=
 =?utf-8?B?eXJuaHRvSzdhWDY4UHgwa1doMlVwK0Z3djRRQzFLd1RiUEFnV2RXbyt0UG1n?=
 =?utf-8?B?U3RkbkhCc1pPTHQ4cHdaSlBLOTNOdWd1N2w3d21vT0kzejFnV1ZRaWI1L1Nk?=
 =?utf-8?B?WkhxNVdOeFNCUGoxM0JqT2JnQkhsdzJDOW51cTRLMjRCQ3NHakM0Yi90aWY0?=
 =?utf-8?B?MmhzV2ZiOFUwQXJGdXo5YkRFaEVwdjNyRmJGM2tiY3ppbFVtRE5oKzUvZ1d5?=
 =?utf-8?B?b0tWcUVIT0J0dHlnM1JNT1dSSE5oZFVRWmFTcVFCMkxaSzBoWmppcW0xRGZh?=
 =?utf-8?B?OTVZWUFUTE9wMFQvZUhoOVRIMURNTm1mbWJqSWJHcGRwOGdNT3NodWVhUTM4?=
 =?utf-8?B?OGlqR3A0aEdWSkg5anlNMnlUZUF5ek10UGVrbnNCNVUvS053cXprVnJLbG42?=
 =?utf-8?B?THd3Y0tqWVZqbzJibUk5Z0NPQWIwOUoxcHFRQStvUmxFL0xTLytudGpOekZS?=
 =?utf-8?B?U3lKZk9IdUszVVBmekszZmp2KzZ4dmhmdlRlVmNwWUZHTHhFVi9VeVdvNktW?=
 =?utf-8?B?Szh4alFTRmVmMWM5K1BTd3lPTGNlUzd4bTAvdEdRNDllU2ZBa2dScDRtano0?=
 =?utf-8?B?RWkwNXR3eVZKT29vNXowRDFQQ1g0S0JVRHVNRmV2NjlzemRUMVlDWE02QkNz?=
 =?utf-8?B?YjFpK0g2djVTUHNOL2Q3UkNkdy80aU5OdHZlUUIzcng2aHBlVC9sR25BQTFj?=
 =?utf-8?B?VmRUUGFvYmg4NUIxQzZSNUlpc0EyWC83dlI4YUd5THRoRExETUsyMWhZQU1T?=
 =?utf-8?B?eWlvVjZBQWJIWEVIbzBhb0ZPdVUxbVZmTlBFQkpKc0RWOCt6QjRjYkhqRnBi?=
 =?utf-8?B?dkEwV1I3K2VnWmk1TlZyVXc0R3N1Ukpyd0hKV2tsUk1WMFhQNnFMMldIeSs0?=
 =?utf-8?B?SkxyQitwUlM3aHVtcVFlclJaa2dnVmtRb2tFckw3L1FTMlI0Tkp3WTJqTjhN?=
 =?utf-8?B?TXAvSnRrbXpHOXkrSHJnUGFDdTRuNkh1VU55M3kzeC9OZndjdG5KclZscUhr?=
 =?utf-8?B?RWdXOHJwcGcrNm5vZVlLZ3FXcHJqdHREQyswM2t2Z0NVQTZFb0pOdW9iMlc2?=
 =?utf-8?B?elJzZW1Ed0lWbi9mN0NjcXNPenpqN1pXRE51WCtQNzZYNHdPcVdtVFkxRll5?=
 =?utf-8?B?aHhsZWVSOHo0T2dFajUxTnUzemlBVTFmeXVsdmY4TkpwME1DZDJlSXY2bWlN?=
 =?utf-8?B?d3FXMGV5cGZiSzN0aHhOMjdKeUxNRnB0K2JYekU0VE5jTWJZQS96VlFsMFBW?=
 =?utf-8?B?R1UvdzdLTlArVlNLWTdiK0RtakFUNnhuUnphZ1RzbXNWWUNsa0ZCZTRKSmls?=
 =?utf-8?B?YkJMNG12SDliejM2SUxTVnd3SFVlK3JVQUErQ3prLzdscm1pZ1hUODZsSUcz?=
 =?utf-8?B?RFpjc0h2WlUvUnBzZi90STZWbzZxcnZ3Z0s3ZW9ubTBXMnJtR0dmaGVsWXZL?=
 =?utf-8?B?K3M3QmZjbCttNy9ra2xSaHpibWpPMlhjc2ZUQUYraFora3dYMTJGallRWHZz?=
 =?utf-8?B?Vi9UU1RsWVVqRHBWOTVnbHl1elJJa09EYy9PdnM0dTExY0xqYW5PaEJwSnph?=
 =?utf-8?B?SzBhOTFIcGU3eDJxUVdLQ0IyNzM5c3J1bGNtMWNBcCtuTk01K3RCd2ZWRzJG?=
 =?utf-8?B?cU5sMmtLVFA0eFNocjZFc3BMNDFTQzk0NGhHcU5veEErdkpNR3RJNFB6SWFG?=
 =?utf-8?Q?2j4K8/vt6Ho2H3zIaKLEPhVUg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0dd64ae-f680-4e98-eef6-08dc447bd2cc
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 23:09:38.9674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MOHAtonP9foNE7+hnz6qQDVYh8K5FXolYefW+Z+pIcjWkgNI473OLJf9Vs2jyQnpCFHsB5AgdofcAvILn66Xug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5222
X-OriginatorOrg: intel.com


> +struct tdx_info {
> +	u64 features0;
> +	u64 attributes_fixed0;
> +	u64 attributes_fixed1;
> +	u64 xfam_fixed0;
> +	u64 xfam_fixed1;
> +
> +	u16 num_cpuid_config;
> +	/* This must the last member. */
> +	DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
> +};
> +
> +/* Info about the TDX module. */
> +static struct tdx_info *tdx_info;
> +
>   #define TDX_MD_MAP(_fid, _ptr)			\
>   	{ .fid = MD_FIELD_ID_##_fid,		\
>   	  .ptr = (_ptr), }
> @@ -66,7 +81,7 @@ static size_t tdx_md_element_size(u64 fid)
>   	}
>   }
>   
> -static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> +static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>   {
>   	struct tdx_md_map *m;
>   	int ret, i;
> @@ -84,9 +99,26 @@ static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>   	return 0;
>   }
>   
> +#define TDX_INFO_MAP(_field_id, _member)			\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_info, _member)
> +
>   static int __init tdx_module_setup(void)
>   {
> +	u16 num_cpuid_config;
>   	int ret;
> +	u32 i;
> +
> +	struct tdx_md_map mds[] = {
> +		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
> +	};
> +
> +	struct tdx_metadata_field_mapping fields[] = {
> +		TDX_INFO_MAP(FEATURES0, features0),
> +		TDX_INFO_MAP(ATTRS_FIXED0, attributes_fixed0),
> +		TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
> +		TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
> +		TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
> +	};
>   
>   	ret = tdx_enable();
>   	if (ret) {
> @@ -94,7 +126,48 @@ static int __init tdx_module_setup(void)
>   		return ret;
>   	}
>   
> +	ret = tdx_md_read(mds, ARRAY_SIZE(mds));
> +	if (ret)
> +		return ret;
> +
> +	tdx_info = kzalloc(sizeof(*tdx_info) +
> +			   sizeof(*tdx_info->cpuid_configs) * num_cpuid_config,
> +			   GFP_KERNEL);
> +	if (!tdx_info)
> +		return -ENOMEM;
> +	tdx_info->num_cpuid_config = num_cpuid_config;
> +
> +	ret = tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdx_info);
> +	if (ret)
> +		goto error_out;
> +
> +	for (i = 0; i < num_cpuid_config; i++) {
> +		struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
> +		u64 leaf, eax_ebx, ecx_edx;
> +		struct tdx_md_map cpuids[] = {
> +			TDX_MD_MAP(CPUID_CONFIG_LEAVES + i, &leaf),
> +			TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2, &eax_ebx),
> +			TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2 + 1, &ecx_edx),
> +		};
> +
> +		ret = tdx_md_read(cpuids, ARRAY_SIZE(cpuids));
> +		if (ret)
> +			goto error_out;
> +
> +		c->leaf = (u32)leaf;
> +		c->sub_leaf = leaf >> 32;
> +		c->eax = (u32)eax_ebx;
> +		c->ebx = eax_ebx >> 32;
> +		c->ecx = (u32)ecx_edx;
> +		c->edx = ecx_edx >> 32;

OK I can see why you don't want to use ...

	struct tdx_metadata_field_mapping fields[] = {
		TDX_INFO_MAP(NUM_CPUID_CONFIG, num_cpuid_config),
	};

... to read num_cpuid_config first, because the memory to hold @tdx_info 
hasn't been allocated, because its size depends on the num_cpuid_config.

And I confess it's because the tdx_sys_metadata_field_read() that got 
exposed in patch ("x86/virt/tdx: Export global metadata read 
infrastructure") only returns 'u64' for all metadata field, and you 
didn't want to use something like this:

	u64 num_cpuid_config;
	
	tdx_sys_metadata_field_read(..., &num_cpuid_config);

	...

	tdx_info->num_cpuid_config = num_cpuid_config;

Or you can explicitly cast:

	tdx_info->num_cpuid_config = (u16)num_cpuid_config;

(I know people may don't like the assigning 'u64' to 'u16', but it seems 
nothing wrong to me, because the way done in (1) below effectively has 
the same result comparing to type case).

But there are other (better) ways to do:

1) you can introduce a helper as suggested by Xiaoyao in [*]:


	int tdx_sys_metadata_read_single(u64 field_id,
					int bytes,  void *buf)
	{
		return stbuf_read_sys_metadata_field(field_id, 0,
						bytes, buf);
	}

And do:

	tdx_sys_metadata_read_single(NUM_CPUID_CONFIG,
		sizeof(num_cpuid_config), &num_cpuid_config);

That's _much_ cleaner than the 'struct tdx_md_map', which only confuses 
people.

But I don't think we need to do this as mentioned above -- we just do 
type cast.

2) You can just preallocate enough memory.  It cannot be larger than 
1024B, right?  You can even just allocate one page.  It's just 4K, no 
one cares.

Then you can do:

	struct tdx_metadata_field_mapping tdx_info_fields = {
		...
		TDX_INFO_MAP(NUM_CPUID_CONFIG, num_cpuid_config),
	};

	tdx_sys_metadata_read(tdx_info_fields,
			ARRAY_SIZE(tdx_info_fields, tdx_info);

And then you read the CPUID_CONFIG array one by one using the same 
'struct tdx_metadata_field_mapping' and tdx_sys_metadata_read():


	for (i = 0; i < tdx_info->num_cpuid_config; i++) {
		struct tdx_metadata_field_mapping cpuid_fields = {
			TDX_CPUID_CONFIG_MAP(CPUID_CONFIG_LEAVES + i,
						leaf),
			...
		};
		struct kvm_tdx_cpuid_config *c =
				&tdx_info->cpuid_configs[i];

		tdx_sys_metadata_read(cpuid_fields,
				ARRAY_SIZE(cpuid_fields), c);

		....
	}

So stopping having the duplicated 'struct tdx_md_map' and related staff, 
as they are absolutely unnecessary and only confuses people.

Btw, I am hesitated to do the change suggested by Xiaoyao in [*], as to 
me there's nothing wrong to do the type cast.  I'll response in that thread.

[*] 
https://lore.kernel.org/lkml/bd61e29d-5842-4136-b30f-929b00bdf6f9@intel.com/T/#m2512e378c83bc44d3ca653f96f25c3fc85eb0e8a




