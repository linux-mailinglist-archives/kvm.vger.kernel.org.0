Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614756C7322
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjCWWcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCWWcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:32:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B74C27D68
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679610772; x=1711146772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=McjUTUl4liKnUMzi844t20f+LA7GEmsDmsDgrQ8eRtI=;
  b=GU5X5yzIsRQWhYX2qwvOqhto2rKNEiI5keDIlsEqVliJWr4/sBNJDWkx
   vVtQM8/ON30d7eun7vyGgE2Kbpc/ImKgyQe7xfKrlTsOOOhoujQl4RP5v
   z0A/RRdjurVEGG3LYJGfnP/CN86DZudmQ2vA0naLsNzEHQ+66ZijTJ9tF
   KdyYlaESLFeiCXNcDhlt15uVMnIrJI1FFLHdPpw0VIyYljsFTUkMMprDG
   JitcrqhNjRItr30IHS7bQ1J4QY8sllg5LYwvS3SkTuV5cV4DsXOf5njUN
   +7VpNSepM9be90SS9M3qfI94p4563qJ6wpB8Xjid4GJU+M65t+WokEVm0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="323505467"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="323505467"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 15:32:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="751664188"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="751664188"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 23 Mar 2023 15:32:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 15:32:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 15:32:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 15:32:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 15:32:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QL6+IT0w66kGY8WHtI+Sgh1QFq27woujx7+EWHpriFyv0u8FmKlZcTQ3hvY/pmWIoXc77t2M+eXC+OZFYyaJMipCwwp5RT9ow2SX8gMWSoP9pApO1F7cSdsF8d+gDZN8+CGpnqxNosvSihlZkaKp59yaoVil80cCx7kD6oRqCTrwxFV13gig+V90cWePcsjfyUZ1ZCW8dr3hN4/dcfq/CT432sadmqAmUlFBux8+XuOplWRXOUHjuGyW9pzuGy2bmzATdoVI63sl5Px30zgzi9NZ03LX1EjwM0kfY0Wv29ZF3sfWOLYFhHN1O4dwYJEAO0gThG+p0oJwkOdTFJ+Raw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McjUTUl4liKnUMzi844t20f+LA7GEmsDmsDgrQ8eRtI=;
 b=Kw+dkF0nAuyRpll2cA6GiWnhAfH6Kbkm8B7dWIn+t0ZtEEHQil/2pCwgQQsKu7yiDmFsvH+cbvKWLMTWv1VDiHzu8eaRgGQ+/v3/iKr+yJQslk/YW2xcuwn5c6Xru6S7vSaNwfkp4buO5+2BehmNu4BXNVTF2h/y21zfcFr38zExZJ06OouujRWWVMDnexYlGn9NsvFz/06VMudswg8Dliv+XcKdhjhzhM32emJp3l6Me/4a1dKpZPczPDgIkjgyHF/FHbMsEpXTigOPGtqxM1S1MsuiyzOOcK6d2ePdpK37czNwA6xo7gxamny2/6VIAp5tpUZWSiZJH4MM0RwM9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4841.namprd11.prod.outlook.com (2603:10b6:806:113::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 22:32:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 22:32:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "Li, Rongqing" <lirongqing@baidu.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not
 itlb_multihit
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if
 not itlb_multihit
Thread-Index: AQHZXVe7DWMC2Kv4vESzd+zUkOLJcq8IaoSAgACJhgA=
Date:   Thu, 23 Mar 2023 22:32:36 +0000
Message-ID: <48616deee4861976f7960f60caf59cbe37a85f1e.camel@intel.com>
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
         <ZBxf+ewCimtHY2XO@google.com>
In-Reply-To: <ZBxf+ewCimtHY2XO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4841:EE_
x-ms-office365-filtering-correlation-id: 65fb780b-5563-433e-1418-08db2bee80eb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 919Zup3S4LyWVq2LMAshQTtUdxcqnAvaaaIs8d6B6VmiKlztMNMuzWsjKd5qi0neu+hPVwI3fAQ6BTY3YHu44HSNUr++zdgsDNtSd3QwYJvewHTTOsB1CDyph73u4N06MP0Ay1fUgIA+dNOSSRZG+e5iwgZE1WpJ8S7N3sCQ3Wc6WuyCOmvgoWnsCmcHgvnGEI4q7ErzHtNQ5xvKenbEdyJPb0BxgxJEKOlzs4Bo0upLWZ4YJOVaDxnKBqiigyFVeKd2on9FEuydhVwlKeP9BN2PWXbTsQrh8n8KJ6MR7ztB+L3jtOH0DXP0vdHDlodIuG+RmOg2hWAYz5PRJO3PW2Ug2zoc4cwbBodcghClnut+8U1NprmY/iGGbuXrTwh3trUbkS0eVMddrHQ+qtmYrtQBqHHhMdTGxhvpMZtNe1j8Nos6PdHbVSBwpSKFiSFogqF0hjY9bMcpqUIliSLKs+PyiMYiYOz/vEo5if7FkdTs05aeDF2my1xCpf2DZ+kyn/yLSp3/cACVTdixI/J+dLHEMikK737HnSjtgd/oNMyZhE7JJDneIjK2956PGDAqSiZywM3oybkdZZigOK1kKLu5pXwcfTGK3fnzXD3kK4aE7joGwjbVub0CdIy9HX7ue1+ryYfg00Ed1/L87Hg9hWIgrZpoo78Aa2Vjsj/6dXi9pPlCzArPw/CJt8tWZhzhcNiehJLNK4jG/rAlL64+jQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199018)(6506007)(38100700002)(6512007)(122000001)(82960400001)(36756003)(2616005)(186003)(26005)(5660300002)(8936002)(38070700005)(71200400001)(4744005)(54906003)(86362001)(478600001)(41300700001)(110136005)(316002)(6486002)(2906002)(66476007)(66446008)(64756008)(66556008)(8676002)(4326008)(66946007)(91956017)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkowL3RpNlBCM3dwZndwV3lETFdIVldKVzczNlh5TlZxZ1dwR2ZqdkFGL2ZI?=
 =?utf-8?B?MjlUL1hLTWNxRFRRRllIWXlMeWhhcFpJb2dQV2Z3bzl5N3Q0dnc2a3V2YzBW?=
 =?utf-8?B?WGwxMnBJTkdtVUxCeXZtUjUvbHUwdG1LTWFXTHBCQ2IyMERVbzlGYUUxOVVu?=
 =?utf-8?B?NHdZQ2hpNDZDUnl6VGpTeC9lb2Myd0lCQklaRVBpYlVOS0M5YStxbUpDaVRB?=
 =?utf-8?B?Mkh5TjVYTllDOXRCbHB0UkJzUjl5MWtSZVBIaW0yRVZZenJTTk5LbXdnZldi?=
 =?utf-8?B?aFRGUGpxbElnVFJuQWhiQmlYUTRudGVuYStTdFd2c2dCRkl1WFdIdEMzMmRq?=
 =?utf-8?B?WHdWalZLeHpsbXRkYTJtcE9IclFKeGdJR0xYNjZaS0FJT05QU0hObTJ5cjZq?=
 =?utf-8?B?RkxWaDcyTTM5dEJWWXJnQW9PK2JONDJoRU1kSm5aZ0xleWxJNllDSEFITTJl?=
 =?utf-8?B?MndzbTYwN2pFaVkrN2pKbUxHVVJ4Rm5VRzIyMUhHRkdLV0JrYklwUy9BZzNU?=
 =?utf-8?B?VzFlZjl6OUJWOVE2RGpqcHRTcE5BMnBNclZpRTBYRGRRejl0bkg4UFBONmZO?=
 =?utf-8?B?djZ4R0JYcGZrWnREakkvdnFZejFPZ2gzaWQwdlhZUW1xeXAzSVJvc0JveTBh?=
 =?utf-8?B?bHBrYUd6aDdlM00xVUtvUlA4STdrZmlUdGc1elFyM0xMR2NHcEJwNVdqZzlZ?=
 =?utf-8?B?NE9iaytaNlA4UVBGdXY3VlQzQW01ek16TkVVNnoyMW5ZRyszSFliR3krYktv?=
 =?utf-8?B?YzVHeVV0QnNMQWZMUTdJR3ZsSmxNREMwcmNZdVV0R0xZWlRxK2IxTUNxTUsv?=
 =?utf-8?B?N3dTQ3Mrbk1SWnhrTmpoV1pYVmtjNWN2U0xKck1rRlNsejFTelN2VW5QaGlk?=
 =?utf-8?B?RU9iWDlSR21oNFRrZmJJR3kvOUZYWXNocGtVU0FpR1NWclpNWGVvbEg1R3Uv?=
 =?utf-8?B?dmRjUi9vZTEvb1VXVXE0OFBGZ0xSNEZpM0lEalg3d2dGT0Q2K3c3aStFcnBj?=
 =?utf-8?B?NUtjTXREMm01aFQ4WmNXd3BlNVQ4RWVtTisxVFRHckpDc1RINldCUCsvbTdR?=
 =?utf-8?B?aXArcWpJZEdjOWk2R0sxOG0vZW0ydjdWZUdkSW5zNzhVa3UrdVZOOEx1TmJ3?=
 =?utf-8?B?UmpzNU84bUI2VmI1U3ZGdlRMUmREVHo0elZLZys5cDVzTHNHYzdqbWpyOGN1?=
 =?utf-8?B?SlB5THo1dElLVlU4bllIVjc3UzhVMzFKODBEU0h4RnpWSHAvUk9DZi9GSUNR?=
 =?utf-8?B?SDZ0TmVZVDdxZ3p0cU83cWpXOVRvZHBDNUU2eExQL01aV2huN2cyNkh0SHVu?=
 =?utf-8?B?TGlFWVBKR29TVVA3RnorUlRJK1R0UmF3MllUT1RzVFhmaktkQmZKK0RTUlVS?=
 =?utf-8?B?dmx4QUo4RHpSYXdvejlNNDZnUmxKSnR1S3J0ZW5PdnFBSnYvYmJPcG1kUnJJ?=
 =?utf-8?B?eXBxdW9LOHhyU2Jxc2dTcFRLV0s5ekhFWUR1V2QvTGhLTUt0T2dKMTltT1pH?=
 =?utf-8?B?aUtJQ3VJN0ZxdU1HcW0zQ0dDWXZ5OFZXK2oxSlI2c1lYTTVCSUg0QmVHNmU2?=
 =?utf-8?B?MHU3UzZ3NUJCaVUzc3E1bktVTFFtTS92V3hubE9oOHRTRXhJYjYzc0xhMS81?=
 =?utf-8?B?TjBVNlpWcEhNNXpNS1N2a1RWVXF3MStUQUFSZ3FHeVpWY1VEOEJyRWtiM0VI?=
 =?utf-8?B?VG1Ucis3b1puL0k4SkRTRlRGYldhVWxZaDczRFJZbWFMY281REFKUGdnVmxo?=
 =?utf-8?B?eDdaVk92S3M1YXU0eFdLTE9JMEhKRzRMQmN0RTl2VkVRNTF0YzAxb1paWGw0?=
 =?utf-8?B?UW1VOUFFeVYra2NiUlZHSTd5UGJ6bjZWcEdNeGhrL0RUZW04SEMrN1dWNVBP?=
 =?utf-8?B?VDJlZEFGamZpVHlNbzQwOTZkTm56YUg4dE9hQklHRG9XNHJWTExMOHhzRnBa?=
 =?utf-8?B?dTB3b3Ztbytwb2RQdWJTQUoxSEQ0SWcyZnFKTzhQcEZLc3Bnb1dmMXN5NU9H?=
 =?utf-8?B?MVpsRm1ZUG1GQUFndG9pQ2FIK3B2QXBHaHdVOXd5ZzZqNDcwYkhjYmNiQ243?=
 =?utf-8?B?d3ltaGN1N3hhNjBmb0JxeDFCOEkzWW5kMERwc01KVytoVlk5VjJNa1VzdTF4?=
 =?utf-8?B?ZU13TmVOLzIzSjBMV0ZtOVQ3RWxrNkF0MEdPcVN6blJFalBjRGgwRXQ5a29W?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA7DEB8856D3C840933FCB1E377FDCAD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65fb780b-5563-433e-1418-08db2bee80eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 22:32:36.7845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LpnPS4U0NhXq2bfZiycKN7sfr4SsVCMPase9C8xrJYnmxmoChHESwb9Gw29ph/RYxHZGIQJOO3S22oT/MZqnTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4841
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTIzIGF0IDA3OjIwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1hciAyMywgMjAyMywgbGlyb25ncWluZ0BiYWlkdS5jb20gd3JvdGU6
DQo+ID4gRnJvbTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+IA0KPiA+
IGlmIENQVSBoYXMgbm90IFg4Nl9CVUdfSVRMQl9NVUxUSUhJVCBidWcsIGt2bS1ueC1scGFnZS1y
ZSBrdGhyZWFkDQo+ID4gaXMgbm90IG5lZWRlZCB0byBjcmVhdGUNCj4gDQo+IFVubGVzcyB1c2Vy
c3BhY2UgZm9yY2VzIHRoZSBtaXRpZ2F0aW9uIHRvIGJlIGVuYWJsZWQsIHdoaWNoIGNhbiBiZSBk
b25lIHdoaWxlIEtWTQ0KPiBpcyBydW5uaW5nLiDCoA0KPiANCg0KV29uZGVyaW5nIHdoeSBkb2Vz
IHVzZXJzcGFjZSB3YW50IHRvIGZvcmNlIHRoZSBtaXRpZ2F0aW9uIHRvIGJlIGVuYWJsZWQgaWYg
Q1BVDQpkb2Vzbid0IGhhdmUgc3VjaCBidWc/DQoNCg==
