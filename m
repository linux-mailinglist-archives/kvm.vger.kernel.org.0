Return-Path: <kvm+bounces-44584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F99A9F4C1
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 735F31790B3
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B1E25D54B;
	Mon, 28 Apr 2025 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dYIq9Nwd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4B3279357;
	Mon, 28 Apr 2025 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745854954; cv=fail; b=CUyGpYdW61CLJQZsa64HDXuGN//X35/93i1o3htvllpOwIJiPfktWeczba9JDhoao10R7hSW0OEpIVB8VOnx65+u6qwh2E3M80wPr73fA9BVHA1vWjG36Q8rGNizCykdaEx4WGKSOpzcTuQeL3RUdR41yC9WV/jUW65Qv2zdk78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745854954; c=relaxed/simple;
	bh=XfUFeVxlhJYUUO1k7vw42eJ0BB8p+aWYywr1ZDdwHGI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CCZOl5K2fPszR3WovhYPUaCl1fWkuJCfHLo+RwJcFftVWkwOD1RTY/U9CmFSKmDjcroaJxPpq/13kG7hwJigsWFlRtwu+JI069eJCZHC1AAszaawZVUGQFaUdo6oflTuJGVqCt9h+YwvWuSFgSV1yc4AGYvPnt3gol/OQRPZEXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dYIq9Nwd; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745854952; x=1777390952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XfUFeVxlhJYUUO1k7vw42eJ0BB8p+aWYywr1ZDdwHGI=;
  b=dYIq9NwdeWNpC5iim+dyEHlunikZx02VNLs+wCRUQybwSm7jROxDc8Ag
   aXhui2xD1O3Zj/vjSn00HhiQpHrYza9s9Rn+Hqk+M9Lfv2uDOsBXpz19D
   hywvXl7fKchbJWXVOjD8G5EYTYa7ZAHoUwOKuRIWk3zyhM++DRP7C7Rbo
   h2TVfm7WRa/5zT3RVZGUTJxwaB06k5bFcfxeer6v8gdi3JvR04zsnkbiH
   YLifq1jZM8m1VqELGz8YfDswpSYQE8ifUPHq9rrXvvexL/1DtZU0QGaiO
   ALYn95eRXdde0+BJCt7affp9BIhJUaQmZbSRR5Wme3mkaq3mBX9c8O/8u
   Q==;
X-CSE-ConnectionGUID: nd5YI6W+Sr+UEenF6vOlEw==
X-CSE-MsgGUID: kq1wTqQuS7OrY0SUBdXHSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="46568423"
X-IronPort-AV: E=Sophos;i="6.15,246,1739865600"; 
   d="scan'208";a="46568423"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 08:42:32 -0700
X-CSE-ConnectionGUID: hO2UkT4BRsqhyi3mwpn9Ag==
X-CSE-MsgGUID: a+CPAoKVTi6oarr9SYHluQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,246,1739865600"; 
   d="scan'208";a="137599912"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 08:42:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 08:42:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 08:42:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 08:42:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IaG4yp4J7f/2GX98ihWqKjmnaS6XhdFLwq1cPnbmD+5wRIFqfwj2nQRodqM6IQVF/t14eih+3wBNQAwaFwOM4+fZa/SAVdBbs+F17pBopmL/XjmKX1xmk0CmnNLLzhemnNwKgMqX9pAKwwrXmV6s2vD6fqIpvsktmo5gz1dN76U7G3SJvrShR/zWdhmDIycqhjRFQVAWf02J2eiJV5ls4ax61EnRQG7Ki02eEwf1sXHwPZUaxQGIwrX8QELRlFfIvVmzmLCnZU0pe/VW8WL8bGrhHcQTQOs3icFY43tGmzW3G3Mj0jQrx7lj+EwQVBjuuD4VT5P9I7wY90J6A91M/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XfUFeVxlhJYUUO1k7vw42eJ0BB8p+aWYywr1ZDdwHGI=;
 b=BEhLKiaejvDjpGTZ7CGYD1BpUD9x4KGSv7qwHFERX5rSvkA7qaBy2hnGnt2peAKbJuFIiAqIZNcOBmjXghbPZ5wydwk9GU0fwiG40dJJWCtNF4aEuHPHqmNT/uw2n24NHy5zvmSWcJOrPj834PpbFZhIBKoJpl9mRWyl0t/fQIHF2S/8AEVk/Hnmkkp/bzT/vXcC5ReEdT6arDBb9M30b4k+whP9gyuY9ASnECjYj9mZFXm0zO3sq9Y3Usaf/k5dHExuCn19VISDekJSGdKkUKVT6ZSIQLo4arAvD7XY91m76lSIagEIdwlX+HyqDvjZVIU4ZcCm3iINBdRLg1NLWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.22; Mon, 28 Apr
 2025 15:42:22 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%5]) with mapi id 15.20.8678.025; Mon, 28 Apr 2025
 15:42:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ebiggers@google.com"
	<ebiggers@google.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Bae, Chang Seok"
	<chang.seok.bae@intel.com>, "vigbalas@amd.com" <vigbalas@amd.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
