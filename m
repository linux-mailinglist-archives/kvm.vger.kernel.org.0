Return-Path: <kvm+bounces-25514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F1C96610B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 641051F26595
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D2C19992C;
	Fri, 30 Aug 2024 11:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eFepplMd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C50C192D60;
	Fri, 30 Aug 2024 11:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725018787; cv=fail; b=NgmhgjZTsIrZloauoaRG+N1UP4vPMJoWH23n0TcVkWRoXU9Qm+AhTRsvZ7tqFIRQCSn7y9wC+vc+3doVASxMPdk18HinZiEmH29Q218uD+tQDTdRNHrKFDL8mOsG2bEfTpf8J+1b/FVf4BSi7mwY7zf16N+LC6+/kyXA/GDNCQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725018787; c=relaxed/simple;
	bh=JUluCdYBKj4+81IaMADdFJETyi+jyj8UxlkrAEpY3JM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dIMxSdVaPUlm5zGZCBx21e5BtqxttId5AjV8DR85JHRs//MvJmHbBXaSR+1gCiqCjn5cvLzJ8n+LeVKLoyafQixDHYQWXECsgPh12gqrp/O3xFKCWC/dAA3GUvWtTQ5wuuQSOIbyDVID/SdEh4LIugzy/9hEjuPCaHCJmHw9X08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eFepplMd; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725018786; x=1756554786;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JUluCdYBKj4+81IaMADdFJETyi+jyj8UxlkrAEpY3JM=;
  b=eFepplMdomP7ocKBbFlVbFBUUw0lsNxDiKmyUdJ/L8GwDrNPjgp0nGuL
   xKSbOVUbJzSVyVPQ9GJCJpqERZzrA9I1s7qnOR7SmxxGuyheaeVVDXbRr
   4yEy3Ud3+cWYNWO72Lx8E1IHjapr+/s8CKvCI1uI+ze6S5dj6SELIPDvM
   WQNjTNc3WJiMLsB4rt3bOMpMHKPJHcgFlul0y17oIdoszzZZLj3EnrO+g
   SX65F2Bh3E5MBxqdyojOadurePxYqZRhAbyHzUzGHHc8+zDfxeaYDlkKC
   RmEeNKYz4/e4rXnPJEXdw6nShT7VHXoa6RvjS1UvUBnCat/OhKk/ZcGJB
   A==;
X-CSE-ConnectionGUID: RnX2Ewf8Ska7dA45u4GxsQ==
X-CSE-MsgGUID: vpJKZKcqSk2td6Y80cuR9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23538182"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23538182"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:53:05 -0700
X-CSE-ConnectionGUID: cxvGlkSjQtCQvtjkaipIiw==
X-CSE-MsgGUID: ucfh8qnRTlShkpKamXEBLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="64063777"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 04:53:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 04:53:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 04:53:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 04:53:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JVmEOuS25AWFoDfg5ZmactCvuLrw5yE/nJ9Po0hWJ5rh6Ay7gFSKPa9FADwODJkG+DirD1vKGM1Su0NaxIny541Y193Dp7ui0jzbXnukCqqehgkrR7vkrzkvgn2mRmyC0w1u1EIZG9/g9UKKMqpPC4V4dGk2SIJ157AO9FSxlROt6Vllbudb/nFVLUzCjH4f7dGADEe3LOOuyZkRsKvWLCHugu38cNUcHSZS4n/NdbSUPrkByn0arMDLZL5ZYk7xf51ok7qtoNP9qGmbxnn7ToArH2cAh3shefBWOGXK0Ek9lIwf1yF02GzFLFA9+rFcQJMm8p0O9AmBvCiylWi4aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUluCdYBKj4+81IaMADdFJETyi+jyj8UxlkrAEpY3JM=;
 b=onLdXXvrdomK/AgVzQuezIFD20m29sgeJAaGHg4kbaFzPD0bvWCopY9n/4P1oD5YFE6XJWXTtPBVpxYsfq22v4x3RKDzBalcAfUyCeB4KeRZxuJbvzo+y5TedSWnJ+j/pzmMeFWpIM9Y+ou57HhCPq2kv4XI25W0iCjlkDaWgl9insvAGcPordHqNlHNm69JnEkKmWCc4zFIqwU0UbFnUqWdxmlPwcUonIk2vgFZpUQUWG/nbTedF967YHVqBf6473jBTMzI7Sr2WwEc+8d6ncnpyudxjAmB6lf+Qh3oXYGvlnKph0oXCzE7D/sQ9GyTBWLGCl43UN3lQhwIowMlqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7121.namprd11.prod.outlook.com (2603:10b6:510:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 11:52:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 11:52:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 7/8] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Thread-Topic: [PATCH v3 7/8] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Thread-Index: AQHa+E/2kfjgY9YZ90u7z64kcn1vUbI/pB8AgAARjwA=
