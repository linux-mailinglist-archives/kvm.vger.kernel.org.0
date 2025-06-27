Return-Path: <kvm+bounces-50931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1267AEAC32
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 03:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F6F41BC2D50
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 01:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339C3189BAC;
	Fri, 27 Jun 2025 01:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L4APy3x1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA74C78F2E;
	Fri, 27 Jun 2025 01:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750986427; cv=fail; b=aykQVpO8VhXf51nmv9BfnLEmU3CwyuVPy1x00QlqG1Sv2Zquvh7WA/JTsH28mD7YJgcLo2b+mzGWBrRcUdrhTXILJGQUxRUn6UDecE85ZmbF/BgIM94THemdBYH7MadcHxhhl6e40Mvsv4RXLVSW7n1XaZX3nXAzGMI3Y5dfm/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750986427; c=relaxed/simple;
	bh=hW2BqbsJ3UZHK4QQP00v+/5KCaxauYfsM6/ya774KOg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jrGZekjPBhZ2OtrJrrFXJjZgzrOsObfbbnDFE7/pLnmhOGCbOMzyual0AAciG9xznC8tfDYBp2aEVttgAL0/7fW/B8oLGYXXdg3yN8GtwVNBkPyBJgl1Syvx4cf88fk4g7si1xm00lNY4OD0Mc9H4qtZAor7mml3fOWvqBBf+1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L4APy3x1; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750986426; x=1782522426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hW2BqbsJ3UZHK4QQP00v+/5KCaxauYfsM6/ya774KOg=;
  b=L4APy3x15EHRCgrK95OKIvQ7EhPIAR3TYo2FluQLXtSmYfjODhJ91Ytw
   mJqM9KX7EvlzO0jB/99lvGcHz1z2Jewe3u4q7OAB5Yn5mTXAdUJ3NyyMF
   Z64ECSTOGx30QfKgk/yNPWAZiFJZkRsq1Wnc9T5ZwVH3ayYM/2UfMFFE0
   fdLD7ybGQ8NvQO0C/WMR9RS1sVrJBxg6Hmk4534JRLjYTDj/tDvqbjY80
   WLlgUKiR3xLuLJM6hbB0kOUQ1+Ps6q5JnXWxAs+o971I4oeRp6qbzodtu
   Grrc0zZwFQg9miojuS4DeyBo31L6o0FD1BSRQ4clgjTBPtqayjPw7bgck
   g==;
