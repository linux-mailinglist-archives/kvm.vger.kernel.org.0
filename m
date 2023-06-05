Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121D47233A2
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 01:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbjFEXZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 19:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjFEXZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 19:25:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B442FD2;
        Mon,  5 Jun 2023 16:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686007506; x=1717543506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ecz9XVhNZAWCTuRP5pcbUx3/EPySU6sBu57wATwUT5s=;
  b=SaJyZRqVI5A2oDtxk9LnSIh/fVb0W9Tf+J2xtsw/HuFPj5O8y0HOIviE
   Q0AFJJt4F8faUwmF6oxWdhfcPjj7RMqdaqVXbpKtmctEY3Q1fCvFSzNsa
   rGhBe19LxUQHMlNaWcQOVinLRubZOUWUxlBdAP7fymtbtido00h2ncKcp
   byyzliO1RTvxUs0UrkB/x7xm+FnJVSEVNgSaIj0lhBG110K9h/d+E9cTO
   0AYiBPrM4AU1qiJRxXMyN8n5t/JnofAiDFg+KcFx51Q/u8OKYOcBrMARo
   1vKf4ihnqJGhGI2/ubbNlmmETN1z0xiL4hduSZffSXAHdEN+mTYXCnyox
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359825558"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="359825558"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 16:25:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="738530189"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="738530189"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 05 Jun 2023 16:25:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 16:25:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 16:25:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 16:25:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 16:25:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfXAgDbvF4C25gA0gsBRWyr9J1M47IqsL/XvrkX9KP/K2zbz++98Z5m3u/BCrTmj13qlMf4HqH795Pa20h98WbhUJ/BVG85For5oUMPyZ38M1c7ivl75rsfwQinlacVx95vsKYN8d/qqnYw8X1kCMR+hynBeJnOMKOkZMBHJM9F8FGMRRU9HPDiiQpZTDc2N/c+QZWxkwc5jMUJCgcGNTygVAFzGOFH6oTmhHWbABDaqxfSxIZBY3lTHpU1Ekwwwyw1O412Coh2ry6W0gt7Vg+9M81nwvT/3/FIB6X2JsH+7pnoCEcBGCs7ydL3AFn1oL2vuWyALizecTG8usCBbZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ecz9XVhNZAWCTuRP5pcbUx3/EPySU6sBu57wATwUT5s=;
 b=gCi6Rqy1nCNVjcwj5AISJRSUzueoC+qdJh9hCArfS8ZTAJiG9rWmw8sS59ORfhgI3PwRBDSj98NXf77cLo/v9b0p60PsPEq3asdRDzLkDU+jR+nrJphXTSiEzajf7H34EAlEn5L/JKUGKDBNNjrnAdkX3LXAtznGxlTkFojfSNd+/g6/qdUfPju+4TbNe1RR5Ye80+eFLImluAf0dVpROl0xEr5y2w6wEUOTqjnQqTobo1MHzqrO0ebklMTA/P0dEZ3Fr2leyWrjKqw+9MRepINY5li+lI0S0Nq3z5rKa0uoqMnHRRxGL2D39/02tEJpJ/pf3IdbJeB21ZLiXjzNuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SA1PR11MB8318.namprd11.prod.outlook.com (2603:10b6:806:373::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 23:24:57 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff%5]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 23:24:56 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
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
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZlu+wNwpF26yA2UWLC9EXmgAK/K98ufOAgAAcVQCAAAEBgIAABLUA
Date:   Mon, 5 Jun 2023 23:24:56 +0000
Message-ID: <8adc3f2c5e6c2e2e08fbf9b33439c26fde4ee0d2.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
         <20230605212303.GA2244082@ls.amr.corp.intel.com>
         <733d0d042f39f099caa35af9b517b6c50ebac12f.camel@intel.com>
         <8dffbea1-0c9b-498b-c270-409835377e90@intel.com>
