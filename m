Return-Path: <kvm+bounces-25130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA449602EF
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DC2CB20CD3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAE6154C0A;
	Tue, 27 Aug 2024 07:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VGx8tucN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F126133999;
	Tue, 27 Aug 2024 07:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724743364; cv=fail; b=n+mIX4Nzq1Y4H7e8GwgJPqeOUd+SpzmI9o1hh/u3f26OQZeeFqlP80wHFfyUNmp89UMywsq0+w4/e+mKI6C/D6XeuQ9i5hdCs8hWNwePTCfT373vBGPWxpjY6hH686Fge2/D74wqh+zQjp7W4yuiZgIN47IeuludhgTVykcvUHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724743364; c=relaxed/simple;
	bh=ZOcmd5VlUtbogwGmJDe0duIyhVtA4kubLziRJTW6Yfo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tggbvgkViohnEpUoHWqiunfoiAidDKQiS160CHXqV0svZoBH+iVya7U3g+A86lkGUJrXiWXbuAT39ocRm13TbyvzNmMkSeCCgFPbJGYFAkJxppiaRDkVWT/HLeBmxhzqqpVL+WglDgqP2Vb6ms9wGBRFWtKkxRDu17TT4Z4zdBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VGx8tucN; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724743363; x=1756279363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZOcmd5VlUtbogwGmJDe0duIyhVtA4kubLziRJTW6Yfo=;
  b=VGx8tucNvseuQjiHk3+fZrrgc/ean04m3nxe3+chzmeh8R2AKFv5sjvQ
   MaK47Bddfg2APFs2IJZ+lyMzoc7vsLvLpdonKwgt4ClC0Yt19IaWZsw6C
   o3sYyzL5GCBhvCl+u5oCG/Fff1Bok/bBN25PtSeNjBQaI/jpk8PxM8CJ6
   4E5FiZor3bPIwyuDqjm3u/19Cn6Td6tTIonm65tM6fWZw+RkiL98hnzVQ
   Qx8fE4nb77cMaSkktbBmfoheEJ7Eo61x1xNLPcquex/B0CR8ZPj3i2z04
   EI8nmLwGg2decBoLklRNIQEA57TSoTLjQsGu2MqYUJ1F6jYp+OnzfwEjm
   Q==;
