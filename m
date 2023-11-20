Return-Path: <kvm+bounces-2063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD667F1297
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:01:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE5771C21763
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F8918E06;
	Mon, 20 Nov 2023 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NwWY7wGV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6ED8E;
	Mon, 20 Nov 2023 04:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700481687; x=1732017687;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zq6gjXlM7oQO7rcfVqA9yv3xQiFQjMaLg2sfs3Wz8H8=;
  b=NwWY7wGVgLQ6O3ZCFSc4mK8QhToDVEqfjVE6Q66NJ7+QexMzof7zuM+W
   rKYxx/0nXf39WoQqU+ItzVaVDSMm075/5Ks2rdgpPHoY+eaVVCxSPs4WD
   gj1nt+d5JaVmUvt/FS3nn/y7e4YFHloRWXliMHY7HjYQGTqkMGexAfIpC
   9JH8dcLOhUInqXPAsNOsql2TlkIPdUdh9aDfhTCpVphz13eAVnbCdKRwe
   wyTeCVwQku6T8WI/6zlppgofRHD7qNhTgKVALrD7UVEOKY70MS4P4ALB9
   GDvvAaWt54u3txoekA2RfQl9aYHl9NqisexqVkQChmq884A0lF+rZPbCC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="10279909"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="10279909"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 04:01:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="939779616"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="939779616"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Nov 2023 04:01:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 04:01:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 20 Nov 2023 04:01:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 20 Nov 2023 04:01:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqZz3MVwtLDDcqfVUwJMFTi9ytEc4f+2yVWMkdLQH5YtPQ/yRpanf6BFcMy9DPeGXg6buzeWw3PsU5h8M9QKZUJbehBOuORzLIZ1K9B/0w47yvNZCz/lncr3RmflyFVpCp+1gR1qBzjW/L8FOrjJYYgzGMH6vRqkX53ys8ZKy6zHP7EaLRhkIrPOlV9ZfWZJJzFm6k3hUa40815DRa36E5+409f+nglaO2sE2CqAQheXtM8O84AdeBnPLMzW1R7fu8Xr7vJo1k6EbB6wkRsYoD0lFOIdMUzqh1LAuhbgFPGmAaTPAqZUTASIfxbz4nbhkpa1xUKP9YiU+mbxc2HIVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zq6gjXlM7oQO7rcfVqA9yv3xQiFQjMaLg2sfs3Wz8H8=;
 b=NbbZIPAt0N1a8pCmerz4OtzsLNezIP2WrpmcGkWq44WEXvPt4Hp/PJDpYLoB4DBnQmoxwSusdEJDfHGW/qUjP0L+NcCGzkr28uXhfrRVzHJ6nLJKkfpvHJUwaJZvAoiI4M4miczk+RMqRJMRAuB7NagQ2yN8/64bbPHwil8HIEjfSKaUmxP3GEZiM7ldXIqQ9VeymxSSRa2n/NnEXOybauUAHtzEGCSkKz0aIdLP0T6g2ZpmKQEbeZ0iD/SvCH7mejd8NCmBtP44nIEqYDm024pQNl5mnMC4UBAx1WgYjhyLQNGDUW2JQ8Te+29+4e6eJ+N5V4vz/lujlIQKHKoP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DS0PR11MB8685.namprd11.prod.outlook.com (2603:10b6:8:193::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.27; Mon, 20 Nov 2023 12:01:22 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::6a55:3e93:ac5f:7b6d]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::6a55:3e93:ac5f:7b6d%4]) with mapi id 15.20.7002.026; Mon, 20 Nov 2023
 12:01:22 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Christopherson,, Sean" <seanjc@google.com>,
	"Shahar, Sagi" <sagis@google.com>, David Matlack <dmatlack@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang,
 Tina" <tina.zhang@intel.com>, "gkirkpatrick@google.com"
	<gkirkpatrick@google.com>
