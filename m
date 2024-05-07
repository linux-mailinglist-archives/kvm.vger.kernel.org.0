Return-Path: <kvm+bounces-16848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C018BE77E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 020A01C2360B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0F51649DE;
	Tue,  7 May 2024 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DD6l67qC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257961649C2;
	Tue,  7 May 2024 15:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715096024; cv=fail; b=kS/0nra3GVatD7EvimVS+BIkGymETqyIKTHFiKsgSElDcvclex8y8gReYLN7jD+9bfqQwq8aWU98fa8lV2Dsu/RMNspGgRurxtIydU0XbqO16Im2+bijHo3r5MmDTwVJiq0JSxAl61IQoYRAOyPDkaeYRMSsEw6wMkmUbHZINH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715096024; c=relaxed/simple;
	bh=9zC3gO4FiXt2EdeFjz/fxxHCS5av7UfiIG5qtA0yR4M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bp4/KrBac1ZLwci4CQOOQjVxFzhuk0+dKslVhJsj55cj4k4KXLWvZXoqWhSDdU/wcn4gTgfBbM3Ux5E/79fjYCdSPczBQbDZY8rwuubv/pQ81VR4jdSIpZSR+ukU98vmyFJDyiIqvIrIfsFRUUn6dm6vHGmj3n6aJ/L27DkdUYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DD6l67qC; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715096022; x=1746632022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9zC3gO4FiXt2EdeFjz/fxxHCS5av7UfiIG5qtA0yR4M=;
  b=DD6l67qCGxaMRw14yGTJsngcFW9wUy2gjcVNAoFEqDQFb5c1FnEtvBpn
   shWTQmzQg2NaLOr42CyZwMJGDm1aDs02fB0emxM8e+6M0cqCX+C6/H+Mj
   nboHaf+6+axtAeqjyAWwIzthrcedULDfqzE0StB8wtf/wVYUg5V0edERQ
   vbDAXvNrVqgmwpabVAoTAfCho+WvoY/6KBFkquR2UQ8rR6ji79ScjAMUV
   ywVj8xlahTMHN9Zh5ZAFwK0ckCkMKxrvpJnZHlHpf1vPBeeVALJJByHfK
   655A1lCwzRq75oaMuhlGjOyESEo7kSivGyxAuJ4NXCddZ0Tw89pIkCIu5
   A==;
X-CSE-ConnectionGUID: xdPQcrSeRDC26p7+x+s7BA==
X-CSE-MsgGUID: DrrTUVdJRcCFZvfNtyD7vw==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="14710300"
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="14710300"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 08:33:40 -0700
X-CSE-ConnectionGUID: M4bmFrVST7+DIOw3Vx7Hvw==
X-CSE-MsgGUID: ewnV3QpLT0iAOi3OuF4CzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="59732687"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 08:33:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 08:33:39 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 08:33:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 08:33:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 08:33:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdodWyqq0ElDjmn4yXsC/7JcVQIHzUKYXImyZcx3cluW11sZskKa541DyD6BYikrtv7KTgHRg9Bn7TtZOa5Kf8u0C6Bfg97kZyLHNHckcz98kfEbZg+qmIucAeMOrvZbURaMb2K2KEDm7+VAC4DjRhxqgpfIRbUDehNyr3xFUJ3z6+tGgqA8CbK3ZaCzcwiQ2mJX8BirIGnRThmnQpUZ3+/yWSw/ERQnTSYMxg+K/C7RClvpVY6Wmc7rbuBoIbbkonvg9zmytirCbK8mqrfVF/wr6IeJbGwCs2mrzxOT4ebcMX92uiku7sNza35Ld67WRW3m4aKl4uKCW+g70NojmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zC3gO4FiXt2EdeFjz/fxxHCS5av7UfiIG5qtA0yR4M=;
 b=RPquyfT8ftPTdtPk5zk/ACy1VSm4w53WVkJlGZLGgEV/nWG4n9JxCKhgdd4t3keBWnNb0H0+r1tPj9L6geVfqmjuptKC/B+aYSZMSay9xRShi4GG+7+Fbxqbsex9jttJpQfU/RvvJFKHxPKfNuX5xPXmhszxT0j5EtzYJrNjdNVW6BVnLTXmYRLof3rBLuWJ33bHFtb8yceMKbzOnGhJMnwFRu7j/oBencOzq+JEHoyvyr6pcUEVyyv00pIKcVLwDyBptTpMM16TmxZ+SRTUKKY2kvksFQ1PnvI6ELoXD9b1f8Z5C+Ahuu/gddLTOQt7Xjg7FmOwrP4ucDZy5jk5cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by DM4PR11MB6067.namprd11.prod.outlook.com (2603:10b6:8:63::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 15:33:28 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6%7]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 15:33:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Thread-Topic: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
