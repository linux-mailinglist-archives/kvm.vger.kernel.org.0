Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCD87558F3
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 03:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjGQA5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 20:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjGQA5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 20:57:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BDC1AB;
        Sun, 16 Jul 2023 17:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689555467; x=1721091467;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E1urivr/X0xvGq0aHyPa22rWq/B4Yl9Kov4kPOn/CNI=;
  b=iKbbNXxW4TZghWk57zAx525BwI1TF4iPo+RfnsXnTa0fwVuOci61Qy8F
   HERgelbgXD0nSDXeuR/tjykDgkZAH3IMJKb7biYAwv6bXU1kVGcoqFdIn
   mTZMia0QashYOijG4a1WULmC8VulBbo8j64QaUTtz3h6v0M9c9hBq3dfH
   aTLtKqJsYq6Rdafdbl9Gk5HtN8H9mmLGDuxxPH1LeVSPNMyLYPjDd4XOB
   1X8SI++MaRZp+F2y4iTz2/z2L7pVt0XDjAeOPMAplJ11KfX8GLkR9SsLn
   i9csU38jBY1/Ru3uk+/m2upCrKVj28+yEuTNtRh87jEc8X4rI1umbgUlZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="396638564"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="396638564"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2023 17:57:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="1053713053"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="1053713053"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jul 2023 17:57:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 16 Jul 2023 17:57:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 16 Jul 2023 17:57:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 16 Jul 2023 17:57:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 16 Jul 2023 17:57:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erHqGke6tNvwzbbZbK+a+KAvi+e533qUn1YSFw7DCYir+qbxTAubGtZdOWJjHnhc81iu3YFNda/MVe1iJ90Wiy6OAkKIYSKFVODd56FvyuTh8VsPz9R2DrZ4io06mvobmz/PweEHflZOqY56fWjd5kpAkfGuyL80zF63tR2IOTuhff41gWtjAvuk6SfE0N+MVrCpGt8eMqFBGWo+rdIaeU5fzaA2DzilQDUyHupoE5zv5STXDz7PUBinb+vf3I4acZHl44Oy1QYO4vU3CCZeQJDzGhdOQEjF2rsH30tv3tZy6pEwDstBO+eKgNUPM5VlfV4JOvXe1bx7mz3jp68NXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1urivr/X0xvGq0aHyPa22rWq/B4Yl9Kov4kPOn/CNI=;
 b=hRkaVqXnUIVD+Ps5OoIzfuvwfUa+6z6W7NaFAVJqTRO116xVBLdTEKGI3IPBd/IPaUIBeqn7Q0xeiG4RCfk6256hzOnu5fepuIPUII8lNYirgtE78i4TaJhNt1EOCuBduSTRviYayQJ640LEPFNN7b5ZZhtWmDKuDx6u24yNLg9Exw3GaOwo7EwnF/galCZNLkPpkXtJS7YT4K7LjuRknVd1EuwkemXipqxYNIlrQSqyILX+AHBjeaq1VqolyYPQdCTtfngD9VOqmEZVHemsyR612cjZZQjX2wNvs+YZogjragc5MV+iXcSnW60Z3scIAu/uH1KHC7EIpKz1qG6ujQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH7PR11MB5795.namprd11.prod.outlook.com (2603:10b6:510:132::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 00:57:40 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::4345:8c8a:ed91:57c5]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::4345:8c8a:ed91:57c5%6]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 00:57:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 04/10] x86/tdx: Make macros of TDCALLs consistent with the
 spec
Thread-Topic: [PATCH 04/10] x86/tdx: Make macros of TDCALLs consistent with
 the spec
Thread-Index: AQHZtJ1tpc3V9+xEBEKvNigjqNhW2q+5NDUAgAP164A=
Date:   Mon, 17 Jul 2023 00:57:39 +0000
Message-ID: <61e70e0cb895663f5d28b260f1aa779fae0b1182.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ba4b4ff1fe77ca76cca370b2fd4aa57a2d23c86d.1689151537.git.kai.huang@intel.com>
         <574a6b44-38bf-85ce-1dd0-2414fa389c48@suse.com>
