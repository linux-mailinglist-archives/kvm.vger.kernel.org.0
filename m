Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316CE732517
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 04:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbjFPCQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 22:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjFPCQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 22:16:03 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583462965
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 19:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686881762; x=1718417762;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t5C6aEGeN9lOtLbd2tuEo93diOrscwbZOOxBEWRJ7ZI=;
  b=OED5Hnw5u5gfXjwZyu8kryJwam9U+TV5e23/r6QYai6UHGSKuMe8dVvU
   Vwm3PrbYSdrckwVQvWYLxoLpeGhUsKnaaM0hVi7rc4BtaA6UpLf5o3XcN
   i2hoXFiL1WAoTDDPUnC4eqqLLpJcEytiwxVD2OD6f2y8d8rswbKoyhgCX
   4j9gLZMYr2XjYoCbr/BwNrviw1QEkLTXzwwjYWcwAIzADA7sR+O5Og3g+
   47w4L3tLDoGvXLMjbqE/ezLENtXExZCiK+nQvpe6NYhoAB90fN5EdjZ8l
   aReIYrTAkycOdc8+gfQ7gvwpje65vvNQShre6wEZdytNKg9nBycx/obER
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361612071"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="361612071"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 19:16:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="712683572"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="712683572"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 15 Jun 2023 19:16:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 19:16:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 19:16:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 19:16:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 19:16:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0QcIpQHxoz+E9hwYYL97psjW2ofwix8xnjDaYKqmLENA1ZrCz8h3Ei8MAf/sN3qIEvnq1Giw2juq2F4yyl6F2aSn3YvgtcfDt71m1FS3HjkOXvt8cDcPXDtWLFo4eXXtEgNY6CPMJrlC34DzENPhdE5xN3LOkTC3A4VeNcxddFQqxgX20BW/wlZQudbifvUZvEcwAhd9O6HUFIGcGr9KhMqZiqJJDumjcd8S5GDlCJRdcLhW/0rV2zOu2J2UCfDhEF1fA6DC2LKeP7Sa8KL9ufaaDxVfHJ+TnwQofuMYAcab8glkDsBs1oIuj+v6QsQrXKtsY5xj3TB6NPkq71MqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5C6aEGeN9lOtLbd2tuEo93diOrscwbZOOxBEWRJ7ZI=;
 b=aLdH6E17ZRCnWyNfKgH64Ox9UOmvox6n8kh5dZ+wL3x24KpTZXD0Zv4kR5TQkmvORChbO6bmu1voUvYGMjddNMbLy4nYmsnr796aWW7f7wsVcKSb87xlkOzhqOBc/1eBkCWzHyNENWUzi8S7nKO+rwAe0USWBLh4l7PxBcAIMPv9obCXt6Se5pzs3oD5oeZa3/MgDsb+uC0cOtiDxiS3eRBRBbEW87jyW/u29YGxvLJx0N7y6utV+RvQKbATJBts4V81oP/00hAiTM0gpk+SQ+XEjT+MZWO5X3Zm28vxWuoKneRlxlJ34xU4E6t2DGUSd1uEjMadLtMxB4iafLAlYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7020.namprd11.prod.outlook.com (2603:10b6:806:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 02:15:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 02:15:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "clg@redhat.com" <clg@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: RE: [PATCH v3 1/3] vfio/pci: Cleanup Kconfig
Thread-Topic: [PATCH v3 1/3] vfio/pci: Cleanup Kconfig
Thread-Index: AQHZnvg1H6CyXhUibkStmEaAxcFpCK+MsvPA
Date:   Fri, 16 Jun 2023 02:15:58 +0000
Message-ID: <BN9PR11MB5276CA1ADAAF0169526DA5668C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230614193948.477036-1-alex.williamson@redhat.com>
 <20230614193948.477036-2-alex.williamson@redhat.com>
In-Reply-To: <20230614193948.477036-2-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7020:EE_
x-ms-office365-filtering-correlation-id: 1d0f64ed-c64f-477c-3e19-08db6e0f9f9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4OlXXKwWGdo7SSYhip4XuQVLzen4SAL8xNvTVh/a1oRLxorFvVOjYksrDvg96TWwlnXNour++BJfVffRrpIMvU2Exz+YRep3ZEyjLVghwufPkjwoqFiW4TjWQzpcCwPvcznNigvwzeBZzXA+2+PsJ4auXxN6BkU06ee8LKrCLFLJyilFOQmZ/lItU4jjZJ9F24ds7Yry27ghYLRjRxYkVu3kwLc7eHYW8bfnwwTsdI/eIqFYEKlDytLtNN/P9bgvhlbn6kRLjSCL/ZYfrkVKYlcjdyS9t0GccxPJsIG3JsNL9Sf6cJp1PIwGPyA01qiCBtbM1qrbwEcb3xQE6mJ4INTjp+/qilHEYXrCNiuonG1+efxdsyEUjnAjbvxRwmCotNi8NxZ5gn/Dm6gQ9+WZXiSBU8AdtM2KnRC7PmE7s3TMAqVDsS+zfSyD8nwSkLULCGSBfv0W1qivZ/5GBHLN2RvLetVvv0BSL/YZ1QD6+Tyqx4LqZiLBY3jGYkYbzxzEqAKBXe+iRhjq1ZVjNfbMEGMrLW6Q0NcZcg4ZHKqSoOTfADwyHByvlQCkhr0hwMN5tWC0+zDGOq83FQQzWqZhdbQHy3clwRRvzqgGWW7pTpGVKOjlMyPV+Zrzl1yQCq9i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(478600001)(55016003)(86362001)(38070700005)(7696005)(71200400001)(316002)(41300700001)(122000001)(38100700002)(66556008)(66446008)(66946007)(76116006)(66476007)(4326008)(64756008)(5660300002)(8676002)(8936002)(52536014)(33656002)(82960400001)(4744005)(2906002)(186003)(110136005)(54906003)(9686003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OElQQUdMZzd2Y3JhZEswZisrL0UxUGJ1Y1FOUUZ5a2ozUjAxUFR4ZXIxMFJ4?=
 =?utf-8?B?R08zaythZnF6ckZKa1YxT01nckdGVERlZUs0cmQ2N0JVY09yRkYzRkFVTXFS?=
 =?utf-8?B?aUlVUHhRdElibTcvVWRqM0dnN084cE1JNkkrWEZQU1I4NlFnRG4zMlVzL0Jk?=
 =?utf-8?B?c1ZzdXFveW9KbU5EWFpsZ2lPbkpQQ1dsUDhuUWtYUmlsVVBNS3ZydGs1a29v?=
 =?utf-8?B?Q1hJY24vMWZrbnBIVy9NN1RyeFVhYkE1KzBvajZsZFV2YmFHRk54Y0NRNDBi?=
 =?utf-8?B?UENpVFdTU0p0MjhFNS9EYk1HZzJZWmhna1dHbW9ielRGQ3doUEtWWllSUUx4?=
 =?utf-8?B?dEJuOXkxeUY0SEJ2RnNTUzNJTnRlZkUyeStpN2pGZm0wTldaR2YxOUdieDIv?=
 =?utf-8?B?bmFCUW1FTW9RRHN4aTdiaWo5QmZieWgxRVhNZVZaa2VZUmViZnFtZ2NTNlhU?=
 =?utf-8?B?Nk4zQVA2S0E1cnNzR1hkUXVEWkIwYkcwNkcvejJiZHlraVZZaFpDODVKQTVT?=
 =?utf-8?B?WmZQcmkyUTVZRGRjQmZTT2hvTnFqRER3UnIvemFqb0lLQXZKNm9PLzJEMXBD?=
 =?utf-8?B?R2s2dFhDM0p6TmNza3dFQ0d2T3FCdk9VNzd1Nmpoa25IUmN5TGZoeDVES1o1?=
 =?utf-8?B?Z2FaNFFvdEJ2RTMrRGhFWWx0YVBIb0dDMFA0U0M1U1VZSW45Nkp3NUFpa1Zs?=
 =?utf-8?B?TlhzMXBIQ3hWVnRTb3VTM0FxY0pVcnRVOS9SWmdTdFhJVVpEQ2ZheWNZK2dL?=
 =?utf-8?B?SjZrSUtBMTZYNWNHcFNJTXpLcjRQV09PUlNNakVBY1VFakxTVWIzcTlhNnha?=
 =?utf-8?B?WStMbk91TjRIVFhoYWh6TmFSSW1SOEpGbjVyNTRyYnlRVFZYNVZwaXpLUzZY?=
 =?utf-8?B?bjltT0JNZS9SaG9OQ0RVL2Q2c0ZUTnE4djgyM21wVzA4VTlSdzlWZkxxczM4?=
 =?utf-8?B?OHc4U1RTRmsveGRXSVJpbGlFRm1yanc4Vy9YMkpQQXo1c09OVkEvKytmajJo?=
 =?utf-8?B?NVpaZFJyWFQwV2YvWE1rZ2lQSDIzQTRMTmtFN2NHeWRnb3JPNFFGamhYK0w4?=
 =?utf-8?B?V0lQRjdha3h2U1RRRVNlY2RmU2J5QisrSHF6YTVNRmR2bDRHV0ZOc1VXd0tm?=
 =?utf-8?B?ZW5xaWpRaUxPUHNMNFVOUjMxWUJVSjk2a21IcDN6NGc5QitsQ2hGNER4bkZn?=
 =?utf-8?B?eFVDdlJBNXdyZ2h2ZTdDNWxiS0NLcGV0R2Mwd25vTnBTbTdYb2ZSNXQ0ZmRr?=
 =?utf-8?B?K1NUcHJBV0JQMlFOUkk4V1YwYVNpTnE0S09zOXJIbUNYZHVUdjgvN1ZTNjlZ?=
 =?utf-8?B?VjZPS05JZDV5bzFLaDc5bGEvQ2RDUWRZc0NQNk52b1BySDNENzh5eVJVSlRm?=
 =?utf-8?B?V0hnTzB0Z3o3NVEvSnBRUDJhaEMrdDEzVEdxcUlYNFEyOU96QTJzV0V3WWVH?=
 =?utf-8?B?V2F3SEQ0Uyt3NTRBQ1A5NXJtd0p6RFZmd3dnQXVBalZvY0FnMmUwdGc1VHdu?=
 =?utf-8?B?VkdoTXplTVhpamM2YmFiRk1PMXFSdXprVEZ3dktyMVlTYmxETVZSODlyeER6?=
 =?utf-8?B?aTlzWXdYNjAwNnIrNDhDcDJITUxqRjdMM1hDS1NCZStUQ3lqdkhQa2UrbWJG?=
 =?utf-8?B?bTcrRVhHRGhJWERNSlU0RER6NDMxT3N1NDl6UDBkbExvVjMrcmdmQTQyZEdE?=
 =?utf-8?B?UVlTSFFEN2dyQzJjb3RaMmp3aWtmK3BUVnJKOVU5aWt5c2FMK1h5QWpJYWUv?=
 =?utf-8?B?TTdmRnM2dEN5UEJXc1lmejlKYVRCK0RpSlJSajQraHNpK3BHUlhaYVF1Ymd6?=
 =?utf-8?B?SFNnQlhjL1VMckk3NjJHRW96dVgvYmlDRkhtaTdjVDdkdVhqVVAzOTdHcFUw?=
 =?utf-8?B?cXpwMkJWMEZGbFJRSVdNTG1Ud3FJYytaMzFwa0hGOWVwRlVqdEVST3c2RWNi?=
 =?utf-8?B?VExoZ1IvNGhvNzhxeTlhelVwM3hSdnJrYUVnbzNRVGdDS3hrT0VSdUNlWGl5?=
 =?utf-8?B?bHl5aHlqNjNvbFJvMnhWQ2hUdWFQRUk4bXc0Sml6dFJsYU90WkJ4Q1NVeDB2?=
 =?utf-8?B?RUd3WE1qeURoc3luaHlKZXBhcEF2Mm1MZ1NpSjg4VE11S29YRXBRSHl0eEJP?=
 =?utf-8?Q?QcEqu20LEz477Y8kDEKvzbSvF?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0f64ed-c64f-477c-3e19-08db6e0f9f9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 02:15:58.4232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PZpxAK9mUlhlb0rT4QXbKRuoQmOGa3mC0dC6IcswpThllCpoSIa9j1/nFZNeVKyeSXpCwb+bETgVN/oe4QFM/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7020
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

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUaHVyc2RheSwgSnVuZSAxNSwgMjAyMyAzOjQwIEFNDQo+IA0KPiBJdCBzaG91bGQgYmUg
cG9zc2libGUgdG8gc2VsZWN0IHZmaW8tcGNpIHZhcmlhbnQgZHJpdmVycyB3aXRob3V0IGJ1aWxk
aW5nDQo+IHZmaW8tcGNpIGl0c2VsZiwgd2hpY2ggaW1wbGllcyBlYWNoIHZhcmlhbnQgZHJpdmVy
IHNob3VsZCBzZWxlY3QNCj4gdmZpby1wY2ktY29yZS4NCj4gDQo+IEZpeCB0aGUgdG9wIGxldmVs
IHZmaW8gTWFrZWZpbGUgdG8gdHJhdmVyc2UgcGNpIGJhc2VkIG9uIHZmaW8tcGNpLWNvcmUNCj4g
cmF0aGVyIHRoYW4gdmZpby1wY2kuDQo+IA0KPiBNYXJrIE1NQVAgYW5kIElOVFggb3B0aW9ucyBk
ZXBlbmRpbmcgb24gdmZpby1wY2ktY29yZSB0byBjbGVhbnVwDQo+IHJlc3VsdGluZw0KPiBjb25m
aWcgaWYgY29yZSBpcyBub3QgZW5hYmxlZC4NCj4gDQo+IFB1c2ggYWxsIFBDSSByZWxhdGVkIHZm
aW8gb3B0aW9ucyB0byBhIHN1Yi1tZW51IGFuZCBtYWtlIGRlc2NyaXB0aW9ucw0KPiBjb25zaXN0
ZW50Lg0KPiANCj4gUmV2aWV3ZWQtYnk6IEPDqWRyaWMgTGUgR29hdGVyIDxjbGdAcmVkaGF0LmNv
bT4NCj4gUmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IFNoYW1lZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlA
aHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5A
aW50ZWwuY29tPg0K
