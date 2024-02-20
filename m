Return-Path: <kvm+bounces-9187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EE685BD19
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 14:23:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 369921C2207D
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 13:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF726A32B;
	Tue, 20 Feb 2024 13:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZ+qSxDm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5A36A00F;
	Tue, 20 Feb 2024 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708435402; cv=fail; b=tOpLnohpQo7gdZWsqbzQ4PYESfClXvxQFbe9hHRF07w2Z78fKLPHGyz1Cl6UeZk9zv+B8h/8mb1Zv/4sR6U8BaLV89JqRKgjqTCIHxhbCfp+f+iwtRUgWi3mL3VKUDHPh1xU8RgxvyHWsLY+Xui3s0Q8nQK1bCdN5eNB19GfZKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708435402; c=relaxed/simple;
	bh=D7m3FIwIADlHTwugEVYbqyr7CycmTEkGPHu9IBChQqI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jG9VM3OAHFUMpN/N3TjvRza+930XJuXL1G2nGBRA8mCrhXZzHQh0n6RfxO7ev7iKOfnobgBu1geCVfy29vGuyuPn0hGXRdG8UxvhFB/NiRej0eRP5pxSrpkzy9PPx7MivYd4g/SkIJt2VW+Wen9uAKkrOWoIT0NwvDv68gW+G7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZ+qSxDm; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708435401; x=1739971401;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D7m3FIwIADlHTwugEVYbqyr7CycmTEkGPHu9IBChQqI=;
  b=NZ+qSxDmZ4Aym7CKvWr4qMHacVC4ZsntgoaHBxQte3bslDb285iKLCEc
   DuJjwXhcesY02z89KHzaulua8M5GU/8mTn/pldWrGME2wPf3ZVBIXbzQo
   RlXj5iqnM1vVe6WTb/MpDyc6NCR0WBMNPssesJTOMQELEslxx3dE7eED/
   rzabdcoYZv7bxLXC8qPIYFkUxrSRKRu2PzLL3wbVmP8kRMbuk13sv4OCg
   3XkKm+KBOsVlMJnc7YcWYeEZkyOH7M5o6i0sijzrnqsEmsW3WW0xaGqss
   uI3IwB3a4mOzpNV/win1MYTaFTU+/iE2ACpiNCEoIPNS30DPiJtj7avnL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2669740"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2669740"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 05:23:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="5132974"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Feb 2024 05:23:19 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 20 Feb 2024 05:23:18 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 20 Feb 2024 05:23:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 20 Feb 2024 05:23:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 20 Feb 2024 05:23:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfZLMAqWDdRh4mrl5v1e0XHL3tNk4xeI6mxmHX2HpxQ8kv6LfrkGSFmQXdcdC/RSH5kKfUFwaBIak9DNBZuFlEac0TYuyQg/JZDi5rjOBD9whqR90fNqPAKwMz51KGXOSKtsMKmk1R/clx567LkHx71tPApbLYGu1O7tBTR1Y2i+JagpPcsm9FDQKY4GoggrZnHgwDlj1bnZKg6DGexuvr9tGAeL+IpqYva7grpmwFEZ49Ru9UngDlBO70DkTxoCbObYcQO71tfwtucROSu31VsMeJnfgsY6l0H4cba9rG+GXYq0Ms68rrMI9o+bj1QohRf9qCJdfQeyHVF1M340MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuG0kkttTqPcFtZdGOQr9nnieaXZXz7Nm0ar/w8i56I=;
 b=Z9O8pXNdRvvb3i/IM5uFPG4nwdQ1GZmqk7Sb2zb0DdEZ2hBrSUknA9cDRmrJ7MMzpmMCeIUFHtPLM+1MoALwIwcYNz1fD7NsaohcP2+OhdzXEIHUub6tkOuI8JpIH8Xt6jrhIE7SZDjtGE5prJudduFKMEcwVHjGa8jPTbEPlkxmNnJ1eDGyaYUD3H0Ju8V5AsjNZXmpVn+nGCuYAhXgdZvMrbjUx4CbuXOcqqON9mcTlNFRtsXOYTYe1IajxZhXiPv/ODgFQgn6MF/oZS9XOPhFBCNlquvS++Irj+0pmDY1TVtvHMwU6Vf3aJACJtf+FrTLAh1392UqDl5SeTQBNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BN9PR11MB5227.namprd11.prod.outlook.com (2603:10b6:408:134::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Tue, 20 Feb
 2024 13:23:16 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 13:23:16 +0000
Message-ID: <119db925-4472-4070-adb3-767f2bd00726@intel.com>
Date: Tue, 20 Feb 2024 21:23:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/27] KVM: x86: Refine xsave-managed guest
 register/MSR reset handling
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-11-weijiang.yang@intel.com>
 <ZdQWu3D3Jku1iAvd@chao-email>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZdQWu3D3Jku1iAvd@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0135.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::15) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BN9PR11MB5227:EE_
