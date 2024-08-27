Return-Path: <kvm+bounces-25212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C157E9619F7
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B9A21F247D2
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ECBC1D4156;
	Tue, 27 Aug 2024 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZjwhKvyS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A9B199E9A;
	Tue, 27 Aug 2024 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724797255; cv=fail; b=Z987DLYWhTKZVJtX1sh7Mm9tnIlo50am+J45gOXgwfre3A5b8+SXWx38Q/YYKxK8e/EbObyXxiHfrGkotbgneOt1PPHvtHJbHV6XQTaBGUzz46uZfDEN+SIEtEPjZqVpsIZ0CE3zMMXsDdIBCtFs3Gul5UjHODCi/rLEnUftrPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724797255; c=relaxed/simple;
	bh=GuQ3sDZlKBa43KE07ysJc+b1fkoW36VwXkEl6um+AoU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lZD/GdDdFUk24A7LI7hbwLChJ/gFu2AQ8XDpoRbzhs/xste9YdelWdU4Jh/+uNJ7HR93Gzn6zATtCawL2Mi7VVIV6ZCrZaffK14GftSjoM6AJDFyr3ZAP0Tm91CzKZVk/29MIAw2BOLadFQdFNRrczLD2g9RB4YLXsaW0CDXs9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZjwhKvyS; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724797254; x=1756333254;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GuQ3sDZlKBa43KE07ysJc+b1fkoW36VwXkEl6um+AoU=;
  b=ZjwhKvySG+0+J6zsIEKBmxqrng7YaBTq2clfhzZkSxLafS2b3mjsnSCJ
   L/PxLYBUlGWxBeXZT56nPiZrbNI7djG3r6UpbSBpY96sDk030lSNCZeZ+
   /RQyIfJg5SvYWp/X7Yehe4+obr3XoAQUIb7qz+JH+1qwlMtdko+xKNiQ+
   ZkoSmwBCs8f4q3INrX6O7X1xGDHcDwIRYlRC2dVEK7ZO8bWGjKoHyluIm
   jbG4owiApaQP/FXZcC0MAbe+G2XVyaYclB4r4dSKqa/iHRrURsH5U4wKU
   NJsI5chNMe3/7M2KkTgPe+h7XrsSombl3V9razjpmQPxVd6aUTVG6HyX6
   g==;
