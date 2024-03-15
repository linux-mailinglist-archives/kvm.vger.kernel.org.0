Return-Path: <kvm+bounces-11925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E3487D309
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E1201F23152
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3062D4CE12;
	Fri, 15 Mar 2024 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G7TyicMv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9D94CB28;
	Fri, 15 Mar 2024 17:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710524944; cv=fail; b=loz3mVEEZvdiHdt/OLX9qRjPcw8Ls/n40e/a2KIqCuTime6a089tSn+Kcyg8GKXguoKhHyzTi1IRAP8OVyCmfXgqNLOC7iL8yfof3af8Yg1NBvrSfJI7LHXpLBJ+BuRA7unhq8afGTkRA/QjPMOmhaRHyXNSkFvQWck1t1neDw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710524944; c=relaxed/simple;
	bh=vx/uFacn5dDRzrOOyK9HPZ67/sFjxo0gNLFRlqp6g2E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rZYEuRN2bU+ZLK/HKJJPN5dR0UFHb6ElKKFENmAe/23VnNTYEYz0JXhnaRtqseselH8FPX9dfVEnDDetsk9JeReglIaDTzomIePPfDtaFqFoT1VY2WFz/SS2X5bPtEEcwsRiZVv7j5ZSLv70h7kXnaNFlTT2N8Maye5CodpyWiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G7TyicMv; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710524943; x=1742060943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vx/uFacn5dDRzrOOyK9HPZ67/sFjxo0gNLFRlqp6g2E=;
  b=G7TyicMvSrxRF64ft9NTCB9RQZmGaCF/DBCnpfTIXzZ7/FQYmZ8VLGzW
   +hdgZE5hUp6PGrRBgxXoisS7vAmkYHcBaaDpBulFfKAQs48xujJPNaIeI
   o0/bwAs/o9+FE+4p5jC0Gr+fs9X2XKCT4jEojDNcXv040zQ8+UvoZyYGP
   h+hVGqbk8HrOmu4dWZIWOApz3vC/jpvqqweilYS7uIf5tPX1iVu85Y3mt
   baUapSeg3hO7k+GyTmuLHdeddwTico6/QwnAE2P5ePnfbTXW1SKthInz5
   /6CiROw2jMZEeZZKJMvp1Yu0vO+RR9pLsxF2FeCxzE+Lf0iB1wFP4Ejcr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="9186821"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="9186821"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 10:49:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="43797321"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Mar 2024 10:49:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Mar 2024 10:49:01 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Mar 2024 10:49:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 15 Mar 2024 10:49:00 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 15 Mar 2024 10:49:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaQm5xyAc5iG0Cm/hjrvegRH/F47gZ6Nrf3ZHX6riI6gcVXZlwUv2Ldt/trhY0oph2wW7fRu1vs5z9/NT5i8YmKZAfuBzYdxQ3VywpifYxgmpzXXKLjxWZnpweVpdv68J5IYZeXrp/nSjNLcJJUita/EiNujCilqduf2KiQaZtJ/CCtm13r+3rRhU0uc/gQXqS8E7MHLhU+yIM4CF13knEJncJOza1MdLsdkWXzUF/8jgOxeqBKJ89t5gGz4O/j2uJd5ND/JAem+0dMIcvhdqMsoe18D7t1WpyzZUybO4SV91GvyvIHfgsTRVCXkxiHujel7Nhs4eDGVsFmW4qlbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vx/uFacn5dDRzrOOyK9HPZ67/sFjxo0gNLFRlqp6g2E=;
 b=nad9nvPyJyG8LcT1H19ructr9lxh7164XilVgxlfqFcc5E+pyI61NQ/9HtOzYdaGQoP/bx98b8aVwoCOdgkt52oI16cBzHW6PqYp7UjcIvnNRGaY4fUZLHX5vkuSfOlU03m6HQJxaO4cyz58B6Orgd2rYob7V9us7fPJV709nK5jvp0JAAV5VNPlKugrLNV4ta01YN2x9EB3Rwc1isCoOt3wfmMPeWOGWqrb9GzBGbSXgVEVdIPaPhrZtLn/FllCCLxGG2uUuRo6ocLvw4W+N2oMXScfsJ4hWYouUTuFVaPsp75ikflKDV3mUU0EcgrbIAo+yKsE8LNOj5sh2Je9mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4580.namprd11.prod.outlook.com (2603:10b6:5:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Fri, 15 Mar
 2024 17:48:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.008; Fri, 15 Mar 2024
 17:48:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHadnZ/Qf0yAsUauU2/h9YYap6ribE4BK4AgAD7XwCAABUgAA==
Date: Fri, 15 Mar 2024 17:48:57 +0000
Message-ID: <6cb438ccf1ffea84d5e3ef48737552b06c474001.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
	 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
	 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
	 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
	 <ZfR4UHsW_Y1xWFF-@google.com>
In-Reply-To: <ZfR4UHsW_Y1xWFF-@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4580:EE_
x-ms-office365-filtering-correlation-id: 62cd8126-aa62-4bb7-60ef-08dc45183079
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D1ekRKwvfV4Z98csoojA89hbl8LdnPxtPhtyv6w3dMq5v1uR3ejHVvjmFYnC2PIAJjqP7FZh4Dnii7BmgutMvimKQuZvdRPx+7RqBQD7GXn8ddzBTLc1g/zISFYs71Zh4OFg76S2NtJmK1n1iWf19HqpgnYU6bpQ5lC0WpCcbr3T4fU/qM5L5ryPvahVqDNrnUXsn/DNeLV6wMVwSw6hJQ1JDJekwB89O2ZRwz6v2s3X1VLTr8IUCHhH0qX6ccHH1CTQtfV/S5LYDz40ACLxfmnMwkbwEjSrwBHcfCeIqzXPsqeUZYRMmvVY3jluOdUeBrURIEdRvumn7oY8qT0fGnA4wNn4c76e+psI7JizUB6B8LbA/2K9wiX7gcv5zJIApoHF0HSAbchTwdL1OrJZu3yFb3y1kVrHsuydCFwLuCUnRnTmv2P6Brz3q9+WG94nUDllnLyGjdIMjAlAaSg04qCQ9dFJJCPczGzum/L22qRdZ2il33fGdetMxt220Y++LyEs8Vby2+348al9LzJuRRG8DBHVPt2SD6rRPb8KmhkiigZILryeEXAMeKUN2rMPLPNe1tAnAecI6S1hHKGUMKAS0qsrfmBRxtkia2F7CX2uBshfYl2C7TuHgWtHrK1vgZhfgXc3DKNC9GNe2OeCqvtPP1tUdmfu3AMyUDSCYNEpjqHkpcdcnnt+lOhxkYJw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEY2MFRiMHlndVlTNjBKZ0MzU0M3TWdVR0pzdFVpWUJDcktEdmQrRlVwdTA2?=
 =?utf-8?B?Wk05VkZtLzByOUNLeENUYmFRWVBqV0RkL3QzN09pZHNPMExhbHdrdkRCNG83?=
 =?utf-8?B?eXRCWkV5Zkpsd01DOHNJbUhBSlFBRmNxVm5BTlNhV2IzcjhmSlBmTzdCZHVH?=
 =?utf-8?B?eDMzdStCbkZDeURiOEVFMm9mTlNtOFB1TlZFWXFrSlM1STNWR3ErU0tqS3d2?=
 =?utf-8?B?MXFDVHVmRlBrdVdYMXFwcnBwZko4VG5IZWJCQTlWN3NUK3NZUm5rQ2tISzBJ?=
 =?utf-8?B?dzJnTVZTblBYOE42SStjd2p5K1MzOTVuc0c5MGlkSlN3SXFnOWZJYzNxdUhL?=
 =?utf-8?B?dGFBT0lucHFDQkFrVkJqODFaSTBkN3BER0FTY25jYVFVaWlXSndET1d6aUoz?=
 =?utf-8?B?NlU5RzAvRlNKQjA1Y2h5VDlBL2l3S1dqRmxvOXNoZjV1Ujd1bmRpdkErT0VO?=
 =?utf-8?B?ZllqcnRGOFNZSVZJNFhvS2NhNjVlRXdqOEdZWkR1Z0tBRFdzY3B2TWc0empI?=
 =?utf-8?B?VjNkNVJGTkgrU3ora1UrOEpFZTViVEFLOGlTeDdLSk9RSkxuR3gyNzlWVEZQ?=
 =?utf-8?B?dVFMZDhkTHh6SHQ3REJOR05KV1J2QllGYk9YWHFtTXBNdSs5MThHbjBqbzZ4?=
 =?utf-8?B?STNMRUdtK3g5c0dKSFRkL3g1T25Ob2VPZ1JXN0FueEhUb01zUFRCYVgzSkJp?=
 =?utf-8?B?dzAxWndQM3lNQk9lc1NiTnNzeFNKMjF3YmJlYjNhTzRxenQ5UVpDMC9mK1JQ?=
 =?utf-8?B?UlpjbHNCekQ0VUNCRnhTL2RlV3hkanQrazVYMFpDTFRQSFhaMVVqNkVoTGp5?=
 =?utf-8?B?ZVBxc21iTytkWHNUUDVybHhVTy9LMHlSVzNKYmg4QTR3QUk4ZmwxRWp6TjVQ?=
 =?utf-8?B?ZXYyV0M5V1k2WjQrS3VTNnVNT3ZqL2ZUaG9UeHhnQU1wZk9rdzMzV2hVOEE3?=
 =?utf-8?B?VHNOOEkzT0svTVJPNjFjOVo4a013N3A0eEVIeVNOTFplOGpHVDA4MVJTZDRM?=
 =?utf-8?B?QUNjSWx6a1IzSndNSmZDMlZJWkNiQjJ2WEQ0R0JYRUEyMVBqUDd5R1BZVkNZ?=
 =?utf-8?B?d1dUT3ZSUXdWbU15bW5WVmV5M1VYNTRKYVV1OEFxT2RBWXdZbC9TV3hMZ0Jv?=
 =?utf-8?B?eFA0ZlNWNHl4S0xFQUVoaTVkQTNLejZMWUZ3L3VseU9adHVyQzhDTnBWaWky?=
 =?utf-8?B?OG5BeklRK1p4aGtVQVY1am9BOURyNDVQcGU2NXphQ1IzT1BIcGRhZmt3cnoz?=
 =?utf-8?B?aE1vVExTRTBraWNxaklUV2JFOXJuQnp4eU1qaUlCT3ErVDNrOXpCZkNNSnBS?=
 =?utf-8?B?SlpqTnBBNE5pSUpwSHBPcC81VE51YnNmL0JXbWIzNG5pd0l1NjE3Q05PRWpM?=
 =?utf-8?B?c3h2QWd4QjVZaEt2a1pWNGVlNzIvV3MyRklRbWpKUnJqTFNSR05hWFdhVDN0?=
 =?utf-8?B?TGVxRTdGemRsaGFDTldzWVkzVit6eHVJRkJzWjQycVJIditzRW5TZDFIeUpS?=
 =?utf-8?B?RlY3ZVpXTHl2MGVURGRTMFFvZG95bXJZRUE3RjVaUmxFMiszSHNGVnNOTTBx?=
 =?utf-8?B?a1BaU1IwaDQ2ams5OGZmUzJ0dEhvY3lnOTNLc2gwWVQ1Ri9oRE1FRXJEUUls?=
 =?utf-8?B?aElXOEs5WjBFeDJjeXNtQ05JRkZ1ajN1Z1JRUjM0bVV4TzY0Y09LKzNySUlh?=
 =?utf-8?B?RCtlczBZTFNqckZMZEVXbEVoanRrUVExUUFKMHB4cnJiUVI5OTB2RXc5OFY3?=
 =?utf-8?B?Rm1NMktmTElubXJCazFYb2llMHVSWmdoSjAwNE5RZEYxWmNYNzM1cDBXNGxY?=
 =?utf-8?B?emtuVXBwUEY2U0YxZSt1NWIvZVFWd1gwU1l4Zll2MjdtNjYybHorMWRhMzBl?=
 =?utf-8?B?eTN5NWNVQXRDbHo0a2hJSFNzMTBOcnYvVG5hZ082K2dpWVE0VHh6Y0ZjcnpZ?=
 =?utf-8?B?SDJTWmlTYkQyejJwSjI2S1dqdjA2TnA3VFhCK2RhNFcwb2FPZmVPanNGRTVm?=
 =?utf-8?B?V3VMMG5EVWIramxrclhmZVdCU2NXRWtpRy8zd0VpNWpwQVFwcllqZVlEWUpL?=
 =?utf-8?B?OElITnZJRFNYb3R5UWhqWFdTUHpicUVHR3YyczZaaXBvWjFxR3Ixbzl2N1hE?=
 =?utf-8?B?Q3FoYzdmSzltNDJuMWJjMWQ1UWpIcTU4THkvalczWGwreVBWbDVxMWZZTWg0?=
 =?utf-8?Q?8KmJSrWVZmxwOIxFvEFp0Sc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEC9AFEC29B67C43841A3D42EB8F1270@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62cd8126-aa62-4bb7-60ef-08dc45183079
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 17:48:57.4336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2melMMBlIFpsEERJ73KawAJxLAMd7FhAHu6FL2/5RpeEFoAuTcUL4QudoZL9DzH0Jjs2ZzDZnMsG1qtqCrY/LFG+gBCeQoRQqa5yTRFQ8A8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4580
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTE1IGF0IDA5OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBIZWgsIExpa2UgdGhpcyBvbmU/DQo+IA0KPiDCoMKgwqDCoMKgwqDCoCBzdGF0aWMg
aW5saW5lIHU2NCB0ZGhfc3lzX2xwX3NodXRkb3duKHZvaWQpDQo+IMKgwqDCoMKgwqDCoMKgIHsN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdz
IGluID0gew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH07DQo+IMKgwqDCoMKg
wqDCoMKgIA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiB0ZHhfc2Vh
bWNhbGwoVERIX1NZU19MUF9TSFVURE9XTiwgJmluLCBOVUxMKTsNCj4gwqDCoMKgwqDCoMKgwqAg
fQ0KPiANCj4gV2hpY2ggaXNuJ3QgYWN0dWFsbHkgdXNlZC4uLg0KDQpMb29rcyBsaWtlIGlzIHdh
cyB0dXJuZWQgaW50byBhIE5PUCBpbiBURFggMS41LiBTbyB3aWxsIGV2ZW4gZm9yZXZlciBiZQ0K
ZGVhZCBjb2RlLiBJIHNlZSBvbmUgb3RoZXIgdGhhdCBpcyB1bnVzZWQuIFRoYW5rcyBmb3IgcG9p
bnRpbmcgaXQgb3V0Lg0KDQo+IA0KPiA+IEJ1dCBJJ2QgYWxzbyBkZWZlciB0byB0aGUgS1ZNIG1h
aW50YWluZXJzIG9uIHRoaXMuwqAgVGhleSdyZSB0aGUNCj4gPiBvbmVzDQo+ID4gdGhhdCBoYXZl
IHRvIHBsYXkgdGhlIHN5bWJvbCBleHBvcnRpbmcgZ2FtZSBhIGxvdCBtb3JlIHRoYW4gSSBldmVy
DQo+ID4gZG8uDQo+ID4gSWYgdGhleSBjcmluZ2UgYXQgdGhlIGlkZWEgb2YgYWRkaW5nIDIwIChv
ciB3aGF0ZXZlcikgZXhwb3J0cywgdGhlbg0KPiA+IHRoYXQncyBhIGxvdCBtb3JlIGltcG9ydGFu
dCB0aGFuIHRoZSBwb3NzaWJpbGl0eSBvZiBzb21lIG90aGVyDQo+ID4gc2lsbHkNCj4gPiBtb2R1
bGUgYWJ1c2luZyB0aGUgZ2VuZXJpYyBleHBvcnRlZCBfX3NlYW1jYWxsLg0KPiANCj4gSSBkb24n
dCBjYXJlIG11Y2ggYWJvdXQgZXhwb3J0cy7CoCBXaGF0IEkgZG8gY2FyZSBhYm91dCBpcyBzYW5l
IGNvZGUsDQo+IGFuZCB3aGlsZQ0KPiB0aGUgY3VycmVudCBjb2RlIF9sb29rc18gcHJldHR5LCBp
dCdzIGFjdHVhbGx5IHF1aXRlIGluc2FuZS4NCj4gDQo+IEkgZ2V0IHdoeSB5J2FsbCBwdXQgU0VB
TUNBTEwgaW4gYXNzZW1ibHkgc3Vicm91dGluZXM7IHRoZSBtYWNybw0KPiBzaGVuYW5pZ2FucyBJ
DQo+IG9yaWdpbmFsbHkgd3JvdGUgeWVhcnMgYWdvIHdlcmUgdGhlaXIgb3duIGJyYW5kIG9mIGNy
YXp5LCBhbmQgZGVhbGluZw0KPiB3aXRoIEdQUnMNCj4gdGhhdCBjYW4ndCBiZSBhc20oKSBjb25z
dHJhaW50cyBvZnRlbiByZXN1bHRzIGluIGJyaXR0bGUgY29kZS4NCg0KSSBndWVzcyBpdCBtdXN0
IGJlIHRoaXMsIGZvciB0aGUgaW5pdGlhdGVkOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGtt
bC8yNWYwZDJjMmY3M2MyMDMwOWExYjU3OGNjNWZjMTVmNGZkNmI5YTEzLjE2MDUyMzI3NDMuZ2l0
LmlzYWt1LnlhbWFoYXRhQGludGVsLmNvbS8NCg0KPiANCj4gQnV0IHRoZSB0ZHhfbW9kdWxlX2Fy
Z3Mgc3RydWN0dXJlIGFwcHJvYWNoIGdlbmVyYXRlcyB0cnVseSBhdHJvY2lvdXMNCj4gY29kZS7C
oCBZZXMsDQo+IFNFQU1DQUxMIGlzIGluaGVyZW50bHkgc2xvdywgYnV0IHRoYXQgZG9lc24ndCBt
ZWFuIHRoYXQgd2Ugc2hvdWxkbid0DQo+IGF0IGxlYXN0IHRyeQ0KPiB0byBnZW5lcmF0ZSBlZmZp
Y2llbnQgY29kZS7CoCBBbmQgaXQncyBub3QganVzdCBlZmZpY2llbmN5IHRoYXQgaXMNCj4gbG9z
dCwgdGhlDQo+IGdlbmVyYXRlZCBjb2RlIGVuZHMgdXAgYmVpbmcgbXVjaCBoYXJkZXIgdG8gcmVh
ZCB0aGFuIGl0IG91Z2h0IHRvIGJlLg0KPiANCj4gDQpbc25pcF0NCj4gDQo+IFNvIG15IGZlZWRi
YWNrIGlzIHRvIG5vdCB3b3JyeSBhYm91dCB0aGUgZXhwb3J0cywgYW5kIGluc3RlYWQgZm9jdXMN
Cj4gb24gZmlndXJpbmcNCj4gb3V0IGEgd2F5IHRvIG1ha2UgdGhlIGdlbmVyYXRlZCBjb2RlIGxl
c3MgYmxvYXRlZCBhbmQgZWFzaWVyIHRvDQo+IHJlYWQvZGVidWcuDQo+IA0KDQpUaGFua3MgZm9y
IHRoZSBmZWVkYmFjayBib3RoISBJdCBzb3VuZHMgbGlrZSBldmVyeW9uZSBpcyBmbGV4aWJsZSBv
bg0KdGhlIGV4cG9ydHMuIEFzIGZvciB0aGUgZ2VuZXJhdGVkIGNvZGUsIG9vZi4NCg0KS2FpLCBJ
IHNlZSB0aGUgc29sdXRpb24gaGFzIGdvbmUgdGhyb3VnaCBzb21lIGl0ZXJhdGlvbnMgYWxyZWFk
eS4gRmlyc3QNCnRoZSBtYWNybyBvbmUgbGlua2VkIGFib3ZlLCB0aGVuIHRoYXQgd2FzIGRyb3Bw
ZWQgcHJldHR5IHF1aWNrIHRvDQpzb21ldGhpbmcgdGhhdCBsb3NlcyB0aGUgYXNtIGNvbnN0cmFp
bnRzOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9lNzc3YmJiZTEwYjFlYzJjMzdkODVk
Y2NhMmUxNzVmZTNiYzU2NWVjLjE2MjUxODY1MDMuZ2l0LmlzYWt1LnlhbWFoYXRhQGludGVsLmNv
bS8NCg0KVGhlbiBuZXh0IHRoZSBzdHJ1Y3QgZ3JldyBoZXJlLCBhbmQgaGVyZToNCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzIwMjMwNjI4MjExMTMyLkdTMzgyMzZAaGlyZXoucHJv
Z3JhbW1pbmcua2lja3MtYXNzLm5ldC8NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1t
LzIwMjMwNjMwMTAyMTQxLkdBMjUzNDM2NEBoaXJlei5wcm9ncmFtbWluZy5raWNrcy1hc3MubmV0
Lw0KDQpOb3Qgc3VyZSBJIHVuZGVyc3RhbmQgYWxsIG9mIHRoZSBjb25zdHJhaW50cyB5ZXQuIERv
IHlvdSBoYXZlIGFueQ0KaWRlYXM/DQo=

