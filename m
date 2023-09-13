Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1691379DF1B
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 06:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbjIMEQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 00:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjIMEQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 00:16:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E424A3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 21:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694578554; x=1726114554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MjpAeG0fIW2YjKIVXa7umdJBCp7nGeN2AFMsMB4VwDQ=;
  b=SNG4m0izAcJauRiycwcBFccG9NezzbhdoInz7LS38xI0IqHKyXvpSD4z
   UCMu69aqZuUz6M3+QvUNwn5/UFFPoqqrGzbEWPsDCro/VJA8PpXF/QEsf
   c6FHaYY001rmQ62zrFPm8OMrTd79V0GSoduF2ZPmVctzcY2sRXAwmMcvM
   R6OtiC905Y3JesFxomn4UhhsawLZVBLIvNxbkfS6ZLbCdLgpH+zLzvZfg
   bBtF005yM0Btzl4KRlQtW9z5qrYn5ovJIaYRJh8BX0fDPF8NkfCDh9Yto
   cXVNGyH31IkPCkx0caJ9Tf4gOiPybxR61/bhfBNz/hqyCYX4bIb9uIeK2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="382366497"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="382366497"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 21:11:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="743966804"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="743966804"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2023 21:11:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 21:11:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 21:11:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 12 Sep 2023 21:11:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 12 Sep 2023 21:11:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceICiGLSAE+uBgs6HVgOMsNzcJ8mE1oKMW7Vaasc3N3P5EBHEdBqbzoOYeHsCtpLdi/Z7EaCkB6Z+BOMzew2Dztt68pKcJFfywM/VMk5CjhPgaHzfaSYl+RLV/2wv9YUG6CxaTFwGiZinisoHV20ZkgURcyE7nOEPqGs0UR6Hvnu1imi4JuIKUP1DFoX5qiUnheDKqq+jXmECWLz/ZFssU1rRbfHdV4E//xXCx6z3ZHS3H/3FVgHwkhBxug6+LS2c+UVJNTw5cFZu5zV3WzdI//y+oFqMkrBg+6I9x6yhd01IghNVh7xNsXCxL3aZHfKRJAyqnOdXF+7zPl+tLdH7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjpAeG0fIW2YjKIVXa7umdJBCp7nGeN2AFMsMB4VwDQ=;
 b=fBpT2/h90wjB8SBrV2iyH1PICvLJBe1fmV4jEgi3xdxmK9/dlsvh5I9naj96lo8ZxVwMq23vkUFpAxCYm+jPuSh/ZwhoDWs+73ns2TpyrzpZ1h6TL+zW9HLE85+7GLRr5eMdst9E1xs/w2vgsNSIs6clw3a4OmiWG1YV8JbnROHRjzyZmar4x8V1Qc8+Ym4OYtVYBQs7vOLfXaD9h6jL0Hto9cL3fPh8y4/pq2MyFZnBSVgCr5ztcGFI8CzzEpL9QV5M0DtAYVYOnAS3URTWgowqcHhzFYSkPnwg+MniMIe7sBhIVmovczZpXCI4tXLGs3O/pj5CCC3FclJAvA4BJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by CY5PR11MB6116.namprd11.prod.outlook.com (2603:10b6:930:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Wed, 13 Sep
 2023 04:11:39 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032%7]) with mapi id 15.20.6768.029; Wed, 13 Sep 2023
 04:11:39 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 7/9] KVM: x86/pmu: Add fixed counter enumeration for pmu
 v5
Thread-Topic: [PATCH 7/9] KVM: x86/pmu: Add fixed counter enumeration for pmu
 v5
Thread-Index: AQHZ3KYZah5WpAUbbUOXIa3Ji5d/4bAXHhKAgAEP9vA=
Date:   Wed, 13 Sep 2023 04:11:39 +0000
Message-ID: <MW4PR11MB5824D13EFE1D1C1B8F78527DBBF0A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-8-xiong.y.zhang@intel.com>
 <d0cf6ba0-94af-2ffc-b086-b90572e5ce98@gmail.com>
