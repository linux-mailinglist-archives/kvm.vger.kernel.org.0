Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4FB7691DD
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 11:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjGaJft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 05:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjGaJfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 05:35:47 -0400
Received: from mgamail.intel.com (unknown [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8591CF3;
        Mon, 31 Jul 2023 02:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690796145; x=1722332145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qkdekMUAi0UvVMdV6wXLEopqSPabuyX5rhzzxMMD8HM=;
  b=ZmjpG1OmDZ39Gh3Xx48jQqHafsB4HUONiBPJmWhuAEdTTzpo3KI+dl53
   0o8wLe1tUPcuonQReDNwF5b76VNYX/baGEJ73BZ2r3JVDgyYStQ0wr4H3
   c7JL14JgEhaEXxrX74Gzs8yuUtFL5RieSMsQBpRdsos5ftpoTTwP0JRll
   SgGA4hBNdkCu/VbiNbHmUpL+ebcvQyTndCDQHzY09N6uy9j2pK9X2clLe
   Dsg/vuaWLPPQOqglV/UuEmQu2fIQHTSdXi/ObgwLGtPBhat/QKL0aw/CR
   ONoNzQRS23NO1fauxm5SJJ/mVUgYomGP5rwWSFZ7L2fp0QBTMIfaZC4rt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="348570418"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="348570418"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 02:35:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="902057521"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="902057521"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 31 Jul 2023 02:35:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 02:35:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 02:35:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 02:35:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 02:35:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDZCnJzD4JfyrIP48AjJ82ocV+hM5InDz/FI6wQ15z5ghy4VpOe0JtS7P+tHGGVUpHnBLsqgAKRsX1ZtpfhW5OPadPvWZRlgpykJ+Uhy2B8aIk4C1kQgz0G5+JCiAN4dczbj0EAZMZeAfuCNrsKZTpfs6Z9fGVU6kgR7T/Lxv/n69eLQecpmpdXKn6aYcxI/SxTHmuAwTTjZyNzoUSkxGgqBOOPlscsmzdMTF61XxnE4iptQ7yNoY8Dmggyqf24hLHhFUVz8VfUbXud2Mmb7fepUS76uMFscAiUclhAeNFDY9DXNj1ooPIk7KOMYt9vkoyRRrQ7a4x440kJYS79Jnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkdekMUAi0UvVMdV6wXLEopqSPabuyX5rhzzxMMD8HM=;
 b=oDj2+KP5KF4keaU107VgwA24a6JmgVtaM8Y5tAjjWxUXvi2JFeJefl2N34sQozOqSHDEl2vN0bAbaWE3iWbBF1WAdtlqIqFoWJoyBvQ0UgFMTwVGr5UIKTQb+FTnVhLzE2EF5eV0ZN5G2LCP8JuACHBrJ383p53Wi1EvUxpITn38AxZLHGn4aV8ZNruZTZkCU57sOxJFdOw5H6adpBz2D5w9tLWedNFFH7yfFp2y44izsFxL992JWlmsTC6kPXZ03xoz6sRFIRPmgoho8OMZQApwBtlx+QlKEPv9qADC47FQMqbj8hhtDfSJaOOEDxhmE93fRlwNOlRtda/6FwCmPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7818.namprd11.prod.outlook.com (2603:10b6:610:129::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Mon, 31 Jul
 2023 09:35:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 09:35:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Guard against collision with KVM-defined
 PFERR_IMPLICIT_ACCESS
Thread-Topic: [PATCH] KVM: x86/mmu: Guard against collision with KVM-defined
 PFERR_IMPLICIT_ACCESS
Thread-Index: AQHZvCQLRBqu6N1Q9kmoUAbbnpqllq/TrG0A
Date:   Mon, 31 Jul 2023 09:35:36 +0000
Message-ID: <caf35fecfa517794385006616d580544a6dd7866.camel@intel.com>
References: <20230721223711.2334426-1-seanjc@google.com>
In-Reply-To: <20230721223711.2334426-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7818:EE_
x-ms-office365-filtering-correlation-id: 29fb44ae-b2db-4297-208d-08db91a97f0d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8fNyfc61j7ZCaNBgDzAkDJz96uwm7a7DKSg2lUTqGjXiZXjaPtHmhxzHPltlIXkD0RJI3GtoVCbE1pY/ksdaapWk4eDjBTpnyZnhELsO4wG4HmTwoCy4o3OEZYWveGnhidGOfYIVbfa7EvsQ3Oif69D2uEK9E9sJlwsxrnBvxNq1OOvovTrwD3wetCG40JSZTC//NWC/W05J6DkdZ9Yp4+YWGS5OPxWaE9GHLm54jpBj3cJZSU5u/AKeOynM1st3pVyFe5ulOCdHcBY1G8U++f6W+FUS0FVF6DuzfOup4UFirY0RQO9ctFtOY36B5a4ubY679310+vCwwvd/BSw1ojcUcZAfLOSoMG4OgFVKXv10tEl4m4T/m4Q4TULnQDQ9zrwITGen8SsKUrkH5f1M/S/8wjnb/J07ZsNEHbPoD8Thw/PQFwKtwsMUTq2HpW+9N+3apEGGbeAgu/KL+uhiBzyj+vtC3aAcUp9hsnJAUp0xoGeRL6UcJNsASJShzDPI64UXHBesg3w+utAIjhd2Z0U/TA0dQjvtf1uv5opoZZ76VgiZWYOHRThX5DGRY+Vmna7rwmZ/f/rojV28Hrx/8RT9wK2dGliIjcFnJA6ZAs840/Wcn3GHQIyTz/HKQdnh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199021)(5660300002)(66946007)(66556008)(66476007)(76116006)(91956017)(4326008)(4744005)(41300700001)(66446008)(316002)(110136005)(54906003)(2906002)(64756008)(2616005)(478600001)(71200400001)(6486002)(8676002)(8936002)(26005)(6506007)(186003)(83380400001)(82960400001)(38100700002)(122000001)(38070700005)(36756003)(6512007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWNmOXVsL3VkWGtZRnVHVjNqSnZtQjFONkxVY1VUQ2d6TENDSUF2djZNaWFr?=
 =?utf-8?B?MzNuUkJmSnZTL1E4b3A1aVlJcjRiL2xNTUM1YnhsMVFKZkZqcUpDbWhJUXlO?=
 =?utf-8?B?TmorTjRnYnZDcFU1ZkhIdG0xaEdjcXdld1FFcDJRRGhieDR1dHlLekYzdXI1?=
 =?utf-8?B?cHYyUXdqYnYreXdzZFg2T0Jtbi9CYzBJSFRvakNUUVd4Wm9FTTliTWpDMjVQ?=
 =?utf-8?B?bGs4SGFNYy8reGo5VC9KSDFaWWJnbEg2UDgrTEFzcWo3OVZndkswTSszQTE1?=
 =?utf-8?B?aU1lRS9DQkVuQU53QWxHVlF4WTVsK1Y4Wm81S2QyaTl2ZTFNOGxUWFd3RmVx?=
 =?utf-8?B?RVhKZWtuMytrcFJFMmR3TUtML3hUbFJFM1cxNzVOcTRMTnZ3ZFJiUUhRZmdV?=
 =?utf-8?B?cnh0K0hicEpqLytSTWhoNU52Rk5pNURlTzVYSjBVbjdFR1QvTnQvdmZHeUtr?=
 =?utf-8?B?MkZWUm8xc2M3RElMUmdqOGpUZ1NzcGFPSm4xWlB1ZEVPYmNtOWxOVXNlY05x?=
 =?utf-8?B?bnBkYy9uWGJLTGZPZFpiamN2QWFyVjlzYXRzTjNGN2dseTVRSG1valYvUXdV?=
 =?utf-8?B?NmR6T1pIMWI2MEViSVR1M2MrZkRwZkorK0EzMnU0ZGVGMFdNdCs0NitFR2VY?=
 =?utf-8?B?V0JDSGV2ZmpQMHZRS0ZhUktFYjFENFFuektSSU1yUndlUUhwMWNWYlF6OGs1?=
 =?utf-8?B?TVk5eFRHeGJ3WDdZUzByeVJFeENWVU1UcHJ2NEpEckV0d3BPL0NxajFscWFG?=
 =?utf-8?B?TnFncnR4RlhRM3B5UENwc08vMnMrL1M2Qkd1VTUrR3lic09lczBwT0FyUVBa?=
 =?utf-8?B?eCtJZkVENVRobW9TaS9IT1g4NGNUT3BrL3k4L1VhUU8wWUdMWFhkVnRnZkRZ?=
 =?utf-8?B?RWhVNGVXR2VZZ0V1dUZrRU8za2htNW5FVE8xZmhYUlh2cGlvbGZPT2FJdkpm?=
 =?utf-8?B?Y3U0c0pXSEIrR3gwbmZpSTB6ZUNtcDRrS1FrLzNIT21MUmZ6UGtIaUIzVmJR?=
 =?utf-8?B?QzA4anlvbWdYaTl5NjVMaFFKalMwRmtNTzJQK3pmakRqMVpFWFlFeStjMFZ2?=
 =?utf-8?B?cm1HZWJWYWtFOSsrb2lldHpqc1I3b0ZhY3FlQTlXeWVrS2Zkb0NRYm0vVVAv?=
 =?utf-8?B?ZkhhaTNpQmVYSnBxaFVBZkRGUmNNUWVWQjFwNHk2d21SdVl1NDhqVzJqQmVi?=
 =?utf-8?B?aVA4ekpvQU9zd3FkbDJEWnRiTEdXNnQ5VzhVZThMaXh1eFhTTXIrTGtzVVdF?=
 =?utf-8?B?cHRnd0dFNmhaMmdINGcvMThpa0trVUtabmNSelV5VHBFbVBoMEFLRCswS3Jh?=
 =?utf-8?B?d2RYVUloRG5IYVdkdE1JMGZLS3hkR0hmaU9xN2RNeWNKbWNibGZHN3VXTTky?=
 =?utf-8?B?Z0FGNG50OWJSb0RKTkxWRlZPL1crNXdHa0ZMU3VockkwL1o2amtxUnl0L0tP?=
 =?utf-8?B?M2JENUNkRWMwbk54cUVDSFFsT3BMVi9nYjU2dzRhUkc1NDl3L3loODNFd0t1?=
 =?utf-8?B?a21zUFJoS3NzaFdVV3hnQkpLdnR0Y2hyM0psSVJyamRpdThNZXphMkk1Mm9Q?=
 =?utf-8?B?RVhTd3lKaGxIZ3djelFFRFJzbFh3VWVQMXRvbGdrUnpwQitpVy9ldFA3Z1hG?=
 =?utf-8?B?TkFoUzhSbVk2V1RGalR1Tmg1WmxNdlFRRTBtUVoyUGt5Z3JncUFpQ2tOeFR3?=
 =?utf-8?B?SXV3UXYxQXlEUHNoYmZIVmZ5R3RQdXdSclJWUXFtYWxQQnNkbjN5TUF3Q29l?=
 =?utf-8?B?VWlBREFjdFhnaU1lUUl5RTVFdzdpVXNPNmdiRGk2L3IwbWpBNUJUazQ1Sk1X?=
 =?utf-8?B?OFJhR0V5aEF3dDJCbXlYd1c2N1RScTRGVkNlczRTajQreVdkT1c2VmJEZFV1?=
 =?utf-8?B?VCtRNWl6akRndm1xWUw4b2F1RGkrUEZtY3pFRjB1emN0bk1JcE5FL25ZVnpZ?=
 =?utf-8?B?VExWeUhRZEx1ek5TQWEwOVFmd04ySVBNR29vZ3gzOWc0SXFqblNCK3kvc3A3?=
 =?utf-8?B?TGlkSWkyT3F1MWlZZEd6SDVsV05kS1dNTW4rUVFZWm92eHM1T1AvZlZBZ1hF?=
 =?utf-8?B?T0VjSmpxcTRLSUFiTktNVVBFbmF4eXF2TUdaaCtoUk1peHpHREdZcUgwNWFa?=
 =?utf-8?Q?YMxJxU3Kkc+AOpiBBW0L8tTWz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60FBBA3D6277084191787838673C0A5A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fb44ae-b2db-4297-208d-08db91a97f0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 09:35:37.0113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MajQTMG2lNnrQgA0NcAxpxP+8/VJI9AyiPZDNAoCY5ykAH65Tq4zuNkjyIRXuT6ot1JCdwrffA1bhS3M+9wo7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7818
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

T24gRnJpLCAyMDIzLTA3LTIxIGF0IDE1OjM3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgYW4gYXNzZXJ0aW9uIGluIGt2bV9tbXVfcGFnZV9mYXVsdCgpIHRvIGVuc3Vy
ZSB0aGUgZXJyb3IgY29kZSBwcm92aWRlZA0KPiBieSBoYXJkd2FyZSBkb2Vzbid0IGNvbmZsaWN0
IHdpdGggS1ZNJ3Mgc29mdHdhcmUtZGVmaW5lZCBJTVBMSUNJVF9BQ0NFU1MNCj4gZmxhZy4gIElu
IHRoZSB1bmxpa2VseSBzY2VuYXJpbyB0aGF0IGZ1dHVyZSBoYXJkd2FyZSBzdGFydHMgdXNpbmcg
Yml0IDQ4DQo+IGZvciBhIGhhcmR3YXJlLWRlZmluZWQgZmxhZywgcHJlc2VydmluZyB0aGUgYml0
IGNvdWxkIHJlc3VsdCBpbiBLVk0NCj4gaW5jb3JyZWN0bHkgaW50ZXJwcmV0aW5nIHRoZSB1bmtu
b3duIGZsYWcgYXMgS1ZNJ3MgSU1QTElDSVRfQUNDRVNTIGZsYWcuDQo+IA0KPiBXQVJOIHNvIHRo
YXQgYW55IHN1Y2ggY29uZmxpY3QgY2FuIGJlIHN1cmZhY2VkIHRvIEtWTSBkZXZlbG9wZXJzIGFu
ZA0KPiByZXNvbHZlZCwgYnV0IG90aGVyd2lzZSBpZ25vcmUgdGhlIGJpdCBhcyBLVk0gY2FuJ3Qg
cG9zc2libHkgcmVseSBvbiBhDQo+IGZsYWcgaXQga25vd3Mgbm90aGluZyBhYm91dC4NCj4gDQo+
IEZpeGVzOiA0ZjRhYTgwZTNiODggKCJLVk06IFg4NjogSGFuZGxlIGltcGxpY2l0IHN1cGVydmlz
b3IgYWNjZXNzIHdpdGggU01BUCIpDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdA
aW50ZWwuY29tPg0K
