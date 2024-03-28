Return-Path: <kvm+bounces-12930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3576F88F4E5
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60F0CB2332C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28C023773;
	Thu, 28 Mar 2024 01:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PkAsy/bX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DE81BDEB;
	Thu, 28 Mar 2024 01:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711590615; cv=fail; b=srb3G1xiCugFT0T7YPIo8wJ7kEun8jiqyUfurh2ZQVmeHQEqAwllpMx55uRzbzF7S8LmV4r3nyVXsxvYdZ8flUSmuHpnbpQU86AYzbtsIuAVrJ+Dec6vXUZ+TJPCGb5ioZ9l3dOJ/ZRE1YdeXaoFzxwY46MbNpvaIfdEJAieTqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711590615; c=relaxed/simple;
	bh=tkqhdNnr/C64vMJJZHg488c0ffuMANNjcondQGMNSeA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hVmXICx76dS/VtoEvHZbj6hoq6Q/w99iV9yXvDQNj8Qo2zJwbqiK8CtbBkPh4FM/UNE3NJaStCftWbe9qpXC3KI5G4lN01IhrIGVFAAEnVjEp7ORepa6tpc7188hxtfqDEUM0X4EZeWn+991rkG5JgsQpMMNX5RfqytxVtb4Vwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PkAsy/bX; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711590613; x=1743126613;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tkqhdNnr/C64vMJJZHg488c0ffuMANNjcondQGMNSeA=;
  b=PkAsy/bX2suTHRUcDwqxrJErCFPtUlHWmFmsWMyAmfJbEojkGFrQ0Q45
   6+j3voU13wbgb//Ytzf0XN23zDwFfy4d5MIIpNNeCyQYGQB8QDlyjf8+w
   /VkomOLEQ2LA8CFfcxHsVTB5WZxCcDOWtt+lPqbVeEp2N+lPO4tRoUeOm
   TvtJsFkohDTLyoQxV9yhPCMm1nrQ8o+j1IKpabLd7yqPDiy4vRkBF8T6Q
   BEZiawZa3hTdg/9t1tbDZw/Zri/smrbZjgR8hEzKEVVunttChNlDoJ0OG
   DBCCjxkqcfrxADiOFdg0thrf0tQeCFqINN0ffs5evrJaPPBay7LKM0kOp
   A==;
X-CSE-ConnectionGUID: sZOVWFsWRCyuSCFexfZYLw==
X-CSE-MsgGUID: VGcFE83ZToe4Bu+iBoYC8A==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17279426"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="17279426"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:50:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16510869"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 18:50:11 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 18:50:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 18:50:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 18:50:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AB9XH/g2fKnzAYOPLvmL/wo5q0Vz9M0hWBAo6cnRH3SUS1dIZrpETU04LjrujmxK0wB/lgiIJL1HgM4nioc7GwWbU3Do1FRGbd2HV01BXhNfTgG8gJzxTdfZXz0VnP5dxGLIAKtRy5Z/cF/x+2A+4Mm0GpKYTRhUG0kHG3SbC5PBm1obq945YF0T4iWp7QXD5+mFVLJsbowMW8t70Adlp20YnIuBqVElM4tk1czFwAYyeArAM1Dq8njbQaUuNhgdKm+qnt6/gYB7dAagDqDfCtAdCy7OdsgilMqahmclOxVtrJg8OhD9gWwJvYFutpH5EBv2Z2xyAvp4FEkaeI1pdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/Vj6+9sIqk/G6WdC1dY+/u1TQCk9zGby9CILJX+Bfk=;
 b=nIpcNwEJ4/19vFX981Sg4Kw7NmSmc8J0GVbeYPAx9VKC+2W4CMeW4uAH+3Hz7HB66VDX8Wp/o5IuZJkZTaeCUjCvknRdxS4em6OVtnDOZSMxjMgazs7tVAIsK41IrncH07SEN924Ibc8/2E17R4ZfCyUw3Jqv5UywFbwZVALpMKfzCiZfyF1V7xDpDsG0OfqLN1W3muzIG7JffDgR+iqJkM3WkOoO9apTrqNInL8eKy0C4HhiEoohxRx82tnyJWtbxTpqo93vlNOP1Jb4CedJ6X6ygvsufaKugesGwxeWH3UiXMbEMmNkTXEOb8SLxXmS2GlYeIhdR4EdMZUHTiqEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5032.namprd11.prod.outlook.com (2603:10b6:510:3a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 01:50:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 01:50:07 +0000
Message-ID: <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>
Date: Thu, 28 Mar 2024 14:49:56 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
 <20240327225337.GF2444378@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240327225337.GF2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:303:2a::8) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB5032:EE_
