Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405D063A482
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 10:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiK1JO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 04:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiK1JOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 04:14:45 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03F7186F2;
        Mon, 28 Nov 2022 01:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669626884; x=1701162884;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=deF3sKGk3BKKc52B4tNFdM35NULY5yHnngahGoFwJuw=;
  b=mcEiYyWDXXenOc7+B88LWB8x24Rydq9zUDJd7GoIripHySx20epE2ldm
   zGKDenBX6xSngYysP3ffqoa/jSfB84olvgZ1ObyTmOsHLSfV4YcJ/Rds1
   kxXZ1lYgkTKoklmmh3FeM7pwteSPEB+uRIM6cl3pO+l3u8+PdxnGbzZok
   dlPBF6fAivAf+N45Ri9Sd41JL7khq99WvjlgjfnYperi3S9sUKiJ6oDb0
   yOERLUWqUC2PhQ4atupSmY04Sq69kAycr6HRI7Fu5v76QNRlodhrrh5M0
   RksXUbgySyzeKyh4rtlqJb26iSkUbbSCfxem1Lfy8Z55pPlbEaa6mDLMh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="295171656"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="295171656"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:14:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="711891271"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="711891271"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 28 Nov 2022 01:14:34 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:14:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:14:27 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:14:27 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:14:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAMEMY8tX8YbNxBp1tcelRg46vVZYoJkMPjE2OjOlwD30twIVuIWS5jJQ0qwlPjwNptJw1GYHzJzv8y6+KYCjOqt//N/EPKs9Ey3FFSGhSkjMqwotnU4uC7+j3vw7jqZpt2KcuYzP45NsQHwEZbQ53+OS8oI30A/S+uSwm3tXLrm2720B1htxTc6aS3R6xzFYKpewOm6vlaafKZ2j7eCaxxni54J3Qp4LD6IXbJ0SPgzMu/9GaSLcy9VbbXkyD2AU69YM0oDPC3fyPqYl0AwiIGlfElKPR7d6NbyoFg+usXbJDfkweF88tuTtaBDHonTWDuRMyPJfLyiQ8q6DQ8I9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deF3sKGk3BKKc52B4tNFdM35NULY5yHnngahGoFwJuw=;
 b=igPS7tqjOMO/fDDBRr0SMN5l29mVCgsGnqwGgRg4CLwjreWiqOQ2QSv0jzgsUPhiElFy/YUbulXWUuUrtOCm6SfXFZ/2jgqDpTVdJ8rCmSOa68VMNhXAIMSdyI6duKWdZdz/durF3KsI9GcuB8XEcL2sJ3kN0/RJetGCmd8YJVL6ZH15H+uyzDZlBX2SszM3NkEWFHek1nzIMWILvdq9cI0Ao7m21el9rvNmnwDeG9QaVSGR5i23u6TTEnPhJKcige/N4qFSLNdaoBWXUtFf11A0Ld0CPk4mBeWZunSCQFQ5+i1tFi3msnYDJRWN+9yyC1r7zlBls5UyCSe8vLuNGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6845.namprd11.prod.outlook.com (2603:10b6:806:29f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:14:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 09:14:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
Subject: Re: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
Thread-Topic: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
Thread-Index: AQHY/T3PFb2p/zo5A0CRtiPfoDprYK5NLyGAgAbp/4A=
Date:   Mon, 28 Nov 2022 09:14:24 +0000
Message-ID: <0ebf26d1ee540b4e082b65c51cabe3327f6d51ac.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <5a5644e691134dc72c5e3fb0fc22fa40d4aa0b34.1668988357.git.kai.huang@intel.com>
         <5526fedd-fa54-0ad2-f356-94b167e6e290@intel.com>
In-Reply-To: <5526fedd-fa54-0ad2-f356-94b167e6e290@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6845:EE_
x-ms-office365-filtering-correlation-id: 9d21dba4-1b40-4db4-f806-08dad120f14f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bqWfz4GLDmadYapQZohA1WGccNJ3BoxWZ0x+f2dxFUJ/nireKGqDgp6yi8enmVm48C/LzIA4/ogi0tjR8VUTQj8ej+KApEozRWGgIP549QAl3VOjAQL3+j8FamoX8RwEnggttSFrKyEMGGix/8y1iWm3Fi5s12Pws3FU2nlxigZFvkFr+dlAdO6iYADw8BOCrsqTFK0DG6iStgdPpXwvIbKoSgfENOZNlffYCidYqG61MtvA5zTKct/KB8HF30UB7VckfbA5guU+Ym6nGlQUFCXUx15EyP7OknjnNaSK4P30VslvUZcFKkLGAp3RPOYUCDngOFqrSBvXT5un3vQtzc3WozzQWZEJGXu8ZALF4G96q5gRhfh0PgA9F3YOQ2P+LdDSkfv8j8NvXtHGKTlW2AAuEz+GIMA94jjCeqPwlxJ1FEhD5I8K+4EbZMz8u5u7op/VF76H1FZqD1KREvNkGEFH+EJVEq68Jg35OnSDwMiGCAYuJwVrHG4xfqJ8QZ8fgy8vh1E6MnU3px6O1aCQ4MYDGnYbhFK3DdcLuGOONI3tRBMA7zjAGdvZNgoShf6dB5DnAHKJOvTVK+LLblA9JL8Pt+BPXlmChx0uOkY1tlCWwcH2Giir6fZnafZrZjhnKHqItDBcS6NxMso0xuRWlWDxSYYn4Cwz8QX0x/axI90I/5H4nz7+XtDmRo4/F5e+HgAz+O5dJwYlV8V6o3f7irJB6arkC4z34oZN0IEVPa9TCvaxpIr6OvWYVSaYtSMK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(4326008)(110136005)(71200400001)(8936002)(76116006)(66946007)(36756003)(41300700001)(91956017)(8676002)(54906003)(316002)(64756008)(66556008)(66476007)(66446008)(83380400001)(82960400001)(38100700002)(122000001)(38070700005)(478600001)(6486002)(6512007)(26005)(186003)(2616005)(6506007)(86362001)(4001150100001)(2906002)(66899015)(5660300002)(7416002)(17423001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cE1FWWJIUGFRRkFUOGVqUlg3dkUrK0pQcnowVUNXZmhYVUZPQ3BjUndnbGlJ?=
 =?utf-8?B?ZEQ5YldIREFwMUx0d0ZzQ21rdTFUTjM0dUROVGprMnYrQzlTNWIvb2dQZHB2?=
 =?utf-8?B?b0FTMUFZcjlHZTl5RE4yQ2R4RnNoRHozc09LRzlJemg1UkMwcFc3TmovdmxB?=
 =?utf-8?B?VFJiUUNOVnJ0RGpIMGhDVDc5YzVyTzdFby92Wlc2dVVWZVpZd3lPZDlLaUMy?=
 =?utf-8?B?NlFEZ1c0Ym5wWlhFVGdiR0trZWFxM1FsSFlLc1VhMzRPNWdvWklmenpCT2x1?=
 =?utf-8?B?NjlzWUJhYWsrZDFpQTFLWTVlS0JoZGFDRGtlNHZUQjBYeFFFWElvTWRSUlRx?=
 =?utf-8?B?ampOaXNEbG1WSmhwREd0ZkFKMnZ6VUhHUkhvd0NxZUNUY1FkSWg1cTk4cUVB?=
 =?utf-8?B?OGJvS2J2cWdwVWtPUXhqaEZJaDc5aHc0RUd3VnJ1b1hZaUptY1poRlZTZmdT?=
 =?utf-8?B?T2c3b1YxRmM5SlNMZ3RmTkY3RklDVmFVZG16bWMvNG9hZHdCOEVONlI2dGht?=
 =?utf-8?B?ZHh5c2dtU2ZzU1RkVmthRGROZGhKWFpPbS8wOG1PRlgzREluNWFtY0FMQ1Q3?=
 =?utf-8?B?SDBVd2FlYjA0MjZJSlpvam1RRm9VRGRQK2VPWm1uNC9lb0praG0wb09PQW5T?=
 =?utf-8?B?ZWJHNVdZRms2bU5mQjgrcnVlaVdNUDlJb0FRZ3lsUG9FV0dNY2VwNlVTbitt?=
 =?utf-8?B?UUh4V2ZSelY2NFBJeFVyOGl0RnJKcUZtVy8vc0p4b1ViT3VEKzdKK1MyQWEr?=
 =?utf-8?B?ZExKM2pvVWFmcWZkUFF3Z3hDR3F5RWxzOUpsYmxOaDVjSEVUWDI0UDJhRWdF?=
 =?utf-8?B?TzZLMmRydXdtS0RORVNzeklXRHBrb3NyLy9TR3NhQkFCSjY4Q0xJRnBlaDhK?=
 =?utf-8?B?ZWpJcW1yZ3NJUFAwYjNGaWdrZk41WTBEeXVCOVZsb0hLMWNuL29LcEErV1Vw?=
 =?utf-8?B?dWozem5sVTVyWExmZVBzRkV3eS8wamhJQkdDRjY0ellJQ2o4Y1F4TFhIS3lH?=
 =?utf-8?B?RWtic3lXZDMzOVZiYzlLS0VTMXY3eUpaTFN3bGdPVU51NGV4aE1RU014WTBR?=
 =?utf-8?B?L3ZES3pMdTk5NFM0Ky8yT0MwTWxTaWkwMUQ2T2FKMWk2MFdWbThydzlJa1hZ?=
 =?utf-8?B?SEVlZ2JJZUg0SDRtL0NONjFlYndpbE92dm9WR0t2aEJEUitjZ21rN2FxWlBv?=
 =?utf-8?B?SGpOYTVmUnptY2dndkZia09CWWlTaXJMYWZydE9DVXFGSjNwcGJjRGJCN09t?=
 =?utf-8?B?WWJvQlRhQ04zOVBjcTBDcHh4Nm9LcFVYdEVQUWtvYk5rbm1NbXRsYmdtZ0xL?=
 =?utf-8?B?NDUvL2hlYWRYKy9lRXRCZnFKV1B3WjV5alJTM0Vjc0RnRDhnU1lHb05OY0ti?=
 =?utf-8?B?ek0wdDJMUmtqY3dwR0EvMjhtMTQzN2pzaEdSZEpwRUg2cHlLOHAxMTlGSXhE?=
 =?utf-8?B?V2dZUytmelVqbHl0NnBScHdaQkRhT1NoUVdTNzdGck9qWWlDRHZ3NHB2Zkxt?=
 =?utf-8?B?YWYxVnFaMmhNZ1RnOVN1N3QvYVlYZlA0KzhOZFd5TzNBN1VwVzR6aXlCYXpJ?=
 =?utf-8?B?RHc1dE96WjBsMEJhdU05LzBOanhiamQ5RmFuUFFzK3JqWmI1YnJSVXpTUk9H?=
 =?utf-8?B?UlVSOWtBbis4K0JFQWd3RzQrRnA4QURodE5FZSsxTjB5NzFpZXJVemJPcmQr?=
 =?utf-8?B?dHkxYkVsdzJTN08zSVNYYjdOQXQ5eHFaNWN4Uk4yUWZ6cWlQalk3NlpPOEVH?=
 =?utf-8?B?WG15SmxOZXdKc2xheTNhTW0vL2FTYzlBTXpJaVFwM3g1MW1kOE9TWXU5Tlhu?=
 =?utf-8?B?UWV2VDlhUTRVMWltUmh0OTNTSUpyZ3F6OFhGQ0JWRzdaWlpicVhwSEhJSXlH?=
 =?utf-8?B?RVVHcHZSV2gyemYvbTFkalFBTjdNQkJyVVBGY1dxWG1idGF6RWIzVFphcitp?=
 =?utf-8?B?QjRWdk5SOHVLSE8zQmVSaEowSGhBaEdvZVN1OHVnOTJSY3VZbVBpRTAxcEZa?=
 =?utf-8?B?T0RLaFFpSFdYMWE4VEJXQkd5TXMyMnl6b3lZeWRZM1dRb0wxV0puVGRlMW4r?=
 =?utf-8?B?WHd2SmZtMStjNTZHTWhVaUpHRG8xOFAvN0xCSmljeDA5SHpHeWJ5R01memU5?=
 =?utf-8?B?VDljVmNmb0RpMzNhdFdUWVJvSFJneEY4ZDlNRm5CQ2NqWXdlMHVsaUcwbHll?=
 =?utf-8?B?SlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7046DD5AABDC0C4DA53694691912B832@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d21dba4-1b40-4db4-f806-08dad120f14f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 09:14:24.3743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tTWrH2iTcKjzgnO69Z+PGZyh8g8ewQDyjQIUD/nst4zmldU6vkWEvla7X2OIFIMhpyKQrdannJyNyGespEAICw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6845
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE1OjM5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiArc3RhdGljIGludCB0ZG1yX3NldF91cF9tZW1vcnlfaG9sZV9yc3ZkX2FyZWFzKHN0cnVjdCB0
ZG1yX2luZm8gKnRkbXIsDQo+ID4gKwkJCQkJICAgICAgaW50ICpyc3ZkX2lkeCkNCj4gPiArew0K
PiANCj4gVGhpcyBuZWVkcyBhIGNvbW1lbnQuDQo+IA0KPiBUaGlzIGlzIGFub3RoZXIgY2FzZSB3
aGVyZSBpdCdzIGNvbmZ1c2luZyB0byBiZSBwYXNzaW5nIGFyb3VuZCAnc3RydWN0DQo+IHRkbXJf
aW5mbyAqJy4gIElzIHRoaXMgKkEqIFRETVIgb3IgYW4gYXJyYXk/DQoNCkl0IGlzIGZvciBvbmUg
VERNUiBidXQgbm90IGFuIGFycmF5LiAgQWxsIGZ1bmN0aW9ucyBpbiBmb3JtIG9mIHRkbXJfeHh4
KCkgYXJlDQpvcGVyYXRpb25zIGZvciBvbmUgVERNUi4NCg0KQnV0IEkgYWdyZWUgaXQncyBub3Qg
Y2xlYXIuDQoNCj4gDQo+IC8qDQo+IMKgKiBHbyB0aHJvdWdoIHRkeF9tZW1saXN0IHRvIGZpbmQg
aG9sZXMgYmV0d2VlbiBtZW1vcnkgYXJlYXMuICBJZiBhbnkgb2YNCj4gwqAqIHRob3NlIGhvbGVz
IGZhbGwgd2l0aGluIEB0ZG1yLCBzZXQgdXAgYSBURE1SIHJlc2VydmVkIGFyZWEgdG8gY292ZXIN
Cj4gwqAqIHRoZSBob2xlLg0KPiDCoCovDQo+IHN0YXRpYyBpbnQgdGRtcl9wb3B1bGF0ZV9yc3Zk
X2hvbGVzKHN0cnVjdCBsaXN0X2hlYWQgKnRkeF9tZW1saXN0LA0KPiAJCQkJICAgIHN0cnVjdCB0
ZG1yX2luZm8gKnRkbXIsDQo+IAkJCQkgICAgaW50ICpyc3ZkX2lkeCkNCg0KVGhhbmtzIQ0KDQpT
aG91bGQgSSBhbHNvIGNoYW5nZSBiZWxvdyBmdW5jdGlvbiAndGRtcl9zZXRfdXBfcGFtdF9yc3Zk
X2FyZWFzKCknIHRvLCBpLmUuDQp0ZG1yX3BvcHVsYXRlX3JzdmRfcGFtdHMoKT8NCg0KQWN0dWFs
bHksIHRoZXJlIGFyZSB0d28gbW9yZSBmdW5jdGlvbnMgaW4gdGhpcyBwYXRjaDogdGRtcl9zZXRf
dXBfcnN2ZF9hcmVhcygpDQphbmQgdGRtcnNfc2V0X3VwX3JzdmRfYXJlYXNfYWxsKCkuICBTaG91
bGQgSSBhbHNvIGNoYW5nZSB0aGVtIHRvDQp0ZG1yX3BvcHVsYXRlX3JzdmRfYXJlYXMoKSBhbmQg
dGRtcnNfcG9wdWxhdGVfcnN2ZF9hcmVhc19hbGwoKT8gDQoNCj4gDQo+ID4gKwlzdHJ1Y3QgdGR4
X21lbWJsb2NrICp0bWI7DQo+ID4gKwl1NjQgcHJldl9lbmQ7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+
ICsNCj4gPiArCS8qIE1hcmsgaG9sZXMgYmV0d2VlbiBtZW1vcnkgcmVnaW9ucyBhcyByZXNlcnZl
ZCAqLw0KPiA+ICsJcHJldl9lbmQgPSB0ZG1yX3N0YXJ0KHRkbXIpOw0KPiANCj4gSSdtIGhhdmlu
ZyBhIGhhcmQgdGltZSBmb2xsb3dpbmcgdGhpcywgZXNwZWNpYWxseSB0aGUgbWl4aW5nIG9mDQo+
IHNlbWFudGljcyBiZXR3ZWVuICdwcmV2X2VuZCcgYm90aCBwb2ludGluZyB0byB0ZG1yIGFuZCB0
byB0bWIgYWRkcmVzc2VzLg0KPiANCj4gSGVyZSwgJ3ByZXZfZW5kJyBsb2dpY2FsbHkgcmVwcmVz
ZW50cyB0aGUgbGFzdCBhZGRyZXNzIHdoaWNoIHdlIGtub3cgaGFzDQo+IGJlZW4gaGFuZGxlZC4g
IEFsbCBvZiB0aGUgaG9sZXMgaW4gdGhlIGFkZHJlc3NlcyBiZWxvdyBpdCBoYXZlIGJlZW4NCj4g
ZGVhbHQgd2l0aC4gIEl0IGlzIHNhZmUgdG8gc2V0IGhlcmUgdG8gdGRtcl9zdGFydCgpIGJlY2F1
c2UgdGhpcw0KPiBmdW5jdGlvbiBjYWxsIGlzIHVuaXF1ZWx5IHRhc2tlZCB3aXRoIHNldHRpbmcg
dXAgcmVzZXJ2ZWQgYXJlYXMgaW4NCj4gJ3RkbXInLiAgU28sIGl0IGNhbiBzYWZlbHkgY29uc2lk
ZXIgYW55IGhvbGVzIGJlZm9yZSB0ZG1yX3N0YXJ0KHRkbXIpIGFzDQo+IGJlaW5nIGhhbmRsZWQu
DQoNClllcy4NCg0KPiANCj4gQnV0LCBkYW5nLCB0aGVyZSdzIGEgbG90IG9mIGNvbXBsZXhpdHkg
dGhlcmUuDQo+IA0KPiBGaXJzdCwgdGhlOg0KPiANCj4gCS8qIE1hcmsgaG9sZXMgYmV0d2VlbiBt
ZW1vcnkgcmVnaW9ucyBhcyByZXNlcnZlZCAqLw0KPiANCj4gY29tbWVudCBpcyBtaXNsZWFkaW5n
LiAgSXQgaGFzICpaSUxDSCogdG8gZG8gd2l0aCB0aGUgInByZXZfZW5kID0NCj4gdGRtcl9zdGFy
dCh0ZG1yKTsiIGFzc2lnbm1lbnQuDQo+IA0KPiBUaGlzIGF0IGxlYXN0IG5lZWRzOg0KPiANCj4g
wqDCoMKgLyogU3RhcnQgbG9va2luZyBmb3IgcmVzZXJ2ZWQgYmxvY2tzIGF0IHRoZSBiZWdpbm5p
bmcgb2YgdGhlIFRETVI6ICovDQo+IMKgwqDCoHByZXZfZW5kID0gdGRtcl9zdGFydCh0ZG1yKTsN
Cg0KUmlnaHQuICAgU29ycnkgZm9yIHRoZSBiYWQgY29tbWVudC4NCg0KPiANCj4gYnV0IEkgYWxz
byBnZXQgdGhlIGZlZWxpbmcgdGhhdCAncHJldl9lbmQnIGlzIGEgY3J1bW15IHZhcmlhYmxlIG5h
bWUuICBJDQo+IGRvbid0IGhhdmUgYW55IGJldHRlciBzdWdnZXN0aW9ucyBhdCB0aGUgbW9tZW50
Lg0KPiANCj4gPiArCWxpc3RfZm9yX2VhY2hfZW50cnkodG1iLCAmdGR4X21lbWxpc3QsIGxpc3Qp
IHsNCj4gPiArCQl1NjQgc3RhcnQsIGVuZDsNCj4gPiArDQo+ID4gKwkJc3RhcnQgPSB0bWItPnN0
YXJ0X3BmbiA8PCBQQUdFX1NISUZUOw0KPiA+ICsJCWVuZCA9IHRtYi0+ZW5kX3BmbiA8PCBQQUdF
X1NISUZUOw0KPiA+ICsNCj4gDQo+IE1vcmUgYWxpZ25tZW50IG9wcG9ydHVuaXRpZXM6DQo+IA0K
PiAJCXN0YXJ0ID0gdG1iLT5zdGFydF9wZm4gPDwgUEFHRV9TSElGVDsNCj4gCQllbmQgICA9IHRt
Yi0+ZW5kX3BmbiAgIDw8IFBBR0VfU0hJRlQ7DQoNClNob3VsZCBJIHVzZSBQRk5fUEhZUygpPyAg
VGhlbiBsb29rcyB3ZSBkb24ndCBuZWVkIHRoaXMgYWxpZ25tZW50Lg0KDQo+IA0KPiANCj4gPiAr
CQkvKiBCcmVhayBpZiB0aGlzIHJlZ2lvbiBpcyBhZnRlciB0aGUgVERNUiAqLw0KPiA+ICsJCWlm
IChzdGFydCA+PSB0ZG1yX2VuZCh0ZG1yKSkNCj4gPiArCQkJYnJlYWs7DQo+ID4gKw0KPiA+ICsJ
CS8qIEV4Y2x1ZGUgcmVnaW9ucyBiZWZvcmUgdGhpcyBURE1SICovDQo+ID4gKwkJaWYgKGVuZCA8
IHRkbXJfc3RhcnQodGRtcikpDQo+ID4gKwkJCWNvbnRpbnVlOw0KPiA+ICsNCj4gPiArCQkvKg0K
PiA+ICsJCSAqIFNraXAgaWYgbm8gaG9sZSBleGlzdHMgYmVmb3JlIHRoaXMgcmVnaW9uLiAiPD0i
IGlzDQo+ID4gKwkJICogdXNlZCBiZWNhdXNlIG9uZSBtZW1vcnkgcmVnaW9uIG1pZ2h0IHNwYW4g
dHdvIFRETVJzDQo+ID4gKwkJICogKHdoZW4gdGhlIHByZXZpb3VzIFRETVIgY292ZXJzIHBhcnQg
b2YgdGhpcyByZWdpb24pLg0KPiA+ICsJCSAqIEluIHRoaXMgY2FzZSB0aGUgc3RhcnQgYWRkcmVz
cyBvZiB0aGlzIHJlZ2lvbiBpcw0KPiA+ICsJCSAqIHNtYWxsZXIgdGhhbiB0aGUgc3RhcnQgYWRk
cmVzcyBvZiB0aGUgc2Vjb25kIFRETVIuDQo+ID4gKwkJICoNCj4gPiArCQkgKiBVcGRhdGUgdGhl
IHByZXZfZW5kIHRvIHRoZSBlbmQgb2YgdGhpcyByZWdpb24gd2hlcmUNCj4gPiArCQkgKiB0aGUg
cG9zc2libGUgbWVtb3J5IGhvbGUgc3RhcnRzLg0KPiA+ICsJCSAqLw0KPiANCj4gQ2FuJ3QgdGhp
cyBqdXN0IGJlOg0KPiANCj4gCQkvKg0KPiAJCSAqIFNraXAgb3ZlciBtZW1vcnkgYXJlYXMgdGhh
dA0KPiAJCSAqIGhhdmUgYWxyZWFkeSBiZWVuIGRlYWx0IHdpdGguDQo+IAkJICovDQoNCkkgdGhp
bmsgc28uICBUaGlzIGFjdHVhbGx5IGFsc28gY292ZXJzIHRoZSAidHdvIGNvbnRpZ3VvdXMgbWVt
b3J5IHJlZ2lvbnMiIGNhc2UsDQp3aGljaCBpc24ndCBtZW50aW9uZWQgaW4gdGhlIG9yaWdpbmFs
IGNvbW1lbnQuDQoNCj4gDQo+ID4gKwkJaWYgKHN0YXJ0IDw9IHByZXZfZW5kKSB7DQo+ID4gKwkJ
CXByZXZfZW5kID0gZW5kOw0KPiA+ICsJCQljb250aW51ZTsNCj4gPiArCQl9DQo+ID4gKw0KPiA+
ICsJCS8qIEFkZCB0aGUgaG9sZSBiZWZvcmUgdGhpcyByZWdpb24gKi8NCj4gPiArCQlyZXQgPSB0
ZG1yX2FkZF9yc3ZkX2FyZWEodGRtciwgcnN2ZF9pZHgsIHByZXZfZW5kLA0KPiA+ICsJCQkJc3Rh
cnQgLSBwcmV2X2VuZCk7DQo+ID4gKwkJaWYgKHJldCkNCj4gPiArCQkJcmV0dXJuIHJldDsNCj4g
PiArDQo+ID4gKwkJcHJldl9lbmQgPSBlbmQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJLyogQWRk
IHRoZSBob2xlIGFmdGVyIHRoZSBsYXN0IHJlZ2lvbiBpZiBpdCBleGlzdHMuICovDQo+ID4gKwlp
ZiAocHJldl9lbmQgPCB0ZG1yX2VuZCh0ZG1yKSkgew0KPiA+ICsJCXJldCA9IHRkbXJfYWRkX3Jz
dmRfYXJlYSh0ZG1yLCByc3ZkX2lkeCwgcHJldl9lbmQsDQo+ID4gKwkJCQl0ZG1yX2VuZCh0ZG1y
KSAtIHByZXZfZW5kKTsNCj4gPiArCQlpZiAocmV0KQ0KPiA+ICsJCQlyZXR1cm4gcmV0Ow0KPiA+
ICsJfQ0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMg
aW50IHRkbXJfc2V0X3VwX3BhbXRfcnN2ZF9hcmVhcyhzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLCBp
bnQNCj4gPiAqcnN2ZF9pZHgsDQo+ID4gKwkJCQkgICAgICAgc3RydWN0IHRkbXJfaW5mbyAqdGRt
cl9hcnJheSwNCj4gPiArCQkJCSAgICAgICBpbnQgdGRtcl9udW0pDQo+ID4gK3sNCj4gPiArCWlu
dCBpLCByZXQ7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIElmIGFueSBQQU1UIG92ZXJsYXBz
IHdpdGggdGhpcyBURE1SLCB0aGUgb3ZlcmxhcHBpbmcgcGFydA0KPiA+ICsJICogbXVzdCBhbHNv
IGJlIHB1dCB0byB0aGUgcmVzZXJ2ZWQgYXJlYSB0b28uICBXYWxrIG92ZXIgYWxsDQo+ID4gKwkg
KiBURE1ScyB0byBmaW5kIG91dCB0aG9zZSBvdmVybGFwcGluZyBQQU1UcyBhbmQgcHV0IHRoZW0g
dG8NCj4gPiArCSAqIHJlc2VydmVkIGFyZWFzLg0KPiA+ICsJICovDQo+ID4gKwlmb3IgKGkgPSAw
OyBpIDwgdGRtcl9udW07IGkrKykgew0KPiA+ICsJCXN0cnVjdCB0ZG1yX2luZm8gKnRtcCA9IHRk
bXJfYXJyYXlfZW50cnkodGRtcl9hcnJheSwgaSk7DQo+ID4gKwkJdW5zaWduZWQgbG9uZyBwYW10
X3N0YXJ0X3BmbiwgcGFtdF9ucGFnZXM7DQo+ID4gKwkJdTY0IHBhbXRfc3RhcnQsIHBhbXRfZW5k
Ow0KPiA+ICsNCj4gPiArCQl0ZG1yX2dldF9wYW10KHRtcCwgJnBhbXRfc3RhcnRfcGZuLCAmcGFt
dF9ucGFnZXMpOw0KPiA+ICsJCS8qIEVhY2ggVERNUiBtdXN0IGFscmVhZHkgaGF2ZSBQQU1UIGFs
bG9jYXRlZCAqLw0KPiA+ICsJCVdBUk5fT05fT05DRSghcGFtdF9ucGFnZXMgfHwgIXBhbXRfc3Rh
cnRfcGZuKTsNCj4gPiArDQo+ID4gKwkJcGFtdF9zdGFydCA9IHBhbXRfc3RhcnRfcGZuIDw8IFBB
R0VfU0hJRlQ7DQo+ID4gKwkJcGFtdF9lbmQgPSBwYW10X3N0YXJ0ICsgKHBhbXRfbnBhZ2VzIDw8
IFBBR0VfU0hJRlQpOw0KPiA+ICsNCj4gPiArCQkvKiBTa2lwIFBBTVRzIG91dHNpZGUgb2YgdGhl
IGdpdmVuIFRETVIgKi8NCj4gPiArCQlpZiAoKHBhbXRfZW5kIDw9IHRkbXJfc3RhcnQodGRtcikp
IHx8DQo+ID4gKwkJCQkocGFtdF9zdGFydCA+PSB0ZG1yX2VuZCh0ZG1yKSkpDQo+ID4gKwkJCWNv
bnRpbnVlOw0KPiA+ICsNCj4gPiArCQkvKiBPbmx5IG1hcmsgdGhlIHBhcnQgd2l0aGluIHRoZSBU
RE1SIGFzIHJlc2VydmVkICovDQo+ID4gKwkJaWYgKHBhbXRfc3RhcnQgPCB0ZG1yX3N0YXJ0KHRk
bXIpKQ0KPiA+ICsJCQlwYW10X3N0YXJ0ID0gdGRtcl9zdGFydCh0ZG1yKTsNCj4gPiArCQlpZiAo
cGFtdF9lbmQgPiB0ZG1yX2VuZCh0ZG1yKSkNCj4gPiArCQkJcGFtdF9lbmQgPSB0ZG1yX2VuZCh0
ZG1yKTsNCj4gPiArDQo+ID4gKwkJcmV0ID0gdGRtcl9hZGRfcnN2ZF9hcmVhKHRkbXIsIHJzdmRf
aWR4LCBwYW10X3N0YXJ0LA0KPiA+ICsJCQkJcGFtdF9lbmQgLSBwYW10X3N0YXJ0KTsNCj4gPiAr
CQlpZiAocmV0KQ0KPiA+ICsJCQlyZXR1cm4gcmV0Ow0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXJl
dHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsvKiBDb21wYXJlIGZ1bmN0aW9uIGNhbGxlZCBi
eSBzb3J0KCkgZm9yIFRETVIgcmVzZXJ2ZWQgYXJlYXMgKi8NCj4gPiArc3RhdGljIGludCByc3Zk
X2FyZWFfY21wX2Z1bmMoY29uc3Qgdm9pZCAqYSwgY29uc3Qgdm9pZCAqYikNCj4gPiArew0KPiA+
ICsJc3RydWN0IHRkbXJfcmVzZXJ2ZWRfYXJlYSAqcjEgPSAoc3RydWN0IHRkbXJfcmVzZXJ2ZWRf
YXJlYSAqKWE7DQo+ID4gKwlzdHJ1Y3QgdGRtcl9yZXNlcnZlZF9hcmVhICpyMiA9IChzdHJ1Y3Qg
dGRtcl9yZXNlcnZlZF9hcmVhICopYjsNCj4gPiArDQo+ID4gKwlpZiAocjEtPm9mZnNldCArIHIx
LT5zaXplIDw9IHIyLT5vZmZzZXQpDQo+ID4gKwkJcmV0dXJuIC0xOw0KPiA+ICsJaWYgKHIxLT5v
ZmZzZXQgPj0gcjItPm9mZnNldCArIHIyLT5zaXplKQ0KPiA+ICsJCXJldHVybiAxOw0KPiA+ICsN
Cj4gPiArCS8qIFJlc2VydmVkIGFyZWFzIGNhbm5vdCBvdmVybGFwLiAgVGhlIGNhbGxlciBzaG91
bGQgZ3VhcmFudGVlLiAqLw0KPiA+ICsJV0FSTl9PTl9PTkNFKDEpOw0KPiA+ICsJcmV0dXJuIC0x
Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICsvKiBTZXQgdXAgcmVzZXJ2ZWQgYXJlYXMgZm9yIGEgVERN
UiwgaW5jbHVkaW5nIG1lbW9yeSBob2xlcyBhbmQgUEFNVHMgKi8NCj4gPiArc3RhdGljIGludCB0
ZG1yX3NldF91cF9yc3ZkX2FyZWFzKHN0cnVjdCB0ZG1yX2luZm8gKnRkbXIsDQo+ID4gKwkJCQkg
IHN0cnVjdCB0ZG1yX2luZm8gKnRkbXJfYXJyYXksDQo+ID4gKwkJCQkgIGludCB0ZG1yX251bSkN
Cj4gPiArew0KPiA+ICsJaW50IHJldCwgcnN2ZF9pZHggPSAwOw0KPiA+ICsNCj4gPiArCS8qIFB1
dCBhbGwgbWVtb3J5IGhvbGVzIHdpdGhpbiB0aGUgVERNUiBpbnRvIHJlc2VydmVkIGFyZWFzICov
DQo+ID4gKwlyZXQgPSB0ZG1yX3NldF91cF9tZW1vcnlfaG9sZV9yc3ZkX2FyZWFzKHRkbXIsICZy
c3ZkX2lkeCk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4gKw0KPiA+
ICsJLyogUHV0IGFsbCAob3ZlcmxhcHBpbmcpIFBBTVRzIHdpdGhpbiB0aGUgVERNUiBpbnRvIHJl
c2VydmVkIGFyZWFzDQo+ID4gKi8NCj4gPiArCXJldCA9IHRkbXJfc2V0X3VwX3BhbXRfcnN2ZF9h
cmVhcyh0ZG1yLCAmcnN2ZF9pZHgsIHRkbXJfYXJyYXksDQo+ID4gdGRtcl9udW0pOw0KPiA+ICsJ
aWYgKHJldCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiArCS8qIFREWCByZXF1aXJl
cyByZXNlcnZlZCBhcmVhcyBsaXN0ZWQgaW4gYWRkcmVzcyBhc2NlbmRpbmcgb3JkZXIgKi8NCj4g
PiArCXNvcnQodGRtci0+cmVzZXJ2ZWRfYXJlYXMsIHJzdmRfaWR4LCBzaXplb2Yoc3RydWN0DQo+
ID4gdGRtcl9yZXNlcnZlZF9hcmVhKSwNCj4gPiArCQkJcnN2ZF9hcmVhX2NtcF9mdW5jLCBOVUxM
KTsNCj4gDQo+IFVnaCwgYW5kIEkgZ3Vlc3Mgd2UgZG9uJ3Qga25vdyB3aGVyZSB0aGUgUEFNVHMg
d2lsbCBiZSBvcmRlcmVkIHdpdGgNCj4gcmVzcGVjdCB0byBob2xlcywgc28gc29ydGluZyBpcyB0
aGUgZWFzaWVzdCB3YXkgdG8gZG8gdGhpcy4NCj4gDQo+IDxzbmlwPg0KDQpSaWdodC4NCg0K