In-Reply-To: <d0cf6ba0-94af-2ffc-b086-b90572e5ce98@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|CY5PR11MB6116:EE_
x-ms-office365-filtering-correlation-id: 62489774-3ae1-4970-e3e4-08dbb40f8795
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ezb6bCjGZ8SlSgrBc3bSmSJTTEPdiaVN3vnTQ3MU4wrJx/PVNfybG5rAhqcMGcqkT+r7pFlzTeqiO8gy07yZmhx7dXNavXdDBuMWKXtwGvpOTrGMDdHvMOVvqeP3nInJvhvm6WwHWA7OSxIB9YuBGXt1QUmcaTpemY0bdvrgKRxZsJgDP6pPaVtB39D1Th4kNEJdPvTQf/tagK37UoyS+vbglktVc2A0cux39uz8Re5k5ebe2knsrivAaPpTxVKZJbnp2y3jvyuaFLXPzeAB+Ph9uMdbY984eWCYCj0bo+WK/KA7D8VdctP7lzec2No4+XSEFRVeUfBhTmAdzzMM22a/u+7bN3hkyzGr6LCIcag35JBVoNLFJTa0A9uIlmzQRKVoe27DK5/vaW6Fs9Au8mn1x6BAsgPw/i1X8rdT6wRFx087fkGXccH5G5tnL0SeOvf3ehqKW+pupeK5B8SegLbV3GXZtuB9B/O0oazpuhw78ekssM/p0Nba7QH1bUYxNEAh+6FMpC3nJHXjJ3Y7ZNkb7/07xFX2QFlT5VeMVPaKG2Y0LI5abi8DZtJFeMGtPD3otbvUq8uXE95NmdfkojR9bogkUZhI/Y0ys7DxndSYtLQsf9OUSs9zzDrKjQOU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(1800799009)(451199024)(122000001)(82960400001)(38100700002)(38070700005)(55016003)(33656002)(86362001)(2906002)(9686003)(4326008)(71200400001)(478600001)(53546011)(76116006)(8676002)(6506007)(7696005)(8936002)(64756008)(52536014)(66556008)(66946007)(66446008)(5660300002)(41300700001)(6916009)(316002)(66476007)(54906003)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tkk0WEVjUGxzdFozOTZ5azJVaFV2bE1uTzdWN1R5bnZmeEx4SStQUjBRMmhi?=
 =?utf-8?B?dDVpUGxia2s1VVFEZUxBcGRnWThqZFlyVS95TEYyZmVuR1RNMDlVc3pSYk5Y?=
 =?utf-8?B?eHI0TVZtWU1ybDlnQWFMNTMzSk9ySm1mN1Y4dVczZU0weFRxT2dxRkpVRXRI?=
 =?utf-8?B?QUoydVdiZmkxd3pVUzZSZWl4dE8yWU9ZK0lsekNuNWdXQWoybjZGN2tKRWs5?=
 =?utf-8?B?Y0FVUkZRY2hkeXQyMVFHNCtKN24zTXZORkxkMU1UbzFndnRyV01EdG5nTC9w?=
 =?utf-8?B?bWovK3pzK2xLTGdEYXNwQ1RQamV1N21ncmh0WnpCV2pOc2NKanRCeDRjaHM2?=
 =?utf-8?B?bzhqdE9pall0dkk4d1A1ckwrdy9pWHlveEpaTERBZ0dnWXN6amFna29zMUNq?=
 =?utf-8?B?NlgrVWtPbFNvT25lTEJSanp4WGhVUHl5UWRiZlVvLy9BWUQrcHV3cUxLVGM2?=
 =?utf-8?B?d1RjSnVrSnI3QWJUOGd1c3RnUjkyZXZVZmtndTlZdFgwaUJwdUJ4bE4rRkVj?=
 =?utf-8?B?V0hnNUVKcXMzUFRreW0vLzhwNWhqUFhVL2RIdFFYVUlGc3VvZ1RKMUQ1bUpK?=
 =?utf-8?B?MXhtK0xqeWhWZ0JidUxVSkNzVXlORU53RmZjVW9Ndmw3dDZBTUZJNU56Qkp2?=
 =?utf-8?B?dEVDclBWMm4zZUoxWkdDMExTZUMxcHNvM050N0lGVXJDRjBRWnR0N0I2Zkdu?=
 =?utf-8?B?NThXbzlmeDFaTmZ5b0RWR29OSEJuZDFGMDNHTTVxSDhUeHRGRlBZaEh2Z0gw?=
 =?utf-8?B?UWlWcmpHVFlmV2ZHd28rL3FzdHFqbHlKaXFucUY0OFhXei85c1Z0TEdndXV0?=
 =?utf-8?B?V0xNTEx3MGs3c0MvM3V0TDlEWW1WWjFzMzQwNENXc0RWYit6S2U0L2M4cDZj?=
 =?utf-8?B?bEI1ck9hblNjR3RYWERBWUhCUDY0T0VKQnM4TXFGcmU4bFNweXFScmwzdHM2?=
 =?utf-8?B?VVFxSHB2ZEt5ZkhDM3NYSnlRVXV1aWswNTdod1ZJL0E3a3kwMDdiZmtlRFlS?=
 =?utf-8?B?U1V1NUY2NFFIaXNlMUVUb3FmbC9tWWlOdTg2NXY5RFB0NzFEb0p2MlEzeFZX?=
 =?utf-8?B?ZTBBR2c2c2QyT1pxSjgrTDB3MlpmY1FBU05YaEl4Sy9VbmkyVXlCUm02cVY5?=
 =?utf-8?B?RnBSdjAxUG5YdWRHTU0zYnpWV1FIWWQrM0NOS1hQcS9LekxPSnRoSFNPYUM1?=
 =?utf-8?B?bDd1Y09RU3Zya0NTSWdOeERwN3RWd3hwSjBPbklRRGo2VEZLbys1emhBL3Ju?=
 =?utf-8?B?TzFoMlhFdVZuSFp0MzJDYWFsVmdSWWpuY0xHT0daL2VTRi9QcXdhWC9tZC93?=
 =?utf-8?B?bjV3dXMwMVhpZVAxQi8xQlZ0RFVKdi90V1k5QkhHMjNmWm40ZUNjM0dBV21p?=
 =?utf-8?B?eVRuejBvQ1oxT1hQTkliQnhGeHljZXpFRHpQTDJRSDRoaXdSaHN4Vm1OUzIz?=
 =?utf-8?B?Mjk1dCthN0NyRWpnYjBhU3RFSFk2bFRnSUM5ZnNrOEkzMDFnYWZqNVlhc0I0?=
 =?utf-8?B?OGRHVEl4K1d0eDBBTS9WNVYwVXplRzZxS0VYNVF3MVJrWWRlSWxMVTVJdEQx?=
 =?utf-8?B?Sm9sVmFTUjBkZGlGUDh0ZlJGZVNkanZ5aCtWNW14TVBmbkRLcFNLWlArdmlq?=
 =?utf-8?B?aEpVUjBTQ1pDdEg5VjY0aXVKejNsanh5L08zYVdRWkVIYnlTVVkraEI1RkE5?=
 =?utf-8?B?WkNReUxXaE9EdUVxVlU5Mlp3ajdsRndpZFNsclBSbk0xd0RLZVU5bHkxeUc1?=
 =?utf-8?B?ZlZnNzE3SFBiR0V3bmlNN1B2SzVMQ3pQck8xM0E1WFdDOCtKVG5LVUE0eGRX?=
 =?utf-8?B?M0xaZjkzMW1FM2c2QnE4ZjZUYjZyQW1VenpkWWNYL0piYU5OVkpJeW1ESzla?=
 =?utf-8?B?VGNNc1IraW1kOCt2eStqSTJXL2lEcDFpTG1hRlltOTN4VmNWdkR0YTZSQTlR?=
 =?utf-8?B?dkdlVUpRUzQwZ0Era0FYeHNrK0Z3dXQ4eklHZTk1R0NKUEFkcVh2MzFtOU85?=
 =?utf-8?B?RFdDOXFCdGN0S0JRY1NKU095VkFmMjJCUkdHekptMDVHbitTcHBVWmo5Q1Iy?=
 =?utf-8?B?SGpLeVFONVh6ZjBMVjZsUVZlSi94T1RBSW16WHRCT2dHd1NxeENMVDltU1BR?=
 =?utf-8?Q?JN2ORK1d4AUgNewrAL350bAVh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62489774-3ae1-4970-e3e4-08dbb40f8795
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2023 04:11:39.4858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LPdgyQYyBjwQcazO1LM3CLI6SSq1O+Kiiz7Yj2/pIzsTy6DZFPEUGkWC1Fw6KMOI1vne+8qB/5eZZEZMVABthQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6116
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAxLzkvMjAyMyAzOjI4IHBtLCBYaW9uZyBaaGFuZyB3cm90ZToNCj4gPiBXaXRoIEFyY2gg
UE1VIHY1LCBDUFVJRC4wQUguRUNYIGlzIGEgYml0IG1hc2sgd2hpY2ggZW51bWVyYXRlcyB0aGUN
Cj4gPiBzdXBwb3J0ZWQgRml4ZWQgQ291bnRlcnMuIElmIGJpdCAnaScgaXMgc2V0LCBpdCBpbXBs
aWVzIHRoYXQgRml4ZWQNCj4gPiBDb3VudGVyICdpJyBpcyBzdXBwb3J0ZWQuDQo+ID4NCj4gPiBU
aGlzIGNvbW1pdCBhZGRzIENQVUlELjBBSC5FQ1ggZW11bGF0aW9uIGZvciB2UE1VIHZlcnNpb24g
NSwgS1ZNDQo+ID4gc3VwcG9ydHMgRml4ZWQgQ291bnRlciBlbnVtZXJhdGlvbiBzdGFydGluZyBm
cm9tIDAgYnkgZGVmYXVsdCwgdXNlcg0KPiA+IGNhbiBtb2RpZnkgaXQgdGhyb3VnaCBTRVRfQ1BV
SUQyIGlvY3RsLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWGlvbmcgWmhhbmcgPHhpb25nLnku
emhhbmdAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYva3ZtL2NwdWlkLmMgfCA1
ICsrKystDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2NwdWlkLmMgYi9hcmNoL3g4
Ni9rdm0vY3B1aWQuYyBpbmRleA0KPiA+IDk1ZGM1ZTg4NDdlMC4uMmJmZmVkMDEwYzllIDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS9jcHVpZC5jDQo+ID4gKysrIGIvYXJjaC94ODYva3Zt
L2NwdWlkLmMNCj4gPiBAQCAtMTAyOCw3ICsxMDI4LDEwIEBAIHN0YXRpYyBpbmxpbmUgaW50IF9f
ZG9fY3B1aWRfZnVuYyhzdHJ1Y3QNCj4gPiBrdm1fY3B1aWRfYXJyYXkgKmFycmF5LCB1MzIgZnVu
Y3Rpb24pDQo+ID4NCj4gPiAgIAkJZW50cnktPmVheCA9IGVheC5mdWxsOw0KPiA+ICAgCQllbnRy
eS0+ZWJ4ID0ga3ZtX3BtdV9jYXAuZXZlbnRzX21hc2s7DQo+ID4gLQkJZW50cnktPmVjeCA9IDA7
DQo+ID4gKwkJaWYgKGt2bV9wbXVfY2FwLnZlcnNpb24gPCA1KQ0KPiA+ICsJCQllbnRyeS0+ZWN4
ID0gMDsNCj4gPiArCQllbHNlDQo+ID4gKwkJCWVudHJ5LT5lY3ggPSAoMVVMTCA8PA0KPiBrdm1f
cG11X2NhcC5udW1fY291bnRlcnNfZml4ZWQpIC0gMTsNCj4gDQo+IElmIHRoZXJlIGFyZSBwYXJ0
aWFsIGZpeGVkIGNvdW50ZXJzIG9uIHRoZSBob3N0IChlLmcuIEwxIGhvc3QgZm9yIEwyIFZNKSB0
aGF0IGFyZQ0KPiBmaWx0ZXJlZCBvdXQsDQo+IEwxIEtWTSBzaG91bGQgbm90IGV4cG9zZSB1bnN1
cHBvcnRlZCBmaXhlZCBjb3VudGVycyBpbiB0aGlzIHdheS4NCklmIHZQTUMgaW5kZXggZG9lc24n
dCBleGlzdCBvbiBob3N0LA0KZm9yIGJhc2ljIGNvdW50ZXIsIHRoaXMgZG9lc24ndCBtYXR0ZXIg
YXMgS1ZNIHN0aWxsIGdldCBob3N0IGNvdW50ZXIgZm9yIGl0Lg0KZm9yIHBlYnMsIHRoaXMgd2ls
bCBkaXNhYmxlIGd1ZXN0IHBlYnMuDQpJcyB0aGlzIHJpZ2h0PyBBbnkgb3RoZXIgcmVhc29ucyA/
DQpTbyBoZXJlIHdlJ2QgYmV0dGVyIGdldCBlbnRyeS0+ZWN4IGZyb20gaG9zdCwgc28gdGhhdCBn
dWVzdCBhbmQgaG9zdCB3aWxsIGhhdmUgdGhlIHNhbWUgZml4ZWQgY291bnRlciBiaXRtYXAsIHRo
aXMgbWVhbnMgd2Ugd2lsbCBleHRlbmQgcGVyZl9nZXRfeDg2X3BtdV9jYXBhYmlsaXR5KCZrdm1f
cG11X2NhcCkuDQo+IA0KPiA+ICAgCQllbnRyeS0+ZWR4ID0gZWR4LmZ1bGw7DQo+ID4gICAJCWJy
ZWFrOw0KPiA+ICAgCX0NCg==
