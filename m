Return-Path: <kvm+bounces-44652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C58DAAA009F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18D765A1377
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E51D26FDAF;
	Tue, 29 Apr 2025 03:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q1z1QXb/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC2A15A858;
	Tue, 29 Apr 2025 03:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745897839; cv=fail; b=Qpt7qKkioU0FlQsh4VSTBxDcHhyaUJ1G6VWD7aDei/wl/wXD5x0WvxUnnM8qHBUHOewJbXm3Q8nreoS6Ma6p/CU+gLojsVm15RCc1FmDE1nvr0d7mLlRgX61/ixnZKhzAWY9CzXKvsrxQx4uzaG9t4GwOi6GeralnJ7rIQOMX+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745897839; c=relaxed/simple;
	bh=wijXpDksk38iZ45GrBuFm83tBgkAbftbAaucZ8Z+Hc4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QmZnZgRxFmTXj1EDb1r5XjD+5B5npqXHVmgUUKA6b0VhJsRYWm/+bZ38keVtaEIKa1ZSDKY71n2mzWRmz3Cr/mnf+f5gOw5M2BHqSjPwq2rNm4EXBKiqCuawFW7/MdL4HM2UGgJkampTufwQ86FNC88aYL2FlCJ9w0q2KXTCPfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q1z1QXb/; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745897838; x=1777433838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wijXpDksk38iZ45GrBuFm83tBgkAbftbAaucZ8Z+Hc4=;
  b=Q1z1QXb/22mnrcNZ86MMnZB6U4RXfda5hjr5Mz7k+zwTRPEi8iM9VtFj
   6OrnUoXe+iLsm4tVrO5/B6VmmpXMZFso/RN0bgEJxbkrv3AXZ2sfPuZ3T
   a3vFhNvSNXsIS0jtCK/KjLYblAB0S5QMJQOBMaac7AZzZ8O0Grf+wJeYu
   /MWvy85qk4vTgqBLMiH+wURPkE9GKFZFEXt/Flq/rT6uVDZBXXvZn7Vwa
   2L0bqrzor9Wy3lD/plf3+8gWJ7a6+OcvZwltsT2/rcGpGfTVAZnJLsawO
   1DWAO6VxqfbebEFDFeqhX6Q/ZCrb+1vmaBppZfW0F6Hn37cQZEHBzWdwl
   Q==;
X-CSE-ConnectionGUID: SBOIxH3jS7K1oEYRuXUUvw==
X-CSE-MsgGUID: 2dgdIyW+QJq2o4h/3cnn/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58876693"
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="58876693"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 20:37:13 -0700
X-CSE-ConnectionGUID: pE7B7jHeQhWtCRWAchDB7g==
X-CSE-MsgGUID: yNScOEOcSWG/EajdopidjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="138512275"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 20:37:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 20:37:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 20:37:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 20:37:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rz4rR1htXE4w4Pc3siS8Ke+DfUk4J9DSeeLC41VtsppyOB//8eUb+ricm9AcfsldjlWousByRh36oIJiyZkjLrV7ZP3cKU5CpNtcmba+igmpr85rDexet3ivJev5UkXAZMQ+4LWbWfzGsA08/405AU1SIVZ7gUSvVhARSlrcKurCxQ3pnyh1AsK4CL9oY1sLYkJqAVmsJsCfhR+NPTSiJ8LwwWI0WCQrmP3888kww0IlHF+Oxvg3F1s94kI2BV3jXuYEV1dvgOwwuS1wbBsjOymP+wKmNM9ynAgMFTRLX6+ZlUTvVRFQiei8s+TqfrID+f6pvLzG4Re/voujMqkNTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wijXpDksk38iZ45GrBuFm83tBgkAbftbAaucZ8Z+Hc4=;
 b=n+nX09dMvh2YkLQrsRebr7S5b+nmATev4p1GYvGvCs/oEQ4ZGhdSx1FdbKl50O37sie4avKCqem+hyy1iK2AesSeDlJ3EeEQbUUMNqimkTQ9R5+WkZK5hmHaUI3eFUHzac5LmHLrXI1mNA/5/jkk7ImJGhg035lYHElYOF03vwJdR69nam1PAuaE+C06uPqNmpNpv3//M8EyZpOBFYkzXXL/RZsp5o+KbqzFIk0a+sKKxaGo+ak4iFN45fAGcHNAn1y7BbkCn8HAo5CdpQ5Z2hyox5Sp1zzjnab5xG2aCXbHFeS02ZZjZTxo5F7K87RT6NfazwJ3J6Dg2FZBbwU4YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8060.namprd11.prod.outlook.com (2603:10b6:510:24f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Tue, 29 Apr
 2025 03:36:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 03:36:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Bae, Chang Seok" <chang.seok.bae@intel.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "vigbalas@amd.com" <vigbalas@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
