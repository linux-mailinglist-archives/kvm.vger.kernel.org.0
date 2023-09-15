Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074F27A23A9
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 18:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbjIOQgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 12:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbjIOQfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 12:35:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD33AC;
        Fri, 15 Sep 2023 09:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694795750; x=1726331750;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ID7wNGDZkCxxcjpCTmsjWGU3EG5RGus6pg6hT3fEYYc=;
  b=RlXViOERTcTtQxsm298/XXsxnQkscQl6Pn/rp+IbWCgHOYHHJVMqMhzb
   kINoHsLAE0zeOaXHbS/+RS7aSJRes5MwveamuMg+/ExLttZ0ltELWaKlm
   fsEBtKucXu816GIWi2Ew/Xm7sdoXQ65UfUNi6h+roDSO8KXVA7RauLTCT
   1vwfOP+hKsXURv8vEaD+FFOFdCrO2Jbn9ZrgAkVAi57HeUKK5HSKAJKaQ
   M+d8MHgKSWkkTnGEgID9dZzEa1wV8BXUFaq4ZCc4vuz4PO8x0ugbq52xS
   J1kf9gqWYo3lQAbDqohfxuh3URt8cp6si39E2MgVTPwcIszwLpyw8RSCF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="383115912"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="383115912"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 09:35:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="721748366"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="721748366"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Sep 2023 09:35:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 09:35:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 09:35:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 15 Sep 2023 09:35:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 15 Sep 2023 09:35:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PglBzWj32allUaTo4m+iGZg7DRbMxTMbZ17c+dF9dJXo/0Ud92SL82tHmnAoOknIOhTDIXdMrWM60j//nS2SUdj6v/avyijfaB1TRDEaR5Z9iRMJ3fe/m7XI4pNfzRasT9BqQ3YyjvO/vqkl3MA/3XT24uDRK0Pny/6dLQfdWfHjX0hljW3DXRTHqO4veT4QrikFK82p+HXAyHON8Bevgt4c9wLN+adSQGktL5Cg8DP+8zXpAe+qzpseQNfp8ZasdvsvVXTHcKrRLVmhlQKNNEeN9tHF7rLdEVXBIBmuBfgE3hSTHnTpx18pnNjAKqnWzXAf2uYks8ByJhcGfp6PfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ID7wNGDZkCxxcjpCTmsjWGU3EG5RGus6pg6hT3fEYYc=;
 b=WH9VzimEiTXk/uQa+5o2XTLROLCb6jbbHP+TYXtjtZ5Bu+GLDoWjof9JTIPF/TdX5jvS5meFAC2HaWDvzksNLIPP9XAk7dRbjeJWoLNPhgVdWcl1odxp+r2Q5bWI0mt2cGlshHyZcu9QGaCYKiJvtpDXoc00+FvVvX9MLn9Vqwvy5Arfzx8NZgahD1VeuIminPDIs1wtNX5in0wqe9B6F/WlI0/9BYptXHGBL02fWab0Luuy9cLB/qE+7Fh6jub5eJW6DtZyp1aVCmxAzs5EfbKs8Cz2JetNNiQTKoe/c0kWsyrdrSG6tnTn0GzCgOCp31jmRU0NHKO3RmrAngOCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5180.namprd11.prod.outlook.com (2603:10b6:806:fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 15 Sep
 2023 16:35:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 16:35:04 +0000
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
Subject: Re: [PATCH v6 01/25] x86/fpu/xstate: Manually check and add
 XFEATURE_CET_USER xstate bit
Thread-Topic: [PATCH v6 01/25] x86/fpu/xstate: Manually check and add
 XFEATURE_CET_USER xstate bit
Thread-Index: AQHZ5u9Bdqx57z4B2UWlkM8Jq2LRNrAa6t8AgABBFwCAAOtSgA==
Date:   Fri, 15 Sep 2023 16:35:04 +0000
Message-ID: <c91f6e5885b8d052b0a1d96d0ccc5a479d9f2b69.camel@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
         <20230914063325.85503-2-weijiang.yang@intel.com>
         <868ea527d82f8b9ab7360663db0ef42e6900dc87.camel@intel.com>
         <8307c089-cff5-db41-5248-7e0f2801143f@intel.com>
In-Reply-To: <8307c089-cff5-db41-5248-7e0f2801143f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5180:EE_
x-ms-office365-filtering-correlation-id: d1342287-28c4-4c09-e9fc-08dbb609b6ff
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 74etqgrMizOWChdYWErukbZEGxaqU0eI3G5c0WkNQsoYJ+YoL5l/f6gqABFEqfM4+dtAiDD27Q/wf0/kQa0ZXdoa1t8wCQmMiaAqwzmfGte/LYzwXxrB5C/m8GFRB/oqXFia4h1o8MR1agWWjOOLCjmZBbZLmn0AGrYTHZz6VIvIFwPZap4430LpbfOvW8rH+2KTw+mCnxbUhKOzxiB8BlwyvAhDEckd2wxDQ49cvICN9uyGJoMbkbHqpf6IGLfYLdjW2dhIj408oXG3PGo4KhePxBiuSvj2Hk1rT//CmLnKp9NXurOIDUYNI39S7LqkrSO+66yRJ3BTj5ZSRDBaOoh6OhTO+xItuODEIeMNmpbqh6F6xrJfL1L6k4L0FBDfGb9Jqr3yj5o7Ht4ITD86gxJwqC3FHuSOUjdkpyE5X81jqkraLevF2mU40NjLahNnKacdHQqzEFOnkD0RL3blOxg07mul5lx7l6OI/QucUtGTG3Ek4ohvENnt41jBJw9LgHNqQ6Jb1PHreU5bUVENiPzG5mEeZ7ORBqImf6mbd6frH+VMFjUnIcZ1pnZouwc4hWs5p+FbTBIMyp50A1vZ+sT9sqpQW2wEKdMw49Y4iT5TiZgmeNpMpUX7wGBNbahk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(136003)(376002)(396003)(186009)(1800799009)(451199024)(110136005)(316002)(91956017)(76116006)(66446008)(66946007)(66476007)(66556008)(64756008)(54906003)(41300700001)(478600001)(71200400001)(122000001)(38070700005)(38100700002)(82960400001)(4744005)(2906002)(86362001)(36756003)(5660300002)(8676002)(4326008)(8936002)(26005)(2616005)(6506007)(6486002)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aW9aL1k2M1pDR3NWckU3elNFd0Ixb2xjSWE1WnkwVkpIZXUxVUJnckorcmJ2?=
 =?utf-8?B?TWMrTEplNy9YZ3dYdzZJNnVtaTFIN3FvWmJJTUZDMW5INXVINGIzSzRjY2FZ?=
 =?utf-8?B?ZkRYanVQcHRRWThGKzNkaDB4enU0UWpQVUVORG5BUFRlZVJiZDJYdVlKdnV0?=
 =?utf-8?B?c3ZMT3FnWW10d0w0R0ZXb2tjbFZ5bzFzbzZXbkRmTVAzUnNIUHpzMGlReXVE?=
 =?utf-8?B?TE5jcUdpRWRnb2dMa1dGam1TbTJscEhBMXJCdG0yOXZRemRpUWFuamlKV2Fp?=
 =?utf-8?B?WnpOWTg1MzhFRnhoTHh5b0JZdHB3OVc4VFhGc2grK042Zk1wL2xObDFERDdu?=
 =?utf-8?B?MkR3aUNxTG12SmgxT2taSHI3RW5aYWM4N25uRSs4SzBQc0QwVzBFTVNRRzR2?=
 =?utf-8?B?eUxRSE8vTGt5T3EvWXlUSXdQYTlOWFBkTDJ5a25UczhhNWZpM0NJL2VMeVcy?=
 =?utf-8?B?UlA0TWhDWnYzSXBkancyZ2xWek1xMU96akplaWZJd3ZzSFlhdFlMbFB3ek1q?=
 =?utf-8?B?T2pWd0RBZGxwWFB3V3FTTG9PSWlHKytzU3BzSklveDFiQ21qOVZUU1NrNlp5?=
 =?utf-8?B?VTg3L1FVZ0NFWmtQUGQ2QUU5NHdVbWIzaHRnMnBRdk43OGRnVkJhajZuRDY0?=
 =?utf-8?B?S3BpUGdyMFJjeFJveUQrUXRyL1JFTEk0QjBYZTJnRGRtN0hscGEzeGFJZWNO?=
 =?utf-8?B?VzlYY3RUQWVlSHVjNG5PZ1lWL2ViOGtjcUFhOGFQZFRpbkhqcUdpVFZxTWxX?=
 =?utf-8?B?Z2h4OTN2cUhpQmF3ZjRMSy9aVHcxYnpra1UzWTlYQ2tLUXBQbUVrWXIrUTdJ?=
 =?utf-8?B?RkxYR2p1eFlCNCtxL1Q2NEJtaWZKai9iWXcwd2hUWWo5c1o1TmhoZWRLWDdO?=
 =?utf-8?B?L2QvaHZFMzdveGh5VEpZbXEvclJYclV6Y3U1U2ZwNThSR3o1b0o0aVhtN0du?=
 =?utf-8?B?N04xMllTcitSdTAxSFBDV1B6MkpjZWZVcHMyNUtLMjZOOENJOUJmdjJLMFBn?=
 =?utf-8?B?b1BOQk1tRERmUHlMeFFVRytSRDFSYmZIR0w2bjZkZlh3QXBRT1BVaEd4Y3pD?=
 =?utf-8?B?ZnJQNWs5WEFJSlA3b2JwWWJDdng4L2x1OUFuN0dJTGVndXU4dWplQWp0Uit3?=
 =?utf-8?B?aFlHOWlvcUhyeTQweWFhM2lRWWxKMDEwZm9WRE5iY0NCTklONVhFTUsrZGxU?=
 =?utf-8?B?OHVSMFVKbWI0ZnNra3B3TzlLajlxTklsdDc1R3Z5ZzNNaGdKSFV4eEhaakpI?=
 =?utf-8?B?ZTBFZDgzTWlKWGQ4UmNCV3BDOE9qczI1bEVZaFZYMmUyd2dFVDJKaEFjNVRn?=
 =?utf-8?B?WERFQjdUTUk2UndaY3JoUnRHZnQ4RmlVTlFSYWNycW9XWVk5ZW9GK1Y2cWdS?=
 =?utf-8?B?QW50QUVzS2dSRU5iam1WM0xpeXVXemRTc0JaVVFyUkNZZXE2R1FtV3hTSEZU?=
 =?utf-8?B?bUJVb2t5Ui9ZTDRkM1p3NWlMZWx1S1Z6UG9kb1RucG85dWVDLy9BNVpVa0pU?=
 =?utf-8?B?VDFRRlBuNFJleUVVeWJiSnNhSUtjTE0wV0dmNHF2clBJU0paNFd0TkJuaDZ6?=
 =?utf-8?B?alM2aVNEQjVsbUswdGpua2FEUTQ5Z2hSNDVvemtta0RXaktIZkFMbGt6cVda?=
 =?utf-8?B?blN0SzRrQUYzWmh6WUt4QnJHN0gwWVE1YXRpQjlIL2l3L29jekdRVjNlaDFP?=
 =?utf-8?B?ZFd6TXdvWnJqSHdWaWVIU09PLzEwalg0NWdJM0hOZHpsNm4vZFpuQkJ6SHBp?=
 =?utf-8?B?R01oQnNEWUVEc2F0SzNnYkthUkRFMFVxcTYzM1A2RXVKMkg5RllUQXArbGhF?=
 =?utf-8?B?dFRRS2N3ZlpDbndaV2xKS2MvdDRNNURodUhmdGRUdzZwL1A0S1RTSVZsdXhD?=
 =?utf-8?B?R3NsT3p3WllzazJTRUEyQWJlRGhRWjZsTitCemphRHdDd1FJbnl0Z1pFVXov?=
 =?utf-8?B?YVpzUWorNFNCUy8yOTgxYVFyWG5HU1lnc2lmWlgyeTJwQU5IclVyN05hUlJ6?=
 =?utf-8?B?QU5MVWNTQlBFWFAwQTYzaDh6dlY2WTRyWXdyK1E3ZjdnNjR4bm9ubUhqM2J6?=
 =?utf-8?B?TExtTXR3aU5jSGtFbmh3MHliWkVMR2p3ZkFnTDdmWVpMcFZzci9mM091SGRm?=
 =?utf-8?B?SGw5Z2JUQlEvUTFKdjVsWldxNVZyRElhRkNCWHgzZWRBNWk3eVRibzZ1dzlW?=
 =?utf-8?B?L2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D3065D2387F9646B647CD84401369D6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1342287-28c4-4c09-e9fc-08dbb609b6ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 16:35:04.3731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fDvsCRvL6uLY+/ASrIrfHji2/FahuqI9EJ1Cu1cKKHgLWcnDPQ1Ns+vf+wpLbPl7REqx/NtRnnU59N8vGXFJhlzCRPd603vxf7fWIpFqBb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5180
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA5LTE1IGF0IDEwOjMyICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gPiANCj4gPiBBbHNvLCB0aGlzIGRvZXNuJ3QgZGlzY3VzcyB0aGUgcmVhbCBtYWluIHJlYXNv
biBmb3IgdGhpcyBwYXRjaCwgYW5kDQo+ID4gdGhhdCBpcyB0aGF0IEtWTSB3aWxsIHNvb24gdXNl
IHRoZSB4ZmVhdHVyZSBmb3IgdXNlciBpYnQsIGFuZCBzbw0KPiA+IHRoZXJlDQo+ID4gd2lsbCBu
b3cgYmUgYSByZWFzb24gdG8gaGF2ZSBYRkVBVFVSRV9DRVRfVVNFUiBkZXBlbmQgb24gSUJULg0K
PiANCj4gVGhpcyBpcyBvbmUganVzdGlmaWNhdGlvbiBmb3IgTGludXggT1MsIGFub3RoZXIgcmVh
c29uIGlzIHRoZXJlJ3MNCj4gbm9uLUxpbnV4DQo+IE9TIHdoaWNoIGlzIHVzaW5nIHRoZSB1c2Vy
IElCVCBmZWF0dXJlLsKgIEkgc2hvdWxkIG1ha2UgdGhlIHJlYXNvbnMNCj4gY2xlYXJlcg0KPiBp
biBjaGFuZ2Vsb2csIHRoYW5rcyBmb3IgcG9pbnRpbmcgaXQgb3V0IQ0KDQpUaGUgcG9pbnQgSSB3
YXMgdHJ5aW5nIHRvIG1ha2Ugd2FzIHRvZGF5IChiZWZvcmUgdGhpcyBzZXJpZXMpIG5vdGhpbmcN
Cm9uIHRoZSBzeXN0ZW0gY2FuIHVzZSB1c2VyIElCVC4gTm90IHRoZSBob3N0LCBhbmQgbm90IGlu
IGFueSBndWVzdA0KYmVjYXVzZSBLVk0gZG9lc24ndCBzdXBwb3J0IGl0LiBTbyB0aGUgYWRkZWQg
eGZlYXR1cmUgZGVwZW5kZW5jeSBvbiBJQlQNCndhcyBub3QgcHJldmlvdXNseSBuZWVkZWQuIEl0
IGlzIGJlaW5nIGFkZGVkIG9ubHkgZm9yIEtWTSBDRVQgc3VwcG9ydA0KKHdoaWNoLCB5ZXMsIG1h
eSBydW4gb24gZ3Vlc3RzIHdpdGggbm9uLXN0YW5kYXJkIENQVUlEKS4NCg0KDQo=
