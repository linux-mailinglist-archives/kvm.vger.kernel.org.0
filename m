Return-Path: <kvm+bounces-18174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 083FA8CFC6D
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 11:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 765861F22D40
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 09:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00E4763EC;
	Mon, 27 May 2024 09:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TafEHwL5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C683B17BCD;
	Mon, 27 May 2024 09:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716800738; cv=fail; b=a0FKClMMYwOLZP2KH99MJN4Fqgyp2oTyx0JR5hD3ErXuFy6oxyFyiIoXS61pbcZj1G1RKMt1NsKJXDLcWTkCfmxQrXOAWl8qJ4MQe6Fc09REMs2kwdNGmlR2q4DL4fPpYXL1UqsWlA0+WVphpdgS/gMGI2YRIWKUORexB1c35Mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716800738; c=relaxed/simple;
	bh=stYkrR7fQ3ZNydyib7bz3G1yYhFC5dEip7Hs0J9+Oo4=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gm393rKeYw2fWKFRNYcIFgloX9wDP+Rzc71Zv+hBp9cHL7mZ2AEwVm6QHMs6wUNYIf78+PearP78FZ2pLZ6hcqNCDf97nb4aMQZpcCNJ+nDhV+shbib/bNj/vhM8J7GvU09UA9KxSUtcRmDxUvRmuwRhDgt2+9p6Pqnbt93Iab8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TafEHwL5; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716800737; x=1748336737;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=stYkrR7fQ3ZNydyib7bz3G1yYhFC5dEip7Hs0J9+Oo4=;
  b=TafEHwL52pbq7Zo1yMg2i8IKz37XNSpK1nTCPmvgOazBIgH+YKnnUitz
   pHbDImTEdQMfCK7Y4IpurO4uaFf8h53iTTeRJt3N5wRwaXPLsg31WWAgA
   EJKpn0jJ0Q/gCD1gSmIHrSvPTZVwyTXnJ0RAtj46e/SORKFK4CyxgZXUX
   6NxSgxWw/PAYuDZnxWrNV5ruwSKU+dWsxZKq7tise7Sg8LFO/M0uXK8d8
   GeWz22oxuDgjnPb7wnKVmRo+aCOemitncbc6CWmf2Vk/Rj+OBHVG7jN5o
   9l/rabgQky9ifzcsMvPtAH38GMJZ2MFyp1fRis6Ktdp/z5NZfEtb/pg0Z
   A==;
