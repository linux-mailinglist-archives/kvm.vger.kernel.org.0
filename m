Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D85B741CB3
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjF2ABF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjF2AAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:00:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A002FED;
        Wed, 28 Jun 2023 17:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687996848; x=1719532848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=18kcT73AmcZ8illrWjQtM4QTNbN4/J4Um5kcuH6xUEs=;
  b=gpd1XY5YOcu0F1pKDWzIF4i54lI3H/d2A1t+f53qOpTld0nonI231G8+
   XrNzkq0pj2zQQpXDCpyS4l2jlPU4iFHFiRAM3FPmffas3G1nm+nCePMz5
   OIGWc6kDIHgtyz0kshxBDoSonOTxvwv/wiBUf/N2ZctPThSoG3qyMo3KY
   gN9JwErN2MX0+7GyZEXwIhwawXKXglCZDcaQan93QzYlEiF5FsM31Omec
   pNV/Sk1BMlqOCduVs6D7wFmdWly08sjUZcBlsNG2nOUe5SR3DrRzkIBbO
   gjSdwxkVRRR17/RJA5FjBlBGL4MSuV5QKp7LUxAWkLMhftJNA2m++2tGh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="365450849"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="365450849"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="787201239"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="787201239"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2023 17:00:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:00:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:00:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 17:00:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 17:00:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAap4eGhvQ/QbO8y7opMhDInQmxXLXRQFNHYjTiowYZ5aaAKIAf0Bre6IKkB0ParAICJqkFcgQ/zNi+FPgIHQ3GbAUAuCnszo6icV8KYJXUmebXmmSXjbiUutEej0MCKhPutqJX1vw0Ln7DWbAGO9KcOCmfLHWvDHagiLv0ASoAx+SCvscBzVM8eCK4Kd6VR9Sk/Pl8KZvN7WiRiCYNVHJjXJE102Fy4ZoXmgTtR/C6J7cmAdvZOkhY7tLcr68GVsHLyAhGC17JyfwCpwIaGmiIQZJW5mKLcalGrbQ+eTt8k/7oEnpZyUAOs2tkRzq46F0bZSBeUB8kFZFTrPb4oFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18kcT73AmcZ8illrWjQtM4QTNbN4/J4Um5kcuH6xUEs=;
 b=OSWh4Daj/G8HZEn3HQoShpgVnOcX1d3rTP0Efm9dOA+qUWH7JejFkXyrhkMQwQAS4QJvdhg4U496hdXTfAdpflJ2T95Z3I9Uf4q96axu8DkcAemzenmASnQ9enPgnvrAq/p7BTjNzB9p9N6j5vFNudSOgMnF+r+/Gpw+jYS2pkbCaD9JL/svhYghwlob6fmfrxfy/Gt0644tx/KWn7F8ot9MO+wGzG0pDdejlUbwx9Fbwd0evSs1++WLgXYr0TGfS7m1KwvxiIDChAKHaHrCY3aqTy/a/H9g4gxx584UOIIj8DXHVOQvXyNfu2av1U/uazZeV94+9NzEpxYaBOdynw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4639.namprd11.prod.outlook.com (2603:10b6:806:70::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 00:00:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 00:00:44 +0000
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
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+gMa2AgAC3Y4A=
Date:   Thu, 29 Jun 2023 00:00:44 +0000
Message-ID: <20322f0432e418eaacfe397aa9363f94ada0b902.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230628130419.GC2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628130419.GC2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4639:EE_
x-ms-office365-filtering-correlation-id: eabb828b-a385-467f-1882-08db7833e2a1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HKO03sE3tWYrpvdUzxrJbWpO7nJg05FyqsVKV3pNP7rW7wM1Ivb2yBCXqZn47F80MUCP/seVTAT+cCiZd9mWei0aSkz2WxBDpXgsjHkfk79uW/jBjB/R67488Sm2SdupZsHUI0F2uXBF/UsmpwDKWuQpBjr0BKgmr4vxJHdZjO54HdHDL91ViNPo4wbEz1pWj9NS0P3Vn+udfLx7TZHX6qSyzeAG9T5MQb15RzL0hj6VnB/h4vPE6rTllAODpbnSDeUU4OnkgrASG5A+frQTVSyMaH4vSyU7Ua/pL9AKEcRPnrId5//kn7CNzTVG7urk8zKnLws62zD9bLTUOpg6KSIKnH02u3Blv7kQ3Z35R7URPISQ7AYxchJ8eRvgm77Ngo2IVvWqZuKDRuFJDHlvn/a/NKieoQoryy2xEn/CbIZI5MBvJErd/7TY90S7BiTYr3xazkLg6YuILo44XtfCVsRKqHopclQZRw8tD4FYR4uK3sPvYkXDA2QQXhOqs96AiFxEQYD+dmpAFux1BPUa7aifRGsPiHc/MLAgwi+0OqwxJXoyylDN/hWYgYy0pHbNfXPuQr6nFudf+Q0tDRZm5qpzdZ2am8ytDyb16VD3WUNnrP1ZokDx+c0ATif1vdO9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199021)(6512007)(36756003)(5660300002)(38100700002)(86362001)(41300700001)(7416002)(91956017)(66476007)(6916009)(8936002)(8676002)(66446008)(64756008)(316002)(38070700005)(66946007)(122000001)(66556008)(4326008)(82960400001)(76116006)(6486002)(478600001)(2906002)(6506007)(71200400001)(26005)(54906003)(186003)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjJzbDU3VmlVaVBxWkoyWnN2ZDA1WXNSV243U0VuTFpNc2s1TDVmRU05OTJD?=
 =?utf-8?B?aEpyeWNURDBGMWRNVlBxeWJwWGVnMG91V2pQU1RYOEFGeisvOFVlWjVqUXNl?=
 =?utf-8?B?NUF4aWlpZEJxeHJFakp2U08yNHFGdUIzazVuUUhRbW04czdQd0pRYThwS0NV?=
 =?utf-8?B?VUN6elp5NzNndEsrczhjZFFDbUJPSHVPWjg4UEQrM0xKYTY5SkhaOHdoc1Nh?=
 =?utf-8?B?ME96eUtISUY3RG1QRWJRVkJBV3ZqLzhEYnNLdnV3Y0h6YTk2RkF3THVraUJR?=
 =?utf-8?B?Vm5rN1pGaWJmdHYrVWEyK1hkdUtheVdoSEx5bDlib25VRHJ6YlZZdjVLeXVr?=
 =?utf-8?B?M3RsMytqaUNoaXJySWhZUGNDU2dsdWFFQkczaC9JcGdLMzBlWXJvTm5RUWdD?=
 =?utf-8?B?bXdpWlYzNHpYRkFobWNZZ1pSV2VvZENNaGZ2WnFwbTd4RnFuUU9EZ0pGcktF?=
 =?utf-8?B?cmovaTIrZDJZaHIwWWd2NUx5NGtBMVlVNDFudGNkRm5vNnNJaHpxViswM3VM?=
 =?utf-8?B?ZGkzTmdPbm1vR2JZWW1ZY0RXM0tncGJCMzhtSjVLeG02Y3Q5SWRQNDEvNTVI?=
 =?utf-8?B?UTB0ajJORStGelhtM1JsNHRsTFRaVkZ2d3BJN3AvR2ZMOWMxcUNnYjFISHdN?=
 =?utf-8?B?b1VHYkIzM3Bjb1p3Nkd6ZENDZGN5YmduU0hsUEFlRFU1aGdTTHVYYm1wZzVv?=
 =?utf-8?B?eGNoUnR0YUlCU3F3SklGZUN1L1B5RUNvLzBOYTAvSWZmVnhFRzg5SXZKSnVr?=
 =?utf-8?B?MFVXMGdKWDRBWGFaalcxQUEwVm1nNzVIanl4NDZndnphWGVXSndGdnlzcGZw?=
 =?utf-8?B?Qmg1clpXUlNBaG5SdTlWWWtHR085WWI4YnkrTVd3N1R6cWpHaXhiNWFacDJy?=
 =?utf-8?B?NUlUSDJTVUZrNEcwc3I2VnlpWmV1WStTQ1dNdFAwdEV6eG9ENmllR1BYN3lR?=
 =?utf-8?B?eDdySXBkZkVTelZkSm9OOHFZTkpyZ3FuaHRaOWpSd0crWFBTOTM4N3VMVDQz?=
 =?utf-8?B?a1pqVmJ1VW5IM1V5QURKR3V3Z0RiaUtaUmV2UTdoc2pDbG5GbEtMamdLaysy?=
 =?utf-8?B?S0NtaURNR3dxNVhsRUx1NC9pVzdzUGRoUkwrY0xxVkpmS2JyRDZvdFZGdExO?=
 =?utf-8?B?SFd1aEIxcnVrMGpXREMxV3J4NzZncXBya1JiTU1TK0l0WnRGR2tQYVNYNXhX?=
 =?utf-8?B?WkJ4OWVpQy9IdG53N0R3VWZqSHdKUUd3L2Jybjdjd2NQRS84bGdSZWdIL3lX?=
 =?utf-8?B?amh4Q2ZXSXloN3RBTjdQRERGTXVoWTVjYTJLTEpSc2tXWUs1YTQrTUcrNkpG?=
 =?utf-8?B?RDRLLzgvNUpLWjUveHdkUlVZeVlCbEZsRTBPWENmeC9HYkdJRmRQRWUrWFZO?=
 =?utf-8?B?ekVjSEZZejBXK0RnN3hYamwrKzdFTHFuenU3WWpOeDQ4cVphK1BTb3RQaElM?=
 =?utf-8?B?SWFuVEQ4U0hmSit0UWlKY3VjL21UOTFDeG5nbEN1enY2a0dVYTBPbWZDRUtC?=
 =?utf-8?B?UG4rdURBUFVQRVNBTFdjanpCcnY5WlpHaDBkTmJZUHgxZVQxZVhUdnBxQ0xp?=
 =?utf-8?B?Q1lVS3h3TlBRcTI3MUJjUlIyRXoyMGVPbDhIYXNpTVRrQ25DTlk1R3ZhNHl4?=
 =?utf-8?B?cUNFQThCYTlLYnlNbUxzNnBYbnc0NjlQWmNPcVdtYVJpZjlpd290NnNXZGtj?=
 =?utf-8?B?VjZnNWNGay9tWlhZQW9kb0xqNDVHRFNCSVV6Q3BrNWFLLzR6WS9SNFJjdnRN?=
 =?utf-8?B?OFVLekVzMDBXNWVGdThwYkx3YmhYSDgvK2c3TGZHbGZDREsraEF6SzA5QlJ5?=
 =?utf-8?B?ZDFBRlI4bmR0UjN2RzkwM1gzNllselhudGoxRUt5NlltVWJzU09OdVk5ZDZI?=
 =?utf-8?B?MnZTOWYzRE1sbk5hTnJPTDhXei83YlA5U3BzbG02RHdNNFllMzVIQVA2Qnds?=
 =?utf-8?B?SzhOV3Q1OXV5ME4rdjErd01DQUVWNFpNL3VDL0lka3lpMDFMSURoeVZOSWJQ?=
 =?utf-8?B?UGltNTdaaFNTNzNjYTZKbGtjQVJUcUlTYW1JczFqaE13Z0dKUmFUZXp3M1Ir?=
 =?utf-8?B?bG56MVdSK0JSNmhwdExITXJrM3p2cmlsT1Z1Y05va0NaZE56YXhOZis2MVIy?=
 =?utf-8?B?d01WYjdUOUVLbGFXb3J6NGptQU9rM3VveVZKallyS1FVRXZnOThKMjhoSyt3?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50E3DE94B478CA45B9D5D797C40ED69F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eabb828b-a385-467f-1882-08db7833e2a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 00:00:44.3382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ulI70SalQKmORoUvtzaZ3kfO2cwAjj2EuJLzpJZO65PpIgPIewUFDGSq0yoHwnQI74Gk+HboUlQDcol5O0Qf4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4639
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE1OjA0ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6MzdBTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiANCj4gPiArc3RhdGljIGludCB0cnlfaW5pdF9tb2R1bGVfZ2xvYmFsKHZvaWQpDQo+
ID4gK3sNCj4gPiArCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsN
Cj4gPiArCS8qDQo+ID4gKwkgKiBUaGUgVERYIG1vZHVsZSBnbG9iYWwgaW5pdGlhbGl6YXRpb24g
b25seSBuZWVkcyB0byBiZSBkb25lDQo+ID4gKwkgKiBvbmNlIG9uIGFueSBjcHUuDQo+ID4gKwkg
Ki8NCj4gPiArCXJhd19zcGluX2xvY2tfaXJxc2F2ZSgmdGR4X2dsb2JhbF9pbml0X2xvY2ssIGZs
YWdzKTsNCj4gPiArDQo+ID4gKwlpZiAodGR4X2dsb2JhbF9pbml0aWFsaXplZCkgew0KPiA+ICsJ
CXJldCA9IDA7DQo+ID4gKwkJZ290byBvdXQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJLyogQWxs
ICcwJ3MgYXJlIGp1c3QgdW51c2VkIHBhcmFtZXRlcnMuICovDQo+ID4gKwlyZXQgPSBzZWFtY2Fs
bChUREhfU1lTX0lOSVQsIDAsIDAsIDAsIDAsIE5VTEwsIE5VTEwpOw0KPiA+ICsJaWYgKCFyZXQp
DQo+ID4gKwkJdGR4X2dsb2JhbF9pbml0aWFsaXplZCA9IHRydWU7DQo+ID4gK291dDoNCj4gPiAr
CXJhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKCZ0ZHhfZ2xvYmFsX2luaXRfbG9jaywgZmxhZ3Mp
Ow0KPiA+ICsNCj4gPiArCXJldHVybiByZXQ7DQo+ID4gK30NCj4gDQo+IEhvdyBsb25nIGRvZXMg
dGhhdCBURFhfU1lTX0lOSVQgdGFrZSBhbmQgd2h5IGlzIGEgcmF3X3NwaW5sb2NrIHdpdGggSVJR
cw0KPiBkaXNhYmxlZCB0aGUgcmlnaHQgd2F5IHRvIHNlcmlhbGl6ZSB0aGlzPw0KDQpUaGUgc3Bl
YyBzYXlzIGl0IGRvZXNuJ3QgaGF2ZSBhIGxhdGVuY3kgcmVxdWlyZW1lbnQsIHNvIHRoZW9yZXRp
Y2FsbHkgaXQgY291bGQNCmJlIGxvbmcuICBTRUFNQ0FMTCBpcyBhIFZNRVhJVCBzbyBpdCB3b3Vs
ZCBhdCBsZWFzdCBjb3N0IHRob3VzYW5kcyBvZiBjeWNsZXMuDQoNCklmIHJhd19zcGlubG9jayBp
c24ndCBkZXNpcmVkLCBJIHRoaW5rIEkgY2FuIGludHJvZHVjZSBhbm90aGVyIGZ1bmN0aW9uIHRv
IGRvDQp0aGlzIGFuZCBsZXQgdGhlIGNhbGxlciB0byBjYWxsIGl0IGJlZm9yZSBjYWxsaW5nIHRk
eF9jcHVfZW5hYmxlKCkuICBFLmcuLCB3ZQ0KY2FuIGhhdmUgYmVsb3cgZnVuY3Rpb25zOg0KDQox
KSB0ZHhfZ2xvYmFsX2luaXQoKQktPiBUREhfU1lTX0lOSVQNCjIpIHRkeF9jcHVfaW5pdCgpCS0+
IFRESF9TWVNfTFBfSU5JVA0KMykgdGR4X2VuYWJsZSgpCQktPiBhY3R1YWwgbW9kdWxlIGluaXRp
YWxpemF0aW9uDQoNCkhvdyBkb2VzIHRoaXMgc291bmQ/DQo=