X-MS-Office365-Filtering-Correlation-Id: 31b65aa5-ef86-4a60-0ab8-08dc321718b0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xF/aGGl0DZperwXSZKGN8ZCv+qNo2yCk8iTrtP/aRHmAEVXYmQpIh2al5FhVAJbRJC3Qla67a2dP9wLkcQh7dwnCKhzb5XR/5tj9ppdZrdSBgZT5msSiYhjql+cL8B+NqZ4zDg5PWjMMXviEYVt/UEymTRsO2wNUtE9XidJpMZGJgQvi/W3hp2Gjfqr60N37eo1l0uxis6QyPbmkL48vOgvJvOtOOPSnRZtiIhd9fv+ib54aP7WSXD53/huRTOlcccj0CU5kJg82it1nPtkJ8r+/WnnwGnsHja1yyxBmctAVLIWgTTloecffRCp+avLW40jMCs1Dc0/UzMDcwNNxX1asZfQBin/GOy7/dQasoN3PXNCWywbLzCu3ty26J3cIEKGxbCx9PkTrc9h2zWlSjlH+fcVZG30jbLwGY4T7PKKLclG/pV87BWHF7XJsCtU6Jr/kR2ID5fqj1larPQRrDHIr24wUd2j4Oy6Y9RGVUlV10DrhAPZExDRWv9p6e9s5CUCmMMk6f89JHTf77Igm3p5aVHHEMYlq13RjvbJoa84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjFtVllyZDFubzQ4N3QvMmtCVHd6TnFBWnhpenZYbmIrTEc3SFIxcmk4Qzl6?=
 =?utf-8?B?RTVmOWFKNXRIbmlWRWtvN0YyZ3NodFQ4RXBuYU5rVXlGckh0UkpGekVIWlJ5?=
 =?utf-8?B?Z3NCUndQMUJDZ0dPTW9ZSVVScjFJdlVkTDRSaHQ5THBFaW5oV2Q2VmZaNEJS?=
 =?utf-8?B?Vko3TGcwVENUekRXRU1KZ3hGZ0RWam5BOW44c3h1Tm5JamtrYWwvdmRWMFJl?=
 =?utf-8?B?YklJRWxNTVNBOXVjTGJqTjgwUDI1YmcwczZWemxKUTZVdFFsR2tTaDJUTEdq?=
 =?utf-8?B?WjVGZGFZS20vY0ZuZWp1YTVIZUdUTzBJWTFVOVR6L1JtYkpaUGtKK3k4VkUv?=
 =?utf-8?B?Y1QyZ3l2YlJNVXdGelZSbTZNNTlnWk1RQmVrbnlNQ2EveUpjZ3QrS3ZGOHdD?=
 =?utf-8?B?MGd5S2JHWEsyZHRtZnVTNUYyVytZRURWU2d6OWFvd3BtL3V2eGV6d3FMei8y?=
 =?utf-8?B?NjF0QXFqQ3UwYy9RbS9udEMvQzVXOGlFYzBOc1AxNy9ZNmExcjZXRFp3ektF?=
 =?utf-8?B?MWJIMnJ6eWcwQkdQelN3YkZETjBObFVBV3FxWkx3QmJ3bEhQcmY4ZDJmRnEx?=
 =?utf-8?B?eU5nNmhHd0ozcTdaRUxWSkdSQ3p4K28ybmZKMkZEQWVNcDdwVFo4em9YVk1m?=
 =?utf-8?B?bW1tOFJyQzBsczByOVlzdDJpTVY3Mi83NkRKOU5XeXV5YVZ5TGFRZkVIbFo1?=
 =?utf-8?B?VnZWeTkrS1hoUEMyUkRTMmcrZHZybWFjNGY3L0t2cXRrb205VVIwNUpzM20y?=
 =?utf-8?B?UjRjS1IvOExBUWVIMXdlelRBUGJQQmVOSVpZbjgyUmlvZVNhL25QOXNLVWcv?=
 =?utf-8?B?RTlZenFnc2FEc3ZkaTZWd2xwcVZPTzNBZEM0YWZ4akFWR1NqdHd0QklYTUJX?=
 =?utf-8?B?WThheUJjS2F2YTR1R2ZvcDdOaGMxSnJ1SzcvNG9OdTNFTTl4dXY5c1pXemZI?=
 =?utf-8?B?SUpxY1lmcDRkQW5FNW9UT2FjZ0tZZzA5UkdFUmxyY3prRjQ1NmFxNncxY2V1?=
 =?utf-8?B?VWZIdmpTVFpXWDBjK1BwT0RobkZzYnZXWTRCS2hvZDJNRW5QSlhJdmoyL1Nl?=
 =?utf-8?B?dkVTMlI2Nlk0ZXJSdTlTK3dsQXpjQjVmZ2crSWd0VWdDaVphV2VPTUJZakgr?=
 =?utf-8?B?bERvRC9GS3JuNnZsUmwvbVhVYjRBcWdJQnNpbjFpNkNCRGlkK1Y4M2tRcnlK?=
 =?utf-8?B?bFlpOTczTTVHWXpwR3JUMVJNNjlCVEtzazNiRHhlZy8wWVFZNHgraVFOcHl4?=
 =?utf-8?B?U3FHZ1dGeWQxMnV3emg2cDN0dURPVVp1SkVMZFdYeDNhWThDQVpLNjZnaE9Z?=
 =?utf-8?B?MlR5UEx3cDMxWDN5MkNzKzZpYTVBVjhzZUxjV3BROEZ4V1pKN2VYUFpRbXZS?=
 =?utf-8?B?OERlUGZHeHFZRGw3S3cySzI1RG8yam4wWTNmWS9jN1VOdkxTclNjSVBiWXA2?=
 =?utf-8?B?MEhOemw4UnFoVFZjZHJOWHkxTnZ3WTl2VU5YaEowaDNhODlDMkpoS0dGcjNO?=
 =?utf-8?B?YUZFSkJheHNrU3djc3dUWW40b0IxN2xkSVUrTXlGZDZlQUg3bEY3dzIwYkdX?=
 =?utf-8?B?azlKSS9nUTF6VWk0cFpUNDl2U0pzSXU1YW1vdUtPZEF6aHJ5SVdReU4zWno3?=
 =?utf-8?B?Qm9XcWYzRHBMOFJNNjFUekdlU0dQTUxsRUZyTEs1S1lZa21aZ0lDZ1JJM09r?=
 =?utf-8?B?emM0RzFBSDhJYkgwemkvL2hBM1JIM0ZQOEZzTFUxZVgwYk4xUTljYVhTcDl1?=
 =?utf-8?B?ekpTUzdIMXRKWGc3MEgxeVlPb3FTSkxZWmhHb2NyRVVxbXljSFlBY2p1MENQ?=
 =?utf-8?B?WWpGN1RaOW9UL3h0WU9HTGY3VTh4ZXFadFRpUWhXTGtIM285cXNpS3AvcFFY?=
 =?utf-8?B?WDdlN1Rsc3l6RXpoakkzWU45OWlvTUhMNVFuWE0yY0hRbU9DL3RrdGlybGpo?=
 =?utf-8?B?Q0tmS3UzV1AydGxnY2pWaHRtWk5uMWhrdHJRV3gyNHFnOW1WNW1YUkFoSDZE?=
 =?utf-8?B?WEtnclphS1M5N1JTc1VmeUZ2bDNhS3B0bVNDL2crTUxmbTZlSVZncGs1MVhI?=
 =?utf-8?B?U1N5NzJTcHdCL3FDbTRDWUdkeDN3Q0gyUzgvcFFLQy9MN1g4OU42c2dhMGZR?=
 =?utf-8?B?MHcwNHdsSm1jYTlMQmRmVEQ5Rkw2NE96OTNJU09YaGxGaWh3eThPU1U2NDRj?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b65aa5-ef86-4a60-0ab8-08dc321718b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 13:23:16.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYKvXN4GVGErljlw4zcQvyu/kY43bXt5EFao7Kn35WdIuOXtBIzJxIwRkSLcRf+jm9NLG9XzFYo3mXrqwSiZcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5227
