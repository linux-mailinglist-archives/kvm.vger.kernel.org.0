Return-Path: <kvm+bounces-11345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD36A875D08
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 05:06:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 249D11F21263
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 04:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 847F52C6B9;
	Fri,  8 Mar 2024 04:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k71M14ht"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D182C1A5;
	Fri,  8 Mar 2024 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709870796; cv=fail; b=H23doYmxWFcsvzFXRQo0NKgNOk3ZXTEPYLprYjqVOQtlXei6CEhVp7VRygJak6ig1fWVNrh/oy5aYjicgmFDPVfV8xfErDEagl4Bxf3b3dMlkvsTn/jHcLD27sB8L1rstXm1xXfBRBBM/Nt202ZXQUW7Jn31vge4suc48AUdqqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709870796; c=relaxed/simple;
	bh=x92MHlod2OynXXwAjwQznYpbxJle2X35EHdgaGGkbWs=;
	h=Message-ID:Date:Subject:To:References:CC:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CY5YuixJ6DwvdFIvJoXCMXCEMABZij2+8bHue0xz8nZJXW7h5Qxi0oIU/ILihnOznWXjAet+Au59s+oDpTvL+EIZjodB1DQxvN3Bg4Ct7CdXbGFkR1ZV+nEssEbcY1dZP8vnetQTnB8+6GGB9sPsQ+gDsyup02qJQ16j5P1/hzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k71M14ht; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709870795; x=1741406795;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x92MHlod2OynXXwAjwQznYpbxJle2X35EHdgaGGkbWs=;
  b=k71M14httmWOmVR69wAhGhGz/pQaDzvNUxjegTDSo/SdDkLSdxIvEudc
   760LWuRS95i5/CPvohNiFr2cOlAIT1WLYrxgpUp8GwIKVH3l1suKxbC/l
   oc0uw6FP6TXKyVEL8rmr0sjxBr4zewXD2ICKSx3odU80ZGmSPuYjjoYpm
   Y8y5mLDWXJ02rRpYssAEgOHzn9sHKMy0G5zVvaM0XqDb+Uf9Qpxv/ipZx
   SqlIV9vbgi6AHIN2ZS/O4zG1b8fPcvqM4PL0VsXbHpu3qHd4BfH7SsNqQ
   INWtZYVaPELpEbbNrWikc4TCBlmumf6oc3dPOkStEbMfmNsut/QosGu03
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4704304"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4704304"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 20:06:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="14897372"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 20:06:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 20:06:33 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 20:06:33 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 20:06:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsapGHMtYGVPEaDZai3Abjr0I/PfB1LzjHlNOcMzHkgbU/d7qi0/bqG8xYnhMMrY6yk4cI0rwG2lEHjcSue98n5tEwFs6zIOs9S3doLpn8N1UYN7Mks6MJfPVt0p+THZc5DfQgjZRGc13nbB0ypXd4pbCfZK4uL80F4KydUdJXZtrrrv2LmEZV6FPvHG5T9wu7OXlddK8nrwylPXz4w/jaimOtrWlFRhqm0qEfFgJswABa+zyZ8lkMEeRM8TwZgeCPD4TdkA5bbEKqHFSP4/OwjS72RXviKZa5e1vIIydtLDmemPDVGFPQK82jjbjM7wjO4LnoDjjg9nxJ1aURoaIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqd1m0xPfhMSPeeFXkIs0dCDFUiL7D61guqHw2Uo3fY=;
 b=MuxKU2h/VyIKs4xvCrMrmpyPDQyod5FVockw3NZRYJyD5DC6WIBxI/jFvIgNzmZq+iJAcUDZPxlJmQpUCo70fNFGo5vXrBIaDOjYvVkMJy+8cn6TjGMDpd/Vi/rzDi+zkACVDVWnSQiB9zMZ6j8YCrDG52q7HAvLLHFtQFlHSc8nEy+ZvNlVZrEkVoKl3dW+cehFOGHm3e0cu5fnSZDvudOxNM8OIXLsnwQSGfS8B2lEuiK/Tc5MT3WgO9UIWCq5PyKTBBMNia67IfcaEPdVQYsDMEwWSDZFwJfeMh8fNVC71Cit85DzsfiJKcTDBFpCo6nvhoiVsonwSttkclxNVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7754.namprd11.prod.outlook.com (2603:10b6:208:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.8; Fri, 8 Mar
 2024 04:06:31 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 04:06:31 +0000
Message-ID: <ddc5e199-ef8c-4ce9-8fb0-4f6227fded2d@intel.com>
Date: Fri, 8 Mar 2024 12:06:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v3 1/3] KVM: setup empty irq routing when create vm
To: Yi Wang <up2wing@gmail.com>
References: <20240229065313.1871095-1-foxywang@tencent.com>
 <20240229065313.1871095-2-foxywang@tencent.com>
