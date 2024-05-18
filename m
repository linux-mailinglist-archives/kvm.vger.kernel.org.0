Return-Path: <kvm+bounces-17728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2166E8C8EE1
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 02:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C957C281A97
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D11322E;
	Sat, 18 May 2024 00:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XO8Wt52H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A154624;
	Sat, 18 May 2024 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715991921; cv=fail; b=OOc16T7vUlZ2K8LpHXUuXpnGpaVIYPjGyDHLktwoMczXqfrMAFA/7IqmclviyTuV7U1Wb5fIJ2NbnzhMlpcwBgTT4KJawD17+IV0g9L7dMoPNjrxlR2goThlkunRc9HLSoLtFPQ4YcTS8jBKwX27rmmdXqCIImT90tKm9J+7RO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715991921; c=relaxed/simple;
	bh=hLndgu516qRlNn13pGgRk5aegZwWCXmrBrAq6tCUNfU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lWEzYBMAyLzL1qffORf1v5vfYV3nB6eU4Kfcy7cctAJab0dm4cX1ZqPl40vkbdVjyGAa+vbRTH5CrHwb/GKe9HNwPtRgqNROqY3YEfUgixgYNFtmbhQfOwSA76yI4x58s2kIiRk0TaN4WGiXQNuriUBfZHM4p/KV4HUDRmqcyaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XO8Wt52H; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715991919; x=1747527919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hLndgu516qRlNn13pGgRk5aegZwWCXmrBrAq6tCUNfU=;
  b=XO8Wt52HBLbw8HMuPIl2S/cpMQqHceG+LIvVPdYFiSrg0bkDbJAe/4gy
   EJ7v08OdOnoEsT5wteFaZ04Kf/1VYBFN4ZuWyiOYF7XQf1wzfp4XMeU1C
   ruz+1YToF8N8b3zxtUXz9eTVMaxgmQp0hqM0yf7eIw9ntQuepoV6M01x1
   xyXIU5PdofYOzQhXzsgd5A/3LYCJQm5Ql5EcItxFto5gWjQTxWtx0zdbP
   1vSMB4crnNl+rK3B8HSyPvMXj+ie3/TvTASva8FhE5K8M2cjR5+Q9JcTO
   HNkE8GzlYM8yRCI4naL429Kv5MAsnIm0eYliXjiErBU9IfNXxePnlQMgq
   Q==;
X-CSE-ConnectionGUID: Sc8dumD6TMO1zAQYA+hE7A==
X-CSE-MsgGUID: ZxcZQXk0SXuSYcTEq1ib8w==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="12041634"
X-IronPort-AV: E=Sophos;i="6.08,169,1712646000"; 
   d="scan'208";a="12041634"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 17:25:19 -0700
