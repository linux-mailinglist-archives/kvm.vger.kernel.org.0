Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9936A1FB7
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 17:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjBXQeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 11:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBXQeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 11:34:46 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D399144BD;
        Fri, 24 Feb 2023 08:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677256485; x=1708792485;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f4c18coto8+HDnq3B20rP2UjB3F+aIkPmnXnlYKu5Ck=;
  b=gAAbqYcQjshu/VwF5NStb05kHzZfZXK5a5dQg+/pQ4FGZk281zmTyD6j
   N2dhG6m9KEEj4y0ZsfxfwsWRQ5U/imx+RggHE336TB/E1heXhAg2Ja048
   5Y4IYqnEUwPaVv8DrQUgPAjUX2IGbyE1tFOxAk87znAJJS5vwYLTCStqY
   SZo8PhnwM78xTcttYkxPQCgzNLsLW/xmQqN2CqoT4h3C6N2esqCMAaJtT
   VUttt/TW3ZdZuaqC5kordoYkEiQ1ScxTrV/uXZSEqbxmW6bQ4DOhQCejv
   mzXoYwCXyjurwF9HbD4g+elkEpT09rDWYnZwYESQ1homtRn+za9edReLK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="313155345"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="313155345"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 08:34:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="782422336"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="782422336"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 24 Feb 2023 08:34:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 08:34:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 08:34:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 08:34:40 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 08:34:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKU/dZnqviYoI7FMKOLsJUpy4IO78w19YuEAMvHgJl2bkbw4f6ICfxMuAI15MmLyHsfg46ZBtydHzZ6Py/Lpkbx3menISpj8egwZ509qgmU2XxEsyoqKCA0V08t+yREe1u/ZY0bD5I7+RoRzUcUSqwR8dnKVD9u87PAHNVvZiKnPd2fnYrNAkNbyPlmkTP6R5al5SV862SEGhOkI4HhP1OyukGYwKEhfzSSl7Y3rGprLkaLmPvCwJ8nJw5EAtJLkKLn9f2hs1O3eFQ+7uDgOvgO6yOc0iXf8BwnF99h+PmgmbuGSODTKlwAvupvNFMO4+bVgZJuFOLvhrFD9xHv0QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4c18coto8+HDnq3B20rP2UjB3F+aIkPmnXnlYKu5Ck=;
 b=N3mGjUzIR2RnHVv9qYvsJFXEiDmJTAJJXkT2gviCPkICC/yrmmGkCjHKq+dm/HWe9ejpXMNi8sW8EWMB5a/HhnjXIMRzFlIkBH95GzXhCM7S1MDesY/mjhhaBfgXJffPXxsnhqOOAmO2llKUopkf6aRKu2BRC9t5WbuK1ld3yPOFvgV5kBbapQySgxj/8IpBVCE/E/rWaH1jczMrVPggra8MpEOe1XcoiUrR9674xt4zT50PV5v4jmmyMqM7+qFhHV0SFCu1YHRMTYhoIQLgH+jurL6pvSyszqBfvestlCCFZGSE4iGp6OOrCYH+Y7uJL3KbSjtVmu+oEi1LkwhHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB4967.namprd11.prod.outlook.com (2603:10b6:510:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 16:34:36 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 16:34:36 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC PATCH v3 15/32] x86/fred: make unions for the cs and ss
 fields in struct pt_regs
Thread-Topic: [RFC PATCH v3 15/32] x86/fred: make unions for the cs and ss
 fields in struct pt_regs
Thread-Index: AQHZSCGoAtP+d2NP6kO8XHsOE5TSfq7d7fwAgABcnqA=
Date:   Fri, 24 Feb 2023 16:34:36 +0000
Message-ID: <SA1PR11MB673406B8B43E18F0BD11C8DBA8A89@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
 <20230224070145.3572-16-xin3.li@intel.com>
 <bf1ad4c3-73eb-0f8f-e627-a7e0785fe903@citrix.com>
