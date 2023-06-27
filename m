Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3CD73FA47
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 12:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjF0KeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 06:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjF0KeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 06:34:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD51C9;
        Tue, 27 Jun 2023 03:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687862054; x=1719398054;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D8lGQeJHXd5lLlVYEIXFTBf7yk0REWRERwOvPoF8lf4=;
  b=dMFn/Ym16yL7od8GCoB/O5YBcGicbzKkZUR4xmBbvbLbSeo3XR1qfLUf
   WJAFZC9UEc8awLd78kpd7xCL8Z/g8Yqlv7U9FOVk7xBXqRFB5CjcYZdqv
   qFqq5v2kGeuNgS2A/gSLpnjBM0tOozI7ewEolYWmkqKCCa9gmBQiBPFXs
   GFQNVCox9ST2Hh1kGELbLisetG4sAU1yIMr1GhWudxyF3IF53zGRO38pG
   2S92v1j0L4V+i6RV7ci51QGRJ2eeeQeESO5nr6Omig4p/SKwNF+9BFy+O
   63eSfr/sprgwJxnJNBAIa28ouAOZGMj0gkk9AqpyESps5IkRqI9rcvMjh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="341125419"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="341125419"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 03:34:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="963140714"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="963140714"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jun 2023 03:34:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 03:34:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 03:34:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 03:34:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 03:34:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9bXGCpiMDTdGTAC+JSeFZljySxzGicBYCbgS1ih+negxLh26G+VWXLU9cbLDiWOfsz03C+IqACTmnZOMPkaWVP8sPOSrEo7iJ/xunjHcB/6TRrZTimWo9IXXaFNhWadU6o79JpdEiReDbrma+pjLqCOd1RpchsVftCThbCV4kUtk5FDeP1jHPngYfT0stI0RWg5KW7Y2HPZnIgr1GYz2IEaoXqZMW96O1sfOZNfIo0h9bs3399HN5aQre0qzpx8bqImWG4DihfOE5xxm/xpu7ORann/gTj70xGLfLHqtqOmAqF0Ni1htak3T1HeocHe58T0oDS66v920ePl3/X1Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8lGQeJHXd5lLlVYEIXFTBf7yk0REWRERwOvPoF8lf4=;
 b=DCvBhNyw2uxePXDaQDimLFAXaX2iiIARRQlFKGyPq7FkUp++PZGhlCF0Vxwg0+vvjoaizJgsMYNbzCpDoOEtxx4u7llmGNn97AncbyDRAPWai3Gkxatv6U1yzgq3pIG/iaZsjmftPxiA37/N2RPpKzWQzjZj1FlAXYW6IvMtknBmZ8JROa9hzzBjcvw/xLepgZWGAuZA2i8PhAbbmgnMv26oLDcnBUaATfR3Orq8ZV0rSBQnWY5y9T9I+SrpgqT2CGg47D8JcrvW/IVvJdFGiw2vxuGEV6LAQVPK+dxok2jVRNJG9oRYvGMKNutArqLQcZfOdrK5QVQoksrVWiPv+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4807.namprd11.prod.outlook.com (2603:10b6:510:3a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 10:34:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 10:34:04 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
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
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+eaRwAgAAMPoA=
Date:   Tue, 27 Jun 2023 10:34:04 +0000
Message-ID: <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
In-Reply-To: <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4807:EE_
x-ms-office365-filtering-correlation-id: df2b907b-2091-4e38-7e8e-08db76fa07a9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PEvF0ik2iXyG+barpBoaZ7vzO0i8pH9n7Uxr9lpmYc7hB+AzsVeO+IS3GV/3bnANID+XtjguF4U6pLLf50slS54YjHdwd5Lp+kjh3CKVkeTfWQSdYG5CD6JPLhFnY61Le0HJHRxoRMMJJoFQA5szNx3DigXzJOF4VNEWK/7kcFT01JjbNMVEjYkufHi3WR35giY0opZlK3qo82DuO4MHd8qdNvHjcNeMZ/FzdnUILWlTepoLBP2fqVwGYNdXGO7SNbCqeS/7XzsqcdVlu99/cmjYjfGBZP1cQ1/nm9dzWmfORnNHTlZKbw04gIARFwiECQ/s5WV9gvsPpjPX/CcL1z14xJ6B/GlfV0NA9/wfCQQ952EtjqT0dWU4HwykiWfdCbLpe5Ur1fPqx2HxOg6O9msUczLXaXxRqFqVIXsS5pJUEqI8ZkARDkuHn98X+rBKaVGu9tQlPTkxBSagzJjYbQJeG2nzEdxWxa8dgLtEX6xJgXftn+D1guETcCMTXwFFR725q/I+1hH2Uar+vmA4MHIRH3A528iKQ6Jc5ba73nCYbxlSwxpJBvTB/7Y92fFKtS+npQBFLLOzVs+sJZqp2sVMIypnttoj42PbmULhPyQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199021)(83380400001)(316002)(966005)(8936002)(6486002)(71200400001)(8676002)(54906003)(4326008)(41300700001)(36756003)(122000001)(86362001)(82960400001)(38100700002)(64756008)(2616005)(7416002)(4744005)(5660300002)(66946007)(66556008)(66476007)(6512007)(66446008)(6916009)(2906002)(478600001)(186003)(91956017)(76116006)(26005)(38070700005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGlnb3FVdGNCQk1SZU5kR0tRMnpXSFZtdmxRTUpyVGhUZ3hXb05ZN2MxY01k?=
 =?utf-8?B?OEJNN3poMWFsQWFUQms0K3MxUmYxUHNSSDQ0eFhzaHJJVFBPWFZiN2g3NUFm?=
 =?utf-8?B?d1UrUEdYZ2oweldPSVNsbmt3RGNZZVNCR2ZYaTZIb1B4dWs3VFRJVWhJckVJ?=
 =?utf-8?B?TllCd0piTWE2Y2FwczhWWU5tNGhySVRsSjFDTlFCd1ZuSUpKQzVkWmlWYnRx?=
 =?utf-8?B?QVN2THRhVTVYMjkrOVdHZlR1NVEydnNMclNFWTBYS09ZTGtTSEVHL3pIMEtx?=
 =?utf-8?B?OFJUMmY2VXpqbFd5MHB4NXRBOVpWTDBjKzZsQkNocFVDaGdZN25ncjNwOVBZ?=
 =?utf-8?B?enFVcjZJODFrdXZZdjZPYTA4cDNBazY2cmFPVnNkY2dUdHRoRmtOVlJZanZB?=
 =?utf-8?B?UG1iUWx0YmM4Z2g0WkwxeDRsZ1REUkNLU3ArSElZVEhTcU5YK2J3NzNzMGlM?=
 =?utf-8?B?VjFydUV3MW9SUWgxOXlyOFRwRnFYaHdIcXZleXRYL3lwNGNDNmNqSXlWaEZS?=
 =?utf-8?B?dmVtd0VROFgxTGhrdzNIY0RVRzQ2Vmg5NlhyaERFQ1g5OGNWNlIwclgveDhN?=
 =?utf-8?B?ODlleTB6ZzlnWS95am5QL1RQRTlZRE5Yd0YwdHlRWWtVazliNDJkQU1ONnBh?=
 =?utf-8?B?Zk9RR0xoenV3ajhKcHJZZlRHR0RscEFBakFrUE0vZ3dSeGxreUEvdVBGUFNq?=
 =?utf-8?B?YkpiYjZMczdJcldFdTFqdkJIaHFCdUl0U1N0bHFmYXlyYnF6MTBERGF6YjVk?=
 =?utf-8?B?aG94NmdrZmY5ZFIyNlJGZ1pWVG8yaTdWd0l0ZlhPL0FDU2QvbXZyYXlxYkl3?=
 =?utf-8?B?QllQdWhXM1pKN0lQV2c2YW91K2RRVVZjbkRQMG5rNzBUNXZpMjdpamhweGdC?=
 =?utf-8?B?VmQ1WTVaVTZvNFZIdVRZcGhDcXBZQnArY1lrMTZUWEpXNmlNNmVWZG5TUzY5?=
 =?utf-8?B?RGZGdHRtckx2NjdNTU5aRy96OUZaZzhNTTRzaFBobUR1bEdMR29XRndOYWE5?=
 =?utf-8?B?ek15TFRnUmh1aE5Xa2tiZ0pHNW53clFSVklhaVh2c0RQSXVOZFhuTHdTTTNu?=
 =?utf-8?B?QTVmdWpqVHRRL2R4Mk10VzVtMUlhVk9nMzJoZTBXSDBjelRpT3hyWisrTnBn?=
 =?utf-8?B?K2dTZ0U1RGRiS0tpVmo1WjlBcjh0VVdZZjc3T0pyZnB1RjdSdEx3MnM4TjFL?=
 =?utf-8?B?NE45aEl5NExGS0pLYVBOeUZyNnludWJWeWhpNVFsUUVjNmVZOTBQeUREUUVI?=
 =?utf-8?B?Z1pJM0M2NmwzWk1sdlBoM3NUNXE2VUloYzRQOWtRRU9vOHptUUx6MHVvSTdC?=
 =?utf-8?B?aXVaQXJicWxWNHFTcVhyR0hlbnNSVmVsWng5TEYrMUJOSW1VUXlOQzJRL1dx?=
 =?utf-8?B?TkNZYjI3NzlNbVNXK1E4MlhvUHpvSG1idlF4VllNNW1RMGFUdzJxM2tCT3hm?=
 =?utf-8?B?ekxrYzlaSUhaY3VFRk56b1lFQjk5QklhMk15MEp2Y1hBVmF2aTVJQVltRmM2?=
 =?utf-8?B?a1dPT3E5a1djemRKZ0xyY0FQMCtQQnY3S0hHUWNWQW0zSzZzS21ZbjBoYUQy?=
 =?utf-8?B?dVl1VGdlSW9iY0R4YkFsNlFiejJSRnd2cGtxNCt5NW1LZFJHcE9Fd3J5TUVH?=
 =?utf-8?B?bnpMYUZFclg5YjczT0dqazlRUWd0TnUwL3dxcXpPZFk2eGM4RWpJZGxqVi9w?=
 =?utf-8?B?cm12eHYwQlhNL1g5OE0xa3J2UU5RanhaZmREMks3Y3dBMnRPNDFaRmtmVnVP?=
 =?utf-8?B?YVRsNzdseWhyZzgvV2NYY3UyVmROd0czWEFGcG9GUEVKTEJpY2ExVlZvdkF6?=
 =?utf-8?B?emwrLytxZEw0QXQ0L201RDhYNXgvVW1TL1lLMVdrZitkTTRvSHEyQ2RpZUJE?=
 =?utf-8?B?Y2xFbWNsMW9BQ05BeUhmU3VTYTFPVW9VK1htK3JndFV3ZDk4WFJnNVhFQ0JX?=
 =?utf-8?B?UVYxaTRaNmg5aEZhOUxwRmVheHlCTG9wcVBvSFNCM3V2cWtQbHY1NTdjVjF6?=
 =?utf-8?B?eFVDMi9uaEhIVmwzMVZyc0xLYkZuOC8wb21KeGNwOEpWQkxvTDdMRmFwcjdV?=
 =?utf-8?B?QmxtZG4rTWZEbWo4VURnRHh0M1prWlpPRkZiS3pyck4wdngxZGVWV1dNRDVL?=
 =?utf-8?Q?WQGdzWw7dvstYSBBUNPJDROHv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2768A6E3C8BEF7409524921ABFF6B470@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df2b907b-2091-4e38-7e8e-08db76fa07a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 10:34:04.4999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HXhvJRiFXPVX+KJT0RDJkNZgIjIpUKYUTeWI37FpDzJYYRnO2yhagyMKzkqfyz8Ow6P2LEb77TBaV2hwTNrfFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4807
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTI3IGF0IDEyOjUwICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBUdWUsIEp1biAyNywgMjAyMyBhdCAwMjoxMjozN0FNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gKwkvKg0KPiA+ICsJICogVGhlIFREWCBtb2R1bGUg
Z2xvYmFsIGluaXRpYWxpemF0aW9uIG9ubHkgbmVlZHMgdG8gYmUgZG9uZQ0KPiA+ICsJICogb25j
ZSBvbiBhbnkgY3B1Lg0KPiA+ICsJICovDQo+ID4gKwlyYXdfc3Bpbl9sb2NrX2lycXNhdmUoJnRk
eF9nbG9iYWxfaW5pdF9sb2NrLCBmbGFncyk7DQo+IA0KPiBJIGRvbid0IHVuZGVyc3RhbmQgaG93
IHRoZSBjb21tZW50IGp1c3RpZmllcyB1c2luZyByYXcgc3BpbiBsb2NrLg0KPiANCg0KVGhpcyBj
b21tZW50IGlzIGZvciB1c2luZyBsb2NrIGluIGdlbmVyYWwuICBUaGUgcmVhc29uIHRvIHVzZSBy
YXdfIHZlcnNpb24gaXMNCmJlY2F1c2UgdGhpcyBmdW5jdGlvbiBnZXRzIGNhbGxlZCBpbiBJUlEg
Y29udGV4dCwgYW5kIGZvciBQUkVFTVBUX1JUIGtlcm5lbCB0aGUNCm5vcm1hbCBzcGlubG9jayBp
cyBjb252ZXJ0ZWQgdG8gc2xlZXBpbmcgbG9jay4NCg0KRGF2ZSBzdWdnZXN0ZWQgdG8gY29tbWVu
dCBvbiB0aGUgZnVuY3Rpb24gcmF0aGVyIHRoYW4gY29tbWVudCBvbiB0aGUNCnJhd19zcGluX2xv
Y2sgZGlyZWN0bHksIGUuZy4sICBubyBvdGhlciBrZXJuZWwgY29kZSBkb2VzIHRoYXQ6DQoNCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tL2QyYjNiYzVlLTEzNzEtMGM1MC04ZWNiLTY0
ZmM3MDkxN2Q0MkBpbnRlbC5jb20vDQoNClNvIEkgY29tbWVudGVkIHRoZSBmdW5jdGlvbiBpbiB0
aGlzIHZlcnNpb246DQoNCisvKg0KKyAqIERvIHRoZSBtb2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0
aW9uIGlmIG5vdCBkb25lIHlldC4NCisgKiBJdCdzIGFsd2F5cyBjYWxsZWQgd2l0aCBpbnRlcnJ1
cHRzIGFuZCBwcmVlbXB0aW9uIGRpc2FibGVkLg0KKyAqLw0K