X-OriginatorOrg: intel.com

On 2/20/2024 11:04 AM, Chao Gao wrote:
> On Sun, Feb 18, 2024 at 11:47:16PM -0800, Yang Weijiang wrote:
>> Tweak the code a bit to facilitate resetting more xstate components in
>> the future, e.g., CET's xstate-managed MSRs.
>>
>> No functional change intended.
> Strictly speaking, there is a functional change. in the previous logic, if
> either of BNDCSR or BNDREGS state is not supported (kvm_mpx_supported() will
> return false), KVM won't reset either of them.
> Since this gets changed, I vote
> to drop 'No functional change ..'

Yes, I'll remove it since existing logic is slightly changed.

>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/x86.c | 30 +++++++++++++++++++++++++++---
>> 1 file changed, 27 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 10847e1cc413..5a9c07751c0e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -12217,11 +12217,27 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>> 		static_branch_dec(&kvm_has_noapic_vcpu);
>> }
>>
>> +#define XSTATE_NEED_RESET_MASK	(XFEATURE_MASK_BNDREGS | \
>> +				 XFEATURE_MASK_BNDCSR)
>> +
>> +static bool kvm_vcpu_has_xstate(unsigned long xfeature)
> kvm_vcpu_has_xstate is a misnomer because it doesn't take a vCPU.

