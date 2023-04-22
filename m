Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2356EB7F5
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 10:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDVIOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 04:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVIOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 04:14:09 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CDA1BDC
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 01:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682151248; x=1713687248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rgdN3iDhfEdeLLIYcXLbhD5RQftOHXwHn5CEqCUxtXE=;
  b=c1Aev1bRaFDJ9TjUs1LH0WoY66Z90oYTTuVUDxL6wEIxEVJKqjcJnDHJ
   a37CxlLIlFjKdS51TrIEw+DQZSsYKOM4iQJ1L9LmzscElt52lqTIlVePT
   08UzIurzDp4ll5RkW8YvSI5qnuDLemBYR9CmE7Zxs8o1ZBf+3jJNSARJr
   Bm3e6pkpu5031ccWoPAOtce3CKylCqlORojQB5TuIJZ/QR5OP3Yo9U61K
   M/1/vbs90A8k8BTCtTV8qU+MrQv3VRg/JOwCBqmBSM/NZW52Uoeht/1Mb
   TeUNIGjZE9IHlrxgPj2sRU5G/X+7bnW0MbCzeRgFSiM4H86vZBLmbehHm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="409077377"
X-IronPort-AV: E=Sophos;i="5.99,218,1677571200"; 
   d="scan'208";a="409077377"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 01:14:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="836405272"
X-IronPort-AV: E=Sophos;i="5.99,218,1677571200"; 
   d="scan'208";a="836405272"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 22 Apr 2023 01:14:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 22 Apr 2023 01:14:06 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 22 Apr 2023 01:14:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 22 Apr 2023 01:14:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 22 Apr 2023 01:14:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRP0CWXXCDgUTatwFCfd9ZQF/K5SDQtIiV5pGrM9Itc9BJ/19HzDqXGviqx8OjCw443l3HQBBu5YVZqD9da4vAEm1qZ5cWP/o8KyIQavof3L+hTJXZIKO7sL62QO64cTsg0wg2O7X0CRepr+Xd85QIJy5dQ/t69jNGPQREzt2otwBFmFZ7vS4+PTPPQXkd3Kt6Qy7Hzl6eMcHDw50sjWMnm+cop98kMoi8cqpmj/fzWwAZp7LzdwGYAV1/7rSkvbBP5usQ9A26+IvRKL4c3q7VxrB+OJOaKhRmsoyI5J9nfUFlMx8J3yqzqKA5CXiS6hTTrgc8E9QuxsmMk+8/xg0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgdN3iDhfEdeLLIYcXLbhD5RQftOHXwHn5CEqCUxtXE=;
 b=U8Bzvi0z119BG8/9wBbWofh3WQlv6G/fodEwYN2HwFdzESFZkj995s0dtPlpaT4lbgDdIJLTvhf9C9kr+2NkyKRggoAzgGBVwbGWhok2mLrDFu6+H6CuGncdDO3yWPpDLk0Fr5Fu5+FnLFtSsOtlzeGdXhPKCNHLVaB+hwQ6VaX+8kyJQo+nmqa7UrJd5BKafEEaX4bHa6VW4GG8ZHF4yWpbOKhBDh1VYprw2dK52hZGLCgaH+DMrTy8rOIRcb4s39rWYMd0DIgX3aRx5OmLyqCJU0aZ0u15ddZ/JJeuZARnpOIzb3inzauOG+2EEThm85Y7WXhKdhWJZrahLyGODA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH7PR11MB6353.namprd11.prod.outlook.com (2603:10b6:510:1ff::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Sat, 22 Apr
 2023 08:14:04 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::12c2:36ed:dccb:ca63]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::12c2:36ed:dccb:ca63%6]) with mapi id 15.20.6319.020; Sat, 22 Apr 2023
 08:14:03 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgIAAJr0AgABKcWCADGbRAIAAVjKAgAA/1oCAAN85AIAAOKiA
Date:   Sat, 22 Apr 2023 08:14:03 +0000
Message-ID: <f0009c6071eb1a8cff3389a735c6619f56a57eda.camel@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
         <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
         <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
         <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
         <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
         <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
         <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
         <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
         <ZEKsgceQo6MEWbB5@chao-email> <ZENnwtBzRVz14eS+@chao-email>
