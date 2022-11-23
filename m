Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C05635C0B
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbiKWLpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbiKWLpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:45:13 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF6B125226;
        Wed, 23 Nov 2022 03:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669203913; x=1700739913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jIgLLsEa7q0gFS8OyhMnhtVP9dPXvoi/fDFzbbNwfbY=;
  b=IExx+u3tGeLn+630Cm0/4hBgASi43trZBxrWIIwuma//jU/3A84vahYY
   9sXgivwIEkUfr8ix9vBtxMev7Ls2+B0+9Xeng69xMCx6O6roBYyshWlsP
   7ZGo/lfCuhT/hM55CUM4RYUbWmoy0SXthRTy0cTfuJ5ENpuGN58TaqRDM
   hK7X6bTpkqm0SvN0m7JR+clpsUb5TvGcY4hMNLaIO2gmY+U9WAGnCLKxd
   Ow0HvwRRaQrtK7Gj5r9lN1nlT9SEssDfwVSYUABu2Jggli6s8avpyEF/E
   8nsL+I1ATYaoFr36zxr+IBqEyYRpFjA6zv9F05ZZY/l+ibNXmy/B7Budf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="293755219"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293755219"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 03:45:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="766692556"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="766692556"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 23 Nov 2022 03:45:12 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 03:45:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:45:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 03:45:11 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 03:45:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxLyd7U8DUKFMzQO5KMHmDYMtOSGLdVC3v7wYiurBRQ2naJ5Z6wTmAf1oHXlipFkyL3KYi+ChMcbzVhe4XPNrFXvvoAkdrOHAxRWKvsi3tvpZK5x6MJhDUuEoCRlCvlsPm4A4j9uwafnxhksYU+tTPh8qZgBjKZTq2Zgs+xAndrsGZ4r3kOyXQfM/ELychjiHtFKmQp9owEvSu23Os4JODoiwRVE90wCekJnirjjQlk86CsfH+Za2AIZdz4EwDQJtryXO1+A2pu0URInmQNgQWjUAk2gVGWmQLPFlk04uw2e5Ots1NkB/8euhaiVM9Ulg6KAsoQbTVMWMPOt/VLUtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIgLLsEa7q0gFS8OyhMnhtVP9dPXvoi/fDFzbbNwfbY=;
 b=IS+2lGXJ03IBlbjzmWZSretgENAh7VONQ1+O2GavK1iFdcjsBy7YGzDAIkLrHSbzN5ihpIqYAG655MH4rXgId8ocqCoDsp0M6Ic91hsXlwhnHWKwnT5lF7sI9FirfNdsFWHdawOzN52a5HXxLeaS/6AL8bZNl5gh15m01Wa0y7qQZhUi/t5DhsfC+jkJFBKsqEsNOXfNuoQaEY2TBjtHpXyiWlhAKDbLYLcwb/WEbiv3dYIdurhsodHHuRdYqPoE8oMElgX7hGjjlQEqb/rEpcCjIOUiY9hhX6fIcvuAk5da5tTyLMO6AcCOymW1qOllhQd7VbsnQ23LN0r0p1HoYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB7030.namprd11.prod.outlook.com (2603:10b6:303:22f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 11:45:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 11:45:08 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 07/20] x86/virt/tdx: Do TDX module global
 initialization
Thread-Topic: [PATCH v7 07/20] x86/virt/tdx: Do TDX module global
 initialization
Thread-Index: AQHY/T3AcnJWM24MoEi7jkvBHZxxeK5LUriAgAEU24A=
Date:   Wed, 23 Nov 2022 11:45:08 +0000
Message-ID: <4e3a0a5a44fd4b7a5eef050f43bce0db5bb2d2d5.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <40824ec3e3dc759705dcfa1cb2929d18c12b417a.1668988357.git.kai.huang@intel.com>
         <2cbd2fe3-91ea-49e6-d684-b1fab012b44e@intel.com>
