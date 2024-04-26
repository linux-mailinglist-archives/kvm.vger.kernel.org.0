Return-Path: <kvm+bounces-16006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAAD8B2DF0
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 02:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1A881F2201C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD74EA4;
	Fri, 26 Apr 2024 00:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A04g+48E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C7620;
	Fri, 26 Apr 2024 00:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714090916; cv=fail; b=Cdjm3iJcx0KQd2ezoUHsk+fibw6JYHu0H76XoK1VZ1fW3lO58Oq5M9Ma10v0fP3Bi62y/oBSrKdwgBmeDNBhz//do+5iUzWls1eRuXOX9YByP6KgT1LOmGve5NqFsQiWg66foiaiqnurtPNihMmjL+aHXJxQyC9EVC+PA8r3p3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714090916; c=relaxed/simple;
	bh=4tC9SgHOf+WX6Dh1NbZoVbVu8dnM0JO4VqarFlm9Y9Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YBeF/IZUrCnmySbEy9J9ICTGNVkJJP5OOhYU+t3C7FTYG0FP2xlKbkrKDrs0dbJboeBYhbZxoExVF0YFCrpEbMxwqiMgxhBgzTMloEUR2+zmxguf88k32aCE8GYG5BpFdIkzya+Qxx8KKlzKgoERshME+7Q+GnUkAc6emcbiGhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A04g+48E; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714090914; x=1745626914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4tC9SgHOf+WX6Dh1NbZoVbVu8dnM0JO4VqarFlm9Y9Y=;
  b=A04g+48Ew2k4hNuFSTtK+i8Ak4l3U008xf5QjfFpEwjoAJVnzpTfrN6p
   eG58ERYFW72aubRiKRroemMAntyglnMFIVRTM/cIzyaDU0nq1SS1b9JrD
   6IPzyMuj4+5yFAiUFqdN7kto7FxZNjXjNNVJxKzENDGiGL7Ur4EPv1gSI
   yZLTzrTrmEWcUqMXuozQ4ZAeX2KiDgkdnx42EjnpJM3wZ6ay4vZJaOgcM
   +FZPt9zf1FdoAuB7FpZY3iccP+Iivv5ZasEYyZKiDhAREoKImERKwYM6o
   1efCU5rL5c7q2gUbKlbjpiI0h+XpM3ttD/NZbJaw5X/wAi8o5nfkTBg93
   Q==;
