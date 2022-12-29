Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68F3658A0A
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 08:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiL2HmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 02:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiL2Hl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 02:41:56 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC7BF25;
        Wed, 28 Dec 2022 23:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672299715; x=1703835715;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I5/J2J80GnF2WHtl1APxA56gXAprz0rbPlY3G3ai03o=;
  b=mW+C8W2ZH/BYsEt91hNMHRfvDQI7O4BPimpcktVmswXavg6Ka3NGQmCj
   e65wLFx2M/z9VwmuaC4f+d/qThSLBRUXBxlImUrEYUrgRjHE3rge7HKXQ
   BSunD+gkw9Oc1dz3+7DZDwCccTFib+41eJaUYSu95iaaWIaNTwrIxC1rj
   LzTaaOE7QdQCkxclYjGzo+JUJIrcZlns26JUMKxOC3Jp57jXyZ4dKHzNW
   WYgLLfECcXBonHnLL+SM8rWGWVb/4hH3/OSi+pmdvM12XPU896YFMZVlr
   45ePzgsMnl2fB+P19iCsnjOYFXHcf4wMTaKL5TLqoWZVERzopIx3KB9h2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="319712130"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="319712130"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 23:41:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="795900248"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="795900248"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 28 Dec 2022 23:41:53 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 28 Dec 2022 23:41:53 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 28 Dec 2022 23:41:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 28 Dec 2022 23:41:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 28 Dec 2022 23:41:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZRvxPBUqWAycBkAFKjKHgpz5VvoChuMPpzJzlzmpt+420X9OwyJCqaDZq+PowdTUqhivoK+AFPhS7UeoEpUKS7jJcpNpUefYUDmpyuxAsA4CmIk2KCyTJ5I7AbY1fSzx2nOHkUeNooWddRmfensrypNF9c8/zp+ao6LVWNTtqr7mt9P6RlQpjVPH3MuEWGpsX0KI3K4huIpGiM14lbSAY5XzNGiB3k83EHEjAAyU4W3s8GQpVcB7WCX0W2FejqbgzXZBoi658mSkumyWEyHvfY3j3ff+NAcbobUYlxMNwB9s4iGh/7DduHy8F3pYPf0G7m97IUKegzOTQ7YTddv5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5/J2J80GnF2WHtl1APxA56gXAprz0rbPlY3G3ai03o=;
 b=K1E5lTKAg/fFb+gfJepCwJBPElJb007pyBJ+C2Eo6RCpEsJAGUCi0HB3C0SFmSyPIgLIelebwUrcaceqCrjYhNfy3K81c2G1kvymWGjbssuWykUFnZ0cC0se8KIuyGOa++xK+9GpDNIj2DIHBfI91A6D1XS+/tQ1rGEsuvf5DY+irOWo4zqzp8uKosHHAMa5D4PPS/Qc6u6O1gtx+mgLtjxlmJ3h6AI9IJZ3D+XFkknMY2TJLl2dHcB//tOqHjD4CSuffiCp6ahhTJWJW0RTz/WQvXZxfH0ZOifEIouzWNe07rWQ8WZxo2rEMlUwocHbEgkDcII0TMhSntu/MyyZyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0031.namprd11.prod.outlook.com (2603:10b6:301:69::37)
 by BN9PR11MB5418.namprd11.prod.outlook.com (2603:10b6:408:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 07:41:15 +0000
Received: from MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5]) by MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5%7]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 07:41:14 +0000
From:   "Zhang, Chen" <chen.zhang@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest
 MSR_IA32_ARCH_CAPABILITIES
Thread-Topic: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest
 MSR_IA32_ARCH_CAPABILITIES
Thread-Index: AQHZDLMiQbmbfwYsK06hcLGAwsuJI653yRSAgAsc9kCAAae2gIAACZ3w
Date:   Thu, 29 Dec 2022 07:41:14 +0000
Message-ID: <MWHPR11MB0031974C4A46C1895FF8C9929BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-7-chen.zhang@intel.com>
 <d4dec151-553f-e762-7fcc-81ae82b5c211@intel.com>
 <MWHPR11MB0031EEA971FDA614271C22449BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
 <cbbdb23f-4261-4f48-4143-c5fb6c78da06@intel.com>
