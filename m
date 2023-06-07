Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A759B725293
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 05:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbjFGDxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 23:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240877AbjFGDwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 23:52:53 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ADB1BCC;
        Tue,  6 Jun 2023 20:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686109970; x=1717645970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pBN2I9cl10ew0jK9Fj/q9u1e389f358zdRRAqRBndPc=;
  b=ZgomuDxbQHoRj8s6WKNiB+/RJDh+xwtgBWm6jvoBbmkMVP3mqAlHl0bo
   k7Kz1u1b5tWQBma50bLxpgq9DRxC7qA2a7csRj57M4CZnIKy5/eVIH/Ih
   ycQE9U9gtJpTuFx4yFNIz82VCb2QcLzYFdDgs2IvaYBk1/DOYMoTPeg3b
   v4B7bTaIk9ZMnkYe2qiek9aB5EymsyavAHtxsaHGApWa/pn02UeAxuXoy
   V25AJo82oYMdzqgKkz7+Fsas1CWOpxfDNHQW1o+SLF9+y39iDUmRuuYUX
   1Dgz4UKw3yMRMY4fkuJ1fWcVPhZ6vHegmoq5azOpA2kEmcjPDeUrMPD0O
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="385186260"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="385186260"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 20:52:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="799125273"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="799125273"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2023 20:52:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 20:52:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 20:52:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 20:52:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 20:52:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8hiNde5qo1eOFyBbY9Tgq8JWYfPczdFKQ3jGovIiZ/4FNfmO2JPP3ft2W66jgABXRBhx2gQSjaF6rKyl0R1+W3jo0+LB+cazvM5CKQAq6WppG7pHO4jHy4zB4RhL+U+rE1axoaBvzaSMErkOEyJbHr9ph0dc8DHuIXwuClJ9FWZOjrDrUi4upunEkfaFxtT8blgR5aNERx6gIqLXCgKS46AWeVS82oCrkIF+rZuPGGDW4zO3dinJVok3jMLWf6SkzPuEWZXyXCMYaA6e7wi/LKJpqOV2WlqqTuGbpT8hYtz+Y3kPU6XTZFdGr5ukyBzu0cHQeAraeUP/Tuqi6qqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBN2I9cl10ew0jK9Fj/q9u1e389f358zdRRAqRBndPc=;
 b=ThM/3Zvx5l1AZyGtsTosJ/QI+5HSZXRZph1jaGGGoWTYskylcPGOKrtKRW51YgVKrvkIrO59iFPfFc0Ngr93wOuCJ53ITXfi4Z4ahvxbRT3uro19AXH5uxYCwsqbMl+Eaz/834s313zxem6ecdj6SDWBLBtQ1nDs9dh2N4i07CoFCnkMb3cTLwNc8tH0atId3Jt8qz9pjPni6UwkQczNbOOazz9Y8kFUWwgofX8CrDopbmkqp2CXAkCkZErBqSayLLcHH8mDJb5bH/WXINLyoIM/gPH70dPI4ofwlNdUOI1FGDA/v2g0ApXgByx6fMwO4ZhdiDp7BLZjGEF6d7YiuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6505.namprd11.prod.outlook.com (2603:10b6:208:38c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 03:52:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 03:52:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v9 6/6] KVM: x86: Expose LAM feature to userspace VMM
Thread-Topic: [PATCH v9 6/6] KVM: x86: Expose LAM feature to userspace VMM
Thread-Index: AQHZmFf0f519KI4Y6EKS7daQM/b8Q69+tlaA
Date:   Wed, 7 Jun 2023 03:52:46 +0000
Message-ID: <e019ba47ddadfe4aec2f11e7f0b360f0bb352180.camel@intel.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
         <20230606091842.13123-7-binbin.wu@linux.intel.com>
