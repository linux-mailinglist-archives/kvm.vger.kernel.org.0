Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CB4751EC5
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbjGMKZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbjGMKZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:25:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C128B0;
        Thu, 13 Jul 2023 03:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689243899; x=1720779899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vw2ntZopvg5nU5QxMufsJDYrJv1lGTtPEIZGWTmHPv4=;
  b=iUBpiUgcKfqlUmn20i2EzCh31PeS4su8l92072jNgH0In7OvkFaTopKV
   /aKKP+kpvKEVTLHVnfbIs3jTAjRCYQWMMdIbYMDFD+JgwZYy46rqL+/U8
   Ed56TBvYNmCA0c1m3JEZax7jTROsi32LpufnLq0DSgL6NJo6GauuFFLjs
   V1gw79BWMzSOkdrwWB1jMKozgBY9lHa7DxolbJk2tnkAPS1C+kaZbHrmo
   xdZxKJ90iqX2SDgkwIifCl+Z8LiTxkXZ4xBL1Chsr9dCrl0rcIPRC68eM
   NLDJ7IQkHELxfOv2ffH/qmXwX1mI/elFSYBsCJOiAHzxDKaIhMnlowvxP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428895029"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="428895029"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 03:24:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="751565400"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="751565400"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 13 Jul 2023 03:24:58 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 03:24:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 03:24:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 03:24:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 03:24:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pu25oyiI2Hfu4xEODLy+idUVKl4lu1V4megZHtPTFZEoiVwuxSDQjIICm4Vmhl+KNQ+wpOoBHJd2OBJSgGIOfowv+bG5XbPPEVaTfSFEyA9I3JtF0TQ3lRX8JyHZ/fQkF3ZBgKYNiCMUZ6+wA9kPLP76+CJDIK/h+zVmiK+HFkoWlUS1gW9tX6DhfCxHSEO4MKntZQqoXqWFJVA6hNgaaGW1ECATNdxHZrbMc2hbVJaJe1RoiLmD0NUFyVbmkXIRAsu/+iGp9a7JghMhum6DpruhJkvcwHcbqvdp2SeKLYr5Pc1PPFjZb6KP7T0facAukVgv8fkMmpasyC2QdarVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw2ntZopvg5nU5QxMufsJDYrJv1lGTtPEIZGWTmHPv4=;
 b=ACZVTk/hKCdqt5ksDiknVK+QqOzMCBNbvKSklkYB921TvYYkz7n8qfRtBkrwJIaFfJPuga+pwpTXlX6QZKjLY/AZa1ezQTD7KA4b/v5YSbBTQJaRLgNhYXHYg7YlE+sqVd+jEPtdDMuAT3yCmBendbnPFNx8L5Dzk55M4nfIhfECPNSaa1/VRNtJZWUuR0Y7XzYo4urs9PjLvqbPn/pFzhi/CHewJKFElNbC7eG12zXnfFVy22gqYl4aAm/LBhTvF3lywdeMJ0zpveirT2kazGi2GbziBDxzXD912hGP03yclGA+TmRQpSqDWJtc2VYePJP+2tWdvADgJwGkV3J8aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7145.namprd11.prod.outlook.com (2603:10b6:510:1ec::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 10:24:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 10:24:48 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Topic: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2WZEAgAABkQCAAPx6gIAAC1QAgAAa7QCAAAFlAA==
Date:   Thu, 13 Jul 2023 10:24:48 +0000
Message-ID: <a2218af09553f89674d3ba3d59db31d2521745e3.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
         <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
         <cc5b4df23273b546225241fae2cbbea52ccb13d3.camel@intel.com>
         <20230713084324.GA3138667@hirez.programming.kicks-ass.net>
         <5cc5ba09636647a076206fae932bbf88f233b8b2.camel@intel.com>
In-Reply-To: <5cc5ba09636647a076206fae932bbf88f233b8b2.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7145:EE_
x-ms-office365-filtering-correlation-id: 52c748ac-8dd0-46ac-38ba-08db838b6312
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S6eDPTzCrTq2Um9Bf+spbkzaBgxnb1g8qGvVD4YVJjkRRZqTQm47aw47I/T1haKLFDLLS9VZ9pwmj2PbdwBXtFKsPmsemge8JsxmH2FV1v+meBqZmA6QuoCY4Mt55xc9sWCvQHdPvjCFU5naIK8wYlFPiYI3If6M2r621D94WS2K1Kc98ZqH3wJ5lo+axczOGxQe4gyrP8OmF7U36ATBotiC1yi/ddJFuD6el3rS6CkibhsScF9/5+YLiJmhFhcDIC1TPkn/OX49jutmq7SKDzowQGQCgM6i1Lfxb2OuKuCy3dg0a6hZc1cO7juSilhcBSBR/rfYKP8Qua6/wMIbZo2JB/pV4KQ3ycLMDpSmQPjDJLKao1WgKccCd/yBfFUijzmXuGqylFp6NlTM7FA/uis7rHKkBjIIdZDtyjyT35oxC6nKGerE1d+bmIrPuBl8cOE0A3OQU+8V5epVkIzBvEZKyehC+lOxx8nIcEbpO1/YLh2i4D5b8khFJAb7OwdFSpWalMSnUNbLMCbOOX00P7JGvw3onSuPiJkYiAQDlhgEyQGQtGk8m+CfXiQf7K3YeMsh7BSZCV3fURnS2CXaplf0Iql81zmJUmlIiB+mukkoDS0G6JHDB6m2T63zhXMZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199021)(316002)(41300700001)(8676002)(8936002)(6512007)(6506007)(7416002)(5660300002)(26005)(2616005)(2906002)(66946007)(6916009)(38100700002)(4744005)(54906003)(122000001)(36756003)(86362001)(478600001)(6486002)(38070700005)(64756008)(66476007)(82960400001)(66556008)(71200400001)(66446008)(4326008)(76116006)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YlA2ZE1RcmVmMUYvQVh3V2V6b0swQ2JSVmRyOUk3N0hBMkpDbG9xT3FQaFdS?=
 =?utf-8?B?Vy9Va1RDMnd3bmV1MldKaUQxQndJd1ZEdFBCNTNweFJqa2RldHhFUzlWV3c1?=
 =?utf-8?B?enV2NndIU1dzN1pNb29MQzRneEdZaDFtMnV6VS9zNGVCeE1ibjRUWGpma0hp?=
 =?utf-8?B?TzUvRW1DS2o0Vk4weHIrT05rN3c1STRidVpCdDVZQWhxUVN3MVdmYXc4czZO?=
 =?utf-8?B?dUZKRzBxK1ZUeWQxeXRMMGJRNFNzTUpRY3N2K0poaVZSOC9qaVhRSjU3VnJE?=
 =?utf-8?B?M3FmNjFEQ3YweTU4VFFjQWw1TjhsY2FIWVA0aUNhQmcydzROL1YxYlFkdkc1?=
 =?utf-8?B?MlE1TS84Ulpad1QzNzcxbVBOeUVjTi9sZ2JQU2FVcU01S2g3MDFET3lpSUhY?=
 =?utf-8?B?SVhubDFHbzVydXB4YXRuaE9XWWlFK3RYaXlzck4vZ0Rob25qNVBKbUt0b1ZH?=
 =?utf-8?B?R2lHVXdHU3dsa25iTk4yc2JiWExyQzBJblBvWGxDQitRc2wxZzBvSXNIL005?=
 =?utf-8?B?RWl5bjZVdFUvbXQ0dUowd1FlOE0xTmNENjgvUXE4c25ZQ3NUSldNc1Y5K1dG?=
 =?utf-8?B?STBNOHl4RFMyNkQvWkFlMU1KSjYyeDZuRWR3ZU9jYTdXOUpoR0x3emhYbW0y?=
 =?utf-8?B?OWNkd2pYempmaGlaZlJzUGlRSXlGbmRyem1QZGtHSHNOQTJSS0NVbDB4YTdu?=
 =?utf-8?B?U2VwVjlaeHFUeUZtekRVRzNtV1BqcHIzb2YxRHA5Z2dOQzRVK1Y2Uzc3SXFZ?=
 =?utf-8?B?c3J4aU5oek5GWTA3RXJkc0RsZUV1d2tkNmY4MWhrK2daWHhrYUFLdXZNN3do?=
 =?utf-8?B?RVNYcTNkaHkyWVN5dXF3dnQrYUhHdnpieXNHUndvcngzWDdacjVGbS9lM2Nq?=
 =?utf-8?B?OFJEVGw3V0J2cTNSNGlLV2VPZGI1T1dVd1R4Wk5GTUl3a0tvTWJBdE0vcS9C?=
 =?utf-8?B?cGs3NXZoY2Mxdk1kMTd0cUZKbmtjdmpLcVI0MTdmL1hDYitYYmZZOHZxUnE2?=
 =?utf-8?B?Z3l0R1FQckJKRVVBZ2JzV2Q2Ny80QUw3MGNwaCtKVTRFekh0a0kyWnZRN1Zm?=
 =?utf-8?B?ampTa1lDUUFqWDhLd3phQTN5aDR1cHBWbG1ydFQxYU1VMDdlaUM0akNaaGQr?=
 =?utf-8?B?b3FvSUY3bDV6c3hqUGxrYXdhTVBaNmR0aDJJYW5HZlVEa0dRUVNFeHNrNG9L?=
 =?utf-8?B?ZDd1cnBMdktjZmh6MzRFZmVzYkR6bDV5bURmYnZCTUEyelMxZm1HaXc3ZU5s?=
 =?utf-8?B?aGY0TWxHdWpraEpYRTNnQTROT1h0RzJMSlFFdGxSajUxdTZZbDNVK1Brdllr?=
 =?utf-8?B?aTdzS20wZXF2V20zQ0tGNXM4WHpvMGNlZWpmM0NzcHRJZE5WSExuLzZlbVYy?=
 =?utf-8?B?WTBXT1Q0TVZvd2tFUVU0enRKa0ZLYy9WbzdPV0hBdWdkWUlYdit1VkZqQWI3?=
 =?utf-8?B?MXNpNG0zOXA5aEtrTXdMQTdWTDFTaXZxSlArV05aUnZUcnZPMkFOT3h3ZUsw?=
 =?utf-8?B?R082R3R0NUZUVUpMWmZZYWtYTlZFNmNMVlN5bkRVMFR1NklXb0FDMTJ0ZGc3?=
 =?utf-8?B?QVJoKzFRQ1JvVGdteHJHcDFPZGFPMjZZbzJPZU5VWnZFdXliQlFnalp4RTds?=
 =?utf-8?B?ZEdGOENSVDJWeS9CaC9yWmJJVXZqYzIrV2VOb2JYZWw4bXNza0tNWG9hYy9K?=
 =?utf-8?B?UHBTZWxwWVFCdG9nRWxmeU1JYlJCcERMZVp0SDFIeVdscGFtVTVkTkpPK3VU?=
 =?utf-8?B?RWVXMGVpcmhGRVdVLzNBVkxTVHliNXFtdUR4K3hlc1JRcHJNNjkxSk9GdDBZ?=
 =?utf-8?B?WkhlQUhpVytaYldseUovTSt5dmIxSmdwc2Z5TWpTRnNzZXY2dDAwU2NMMnV1?=
 =?utf-8?B?MzRGa2hKSDVhZWptdkdNamp4V0hIQldJVklVS3Rud3dBaVNXNSticlc3cmFW?=
 =?utf-8?B?UzRzRVZ4YW9sTkpkMkxWVERNMENxeVhWWDFvRktuUzFFczV3dDFlOVVmQnRK?=
 =?utf-8?B?aHFlL3V0RFpGZ1JZbm1LZzRaOUNRbkhKQkhEKzF1SmNBQjVoR1lyUm1GMkwy?=
 =?utf-8?B?b0xyYk1UTFlMWFBWTzVvK210ZUE1d0ZmcXZ3bnFsb3FEaWRqUWg2N256VDl6?=
 =?utf-8?B?WWt5QXlYcjJUaWgrRytDVmo0L0NuMHdTbEpRcnJuS2ZvZHZDQ2RUSkl4RTd0?=
 =?utf-8?B?cmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A41509A309794145B468EBA3E950A857@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c748ac-8dd0-46ac-38ba-08db838b6312
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 10:24:48.8451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZV2rJmkXj3zWaaU1WHLVm8UWGPqRfxoGPHvkJilBhKxnCUMj4r3puHZYwNRN4QgivjwVYPNopEqzoSHPy7N+Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7145
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDEwOjE5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjMtMDctMTMgYXQgMTA6NDMgKzAyMDAsIFBldGVyIFppamxzdHJhIHdyb3RlOg0K
PiA+IE9uIFRodSwgSnVsIDEzLCAyMDIzIGF0IDA4OjAyOjU0QU0gKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gDQo+ID4gPiBTb3JyeSBJIGFtIGlnbm9yYW50IGhlcmUuICBXb24ndCAiY2xl
YXJpbmcgRUNYIG9ubHkiIGxlYXZlIGhpZ2ggYml0cyBvZg0KPiA+ID4gcmVnaXN0ZXJzIHN0aWxs
IGNvbnRhaW5pbmcgZ3Vlc3QncyB2YWx1ZT8NCj4gPiANCj4gPiBhcmNoaXRlY3R1cmUgemVyby1l
eHRlbmRzIDMyYml0IHN0b3Jlcw0KPiANCj4gU29ycnksIHdoZXJlIGNhbiBJIGZpbmQgdGhpcyBp
bmZvcm1hdGlvbj8gTG9va2luZyBhdCBTRE0gSSBjb3VsZG4ndCBmaW5kIDotKA0KPiANCj4gDQoN
CkhtbS4uIEkgdGhpbmsgSSBmb3VuZCBpdCAtLSBpdCdzIGluIFNETSB2b2wgMToNCg0KMy40LjEu
MSBHZW5lcmFsLVB1cnBvc2UgUmVnaXN0ZXJzIGluIDY0LUJpdCBNb2RlDQoNCjMyLWJpdCBvcGVy
YW5kcyBnZW5lcmF0ZSBhIDMyLWJpdCByZXN1bHQsIHplcm8tZXh0ZW5kZWQgdG8gYSA2NC1iaXQg
cmVzdWx0IGluDQp0aGUgZGVzdGluYXRpb24gZ2VuZXJhbC1wdXJwb3NlIHJlZ2lzdGVyLg0KDQpT
b3JyeSBmb3IgdGhlIG5vaXNlIQ0K
