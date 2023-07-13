Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F49E751AC6
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbjGMIFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbjGMIFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:05:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14FF3A84;
        Thu, 13 Jul 2023 01:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689235390; x=1720771390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=z/gXuy5DiS528PH+c0UsZCb3Vhx1p3wBt6sSwfyhi/Q=;
  b=cdCn+cd95caQkyL9R19R9uboqAYRXB1EuKxJu/v3F6trHVvg/vvnyknn
   GlmGoN+xDairCNnNy+ekNxY3A4cFpy159rqLHdgf3/AnzfbKLpeaLFTmy
   /euzwkbZ/0Xr5jRWmvsRKc0qdPry3OeC7Svn4thuLOa3X3mLjjvTZhoJH
   5izA6mgWtyh8CKyssPh+wxWxPJqNzoiq+gzcGdLzfWoz44wFIeOmg0UB9
   J0n9B78VMN2nVGFBM8aFbl7Td0cB9gLAsCzYK6L0WBtxXEzl0slHmRtqs
   tt3D6DGKjW+9Qqp22aQyl4sWr4rdzjuz2CX5ZSaqMIPM2cV7oH8NfwpKY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428870669"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="428870669"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 01:02:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="757067342"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="757067342"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 13 Jul 2023 01:02:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 01:02:58 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 01:02:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 01:02:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 01:02:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuhpWcnLXt48lbADr/RAmmjSb1QtqbzA0FZ4RScx09pcILYMT6SGStP2khj1sy8Z27omEWFFjrNEob5LDTa8jkKhBhgVz9NlS6yIL4aLewWDOSHOUCJ+HbypXXjcw/3O74QZPFbluzscy74wyzHFb6e6i9LcPecN0rxtMRklrrIWgOPt4MtLJjyg0rZNlq9JcP8NNMc1RmHSmw/1U1GnBt8tPQ1fN3iy0FNi+njvUMnhbcW442duPAteRz437xL6bP1VJePHqsTq8ooKRynzEITIRK5fePSdvQ8TarmuXVlP8l+VcH8/3t0YIblPf6yL3xhJ07PqpTZAkhgBGvEGSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/gXuy5DiS528PH+c0UsZCb3Vhx1p3wBt6sSwfyhi/Q=;
 b=cFJYS3Vk/V/k92PtCllVs7qO/3XuPPUqFaUddgOQ5xcnVwZqyy4zpurWR9yayK/SDm+bB8bf3wp//3pHt3+AdoMdZH4LVCdER5jFox2F40Sbqgv8FS8v8RStVO0SsaJR6Xh3zDil0ZYVqxFXLIs/PAXlU0Om9ES2rb1USP++JMNu6/89PD7JX4Baw/3uPJxN4FsgnXwjG55RKiRL8wkjrDc7E38wyHD8x74gk8VG0t7DZsFaAM2L5wRjIKZXtcv9RZU7Bx+xvsR15Q3ssv5RFWtgRwgzURzANYMxIgsj9auoTS4zEjeD3Or4MU+FcGX1oPVNvhR4UBcVklvaBohcNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB8353.namprd11.prod.outlook.com (2603:10b6:208:489::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 08:02:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 08:02:54 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Topic: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2WZEAgAABkQCAAPx6gA==
Date:   Thu, 13 Jul 2023 08:02:54 +0000
Message-ID: <cc5b4df23273b546225241fae2cbbea52ccb13d3.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
         <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