X-MS-Office365-Filtering-Correlation-Id: 35b84e5d-6dcc-45b2-098b-08dc4ec96524
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: enoGdV3QCRI+hI4Xm35rPRYKdfls4FCsWP1zRwXfbeukXbVxbfqI5uhrWIdnlfV0lxhcDh6pmlYFQ/3JdzurLyBqS0MTB5Z4sunxTaXrA9QA/slS0LN2y/MA8upGqkWCP9quHTGWAMC05PhWrdN+99yNtpYFG7bfaC8DAe35op3DhY63Gl7cIXptxrxYZRg/3YgDdJJdRlS/tCfghYASwzSJ7o46/5Y4Ag8dBkyAr09nQvU4xp+zVKbdJ0SPO38TUd7XF4Vz1rU8RK2JvMht363/uO+gtBgo62m1JA9H2Nu4keli20/DEn6eO9qhmuC9QV9uE4iWoCTz9IhN2y0H8apQGGnT6YgJMRSo9QJumxFWM45aJPPifvdSHX/g+GM52bgGfeKZr2O+4amk87UJZLKe/Gvqdm/KVlQmjKlJqhcaExP8ZhJ9+pLFFw71kx54MVGQyUXlljXhzjSTl9JjuEATX3M6KYlmStHfV4m8Yt2+N5s8A3MwDpoqjmOYb68McbU36ABGemnPjuLB4JwJrIhsIhXiEvCJUpW5l7HEP6bAJpd7AFEA1aK3SckcNAuOI2c/BKpEpDozvmuJieqPJ7tLRLrmkLASBDjNvCKO4mM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDZKYStRZFAzU3YyU01qUmpkc3BTM3BkS2twZGV4SEhsQVBwYWI5MTc4RjdQ?=
 =?utf-8?B?RzNVN2FCQXd3V284MnB6NmJwSXNlY3ZzbFlBWW9tOWZNM2taKytaMGkzSGpN?=
 =?utf-8?B?d0Y2azdyQXlqRHY3L1k4emIrWFBtRm5nVnZlc3lwS1ZwMlpKRDdqUlFIUWUw?=
 =?utf-8?B?d2swQlNFUTd6dTB3MWpzalp1elJJODNhVzVxS3crR2M2VW84WnduWlhFaG5N?=
 =?utf-8?B?MDBtWjdqUXROOWhzd09VY1pLMyt2aU1yTDFhNVBWWVN2MXdRUnNLTW5qTEdY?=
 =?utf-8?B?S0FZbmRscDh3YnFkVlZyTjlFMks4VEtXS1FnOTNLUWc4U1U0bEo5QW11QSs2?=
 =?utf-8?B?RWpuRzltVVU3NmlVOGQvVExDdVZiTzcvelR4eE9DSjQ4SmpGWWtuMVBwSjM5?=
 =?utf-8?B?RFRpekozM0lpZzJxSG1EanBDTkFaWC9BQUU0UElNYUR6LzU5dDF0L25LSjNT?=
 =?utf-8?B?Nkl0dHNZUjNFT014NURjeFBrQ2Y0SVlreUhoaVVuajRva1Jsb2hCMTJqTWhF?=
 =?utf-8?B?Zm01UXpQVzlEY0hGMUNxdUhqUWFwbHZnYVMwa01aeGJLRWszeC9MZEJoQkZF?=
 =?utf-8?B?MjZaNnRkMUhOeFVQR1ZKQWhTVVU1QTkyejdoelViVmFoOXN2WkFnbWRxZXdo?=
 =?utf-8?B?SG00ellZWFdYTXVoZjc3QnFsMzlpUW1QL2dmSXF6Ly93RmZaUlBZMXZ0akZi?=
 =?utf-8?B?UDM1Yjk1WXVVaHUzWFRyc3VPSCs4L3BtUkh4MThiNUhTZGRDa2xTNVNIMlNL?=
 =?utf-8?B?WGhEMzBUWWJiOG1SbkZ5QUYrNzJZUGZWTFVuWWsyRndZMGVLOGM5STJyT3pE?=
 =?utf-8?B?b3ZsckY5c2NURFVMWnlSS0NzcmNRU2pZQ1JZK052WUhtVTJlUmNBODkxTXpH?=
 =?utf-8?B?QS9FZFQxS2t4Zm92V1ViZFA2OS9nT09IdC8xOHpXek02N2RQbjF0UjlqcXNF?=
 =?utf-8?B?bS9KdURXem5YZVJpNGZUTjIxTzFUWkticzdieFN6ZGpjVzdlN1JUaStWaVdI?=
 =?utf-8?B?Q3p1M2MrNDN4NjhXWHpCZDQvKytPdkdkSHJMRFdXTTFnMUhXaHY2WXpRMTNV?=
 =?utf-8?B?MzJZNU9GbGFLS1FwdXp6R21GODQ4MU91b1E4WUN4NWg4emN2UzNLK0pHTmda?=
 =?utf-8?B?eW9GRjYyS2xpbisyZkhpN3NjUnhsZEhlZnBlaVhWSXhZNWVrQzZZcWczSDZk?=
 =?utf-8?B?S2VEUTZVaXF1cUZaMzJFV0I5RkpjcEtSREdlWEFaSG5paGNOVWR5V09IUEU1?=
 =?utf-8?B?NUI0REZIUW9TSUJiTmxTVWJ2cy9Sd0dSb241TVNLWG9JZ2FuMXB4anF5bEM5?=
 =?utf-8?B?Tkl4YVNoR2lJRXQ3K1ZmTjBQb2ZneW1zTFhlL1ZqQzA2WjR2ZnlJaWh0ZXZD?=
 =?utf-8?B?K2lzMHk3Zm83MFNUR2RHVjR2SXg0bkpxN1FUTkJzOUtpR21GWEZ0VzhDSS9W?=
 =?utf-8?B?RDc5RnAwVXNUVVlCWlIvSUkxNURpREFSOVhhL2Nnc3NyWGkyY0d6MnJnUVlj?=
 =?utf-8?B?RWI5cEdaMzJUaVF5VkdGR2JZK01oRG1HdlNIZ0hmVjVZbjhnQ3FZczFOSjFt?=
 =?utf-8?B?Vyt5ejlMamFoSzFLNTk1MWRhdkM0TGVoZStIa0dBRExxeXZUeC9VQ0NuM3pp?=
 =?utf-8?B?eGRWbXdsSklLbVgvUHJxcXN0K1NXbGVwaUppL2NNM1RvVm9oK2E0d05PSEF2?=
 =?utf-8?B?Vys2b1FLL0pTaXppR2hoVXoyQVZuZnZhQW44WDVVU1hkQVZ2STRib0pJK2U0?=
 =?utf-8?B?QTE3SUd3dENxdWtMYzJPR2hlNk41dXRYay85OHNFaFducjQvM0V3OVZNTitG?=
 =?utf-8?B?VURYanVBZ3N3QmxZaTEzT3h0YnQzcVhHaXhFRmJBY3hTalZIUTA4WjRLQ1NU?=
 =?utf-8?B?cmwxQjVmQmZ4UVlZT3JIRjlWK0dQRmtZM01KWlNiSUVCa09vNisrK1FXSk5P?=
 =?utf-8?B?TVJLVkVvYzdzelhMckpMVzJpc0NuZWttWHo2QUp6bGNuaVZBdHJvTUNVL0NE?=
 =?utf-8?B?aXVLdVRDKzNoSGlqK1RZR2RjT0lKODI0TC8rRjF6Mkdvd2Z3Qk9pQ3FXTDM1?=
 =?utf-8?B?WVJiREQ4SHl4NU54YWMvNkpPY3ZJNTRTUGx4WDVuQkVhVEhrOGswK2EwTGRi?=
 =?utf-8?Q?QxPMttZ8FzzwfDYc7aNGJqkDF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b84e5d-6dcc-45b2-098b-08dc4ec96524
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 01:50:07.3841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgrp03ZH0sqeXR/AdFXw6SzxLx++vIev+LHYeJiWpXQ9PEN1lgMk4TEnoBdyrtcMMF/5hVmMCU/Tt0pB+6z+tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5032
X-OriginatorOrg: intel.com



