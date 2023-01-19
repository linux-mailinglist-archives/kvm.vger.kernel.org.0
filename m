Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5576736DF
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjASLbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjASLbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:31:15 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E0974967;
        Thu, 19 Jan 2023 03:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674127874; x=1705663874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ATXCi3J2GJcUVe8vSSNM0VG1gHWy6EDzU8+SQNjBEOs=;
  b=HhsV6dVAz9JIj3DBIr2bORRHJav40KcSJu8KLYdwm8Uzzd3DSZx8+4wq
   l4TXaK/Lo+XQoMioRdl6xVLuwyniBTQBfEG+rNk09TS5msy27PrpIxZwk
   4EtX2B02HDbPxNKagQH8Nnt/KXhtGt4KztAIgxPRStPXJgYHVZo/7HZJg
   3SquGmP5Ws0NRelZh/gjq2D5Nbf8b29A1rwr1nYT/oo0SfihWrHNz8pxT
   +BSPCfPMsg9SE18h9nrfZNjbbfjOr7298HFaI4OrLWI2mdK7B15CdTRuy
   kxTKBLYYDK/nSRc6fcNW1sVhHVMxgJfzFNNJ94h+Q0tFIP8yAqV++P8KQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="313135448"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="313135448"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 03:31:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="662083095"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="662083095"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jan 2023 03:31:13 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 03:31:12 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 03:31:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 03:31:12 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 03:31:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+foG0S3y+9N10wHcgBtauA2PwJF14NtJKhDSxGbO3cpRIwE7lsSKPo8Xh9rUC+6CLbNLD0aWRM+MbUoNYJfwS/FVntkZdiTROgcDB5X/w3fIvfr/eNMW5BUvbY1clQ6sDaObYZJHJrqmZD0CcHhabBCrQ/mMkv3xklVmLDyMt7r3tV5MOGNNjVjzjCSZZm+SjbRUboneezh1UTU/LefTBQoIC96U7dk2ze8pAr0IuApmvo9RKNYkbK3YKwiVgCTzpCW4ApbvrB5tc0tq3Sicz6qs1KDUw+NJ3cA2pIOSY8VdS6xi9MbFRrcKz9uoDjBdZrr1LKRvewp5f0MxSllNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATXCi3J2GJcUVe8vSSNM0VG1gHWy6EDzU8+SQNjBEOs=;
 b=oPJyoaY9DRkkak8K9BRCny12Gz6k2npKMAJR0jjX645I6VYPgJ6DkYZav4svCayggxpgPGyUsV9/NKFABCnZsvOl1Q9i1aRgHU/7KIPJkAeaFTZo+9P2BkJ1MJ+HPFJSr3+bOu1+B+bno+R3uisQsgH9rO173XSUPJ0o/Vc8IKkiDjER+S3YzjgxyGyh45YsSVeMKwjftNpyr6qHpRGM2F5MOcfV3dPlcSbGfhHdgIxQBQY03uVwkQa3XsLDu2YPqiJXLhHmEbFwZswzszHb5sD29DtiBbFzuLPgYDu0jrS1PSnEPQJ6g23rhB/zeIAYgGIWEey5F8AkC/YM9//xXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6122.namprd11.prod.outlook.com (2603:10b6:208:3ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 11:31:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 11:31:07 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoA=
Date:   Thu, 19 Jan 2023 11:31:07 +0000
Message-ID: <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
         <20230113151258.00006a6d@gmail.com> <Y8F1uPsW56fVdhmC@google.com>
         <20230114111621.00001840@gmail.com> <Y8bFCb+rs25dKcMY@google.com>
         <20230117214414.00003229@gmail.com> <Y8cLcY12zDWqO8nd@google.com>
         <Y8cMnjHFNIFaoX27@google.com>
