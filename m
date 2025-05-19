Return-Path: <kvm+bounces-47032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5EF6ABC855
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 22:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F15177A0336
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBEE02163BD;
	Mon, 19 May 2025 20:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FPbonGHR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D03215766;
	Mon, 19 May 2025 20:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747686108; cv=fail; b=d00EuG6b1XkUyNSAve+0eTzkEEfOxnVCGl/mhBtzwUKiEH8k9vVvj1l989Ldg6wyAHEtMYoA/4/vcKpZiJgAal0T+H0bsOgZnPKinHdsYhajL5wskqO+7NiTO+F/CtITh2EqM6HhFTuy1a6S7OYgVUQ7yq7LErj15BWcF++I0Cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747686108; c=relaxed/simple;
	bh=RUfHnmkBdNO8OZKYeudCEbVu509ZC6vZppcodb527fo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=deICrtD5hX3jRFR/VfMThuKfih1g0exhV+J478TtE5gcdlzlr6haaNJShCYfy+yyKVHmfYdG/9t6Dp5Jhp5vpq4++sVgra4RP06RjTJ/t3Nf7Vn4dSkpRYOeZrtYI2AOFf+MhdPmXV56eZjxZ47b27vwWF7C1XGz6Gbr+8gBeRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FPbonGHR; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747686107; x=1779222107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RUfHnmkBdNO8OZKYeudCEbVu509ZC6vZppcodb527fo=;
  b=FPbonGHRU0PzHp3J5odibQMfZct6anngmmgNE2aPwu3KTj1eu5Kfh6J9
   lVXXOHaKSgVPEf7tld2qaLZqdMLb3aVZR6G+1USCP8m3eI3AMgjUP8a41
   Mm532Vgb6of2gP++qhuVO8IJLIzsEThlwstIKZPnyyC3+vCOigTLQgRky
   W5jYKjUEdwSHscXteGUw/47KaZEIU6VOgpF74Y1wBQJz4Lc1VYqZKJN2n
   grMITF57v5e4DTJZapcTgaqC50yP1mxDX5U1efbifaNFA4UeDgbKUok0K
   TxF5sk6TzQcfeWY/j833iNOxFUjUM5bD1TXhdpwWYcIIQ5Xkep+rmYkkJ
   Q==;