On 28/03/2024 11:53 am, Isaku Yamahata wrote:
> On Tue, Mar 26, 2024 at 02:43:54PM +1300,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
>> ... continue the previous review ...
>>
>>> +
>>> +static void tdx_reclaim_control_page(unsigned long td_page_pa)
>>> +{
>>> +	WARN_ON_ONCE(!td_page_pa);
>>
>>  From the name 'td_page_pa' we cannot tell whether it is a control page, but
>> this function is only intended for control page AFAICT, so perhaps a more
>> specific name.
>>
>>> +
>>> +	/*
>>> +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
>>
>> "are" -> "is".
>>
>> Are you sure it is TDCX, but not TDCS?
>>
>> AFAICT TDCX is the control structure for 'vcpu', but here you are handling
>> the control structure for the VM.
> 
> TDCS, TDVPR, and TDCX.  Will update the comment.

But TDCX, TDVPR are vcpu-scoped.  Do you want to mention them _here_?

Otherwise you will have to explain them.

[...]

>>> +
>>> +void tdx_mmu_release_hkid(struct kvm *kvm)
>>> +{
>>> +	bool packages_allocated, targets_allocated;
>>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>>> +	cpumask_var_t packages, targets;
>>> +	u64 err;
>>> +	int i;
>>> +
>>> +	if (!is_hkid_assigned(kvm_tdx))
>>> +		return;
>>> +
>>> +	if (!is_td_created(kvm_tdx)) {
>>> +		tdx_hkid_free(kvm_tdx);
>>> +		return;
>>> +	}
>>
>> I lost tracking what does "td_created()" mean.
>>
>> I guess it means: KeyID has been allocated to the TDX guest, but not yet
>> programmed/configured.
>>
>> Perhaps add a comment to remind the reviewer?
> 
> As Chao suggested, will introduce state machine for vm and vcpu.
> 
> https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/

Could you elaborate what will the state machine look like?

I need to understand it.


[...]


> 
> How about this?
> 
> /*
>   * We need three SEAMCALLs, TDH.MNG.VPFLUSHDONE(), TDH.PHYMEM.CACHE.WB(), and
>   * TDH.MNG.KEY.FREEID() to free the HKID.
>   * Other threads can remove pages from TD.  When the HKID is assigned, we need
>   * to use TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().
>   * TDH.PHYMEM.PAGE.RECLAIM() is needed when the HKID is free.  Get lock to not
>   * present transient state of HKID.
>   */

Could you elaborate why it is still possible to have other thread 
removing pages from TD?

I am probably missing something, but the thing I don't understand is why 
this function is triggered by MMU release?  All the things done in this 
function don't seem to be related to MMU at all.

IIUC, by reaching here, you must already have done VPFLUSHDONE, which 
should be called when you free vcpu?  Freeing vcpus is done in 
kvm_arch_destroy_vm(), which is _after_ mmu_notifier->release(), in 
which this tdx_mmu_release_keyid() is called?

But here we are depending vcpus to be freed before tdx_mmu_release_hkid()?

>>> +	/*
>>> +	 * In the case of error in tdx_do_tdh_phymem_cache_wb(), the following
>>> +	 * tdh_mng_key_freeid() will fail.
>>> +	 */
>>> +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
>>> +	if (WARN_ON_ONCE(err)) {
>>
>> I see KVM_BUG_ON() is normally used for SEAMCALL error.  Why this uses
>> WARN_ON_ONCE() here?
> 
> Because vm_free() hook is (one of) the final steps to free struct kvm.  No one
> else touches this kvm.  Because it doesn't harm to use KVM_BUG_ON() here,
> I'll change it for consistency.

I am fine with either.  You can use KVM_BUG_ON() for SEAMCALLs at 
runtime, but use WARN_ON_ONCE() for those involved during VM creation.

[...]

>>
>>> +	err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(kvm_tdx->tdr_pa,
>>> +						     tdx_global_keyid));
>>> +	if (WARN_ON_ONCE(err)) {
>>
>> Again, KVM_BUG_ON()?
>>
>> Should't matter, though.
> 
> Ok, let's use KVM_BUG_ON() consistently.

Ditto.

