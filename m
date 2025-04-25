Return-Path: <kvm+bounces-44335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D18A9CDD1
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 18:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 930A94E00F1
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 16:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C709C18FDD5;
	Fri, 25 Apr 2025 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ntDRkPaF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357614C6D;
	Fri, 25 Apr 2025 16:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745597427; cv=fail; b=dYQgZU7PNLyKtPk1tszn6jmFqXktSIe5VDKQSeREn7gWteGoL9jXcdjW2U2peOOUjcnwmUItN706bKfUP/frl/1NQqglDSubhmNoS9+EIEiy1ewHHsth5303lFLIqT6FllLeJDcz1QgITrw/nlnmNNSNLj00NZu83sXvujaePe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745597427; c=relaxed/simple;
	bh=MSTwgkUdRyeShcQP6QMFByyY3k55aJ/x2ZcD9EGLO2k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kiYlxpEjAaldlV6LSUnBJlhHBLGKEEpCPVZXSe6xcHNVQwaHMGRodf4nVIK/O/co/S2e9wom+p+RKgFv4zEAUTlHnDPeJJS0PmDPPpst+8ZsMMHcMwWV6+atu8bYO4wmOtk8f1SKo2UpLQ0ehYOIzsCgvWcjiFJXcaFRsMWj7QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ntDRkPaF; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745597426; x=1777133426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MSTwgkUdRyeShcQP6QMFByyY3k55aJ/x2ZcD9EGLO2k=;
  b=ntDRkPaFu2cjQC1sb7t8O0OAsAtYRo3n2G3hZ+Boj+/steiP6aVsK0y1
   X69PECpXngOh9uSmhbRQZ0yrfZqjCEkgHeRnMH3huip/lMOrqNuW5CJ3H
   s7uxQ+W2aGsBYQDtBq0Xhbv/YRWIlHz159zs5myH85iiPG8YxHFI0noAc
   8C8jd/FrmJyyECpJhjB/17GpITKA6uHp/p6SgNODDi7JmRXhV79++uH5E
   mZa2M1NgLbdTA0p3JvUIUaazkKoAM0u9QgBe2kV1ZU00cMw31JgKKCaTr
   L2jsxuZH1KRsRQQGdHjXg7XcR14WmpxjHTSpJIzgGWZwveOcBuUjlLwgn
   A==;