In-Reply-To: <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB8353:EE_
x-ms-office365-filtering-correlation-id: 1f9c5770-a264-4344-bd8a-08db83778fdb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Uf045LMAxTSTBfZN+bVtYC6Gym+kXYoWuQJw+9y4k8V2qUpG1EfZTeQnJJQYOu6xd/QuOOd7ZggJB8WnmNbbYlXdbLlM0JoV7JP6q8NdAgaeBENsuMK9HSeviGgkEeTKHYw5b4CYvqqKkdILIO0PRtFMJ1tUgdDBwwnPKrN1eL8J22QAzH6HCQbZVuXBrebHMFSpcVzPvV6RfxSDLvXo+OqXtvdq8ufi0J5rI2w9vzUn1eAmxoWTJMQPdnvD0fdSF2t8rk+BEnubsun8D2vYuyKkMgEW69gHYAoPBnhIa1CQaz85VQ4qE9pShe9gquM09XtEaupGagPvEYW0N3FoKhuaoSXej4OyIAfyjs6XOi9uNTNCkYek81tjvkR2v81ChLN5K8KurRuz8C48aA4/W2n8gzvwPxm/9jepgJ1mEFg5sf+Ygenjv3FjZD0xvFBA4uZx7D+KHldwSpmeCEI3vLNk8vVErq8q8s/o2w7MkPyaennk2C2GYJDDer4FyFmGVJG8s9uQrcMJmPrinv+BZBqFAc2A35uDdM/i8pfgnDKo85um83hqL+PVnuwuFsbZynczh411nPokvp9zosBac5KiqzYEuD5zVtzeQgOprnj7lGH+8OpDq3h3oOZV+5Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199021)(54906003)(76116006)(6486002)(478600001)(91956017)(71200400001)(186003)(6506007)(6512007)(2906002)(66946007)(5660300002)(316002)(4326008)(66476007)(8936002)(66446008)(7416002)(66556008)(41300700001)(6916009)(64756008)(82960400001)(26005)(38100700002)(8676002)(122000001)(38070700005)(83380400001)(36756003)(2616005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEdPSGY1UjE3YlcxeGZoRTZGdkVSQk9wWWpTNEdaZzZvYktzY05PMERzdXR1?=
 =?utf-8?B?MHMyVHZIYkNwRUNJLzRXbkxQdExtNjVVWHFLZnUrVDRTaENWd3VUTm9SRlhq?=
 =?utf-8?B?dEtrNDJHeHJ6SDFCcUE4U1czWXNEa3gybGpJQm0xZ2xkUFJ0OG1qM3lQaWVl?=
 =?utf-8?B?RDh5SDZldzRrODk1eGV5TC80eFd0bXZrSTJxb0N2QW5rVkYrQUJpYmhPWWU1?=
 =?utf-8?B?N3NHRHdYSWdjWERINStCRit3MjBVTEd0eTM2STN5T0VOcUljZWNtWHdyUE5D?=
 =?utf-8?B?RXphblpVWjBtYnRDV3Ura2NMejlZVG83TGhTQWM2Z3BkTlV5d3hqYW1RSVFa?=
 =?utf-8?B?amtUYlpNS3hqY1I5eHFjLzIwNndNclplaTU1a0RJcUtsTkN4K0YxbWxQNW9a?=
 =?utf-8?B?dWRHeUtOZHFPZU1rem9jUHBldGFqQkdDcENOTlNWNnpIenVqOFFtc2xoTWoz?=
 =?utf-8?B?YmxqVFFQcG1uU2p3YjNoU05YV2FPSTZYeXd2RklSZjg4RUFSak0xU2NiTmdO?=
 =?utf-8?B?bFZ6K3Q5dS85dXNybUdnTUNZY3VTZGU3Z095alAvbExGc09Ed3JvRm5zbHp2?=
 =?utf-8?B?VTlhNitNZW1zanQyT0dIeFRRV3RxZFA3VU1vL2xZTjZaNVpLbTkwWFFNRHp4?=
 =?utf-8?B?eVdxeVJRUktuZHlsaEJVSGVNSk5zWUxZNk91ZUsrUDNWM1FZMUV1cUJMeFJT?=
 =?utf-8?B?RW5kMTkrUHF1eVJKVFY1cDI2ODBJRGtYb1JCVkdyVzhVYUIxekJqZ0x2N1A1?=
 =?utf-8?B?VGxKM2g2MWNFTDJaT2tRMHFlSWpOdVY3UE9MbG53MGVYMHZjUW9LTGg0Y0dn?=
 =?utf-8?B?MjJoNkRsWW9yL1Z1cEJ2d2ZOSjNmaWwvREJidXhQWlFWUlhaV2xtZ2F6dUor?=
 =?utf-8?B?NkhkZlhDOWQxV2lpK0RsME9yT0Q0WlJKSkk1ZkNZUHU2cytPcmdESzlGSUwr?=
 =?utf-8?B?d2ZVSFlyQjN5dTBHL241VzlNMHEyWWd6eG9GUGQ1ZFNoMHROVktRM01nUGVZ?=
 =?utf-8?B?MllxMkdkTXU4bWw5VlJRYmM2YUJCdk5DbnI1UUJTbkJ3YW1aRzNxcDNYbGRq?=
 =?utf-8?B?NitCRE1qbHd6Vk9LRVhJRnYrUUlQNWJQTElzNE14ektsVzV2bDkrclpMTHdI?=
 =?utf-8?B?Ukl5c3kwVisxM0V3cWdIYi9WWG1qdEM5UnR4RHhsNlBLOTB0V280Tk1XUVJy?=
 =?utf-8?B?ZmxCdkVjQXNpNm5uY2lONmk4Z09FSjk5ZVh4bGF4YjBqUGppSTJzandxenlM?=
 =?utf-8?B?ODU4TE1EQ1BNMlB3N3liNFliVG9QWW42aWFMcy8rR1d5VXZMWWk3M2o5TWx0?=
 =?utf-8?B?Ti8ra2NRTG1KdXdtd0Q5NWR4WnllT3lsTzdZYXg5anlzc1E3V3FaUjg4cHN4?=
 =?utf-8?B?WTF4dkZabEh3Zzhmd1RPZzVXUGVuTzMxekZiTDk3M3ZjSXJjcWR5bWFMRWlD?=
 =?utf-8?B?L0o1ZU1jbnp5VHlGS0Y0TUxNS0U5RDlyTlB4U0d4NndsREMyUFEvMmtCQVUx?=
 =?utf-8?B?NG55QVlGVUNMOU1JSzhJSlhRb28vWFBjcDVwUGZkNmpVWUdQeExFejJWVVdG?=
 =?utf-8?B?U2phV2xtU1NGSFNOWXlna0VsRDRjQ1phTjRpanFqMjh3bDZOUFMvd2hyOVJC?=
 =?utf-8?B?bGlPd0JPcXVnVnZXaE9Ob0NmaUxqVjQ2YVlOZmFYYklZdWpLOTQ2cnNPYnFO?=
 =?utf-8?B?REx4RFMrclFqcTJqUlZtZUljR3BaTUYvQWhWWlRLSDFVdldzZHp4UWlDdkMv?=
 =?utf-8?B?cjJpT2JkMUFRbmthMDZtRU9vQUgzMlZZVkhQSWJZeTkzMDJ0aXNoeUtVSzNG?=
 =?utf-8?B?NlN5T1lDdDByYWY3ZzhjTStrdWJXMjlmelNxdmdpRk9HTU1RaFNUY1pUZGNa?=
 =?utf-8?B?NlFPSkhYc1MxNzdYYjJQSnN1QXhEaHpOUHQ2UTd2QXdIQmZuZzZ6MURIZ3or?=
 =?utf-8?B?SFlKQmJVTVNnZnJoRlhjRHdqU21BOExnOXFDN2EvRElUNVEyQ0wzTng3UUxu?=
 =?utf-8?B?QlVDRHE2SFdsQzFic2dSU0hGK3ZkbERaU21wb00yVk14V3RndGFJR3hEUVFl?=
 =?utf-8?B?YkZnRmFRdi9sTVQxRTBma2dRaVVjU2JsRGtTVVpLeWJUR1g0aVgzSWVVdHh6?=
 =?utf-8?Q?IW5bnzb8JXKWOVod12vvT85Zq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D7BC50F9B06E44B8428BEE2C60FBB8C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9c5770-a264-4344-bd8a-08db83778fdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 08:02:54.0851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FmwwLImBjPrKR015W5hRnEHgrk9p9ONTaFPRLqEJW2IauL5W/yZskXzcm8NHwTlRKj5V9c1SaTAvaDZb4qafpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8353
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA3LTEyIGF0IDE4OjU5ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdWwgMTIsIDIwMjMgYXQgMDY6NTM6MzdQTSArMDIwMCwgUGV0ZXIgWmlqbHN0
cmEgd3JvdGU6DQo+ID4gT24gV2VkLCBKdWwgMTIsIDIwMjMgYXQgMDg6NTU6MjFQTSArMTIwMCwg
S2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+IA0KPiA+ID4gQEAgLTcyLDcgKzE0Miw0NiBAQA0K
PiA+ID4gIAltb3ZxICVyOSwgIFREWF9NT0RVTEVfcjkoJXJzaSkNCj4gPiA+ICAJbW92cSAlcjEw
LCBURFhfTU9EVUxFX3IxMCglcnNpKQ0KPiA+ID4gIAltb3ZxICVyMTEsIFREWF9NT0RVTEVfcjEx
KCVyc2kpDQo+ID4gPiAtCS5lbmRpZg0KPiA+ID4gKwkuZW5kaWYJLyogXHJldCAqLw0KPiA+ID4g
Kw0KPiA+ID4gKwkuaWYgXHNhdmVkDQo+ID4gPiArCS5pZiBccmV0ICYmIFxob3N0DQo+ID4gPiAr
CS8qDQo+ID4gPiArCSAqIENsZWFyIHJlZ2lzdGVycyBzaGFyZWQgYnkgZ3Vlc3QgZm9yIFZQLkVO
VEVSIHRvIHByZXZlbnQNCj4gPiA+ICsJICogc3BlY3VsYXRpdmUgdXNlIG9mIGd1ZXN0J3MgdmFs
dWVzLCBpbmNsdWRpbmcgdGhvc2UgYXJlDQo+ID4gPiArCSAqIHJlc3RvcmVkIGZyb20gdGhlIHN0
YWNrLg0KPiA+ID4gKwkgKg0KPiA+ID4gKwkgKiBTZWUgYXJjaC94ODYva3ZtL3ZteC92bWVudGVy
LlM6DQo+ID4gPiArCSAqDQo+ID4gPiArCSAqIEluIHRoZW9yeSwgYSBMMSBjYWNoZSBtaXNzIHdo
ZW4gcmVzdG9yaW5nIHJlZ2lzdGVyIGZyb20gc3RhY2sNCj4gPiA+ICsJICogY291bGQgbGVhZCB0
byBzcGVjdWxhdGl2ZSBleGVjdXRpb24gd2l0aCBndWVzdCdzIHZhbHVlcy4NCj4gPiA+ICsJICoN
Cj4gPiA+ICsJICogTm90ZTogUkJQL1JTUCBhcmUgbm90IHVzZWQgYXMgc2hhcmVkIHJlZ2lzdGVy
LiAgUlNJIGhhcyBiZWVuDQo+ID4gPiArCSAqIHJlc3RvcmVkIGFscmVhZHkuDQo+ID4gPiArCSAq
DQo+ID4gPiArCSAqIFhPUiBpcyBjaGVhcCwgdGh1cyB1bmNvbmRpdGlvbmFsbHkgZG8gZm9yIGFs
bCBsZWFmcy4NCj4gPiA+ICsJICovDQo+ID4gPiArCXhvcnEgJXJjeCwgJXJjeA0KPiA+ID4gKwl4
b3JxICVyZHgsICVyZHgNCj4gPiA+ICsJeG9ycSAlcjgsICAlcjgNCj4gPiA+ICsJeG9ycSAlcjks
ICAlcjkNCj4gPiA+ICsJeG9ycSAlcjEwLCAlcjEwDQo+ID4gPiArCXhvcnEgJXIxMSwgJXIxMQ0K
PiA+IA0KPiA+ID4gKwl4b3JxICVyMTIsICVyMTINCj4gPiA+ICsJeG9ycSAlcjEzLCAlcjEzDQo+
ID4gPiArCXhvcnEgJXIxNCwgJXIxNA0KPiA+ID4gKwl4b3JxICVyMTUsICVyMTUNCj4gPiA+ICsJ
eG9ycSAlcmJ4LCAlcmJ4DQo+ID4gDQo+ID4gXiB0aG9zZSBhcmUgYW4gaW5zdGFudCBwb3AgYmVs
b3csIHNlZW1zIGRhZnQgdG8gY2xlYXIgdGhlbS4NCj4gDQo+IEFsc28sIHBsZWFzZSB1c2UgdGhl
IDMyYml0IHZhcmlhbnQ6DQo+IA0KPiAJeG9ybAklZWN4LCAlZWN4DQo+IA0KPiBzYXZlcyBhIFJB
WCBwcmVmaXggZWFjaC4NCg0KU29ycnkgSSBhbSBpZ25vcmFudCBoZXJlLiAgV29uJ3QgImNsZWFy
aW5nIEVDWCBvbmx5IiBsZWF2ZSBoaWdoIGJpdHMgb2YNCnJlZ2lzdGVycyBzdGlsbCBjb250YWlu
aW5nIGd1ZXN0J3MgdmFsdWU/DQoNCkkgc2VlIEtWTSBjb2RlIHVzZXM6DQoNCiAgICAgICAgeG9y
ICVlYXgsICVlYXgNCiAgICAgICAgeG9yICVlY3gsICVlY3gNCiAgICAgICAgeG9yICVlZHgsICVl
ZHgNCiAgICAgICAgeG9yICVlYnAsICVlYnANCiAgICAgICAgeG9yICVlc2ksICVlc2kNCiAgICAg
ICAgeG9yICVlZGksICVlZGkNCiNpZmRlZiBDT05GSUdfWDg2XzY0DQogICAgICAgIHhvciAlcjhk
LCAgJXI4ZA0KICAgICAgICB4b3IgJXI5ZCwgICVyOWQNCiAgICAgICAgeG9yICVyMTBkLCAlcjEw
ZA0KICAgICAgICB4b3IgJXIxMWQsICVyMTFkDQogICAgICAgIHhvciAlcjEyZCwgJXIxMmQNCiAg
ICAgICAgeG9yICVyMTNkLCAlcjEzZA0KICAgICAgICB4b3IgJXIxNGQsICVyMTRkDQogICAgICAg
IHhvciAlcjE1ZCwgJXIxNWQNCiNlbmRpZg0KDQpXaGljaCBtYWtlcyBzZW5zZSBiZWNhdXNlIEtW
TSB3YW50cyB0byBzdXBwb3J0IDMyLWJpdCB0b28uDQoNCkhvd2V2ZXIgZm9yIFREWCBpcyA2NC1i
aXQgb25seS4NCg0KQW5kIEkgYWxzbyBzZWUgdGhlIGN1cnJlbnQgVERWTUNBTEwgY29kZSBoYXM6
DQoNCiAgICAgICAgeG9yICVyOGQsICAlcjhkDQogICAgICAgIHhvciAlcjlkLCAgJXI5ZA0KICAg
ICAgICB4b3IgJXIxMGQsICVyMTBkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIA0KICAgICAgICB4b3IgJXIxMWQsICVyMTFkICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICB4b3Ig
JXJkaSwgICVyZGkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIA0KICAgICAgICB4b3IgJXJkeCwgICVyZHgNCg0KV2h5IGRvZXMgaXQgbmVlZCB0
byB1c2UgImQiIHBvc3RmaXggZm9yIGFsbCByKiByZWdpc3RlcnM/DQoNClNvcnJ5IGZvciB0aG9z
ZSBxdWVzdGlvbnMgYnV0IEkgc3RydWdnbGVkIHdoZW4gSSB3cm90ZSB0aG9zZSBhc3NlbWJseSBh
bmQgYW0NCmhvcGluZyB0byBnZXQgbXkgbWluZCBjbGVhcmVkIG9uIHRoaXMuIDotKQ0KDQpUaGFu
a3MhDQoNCg==
