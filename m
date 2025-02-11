Return-Path: <kvm+bounces-37768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F06A2FFE2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F60A165B20
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 01:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1DC15624D;
	Tue, 11 Feb 2025 01:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FoGztLPP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992C83C0B;
	Tue, 11 Feb 2025 01:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739235845; cv=fail; b=oqwH/LPhDG3AZVrlufFPKeucofIacaqoOBTjBLKIJvp8jNL4OsRu/e0B4kAwh0UcFahu1GM26G4FT75mCCX+qq76CMt2LOvAalJ0Pas37v3h3+mKkK/jpOdpCgwPneI7SW4AgjtzT4zi9flUacaEb8ZpuJeNKhzzRsrVlkojKN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739235845; c=relaxed/simple;
	bh=eNtzKwYnaiMewMoZK52C7QRVm6gg2OY+Y1PdS4TK4q8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BAjKZxBFKOvl2lBr3XVnhLLq3qHAsoB8bVTMdqCQY2+WLM5PuFB3R6cRUUySF6WPzMu75M8aHwm86hugCUMYcmfIz7IyXlrLKUguqEkCIcOFi1H27xj2L+cCaeRQFHrAUtBedNI1lxfu55hiTKobp8AuAVLB4Rm3PfL5uEibGvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FoGztLPP; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739235843; x=1770771843;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eNtzKwYnaiMewMoZK52C7QRVm6gg2OY+Y1PdS4TK4q8=;
  b=FoGztLPPgR2di41MuWE26XoAlYp34dS5raWeyG4b3hRcjo/5YOK/1DoZ
   s64a74QyhOhVwZzkcmvwuigXFsuaKnK+6tOkZGeBEqf0ML9lyMkFAA7cf
   TVU91eaBjWDJITCEy/+tvfjH2yl++1G34tRNjQyq8HJADyZBbq4LZx+IX
   z1uGbSLobC2jPzhsh84Kz91kU1pD2yWrA5K7DqwvmWCm+qdoUIBn6pCaJ
   dnpcr5QeWt7ookxh5BiLDmZLt1vhB8FtjdQiMKKqmXcBZ1b0Sfk8iGsG6
   MV2iC0wQU33B4GZ9JCNpX89AFpjcbxk7Or3n6I5Nt7HNXTq8LLSsV+BT3
   w==;
