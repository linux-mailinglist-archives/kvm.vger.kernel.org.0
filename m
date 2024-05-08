Return-Path: <kvm+bounces-17024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2FD8C0093
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 17:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32AE3287845
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD32B127B4B;
	Wed,  8 May 2024 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QZIiaJ65"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA83126F3C;
	Wed,  8 May 2024 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715180658; cv=fail; b=ehXko8vnR5POC3IsD8J7wW5uox4uOMDDtN4ac2/4qy66a2vvpz26HACnSvDE2JEpv9h1XVpOh4HT+l/Q1QZB3YUxjhAGK8qduF8NBD6GxBI+hB6VWM7JJoFqTXydFOz8kTGV1d0yAU1vJlrc6LyovFnHvAw772dsntkPU8U0HG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715180658; c=relaxed/simple;
	bh=8S+RyaVr+GFH/zUrtd9B+T2MVBh0r6caOaBVPIWVXVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T/maSyYzt7XwFwCu+BftS8Sa3PP7P6rAnmzm3ST8jPoChhC0wExmJVK5ObLyXIFE9UEH7dULNafKcblld69iXg46l8/wXO0GbeOnMsjIECn0hHvhmvU3BX/ld3vEHfa0y9aiMqJw8xlcWTR6Dvo9GBnjjn3omYd1C0L77dL4iXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QZIiaJ65; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715180657; x=1746716657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8S+RyaVr+GFH/zUrtd9B+T2MVBh0r6caOaBVPIWVXVQ=;
  b=QZIiaJ65VTjz1XmLujZ41KDoKZFXMgoYP1+doC9fYaVKWZ3L8/BodUdW
   OSGmTa8V5BIOCT349m7QuIXke7Wgu54AN5iAx+mrZxgGnO8xtnKxYZmD4
   w/BGyzyBhcbNS3RMO6KfQUPiG79kGd0LvkPzAW4sLP0ojrvhIklCgvwHW
   Mwn2t0Xcrik2DOYXFlbvg90wPnmu9pc+/veQ/S575VvLWk7Es+h74kXw2
   /q0YjWLHqInxrFuj1+1chMkbBhAy7dFM7gbsdqbhQXqchUGvd1Vs8/Yky
   myKKQ81T/QQXYd8iVk22TZlzRZNb+nZxWCBcP96pg5S4llGS/r65d80Wv
   w==;
X-CSE-ConnectionGUID: jEbqX7UDTXatyfRPzdbWXg==
X-CSE-MsgGUID: C9BY2Bm5Qo+4/va87KXiVQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11173056"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="11173056"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 08:04:16 -0700
X-CSE-ConnectionGUID: IbeP7zsDQiOx+HRTkuP7fg==
X-CSE-MsgGUID: a/lPkhQ+Tkio++eQDaVP7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="28899018"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 May 2024 08:04:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 08:04:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 08:04:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 8 May 2024 08:04:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 8 May 2024 08:04:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmUKcQ4hn+CN24n18kCd/FSo+wsds6U2MLU+yp8klzYYMJ11SfG5eQvbOgyhU0T/A34EpVAUL7rQhR1E3QFUsOCEcowEnKdesif2NbevLKcmDKzsM3KQXLmmOXjG3k9NPtrgGwsack+oWi8Anoxal2ZINnMdgZ44dw/z97Dz6KaVSEoNfThXjxliLn0XoWwH79JiJWaVdsUVQw0X51RdCg2L3SeFEKibSHjFeFx7ouQ9cKG2c/uw2tHIJ0cYLP7guR/9UnkeT1by7QD8cY/+clgTzOUQiI7+2o+P1Q6HJyicGA5tS5ucckpSJwDZ6Sss86J8/dli5whk0WUKI79L6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8S+RyaVr+GFH/zUrtd9B+T2MVBh0r6caOaBVPIWVXVQ=;
 b=oDxJa0ucX5JvWIeSrdDLHC6E+dlRjImW/ZeCORN4lHZNvFKTJDhUKHQpmi0kStehCT74TiiBc9+B/ydRcriqUPCN5MLJZjJu79Q3PKav67fU2ASYDys2ftYICoLYoiy6ED0ArrxtyoHDnNRF/JmDONmD6ISbEvcLErsR33oklYWIG/LjEqxJvH2iEvUUaFgLgbGvBZGzNCB2cWxbs3explRTq7gfzupYrMvjFN0n0JQhettmASIR6+yq/CaGY7BKvCDKzsKKCiPFSWOmJ9G9jjzLudIAppmDOfUwOUP9mA/zMvPnmx3Jlj2kUNIK5t8iq+zUwmORmgMkAEQYYm9MMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 15:04:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 15:04:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo
 features
