Return-Path: <kvm+bounces-12462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9922988648E
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 02:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B75FC1C216F8
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 01:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A31B1392;
	Fri, 22 Mar 2024 01:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h2VF33sk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4484376;
	Fri, 22 Mar 2024 01:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711069602; cv=fail; b=pxRVzD4Jh8+O7qjpEgYQzjeJJWyCBouF0wgMYMStVZbrAk+XGNkUwVJaA9RGjofG1Cl2ponYsED4EdeGpj0Tm7EHcOTNwtEMC+nhjbHsrBk+fkmR6s/KxIa4LaeogRWR3xEnOyK6Y9WDEObmZdWutdvSLCmRlFVUkpoKAEdO+3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711069602; c=relaxed/simple;
	bh=avH7eunXOHU8ZMgGoi0UC9ruDlko/M8EZ84xrNl3hSo=;
	h=Message-ID:Date:Subject:References:From:To:CC:In-Reply-To:
	 Content-Type:MIME-Version; b=mi6tqFkptMFe57TCOG8MobcyY7Lxxx2FnTxbuQ4lbG/NQJ0y6kZ3/wKlyv/Gde9FBURJZeh4bm2IHe8TtfMan52ea6ZhjfPKQzx/Fm6P+OASAuJEqL9haTUPv1EjkURc0z2I2wenYvRjCzL/0SHV9uDNi0Frf740UIVKm4esUjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h2VF33sk; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711069597; x=1742605597;
  h=message-id:date:subject:references:from:to:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=avH7eunXOHU8ZMgGoi0UC9ruDlko/M8EZ84xrNl3hSo=;
  b=h2VF33skT2lwy5YDhUHyFy1d29rR46yxzlCQwEDeGARzaySpQ55ofQBv
   /2zkAEjLk4gEBNWkHb+/Fe48g+HReQMmJ3U7mX4EKJC5YLKs4vwZNPfju
   xnU67nukXLE2poRKiecq8f0TnMnsxWKDuEtwqxv2I4AxQqJHZd+B3m0qc
   u7dytbEIn7WxAY9t1NHo/7J6C8rJKFG8p8GhFhFmQ44myIgz3oZrVyX1U
   etnJ1k2Qh4y79I0K+XlR+s9jnmshzzxCkEGGNWZngd1ajzvJUNDIUNWKH
   D7HQqvu788rZFzhMCqZ+uaVSLxKMToxrMJX6Brg7BecQFQA/oMdIWjOro
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5966124"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="5966124"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 18:06:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="45712412"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 18:06:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 18:06:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 18:06:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 18:06:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/1P5SS9vsCgMJYmBL53c5kAatye2W5MdRdZwnzAWHDMZLK6mEVIrbm5wWJlRpoL2yh4+HJVUiZrmWqh6PLIyr3dLDEaXD9CP0oDrtreUTU3xZc0rtxpm2vFJMNCclMixaK2cknKnVToVbZgU85pHCkbMQGXA7woOcsqKjnHhK6NA5uft0sZ0Suwri/0RCQ1EbwubIzTaqkW3iVZpAWshijkv3CCCRUdsqmRPSIoHrakm6i+RNmwUKR/7nMBVK0GXPNQslZ5YyRU5U6OW6VaCuFlJzT9R3mO/U7hlbPiFuUoHUCzlrsmuRUeR3nbOjbCjEffGeoQK9gixER/jrSz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVt67o6Yx96ibVGmHQ0cnP1BXo8h7H5mamI9fwj0MsU=;
 b=hnWTGLET4YjpYBuVH9/B8LrXT+QogmwbKpNgjWAbSvE4i8IMgG9UZXwylJum/VrfBk+O84gUgFocOx0asK8878PL4ZEen1rkr4xv9hMXtuxqKdCrKUOfSyt7Z4HJWmNBGvcq5TuB7fckTNbv0V+tpRMbx92z55GBC6T1f6CT05XJ2z9gMmgXsD42e8vAT9KRgUbTjx0JsnbnE7s742+CR8cRpx2itacQPGbNbxSw/4FWdaBQE9Z0MoF3mTqDPR8p53xqMI0J1h00k2vD82+1fw85E+i088rZSrS7P852+xKnF6oLpqIiecAN0v4K42fA8VLFFz364IgxrwypWIPH9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB6987.namprd11.prod.outlook.com (2603:10b6:930:55::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Fri, 22 Mar
 2024 01:06:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Fri, 22 Mar 2024
 01:06:29 +0000
Message-ID: <c0e49a87-410e-4685-a677-069bc3abef7c@intel.com>
Date: Fri, 22 Mar 2024 14:06:19 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson <sean.j.christopherson@intel.com>
In-Reply-To: <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:303:b6::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY8PR11MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 01064d81-ad19-4ea0-5365-08dc4a0c4e4a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: auWZZ/em4RGc6UHOFGbioeeftLb1uFCVGkN3f4iCAc+X/k6Ewbj3Mg54amMtpYLOw7jln+7yv5ikSBXWjqks662vklrSPnFQQ2u8dGQpZU8Pq2DnzGCS/3EN/ic4CnKnoOE2CmF8V5Nkx5jq/1HD81hGymgyhS6YwGig2zwEP0cPASuTqZ58ExkyiqNVjmukgGhO02ffreY9FiW2nP5kNk+Qz8P6LUVrOZMmP1Wdq+yBmH5k/VHnnwg80ieBROqdcmNIAmjKZJvj/wkPiTL4CInKxzHhwGpO0EMJyd/Yoe1wCFY217N5/0CAVTqjsqlo9sk3CxOlY6xwGsfC6T39jct92/6OBKL/gb0MWgDtfvpZV+8vWOajbgqoBpDwHGzZAamytHj/PgOV8WARgOObdGQ/Fv62zurRlgEtEOJAsEwvRy3AyTA469Ppg0rm4fPSNxwTmyn5BvkT7jNNsjO//8F6vLDE14ojSVAneNHKhMskpn+Cmz/KohF2dUJ2gk+KTbq+LCq02DX6KA7wq0rkDa4Kjd/3mmJtasCyVE/Lv1kldMNv1GdI44AHWvRBcztrHqoDWZKVv8olK4zIgi+UMT8HSFWKATpfcFa+yHdZipoD3WhgpvFXLIiWDbaPeCXngxaCqlljdJso4PBQi9Xp+fBL2h/naM6oaSGahXuCDBI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjk4a2RrK2xYMjhmZ0JUWGtueTVXQlpOaVVOWjl2ODRXSHFkYXE2Y3V2NStV?=
 =?utf-8?B?c1NCd0VtZEVuaGt2OXJ5U1hrc0s4ODd2NUdwU1pGVVZTWlVIM3NJSXMxeWdL?=
 =?utf-8?B?NkplTFRMMEdIZGJBUWtFWnNWb0l5bGl0T3VqR0NzWWFlZVdEdnloRktWRHhP?=
 =?utf-8?B?bG1HOU9OSElScDFXak1YZmhCeDJUdG90R0J1VXZxY1BWQnI2YmRtTzZyUUJo?=
 =?utf-8?B?WmVSb0dvUThkMGNlZU1US3dkVFc3VmhEQzhXWUhCbmVLREZWTS9HcG9OWU5z?=
 =?utf-8?B?R1ZiU0hQZXRUQVQxTW9ucjNLV3pnT1k0L0E2L0ovYXZBWUtPUGVseEVuYnd1?=
 =?utf-8?B?RHVCTzYvR3BTRHhnTlZoT2tyaG1oUjUyU0dSSGc5aUdCemFJN1Z4U05BMFdj?=
 =?utf-8?B?RUF3YXpvRXY4ZDQxZnFpVm00UklVanYzTjJCTi8vb3JidVU3M3ZTVGYyL3A5?=
 =?utf-8?B?aDlnUFVKQm9OU3IzbEwyQS96OVlKdDM0UU9aUFIyVDIvSzF1MUFpRjUyQXNH?=
 =?utf-8?B?aHVFY3R4RXJwd2dLZ3dzOTF2aVBjY3M1ZjNxU1EyQVM4U1Q0YStmdjgxVVVa?=
 =?utf-8?B?blRlVTlGUy8wZmU1Ym1UZTR3SGlyOFBUVnJLaG9xcm4wUW9NdjU2WHozUEdD?=
 =?utf-8?B?T29ETTBFOS95ZFlramRDQlFGZ2lFaEY2S3EybmF4NlBRSThtZStIQVRpSnAz?=
 =?utf-8?B?STVXRW1BVGhXallwZDJkWGpNdUFvN2NWc1kwUDJvSnkrcUFMSlJjcVpqWGxk?=
 =?utf-8?B?NXQ4ZXNzUE95ME1HL2tvSExtODZqaDYxMW9SV0g3K2l2R2NRdTR2LzhzN0F4?=
 =?utf-8?B?TFRQZTlXaGYwaEFtTEpSczI5cGQweStBT2xXV21oNEdOTUlxbkxVSWVzaTNm?=
 =?utf-8?B?M2lsdkt2UWNDVm9DYVJncnY1aVAxM0NKY1ZUQzl4cFp6MXljVVRXRXppSUFK?=
 =?utf-8?B?YWh6UWFqS29UVUZXT3VJR2RoTVJScW5DNnRwV2FvTDI3VXViR1V4R1YwUGR1?=
 =?utf-8?B?cncvdnBKQ21vVFFZQlBHSGFISkdkLzlTSUtBY3p0M0FXQlUweVkrUUJMY2Z3?=
 =?utf-8?B?ZWhjNTVjTmVvZDVNdFlxOTRuNk1CTDgweU11V210TE5uNndDa1N5bWQxamhV?=
 =?utf-8?B?NFBicEkvMEdHUGI0YVJqSVV5c2FBb0pMQXVranN3T2ZuS2NWNzJFc0hpRW8x?=
 =?utf-8?B?aVBHb25kMHlDc2owQUU3UEFhNXA2enQ3NXYrUGl4OEdzR00zaU9nVTRSNzVB?=
 =?utf-8?B?YlF3RnNXdDZaQnNJQmpyM29qMG9vYlFoTkVLUitFd3V3M0w0dWtYNmd4ZTRU?=
 =?utf-8?B?bkVxUFh6bS9DTUFmWDJPU2UrYnAwNnVYa0ZnRE84ZUhNZlUxekZjQmxkR3pS?=
 =?utf-8?B?UFd1dmRnZFQxb0JXejR1a3psaHh6OTErcGdWSFppOHk4WWpNSFhuc1B1L3py?=
 =?utf-8?B?S3lGTUQrOEtmQ01xdm9zOThWaDNpNFdVYzBRVFQ0YkpZeCtYVTdDVGRmM09o?=
 =?utf-8?B?c3Y1TnRPbGNKckFZeXBmbVVDV0ozN2dhYUNIbi9RN2YzN0VBY1BoT3JwWm84?=
 =?utf-8?B?Yzgzbnoycy81QjBMRmNhNUZiZFprM2h6OTRzeWNQVE9KSTJ0cEorYm1FWmdn?=
 =?utf-8?B?bzBBeWhtTUZaNjlhSFlLYnRGK1E5MzZsRmFINStNRFBqVVI3aGQ2ZllFb3hv?=
 =?utf-8?B?dGhIaEhyQUpyR2tYWkRsMEFVUGprM21jTTMzdlBUVlFOV0VrR1pFMHhYdlpM?=
 =?utf-8?B?RWduUDJJNnNzb3ZjR3JRYkhCYkxBSWkvWVQrZnRDcFY5REthSkVNcWxlVXlx?=
 =?utf-8?B?Tk82UUNNdWRUU0ovbmkrMFFBU1R3d3V5VkZlMGNYbHZ5TE4wdDlkMm84UW00?=
 =?utf-8?B?Y3MreExLRzNINkxBVDZSWk9qczBscEs0MFlpVVJHUGpOb0dkNnRKUENoeHc2?=
 =?utf-8?B?WmZsaXdRL05nZ2lDZzRLYkxjMVFDYjB2Yk9oY3VVS09IWThnL2V3QzVzUGNx?=
 =?utf-8?B?dWswcWZJbXVYMThZSjY3bjk2VjRuZVRnbjBHSHUzMmpJWituYzh2bndrb09P?=
 =?utf-8?B?dlVxMjVtOFk0and5OWhaRE9qaTBxRHFESUZ4U1A2TWs2M3hnb1lHS3pURTA2?=
 =?utf-8?Q?qnN0bF2Fh13wB3ipT951Gb46s?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01064d81-ad19-4ea0-5365-08dc4a0c4e4a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2024 01:06:29.4378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azHaD+lK+IVAIhwB1E1lDhRO22mcWoI7a/yCbvjzsqBY7PztTLHZAjG9GDFQl2+VeZuciH6tEf1P4D1EVQDXEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6987
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> TDX private Host Key ID (HKID) to the TDX guest for memory encryption and

Here we are at patch 38, and I don't think you still need to fully spell 
"Host KeyID (HKID)" anymore.

Just say: Assign one TDX private KeyID ...

> allocate extra pages for the TDX guest. On destruction, free allocated
> pages, and HKID.

Could we put more information here?

For instance, here should be a wonderful place to explain what are TDR, 
TDCS, etc??

And briefly describe the sequence of creating the TD?

Roughly checking the code, you have implemented many things including 
MNG.KEY.CONFIG staff.  It's worth to add some text here to give reviewer 
a rough idea what's going on here.

> 
> Before tearing down private page tables, TDX requires some resources of the
> guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).  Add
> mmu notifier release callback before tearing down private page tables for
> it. >
> Add vm_free() of kvm_x86_ops hook at the end of kvm_arch_destroy_vm()
> because some per-VM TDX resources, e.g. TDR, need to be freed after other
> TDX resources, e.g. HKID, were freed.

