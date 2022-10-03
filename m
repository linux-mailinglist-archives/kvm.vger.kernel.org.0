Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D245F36DB
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 22:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJCUJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 16:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJCUJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 16:09:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F90746627;
        Mon,  3 Oct 2022 13:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664827744; x=1696363744;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I8N52LlMdfyLvTvyKzQnmCzj3UgCLzfQpbSSRjKOIEM=;
  b=bfVuKopaHdgXzyi9K5iHrhWrXDMFF9CkzzTTdnf3YG33FLpevf1SHaRB
   QiiItC8nUVBWkv6be4RO5mphp7KUo69z2DspR6cNmvJVzyTKzYcy20OWk
   HD/MldCywBcjteIiAyhBmwJfU5v2/vCDBpWQJXTm+KGFT4PRdwZHX3h2V
   T5sZLraKbmqGcj56bAgmahP/3FahKCQIBF2HWmY3f2cZOQNRRxaVcGhui
   ZVqeRJcIJm7uv9n2AzlHKkWZs7/CX7lhQXj/x7h4PfB8gJrQWPNhU6hum
   DFWSccN+m5OAXCZZd1G60JP8OT5chdoa4M7j6f94sB9+mchE1GUf46iKp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="329149601"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="329149601"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 13:09:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="654508590"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="654508590"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2022 13:09:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 13:09:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 13:09:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 13:09:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 13:09:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEQsGOYnFmRCXhYmOPuszdqJ2qGVvtbNXrZEkgwBkaOzSF5EA2m/DLCkSNZ15gjK8q6AckZLlwLGUSQ2d5fZ/XfgQMXqwAC+575nE/HIrfJNjcUdEtJgs4zmi6vn1w5DmTWnOubNfk8owaUHQMKF6sz03R6Sy7DxGTpCbQoPMhiLaSryjZw0QfQOSXK4dQZBVPcSvzHcaQezp7DG6rj193qWX+Ui/QlOFKjMujUjbUKXBkVkU66IMuQuTVCGB/Gp0KfbVh1+ZfT8muZamobHesYd++GnyJbRkF/A1qYTtzZgSzmAwVlvv8tV4Wv4Wdrzl2rtmTKU0xFou1/6sXIbiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8N52LlMdfyLvTvyKzQnmCzj3UgCLzfQpbSSRjKOIEM=;
 b=nWyYkiDkdUDYhRB25DHIjzeYoPS2B4QPSbC9YqGhd6ZrWA4w9NWPm1r+nhZUqFvhhxeys8RL8K1J0AI7u792tzU2XMy5CdcKZPWorlTkA3z+xng6pHudbeXmu7QuXazcPFHCjJ8Q3LOsrHYV9JrMyhcavAH8SCNzQYKdJ2NC5sYtanDx9C7uHtEaF89iQO8a2/7GztFbA8DBG6ulpfWqdfIlbiOmG1qb825hW6H5YAAvQaUWrdgewl7mMj7IqJBveaKZlboGNRldqeR3vZ/ZEwOON+SzWqmj8+KKYaCOmLxqvTsAaY6fcylU3tID52vRfHsoGFM2Z3FoZfHgfdfneQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Mon, 3 Oct
 2022 20:08:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 20:08:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v9 000/105] KVM TDX basic feature support
Thread-Topic: [PATCH v9 000/105] KVM TDX basic feature support
Thread-Index: AQHY1LYtIC3VF0/twUaLSgpXq2KJpK35NsUAgAPMGICAABuNAA==
Date:   Mon, 3 Oct 2022 20:08:37 +0000
Message-ID: <56a9b3bdedd0b7bfa28703f1af0187c85bfb3455.camel@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
         <Yzf6tD9HZasmPVvY@debian.me> <20221003182959.GA654699@private.email.ne.jp>