In-Reply-To: <Y8cMnjHFNIFaoX27@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6122:EE_
x-ms-office365-filtering-correlation-id: 84098d1f-a2ba-4662-156e-08dafa10a82f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lK0feC7RGv+j4rKygM1/G7Q8o6B7otcK6Qk2ZoRt+v9WirrNhhUAwSAO1J8MqYIkhkIbdwRFYJLjMElj0XxK58jF8xvCqCXpUXrZuNeo0cYFber0gUINPr+smLUUHlKcJiBkFbde2il8gFw6sgkK/Bqq2sPYGtIItDV1f2No4RI/WkKwgs9424B+AuXNG3FluBAZC7l9Ki7iPfgKWgcOpEAuwwbFhmAV2d6wyoNSqWrXeX1CkBiWTvzbeWcmYxiGHaZ0Nj0J4AnKKAKqmY+hSRGR0ZVigMksl/5R/JrZ47jrusR+4jgv+A+uuArQLtD5L2DKfVUqgK5CRQ8oG7NQNGrUUY80wdCq86sDuOwS1kca3tLa1V1B7HP9edLRXwH5uMhmtik/DJx4m3z6wDRPCJGJPzvzw77KanbsX4Xo9dBAqg9zVHAegrJAVFX5F+Qr14Lkqm3W5gi9VWkGbWTeV5Z75IXCuElnYzqKZJsOn8i7kQVVb3VEdX7OJ5g+OShT+49eIbE8eHAZjW4aUUlc47MiGID7+Atp3U0MtY4eNznTYquFHz0luQaqT8acQagUjvcsOIW1qIdLwypRAO6tFtjP8M6DilxrVgQR44rQp9943E++h/bEAFd9ucxRbSipW5G8XjsJfOsxo6xuh6Q0DkOrhIh8Mv5WkEMVCXhN5RTs5SYJ8rmaw4YOu2jS/nlfXM92CFYwjZh0UfVgcJo+mA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199015)(110136005)(54906003)(316002)(122000001)(82960400001)(2616005)(4326008)(5660300002)(8936002)(38100700002)(41300700001)(186003)(6512007)(8676002)(36756003)(26005)(83380400001)(66446008)(64756008)(76116006)(66946007)(66556008)(66476007)(91956017)(38070700005)(86362001)(2906002)(6486002)(6506007)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVV0Ukd0elBaSE5KZVEvUkw5aVhTc3cwdlFnSForbFVRV3g2aVVuYWlqbFNO?=
 =?utf-8?B?Q2czVnNqdHlNcGZ1dUdJQXFuY053M0FQVWU5NU81OVdtTXRtVzlSOXFwM3Va?=
 =?utf-8?B?MzFFVmovTDlKZ3JuK1FQZzRHZ3RtKzBneDJaWkVTelNYNHlaL2REazUra2l2?=
 =?utf-8?B?azRjUUVMZXRNZE1SNWVGQWFHUEc0eThqTEV4WnN0NzZkMUxMQ201SUk2eFFF?=
 =?utf-8?B?b1pET2swcVF3VGx4VC9BTnY4Zk9od0c2N0dLR0ZlcURTYklVdTlscHVqK0pU?=
 =?utf-8?B?VVJQZUhHQ3Q4ejBaY3doQ3lsbnMvYTFhMFhrUEtsMHpTM3JkdnFtK3hTYlI5?=
 =?utf-8?B?L1Y2eGg1dng4TGZjYUM4aklDT2E3RDJpWWd1am5oRjZkQjNCVStUdGJSNVE0?=
 =?utf-8?B?R2kybDJkczhyc0RPbThBZEY0MllhTmFmVDBmbzNYUXlPRUxySUlMWC83b2tC?=
 =?utf-8?B?NFlVMUdhMHdJQTJ5aDhNbEtOdklvUGpBc2FTWDlzWmcrWU9Yb0xJMEtPdXht?=
 =?utf-8?B?M3RxZG1NYlpwVXg3ZlpURDRSNVRsU2h4aElualVYajBvb1ZWVFJTcEl0K21i?=
 =?utf-8?B?ZFBQZUFBUmZTd1hkY1RYbUhQbHVLMkN3cDNtazVRMFExSDdENVg3bW1tZzNQ?=
 =?utf-8?B?bVZublRXN3EyYysrY0U3Sk8xdDhuQzlzaWlOWU1walhwU0xIOXpaNnRobVIv?=
 =?utf-8?B?R25ZMmhWSFZsUE1Xb283MFlRelBMY0JLbS8rekE5bGRKQzB0MGM4VTFjeUVL?=
 =?utf-8?B?bGZ5WkN3dVlEYjYzSmVad1IxRlBldEl2QkVFVmpGUlgzOE0rTGRRNk81VHZv?=
 =?utf-8?B?NDlyajNwZHpmc1MvSXA1U2lqckpSZnpyVWxFcW5pWjNKeUdxOW5rOVJmWDc2?=
 =?utf-8?B?ZXdZMGQ3UTJvaXVkWVh2QkxHMVlWWXJIc0xiMGlPQktuSFhQZGxHUStCVisx?=
 =?utf-8?B?TzhNVThKdEk0QVJSQ1k1Y3Fla3c3SkxhUHlvS2Exb2o2cWtBang1N2xSRU4w?=
 =?utf-8?B?QktIeXduaTJnbkJhYlNJRlFhOVVPc0E0cys3QXhPQUJlcFlsaXpLN25TUDM3?=
 =?utf-8?B?MzF0Rm1KTk9pM0pwcHRpekczeVhCQi9ISzM4c0JmSHU4RnBHNHZFMnhjT3h2?=
 =?utf-8?B?OUxYZ0tFNWwveWV6ci9MdDdlTnI2ejllWjgvTUNqT0dUZnk2OXRaQ2Uzei9C?=
 =?utf-8?B?VXUwNXVEcUo2MHR3V0FOR09GRXkxTUs3VFdiZ3pIK21pU25BRENDd1pJTmR3?=
 =?utf-8?B?bDBLNjNEcnZVOEFPdnFQdVh4ZWZsMWc0RXdRL0xHSzVpMEVxS2NYNnhGU0VU?=
 =?utf-8?B?eFJPYk01ZFhzVjF2T0xJMmkxZUxNMWkrYVNCMThvWnpSOVNkNERwaG9ZUkVl?=
 =?utf-8?B?aE50Q2l3K0RxVXlkZUR3ODVvb0tyZWIwVEZvRWdvN0V2ZWNRNGdSMXpvTEsz?=
 =?utf-8?B?RGtHS1RmT2tNMC9yazlOb3lrbS9IdkE4MGdUSWhuSXNORElhT2lEbDlnZ1Av?=
 =?utf-8?B?ays2R2lydzEvaWQ3bFZwWmhSRFNtdTRHNUZpYnFCR1UzM256Y2UwMUtiREdr?=
 =?utf-8?B?K1NQSWFlT0I1c0JWY081Wm9zMEZsc1BMQkNSczRNOXRNVjVSUDJ6UWxVY2Ji?=
 =?utf-8?B?ZHV1MGcvUVEwOEhmalJ5cGgzNGt4RG9ZaEgwbFZ2RkZUY2RSbDArVUNVVlgv?=
 =?utf-8?B?YlN5dVFiaXlBck5JZUFUaTM0c3JKNWVWc2VtQVJ6bGFuMnRUZUNSSEJqc3FK?=
 =?utf-8?B?Z0VOaFpPNmVkbUtYRTk4empvYjVYK3FCMVNFc3pINkNlaEJvN3Q4R2xrNnNF?=
 =?utf-8?B?bGJ6VkVCOFkwb1dIMlZCdFZqYzZJZDh2My9FU0Vvd3h2SFRPckNESnk3NFRB?=
 =?utf-8?B?QXR5eDRYa0lLd0Z2UTcxM1FYT2lJY3JuUkE3eFhIYUxHVUJJSWRINmJMdGd3?=
 =?utf-8?B?aVo1aWVQYlpQK2M2Nk5vQTJpdGZ4Sm12REEzNHhJZ0kzQ0FlR3BibFJXOVh5?=
 =?utf-8?B?U28wUjNMNVhlMkwvWVY1Nndmdy95azFkdk42SVh1RmlNUkdoTUtDNWhiSjNu?=
 =?utf-8?B?QmZ0cXpuV3NmMk1KU2xpS2t1NGQ5d2dZVmI0MlpsZExkN0hFY3VyWFJpeGR4?=
 =?utf-8?B?RVFlSGhydTM2TFZoKzNUVFByYjZCRHR1cGpKcFNENEc1NTIwQUtMRTFIUUY3?=
 =?utf-8?B?aEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40EDF5036D0F0341A969F282C1C02960@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84098d1f-a2ba-4662-156e-08dafa10a82f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 11:31:07.4268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hf5YEQ0aCUrfTn4425p+m/pbfXg3edtvKpxk7MlFh0OHQe2EgyPs8tkbnVn1PuEVdUnfAUHLyo17AM50dT0HTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6122
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTE3IGF0IDIxOjAxICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEphbiAxNywgMjAyMywgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiBPbiBUdWUsIEphbiAxNywgMjAyMywgWmhpIFdhbmcgd3JvdGU6DQo+ID4gPiAyKSBBcyBU
RFggbW9kdWxlIGRvZXNuJ3QgcHJvdmlkZSBjb250ZW50aW9uLWFuZC13YWl0LCBJIGd1ZXNzIHRo
ZSBmb2xsb3dpbmcNCj4gPiA+IGFwcHJvYWNoIG1pZ2h0IGhhdmUgYmVlbiBkaXNjdXNzZWQgd2hl
biBkZXNpZ25pbmcgdGhpcyAicmV0cnkiLg0KPiA+ID4gDQo+ID4gPiBLRVJORUwgICAgICAgICAg
ICAgICAgICAgICAgICAgIFREWCBNT0RVTEUNCj4gPiA+IA0KPiA+ID4gU0VBTUNBTEwgQSAgIC0+
ICAgICAgICAgICAgICAgICBQQVRIIEE6IFRha2luZyBsb2Nrcw0KPiA+ID4gDQo+ID4gPiBTRUFN
Q0FMTCBCICAgLT4gICAgICAgICAgICAgICAgIFBBVEggQjogQ29udGVudGlvbiBvbiBhIGxvY2sN
Cj4gPiA+IA0KPiA+ID4gICAgICAgICAgICAgIDwtICAgICAgICAgICAgICAgICBSZXR1cm4gIm9w
ZXJhbmQgYnVzeSINCj4gPiA+IA0KPiA+ID4gU0VBTUNBTEwgQiAgIC18DQo+ID4gPiAgICAgICAg
ICAgICAgIHwgIDwtIFdhaXQgb24gYSBrZXJuZWwgd2FpdHF1ZXVlDQo+ID4gPiBTRUFNQ0FMTCBC
ICA8LXwNCj4gPiA+IA0KPiA+ID4gU0VBTUNBTEwgQSAgIDwtICAgICAgICAgICAgICAgICBQQVRI
IEE6IFJldHVybg0KPiA+ID4gDQo+ID4gPiBTRUFNQ0FMTCBBICAgLXwNCj4gPiA+ICAgICAgICAg
ICAgICAgfCAgPC0gV2FrZSB1cCB0aGUgd2FpdHF1ZXVlDQo+ID4gPiBTRU1BQ0FMTCBBICA8LXwg
DQo+ID4gPiANCj4gPiA+IFNFQU1DQUxMIEIgIC0+ICAgICAgICAgICAgICAgICAgUEFUSCBCOiBU
YWtpbmcgdGhlIGxvY2tzDQo+ID4gPiAuLi4NCj4gPiA+IA0KPiA+ID4gV2h5IG5vdCB0aGlzIHNj
aGVtZSB3YXNuJ3QgY2hvc2VuPw0KPiA+IA0KPiA+IEFGQUlLLCBJIGRvbid0IHRoaW5rIGEgd2Fp
dHF1ZXVlIGFwcHJvYWNoIGFzIGV2ZXIgYmVlbiBkaXNjdXNzZWQgcHVibGljbHkuICBJbnRlbA0K
PiA+IG1heSBoYXZlIGNvbnNpZGVyZWQgdGhlIGlkZWEgaW50ZXJuYWxseSwgYnV0IEkgZG9uJ3Qg
cmVjYWxsIGFueXRoaW5nIGJlaW5nIHByb3Bvc2VkDQo+ID4gcHVibGljYWxseSAodGhvdWdoIGl0
J3MgZW50aXJlbHkgcG9zc2libGUgSSBqdXN0IG1pc3NlZCB0aGUgZGlzY3Vzc2lvbikuDQo+ID4g
DQo+ID4gQW53YXlzLCBJIGRvbid0IHRoaW5rIGEgd2FpdHF1ZXVlIHdvdWxkIGJlIGEgZ29vZCBm
aXQsIGF0IGxlYXN0IG5vdCBmb3IgUy1FUFQNCj4gPiBtYW5hZ2VtZW50LCB3aGljaCBBRkFJQ1Qg
aXMgdGhlIG9ubHkgc2NlbmFyaW8gd2hlcmUgS1ZNIGRvZXMgdGhlIGFyYml0cmFyeSAicmV0cnkN
Cj4gPiBYIHRpbWVzIGFuZCBob3BlIHRoaW5ncyB3b3JrIi4gIElmIHRoZSBjb250ZW50aW9uIG9j
Y3VycyBkdWUgdG8gdGhlIFREWCBNb2R1bGUNCj4gPiB0YWtpbmcgYW4gUy1FUFQgbG9jayBpbiBW
TS1FbnRlciwgdGhlbiBLVk0gd29uJ3QgZ2V0IGEgY2hhbmNlIHRvIGRvIHRoZSAiV2FrZSB1cA0K
PiA+IHRoZSB3YWl0cXVldWUiIGFjdGlvbiB1bnRpbCB0aGUgbmV4dCBWTS1FeGl0LCB3aGljaCBJ
SVVDIGlzIHdlbGwgYWZ0ZXIgdGhlIFREWA0KPiA+IE1vZHVsZSBkcm9wcyB0aGUgUy1FUFQgbG9j
ay4gIEluIG90aGVyIHdvcmRzLCBpbW1lZGlhdGVseSByZXRyeWluZyBhbmQgdGhlbiBwdW50aW5n
DQo+ID4gdGhlIHByb2JsZW0gZnVydGhlciB1cCB0aGUgc3RhY2sgaW4gS1ZNIGRvZXMgc2VlbSB0
byBiZSB0aGUgbGVhc3QgYXdmdWwgInNvbHV0aW9uIg0KPiA+IGlmIHRoZXJlJ3MgY29udGVudGlv
bi4NCj4gDQo+IE9oLCB0aGUgb3RoZXIgaW1wb3J0YW50IHBpZWNlIEkgZm9yZ290IHRvIG1lbnRp
b24gaXMgdGhhdCBkcm9wcGluZyBtbXVfbG9jayBkZWVwDQo+IGluIEtWTSdzIE1NVSBpbiBvcmRl
ciB0byB3YWl0IGlzbid0IGFsd2F5cyBhbiBvcHRpb24uICBNb3N0IGZsb3dzIHdvdWxkIHBsYXkg
bmljZQ0KPiB3aXRoIGRyb3BwaW5nIG1tdV9sb2NrIGFuZCBzbGVlcGluZywgYnV0IHNvbWUgcGF0
aHMsIGUuZy4gZnJvbSB0aGUgbW11X25vdGlmaWVyLA0KPiAoY29uZGl0aW9uYWxseSkgZGlzYWxs
b3cgc2xlZXBpbmcuDQoNCkNvdWxkIHdlIGRvIHNvbWV0aGluZyBzaW1pbGFyIHRvIHRkcF9tbXVf
aXRlcl9jb25kX3Jlc2NoZWQoKSBidXQgbm90IHNpbXBsZSBidXN5DQpyZXRyeWluZyAiWCB0aW1l
cyIsICBhdCBsZWFzdCBhdCB0aG9zZSBwYXRocyB0aGF0IGNhbiByZWxlYXNlIG1tdV9sb2NrKCk/
IA0KQmFzaWNhbGx5IHdlIHRyZWF0IFREWF9PUEVSQU5EX0JVU1kgYXMgc2VhbWNhbGxfbmVlZGJy
ZWFrKCksIHNpbWlsYXIgdG8NCnJ3bG9ja19uZWVkYnJlYWsoKS4gIEkgaGF2ZW4ndCB0aG91Z2h0
IGFib3V0IGRldGFpbHMgdGhvdWdoLg0K
