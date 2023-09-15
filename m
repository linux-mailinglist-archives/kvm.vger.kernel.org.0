Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3E7A1223
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 02:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjIOAGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 20:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjIOAGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 20:06:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139532100;
        Thu, 14 Sep 2023 17:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694736367; x=1726272367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YFwPjN2EdJfkJ1HunxAiUva79Yq9OcJfrXsgkndESLg=;
  b=EdHR14g7gbbDSdjWyZveuDavVuKjpac8waX7HTHiVbChDrsTqla9Cek2
   AftN73deTjfTDc17R7lww/iE8aSv9tzLJDpdiPml0A8IkuNWN4mD9lkIL
   BmKT5Q9m1KbYB4eWythVZg8cQyD3gv8W68NxCakU9TB5mzWcM6U1Rrdh6
   30NgEJvU+Suys0a9RgciSp5h154gg9KGXpfaGMDWwZwKGxCLYZZlp5OYJ
   A0aaiFfNqPL3WFpEHtJcU1U1cq5+QyCtDBT2FVl8OD0IHdApnO3hA2FwC
   Dr9+jZLxOLLeh5F2keq51LsJDSCfc2jw84Dg3u1lv+1aqEGoP5GADNWFJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="378030564"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="378030564"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 17:06:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="747990932"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="747990932"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 17:06:05 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 17:06:04 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 17:06:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 17:06:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 17:06:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAu3NYHfA42TpBuLCY1GhFO5vkVxJyBSd5Jsz9m0VJ9IRjE/1tR77hmJALhK7SXmLZh2SIkGjrCESFRW5AzuPu4oU4+/EdYddJkUmjGZR5VPK9qC+JzDJDIguiWWvgOutldT+AJJPVoQ3lJli8ZR7W316/c6Ifi4Vjg0iO8RQ2TJ0ua6InkcLYFGms3whdYZOLRpbhFcdAGpu6aH5qYr2v4xVTE6H5otpN90l0mjJCw69myT1u18FONeYMsiESdrx7+ayZTKsiTgOipdHqx4YCSW6PFALtZCL+V80hIWZOPHW69dta5dtoxROL62B780i5kSd+VUanK+Ltp35ppR6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFwPjN2EdJfkJ1HunxAiUva79Yq9OcJfrXsgkndESLg=;
 b=G62mHUT6432Dmhw3kGykXr299N9TOSHhz5UFUCl+HxDBY9kC5XT0JborzgosICiRgtat3tPmjnLdrY4lqDC1iE7TU2FUiVKV7S1t+pUv24EMxGtM8fNdqu7oeoIwlSUvEh/fFd0U7T5+QRnlQ4KHJAA/y1trxoM9kuJw40nF6b3sqwPhB1+MGcZfYSXiNDzTrRxOjxCBiDakk+jLWnsEfaGvaoc29aouMRujzf00cdLqnWLaIhMYfnSOTNn9HVKMWEb2tq7OINeGUNTxwwEGCvTjjH02rfNWUNh3eegP3Ly1nyvDlNupC/MGRzseciPJ7cj/j+E1XeO8hTGIUuVi5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5396.namprd11.prod.outlook.com (2603:10b6:610:bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 15 Sep
 2023 00:06:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 00:06:03 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
Subject: Re: [PATCH v6 03/25] x86/fpu/xstate: Add CET supervisor mode state
 support
Thread-Topic: [PATCH v6 03/25] x86/fpu/xstate: Add CET supervisor mode state
 support
Thread-Index: AQHZ5u87aMWC+8H5o0iuwBeQPFOztbAbAvQA
Date:   Fri, 15 Sep 2023 00:06:02 +0000
Message-ID: <35393ed30962125fd6ce1f91f71595d1111413ec.camel@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
         <20230914063325.85503-4-weijiang.yang@intel.com>
In-Reply-To: <20230914063325.85503-4-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5396:EE_
x-ms-office365-filtering-correlation-id: f9f09253-5f7b-4565-0ba7-08dbb57f8cc3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nJYuzc6omqgJsGKklwmPN/K8Gexl8hN5lpaF9khJItJiw+GxOA7nwBAg+6gp4wjw4YpiFVpeV97NQfgKOivYQP/n/L9Sbi90tsO8l7k1XqNWjLzsOc6Tbi9LZfSxLsYAIpMqNf7/fn4Jp7M1erE/ABxvL4faYtGLHZfsnlgrAg4/xffns3/AwQveFZlfN5ytR97y1ula9+Y35A4TVeR0aB0cXCeOEx6GnxNTDmDDS79mXuWMjdtTLJ4x71zK7/dmIVp4Fs/f2RE283YNeSd2868X9VlsuGYsdtNxqKOShNKbii7cmyfKEIYUfu8X1pb10xMVPEBBnRaBmpUz+Z76kOZpvsdVGKaePwhzCUDvl+CD/ZUD1OMVhXKoLRb2B2LN/WhynBg7H0kC/1t5rGFBHfYNolhBWeaCY6+2/SGOtPWWv6mmE3Pf1lfKOUIID5RnTfnJI5k4j8usj2ZxzaM2Wn1IS6t/ZorOOq3jjhltaJk6UacNwLmoOfoucUO/ELSmnEkK01AjbTAYHlAhB9onHe2WJUqgDxkjt+z8tsgkcYsviwNcTEZzM4V3sjPEXP/CLKOPU6tKp1bEWTzVDYmKaKjBK4DHhh/mJ0TS68D9kzI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(136003)(396003)(1800799009)(451199024)(186009)(110136005)(66446008)(91956017)(54906003)(64756008)(71200400001)(66946007)(76116006)(66476007)(66556008)(6506007)(6486002)(41300700001)(6512007)(316002)(966005)(478600001)(2616005)(4326008)(8676002)(8936002)(5660300002)(26005)(36756003)(38100700002)(38070700005)(82960400001)(122000001)(2906002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGIrdmJEemVXNGxsczA2TnRHLzdrSHVVL3hxN25jZ2pnNVYrVHdYOEtPT3Nt?=
 =?utf-8?B?aUY4dmtFbkV3ZDVscC9tVmZBV1RlTWk5akNRZ0RSSE9sZ2JkL1l1dFBKZ0FR?=
 =?utf-8?B?d2NDUCtOSjE2R1BteEUyeEpVeWJqTDNZbGRXMXdnSlpoWG5uSnlZblBncTJy?=
 =?utf-8?B?WjA0M2U4UXFmd0x6RThqcXpjSWZ5SlNqUjRCQzRXT0h2SEJSSHR0aTBTYnIv?=
 =?utf-8?B?RWxicVdGTWo1eE9UQkRNaUFLOXFPcmM4OGhkY0FpVUZuN01jek9PVzd2UnNi?=
 =?utf-8?B?OFFYM2F1MlpZVC9HdnlWbkRibW1LUzdBb3o0WTlWWEhZSjd4Yjh6bXFPUWU1?=
 =?utf-8?B?M1IweGUyM2NFS3VuZithZklSV1cvY1F4cFI3NWhza1NXbzJ4YnE3Sm84aTI3?=
 =?utf-8?B?K2F4YmNMRXJYcXVKYmhPZ01sUE5BSkdscG5GUVVHRW5WV1VFWVIvMUh5NHRI?=
 =?utf-8?B?cyt1UGJuZHBiV2NLSWhxTk1VdFc5UUh4Y2dWN0M0Z3RWaG9BMnVDNXg5d1Fm?=
 =?utf-8?B?a0FYNHlkajVMUUxXM1VmUnZJb0E4QnAyMGlVZXlIZ3hKOEVjYmVQZlJBMEIr?=
 =?utf-8?B?bU9nOTBwSnMvenNIdUpSWWVhUGJVVmtteWFHV3J1dmtlSytSVG9RK1hZcXdZ?=
 =?utf-8?B?L21oTVQrR3hwOFFDeTkzMEtyN0xlOHQ0Vytqc3puazdmbmY3d21xajZmejE5?=
 =?utf-8?B?cS9nVHB5Myt4MEVXVWs5WHk5cWpEVm1QUy9uYWpVRDV2OFgwTVZRdjEwUFhS?=
 =?utf-8?B?dVM3c2JocXJUYWtwRGNES1daVkhyVm0zbUxLNGI5TlZDK2pTTHRTSmdlRmVy?=
 =?utf-8?B?TW5xbFZpbmplb3MvbnlIeUxRZnNzd3JsWXdITkNldDM5ZWxrL1Uxd0VCekUz?=
 =?utf-8?B?eXppSXVFWnZyRGV1N1h6djVTZk4vSWZwQ3JnQ2pOc2hpQjM3dEV5RTVZdGNG?=
 =?utf-8?B?a2NQblRDYTJPRTFoWUR0UnVSdmlrc0pPSnVEWlBxaG5taFJDNU03cGtGaCtE?=
 =?utf-8?B?aU4zVWFQa0ZGSFhUeTl6YWlWSk1OSTh6NjFSQ1R5N1h5a0s2ei9oellHLzI1?=
 =?utf-8?B?M1Z6R0NRSERLTnFIV0Z3VXlzMTdkSGhwNW9TcnYzR0Q5T29XZm9YaFdlV2Qv?=
 =?utf-8?B?UmlFQmhLT1dDdjNZMERWams1WCtpempYZ2l6VmhrdEQyRG5Ic00ybCtqWFZy?=
 =?utf-8?B?RlRIeWZQbUZaVmFnNmZTQzUyRHVPeUE1aWk3UzJZTDhQZ0NTcW1oSGFxSE9Z?=
 =?utf-8?B?VHVaTlZuRE1HK2JkSXU3UlUvOFdvVis5cFBjaGZrczJmbnBoZ0pUemlEbEd5?=
 =?utf-8?B?TGpSR1FqSkNLSXAraTV1ck82dnMyT2ZadDBqV2tYOFBrV2l4V011Tnc5UTc4?=
 =?utf-8?B?b2xPMWRzcXhPeDBPakxRSElZZkZBUlZIdjJGd3d5cnR5NnI1dHZoUEF4cXJP?=
 =?utf-8?B?b2UvWGtDS0t6S2hRTC95cHZCTWxCWmxGeStFN0FQeCtBWENFUHV6dHB1N1Jp?=
 =?utf-8?B?RkpwejNTdWQyWHBQV3BaaWdGRjR2MVpPampybVZBdlVnNTRFZGZId2FBRWU4?=
 =?utf-8?B?bTFjMmUwR1lJaWdiTWlyT2YxdXRhZWVFQW9NSGJmZG9jQXg1TDFYQ0w4RjZE?=
 =?utf-8?B?WGFzV0RHWUJVdTd6UW9zS1lHT2RzWWZ3ckxwaSsxc2ljd0IydTdKdVhwRWdj?=
 =?utf-8?B?Z2VQeU5taHpDdlNiN0VwdlJOREh6cnY0Y3hyRmthSTBxN1gvQWxweWNiYjhp?=
 =?utf-8?B?cE9lck1xQWcvMWhOQnZmWlZneWdSdW16aEFVcHdWdTJIMDZWSXpiNE41cWVp?=
 =?utf-8?B?U2kxRXVhRVE4R1VieXdabS9YQmlPejBIVUZsRXQyUmN4ZGdKZDFJenFocVRi?=
 =?utf-8?B?czRxRHB4cldzQk5CWVJRL2lrckVXWFVRcThORllXcGp5N0VlNnc1eTE4R1FD?=
 =?utf-8?B?Z09BaFJSOGh4ZkZWSFNNZTFiOGVLUmlpVm40ajArZGc2VmxSMytiTitSNU1q?=
 =?utf-8?B?U2xuWks2UFZ1UEs5d3RvRm5vQVRvYzBneUduL0p4L3dvTm5TTDVpeGRhSGx5?=
 =?utf-8?B?WkF3VmtlVjNtdGRNOXJxUUVoOHAzZTJ2UTlGVDg5VmVjVjB5bnlXNnZxOGgx?=
 =?utf-8?B?Vk9CL09PTkFOQWo2OU9KaFYrMEhCbkJHN0Uvb2p3eWxPMWFBR0ttRUwzdkJu?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E108B3AB0AC084D83400A7F76A2F010@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f09253-5f7b-4565-0ba7-08dbb57f8cc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 00:06:02.9949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3pZbDy38znS8D8QjCMxLIA3kx2hCQSuvbSjYj12O00SaUOGHWfFFZiIioeR88wDS0HT5XP0A2uysUkrSF+ymMnuuO30o8Gb7jMrV2i4RIvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5396
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA5LTE0IGF0IDAyOjMzIC0wNDAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBBZGQgc3VwZXJ2aXNvciBtb2RlIHN0YXRlIHN1cHBvcnQgd2l0aGluIEZQVSB4c3RhdGUgbWFu
YWdlbWVudA0KPiBmcmFtZXdvcmsuDQo+IEFsdGhvdWdoIHN1cGVydmlzb3Igc2hhZG93IHN0YWNr
IGlzIG5vdCBlbmFibGVkL3VzZWQgdG9kYXkgaW4NCj4ga2VybmVsLEtWTQ0KICAgICAgICAgXiBO
aXQ6IG5lZWRzIGEgc3BhY2UNCj4gcmVxdWlyZXMgdGhlIHN1cHBvcnQgYmVjYXVzZSB3aGVuIEtW
TSBhZHZlcnRpc2VzIHNoYWRvdyBzdGFjayBmZWF0dXJlDQo+IHRvDQo+IGd1ZXN0LCBhcmNoaXRl
Y2h0dXJhbGx5IGl0IGNsYWltcyB0aGUgc3VwcG9ydCBmb3IgYm90aCB1c2VyIGFuZA0KICAgICAg
ICAgXiBTcGVsbGluZzogImFyY2hpdGVjdHVyYWxseSINCj4gc3VwZXJ2aXNvcg0KPiBtb2RlcyBm
b3IgTGludXggYW5kIG5vbi1MaW51eCBndWVzdCBPU2VzLg0KPiANCj4gV2l0aCB0aGUgeHN0YXRl
IHN1cHBvcnQsIGd1ZXN0IHN1cGVydmlzb3IgbW9kZSBzaGFkb3cgc3RhY2sgc3RhdGUgY2FuDQo+
IGJlDQo+IHByb3Blcmx5IHNhdmVkL3Jlc3RvcmVkIHdoZW4gMSkgZ3Vlc3QvaG9zdCBGUFUgY29u
dGV4dCBpcyBzd2FwcGVkwqANCj4gMikgdkNQVQ0KPiB0aHJlYWQgaXMgc2NoZWQgb3V0L2luLg0K
KDIpIGlzIGEgbGl0dGxlIGJpdCBjb25mdXNpbmcsIGJlY2F1c2UgdGhlIGxhenkgRlBVIHN0dWZm
IHdvbid0IGFsd2F5cw0Kc2F2ZS9yZXN0b3JlIHdoaWxlIHNjaGVkdWxpbmcuIEJ1dCB0cnlpbmcg
dG8gZXhwbGFpbiB0aGUgZGV0YWlscyBpbg0KdGhpcyBjb21taXQgbG9nIGlzIHByb2JhYmx5IHVu
bmVjZXNzYXJ5LiBNYXliZSBzb21ldGhpbmcgbGlrZT8NCg0KICAgMikgQXQgdGhlIHByb3BlciB0
aW1lcyB3aGlsZSBvdGhlciB0YXNrcyBhcmUgc2NoZWR1bGVkDQoNCkkgdGhpbmsgYWxzbyBhIGtl
eSBwYXJ0IG9mIHRoaXMgaXMgdGhhdCBYRkVBVFVSRV9DRVRfS0VSTkVMIGlzIG5vdA0KKmFsbCog
b2YgdGhlICJndWVzdCBzdXBlcnZpc29yIG1vZGUgc2hhZG93IHN0YWNrIHN0YXRlIiwgYXQgbGVh
c3Qgd2l0aA0KcmVzcGVjdCB0byB0aGUgTVNScy4gSXQgbWlnaHQgYmUgd29ydGggY2FsbGluZyB0
aGF0IG91dCBhIGxpdHRsZSBtb3JlDQpsb3VkbHkuDQoNCj4gDQo+IFRoZSBhbHRlcm5hdGl2ZSBp
cyB0byBlbmFibGUgaXQgaW4gS1ZNIGRvbWFpbiwgYnV0IEtWTSBtYWludGFpbmVycw0KPiBOQUtl
ZA0KPiB0aGUgc29sdXRpb24uIFRoZSBleHRlcm5hbCBkaXNjdXNzaW9uIGNhbiBiZSBmb3VuZCBh
dCBbKl0sIGl0IGVuZGVkDQo+IHVwDQo+IHdpdGggYWRkaW5nIHRoZSBzdXBwb3J0IGluIGtlcm5l
bCBpbnN0ZWFkIG9mIEtWTSBkb21haW4uDQo+IA0KPiBOb3RlLCBpbiBLVk0gY2FzZSwgZ3Vlc3Qg
Q0VUIHN1cGVydmlzb3Igc3RhdGUgaS5lLiwNCj4gSUEzMl9QTHswLDEsMn1fTVNScywNCj4gYXJl
IHByZXNlcnZlZCBhZnRlciBWTS1FeGl0IHVudGlsIGhvc3QvZ3Vlc3QgZnBzdGF0ZXMgYXJlIHN3
YXBwZWQsDQo+IGJ1dA0KPiBzaW5jZSBob3N0IHN1cGVydmlzb3Igc2hhZG93IHN0YWNrIGlzIGRp
c2FibGVkLCB0aGUgcHJlc2VydmVkIE1TUnMNCj4gd29uJ3QNCj4gaHVydCBob3N0Lg0KDQpJdCBt
aWdodCBiZWcgdGhlIHF1ZXN0aW9uIG9mIGlmIHRoaXMgc29sdXRpb24gd2lsbCBuZWVkIHRvIGJl
IHJlZG9uZSBieQ0Kc29tZSBmdXR1cmUgTGludXggc3VwZXJ2aXNvciBzaGFkb3cgc3RhY2sgZWZm
b3J0LiBJICp0aGluayogdGhlIGFuc3dlcg0KaXMgbm8uDQoNCk1vc3Qgb2YgdGhlIHhzYXZlIG1h
bmFnZWQgZmVhdHVyZXMgYXJlIHJlc3RvcmVkIGJlZm9yZSByZXR1cm5pbmcgdG8NCnVzZXJzcGFj
ZSBiZWNhdXNlIHRoZXkgd291bGQgaGF2ZSB1c2Vyc3BhY2UgZWZmZWN0LiBCdXQNClhGRUFUVVJF
X0NFVF9LRVJORUwgaXMgZGlmZmVyZW50LiBJdCBvbmx5IGVmZmVjdHMgdGhlIGtlcm5lbC4gQnV0
IHRoZQ0KSUEzMl9QTHswLDEsMn1fTVNScyBhcmUgdXNlZCB3aGVuIHRyYW5zaXRpb25pbmcgdG8g
dGhvc2UgcmluZ3MuIFNvIGZvcg0KTGludXggdGhleSB3b3VsZCBnZXQgdXNlZCB3aGVuIHRyYW5z
aXRpb25pbmcgYmFjayBmcm9tIHVzZXJzcGFjZS4gSW4NCm9yZGVyIGZvciBpdCB0byBiZSB1c2Vk
IHdoZW4gY29udHJvbCB0cmFuc2ZlcnMgYmFjayAqZnJvbSogdXNlcnNwYWNlLA0KaXQgbmVlZHMg
dG8gYmUgcmVzdG9yZWQgYmVmb3JlIHJldHVybmluZyAqdG8qIHVzZXJzcGFjZS4gU28gZGVzcGl0
ZQ0KYmVpbmcgbmVlZGVkIG9ubHkgZm9yIHRoZSBrZXJuZWwsIGFuZCBoYXZpbmcgbm8gZWZmZWN0
IG9uIHVzZXJzcGFjZSwgaXQNCm1pZ2h0IG5lZWQgdG8gYmUgc3dhcHBlZC9yZXN0b3JlZCBhdCB0
aGUgc2FtZSB0aW1lIGFzIHRoZSByZXN0IG9mIHRoZQ0KRlBVIHN0YXRlIHRoYXQgb25seSBhZmZl
Y3RzIHVzZXJzcGFjZS4NCg0KUHJvYmFibHkgc3VwZXJ2aXNvciBzaGFkb3cgc3RhY2sgZm9yIExp
bnV4IG5lZWRzIG11Y2ggbW9yZSBhbmFseXNpcywNCmJ1dCB0cnlpbmcgdG8gbGVhdmUgc29tZSBi
cmVhZGNydW1icyBvbiB0aGUgdGhpbmtpbmcgZnJvbSBpbnRlcm5hbA0KcmV2aWV3cy4gSSBkb24n
dCBrbm93IGlmIGl0IG1pZ2h0IGJlIGdvb2QgdG8gaW5jbHVkZSBzb21lIG9mIHRoaXMNCnJlYXNv
bmluZyBpbiB0aGUgY29tbWl0IGxvZy4gSXQncyBhIGJpdCBoYW5kIHdhdnkuDQoNCj4gDQo+IFsq
XToNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzgwNmUyNmMyLThkMjEtOWNjOS1hMGI3
LTc3ODdkZDIzMTcyOUBpbnRlbC5jb20vDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZYW5nIFdlaWpp
YW5nIDx3ZWlqaWFuZy55YW5nQGludGVsLmNvbT4NCg0KT3RoZXJ3aXNlLCB0aGUgY29kZSBsb29r
ZWQgZ29vZCB0byBtZS4NCg==
