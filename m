Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD526C7CC9
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 11:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCXKmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 06:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCXKmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 06:42:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02EC23DAB;
        Fri, 24 Mar 2023 03:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679654520; x=1711190520;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nT3eZXpN9nmAwJMleoNJWIDuYaSItn9ns+OKA6+LVzg=;
  b=SkHSaR4crdMajLQ0qvqgw9mDR9GjMaQdyRfIAidIJpNeeqczvsHtl25F
   buQaHgwLaF0EtnGSGzo6TUWQL5l3tU/N3DXz7xXR0CPyc8tzbT+smdIoI
   XSKQr9z0YXwZx28RWU3TWu0Q2BdylzRzDlp/wVFxcEWW/6+h//naFsq5Q
   nQ9ZN/G5ZgxCN1D/aZUqYWZoa2Da0F5mNC07BLYe0bH8LJVkSOZGh1tSp
   EpR0Lnv9FIUFYocejO+SBjJgl61nL9pdeXUXzW98BAzWU1cgVdCDY2IIS
   WXhujK9cBxNSIni6WJ+QfMymy0kDDl1jfAcRYJL7mDjRKnyf7uZZShHB1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="339774619"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="339774619"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 03:42:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="793401132"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="793401132"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 24 Mar 2023 03:42:00 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 03:42:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 03:41:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 24 Mar 2023 03:41:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 24 Mar 2023 03:41:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPbm0im9eHH/VMKLdRzjtje3+wxCOlrgAlAv6gyaCRrza78sskccEKREJLT1sarAUVgEBrDMLKdwzAwOnFr9dj5MbyWypLODnzrhq0og9KgnNIPlaFjj6q36AwSXmkfZoSU0ORiD8ahLDzAfFcLQwbxlSZCrcOOGRCSt+PGVNLWVAdOToLQYA21dpBCsF+uP18otVTLcnEw28tMi6c6ILE+wvjIU3yZ0JrJRTHjAMEfypkfc2X8gj5bZWiGR2Ewo2S3ZjZoGAYHhFd4J/NH43HKATypouafF2ym54Wjeb4nI6ylAaLywrzgbbDIKpAXEPokn+n8Xm+SS7Ru0uKU5bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nT3eZXpN9nmAwJMleoNJWIDuYaSItn9ns+OKA6+LVzg=;
 b=RZDYM3w5AU/CsPUvA8O8DOn2mBkwSqZbAabzBuIvUDmifUUqWmSOq7bQqNnM5c7k+3tLoWTiPOd5rGAvMdNLmYmUapjgBBiyR4tKxERHGuNE7Kfi0J1Dg/XBtqPMYow4A+NO8WBLfvfl/HIm+O5xqsIeG9OHKCHmfjAG478VoicG11jQivoQsPs6Tu+GNLSNRmOZaQ6Q1LJWQieQcTTXBWmGosrKb+s7jNuxbWz78bRxmXET3K969Ltqfsz5IEgOQFnZtRMci+WXi6vCAPF+4p1YrjvI7x9OaoIVxF/1RUlYEg1RsjFjlT5kJyKQDhL8uBUra3wWPdDlSgSnTXkKtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7399.namprd11.prod.outlook.com (2603:10b6:8:101::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39; Fri, 24 Mar
 2023 10:41:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%6]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 10:41:56 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZVQwsPOGReWj5Uka2uRq42SaKMa75keeAgAHjHYCAACbFgIAA9iwAgA0+bwA=
Date:   Fri, 24 Mar 2023 10:41:56 +0000
Message-ID: <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
         <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
         <20230315072711.GF3922605@ls.amr.corp.intel.com>
         <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
         <20230316002702.GA197448@ls.amr.corp.intel.com>
