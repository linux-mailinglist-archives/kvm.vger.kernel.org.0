Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD352728D9A
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 04:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbjFICIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 22:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbjFICIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 22:08:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D19C35BC
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 19:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686276499; x=1717812499;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=skFc/MqYDd7hRTOeYxSSW4P7X02eeM3Xuohu67Rs8L8=;
  b=USq6ujSgvQMBVXHL4zWfZIPBMX7E3TV3w806R8Bdfb+BuWg9RfcL5690
   ww2XM7/cYVh+9WjmHGe+geFQzpJcQ1KnM22/tOslAFY46DEfE/hSi6u2A
   +4DaQP+q6QFQqeSZrOWfXUMUizL2PvR6q42VJQenpmn8wTHSZ6pZ4BPjy
   ej1zS5wOGtjAKwmckMfaI+E2Z21b2aNFqVTqWh++gLkMOhjMsvASUQmne
   duGMatEgr+rd1XuoHI7JR1H1t0UqioOu/+evop2jXRs/sXD+Qtn1541Rb
   u3h7i5Lb3BbmRWABqhz3MknstvIJGVwzW8YoRl8tIhzx/zgCu8X293YII
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="360846660"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="360846660"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 19:08:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="1040328863"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="1040328863"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jun 2023 19:07:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 19:07:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 19:07:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 19:07:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 19:07:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVRTlclWs0fP4fHgP5e6whSre/9/1taROC3mLvrVpB4uMRw5lvGDFp7k0qFu7HmLUei4gNy3oefu2HeYmckdxR1K+IOCCvOAzpfRnvXKS+dOhCxT6nwTy7Hw1IxEcc7Ot8g9SBbXSpdUoCtMGTNCRw9oAOEwQjSIgshtK5k54EAiq55wLjMIzw7eaSD/ytpGXK00Gk1+h+L49EzBcpDGi0Jh4WaTBjVSPbsHfr6kPjsHNMkCHI/g/lo3W6FOpX1vlPyjqM9aLcFY1cMgjgawTwHQhIkNs05Hp/WmYP0xItCbrsIRuXBNO3EfJBdiKd625poA74liXpmaOlDUVOzDNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skFc/MqYDd7hRTOeYxSSW4P7X02eeM3Xuohu67Rs8L8=;
 b=ewD2eAo8CxXECQFdVufg0QL+j5TZbKZeHxTGHT9Sd8E9z/930VKKU1oMBCWRHkF6lmyzSgwEyObW9veaoUksmOJokuhLC0iAcelutY6FR1/MehB8BEEqBcdFovDJ5HTrYbEX6oAZ5yJt1jaV6bTBC3WN1qvxJQpLmir6LebFHBDqnru15ObYgGWAl08F68q85O19oi10nDiN0KJpYD8dDC2ENHrIHscu5z4XstNxcVAtKAIe/4zFiQ1QSTBSiLFuQ2r7dQFIp6aVMlvbDW6AtfsgyayNx9C8lQM5j03Qamd/qY8uI0/jBOKgV41N45cfWOnWhfLetpX1lWYslHgl8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by MN0PR11MB6303.namprd11.prod.outlook.com (2603:10b6:208:3c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 02:07:48 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a86d:e44f:380f:86c6]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a86d:e44f:380f:86c6%5]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 02:07:47 +0000
From:   "Chen, Jason CJ" <jason.cj.chen@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "android-kvm@google.com" <android-kvm@google.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>,
        "Chen, Jason CJ" <jason.cj.chen@intel.com>
Subject: RE: [RFC PATCH part-5 00/22] VMX emulation
Thread-Topic: [RFC PATCH part-5 00/22] VMX emulation
Thread-Index: AQHZVMjjkIJAGzww10G2XmdQMAuYo6748H2AgAGKPYCAh36zgIAAQRjg
Date:   Fri, 9 Jun 2023 02:07:47 +0000
Message-ID: <SA1PR11MB59230DB019B11C89C334F8F2BF51A@SA1PR11MB5923.namprd11.prod.outlook.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com> <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
 <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