In-Reply-To: <574a6b44-38bf-85ce-1dd0-2414fa389c48@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|PH7PR11MB5795:EE_
x-ms-office365-filtering-correlation-id: 9934ba33-0512-45d6-da15-08db8660d1a7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sbNENXBPC1hjq7KGZqsB2AVZgpNy263R+LvNwVcT47KyiwJhgthUWWw8YHESWhA4LE5u0zkEXSqTWHxKrXUTbIR3KixRJc/yD3IuZiXjJLwfl/ns8hFZM+R9J7gU4BnG4aOxasu9zjkY2JNxGvzI7qbcd4sbKZbekbI36PttgW06JKyXQyxu3GzGAE1jdOQYa7HZg3bXdq8+tl2U+pQxJSg9ZNagyc/Z8+0N04Bjkmtpr43yvqsQLAuJvNduMtGZm7B5h7vOIk5dIaHdZU3gpoz8N/Id2Vl362qz7kGYsuIBIgosA5vP+aV3i6hwnUdt3oXACG9NKA0FEXSD4DVL5wRaZ+b+2mxGMX/k/xS+6ThnTuZuyA7hzSt3FQLNAxxu0Kv21GgurOk6nRvQ1ed/teoYJzt0RHcnGCJkxS/bwFKSNdpHWKIwB0RAKH8FVYIF1kSvjYp6amlDzhWu99rndM8QVGzCIiqi1u543AkdzuwhQgLSIhbak+Oj0SbhojfJDMHA2kF0KrH28dpiX5cXaLBwe6xApsNGjKeek/TBd7WSMr6t2cNr9ms6tc6NZF1s8CdsuldeVi7IBnHdsmqf9fOjpsVHEKkriFoJvgj/gQSfPM3S85JUEtNj8calbGN0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199021)(71200400001)(82960400001)(6506007)(83380400001)(38100700002)(186003)(26005)(110136005)(478600001)(38070700005)(6512007)(6486002)(54906003)(7416002)(8676002)(41300700001)(66476007)(66446008)(8936002)(2906002)(66556008)(66946007)(4326008)(316002)(5660300002)(36756003)(64756008)(2616005)(86362001)(91956017)(76116006)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW1yQkJwNSt4NzNVRk9oaHVtWXlnd01zQnppeHpCUmxhbmF5UDBFWVJNbHVF?=
 =?utf-8?B?NTUwYjVFWkdiay9Ha2dYQkMyYnRSU2JHMW51aHJ2Qi9RWExWMTF0YXE2UVlQ?=
 =?utf-8?B?Y0hWb3UvTkVoUmN2NDdKTnFKZ2FvU0E5dmRiRmpQZzVScEp4Z1lFVkZGZHIv?=
 =?utf-8?B?OUtaNGpzMCtRR2lvTk5Rb3cvKzBCOUlOWkE1bUJTRGFtcXZDY3Z1V3k2UGU5?=
 =?utf-8?B?K1dnYUNyRmJjL3VHeGcrSVZOY1llZHBvbEN4M0kxL2lnSnVpS2RMK2VVaTN0?=
 =?utf-8?B?SHVuM0NzVUdOY1Zlbm1WSk1kQTlFZHhIUmFCMXFYc29jS3lVK1dqN29UcTkz?=
 =?utf-8?B?MGQzMXc1ZE56dDJkenlieS9RT2ZYd1lYeVhDS21aTy95alhMc2pnTktqbUhs?=
 =?utf-8?B?U01VS25wellyK0lXSE1oZ1Y4TXFFWXJ1NFpseHFBT2h0RmllUEUzbG5ZdDNB?=
 =?utf-8?B?SW54VFhHNXEwaUdERi9LK29EQ0NjdzZkNkdaWDlBK0hETnRJNFdCZkVndHF4?=
 =?utf-8?B?cHhWemxZNlhXL3dxbFJkTGVURUxxdWhhZVE4bXV4bzNvV2RzL1U1YTJ2NXhK?=
 =?utf-8?B?STZORWRwK1Y4Z3N3VWNrWW05UUFqT3FGLzJUM2dCK0xIeU56aURvVVNmbmNi?=
 =?utf-8?B?dyt1RmtaUWVRb2UvZkZQK1BhTmJIbnBENVdRSndFVGJmZ01BcVpLMStmdmU5?=
 =?utf-8?B?UjE0bndwU1F0TWdjVHU0Nk42Vm5KNkJEYU9hV3dCTjAwZ1ZtekV3czdTU0ds?=
 =?utf-8?B?WDZQOXR1OXJ6SGRDanpOUCtZV3grRDJMa1RkL3kzNlEyUkVycW9McmV6WHFG?=
 =?utf-8?B?cFd3WmY3VVAwRlEzZzF0Y0FhTmxKMFU0Qi9hcWU5Z2tCYU1seVphOGw4Vmhr?=
 =?utf-8?B?eExlV3YvYnh5c2sxTGJCMVlEeG1ZbzdBYVNyV2NGRmlQc0x0dWMyY1RnRmJs?=
 =?utf-8?B?QmhQdFBxMDhjNlZsUEdNZUREc1lDSVlkalhsUGp5dDVUMVBubENSSDNIVHpj?=
 =?utf-8?B?WGF6bVc2MFQ1aTkweU1aZE00VTdONE1iVGVRc2NjME1oSFhvR2VYTlp4Ty9a?=
 =?utf-8?B?RVBGbmZ4NjNzOWU3T2ZYMGNQZ2xYZDdDL3VHcWZQUEFsbS9uY0p2TTFXL2R1?=
 =?utf-8?B?N1V1b2VGMDRrdjNsRkJNV0NaSnNRVXNMTVpxb2w2MVh5SjJORGQ2RWpQMW8v?=
 =?utf-8?B?aDdma3JhTmVjcEJWZDNrSmhnRnBjb2E0enJzNEVEcExpckYyTjZFV1ZOaHBW?=
 =?utf-8?B?NG1qcGo2R2pJc2ZOOU1XeVdDT3cwL2szWGVjdThZU3NuUTdxclN3L2Q2b2xk?=
 =?utf-8?B?K21YeS8xeHoyVGJWYnNBaFBBY0RTeUdpKzZ0bHQvZ0k5c1MxQm1EUW03QXF6?=
 =?utf-8?B?Q3JnZmh3dVhOeWtySmlYalVjVThxUi92bDdHclFwdU0vaFRKd3ZXSzdjYWxM?=
 =?utf-8?B?NHZJbHhwL2xVZys0UVo5TW9pM2Y4bDJrMU1hZENhd2pEZ3JIbjM1WkZ6TXhW?=
 =?utf-8?B?TmxWTmNWTUlPTkJjYkgyN3pEc2ZuakRyVEI2QmYxajN4MHgxMlBubkhTR0Rj?=
 =?utf-8?B?dGNZc3EyYnZFMjUzY2t4Q1BLbktZZ0F0M2syOVVhTjV4VmVCUlo5TGJsWmVu?=
 =?utf-8?B?OEVEZGtpMHdhL3RaY0tUSWsrUDNTSHBtOGs5aTh4OXU3M2poNjJmL05xZ1By?=
 =?utf-8?B?d0VPdFVXRXk0d21JN3VQYmVnOUZkTnhuUHlMTm55SzFselJoZlg0WndUOWZQ?=
 =?utf-8?B?N1YzcFB4UEZiN0tEamZmcVdKZmdIQVVrcXpBTGZQM2h6cEJUakdlS1FVZ0ha?=
 =?utf-8?B?WHA3YmxaeEdQUGxJN1Rkc0NvNWY4YVRIR2NkalRZV3FhNU5UdDRrelE3WDZI?=
 =?utf-8?B?a3RRanFUamx0WVlwQlI5ckxiVFVvSGFncmNXVFYvTmZ5VkxoL0Q4eE56ZW1q?=
 =?utf-8?B?UkxJR1VxRjByZHRBR3FLN3NwSTFyZ2lmcGhMTXVOK0lnVzlzTTgrNDVtd0h1?=
 =?utf-8?B?YW5haW9QT2FManJydmQ1dXRDd01PakRRZE1PeExwQ3lNa1kvZmJrbXhtK1FB?=
 =?utf-8?B?Tmd1OGpCYWF2VERPOVFSYXZxV0pkZmFWcW11eXpsQzBibjdMWnYwMzRxOEY4?=
 =?utf-8?Q?PugMyJGJ8Mu2+RKJb1fuaXVVS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA1CCA93D584334A80A214D3E99D0C37@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9934ba33-0512-45d6-da15-08db8660d1a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 00:57:39.5390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /cfTsubow+ubHgrdEnAeLNnxXuDgZkGQZHKAZ99EOe8xIgeonaMRDsgiEBXhx/ZogyCtgSAk3pLhwL2U+3gXcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5795
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA3LTE0IGF0IDE1OjI4ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxMi4wNy4yMyDQsy4gMTE6NTUg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
VGhlIFREWCBzcGVjIG5hbWVzIGFsbCBURENBTExzIHdpdGggcHJlZml4ICJUREciLiAgQ3VycmVu
dGx5LCB0aGUga2VybmVsDQo+ID4gZG9lc24ndCBmb2xsb3cgc3VjaCBjb252ZW50aW9uIGZvciB0
aGUgbWFjcm9zIG9mIHRob3NlIFREQ0FMTHMgYnV0IHVzZXMNCj4gPiBwcmVmaXggIlREWF8iIGZv
ciBhbGwgb2YgdGhlbS4gIEFsdGhvdWdoIGl0J3MgYXJndWFibGUgd2hldGhlciB0aGUgVERYDQo+
ID4gc3BlYyBuYW1lcyB0aG9zZSBURENBTExzIHByb3Blcmx5LCBpdCdzIGJldHRlciBmb3IgdGhl
IGtlcm5lbCB0byBmb2xsb3cNCj4gPiB0aGUgc3BlYyB3aGVuIG5hbWluZyB0aG9zZSBtYWNyb3Mu
DQo+ID4gDQo+ID4gQ2hhbmdlIGFsbCBtYWNyb3Mgb2YgVERDQUxMcyB0byBtYWtlIHRoZW0gY29u
c2lzdGVudCB3aXRoIHRoZSBzcGVjLiAgQXMNCj4gPiBhIGJvbnVzLCB0aGV5IGdldCBkaXN0aW5n
dWlzaGVkIGVhc2lseSBmcm9tIHRoZSBob3N0LXNpZGUgU0VBTUNBTExzLA0KPiA+IHdoaWNoIGFs
bCBoYXZlIHByZWZpeCAiVERIIi4NCj4gPiANCj4gPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRl
bmRlZC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQo+ID4gLS0tDQo+ID4gICBhcmNoL3g4Ni9jb2NvL3RkeC90ZHguYyB8IDIyICsrKysr
KysrKysrLS0tLS0tLS0tLS0NCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCsp
LCAxMSBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvY29jby90
ZHgvdGR4LmMgYi9hcmNoL3g4Ni9jb2NvL3RkeC90ZHguYw0KPiA+IGluZGV4IDViODA1NmY2Yzgz
Zi4uZGUwMjFkZjkyMDA5IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2NvY28vdGR4L3RkeC5j
DQo+ID4gKysrIGIvYXJjaC94ODYvY29jby90ZHgvdGR4LmMNCj4gPiBAQCAtMTUsMTEgKzE1LDEx
IEBADQo+ID4gICAjaW5jbHVkZSA8YXNtL3BndGFibGUuaD4NCj4gPiAgIA0KPiA+ICAgLyogVERY
IG1vZHVsZSBDYWxsIExlYWYgSURzICovDQo+ID4gLSNkZWZpbmUgVERYX0dFVF9JTkZPCQkJMQ0K
PiA+IC0jZGVmaW5lIFREWF9HRVRfVkVJTkZPCQkJMw0KPiA+IC0jZGVmaW5lIFREWF9HRVRfUkVQ
T1JUCQkJNA0KPiA+IC0jZGVmaW5lIFREWF9BQ0NFUFRfUEFHRQkJCTYNCj4gPiAtI2RlZmluZSBU
RFhfV1IJCQkJOA0KPiA+ICsjZGVmaW5lIFRER19WUF9JTkZPCQkJMQ0KPiA+ICsjZGVmaW5lIFRE
R19WUF9WRUlORk9fR0VUCQkzDQo+ID4gKyNkZWZpbmUgVERHX01SX1JFUE9SVAkJCTQNCj4gPiAr
I2RlZmluZSBUREdfTUVNX1BBR0VfQUNDRVBUCQk2DQo+ID4gKyNkZWZpbmUgVERHX1ZNX1dSCQkJ
OA0KPiA+ICAgDQo+IFdoYXQgYnJhbmNoIGlzIHRoaXMgcGF0Y2ggc2V0IGJhc2VkIG9mZj8gQmVj
YXVzZSB0aGUgZXhpc3RpbmcgVERYX0dFVF8qIA0KPiBkZWZpbmVzIGFyZSBpbiBhcmNoL3g4Ni9p
bmNsdWRlL2FzbS9zaGFyZWQvdGR4LmggZHVlIHRvIGZmNDBiNTc2OWE1MGYgPw0KPiANCg0KSXQg
d2FzIGJhc2VkIG9uIHRpcC94ODYvdGR4LCB3aGljaCBkaWRuJ3QgaGF2ZSBhYm92ZSBwYXRjaC4g
IEknbGwgcmViYXNlIHRvIHRoZQ0KTGludXMncyB0cmVlIGZvciB0aGUgbmV4dCByb3VuZCBzaW5j
ZSBpdCBub3cgaGFzIGFsbCBURFggcGF0Y2hlcyBhbnl3YXkuDQo=