In-Reply-To: <20221003182959.GA654699@private.email.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4951:EE_
x-ms-office365-filtering-correlation-id: d2be2d97-c8c8-4d17-46cc-08daa57b0f02
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qXNfHQp9p6ToQTfnxI8/i50ziPxzd+TFZp8W8qEzn6VqlF8U9snirY7e/k5Ag05benZO2jTsHiitZu1n4hfe1sxeLkdZjmB7EfYIdTrsgGwL/HGkQMFBsf5X4c1WDbIT48GTpXYYdeE4AjBtMErB5LaakQ4Fvvhxj330NUPUvB7b3BgHXxFX0PxtfDpEniipyDV2phzW7KAFQguKXydjHFmrEmL5iA63trRPRrMb+aNEtWTl8o0i6nLJOU3BOBYBh3BVLd4bafAKj1q9kNbkXLetRTJMzzC9RYOb/K0UE56c8BMaIrFjwEvTThl5YrsL25jG/1z4XWoFuEbncgfHJo68gPLAGsZKCplenp8DXdXL0Mma+vsl0GpiuBsZvfscjpfMsTovxwZNI9wQo3EgxZch1kyGtV3UP0G8zO3nVP2HHoK+9SBdjd9r480AJ3FOyuUlek6wnQC8YOK0C3nBH60aV+yhohGw1dVu1SgvomOCCAKmub0VENpIQl+Go15luHmtMrcCuqSOFghzDM1qFPwAeA4KHuWjqJgsL6HuMYDintgI6dcViInuvw85aOLliZeJb7S6E2L34D26e8YUEsd6WMT8lZ+S2OymmeZ3zTKrvwpfrAwrxOuKxUy7urUjP+D2vks8wbkpgliNQ3hp31x87B/VBwazS0GwPB4v/8YCHQKY5pDJonE5h3KaP6mc4t6VWiJi71mD+opebHv3/M7m+Uxo9LYret5QMxx9AZxwyxFnlyAEjUzZVYGpxTknudIjJKNGaqgza/4yEaXW6fgOVQI8Ef7c7Gb46J/sV99sIzz7eSkxgmzTzB/QP/puMQERHc5/hRu0MtZrngymOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199015)(186003)(82960400001)(38100700002)(122000001)(8676002)(4326008)(76116006)(66946007)(66446008)(66476007)(64756008)(66556008)(316002)(54906003)(2906002)(110136005)(91956017)(4744005)(41300700001)(8936002)(5660300002)(2616005)(83380400001)(966005)(6486002)(478600001)(26005)(71200400001)(6512007)(6506007)(86362001)(36756003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnY5SnhHbWZ2VnovZGg2b1NwcTBqbkoxREg1eW8wKytpUnJTR0M0R0lBVFcz?=
 =?utf-8?B?dStwUXlKWmdJcWpHbmFXSzBvSnB2UjVjamlJUWdXMjB6NTZPeDFPWExlemJT?=
 =?utf-8?B?MUR5YlNkREJjU1RXcFN5cjVJd3k2aW96Zk1BS1lrRWlUWmtGNklZRkVpVm82?=
 =?utf-8?B?TWl2OGk2dXVUc3Byckk1RHB0NG8xMkd6eEVVeWVyT1oreVVDOUNaY2wxV3dJ?=
 =?utf-8?B?dVRXaHI2cGpPdzZnNnFML0FqYnJrOWlsWm40UWlqb1U0VmRrK2lnSjBwZkln?=
 =?utf-8?B?MnM1UzU2cjlHUTRtSUVCMnRDRHAwMGtlMk1uUHZFMG4yL1BsY1lDVS9pNUU4?=
 =?utf-8?B?NmZ2czZKOVIzK1NUU05HSnZWbnJSaWhWTXhYUldwVW9uQXQxeTBZemxzOFNO?=
 =?utf-8?B?TnR5SGp0T1BEU0wxSmNwTEFRR0YzZHNTMnZ5RDhBWHpuWlZWOXFwRE1Bd3hI?=
 =?utf-8?B?YmRyMldTdTlOL1Z5OC8zZzhxbGVUZ3ZWWEFZTlNKM0p1bzVVUkREbVBIb0xu?=
 =?utf-8?B?TFVqR04yZGZPdVRMTEpIWlg0UXppaHI4M2s1YXZZWFlNM1E4QnF3TWt0UDBW?=
 =?utf-8?B?N1NZbVVYbi83b2FYbTJab0NMR2FFNHh5RHJ1c0lqZVdOK2oveHNtZEo2RjV4?=
 =?utf-8?B?aDVySWs5ZEh2OEJSVDhnRUxOTzhmMkRlNjkrU1hsMTBJSkhRNGFac1ZuK0NM?=
 =?utf-8?B?aXRJVnJrbElmNXN0Q2M2NlNORk05OHNQQmRWa1dwUncvUm5VMWFuZDJFTW5o?=
 =?utf-8?B?N0ZpMytlb2dNbjFaSXUzaVNVOU9XMmpvY3BTdTJ5VG5pa0hqQ05ZZWI5YVdQ?=
 =?utf-8?B?V3QrMFRQTGFJY0UxcGlXN1AxZk5nVkptTjJUSitmK3hZWE9GaUpFUlB4YnAv?=
 =?utf-8?B?dFZRZW1EVTkzNDlibVNxZEFwdlUyUTRLT1RVbTNNeHlER0lWZnoxTTMzMjNy?=
 =?utf-8?B?OHdEZjA3cUpNUnExNkV6R0FsL3JhRmNvUTBqSDlBeE5jQzgxVWU1Y1czOVFB?=
 =?utf-8?B?L0twcy95NkkzM1dQN1lUOFhiN21uRVhqeTU0R1c0b0FKMUJjc0xqcXZ2Q29U?=
 =?utf-8?B?M0F0Qndvc0VESTZMclNuZ2RCbzBZWEtCOGdNSWdSNUdCMDVWZW5tdVlnQWtn?=
 =?utf-8?B?RG1OS0pPdVZicmlYcDlFRnZkUHAwM05zdEhET1prbXhMa1V3dHlJTnNjNlVp?=
 =?utf-8?B?RG41dTFPbDJmb0FDbWJBQy9udm8wYUJHeEFsQTJpczV6NkhxSmlxbWNTcjJL?=
 =?utf-8?B?V3dNYyt3cVg1U1l2V0x2VEFkelorN2xhM2dvWDROL1F2SytMN1YwUW0xOFl1?=
 =?utf-8?B?OCtidXM0YXhkLzYzUXliSEc0bnRwdkZoZk5WbzNtQ0NEMVZpa010R3VBVmJR?=
 =?utf-8?B?WTNOWUpaVXlINXNZNVRZakFqSzlOdmRXK2ZiTDh1L1R4bWdxR0dUN3h1eG93?=
 =?utf-8?B?NzlHRXFVSGkrV0tDV1Vobm5jWFNybFRIeHVZWDI5Q1RDTG9QQ2Z4NUtNekFN?=
 =?utf-8?B?MjFWYWhHVEZpVDhFYlp1MUpnbTRVTklsTUVHeEhlbnpLTDJqeXVhdHhYa2xs?=
 =?utf-8?B?VXVxUldyeC9IRHVlRm9McHlnVXBWTjhWWFZhZHByaDNVeVowQ1NJaTFIaUdz?=
 =?utf-8?B?RXFxbjJ3ZkFBNWtjVVJxUTFENkhuSFVyM2xyd0oydU1IaWhDM25LVll3Zllt?=
 =?utf-8?B?bzVFaWx6eVl1dThOQjNtWWkwODU1UE5iMTI0NlNhWlovL1RJaEQ1blNLcmdh?=
 =?utf-8?B?RnhHSUNzd29TaURrYVhYSjF1VG9tK1F3Z1premJJRGQ4bU9CeVV5SklnTE1D?=
 =?utf-8?B?YitZUXM0cDViVUk1NjI1M25zOCsxbkw2NTJMOE5WWmlUbjlMMlZXVWRxSFFi?=
 =?utf-8?B?ZExPQjdKTHNJK0N1c0FrcnVibGMwbkQxdFlOMHZCSUNwSlo3RTNZcTVpbTdK?=
 =?utf-8?B?OW9ZTFhrdWtuUjhEVUtQWXdFK1RiNnRudVBaV2EvZ2ZTMWFobkdudlBma0pF?=
 =?utf-8?B?VXNaZTFEakxjVHF0UlMreDVYam1KWm81ejh1U2Nhd1czanlIZm5DUWF5eVJl?=
 =?utf-8?B?elpJSFNXSDUvQyszS2poS1hFWDZpTDFPK3FHRDNJZFUrRWRJQnB2Q01ZOElO?=
 =?utf-8?B?c3hJQXhSYjJuYTNrcE01RkVEOFQ1SnBvc0JBNjRSamNJNkZiQ0VrZ0lYVUtm?=
 =?utf-8?B?MkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D88A194FC3EF2F4386FC9E8E4839315C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2be2d97-c8c8-4d17-46cc-08daa57b0f02
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 20:08:37.7557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aAJUgo4xu/8g78iYP1XN7PN/vXLoA1Tsg+6dzvAiwhXmEA2IzkXQxzsitWk7/n0PWyvSEFnUW2WVRLdqw9HKDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTAzIGF0IDExOjI5IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBIaSBJc2FrdSwNCj4gPiANCj4gPiBJJ20gc3RpbGwgZ2V0dGluZyB0aGUgc2FtZSBodG1s
ZG9jcyB3YXJuaW5ncyBhcyBpbiB2OCAoc2VlIFsxXSkuIEl0IHNlZW1zDQo+ID4gbGlrZSB0aGUg
Zml4dXAgdGhlcmUgaGFzIG5vdCBiZWVuIGFwcGxpZWQgdG8gdGhpcyB2ZXJzaW9uLg0KPiA+IFsx
XTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9ZdkNIUnVxOEI2OVVNU3VxQGRlYmlhbi5t
ZS8NCj4gDQo+IEhpLiBUaGFua3MgZm9yIHRlc3RpbmcgaXQuDQo+IA0KPiBUaG9zZSBlcnJvcnMg
Y2FtZSBmcm9tIFREWCBob3N0IGtlcm5lbCBzdXBwb3J0IHBhdGNoLiBbMl0uIEFkZGVkIEthaSwg
dGhlDQo+IGF1dGhvcg0KPiBvZiB0aGUgcGF0Y2ggc2VyaWVzLsKgIEFzIFlvdSd2ZSBhbHJlYWR5
IHBvaW50ZWQgb3V0LCBpdCB3aWxsIGJlIGZpeGVkIGJ5IHRoZQ0KPiBuZXh0IHJlc3BpbiBvZiB0
aGUgcGF0Y2ggc2VyaWVzLg0KPiANCj4gWzJdDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xr
bWwvMDcxMmJjMGIwNWEwYzZjNDI0MzdmYmE2OGY4MmQ5MjY4YWIzMTEzZS4xNjU1ODk0MTMxLmdp
dC5rYWkuaHVhbmdAaW50ZWwuY29tLw0KPiANCj4gdGhhbmtzLA0KDQpZZXMgSSBhbHJlYWR5IGhh
dmUgZml4ZWQgYXQgbXkgbG9jYWwuICBUaGFua3MuDQoNCi0tIA0KVGhhbmtzLA0KLUthaQ0KDQoN
Cg==