Thread-Topic: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Thread-Index: AQHbqelZqhZU+Oq6j0yiouUZFd9/N7Ozg2wAgACfzYCAAIHMgIAAgC8AgAQvOgCAAJ7/AIAAG5MAgAAJFwCAAAPrgA==
Date: Tue, 29 Apr 2025 03:36:40 +0000
Message-ID: <f57c6387bf56cba692005d7274d141e1919d22c0.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-4-chao.gao@intel.com>
	 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
	 <aAtG13wd35yMNahd@intel.com>
	 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
	 <aAwdQ759Y6V7SGhv@google.com>
	 <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
	 <9925d172-94e1-4e7a-947e-46261ac83864@intel.com>
	 <bf9c19457081735f3b9be023fc41152d0be69b27.camel@intel.com>
	 <fbaf2f8e-f907-4b92-83b9-192f20e6ba9c@intel.com>
In-Reply-To: <fbaf2f8e-f907-4b92-83b9-192f20e6ba9c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8060:EE_
x-ms-office365-filtering-correlation-id: 39831563-4cd1-4eda-f2c1-08dd86cf0dc7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?azFQaVprOEJXRHZOS29IWXNaenA5TTZ1UWRyWVNmZ1B6VGNOTUJXR0h2YkxL?=
 =?utf-8?B?ZjNYSFJZOHQyOThtSkFyNGtnY2Uxd3lLMi9VN3JUa1ErR0xTNmxvMU1xN1Jy?=
 =?utf-8?B?TFZ6ZmJwWWNUcGc5TnNFWnVpVFZSRHBmb3BxT1d6S2grdzV4aDc3OHZ5OXBi?=
 =?utf-8?B?am5RbitIdVh0TnNzYXVrRUk5aVhFRi9mazJ4a3JIWVlIbjZjZERDb0pDdFJB?=
 =?utf-8?B?U3JmMlVNUUhqTDdheVZOaERESGp3aTRVeXdnVFBQS2wyQzQwUGlxdXU2ZThj?=
 =?utf-8?B?M2VuR0xTZ2lQQ05wcHRNTngyUTdpdkNYWGJaMDVNT24xNGhPS1dUQytzOFRQ?=
 =?utf-8?B?QjhSbS83ZWhkTGlzaHRiOUF2YmppSU5uNFdrVVRKbjNDYllNNjI2M25DKzNV?=
 =?utf-8?B?M1NodmpXSjlBVWY0UmgrQjlKTVNrSm9ncWJBUzlkMUEyWmYwUE0rdXlpTFg5?=
 =?utf-8?B?TnB0RlQvMG5tc2Z2Q3Rxb2JTSjV0NkNtR1NydWJMcjB0S2FPeHBYcFdBMWo2?=
 =?utf-8?B?OU1Zek5kQkRYTURLVnlFYTQxTHplLzlIa0xEUzFxWUk4UG9uZFkwMk1QUm5G?=
 =?utf-8?B?L212b2xVR3BFeDFFcTR1Y1BDWWFMWFJIR0s2R1BDajBWUTdDQk44MWM0QXdj?=
 =?utf-8?B?VUxUVGxtbU4zOUpkUTl1bWFTZGVuenluUlQrbVgwc0Zmb3VWaW92d1BqeklI?=
 =?utf-8?B?dTAwZVI4bnpGZEtmcWtHbFZEOW1paFh2QXllQnA4MzVlUGsxbllNZ1ZaRkYx?=
 =?utf-8?B?MUxuenRua0ttV2VXSWpvZDl0eEJFYjZlWVYza3piZEc2SFFtKzZqcWkyQnZk?=
 =?utf-8?B?blVaRTJWQXBvRmRsU21EQ1htaFRKWGJMODdiL2M4SE8vTm12UDNHancvU2Zs?=
 =?utf-8?B?cEkzbk9oazhvd2MwV2lxMHBlV01WdjZuaHBEZjR5N0hyWlZ0UU4xWFlEODJL?=
 =?utf-8?B?V3lFa2NXMm1uK3poOGVTOUxiUmg3YWtnc2Y2M1ZnMm1jMThzUjlhRkRTNjMw?=
 =?utf-8?B?Vkt1ckFYN3lIYWdYY3ErMkdWYTdxUEdlTkY0SGhMaW5jQ3gzM0VKUVMzcTI5?=
 =?utf-8?B?cTQ5Z1ZWd0orcEpWSm5SSlhCNDNNa0N5eDY4OVloWWpjeXdZSXlPR29sNEdR?=
 =?utf-8?B?NHdwclBRYVlGYXVUZVljcHV5SFkrMVhQcjVDMlJYWEZKUy9vNGxQb0cyUGNX?=
 =?utf-8?B?dnBOOHpzNWlFVXNoanJNTVJKd1haK2RacVEvbncrOGxCczBKakFPMGNiUGUy?=
 =?utf-8?B?Q1VYcWY4aHJCMUVhcFRtWi9LWGxMNEorMWRCK1NTS2QrVVRSR0xpZktoTGZN?=
 =?utf-8?B?dEgwYzlZMjRxeVFJZWM5Q21OTHhzR285T3poWGtjMExTamVhQ2thT2h5cFRN?=
 =?utf-8?B?QW9xTFRmRFJtYmFlTTlPbHZhVzlBbGJOSUkzSFhNOUw2N3BMdi9LaC8xSjJP?=
 =?utf-8?B?bFpYS1Vzdk5NOE9LcnhUTTNENE95dXkrejZQbkQ1bWdSdlpNK09RQ2tHMW4y?=
 =?utf-8?B?WDZkWXhXWVpyQUQ1M0tVVDh2dG5mTjZOWDFESmNFeWsvTHNnY1VaYU03MVMw?=
 =?utf-8?B?cVdYWGphb0dzUVVJempDbkdwbzMzWFhtWWh0NTlqNmJhMkY5UGhzZSthdDVC?=
 =?utf-8?B?UmIrcVAxcUt2WUJWT29abXJXQzAvNVFtWHBqQ1FPbDBVSGRFR0g3dDdQU1ky?=
 =?utf-8?B?WTdMSWNKZEtSSUJ1ZkN3T1dQNTN0aXlnSmhNcFRuYzFNcWZpWDRZQWp5Uk1C?=
 =?utf-8?B?YVpndnFHdDkxdXZnV3dlMG5ETXg2M3pNSE9pNkptWFArdVFPd3RUeDM0amlD?=
 =?utf-8?B?ZUNDdUN4MGVqYS9pekdjaTJvcktGTlZ0eTZmanZEd3dwMGpkM2YvZVIxZ2dN?=
 =?utf-8?B?eGgwS3E1K3dnb0s0TUU1UUxSSGZsWjc1N2hzVWplK05tOGFYT1VvcWNJOWFs?=
 =?utf-8?B?S016Q1BGVlpGbTBkbm9yaVEwVXBYL2FKamZxS2prZzZEZjFZT05IOXpvWGFF?=
 =?utf-8?B?UjZJZUVpL2tRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3Baa2d0b3BraU5oTC8wQll6Mncyb3hxbUxtZDN6eFRXMHo2bmxyRGFTU3ph?=
 =?utf-8?B?OGJkWUx4SXRmL2tneXBHY3pib2FTZkFhY1ZCSUYvZVU4S1FSU1lsU1hUcVds?=
 =?utf-8?B?Wmc3TVpqQzZlRGdKQ05JZjZaUFJOU3BIMU1BS2RtVVJGeWdRUkJNby92VlN6?=
 =?utf-8?B?QitFWWwrQllablFFWmpPM3RvY3lWN1F0cVJXZnlaSG12dk5GNFF3RjRJRFhx?=
 =?utf-8?B?OUpRRFNEUVRndEk4UVlPWUs1emo2bWcyOS9yYUlZZ1FjUGI4SFpwVjMwSWt1?=
 =?utf-8?B?NHdodWM0YWJtUVMrU3VwVmRFQzRUMS9XcTMwNXFFV2xtMW1JNHhwMnR0TTBQ?=
 =?utf-8?B?VUpycXd6MFRWbkdMaUUwYjVOSVZlZGlFWnQ4L1Vrci9mejk4YkJPYUtCbnM4?=
 =?utf-8?B?WXZackdYVnVtRmVnTU9IUUN0SGRxdnZEM1BJRGprSEpQZXBZb0VoVjNoSVFl?=
 =?utf-8?B?SzNacGNHQnQ5MnFUd2crWUw2TkdGMzFqaTgyMjFMTUl2ZzlnY1VNcjZqL21J?=
 =?utf-8?B?eFV2WUhpWkN2NEZHSkwrNllPUVcrRXBDRG5lVm1KWmg2cDZQZUpuRCtvcGZh?=
 =?utf-8?B?K2Y0ZDlmNnFEeGpsN3NuOHpMR0tjK1dQV2EyblpoUXEwV3IycURYTnIxMDAr?=
 =?utf-8?B?MTcxVjJZdDNSMDVxUDRuclg5OEl2VUU4THU5d3ArTkg1N2hSMEpMOENVRFYw?=
 =?utf-8?B?UHhIK1dyTDBXSzlScUx5M0ZkZVIyVkFtQjgwMWx1Vm1XaE9hTmZjWlZLU1V5?=
 =?utf-8?B?cmJiR3RmTER2VEtZL2NhZlNocFByOFhpSE5jYmt5Z1pDa3UwQW5nRXdaWENk?=
 =?utf-8?B?OEFqbkpFbkdTUnQwTXVDWXZLc00ydjBIeDJPbEI1V2h0blYvRDRQUkZ1cTYv?=
 =?utf-8?B?SlBhK05ya1RXSjgvdDlNVUVuSEdIYUFWVEZ6ZTRwVjduS2FGWCtJNnloNWNx?=
 =?utf-8?B?VUhkRm9MbnI0cFQ4VGxGVTc0aWg5eitYUkNSS0hCb3FaNStBVURLSXRMZGVK?=
 =?utf-8?B?UDE0czVJL0lNUG1GZzJRbzhxMlJCTG9vb3RoQTRNYTBaVXpSWVFEbVdXaC9T?=
 =?utf-8?B?NU9ZTk1xMVlWQkNyaWdlSHNTUGgwWkhrUGd2N1FtKzlqVGY2cjdSV1MxdEND?=
 =?utf-8?B?bVI4U0hnOXFHLy9qOTNzWncxbVFKUFIzU0ZzTjg1RXZSKzZ4aDVPUmRXKzc4?=
 =?utf-8?B?QlBKeFZPbThiZnB0c01CNSszQjJRbWNma09EbWZYOThHTmh3VGFSY3ZHK1lt?=
 =?utf-8?B?allwc2RHL1J1STdiUHg1YWhEcVRYNnNmdXJTM3c2YW5FNDZTa0FUa2NIRUJI?=
 =?utf-8?B?Z3BUS1VTOUV4cWcvY1JhOEw0aUVBM3JmekpZSm15T3hrWnBkQTBpMEFCeHFW?=
 =?utf-8?B?N3pnOVBNWWpXQ3NvMUdyRTNteHNGZGdicU1aNmRVMTNEYkNQR1VtTFBlUDZH?=
 =?utf-8?B?a2pRTmwxRDB4K1RDQ3hXYzVtMjBJOWwyMUxiT0lINU15VUF2Y3l0RkRjTTVB?=
 =?utf-8?B?RWIzSDhLWGFUbXN6UldMNnlLOVdIOW1WaWVpK2x6a1hTMUZYV0VNeWxkeUJ2?=
 =?utf-8?B?dUwySzd1dktBTG5yQWxxay80TnhheDFFZmFrTWlsN2tBclVPdnBvbkdvRGFO?=
 =?utf-8?B?SzdVS1hxUm9GWStzMmFRbm04Qk9YQldiWHJuQUFNcmxHSXFEQ1Q5U2pnZDB4?=
 =?utf-8?B?MmdBQnUyaHd6dnF2NW1YUU9EU0tyWDhZb05Fb3piYXZ6OWRaSWNkQkFVM0M0?=
 =?utf-8?B?ZGdMNHVaR3MxUnpwK0NlczhJQ3dxRzl5c20xY2x0MmQ2eCtabGhHUTlObWZj?=
 =?utf-8?B?QzdBbXQxUTk0MG9QQ2xBaFd4SHJwa1NOTHdwMS8xek95TVU2QnN0Z2YrRERY?=
 =?utf-8?B?RWI5bGxWYlRvWFN6QTFRdEZJcDFzczVxSFRDSjg1TDRlZnNJVzFZa2tGZytm?=
 =?utf-8?B?dkJLU29LME9SNWRHbWNXbTdPVUoxTWhRRmwxWnJSOXVjenAwQVpVVm8yV3F1?=
 =?utf-8?B?azVsTnBNaGRCdWREOVdMN3NMcGdvY1ZZZ0VJNVlZZ2JOa2w5N1g1a3RFVHo3?=
 =?utf-8?B?ckxBQi9rdkZ1YVpVNDV0Y0VXcjRKb1A1VE1CbTdtQjlHZDFRTW01L0ZiRUFZ?=
 =?utf-8?B?TzQxekY0ZGpKeG1YR3FYamc5VUFLOG92NkJ0QWFReWdZVUt6TDV4Q3JpMEdE?=
 =?utf-8?B?S2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3D0AA9339A50E4BB7E66E37D94BCDE9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39831563-4cd1-4eda-f2c1-08dd86cf0dc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2025 03:36:40.3902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L8oPY6ovUr6Da4drbSrSM0EN3JVijwohbPxh/rqFojEpzbpf76f2OyXgmn0viw8Hr3qiKbgV+vpZXItgqBidygIuDdnGMytY0FRNaRtter0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8060
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA0LTI4IGF0IDIwOjIyIC0wNzAwLCBDaGFuZyBTLiBCYWUgd3JvdGU6DQo+
ID4gDQo+ID4gVGhpcyBwYXRjaCBhZGRzIHN0cnVjdCB2Y3B1X2ZwdV9jb25maWcsIHdpdGggbmV3
IGZpZWxkcyB1c2VyX3NpemUsDQo+ID4gdXNlcl9mZWF0dXJlcy4gVGhlbiB0aG9zZSBmaWVsZHMg
YXJlIHVzZWQgdG8gY29uZmlndXJlIHRoZSBndWVzdCBGUFUsIHdoZXJlDQo+ID4gdG9kYXkgaXQg
anVzdCB1c2VzIGZwdV91c2VyX2NmZy5kZWZhdWx0X2ZlYXR1cmVzLCBldGMuDQo+ID4gDQo+ID4g
S1ZNIGRvZXNuJ3QgcmVmZXIgdG8gYW55IG9mIHRob3NlIGZpZWxkcyBzcGVjaWZpY2FsbHksIGJ1
dCBzaW5jZSB0aGV5IGFyZQ0KPiA+IHVzZWQNCj4gPiB0byBjb25maWd1cmUgc3RydWN0IGZwdV9n
dWVzdCB0aGV5IGJlY29tZSBwYXJ0IG9mIEtWTSdzIHVBQkkuDQo+IA0KPiBUb2RheSwgZnB1X2Fs
bG9jX2d1ZXN0X2Zwc3RhdGUoKSAtPiBfX2Zwc3RhdGVfcmVzZXQoKSBzZXRzDQo+IHZjcHUtPmFy
Y2guZ3Vlc3RfZnB1LmZwc3RhdGUtPnVzZXJfeGZlYXR1cmVzIHVzaW5nIA0KPiBmcHVfdXNlcl9j
ZmcuZGVmYXVsdF9mZWF0dXJlcy4NCj4gDQo+IEFyZSB5b3UgcmVhbGx5IHNheWluZyB0aGF0IHN3
aXRjaGluZyB0aGlzIHRvIA0KPiBndWVzdF9kZWZhdWx0X2NmZy51c2VyX2ZlYXR1cmVzIHdvdWxk
IGNvbnN0aXR1dGUgYSB1QUJJIGNoYW5nZT8NCg0KSSdtIG5vdCBzYXlpbmcgdGhlcmUgaXMgYSB1
QUJJIGNoYW5nZS4uLiBJIGRvbid0IHNlZSBhIGNoYW5nZSBpbiB1QUJJLg0KDQo+ICBEbyB5b3Ug
DQo+IGNvbnNpZGVyIGZwdV91c2VyX2NmZy5kZWZhdWx0X2ZlYXR1cmVzIHRvIGJlIHBhcnQgb2Yg
dGhlIHVBQkkgb3IgDQo+IGFueXRoaW5nIGVsc2U/DQoNCktWTV9HRVRfWFNBVkUgaXMgcGFydCBv
ZiBLVk0ncyBBUEkuIEl0IHVzZXMgZmllbGRzIGNvbmZpZ3VyZWQgaW4gc3RydWN0DQpmcHVfZ3Vl
c3QuIElmIGZwdV91c2VyX2NmZy5kZWZhdWx0X2ZlYXR1cmVzIGNoYW5nZXMgdmFsdWUgKGluIHRo
ZSBjdXJyZW50IGNvZGUpDQppdCB3b3VsZCBjaGFuZ2UgS1ZNJ3MgdUFCSS4gQnV0IEknbSBzdGFy
dGluZyB0byBzdXNwZWN0IHdlIGFyZSB0YWxraW5nIHBhc3QgZWFjaA0Kb3RoZXIuDQoNCkl0IHNo
b3VsZCBiZSBzaW1wbGUuIFR3byBuZXcgY29uZmlndXJhdGlvbiBmaWVsZHMgYXJlIGFkZGVkIGlu
IHRoaXMgcGF0Y2ggdGhhdA0KbWF0Y2ggdGhlIGV4aXN0aW5nIGNvbmNlcHQgYW5kIHZhbHVlcyBv
ZiBleGlzdGluZyBjb25maWd1cmF0aW9ucyBmaWVsZHMuIFBlcg0KU2VhbiwgdGhlcmUgYXJlIG5v
IHBsYW5zIHRvIGhhdmUgdGhlbSBkaXZlcmdlLiBTbyB3aHkgYWRkIHRoZW0uIElmIGFueW9uZSBm
ZWVscw0Kc3Ryb25nbHksIEkgd29uJ3QgYXJndWUuIEJ1dCBJIHRoaW5rIHRoZXJlIGlzIGp1c3Qg
bWlzY29tbXVuaWNhdGlvbi4NCg==