X-CSE-ConnectionGUID: AkUDEVTfSVuAD1e2DUOb8Q==
X-CSE-MsgGUID: Zf06tBCfTvmfObh2XeE/TA==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="33964274"
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="33964274"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 15:20:53 -0700
X-CSE-ConnectionGUID: gxrU8LQySkaCatRmTB5HhQ==
X-CSE-MsgGUID: wY5+irQISFmbki46wEOJZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="63732638"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Aug 2024 15:20:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 27 Aug 2024 15:20:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 27 Aug 2024 15:20:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 27 Aug 2024 15:20:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDUNAXFixablSnQcs+Mvjp7Jj5lUO9Mg08leXwZ6LxFhh4WIIIeaxZicPcMBVRtUgVAz8wOUW6/nfBEv/Nyteu3xpexe4XWSf3mSLRHOjgocxppjZ3jPF5cLDqBfBfDLDJbaEAkbTf6Uh3t647Y2HJfKxJAUgcvLJrfD/clz6OvhBRsA0iUemBfw8FoRVJcKpweJQqCb5UouSdPIZzT/XliOFgXkyciJKqFQa/v7ByD/S3HDVp28ibpCjs5To8d/U/EDXk7ivgDQrrfLnnst/aHbgg9YZrp2XzVfuimuNlZJvasZgaTq6Gvc7EguZiOxQbzXrjw/PScmtzrbwbdzGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0WJUF2M47rXmNB1yPAi+CK7rH/SnTUYcix/lG49yt5Q=;
 b=U1eEiigAosaOVghtGkvzMxrbt53FdAnyspj5O5rGu8pHf2dupZtlhspLSCGrk8MyjoxT/1z+MM9fIa2NsvMEvnsCqS4bsfmWzGCszwcgKscnldqBsYYR+grcOQ/TuLP/zF09Yu03INuA3ttXOUtl7iBUIqb3g87HBxztRxP+0K44ghpjMmgXw90jxHESv5HxGaWVrkLWcRk+2pAxuZIbVV2j37oJZmQGGyo/nj0u6LAamF59XOQ9ZK0ipLEHz/IMnsV+vHeU9G2uEgN8OCr0liIOs8O4elxCZFjmfHpQALfWg4Vj52oI7WWkSI45DYwFlB7ABeEoaw6Trb9LQPAfMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6839.namprd11.prod.outlook.com (2603:10b6:303:220::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 22:20:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 22:20:49 +0000
Message-ID: <2152e96c-eccc-4e96-b658-70cc59dfee68@intel.com>
Date: Wed, 28 Aug 2024 10:20:38 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to
 reflect the spec better
To: Adrian Hunter <adrian.hunter@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
 <b5e4788739fd7f9100a23808bebe1bb70f4b9073.1724741926.git.kai.huang@intel.com>
 <1b810874-2734-4ca8-933d-ebe9500a8ddc@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <1b810874-2734-4ca8-933d-ebe9500a8ddc@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::10) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW4PR11MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 84432782-e7fe-4f61-50c9-08dcc6e680db
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eWUrMkp1akx4TmVaZGU5TXA3TFVzWmJjSml3eXM3VDhOUi96Z2x3a0VETUox?=
 =?utf-8?B?R0lFdlpRdG5GdWpFR0ZxVjNvL3lqSUdpQTU2dUp6SzFMUm0rd1VuY3Q1V2J2?=
 =?utf-8?B?eVl1QzFOS1cxNmVjTUtJL0NsYnFyd2VnUERLb0UvMFk1eitGSW9OV3Jjb2Vz?=
 =?utf-8?B?RHpQZHNWdWp3QkJSKzZvQVFvcVM0YVFqaktlNDI5b0RjMDEwTktRTnd6Wnlx?=
 =?utf-8?B?d2hyZnV3aG5uSnF2N1cyYkhjckhmamxzeUQzZlJoMCtzS0ZmZm5ZeEVRNDBm?=
 =?utf-8?B?dURVM20yc0lJSThXV0pIRGdNTkl3aTJ2aGZlTFBadWhzSzhzNmpYMjYyemlV?=
 =?utf-8?B?NGxrbXhWUUdtUTZLYnNkSEpRL2FTVVdkSTY5emtVWG85K0NDbXgxKytTQkVD?=
 =?utf-8?B?NndxR20yMTdBTFJEcEoreDZCdFZTS0FLdk1Eb050M1JPYTByQkVQNlJXT2hq?=
 =?utf-8?B?bndaVjUxZjMxbjdVOEloQUJiNnc2S2VGSVVtN001Ylgra3k1akRWaGFLTy9u?=
 =?utf-8?B?MGZ5NGV0RlpVNGVxRXdoVmNHOXl5cHFsQjJwSzJqZ1RPeVhHWXFSeTd4ajNV?=
 =?utf-8?B?cWFNTTBMRVFFVkJ5a1p2L1J3a2NxZDlzS21NeXppWnhqTU1xRlF6bGdoeEtI?=
 =?utf-8?B?VFkvNUJleTl2R3dKUW1aWW42QmtzTlJ0VSs5SkhhdHVhZ1VpWVpMamhBZDVQ?=
 =?utf-8?B?Vjg2YUI3cGxxbWRvTC92T3poZjVHVUw3em5NSzk5cktoWDFlKzZiby9VeDMv?=
 =?utf-8?B?WTQyUTN0SUtJeHl5RzRGOUdGM3dXR0JsSGgvMmYrWmYzeGRHNlh5aXIvWWh4?=
 =?utf-8?B?SC9MdGlwMVZjL01vNzlDeHBqb2ljSUZXTTVKSHJrV2VCOUV6c0t2V01NbzRH?=
 =?utf-8?B?dGh3bnRsb3lDVVdCelJlc0ZzN3E3WE81VlFpcndET29ocGlWWU9mYjR4MXVH?=
 =?utf-8?B?TnlEMUR4aUROTWNIRW9MTG1SYnlZbWQ2TlpJb3FTQ0R3OFVTTyt4NTk2c2dP?=
 =?utf-8?B?UTRxalRSYVhiSVZ6R0FCV1RTMy9MbUZFL2huaGgvYnFJcmFYZ0l6ekd1dXEx?=
 =?utf-8?B?Q3UvNGFNMmxxTXNlMTZndzFBcGtMd0VWNzlCaU1UdVVKdFRJWmhpZXovL2t6?=
 =?utf-8?B?R0NYdkhlRmNZeDFTelRYK25XUUtxbUQ2d3ZVOGpxWVphV2xjRW0zZUpCVXB3?=
 =?utf-8?B?bnM3cWNid0FSbFVKUTRmT3A3ZXVPU0V6NVJNN1JYcnIwL1RjTXRjMjdZcGMr?=
 =?utf-8?B?cGZyYjNMbkFXQTdJSWhDNlJwSWIyaUIrbEZKY1A4M3dFQmp6ODFVUHhJck5j?=
 =?utf-8?B?a0g3TE9BR09ycFVrcWhUd2lyUWZ0OWY0ZEtCMzFpZG14WWFzb2hvMkJTM3hP?=
 =?utf-8?B?NDJLOXZXY2lBaEVUVUZzcGNnZVQ1K1Ard1UzVjVFYmp6eGFQYVBJQkVROTRY?=
 =?utf-8?B?NDcxM3JKU0dtNmlRZjQ0em44MzQyM29lWjlEYU0zOHkyWDRQNmRjSExGSTJH?=
 =?utf-8?B?TGF1Q0tmaGwxM1k3QzkrVDVNcG1NY3VyUmtCRS9wUUowSVl6MFduOTdrSyt4?=
 =?utf-8?B?VGVRV0l3dExNTTFmS0pKcENwUlpiRDFNTXQyMHUwd2pSMXY5OERUbDNOb05S?=
 =?utf-8?B?ZG4yUks5dURldzdZWG54TFFldlFPWmFmMUt6VldYMnlQWk9Zd0Ftb0cxYXJV?=
 =?utf-8?B?Z216QitENVJ1MDR5bmxMYndlQXF4L0x4U0tXbm9CTThVdFFsemg4eC9zQ1VK?=
 =?utf-8?B?Qlk5b1VnekNRTUJJcldCS25GVFdDY3FNeEN6TFRaNVV6WVhxUWFLR2hnY1py?=
 =?utf-8?B?TjBtRStxWEUyc24renhrU2J5bmE4ZWJ3WjBvY3hNWWZMVFBVTUJyY2dNTHdU?=
 =?utf-8?Q?m1NvKR/Y6IvNJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjV0c1p1RldWYmRjci9naUFwYm9zQ1RCUWdDWUtuaDNtbzhSMVVyWjV2Z2k5?=
 =?utf-8?B?eHhGVGNncE1WUkFscDJPRWFZTDIxdUFsL011MTlUSzZXWG5WNzU0VFA0eWJt?=
 =?utf-8?B?dmgwMG14V3Vkc0Y3WWthdmU0VW9jZ2FNL2U4VmJCV3A4NUd0cU9PWkNBbzVI?=
 =?utf-8?B?cGxPUWlINWtvMVlnUWxoWUpLaXZKaDd4b0hjcUJhSUlvK2hFMzhmNkFIQUM1?=
 =?utf-8?B?M1R6bjNQaENZV29SSzNWeDBIZzlTL0FuOThRSjl4YXhVTWNNQWJPNEZTV3JV?=
 =?utf-8?B?c0pjWnhhTStEOW1YcnR5bXNCVUg3ZHM4ZmVkZ29RRDlOcDgrQUl6cE5KWENC?=
 =?utf-8?B?ZEZsRlhNTE82OFd3L1lQdFRNa1cxTW1uVW1pOGRnNnRlTkF2ZGNZRnI5djVt?=
 =?utf-8?B?RCtwV3JnanRBeHhZaUJaS2REbnR5T1g2d2hpVm0wTHlPRWQvNE0rZUYxKytS?=
 =?utf-8?B?dlkrRnF3dkc2OFZEQ0tIMEdBOGp5dmxQcmh0L1Z5RVQ5ZHBqV3k1S1h1bmtx?=
 =?utf-8?B?R0thajFoYUlncy9ROFhneEtRaWRCaUEwMFRheEZQMWNldVlBUEw5MjM1Mk9a?=
 =?utf-8?B?d3QvNDFCVC9tMkVPMUY4enZqZVloOFhGM1JjRk53NWttV3JST1BZeUpnMHhv?=
 =?utf-8?B?UmF4eDRSb0JsOHpvOVFJS0xPTSsrb0FWWjhRODR3NXliV1FBdGJLS1duMEdw?=
 =?utf-8?B?V0p4V1JVQ29lbkYxcENuSGw2dGRMOFpzODNHTm5IcGExQzdySU9LMm5hR3Ay?=
 =?utf-8?B?a1dmNE8rZGFvNzc1THRRc2t3UUpCRmc3MnNFVTdZc0xVenBTREVGZEJNV25v?=
 =?utf-8?B?a1ZiRmc0Z0ljVG5OZElVcHlEd21HVFhGYVAzdDltcWl0bzlCU2VVSEFZNVNx?=
 =?utf-8?B?S2pMQmVEdnF1dWxFbEt5ZUhDMkwwcWlwcHE0UzhlekQrMnYzL2d6R2RUdWRR?=
 =?utf-8?B?L0tXdzBzS1FVUFZWT3dsdDFnMnRkcU5lNEZqbmNnZ1FReitjS21Ma3Q1NzdQ?=
 =?utf-8?B?QjF4L3VDb1JXNDdydG15NzJYT1YvblJjK0RaaVBLNXNTQ216dHBNTjBDRDh5?=
 =?utf-8?B?QTNtb0szSnNZL0xIMGdiR2k2RU1qZFM4ejFrNld2OGtldVdGVkVtRlpyM2R0?=
 =?utf-8?B?L2xtK0x2bHBTZ0EvZ3VOcHFzOXBKZG5kNFVUaHNYSVFtMmJwQTJ2d2J4SWxQ?=
 =?utf-8?B?L0tuRnRDUEh5aVZib3hjckF5OHMzNlVBMDY4RGF5NDdVUTBQUmZXM2ZBeGMx?=
 =?utf-8?B?Z2psd2hMM2FiaitaQWEwNU1pVWtIYlRXVGhyakZuMFd3NzhHV1B2OTh6WGtJ?=
 =?utf-8?B?Y2swSUVaVHNBOEZ6ZldwZ0crRWRrY2ZYVkZNWDg2NHNzSVNzTHNpeXdFcEhH?=
 =?utf-8?B?UGlqZFY1ZEdvY2pSVXRJMTBoU1YxQWhZb3MwRW9xTk84eWNtVTRSMU9EYkIx?=
 =?utf-8?B?V0czQ1hDZzB0UzZGWkZ2YTg2UTRNczd2WUEwc05NbHZrOWhZME9QRGsxTHdI?=
 =?utf-8?B?bmRzbUxRT2oyZzhHckdDaFVDTWgvUkU5Q3JZeisvU1JMNEhidkYxQnIrOWhF?=
 =?utf-8?B?OGE4MTBpV01LditaTGtFKzFnYllUZldoT3BjUkZWTGJNaTNqb3o5T3NOand2?=
 =?utf-8?B?dkEyWkM0OUVCZnB1WG9odkY1TEpEZlE2S1l5cXBsbXVxY2Z6TXF0YkVlaExS?=
 =?utf-8?B?ZnZoNnVBcUlURStJRzh2OE5xWGdveDhYaWdBSElMYk5udnRqRTNRbmdEMTNK?=
 =?utf-8?B?NmVmRzhpQS9yVnpIM1FXNUFzU09jeVBETU9KWlBybEt3WU1UUWpUbVlNVTA4?=
 =?utf-8?B?bzBkWmJzL0x4UW5TQXpPZUxtQ1FGS2hzejRHd3l1YXRCZWVPS3NTSTRaMDVS?=
 =?utf-8?B?aVhoNjY4OWhLOTJPWkFxN0tORUhZbTlCcUNONUJsaGhGR0habnk3ekUvNXZ3?=
 =?utf-8?B?VW5FNFZMRGxDdGFSN3JvTUd0RUwrMkExblI5RnR3KzFFOHhwdUJnOW1GMDVC?=
 =?utf-8?B?cThJc0lQYVJQcDBJMnQ2aDltOFlieUM3NDFNZnB5dW1oR0pydDhYWXdhZGdu?=
 =?utf-8?B?TVFXNTNENllubmFNcHhZMmo4QlN0bDM0d0Mvc0pIbHVxYWhmMFpBdldIZE9h?=
 =?utf-8?Q?SPvNiGRjUahUXt+S/WwSXUpTd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84432782-e7fe-4f61-50c9-08dcc6e680db
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 22:20:49.4687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6LuNZqtUP/TFSKFspJPInBUBDIZb7WXBIY1ZJdELO91V0tBbDx/volAitbPbeQAqNt6/LTt3IDFt7lXWz+S8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6839
X-OriginatorOrg: intel.com