In-Reply-To: <20230606091842.13123-7-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL3PR11MB6505:EE_
x-ms-office365-filtering-correlation-id: 606fc153-f97f-4791-78e1-08db670aa7a2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BCbNvGkH1Ge5doDIdUVQMuB0ZS40v5oRnXH5DJUchOUK69BTpcXujjiQyLztVFdxbO2YvWBru6BEPKZ6oJVQJsUuKkeBZ1MUMO2RHxOHCJm/pzLfIrXufusiUiPmyBupDJe61uLD9JAePI+MQ5LfSS55ofvdvWC/aB9mcxig5viHzT9FojRbOFL0hQ6tbDQm8/oI6EVhbH7zmvsrW7KUoC49UgvRNYKF/7neM4Z3JlwD08iWu2mTbn1U0L+vM+mH3DXYeblmptnhwESvKVd3lqsgGuSkBACgvyTUaJa2jeaAUb5XqETg5B4k2s9kOyM6SNFXU8nc19Ms3LInsHoWRMh4+d4edZF4je1rKdzbjlkTDOv2aYAz3v6byOjHoa1s85NilQosGCRa9hLVt6VWXRevnAy4nslbsnSpruy64XpIlXy2zTrAz7jhp/xCIJiv+Wc8ELMm1vG/X/F6S9f7y18PODceamJH9oE9/W7OD+xPx+S+c0zRS5HcDD++3i0BGG62WEqrlxxnoj6NTILqTT36lAp0sfBLeHXkzL48KijRClX0G+WI6tfE446lQiMcDOl/tYLjWGgaX6g9IlwhVLnIMvJwEpaLY8VASQ2xWYJLg45anTZrbSg1HjCmFOI7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199021)(6512007)(6506007)(38100700002)(2616005)(41300700001)(6486002)(186003)(26005)(83380400001)(71200400001)(478600001)(110136005)(54906003)(122000001)(66446008)(91956017)(66556008)(64756008)(66476007)(76116006)(66946007)(316002)(82960400001)(2906002)(8676002)(8936002)(5660300002)(4326008)(86362001)(38070700005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjFCVFBKb3Q4SGRUWGEzaytpRU5MMXVUeHI0QUIxcVNtYlIyV2FnbjFLNUg0?=
 =?utf-8?B?dzJSTVE2OXE2UEQ4NWdYRXhmZXRrV1V5U0dsc2E3d1dVd2JTMzFEYnJKMUY2?=
 =?utf-8?B?S25IWklxeUp3S3RuWlVNSG0yNmVuYU1JL0pRMkdQRGxMVVlPekMyVWJtWW9t?=
 =?utf-8?B?SEtWSnN0RThDQlIrY2JLTHhyL3ZiT2hrNDlBVWllTlRhWlcrRmZBWE8zS3NO?=
 =?utf-8?B?SEFqT1h1MjNhRGdlQ214b2p4ZXZBYVN3Nis2dW5nNjhIS0xTUTlCUzI5TGlh?=
 =?utf-8?B?Ti8va2VlZzg5TW5ZVkpJMnlRenExazl3azRhRGtnQ2svTlhhRGNBeTZJS1dq?=
 =?utf-8?B?RExkTXgwc3dCMHQxeGFuUHZwWmFVTmtvbkxZUEFSVHBYTUpnQU5ENWdwVG0y?=
 =?utf-8?B?R3pRY2tMcWRIeVBBQk9YQVV2U0s1cnRqQmcxT3FjRkMxenBpWlptVG1jMW8v?=
 =?utf-8?B?RlkyNlViazZXblp0aU5pTDdNNjVJSG5vSk5pdGhaMjRiZEFwRGtRYmRTRWw1?=
 =?utf-8?B?d3NxN0hVZXg4Y3RYZFhKb292L1lQUW4wN0MvdTNZN3dEQ1g3KzVoSGFCN1Yx?=
 =?utf-8?B?NzMyK3U3bktuckphUTZKQmNQU0NQMitWdE4wU1EvWENTVUZlM0lNNWZuME8x?=
 =?utf-8?B?UXZpejBJRkJBeTJsTzJsZ3VjUGlZRnFLdGxYbW1nalUrZWdVNFVjamJZZ1Zm?=
 =?utf-8?B?ckw5aXdOcjlSN3FiQVNKVHdVODlhSmpycnZYbStuTU9kQkhWNURsQ2cvR2FB?=
 =?utf-8?B?NTd4eXhrV3VPcmJpWG8vWWdBQm9WUFV0eE5mVnRVSEw3bGd2dTAvVVBsc3ll?=
 =?utf-8?B?bWMzSXdEbk11bXlLcVN1cWJ1ZWNwK002UXRIVXdvdFNFbmxvTy9US0xKM1lS?=
 =?utf-8?B?Rk00bFhEVTlsazJzS0JnTXI4VndUbUplRDZBc1F0a2t2cE9hZ3NlUnd4aFFQ?=
 =?utf-8?B?Q2pVaUpzMGFRN2l4eDY3MDFxQ1JoUi81OUR4QWdYMUljMTROMHdQQ0dpV0F2?=
 =?utf-8?B?dWhNNDN4aGNaclBzakJLRkZKTnl1UytnZWRiSFhxdkdsNGh4QmxFeTRDZUh6?=
 =?utf-8?B?SlBSd3BhVks4K0psU0JvVmF2UXF1MjFrUHU1Q3krUU85YXptcUllc3d6OXlZ?=
 =?utf-8?B?Y2MrcThzRDBwdUxGeitZQTJIQzltTlBoN1BMVm5Zek1SNjdaVFMrSXoxYXUr?=
 =?utf-8?B?YTV5N1dPaWRtRGtKcEFiWFlidnpjMzhLRVIyeWJrRnZpeTBXZlZJcURudExz?=
 =?utf-8?B?RU1DSkFlTUMrWXJWTXpCMzI0RmI4T3BsVG1RbmtaSEt2SGxZeENVTkM4dlBi?=
 =?utf-8?B?Nm1ibysxbEdsN1ovZmdMS1hSUXNaU05jZEpjZk5aMFJMNmFUc0xaMURUYlho?=
 =?utf-8?B?TzI4QjdmUEJRQzUwUnRqLzhQMDJOS24weGRveWFXRmQ5ZFZyVUZIVzA2MXd6?=
 =?utf-8?B?SnRJbm42Tnc4dFNDdk5qTDRwNFpjdmdOTlJmZUcrMHJVSFM1Z2Z6T1IrZzR3?=
 =?utf-8?B?c2Fkdi84L2JIdFZXaFJRRk1ENUhkVW5zaTlLQTJRd3BicnpZNnhieGNWOXQr?=
 =?utf-8?B?alN5Y0FzdHA1NGMvQmtXZkJpbVE5WWJ1cmpJdkducDg2TFUvM2phTDVoR0VY?=
 =?utf-8?B?eHEwUktkTUdlSUd0c1FubEloaWdyVXI0R2w5T0dVYmExQmNGVlV0OVB3Mkl6?=
 =?utf-8?B?SVBZU2pvdUR0TVdMMVFHTHNDRlllN1dhWlBIclcvT2kxckxLNWtidEYrSjI3?=
 =?utf-8?B?YVU1VjN5ZlhXdTZBKzlqeTJWODgwdmZ4T2hYZUpqUkozeE4xQldrSE1YSTNq?=
 =?utf-8?B?bnlMeElxTGt4TTlSOGp2OEVpSWNrcFpnK2hDOUVWWmUwdXRYQklZRytEYjM5?=
 =?utf-8?B?VmYxb2FQWjRPRDRjZG00NUZlWk44djhUK0dCRzFpTndTNVhmL21wM2pUZTVq?=
 =?utf-8?B?eEo4ZmcrMFBtRFBhbTMrOUcwMzYzOFlTam54UlJOZ3VqWUowNmx0SnF3ZSta?=
 =?utf-8?B?OERGVWg0ZHAzc0pSR3ZqSm0yY3RyM3lTM3RKZ2dQN0ZUUmdOVnhTOEo5NC9m?=
 =?utf-8?B?dzZZOUIwTERuZ3BMRlROZzY4bEdSSXhJWHlWWXNDdVZOQXdRVitzWWdUdXRn?=
 =?utf-8?B?MWd2cGl3cnMxUG9KWEFKZjZ4THpXaDJFN2hZaHkwQytEVGJvWU1QQlJ5WVEx?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87C649C896E0AC42811C008459BC0AA7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 606fc153-f97f-4791-78e1-08db670aa7a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 03:52:46.2618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dd0b2vd03ak2nNhzJ0FzfEMr4vRrCmwFvvhRIg6j5MruKauMbK1abWlSqJm9nbTyB3oZCJ6k/jSYJO28tlYNzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6505
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTA2IGF0IDE3OjE4ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEZy
b206IFJvYmVydCBIb28gPHJvYmVydC5odUBsaW51eC5pbnRlbC5jb20+DQo+IA0KPiBMQU0gZmVh
dHVyZSBpcyBlbnVtZXJhdGVkIGJ5IENQVUlELjcuMTpFQVguTEFNW2JpdCAyNl0uDQo+IEV4cG9z
ZSB0aGUgZmVhdHVyZSB0byB1c2Vyc3BhY2UgYXMgdGhlIGZpbmFsIHN0ZXAgYWZ0ZXIgdGhlIGZv
bGxvd2luZw0KPiBzdXBwb3J0czoNCj4gLSBDUjQuTEFNX1NVUCB2aXJ0dWFsaXphdGlvbg0KPiAt
IENSMy5MQU1fVTQ4IGFuZCBDUjMuTEFNX1U1NyB2aXJ0dWFsaXphdGlvbg0KPiAtIENoZWNrIGFu
ZCB1bnRhZyA2NC1iaXQgbGluZWFyIGFkZHJlc3Mgd2hlbiBMQU0gYXBwbGllcyBpbiBpbnN0cnVj
dGlvbg0KPiAgIGVtdWxhdGlvbnMgYW5kIFZNRXhpdCBoYW5kbGVycy4NCj4gDQo+IExBTSBzdXBw
b3J0IGluIFNHWCBlbmNsYXZlIG1vZGUgbmVlZHMgYWRkaXRpb25hbCBlbmFibGluZyBhbmQgaXMg
bm90DQo+IGluY2x1ZGVkIGluIHRoaXMgcGF0Y2ggc2VyaWVzLg0KDQoibmVlZHMgYWRkaXRpb25h
bCBlbmFibGluZyIgbWF5IG5vdCBiZSBhY2N1cmF0ZS4gIEp1c3Qgc2F5Og0KDQpFeHBvc2luZyBT
R1ggTEFNIHN1cHBvcnQgaXMgbm90IHN1cHBvcnRlZCB5ZXQuICBTR1ggTEFNIHN1cHBvcnQgaXMg
ZW51bWVyYXRlZCBpbg0KU0dYJ3Mgb3duIENQVUlEIGFuZCB0aGVyZSdzIG5vIGhhcmQgcmVxdWly
ZW1lbnQgdGhhdCBpdCBtdXN0IGJlIHN1cHBvcnRlZCB3aGVuDQpMQU0gaXMgcmVwb3J0ZWQgaW4g
Q1BVSUQgbGVhZiAweDcuDQoNCj8NCg0KT3IgaGF2ZSB5b3UgZm91bmQgdGhlIGFuc3dlciB0byBh
Ym92ZSBxdWVzdGlvbiB0aGF0IEkgYXNrZWQgaW4gcHJldmlvdXMgc2VyaWVzLg0KDQpBbnl3YXk6
DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IFJvYmVydCBIb28gPHJvYmVydC5odUBsaW51eC5pbnRlbC5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IEJpbmJpbiBXdSA8YmluYmluLnd1QGxpbnV4LmludGVsLmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IEppbmdxaSBMaXUgPGppbmdxaS5saXVAaW50ZWwuY29tPg0KPiBSZXZpZXdl
ZC1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCj4gVGVzdGVkLWJ5OiBYdWVsaWFu
IEd1byA8eHVlbGlhbi5ndW9AaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS9jcHVp
ZC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2NwdWlkLmMgYi9hcmNoL3g4Ni9r
dm0vY3B1aWQuYw0KPiBpbmRleCAyNDFmNTU0ZjE3NjQuLjE2NjI0M2ZiNTcwNSAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYva3ZtL2NwdWlkLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL2NwdWlkLmMN
Cj4gQEAgLTY0Myw3ICs2NDMsNyBAQCB2b2lkIGt2bV9zZXRfY3B1X2NhcHModm9pZCkNCj4gIAlr
dm1fY3B1X2NhcF9tYXNrKENQVUlEXzdfMV9FQVgsDQo+ICAJCUYoQVZYX1ZOTkkpIHwgRihBVlg1
MTJfQkYxNikgfCBGKENNUENDWEFERCkgfA0KPiAgCQlGKEZaUk0pIHwgRihGU1JTKSB8IEYoRlNS
QykgfA0KPiAtCQlGKEFNWF9GUDE2KSB8IEYoQVZYX0lGTUEpDQo+ICsJCUYoQU1YX0ZQMTYpIHwg
RihBVlhfSUZNQSkgfCBGKExBTSkNCj4gIAkpOw0KPiAgDQo+ICAJa3ZtX2NwdV9jYXBfaW5pdF9r
dm1fZGVmaW5lZChDUFVJRF83XzFfRURYLA0KDQo=
