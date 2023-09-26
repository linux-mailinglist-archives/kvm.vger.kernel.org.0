Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C36E7AE62A
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 08:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbjIZGmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 02:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbjIZGmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 02:42:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C880E6
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 23:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695710536; x=1727246536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gn3MFknYDWD3W39oJ7OJ/PhASeEF80Zr7AJYvDOCq+w=;
  b=ad4qGqZdLKFBP8kdCxUkz8hnjox04zVjAo/m3RovFRlVtL95gc3DIvkP
   8BI3n6M+4+5a/m52K3XWR4vLNJdAr1etG0UDTLacR6+ZlIzkUGbZQ7KZX
   dm5zLexGK9+RvZcRyKuidg/48BWI5JujaqQtsaJbkqo2dsqZuQv1bfXRS
   GnSzM1ECWizi9q0pb5ToDFGABJ5HcVcrhRZVNW1b8nzf2jVnE+LUbK/eM
   cy6vVsC/IU0kvU3x+J1eiel147GqUMSoepCjlFFLhwi3X1PlerYKKXfBZ
   vTDYpch3efGsFctoBQkeyVj9RrvlfU1bhXL2/a+JyMDvoX8alSBzyLll+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="381402112"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="381402112"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 23:42:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="872382626"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="872382626"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2023 23:42:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 23:42:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 23:42:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 25 Sep 2023 23:42:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 25 Sep 2023 23:42:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrAK5grJbtXRHRNMAZi+GGbucdP+Ab5+Z/f8HpdGeuAsZBy68eO3qwQQoWR8QarYopmrQADRboQXHZBiobrudCHdc4i4Bnyrj+DQ1nSVRcjhBPuDOKcnZX8EZBC/iGIr+pW2fHwH7dl2TKcN/JIjBbjQYRJwU+e1O1al5h179RFQkiZYV9st0rej6j6rJ2nfkX7TuK/L7vm5qIOn7NxReQfwh2De1H7CICVm6owea6+I9/lLxUa31o/LVTor7NFGA9Ub8uyuI1c7N9uWS6QhSJZGEt4ck98WJ6Z74iL//vIAQkx9VowLmjldnP6h7CFwi0c4jD8h8yZgQDeyfwW+FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gn3MFknYDWD3W39oJ7OJ/PhASeEF80Zr7AJYvDOCq+w=;
 b=bhNyRqMdj7DrPDvISJAnyb4kesZPjiJquXHCy/LNV7HwnLxWRUCIf9LawS/UqsQHqNUxY1Wka7zgCwOHISUyWzG7dMsHQiQGGaQhnMCv7hdzYpEmtzY7iTiRsX7R1NY4mnnL9NH7DURjezDtI75+bmCuvTlQPWvcBcvZ1fRlwAAPwK/4Ba4sHY4x6k64Bp85i0ZQ1SxEwP09aV9jpeZoWFc+MkkfyTET+W4SYCq6V/cZbrNpmp2pNQxHyAelsemA5+ttQFOkVedm93HM4DbNqTwPZL2ZMpbFWg930S02Tv+CwzujnLD23pKvBdWPrWmc0LCxewxCki7P15tbExdb3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB7720.namprd11.prod.outlook.com (2603:10b6:510:2b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.27; Tue, 26 Sep
 2023 06:42:05 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%6]) with mapi id 15.20.6813.017; Tue, 26 Sep 2023
 06:42:05 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>
Subject: RE: [PATCH 4/4] target/i386: add live migration support for FRED
Thread-Topic: [PATCH 4/4] target/i386: add live migration support for FRED
Thread-Index: AQHZ3JmH8jAq0iUYYEqlHY1Uo0XRfbAlG96AgAezmBA=
Date:   Tue, 26 Sep 2023 06:41:46 +0000
Message-ID: <SA1PR11MB6734B58C0A7F6F70327AFE1FA8C3A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230901053022.18672-1-xin3.li@intel.com>
 <20230901053022.18672-5-xin3.li@intel.com>
 <ce2bd892-0c42-3d7b-cd59-a397b840fee5@intel.com>