On 28/08/2024 1:10 am, Adrian Hunter wrote:
> On 27/08/24 10:14, Kai Huang wrote:
> 
> "to reflect the spec better" is a bit vague.  How about:
> 
> x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to 'struct tdx_sys_info_tdmr'
> 
> Rename 'struct tdx_tdmr_sysinfo' to 'struct tdx_sys_info_tdmr' to
> prepare for adding similar structures that will all be prefixed by
> 'tdx_sys_info_'.
> 
>> The TDX module provides a set of "global metadata fields".  They report
> 
> Since it is a name of something, could capitalize "Global Metadata Fields"
> 
>> things like TDX module version, supported features, and fields related
>> to create/run TDX guests and so on.
>>
>> TDX organizes those metadata fields by "Class"es based on the meaning of
> 
> by "Class"es	->	into "Classes"
> 
>> those fields.  E.g., for now the kernel only reads "TD Memory Region"
>> (TDMR) related fields for module initialization.  Those fields are
>> defined under class "TDMR Info".
>>
>> There are both immediate needs to read more metadata fields for module
>> initialization and near-future needs for other kernel components like
>> KVM to run TDX guests.  To meet all those requirements, the idea is the
>> TDX host core-kernel to provide a centralized, canonical, and read-only
>> structure for the global metadata that comes out from the TDX module for
>> all kernel components to use.
>>
>> More specifically, the target is to end up with something like:
>>
>>         struct tdx_sys_info {
>> 	       struct tdx_sys_info_classA a;
>> 	       struct tdx_sys_info_classB b;
>> 	       ...
>>         };
>>
>> Currently the kernel organizes all fields under "TDMR Info" class in
>> 'struct tdx_tdmr_sysinfo'.  To prepare for the above target, rename the
>> structure to 'struct tdx_sys_info_tdmr' to follow the class name better.
>>
>> No functional change intended.
>>
>> Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com

Thanks for the review.

All comments above look good to me.  Will do.