Thread-Topic: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Thread-Index: AQHbqelZqhZU+Oq6j0yiouUZFd9/N7Ozg2wAgACfzYCAAIHMgIAAgC8AgAQvOgA=
Date: Mon, 28 Apr 2025 15:42:21 +0000
Message-ID: <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-4-chao.gao@intel.com>
	 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
	 <aAtG13wd35yMNahd@intel.com>
	 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
	 <aAwdQ759Y6V7SGhv@google.com>
In-Reply-To: <aAwdQ759Y6V7SGhv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|DS0PR11MB7925:EE_
x-ms-office365-filtering-correlation-id: 0fccc5ff-76fc-4e74-443b-08dd866b43e8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?amdmMUZDNEFKQkdCTFFCTy9ZSXdrckpsdTY4dWZJclBNd3NqWVVONUc4U3Nh?=
 =?utf-8?B?bW1zU1ArT2hLdUZ3aDVLRE9WTkVCdnpzNTV2MFREWVhjM0pLSW5NaFh6Vnoz?=
 =?utf-8?B?SmZoVGtIelh1dUMyVy92MGsyeTM4c2NNY2V2am55ZGNpS0Y5dTNvMkwreWFP?=
 =?utf-8?B?MTBQYzE1VzB3dlI2V3JnNUdWa1BiQldzVFdJY3ZPSkNOV0VWWDJQNzBRNlMz?=
 =?utf-8?B?b0NPUTVIUWtVV2tSbXpFMTIzVzZlNE1lR0k3bjlZTGFTL2x6WDRGR2V2VURX?=
 =?utf-8?B?Z3IrM1B4Mk53Wll4SDN4UHN4a1ZNNzl4QWl3UmM1aVo5WUNhL05hVXV2OTc1?=
 =?utf-8?B?Z1JPekt0U1VXOFhrQmZJOUMyZ1laQXlEclFaZlpzTVYyVXczZmtYZG12T0VF?=
 =?utf-8?B?TlI2QVhmZ3hHbW8wbEVaRE5SM3JSNklJa1RMY05xcWNrelYzdEtWTkdJYjhx?=
 =?utf-8?B?M29iOGNjU1NmK3Z3Y2t0dHhQa3NHajVCcVpuSDNiWXd5NmFGeFZ5NDV0V2pq?=
 =?utf-8?B?ODJmbnVXaUw4Yk5VOHZUZmN1QjRZU0dRNEtneVZiSUV0TTVyaVFaemdXZ1pJ?=
 =?utf-8?B?TmtuVjZRL1p3ZmdLWWtmcE1MektONllSSkFuTVNrTVNxaXBaQkhGRGpMejBJ?=
 =?utf-8?B?Mk1NcGlMMnNXajJTR2lJWjJMSUV2R3dud05DUG56N3pWQ0FnQ2YzcVR5NUNy?=
 =?utf-8?B?OXN2THJTZ2Z0SU9qbDB3VHByV1BJOHFuWEFMeXJqeTRHRW40SThqa2J6ZDkx?=
 =?utf-8?B?Vm5jZDBqeFloakV3TEFvSUdMbnZvc0hzelJId2lrTnZ1YWxQTGtUb0xQdWFr?=
 =?utf-8?B?bDE4Y1pyVlpUTHF5YkNuT08vSTkrRjdVZTAyTnN4Vnk1ZzdkU2MrRFZ5MFZp?=
 =?utf-8?B?cXFhRWJIdDdkRTZqK1V5Z0xNQmRwdWh5WktBNUR5VHdiMDc4WnhnUjQxenJO?=
 =?utf-8?B?RmJIcnViWGZRUHVWaUwwb1gxRXhDd0dUNW9jbEI3S0RiVHJ4QVIvZDJGVXRF?=
 =?utf-8?B?emJPZmc5Wm0zTDlzZWxwSGhiRnVUeitvdG1uUHJVekc2VUF5YVB5RndMUEx2?=
 =?utf-8?B?M0V1ZjR3WW4wV0Z3UU9xSFJFRHEyZWY4T21yNVlTSG1GREU1Q1BQU3FKUWlK?=
 =?utf-8?B?UmxnYWFaQW5na0JhNFlXYmVPWE0rc29majdvNlBLeGp0cDY5RFZZdmh5eW1o?=
 =?utf-8?B?aDliM210Ukl5SjIzV1h2SUlpUEFLOEV3WS8zdGplakxzQmZKNld0Z2RaOW9W?=
 =?utf-8?B?dUFmM1lQSEJxOXRlY2lJMG9ob09Kb2JOV29ZZituZURZN2FrcTduTGZMeGl5?=
 =?utf-8?B?bk9Vd2szMDdTSTEwakw5RWJ2TTVsMHBwaUdjY0ljbEhGelhvN2pXd2l5T3dm?=
 =?utf-8?B?QW0vWE13bnhDQ3FVOVJHYit0MklRNHVGbm9zUFA4YzQxQ1YySDhiMHpNVUxW?=
 =?utf-8?B?cGpJYjkva2RYbktBYjFMYWpaalpGTWc0ZS8yVUhVdlR1OTBtdXlDRGNWcGNS?=
 =?utf-8?B?RGZ1dzhkU0xSd1hvS0tmQnBNcFVCZHVxSUhoZ3ZYUFNQVW4yMFRTYy9MK2U4?=
 =?utf-8?B?c0g3RTIzSVh6RGRqL0svVUtUdHFHN1lXZWNLL01xR1VFOHM4bEFCbVZrbEov?=
 =?utf-8?B?bDRyYUJYM1BrcXQvcnIzWkI5a0c1L2tOdHFpbm5LMnp3RTZaVThJekpZUi9j?=
 =?utf-8?B?RVN2V0FKK1BrbHdZQm94Um94alRQbFJDWXdCeXJiZHVFTVdvTWJYbFBlUmlF?=
 =?utf-8?B?dGU1YUxuTjgraDlBZmdCQmNXM1U3R3N3N3ZWYWl4VEo3NTIwRXY3YlJEN1Ns?=
 =?utf-8?B?NGdLd1liY2ZjVENLREFxdHVDWHU1M2VkWm10ZHpjT1FkdEZIUWRxcWNPTmg5?=
 =?utf-8?B?THVPbFBXNUljdFVuV2Z5ZTQ1RHVMKzFxTDlLU05wRmIxMU95NHZwd0VmUjZy?=
 =?utf-8?B?Rmd4NmRvTytRbDdYb0hmNW9iTmYrZDltcUtraWEzbXpVQlp2ZWx1UTE0dE5u?=
 =?utf-8?B?bTlQUmdnMXJ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cStaTVJxdTdPZGhodE1wRHVxYWRyeGcyTlhDWWVpYXY0ZVZ3SG9RWW9QMjVD?=
 =?utf-8?B?UWNTb2VuVmlJSkhKQmJ4QzZmZzhSZHE0QWRBblhlZ2JMUXNxODQ0SUkybzF2?=
 =?utf-8?B?aXhBQm1Cc09PL1QrZGJ6a1lwa2RyWHphQjg1NUprdVd4V0g3ZmI3ZGNoV3Y0?=
 =?utf-8?B?R1laY1l0UDRkcEYvZlF3QlZnYXQ1ODk2eE0xSGZPYWZNQWZGQ1ArbTRUS0Q1?=
 =?utf-8?B?VEh6WlFWTGZaalpsRTFwQXFoTTFVZ25DdS8wcmVmRDVKR1p0bWdiNCtBL3lP?=
 =?utf-8?B?MEd0WWs3Z3FVMnVjaHc0ZStaTG44N2huc2VHUDR3OEdFUTJjVWs3WndEMktC?=
 =?utf-8?B?eHdJQklnM2RaT1A2U2ZFNUxNRThIdVgwRy9LRDJrT3A4WkxybFltRlNkTlpD?=
 =?utf-8?B?QUUwUEdvQkdBSlBsTE52dktrM2Q4SThwYmhnd2RQS0Z5bGxpN3h3TFZOMWl3?=
 =?utf-8?B?dnpmNENtMnNGbWZPSWpXdWc4eHJUcFQ2dkQyMDQ2QmpralBrRTAveUNFMXE5?=
 =?utf-8?B?WTd6YkFTMjlWM0hkQnArM01paVpibTBXd0hSTVZJK3hrSzdqZ3hzY3Y3cGVU?=
 =?utf-8?B?bHl3UjRLMnNqS2wvMUYxTFo0VGw0VUFRRE11QTZsSWNNVXRtQUFURm1xR3la?=
 =?utf-8?B?bHMzN3NYcjVzS1hTbjRvLzVVdkM4MXBNZ2Z0c1lyMWEybHFqYzZ0VndHM1cy?=
 =?utf-8?B?cDh5VGpxckxKMEtHSjBpU2NGRVkzY0ZQNkJQZEpJdndXUGkrN0JtVTdJcXVi?=
 =?utf-8?B?RGwxaVExaTZwakxSU1RMWkJna0RvZmpHN1FaY25lUFc0OEcvR3ZEdWMxZTUy?=
 =?utf-8?B?QzY4QzZLL1VEV0FYN3ZsbXFobzRQMUpMT3U1V0padGdSR0NZSGpIb2pEK2xy?=
 =?utf-8?B?SXFMNUI1N2ZBWUZpYytsU3pUZnhaMnY1R05HelpDWHBKcnZXTUxoUmFYTjM1?=
 =?utf-8?B?UDdtOGV1RDZoVWR0VndxSHZrMVRNcUUyUUtGSlZjK2twMHp1ZWFYSk1pcmJZ?=
 =?utf-8?B?SnNJSU0yUDUzVmZwMDhBWmdmajZBcWtJZXhMVlRqOWpWWnJBSlpmWThlcXV0?=
 =?utf-8?B?Rjl1ZmV4T2xjWXBORnJObGt0clFDR0Q5bzEvejUyUTFSekl6UUJUaHJTMGpF?=
 =?utf-8?B?YUozd2JEdzQ3THFPT0JnM3BqTHR6UVhBZnptdERJSzN3dXBFcUpyYk5nY09j?=
 =?utf-8?B?b1JtUEwvVEt5WlEzNjFicElReTFrZWRjRG9rZnZucUVQQzlmT21ySTBzU1RE?=
 =?utf-8?B?eEV3OHBLdkFqd2JONDBCWWdHUVRGaVAyNmlndGc2WHFNcEV1Zk9TZWRMSE12?=
 =?utf-8?B?cDh6YWlmL2hpMGdoMWwyTjFDcWY5cllSQ21tOE4rRU1xRFMrM2JsSFcwYzV4?=
 =?utf-8?B?ZzB2MXhIYmszSllvUG53OWEvWHBUQ0t5RDV4ZzZzWHBZcm82OTBOb3c2RnlE?=
 =?utf-8?B?M1F5SEpSSW9WWHlOekpsSGk2cTBTMEluNFNXRWluYWFneEhEZEd3enNyc0Ez?=
 =?utf-8?B?dTB3ZnhtTzNjNUt6Y29EODROb2xhMG1aOW5WUDgyUGJYSWgxbko4MmtzSFB2?=
 =?utf-8?B?Uy9nRDJ5cXRiaEt3QnV3dW1vUWdlWW45K3EyRVBPWi91ZS9HUEN0dXN5RFdC?=
 =?utf-8?B?TTRjUW1pempYSHlQc2EzL1drZVlpQS8reWc2RTc2ZExJblovd3dHWG9EOGdB?=
 =?utf-8?B?SGphQlBoY3ZuNW50TGR0OEhKRnZiZkI0WjEzQ0NnMDNOUzZZWjkvTkJiZ3Ra?=
 =?utf-8?B?L0RhRmgvOGV0MGxZRkFlR3Y2ZkpGNnZaZ2lLWE5Bd1dHM0FmN0k3a3llZFRV?=
 =?utf-8?B?K1ROTzgzUlBHT1ZkcTY4Y0FxOERYbDE5UjFpSElReWZCTHBkZ3NYVHlVOWpC?=
 =?utf-8?B?clRQN2poRWphZnBBazRqQlRFWXVhVVRoc1lxL2VtZFlMR1ZBSjF6V2orNURU?=
 =?utf-8?B?cEZaRHJwK254anRoeWYvbnY2dGlabVB3NzNQSkxSSEVBNHQ2VisybzQ4N0Zr?=
 =?utf-8?B?ek9aVTZzU3B4dG8yTHp0VW9saG1sY1lPdXIrWDhjdjR1L01RSjRiVVp5TTFU?=
 =?utf-8?B?TVFJV2lVeDZHVVZ5TmJKSXErL2VxTzFSSkJ1SG1mZ2pRd0Q4Yzk1V3daRFJk?=
 =?utf-8?B?OW51V2pYWWtLTVMrM2pqUlNWY2RUK2xSclZuZktWTlNrTHhDWXcySmhseG8y?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB1FCA746D478A44BB7848CECB5C0BC7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fccc5ff-76fc-4e74-443b-08dd866b43e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2025 15:42:21.4419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qe9zpmc/RHEwMO1VctK4mg78yehFwe9mo+MMhS8gHajl7F0n8In0gXcbtSfwr9qOHAF8PjtI84msEsz+lz1eXW1oB9QW6XHKv64b/az8d7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7925
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA0LTI1IGF0IDE2OjQ4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ICgyKSBpcyBhbiBleGlzdGluZyBwcm9ibGVtLiBCdXQgaWYgd2UgdGhpbmsgS1ZN
IHNob3VsZCBoYXZlIGl0cyBvd24NCj4gPiBmZWF0dXJlIHNldCBvZiBiaXRzIGZvciBBQkkgcHVy
cG9zZXMsIGl0IHNlZW1zIGxpa2UgbWF5YmUgaXQgc2hvdWxkIGhhdmUNCj4gPiBzb21lDQo+ID4g
ZGVkaWNhdGVkIGNvbnNpZGVyYXRpb24uIA0KPiANCj4gTmFoLCBkb24ndCBib3RoZXIuwqAgVGhl
IGtlcm5lbCBuZWVkcyB0byBzb2x2ZSB0aGUgZXhhY3Qgc2FtZSBwcm9ibGVtcyBmb3IgdGhlDQo+
IHNpZ25hbCBBQkksIEkgZG9uJ3Qgc2VlIGFueSByZWFzb24gdG8gZ2VuZXJhdGUgbW9yZSB3b3Jr
LsKgIEZyb20gYSB2YWxpZGF0aW9uDQo+IGNvdmVyYWdlIHBlcnNwZWN0aXZlLCBJIHNlZSBhIGxv
dCBvZiB2YWx1ZSBpbiBzaGFyZWQgY29kZS4NCg0KUmlnaHQsIHNvIHRoZXJlIHNob3VsZCBiZSBu
byBuZWVkIHRvIGtlZXAgYSBzZXBhcmF0ZSBmZWF0dXJlcyBhbmQgYnVmZmVyIHNpemUNCmZvciBL
Vk0ncyB4c2F2ZSBVQUJJLCBhcyB0aGlzIHBhdGNoIGRvZXMuIExldCdzIGp1c3QgbGVhdmUgaXQg
dXNpbmcgdGhlIGNvcmUNCmtlcm5lbHMgVUFCSSB2ZXJzaW9uLg0K

