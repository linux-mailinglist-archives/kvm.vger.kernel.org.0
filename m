Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB627040D9
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 00:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245615AbjEOWVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 18:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245188AbjEOWVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 18:21:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F8F1BDF;
        Mon, 15 May 2023 15:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684189265; x=1715725265;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OhvCJYtpvOjA4JXSQH77p0SWuWmR8qyS0mDaa6gJpJg=;
  b=NanRrnKEJbgMGSmdV9gkIxOgkqGXoZafnBBzMQM/Fcnbias853ocTbQ7
   tkg78YwhNAltEtcltf8MjM90RHCPCTYP+k08p6BqvPuRLQJm/J7rC8KMT
   yF3iACc1h86V34U9bpHx5VZv6WZB3w7QByB4B9zgm2i30+HidmOdhWgoc
   qS4MK+Pk4yEDlOzl4ezYk4VOO2J6hrBv5IIaNdLptRcCsP8qiUMi/6dYs
   vPlRwNKxB8Q37bis4OpzL3PcmbKCoWzSdlUZ/QM4hjH3UAGimHHS2sxZ3
   KzIbEflV8IjEtGZTKN/Pu5JLnMG0CNKnDfTho8j48a9mYNeSlVdlqY0BH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="348820580"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="348820580"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 15:21:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="1031054330"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="1031054330"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 15 May 2023 15:21:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 15:21:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 15:21:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 15:21:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 15:21:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0On/SDRWPrL/dNnglBLllFJNHMEf/5fdmLRBfG84DOpQicJdIq9kLsN33xRVzlMG9d5camYEurNdWvbWb4oQgS2mxpTN5SMd1HlTHCTwzybMf/vtcHo6rsPwHrN6bQxkxkEIbeJ18Ss5/AU0vMavpM17gF2YCJeDg0Ac+5CxE0BhEHkovAesy1gO5rhhLzLWuhZz7OVcikQ2uvem5RnZKhyHzx3h6vKFY0hZc/L3SpXuXmhuGVXXWGfYRzpB7WG2bZC/3jxPRFXg47eyb4j4iOcbVogp6Ii9QNb/CXml/TD9O8EbtFcpHmKg4AUYPTScYZ/hhaxeGwVt2SxtdGHcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhvCJYtpvOjA4JXSQH77p0SWuWmR8qyS0mDaa6gJpJg=;
 b=HvySBdE2VYax6vt0LU+I6hUcLSvb45Bxu/WuXMY/1VCTbEP9m5nIiQgUMCLmOwkc1LcFJV4Xl0RogzApYYmBcfczhooLIpafLAYP6bgco7+/kAWH8XfFq6za0L1uB8PpXRUGdAegzbY8il9HFpD/6GaetdGqgIR19Ro3JsuP2Z9Z+WpY89xvLHdhp/dNGFNSB5Xagk+N7gpUV92Be7A57o/R2oRHQpXUVGXR+W1P/TZnK8Z736b7gjhq8k1ndXN8Vp6wnaD7/0ngqDnHZaIlci6V3PKPjUgoshg8op5OzzBnweXp94BbyNZfpuREcUsPo1OBwqlUhKZ2bIKj7IxVYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5377.namprd11.prod.outlook.com (2603:10b6:610:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 22:21:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 22:21:01 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Thread-Topic: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Thread-Index: AQHZhGEcNSDg8JA/dkmFf9j26efTAK9WchSAgABkvQCAA6tDgIABIFAAgABL5QA=
Date:   Mon, 15 May 2023 22:21:00 +0000
Message-ID: <0c036de92f6196c0796a62f01cd2e6b66e717865.camel@intel.com>
References: <20230511233351.635053-1-seanjc@google.com>
         <20230511233351.635053-6-seanjc@google.com>
         <ecbcfb6ca243cf587eb6e61c6e852b4f474a36d7.camel@intel.com>
         <ZF5qnQQYa6OAI0Hy@google.com>
         <7972883f69abe6fe61a2e76def6a0a1f1f28228b.camel@intel.com>
         <ZGJwoFCWVWMSX5c3@google.com>
In-Reply-To: <ZGJwoFCWVWMSX5c3@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5377:EE_
x-ms-office365-filtering-correlation-id: a16023b5-308b-4355-a7f2-08db5592aa0a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hCUN7KayCFFEJMTvB2AFSsimeAsvIvnd25wqU4BF1qSIkEOb8Fja5r4VBWOlanxOIt4G3CxTdHYjcNUh0v57X3rXNcnYVnDvzHBvxkiuiKjPiM2bidKk0m1YLj8YaujDcT51ONEh9nXkkugr9pP9MQF1tWVoWKgqg0RhEmsb+6UashSS47TlWXG/0QH+/Oo3Gz0vA2rSs3tvXv7/C3K+8PhJiUXOE64LUZxemeQi7jUc8VG02+nZILyAuGKRmFg7L1aak4QH/ntuiPTx8cHwaaVufVjGDLbgVrzYkoG6Yvc+koV1/XBdt99G7fUcwpB6eAssTVGqAhPfCZoqTvHp0poVP1iDPMdgAjrRRXiHLp0sp5PzTtdLxNM2gy4gF9KlyJPCH0gniQ7daQDwIiEmmRpA+6F17r1QCwVkK2wJDyNXzcnAIBJvEIXSLC865jxb/5JplJZyYWWS1AiONfszEgNWqnwm3PlWy1/P/wB3of0gRAg94gCJvuKFgS9mAE4zWB9/7qYe8DRgqXgJk6T8mqQ4Hyf7e/X0P4zX/3VStzttGjestoYfVt8GSFlwlXGC1ijYGADY2TS+LFuCtrfzK+GV6tfBQ3yA8NtYBzm9t7A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199021)(36756003)(91956017)(86362001)(54906003)(316002)(66476007)(66556008)(478600001)(6916009)(66446008)(4326008)(66946007)(64756008)(966005)(76116006)(6486002)(8676002)(8936002)(5660300002)(2906002)(38070700005)(38100700002)(82960400001)(122000001)(41300700001)(2616005)(6512007)(107886003)(26005)(186003)(6506007)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWNYVXBrdXpJWHF6N3N6MVdYU2dOTi9TY0lWWi9Panh2WGpOQ2NKYmxZd3A3?=
 =?utf-8?B?M0dSVEJDWmQ0NlQzZjRRenBUU0w5ZWlKbHVjeE5weERDZmlIYXNLUjQ1Qnhp?=
 =?utf-8?B?aTJYelE3VVlLcHBwdjZTeU0yNXNnQUxhdldRUXVQSXIrTExiRnFueW5XRE9j?=
 =?utf-8?B?NnZpZFVTc0ZTV3ZyS1FsdStidU5taW5IbGpkWTZheFg3VVdadzdFUEV1bjlP?=
 =?utf-8?B?eWlVVTVCNDVtS2U3N2xjQndsai81OEVrN05aRGJwT0VKZ2dVd1pQS0FFSUFh?=
 =?utf-8?B?Q0g5ejMwZ1JQRWxZdDBMWVhjWVhCbXViSkFxQW1CZ1hRbTVjNkdhZDZESDQz?=
 =?utf-8?B?U1IrTlIrdEZ2ZSs0WEoxQ3M5ejhvcnRTejlTcXNobUw2bWFkdFljSXUvWi9u?=
 =?utf-8?B?N1ZpUjh3TG9JYmpGUzJRcWU1WEw3OXNsbTZvTlBtOVBqNHNlY2cybWVkSFZP?=
 =?utf-8?B?Tmx1MWNhamhVeTdwVGxlZDBzaklKSUdwMWl3eXV5N0VNd3NOdUh4bENVak1J?=
 =?utf-8?B?eVFja2orMUZ2YlZPVmp0V3JNMWdOVkxBblZOYzFyTFE1Q0hWTnhRVUVFNGt4?=
 =?utf-8?B?VFA5STJNbEdobzhRLzVrVlQ2NytGc3FodDl5T2syeFZuWjRMaVRablBKL1Uw?=
 =?utf-8?B?VWZPZGZ0c3FHWUplamc3M21CYWJuMlNOQW1PRnkvYmhVZk1aWWZQOUYwTGZY?=
 =?utf-8?B?QzQvMmhIYlJpUnFqdVAzZGFSS2gwS3lWZTVxb3ltdUxNTDF1NkR6NDNkM0xh?=
 =?utf-8?B?N2QwcHlTaFZBUEtqUU56cHdzSmJ1SStFbnJjRTBYUUhsOGdBV1NMdE1wUXBO?=
 =?utf-8?B?MWVkUkNMRytPNFRLRi80SjBlZnRKdEoyVmM5R3pOZ0FyTHg4L3prNHNYT3BZ?=
 =?utf-8?B?QU5BeHRlc2MzeXhkU3BtMFVLRm16dENvR3IwZE9QZUtOdWVzN2d5ZWNQbWtE?=
 =?utf-8?B?c1c2OXVNdHR1N0ZlQkg4NGdyKzZ4cjVoK1hmUWJWZUtLME0xMlQwdFFYMFAv?=
 =?utf-8?B?Z1RDcUVSakZrbVZkSDBDL2VrOUZOZEt4SHdRcWdJNm1wN3pFRnpIczVtYURB?=
 =?utf-8?B?azM0bm1kSE1vejN1Q0twT0F6dFE5bTZFUU9nLzZHcjJVbERFby9kdE5FVnFv?=
 =?utf-8?B?Wk83TUtDWjhDSlRjOTBmT0xtcmttK1RJNFJSV3drRWhHaVJiZlpwR3o3Y2lz?=
 =?utf-8?B?Qk5NTlVMVlAzcWhxQUNidm45TnRwSkZqc1QycU5UZkpmS2h6NFNMMHBpdU52?=
 =?utf-8?B?ZTFTZWNsaWZHaG8wVnRoQkZCSk9BdWhsZFV3aDJFV2l3NStRZjJFZzhXOU1Y?=
 =?utf-8?B?VTkyUXEvcktwaWlmbG0zVnJFbjdNaWx5cGdDeEtYbU9OWkFIK25yd3JWTzgx?=
 =?utf-8?B?dHMvaktnYjFQQlI0TXl0SEdTN2RaaXBQc3k0WlZpdExIVmR2MStLZzBUTlQr?=
 =?utf-8?B?NlJyeGRJejJOcmxQWFpYeWpXeEpNTGhveXhpaE9hVW9vRWtSZ2xocTAxQXZ5?=
 =?utf-8?B?MGxtWnRsdnJVVXRMbzVyK3ZCUHdwOUZJTnVUY283SVVUU2k1Znphc09YUk9V?=
 =?utf-8?B?eU96dTZ4dVRCZ0VGa1M4bDdzQlkvcWxwazZxZUttQTMxZmlSMTFLR1EwVHhR?=
 =?utf-8?B?akNQZzVRZStCUjQ5cEkrWkpQUUx2MWIvUWsyYy9hQzZOSHZMQTkvR09XaHR6?=
 =?utf-8?B?WFFzMm5lR0l3MDRza2UxQW8ySzRzaUxDcFR2MmlOeFk4SDdOTGVCMUExWVll?=
 =?utf-8?B?WERrNnVjTk5QbER6N1NkOGRLMWhVT1BKdFV1MFcxc2xwNG8xWGJiVEF2b3F1?=
 =?utf-8?B?QUdIbnJWK2wrdUltMW9TRDFwTE15UURDQUdzQkhScm1PcDhrOGVKMjlud2V5?=
 =?utf-8?B?cGEzc0tHVGRaRGp5UDR5OUhySUJ5akhMR1I3WXZOQlZ2YlNpNXZTOVozc0E3?=
 =?utf-8?B?cEluTXdiSHJnRUZKdkhlN2MxeXdiTnYrS0FSdEV0VjRRWmU4bnVzU2d2Y21s?=
 =?utf-8?B?TlF0MUhCY09VQy9nWStmSVY5amtYelF0bmdJdmw3TGZOTGc3SGFSOG9uRnBC?=
 =?utf-8?B?MHltM3pMc3hNM2RZYnlaSHZIT1NhZlRVaSsxSDViOHBlaXQ4UWhSQjNSalBQ?=
 =?utf-8?Q?pUnXu9H9/zONebkDALzM3np2Q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3847075B8065F44D9FA23FF5BCA94189@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16023b5-308b-4355-a7f2-08db5592aa0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 22:21:00.8891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cL3AzKJ/BTbklRyQv84DrCx7+GU7WA8ZXNrv1bzBkTk9TmD+34eIHDUzvpvZVgGBc7lUlNauPOsipQmKPETGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5377
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA1LTE1IGF0IDEwOjQ5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1heSAxNSwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMjAyMy0wNS0xMiBhdCAwOTozNSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIEZyaSwgTWF5IDEyLCAyMDIzLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IE9u
IFRodSwgMjAyMy0wNS0xMSBhdCAxNjozMyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90
ZToNCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYv
a3ZtL3g4Ni5jDQo+ID4gPiA+ID4gaW5kZXggZTdmNzhmZTc5YjMyLi44YjM1NmM5ZDhhODEgMTAw
NjQ0DQo+ID4gPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gPiA+ID4gKysrIGIv
YXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gPiA+ID4gQEAgLTM3MDAsOCArMzcwMCw5IEBAIGludCBr
dm1fc2V0X21zcl9jb21tb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QgbXNyX2RhdGEg
Km1zcl9pbmZvKQ0KPiA+ID4gPiA+ICAJCQlyZXR1cm4gMTsNCj4gPiA+ID4gPiAgCQl9DQo+ID4g
PiA+ID4gIAkJYnJlYWs7DQo+ID4gPiA+ID4gLQljYXNlIDB4MjAwIC4uLiBNU1JfSUEzMl9NQzBf
Q1RMMiAtIDE6DQo+ID4gPiA+ID4gLQljYXNlIE1TUl9JQTMyX01DeF9DVEwyKEtWTV9NQVhfTUNF
X0JBTktTKSAuLi4gMHgyZmY6DQo+ID4gPiA+ID4gKwljYXNlIE1TUl9JQTMyX0NSX1BBVDoNCj4g
PiA+ID4gPiArCWNhc2UgTVRSUnBoeXNCYXNlX01TUigwKSAuLi4gTVNSX01UUlJmaXg0S19GODAw
MDoNCj4gPiA+ID4gPiArCWNhc2UgTVNSX01UUlJkZWZUeXBlOg0KPiA+ID4gPiA+ICAJCXJldHVy
biBrdm1fbXRycl9zZXRfbXNyKHZjcHUsIG1zciwgZGF0YSk7DQo+ID4gPiA+ID4gIAljYXNlIE1T
Ul9JQTMyX0FQSUNCQVNFOg0KPiA+ID4gPiA+ICAJCXJldHVybiBrdm1fc2V0X2FwaWNfYmFzZSh2
Y3B1LCBtc3JfaW5mbyk7DQo+ID4gPiA+ID4gQEAgLTQxMDgsOSArNDEwOSwxMCBAQCBpbnQga3Zt
X2dldF9tc3JfY29tbW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICpt
c3JfaW5mbykNCj4gPiA+ID4gPiAgCQltc3JfaW5mby0+ZGF0YSA9IGt2bV9zY2FsZV90c2MocmR0
c2MoKSwgcmF0aW8pICsgb2Zmc2V0Ow0KPiA+ID4gPiA+ICAJCWJyZWFrOw0KPiA+ID4gPiA+ICAJ
fQ0KPiA+ID4gPiA+ICsJY2FzZSBNU1JfSUEzMl9DUl9QQVQ6DQo+ID4gPiA+ID4gIAljYXNlIE1T
Ul9NVFJSY2FwOg0KPiA+ID4gPiANCj4gPiA+ID4gLi4uIFNob3VsZCB3ZSBwdXQgTVNSX0lBMzJf
Q1JfUEFUIGFmdGVyIE1TUl9NVFJSY2FwIHNvIGl0IGNhbiBiZSBzeW1tZXRyaWMgdG8NCj4gPiA+
ID4ga3ZtX3NldF9tc3JfY29tbW9uKCk/DQo+ID4gPiA+IA0KPiA+ID4gPiBMb29rcyB0aGVyZSdz
IG5vIHJlYXNvbiB0byBwdXQgaXQgYmVmb3JlIE1TUl9NVFJSY2FwLg0KPiA+ID4gDQo+ID4gPiBO
bywgaXQncyBhYm92ZSBNVFJSY2FwIGZvciB0d28gcmVhc29uczoNCj4gPiA+IA0KPiA+ID4gIDEu
IFdoZW4gUEFUIGlzIG1vdmVkIG91dCBvZiBtdHJyLmMsIFBBVCBkb2Vzbid0IGdldCBidW5kZWQg
d2l0aCB0aGUgb3RoZXIgTVRSUnMNCj4gPiA+ICAgICBhbmQgc28gd291bGQganVzdCBuZWVkIHRv
IGJlIGhvaXN0ZWQgYmFjayB1cC4gIFRoZSBlbmQgY29kZSBsb29rcyBsaWtlOg0KPiA+ID4gDQo+
ID4gPiAJY2FzZSBNU1JfSUEzMl9DUl9QQVQ6DQo+ID4gPiAJCW1zcl9pbmZvLT5kYXRhID0gdmNw
dS0+YXJjaC5wYXQ7DQo+ID4gPiAJCWJyZWFrOw0KPiA+ID4gCWNhc2UgTVNSX01UUlJjYXA6DQo+
ID4gPiAJY2FzZSBNVFJScGh5c0Jhc2VfTVNSKDApIC4uLiBNU1JfTVRSUmZpeDRLX0Y4MDAwOg0K
PiA+ID4gCWNhc2UgTVNSX01UUlJkZWZUeXBlOg0KPiA+ID4gCQlyZXR1cm4ga3ZtX210cnJfZ2V0
X21zcih2Y3B1LCBtc3JfaW5mby0+aW5kZXgsICZtc3JfaW5mby0+ZGF0YSk7DQo+ID4gDQo+ID4g
U29ycnkgSSBtaXN0YWtlbmx5IHRob3VnaHQgTVNSX01UUlJjYXAgd2Fzbid0IGhhbmRsZWQgaW4g
a3ZtX210cnJfZ2V0X21zcigpLiANCj4gPiBZZXMgbG9va3MgZ29vZCB0byBtZS4NCj4gPiANCj4g
PiA+ICANCj4gPiA+ICAyLiBUaGVyZSBpcyBubyBNU1JfTVRSUmNhcCBjYXNlIHN0YXRlbWVudCBp
biBrdm1fc2V0X21zcl9jb21tb24oKSBiZWNhdXNlIGl0J3MNCj4gPiA+ICAgICBhIHJlYWQtb25s
eSBNU1IsIGkuZS4gdGhlIHR3byBjYW4ndCBiZSBzeW1tZXRyaWMgOi0pDQo+ID4gDQo+ID4gRG8g
eW91IGtub3cgd2h5IGl0IGlzIGEgcmVhZC1vbmx5IE1TUiwgd2hpY2ggZW5hYmxlcyBib3RoIEZJ
WEVEIHJhbmdlcyBhbmQNCj4gPiAoZml4ZWQgbnVtYmVyIG9mKSBkeW5hbWljIHJhbmdlcz8NCj4g
DQo+IE1UVFJjYXAgZG9lc24ndCAiZW5hYmxlIiBhbnl0aGluZywgaXQncyBhIGNhcGFiaWxpdGll
cyBNU1IgKE1UUlIgQ2FwYWJpbGl0eSBpcw0KPiBpdHMgZ2l2ZW4gbmFtZSBpbiB0aGUgU0RNKSwg
c2ltaWxhciB0byBBUkNIX0NBUEFCSUxJVElFUywgUEVSRl9DQVBBQklMSVRJRVMsIGV0Yy4NCj4g
VGhleSdyZSBhbGwgZXNzZW50aWFsbHkgQ1BVSUQgbGVhZnMsIGJ1dCBwcmVzdW1hYmx5IGFyZSBN
U1JzIGR1ZSB0byBiZWluZyByZWxldmFudA0KPiBvbmx5IHRvIENQTDAuICBPciBtYXliZSBzb21l
IGhpZ2hlciB1cHMgYXQgSW50ZWwganVzdCBzcGluIGEgd2hlZWwgdG8gZGV0ZXJtaW5lDQo+IHdo
ZXRoZXIgdG8gdXNlIGEgQ1BVSUQgbGVhZiBvciBhbiBNU1IuICA6LSkNCg0KSSBtZWFudCBpdCBt
YXkgbWFrZSBzZW5zZSB0byBhbGxvdyBRZW11IHRvIGNvbmZpZ3VyZSBpdC4gIEFueXdheSB0aGFu
a3MhDQoNCj4gDQo+ID4gSSBhbSBhc2tpbmcgYmVjYXVzZSB0aGVyZSdzIGEgeDg2IHNlcmllcyB0
byBmYWtlIGEgc2ltcGxlIHN5bnRoZXRpYyBNVFJSIHdoaWNoDQo+ID4gbmVpdGhlciBoYXMgZml4
ZWQgbm9yIGR5bmFtaWMgcmFuZ2VzIGJ1dCBvbmx5IGhhcyBhIGRlZmF1bHQgTVNSX01UUlJkZWZU
eXBlOg0KPiA+IA0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMzA1MDkyMzM2
NDEuR0daRnJaQ1RESDdWd1VNcDVSQGZhdF9jcmF0ZS5sb2NhbC9ULw0KPiA+IA0KPiA+IFRoZSBt
YWluIHVzZSBjYXNlcyBhcmUgWGVuIFBWIGd1ZXN0cyBhbmQgU0VWLVNOUCBndWVzdHMgcnVubmlu
ZyB1bmRlcg0KPiA+IEh5cGVyLVYsIGJ1dCBpdCBhcHBlYXJzIFREWCBndWVzdCBpcyBhbHNvIGRl
c2lyZWQgdG8gaGF2ZSBzaW1pbGFyIGhhbmRsaW5nLA0KPiA+IGJlY2F1c2U6w6/Cv8K9DQo+ID4g
DQo+ID4gMSkgVERYIG1vZHVsZSBleHBvc2VzIE1UUlIgaW4gQ1BVSUQgdG8gZ3Vlc3QsIGJ1dCBo
YW5kbGVzIG5vdGhpbmcgYWJvdXQgTVRSUg0KPiA+IE1TUnMgYnV0IG9ubHkgaW5qZWN0cyAjVkUu
DQo+ID4gDQo+ID4gMikgVERYIG1vZHVsZSBhbHdheXMgbWFwcyBndWVzdCBwcml2YXRlIG1lbW9y
eSBhcyBXQiAoYW5kIGlnbm9yZXMgZ3Vlc3QncyBQQVQNCj4gPiBJSVVDKTsNCj4gPiANCj4gPiAz
KSBGb3Igc2hhcmVkIG1lbW9yeSwgdy9vIG5vbi1jb2hlcmVudCBETUEgZ3Vlc3QncyBNVFJScyBh
cmUgaWdub3JlZCBieSBLVk0NCj4gPiBhbnl3YXkuICBURFggZG9lc24ndCBvZmZpY2lhbGx5IHN1
cHBvcnQgbm9uLXRydXN0ZWQgZGV2aWNlIGFzc2lnbm1lbnQgQUZBSUNULg0KPiA+IEV2ZW4gd2Ug
d2FudCB0byBjb25zaWRlciBub24tY29oZXJlbnQgRE1BLCBpdCB3b3VsZCBvbmx5IGFkZCBjb25m
dXNpb24gdG8gaG9ub3INCj4gPiBndWVzdCdzIE1UUlJzIHNpbmNlIHRoZXkgY2FuIHBvaW50IHRv
IHByaXZhdGUgbWVtb3J5LCB3aGljaCBpcyBhbHdheXMgbWFwcGVkIGFzDQo+ID4gV0IuDQo+IA0K
PiBZZWFoLCBJIHRoaW5rIHRoZSBiZXN0IG9wdGlvbiBpcyBmb3IgS1ZNIHRvIGRpc2FsbG93IGF0
dGFjaGluZyBub24tY29oZXJlbnQgRE1BDQo+IHRvIFREWCBWTXMuICBBRkFJSywgdGhlcmUncyBu
byB1c2UgY2FzZSBmb3Igc3VjaCBhIHNldHVwLg0KDQorSXNha3UsDQoNClByZXN1bWFibHkgdGhl
IG9ubHkgY2FzZSBpcyBhc3NpZ25pbmcgR1BVIHRvIFREWCBWTXMsIGJ1dCBhZ2FpbiBub3Qgc3Vy
ZSB3ZSBuZWVkDQp0byBjb25zaWRlciB0aGlzIGFzIEFGQUlDVCBURFggKm9mZmljaWFsbHkqIGRv
ZXNuJ3Qgc3VwcG9ydCB1bnRydXN0ZWQgZGV2aWNlDQpwYXNzdGhyb3VnaC4gIElzYWt1IG1heSBo
YXZlIG1vcmUgaW5mb3JtYXRpb24uDQoNCkFuZCBJc2thdSwNCg0KRG8geW91IGhhdmUgYW55IGNv
bW1lbnRzIGhlcmUsIGVzcGVjaWFsbHkgY29uc2lkZXJpbmcgVERYIDIuMCBzdXBwb3J0IGZvciBU
RUUtDQpJTz8gIFdlIHByb2JhYmx5IG5lZWQgYSBzb2x1dGlvbiB0aGF0IGlzIGZ1dHVyZSBleHRl
bnNpYmxlLg0KDQo+IA0KPiA+IFNvIGJhc2ljYWxseSBsb29rcyB0aGVyZSdzIG5vIHZhbHVlIHRv
IGV4cG9zaW5nIEZJWEVEIGFuZCBkeW5hbWljIE1UUlIgcmFuZ2VzIHRvDQo+ID4gVERYIGd1ZXN0
Lg0KPiANCj4gQWdyZWVkLg0KDQo=
