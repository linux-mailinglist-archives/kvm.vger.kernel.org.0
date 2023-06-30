Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13F1743900
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjF3KJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjF3KJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:09:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7931FC1;
        Fri, 30 Jun 2023 03:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688119772; x=1719655772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IEX0F48cRmw5Ru7VKQLdfDpbzYJ2o6FGR3t7U5OzEFQ=;
  b=gTMMlMhEQJ2jZbyQRDRoqKlrqjJS/ZblBD9XCeJvaVX0VomwPVghR/aQ
   qQUHIkqP9YeG20rK40y6ePKc9vBYxm4VmDkQfMT3nRa5BwdfSAkwP/o/i
   I1MdF617WpMUyZWqtKccgXihkd/Ku564yE8ZFz3rqOtd1I0AvuH4cYXlz
   QrOene3In7QtQCoi9xzSwCr+qao7iqtPDjK7JjZQrF3l3PwlMEsKFPIzY
   ZzYZ1sjK2tMtB3nRTiq2VPdoqPF2KLPFsF7nA0xizgcDvuEy7EXSOL7aF
   xtKc+4JdECkTqhBPLe4SpzWXRZ3riE30tQChm89k7Ibr6CRkDotMm9sSf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="359841114"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="359841114"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 03:09:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="1048173880"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="1048173880"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jun 2023 03:09:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 03:09:15 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 03:09:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 03:09:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 03:09:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gz5zTb3CNiecKufAtdiTsNKzEO0lx+zlzD+P9Dq8QHZYX1YgYps02kcnY465st1LBGq3BOKAUTkdhtYr2FwE1a6O6ZfJ3YLbrJXa4SaGrh4OL3Pl9MTWYFkbe5u8bObGYkMDKvd9HTf4lcZRMnMgW7AE5Dd4vM4JYwCq24u1DujucwoFEj1HSAB1YbdjjrCOAvzy4Os9rN2eQv10b+nIYmA+PzsDcbgPvknQBNggJuWvuKxMPE63pU2D63M3krdYzbiULQ5b4lOcoFlIijehxKdxNIth+YpKBtXMZPQIg+lBHXGideAi/aF4djOahZk1ZsnU1dDohMQS0+53lvFa7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEX0F48cRmw5Ru7VKQLdfDpbzYJ2o6FGR3t7U5OzEFQ=;
 b=N/UPErEzJX0jPOc/LS7MRbbrXQJPJkhRv9ZBD7dwFr+m5VRf83FSFh2MCX7GMnE5iPLm8NXHNd6TNFDOmMYIh9cU7woZCwu9Naca9VnKakEtyzyWTKDGdm3qPjA3d4k9v8lQZy9DCOrVp26YPvrS07JFYf9cNY8P7inRG4mOPPwPa9nFdGbHgCdnUfAqz/wbeh6GRT2Hno4w2WMvRiAOQ9ZByc3vnn4Z1r0bcGygKIEvGDvLpSbok1cYeW8dXxQXGDiSm6TWacMnFxpPoRnU9vGRPPrOCzj3aixckHxW2Fc2JPZ5FqN08ERfqlW/CRA76Cc0EvKbAsEZfJ8Nzg1p9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4582.namprd11.prod.outlook.com (2603:10b6:208:265::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 10:09:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 10:09:08 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+eaRwAgAAMPoCAAB1NgIAArPYAgAAey4CAANwJgIAAsqsAgAIrRACAAA0BgA==
Date:   Fri, 30 Jun 2023 10:09:08 +0000
Message-ID: <716cdf73799a5322cbe34c7f23d582f8a3ecf301.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
         <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
         <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
         <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
         <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
         <20230628133541.GF2438817@hirez.programming.kicks-ass.net>
         <03def8b40a7db14f31d2ad67fb1a201e8ae8bce0.camel@intel.com>
         <20230630092232.GB2533791@hirez.programming.kicks-ass.net>
In-Reply-To: <20230630092232.GB2533791@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4582:EE_
x-ms-office365-filtering-correlation-id: 197f3726-afbb-4ace-d2d0-08db79520b3c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RoXihyVeFDrF/xQEgTJAV6Kb3GIqApZxd8Hfu1zbXQkb5Aj22hXEXO+ygh6MjEvNVh60htTFqmZhYlq7yzPaLwG2+dRqMUfuGyPRhzwuZ1Gluc7P66j9hqWEkoKhJkab4OgPN4tlTW74dqHz8XKIlo5ZYPhQxSRBIjxTjo8OLWFL2gWiwRhrEoyFZ1C6xy4txrqUPOQV3rhczwVLJHsEXNJVGB4FFN5wvyv+Bt3L/7y21EJ0+ieJOWrihbNI3TPlAyjPDbIciX9FZaj0FcuD5mmQ0wMRYOkAxnTQmYlXTW59Qb63Ije1Dcq8kQ1664VvEXR3rJBY/6TDPCgvc1fpbzWmNcpeto+gYQtuZbaAlvzMDP+fhqW2o66NrBOCV5AcBQe4Y981kZUyrPKUXQ3zaPfN+nRIW9DGP5VfdO0ISKVrpwp9TN3DSEVt6JKzVSfgCJVXBkrTgukPULVssjjzRbMOymBRu/FhblXx2x2YxxO++YZvj8AcZmJMgo+y4FoKpwa8zz0z83JiwjMzYWMCmhWYB6gG5TTbv702cD2rSi90molc49Fnb5F3RuSBHRrVYCzjByluX9vKYMxKP8pIN0zUd/huk8AF0FPCw+rUDdmi9Kwro68xpwyV8JQYyHqm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199021)(86362001)(54906003)(71200400001)(8936002)(8676002)(5660300002)(7416002)(26005)(6506007)(6486002)(478600001)(66946007)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(6512007)(41300700001)(76116006)(316002)(91956017)(186003)(38070700005)(2616005)(2906002)(4744005)(83380400001)(36756003)(82960400001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXdBeW5Ob3Z3WjFBQjhnWWh5MkQzbXFNY3l0dHQwSzV0NTJzMGxtcUFvbWs3?=
 =?utf-8?B?WnBDKzQ0aThmaTFkd1htUnlCN0Q3Y2N0akp2dkFxNXlYT2JLL053MUVTNUZV?=
 =?utf-8?B?bDNQK2JBMjhNeC9Kc1ZOVy93Rm5OYmo4dHhxZHY1aUFVTDFHcGxCWXI4Wmpv?=
 =?utf-8?B?bm1LNVpsUFlrME5wUE9mN3lGclJ2MWNYR09ISWxZSVJGZm91dTRxWjE1aDF0?=
 =?utf-8?B?WGhzZ2x1T1BMNnFCSjQ4Y24zT0N0YkUzcmxhQkxVdUdYMk5WZGpEbUhMeEhX?=
 =?utf-8?B?UHVEZ0xSVC9GOVpPQWMyMlE4bmtSZy9BczUrVmxYUjBCSzV5MWY0cXdGYWZo?=
 =?utf-8?B?cnYxTUdoakFvd01VSjU0L1FJL1B4M00ybHBJVmJ3ckI3dk9wS3pSbnpRV2ly?=
 =?utf-8?B?VG1Mc3ZVZ05PQjJZd21VeUwvbkd6Tk5xd05RZUV0US90d2kzTlY5dW9BY0FI?=
 =?utf-8?B?ZE95cyt1WnB6ZEtNbjBpN1hLYytmTE5rOGNvNHIvM0E5OTA2RFVvTmdXTWZL?=
 =?utf-8?B?SCtGL1kyRzZ0ampDbm0yOEU2bnRZaFh5cnRhdWtJallmN1M5NUU4TU1DVTBV?=
 =?utf-8?B?ZlUyblh4VWJHOVNveW5RMVcxSlNLWk9lOE9Udm9zL0kvOEZMY0dBWUEvWXFU?=
 =?utf-8?B?Tyt0dTB6Sk13Z3pWaGJudDZleE82Z0dkZTRoRkEwTHVNeG1jcEN5a3BWeVhL?=
 =?utf-8?B?R3ZQL0E2ZnNGQTFsdkl3RkswS1FMd3RKbEtkc0V5QjVhd2h6L2llMXBEUVNV?=
 =?utf-8?B?d2JHM2s2NFNRR3k3V1NFMmZJaitMZFBPbTI0UUlKdzNiWTZHbFFLcW8yTG1l?=
 =?utf-8?B?VUE4ZFJlbmE1dlN3aEt0MnRuVmRzQTJyRTZDNFk1d0hDRFdFa0srZkFscnlK?=
 =?utf-8?B?YWV0dHdBY1hkTU5DWVc4QXV3bjMyTlJXN3B3SUk1SkgzV3NzWVhEbTduRUVF?=
 =?utf-8?B?ZythOWY4M2JxbExxbGRTRmpiT0NRaVk0Z1lMdS9HbWxUQVA1ZE90V1BVQkdm?=
 =?utf-8?B?bG9uY0pUNE9wSDlmV0RaYUNnamxEYUY5OCtObDZOYWJ3YkFXTDBXSjROdVJG?=
 =?utf-8?B?dTVnVnFCSGpKYWcvUXRFNzk4RlZ3cnI2eU5aeEo5ejZwQmloMWRXR0ZONHBq?=
 =?utf-8?B?N2VlaFZ2aXBjM1ora2pVT0lNWm1pMXFpdTlyTVhFUHJNckxvK3F6Wk5VM085?=
 =?utf-8?B?dWNldnpEYWp2L2c4Z2VpQWNsUnBhOXpCUU5qRnVSYUk1L3ZjWDZoK3RNNHpY?=
 =?utf-8?B?RGd3L2VUR2hQU3p1bUU0L0xIemdyN2lTVU9HZzRPQmVXOGV2MThqeDlNU2RL?=
 =?utf-8?B?c1k0c3Z1am1ZV1hiUWNZS3YvRjRjQXJlbzkxaWt6OTdFdTZITHF6Z3MyR1M3?=
 =?utf-8?B?dWZMOGVDbEQwdVpQaDdqSFNGcXFNeERKZDJCdmxKVjdYMnpqa2lPZUlUcHMw?=
 =?utf-8?B?dVp0aHdQM2UwUFl6b1plYUErVWcrMDVGM1JrNnhUQkZCWWcybkg5bmNPQk5D?=
 =?utf-8?B?VHQ1Q29SQXNDZzl5dUpWRHZZaExiSU5ZdVp0SFFoWmRuajdsT1ZrUHBESnF1?=
 =?utf-8?B?bXZkbmlsS1FVY1crZjNHNXJXdmxUdHdYYzBpVlJkeGxRUExlVjZqNFpBODNF?=
 =?utf-8?B?ZXFudldFNGVTM0FBN3E0R0hZb013c2VKdlpyMVM4K0c4eThXajRUZHRndEtV?=
 =?utf-8?B?NlRrTTBYSTVJZFFRZ3hpMUxzUXc3M2pER0d5NWNkcTBuZ2x2cThnbVZLanVp?=
 =?utf-8?B?VzJqWG5HQkdjamdJMjBUZTljOURWQjlTQ1RpSzNIYUNBcFlHWUpkb2M2eFN4?=
 =?utf-8?B?bDEvREdpZjJpamQybnI2Z2xWNUV6Z1lMTTd1MFY0SzJxUUhwMXoyMmhmNENu?=
 =?utf-8?B?LzN2bGV3blZ0aUljcTJsSkRFaDB0aU9mcVVNY2hkM1ZycE43L1A5Rnl4Mlo5?=
 =?utf-8?B?c00xUXp2MjBZZDd2OWlZbXk5RGRhY0RQQjRQb2xrMG1nemh6NEV0ZVIxd1hL?=
 =?utf-8?B?TW1KRjA3VWgvQ0o2UVFMRkFFWVY5RTdIalR1MUNxSkRlaWREaXhGbHMyS3ZG?=
 =?utf-8?B?bVJ5OFM5cmxnR2M1Z1dLb1kyR2M1RGwrdng2elB6KzFBY3ZCallsWUJjaXpl?=
 =?utf-8?Q?NAfGHao59O/1m716CBgnzW838?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FEEA46EA4253641BB419D75BBF2D2C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 197f3726-afbb-4ace-d2d0-08db79520b3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 10:09:08.5645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TYIPbgIIFs22uFTgTICfxmui9LvsTzYupSh6PNNNcKSj65YgU5VQ5IvTTxvCUxPKu6dRoX9RdZsBoL22Xz5AHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4582
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

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDExOjIyICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMjksIDIwMjMgYXQgMTI6MTU6MTNBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gDQo+ID4gPiAJQ2FuIGJlIGNhbGxlZCBsb2NhbGx5IG9yIHRocm91Z2ggYW4gSVBJ
IGZ1bmN0aW9uIGNhbGwuDQo+ID4gPiANCj4gPiANCj4gPiBUaGFua3MuICBBcyBpbiBhbm90aGVy
IHJlcGx5LCBpZiB1c2luZyBzcGlubG9jayBpcyBPSywgdGhlbiBJIHRoaW5rIHdlIGNhbiBzYXkN
Cj4gPiBpdCB3aWxsIGJlIGNhbGxlZCBlaXRoZXIgbG9jYWxseSBvciB0aHJvdWdoIGFuIElQSSBm
dW5jdGlvbiBjYWxsLiAgT3RoZXJ3aXNlLCB3ZQ0KPiA+IGRvIHZpYSBhIG5ldyBzZXBhcmF0ZSBm
dW5jdGlvbiB0ZHhfZ2xvYmFsX2luaXQoKSBhbmQgbm8gbG9jayBpcyBuZWVkZWQgaW4gdGhhdA0K
PiA+IGZ1bmN0aW9uLiAgVGhlIGNhbGxlciBzaG91bGQgY2FsbCBpdCBwcm9wZXJseS4NCj4gDQo+
IElQSSBtdXN0IHVzZSByYXdfc3BpbmxvY2tfdC4gSSdtIG9rIHdpdGggdXNpbmcgcmF3X3NwaW5s
b2NrX3QgaWYgdGhlcmUncw0KPiBhY3R1YWwgbmVlZCBmb3IgdGhhdCwgYnV0IHRoZSBjb2RlIGFz
IHByZXNlbnRlZCBkaWRuJ3QgLS0gaW4gY29tbWVudHMgb3INCj4gb3RoZXJ3aXNlIC0tIG1ha2Ug
aXQgY2xlYXIgd2h5IGl0IHdhcyBhcyBpdCB3YXMuDQoNClRoZXJlJ3Mgbm8gaGFyZCByZXF1aXJl
bWVudCBhcyBJIHJlcGxpZWQgaW4gYW5vdGhlciBlbWFpbC4NCg0KUHJlc3VtYWJseSB5b3UgcHJl
ZmVyIHRoZSBvcHRpb24gdG8gaGF2ZSBhIGRlZGljYXRlZCB0ZHhfZ2xvYmFsX2luaXQoKSBzbyB3
ZSBjYW4NCmF2b2lkIHRoZSByYXdfc3BpbmxvY2tfdD8NCg0KVGhhbmtzLg0KDQo+IA0KPiBURFgg
bm90IHNwZWNpZnlpbmcgdGltZSBjb25zdHJhaW50cyBvbiB0aGUgdmFyaW91cyBURC9TRUFNLUNB
TExzIGlzDQo+IG9mY291cnNlIHNhZCwgYnV0IGFsYXMuDQoNCkFncmVlZC4NCg==
