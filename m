Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D59741C74
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 01:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjF1X0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 19:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjF1XZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 19:25:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6382728;
        Wed, 28 Jun 2023 16:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687994718; x=1719530718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K9TseowI6gGzun1sQ7ckGgkfrg5dyP3xahBICk/MtTg=;
  b=DKSIxEKAMVM42JLX8PPUkfXfEpj8fKoPehcUEX44e76xmvLGWyoIc/Ws
   9rR1BRa+S1divTzy4ffPRA0Ar1MGTinhhO5K/AIHvFph1LlkhIM/eTcJ8
   wpa2F3KRu0p0E62NEyQJoUm0ysp1WjKrerKPyrWGfUchcCuRIgUefdn6E
   5jEHTt8s4tK+MeOmu35PE70nDHgc8Rq1bsoWYWtw6ELzZ7r4AZBOwMk6p
   ihXWFquuyaEY7WMGg0jhDPivUxa0Ak8KRp8OarW5atUJT8lR7K09z1qLn
   BWQezaZ5uDp1gGLitHVLfFNTj7ojJnVJ3CS2hT0zNKh/ZEob+e6Xw4Fu4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="346751888"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="346751888"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 16:25:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="807109712"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="807109712"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jun 2023 16:25:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 16:25:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 16:25:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 16:25:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 16:25:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWgcMXBEjNLCGd3gbjt8P8jHpq/WK4d1cvx2MLrnKq3NzRBAaq7hwNUayfBQjScanVh5ZuvuRr7CxowAHQjzg6QW2XsXj7ULqJNXazPagH1IUkdvtmsKvysrPdM0PF0CnwO7tMHiOZt6ONOSo4rdV5DeGuiGyeQuBYh25fmJ2Bo6TsPPoPvctwduwqkEvM4m6Re2TUhgKx9wg+57QjAVDK6GK2eTzi4sXz97Ljuc+AASe9YKyKaGyxgFc2wRZIC9nQi8fL6ntI1OTyawwFU8d3rEu1oK7ENblo/6B/drBj9AuWY7095u9eKz4lSbaboab4Ky8TGdfHkA43CWnFdi2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9TseowI6gGzun1sQ7ckGgkfrg5dyP3xahBICk/MtTg=;
 b=jhETAZzI06GRzqsMjb3wTf4jy0pBygfJjqwvyJ9RUGdDRNiBFyPrRSg09uxbTP4QkJlbVI0BYCw3AmSoKMmnV6i2PxAipyO1XxwvzV5UTW9HziircXsh176OK+ddbjLbKBRmMeOdiZueeT9OmblD7mYIK1wqRQmrgdtrWNylMnP39JOypimD7JBAs+ASmNruKccfaugO3puEkhtz9BdRn7r6UPQlxm5gnEHa4508EA8r42HzNJxvjNYbtSe7mZdeo80tcy4NTifrK4O7CQvmsZzXu3v1Ir6aOo0yjZrWpIr4BViEi7s7/C8dGJ1dYsQn7EByggC7P40m04NInDbAfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5024.namprd11.prod.outlook.com (2603:10b6:a03:2dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 23:25:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 23:25:09 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZqDWtRkTpkzZfa0qfwqSEOzdd8q+gL/mAgAAPwQCAAJ9ngA==
Date:   Wed, 28 Jun 2023 23:25:09 +0000
Message-ID: <0f3ab0920062a0270034150bfcf94300e6ba8538.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
         <20230628125813.GA2438817@hirez.programming.kicks-ass.net>
         <20230628135436.GC2439977@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628135436.GC2439977@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5024:EE_
x-ms-office365-filtering-correlation-id: ce91c675-6f31-4a49-793b-08db782eea39
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sS75/H9puVknRWjtU/0mP2zz0qYEPSYSzUstlU0IzPU78uxhHfgrx50ZQi4O3MOhibILDKlVaduPYLa7OFTrAx+KEqX8j26pZrF01DmpKYlIwGtjPzKsA+tcHnvLYYXwTHJZwS+6MSBTflLqJV4lseLKGxIpjHAuadxSqFcecRQGhgq4HYPJAXOmTyjzmMqQ88kJYqChP1DJY4uGNkhElkDWAtrVoHmGdkRZ4r+zZDfPVBnljsMgZzcxLmb9+gbz3ZxT2OnQHoWJdKCIGwmcJ9kmyPrrJpTuMO7evqoptttTTGV9G3DfW0+ORtIPFy3nc+OIqM1T/w/8CVxpx92N9dE/9LGZBKzrO7qpSiKEREWNi7gNrxRBP01cxARv4GpEIl5saMe2TmcenvyL0oFci+8lZioI8CBGN1cePZ/UXdrYSkUhzD4mDD9siw6kUJgRtp2a6tGgQfSW1JTJu4+ZnvZEgTxpHaqfjvI9dJUf7NytZy82tXJhYW3+zarLoY+ErKbVuaV2Ly4HndZtxJAdH3AZYZXFpDpsgiEjTgYcRJuPE0VdEHctU0hNgdwbnJ3EkgYYdX7oIxuOeFI1Nbgkk89sJ1TiVroV/pKY+2iONxywFdJoUsajve1FGgv08eqc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199021)(478600001)(6486002)(2906002)(54906003)(186003)(26005)(2616005)(6506007)(71200400001)(4744005)(86362001)(41300700001)(7416002)(36756003)(38100700002)(5660300002)(66946007)(122000001)(66556008)(4326008)(316002)(38070700005)(82960400001)(76116006)(8936002)(91956017)(66476007)(6916009)(8676002)(64756008)(66446008)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NlYzcDZyNmd1R0JGM1oyTWdJbUdsa3VtZUFlV0xOSDNjNHVoNFBRWUFWRlNh?=
 =?utf-8?B?ei9EY0NRdlBsQUk2K001eDlOajZiYWVZd1h5M3pnd0J4TVRRWlVjNnlXalg4?=
 =?utf-8?B?WlM0azRub2xhd0NwL0FGWURKcGZSM2ROOWZoN2N4WnBTek9tMkd3bk1Dbk9I?=
 =?utf-8?B?bzlqZzFseGpqTWY0MVNWWGJJVlpaQlA5TjFBTE5PbFRHWnJZc3pyZDcya0ZD?=
 =?utf-8?B?TG1zNk5XN3dSQnpDb3RVSjNma1NhVW9jb1BMd294VmJnTGw5NzNZTTFZQ1FD?=
 =?utf-8?B?dVIrQXo2SnZ3TCtyZEN1dmFTUnhrTGlFOTZXMElmSkZGd1h4Q3dBQW9EUUNO?=
 =?utf-8?B?M2ZEem9tVWhtb3I3RkU3WUE0aXdSRDlLVmVmbkFiRUw1eDNFeVQ4bVIvUHU0?=
 =?utf-8?B?TUNjUXJEcVU3Y2dlV3c5U1UyRUszWUhlOXd5MFFmUDlHcFIrVDlSd2hoc2Yr?=
 =?utf-8?B?WEdrcDY0V1dtczNUZFcyZUFxSXA4eFU4cW5peU4vMU4vdUVXWjZZRkpaN3lM?=
 =?utf-8?B?d1k3SjVteFRjaWt0ZkpmQVY2dVRsbjR6TmlrNWpIV0NDMlZWcG53UE52QnpT?=
 =?utf-8?B?K1ZrYVpmc2dGYXJDZXJ2VFdqMldodXMvVjRPeEFTRldEYm84R2pjQVBMcUxp?=
 =?utf-8?B?dzJ5dFpZakEvbWhtYXFHcTdYbzdwczYvMnRGNU01ak9xelI1VFdGL1lWMnJY?=
 =?utf-8?B?QVQ5ZUpPeHM0M3ZiVmE1M1N6UDlVc0hRN1JTZ0thVS9BaDRvMVhqSU9LSFJ5?=
 =?utf-8?B?T2wwS0FDQWJrMUNGVUYyZmZuLytFamNBaEpJOUs5aXZ4TVlLVW1YeTA4bTlh?=
 =?utf-8?B?dWVqNzlYSmN0TmVMbldQUFRDM1I3UkllTEE5NFVwTC9ndjM4K1JIdngyL1B4?=
 =?utf-8?B?enJqamRCRUQ4bTE5S21SZzY3VzRRUTloV3RuT0U2Y1ZKUXd3elBmaVdobVMx?=
 =?utf-8?B?ZFBtUXJTV21hTXBSVDJGdklWekNDam9lRU92S0p3WC9aRGh6Y2hrQnIwem9s?=
 =?utf-8?B?TDJ0WGIvcWd5a05vOHRJM3VSNWVCV1h0c1BZQURrQVdQOUxyUFE1NVFubXJB?=
 =?utf-8?B?eGd6THRNNGtpeUtJM29ZZ2lyV3VPUHVQRmp1UDc0L3RDMER1dWxDWXFnSk41?=
 =?utf-8?B?UVREMHpwYjhuMkR4K2NHa1lubEl4Tld2OFN2Nzl2NExaZ0xacGwzbGUrUjZK?=
 =?utf-8?B?emROZGQrdklDZTFkcERTSEtYMVI1U084TVZYYXRrcWkrdWs2SkdBa3JjZ2dN?=
 =?utf-8?B?Nk56RExJT3hYa0pSZzl6U3NkZ0VlZEhLS2hmeVFIdHJ2UERRUFZJWWVoOVVa?=
 =?utf-8?B?SS9kVUhaY2RwSUFyT05CK3hKcHZSdjlkTmFQcHVJMjVRdnlCSXVwTXArTW0v?=
 =?utf-8?B?T1ZlaE90WXB4UUNlS1BXdFM3K1c3S2VjUXFRcHIzdEdEdFZuOGRaNFlBNURS?=
 =?utf-8?B?K09odW5kd0VjR2YwMmhxMy9QcHNnSDl6UTNuaXlkMlpCRE93TGUxSGRON0oy?=
 =?utf-8?B?a3JRd1o1RzY4Qkk3eGNjRjVqT0RRL1dKckd4UEQzcHRKc3FtYnVVNVFxSGV2?=
 =?utf-8?B?TDZiT2hzRWhmZGcvWFZXSG56bDJDS1NMbkFQak9Zc2Y4cDBmOGxnODM3cU5m?=
 =?utf-8?B?MEIxZElkamNlbjVOOVFXeVo4R3hwcjduVXF5SzJLaGVlVk1uUmp6UTNGbWoy?=
 =?utf-8?B?NmZweHdZb3JDZld1cnBHV1NoZW9TTkpmTms4WUVSR1liQ1pXMno2QVEvdm5h?=
 =?utf-8?B?dXNvcXp5ZWMyVVFvREhOQ05NQ2Jia0JRd1BnS3dVZHJ0b3RNczlkZkFQYnlI?=
 =?utf-8?B?NFdzdXBDQzJ4bGRRR0Zva2NJV0tYd21aSTNRTGJ1dWpLMTR5YzVvUDVRU0lB?=
 =?utf-8?B?OEdNT2I3dThVQnhZUGxVZzUrOXpNLy9SUkxzaC9DbkhpWnFJME1wVVRqNVhz?=
 =?utf-8?B?dGthKzV3ZkhjaHEvWWNxN04wSVpickEwL0I1U0VFS00vSmtYLzRrV0haY3BY?=
 =?utf-8?B?dzlTaWhHWEt0RmNXdm82dnlRM21wdWxiQTZKZGJHc3A0UWIxTXg4WDhJeUp0?=
 =?utf-8?B?bjltM0hURkZteEFtZWFrb20xMmIvMVNCWXhvdDVmdDFOZ0FGSWMzK2prRkZE?=
 =?utf-8?B?Y2o0dDNyRUI0UDRxbDhOWkJveTY4eDlYWUxLaHhaNTBCQkMwakJEMVA4UEtI?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16B932194D4D3B4EACFED37E78EEACC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce91c675-6f31-4a49-793b-08db782eea39
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 23:25:09.6207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PKaUqWXKVZgEQLzRv5e1L2LVuVWXggQp0cUqJptcbiQeGdTaZIUJSvbQoEf8WCT3OIS1lqGhCA1SIez/j1fVVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5024
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE1OjU0ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdW4gMjgsIDIwMjMgYXQgMDI6NTg6MTNQTSArMDIwMCwgUGV0ZXIgWmlqbHN0
cmEgd3JvdGU6DQo+IA0KPiA+IENhbiBzb21lb25lIGV4cGxhaW4gdG8gbWUgd2h5IF9fdGR4X2h5
cGVyY2FsbCgpIGlzIHNhbmUgKHBlciB0aGUgYWJvdmUpDQo+ID4gYnV0IHRoZW4gd2UgZ3JldyBf
X3RkeF9tb2R1bGVfY2FsbCgpIGFzIGFuIGFic29sdXRlIGFib21pbmF0aW9uIGFuZCBhcmUNCj4g
PiBhcHBhcmVudGx5IHVzaW5nIHRoYXQgZm9yIHNlYW0gdG9vPw0KPiANCj4gVGhhdCBpcywgd2h5
IGRvIHdlIGhhdmUgdHdvIGRpZmZlcmVudCBURENBTEwgd3JhcHBlcnM/IE1ha2VzIG5vIHNlbnNl
Lg0KPiANCkkgdGhpbmsgdGhlIHJlYXNvbiBzaG91bGQgYmUgVERDQUxML1NFQU1DQUxMIGNhbiBi
ZSB1c2VkIGluIHBlcmZvcm1hbmNlIGNyaXRpY2FsDQpwYXRoLCBidXQgVERWTUNBTEwgaXNuJ3Qu
DQoNCkZvciBleGFtcGxlLCBTRUFNQ0FMTHMgYXJlIHVzZWQgaW4gS1ZNJ3MgTU1VIGNvZGUgdG8g
aGFuZGxlIHBhZ2UgZmF1bHQgZm9yIFREWA0KcHJpdmF0ZSBwYWdlcy4NCg0KS2lyaWxsLCBjb3Vs
ZCB5b3UgaGVscCB0byBjbGFyaWZ5PyAgVGhhbmtzLg0K
