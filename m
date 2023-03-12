Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6616B6C65
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 00:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCLXI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 19:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCLXI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 19:08:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF523D9F;
        Sun, 12 Mar 2023 16:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678662534; x=1710198534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dXBs14YlwO7ommmfLZxAVc0RZvTbfLU4Gp2AxHeIMBA=;
  b=UsfTrLgakErJw92TvzfryuPMrbgypcfY5Lf1/NyNdbXPKtZOSPTRiUQR
   e+1idPdUHwK1HCiwMRG/wNYcUxG2jChi3v8US47WtfFp7k04PAKwjtH5r
   +cVMmOp6vEHj0gIOpc28LBBVX2FR2tPkYJs3SG00zPQIGvuZUsUROOvDs
   g+Ak/ry32YVu1+q3pmGXy8m1/CR3QfgMKbR+o9gBUogYHsWx2iGi4g3dd
   Q2OjWxAm3wry2GBD2I3cIPKBtrE6naSSm1QsetWtcLkmjt5Y/4qTbrmLd
   Jixz6mEBDOpQidLJvos1rHsX12l0n7rzspT7hIjIKoAiVSx1Ixch1RbDI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="335725372"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="335725372"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 16:08:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="671698346"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="671698346"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2023 16:08:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 16:08:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 16:08:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 16:08:53 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 16:08:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxs7wn8Lq9+7M4x+aSrPJN9wniwRwN25BtTodOgTWDrH7LkCnKssUjnz8//Uc/DyUc1DEWAFJX/Lv8M0SjOOGRQnExkGgdD7Y4aZ4T0FLNXwZh1mRy24+eVQCaG1vKpv6nAJhlyYSXX5ZrwyJSdmwAxXz57/Zz/Z6zPTEUHrH8RTP63R2j4qI8gBOXVRIC937zpkuvW87OQFqB+toiCT918jHXhTD3ELsQZUVImyAwLNvJzkl+DzTaifdeAEY72FJEQAGJKHEUt9fxR0HYy5ivj3x/EPSdujxmbyLk9fzwXfT8E/MVkx6GXgUTJ0EUNK8lya/Y4EDsj7M+o6kfAhgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXBs14YlwO7ommmfLZxAVc0RZvTbfLU4Gp2AxHeIMBA=;
 b=jawIytS0W9yeh6oQv/Bbmxc20halmXklXGNX9pDevyurgHVW4IApJctu/J8+SQHGVqnv2BSWT5jfwLYqoKfAOZ0gq9qQVtdvTeaEBoW8uxg4Yrl/3MFT6DEdifpgIFbpA8oLWlSvdUgCExXAexvXk4CLoKLwaOPXZ4yJvnw2HIokaQNM6gFVxps2Hce4N2aTcVOSK61XqjdAohQUoMkyqDyNAxYxRzjO2RqoCTg/ifsvYthnha0C61O/ZPOBXfEhCcs2q+ijP4UV6sJJwqfO2PiL63MY/P1lvdlLJzWM9zViafnhN8e6myWHC8anoe4Jy976I+18Wb8BxMH9hKmrXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6568.namprd11.prod.outlook.com (2603:10b6:806:253::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sun, 12 Mar
 2023 23:08:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 23:08:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZUDU50M/RwoyayES+lzw7MeI2g67xefUAgAZUzQA=
Date:   Sun, 12 Mar 2023 23:08:44 +0000
Message-ID: <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
         <20230308222738.GA3419702@ls.amr.corp.intel.com>
In-Reply-To: <20230308222738.GA3419702@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6568:EE_
x-ms-office365-filtering-correlation-id: e7018212-45dc-4159-0248-08db234eba2a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mt3tacxwgo6ZBCBP8HGW/CsB0IqJ6qhu+71zyqSfQEhks6kJQQWPA+sV0bhXMkFQ6dFXuqrcn0pCdo94CiPah/Ngjr53PndtuFR9ZJhFkI98LB4x13T7hdsXbczE4jwG068wDofmEwABnay93weZXyJ8+hVP1rubZ0CbRWS9pWPlvSAMMNMK3zWzRMzneyuEz+3lnRAbETlm7PuqQTxkldsHSdAeIpKNhulghvyVKxM2emLout0W5WScswLf3H7ZR1LxdfUp2cETMHjNYxD3G00tatF6YecVOdNt65lBc1KaftQmQwsvRDAQFVZPfmiUX1ttaTEjNzgfPMrCVdas/k9C36bVjP4qy2GvUFh6wsBeGvEKXpntBvh4aalMjFklcNgvBXnh5tva0/rdQQOTRgnMTXXTCs5zcVSCwaDpeXRPhOh1PIAt7MECLKVrYBN4CJmMw5/NzAve7V/m5bm3+HN/6VyUTW1ewQgZoPfWv3AH2vVRhyykrVgBJbbqImOry33gt1GgUKwxJMRO8yVMJJ7/RKaPziZ8Z142oiUCiD3svqQFHL+jCLf8W3kgCGgzM4VVt4CgGXaOnAOqftM1f5uiWiUZYVGRkvehVzgM62bbflvnyANK3JpDdvsGdt+ad3d36DG8JcmxaFbSA9yz30zajDx5jlj8hxeCNGm6+/XiS7rnxhxemEu+h8b712FK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199018)(2616005)(7416002)(186003)(6512007)(6506007)(26005)(8936002)(83380400001)(38070700005)(82960400001)(38100700002)(5660300002)(6486002)(8676002)(66446008)(66476007)(66556008)(64756008)(91956017)(4326008)(71200400001)(2906002)(76116006)(66946007)(41300700001)(122000001)(316002)(478600001)(36756003)(54906003)(6916009)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjQrai82VVhDbVE2OVdPaXJ1LzR2T3JqMzI1SGxiVFBIOGhaTWsvY0tIZ0c5?=
 =?utf-8?B?clVZbU1qZkJlM3BLWU82b0FGTjV0cFZXMVM4SGJva2RYNGhxdlZDdUgyZjFC?=
 =?utf-8?B?OTVrMjVKZTkyMWhmYW5qdkFWOUdHMWhXbzhENU1ZQVdXN094RkdzOHNFcUs3?=
 =?utf-8?B?T3ZLT2FVbi80S2JuaTVJTENkLzVEOXZxSVREMWREOFY4dVlZY2xydFVDQklm?=
 =?utf-8?B?Vk5YaDVBbEtFQ1owNkVBMktqbTNvRm9UUXZzUmdZVVg2cDlLQnZWSDhGKzJV?=
 =?utf-8?B?aE5tNGFKc1FqTzl5MTJVRU51Nkl4bHJxdFRrN3hBbTFWb0ZUaW5OZlZla3k2?=
 =?utf-8?B?dHlOSTVZa1BvN1V6N3JtOFBjU3pUcURPdTltdUVqa0d3MEkxWVdyYkdEcDNt?=
 =?utf-8?B?QXRaUWJPUjVNcjB6Rm9iU3pUaDRwenM2bXFSZjNJeGJSS0hiR1A1bHRQVXJO?=
 =?utf-8?B?Q2p4NVFRblFDTGVYTFVGdkdCSjdRODdCN05ZYVRBOFlMUDNyTjlQQmxpN3hL?=
 =?utf-8?B?RHlvU2lLM0RoeEM4eExESXZtVUgrKzZwUDBGdkZoSFVxZzdUS2hZZkVyM3Zp?=
 =?utf-8?B?d1FEcGkvczVjVzhQbGRDaDI4ZzRyVUtYeUVVL1ZTSVQ3T1pqZ0t6dlhROHBw?=
 =?utf-8?B?OU0zemRzVk5DMUdheGRGeCtsQjV4RGlXV1Y0cWpFWmZqbGhHVjErbXVIVkVU?=
 =?utf-8?B?eDRZeEVXQlVUZytVckNkazFzNUp5NjhHSDVtd0NIamR2RGh6QVFZd2lqSWdk?=
 =?utf-8?B?QzlMTVlIcnpkcTNUV2l6ajNISGFXYkJzcHJYNzcwYWs4cFV3NXd2eW5RYWov?=
 =?utf-8?B?NGQrY0EyQmpMdDZBL3p2dUtWQmdmSTlvTHl1T3dNdzR0ZkpDeUpvZzZzQU1M?=
 =?utf-8?B?T0dYZExlSFp2UEFDRzMzMDNGOE9Jd1hwUVBOVmM1L0ltZWxlRmlwREk5S0FT?=
 =?utf-8?B?c1E2ZUhlQnNidVk0MnhRSWZpbmNvRzF0Wk9QOUtLWnpTWDRvRnQxNG9EVW9K?=
 =?utf-8?B?akVJcEVkLzZHOWYvNmpaQ0lRdjdJL2pFc0dmNU1pY2JuYjkwa29nOThuNmt6?=
 =?utf-8?B?KzdxeldyVFVOTXpzQ1d3M0tJY1NXZVA1SitzMzJvZExtOStFT3RWUU54Y1N3?=
 =?utf-8?B?S0l2WE84ZE5ES0pEWHM0V0NNdUpVdENXOVFubWM4MFJJWjgzWmpMRTJ5QnV2?=
 =?utf-8?B?a0VvMEYvQm41MC9VMGxscFRUaXd6ejR5N2hkYWFjTFN2dW1XZklnU0tZYW9J?=
 =?utf-8?B?WUdzT3lSUUlhdzZsaVo0VDNHa2p2L3NRSGkyZ0dzdE9DbitnQjZiNzVCN1p2?=
 =?utf-8?B?UU4xbE1qaVJGUStXYS90RURsVVpYSGpmeGlKTVFPU1F2RDI0R3podGpHL3dl?=
 =?utf-8?B?MVFlelE3SXFjVjZCb1oyNWk2Uzd2dmRMM25ETE51QzlmZEcrV2Y5dW1xL0E1?=
 =?utf-8?B?QzRTWU5qVEhyQmRyTXlkVklDeFlLNXoyY0V0em5ObzBrbmZyYmtNZXVxYTNN?=
 =?utf-8?B?dEVGNlhwV0NKWFZweDR4NjdxUkx5RVcyVGJkNjZUM1h3RmVsQzA0VDlZaWgr?=
 =?utf-8?B?c24zRG5GR3lscEU5ZDBsZGlHYUcwLys4SUN3aldHbDNBM3E4UzV6SVFoT3ds?=
 =?utf-8?B?UGlCV0xDbWNFaExWNkdqemdZTXJjQlhJY1RBbTJwUVk1NVhuQk0reHB2TUJx?=
 =?utf-8?B?cWpNRDdiZy9tQnZJNjRIRDVKd01QcHIwMWN4UFU5emY4Tm5WQ3pYRmd2dGVv?=
 =?utf-8?B?WUJLNU9vMkV5YU0xMG51N3psOVBLYy8vOC9JZDVlWXVZeVpFSENNODdnYlNt?=
 =?utf-8?B?S3Jlc2ZYWVJkRXdnNU12VHhzOGMyOTAwQ09KR3BPWW85QUZRdjZCeGFqNjN3?=
 =?utf-8?B?bkIwZisyTHNCNHNjN0VicitBbUxZcVROUWZleW1jdmVQVjNPTTdIUnlnT2Iv?=
 =?utf-8?B?eDFUdDVTQnpGWm9zUHhEbUd2eW9QSEg5eExZN3BjRGhwYTJSaTh1Y3FPbjlP?=
 =?utf-8?B?S3lReEJHd3NyVzgrZ3l3MDVLL3VuNk5EbnNiNzJ4cjEySTN3TWYxK2dkeWVn?=
 =?utf-8?B?MUdiSTRKUUZodTJhb2FYajlOMTBiUGgyZDFINDJEYk85K055ZGwydno5aWVO?=
 =?utf-8?B?ZVNlT1dsL2cvQkJtS0JqVEhzTnFlUUpmUzhyekhLcVZ5cElEVXl4ajBuYzhp?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20CFD5A7ABDE014392DDD561D9141D0E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7018212-45dc-4159-0248-08db234eba2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 23:08:44.0324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kMMG4YBl/lmKvuf1pWvRtiIzP67vk/LqBJJfH1NGQYHJKVALWrOEEsKuSLv1AEFl6Fhxty1NytbWg1v7THVccg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTA4IGF0IDE0OjI3IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgdHJ5X2luaXRfbW9kdWxlX2dsb2JhbCh2b2lkKQ0KPiA+