I think we should split the "adding callbacks' part out, given you have ...

	9 files changed, 520 insertions(+), 8 deletions(-)

... in this patch.

IMHO, >500 LOC change normally means there are too many things in this 
patch, thus hard to review, and we should split.

I think perhaps we can split this big patch to smaller pieces based on 
the steps, like we did for the init_tdx_module() function in the TDX 
host patchset??

(But I would like to hear from others too.)

> 
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Sean's tag doesn't make sense anymore.

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
[...]

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c45252ed2ffd..2becc86c71b2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6866,6 +6866,13 @@ static void kvm_mmu_zap_all(struct kvm *kvm)
>   
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
> +	/*
> +	 * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
> +	 * tearing down private page tables, TDX requires some TD resources to
> +	 * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
> +	 * kvm_x86_flush_shadow_all_private() for this.
> +	 */
> +	static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
>   	kvm_mmu_zap_all(kvm);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index e8a1a7533eea..437c6d5e802e 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -62,11 +62,31 @@ static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   static int vt_vm_init(struct kvm *kvm)
>   {
>   	if (is_td(kvm))
> -		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> +		return tdx_vm_init(kvm);
>   
>   	return vmx_vm_init(kvm);
>   }
>   
> +static void vt_flush_shadow_all_private(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		tdx_mmu_release_hkid(kvm);

Add a comment to explain please.

> +}
> +
> +static void vt_vm_destroy(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return;

Please add a comment to explain why we don't do anything here, but have 
to delay to vt_vm_free().

> +
> +	vmx_vm_destroy(kvm);
> +}
> +
> +static void vt_vm_free(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		tdx_vm_free(kvm);
> +} > +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -101,7 +121,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vm_size = sizeof(struct kvm_vmx),
>   	.vm_enable_cap = vt_vm_enable_cap,
>   	.vm_init = vt_vm_init,
> -	.vm_destroy = vmx_vm_destroy,
> +	.flush_shadow_all_private = vt_flush_shadow_all_private,
> +	.vm_destroy = vt_vm_destroy,
> +	.vm_free = vt_vm_free,
>   
>   	.vcpu_precreate = vmx_vcpu_precreate,
>   	.vcpu_create = vmx_vcpu_create,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ee015f3ce2c9..1cf2b15da257 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -5,10 +5,11 @@
>   
>   #include "capabilities.h"
>   #include "x86_ops.h"
> -#include "x86.h"
>   #include "mmu.h"
>   #include "tdx_arch.h"
>   #include "tdx.h"
> +#include "tdx_ops.h"
> +#include "x86.h"
>   
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -22,7 +23,7 @@
>   /* TDX KeyID pool */
>   static DEFINE_IDA(tdx_guest_keyid_pool);
>   
> -static int __used tdx_guest_keyid_alloc(void)
> +static int tdx_guest_keyid_alloc(void)
>   {
>   	if (WARN_ON_ONCE(!tdx_guest_keyid_start || !tdx_nr_guest_keyids))
>   		return -EINVAL;
> @@ -32,7 +33,7 @@ static int __used tdx_guest_keyid_alloc(void)
>   			       GFP_KERNEL);
>   }
>   
> -static void __used tdx_guest_keyid_free(int keyid)
> +static void tdx_guest_keyid_free(int keyid)
>   {
>   	if (WARN_ON_ONCE(keyid < tdx_guest_keyid_start ||
>   			 keyid > tdx_guest_keyid_start + tdx_nr_guest_keyids - 1))
> @@ -48,6 +49,8 @@ struct tdx_info {
>   	u64 xfam_fixed0;
>   	u64 xfam_fixed1;
>   
> +	u8 nr_tdcs_pages;
> +
>   	u16 num_cpuid_config;
>   	/* This must the last member. */
>   	DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
> @@ -85,6 +88,282 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   	return r;
>   }
>   
> +/*
> + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a global lock
> + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is returned without
> + * spinning or waiting due to a constraint on execution time.  It's caller's
> + * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use this mutex
> + * to avoid race in TDX module because the kernel knows better about scheduling.
> + */

/*
  * Some SEAMCALLs acquire TDX module globlly.  They fail with
  * TDX_OPERAND_BUSY if fail to acquire.  Use a global mutex to
  * serialize these SEAMCALLs.
  */
> +static DEFINE_MUTEX(tdx_lock);
> +static struct mutex *tdx_mng_key_config_lock;
> +
> +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> +{
> +	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> +}
> +
> +static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->tdr_pa;
> +}
> +
> +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> +{
> +	tdx_guest_keyid_free(kvm_tdx->hkid);
> +	kvm_tdx->hkid = -1;
> +}
> +
> +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->hkid > 0;
> +}