X-CSE-ConnectionGUID: /XNxJgPiR4y9LK91j1Sp0Q==
X-CSE-MsgGUID: J0lnVUwLSHmb9JZ3N3p8rg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="20425799"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="20425799"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 17:21:50 -0700
X-CSE-ConnectionGUID: YQgsCPbgQV2W1EiImEnlOw==
X-CSE-MsgGUID: vMKXH+UXTqePyiTnBkPZiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25303292"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 17:21:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 17:21:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 17:21:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 17:21:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 17:21:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+jJH2O9hRSZTsFB7MgDawVDQOTJHWRHNs9GoR9gxZfcDywPfiIRmGSzZXmOBCCoURO3Ytee+Ldtoavy6sbXEx5Yfgvq8PPAlX8XM+QusZnhaKdFI5u7xqrE9G4THTJGlq94PBN/b5L3FrEPe59mJh7HO5yCoCFetMb5By25SMbVxirtelYKmatZP4kZuOrLb4L7fGTYdwXrvi4SDD6qqGJzdzb3WI/WtgudlQGtKdVuKUfMppfE6MZ92lzwdOpP4KSF/Th5K4mBBYDVXUV4GddyOBLSmfBNvM/edOGb5wK2f+c9sSOmsK3yHC4qHt5BHxsHyty93JYfPmD5iUAC8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tC9SgHOf+WX6Dh1NbZoVbVu8dnM0JO4VqarFlm9Y9Y=;
 b=i899hz9/FRAjCUghWZOVmFw8Q0hp7NK1X3wq5UF03UuJi4ndF8hAiqYftFU/9n0k5khKpsGHZ8zKD46dfjQYqPdiZJa/j1q6fVk0pwimp/qgRUdQYs6OIPWpLeiGDPDHY9/Brk0c/t04M0Zav1wbpZo/Qbicnj4RNW9UEZ8G1dYS0vDlcR3v7U4hddXOchVquJKzzTRoULhCRQroPbJF0vKE4Y2vBz2yprUmr/qIxGLdJpZE93nTh8farkftxSQcvJJ2/kgVQzryGJhqQcYajU5ka7/zpxIVgu/sQnoImvS6llf7R6Y2Y6+6XjMlwluhaUfkMEzls7NtkSoAG3cKJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4534.namprd11.prod.outlook.com (2603:10b6:208:265::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Fri, 26 Apr
 2024 00:21:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 00:21:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAIAAAz+AgADiNACAAIG7gIACuUQAgABYxACAAAQogIAAJWeA
Date: Fri, 26 Apr 2024 00:21:46 +0000
Message-ID: <2caa30250d3f6e04f4e23af96caed0f92bf5f8c3.camel@intel.com>
References: <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
	 <ZiaWMpNm30DD1A-0@google.com>
	 <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
	 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
	 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
	 <ZifQiCBPVeld-p8Y@google.com>
	 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
	 <ZiqGRErxDJ1FE8iA@google.com>
	 <22821630a2616990e5899252da3f29691b9c9ea8.camel@intel.com>
	 <ZirUN9G-Y1VUSlDB@google.com>
In-Reply-To: <ZirUN9G-Y1VUSlDB@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4534:EE_
x-ms-office365-filtering-correlation-id: 6e660459-d10c-47c7-7edb-08dc6586dbc9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?QWxZWnUweUE1RHhRajJHbzdVd2l6ZjY4ZG5GcVFLRzJaM2RGSmluV014TWpB?=
 =?utf-8?B?bWJxa3VnRjdjTHR5MHdEZi9BRXU0WHhoNkhoc01vQTBzeVViTnVqMU1HQ1ov?=
 =?utf-8?B?cWRMY1FyZDNtdUx1aERXelRYR25JVHI5OFBvZFYxbXBUTGgyNThUQXVRaXpL?=
 =?utf-8?B?Rk5OYk5kQis4ZmI0bC9NbWpyZUo1MVcvelo5V1RlbmRBWU5QQXh5TGg1ZnRi?=
 =?utf-8?B?SE15bUJWTkRtMWdTeUgvTGRSdldSVDNoNWVHNEo5NGFPWnBWbU9lUGRvYlB2?=
 =?utf-8?B?S1BhWWlRaUFCM0w3bE1kQ01zckJqOHFXcDFqdmlaL29GeUtjWEthY01icVVx?=
 =?utf-8?B?MjA0dGU1SWpCSFJMVy9EREVGTU5xZ00vZnVLRERaSzU2NUd1elZmRjJLRG5T?=
 =?utf-8?B?M1lkKzhZN0wrS21BS002dzFvSXFxSEhrd0pacFlBRVRMMWFTTGZHb1NWQU9K?=
 =?utf-8?B?OSt1UXJtVDVELzdwRTZoVEFwcXpaa2JYYjFOMEJPK1VpWmlUMFY5SXBQZC9u?=
 =?utf-8?B?VFMzTk5oTzdTT1dKaEkwMkhZOUYyOSt5UXMvcmVra3hVMHdMZGROUnRSdzIv?=
 =?utf-8?B?bEQ2MVRlVzdvZWtUbDdRcE5zai8ySEJFb0JEMnN2WTdJQmRrR21wcnZZbzNR?=
 =?utf-8?B?bnZ6OU5JTWR4a1dlL1dSOWpaZzlpUXVWY1oxNWVUeTlHb2ZMRG4rai9GQVl2?=
 =?utf-8?B?bVJNTGdEb1ZGc0lkYS9mdk5yK0UySmVBYXZvREV0QjVUK0ZXVkRkWG5FYXpm?=
 =?utf-8?B?S3owb0prMmkzZ2xsM0dDVjZjN29LeHF1TEl5WXFLeU8xM3NiMkJDSW1OMGds?=
 =?utf-8?B?THNGREJnaS9WUG01Y05lc3cwUDFVNVg5V2d4N3p1MUZrZ0R6NHBBWVFBcEVu?=
 =?utf-8?B?b3B1SmczbWYwMXd2T21uUVNlaHhaMUM4cjB2N3daalZEYyt5TFVNTEpYYzE0?=
 =?utf-8?B?L2pMT3VzWGlWVHEveDdqbC9pcEY2K3RrOW04ajZ1L1Focjl1eU40YjZMc24v?=
 =?utf-8?B?b09KU0dpOEZ6WFRJV1ZqbFc5L1pTNWN4WE83N1NXUU9RRzdzYkNvM0w0NDMr?=
 =?utf-8?B?OE1WWmxHdUR2SDVhWGNrWkt2Ungyb1VocEhqYWZ1eDlyMDZJWHNHd0dUd3hj?=
 =?utf-8?B?MVVOWkZmU2pWR21nTW5FcWN1U3FnYTdmZ01oeGlvaXRpWFFsRUlWVVN1Y3Ex?=
 =?utf-8?B?TThsMDNNQXVvWDdDRUF1eURreGFicjVtdFRVNGZ6R2JiYUQvdUJ4OHRtblpv?=
 =?utf-8?B?TnhvekJicUdraE1JZ1c0dW5Ed0NORXZhckdTWlQ2Q1BDVDdhRmxxNGZXYlRv?=
 =?utf-8?B?dzdIazVORUxnaVR0ZjdiRktIOEQ0RTJrUzlhY2tqK0FlOEdyT1pqY2tUUlI2?=
 =?utf-8?B?bGQxOW9sdXhkUlg2WWJFY3BoeXNjN2kxdENsa2RUQkNTd2YyalBpckJXb2tO?=
 =?utf-8?B?WDhGUk1MNEdrU0c1MmdZWlRqUElWZVkvWjc0T2dNY3ZXM2ZQWHdQR3NIMys2?=
 =?utf-8?B?aWtlbGJBV015QkIveldYVzdHVEg3djZjaCtic1JDa0owZGh3TmNPUVlZRkJu?=
 =?utf-8?B?cVArc2E2TDBMRGZETURLeHFONU5DWENjTFZoajlyY3hMcU82N3hpM1dORWhp?=
 =?utf-8?B?amlKTUp6ekp3T3RFSUJ0eXZmRmhMeXBCSEhOakNSaFk3eEtjRk14bTJEVk4z?=
 =?utf-8?B?VFZEclN4RTM2blFsMk4yRVBYSWllMlNWSUhxajYzdTM3bWJaU09DdEVHQWZP?=
 =?utf-8?B?NWJHVUhoQUhFQ3B3bllsdjVrNHYvUXhoUVN6QXlJVCtQZjVJbVZrY3BaQjFw?=
 =?utf-8?B?d0NPbEJmcHlLdUlhbFpiZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU9OWVl1Y1E4Q094blpNc2ozVzdhdjBKeEVsdC9vWXZlb3J3SmlsRWNSMDlP?=
 =?utf-8?B?cndWN0VqTENScVZHY3l5WnFtU3k3SjFncTdhYTd1SDVyQzMyWnMrbTUrOFlW?=
 =?utf-8?B?VnF2b21pdU1DU1IwNjY5SFRUU1lkU2ttVEJtYmprK1NWYjB4VTZaSDArQTJz?=
 =?utf-8?B?UTVraVJVblgzTW1BTlpNTEZ0cyttYkYvUzZwZWhaK1B5dEo3VHA0ZDhEWlJh?=
 =?utf-8?B?c082U3BMSk1qdXcyT05tQitManZ4T0NaYmg3aDlXY3lOSDJydlFNS1pVbUQ5?=
 =?utf-8?B?TGJ5Qm9YSWpsUGlkYk1nWUVPRDJDMXpRb1drbm9TdzFQUGZXNCtGZG1tSFZQ?=
 =?utf-8?B?TU5NelpqUDYrUDF4dStYWU1EdWZMcnFMNHY0bEhTRk52QlMxNlZPamljUFhB?=
 =?utf-8?B?ZFNIRlBqVGsvZGp5WDRmeDYvN3V6R1FpMDJMZFBnNEVIaUg2dlBVdXVnci8z?=
 =?utf-8?B?cUR4Wm5rWkorZEhqWlpFUUNsZG80VzJQQ3A3T2hwTk0vbWNKL0JOaisxYUJ1?=
 =?utf-8?B?djZldFpiZE9ESytGUFl0M2cxZXdKQTg0K1prbGZLbktwM2k5bm1YSEIxblBp?=
 =?utf-8?B?MUpPaGZhclBaRE8yK2RIaGhoTG8rL1d2cThoMzVjV1hMVG90dkg3Z2pYOUp2?=
 =?utf-8?B?RUZkdER6SklKcVNlaW14MUZ5eHZnVFNvQjJEY0Q1SEM4V1d4dUdjQzZabWY0?=
 =?utf-8?B?ejdKNFZGL2F1M2FLTnp0MjVaRDNBY0tPdjFWNU9yTjd5WWlIMndMdlFaT2gv?=
 =?utf-8?B?dFZyZXdzN1lmTGRvRHdyWlA4SFNGMVI5U3ZCWjNvemx0QXAzajgyck5Fa2JU?=
 =?utf-8?B?VHNjQ24xWUhNbWFsc0RjeWxrdmVWUjFDNkJPRjhLUHo0ejNsOEVzRHZycWZU?=
 =?utf-8?B?T0R1T3ZTNUcrSUgzQ1pUbG1pYTEwU1BFcERIb3EzMWJQWWprcERabUhQVTZW?=
 =?utf-8?B?SEZFK04vdFRZVlRnRW9xY2w2V2FCUVJBcXltaWVQUWd1c3pKRDRnb091eWJP?=
 =?utf-8?B?YlV0MXBXbm4waWFKWnE1U0hndXJmUFV2bE5xUDZvbjJFMkpQenRUSFVtZXhm?=
 =?utf-8?B?TW45RUVzUi85U08wZENid3RYTE8xa241b1NCTE9XdTZUSVhzYWVzL2E2UWt6?=
 =?utf-8?B?MzFidUIvMzN1RS9hNEllSzNiR1piQ05pSzN2YVI4enNIQmdOeDNWcmhQRnFv?=
 =?utf-8?B?bmp1UjJpZGZUYkpkTTNwTTQvbXFpclB6elloMFRHOXJsU3VkSDFRRkE2N0k4?=
 =?utf-8?B?eXRFU2p0Z05mK05XMlovMTZWdnhKNGNCVWl4c04wcGs3cnBhSVh1TXQrZmQ5?=
 =?utf-8?B?K3RCdm10ckdualhVVXJWQ2t0VHJQWEE4emR3Mm13eWZucU1BVmhlZXg3LzFq?=
 =?utf-8?B?b3VCU2JUa1J2K1F5ZEhJajFkU2JUYzNROTE5cm5SNkhxTU1oUzFxanBUcW9P?=
 =?utf-8?B?NkQ2RzhBR2NCRzh4Q1RBZTlJNUZVc2N6TXJsTjhBOU9ES1U1Yk5rM2lvem5u?=
 =?utf-8?B?ci9zVFdUbmdJblFheUw1YVJOS3pOcytIWTBUQzhJNE13N29ZektRWWRROHdh?=
 =?utf-8?B?cWxjN2M0YXFSVDZjMDFTZGhJcU51aWs5bkxtOXQyNjNpaCtKSWpFVE1zQXpH?=
 =?utf-8?B?d0NGYjZaRXhlTnh2KzV2Mzlsc25qZkhPRVlKdXBmN3gzaE56VXpSaExhczdO?=
 =?utf-8?B?ME5nWUVWaHBjenFhWnRCb1JSV3NCRWcremQrUmxNQlFmWHZ4TnM3TjVEWlE3?=
 =?utf-8?B?N3lGYTNGanZKRkM2WlQ3Z3VUTnREWlFQY04yVGtKS3N0K2NkOWM3akVyUTcw?=
 =?utf-8?B?cTd5WStOVG1MVlFUMVJvYjkyeDlHZUdjY2ZDUGtSeU5NcUZjMDkyTmJlU0Nu?=
 =?utf-8?B?VUp3UlNSelg5L0xuc00xRk95L2kyYm9VdDdqY0N1RjVZYzk2QjlMZ2pwaE1T?=
 =?utf-8?B?KzhhVXNrdFVtN1RVY004MmZZelZSRmNHWm9ZbVVUR25MSVlmWS9hQ1RkeGRv?=
 =?utf-8?B?TlQ3c3hkQitSVG44SXNDclBPNUh3NHI4MHU1M3BmRTI3SGhyVUFZRE9iUUxU?=
 =?utf-8?B?bXVzVG1NZ2YzUlNvYmJhUVRieGNTL3MxcUkvMVJTUTdqY2taQktDdTlTYXBY?=
 =?utf-8?B?L3V5emRJeWNEMTJTUktMN3VnOHh2bXluRnU2Z0gwcEYya0FQbUxacUVwZ2Jw?=
 =?utf-8?B?TVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4104B269B5E6CD449B3B05FF8E2640C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e660459-d10c-47c7-7edb-08dc6586dbc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2024 00:21:46.6776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TMCBaB6V9TYPplyEr8Gtf66XQ91VaUT/S1cbw5xxPOA1p/ki8d93X4yow0QJB6PcUWoiwh5GiEZuF++tF7zecg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4534
X-OriginatorOrg: intel.com

DQo+IA0KPiA+ID4gVGhlIGltcG9ydGFudCB0aGluZyBpcyB0aGF0IHRoZXkncmUgaGFuZGxlZCBi
eSBfb25lXyBlbnRpdHkuICBXaGF0IHdlIGhhdmUgdG9kYXkNCj4gPiA+IGlzIHByb2JhYmx5IHRo
ZSB3b3JzdCBzZXR1cDsgVk1YT04gaXMgaGFuZGxlZCBieSBLVk0sIGJ1dCBURFguU1lTLkxQLklO
SVQgaXMNCj4gPiA+IGhhbmRsZWQgYnkgY29yZSBrZXJuZWwgKHNvcnQgb2YpLg0KPiA+IA0KPiA+
IEkgY2Fubm90IGFyZ3VlIGFnYWluc3QgdGhpcyA6LSkNCj4gPiANCj4gPiBCdXQgZnJvbSB0aGlz
IHBvaW50IG9mIHZpZXcsIEkgY2Fubm90IHNlZSBkaWZmZXJlbmNlIGJldHdlZW4gdGR4X2VuYWJs
ZSgpDQo+ID4gYW5kIHRkeF9jcHVfZW5hYmxlKCksIGJlY2F1c2UgdGhleSBib3RoIGluIGNvcmUt
a2VybmVsIHdoaWxlIGRlcGVuZCBvbiBLVk0NCj4gPiB0byBoYW5kbGUgVk1YT04uDQo+IA0KPiBN
eSBjb21tZW50cyB3ZXJlIG1hZGUgdW5kZXIgdGhlIGFzc3VtcHRpb24gdGhhdCB0aGUgY29kZSB3
YXMgTk9UIGJ1Z2d5LCBpLmUuIGlmDQo+IEtWTSBkaWQgTk9UIG5lZWQgdG8gY2FsbCB0ZHhfY3B1
X2VuYWJsZSgpIGluZGVwZW5kZW50IG9mIHRkeF9lbmFibGUoKS4NCj4gDQo+IFRoYXQgc2FpZCwg
SSBkbyB0aGluayBpdCBtYWtlcyB0byBoYXZlIHRkeF9lbmFibGUoKSBjYWxsIGFuIHByaXZhdGUv
aW5uZXIgdmVyc2lvbiwNCj4gZS5nLiBfX3RkeF9jcHVfZW5hYmxlKCksIGFuZCB0aGVuIGhhdmUg
S1ZNIGNhbGwgYSBwdWJsaWMgdmVyc2lvbi4gIEFsdGVybmF0aXZlbHksDQo+IHRoZSBrZXJuZWwg
Y291bGQgcmVnaXN0ZXIgeWV0IGFub3RoZXIgY3B1aHAgaG9vayB0aGF0IHJ1bnMgYWZ0ZXIgS1ZN
J3MsIGkuZS4gZG9lcw0KPiBURFguU1lTLkxQLklOSVQgYWZ0ZXIgS1ZNIGhhcyBkb25lIFZNWE9O
IChpZiBURFggaGFzIGJlZW4gZW5hYmxlZCkuDQoNCldlIHdpbGwgbmVlZCB0byBoYW5kbGUgdGR4
X2NwdV9vbmxpbmUoKSBpbiAic29tZSBjcHVocCBjYWxsYmFjayIgYW55d2F5LA0Kbm8gbWF0dGVy
IHdoZXRoZXIgdGR4X2VuYWJsZSgpIGNhbGxzIF9fdGR4X2NwdV9lbmFibGUoKSBpbnRlcm5hbGx5
IG9yIG5vdCwNCmJlY2F1c2Ugbm93IHRkeF9lbmFibGUoKSBjYW4gYmUgZG9uZSBvbiBhIHN1YnNl
dCBvZiBjcHVzIHRoYXQgdGhlIHBsYXRmb3JtDQpoYXMuDQoNCkZvciB0aGUgbGF0dGVyIChhZnRl
ciB0aGUgIkFsdGVybmF0aXZlbHkiIGFib3ZlKSwgYnkgInRoZSBrZXJuZWwiIGRvIHlvdQ0KbWVh
biB0aGUgY29yZS1rZXJuZWwgYnV0IG5vdCBLVk0/DQoNCkUuZy4sIHlvdSBtZWFuIHRvIHJlZ2lz
dGVyIGEgY3B1aHAgYm9vayBfaW5zaWRlXyB0ZHhfZW5hYmxlKCkgYWZ0ZXIgVERYIGlzDQppbml0
aWFsaXplZCBzdWNjZXNzZnVsbHk/DQoNClRoYXQgd291bGQgaGF2ZSBwcm9ibGVtIGxpa2Ugd2hl
biBLVk0gaXMgbm90IHByZXNlbnQgKGUuZy4sIEtWTSBpcw0KdW5sb2FkZWQgYWZ0ZXIgaXQgZW5h
YmxlcyBURFgpLCB0aGUgY3B1aHAgYm9vayB3b24ndCB3b3JrIGF0IGFsbC4NCg0KSWYgd2UgZXZl
ciB3YW50IGEgbmV3IFREWC1zcGVjaWZpYyBjcHVocCBob29rICJhdCB0aGlzIHN0YWdlIiwgSU1I
TyBpdCdzDQpiZXR0ZXIgdG8gaGF2ZSBpdCBkb25lIGJ5IEtWTSwgaS5lLiwgaXQgZ29lcyBhd2F5
IHdoZW4gS1ZNIGlzIHVubG9hZGVkLg0KDQpMb2dpY2FsbHksIHdlIGhhdmUgdHdvIGFwcHJvYWNo
ZXMgaW4gdGVybXMgb2YgaG93IHRvIHRyZWF0DQp0ZHhfY3B1X2VuYWJsZSgpOg0KDQoxKSBXZSB0
cmVhdCB0aGUgdHdvIGNhc2VzIHNlcGFyYXRlbHk6IGNhbGxpbmcgdGR4X2NwdV9lbmFibGUoKSBm
b3IgYWxsDQpvbmxpbmUgY3B1cywgYW5kIGNhbGxpbmcgaXQgd2hlbiBhIG5ldyBDUFUgdHJpZXMg
dG8gZ28gb25saW5lIGluIHNvbWUNCmNwdWhwIGhvb2suIMKgQW5kIHdlIG9ubHkgd2FudCB0byBj
YWxsIHRkeF9jcHVfZW5hYmxlKCkgaW4gY3B1aHAgYm9vayB3aGVuDQp0ZHhfZW5hYmxlKCkgaGFz
IGRvbmUgc3VjY2Vzc2Z1bGx5Lg0KDQpUaGF0IGlzOsKgDQoNCmEpIHdlIGFsd2F5cyBjYWxsIHRk
eF9jcHVfZW5hYmxlKCkgKG9yIF9fdGR4X2NwdV9lbmFibGUoKSkgaW5zaWRlDQp0ZHhfZW5hYmxl
KCkgYXMgdGhlIGZpcnN0IHN0ZXAsIG9yLA0KDQpiKSBsZXQgdGhlIGNhbGxlciAoS1ZNKSB0byBt
YWtlIHN1cmUgb2YgdGR4X2NwdV9lbmFibGUoKSBoYXMgYmVlbiBkb25lIGZvcg0KYWxsIG9ubGlu
ZSBjcHVzIGJlZm9yZSBjYWxsaW5nIHRkeF9lbmFibGUoKS4NCg0KU29tZXRoaW5nIGxpa2UgdGhp
czoNCg0KCWlmIChlbmFibGVfdGR4KSB7DQoJCWNwdWhwX3NldHVwX3N0YXRlKENQVUhQX0FQX0tW
TV9PTkxJTkUsIGt2bV9vbmxpbmVfY3B1LMKgDQoJCQkuLi4pOw0KDQoJCWNwdXNfcmVhZF9sb2Nr
KCk7DQoJCW9uX2VhY2hfY3B1KHRkeF9jcHVfZW5hYmxlLCAuLi4pOyAvKiBvciBkbyBpdCBpbnNp
ZGXCoA0KCQkJCQkJICAgKiBpbiB0ZHhfZW5hYmxlKCkgKi8NCgkJZW5hYmxlX3RkeCA9IHRkeF9l
bmFibGUoKTsNCgkJaWYgKGVuYWJsZV90ZHgpDQoJCQljcHVocF9zZXR1cF9zdGF0ZShDUFVIUF9B
UF9PTkxJTkVfRFlOLA0KCQkJCXRkeF9vbmxpbmVfY3B1LCAuLi4pOw0KCQljcHVzX3JlYWRfdW5s
b2NrKCk7DQoJfQ0KDQoJc3RhdGljIGludCB0ZHhfb25saW5lX2NwdSh1bnNpZ25lZCBpbnQgY3B1
KQ0KCXsNCgkJdW5zaWduZWQgbG9uZyBmbGFnczsNCgkJaW50IHJldDsNCg0KCQlpZiAoIWVuYWJs
ZV90ZHgpDQoJCQlyZXR1cm4gMDsNCg0KCQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7DQoJCXJldCA9
IHRkeF9jcHVfZW5hYmxlKCk7DQoJCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsNCg0KCQlyZXR1
cm4gcmV0Ow0KCX0NCg0KMikgV2UgdHJlYXQgdGR4X2NwdV9lbmFibGUoKSBhcyBhIHdob2xlIGJ5
IHZpZXdpbmcgaXQgYXMgdGhlIGZpcnN0IHN0ZXAgdG8NCnJ1biBhbnkgVERYIGNvZGUgKFNFQU1D
QUxMKSBvbiBhbnkgY3B1LCBpbmNsdWRpbmcgdGhlIFNFQU1DQUxMcyBpbnZvbHZlZA0KaW4gdGR4
X2VuYWJsZSgpLg0KDQpUaGF0IGlzLCB3ZSAqdW5jb25kaXRpb25hbGx5KiBjYWxsIHRkeF9jcHVf
ZW5hYmxlKCkgZm9yIGFsbCBvbmxpbmUgY3B1cywNCmFuZCB3aGVuIGEgbmV3IENQVSB0cmllcyB0
byBnbyBvbmxpbmUuDQoNClRoaXMgY2FuIGJlIGhhbmRsZWQgYXQgb25jZSBpZiB3ZSBkbyB0ZHhf
Y3B1X2VuYWJsZSgpIGluc2lkZSBLVk0ncyBjcHVocA0KaG9vazoNCg0KCXN0YXRpYyBpbnQgdnRf
aGFyZHdhcmVfZW5hYmxlKHVuc2lnbmVkIGludCBjcHUpDQoJew0KCQl2bXhfaGFyZHdhcmVfZW5h
YmxlKCk7DQoNCgkJbG9jYWxfaXJxX3NhdmUoZmxhZ3MpOw0KCQlyZXQgPSB0ZHhfY3B1X2VuYWJs
ZSgpOw0KCQlsb2NhbF9pcnFfcmVzdG9yZShmbGFncyk7DQoNCgkJLyoNCgkJICogLUVOT0RFViBt
ZWFucyBURFggaXMgbm90IHN1cHBvcnRlZCBieSB0aGUgcGxhdGZvcm0NCgkJICogKFREWCBub3Qg
ZW5hYmxlZCBieSB0aGUgaGFyZHdhcmUgb3IgbW9kdWxlIGlzDQoJCSAqIG5vdCBsb2FkZWQpIG9y
IHRoZSBrZXJuZWwgaXNuJ3QgYnVpbHQgd2l0aCBURFguDQoJCSAqDQoJCSAqIEFsbG93IENQVSB0
byBnbyBvbmxpbmUgYXMgdGhlcmUncyBubyB3YXkga2VybmVsDQoJCSAqIGNvdWxkIHVzZSBURFgg
aW4gdGhpcyBjYXNlLg0KCQkgKg0KCQkgKiBPdGhlciBlcnJvciBjb2RlcyBtZWFucyBURFggaXMg
YXZhaWxhYmxlIGJ1dCBzb21ldGhpbmcNCgkJICogd2VudCB3cm9uZy4gIFByZXZlbnQgdGhpcyBD
UFUgdG8gZ28gb25saW5lIHNvIHRoYXQNCgkJICogVERYIG1heSBzdGlsbCB3b3JrIG9uIG90aGVy
IG9ubGluZSBDUFVzLg0KCQkgKi8NCgkJaWYgKHJldCAmJiByZXQgIT0gLUVOT0RFVikNCgkJCXJl
dHVybiByZXQ7DQoNCgkJcmV0dXJuIHJldDsNCgl9DQoNClNvIHdpdGggeW91ciBjaGFuZ2UgdG8g
YWx3YXlzIGVuYWJsZSB2aXJ0dWFsaXphdGlvbiB3aGVuIFREWCBpcyBlbmFibGVkDQpkdXJpbmcg
bW9kdWxlIGxvYWQsIHdlIGNhbiBzaW1wbHkgaGF2ZToNCg0KCWlmIChlbmFibGVfdGR4KQ0KCQlj
cHVocF9zZXR1cF9zdGF0ZShDUFVIUF9BUF9LVk1fT05MSU5FLCBrdm1fb25saW5lX2NwdSzCoA0K
CQkJLi4uKTsNCg0KCQljcHVzX3JlYWRfbG9jaygpOw0KCQllbmFibGVfdGR4ID0gdGR4X2VuYWJs
ZSgpOw0KCQljcHVzX3JlYWRfdW5sb2NrKCk7DQoJfQ0KDQpTbyBkZXNwaXRlIHRoZSBjcHVzX3Jl
YWRfbG9jaygpIGFyb3VuZCB0ZHhfZW5hYmxlKCkgaXMgYSBsaXR0bGUgYml0IHNpbGx5LA0KdGhl
IGxvZ2ljIGlzIGFjdHVhbGx5IHNpbXBsZXIgSU1ITy4NCg0KKGxvY2FsX2lycV9zYXZlKCkvcmVz
dG9yZSgpIGFyb3VuZCB0ZHhfY3B1X2VuYWJsZSgpIGlzIGFsc28gc2lsbHkgYnV0IHRoYXQNCmlz
IGEgY29tbW9uIHByb2JsZW0gdG8gYm90aCBhYm92ZSBzb2x1dGlvbiBhbmQgY2FuIGJlIGNoYW5n
ZWQNCmluZGVwZW5kZW50bHkpLg0KDQpBbHNvLCBhcyBJIG1lbnRpb25lZCB0aGF0IHRoZSBmaW5h
bCBnb2FsIGlzIHRvIGhhdmUgYSBURFgtc3BlY2lmaWMgQ1BVSFANCmhvb2sgaW4gdGhlIGNvcmUt
a2VybmVsIF9CRUZPUkVfIGFueSBpbi1rZXJuZWwgVERYIHVzZXIgKEtWTSkgdG8gbWFrZSBzdXJl
DQphbGwgb25saW5lIENQVXMgYXJlIFREWC1jYXBhYmxlLiDCoA0KDQpXaGVuIHRoYXQgaGFwcGVu
cywgSSBjYW4ganVzdCBtb3ZlIHRoZSBjb2RlIGluIHZ0X2hhcmR3YXJlX2VuYWJsZSgpIHRvDQp0
ZHhfb25saW5lX2NwdSgpIGFuZCBkbyBhZGRpdGlvbmFsIFZNWE9GRiBpbnNpZGUgaXQsIHdpdGgg
dGhlIGFzc3VtcHRpb24NCnRoYXQgdGhlIGluLWtlcm5lbCBURFggdXNlcnMgc2hvdWxkIG1hbmFn
ZSBWTVhPTi9WTVhPRkYgb24gdGhlaXIgb3duLiANClRoZW4gYWxsIFREWCB1c2VycyBjYW4gcmVt
b3ZlIHRoZSBoYW5kbGluZyBvZiB0ZHhfY3B1X2VuYWJsZSgpLg0K