In-Reply-To: <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5923:EE_|MN0PR11MB6303:EE_
x-ms-office365-filtering-correlation-id: 5732a33d-44bd-42f0-4f5f-08db688e521f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eQhIblx2RRCB06TQlFdFKy/SByTHg+jSTQ/EetKbcURARa0slXmxlmH0QScqqe9WCYXjUoRErFp5BF1NCGMkrdzz63DVHNB96SQreyIDCPCjiBTHc2/1x4jlJZkSkt1jKspcUC6ngj3KSXUBA9LIga+2Ta8/6HhhsHPAHleBG+zj4GKR+4joOjMQUv08ezE5IJp1MyPxrT5tqjoSqLadho1kpQ6j+4643Vu8YUJsQcVnHw/XIC1yd1DWtQbD4O5Fb7bHHu9WcZL+HoEiI+/0GM6pbhFdUKl1lSyLeTygaxPxl4wl96czPScgm9IT4uXXxcplxVx28u4kw+vTT6UsSoLNCeZFgOWZiZPvLkauYXrttAmi5/EBqMULkDK4YRzXLbZzMCQEEUYjA7bWjylKRZY2F6CZ3ThEWdQM5cSlKaEnhCBOeFUkG8THbCIHNtnZztoWPC3f2H64f8Wya1BLJWD5/T+rUBxwu9DCkXAU6idbYR21vbMSoJxY4KbFDKo3zAel/w674ouDjkHXelELWxpl0DXlleqI2FUEJ8ck9NjqG8XdlQHpLegkekJsLYRRs9b2HFdYeItaj9iq3EIcM9D2OLk/NNhPIQvUUqlC5acp3EBEiXy7gIjqiyO64zKy3axV0dotd9TpW3lfHjKMdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199021)(7696005)(71200400001)(55016003)(33656002)(86362001)(26005)(122000001)(38100700002)(82960400001)(38070700005)(6506007)(9686003)(107886003)(186003)(53546011)(83380400001)(8936002)(8676002)(5660300002)(41300700001)(316002)(52536014)(2906002)(54906003)(110136005)(66476007)(478600001)(76116006)(66556008)(66446008)(64756008)(4326008)(66946007)(399854003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QU9BcVk0RE94QXllODFLakZDcnRZL3IzdHoyQ2xtYTZNOVYyTVRSaU1iajFW?=
 =?utf-8?B?S2NTMDUwdVFsSFVIUHRadmFtMEFLeXg4Q0VDQWpHdFRQa2ZlN0p2a3JpU3do?=
 =?utf-8?B?UlU3R3JYdnEvT2tDTk9CdkNSK0Z0ZFIvT2N0UFFmMGhJamV5d2MySTUwazhq?=
 =?utf-8?B?bnFCVVhUaW8yOXViZUV3Uk81bEt6ZVFGZG9sZ25OeWdmbllrd0g2L1crYlgx?=
 =?utf-8?B?YkkwdWMrUXVFakEvaERmQm9ERVNUbHVvRHdXY3lWQXJHcnk2bE41WHpuL1lv?=
 =?utf-8?B?aFBIZm53YUpnRmVKbGJzMXUzSEM2bDFWTEN5NGtNNG92bWMvb09hKy9qVm9s?=
 =?utf-8?B?WmlqdWR3MXZUVloyK2gweEQyM20reEl2SkhaNTdhZU9KaDJQR28vMHJ2WDY1?=
 =?utf-8?B?ZGRBMnlqRVN5NGtxREtzL0RPSnd3d05mL2N4ckkzdE5WbWRPQ1lXblRwTWxG?=
 =?utf-8?B?aURGK3VRc2FEdE9neExjZFp3Q2YvZFpPbFIxREQvUDJ1L3BSUit1MjA3TzRk?=
 =?utf-8?B?aXFWZTRXeG9XcEN1VkJQK3RxTlVJTDFVaFlUd21pMG5ib2xjMjRnSFpNTDNC?=
 =?utf-8?B?ZVNyOWIzSEUxN1VFd1ppcDk1bFlJMS9jWDdWS2plbncwRnlVaWxHT3kxczZQ?=
 =?utf-8?B?MURXOXFjRWQwd05mVHJSS3Bna2NyN1NIN0JlQVNOck5vOGZkRkxiaS9qRjZ0?=
 =?utf-8?B?TWtXSy9tUmtSL0hsUG43K2FlSmJJRHUySjAyaHJacm9UdU8wZmEyTjZUOXhx?=
 =?utf-8?B?UlRYS1doTDc3Wk9MNmM4K0kwQm5PKzlqSkxRWUxQSjBKWUoyNmZDT05vdERX?=
 =?utf-8?B?V1E5RUNnRU5BOGZERGFraWEvRnlnRHNOUTgydDhXcUlIa0Z3RkkyQkdwY3l0?=
 =?utf-8?B?ZHpFaE04ZmdJNi9GWXhHMGk2VVRYKzF1ZHdxdTVGMDEyd0pSSkRMeGJKRWRE?=
 =?utf-8?B?SVBtcjZpUjBkU05HSmJmWGkybDNmVmJ5RURueGJxRFVvZm5WcUtrbFZSWGZp?=
 =?utf-8?B?UVgxeS93d05Ec0lDalZaeFZuK3lOeThaR2VZa0ZHMUdVWnMvUFdjcUQ3Nmxm?=
 =?utf-8?B?VW9YNlJpQXFnTjlmeWNUbHZKK3NwUHMxSHF4K21pbkZMRGdyMUVvbSt5cU4r?=
 =?utf-8?B?a3lXeDhlc1lNVWExNmlwWFRwOXA3SzZiNmFManlBa2MrcmFHK2VJcjRseFQy?=
 =?utf-8?B?RmVRc0MyeC8wM0tvTW5HYUtYSk5qRDcwVkhpdXYzUkdYcm5qaVYzUlVZOFhr?=
 =?utf-8?B?OVZKZDRIdDcranR5SzEzYVk0MDJ6ZmZ4QWZpVEJhUXpneG5JYlVXa3RHWUxG?=
 =?utf-8?B?ZkV5Mk14dlZnWkhsbWR0dVhPZkpJRVJSZ21hc3I0dHhMb0p1a3NGNEl1bDJ0?=
 =?utf-8?B?b2lvbjhaRzVzWFNhQzl2MGc1dkk0bWhNNmt5WVYySUxEYWxaWDUya2VMYkFa?=
 =?utf-8?B?V0E1S21BK2k5bHZpV21jdCtuWGxISUJZemJDWFM2Q3JnODNlR0lzbzVFK2pI?=
 =?utf-8?B?QWo3UGN1R0JDMm90b2EzYXhxOWlBRTE4bENTTTBsWC9BeUgzV2hmY2ZFRERY?=
 =?utf-8?B?d0NndXBKYkhEWDg1cGJZL2NOQ0xSbWRaRXZrdG51bWZsRTRodDV6d3ZENnJC?=
 =?utf-8?B?SmloeG1xUzJMN0xWcHhmelppOEN4YTh6Mk5XWXR3dVNUNFY0VDVCK2l2Lzh4?=
 =?utf-8?B?dHZRdmdqTU1BRy92VlJ1M1pFYTdmMVBXVHh0ZGZUOVhtQlRma0FlZWdiOEZQ?=
 =?utf-8?B?UFZ5Vnk2VEQ4NVZ6c0xCeFhscWRaYlk1TllSekxOZWQ2MXlteGpaK0Z5STNy?=
 =?utf-8?B?K2FyZ0ZySDNwMzY1QlpIeFJzVUl3UURjbnU1U3ExTyszU2RGUTl0Nmd3ZlV4?=
 =?utf-8?B?MFlWVnBDOWE3Nm1uNzJWc2hwU2hpczYrQkF2UzlNQU0wcExqWWpmRjZNSDc4?=
 =?utf-8?B?YndwNHRCRE9Dd0hQNlJ4OWgwVk1BQlVMSWFSMXlzd2ZVbDMvcHlzNUZQYnR1?=
 =?utf-8?B?SzdmTGRYZUgrOVN0RGRBbUlqQWRYNk5SVHhNQ3JkaGs4RlRRZUZ5NTZCKzF6?=
 =?utf-8?B?bWlNRitmTi9mejA4azFGNkNqTGlGbWpCdVNrQ2VGQjdBdzBHakZPM2VGR1ZN?=
 =?utf-8?Q?m81+IPWHtbtRkGeQJ7Dr4YlLx?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5732a33d-44bd-42f0-4f5f-08db688e521f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 02:07:47.5426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 79FiA4sLW27VjlnFX81YypVb31wCQpzyP5W3DlL/TCRw2Qs2RPYAbWtgt2yLwBTwWo27Fgm2Lhz8hxUulGP5Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6303
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEbXl0cm8gTWFsdWthIDxkbXlA
c2VtaWhhbGYuY29tPg0KPiBTZW50OiBGcmlkYXksIEp1bmUgOSwgMjAyMyA1OjM4IEFNDQo+IFRv
OiBDaGVuLCBKYXNvbiBDSiA8amFzb24uY2ouY2hlbkBpbnRlbC5jb20+OyBDaHJpc3RvcGhlcnNv
biwsIFNlYW4NCj4gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBDYzoga3ZtQHZnZXIua2VybmVsLm9y
ZzsgYW5kcm9pZC1rdm1AZ29vZ2xlLmNvbTsgRG1pdHJ5IFRvcm9raG92DQo+IDxkdG9yQGNocm9t
aXVtLm9yZz47IFRvbWFzeiBOb3dpY2tpIDx0bkBzZW1paGFsZi5jb20+OyBHcnplZ29yeiBKYXN6
Y3p5aw0KPiA8amF6QHNlbWloYWxmLmNvbT47IEtlaXIgRnJhc2VyIDxrZWlyZkBnb29nbGUuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCBwYXJ0LTUgMDAvMjJdIFZNWCBlbXVsYXRpb24N
Cj4gDQo+IE9uIDMvMTQvMjMgMTc6MjksIEphc29uIENoZW4gQ0ogd3JvdGU6DQo+ID4gT24gTW9u
LCBNYXIgMTMsIDIwMjMgYXQgMDk6NTg6MjdBTSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3
cm90ZToNCj4gPj4gT24gTW9uLCBNYXIgMTMsIDIwMjMsIEphc29uIENoZW4gQ0ogd3JvdGU6DQo+
ID4+PiBUaGlzIHBhdGNoIHNldCBpcyBwYXJ0LTUgb2YgdGhpcyBSRkMgcGF0Y2hlcy4gSXQgaW50
cm9kdWNlcyBWTVgNCj4gPj4+IGVtdWxhdGlvbiBmb3IgcEtWTSBvbiBJbnRlbCBwbGF0Zm9ybS4N
Cj4gPj4+DQo+ID4+PiBIb3N0IFZNIHdhbnRzIHRoZSBjYXBhYmlsaXR5IHRvIHJ1biBpdHMgZ3Vl
c3QsIGl0IG5lZWRzIFZNWCBzdXBwb3J0Lg0KPiA+Pg0KPiA+PiBObywgdGhlIGhvc3QgVk0gb25s
eSBuZWVkcyBhIHdheSB0byByZXF1ZXN0IHBLVk0gdG8gcnVuIGEgVk0uICBJZiB3ZQ0KPiA+PiBn
byBkb3duIHRoZSByYWJiaXQgaG9sZSBvZiBwS1ZNIG9uIHg4NiwgSSB0aGluayB3ZSBzaG91bGQg
dGFrZSB0aGUNCj4gPj4gcmVkIHBpbGxbKl0gYW5kIGdvIGFsbCB0aGUgd2F5IGRvd24gc2FpZCBy
YWJiaXQgaG9sZSBieSBoZWF2aWx5IHBhcmF2aXJ0dWFsaXppbmcNCj4gdGhlIEtWTT0+cEtWTSBp
bnRlcmZhY2UuDQo+ID4NCj4gPiBoaSwgU2VhbiwNCj4gPg0KPiA+IExpa2UgSSBtZW50aW9uZWQg
aW4gdGhlIHJlcGx5IGZvciAiW1JGQyBQQVRDSCBwYXJ0LTEgMC81XSBwS1ZNIG9uDQo+ID4gSW50
ZWwgUGxhdGZvcm0gSW50cm9kdWN0aW9uIiwgd2UgaG9wZSBWTVggZW11bGF0aW9uIGNhbiBiZSB0
aGVyZSBhdA0KPiA+IGxlYXN0IGZvciBub3JtYWwgVk0gc3VwcG9ydC4NCj4gPg0KPiA+Pg0KPiA+
PiBFeGNlcHQgZm9yIFZNQ0FMTCB2cy4gVk1NQ0FMTCwgaXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRv
IGVsaW1pbmF0ZSBhbGwNCj4gPj4gdHJhY2VzIG9mIFZNWCBhbmQgU1ZNIGZyb20gdGhlIGludGVy
ZmFjZS4gIFRoYXQgbWVhbnMgbm8gVk1DUw0KPiA+PiBlbXVsYXRpb24sIG5vIEVQVCBzaGFkb3dp
bmcsIGV0Yy4gIEFzIGEgYm9udXMsIGFueSBwYXJhdmlydCBzdHVmZiB3ZQ0KPiA+PiBkbyBmb3Ig
cEtWTSB4ODYgd291bGQgYWxzbyBiZSB1c2FibGUgZm9yIEtWTS1vbi1LVk0gbmVzdGVkIHZpcnR1
YWxpemF0aW9uLg0KPiA+Pg0KPiA+PiBFLmcuIGFuIGlkZWEgZmxvYXRpbmcgYXJvdW5kIG15IGhl
YWQgaXMgdG8gYWRkIGEgcGFyYXZpcnQgcGFnaW5nDQo+ID4+IGludGVyZmFjZSBmb3IgS1ZNLW9u
LUtWTSBzbyB0aGF0IEwxJ3MgKEtWTS1oaWdoIGluIHRoaXMgUkZDKSBkb2Vzbid0DQo+ID4+IG5l
ZWQgdG8gbWFpbnRhaW4gaXRzIG93biBURFAgcGFnZSB0YWJsZXMuICBJIGhhdmVuJ3QgcHVyc3Vl
ZCB0aGF0DQo+ID4+IGlkZWEgaW4gYW55IHJlYWwgY2FwYWNpdHkgc2luY2UgbW9zdCBuZXN0ZWQg
dmlydHVhbGl6YXRpb24gdXNlIGNhc2VzDQo+ID4+IGZvciBLVk0gaW52b2x2ZSBydW5uaW5nIGFu
IG9sZGVyIEwxIGtlcm5lbCBhbmQvb3IgYSBub24tS1ZNIEwxDQo+ID4+IGh5cGVydmlzb3IsIGku
ZS4gdGhlcmUncyBubyBjb25jcmV0ZSB1c2UgY2FzZSB0byBqdXN0aWZ5IHRoZSBkZXZlbG9wbWVu
dCBhbmQNCj4gbWFpbnRlbmFuY2UgY29zdC4gIEJ1dCBpZiB0aGUgUFYgY29kZSBpcyAibmVlZGVk
IiBieSBwS1ZNIGFueXdheXMuLi4NCj4gPg0KPiA+IFllcywgSSBhZ3JlZSwgd2UgY291bGQgaGF2
ZSBwZXJmb3JtYW5jZSAmIG1lbSBjb3N0IGJlbmVmaXQgYnkgdXNpbmcNCj4gPiBwYXJhdmlydCBz
dHVmZiBmb3IgS1ZNLW9uLUtWTSBuZXN0ZWQgdmlydHVhbGl6YXRpb24uIE1heSBJIGtub3cgZG8g
SQ0KPiA+IG1pc3Mgb3RoZXIgYmVuZWZpdCB5b3Ugc2F3Pw0KPiANCj4gQXMgSSBzZWUgaXQsIHRo
ZSBhZHZhbnRhZ2VzIG9mIGEgUFYgZGVzaWduIGZvciBwS1ZNIGFyZToNCj4gDQo+IC0gcGVyZm9y
bWFuY2UNCj4gLSBtZW1vcnkgY29zdA0KPiAtIGNvZGUgc2ltcGxpY2l0eSAob2YgdGhlIHBLVk0g
aHlwZXJ2aXNvciwgZmlyc3Qgb2YgYWxsKQ0KPiAtIGJldHRlciBhbGlnbm1lbnQgd2l0aCB0aGUg
cEtWTSBvbiBBUk0NCj4gDQo+IFJlZ2FyZGluZyBwZXJmb3JtYW5jZSwgSSBhY3R1YWxseSBzdXNw
ZWN0IGl0IG1heSBldmVuIGJlIHRoZSBsZWFzdCBzaWduaWZpY2FudCBvZg0KPiB0aGUgYWJvdmUu
IEkgZ3Vlc3Mgd2l0aCBhIFBWIGRlc2lnbiB3ZSdkIGhhdmUgcm91Z2hseSBhcyBtYW55IGV4dHJh
IHZtZXhpdHMgYXMNCj4gd2UgaGF2ZSBub3cgKGp1c3QgZHVlIHRvIGh5cGVyY2FsbHMgaW5zdGVh
ZCBvZiB0cmFwcyBvbiBlbXVsYXRlZCBWTVgNCj4gaW5zdHJ1Y3Rpb25zIGV0YyksIHNvIHBlcmhh
cHMgdGhlIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50IHdvdWxkIGJlIG5vdCBhcyBiaWcNCj4gYXMg
d2UgbWlnaHQgZXhwZWN0IChhbSBJIHdyb25nPykuDQoNCkkgdGhpbmsgd2l0aCBQViBkZXNpZ24s
IHdlIGNhbiBiZW5lZml0IGZyb20gc2tpcCBzaGFkb3dpbmcuIEZvciBleGFtcGxlLCBhIFRMQiBm
bHVzaA0KY291bGQgYmUgZG9uZSBpbiBoeXBlcnZpc29yIGRpcmVjdGx5LCB3aGlsZSBzaGFkb3dp
bmcgRVBUIG5lZWQgZW11bGF0ZSBpdCBieSBkZXN0cm95DQpzaGFkb3cgRVBUIHBhZ2UgdGFibGUg
ZW50cmllcyB0aGVuIGRvIG5leHQgc2hhZG93aW5nIHVwb24gZXB0IHZpb2xhdGlvbi4NCg0KQmFz
ZWQgb24gUFYsIHdpdGggd2VsbC1kZXNpZ25lZCBpbnRlcmZhY2VzLCBJIHN1cHBvc2Ugd2UgY2Fu
IGFsc28gbWFrZSBzb21lIGdlbmVyYWwNCmRlc2lnbiBmb3IgbmVzdGVkIHN1cHBvcnQgb24gS1ZN
LW9uLWh5cGVydmlzb3IgKGUuZy4sIHdlIGNhbiBkbyBmaXJzdCBmb3IgS1ZNLW9uLUtWTQ0KdGhl
biBleHRlbmQgdG8gc3VwcG9ydCBLVk0tb24tcEtWTSBhbmQgb3RoZXJzKQ0KDQo+IA0KPiBCdXQg
dGhlIG1lbW9yeSBjb3N0IGFkdmFudGFnZSBzZWVtcyB0byBiZSB2ZXJ5IGF0dHJhY3RpdmUuIFdp
dGggdGhlIGVtdWxhdGVkDQo+IGRlc2lnbiBwS1ZNIG5lZWRzIHRvIG1haW50YWluIHNoYWRvdyBw
YWdlIHRhYmxlcyAoYW5kIG90aGVyIHNoYWRvdw0KPiBzdHJ1Y3R1cmVzIHRvbywgYnV0IHBhZ2Ug
dGFibGVzIGFyZSB0aGUgbW9zdCBtZW1vcnkgZGVtYW5kaW5nKS4gTW9yZW92ZXIsDQo+IHRoZSBu
dW1iZXIgb2Ygc2hhZG93IHBhZ2UgdGFibGVzIGlzIG9idmlvdXNseSBwcm9wb3J0aW9uYWwgdG8g
dGhlIG51bWJlciBvZg0KPiBWTXMgcnVubmluZywgYW5kIHNpbmNlIHBLVk0gcmVzZXJ2ZXMgYWxs
IGl0cyBtZW1vcnkgdXBmcm9udCBwcmVwYXJpbmcgZm9yIHRoZQ0KPiB3b3JzdCBjYXNlLCB3ZSBo
YXZlIHByZXR0eSByZXN0cmljdGl2ZSBsaW1pdHMgb24gdGhlIG1heGltdW0gbnVtYmVyIG9mIFZN
cyBbKl0NCj4gKGFuZCBpZiB3ZSBydW4gZmV3ZXIgVk1zIHRoYW4gdGhpcyBsaW1pdCwgd2Ugd2Fz
dGUgbWVtb3J5KS4NCj4gDQo+IFRvIGdpdmUgc29tZSBudW1iZXJzLCBvbiBhIG1hY2hpbmUgd2l0
aCA4R0Igb2YgUkFNLCBvbiBDaHJvbWVPUyB3aXRoIHRoaXMNCj4gcEtWTS1vbi14ODYgUG9DIGN1
cnJlbnRseSB3ZSBoYXZlIHBLVk0gbWVtb3J5IGNvc3Qgb2YgMjI5TUIgKGFuZCBpdCBvbmx5DQo+
IGFsbG93cyB1cCB0byAxMCBWTXMgcnVubmluZyBzaW11bHRhbmVvdXNseSksIHdoaWxlIG9uIEFu
ZHJvaWQgKEFSTSkgaXQgaXMgYWZhaWsNCj4gb25seSA0NE1CLiBBY2NvcmRpbmcgdG8gbXkgYW5h
bHlzaXMsIGlmIHdlIGdldCByaWQgb2YgYWxsIHRoZSBzaGFkb3cgdGFibGVzIGluDQo+IHBLVk0s
IHdlIHNob3VsZCBoYXZlIDQ0TUIgb24geDg2IHRvbyAocmVnYXJkbGVzcyBvZiB0aGUgbWF4aW11
bSBudW1iZXIgb2YNCj4gVk1zKS4NCj4gDQo+IFsqXSBBbmQgc29tZSBvdGhlciBsaW1pdHMgdG9v
LCBlLmcuIG9uIHRoZSBtYXhpbXVtIG51bWJlciBvZiBETUEtY2FwYWJsZQ0KPiBkZXZpY2VzLCBz
aW5jZSBwS1ZNIGFsc28gbmVlZHMgc2hhZG93IElPTU1VIHBhZ2UgdGFibGVzIGlmIHdlIGhhdmUg
b25seSAxLQ0KPiBzdGFnZSBJT01NVS4NCg0KSSBtYXkgbm90IGNhcHR1cmUgeW91ciBtZWFuaW5n
LiBEbyB5b3UgbWVhbiBkZXZpY2Ugd2FudCAyLXN0YWdlIHdoaWxlIHdlIG9ubHkNCmhhdmUgMS1z
dGFnZSBJT01NVT8gSWYgc28sIG5vdCBzdXJlIGlmIHRoZXJlIGlzIHJlYWwgdXNlIGNhc2UuDQoN
ClBlciBteSB1bmRlcnN0YW5kaW5nLCBpZiBmb3IgUFYgSU9NTVUsIHRoZSBzaW1wbGVzdCBpbXBs
ZW1lbnRhdGlvbiBpcyBqdXN0DQptYWludGFpbiAxLXN0YWdlIERNQSBtYXBwaW5nIGluIHRoZSBo
eXBlcnZpc29yIGFzIGd1ZXN0IG1vc3QgbGlrZWx5IGp1c3Qgd2FudCANCjEtc3RhZ2UgRE1BIG1h
cHBpbmcgZm9yIGl0cyBkZXZpY2UsICBzbyBpZiBmb3IgSU9NTVUgdy8gbmVzdGVkIGNhcGFiaWxp
dHkgbWVhbnRpbWUNCmd1ZXN0IHdhbnQgdXNlIGl0cyBuZXN0ZWQgY2FwYWJpbGl0eSAoZS5nLiwg
Zm9yIHZTVkEpLCB3ZSBjYW4gZnVydGhlciBleHRlbmQgdGhlIFBWDQpJT01NVSBpbnRlcmZhY2Vz
Lg0KDQo+IA0KPiA+DQo+ID4+DQo+ID4+IFsqXSBZb3UgdGFrZSB0aGUgYmx1ZSBwaWxsLCB0aGUg
c3RvcnkgZW5kcywgeW91IHdha2UgdXAgaW4geW91ciBiZWQgYW5kIGJlbGlldmUNCj4gPj4gICAg
IHdoYXRldmVyIHlvdSB3YW50IHRvIGJlbGlldmUuIFlvdSB0YWtlIHRoZSByZWQgcGlsbCwgeW91
IHN0YXkgaW4gd29uZGVybGFuZCwNCj4gPj4gICAgIGFuZCBJIHNob3cgeW91IGhvdyBkZWVwIHRo
ZSByYWJiaXQgaG9sZSBnb2VzLg0KPiA+Pg0KPiA+PiAgICAgLU1vcnBoZXVzDQo+ID4NCg==
