Return-Path: <kvm+bounces-16050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB3678B38E9
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 15:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E789286168
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 13:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADAE147C81;
	Fri, 26 Apr 2024 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AJM20unI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D489A1F956;
	Fri, 26 Apr 2024 13:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714139454; cv=fail; b=pCdkTJTKehMu6lf7sJzLnPOMZ07rnc4xVKKUWvnZjCgewVvAHiVhO9j7DK9x8zjAGU/bEq3m2I/8wEmw3PwCbYWYkj8DG6VpXoo/1ZR4THsBYaGXpc55pZvNFB6kbvz5ntrrOeOO/hTOaG2o0kHSpFj3pKtoPFeoxKJCmFal0w8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714139454; c=relaxed/simple;
	bh=Qm+5RipPWnMjakNyG49M80ApYItnjcs9C2FrJZcsCPg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TGg4VYTc+mE75jWqsx0hVQpIuPsq4Lpd2Ux/f9AUV7AI2zDQjj3m/SnCxNFJk+3hnRiTQaWN7qn3bq42ypj248t7eH7aXwRuOkgZy9EBdoiU2XLmm8zq/Lu8WKWgbOjz+e+tvIZWrreZBFJuaUeMt4c8VHTm3REJFuoJ8GZRTeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AJM20unI; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714139452; x=1745675452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Qm+5RipPWnMjakNyG49M80ApYItnjcs9C2FrJZcsCPg=;
  b=AJM20unIO5RRAk4270Om8zztNIPa7+LMLY6i0DYCzWcAe2ct+9mOU2UD
   8VP+sQ2rhNSaMmvJQHZORQ7Ltk4kvrD74OWxmJJcHscSmQdXYzcGH+iZU
   HXupQnkj9EgV2SSU7ym7RKlPDAMa1vdLGel9n6Ps0/fxddyQ49RT+nfNO
   cefWJS2NoMMHAHVTAvFDEsGzFs8ixFgT/a+lSMYzz7jA619VP69O9Puj8
   2rgXKeamgBxT1AMKVlrdmSKR9XiaUjJ5RQf7Iuckp/nm4Z6KT9pvar62U
   sENembho8ktA0ghN3rnoH3T5979MP2hlPFYIl3Tlw+AexBzJxqI5X8ou6
   w==;