Content-Language: en-US
CC: "seanjc@google.com" <seanjc@google.com>, "atishp@atishpatra.org"
	<atishp@atishpatra.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "foxywang@tencent.com" <foxywang@tencent.com>,
	"bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org"
	<maz@kernel.org>, "anup@brainfault.org" <anup@brainfault.org>,
	"frankja@linux.ibm.com" <frankja@linux.ibm.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240229065313.1871095-2-foxywang@tencent.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0044.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::13)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 255f8006-930d-4191-8448-08dc3f2522ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0kzywKIWdl5z3EQizfO277K3PHWevSezlKxjcKE5+84HG+DMLpU7uolij6rCwBTbBdw5xAGyfZkKRndv1rqUqdQAQnE1xlpmRm71cENhjEemR88wKZD4Ezk5DiJdpj30CSVGV+tNiDHkZaOS6vY6W7NWUe4m90uT1QySn/9PVVgEROz/RxbGohMbIQ1Fqug2nEwR/6hXOtC63LLQ7kDJkARbe1w2SnFQWHbb3URYQH649e7mpDOEsDKGGgzOkkwzZdbC19TMKZOfwZkmwH7tzK0YWjgsctGxsZjWF/as1gJpdYlzlPzGp6WiT3cFl5IjHU5I9T8asIL43zFcWVfle9PU3+0Jk30XNONXQYwbWHCUPNiWeOUvlo77rQOEn/ijY4/MQEZypGLWUlD9gKeYqSnZiu3i9Sf2SrItKcfTfSePe8hwfUVzYPigQyE0UMBpxQUOIaD3Map6WC5cAUlSFZNNRD3RttDktYOjpnKo6zK0pWEnsCciOR79F2PlHlcMIZqU9jMJtvAinAIrzfS8oSuTCzrMTXktNNJjUoCUPtYNZLCuMkHl3aLA4psO3dzyOqYZRIbarQP3Kl0XAyF7UYUhG8ksQrW1PfnlhR6s2oXidbkOaFig0DzAbqGFtdmmB7H1u/415JH0LWo6/CwJ1zFuvgTYWJC3ghrtWTGHlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkZZa2pUS2xHZ0JOaW5aQ2ZyL1ZSS1BWQTZpVWxlUGFaOFk0MjcwZVQ0MTVU?=
 =?utf-8?B?Zmc4SHY1M0FIYUN0VGl6c2kzTUFlOWszUTFaT0x0TmxHaHVpdjVsWEhRRlIw?=
 =?utf-8?B?TG1FTmhFUnJpeDlNc0U3VXA0WVVZUFdzbkdHV2hTUHJ6cXg2UHJDWm4yNEpl?=
 =?utf-8?B?Rlh3WTROMnIzSmJUSS9wMHRpQ3dVVFV0NmxVRjhtZmIxK0xvQ0NxeGM2aUEy?=
 =?utf-8?B?Ykxrc1R3UTZZM0Z3SnBBS2YxQy8rdzNVZ2Q1UEVvbG1DY2xmb1plSmR5eXNh?=
 =?utf-8?B?U1pvZlZLc0FtSlhHSUFHZXFIUVQ5dDlVMUhYS24vWDNiZTZya0VNVTE3bGIx?=
 =?utf-8?B?Q2FReHNpYVVHWjlUZFpnbnMyUnJBaUYzS2YyVklBTkxGTG16ZitZalhwVUQ0?=
 =?utf-8?B?V3UyRGlSRUpFRVNGeEs5RVdGRFpMSGFVTjVMS3llN1ZuYnMxRVY0RGYyNVhz?=
 =?utf-8?B?dlRqNGxVRXkzWDNCSU5NODhlS1kyYkRJZmp0MEgyTVU1ampnUkNKT0pGSk1s?=
 =?utf-8?B?SU1Qa29CU2syYmNNQU9pcHh4ZVAvTnFEQkQyOGVvQzBFem11M1hob1pPUkhx?=
 =?utf-8?B?cS9kd2hVZnhTSnkzdFFVcHJlNVVPa2NLZHdzZHBVQkFvQ3IzZmtMVHc3amJU?=
 =?utf-8?B?c3B2SVkyNkoreHkzZHdFUGdERFpVUE5vUjZ0N0NrSUFRUzBxS0UwT0JIcWdF?=
 =?utf-8?B?eGgrdzc5ZVN1WjVXUTBvSzBBd3VhZUlqdXdRK2k0akRQMnNlZGtFTkJKMG1y?=
 =?utf-8?B?UWcwSzREcE9KZERyWVBhRXBCMlM2VjlaZHNiRktvMjZzK1dOVnpDWmhULyt3?=
 =?utf-8?B?ZVZreWtjVDJ2MzdWY05nQi93cytLK21UZ2cxRTdNc1JHNzl0Y05JcHBFZHJZ?=
 =?utf-8?B?SGtpamZvMzliSDFCTWZqdFIxVGZiNFdLVGVRTVJRVGhSV3d5SzVWNzVURm1j?=
 =?utf-8?B?QXc5Y3JDR0JydUNQU2R0dlBZMXZuMXQxSFMwTjNIWXlXOVJjdHp6di82Ulp6?=
 =?utf-8?B?aVpjV2Qxa2pxZmhoS09Ubzg2L2xuWmRJMVhMc25KVGVHNnBYam9lNVJTT1pK?=
 =?utf-8?B?RUhJaHZYUGVReGJKUDlUOEVUSk1WU09VLzdtOERBVjdIaHVoTXRISW5XM2JQ?=
 =?utf-8?B?Y2s4bkxiQzBiQjBYZ2ZYa2huSXZHT1FkMlBwbXQvRGt4WDlGTHR6OW9FZlhZ?=
 =?utf-8?B?cTN6dTgxcDRLelpaUUgvcG1WUENDZTh1MTdmdzIvVVByenlSVmtLSTllaFNB?=
 =?utf-8?B?VEUwRHkrbjhINFZwVGh4ZGZiZlNLbTA3ejBJN05tZGErMTdDbWkxSmFMdHZ0?=
 =?utf-8?B?YXVzRHNxL1gydHN1eXpSeHh3bDVvdjBhVnZIVTdXdFB0REpIZGVmZkVhSFRt?=
 =?utf-8?B?cGNVbEtpdGE2c1JwVUVISklPbm5wVjFackViaFZ1aFZaNDhnQkFWVzh6N2Zs?=
 =?utf-8?B?NG9KUWx6Z2tWS0lzb283TnU5ZjlpZDlQaHhzeWYzMVV2Z3FTQnU0V2MxU2Vz?=
 =?utf-8?B?TmRKV0ppM2NOYXp0K1ZQelhUQVJTNlFLQ083NUVCQTh0RWVnTDd4RUZwcFBa?=
 =?utf-8?B?OW5zckVIazkzQ1J2aG00OTQ5alB2U1p2M2RLd2x0K1ltRGViS3p1ZGY1RmFj?=
 =?utf-8?B?anVSNlZyUHJmUlZWMnM4cFNoV1pFbG5UWkJKaXJwU0RBVkJpUE1Daml6MHQ1?=
 =?utf-8?B?WW5MNVVqcUFqb3ZIbGZvYUZLWk9QSFZpMnREWjJRU2JxNGhnYzdoT0pxUmI5?=
 =?utf-8?B?UjNuWFMxamw0dTBNT3lvMW9vZG5iRThWRkRBQmJlcWR4eGhlM0k3aVo2TjdS?=
 =?utf-8?B?cW9YbEdKREh0T0VXVU1uMlBYMDE5VXdaYlpQNDZqMUNDWWJ3K29vN0NaV1pG?=
 =?utf-8?B?TzVVZlkxR1dhaWwwQ053T1Y0NlFBY001bHN1cUpPRVVtSWtsU3ljdnJoekJH?=
 =?utf-8?B?czV1cFlMb1RmeUZIZ2gza0NZTEgxdE9UZmN5QzFwcEptaWJ6YzhLejZTTGZN?=
 =?utf-8?B?NDVNTmttOGJZNGtlcjhDcVhnSnluT3pYc205MHFpKzNHSmdNU1M3UXlIM2xU?=
 =?utf-8?B?R21Fc29NS2lqREVWVnBNYm5qZi9lY1BSVWE2OWpDbUJLRHdxL2RMK3BCREFK?=
 =?utf-8?B?dXY2a3MwdGlldzMva3N2b29Ta1Z6UjFGRUUxYmM0WGFtVXNscU15RTdLQmgx?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 255f8006-930d-4191-8448-08dc3f2522ea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 04:06:31.5430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGFI1kyNieOVqVP47bG7vcFJGZxHkQiMstLWDLjetNwm+j4ePXoSbmISCdi8TxO/UeiJ7v7QdlUxkkD+w9DcLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7754
