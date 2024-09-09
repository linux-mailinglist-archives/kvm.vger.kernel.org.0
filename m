Return-Path: <kvm+bounces-26111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69313971557
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 12:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21826283127
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 10:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E5B1B3F3F;
	Mon,  9 Sep 2024 10:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMB5ndX8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BA013C914;
	Mon,  9 Sep 2024 10:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725877823; cv=fail; b=Mim76uINpus1rwYmSf1yx9hwz+YtMT8tt8K2H/+yF2k9VJ6448akHqp5/nS8S3U4SIVXrTFAzuUmkxcDt0ry0YAIbm96crPNr/pC0lZZWwJJM9ags7Ww0SLhFnhXL7Sh83LEkpUXfHzgNlsgi1QSLbSbCb8QLUUlIjTtDnQEs7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725877823; c=relaxed/simple;
	bh=+8m2aI+2Vr1MEjMDV1dOAf8QxNh3tLwLOlZBRCCX+S8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZQuEHQs8bexNEfDjXm9WYOG5qSk+nvaLRkKK0r5DdtufdFaOMeBlzN7aK296wkgHX2jdNctiIzz3kq+EZxNLCb8v2NKpD5qH1azvvoJdQX6r9u86MRbImjmfZgI7Ij4tISnsJZUcFzc5ukDQhQqBJh9A8S5HAZuNjRi0kll0PEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMB5ndX8; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725877823; x=1757413823;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+8m2aI+2Vr1MEjMDV1dOAf8QxNh3tLwLOlZBRCCX+S8=;
  b=nMB5ndX8S+Pzqa4u2OTMYaxfXrfjlq+MIEVBIlRz01u17pFyRDewcjmy
   os0IFfJ9Du7ECbjZCVOLILdh2GDal3QSS/YAeXhy78k356MHNd1QIv8P0
   N4/RMHNn4HMjZbN+zI2GUuOrdeAz22NjlUcZOT1/r9qzqWDWvynCzDdbO
   c6fAGcfqGom64LqMmD3V9McADVBcSialkptCdInDbHMjhKNJRsv9Gp01Z
   mC8CnOv4kzsxEcyX8cCCxIXztKhj+3h5RS5wzp6Ufs1p21+vJbzkLAQgI
   jrVv74AZ0QG44p8909xDI0ziKmrXElf6dDt+yk/zdtnui5SftzbSN/D87
   g==;
X-CSE-ConnectionGUID: MyAjNTo5TLW2HvZjz+JCww==
X-CSE-MsgGUID: LWQj2l6ZRmeNAz10d+h9Aw==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="35141892"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="35141892"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 03:30:21 -0700
X-CSE-ConnectionGUID: W1yqhktLTMSQlGAqMozquA==
X-CSE-MsgGUID: kZZFNfHsSX6f9a9rCPHh6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="71411539"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 03:30:21 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 03:30:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 03:30:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 03:30:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0UyCk0UBvCNpIt7n+5oawNdWbM1Op6/jSO26mA5midVRHBNyyGm8NUBFSKRTxQGzKrSUzOpBaVcoimuousbJtIJimANiP2/TtwAw7cVT7hwzbXZOyFUHB1WJm44t1yYVpgCqIkMqqJwjaD50Y6pDwNAZ6CeTvOD01X8z8XA9pa33rDOQEAjtX6TBTAo7zEYLLHCoBYTZvl5L8qd8emexOfUDU6PzjeLG2YKTJAI1QyZjBNnUfkzf8ocWfWBaLSnIFbFn86YtrwLHJ06O6/rsPrzNRoUb2mQkoJ7XDMLVrmsxqepw1ASZP0BkuQvbbKZ9VD7pyhvdwlsKyV8gxfHng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8m2aI+2Vr1MEjMDV1dOAf8QxNh3tLwLOlZBRCCX+S8=;
 b=WuaBpkdV5Q9+3N6ns/w36xZn8BfTdeVPOeE4gW/RxMMJR4UcoDvmoODV+gXMyyJDW3eDGi0mYb1fsbvghtHEkRfbxQPIlkWV6+jgGM+NyDYWJtcrAqtmtaIKnSCt5O9LGaknOHZpAPUt1VLQ5dB/46U3ytQqOiRCQHBWY/ax6m3/jz9bL+t6G8KwG/Blp0HPRYttZnpw7jlmc3kcFX1mpj77gtR1hcgdqZQd6eBqjCQuCXDvEd7NaYNw6B56iKedjk4hJg1EIWW+i3SUd4lq1PuwxwA7JvK/Hy5QgkUCEL+d000i0cmVHs57Sp/jleYQ/n5OFYNyUr3BCxtuFQPe1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6283.namprd11.prod.outlook.com (2603:10b6:930:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Mon, 9 Sep
 2024 10:30:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 10:30:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 7/8] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Thread-Topic: [PATCH v3 7/8] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Thread-Index: AQHa+E/2kfjgY9YZ90u7z64kcn1vUbJLeS0AgAPctIA=
