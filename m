Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615F17272DE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjFGXWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjFGXW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:22:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AC12109;
        Wed,  7 Jun 2023 16:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686180147; x=1717716147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u17I1q3CeaEOTUpP30yLvuoGOYahdkc7pqIIkexxTpM=;
  b=WGMrrf6kVh7vZhtGuVN3SbGy8M4jJr9c5RmqYdgg1hJT+JsHy2H9bec/
   hexf5VCtVBwKQpkwTmkUvLr4no8NR3r1W81AGxGKDaR4UWv/RR+bCOvZh
   ggWLK7N00eTkKixhs+uBwFuq9XrPCBAIf2Jh3/aK2YReznCJ2IBJsSlBW
   W4lHXRZsgQ+smn7XPIff/PpLqS2RecM09Spw9XE/KqHqSOt5Bqw8qY9B5
   RtPHpQGdwafGhYjlKUmhHq2/BnTC2XTgNmVIPzzPWf7WizSGLlfKqgJxa
   8O0jSdcyScV2cYt2a4smrvLtcLguwMoc8egdRPyEPZOdlhHJIwnW3LuHZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="341792556"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="341792556"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 16:22:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="956476720"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="956476720"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jun 2023 16:22:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 16:22:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 16:22:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 16:22:25 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 16:22:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDeYRvoZt5pTWr7zdhuLhFBKZt3gVQeBVEq1HiBQfpDEkaqHubB7BG+Q+2OeHyjTfdjwFI/EyIS/BeKmipx+zkWWuO7NS87i3HunN1U03ccprXubzLQQYUzxus4IJP4K/rLP3ifB4yI1y4oCTNRtskuWowFfS/vkPdW6TDiA7qQOuwg/xB389qUOhL5kWUvceyMxUHheIcPYdGlPjH3SJZXP4x7xiLoNtdqEBSbPq3cS77w1WgE3MgH0mqCqpykKcl7irvUoaPmqeoyfcn2LUriFxfV7CEinFX80b+kR1m6Jkphq6BD7e8j7o1gL/FdDCvW/Qa11hQOMq2oOqOctJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u17I1q3CeaEOTUpP30yLvuoGOYahdkc7pqIIkexxTpM=;
 b=MADdaz15qPsZoNrYbnHu6PsICQg38IcUyHHAciEvppkHILw6E0jUqtQsfwtqOTAMFbMmVPKfw+4D8XH5cdhKpiw5WAQxUi4tslvt6vWdMhISRI12npgGKrtYTMv+mwggz3GnBQp6oavC/Nnx4I4FfrNeyJJW/KyjLZ9tCWZKgfsUMl9jYmRUR1rOmVBsdWBRizrGNwb5ZO0cOS5cunQC96yeBURmqQ32aZKoVn+ZZugxu7MZPSBaAsQHf8dPnZbaDj9joqsIFzcw5Zh6x+uVg8JoqVNA7N73TMe5anZTp9IkJt8yCTG9Rw7q1s5mDi7tswX7tv5ktXa68LhZFPK9GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7831.namprd11.prod.outlook.com (2603:10b6:8:de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 23:22:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 23:22:21 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 09/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v11 09/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZlu+vpFsQWL0JukCYZOxCt4kBRq9/gQOAgAB+6YA=
Date:   Wed, 7 Jun 2023 23:22:20 +0000
Message-ID: <85a73d9b48e385389479f3e9e2d29ceca611e6f9.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <468533166590ff5ed11730350c4af8cdb0b99165.1685887183.git.kai.huang@intel.com>
         <97b239b4-7d0d-e5e9-43f5-b9c26d6cd846@intel.com>
In-Reply-To: <97b239b4-7d0d-e5e9-43f5-b9c26d6cd846@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7831:EE_
x-ms-office365-filtering-correlation-id: 02e9f36d-f5d5-4394-2bb8-08db67ae0ab3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VCYHMYnsSKmYf7tG8MDCpbmQBY+IslFMSumqQVAU3XToOMOyM9kaaLFPWgfa50Q1PIbIiJDigoqNe4q/4Ohl0S/XDnsN4yxFUb8iVbHHZhS2y/A4QivkSHFUIsNBTvGAgKzJ4nPGHInU+WUgUBzsiOYsRPI7vnvDiX4ETl97tM74z+h8HQxMLvbeZChgC8XrZCDTcW4F9eNRMH1AEgzx/Tehj5G+wbR3IijNRaCXLf1aggSVTZAnZHbpRlVX72W9A8GGHhQuyD6tOX4eJAsJrngEghpTPWnaXb7DBRjYd4PtnG3MouDSyZ5Sl3Hb34fmRJyey+QNMcD21NjwUW9l7FlUvKPhSe5H+6RtotbITGngra10Pcha0sA8Z1WDYSUaxvgaO9awwTyWCoPalsf/Y3LSqY/E5JONGD2j1PNWpXibVjHx8bywkXnjYDi1b0G1wM2QJ8jQutERM9wYAB2/r73OmTwCLe/RVFeTYhRYOshlBWxcv0HRISJ4XOWzZC3dGLhbrkY6fJYfOkmhDoXlWAPWD7HstWqsJJlosxN4M7zBcBHOWJ5MQtTJ5kFPb3/2BEIUffSdNMX/o1q2TjAHQ8eqlxbrZh/qL2J4ATkOwU4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199021)(36756003)(5660300002)(478600001)(38070700005)(54906003)(110136005)(8936002)(71200400001)(8676002)(316002)(76116006)(4326008)(122000001)(66476007)(66446008)(66556008)(64756008)(41300700001)(66946007)(91956017)(38100700002)(2906002)(7416002)(82960400001)(26005)(6506007)(6512007)(53546011)(86362001)(186003)(2616005)(966005)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KytUUVZjYnZyWklTd1cvZGdGL21uS2praTh1ZzdZRFY4NUxvOXM5MzNWVE5p?=
 =?utf-8?B?QTZoSXByclhHYkcvNnZTSEllRm5vMmRzOXd1bFFudzZHSUZUQXg0cHF1WUJZ?=
 =?utf-8?B?bHRPc29tMEtkd2Ftc1VLcnRYWHRnaDFlYmZMYXdiM0RFQzlzZXJhRHVFZFRh?=
 =?utf-8?B?N0lMOVFjMFJITFBmRDY4SHBSa2g3UDJOYkVjL0Y0SVJSSk5DT1hpZ1pHVy9a?=
 =?utf-8?B?YjJQNmx5ald6MFNIaFZVR0Fkeno2aTRkaVB6NGVKQ2Z5SUdMUWRPR29nOXJQ?=
 =?utf-8?B?dTl6SWlHTHJzby9XbzlhWlBXKzcwN1pzNTFKRW9ySEZOQ1doTW1WNS91ZEZx?=
 =?utf-8?B?c3g3Qkp2YkdzR1hjMENpbXFjR2UvMng4Y2toT0FRNmRlSzRzY3VlTnBSK0RF?=
 =?utf-8?B?UGpzcHpqamlXWTRzR2JPS1E0dktvUVZqcER4TEhiVXJpZFZTdlJDZ2JkQnlJ?=
 =?utf-8?B?YTZTWjVjVTdRdG91Y0JVMVBmQ3ZjcVNKTnkyZFY0ci9IWDU4Q1M4MVIremty?=
 =?utf-8?B?VFRTeHJ5K2h0QllKWWJoeE1VTXNOUnhmQmVoUGFCOHFWcWthSnVBeWhDREYz?=
 =?utf-8?B?eUkxWEQ0elN1T2ZaT2dESGhtYWhFV21lVXg5dlIrM0NyVUFnYmFQRHYvQmxv?=
 =?utf-8?B?aGFlSDZrdkEvRDZxakdQWVgvQWdpLzJDQUs0THJnLzR4b3hqc09RcEZObFBK?=
 =?utf-8?B?d2Y5VTI4U1NZY2ZxaFFjaERYZDdIWDlOUUhpQ20wRk9wNUNGRHkxSXN1VUox?=
 =?utf-8?B?RU9ab09rbDFpZFBxYlI1WG5YeTB3dUp6VjhFNDBjNFRoSjYyY3Zvbjd5R1Vv?=
 =?utf-8?B?MXYwMXJXODlBZ1BUM3lCdzBPSDJPVHZOTFp2eW5GYzYyU3lrYXMwMGpJZkd3?=
 =?utf-8?B?WXlIbWdIZWllZ0N1VGVHbmRhR0twUlloaEFhQXJhTFNDSzVhTzJyR0dOYXUw?=
 =?utf-8?B?Nllibm1RSzR2cGE0cWhnbGh1NzF5VDZxR2l6MEJkQyt2d2FucFluOXl4N0RS?=
 =?utf-8?B?SnUrRVpCcUU5VnptYUcrZ2Fid0xHcFRoQTg2c25VT1g4U293SHl5eVlQbEdx?=
 =?utf-8?B?WFpEQnFwY2d1bjhvc1RDUGVHbVYwRFpvd2x0TkZtdEh1dFhtcFRiaWQxaE51?=
 =?utf-8?B?cUFTNDF3eS83SHhxazVSeTVjakZzclBZcjBRSW1mVkVsTW50SThpc0hoK0U5?=
 =?utf-8?B?d0xXQmVlSGtTczIwdFBBZFRBTWV4eEVqTmUzclJNcHdBblhNQVA3dk1zbDB6?=
 =?utf-8?B?VktQdTF6a2dWc0hFYm5LN1Z4U3lVbjlQSVpjSTdGRDdkRG9yTkJmTzNJa3FX?=
 =?utf-8?B?YXNISzIzbUZqc3R0YU92RlpaTDJkOUZVN003bmpjS0FQWDd5RHhCMjlmRlZm?=
 =?utf-8?B?WU1ncmNyakhabUFLQXZPRGxJeG9ZUUQ3MnAxUy9EeFRuNFd5ODVGOVp2YnZ2?=
 =?utf-8?B?RDJMaFBYNEhNck1DclJ4K0JGdlFOWjlkRStrdnpwUGZJaGczRk5yZDFnSGFR?=
 =?utf-8?B?OUc4UVZmdTVFZ3RFQTNuTnduR1RvQzQ5RTdzWUl6VDdTTzJoOUVnOWk2b2Uz?=
 =?utf-8?B?TUd3T3hRcHdNMFlwQmFWZ0llKzFwc0JzemRzNlVubzN0WlgvM0NpRXVOdGtq?=
 =?utf-8?B?Tk41bHprWm10dHNoWFJCcHViRHRkbTluTnhCZFJCNjcyVmdrZlIyRkVVSVp1?=
 =?utf-8?B?OTY3MUJ0aWkzNWdZSUFyUE9tVG5nOUJRTEZYV3dJSU1lQWsxcDFlNEZiSEsz?=
 =?utf-8?B?RHRDR01ML3FqU3g0KzJ1Vm11aElWUVRNOXZTYTlMMVUxdTVrQkJOSG44NXZj?=
 =?utf-8?B?a0g5YVhpZ0hXdGVqUGZDdmF4dmx1aGp5M3VLY0NDZmRKTjlXMlkyLzN6cnBW?=
 =?utf-8?B?RUlGMmtlNVN3RHBOL1Fqc0hkSlBBUitsNk9kdzZwMUxPUEY1WEVDcjNkcU9O?=
 =?utf-8?B?YlhDcnZ1cGlPYWJqTHpOVTdzV0JMdUlzMXJQcUY4Qjd5aHFRNkp4WjZOd3N2?=
 =?utf-8?B?bm96cyt3YkVNbFhValJvOWVSa1lqd09henYwRXdPWmVVUEsxNmYza01wZDVE?=
 =?utf-8?B?VUl1UzZNT0pyWk5yeExnNDFENVVaSDZHYmp4b0diN3dWaTBQU290MnNjKzlm?=
 =?utf-8?Q?7eVRo8Mvf7TJ8W6ORYyLjtqDX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9452A33AA2273547B4091401F06EFDCB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e9f36d-f5d5-4394-2bb8-08db67ae0ab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 23:22:20.4107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wzLtRVwQELoTBdwuTAQrU/wRMhEka6a3Res1nlQX38O0K+9qAYtAU9/sjoO8UIlQJVj012eaMzttNECY01I7zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7831
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDA4OjQ4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi80LzIzIDA3OjI3LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gQXMgYSBzdGVwIG9mIGluaXRp
YWxpemluZyB0aGUgVERYIG1vZHVsZSwgdGhlIGtlcm5lbCBuZWVkcyB0byB0ZWxsIHRoZQ0KPiA+
IFREWCBtb2R1bGUgd2hpY2ggbWVtb3J5IHJlZ2lvbnMgY2FuIGJlIHVzZWQgYnkgdGhlIFREWCBt
b2R1bGUgYXMgVERYDQo+ID4gZ3Vlc3QgbWVtb3J5Lg0KPiAuLi4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6ICJIdWFu
ZywgWWluZyIgPHlpbmcuaHVhbmdAaW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBJc2FrdSBZ
YW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4gVGhpcyBpcyByYXRoZXIg
c2hvcnQgb24gcmV2aWV3cyBmcm9tIGZvbGtzIHdobyBkbyBhIGxvdCBvZiBtZW1vcnkNCj4gaG90
cGx1ZyB3b3JrLiAgUGFydGx5IGJlY2F1c2UgSSBkb24ndCBzZWUgYW55IG9mIHRoZW0gY2MnZC4N
Cg0KRGF2aWQgYW5kIEtpcmlsbCBhcmUgQ2MnZWQgOikgbGludXgtbW0gbGlzdCBpcyBDYydlZCB0
b28uDQoNCj4gDQo+IENhbiB5b3Ugd3JhbmdsZSBzb21lIG1tIHJldmlld3Mgb24gdGhpcywgcGxl
YXNlPw0KDQpZZXMgaW4gdjggSSBmb2xsb3dlZCB5b3VyIHN1Z2dlc3Rpb24gdG8gYXNrIENjIE1N
IHBlb3BsZSAoRGF2aWQvT3NjYXIvQW5kcmV3KSB0bw0KdGFrZSBhIGxvb2ssIGFuZCBEYXZpZCBz
YWlkIGl0IGxvb2tlZCBnb29kIHRvIGhpbS4NCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGtt
bC9jb3Zlci4xNjcwNTY2ODYxLmdpdC5rYWkuaHVhbmdAaW50ZWwuY29tL1QvI21mZmI5NzhkMTU3
Yzk5ZGE1OThkNjM1NGQ1NTY1MDk1MmM0MjVjNmZkDQoNCkkgdGhlbiByZW1vdmVkIE9zY2FyIGFu
ZCBBbmRyZXcgZnJvbSBDYyBsaXN0IHNpbmNlIHRoaXMgcGF0Y2ggZG9lc24ndCB0b3VjaA0KY29y
ZS1NTSBtZW1vcnkgaG90cGx1ZyBidXQgb25seSB1c2VzIG1lbW9yeSBub3RpZmllci4NCg0KSSds
bCBhc2sgS2lyaWxsIHRvIGhlbHAgdG8gcmV2aWV3Lg0KDQpIaSBEYXZpZCwNCg0KSSBhcHByZWNp
YXRlIGlmIHlvdSBjb3VsZCBnaXZlIHlvdXIgQWNrZWQtYnkgb3IgUmV2aWV3ZWQtYnkgaWYgdGhp
cyBwYXRjaCBsb29rcw0KZ29vZCB0byB5b3U/IFRoYW5rcyA6KQ0KDQo+IA0KPiBGb3IgdGhlIHg4
NiBzaWRlIChhbmQgPHNpZ2g+IGJlY2F1c2UgdGhpcyBwYXRjaCBwcm9iYWJseSB0b29rIHR3byB5
ZWFycw0KPiB0byBjb2FsZXNjZSA8ZG91YmxlIHNpZ2g+KToNCj4gDQo+IFJldmlld2VkLWJ5OiBE
YXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPg0KDQpUaGFua3MhDQo=
