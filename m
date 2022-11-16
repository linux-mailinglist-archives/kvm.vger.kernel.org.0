Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A154B62B6C7
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 10:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbiKPJml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 04:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbiKPJmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 04:42:39 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D47429CB7;
        Wed, 16 Nov 2022 01:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668591758; x=1700127758;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FiQXAQVHCclHRNTs8tnR0D671SaSAhbSbS31blw6I4E=;
  b=lK25btxZZUqbAj8zJustWFt7Xt7RD8e8mdi/h2OAO/c0YArb03S1rZiZ
   +kX7Lr+sPhrY6Vjad6km61qHZpWeoBWj7Uj1yFRqqXXb08GK/WAVXZSiZ
   2rTbO/6kHzCHGywNu8LwILVaC5Ml/8F4azvH5hFYksZPXAh1wYAv57SkR
   8WunL1DSVP1L0N+Bw2ktK/KUygGMoJLJ66SBQs4LJ8YjfOs2vve8KOgth
   GN0Fzy7mYRTPMXorvvVfXIeXDuSNdmik2hk67H1HvygNNnAcggt5KQhcQ
   Sz2LVEbU8PqhsO+z5viCYvv21XqiIR2gTeMn2x+ERTae+LZ6g/9CJCtnM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="374632440"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="374632440"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 01:42:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="590126217"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="590126217"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 16 Nov 2022 01:42:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 01:42:36 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 01:42:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 01:42:37 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 01:42:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5uIqADK3YGnNB1ESmJeWIcsbFrueDyRHPYWEm4oD6jS3g0/14kF4OQydxXYB3/qRcHd61HEK/hH0jKhT8/FVoHzCcdtg3LcHqNWb2QZRaQ2jzTYBKcRlZR0lgtrcDBbyg1za/TJcEgwpgIcog9hsFLXLRN4tziBg3dHk6wOLFxANUQaWBkW1nszjSXkKQVxGxhHlzUooI0ffx0HNwethWi5GH0KkNi1kfG6L9d7bnqSurujKWk3hQUDAkqsCZDooVEYta5rthfZuQ7z//L6hn5SrsbABbs1P+1lhGqplDM58DXJ2LOYNI6vu8Th9zzi3X6SfDs4dr1iDVG/a5Qkcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FiQXAQVHCclHRNTs8tnR0D671SaSAhbSbS31blw6I4E=;
 b=kUP1jhe5ujaikVVjZIOhpUC2cL3paiHyfWctgaLzF8eiSxxflXailSOt1aS9hFuXLNPRKHZDgsldMKV6LqdvxfnWMhqBdAgQL5Pd1d/EAe9sqU8qNWMPCHooZn191NTTIX02fRR+v4zwpseFnpyCar3gnXUZ8nHEC9khOmwbm1mQmzCxP9eXIbEE27qG8ZYdHyZy1MHDj7mQ+FHsY8anRrpo/I/dkL3INfkbaVVO9BcCOrqLKzdOPaAmWgote+KuCRbezIObqYvk0ZJf1MX62rg3bS6xI5mewfKsv8EC45Yo01YtGBoCB4JKN608sRjxeakcH8aVpWKmkUfrm07iHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB7473.namprd11.prod.outlook.com (2603:10b6:a03:4d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 09:42:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 09:42:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 041/108] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Thread-Topic: [PATCH v10 041/108] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Thread-Index: AQHY7ChzoAuKem3nhEK/F6xGG5XOk65BZy4A
