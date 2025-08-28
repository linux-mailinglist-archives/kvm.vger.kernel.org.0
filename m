Return-Path: <kvm+bounces-56197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C912CB3AE56
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 01:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8389B4656CD
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5662D0C7B;
	Thu, 28 Aug 2025 23:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TotITb2p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9B5262FD3;
	Thu, 28 Aug 2025 23:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423049; cv=fail; b=EYwDxJpHOBdWw2sO7q0Hh/LN2EGuKxZvA6dGelH2r/aDfSCcP5jPWqxvYDA/X+WGDF3U7Pom+4aJfzc0VTMDJdITWef5IOHyTc3bvg6QfwjlbYmK/+fIed5j+kKig9Ph3VhEaVpQaaZQfTb/qlEnktMqobSOLr6HoWIKhtFTSB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423049; c=relaxed/simple;
	bh=H/RNG+3700lzWFJ+e9uoElrHpyqi5fKyhNWTMGk8eSo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C05abGFylAmgk/bJ8q6XG7g1/rSUsdBjcrGAesnSL82I4ZDuN5Omvbny6OIxVngFhB/LV134yFSDB0YVJWlLy4jtXoLxHSFzWaHXlIVbYkYnGlWXQseTeCijoapT1q3+awUbIGd++KeIWLYMDCGSS2HdbBYCfYb5bE37qV1a5Ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TotITb2p; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756423047; x=1787959047;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=H/RNG+3700lzWFJ+e9uoElrHpyqi5fKyhNWTMGk8eSo=;
  b=TotITb2pn/OSWq4NGM/n5jg8rYC0EIqSokhRV7y2PNZgh9ibS4sp8rlY
   Cb5U3DTUimJoPMQnKz6bB4KHwgccvGjI95fyl8+jqygoP50qfQMS6JHIz
   4E70pUvdZSslHJf/jUg+9TYUPufLVm6QN7Wf5NgO2haQx+8eO3bj/gmQ+
   HkHs5iJ6FY6eYNiJ7XwFp2iZ1e5GrOtM5QtxABSmH90VugSZne2ns3g22
   98eyxyCuQjTiEZLDa2HX1aSqM0JdRcX3SoB7jXRYik1SnPjjJe5Wj8up+
   wbG3s/Z/vbVgPuB7cz4DPPxoULBUNPfJpiY822XipwQlrKPo7Uk2eKWN3
   g==;
