Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8731B6D7A67
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbjDEKxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbjDEKxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:53:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F811AB;
        Wed,  5 Apr 2023 03:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680691989; x=1712227989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MkZ2gE13I1UcU0OaWmNUYcnAGe/Vxa0Pe6PhDl19euE=;
  b=lgFqYfka7HCZ0rpGKhSgaUfnZ8+vrHdCCBjM8FYaHoQI1iwPJ+nB3QgM
   1k17EsE0TfVNU+8mswHPFm/nxe5m651l48RVppD/8hnVIyDIPuYJzgNHf
   VbGuoHimWtfXRxRnwdzDOeejUR1ff7lEdm1ypIj8VhslKbL/hyrbhPERZ
   BzWq0E9LxxmkeMWFkmJ21E4E02Af7J/gKs+VTyILNDHt3E2WHfQehjglw
   RNgxkc1+K5jMKQsezmU1RUdK5llz7S4n4dPmh1glZJl5Tdt4MbfSU2qh7
   RED89xclAWWhLy0y++eS44bmL3oIJcC4myyxyuTMCtS6PVfaENZC6xhrb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="405196093"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="405196093"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 03:53:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719275452"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="719275452"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 05 Apr 2023 03:53:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 03:53:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 03:53:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 03:53:07 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 03:53:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cE29MM8qhgp37BO5yTKsL7DME9TYYYlAKboN2es9URJe7k65kog0oXh93ht3FYiQ+octgXe0/0Xr0OkfYWQUVquPbxe1s71zgzOXdcx7+d6UIdIDBhZEBjWmcmoaAU7N0kh4jExwk8YSAwJg7n8irVMYUsE7Syf2ICybGVUaK+HENa8QvVXVIjKIxYNZxBZiOsS3IBpXzKkdsocv8MNqO9DwWHtX+0u1gGtprvV/fKJfkUdPuAfX7pp41PKn3qCwyfGcvDgkV6YCHASeWhOSyF+XmG8IvJFVyHS5V5fVmbLNJ2odwbFF5hlKRyU+gRD7qq/hjgeBFodyjYqeUlagyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkZ2gE13I1UcU0OaWmNUYcnAGe/Vxa0Pe6PhDl19euE=;
 b=cOW1yjvxbiNNPZXa/6j5VUqXknwBnIUFYSl8JrVKjwVnoR2eTd6h2H2QGbADkTAWxAOG/MyX7Br+g7SSYOEIKd4tU5SiZ50Z/OmGsjtfSOjzhwcaOXcycpSvivuY6GyY4ai9EB3OOYmPxYTW5T7L4CGZVa92G8+ogfW8VWyiAlq3nalpqlj7Lt9sgh0nwU5x4r3cxkrhz1nkDFGlhH3fd3MMVlNFwatJ6UOzRPbPs881oIWj1is3rAzeVDhClLjakv8MjUczQOhl2JTYUIrfEmT0HWdMXuPlrXsfEmcEgBv5GAQF0bkCYseuEDWirHa6U/5pg9tiKYzeOL+oTJ3cLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:91::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 5 Apr
 2023 10:53:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Wed, 5 Apr 2023
 10:53:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
Thread-Topic: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
Thread-Index: AQHZZ1neYlqkq4ONyEOC8NUatF9pta8cityA
Date:   Wed, 5 Apr 2023 10:52:59 +0000
Message-ID: <626179c54707297736158da89ee634705cd6d62f.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
         <20230405005911.423699-2-seanjc@google.com>
