Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0448622B7F
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 13:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiKIM1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 07:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKIM1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 07:27:40 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90622C121;
        Wed,  9 Nov 2022 04:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667996859; x=1699532859;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QXdsTTqpJ34/59x6NnsH02gy3w70pfbE9+SDi5RP4LM=;
  b=gg94c7SzBplre1z2zyWqp88g5Bt37Dp5RttYylN31n5u1mI4P4OfOtw7
   m6ETIsvXL4omM1DscI21GyTLcCKL/xcQPJjuGsbcOsh4hB7NV3ezjwAZP
   8FiW8a+KFrnSwmF0FhbOZhh104uviufgnzl7QA9GgWunke2/cS0GiVH3M
   FlhmjsSk+JKWrklmq4y4UYoG3BsoxrNkQLy4dmG3JrUaTbXJvKwc4sqGR
   bukJi/XcultYCO/xnIti0mnMsT2ffZU0UtSdHNGIBdz8fP1u2wPxf7yEp
   xqTxuz5rONWRgSGQrE6460nAwAqw5Dddyoy4R4W54Rgl6BpaGi8hINa3A
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="310959206"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="310959206"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 04:27:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="881913690"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="881913690"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 09 Nov 2022 04:27:39 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 04:27:39 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 04:27:38 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 04:27:37 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 04:27:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/OUlM7uIaRpV71J+TvjhGTDYSiily1Ztq/exsBzMpEHMIY3L0jI5xZjIpm94BcGbAwzCGySM6UdlIIAwX5Co8TOpsjsa01CIsAJ/Qh6xojlO2x9I1OrU7pfYVgujTocdQih1Ivpal7S/MtBo6Eg6Ow0VseyfgooJSVwk6+26/E7mZ/142l6g/B2RiR4XUmhri272VhueLwNKPUlUFhupULg9yFbO78Ukhsp9RCjUavGMJWK/7KApTsB8ChHxEeeew3QrpYnyuTvN9G3DlGogj4B7AcjdpF4XQaKBAN5vZk6s+FH+YX3pSRXGFMSuVEGL24bO2E00UMsUfHziJpuVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXdsTTqpJ34/59x6NnsH02gy3w70pfbE9+SDi5RP4LM=;
 b=VcYCyNqO6E0BGCJDsDSC0hG8KDEMswxDGG+6tCZI9xUcWrvrGTgPJR4eIEFyZ/QOxGJbPNjjaFJEp3dctF86AkqDmb27Vo7d10z7iXHgPv17xueQl34wsoAAjUEwstn0m6YxA9Mq88GPl2lsRL9uQpcMULPkM6tAI3iQ3e7zMQizGpcihGtQyD2JDnrqW7sRUHyNkN8gDvFzcHPSYrIj/xGk8m3xggA4NgU2ZSyD0R8+KM+ZKbEzRm14VrP5CyayNF8nLR9uPvbzZOkK8VwxmgjS9Dt1ozseFScT2XE373rnahECYFLB0ERiH1Vjgh8yl6o2xPP8leLpBJQPtJaTfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6372.namprd11.prod.outlook.com (2603:10b6:208:3ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Wed, 9 Nov
 2022 12:27:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Wed, 9 Nov 2022
 12:27:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Topic: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Index: AQHY7ChybP3VDS//1EK2niE1cyNWwq42lPYA
Date:   Wed, 9 Nov 2022 12:27:33 +0000
Message-ID: <3feb8d35ff42814927a3c52935b97527ef827e9a.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6372:EE_
x-ms-office365-filtering-correlation-id: ec467e59-4209-48a8-15c5-08dac24dc716
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6NKmwGs7grveOLxcrWtRWvJlcq16tcljcs5uRAD51sWxzMsNncAW+z4JuIZaxSdJgzIELVSS9LLAxGj2+gxuWMMlfrpJPoWJCsVJdwseOEMDjAvd03regPvqauw28hePVFFsvU/+u7bRqqHIonGfrPPkmSEA2Zbj4uzCGZs8VHql0762G/gyDw83xyMxpXGmvOEB3AAePtG3xOeyOe+ukiL0TqzjZsVx4P98mX6wIo4bamS+SqEY3Eyg75jVww8AVY2lTrlXHYkKrx/T/ooLYO7EO8Mo/SdCDmeW+gDKOmXQey6BRdhcsex3giV0PzlLx+siqqOUG5SSDJG/n9SucawDazPHSZVxptutjjlYqpKGtdniH8yY8X1bmrre5I/18LMt85mhnYAWeX6BEetoIBiKVAnQiVWFzDr09Nc+J/naJ7Sy8OpX+B+i/w8XcV3M1Oq55pnYgLUdE7HgBirFQmyLP/Ask+FcPdEALzxQXdvZTo3QMLrBGCgazv1g7ygNbggiaN2H0pQOFROrg9N+fN97zHlv48pp8jYvM2YVSyTysByisK97yCjgkykWSVY3DEI5FnDMPVXTHC4pucdzDtSFK2c9s4LHz+CIbxqOo6cC+0HEJZMbxe5rRcPAYQkmaKNC3LlGkvahNdM3qWaYcHHUL80t2GoKrYL8CfvVfa+fikQdUtX3hdUUh/q8UEdqAgMHNWKhgAPN4LigqOsK737x7ASL49qU06dfqWGg9gZE1v1JYE7+P9tKL6Ls3RNcOgZ1+m2D3hh1gvlQBj+WBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199015)(71200400001)(478600001)(8676002)(8936002)(6486002)(4001150100001)(4326008)(2906002)(64756008)(41300700001)(36756003)(5660300002)(316002)(38070700005)(83380400001)(110136005)(6636002)(66446008)(66946007)(54906003)(91956017)(82960400001)(6506007)(38100700002)(122000001)(86362001)(186003)(66476007)(2616005)(6512007)(76116006)(26005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M09EVnNVT2RjWFkvcGlQUG9yM21UaE82SjlvdXB4NDlLd0tScEYrZUVtUGI2?=
 =?utf-8?B?bkNxdjlRNFJsMVIxaEVuYkJDVVNrcDBTYUhiZjhnRWtPMmlKeExhQ2wwOW1H?=
 =?utf-8?B?aEhmZXZNaGFSU05XS2d2b2tEMWZsQjZ3SmdIMjZOQ2g1WDZHTkRVM3ppVlBh?=
 =?utf-8?B?dG1DQmk5RFBFYjZOVkRsenF3bzdEY3dBWFlyTkFPb1hrb3M3NjJNVFQwN05j?=
 =?utf-8?B?aFM5NUliazJ4Z2VOajlhVzJLZDN6TUhQTk82eVlER2JGdzh6cGgrREtrcU5S?=
 =?utf-8?B?K2h6c05ldS9DRlQxMTVTRTVRdGx5ZzFkck0rTE0vcCtPSnM3U1AvSDB1VElj?=
 =?utf-8?B?ZmNvd1BIQnRsdkd2cVZOZy95a3FxR1lmM2l3cWp0RXQ2clAzSDRmaXhUZHlI?=
 =?utf-8?B?dFVrWktEYmVrOUtVY3Y1ZTNQbGRQV1VseGgxalVzUW04b1BmL3BNUFQ5UG4v?=
 =?utf-8?B?b1hWN1pobmFMcHArdkVJWlo2Zy9HNmI5YWgrWFFFZFJTcVBqUGRoN3RqSTdZ?=
 =?utf-8?B?ZU9xU1V5ODJ3YllnalI0REpYYUFDL2tsNSs2bkdBOU9DUkMweWNkaU5YeHU5?=
 =?utf-8?B?TzdvdmxPVWxkc2ZkNnhtaHBLbHpQOFhsVEpENXBlZmtyZC9ib1Flb2RSNHQ2?=
 =?utf-8?B?eDJKZURDWm1mQmNwWGRHWEcyN3NOQzZjTUR6bFIxeXFjcS92Q3dUVDRQZHV3?=
 =?utf-8?B?M3JicFNnRDZBbHpZK2pRM3E2ZmU0cEdtbFE4RXpsTGVCblUrbHB1elAzbDg0?=
 =?utf-8?B?WExaajFXZFBPMHRsajNOOUlNUVRNYlRyNEJXRzJWaDBBYzBSZDZWZGhBY0Zh?=
 =?utf-8?B?UjYxM0o2Tk90aHR2OUlpUDRnUFIvWXIzdDUwOWhlV1k1ek5nQ0pZeFFHc2R2?=
 =?utf-8?B?NXdONjk4YnB6RWtKUmpWZkFjVUpJRFFHTXludEh1UnBPb21meTVsUWl2SDVM?=
 =?utf-8?B?UjBacE1GUE9UakIwRk5INTAxZHk0bHBVSU1FemljV1M1Z1JaQitBZXFlSjlL?=
 =?utf-8?B?UDJYbGd6YzhUaUdrTHRubldKVGd1cTNPT2dSR2Z2MkRuRmNXWWxZS2k3SGNk?=
 =?utf-8?B?enRJMmdQVVlML1ZrSG1VWmZ3M25lVEVMZ2hTaFIwcWcyaWZjek9iZWlMWEJR?=
 =?utf-8?B?TlF4ZWN5d1dTeC9KUXRpSTBQSmxSN1FYNDBBMUJkMnNzdFM0MFV3N1p4Sy9U?=
 =?utf-8?B?a2ZWSkhYMVc0UnN3ZTRtUG14NGd2dVI4Vld4Q2NKQ3NHdFpxTkdOcWlFMmhS?=
 =?utf-8?B?dy83Vy9HMXhlZmdkTWNsTWVUMmxhdW5PcnNKK1ArVGhETmJMRjEreVhURzJL?=
 =?utf-8?B?dTZZK3dqbHZxb0hrNDZZaTQzT21McHdpZG0wUEhUWmc1bzhtelZUM01FZUQy?=
 =?utf-8?B?QlR2SVBRUWZxYmxtbWFDTXV0bGVTQUEvRnZaRFJLa2s1S3ZTMUpPeU1haVBt?=
 =?utf-8?B?TmZJM2RSU2FuaS85QWg2YWpPU3hkNzRObWcxdnIyVVF2RDFZcGJGYmNnMDNW?=
 =?utf-8?B?QitFTFRmckJnN2VNRG5KUTk3d1pjQlN6NjhQKzhobFZISVh0WTk4NDVwYTB2?=
 =?utf-8?B?bmtqdWo4U3YyWlJUSGFyUnBsVEtZMVZMMUNkUmxUVXVrMm1iV0I5Wm5zS0xU?=
 =?utf-8?B?VmpkU2g1RWVlWVJJRi9wUjQ0T3BraGl5eUN2K3I3dE5YeWNGNzU2NmFjdmtQ?=
 =?utf-8?B?SjkwSUZRSmgwYzZsckVKeTZiMFZTc2g4VDgwd1hPdzREbk1nK2J2N09hV281?=
 =?utf-8?B?UW5GQmRUMnVTTVcybWhqaVlhZG1MSlBUTEZtcURFNFJob0lJaUF2V0MvTVVU?=
 =?utf-8?B?VDRyT2tnL0RYQ2ZBYXBGS2t0YWlGNGNnSzBWbTI1dXQ2bXZPKzVvT3NuUWpS?=
 =?utf-8?B?STFGakZ6RFcrelpRUEV0S3dUa0t2NGV3MXp2Zll4OW12Ulhzc3RuUllSV2Qx?=
 =?utf-8?B?STZjeGdKOUQ1WFN6U0VUdkF4T2xqdHFtS0s4VGVaZzQySitPM3QwTEduOUtQ?=
 =?utf-8?B?WUsyUGNaSzJmK2ZKLzZmZWpoa0tvb2duZFhnMUZ3bk1qK3FxVlBxOTRObzYw?=
 =?utf-8?B?N08ycUR0ZCtCNFhWa0svVWprM1N1ekEvMWE1Y2RQcVNHMVBGRG5neU1tWmtM?=
 =?utf-8?B?MVNiVEFCak9sKytpWWxvSG9TWHcyWDZsamREcG1DK0lTM1k2VWNYV3pCbFBv?=
 =?utf-8?B?c0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2338F66F85C4A149AEF808F44FDE58D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec467e59-4209-48a8-15c5-08dac24dc716
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 12:27:33.4105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RdmvUnH4x1Eea2EXQOoKXkSJyo3+yhO1sTGSKvkfX143EypN/IIjRmC00OWFGerBGL45VP+OVyvbasIb4f47yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6372
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggd2lsbCB1c2UgYSBkaWZmZXJlbnQgc2hhZG93IFBURSBlbnRyeSB2YWx1
ZSBmb3IgTU1JTyBmcm9tIFZNWC4gIEFkZA0KPiBtZW1iZXJzIHRvIGt2bV9hcmNoIGFuZCB0cmFj
ayB2YWx1ZSBmb3IgTU1JTyBwZXItVk0gaW5zdGVhZCBvZiBnbG9iYWwNCj4gdmFyaWFibGVzLiAg
QnkgdXNpbmcgdGhlIHBlci1WTSBFUFQgZW50cnkgdmFsdWUgZm9yIE1NSU8sIHRoZSBleGlzdGlu
ZyBWTVgNCj4gbG9naWMgaXMga2VwdCB3b3JraW5nLiAgVG8gdW50YW5nbGUgdGhlIGxvZ2ljIHRv
IGluaXRpYWxpemUNCj4gc2hhZG93X21taW9fYWNjZXNzX21hc2ssIGludHJvZHVjZSBhIHNlcGFy
YXRlIHNldHRlciBmdW5jdGlvbi4NCj4gDQoNCkl0J3Mgd2VpcmQgdG8gbWVudGlvbiAic2hhZG93
X21taW9fYWNjZXNzX21hc2siIGhlcmUgKGFuZCB0aGlzIGRvZXNuJ3Qgc3RhbmQNCmFueW1vcmUg
YW55d2F5IGFzIHdlIGhhdmUgY2hhbmdlZCB0byBvbmx5IG1ha2UgbW1pb192YWx1ZSBwZXItdm0p
LiAgSnVzdCBzYXkNCnNvbWV0aGluZyBsaWtlICJpbnRyb2R1Y2UgYSBzZXR0ZXIgZnVuY3Rpb24g
dG8gc2V0IG1taW9fdmFsdWUgZm9yIHRoZSBnaXZlbg0KZ3Vlc3Qgc28gdGhhdCBURFggZ3Vlc3Qg
Y2FuIG92ZXJyaWRlIGxhdGVyIi4NCg0KQWxzbywgc2VlbXMgaXQncyB3b3J0aCB0byBtZW50aW9u
IHRoZSBzYW1lIG1taW9fbWFzayBpcyB1c2VkIGZvciBib3RoIFREWCBndWVzdA0KYW5kIFZNWCBn
dWVzdCBzbyB3ZSBjYW4gc3RpbGwgdXNlIGdsb2JhbCBzaGFkb3dfbW1pb19tYXNrLg0KDQpbLi4u
XQ0KDQo+ICB2b2lkIGt2bV9tbXVfc2V0X21taW9fc3B0ZV9tYXNrKHU2NCBtbWlvX3ZhbHVlLCB1
NjQgbW1pb19tYXNrLCB1NjQgYWNjZXNzX21hc2spDQo+ICB7DQo+ICAJQlVHX09OKCh1NjQpKHVu
c2lnbmVkKWFjY2Vzc19tYXNrICE9IGFjY2Vzc19tYXNrKTsNCj4gKw0KPiAgCVdBUk5fT04obW1p
b192YWx1ZSAmIHNoYWRvd19ub25wcmVzZW50X29yX3JzdmRfbG93ZXJfZ2ZuX21hc2spOw0KDQpM
b29rcyB1bm5lY2Vzc2FyeSBjaGFuZ2UuDQoNCg0K