Subject: RE: [PATCH v16 059/116] KVM: TDX: Create initial guest memory
Thread-Topic: [PATCH v16 059/116] KVM: TDX: Create initial guest memory
Thread-Index: AQHaAEyrBpVPWseLVU+0s47fedmgi7B+Z8cggAC9NoCABCxt4A==
Date: Mon, 20 Nov 2023 12:01:21 +0000
Message-ID: <DS0PR11MB6373963DEA9B38DAAD38F7CBDCB4A@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
 <edccd3a8ee2ca8d96baca097546bc131f1ef3b79.1697471314.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373EC1033F88008D3B71568DCB7A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20231117201523.GD1109547@ls.amr.corp.intel.com>
In-Reply-To: <20231117201523.GD1109547@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DS0PR11MB8685:EE_
x-ms-office365-filtering-correlation-id: 7551e026-88fe-4383-6f2c-08dbe9c0698b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +NG82FnPElf/3SbzNDkVZvkKDeVFV3cm+RxRnBHtnBaVdtS4qrjArqqPzF6LJ/AZCaQ6EFVgSsl9t0k6pnLYfGl0vCTVnLr2Ovm4pHPDvwHk3IIF5Cb0AzD5oHeMsLVXogT4HL11ebKRRAS35t4+ECpYZq8j13LepE8RgF6EeIm0/5vqyNiezfyW22x5rTtJKHerMXqMmJLu6cK6Xbz3THoPlB5/qD7dVUry2kEG26tnuPU+8CF4gdsO14PSgir2M93bjJLnbz6AVttqh1Q7OiTgcukoSyVs7IcAHGgeUdKwgOpD8kxaBckAX4djoRcKIiLBVp6aQeBty+ofZKUQvKUXuA/gqlO/N/Q/Jib2EXDLfcCRtED31dWfhQUVl1rqIQHFGCObOt46KwD2haa60eV8kSjMAkgHhbG9mI0604AKVpqB5GokrxUt5yQt01N7VIaQJV/5cSd40gVdd0RSnG+fjOoX5HZUe+AP9JFC5zfY0s0T/p1e91SdW7hRxShDjf7KgRtWCT+eWYcB6xgKie1ynT+/UG8u1sjC1IGVK5yuvnU1u7sfRfnRcyjmKbRKpoxT3NS1PhYTGFdtAT4yN2m2aICeFRWmhZYTP/tsOXg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(366004)(136003)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(9686003)(53546011)(26005)(4326008)(8676002)(38100700002)(52536014)(8936002)(41300700001)(7416002)(2906002)(4744005)(5660300002)(478600001)(6506007)(7696005)(71200400001)(76116006)(6916009)(64756008)(66446008)(66476007)(66556008)(66946007)(54906003)(316002)(33656002)(122000001)(86362001)(82960400001)(55016003)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEZDYzBoNUJwdHdTZEl1UVJualdwblNxMGkvbHdRa1JGVzdLRkZEWjBhT3k4?=
 =?utf-8?B?eU9XYXhBRFROUmdtK3hzY1lJQUpmclZZdDB3MFpyOE1HRi9oMEhlZE1zYUFu?=
 =?utf-8?B?UHJWMUEzMnJkSmwvMUF5NHlkNG5zcVhXTUg1dnBhNHdsWERLOTJGRnN5TDFn?=
 =?utf-8?B?WXNFbTB6SmNvbG1uY2ZkUDVsUWl2NjNhQjlMZ2gyU2FjblZEcUt5dEZjK2Y4?=
 =?utf-8?B?bjFmbVB0bmFNbW44c0R1Q1IxWWRhMzcxcTNnKzYvSVJCaVJtUmRmR1hDNHhM?=
 =?utf-8?B?azRJSkdlcTliS1pUSzczcEpJL0hzdlNJTHY2RVo3NlFUbi9lbTNMVUlyejlW?=
 =?utf-8?B?YzBmVWlZMFRXQTk3NU40OFhhRjBHY3hzNTV6WS9sQUoyTk0yc080OGxQNjZE?=
 =?utf-8?B?Rm4vMEV2MGFNdkJ4N0l5dndmRVZCSDgzdCtISWtLYU5CbHZiY1Zhd2VFN1hI?=
 =?utf-8?B?Y0tFR29XNUpHc0UyRktMSzZpaUZFdzljOC9kUDltZ056THR5bWlaYlhmdGtR?=
 =?utf-8?B?OEhzUC9Zd0l2cUE2MWkyTW5heHdPQjFYbWdEZXF5V1hGemMvMWozOWhPZlF2?=
 =?utf-8?B?djBFV3VsUlNLYUVXUUU5czZscmExb2hPc05Ib1hFd0Q1b00yS1lZeVVaK0pX?=
 =?utf-8?B?dk5icVpzNXpHeU0zM01pWEI2c2dMZ2dSMVlqNGM2Q3o3ajBoTzVBaEpEeVlL?=
 =?utf-8?B?bHg1Sjd2aG41Q0twZityeUc2WnFBamx4dWtoNzhrRkczeFZZT0RsRVg3ejJY?=
 =?utf-8?B?ODNmeHFKa21qWWk1OHdSSzcwK3BEbzRpd3M5bHZvKzRVWFJNVlFkRGxxYW9C?=
 =?utf-8?B?REVoYkpaczdHbElTUjdVQlNBUmR2SG8vSVQ2VzJUZFY5M2lidFp1UlZ6Tnhq?=
 =?utf-8?B?YnRlRm93TUFyQzV5eDl3b1p5d1VydmdHY2cwV09ocG0xN1grK0drVWJ1Z3Uv?=
 =?utf-8?B?LzV6T1dUSzE3WUM2QkNEenVKUHNHMDBMeUFDSmxKZmRDMFpkR2FXRXk4Wncv?=
 =?utf-8?B?M2lXV2pGUDZRZlUwZDd3TmVYckdROUltT3FrNkNvNHNRdHowNUlpelE5cW5t?=
 =?utf-8?B?VWZkR3RnS3dOUTNBN1Iyc1l3Nlc5Y1lDTlRxblJ3M3pDcVovOHFCY1R0cFhG?=
 =?utf-8?B?elVXTjYxMU1HTVoyYTRqRG1icDdLK0YwdVdxKzNhRWlQSUhGbkJadkJjdHFn?=
 =?utf-8?B?SGJOZ3VvY2RPNWthSzl1MkNTTGR0UWZkS0tyRmFRcGt1UXFzbTBWVW0wUlNa?=
 =?utf-8?B?aUFFTDF3T1FkZEhFYTVxMVlRcDVaNEFpbkREMFd4THdxNWtYL1FDTFEyOGF6?=
 =?utf-8?B?SVV1TG5JWXFuSkx5ZEpXOVF2YXdrRE5NSXd1YitWTWZaVDFBd2pwc3pqa1Vy?=
 =?utf-8?B?Z0JiYzVoQzRhckUydDZIKzFud0tIcys4dHFkcFNHZEYxUC8xY3orTTlwelF0?=
 =?utf-8?B?NTBBbnhQcWo4bU00a0RYTWNiOERIMnJhTUdSL3Z6dEViZlFSemswNWM1SVEv?=
 =?utf-8?B?K3REWnkzaUVsdEUrSUd4bkxpWHJuUTc4Ymh3WEJLVjk5N2FEV1dQSGlkTFhK?=
 =?utf-8?B?MFJVZm5XY0JJbUZ3cGZZUWprb1Vham5lVTg3N0JZUFdXYWJCdVhMUjZiUFg2?=
 =?utf-8?B?U0ZQTEhPOVRUOWJ1cTZDdUpZNWNwWWxpUDlQUytXZklDeEtlSk0rak1BYnBK?=
 =?utf-8?B?czZvZkN3akpWaGlUYTlmOEhSdG9wT2lDRDRjdm80N3lSSklJdHVieE5JNjlw?=
 =?utf-8?B?L0FXUUl0TFR2NzFwZmg2UTIrZmZUc2JRWWJVTHVkUzFSM21qa1VPckhoU3Fu?=
 =?utf-8?B?SUZmSVBTZGhVb1ExRURkOHl4L0RCTGpyc2lQWnZhUCtjR2pic3h2V3dLdEFD?=
 =?utf-8?B?LzdPMHFzTDZGYmhLM1F2NEUycXdqcjNXR1hFeS83MWRnVU1tNTgzaitPUXRR?=
 =?utf-8?B?UlV6Q3lCZk45TFc5YmFmV09rSFYwOE1ndDJDODNkSmx3WXlaMWdVRi94ZFlS?=
 =?utf-8?B?cis1R3VVU0Zyb3ZiS3VIRUhkaktwZ2lQd1Boa1lXVDhlMW05SW1rVklyN3hL?=
 =?utf-8?B?MzB4b2t2MzRDNzJGalUxa1hiVGtCclFDKzYyaFllcjZpSHB1T09LUnNScG8r?=
 =?utf-8?Q?KbhfxgqYrQgeKRYAdSyhbLNsx?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7551e026-88fe-4383-6f2c-08dbe9c0698b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2023 12:01:21.6465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kP08wKDmHqGsxit+ACQt6AZxttTrSps+4st6TUrChDtf01VipBbnaZW/585mVXU21PVHkOB8hr6fjPjOc2Uzng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8685