X-CSE-ConnectionGUID: pH4axYs7Qr+S/a1y+jGG0Q==
X-CSE-MsgGUID: mnzl+G3LSbyJWkifNCbhzg==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="9734847"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9734847"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 06:50:51 -0700
X-CSE-ConnectionGUID: fKcEI6EvQ9CX7MX6A9yE6A==
X-CSE-MsgGUID: 6fY/ghDpSVSaoEWtmxzhEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="48653577"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 06:50:51 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 06:50:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 06:50:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 06:50:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 06:50:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3WoTOXO1qDnyFHkEYqgk2ALesCR01JlCD88AqIA6iUgOEEreFeS24YgchFmeLMuVLO6S8TYJE+CDD4wUBJ6jJ4Qy1PdbJLGAE7ACL7EBWF1YoHmHm7oY9tGi8Tg2KkxDxaWnFemKvJvSSvFztMKLkESjU9oTj1eYCuZjhxKt5Vgmo82ip0Y2hdYLH07fCw4jVFdxgdTx3s4UBrB2FFPFGP1QUlz/nRf0k6uskRG8LQnoRjiNTF4dJV2kpiS45Gou6bZXFAjA9uHhFTcwP1GU0wOI+EhD6sQZeqTWTJshmxZ8moUtRtvbu9zkYcCGc5MrAGL+aIiZNgbgKcFw6gqKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qm+5RipPWnMjakNyG49M80ApYItnjcs9C2FrJZcsCPg=;
 b=fZ14H9W5EVWNVQCE+jRUEMbiVIvsGntA4VKaijY6uc+tN2b8S5OavZjWC350p4s5nZdfU/GZkpzJNMYVrJM/x+V/VJPgnCUIcAYZaX4HC7zs0l00YX+/NlWDEaQllCOfAyt9pTS/9C+cBR7Zl3KaHRj4MIT4W1wtsshEJHXji/zFCXRV0ZlCFzbLMxRrAwrL67dO53uAO87aouFJDesgZbc8RlsznhEILOSz83lXwyOOLfA8e12fX7+bBMgQMcFVSJbmMu9KYodtJ8XPuGICIn6kJ7OUEv6LDh45S91eeObPWbix4/nykVYLH3Wv7vqDy5AKmnh4cPmKH416bdbchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7192.namprd11.prod.outlook.com (2603:10b6:8:13a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Fri, 26 Apr
 2024 13:50:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Fri, 26 Apr 2024
 13:50:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "tabba@google.com" <tabba@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
	<hang.yuan@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Topic: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Index: AQHadnqYyiwEEDddI0GwsG68yoNoPLE/K9oAgAB2CoCAOsrgAIAAZ8AA
Date: Fri, 26 Apr 2024 13:50:46 +0000
Message-ID: <970c8891af05d0cb3ccb6eab2d67a7def3d45f74.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
	 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>
	 <20240313171428.GK935089@ls.amr.corp.intel.com>
	 <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
	 <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>
	 <20240319215015.GA1994522@ls.amr.corp.intel.com>
	 <CA+EHjTxFZ3kzcMCeqgCv6+UsetAUUH4uSY_V02J1TqakM=HKKQ@mail.gmail.com>
In-Reply-To: <CA+EHjTxFZ3kzcMCeqgCv6+UsetAUUH4uSY_V02J1TqakM=HKKQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7192:EE_
x-ms-office365-filtering-correlation-id: 728efeb0-40d1-47a2-6854-08dc65f7dff0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|7416005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?LzVUUWIyNkZVaSs3MnpqY09FRXBpdzV1ekMrdW1jRlNqdjRpbi9uYmF2Mi95?=
 =?utf-8?B?MTRveEJUSDRhMDRWUTJRWlM4NlBDbUFZVmVTVGl2WHVBVnpCZ2FvRGZGRjdF?=
 =?utf-8?B?RHlVdGJWN1YzMVpFVVhpZTkwMkVNNDkzbUdETHVwLzl6Mk1GMHFjT1lzY0o1?=
 =?utf-8?B?WjYvZnhJNVp1eUlLd3V5QjlzblI5YTJ4QjBsVjJBWHhSWHdXcnFpWk0zWk9B?=
 =?utf-8?B?T1BIWDE0M2swa1hCQUlGeDlrbmN5K0ZlcG5MaFV5NXhvRXFVSnpleFgzTkxO?=
 =?utf-8?B?NjlMNDhyS3FDWHJrQVlRRm9jRVpXaCthUGd0MVRSdHVPeHZlYml4V0FCcy9j?=
 =?utf-8?B?OHNaWUtBblRBZTEyUGUxQzRTay9WcVRKVDEzNHZnTWdwSk1tdjJlTUZsUTFn?=
 =?utf-8?B?ZE43VHVlODJDaXFKWjVEZmNHY2svakljd3dKWUZTNXdSY1YyVEdnb3B4bUhr?=
 =?utf-8?B?SW9XVFFxT3I4bG9pRFZHMVByREtraFM0ZXRTem50cU4yd3c2d1hKM1QxSEsy?=
 =?utf-8?B?TDJ0cC9uM04zYmRNS1k1RmVNUVhsVzVaSG1Qb1k4UTR5cTAwL3lKZjBFU3E0?=
 =?utf-8?B?VGVVdy9zM0xTRlFWSVJOYm94TC9WVzA3NForUlBwR2VoQWRnSGJXU2k5blMv?=
 =?utf-8?B?MjBtS0RnOStJcHVZdEdadDl0SCsvd2FxVngrYmJVbmdaZjVvU1lvY2dnSXhU?=
 =?utf-8?B?clJXTTlPTG85MFZQRUZCU2lHL2NQNnphUUJuMHFFRk1zMU9LT0xyY2V0OHJl?=
 =?utf-8?B?WWxzSlNkVkxvcmZ2QjQ0c0VsaHJ4dEdpaHJ5b0puOGZ3UlovaXl1b3Vvcmw5?=
 =?utf-8?B?NkxTclVLUnZUSkpLRFRqVlZEc29IY003UGNYSDVrczBlcFQ4bWhlNythZEFm?=
 =?utf-8?B?WWZXdHF0M0hkVk1tTW5tTWFHbEVqRkg1QVdoNHg1dHpwRjJmaUZjTVVMRVhp?=
 =?utf-8?B?R1ZIY0ZsSkJSRVF2TjBOcTJua2xlQXBXWDFzWFBoNDV2RlJocm9UdGxud1dl?=
 =?utf-8?B?MHA3SXhkc0thUDB3OHlXbzE5OERFbDNaNGVZQ0RGbnpGN3JEZ3RxYjR0eFov?=
 =?utf-8?B?VGRDNnNyU0M5SmsvWWlzb2hJbU9JbjRNMXhqb2ZLWVkyTmt4RUNEdFpXaWlt?=
 =?utf-8?B?SlZYSkJJRlU4eDJ1d1I4S2hNZGpXcjd4cXB5ZGdoNTRiRHVldHlRU2dkNDRZ?=
 =?utf-8?B?eDdneW00QmtYb3N6RUxUdW9mcG43dWp3RERZRzd4SHg2UEtpOFBiS3dQbjMv?=
 =?utf-8?B?bWcvbENZcTBaTDNvZVdmUnVyK25rWVhGTUVHd1ptOTMvRm9oVlZ2TTl3aFpN?=
 =?utf-8?B?TUJmQk9TYXZJZkd6bWE0a3NRN2NSN2pvUzAxS3ZVSzAzTXRndnpWYVVpM3JO?=
 =?utf-8?B?UnJyaG56aFl4ZkF6SWtEeisxVm5sYnE2aXl0RDVsZHhkY3lnSTV1b3hQVmZj?=
 =?utf-8?B?cXIwQjdBeUI5NXo5Z1lBZXVQQi9pVUM4VXlpdG5sMHpQVlVOQ3g0emE2OGJO?=
 =?utf-8?B?RW5hTktZSERCbkVoeVFGMUUwU1NCL1dPV3NpTFRIcmxjRFJjc3gwTk5hT1Vx?=
 =?utf-8?B?eVg0LzhQL0U0TGNPb3BiZlpESmg3aXlMalJZbWdOS0VWUEtpbjI3cWo4NHhL?=
 =?utf-8?B?dFY4SlptUEJPaDQvNWcxSU1ERWYvRk1PWktOTnZ6WGJWU3A5YjdoZ2c5bmU4?=
 =?utf-8?B?YXlKa1RSVTVSdnhzYlhWR0NSUjNkTElXMk9hWDZwVUtYVER3RFZURmZ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1ZoKzBXOUNCN0UyaitiM0NUODlUVnRTUDl0R3ZRcjM0bW5MUGdOTnZmRkhI?=
 =?utf-8?B?TjhYQVhzQzFPZTZ4QW9VcjJ6b2ljSzZVVWtXUlcvYVBPcFlRRXJ5ZTBsSkpK?=
 =?utf-8?B?WEZzZ0t2Z3JYVXo5R1NuK3QwemNDejZyb3JYbGxaSVEwQjFIZXV6L1lVVFJV?=
 =?utf-8?B?eXVBT3RYMUVDWjBlYjhLR1Q5VjJmRTJMeDZxVCtzOEZ1WE1ueEF2YUhoLzY2?=
 =?utf-8?B?cnNpWXZmNlZrVGZ0R0pHVzQxNjV1QnNxZmF1dTBnYUZWMXZjU3ZQRjZkVEZH?=
 =?utf-8?B?UHRpNGxhSjBDdzhLeUVMaTJCRjBQc2w0cHAxRkZxS2laOXJhY3dBWDJJNzdY?=
 =?utf-8?B?L2F4M0dPZnNUbnNxRXMxT0t4S0VHSjdjTDZEZ0hmSmRFOS9ZS3NneVBiSm91?=
 =?utf-8?B?empVRlVCSm1yLzNjN0ZwdXZxK281dk1ZYloxVEFOeTYzUzJyaXBUdzROL0Vw?=
 =?utf-8?B?TER6OU9hbFBIdzZ3UE1JR3VjU0VDUnVQci9wRC9yRnFVR0l3dTFDaWR4NFRE?=
 =?utf-8?B?eWhkVklqTFZQcUl2RFQxRDV3Q2RnTEJRaUYxRGYyOHNybVdhQmtkVjlHTi9Y?=
 =?utf-8?B?ZkpVWlRId2pYWnhKb3RrN005aS9lR0w5RWNFNUd0aUU1dkx2L0FEQkd2RXJj?=
 =?utf-8?B?bGdLWTBJVGRqVFBpbHRRN01OalNQTXhqcEEzelN4ZUdBcTAwSjNtSlBzTTAr?=
 =?utf-8?B?dmkrY2xTck5lZWpJYjE0UTl2NW8ySExWRVhxS25XTTFadFk2L2VJNG9PUTZ4?=
 =?utf-8?B?SXI4cjJLK08rTmRMYUtXeitZZmRub3VIUk1BbVRIcGJkYlpPcU43OGhTZkRN?=
 =?utf-8?B?QS83NmNSVkJBVlhaSis5UExGNGhYL1FjelBJZmdwNUpkb0pjNmVObzJZUGRI?=
 =?utf-8?B?RC9KenJ2dEU0VmVWWVphSkdiemRHN085Yzk5bWdIOXlLcWVGOVM4eFVqTXpr?=
 =?utf-8?B?RW81UW1HaVhxU0VUeGtZaXFLOE40d2xmd0duTUdHWnFVZVlrTkVSZ2hzajBo?=
 =?utf-8?B?SzZKSWdsVmM4MUdhM2lCU01oS2trbjd1VVlpRXljNWdHclFQWWhKRDduSGhr?=
 =?utf-8?B?M1hMTEEwR1J6a0FGUC9VMVFVS0QzWlFZQVlYQ2RCb1hxOFFpdWY0MHhDamJ1?=
 =?utf-8?B?SDRBVXl5Tkh0cWRRTXI3R01pVTFha3EvZnFuYzlNR3pQREo2eUdDL2hPZ3l5?=
 =?utf-8?B?OERFa25SbXpTTU5NZ3hNV3dHS1lFamZwYUU4Vy9tT00yZmZnTjdtalQ0UG9N?=
 =?utf-8?B?NTNlOS9zYkRKMG5ZVjk5d09sNW9UR1dWSkxqeEFTTFd5THEzZEZlaElTNmFa?=
 =?utf-8?B?Z0hmeG5wRXpZTHVSc1VTMWk2VCtzZlp2S0xGQkZzTVB0Y052bXNoTUYzL3NC?=
 =?utf-8?B?Nm93Z1IwYWd3TFZVaURsM0FjWnhqY1ZwUGxIc3crUE55MEt4bTRPZWlGU3hl?=
 =?utf-8?B?ZndtUUJoeW04ZTlaYXFFdUFXR0VQVHBuOWNmbHlaM2lVUWl5WDZuWmo4WEVU?=
 =?utf-8?B?TXliUFRCV051bms2elJ1RkcwMmE4Z2pEai9waXRCUHFUMmxnczRCdkFhQTRj?=
 =?utf-8?B?RU12eGE5RDNrQ2djd25UVkRON3JBWW1vM2RhRVI4bUxNYlRjNEkvSUs4Q1lo?=
 =?utf-8?B?b2VrN2IwZms4cEJpd1pFT1BGZFNabGV3QUxDL213VG9IV1h1clNNcElKMDZj?=
 =?utf-8?B?RGY0UXl5NEd4Q3BScC9Wc2hadUxSVFNvNGk4SEZqTFVqLzIydlh1dlIxTWVr?=
 =?utf-8?B?NHZOajhtU3hxSGoyOS9jNURRVEMrYkRnMHNDbktHYWRSbFdoTC82L2p1eThE?=
 =?utf-8?B?ZElMY1dxK2ZQRVZwbzBxbTdreG15clJyMjBhcFpyaDVSemdyL3hENHlLZzJH?=
 =?utf-8?B?OVY0b1c1NGl0bThPNGNDK0x2OG9mRWdjZjhrQjB6Q2pzV1FwaWxCYnlST1Vy?=
 =?utf-8?B?S0daUURCTUsvM05JYzdid2FLOW8wWkd2V2dzd1g0NC9CRG82dVhlMnNtSW5T?=
 =?utf-8?B?NDVqeGMzU2JkZldxanh5NjFGU29uekRKdDhsaDJBYVYzcUNBY21JcjQwZE1K?=
 =?utf-8?B?cnRHbUZzZTFHT0RhVW9zeEtYcU4rR203aWVVc0Jvci9vM1NDUmIydHZ3Vm43?=
 =?utf-8?B?Q0ZuMllhNE5uWjQ5clp2MDU4T1AzKzJuVjE4aHFzM2Zrem9LZFc3azQ4aTJu?=
 =?utf-8?Q?tovPZgSkt3CdCTbrxVlzv+U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD36D9910C7D084C8EF4E92655E5E6C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 728efeb0-40d1-47a2-6854-08dc65f7dff0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2024 13:50:46.7919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YDXrGmxvw7QlkeKeeQD9JDM/T9JJ6o+PQKpZcvCeEHj9CUW4oFnSRBti7bRCUkbgoHTFFIbcpDi0rc7imM/hIwNEoewQdM04moilF/HAYBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7192
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTI2IGF0IDA4OjM5ICswMTAwLCBGdWFkIFRhYmJhIHdyb3RlOg0KPiA+
IEknbSBmaW5lIHdpdGggdGhvc2UgbmFtZXMuIEFueXdheSwgSSdtIGZpbmUgd2l0aCB3aXRoZXIg
d2F5LCB0d28gYm9vbHMgb3INCj4gPiBlbnVtLg0KPiANCj4gSSBkb24ndCBoYXZlIGEgc3Ryb25n
IG9waW5pb24sIGJ1dCBJJ2QgYnJvdWdodCBpdCB1cCBpbiBhIHByZXZpb3VzDQo+IHBhdGNoIHNl
cmllcy4gSSB0aGluayB0aGF0IGhhdmluZyB0d28gYm9vbHMgdG8gZW5jb2RlIHRocmVlIHN0YXRl
cyBpcw0KPiBsZXNzIGludHVpdGl2ZSBhbmQgcG90ZW50aWFsbHkgbW9yZSBidWcgcHJvbmUsIG1v
cmUgc28gdGhhbiB0aGUgbmFtaW5nDQo+IGl0c2VsZiAoaS5lLiwgX29ubHkpOg0KPiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvWlVPMUdpanUwR2tVZEYwb0Bnb29nbGUuY29tLw0KDQpDdXJy
ZW50bHkgaW4gb3VyIGludGVybmFsIGJyYW5jaCB3ZSBzd2l0Y2hlZCB0bzoNCmV4Y2x1ZGVfcHJp
dmF0ZQ0KZXhjbHVkZV9zaGFyZWQNCg0KSXQgY2FtZSB0b2dldGhlciBiZXR0dGVyIGluIHRoZSBj
b2RlIHRoYXQgdXNlcyBpdC4NCg0KQnV0IEkgc3RhcnRlZCB0byB3b25kZXIgaWYgd2UgYWN0dWFs
bHkgcmVhbGx5IG5lZWQgZXhjbHVkZV9zaGFyZWQuIEZvciBURFgNCnphcHBpbmcgcHJpdmF0ZSBt
ZW1vcnkgaGFzIHRvIGJlIGRvbmUgd2l0aCBtb3JlIGNhcmUsIGJlY2F1c2UgaXQgY2Fubm90IGJl
IHJlLQ0KcG9wdWxhdGVkIHdpdGhvdXQgZ3Vlc3QgY29vcmRpbmF0aW9uLiBCdXQgZm9yIHNoYXJl
ZCBtZW1vcnkgaWYgd2UgYXJlIHphcHBpbmcgYQ0KcmFuZ2UgdGhhdCBpbmNsdWRlcyBib3RoIHBy
aXZhdGUgYW5kIHNoYXJlZCBtZW1vcnksIEkgZG9uJ3QgdGhpbmsgaXQgc2hvdWxkIGh1cnQNCnRv
IHphcCB0aGUgc2hhcmVkIG1lbW9yeS4NCg==