X-CSE-ConnectionGUID: GdUTwooWSEeNzJiQmGgsSg==
X-CSE-MsgGUID: JW2I9B+RRJmCkogBlp3qdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34576690"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="34576690"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:22:43 -0700
X-CSE-ConnectionGUID: mkcbTPT2RraZzCYn202VEQ==
X-CSE-MsgGUID: jo3nM0V0QsWIWpyPo+tSlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="93573716"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Aug 2024 00:22:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 27 Aug 2024 00:22:41 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 27 Aug 2024 00:22:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 27 Aug 2024 00:22:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 27 Aug 2024 00:22:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ytAZZjAdOxI2n50N9beWgvqmYsXKnxaj5NVCtXsMXRPs3wlora1KtsOFL7xXmKaW8IWj+ss3Q23rmC+KNDILZ+996bQZSUlq+cO4P3Un2ZrVCX38LJNy0nclTaTvx1dObsilpkAheHjHRsLCoZ6qscaVQVi1CQQ7VLfJJcoINu6s5iUdYnYT5VLPsvsnEWitEwbe96XcHqTveDmdWI94IHC5ZlhdcxTA9p5CFfHjbrutFIt88tRGZU4W+rS9GTLnfFU1hpQYur2MBr05lzkK4qytyIurRQ1CqdrNC0dDPsUNXC5NTdcLG1QkSCw3wRVa5u64SSGwGq29YXG931at/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOcmd5VlUtbogwGmJDe0duIyhVtA4kubLziRJTW6Yfo=;
 b=xP+pdCsfRITCAaBBYZI+44Thq5X1Vzn23Yc5Vcj30VZvWzCWSeter05IIRCNgBR320umbgZXSi4dJ3Hy4B4XkMm07JOiufSo48qJS6Rqb8iI3xe8sEQiow6xCQJHOkv89lP6TQ/raeCA5kHrPHl9obYcza4/30hvsKptszKUD5uw2H6DQIeXkQ3X9bSkk/a8qUT2V7NwYJPMGyFd50n+MhYJR+Y8A94aLSwSO/YBWM7w+q1OBdJLbSKlPmyp94Hf7KjBCoN/07BvInHPyybvNJRACYHvyQGrDMuFqCKebKkqJqvVHNevfhpsd574CmHi2om/+pAFwqqNzZq2UAy5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6966.namprd11.prod.outlook.com (2603:10b6:806:2bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 07:22:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 07:22:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Topic: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Index: AQHa1/rBf1e/y/ONHUu17Yv0cGvYCrIZb5uAgAAKUoCAABHuAIACSXUAgB4WuACAAHXkgIAAaKEAgAApRIA=
Date: Tue, 27 Aug 2024 07:22:38 +0000
Message-ID: <491e3134f4fb1a09436aceeefb4104c4e11275d7.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
	 <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
	 <7b65b317-397d-4a72-beac-6b0140b1d8dd@intel.com>
	 <66b178d4cfae4_4fc72944b@dwillia2-xfh.jf.intel.com.notmuch>
	 <96c248b790907b14efcb0885c78e4000ba5b9694.camel@intel.com>
	 <a107b067-861d-43f4-86b5-29271cb93dad@intel.com>
	 <49dabff079d0b55bd169353d9ef159495ff2893e.camel@intel.com>
	 <7ae1fcac-cbea-478c-b8c9-d2c2a5dd6f11@intel.com>
In-Reply-To: <7ae1fcac-cbea-478c-b8c9-d2c2a5dd6f11@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6966:EE_
x-ms-office365-filtering-correlation-id: 5046d797-2ffa-45a7-79c1-08dcc669081f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UnRMMFExNUFWKytqdlRRVHJ1ZGpQUDRDK2twMGhmMElPY28zTk5Id2Rzb001?=
 =?utf-8?B?T0Y0WmhqZWRDZVFDWU9CWG5FSk9GVEQraHBhNFJTSExPTjBxUTNRaEtpRDE5?=
 =?utf-8?B?ekNhSkFOdzJ6R1dUWnVEZHJMRHB5cDJ2OEJJSndTYWYrc2xuM0dWZ0Y1VkhM?=
 =?utf-8?B?T0xBTmp2K0lkNDVMbVNHWlhJYlg2Z0s3UENBQlRiRXpWZjljK3YzWCtpQlFE?=
 =?utf-8?B?bG9zc0hYcjg4R3k1aHl1QjZ2cC9ydG5GQWtrUWFuNHdIdyttck5mNkdOQjhk?=
 =?utf-8?B?c1FyMlRlbTRaTmF6ck9mT0ZNMjZmNGVqN3hQSEVVVnJZczJUdVp2aEdxdTQ5?=
 =?utf-8?B?dVRRR0pISk9IcUJ0aCtOaGkzdlBWRTFyRzFSUWJxdVc2QTNjMzMyQWF5WDBE?=
 =?utf-8?B?T1BVbVFXQ1JvM1FOdWlLTGVRdk8yQ1BJR1pBUmRIYlQyaEtCZTdINyswTFJu?=
 =?utf-8?B?YThaUmNVc2M0SW9DODlhWnVWcWFiZE1tUW1QWDQ4UXZLZktlU2djZlg4eHJY?=
 =?utf-8?B?eU5jRWk0MTZOL0c5U3dqanJMRXJvbUFtdC9RdFdyVHdwaC85MVNqcUkzTyt1?=
 =?utf-8?B?R2l1Z2NVZDdXRjFuaFVtUjdsL2Nsb3N4aENldmFJTEpUb044V3MxcjI2aHB3?=
 =?utf-8?B?OEs4RkZsdnJZTGtXc0xTQmZoSHhLazVhUjhVMDJPSEUrYlZJNklRVE8rSWtX?=
 =?utf-8?B?SEw4OHp0bUJLdnkrSDZTa2Z3Wm56QjM4ZlZzejdKTTZNUW1mM0QvSzdiME9L?=
 =?utf-8?B?MmRQekVRNDhrVU91ZE5BeU9mUC9FR242SDJEQkFRYnprMmVyWHJKeEJtTC9x?=
 =?utf-8?B?L3lDVzZ5SjdBeFY3OFovYU1WMFVKN1BPQXlLMkczUXlkelZ0WDFkUk9XdmZ5?=
 =?utf-8?B?RVNxOCtyWXJsOHA2aFZNckc0ZFI4UUFxd0k0azFBWjBQbEJIMmR1bFEyZ0hn?=
 =?utf-8?B?QXN5TlVWQWpCWHVNb2lxUEVtaXdERzJ6Z2ZTblY3c0dVVDZzeE01TzZ4YUpo?=
 =?utf-8?B?K2lXcW1Dci8yQVhSbDVoVlNSalpzbXFyWGlkRWEwQk1yaXpkbVRBWVJkMUFv?=
 =?utf-8?B?ZzNHVllUOHF5cDBvbWZlM1U5cnB6Znhscm5PdTNkYVo5WjI5Y0VucEhYUERB?=
 =?utf-8?B?LzFvTFVoU0JMTlMyY29MUnlkTTlaV05LSlVEaUwxaVIvSVJ5dGZaKzJza1Zm?=
 =?utf-8?B?RDAvbDdWRkk3aG8weUhDWk9uL1pBNXo3TVFtNDNjcVdHNWN2b01vZFNKbWE3?=
 =?utf-8?B?UFFtdk5OQW5PdmlnWlUyM0RzamRHLzR1MVk3OEU4RCtKNmxDakpCOTVrY1hr?=
 =?utf-8?B?YmpMWGtVS2lqN1F5RXV6SVl6LzJNMVk5WnFDSzczQmVWRjFrUVl6Uk44bFRv?=
 =?utf-8?B?TFNnQVl5OGMrdnY0ZkpyMGxsdEo0eDllNU8zZXVhR2M2TlBTbWk2NHNvV0VN?=
 =?utf-8?B?QUVJelZBNTlRSm1yNERCb21Fcm5vTS9rbDdjeFg0ZEpObDV4M0FqNnVFcXp3?=
 =?utf-8?B?NnJoVDhWeFU3SHZ1dGVFWmppT2JhVlhMYnBGSXd3aHlwem82bDZMaGRObGdv?=
 =?utf-8?B?dGFnZ0x5STErNnJoaWxNZHRMaWpKZGFlbWZlUHdvVStaeDhlZm1mdFhWakQ1?=
 =?utf-8?B?NXMra1hkVjliN2Jrcld0TWVsUTN5Mks0MmlPSTRQZ3ZZeVVaQ1Ftb2tnaFZG?=
 =?utf-8?B?YUxLejlMenNrVGRJdDBPcDZXZUZSczcwcWVQakdrOWVwQWtqT3BqQ0lLMW9q?=
 =?utf-8?B?NFNaVDEzSWl1QUh0dnozSEZLRFlCSVc2SXdUWmFoeENEaWRjdUVtbHE3T2pQ?=
 =?utf-8?B?eUIwM2lJMUNtanBiSG8xZk90SWJueC9zWlBpaFVpa0VGbVM4bWNNUmdKSGFK?=
 =?utf-8?B?WGxwTnR2UlFvK1NjUktlSVovQm1RbHF1VjNQNGxqSngwRm96Y3NwaGI2MVdP?=
 =?utf-8?Q?V5noV2hYFCA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anNLNHY2YnAwZGlCV3FlejR6OFM0eERpVSttT3JJWmxZUVozZDlJb0tHVDJq?=
 =?utf-8?B?NlNLaitJaEdVRnlNUVZEYzhtbFdEcHdXUlMxbWJJQzYyV2Q3QXE0dDBUb1or?=
 =?utf-8?B?RzJqY2JDNXNTbXFabWpNNUpRcWw2NVVSTHhaeUVJVHYwNVVRR3N3ejVqR0Ez?=
 =?utf-8?B?ZWNTOHpQdStrS1crc291ZThiOFZNVzBtQWFaMVNpUDc3dkJoNk5ST2ppNHd2?=
 =?utf-8?B?ZTBUVnh4ZUp2UWxUa3ZibFBEMDVQSERXcXNlNzN6ZnI3L21XMnhOdzYwN2Uz?=
 =?utf-8?B?RExtYjZaRlZ3aDRYM2VUcW91OXF0L1Zyc1BNUUdtaGc4U2ZhdWtHVGRTQmlq?=
 =?utf-8?B?VnkzOThwVjROQ25rekZ6UlRKNFF3TzJsaEV4VkE0cWVFMnZnUEZtUFhhUXdM?=
 =?utf-8?B?QUJEdFNyTGRUaVZkNFpkR3VKUFZsT25iYjdFYXYxblpta0VoNG8wYXoxWkpS?=
 =?utf-8?B?c3VNcjdLSUhKNDJKVFZxb0pUTGZUQzdRQm9BM3pmbUxpVkRWSUdSVlAzV082?=
 =?utf-8?B?WGRzVWkvYlVWS0ZOVlI4ZnBpSUg3MTBzRnFrN0RWQUI1ZmtkdUgwblhoYUdV?=
 =?utf-8?B?alJNdlJ1QUtYbHlSNUJwb0xJbDBoZUZuakdsdTUrWkNISDdBbCtUamdFdHZX?=
 =?utf-8?B?d2NWVjFzMk42UVlxNERNOTJPOUpqYWJ4VzY3U1dmbmRDbWJreW1HWFU4TVpZ?=
 =?utf-8?B?Wm84ZXFqa0J2U25VTk8rUFBRYzJNc2t2eUlJUmVuM2paQm5WQWNXc2lVdncv?=
 =?utf-8?B?WUFDbnU4dkc0eHJsL0lCM3l4Zm5vTzBPTzR2bWpMK3JuZmFUUWxYUEp0SU1v?=
 =?utf-8?B?MWVkYmFRYkdwNUJveDc2eU10MnQrRmFUMnNVRTdKM05kOG9CQ1hJdXBLOGdR?=
 =?utf-8?B?aE5YNUd4OENVZG5laUVmaTkrdjBJZmZzL0NpbjJUaFZsZDhQckwzdWZsMitG?=
 =?utf-8?B?T0NzUmFtd0xHcFRrUXpaZDJPaVVuUUxYNDg0bmdZbHkvMU5vQ2FoSXE1Q2xo?=
 =?utf-8?B?RUpGWVlYdHpacll3ZlpQYWlTbzNRZjh0T3BTYkxKK2FUazZ0TytONG9SVE5a?=
 =?utf-8?B?Nlg2eEc1L1lCRGd2WHJxWEFaWVBiWE9tb2RpMEJuUk90NGd5VDkzRXk0aHhO?=
 =?utf-8?B?WWJOSWZ1N0lRamNRN3BWeUdmeTRhZ2cxKzc1d2pOVytQUWQ2aFpuSmF4b2JE?=
 =?utf-8?B?UUhJU04vaU5RSXdXS2dXVE9uMjZoQ3pFYW5BVFVrajRqN2hKRGtuajlkV3Bq?=
 =?utf-8?B?SG54RVA5aG5YTWtzVEtIVm1sQi8vem1USjNQczFKTDVTcHI5amRWV0VCUmFI?=
 =?utf-8?B?Yk5oRi9UOE1ZdjdtZXdjTGJrNWdHVFc0VllBTlN1MHlEMy8wN3ZhUHZwZU1S?=
 =?utf-8?B?bVdaOHhaSm9UbmY3Y1Y0WHZlOWNsNXBOMS9GWDBIR2NhOWMza3l0RENJUzRq?=
 =?utf-8?B?bHJDSHkwZFM3ZmRMMk0zTld6bzdjSkxMRDFMeWtPV0lQVnRTaGtLWUJ6OHNj?=
 =?utf-8?B?TFVrWkQwNVpSUUtBTUFXaHJXRlNhYmhiUUN3cXJPOUZiVDIyK0luSFVLNE4w?=
 =?utf-8?B?Rnp5RmZTV1RuaHFzVFhxM3V3MDVYVkc2K2xDaElYbFNLTTZEUVRBMHdncm5W?=
 =?utf-8?B?Zm1pQkhvY0NuWEIzTmM2THluNmdCYWFRNktNc0tHS3kvTWhubE1adzk5KzQx?=
 =?utf-8?B?UTljL2pseVdBbFgrUUFzRklkNVk5aXNlT2ZNV1h2TlNYZmV3SVNsWG1RdnN4?=
 =?utf-8?B?dk12VWx0dktjN0VIR2l3OEFOVnhUL215SjVUdGloMnFraFdtYmxXVHdndUFR?=
 =?utf-8?B?a2NQdDU3cWtGOFd1aWN5OEpkak91bUljSzdEb1FMZ0gzL0c5Ny9kT0xMUWFB?=
 =?utf-8?B?d3dKYkJpMzBsUzAxVVhwb0krdmNVRTk1ZC8yeEpCT0hXbVJXSSttSkdOa1kr?=
 =?utf-8?B?VU5NY1BreWFWcS9YOEozTXdDam95WXFtbno2UjlnUFhUOEp0aTlzK3FQKyt2?=
 =?utf-8?B?Lzd4aTl0V00waTJCZTVlaS9PVlRJTzFTQlpJTnk0d2h2YmwwV1lYZXhrWDNL?=
 =?utf-8?B?RFNOWEltOGdvVEVpb0V6NGgyWmJxSzFSWVRYd2g1VGNJc1RhSmttaU1IVFZH?=
 =?utf-8?Q?aqPXs+MoVkn1pFbtto0Qcyl3Y?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F38C4A89FB8A3242BA60EC46C8DE5ED6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5046d797-2ffa-45a7-79c1-08dcc669081f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2024 07:22:38.9533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wnteXxWAgi7HfXwCBkBT40Cy1k63KYOvrj6uOjritwmPVyEF+Njnv+q03U/s+zQkL/W6vNZm9pJp6G0Z6w5eEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6966
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTI3IGF0IDA3OjU0ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOgo+
ID4gPiAKPiA+ID4gQlVJTERfQlVHX09OKCkgcmVxdWlyZXMgYSBmdW5jdGlvbiwgYnV0IGl0IGlz
IHN0aWxsCj4gPiA+IGJlIHBvc3NpYmxlIHRvIGFkZCBhIGJ1aWxkIHRpbWUgY2hlY2sgaW4gVERf
U1lTSU5GT19NQVAKPiA+ID4gZS5nLgo+ID4gPiAKPiA+ID4gI2RlZmluZSBURF9TWVNJTkZPX0NI
RUNLX1NJWkUoX2ZpZWxkX2lkLCBfc2l6ZSnCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBcCj4gPiA+IMKgwqDCoMKgwqDCoCBfX2J1aWx0aW5fY2hvb3NlX2V4cHIo
TURfRklFTERfRUxFX1NJWkUoX2ZpZWxkX2lkKSA9PSBfc2l6ZSwgX3NpemUsICh2b2lkKTApCj4g
PiA+IAo+ID4gPiAjZGVmaW5lIF9URF9TWVNJTkZPX01BUChfZmllbGRfaWQsIF9vZmZzZXQsIF9z
aXplKcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+ID4gPiDCoMKgwqDCoMKgwqAgeyAuZmllbGRf
aWQgPSBfZmllbGRfaWQswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgIC5vZmZzZXTCoMKg
ID0gX29mZnNldCzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgIC5zaXplwqDCoMKg
wqAgPSBURF9TWVNJTkZPX0NIRUNLX1NJWkUoX2ZpZWxkX2lkLCBfc2l6ZSkgfQo+ID4gPiAKPiA+
ID4gI2RlZmluZSBURF9TWVNJTkZPX01BUChfZmllbGRfaWQsIF9zdHJ1Y3QsIF9tZW1iZXIpwqDC
oMKgwqDCoMKgwqDCoMKgwqAgXAo+ID4gPiDCoMKgwqDCoMKgwqAgX1REX1NZU0lORk9fTUFQKE1E
X0ZJRUxEX0lEXyMjX2ZpZWxkX2lkLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4g
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG9mZnNldG9m
KF9zdHJ1Y3QsIF9tZW1iZXIpLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVvZih0eXBlb2YoKChf
c3RydWN0ICopMCktPl9tZW1iZXIpKSkKPiA+ID4gCj4gPiA+IAo+ID4gCj4gPiBUaGFua3MgZm9y
IHRoZSBjb21tZW50LCBidXQgSSBkb24ndCB0aGluayB0aGlzIG1lZXRzIGZvciBvdXIgcHVycG9z
ZS4KPiA+IAo+ID4gV2Ugd2FudCBhIGJ1aWxkIHRpbWUgImVycm9yIiB3aGVuIHRoZSAiTURfRklF
TERfRUxFX1NJWkUoX2ZpZWxkX2lkKSA9PSBfc2l6ZSIKPiA+IGZhaWxzLCBidXQgbm90ICJzdGls
bCBpbml0aWFsaXppbmcgdGhlIHNpemUgdG8gMCIuCj4gCj4gRldJVywgaXQgaXNuJ3QgMCwgaXQg
aXMgdm9pZC7CoCBBc3NpZ25tZW50IHRvIHZvaWQgaXMgYW4gZXJyb3IuwqAgQ291bGQgdXNlCj4g
YW55dGhpbmcgdGhhdCBpcyBjb3JyZWN0IHN5bnRheCBidXQgd291bGQgcHJvZHVjZSBhIGNvbXBp
bGUtdGltZSBlcnJvcgo+IGUuZy4gKDEgLyAwKS4KCkFoIEkgbWlzc2VkIHRoZSAnKHZvaWQpJy4g
IEkgZGlkbid0IHRob3VnaHQgdGhpcyB3YXkgKGFuZCB5ZXQgdG8gdHJ5IG91dCkuIApUaGFua3Mg
Zm9yIHRoZSBpbnNpZ2h0LgoKSSBhbHJlYWR5IHNlbnQgb3V0IHRoZSB2MyBiYXNlZCBvbiBEYW4n
cyBzdWdnZXN0aW9uLiAgQmVzaWRlcyB0aGUgcHJvcwptZW50aW9uZWQgYnkgRGFuLCBJIGFsc28g
Zm91bmQgRGFuJ3Mgc3VnZ2VzdGlvbiB5aWVsZHMgbGVzcyBMb0Mgb2YgdGhlIGZpbmFsCnRkeC5j
IGRlc3BpdGUgaXQgaXMgdHJpdmlhbC4gIFNvIGxldCdzIGNvbnRpbnVlIG9uIHRoZSB2My4K