X-CSE-ConnectionGUID: n+Z7CIVoQc6SDbgYT+O/Cw==
X-CSE-MsgGUID: K5CbPQmOSr6Q2Ie3/W3RPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11414"; a="58630244"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="58630244"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 09:09:35 -0700
X-CSE-ConnectionGUID: QqiC7jOMSxWZXvfb9QaYZg==
X-CSE-MsgGUID: eL0qluNST5qpqrlTc6WJbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="136992518"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 09:09:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 25 Apr 2025 09:09:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 25 Apr 2025 09:09:33 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 25 Apr 2025 09:09:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LoKtNVnAE1Q86hQZXR+8985c471m2KZlezabMRSizQdKcwaDAFO9aU7sKQjoRDpQgqOGoVmhpQJb8hVjTCyLpUbVVH2MG9hJMp3xh9RGzzaHkCOc8yRq4/jLTeWcHtQHbm/N9MW9IrV7UA+tumYdphudF8W0VtVWCuz6l77psyCq0UxGbyWIpM82YqI9S+MADeKY1NKehJOi9ex4jpeHZ22b0OJaT+XsGosk8TO0vhjp7nqYnbbl3Ev0Q7pQNGRytD0Eik9wt9j+NyrWD7d9pQUU9gQc83TsdfqZai1TYmg8guXMjizvM73fJxA77y3Q8EHkR99ZL/7nolCvzsc8aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSTwgkUdRyeShcQP6QMFByyY3k55aJ/x2ZcD9EGLO2k=;
 b=jtn9HSUjNDtubQWvdFHrgRNSgwvNZ7wDqtelmRjAOSrHA6EpMBleb23Dfv12SscFLqGNsKWFnWYBSHvYaMkRUodzdzvXvERZ7x0UTfuhrhrTniBEMU8TkEV2OBUQGnc8Se2scuv+DbDfsFMivPaKSZcA3ZxrzmfmQA4enZMOtp5w8r9E3dkqW0GyQleDtrnXef23osy/mAyf5dHE7DJJG/8u+aSFJ8k6yAlJNkY7LTbMd9ogDSLRHoppMCsPailQRDa9WXJCd1vx4l2UhFarcqMWrF1ZFcvwd/VXM0J8KGSUBxXbmbIG56IP2cdqCiSMKP53XmRsCY5ZuJs2uth+tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7505.namprd11.prod.outlook.com (2603:10b6:8:153::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.34; Fri, 25 Apr
 2025 16:09:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 16:09:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ebiggers@google.com"
	<ebiggers@google.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "john.allen@amd.com" <john.allen@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Bae, Chang Seok" <chang.seok.bae@intel.com>,
	"vigbalas@amd.com" <vigbalas@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de"
	<bp@alien8.de>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
Thread-Topic: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Thread-Index: AQHbqelZqhZU+Oq6j0yiouUZFd9/N7Ozg2wAgACfzYCAAIHMgA==
Date: Fri, 25 Apr 2025 16:09:29 +0000
Message-ID: <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-4-chao.gao@intel.com>
	 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
	 <aAtG13wd35yMNahd@intel.com>
In-Reply-To: <aAtG13wd35yMNahd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7505:EE_
x-ms-office365-filtering-correlation-id: e1556802-3fef-42aa-fa86-08dd84138f56
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cVdkbjE4L0RWdy9pM21GSEZHOE1jSVNXc1QwdlJwN3lKQ0wxVkVCTDlha3lC?=
 =?utf-8?B?a1k1djRyQUhGbFNmSGNzTXRZRVhjUjdValdLcnpXdCsrR0drRys2bWhkWVds?=
 =?utf-8?B?RDAyY1NITGZsYUNLTlo4bG5uMUlJZjNiQmdkcWw4MmoycTBZOXhjYmxBb05n?=
 =?utf-8?B?Um9oZ1A0NFMyYjVvTEwvRTZlUk9EanltYndtSEtEcE5NU05ZMXRhR0x0eTlC?=
 =?utf-8?B?RDgvNkJ2bmhTZHExdGEvUkhkTmZWZ01ZWE5oaDBnOGV1cHdsYk5EakR2Y2VR?=
 =?utf-8?B?eE1jQWRUS3U1dW81azBibTRLVDFKS2dDTzJOblJvUVlRcVBUbXhLVDQ0bEZC?=
 =?utf-8?B?RnpkNUxrYW9HTkQwckx2RHZqOEpVSDMzYWlRTnlxYXpWNzhlbGlCYm11cTQ0?=
 =?utf-8?B?cDkzdEFhcWJ5YURLaDI4YzJyZzNXQXFzTUVZY1VXVE5aaTErV2FuRDg1QXFs?=
 =?utf-8?B?R3IxWU9kbDFKSmlvVTJib00zc09NNlBMVU1CU1VxQlhHVzF2N3N0Q3NXTG1O?=
 =?utf-8?B?ODFUcEwvTEl1OU5PZjRWVGhoYlhrb3YyVklzV0EvaTUwU2s2SUo3SzZ5Nlpp?=
 =?utf-8?B?NmdsdGFBak9UZDVucnBpZzBRaFhRV0ZBbHRRSnpUOGczdnU1SnNxMk5aWUpP?=
 =?utf-8?B?Nzl1ZldUN245aEtHbFlmZlQ3R3FPSUtqRWsvQzZqUmJXMDNUdm5oUUNhQkV4?=
 =?utf-8?B?c2FrYjVzdVQreWNUUnFEVmcxdVU5QmpEdngwRExMSVVDbURzS2sxTGpnN2xz?=
 =?utf-8?B?b0N2VlVna1ErcmRnWTJ1anhDYXkrUWcxQWYzL0tTcXRrY1p0bTBEbFY5TUE3?=
 =?utf-8?B?aWtXRkozUmlZd2had3p5NnNMOXJERDBGV0NHbmhoQzZsWTROT3FGbXlJTGFW?=
 =?utf-8?B?KzhHMGRrclJiaDR6OHpiNkYrby9COHUyazVqUlpuLzArdE51bXBhUG1MYXVD?=
 =?utf-8?B?eXM2bUhpc1FGbmhZSFg0TkdmMEhjK2ZROXpjbUFsM09KaUNLTTJqTDd3Q256?=
 =?utf-8?B?YzNmTVAzZXhndzJqRTlMa25CUFhCZy9pL25HWUh5Q3VxNnJCTEZaZ1ZoL3hQ?=
 =?utf-8?B?K0dGRTQ2WmJNSks0YTNYaUs2Y0Q2aHQwMHpPREljbTFiZ1pGSWM2cjFNT21Z?=
 =?utf-8?B?UDJKWWlFNThpUE9ET0ptOC94eU9sY05WbEpIMmtUNFBhV0xsb1RzSkQwamE5?=
 =?utf-8?B?ajF0QlJZY3BSTUYxeEc2UUpFVkM2TU9RTEpNRVM3NUl3VnZTVUJFWVh3RDdr?=
 =?utf-8?B?cEErdTdlUEJKcWQzSGI1UmplaUplY0tkNVdQQkptc0ttVll1dUtpQ2UwVFVN?=
 =?utf-8?B?dWZlSE9PYUdaMlNpL3FyNEhzbGpocXNybHFidHRhZjVDTGRnc3daemFvc2RH?=
 =?utf-8?B?VFQ5ZWFoRi83WXo1T0dzc0p3clJxZnJaNTBFdC9EZTV4QmFoYWloQVcybXNS?=
 =?utf-8?B?THJOTFhNVTRGTHl1L0JmY0xoMDVwS0hObGxlT24vTXBuUFErZy9kMjJjTVp4?=
 =?utf-8?B?Q2E4aVU3cW0rSVR3VlZGcXZ6Vy9RRU4rSFRtOVJyLytGdE4xNTNFZ3pEOEZI?=
 =?utf-8?B?L1Y5Kys4cHU0Ni9KZllqS3pIZHd0WkU3dk5WVzZlUFdrQldpQ1NpVndoNTNS?=
 =?utf-8?B?dlQ0VWRoY0RaUW5sSWNUZjNWYk1pcUZ5bWNVd2FNQnJscGhzUVFhRGRuQktm?=
 =?utf-8?B?bEtXN3Z3NDhSb3RKamRlMFoxSWJGWHlORTBZWFJvUTNvMk5YWlNtY2Q4UTA5?=
 =?utf-8?B?TGlDRWJWanFuZ3orZ1lWZTFYblZRa1V2VlhIdmdwM09MQUxzNVFyL2NiekZH?=
 =?utf-8?B?elNoWGdwa3lWWUdKakdOWkdRT3EzWWZETEs2Z0JDMG1lVUNXNGVxZFZCUEdx?=
 =?utf-8?B?c3lRaG5Pb1o5OFlJNmhzTXN3aEhSZWhXejU0Q3hHeThXR2k5aEh0M01DR2xh?=
 =?utf-8?B?Y0JhSUpickl4WCtVcHowbUxxK2hlbnBJZjJNNVB0K2RpYTdhVms2UmpnTndH?=
 =?utf-8?B?dU9MQlJPRkpBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnFGbk1xMndXSzBObkFZVE5XUGhXK2Z3RVNPMU5yTStDbDNrRS9NUVQ5MDlU?=
 =?utf-8?B?bXFLdENnZTY4NzdhcHErVFRrOXJpdWhHQ0NZdEZWMTYxTkpRNmF5TVZzQWFs?=
 =?utf-8?B?TmN0ZTdJaHN3d2FsNGNzUlpSb0ExQjI0SUkvVHo0WGNySGIwRnpQbUZjNk5w?=
 =?utf-8?B?c3FDbUFmWW8rZDBZTjg1bWZFK2dDVzdRek9POTNmNmNqZ2dIQWdpZjNNTEVN?=
 =?utf-8?B?RitLSjcwOTBrbWlSbjByelMxNFpIWFNzV0xWQ1R3U244THo4K2F3cFZqTWNC?=
 =?utf-8?B?M3A1ZVU4NTl2cEVqK2hDNHA0cEVNZWs0czY5c2k2N3J0bnF0SVFRWHBoc09y?=
 =?utf-8?B?aHhNUU9Wd0ZqQ1RWUTNzRE5WWWlXRHJQL0NKQWM0SjhLVno5NFhIVEducG1I?=
 =?utf-8?B?Z210R1FBeUd0T1FRQmpnWVpFRVRQRFNZMXdmaWVCb0pQSVc3d3IwZkR0bGFr?=
 =?utf-8?B?RUJMTStkWGU2Zm5TNEdkY1AxMUI4eUFQa201cFFCVm9LSk1ONnIvdUk5cFEz?=
 =?utf-8?B?UlpManptRUNoYStQMUlkdGlhcmc1V0l4WjlPQyt4VUx2ek9RM09LK0ZPa2lH?=
 =?utf-8?B?ajNTY1VXTUxWWW1iM01xRFBPeEFKcUxvYzd4MFEzcjloOXZzcnV1Smt3Yksr?=
 =?utf-8?B?aldWU3pTN1NsQ1J5c2dIMmphN1ZHbWs3RlEvLzdta0g0bXl4aC9leGJjOEpS?=
 =?utf-8?B?ZTUyMjhiRkR1VGtWK3BYZVlWRTFWSG9GUVNaRFNhZ0l5cWtEZWxFMWoxaDl5?=
 =?utf-8?B?QnRIbmg4c2I4YXVtYk5wOWNORVVCenkxNXU1cnVVdmRqa0tlc2dOdjFUYW1G?=
 =?utf-8?B?bGlvbEMyT2tDM2xqditwajhFalRON3F6RmdRUEFRTE1lOVhTbk50c3N4MUxH?=
 =?utf-8?B?ZFQzdkRwbWd0TkxhdTRFY256TFp4RkE5cEtNMmhXdklkc1lScWZZd0N1aXAx?=
 =?utf-8?B?V1lqRzJyK3IySG9MRit5TWFsZjFzVkZoYVIvVXlGRDNFQVkwWmN3WTN4UXlO?=
 =?utf-8?B?ZmVvS1c0TmQyTGo0QyszMXQzS0tWbDNhWDJJazhZb0sxMURpOCt2L2I3TGM5?=
 =?utf-8?B?OEUyL1RJVkM0QUVCek9Qa0tZZDYzanlna0c2QzNDSzE4WWNFVFEwQWQ4cWdI?=
 =?utf-8?B?OUc4ZXZmV01uOWFGZklxSmdvallKKzhxL3JOS3l5TjczMmFEeFhaT1VJRS8z?=
 =?utf-8?B?cG9sOERKbnN3U245MStiWmRKVnQvRG5UenVhQUlVc2dvckJhL1lxMkVSM3Ba?=
 =?utf-8?B?YTREaDJVMUtDSjdHdWJqVmdGMDhZLzZvVW5CWktmSnlEZldDdDZ1b2ZpOTBB?=
 =?utf-8?B?NUc0WHg4YnpnUG5iZVp4elk3Sm9hRTVKL1Q5R2tUWUtrY2ZXd3ZGWVhjaE1Q?=
 =?utf-8?B?ZnczT2JwUVhoTXpDWkd6SDBqVG45RHl2WW9zYm4ydEdyWDZ1M3pnQ1UyRzR0?=
 =?utf-8?B?bkJyTk9ZYlZmWjdTdW1kMGFPcjRldTVndk52dDFPcVlTeHlJeVptdXdzTklE?=
 =?utf-8?B?MEt6Y1d6alFRcm1jemxGT0JraGJnMEh3MndMT3NFaXdFeTdQNlU3eitKYnlG?=
 =?utf-8?B?MGtDOG0wcGFnUUxLdzl2QjQ1SDVrV0dKd0g3MU56Nml5ZmhwTW0wR2VRcm1L?=
 =?utf-8?B?OW9jOHhaMWNMQ3BOeE0rdFNuRm1BVEExQ1ZwRDdiRVcrNFl0czNPcTlCNmV5?=
 =?utf-8?B?dzVKSEJ4dHBablJXVm5WZjJDR2hpeXVVTWhPUU13Zk1OTEsvTWpwWktaSG8y?=
 =?utf-8?B?SDVRbkRiWXl1cXdUYndQZE0ydnJWbWVPSGIrbDZab2I3TDZvUWlJT3FoNWZD?=
 =?utf-8?B?K2JIYU1QRC9MYXI3V1RlZjd1OXlNb1lQMnZCVW15WUlEZ2c2UHNXUzlKd21t?=
 =?utf-8?B?bEI3UkJ6cVd5bGZsUE1YczdmZmI4c2gvYkRaQjR1aHFFQUhONVdvQm0rTms4?=
 =?utf-8?B?Qk8rMzdvOEpKU2F4YzRsQlp3Sk83ZFVtTzJZc3hlUlZLSm9rSkNEMEtXZzhp?=
 =?utf-8?B?VVlnTTF0N2tXei9rQlRBalJ4ajlTTXFyam5CSDNpclZKcmY4NDlnYnQ2OHpI?=
 =?utf-8?B?czRXOEpkbTlwdHRvQi9SbGdmc2ZJMU4wN3BLK2pCL2Q3ZHVwWVVrZEhoRkhx?=
 =?utf-8?B?ZVl4a2U2LzFldElydDA4azB2ZmhzL2IzMCs4Qm1Ub0RhRzg2Sy9LWHNhZFNW?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3A4226136F2E74B9885D386E3C7D2DB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1556802-3fef-42aa-fa86-08dd84138f56
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 16:09:30.0182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4gfLWGBniSgWCf9tu1rVG+qmobQsqPqpRD0NE3YUAdvlRbQVSkDR68Mix9kBaGKQN7VLo8kHjYMf2uePcms+jdk3htsStpBibMUfV5FX6fU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7505
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA0LTI1IGF0IDE2OjI0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAN
Cj4gPiBJbiB0aGUgbGF0ZXIgcGF0Y2hlcywgaXQgZG9lc24ndCBzZWVtIHRvIGNoYW5nZSB0aGUg
InVzZXIiIHBhcnRzLiBUaGVzZQ0KPiA+IGNvbmZpZ3VyYXRpb25zIGVuZCB1cCBjb250cm9sbGlu
ZyB0aGUgZGVmYXVsdCBzaXplIGFuZCBmZWF0dXJlcyB0aGF0IGdldHMNCj4gPiBjb3BpZWQNCj4g
PiB0byB1c2Vyc3BhY2UgaW4gS1ZNX1NFVF9YU0FWRS4gSSBndWVzcyB0b2RheSB0aGVyZSBpcyBv
bmx5IG9uZSBkZWZhdWx0IHNpemUNCj4gPiBhbmQNCj4gPiBmZWF0dXJlIHNldCBmb3IgeHN0YXRl
IGNvcGllZCB0byB1c2Vyc3BhY2UuwqBUaGUgc3VnZ2VzdGlvbiBmcm9tIENoYW5nIHdhcw0KPiA+
IHRoYXQNCj4gPiBpdCBtYWtlcyB0aGUgY29kZSBtb3JlIHJlYWRhYmxlLCBidXQgaXQgc2VlbXMg
bGlrZSBpdCBhbHNvIGJyZWFrcyBhcGFydCBhDQo+ID4gdW5pZmllZCBjb25jZXB0IGZvciBubyBm
dW5jdGlvbmFsIGJlbmVmaXQuDQo+IA0KPiBJbiB0aGUgZnV0dXJlLCB0aGUgZmVhdHVyZSBhbmQg
c2l6ZSBvZiB0aGUgdUFCSSBidWZmZXIgZm9yIGd1ZXN0IEZQVXMgbWF5DQo+IGRpZmZlciBmcm9t
IHRob3NlIG9mIG5vbi1ndWVzdCBGUFVzLiBTZWFuIHJlamVjdGVkIHRoZSBpZGVhIG9mDQo+IHNh
dmluZy9yZXN0b3JpbmcNCj4gQ0VUX1MgeHN0YXRlIGluIEtWTSBwYXJ0bHkgYmVjYXVzZToNCj4g
DQo+IMKgOkVzcGVjaWFsbHkgYmVjYXVzZSBhbm90aGVyIGJpZyBuZWdhdGl2ZSBpcyB0aGF0IG5v
dCB1dGlsaXppbmcgWFNUQVRFIGJsZWVkcw0KPiBpbnRvDQo+IMKgOktWTSdzIEFCSS7CoCBVc2Vy
c3BhY2UgaGFzIHRvIGJlIHRvbGQgdG8gbWFudWFsbHkgc2F2ZStyZXN0b3JlIE1TUnMgaW5zdGVh
ZA0KPiBvZiBqdXN0DQo+IMKgOmxldHRpbmcgS1ZNX3tHLFN9RVRfWFNBVkUgaGFuZGxlIHRoZSBz
dGF0ZS4NCg0KSG1tLCBpbnRlcmVzdGluZy4gSSBndWVzcyB0aGVyZSBhcmUgdHdvIHRoaW5ncy4N
CjEuIFNob3VsZCBDRVRfUyBiZSBwYXJ0IG9mIEtWTV9HRVRfWFNBVkUgaW5zdGVhZCBvZiB2aWEg
TVNScyBpb2N0bHM/IEl0IG5ldmVyDQp3YXMgaW4gdGhlIEtWTSBDRVQgcGF0Y2hlcy4NCjIuIEEg
ZmVhdHVyZSBtYXNrIGZhciBhd2F5IGluIHRoZSBGUFUgY29kZSBjb250cm9scyBLVk0ncyB4c2F2
ZSBBQkkuDQoNCkZvciAoMSksIGRvZXMgYW55IHVzZXJzcGFjZSBkZXBlbmQgb24gdGhlaXIgbm90
IGJlaW5nIHN1cGVydmlzb3IgZmVhdHVyZXM/IChpLmUuDQp0cmllcyB0byByZXN0b3JlIHRoZSBn
dWVzdCBGUFUgZm9yIGVtdWxhdGlvbiBvciBzb21ldGhpbmcpLiBUaGVyZSBwcm9iYWJseSBhcmUN
CnNvbWUgYWR2YW50YWdlcyB0byBrZWVwaW5nIHN1cGVydmlzb3IgZmVhdHVyZXMgb3V0IG9mIGl0
LCBvciBhdCBsZWFzdCBhIHNlcGFyYXRlDQppb2N0bC4gKDIpIGlzIGFuIGV4aXN0aW5nIHByb2Js
ZW0uIEJ1dCBpZiB3ZSB0aGluayBLVk0gc2hvdWxkIGhhdmUgaXRzIG93bg0KZmVhdHVyZSBzZXQg
b2YgYml0cyBmb3IgQUJJIHB1cnBvc2VzLCBpdCBzZWVtcyBsaWtlIG1heWJlIGl0IHNob3VsZCBo
YXZlIHNvbWUNCmRlZGljYXRlZCBjb25zaWRlcmF0aW9uLiANCg0KSSdkIHRoaW5rIHdlIHNob3Vs
ZCBub3QgdHJ5IHRvIGFkZHJlc3MgaXQgaW4gdGhpcyBzZXJpZXMuIExldCdzIHN0aWNrIHRvIHdo
YXQNCnRoZSBjdXJyZW50IENFVCBLVk0gc2VyaWVzIG5lZWRzLiBDaGFuZ2luZyBLVk1fR0VUX1hT
QVZFIGJlaGF2aW9yIG9yIGNsZWFudXANCmNvdWxkIGJlIGEgc2VwYXJhdGUgc2VyaWVzLg0KDQo+
IMKgIEFuZCB0aGF0IHdpbGwgY3JlYXRlIGEgYml0IG9mIGENCj4gwqA6c25hZnUgaWYgTGludXgg
ZG9lcyBnYWluIHN1cHBvcnQgZm9yIFNTUy4NCj4gDQo+ICo6IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2t2bS9aTTFqVjNVUEwwQU1wVkRJQGdvb2dsZS5jb20vDQoNCkkgY2hhdHRlZCB3aXRoIFhp
biBhYm91dCB0aGlzIGEgZmV3IHdlZWtzIGFnby4gSXQgc291bmRzIGxpa2UgRlJFRCBiYXJlIG1l
dGFsDQpTU1Mgd2lsbCBub3QgbmVlZCBDRVRfUyBzdGF0ZSwgYnV0IGl0IHdhc24ndCAxMDAlIGNs
ZWFyLg0KDQo+IA0K