In-Reply-To: <ZENnwtBzRVz14eS+@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|PH7PR11MB6353:EE_
x-ms-office365-filtering-correlation-id: b5a85406-5469-4856-9ce7-08db430988ea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y5y8EdEjtxrW2kfgU5mWDG6kdUhM8pF59IJWNYXXjsVfk61drTCEE3vANOCnD2b5+Ufvo7SzJ+J65R2qV60STPec90HBct3rZNhI+EjutZzCX88gSmRRWmuTLItuW+CDELszD3+2a28Niji8zdHJilH4pkSf1a1D+NQTeBXYvnmAjbB07Zzkp4Q55QnKia3lcVt5qnOCOTLyH6LfgEov5/tR0gllySMfBPnVfeFAtjC13AfoF7WwfB7cK6cwDvzw1hSUJYzFso+pdofJO2eQK/RBJJwFJifKSfJtb0qMRs/p1t2mXz2bgjJVOck49KHvn7LQyaS0Z8eR3qa3I94Q1Wyb32KRRyJ48HoO4ppyLg+UytLr3Wftr/vMzldZacNEo7UxXnycIuy33eg3dhMKfRe5zI+mMPfa0LRv4RToQjVYPOejTlNKYVDmynzleHvGdQeBn/azfkeYm9aMnzJE8Qc2pdYlKzTnkCTTVrRdRiXpOEIJscfjq0qQXU9fzlTaoSU2EaW4OwDxloYV88qkkDQSubhyc/c/8NnZAixgEwbeUhjpTsemM/Usx5F6/IR4e9F0uCRSr3C2YSMMWDUb/JL7X6lQkp8EM03cHvwsmF0Mws49hv26gRBb5nzsyjoM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199021)(86362001)(38070700005)(36756003)(2906002)(71200400001)(2616005)(5660300002)(83380400001)(186003)(6512007)(26005)(6506007)(66476007)(91956017)(66556008)(478600001)(64756008)(6636002)(66946007)(6486002)(316002)(4326008)(66446008)(41300700001)(76116006)(122000001)(54906003)(38100700002)(82960400001)(8936002)(37006003)(6862004)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXNmM2s1aHFBN0NJT2pJYkhqRFJvVW1xQ2ZMR09hUEZERUZ0WlpoaEVzV1J3?=
 =?utf-8?B?UkowTjNSRnkrRStocjJzYm9ONy9scC9EZW1xd2U3NmVXSzZKVEpOeHVtKzF3?=
 =?utf-8?B?NlQrYnNoVU9wdlFmZzhUQ0ppaWJMVWhXZXVqUEJadVI3VDNETlBEblF6V0VV?=
 =?utf-8?B?TkMxaTlha24xRWIzdzhMMlBURGRON3VBSjg5RExqNE1EWUwwK21ZeHFsRHV0?=
 =?utf-8?B?YSs3YitjTHNCTW5CVHlhOEVhL2RTVmh1cWFVeG8xS0FHQ2Qydk5PNXpMdm9R?=
 =?utf-8?B?M3p0Mk8rUzVQbTFjdEM4cTZqelRHbkNvL1d5bkE2UWdiMWk0K3Q4NFYxOEYv?=
 =?utf-8?B?R0pOcC9jNWIyOWc3SmZpNXBPSTMwZjluR21rUkdSNzVaZFlmYU16WnpiRUlL?=
 =?utf-8?B?V2tLMFQwcGJwVjI2V2xGSlJ2Nk9LeEh3ZUFlU3MrK2VPNmJwUGJBQ1VKVURT?=
 =?utf-8?B?YkNzUnJqempYZzlmTnpNZEV1bFpqZUlvRkdjblQxRmcyVXZ1K3Q0aVc5cFNk?=
 =?utf-8?B?Mk9MWWtHWWs3blhSY00ycy9xYkpCTUNsQjdKNW5JMzNnV3lsS2tsWEE0VTB1?=
 =?utf-8?B?bkJzQTUwTXJwREhjZnduenZnT1hkUjk1Mm5NRWw2UG5qRmh5UWYrK3FiNWV1?=
 =?utf-8?B?MVM5a1hkc1pkekxmTWJmK0trUGZESmZ4Q1dnYWxHc0d5RWZoUll1VFBFbE53?=
 =?utf-8?B?N2g5N2V3YytueDRnNlZlQ242UVNnanFrbVZRYTBrSTVlQmVmcVh5RUhMcm9G?=
 =?utf-8?B?U1A4QnBWL1hKaVNNd3RWZng4NTFrQjlLdmxQVmtSR3JKNW9zclArWWE5MVh1?=
 =?utf-8?B?bU55Lys2VjM1MEQ2T3pRLzZzOEh1c0FaYWpDU1ArNmFRNXBNU01abjN2d0NC?=
 =?utf-8?B?V0U1K3UzdVhXMUs4eGQxaXZGMnJDY1FhMngwYXJQMHREbExvZzA3b1BHQ0hz?=
 =?utf-8?B?c2wvSTBaUUlwRmM4bkxrT2IyUmFkc2JMQ2RXYjFxRUQ1RThSVFVleXZ4Qk5l?=
 =?utf-8?B?a0VKME9DKzJJeEsyRmw0SzJLSElLYUE3cm92M25tK2l3UStWZEZvMithM2tY?=
 =?utf-8?B?V0dJQnY0Y2ZRV0VqNXRXVUVMQWJPOXBxdG1wVXZ1Mm9iWlhMYzBTQWhNME1V?=
 =?utf-8?B?TmM5QmpwQjJzWTZ6RFBOVWkzQUNKcGRCeDVNdk5hNVNPazVoeVhJQy9ZV1VL?=
 =?utf-8?B?ejNETldzWkpINkN2Qjg1TzdwVnJQaitKQ2NWam12Z1lGM29tMDlhK09UZ3Zo?=
 =?utf-8?B?Mi95c0RYNjVZL2h0ZEdHamhyZHlPZElZZXY3UVFiR0FIbnNvbHNGaVNvMGQz?=
 =?utf-8?B?UHcydkdvVGkvc3dSd0JDN3Z0T3dWbTRCaFB0SHZoMUJ0VjdTTm9kenBoUFdC?=
 =?utf-8?B?bGxTNHQ5L2xyV0JqNkVYamFzaGY3WHVjUnA5TjVJV1oxMDhET1FXM2pMdTc3?=
 =?utf-8?B?aHIxWDJkbTFEQzFMVkNQWHdBMzdSTDBTaUpFQi9ROW5HSW9zaWQxV0RsY0ZY?=
 =?utf-8?B?WXhvcnFKNjE1NTZMY05jVkpCV0JOajRiTDM3SFgzc2p1ZlhNalRxZDVwRnBK?=
 =?utf-8?B?bGVXc3ZVQi9QeGFBdDZsUVRIU2x6N0VpRGNlS0xWWmxTQlJ2MVBWTWt4UzVw?=
 =?utf-8?B?VjBCT1cvRFFXdEd4Y2tmTDBQbGFtT0pXdXN1OWRpbEFOc2VqOU01TWJVUHph?=
 =?utf-8?B?UTZLTmt6Wm51bVZqM1RHaEpMZXlpWXBIR05ULzZDaFo1cWE5TmIwY0NnQkg2?=
 =?utf-8?B?cEJ6Y0tpSzh4RjVWTU9wdGpiaUIvb3plVng5TlgzcGprVm9SRHJKTFdXZk9S?=
 =?utf-8?B?QXFHNFhRTHNSam5JSmpoMXd4VnNDSjZJTDd4Wm52eUgveW8zaEdHZHYzRHd5?=
 =?utf-8?B?bWpIL21vT3BGelh5R0xKTzN2TWh2TlZVbE8wdXJQaDl6ckg1WDlzMmdKaGp4?=
 =?utf-8?B?NXRabGxLSFNCNnQ5ZjhJbGZQR1hFVTBMeTlCckhTNDJ3Zy9Cd01LaDI1d1BZ?=
 =?utf-8?B?TUhHN2Y4TVhUVCtaUkdxc2RxemxyclRmTHdtWXNOM2xWYzF6cTM5WUU1Slh5?=
 =?utf-8?B?V3krVmowdlZ6eG9LbW8wRGNSK0I4Ylp6YmsrTDFXK083b1BubDFHcHZxNC83?=
 =?utf-8?Q?2lK6pJj24fX4C/VeMjhXpeZrj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B754EEBEED354C4D9B3AF9495B5A3568@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a85406-5469-4856-9ce7-08db430988ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2023 08:14:03.3811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ee3ceq+ZMfyaI0PIb6/GhtrnmgNRAABpy4Ep41Eyab0rP03HRcrcmbwNZ6A71N5ceudNdyZav4Wu646hUq4nng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6353
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIzLTA0LTIyIGF0IDEyOjUxICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
RnJpLCBBcHIgMjEsIDIwMjMgYXQgMTE6MzI6MTdQTSArMDgwMCwgQ2hhbyBHYW8gd3JvdGU6DQo+
ID4gPiBGb3IgY2FzZSAyKSBJIF90aGlua18gd2UgbmVlZCBuZXcgY29kZSB0byBjaGVjayBib3Ro
IFZNQ1MxMidzIEhPU1RfQ1IzIGFuZA0KPiA+ID4gR1VFU1RfQ1IzIGFnYWluc3QgYWN0aXZlIGNv
bnRyb2wgYml0cy4gIFRoZSBrZXkgY29kZSBwYXRoIGlzwqANCj4gPiANCj4gPiAuLi4NCj4gPiAN
Cj4gPiA+IA0KPiA+ID4gCW5lc3RlZF92bXhfcnVuKCkgLT7CoA0KPiA+ID4gCQktPiBuZXN0ZWRf
dm14X2NoZWNrX2hvc3Rfc3RhdGUoKQ0KPiA+ID4gCQktPiBuZXN0ZWRfdm14X2VudGVyX25vbl9y
b290X21vZGUoKQ0KPiA+ID4gCQkJLT4gcHJlcGFyZV92bWNzMDJfZWFybHkoKQ0KPiA+ID4gCQkJ
LT4gcHJlcGFyZV92bWNzMDIoKQ0KPiA+ID4gDQo+ID4gPiBTaW5jZSBuZXN0ZWRfdm14X2xvYWRf
Y3IzKCkgaXMgdXNlZCBpbiBib3RoIFZNRU5URVIgdXNpbmcgVk1DUzEyJ3MgSE9TVF9DUjMNCj4g
PiA+IChWTUVYSVQgdG8gTDEpIGFuZCBHVUVTVF9DUjMgKFZNRU5URVIgdG8gTDIpLCBhbmQgaXQg
Y3VycmVudGx5IGFscmVhZHkgY2hlY2tzDQo+ID4gPiBrdm1fdmNwdV9pc19pbGxlZ2FsX2dwYSh2
Y3B1LCBjcjMpLCBjaGFuZ2luZyBpdCB0byBhZGRpdGlvbmFsbHkgY2hlY2sgZ3Vlc3QgQ1IzDQo+
ID4gPiBhY3RpdmUgY29udHJvbCBiaXRzIHNlZW1zIGp1c3QgZW5vdWdoLg0KPiA+IA0KPiA+IElN
TywgY3VycmVudCBLVk0gcmVsaWVzIG9uIGhhcmR3YXJlIHRvIGRvIGNvbnNpc3RlbmN5IGNoZWNr
IG9uIHRoZSBHVUVTVF9DUjMNCj4gPiBkdXJpbmcgVk0gZW50cnkuDQo+IA0KPiBQbGVhc2UgZGlz
cmVnYXJkIG15IHJlbWFyayBvbiB0aGUgY29uc2lzdGVuY3kgY2hlY2sgb24gR1VFU1RfQ1IzLiBJ
IGp1c3QgdG9vaw0KPiBhIGNsb3NlciBsb29rIGF0IHRoZSBjb2RlLiBJdCBpcyBpbmRlZWQgZG9u
ZSBieSBLVk0gaW4gbmVzdGVkX3ZteF9sb2FkX2NyMygpLg0KPiBTb3JyeSBmb3IgdGhlIG5vaXNl
Lg0KDQpSaWdodC4gIFlvdSBjYW5ub3QganVzdCBzaW1wbHkgcmVseSBvbiBoYXJkd2FyZSB0byBk
byBDUjMgY2hlY2sgaW4gVk1FTlRFUiwNCmJlY2F1c2UgYXQgbGVhc3QgdGhlcmUncyBhIG5hc3R5
IGNhc2UgdGhhdCBMMSdzIE1BWFBIWVNBRERSIGNhbiBiZSBzbWFsbGVyIHRoYW4NCkwwLg0K