In-Reply-To: <cbbdb23f-4261-4f48-4143-c5fb6c78da06@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB0031:EE_|BN9PR11MB5418:EE_
x-ms-office365-filtering-correlation-id: 4055fe32-ea57-4d25-63ef-08dae9701027
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fF6Z72h582b7VBWqIhF4BIOoJ4wuG+f39gKoe4XFUT+srjGexsF4+2QsdLjOutoBGXqRtEYBKRp4YiRCg5a0nc/0S7ub9q6sIRfNZCVYYzBpiBrIWuUW4mpCI0LqMA6HarET0LzUesYbFpY5jigXgaKy1nQEHQDeaBm0IU7AEaWdNpFveEuW7LLP+XvjBkVDoL3QryiipOwom8Xoru0f7m5XcdXAJLJvAKqGph9mISjj4L7sY1Vjiah9bLsE5bMKsbto0qNCb9mtL6JMxv1/ud9F2w25V5Guuc8Nepxb8qUYOBDRofFi3HJMpCgyhOvpBl+yFz6zSaK2Z4a/a6n65uaOerclMJp+ppWzQhEO9p9CMh9qpWDHuihERhvna6JKJNiYZ1PKBhjfIvxBscFJfKZyEiBaYfLpRAgI4Z2lpO9tP7FDgu70Ljc1fxFj0g8xqJoKGvpMSPBso6St/qT/yK/sFnTZKn0xUYSVvCK/J5aI3EHGiaVAZZ4ILv6M1PC8CwHJJdI/PLzPvVGkHlQxFk5nbWRYcnrB7qt/6Kj+OyuaqyT3Vty3czA0jKNyfpxG45l+NDkZcAaOvkSZZwbersQkMc2FtDSIxSS7hfSO1PZlSTF7GVanYHuJGV+CHz84gdVXh5qmyok8YrcDQEQUosXEhqbVGOZ4jIfyPX/V+T78u3ZMaXxRXzibtTA/9ShRWzDSoDQLNuyBckb3Uix3euhU9hMYjR9NqfmwTIyhJgM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0031.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(82960400001)(33656002)(6862004)(2906002)(5660300002)(38100700002)(122000001)(8936002)(41300700001)(7416002)(52536014)(83380400001)(86362001)(38070700005)(966005)(66446008)(64756008)(316002)(54906003)(71200400001)(66946007)(6636002)(66556008)(66476007)(7696005)(478600001)(6506007)(55016003)(4326008)(9686003)(8676002)(76116006)(186003)(53546011)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkZLckVta01wVTQ0cDhWOTZ0eDBaYTJlK1NRcng3dU1VUWpzYW1QV0ZOQm1K?=
 =?utf-8?B?RjBISittbFZCYU5jbjdhMVZvRm5od2ZqSHhodmJRUTVDQnlSWC9jajBZQWJ6?=
 =?utf-8?B?b2RmeDVBSWNobmRUdzZmNGx1SnNjUVlFYlpRdk1iazU2cWhXN0Rid3MxUFZa?=
 =?utf-8?B?dGJlRFFRRkg2UlZKcitkaFplR0FtdXdiOWdGR2Vmby9WVjc0RVZtbEVCaVph?=
 =?utf-8?B?cHlYVER3aXhwQ3N0VGF6eUNJaUsvK1J0UlY0Q2ZzS1hNNENTTVREYkNUT0VL?=
 =?utf-8?B?UklEdWpha2hqZWtlT2FoMjZmdUNsK0Voa0JRWVZucGhpcktkbGFlVTVuSmcx?=
 =?utf-8?B?NDlqRXF5ZFBPS2dycUZmd3oxQ3FObnhzaStkVDYwL3IvWUZhNnlaOElsNG1Z?=
 =?utf-8?B?aDZ0K0hqa2d4MTh5eWt1eXdlUEZWS082SWdTK0kvdUU0ZXJWdlovaVp6RlN5?=
 =?utf-8?B?MzUvRDc4emhjek9JMlFsWEJ4UC9OeGZZcFcyU1ZGMkJXVy8wWW5SMEZ3Y3JV?=
 =?utf-8?B?Sm52bDlzYWppSWs1TFZoazc2dXhESUlVYU1IUEw0MnNocmR2RjNuS3k5NWVC?=
 =?utf-8?B?V2t4bThQSHJ6YlV6Zjg2NDczbmtnK2VXay9BSXBZT1JrNlZrd3JhTEJSWFF3?=
 =?utf-8?B?dmV6cnQrSG9YS0dvUEt2a241cGordGJJUkt5REFUWmQ2cGNFcU56Y1JSWVdK?=
 =?utf-8?B?eGZVUWJ5V1RsN3l0c2FiQStkNHlwREszajV6OG90TnI0Vlh5dlNpQTYwMHN1?=
 =?utf-8?B?NnpkdHNjdUJ5WTRpcWFDdm9kd2FodWZUQ3dmME1YSUNTR3ViTGF4b1V2ZFY0?=
 =?utf-8?B?TzFtenAvVXIxa2tQVGFwaGxNU01Rd1NBT2tKM0szNXJ0RWxuWEpROUxNT0Ix?=
 =?utf-8?B?M1FPQVRHdHdMcEdLanZ3UDJZbWh4S2RPNEpOMm5yVzYxSm9XUzRaUHdXbEE4?=
 =?utf-8?B?T0FTZ1lSUWRVNjR5bGkydXpURXAzQzNqdkgyUWxqWnFPZ1owUXZ1NlhaUkor?=
 =?utf-8?B?cmdHejBHeTJlZnpCQytOUm85LzVMTGYrVTBUQXN1bUJQZXVYajZVeDJiTGFQ?=
 =?utf-8?B?aHFzbnc3V2w5YVpleC9maG5YdkNxZEF3bU5yQmkrd2gvSE80QzFWM3ZlVzBF?=
 =?utf-8?B?UnFPbWVQaFhnZEFLYUVUb3Z5MFVEUWQ0TTFUZjVTWm9wMmt1RWs4bkd0Zkdt?=
 =?utf-8?B?KzRFbE1QdUw4ZHZyeWNvcU1CYUhZZVlHNUZrd2Ixc0RxM1pHS2NiRnIvTEV0?=
 =?utf-8?B?ZTFzTGozSDZqTE4yV0RhamNDWXcxYTdOVXNTQU9kd3FRcDZPWTFHbzdDdzUx?=
 =?utf-8?B?UVJqeGRiYitDT2NBYTNWQ01OZFk0VEtTaG9MbWhscFlsNW5pL0Y0NnF6My95?=
 =?utf-8?B?OGZXL21JcDFlVFVVelpUOGhwQVNZSEhxeUpuT21UVkVHNzZuQVprY3U0R3Za?=
 =?utf-8?B?cHNtQmR1VnBxcmZLWEJobTBwdHdhcXBScWFvZVVUVFUxdmdQNjhDQUFmNnVi?=
 =?utf-8?B?cmJ2aWFQbXZhVjBOZzVmcktMV01ZTDl0TEtVcVp2cWpjSERVMVUrb252Z2xt?=
 =?utf-8?B?Tzg0RUR0ajgvTzVCb3FlZUdhMVYxUjVoa3M3NHFLWjg3ZE9qRDhST20yL3dw?=
 =?utf-8?B?Y0liM0hZamY1Y0RVclF5Z1FtRjBHMHZWVkJDTHk2VmkvVnNxSlZMQnFlemdX?=
 =?utf-8?B?Mnk4QVJFM2w3SjhrMmhyM3dDWjROTWw2VGFPL21VVHYxdzhucXZINVNwNkNM?=
 =?utf-8?B?MDFaWm1Pd3VmV3NiZmlJNFFGOHNPTmlTcW5wQmw1ZEZRM2xnZHljMVFqZVJp?=
 =?utf-8?B?UFpJRUwwK0I1RGlCNkJLaGtBUnVISHR6bTJsV3pLUVBxUkZyellHSlVwb2pR?=
 =?utf-8?B?WXltdUtaSTI1ZnU4UVlHVHNzSGpFVnVaUzNkRUhsWHh2SHQwRDk3Tit4ajhT?=
 =?utf-8?B?UlZmYjVVRjVuYUliWVhxeVE3ZjdCSjZ1SzdrRlVsd0JKc2syL0Fsc25hVWox?=
 =?utf-8?B?TTA2UGVjL1JHemUreDB3eGRheEp3ck4zWVVJL0pDZEtvWVpwZXRNVEsySzY5?=
 =?utf-8?B?d0YyMWV0L2JZYWY0S1YxTlhtZzdoOGhmbVFjM1dXYk03TTVKL3NEc3hibXli?=
 =?utf-8?Q?NWX7ioZJm9QAMth/zMyN9GjXF?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0031.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4055fe32-ea57-4d25-63ef-08dae9701027
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2022 07:41:14.2659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RhHdbFjUj3civlUKk/DSt7/zuwBMOyMQOm1OIfkU9lfzdZ8H6jU4UEjHv1qlwnL+Bu0mBK/pIIEnApC8QNWsPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5418
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWWFuZywgV2Vpamlhbmcg
PHdlaWppYW5nLnlhbmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgRGVjZW1iZXIgMjks
IDIwMjIgMzowMyBQTQ0KPiBUbzogWmhhbmcsIENoZW4gPGNoZW4uemhhbmdAaW50ZWwuY29tPg0K
PiBDYzogR2FvLCBDaGFvIDxjaGFvLmdhb0BpbnRlbC5jb20+OyBQYXdhbiBHdXB0YQ0KPiA8cGF3
YW4ua3VtYXIuZ3VwdGFAbGludXguaW50ZWwuY29tPjsgUGFvbG8gQm9uemluaQ0KPiA8cGJvbnpp
bmlAcmVkaGF0LmNvbT47IENocmlzdG9waGVyc29uLCwgU2VhbiA8c2VhbmpjQGdvb2dsZS5jb20+
OyBILg0KPiBQZXRlciBBbnZpbiA8aHBhQHp5dG9yLmNvbT47IERhdmUgSGFuc2VuIDxkYXZlLmhh
bnNlbkBsaW51eC5pbnRlbC5jb20+Ow0KPiBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT47
IEluZ28gTW9sbmFyIDxtaW5nb0ByZWRoYXQuY29tPjsgVGhvbWFzDQo+IEdsZWl4bmVyIDx0Z2x4
QGxpbnV0cm9uaXguZGU+OyB4ODZAa2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCA2
LzldIGt2bS94ODY6IEFkZCBBUkNIX0NBUF9WSVJUVUFMX0VOVU0gZm9yDQo+IGd1ZXN0IE1TUl9J
QTMyX0FSQ0hfQ0FQQUJJTElUSUVTDQo+IA0KPiANCj4gT24gMTIvMjkvMjAyMiAxMDo1OCBBTSwg
WmhhbmcsIENoZW4gd3JvdGU6DQo+IA0KPiBbLi4uXQ0KPiANCj4gPj4gXA0KPiA+Pj4gKwkgQVJD
SF9DQVBfVklSVFVBTF9FTlVNKQ0KPiA+Pj4NCj4gPj4+ICAgIHN0YXRpYyB1NjQga3ZtX2dldF9h
cmNoX2NhcGFiaWxpdGllcyh2b2lkKQ0KPiA+Pj4gICAgew0KPiA+Pj4gQEAgLTE2MDcsNiArMTYx
MSwxMyBAQCBzdGF0aWMgdTY0IGt2bV9nZXRfYXJjaF9jYXBhYmlsaXRpZXModm9pZCkNCj4gPj4+
ICAgIAkgKi8NCj4gPj4+ICAgIAlkYXRhIHw9IEFSQ0hfQ0FQX1BTQ0hBTkdFX01DX05POw0KPiA+
Pj4NCj4gPj4+ICsJLyoNCj4gPj4+ICsJICogVmlydHVhbCBNU1JzIGNhbiBhbGxvdyBndWVzdHMg
dG8gbm90aWZ5IFZNTSB3aGV0aGVyIG9yIG5vdA0KPiA+Pj4gKwkgKiB0aGV5IGFyZSB1c2luZyBz
cGVjaWZpYyBzb2Z0d2FyZSBtaXRpZ2F0aW9uLCBhbGxvd2luZyBhIFZNTQ0KPiA+Pj4gKwkgKiB0
byBlbmFibGUgdGhlcmUgaGFyZHdhcmUgY29udHJvbCBvbmx5IHdoZXJlIG5lY2Vzc2FyeS4NCj4g
Pj4+ICsJICovDQo+ID4+PiArCWRhdGEgfD0gQVJDSF9DQVBfVklSVFVBTF9FTlVNOw0KPiA+Pg0K
PiA+PiBJTU8sIHRoaXMgaXM6wqAgZGF0YSAmPSBBUkNIX0NBUF9WSVJUVUFMX0VOVU07IGJlY2F1
c2UgaXQgcmVxdWlyZXMNCj4gPj4gcGxhdGZvcm0gc3VwcG9ydC4NCj4gPiBJbnRlbCBkZWZpbmVk
IHRoZSB2aXJ0dWFsIE1TUnMgZm9yIHNvZnR3YXJlIG1pdGlnYXRpb25zIGZvciBhbGwgcGxhdGZv
cm1zLg0KPiA+IEtWTSBzaG91bGQgYmUgdW5jb25kaXRpb25hbGx5IG9wZW5lZCBpdCBmb3IgdGhl
IHNvZnR3YXJlIG1pdGlnYXRpb24gaW4NCj4gbWlncmF0aW9uIHBvb2xzLg0KPiA+IEZvciBleGFt
cGxlIG1pZ3JhdGlvbiBmcm9tIHRoZSBvbGQgcGxhdGZvcm0gdG8gdGhlIG5ldyBwbGF0Zm9ybS4N
Cj4gPiBQbGVhc2UgY2hlY2sgdGhlIFNvZnR3YXJlIE1pdGlnYXRpb25zIGluIE1pZ3JhdGlvbiBQ
b29scyBzZWN0aW9uIGluDQo+IGRvY3VtZW50czoNCj4gPiBodHRwczovL3d3dy5pbnRlbC5jb20v
Y29udGVudC93d3cvdXMvZW4vZGV2ZWxvcGVyL2FydGljbGVzL3RlY2huaWNhbC9zDQo+ID4gb2Z0
d2FyZS1zZWN1cml0eS1ndWlkYW5jZS90ZWNobmljYWwtZG9jdW1lbnRhdGlvbi9icmFuY2gtaGlz
dG9yeS1pbmplYw0KPiA+IHRpb24uaHRtbA0KPiANCj4gSWYgdGhpcyBzZXJpZXMgcnVubmluZyBv
biBvbGQgcGxhdGZvcm1zLCBob3cgVk1NIGNhbiBzZXQgc3BlY2lmaWMgdm1jcyBmaWVsZHMsDQo+
IA0KPiBlLmcuLCDigJx2aXJ0dWFsaXplIElBMzJfU1BFQ19DVFJM4oCdIFZNLWV4ZWN1dGlvbiBj
b250cm9sLCB0byBtaXRpZ2F0ZSBndWVzdA0KPiBpc3N1ZXM/DQoNCkVuYWJsZSB0aGUgdmlydHVh
bCBNU1JzIGRvZXMgbm90IG1lYW5zIHRvIGVuYWJsZSB0aGUg4oCcdmlydHVhbGl6ZSBJQTMyX1NQ
RUNfQ1RSTOKAnS4NCktWTSB3aWxsIGNoZWNrICJjcHVfaGFzX3ZpcnRfc3BlY19jdHJsKCkiIGJl
Zm9yZSBzZXQgc3BlY2lmaWMgVk1DUy4NCg0KVGhhbmtzDQpDaGVuDQoNCj4gDQo+IA0KPiA+DQo+
ID4+DQo+ID4+PiArDQo+ID4+PiAgICAJLyoNCj4gPj4+ICAgIAkgKiBJZiB3ZSdyZSBkb2luZyBj
YWNoZSBmbHVzaGVzIChlaXRoZXIgImFsd2F5cyIgb3IgImNvbmQiKQ0KPiA+Pj4gICAgCSAqIHdl
IHdpbGwgZG8gb25lIHdoZW5ldmVyIHRoZSBndWVzdCBkb2VzIGEgdm1sYXVuY2gvdm1yZXN1bWUu
DQo+ID4+PiBAQCAtMTY1Nyw2ICsxNjY4LDkgQEAgc3RhdGljIGludCBrdm1fZ2V0X21zcl9mZWF0
dXJlKHN0cnVjdA0KPiA+PiBrdm1fbXNyX2VudHJ5ICptc3IpDQo+ID4+PiAgICAJY2FzZSBNU1Jf
SUEzMl9VQ09ERV9SRVY6DQo+ID4+PiAgICAJCXJkbXNybF9zYWZlKG1zci0+aW5kZXgsICZtc3It
PmRhdGEpOw0KPiA+Pj4gICAgCQlicmVhazsNCj4gPj4+ICsJY2FzZSBNU1JfVklSVFVBTF9FTlVN
RVJBVElPTjoNCj4gPj4+ICsJCW1zci0+ZGF0YSA9IFZJUlRfRU5VTV9NSVRJR0FUSU9OX0NUUkxf
U1VQUE9SVDsNCj4gPj4NCj4gPj4gTmVlZCB0byBjaGVjayBiaXQgNjMgb2YgaG9zdCBNU1JfQVJD
SF9DQVBBQklMSVRJRVMgYmVmb3JlIGV4cG9zZSB0aGUNCj4gPj4gZmVhdHVyZS4NCj4gPiBSZWZl
ciB0byB0aGUgYWJvdmUgY29tbWVudHMuDQo+ID4NCj4gPiBUaGFua3MNCj4gPiBDaGVuDQo+ID4N
Cj4gPj4NCj4gPj4+ICsJCWJyZWFrOw0KPiA+Pj4gICAgCWRlZmF1bHQ6DQo+ID4+PiAgICAJCXJl
dHVybiBzdGF0aWNfY2FsbChrdm1feDg2X2dldF9tc3JfZmVhdHVyZSkobXNyKTsNCj4gPj4+ICAg
IAl9DQo=
