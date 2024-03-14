Return-Path: <kvm+bounces-11835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8782B87C4BD
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB1AB1C217B3
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA0B768EE;
	Thu, 14 Mar 2024 21:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JmBApK0X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C621074E21;
	Thu, 14 Mar 2024 21:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710451438; cv=fail; b=XnPf1bCa1rEa09iPEejQcQNUWZeHEPC+kgLqOw8pSpwbw84sRy/sEN+zmrIOl4wsB/T0511u6+Uu0VucpCbqb2R2Js4IJ35SiQnguhLPI1022gDu8LxCOspq9m+yHG0s9+6qTpK85Wr4ueg8Na5fJ45ZPnoxwmktfzvwIbvV3BQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710451438; c=relaxed/simple;
	bh=9U8F2tcuUB4lX2mFWQ/4gCR43BMjamXvPtHdde9Fa/0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JwcA3iE9TIK/nIL8AHxSMq3EjibsbuN8DdJkqQSx2SvUrD5VyJ0Plv/lI+LSZ1/HqnTXI7ylrAwu1l2rgSUcTbNwBrmK465KfaNjePzIFgsLJDg4UQ2CBnneiwspAHbG+/tMon0tQLJ+QHqmPmYkn1wGAfU1+sgs3k83gtK0XBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JmBApK0X; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710451436; x=1741987436;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9U8F2tcuUB4lX2mFWQ/4gCR43BMjamXvPtHdde9Fa/0=;
  b=JmBApK0XOUsAGU8c6+71nDx56DkKPy5RRPBdewLp8iEItDdqYQGwa758
   VK8ELswIX4/kKYo+FIc9wdckEl+xrpwQSz7dRNdfRBtIxscKxrJ67MGZ/
   HbjdRM0R0ECFcjA7BvqKCYQTUihKxcO9wF1t/NBZkGT+xppNp6yVWEpN1
   ZqialKSdWvvzJ9V3qKvlhst+XIYyTzFUtkZMcbhea1JO9AhkoZHDgsP7S
   TUnnraBAHkUyErhDRtT/OiDRAcbaUvhxWeVLvzURFwWVErVmEGbZVABcc
   kZVsGUf0mMZ92lfVEzDQqNqS5KViOev2MFg7GAn16fICk957DQImAzGQp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="22758620"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="22758620"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 14:23:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="12515078"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 14:23:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 14:23:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 14:23:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 14:23:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5bkuKip3LTwRTqWDDfVthntm7slyFTNpydFbrpVxgz4fzbgwZBoKVHC3KviTZhMAPT2bhOBta99wkfwIK6S1GDEkoCb9xd6Q4K8fOny0yTjFV2H3WnOHdOgp8Uhzo6FLzIHTUrvGjdazd/eu4HZQBV//le+HTO4weumn+UT8pq+SkaCg0E6y77miFkZvLaCRLHMW6YBptWXHjk6Jj2ei4DtYf/q7LaLg43oAbFZNhvG2yWBQ5054/oLrtSQCnd0rd2gqPDs14qVwG1pSAOmMHKJn9KBEHgstVdqJ+U1QL7NTLmxS5aQ3iTQ9IOEj9ZIVBdr8qLEMZz871+eVYDF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbR51V24claVEMr1V/OTBQlbtVlgeE/y/mu3cojF420=;
 b=fB/rGQXJQn3zkI8G775iaSYZjNTxd0KkuJGxmgAuJMc20PtEDe6i40nvhSe4nWAA0bptBg2+A0npO1QxjlK8roWlPCEGRU4Qwjk2uADVTbni0+CT1SvsJFXcYK84nTvPnv+7FExzn1Sh3L2Ju66L8UE4Kk6mrfN1bd8NYFZ6+c2Ys0S5rG1jB8+TwidO7Rc0FY0xNQ2cv/x/hAsBegBzLWDRK2MhFPClZe0Tht4qC1TronWCVxMYRFkmhMZgQsWdEKgkn6ghllfhlyix8rt9K+Pjn8BMdZNM4CP/kJN8/dH/+CwRmGmlqa3beAyeg8nMDTean01jIbOduOHj9WMfDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6534.namprd11.prod.outlook.com (2603:10b6:930:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Thu, 14 Mar
 2024 21:23:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Thu, 14 Mar 2024
 21:23:46 +0000
Message-ID: <bfde1328-2d1c-4b75-970f-69c74f3a74f9@intel.com>
Date: Fri, 15 Mar 2024 10:23:35 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhang, Tina"
	<tina.zhang@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Yuan, Hang"
	<hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
 <20240314181000.GC1258280@ls.amr.corp.intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240314181000.GC1258280@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0308.namprd03.prod.outlook.com
 (2603:10b6:303:dd::13) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY5PR11MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: ccd077df-a240-4195-1e18-08dc446d08a3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52Pl8VS58M9eep2tW3qQ5HmnMR+n4kEpvvqT1EwD4Qa8s+255mYRYbFFjAetBNbA9WX45GgdCEj9ekbvomZdX/5bUMXUOgFvWNEOzAIPm0+0JTYcVUKLGouNXj/ioN6F4uIC1Y2+FiPAqMRXoJr2guk9C6WyxukhsfU+BFh3EVzO8SiEXbQxZ1aUIgAk/jis4D6tjyYk2/f0oT/rYR4/yMabOdqhEPQXoC1h4MM8Qe/apnATUEvk9wlf/Clpb8sQsFnNhWL1PIo6CKGcqaBnviJJfuVLId/K/Y5SZ9QxUtKkj+y1OyHcz418c68hkB7JQPiZIOn4DKMwLk/aXG04WsHIQJSSkqsGdEaigHz6nOxcuvawTShB83FTvvbxSBmyChpQ0nF3FnbVdtyr9wNnu8UUxopa/SxYVRQSmmhBB21M4TRWHRGhwEH6KcY2Dp1d2HMAiJfoEyv+2Ycsik5uzbPUW+Rll+ePYsu55HhcMlvNBq4fSFj8ycTRHpjNayvJkcoRIYSkF83MY4JHUFrqevHQenyONI5NED5WtPzvejd3f+DJzg8o/x52I9P6GjHwkqPwzi44fI+TKTsYBq+6LahSCfSfJ2kGgDD7eqx88vF7NCA+IS3dQv512PsP2YHzZVyWTamgg+8369MYdBHPBLH3p56ImwZo6z9pdFnOPQI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGtQV1k2UFdUNWx5SzJZNWczY2lZS2tPckkxZG56bHQ2UHlhTmdwbDkya3h3?=
 =?utf-8?B?V0c0OFVYY01BemM4Uyt1M2p2OW5GeWFYbzJJNHdnUmU0MThyNjJVRit2WVc2?=
 =?utf-8?B?azZEdFBkaEpuVW9QVG1TWUJ6U01lQnBqcVdyZ2ZrWklUOFFFYi9VYXdNV3Mw?=
 =?utf-8?B?NVAzTWVONm1UejRHN3FPdms3STRPZ3NWNGtrM241aVBEbm9wN3E1eGxGYS9O?=
 =?utf-8?B?OTYrVkMyYzVGdFNKWDdnUjRPQ1pFOXhxRGlvaFlsZVhlc3pLekdSSy9XOTgz?=
 =?utf-8?B?S3V4dFhpM1gxRExFOWpLRzI2RmNVSHdqY2VrODk1cTdOQlMvRHNYTHZxdXd0?=
 =?utf-8?B?UTBvcXdXVHI5Z3NOSEFpU28weDZQRlIxYUZLUEtaSDdKZGcwYnVYU1pkb1F3?=
 =?utf-8?B?YzlrT0M0Y2Y4NTFTYWtvamtvWFlQSHd1bEt0YzFqdERDbENBcFBNK0FVaW5O?=
 =?utf-8?B?cVEzT1RiS2xVdEFnVm1QQzZIS240aEpWUGhnb3Rac3c1RTB2MXh1ZlRESnhO?=
 =?utf-8?B?UTJQb2gzMFJYakM3ZXF1dkRtcGoyem5xbWNpRi9LUUxyazZDZzNWWFBzM3po?=
 =?utf-8?B?cllaN3FvWWVSdjZETE5LU1ZGakpHd1BrOVAxb2tHQTdDVzZYK3V0QyszVjF3?=
 =?utf-8?B?YkNGVTRNc3BxemROaVl5dGhMZWtOTFYxR1pYeWw3VGlXVUtIMDAvMUdoRStL?=
 =?utf-8?B?eEN5dXdHVDJubW1rN09XOWxpaXVQMHR2My9WUHJBeW80T0kzMmJ4d0dZMzh1?=
 =?utf-8?B?NlJnYTV3ZzdaRWViclZvUEcxM3RRaG5oSkNwTXQzMkZ2bXVNUGU1TkJDR0dD?=
 =?utf-8?B?UlJTQms5ZndoVE90c3VqQmVVR3NTR0RiNkZpLzFlcnEvd1dFQjFkNFovRHM1?=
 =?utf-8?B?OXF5OVd0NDRxZ2g4cnRzc2JUakZIK3Z6WXBjQTNwQUhoOWpMc3BER1d4QXk5?=
 =?utf-8?B?WkswSzZFK21jZTNncTJpWnNoazc2d1M1MzVsRitOUFU0b3l1a0tkdzdjUmZi?=
 =?utf-8?B?enFUdmJYYkx2MFRWT2lpZ0Z3MFYrMEVQR3Uvb2lzZGpoek8wNW5sMCs3L3Av?=
 =?utf-8?B?RmwrNGlGQ3RGN0svblNTenJpYUZhTzhGb212aHdRQ0c3SzZUbGpKME9pRGRN?=
 =?utf-8?B?UVhyOVU2M2pJVFBaTGN0cFd0MmZncEVoeFdTNTF4MFdUd3piNktjYXRkRURj?=
 =?utf-8?B?VXJMUzJhRm9wNWZjQ3dmNVc2YXRaNDlQbzFqSTRETlZRVVArb2R2eE90UTBP?=
 =?utf-8?B?c214eVd3WlB1WERVOVlyN3M2WDIrN04wZzZBeENXSkhBM3RPbnJwVGR6SXJr?=
 =?utf-8?B?MjdrMGNlQ3kzVDVBMGlzR3Ricno0WC9LbHZTUzFRNEx6Wm1OUWQyYk9YWGRZ?=
 =?utf-8?B?OGRHb0VSTEJkZ2ZlejN0QU1qTzBzbUcxV3FzNzczYUxqOG5vTTFZa0ttazV6?=
 =?utf-8?B?OXF6N0NBcm1aMEZ2bzBnazV5TC9DVThYWmhVUDFmaDRFeldNVEliMHc4b2JG?=
 =?utf-8?B?NE45eFZHKzQ3UmpGV0ZJdFNqSWxVUFVjaS9qZHNMdjVMMUxXUDQ3Y0FHb0sx?=
 =?utf-8?B?L1lNR2Fpak9PNVdnZ0p0T2Y4YUNkeDR1MWxnUDRhL083MG44cSt2WlJxRHpi?=
 =?utf-8?B?UUZzenU5V285KzRPM2Vybis4MDFUMmJIRUFqY2d0RXE3T3Y3QU01UlIrQzMx?=
 =?utf-8?B?V2F2QTdGYS91a05uWVlBRXhHczlYRWRTZFRQZ2F0eUtiMkl2R3JmNTg2MFFG?=
 =?utf-8?B?b3ZVWWQwTVRUc01PcklVOElJUzlHL0xFUHBNVmRJbTU4QzYzTFlpK1BvM2ZG?=
 =?utf-8?B?Z1RwRnUzenVTeU03eUFGemdxWGV5b3ZLZS9uUDdiTWY1YTFjenpXaExWUDdn?=
 =?utf-8?B?YWdsQXBuUi9oY3ZHaTBzcERKZi9uL1BFODZkZ0JkcXV2SlphVmd6cVFzeDZs?=
 =?utf-8?B?RG4zWUFCWXNSQ0xGTVljU0dtVlhDMEdRRVJlNFZYYWRhamdXb2RKZlVEbUlu?=
 =?utf-8?B?bjJVczBPKy9VQld3MElhZWlnVnNBWS9LenNtMk5WcDZTZ0lveFVuMVhyTmZF?=
 =?utf-8?B?QnAxd1JGV2tPZjVLbkVGL2VwREhaMzhkZjJ1VWFUTEYzS2FoeStQazBITk5B?=
 =?utf-8?Q?2q0rqnJ4vPyYFmhSck5UxmLwF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd077df-a240-4195-1e18-08dc446d08a3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 21:23:46.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: otxABHsfth0uaGNpqEpCjtmF8GB0UZ9MtibZgLaQyHAYvOlkyfNeI+dPmdOAZ2IKmDDx3oLP7Az2Sr/zgaRwTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6534
X-OriginatorOrg: intel.com



On 15/03/2024 7:10 am, Isaku Yamahata wrote:
> On Wed, Mar 13, 2024 at 08:51:53PM +0000,
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> 
>> On Mon, 2024-02-26 at 00:26 -0800, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> For private GPA, CPU refers a private page table whose contents are
>>> encrypted.  The dedicated APIs to operate on it (e.g.
>>> updating/reading its
>>> PTE entry) are used and their cost is expensive.
>>>
>>> When KVM resolves KVM page fault, it walks the page tables.  To reuse
>>> the
>>> existing KVM MMU code and mitigate the heavy cost to directly walk
>>> private
>>> page table, allocate one more page to copy the dummy page table for
>>> KVM MMU
>>> code to directly walk.  Resolve KVM page fault with the existing
>>> code, and
>>> do additional operations necessary for the private page table.
>>
>>>   To
>>> distinguish such cases, the existing KVM page table is called a
>>> shared page
>>> table (i.e. not associated with private page table), and the page
>>> table
>>> with private page table is called a private page table.
>>
>> This makes it sound like the dummy page table for the private alias is
>> also called a shared page table, but in the drawing below it looks like
>> only the shared alias is called "shared PT".
> 
> How about this,
> Call the existing KVM page table associated with shared GPA as shared page table. > Call the KVM page table associate with private GPA as private page table.
> 

For the second one, are you talking about the *true* secure/private EPT 
page table used by hardware, or the one visible to KVM but not used by 
hardware?

We have 3 page tables as you mentioned:

PT: page table
- Shared PT is visible to KVM and it is used by CPU.
- Private PT is used by CPU but it is invisible to KVM.
- Dummy PT is visible to KVM but not used by CPU.  It is used to
   propagate PT change to the actual private PT which is used by CPU.

If I recall correctly, we used to call the last one "mirrored (private) 
page table".

I lost the tracking when we changed to use "dummy page table", but it 
seems to me "mirrored" is better than "dummy" because the latter means 
it is useless but in fact it is used to propagate changes to the real 
private page table used by hardware.

Btw, one nit, perhaps:

"Shared PT is visible to KVM and it is used by CPU." -> "Shared PT is 
visible to KVM and it is used by CPU for shared mappings".

To make it more clearer it is used for "shared mappings".

But this may be unnecessary to others, so up to you.


