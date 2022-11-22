Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348E66331AF
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 01:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKVA6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 19:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKVA6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 19:58:22 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E6E682A7;
        Mon, 21 Nov 2022 16:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669078701; x=1700614701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D2sjioOhc+aGEs/3bQy1RRAyHoNQzgOf+I8u1Y+sOzo=;
  b=RBDB221jSknxY81uf/5gkkxFMKT0ZiJxer+v6UhUc6D73migcZP5BKdR
   I6VdhL1lQ9HtirtftMXlH0hMPx77EoJjuGipWztqo03PywxhIK1XdzKDJ
   tMyo7RtH534PyO6sHaL1BMaFHcoOge4Kgsc93GzP46UgJVK1W+RIVtMvw
   McXRuycXBUr4IAb6UclVBYfbOt4F6QlSRTv2lsttuaz9uoMZ2LKOjDLHc
   7oEaZLou0xj4Ff8U5sbDprPZtnLsnEJpWAqOVz7d2zSfwPwHh4FA6JbRI
   QRU7rgLdn+z0lzAoyZm0+6XE5Rujmwff1ZCTjAAL21yjsXXjSWgq/KANY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="311328216"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="311328216"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 16:58:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="674168676"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="674168676"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 21 Nov 2022 16:58:19 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 16:58:18 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 16:58:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 16:58:18 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 16:58:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK+yzEUotCmCPrsqsgE+z604PposXTknVGncdv8ym7vLrjYBVH8V8lEO/C4LlKny/mTeu3p8u3lkTooNVlfJFh/wpxyyaA1bba0Nm0/GFmqTGeFRtcP0GvrW4DvUz//QOxiwlSM3InBwCbsomLHZ8lHK8A/8vKv/WTrf/jdW0M1aN9OAcOiSINkvsrxWw/QeNOuLL30QP7NnJ2J8LSkUAbbzAtUrvhOnfoDDQho65VNOa0fmXegip+TYHVg0j1r9t2NJ12hPD49FZKhD8nMvEWg5zCzQu/UelPmf+DD03jeig74+3c38iu5CJxqIVrJvos5JhIuSpGLmim+g38ApPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2sjioOhc+aGEs/3bQy1RRAyHoNQzgOf+I8u1Y+sOzo=;
 b=lLTvtXFvZWT92L97oJBarTUqsbhU7oEypFaO2/cjMQv+LFO54LyBolWjkrovh14YIDPHasi3enU0j3cS4Zw5+/DofXixq7Yg1D4gJgYhj7NDmEQluyTgYlGTYiiLkuIfpj3pVxYoigNi/Co7ndWiR05eiGDH9erU5h+8OVasBaZXFQ5GpmphcuU6pcOgnGEL1htr/+3sdB4W2TaZczf/yq1UA0RLnRZB9GZBQvq611hOcTe/6D330kELrvoHfuh1bZF2ujfPk+2uJT5S7oDin1PFmKn7i7d7Rt0x/JMtPpEPCEUafDVDK7zmky/gpu0B7+G/xdWZ1Dknl6eG7VuzFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6934.namprd11.prod.outlook.com (2603:10b6:303:229::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 00:58:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 00:58:14 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Thread-Topic: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Thread-Index: AQHY/T2/qiNrCEbeGka7t7fkot0Cyq5KDH+AgAAMRICAAAQCAIAAA7uA
Date:   Tue, 22 Nov 2022 00:58:14 +0000
Message-ID: <badc1c1118dab8ffd182348bf7117b7b58d3be66.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
         <87e17024-755d-e195-d9ea-ef62a4de6aa8@intel.com>
         <f9918596c4013444428899aca2cfa73b1f18c703.camel@intel.com>
         <c564a7fe-2e33-a071-e333-39163471c678@intel.com>
In-Reply-To: <c564a7fe-2e33-a071-e333-39163471c678@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6934:EE_
x-ms-office365-filtering-correlation-id: 33492327-7e47-4830-f948-08dacc24a25d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D6sn3LAxYQuPTMO1iVcC6s7chUYGpUhZuEpY10CS+/PUUzIWlcq7qiMCEJNz1WUxxlZkyHU+AWYWqnUuSEDE5Q76yywF7uGElEZpymV1ntQvc6sbIs4YM1BXOuoWLHnA6aWfQGOaaUiNTGZpkUXU8AXHgQB4nKeCQs63R7RlTFWCvhmcUAIOL4gwmiELt34KcDW/qCXdmIwIxFpln8z0AhFh3FLSEQxXvKD7JPgfaGhH8jo7epqrPeuINw7uem7kBxhn73NYQUY2k89kXlU6wMqhyWAYiJU5Q2CErs6YYdYmvF8ry1scQAcp9KzrI9z0xG5whRuYtxRX2EFiluDcY+7cDZhYBqS9llpZSVQ1wJ35JQurX3/mrIrepQIl856kUONkT75/9eSsOZ4bfkeQWEaYtT90ZgUvNQ5hjRPGXV/Q+7EHyOUpjojRAteRfD4Mfp4prZdxwVOvwAQoLSeA3b4NbxD9Cr1DGWdHDG5clVwOiz/f4LOLaJM60yCCJhJtj5xzLznw7KvDQNLLHuiiEbADC6UPTK5hDWSkr2zbnBeVHXIDCLRx2aGUNzSUbdrJ881oxAOdzHB/39UtpJYXbLk+iXn3FI/PAV6qwBIJ/6JRX/3TEVwWCBo4Jpe9UTNvQlP2s4P/GTL63Zr64Y3rGZJ+KWrJ4fTapCGgp4OWwZtqxaHmaZCJ84JNG1OGMtUXSd/6zQ/ksUOFEZMh7qj2wQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199015)(83380400001)(4001150100001)(2906002)(2616005)(66476007)(76116006)(66946007)(41300700001)(91956017)(36756003)(86362001)(122000001)(38070700005)(6506007)(53546011)(54906003)(110136005)(38100700002)(82960400001)(5660300002)(8676002)(8936002)(66556008)(4326008)(66446008)(64756008)(4744005)(316002)(186003)(26005)(7416002)(6486002)(71200400001)(6512007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2I5L3hkMFNNbDRVR3lQOFU1Mk5qMnU0ck9PMlNkOHowc3FFUitFL0EvUjBj?=
 =?utf-8?B?S1JVVUNkZ05TY1duVnlMZit1NStsOHM3cEJDMDFmc0RiZmQrb0g1VVEzcGwv?=
 =?utf-8?B?clY2TlI3OUJ2Qml2azhWQ0tBRzYzRFJ2NDNGcUZaVkQ0WDBja3NWSHBYYlFB?=
 =?utf-8?B?ZWxMeWtsd0tnRDNkeDk3OUpCaERWcGp4a3pzUGg1NTIzUDBtc0FXd2pCclN6?=
 =?utf-8?B?WjhBNDdSWERHV3UvL2o0NE1IT1ZHYUQveXoyRkc1WVpieWZnMEpzb05sQnNW?=
 =?utf-8?B?Wm95bDZ6SGVVZ2NKdks2K1kxOHRWK29iMGU1Vkx2U0dqakxSS21WRnYrNjhP?=
 =?utf-8?B?SWMvbTJWbnp4RDlRcXd0NkVVN05QS3FWTTBSTUlJYmRBb2NrT2tCbUFSN1Iy?=
 =?utf-8?B?NG11OG5NTzZFN0NuUTF4N1VPaGVHKzVKczdQb0YvZlZBWXdSbUZrQy83WEIr?=
 =?utf-8?B?dDUrWGpzMndxTi9kYXp5M3dFSStlZlVJYVQ4TTlqUnJURytXR3EwSldXTm4v?=
 =?utf-8?B?ak9jZ0o2ZHlhOHVQeExwYUljMDdiMnVyS2dXVHQwSEdHQ0d1ZEFMZUFKS0hG?=
 =?utf-8?B?dGE2QnBweEJ3VDZ1TkN1V3BGYjFaY0daT3RDTDEzMTAzZk9yRm5jbzVKS3ky?=
 =?utf-8?B?dWZUVGlUYUExVTJabnA1aUViVEwzeDJYZVdzQU5LY0tOQnUzdGgvaEF3TW53?=
 =?utf-8?B?WkdkNTAyaUxaMnlWckF3bWNEdlhVb1oyT2lXdjNjSGVhcHZPQmhMZmdJelpa?=
 =?utf-8?B?MWVuWm92eVZtYnU4eGFZSGJkdE02WVpkK3ppYXdOSDAwN0JOVDl0TDRoK0FN?=
 =?utf-8?B?eHJuMGlTTzRtWGEvUUg3KzZZdTA0elFQYjQ3NDZyMExKcjErSHBZc1hIV3Zh?=
 =?utf-8?B?MCtHT2R1aExVbmEvaWVoUmlmLzZPR2s1bWpSTkt3M0tQemxvNm9wOEhiSnE1?=
 =?utf-8?B?c2lzQ25UNlYybUgwenNQbTg2WXhHd1o2LzJGZGw3aE1xWSs4OXI3SjZwKytO?=
 =?utf-8?B?Z1Q0ZWJLYlVndDc3ZTJMU3dCZ05DeldsanFiM1ZONkdyMndld1Avb1lsM1lo?=
 =?utf-8?B?cldDdWJESnVXSmIrR09FUWRpWm5YQ0xEaVlUeHJ1QWtBUjBTTEFUQ0JyODdH?=
 =?utf-8?B?dWJ3cEpVcE9PNEJtdnhWZzZlQ3drZXR3YlJVMjVDdEhnM1FLT1JjT1JFcDk2?=
 =?utf-8?B?RitjTTFOTERCc0FFanFrRGJIaTF2YlVHaFBIUWpRb05lUmdoNjdFVUdNZ0ov?=
 =?utf-8?B?WlpBODNGZ1hHUFk3RjRkMXRQbUpiNDNWQ2o5akp4cUlmYUhTam9NY09OT09k?=
 =?utf-8?B?UlBWVVV5K2FLbHlEaWttMjdDaWhkNjQvNTJlZzEvTkdEVUM5NmRQdVRZL0NM?=
 =?utf-8?B?ZUtxRUp3WEwzTlBxcCtBVEptMEVEM1NaVnlsWWIrSkVSbmRnSnZQNHNsY0xq?=
 =?utf-8?B?aEkyenlSclFPQm1LQ1pPZDU0c1FUeEoxeGdud0ozaDIwZVN2VGRxdEptaVZR?=
 =?utf-8?B?V29YNTNWL0o1ekpEVkNxNnNUUzMyMVlQL0JsOW1xdnVwMTZ6UnhwUHM4OG55?=
 =?utf-8?B?Y1pmOXQ5dDl4K0lSQ3QrQ001eW1NRFBjdEYwVXd1VUM0TS9La2twMG5MNG9G?=
 =?utf-8?B?VjIyNU1CaUVPUVJmbVZKSmVKNzFFbmc5b3dsOXNHcWNpZ3RYTzNpd3o0dW5W?=
 =?utf-8?B?MENSRlVsN3lCWEdsZE16UHZxN1hYSnVmNVphTEM5Y0xIVnc0OTNhSXlLMTZL?=
 =?utf-8?B?VEtiWXRpaWx2MzNTL1dqQ1RQQjRWSVRWbCthbTVkMnJyd05NSDFLQ3JJRFVZ?=
 =?utf-8?B?NVF6U0U2OVc0T1JQeFRRT2swOWtMeHhvU015dHRjWHREWTZXZ09BR2JTbEUr?=
 =?utf-8?B?S3VjSHFnS2hENU90Um5BdG1QQlliNEpKUHJlRU9vZ1BjSXRsZjBMTnNJVDl3?=
 =?utf-8?B?YVRFTzJDaWh2OGVrNy93Q3dSV1BqMVZ1TExrdXhvUm42bElrWGtPYzVxQ0Jr?=
 =?utf-8?B?RzhLSHJITDlPaFN1aGI3Vm01by80Y0ZZSVhmOXRCaUlOQ1BocUhnd2hxbUpL?=
 =?utf-8?B?a0NZR1RXS1dpaHlaeVhLSVc3cmVKQWtzbWZ4UzU4ZlQxUDBSYXBjemsrZW16?=
 =?utf-8?B?R0ttOWx1Q0RVM2ZDZlY4c0NXVE9DaEE3TFVtMFZBRlBiWWdZckVId21jeTk0?=
 =?utf-8?B?blE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1ED6F60617978946840225351381264A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33492327-7e47-4830-f948-08dacc24a25d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 00:58:14.0834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N4UegtkDVchVyCmapXbhQbs//oNSsIVguiwQxDygdu2WqNE9qasT9K81JF4sT2q+T5nl5tzNUEVTqHu4Xpiq5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6934
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTIxIGF0IDE2OjQ0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjEvMjIgMTY6MzAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gDQo+ID4gSG93IGFib3V0
IHN0aWxsIGhhdmluZyBhIHBhdGNoIHRvIG1ha2UgSU5URUxfVERYX0hPU1QgZGVwZW5kIG9uIFg4
Nl9YMkFQSUMgYnV0DQo+ID4gd2l0aCBzb21ldGhpbmcgYmVsb3cgaW4gdGhlIGNoYW5nZWxvZz8N
Cj4gPiANCj4gPiAiDQo+ID4gVERYIGNhcGFibGUgcGxhdGZvcm1zIGFyZSBsb2NrZWQgdG8gWDJB
UElDIG1vZGUgYW5kIGNhbm5vdCBmYWxsIGJhY2sgdG8gdGhlDQo+ID4gbGVnYWN5IHhBUElDIG1v
ZGUgd2hlbiBURFggaXMgZW5hYmxlZCBieSB0aGUgQklPUy4gICBJdCBkb2Vzbid0IG1ha2Ugc2Vu
c2UgdG8NCj4gPiB0dXJuIG9uIElOVEVMX1REWF9IT1NUIHdoaWxlIFg4Nl9YMkFQSUMgaXMgbm90
IGVuYWJsZWQuICBNYWtlIElOVEVMX1REWF9IT1NUDQo+ID4gZGVwZW5kIG9uIFg4Nl9YMkFQSUMu
DQo+IA0KPiBUaGF0J3MgZmluZSBhbmQgaXQgbWFrZXMgbG9naWNhbCBzZW5zZSBhcyBhIGRlcGVu
ZGVuY3kuICBURFggaG9zdA0KPiBzdXBwb3J0IHJlcXVpcmVzIHgyQVBJQy4gIFBlcmlvZC4NCj4g
DQpUaGFua3MuICBQZXJoYXBzIEkgY2FuIHJldXNlIHlvdXIgc2Vjb25kIHNlbnRlbmNlIGluIHRo
ZSBjaGFuZ2Vsb2c6DQoNCiINClREWCBjYXBhYmxlIHBsYXRmb3JtcyBhcmUgbG9ja2VkIHRvIFgy
QVBJQyBtb2RlIGFuZCBjYW5ub3QgZmFsbCBiYWNrIHRvIHRoZQ0KbGVnYWN5IHhBUElDIG1vZGUg
d2hlbiBURFggaXMgZW5hYmxlZCBieSB0aGUgQklPUy4gIFREWCBob3N0IHN1cHBvcnQgcmVxdWly
ZXMNCngyQVBJQy4gIE1ha2UgSU5URUxfVERYX0hPU1QgZGVwZW5kIG9uIFg4Nl9YMkFQSUMuDQoi
DQo=
