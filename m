Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F0E72B562
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 04:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjFLCZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 22:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbjFLCZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 22:25:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFB619A;
        Sun, 11 Jun 2023 19:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686536719; x=1718072719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T9f0npRaN45vOVZJ7CQGVNcFZs7jlE5v/nyHXUvktuQ=;
  b=AO1KSa4rx872msnNWAEAfgh70b/TDn0Dhq7Ca0NHUE8JHnotQJT43k0V
   GGDgeDPKJuad4uaY/sOv+5244osJez56jdLgh36jbjrecrW7wuRdS/3CM
   VfW7CmJWdtznNYMVkSjaaqsQTuk9TJNBc/Gbt0xYBLzFrwmrpKtbon/Rj
   M8q5xek+pF9eqiO+kZ8zo58GRXLtceop9hj0eBSzzJMuXw/q3eSxb5gJm
   t8ihRl3rIFYfiV59wZMlPJkXFU0Jg+vppLRVsHBvCJCdDZBW+qzmOPxKe
   3Sp71ieUheekKzWBgPtiKTJ6wSjgM15b5veKHZQPtElswMpmwGeKmD6dx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="355423702"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="355423702"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 19:25:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="705207731"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="705207731"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 11 Jun 2023 19:25:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:25:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:25:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 19:25:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 19:25:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kke8uX98t3v5nS3HB78PmTL2EwgrCwVwSH1kpsv1dGN4bfE98gBDR6CgRd4uBhKHoopQaSQFDd+4SiCBoWwM/tOta2ucMJBBgm4EUFNGOHuU6GqzE1pZNtf/g6MvkxSV6+J7ETxfCfStd0Mixdoh1s0I53l0MzPLd72phY5ZQk9+gvkcfKjL9jnHvNeGJYuQm/ioPxHWGwIsA9moh3Pzu22rUsI/UpoPlEepf6njVfz7yZzDfi6itzaBeUiH+zdhrVsbxXYS6dbF3RdqVP1GuQZ6/xs8T1agMBc3L7PPCiLY1BlPH9BXcKZ/BFzcR6wSjV/ELndi/g55JTLTl8O1PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9f0npRaN45vOVZJ7CQGVNcFZs7jlE5v/nyHXUvktuQ=;
 b=eSkh5DvEsCNz8i7z8ORPpr0JKh3vcFdAVA5wiu6e90UQV18ilWhgWJiMhI8ZC5ImaaoldUeNOEVi4p3EG+5ru01Cy5sN5hf8XI7KCWyUqp42kZsadpyFh5niDDGTsebq3mEizpkphVOT4mHQZUhdwffUu6QPojWODHUiLjowJb86+T2nF4yUrmkPxa6H8ENQZ2MwDjJaNW+Rr90m+VsdrG0u26OX7VMJAkZ1Zn93mxIznJf5VxlbTk8Lzbl6NdFH2umEq7HS80Ic/yO5L38okwpPibSShDD28vhe8zO9kfClY3m8BUn9or9tqdQrGcVUDhX95a+9jcK3HKsAZMw8Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8276.namprd11.prod.outlook.com (2603:10b6:510:1af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Mon, 12 Jun
 2023 02:25:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 02:25:14 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Index: AQHZlu+2r84uqtF1H0SFKn93tuC1FK+BjKSAgATvtoA=
Date:   Mon, 12 Jun 2023 02:25:13 +0000
Message-ID: <7313b6ccd2d3fdbcbb5cf4624bf15117fde7ed85.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
         <20230608230211.byot2fbo7skkfqxe@box>
In-Reply-To: <20230608230211.byot2fbo7skkfqxe@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB8276:EE_
x-ms-office365-filtering-correlation-id: d498b0d0-4eb2-4342-6226-08db6aec4116
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L+WIeqWiUstsQw0brhhhjwntktW/GMK+C5MgGtRmzT9VE4NV5AiMvzM77WLF/I9L5qTlJpu1bR5ffwLzyJK2wD8QjRLH4Td1hzWoYT82rruOH6zwDFnnAAQP5MrqMivylPLCUV67PEZ1b5yJGsfLOcXEZhhsS2RVCk0/l80piQPp8k7KMohFic7A3LtelNKpbIfZYAunWb2zLarqDQi8dHo9j4kEiG9WG/HfCv9GKEE4Yomxd0pjK8OD/TRRrdrkA0GZdrg31f8QBplFk/wXF933w276if6ztSfWjSYoDBtWQbUlC2btcJK0OECsOg2TXUXAyyjPRCMD69Byo12mdJxoEgMtTenM8606eiF8sOiu3bZcn08GEEde6bcFYkyYfJd6TGJXCOtWUPxNeJocQEZ/CTqckQPoqWhNOpSGxlWaO4RX/oHFLU8biLGZBXdXDL1RVBDJNNamcuJaZQXu5fIqMx9WZLWOPFS+zSOq6O3nNrSxwKH/DsyZiXbYQH4tmiFaHtcS9VMa9SR0p3yff0V8l37KZGtBdO5D21ztBq3+v04scZevET/fo6t3LbmlNCs7f2H0S176vejFFT4yf8MbDsh2HE8PNQdzivyhxMzqEh7k2kWRshN9LO/AK7AZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199021)(7416002)(82960400001)(478600001)(8676002)(558084003)(8936002)(316002)(54906003)(38070700005)(41300700001)(4326008)(86362001)(66946007)(76116006)(66556008)(66446008)(91956017)(122000001)(64756008)(6916009)(38100700002)(5660300002)(66476007)(36756003)(71200400001)(6486002)(2906002)(186003)(6506007)(2616005)(26005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWE2K0NmcXFQZmZuZFBhMm5VYkJYUWhNMnRaZHVYQ2xkSVMxblF3L0Y5S1lO?=
 =?utf-8?B?TmFoYTRxYUxZUG1EU3JkSll2M0ZRdTMxSTZmVHFEMHBxYVZyazgyYWROM2Jy?=
 =?utf-8?B?cFp5NVF5RGZWSnAyYlpNSVVoa2pHQVFPc0RhZ2s5dlRXZjhULytGemxobkNR?=
 =?utf-8?B?WVNkK3R6L2VTb2hteEdyZkRkQlR0M1k5Y0ZkellTV0dEZ0F2aVpXK0hNaVpK?=
 =?utf-8?B?V1lvYTlNRnp2bjVJNitBK0JvRTFONVNOdm90YWtzc3IvR2hEdkp4bkhUMkhj?=
 =?utf-8?B?RDFSSURheDFIb3dRS0U0US9sWWhHVnVLUXE0ZzVpUnZBcEkrZHBoUUNtM2ZL?=
 =?utf-8?B?MEliVko5bDVpczNsMjhmdlpxK2R0N3JZR3JSMXlDRjUzckJjRzUzZllDR3JP?=
 =?utf-8?B?Y3pkYS9QMTlVc3ZTNlpjaWo1S2J1bWlHMjU5TVN5cmtZYzlqRm5VblFudzVv?=
 =?utf-8?B?cTVMWFhXOGVVYnNSTGFlampMZkk4VzRTMjRORFBFeHpGakg1MW1GNFdjVm9G?=
 =?utf-8?B?akRFdlVGT09Bclk5aEVJOVd1TFhXQ1RLRUttbW1CZ0ZLUVY1bUVNUUlMSWRi?=
 =?utf-8?B?OS9Ea2R3ZWZONE52U3NhYUlzcHBJWmIwRDJyZFo1bmp4RG1DTmtGcGhvZVcv?=
 =?utf-8?B?MDhSYjhUaHJwS2lPUkpSblp6R3FSemZTY3RmdmNyWUE5QjNTa2ZObVdyNmlS?=
 =?utf-8?B?ejROamp5VTliajE1NW9JZzFuRkVQMURlcWJaWDdsZFM0SmlqTHJyc0tOaTdB?=
 =?utf-8?B?WG5WaTVCT1lYcGxNcHVLRm03QTVqNW5kUHRDN29SVVk2S0N2QnFFaFNmZ0NZ?=
 =?utf-8?B?NFBSQWVkUkxEcGIzaWl3UlMwYjJMOW96aDA0WjV6RzZYclhzZTM4L3hFOThx?=
 =?utf-8?B?Vm96V2NLaWVhTUJKYmw5SHk0UTVMOFpISEx1U3dGZ3U5Sm9UaHpjZ2tTLzdl?=
 =?utf-8?B?TlF3N1FUbXR6bkpDTjhSWUkzN2pRK1JjOGlmT05ZZWVwV1NpMG1LR21TejlF?=
 =?utf-8?B?dUNreGZZc29rVi9ZZWZ1cS9nLzRjTS9JMzZzUEp1YldvNE16UlJpbGhONGpa?=
 =?utf-8?B?R1FLTmkxUHpZYmVXdjRNNmlVTUtwbVJPQVgwMUJJZG1oQmJnVDlnVWl1VWxG?=
 =?utf-8?B?dlQ3YURIdFV2RE1HRlZzVlJMeGhiNjZ1cVV5blo1b2tGRndKUEJVbGNkenEv?=
 =?utf-8?B?MVUrajBTYzlJb01FcFRFcWo5THhESkdPZmVxcmptVTBjKzJ6dy9nT1dEMCsr?=
 =?utf-8?B?Q1V4UFppTVhpTEJjeW1WNmYrU1dHckZSU1JBVU13c1AwcnV5U1N2Q05GaGVx?=
 =?utf-8?B?OFRQZmlndVcremlWeVQrVzFDYUEwYjUvaVRMNlJ2Y2cxVVpVOHhpSFFyWFUv?=
 =?utf-8?B?U3ljUEs3Tnc1dDFocmN5bU14MklHcGkwQ2I0dXVRdUxxUElPOFNjV2FPc1Vr?=
 =?utf-8?B?NmhvT3F3Z043YVJDS2pLYUNXeUg0WUlhMTZ0MGk1bzVybkgrZ2pnLzRwUXJT?=
 =?utf-8?B?TnhyYjVoeTFXeVM5S1V6MjBZSFRiYnc1VlJEaklZdTZHSUU0WE9LQXY3d3dx?=
 =?utf-8?B?azNvQ2R3QmdZSFlOTGgwcGdlT08yV3BmZXZaTVRlNVVzSmhzV2trYi82OFNB?=
 =?utf-8?B?UnQyV3F6UWE2QUZNL1BvZ1NZOGxWMm1UaTdEeDBVQWZ1WERlVUxZYVdLMDVs?=
 =?utf-8?B?S0ZtQ3h1SXY3bnVzcUpRMTJZemx1bzdqZVEvYlVsZjBXMDh3Umt3WFMrbXFM?=
 =?utf-8?B?RXJaZ0RWVTV0VHZ1WnBhN2R1SG5wZXNxS3MvdEhlYkpMRC9zaGIrRWxqZkRN?=
 =?utf-8?B?TFJmdTI1QjIxZHVxV0xIMWdBMmU0ZGVycy96dWJTQjM4UTJOUGdtK3JEWm1I?=
 =?utf-8?B?VEMzYkhLc0k3bGMrdk51RStXTTJuY0JRaUc0bHZHdzNpZWV5VW1uSEptb3Fj?=
 =?utf-8?B?SnNCN2xPQkpWRlBEbWx0YUZDbzhXNjZ0RmxaK2hIZnA1YS92TWFKcjNEeXFY?=
 =?utf-8?B?MEVveHVsbUsyeEJCSWs4RXIwalYwb2tZMWVZQXczelFCb2ZubTBSTXczakc3?=
 =?utf-8?B?bUx1c3o4YzIveEE4Yy9pRXRGRWNuUzNWSzc0ZHE0N0dRdjNyOGVXVm9CSndy?=
 =?utf-8?Q?TkuQ4Qphx0QbCKUvCgxfjPYbU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <979DBAF81EC3354792AD7EBB6398E3E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d498b0d0-4eb2-4342-6226-08db6aec4116
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 02:25:13.9308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SDf8Qe0Q4LYDM3wVwohVdev7dSHiUM1cP/DQKP+t6U/VyDecT8PXW3f/WN9xnrQxe9c+B8cA2VlXLG5IssnliQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8276
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTA5IGF0IDAyOjAyICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMjoyNzoyNEFNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gKyNkZWZpbmUgVERNUl9BTElHTk1FTlQJCUJJVF9V
TEwoMzApDQo+IA0KPiBOaXQ6IFNaXzFHIGNhbiBiZSBhIGxpdHRsZSBiaXQgbW9yZSByZWFkYWJs
ZSBoZXJlLg0KDQpXaWxsIGRvLg0KDQo+IA0KPiBBbnl3YXk6DQo+IA0KPiBSZXZpZXdlZC1ieTog
S2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwuY29tPg0KPiAN
Cj4gDQoNClRoYW5rcy4NCg==
