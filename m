Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0676567A849
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 02:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjAYBMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 20:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjAYBMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 20:12:18 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE061301AD;
        Tue, 24 Jan 2023 17:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674609136; x=1706145136;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XzPu5EuHYJTMTt81zZQhrZEjeOFYBmz5d4f44H5uWN8=;
  b=dCBq2lWWvnBQbk9C6rlWnFNFK+O6fcJgdb4H/NgdPUJxpCqkHwbGWdgX
   K9pjzdLTDmBc0zpFg1JN/yW2c6oHH1JNe6FvckHWwL4jbTwVNKjhjfZSB
   WW3FQLNIj+vX50KcnokAq7Tnz2ne9i6RYDgwtjnDLIu6Zdmr98ckfLbLN
   H0RvruOsqtH2CvtbZxNLt8PHvsV6wsdeTssJO8FJ7aYMBy5dGsRGUPDtz
   3k9DA2nfPaBawLQVxDmLteeDTWPTr5734KBQzqjZeDzhlH3jEfeXvMhs5
   rUf63095UShJ5giT+IamhG1JQNBVG2mwlTch6Q6zeyk+c2liNae49Jt1U
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="326488814"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="326488814"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 17:12:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="662337683"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="662337683"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 24 Jan 2023 17:12:14 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 17:12:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 17:12:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 17:12:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 17:11:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyogIwjvIitYvmKtyC6nDvXQR+OslCDvJ5cK2tvG9kVrD6C50eW85aP5yMFBf0BUwVUi7FGQqPrh18k41EXRa7tKHBgZwf3Vd30Ckx5ZXjZOSAJVV8bbyrzVXs6F0MlEZbptLhKcgLgnZSQ3krTX8oX+XsHll6UIqoCX7OUMfCKI4r2EH7hqA0W1XULSDubCKh50hKpleeqd3Qh8P8eBhBa+DSf+jrBkJ87+caNG4NmF6i787pCYXYF/UblgxPFP1hpdh9yKdwwXzf4SURD76zCt0r5DJmKvVLtQCVdiq1B5Rm6GIpnxB4Ic8vuJvPso27ny1ApGZ4VV8Mk68Zvayw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzPu5EuHYJTMTt81zZQhrZEjeOFYBmz5d4f44H5uWN8=;
 b=X+wqO04n0cUyIT030Mr0eK90rBYA0BcvTGNElJmGkDxNGkpam2dRPRRxhdYggWZfuNjVcSq0SuHMNxGwexmhAes/ON9DyzPOW8Ea98uF0b4lobJMLKKisRw5WTeUK8Y8yxn5vAYvggI9qDrJO1Y9kDALv86QjNDczC1/gWNVOYYl22taI9XpVGWTMvTS9bPgsQVjGVj+Zn9PJnR/VUCk0aYWF9alcyezljpebkD2fmgRTfzcAga4GGi2M6Dh2iT0R8ajinh8pbZvKCof0D4eIUoBDZm/v8wOT8aji5yAKaMrImV+67pMbRfrufjIiMaD72gOGagdA9ZgM/R5lRV0hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by PH7PR11MB8124.namprd11.prod.outlook.com (2603:10b6:510:237::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 01:11:45 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::d41f:9f07:ed56:a536]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::d41f:9f07:ed56:a536%3]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 01:11:45 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "john.allen@amd.com" <john.allen@amd.com>
CC:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 0/7] SVM guest shadow stack support
Thread-Topic: [RFC PATCH 0/7] SVM guest shadow stack support
Thread-Index: AQHY3nrHPT3eOd6fEEOV8MC5zbwdba6u8mKAgAAEogA=
Date:   Wed, 25 Jan 2023 01:11:44 +0000
Message-ID: <d4e15021af4e72d6daba4021feaebf289b676830.camel@intel.com>
References: <20221012203910.204793-1-john.allen@amd.com>
         <Y9B97dZnFnjEHhVf@google.com>