In-Reply-To: <bf1ad4c3-73eb-0f8f-e627-a7e0785fe903@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB4967:EE_
x-ms-office365-filtering-correlation-id: c8da665e-6a3d-43b3-0aaf-08db16850465
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ETVWOirXSt+vflRPplhMbjWSBCEFKjxy5Te27bB4ngCPS/8xYikvT3X6zsyQZLYaFXe0AHaWvptC43iEoqq+oXNroZxV2pRROSqhAsTqf4m4MR/HhWzMG9Uz9JSi7xPzB//STOQtlCjgUcllYijLmYiiq66XJBkAUpnm2knTy2uCYDN86TQC6+bGMlEVbfHUsVEnHLHqaEKRU0iaH6IbbytdUX/UecD5lRBX3fgcfHCh4jAV/RTeyTuyLZMAI+ocsO6MLsIBlcksxmZXkzS4t1OQPrWz0USU9zbiKzWsPCZwm6Vh0p0u/2Dgm7vkSX3pgG67dM7/zqC85r05PqRkNxWjBHtj0zzCQCA0oaqZ6BVv7yMvpuMuCHBCsRZkOZCNfhh4UdL2P/qZulUzlRkqpDT+jn14FiCHVcFJuSf/AEMw7S7W91ael06xGSFou09qsZssgS4kK+kf591Wg5Kz/vGJ/YLGXy5TX15oG3kJW6qMoC2LovnEK5eJfWAs5CrCX7NXUbGLucbmLs5SOL7+FlvJ9zg6vGAR/QjtW+fQ6M3ah6fxc/vau22MGRYCgRxNCIuePF6AzoW1t6FuohoH+27HtunAMePiKsEdHPq+CHtRUZpKs//pHRSCWvawrcbzAKhkrXfTCqQrEnLe32NnmvUrLi+wuc0Qjg0ylyA2zyqXM7XLdInO1h60tLWbioiqKXZ5rJUIEozheeimnTEtQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199018)(82960400001)(8676002)(7416002)(4326008)(4744005)(8936002)(64756008)(52536014)(2906002)(41300700001)(55016003)(38100700002)(5660300002)(66446008)(122000001)(9686003)(7696005)(26005)(33656002)(186003)(6506007)(86362001)(71200400001)(316002)(38070700005)(66476007)(76116006)(66946007)(66556008)(110136005)(478600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1BlMUVyaXFMNVRFWk1oQnpLZkdCWVo5eSs0L2tmS1J6dG9wQnhyNmVYdWRw?=
 =?utf-8?B?OWlEUVZnWkhtTndwaXUycndzOEdWdityU3RMQzE1SnErU3BXYjY1QTkwWk1k?=
 =?utf-8?B?Q1NrQTY5M0x4RGpnZ0tCeEJMdncrY0FFODhlQUp0am1qTVgyb09UdTJKWlNF?=
 =?utf-8?B?WmFiaktrMHZ2ZnJscVVaMk04SlIvMWI3VGZCSkpicUxKak5qWHVFNmdBNklK?=
 =?utf-8?B?UVp0RUZnbWxINU1RQnFDTEFET1FtMnhpYk1reTNoWVNpdU9LR1FRLzhrNFl0?=
 =?utf-8?B?WXpyOWJhVms3a0dsY1M2YlpYMTNPRkNteUVFcmtCVmhDaktPWnRkdWcxZklo?=
 =?utf-8?B?clB3ajFvL1hmTlZyMytaRFBZMkE2T1JzMThNV0tQbmd4TmNXQUFZL2tYOWEw?=
 =?utf-8?B?UDlyMGtlVGY2Z1EraGlKTnJ6MStKNkNtb2doekFkNmdXK0lMWmNXR0paZC82?=
 =?utf-8?B?aCtheUdIdUkybnp5MHNSaHlYanN4RzZPYkpHb21mMlRBRnN2YmZhUHpIbjB2?=
 =?utf-8?B?MXNrK2hDWTdrdzFoUTRldDFncFRXY25XZjRUWFl5WEswT3QzazdSS1dua2pz?=
 =?utf-8?B?M2tDbldkWWZVOE9ST2V6eTdzM0tqZmgzSDdoMlJkNGxnd2w2L2lTZ2pGMVJm?=
 =?utf-8?B?Mm5qa3pLdSs3K1ZJT21NT3k2MGEyRzVvMXVSRzBPUlVNSkR2SFBIMjNKclJv?=
 =?utf-8?B?TVlnNjVkR3pJZWJhWDl4Z0J4U1R6dDd5SFk3OXU5TEw2RjhZVVNsVXFwNHRV?=
 =?utf-8?B?YXJXUWNBRFg1eHpQa0x6VGZxM050TDV5d3g5N0s3d3lKR3RxQ0pGbWNScXB6?=
 =?utf-8?B?eUN4NUF1YnFZaU5RV0poeUd2LzVYd3hMZXNpMVN6UzIraUlLTjhRRnVsWDMv?=
 =?utf-8?B?QlZMWUI3bHI4SU5LOUJ4UTVORVNKdngvMTJ1cndkNEQxYnpHaklxZjU3VXZs?=
 =?utf-8?B?Qlc4ZVN3dm1DcWdyVDAxKzZ0ZUF4THNwcUhQZXU4eldWVGo0ekhpUlJRd2Zx?=
 =?utf-8?B?UmNteXRzMExqMjdENUdoSHAwMndyZEluTDZ3Q2JrYVkrdFFGOFF1LzB0RjBE?=
 =?utf-8?B?Ylp6eFVzZlliNWhhd2w1OUIxNHdnWUdmN3UxdlFmVENHWkZHN2RrbXRIODhh?=
 =?utf-8?B?ODFCQURod1AzNEZ3c3ZhWkprTXcwQzRJeDlMZmttS05nS1AzanVGMlZWUytx?=
 =?utf-8?B?RE1KU0dBdkptcVM0SDZuTGVaeGxhcFFieCtEOTBGVVo0SEE4Z0ZwMVdGNUZ4?=
 =?utf-8?B?QVowbFU4dGRYdUozeWtXOXRtZXV5MjFEMzZkTndIaVBDRkFpb095NzhpQUFV?=
 =?utf-8?B?eWVQN3dKTUluRzFlRFl5c3lHYUkwaWsxVm90Wk9USVYzMWpBanRoYUt4cVFt?=
 =?utf-8?B?V2R0WnZWb0RGSWU1aytaYW14RXFIVkt4Zk9TV09WbWluYzBJL2JKWjhObEI3?=
 =?utf-8?B?ejJwU050OVQwQ0NiNDRHeFJJWW40L3NaUFNtOGdBenUvQTZBUml6TU9wTEJI?=
 =?utf-8?B?STdyZGhLb3VTVWJ5OUZ4V1FYSWFreUVyWk1xUFppanl2NDc2a0NhSmgwMzJT?=
 =?utf-8?B?ODVpQ0pBUitIREFaR1ZPS052UVV0aHN3VThFM214NHQwNTBQazFFWEVCMkRD?=
 =?utf-8?B?M21yaEppeFptZGRMeHJrWHRJem9neUg0Zjl6b1FBNlVCQlpqQW1GRG1Ld2V2?=
 =?utf-8?B?eEh3WlIrazA0dXE5NVRtYXhoMnUzazJzdDVXUFVQMTcwSmFNTjZJOTM5UTAx?=
 =?utf-8?B?VlFPbFFNbkw4R1hjVVhVRWdpK3R6bW9jNUVsL2dPc0F4bFJERXNjYTFPS0Fp?=
 =?utf-8?B?QUlaWmU3RnpYa0x2SWpPV3B4eDhOcGxuTkhhaVJ5N0pCRERUYVE0UE5LK2lU?=
 =?utf-8?B?U2NxZlNUY0pYUXV5aC9ZVEdJSURWR1pKVDd5bTBzWU9rdnlhT1p2TmdsUDhM?=
 =?utf-8?B?UkJXUFpEQitnZExWdmJvN3hjVTQ0MVZ2WTRKVll2ZVhleGxjYjA4aEtNNXc4?=
 =?utf-8?B?OWlaczRZa1B3K054UmF3c0VMdEZWaGVWT0l6NEZCRHVlendxeWJLdnUreGll?=
 =?utf-8?B?ajIyRGwxTnVnV2Z3TkkzT2tOdnhtaGZhbjlKZGZMT0UrbURxaXRkcnBBRi9Q?=
 =?utf-8?Q?x0pw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8da665e-6a3d-43b3-0aaf-08db16850465
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 16:34:36.3093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P79AoNlGO8bzCiRtGwGWCrxFHnC6ba9w+Z3Umi7uXfOn7zX3z6gnmWT9gStHqSu/YpLgVTN6j7oyl6djh2Rfcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4967
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ICsJdW5pb24gew0KPiA+ICsJCXVuc2lnbmVkIGxvbmcgIGNzbDsgLyogQ1MgKyBhbnkgZmll
bGRzIGFib3ZlIGl0ICovDQo+IA0KPiBJIGd1ZXNzIHRoYXQgQ1NMIGhlcmUgaXMgc3VwcG9zZWQg
dG8gbWVhbiBjcyBsb25nLCBidXQgQ1NMIChDdXJyZW50IFN0YWNrIExldmVsKSBpcyBhDQo+IG5l
dyB0ZXJtIGluIHRoZSBGUkVEIHNwZWMgd2hpY2ggaXNuJ3QgdGhpcy4NCg0KR29vZCBjYXRjaCEN
Cg0KPiANCj4gVGhpcyBjYXVzZXMgY2hhbmdlcyBzdWNoIGFzIHRoZSBmaW5hbCBodW5rIGluIHBh
dGNoIDI3IHRvIHJlYWQgaW5jb3JyZWN0bHksIGRlc3BpdGUNCj4gYmVpbmcgdGVjaG5pY2FsbHkg
Y29ycmVjdC4NCj4gDQo+IGNzX3Nsb3Qgd291bGQgYmUgbXVjaCBjbGVhcmVyIGluIGNvZGUsIGJ1
dCB0YmgsIGV2ZW4gY3NfbCB3b3VsZCBiZSBiZXR0ZXIgdGhhbiB0aGUNCj4gdmVyc2lvbiB3aXRo
b3V0IGFuIHVuZGVyc2NvcmUuDQoNCmNzX3Nsb3Qgc291bmRzIGEgZ29vZCB0ZXJtIHVubGVzcyBz
b21lb25lIGNvbWVzIHVwIHdpdGggYSBiZXR0ZXIgb25lLg0KDQo+IA0KPiBBbmQgb2J2aW91c2x5
LCB3aGF0ZXZlciBpcyBkb25lIGhlcmUgc2hvdWxkIGJlIG1pcnJvcmVkIGZvciBzcy4NCg0KUHJv
YmFibHkgc3Nfc2xvdCB0aGVuLg0KICBYaW4NCg==
