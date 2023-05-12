Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2E70051C
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 12:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbjELKVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 06:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240466AbjELKVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 06:21:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA3EBF;
        Fri, 12 May 2023 03:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683886898; x=1715422898;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kV7DelheKC03u2KDcrdQVqEnQ4UH8WZMTcNIInVw56s=;
  b=R6veDc9iT3k/O6OhEBB8DHpkYPZU3eiBiGmDQ9YvUHHWW64oulV02IR2
   U3wv05k07OYH0PjHgKwVanoxEmqtyByRZDVwVTh8mtdBImJhn3yUNri/c
   Wie3eoAMQ6npFfJZWY57yHFCTrQB1hvXZiabWzE2FCuDluPRbotRS5Lpf
   NxebvHK81hnPmab7U8avMJbYNuR+Ii2/6rXeUpWWEXHv7md0uIL8aAXc2
   rE3nliA+qXElA26zCHrCeTK/anBULFjaOoLHGmdKTkW6E4o9Mfj9yyjGv
   bwKG24yBWSFfSIdCPJwJjAwR+gXk74siNn/lHmYyEtHy4aJVBnJQKOvoP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="353005592"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="353005592"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 03:21:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="874352531"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="874352531"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 12 May 2023 03:21:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:21:37 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:21:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 03:21:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 03:21:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg+nNSs8nlT6exZcYGMvJctN+T0gxwX5av8YmCMI/Zi+JW45V1xuaGPw8G9UdTRrVCVHR93PwmDiExOQb+DLRVrgQ3Q52446VXjLzN1LAMoAdFLOh25zcmO6eJEyaZaRv4wvoiQ2FoNvQn4G3ZwPBVqaSPAwCqbjJGV2m6HsKqQRJR1tYZI/A304eo0Jr0u81YrHFK/tLunWIDn0A8LalY3j/0wSxTVXh+Bcr+NBtTTCUkqT3g2itUkWGVw1gHuu3xWacIx3HBcIXoA89o9WOctM9frjZXG7BOIKwK658eH/e+DcmKRDmW2mcYxcaIbdTHF32Fajw0TTNZXOHyMdZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kV7DelheKC03u2KDcrdQVqEnQ4UH8WZMTcNIInVw56s=;
 b=ibfkg0FyYo5ty334Ft8dM4yBSX0HCneBRel1f4X9+LOE6Cfjrkqxr397DfYHz6ejGoEa4w3ab2sETGoREDnxouLOVT+9ubyKwaZib8ZK+QzamAnf46QOaeLEaM7JmrLPnnr5NQEnxcA6hfoY0dzyn92R4Z4LsGT9BYNu81/S8Iosz6bMVQqoGgnb/pAwSAQ6Z9/5CAi2mOK9zeleQsCuf45zdxQ6TaeXTKNJlodq3iveE838NBTSGVT/Gh6iVIBME4E+W6RXDFf1CIjm2cfuc3W6nxIPl90YbRE65029U6cwMkoWLsKSqI9Fc+aUQoTX2RBKIF8WgobB1K4dUTnMtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6713.namprd11.prod.outlook.com (2603:10b6:303:1e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 10:21:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 10:21:35 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH v2 4/8] KVM: x86: Add helper to get variable MTRR range
 from MSR index
Thread-Topic: [PATCH v2 4/8] KVM: x86: Add helper to get variable MTRR range
 from MSR index
Thread-Index: AQHZhGEZl4tBpYAwq0K9CMOLNb/pNq9WbkkA
Date:   Fri, 12 May 2023 10:21:34 +0000
Message-ID: <a9ddd6827ce6f69a2c54574971317340e085f8ab.camel@intel.com>
References: <20230511233351.635053-1-seanjc@google.com>
         <20230511233351.635053-5-seanjc@google.com>
