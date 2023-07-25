Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6247606DD
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 05:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjGYDvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 23:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjGYDv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 23:51:29 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E8519B7;
        Mon, 24 Jul 2023 20:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690257081; x=1721793081;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ALTzAMPOll8q/qFtxIIXI/yJVVJPn89CsRwpBFaQxtw=;
  b=QXI/PDzIyxYGNuUWB5JLls3LfT1KXV7tkJJ6BQOsUjFN6i0OxEUSIh11
   rnEpUQ5b8bqt1LDUkzRSh3q/HeA+XnS88rIfmp1aCSbsjd1bf/v8nNsoP
   7FgbZtkjA1UoeRzlgCOM6tn/4HRZ7b4IKxCAjLF3YERCtl715XGRElZgm
   ns6k7SDNqTpcNjOu4J4c9W6B4T/qwTLvDsabVryXJ2HItuiC/ZCnlPOrW
   hewNtpp6XoyMOxhtkHAxk1FdlpdnlUpLGRPhBri5V5rGYvz8zXXlHz84u
   jmw2GEawSv8jtKjcuy1VGrgUI7sIdqYwQ9bnsSd/G18OalvlAwXVW7mUv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="370279595"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="370279595"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 20:51:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="795998789"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="795998789"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jul 2023 20:51:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 20:51:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 20:51:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 20:51:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 20:51:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBIg75q5gVKT0BbbM2JO8FPhrjP0Q4l7NmwA4ZxJQGMOdTLZaSCXEcQVAIE+sGOGpx/aeL2Qd1wdgJ8LL6OJeWc7BoYPdwAt8VMffX4K6rOPkNEsw+XeTkDkPJ5PD66oaFbWIcgcTq8ZCFN8qPdpD271cAPcPKFMTvqFv8R6ek41o4f/0ZPLrHJ7yXU2GpjhyCoKWQeRlbHt7+6uYV5uKOmtx9PVslK324wiZbBzF8Pabb8wiJDgevxDf00kFtP26x/0043xaa48Ou6lE0xUaVLfwZZ7x82MB8kURIqQKcmK00TppBlFsiukcssQ12xi6V5xqkhdyEkrbfSN9myY9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALTzAMPOll8q/qFtxIIXI/yJVVJPn89CsRwpBFaQxtw=;
 b=kVJxyMp+B4iOsETxOQz9OiKDEAa50Xdtnt9TUvL1LPyDRW/l7EBrqycAt59kjVfPBmxkzw27+LSAmFPGguNBYojXKkQT4FLfhtRFtK4ht9I75Ciko837qLU9z9Fq5FNFHoIZJU9gmYfQ1dFmG0f9cNHlLbnOGOwmb0cbHyMyaa5PR9jg2krImBNRgBAFz5G1QAzoykdXH2nFCotY8venlDhmSKcZoXVggz/3H3hRniXACzzBsI6fvwTyba+v0cFrZSgHH3zHXK/xnOY+Ed1fFrlclr8QUS5n9WCYcD1JWYvMBhR6Crl7Nah/7Z7Ywi+3MRd2iEX/zjo6RrYJf4zhlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4802.namprd11.prod.outlook.com (2603:10b6:303:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 03:51:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 03:51:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v4 19/19] KVM: VMX: Skip VMCLEAR logic during emergency
 reboots if CR4.VMXE=0
Thread-Topic: [PATCH v4 19/19] KVM: VMX: Skip VMCLEAR logic during emergency
 reboots if CR4.VMXE=0
Thread-Index: AQHZvBC20pPLjDeC6UKpM4HW6FXiBK/J3lyA
Date:   Tue, 25 Jul 2023 03:51:12 +0000
Message-ID: <c90d244a6b372322028d0e5b42d60fb1a23476da.camel@intel.com>
References: <20230721201859.2307736-1-seanjc@google.com>
         <20230721201859.2307736-20-seanjc@google.com>
