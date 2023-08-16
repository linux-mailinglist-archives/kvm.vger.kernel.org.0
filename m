Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3479777D887
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 04:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241340AbjHPCqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 22:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241326AbjHPCpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 22:45:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675981FD7;
        Tue, 15 Aug 2023 19:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692153942; x=1723689942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZuKYqvjtqoYpGf/bsr0MqIw0sJZBDS36FSBkGWrc/ZU=;
  b=DXmxR1Ckv/q+SqWd+oPiyTHbvQp5WARAtV/ToBGZoBiyicnMEHnA+OsZ
   YfCt1iK2yEY7gCJHB3/nb74i8byEpjnpVx7S4S16ginJDrMExUG7ZhSYK
   CHmiAO2DRe+wXBsKUIXfTvYcDGnURMX1F0kdyzMdYGzEIVfN8892C/V2c
   IldwuRfEpgSUdIg+IY7fHE1DCUMS6KD/l71GLQs6RQ1CWs7c+tct/B1A1
   gtQ1LjPI4rPehWHDTAj5+340F3YkBGcwvP9JCymMBMKgWJA1/WeBWFJgQ
   wfg8YS0OYcq1+vcUk+is1LlWAwWUEmBzWKnyRRo7OHt5Vx7ngg49Y879L
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="438770134"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="438770134"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 19:45:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="683875885"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="683875885"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 15 Aug 2023 19:45:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 19:45:41 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 19:45:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 15 Aug 2023 19:45:41 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 15 Aug 2023 19:45:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP0IH2uKC4SiuxlfGYiSj1FYX//LLk3htECCY3W9mGo9Njep/XZk98f6XQbBpdbZyV0N/RcbvemSSt9hf5osy1MeUM7my7GKEaBmFerQKOn3I2d8eH46xcWkhjMgA7nz72e/Gkgny3wlzm1R0kzQJIuBFxdSvAmosWS9KLWRlPON6xXo+cGxB3vNfHr80A8vBsw8GGtNXyZdg6ETp8vcLmyMdMY5nr8O9Usop0CarJixKy20mYJnLfuiTFqGSeXnnyiOv2ywFpEUlfwmyyHZcejxlzbVo3m/MNqLfJZu3w2wT3ynMGIGDYY8HAYkH70yYyWWTpheZrB107l7SdAbSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuKYqvjtqoYpGf/bsr0MqIw0sJZBDS36FSBkGWrc/ZU=;
 b=fOmVzgg2O9r9IfZ2PNXMVBySeCzBDqKB6TNnCokyVWccQ/sK3UF7kT9rU72cMQ/xLIxR7vUtiY3oT2n5IXTCRIkU/FfSM7/lV1P6vbtSQO9kiNx8ppak1+lfgT1EE10vYd/Rizx7dG4BZ+YRwO7NelFp4JEiQIOn8rq7VaJZnQYRz8fQXKW0/UMikptdYVgHvs9ePODuftChYweA7YYzW0oP+FOuJw0msDNfww2nu9YWQZWE2dekgPhfKrFH9gJ9S22ibG7NvaQSRnpTsgjbEg9PUR9Tg/VbOLiT5DIRarPQAiCjM/R90IKMn/vcpgEP46LQ9JT4bmByidNL21rEEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SA2PR11MB4810.namprd11.prod.outlook.com (2603:10b6:806:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 02:45:39 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::1969:941b:6bab:8efa]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::1969:941b:6bab:8efa%7]) with mapi id 15.20.6678.025; Wed, 16 Aug 2023
 02:45:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yao, Yuan" <yuan.yao@intel.com>
Subject: Re: [PATCH v3 07/15] KVM: nVMX: Use KVM-governed feature framework to
 track "nested VMX enabled"
Thread-Topic: [PATCH v3 07/15] KVM: nVMX: Use KVM-governed feature framework
 to track "nested VMX enabled"
Thread-Index: AQHZz7iJgcXsbUyDlUCdfwdXBJPogq/sOAYA
Date:   Wed, 16 Aug 2023 02:45:38 +0000
Message-ID: <55bfeecb59787369d57c2704785af13604e63a62.camel@intel.com>
References: <20230815203653.519297-1-seanjc@google.com>
         <20230815203653.519297-8-seanjc@google.com>
