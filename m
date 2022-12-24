Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC465582B
	for <lists+kvm@lfdr.de>; Sat, 24 Dec 2022 04:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiLXDDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 22:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiLXDDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 22:03:01 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBA824954;
        Fri, 23 Dec 2022 19:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671850979; x=1703386979;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QB/bmPcKWGBIEkhJbBfWsQQityqlU2yfoBikEikyHvg=;
  b=JN7VcHe9zFqt/2VNJ95y1hKUELctWcfV5lS/+aXFhUPqdBWeQ+Td+Qyc
   6SsguXT76MNhglRP+sdDzFyIDSgIhyuXKKyI20sLuPpZlzydrogVxzhqm
   v9dOQQyBLiVi5aMdMRslE9xdarOOXVnh574gvIWJZvdtco3X6/8dXzbtQ
   2tH56nvj+1SwAb9EWNGc2ms1xPErRmKF3uaWl6vReTfR15CXSUjpykZKg
   pKoQgCQ5c9lZ1jD3n4p21ms26eZexZKe/aWB3sQGND+RXXG6iM6PPDeUt
   OmIRGnhmo/oPFxSjBeuerYzyOpqzLG5iuC695XKPziYBI5V1xIJ5Jf+Ba
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10570"; a="322343814"
X-IronPort-AV: E=Sophos;i="5.96,270,1665471600"; 
   d="scan'208";a="322343814"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2022 19:02:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10570"; a="652269053"
X-IronPort-AV: E=Sophos;i="5.96,270,1665471600"; 
   d="scan'208";a="652269053"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 23 Dec 2022 19:02:58 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 23 Dec 2022 19:02:58 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 23 Dec 2022 19:02:58 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 23 Dec 2022 19:02:57 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 23 Dec 2022 19:02:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxWcbOiuJguy5/H2W5tcJhRlUi+cd9ZwgLm5wwWT93dcRcnF4UcUl2A/aIlrk0Ss+sV88UxZmv6wN46HpkSRxPy63B2N0OuIORedkauOXLW3K6NQPranIrM3HP2jWYeHZnRINVaRI1IUMJpDhdt3GiEU0Esi+pmCn4ZCFERN/MoGMD+w1j5O9SosJswGm2NtwVfb/U5gGk2YJI/XzRV2iV0LP087s3bK4AmzSMP220ZMGgsaVLcePxHyFB/Xgs3fA1N8v8swo6qvacxFwxJHfv+sULlgPiW5TXGSx+uXOUCIpytT6IOmOC+DhAJqJLtW8GV1OMQ7z6Ybsn8oc7wG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QB/bmPcKWGBIEkhJbBfWsQQityqlU2yfoBikEikyHvg=;
 b=HLEC9oW1lodZa8StFuZwMff0oP+vVPV3iVMqlAHKcNFZfONJiaz1Yb8sFt18PaqUdx8gafh9TlNtfXpWp+ZpG7kRaVWCKsRKPrWVKZ6AfUQVQ9FZ6TMElnh9d+Hd2CT28umMJM41KAsMBTkFPtmmNCRFitUwk1L8QmD/05JKGfRVl8hW0DkgGipIU6Dyu5Dmm3wGwA1bv6Fk1O71Ei5/qnGB79bFTSxkrmM9B95MJPyyZjs7rzLQ6cfyjlOCR4Lud6VEBjvgfy4NTxlnJXsslzO6v9FInUuMvpiCKw3SIVfSL6ZNEQIVIxsCB35jLnZbx2TCjk7usIEeh867aR/ojw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB8067.namprd11.prod.outlook.com (2603:10b6:806:2e8::15)
 by IA1PR11MB6417.namprd11.prod.outlook.com (2603:10b6:208:3ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sat, 24 Dec
 2022 03:02:56 +0000
Received: from SN7PR11MB8067.namprd11.prod.outlook.com
 ([fe80::133b:37ac:ce48:99ea]) by SN7PR11MB8067.namprd11.prod.outlook.com
 ([fe80::133b:37ac:ce48:99ea%3]) with mapi id 15.20.5924.016; Sat, 24 Dec 2022
 03:02:56 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC PATCH 23/32] x86/fred: update MSR_IA32_FRED_RSP0 during task
 switch
Thread-Topic: [RFC PATCH 23/32] x86/fred: update MSR_IA32_FRED_RSP0 during
 task switch
