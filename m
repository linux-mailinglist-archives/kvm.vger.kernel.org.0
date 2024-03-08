Return-Path: <kvm+bounces-11339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2BC2875B83
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 01:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21CBC1C210FC
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 00:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C081DDC5;
	Fri,  8 Mar 2024 00:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OPNSNR27"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F691CD0F;
	Fri,  8 Mar 2024 00:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709857285; cv=fail; b=IVw8UzCVZQ5X6XiKzpngzHmh3AftH2x9lMrNcEVMo7dXEpmnjBSb+txnS0uGl4o0x0u0OY1dZcTZauoODMxv8v0yBknaCCpUwUyn5+IYFjevtFZIPzFJZWGqPwJJtZTu/YJTS3T0fSVbCCfsV3PDeXxYa9zrD9pxsERLAuAMK40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709857285; c=relaxed/simple;
	bh=8A+w635dIh5cL//hP9d/j+wZq+sigXisJL16QtHSL9Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IGy6UXGDlOJEHH/cXSg6BK3RhE7Y2OLK1/7pRPcj/DOqroWseSUwVwS27UtErO9Lsc6EFHPtn0YeRQg1gyKyUpsftISKL8bDrOBCjNscjWcsPTECMNyF9/34V068CkDZNUTTUlSNCBl/a2OWqJmEE9b6m7dthd9+229u3BNPpEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OPNSNR27; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709857271; x=1741393271;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8A+w635dIh5cL//hP9d/j+wZq+sigXisJL16QtHSL9Q=;
  b=OPNSNR27Av9k8IUZr1nBOoQld+ztjsVXF68vaYPTxYx96y+0VmSLdf95
   l3SxBoasofaNrwUfGEjfKVwk0TRx5KcPMSx+6lioh9CBGi02cMzv6VJGs
   +nTW8wdmTb6aly8dDfMCgBF76gZJ3nXTHSha0jXewvCvKy/kvELEJgR1L
   GgPZLjuKaZFYYl2mTvDDnSlDgpbqxMT07p5EIdpmo+sekZAam3pLQdrJG
   twMDCkzKClNcti7Q+y/QKFofiqFt7i7aGHTLrnjXbNGnbOv3pRlLUTYg9
   PdhdkBJY0gblh26uGpJW2VTKreE+hK4/r3lmzLSCBTeKluRfoaSnp5IZE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="15969839"
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="15969839"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 16:21:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="14851288"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 16:21:08 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 16:21:08 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 16:21:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 16:21:07 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 16:21:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9scnu3mI6NuoyDxcZzSHNTS8s/Vk8ltvKUlRKQh0RP9qymgD7MBdO1zTd0dun2AWJ6kudD1iFla2faL02MVo5UTz0dIbKjFNkolbduNzb4IE1anGRjHJA4PTLhxY5J2/xi2vnpTrFuiz6m693iqik4mBxoiRQsE8SEZb/15jPNEyMuctYTWgjJLcNGLDOI4DD5QBXqSPrBGc2WG9DBmPG41rxFcAUAzY6YwfuZ0sor5Qh5PurAZyO5VfX46W6edGVHr/bxtLIZhWXC54c0Jm4gNngyw21rF4ImfumlQEwMaPl8GwgVfkpspeOZmOOD8t5kWelh8/ekePZx3EeGCvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrUW6DbWLgRCRuYL/NDZZG6sC0BAggzYO3ze3rP2XMQ=;
 b=D42wxwOQ1il3foW3axCGgOJUXpY+6pdGBwlCDlN1CW6b7CvbE2PhcUDxdCNs6TyEu6HsmGCooDxdxALcOpWUnOP5FYHVxcZO2scBWufOTbbrOOB+v8v63Jw+iX2BfNk1oFmxojM7imZDOBm1Ldr/abM/YGcYg+6vXGWnSHf4+i2S0AcHwl73THsL5OumB/AdXwky3pULxGKu94F4GSpNzPisjJmiq63vIoB2Q7Ttt/4LtxJErYMRGIVlDyOdC9I8Fn7bH1OuM+lv/RuUMAs4QGb2CQdXfEWuv1Ex06mDw5lmzV0dep0mRxmmEomg/5kwjCI+4ixycyxLgQK24yakDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4794.namprd11.prod.outlook.com (2603:10b6:806:f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.9; Fri, 8 Mar
 2024 00:21:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 00:21:04 +0000
Message-ID: <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>
Date: Fri, 8 Mar 2024 13:20:55 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
 <20240307203340.GI368614@ls.amr.corp.intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240307203340.GI368614@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:303:8c::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA2PR11MB4794:EE_
X-MS-Office365-Filtering-Correlation-Id: a4133e5d-6319-4d29-6249-08dc3f05a46f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jfB/NVeeQEnW1iHG5fOuWOrDSjPVUrnUoctTHPmgu9wOL4xF14jWPWH/LxOTpSaZP9T1QOyQ9akTTHKbd8NS7eHDg0+BFD6h6QvCIVPomkpqxaGLN+nTVfG0eGQFDxCzLawdxwFfr77uZGJK+bnxqjxZRRDKIJB7DqcQySqQIQA7j/LFr6H1ODY8XwNyg10KrAKCQU0+hMD+kHb0oETaJ8OQ/FZSt5xaz0wwKVPll5BN+AUllJ2fJ4Y1hklN2IGw1BN3MskQIK13uAol6perFKBdsmcYveyJ733OS3U4mrgS7kGiT8384rAzlZZ1lbUCoM0FkS2jUexS+QumY4HK7m2yCLrrvexuES6DMrcZ0I/kPJcYB5oLvCFy+4Z/B7DooK+TeM3PKLir9JZy/fastfD6GYYVowgIoPw8jLRFmPq+O7psNc0MBwwkwPAcNEHXle+g/WlUwHxQnjHrBk9aHzBP+3Y7zAn/t0NDTZ+A5iQPLMM4BnYUe+oizAl2be/PNlq2sh7HZe/2UOIpnlsK/2H6GAPqRH8gSJJMc3MIJTEVYOLgorD6ILt5nMXPbL2XbM19xVA3fWVjjAN3mrK1gm6VJ8nVbVz+T8e3iErfINbjzi6tPnuWmNKAJL27TIswK5CYwTX8zGAxsLO2+a3PjqMzpyICsu5zyNm5cJaPwKM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXFvVE9mSldpNE1oMEx6S3gvaWl0Qzg3RW0xSVFHbUFYVGRRWXkrTTE0M1FJ?=
 =?utf-8?B?K0xtL2prMFRHbFVxUnRubCtSdW83RUY3VW9rMENUMGVHcTcyWXVWME9YNk1y?=
 =?utf-8?B?b0JlVFhqclEzblF0bll4WU1NcEhGODJsbFc5N3R0T2VjU05GZFl4NjVvNmwy?=
 =?utf-8?B?S05zbHdWeVE2WTBLWkpwWGYwYWl2ZXYwanNaa3VQYXl6TVN6eFBvWDk4MUov?=
 =?utf-8?B?RDY2YjVYVkdnbUlNNjczSzg3UFQ2MEpydVVYV3cyZDgrU09pYW5EVVVBTWpC?=
 =?utf-8?B?azFaZlZQSVBSZDBTUGpvQUhlQnBpZ1MvUTRSZW5YVStZcXZyeEtQVlM2SXlo?=
 =?utf-8?B?UUxNTGxkLzZMdmE0aklLdUxWczIzTktENFBBQTFaWmE5ejdwdXc4dWFSMERy?=
 =?utf-8?B?bmNrYVkwVkc1ekJOaEh1aXhTQ3BVRjVGaVBsaVVvL2NEQm5BL1BhdU9iKzNr?=
 =?utf-8?B?T0NYZ1Z4MnJiUU5DemFaWjNiUlY1cEZhTmhQdFpWaklrcFhIY1hsbmxhRkpV?=
 =?utf-8?B?dnZXSXQwL2NlakZFdDRiT2JlbWNKSlo0c1J5cy9hTk5WbkFJQm1sVHYxMDV5?=
 =?utf-8?B?MFZLY3c2OWVvWkFSbytRTmRmMW5NK3BhRWs1Zm12T3dReHQ3dnhIbHRYTzAr?=
 =?utf-8?B?U0VNa1FxQWlPWVhCK1NQcFJwaHhFK2RDaFR2S043NHY5aGtIR2hIM2F4Q214?=
 =?utf-8?B?YWhHMHBBTC9jamF1Mi9NQnhiTGoyMHY2cXc5QkdSWGZ4Y2NVZnRSUGRLU091?=
 =?utf-8?B?MW5wanUzQWhpQWpFSTc1U2x1QzRLOXhGZkRXcHhiME9ab0xhcVU4Zzd1Mzdy?=
 =?utf-8?B?eVRZRnlJc0NNRmtQVW9tYS9DYVZ1LzBNbDIvMXFrb1FXa3RtNWxjam0raWpo?=
 =?utf-8?B?TnFzLzF1UFo3MUNQckhSVkZUZ252elNmMkVFbHFhVUxWd3lERm9IM3ZjczRL?=
 =?utf-8?B?bVUxUkF0dFhpZ1ZhdGZSeEJUckdTdGRzNFpiUlFtVlJKc0hlcnE3a2VibUhk?=
 =?utf-8?B?R2dyZHd3ZWdaOWFaOXdSY3lQNnJTSlBiT1dyOFhhMTRNVFNReHlsK3BvRHRK?=
 =?utf-8?B?Y3k2bGJDY1ppNG11b0JqUi81Y2lmYzVieXgyWkozR1N4MkE3NWxsNnBVVmx3?=
 =?utf-8?B?WGUvWWtoVzgxU1lJRlYzODhsMldjQWhmTGFwQnQ4dFdKZ3EwWkhNOGtEM1ZE?=
 =?utf-8?B?Z2MzYUVhYzM3NDc4TWVqVEg0SmxnWStLYURXTjlvcFhDcGtYYmpkTlhNL3hq?=
 =?utf-8?B?ekpsSlJjN2N6bE1wbWVXdFdjdDBvYUZJOEt3VEZJUy9WQ2Q2bHE1YjhQcnhn?=
 =?utf-8?B?dHdGM2YybElsSndoNUFRb0sycGVVTnRYWG9DVmdUTXk4dVVLM0VwM0xGbmgv?=
 =?utf-8?B?dkpUWWhDazY5QlNweERXZ09KYVY1ZVpPcUVCK1MxK0FEcFhHNThUM1oyUFh2?=
 =?utf-8?B?Qkh1WGgwNUo2OFpsNmlubnFKMi9xUHU2TmllbnV0V1lJd0JEUVMrWUloOG9y?=
 =?utf-8?B?WHBWbys0dUUwVWhvM1NGTlUzcnFrQ2NzdnJuaEVMTDBReU1iQUNpZjYrSmoz?=
 =?utf-8?B?cG03UC9Ydi95Wm9jbWFJa3V5ajB5Y0p3YU8remlyVGZtQW1OQWRQaVlIQ2oz?=
 =?utf-8?B?clNCc1dOWTMvanIxamhYNlFhWHZObjhLT2xkYmJ4S0VOVnJwVnpXQnZuNVR5?=
 =?utf-8?B?TUZhRmplVmgrelEyVmhxbkpYamNMOHprREpsYW5XSGN1SWpuQkpIelAzdzZL?=
 =?utf-8?B?Z1JlUCtDb2h6QytmdTJONVpRd0ZwNW5pYkEvUFJIa3VLRW5KWXoxYWdMR1Ir?=
 =?utf-8?B?bng1RzF2K2xVUnZuVVhkMnYwT05ZQ2dYVm5PVzhyb3VkWXNad3UxS3JjYWs2?=
 =?utf-8?B?dWF5VlRIbVR4WCt6WklMbklBeDhhbVgza1VtZEVDUk5QczBFdDUvRHFGZG0r?=
 =?utf-8?B?bmFvQ1BkN1hsQWlhcUg2djBNbHdGelJGWWJ0ZjQ0QzJYOWZ5OU5yWmNEaVVF?=
 =?utf-8?B?MHh6SVY5a0FGZjRGV3Y0Sm9iOTYvUVpHNWpVRldNcGhNcFVKK1hDc2ZZVGpZ?=
 =?utf-8?B?WCszem5mSC9UcmIrVnROYVI2M3JDTW5oTEh2T040bTVRYXFVSGJ3RTZMRmU0?=
 =?utf-8?Q?c4kAmtQYaLZL7wzj6/86W8Ovm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4133e5d-6319-4d29-6249-08dc3f05a46f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 00:21:04.7631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pTj7iluf7j17R9TaISbPdXLQ1I6Q/gvC/BjNHOAtwg852rDSpEHPrYiB2C0stxTTKsnvFKkuKXoQYMDaHQ5r2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4794
X-OriginatorOrg: intel.com


>>>   
>>> +4.143 KVM_MAP_MEMORY
>>> +------------------------
>>> +
>>> +:Capability: KVM_CAP_MAP_MEMORY
>>> +:Architectures: none
>>> +:Type: vcpu ioctl
>>
>> I think "vcpu ioctl" means theoretically it can be called on multiple vcpus.
>>
>> What happens in that case?
> 
> Each vcpu can handle the ioctl simaltaneously.  

Not sure whether it is implied, but should we document it can be called 
simultaneously?

Also, I believe this is only supposed to be called before VM starts to 
run?  I think we should document that too.

This is userspace ABI, we need to be explicit on how it is supposed to 
be called from userspace.

Btw, I believe there should be some justification in the changelog why 
this should be a vcpu ioctl().

[...]

>>> +:Parameters: struct kvm_memory_mapping(in/out)
>>> +:Returns: 0 on success, <0 on error
>>> +
>>> +KVM_MAP_MEMORY populates guest memory without running vcpu.
>>> +
>>> +::
>>> +
>>> +  struct kvm_memory_mapping {
>>> +	__u64 base_gfn;
>>> +	__u64 nr_pages;
>>> +	__u64 flags;
>>> +	__u64 source;
>>> +  };
>>> +
>>> +  /* For kvm_memory_mapping:: flags */
>>> +  #define KVM_MEMORY_MAPPING_FLAG_WRITE         _BITULL(0)
>>> +  #define KVM_MEMORY_MAPPING_FLAG_EXEC          _BITULL(1)
>>> +  #define KVM_MEMORY_MAPPING_FLAG_USER          _BITULL(2)
>>
>> I am not sure what's the good of having "FLAG_USER"?
>>
>> This ioctl is called from userspace, thus I think we can just treat this always
>> as user-fault?
> 
> The point is how to emulate kvm page fault as if vcpu caused the kvm page
> fault.  Not we call the ioctl as user context.

Sorry I don't quite follow.  What's wrong if KVM just append the #PF 
USER error bit before it calls into the fault handler?

My question is, since this is ABI, you have to tell how userspace is 
supposed to use this.  Maybe I am missing something, but I don't see how 
USER should be used here.