In-Reply-To: <20230721201859.2307736-20-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4802:EE_
x-ms-office365-filtering-correlation-id: e8beab18-037a-4bef-8f77-08db8cc26387
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H4TGYuNRsbztr0EdbSc0LwTi7zqXM5uteHZ8HVYNUJ71lFbh455BsmsZ8lBtRhBkGgWttfAjq8uJwMiKOYN12qFPtx+jiEnJiFf4u7CloUcV/u8HATAzvkB4g9isjsS9wlqtmSHSS+V9wn+Z8yZdwM7E9P7FvoS8GQQ3d0YtQ/LFkk45xGA+Jw6Dc/oD5j3icTbNbR+FbHxW5DVB5Fq3C1RWZvWS6Ac6HAu70N7Og1CYTxZlmFJcJc+xPLXOZnxLgEDRFzAqnB+xRoJAsTH/0SK4XarxSsD6xQMeIlwaGHjMKBPBAKmVFKFgIfjV/Ki84Iyqf98PWG9vhP9w80DfxSNo4kK15vjoIYrb1y6rRAc2qls7XJSzdiQjljmA9QD5QVM91fsHoyDgbWUQncSOd3p//Otrp0+/put6smqM2L2r5qDI03D8OKiOD8UEjU4oGCBxPuHpuGjJvubMqmyTvBzTyl/r0J6v7HqUczPjoXWTx0b8Oq8HVZ16fSp1NPbN+jjYf4UyPp6lx8Zmhz2sMWf6ZWJniXTWIPO1ouWnPJ6sjJUkSSRRd2uUGbda9E6znPk823gNnc4QBXHM43Vo0lUeDhLKH4HDqtzBZEVoplwsGef8uxHZto6fvxDuCX1W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199021)(36756003)(86362001)(82960400001)(122000001)(38070700005)(2906002)(110136005)(54906003)(478600001)(38100700002)(2616005)(26005)(186003)(6506007)(71200400001)(5660300002)(41300700001)(6512007)(6486002)(7416002)(64756008)(66446008)(66476007)(66556008)(83380400001)(66946007)(316002)(8676002)(76116006)(4326008)(91956017)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU9JWkJhT2ZDRldESTZoYzBudVhlQ2JhcUg1aU5NcTM3MnhFNnlnajcvQ2ZX?=
 =?utf-8?B?RE9lRXBCZjJqeU9mVVkwUzhTTkt3NzlTd0tFaGFOL1EvQm84SWg4MWYrNGZi?=
 =?utf-8?B?ei9NcVJ5NlVoNUpmdmdNaTZTcHdqekx5djJ3VE1lMkRaeGVGR2NVVTc1dVd4?=
 =?utf-8?B?c0FXc0s1UVFpYkluZlNTTElLaEdaOVdGQVljVUJZbzRaYTlZckJaL2UzN1l4?=
 =?utf-8?B?Q2kvMkMzaFVheDErb1BpUjl5elV0VEdoR3pjRStyZTJVY1RnVnZoaExRNDFu?=
 =?utf-8?B?cEE0TUkxaWgvSyt4SWh3QW9NUjZzWmQzNllqVlN3MU9QalpOeG9UcklycWN1?=
 =?utf-8?B?bHlITkZrNVZNYU1DQkxMMkJCR3R1d3ZieG5rVkxveC84aU9TVkJZR2NBRUht?=
 =?utf-8?B?aFoxRUVSRXprQkQ4aTJlZHd4NVpmVktpN2NpVlV1VEtkQ1NCU2ZObjVMNGdE?=
 =?utf-8?B?YVRxcTJ3QjUxYlQ1VmZzS0Y0Zkt6UC9UaVdlMWdzYkZqMGN3MVFRQ2luTk00?=
 =?utf-8?B?LzdXejNzRitlSzkwZG40WTNwdVJ2VU1LNldPd1V2bnN2dW1IdHhjajZjdmsr?=
 =?utf-8?B?Q2h2amNWZjhpSm5zQ01vUmlGSjJNNG5QQndObmpKUllkWlRSRFV2WUVyWVph?=
 =?utf-8?B?ME1jdllzVnY3cFRWMGIzbmh6QThpUnJzTnZSR3B1cmhFZUNkc2NzempLSUta?=
 =?utf-8?B?S1poMnM1WFFSbFQ5eHczQWs0SzZ0YXh0WmVrWHNsTm5mcnhJcE5NTU8vY0E1?=
 =?utf-8?B?YVNLWWRHWU43S0NodmR2a0NsSmFXMVI5bklPSmI0aHNrbTFacFphaWdRRDk2?=
 =?utf-8?B?Nm1rTjB2UUVCM0FuM0prZ3B0UkM1OHhtT1o1SitITTR4RmhvWEZrRXQ2dURC?=
 =?utf-8?B?ay9qektyaXNFeUw4SGMwNUJ1OHg5c3lXSGgvbmk0TzJHWUhZd0p4VXpuVTlZ?=
 =?utf-8?B?TDZoK0FBclhWTFd2blprcjRFZ2hEWVI0NGdrVnhnWXVxNkoyQjBYaVBrV3Iv?=
 =?utf-8?B?RU5Hb2Znbk9MSm9xanM5L1lZQjhBcUtyandIRjhxVmx1VzVMeHVwMjc4eXY0?=
 =?utf-8?B?L1Q3M21xSVJmUlU4M0R0alJSdkVnY3lURnBTQjZPVVhNQ3p3M3ZDWllHTm1n?=
 =?utf-8?B?WHN0M0dXVmZFa3hBYm9aa29HYTBHa295dEF2QVdVSjllOEhScTdqSkdnVjls?=
 =?utf-8?B?YlVYVFozTFNuU0JlY0NUT2NCOUVTdVhDdDZWbmtyWENSdGlpQ3ZQQTJXQklo?=
 =?utf-8?B?TzlyQTRZbGtnZlpSYXl3akIwVUhGS0NMNmI2a3NqOUtUTFdIa0dDeG1mQVlh?=
 =?utf-8?B?R05aRlhPUEpua3Rhcy85ZVp5MW1ISjZQd2Q3UHkzNnIveFFEWXMyK0d4eTBm?=
 =?utf-8?B?aUErTlV6cWFGVTNINXRLYVRnNHNpb3luTzJWTmlVMWdKdVdlZHM5RHpZRnhx?=
 =?utf-8?B?RnFNMWRmS1hRQlRSdURCOVJDOTdwOVFHdmhpTFBYcGVVVWNwVXB5MUh0Y0dl?=
 =?utf-8?B?R3NIZkFzbW1XMitGZ1AxbzhtMkhLTmVXWjVNdktTUExKQldQeWhRTDRzM0Nv?=
 =?utf-8?B?Z1dBVnNSbG9zaE9ucmlzK1NhQm9TaEF1WEhpNGwrSXV2Qm1YNjVqSlFVR0RO?=
 =?utf-8?B?aStJWnUvcnNxWFNSWjNJS3hNQkw4UEwzWm5XMXIrWjIvUnRYSExjckpJeDhE?=
 =?utf-8?B?MUJPMjNuKyswUDUxZjBuaDdzRkNPdnlrMFBPN3hRbitqbUxCZEZuMnVMS1p2?=
 =?utf-8?B?M0FBSndSRWtkazZEL2N5UlM4TmMxSXpqeTNrMGhXYnNJQVdLR2ZBcWdEdzRa?=
 =?utf-8?B?cnlWck5mNjdOQjBEaXJteTZjOVZMUHJPMzF5Umd2N1pabklHOWhWbzlTWmlN?=
 =?utf-8?B?S2J2YUswYWhFaHY2aVhkUEtiYlgvdzMvcGRKSXRDMmlxRm1kc1JYZWZuZDVM?=
 =?utf-8?B?ZFZUQUNBdkh1dEp2Y1pSWVdqMlc4TVpoVTk0MVdlcDJkeENhTHAwVUdJbmw2?=
 =?utf-8?B?WkRETldrelBvTWZpMjM5SXRRbGFSUy9WeUZZbjFZbi8rUUdvVk9EczZWR0pa?=
 =?utf-8?B?Wm8yTlhDZTh5YUx5aUc4ZzlHeFdnWnhjY0hrS1lmMmEydDBLMHFCdGV2cnhB?=
 =?utf-8?Q?nzd2LmmiAOVgWpa0lSrUzY/92?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <313E23AF9C696C4E819C15DE5EDA19D1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8beab18-037a-4bef-8f77-08db8cc26387
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2023 03:51:12.4103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hvld1vGdhSkoTa1W+Q4mjNqB2Qud0k9ZIb9UjOerj5LpNetfGxayxHfgsk/RfycNn2jrVOhJrcLOgwfURLtKQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4802
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