In-Reply-To: <20230405005911.423699-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5170:EE_
x-ms-office365-filtering-correlation-id: 26278099-5354-4a45-5589-08db35c3ec1c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lso6MsHpkyJVlL5iBZedeazGewUTkqzp2bEAMBR9VYcUOxAvBYrZ4BpZ6F4ZncgWWaNLH9iXe1nHeFF7M8Veg1VR2VNkGXxubYJKrL1o8p398aoUzriRh0LgsuqGYbzSNNKVhVRlbGAMsrg1pAcsTbET3YpnZjhZcq4ZfuE12midbmE/BwArn03v373u/zXEtXumrYzx4ek5XQ0BgBNZJtGx9Fx0JZUdDUYQRy1WIOGH1tofJXpKVAGlbI19f72YHfOKCJCSlGrdX6i2hbVgaj74cf1ezaZ1DtBwZ1dJY7yM4bjcFh3zT1pZ2Hv5MtWQkmyxdr4ujsnKrX8ZBUGLWU8nEFx93+nWLFAuGRKzL7mDuQMHoKTqlyLaxcT8hbIkjLFwUCjIZ665e5vq8QrF2i94lC8Y6xXa91AEtw1a19WI2UOJcZld2gRmirALEWTc4t1fGard+ogN3Ks7eMOEvqHPLJyP1Sm2LthpgVaAzu0yI08AyRMlsFItweAeRHiGYEQxVHBK58AjnL4HT0W4Zult87deu0v/FWNClpBH1nou1/beb8L6A7C5ut7hwjHicB0hC0RKo3/NRkbFoZzL1lCkLyJbckKFuGdZgtOgf//sSDDI+Ont4dEeG3mBLlXO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199021)(54906003)(8936002)(5660300002)(38100700002)(2616005)(36756003)(26005)(38070700005)(6512007)(6506007)(66446008)(66476007)(64756008)(8676002)(76116006)(91956017)(66946007)(4326008)(2906002)(186003)(86362001)(71200400001)(66556008)(6486002)(83380400001)(41300700001)(122000001)(110136005)(316002)(478600001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzF6TnAvNWpVNmduK3FjSXRxN1NmRzJIVW1XSmtMYXpoUGw3WVVlQWEreFM0?=
 =?utf-8?B?MFYyMVpHZWFhQ2R6MWZLUmVMWThsSVUxTUpjUDJJSHhsMlBNNWVZYVNXcmRC?=
 =?utf-8?B?MUdtYTlrY0QzUzlicTFtcHpId2k4eVkxNjFZV3ExamxWcnhxenRTY1hLb0sw?=
 =?utf-8?B?ay9jOEZKVkdCZjJrRnZQRWJIbTN6Y0xBME9sbzZaWmlTbUhOcTh3ZlJvTFhv?=
 =?utf-8?B?MUo5dGJTcUdsVFJrWmY5QXo5R2FQVEdYRkduUFVqZk9wTHd1djkzYThjbFNo?=
 =?utf-8?B?ZGxwZ0lLQkc1b3UxQ1M1UkhCSXJBSkpqejZHVUdTY1hncktOdXNkOTRDUFhr?=
 =?utf-8?B?dy9hTE0vYnNLOTJoUWsrRExyRGFhQStKTnV2NG1Ub2cxMzFOS3BRbVp5UDla?=
 =?utf-8?B?MWJvWCtYMnllOUJFRFZEYVNpMEtFL21IUVlLb3c3enlPaGtyaWhLb1VIOWdN?=
 =?utf-8?B?ZlVnTEJSeFBPeUhvQk9SR2ZGUmRhNDRleWtmdlFWemoraS84NDBhQ3JQY09Q?=
 =?utf-8?B?ZXR4akVvdkxYSlYyZ0VGYkNRQ0w0L29PMDhFcEJKbGVCMk5hdkhkcXhTdURW?=
 =?utf-8?B?MHc3KzdQWUtrdkRIcXlrUmlQeU5pZ2V3aFZzZldncUMwYnd1MnkvSGNEV3Nv?=
 =?utf-8?B?OVBUYVloWHEwQzQ3WlYvNVhYU0I3UEpTVjhLZlRTRVQzeUxNdU45SkEwdXpG?=
 =?utf-8?B?dmRldE5LSDZtMUxwa1Z3MyttcGphWVJEQnQwL2FUMUhvNzAwUkI1M2JHUmZG?=
 =?utf-8?B?aSsyaFlDTlF2bWdDSkVaSG1CbHhmNSsvakJvTnpLSzQ4RUNxUjdIQ2FkYjhs?=
 =?utf-8?B?V0hzZXcxbmt1cTg1WHJQNHlMK2IzYW5admx0RnE3TGlZclpydlpjWmpWcndG?=
 =?utf-8?B?eHUrK2x2YXhCMFJXL0k1REpWRm5nWC9BN1hTaGtSVGV6Y0lESWhlREhtb1VG?=
 =?utf-8?B?RDRCdGl0OUd0QVdSc3oyRWRZRzhNQWZ2dXJLUHB5TWVDclN0WXkxYmZLQ0hk?=
 =?utf-8?B?THhuMURYdXZsRjRDSUl3aU9TTzdGODg0MGxkbFlvZnV5UXZoajltNFhNZ3cz?=
 =?utf-8?B?M0pjQW1MZEtyb2xNVUpqZUNlZnFKSDl6cjZnZGJwTE4waW0xOThCR3lBaWxG?=
 =?utf-8?B?b2lYdEY2bE90aFQremVhYi8ydHZCaWxqQ011TFFSNDFCM1Z0ZEdWMGFhMTdN?=
 =?utf-8?B?WFRDenhrdnd5cmRKanFHVlYrTmlWWWpMVHVDbWVJWmZFVHBubnZ2YUdqNjBm?=
 =?utf-8?B?S1U2TU91eHd5SnpkOXpWWnVDNlc0bXNXbDY2TDRUaGVMM1M2SGJTejA0a3lK?=
 =?utf-8?B?ZjJ1ZFN6b0liR2diSXVkd1ptdFZLT0NYaWFqQmc4S3dGdFJuZGNGQTdyMlhj?=
 =?utf-8?B?T3duZmRWWkdKeFBpVDRkbFJGSytITGdqRXFiSC8ybjNMRk1GRDl6ZDVnaXZX?=
 =?utf-8?B?OWhWdTJGYXRpS0MzLzJnbmU1MlN1RTRGNVhLRmxINkJGcUJHZUxjNjl2SHY1?=
 =?utf-8?B?U0JiSjFnNWhwM3htdWxhamdMVTllMi85SjlZSG1lTk5pK3Zac0J5OTlsNERh?=
 =?utf-8?B?eGI2UUJzd0UrVFk0Vkx5NVdEUWYzMXdRRFZvZzh6ellwSnBsdlkrVi93VENM?=
 =?utf-8?B?eEtEZXJ6TU5iSHR6SzlqVXZxWTBiYkxTL25LS3QvQTJNSk9MeXpwUWk0ZlpX?=
 =?utf-8?B?ejlkaEk0cWZmaUJ0LzZJcEx5a2UxbGxqRk84WHBPZ0dGYzY3MjhYV1Rmenhi?=
 =?utf-8?B?ZmZER3JVQkZQNHJnbVJRTzUreDErckR1QjdlSHMrZ3hIKzFmcFdYWlVNblZp?=
 =?utf-8?B?Q3h0MkVlVDRYeDNySitkRHl4QlRPZFRKeHZSWmZBdzJFWUVUY1d4U0RyWUF4?=
 =?utf-8?B?OHNNaWMwU1I1RjJZNGpweVhLSDZ0K0J0SEJBNzQ0cHRDSGYydDFEeTdYZEF6?=
 =?utf-8?B?NmxhNEdCeUR2RmVoTFpPTUdVYUF2UTlkOVBLemJkNVl0T2F1V2cwM1Z5L2k5?=
 =?utf-8?B?L2dTd3YyUGRGYnBHSFhjOGFXTzVhSURoTVdXa2p4ODYzVytqRXAyM3JiMUh4?=
 =?utf-8?B?ZkF4Mkp3UlluY3FWVjI0ZFRxVDNtZGg0dHhENmdNdU4xUkZXajE4a0o1Z3hP?=
 =?utf-8?Q?LhzxOtlJNnir2cSxxtoQG08T3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A8471DEA3E80E42BCCD193F5D6B26D6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26278099-5354-4a45-5589-08db35c3ec1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 10:52:59.9052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0AT3bi+o5X3bVC2OXpGu0fd20Xp3aTObq9eOQNHRMuFULJJT29Mci4GXOAEysJh5kDpWe7MwZ6GVnJLKLuMJjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5170
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTA0IGF0IDE3OjU5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBFeHBsaWNpdGx5IGNoZWNrIHRoZSB2Q1BVJ3Mgc3VwcG9ydGVkIFhDUjAgd2hlbiBk
ZXRlcm1pbmluZyB3aGV0aGVyIG9yIG5vdA0KPiB0aGUgWEZSTSBmb3IgRUNSRUFURSBpcyB2YWxp
ZC4gIENoZWNraW5nIENQVUlEIHdvcmtzIGJlY2F1c2UgS1ZNIHVwZGF0ZXMNCj4gZ3Vlc3QgQ1BV
SUQuMHgxMi4xIHRvIHJlc3RyaWN0IHRoZSBsZWFmIHRvIGEgc3Vic2V0IG9mIHRoZSBndWVzdCdz
IGFsbG93ZWQNCj4gWENSMCwgYnV0IHRoYXQgaXMgcmF0aGVyIHN1YnRsZSBhbmQgS1ZNIHNob3Vs
ZCBub3QgbW9kaWZ5IGd1ZXN0IENQVUlEDQo+IGV4Y2VwdCBmb3IgbW9kZWxpbmcgdHJ1ZSBydW50
aW1lIGJlaGF2aW9yIChhbGxvd2VkIFhGUk0gaXMgbW9zdCBkZWZpbml0ZWx5DQo+IG5vdCAicnVu
dGltZSIgYmVoYXZpb3IpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNv
biA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC9zZ3guYyB8
IDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC9zZ3guYyBiL2FyY2gveDg2L2t2
bS92bXgvc2d4LmMNCj4gaW5kZXggYWE1M2M5ODAzNGJmLi4zNjJhMzFiMTliMGUgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvc2d4LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC9z
Z3guYw0KPiBAQCAtMTc1LDcgKzE3NSw4IEBAIHN0YXRpYyBpbnQgX19oYW5kbGVfZW5jbHNfZWNy
ZWF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ICAJICAgICh1MzIpYXR0cmlidXRlcyAmIH5z
Z3hfMTJfMS0+ZWF4IHx8DQo+ICAJICAgICh1MzIpKGF0dHJpYnV0ZXMgPj4gMzIpICYgfnNneF8x
Ml8xLT5lYnggfHwNCj4gIAkgICAgKHUzMil4ZnJtICYgfnNneF8xMl8xLT5lY3ggfHwNCj4gLQkg
ICAgKHUzMikoeGZybSA+PiAzMikgJiB+c2d4XzEyXzEtPmVkeCkgew0KPiArCSAgICAodTMyKSh4
ZnJtID4+IDMyKSAmIH5zZ3hfMTJfMS0+ZWR4IHx8DQo+ICsJICAgIHhmcm0gJiB+dmNwdS0+YXJj
aC5ndWVzdF9zdXBwb3J0ZWRfeGNyMCkgew0KDQpQZXJoYXBzIHRoaXMgY2hhbmdlIGlzIG5lZWRl
ZCBldmVuIHdpdGhvdXQgcGF0Y2ggMj8NCg0KVGhpcyBpcyBiZWNhdXNlIHdoZW4gQ1BVSUQgMHhE
IGRvZXNuJ3QgZXhpc3QsIGd1ZXN0X3N1cHBvcnRlZF94Y3IwIGlzIDAuICBCdXQNCndoZW4gQ1BV
SUQgMHhEIGRvZXNuJ3QgZXhpc3QsIElJVUMgY3VycmVudGx5IEtWTSBkb2Vzbid0IGNsZWFyIFNH
WCBpbiBDUFVJRCwgYW5kDQpzZ3hfMTJfMS0+ZWN4IGlzIGFsd2F5cyBzZXQgdG8gMHgzLiDCoA0K
DQpfX2hhbmRsZV9lbmNsc19lcmVhdGUoKSBkb2Vzbid0IGNoZWNrIENQVUlEIDB4RCBlaXRoZXIs
IHNvIHcvbyBhYm92ZSBleHBsaWNpdA0KY2hlY2sgeGZybSBhZ2FpbnN0IGd1ZXN0X3N1cHBvcnRl
ZF94Y3IwLCBpdCBzZWVtcyBndWVzdCBjYW4gc3VjY2Vzc2Z1bGx5IHJ1bg0KRUNSRUFURSB3aGVu
IGl0IGRvZXNuJ3QgaGF2ZSBDUFVJRCAweEQ/DQoNCg0KPiAgCQlrdm1faW5qZWN0X2dwKHZjcHUs
IDApOw0KPiAgCQlyZXR1cm4gMTsNCj4gIAl9DQo+IC0tIA0KPiAyLjQwLjAuMzQ4LmdmOTM4YjA5
MzY2LWdvb2cNCj4gDQoNCg==