X-CSE-ConnectionGUID: g32+Il73ReuPk6lGpTQFJg==
X-CSE-MsgGUID: vrm8EH1AS7mxYELq3FF8fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,169,1712646000"; 
   d="scan'208";a="36362378"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 17:25:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 17:25:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 17:25:18 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 17:25:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+i7ixJqG7Xh1NemfEs2gz0fhaWG8fXvFNx24wl22KmmLsk8yiQpxo8EIK28jYOwl0aeorDZHzwI/QaIPof95CobGfbv0XFNmto3PiEk2VAyuVCkHQIeDG+qnjE0qX8mC4v5nZhn1NicywwMNSv/CTjHkR6NoXI5STPmKMClmDfGf7oFonIFo5C02/ofNg1dfXD4oplALawH98f0S3qwPqzD1m9uGx22hDyUAGZpgYAyWrF640hLhRAS9HAnEIbVoLtCUne8aVoEjYgBDvW4OHRwspw0pyThudkm3bxybl/KpoHJ3za9Z6yBGHEneFz/QAraNSRVg4PbbHb7q2UsKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLndgu516qRlNn13pGgRk5aegZwWCXmrBrAq6tCUNfU=;
 b=CT40sW58ASr7H52dTEDrzsjvGeUZz7Kxn0b+sltfEtOsSttJZoDSYrjPf44u/+YuX3jpwntAPpzZfHneccipGeLxZfe0x9WentBqPU4AylXXy5c3kc02fxBp/H1MahEIoSM78xO8CrWl2aSG4D+5lmr3AyiadEYlSHq4DvL3pcYEw6i8CLLDM+Sw63rLzuE5KtXrumV59cObIpwGRAQ7e9C746xHgCqa4scYtqUSWJtUxebsKvpby33ldQqo0zMMqKjEnrc1qQWNa9lXIgzE0LN2Oz6M59Tu4jLqD3MbHck8Pv0XSlSzolaEXqEWp84HxVfyNc50ydzr2E88iaZixg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4573.namprd11.prod.outlook.com (2603:10b6:806:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.29; Sat, 18 May
 2024 00:25:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Sat, 18 May 2024
 00:25:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "seanjc@google.com"
	<seanjc@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaAgAAByoCAAAQqgIAAA6mAgAAB7ACAAAHNgIAAAriAgAAH94CAAAR+AIAABbyAgABGToCAAslHAA==
Date: Sat, 18 May 2024 00:25:15 +0000
Message-ID: <6e18f4ec4ae33fe0e93cb2575a88b6da254bde8b.camel@intel.com>
References: <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
	 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
	 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
	 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
	 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
	 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
	 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
	 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
	 <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
	 <d8ff5e19-85a7-46bf-9dad-7221b54d8502@intel.com>
	 <ZkWfE2KSpPgv6RND@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZkWfE2KSpPgv6RND@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4573:EE_
x-ms-office365-filtering-correlation-id: 86ccea3e-5729-4537-3583-08dc76d0fd2b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?dTY1ZC8rU2pHWi9qcTVCZUdHOWd3SHJJQ0tMb1lNLzFKYVB6eU5EZmw1bmY4?=
 =?utf-8?B?STRnTUE3SEN1MjlicFd5cnpEMXFqbWhtUEU2S0J5aU9BYzBjZHVBY25YbHhp?=
 =?utf-8?B?bm5ORDZ6MzI4M3R0d25wRHdrOE82MHoyVXRXb2dJejcrUmR0WkkwczJQbnNM?=
 =?utf-8?B?NUZsTVQvWWFMbGRpRWhhTTJPeEF4c1ZwVGJ0citiYUVmR2dZM3ZBRFpuSGlm?=
 =?utf-8?B?dVNESXVnUHdGUDd6ZVN5dzNhU0UySHFPU081anhWc09aaWg0OTlydDhXejF5?=
 =?utf-8?B?c3d5c24zdnhMZ0JZY0ZaRHc4eXh5NTVlZnlxa04wMnU5VlFrZXFxSXEwU0Nx?=
 =?utf-8?B?RDdjaHN6dGk4b3FvRGFYMWZVakVNSDhkMTJWR21xbXNQbDNyblNoRXNsT3Fo?=
 =?utf-8?B?K3l1cFkzNEtaZUZiVFpYMnlZalhMWklCb21DajAyMGIzMldHYmVRb0RUVlVv?=
 =?utf-8?B?ZzNXL1BIWkpvMkJNa0ZyTmhHUkRJWVY5dk1tSUpzZ01MZkNuZ0NSMkh1U2RZ?=
 =?utf-8?B?dTgyUDkvc1lEYmVjT3djWU5CamJXYjk4R3FyZ1dYZmdNZldFUUgvbHNLL2FD?=
 =?utf-8?B?NEFlRDFKVDNvWDJ2dzBqMU8waEMzUG9KQ2ZaYXFwdXpBSnRKSWtWSzV3VnJi?=
 =?utf-8?B?VTBVOEVTRmU0ZElpcnBFQ29DZzhmRitkTFpTdW1GdzJidHBqdGVEYmJla1R0?=
 =?utf-8?B?aE1kc3JVZHc1SmRwamt4RmVSN0ZLOHBMc2doblRtSUFSanVwZzltazRuS3hT?=
 =?utf-8?B?TEFUU2RhYWhtV1liWXo0VmdnVUdNOUhoWWlUU2VxcHYwUUlWSHhNVDJESnVF?=
 =?utf-8?B?ZGkyOExBU2pwR0tsWll6bUtsL1RhbE10OXFtTkxpR0VNdTRvZURlbE9NM1Y4?=
 =?utf-8?B?YjI4OEd6OFZoWXhLMkRxUkhiOW1FS0VaZjFPOUhLVEQvZ01BSXhTajlxdW5C?=
 =?utf-8?B?ZXRKbzFoaHkvMU5aTVRReHJWbndRc3VTKzN1MWgrNUR1K3ppL1BOMUtGOFZj?=
 =?utf-8?B?NEZaMTQ1bm5GK0RLcmVFdE1vek0vT213SEo1NW1EalZFUXVPMmtQZDZDaEZp?=
 =?utf-8?B?UWNmQ1pDOS90dG1OeWRIU3ZldDk2RkF0dzVlZFE1eWZVdXAwbXhwOTYxOGZ4?=
 =?utf-8?B?ckRJeTY0dVJNc3ZqSWc0ejBkOVUxR2dvWFZML1U1UmZyOHBYejFJVytRUkdE?=
 =?utf-8?B?ZGVqSVNEcmlQWk1NeDJtMFU1b3FPcmhEMzMrQXNvdHBON1pGZnkwcG02cnk4?=
 =?utf-8?B?RklmTjJyS1Q0T3U3QnZZOEVOYWZsM0hMbCtmK1phSkR1Z1BvTmVuVEhKUGlv?=
 =?utf-8?B?MngwRXp1b3doUisrd0hVbUVkaGg4TTBLR1RDVmVFZkRqbVgxdGtEbml1OUlJ?=
 =?utf-8?B?TnJ2NldxaklMQXNNZFdscTJqemtXRWFkZXZJbWl5K1RLN3kzM2IvNlVZMU56?=
 =?utf-8?B?WFExcGREaDBRcU4xdFZYQVM0ZXFOTTdmemJiWThEazFIZnkrNVRRUUNYRm9w?=
 =?utf-8?B?eFU4c2JueU8xc01KTkxyNXlBekIxS3lYdHJPc0JYMjVtRXRDY3EwM2ZhTnBT?=
 =?utf-8?B?OWY5QTRYdnhOWjVlUWQyL1lPQ1hncVd1WHJ1Vm4weFdFQ0Y5VzlaQWJBRDJY?=
 =?utf-8?B?TWk0SVdhUForMzY5d00xYStOY0JSb1huR1hXN2tvbHVPY3YyVHNhTWpYd2V1?=
 =?utf-8?B?alZJcW9EeFBpVlF6RDUzcWtYY3dEYnFLTy9NNzZQVEQwZG1Xam5yRmRpVHRH?=
 =?utf-8?B?bVlLU3p6Qkt4eXZSWjdDeVhKWkNVZjFWbDg5cEt5S3ZJTHBGQnVNRDVqMmZE?=
 =?utf-8?B?R3NFSjJyenhpVnptODhrdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGtVV2d3bXI2aCt3WENDbndQMWVzUDNUcWs0NWpuTDNhOFUvL21SVWdQVHdC?=
 =?utf-8?B?S0FUdWQ0ZzhCZnRaR2hKQ3lHbHM2YzRQbHhJdFlMY0dxaWczcmFsalI3cHdU?=
 =?utf-8?B?cDRTNUV5dkhBS2E2K0VpL1dzQUU4Y0JRdjlkeGFSYjZiUTJodUFlemJRa0JJ?=
 =?utf-8?B?ald0cU4zbXZEeTlFSUg0c1pLZVFBWWx0dTJqMVhWYUQ3Wm1EZnpyLytRN3M4?=
 =?utf-8?B?MlpKenVUQ2wwdE1oY1U5ZTZFWFFaemI4RUdWSGIyVjVzT05pN09hQkZ6VWFn?=
 =?utf-8?B?NGR0SzJXS2VMSTljeG5PckxzWlNVWm9rbG5zUmIyaUhtbHJEUHd2RmpjNVRG?=
 =?utf-8?B?OUpjSURFbXlwaGJ3MlB6bWhiYVc4UnFtekhsQ2lXYkRQWk1hT3NOeFdUaUNO?=
 =?utf-8?B?YUpZOVQrczlFam1HK2tJL0lMSkJhREJBWnljOWg5cWVqTzBOSFpsTUFkM2ZS?=
 =?utf-8?B?OEg2UDVsSmdEenBqWE5VWEZ2YitydURWTEtUOTRLMk0wODNlaVZHVTQyZm5u?=
 =?utf-8?B?aHJhMWNUM01UK2FhMS9yc1Z5WjlFSmNsTEVUbTVIVWc0amsxZFloY1pMVmJl?=
 =?utf-8?B?WVV5Sk1hcjd2Z0x1MXFCN1RUSGRvNzMyU2JMZVU0bS9DNEZNOTJmZTZKMlMv?=
 =?utf-8?B?NmRRNTRrSVpybG5LM1BreHZ3c0t0UkhmZjVoWnA1WW1WRlNnZmxMSVJNUFhu?=
 =?utf-8?B?R040UTFmV3RlQWlVZ1JYVFVRUVc4RGQwUk1ybGRxWDJrb1NrekFkcVIrc1dm?=
 =?utf-8?B?SEduWllPMTF6SWZMSldhcnB3QVJDeWNXNG9Famh0cDJlQnBFeWJxRmJLVFlp?=
 =?utf-8?B?cUxYaTJxOEZ6RVB2OGNKcjk5VTd0SkUwekM3YnEvWlV0bCtEZ1hCaXlMdk0z?=
 =?utf-8?B?cTFvcUQrV1prdzhUd3BMTHRLRGY3V21mdTZUNVRWdnF5K1hWdDFPczY5anBr?=
 =?utf-8?B?anhUTVRIVSt1NGFaSTNlR1kzR0o2RDNPWkpYUHNaOEl5UEdSeDJ1dm1QelBi?=
 =?utf-8?B?a0lXWkI5aFVOY09obFl3WkNMcHdTNTVBUXIrcWdJcDJwUmNuWUE5WmxrSEwz?=
 =?utf-8?B?YmF6SDlqRk9WZzUzV2p6SDZlRU5takh1VThNOFNYQTNuK2hWRU43Wmtobmdj?=
 =?utf-8?B?VGtmMkxiQ3VRQ1pEaFJyVXBIbHNybkJBMzVYRmY0cUthRlNYWnN0T2tIOTJP?=
 =?utf-8?B?d1NGNmdBdTNYbWJZc2J5SGoyNTRyQm5jK0FzazU2WUJhbVhqazB6OW9rK1h4?=
 =?utf-8?B?Mk1jdEIvdVMrMGk5akp5OTBtSjE5SFNVUzNkQmkzRHVNd0hwQkhyZUFJbGd6?=
 =?utf-8?B?eVVLRmRLaGVVazBEZGQxeXEzSmFaQjlnMHY1L1ZFVk9ZejA4MW9rdGNZR0o4?=
 =?utf-8?B?RE50MDdtSk1tbC83NzJwejVEaXl2WVZmUDFzRWJJVWxXY2RkWWRTZll2QTFj?=
 =?utf-8?B?QlQwcHJDbDQ0c1NkVWdadk1RTzBCN0JoRkJTSVQxTHkxL2lLVmg2VUM3QlJB?=
 =?utf-8?B?RWh0SHBIODExZXJjOEwyZmtLS3E4QkllRktheFpkOGdzR0V4d1I2bU9PUVIw?=
 =?utf-8?B?QXQwQW5nek44Z0hYakMrbHN3dlMzZW5CdTFIbTgxekE4cjlpeGdyV2hlVEd1?=
 =?utf-8?B?QW1tT2NsNHJyVzA3ODNkbmlsVjU1TG12c1dHRHAvUjY0M21xbzdzci96VDZq?=
 =?utf-8?B?Q29ER0RsL3RtRkZINjE2UUZqVk1HK1B6OVFQYVo1M0twUHlmbndWZHlLRDFO?=
 =?utf-8?B?T0ZiV2g1R3BkRmlLbDBSY1U0dzQ2N0pqcXJGZHhvYW8wZ21Ld0pYN2trNmox?=
 =?utf-8?B?RG8xRU5xbjFUSHVBeUcvVTUwMXhoM04rWnc5N3RjeG1DR1VNYm80aDZUSWdP?=
 =?utf-8?B?UTdmSFVrQmFQZU9temw5MEtWY095dEVPYTJ3RFZ6QXRVeldDZVhjMngweFAw?=
 =?utf-8?B?MWw1ZjhlR3RhUTN6Tmk4Y05zYjVSZksxWVF5SDdEa3FIdjFPN3k1N2x2QzIr?=
 =?utf-8?B?ZzM1aTJBcEgyMDJOY01DMUcxZXZrZ0dTdGRmN2NwUW4yUU40V0dBZHZLTloz?=
 =?utf-8?B?UnlaVFpZSzN1TXd0V1FjZ1R4OExHZGNzbFpnc1c3MXpCdXplTzRiM0NpSGx2?=
 =?utf-8?B?V3ljclIxNk1qVnMvY213a1YrZ281NlRUZmdyU2RiYjBja2NncSt0QXdrLytD?=
 =?utf-8?Q?kWW76o1CqSVEEcX4hz+cdLg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90D59EB3C9BA4D478B811096195BE9A1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ccea3e-5729-4537-3583-08dc76d0fd2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2024 00:25:15.1937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RbKvj/weI7BQH5V/Z56mulWODri31uIWQDAW7NGF/ncnKld4Y/kPjD3RnUwI1UraxMNghyTjvA8ubHmOxRgb+A0udXjm2TNdvwxZux1xfnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4573
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDEzOjUyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBB
cyBzYWlkIGFib3ZlLCBJIGRvbid0IHNlZSB3aHkgd2UgbmVlZCBhIGhlbHBlciB3aXRoIHRoZSAi
Y3VycmVudA0KPiA+IGltcGxlbWVudGF0aW9uIiAod2hpY2ggY29uc3VsdHMga3ZtX3NoYXJlZF9n
Zm5fbWFzaygpKSBmb3IgdGhlbS7CoCBXZSBjYW4NCj4gPiBqdXN0IHVzZSBmYXVsdC0+Z2ZuICsg
ZmF1bHQtPmlzX3ByaXZhdGUgZm9yIHN1Y2ggcHVycG9zZS4NCj4gV2hhdCBhYm91dCBhIG5hbWUg
bGlrZSBrdm1faXNfcHJpdmF0ZV9hbmRfbWlycm9yZWRfZ3BhKCk/DQo+IE9ubHkgVERYJ3MgcHJp
dmF0ZSBtZW1vcnkgaXMgbWlycm9yZWQgYW5kIHRoZSBjb21tb24gY29kZSBuZWVkcyBhIHdheSB0
bw0KPiB0ZWxsIHRoYXQuDQoNCkluIHRoZSBuZXcgY2hhbmdlcyB3ZSBhcmUgd29ya2luZyBvbiBp
biB0aGUgb3RoZXIgdGhyZWFkIHRoaXMgaGVscGVyIGlzIG1vdmVkDQppbnRvIGFyY2gveDg2L2t2
bS92bXgvY29tbW9uLmggZm9yIG9ubHkgSW50ZWwgc2lkZSB1c2UsIGFuZCByZW5hbWVkOg0KZ3Bh
X29uX3ByaXZhdGVfcm9vdCgpLiBJdCBzaG91bGQgYWRkcmVzcyB0aGUgU05QIGNvbmZ1c2lvbiBj
b25jZXJucyBhdCBsZWFzdC4NCg0KT24gdGhlIHByaXZhdGUgYW5kIG1pcnJvcmVkIHBvaW50LCB0
aGUgbWl4aW5nIG9mIHByaXZhdGUgYW5kIG1pcnJvcmVkIGluIHRoZQ0KY3VycmVudCBjb2RlIGlz
IGRlZmluaXRlbHkgY29uZnVzaW5nLiBJIHRoaW5rIGNoYW5naW5nIHRoZSBuYW1lcyBsaWtlIHRo
YXQNCihwcml2YXRlX21pcnJvciksIGNvdWxkIG1ha2UgaXQgZWFzaWVyIHRvIHVuZGVyc3RhbmQs
IGV2ZW4gaWYgaXQgY3JlYXRlcyBsb25nZXINCmxpbmVzLg0KDQpJIHRyaWVkIHRvIGNyZWF0ZSBz
b21lIGFic3RyYWN0aW9uIHdoZXJlIHRoZSBNTVUgdW5kZXJzdG9vZCB0aGUgY29uY2VwdCBvZg0K
Z2VuZXJhbCBtaXJyb3JpbmcgRVBUIHJvb3RzLCB0aGVuIGNoZWNrZWQgYSBoZWxwZXIgdG8gc2Vl
IGlmIHRoZSB2bV90eXBlDQptaXJyb3JlZCAicHJpdmF0ZSIgbWVtb3J5IGJlZm9yZSBjYWxsaW5n
IG91dCB0byBhbGwgdGhlIHByaXZhdGUgaGVscGVycy4gSQ0KdGhvdWdodCBpdCB3b3VsZCBsZXQg
dXMgcHJldGVuZCBtb3JlIG9mIHRoaXMgc3R1ZmYgd2FzIGdlbmVyaWMuIEJ1dCBpdCB3YXMNCnR1
cm5pbmcgb3V0IGEgYml0IHNpbGx5LiBTbyB0aGluayBJIHdpbGwganVzdCBzdGljayB3aXRoIHVw
ZGF0aW5nIHRoZSBuYW1lcyBmb3INCnRoZSBuZXh0IHJldmlzaW9uLg0KDQo=