Date: Fri, 30 Aug 2024 11:52:59 +0000
Message-ID: <2c8087136424fd5a63a183046f114ac01584c3c4.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
	 <4b30520d-f3fa-4806-9d58-176adb8791a6@intel.com>
In-Reply-To: <4b30520d-f3fa-4806-9d58-176adb8791a6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7121:EE_
x-ms-office365-filtering-correlation-id: e4c97858-9829-4cbe-2414-08dcc8ea4b66
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?dVhIZysvbGxrQ1NoTEp3eE5wWWVhZnN4U0RFc0lOZzBLa2RMeXJsWFhkeHpJ?=
 =?utf-8?B?aG5ZNzFoOVBtYUNXLzR0b1Jad0dMZGliM3JFdnREREY0S0tHbmlKN1diSHdx?=
 =?utf-8?B?ZkQyakx6ckgwOWFGdUE1YmFoMXhaaHRweklMeG95R3RrSzRxeFBCSUZNeU41?=
 =?utf-8?B?M2lxc3RqeEZaQlY2UDZCT0U2T2ppQXdyZGNIait6Zkx5TDFKQ0FBYnJ3ajYw?=
 =?utf-8?B?UjdDSVBaVno5cjRQWXRLWWdRZkpFamRYaWtHOXVqTXpCY2MrK0xvbTRDY21J?=
 =?utf-8?B?MDFVR3c1UWNiKzlsZGRVOHE3M0NuQWFjbHQ4VVhKODQyS2NQR1pPdkVuZWg4?=
 =?utf-8?B?M2Raemh4aVdVcGVjUDBMR08vMTFzdlRaNlcxalFXdlBhVHZFYVpIUWE1eGNz?=
 =?utf-8?B?YngvOHUxRXYxekt0S1owYkxDZzdibnNkeW96d1lmQUE0MlZNYzZrQXpqSUor?=
 =?utf-8?B?dklGOXZBV2UrWW90MUNYMjBVQlRiRHVKd0JmZnY0czRGMHVMc3lJUDJzbE9I?=
 =?utf-8?B?bjBtMWZ2dkFPbFQ0OUlZcUNYRDh4VEdWbGxjWDVaT250d1NWVlpJV3hQS3Qx?=
 =?utf-8?B?MG1zL2dqWjBBZWhxMnZYQlErT0NRdjdBMEhXYzl6Tm5LcHBZRnUxUkpOb1Z1?=
 =?utf-8?B?N3N2UGk0MFdNbi8zWjJJMVpzaWIyNmk3SkR4Wi90L2RqcHN3SU5EMXJCUlB1?=
 =?utf-8?B?TG1IVzhmalJkNE40cmxkUFlJa0pQYnJGTzFOTnlVRHNFRjJVNDA4NjN2bndR?=
 =?utf-8?B?STNkdHpCL2dmbEd3dzNnOWRKS1g4Q29EbTFKZ01IVFVVcEZRdForWUh6ejBJ?=
 =?utf-8?B?ZEtpU21LNDFGU3l1cU1IVy9DV3o1cVNLZjZ5ZS9Jb3RTY2Y3QkdjUXpUT2xX?=
 =?utf-8?B?Q0t4aElIbmJvbVRqQnh5cHFucHBoNThmZC9iTGhyZ3hYekZhMFh2OFI5MFEr?=
 =?utf-8?B?Wjh5T041UXNIa1RobnFhQ0YydGN1QzNtTDhxV2JSRmVsallZL0QvUmN6U25L?=
 =?utf-8?B?MXJZOVpYRHE1a2hGUy8wSTNNK1o0WWpGMDJsSkc1RTdHcDZjek5ESDc4WE5Q?=
 =?utf-8?B?aTRBZUxsbFNnYlRNV0NUdjlzUDZGd0xjMTBNYWkwc2M1cXBWaE1HSTJnZHdv?=
 =?utf-8?B?cmxNdDFwUWlocWhTRjdhZVdKcHdIekdERjJlVUpyQ3k4Skt2czBJN1JjNStx?=
 =?utf-8?B?dGtTUTZZbGIrNU92ZTdBSWIvbEdRMU5abnNGVkV2enozY3ordkJOYzhJTDVQ?=
 =?utf-8?B?MEcwc0pGYVkzU1g1cThCWnl6d200aWxybHZkbG1SSzhRYUFwazF6ZU1sTkYz?=
 =?utf-8?B?NTZMcG1ncm9iTWdPbjhaZGQxZ3U3YVhJamtwelg1Z0pSQnozK2xaNDNXbkR4?=
 =?utf-8?B?MjJXanQ3WXlkUjdwU05BZUZaaUxYYnlid3ZJSmdGcVAvS0MvRWFGUkpQVDhB?=
 =?utf-8?B?a0hHZDhCMUxjYkhXdFdNNmp4dFkwUUtWdFp1NThXL3J4MkhNZE1PclF5aVdr?=
 =?utf-8?B?OWdKai8zWHBiVWtVc0l2a2hNS3RGZnlqUnJhamZjUDhLZWRmSE55bGhXNXQw?=
 =?utf-8?B?ekF4dUEwMVFVdnFBZVVnbGdHOThIRlZxNEpNNGRCbGdEaFBDY012VWVldEFK?=
 =?utf-8?B?cEZQRTBmbkxLNHlpcDJEd3lzM1dpblhoWEFBbE84WDFtR0FzZllHTWFxcjRB?=
 =?utf-8?B?MEtpVnhFQjNLL3lDR1lnVVFSc3gvVWk4QzY2RnR5MHQyU1dhZERxNjhwajdt?=
 =?utf-8?B?dzJkN042bmc4eWJPWU1ZZHpmTEZieVJDRDVhQWppbHJvbFJwTG9yektqd3px?=
 =?utf-8?B?enhTUGt3Vk1GcjVWZkJ0MFV3aHFSbkQzN1h1SlFjc1RKOEJJZncrczBHNmEw?=
 =?utf-8?B?NVMveFhweWozZjM3NTVKRy96bWtuRjUwOE1leVk3Z29ZU0ptYTAyTWYyQzJN?=
 =?utf-8?Q?HF40qEp00y4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RW04T0lxQjRkcDFTOFYrcnorSjZrK0RIZjliUENrbWtiMG0rZnFlcmx4RnlL?=
 =?utf-8?B?ZjQzLzg0RWp0RENSbW1YRS8rUnVmeGVOV25RWlE5VDdxdCs2YTFJcTFqVGVK?=
 =?utf-8?B?dDNnb1lhVHowckREbHVsM2cvaFdKK08zYXdPSkoya1hNRnhpeDdjUlMwTjV5?=
 =?utf-8?B?TU9iVjg0Ujd0YkRrem93NHZqN0tvNEx5QUtobHgzcFJuUU5GQ1dNMGxHVG5v?=
 =?utf-8?B?Tkg5aHAyWDhKbzJZeFdtWDI3TkNwR2V1U0xzMENFTXNXd0pwbVpSRnoycy92?=
 =?utf-8?B?c2FuL2hFN3A0b09LaWYrSzFiemtiQnhlc1psL2phL1oyWFYvMytJZTluSWIz?=
 =?utf-8?B?YmpjbWM1TjFzbFdVZkltd09KZ3g0SFROM0FLdUJrOXhjSmppbXEzMm9lbEVs?=
 =?utf-8?B?ak5CT2JNcTNWL2Nmb29GdDFReUFJZkNOZnNmNGt6dmgyRG1BTXh2VU96RGJ0?=
 =?utf-8?B?cit0eUplSzdkb21KM0hNWklqRTBaS1orNTNzVnhydUNPaFNZbS83Wk55VGYv?=
 =?utf-8?B?N1p6VnowSy9lNkp2VldqU25YU01Qam9zZ0YvSG1jbVo3QjZJVlhweVNnbXA5?=
 =?utf-8?B?K2lEcmw5b1pod1lpS0pGakRIQ3prbG1WRzAyclZzTm13S1ZIMUtpM20rc1NR?=
 =?utf-8?B?VmNkOVNrRU9LT0N2Y21GbFlFMmlFbkZLeVM4NzlhWjZ0aTVVUG5NZHBOOHgw?=
 =?utf-8?B?SUgydTZPa2RYOE8rTFFhWldYM000eXB5bG11NkowL2ZVSzU2MlJiK2JkZkhN?=
 =?utf-8?B?TVE1SFF3VE13TDFpZ3hkVjg4VGI2LzJBeDVTdksydFMwejNrN21BNUhUNVFq?=
 =?utf-8?B?VTI3THFWNUdCSG4zWjg4dEtMY0hmQzRLS0pqenovWjBEMTljWEg2aXBEU3lJ?=
 =?utf-8?B?V0VJVHJLSzRRcVhzZUtCd0xXNURsZjM2MXVjWDFSMzE5VEdZRm1YS0NPUE95?=
 =?utf-8?B?TE9OZmFjbk9kWU54UlhjNHZCWE9JWTJ3YUxjb2pRcTdHc0RTT1FWdml5eks0?=
 =?utf-8?B?aGNDVldEVUpLbitYY1ArN2dtZzdzQzBHR3ArUWdvMTdLNEdLa3BsVnVHNjly?=
 =?utf-8?B?T2lvdlZoQVI1ZVJ3ZGd3cGQzUldkNXlsR2pONkFoT0s0bE9SaGNiSkVwS2Np?=
 =?utf-8?B?azdNYVZ1TzE3Q3Fkd2tJSEYyU0oyWVM2RzNnak4xdHVHVWpuN09qWTdETm80?=
 =?utf-8?B?SkQwdU93aWFoT2JITUNoNkhMdVZKeHNtNmR5Z0dQSit6T2RCY2xVa2xrZXJm?=
 =?utf-8?B?MGt0alluckdCcDlqVGc5VGhSNDl6SVZQb3grbldkMVhKN1czNG91UjB1Uklr?=
 =?utf-8?B?RzRsUmFnNDBIR2prNEZkMXA0elk3MHlQc1JDRjFYbW8wNzdlR0ZHRG5VVFVm?=
 =?utf-8?B?YVlEbkxEaGlGK3hLQXpnQnEvVzNhckRoSCtWakQyWU5xdWh1Nm5BNXRHRDFw?=
 =?utf-8?B?YytHaUFhd0ZEN3BZa1kzbGtoQmF1K0U0ZC9PcEVZMUU4RlYzMXhPS1ZRZXVu?=
 =?utf-8?B?RWNJUVFabjQ5QmVSVHhVVFFhdTFFQTZMZ1hBbFYrcEZDbUdMWTU0RmRCcCs3?=
 =?utf-8?B?OENHM2RZY2FNang4a3dyZ3dhbVpOck05WW45Q2lZNnBSVEhPUFJpZkxUSnhX?=
 =?utf-8?B?RzJmZXQxMmVkMmZma0l0ZlRiTmlqVDYycjlYUXF3SjU4QWVXNmhQbHRrK3Zy?=
 =?utf-8?B?SkVESytlQ09RNE5WbUpBNW1mWjlxcDFDb2dycUZ1a3BYU2wzOXZSZnlBeXJJ?=
 =?utf-8?B?ZUU1UFZhczBWcC9KK2Z1TVZoTWdpM0JmWndFUE1JNWpRaE1pSW1MdkRqdWY2?=
 =?utf-8?B?L0V5SldVRk90YnFaTG9ZdFhoOFhIRHJLOFd4MldHaUFDZ08rcHBzbE5Kc1p6?=
 =?utf-8?B?ajBZVStvb01JYVc5TkdzalZEbW5NbTE3NG9rWmdhc1c0VW9zOVRtK1RRd0pB?=
 =?utf-8?B?OGpVdkJsdDJpSXJFUldwS2doL2tRaUp0Nkx4SjRkMkdiZUtSbTlEYWFiZ3FI?=
 =?utf-8?B?NWtic2N6K2JaVXVBRGVVdjQrN2VoUnIxL2xYYTlYVjBhTlk3dHNsWGx3UXlt?=
 =?utf-8?B?dVFMWHpWM3JVZ1hiRytyY0dweGh1K3pYUzZMQjdNN0pFZWllQXNjUVVkWW5W?=
 =?utf-8?Q?0g6ZUsbEMD+XGMRTH5iiDm4dJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E21E0EF73A3F11418D40E9CE47ED20DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c97858-9829-4cbe-2414-08dcc8ea4b66
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 11:52:59.2022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: adSlaEvKcr7cAsXl+e6Dtajoy454Gcd8mGZRYNV0F60rwOSVZ1DMD4qpXReT2cwJ2gI/plQphRId2W15de+TQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7121
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTMwIGF0IDEzOjUwICswMzAwLCBIdW50ZXIsIEFkcmlhbiB3cm90ZToN
Cj4gT24gMjcvMDgvMjQgMTA6MTQsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBBIFREWCBtb2R1bGUg
aW5pdGlhbGl6YXRpb24gZmFpbHVyZSB3YXMgcmVwb3J0ZWQgb24gYSBFbWVyYWxkIFJhcGlkcw0K
PiA+IHBsYXRmb3JtOg0KPiA+IA0KPiA+ICAgdmlydC90ZHg6IGluaXRpYWxpemF0aW9uIGZhaWxl
ZDogVERNUiBbMHgwLCAweDgwMDAwMDAwKTogcmVzZXJ2ZWQgYXJlYXMgZXhoYXVzdGVkLg0KPiA+
ICAgdmlydC90ZHg6IG1vZHVsZSBpbml0aWFsaXphdGlvbiBmYWlsZWQgKC0yOCkNCj4gPiANCj4g
PiBBcyBwYXJ0IG9mIGluaXRpYWxpemluZyB0aGUgVERYIG1vZHVsZSwgdGhlIGtlcm5lbCBpbmZv
cm1zIHRoZSBURFgNCj4gPiBtb2R1bGUgb2YgYWxsICJURFgtdXNhYmxlIG1lbW9yeSByZWdpb25z
IiB1c2luZyBhbiBhcnJheSBvZiBURFggZGVmaW5lZA0KPiA+IHN0cnVjdHVyZSAiVEQgTWVtb3J5
IFJlZ2lvbiIgKFRETVIpLiAgRWFjaCBURE1SIG11c3QgYmUgaW4gMUdCIGFsaWduZWQNCj4gPiBh
bmQgaW4gMUdCIGdyYW51bGFyaXR5LCBhbmQgYWxsICJub24tVERYLXVzYWJsZSBtZW1vcnkgaG9s
ZXMiIHdpdGhpbiBhDQo+ID4gZ2l2ZW4gVERNUiBtdXN0IGJlIG1hcmtlZCBhcyAicmVzZXJ2ZWQg
YXJlYXMiLiAgVGhlIFREWCBtb2R1bGUgcmVwb3J0cyBhDQo+ID4gbWF4aW11bSBudW1iZXIgb2Yg
cmVzZXJ2ZWQgYXJlYXMgdGhhdCBjYW4gYmUgc3VwcG9ydGVkIHBlciBURE1SLg0KPiANCj4gVGhl
IHN0YXRlbWVudDoNCj4gDQo+IAkuLi4gYWxsICJub24tVERYLXVzYWJsZSBtZW1vcnkgaG9sZXMi
IHdpdGhpbiBhDQo+IAlnaXZlbiBURE1SIG11c3QgYmUgbWFya2VkIGFzICJyZXNlcnZlZCBhcmVh
cyIuDQo+IA0KPiBpcyBub3QgZXhhY3RseSB0cnVlLCB3aGljaCBpcyBlc3NlbnRpYWxseSB0aGUg
YmFzaXMgb2YgdGhpcyBmaXguDQoNCkhtbSBJIHRoaW5rIEkgc2VlIHdoYXQgeW91IG1lYW4uICBQ
ZXJoYXBzIHRoZSAibXVzdCBiZSBtYXJrZWQgYXMiIGNvbmZ1c2VzDQp5b3U/DQoNClRoZSAiVERY
LXVzYWJsZSBtZW1vcnkiIGhlcmUgbWVhbnMgYWxsIHBhZ2VzIHRoYXQgY2FuIHBvdGVudGlhbGx5
IGJlIHVzZWQgYnkNClREWC4gIFRoZXkgZG9uJ3QgaGF2ZSB0byBiZSBhY3R1YWxseSB1c2VkIGJ5
IFREWCwgaS5lLiwgIlREWC11c2FibGUgbWVtb3J5IiB2cw0KIlREWC11c2VkIG1lbW9yeSIuDQoN
CkFuZCB0aGUgIm5vbi1URFgtdXNhYmxlIG1lbW9yeSBob2xlcyIgbWVhbnMgdGhlIG1lbW9yeSBy
ZWdpb25zIHRoYXQgY2Fubm90IGJlDQpwb3NzaWJseSB1c2VkIGJ5IFREWCBhdCBhbGwuDQoNCklz
IGJlbG93IGJldHRlciBpZiBJIGNoYW5nZSAibXVzdCBiZSBtYXJrZWQgYXMiIHRvICJhcmUiPw0K
DQogIEFzIHBhcnQgb2YgaW5pdGlhbGl6aW5nIHRoZSBURFggbW9kdWxlLCB0aGUga2VybmVsIGlu
Zm9ybXMgdGhlIFREWA0KICBtb2R1bGUgb2YgYWxsICJURFgtdXNhYmxlIG1lbW9yeSByZWdpb25z
IiB1c2luZyBhbiBhcnJheSBvZiBURFggZGVmaW5lZA0KICBzdHJ1Y3R1cmUgIlREIE1lbW9yeSBS
ZWdpb24iIChURE1SKS4gIEVhY2ggVERNUiBtdXN0IGJlIGluIDFHQiBhbGlnbmVkDQogIGFuZCBp
biAxR0IgZ3JhbnVsYXJpdHksIGFuZCBhbGwgIm5vbi1URFgtdXNhYmxlIG1lbW9yeSBob2xlcyIg
d2l0aGluIGENCiAgZ2l2ZW4gVERNUiBhcmUgbWFya2VkIGFzICJyZXNlcnZlZCBhcmVhcyIuICBU
aGUgVERYIG1vZHVsZSByZXBvcnRzIGHCoA0KICBtYXhpbXVtIG51bWJlciBvZiByZXNlcnZlZCBh
cmVhcyB0aGF0IGNhbiBiZSBzdXBwb3J0ZWQgcGVyIFRETVIuDQoNCk5vdGUgaW4gbXkgbG9naWMg
aGVyZSB3ZSBkb24ndCBuZWVkIHRvIG1lbnRpb24gQ01SLiAgSGVyZSBJIGp1c3Qgd2FudCB0byB0
ZWxsDQp0aGUgZmFjdCB0aGF0IGVhY2ggVERNUiBoYXMgbnVtYmVyIG9mICJyZXNlcnZlZCBhcmVh
cyIgYW5kIHRoZSBtYXhpbXVtIG51bWJlcg0KaXMgcmVwb3J0ZWQgYnkgVERYIG1vZHVsZS4NCg0K
PiANCj4gVGhlIHJlbGV2YW50IHJlcXVpcmVtZW50cyBhcmUgKGZyb20gdGhlIHNwZWMpOg0KPiAN
Cj4gICBBbnkgbm9uLXJlc2VydmVkIDRLQiBwYWdlIHdpdGhpbiBhIFRETVIgbXVzdCBiZSBjb252
ZXJ0aWJsZQ0KPiAgIGkuZS4sIGl0IG11c3QgYmUgd2l0aGluIGEgQ01SDQoNClllcy4NCg0KPiAN
Cj4gICBSZXNlcnZlZCBhcmVhcyB3aXRoaW4gYSBURE1SIG5lZWQgbm90IGJlIHdpdGhpbiBhIENN
Ui4NCg0KWWVzLiAgVGhleSBuZWVkIG5vdCB0byBiZSwgYnV0IHRoZXkgY2FuIGJlLg0KDQo+IA0K
PiAgIFBBTVQgYXJlYXMgbXVzdCBub3Qgb3ZlcmxhcCB3aXRoIFRETVIgbm9uLXJlc2VydmVkIGFy
ZWFzOw0KPiAgIGhvd2V2ZXIsIHRoZXkgbWF5IHJlc2lkZSB3aXRoaW4gVERNUiByZXNlcnZlZCBh
cmVhcw0KPiAgIChhcyBsb25nIGFzIHRoZXNlIGFyZSBjb252ZXJ0aWJsZSkuDQoNClllcy4gIEhv
d2V2ZXIgaW4gaW1wbGVtZW50YXRpb24gUEFNVHMgYXJlIG91dCBvZiBwYWdlIGFsbG9jYXRvciBz
byB0aGV5IGFyZQ0KYWxsIHdpdGhpbiBURE1ScyB0aHVzIG5lZWQgdG8gYmUgcHV0IHRvIHJlc2Vy
dmVkIGFyZWFzLg0KDQpUaG9zZSBhcmUgVERYIGFyY2hpdGVjdHVyYWwgcmVxdWlyZW1lbnRzLiAg
VGhleSBhcmUgbm90IGFsbCByZWxhdGVkIHRvIHRoZSBmaXgNCm9mIHRoaXMgcHJvYmxlbS4gIFRo
ZSBtb3N0IGltcG9ydGFudCB0aGluZyBoZXJlIGlzOg0KDQogIEFueSBub24tcmVzZXJ2ZWQgbWVt
b3J5IHdpdGhpbiBhIFRETVIgbXVzdCBiZSB3aXRoaW4gQ01SLg0KDQpUaGF0IG1lYW5zIGFzIGxv
bmcgYXMgb25lIG1lbW9yeSByZWdpb24gaXMgQ01SLCBpdCBkb2Vzbid0IG5lZWQgdG8gYmUgaW4N
CiJyZXNlcnZlZCBhcmVhIiBmcm9tIFREWCBhcmNoaXRlY3R1cmUncyBwcmVzcGVjdGl2ZS4gwqAN
Cg0KVGhhdCBtZWFucyB3ZSBjYW4gaW5jbHVkZSBtb3JlIG1lbW9yeSByZWdpb25zIChldmVuIHRo
ZXkgY2Fubm90IGJlIHVzZWQgYnkgVERYDQphdCBhbGwpIGFzICJub24tcmVzZXJ2ZWQiIGFyZWFz
IGluIFRETVJzIHRvIHJlZHVjZSB0aGUgbnVtYmVyIG9mICJyZXNlcnZlZA0KYXJlYXMiIGFzIGxv
bmcgYXMgdGhvc2UgcmVnaW9ucyBhcmUgd2l0aGluIENNUi4NCg0KVGhpcyBpcyB0aGUgbG9naWMg
YmVoaW5kIHRoaXMgZml4Lg0KIA0KPiANCj4gPiANCj4gPiBDdXJyZW50bHksIHRoZSBrZXJuZWwg
ZmluZHMgdGhvc2UgIm5vbi1URFgtdXNhYmxlIG1lbW9yeSBob2xlcyIgd2l0aGluIGENCj4gPiBn
aXZlbiBURE1SIGJ5IHdhbGtpbmcgb3ZlciBhIGxpc3Qgb2YgIlREWC11c2FibGUgbWVtb3J5IHJl
Z2lvbnMiLCB3aGljaA0KPiA+IGVzc2VudGlhbGx5IHJlZmxlY3RzIHRoZSAidXNhYmxlIiByZWdp
b25zIGluIHRoZSBlODIwIHRhYmxlICh3L28gbWVtb3J5DQo+ID4gaG90cGx1ZyBvcGVyYXRpb25z
IHByZWNpc2VseSwgYnV0IHRoaXMgaXMgbm90IHJlbGV2YW50IGhlcmUpLg0KPiANCj4gQnV0IGlu
Y2x1ZGluZyBlODIwIHRhYmxlIHJlZ2lvbnMgdGhhdCBhcmUgbm90ICJ1c2FibGUiIGluIHRoZSBU
RE1SDQo+IHJlc2VydmVkIGFyZWFzIGlzIG5vdCBuZWNlc3NhcnkgLSBpdCBpcyBub3Qgb25lIG9m
IHRoZSBydWxlcy4NCg0KVHJ1ZS4gIFRoYXQncyB3aHkgd2UgY2FuIGRvIHRoaXMgZml4Lg0KDQo+
IA0KPiBXaGF0IGNvbmZ1c2VkIG1lIGluaXRpYWxseSB3YXMgdGhhdCBJIGRpZCBub3QgcmVhbGl6
ZSB0aGUgd2UgYWxyZWFkeQ0KPiByZXF1aXJlIHRoYXQgdGhlIFREWCBNb2R1bGUgZG9lcyBub3Qg
dG91Y2ggbWVtb3J5IGluIHRoZSBURE1SDQo+IG5vbi1yZXNlcnZlZCBhcmVhcyBub3Qgc3BlY2lm
aWNhbGx5IGFsbG9jYXRlZCB0byBpdC4gIFNvIGl0IG1ha2VzIG5vDQo+IGRpZmZlcmVuY2UgdG8g
dGhlIFREWCBNb2R1bGUgd2hhdCB0aGUgcGFnZXMgdGhhdCBoYXZlIG5vdCBiZWVuIGFsbG9jYXRl
ZA0KPiB0byBpdCwgYXJlIHVzZWQgZm9yLg0KPiANCj4gPiANCj4gPiBBcyBzaG93biBhYm92ZSwg
dGhlIHJvb3QgY2F1c2Ugb2YgdGhpcyBmYWlsdXJlIGlzIHdoZW4gdGhlIGtlcm5lbCB0cmllcw0K
PiA+IHRvIGNvbnN0cnVjdCBhIFRETVIgdG8gY292ZXIgYWRkcmVzcyByYW5nZSBbMHgwLCAweDgw
MDAwMDAwKSwgdGhlcmUNCj4gPiBhcmUgdG9vIG1hbnkgbWVtb3J5IGhvbGVzIHdpdGhpbiB0aGF0
IHJhbmdlIGFuZCB0aGUgbnVtYmVyIG9mIG1lbW9yeQ0KPiA+IGhvbGVzIGV4Y2VlZHMgdGhlIG1h
eGltdW0gbnVtYmVyIG9mIHJlc2VydmVkIGFyZWFzLg0KPiA+IA0KPiA+IFRoZSBFODIwIHRhYmxl
IG9mIHRoYXQgcGxhdGZvcm0gKHNlZSBbMV0gYmVsb3cpIHJlZmxlY3RzIHRoaXM6IHRoZQ0KPiA+
IG51bWJlciBvZiBtZW1vcnkgaG9sZXMgYW1vbmcgZTgyMCAidXNhYmxlIiBlbnRyaWVzIGV4Y2Vl
ZHMgMTYsIHdoaWNoIGlzDQo+ID4gdGhlIG1heGltdW0gbnVtYmVyIG9mIHJlc2VydmVkIGFyZWFz
IFREWCBtb2R1bGUgc3VwcG9ydHMgaW4gcHJhY3RpY2UuDQo+ID4gDQo+ID4gPT09IEZpeCA9PT0N
Cj4gPiANCj4gPiBUaGVyZSBhcmUgdHdvIG9wdGlvbnMgdG8gZml4IHRoaXM6IDEpIHJlZHVjZSB0
aGUgbnVtYmVyIG9mIG1lbW9yeSBob2xlcw0KPiA+IHdoZW4gY29uc3RydWN0aW5nIGEgVERNUiB0
byBzYXZlICJyZXNlcnZlZCBhcmVhcyI7IDIpIHJlZHVjZSB0aGUgVERNUidzDQo+ID4gc2l6ZSB0
byBjb3ZlciBmZXdlciBtZW1vcnkgcmVnaW9ucywgdGh1cyBmZXdlciBtZW1vcnkgaG9sZXMuDQo+
IA0KPiBQcm9iYWJseSBiZXR0ZXIgdG8gdHJ5IGFuZCBnZXQgcmlkIG9mIHRoaXMgInR3byBvcHRp
b25zIiBzdHVmZiBhbmQgZm9jdXMNCj4gb24gaG93IHRoaXMgaXMgYSBzaW1wbGUgYW5kIGVmZmVj
dGl2ZSBmaXguDQoNCkFzIEkgbWVudGlvbmVkIGluIGFub3RoZXIgcmVwbHkgSSB3b3VsZCBwcmVm
ZXIgdG8ga2VlcCB0aG9zZSBvcHRpb25zIHNpbmNlIEkNCmJlbGlldmUgdGhleSBjYW4gcHJvdmlk
ZSBhIGZ1bGwgdmlldyB0byB0aGUgcmV2aWV3ZXJzLg0K

