Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0337001FB
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 09:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbjELH6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 03:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240285AbjELH5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 03:57:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8840E10E64;
        Fri, 12 May 2023 00:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683878248; x=1715414248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UACnbnoP44i0jyWuOE8OTKphC01Xgm2JurJmmyN6+2Y=;
  b=FVL4hNutqHB2l6xpN6HFpOShyI31jtonmeBqRdKBmCP6eYQg/rsI1bra
   dfdfW9PBNTO59WKXLsqQNnewzr9EYWgyUg/E6tIqhvZzmI4v6FEqo37x9
   6eM88kG2jWg3yyAFxE4Rz9LT5WV6FBeRnGLk/o+3altFY0GrOkiDMLr8b
   Ta0OsF1v1Mq97hsxhbUYjaV2KsqwXcff/TB1cCVmG6gZ+gmN18B6FOnwL
   PoV26ERwJmwUB0u2UQM8jwakjGq5uwACTWrKgpYCTt3+UieJ3kqe5JSTV
   hfXaptrnbYf0AQiUXehcCscmA1ipL/yeEqV0UloM/zmqo7rN15nGmz/0I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="437064672"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="437064672"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 00:57:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="874307662"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="874307662"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 12 May 2023 00:57:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 00:57:27 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 00:57:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 00:57:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 00:57:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6PvCqMA7ZwkNNtHMvt9ZZX8JkYluBWSbvuS8hi5oG1PvXD8Ghj+YDz+uRNYr16sEpCTY1Jk85sH9WpWM+7H/CcToyjbxE/RGhYcwkKjSbeSLtT5lpfbRdAD90rEBjlv1C6HRpQjju95Qcnu//l/61IPXo1CnLH4kQySPRD/LjBoBnDBimvDJrJgMQ/8J/AeFec4R3wAQ3HczWT+aP9Wgw8IzqtBcJ5pPlHKoBNxdz+jzue5jJAWAy49Zi+R0cu4Wq6fWQzbhKIyEtYP0Cfgw99/EW9PoBvF9imHUomrQ9yDeeuh0sDLFe25MfzyFHocoOvPvRKGEzGsBoRTZJCW/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UACnbnoP44i0jyWuOE8OTKphC01Xgm2JurJmmyN6+2Y=;
 b=Cyk5y8nK9IVsO3t6+/NwbeeudQg4Oaa435PuuhU7ND9PXcHbDQTvrjedkjsXARdDAYxn8gRFp2b/j/cDbzRY9q6qlFswDIwdUMv3U7jPowdDdqBnvEfMY5hC0GXyaXXeOaKLN0xwrumcfHjv/45hclBs30T/L/m1Z90bnsigwytjnt/QYw+qg5vXv1jQ6O2Frmf+4i0pImNatTp+MZYjesUa7qmaSHo9GNokmHCK7OnLqbPqp+e0nxKRXekRLbHoYZL1mevTkMEYvtOA53K3bV/RYvIKmSTSEFO0Bsb8NCd5rz1y1IWYtlBccb0m+NujOS7yugogInOhD7xpauRlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5300.namprd11.prod.outlook.com (2603:10b6:610:bf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Fri, 12 May
 2023 07:57:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6363.033; Fri, 12 May 2023
 07:57:24 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clegoate@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v10 05/22] kvm/vfio: Accept vfio device file from
 userspace
Thread-Topic: [PATCH v10 05/22] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZeFBTLnrt45ENs0aY06fEDT+Gpa9UvuaAgAGdRpA=
Date:   Fri, 12 May 2023 07:57:23 +0000
Message-ID: <DS0PR11MB75291BC4BFB6B826756D6C06C3759@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426150321.454465-1-yi.l.liu@intel.com>
 <20230426150321.454465-6-yi.l.liu@intel.com>
 <0805efa4-9376-7485-e52b-d53216f74482@redhat.com>