X-CSE-ConnectionGUID: 4c/UiUjFRpyhIxX0J8kO3Q==
X-CSE-MsgGUID: gqLI8YNpR320IVa843Wq3w==
X-IronPort-AV: E=McAfee;i="6600,9927,11084"; a="16051919"
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="16051919"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 02:05:36 -0700
X-CSE-ConnectionGUID: cletZ3baTx+PaWb5q4MGsw==
X-CSE-MsgGUID: AOrlcdsfSDC8CCE0gOHa7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="35176740"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 May 2024 02:05:36 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 02:05:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 27 May 2024 02:05:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 27 May 2024 02:05:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqZbJyOLjxqAagGjuMVFilcmmPunXiLPo3HZxhLq08lqlH9aoS5KFn4jrliQemS3JFsHsftrR0cqllzr2qLGP9kNiGxezN+BJq+ljk9VN93rKfm35POUDiWVIUf2DMbrmo/Wy3cV8fA2OK3aYTFEHkTUk4ELtRXb717aFOrZCImylC79oFxvkfJ1edPeUdT5rl6Jrtc9DKHshC7V9D5YoR+2PF2E95ajCQvXcZn67NnoHLso+zR0chSbfvSXVMf9S2d+U7jTKklPmODQJX7pmxuMXB/LEqnmyh7hJ6/BWyFNAsXQBYNfRBKqURg0YZzWHVw5VFSUIba68t33j7Yo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=stYkrR7fQ3ZNydyib7bz3G1yYhFC5dEip7Hs0J9+Oo4=;
 b=fDtWBPG8VCIxydzATkcQTT6eDRDnJ1MZGSpwCXB1HBvA1M/y7nNxAKYJvaCr1qRcUco0BVL6dPsakaZOaUH+U8ErBB+dLa1bI2F7W1vOKnxcMAZXoIcvTIf4PXzQVT4IOhOkP7jc331tDYb4hQ9DdlrHehTe6B6wTjZogJaS7sQPRBxVpeQGHCiWGYRwmJg1AxO/QAhAxIgKV+jONFBdpBD6zAd5pjTff5sKIVIT5MC+8hPHu3aXxqTfDdIkRjXhJjT+tfv050Vaya2SIiSUfLsV/Umur9Wd+rquifhODJssbSxT8r6hFN1LA879XGvqN2Jll4jvXN1lCaxZwIXe5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA0PR11MB7258.namprd11.prod.outlook.com (2603:10b6:208:43d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Mon, 27 May
 2024 09:05:32 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7611.030; Mon, 27 May 2024
 09:05:32 +0000
Message-ID: <e7742e9c-140e-4a36-8e5a-e6884bc24b76@intel.com>
Date: Mon, 27 May 2024 17:05:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: "Yang, Weijiang" <weijiang.yang@intel.com>
To: Sean Christopherson <seanjc@google.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
 <ZkYauRJBhaw9P1A_@google.com> <87r0e0ke8w.ffs@tglx>
 <ZkdpKiSyOwB3NwRD@google.com>
 <a170e420-efc3-47f9-b825-43229c999c0d@intel.com>
 <ZkuD1uglu5WFSoxR@google.com>
 <07fc9f6f-721a-4b89-baa5-986664ad5430@intel.com>
Content-Language: en-US
In-Reply-To: <07fc9f6f-721a-4b89-baa5-986664ad5430@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA0PR11MB7258:EE_
X-MS-Office365-Filtering-Correlation-Id: e6d14f40-c885-4be9-15a1-08dc7e2c29a0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T1JVYzdlRnVNeEt2ckZpWnlIbERmdlZQWXNub05MWVBQbHpvMmV1azBKK1pm?=
 =?utf-8?B?N09XVHpZT0RDOGdYemZKMnUxUHBFY2ZUNlFsZWZ5WnkxakFNNTdaL0tMM1Nm?=
 =?utf-8?B?VkhBaHg0YmFTMlEzZFNTSG5WK3J6R3V2bzN4MjhKZURDK3pkMjloU05YS2hZ?=
 =?utf-8?B?MFNwWnFhSWpCMk9mdUpDYmIyL3k5cnRtSTl1bFNXd3NqSTc4OWZDSlZzMzR1?=
 =?utf-8?B?dzliQ24xTS9mU2x1OHJ0c0o1enFacHBPMjMxSVRFT3pqVTB2V0VJSTBibG1r?=
 =?utf-8?B?bzBnREdKeExuVEZIRW53SGF0a3phNmVmajRncUV6T2NvTXFScm02ZzE0V1dH?=
 =?utf-8?B?QlkyRzBwQmRhL1lLVDNrZ3BCWXQ1VlBMSi8xOHUrTTExQmZKWFI2SXg0bnB4?=
 =?utf-8?B?V0hQdWNHb0hEbHNvNGVLSW1XbWRJWjRCVDBUZEdaZzlRTzBnWkFOOG9xMmYr?=
 =?utf-8?B?ci9SVTZOdU5IV3pGR3dYUkNyR3AwQXhvcVZBNndoZ0EzdmptRkhqTzRjcTV3?=
 =?utf-8?B?Wko2a2xkVzBwS1ZCaXQ1QldTVEJFZUZEek5KWHo4ZE5nVFpzcjh2YUxhZ3BQ?=
 =?utf-8?B?TlNGa3FOWlZpSnliMkVSRmVhTno1dlc4SDNPTHIxaVZFZHY4MXloVnIrSEk1?=
 =?utf-8?B?UW1GNHg0Vi9wZjZvd0w0NmFDcm1vUDh2T2tndXBCSWh1cU1wTmVwRThCZHlT?=
 =?utf-8?B?YldpUzdoTE9tRmExaGUxOFVxMEwrejBldmQrRDZTbWgzOUhJcE5NN2lpVjZC?=
 =?utf-8?B?aVkrSGxXa2l5QlFHQUNTT2xaK0Fvb05MWXc0TkwySTJEK0x4YW94VkQrT2Q4?=
 =?utf-8?B?ZTdqeFFDR1M5YVlkTnE3ZUtobmxRR29nSkZzL05IWUF6R0lOY0JTMERIdWJS?=
 =?utf-8?B?TGZQSzJybWJ3YXkzNnZnQzBwN3dacWF2bEtnZHhlcTlSZFE1cG5UNS9VL0Rv?=
 =?utf-8?B?YmNhd2lnY1UrK3U5N3d1U1VVQTY1N2E2ZEx5bjJLcEMxclFJUDJiRnJwb1lo?=
 =?utf-8?B?V0EyRDJlOE5YVmF4NHhQQitOekdyZnlkTmpMR2RsUTg3RVhMd0puVzRVZXl4?=
 =?utf-8?B?WXlpZTMyZit5aWxrUVlvWVM3QkFZcTVrRFE2aUJLQ0sxdTY1SlhoWmZBYklG?=
 =?utf-8?B?LzdXb0RFUlk1UXE1cjJvMHdIQnBjSC9LNDIvY0s5dXV6UzlMQWpDbFgzdWN3?=
 =?utf-8?B?SE91NFFXQVhHMWNOWjRBRTJ0R25IVjNUb0VkNjJOOFh2STJCZmFmRGl0RHJM?=
 =?utf-8?B?VDg5UFBHeTVna1FNS2pqWnVwSmFqbEw3d3dqZjRnOTZSOVhJRzBiaVExNDUy?=
 =?utf-8?B?R0RTUktEVVJDaXdkT21sR2RRRG5jVXIrZ3lDeGg5OER0UHNYckkvT21qeElV?=
 =?utf-8?B?MldyUTZpV3NsaWZRMS9DVmF6SjJyRE8vampNYnVXQlZJODN1UlU5R2J2MTFL?=
 =?utf-8?B?THJaME04dktzMmJlMitzU201SDBOTVlCRE1yd05JVzg1dStQOHNPTk1jWUYv?=
 =?utf-8?B?VEJ1Mk0rc3IwbjgvSExLMVBCeGI4Y0NqSENLQlVxVVZ3S0NuRG9YVVZ1bjB5?=
 =?utf-8?B?WWhlclF6WDdnSGdLckljQzgrVW1IWTZHYk9yL0wwNTZDdlo0cDM3cnUwL2tN?=
 =?utf-8?Q?kZoeU+3+F5gyoDW6rcxVtOsCauSMC7y0NlQEZYMuoKZ4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U05KN1hyK0QrYTZFQnQ3MTlUUk82aXdKVkJtU2tMZGdSZ085cktySnBHVzJX?=
 =?utf-8?B?T3VxeG5CRmhsUkMvYTJQb0RaOVlNL1VGOVdYdG95YjNnMHJtVGdmZmkxREkv?=
 =?utf-8?B?Q0hQb1NNbGk3eU01YTFBMFM0Y0tPeXU4SmlqN2hOYWZUbHFZU0tTOUdFTXpB?=
 =?utf-8?B?RGVQdmI3MHJWTXZ1dk5GcE5IUC9zWEt5M1dqRTlGaExNeThDNXgyRGVJSUpz?=
 =?utf-8?B?WFF0NEF3VWh0SUFIby93Q01mVW1PYVRJOWZrRmg4MHVpSTVyRnFudTJCdTBn?=
 =?utf-8?B?NG42T1AvVzFrYWJUQkJzaVlNUGNjd0tWZkpHRCtNWXhQNmVNWGxody9zL1R2?=
 =?utf-8?B?Z0NZcVd4a20xVmZaY2xXTWdWUG03WFdpVDNURmRaMmNYUitlMXNBcnEzYTdn?=
 =?utf-8?B?UUdqSUIxNGtMSXRhUXlLVUZ4czNwM2t4Q2ZKYTdRTUNLSGlrMFM0eWR3YnpG?=
 =?utf-8?B?RzVPVFBQMWJoK3RjNTRXWnVDeVB0UER0TGNaaHpUOFRTWlZrQkVpcmJQSVZS?=
 =?utf-8?B?RXF4c1FCa3VBVjRHMkJHbUFRTnNPWXN6OGUyVEtDRDU4T0hQbmpBK2JzUGFl?=
 =?utf-8?B?Qm9tL1VPNHo5ZGdObXdmaHJSS0F2QzlJOTFQaEFWNXd2aHFjT2pYZFVCV0Zu?=
 =?utf-8?B?dmVNUFBvMDU5R0tyK0ZlTEVXNjZCY25KMHpzVUtMaC9JSnZnQWFWVE13ekVP?=
 =?utf-8?B?OENQOCtJMmQrcmlaaHBjeFNvS3JpeXUrckN3ZU80aGJhWUY4dktIdHB2a2lW?=
 =?utf-8?B?bVNQUWpVVFpLK3cyb3BmTFJ6NkMzNnQrS2w5Rjh6WE1BekdrVGRXOFV4N29h?=
 =?utf-8?B?TENuNzJvczZWQi84WlNZYjEzbnFEbDFseGFPeHFjbklOTWhnL1VmeFBKVjIw?=
 =?utf-8?B?QXUrU3QvNnNUVFgxN2l5TWc5ejZPVElwRngvaXl2dE9MSVFYUHpwUVR1R0Z1?=
 =?utf-8?B?SnBhYzl5RE5RRmN1ckNGRHhRaDBqc1hXMUpHTlAxdCtoQXN3djlwSG00QXRD?=
 =?utf-8?B?YzB6M1pRMHRJMWpmLzh0aDVwRXRLeTlKeUFHTU15S0xZc0t6c2orZm8yNWIy?=
 =?utf-8?B?RjZsMVVZbUVhQ0UvSXRxUjNTVWFKL0xncmExejBtR2ZSYk9EY21UZDZMMG01?=
 =?utf-8?B?V3dJTUY5QmVWdWljREQ1R3FqRXhmQUVJY2RZeWFMME1XRXpiUk92YmgvaCti?=
 =?utf-8?B?bG9qT2taOWxMbzExNEUvQ3ZXaGtCc1FyaWh4d3RsV2VOOHd5dS9CVUVlaGxN?=
 =?utf-8?B?MGJjN3V2Wkh2ZDdBaUhOWkdNM3ZKL1VRNW5HbW81cnQxTmxja1k0R2piR0V0?=
 =?utf-8?B?RUppcUduakNHcGhib1N4UzhDaTFSK1ZFR1BuNEEvS0I0N3dmNUh2eW03Q1pC?=
 =?utf-8?B?T0dSOWtveW5ScEVjZTg1L3ZmWEJDTHlncTB4UUdvdmwrNEJmUE82WFJNbXdY?=
 =?utf-8?B?ZGJSOXFnR2FjalpsemkzQmlBaWpBQUNrTVpYZ3h0RDkwb1J2dEJES3F2WlRG?=
 =?utf-8?B?MlhKK0VHMmpyZjJGUU1UeXBOL1JpOWd6RkZwbDZqem5MaEhBZi95U0FzUjNF?=
 =?utf-8?B?dnlpT2VMalFRUUxNd1VKUEpPOW9JZjdxRUxNZ2Y1bDZ4WWgzYmVCbGc1R1pL?=
 =?utf-8?B?UEluSk9TRmdXUnpNWkYvc1NvZ3ZRNmlUcHhXU0J1NzNySkdGWXdZcGdqb2N0?=
 =?utf-8?B?MmdYd09udCtQQ1hKd25Sc1liQVRyR05QM2syZE5hR2djSk9MSlBhcG9rOUZG?=
 =?utf-8?B?WTJ1d0dWand4ZDhZSmVJMWkxQ3hkaGR4czZZUW9HSGxveHI3RXpBUDNKQ20r?=
 =?utf-8?B?Z3hPLzYxRndGcDBvTUVZMTVhTWhLRkpJT3ZJanNxajVzRUR1ZHFRMU90OWZ2?=
 =?utf-8?B?WjQ2UXlwd2JMQ2J2dG1MYW9pYXAyS0ZJUXNHaFR4bTVkaDRhWE9PbnNTaDNZ?=
 =?utf-8?B?cmE3dkozUndHUUdteis1M0dyUUlKQzM2Y2dDNXFtVTlNTTR2ZzF1OTJJVkYz?=
 =?utf-8?B?RHJZU2pZSVVkTmkwTHc3REFyVlplZmtjN1A3Zy9UbnZTMjNFYVhCNnc3UXdQ?=
 =?utf-8?B?aWhiYUF5eHFWeWNFS0tteVNTa01ScmxwbXduRVNsdmhwdkJVaERCL1luY1RG?=
 =?utf-8?B?UWdZSW5abkdkY016cHVjQ2gxWXQ4ZDd3NURaSmFzWE9oWWVvZVoxMjBHaWpV?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d14f40-c885-4be9-15a1-08dc7e2c29a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 09:05:32.5208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDlofNSXodiC3aga0MhqXR8ZmBDF7OZ/YMKE3V1LRhuvW4/EMrpSQ7vAYG3qQpnFA59BwVhRBCyS2xV9Ia94ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7258
X-OriginatorOrg: intel.com

On 5/22/2024 4:41 PM, Yang, Weijiang wrote:
> On 5/21/2024 1:09 AM, Sean Christopherson wrote:
>> On Mon, May 20, 2024, Weijiang Yang wrote:
>>> On 5/17/2024 10:26 PM, Sean Christopherson wrote:
>>>> On Fri, May 17, 2024, Thomas Gleixner wrote:
>>>>> On Thu, May 16 2024 at 07:39, Sean Christopherson wrote:
>>>>>> On Thu, May 16, 2024, Weijiang Yang wrote:
>>>>>>> We synced the issue internally, and got conclusion that KVM should honor host
>>>>>>> IBT config.  In this case IBT bit in boot_cpu_data should be honored.  With
>>>>>>> this policy, it can avoid CPUID confusion to guest side due to host ibt=off
>>>>>>> config.
>>>>>> What was the reasoning?  CPUID confusion is a weak justification, e.g. it's not
>>>>>> like the guest has visibility into the host kernel, and raw CPUID will still show
>>>>>> IBT support in the host.
>>>>>>
>>>>>> On the other hand, I can definitely see folks wanting to expose IBT to guests
>>>>>> when running non-complaint host kernels, especially when live migration is in
>>>>>> play, i.e. when hiding IBT from the guest will actively cause problems.
>>>>> I have to disagree here violently.
>>>>>
>>>>> If the exposure of a CPUID bit to a guest requires host side support,
>>>>> e.g. in xstate handling, then exposing it to a guest is simply not
>>>>> possible.
>>>> Ya, I don't disagree, I just didn't realize that CET_USER would be cleared in the
>>>> supported xfeatures mask.
>>> For host side support, fortunately,  this patch already has some checks for
>>> that. But for userspace CPUID config, it allows IBT to be exposed alone.
>>>
>>> IIUC, this series tries to tie IBT to SHSTK feature, i.e., IBT cannot be
>>> exposed as an independent feature to guest without exposing SHSTK at the same
>>> time. If it is, then below patch is not needed anymore:
>>> https://lore.kernel.org/all/20240219074733.122080-3-weijiang.yang@intel.com/
>> That's a question for the x86 maintainers.  Specifically, do they want to allow
>> enabling XFEATURE_CET_USER even if userspace shadow stack support is disabled.
>>
>> I don't think it impacts KVM, at least not directly.  Regardless of what decision
>> the kernel makes, KVM needs to disable IBT and SHSTK if CET_USER _or_ CET_KERNEL
>> is missing, which KVM already does via:
>>
>>     if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
>>          XFEATURE_MASK_CET_KERNEL)) !=
>>         (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
>>         kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>>         kvm_cpu_cap_clear(X86_FEATURE_IBT);
>>         kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
>>                         XFEATURE_MASK_CET_KERNEL);
>>     }
>>
>>> I'd check and clear IBT bit from CPUID when userspace enables only IBT via
>>> KVM_SET_CPUID2.
>> No.  It is userspace's responsibility to provide a sane CPUID model for the guest.
>> KVM needs to ensure that *KVM* doesn't treat IBT as supported if the kernel doesn't
>> allow XFEATURE_CET_USER, but userspace can advertise whatever it wants to the guest
>> (and gets to keep the pieces if it does something funky).
>
> OK, I think we can go ahead to keep KVM patches as-is given the fact user IBT is not enabled in Linux.
> I only hope other OSes can enforce both SHSTK and IBT dependency on XFEATURE_CET_USER so
> that user IBT can work well there.
>
> Then IBT can be exposed to guest alone because guest *kernel* IBT only relies on S_CET MSR  which is
> VMCS auto-saved/restored.
>
> What's your thoughts?

If there's objection I'll do below changes for this series:
1) Remove patch :
https://lore.kernel.org/all/20240219074733.122080-3-weijiang.yang@intel.com/
2) Remove reference to raw CPUID for KVM IBT CPUID, handling it the same as SHSTK.

Meanwhile still allow userspace to enable IBT feature alone because user IBT is not enabled
in kernel now, leave enforcement of user IBT dependency on XFEATURE_CET_USER in future.

>
>


