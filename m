Return-Path: <kvm+bounces-11270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E6E874865
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:01:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7897D282DAE
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 07:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2852311184;
	Thu,  7 Mar 2024 07:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bV4cbE9h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612FA1BF50;
	Thu,  7 Mar 2024 07:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709794879; cv=fail; b=dJYDPIl2CXfkbTVUa0lRxAa95mgN4Yj9fLGSE8g+ydwqHcma7h/vApBO90OaieKbssfsBA64tqb3dPj+1K0mobdc+LMwsOYbygdADwx28/zqPZ9UdwBw7GblGmO+8eMlLWIJsbsDEAm9ayY6P6GKU/h+DnUV/WajmanVAR97r+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709794879; c=relaxed/simple;
	bh=CSj2uLCsVWPWmXRbRIhX1sjoX/BUl8vN2mfQKoadeu4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s2BYjaIyTiUVN7xGi1pS3jdjENV/SfiFpPfm/NE1UunwnuDEEMlTfYycptoL8V6KrQ/Sy4fYauZgOVebRmzTAwATBSqXF9kzOcBCcPOrEEb+BDmRiZGtYcngkzCOhBG35uiwShTuPUCmWogF+RgMAZvlxpLSjAXGnYVEwnUI/3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bV4cbE9h; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709794877; x=1741330877;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CSj2uLCsVWPWmXRbRIhX1sjoX/BUl8vN2mfQKoadeu4=;
  b=bV4cbE9hW3AKT2uvfotDw+B/nHAnE2GMzpQ1NP1uJeLp6m+IV6e7ti0D
   WFVhS4asvJw14mFzinJNv59nSNg9UycxQsAMqOcc8opkDdGoYROA3mlB6
   S33Xg44rWC6P7cptkGPDBvNing958Eiv/EM6a6iP/RZSnntt4ggw3LWcN
   GzRT+NDdTy8QGxLOTfRZtcYY7sRLk4V21hmom/RLVb+yKly62tfYe0ogj
   IwrO70e5COjZx/RRScZPBDH1uUywR3r5SENsPy7dQEwqMNvyvoHn96Fby
   J4e3vEkq1naZXNPLq44jmC8/XIRCDerUDWs+WI6L7Blhqe2PAhHj5mvB1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4316869"
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="4316869"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 23:01:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="40901472"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 23:01:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 23:01:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 23:01:15 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 23:01:15 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 23:01:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1H+GLsi6JKbCj3q7PTzaEI9A7Pnl1un+YIfJro/95POjSg+N+TixfkBJFLXvM0/9OEJRUKuLEjEaY+lz1g37wYiaMR9blwYHnPpp7uDUYtEvKjwmwVQPbyvRPVs9dSgRtgGU0DsaJOlmmM9v3WiTsCeoooGZOE2/H81R9UA26BzluniLVAhq37fp7SIHTsL2MNsZ9zOo9/QT2T4FX1elt38AsPBJUEnkZJAzLiOxebvYNAGwTY0X2nEpK64MVERi8uC3vXlhXRDLZeN+Jfe97c1yeRjwwyYV64SHj3ZnAH7EYBX7bhvOh91rF5itM0sheScw2gBjmATHw8pDa7zSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G09BZNH7z2Vxmjbd8oJLuczQ8BL6PiK7Lfny/WYktXg=;
 b=EtYF0ZMTy+wkei2B2C0CxZitYVKxwwyfQ+i+tqvjQv6d6UfkO45RwHCw/tQmKV3kglD5GHVKHZ7xCYdk2bJ7o9sX5QwAAhZiyqWwBi+gaZLMQbUA5gGCnEHwEvBprbj0hFMdJrgqPNkkZF8nRRnKt8VI7dJ0iALmMr1Ncz4QzWyd0iZzDFh5KDqcznDGVR6RVBEbXnqWYAwfUA5bWSdWc1GJ4o2MN4eNr5U3RzV941ewWixU87jcjGBrVfZgc7JcCqwO08wu47qa7e7Pd9US0rsxib03Fh0Eu4k4f8nZkm72mf6OGcEA6Wek839KV5yOnf1jhsUEkQ0XJVJBLiIV1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by LV3PR11MB8601.namprd11.prod.outlook.com (2603:10b6:408:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Thu, 7 Mar
 2024 07:01:13 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7386.006; Thu, 7 Mar 2024
 07:01:13 +0000
Message-ID: <6b453972-2723-47c5-981e-56c150f217d7@intel.com>
Date: Thu, 7 Mar 2024 15:01:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 014/130] KVM: Add KVM vcpu ioctl to pre-populate guest
 memory
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8b7380f1b02f8e3995f18bebb085e43165d5d682.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <8b7380f1b02f8e3995f18bebb085e43165d5d682.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|LV3PR11MB8601:EE_
X-MS-Office365-Filtering-Correlation-Id: 297f0830-86c6-4fe4-c2b0-08dc3e745fdf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7GtBl12NDH1r6uy+E9NwfEbVZX4k/V0f+FZh7+Coy9xkfuFmm6h3wECWiJM3Yqm15vKhmVcda6FlSuunnSwFVhNzndftqoBBw7FcFqrckww/fwWAKIMO0hpKYNXrxo5scE69a7dyWeyGKy7T/B0z3CPnUwf7oHNvpT4LcBrBqkdeZ0gPNVk9sVngqD5Zw9R5TsRxXRc15TKlgK2yOgq+hor89+6U2ilzRJykKj8CgMno/v35dvcdhGjbGR5UzbB+eMhZCh2BcJeMFuXGYDTKDoJLcTO3yTpQQZauUZ2a1vPWUcKxGMkaSjXX++Tyf0faUS8JpQXN2GK+ouhD5UIU2NjIimjxe4Xpe4mTRsdHkwyoGh/TNbkGDBQV1PVZwtk5B7f4WZpn9egbs6OzcnKndy6CsVfjYbSnIX3bYxjNGHz8yKusuwwYnLjs58NM8FuPOwolq7RqeZUYXmtyW+WctJKu1fkjNaGbKsbJignVJzA6I0Zj3yoan9DC1WkRezdOfRY47aHFDG5tDTqVvLdHo5vvP4Sv6Q3GMWxtrynkti77Dj1Iqg00WHzfYTGK2YTsot9ob4qEfTlWHEwdoqhrDehmphnhSypBiRN08oCqnsB9KFFuJmlA0mh4GBIh3ieWevOkSCh94uyWPwO1TuYytg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RC9wdzJQODNmSjBBY1V2RFVDQ2NKcUpVUy93Y0xwZGt1eWZTVWlHWDhJeitF?=
 =?utf-8?B?MUlTUmNlbjJINjFIM1k3Snhtd1hoVytKVmREdzM4UmxXOS9vYk5tbHZtZ1pI?=
 =?utf-8?B?Q2xMQW5VSlRuNEpmMkxZMlV5cTRZUnptTU9OZlFWaXUyNXFrcHVEYmJORDNV?=
 =?utf-8?B?c25aMmpMVXhua2dPc2ZGMG54TC91aTJvWWY1VnovbEViRGlxaURUcnJ6RDg3?=
 =?utf-8?B?MldWVzdCbDlveGI2OE9XMWlnNW5yMFo2UitUT3kzdkw0V0hzQTNJbjBoQlUw?=
 =?utf-8?B?ZFNLbkJaU3NSWFltaWFmOXZ5cWVubXVnOGZnRnViR2NkTFM0U0NSSFQ4emcy?=
 =?utf-8?B?NWtGNTFWSS85djNIeXc1SDV4OTVFcjVGdnQ3bXp2UWNqckYwZm5JbVRkRk9o?=
 =?utf-8?B?Q2QvcUtQaDVYS202cHVGaHVzRmVLSFRJSDh2aHZzYThKMFZHaHRLeEVqODdL?=
 =?utf-8?B?V1lxUWZtN0Y5cjFzK2RQdlBiNzUvMHJTbHhqek4wam5GQWI1TkNhOHYwOTJD?=
 =?utf-8?B?SFA5Q1dBb3czOFp2MjIxS2RvRnY4d3lHVVJRbHNRTWNmanA3U3pobFNyMXJN?=
 =?utf-8?B?Tk5NSm9yenRqSVVsQlhpUVQ0c3k3MkVFanlMRVFIckZPRlNZUC9CV1phYkdJ?=
 =?utf-8?B?M0F3T2R6UC9KSm9FSFhJcU16OHhTTTdwMXdRdWIwODJMSFAxOGVPYlorblY5?=
 =?utf-8?B?WWdIZjdsaXlJZTREVUJKd3BhN2JEemxvQ09KTTNsRnl2SE8wbUd5akdMK0xM?=
 =?utf-8?B?Y05XRTViais1d0hQSXRWQ1hKSlhINUtMODh1cWNKUVoxQUx4ZGk2YlFyTitJ?=
 =?utf-8?B?MHhjcTNocUxYcXNadml3T1J2NkU3ZnhHaWgvSThNM2J2NjdZK2h5dVd6R3lX?=
 =?utf-8?B?NUp2Vi9zRVpyb1V1YXdxd3pEbThiMjlhdEFiZFZWb09oT3l6ZzNqcUY0cC9E?=
 =?utf-8?B?b1VXSjRnQ01sTDg0amVrNGg1MVpHeC9vU2JIM3pDb3h4LzNxMnkrK1ljdEdk?=
 =?utf-8?B?WURTc011dkNTbVFKN0VRSDhUcUxhZWlPdk9EWHJMWlZCUHZpdXo4S2dtZklt?=
 =?utf-8?B?czQ5dFNTdUUwUXppWE1QN1hMTnoyVlhwS3pBUUZzM040UXYrazZHYmhweWdQ?=
 =?utf-8?B?ZVFuL0R3WC9RQ3RlVlhTdDJ2Q0tPSmx2NE5tbllSWGJXY2dCVnN2c29GVUVs?=
 =?utf-8?B?bjE5RmVObUhGYUJsYUpMOUdKcmhxYk8vRUsvUmx3ZVQ3Y1NVenhiajY1NWlV?=
 =?utf-8?B?T3BaV3N5YmUxSDhobEticXNlNW5RMnl3M1dYN3pDUUJsdjRvcTRMcGYyeTFC?=
 =?utf-8?B?Q29CdW9kaWwrSE9kQUsyWkRlT0p3bm1BcThrNlJ1WG9zKzRTamNwVDVseDhs?=
 =?utf-8?B?VWJnUzIzN2pOakhTMmduNVB6S08vRStMcWtpdDZvUTBoWnRWQi9zang5Slc3?=
 =?utf-8?B?UC9KYUhGRkNBMlZ6dUhKY29vY3JUVlErWlNuTnNoa1IwMXFZaVFLMUFRdGtj?=
 =?utf-8?B?Tk1TYTdoTDJSZ3RhdDZBbGhWQnJKdGtIZTRUVVk2NG5wVXNncW1yQzAxMGZy?=
 =?utf-8?B?RHh0ZmlQV0h1U0JFRTlFc09hTjdaYnc0RHpvV1FPOVUzTkVuVGZCTC9WYWNn?=
 =?utf-8?B?UlFLcWUycVErckgwdUY4ZENDdDdWeU1pWkdWZ1FVVEtxajJJQSt3Zlp2cjhh?=
 =?utf-8?B?MEY5Ujd6MG5NWkF4M3I2Y05TMk5PYzNnUThyK3BQcWJDSU8yTmZ1ekZqclRk?=
 =?utf-8?B?M3N2SExFaTc2Q2p2VzU4TzFXa2JtV0grTWtCdjdvbEtlOUN0c2JCbW56UndN?=
 =?utf-8?B?OGpreVVtZ1V0cHRlMEhXU0hPRjd4UCtGc2ZSTXRDNERkdWF3UlJ4YnA1SENE?=
 =?utf-8?B?bWg3Q0puM2FrblJPOW1HVVVFOWhveDVFaVYxK0xDd1JReXNoTmtuSnBBSGtQ?=
 =?utf-8?B?SXkzNGlDZXB1bDFXZ3VOY2dkOTZQck5CVzdjb3B4eFo1b2ZxN1F0Zk5KZnVy?=
 =?utf-8?B?Mm15RDErY0FSeXJjSXBjSTA0U1pualhyb2NuYkhSWTN4OWZIaldUMmQxaDFy?=
 =?utf-8?B?TnAxY09SZlJPL0NyQXZLcVUyME9kL3Z2a21MVEk3eCtjLzdwZ3hpWEhaR2k1?=
 =?utf-8?Q?omwHEP9lhi7rqiQeFtdxqA6MC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 297f0830-86c6-4fe4-c2b0-08dc3e745fdf
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 07:01:13.0195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h52/X9menYv3bFDIk3WockyJh7ZVgJwXTm79LanETCWm92bkWSteIn7f1AMG9SWoss4lAWJowlDST/3yPyedvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8601
X-OriginatorOrg: intel.com