True, I'll change it, thanks!

>> +{
>> +	switch (xfeature) {
>> +	case XFEATURE_MASK_BNDREGS:
>> +	case XFEATURE_MASK_BNDCSR:
>> +		return kvm_cpu_cap_has(X86_FEATURE_MPX);
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>> void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> {
>> 	struct kvm_cpuid_entry2 *cpuid_0x1;
>> 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>> +	DECLARE_BITMAP(reset_mask, 64);
>> 	unsigned long new_cr0;
>> +	unsigned int i;
>>
>> 	/*
>> 	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
>> @@ -12274,7 +12290,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> 	kvm_async_pf_hash_reset(vcpu);
>> 	vcpu->arch.apf.halted = false;
>>
>> -	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
>> +	bitmap_from_u64(reset_mask, (kvm_caps.supported_xcr0 |
>> +				     kvm_caps.supported_xss) &
>> +				    XSTATE_NEED_RESET_MASK);
>> +
>> +	if (vcpu->arch.guest_fpu.fpstate &&
>> +	    !bitmap_empty(reset_mask, XFEATURE_MAX)) {
>> 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
>>
>> 		/*
>> @@ -12284,8 +12305,11 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> 		if (init_event)
>> 			kvm_put_guest_fpu(vcpu);
>>
>> -		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
>> -		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
>> +		for_each_set_bit(i, reset_mask, XFEATURE_MAX) {
>> +			if (!kvm_vcpu_has_xstate(i))
>> +				continue;
> The kvm_vcpu_has_xstate() check is superfluous because @i is derived from
> kvm_caps.supported_xcr0/xss, which already guarantees that all unsupported
> xfeatures are filtered out.

Yeah, at least currently I can skip the check for CET/MPX feaures, will remove it, thanks!

>
> I recommend dropping this check. w/ this change,
>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
>> +			fpstate_clear_xstate_component(fpstate, i);
>> +		}
>>
>> 		if (init_event)
>> 			kvm_load_guest_fpu(vcpu);
>> -- 
>> 2.43.0
>>