Date:   Wed, 16 Nov 2022 09:42:34 +0000
Message-ID: <f9dcc09e6569b2d47c039a44bfb83c22e30365bb.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <ae532ffde75be94062f03dab8b538fa64d1dfc74.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <ae532ffde75be94062f03dab8b538fa64d1dfc74.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB7473:EE_
x-ms-office365-filtering-correlation-id: 99ffb88a-abaf-4cc0-af3d-08dac7b6e3d1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jSn4iHI8Vj8qgxmEmFXMaoemheKnk+dfIT4jFBbkaNITBRAmXTOlO4MdPdeA2P6aI3amGi/8Fz633wY8zy8dZR9bmdkiSPckkezvx4EamTdBnS/S869Z9xNVcTia8bU6kQ8cYmuv6hzchSRbAGQ6oLwcfuEaIMW2jdCjp7U/OuP0VybT6/gyr/909yFNcs8wPLgZ1+c+ZFVrgCYfFS0sqnrC0LRIeryNEL1D+dF28C+lA2c2wbb6hNH46LcL9r2TsUSbiztuXDY4v8MStf6BaXtU1WMwz/uMxBBwxnkNU4GdVSpGSoR08RIxCYstaj0fkJM4gr//l1MZOTI/xfQjXi5xmGxqx8kiVELfcSAjAFQ7a5rC4boBFKigB8CqM39aTgsA3yL4Pm38xaN4j1gYAw6Q82vpNr0Hh2SVj+BpOkDiWRTCaKOJApQEhh1wzow0bcQEACqjI+1/5/dFrF70RxJEYrigmj87grwwUyUki03R0jJm1LVDNN761czvRRuD9BUruzgmVR/QRDd/Xlg9/OpJHzOuRsP3jLcMi19iI/RRS3EQYrdQMIUnc8EF9k4GI6Akgbx34weqg7FVR9FCwm1JlnCelkTWKWWcojpbWOzOMi+LpxHJ0LEGdEbH3RRMBdP5E/ea0StFpKwcsmtDPCaZSq3jGM894e0MLSQC80AYsMg5f9nXZpCn2FyNs9/0G61E76P+34HsfypEo/TFkoW8hmrZYLzJ6AMTZ8FbOkRAaTTcP9RBYg3KcNs7BVO1qbxt+mzHwbLHT25f8PIGKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(6512007)(66446008)(4326008)(122000001)(36756003)(316002)(26005)(71200400001)(2906002)(38070700005)(54906003)(110136005)(4001150100001)(6636002)(8676002)(86362001)(82960400001)(6506007)(64756008)(66476007)(91956017)(76116006)(66946007)(478600001)(66556008)(38100700002)(6486002)(8936002)(2616005)(5660300002)(41300700001)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VS9NTEJVU0UxOVMxTng4QkFPb0JHQXFvWnpTemh4VmpsK0NzcWV2ZUUyVG5F?=
 =?utf-8?B?RDV3RHFSOG53bUJ2dXlFbmhKaHluYnpua0liQnIyM0R6RTc2dng4NS8vUnBz?=
 =?utf-8?B?a2NNUE1yM2FJKzRVQm5mVkZHR3RrNEowMTQvbVVOZFFBK01keVI4WDdQQ1Ry?=
 =?utf-8?B?cHg0WS9hU282cnVBUGVwVVcweTFhd1ZZbmJEdDlIYi9vVmNUZE9HZjRhSW8y?=
 =?utf-8?B?aE42UVk3WFhjNDNYMVVnNmxlR2dSR2c2S0FWdnFQbUdtYW83YzdLd2tMdklX?=
 =?utf-8?B?N2dYdC9CLzM0bXFrakxtbC9jVDZzTTQxQ3lhejQweUVLdHhiZVpBektLVWFI?=
 =?utf-8?B?QTl6SmpIKzBpMXpGNDRoNTlkNC9PdXBwR1hjcG5oRzZmbWNJeXdvMVFtWXdm?=
 =?utf-8?B?K2cwV1V6MDJvYW1YazlGaUw5MnQ3QlJEaktLUFdEa1BLNUlGTmg3T0lmVko0?=
 =?utf-8?B?KzM3ODlEOEk1L21ueU8rTXA5Ykp4Q0dHSk9yaWh3Mi9EN3hmRjVaMVdobUNI?=
 =?utf-8?B?dGowNXVlRHMwNk1sK05ON3JIRHBjdENFSU81c1FaMDFQTml5bDMrNFcrUlZo?=
 =?utf-8?B?ckVyVksrcmNkcExqczNiNURqa1hFSFJnc3hNd2lkTG5VRVhzT0p5WEZEcktH?=
 =?utf-8?B?Y2kweXhkOEE5dlAxd2ZxbTJXV1Y1eVZka29wRDFIalNtSHJMTHJtMHhEUFFG?=
 =?utf-8?B?TncyNi9kNUd2b1VnRHFRMGNJQVZ5eTlBSHJkeGNmN3NVbTdLZEpQdW5DdjNs?=
 =?utf-8?B?QUJaL1pGNmxkek52RkpRVmk1MmoyWWJsSFM0Z3hzeGdaR0xsWVZWZUFjSUlY?=
 =?utf-8?B?RGRMU3JDYm0vWnVHajNCYzkyMDBaZWRxb2Z2U1h4N0c5U0VmN3JKZm9PSGVh?=
 =?utf-8?B?S1lwbUhjRzJuZVFNVXUyMGZId3RTL0VoQWg0amVKQTEremZ0K0s4bi9ucGdZ?=
 =?utf-8?B?Snc2SWVLSlR0b2NHREJUNHdieHNLKys0WlEzK2tlcktKWUZSWXJIUFhsalFQ?=
 =?utf-8?B?VDNvaHpoRkRGVnRza251T2xVOWwzOFh0TDk3RjlrdGw2c0w1MHUrZExJSU9E?=
 =?utf-8?B?RGpSSTdTYWNyUU5uM0ZGZ1MrNjg4UWE3V0IxdG0yMzRZMFlla1p0V2dCSEJR?=
 =?utf-8?B?UE1LV2hMTGc3VGxEcVh4SGhwR0s1OHdDZVU3d1VBRERidXZGbzRINTBLdENE?=
 =?utf-8?B?ZXRTZnZsUXpPdVZRbFlOODg5WHpoMjAwWW9hakJwelcxd3dRSm40Zlg1R3Vj?=
 =?utf-8?B?NkN1emc2Z21QYUZZeE1KVnpaUG1ubDN3MDcyMFlNb2lhYk54eU11bnFkTTZ5?=
 =?utf-8?B?UlVIaWsxNitPWWo5UXQ4WkJQQ0p3VFEyVUlOdEs5ZkRzdjVPaTRIY0lyR1hZ?=
 =?utf-8?B?eXVtSWJNYkUrNHJ5NW5CTFBhZkNwOHp3Y014VHZGSXlOSDlFUWJIdk1xc3Bx?=
 =?utf-8?B?U2tEdWxwdFJBell3NjlobCtCQm40c09oK3dydUhCV04vMHQ0Si9LUmRwMXg0?=
 =?utf-8?B?RG84c3d4WlNGUUVWc1ViSENDcEw3aUpjNThQUFNhbU9yTWlGcHFwYzNyaWd4?=
 =?utf-8?B?TXRjQmhRRDlUd1M1SzB2SEJpSUYwRFJtdjFteXR1TGhzTVBYVHdmTkNiZ2sv?=
 =?utf-8?B?MHJScm92bExFL01nbUFIVVNOT2grZHBpbGxFSmZ4WGdCNDVoTzRiQ1Q1R3dp?=
 =?utf-8?B?TFFMWlJXZlJNc3JoaVJxTWtsYktoeGZUTjNxdGZ1VVNHdTI1amRiNzM4aUdU?=
 =?utf-8?B?eXJKOEhrcnZNd3dwRUpoV3ZvRE1xZVNqZ21CVU5xaDFRKzlUT3dGcVZjaGFG?=
 =?utf-8?B?MktWNnZKWmE3MTBYc0tGZ21nd2RsMVh4TFVRZitDMEtJMHlEUzBRdmpNZGZP?=
 =?utf-8?B?dEowVjRzbGh2OFZZMkZOenVDK1BxZXdxazcwQ05nWFBpMjFCbXBkUW5rbEJ3?=
 =?utf-8?B?bE93ZXZhSTR3ek03SGVjNWd6MFd2emJLdE5VVjRyVUgzZnRWMkZnWDJEVHcw?=
 =?utf-8?B?Y3BjcVBlaVBCbHNzRUwxYklxRWs3K0ozd053WElMWi9RQkV2TVQ2S2M4Sk5Z?=
 =?utf-8?B?LzdvYjZ5eUY2aHdGN2p0TVpnOGkyWndaVy85Sy9uQ0lTR3hXOW9uSUp0Zmta?=
 =?utf-8?B?YmIwSjRhMXFVeG5pZ09xRndwTmQ0SmhLbTRDRmpsMUNTSW5iMnNwRkVxeUVV?=
 =?utf-8?B?T3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <524723D6DBF39B4CBDB0DDF164D40F53@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ffb88a-abaf-4cc0-af3d-08dac7b6e3d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 09:42:34.6179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NTnoFaMLuylDAztU9MVj+anKlN2isSk6g5Y2z0TCX1HUZSpgmFKM9oZa9QwgO3ywU+Kz2WS21mHhNN6flWBYcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7473
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBGYWN0b3Igb3V0IG5vbi1sZWFmIFNQVEUgcG9wdWxhdGlvbiBsb2dpYyBmcm9t
IGt2bV90ZHBfbW11X21hcCgpLiAgTWFwR1BBDQo+IGh5cGVyY2FsbCBuZWVkcyB0byBwb3B1bGF0
ZSBub24tbGVhZiBTUFRFIHRvIHJlY29yZCB3aGljaCBHUEEsIHByaXZhdGUgb3INCj4gc2hhcmVk
LCBpcyBhbGxvd2VkIGluIHRoZSBsZWFmIEVQVCBlbnRyeS4NCg0KSXMgdGhpcyBwYXRjaCBzdGls
bCB2YWxpZC9uZWVkZWQgc2luY2UgeW91IGhhdmUgY2hhbmdlZCB0byB1c2UgWEFycmF5IHRvIHN0
b3JlDQp3aGV0aGVyIEdGTiBpcyBwcml2YXRlIG9yIHNoYXJlZD8NCg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbT4NCj4gLS0tDQo+
ICBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyB8IDI2ICsrKysrKysrKysrKysrKysrKystLS0t
LS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyBiL2FyY2gveDg2
L2t2bS9tbXUvdGRwX21tdS5jDQo+IGluZGV4IDMzMjU2MzNiMWNiNS4uMTFiMGVjOGFlYmUyIDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiArKysgYi9hcmNoL3g4
Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiBAQCAtMTE1Nyw2ICsxMTU3LDI0IEBAIHN0YXRpYyBpbnQg
dGRwX21tdV9saW5rX3NwKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHRkcF9pdGVyICppdGVyLA0K
PiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgaW50IHRkcF9tbXVfcG9wdWxhdGVf
bm9ubGVhZihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCB0ZHBfaXRlciAqaXRlciwNCj4g
KwkJCQkgICAgYm9vbCBhY2NvdW50X254KQ0KPiArew0KPiArCXN0cnVjdCBrdm1fbW11X3BhZ2Ug
KnNwOw0KPiArCWludCByZXQ7DQo+ICsNCj4gKwlLVk1fQlVHX09OKGlzX3NoYWRvd19wcmVzZW50
X3B0ZShpdGVyLT5vbGRfc3B0ZSksIHZjcHUtPmt2bSk7DQo+ICsJS1ZNX0JVR19PTihpc19yZW1v
dmVkX3NwdGUoaXRlci0+b2xkX3NwdGUpLCB2Y3B1LT5rdm0pOw0KPiArDQo+ICsJc3AgPSB0ZHBf
bW11X2FsbG9jX3NwKHZjcHUpOw0KPiArCXRkcF9tbXVfaW5pdF9jaGlsZF9zcChzcCwgaXRlcik7
DQo+ICsNCj4gKwlyZXQgPSB0ZHBfbW11X2xpbmtfc3AodmNwdS0+a3ZtLCBpdGVyLCBzcCwgYWNj
b3VudF9ueCwgdHJ1ZSk7DQo+ICsJaWYgKHJldCkNCj4gKwkJdGRwX21tdV9mcmVlX3NwKHNwKTsN
Cj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0KPiArDQo+ICAvKg0KPiAgICogSGFuZGxlIGEgVERQIHBh
Z2UgZmF1bHQgKE5QVC9FUFQgdmlvbGF0aW9uL21pc2NvbmZpZ3VyYXRpb24pIGJ5IGluc3RhbGxp
bmcNCj4gICAqIHBhZ2UgdGFibGVzIGFuZCBTUFRFcyB0byB0cmFuc2xhdGUgdGhlIGZhdWx0aW5n
IGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3MuDQo+IEBAIC0xMTY1LDcgKzExODMsNiBAQCBpbnQga3Zt
X3RkcF9tbXVfbWFwKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9wYWdlX2ZhdWx0
ICpmYXVsdCkNCj4gIHsNCj4gIAlzdHJ1Y3Qga3ZtX21tdSAqbW11ID0gdmNwdS0+YXJjaC5tbXU7
DQo+ICAJc3RydWN0IHRkcF9pdGVyIGl0ZXI7DQo+IC0Jc3RydWN0IGt2bV9tbXVfcGFnZSAqc3A7
DQo+ICAJaW50IHJldDsNCj4gIA0KPiAgCWt2bV9tbXVfaHVnZXBhZ2VfYWRqdXN0KHZjcHUsIGZh
dWx0KTsNCj4gQEAgLTEyMTEsMTMgKzEyMjgsOCBAQCBpbnQga3ZtX3RkcF9tbXVfbWFwKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpmYXVsdCkNCj4gIAkJCWlm
IChpc19yZW1vdmVkX3NwdGUoaXRlci5vbGRfc3B0ZSkpDQo+ICAJCQkJYnJlYWs7DQo+ICANCj4g
LQkJCXNwID0gdGRwX21tdV9hbGxvY19zcCh2Y3B1KTsNCj4gLQkJCXRkcF9tbXVfaW5pdF9jaGls
ZF9zcChzcCwgJml0ZXIpOw0KPiAtDQo+IC0JCQlpZiAodGRwX21tdV9saW5rX3NwKHZjcHUtPmt2
bSwgJml0ZXIsIHNwLCBhY2NvdW50X254LCB0cnVlKSkgew0KPiAtCQkJCXRkcF9tbXVfZnJlZV9z
cChzcCk7DQo+ICsJCQlpZiAodGRwX21tdV9wb3B1bGF0ZV9ub25sZWFmKHZjcHUsICZpdGVyLCBh
Y2NvdW50X254KSkNCj4gIAkJCQlicmVhazsNCj4gLQkJCX0NCj4gIAkJfQ0KPiAgCX0NCj4gIA0K
DQo=