Thread-Topic: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Thread-Index: AQHah60wsHP29hDi6kKJ9JlK2WL9i7FfKRuAgC1sloCAABYrAIAAEG2AgADfEICAAAdDgA==
Date: Wed, 8 May 2024 15:04:12 +0000
Message-ID: <cf75bf92f096f4303a911ca5fd119fe765a618e2.camel@intel.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
	 <20240404121327.3107131-8-pbonzini@redhat.com>
	 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
	 <ZhSYEVCHqSOpVKMh@google.com>
	 <b4892d4cb7fea466fd82bcaf72ad3b29d28ce778.camel@intel.com>
	 <ZjrFblWaPNwXe0my@google.com>
	 <2c8cf51456efab39beb8b4af75fc0331d7902542.camel@intel.com>
	 <ZjuOUzhVIgkAQXmf@google.com>
In-Reply-To: <ZjuOUzhVIgkAQXmf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6680:EE_
x-ms-office365-filtering-correlation-id: 3fea1907-ed24-4249-3b38-08dc6f701f22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TlkycmxtZzljY1FoWW5vcVFWQlh4SjlFYzlXdE1jNzZHWmdvdDVnWk41ME5j?=
 =?utf-8?B?cnRmb0tkanIyWDVQbE1lOWdFM0s1N1VPRzRDV1VlN080ZFFjYzE4M01tYmp3?=
 =?utf-8?B?clUzd0kzVm5iMU1qU1RES2xSWWlJZzdueVRPUDZwalZGdHZZQnFENWtkamRW?=
 =?utf-8?B?S1RkWFJocm92V1FmUm1ReUJmOXJmTGJ1bEc5U0pJWGNOUnpBVmNiRldCNFNS?=
 =?utf-8?B?d0pLcUM1RWxndmFFSjM4QkJjV3VZYW10U2dvN0p4bklTVXk4c1BTWUZPYitw?=
 =?utf-8?B?cnhETENyYXFSaGU4SEN4TjlWak9IL3VFbU9jUE80UVZwNkdsZkFCZjRtK1ln?=
 =?utf-8?B?U3Q4Tld1SlltbnYxM1V1VHNzaTd4OEV2S24yMzlPNTZ1b2dUWXNJSyt4OVpD?=
 =?utf-8?B?dHBwSUt1d3ZFK0NZeVJvSjhYbDIrSytHSUtDekRHajlqOGszWDNuOTA5NnR1?=
 =?utf-8?B?TlpwUTcvNjBWUzZPZ29DNjdSRXJWRlR5bEVNaVJmVkxaNmZRbkRra254OHEx?=
 =?utf-8?B?d2pkRHlWWFdsY2JBRVZwUW1SdHdrVEJxR0RUU3QyVVcxaGcxOEtMelNzdnNy?=
 =?utf-8?B?QlJxL2xFZnRVUU11REZEUVF4MWFFTmN5ZHVKTmtjZDJ1THU1WmpjRWkvUW1U?=
 =?utf-8?B?MUZMYm13bVBKeXFKYStBa29kZ3ZoNEdKTHVJNHo0bXJBWXZSRWMrWUpHL2Zq?=
 =?utf-8?B?OWMySkRyWmlOZXFyVE9TL215TmFHRmFzMjlNS1hQb0N2WnljRmZydlQ4M2p0?=
 =?utf-8?B?ZnMyenB2UnNlbk1XaVB3a2tXMWorVGxHOGY3eHAxQ2NidWxCeERPTUFDdXRq?=
 =?utf-8?B?ajI2b2RYRTg1OVVYT0Vtci9DVjg0d1Y0aUVDK3AzMFYxOEJGN25NRWlQSWI3?=
 =?utf-8?B?V2xHeVFVbVR3VlBpSHB0MzB4ZWRmSUFRbnRaRHNDdk5NaFBlSTRtampxQWdH?=
 =?utf-8?B?S0JPWEdaby9FOFRmcWlpTlBKLzNJZ3RQdFd2QnIzREFNZ1pTRUVoNzBmdE1M?=
 =?utf-8?B?M3JYM3puU2dsaVRzU1ZsVGpPSVhxMTkxRWxsVnROd0k1NEkvMWRwdUgzVEdZ?=
 =?utf-8?B?a0xYT3dQMzRIcVRBenFtd0U5MDhJSHVFTXNuOTNmTkN4UGRqUXNDNWZqNnAz?=
 =?utf-8?B?dDNXVnQ0RWhxOUlEYk44WElyWU55UzRmNzhzQS9OTGN3NVB1WEVVTE5MT0t6?=
 =?utf-8?B?WXpTVG1sdE9Ec0k3azk3K0NFV3ZWc2ZmdG9UTFBNUXdBR1J5NzI5eSsxZlA4?=
 =?utf-8?B?eFQ1Qzg3dTF5UjlJVG94Zlg3eVpiTC9BYTB2MnZ6UEJIa1dmODNXMEl2VlZu?=
 =?utf-8?B?V1NLeFVnOGtzWEdMNmlWckRKclNSYXdXbjYwZzJvbmxNcHRoVkpXa2o5elE1?=
 =?utf-8?B?VWhUUEMrNzZUamJUb0FreUJ5ZllMZExtUzdIazdTTWk4a1BKUWtJL2RSWERS?=
 =?utf-8?B?OTVId3VBOFY3NHQrdGhCQlBmVUEydWVtWURpVFh0QTNsU0tudnJEOHg0ZXRi?=
 =?utf-8?B?UXFQL2VzMW5TcHdJdThPYXhTYktwYlVNWGdmSVMzWExTZSt6Z1I0eGlNbzJI?=
 =?utf-8?B?eEdoNUtzZmhBQW5nSVZqSUt5OUh4WFpGeXdMcm1BbjE1WnZnZHppL2dFZUl4?=
 =?utf-8?B?ZGdaTjR6bVREUVBpZW85QTJENXNyOWFGUG9mNVFIQ0VUT1I5bVZYdTF6cm1a?=
 =?utf-8?B?VFpyaldJMTlOL1JJNVZzcUMzdHkzOEFqaDBIcStYbitOaE8yQWtZWmQ2Wjhs?=
 =?utf-8?B?T2JwbUJFTTFldUhDa3pkYnpwSFJYVmFrSjZTRnRZZkNkL0xPcUlub1lDVmdJ?=
 =?utf-8?B?UlRTTnZyNWlhaVdHSWE5QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXpHTmpMeldFOUNFWlN4R2M5LzFMV053QlhXUGd4RmY1LzNwOC9JNkJDTnpO?=
 =?utf-8?B?d01FRDFVV1VCaG5DZEZ6MEdleVZYdGFmdmtzbnF6YS90ZUZzQWJvRVdFSG8r?=
 =?utf-8?B?MmVldkxrV3FaK20wOEh4QVlIRVo0WVMrdVhBbEpzdlRJcHlBNFMxYVp5S3dK?=
 =?utf-8?B?K295SExsdGpBTjMxTXBHM2lIbnFaeHl2QVRPcmxpWlExSStoNWhqZnhtYkty?=
 =?utf-8?B?bzlsbktPVkp3L1p6ZW9wN3Jhc0o0Y1NzMFJjc0JFYStvUk9BNkE5OSthT1hK?=
 =?utf-8?B?VExYMUQzbE1UNjB0K0tybE56UXZaMHIzcklXNXBnRkNZVEg3bVo3V2VGcml0?=
 =?utf-8?B?TEQzNW9DeHZjRlUzSlRuN2VhdmJzQTBzNHNYOXhqQ2pCODFZcVB2WXZHdjhs?=
 =?utf-8?B?YUtObFVHNndoaitxY2loVGlHaW93TzJPR3pPZTVJZmVqanFMYkdNY01kU25k?=
 =?utf-8?B?RE9nSXgyTjRNQ2s2UWdURXBuRi9KbUpaSU1aVGZ2STVFNXBSZGRUL1N4YlBY?=
 =?utf-8?B?UnFCVVNLVXVzNWpjWnlrRjk3S2JHQ1p1d3hGbTBWL1dObytqbW4vdm45V1hR?=
 =?utf-8?B?QW5vM3hHMnQzRjJSV2VVVGd3c1pwMUpxVCtUbm9JZWJydXBkYWZYY24rNUdI?=
 =?utf-8?B?TllzT1NFYzExdms3Mkt1MnJ2YVY5U2k5cDhibUl5OXJiSEtQUHZBZUhRSnA2?=
 =?utf-8?B?TUJPVmU3cWhHWmRlVXM3cVRZN1pLOGFTUGlLbUlWdDF5bUVtZi9JQTIrZkI3?=
 =?utf-8?B?SXlQSzI3NE0wYWVyZGgwaEkzVEpjUXNpM2NOeWFwajNTTHdKNCsvL1pvQ2tw?=
 =?utf-8?B?cUd4SEJZbzNHRVQzRzNmazN2dEdReUJPeWhZd2J3UHAzaHZSNmRwSkRYS0F3?=
 =?utf-8?B?ZUZBUG10QmJIMVFCNWRSNUJWVHRLRGRwUU0yOWFkc2tKOXFHbUhvaGhoUXdP?=
 =?utf-8?B?Rm5mdEYwZy9oek9tN3lUZ1Noei9oSk5jNUI0ODVpWXNQeFkyWXdhSUx6YWlm?=
 =?utf-8?B?QUZZNFp4NHd4eHV5RHBoamROZ3RDaWg5d2N4Yi9peGkvbEtWclljZDBVUi81?=
 =?utf-8?B?VGlOeGFSQ0EyTE5CR1NRSDNobVd1aUtMNlBxOXd5U1lNNjY5VWc0TkF5anNP?=
 =?utf-8?B?SFdTblpwaDlnYitRcEQ0S1BpRDNCK2pPWEFaRDZQYVdhczJabUxXMExrbksr?=
 =?utf-8?B?dFUyNytMR3VHa3p5cVp6Y1ZnZzk4Um9MS2hZejlqalJLcWFVc1BldEc4YzA5?=
 =?utf-8?B?UmJYV2wrMEtnczJhMGYyT1pLRWJ6REllWWQxc1kxTmZBSTVoWkpOS3RuWmZT?=
 =?utf-8?B?S2Y3UGNhK3A0amdNeHNHelA5WGdFMU9IYUpCUUQ5Q3RRUTh6RHNwNWFydFF0?=
 =?utf-8?B?cjhiVTBkYkdrU216QVNDaTNFODlMMjltUGpiYUtJZ0c4TUdONm1BRm0zVDNP?=
 =?utf-8?B?TndZQWJqK2wvLzVibjdLcGhScVhEcW4xdW5mOXFVcGxNekEyWEZyRXlZRkl5?=
 =?utf-8?B?VVQ1bWo4QXhNc1RibHZPVTNPMGhURUFDbCtsR1JXQW1QVTMrbHV0Wk1xUWo0?=
 =?utf-8?B?SlBMZng0Y1BQUmpvNERpUTRwSFpnV1U1a0x1OUl4ZWlPTXZGL2pZSnhITTdH?=
 =?utf-8?B?a0tkZlY2eVJrekhxaGZCeS82Q2pLOEdsOE9rVjdNUWhhRm40SWRGYko1SDZ4?=
 =?utf-8?B?SkZTakZ4UStRN01HZmdRdi9IbnZCWno4NDJNa2RSbktaNEFrSmlBTjRFaHAv?=
 =?utf-8?B?TGFJNWJxRTFSeG1tM0lKS3dvZnh5bWVnK1dEbzdKUDlEYjR5OHpodElrTzZW?=
 =?utf-8?B?OSttMUlxRGwzRzQ4K2MzbU9mWEN6Ymx0NGpEL2FjWlk2NWJ1UFd3dXZ0aGxH?=
 =?utf-8?B?QnpnczZFdDBXeFh1K3VZUkpQdDlQRzVvQ3N2cE4xTE1TL05ST3Z5bGsyRGNX?=
 =?utf-8?B?K0R3YjcvSnFQRUt6L2xjQlBYMlZmSjg3dk5qeDlmcVo4VVJobXloT0pZcnJw?=
 =?utf-8?B?dGdBL2hySHE1RU0zNTcyQ2dLMUllVUM3QTM2TkxZQ3Y2dWFncjY5cVBuc2dQ?=
 =?utf-8?B?YjBCR1VKUEU0bW0rSGVWR00ya3c1QWZEUU94bEE4aWdPWVVOK0FIMGhpdUFv?=
 =?utf-8?B?NHYrd0lYMEh0WThmU01FWlQ3Wkk2SFJpdDRFTlZMTVJ4eUpsTWNEaitkMjF3?=
 =?utf-8?Q?uq09hkWV1UwkC8h97ccb8mg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F91EF055747DE24FAFAD45CF17A155BD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fea1907-ed24-4249-3b38-08dc6f701f22
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2024 15:04:12.9092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yjy4Lrk68rugbgKrmODa6/UAw4RcObR7DLlOIiomHyz+J5Sw9nwdUtVroRgtibP9RI9Q0wRSvUHtfGd8sgQ48niZc84YBXSZCIGnROCoMxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTA4IGF0IDA3OjM4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IE9rLCB0aGFua3MgZm9yIGNsYXJpZmljYXRpb24uIFNvIGl0J3MgbW9yZSBvZiBh
IHN0cmF0ZWdpYyB0aGluZyB0byBtb3ZlIG1vcmUNCj4gPiB6YXBwaW5nIGxvZ2ljIGludG8gdXNl
cnNwYWNlIHNvIHRoZSBsb2dpYyBjYW4gY2hhbmdlIHdpdGhvdXQgaW50cm9kdWNpbmcNCj4gPiBr
ZXJuZWwNCj4gPiByZWdyZXNzaW9ucy4NCj4gDQo+IFlvdSdyZSBfcmVhbGx5XyByZWFkaW5nIHRv
byBtdWNoIGludG8gbXkgc3VnZ2VzdGlvbi7CoCBBcyBhYm92ZSwgbXkgc3VnZ2VzdGlvbg0KPiB3
YXMgdmVyeSBzcHVyIG9mIHRoZSBtb21lbW50LsKgIEkgaGF2ZW4ndCBwdXQgbXVjaCB0aG91Z2h0
IGludG8gdGhlIHRyYWRlb2Zmcw0KPiBhbmQNCj4gc2lkZSBlZmZlY3RzLg0KDQpJJ20gbm90IHRh
a2luZyBpdCBhcyBhIG1hbmRhdGUuIEp1c3QgdHJ5aW5nIHRvIGdsZWFuIHlvdXIgaW5zaWdodHMu
IFRoYXQgc2FpZCwNCkknbSByZWFsbHkgb24gdGhlIGZlbmNlIGFuZCBzbyBsZWFuaW5nIG9uIHlv
dXIgaW50dWl0aW9uIGFzIHRoZSB0aWUgYnJlYWtlci4NCg0KRm9yIFREWCdzIHVzYWdlIGEgc3Ry
dWN0IGt2bSBib29sIHNlZW1zIHNpbXBsZXIgY29kZSB3aXNlIGluIEtWTSwgYW5kIGZvcg0KdXNl
cnNwYWNlLiBCdXQgdGhlIHphcHBpbmcgbG9naWMgYXMgQUJJIHByb2JsZW0gc2VlbXMgbGlrZSBh
IHJlYXNvbmFibGUgdGhpbmcgdG8NCnRoaW5rIGFib3V0IHdoaWxlIHdlIGFyZSBkZXNpZ25pbmcg
bmV3IEFCSS4gT2YgY291cnNlLCBpdCBhbHNvIG1lYW5zIEtWTSBoYXMgdG8NCmJlIHJlc3BvbnNp
YmxlIG5vdyBmb3Igc2FmZWx5IHphcHBpbmcgbWVtb3J5IGZyb20gYSB2YXJpZXR5IG9mIHVzZXJz
cGFjZQ0KYWxnb3JpdGhtcy4gU28gaXQgc29tZXdoYXQgbWFrZXMgS1ZNJ3Mgam9iIGVhc2llciwg
YW5kIHNvbWV3aGF0IG1ha2VzIGl0IGhhcmRlci4NCg0KVGhlIHJlYWwgaXNzdWUgbWlnaHQgYmUg
dGhhdCB0aGF0IHByb2JsZW0gd2FzIG5ldmVyIGRlYnVnZ2VkLiBXaGlsZSB0aGVyZSBpcyBubw0K
ZXZpZGVuY2UgaXQgd2lsbCBhZmZlY3QgVERYcywgaXQgcmVtYWlucyBhIHBvc3NpYmlsaXR5LiBC
dXQgd2UgY2FuJ3QgZG8gdGhlIHphcA0Kcm9vdHMgdGhpbmcgZm9yIFREWCwgc28gaW4gdGhlIGVu
ZCB0aGUgQUJJIGRlc2lnbiB3aWxsIG5vdCBhZmZlY3QgVERYIGV4cG9zdXJlDQplaXRoZXIgd2F5
LiBCdXQgbWFraW5nIGl0IGEgbm9ybWFsIGZlYXR1cmUgd2lsbCBhZmZlY3QgZXhwb3N1cmUgZm9y
IG5vcm1hbCBWTXMuDQpTbyB3ZSBhcmUgYWxzbyBiYWxhbmNpbmcgQUJJIGZsZXhpYmlsaXR5IHdp
dGggZXhwb3N1cmUgdG8gdGhhdCBzcGVjaWZpYyBidWcuDQoNCg==