In-Reply-To: <0805efa4-9376-7485-e52b-d53216f74482@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH0PR11MB5300:EE_
x-ms-office365-filtering-correlation-id: ff001e5f-2ffd-4b89-f989-08db52be8587
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AEN07jXy3MBykSJr/ras8L0WM9wghihGx7Qd8uNI4Yt31SHww4PhoqTv+rgWh+vEKYWp+twTkkW4rzJC53+81LdM0jQTW4ux3hGmbqjG8f0fbiPq/f3VqVvXeSgNh0lT5I2Yv49gfMCVfueD1D82hpV97zdAgcQNBVr46t97fRunaLT6gYAe4oF07ssmjWBRpueRApuwBvb7vHC45xHvXr0rt2+6zNkFEdqWi/h3B+U+2uAj50AsgAgVmrwxj4CBmk/44aYQ1mgesiruuxFMJ+UiHpGZxEmaAZAHlVmPCdyFYNzpmLGWVjMTjy5b6ycVyIwOzQH5pWITc0P8Lv6SfTLHtFI7WoKthTTP9bKIGzIEUFbLFB+OhOttEIPuoiaR9+XZJNf8WqgnGJdH/d+09HY7v8Ronef0LLw97AfgUFJGYa/Ywh4euLAPam0cbsYGp8v664ozX2wJLfXQQ1gZvZ7C3xmG6jmjkWCiDumRdCL+qB9bqJP4mFWw9Ukrg2tyIYf4cwDM9t7aCnl0SKi9BuAif28R8nb85i9XPA1/r52bZN/tFgDt0lHZ37D5FjucQNo5mmmI2fTHVwN9a18YQlXAAVJJBGYCnbKGwi3lpG2+RNOJOujTSpM10F0+KHf2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(38070700005)(7696005)(54906003)(110136005)(316002)(41300700001)(71200400001)(478600001)(86362001)(6636002)(64756008)(66446008)(66476007)(66946007)(76116006)(66556008)(4326008)(6506007)(26005)(55016003)(186003)(38100700002)(9686003)(53546011)(82960400001)(122000001)(52536014)(5660300002)(8676002)(8936002)(7416002)(33656002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVY3emIvTVBGbktqOTl4SFVsQ256Y3N1blB2aXRuL1FFZ00rTHZxdk84WUh5?=
 =?utf-8?B?clJwc2NQRkliWjllRUJrOXZKemRVYTZvK2RQSXJYRHVwbWVRR1J3K2pmRXZ5?=
 =?utf-8?B?Q05ld2ljNFdxMkduRzExYS9ONXFMSGR1WVYvZnlaWXhxS205YmYzMzI4VkJ6?=
 =?utf-8?B?VkIyYzA3SUhrejc2MVlMQytVTmlOSHFvSzhOWkFjWnRlMTJjZS9jaTBlYUIz?=
 =?utf-8?B?RVZMS3VQQk81TnRxRVV6b2Z1WitYbWVXeGVrUkdYdGxyMDJHQ2pzV0gzM25K?=
 =?utf-8?B?eWtkODZVUGxVaU5NT0tveHR6NlQ1RWdmUHNWQlVKeDRwQjFZNVJ5Ti95cS9v?=
 =?utf-8?B?eGdWVXdZbXFHVkFoMy9wVWw3SWg2N2s5OHBzak84Y2JhZThwdWdsZGJaRnNZ?=
 =?utf-8?B?dGNreU5xK0lFeDVKRERkNVdpY05vUmNQbjBuK0pyRVdmT0dIRGgxWllnMEtT?=
 =?utf-8?B?ejlMNnNRVy9taXJ3N2drQWpSVmFkVjNqODVwSCswZWxEZWh3eWpuQnBhQzIz?=
 =?utf-8?B?c2xKUVQxSW1Tb25lSkdNWDdiVnROK1BScVdYOTZYblUwUDJIZjk4UHpGb3VU?=
 =?utf-8?B?N25sU1ZRT3o2RUpmZE1hRGNJNGwwa2t0R0JQSld4NWd1NkZkTWlBdTVLQVZC?=
 =?utf-8?B?ekF6R3BiOHpsbEYreW9uOWd3S2VzN21seTdpanZBcGhuREsraTBKWWN1OUFE?=
 =?utf-8?B?OEdaTkZyQVhsaEwwRFNFNGRRTnZPRWYvWGlwTTh5RjVBcTIxcjQ5Zm1MSkhu?=
 =?utf-8?B?Smt2M2pkUXZka3lZdkUvRko0UUl5d0p4ODY4SHRCL2h4dzNKcWk5bE1IQnRP?=
 =?utf-8?B?R2gveldxYmlESGtPNVE3NmRBdlRqRkxOOVV1eklINkN1SmxuRGtWelIzUkxQ?=
 =?utf-8?B?U3JQbnRROGtIODZScVNkbnlTd1R0dVpNNldBTmtvUERiMEZMOUVHdDBxV3N0?=
 =?utf-8?B?T1Y2S2F6SXVmbHNiT2Z4UTVvV2hIU1pwVHdHVy9OZkcyZ2FCZGhDWGFSSkdG?=
 =?utf-8?B?SWZVdUEvYmpKOGxxb05jemYvTDZmYWozWkdQQW5OeWYwY2lqelcrcGk2djlF?=
 =?utf-8?B?MTNZaGVPNWFMelk1bU5SSkk2VE1tUy9qNXA4a3NxYU9aM3VuMDFxSTlyaDZp?=
 =?utf-8?B?eXZIaUgxVzhmT0hiUCs3L3FvSk1VN1N4bnNxNUQ3YS9YVk9TRTJ1NmZ0N3dU?=
 =?utf-8?B?SDhmRHhNcVdQYlBKMTdTWWVJdlJjdWZacW9FK08rbXdBNXRHZmxHM2pLNWpJ?=
 =?utf-8?B?Y2Q3YWVrMGlNNWJ6SUk1dFVYZDV0UTJLK0crSUwrUzVDQmRiYkh1UWRKNUxH?=
 =?utf-8?B?SGJzV2V4YXNxd3hHNGI1ZWFsa0NtRndnRjNYMWo2VWZ2ZUh3UEx2Z0wvS2hk?=
 =?utf-8?B?eXNrUWphZG91SmZXZFh5bmR4YTdRZUdlWURJTkljQXMyYXA0KzBwQkNOdkEr?=
 =?utf-8?B?UDBZb0tuL01pcEl5VkNXdG1kY0U3cFNMa2ZMbElnS1YvMDFVRDZaSTZZU09s?=
 =?utf-8?B?MjZ6aGhTclorZ21Ua2dRQ3hYTmtReGxPUWF2S0xZNEVoMThFQW1WZ0JhN29n?=
 =?utf-8?B?bUd1VHpEZGQ1M2JOaVFPN1h0Q25iSjVlc1ozOWdqME9UTHI5SnhFZG90Y0NZ?=
 =?utf-8?B?UUVtS1MvbGVPakswQWpiaTA4cVBJVnpXWlJaN0RPV1JEVjdZMTJseDdjNlln?=
 =?utf-8?B?eXdiVnZZaDhkdkIzZERqdGhPUDV2dmt3NnJCemtCa2k0aWRFbUNkSm0rNjhC?=
 =?utf-8?B?WXJGbWd6aVhYdzBLWmt1aXNiZEowT1gvZkVEUmgybFNsTUFPWityK29Pa1Nq?=
 =?utf-8?B?WHQvb3ZuZ3BnMU91R05mYVNPZlJETzlXN0Nwa1pSMkh3MDYzSmhGMmhqTzIv?=
 =?utf-8?B?RUh0Tmlzd2lWM0NjUzUyYk56SUV0ZUV0cTlVY1JhRFI5eFQrV2pQZ2szVGY5?=
 =?utf-8?B?OU5RTnhRQy9kcGVxV1h0SFp1M3Q4UFd0TXZGaHRJakE1UXFjQkRMU0R1aGd3?=
 =?utf-8?B?WnFicG1ZTW1FSzJuVkRIbE9XVGZoUlU0NWI1WFZQMW5YMDdMYkRPOXgrc3VB?=
 =?utf-8?B?NnVOUm55RWFOZXJ6WTNHRmx0djBhQ2xnVDRJM3RER1pEZFBUMUFlc1Ria1l1?=
 =?utf-8?Q?gKnA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff001e5f-2ffd-4b89-f989-08db52be8587
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 07:57:24.0101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dWOMinDuSOGuszAg4vaW9Q1+/aA3CsuJaJBXgFBvxFjnp05I+hkb7JJIfyTFPcLqCI03E1Vv84Jgul0TWVH8OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5300
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

PiBGcm9tOiBDw6lkcmljIExlIEdvYXRlciA8Y2xlZ29hdGVAcmVkaGF0LmNvbT4NCj4gU2VudDog
VGh1cnNkYXksIE1heSAxMSwgMjAyMyAzOjExIFBNDQo+IA0KPiBPbiA0LzI2LzIzIDE3OjAzLCBZ
aSBMaXUgd3JvdGU6DQo+ID4gVGhpcyBkZWZpbmVzIEtWTV9ERVZfVkZJT19GSUxFKiBhbmQgbWFr
ZSBhbGlhcyB3aXRoIEtWTV9ERVZfVkZJT19HUk9VUCouDQo+ID4gT2xkIHVzZXJzcGFjZSB1c2Vz
IEtWTV9ERVZfVkZJT19HUk9VUCogd29ya3MgYXMgd2VsbC4NCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS92aXJ0L2t2bS92ZmlvLmMgYi92aXJ0L2t2bS92ZmlvLmMNCj4gPiBpbmRleCA4ZjdmYTA3ZTgx
NzAuLjEwYTNjN2NjYWRmMSAxMDA2NDQNCj4gPiAtLS0gYS92aXJ0L2t2bS92ZmlvLmMNCj4gPiAr
KysgYi92aXJ0L2t2bS92ZmlvLmMNCj4gPiBAQCAtMjg2LDE4ICsyODYsMTggQEAgc3RhdGljIGlu
dCBrdm1fdmZpb19zZXRfZmlsZShzdHJ1Y3Qga3ZtX2RldmljZSAqZGV2LCBsb25nDQo+IGF0dHIs
DQo+ID4gICAJaW50MzJfdCBmZDsNCj4gPg0KPiA+ICAgCXN3aXRjaCAoYXR0cikgew0KPiA+IC0J
Y2FzZSBLVk1fREVWX1ZGSU9fR1JPVVBfQUREOg0KPiA+ICsJY2FzZSBLVk1fREVWX1ZGSU9fRklM
RV9BREQ6DQo+ID4gICAJCWlmIChnZXRfdXNlcihmZCwgYXJncCkpDQo+ID4gICAJCQlyZXR1cm4g
LUVGQVVMVDsNCj4gPiAgIAkJcmV0dXJuIGt2bV92ZmlvX2ZpbGVfYWRkKGRldiwgZmQpOw0KPiA+
DQo+ID4gLQljYXNlIEtWTV9ERVZfVkZJT19HUk9VUF9ERUw6DQo+ID4gKwljYXNlIEtWTV9ERVZf
VkZJT19GSUxFX0RFTDoNCj4gPiAgIAkJaWYgKGdldF91c2VyKGZkLCBhcmdwKSkNCj4gPiAgIAkJ
CXJldHVybiAtRUZBVUxUOw0KPiA+ICAgCQlyZXR1cm4ga3ZtX3ZmaW9fZmlsZV9kZWwoZGV2LCBm
ZCk7DQo+ID4NCj4gPiAgICNpZmRlZiBDT05GSUdfU1BBUFJfVENFX0lPTU1VDQo+ID4gLQljYXNl
IEtWTV9ERVZfVkZJT19HUk9VUF9TRVRfU1BBUFJfVENFOg0KPiA+ICsJY2FzZSBLVk1fREVWX1ZG
SU9fRklMRV9TRVRfU1BBUFJfVENFOg0KPiANCj4gVGhpcyBzaG91bGQgc3RpbGwgYmUgREVWX1ZG
SU9fR1JPVVBfU0VUX1NQQVBSX1RDRS4gU2FtZSBiZWxvdy4NCg0KVGhhbmtzLiBJdCdzIGEgcmVi
YXNlIG1pc3Rha2UuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0K
