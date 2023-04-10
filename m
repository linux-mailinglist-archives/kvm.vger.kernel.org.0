Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620A36DCC4C
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 22:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjDJUwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 16:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJUws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 16:52:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8D119AF;
        Mon, 10 Apr 2023 13:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681159967; x=1712695967;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o7592GP0d+ZX0nLPkthYH8jlKQByYJ4A9zaWWGcST4Y=;
  b=lk24EaMOBo49ozfpHUgBmri/3Kg/ppMegJcYPzTAZLSP2EGhxYQIA0Tk
   6VvqUAcBmWbNngaFBpB+P1TSr6iUZ5pFIaMgN9AuAwmQGo1Vcp9IVOgP6
   QSwCJN+CM5MrsHUtqzhrl3Fzo3SrfyDRUrz74jifURXt6OocGmAsluxZc
   BDL985QGQRoVGCrqah4YiJ3Vcr78weJQEE3DUS7yVy5by16DA5yeDBBnO
   Kg2RH98RqZYvNklLTZCqij6XBce6vcuTM7qxyggbkfmZmJmCaQFRLYLjH
   38hYSS4X1w9hNbWi4TrcxFuiOizVglpfsUvnPhh/39gBi6/Xgby0140b4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="327547150"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="327547150"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 13:52:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="718711265"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="718711265"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 10 Apr 2023 13:52:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 13:52:46 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 13:52:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 13:52:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 13:52:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWPgECrv/PlzOQiU+gZdqN6pzJ5KNi06xGdG53PAybddLb6peIh+JjPCRcu2Z2C8Pdt4aeUkDnqAAsCXhnghHbtpjh1aLTPCrCbk5NGWdQvLG2Yd9oB2wiBDtzwtbxzNhuPsna8Mm2+U3DGRI1fSA+wHc1rncv+IykR9/uSy3z+LRYY022y+fAcRxPU7NgLeraW94VgmOFtyLT/wGdjlUzpVNvQLhpHayKJ02h856u1KNooTDuZECG3uSeBkBN+y4IhGguaMGdYXlfsaeLJkG9uwwcX39P1s9M+GWOWAL8EXs66vy7nfu4zINg9GDRVipQ3+7i44oLA7olFmP8gnBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7592GP0d+ZX0nLPkthYH8jlKQByYJ4A9zaWWGcST4Y=;
 b=AKWNpgDxDPN8N7Z/zwhX+fhwbO9UcwIkKfFblEfURv7uVMXxYXx/cpu8m0+0l7mtkBBPZnEUepfB6cYWZupaEnr8OAndgw8UdSwjR5j7HhVRk2UwX6qtJpcJMG18R+B9VwLAgjUK9em3hLx7VYH45hBKcgaLnYCcLJ0sL1phbJEEs1K3daRpXt3mHD6J9yYIw5wqJ174Ol6sJzHwUiLdbuH04WjU2yESGKkQT71fp7JOjmVKyv7o0p659iFfsn4SvHHPAgbUG/w3R6mccT1gumK1XD1kvbf7IBf1LVdXaHzrCsxkNZOPu1hcnelnIOy1zzOJojPmJUKBM5K/TQCCOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by BL3PR11MB6388.namprd11.prod.outlook.com (2603:10b6:208:3b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 20:52:33 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%5]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 20:52:33 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        Borislav Petkov <bp@alien8.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>
Subject: RE: [PATCH v8 00/33] x86: enable FRED for x86-64
Thread-Topic: [PATCH v8 00/33] x86: enable FRED for x86-64
Thread-Index: AQHZa4g5E/QemdFnfket3mQeyiRQG68k3+WAgAACSoCAAA0+AIAAAZMAgAAT6FA=
Date:   Mon, 10 Apr 2023 20:52:33 +0000
Message-ID: <SA1PR11MB67348E971CE0137282087809A8959@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <f3b12e7a-3536-c0af-2c67-d94c56b6fcc5@intel.com>
 <SA1PR11MB6734C0AE97E8B5ACF70CA32AA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
 <20230410193254.GAZDRkZjBURP9BydHB@fat_crate.local>
 <7d2be935-848d-4b6c-80f5-053db5141a33@intel.com>