In-Reply-To: <8dffbea1-0c9b-498b-c270-409835377e90@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|SA1PR11MB8318:EE_
x-ms-office365-filtering-correlation-id: ad81fab4-97fe-4798-a3fc-08db661c12ef
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wYMxh0F4/MsfoAV9fnRV6fTBW1cPPJRWP5LP7SKAnw0G4/yEsSLI5DilGYElJIYxNA7un1pPxxN69LWJhVZHU6ikwsvj/s0ACezxJsnO/sbYoJmzsqLO7d4nCFieyhb8myZchbeJaiWehvGCSlMrS2GhZwgaqx9cbWgAc1e5o4u54XXKXFphIED+dv6aTbycTKxqbrT8X27AgQjVOyUHfhojia2GRdhizVkEOSAIrgtpIwsTGuGdY86TuOLGEiKEc1gKYQgmIKKrYsApBMJbTFnronIDnMxCDvI6ob2i9niIyo47Nub4As1u77TiCnLpEJXOgxj3pGmIALdlpTsuUcveqcRWZGlIVorj8eAG6kQKh1/k4YpDzrDIeR5eFmQTEBW4uJLv3XmI8GvrzTm/Y3jPzuHbDAyG5pWIeSK/Gf2ZCuWJvHEhoCU40IEW4X3L1qm4ZAQ4zb5GhjwX2wOeb9JZHmtKQmcv/N+4bK8t3lfa0GiJLxJK7GKdI9sbNlZ67lqo0nKlkosBnGnJGlsdpG8Gkw1exXLc1QbuecPFWTyNQ8nALAsuKUhzOfjl2tLNfmTlUJoIrYlbcY1mVe65pQjETYFumJAeX2rRQirEbo+TZJpVbEki+PnyTtM+ap31
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199021)(38070700005)(6486002)(71200400001)(53546011)(26005)(6506007)(6512007)(36756003)(2616005)(86362001)(186003)(38100700002)(122000001)(82960400001)(7416002)(110136005)(54906003)(5660300002)(4744005)(316002)(41300700001)(91956017)(8936002)(8676002)(64756008)(66476007)(66946007)(66556008)(4326008)(76116006)(478600001)(66446008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2NWR3oxa00zYVEzdzEyVjdNQTBsT3hUWUpmaW80S0IzVkdKZmVhUW9wUW85?=
 =?utf-8?B?MGxHZmd1emNhdXpjakFySW1Rb3FVUGtjTDlESlBhTE5LM2QxSC9OS1JQYVUv?=
 =?utf-8?B?VEFXTmdjeGlKcVNJZkh2ZUlqOGFxVlQxNUxaV29PTEFscjQ0UkE3UzJ3OHFx?=
 =?utf-8?B?SXQ4aUFaaHVuekE1SXFZT0N1ZzQ5bU13TlVGRERTNDFmRlhRdzI5c21vck5q?=
 =?utf-8?B?anpTV0FHTWJITmZtODNTTExvTjk3d1g3b0xMSkNOdjBjZEI3Vmc0SThqSDdV?=
 =?utf-8?B?anVyRzd5OGVTMzFjMFZVVDc5ZHFESkdDVjRZd0lnRDRQdWc2dkNiNG8xS01Y?=
 =?utf-8?B?RWtMb0xnWGlLYnMvOFZaN0JoOWlVMElES2JScnA4K01yVFNldlhrZmQyblEz?=
 =?utf-8?B?MzluR0NNRjdKdSs4VnBqQng0WlBJbFAwcHE2Vlk3NlROMjZ5bzZieGhEaW9j?=
 =?utf-8?B?UFYzVUFnRzhlZ1ErYWkxS3BYYUxHcVU4Wk5zTlJMSmsxRkM4OXpCdzE5cnJC?=
 =?utf-8?B?Vjlsc3hreHNkeWNFcTBqUDM3dld6OE9DVXllc3JqZXBsallaQlhneU03SFdj?=
 =?utf-8?B?UVcrZ0ZhMWF0dVZiTzlBODBYblJ2akdEVWx4eVdXNUZiWVoxMFZlMTZLemFT?=
 =?utf-8?B?V3lzQmZNSlZlalVlVU5BdU9rSndweDMrcldNaWVZMTdNNnRxcXBiV0dPMk5V?=
 =?utf-8?B?NmxYSXV6YmpvREc4VS9HOFBPNG5QK1hvRG5mYnNoTEdaRG5rd1o3VSsrWDVP?=
 =?utf-8?B?U3N4cWxZTGdkWWJ6WU9MNnp6M1J2RTFQNXIwakJzWUovbTVsRU5hQzV2MmdG?=
 =?utf-8?B?K2Vyb094WWNVNEgxWGcxY1dCb3h6VTVZY2oyRVRGU1N0OWtud3U0eE1rdW5M?=
 =?utf-8?B?WXpPYW1xUGJNVStrRE5CZ1BZb3V4aWhtd0s1N0NnUkhLZWxaZEt0Sy9nUjJN?=
 =?utf-8?B?WXo3aUhlNjUxVW9SMmJMZHc1MmZlRTVkUW1wL284d2twTHk2UHNBZVJRajgz?=
 =?utf-8?B?S3FwR0lhOUk0aUQzUDRqTmhFZVY1ak9HVzBMR0R5R3AzQ1oyb0VHdXFLMVBW?=
 =?utf-8?B?UVU2czFDTHZBVGtDemIvTklONE1DTmduZnR6ZkFkN0lySU5YYkNMdm9lRU5X?=
 =?utf-8?B?RzMzaVlCYTVYVnozNnhmRDlWSXFzUUZVdGY3eEhjWTBsQWZZMG13MkpCSE9Q?=
 =?utf-8?B?c1k3dk4zN0YxbVdxRHY5bDBHOUhVTU80WDJ1QTI3U1hOdWoyUEJQQThKVHVY?=
 =?utf-8?B?VG4yVlFMRUNPU3FaV09ZanhsaW5ib0RRYXlBYTM2QXphNk1JUmNONjgwcmRW?=
 =?utf-8?B?SWl5eUtRR1I0S1lKTS8xU29GOUlFenAzd2dYa05ZZ3FoeFYwVkFmY0xQK0Jr?=
 =?utf-8?B?VEE4MXQ4R1VuWSs1akJFVjF1NFhXRmZnSG9uNUFnQVJIK1RCdjRMMHh1aUN3?=
 =?utf-8?B?QVl0WklFYWJJcW9jY0RXZURTOFE1V3c4YitKZzJvVkFHdDZ2bk8zeEh3cWlS?=
 =?utf-8?B?d29nZ1JSVHg4QVVVRVVtanZRRXF1d3g4d3AvMitxVkZTbTB3dU9aenRYVnZ4?=
 =?utf-8?B?WmtzYVFDejR5ZEs1clFkd1pZM2RvRzVKdXBVYmZvVTdTMnRxdWxTMjQ5SFpm?=
 =?utf-8?B?cmR5RUhMdEJGUFFLRGdCdklvRWcwc1pQOGoyZXE2UEhtMjJqTFByMlNEU0pG?=
 =?utf-8?B?dFZEejVLcDczUDl1elNlVUkzK1lONThrR1R1c1N4cmZZNkQ4UTU4VlQ1TWJr?=
 =?utf-8?B?ZFdGZUlmbEVpWEtyTTBMWDN2U2JDbFJNdW9TNWNiNUVrQkF5VjNYaFZRRmtP?=
 =?utf-8?B?NTh6R2lKZkQ5RFZrblRaUDdFbXRocEVXT0x0QlpQWi9SYnEwMlZ3TG55WGQy?=
 =?utf-8?B?Y04xNk9UM1NqRmFlalpValV1b1d2RnFRTy9VdUl1Z3JIQ3JVaEk3RFRzRGM3?=
 =?utf-8?B?aStjYXF0ZUIweEowdDFDS1hIbjV6R1FPbGZDYmV3cTg5dlRUb3lMMXAvaFQy?=
 =?utf-8?B?OW9MQ0VOZEN2cy95MGlWV0t2U1ppaldXL1JOdWFKbEJLTGpScHNIQ2JRTGdZ?=
 =?utf-8?B?Wjk0SFpqYjhaZEFlRkpINEExUTBOU2g2bm5wK3c0STcyZXlLZnRpQXZYbElF?=
 =?utf-8?Q?UezI0c83ynE1a/Za5xYqxUYIS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F8686909FE3A4499D82BB29BA9F0A4E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad81fab4-97fe-4798-a3fc-08db661c12ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 23:24:56.5345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lr7mR1pLoBJJEuJy7T/1AGDca/2GP0dRNlN0jBO0xubEWMbhF2o4SS9BMv7IJky47zNXFDnaCCfEjwfYHnhFDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8318
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

T24gTW9uLCAyMDIzLTA2LTA1IGF0IDE2OjA4IC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDYvNS8yMyAxNjowNCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBJJ3ZlIGNoYW5nZWQgdG8g
LUVOT0RFViB3aGljaCBkb2Vzbid0IGNhdXNlIGJ1aWxkIGVycm9yIGluIG15IHRlc3QuDQo+ID4g
DQo+ID4gSSBhZ3JlZSBpdCdzIGJldHRlciB0byBpbmNsdWRlIGVycm5vLmggZXhwbGljaXRseSBi
dXQgSU1ITyBpdCdzIGEgcHJvYmxlbSBpbiB0aGUNCj4gPiBleGlzdGluZyB1cHN0cmVhbSBjb2Rl
ICh0ZHhfa3ZtX2h5cGVyY2FsbCgpIHJldHVybnMgLUVOT0RFViB3aGVuIElOVEVMX1REWF9HVUVT
VA0KPiA+IGlzIG9mZiksIHRodXMgc2hvdWxkIGJlIGFkZHJlc3NlZCBpbiBhIHNlcGFyYXRlIHBh
dGNoIGJ1dCBub3QgZm9sZGVkIGludG8gdGhpcw0KPiA+IG9uZS4NCj4gPiANCj4gPiBTaW5jZSBu
b3cgdGhlcmUncyBubyBidWlsZCBlcnJvciwgSSBoZXNpdGF0ZWQgdG8gYWRkZWQgc3VjaCBwYXRj
aC4gIEkgY2FuIGRvIGl0DQo+ID4gc2VwYXJhdGVseSBpZiBpdCBzaG91bGQgYmUgYWRkcmVzc2Vk
Lg0KPiANCj4gWWVzLCBpdCBzaG91bGQgYmUgYWRkcmVzc2VkLg0KPiANCg0KSSdsbCBzZW5kIG91
dCBhIHNlcGFyYXRlIHBhdGNoIHRvIGFkZHJlc3MuICBUaGFua3MhDQo=