On 2/26/24 16:25, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add new ioctl KVM_MEMORY_MAPPING in the kvm common code. It iterates on the
> memory range and call arch specific function.  Add stub function as weak
> symbol.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v19:
> - newly added
> ---
>  include/linux/kvm_host.h |  4 +++
>  include/uapi/linux/kvm.h | 10 ++++++
>  virt/kvm/kvm_main.c      | 67 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 81 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0520cd8d03cc..eeaf4e73317c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2389,4 +2389,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_PRIVATE_MEM */
>  
> +void kvm_arch_vcpu_pre_memory_mapping(struct kvm_vcpu *vcpu);
> +int kvm_arch_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
> +				 struct kvm_memory_mapping *mapping);
> +
>  #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c3308536482b..5e2b28934aa9 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1155,6 +1155,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_MEMORY_ATTRIBUTES 233
>  #define KVM_CAP_GUEST_MEMFD 234
>  #define KVM_CAP_VM_TYPES 235
> +#define KVM_CAP_MEMORY_MAPPING 236
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -2227,4 +2228,13 @@ struct kvm_create_guest_memfd {
>  	__u64 reserved[6];
>  };
>  
> +#define KVM_MEMORY_MAPPING	_IOWR(KVMIO, 0xd5, struct kvm_memory_mapping)
> +
> +struct kvm_memory_mapping {
> +	__u64 base_gfn;
> +	__u64 nr_pages;
> +	__u64 flags;
> +	__u64 source;
> +};
> +
>  #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0349e1f241d1..2f0a8e28795e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4409,6 +4409,62 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
>  	return fd;
>  }
>  
> +__weak void kvm_arch_vcpu_pre_memory_mapping(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +__weak int kvm_arch_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
> +					struct kvm_memory_mapping *mapping)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int kvm_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
> +				   struct kvm_memory_mapping *mapping)
> +{
> +	bool added = false;
> +	int idx, r = 0;
> +
> +	/* flags isn't used yet. */
> +	if (mapping->flags)
> +		return -EINVAL;
> +
> +	/* Sanity check */
> +	if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
> +	    !mapping->nr_pages ||
> +	    mapping->nr_pages & GENMASK_ULL(63, 63 - PAGE_SHIFT) ||
> +	    mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
I suppose !mapping->nr_pages can be deleted as this line can cover it.
> +		return -EINVAL;
> +
> +	vcpu_load(vcpu);
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	kvm_arch_vcpu_pre_memory_mapping(vcpu);
> +
> +	while (mapping->nr_pages) {
> +		if (signal_pending(current)) {
> +			r = -ERESTARTSYS;
> +			break;
> +		}
> +
> +		if (need_resched())
> +			cond_resched();
> +
> +		r = kvm_arch_vcpu_memory_mapping(vcpu, mapping);
> +		if (r)
> +			break;
> +
> +		added = true;
> +	}
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	vcpu_put(vcpu);
> +
> +	if (added && mapping->nr_pages > 0)
> +		r = -EAGAIN;
> +
> +	return r;
> +}
> +
>  static long kvm_vcpu_ioctl(struct file *filp,
>  			   unsigned int ioctl, unsigned long arg)
>  {
> @@ -4610,6 +4666,17 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		r = kvm_vcpu_ioctl_get_stats_fd(vcpu);
>  		break;
>  	}
> +	case KVM_MEMORY_MAPPING: {
> +		struct kvm_memory_mapping mapping;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&mapping, argp, sizeof(mapping)))
> +			break;
> +		r = kvm_vcpu_memory_mapping(vcpu, &mapping);
return value r should be checked before copy_to_user


Regards
Yin, Fengwei

> +		if (copy_to_user(argp, &mapping, sizeof(mapping)))
> +			r = -EFAULT;
> +		break;
> +	}
>  	default:
>  		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
>  	}