X-CSE-ConnectionGUID: lPm56QrwT1y1pfUpFbbBxQ==
X-CSE-MsgGUID: fDyqxEMJRse7bpjzYWVl5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="64735419"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="64735419"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 18:07:06 -0700
X-CSE-ConnectionGUID: L8R2hB2/TXOrtquPoDLPvw==
X-CSE-MsgGUID: zFEzYAJfQ0yNl+K+C9kThw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="157060226"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 18:07:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 18:07:04 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 18:07:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.54)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 18:07:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mje7h5AccbKLr3lT0yiCxwfozjlIyG5QU6l4RPpcQobNmOhlrlH/xim/bb9bozk0qB2ROQgNenlaJQFJmi/QhMUIsrtyJ9BUly1DPKm0KIdfV2SSsQiIG27XsdsMd2A0w+8ar+JH2iMP4Ys+GW+LM+pFEsvv1oFcoJKNACYCNCdjEeBmFxzAWES2A9g/d7EHwKBiROj4xfKzx6lUlY4pS0Gz8tGMw5hvMzOCQluuA11nT5GkwYpUGH7TabUISYxcrgTdI8SL5X+jBJqLfGalxVH8/Fgc3zgPFGoIoberUwwR6JTy1zelPeUw2b5wIh+bdx9CIBhmBFALy5erNcjG7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW2BqbsJ3UZHK4QQP00v+/5KCaxauYfsM6/ya774KOg=;
 b=SzFZQtGPfXmeZg40JIU04pgDeOc2M8xH3GtQs2/Y0AQiswJ/HqVVISD3Q1BfSDJDC59V1ZgCLfRvRwqdfngCv6on8rAH02o733KFnytHG1nBVfxk5Dzh5luteUwnODe1+ZGsHngA3Vw9tPrMQBWeFBydJxJr/1Pl0N+YlsuyE50E/+53UDubKuZsjDNJdIRMBaSBAguvnxjNiAicEyCInGyVndw4AfCHjDVq7mR17VcuuUpqiNCx87ihmNLgxvMpicwjE2GPD9iQrtkx8g92FB/eKsGA1r3wPYSegKwamdJyo+v9wskYZ+CW06uLXCZgUFNQvp44IFyaE/VQS43+Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA3PR11MB7609.namprd11.prod.outlook.com (2603:10b6:806:319::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.22; Fri, 27 Jun
 2025 01:06:44 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 01:06:44 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ob1Aej6jhsWsE288GxQicmcLLQVuwOAgABvTgCAAAChgIAAB3iA
Date: Fri, 27 Jun 2025 01:06:44 +0000
Message-ID: <96c39744eacd6d670b1559268137d56c381d84ab.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
		 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
		 <ffcb59ff61de9b3189cf1f1cc2f331c5d0b54170.camel@intel.com>
		 <065b56f9743a18aa1866153a146a18b46df9ef8f.camel@intel.com>
	 <4b752f2bd492be6deaa681f04303cdb57d2a3c91.camel@intel.com>
In-Reply-To: <4b752f2bd492be6deaa681f04303cdb57d2a3c91.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA3PR11MB7609:EE_
x-ms-office365-filtering-correlation-id: ab798b15-4ab1-4172-1c8e-08ddb516e1f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?UDltMXR5N1diektUeVRYWEpHd0pKMm42WVVKRDFMbXBZblR5Q0p5clVPUHZB?=
 =?utf-8?B?YVhpNjVEaHdWRzdtSWlVaTN1dHQwL0dWeFJRYmYwRVZVdEUyNjRWZjhYY1Q5?=
 =?utf-8?B?Rm9zZFlTZ3NHZWk2TDl4d0x6dVFZQW53ZEZ4bktGYm1YWEdHbmlyN1NuWFdB?=
 =?utf-8?B?bloybTFoTjM5NWhISmU3ajJMQS8yOTM4akpuRXU5NzNZR2tSWUlWTFFyNlJw?=
 =?utf-8?B?OHNPZkhPOC9ucXRnRXlTNjZCdGZzUFEwZ1JDRzF3ZWVGaW01cStRUE1vOGxM?=
 =?utf-8?B?R1lZY1ZXNnJZbmdVWGJmSnByMjBPYnp5UTV1NS9WYllXcHcyc0xHbU9KblM5?=
 =?utf-8?B?b1pWc1ZhOFAyQ0gxYk9QYUgzbkxKOTZKZGxxY0N2Nk41eldqRXk2cDh1blhE?=
 =?utf-8?B?djU3K1M0L0tRYWdLUEc4N05JdW5uZk5jRjRURnkyZzZEaWNJMUxwZjJ6bTZZ?=
 =?utf-8?B?VjRvbU83enI3QXVKSlczb05rK0ZpcjMvT09qd3FZL2FOV2ZWZ2hFMTVoNlY1?=
 =?utf-8?B?UitoYkwrVjdrOW5LYWovbzNqSHpaMmRRcGx1VUVMMzZaa1RlK3FEeXdvT0xU?=
 =?utf-8?B?eE1RYklBWXVrcXFNSTJTME9mT3pNbnZ3UEtWQU1hNlBxdEdDeHpwVnpXOERX?=
 =?utf-8?B?SEg3R0F0YTBwalp5ZVdyNGpQVk1UR0cxMXQ1ZU9qNk1GRWh2d1Q0OWJUbDJO?=
 =?utf-8?B?d0xMT2MzeUcwWGlPSVFHbE5CdFZBTEdUd0NVZm8rTVhIY3dJT0o2TllkQURY?=
 =?utf-8?B?T2JPQk54LzFkdUNRcXFBdWxvcGNWV3hwZ1lqSnkyOUNiQnlWSkdKemdDcFBW?=
 =?utf-8?B?NUVZOTF4K29SRVErN01NTDFOK0I0cFdmWi9SOEtEWDllVklGd3BQaFJXQyt5?=
 =?utf-8?B?WFVSYlczM0U5dVVVd2pWVG9oMEZ6YmxqM001K21oLytuRzAyTGVoaW5DUXQ3?=
 =?utf-8?B?MHdUTklqMmJRZ0ZiMmFST2R5bHk1TTU3MjV6Wkx3R3BaNXhEbEZwUGF5RVEw?=
 =?utf-8?B?QURNTTRlMkJaNXdJRzBQOHluZVFQc25HRXpaN09LRTNxZWN3c2Erb0lpLzdI?=
 =?utf-8?B?aVh2M2wzREFOcVNybEd0VXpXNmg3NC9pamx0SUJnQTRqNWxRYUZGcTMwOEh1?=
 =?utf-8?B?bndpbXg2VVlsbHhmbU5nSUhJc0drZ2x6azBQTG5tUWpuWFNSejVxN3RPTUtw?=
 =?utf-8?B?VU1YU3NqOUdLeVpYWCtjL2hZT2hDNXR0b0pkaHI0dXpzU1dhOWgwb2VyeGND?=
 =?utf-8?B?T3pIcXlnMGpoZUtVbHp6R3F4dGNHY0dlT2d3cHZPWkIyb3BHNEdzaW5IdFd2?=
 =?utf-8?B?RjdkUU1QdXMyTDJHbE9YRGNHUXk1M0d2ejZJMjh4Wjk3ZE05d1VGdU5GdTBu?=
 =?utf-8?B?YWtXQmF3U0piL0JnVFdNQTIxWlVUVjJST041ZHdzelNtVDMrYmsyS3JhNFVJ?=
 =?utf-8?B?SWNMSGRFNXRLWkFCdk0ycFdxVHFieHFib1drbzdHNkhFM0lKdGZ6NlJod1NE?=
 =?utf-8?B?OWlPV3EvbnRIV1lHRWQzeEQ2b1lrM0Q0Q1oxWE9LbkxjNWxETUZjeXJYalBT?=
 =?utf-8?B?ZEY5NElGZTlYVGlWZVFGT3hLZHlkdEhlc0JTR24vOVN6NUx0WmJNOUJ1ekVy?=
 =?utf-8?B?b3h4eWdFWElyZHN5YmpTbFkvYnUydHlYR0dMSEM3ekwzTFJWQjlOdG1rRy9H?=
 =?utf-8?B?ak83OTNTQ1FyY3AzTTJzZ2Z3L3JjTTFUSkJ0dmF5WTRuWksxV2FwSzZVZ3d4?=
 =?utf-8?B?eExad2UwTWN2dXlTVTRiYzYwdFRpQXdsZDgzZVQ3YnZVR2tGRGFVWDNtWWZO?=
 =?utf-8?B?QWliMWJMVUd3WHhPeU9PZVd6NTJPa0plVjFZZ0NkcTNCMTVWZUFud3pYWVZi?=
 =?utf-8?B?MmZhaDd2RUtXNGlkUDlwRGNJUlhnd3JEcWhUTC9zT2RYZXQyWEJnVUlmd0lq?=
 =?utf-8?B?bmdqakdjaHVoTDVnd3kxTlNKeG5YRzlSSm1hUTFJN0NySHcwbmh5N0MrQWd3?=
 =?utf-8?Q?6rzss0CHx6pV9314TyYJSaxdkY16oA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Lzh1TktvcWJqNHl1ZHNBL1hxYlNmRW0rMzZ5N3ZIY2pPYXhGcHZiMHJyL3ZE?=
 =?utf-8?B?Slo3NEMwT3pjZTV6Sk4vdXByRGZkQW5KUitiY0RsY1JkTUs0VDJRTUllSngr?=
 =?utf-8?B?bnd6SFEveTA4bVdiN1dhUDZQNUkrWjBqY1p6NHFZTW1Bc0h3MytmVEdDWXg1?=
 =?utf-8?B?dmhWdVFjZnVmNXNia3BucHhkQjYrcTdjc2RJOXlTa3dmYXdqWHlPWGxSV29v?=
 =?utf-8?B?OE1FU1FueXVORWE2dWx1dWN3MkYrcVd4OHVqcVkvem5weW5CZWhocENlNFVJ?=
 =?utf-8?B?RXNRWWhFdGVFWWFCSjNIU2Q2b1huZDliSU1xTFQxcjk4Ym1kTHFscHhlM08z?=
 =?utf-8?B?VmJWZjlBUGdNMEdSR2QrM2FxYXREaWRhZ2ViZUJDRlNYaGttQnQzYWhqTmFL?=
 =?utf-8?B?MDhaMEZuTXk4WlMyb09RclJxYnlNMTFoZlU2akpyTHJrQ2VtOGJWMzRGQzQv?=
 =?utf-8?B?TklvczZVc2JYQXBiRjhoU0RtZG5Dd2Qydjg4UmpsNFAwWlVnNm9NcEZUS1NS?=
 =?utf-8?B?T0VNOWhqa1J0blRJdzJIZy9ScWUwb3Y5VlFFMHo1d2J1eHpRcktnNUZHYzdH?=
 =?utf-8?B?M0JkMlBvZnExdlRaU2xhQnQ0ZmpVU25uQjRma2Y4Mnhpemt4Wm83RHdLZGZ0?=
 =?utf-8?B?NWFTbEhOck9OZDd3cXZPc0lza3JaZ0xYUzNhQVRMRldsRmd2ZyswKzMzcFUz?=
 =?utf-8?B?dkJ5SDZuUE1ZOFFhYzZTaUxyWnQwMUYrYnhqVHM0SUVJc3NsdWZqYWRwcEJO?=
 =?utf-8?B?ck5HQ1RiYnlaZUVpVnFVTU5ocm1zeUxtd0Y4T0JsUkM3VDhGd3Rzd1VLcTFu?=
 =?utf-8?B?L2dCa21tLy9Pa1Q4bGlJVHdhbXp3aGJjekUyOU81M3ZVVytSQjg5SUI4M2Ja?=
 =?utf-8?B?cHVJZlJwb1k5Y285dnRVTE9DQU1vaU5YMlY3d2Q0MGMydCtoVWJyNXhIZml6?=
 =?utf-8?B?dmpVS3p0eVJGWnFTTlRGWlAvQW96ZmdybkF2QzZYZ3lCSWF4UVlZL2VhM3gx?=
 =?utf-8?B?V0hWem5JeXRNVlhjQjhKYmxMTEk1c1ZDUzBiaDkvc3M0YkdwbGtYMTJGbVE5?=
 =?utf-8?B?ZkM4cWJ5QlV3alpYRUkyeGlmMjQzUWQ3NFpWUjN1OEw4WVk3NSsyU3VRYk85?=
 =?utf-8?B?VFRJY3lxR2JtNTYyUjNoZWtNZlNBYVhnQXFBbUdXWlVXMHhEMUluT2JNTXVU?=
 =?utf-8?B?KzVNQzFLTW1PYTBIbVdiQjErMld6RmJmTWFFeGFFeGRna0M1K05xYmVYSlJM?=
 =?utf-8?B?RGJaV3duSlhORUROeUZDUkNZNjUwTmVxSG1FUXZmZXZJZ0xJMTRWekIrUTNE?=
 =?utf-8?B?Y244U2daSlRqZ2U0RHF6K1lvK3ZveEhndkZwM2RZWWRtZzJOTWFtQkdaZnpK?=
 =?utf-8?B?MWxIRndobjdseXl2ZnA0WEFZeENvenJHZWNiRXYwdG9pK0VDa055cXFuQXd0?=
 =?utf-8?B?bHlQK0xlRXQ5ZEdGRENzczVlbDNVeUlQOXpPKzYrMGVnVDVRWFZxTjdvVm9k?=
 =?utf-8?B?aGN6aXdUQjI3ZVBQcldOZjZpV1BnVEtDb1hDcEJCNXRUUFdtNmgxR3RKY2Qz?=
 =?utf-8?B?Vy82NktmL0JzWjAvRG00VEY3ZlFEV3B0Ni9aQ1lVNUtvRHhoVG5RVnBuYkUv?=
 =?utf-8?B?QXhCdkpVMUxjNzZGT0E4TS93STlnZWl3eCtXd21VNEF4NElpQlU3RjRVT0p2?=
 =?utf-8?B?alMzcWUyamtSRVJUSmovVFRRbFJCdU1GY3daZExmaUhnWE5mSnNWcVY3Tnd2?=
 =?utf-8?B?NWtIUUlyWi9tLzBzaVR0Q2VqWDBBQ1lwdkxCZ0JtdVFCZW5XY2d2NGRpZ0RL?=
 =?utf-8?B?N2tuMW1hMUN5bVc3cDdZS0xqNUswSklqVzMzanpReFM5bHFUbE1oYU0xcVN4?=
 =?utf-8?B?K3I2K2dnZWNUVW1RUERBOU1yWHNUTVhEbFpCQnBTUXhhZ2ZrWlJlMzQ0L1ZI?=
 =?utf-8?B?YTlxcVJZcmJ6ZkpwSFhYeFhmbWNMc0tkQjJ6WGt6eTIxalkyak0zZjFKVHNh?=
 =?utf-8?B?SDhLdVZyYVkrZEdWaDlBb2J1TVVuSXVFa053ZFdnNjV4ci9VVXlBSnNYd01w?=
 =?utf-8?B?VGVlZHdNQzhMKzI0bW1TUTF4N2dpQkFJZzlrVmZ2Q3p5NHkremFOS0lCTDhu?=
 =?utf-8?B?NXRIbitobDFhdWk3UGRRMXNFTFNkZHluamM1TTFRZ2owZnJETXpDZHRpQVRP?=
 =?utf-8?B?eUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C45998101952034EA9D2871C6B0289A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab798b15-4ab1-4172-1c8e-08ddb516e1f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 01:06:44.0979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HbzBUmCjYa3zT6X+Hv+bky3fN2A8hsjfbfJpuA68fGjsE/tNeTMCdUvRJb2+Gyi6fNKFu5r7A1qfn89HpmLlJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7609
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTI3IGF0IDAwOjM5ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gRnJpLCAyMDI1LTA2LTI3IGF0IDAwOjM3ICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+ID4gQXJndWFibHkgdGhlIHN1cHBvcnRlZC9lbmFibGVkIHBhcnQgY291bGQgYmUgbW92
ZWQgdG8gYSBzZXBhcmF0ZSBlYXJsaWVyDQo+ID4gPiBwYXRjaC4NCj4gPiA+IFRoZSBjb2RlIGNo
YW5nZSB3b3VsZCBqdXN0IGdldCBpbW1lZGlhdGVseSByZXBsYWNlZCwgYnV0IHRoZSBiZW5lZml0
IHdvdWxkDQo+ID4gPiBiZQ0KPiA+ID4gdGhhdCBhIGJpc2VjdCB3b3VsZCBzaG93IHdoaWNoIHBh
cnQgb2YgdGhlIGNoYW5nZSB3YXMgcmVzcG9uc2libGUuDQo+ID4gDQo+ID4gSSBhbSBub3QgYSBm
YW4gb2Ygc3BsaXR0aW5nIHRoZSBuZXcgdmFyaWFibGUgYW5kIHRoZSB1c2VyIGludG8gZGlmZmVy
ZW50DQo+ID4gcGF0Y2hlcywgYXMgbG9uZyBhcyB0aGUgcGF0Y2ggaXNuJ3QgdG9vIGJpZyB0byBy
ZXZpZXcuwqAgWW91IG5lZWQgdG8gcmV2aWV3DQo+ID4gdGhlbSB0b2dldGhlciBhbnl3YXkgSSB0
aGluaywgc28gYXJndWFibHkgcHV0dGluZyB0aGVtIHRvZ2V0aGVyIGlzIGVhc2llciB0bw0KPiA+
IHJldmlldy4NCj4gDQo+IEhvdyBhYm91dCBpZiBUb20gdGhpbmtzIHRoZXJlIGlzIGFueSByaXNr
LCB3ZSBjYW4gc3BsaXQgdGhlbSBmb3IgYmlzZWN0YWJpbGl0eQ0KPiBoZWxwLiBPdGhlcndpc2Ug
cmVkdWNlIHRoZSBjaHVybi4NCg0KU3VyZS4gIEJ1dCBJIGRvbid0IHVuZGVyc3RhbmQgaG93IHRo
aXMgY2FuIGltcGFjdCBiaXNlY3Q/DQoNCkxldCdzIGFzc3VtZSB3ZSBoYXZlIHBhdGNoIDEgdG8g
aW50cm9kdWNlIHRoZSBib29sZWFuIHcvbyB1c2VyLCBhbmQgcGF0Y2ggMg0KdG8gbW9kaWZ5IFNN
RSBjb2RlLiAgSWYgdGhlcmUncyBhbnkgaXNzdWUsIHRoZSBiaXNlY3Qgd2lsbCBwb2ludCB0byB0
aGUNCnBhdGNoIDIuICBJZiB3ZSBoYXZlIG9uZSBwYXRjaCB0aGVuIHRoZSBiaXNlY3Qgd2lsbCBw
b2ludCB0byB0aGlzIG9uZSBwYXRjaA0KdG9vLiAgSXMgdGhlcmUgYW55IGRpZmZlcmVuY2U/DQoN
ClRoZSBkb3duc2lkZSBvZiBzcGxpdHRpbmcgaW50byB0d28gcGF0Y2hlcyBpcyB3ZSBuZWVkIHRv
IG1ha2Ugc3VyZSB0aGVyZSdzDQpubyBidWlsZCB3YXJuaW5nIHdoZW4gaW50cm9kdWNpbmcgYSB2
YXJpYWJsZSB3L28gdXNlciwgZm9yIHdoaWNoIHdlIG1pZ2h0DQpuZWVkIHRvIGRvIGFkZGl0aW9u
YWwgdGhpbmdzIChlLmcuLCBpdCBoYXBwZW5zIHdoZW4gYWRkaW5nIGEgc3RhdGljIGZ1bmN0aW9u
DQp3L28gdXNlKS4NCg==