ICt7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBUaGUgVERYIG1v
ZHVsZSBnbG9iYWwgaW5pdGlhbGl6YXRpb24gb25seSBuZWVkcyB0byBiZSBkb25lDQo+ID4gKwkg
KiBvbmNlIG9uIGFueSBjcHUuDQo+ID4gKwkgKi8NCj4gPiArCXNwaW5fbG9jaygmdGR4X2dsb2Jh
bF9pbml0X2xvY2spOw0KPiA+ICsNCj4gPiArCWlmICh0ZHhfZ2xvYmFsX2luaXRfc3RhdHVzICYg
VERYX0dMT0JBTF9JTklUX0RPTkUpIHsNCj4gPiArCQlyZXQgPSB0ZHhfZ2xvYmFsX2luaXRfc3Rh
dHVzICYgVERYX0dMT0JBTF9JTklUX0ZBSUxFRCA/DQo+ID4gKwkJCS1FSU5WQUwgOiAwOw0KPiA+
ICsJCWdvdG8gb3V0Ow0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qIEFsbCAnMCdzIGFyZSBqdXN0
IHVudXNlZCBwYXJhbWV0ZXJzLiAqLw0KPiA+ICsJcmV0ID0gc2VhbWNhbGwoVERIX1NZU19JTklU
LCAwLCAwLCAwLCAwLCBOVUxMLCBOVUxMKTsNCj4gPiArDQo+ID4gKwl0ZHhfZ2xvYmFsX2luaXRf
c3RhdHVzID0gVERYX0dMT0JBTF9JTklUX0RPTkU7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXRk
eF9nbG9iYWxfaW5pdF9zdGF0dXMgfD0gVERYX0dMT0JBTF9JTklUX0ZBSUxFRDsNCj4gDQo+IElm
IGVudHJvcHkgaXMgbGFja2luZyAocmRyYW5kIGZhaWx1cmUpLCBUREhfU1lTX0lOSVQgY2FuIHJl
dHVybiBURFhfU1lTX0JVU1kuDQo+IEluIHN1Y2ggY2FzZSwgd2Ugc2hvdWxkIGFsbG93IHRoZSBj
YWxsZXIgdG8gcmV0cnkgb3IgbWFrZSB0aGlzIGZ1bmN0aW9uIHJldHJ5DQo+IGluc3RlYWQgb2Yg
bWFya2luZyBlcnJvciBzdGlja2lseS4NCg0KVGhlIHNwZWMgc2F5czoNCg0KVERYX1NZU19CVVNZ
CVRoZSBvcGVyYXRpb24gd2FzIGludm9rZWQgd2hlbiBhbm90aGVyIFREWCBtb2R1bGUNCgkJb3Bl
cmF0aW9uIHdhcyBpbiBwcm9ncmVzcy4gVGhlIG9wZXJhdGlvbiBtYXkgYmUgcmV0cmllZC4NCg0K
U28gSSBkb24ndCBzZWUgaG93IGVudHJvcHkgaXMgbGFja2luZyBpcyByZWxhdGVkIHRvIHRoaXMg
ZXJyb3IuICBQZXJoYXBzIHlvdQ0Kd2VyZSBtaXhpbmcgdXAgd2l0aCBLRVkuQ09ORklHPw0KDQo=
