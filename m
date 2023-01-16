Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1752E66BB9E
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 11:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjAPKXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 05:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjAPKXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 05:23:22 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BD0125B0;
        Mon, 16 Jan 2023 02:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673864601; x=1705400601;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8sn2C8ZXUvLKxJqaiowcJkQIVjXz0yweRhXEZb3zSCw=;
  b=EZl2jVR70dwcBtopt8zAwN//32r727hjXSNN1QB0Qd5gF+leb/PtB1lq
   0Fa+xsChcRaLr7G5IA/IxAvLTtGIyu7J5YS+K9cDQXjvf4eKNVKyj8AB4
   qnDDvWh5r0UvYfXcPUxk6cQS8M/6nysMZ2gI4MQOsqq5437BXg1pI8s+F
   w7SCJJ9IStHheJ703D/lE2+19EZ066wTFtryqzt2JZGPP/8b7B19HyJDz
   Wgjmdob9K8Y1jLG4b7iqPoubOjR8gHBcfd8xt5ghLq24+OK/1k+rme2W0
   2yCUltUQp0t0qbXOKtaEy0Mdmro/1UrUI4Rq4fxV/SVgzH4Y3AAGhret/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="326491969"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="326491969"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 02:23:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="691199964"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="691199964"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 16 Jan 2023 02:23:20 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:23:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:23:19 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 02:23:19 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 02:23:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIC2Ix1GtGIyAuCmmF5TXE9S/S/GycLeyUadBC4cMnbqHNleaH6cxli8+eVaL28c2oWa1h/QhBbIIr1o7tzMNqSALZAzQiCRu0vKlANeAGBQHhQdi4zgfyIOzf6wzy47eRwF9cCqjp34CGBQ4VLQ2IPFYA/69PXod7hJxS9pev4KtJ6nG526l8Tt6QdI5ugrRdPkZj1MXeNNaGqUDprQms0w9X5qI9KOxaiouAGRJU2i0TFjrdgizdTDP/LB1u9E+Dj6+EO5hQnkH6mJdkFvSkbURvkk4FfjGLyD6t0p0JxQD8Wloigw0E9wCXzr9mBE3f5e4Oep7kUHLye4FFvi+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sn2C8ZXUvLKxJqaiowcJkQIVjXz0yweRhXEZb3zSCw=;
 b=TbyQNPfbupMxoazos2QrBsVIIZ9w8WsjS6URIi4fEeEbwqrCH1rkIZSrWJjIu9esrbghF0nBugCNVtVi1rN7tbdJXqmJscmZ6EZFkIlIgaeDobdJM4OuqeKwxsDxAZN7PiNii9KnXdWa6QO47ff4xkuz6zy0hxPW/HX6503pbJn1nKxacQN8s8ODDpgWzjCMsXbwRlQNmsq7jORHWVyOzXOtKDZPGJpKOnghKELDwgkfpx5m9f8Wbwlrayf6ANMLl/QvpZzmU5HM0C41TX0qKl+dquqYYKSadaYPZYtJ79TVqRK3Xnuh3IrIy2hREa8MD7iioaMsDdQ+KouoA9VuLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8115.namprd11.prod.outlook.com (2603:10b6:8:12a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 10:23:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 10:23:17 +0000
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
Subject: Re: [PATCH v11 021/113] KVM: TDX: Refuse to unplug the last cpu on
 the package
Thread-Topic: [PATCH v11 021/113] KVM: TDX: Refuse to unplug the last cpu on
 the package
Thread-Index: AQHZJqT00LNmRr4ZZ0GW7NczcESoTa6g28sA
Date:   Mon, 16 Jan 2023 10:23:16 +0000
Message-ID: <d95328039ba69346c30555def1991bddc385ddd4.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <ecf02459d319789aca1b9399ed8fda47c03812df.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <ecf02459d319789aca1b9399ed8fda47c03812df.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB8115:EE_
x-ms-office365-filtering-correlation-id: fa51b5f8-2e75-47aa-65a0-08daf7abaec8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UYDfzUJbQ6KS6mTflUf4ukEu/lfbWYZbPQyjSThYJzGu1ewLQ5BGtbXfWNx66kcqAaCAoMW+MJfm0MaSeeoR2sDSA3wsTbagFkNtrowvzSMFvo5bwHtV47zSJdpFW6td2NUDplaEKevzjjBrx1U/G/Lm0jCTXtgwk2TS+L6MEUl5NNXYcoECahEEAnRgDmu8JSNQHXBVVbzaLiHc77hw23Jjg/VvHiimaWEEIcMfJh5ccaYO5Zto6raAylQDpr3b8xZXsYSNsQtUNDqhm9ZIbFZwxnDTx+Lq7DYzNM8iCFcNJ39wMnWo1dSZUXwxlAKk27LJ0hMk4yj55FI5JByobzq/jgkfFmANBnb0OYlaV+OppNMrreOGs6gy1EUUT1mwwbkhhfBp6zOwC9VPyibqy0Gy89lhWDne1Abr+VAi8CEFVlsN2wKsdP8qX0fLpiT6YdFMNDtVbQJr8zBYQQDKfPyQN4VXPzeGIL+LLkjfc2jbEaoPEP3+f1ZfGwa93FoVyVzkUiOyqND17LUqoBuuUeB8EkYXl5Klwtkho7OAqKcyNrgqcauLEFla1ez9yDovYEc3BGvkdRwWENML+euEvGx3gjl8KeptbG+2c6JLYxhZ8sgpx8TvR0dSuHoAErGjjqPT076ilKldD2VzAKl34LxFGm4cc5gRm+JnGcJ+RuOgBTR6c+xZRTD11wNkTJJrjeiicoZIaZZIeqxcOC57WQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199015)(86362001)(71200400001)(36756003)(478600001)(6486002)(186003)(2616005)(6512007)(26005)(6506007)(8936002)(5660300002)(91956017)(41300700001)(8676002)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(54906003)(6636002)(110136005)(316002)(2906002)(76116006)(122000001)(38100700002)(38070700005)(82960400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3ZnOTg2QXJOUEhaeStwOUlBeDNLbXdaYTZKSVp4QnRtbVE4eUM5OC9aTmJS?=
 =?utf-8?B?MjM3WkhPV0FLRzhmRThwWTh3VUdwMmpTZVNDVDNZYnhrN0tvTldNV2llWjZK?=
 =?utf-8?B?UEs4clZUNlNLU2l1NG5NRXMyN21aYTFkcmkwK1I4M3dCNnlNbU9qbkFpY0Qr?=
 =?utf-8?B?ckRvL2FSQnJGc2RWZGQ2N1hEeXh4MDdaQzRwUTFmak5pVHFDaGM0MEIzWWRP?=
 =?utf-8?B?T2JFMXl1K1VRU3pHWW5FTjFXSkt5VWhQblA2cmU5ajl1RXRDMENYMC9mYXYz?=
 =?utf-8?B?NjBTblAvcEpTRmNTUGFVU1FqbGdlMWFjQ2paOXNMYnNFcjZXb0prWHRIWVRs?=
 =?utf-8?B?MmtBbGp6dFJFZUtzeTl0VHhYWEc5Y1M5c2QwejloVHVWZmxmOUZDWFNyUVhk?=
 =?utf-8?B?MzBtaytiWnBxY1VVZFFSZXVhWkwvVEszRDVCS25UdTFEdVFkaDVKSUp3eUpC?=
 =?utf-8?B?OWNnaTVUUDJYZDY5Z1ZrNkhibkpMU1pJbzh3U1VCd003S1QydzRtR3lTa3FM?=
 =?utf-8?B?QkhjQjZkZ2txVmc2U0w1eE1WRGFnQ3dpV1JFT3U5S0djRDJENWlsQWN2R0N4?=
 =?utf-8?B?ZnFoWVh0bGlPNHBsTXVyYURnL1ljVjBqZFkwdUZ4YlVmRTJLUWRtUDZTNnhH?=
 =?utf-8?B?Y3FsNSthMnB6WFlwOUpFb2NFejNtbGREV0ZHTHhCK2pYZnY2ZGRLaVVCZmJ3?=
 =?utf-8?B?UEQva3htY0lhZzRpODZvbzVGODI3eGJkdzdlWE5SNXJ1SXZ2bHk0TytqQWRp?=
 =?utf-8?B?U1ZRMGJ0WUZMQ3VORVRXOHlsQjB2clpqeEczMzZUL2tvY1hzYmM3aEJid3ps?=
 =?utf-8?B?eUlSL3IzN29EKy9YRGtSYkxNYk1hbXF4dk9rdHphenJ0MGdWUUt4UHhSQ3Rw?=
 =?utf-8?B?RkQzaEVDUjFWSVE1eXNvb0NzSk9YSktQWXFucnVKaFM2UXFxaFFvblpJYzYv?=
 =?utf-8?B?SklMRjRqRmZEK3NpZTdmVkV4NFNPRmZrQ2dGMzdtaVpRUXo0d0pQTDlpRHZI?=
 =?utf-8?B?b09jdFlQQmdiYU9ERGFGdGUzb3NZck9lRnBNODdxVnBNaW1Ubk81YW1CSUVK?=
 =?utf-8?B?MHI4Q3lJb3RBc2M4WG9rOFhwOGkyd3J2Q2lGQzRQYVkrS0VsUlpON05HOWd0?=
 =?utf-8?B?VE1nVDUrR1ZZL3ZnUHU1STRUdVVVdXFoVjVWRmltOE95TVJ2Mm5KaVhxY21n?=
 =?utf-8?B?d25jOGhENVAyanc1SW5semRCOUhxRkR4cGgxWDMwSXJ4MWlueldKeFBCWDBi?=
 =?utf-8?B?MnhKQVkybmMrMmMrUkpleEY1VGRWMDMwbk0zNjJnSzd0ZUtSNnJHZlZFNm51?=
 =?utf-8?B?dm1UdDU0RTMyejBwOXJBN2JjWXFLRlJwWTlkM1poSXd5NC9way9mMUVjNmho?=
 =?utf-8?B?WUhjalc5MlY5TWJJdFp0b1ZlSTJxMS9JREFYelQrTlgzN3hYVFNnUkdhN2hC?=
 =?utf-8?B?bk9weTNMUE1VZ2VUM3l5ZFJ4bkVjMWNsRjhkT2RTcUkwWGJYN1BaTmlUK1Y0?=
 =?utf-8?B?QmRJM3BEa0pEWVhPNW4ybkMxSDViazN5dVgxUXVvRU1GcTRIYVBpVUFBUWZ0?=
 =?utf-8?B?WW1jQ3poVFRZSmF5QWcxbUE2WlhPekRQSFlmS00xZVBoSHU0QndkSmgzS0lz?=
 =?utf-8?B?RmRuVDRmUjRITWwzYVBkWS96MEZnVHc1T04yaWpzaVlkV0xUb21xMVM4M0JB?=
 =?utf-8?B?bEVjUUtaKyszR0kxbmxoOE9qcEU1eDMwQWhBQzN3TkNGS0JIMHpJTnFCTUV2?=
 =?utf-8?B?Z1kzNWs1L1BQRnhYVlRBbDBORVRtdjhMVGlRdkdTaGZQbFhNc1A2YVdHclI2?=
 =?utf-8?B?dXA5UERMOUNqOHBoVElwMzQvMTl4YjdFTTlKVGpsMXFjNDZ3aDl6R2lYTW5T?=
 =?utf-8?B?d1MySWMrVWlsakpVd2lKNTJGOTJzNG9MaEFCV1RKbDJPZ2lrWHpTQ2V5dkZo?=
 =?utf-8?B?L0FZQ3R4cE1BZEFCa1lkamdCVkNrRzRLTkxIWFdrM2hENXRQNnVoVmU3U1Np?=
 =?utf-8?B?dGhNdXlpTkcwZG04VmJIQXJMMkhLMDI4TXV4c2luMnNpRHhlSHk5L1ZYRm9Y?=
 =?utf-8?B?YjNTdGlRSGNTcStZM296d0V2Y0VoS3JEa2ZrRzhxb0VkTDRJamRvemtkbVZX?=
 =?utf-8?B?SWZXMDY3TFlEZ3NPRndEZ1pKOU5EMUFJWUxlVDh6aE9RQ21HWjV1SzJGYWNR?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E1F39AB00C6194C82FA413DE5CF6FCD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa51b5f8-2e75-47aa-65a0-08daf7abaec8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 10:23:16.9871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bYlx4EZJi2xQxydkKvFiG+l8GdB8KaKLUbMSwWVDZcQIq6EOJJA3kxoscyhschGMLh9SkBJwuotrMs3TucjbHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8115
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBJbiBvcmRlciB0byByZWNsYWltIFREWCBIS0lELCAoaS5lLiB3aGVuIGRlbGV0
aW5nIGd1ZXN0IFREKSwgbmVlZHMgdG8gY2FsbA0KPiBUREguUEhZTUVNLlBBR0UuV0JJTlZEIG9u
IGFsbCBwYWNrYWdlcy4gIElmIHdlIGhhdmUgdXNlZCBURFggSEtJRCwgcmVmdXNlDQo+IHRvIG9m
ZmxpbmUgdGhlIGxhc3Qgb25saW5lIGNwdS4gQWRkIGFyY2ggY2FsbGJhY2sgZm9yIGNwdSBvZmZs
aW5lLg0KDQpJIHRoaW5rIGl0IGlzIHdvcnRoIHRvIHRhbGsgYWJvdXQgc3VzcGVuZCBzdGFmZiwg
aS5lLiB3aHkgd2Ugb25seSByZWZ1c2UgdG8NCm9mZmxpbmUgdGhlIGxhc3QgY3B1IHdoZW4gdGhl
cmUncyBhY3RpdmUgVEQsIGJ1dCBub3QgY2hvb3NlIHRvIG9mZmxpbmUgdGhlIGxhc3QNCmNwdSB3
aGVuIFREWCBpcyBlbmFibGVkIGluIEtWTS4gIFBlb3BsZSBtYXkgbm90IGJlIGFibGUgdG8gdW5k
ZXJzdGFuZA0KaW1tZWRpYXRlbHkgdGhlIHJlYXNvbiBiZWhpbmQgdGhpcyBkZXNpZ24uDQoNCkJ0
dywgSSBjZXJ0YWlubHkgZG9uJ3Qgd2FudCB0byBzcGVhayBmb3IgU2VhbiwgYnV0IGl0IHNlZW1z
IHRoaXMgd2FzIHN1Z2dlc3RlZA0KYnkgU2Vhbj8gIElmIHNvLCBhZGQgYSAnU3VnZ2VzdGVkLWJ5
JyB0YWc/DQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1h
aGF0YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiANCg0KW3NuaXBdDQoNCj4gKw0KPiAraW50IHRkeF9v
ZmZsaW5lX2NwdSh2b2lkKQ0KPiArew0KPiArCWludCBjdXJyX2NwdSA9IHNtcF9wcm9jZXNzb3Jf
aWQoKTsNCj4gKwljcHVtYXNrX3Zhcl90IHBhY2thZ2VzOw0KPiArCWludCByZXQgPSAwOw0KPiAr
CWludCBpOw0KPiArDQo+ICsJaWYgKCFhdG9taWNfcmVhZCgmbnJfY29uZmlndXJlZF9oa2lkKSkN
Cj4gKwkJcmV0dXJuIDA7DQoNCkFzIG1lbnRpb25lZCBhYm92ZSwgSSB0aGluayBpdCBhbHNvIHdv
cnRoIHRvIGFkZCBzb21lIGNvbW1lbnQgaGVyZS4gIFdoZW4gcGVvcGxlDQphcmUgdHJ5aW5nIHRv
IHVuZGVyc3RhbmQgc29tZSBjb2RlLCBJIHRoaW5rIG1vc3RseSB0aGV5IGFyZSBqdXN0IGdvaW5n
IHRvIGxvb2sNCmF0IHRoZSBjb2RlIGl0c2VsZiwgYnV0IHdvbid0IHVzZSAnZ2l0IGJsYW1lJyB0
byBkaWcgb3V0IHRoZSBlbnRpcmUgY2hhbmdlbG9nIHRvDQp1bmRlcnN0YW5kIHNvbWUgY29kZS4N
Cg0KPiArDQo+ICsJLyoNCj4gKwkgKiBUbyByZWNsYWltIGhraWQsIG5lZWQgdG8gY2FsbCBUREgu
UEhZTUVNLlBBR0UuV0JJTlZEIG9uIGFsbCBwYWNrYWdlcy4NCj4gKwkgKiBJZiB0aGlzIGlzIHRo
ZSBsYXN0IG9ubGluZSBjcHUgb24gdGhlIHBhY2thZ2UsIHJlZnVzZSBvZmZsaW5lLg0KPiArCSAq
Lw0KPiArCWlmICghemFsbG9jX2NwdW1hc2tfdmFyKCZwYWNrYWdlcywgR0ZQX0tFUk5FTCkpDQo+
ICsJCXJldHVybiAtRU5PTUVNOw0KPiArDQo+ICsJZm9yX2VhY2hfb25saW5lX2NwdShpKSB7DQo+
ICsJCWlmIChpICE9IGN1cnJfY3B1KQ0KPiArCQkJY3B1bWFza19zZXRfY3B1KHRvcG9sb2d5X3Bo
eXNpY2FsX3BhY2thZ2VfaWQoaSksIHBhY2thZ2VzKTsNCj4gKwl9DQo+ICsJaWYgKCFjcHVtYXNr
X3Rlc3RfY3B1KHRvcG9sb2d5X3BoeXNpY2FsX3BhY2thZ2VfaWQoY3Vycl9jcHUpLCBwYWNrYWdl
cykpDQo+ICsJCXJldCA9IC1FQlVTWTsNCj4gKwlmcmVlX2NwdW1hc2tfdmFyKHBhY2thZ2VzKTsN
Cj4gKwlpZiAocmV0KQ0KPiArCQkvKg0KPiArCQkgKiBCZWNhdXNlIGl0J3MgaGFyZCBmb3IgaHVt
YW4gb3BlcmF0b3IgdG8gdW5kZXJzdGFuZCB0aGUNCj4gKwkJICogcmVhc29uLCB3YXJuIGl0Lg0K
PiArCQkgKi8NCj4gKwkJcHJfd2FybigiVERYIHJlcXVpcmVzIGFsbCBwYWNrYWdlcyB0byBoYXZl
IGFuIG9ubGluZSBDUFUuICAiDQo+ICsJCQkiRGVsZXRlIGFsbCBURHMgaW4gb3JkZXIgdG8gb2Zm
bGluZSBhbGwgQ1BVcyBvZiBhIHBhY2thZ2UuXG4iKTsNCj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0K
PiANCg0KW3NuaXBdDQo=
