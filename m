Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19EB7A23AA
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbjIOQgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 12:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbjIOQgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 12:36:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7ED268E;
        Fri, 15 Sep 2023 09:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694795768; x=1726331768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mUtcpW4d/T3/83IziQbrfenDipsGqCFCpLMOe5ZfXSc=;
  b=NsHCtD3GQQ7gcIeFEaE0uTqsAuRskBj3loZh19eAfOdaSyDA3pi9J6Aj
   nnzOy0eivK/gemuMbP5y4zdDjXuFBvu3FzP9CtSQVblGn3LgWuVEv8N1A
   6jVt4oLvgmYKew2SRvFZiXwvIIIv9gzbbCkqEToCdMHR1qXPWjE0ktICb
   sWXUeUL7PDLost/uTiACKeAq9pyHlJwKudVrnLqJ9JSaxL+1J1oU8+TfF
   AKSdHu2gzSNCMN95sKIQjGYC4NR+rwCG6+Mjfp9Bbl/oI+RZB+QYzcMFr
   zPE0Xkv6qjmo4hCsJjQUpXU5Zf3M5ihQNlFL1mPZWn+rgiLs1Mz0qIEWq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="383116074"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="383116074"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 09:35:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="721748724"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="721748724"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Sep 2023 09:35:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 09:35:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 09:35:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 15 Sep 2023 09:35:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 15 Sep 2023 09:35:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NP55O2OQcUvz6qeLq0N88QzKU7S7Jfg6X5Kdls/fcuEMTJEwIrgop0hChdpSvjAY66E1KHLWRPlHyuUV5rGGF7em+EVM4SthC3MVY60R9eW79EQfX+zdnNLimM7lqiKFeA/l+9qegkEIh0sWZThBRO96zQJSZUdk/BQXPsbe7KZZb7OKUOlPvk4rJ+1steGlmCCOr4Ae0TjOsebUjHWWJjSSxGmVGPiPPPLL/NnvQ1OalNA/PcdxWj/372eDyk3ysD2Zo7dkaMErVFGCswZxSkRVqIprejIYSR61dpPcjKeB5Hv+sFjdGnMh2EG6KHf34mo+5cLryQgSaKegdOl8/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUtcpW4d/T3/83IziQbrfenDipsGqCFCpLMOe5ZfXSc=;
 b=n9m60GcUFDrEFFALuTqNWvDmWOQGFbwtRBJOuYq7rmhEFJpzjG4naiyaDyfWQP3bpaKusaEHbVSdvQGsLkYdSSNNwneAEPvnnUmNK64pFDo2DGsToXIP/e73CtpNwa0sEphiJXq2vH90JkAz+pYQKWB31X6rwhHAzdLVXXXqtvhc2e84PpXEqrWS32ttkhwC/Y2pU9e8CPbNAYmTibN/RQkc0pIFoMjtika042TxRf8Rb82eTmH0jx2BymsbCRD1CqszW2MTck1/sne3Ow8jRwEscpOSfxX7KKv+9gu3xG5AAG8eT/z+2kvs44D1NHaXVZ4htcpT5dN/y7ZZtC0JqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7882.namprd11.prod.outlook.com (2603:10b6:208:40f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.38; Fri, 15 Sep
 2023 16:35:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 16:35:46 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
Subject: Re: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
Thread-Topic: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
Thread-Index: AQHZ5u85jsakadGf40+tOzEQaa/IwbAa7IMAgABC9gCAAOgBgA==
Date:   Fri, 15 Sep 2023 16:35:46 +0000
Message-ID: <f2145fcc96b05060b3a9038b7caa37f69b51cbfe.camel@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
         <20230914063325.85503-3-weijiang.yang@intel.com>
         <d05a91f12cbce9827911c23afcfa5fdaf2acb5cf.camel@intel.com>
         <1b5ecaa7-97fe-ecd2-6afe-0c260ae8b0be@intel.com>
In-Reply-To: <1b5ecaa7-97fe-ecd2-6afe-0c260ae8b0be@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7882:EE_
x-ms-office365-filtering-correlation-id: 921d6968-c689-4e7e-a21c-08dbb609d040
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I/8sO02Aat4J8QBY97OiAmZBWWc5l/GCNmlHK23yaELM23YEtQH1xT92vE1tTB5rTqrRTbS1R91p9Bq8Bb58kqaJjyjovlRDqep95PlLLf+Qc6AQphB6u6yTWSH31N5GYV9cvRFCQyvUi7YmQHPXnTNe+4zriQWkj/TcHS5clXL8VCjtxJTWQ31U3FnOO8CS5xhuB5hpd+ds/o1voEyq+unBIwavvcmiGZ7S08aHh1hyLvqux7574CbS0sZXTgBTS2JX71Bod+gd/zlRdA7j12R+1I69/bd8/FIQZBzc+b8N53tloUo3pTyfvzbFvu4rE648q1t5gQLirCVxE0VqGNpWZ5WG9057yWLRMKjahLiyW/wAsT56NKnVCumogqTmIxbwxUnSQ0eLeZH3ysZaE/BXKbEPcZL6xEr5BemRNSsnXqWpFCmP5o5a7GKdP+X6nZ9lUGQJgzlqrGwXPHlSDNS6hfIuXRkQCplX+DVkDQDC1uwrTBifjgQWVQWUNEzT7USy8KF7jR9Bwh+20frr7cebybhHRlwu+ZDntvIM7UN1WweVMo+t1645V9bUpowioGTmAhjKczA/1P9jzA/BM1+y267F9Mm7mR80SJWtnoKV7brVnkbCMCMzBYQgez+l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(376002)(136003)(39860400002)(1800799009)(186009)(451199024)(38070700005)(6486002)(71200400001)(53546011)(6512007)(6506007)(122000001)(83380400001)(38100700002)(82960400001)(41300700001)(2616005)(66476007)(66946007)(36756003)(76116006)(66446008)(91956017)(64756008)(478600001)(26005)(316002)(54906003)(66556008)(110136005)(5660300002)(4326008)(86362001)(8676002)(8936002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmJQNEUvc1lTakhidWNEaHlUZnhLcjFsNW42UDBvalBKZDJYazYxSWFScVBn?=
 =?utf-8?B?ZFNvNGNXaHJrcWNqTkkzOGg1SjNmdkRrNjlnRjBVNUhjb0Q5b0l6MnFTUVRO?=
 =?utf-8?B?UXNLRlJRMGtiOFdsa2J1K05FcUsvbDhiYU1xcy9FNjlhNTZza3NRcE45bmtZ?=
 =?utf-8?B?MjBrWGpWN1N2VnNJSVBmVytFSFNjRVVSMkgrMFZUSWJQaG9lNytrU0RON1dh?=
 =?utf-8?B?b3hIc2FvTHl0M3Uzc08wcUI4WXBQWnJQSDEzaWhyYWNzN2xxb2k5QjR6UTEw?=
 =?utf-8?B?S0NSSUJBeVZ0blVBeHpqRXMzTXl6Y3ZOdGcvMEJmRHQ0YmdUdmNTNzhOaE54?=
 =?utf-8?B?aW9jcnF6ajk4dGY4QXV0RVZLTkFzK3dCZnZvMUtMOUV3TmJUWlVhNC9Kak9u?=
 =?utf-8?B?ZitnOWI2c1QxSjcvUVkyeUdXOUpxVUtzZ0VZQlNIeXpXZ09zSFM3RDRHUFY4?=
 =?utf-8?B?VGN6STdrVEZHYkpXckZTUnFidEZhbWNBdjBTK2ZPMzE1enV3MEVkQjk0OVp0?=
 =?utf-8?B?elN1cjRNNXZabXBGam92WGU5V1NIc2RGUGN3QVo1cWEvRnpCd3A3a0ZIM2VR?=
 =?utf-8?B?ZWdOR3RUVkxOcHdaNldnOWZlekI0ZU9OWW15WHhValpFYnBxcHBlcmtpYnhD?=
 =?utf-8?B?SEdWMjFZYkx1QkMySHVRZTUyR0RlS1gyalJoWkhmRkc1U1NNT2NCUFd4ZjU0?=
 =?utf-8?B?QzlyTEtEQW9Va2RFK2tNamhINDhCTjg2MXd6T0k2KzF5VjFqdWZmbTExU1k1?=
 =?utf-8?B?OVFKTXFSaWFVbmxPZmg3cjdid2taM2NIbmJKemxrd0FFdk1PZEUrZUhEcDM2?=
 =?utf-8?B?V0dKUTFMMUkxWGtjZEpDWVZwL3RqU3M0Y1dObStXMm9xK0RtV29qRkFzUkhk?=
 =?utf-8?B?QmV0dVVVZ1c5bVQyR3g0VVdJd1oxNU1mY2VJYzMxdVAvcy8xSUg5T1R5d0NI?=
 =?utf-8?B?U2k2QTkwOGF2RnRCaTdIT1BjRDN1aERCMHB0ZXUvQ2FEOFd0RXZCT0l0Mkxu?=
 =?utf-8?B?cEpIMXNPTjArcnJoWlBxcFBWOVNSWmxXUzQwTzV3Y2FOOC85YVRsUk01Y040?=
 =?utf-8?B?SlZZNXVsb0NTS0FXdkJZV1YwekRtZDNMaHhTcVYweFVkN2VOSUp1b3V5NEZV?=
 =?utf-8?B?elhObmRaNjA2MWxGakh1N3dySi9IN3dSYXBETjVsWFJUdWpEQ01vR0toNThp?=
 =?utf-8?B?ZDNiQkFMR2Vtd3hnRjdEZFN5b3FzQ0owdGJSNy9SWnAwU2kzZXVpL2tFTWR2?=
 =?utf-8?B?Sk5wZ0FMR3dheWE4SVpFcGNmcE05QWdRcEo1VDBtZ2ZvUWNqOEtZQWdPa3Zi?=
 =?utf-8?B?N0pqR2dGaGJMMS9EN3R5U1hDcHVxMDFadUsrRG4wSGsrc2dUNi9pM0ZYSnE5?=
 =?utf-8?B?NEFiY2IyaTVuODFHVWVHbG9TbXRnd3RSOVp1L2JLMi9wUU5SOGJUS1JLQVFB?=
 =?utf-8?B?dWxtN3FTYVBkS01ZM3R6V1hDVnJtUTBYdldLZWRDMXU3ZllTRFZKK3ZjeStP?=
 =?utf-8?B?WlRac1hYOTRrK1VNT3BobjJCUlExczM2RUJaNVhSOHdKaUpKTTZHVk1VTEww?=
 =?utf-8?B?emZmQnVnVEhMeURJcFlMc0VtaDgyMjlKMFI0TDF6cjZacnpFTTB2ZWtmejZK?=
 =?utf-8?B?NkVCT1UvWE85bVVvQWpzNzZRY0d6NHhuRFQ2Q29NZ0pXdjZaUG5PZlMyTGx4?=
 =?utf-8?B?L2FBVDJud0FmRHc3a1dTSjN1MXV1YmxVWllTRmx1UE5kZ1p3NUpROGl4V0Jx?=
 =?utf-8?B?Y2w3STlhRS9RSG1idTNxd0cvclk5dnZFSkd2VUVLSlhHNGJDTHpiSHhKcUl6?=
 =?utf-8?B?QWtScGF3SW1GZDZQczVGS2M5ODliR1Y4Sm1HS25yb2htVFp6ZTl4eDUvbVB5?=
 =?utf-8?B?TldOZ3FWdXFsdnZQclRTYjNiYnZFQ2ZYb2hraDlMRzZiYVFHRXlGOHY4Zlda?=
 =?utf-8?B?ZjNKQnZ5d00vbEZXZU03eVZ5ZnFsQk00VDBHYjdEWSt0ZzQ3ei9sYXBmNnZv?=
 =?utf-8?B?ZEZJUU1Mc0JucDQzdGMzRFByemQycHc2MkNaS1ZWVzNHZE4zSzVkS1M4dlpu?=
 =?utf-8?B?RnRTWWF4NHorR0tDbU10YkZjYkg1SFA1a3IxVW5FSHlzMWdjb1lEOTJIZm90?=
 =?utf-8?B?YnJweXBaSUpEaFR0ZGxhbHhzNnNtVGg2SnNVZ2Q4MVBVaVh2WU0rWittNjNk?=
 =?utf-8?B?NXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7CE2A992EA28F4AAB49C11B741A5171@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 921d6968-c689-4e7e-a21c-08dbb609d040
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 16:35:46.7559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3X46U9AV68hXiX/y+4dlDvIc0IZ+3KrzO8B83t+eNdnf7aamdxcDzsNV+NhJwhPD0ZhrpgJIGVzpOr7Oei3HieNuJ9CtqBW52Hzu1CioR28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7882
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA5LTE1IGF0IDEwOjQ1ICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gT24gOS8xNS8yMDIzIDY6NDUgQU0sIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0KPiA+IE9u
IFRodSwgMjAyMy0wOS0xNCBhdCAwMjozMyAtMDQwMCwgWWFuZyBXZWlqaWFuZyB3cm90ZToNCj4g
PiA+IEZpeCBndWVzdCB4c2F2ZSBhcmVhIGFsbG9jYXRpb24gc2l6ZSBmcm9tDQo+ID4gPiBmcHVf
dXNlcl9jZmcuZGVmYXVsdF9zaXplDQo+ID4gPiB0bw0KPiA+ID4gZnB1X2tlcm5lbF9jZmcuZGVm
YXVsdF9zaXplIHNvIHRoYXQgdGhlIHhzYXZlIGFyZWEgc2l6ZSBpcw0KPiA+ID4gY29uc2lzdGVu
dA0KPiA+ID4gd2l0aCBmcHN0YXRlLT5zaXplIHNldCBpbiBfX2Zwc3RhdGVfcmVzZXQoKS4NCj4g
PiA+IA0KPiA+ID4gV2l0aCB0aGUgZml4LCBndWVzdCBmcHN0YXRlIHNpemUgaXMgc3VmZmljaWVu
dCBmb3IgS1ZNIHN1cHBvcnRlZA0KPiA+ID4gZ3Vlc3QNCj4gPiA+IHhmZWF0dXJlcy4NCj4gPiA+
IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogWWFuZyBXZWlqaWFuZyA8d2VpamlhbmcueWFuZ0BpbnRl
bC5jb20+DQo+ID4gVGhlcmUgaXMgbm8gZml4IChGaXhlczogLi4uKSBoZXJlLCByaWdodD8NCj4g
DQo+IE9vaCwgSSBnb3QgaXQgbG9zdCBkdXJpbmcgcmViYXNlLCB0aGFua3MhDQo+IA0KPiA+IEkg
dGhpbmsgdGhpcyBjaGFuZ2UgaXMgbmVlZGVkDQo+ID4gdG8gbWFrZSBzdXJlIEtWTSBndWVzdHMg
Y2FuIHN1cHBvcnQgc3VwZXJ2aXNvciBmZWF0dXJlcy4gQnV0IEtWTQ0KPiA+IENFVA0KPiA+IHN1
cHBvcnQgKHRvIGZvbGxvdyBpbiBmdXR1cmUgcGF0Y2hlcykgd2lsbCBiZSB0aGUgZmlyc3Qgb25l
LCByaWdodD8NCj4gDQo+IEV4YWN0bHksIHRoZSBleGlzdGluZyBjb2RlIHRha2VzIG9ubHkgdXNl
ciB4ZmVhdHVyZXMgaW50byBhY2NvdW50LA0KPiBhbmQgd2UgaGF2ZSBtb3JlDQo+IGFuZCBtb3Jl
IENQVSBmZWF0dXJlcyByZWx5IG9uIHN1cGVydmlzb3IgeHN0YXRlcy4NCg0KSWYgS1ZNIGlzIG5v
dCB1c2luZyBhbnkgc3VwZXJ2aXNvciBmZWF0dXJlcywgdGhlbiBwcmUgQ0VUIEtWTSBzdXBwb3J0
IEkNCnRoaW5rIHRoZSBjdXJyZW50IGNvZGUgaXMgbW9yZSBjb3JyZWN0Lg0K
