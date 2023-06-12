Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC63F72B56B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 04:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjFLC2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 22:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjFLC2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 22:28:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAFDA4;
        Sun, 11 Jun 2023 19:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686536927; x=1718072927;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SlcYP6L+AXHp+H/LeaVkJPgp1sflfMv4QHbbpzg4aFk=;
  b=DYT/8/ucHFW9IZmRhBQjSqy+Es4Cg5zXJEOoy5zt/2HzhnLW7zYHrSo+
   K/iPmMynncFaz4ISkfwAJd8svfgRMWG+RnPgRqzMgJ5N8BoOjw9zEStjU
   wDitZkyHdCBnQSbXuZ7aQUokQ1xLJb6Ymqu/6OZkPsHH3ShXkre/41wY3
   7iM9sm357T9MednZO2vwL7TkcCncY9S95inUhkYj52UcwYCKoe3YtnP7B
   isqJSYedBM88+KIbmkghhZ1eYv4NptbsrV+eO7fZPBFAqSeSWaJ82vbjk
   mTcUpj1tyIcnySqZt4zxQKer2+LYY1CzAGIRZaQ0nb7Lv0YouTm/xo6gn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="356813674"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="356813674"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 19:28:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="744153055"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="744153055"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 11 Jun 2023 19:28:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:28:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:28:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 19:28:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 19:28:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmVWNN2eAeclLdr8tVEieWbUqWY8lAfEtJYdWJNDE07uMZ6aaFIBR7XfxQzHZJfXOrcoDtuakBem9/I1GG19go0nTJcLLM3l0/omjk35lUyb5ZwVZaHU89BOIYNRyyyvQGwSMcUVjdgnAIQOp4fmMUYOVPALWJoXaKVqDkXOl4xXrNyNFnD6YeqsmgmrjwoxQbFa5AZXcWIX6LdR4dvid/RX8jJZqecLrh2/tYVso8E9AbfNw3BedIUt7LEd/iHhbIc5s+najB9tburAF3Kbf2uysG4dyI1Cvy8LPMjNZFq8gT0+hlVXEFqo1PI9jh1onTQmg00oul0j5fUP5smGLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlcYP6L+AXHp+H/LeaVkJPgp1sflfMv4QHbbpzg4aFk=;
 b=ih0ArfrkDlyoFTjE+NJU8SpkDDt7HD1y93AlwvOguJHq2g3iyYrClBZbs7O3nclWNhgGRY+NDr1OBpOuCLWCxdTH8Y2NynZMtKo/SzOv4SiZ796uLDSp6eTz04finwMiOSqjj2sUNryeOyOlUKO3NtViynfyfwYU8J0gz5lBMnZbD42bri01urRNg8JQNIa6lgWJGkrb2C6vTHJ/t6YPS09JfgMpJJd1vWW6Ux603H5nIIVyigcmnFJSZTXbASh7pRHRYoD6csj/1LWJFoFHC8r4k3t+etlJsE8r/7QYMNidFszAzA7K+L7fqMi7FLIZfMPTC5Sgpp0D8QfN5R4SvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6092.namprd11.prod.outlook.com (2603:10b6:930:2c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 02:28:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 02:28:41 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Index: AQHZlu+2r84uqtF1H0SFKn93tuC1FK+B4C6AgASdIwA=
Date:   Mon, 12 Jun 2023 02:28:41 +0000
Message-ID: <2d3cd099714369d6f7ceb5c89595a9c4cf42e9a2.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
         <77187035-52c0-77b4-7c9e-d09ece77e0ce@linux.intel.com>
In-Reply-To: <77187035-52c0-77b4-7c9e-d09ece77e0ce@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6092:EE_
x-ms-office365-filtering-correlation-id: 57da1748-a514-4a13-f916-08db6aecbc95
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PPIjB5zxpIO5xXGD1Im86uJfh4ie1bri3bDGIKqlvnh+8k0KZpEt6IhdulB8hO6GhBFLxLNK9ppUlpDZ8rWbJW/MKolBv+7UUxNXdX8TsEc8YXn1tPRaCY1WcA2baxDKLjKns4FAs4hYCoovOV1xNDVlHeAs9TKT3WdsFRp+4Ws43pRalqhhH2keh6Lnk6mrEOLFJAniWonuqwsqcO0S5GtUVAC8EEXboLQmFi7qCC91CTungUhvpPaiCTZrZTx6M8xwnCoz96Ded6OlpNEa4OSMumsby3gRAo/rguy7IkZXlQ0V/20oyCFN6Z/KZT+nZ5nm6rGJIrtti5/57qbxUpUM9Xs0iwTbZzdVDKT9UPtu391aq03KzbTARWiNqT2o3eE3ztS1rcsq1UTeH6zm8FItEbC0yGm0+bvMdoK3TTSq5wyp1bNbX0F3QmBydwP4ImdapIgSk/1FEHIKgn5DPlWCCfy3ITMIwrqipK5eK7A+aBvzclPkugnKwgblCvL/2ZCCKuROHhBKJdRrS1Rg46ajF6cY/dtLLy60qDUDpSmwAvhVUitbHUzUoyuA6/oANwg0JfIzMT150s9WZFmX8CqRmufXe4HANkI1D0WjQFA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199021)(2616005)(186003)(53546011)(26005)(6512007)(478600001)(6486002)(6506007)(71200400001)(110136005)(54906003)(82960400001)(316002)(41300700001)(5660300002)(38100700002)(8676002)(8936002)(91956017)(76116006)(66556008)(7416002)(4326008)(122000001)(66946007)(66446008)(64756008)(2906002)(66476007)(86362001)(38070700005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGdxdFpzOWJ0Ym1tekduT08zN1NmbE82VUViTkdGWGhQWDl2bGw3cFpnN04x?=
 =?utf-8?B?WnlPeEcyVm9oL2U5VUQ3YU04dkNoVFVkb1dlRzBVYjUzYWVWTG05TjRTeFdH?=
 =?utf-8?B?aDhRZ1ZUVWZ6b2RiL2dDeEdmdnZ0VVUrSWhKMW8xRmdOV1RsaEJWS2doVU9C?=
 =?utf-8?B?TEkxRjhHMlhmMExIZEFUVHJnNEs2a3FhMi9tTk9hamtNWjk5bGMydWVvYW9p?=
 =?utf-8?B?S21QemJ2R2RvZHNVbUJ6Q0hJNnFYME5mNkhSR0JrWmF6UUVIb1hFaEFvb3RX?=
 =?utf-8?B?S1ZYV3J5em54cFJzQXJLK3FJZ25CWjNNMEdobW95MUhBZllKdE1yWXh0Wjc3?=
 =?utf-8?B?SmJlYk52eitXQ002WkQ4Y0lBaGVwYVg0SzVnYU1qSE9oMElaNENxajY0MFhS?=
 =?utf-8?B?MnV4R2xlYUcwWDFjMlVoWDRqRTZhcXQxcGlEak5tMTQzZVlpQi9EQ2E1VzFT?=
 =?utf-8?B?MjlTVlh6aXcvUFJZRTIydkFVUEVxUjFxS2J2YUloYjlrbE10aFhGRE1EMTlU?=
 =?utf-8?B?c2g0ZExJam1qSmpzTnBGVlhMaDA2QzdMeWk0M0o2ejdJWU9naWVXYy9zSVNu?=
 =?utf-8?B?V1R6bHhPdUdzNm5GK0Z3WWlhbzNwbktBS2NCVkUweENES0M4WklMRGdxSE4z?=
 =?utf-8?B?cDk1ZDA2WW5aRUVwM1JPcHZYQ3JOU1FZbUE5SnVzeTFNZ2NoZmgzUTM4V293?=
 =?utf-8?B?SVl5QXlXNEdhdzQ2R21aM1YzVFIreCtQby8zanVqRzdkQ2RYSy9kbWhmYUFr?=
 =?utf-8?B?eVJDd1lJd1d3QzMvcnZKaGVOTGh3VDJhY2NQRlRrVjRFcFp5YjJDK2RmaTAr?=
 =?utf-8?B?bEpNZjhqeHpHSDllMkRSUGQzN0s5RkQwdXkrL0NPclFxY082cTN4WDFDOHda?=
 =?utf-8?B?OGc3SkV2Y0NVNC9SR01xM0hhUTRpU29SeFZPTzNRc0pYSXBwc3Z1VGYyMTVx?=
 =?utf-8?B?eHhSTlUwTE5TZGJackZyc2xOaitwRjZhdVorVm13OU8rWXZnYkJxWm81VWNp?=
 =?utf-8?B?NWxYSFJaU3NhUzRGZzhPZDVSVjZEekxwc0pvQnZkU1BjMmRvcnFzQy9DblBk?=
 =?utf-8?B?QW5FQkVFdWsySEU2UzNUNm45ZTlMTGRWVmZlSmRQSmxZTXBadEEwaXgySGVC?=
 =?utf-8?B?Njd4K01HWDdRZTdiR1k4dWEyZWVCdk5yU3gxYkg5V3QwNjQwazA1bjgrdWF2?=
 =?utf-8?B?bXdhVkZEa2pyU3FWNEdnM09kbk9CMXloZDZsN3ZPL0V3OVc2WDRXQzdDZmg0?=
 =?utf-8?B?RUNEQXQ1VUplbjhYUkJOdXBQNGpjdTAyRjdoUTA4VDVNUHE4LzdkbUNrNXBt?=
 =?utf-8?B?NUlON1MvOE5DMWlwU2Q3VjVackZ6SFNGVlFibDNENW5Bb0lJK1hydU9pUHBm?=
 =?utf-8?B?QkhmU2hXbTlyV254U0crUkZqMHdvOW5uNGRXR3RxbkkrRWlCZmpBWUtrNVVX?=
 =?utf-8?B?RW8yMU1ORS9ENzgvM2ttT2NBUGtNbkpUN1J4WGh6VDVwUko5VitHUVpYVnNQ?=
 =?utf-8?B?aWFNdEVuenpPR21rZWwwbUIxMmlEYk9tczdsWkY5MDBkRWZWNVdyU05oeFVs?=
 =?utf-8?B?aWttWmQ1Z3ZMTi9Lekl0WTEwYXU3SGlESUpTRDMrN1c4T0cyRTdBM3BjMWc1?=
 =?utf-8?B?blBNTmNkb25FWTN0T3FwZnI1SUxsaHdORVZnU0tkSTBndmhFZndTd1lsWXdN?=
 =?utf-8?B?ZFJ0dk1xYjhXa09IZFZRNHpEYVVMTUh5L2NGSm5JRjFmTlE0YXI4M0l3Y1BQ?=
 =?utf-8?B?UjJNRk1TNWhRTDd4cHRMK0RUV1REVE94VW1VdGF5NDVjQXB2SXNJK2IxMFBF?=
 =?utf-8?B?eFFPZU83WFlzV0k1K3FoMWlwTmZuUkhLQSs2MUdnVDNqWE9NRmkwSGVwRHpn?=
 =?utf-8?B?QWF5c1pLRFdoM1JFeG10SzFsem5QK0wzRHJDekFIZTdEUnhzSCtOMVlpOER1?=
 =?utf-8?B?aWY5VndFQ3NHQk9tOG5oREk2UXo2Z0V3OWdDSkJvV0llRWUwVTRZNWUySk9y?=
 =?utf-8?B?c3dwY2JUYUtKb0pLSXVqbFlIQ0pIL2hQN2VsV3RtbzdDL1BINFdlRFdSNlBF?=
 =?utf-8?B?UWxvMEpNUXRMWGdYOHFFQ2Mxa2hSQjdZRjUva2w4cDJaa1FwT0dQNG16WURQ?=
 =?utf-8?Q?eT5vNZWt02sPi022EXtQhV2vo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97ED07A4AF88694091106FBB8132F042@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57da1748-a514-4a13-f916-08db6aecbc95
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 02:28:41.1309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H2hBpXQA/63xZBhFO1SaW0lzIuGxcpvJvGPufloUlnStl4COyWr0khqBYnp6WYvCSjC3HWSJvqIZk67IOYtO9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6092
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

T24gVGh1LCAyMDIzLTA2LTA4IGF0IDIxOjAxIC0wNzAwLCBTYXRoeWFuYXJheWFuYW4gS3VwcHVz
d2FteSB3cm90ZToNCj4gDQo+IE9uIDYvNC8yMyA3OjI3IEFNLCBLYWkgSHVhbmcgd3JvdGU6DQo+
ID4gU3RhcnQgdG8gdHJhbnNpdCBvdXQgdGhlICJtdWx0aS1zdGVwcyIgdG8gY29uc3RydWN0IGEg
bGlzdCBvZiAiVEQgTWVtb3J5DQo+ID4gUmVnaW9ucyIgKFRETVJzKSB0byBjb3ZlciBhbGwgVERY
LXVzYWJsZSBtZW1vcnkgcmVnaW9ucy4NCj4gPiANCj4gPiBUaGUga2VybmVsIGNvbmZpZ3VyZXMg
VERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucyBieSBwYXNzaW5nIGEgbGlzdCBvZg0KPiA+IFRETVJz
ICJURCBNZW1vcnkgUmVnaW9ucyIgKFRETVJzKSB0byB0aGUgVERYIG1vZHVsZS4gIEVhY2ggVERN
UiBjb250YWlucw0KPiA+IHRoZSBpbmZvcm1hdGlvbiBvZiB0aGUgYmFzZS9zaXplIG9mIGEgbWVt
b3J5IHJlZ2lvbiwgdGhlIGJhc2Uvc2l6ZSBvZiB0aGUNCj4gPiBhc3NvY2lhdGVkIFBoeXNpY2Fs
IEFkZHJlc3MgTWV0YWRhdGEgVGFibGUgKFBBTVQpIGFuZCBhIGxpc3Qgb2YgcmVzZXJ2ZWQNCj4g
PiBhcmVhcyBpbiB0aGUgcmVnaW9uLg0KPiA+IA0KPiA+IERvIHRoZSBmaXJzdCBzdGVwIHRvIGZp
bGwgb3V0IGEgbnVtYmVyIG9mIFRETVJzIHRvIGNvdmVyIGFsbCBURFggbWVtb3J5DQo+ID4gcmVn
aW9ucy4gIFRvIGtlZXAgaXQgc2ltcGxlLCBhbHdheXMgdHJ5IHRvIHVzZSBvbmUgVERNUiBmb3Ig
ZWFjaCBtZW1vcnkNCj4gPiByZWdpb24uICBBcyB0aGUgZmlyc3Qgc3RlcCBvbmx5IHNldCB1cCB0
aGUgYmFzZS9zaXplIGZvciBlYWNoIFRETVIuDQo+IA0KPiBBcyBhIGZpcnN0IHN0ZXA/DQoNCk5v
dCBzdXJlIHRoZXJlIGFyZSB0d28gb3IgbW9yZSBmaXJzdCBzdGVwcz8gIEkgdGhpbmsgSSdsbCBr
ZWVwIGl0IGFzIGlzLg0KDQpbLi4uXQ0KDQo+ID4gKyNkZWZpbmUgVERNUl9BTElHTk1FTlQJCUJJ
VF9VTEwoMzApDQo+ID4gKyNkZWZpbmUgVERNUl9QRk5fQUxJR05NRU5UCShURE1SX0FMSUdOTUVO
VCA+PiBQQUdFX1NISUZUKQ0KPiANCj4gVGhpcyBtYWNybyBpcyBuZXZlciB1c2VkLiBNYXliZSB5
b3UgY2FuIGRyb3AgaXQgZnJvbSB0aGlzIHBhdGNoLg0KDQpPSyB3aWxsIGRvLiANCg0KWy4uLl0N
Cg0KPiANCj4gUmVzdCBsb29rcyBnb29kIHRvIG1lLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEt1cHB1
c3dhbXkgU2F0aHlhbmFyYXlhbmFuIDxzYXRoeWFuYXJheWFuYW4ua3VwcHVzd2FteUBsaW51eC5p
bnRlbC5jb20+DQo+IA0KDQpUaGFua3MuDQo=