In-Reply-To: <ce2bd892-0c42-3d7b-cd59-a397b840fee5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB7720:EE_
x-ms-office365-filtering-correlation-id: 08aae5e9-f75b-4ace-1226-08dbbe5ba786
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wQPd8YvQTyWeTxhBGy/XS3zOijIUT3YwdNuMWpBPvEa4BdgD7tf+dWpHxdKFRBEwaOEprxPBgHVK2MzAKDuc14U9ChBBkxChS/1qYkqbNl47jro8ZYiN4YP8Vqvx26/TKd2wQvDegy0wcJlP0fE1qzP3JS91GYnWyAgiArr98OMpi2hEjrNqxSpY+7lnyI5I+fOxM7SQ3+Z8UbCsZI4TqXLuttahfy3OGhOOxQitLt4R4RqvWnABHiqWvlbXR1qEd8LA4PeIdmbhBZrbWm+btK1Sg9ayeztyYdZFyQb9D7CNCYqhrKSa8mSN93qjj4KHnodCzZZnPFpsAdyGMzTGq2XeMJoGNvhi/6u5Y32qhDe6w6FppYpEM5zN4rzGvNv3tKZmr9kMBIqyhXmM0kUzALpY69/0I8dMRqVUiwQ0NgS2hV5fM8QeqYmuZpjwuCVSbXDXRQFoEbRRPpe6nOHTL48PSsZRf+SGZQaoTVP93DGyY0qO1OsWL2DYC0WBtLNQT+9iwOrKx90c/c0eaOG6viY1ofZos8ZlMULaFsGvNgkgySllJ9PoIL5jmQSkAWI21DSn7zHGHQnkV8lT9zouMWZMiygCFxA3uvsnk/DNrihUevQdluffqZ5IB6w+MGad
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(396003)(346002)(366004)(230922051799003)(451199024)(1800799009)(186009)(83380400001)(4744005)(55016003)(8936002)(26005)(478600001)(8676002)(86362001)(4326008)(5660300002)(2906002)(6666004)(66946007)(71200400001)(38070700005)(38100700002)(52536014)(66476007)(54906003)(316002)(64756008)(66446008)(110136005)(66556008)(76116006)(41300700001)(122000001)(9686003)(107886003)(7696005)(82960400001)(6506007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2VqUVhEOU1TT1E4VEZiVU9icDRWbGZoSW9nb0hrM1pNVVdZNm9DWEhhbTBR?=
 =?utf-8?B?d1plU0xZQkZTSkg4TisrR3FOQUV5US9Tc1o2ckpmZ1M5WmNGWG1HVEU2UkRz?=
 =?utf-8?B?T1RuTFFXa29CaTJjeEZFR3JoZlBMVnVzSXdzSnFiQlZELzhMbVlqb0l5NFYr?=
 =?utf-8?B?eDJIeURacGxTc0RISkxIblRUcE41UUhxSzVpSm40Q3hsWS94d1hVSXJUZjVm?=
 =?utf-8?B?VGlzWGc5ZTAzaUROcHh5K2F0eUx6NThSZExHUHAvdDJQKy94WFl0OUlEcnJm?=
 =?utf-8?B?NXZpODJ5NDcveDNhcHNRMXFtZkFUNzgwVWRKY3ZMSWxrWGtITmlURDd2Q21B?=
 =?utf-8?B?WXRFek1MV2R5QUNSMlFkUG1kTnRqT2htYWVaWTdza1diQTNldW1YNlE2VVZu?=
 =?utf-8?B?WFpXanRYQmQyVlJuSVkxSUZaK3RiOTNFcDJXKzMwaUVlSlVWSlg4WllIV3Q3?=
 =?utf-8?B?Y2h4MEFLNlNzdnZuZWF4eFFRU21DU1NyKzcwMWhCWE9MVStkNlUyM3k2OEdL?=
 =?utf-8?B?c05SQTNuZ2Jlb3JwT0pra2tneFFSaHNaajBVWTA2WTN6Yno1Z0Rhc05YWG0y?=
 =?utf-8?B?WW42bXg4RE1GWUtib0Z5cjQ4bnhtS2RLREdobnhPVk1kc0JlSEdSK3NhWmxP?=
 =?utf-8?B?UnhaN21Fc3dHTGZqTlZGU2N0SjhvZm9zSEl5UGV0a3d3eDMvdUVSd1RGcHlr?=
 =?utf-8?B?dHNYcnpVc1VyWXJ2VWVES2o5WEQvcGRQbEo1RmhCNlNkelNwY3BQa0k0TU92?=
 =?utf-8?B?MFNkZ1JWSmRlVWxpL3F4cG9CNHFQR0NSbEdkcG1tVFdYL2JuZzhRWVhDLyts?=
 =?utf-8?B?eGl4elg5V091SUJiaG5kVktpREpaOE9HdHFVWnRPaU1GQkp2Nk9FUmRqUzlM?=
 =?utf-8?B?MFU2VjN4YmdidmtXaGExbzRZSU9yaE1jN3I3YytYNkYxUVY2dDJHYzk3VFht?=
 =?utf-8?B?bWk3TmR1RS85VmpkcXVnTFhmM09Na3FvVUM3aWZLYlhRd2ZVTUR2NVY2VkUy?=
 =?utf-8?B?aVRVV0pGWFFQNkplSGxGSWRpOEJnTUxVbFZGdVVXR1N2TG9Ecm5Uc3p0b3Aw?=
 =?utf-8?B?SEdUZmVSNnlVYjhLekdzRTJQcVJveG1ZakVPQ0ltV2k1eHZZaytZSDdHTVNX?=
 =?utf-8?B?Tm1yWFB0TDVkS2J6ZWtZd3pmMXRnKzdOdHc0UTlld00xdjUwdXVYdlBZRDVZ?=
 =?utf-8?B?S0paakFPblFwNmQxRlJqaE1vcGxlY1hYMm84UUpEZDNOMUdxYnI5eC9mL2Nz?=
 =?utf-8?B?cjYyQmNrVE8wSk1YVk9DRXFQU09uMDRQd2luaE40aWRNVDFodkJtbnJHNWZq?=
 =?utf-8?B?WERWZmlibEorV3lrMWtvVzZLaHduV3FWVkEvbUxVdXdBU3lrY1dXZU0yNENJ?=
 =?utf-8?B?ejJ2SEo4aFNWWG0vUUVuOGRTTzd6MUEzZWN4U0poaVRQNUtyVHpDT0pOOE5a?=
 =?utf-8?B?U0FJaVdLMUhRcXVaTzhGeDZQMUtVTy9ERGNsMlpncFhqSVg4S1dXa1Q0d2Fa?=
 =?utf-8?B?MjJaenY2WFVCeUp4MFF4SXVBbkVBdUhXUTYwS2lGbHVRV1BTM1hZUmJYeEND?=
 =?utf-8?B?SlVlWERvbFpUVGIyVXVvQk5jSlRmUUhKQUlCRVc3MzJSUGRBSTZ6YlEySE02?=
 =?utf-8?B?dXppYUZ6cXZZRkdlQWs2c1ZwZFJ4RkJYSEEwZi95NHprVEQzZ2pJcnExeVZ5?=
 =?utf-8?B?WFI5NzBrakFpWjBxRDN6VlQrK0wxeWpEMHFHK1RHcXZWcGVOVDBEQTRNc2NW?=
 =?utf-8?B?TGpnK21kWWJxZHRNRlNkRnRFNklhdGc2b25SbUVmbFhaNGt0T21UemVCUC9J?=
 =?utf-8?B?Wk1RUm5vWVdldlpoVmtpVXlBWjBaWlYvTVhPWlFRc0w0bzRmY25EYUZBWWJB?=
 =?utf-8?B?YzY2WVlidUpXd0lwRFV6VHZTMkphMFo4SXpsZTNXMU1HWXJFbjdlamMyb1BH?=
 =?utf-8?B?WHZ6UXh3QWdjUkRPTnN1NXBHbnc0cVlsbFh2bER3bmRQWmVzUjY2a1ZvUkdw?=
 =?utf-8?B?bzJhVlJLQ1orRXhRMGFrMHFReXltM1VaNzRNL1RMWC9Mb3BOdFRxd3d3RVIy?=
 =?utf-8?B?UTZTY1RoZzZUV0huaGdTOVF6MENXZGp1WnY3UVhLblRkSFkzNndxU2dOT1cw?=
 =?utf-8?Q?gyGQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08aae5e9-f75b-4ace-1226-08dbbe5ba786
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2023 06:41:46.4694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9wGlD5gnwpf8pBkwZSg+XXL+q8AekeFmzD3Daq526qYwyURvnd0PV0nIAk9cOZsiGRVr11zD7as7DH3cTiWWug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7720
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IEZSRUQgQ1BVIHN0YXRlcyBhcmUgbWFuYWdlZCBpbiAxMCBGUkVEIE1TUnMsIGluIGFkZHRp
b24gdG8gYSBmZXcNCj4gPiBleGlzdGluZyBDUFUgcmVnaXN0ZXJzIGFuZCBNU1JzLCBlLmcuLCB0
aGUgQ1I0LkZSRUQgYml0Lg0KPiA+DQo+ID4gQWRkIHRoZSAxMCBuZXcgRlJFRCBNU1JzIHRvIHg4
NiBDUFVBcmNoU3RhdGUgZm9yIGxpdmUgbWlncmF0aW9uIHN1cHBvcnQuDQo+ID4NCj4gDQo+IElN
TywgaXQncyBiZXR0ZXIgdG8gc3BsaXQgdGhpcyBwYXRjaCBpbnRvIHR3bywgb25lIGlzIGZvciBG
UkVEIE1TUiBhY2Nlc3MsIHRoZSBvdGhlcg0KPiBpcyBmb3IgTE0gc3VwcG9ydC4NCj4gDQo+IEFu
ZCBtb3ZlIHRoZSBGUkVEIE1TUnMgZnJvbSBiYXNpYyB4ODZfY3B1IHBhcnQgdG8gLnN1YnNlY3Rp
b25zIHBhcnQgYmVjYXVzZQ0KPiBGUkVEIGRvZXNuJ3QgYmVsb25nIHRvIGJhc2ljIENQVSByZWdp
c3RlcnMuwqAgSW4gdGhlIC5zdWJzZWN0aW9ucyBwYXJ0LCB5b3UgbWF5DQo+IGRlZmluZSBhIHN0
cnVjdCB0byBob2xkIEZSRUQgTVNScyB0aGVuIGFkZMKgIC5uZWVkZWQgY2FsbGJhY2sgaGVscGVy
IGZvciBRRU1VIHRvDQo+IHF1ZXJ5IHdoZXRoZXIgRlJFRCBNU1JzIGFyZSBuZWNlc3NhcnkgZm9y
IGxpdmUgbWlncmF0aW9uLg0KDQpHb29kIHBvaW50IQ0KDQo+IA0KPiBTZWUgb3RoZXIgZmVhdHVy
ZXMsIGUuZy4sIHZtc3RhdGVfbXNyX2ludGVsX3NneA0KDQo=