Thread-Index: AQHaYwfynhk8CrwGC0ayixDi2U+bW7GDdNgAgAbyCQCAAIJfgIAAbDuAgAAFmYCAAPKPAIAABtCAgAAGTwCAAAb2gA==
Date: Tue, 7 May 2024 15:33:28 +0000
Message-ID: <7af72cd4720d67dc2a2a5457dcda675a46aba83e.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <20240219074733.122080-25-weijiang.yang@intel.com>
	 <ZjLNEPwXwPFJ5HJ3@google.com>
	 <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
	 <038379acaf26dd942a744290bde0fc772084dbe9.camel@intel.com>
	 <ZjlovaBlLicFb6Z_@google.com>
	 <8a6c88c7457f9677449b0be3835c7844b34b4e8a.camel@intel.com>
	 <Zjo46HkBg2eKYMc7@google.com>
	 <994d42e4c4fb74899474a87766d7583507f13a73.camel@intel.com>
	 <ZjpD2BaO5SXPUEj0@google.com>
In-Reply-To: <ZjpD2BaO5SXPUEj0@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|DM4PR11MB6067:EE_
x-ms-office365-filtering-correlation-id: 96772e73-1b5e-4ec4-1a96-08dc6eab0b3c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TnZQWmpOM3lkeUtESmswUkFKTlVXREpxaXRLeFZKejdyVFBzdTE3a3R3eG1W?=
 =?utf-8?B?REtFcDI4TTVrdHl6ZlkxRklpRVd2NUE4bUVGQU51UjJUZTRpL2pVVUJzelU1?=
 =?utf-8?B?aTEvVFhyUEpLcG84MmUvQ1E5U3BBSVEyR0lYa01YTlNKN3VLUzlJMEZDeFVo?=
 =?utf-8?B?RGV3Ym1oZStrZ0RHc20rUzlxSG9Pd3E4YjRjYjJzOU95ckFZSXQzMEJGYlc2?=
 =?utf-8?B?Y083RHNHWjFWK2hnSDZPQ1BQZE05VWUyTGhNdTZ3R3RDQUQ1Q3hvaTBRMStZ?=
 =?utf-8?B?ZUtqMXQzQlRyVVhkbFVQUXNMYzE3YmhBYmVQSk1kOG55d1p1SkpWR1dlcXN4?=
 =?utf-8?B?VXlGeXlsandGRVRhOUZ6VzkyZHU5d1NtQTc3QUxuSThZd0gwOG85Q1Q4Q0Jo?=
 =?utf-8?B?alFwVXRCUkY3ckgwa0NwM0V0cGFBWlVwQlI2clI5LzZRVnVuZjhRK0lsWVpk?=
 =?utf-8?B?UFVscUZONllUVzJFUEVZV1NncHJMdGVyMGNzVG1KYkRDb0pTK2NFN3BaNFZv?=
 =?utf-8?B?YWJYemtleEVsZnBBWmQzZjh5MzF4eko4Qm9GSFViTzYrVVdHSDc0NGdhaVE2?=
 =?utf-8?B?b0JoQlFVYjhhU2liNmEvN3Q5dUxuRTFuQjRZTWJlYzR0T1h1ekVkaDJLdFBJ?=
 =?utf-8?B?VE9rYzhnM1dxZlpwTTJ6Um1jMXJJTjBFWU1YUllGNndvNVZ0c3c5d2JUMkx3?=
 =?utf-8?B?YWYwd3MyQVRXOXFJRlYvbHN4RWRoWTh1VkVZOXZMQmZNaXpNOHdGYkNrUVZJ?=
 =?utf-8?B?NEFRdTFVNnJFK2VreElQa29iZ25zeStVbGdFUDQ2cXFRalJZN0gxS3g0bHZU?=
 =?utf-8?B?cUt6cmlZK0IrdkVLcW1wQXd6M2s3T2FSSlBocFVJQjVrdmtsc3VmTmFpV3Rr?=
 =?utf-8?B?VUJHbGhVNXNiUTRjQ2FSU3BaQW9qcmRPZ1JIRmhRYlUzL3pOYzdwam9OdkIv?=
 =?utf-8?B?U2JMK3NSWU4wUE5YVkN2Yml1V0FwV2dPQU56S1pGMHo0aXB6ejJnVUxEckgx?=
 =?utf-8?B?bFVTb0pDdWRWZDJLMkhKZ1dWNzBkWWROTFpOWElpaGNXdmVoL280NGJ5djJw?=
 =?utf-8?B?aWh4R0ltVG5ML1poYXd6eElSRVZlOG1WbGt3ekNXZUtoS3dUWVQ4N1BVUUlw?=
 =?utf-8?B?ZXI4TWJQS0Nxd1dBQzVCWTROQ09sU2gwYkp4TVN5K2lzTWtyaXhkbXBrSCtN?=
 =?utf-8?B?Snl6T2IzODlXMmdOQ3lNVXNPNE8rSS9vWTFPVEhhUDNtdDFNMmU0eWFBVUEr?=
 =?utf-8?B?N2RORENDWkxRRXhsNGxkcUxWZnRoaU50dUU5ZXFSMkJacW1LcTdMdG53OWtS?=
 =?utf-8?B?anVFTWNwU0k0SEtjNTVCbDZyaVAxUnBnczBWYUZnT0QyY21sWkI4YkpWRCts?=
 =?utf-8?B?T0xYRVZEQ0UvWjI0TDFQTjZiaHBBNDREZ01OSHFxbVNuTzBrZ2R1Q1ZDeC81?=
 =?utf-8?B?L0ZHUFdZN2xPR2FRY1dQcWJyYnRWVjgvTW5GSHVJdUZHZmplcHBnbGZreTU1?=
 =?utf-8?B?dXdZNjNZcGxOTy9KYndyeFlhQ2U5NWxIUCtXcmltaUc5eXA4TTkzL3NSTGNy?=
 =?utf-8?B?SFFvTWcwRGZZOTkxU3g2S1lBZjZBcDBaeXhWdlVSeWJxQktpQllEUktGaGJQ?=
 =?utf-8?B?b1AyNXE3MU0wd2NCVUFGNmgxd3Mvdm1ORXBUQmVsdHE3cjhJNGQ1SFlONWU5?=
 =?utf-8?B?ak51QzhNbEUxNXZFanUrTTVyNUgvTkkrcUlmWXFUSkpKWGM3U3lRdTRIMEFU?=
 =?utf-8?B?RHhDWWpqRnZWNkwvbDQvRXMrVU5Fbm5JSUlmNUx0NGZHSzN4MVJqMTg4Wk1j?=
 =?utf-8?B?d28wT2JKekVkZ3FlekN5UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkpFYnVzWXRibEU3Yk1CZWo5cmVqSE96K2h3TUZISHczMlVZV3VjRFNFM0JE?=
 =?utf-8?B?VTZHZVFHM2dEQ1lOYzhySGRUU3pvQWlTWkd5NVBnZm1DOHpwZ0JZcndHZVU3?=
 =?utf-8?B?R0EwYVVhOVR2WVN1ZER1dWFDQnk4YWU1MkJHVFA3Y3B0NG5najQyM3JxVU1h?=
 =?utf-8?B?M00wMmU4MEZxMDdKajhuY2lnaE5Vd1FiT3dvT2xXTm9DU01zQWtDUXZrM1pw?=
 =?utf-8?B?WWk4OFJ0VkNabzhFVFFsOW1sWkZQWmVqSmx0SXVKV0Q2dytWd05obUk4Z2tp?=
 =?utf-8?B?NlVUakNuVWNnMFNOaEpnMHB2L0JPM3prRGpGRXZWSkNBdlUvbVlpWC9CQ2k2?=
 =?utf-8?B?MjBZdlE3R0hhMERyUzF1R2U1MTk0MnhDVmVUZ0JYMFNibXhaRTRGZGgzMFBC?=
 =?utf-8?B?OHIrRXdpVkxKZGt0N3I1OGdYNy9VU2hEamxNNnZQU09KeWt4SjQ2Z2xnbG45?=
 =?utf-8?B?V2RFK0wzWXRScnViSkR3Y2dOVGJnOW84WG8yVVh5MlpOZlRqN1ZLcS9xMVFv?=
 =?utf-8?B?a2VEbXZKeHFvS2swMS95eVdSK1dydjhTZCtSai9jTmdITzVMSU10cWYwZjFr?=
 =?utf-8?B?b1ByN1E4VUdxV0xaT3RmdU9vOUYyZTVsZHdIWkhWRXVSdW1DNUNsMUNOYktZ?=
 =?utf-8?B?WHowZldDdmFHRWoyRUVzQmlHK3BnVUFteVUwWTFDYzltU1RGUWh3eDg5eWJY?=
 =?utf-8?B?Z3ZVSCttWEtpc2NYNXlLRkFhdDNuVk04ZTh1T3p0THEyb3VLQUtaclA0MUpr?=
 =?utf-8?B?L2cxTWpvSzRKOVA4ZXJNa3JpYWVFWlEzT2pCNDY5WUdib2p0cGphMXdPMDRC?=
 =?utf-8?B?Z1VES2dIcDArU0crcDVxRjFNMEVTRTVWNXVpYThsZ2I4RzZGVnV3T01SdHVu?=
 =?utf-8?B?TnpsQXg4UmFDZWpndStDWldZdlNQVnh2R3A5OGNWTGN1K3NZSXBNYWlQMGcy?=
 =?utf-8?B?aDBoNVdDZWtJTklrT1JxbXM1WmZmNFpSZzJ4U29GbTdKM1lVK05yeEg5S0VD?=
 =?utf-8?B?MG54T0E5L1I0bzJvKzVZRlNNRTRHTFpUY2Z4ZXZYdWdIWjFnMWx3M2FFRXlP?=
 =?utf-8?B?WjJtVFZNQTdsV1I5MHZUWnY0REtha2xKcGd6NzFwRkF6Vm5VMEwra01LdlRT?=
 =?utf-8?B?OGlwZldqdU0rNnJyeDUxVjJGRkMxYlZZdXhEVWU2YldqS2NQbFk0cDBWTGhK?=
 =?utf-8?B?Z0p4UG4xRWUzdVE3UlhBRjhnVzRkRWZpeko0RncrUXVQUWZtRng0NFVhU3BQ?=
 =?utf-8?B?YU0rQU51b2dQVzJJRDRlVmhjWGdvTVhONCtTSkx2RWpzNFVuNUxQK1Rua3Qr?=
 =?utf-8?B?RUhYVXRWUDVreHA4aXJncnRtYXFNRmRaZWlBVUlmU2FzZ3JRVEtMU3JlelFu?=
 =?utf-8?B?Zk54dWxYQWt6c3dwR1EvZzRpMTNLRTZ1SzFrQkZtNDd6dE5KZkhRVy9tdG5J?=
 =?utf-8?B?WTZGdDE0cUE0alUzdG1oeFo1bHRkdXVScEt1Q01DdFBpS3BXVm5TZC91Q3lL?=
 =?utf-8?B?QzlMUDJJUWhGdzZ4cFRBTmlLWDAzR21kbWdBVjZOT1pqQ3E3cm1VWU5VUmZz?=
 =?utf-8?B?VG9BRU5PTzRjRktYbXRzUnd1TUl2cmhqVlhHNitndkh0ajRNTnBlKzgvSFJD?=
 =?utf-8?B?L1k5alM1R0tTVDM0YUtMbHcreTJHRnVHWU5TRDRjVHp1RDhIa0NXTDZwVzNB?=
 =?utf-8?B?eFZBSDdkeTZZV2kvSGcvQXJyazVqZU9qOWVIanBUT213Y1N6TVNjWWt5SjJs?=
 =?utf-8?B?cndFSzU4a1hXY1lIbHo3TFd2d3EwWTRBOWV3ZjBzOTl5a0pFMWVxUk9hL3g1?=
 =?utf-8?B?dGpZbTFwUDBBR05XN2Zaa3N6enpvTFd2NmN1SGI0YU9xT1llam5qVzZnUVpm?=
 =?utf-8?B?bW1VVXVhUDZndWRQdWJJVmFTSFdyZWp6NGRPWlJWRmdVemNILzNCMFJUQ2hN?=
 =?utf-8?B?eGh3VDRSUmw3eFBFakVRSEgwbVpkeE9MbFVRd3BFTUQvYWptNEpIOVRjZTdh?=
 =?utf-8?B?Q1BtdHp6Tk9FcVgzdXF2VUJJMkxUbmZLck9IQkZOdDBpNGpRK3lRckpiWWkz?=
 =?utf-8?B?VlU0dHFuRVpOd0pWN2lTU0tSbjFOYjZGRW1qQ0hYYkw5RE9KSUpaNHNZRm5i?=
 =?utf-8?B?NC9FaDExK2RKTnhZYlpCVngyc1U2aEpSaHN3ZmkyT0xNK0MzdDhJc0tZenZH?=
 =?utf-8?Q?ezWI7fJY/tRFf2g+uSGswnA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E243241E79B00149BFA86356520126B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96772e73-1b5e-4ec4-1a96-08dc6eab0b3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 15:33:28.6358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4K6Ur6xl1dEmJO6LG/5ovNeDJD+ErS5/+d/RLKpEmAi0MWlyYgOrPeNmWDTcHClzETot66muJShoWixFH4gDepBQAfiHFCo7aQPIXBXGzZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6067
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTA3IGF0IDA4OjA4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEl0IGlzIGp1c3QgYW4gaW5kaWNhdG9yIG9mIGlmIHRoZSBJQlQgZmVhdHVyZSBp
cyB1c2FibGUuDQo+IA0KPiBEb2VzIGlidD1vZmYgbWFrZSBJQlQgdW51c2FibGUgZm9yIHVzZXJz
cGFjZT/CoCBIdWguwqAgTG9va2luZyBhdCB0aGUgI0NQDQo+IGhhbmRsZXIsDQo+IEkgdGFrZSBp
dCB1c2Vyc3BhY2Ugc3VwcG9ydCBmb3IgSUJUIGhhc24ndCBsYW5kZWQgeWV0Pw0KDQpTYWRseSBp
dCByZW1haW5zIGFuIHNtYWxsIGludGVybmFsIGRldiBicmFuY2ggdGhhdCB3YXMgcHJlZW1wdGVk
IGJ5IHRoZSBlbm9ybW91cw0KVERYIHJhbXAuIEl0J3MgbXkgIzEgdGhpbmcgSSB3YW50IHRvIGdl
dCBiYWNrIHRvIHdoZW4gdGltZSByZWFwcGVhcnMuIERlc3BpdGUNCmJlaW5nIGFuIG9sZCBmZWF0
dXJlIGF0IHRoaXMgcG9pbnQsIHRoZXJlIGlzIGNvbnRpbmdlbnQgb2YgSFcgQ0ZJIGZhbnMgdGhh
dA0Kc3RpbGwgd2FudCB0byBzZWUgaXQsIGluY2x1ZGluZyBvbiB0aGUgZ2NjL2dsaWJjIGFuZCBk
aXN0cm8gc2lkZS4gU28gSSBzdGlsbA0KaGF2ZSBob3BlLg0KDQo+IA0KPiA+IEkgdGhpbmsgdHlp
bmcga2VybmVsIElCVCBlbmZvcmNlbWVudCB0byB0aGUgQ1BVIGZlYXR1cmUgaXMgd3JvbmcuIEJ1
dCBpZiB5b3UNCj4gPiBkaXNhYmxlIHRoZSBIVyBmZWF0dXJlLCBpdCBtYWtlcyBzZW5zZSB0aGF0
IHRoZSBlbmZvcmNlbWVudCB3b3VsZCBiZQ0KPiA+IGRpc2FibGVkLg0KPiA+IA0KPiA+IENFVCBp
cyBzb21ldGhpbmcgdGhhdCByZXF1aXJlcyBhIGZhaXIgYW1vdW50IG9mIFNXIGVuYWJsZW1lbnQu
IFNXIG5lZWRzIHRvDQo+ID4gZG8NCj4gPiB0aGluZ3MgaW4gc3BlY2lhbCB3YXlzIG9yIHRoaW5n
cyB3aWxsIGdvIHdyb25nLiBTbyB3aGV0aGVyIElCVCBpcyBpbiB1c2UgYW5kDQo+ID4gd2hldGhl
ciBpdCBpcyBzdXBwb3J0ZWQgYnkgdGhlIEhXIGFyZSB1c2VmdWwgdG8gbWFpbnRhaW4gYXMgc2Vw
YXJhdGUNCj4gPiBjb25jZXB0cy4NCj4gPiANCj4gPiA+IA0KPiA+ID4gVG8gZnVkZ2UgYXJvdW5k
IHRoYXQsIHdlIGNvdWxkIGFkZCBhIHN5bnRoZXRpYyBmZWF0dXJlIGZsYWcgdG8gbGV0IHRoZQ0K
PiA+ID4ga2VybmVsIHRlbGwgS1ZNIHdoZXRoZXIgb3Igbm90IGl0J3Mgc2FmZSB0byB2aXJ0dWFs
aXplIElCVCwgYnV0IEkgZG9uJ3QNCj4gPiA+IHNlZQ0KPiA+ID4gd2hhdCB2YWx1ZSB0aGF0IGFk
ZHMgb3ZlciBLVk0gY2hlY2tpbmcgcmF3IGhvc3QgQ1BVSUQuDQo+ID4gDQo+ID4gQSBzeW50aGV0
aWMgZmVhdHVyZSBmbGFnIGZvciBrZXJuZWwgSUJUIHNlZW1zIHJlYXNvbmFibGUgdG8gbWUuIEl0
J3Mgd2hhdCBJDQo+ID4gc3VnZ2VzdGVkIG9uIHRoYXQgdGhyZWFkIEkgbGlua2VkIGVhcmxpZXIu
IEJ1dCBQZXRlcnogd2FzIGFkdm9jYXRpbmcgZm9yIGENCj4gPiBib29sLg0KPiA+IEhvdyBlbmZv
cmNlbWVudCB3b3VsZCBiZSBleHBvc2VkLCB3b3VsZCBqdXN0IGJlIGRtZXNnIEkgZ3Vlc3MuIEhh
dmluZyBhIG5ldw0KPiA+IGZlYXR1cmUgZmxhZyBzdGlsbCBtYWtlcyBzZW5zZSB0byBtZS4gTWF5
YmUgaGUgY291bGQgYmUgY29udmluY2VkLg0KPiANCj4gSWYgdGhlcmUncyBhIG5lZWQgZm9yIElC
VCBhbmQgS0VSTkVMX0lCVCwgSSBhZ3JlZSBhIHN5bnRoZXRpYyBmbGFnIG1ha2VzDQo+IHNlbnNl
Lg0KPiBCdXQgYXMgYWJvdmUsIGl0J3Mgbm90IGNsZWFyIHRvIG1lIHdoeSBib3RoIGFyZSBuZWVk
ZWQsIGF0IGxlYXN0IGZvciBLVk0ncw0KPiBzYWtlLg0KPiBJcyB0aGUgbmVlZCBtb3JlIGFwcGFy
ZW50IHdoZW4gdXNlcnNwYWNlIElCVCBzdXBwb3J0IGNvbWVzIGFsb25nPw0KDQpJc24ndCBLVk0g
Q0VUIGtpbmQgb2YgYSBzZWNvbmQgdXNlciB0aG91Z2g/IEl0IGRvZXNuJ3QgZGVwZW5kcyBvbiBD
UjQuQ0VUIGxpa2UNCnRoZSByZXN0LCBidXQgdGhlIHNhbWUgaG9zdCBGUFUgc3VwcG9ydC4gTGV0
IG1lIHRyeSB0byBwaW5nIHBldGVyeiByZSB0aGUNCnN5bnRoZXRpYyBmbGFnLg0KDQpGb3Igc2hh
ZG93IHN0YWNrIHdlIGFsc28gaGF2ZSB1c2VyX3Noc3RrLiBUaGlzIHdhcyBkb25lIGJlY2F1c2Ug
b2YgdGhlIGV4cGVjdGVkDQppbnRyb2R1Y3Rpb24gb2YgdGhlIENFVF9TU1MgYml0ICh0aGUgc2hh
ZG93IHN0YWNrIGZyYWN0dXJpbmcgYnVzeSB0aGluZyBiaXQpLiBJdA0KY2FuIGJlIHRyZWF0ZWQg
c29tZXRoaW5nIGxpa2UgYSBzdXBlcnZpc29yIHNoYWRvdyBzdGFjayBzdXBwb3J0IGJpdC4gU28g
Zm9yDQpndWVzdHMsIHlvdSBtaWdodCBoYXZlIHVzZXIgc2hhZG93IHN0YWNrIHN1cHBvcnQgYW5k
IG5vdCBzdXBlcnZpc29yLiBBdCBsZWFzdA0KdGhhdCB3YXMgdGhlIGlkZWEuDQo=