In-Reply-To: <Y9B97dZnFnjEHhVf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1392:EE_|PH7PR11MB8124:EE_
x-ms-office365-filtering-correlation-id: a87c21da-a24a-4efb-72da-08dafe712017
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7CVmtLFL8vY8FKS3/Ez39mxoW9wmmlTE5d50r6s2AVKVf29lHuwPXGkliHiri2+LqzsNPTDjJJuhDOWG35buUjJdS5NDYA029V7XBcU1C1r2gMawS72WqLW1nxYtJ35e8mnezB07wC8emG2kxt3b5kO+4dHG3abgEtiVJwqbdoic7FVlASeiOoLW48tExvNWnjVQw427LejQVKJKRZgNQRTzUDiHDx1vBSE6HjkZoDcYi3DLuoa8STLH6HDLmA7VTqvoB8uZ+60au2QsoL5vcMOFcOYI2HNGK3CNujvIgyPQk8rwbSDbEP5fzwgo1fVkBZg+ZCIIpDVeocasUZhnIkGhjd/Lb5LKnDOD7eaTUKZwxauAg2DoLD09iA8ZQSoNFBT3nHiNKmolx0iot/Acgr9oU0xJQcGJkL21i7i1j2YDfi/NuilkE783VIDAV5CKpd7H26j1YoEdHiAz+kyXkU+fiNLcPrPlwW60nQLzi44y+71uIjCcJY9L3Pau7ShUBdOrvF6CJtEEzwr5Hx4QsN7JxjjLl3BxikTluRrGBHUlk0SWRaUCLw0/apzJesddvQdmlCAJiZBd+PEdgtHOmjG6y3eoKZOMx6PuybJwOQW+q5SbsywnA+iuZljsdqnIM/pIR1D1YdqmKYXQzK7dAMpPvUu1J3P76sVibjVjlA+c01sTSBGHASjys8W/ZRttXu/JhYu6UdJKXNQevUf4xsUzmQfvn0W96NONSGKjb6cYAmRKE9pbNcBFdLR1N2Zfc0JpMBDWykrmQpL+A1hBbRqYh9Zl9VGxbvIaHx+UoI0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(82960400001)(38100700002)(36756003)(122000001)(86362001)(38070700005)(5660300002)(41300700001)(2906002)(26005)(64756008)(8676002)(66476007)(76116006)(4326008)(66556008)(66946007)(66446008)(6506007)(316002)(2616005)(8936002)(83380400001)(110136005)(966005)(6486002)(54906003)(71200400001)(6512007)(478600001)(186003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NG1ocW9ucjJJRXM4UDM4Q3dnTzJXY1V6Y3pFcldSUHRpVVFzTHlDTWw4bDAw?=
 =?utf-8?B?cTRjT2FRWlo5cW1XSDYvL2d0TlB0S1lOUUV6bFdEdytMYy9lQzI1OFFwaUpx?=
 =?utf-8?B?TWQwUkJ0RzRxM1B2VCt2WUNpOExSVVppWS9IS0lSVGJ6bUk3SEFhTDZEbEdK?=
 =?utf-8?B?LzFmVkdEVkJqdnpSbUR2Q1B3ck1OdFBuYTFUNDY5djEvVkRwbUtYejhLM2Zz?=
 =?utf-8?B?L2RaZ3B4RUtvYnpZQlZic0p6cGhyTFFMb0QzNCtOZzJxVUR2SkdoMGlXWThN?=
 =?utf-8?B?d3M1UUNlbDNDbWJ1Tk9DTlJuc09qdS9ySzZjY3pnU0hWRi9jaWlxMWF4eVB4?=
 =?utf-8?B?aVdWN0Y3dDN3SEVtaFZrZUtZbVBYMWRGWmlGaEhqQ3NFb1NDdnRuNXZTNER6?=
 =?utf-8?B?dzJvOHJ1anFsSzdsL1lpVlFSaVN5ZWxsZlZ5ZC9mc3R0Nmk2YlBTekViZG05?=
 =?utf-8?B?US9RVDE5Y016YzdrcDBiaS9YeHUvdy9UZFhFNThiOHRIVU9lVHBPa2JpZzJE?=
 =?utf-8?B?SUNSai9wYkJQc1pxdGdUaTJoODM1TW0xeHZjQ21FdkM3eGNKanBOdk82QXRp?=
 =?utf-8?B?c1lwcEx6eUlzK3lGalRKcFd6clVpSGtNQmMxZFp1MWxvcDd6NW84Z3BsRGJV?=
 =?utf-8?B?dTBSSGNJWVVlN0xBYWRmM05OMUJvYmlsdW1zTm9la2JMRzZqTTRHdHFpUlJ5?=
 =?utf-8?B?aFFxNmVzMThoMlpHTTBSMitrdDE1NUNObzVlQWRENjJMRzVSSUJ3bHdzeUNF?=
 =?utf-8?B?dy9Ha0k3YURPakx4V28xR0o5Sjkrb0tsVUZzVTNGc3VNeVl3K1RrOVBydVNu?=
 =?utf-8?B?dkJsdWRLUkN1cmZ5UVU4VU1SUXUwMUplUDVpelZhM29lZXgrazdsb0JnTXhF?=
 =?utf-8?B?bklkaEJIZTJMNWZHSVRNZzE3NnY0eGZDNTUxQmpReExIT01UNFlxYlkzSk5J?=
 =?utf-8?B?UHQyeVV3cXdydkk5UzNPUE9CQWdVQ3BJSmMvZW9yWVlJSVcyQ3lwRGt6bUdp?=
 =?utf-8?B?RktKQ05uVFZuUkxxVjBYN1BQZjFBSUFQV3MvUzk5cTNVQlNIL216SVpPTXhv?=
 =?utf-8?B?bGdJSHVZdmlXRXd3TmptSm5ITk1PUDZ6Z2srOThTMGt3eENveG5YTmI0aTY1?=
 =?utf-8?B?M1Z0MUNHNUdHekZyRkFSVlBYTjBpaytYb1NEZHA4ZXQ0L2ZxSG9waGdGQlE5?=
 =?utf-8?B?QlNRYlpEV0pzcVo3SEZadEVGREVlM3FWNWRyS2ZzQm84QVZuWmZ0TC8xUGl4?=
 =?utf-8?B?Qjh4cFI0dEp1RFRLQWdjaC9URldhQm9DS1VTa2ZlVGF2RmE0VnBucTZyU2Y5?=
 =?utf-8?B?WFlTV29qdlJiY09saDBhQk5NZllrNkNkS0xCR3d3RjRDZXAvNlRoa0RhdDdS?=
 =?utf-8?B?QWIvVzNsV1lWVmpkM0piWW0rb2UxS1NHTjFhWFJJYTI1cC9YblVDZFBSSWpm?=
 =?utf-8?B?RWxmd3M3ZStqV1RlTEl4OWVpRFVJQm5yY0U5Y3NvSHRzeHc1ZjJUY3phY1Fl?=
 =?utf-8?B?NTllRFZrUnEwZGRPUm1qcVozVmlNdzdrSlRkVFBhT3NqTVQ2YjNSOFROakRr?=
 =?utf-8?B?aFB0OFlPNTJXTFVyQml4a2Y4ekZHL3FrMzZUdU9TTnpzWFpSbG9vV3RhSGtR?=
 =?utf-8?B?bHU2RkRXMHNCejBmYThvbERvNHJjZ0YyN2xwZGYwMEkwTUh0bkNFY2dYOE5q?=
 =?utf-8?B?NWtSTzdWM1dpYTZOZ21vaDllQlg0Mmt6MWcrQ25VdkhzMkRwejB0MzQxOU1p?=
 =?utf-8?B?SGd5bldJR0o1ckNuNzVCeE1wUGxFVUdySlEyVFZ1YzN3Q3BDY0ovd2JuenJy?=
 =?utf-8?B?amhQczlFN1Q5OTB4TUpzYWREc0dybE9CUXRZeFE0MmM1UWNvVFJxcUxlME1B?=
 =?utf-8?B?WlhnZmhWMU1iOVd0YnR2T0ZTZEt0NXRpM2ZpbEpHVDI3RlhJVFIxNGRpVWta?=
 =?utf-8?B?VkE4cFJoekpYajVTT2l4Z09RN056dXR0RnpuWnd5TDZMcXN5MWQ5bmd1Z2ZX?=
 =?utf-8?B?emVUR0h3ZHRIb3B6R3hGd3dCYVA5WENOeDQ4OWhUbEwzMGFob1ZySktGc1hN?=
 =?utf-8?B?b1RrZXpnYkY1RlhmOGc0NmYzNWlpREJFck5jZ1VkZkJQZG1hYk1OZXF4SkhH?=
 =?utf-8?B?ZWtvR29YeHZ1UVV4TFYzdHUyRk8rK0Nnbm04VUtucHRtMlM2c0s2S3JodG93?=
 =?utf-8?Q?yvhVP2OMG07COtg/jsmQDCg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CA2273A43870E4FB29EFC193554C5D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87c21da-a24a-4efb-72da-08dafe712017
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 01:11:44.9357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uTOH0+84w5Nn1d2QrbB8XTcTyrR1QSbONajiTjTrwMw3piG3pYWqm0KTXQ6mUl5ao8E1KZmZqfIxnRKCsNOXXcL6T/ZCY3awwCNJgWTKbm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8124
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAxLTI1IGF0IDAwOjU1ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE9jdCAxMiwgMjAyMiwgSm9obiBBbGxlbiB3cm90ZToNCj4gPiBBTUQg
WmVuMyBhbmQgbmV3ZXIgcHJvY2Vzc29ycyBzdXBwb3J0IHNoYWRvdyBzdGFjaywgYSBmZWF0dXJl
DQo+ID4gZGVzaWduZWQgdG8NCj4gPiBwcm90ZWN0IGFnYWluc3QgUk9QIChyZXR1cm4tb3JpZW50
ZWQgcHJvZ3JhbW1pbmcpIGF0dGFja3MgaW4gd2hpY2gNCj4gPiBhbiBhdHRhY2tlcg0KPiA+IG1h
bmlwdWxhdGVzIHJldHVybiBhZGRyZXNzZXMgb24gdGhlIGNhbGwgc3RhY2sgaW4gb3JkZXIgdG8g
ZXhlY3V0ZQ0KPiA+IGFyYml0cmFyeQ0KPiA+IGNvZGUuIFRvIHByZXZlbnQgdGhpcywgc2hhZG93
IHN0YWNrcyBjYW4gYmUgYWxsb2NhdGVkIHRoYXQgYXJlIG9ubHkNCj4gPiB1c2VkIGJ5DQo+ID4g
Y29udHJvbCB0cmFuc2ZlciBhbmQgcmV0dXJuIGluc3RydWN0aW9ucy4gV2hlbiBhIENBTEwgaW5z
dHJ1Y3Rpb24NCj4gPiBpcyBpc3N1ZWQsIGl0DQo+ID4gd3JpdGVzIHRoZSByZXR1cm4gYWRkcmVz
cyB0byBib3RoIHRoZSBwcm9ncmFtIHN0YWNrIGFuZCB0aGUgc2hhZG93DQo+ID4gc3RhY2suIFdo
ZW4NCj4gPiB0aGUgc3Vic2VxdWVudCBSRVQgaW5zdHJ1Y3Rpb24gaXMgaXNzdWVkLCBpdCBwb3Bz
IHRoZSByZXR1cm4NCj4gPiBhZGRyZXNzIGZyb20gYm90aA0KPiA+IHN0YWNrcyBhbmQgY29tcGFy
ZXMgdGhlbS4gSWYgdGhlIGFkZHJlc3NlcyBkb24ndCBtYXRjaCwgYSBjb250cm9sLQ0KPiA+IHBy
b3RlY3Rpb24NCj4gPiBleGNlcHRpb24gaXMgcmFpc2VkLg0KPiA+IA0KPiA+IFNoYWRvdyBzdGFj
ayBhbmQgYSByZWxhdGVkIGZlYXR1cmUsIEluZGlyZWN0IEJyYW5jaCBUcmFja2luZyAoSUJUKSwN
Cj4gPiBhcmUNCj4gPiBjb2xsZWN0aXZlbHkgcmVmZXJyZWQgdG8gYXMgQ29udHJvbC1mbG93IEVu
Zm9yY2VtZW50IFRlY2hub2xvZ3kNCj4gPiAoQ0VUKS4gSG93ZXZlciwNCj4gPiBjdXJyZW50IEFN
RCBwcm9jZXNzb3JzIG9ubHkgc3VwcG9ydCBzaGFkb3cgc3RhY2sgYW5kIG5vdCBJQlQuDQo+ID4g
DQo+ID4gVGhpcyBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBzaGFkb3cgc3RhY2sgaW4gU1ZNIGd1
ZXN0cyBhbmQgYnVpbGRzDQo+ID4gdXBvbiB0aGUNCj4gPiBzdXBwb3J0IGFkZGVkIGluIHRoZSBD
RVQgZ3Vlc3Qgc3VwcG9ydCBwYXRjaCBzZXJpZXMgWzFdIGFuZCB0aGUgQ0VUDQo+ID4ga2VybmVs
DQo+ID4gcGF0Y2ggc2VyaWVzIFsyXS4gQWRkaXRpb25hbCBwYXRjaGVzIGFyZSByZXF1aXJlZCB0
byBzdXBwb3J0IHNoYWRvdw0KPiA+IHN0YWNrDQo+ID4gZW5hYmxlZCBndWVzdHMgaW4gcWVtdSBb
M10gYW5kIGdsaWJjIFs0XS4NCj4gPiANCj4gPiBbMV06IENFVCBndWVzdCBzdXBwb3J0IHBhdGNo
ZXMNCj4gPiANCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIyMDYxNjA4NDY0My4xOTU2
NC0xLXdlaWppYW5nLnlhbmdAaW50ZWwuY29tLw0KPiA+IA0KPiA+IFsyXTogTGF0ZXN0IENFVCBr
ZXJuZWwgcGF0Y2hlcw0KPiA+IA0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjIwOTI5
MjIyOTM2LjE0NTg0LTEtcmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20vDQo+IA0KPiBUaGF0IGRl
cGVuZGVuY3kgY2hhaW4gbWFrZXMgbWUgc2FkLg0KPiANCj4gT3V0c2lkZSBvZiBhIHZlcnkgc2hh
bGxvdyBjb21tZW50IG9uIHRoZSBsYXN0IHBhdGNoLCBJIGRvbid0IHBsYW4gb24NCj4gcmV2aWV3
aW5nDQo+IHRoaXMgdW50aWwgdGhlIGtlcm5lbCBzaWRlIG9mIHRoaW5ncyBnZXRzIG91dCBvZiBv
dXIgd2F5LiAgV2hlbiB0aGF0DQo+IGZpbmFsbHkNCj4gZG9lcyBoYXBwZW4sIEknbGwgZGVmaW5p
dGVseSBwcmlvcml0aXplIHJldmlld2luZyBhbmQgbWVyZ2luZyB0aGlzDQo+IGFuZCB0aGUgS1ZN
DQo+IEludGVsIHNlcmllcy4gIEknZCBsb3ZlIHRvIHNlZSB0aGlzIGxhbmQuDQoNCkkgdGhpbmsg
YWxsIEtWTSBuZWVkcyBpcyBhIGZldyBwYXRjaGVzIGZyb20gdGhlIGJlZ2lubmluZyBvZiB0aGUg
aG9zdA0Kc2VyaWVzICh0aGUgRlBVIHN0dWZmKS4gQXQgb25lIHBvaW50IFdlaWppYW5nIGFuZCBJ
IGhhZCBkaXNjdXNzZWQgd2l0aA0KUGFvbG8gYW5kIHg4NiBmb2xrcyB0aGF0IHRob3NlIGZldyBj
b3VsZCBnbyB1cCB3aXRoIHRoZSBLVk0gc2VyaWVzIGlmDQpkZXNpcmVkLg0K
