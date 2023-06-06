Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F134672505D
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 00:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240136AbjFFW6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 18:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240135AbjFFW6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 18:58:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6AB172D;
        Tue,  6 Jun 2023 15:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686092324; x=1717628324;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XD4YNCCzniUMNtFbw4IXgIYqW6dcihPBWEnTO7tfrKA=;
  b=QAKtXx83fPvyU0MhZZ9VGRwL2JIACUgxK19YS2tZb0UeqzNz3onFUuGF
   Vf8FFRDCD+Cbf98Jl4mK04KDPspjzhJvuuWAghL3qTAqZ7X8RLh9X+310
   Ca9tggeX9aBRFV4Ol5V9V4etHDeHg5Uzt4hZzhqjCuk00j1Kqdn0eSM/u
   NsfkKRQ1tbRzjhChhKnWStmBV8sb3HQTVIDxbLWQCUCXvQhaNI3oxp+yJ
   Hp2jyVzbA3yZpIDI4cam/Ftgb83MAVURu2hjSGxbG+wPU2AGCnEFP7BIB
   8nuq9DBsVsrCgbjMbL70SPOVLuygvMHh+qOUIo9n7sQmILGy7Oss2Hq+G
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="355673057"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="355673057"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 15:58:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="821853544"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="821853544"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2023 15:58:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 15:58:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 15:58:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 15:58:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 15:58:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0q3JXj1s9oV6EVJBui1mQjpRR7TusKYT1WOwF3bZgkg4+kL2IbYxBZZXtakHw0NFXUTFBATqYgWzlP3DiAN2FmR/68+PBiaXk119e5Uc04tqy1v6iVXwdUxJDDBi4jDqHHpba+373i5r6lUAphY36oOPWiCc0tBdvbz1NZf949I4VXWU3oTTAipE2FCWY186cN3GjsstChueDLfQjwtNZV33bn5fQdVJmUgqGUqDyAjBepYoQCe8aUR0rTM+o/gPfidfIO/+RJVv2fAG3WbTseCTdhXETU2eWoVIzib9uAwHrLaGdW82kO3rNu2wFJQocYEQ91p3Y0I6how1B7BTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XD4YNCCzniUMNtFbw4IXgIYqW6dcihPBWEnTO7tfrKA=;
 b=AYVZnTRqLXrXev5JY43PpJKRDczq/xrhbfk23rfPL0rnBQAPIckFrxI6xLelD1/TGQCD0M6rnWB5UeXfd868TG5YnmlhdfzV6keQXJyzUkKzZrJXe88q8Vh+k71AT90Z2EMxctk0XDpzyhC3v6IiqI38mmkdMntkK2SqJl5UqmododXre8f0dmj9pLZhKaZg9JdGPwUPjZxZn2HMq/SOp+oiYaib93zQbZR6eAGKgC4uYIm0wusK4XQcTTP65D56zdiAysOXzyhJl1HFnSBIua/zIkgnMbg39ElHkErml6BWwOPn6Jb6HeDf4RyPXFknOglQ0sPlzv9ZUZ8A/J8y1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5958.namprd11.prod.outlook.com (2603:10b6:510:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Tue, 6 Jun
 2023 22:58:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 22:58:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 02/20] x86/virt/tdx: Detect TDX during kernel boot
Thread-Topic: [PATCH v11 02/20] x86/virt/tdx: Detect TDX during kernel boot
Thread-Index: AQHZlu+rpaaVXo8nO0KFA4JXild3XK990I8AgACWbQA=
Date:   Tue, 6 Jun 2023 22:58:40 +0000
Message-ID: <92882ba2b4b0d10c0c8d2bc08c4d7fba88a867e0.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <af4e428ab1245e9441031438e606c14472daf927.1685887183.git.kai.huang@intel.com>
         <a2da8af2-41a9-a0cf-dbe9-7f0a14bf05fe@linux.intel.com>