Date: Mon, 9 Sep 2024 10:30:17 +0000
Message-ID: <12022e5dc5fc8f1ecf889a8700cc0031d5f04e0f.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
	 <66db90d269408_22a22948c@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66db90d269408_22a22948c@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6283:EE_
x-ms-office365-filtering-correlation-id: c327cd84-8c4e-4d38-2105-08dcd0ba65e1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?alJ0MkdjSHZrRVF4S3Q5eS81MzVzeUJ5a28wbHpaU25DSzJxOXNEazZRVGha?=
 =?utf-8?B?M0JOUkJOeWhYNzhiSEo2OVVveUJDRlhKMGxCRjVkTXd5d1BGem56akZrVTV3?=
 =?utf-8?B?eitJNlAwWVBrZEJ3d3FVOW9hVFlyTlJjR3NMSncwOHU3QlRvSlhZZjEvMjB0?=
 =?utf-8?B?Q1VyNk9GUS9BczFwdE91bmowbHUxOVVweWZiS0tCemwwVW5LT1lqc3ZlaDV3?=
 =?utf-8?B?Z21Yc2tUbmFNWmhVTVdmZElodHlqUFJySGVUZktuS2dQbTlHajVkOXFQMjRo?=
 =?utf-8?B?WW0vMkJtazhtRHV1b3RnamRZVTUwK3VrUzJsMXcyV0xkbFdJYkVWQ1RLSXN3?=
 =?utf-8?B?QTBzU1BSL3docmVaREx4Vkc5R1Z2aFNlejBlaTBHUzN6V0xLemV6SERqdXR6?=
 =?utf-8?B?NzM2dUJKWEFOYnoxSFIzTXFDSDJNamNQeTdDVEkyb3A3ckZ6VytabjUzTU5I?=
 =?utf-8?B?RmpHTDU1eXpnWitreUZwVlhsVkVsRVRrZjVWaHp1RFFOdHhtTlhZRUxwWVY1?=
 =?utf-8?B?Vm9OdnhtYmYzMWdZVUZKZ2huREJ3bm1pbUQreGlNMFVoZmJBK0dvWUc2RW53?=
 =?utf-8?B?VVRRWU9XOXUvVUJmZmhLODVOSFp2QmVoNUo3blVkNjkzQ1hTdzUxdks1MlBy?=
 =?utf-8?B?YTlZUXRqdXJYOEJESEZxeXFXRlJaZEdGYnpDeHNVODNKOVhDVmtpK3RoQnpl?=
 =?utf-8?B?dGxwaEd2MVpBamNjTHhvN09US1hkbUM4bDlEbS9LRWRRUVIvYW50NEF3THFN?=
 =?utf-8?B?Z0xLMGlKOGFZa2JuaWRQektZc2ErSXRlLzAvVjgrU0xkWXlzQ0NIdVcxZDJl?=
 =?utf-8?B?V3hYTG9SZmxJbkdBeTFqN1dYVWhBK3hQcFhjRmhaUlRNMEVWRk0vOERQWUdL?=
 =?utf-8?B?WDQyTTlvQW5nbTJsNzdmVWIyVHhJUlVNK1VhcEt3Q2I3eldIVHg1OGluMkRD?=
 =?utf-8?B?RU11NHo2Rzk5MXBEZUk4OFBlaXc3d1pYM1AyY0J2bWlwQnVpQjNCNmNxeGhi?=
 =?utf-8?B?V0NtOHgwdnZFRjBBYzJ0SGdxNCs4cVFDVGFzQWl5RXhWd2t3N2NzdnRkbVRR?=
 =?utf-8?B?b1NvUWoyam5tOS8xZCtNK3RCN1VJdXRZOXkvTWFFRGZxa3NqKzNFdHBjOHht?=
 =?utf-8?B?R25wUDJHeTZBUkRKUm5NYkZYZ3BlNlozb29mNWFYdDVlTFlvOHE5YW1veGVh?=
 =?utf-8?B?SWpFQnhiN0hSbWRieDZLUnRXaDZuYjV6ZVZnaU8xajVmUkE2N01SMUxEOGNX?=
 =?utf-8?B?aS9SWkJxKzBVMHkzNzM4L2x6d2VqeUdRSDk5SjRLUytCd2NQNzRzNmNyZjhU?=
 =?utf-8?B?VlM0UGpvV2JMY2wxdkp4NUVkRzZrRjYxUEd5UlVOalRueTZBVzhrMk9xVU5K?=
 =?utf-8?B?TXpzbWFGbnBMS0p4MUZSc3pXOWI0QyszTUMxRVRoTDdDRDFnWHdGZVhNK3Mx?=
 =?utf-8?B?SDEyVS83K2lBRHJuZzFUT3ZrZzc4emppbE5mZHk1YnRYRGVodENOVEUvblRX?=
 =?utf-8?B?UXpZRVJNLzRTTUpjZFhibUdNQkZaOWdvUEpscnlZMjFiZThVNHFNVXJrZXlG?=
 =?utf-8?B?L3VCdFJYNEFacUR2Vld5Y2dQVUx2ZWQxcm1aN0FRY0JQS0lGVlcvd01sdmEr?=
 =?utf-8?B?MGFoWmFmZS82VnYwUzNSNDRMd2c1Wklncm91b01RN3dlVUJKNEdVbkVaRS9r?=
 =?utf-8?B?K25SL1UweGl5UUR3OUxlczFRcnljd3Y0SnhEYzcwNkNIY0puMkJQeXdoNC8x?=
 =?utf-8?B?VXhpazZnWkkxSVNlQ3Q5eHd5bmg3dC8rMXJIR29YT2RWUEJMZ1lOM3NVSjhj?=
 =?utf-8?B?cUxGL1dzelZkSENIbG1jQWx1NmJoMFNxNkphcm12R0hYSzFrVmYrRW1nVklo?=
 =?utf-8?B?ZVlDdm5obGhGck5saEw4SS9CYytUVmFlbGdNak9oa3hyZ1NHVGxUNUtHQ1hT?=
 =?utf-8?Q?V4TgJOl7Kh0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVBlRStqd0V2bWltWEd2UzRPVndSUkxTVmRGbzBmTjJoN0ZLQWlzUSs5ajZF?=
 =?utf-8?B?dGY5TkcwYkVSb2dqUWlocy9ScjFSTy93Ui9DbzFNWHFKakNKNDA4Y0NIeHNk?=
 =?utf-8?B?OEFEYmZBcUhUaEh1NERaUk5XNFN4aUNvWmtKb3hSV1JDd2o5eWRKK3RvMDI2?=
 =?utf-8?B?cWdzZGkvYWZSUnZpSEdPaFZaRjRZYWpzRmt1VG01UVZxN2JKcGpmV0k2d3R2?=
 =?utf-8?B?L2djQnRlNWlTUHJuMXluRHk3NGFEMlVzUWljK1dWK2d5bGhraXJKeGE1Zmo0?=
 =?utf-8?B?eXJmeHYrZnlldzlibmhJdXdpVDRlM3QwYittR3diN1BuV2oxUHVpbkZFSzll?=
 =?utf-8?B?VDhwMnUzYVQ2bVVsUkhZQllvblVsQWhsL245VlhaZTFEUUZubVE5eS9kVlIx?=
 =?utf-8?B?R1hwZ0FUNWYzVjQ5RmJQUElOUTVxR0JvUXZxNFkwQ2o2UjZNMktOZnhZOXNX?=
 =?utf-8?B?TFVuUFQxNi8xYWQ5WXYzNWpZallPUStLbnBDamVaZjRkWlRYaUpKTHphUVFt?=
 =?utf-8?B?dkJwVHBvczRPS2RXSytpcldZWkpSY3ZHRE5DR1VSZGZ2Z1NFU1A3MEUrU0RB?=
 =?utf-8?B?MUVmYUphTVluTGFSQytJWUhaZkFielJCUHd6T1JVenNzSEUxT3Z2UmpsOHVz?=
 =?utf-8?B?RGtMNnFuNGozbitYTUVnOHNNamNtNmxnS3pyWS82K0NuTzViZkY3S0ZUNWJu?=
 =?utf-8?B?aDlNOTN4YVFFeDNxV0d2TU1HOXlCVElreGcyZ1ZJZlRDdEY3YlI4VngxbVBF?=
 =?utf-8?B?WllCRXAyV2RpekNNbFNWbDhOWGZpMlBxYkdlSFBtMWVhdUlhYjVTblFFZVEz?=
 =?utf-8?B?S1ZXNFNzZXJsV1dzQjliUmx3dy91TTFYSDZPZS9UVzJvYVhFTk4rL1RocFFr?=
 =?utf-8?B?aUpiRWJVaFZaLzl4eVpXV1FBWEpCSzdBNUNTd3F4TzF2Tk9ERFArTm1VaXo0?=
 =?utf-8?B?dWE0a09uRW1vMUFXYmZtMVB4UmNGNkRBRGhRYTlaSm16cUtHT3RNTDRuVFd0?=
 =?utf-8?B?Y3czbkV3WUpNdDM0NFhIZlpaemF2dFhMc2FmK3g1NGNRYnNZVzhHYnFrLzJD?=
 =?utf-8?B?WFlzQ2JMczFhVGRHL2QwNFpYRW9OSTR5TUg0TE81UWdyWVk0SkV2TXBSNTVK?=
 =?utf-8?B?dzY1Q0NqdlBpdUtNeHJmYzhKc0pGblJZclZXRHFoaGlkYnpINHJlVVIxT0dC?=
 =?utf-8?B?SmgvOXRvQ3F0ck14NkRValhCcTRWTGhjUTJ5cFVrbjVsUnZzVlNncWgzcmFm?=
 =?utf-8?B?VjVrenovWVY3NlBxVnVqUGJONDJzcUh3YVVhQ200TGVHM2V6NE96K0FHZ2tV?=
 =?utf-8?B?K3RFQUJocjgxOGg0akM5N1NVUElITENsa1c5VDc4R3JFdlRpSGlHQjZ3VXQ0?=
 =?utf-8?B?Qjd4SVVuK2dZWlBiV1Q4N05MZEo0RDVVQSs0RExoR2lOaWJJb3c1SDRwUUdJ?=
 =?utf-8?B?c2hjVWQ4VGY2UzN3SWFMejBYTUViV203VytrQ09rUFRGc1pLUVlrcnNFcTh5?=
 =?utf-8?B?TnNlYm52ejhsQ0dHQ2hna1VFdDMrYzN3c1RMYU9zKzJOM0lNdnpvTTZlNklP?=
 =?utf-8?B?cCtHUVNFWkVFWlE1dk1xa09LL0VoeWJYMEJ1SFN4WDkwQytrYmNHL0hKV0NZ?=
 =?utf-8?B?aHVoaUFONkdxNUh5ckRKemczQ1lNTGxZM2xFRkR6K0ZIcDIxcUw5dERrZDQ2?=
 =?utf-8?B?V3dkZjNMUnRBZ2ZVOGNDS1Z3bUsrV25FaFNkMURCOWw3RndaSEF3cW13bjdN?=
 =?utf-8?B?eC85S1UwUy9xSlMyOG1CakYzUnhmbldkT2J2dFp4dmhNSDVuVW9GNTJ1TXNH?=
 =?utf-8?B?aUNIZEpFVHJPRXc5bHBkTXo0cFpEVFhYYnVveTRyMGJLUWtIODY0MTlYVTZR?=
 =?utf-8?B?eXB3UzU5QWF1YnJSVEgvUWd0TmJvWkhTLytwSnlSNHA2YVQ3d3VlMnk3UmlL?=
 =?utf-8?B?NUxZSlF6ZGRCMjdxMEVzWk04aG4wQXVQUy9QMmUyYStBS1czMXF2aHU2Y05i?=
 =?utf-8?B?bWN2TGdBcU9HV1g2Y3U3ZjVCajd2cGlQRUtZd21UV0dKcjRoRmVCOFc5VVBV?=
 =?utf-8?B?SHZvRUl0OGJ4VDVXYlhIWEJreWs4L001SXViVlQzSDlQSWVUdXJvU0Fzc3lY?=
 =?utf-8?Q?h8N/KR2eg1kv77Yj4ZV1N24h+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C789A907FB96D4CA8AE498EFCB88958@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c327cd84-8c4e-4d38-2105-08dcd0ba65e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 10:30:17.1412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VxVLPafDDVybgt0nTjQFA5XHGrbGzAxP+51ut9DEebRa3/Dte8itt6vs9I8hfFpVchBLk1z9TOupEMvKpC/V+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6283
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDE2OjMxIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEthaSBIdWFuZyB3cm90ZToNCj4gPiBBIFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gZmFpbHVy
ZSB3YXMgcmVwb3J0ZWQgb24gYSBFbWVyYWxkIFJhcGlkcw0KPiA+IHBsYXRmb3JtOg0KPiA+IA0K
PiA+ICAgdmlydC90ZHg6IGluaXRpYWxpemF0aW9uIGZhaWxlZDogVERNUiBbMHgwLCAweDgwMDAw
MDAwKTogcmVzZXJ2ZWQgYXJlYXMgZXhoYXVzdGVkLg0KPiA+ICAgdmlydC90ZHg6IG1vZHVsZSBp
bml0aWFsaXphdGlvbiBmYWlsZWQgKC0yOCkNCj4gPiANCj4gWy4uXQ0KPiANCj4gSSBmZWVsIHdo
YXQgSSB0cmltbWVkIGFib3ZlIGlzIGEgbG90IG9mIHRleHQganVzdCB0byBzYXk6DQo+IA0KPiAg
ICAgImJ1aWxkX3RkeF9tZW1saXN0KCkgdHJpZXMgdG8gZnVsZmlsbCB0aGUgVERYIG1vZHVsZSBy
ZXF1aXJlbWVudCBpdCBiZQ0KPiAgICAgdG9sZCBhYm91dCBob2xlcyBpbiB0aGUgVERNUiBzcGFj
ZSA8aW5zZXJ0IHBvaW50ZXIgLyByZWZlcmVuY2UgdG8NCj4gICAgIHJlcXVpcmVtZW50Pi4gSXQg
dHVybnMgb3V0IHRoYXQgdGhlIGtlcm5lbCdzIHZpZXcgb2YgbWVtb3J5IGhvbGVzIGlzIHRvbw0K
PiAgICAgZmluZSBncmFpbmVkIGFuZCBzb21ldGltZXMgZXhjZWVkcyB0aGUgbnVtYmVyIG9mIGhv
bGVzICgxNikgdGhhdCB0aGUgVERYDQo+ICAgICBtb2R1bGUgY2FuIHRyYWNrIHBlciBURE1SIDxp
bnNlcnQgcHJvYmxlbWF0aWMgbWVtb3J5IG1hcD4uIFRoYW5rZnVsbHkNCj4gICAgIHRoZSBtb2R1
bGUgYWxzbyBsaXN0cyBtZW1vcnkgdGhhdCBpcyBwb3RlbnRpYWxseSBjb252ZXJ0aWJsZSBpbiBh
IGxpc3QNCj4gICAgIG9mIENNUnMuIFRoYXQgY29hcnNlciBncmFpbmVkIENNUiBsaXN0IHRlbmRz
IHRvIHRyYWNrIHVzYWJsZSBtZW1vcnkgaW4NCj4gICAgIHRoZSBtZW1vcnkgbWFwIGV2ZW4gaWYg
aXQgbWlnaHQgYmUgcmVzZXJ2ZWQgZm9yIGhvc3QgdXNhZ2UgbGlrZSAnQUNQSQ0KPiAgICAgZGF0
YScuIFVzZSB0aGF0IGxpc3QgdG8gcmVsYXggd2hhdCB0aGUga2VybmVsIGNvbnNpZGVycyB1bnVz
YWJsZQ0KPiAgICAgbWVtb3J5LiBJZiBpdCBmYWxscyBpbiBhIENNUiBubyBuZWVkIHRvIGluc3Rh
bnRpYXRlIGEgaG9sZSwgYW5kIHJlbHkgb24NCj4gICAgIHRoZSBmYWN0IHRoYXQga2VybmVsIHdp
bGwga2VlcCB3aGF0IGl0IGNvbnNpZGVycyAncmVzZXJ2ZWQnIG91dCBvZiB0aGUNCj4gICAgIHBh
Z2UgYWxsb2NhdG9yLiINCj4gDQo+IC4uLmJ1dCBkb24ndCBzcGluIHRoZSBwYXRjaCBqdXN0IHRv
IG1ha2UgdGhlIGNoYW5nZWxvZyBtb3JlIGNvbmNpc2UuIEl0DQo+IHRvb2sgbWUgcmVhZGluZyBh
IGZldyB0aW1lcyB0byBwdWxsIG91dCB0aG9zZSBzYWxpZW50IGRldGFpbHMsIHRoYXQgaXMsDQo+
IGlmIEkgdW5kZXJzdG9vZCBpdCBjb3JyZWN0bHk/DQoNClRoYW5rcy4gIExldCBtZSB0cnkgdG8g
dHJpbSBkb3duIHRoZSBjaGFuZ2Vsb2cgc2luY2UgSSBuZWVkIHRvIHNlbmQgb3V0IGFub3RoZXIN
CnZlcnNpb24gYW55d2F5Lg0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3Zt
eC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBpbmRleCAwZmI2
NzNkZDQzZWQuLmZhMzM1YWIxYWU5MiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3Zt
eC90ZHgvdGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBA
QCAtMzMxLDYgKzMzMSw3MiBAQCBzdGF0aWMgaW50IGdldF90ZHhfc3lzX2luZm9fdmVyc2lvbihz
dHJ1Y3QgdGR4X3N5c19pbmZvX3ZlcnNpb24gKnN5c2luZm9fdmVyc2lvbg0KPiA+ICAJcmV0dXJu
IHJldDsNCj4gPiAgfQ0KPiA+ICANCj4gPiArLyogVXBkYXRlIHRoZSBAc3lzaW5mb19jbXItPm51
bV9jbXJzIHRvIHRyaW0gdGFpbCBlbXB0eSBDTVJzICovDQo+ID4gK3N0YXRpYyB2b2lkIHRyaW1f
ZW1wdHlfdGFpbF9jbXJzKHN0cnVjdCB0ZHhfc3lzX2luZm9fY21yICpzeXNpbmZvX2NtcikNCj4g
PiArew0KPiA+ICsJaW50IGk7DQo+ID4gKw0KPiA+ICsJZm9yIChpID0gMDsgaSA8IHN5c2luZm9f
Y21yLT5udW1fY21yczsgaSsrKSB7DQo+ID4gKwkJdTY0IGNtcl9iYXNlID0gc3lzaW5mb19jbXIt
PmNtcl9iYXNlW2ldOw0KPiA+ICsJCXU2NCBjbXJfc2l6ZSA9IHN5c2luZm9fY21yLT5jbXJfc2l6
ZVtpXTsNCj4gPiArDQo+ID4gKwkJaWYgKCFjbXJfc2l6ZSkgew0KPiA+ICsJCQlXQVJOX09OX09O
Q0UoY21yX2Jhc2UpOw0KPiA+ICsJCQlicmVhazsNCj4gPiArCQl9DQo+ID4gKw0KPiA+ICsJCS8q
IFREWCBhcmNoaXRlY3R1cmU6IENNUiBtdXN0IGJlIDRLQiBhbGlnbmVkICovDQo+ID4gKwkJV0FS
Tl9PTl9PTkNFKCFQQUdFX0FMSUdORUQoY21yX2Jhc2UpIHx8DQo+ID4gKwkJCQkhUEFHRV9BTElH
TkVEKGNtcl9zaXplKSk7DQo+IA0KPiBJcyBpdCByZWFsbHkgcmVxdWlyZWQgdG8gbGV0IHRoZSBU
RFggbW9kdWxlIHRhaW50IGFuZCBwb3NzaWJseSBjcmFzaCB0aGUNCj4ga2VybmVsIGlmIGl0IHBy
b3ZpZGVzIG1pc2FsaWduZWQgQ01Scz8gU2hvdWxkbid0IHRoZXNlIGJlIHZhbGlkYXRlZA0KPiBl
YXJseSBhbmQganVzdCB0dXJuIG9mZiBURFggc3VwcG9ydCBpZiB0aGUgVERYIG1vZHVsZSBpcyB0
aGlzIGJyb2tlbj8NCg0KV2UgY2FuIG1ha2UgdGhpcyBmdW5jdGlvbiByZXR1cm4gZXJyb3IgY29k
ZSBmb3IgdGhvc2UgZXJyb3IgY2FzZXMsIGFuZCBmYWlsIHRvDQppbml0aWFsaXplIFREWCBtb2R1
bGUuDQoNCkJ1dCBDTVJzIGFyZSBhY3R1YWxseSB2ZXJpZmllZCBieSB0aGUgTUNIRUNLLiAgSWYg
YW55IFdBUk4oKSBhYm92ZSBoYXBwZW5zLCBURFgNCndvbid0IGdldCBlbmFibGVkIGluIGhhcmR3
YXJlLiAgSSB0aGluayBtYXliZSB3ZSBjYW4ganVzdCByZW1vdmUgdGhlIFdBUk4oKXM/DQoNCg0K