X-OriginatorOrg: intel.com

On 2/29/2024 2:53 PM, Yi Wang wrote:
> From: Yi Wang <foxywang@tencent.com>
>
> Add a new function to setup empty irq routing in kvm path, which
> can be invoded in non-architecture-specific functions. The difference
> compared to the kvm_setup_empty_irq_routing() is this function just
> alloc the empty irq routing and does not need synchronize srcu, as
> we will call it in kvm_create_vm().
>
> Using the new adding function, we can setup empty irq routing when
> kvm_create_vm(), so that x86 and s390 no longer need to set
> empty/dummy irq routing when creating an IRQCHIP 'cause it avoid
> an synchronize_srcu.
>
> Signed-off-by: Yi Wang <foxywang@tencent.com>
> ---
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/irqchip.c       | 19 +++++++++++++++++++
>   virt/kvm/kvm_main.c      |  4 ++++
>   3 files changed, 24 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4944136efaa2..e91525c0a4ea 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2000,6 +2000,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   			const struct kvm_irq_routing_entry *entries,
>   			unsigned nr,
>   			unsigned flags);
> +int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm);
>   int kvm_set_routing_entry(struct kvm *kvm,
>   			  struct kvm_kernel_irq_routing_entry *e,
>   			  const struct kvm_irq_routing_entry *ue);
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 1e567d1f6d3d..90fc43bd0fe4 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -237,3 +237,22 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   
>   	return r;
>   }
> +
> +int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm)
> +{
> +	struct kvm_irq_routing_table *new;
> +	u32 i, j;
> +
> +	new = kzalloc(struct_size(new, map, 1), GFP_KERNEL_ACCOUNT);
> +	if (!new)
> +		return -ENOMEM;
> +
> +	new->nr_rt_entries = 1;
> +	for (i = 0; i < KVM_NR_IRQCHIPS; i++)
> +		for (j = 0; j < KVM_IRQCHIP_NUM_PINS; j++)
> +			new->chip[i][j] = -1;

Maybe it looks nicer by:
size = sizeof(int) * KVM_NR_IRQCHIPS *KVM_IRQCHIP_NUM_PINS;
memset(new->chip, -1, size);

> +
> +	RCU_INIT_POINTER(kvm->irq_routing, new);
> +
> +	return 0;
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7db96875ac46..db1b13fc0502 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1242,6 +1242,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   	if (r)
>   		goto out_err;
>   
> +	r = kvm_setup_empty_irq_routing_lockless(kvm);
> +	if (r)
> +		goto out_err;
> +
>   	mutex_lock(&kvm_lock);
>   	list_add(&kvm->vm_list, &vm_list);
>   	mutex_unlock(&kvm_lock);