In-Reply-To: <20230815203653.519297-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|SA2PR11MB4810:EE_
x-ms-office365-filtering-correlation-id: 4e4dbaf9-9e4a-4d15-eaf6-08db9e02e01c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GO6Mu9c43fMcz9y2A3xgJBeI+ZNFrLXVVhmXnYifFHmOFdbzKyJvANVAoulzpZQscnHc5Y7LCG923gSHGEbWSU3zaY/zMXoP1Apo/y/RZYIen8ELDGjXaa/tpoAWI+FsfbQ+gwrwfe/5FtiojuQCaiVJ9VYO+ShOjfQR6NglcaY9w9p0tFSR03YMHsKtRPEGSFo+rsD7AL/FBC1SHyNG5c+xeXqg4oztXuD+LJSI/NO2fGnim7Jt4WFrnT6yqwOZMcO6Yqr1neWdD1/vD3Exei0WCjp7yBWgNquS+cZww14RoGfdSpsMBQUCanxsLscmjxUYekQGoUXQQAMjYBTwmB/AeYMZvLDDF+U4lIcu6BvcdiecepOQP6fCnZNfmz5wREHBSPXhyfrDrYztyC0cI5q/xM6i6Wl82MtRHuseSpumE+ZJQwekN4DpzGcQVv7FgUow7eEsJyyrnVhIjHjjHgNc78WwwdESJGJp6ur6SBOWiuOiLKNeVcnHg3eDjBdGyBQnrjHpnv7WsRW3c0oXIgArrk8vPGG36IqKb+45TrDBorr22QSAqMG4dpSFXCI2rRfsvI8QJhlaf3q6JRYzBQJm+hgAdXK3rYbcjXqZdkA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(346002)(136003)(1800799009)(451199024)(186009)(71200400001)(64756008)(54906003)(66446008)(76116006)(66476007)(66556008)(66946007)(6512007)(6486002)(6506007)(2906002)(478600001)(26005)(110136005)(91956017)(107886003)(5660300002)(2616005)(83380400001)(41300700001)(316002)(8936002)(4326008)(8676002)(122000001)(38100700002)(38070700005)(82960400001)(36756003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzNuL2ZWY0JEN3AwSFh4anBPY2gyUDhyTFJMYWhuUVZPeExod2tVSE9Wdisz?=
 =?utf-8?B?MjY0cXlmSUNvaXNMVk1ISmwrbEc0M2dHb1BMbktBSGZOYjRNeWdPOU1EZTdp?=
 =?utf-8?B?Y3owQklnVit2K1RrTWdTY3NGZEtsM1dBT3VCL2lIbFg3YWNZc2lrKzQ3ZjFN?=
 =?utf-8?B?ZlFaekxySktTdVBTT0tFcnpyVFVBVXJGWEp0L1pKNWxpeTF1ZG5qMTJnMndu?=
 =?utf-8?B?T2U4T3VaWHVOVTQxSEp4YkNpNU9ZMmJZTWM5aFlUT2o0S2RIQjJiYmViTWIv?=
 =?utf-8?B?QVJkSW9xdCswODFhMkdEZzQ5N3I1SUswUHI3ZitLc0g1NFRmWW1ZYkp5ak91?=
 =?utf-8?B?RlhINkc3cDhKN3VKT2l6TWJnc1hPRk4yNkM3YkdkMnVBMWpvS3JmSThibUY3?=
 =?utf-8?B?S0xDdU93RWR0QVpNM1EyYmFxTm52dytCS1JqRDNUeU5jczIyTzdHeDRzUmUr?=
 =?utf-8?B?SjJGc1hNT3JCdEY3L0piYm1oY3ljUUg1aXU5aUhGbmlJWE56TWJKTlh4U05M?=
 =?utf-8?B?UkxLbm5IQU5vcEdlUTBHcE92cVNPb3hxM2kzRzJGTW5zUmJTUmM3Y2kxQUo3?=
 =?utf-8?B?S3hPakE3NXNudk5PMitCV2hsRVoxU2o2T3lZTG9HQzdqT0NmVGtwL1hoM0gy?=
 =?utf-8?B?dzRZOTZzWlBGYldSUVFnUDRzWGtTWnB2Q1hKdHhYaDVCY3hpSEZEWmxPQm9C?=
 =?utf-8?B?NkNqT1JkTlR2REx0T0dvVWVGVlhSVERBNTlLZFNyS2g2OXpQalZJRGh5ZGZK?=
 =?utf-8?B?cHBhQ1R5d0c0L3liYzJ4eENsTU5NMERFSWtUZHlucnhPeWFMZ29sUUlqdk1G?=
 =?utf-8?B?aEF0cXZVMWlweW9TMzVIV3lyQ1g0YjFyMXI1bXZxVW9EeWhtaDdxV3IwSnBN?=
 =?utf-8?B?SGcxbnhFZTJ0M25YQzR6T3RWeUljMEI4TEwxS3RiRWwvcURFYjZqZzZtZnZ2?=
 =?utf-8?B?UzB0K1VXbTZDSlJ2YVp1and5azZTNVV6RVdkdTdQYVRjNWVMYUFIdEZvZVZu?=
 =?utf-8?B?VWdRcHJVTlVxb08rdkpmZkE5NGdQZGpybXZGV25lYnFDTHh5aXZNOWw3UDY1?=
 =?utf-8?B?NEt2d2hYWWFIelhJb0tNR2dIaytSeTVxbkNRREMzME9oeWVPOEdIVjZ3S2V5?=
 =?utf-8?B?b1VDWkdtQ3NhQ1RBM1pGWDlCM25aeEZlU3dEU1pneW93cTR0U2cwcDBKSndE?=
 =?utf-8?B?OXNYNnNxZEx2WkU4MGlnRHRFcEpEbG8zb3dlS0VUU0kzU3NqWGpzbm9reEhD?=
 =?utf-8?B?UHh2WC9GVmdPd1lSVUNJc0VkODZzMEhDTFZ5dWdwMUl0SVBaTHY2bFFBV0dy?=
 =?utf-8?B?RnVCV3NZT2pWUHA5UVZpV2VtOGg5WUtTSVRTYnEweWl5VGhIS1JPTkJNODJH?=
 =?utf-8?B?OHd5eHVxZVJjQTdMdmFRNE5GK1pjWmhhQTVNbTBpWUpHWURLTTB1czBWZ2sv?=
 =?utf-8?B?MzJXVGlTaUZVTlBzZU0vdnBjRXJ4ZWh6R2JPZWNjWjVYZU5KMEVJdXRXR3Br?=
 =?utf-8?B?V01lL2RyNEJNdk5SaTVQTy91OUtOQUp0MnNZTGZjMkFRdWpranBrYTd3RHJR?=
 =?utf-8?B?VVBLaUVrYkd3dkJFUWhWN29hZkYvNDFLTWx5YkZIQWV6amdVNEZhQTFVankv?=
 =?utf-8?B?WW91Y1hJVVZsakVqcUlWVDNkeXFQdVdHR1BoaDM1Wm15dmVLdTZvNTBrT1g1?=
 =?utf-8?B?RDhnS3FzNHpjMHVZVk43L3AxUjVJbHRDaGJKUzQyQkQyUXZpOHJGSnI1RUZn?=
 =?utf-8?B?YkdFV283OWVHaC95OTdkeVAzUDliV1hsNWFFakc1ajkxV2FLSUpBK3ZUaitv?=
 =?utf-8?B?S1EzdmZhTzJNQnhWV0d1TTZuQnFtZ0lhcHhLS1VEeVYxMjBqbWZvUStDMG1V?=
 =?utf-8?B?VXRHUFR3RHB0a0Fyalgya1lXRitkNDFlRzYzM0VqclJrRFZIaXp3SnVGU1RE?=
 =?utf-8?B?dFNjWnJPeGYrYk1kc01QSG1pTVVJd0piN2xWQXRiT1NlQ2xnMGUwaGVjSis3?=
 =?utf-8?B?ODE5Y1J3dkNzczRLZXBWRCtnZDNkNUQvcW9rVFVOVFhranNnUTVLem1LdkNp?=
 =?utf-8?B?SENKdzBkVENRT1ltUC8rK1Z2MjJqSHVCMUl6eDZCTk5jU24zTm1tTWRMT1J4?=
 =?utf-8?Q?gey/dQQSi2Nn9Vd35QpDsgYc4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <746E64610CCECC459B3EAF1FD71DBB6F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4dbaf9-9e4a-4d15-eaf6-08db9e02e01c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 02:45:38.9995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mWNrPebw2jeG8+VNljwGoOL5hpaCs6PA+/lpdLBBdOWpWgWcURyONg+G2QIUQP4YcFtHSJJ27tDktRuAM3k9PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4810
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA4LTE1IGF0IDEzOjM2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUcmFjayAiVk1YIGV4cG9zZWQgdG8gTDEiIHZpYSBhIGdvdmVybmVkIGZlYXR1cmUg
ZmxhZyBpbnN0ZWFkIG9mIHVzaW5nIGENCj4gZGVkaWNhdGVkIGhlbHBlciB0byBwcm92aWRlIHRo
ZSBzYW1lIGZ1bmN0aW9uYWxpdHkuICBUaGUgbWFpbiBnb2FsIGlzIHRvDQo+IGRyaXZlIGNvbnZl
cmdlbmNlIGJldHdlZW4gVk1YIGFuZCBTVk0gd2l0aCByZXNwZWN0IHRvIHF1ZXJ5aW5nIGZlYXR1
cmVzDQo+IHRoYXQgYXJlIGNvbnRyb2xsYWJsZSB2aWEgbW9kdWxlIHBhcmFtIChTVk0gbGlrZXMg
dG8gY2FjaGUgbmVzdGVkDQo+IGZlYXR1cmVzKSwgYXZvaWRpbmcgdGhlIGd1ZXN0IENQVUlEIGxv
b2t1cHMgYXQgcnVudGltZSBpcyBqdXN0IGEgYm9udXMNCj4gYW5kIHVubGlrZWx5IHRvIHByb3Zp
ZGUgYW55IG1lYW5pbmdmdWwgcGVyZm9ybWFuY2UgYmVuZWZpdHMuDQo+IA0KPiBObyBmdW5jdGlv
bmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IA0KWy4uLl0NCg0KPiAgDQo+IC0vKg0KPiAtICog
bmVzdGVkX3ZteF9hbGxvd2VkKCkgY2hlY2tzIHdoZXRoZXIgYSBndWVzdCBzaG91bGQgYmUgYWxs
b3dlZCB0byB1c2UgVk1YDQo+IC0gKiBpbnN0cnVjdGlvbnMgYW5kIE1TUnMgKGkuZS4sIG5lc3Rl
ZCBWTVgpLiBOZXN0ZWQgVk1YIGlzIGRpc2FibGVkIGZvcg0KPiAtICogYWxsIGd1ZXN0cyBpZiB0
aGUgIm5lc3RlZCIgbW9kdWxlIG9wdGlvbiBpcyBvZmYsIGFuZCBjYW4gYWxzbyBiZSBkaXNhYmxl
ZA0KPiAtICogZm9yIGEgc2luZ2xlIGd1ZXN0IGJ5IGRpc2FibGluZyBpdHMgVk1YIGNwdWlkIGJp
dC4NCj4gLSAqLw0KPiAtYm9vbCBuZXN0ZWRfdm14X2FsbG93ZWQoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1KQ0KPiAtew0KPiAtCXJldHVybiBuZXN0ZWQgJiYgZ3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4
Nl9GRUFUVVJFX1ZNWCk7DQo+IC19DQo+IC0NCj4gDQoNClsuLi5dDQoNCj4gQEAgLTc3NTAsMTMg
Kzc3MzksMTUgQEAgc3RhdGljIHZvaWQgdm14X3ZjcHVfYWZ0ZXJfc2V0X2NwdWlkKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCj4gIAkgICAgZ3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4Nl9GRUFUVVJF
X1hTQVZFKSkNCj4gIAkJa3ZtX2dvdmVybmVkX2ZlYXR1cmVfY2hlY2tfYW5kX3NldCh2Y3B1LCBY
ODZfRkVBVFVSRV9YU0FWRVMpOw0KPiAgDQo+ICsJa3ZtX2dvdmVybmVkX2ZlYXR1cmVfY2hlY2tf
YW5kX3NldCh2Y3B1LCBYODZfRkVBVFVSRV9WTVgpOw0KPiArDQo+IA0KDQpOaXQ6DQoNCm5lc3Rl
ZF92bXhfYWxsb3dlZCgpIGFsc28gY2hlY2tzICduZXN0ZWQnIGdsb2JhbCB2YXJpYWJsZS4gIEhv
d2V2ZXINCmt2bV9nb3Zlcm5lZF9mZWF0dXJlX2NoZWNrX2FuZF9zZXQoKSBpcyBjYWxsZWQgdW5j
b25kaXRpb25hbGx5LiAgQWx0aG91Z2ggSUlVQw0KaXQgc2hvdWxkIG5ldmVyIGFjdHVhbGx5IHNl
dCB0aGUgVk1YIGdvdmVybmVkIGJpdCB3aGVuICduZXN0ZWQ9MCcsIGl0J3Mgbm90IHRoYXQNCm9i
dmlvdXMgaW4gX3RoaXNfIHBhdGNoLg0KDQpTaG91bGQgd2UgZXhwbGljaXRseSBjYWxsIHRoaXMg
b3V0IGluIHRoZSBjaGFuZ2Vsb2cgc28gZ2l0IGJsYW1lcnMgY2FuDQp1bmRlcnN0YW5kIHRoaXMg
bW9yZSBlYXNpbHkgaW4gdGhlIGZ1dHVyZT8NCg==
