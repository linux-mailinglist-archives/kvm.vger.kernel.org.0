Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85A462B9DD
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 11:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbiKPKp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 05:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238893AbiKPKpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 05:45:00 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35174093D;
        Wed, 16 Nov 2022 02:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668594773; x=1700130773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OAdVK63cQTab9fdFTKeaFG5DipI1leZcjBED4YJW8Ko=;
  b=QX9QKaQuP5XZMxxdXasvxrJU15FjGZz3Wj3Eaf7uTf+3qgYu+ZEoEC6V
   1kg2PjFDdCa0b3CtBTXGo/rOnzgvW8AXtF0no+NNJ0GGn8CpfqXpSm2+V
   pWOVVJ8NuhtjpRM7yYEQS4nlYTG+RRM0C0fvBeXTH0JWImQJeKaO08e7M
   rDE1EjS37s4Dt8Lt0xRoL4fvwrhYUA+RkmgmlzX4yS9gSPGUbkUywBHXb
   RDfy9hMjSaYJjZ3VPZ3m4/TW7IBchA4e5KDb2ENsAtTTCke+RKKeCjx84
   b1hXAirWtyldlbqAiPLOewumpActYl++1OMR683QhelqmqweBv28EfgXs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="292218040"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="292218040"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 02:32:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="968372380"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="968372380"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 16 Nov 2022 02:32:52 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 02:32:52 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 02:32:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 02:32:51 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 02:32:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXkXs2VaWnTcP3QlxDIyqaTaoh9tQ9eaxv/2f8zlM0DPHZIHvJHxJWCe9uhavJroRlTvn+4//02FMaXMN8RIthTYJu/vOl7g0J1DdXCwKBEsUodRWVSI5GO9XcGfk8BJPt6M/h0SRBU37y52aCyWmD41d1/Hz3gsRQGO33RMQgOJMwrjdaNhNFErl87lqxHKgsNTRQ1iwquf6TLzjpMWlXrcMg9gugWeu8nMK312vf90b7lH5Sn5lqzBL2nWBu65TZgCctJXIMdB7ohS+yEsfz/0H01cRDEsQj/DYCC9xZu8LD9tFD4MF79dwThcjXayFMgoJKLanuU/N2Vh3f/cLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAdVK63cQTab9fdFTKeaFG5DipI1leZcjBED4YJW8Ko=;
 b=JfKU3EtMV4mD5RY/e2qoC1/RCAemahcciUV04tGxAw1C/FTanaDmG9ke1rprBN15/Hw7UtcuS5xU35Or2Kqi/W9ZnGDHnzh0KSHWRTbCuAAo33ehbAteSsMdygPVyEgPiIbJE7hpBDdLfWtnurTJnbpEclbSRlAVWw9PcBHd6h1c/PdJpaB4U1SPQQ+9IKPX6SRs9QyifaNsYEPQNyE41S5OFRLZlh8hJFtDTbf4WpzGPZdQzkM7HeXrlBZLO2Vz20KVkO5zJwXajcrf9oPFj71Qmzh6yyDYlObeI4coAax37Z1KHqI8d1EllpccqIYUcVDifWBVCOWpJ8TvzOEcRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5432.namprd11.prod.outlook.com (2603:10b6:208:319::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 10:32:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 10:32:49 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 045/108] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Thread-Topic: [PATCH v10 045/108] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Thread-Index: AQHY7CiLoJddw42+PkiEvfawWtRD9q5BdTcA