In-Reply-To: <7d2be935-848d-4b6c-80f5-053db5141a33@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|BL3PR11MB6388:EE_
x-ms-office365-filtering-correlation-id: b6c4b261-5045-45a6-1852-08db3a05822b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 17Vc7Rz+RfRoCYSi4MG/i4Y2yZB3ObEeF/xfHDlZ7+NS9vRGpxhkHYklFhUYY6ndldoZQ35gTbip39HEIzJ8c45ARfcZzyAvZUhfo4I8mrasWEy314WLwLY2FjapzW6zsnYbJmZ1/aGvuQTm16s3d0aUMM3fBuTl4cqrheGKhb+C2NtgOaxy/p2QGWoukkaQg0lz8A68WhWjVwKw9ZkYiK/ucHATKAY2uMCt7V6YbPZcxqJguRjrsNv9oc1UywjNqLI5v9RqhKsaRJkXPHVnDySVBsVYkd5LWAmr6/j3HLXnqyieOtcS3rtGEqwliKSDo8k60tgIq7pQhrvLXF42gohVAe7kmZFwKKa1sRSzHWzDy+vjw5dwqru0+x3nKQ8JCgnrSYBKcpbSHLLm2W7+lCXmIkdmWKi+GgTSKe/GA5SwrI+v5GdBkz1wL+ukH7CWymoFC3D/RJnQC8E24DRCbDag2qqRigzjlgHLuU3+8TWkbCHpS681T2lkbxZtPhurh7X5C71aW5BSdrQjnlO7Skv8F7RNRQqH95Ab7IU+PTHfba46CQm2AdFluIZgzfRjvo3PxjS/bi83PaIDBqWudnCPjZV/RDpUAVoSNS7+NKA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199021)(7696005)(478600001)(71200400001)(86362001)(316002)(6506007)(110136005)(54906003)(9686003)(26005)(186003)(966005)(2906002)(4744005)(66556008)(4326008)(76116006)(66946007)(8936002)(41300700001)(64756008)(7416002)(5660300002)(52536014)(66446008)(66476007)(8676002)(38070700005)(38100700002)(122000001)(55016003)(33656002)(83380400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUM2eTRMRk43cGxSNUFRM3l0ZHdJbHRqcWJlWGxqbUdGOHA4L1RpUjhIN0Qv?=
 =?utf-8?B?dmhLK2xPR1pVNDllNXVyVUNEcDZjUjJOSEY4d0c2Rk0xOTIvbktoL2wyaE84?=
 =?utf-8?B?UjkwUGVJSEZiVzNhRHBBYU8vdnZFbXhDOG1BQzVHZ2YxYjZQNjZBUFVoWE1r?=
 =?utf-8?B?cWxYNG9lSVZ4NnZ2RkVnMTBMVDJVdG1GeE5Ca1J5K3VWN0J3bEFndUhldk03?=
 =?utf-8?B?T3htaGxwREQyK0REdi8xNUFvQ2h6MGpQUU8xVlFEaUwrRTA4YTlHMXBXdnh6?=
 =?utf-8?B?c2UwajBvYmYwSS96cGszSXhGZ0llc0NSbld6bGxYM1RuVXBGR29TSnkvSmhN?=
 =?utf-8?B?aC9DTFZsSXV5K2tCWHQrbHNhTHZncXFVT3Vpa2FvaUQwZHRYcEVhdXgzd2k4?=
 =?utf-8?B?RXRFV3dETHhCLzFtdWZhd3JVQ3ZtcmtFRC9wTGZwQ1NNbkN2cVlKT1hReXhE?=
 =?utf-8?B?V3ZiOXBKRUt4d3NIaTFRSTZVUEQvZFVsVXdmZHdkZk83a0FSVDdJQTQzbE5Y?=
 =?utf-8?B?cml0bzlHaWlIQ0lmVHV3OVFGT1ZCUlBNYVR6QzRTMStTempwU2R4c3ZhNVdL?=
 =?utf-8?B?RXRyUUFsUjllenVBZVQwbGhKcXkyMW1PZUx5MnRReDdXTzhrQ1N4TE4ybXRw?=
 =?utf-8?B?U2krekFDTWRyV1ZRU2hpVDR4b3B4ZmtKeEdLOXJRUkxDbDZnOG5LVWkxaElL?=
 =?utf-8?B?YUxZR090Z1gxdHFKMjJPV3FVYnFvUFkrSm9lbitLTzFhUGRkMjFZWFRRRG5I?=
 =?utf-8?B?NFcyT2FWWGQzbGRCTkwrSXZDTlAydlpReUMvT1c5K2hxMVJ6SDdMNk53LytE?=
 =?utf-8?B?N05ySHlWT2s2TENBT0ZxQkc4YmZobnZ1MW9rY2N1akVsMkZRb0R6Sllic1lk?=
 =?utf-8?B?Qkg0UVQxVWloVDQyMlFtZDBXVmd3Ujk3ZnRMTXB6eUVsNXVraTlQZTg3L0Fl?=
 =?utf-8?B?S0dXQlcySWYveHNUQzlEN2Z4aTI3eUltOStpQ0NHSHNRWHJjWkd0QVFtbnFM?=
 =?utf-8?B?Ry9DOEVvS0RaWm1sTDVKUER2SlpKemJPckdGY1ExZ2IrZzdRUUlOWXNYVXJZ?=
 =?utf-8?B?eXZhUHlORkpCWFhxME1qZ3hqT1B4b0dGRmlFMDhrbFlNS2FUdTRsdDE0dlRx?=
 =?utf-8?B?Y21EVXNZUTA0cVc5QTYxRzFHRWdKWWk1aVVPRHVpbGQvL3NRZVZkQ29ZUmFh?=
 =?utf-8?B?M2J5U2xCRXNsbHc4K3F6UDdRL29POUhvaHRBYzRrOTZNT0N5YVU1ang1MWkw?=
 =?utf-8?B?VWF5L0RLOXBHeDIxNDRISk9KZm1PN1RPdGZ6OXNtVGxWY3oxYTk1NDFueDJq?=
 =?utf-8?B?eDQyb09SMlRzRi93YnhGaU8ySGlJNmRrYmZMVjcvTlhETFNjd21tYm04Zkxj?=
 =?utf-8?B?bFlGb28vQWZyaXlud2VTRXBLeExjc3c2RTVnaHBkVUJoRkg2SzZwZGRvMy9U?=
 =?utf-8?B?SHp2S0ZkNXI2OFV4bkVGYll0VmdtajZBZmtwcS9MVjdReUxvak5VbVZjbWtt?=
 =?utf-8?B?d3RRYWZJUi9DUk9HRkliaVZBVHNrdUU0ak1VMHVON1k5cG1nVVFLVXU0R1A2?=
 =?utf-8?B?UVhYeFV6eE5aYTBHKzR3TitzVkxlVkxFd0ViWDZWSHBBYmlGNHVHUlloVFRM?=
 =?utf-8?B?dzBrbFA1VWRhNWkya0IxbHdXWTRWNCtzQjg5dHh6M2xUZ2JURDlKQTZ5ajhh?=
 =?utf-8?B?K3dmYjJ1U0QvT2NGaW5JYmgyRU5LRGdLbE9oOVk3bXNXZVdQTktSVngzc1VE?=
 =?utf-8?B?R1pkR1A1bXM1U2pJQ1g4RlFNS2ppWVZNUXJ2Nm4ycXBaVWpseGVWOHRxTFV5?=
 =?utf-8?B?MmE3QnZ1REFXN2o5aHFkdHNyRmY4elFFTUw1dUNUUlEwZXBoTnRBb1lydEh2?=
 =?utf-8?B?VVd5dzdvOWFNYy9XbFQ4Y3pXMzkwSzJMaGtmdjVKWjNZQWlMd1FOZlZlLzRG?=
 =?utf-8?B?eERMQjVqeXpGWFFMaHdUcUI3amkweFRBOURlaUNBSHNBUWtQTmRtL1ZURDhs?=
 =?utf-8?B?ZUNFangrdzZvR09aVzdqQ1BWMHd3bmtXNnBFYk1qbmsrRVQ5YldMT1ozYkVt?=
 =?utf-8?B?djdjTWQyRko5SkNBR0Y5c09SK2M5UlpUY2MrMWJ1NFlBVU9TVHIyUlh0NGF4?=
 =?utf-8?Q?w6RY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6c4b261-5045-45a6-1852-08db3a05822b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 20:52:33.5413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: itfm4wKTt3E3R20HHmijXR5nkcLdCLpENsl62UY33nKe9gu4iNbBeUcR2qRbuahEkNuqXDH2heGDuRoA8qSzrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6388
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IElzIEZSRUQgaW4gYW55IGhhcmR3YXJlIGluY2FybmF0aW9uIHRvIHJ1c2ggaXQ/DQo+IA0K
PiBXaGljaCByZW1pbmRzIG1lLi4uICBJdCBpcyBhbHdheXMgYXBwcmVjaWF0ZWQgd2hlbiBoYXJk
d2FyZSB2ZW5kb3JzIGNhbiBwdXQgYQ0KPiBzdGFrZSBpbiB0aGUgZ3JvdW5kIGFib3V0IHdoZXJl
IGFuZCBob3cgYSBmZWF0dXJlIHdpbGwgc2hvdyB1cC4NCj4gSXQncyBncmVhdCB0aGF0IHlvdSBz
YWlkIHRoYXQgaXQgaXMgU0lNSUNTLW9ubHkgZm9yIG5vdy4gIFRoYXQncyBhIHN0YXJ0Lg0KPiAN
Cj4gQnV0LCBpZiB5b3UgY291bGQsIGZvciBpbnN0YW5jZSBzYXkgdGhpbmdzIGxpa2UgKGFuZCBJ
J20gdG90YWxseSBwdWxsaW5nIHRoZXNlIG91dCBvZg0KPiBteSByZWFyIGVuZCk6DQo+IA0KPiAJ
RlJFRCB3aWxsIGJlIGF2YWlsYWJsZSBvbmx5IG9uIHNlcnZlciBDUFVzIG9yDQo+IAlGUkVEIHdp
bGwgYmUgYXZhaWxhYmxlIGFjcm9zcyBhbGwgSW50ZWwgQ1BVcyBvcg0KPiAJRlJFRCB3aWxsIHN0
YXJ0IHNob3dpbmcgdXAgaW4gQ1BVcyB0aGF0IGFyZSByZWxlYXNlZA0KPiAJaW4gcm91Z2hseSAy
MDMzDQo+IA0KPiBpdCB3b3VsZCBiZSBuaWNlIHRvIGtub3cgdGhhdC4NCj4gDQo+IEhlcmUncyB3
aGF0IEkgc2FpZCBmb3IgcHJvdGVjdGlvbiBrZXlzLCBmb3IgZXhhbXBsZToNCj4gDQo+ID4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vMjAxNjAyMTIyMTAxNTIuOUNBRDE1QjBAdmln
Z28uamYuaW50ZWwuY29tLw0KDQpHb29kIHBvaW50LCBJIHdpbGwgZmluZCBvdXQgd2hhdCBJIGNv
dWxkIHByb3ZpZGUgaW4gTEtNTCBhbmQgdXBkYXRlIGxhdGVyLg0KDQpUaGFua3MhDQogIFhpbg0K
DQo=
