Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DB0741EAB
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 05:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjF2DT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 23:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjF2DTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 23:19:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A81C2733;
        Wed, 28 Jun 2023 20:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688008781; x=1719544781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D+wE8+ldovhm1NybI4jQeiomoswV6BAXPCXDE+YFMHw=;
  b=XD1pavc8vqn+pB1c5OXkzVdVie++YJMAqGbFxPgBFomPJbyJsfuGqp46
   tCj3M3RX5tMPIMcbVClmdm66E3+3/JKQONqMDJD7A3eLHlHs5dGsGNXzB
   ZDtTSu5PqCXYvYXt3f6MUBcf8iy4lWRrd3TcnJ1CjH9Mmf+l9ueYoh9Pr
   MemTr2kvw2uQl0H/ssmZvGbrog4jFdrk4Xw3Q+T8aEKC7ug0L+fIPfsHt
   uEuDpXJ25U9e4TtzRUd1u6fUI0rJK75Kk+nPgxmL7fg5Je0gnqnFbb1VP
   LQo2CcR4sJLa6a06ElhzqFNBLWTUeNTMC2Nyxve9YUddsXZECA0KontJD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="365475398"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="365475398"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 20:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="861762505"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="861762505"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jun 2023 20:19:39 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 20:19:39 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 20:19:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 20:19:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 20:19:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHv2FsL4EUKMzZt13lDUvaGGpxqsYo6gXZVr73i8F019qa5FcSU/HVLhPCWy33X0nkNtgsXyKXXNBoWOLOe5u9HwoDA7LElheKyJ26p//rFnfVc77BB+lbJDe15OvMPDT5VUhJad2fs/ILNL68fP6g+ogNZLLboNOdRy+8yXCEPfdfZOVvDXLLb7gqN7PMvNcW7Fc3MCIWudZJvkRKBbVgk+sYsy75sjNDZufaga0pNczWFWdfY5v1qrJ3+FTvF1Z37G6CNvJRC84qsWSDaPO/A0lf/4kc9TgVZLOH5t5jTbuDaHfMlQFzX8fXJC0OBK9BmC19I37/ZuKh1ThgTxrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+wE8+ldovhm1NybI4jQeiomoswV6BAXPCXDE+YFMHw=;
 b=jEBLp9TI6DtkohLHjWBr3tOx1zl9sc4pWidC6P788Y8YTqD/riSMPb08pFXGOlJeww4lP6pi1PcRR7/tT6inyXVppZ4bGX4yH0mVEOyzalSFjQQJ8ocliDLE+uVKFopWudMKNIduvJTVkEvwcje3RS6ZwLUQlyzEnnTtbejt+Z7Dj8QSiD60BbzgZKLQuqN3g2TRo+KR6CEtAN4mlQ4gEVlkUMTYAWDqMNosQbdrGgy9x6j1Knt9wl05RkK4STWd+WlfnaG2+0+mhLsWQtAIYxsUEgzfRAiSOvCYK3f42hXd/F6wb6blcbhqcP5G943sPLZEwfmfIPE4/OfV0it3ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6402.namprd11.prod.outlook.com (2603:10b6:510:1fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 03:19:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 03:19:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Topic: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Index: AQHZqDW1qzOe/uWSAkmVYoaVetZlS6+f8x4AgAEtegA=
Date:   Thu, 29 Jun 2023 03:19:29 +0000
Message-ID: <8a1d39c7641b0ba2be3191599a114bebfa3ffca5.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
         <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
In-Reply-To: <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6402:EE_
x-ms-office365-filtering-correlation-id: fb7a2d42-aba2-4200-84f4-08db784fa652
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2rsLnFe3B3kjK9Mc9zh8WBEyBEuYOPfMcDJDGhAHbHwBxN/RwXo+AM9T4NA3RWfxWGRsLPqlsQJguD4+UrtGnq6VOpBhKIbr98in+gUd8kDeR8af5YW380Nl9ynVpPPHJ8SGusLa3AAbZbkLkjQZXAdXF+XzKeAvYDoUMUmahvOySExjkrOsvIIr7pKOuDVkhJqrC34zNfyaGGx6+kTk7kqpmVzIFrOauAB+TY+bc9LcMZmwYFdB9SQ2MRWHcWpbpI/JFuGvtYSnnhjfqpoh25wMJ/leS5IDbqYm2gsb0XtMebfl0sC1/1DOk601CMh/1pBQ1AXlqXjylkprMf9ei5bkSffC1VJp7WygGTxhnAOpFJ3I5Gf1SmDclJrcIvZ35uSUyXbVTeYLd6aQ2KfOFuiQiYYJqn8YRRkOR2r3jSQYnwSqF7x8nTxuRrryZX8dwtlKhKgNXi4etqz+fnHejLnriip18nvjoOJbSVG6lr/qiTnjhACV0+FR+dKrmr0b81EYbbZmVXFHvLSzazPH809U83c6b4fgORjyNcpCfJ2h9xWm8uBPBBhaxMhdseo+37dSyvge11+78Gl4xYBBAdycSVPUvizluWe7na5UFceefxskYTkDpgltqi5Q0+QM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199021)(7416002)(66446008)(76116006)(66946007)(64756008)(316002)(66476007)(66556008)(38070700005)(478600001)(4326008)(36756003)(8936002)(91956017)(8676002)(5660300002)(86362001)(2906002)(54906003)(41300700001)(110136005)(6486002)(6506007)(6512007)(186003)(71200400001)(83380400001)(38100700002)(82960400001)(122000001)(26005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFJ2MlkwWHZmbXVqK01mL0VNZ0h6SUZGb1d4UDJOUHF2aTZ4dTUyR25JMnMx?=
 =?utf-8?B?bjBDS2pjUit3WTg5QTJLRzRaZjBxOWVhMzZjeTQ0SThOUHdjTmlod1dVOTRB?=
 =?utf-8?B?QkdzcXV0YytrK3lNN243ZG1hYzhHcnJHSEFYY2ZNZ2k5K1FsL3cxQ3R5ZkU2?=
 =?utf-8?B?dlNqd3cvWFBUdis4M0hDMW4wZGs5MzJtTlRLZ3lUSDZvSUVLVmJJYjU4akhH?=
 =?utf-8?B?bWpiQS9KR3NUUGdKQXJ6RzYwc1N3SHFhVXR0YmRieGxKd2xvVTlwUFhhK3h4?=
 =?utf-8?B?SnRXZ1hmY2FXM1ArY0JHT3ZNODIxVllLQ0x1SVI3clgzQ3ZsVlJ5UmpMWGc1?=
 =?utf-8?B?MFlPbVpkOUxxNmRUZTBnNWpJY0FLZVk3WkYxYXpqdzFLalozYjRPOFJsVEx5?=
 =?utf-8?B?TENnSmcwUGtyS2dUY0JqWCtoM25IVG9OQ3ZpTHk1K2E3dTZzc2FlOFVHVkk3?=
 =?utf-8?B?QUtEU3RHb1FhejV0dVNVWDJMOEhOYVl6NDZZQlpkY2d3NVlxQ0thOFptcW5U?=
 =?utf-8?B?NDh0RlVGbGFvckVPR1ppMWdTZXF3M3IyaWZKQ1JOS05JbzQrcWIrZEdPRmtP?=
 =?utf-8?B?Y1liUXd6VzNCMm5xcnNRMitWdFNOU2tvQkJYQkdaaTJ2QmpQbWdlT1VGMlNC?=
 =?utf-8?B?SGMyVXphcFJ4Qmo1Mm1xUXE1WC83THBuU1JENXpGQWFxWnlJNFR1M3pIcGZi?=
 =?utf-8?B?YzE2MXlKSDg5UFhrMklCaFEyS0NNcTBYbmtPZjRlbmwvMTRqS1F1b2pJZ0dQ?=
 =?utf-8?B?alU4c2N1MXNiL1BRYm5OdXI3c3pWL0RCcjNrWVFkejlyQkEzM1loVWdyTUh5?=
 =?utf-8?B?K3FlVkNyV3lwWitSYlpPM0RUVE9lZGh2UTh4RGJCczdXQzg3d1UvRlg2U204?=
 =?utf-8?B?Qi9oN1NmUDNHU0hsU3Z5VGg1cHRxNzVsYXVJQzFYOVBnQ29weWZBMHVLVmdl?=
 =?utf-8?B?azFMa2V2R0RiNk5ZWXU5VWJJZHliQ0swc1BQNURmSkgyNVBseXIzQlpDeXpK?=
 =?utf-8?B?bTFvUmtDRnI0cDVPTE1GYXYxTzlMQjA0WXRjOXRVeE9ObGJTQWNlMkV5QzF2?=
 =?utf-8?B?R09DTmlJV1lnZTh2aVkvSFJyTU1RNm5uSjZGRFJlNGFQL0QzVVZnOTVlaFkv?=
 =?utf-8?B?alRYWVRBNmVCZGlzWE1yT1dFZVRWczFQNHNCV3NWeklvWmM3bGc2WEJ5TmE4?=
 =?utf-8?B?a0dPM1JIU3E5bHI2MjZnVXMwaVNCOWdlTThjNEdvakpEOXdRclI2QnM0WDdz?=
 =?utf-8?B?aFg4UXVQNUYyajkyNk1Jc3NFM3VHSGFYb0ZBeVprMkw1MVQyRkR6WTV4dUFG?=
 =?utf-8?B?SFBMelNyU0JPVHFMc0t5ZlRVTmMrM1NnVGcxYVFCRjVGaEprRXVXd0dQNVVE?=
 =?utf-8?B?N1F5NWxlaDJoaW1OWXUrb2hibHFPTytrQ280QkVQc0lBMG9tNnFXU2R3cDlF?=
 =?utf-8?B?em50ZWtpYTM2ajlBYmRRUGZmSjBiYzZWbjNXOFNYelF5OEZ2b0NoQ29xOGpK?=
 =?utf-8?B?S0NOc1E5QXlGMTBSclo0eFVyZ1QxRTRjTmVvb2UwWmZ2UStvYVJwZzZSZG9P?=
 =?utf-8?B?cVBLWFYrSmd1SHljQm0yT3Ryc2pLbnVYR0tVSmNGdXVDdHFNWUxsQll4dERn?=
 =?utf-8?B?aWdxUnQ2QURuRE1mSHBNWGhWVGhRdjdBT0pyMVlaQkxlTUM0OXUzOWc5aEc3?=
 =?utf-8?B?dnZDWTlxcXFrb0xLei9NQlE4OW1jUG5IVERFYzg5cXYxNHk5WGxubnBtWEFi?=
 =?utf-8?B?aU1Oa2sxYXQ1b0MzUVVRUE9Pb00xZHhFcWlyVkk5TnJTNmtpbkxDc2QrMmZn?=
 =?utf-8?B?Z2hRUFh1SmlkWWJ3V1NrMy91NEdJb3Byc1creGxucDJVSU85T3loekQwcVM5?=
 =?utf-8?B?ZUdkTFZJalFlOTE1UTlJbmJtN09zVDREMnJUQk9zeDkyU2o5UFBjc3dqdEU0?=
 =?utf-8?B?eHJrTHFOb1l3eXllOFNNUkNOTTdVMlB0dEQ0Wm0vR1J0RVF1VUhhcXVWZzZv?=
 =?utf-8?B?RW5CelFIc3dhZXZFSDF0SUJJSExLMXRNb21zU2pxUmV6aVFOUHI0Y0hBTisx?=
 =?utf-8?B?WFdBOHN0MnVTaWtKZTBzN3BGRlAwamppUFBKNU8rWWhTYVpzNTRwU3lmQTRh?=
 =?utf-8?B?QmRKOVpIOTZuU2NkK1V4Vk5FRlVsWGsxcEh6V00rSnRmeU15RUtmTUc0c1Iy?=
 =?utf-8?B?eUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE7D0AB4317110438DEF215C72928597@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7a2d42-aba2-4200-84f4-08db784fa652
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 03:19:29.0831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sqxelAXxL3CiG8BSChrooioldF8xFBWQ9HjOFu5Ka5IvSdx96qAPC88BlY0NF3e+uNPYGpLFMfIbzN+VvFsnPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6402
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDEyOjIwICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gKwlhdG9taWNfaW5jX3JldHVybigmdGR4X21heV9oYXNfcHJpdmF0ZV9tZW0pOw0KPiA+
ICsNCj4gPiDCoMKgwqAJLyogQ29uZmlnIHRoZSBrZXkgb2YgZ2xvYmFsIEtleUlEIG9uIGFsbCBw
YWNrYWdlcyAqLw0KPiA+IMKgwqDCoAlyZXQgPSBjb25maWdfZ2xvYmFsX2tleWlkKCk7DQo+ID4g
wqDCoMKgCWlmIChyZXQpDQo+ID4gQEAgLTExNTQsNiArMTE2NywxNSBAQCBzdGF0aWMgaW50IGlu
aXRfdGR4X21vZHVsZSh2b2lkKQ0KPiA+IMKgwqDCoAkgKiBhcyBzdWdnZXN0ZWQgYnkgdGhlIFRE
WCBzcGVjLg0KPiA+IMKgwqDCoAkgKi8NCj4gPiDCoMKgwqAJdGRtcnNfcmVzZXRfcGFtdF9hbGwo
JnRkeF90ZG1yX2xpc3QpOw0KPiA+ICsJLyoNCj4gPiArCSAqIE5vIG1vcmUgVERYIHByaXZhdGUg
cGFnZXMgbm93LCBhbmQgUEFNVHMvVERNUnMgYXJlDQo+ID4gKwkgKiBnb2luZyB0byBiZSBmcmVl
ZC7CoCBNYWtlIHRoaXMgZ2xvYmFsbHkgdmlzaWJsZSBzbw0KPiA+ICsJICogdGR4X3Jlc2V0X21l
bW9yeSgpIGNhbiByZWFkIHN0YWJsZSBURE1Scy9QQU1Ucy4NCj4gPiArCSAqDQo+ID4gKwkgKiBO
b3RlIGF0b21pY19kZWNfcmV0dXJuKCksIHdoaWNoIGlzIGFuIGF0b21pYyBSTVcgd2l0aA0KPiA+
ICsJICogcmV0dXJuIHZhbHVlLCBhbHdheXMgZW5mb3JjZXMgdGhlIG1lbW9yeSBiYXJyaWVyLg0K
PiA+ICsJICovDQo+ID4gKwlhdG9taWNfZGVjX3JldHVybigmdGR4X21heV9oYXNfcHJpdmF0ZV9t
ZW0pOw0KPiANCj4gTWFrZSBhIGNvbW1lbnQgaGVyZSB3aGljaCBlaXRoZXIgcmVmZXJzIHRvIHRo
ZSBjb21tZW50IGF0IHRoZSBpbmNyZW1lbnQgDQo+IHNpdGUuDQoNCkkgZ3Vlc3MgSSBnb3QgeW91
ciBwb2ludC4gIFdpbGwgdHJ5IHRvIG1ha2UgYmV0dGVyIGNvbW1lbnRzLg0KDQo+IA0KPiA+IMKg
wqAgb3V0X2ZyZWVfcGFtdHM6DQo+ID4gwqDCoMKgCXRkbXJzX2ZyZWVfcGFtdF9hbGwoJnRkeF90
ZG1yX2xpc3QpOw0KPiA+IMKgwqAgb3V0X2ZyZWVfdGRtcnM6DQo+ID4gQEAgLTEyMjksNiArMTI1
MSw2MyBAQCBpbnQgdGR4X2VuYWJsZSh2b2lkKQ0KPiA+IMKgwqAgfQ0KPiA+IMKgwqAgRVhQT1JU
X1NZTUJPTF9HUEwodGR4X2VuYWJsZSk7DQo+ID4gwqDCoCANCj4gPiArLyoNCj4gPiArICogQ29u
dmVydCBURFggcHJpdmF0ZSBwYWdlcyBiYWNrIHRvIG5vcm1hbCBvbiBwbGF0Zm9ybXMgd2l0aA0K
PiA+ICsgKiAicGFydGlhbCB3cml0ZSBtYWNoaW5lIGNoZWNrIiBlcnJhdHVtLg0KPiA+ICsgKg0K
PiA+ICsgKiBDYWxsZWQgZnJvbSBtYWNoaW5lX2tleGVjKCkgYmVmb3JlIGJvb3RpbmcgdG8gdGhl
IG5ldyBrZXJuZWwuDQo+ID4gKyAqLw0KPiA+ICt2b2lkIHRkeF9yZXNldF9tZW1vcnkodm9pZCkN
Cj4gPiArew0KPiA+ICsJaWYgKCFwbGF0Zm9ybV90ZHhfZW5hYmxlZCgpKQ0KPiA+ICsJCXJldHVy
bjsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogS2VybmVsIHJlYWQvd3JpdGUgdG8gVERYIHBy
aXZhdGUgbWVtb3J5IGRvZXNuJ3QNCj4gPiArCSAqIGNhdXNlIG1hY2hpbmUgY2hlY2sgb24gaGFy
ZHdhcmUgdy9vIHRoaXMgZXJyYXR1bS4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKCFib290X2NwdV9o
YXNfYnVnKFg4Nl9CVUdfVERYX1BXX01DRSkpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiAr
CS8qIENhbGxlZCBmcm9tIGtleGVjKCkgd2hlbiBvbmx5IHJlYm9vdGluZyBjcHUgaXMgYWxpdmUg
Ki8NCj4gPiArCVdBUk5fT05fT05DRShudW1fb25saW5lX2NwdXMoKSAhPSAxKTsNCj4gPiArDQo+
ID4gKwlpZiAoIWF0b21pY19yZWFkKCZ0ZHhfbWF5X2hhc19wcml2YXRlX21lbSkpDQo+ID4gKwkJ
cmV0dXJuOw0KPiANCj4gSSB0aGluayBhIGNvbW1lbnQgaXMgd2FycmFudGVkIGhlcmUgZXhwbGlj
aXRseSBjYWxsaW5nIG91ciB0aGUgb3JkZXJpbmcgDQo+IHJlcXVpcmVtZW50L2d1YXJhbnRlZXMu
IEFjdHVhbGx5IHRoaXMgaXMgYSBub24tcm13IG9wZXJhdGlvbiBzbyBpdCANCj4gZG9lc24ndCBo
YXZlIGFueSBiZWFyaW5nIG9uIHRoZSBvcmRlcmluZy9pbXBsaWNpdCBtYidzIGFjaGlldmVkIGF0
IHRoZSANCj4gImluY3JlbWVudCIgc2l0ZS4NCg0KV2UgZG9uJ3QgbmVlZCBleHBsaWNpdCBvcmRl
cmluZy9iYXJyaWVyIGhlcmUsIGlmIEkgYW0gbm90IG1pc3Npbmcgc29tZXRoaW5nLiANClRoZSBh
dG9taWNfe2luYy9kZWN9X3JldHVybigpIGFscmVhZHkgbWFkZSBzdXJlIHRoZSBtZW1vcnkgb3Jk
ZXJpbmcgLS0gd2hpY2gNCmd1YXJhbnRlZXMgd2hlbiBAdGR4X21heV9oYXNfcHJpdmF0ZV9tZW0g
cmVhZHMgdHJ1ZSBfaGVyZV8sIHRoZSBURE1Scy9QQU1UcyBtdXN0DQpiZSBzdGFibGUuDQoNClF1
b3RlZCBmcm9tIERvY3VtZW50YXRpb24vYXRvbWljX3QudHh0Og0KDQoiDQogLSBSTVcgb3BlcmF0
aW9ucyB0aGF0IGhhdmUgYSByZXR1cm4gdmFsdWUgYXJlIGZ1bGx5IG9yZGVyZWQ7ICDCoA0KDQog
Li4uDQoNCkZ1bGx5IG9yZGVyZWQgcHJpbWl0aXZlcyBhcmUgb3JkZXJlZCBhZ2FpbnN0IGV2ZXJ5
dGhpbmcgcHJpb3IgYW5kIGV2ZXJ5dGhpbmcgICANCnN1YnNlcXVlbnQuIFRoZXJlZm9yZSBhIGZ1
bGx5IG9yZGVyZWQgcHJpbWl0aXZlIGlzIGxpa2UgaGF2aW5nIGFuIHNtcF9tYigpICAgICANCmJl
Zm9yZSBhbmQgYW4gc21wX21iKCkgYWZ0ZXIgdGhlIHByaW1pdGl2ZS4NCiINCg0KDQpBbSBJIG1p
c3NpbmcgYW55dGhpbmc/IA0K