T24gRnJpLCAyMDIzLTA3LTIxIGF0IDEzOjE4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBCYWlsIGZyb20gdm14X2VtZXJnZW5jeV9kaXNhYmxlKCkgd2l0aG91dCBwcm9jZXNz
aW5nIHRoZSBsaXN0IG9mIGxvYWRlZA0KPiBWTUNTZXMgaWYgQ1I0LlZNWEU9MCwgaS5lLiBpZiB0
aGUgQ1BVIGNhbid0IGJlIHBvc3QtVk1YT04uICBJdCBzaG91bGQgYmUNCj4gaW1wb3NzaWJsZSBm
b3IgdGhlIGxpc3QgdG8gaGF2ZSBlbnRyaWVzIGlmIFZNWCBpcyBhbHJlYWR5IGRpc2FibGVkLCBh
bmQNCj4gZXZlbiBpZiB0aGF0IGludmFyaWFudCBkb2Vzbid0IGhvbGQsIFZNQ0xFQVIgd2lsbCAj
VUQgYW55d2F5cywgaS5lLg0KPiBwcm9jZXNzaW5nIHRoZSBsaXN0IGlzIHBvaW50bGVzcyBldmVu
IGlmIGl0IHNvbWVob3cgaXNuJ3QgZW1wdHkuDQo+IA0KPiBBc3N1bWluZyBubyBleGlzdGluZyBL
Vk0gYnVncywgdGhpcyBzaG91bGQgYmUgYSBnbG9yaWZpZWQgbm9wLiAgVGhlDQo+IHByaW1hcnkg
bW90aXZhdGlvbiBmb3IgdGhlIGNoYW5nZSBpcyB0byBhdm9pZCBoYXZpbmcgY29kZSB0aGF0IGxv
b2tzIGxpa2UNCj4gaXQgZG9lcyBWTUNMRUFSLCBidXQgdGhlbiBza2lwcyBWTVhPTiwgd2hpY2gg
aXMgbm9uc2Vuc2ljYWwuDQo+IA0KPiBTdWdnZXN0ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5n
QGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbmpj
QGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC92bXguYyB8IDEyICsrKysr
KysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2
L2t2bS92bXgvdm14LmMNCj4gaW5kZXggNWQyMTkzMTg0MmE1Li4wZWY1ZWRlOWNiN2MgMTAwNjQ0
DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3Zt
eC92bXguYw0KPiBAQCAtNzczLDEyICs3NzMsMjAgQEAgc3RhdGljIHZvaWQgdm14X2VtZXJnZW5j
eV9kaXNhYmxlKHZvaWQpDQo+ICANCj4gIAlrdm1fcmVib290aW5nID0gdHJ1ZTsNCj4gIA0KPiAr
CS8qDQo+ICsJICogTm90ZSwgQ1I0LlZNWEUgY2FuIGJlIF9jbGVhcmVkXyBpbiBOTUkgY29udGV4
dCwgYnV0IGl0IGNhbiBvbmx5IGJlDQo+ICsJICogc2V0IGluIHRhc2sgY29udGV4dC4gIElmIHRo
aXMgcmFjZXMgd2l0aCBWTVggaXMgZGlzYWJsZWQgYnkgYW4gTk1JLA0KPiArCSAqIFZNQ0xFQVIg
YW5kIFZNWE9GRiBtYXkgI1VELCBidXQgS1ZNIHdpbGwgZWF0IHRob3NlIGZhdWx0cyBkdWUgdG8N
Cj4gKwkgKiBrdm1fcmVib290aW5nIHNldC4NCj4gKwkgKi8NCg0KSSBhbSBub3QgcXVpdGUgZm9s
bG93aW5nIHRoaXMgY29tbWVudC4gIElJVUMgdGhpcyBjb2RlIHBhdGggaXMgb25seSBjYWxsZWQg
ZnJvbQ0KTk1JIGNvbnRleHQgaW4gY2FzZSBvZiBlbWVyZ2VuY3kgVk1YIGRpc2FibGUuICBIb3cg
Y2FuIGl0IHJhY2Ugd2l0aCAiVk1YIGlzDQpkaXNhYmxlZCBieSBhbiBOTUkiPyAgSXQgc2hvdWxk
IGJlIHRoZSBub3JtYWwgdm14X2hhcmR3YXJlX2Rpc2FibGUoKSBtYXkgcmFjZQ0Kd2l0aCBOTUks
IGJ1dCBub3QgdGhpcyBvbmU/DQoNCj4gKwlpZiAoIShfX3JlYWRfY3I0KCkgJiBYODZfQ1I0X1ZN
WEUpKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KHYsICZwZXJf
Y3B1KGxvYWRlZF92bWNzc19vbl9jcHUsIGNwdSksDQo+ICAJCQkgICAgbG9hZGVkX3ZtY3NzX29u
X2NwdV9saW5rKQ0KPiAgCQl2bWNzX2NsZWFyKHYtPnZtY3MpOw0KPiAgDQo+IC0JaWYgKF9fcmVh
ZF9jcjQoKSAmIFg4Nl9DUjRfVk1YRSkNCj4gLQkJa3ZtX2NwdV92bXhvZmYoKTsNCj4gKwlrdm1f
Y3B1X3ZteG9mZigpOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgdm9pZCBfX2xvYWRlZF92bWNzX2Ns
ZWFyKHZvaWQgKmFyZykNCg0KQW55d2F5LCB0aGUgYWN0dWFsIGNvZGUgY2hhbmdlIExHVE06DQoN
ClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCg0K