X-CSE-ConnectionGUID: EbEV3JoUQCyhSeuKkLSyCg==
X-CSE-MsgGUID: +5EooHw3QIil7fYbPRpj7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="39531523"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="39531523"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 17:04:02 -0800
X-CSE-ConnectionGUID: eEkxXi4QTo+0uCr+I7nI8g==
X-CSE-MsgGUID: ByHSeg6JTKasdPyrCUn76w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112329750"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Feb 2025 17:04:00 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Feb 2025 17:03:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Feb 2025 17:03:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Feb 2025 17:03:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJheClo4ASGvTEH6OfcXLJv40ZptwEByrqktWrBWAzgAjK6NoKSPc6gvgZV6RTqAhrLQiYzp+U4M5ZPy/ycInKKg8x9bOCAHdK5RMoYdy6FwHOUDLPqFY/ACDdMZyXEOKXZLPAcR5XCD7oQUGo+vQOBMwGkV2s6IDEziRR5w+xITxbmpKZALR4y+jXa5j0m93DKBiD0+EdRke5Eer5GGnT+M+xfTc+Dm8pntim2asmQjE26YcNN+qG53uIuqriFNKxvsaW11GPFpiQMaRBgywf0zS7vCMI92ogyoFII/y5RRz+Jp511WRhQ2yD9L17RL6QmtMQkvsmiKc0av1PRGmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNtzKwYnaiMewMoZK52C7QRVm6gg2OY+Y1PdS4TK4q8=;
 b=Ow4LhbikjPP/SQBg75I3AMvdVC1XUK6FtH6q4E2OzdZsEDmg6++doMqvfWuXi2rCWZpIJ11Zpr3yluYDenYDJ5sMM6DBhGWzrYUUZl9jbNur6mCSrrheh3Wu957cJXSICdj9ApVKGF2jAh+5No88C/kkPJxGdtRC/m2BpQ9sXX9AAaLZm0rTfjSpWtmjbmLaPoRuFt2v4ZtlpDSu/DZLULFdOJtT+IFpJZcwv0Hfb3VH+WObOV1wXZlxZzj4FI4fleOgXf2L8rF3WCTOojGOyi5MH2JXu8WBEABsCU3liZges2jrqggy5/EDqacogxlS29umFzRFMs+pck6V9TW9kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB8043.namprd11.prod.outlook.com (2603:10b6:806:2ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 01:03:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 01:03:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Thread-Topic: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Thread-Index: AQHbehfVHEczKAq3gEWCQe7SoPjvmbNBTTyA
Date: Tue, 11 Feb 2025 01:03:08 +0000
Message-ID: <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
In-Reply-To: <20250208105318.16861-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB8043:EE_
x-ms-office365-filtering-correlation-id: b122cdc9-804c-448c-00a8-08dd4a37d948
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V0JRc1R2bkcrU0lOU0tuMjcxcktGODhSMzd6Vi9LR0h3a2Zva1J4OTRaVU1V?=
 =?utf-8?B?OU9kaWYrRERxQ3kzZ3VlV3J5ZG83ZlZQMTVaUjZMSHA3NExnMW5Nb1E2V3do?=
 =?utf-8?B?NEZqUHo0NWR4ZnpwaVAzeGQwNzZCSko3NnhRbnJVZjd3VXVJbHYrb1ZiSjNs?=
 =?utf-8?B?TzBjVzRDeHNIZ01xUTFSNlloMG1BOVVTTjVIb1N1ZVUxa2lLQTJJSE85NXll?=
 =?utf-8?B?OFU1a05iRTZiQkRUcFc2UGt5OFZZcjN5SGdxVFB5SEdsdWE1QXdidFZQeGpM?=
 =?utf-8?B?NGIycmtUdHdLUlN2amp5a1MycUFnbnFMazVrZmdmbHdLL2hmM2wwLzViVGhG?=
 =?utf-8?B?YVJTWm1JZGlYQnJYNGloMmM3VTZ1amM2RjFRUWo0S29yS2RqV3RTN0ZaSmtK?=
 =?utf-8?B?SkJWYUpFL3BXK04zdWV4WjU0YVBVaDR3bi9GZjlOWTBQMDRYekJUNnRDMTl1?=
 =?utf-8?B?d2YrK3VRV2lRanI3RTNHMVNCb3lNcGc4MGFRU0VuWHMzWGxScEl4YTlzeGcz?=
 =?utf-8?B?OTdzOUd3RTF6NU1YL1BBam5jYS9WRS9uaG9iaGFIZElPRWFIWU84RlAxTEFW?=
 =?utf-8?B?dTRGUnY4UHZmZVVoRU1EZGYxeG9WSlZRaDFtckFYamlQa3JrbFpadlRmSlh1?=
 =?utf-8?B?SVJPbkh5RUpnREVpT3ZYc1ZpVGw4WjJ0ejJEcHJYdndyWHFGVTJ6LzdON0Ew?=
 =?utf-8?B?OGpIUWZWcmJlNXJHWE1nOHN3QUM5Q20vSVlnUWtXbEMxTjZEQmdCRUxxT0xZ?=
 =?utf-8?B?VU5LcWFVeW5IbGlCU3hXdS81eU83UVlKUE9NbWpMUnV4alFsRGVSYnRDK2Yy?=
 =?utf-8?B?T09YanN3bkQwUUxBN1IrVlZDbXU2K1k0bThCdkJWbEt6OG9wL2xkZVNhbnRQ?=
 =?utf-8?B?NDFnOG8wNm9mVTFYeHhRK0RHSitMRmxTWnZZODBFeG9XWlpjM01LT0FlYjJx?=
 =?utf-8?B?YW1Ud3VwOURHRWQwbjBiS0NSSHF2UmZrc2JSZ2tEQWYvcmpoQ1BvM1pZM2Zr?=
 =?utf-8?B?UkdkbWZtNEZ6aWpxNVArK2M2dk41TitSWElkbnQxaGhWSi85R0RVcGltd2pt?=
 =?utf-8?B?ZFdMKzViVnFwWjBLK1RTK2V0RFBjT3B5VkUwbUlHNjJvWlh4Mi9oaW9MVzVT?=
 =?utf-8?B?STBDQVVkOURKWFNSQTdKajFmTFFGRlpYeHpzY3ZnOFhzc1M1UWJoYnNZTmFR?=
 =?utf-8?B?cHNidi9lRXlqU1Jvclo5SDhlWCt4RG5MRnFLaXZkbWdaelJzdlBnMHpueW0v?=
 =?utf-8?B?RXlyREEyc1pJczFsZVY3aGFoVWozQkZLOENOeFFpcWFZUlUwYnpETytjcEhK?=
 =?utf-8?B?YzBlL0xaWlZsa0NvMFhPZ1MxdGlBU3lYaUtEeVdPZ3NieHIwZ2tocWtKeFNG?=
 =?utf-8?B?QjFrMGtaZVpCNGVib2dobFMrWmY4dmlpOXZPRjZkVWRnTXRzTjNJRHJ5bkNR?=
 =?utf-8?B?SUV2YmdBa0NLanpySWpPZUNKZGhkNU1aRUtVd1FWNm5FN0M2R2Z1TGJydk44?=
 =?utf-8?B?WWV3Ymt5QUZnM3IzSUd0d1R5WEhJZjJpcy9KTDlIZnZWb1dBeXdBNXFkbXlz?=
 =?utf-8?B?UHlQdEorUjZ3eENCUWNBWmFxNFZrRzJLMmR4bDYzZDRtWFFCZTE0T0ljTE9G?=
 =?utf-8?B?eXV4c0oxTjhRVlMzK3ppREQzSUhKVE9sK0pVK3IvNWhlQkZ1YkRFcy9tNlI3?=
 =?utf-8?B?SGdtWkZsOUFEd05LaWVSZHFiQThMY21oSVVJejlDb1BoR3JKZTh4NXgvS01N?=
 =?utf-8?B?NGo5dTFSMUJSWG11MkxZY2JjaFJsazFlSHp5bkkyVXh3eEVFY0JXb2lqNHVL?=
 =?utf-8?B?eTZWRlpEQ3VMRGo1UW5Pa1ZRdlUvY0NnaGZUUUE5Z093Q0l3R0p4VCtoUXRr?=
 =?utf-8?B?OWxTSlZZWHY3TlF0dUNsMTQrb3ZWYnc0RUh6Nk11dDYzZkF4SmFIWW5jOGYw?=
 =?utf-8?Q?Bt4uXYw8QbYshIjfhqXJMZnK8W1h3Yv7?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHU2WnhrU2xHdS9OclkzcTVOc1hmREk0RlZJQzJ3QThRNHlUcmN6cjBZNW5P?=
 =?utf-8?B?N2czVm9WWkl3RjJJeVYxZVlYMURjQkhvckU1ekg3R1R5SHFsS3UvOGF3ZHAz?=
 =?utf-8?B?WktvaVY1bHhtZmttc3BFVllaeVpST09QV3hIaEJ4L0YvUGVJa0ZwemtvRW1r?=
 =?utf-8?B?bURuV2lBMFRuek9LdGVlZk9LMjBSeFBEbml6OUNzTkRCQzhlaStnaUJFMkVO?=
 =?utf-8?B?YlJiL3VRT1NCTVJHdVpFNXlkcVNheWlXL2ZsYTEwWEJBSVZvR3doNlpXUm4y?=
 =?utf-8?B?VjZvQTlCZEpDU0RlVEx3TW5tR2VCeFdPVjA1RGtCQmFReks2eGc2akNSMXhG?=
 =?utf-8?B?SEZsb0xoTUZlY0tWcHBtUUxOM1hQZDZZakQ4czBkSXZiKzYyVmtWVVJ4bisy?=
 =?utf-8?B?MW5jdmhIK01sZGh1NUdyMlFuNzJlVHROSDZCSWVjczdmbnB1QTdESHJXWVZw?=
 =?utf-8?B?Y1JYVk5tRWpDRHBaRW1HVk9PYUwvY09tYTVzbkZsWmxyQXdDNzg5WUs4eXdI?=
 =?utf-8?B?MDc3cWVOS29FalZuNklSY0RyN1hDa1pZOVlteDdNR1JObXhZZWtod0FtWUx2?=
 =?utf-8?B?ODA3d0c5V1RTYkZIYzdPbnYzRmx6MlNaaTgrbzVUSTNvdnRSTlZJMk9oclN4?=
 =?utf-8?B?cE1HR0tPczJtVjZnckl2dFppUW95YkVVTzM2bm1RNlFUUFdXSGcyY3EzSVdt?=
 =?utf-8?B?dHV5RFhEK0ZYM2tNRWpCZSsvUnczbkh3Q3ZQTkhFbndwZzBhUVZiY3dod1Vu?=
 =?utf-8?B?Rk4zcnhBVGc2bDNaL0Qxa3F1L2p5cWxic2M5TEE3RENaeHR4OHc3K0d0eDdO?=
 =?utf-8?B?RXlIS3huSWpTTDFBU3JvSjdJMUY4QzhCU1pVZW5tcUowVEFUTkdqZ1BQOXg2?=
 =?utf-8?B?aC95ektWUUpmc0ZiWERqd05kTmM1MFZUWnQyOFRPQ1VRZGJBRDVYcXUrenZW?=
 =?utf-8?B?a3ROYytTRzhKV0dpbzlodEd2eEtrcUg5dEh0QnJlck5SaHBCTDg5SlF4ZmE1?=
 =?utf-8?B?amo3NkE1bG0yOEtLQ1NJYVY5VTNXV0ZNa1NNTlorazN0MWtia2R6Q01mWlBl?=
 =?utf-8?B?ZkYxa0lyV0FpdFRwNXl5VFZ1MUVwRlYxaEEyZFFlNXRIejBvMTRIQWlsa0t1?=
 =?utf-8?B?OEZGYW5xS1hwRWx4NVQ5NTdrdTVqNmRHdndnOVUxUDV4djM1cmVhS3I5VW40?=
 =?utf-8?B?U3ZOQ1FqVTZ4VW9Ic2huRUFIUExGbURlc1RJYmRldFRBcnJDK0hoeTF4aWxH?=
 =?utf-8?B?M2xibmVqdjQweVhvSzNBRlh6b0wxaE5SYnhMeUprOVBNVmNQLzJmRjhpKytN?=
 =?utf-8?B?N2dMNU9VWEo0cldhenFxQXA0SXRvYS9hVEhhVTM3c2Q1MDk5ZWlIczkzV1dr?=
 =?utf-8?B?dHdQOFZIeUtRVkJqOXI5L0owT21kRE1iNGtLNk83VXdZT3Zvd2VIRlNRMkEv?=
 =?utf-8?B?VW5Qanh3VG1jNFZHa1V1SitCNVpuWUxDdU15RjAwZlJNRWpGa0Vac3NzYTdl?=
 =?utf-8?B?UEZSeW92dldpU3FpMDAwRnhuVmRWMjlZZjJVSlhCVTJjd0I5NTE4b2p3NWV3?=
 =?utf-8?B?STVIMUJ3SnF3ckl5UjB4NjVmTm12QmVBZXNMV09IQTI2RGorSlJXOURLWXFr?=
 =?utf-8?B?ZHU2VWFsS1VwUi9qUmlnTXNXMGVRVUZoNmFTYkpMcHBVeHhyb0doK3NYbVVm?=
 =?utf-8?B?ZGtxcXhDTDlHSTZEaVhWZE9pR24raUpCY3dZMkpydG5DZERrTHBMeEpQbWI3?=
 =?utf-8?B?VWRBbk1DcUNrdlZ2cUlsNEhoVkJwSStGdk5IaWtUaGZCUS91dWxwS3A4eFE2?=
 =?utf-8?B?Rk0zUHF3eWtEWmNMM2ptazNqZmRvblZsYjZwNkYxbnhwNFk5MzlZa0NJV3hH?=
 =?utf-8?B?Z3dZcEMvMnhyWWJGN0FUdllhbi9rVm9pRmRNR2NETjI4M1pyNm91VzFyM2dq?=
 =?utf-8?B?a0l3TzlkSDFOZkhhSXRKSnIzNTA4b3AwRWMvMG9vUXdOMnFuOTR2bmRMbHdS?=
 =?utf-8?B?dllHUHptaXVnajMrbGFRMkFuRUpYZWZEL2NpNzZXT1RDODhXb2Qxa1psamYv?=
 =?utf-8?B?YzhXTk15RkdzRHhzd1Zqb1k0S2o4WnJjSXJybytVeGlyZjA5YnBvN0VGZjRO?=
 =?utf-8?B?U0xaNlJUbEZ4eEVHdTdIbDA2Y0V2MnFIcXNGZUtxc21vMEp6Yzd0eHB4QVlC?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C9D173741AD1A4CBCD20571BE6F68D5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b122cdc9-804c-448c-00a8-08dd4a37d948
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2025 01:03:08.5315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skxpoRCErJiZul5jAYVnbcrg3c919mkGESY4IVlUdgyPGkzx8TTf0PiKGcEULewn6AAkAbF+YBtmO3DQZ3GtbJXhzTMxu0lJ+LpUhXHSSy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8043
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI1LTAyLTA4IGF0IDE4OjUzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSW4g
dGhlIHJlYWQtb25seSBtcHJvdGVjdCgpIHBoYXNlIG9mIG1tdV9zdHJlc3NfdGVzdCwgZW5zdXJl
IHRoYXQNCj4gbXByb3RlY3QoUFJPVF9SRUFEKSBoYXMgY29tcGxldGVkIGJlZm9yZSB0aGUgZ3Vl
c3Qgc3RhcnRzIHdyaXRpbmcgdG8gdGhlDQo+IHJlYWQtb25seSBtcHJvdGVjdCgpIG1lbW9yeS4N
Cg0KSXMgdGhpcyBhIGZpeCBmb3IgdGhlIGludGVybWl0dGVudCBmYWlsdXJlIHdlIHNhdyBvbiB0
aGUgdjYuMTMtcmMzIGJhc2VkIGt2bQ0KYnJhbmNoPyBGdW5uaWx5LCBJIGNhbid0IHNlZW0gdG8g
cmVwcm9kdWNlIGl0IGFueW1vcmUsIHdpdGggb3Igd2l0aG91dCB0aGlzIGZpeC4NCg0KT24gdGhl
IGZpeCB0aG91Z2gsIGRvZXNuJ3QgdGhpcyByZW1vdmUgdGhlIGNvdmVyYWdlIG9mIHdyaXRpbmcg
dG8gYSByZWdpb24gdGhhdA0KaXMgaW4gdGhlIHByb2Nlc3Mgb2YgYmVpbmcgbWFkZSBSTz8gSSdt
IHRoaW5raW5nIGFib3V0IHdhcm5pbmdzLCBldGMgdGhhdCBtYXkNCnRyaWdnZXIgaW50ZXJtaXR0
ZW50bHkgYmFzZWQgb24gYnVncyB3aXRoIGEgcmFjZSBjb21wb25lbnQuIEkgZG9uJ3Qga25vdyBp
ZiB3ZQ0KY291bGQgZml4IHRoZSB0ZXN0IGFuZCBzdGlsbCBsZWF2ZSB0aGUgd3JpdGUgd2hpbGUg
dGhlICJtcHJvdGVjdChQUk9UX1JFQUQpIGlzDQp1bmRlcndheSIuIEl0IHNlZW1zIHRvIGJlIGRl
bGliZXJhdGUuDQo=