In-Reply-To: <a2da8af2-41a9-a0cf-dbe9-7f0a14bf05fe@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5958:EE_
x-ms-office365-filtering-correlation-id: c2c09e2e-b977-4a52-2d96-08db66e191cc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RC/qCSAkuYVMMzIPu/mk3Wxe/5E1mH4MuR/lMYKf9LwHavBmcval/5dYbXkStOT+DOSD4y4nZ/AHWxdLoWfDaBz9p6BNhHoR4S2+NlbhvgwPHNRBUqtE57GD9+jxdc+yj1JwoULMXR3XYxiWBZAyl+nkFF+2AFIDxJKFluFCkTfFljfVCO3jbk+OYNnR/5Tcz0cn3rrzy7Kb1sQljO2xFBchaCfw91N5OVDn59i+8E8NFlkTVkfeShyNFXJkjcjmMLEWaHgw4dssSAnvP/FOCu6BFB7OQ+0ZQT/iRwLNS3b/9KO1JY8no28XgKLy+F9jQbDT34gQcKWOlcg/zNvOXMeCxnlubqGayf5wcwC0loJwuwn1hxWdDafofHHCCEJcwO2L0o+KW8iJWMBDm8FRcPlULbNb0j0R00vlo+gYJL2U82dEBwkYrAXp9EBjMivrEThT+U5hCLpPEiGAjxCoBpa65DTRoDuycD0kX4CAvKL9utvxY0steS6x8k3MqPgKAtrn/duDUmmkjF+g2Rb/cVmo/n/X68GhvhY+5yiHNuCC1eyOfyPSE2cA3Qnl1k7KQyNGUwjlK7uzeSZ+4Y4AC80dRZBSYWrws4tJ/hvdhKpAWR1n2Qygp6f5XMiEeNOQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(376002)(39860400002)(396003)(451199021)(186003)(2616005)(478600001)(6506007)(6512007)(26005)(6486002)(316002)(8676002)(8936002)(38070700005)(86362001)(38100700002)(41300700001)(71200400001)(66476007)(66446008)(76116006)(64756008)(66946007)(122000001)(36756003)(91956017)(82960400001)(4744005)(2906002)(4326008)(5660300002)(7416002)(54906003)(110136005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzE5cnlGK0ZITW5FTWI1bjc2UHZndkZVVTh6d1g1WkNQWjQycWIrdjZiYXVY?=
 =?utf-8?B?aGZtbnkvazJuWUlER082UUxnNE05bStMbVdHdEtwQXZSYVRWL3hWZWdlc2xE?=
 =?utf-8?B?dnE4QWMwbDdhdjF0WUVnclpkUmhVRGc1R25WaGVNMWYzM2krVXk1YzZDUjVB?=
 =?utf-8?B?bCtnMnJ1aHRvNVZlWUljQXdhN1BTOWlYUGxwcWoxQzRwd0tRVkFsTjFMc3k0?=
 =?utf-8?B?UEFjMU5yblZRS2lMeFJ0a3JzR1JyVzlYbDVSRnF2d1dHbTJzZ1lobG1ZeGEw?=
 =?utf-8?B?M1l5WFFpWUZrWHVlVmlTK2xaYWhWYkRkbHN0ckFNWk9yeGpEZmJPNXJpWnd6?=
 =?utf-8?B?UFFkQi9BSjVENGM5N3JhZDlZUm1mdFFWYUNYYzJHYzRSS2NXeklpcWZMeHUz?=
 =?utf-8?B?QXpJZCsxNFIyakMybzlJd3ZsYTBydmpQcXVDckMwbXZaL0hrMVFYdGdOUWN2?=
 =?utf-8?B?Rk03VGEvWDZtVGh3aU5uZFpvRVFVd3FmU2s5TzB5cStDMzVmZ2VldklWS091?=
 =?utf-8?B?TUltWEVSM2VNeUt1WmpnOHJZMnl1T0wxcUp5VjlXWi9WSXZFajVhQTcva3FH?=
 =?utf-8?B?Q1JmMEhNZ21kZ0p0TzVwR3Q3MzhTdXhIK1g3cC9MTkNObWh4UGxPeDllSWox?=
 =?utf-8?B?Vlh5UDBkYmdjQitNQmJOeUNsM2ZITm1Jd3FJWDM5ZVdnT1Y5WXJRcm9wRWsw?=
 =?utf-8?B?VVJEUytPUUpmMS9EVjlDWUxuRmpkYUMwcmdkWUNqSkJxNFdld2pRM1JzRE8r?=
 =?utf-8?B?Q3F4cHh1NmdOYzJSUTN1QmNSUG96WjN5SDJjWGtObFNqdTM3eW03azMwa1di?=
 =?utf-8?B?MS9GYnh6SlYza3VOVGwzR3dMNDM0QmY4OW5FMzVSTFE5WWN4dlhOWE5xZG9p?=
 =?utf-8?B?TndibUIyR0kvZFVBZUxld3FSeUtNd292MHR4elF3MTlFVUM4TjdrQk51bm5v?=
 =?utf-8?B?M1hQc3VHRDc0TW8reElkM0FuQVp3cWpDZml0dVFqc3ZqZ1pmaW00SlZBT1lF?=
 =?utf-8?B?dTZuS21RSnRZTlBDSXc3QXNpUzFmUVZTZHRYZEd5N0d2TXNtWFlQRUxPTXBJ?=
 =?utf-8?B?a2Q3d0lla0QwSHNOdUkyOWZkbUZUcnh0ZklBQnkwY0NDWWNPM1JEOFBMVUFn?=
 =?utf-8?B?Y2wwSHlHN0lWSm8zaGJDSkN6bVpFQlBvaHcwbml1VmJRKzIySTF4bDBwblN5?=
 =?utf-8?B?UXNVT1p6RUN1OEV4M1VJZ0h0ZkdrMERVcGpoeTgrVURDam96eGJ6YWdRbkQy?=
 =?utf-8?B?MDd6RVR5Y1p4UzBCNzREV0JCa0c3K0NqTXFBemx6RHZGTFlKVmw2WlB6WmtY?=
 =?utf-8?B?Nnl2Z1h5cit3bjA4RnNoKzkwMERvZVhuTnhtaGtheHFJd1ZvblIzR2hyR0Z1?=
 =?utf-8?B?Z0M5VEN2eWlFTm1ZbXNlR3Q2WmdZMDV5Zm0rRi9paW9XcTlDS0hGaWhTV1pX?=
 =?utf-8?B?dVpNdWZmUU8xRUowR3QxSkMvVTVRMG80dlFramtvc0pzK3dNYmJyUCs5Qml2?=
 =?utf-8?B?L1lDNXJ5WHdZWmRONUFQM1V0VjVmRlorRWx6M2E1UHQvVDV0cDZVSU4xUVBn?=
 =?utf-8?B?QWZPUTk0RUplT0ZFNmlhOVBMZy9lWmUxYXYrSU1nOUhLUjdqeEZGMXhYeSty?=
 =?utf-8?B?REhNemR0bU9FeDFyaUdVUUcxc3RxVzBiUHJoRXZaUHZ3U2d1R0lhSHNrZTRx?=
 =?utf-8?B?NFcrRW80ODZTQmhLUFVaRXlCTlVBZ0JxSlVReVMvMTFkT3pwbG85endMWml5?=
 =?utf-8?B?YVQ3Q1AxYkRNaXp1am5OSEpBejZNU0djbkd1STYrRm1FRUV5TEQyL3ZZY3RM?=
 =?utf-8?B?QWYyR1pSMU5VS2owQ3pHT2piNTFWZEFiMWJWQ3ZBYjQxTzBWc3dwVGFYUzY0?=
 =?utf-8?B?b3VoWjdmdHhwMjV2Sy9ncHh3M0V0T0pVdnA0Vzc1K0Z6MmhkdlBEaS9xbEZU?=
 =?utf-8?B?Y0QrUmhvL1VueXowY08vMjhRT1pQUHhXczFCV1o5emI5bUJTSGN6QWFYdUVa?=
 =?utf-8?B?YnBKcmxrN1dpRWJsWnlhUGYvM3lBQ3hnMjZqU1JJUHFYakY3cnhBM21jdWRK?=
 =?utf-8?B?RVJ4OVE2SUoycGluOWplek5LZkhFNWZ5UDEzRlAyOXY5SXFhVXVSSDBlaWo3?=
 =?utf-8?B?ejMxUGRlcWJYRE5ZOE0yeWFBbTF5T0kxaTQ3STRVS3c3V0xvS1JkTTl6TmdQ?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9D410A56AF8104FB12233E51AF6165B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c09e2e-b977-4a52-2d96-08db66e191cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 22:58:40.2287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kn+lhfF/k6EsTYYESBzA7V45aFS5sDMiwB3pdUcFdgXhlNVaxlCT78332nw4BOuIe1D/8rgEpKtC7e5c2gRvyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5958
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTA2IGF0IDA3OjAwIC0wNzAwLCBTYXRoeWFuYXJheWFuYW4gS3VwcHVz
d2FteSB3cm90ZToNCj4gPiArCWlmIChucl90ZHhfa2V5aWRzIDwgMikgew0KPiA+ICsJCXByX2lu
Zm8oImluaXRpYWxpemF0aW9uIGZhaWxlZDogdG9vIGZldyBwcml2YXRlIEtleUlEcw0KPiA+IGF2
YWlsYWJsZS5cbiIpOw0KPiA+ICsJCWdvdG8gbm9fdGR4Ow0KPiANCj4gSSB0aGluayB5b3UgY2Fu
IHJldHVybiAtRU5PREVWIGRpcmVjdGx5IGhlcmUuIE1heWJlIHRoaXMgZ290byBpcyBhZGRlZCB0
bw0KPiBhZGFwdCB0byBuZXh0DQo+IHBhdGNoZXMuIEJ1dCBmb3IgdGhpcyBwYXRjaCwgSSBkb24n
dCB0aGluayB5b3UgbmVlZCBpdC4NCg0KT0sgSSBjYW4gZG8uICBUaGFua3MuDQo=
