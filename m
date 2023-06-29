Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6596C741D6B
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjF2A6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjF2A6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:58:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB796212F;
        Wed, 28 Jun 2023 17:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688000329; x=1719536329;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yLBtAzaKFYgTfIgj0Ym/G1wyKVlA8QtVrSwmxa70ixA=;
  b=NspMvW7xgGDcnYkBeA7UfdstQiLp7gr1N8b31OPAaCUEa7pqafKMeHbG
   m/3z+OOu0K9u3NkuSr6UWcsmO9mVcslV1JlMWycOEQSQgn+7S7i9iwG6r
   RQ5HLDOe3R72QEunu8BUT4/8DCtk+KbINOvO5EvaZj7RYroxbPiasM6lL
   qs5bwQybP/R5Hv0Oz/rJvGJG5E0nNIEbN3ORTNNBucD2wkm2OYyX+x9MV
   XKMp7Emlq4QegOWhvuIyGtEvvcZaI49GISdy3VSflP5PrJeQjVnWys7z5
   1IzOTQZvNLTK7DPuOP33+xf2VUmMTnTdgZtt8jgQkmTaKhzgNmham9amt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="360847964"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="360847964"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:58:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="717177848"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="717177848"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2023 17:58:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:58:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:58:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 17:58:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 17:58:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGNCletgSlAkZnuiKG86R9scsy2LliD+L0M56f3Hjj1esC1+Sh/8lOZ4YEtZZGFPBPkdcVxb7rH+Mm4fGwH3ka/sGlw6heK0MI0J2ulRYbuAILbY5Lugwl8ztMonOa5adaPI+4HvY02djNt+Mn1Uzm3rEuIpphvbi+4XAOLdBSowBvV6p4Wigj89xo3nUn2CmL8+3pkO1aa4xKaPExJUK0DzeFgtzkIv2GVDHgipbSoE4zUGIl3di8MdNzOA2JvBMQ/kuaqsT59GraJVjzrfc90UxzECFmQn7hcbubKA85pzFRgXnKN/zXFRn0L9mdXpJYjxoPVHBPPM4Zu7Rncx7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLBtAzaKFYgTfIgj0Ym/G1wyKVlA8QtVrSwmxa70ixA=;
 b=RM/IiPuXZ3MWTJG0pqOodpHdwYOFbZo6kf2VvvcgLrdugPQEJCH0L4NFus5sNcEvmAhZFb1YcprWUTUwtXbQ+TgrVX6+e2BLUcXGm0XBl4DTfHvDeahB4xnn743NFB1CWSHiM8spggT1OuR2Qerw29lqjGXd8Qj5yxeOWK9mjP7Qlew9BoDEuW5YX2eV9vWBayszkMT8Sg+x5WVkHXhAdKb39nNDu3s6Q1ouJ/T+CiHelKoZeo32yB1MHjnBjUDGaVU41efYwdpgNyoC6wii+atb66l+uFqh9/yUnSjkFAjtFVmZewFs9rDZf8anuRI6tnHyNo2sgJ202jBuFhGOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7189.namprd11.prod.outlook.com (2603:10b6:8:137::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 29 Jun
 2023 00:58:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 00:58:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
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
Thread-Index: AQHZqDW1qzOe/uWSAkmVYoaVetZlS6+f8x4AgAD+woCAAAdlgA==
Date:   Thu, 29 Jun 2023 00:58:44 +0000
Message-ID: <eddd7d0e31dab9efabfa6f830c8bc51c277e83a8.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
         <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
         <dc30a8c6-c313-9d85-c41e-07171dfdf056@intel.com>
In-Reply-To: <dc30a8c6-c313-9d85-c41e-07171dfdf056@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7189:EE_
x-ms-office365-filtering-correlation-id: a6db7c62-e236-4ff9-4665-08db783bfcee
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kKbFnAugABePITNEGfihwCR7q6UfL52JG3rLcPseRAk3Z44mzelnHv2Tv0zxRGDila7mcEAzsjBds3FAHICshI9dYrxZ+C+kf8ZzlOsIuNp7qDAgWKTlwKYVq05vAQGWqLyUxcKwMmc2xkgi+HbEj/Xjjuq9ZeaL/OZ8+C2JoizFVTxF2aruB4jI7l3NUWeCYOE+u8yvVnEWJ/C9owJGPSrPKiYnjpE3dab9xaT/ymipTp69z74H89J1Ieoemo4PN5tO0Slu0q+YroLSj/THOe5uH7IC1+nRLGb0V9xvUr2+nCEDUr0l7e8WX/la7M8C0TNIIDhfE2y1lSXohBJTjNHOyIhK2ZkupIrWg6ISEM0z5R05SiVHFDFUy8FSHVroNhzloEzfOoax7AhwLRf1RmBIuNVRXb8mhEJlh+/IPydbW3gybUufHAXLv7WM+zhU1+ElFBCVeB84KkhKL8X5nIDzVGTK9klZfR7AYhjClEUxPAv3fUX1MHuFckdwD7QE3Srxpe9XapeBH4SZBicT9K0nof4FEUYIgu1VqvH69o6Cu19Q3SKLV0tbNHBHfK8xNQNsaSs7wzOFbTmgDAhaR+vugSbmOmolFc4C85C90EC6l8//3mRgU994g6d92J9T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(6512007)(2906002)(186003)(6486002)(71200400001)(122000001)(2616005)(83380400001)(38100700002)(82960400001)(6506007)(53546011)(26005)(86362001)(110136005)(41300700001)(54906003)(38070700005)(478600001)(316002)(36756003)(76116006)(66556008)(66446008)(4326008)(66946007)(91956017)(64756008)(66476007)(7416002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEFMZU5iRVBKdHB4NmhXa3pPWHUvNEF3SjkzVXdGbTBhaDh6Z0hCWEVHblhM?=
 =?utf-8?B?OUc4WlVLcmt6RjV0UFk2NXhMamdVYmwyQTdGaWxJclk4YnJvS052UnFjY1BM?=
 =?utf-8?B?ejVJMWRUcWJZT0Y2UnFGUlFwUERUak1TZ0xEUms5cXIxaFZ5cGJMWVVRQXk3?=
 =?utf-8?B?SWFkZlI4OGFJbXQyUGxuaE5zNWxkbk02ZFdpMnpVdy9xY1ZaKy9tcHdVUHdo?=
 =?utf-8?B?TUNHbEZCeHB0amZmWUcrRzcxenM3bW8xZTdCaFJLSElRLzUyaVFYbXplcUxo?=
 =?utf-8?B?NGNvMnF6WS84K2NCOUl3aWJDTlNLT3huWTlzT0V0K2Z4M000bXNLcjlQUCtB?=
 =?utf-8?B?V0VTelc1aG1UVlRNZEtweEUyU3o2MVpMcVdROGMwaFhvN0EzREV5bjBVMVFw?=
 =?utf-8?B?OGMyNmNkeUd3RFZ2czZmMllSU2QraFdBMUVPbEJuYmt1a21KWlJHUlBCQndr?=
 =?utf-8?B?UTlqTE40V0dOU3ZROVVmaDk3L2lPOWVSeU5WTWd4SWlBRTQwOGIyaDU4Tkdh?=
 =?utf-8?B?d0QycytZOVR1OVJZRUFocnVyV1ZPdmZQczdVUkpaaldHLzJZYlhvcm8xNjZ0?=
 =?utf-8?B?OTFIWG1oYnpneENUWC9yL2Fnc2wycVE2czdJeEZ0d1lwS3FqdUpKdzNXMWFL?=
 =?utf-8?B?b3grZWE4KzhCMktHR2dKUzJnaEdnOElzakE3V3o5UDNUc0h4bDRScC9LcW1S?=
 =?utf-8?B?ZnNRSk9naXNnUUUvT0NXSGcvM1VOSlpEazh3SlRYQmdJMFArUkY0a2pZTVVn?=
 =?utf-8?B?ekNNa1ZRL1JJY3MzRUhPakVoaFJzQ0I5MmlVUlp0UHE3K0RIRkZVbkEydVVD?=
 =?utf-8?B?MWh3bjQxeFZ2VzBxd2p3S25EYURpRUVEVGtIeXU3M0orb2FaLy9vcWpJS1NI?=
 =?utf-8?B?NWY3OGQyelhSNnVwdTFWTTBFdTZzaWhFeFRlTFJUVkdoamVYSk00bERJNlZo?=
 =?utf-8?B?VWVUY29ZdlE0TGd1TGFRZXJTMEtLWTRIeUsrWFF4TnBja0hHb0ZyZkxsMEt1?=
 =?utf-8?B?bk1Ydk1zM3J1U2tQZm9GTUFtUkdESStyK0lRYWJNUzJkankzKzliUjZ6QzdP?=
 =?utf-8?B?aDIvVVBFZElqLzJ0VTgvWitYSXd5UjBKZ1c2Uis1d21IWGNwa3Q1R1J5ZGsz?=
 =?utf-8?B?UEppM1habWRDWFZJajYrUDQrR0dLVHlIYzJieFJySkZsWHBoSmtqaW03N3lN?=
 =?utf-8?B?b3FuVy9IQTRVL3cxZ0ljY25lbVVxNW1HQTNlOXpHeCt4bE9mOGszNmhrdUZH?=
 =?utf-8?B?d3d0WFZWMkF5UmdXeTc4UW0zeFkwUHZHRm85WHcvRm9uVFgrTVJZVGtFZGEv?=
 =?utf-8?B?MlZITHRLengzL1RSMnBuVkg0em1jSVpUQVNLSHprM1JESC84cU1xUXlmTWpk?=
 =?utf-8?B?QS9aVlJwNUZzZU5hbHVZS2JDc3JoNUU3SGNwWmp3blh6UTY1ZGs3ZytUREhV?=
 =?utf-8?B?S29hM0N6a0lsMGt5RTV1eGJQbitZR0FkTEZwdWJOZ0tlUkN4UndlTHg2QU1J?=
 =?utf-8?B?RE1CeTZUcXBBN1lwMGVwZE9YWXVZMjBwSytkY1I0WUQybDc4alExRUFObGph?=
 =?utf-8?B?K0c1aHF5NnE3cDZZZ29PZHd4Z0xsbHJkeUFrRklGbWsyZldvbi82aEo5dDdu?=
 =?utf-8?B?ODJsOGlxYlE4ODNjR1RqMGxRaDllK1V3Uy9mWjJBYUVjTnFCbkdpQ3pGeGVJ?=
 =?utf-8?B?OXNQOTloU1JYZzd3Mk9EMzhjVm5GL1ZBd2JNQklwZEVhL0xWZXEzNHYzd2o1?=
 =?utf-8?B?M2hwVnJFdSsrUDRPWjB6QzF4Y1lvZGVXYlRNdDFoajVwbVYvNFZlUWhOUFZt?=
 =?utf-8?B?L2VneElqVFdFajhWY3hFWGlWVmtJQnJKYXRWSVREZDNrWDdMY1ZQeWtLZWlD?=
 =?utf-8?B?M01Rc2gxNUJqTHUyVmFyQWx3MlBhU0dQNEdKeERxWmRaMGxBZGx4eUUzelNG?=
 =?utf-8?B?OHkweWZ5QmJIM2w3Z1dBeTNzK0oxSzZHMEE2ak9lS1JoOXhDaGRoeU5qc0RB?=
 =?utf-8?B?aU1WdnAyaCtXT2RVR0NGVkxtZVVURlk0ZXNwT2ZGRTZseXJnK0hGbDl4WmlJ?=
 =?utf-8?B?MlA5U3BRdUNsZlN2b281d0tGNjhhZzhvWmp2S0xtQUdoaUdZR1F5THRTcGNs?=
 =?utf-8?B?YlZSTmxwU1F6WTF1Nnl1MTJyaXg2eDlUUFluTlBuZ1plRTNwaFFUMG50dFJj?=
 =?utf-8?B?aUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88FE5E133519DD4C87039536D4F06B20@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6db7c62-e236-4ff9-4665-08db783bfcee
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 00:58:44.4525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rxWqVy85YNmd+5gPQxdURc7XGupCK5ZW9g4g/sHoi6axm6R3TPbEvLIm4G7DOzvNgPI2lkQKX5/kZcqcAnRsKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7189
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE3OjMyIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8yOC8yMyAwMjoyMCwgTmlrb2xheSBCb3Jpc292IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiDC
oCArwqDCoMKgIC8qDQo+ID4gPiArwqDCoMKgwqAgKiBTdGFydGluZyBmcm9tIHRoaXMgcG9pbnQg
dGhlIHN5c3RlbSBtYXkgaGF2ZSBURFggcHJpdmF0ZQ0KPiA+ID4gK8KgwqDCoMKgICogbWVtb3J5
LsKgIE1ha2UgaXQgZ2xvYmFsbHkgdmlzaWJsZSBzbyB0ZHhfcmVzZXRfbWVtb3J5KCkgb25seQ0K
PiA+ID4gK8KgwqDCoMKgICogcmVhZHMgVERNUnMvUEFNVHMgd2hlbiB0aGV5IGFyZSBzdGFibGUu
DQo+ID4gPiArwqDCoMKgwqAgKg0KPiA+ID4gK8KgwqDCoMKgICogTm90ZSB1c2luZyBhdG9taWNf
aW5jX3JldHVybigpIHRvIHByb3ZpZGUgdGhlIGV4cGxpY2l0IG1lbW9yeQ0KPiA+ID4gK8KgwqDC
oMKgICogb3JkZXJpbmcgaXNuJ3QgbWFuZGF0b3J5IGhlcmUgYXMgdGhlIFdCSU5WRCBhYm92ZSBh
bHJlYWR5DQo+ID4gPiArwqDCoMKgwqAgKiBkb2VzIHRoYXQuwqAgQ29tcGlsZXIgYmFycmllciBp
c24ndCBuZWVkZWQgaGVyZSBlaXRoZXIuDQo+ID4gPiArwqDCoMKgwqAgKi8NCj4gPiANCj4gPiBJ
ZiBpdCdzIG5vdCBuZWVkZWQsIHRoZW4gd2h5IHVzZSBpdD8gU2ltcGx5IGRvIGF0b21pY19pbmMo
KSBhbmQgaW5zdGVhZA0KPiA+IHJlcGhyYXNlIHRoZSBjb21tZW50IHRvIHN0YXRlIHdoYXQgYXJl
IHRoZSBvcmRlcmluZyBndWFyYW50ZWVzIGFuZCBob3cNCj4gPiB0aGV5IGFyZSBhY2hpZXZlZCAo
aS5lIGJ5IHVzaW5nIHdiaW52ZCBhYm92ZSkuDQo+IA0KPiBFdmVuIGJldHRlciwgZXhwbGFpbiB3
aHkgdGhlIGJhcnJpZXIgbmVlZHMgdG8gYmUgdGhlcmUgYW5kICpJR05PUkUqIHRoZQ0KPiBXQlZJ
TkQuDQo+IA0KPiBJZiB0aGUgV0JJTlZEIGdldHMgbW92ZWQgLS0gb3IgaWYgdGhlIGdvZHMgZXZl
ciBibGVzcyB1cyB3aXRoIGEgaGFsZndheQ0KPiByZWFzb25hYmxlIHdheSB0byBmbHVzaCB0aGUg
Y2FjaGVzIHRoYXQncyBub3QgZnVsbCBzZXJpYWxpemluZyAtLSB0aGlzDQo+IGNvZGUgaXMgc2Ny
ZXdlZC4NCj4gDQo+IFRoZXJlIGlzIF96ZXJvXyByZWFzb24gdG8gdHJ5IGFuZCAib3B0aW1pemUi
IHRoaXMganVuayBieSB0cnlpbmcgdG8gZ2V0DQo+IHJpZCBvZiBhIG1lbW9yeSBiYXJyaWVyIGF0
IHRoZSByaXNrIG9mIHNjcmV3aW5nIGl0IG92ZXIgbGF0ZXIuDQo+IA0KPiBJIHVzZSAib3B0aW1p
emUiIGluIHF1b3RlcyBiZWNhdXNlIHRoYXQncyBhIGhpZ2hseSBjaGFyaXRhYmxlIHdheSBvZg0K
PiBkZXNjcmliaW5nIHRoaXMgYWN0aXZpdHkuDQo+IA0KDQpBZ3JlZWQuICBJJ2xsIHRyeSB0byBl
eHBsYWluIHRoaXMgd2VsbCBhbmQgY29tZSBiYWNrLg0KDQpUaGFua3MhDQo=