In-Reply-To: <20230316002702.GA197448@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB7399:EE_
x-ms-office365-filtering-correlation-id: 05cfd77f-0928-4af4-8503-08db2c54637e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4l5kK89grwiUcRIxwN+10kRGRyLYkdAEAeAKbBoihHnv+L9GBQ6dTWGRnhUyr6UirQ+8IxY3mErl9LlduZTSEGkUnAUKjghzDmND4eueGOoMlH11dktYWRbGznjWiwBM88fj3ST8SrdtEq8z0DR/1/5tvvZQTbjUxF5U4/plw3ZzSbhd9ngfS0bm6TCpglgsK03a0TzvUGUD8rVpICHqgJ2uAbEwp/loXfFZwjwcg6EuvHtQc+FqLuVF9aTq8IIs0OYChoH6la+XhO8dyJ6qvS66wxOyCqj+GIVGj4DoMm7WOJSmFCMp/ZpZqT9kaem5PZL/i0cRKDimUItEw+ibV+6APn/fotd4zv7f4LbPWbqlQIT2IfiFXFKJUNb9LIRXOyQ/UF/CvqmYUxr8BZno4GhUuxc2HmTqH13ZQd5qy2vHU/qdXQ+Z9keeEWvSgmoeqU2b1zEhLOCYfRPFKVJVohPGZ0jV4ZYA1DVl6qEUVDPzApc2GWP1UKE5YSAi5OuoR4vzjy54/pa9ll+6PNB+rknUThOtRf0qy4HzEyUYi2rEHB4zPs4PSPsrCxZ8LzpcNBHGgr3mllvqCf2EqwWGA3BNX/HLDcmflCfNKGeV6QRUZ7ln7BRDbPvAyMSNHMCczumxabKdD7dsJjmeWUvrzQDLfLVYr32Rj/M2a52tlFhzXXIRtch+xmsiKpOslVmUYaw0ry/azxm2XKFhZZgbE9/x8g442l77I+TDBCPVJ9E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(36756003)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(6916009)(4326008)(91956017)(8936002)(41300700001)(71200400001)(478600001)(6486002)(316002)(54906003)(2906002)(5660300002)(82960400001)(38070700005)(86362001)(122000001)(38100700002)(6512007)(6506007)(186003)(26005)(107886003)(83380400001)(2616005)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3ZpeVBvYm1IZFhkSmk3dVhzWWtkTGpJUXJUazdXVzZBdC9LcjU5VG9yVGp1?=
 =?utf-8?B?cGZhNkM5b1VwK0tFYS9JeW1RWTE2WDB6d1RkMEJtakpkKzcwOXhQeVhzTWRw?=
 =?utf-8?B?d003cENaS0JlaktjRnRKOVhXZWhpam0rMzJDbVRpcTViOTB0WVZEWXZnL3oz?=
 =?utf-8?B?enprcEV3YmhDclNiY0U4M0w4bXVVcERjTWNrbUZkTWJGWHEveUhWeFNNVm1O?=
 =?utf-8?B?YkZjSXMwNVcrSXV0ckhjV0FHL1AwaUcxdlhxMHhYeE5md1VCOWRORjFMbUJ0?=
 =?utf-8?B?TDQ3WHlWSXFFMkxOdWRxNkV0Rk82MTJ4TTBobjBzYzM2YWJyaUVhTng1UVVn?=
 =?utf-8?B?My9GZzhOZjhLNUU2T3J2TGtlWW5SRjRPcDcxaGlCamMxYndBQ295VTVNdUN6?=
 =?utf-8?B?bGUwbWZrMWRWNmszZjArU2JqelR3ak93N2FPRS95RDBBQmN4b0hodmtaT1M4?=
 =?utf-8?B?aW9NU0FmelllNkpxS3M2RkgwYVp0eFdhaHNObWxZNm95ckVkd3hOeUN4NDN3?=
 =?utf-8?B?Wng3amtEYnUvYVlCcW1naGhtSzN5d25TZlVWUzhlVjVsOWhaK01xS2ZROE9i?=
 =?utf-8?B?anVEbEhPYWlaWkJUd2ZZK3hDQ3lHUVVTNzcveXVMOHBmT1lRQ2JMblc0VHlm?=
 =?utf-8?B?NmRrVGN1QXpYbFBXcDQ3VmthaVNOYUZHOVpNQkk4TUNJbXRxZFdPaEdMaWZP?=
 =?utf-8?B?MjYwQ3ROenZISm5Ia3ZtNGh5SkJvK09UT2dDYXk5TE1sdW9GMGZzK0JSeTV4?=
 =?utf-8?B?V1k3aWVlbTRNd1MvV3FEVXRaRkRKYW1IdU1MQlZCNm9rdEw1UUxMaEQ1YkFj?=
 =?utf-8?B?WUVMTnlseW5FSmpTTTFwQ2hOODcvL1dhNXJuYXk3R0lYSTh6Wk95dzNFMkVJ?=
 =?utf-8?B?dEJROU5LYm8wbGdBaitXay90L3plSFc3c25ENWk3RU4rSWhDZGZRVW9YcGEz?=
 =?utf-8?B?cjByVXNvTDhvMkloOTFuMFJmMnE2OEs3NTF2Y2x4aWNHU1h6QjNXWWZRVHRj?=
 =?utf-8?B?WjRNZ1M1S2pVSGprSFcrRFRYeiszZ3lFenp3YkNqNjJoYXhnSHFMcWhLem03?=
 =?utf-8?B?M1c3dVBIRnpxaWp6VjZjRmZhZWdOeHA3d1NaMXdOd1pqczdtMlpINTFmOXky?=
 =?utf-8?B?WDR4ODZDcERrakVDWXJ0Ui9YNDV3eEJUNEFtelFjSG1vT0d6eEcyZ0RRN1I0?=
 =?utf-8?B?MU1PWVd3UzhqcmVQTkNWZjBhTzJWb1J0eHNpYXpyc2FEdW01YThvSnUrdmZa?=
 =?utf-8?B?OWdGbU5iZys1dXVxcHVpVUJhQXUwZ0luQjkyNFBJcXBGNUxVNmFwQlJ1VWFJ?=
 =?utf-8?B?aXVacXlCdWxDajVaam82VkFNTGxmYUhaZE93SmpDcXc1UW1kWk9tTnUxOFk4?=
 =?utf-8?B?b3ZDVDdpcnR4bU1maUVLaTV4R0pWMWZadjZMaXliSmFJQUQrVHlCWU1GMkRU?=
 =?utf-8?B?RmdkNnRxek9PTTZXWEw1Uk1LdXlabWVURUZsSGd6RWdYYzdrRUMzT1o5S1lL?=
 =?utf-8?B?M0tMNWZrYUlhbnhnWW9XK0hCSWt1bk1DN3hBVFFEdk1ua29NTEE5aHlwTFNN?=
 =?utf-8?B?V0s5RHlSRWJhc3EzYkNiS2F6Z2pXa1B2UHlzRVVPRGhoUkc0a09XMmk4cmRO?=
 =?utf-8?B?NVdnSW1SUDVNdHVXT0t4TjhvcUlVbENianN0a1lPK0IzbTNwOFBNUGdxMFAv?=
 =?utf-8?B?NFhYaDJ6UGJUT2o0eE5FQkxRUlBTUTBBV3VzT05qOGhRSEg3RXBUUDRwVTRC?=
 =?utf-8?B?TUQycWtPajIzMVc3Q1RVOHQva0t4VW1sc0ZCdklROERsRE1MT1dSOWNwbzFG?=
 =?utf-8?B?UzRsMXZ6QUpnNU9aaEM3cWJKWlJrd1pXNUJIQmREQmMzTUdqSW9lZWFreUdV?=
 =?utf-8?B?c1kvdHhpQWgvL0pqQ1REaFRIZkt1MVNFdHA4ZlErRUNqdTR1eFZWOWdwR2Zw?=
 =?utf-8?B?cmU5Y1g2MXhWcFhjaHZyclAxRFlPeHUxMW1takh2Mm4wRm8xV3k3Mm1pYWw4?=
 =?utf-8?B?OHV0a0d4SDJiaHF2RFdCVXl3RVlYbWIwME5Rb3QrNGtRVElHRHlZM0p0OGxN?=
 =?utf-8?B?eC9KdzVEbDVxa0lueEYybkpPSFlIM015MzhDbW1SeGlPQzdQOFRndkt5ZjJQ?=
 =?utf-8?B?cUdmUDRKd2FZbE5zSVFCeFJKWWRvUlExSUNabmhyTXl1Uk43V0doWW1rTlBk?=
 =?utf-8?B?a2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <266171DDB45DF64F8A67EC00094FE77F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05cfd77f-0928-4af4-8503-08db2c54637e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 10:41:56.0543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SupHCs+5QPqa3yseqw2nC6N5Vih/l6Mu4DODRrXB8ElCyES02age/mDqg3DvOMo4vVV4jYed2yUQEhyeH06VOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7399
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U29ycnkgZm9yIGxhdGUgcmVwbHkuDQoNCj4gIA0KPiArc3RhdGljIGJvb2wgZW5hYmxlX3RkeCBf
X3JvX2FmdGVyX2luaXQ7DQo+ICttb2R1bGVfcGFyYW1fbmFtZWQodGR4LCBlbmFibGVfdGR4LCBi
b29sLCAwNDQ0KTsNCj4gKw0KPiArc3RhdGljIGludCB2dF9oYXJkd2FyZV9lbmFibGUodm9pZCkN
Cj4gK3sNCj4gKwlpbnQgcmV0Ow0KPiArDQo+ICsJcmV0ID0gdm14X2hhcmR3YXJlX2VuYWJsZSgp
Ow0KPiArCWlmIChyZXQgfHwgIWVuYWJsZV90ZHgpDQo+ICsJCXJldHVybiByZXQ7DQo+ICsNCj4g
KwlyZXQgPSB0ZHhfY3B1X2VuYWJsZSgpOw0KPiArCWlmIChyZXQpDQo+ICsJCXZteF9oYXJkd2Fy
ZV9kaXNhYmxlKCk7DQo+ICsJcmV0dXJuIHJldDsNCj4gK30NCj4gKw0KPiArc3RhdGljIF9faW5p
dCBpbnQgdnRfaGFyZHdhcmVfc2V0dXAodm9pZCkNCj4gK3sNCj4gKwlpbnQgcmV0Ow0KPiArDQo+
ICsJcmV0ID0gdm14X2hhcmR3YXJlX3NldHVwKCk7DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0dXJu
IHJldDsNCj4gKw0KPiArCWVuYWJsZV90ZHggPSBlbmFibGVfdGR4ICYmICF0ZHhfaGFyZHdhcmVf
c2V0dXAoJnZ0X3g4Nl9vcHMpOw0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gICNk
ZWZpbmUgVk1YX1JFUVVJUkVEX0FQSUNWX0lOSElCSVRTCQkgICAgICAgXA0KPiAgKAkJCQkJCSAg
ICAgICBcDQo+ICAgICAgICAgQklUKEFQSUNWX0lOSElCSVRfUkVBU09OX0RJU0FCTEUpfAkgICAg
ICAgXA0KPiBAQCAtMjQsNyArNTQsNyBAQCBzdHJ1Y3Qga3ZtX3g4Nl9vcHMgdnRfeDg2X29wcyBf
X2luaXRkYXRhID0gew0KPiAgDQo+ICAJLmhhcmR3YXJlX3Vuc2V0dXAgPSB2bXhfaGFyZHdhcmVf
dW5zZXR1cCwNCj4gIA0KPiAtCS5oYXJkd2FyZV9lbmFibGUgPSB2bXhfaGFyZHdhcmVfZW5hYmxl
LA0KPiArCS5oYXJkd2FyZV9lbmFibGUgPSB2dF9oYXJkd2FyZV9lbmFibGUsDQo+ICAJLmhhcmR3
YXJlX2Rpc2FibGUgPSB2bXhfaGFyZHdhcmVfZGlzYWJsZSwNCj4gIAkuaGFzX2VtdWxhdGVkX21z
ciA9IHZteF9oYXNfZW11bGF0ZWRfbXNyLA0KPiAgDQo+IEBAIC0xNTksNyArMTg5LDcgQEAgc3Ry
dWN0IGt2bV94ODZfb3BzIHZ0X3g4Nl9vcHMgX19pbml0ZGF0YSA9IHsNCj4gIH07DQo+ICANCj4g
IHN0cnVjdCBrdm1feDg2X2luaXRfb3BzIHZ0X2luaXRfb3BzIF9faW5pdGRhdGEgPSB7DQo+IC0J
LmhhcmR3YXJlX3NldHVwID0gdm14X2hhcmR3YXJlX3NldHVwLA0KPiArCS5oYXJkd2FyZV9zZXR1
cCA9IHZ0X2hhcmR3YXJlX3NldHVwLA0KPiAgCS5oYW5kbGVfaW50ZWxfcHRfaW50ciA9IE5VTEws
DQo+ICANCj4gIAkucnVudGltZV9vcHMgPSAmdnRfeDg2X29wcywNCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IG5ldyBmaWxl
IG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uZjEzZmRmNzE0MzBiDQo+IC0tLSAv
ZGV2L251bGwNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBAQCAtMCwwICsxLDQ2
IEBADQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArI2luY2x1ZGUg
PGxpbnV4L2NwdS5oPg0KPiArDQo+ICsjaW5jbHVkZSA8YXNtL3RkeC5oPg0KPiArDQo+ICsjaW5j
bHVkZSAiY2FwYWJpbGl0aWVzLmgiDQo+ICsjaW5jbHVkZSAieDg2X29wcy5oIg0KPiArI2luY2x1
ZGUgIng4Ni5oIg0KPiArDQo+ICsjdW5kZWYgcHJfZm10DQo+ICsjZGVmaW5lIHByX2ZtdChmbXQp
IEtCVUlMRF9NT0ROQU1FICI6ICIgZm10DQo+ICsNCj4gK3N0YXRpYyBpbnQgX19pbml0IHRkeF9t
b2R1bGVfc2V0dXAodm9pZCkNCj4gK3sNCj4gKwlpbnQgcmV0Ow0KPiArDQo+ICsJcmV0ID0gdGR4
X2VuYWJsZSgpOw0KPiArCWlmIChyZXQpIHsNCj4gKwkJcHJfaW5mbygiRmFpbGVkIHRvIGluaXRp
YWxpemUgVERYIG1vZHVsZS5cbiIpOw0KPiArCQlyZXR1cm4gcmV0Ow0KPiArCX0NCj4gKw0KPiAr
CXByX2luZm8oIlREWCBpcyBzdXBwb3J0ZWQuXG4iKTsNCg0KQm90aCBwcl9pbmZvKClzIGFyZSBu
b3QgcmVxdWlyZWQsIGJlY2F1c2UgdGR4X2VuYWJsZSgpIGludGVybmFsbHkgcHJpbnRzIHRoZW0u
DQoNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiAraW50IF9faW5pdCB0ZHhfaGFyZHdhcmVf
c2V0dXAoc3RydWN0IGt2bV94ODZfb3BzICp4ODZfb3BzKQ0KPiArew0KPiArCWludCByID0gMDsN
Cj4gKw0KPiArCWlmICghZW5hYmxlX2VwdCkgew0KPiArCQlwcl93YXJuKCJDYW5ub3QgZW5hYmxl
IFREWCB3aXRoIEVQVCBkaXNhYmxlZFxuIik7DQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArCX0N
Cj4gKw0KPiArCS8qIHRkeF9lbmFibGUoKSBpbiB0ZHhfbW9kdWxlX3NldHVwKCkgcmVxdWlyZXMg
Y3B1cyBsb2NrLiAqLw0KPiArCWNwdXNfcmVhZF9sb2NrKCk7DQo+ICsJciA9IGt2bV9oYXJkd2Fy
ZV9lbmFibGVfYWxsKCk7DQo+ICsJaWYgKCFyKSB7DQo+ICsJCXIgPSB0ZHhfbW9kdWxlX3NldHVw
KCk7DQo+ICsJCWt2bV9oYXJkd2FyZV9kaXNhYmxlX2FsbCgpOw0KPiArCX0NCj4gKwljcHVzX3Jl
YWRfdW5sb2NrKCk7DQo+ICsNCj4gKwlyZXR1cm4gcjsNCj4gK30NCj4gDQoNClsuLi5dDQoNCg0K
PiAgI2VuZGlmIC8qIF9fS1ZNX1g4Nl9WTVhfWDg2X09QU19IICovDQo+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gaW5kZXggMjEyNWZjYWEz
OTczLi5iMjY0MDEyYTg0NzggMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiAr
KysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gQEAgLTk0MzUsNiArOTQzNSwxNiBAQCBzdGF0aWMg
aW50IF9fa3ZtX3g4Nl92ZW5kb3JfaW5pdChzdHJ1Y3Qga3ZtX3g4Nl9pbml0X29wcyAqb3BzKQ0K
PiAgDQo+ICAJa3ZtX2luaXRfcG11X2NhcGFiaWxpdHkob3BzLT5wbXVfb3BzKTsNCj4gIA0KPiAr
CS8qDQo+ICsJICogVERYIHJlcXVpcmVzIHRob3NlIG1ldGhvZHMgdG8gZW5hYmxlIFZNWE9OIGJ5
DQo+ICsJICoga3ZtX2hhcmR3YXJlX2VuYWJsZS9kaXNhYmxlX2FsbCgpDQo+ICsJICovDQo+ICsJ
c3RhdGljX2NhbGxfdXBkYXRlKGt2bV94ODZfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdGliaWxpdHks
DQo+ICsJCQkgICBvcHMtPnJ1bnRpbWVfb3BzLT5jaGVja19wcm9jZXNzb3JfY29tcGF0aWJpbGl0
eSk7DQo+ICsJc3RhdGljX2NhbGxfdXBkYXRlKGt2bV94ODZfaGFyZHdhcmVfZW5hYmxlLA0KPiAr
CQkJICAgb3BzLT5ydW50aW1lX29wcy0+aGFyZHdhcmVfZW5hYmxlKTsNCj4gKwlzdGF0aWNfY2Fs
bF91cGRhdGUoa3ZtX3g4Nl9oYXJkd2FyZV9kaXNhYmxlLA0KPiArCQkJICAgb3BzLT5ydW50aW1l
X29wcy0+aGFyZHdhcmVfZGlzYWJsZSk7DQo+ICAJciA9IG9wcy0+aGFyZHdhcmVfc2V0dXAoKTsN
Cj4gIAlpZiAociAhPSAwKQ0KPiAgCQlnb3RvIG91dF9tbXVfZXhpdDsNCg0KSG1tLi4gSSB0aGlu
ayB0aGlzIGlzIHVnbHkuICBQZXJoYXBzIHdlIHNob3VsZCBuZXZlciBkbyBhbnkNCnN0YXRpY19j
YWxsKGt2bV94ODZfeHh4KSgpIGluIGhhcmR3YXJlX3NldHVwKCksIGJlY2F1c2UgaGFyZHdhcmVf
c2V0dXAoKSBpcw0KY2FsbGVkIGJlZm9yZSBrdm1fb3BzX3VwZGF0ZSgpIGFuZCBtYXkgdXBkYXRl
IHZlbmRvcidzIGt2bV94ODZfb3BzLg0KDQpTbyBwcm9iYWJseSB1c2UgaGFyZHdhcmVfZW5hYmxl
X2FsbCgpIGluIGhhcmR3YXJlX3NldHVwKCkgaXMgYSBiYWQgaWRlYS4NCg0KSSB0aGluayB3ZSBo
YXZlIGJlbG93IG9wdGlvbnMgb24gaG93IHRvIGhhbmRsZToNCg0KMSkgVXNlIFZNWCdzIGt2bV94
ODZfb3BzIGRpcmVjdGx5IGluIHRkeF9oYXJkd2FyZV9zZXR1cCgpLiAgRm9yIGluc3RhbmNlLA0K
c29tZXRoaW5nIGxpa2UgYmVsb3c6DQoNCmludCBfX2luaXQgdGR4X2hhcmR3YXJlX3NldHVwKHN0
cnVjdCBrdm1feDg2X29wcyAqeDg2X29wcykNCnsNCgkuLi4NCg0KCWNwdXNfcmVhZF9sb2NrKCk7
DQoJciA9IG9uX2VhY2hfY3B1KHZ0X3g4Nl9vcHMuaGFyZHdhcmVfZW5hYmxlLCAuLi4pOw0KCWlm
ICghcikNCgkJciA9IHRkeF9tb2R1bGVfc2V0dXAoKTsNCglvbl9lYWNoX2NwdSh2dF94ODZfb3Bz
LmhhcmR3YXJlX2Rpc2FibGUsIC4uLik7DQoJY3B1c19yZWFkX3VubG9jaygpOw0KDQoJLi4uDQp9
DQoNCkJ1dCB0aGlzIGRvZXNuJ3QgY2xlYW4gdXAgbmljZWx5IHdoZW4gdGhlcmUncyBzb21lIHBh
cnRpY3VsYXIgY3B1cyBmYWlsIHRvIGRvDQpoYXJkd2FyZV9lbmFibGUoKS4gIFRvIGNsZWFuIHVw
IG5pY2VseSwgd2UgZG8gbmVlZCBhZGRpdGlvbmFsIHRoaW5ncyBzaW1pbGFyIHRvDQp0aGUgaGFy
ZHdhcmVfZW5hYmxlX2FsbCgpIGNvZGUgcGF0aDogYSBwZXItY3B1IHZhcmlhYmxlIG9yIGEgY3B1
bWFza190ICsgYQ0Kd3JhcHBlciBvZiB2dF94ODZfb3BzLT5oYXJkd2FyZV9lbmFibGUoKSB0byB0
cmFjayB3aGljaCBjcHVzIGhhdmUgZG9uZQ0KaGFyZHdhcmVfZW5hYmxlKCkgc3VjY2Vzc2Z1bGx5
Lg0KDQoyKSBNb3ZlIHRob3NlIHN0YXRpY19jYWxsX3VwZGF0ZSgpIGludG8gdGR4X2hhcmR3YXJl
X3NldHVwKCkgc28gdGhleSBhcmUgVERYDQpjb2RlIHNlbGYtY29udGFpbmVkLiAgQnV0IHRoaXMg
d291bGQgcmVxdWlyZSBleHBvc2luZyBrdm1feDg2X29wcyBhcyBzeW1ib2wsDQp3aGljaCBpc24n
dCBuaWNlIGVpdGhlci4NCg0KMykgSW50cm9kdWNlIGFub3RoZXIga3ZtX3g4Nl9pbml0X29wcy0+
aGFyZHdhcmVfcG9zdF9zZXR1cCgpLCB3aGljaCBpcyBjYWxsZWQNCmFmdGVyIGt2bV9vcHNfdXBk
YXRlKCkuDQoNClBlcnNvbmFsbHksIEkgdGhpbmsgMykgcGVyaGFwcyBpcyB0aGUgbW9zdCBlbGVn
YW50IG9uZSwgYnV0IG5vdCBzdXJlIHdoZXRoZXINClNlYW4vUGFvbG8gaGFzIGFueSBvcGluaW9u
Lg0KDQoNCg0KDQo=
