Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D295D628F9D
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 02:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiKOB6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 20:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiKOB6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 20:58:17 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E8517421;
        Mon, 14 Nov 2022 17:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668477496; x=1700013496;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4/x//HRnMUjXcH3Q0UcXn8L694ZkEkcG8ZNscMnZ7fA=;
  b=ak5nnJHH4C8XXznf20sN4x6N7k4gtBX/Bo0yRGJ0wMhsPe+iiISVmNA5
   KHSFTaqE3oXNa5l6KHlZD+Z2Xas6V2itG9CXOQnRDdBi3tGWGY8qJlQ8V
   WQIQopNq5J1+1QTqOhTY8GhWHSuuJdDbf5TIXeNUBXTguRdmIG+x9ZSa9
   42p+CjQX8YONX2Bt1jSif91dDPHrp3kZd3BhKY82XcAmtvzFuWiqXw6R1
   m/8aV2tg/ZVz0Ob6rI+UFf5tGC2rUm9Dps6CmHhX7dwpAOC0mIBa5VfU9
   xYB81z+A/WjYY3WIlGj4hwREt5t+mqM7Gw4Z2wpb4OG5HPYVYIWFfmJb5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313941362"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="313941362"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 17:58:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="883769776"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="883769776"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 14 Nov 2022 17:58:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 17:58:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 17:58:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 17:58:14 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 17:58:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ga2h18Ah5kpDygk+mnYixD3cfe/luTy0HEejkkO7inYTT5KO7Ly2t0X+zNmbG4eE68prN/6FWvh+GOhcX09/Ai0bTxsB2A9LfJEOrLknnq8Jzv89bgX8npQoZn/BBD/s+vdPHiOHTfoQRZa7bYLEcoMGGUfkq0TGiD3C4qioKZllJFQxMPOgSkeGf24UKVvvlNDXxPyBd9MEPdKsuCqc84LvoabSaMT/6FFHAXEKxk3y52Ana4z7UU6FIWe9CVMF5zadmgfU8q9BOA5XoGMwXPNrW3fChk1GakHS11xm1HEZGiGsJJ9G0el/ajJdFeHl7IdxI+Dft5Vp3AYtM6hDuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/x//HRnMUjXcH3Q0UcXn8L694ZkEkcG8ZNscMnZ7fA=;
 b=EIM2IbPi0Ite6ap1fZaPcxop5AzBHd0254XdPttQ+OhfhBLEjyXECpc67WC/l07giNrt+aBRWXyD2N7SLVo+qWqKp7Zjd0AHU+Qd+Np/I0WIMjBuHTHgsv9nY8Ednbaei9w+FRqltPFUOO+32f21vxAS3JZ6rGi6tUJvq3ywZQEUorCu0emJtbn3ILpqWIHHPmtUQ6nYCJB1uGavgBF9oVtGbFEWRVdqY5g8SaXey8Y+yjnQohyi9IrtRoUBKPidjguYh1nUYS09MHTxymPBVBDQpCdgvW81WOKLLIUbHM1MuRUnc50EBjZc8mJ9iJpKHjtx8ZTjgQyyXRY8840jFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6009.namprd11.prod.outlook.com (2603:10b6:208:370::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 01:58:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 01:58:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHY7ChDw1zmpi/iYkCerKDnhZwIwK40StmAgArbrICAACyVgA==
Date:   Tue, 15 Nov 2022 01:58:12 +0000
Message-ID: <ab48eb458666a1cd1d7ae36faebf851536b86544.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
         <0feaa13fa5bf45258f2ebb8407eaefadf5c48976.camel@intel.com>
         <20221114231835.GA2350331@ls.amr.corp.intel.com>
In-Reply-To: <20221114231835.GA2350331@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6009:EE_
x-ms-office365-filtering-correlation-id: c75966ea-2fd5-47f0-38b2-08dac6acda4f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1PMpM258CKmzhGnykkVCtyD+lz2SCc7LGO9QUKAOo2QS8vMYXXttg3echdgkICVKDNS3k1wqDmIx9fYnhcDtrHlVSpJogKBNUtXTz3mnMvEeMcGihehyL58UTrdbwMVduYl4JWqF2aqwEWZbqgtlqSMcq3asXMpbefqEa4H2oUybN0QjGW0Ka8axTeXqC1oeB7h8Ny6e3QFtCRgUeLkoyZXBmVdj2dd5uLKLxivB1UXNuUKIg0xZJuh0tXqZ2Fh1Ropkc36+jp8MQkYuEcw1lIF0AD1Nd4G3N8bEVzCiFXQWg7/2rLdujih9XhZi1spjS/IuD7y5RHCKoFRENLF67X7iDhpFOP4VxIPH1rJLstawD77et22Zeyto7I5XuiVxlBjvEzD/p0KD7k6d8RTrlGj377IzVuwsC6hfxH0CSu0oVNGQb/7Y1GTktwgobAgAnyHpAce1A9OgnYUFQ9I5oaSMTvasbilIXjf1EK8KMUPxNA5Zt7lbh/Ny4Iiv4Mb8dE6IQitNQtgwQobdfMRoaTlINBcnhIAbKCH6KFenuRpFVTI2bIE7bRhMnHWQ2RxOBP3SeYPJdKalem8SQRay39jgXCYWl3hMPmRYKKiVwhUXkf0DUJd2Z9Zyhg6TAlv+kV5sprzz1gFImsNpAjnmTbgObBBk3FiyOI41ZbmxXKDJPd8U6jfp0sN1XVetsdatRLbEPPakJVwgfJM/frr6OQ/gYk89fupLtYdTzfX+HcKCq5qMCkKy6m73pl3/a1cCYoxbRi8sGKWnj9+rgisdlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199015)(8676002)(66946007)(4326008)(66446008)(64756008)(186003)(66476007)(66556008)(91956017)(316002)(76116006)(54906003)(6916009)(4001150100001)(2906002)(6486002)(5660300002)(82960400001)(38100700002)(8936002)(41300700001)(36756003)(71200400001)(86362001)(6506007)(6512007)(26005)(2616005)(38070700005)(122000001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STl0akZ2Wi9uZit3SWFyNUxuSUtoWHNoY1MwNEhWR1l0VHVUWis3ekxqUEhI?=
 =?utf-8?B?aS9GZW0wam41UDJQbWpsWnR3Z25wUEt6b3hPOE9KeFBCdHhXSWtvYjF0bXI3?=
 =?utf-8?B?NnFIcnBDUE1Qc1M1VEZlTmtpNzdjbGF4eXlpSlNIdTljN3JkVDdaUWFsR0tr?=
 =?utf-8?B?bkYxUHhYWWswaWpRenBPWDNLbnlhNUk3engyaXJQc0lkSHBWZVpTbEY3NHNZ?=
 =?utf-8?B?NjRRaW5NVUhyWmd0dnFPQUhpNTJpdWgveG5oRWVOU1ZjdTBIRnk0NTNPTDVs?=
 =?utf-8?B?TXpXWU02bFpwYjRpR21JWkNHYVVwenBDbDVWbXpwcU5zYjFCOVdnM25yZ25z?=
 =?utf-8?B?d3NmZzBkc1BZM0RFY0tNQ1hYNU81RVFQTTBTcFBMcE9mQ0E4SXppTnpjdFFQ?=
 =?utf-8?B?YzJoOVZ1RnJpNk5LOGpDbzRra3N1Tis5VVhqbDUyMlFKWHE5aDJyeCtYSUFQ?=
 =?utf-8?B?V2lzUmFJek1mNVYxU0ozazBMNTJQcHp5TUtIUGxYZWR0cHVSd3BhZHdTKzRI?=
 =?utf-8?B?OFVpWW95NHZBRkx5KzZLNHNtN0tlVGZTalc2em81SmM1a3poQUpZbmRlVmxY?=
 =?utf-8?B?RjB2Y3Y3L1lUYklhRkFKMGcxMFFDaDFwYjdlRUN4eHZSeHNDczdwZEREeEo0?=
 =?utf-8?B?R05URUZJWk45NzQyZ255bWdHbzFZcGpYNk1wVmxOeUR2SXg3MFFLMlhwNzg3?=
 =?utf-8?B?WFBTT1Y5VjNNaWhVRTdFbVJzbThUV2hPdjJxSmpNNFNrb1Ewd2lyVHp2U3dH?=
 =?utf-8?B?dmN5bGNrb2psYnpIZjIzcHRhU1RxZzZzRWk1V3JvdE9mZ09XOGZDVkk5Q2Fk?=
 =?utf-8?B?ajZPYWQ2MjJOc2hkc2FxU0NwOTI3b1d5L0xMcUMyUnlhbEpUV3h1VEhqYnla?=
 =?utf-8?B?c3JLZWFWU0h3TXlxU1c3ZXljck1BODcvczVyTGNRNngvQThRUUhwcGRGRmk1?=
 =?utf-8?B?NXdsY2Yxc1ZnS1J2NGhpUTc3TjhudGlONzhJbUFibHpiU05zaTJ2V21iei81?=
 =?utf-8?B?NHlpVmVsQnI2azBRT1lEcEpnYXBLaEI5c0gxNkxYZVF4WVh6S0wzTDZLTmo2?=
 =?utf-8?B?ZXhRVG4vbWRkdXEwam5UL1BMVVBTSWZaMEF6QnB2VVBvZmgrcE0zZUFSTStU?=
 =?utf-8?B?eEdoZ2VCV2pqWExWK0xEam1iMnJNL3g0QzdNYjZ3YXVZWWpwQlZTZExXeDZT?=
 =?utf-8?B?OXVFMlUyVHNJWXVIR3RFQmtyZHlQN1g2eDRqUy9kcjg2Z1ZCTTQ1RXRhWXdv?=
 =?utf-8?B?aXRZNXlxcUlVR2UzcVEwNUFubTRXQlVMbHNwZUlzOVQxVGFHMlNZMHJWSmdx?=
 =?utf-8?B?Sml5QVltZExCYS93cmpYL0RTU3lTRkVTa1dEY2FXQWhUSjBETU5wZTVHV01T?=
 =?utf-8?B?TkY3RmgrWnV5NmR5N3Y2V0tKbmdvNzl4L2IwZDRsd0VxaXRYdUhXYVpZSW5o?=
 =?utf-8?B?WHZOQk1qNVgxUmZYQXNEZmVLNkxJM1NGMmZrYXJFMTJYSEthK3hBMXhmUml0?=
 =?utf-8?B?RkhyRzN1aW50dHU5TUNrWkZkMUgwYTJtRW5kc2FSNzc0QXVQQmhOWUdxQ05n?=
 =?utf-8?B?NzdvK2JlYnNMc3BESGYySTJzYkl1dkNNc3kvQWFmd3BBOEZwb1A4cFZqazNR?=
 =?utf-8?B?ZGl2RmVndmxGUDZRTHBoWW5sQWJOVzV4Y0ZiRFRERENxUlJleENBUTJPMkE4?=
 =?utf-8?B?cEpZS3BUQnlLdmlpZUdoSG8vSzhJaXdYMzFpei9hcElBdW9uTURqZllTOE5H?=
 =?utf-8?B?cHV4Z2RwWnJLcmRzWlY3blplUWlISmxzTWV3Z3dWVkh5dXRZZXhidHVxdHE3?=
 =?utf-8?B?c2Q3Z0NmeWVHYitTNzY5d0tONHBCeEJ4NWd6Vk4xTWJtR2lZaklveUlyb0pt?=
 =?utf-8?B?V1J2RE1xbHdMRjZibWVxRWJTd0FxT3ZzdDluZlV5N1lvMEMzazZyVFhIVzVk?=
 =?utf-8?B?RVZNTE9KdjVNMk5KdndxemwxKzJ6ZFh6Z2Zya3R5ZHpLUkcwelA5RGRpUlBy?=
 =?utf-8?B?UHNhNG85d0ZkOFJOd0dDMS9NRHl0ZTZjZHhhd3hCQUdQMmFvL3l3dy95RExh?=
 =?utf-8?B?Zk9rR3lOeEtIcWkyUDVub0xoZTZ2bjVTRFJ4Tk95cHlZdUxJdlZMT3NFYXZJ?=
 =?utf-8?B?S1VzaEUwSzNycmk3ajBVZ0g0ZFgzUmFWTVhHaHhtdkdHdHJKVHdQMkJWeDVk?=
 =?utf-8?B?ZkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DC9335B9ADFE34182FC7A5D6AF6AB5A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75966ea-2fd5-47f0-38b2-08dac6acda4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 01:58:12.5333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: trlqAN6wiLMxM/qvisTXkjhj78zO12BakETf52wTiKOsvEOdvcBr8l4UVLrQQXtEbmfMp8OJe+hloD1XvLjmGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6009
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTE0IGF0IDE1OjE4IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiA+ICtzdHJ1Y3QgdGR4X2NhcGFiaWxpdGllcyB7DQo+ID4gPiArCXU4IHRkY3NfbnJfcGFn
ZXM7DQo+ID4gPiArCXU4IHRkdnB4X25yX3BhZ2VzOw0KPiA+ID4gKw0KPiA+ID4gKwl1NjQgYXR0
cnNfZml4ZWQwOw0KPiA+ID4gKwl1NjQgYXR0cnNfZml4ZWQxOw0KPiA+ID4gKwl1NjQgeGZhbV9m
aXhlZDA7DQo+ID4gPiArCXU2NCB4ZmFtX2ZpeGVkMTsNCj4gPiA+ICsNCj4gPiA+ICsJdTMyIG5y
X2NwdWlkX2NvbmZpZ3M7DQo+ID4gPiArCXN0cnVjdCB0ZHhfY3B1aWRfY29uZmlnIGNwdWlkX2Nv
bmZpZ3NbVERYX01BWF9OUl9DUFVJRF9DT05GSUdTXTsNCj4gPiA+ICt9Ow0KPiA+ID4gKw0KPiA+
ID4gKy8qIENhcGFiaWxpdGllcyBvZiBLVk0gKyB0aGUgVERYIG1vZHVsZS4gKi8NCj4gPiA+ICtz
dGF0aWMgc3RydWN0IHRkeF9jYXBhYmlsaXRpZXMgdGR4X2NhcHM7DQo+ID4gDQo+ID4gSSB0aGlu
ayB5b3UgY2FuIGludHJvZHVjZSB0aGlzIHRkeF9jYXBhYmlsaXRpZXMgaW4gYW5vdGhlciBwYXRj
aC4NCj4gPiANCj4gPiBBcyBjbGFpbWVkIHRoaXMgcGF0Y2ggY2FuIGp1c3QgZm9jdXMgb24gaW5p
dGlhbGl6aW5nIHRoZSBURFggbW9kdWxlLsKgDQo+ID4gV2hldGhlcg0KPiA+IHlvdSBuZWVkIHRo
aXMgdGR4X2NhcGFiaWxpdGllcyBvciB0ZHhfc3lzaW5mbyBpcyBlbm91Z2ggY2FuIGJlIGRvbmUg
aW4gdGhlDQo+ID4gcGF0Y2gNCj4gPiB3aGVuIHRoZXkgYXJlIHJlYWxseSBuZWVkZWQuwqAgSXQg
bWFrZXMgcmV2aWV3IGVhc2llciBvdGhlcndpc2UgcGVvcGxlIHdvbid0DQo+ID4gYmUNCj4gPiBh
YmxlIHRvIHRlbGwgd2h5IHRkeF9jYXBhYmlsaXRpZXMgaXMgbmVlZGVkIGhlcmUuDQo+IA0KPiBP
aywgdGhlIHByZXZpb3VzIHBhdGNoICgieDg2L3ZpcnQvdGR4OiBBZGQgYSBoZWxwZXIgZnVuY3Rp
b24gdG8gcmV0dXJuDQo+IHN5c3RlbSB3aWRlIGluZm8gYWJvdXQgVERYIG1vZHVsZSAiKSBhbmQg
dGhpcyBwYXJ0IHdpbGwgYmUgbW92ZWQgcmlnaHQgYmVmb3JlDQo+IHRoZQ0KPiBmaXJzdCB1c2Ug
b2YgdGR4X2NhcHMuICJLVk06IFREWDogY3JlYXRlL2Rlc3Ryb3kgVk0gc3RydWN0dXJlIg0KDQpJ
IHRoaW5rIGl0J3MgT0sgdG8gcHV0IGFsbCBob3N0IGRlcGVuZGVuY3kgcGF0Y2hlcyBhdCB0aGUg
YmVnaW5uaW5nIG9mIHRoZQ0Kc2VyaWVzLCBidXQganVzdCBtb3ZlICd0ZHhfY2FwYWJpbGl0aWVz
JyB0byB0aGUgcGF0Y2ggd2hlcmUgaXQgaXMgbmVlZGVkLg0K