Hmm...

"Allocating a TDX private KeyID" seems to be one step of creating the 
TDX guest.  Perhaps we should split this patch based on the steps of 
creating TD.

> +
> +static void tdx_clear_page(unsigned long page_pa)
> +{
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +	void *page = __va(page_pa);
> +	unsigned long i;
> +
> +	/*
> +	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
> +	 * required to clear/write the page with new keyid to prevent integrity
> +	 * error when read on the page with new keyid.
> +	 *
> +	 * clflush doesn't flush cache with HKID set.  

I don't understand this "clflush".

(Firstly, I think it's better to use TDX private KeyID or TDX KeyID 
instead of HKID, which can be MKTME KeyID really.)

How is "clflush doesn't flush cache with HKID set" relevant here??

What you really want is "all caches associated with the given page must 
have been flushed before tdx_clear_page()".

You can add as a function comment for tdx_clear_page(), but certainly 
not here.

The cache line could be
> +	 * poisoned (even without MKTME-i), clear the poison bit. > +	 */

Is below better?

	/*
	 * The page could have been poisoned.  MOVDIR64B also clears
	 * the poison bit so the kernel can safely use the page again.
	 */


> +	for (i = 0; i < PAGE_SIZE; i += 64)
> +		movdir64b(page + i, zero_page);
> +	/*
> +	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> +	 * from seeing potentially poisoned cache.
> +	 */
> +	__mb();
> +}
> +
> +static int __tdx_reclaim_page(hpa_t pa)
> +{
> +	struct tdx_module_args out;
> +	u64 err;
> +
> +	do {
> +		err = tdh_phymem_page_reclaim(pa, &out);
> +		/*
> +		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
> +		 * state.  i.e. destructing TD.

Does this mean __tdx_reclaim_page() can only be used when destroying the TD?

Pleas add this to the function comment of __tdx_reclaim_page().

> +		 * TDH.PHYMEM.PAGE.RECLAIM requires TDR and target page.
> +		 * Because we're destructing TD, it's rare to contend with TDR.
> +		 */

It's rare to contend, so what?

If you want to justify the loop, and the "unlikely()" used in the loop, 
then put this part right before the 'do { } while ()' loop, where your 
intention applies, and explicitly call out.

And in general I think it's better to add a 'cond_resched()' for such 
loop because SEAMCALL is time-costy.  If your comment is intended for 
not adding 'cond_resched()', please also call out.

> +	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX) ||
> +			  err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_TDR)));
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tdx_reclaim_page(hpa_t pa)
> +{
> +	int r;
> +
> +	r = __tdx_reclaim_page(pa);
> +	if (!r)
> +		tdx_clear_page(pa);
> +	return r;
> +}
> +
> +static void tdx_reclaim_control_page(unsigned long td_page_pa)
> +{
> +	WARN_ON_ONCE(!td_page_pa);
> +
> +	/*
> +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> +	 * assigned to the TD.  Here the cache associated to the TD
> +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> +	 * cache doesn't need to be flushed again.
> +	 */
> +	if (tdx_reclaim_page(td_page_pa))
> +		/*
> +		 * Leak the page on failure:
> +		 * tdx_reclaim_page() returns an error if and only if there's an
> +		 * unexpected, fatal error, e.g. a SEAMCALL with bad params,
> +		 * incorrect concurrency in KVM, a TDX Module bug, etc.
> +		 * Retrying at a later point is highly unlikely to be
> +		 * successful.
> +		 * No log here as tdx_reclaim_page() already did.
> +		 */
> +		return;

Use empty lines to make text more breathable between paragraphs.

> +	free_page((unsigned long)__va(td_page_pa));
> +}
> +
> +static void tdx_do_tdh_phymem_cache_wb(void *unused)
> +{
> +	u64 err = 0;
> +
> +	do {
> +		err = tdh_phymem_cache_wb(!!err);
> +	} while (err == TDX_INTERRUPTED_RESUMABLE);
> +
> +	/* Other thread may have done for us. */
> +	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
> +		err = TDX_SUCCESS;

Empty line.

> +	if (WARN_ON_ONCE(err))
> +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> +}

[snip]

I am stopping here, because I need to take a break.

Again I think we should split this patch, there are just too many things 
to review here.