Date:   Wed, 16 Nov 2022 10:32:49 +0000
Message-ID: <00fc2a80784f9e007cffa9790c3dbd3109c3bec6.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <f2e0790612bb86bf1ebc2d5f5d94d72cc28dd1fd.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <f2e0790612bb86bf1ebc2d5f5d94d72cc28dd1fd.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5432:EE_
x-ms-office365-filtering-correlation-id: 8e3e381d-67f9-45cc-4c9f-08dac7bde8b2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WtagPbVc1hPdksPF8lh5X1jZm/36MPdeJUYGEyS2Ycj3Upd7JzKqYkmTg9aOzgAPAHiRLJKUt3LyjyDkB2zfiHcGoD+s9Qzt2REScXtWoxkWl3zZAoUbQfrIDWNwZ9ZEYs8IJImjUBbQD0s/V7jZCh1KtKnJXb+l3QGqQ811095zhJny7Mo7v8cmXtEOdPxPz4FL0Jqcyy+kZr+7QmAODQUOhvFxk0btIA5u4Xb5ulW0+gOmg8Aj6WuN8GycvCtokxNA7nPN75BAi7aRA/+scHBEW2vkKWLGjUHlFzmvPEE6ljyXB1GHsRqfX/A+ZX72LzdLeVCdC0qHFU5qNhvwISXwrpK+wNAwmt2sPm0G+VA1YsEkewzLQdOw9gGo4dNzikxd+nGBt0BV6aDTYBICoxeEychIgNPm0+jlrFfh0fkXr1p1ti4dTnczEWZAZ+fbvML2TTEpat0P2/ddqchBQc/n0z63TP2nJUFW0apkLKNUwuGV6BrHTKDQZ4LHV8mNJW5IWIF1sIh5uweLNzlvqLSrKFCwEJub+BeZdNvbqslKnpPj2UgkofjtBV2V8rC4GsWdw00k0t9lqxRiyRJ6TAynJASpIaj34BoYtrQP7o+c3NJrb2AFsvICSuZ/MqX8lOQTjnEXNL+NjaRLes/vmSWYbQd2FUbDnk1+vSVvT+0ZrCEKod5v3epo6yeE2xVtdNb6ESXBBqyWKvW53ihBrAG70gITWM57IgX4QgdqiHCCPQI/KXMyiqiHYllyGM26QGs32bhkUo65EGdXu8PwIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199015)(83380400001)(86362001)(82960400001)(122000001)(38100700002)(38070700005)(478600001)(71200400001)(6486002)(6506007)(66446008)(66946007)(66556008)(8676002)(76116006)(66476007)(91956017)(4326008)(64756008)(110136005)(316002)(6636002)(54906003)(2616005)(186003)(41300700001)(26005)(6512007)(8936002)(5660300002)(4001150100001)(36756003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azRMVG01WkpzeDdLT0g5VTRMWlp4c2c5TThTN1BhbWltQmkxZlRaUmhjTlJv?=
 =?utf-8?B?RCtmWmZHdkczeHdtbUVwbmMzN0cwQnBsTlBKUVMwYlpkSXhramZVZy9JbUlq?=
 =?utf-8?B?RmtIelMvOTlUWG5rNlYrVnovV2FseDhMNTg1cnN6eTBrY1Zjd2hQWk04emxT?=
 =?utf-8?B?WTZ1Ni9XZ1o3aythYWptTHV1b3N0eVRNVWMyMVY1aHFBaW1zeWpkRkhSYTMz?=
 =?utf-8?B?Z0J0Um1ySjVzR0xHNDNwMnNzMFFtOVRQQkZaVTV2Yk02R3VEMDVPSjlrZEpo?=
 =?utf-8?B?ckJGOS9MM1BPdkZNaGZ3RkRBYjR5ZHlmdnYyVFVrc3lrWnpJbExFUEVvUUQz?=
 =?utf-8?B?dVFTb2tSTURqVFZ4NDNnT0dZMytjVjM0dDA3Y01xaDBhc3J0OEZGS05jR01G?=
 =?utf-8?B?S2U5N1psTS90TThYTjJQc0xieGErUFRaL2RDZS9tYkZlYndIR3FrRCtnYkxw?=
 =?utf-8?B?VGVBc2dxdnBDZ25qMWpiT0FTeHFycnBqcmRYa1psTjVGWlBNL2ExazBub1l2?=
 =?utf-8?B?ZlJmWllsV3phWi9TeDlLMmMwRFgvTElreGplbGNiNWNWODY5VTRYYm9qckQ5?=
 =?utf-8?B?c1JrcVd3VWptS0NlWkQxYVhGNFIwOEUraXdCTjdWTW9mcHFpaFRNZERVdVpW?=
 =?utf-8?B?am1qRFh0dC9FUEhIdlZoOTB5eEJxYXhMa25mellJWFBwbDc2YVZQZGlMSk83?=
 =?utf-8?B?dCs1YUtKRzZMb1kvTUV2N2lOT2lCbUU4WnV4a3BVTXVQQUNSSUYwVGZ2RUY3?=
 =?utf-8?B?dXcwc2ZIZ2dtSFhjWVRwT2tUUjA2WDdqL3RiMVVJL2ltVE5rcDUvZE5DU3FT?=
 =?utf-8?B?Ung3aVpKT3Q3ZDVPbjVLdmFKNzlFVG9WNENpTW1naWhtYzdzQXk5WGlyVi9i?=
 =?utf-8?B?cCs3Y0I0TnJ1VzNPeXNVcTRNRHpsay94ZUluOXZjR3dCN25HaStEbURlMkF2?=
 =?utf-8?B?a3RTRW5FdEtzMGZYbHc1ZlhJTnZhSzc1QXZQblJjZW5iY2NHa3hTQTYxS3BS?=
 =?utf-8?B?S0d0RzFvbTVrY29BNWtGamtJQVd0WDYzTSsyMDJXZUZ6ckZzaXJQdjRNTWRr?=
 =?utf-8?B?Z05kd2g0M3ZLWDk3MEZ4YXpEMzBmY1p6VVh1bDVQMDJRM3lEbXZJZXFYak1C?=
 =?utf-8?B?RThidFQyNmJtWDNsRWFKYzhSSk00Si9wNUVBU0NIZFVTQjRxb3ZoQTNuWlVW?=
 =?utf-8?B?aGxuL0EvQXB4bDVnV1NKVjA4MEpHZWZISWxaR25ybzhzSkpNZDR3WDhzc0V3?=
 =?utf-8?B?cWlUNkZkRzJqWWd1UisyOHFwVU91bDhPNFBlRnJjV20vVjkvQWdlMHJRZTVN?=
 =?utf-8?B?b0VIRnpQcUVHZ1BxNHgxQzJZTmxvbDVOOW1DRHlTYWM5VFBCdlp2M1M2T2Y5?=
 =?utf-8?B?dXJPOFoxZEpCdzQ4dllSNThUcWJ1U0hZWDRvQzBUUzJua0JadHZmcnR2cng2?=
 =?utf-8?B?WlFMYTBrYzJQME90amhKNEJIVFpyRTBHa1VQdGlpNUQ5b2YxYW81c0dERVlR?=
 =?utf-8?B?eWZoRGErcWc0c0hHSUhrTHdCTlhoU1Y5U0ZnOVB6OGVzTXZoTllTeVQwVDVB?=
 =?utf-8?B?Tmw0SEZDWWRZRUlISnZYNUNDRHhjQkFtdDFKUURIWVNzL1dQcU05dTNrd2dr?=
 =?utf-8?B?eDdWMkhRaVJHSWtQT1A1eU1NZ29pNXQ4UmlCRTZRYUVlU2JBNEpBcHdkV0x2?=
 =?utf-8?B?M0k0V3ZiZDRpSFd1Y0dVbnF1OWdvQmRoaDgvWVVBZElTQTJCWHFKbmVHUzFD?=
 =?utf-8?B?d0J6aW1SdWsxYnQzeWdWN0NoemFlN29OWTBFeGllblc3bXFBRzgxcUlTUGtR?=
 =?utf-8?B?RllqUjN2OUt4R0IvcFA0dmhPUlpJRWxxdUgyR281VEkySFVvcDV6cUs0RFJY?=
 =?utf-8?B?SUV4UmJ3UjdMWGx5bEdRRUFlNTZjMFNLcUVrQU5JL0JZdGtjUEY0NHNtTXpG?=
 =?utf-8?B?UFMyamFpeitBVWpLQ3J4VmszbktlamZkOEhZS1BoZXdGNXowaEhHZUJYbnA2?=
 =?utf-8?B?NWE3U3ZMSmdVRzUvbTRPTGxDQWY0NU41WFpWdEl5OEFDZ3dlOHhZUjY4V1Bk?=
 =?utf-8?B?Vk1OaDhRUy9lcGdyU3N0Y0sxbmpLc2ttSU5IYXZOakRhbEplb09uWGY5ZlZZ?=
 =?utf-8?B?dDVNY09scTEwM1psTG4xbjZTVVIvUzV5SUJOT3VQdFQ3bDlsendhOWZ1cjV2?=
 =?utf-8?B?elE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B7E3A4B99B53C46BB92DE6DEAF6E29E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3e381d-67f9-45cc-4c9f-08dac7bde8b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 10:32:49.2779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bU/CwGUjEd0sbbcRWJYRXBZVRrV3CN1d9VOOat7EBmJeBRVMRnomVE4xoo0VYhTs3DqY9VT+wIOVM0ePo6/54A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5432
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBGb3IgcHJpdmF0ZSBHUEEsIENQVSByZWZlcnMgYSBwcml2YXRlIHBhZ2UgdGFi
bGUgd2hvc2UgY29udGVudHMgYXJlDQo+IGVuY3J5cHRlZC4gIFRoZSBkZWRpY2F0ZWQgQVBJcyB0
byBvcGVyYXRlIG9uIGl0IChlLmcuIHVwZGF0aW5nL3JlYWRpbmcgaXRzDQo+IFBURSBlbnRyeSkg
YXJlIHVzZWQgYW5kIHRoZWlyIGNvc3QgaXMgZXhwZW5zaXZlLg0KPiANCj4gV2hlbiBLVk0gcmVz
b2x2ZXMgS1ZNIHBhZ2UgZmF1bHQsIGl0IHdhbGtzIHRoZSBwYWdlIHRhYmxlcy4gIFRvIHJldXNl
IHRoZQ0KPiBleGlzdGluZyBLVk0gTU1VIGNvZGUgYW5kIG1pdGlnYXRlIHRoZSBoZWF2eSBjb3N0
IHRvIGRpcmVjdGx5IHdhbGsNCj4gcHJvdGVjdGVkIChlbmNyeXB0ZWQpIHBhZ2UgdGFibGUsIGFs
bG9jYXRlIG9uZSBtb3JlIHBhZ2UgdG8gY29weSB0aGUNCj4gcHJvdGVjdGVkIHBhZ2UgdGFibGUg
Zm9yIEtWTSBNTVUgY29kZSB0byBkaXJlY3RseSB3YWxrLiAgUmVzb2x2ZSBLVk0gcGFnZQ0KPiBm
YXVsdCB3aXRoIHRoZSBleGlzdGluZyBjb2RlLCBhbmQgZG8gYWRkaXRpb25hbCBvcGVyYXRpb25z
IG5lY2Vzc2FyeSBmb3INCj4gdGhlIHByb3RlY3RlZCBwYWdlIHRhYmxlLiAgVG8gZGlzdGluZ3Vp
c2ggc3VjaCBjYXNlcywgdGhlIGV4aXN0aW5nIEtWTSBwYWdlDQo+IHRhYmxlIGlzIGNhbGxlZCBh
IHNoYXJlZCBwYWdlIHRhYmxlIChpLmUuIG5vdCBhc3NvY2lhdGVkIHdpdGggcHJvdGVjdGVkDQo+
IHBhZ2UgdGFibGUpLCBhbmQgdGhlIHBhZ2UgdGFibGUgd2l0aCBwcm90ZWN0ZWQgcGFnZSB0YWJs
ZSBpcyBjYWxsZWQgYQ0KPiBwcml2YXRlIHBhZ2UgdGFibGUuICBUaGUgcmVsYXRpb25zaGlwIGlz
IGRlcGljdGVkIGJlbG93Lg0KPiANCj4gQWRkIGEgcHJpdmF0ZSBwb2ludGVyIHRvIHN0cnVjdCBr
dm1fbW11X3BhZ2UgZm9yIHByb3RlY3RlZCBwYWdlIHRhYmxlIGFuZA0KPiBhZGQgaGVscGVyIGZ1
bmN0aW9ucyB0byBhbGxvY2F0ZS9pbml0aWFsaXplL2ZyZWUgYSBwcm90ZWN0ZWQgcGFnZSB0YWJs
ZQ0KPiBwYWdlLg0KPiANCj4gICAgICAgICAgICAgICBLVk0gcGFnZSBmYXVsdCAgICAgICAgICAg
ICAgICAgICAgIHwNCj4gICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwNCj4gICAgICAgICAgICAgICAgICAgICAgViAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwNCj4gICAgICAgICAtLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0gICAgICAgICAgICAgICAg
IHwNCj4gICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgIHwN
Cj4gICAgICAgICBWICAgICAgICAgICAgICAgICAgICAgIFYgICAgICAgICAgICAgICAgIHwNCj4g
ICAgICBzaGFyZWQgR1BBICAgICAgICAgICBwcml2YXRlIEdQQSAgICAgICAgICAgIHwNCj4gICAg
ICAgICB8ICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgIHwNCj4gICAgICAg
ICBWICAgICAgICAgICAgICAgICAgICAgIFYgICAgICAgICAgICAgICAgIHwNCj4gICAgIHNoYXJl
ZCBQVCByb290ICAgICAgcHJpdmF0ZSBQVCByb290ICAgICAgICAgIHwgICAgcHJvdGVjdGVkIFBU
IHJvb3QNCj4gICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAg
IHwgICAgICAgICAgIHwNCj4gICAgICAgICBWICAgICAgICAgICAgICAgICAgICAgIFYgICAgICAg
ICAgICAgICAgIHwgICAgICAgICAgIFYNCj4gICAgICBzaGFyZWQgUFQgICAgICAgICAgICBwcml2
YXRlIFBUIC0tLS1wcm9wYWdhdGUtLS0tPiBwcm90ZWN0ZWQgUFQNCj4gICAgICAgICB8ICAgICAg
ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgIHwgICAgICAgICAgIHwNCj4gICAgICAg
ICB8ICAgICAgICAgICAgICAgICAgICAgIFwtLS0tLS0tLS0tLS0tLS0tLSstLS0tLS1cICAgIHwN
Cj4gICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAg
ICB8ICAgIHwNCj4gICAgICAgICBWICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgICAgICBWICAgIFYNCj4gICBzaGFyZWQgZ3Vlc3QgcGFnZSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHwgICAgcHJpdmF0ZSBndWVzdCBwYWdlDQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8DQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIG5vbi1lbmNyeXB0ZWQgbWVtb3J5ICB8ICAgIGVuY3J5cHRlZCBtZW1vcnkNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gUFQ6IHBh
Z2UgdGFibGUNCj4gLSBTaGFyZWQgUFQgaXMgdmlzaWJsZSB0byBLVk0gYW5kIGl0IGlzIHVzZWQg
YnkgQ1BVLg0KPiAtIFByb3RlY3RlZCBQVCBpcyB1c2VkIGJ5IENQVSBidXQgaXQgaXMgaW52aXNp
YmxlIHRvIEtWTS4NCj4gLSBQcml2YXRlIFBUIGlzIHZpc2libGUgdG8gS1ZNIGJ1dCBub3QgdXNl
ZCBieSBDUFUuICBJdCBpcyB1c2VkIHRvDQo+ICAgcHJvcGFnYXRlIFBUIGNoYW5nZSB0byB0aGUg
YWN0dWFsIHByb3RlY3RlZCBQVCB3aGljaCBpcyB1c2VkIGJ5IENQVS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IC0tLQ0K
PiAgYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8ICA3ICsrKw0KPiAgYXJjaC94ODYv
a3ZtL21tdS9tbXUuYyAgICAgICAgICB8ICA4ICsrKw0KPiAgYXJjaC94ODYva3ZtL21tdS9tbXVf
aW50ZXJuYWwuaCB8IDkwICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAgYXJj
aC94ODYva3ZtL21tdS90ZHBfbW11LmMgICAgICB8ICAxICsNCj4gIDQgZmlsZXMgY2hhbmdlZCwg
MTAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9o
b3N0LmgNCj4gaW5kZXggZWUwMWFkZDU3YTZiLi4zODFkZjJjODEzNmQgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaA0KPiBAQCAtNzU0LDYgKzc1NCwxMyBAQCBzdHJ1Y3Qga3ZtX3ZjcHVf
YXJjaCB7DQo+ICAJc3RydWN0IGt2bV9tbXVfbWVtb3J5X2NhY2hlIG1tdV9zaGFkb3dfcGFnZV9j
YWNoZTsNCj4gIAlzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUgbW11X3NoYWRvd2VkX2luZm9f
Y2FjaGU7DQo+ICAJc3RydWN0IGt2bV9tbXVfbWVtb3J5X2NhY2hlIG1tdV9wYWdlX2hlYWRlcl9j
YWNoZTsNCj4gKwkvKg0KPiArCSAqIFRoaXMgY2FjaGUgaXMgdG8gYWxsb2NhdGUgcHJpdmF0ZSBw
YWdlIHRhYmxlLiBFLmcuICBTZWN1cmUtRVBUIHVzZWQNCj4gKwkgKiBieSB0aGUgVERYIG1vZHVs
ZS4gIEJlY2F1c2UgdGhlIFREWCBtb2R1bGUgZG9lc24ndCB0cnVzdCBWTU0gYW5kDQo+ICsJICog
aW5pdGlhbGl6ZXMgdGhlIHBhZ2VzIGl0c2VsZiwgS1ZNIGRvZXNuJ3QgaW5pdGlhbGl6ZSB0aGVt
LiAgQWxsb2NhdGUNCj4gKwkgKiBwYWdlcyB3aXRoIGdhcmJhZ2UgYW5kIGdpdmUgdGhlbSB0byB0
aGUgVERYIG1vZHVsZS4NCj4gKwkgKi8NCg0KUGVyaGFwcyBwdXQgIkJlY2F1c2UgLi4uIiBwYXJ0
IHRvIGt2bV9tbXVfY3JlYXRlKCkgc28gcGVvcGxlIGNhbiBzZWUgd2h5IHRoZXJlJ3MNCm5vIGlu
aXRpYWxpemF0aW9uIGZvciBtbXVfcHJpdmF0ZV9zcHRlX2NhY2hlPw0KDQo+ICsJc3RydWN0IGt2
bV9tbXVfbWVtb3J5X2NhY2hlIG1tdV9wcml2YXRlX3NwdF9jYWNoZTsNCg0KTml0Og0KDQpJbiBj
aGFuZ2Vsb2cgeW91IG1lbnRpb25lZCB0aGUgcGFnZSB0YWJsZSB1c2VkIGJ5IENQVSBpcyBhY3R1
YWxseSAicHJvdGVjdGVkDQpQVCIuICBJSVVDIHRoZSBzcC0+cHJpdmF0ZV9zcHQgeW91IGFsbG9j
YXRlZCBmcm9tIHRoaXMgY2FjaGUgaXMgdGhlIG9uZSB0aGF0IGlzDQphY3R1YWxseSB1c2VkIGJ5
IENQVS4gIFNvIGxvb2tzIHRoZXJlJ3Mgc29tZSBpbmNvbnNpc3RlbmN5IGhlcmUuDQoNCg0KWy4u
Ll0NCg0KDQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgdm9pZCBrdm1fbW11X2FsbG9jX3ByaXZhdGVf
c3B0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gKwkJCQkJICAgICBzdHJ1Y3Qga3ZtX21tdV9t
ZW1vcnlfY2FjaGUgKnByaXZhdGVfc3B0X2NhY2hlLA0KPiArCQkJCQkgICAgIHN0cnVjdCBrdm1f
bW11X3BhZ2UgKnNwKQ0KDQpUaGlzIGZ1bmN0aW9uIGlzIHZlcnkgd2VpcmQgaW4gdGhlIGNvbnRl
eHQgb2YgdGhpcyBwYXRjaC4gIF9Pbmx5XyBhIG5ldyB2Y3B1LQ0Kc2NvcGUgJ21tdV9wcml2YXRl
X3NwdGVfY2FjaGUnIGlzIGFkZGVkIGluIHRoaXMgcGF0Y2gsIGJ1dCBoZXJlIHlvdSBhbGxvdyBj
YWxsZXINCnRvIHBhc3MgYW4gYWRkaXRpb25hbCBhcmd1bWVudCBvZiBwcml2YXRlX3NwdF9jYWNo
ZS4gIFNvIHRoZXJlIG11c3QgYmUgYW5vdGhlcg0KY2FjaGUgd2hpY2ggaXMgbm90IGludHJvZHVj
ZWQgaW4gdGhpcyBwYXRjaD8NCg0KPiArew0KPiArCS8qDQo+ICsJICogdmNwdSA9PSBOVUxMIG1l
YW5zIG5vbi1yb290IFNQVDoNCj4gKwkgKiB2Y3B1ID09IE5VTEwgaXMgdXNlZCB0byBzcGxpdCBh
IGxhcmdlIFNQVCBpbnRvIHNtYWxsZXIgU1BULiAgUm9vdCBTUFQNCj4gKwkgKiBpcyBub3QgYSBs
YXJnZSBTUFQuDQoNCkkgYW0gZ3Vlc3NpbmcgdGhpcyAidmNwdSA9PSBOVUxMIiBjYXNlIGlzIGZv
ciAiRWFnZXIgU3BsaXR0aW5nIj8NCg0KSWYgc28sIHdoeSBub3QgYWRkaW5nIGEgZ2xvYmFsIE1N
VSBjYWNoZSBmb3IgcHJpdmF0ZV9zcHQgYWxsb2NhdGlvbiwgYW5kIG1ha2UNCnZjcHUtPmFyY2gu
bW11X3ByaXZhdGVfc3B0X2NhY2hlIHBvaW50IHRvIHRoZSBnbG9iYWwgY2FjaGU/ICBJbiB0aGlz
IGNhc2UsIGluDQp0aGUgY29udGV4dCB3aGVyZSB5b3Ugb25seSBoYXZlICdrdm0nLCB5b3UgY2Fu
IHVzZSB0aGUgZ2xvYmFsIGNhY2hlIGRpcmVjdGx5LiANCkFuZCBpbiB0aGUgY29udGV4dCB3aGVy
ZSB5b3UgaGF2ZSBhICd2Y3B1JywgeW91IGp1c3QgdXNlIHZjcHUncyBjYWNoZS4NCiANCj4gKwkg
Ki8NCj4gKwlib29sIGlzX3Jvb3QgPSB2Y3B1ICYmDQo+ICsJCXZjcHUtPmFyY2gucm9vdF9tbXUu
cm9vdF9yb2xlLmxldmVsID09IHNwLT5yb2xlLmxldmVsOw0KPiArDQo+ICsJaWYgKHZjcHUpDQo+
ICsJCXByaXZhdGVfc3B0X2NhY2hlID0gJnZjcHUtPmFyY2gubW11X3ByaXZhdGVfc3B0X2NhY2hl
Ow0KPiArCUtWTV9CVUdfT04oIWt2bV9tbXVfcGFnZV9yb2xlX2lzX3ByaXZhdGUoc3AtPnJvbGUp
LCB2Y3B1LT5rdm0pOw0KPiArCWlmIChpc19yb290KQ0KPiArCQkvKg0KPiArCQkgKiBCZWNhdXNl
IFREWCBtb2R1bGUgYXNzaWducyByb290IFNlY3VyZS1FUFQgcGFnZSBhbmQgc2V0IGl0IHRvDQo+
ICsJCSAqIFNlY3VyZS1FUFRQIHdoZW4gVEQgdmNwdSBpcyBjcmVhdGVkLCBzZWN1cmUgcGFnZSB0
YWJsZSBmb3INCj4gKwkJICogcm9vdCBpc24ndCBuZWVkZWQuDQo+ICsJCSAqLw0KPiArCQlzcC0+
cHJpdmF0ZV9zcHQgPSBOVUxMOw0KPiArCWVsc2Ugew0KPiArCQlzcC0+cHJpdmF0ZV9zcHQgPSBr
dm1fbW11X21lbW9yeV9jYWNoZV9hbGxvYyhwcml2YXRlX3NwdF9jYWNoZSk7DQo+ICsJCS8qDQo+
ICsJCSAqIEJlY2F1c2UgbW11X3ByaXZhdGVfc3B0X2NhY2hlIGlzIHRvcHBlZCB1cCBiZWZvcmUg
c3RhcmluZyBrdm0NCj4gKwkJICogcGFnZSBmYXVsdCByZXNvbHZpbmcsIHRoZSBhbGxvY2F0aW9u
IGFib3ZlIHNob3VsZG4ndCBmYWlsLg0KPiArCQkgKi8NCj4gKwkJV0FSTl9PTl9PTkNFKCFzcC0+
cHJpdmF0ZV9zcHQpOw0KPiArCX0NCj4gK30NCj4gKw0K