X-CSE-ConnectionGUID: kBjQgxK8SNuy7tfqw+IbtQ==
X-CSE-MsgGUID: qJctbzpOT9+sF1koAVeoGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="37216858"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="37216858"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 13:21:45 -0700
X-CSE-ConnectionGUID: 3D0iaZp2T+q82BPTVQYFVA==
X-CSE-MsgGUID: wEBZMhzCQJSOCt6BvTDD7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="139510782"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 13:21:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 13:21:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 13:21:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 13:21:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZKQeqCyl1+kwxXm6461dqVCBOUm0BDS2a833J8k+wClhb9qmt1DZ6Yd00hItYEUc+Y6YOu3p7nHecaHdqmDIBA7xz3ah6Vsh/Q7f7U6hc4lUPJxOjEKDuKYgimpfj5cYkq7rFuwk+g3qIgKy1vzWnHw+J5T/Pre4hpEDoDZrC504tILrhL6wG54E5IjaL1Er58KBYzmYHti05QCEvOGBTJyG12TAcXNATeJJ6+5vGNA2SN9QvC6+cEo6Q7Oaf3YxrBzo/wF8On/9PWqZOzDJ1yEjMBMyoyYo1HeZ2EgWvlGFY+RMBYcAWx5UnjPtRR59xi+nehJE4z1aK3rsUJxlEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUfHnmkBdNO8OZKYeudCEbVu509ZC6vZppcodb527fo=;
 b=rG0I9sIsuydCCjZZpDXsND2NSjf34Y/IMsBBZYulatSnWNcO29WZCQNJmY0Q1zEY63YBl003yaZ3IQUiHirXLn/69V0Ao4x71q4sX1VzWGYc7z9PPmB/9tFYFkGkpPsn0JI4FHnGLeFeKoaDjnFpwEFOG7PdGZ4FzcqmRVS4zHZE6JtEftpMwF5rkoGNBhD1vWcXQBmkpOPNgbj/GnYrTtFMtS+cQPEcuiGIhskP8O7PTzLfGe22FumT7i11WB9y8QAw0Nq0qBg7ou4K+I1r1pRVQIocGiAkcl858TZ6QXhcgi4wetkgeJD9J/WNCb5q4WX9ZoT2AWKrnbPt3fCwFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7380.namprd11.prod.outlook.com (2603:10b6:208:430::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 20:21:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 20:21:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "ackerleytng@google.com" <ackerleytng@google.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Thread-Topic: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Thread-Index: AQHbtMZXtCmug//st0iewCdVRT7MSrPRTdqAgAPPNYCAANh4AIADhm8AgAERnQA=
Date: Mon, 19 May 2025 20:21:13 +0000
Message-ID: <724deab9c31b6e5cf30817b01446d344141178c8.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030744.435-1-yan.y.zhao@intel.com>
	 <b5af66343b3f5d4083ee875017c7449dea922006.camel@intel.com>
	 <aCcCl6nSvYpSK1A2@yzhao56-desk.sh.intel.com>
	 <11de62c95f7866fcecdba4c2d9462c77bab3bf83.camel@intel.com>
	 <aCqtMgT3DA/AvC2s@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCqtMgT3DA/AvC2s@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7380:EE_
x-ms-office365-filtering-correlation-id: 3e0cc955-dc82-4911-5381-08dd9712b3b5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L3Y5b3JFUTltamJRWVNKaHloOHNLeDJVTUhoSjJmVURHcmdQSkR0NklaeDlD?=
 =?utf-8?B?NndyY2dsTFFIc3BuL1puTENWOGRZdUVYbWl3VE4zSlNmZ1dmcDJIOGtrV0Jy?=
 =?utf-8?B?TlJwci8wZW1MUW5hbE9iM0tHWHhmNUZZU3k2SkMxMDFWSkFTQmN5UkFFTkJa?=
 =?utf-8?B?VW85ZnZ6VmxDc1RCeFZtd0hLcnRkaUxjQWRvUlJWVWNzVzhpZ2luVUpNQlN2?=
 =?utf-8?B?WnNIV0liSllrTDFtM1ZKcURwM2VZR1krS1dHL1dvOGJEa3ZZN2JIbHB4WXdo?=
 =?utf-8?B?OGM4NCt5TUhxVEhnUEp6QkVMTXVDeEVKSkFWV3Rlc3hnMnZxYkptZGR2TnZM?=
 =?utf-8?B?UVdZMEVRZUl0ZlNSNWNtTCtKWUFPWERxa3hGTlUyNGpFbnh3RC9aUW4wYUZV?=
 =?utf-8?B?aG4rQkpKWUlXVlQzekdra3lEWGRNNUJ2b0RobTVGMlhRcTZaNEkvSVlMSWor?=
 =?utf-8?B?TXE2M3cyY1NuNk44c2NaaTdvZTUra3JBOERaaGxFSWdML0F4cGlteTlOZTR1?=
 =?utf-8?B?N1g2Vk5TM2xMV3dISEZTbnJnenN2L1YrRDhFQ1BsZHR1bnpXKzllaEpWVFg1?=
 =?utf-8?B?WUhlZXRZN1U1bjY2bFlIeE94WC93ell5Zk9uZlhDbmFCZzNJZUdSUFFCZXFR?=
 =?utf-8?B?RVJmU0ZHYmN0NG1DVHRreGJpL1c3MzFjWWVGQkV0citibU1LZmxvMzZiMm9s?=
 =?utf-8?B?WnZDOGJmNjNmcDhvQVZ0Zy9UeUZ3TThITjBWdG9tdTRBRk5GWjBnZ3NqZjhM?=
 =?utf-8?B?d2pHblY4UmlSLzZyUUpqUHNUa3VIa21lb2h0Q053MzlzN3h2L1JSWURUdmUx?=
 =?utf-8?B?OWRESVRrMEw1NTdGZ243bGdZSlZ5eWMxUm1jdXhLRWwwUndKZ2RUUGRHTXF2?=
 =?utf-8?B?R2pxM1RhRlE2SnRjaDRpVlQ0LzE5OXpQUUNVREFaRHRDa3lJVmpyNXpkazQ2?=
 =?utf-8?B?aWMxMDRQaW9heEN3V0pTd2ZrUi8vU2phcmpBZU4zZXc5MEJiM3diaFhDYlRh?=
 =?utf-8?B?cjU1R2VucFhKdVNtVnk5OHNuOHVrM242SlhmaWRmc2VuT1BtYnRCZHFicnNU?=
 =?utf-8?B?azg0RU93YWFIUU83OVBGRTlwVmxzR1R5Tk1jd0FvOHU1M04xRHRpTjA1Uk00?=
 =?utf-8?B?WGt5dll3R1J3T3dZUnVIQ2VLMmo2RHdlZ2NuOVZHemVtbHJ3d0FJNUxYbDZV?=
 =?utf-8?B?QVAzSmN4VythcEpuYUZBSlRhZVdTVUd0cmtEbFNrWmdSbWtiMGhleDFDN2Ix?=
 =?utf-8?B?SGI0Zy9oK1pPR2VYbm5EbmJQV01URnJZQzVDTHFxTUdSOGdNWHdxVUVpZGF4?=
 =?utf-8?B?SXBleXhGZ0EvWjNhTnJvOXBlK2VyMDNjaVpsU081eksyeGVsd2ROY1ZJUGVK?=
 =?utf-8?B?c0JiejJNSkVqRDBPdVE5ZjJ6cnRnU3F2cHBxeXdaWVlnbDQrZWY4V09hdkVH?=
 =?utf-8?B?eDRrRmJSeGVWTmNRTjlQZHFOQmU1Q0I3YlZwUjNWbGFvZXZlZzBiREdwYVls?=
 =?utf-8?B?NG1YdGhpcGpSKzl0N2lJL1lLMTg1T1c5c0JFcTVMdDEyaTVWNURXNnh3V29y?=
 =?utf-8?B?dzdXQlN1K2l2UWZ6R1BqSC9jWjJ0Q0JNN2NYR0lxNXoxNGR0SUt1by90cE0r?=
 =?utf-8?B?UkVCUFlVcFV6azNwQzNFdGJVV1lmK0ZZeTZsZ1ZKbWJkbW1rMVc1SHFtWEpM?=
 =?utf-8?B?NE4rQW1xYUNKRVpqM09aKzZ3eHBPUlY4LzMzKzdIbXRzSzd1VnRRbDg3cXpK?=
 =?utf-8?B?WVNiVlpWTUd1R0pjWWxCTHJXcElCMlA2SysyY3J6OGFLSlAyNFlDZUgzaGhk?=
 =?utf-8?B?cVN2YzFGcyswYXpSczFtN3dpT2VsbkZyTjg4cGdxTHdUdUxGRFR1WkFNaXo5?=
 =?utf-8?B?czg0aXZYeWU2VFgxcVRaUDQ5VEFJRHJTUmcyUlpXWmVqZm9LQld5ZnNlOWl3?=
 =?utf-8?B?K1FFM0F5UThNZ2RxNU9Rc2xYK01RYjlBU1ovazVQQ2VvZVdqYXBNU2JBY0N0?=
 =?utf-8?B?UTkrTFlPSjJ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWpnNDUxenBEUmxFNDZDdHp3c1JDWFdMRkNzRjhhdXBoU09kN0lySGtxK3Rj?=
 =?utf-8?B?K3pPdlc5VnVFUXA5Q1FycHlRUnlzcjAwMmU1aDdVeUtNQVZGZXBHSVRzb1NW?=
 =?utf-8?B?MWlDUll5Q2Y0U3ZZVWNqNjRpYWhab0hIR1o1d2hnOWpwRlRRam94QmZlOXY5?=
 =?utf-8?B?bFBwWmRGL2RHUUtyTFgvc2pnWjR6b2EvcWc4aXF6dDhqSXl0Yy84b3JHajNp?=
 =?utf-8?B?UlpQREVJREp2VnFhcUVTaUFBcENsZytKRFVXN1ZQeEtZQXJGcnBJMlpCNVZw?=
 =?utf-8?B?RUhWWlRWU2VKN1dZWDhBdmVvZnhQMVpOTW9paWxsbmdPZ2xMYmd0b3ViWFU0?=
 =?utf-8?B?VzRLeVpBNGR4bW95VWFVTmhMK2tKMTk2WTdiRWcxQlMyVUNiTzhMZFk5anhn?=
 =?utf-8?B?Y3RRQ05tNGVxcWdVNkdldWtKWGI2cUl1Tmxid1FQSDY3NHF2ZkNqdnkwWHpS?=
 =?utf-8?B?dEczNHloLzA4RUZPYXZnRWJXeUliMXlIRGZBVERKQTlOTnFVSWtQS2t3TVJZ?=
 =?utf-8?B?eVRvdlJrMTJiSjFiVHpMSHJJcmw4dHdQUHlnOWx2OTlpRDUyaUZ3R1lzTmI4?=
 =?utf-8?B?UHdEWmp5RlJxc20xZDJrcUo2SzJRMzJZaVRpV1ZvUHd2Q0E1R3NyN1ZWSlp0?=
 =?utf-8?B?VmVuM1pTd0drU2tUc3p6akpicDRZNGdQVStlaStRYUp2SUhyMDZReUd4U3Z4?=
 =?utf-8?B?bE5Lb0U3WGdHYnJiTFByQ3VkOTJGZHBrTmJ6SEVSaTlwLzI5UkV6K0pjZTg4?=
 =?utf-8?B?QWFqSkJqZmVhL2x5RzlFcjk3WVB0bzZXbXlxRUNqRENaRXFub3NxTmlzRTBN?=
 =?utf-8?B?WHdaZTc0eDhkV2pTbUt2YzMzT0t0S1JhVUJlZng4T3J3NXN6enFuTCtXZ2kv?=
 =?utf-8?B?c1VFNG5FcXZlZ0ZYbkJaamNPazhvU1BuYmpaeW9ZSVJLMUNhb25mRjgyUkE0?=
 =?utf-8?B?VGtyaVNGSkJqcXIweGxjUDdmcGVuZTArS0J1T0ZId0ZJbmg0K3JpWjE4OUp4?=
 =?utf-8?B?Z3BaeGtjZnlDUTRURmlNRE5BeUhjSXFNRkFPSFo2czRocVlpaHZ3Q1liYXk5?=
 =?utf-8?B?TFN3QlZNcmxTMjN6alVzKzRjVktwcENOTU9kUGdpVlNGdWVwU2tnQkdISVJL?=
 =?utf-8?B?U2Nob0hENzJhRHVHWVYxdXltQ3BKUEZjU25HQXN5UmMwdldFR3o1c2p0VFZp?=
 =?utf-8?B?OXJwV0tHSFZQdkdtUmdtdEFJVWxNZlp1Wm1jNklUTHNIU25OYXBjcWdxRHNI?=
 =?utf-8?B?TFpxWTBPNFJ0RmtKQ0QzcWg3bStBcVZReW1OdkFYRjR6TXYxY1ZYZElOaEFq?=
 =?utf-8?B?QlBTajRWOG95VlhGS2RqQzlvc2w0UmFHZXNnTkxzaS9WT3VTa1RkQlI5Z0Ew?=
 =?utf-8?B?QWUwY25BN2IrUnlXbDlJUWZHSWovTVRWMSt0YmxHby92OWdiSGJWUllMbWRB?=
 =?utf-8?B?SXRnL2Uva3pVQ0JUUDRtMmJBaVRTa2VKeThnVmFWV05rSU1tVDA0eGpkSXZ6?=
 =?utf-8?B?WXdNSk5MZ28yalpqN3VRUHBQNUV1Um9Bb09hV3NGMkdNY0RjMG0wQnRMWFhy?=
 =?utf-8?B?K2swNmxOejR4RFQ2bUdHL2lPTmVOMEZhZitZeDFJSWM3dTJDWFJ3ZFErSm5y?=
 =?utf-8?B?cHpQWFAxTzJjMHVCYUkxR2hFbmU1ajJjbUxOTnhYRUxwclU1aVVDcS9tbFJB?=
 =?utf-8?B?aWFCSU9Jd3VDWitaNk5qMDVtK3Y1ZnFzVmZ4Wk53NHRsMmt0VGVaR1lqM1Z1?=
 =?utf-8?B?eWdycXRieWo4ZUZ6QXVMU3JyeHl0TGJWYjREemFlWjcxSG42RkZQalVRc3dZ?=
 =?utf-8?B?bXdlNXhROXRXK0d3L1VUMSt3WVFOcWg3NmIrdFQzSTBxc1lPK1luOTZGWFFa?=
 =?utf-8?B?NUxVVlFQTzVxa0JpamlucTNmZzl4eWZVNDN3K3NZYUFiSHVaS0J6QnJxOVQz?=
 =?utf-8?B?V0dXdEQ0K2Z6U3Q0d0tGTE1CNGN4cnA5VjRIZ2VERTlYQndzdElxQm1Vb2N6?=
 =?utf-8?B?Nk5HTHU3UzY2MS8ybHBxM3liY3U4ZnU2RkZOZ1VkL2ErckhEcWpQUngyYXA5?=
 =?utf-8?B?Q0FtUE9tbTUwYkppZXBKNFNmOHcwc0pLcDVaYkFFVnJuS0NZY2RFbXYza1J3?=
 =?utf-8?B?YytIemJreHZBWFdvRDZWakczbWRQb1YxRDVTeGhjU3E2TTlVNWxaZ014NjdU?=
 =?utf-8?Q?yAh+NqAy4dUewTa92rdRD/0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <363C97102C290A40897DC772D0B53C5E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0cc955-dc82-4911-5381-08dd9712b3b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 20:21:13.6086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DK9IhdTB0Mmi5uztdcSXA35Nmyf0NzWnX8QQpDKwiPuq/MlAoP1UkcJgwUUPsD32BDvpkrPWeeqeHzn3KzFt1M0+7XVuSVi20dWDP1dDw1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7380
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEyOjAxICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
U2F0LCBNYXkgMTcsIDIwMjUgYXQgMDY6MTE6NTlBTSArMDgwMCwgRWRnZWNvbWJlLCBSaWNrIFAg
d3JvdGU6DQo+ID4gT24gRnJpLCAyMDI1LTA1LTE2IGF0IDE3OjE3ICswODAwLCBZYW4gWmhhbyB3
cm90ZToNCj4gPiA+ID4gU2hvdWxkbid0IHRoaXMgQlVHX09OIGJlIGhhbmRsZWQgaW4gdGhlIHNw
bGl0X2V4dGVybmFsX3NwdCBpbXBsZW1lbnRhdGlvbj8gSQ0KPiA+ID4gPiBkb24ndCB0aGluayB3
ZSBuZWVkIGFub3RoZXIgb25lLg0KPiA+ID4gT2suIEJ1dCBrdm1feDg2X3NwbGl0X2V4dGVybmFs
X3NwdCgpIGlzIG5vdCBmb3IgVERYIG9ubHkuDQo+ID4gPiBJcyBpdCBnb29kIGZvciBLVk0gTU1V
IGNvcmUgdG8gcmVseSBvbiBlYWNoIGltcGxlbWVudGF0aW9uIHRvIHRyaWdnZXIgQlVHX09OPw0K
PiA+IA0KPiA+IEl0IGVmZmVjdGl2ZWx5IGlzIGZvciBURFggb25seS4gQXQgbGVhc3QgZm9yIHRo
ZSBmb3Jlc2VlYWJsZSBmdXR1cmUuIFRoZSBuYW1pbmcNCj4gPiBiYXNpY2FsbHkgbWVhbnMgdGhh
dCBwZW9wbGUgZG9uJ3QgaGF2ZSB0byBzZWUgIlREWCIgZXZlcnl3aGVyZSB3aGVuIHRoZXkgbG9v
ayBpbg0KPiA+IHRoZSBNTVUgY29kZS4NCj4gSG1tLCBhbm90aGVyIHJlYXNvbiB0byBhZGQgdGhl
IEJVR19PTiBpcyB0byBhbGlnbiBpdCB3aXRoIHJlbW92ZV9leHRlcm5hbF9zcHRlKCkuDQo+IFRo
ZXJlJ3MgYWxzbyBhIEtWTV9CVUdfT04oKSBmb2xsb3dpbmcgdGhlIHJlbW92ZV9leHRlcm5hbF9z
cHRlIGhvb2suDQo+IA0KPiBJIGludGVycHJldCB0aGlzIGFzIGVycm9yIGhhbmRsaW5nIGluIHRo
ZSBLVk0gTU1VIGNvcmUsIHdoaWNoIHJldHVybnMgInZvaWQiLA0KPiBzbyBpc3N1aW5nIEJVR19P
TiBpZiByZXQgIT0gMC4NCg0KVGhpcyBpcyByZWxhdGVkIHRvIHRoZSBvdGhlciB0aHJlYWQgYWJv
dXQgaG93IHRvIGhhbmRsZSBkZW1vdGUgZmFpbHVyZS4gTGV0J3MNCmNvbnRpbnVlIHRoZXJlLg0K
DQpCdXQgaW4gZ2VuZXJhbCwgdGhlIGFtb3VudCBvZiBLVk1fQlVHX09OKClzIHdlIGhhdmUgZm9y
IG1pcnJvciBFUFQgaXMgYSBiaXQgb2YgYQ0KY29kZSBzbWVsbC4gSXQncyBub3QgZXhjbHVzaXZl
IHRvIHRoaXMgc2VyaWVzLiBCdXQgSSdkIGxvdmUgaWYgd2UgY291bGQga2VlcCBpdA0KZnJvbSBn
ZXR0aW5nIHdvcnNlLg0K