In-Reply-To: <2cbd2fe3-91ea-49e6-d684-b1fab012b44e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB7030:EE_
x-ms-office365-filtering-correlation-id: 43c56f54-29fe-4787-69e3-08dacd482bfe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0CQa5JQtg3iUekLg1unr5dsfULuAtrONoIYc2BYzILnajTEDmruQu1/oPiqp8hghahmuUpFkf3T/K9xXr8xVILz17htd1kjBohrGOObAtm0PFNTe+uYHT8rqAWVXw+YC5JgN9Fap9IUYKohdgIdDzCOdK2KLEPMxVJTEKMMNDAbh4h+M5cTabgp+G/RYmywJHZET4mWotQCJDZYVIfaCpn+94pIb/rwb6rhkL07/yQFQM8xaTU7Zhu5+gYv0kKwb/xEOGINxwSbZu/brBwV2FdhqPIdL1xtQslfH7A0vn957f/cDbeDSZNXnfXCRW6US+LrLGe5JAhzWpdZrj4Tuwk7/14rKT7PWk5jIhxe3KAqELXxCekSx9hI3kQlnXm49zKJz6kdMW3lnmI4P4A3TV0KHJsudZwTlJQIG4RqjXigTNb3vwe1jHYxw586C9tmvIOh33NpaKogp+JSEU/LkxSC4s50CgloWkq1Hx1JA5k4mWOE94ak92UuO3vUHMJvDq4+eCIH7F/J9vsGwpJKYwwfJtLxV4UWiKGxjV56VDKZGu71qEOHxGMRP2DNatQqpASsl9HBO/CdxYqgFGs58wgDcb6tgJyHl42YCK0sclFyGTvbD+M2f5ZYHKSQzMSWZyD+6aQqXrXEnme4elHk04JzRMviVuYixFXUTLt5sLrUDZct/JGJvtRRJgEh1VOXgR5oHltm3n7FGJwqVRYuNqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(82960400001)(122000001)(38100700002)(86362001)(6506007)(38070700005)(53546011)(5660300002)(76116006)(26005)(71200400001)(186003)(66946007)(6512007)(316002)(66446008)(64756008)(91956017)(2616005)(478600001)(66476007)(54906003)(6486002)(4326008)(110136005)(8676002)(66556008)(8936002)(83380400001)(2906002)(7416002)(41300700001)(4001150100001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk9RMnB3WFBuKytnYjE2aTlKN291T0RldEVMSGhmUGR1eTZwVXRMNzdNUnhJ?=
 =?utf-8?B?aGJuY0hlNGpuTjN1d1lNMkFXS0FPVjMyNXg2Mk9WSEt1bG1mcHpQcE56NXF2?=
 =?utf-8?B?dGY3VC8vSWpIU21BWnJRVkpNNkZDSWZLU2tBZHhKNkk1OEtSbTBTV1FaZ2pD?=
 =?utf-8?B?eUx0ZXIxc1dydWRUN1ZXV0IybzZWd1JlYVVsSlVCTDkxTTR6Y1BFd0t2M1kz?=
 =?utf-8?B?MFJoVTVpSVh3QWE4QnhzbzhWU2dQcmllSnRoWnk1R1k3cWM2MkMvTG1JZjBw?=
 =?utf-8?B?YjAwNi94RThVZ3MwdUZMUlppSlRuSUlaMzNVbk44OUE5ZytIRG11SG5xdndo?=
 =?utf-8?B?S0xLeldnNTR4US82NVNvSTg2SkorUzQ2ck1XcElyMDdYa0V5RnZwaCtXVmZU?=
 =?utf-8?B?dUNadC9seHRydzlaaVd0SlhjVGovR011WEI4ekxLY3VnNWFENkdpOFllVVJl?=
 =?utf-8?B?b2w1cytBODNHMytjOHlJWjRwN3NsbjZLZSttUlFxUVdlejVRaTlWZzdHUWRU?=
 =?utf-8?B?dGlYTEZneXZoc0MwNkg5RWlXbitsbERtUFUzcWFMVE93VnFhVlV4S3JWazNm?=
 =?utf-8?B?enZxMk5hb01SRjAraGRJVmxWemhRZTc4LzBJdWlUajVYNXFUYkFibkRHbDZi?=
 =?utf-8?B?S2ZiYmtKbWpFVWRLeS9jMyt4SWpxOExkcjdvSjBEWHdxV1dWYmdNQjNBOHpz?=
 =?utf-8?B?eFF2c2hjVXBjay9TTGNVRHd2TWRNQ2Zzemk5SFRzMTNHWTFIMnppUmtTSzdR?=
 =?utf-8?B?TUNVNjF4b0RieXRTQzZleDF0Q0ZLOGFBbWIzR3hSVHJtOXk0Q1NpSitUekRU?=
 =?utf-8?B?aHJjZFB5aDRCaGNxZ01jeUl5NTRGWnFvMXZiT0lrbGNYRThrUEplZlBJdE00?=
 =?utf-8?B?TVM3VkpxZUV3NHdZblM3UW43UW15bnlsakJBS0U5YUpjbXZaWldOejhac05G?=
 =?utf-8?B?WHhpVHNWQ0VnMld2eSttQm5aR0ZBejhobEZGSVJGVy9pWlRFVDNndG5xTTNl?=
 =?utf-8?B?WGpOY2ltMWhzZjRUa0JZRmJhQmNBemZNOUZDOEgrQktmR0xaTHBCaWFoQlFR?=
 =?utf-8?B?ZDh0bU42OG0wV1pINlFoTFZOeVBFemtSR1Z6bHM0WCtaMnd1QTlqcG1xeUhm?=
 =?utf-8?B?YWUzVjVxREpUbEM2RnV0T2IzVk5Kc2FqQlhQUmZEZU9MQTM3ZDgzeVQydU9p?=
 =?utf-8?B?MGozZklxM1dnVHVmSTdjaWZmWEhxT2dvMVY4SmRHaGtpSEVEc1M3ZDFmdGU4?=
 =?utf-8?B?WUpwYTlWQ2t5bk5ERGtENXdsU25HTmFvZXZKb1dZWXVrb2dWWWtGL0FPa0wv?=
 =?utf-8?B?eVQ3NWhpTVVJamdHK0wydHlqTE9LQ2Q1clVrMEp3Qk41dUV6NzA4R0d2TDk1?=
 =?utf-8?B?Vi9lL01ncThhNXFVM2tmZm92ZW92T3dSUGhINnVLaEVxZGpGSHMyclhCYk9m?=
 =?utf-8?B?VnRnWWxZQklWbzhDNnBnbkF5K3dRSEZUdlFNcG9nM0ZWSzRmVGZEOFFxS0Zs?=
 =?utf-8?B?YmlTYkNWYk5reVVCMWxRTFZRM0ZQdTc3QWtFWlA0T2ErWmZrWG16VUcxS0ov?=
 =?utf-8?B?NkQ1alNnMDFucEtZcVlpOFZBU2NQeEpKZ0E4NGY5VEFBblhPS3YyRHZoMWJT?=
 =?utf-8?B?RW01UVBiMlhPWUVHUTBjelRVRDRlR1dXa2VPVmFmSnhseTd5enhEWk5YL3ho?=
 =?utf-8?B?U3V3K2dobzgzMCtnU3E2dGt4SWduTTB5T25GRFRNb2FtaE5jWHA5MXlENnky?=
 =?utf-8?B?SjVPZGg3dU1TVmNBMkY3Q21KNE0yeUNsUVF5UndoZ2dVK3Vlb2FJR0RmUVl3?=
 =?utf-8?B?SWZPaVEzL3FmV0psNlBlRDlwVERtV3Zhdnl5SzJVd2hURndOUkVDQTZWVDd0?=
 =?utf-8?B?VmJwRFF1RitHdUMxZndEVUFNMDlldlI4RTUrdEtKdkcxaUNxZ2VrVkVmbGpy?=
 =?utf-8?B?QUdFZU43N2VKdGtzNm5EWEhURlhldGxDSmhZblF2WjFEYVl0SGgvbGUzWWx5?=
 =?utf-8?B?aFFIeWllQ0F2R1dMZEZ5YWZhcnI3dVk0N1RqN2VoUGtMMFp2MnhhTUc0RmdB?=
 =?utf-8?B?WjhtYmtyTXNDUDArTUkzQ2ZVNzRMNC9IYUVUYk53S05GT0UzWHd5bkFBQjVp?=
 =?utf-8?B?d3lQK0NlcGI2TGJMa3lOMDhYeXdQRWEyMDNsVHg5QnlicStuL2pWaXY2M1R3?=
 =?utf-8?B?Wnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5F68CDA743D99439CA8F944765A92A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c56f54-29fe-4787-69e3-08dacd482bfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 11:45:08.5467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eva2ER4wWVr6QRLhiqxONu7quPN/odGuilCEpBggK02TEzWBh6skO7mkhvKG1Q0eEQb71wkiUcEwPK3GrzjB9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7030
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDExOjE0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBUaGUgZmlyc3Qgc3RlcCBv
ZiBpbml0aWFsaXppbmcgdGhlIG1vZHVsZSBpcyB0byBjYWxsIFRESC5TWVMuSU5JVCBvbmNlDQo+
ID4gb24gYW55IGxvZ2ljYWwgY3B1IHRvIGRvIG1vZHVsZSBnbG9iYWwgaW5pdGlhbGl6YXRpb24u
ICBEbyB0aGUgbW9kdWxlDQo+ID4gZ2xvYmFsIGluaXRpYWxpemF0aW9uLg0KPiA+IA0KPiA+IEl0
IGFsc28gZGV0ZWN0cyB0aGUgVERYIG1vZHVsZSwgYXMgc2VhbWNhbGwoKSByZXR1cm5zIC1FTk9E
RVYgd2hlbiB0aGUNCj4gPiBtb2R1bGUgaXMgbm90IGxvYWRlZC4NCj4gDQo+IFBhcnQgb2YgbWFr
aW5nIGEgZ29vZCBwYXRjaCBzZXQgaXMgdGVsbGluZyBhIGJpdCBvZiBhIHN0b3J5LiAgSW4gcGF0
Y2gNCj4gNCwgeW91IGxhaWQgb3V0IDYgc3RlcHMgbmVjZXNzYXJ5IHRvIGluaXRpYWxpemUgVERY
LiAgT24gdG9wIG9mIHRoYXQsDQo+IHRoZXJlIGlzIGluZnJhc3RydWN0dXJlICBJdCB3b3VsZCBi
ZSBncmVhdCB0byBsYXkgdGhhdCBvdXQgaW4gYSB3YXkgdGhhdA0KPiBmb2xrcyBjYW4gYWN0dWFs
bHkgZm9sbG93IGFsb25nLg0KPiANCj4gRm9yIGluc3RhbmNlLCBpdCB3b3VsZCBiZSBncmVhdCB0
byB0ZWxsIHRoZSByZWFkZXIgaGVyZSB0aGF0IHRoaXMgcGF0Y2gNCj4gaXMgYW4gaW5mbGVjdGlv
biBwb2ludC4gIEl0IGlzIHRyYW5zaXRpb25pbmcgb3V0IG9mIHRoZSBpbmZyYXN0cnVjdHVyZQ0K
PiAocGF0Y2hlcyAxLT42KSBhbmQgaW50byB0aGUgYWN0dWFsICJtdWx0aS1zdGVwcyIgb2YgaW5p
dGlhbGl6YXRpb24gdGhhdA0KPiB0aGUgbW9kdWxlIHNwZWMgcmVxdWlyZXMuDQo+IA0KPiBUaGlz
IHBhdGNoIGlzICpUT1RBTExZKiBkaWZmZXJlbnQgZnJvbSB0aGUgb25lIGJlZm9yZSBpdCBiZWNh
dXNlIGl0DQo+IGFjdHVhbGx5IF9zdGFydHNfIHRvIGRvIHNvbWV0aGluZyB1c2VmdWwuDQo+IA0K
PiBCdXQsIHlvdSB3b3VsZG4ndCBrbm93IGl0IGZyb20gdGhlIGNoYW5nZWxvZy4NCg0KSSdsbCB0
cnkgdG8gZW5oYW5jZSB0aGUgY2hhbmdlbG9nIHRvIG1ha2UgdGhlbSBtb3JlIGNvbm5lY3RlZC4g
IFJpZ2h0IG5vdyBJDQpkb24ndCBoYXZlIGEgY2xlYXIgY2x1ZSBvbiBob3cgdG8gd3JpdGUgaW4g
YmVzdCB3YXkuDQoNCj4gDQo+ID4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8IDE5ICsr
KysrKysrKysrKysrKysrLS0NCj4gPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIHwgIDEg
Kw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2Fy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IGluZGV4IDVkYjFhMDVjYjRiZC4uZjI5MjI5
MjMxM2JkIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+
ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IEBAIC0yMDgsOCArMjA4LDIz
IEBAIHN0YXRpYyB2b2lkIHNlYW1jYWxsX29uX2VhY2hfY3B1KHN0cnVjdCBzZWFtY2FsbF9jdHgg
KnNjKQ0KPiA+ICAgKi8NCj4gPiAgc3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCj4g
PiAgew0KPiA+IC0JLyogVGhlIFREWCBtb2R1bGUgaGFzbid0IGJlZW4gZGV0ZWN0ZWQgKi8NCj4g
PiAtCXJldHVybiAtRU5PREVWOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwkvKg0KPiA+
ICsJICogQ2FsbCBUREguU1lTLklOSVQgdG8gZG8gdGhlIGdsb2JhbCBpbml0aWFsaXphdGlvbiBv
Zg0KPiA+ICsJICogdGhlIFREWCBtb2R1bGUuICBJdCBhbHNvIGRldGVjdHMgdGhlIG1vZHVsZS4N
Cj4gPiArCSAqLw0KPiA+ICsJcmV0ID0gc2VhbWNhbGwoVERIX1NZU19JTklULCAwLCAwLCAwLCAw
LCBOVUxMLCBOVUxMKTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJZ290byBvdXQ7DQo+IA0KPiBQ
bGVhc2UgYWxzbyBub3RlIHRoYXQgdGhlIDAncyBhcmUgYWxsIGp1c3QgdW51c2VkIHBhcmFtZXRl
cnMuICBUaGV5IG1lYW4NCj4gbm90aGluZy4NCg0KV2lsbCBhZGQgdG8gdGhlIGNvbW1lbnQuDQoN
Cj4gDQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIFJldHVybiAtRUlOVkFMIHVudGlsIGFsbCBz
dGVwcyBvZiBURFggbW9kdWxlIGluaXRpYWxpemF0aW9uDQo+ID4gKwkgKiBwcm9jZXNzIGFyZSBk
b25lLg0KPiA+ICsJICovDQo+ID4gKwlyZXQgPSAtRUlOVkFMOw0KPiA+ICtvdXQ6DQo+ID4gKwly
ZXR1cm4gcmV0Ow0KPiA+ICB9DQo+IA0KPiBJdCBtaWdodCBiZSBhIGJpdCB1bmNvbnZlbnRpb25h
bCwgYnV0IGNhbiB5b3UgaW1hZ2luZSBob3cgd2VsbCBpdCB3b3VsZA0KPiB0ZWxsIHRoZSBzdG9y
eSBpZiB0aGlzIGNvbW1lbnQgc2FpZDoNCj4gDQo+IAkvKg0KPiAJICogVE9ETzoNCj4gCSAqICAt
IExvZ2ljYWwtQ1BVIHNjb3BlIGluaXRpYWxpemF0aW9uIChUREhfU1lTX0lOSVRfTFApDQo+IAkg
KiAgLSBFbnVtZXJhdGUgY2FwYWJpbGl0aWVzIGFuZCBwbGF0Zm9ybSBjb25maWd1cmF0aW9uDQo+
IAkgICAgICAoVERIX1NZU19DT05GSUcpDQo+IAkgLi4uDQo+IAkgKi8NCj4gDQo+IGFuZCB0aGVu
IGVhY2ggb2YgdGhlIGZvbGxvd2luZyBwYXRjaGVzIHRoYXQgKmRpZCogdGhvc2UgdGhpbmdzIHJl
bW92ZWQNCj4gdGhlIFRPRE8gbGluZSBmcm9tIHRoZSBsaXN0Lg0KPiANCj4gVGhhdCBUT0RPIGxp
c3QgY291bGQgaGF2ZSBiZWVuIGFkZGVkIGluIHBhdGNoIDQuDQo+IA0KDQpUaGFua3MgZm9yIHN1
Z2dlc3Rpb24uICBXaWxsIGRvLg0KDQpJIHRoaW5rIEkgY2FuIGRvIHRoaXMgdG8gImNvbnN0cnVj
dCBURE1ScyIgcmVsYXRlZCBwYXRjaGVzIHRvby4NCg0K
