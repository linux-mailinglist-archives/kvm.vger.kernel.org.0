Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3556B5EBE6F
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 11:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiI0JW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 05:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiI0JWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 05:22:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B606C558D6
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 02:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664270383; x=1695806383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uFgGo0ENe8rK37GxJEr5yZ0KsUrp9fhXW0JkBKpR94w=;
  b=M10T+FgGtKpjT5zrzARd1mgdB5LffuVr7pUP8kY3LqkwmVMQvFbuQciG
   IN2BAirRtHq//QtHiMmAD9BgcJnfHAL3+TmVWeC4B9+lS3YCoEGJ8XLn0
   C4yFmKunc9Lm3djajE/R8APG4paO8mXq8WoWwYCVqxjENgJwXcc/J/V6h
   NfrXvTJABPBbtLVSfG7sRbLXoEmj3rZUxYZTdMaBoKzDt1u+fM/Rc3sFK
   xofaUHRJ6PHYqOmpuqu99cM+Vsk+yIpaNv+YyGo0x7UopD6FuXkF9xbFh
   ftTvF1Ix8odO3K6cqDGzPd0gs6mCL6Rpz08RUvZGxfHVz+Pz4LCHSf/tn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="299987622"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="299987622"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 02:19:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="572585291"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="572585291"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 27 Sep 2022 02:19:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 02:19:41 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 02:19:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 27 Sep 2022 02:19:41 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 27 Sep 2022 02:19:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD5TsYwNv9UV7kyLF8zSsnxPSlG8Ht+WLlNIn+HO7gq7I8Bt3y9ypd9yX8k/MWtgYKzQEf/wBcWqWQ6LWOIYXYwB00rkXKBHU/miRQSBAiCnPVPIP5Lu5J4h7/Szsbk79EPYWBuDMuMDlR4mnek4gvG3tuo7Fh7LyljjTEKYR8hv4wsJQeaR1tU/YrXc9Yf9SZirzGkd09tpsqBL3eJpYxufKgfrk8RgdXk+tAbMUeB0FCguYEatt4VZUq/qss4iTAwOuq3Iwp8ITHCSn2+dl2q/nJd9ufeNq82pQ2zLOKg0jh/Rw0nHprmIZZ+XwDfeEHdLnzMVNN1VfOBNPGESuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFgGo0ENe8rK37GxJEr5yZ0KsUrp9fhXW0JkBKpR94w=;
 b=d8FdDABourSHpAboBiDbR3nqEvIgnMkVgKO99r2LSGhpCLykd8LIeCp4JcodERXKJVLVnY5ZyM3RBJTUk0VnmmVDY9xlPfVYHm9cEuSkzykSEyOAKhiYitN5ddvCJpqvJ8x+vUxiOlPF3RFyO81enYuuj8/vsYyS5s4ApQKHcWeUrxWuNSbUhQPRAPk7nnpCs2HoK5P5ASEBhZ3ZOA2h+MftN/q+rsS/QZKPg00r1l/88S7+xfHag+J6Heb09BV1B3ptKIgw619yAYehta25/d61zDy3SaphrwWSmg/EzIjcSM6D7kg2LeBOWjEEsP0OxMEqTIRwI8hKFa/T5Akwiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4869.namprd11.prod.outlook.com (2603:10b6:510:41::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Tue, 27 Sep
 2022 09:19:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 09:19:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Topic: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Index: AQHYzeClAoVSdFoVkE6IUn79IeyfMa3zCMQA
Date:   Tue, 27 Sep 2022 09:19:37 +0000
Message-ID: <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
         <20220921173546.2674386-2-dmatlack@google.com>
In-Reply-To: <20220921173546.2674386-2-dmatlack@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4869:EE_
x-ms-office365-filtering-correlation-id: 07f729b1-ef71-410c-b79e-08daa0696694
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l2+9Dvlpi20BARxpuuf4yhp/e18sEe4PwTCLRAwRvAifoDsJPKMjqTubqb5/7RYFNzBJlaackiKSGJvd8t1bsLF3pejbU9fbVG6mV354F05qhtqQuAkcBxQRW017jWs2uLoFUFoW1FNLfwZyY5uhJA17wy9T7X5QOWiYnweWYLQH0+2XQnYS8kIvbbJab0GYssbVGGTTeY4VPiKkYRQQ9mhk5jbUYUBZfOz7SdJ6xfBgpOAw4HwaYfm9irV/Jx4CyBPCyn1LR3Is/y7+E5zeMtBNRvdWta7GFfERjJdvhpmrXdqnx0GOnoD6wzlIcQVRsnHlNbai31fDAJGyh+gXUuLuPc5Zi4jawAjar4lOg0pBfmy6HEJHJZMuYj0ot4BF4y6ogPs2k/GeAzq2FBrK4tvGXfLRBJKd0tEGd2IhIjSNd848k3f7kWylNpbRe2OIMHjtbj8IA+Ug9xUKZ1lwSeqWAO7NYSm6hpMf0Iyx+iXHiIZx7Lya8Z9DXMOO8N5RQZzwIN1LxPy6VKiLEhvpVBPKey13tSBSo6RvqxH9CfVGT0o9PuuGEzKZJ3Oc/XzhHqqxtAvszWmWBcquAFsysJSnAZbH2p7TWB3v4/ucyXzqW7HzbovgPLGl9qD443w3/wSpqzF5J6mr42XjkC/DPXaXwXUBrTy786YTTjyRG8NnXiHbX40MW7E8RCf1fYnvO5kloMY0ewTkFBKEV7Alp4KUbMmq/KcoDvuyiYYumv512nJyfg8r1NyRSkQMdDBZL/AjtDChkeD+39ZEHQUy1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(396003)(39860400002)(346002)(451199015)(66476007)(86362001)(82960400001)(66446008)(64756008)(83380400001)(316002)(186003)(4326008)(38070700005)(8936002)(26005)(66556008)(6512007)(8676002)(110136005)(54906003)(36756003)(38100700002)(91956017)(5660300002)(76116006)(66946007)(2616005)(2906002)(6506007)(122000001)(71200400001)(6486002)(41300700001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Syt2a0NXUzczRS9UVG9JL0VHeTZONmI3RjZrd3hQZWxnbndCb1dZNGpwdzRk?=
 =?utf-8?B?TWg3d1RZaW51ZG05Wi9uY3VIaERYRE8zRkNDdGJQaU95d0FjQkVtdElPWHVy?=
 =?utf-8?B?WVVJcUd6Ujh0UnYwN0xsSVF3UjVpZSt0TUVHRXB2OXo3amowNnIxMkVQZkZx?=
 =?utf-8?B?N0lZZlZVdnlNcFJ6eUhpS3JHWlFxa3gxaTRRTEkvMXI3N2RYUlVyd0IvbHdK?=
 =?utf-8?B?TmYrUXgwL0tKcUlWVUhvc2piRXBKNHhud3ZaSS9QWlBqOW0yWjc1UlZzWjk2?=
 =?utf-8?B?ZW5WTUdCcldyaTFLR0RuZWFtZitBTHZJSnkwTTNibHQ4aGJBUHdhS243ZU0x?=
 =?utf-8?B?RUxXR0kvOGNGRGsvMVh5dHQ2NHZvK3RuTnZBcGZHQ2tBSWcySzNCYUtvb3NX?=
 =?utf-8?B?YWpqd050Z28ybDd0dTViYkVCNmhwUklqdDdpekhzU3FhNU5RQ0VCM042R3JO?=
 =?utf-8?B?MExFZGRadUNaYnhrOHpnN25uQ1o4TW9wbVhad0UzNUx4K3M0a2hSVzROajZB?=
 =?utf-8?B?K0l2M0Nncm0rZ1BqUEJIdHg4R1ptYU9GU2VERlNwY04wbmI4L2N4WDdJeGFs?=
 =?utf-8?B?WUhiOUNuU01LUGZIZGI1QkhsSGxvUmMremc5RjZISDdTa1Bad2lKcFhyVHZH?=
 =?utf-8?B?TnFOaVd5dFNadFVidEY5SUVvWXhHZ3IrQlF0N3c0dFltbzhKRy9tWUM0aUFZ?=
 =?utf-8?B?RGZzbE02R1lQU3pucVVLTlM2SWduemJmNWpOc0x2OVM1R2dDL2tNZ05wcVlQ?=
 =?utf-8?B?Unl1Q0djQUxvUjFKT3E0Z0dFOTI4Q2VyMUdFNkZmT2tjcjJRUFFiNFp4RnMw?=
 =?utf-8?B?M3RpZCtRSHVKUHRLdGYvai9rdWY1blBYWEl1REloNWgzVll6aTJTWFExQ3o4?=
 =?utf-8?B?V3h3VkVMUHkzUUU1ZGQyOTg1VHpxMkwvMit4K1ZlZVZaVFV6VVRoZkVhZ1ZJ?=
 =?utf-8?B?TjFYTThtY1F2WDBMLzJUWVpUc3ZoWEVvV1BWeHhqTExqVXRZWkRuaGFxRnJJ?=
 =?utf-8?B?WkVRaVdPUERoaGVEOGcxZmppbThrWktYMm5zL0plWnNXZnhZMkgzdFRERUlY?=
 =?utf-8?B?d3RsakpNdzkxTGNUamU5ZXZ0N1I1Qlg5UW5hc0w5V2xzWkpnMitYbjFVSDdY?=
 =?utf-8?B?a3puM3dwSE0vRG53S2ludnZCbzhKa3crTUtLeUlwaTR0V1RlRjhrMVFGeHNs?=
 =?utf-8?B?YkZraGNhRmR0bzQ2R1hkTFZoZzZwcHZtdXBmM091RE9MbklBcTZaMVBCRjAv?=
 =?utf-8?B?UkF0NGw1MFdkRExxZjU5b2VaVnMzcTd6SnRKd0g4RUtQOVRqbTA2RElsQ1gx?=
 =?utf-8?B?WGp6Zkh2ZW1FL3ZEcmVVcVJmRTArc1dVRHE3eUdkcldFRWc5VDN4UFdvY2Zm?=
 =?utf-8?B?anB2T0RwRFJWVis0NXhORUVyKzcxN3U1Q1N5UjFYREwxU09NUmZTWXBzWUc3?=
 =?utf-8?B?dVlBbGVxSWg2aTNIN29wZW5qWkFNT25QRWhkMm1xQnQxbm1YaGxJbys3OTRN?=
 =?utf-8?B?cWt2cWJlSmZVQjRsT240QTVjMDFieS9PM1NCQW9tY0I0OXBycUxSYXd2blE2?=
 =?utf-8?B?N3h2UWMxVnhONVJ3dzRTaTlZalJHLzF0Q0ZXYko0K2VtS293U2Q0Ri9qcThx?=
 =?utf-8?B?YjhKRUk4MUdjSURlMGZnd3d0N3NsbFJscU1NY2R1M0JoZmlIeVlZUzAxUGM0?=
 =?utf-8?B?OEV6cXZqU3B0b0Y5RnQxWHR4eGZ1dDNhT3NseEZ3TmcrOUUrdmh3bzdLeDJr?=
 =?utf-8?B?a2ZGaWg0VlVlR2lReFphTGJvRGJ4U1hNaWk0a1g5eVpXTnE4RnVIMGZzTkw0?=
 =?utf-8?B?TFdQRFhTcWhXSWcwUElNbVVFZkQra3VmREdVRTFqR0xWM1J3bHVNZGlmWHA4?=
 =?utf-8?B?SnRtbGczeVB4SzN0WmgrR01ZM3BmQUdVdFVaVkYyZzliTUhjWUJlWVA4eUhL?=
 =?utf-8?B?VFBFMHJsZTdUVGJ5SkUwc1FBNUcvTVVJN3RqYmMxazA2UGVEMkczUXhlUXZD?=
 =?utf-8?B?a2R1bHJ0ZGF1V2hENGhVSXFtNTJYVW1jWHdkRXNITzZLemZ2U0VrMUhKaERO?=
 =?utf-8?B?djBjcGpMcnoxUVlHd2pNeWxVMjBUZjU0LzBoSVR3YytORlN5RUh1ZUlSQjl2?=
 =?utf-8?B?TlpQTzQyTnFEVmhMNXc4N05yTW5INlJkUzdVbURpUUpFd1ZkY1Z3c2hVcUNp?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DFACD4E88E41F49B94A925DA0AA514C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f729b1-ef71-410c-b79e-08daa0696694
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 09:19:37.8910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jUfzhtAglMY8ZOuvl3eLyr7fsN+rZa3XQ+5NHjerSx8S+hHjWYDm+xp8gIthiLG+iQ4vw/iW5jcDNFlpxwE/pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4869
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ICANCj4gK2Jvb2wgX19yb19hZnRlcl9pbml0IHRkcF9tbXVfYWxsb3dlZDsNCj4gKw0KDQpb
Li4uXQ0KDQo+IEBAIC01NjYyLDYgKzU2NjksOSBAQCB2b2lkIGt2bV9jb25maWd1cmVfbW11KGJv
b2wgZW5hYmxlX3RkcCwgaW50IHRkcF9mb3JjZWRfcm9vdF9sZXZlbCwNCj4gIAl0ZHBfcm9vdF9s
ZXZlbCA9IHRkcF9mb3JjZWRfcm9vdF9sZXZlbDsNCj4gIAltYXhfdGRwX2xldmVsID0gdGRwX21h
eF9yb290X2xldmVsOw0KPiAgDQo+ICsjaWZkZWYgQ09ORklHX1g4Nl82NA0KPiArCXRkcF9tbXVf
ZW5hYmxlZCA9IHRkcF9tbXVfYWxsb3dlZCAmJiB0ZHBfZW5hYmxlZDsNCj4gKyNlbmRpZg0KPiAN
Cg0KWy4uLl0NCg0KPiBAQCAtNjY2MSw2ICs2NjcxLDEzIEBAIHZvaWQgX19pbml0IGt2bV9tbXVf
eDg2X21vZHVsZV9pbml0KHZvaWQpDQo+ICAJaWYgKG54X2h1Z2VfcGFnZXMgPT0gLTEpDQo+ICAJ
CV9fc2V0X254X2h1Z2VfcGFnZXMoZ2V0X254X2F1dG9fbW9kZSgpKTsNCj4gIA0KPiArCS8qDQo+
ICsJICogU25hcHNob3QgdXNlcnNwYWNlJ3MgZGVzaXJlIHRvIGVuYWJsZSB0aGUgVERQIE1NVS4g
V2hldGhlciBvciBub3QgdGhlDQo+ICsJICogVERQIE1NVSBpcyBhY3R1YWxseSBlbmFibGVkIGlz
IGRldGVybWluZWQgaW4ga3ZtX2NvbmZpZ3VyZV9tbXUoKQ0KPiArCSAqIHdoZW4gdGhlIHZlbmRv
ciBtb2R1bGUgaXMgbG9hZGVkLg0KPiArCSAqLw0KPiArCXRkcF9tbXVfYWxsb3dlZCA9IHRkcF9t
bXVfZW5hYmxlZDsNCj4gKw0KPiAgCWt2bV9tbXVfc3B0ZV9tb2R1bGVfaW5pdCgpOw0KPiAgfQ0K
PiANCg0KU29ycnkgbGFzdCB0aW1lIEkgZGlkbid0IHJldmlldyBkZWVwbHksIGJ1dCBJIGFtIHdv
bmRlcmluZyB3aHkgZG8gd2UgbmVlZA0KJ3RkcF9tbXVfYWxsb3dlZCcgYXQgYWxsPyAgVGhlIHB1
cnBvc2Ugb2YgaGF2aW5nICdhbGxvd19tbWlvX2NhY2hpbmcnIGlzIGJlY2F1c2UNCmt2bV9tbXVf
c2V0X21taW9fc3B0ZV9tYXNrKCkgaXMgY2FsbGVkIHR3aWNlLCBhbmQgJ2VuYWJsZV9tbWlvX2Nh
Y2hpbmcnIGNhbiBiZQ0KZGlzYWJsZWQgaW4gdGhlIGZpcnN0IGNhbGwsIHNvIGl0IGNhbiBiZSBh
Z2FpbnN0IHVzZXIncyBkZXNpcmUgaW4gdGhlIHNlY29uZA0KY2FsbC4gIEhvd2V2ZXIgaXQgYXBw
ZWFycyBmb3IgJ3RkcF9tbXVfZW5hYmxlZCcgd2UgZG9uJ3QgbmVlZCAndGRwX21tdV9hbGxvd2Vk
JywNCmFzIGt2bV9jb25maWd1cmVfbW11KCkgaXMgb25seSBjYWxsZWQgb25jZSBieSBWTVggb3Ig
U1ZNLCBpZiBJIHJlYWQgY29ycmVjdGx5Lg0KDQpTbywgc2hvdWxkIHdlIGp1c3QgZG8gYmVsb3cg
aW4ga3ZtX2NvbmZpZ3VyZV9tbXUoKT8NCg0KCSNpZmRlZiBDT05GSUdfWDg2XzY0DQoJaWYgKCF0
ZHBfZW5hYmxlZCkNCgkJdGRwX21tdV9lbmFibGVkID0gZmFsc2U7DQoJI2VuZGlmDQoNCg0KLS0g
DQpUaGFua3MsDQotS2FpDQoNCg0K
