Return-Path: <kvm+bounces-2525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF7FB7FAA50
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 20:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D8D828195D
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 19:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC903FB0C;
	Mon, 27 Nov 2023 19:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LQUJ1eMR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17A8DE;
	Mon, 27 Nov 2023 11:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701113637; x=1732649637;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OnaNk1E38vGlUSy9c2C/2e27Y76HB/Yl6z4wvU6Ypoo=;
  b=LQUJ1eMRO+MhhqA9kg4eo/xITTW+4WkPTONXwF8wMVGJA5ndArCzX/DV
   L8IkfGIXY6ZpHBNKss3BqzI52+EwyQviitdbR85Nw0uq8WCkZV+lg6+fR
   IaOCg4iYOejm3kuCGo1hzcyo8g5LxAQGW6+ZvhJFGabYvJnOFZH4cpUWC
   palggsn5OB5LRG226nvNc+G8+pF2UXNcJWq8uyldJoRL8lgNUjQcHxDGj
   3JSHBc+/ybGlWogNsVhHIqp1VfXnmSCB/xvQl2CHkEpwBB77dIQNecD6Z
   n4bM7SKDZbsCTIcCrIOyzNmj/aVHRSK8p8AI/U+hwg+QxCFOAc9WHSC/a
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="457107192"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="457107192"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 11:33:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="9874530"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 11:33:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 11:33:51 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 11:33:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 11:33:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+9vRXKCup6Jn/f2MUjOxYOeCNHg+jWcvEfw6ESfcMHyb807EUnYWW5i0DYOc8RlATQZd72WYN2/hL9U39ypTv6bNkE/i0JiMm33f9Ngu+JP9NuN9fY68DB8PBdWXFJA4i0eqhbV9NG2/rIE7Os6urjFc4QVYY3MvRSDFQaYwgU4Ig/t05geizVpMAdNG5yl5KM2wjyScTiDcH6tXnQ8KRDcOl7FDfwX9TOhxix+uFD1kTbxV6OgaodqWu2CImZC45hybo6jTCxe4c0WVr+m3VkE3jY9/W4fckQjrKEFiyVR+xqyIz91s32yyg+z2QxKk433eJITv2rjXiIeG+3UeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnaNk1E38vGlUSy9c2C/2e27Y76HB/Yl6z4wvU6Ypoo=;
 b=Dx4tL96Iv+Bj67meMsYoOlDq+vC5tIWiwPvuBpIMjlaTdzYc/dsoUgueqBeAo9AvQJIxUybLsqGl6V7tpF4yMSW9rOFC9/+iTAQZiW0rUZ1Q/O5P8fFg7UQVGRaq7o5KuYZ1FwacLJxIDQ+fup/JSP4PYfFMpSKrTHAwySQfqcvPBHmTdjN9jD4kibTZJm8pRUJRQ6P1OmbphMXjmTMi9C78J07gNdnExcpMSGd2RnMGTKakbotnJUa9T8mvpukHFX7dHLs6NLf6gHFRjfY/3kvVX6Be7jvwWrMLe3h+QTvgqUwQCVFsi0aI920ec61FsvDtifZKeSPw5tMcCwnl2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5895.namprd11.prod.outlook.com (2603:10b6:a03:42b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Mon, 27 Nov
 2023 19:33:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 19:33:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "Brown, Len"
	<len.brown@intel.com>, "rafael@kernel.org" <rafael@kernel.org>, "Huang, Ying"
	<ying.huang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Thread-Topic: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Thread-Index: AQHaEwHp2HWZl9Al5EWrZJMGp6I1arCOlOeAgAAWWQA=
Date: Mon, 27 Nov 2023 19:33:47 +0000
Message-ID: <e8fd4bff8244e9e709c997da309e73a932567959.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <2151c68079c1cb837d07bd8015e4ff1f662e1a6e.1699527082.git.kai.huang@intel.com>
	 <cfea7192-4b29-46f9-a500-149121f493c8@intel.com>
In-Reply-To: <cfea7192-4b29-46f9-a500-149121f493c8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5895:EE_
x-ms-office365-filtering-correlation-id: 4f9748f8-66a9-4d4c-9b28-08dbef7fc680
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yt2tjKrBeAUJXdX2iTUVmPxqw8Xj2qO6V5x4Yf83rGxKtz7KZVnh1EQgIsJVm3uR7qS9rt/TqAo51bRKwKA+XHflFsY8Zo5Z0zJJzh1pbP4lMMr9eKtjtxqlypNXALZK/I4E48zTY9UqserAtJwUWJ0Mi0dr+S5E4r6RtzYDl6ZfJhiXOoVKI+2fHstjE0xtuTNTeRG9XY24A0Ur5MWbGBsOUzyOn6JFSTxMjYOMo1QeyMayBKDRV++EaMEsUcllbNn4XoUQ6d9t5FYgIcD0ymR9gAgxi2WbmIDFnRfCd2nQ/k5c4co0eey4H9vxqRg+uGtrkEHk+ropkATiXozIEPHCLzdGTaU4IpTvU6h3NLAW9UFyN1Otjbhp4XoU1WW1WnCuucUw2t4Af+EsQeMKZUJYeeVsJdKH+9nsvxBTi4HnuidSVxsR9thHmo61b0Wnt/WT2+ZE4aq6Z8J9y4HIZhLdKEhOvJmQdLwt83fKudGuhhkZ5D39C4rb9oFtLml32Pm5JBfJwuYCXsmLiUvoeOaAaGHdMWRtwT3011vwCA2QugLO3LaBUPQ60tDfYHgg73/8B3Z1PUjxMWzAVCDT1ZWXEuQkQySo2HpNs4dqQ+8sgf7Unz4PRe2/6kwfvydX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(376002)(346002)(396003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(6512007)(53546011)(478600001)(6486002)(6506007)(2616005)(71200400001)(7416002)(2906002)(4001150100001)(41300700001)(66946007)(91956017)(76116006)(66476007)(4326008)(110136005)(316002)(54906003)(64756008)(8936002)(8676002)(66446008)(66556008)(5660300002)(38100700002)(38070700009)(36756003)(122000001)(82960400001)(86362001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QU8veWxyUUozZkxxbkp3SHJZVWdFSzVFVW52Q2J1NXVzbVAvUDkxRmZqL2U4?=
 =?utf-8?B?TThSLzQyYVQ0algvcWxkNDIwRFBIeUtlYm9nRk9ibjd2eXFKRGxDRi9KNHZX?=
 =?utf-8?B?TW4va0RTa2tlNVZHTW9nNmZNbWpKTVlreTFsdEMxbUVvSXp2a3J0SlRROVZv?=
 =?utf-8?B?SElSMHJZcjV1czFMUEVpd2MzTGQ3dnc0RXpVSllweU9QQXVRbDV6YlQrZ3cy?=
 =?utf-8?B?SDBRZ1B1VkNUdWVPWEVUTGlCUEx5U3ZVWW1oSzE0aGNVUUpvNit3TUdSaUc4?=
 =?utf-8?B?aHBiaEkyM2ttcEZPRUlRWkNsVUxzL1Y0MzhQVm1lOXl4Y0FFdzR3c1NRSzNr?=
 =?utf-8?B?N1V4dHI2elpKZ1ZqOVhrbkNnWC9OSWtPKzFVZXJXb1pvR0tLTDY2T0oxTWZD?=
 =?utf-8?B?OFhjOXVTTHhpcFZlTzZQdVE5a1RieVpqK2pIc0I2NEROSkFKaWVpUHZHZ1Ja?=
 =?utf-8?B?SGxSZ3ZRN1BQalo4aEFoTFBzZ0dzL011enJCZGpNQXRKRVkvQzQvazVuMHdq?=
 =?utf-8?B?OTZIakZROGkxZnRFTGljWHVzaGhCVG1kU0Y3MTl4VDMra1Arenk0Ym14T2gy?=
 =?utf-8?B?VDEyTmdxdFFpVnlkNUdUd3RMZFpidlBPTldnOEJMV3dWeXhqUjY1c1IvSmx3?=
 =?utf-8?B?RDZzU2VFbkJCejd0SWc2NEZWWlhRRVBONDNLQTJkZlRiZVduaVRTcHR2R2xs?=
 =?utf-8?B?c3hYaHRRaG5uM2pVMk5oMWNHNzRZdVZsMDdIS0lGc1lQQy9WcTNNSE1LMFdI?=
 =?utf-8?B?ZVQ2dnlyNmVDUU5ITHpxZTc2VGNGVmhmMnlFZlYrY3YrZU16R1VkYlpIa1JI?=
 =?utf-8?B?MWNNT1o5NzFjSTlKaUxKZWZDeWJWaEZtMFhMR01QdVMwd3BsOWtlKzVGa1M3?=
 =?utf-8?B?RFpIU2NiM2w4MkJXUXVNMGl4WHM0RGFwUWVBc0tYa25MSHVGNFZWd2EvbHho?=
 =?utf-8?B?a05IQ21neXlnYnZNdWgxM2FDUTN1bkdUbzRmNlFDc1lwOVZrR0xBaWVpSHBE?=
 =?utf-8?B?RW02YzJWU0p2eWRITmJrUnhzRklKK283aUJCZkJTRzRFS3lDY1czNGVSVTgy?=
 =?utf-8?B?UUhQcFNyeDFzYnY1RFNDbnJ5V0N2TTJ1UlRGQ1h0ZTVRREYxV2F6OVA1SkFX?=
 =?utf-8?B?ZTRsMHZFaHdIWHlJWjgrU1ZucGphNmJzK2E0NlNUM1RyNldNbTgyWXlrTnhV?=
 =?utf-8?B?SzZhbTcyV2orWWFrcVFjM1V5SktMeUphcFlIZVhUd2lKUE9EcXU0bDJhd2Zi?=
 =?utf-8?B?RTNhUHl1akNNbnc1NlpFMTVOVHcrY1ZIdUIzVnY2VjZEM0NBNC96TGxhaUJI?=
 =?utf-8?B?VDdpVDMwbVorKzFiOW5Wa1JyV2N3MGM5TllENitvSEtneElFNS9RNjl6bGdJ?=
 =?utf-8?B?UVZadDFQQXFtWlJrYi9LMWdTSngvbHpNeitBdHlVMUlsdnp0QmxMSEplRkNJ?=
 =?utf-8?B?bUNYVEFMUWlZdm9abndPb1hCS1M2U1VDMzhYZ3dsM1RkQ3Z1Q1AvMk4zclAz?=
 =?utf-8?B?S1h3NS9DeU44MWpMcjgrZjBXcDRsbzl2VkhaK1NEZTE0eU9LNUNsN2tFYWor?=
 =?utf-8?B?c1ZyMzRTaWNoL1YvM2FDMXhsMThuL0xHMG9pWnJzOEd5MXE2TXRaQmhwSzdi?=
 =?utf-8?B?ZklHL1VlS28yTVZ6ZjQrOW0xSVVwelNiY2w4L2hnd1ZMblhWZVkrZUJXR1Vs?=
 =?utf-8?B?UmRmdVNGQ2RvYmJZNTl6OHBBV29HS3BZTHNUcTVaNVZyYmh5cFlhT1doMlhv?=
 =?utf-8?B?amVGc2hCT0FyQ1EvajQzNGtDZ3NwRHJZQkwveHh5QklwNlRtVkNibnozWGNB?=
 =?utf-8?B?WmM4K3hiNzNTa0hoOUEwVXA3cHBFTm9oU1I5eDhEZ0pzWkJYdXk3NkFUdnBR?=
 =?utf-8?B?Y0ZVQWpFbVhtKzFVd0NhZit3cEdLVVJRQjFHWjZUKzlYMVA1eERRNnQxRHZB?=
 =?utf-8?B?M0xrSEcwbWlKN0NrMUJHNTN1VHlVa1IrSEtqOGNpdDRSWGx6UkExTm5OZ3py?=
 =?utf-8?B?bklRZXRYQ0h2TXhqeGRackpKMXBHR0dGNjgzQlpuUkJNUWppMXlESUNndEtW?=
 =?utf-8?B?V3VqSnZsTmRiZExZbGtXQ21kUkNRQ2o1STNtM0QzRkJJNkJLb2locTdaUW5X?=
 =?utf-8?B?WUFPZElWd0gwc0lBaTlYbXR1WnhCWFJyU24yZkoxYVRNdGNSeWt0Q0VJbEVx?=
 =?utf-8?B?dlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EAB72DD6EF50E4ABA947D29700C9048@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9748f8-66a9-4d4c-9b28-08dbef7fc680
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2023 19:33:47.2750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OxVx+VVG1a0a3BHob+yr7fCa62IXpciNvlzrSQhqptlMubb4kobaj1GuipwVxqBDXjFGgBCb6cnnKPHH/BKJ/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5895
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTExLTI3IGF0IDEwOjEzIC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDExLzkvMjMgMDM6NTUsIEthaSBIdWFuZyB3cm90ZToNCj4gLi4uDQo+ID4gLS0tIGEvYXJj
aC94ODYva2VybmVsL3JlYm9vdC5jDQo+ID4gKysrIGIvYXJjaC94ODYva2VybmVsL3JlYm9vdC5j
DQo+ID4gQEAgLTMxLDYgKzMxLDcgQEANCj4gPiAgI2luY2x1ZGUgPGFzbS9yZWFsbW9kZS5oPg0K
PiA+ICAjaW5jbHVkZSA8YXNtL3g4Nl9pbml0Lmg+DQo+ID4gICNpbmNsdWRlIDxhc20vZWZpLmg+
DQo+ID4gKyNpbmNsdWRlIDxhc20vdGR4Lmg+DQo+ID4gIA0KPiA+ICAvKg0KPiA+ICAgKiBQb3dl
ciBvZmYgZnVuY3Rpb24sIGlmIGFueQ0KPiA+IEBAIC03NDEsNiArNzQyLDIwIEBAIHZvaWQgbmF0
aXZlX21hY2hpbmVfc2h1dGRvd24odm9pZCkNCj4gPiAgCWxvY2FsX2lycV9kaXNhYmxlKCk7DQo+
ID4gIAlzdG9wX290aGVyX2NwdXMoKTsNCj4gPiAgI2VuZGlmDQo+ID4gKwkvKg0KPiA+ICsJICog
c3RvcF9vdGhlcl9jcHVzKCkgaGFzIGZsdXNoZWQgYWxsIGRpcnR5IGNhY2hlbGluZXMgb2YgVERY
DQo+ID4gKwkgKiBwcml2YXRlIG1lbW9yeSBvbiByZW1vdGUgY3B1cy4gIFVubGlrZSBTTUUsIHdo
aWNoIGRvZXMgdGhlDQo+ID4gKwkgKiBjYWNoZSBmbHVzaCBvbiBfdGhpc18gY3B1IGluIHRoZSBy
ZWxvY2F0ZV9rZXJuZWwoKSwgZmx1c2gNCj4gPiArCSAqIHRoZSBjYWNoZSBmb3IgX3RoaXNfIGNw
dSBoZXJlLiAgVGhpcyBpcyBiZWNhdXNlIG9uIHRoZQ0KPiA+ICsJICogcGxhdGZvcm1zIHdpdGgg
InBhcnRpYWwgd3JpdGUgbWFjaGluZSBjaGVjayIgZXJyYXR1bSB0aGUNCj4gPiArCSAqIGtlcm5l
bCBuZWVkcyB0byBjb252ZXJ0IGFsbCBURFggcHJpdmF0ZSBwYWdlcyBiYWNrIHRvIG5vcm1hbA0K
PiA+ICsJICogYmVmb3JlIGJvb3RpbmcgdG8gdGhlIG5ldyBrZXJuZWwgaW4ga2V4ZWMoKSwgYW5k
IHRoZSBjYWNoZQ0KPiA+ICsJICogZmx1c2ggbXVzdCBiZSBkb25lIGJlZm9yZSB0aGF0LiAgSWYg
dGhlIGtlcm5lbCB0b29rIFNNRSdzIHdheSwNCj4gPiArCSAqIGl0IHdvdWxkIGhhdmUgdG8gbXVj
ayB3aXRoIHRoZSByZWxvY2F0ZV9rZXJuZWwoKSBhc3NlbWJseSB0bw0KPiA+ICsJICogZG8gbWVt
b3J5IGNvbnZlcnNpb24uDQo+ID4gKwkgKi8NCj4gPiArCWlmIChwbGF0Zm9ybV90ZHhfZW5hYmxl
ZCgpKQ0KPiA+ICsJCW5hdGl2ZV93YmludmQoKTsNCj4gDQo+IFdoeSBjYW4ndCB0aGUgVERYIGhv
c3QgY29kZSBqdXN0IHNldCBob3N0X21lbV9lbmNfYWN0aXZlPTE/DQo+IA0KPiBTdXJlLCB5b3Un
bGwgZW5kIHVwICp1c2luZyogdGhlIFNNRSBXQklOVkQgc3VwcG9ydCwgYnV0IHRoZW4geW91IGRv
bid0DQo+IGhhdmUgdHdvIGRpZmZlcmVudCBXQklOVkQgY2FsbCBzaXRlcy4gIFlvdSBhbHNvIGRv
bid0IGhhdmUgdG8gbWVzcyB3aXRoDQo+IGEgc2luZ2xlIGxpbmUgb2YgYXNzZW1ibHkuDQoNCkkg
d2FudGVkIHRvIGF2b2lkIGNoYW5naW5nIHRoZSBhc3NlbWJseS4NCg0KUGVyaGFwcyB0aGUgY29t
bWVudCBpc24ndCB2ZXJ5IGNsZWFyLiAgRmx1c2hpbmcgY2FjaGUgKG9uIHRoZSBDUFUgcnVubmlu
ZyBrZXhlYykNCndoZW4gdGhlIGhvc3RfbWVtX2VuY19hY3RpdmU9MSBpcyBoYW5kbGVkIGluIHRo
ZSByZWxvY2F0ZV9rZXJuZWwoKSBhc3NlbWJseSwNCndoaWNoIGhhcHBlbnMgYXQgdmVyeSBsYXRl
IHN0YWdlIHJpZ2h0IGJlZm9yZSBqdW1waW5nIHRvIHRoZSBuZXcga2VybmVsLiANCkhvd2V2ZXIg
Zm9yIFREWCB3aGVuIHRoZSBwbGF0Zm9ybSBoYXMgZXJyYXR1bSB3ZSBuZWVkIHRvIGNvbnZlcnQg
VERYIHByaXZhdGUNCnBhZ2VzIGJhY2sgdG8gbm9ybWFsLCB3aGljaCBtdXN0IGJlIGRvbmUgYWZ0
ZXIgZmx1c2hpbmcgY2FjaGUuICBJZiB3ZSByZXVzZQ0KaG9zdF9tZW1fZW5jX2FjdGl2ZT0xLCB0
aGVuIHdlIHdpbGwgbmVlZCB0byBjaGFuZ2UgdGhlIGFzc2VtYmx5IGNvZGUgdG8gZG8gdGhhdC4N
Cg0K

