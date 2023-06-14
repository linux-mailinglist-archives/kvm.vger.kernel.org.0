Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624D1730AED
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 00:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbjFNWpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 18:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbjFNWpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 18:45:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B160E1BF7;
        Wed, 14 Jun 2023 15:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686782727; x=1718318727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qfHgQWDwuNLlYciSNX3E+MEFbR68QCDXXJYkGpMua4o=;
  b=kGr0wD1ma2X0DfVvBQ4qOHM7ezDidgCJycTvL7XbQtBmGFfhhYkWzsov
   /i6yr+Q2IwRmKilIgx2ZWEUK6L/sUddg5f7UAnhVMKWxmtmqEh3X+9OeR
   tJ/aNA+f8n8W5rHTRY0atJL8Efbs5adWMJXs5WoeMT/8eIy6GLm50LAu2
   dJ7wy3WY7BWWAn9L4dDqSDOEWeJtZ/Gb8JnsVDuzF8gOnl7grvFYq6xWQ
   ZWEYi2/HOEB7jGThgR46JAc32US5EKu+hqMWdxyKmBDaYkIJtZtTmzDl8
   sG9pJ2Hnn+8x/QIJOm9k0LYzLvMOu8lVQrrB5ERx0h6CNy1+YVgXIKcn1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="424641027"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="424641027"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 15:45:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="662563109"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="662563109"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 14 Jun 2023 15:45:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 15:45:26 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 15:45:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 15:45:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 15:45:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKJEQ/mp+COy2KOw/MPvRQAWgVbmHiX8HYavfCKL/NfbaduSIJw9NelzJtzZSWDLhQoIQ887xGkqe798tzNWZ0su9bXGFHuUwOFokZWkxdajwafsKaJkH4l0FpYVpYeCM5/DxBP/Ru/G9OKhZKkoF+zlG3AX/jbEdlSPiQGz3exOVGYn5qHzLI58HC6Cw3+hpB6K+Z+KuEd3nUbWzyEBW+4osCs5gIjrhydXVCtiuuRxuhwHnh83ElFWNaF6FOzE0IvaFDzRXI0XmpOl6rwqaX2MRlex2nFiVkHm2+TWO6EI6jvBG7VudtCdNCRuovQmxgObZ+wwjwQvYMxvRzBVGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfHgQWDwuNLlYciSNX3E+MEFbR68QCDXXJYkGpMua4o=;
 b=Eud8DaECBBhqXARp5F8Fmd9jGYkXV04ZwAQZVPncAExw0Dt0EfirEO41qjNtVVYV6mcEey1NyDAK/j9lKVXQKqMFg9a0j66VdtM0fhPG/JmmPpdh2UUuMPe5cUtpyuqLDOHMdgBPEU4tYR1UVGi7HTJDeC0BqnLy2YgoRbml+qF2B4fyL7h2RImkomDTW0lcO3hLDCvMD8hnOsKzrHmT4fI2TJ7lEiMW+DLWsUeRONusY4aMejQCJv4wvrylByUGsqWonrLuchBWWSfol7lqx2GFK1BmVoQQu+xoLLCSd0889WtpTQgielnVQPi3DbK0B2Xnij3YYVpI8i6Sx3oZWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5494.namprd11.prod.outlook.com (2603:10b6:208:31d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 22:45:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 22:45:22 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Index: AQHZlu+2r84uqtF1H0SFKn93tuC1FK+KSnIAgACreIA=
Date:   Wed, 14 Jun 2023 22:45:22 +0000
Message-ID: <87a52584b67a6f68b7c9beade5da533bf722f719.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
         <cff2c398-6d2b-8202-6d8f-88b6518bb49b@suse.com>
In-Reply-To: <cff2c398-6d2b-8202-6d8f-88b6518bb49b@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5494:EE_
x-ms-office365-filtering-correlation-id: edc2ea89-d644-427f-e007-08db6d2909b4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bNTuMLnSzKjI2GfqjqNvAEsttAcf8HVAqFoGyKuXR2RU5tIdx6dZjvvwz9Ovvd+Fwt24QneevvkXpyEqh0FRhRdIxbt22anGfyURn3mvCbMuzacj8+mr79O5VMvK584L+k1jGZIR4Ue/dohA12gQowyaUQ7gOzbeVcufcWiS2YX+hqXupSZoLDvSgEHwPRTw7+IVWFP1Yt6rh+eqmNHcGFxlxW0N7zPQwCmPwso53ZaCZEODYlbr/G+vKPxY9tTbX6tGr9xsdkYrARVzKBswRJGkOzKQ7nbq66TSfmZvAzjbD3Wtt0RXc9n5w5DpsRuNG94t7Qz3ji/VscyjN9vpHrhfmOkt8Jvkcl66CvX045O2emiYmG6KYCyhAEpOKCwOM6tb3ypntOxpfCcXnuj4z+94lZCyOsodBPUVSiejTLIlC1oDumC1exYZqASATJix7crzr8HsStOpHGYUotSiJTI2XdR/Soq6suBKIjEA8EpgUfag9kQ71vWUzZO7WPATlg2KY6cqifPC82kNlNhhyBggRom0C/pNYRqs/344A0IRiCGl3y26zMrfZgBp3+9zRu5X3hHvUAIXXAyCa1IKTF0d8UByP/AVSFYj4QbYtyjAMe5YIXHFQv7+y4OWGhpJIgX7UsDOtZylOVidfGeZ3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199021)(83380400001)(5660300002)(186003)(6506007)(2906002)(2616005)(7416002)(966005)(6512007)(41300700001)(8936002)(26005)(8676002)(6486002)(316002)(122000001)(110136005)(54906003)(38070700005)(82960400001)(36756003)(478600001)(38100700002)(4326008)(76116006)(66556008)(66476007)(86362001)(66946007)(66446008)(64756008)(91956017)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTdNTDVzdHgrNXZnZUZPajZsc283K3cyayt6MmhkMURKL3R0MnExQjE2L0Rs?=
 =?utf-8?B?aXFxTVA1bHZsQTNZanFGZzZGbklKTUJSMjdtK1ZCZ1h4MTZLclVld2phODYy?=
 =?utf-8?B?M2ZPUXk5Y3U5clpXRTkzN0g2TFdUTHV2aFRGdWU1ZVdLUXBaWlZUd1VuWU42?=
 =?utf-8?B?MEc5N0ZLb2E0ZWx4RnVBeXNDdVl6SkpJYjRnMmtvY1h3Y0Nqd2hKRWMxYTRX?=
 =?utf-8?B?QXIrdDFCck52bFBLNFRVU1hpWngrM0hYU2tISnlUaHFZQzJWTjJtQXlXaGxq?=
 =?utf-8?B?NUxTaytrQjF1QnR2TkQ0b2lSK05ZNmZHRnRONlBEa1VLa0FkckxpZWVWd0tV?=
 =?utf-8?B?MFgvZVd1UmpyMWpUdkg5SzhUUDFYbld1MTBYRVlxZ2JYR1dLYmM4RHVYUi9v?=
 =?utf-8?B?b1FqSjlkQlRMUVFhVkdrUVRpcWMrUk9vYWhwZ0FqelNLYUk4TXhyNXZ0QWpt?=
 =?utf-8?B?ZitSWHlVeWcxM3ZTSGJITWR0cXprdEZyODY3S1YzVFZWU0lkY1Jhc05zMWJn?=
 =?utf-8?B?eGJodnFaR3NkOTM5VU1nMUliN0xEMGR4RDl4bjg2eTZEQUphUFFkN0YycEhu?=
 =?utf-8?B?TGJiR1dJU0o4aVlrWjJ4WlFLWHcvS3VVWXowWG9FVWpFYndDeitGcEFxQXJZ?=
 =?utf-8?B?YVlxSGZaWWNjb05lcTljU3R3bFhFR3ZjRFk3dzhkMlF2Zm1tYVlaSTlFT2Fp?=
 =?utf-8?B?empodURqMlRlTEJ5NUpUYVRsbTIrUEVLd3g0b3JOeENkUEV6RTI4dFJoWFA0?=
 =?utf-8?B?bjdEcGhPUWJUM29QVUNUb3l1Z0RXWHZENFR4b096dHphTkxEN1lwVDV4Rml2?=
 =?utf-8?B?aGhxY3hveHpZTEJLcGNXMXczM1BtMDc3WnZmN2VibDUxVjFyOEMreGRxNWty?=
 =?utf-8?B?OTNmVGJXckJsemMxd2tKVU9OY0ZQMEI1d3B0VlZIcWgwd0VNNlhldHJHVE9l?=
 =?utf-8?B?MkRTSEc2MG5tNG5pTXVYOTJHK0RIcmY2ZjNVMDJhNURZL1VhY1V0Rk1KdDUr?=
 =?utf-8?B?RUVndWdQbzZwT1QvbHM0NDk0THErSnQ4VG04WEMyMkd0MlJxbjhtc2J3bWcz?=
 =?utf-8?B?Y3RNNFhZbEVmYndab2IyZVFEYVdsck1Eb2tpYVhLVVlleExFMGZZUml2eEZF?=
 =?utf-8?B?aVBjU1FYd2FaQ2tiU0w0cWlBcXJ3c0p4MGE0d2IxYXpMbzFOTG0rWDU0SFpU?=
 =?utf-8?B?K3BnTCtSb3FqdzVWb1JrZmdGc2FpU2dRWnJrS2JiVkpySHBHZHNoNFNsVnlo?=
 =?utf-8?B?NFAyUFdKQkY4QUtVakJYczlHRTNSWmw0ZzFJNjRhdCtKcGNNWGxvMnk5d2sz?=
 =?utf-8?B?cExWNDZkckoySElCN0V6OHpDeDBnTmZSQkt4aHlNVFZaMWphYk0veFlFaHZJ?=
 =?utf-8?B?RDJJcnk0MHVzU0M0Ymh1OGw2SWNBMHI5c2tCNzZzSjdXZTdhMHVteWRVQ292?=
 =?utf-8?B?UnhlNFJGUkNHSWtwY3RQdXJTMGJlZDBQUXhSWEZGd1BpanJKenVlZkx6STJy?=
 =?utf-8?B?Rjh3WEpjd2VvZXhjNktlUjNsRFVzaXVrQ0NnWi9SNUl4RWZENWQzMFBHVS9U?=
 =?utf-8?B?L3psTys2S2duQTNISGtvSkNETUJOLzBOVmxid2xBS2pFVjdLL3FGUERXYVJS?=
 =?utf-8?B?eGttY01FLzlmMk03c3FpTUhER1AvSnpxL2tFZWFvK2FFY1UyckI1QllmaFZq?=
 =?utf-8?B?TXhqSU1FeER2V0tuUVpidGN3cGgwVUdKcE82RC9IT2NDT1Z4VjVDd0FWY01K?=
 =?utf-8?B?NFN0YVNFdVBOdXdpeVB2TGtLbFZWRmNPdmJlMC9YUitpQVlqZGppS1dOUXZH?=
 =?utf-8?B?NEsxMFlGcVJaYnRPdDU2bk1lVWpFUXJsd0N1ZmJEbFhEbVZTQWhnNDR4Uzhv?=
 =?utf-8?B?U0ZGQmoydmdUdGNNRENGOVBjQ0h1dVNMZ2ZoYTFjNEU2ZzNxOG5Vek9jMmVC?=
 =?utf-8?B?dVhvVnVtZzhad0NVZFdmcXY3VWNydW1ERWQxR2xkazBldWZicHNra1QvLzN1?=
 =?utf-8?B?aW8wUHRYSnVzbEkzWkVLWXV5TlpSYm12andOcnJLQ3JweWJwQVRlYStKQWRx?=
 =?utf-8?B?RThtK1VNemo5WWhXSzJyL0FCSEhuclAzTWlZMmQ5VnRsWDlqbDFFSHdHeTN3?=
 =?utf-8?B?Mnc2dEpqd2ZpZ2xqdHM4SFZVVTlkOU5WeTZNUlN0a2FHMnhScEZsNjlVNFBq?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AC1068D20F06A4AA4605532D084CCA1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc2ea89-d644-427f-e007-08db6d2909b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 22:45:22.6477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jryAAme+eBzOjZTvDrg/khe1G/b89+FteIya0pxtoJlUSmZzYKudOGUnTkYgx7/zt460pVJdca6SevBwl0wSWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5494
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTE0IGF0IDE1OjMxICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiA0LjA2LjIzINCzLiAxNzoyNyDRhy4sIEthaSBIdWFuZyB3cm90ZToNCj4gPHNu
aXA+DQo+IA0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIHwgOTQg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICAgMSBmaWxlIGNoYW5n
ZWQsIDkzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3Rk
eC5jDQo+ID4gaW5kZXggN2EyMGM3MjM2MWU3Li5mYTlmYThiYzU4MWEgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeC5jDQo+ID4gQEAgLTM4NSw2ICszODUsOTMgQEAgc3RhdGljIHZvaWQgZnJlZV90
ZG1yX2xpc3Qoc3RydWN0IHRkbXJfaW5mb19saXN0ICp0ZG1yX2xpc3QpDQo+ID4gICAJCQl0ZG1y
X2xpc3QtPm1heF90ZG1ycyAqIHRkbXJfbGlzdC0+dGRtcl9zeik7DQo+ID4gICB9DQo+ID4gICAN
Cj4gPiArLyogR2V0IHRoZSBURE1SIGZyb20gdGhlIGxpc3QgYXQgdGhlIGdpdmVuIGluZGV4LiAq
Lw0KPiA+ICtzdGF0aWMgc3RydWN0IHRkbXJfaW5mbyAqdGRtcl9lbnRyeShzdHJ1Y3QgdGRtcl9p
bmZvX2xpc3QgKnRkbXJfbGlzdCwNCj4gPiArCQkJCSAgICBpbnQgaWR4KQ0KPiA+ICt7DQo+ID4g
KwlpbnQgdGRtcl9pbmZvX29mZnNldCA9IHRkbXJfbGlzdC0+dGRtcl9zeiAqIGlkeDsNCj4gPiAr
DQo+ID4gKwlyZXR1cm4gKHZvaWQgKil0ZG1yX2xpc3QtPnRkbXJzICsgdGRtcl9pbmZvX29mZnNl
dDsNCj4gDQo+IG5pdDogSSB3b3VsZCBqdXN0IGxpa2UgdG8gcG9pbnQgdGhhdCBzaXplb2Yodm9p
ZCAqKSBiZWluZyB0cmVhdGVkIGFzIDEgDQo+IGlzIGEgZ2NjLXNwZWNpZmljIGNvbXBpbGVyIGV4
dGVuc2lvbjogDQo+IGh0dHBzOi8vZ2NjLmdudS5vcmcvb25saW5lZG9jcy9nY2MtNC40LjIvZ2Nj
L1BvaW50ZXItQXJpdGguaHRtbCNQb2ludGVyLUFyaXRoDQo+IA0KPiBJIGRvbid0IGtub3cgaWYg
Y2xhbmcgdHJlYXRzIGl0IHRoZSBzYW1lIHdheSwganVzdCBmb3IgdGhlIHNha2Ugb2YgDQo+IHNp
bXBsaWNpdHkgeW91IG1pZ2h0IHdhbm5hIGNoYW5nZSB0aGlzICh2b2lkICopIHRvIChjaGFyICop
Lg0KDQpUaGVuIHdlIHdpbGwgbmVlZCBhZGRpdGlvbmFsIGNhc3QgZnJvbSAnY2hhciAqJyB0byAn
c3RydWN0IHRkbXJfaW5mbyAqJyBJDQpzdXBwb3NlPyAgTm90IHN1cmUgd2hldGhlciBpdCBpcyB3
b3J0aCB0aGUgYWRkaXRpb25hbCBjYXN0Lg0KDQpBbmQgSSBmb3VuZCBzdWNoICd2b2lkIConIGFy
aXRobWV0aWMgb3BlcmF0aW9uIGlzIGFscmVhZHkgdXNlZCBpbiBvdGhlciBrZXJuZWwNCmNvZGUg
dG9vLCBlLmcuLCBiZWxvdyBjb2RlIGluIG5ldHdvcmtpbmcgY29kZToNCg0KCS4vbmV0L3Jkcy90
Y3Bfc2VuZC5jOjEwNTogICAgICh2b2lkICopJnJtLT5tX2luYy5pX2hkciArIGhkcl9vZmYsDQoN
CmFuZCBJIGJlbGlldmUgdGhlcmUgYXJlIG90aGVyIGV4YW1wbGVzIHRvbyAodGhhdCBJIGRpZG4n
dCBzcGVuZCBhIGxvdCBvZiB0aW1lIHRvDQpncmVwKS4NCg0KQW5kIGl0IHNlZW1zIExpbnVzIGFs
c28gdGhpbmtzICJ1c2luZyBhcml0aG1ldGljIG9uICd2b2lkIConIGlzIGdlbmVyYWxseQ0Kc3Vw
ZXJpb3IiOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL0NBSGstPXdoRktZTXJGNmV1
VnZ6aVcrZHJ3Ny15aTFwWWRmPXVjY256SjhrMDlEb1RYQUBtYWlsLmdtYWlsLmNvbS90LyNtOTgz
ODI3NzA4OTAzYzhjNWJkZGYxOTMzNDNkMzkyYzllZDVhZjFhMA0KDQpTbyBJIHdvdWxkbid0IHdv
cnJ5IGFib3V0IHRoZSBDbGFuZyB0aGluZy4NCg==