X-OriginatorOrg: intel.com

T24gU2F0dXJkYXksIE5vdmVtYmVyIDE4LCAyMDIzIDQ6MTUgQU0sIElzYWt1IFlhbWFoYXRhIHdy
b3RlOg0KPiBQbGVhc2UgcmVmZXIgdG8NCj4gc3RhdGljIGludCB0ZHhfc2VwdF9zZXRfcHJpdmF0
ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZW51bSBwZ19sZXZlbCBsZXZlbCwga3ZtX3Bmbl90IHBmbikNCj4g
DQo+IFRoZSBndWVzdCBtZW1mZCBwcm92aWRlcyB0aGUgcGFnZSBvZiBnZm4gd2hpY2ggaXMgZGlm
ZmVyZW50IGZyb20ga3ZtX3RkeC0NCj4gPnNvdXJjZV9wYS4gVGhlIGZ1bmN0aW9uIGNhbGxzIHRk
aF9tZW1fcGFnZV9hZGQoKS4NCj4gDQo+IHRkaF9tZW1fcGFnZV9hZGQoa3ZtX3RkeC0+dGRyX3Bh
LCBncGEsIGhwYSwgc291cmNlX3BhLCAmb3V0KTsNCj4gZ3BhOiBjb3JyZXNwb25kcyB0byB0aGUg
cGFnZSBmcm9tIGd1ZXN0IG1lbWZkDQo+IHNvdXJjZV9wYTogY29ycmVzb3BuZHMgdG8gdGhlIHBh
Z2UgdGR4X2luaXRfbWVtX3JlZ2lvbigpIHBpbm5lZCBkb3duLg0KPiANCj4gdGRoX21lbV9wYWdl
X2FkZCgpIGNvcGllcyB0aGUgcGFnZSBjb250ZW50cyBmcm9tIHNvdXJjZV9wYSB0byBncGEgYW5k
DQo+IGdpdmVzIGdwYSB0byB0aGUgVEQgZ3Vlc3QuIG5vdCBzb3VyY2VfcGEuDQo+IC0tDQpZZXMs
IHRoYXQncyByaWdodCwgdGhhbmtzLg0K