In-Reply-To: <20230511233351.635053-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6713:EE_
x-ms-office365-filtering-correlation-id: 44f30cf7-2b7f-4691-4125-08db52d2a9d8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BepuOo40obZbpsGl7fAbibyIzi7JXWEy+TNm0ty5g8liy7EWHlxkcWCqeydP5KSTcBAlyP0xhspk0m+A/Jh38MxwgR0sgRvozFDoxmmqMgK0YrEue07iUbahOR4vOI3A/H6kFuazpoETiws/e5+wcpFjHSrNhkSgtl5K+jVWiAg3P0vplHZdbpiUsALcFKPdGihntpQIvCpCw8XGojtaxQLp0b/Op+ABTW6XB92EfGHHC3JDtqeeJRkP06fVCCPlgg4+eDWRfu70koW1LubJ11tSziYNc/1TSCj88cGyAlg0tor++A3bA7x1gW/H0FkaLIeblZ8PIbigIAOHIvt5WoemjikZZgZVmfE0mIgQIbU5HSveCeo6vxv+AsRiWK7C7UZ608YUTr0UQLFHBsv1nK9JDVu4hmVgW7LWJqsAhyqrBzrY56lf59DoZfU0HT3Lw7z60Zh3N7uyyxtV9ztxd7oYVH33zytloN8thc68oTYmKnLk1cztlDb039Q8CY8NJXWv2I73WtiayzcML4NRVtaYave9xKvKEOihsnSQNuS61ENRsMZNTOjiUSNH9ZbEYTzZ+uYoSWp1H9EHO1yhoTZWOMCHpaHjXKUYazK1tJnGuOfs/ywa2YIugVGG1FR7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(2616005)(4326008)(83380400001)(26005)(66946007)(66556008)(64756008)(91956017)(6486002)(66476007)(6506007)(76116006)(186003)(110136005)(71200400001)(316002)(5660300002)(54906003)(478600001)(2906002)(86362001)(38070700005)(82960400001)(8676002)(38100700002)(122000001)(41300700001)(36756003)(8936002)(66446008)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEZCbjBHQ1F1SGROSVJvZ3RZTEpEOE05OWk0VCtwSlJzTStNN2ZiSTczUDJ4?=
 =?utf-8?B?UENPVUN1T3VBak03OEg1RGh1VTBRVkZvcHRDL29QaGF0WFBLVnFVT09lUjZE?=
 =?utf-8?B?RGkxMXNhQmpEYXFFK2dueTFPUFNMZ09sbWJ6V0pUaXFkQk5rNTY0YksxbFlC?=
 =?utf-8?B?L2Q4TlR2YWxDa25RMUpsTGYydnBJTitrV201MnRVYUdITjUxM2doVkdIbjVk?=
 =?utf-8?B?b3I3bEhUd0hTN0xDeURPTWdSSGF5bjhzYzZ1LzlWNVZHcHQvRWN5cWJkUXBx?=
 =?utf-8?B?eWFOM2lRL2Y0THk3ZDhhTWt1OGhDMDVoTFdhZGJDOFl2YXVUc0podjFNTWVE?=
 =?utf-8?B?RU8xWkkxb1J3TFZTT29UbThESEZVUlgwaGVSelllZ1V4TVdudGJtSHg1M3NV?=
 =?utf-8?B?cGVoUGIrcVhLUGlyR2NoejdneGpDbjhnVkZ0QTZ5MFFtTENja0xQUi9zd25J?=
 =?utf-8?B?bEFWYTVoS0FUcmxaNXNzeFNmUWRVVXZyL2o4Mi9xRDZIV20yRnoxMGNpUWxp?=
 =?utf-8?B?Qzl4QzlKVXlNUTBpTk85MnFnQUVhVWJLeWY4UjJ4ZlhXM3NENzM2R2x2Z0ds?=
 =?utf-8?B?UmZzVGJWTmFLa0hwdk1peFlvTWtTVWpIUG4zazc1SmY2ZWljQUozVHB3YStO?=
 =?utf-8?B?SjQzWUliVFB5K1VhMjNMVWZtNTdKaHRsL2JYVHlyaUk2cklYWFpGam5FUzlY?=
 =?utf-8?B?eG5nVTFzQ3AybFZESyttNkliTm8wTjRhdFRJcHlaZ1cwUXUyNTk3OWVLVWNZ?=
 =?utf-8?B?cFUvT3VaZ0d4L0JMZ1B4R0hhd3pzeXdZSmhDRkJwdGhTaGFMZDlPNUxnaWtN?=
 =?utf-8?B?SUpQa3VhZmZuN1g3UmZkOTR4Ti9jeENGUXBCU1VDeXdnYUdCNjExejBhdXA0?=
 =?utf-8?B?eHNlQ2YxZ3hneHovRFpxUVhvaTJYQ1hneHIwTHozbEFBMkZRM1ZHR1RKRHVm?=
 =?utf-8?B?aG00N2Y3THkxclordHpCL1c1VXk2Ukl4ektKV1VnTTkvRnV3Q2lyTkUxSENp?=
 =?utf-8?B?ZUZQczgvUk9PQ0VGcDUxVmdIWFV4T0VNMWt3MkthVjVTcVMrN2w3dUJ0Y1JY?=
 =?utf-8?B?MHBiV0hsK2FmNUprd1JDdUZpVWRHK1RnTEZPWlZxczJSVFdKckorMjdKU2hK?=
 =?utf-8?B?VW5hWTN4amRDRHFKNUU2MFpaQUNuSnJRUzkyNTV5WFFrOU5aeHY5cUpFZEtQ?=
 =?utf-8?B?QTlhOWNiaXp2U0ltWEc3L0x0NlFJZi84dVowWEFTZnhXc0U0a1Z3dUtyQTI5?=
 =?utf-8?B?dDVTQ01NN1pVWkJ1YUxnb2JrM1FsWTF0dGZpTnRCNlhvZmRKUjh0TVQyTldK?=
 =?utf-8?B?MEtxWm56MkN3VjQ1NmpiVnc2R1c1WWVaYXh4MGFVYmEyeGVqSHVMMzl4OU4w?=
 =?utf-8?B?ZG5GSG9KcktWdjRIMEFROVpLdEFLTGVoSlFoM3pIMHpDcXVzRklQWnh4MHNm?=
 =?utf-8?B?NDJ0OURaNFVlV0dtdlBYTnErQ0I0SzRYaER6YU02UmZVYnRQV1E0NEZPdFAz?=
 =?utf-8?B?N1JGYzdVYThvbXNYek5qYjBCMTl6QlhUS2UwYTBONGxRaUJwZXJKMXlXRGdG?=
 =?utf-8?B?bzlCV08vc3pWall3U0IyYTEzY2hOT2hLOFBWY3lBaW05bzltVitoQkF4RHAv?=
 =?utf-8?B?aG00Ym5aa0lyV2l6QkU2MEtKNHlyNllLTjEvUTNVWDdpMVAyK3NwdFNGdUNl?=
 =?utf-8?B?aGYzR2lBSHlodGc0b3BRWXQwQUNWOGl1dWlpZDF1N3lETHowRVdhNWRpR0Q5?=
 =?utf-8?B?ZUlyTGNteVVJWmRzSmVWOFFlZ283bHVmZDZWcllROG1Db1pkRTArYjhyTlVT?=
 =?utf-8?B?SUNMZXBXYU05SVpjYnNoaGZHdE83cUlDVmFqWmY5NnB2dUY4N3NBeC9DS2tq?=
 =?utf-8?B?MHVDSkRGQ0xQaTBPMDFTVXJkbk13VFNpcTdRS2VqZ1VXR3lzTHRWc2FyMU1p?=
 =?utf-8?B?TjhpZlJaR2ppZ0w2cWRFNThYUE5QeFFQcDFkS2lveDJyZEE1OW9Ua2NWWklP?=
 =?utf-8?B?dVg4OVkyMVBLR3NaSm1pdHd4UkowVzRZcHo1NmpScjJ4WUxsajRkMHJORnpR?=
 =?utf-8?B?cVYxZUZrMlU5V3ZIbmRja2UwdDJlYk91Vk1mL2RtcENLbmFXSS9MbTdHS3hY?=
 =?utf-8?Q?KWQfdGw/PYg1kuwhzrrtMC7lJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05081FD37A468A4BB8A7E8E5F127055A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f30cf7-2b7f-4691-4125-08db52d2a9d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 10:21:34.9041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JO7mJJ770TOgFKlvkIgPC8ikb4EKG9+Ua5PiC6ZowqoL3QIhn6MOf6WpMjZmOpqsNBvWotuKxzetvbK5prx0HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6713
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTExIGF0IDE2OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgYSBoZWxwZXIgdG8gZGVkdXAgdGhlIGxvZ2ljIGZvciByZXRyaWV2aW5nIGEg
dmFyaWFibGUgTVRSUiByYW5nZQ0KPiBzdHJ1Y3R1cmUgZ2l2ZW4gYSB2YXJpYWJsZSBNVFJSIE1T
UiBpbmRleC4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClJl
dmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCj4gLS0tDQo+ICBh
cmNoL3g4Ni9rdm0vbXRyci5jIHwgMjMgKysrKysrKysrKysrKy0tLS0tLS0tLS0NCj4gIDEgZmls
ZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0vbXRyci5jIGIvYXJjaC94ODYva3ZtL210cnIuYw0KPiBpbmRl
eCBmNjVjZTRiMzk4MGYuLjU5ODUxZGJlYmZlYSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3Zt
L210cnIuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbXRyci5jDQo+IEBAIC0zMSw2ICszMSwxNCBA
QCBzdGF0aWMgYm9vbCBpc19tdHJyX2Jhc2VfbXNyKHVuc2lnbmVkIGludCBtc3IpDQo+ICAJcmV0
dXJuICEobXNyICYgMHgxKTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIHN0cnVjdCBrdm1fbXRycl9y
YW5nZSAqdmFyX210cnJfbXNyX3RvX3JhbmdlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gKwkJ
CQkJCSAgICB1bnNpZ25lZCBpbnQgbXNyKQ0KPiArew0KPiArCWludCBpbmRleCA9IChtc3IgLSAw
eDIwMCkgLyAyOw0KPiArDQo+ICsJcmV0dXJuICZ2Y3B1LT5hcmNoLm10cnJfc3RhdGUudmFyX3Jh
bmdlc1tpbmRleF07DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBib29sIG1zcl9tdHJyX3ZhbGlkKHVu
c2lnbmVkIG1zcikNCj4gIHsNCj4gIAlzd2l0Y2ggKG1zcikgew0KPiBAQCAtMzE0LDcgKzMyMiw2
IEBAIHN0YXRpYyB2b2lkIHVwZGF0ZV9tdHJyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIG1z
cikNCj4gIHsNCj4gIAlzdHJ1Y3Qga3ZtX210cnIgKm10cnJfc3RhdGUgPSAmdmNwdS0+YXJjaC5t
dHJyX3N0YXRlOw0KPiAgCWdmbl90IHN0YXJ0LCBlbmQ7DQo+IC0JaW50IGluZGV4Ow0KPiAgDQo+
ICAJaWYgKG1zciA9PSBNU1JfSUEzMl9DUl9QQVQgfHwgIXRkcF9lbmFibGVkIHx8DQo+ICAJICAg
ICAgIWt2bV9hcmNoX2hhc19ub25jb2hlcmVudF9kbWEodmNwdS0+a3ZtKSkNCj4gQEAgLTMzMiw4
ICszMzksNyBAQCBzdGF0aWMgdm9pZCB1cGRhdGVfbXRycihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
IHUzMiBtc3IpDQo+ICAJCWVuZCA9IH4wVUxMOw0KPiAgCX0gZWxzZSB7DQo+ICAJCS8qIHZhcmlh
YmxlIHJhbmdlIE1UUlJzLiAqLw0KPiAtCQlpbmRleCA9IChtc3IgLSAweDIwMCkgLyAyOw0KPiAt
CQl2YXJfbXRycl9yYW5nZSgmbXRycl9zdGF0ZS0+dmFyX3Jhbmdlc1tpbmRleF0sICZzdGFydCwg
JmVuZCk7DQo+ICsJCXZhcl9tdHJyX3JhbmdlKHZhcl9tdHJyX21zcl90b19yYW5nZSh2Y3B1LCBt
c3IpLCAmc3RhcnQsICZlbmQpOw0KPiAgCX0NCj4gIA0KPiAgCWt2bV96YXBfZ2ZuX3JhbmdlKHZj
cHUtPmt2bSwgZ3BhX3RvX2dmbihzdGFydCksIGdwYV90b19nZm4oZW5kKSk7DQo+IEBAIC0zNDgs
MTQgKzM1NCwxMiBAQCBzdGF0aWMgdm9pZCBzZXRfdmFyX210cnJfbXNyKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwgdTMyIG1zciwgdTY0IGRhdGEpDQo+ICB7DQo+ICAJc3RydWN0IGt2bV9tdHJyICpt
dHJyX3N0YXRlID0gJnZjcHUtPmFyY2gubXRycl9zdGF0ZTsNCj4gIAlzdHJ1Y3Qga3ZtX210cnJf
cmFuZ2UgKnRtcCwgKmN1cjsNCj4gLQlpbnQgaW5kZXg7DQo+ICANCj4gLQlpbmRleCA9IChtc3Ig
LSAweDIwMCkgLyAyOw0KPiAtCWN1ciA9ICZtdHJyX3N0YXRlLT52YXJfcmFuZ2VzW2luZGV4XTsN
Cj4gKwljdXIgPSB2YXJfbXRycl9tc3JfdG9fcmFuZ2UodmNwdSwgbXNyKTsNCj4gIA0KPiAgCS8q
IHJlbW92ZSB0aGUgZW50cnkgaWYgaXQncyBpbiB0aGUgbGlzdC4gKi8NCj4gIAlpZiAodmFyX210
cnJfcmFuZ2VfaXNfdmFsaWQoY3VyKSkNCj4gLQkJbGlzdF9kZWwoJm10cnJfc3RhdGUtPnZhcl9y
YW5nZXNbaW5kZXhdLm5vZGUpOw0KPiArCQlsaXN0X2RlbCgmY3VyLT5ub2RlKTsNCj4gIA0KPiAg
CS8qDQo+ICAJICogU2V0IGFsbCBpbGxlZ2FsIEdQQSBiaXRzIGluIHRoZSBtYXNrLCBzaW5jZSB0
aG9zZSBiaXRzIG11c3QNCj4gQEAgLTQyMywxMSArNDI3LDEwIEBAIGludCBrdm1fbXRycl9nZXRf
bXNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIG1zciwgdTY0ICpwZGF0YSkNCj4gIAllbHNl
IGlmIChtc3IgPT0gTVNSX0lBMzJfQ1JfUEFUKQ0KPiAgCQkqcGRhdGEgPSB2Y3B1LT5hcmNoLnBh
dDsNCj4gIAllbHNlIHsJLyogVmFyaWFibGUgTVRSUnMgKi8NCj4gLQkJaW5kZXggPSAobXNyIC0g
MHgyMDApIC8gMjsNCj4gIAkJaWYgKGlzX210cnJfYmFzZV9tc3IobXNyKSkNCj4gLQkJCSpwZGF0
YSA9IHZjcHUtPmFyY2gubXRycl9zdGF0ZS52YXJfcmFuZ2VzW2luZGV4XS5iYXNlOw0KPiArCQkJ
KnBkYXRhID0gdmFyX210cnJfbXNyX3RvX3JhbmdlKHZjcHUsIG1zciktPmJhc2U7DQo+ICAJCWVs
c2UNCj4gLQkJCSpwZGF0YSA9IHZjcHUtPmFyY2gubXRycl9zdGF0ZS52YXJfcmFuZ2VzW2luZGV4
XS5tYXNrOw0KPiArCQkJKnBkYXRhID0gdmFyX210cnJfbXNyX3RvX3JhbmdlKHZjcHUsIG1zcikt
Pm1hc2s7DQo+ICANCj4gIAkJKnBkYXRhICY9IH5rdm1fdmNwdV9yZXNlcnZlZF9ncGFfYml0c19y
YXcodmNwdSk7DQo+ICAJfQ0KPiAtLSANCj4gMi40MC4xLjYwNi5nYTRiMWIxMjhkNi1nb29nDQo+
IA0KDQo=
