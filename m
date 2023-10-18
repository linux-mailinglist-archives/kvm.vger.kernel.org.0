Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC2B7CD74D
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 10:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjJRI6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 04:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjJRI56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 04:57:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48681C6;
        Wed, 18 Oct 2023 01:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697619463; x=1729155463;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=viHR8v2jSf7skZjup89USpWdzRutJcwu7TzsAzo/MQA=;
  b=PiHQEYhuvLArB1Ga8W/CwJ+ygrZ7qc41QMX587DVwwXeM0Vt8YLN+Ff/
   IeujDVQRLSD9dam5v8QFm+Qhhm1UM9vcsjaSC7b2l+cuoKarByCZAsJJD
   StgNdyLZJpSMW9eCU6EDIKjIQtiXZtSo8tacHfTN8dl0yxcC+YM/z/UII
   d9jB0hOWGux2k55KsrWoxpUUJ2g0fb1XxtcT7b+9WSx2TIHa67hC70gKE
   erxqeUyJgN8l5jj6TeAdLRJS9l1gOlmF7IiavHlQArMq5bSUvbm0mo1ao
   HyN2kkWU+9YuvU74f5uYQF5C/M9zjhirbRfUFI6SCvYWFVEMqtMMsb/KQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="450191711"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="450191711"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 01:57:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="4271482"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2023 01:56:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 01:57:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 01:57:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 18 Oct 2023 01:57:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 18 Oct 2023 01:57:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuylbXUs7QSv2OMBPTIViPkBIXtn5dwbormTs0QqgPpugrKQgDnbRQXXHN828Yk74NZ3junpFhKQ1ComAmP0vzxRqTHj0UsMR0VpywX5vMY9R0set3jrlLH9yG6UVjKgee374vqT+kvU5asq1i77ticyqDBVzhsZJjm/YcXNvvScwehJ8mzsP+sJJKojCy3pcls5FUs18f3p9llZXxJgjo7TT6eb0kXGmDFUeBrKw3Y/LcsX0NvG4q0iz3bZJjEB65VDW3QGykp5qhKq8nCwvTC8MNfw2F3TwzZGHWwLGqFJ9wgaaEgZk3tQuV3W6tHh61xth2fTcSpYnZz+hUOAyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=viHR8v2jSf7skZjup89USpWdzRutJcwu7TzsAzo/MQA=;
 b=Yj0gMLLUmasfY6h5z0fqppjyUePv1Qna4pYwk2VPC8Me5JQCECKhefrBUBRiR/G/AGxQLaQCWhisfWH5vtEE1NWiY+UeUZNc650M5NefTzkFenpUw9ttlcvfETad0d8OPi+lUCX2h1bJQhqNgRb4nPLzl5KTc+rU/76VFnUQyoHBpHZoRrdhwkEugadCnjsxBBZJpFmiC6VL85SZBkdeXuN0DNU++kTmZAWNOhCDdeGdeCfqEb3nyt4YWjHNdyOfn+Xu77DOngFPN1PrJ9uXLilsDkTz7aD88w3LatM3rrUvFaFfMjlnCR9h6komJu9hD6QpjUFsZeDtO+GepFfiCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB6987.namprd11.prod.outlook.com (2603:10b6:930:55::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Wed, 18 Oct
 2023 08:57:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 08:57:32 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHaAN//ldkr1S527EC3GXo/nVXwQ7BPL8MAgAAI4wCAAAK/AIAABRsA
Date:   Wed, 18 Oct 2023 08:57:32 +0000
Message-ID: <b8630bf49e0aa0cb337e626ae6e116e26862d9f2.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
         <ea983252-0219-46a7-99be-5a8d22049fd6@suse.com>
         <a0389bcb3fa4cd1f02bff94090f302b87d98a2e3.camel@intel.com>
         <5fca35af-b390-46d1-b5ab-9312fa740599@suse.com>
In-Reply-To: <5fca35af-b390-46d1-b5ab-9312fa740599@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB6987:EE_
x-ms-office365-filtering-correlation-id: c5c44ce3-7fdf-42b1-4d5c-08dbcfb84426
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cPNNVNZKBrvHN4ZmoyGS3pm1FmN1vcOHPwAxbSqtAhT+0wP6DlQ2omsUEEVw9WopNcIkNIVjp0BlrQVogXhEQKTOJG4wA4ZvZu3azhSUN6uKcfYdMTSiUUYGRBaVJuW0JYbb1oYICqcjRx84hWeASpe0qeClEsGgaGyF2+hJ/kCe8EHcjV1bcJ0GPoY/1kNxYedvJ/xcU05BuxxXqiWUmKFVkDqN6nxetoP9BCOpHFhCjPNQv/cImCZ1iVPT2nRntgKcSW51rW+nLuFBNrfNtJgmG4zlfefh8k9v6EYXXXQju22YPRCI3IfkDJJlu9+W+qwS/i96U7Zm1WQ4XFD1icZ3irXZdc8QFzn4pp7wIAOCWY2LV7DA25JqnvC0E1qzqydXkCS3q6vOcePYXZX1V52pQKBmIaY76ylh9in6hTjq+XrFCOr5hk89/miR/D0Qz7f0x6Fz4sMUmUuu9hUf7HhNCyYJoK+8YdtX0TWL/62SjHX3t6z+cti1d23MwUrrYQfCzBrFMPYu2PKYeeDxAbtWujdvOxaxTzTPg5hkFjDeUnlyZ4rK8u09nIWj7uETjs4y+a4WHpcH9WWOEtUgkMYkk88U8VBlVbGUVHHrHUZmXk4PZoua1U6z4Suo+wSH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(136003)(39860400002)(376002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(26005)(110136005)(6486002)(36756003)(122000001)(38100700002)(83380400001)(316002)(38070700005)(71200400001)(76116006)(6506007)(2616005)(64756008)(66556008)(66446008)(91956017)(82960400001)(54906003)(4001150100001)(66476007)(66946007)(478600001)(86362001)(7416002)(41300700001)(4326008)(8676002)(2906002)(6512007)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3phaGlkRTlmbWtLOVU1ODNlTW9zTkNKVmFFN29jRkx6U1M2cnlIdFZ6SjBI?=
 =?utf-8?B?VjVWRHVzV0ViZ0NUblBnSDB0Q0lFY25tLzZwdjlxMjlTNU9EdkZNakd3OW5o?=
 =?utf-8?B?U1BZR3k1RnVXdEp3b2toRUp4UW80QVJENE9acUw3NzBYQzNpdEhCQmR5MHB3?=
 =?utf-8?B?blNoWXhzSmpycWdHVkdSZEYweXVzOE1CdXhJZVZSekprTWF5bTNIN21uSFcx?=
 =?utf-8?B?R1dLNjJHMXJEVVBhUmtBbk4ybkJJUmNmUXRVWnV4eDAvZi9maEMvTmhXbHJC?=
 =?utf-8?B?b1dxd3RYUjFpK01LQ1VYQWJqZjc2OVY1YmZpUlVZZTZ0VUZVWFdGZFA5ZkJI?=
 =?utf-8?B?Z2lSQWdoVGNVa3RHZmFtbTRNRC9pT0ZBRklpR2x4SGJVcUhWNjlsMi93M2lU?=
 =?utf-8?B?VGlvWXRzUEZ0Ui9hRHlOZlFCdlA5YlNXUGJ3S3BBSC93RjBoRXJ6QmdPQ3g1?=
 =?utf-8?B?eDhXck1HMmRJYVdjSEh4Z01KQUhlOUl4S1ovTmw4NHk1TmxqVVdjaUdCcWow?=
 =?utf-8?B?MG1zdUZ2a1J2dHpZYmtaWWFvVmYvTlBWT3M1QzVtbGJyWGdERkJFZGh2Y2pJ?=
 =?utf-8?B?UHNMZmg5SXBYQUVEdkZCNk5HeWE2QktyUWdVa3ZGdlB3a3BVcmRpTVk5U0dI?=
 =?utf-8?B?QW8vbEJxa3Q4RnlNM2dxQmJOVkNLNCt0NFg1Vkw1eWJwa2ovVW51MGs1WDFI?=
 =?utf-8?B?b2ttbHlDcTk4UFZDVGIyTmJTQUN3L1YzazFoajJ0NnFtRkgvb3NtTFgvaUlp?=
 =?utf-8?B?OTRaOFh3S2h4clpzVk1PcCtTZ3NBVUJuU0xDc0Z1Z0N6VlV1ZmpESG1FSHc5?=
 =?utf-8?B?cUM1QzViR09VVEJiOWZuOGR4ZGM2ZkI3aWlaeWF1QXlDNStzRkFVdUVtcEFE?=
 =?utf-8?B?OE5wREUxVHVNaVZXNTJMK29LM2dwa1JhTEl5ajMwbGlyQ0hlLzZoQU1zK2NR?=
 =?utf-8?B?Q0NsTVoxd3R3RHM3YnV2eHdIUE81UEpkQm1iUDNlZUttNndsZjBjTmw0bzNm?=
 =?utf-8?B?dDVYd1JVZEUwdFFZY0o0SHBxSHdVNHdwNEFlV1ZnUmcyWXVyci8zelM2dE1j?=
 =?utf-8?B?eDNic0VZaitFQzdLSEgwUnJRT2V2a1cwSEJQNi8rMEFUMlAyUWh0Y3dneXV2?=
 =?utf-8?B?R3lpczg4MlFmVi9ueEJFUFZDMGJRNWc5VDloMGFoTitXeDlsQWJUYmR1RW5x?=
 =?utf-8?B?TURzc2NYKzJ4V2oxYnMxMWhwaER3Nm9Fd2o1VktQUExmanNuUFFMNnRvNmJC?=
 =?utf-8?B?MHpKUzU5Z0pNSjBiN2lPSjh3U3p0clhXUVN3OE9tT1MyZHRIV1hHY1lvM1VP?=
 =?utf-8?B?UkNuMGxpT0xiblYyZE9BN1laS3RON0gvdGdrckpEcVpwSnFCM0NaUm04ZXpl?=
 =?utf-8?B?UWJtMkYvb1BmN2h1bEZ1cFhvQWlSRkI3Z09OS1Izckd4aGpKbFAvc2Z1ZW5W?=
 =?utf-8?B?elVKOXJOZzFtdGpKcFFIL1R6WHlaTkR1SUNBZ0gxV05CQ2NmYWh3TGUwVzJM?=
 =?utf-8?B?QXFKdTcyVllPbVU1M2RuS2RKM1pyOVY4NHRxeHl6Zko4S3oySmxLSS9oRk41?=
 =?utf-8?B?S2d3OTNlb1lOa3d6WWJRRE1oMkVPMHYzMFhtdWVPcTF3S0JUdVNjT3Azc3Rv?=
 =?utf-8?B?KzNDS1BCOVdDbzBhY0VTZ2ZVK3Vuek9sVGdQT0tIN2J0SGFtMHBlSm9WOUxV?=
 =?utf-8?B?ZmZQUi9NZ1FsNFIxNFVBaHRJa1pkaUxMZ3ZLQ1VvVHFwa0p0ZVF3dm9ubzl2?=
 =?utf-8?B?TGlGWDRiQkNDV3VxcVZQUGJnaTlNRWJad1BYVG80cEVySlRmWkZ5ZXF3cWVE?=
 =?utf-8?B?Y215R1M3L2dlZEw0ZlNCSGFHa2R5bUs5M25rL1YwdVAvaStOV1J3MEdXcVlU?=
 =?utf-8?B?R3pZK003OWwyWmN6ZnljUGNrVU1pREJsM21RVkcxNGg2ODlFYWtucGhMUUgz?=
 =?utf-8?B?ZkgvZ3RuQ3JISWJObmlSZDNzNFlWcUIya28vRENRUTFIdkdlZDdvQW5HL0U4?=
 =?utf-8?B?MUVaUG5wQ1oxTnVrK016ZXRDMHNkdW1vQm1zVVpVSFc5ZTR4Tjh4OC92ZFhm?=
 =?utf-8?B?V3BYVWNMUUhsemFNSnBuVHd2MG1kNjNHUEFaM0pQUUhETlBCelZlY3g0MHJ0?=
 =?utf-8?B?bGJkUGRiWkN5MXMwWThFS3U1Vk13UWdpV0Z0UFlSdWllUjJvYTZ5UllHVlNV?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABAC850BD7D7354486D021F409256437@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c44ce3-7fdf-42b1-4d5c-08dbcfb84426
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 08:57:32.7108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjlLlU7p6Cl6QV3xNsCCJsi3YwSE9HEnLkbi+ta9RfKjQqh2tJjtNaaLmEpntwDqfjlsCIjHrsx7ueHZ/YmgXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6987
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTEwLTE4IGF0IDExOjM5ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxOC4xMC4yMyDQsy4gMTE6Mjkg0YcuLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICAgDQo+ID4gPiA+ICsvKg0KPiA+ID4gPiArICogRG8gdGhlIG1vZHVsZSBnbG9iYWwgaW5pdGlh
bGl6YXRpb24gb25jZSBhbmQgcmV0dXJuIGl0cyByZXN1bHQuDQo+ID4gPiA+ICsgKiBJdCBjYW4g
YmUgZG9uZSBvbiBhbnkgY3B1LiAgSXQncyBhbHdheXMgY2FsbGVkIHdpdGggaW50ZXJydXB0cw0K
PiA+ID4gPiArICogZGlzYWJsZWQuDQo+ID4gPiA+ICsgKi8NCj4gPiA+ID4gK3N0YXRpYyBpbnQg
dHJ5X2luaXRfbW9kdWxlX2dsb2JhbCh2b2lkKQ0KPiA+ID4gPiArew0KPiA+ID4gDQo+ID4gPiBB
bnkgcGFydGljdWxhciByZWFzb24gd2h5IHRoaXMgZnVuY3Rpb24gaXMgbm90IGNhbGxlZCBmcm9t
IHRoZSB0ZHgNCj4gPiA+IG1vZHVsZSdzIHRkeF9pbml0P8KgSXQncyBnbG9iYWwgYW5kIG11c3Qg
YmUgY2FsbGVkIG9uY2Ugd2hlbiB0aGUgbW9kdWxlDQo+ID4gPiBpcyBpbml0aWFsaXNlZC4gU3Vi
c2VxdWVudGx5IGt2bSB3aGljaCBpcyBzdXBwb3NlZCB0byBjYWxsDQo+ID4gPiB0ZHhfY3B1X2Vu
YWJsZSgpIG11c3QgYmUgc2VxdWVuY2VkIF9hZnRlcl8gdGR4IHdoaWNoIHNob3VsZG4ndCBiZSB0
aGF0DQo+ID4gPiBoYXJkLCBubz8gVGhpcyB3aWxsIGVsaW1pbmF0ZSB0aGUgc3BpbmxvY2sgYXMg
d2VsbC4NCj4gPiA+IA0KPiA+IA0KPiA+IERvIHlvdSBtZWFuIGVhcmx5X2luaXRjYWxsKHRkeF9p
bml0KT8NCj4gPiANCj4gPiBCZWNhdXNlIGl0IHJlcXVpcmVzIFZNWE9OIGJlaW5nIGRvbmUgdG8g
ZG8gU0VBTUNBTEwuICBGb3Igbm93IG9ubHkgS1ZNIGRvZXMNCj4gPiBWTVhPTi4NCj4gPiANCj4g
DQo+IFJpZ2h0LCB0aGVuIHdvdWxkIGl0IG5vdCBtYWtlIG1vcmUgc2Vuc2UgdG9vIGhhdmUgdGhp
cyBjb2RlIGFzIHBhcnQgb2YgDQo+IHRoZSBLVk0gYnJpbmd1cCBvZiBURFguIEluIGZhY3QgYnkg
a2VlcGluZyB0aGUgMiBzZXJpZXMgc2VwYXJhdGUgeW91IA0KPiBtaWdodCBiZSBhZGRpbmcgY29t
cGxleGl0eS4gV2hhdCBpcyB0aGUgaW5pdGlhbCBtb3RpdmF0aW9uIHRvIGtlZXAgdGhvc2UgDQo+
IHBhdGNoZXMgb3V0IG9mIHRoZSBLVk0gdGR4IGhvc3Qgc2VyaWVzIHN1cHBvcnQ/DQoNCkEgc2lt
cGxlIGFuc3dlciBpcywgZm9yIG5vdyBvbmx5IEtWTSB1c2VzIHRoaXMgc2VyaWVzLCBidXQgbGF0
ZXIgb3RoZXIga2VybmVsDQpjb21wb25lbnRzIHN1Y2ggYXMgSU9NTVUgd2lsbCBuZWVkIHRvIHVz
ZSB0aGlzIHNlcmllcyB0b28sIHNvIHRoZSBjb3JlLWtlcm5lbCBpcw0KdGhlIHJpZ2h0IHBsYWNl
IHRvIGZpdC4NCg0KQW5vdGhlciBwcmFjdGljYWwgcmVhc29uIGlzLCBhbHRob3VnaCBmb3Igbm93
IEtWTSBpcyB0aGUgb25seSB1c2VyLCBidXQgdGhlDQplZmZlY3Qgb2YgZW5hYmxpbmcgVERYIG1v
ZHVsZSBpcyBzeXN0ZW0gd2lkZSwgYmVjYXVzZSBvbmNlIFREWCBtb2R1bGUgaXMNCmluaXRpYWxp
emVkLCBpdCBzdGF5cyB0aGVyZSBubyBtYXR0ZXIgS1ZNIGlzIHN0aWxsIHByZXNlbnQgb3Igbm90
IChLVk0gY2FuDQplbmFibGUgVERYIGFuZCB0aGVuIHVubG9hZGVkIHBlcm1hbmVudGx5KS4NCg0K
Rm9yIGluc3RhbmNlLCBrZXhlYygpIGFuZCAjTUMgaGFuZGxlciBuZWVkcyBhZGRpdGlvbmFsIGhh
bmRsaW5nIHdoZW4gVERYIGdldHMNCmVuYWJsZWQuICBJZiB3ZSBjb21wbGV0ZWx5IG1haW50YWlu
IHRoaXMgc2VyaWVzIGluIEtWTSwgdGhlbiBhZnRlciBLVk0gaXMNCnVubG9hZGVkIHdlIHdpbGwg
bG9zZSBzb21lIGVzc2VudGlhbCBpbmZvcm1hdGlvbiB0byBkbyB0aGVzZSBzeXN0ZW0td2lkZSB0
aGluZ3MuDQo=