Thread-Index: AQHZFEEtGjKidcc/l0em/MMw2NP2fa52h/wAgAVcygCAAHrz0A==
Date:   Sat, 24 Dec 2022 03:02:55 +0000
Message-ID: <SN7PR11MB8067ED3FA4F69BA1B72A6EEEA8EE9@SN7PR11MB8067.namprd11.prod.outlook.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-24-xin3.li@intel.com>
 <Y6GE/Fnl1tuER1fF@hirez.programming.kicks-ass.net>
 <C2B7B3DF-51BD-455A-8F9D-BE1C0FFA60AD@zytor.com>
In-Reply-To: <C2B7B3DF-51BD-455A-8F9D-BE1C0FFA60AD@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB8067:EE_|IA1PR11MB6417:EE_
x-ms-office365-filtering-correlation-id: e91c79fb-0660-4dcb-94d4-08dae55b5b1d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BAVTKrl8yF+ZjDN8PgHx5LLOZ2aHzINmpC4NEYruZTYSUu+kC/EJN/T5gCqf47BBZT+pnpqPGoHZKEuW/wG5xeFlQfNJD9RLZI4CKvSLqnqJS3V7jMx0vM+x/gyJOkwD44tC4T7m2+zIkkUTUqHd4f1EyfAheAf46EvtuvDqGqyvC7sdsvM/EqE3zP9DyVE5450/zuimmgpPqjS1UefwY3FDPlt7I4nje2ot4+8P3h5aRpR19zPn7xO0rFGyt+TVSqEIVoYlzRo3podXyGIE2Dnybmpbm1pFj0FtaLamCZpk5hi7fyvUM2cP+BA0gpsdr2qmJyEP5SzhnrT61K7CtWzNcLpcmbfKUjSXhvhzf46cVV5cZz8Ok9bN6J9tPkznwDu0jx+VoCTzmobY3Efo4OrngXhP02yWljd95LPvwMZZ+cyGW7nEGmBsQfQv9txTAhf4XozS+Uwij+EJdE4nUmiQb2Eb0sY/qLVcDmokMV2YgyrO8ZWJRC3sV23e+Mq4yeKWJclHdU8Ly6gLbuy3G22TVv5fUwrTi/kWoM+0ohflyEs7TsQZnf/ZIF+79JLRzu3b8B1i4oNGBOpWbSG+Dk7OgpONb164YiZpxeTyL78c6HovVN9wJQZQUn213pH8V1fZxciqmCFnDSpNBDJCLPsp/w70oFg4ZzJ4yuAifklFSRv3QTmP7OvOrslCEIXvK6ruyQGQzl/YeR7gWZGQBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB8067.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199015)(2906002)(55016003)(38070700005)(38100700002)(82960400001)(66946007)(66476007)(478600001)(8676002)(110136005)(4326008)(54906003)(316002)(8936002)(15650500001)(52536014)(64756008)(7416002)(66556008)(71200400001)(76116006)(66446008)(41300700001)(83380400001)(5660300002)(122000001)(26005)(9686003)(7696005)(33656002)(86362001)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGljaC82NTMzZEVGakJ1THB4V3Q2VUtuVWFkMnM1Y09WUFJZUDBmeEdPYWdz?=
 =?utf-8?B?dTZDK3E0NnZINHpXeEdDOFIzeHVJY2x4OXB5T2dnTWNrbU9wS251NlBwd1Zp?=
 =?utf-8?B?MDF1L3g0b3Q0UW13Z1FHQWxYcWlaMG5LSktRaFBnL1VRM2oxQVlYVkdRY05Q?=
 =?utf-8?B?Y3VXdjJWNlVaeEFnZGtLQ2I2c3ZBaXViU2U2R0pMaUNWb3huVXhWQlV2dEZQ?=
 =?utf-8?B?Z2gvL2RGUnk2eGtIdE5jQlRpZ01nT0svVUs1RjlBdVV3WUdoNk5NZGdFNnFF?=
 =?utf-8?B?S2JMQ0NHWnJDQlJNdlhncEZaQTZzMFpRci9qOTNBcE5QY25VSldtS1djNEdp?=
 =?utf-8?B?ZWtjOTZkQWh1U04ya1VlWG1BaWlDVE5tR3U0VGZwTEd2YUlIeEJ6NmtXbkFW?=
 =?utf-8?B?aXlNWnU0UU5SQ3k2N2VnMk5PQzIzREExbE5iNy9tbGpPZjYrVHlRZFhDWG9j?=
 =?utf-8?B?em5ld1BwT3FkYUF6a09Qa1oyKytjZVpzcXRDRktvQ3I3Qll0Z1MrUk56Ulgy?=
 =?utf-8?B?ZGhMMmJBSW1DNkZEUEdvVEVDcEtMZVBWRlo1Wmp5Z2gybExmRHVCSStZaGNP?=
 =?utf-8?B?MmNlb1dIQTVkak51cmVVdWRNMDZPbnRPNGFrQnp4UEJRSFFJbEZIcUlIL2F1?=
 =?utf-8?B?c0lKYy9OcGpyY2x2dWhxMnp3eTZPSndTYTlCd2ZUemlrT1lvQmUrY3NIU08r?=
 =?utf-8?B?eWgvdkNnRTAyUlgweER2V3JoZXZSd1ZjK3k2bTJTOXlXRW5iQTlWTVVqNEg4?=
 =?utf-8?B?eHdGYUFDd2xyQWtLaE82VFY1aUtVY0NPQWlGTFI5VnFjRUxESnEzM1MvbUpI?=
 =?utf-8?B?SGNkVDFsbDNvZHc4RTBFMFFUQlMzTS9hTTR2azdRNDI0SWZHNlBHWktKT1pK?=
 =?utf-8?B?RVdreWNmSVFpSGlxMDdJbG5wNVdJVGFVNEplUlFtMmR2TUlOeXFXUldHK2lv?=
 =?utf-8?B?SG1mZTZVcUV6R21TM1N6UmlVOWdDNDdnd1F3M1dLMElPZ3ZDcEIrbk9WQlhV?=
 =?utf-8?B?ZTlTemI4Zy9RUUpWWVNpeGdBV2lqcUdNL294bDR4ZEk1MkVCVVFpNXlwaFEv?=
 =?utf-8?B?V0hwYmVYa3pTUm9yaHpVM2dBa1JBM2RnRE5jdmQ4VkZIc3JrazNUT24vN2xm?=
 =?utf-8?B?SFNaNlNRemZRajFIMGxXR0RCM0g4VUtyWHIwYnJpeTFWV2UvUkJtZm9XaGJz?=
 =?utf-8?B?UEFMUzZ2TUtTSGdRcU9lYi9DUzFDQzNieVYzclVjRHczWlNJTjYrdjVrYW9k?=
 =?utf-8?B?SzhVbXAwcFJ2NXJhNXkxUFFzN0lzVm50aURrbDZNVUhKVU4waCs4WXJFa0ND?=
 =?utf-8?B?QnlOMW9ka3NmdVdNVHVpaFp0bjBQUHB0K0QrSWtUNzhVelZUenYvY0ZwWlkv?=
 =?utf-8?B?S2o5WmhYY3RXdTBXMGwxWnUvUW1IZTRLT0s1Nkt0bnJTaUZpZDNIZ1JHR2pN?=
 =?utf-8?B?MVJuWmZpZzJLOWRiVmV2SlBjNGJUZVlrVDJScGhVcVBKRGdMSUJmZXFnb3ZC?=
 =?utf-8?B?d2EzeVQvTkF6eG9zWVIrMmcwMnhIVEVac25aQjVmSU55eWZDMVd3ak8yY1lQ?=
 =?utf-8?B?ODhiNWRjeTFVRWwzbHBoVUlPNVlxQjVnZ3NiT3d3cHc1WXIrLzRJZ2VVOXlB?=
 =?utf-8?B?cFBtOC9Kc2ZHMjNrNy9Ha3JQMTBkWEl6ZFF1QnB4NzNLY29IeC9kS0dLSVJq?=
 =?utf-8?B?Wm5VQ1lJY2tQa0ZBemdvMEdGRCtaWHZMZmZ0WURvRUZSWisyY1hkUTlEVVpw?=
 =?utf-8?B?K0tSMnRVNnBVRk4xSU03N0RjRzFNd1A4NHkyMHJyeWpkZUlUUGtJUXU4RU1j?=
 =?utf-8?B?Q0cxbXdHSC9DeGRxcnA0a0pkcDFNYUhhVWg2OGFVNmZyVGswbGFnbTRTdklp?=
 =?utf-8?B?bk9hcVNpbmkyQ2xrZnQ4L0RxTWQzdTZZU3ErdHRhK2NpbHFKZU4vUjNwZlM4?=
 =?utf-8?B?cVFaTmMzM21tZndudXdUTDNMYUZvejVlWGNocllBWmI3Q1k5TjB1am9kVmpO?=
 =?utf-8?B?dy9SSHlEUEtMZDUzQVVRYVJpcHJVUjh6NEVRd1VhRlZsTU80UlV0TjBoT1Iy?=
 =?utf-8?B?UjhabGFIVUVYbVA5TlYxUDAzSWNBREE0WTlESjJkL2w0cUFOdjN5ckZkVHdQ?=
 =?utf-8?Q?s9yp348GnOk54MM3GxKVbmbq0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB8067.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e91c79fb-0660-4dcb-94d4-08dae55b5b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2022 03:02:55.9327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZ4L+jT5XGsHVJ15MH4WBbwhjmrTiS7DQkk38rjJjIxGnu7Tn7jGobQItjmdngibMEpyY6P9QwimEyEtJFH5Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6417
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zd2l0Y2hfdG8uaA0KPiA+
PiBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3N3aXRjaF90by5oDQo+ID4+IGluZGV4IGMwOGViMGZk
ZDExZi4uYzI4MTcwZDRmYmJhIDEwMDY0NA0KPiA+PiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9zd2l0Y2hfdG8uaA0KPiA+PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zd2l0Y2hfdG8u
aA0KPiA+PiBAQCAtNzEsOSArNzEsMTMgQEAgc3RhdGljIGlubGluZSB2b2lkIHVwZGF0ZV90YXNr
X3N0YWNrKHN0cnVjdCB0YXNrX3N0cnVjdA0KPiAqdGFzaykNCj4gPj4gIAllbHNlDQo+ID4+ICAJ
CXRoaXNfY3B1X3dyaXRlKGNwdV90c3NfcncueDg2X3Rzcy5zcDEsIHRhc2stPnRocmVhZC5zcDAp
OyAgI2Vsc2UNCj4gPj4gLQkvKiBYZW4gUFYgZW50ZXJzIHRoZSBrZXJuZWwgb24gdGhlIHRocmVh
ZCBzdGFjay4gKi8NCj4gPj4gLQlpZiAoc3RhdGljX2NwdV9oYXMoWDg2X0ZFQVRVUkVfWEVOUFYp
KQ0KPiA+PiArCWlmIChjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX0ZSRUQpKSB7DQo+
ID4+ICsJCXdybXNybChNU1JfSUEzMl9GUkVEX1JTUDAsDQo+ID4+ICsJCSAgICAgICB0YXNrX3Rv
cF9vZl9zdGFjayh0YXNrKSArDQo+IFRPUF9PRl9LRVJORUxfU1RBQ0tfUEFERElORyk7DQo+ID4N
Cj4gPlVyZ2gsIEknbSBhc3N1bWluZyB0aGlzIGlzIGEgKmZhc3QqIE1TUiA/DQo+ID4NCj4gPj4g
Kwl9IGVsc2UgaWYgKHN0YXRpY19jcHVfaGFzKFg4Nl9GRUFUVVJFX1hFTlBWKSkgew0KPiA+PiAr
CQkvKiBYZW4gUFYgZW50ZXJzIHRoZSBrZXJuZWwgb24gdGhlIHRocmVhZCBzdGFjay4gKi8NCj4g
Pj4gIAkJbG9hZF9zcDAodGFza190b3Bfb2Zfc3RhY2sodGFzaykpOw0KPiA+PiArCX0NCj4gPj4g
ICNlbmRpZg0KPiA+DQo+ID4NCj4gDQo+IFRoZSBwZXJmb3JtYW5jZSBoZXJlIHdpbGwgYmUgYWRk
cmVzc2VkIGJ5IFdSTVNSTlMvV1JNU1JMSVNULiBJdCBpcyBub3QNCj4gaW5jbHVkZWQgaW4gdGhl
IEZSRUQgcGF0Y2hzZXQgc2ltcGx5IGJlY2F1c2UgdGhlcmUgaXMgYSBzZXBhcmF0ZSwgcGFyYWxs
ZWwNCj4gZW5hYmxpbmcgZWZmb3J0IGdvaW5nIG9uIGZvciB0aG9zZSBpbnN0cnVjdGlvbnMgKHdo
aWNoIGFyZSB1c2VmdWwgaW4gdGhlaXIgb3duDQo+IHJpZ2h0LCBlc3BlY2lhbGx5IGZvciBwZXJm
LCBhbmQgbWF5IGJlIGF2YWlsYWJsZSBiZWZvcmUgRlJFRCkgYW5kIHdlIGRvbid0IHdhbnQNCj4g
dW5uZWNlc3NhcnkgY29sbGlzaW9ucy4NCj4gDQo+IFRob3NlIGluc3RydWN0aW9ucyB3ZXJlbid0
IHB1YmxpYyB3aGVuIEkgd3JvdGUgdGhlIGZpcnN0IHZlcnNpb24gb2YgdGhpcyBwYXRjaHNldCwN
Cj4gYnV0IHRoZXkgYXJlIG5vdyBpbiB0aGUgSVNFIGRvY3VtZW50YXRpb24uDQo+IA0KPiBYaW4s
IGNvdWxkIHlvdSBhZGQgdGhhdCBub3RlIHRvIHRoZSBwYXRjaCBkb2N1bWVudGF0aW9uPw0KDQpX
aWxsIGRvIQ0K