X-CSE-ConnectionGUID: fQ9qYlgoRHuj7d67TOTxAA==
X-CSE-MsgGUID: iYuE610iR+2pdw3u/rsZpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="57733037"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57733037"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 16:17:27 -0700
X-CSE-ConnectionGUID: 4irdAAyeS5SkeMIaAqxiEg==
X-CSE-MsgGUID: c7jTQXadR02dm3OhDElCsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169814462"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 16:17:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 16:17:25 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 16:17:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.65)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 16:17:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZitqHalHi7KZ5lKoWy5bDnYFScdZ+56pg/qnlBWq70Z6yBQpSrb7gSnZdF77odtNV4ipel6nVpf8Gt5x/AWITkNb5TUSlwF+pu2CMR8HBbCBTFdZSKd9H9eXvNk0G6uL4yLN79KmPLK6ySsjhkUoDEC/+Z6PvuCmWi3z4hldY0mnQJQvIXUP49SUeNpKwFgeBgIXNsIX03+tac1oD19J9l/x1RVflnSUZKjNrqApQVOepHEDbDOWD55YSW/Vc+m5vV8/AnzxrUmKyTtbH6t2flRBwi0QaMQTB3exST6rR5k/UMkqd39JkcTE7FDZGvp+ZyTxxa/CD/J4hBuAONXIug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/RNG+3700lzWFJ+e9uoElrHpyqi5fKyhNWTMGk8eSo=;
 b=Eyljwq0HXjsmFtl4UXRKXOoSd2LZHXLGU5CHKuJduoD9gcn0nY0T5PDorX2lu6k4agjRpGhwf1DDnwZje3xpN+9o6fdFgRasgTJnYsjJRrG9WEK6YH8E4XqcRrki81HfpNpmhWSRs4RcYzZ6MDngrEu5dOBLf7tFbtGCv0QUK1ieE1S2pGWy/p3mL6vFs9PmZeztNpxqW18QJTeh3MiHFVKkDbd8B/K0YUn5TpJk6CPsGgerLMA/io4AQihrGbMi8K0U+T1/edasYFViNM4UGlknKWsODjxkR/zJZOgwHYAyoqcmwP1qhZNULMxO9ksIcagASKoOWW8J14/Lua5+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ1PR11MB6082.namprd11.prod.outlook.com (2603:10b6:a03:48b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Thu, 28 Aug
 2025 23:17:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 23:17:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
Thread-Topic: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Thread-Index: AQHcFuZaMDeZr458G0eulsQOyqpL0bR2NLWAgACpbYCAALFgAIAAvTMAgAAfRYCAABpugIAAEqqAgAAGq4CAABY/AA==
Date: Thu, 28 Aug 2025 23:17:17 +0000
Message-ID: <12b2b02b58b2262cf58f047a40c9af1d11bb09e7.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-10-seanjc@google.com>
	 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com>
	 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com> <aLCJ0UfuuvedxCcU@google.com>
	 <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
	 <aLC7k65GpIL-2Hk5@google.com>
	 <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
	 <aLDQ09FP0uX3eJvC@google.com>
In-Reply-To: <aLDQ09FP0uX3eJvC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ1PR11MB6082:EE_
x-ms-office365-filtering-correlation-id: 0b39593c-2e7f-4e1c-bb52-08dde68907ca
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0RzWFk0TkZ3MGRsT1JsQ1JPMDRNZkpqK3V4NlpGaVlkN2R5ckQwemlPMDdh?=
 =?utf-8?B?bXVkWlNQS0hvOEUxNlJJbC91Q3RnR3JaUkMvMHpKQlYwRVlWRDdFV1prcWtQ?=
 =?utf-8?B?UE10TlR3T0RzdkNHUFRZZE1rYWpxSXVQcFYyR0hoejVFaEQvcjZlYjFvOGVE?=
 =?utf-8?B?Mkt0NWRBT3c3V3hhL214aGZwSlZ4Mi8rRmlGREdNOENzRGJLSWxreC8va3Vo?=
 =?utf-8?B?Rzh2ZUFjQTNDaW5tZmo5SEVGVFhzTUhRM0RlVE9QMmw3LzV6MDVGUUVVQmd3?=
 =?utf-8?B?R3BueGdHbklvbE1qbUxwK1k1QW5TSC84WFY3OTdOZlEwb1ZaUlQzQ0krUXFP?=
 =?utf-8?B?SnNuR3ZOV1ltcGpmeWpsZnBJZjE1MnZwWisvMXJKMCtpQmZrcjBvSG1telRV?=
 =?utf-8?B?Q2h2MVhpYWxtTEF3K2hGYmg1R0pZQzdIeW5qNkczWXIvd1NabVZxaWhTVkdn?=
 =?utf-8?B?bjJvcG1NMVpSeWVDODdOam1SSkdwc2pHM09ITUh0eXRPcWloZjN5WXhxL3Rz?=
 =?utf-8?B?MCtZUlYyYzBYR0w2dmI0cC9na0QyVGtodkVWNXdwc2NGck9jQU5EM3AyNk5D?=
 =?utf-8?B?K0hBQWRuZUhYYUtEbytVTUxRZnE5L2c3TWtVZzd6cG11S0t4clJLT0hRbG0w?=
 =?utf-8?B?V2hzd0RDSmhoM3lTcTdPc1ppd3JsbGx1ZjgyeVFlRXdsN0lKTEQrTGR4Skh6?=
 =?utf-8?B?NXVNZWpyYWRmcnhZZExqOWtaSFRtT25Rc2g1U1l5QWYrTmR3NzllQlJva3RG?=
 =?utf-8?B?Z1RheEJGaDd4bE52WXc5aTRCTGpPNUEvWGdUZXRTNGNJSXIydWFnMHlDNlBV?=
 =?utf-8?B?K3Jaenhvczc0MXd2S1ZpWmF5dGkvVmpYS01OQXdtN3d2VWdhcS8ya3EwdUV6?=
 =?utf-8?B?MmhCT3lvMlNiaUlnWFFLWWVDRUZVMVQvMXMyMDJzODlkQWJQU3lLNVNKZjcz?=
 =?utf-8?B?SEllbU1tWSs3eFJxZGdDRWpaU0NkeWE3ZVpabDMvcWpBMzFBcWtGc0doLzFo?=
 =?utf-8?B?Wmw1YS9GbkxYS1B2OW1wYnJ0Sk1CUW5uSVZDN0t0eW5GWEYyQUlCdXY3RUVi?=
 =?utf-8?B?Zmhvd0VYNHFrR2JOSitzcFFmbnBFUTJkeHRZeFVsa3M4aEpqTTNEdTJOQ1g4?=
 =?utf-8?B?bTJ6cjlPYTQ0RGRFaEVvSDQ5ZkVzOUtWRXRKbDAyVmJTUk81YlRmZEFhK05r?=
 =?utf-8?B?eXplUlhraXpTK2NSY1laRWFYVzhJS1M3dGVCU1lLNVU2NkxUZ09FamVwTXpY?=
 =?utf-8?B?cHpWKzk5VkdwT2pxTFBQMGIzeUh2SWJ4bTZEVWsxQTZwdlhJdmJ4ZDdmM0lF?=
 =?utf-8?B?NUJvMVZydVgxYjNwdk9aTDN4dzk2M0t2b2ZMZVo4K09rV3BwK1hrTXNRRkJX?=
 =?utf-8?B?MUljZnRUbG90djFSRXZEMVRrOHpkWi81a2VYak9DVnNCc2dYZmtlaXpPdTRO?=
 =?utf-8?B?WXQ0eFcvQXNoSnN1bWdpQmVxWTB6U003aWcwM2I0TmV6MDR6a29VYVh0Zm5u?=
 =?utf-8?B?SlY5a1h0aDJ0allIclBxOUowamdCdVB3Z3VDNkp1RVRqeDhyRWprUmJQOWIw?=
 =?utf-8?B?WTZmNG4zVlNEQUpSVlVkNzdEMGpxbVRhUzR0U0JCMDU1Nzkvc2ZPYTNRcTUv?=
 =?utf-8?B?L2w3RjQ0ZjQrSE93Q09nZXdLaDQ5QVNjZWhQTWJtRkt1SXNCZVMyOVdUVWNS?=
 =?utf-8?B?SnRTYmpIN0J5disxTXBZeERwcGNYZVAyOU1IbXBVQlAxK3p6cU9KdytBMzFu?=
 =?utf-8?B?amRDY0NMREkwWG5ldzUyZksxNXBwWU8ra3VpaThRZkRTNE56OWlnV29zaGxH?=
 =?utf-8?B?TmNLMTVpejRrbVkxT1RLY3ducS9JdjllbXVKSm95WWVPNERpTDM2QWRHbVpo?=
 =?utf-8?B?ZWF4NmEwZ1JUMXFBWWNMVUxQOXUyVDlHR1A1TnFHSTNOWmpCMU41OVljU1Zp?=
 =?utf-8?Q?EnUgN31h7gk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ni9IdERZL1E2RGZkSEdsOEF6bFNkTExoL0ZqTzJYMVQ1WERLMHF0aXNCYjJF?=
 =?utf-8?B?aTQ3T2lJVWRzeFpYNW01d0tOWnFaMkQ3ejBiVE9XWGlKcDBqazdWaTg5azhs?=
 =?utf-8?B?YjVSVGtmanNQby8xTUFWQjVnYnZXanpqTk95WnhmWDNpVG51TGpYemJiSkxR?=
 =?utf-8?B?UWtPMU5lK2FOYkk3bXBoZ2Z0clR0dEcyWm1sWEJEMFpXUmJmOXJIYXQwRU1o?=
 =?utf-8?B?Vmx4eTdaUXNxbWNrSkk0eUFDenpsakQzOGo3a1ZwOUJmMjI1MXkvb1FXODFP?=
 =?utf-8?B?K2ppSWJkUlhpdkxvWm5RTTNwd0Y2d3VqL2dwbE1HOWgzZ1lVY3hHTTNob2sz?=
 =?utf-8?B?bUphcDJJTjNqOFJGVk1CM2IxTEh3eU8vZGpSanNaWkFEVEk4US8xNWk3K204?=
 =?utf-8?B?bEdYS2kyNmRDM0FSOVNOb29kaWFnWU1oOVJ4MEtoZStCbkhtSFVsUWVsL1Rz?=
 =?utf-8?B?azRMQ0dEOVEwTEI0RXZsWHIvSHY4eFZFWkdkL01WcFBsbnU5cUpXVCtLeWEy?=
 =?utf-8?B?TFRpMFpIRHd1Mml6WEhUeUpBNlBvcU9iOEZkRFpFZUVRaG8yTEU3Mi9RU2d4?=
 =?utf-8?B?K3IvRGQ1cGl2WjFJL1lyVVNES1JJOVhIM1V4cGlkclBiTDRhV2JYa1pKVzVj?=
 =?utf-8?B?WDQ0SFcrYTNoSmNScGZlTi9FS3ZYZkkwSytGMncvTDQrRUxBTXI3WTdDSU1o?=
 =?utf-8?B?b0VRKys0bUtOdS9yRnVTU0ZRMU9MTktrRXVPeWtERTlWdEQwTzJSbnROY2h1?=
 =?utf-8?B?QnNLQWt0TlhaZlRDK1BZZzRaN1JmWm9JRWxDWjF5VTdHQzEzcjgyaEMybjRE?=
 =?utf-8?B?YzJ5aW4zckJpejcweG1ld3o4V0svU01oWG8vTTJ3bS9DYlRhbHMvR1c4bFlH?=
 =?utf-8?B?K3IrZlpSeTc3Um40dHlNcCsvenRrYThJbXhOV2ZoR1RUWWpKZkJZdldUcGIx?=
 =?utf-8?B?UEQybmJqQWJCSXcvLysyY0Q5VExMYlEzQnJZcmkrS3JEc280R3lGeXZaVjFF?=
 =?utf-8?B?S3d2VUNCYmdMUkRpQk0xenJxQmdKbkNMTC9IMDBsZGNTYXpSaHd6WXlKV1FB?=
 =?utf-8?B?YzgvQkZ3d2s4bUVyK0dqWXREbEUzc1dPdk82Vkc5aTdnV0VEeTJKcXBobmZp?=
 =?utf-8?B?VXFpdGlmVUtYcStkOUtqZFZ3ZGVWUHp6OUFzYkV1WmY5NGlUaVAwbUpkWVBH?=
 =?utf-8?B?R2ZJMytpcEhOM3U3SXdoS1F6WU5ub0lFUUJtNERNakZVem42aUVzSXRKT0Uy?=
 =?utf-8?B?Y2tKL0FyTEdEcm5rUzB3TkZ6cXFWdWRZZnpHTnNacFJCR0U1ZzRrUkhGbElR?=
 =?utf-8?B?R3BxVkwxWDFCWEdQSEdXYjY0K1I0RnI5REhXWWZGZHoyMGNwbVhtbUZyaThT?=
 =?utf-8?B?ZHBrU1Z4WWloWmFLMjBONWV4b082ampaTmd1TjM5Q0FCcGxQUVFjVHJSUmI2?=
 =?utf-8?B?OVFNYXpRR1A4WFhyMStlM3lueUl2UE5IenJDbGNCdHRDM1h6YXJxWEFnSTZV?=
 =?utf-8?B?NFVHRnE5WVBjMDFjY2RCbms2ckc3ZEgycTJuaGdUK0tURXFIeUZCanVOOHFJ?=
 =?utf-8?B?QVdBZDhsdXNFSHZYQmlCV3BWVDQ1T3c3eFVmb1JVeStCUmpmdmt1OXFMbFND?=
 =?utf-8?B?VktrVURPeGdDZGU1T0FpR1pScGtRY0Jjb3JPcVp5d2dZanA4NmZiWDFLeVMw?=
 =?utf-8?B?bTdOMEt0RlhiODhxNFovUERSTnVwTTZEaUhMRU9NcmJVSk1ySFhjc3BQZjF2?=
 =?utf-8?B?anEvNk5zUmQrQWozYUxwcmJESThuQ2c2ZGRiMUdqYm9majFDbXdENlhENzBV?=
 =?utf-8?B?dFYzeVpRMU9ib3dHb0c2aDlxRTlrOGxuL3R6M1NBNE5QanNQM3E2cDM0RUhY?=
 =?utf-8?B?S3l3YjJRODQrZ01yOTA2bU53NDJnenlHNk9JUlcwYWt0MkhSNG4ybXp0SE5I?=
 =?utf-8?B?TjJmZ1h1aWxUOEJScC84SHJ1eDgyblo0cHk0UDlDNEsweWtLZ1RrR3YxNFNV?=
 =?utf-8?B?ejlUQlNaRkZvcXlLaE5VemxobURuRTFFSDNtRUxYVkJKeXNFajA5Q3Z4YnVm?=
 =?utf-8?B?NDBGN2dPWmVJdlBoYUNudUZuU3RtV0lXVDExRlZHUEc0ZEdNdSsvLzdqVG9L?=
 =?utf-8?B?MU52RmF5emRNaldBczFpY0tuQ3FqL3NLRTdyeHUxMmJyREExVUtmVUNEck5n?=
 =?utf-8?B?YkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38AB18ADB677E847985987B9F17BB156@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b39593c-2e7f-4e1c-bb52-08dde68907ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 23:17:17.1674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/mYM9ZnwdxzP5wNQYeGsqHQ4GJY9R1nCJlVREzaxUans7iQsexFiYLYGaO1J8Cg7zhbLpZjDJNVhnqSK9RtgHseyO5CJfb7OTebo+EaT9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6082
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE0OjU3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZ3JlZWQsIGFuZCBpdCB3b3VsZCBlbGltaW5hdGUgdGhlIG5lZWQgZm9yIGEgImZs
YWdzIiBhcmd1bWVudC7CoCBCdXQga2VlcGluZyBpdA0KPiBpbiB0aGUgbW11X2xvY2sgY3JpdGlj
YWwgc2VjdGlvbiBtZWFucyBLVk0gY2FuIFdBUk4gb24gZmFpbHVyZXMuwqAgSWYgaXQncyBtb3Zl
ZA0KPiBvdXQsIHRoZW4gemFwcGluZyBTLUVQVCBlbnRyaWVzIGNvdWxkIGluZHVjZSBmYWlsdXJl
LCBhbmQgSSBkb24ndCB0aGluayBpdCdzDQo+IHdvcnRoIGdvaW5nIHRocm91Z2ggdGhlIGVmZm9y
dCB0byBlbnN1cmUgaXQncyBpbXBvc3NpYmxlIHRvIHRyaWdnZXIgUy1FUFQgcmVtb3ZhbC4NCj4g
DQo+IE5vdGUsIHRlbW92aW5nIFMtRVBUIGVudHJpZXMgZHVyaW5nIGluaXRpYWxpemF0aW9uIG9m
IHRoZSBpbWFnZSBpc24ndCBzb21ldGhpbmcNCj4gSSB3YW50IHRvIG9mZmljaWFsIHN1cHBvcnQs
IHJhdGhlciBpdCdzIGFuIGVuZGxlc3Mgc3RyZWFtIG9mIHdoYWNrLWEtbW9sZSBkdWUgdG8NCj4g
b2JzdXJjZSBlZGdlIGNhc2VzDQo+IA0KPiBIbW0sIGFjdHVhbGx5LCBtYXliZSBJIHRha2UgdGhh
dCBiYWNrLsKgIHNsb3RzX2xvY2sgcHJldmVudHMgbWVtc2xvdCB1cGRhdGVzLA0KPiBmaWxlbWFw
X2ludmFsaWRhdGVfbG9jaygpIHByZXZlbnRzIGd1ZXN0X21lbWZkIHVwZGF0ZXMsIGFuZCBtbXVf
bm90aWZpZXIgZXZlbnRzDQo+IHNob3VsZG4ndCBldmVyIGhpdCBTLUVQVC7CoCBJIHdhcyB3b3Jy
aWVkIGFib3V0IGt2bV96YXBfZ2ZuX3JhbmdlKCksIGJ1dCB0aGUgY2FsbA0KPiBmcm9tIHNldi5j
IGlzIG9idmlvdXNseSBtdXR1YWxseSBleGNsdXNpdmUsIFREWCBkaXNhbGxvd3MgS1ZNX1g4Nl9R
VUlSS19JR05PUkVfR1VFU1RfUEFUDQo+IHNvIHNhbWUgZ29lcyBmb3Iga3ZtX25vbmNvaGVyZW50
X2RtYV9hc3NpZ25tZW50X3N0YXJ0X29yX3N0b3AsIGFuZA0KPiANCg0KWWVhLCBpbiB0aGUgb3Ro
ZXIgdGhyZWFkIFlhbiB3YXMgc3VnZ2VzdGluZyB0aGUgc2FtZSB0aGluZyBmcm9tIHRoZSBLVk0g
c2lkZToNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9hSyUyRnNkcjJPUXFZdjlEQlpAeXpo
YW81Ni1kZXNrLnNoLmludGVsLmNvbS8NCg0KQnV0IHdhcyBjb25jZXJuZWQgYWJvdXQgIlVuZXhw
ZWN0ZWQgemFwcyIgKGt2bV96YXBfZ2ZuX3JhbmdlKCkpLiBJIHRoaW5rIG1heWJlDQp3ZSBjb3Vs
ZCB0aGluayBhYm91dCBLVk1fQlVHX09OKCkgaW4gdGhlIGNhc2Ugb2YgbWlycm9yIEVQVCB0byBj
b3ZlciBpdCBmcm9tDQphbm90aGVyIGFuZ2xlLiBJSVJDIHdlIGRpc2N1c3NlZCB0aGlzIGF0IHNv
bWUgcG9pbnQuDQoNCkkgd2FzIHdvbmRlcmluZyBhYm91dCBUREguTVIuRVhURU5EIGVycm9yIGNv
bmRpdGlvbnMuIENvbWluZyBiYWNrIG5vdywgSSdtIG5vdA0Kc3VyZSB3aGF0IEkgd2FzIHRoaW5r
aW5nLg0KDQo+IHdoaWxlIEknbSA5OSUgY2VydGFpbiB0aGVyZSdzIGEgd2F5IHRvIHRyaXAgX19r
dm1fc2V0X29yX2NsZWFyX2FwaWN2X2luaGliaXQoKSwNCj4gdGhlIEFQSUMgcGFnZSBoYXMgaXRz
IG93biBub24tZ3Vlc3RfbWVtZmQgbWVtc2xvdCBhbmQgc28gY2FuJ3QgYmUgdXNlZCBmb3IgdGhl
DQo+IGluaXRpYWwgaW1hZ2UsIHdoaWNoIG1lYW5zIHRoYXQgdG9vIGlzIG11dHVhbGx5IGV4Y2x1
c2l2ZS4NCg0KSG1tLCB3ZWxsIG1heWJlIEtWTV9CVUdfT04oKSBmb3Iga3ZtX3phcF9nZm5fcmFu
Z2UoKSBvbmx5IGlmIHRoaXMgZ2V0cw0KYWRkcmVzc2VkLg0KDQo+IA0KPiBTbyB5ZWFoLCBsZXQn
cyBnaXZlIGl0IGEgc2hvdC7CoCBXb3JzdCBjYXNlIHNjZW5hcmlvIHdlJ3JlIHdyb25nIGFuZCBU
REhfTVJfRVhURU5EDQo+IGVycm9ycyBjYW4gYmUgdHJpZ2dlcmVkIGJ5IHVzZXJzcGFjZS4NCj4g
DQo+ID4gQnV0IG1heWJlIGEgYmV0dGVyIHJlYXNvbiBpcyB0aGF0IHdlIGNvdWxkIGJldHRlciBo
YW5kbGUgZXJyb3JzDQo+ID4gb3V0c2lkZSB0aGUgZmF1bHQuIChpLmUuIG5vIDUgbGluZSBjb21t
ZW50IGFib3V0IHdoeSBub3QgdG8gcmV0dXJuIGFuIGVycm9yIGluDQo+ID4gdGR4X21lbV9wYWdl
X2FkZCgpIGR1ZSB0byBjb2RlIGluIGFub3RoZXIgZmlsZSkuDQo+ID4gDQo+ID4gSSB3b25kZXIg
aWYgWWFuIGNhbiBnaXZlIGFuIGFuYWx5c2lzIG9mIGFueSB6YXBwaW5nIHJhY2VzIGlmIHdlIGRv
IHRoYXQuDQo+IA0KPiBBcyBhYm92ZSwgSSB0aGluayB3ZSdyZSBnb29kPw0KDQpXb3JrcyBmb3Ig
bWUuDQo=

