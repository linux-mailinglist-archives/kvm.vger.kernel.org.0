Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED1166BB2C
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 11:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjAPKFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 05:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjAPKEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 05:04:38 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1BB1B557;
        Mon, 16 Jan 2023 02:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673863472; x=1705399472;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AiyaHWRuyHVYvabDN2qSbh/fkPWEd27I1tW8S3R3KRM=;
  b=FXmAy9YN9sBtg/ILNpVQ8T1sPM2F2n8vMT234aF8aNY/kFBhoyCig750
   POxaNWz59YBY3F0SnTifyUCqiUac78PqpIX3ilvWpbhiB7q+LzYoVX96K
   wsyJLntU0KCN2yJyaViuculQRQ7BYvMYKR5fT4SzG1NuhXtLLu1VG15aS
   uKijZZ3lrMhApfL4uQsf5Peq0yELpkZwQCaXoMPtHf87tGDqD7gR8dA7l
   WXdR4+wJJ4zN9BiI5mSCIBnDrUzDRTKjAxN1R2/r9xO0RBphuXtG6kh6K
   fZDFvJTvnF0US/VEDRaF7h1EkNv/PayBg+cH/byfdR487E2C3qizZqqKs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="326488506"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="326488506"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 02:04:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="987745208"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="987745208"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2023 02:04:27 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:04:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:04:26 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 02:04:26 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 02:04:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Al/FcYd8gDFJgGgKHtcJvmhBZ9wW2TFHmbhj7WRFfLoKcvd46Olq5gCv8XI5CqPxxMwuOcfiCFPvU6e7Rx8SF3cU4o6WP+pV7/Yi/xPv9uBIKodrFWpc8vGiKjhCyzRE3Ei7ccLx2Y69/3gj+IXRtBPgENG3CRWDjKGdl+/Nd9nEJ2ItlPir6Ywml9mm5fQoAqbxSu9b4eiHlnt/BFhyVoHTQZeeqor0DlfnByOCigy0C1CUSP4/bov4uO6EvNtx902CVHakxH8353gttMmVMXI4tHI3ZwAXxrg34cUgrlIVuJgC4eo0PMPW/acCazIKjLAVTbctdvdRuFsy8oUeCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AiyaHWRuyHVYvabDN2qSbh/fkPWEd27I1tW8S3R3KRM=;
 b=g0/wiB3xnwheUmcq8s3r8N1JQnYVnTZdSqPO/JIEWTP+nJVU6zcEIz0UdNvixpw3+eMmobUT0fbPYsoXhQwn+63fuJ9GVH9zjdN0gxcCsABgQGCx5qO1SZA5p3Iy502Ngh24m1lb5MzIpIZrlWBkUMHG5vN10CDoSG0eWdAurWqAPlCDp74IzdRV2HaWeaYPjHJNqCe+BwqRkKWdlkxPxf42/e/Jkj9WRGBbJAu0t82yBJ7HqOoMQoxFugspJk7yj9s5mFQWm+PlZQW7weQUtw94rX5CfwvuvmxlbVUclNiTOEOlH9MwhIHP5lPXwkt561ZRYqRtXWDN0F8i3yk9wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5487.namprd11.prod.outlook.com (2603:10b6:5:39f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 10:04:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 10:04:19 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 019/113] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v11 019/113] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHZJqT1ezRBV5wttUugNmYVfUxfG66g1n+A
Date:   Mon, 16 Jan 2023 10:04:19 +0000
Message-ID: <426aa7c48100b4577dd107ca54896286c60b9d4e.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <a0b5c459cce27c83a1275a3108f810299635d217.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <a0b5c459cce27c83a1275a3108f810299635d217.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5487:EE_
x-ms-office365-filtering-correlation-id: 2b53d840-76f9-44cf-1e5f-08daf7a908ee
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OT0WZd5iFBHu3uXnymuJjgu0cr46gTvSVVjDz0y91oR9iu+vh996Cxn0y7yKY8VzwScNK+xBrJyElbGOjUlQlSK7iHsTgjgISg6mfdWkipZwsIxM01eXYPgi+Xcdb2yeBkla4/8wCJp/rzfsE0N64jXrAZ73GzM56oMx9ASS22gapz2QjDi3Op8BscZIeeKBWDsl0/xEEBmOIpKoQRbpj9r+sSlCZA3sGdp3OeMM1Wu50Bjc/eFPGbmwzLliod4y9iZ0PceHptNbJNmQQYCKqUj/thqAE8k0XRBAUxbouJyWvg7+eq/4oCPlma0+L2Tzo61TY2EmxIqlgdesY9fwHt64Cv5usO2AYTAYpiBoWdXwCEb8rj8VCqSMH/MyYtbVUz1OvGwBXQnPCGhBVIGKBQePU5OCjfz54Ec/dVbrW3gLN4ne9PDvJOiZx4mEw1at+l2+d+fJ0PC1lO8cqQUhTIcb4RKyEZRF8PlB1D38LsbU6kIKp4UDLYemNWSPAkZo+iwyfWOUkMjWAD+bsZrV7CYC26a6LoWoepTfCPuSpmhUjCEhukDML1jKuCQY6dw0dwr8do1L6PULWXOLBOjVK6RwICrPC5c/GncXEapvObOJkN0F0J+KxuFvKX5k03NdI1DSjvkjWwf1NdwSr6tYs/3tB2Tz/53yZyDEHUAgECM6fTaEQNi56txbXiDfkLUK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(316002)(6636002)(110136005)(54906003)(71200400001)(41300700001)(8676002)(86362001)(66946007)(76116006)(36756003)(66556008)(4326008)(66476007)(66446008)(64756008)(91956017)(38100700002)(38070700005)(82960400001)(122000001)(478600001)(6486002)(2616005)(26005)(6512007)(6506007)(186003)(2906002)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3ZZbnBTUjN3QmRZNTU0aGVvNEpmamgwOHB4U2lPZGdHejJ1SDYyMkkvZ2JY?=
 =?utf-8?B?ejhxNERjR0wvNlBlb3dKR3g2MDlqVFQwRXhrdmNDRVRrQW4zTlBmZUY3Ky8w?=
 =?utf-8?B?WlE4TENOa0hWQThXZzhzRTNTN0tUb21jbE1JdndCdW9wN0FUcFVsL1k5OFRF?=
 =?utf-8?B?ZGh4dFVhazgyaUlQT0pxbnZlSTVpRnNNTVRuR0RkWXRVK1pNRkxRS004WEpX?=
 =?utf-8?B?TXVpT3VxR2JVcE9STGdyWlduUHVxOTQ4Z2g2cG55V2xLRmc4SDJxbldXYkZC?=
 =?utf-8?B?Y21LVkpieTUxQmE1SFlvMWoxMkVHYURSSDU3bTIwU3RNV0NUSy9NdHZyUDY4?=
 =?utf-8?B?TExxYTRqdkhpQ2ttR2NVNVhjMng2aHp3MDQzaWlxTnV4bWR4QjFDRitpODdu?=
 =?utf-8?B?TWJ4T3duNVpBQzJlUE5TNnVYM3M2Qkc3emlBODJpN3BwVjUrRkdWc3FBcmhh?=
 =?utf-8?B?ZmhXN0ozNkQvVWwvSUtXYWlKU2lnalZIMWVUQUx3UEMvVVY0eEp2eGdEVE52?=
 =?utf-8?B?S1N6Y0phdmRsejdnZGNER1FaUmVkb1FDczJLQWFweEFOa00xZTRMV2F6cGpv?=
 =?utf-8?B?MVl3MTkrYkI4U0V6WkVGUFpLVm9qakVMTFJhcEhWTXErR3ZKa081QUltWWJG?=
 =?utf-8?B?ZnhSYWdyZ2YycGh3OXdUNzN5ZTB5eGtpeTkvV0ppaG85ekREV2lDYnZEV3o5?=
 =?utf-8?B?U25IMUp3cmMxMzIyNXZucjFmSmFHTXFoTG5pSkkzTGxLK043eFl5K2U1VVJx?=
 =?utf-8?B?cVg0c01BaVUzNmducEt0dDZwYjljLzNuTGRKa08yaHFlRlVIUVJyK09pM2Zt?=
 =?utf-8?B?THlGV2U1VG5aQ21jWlV5SkRjcDI4MzNVRWdVVTRwKythNHdqNTRIVEZUVHRE?=
 =?utf-8?B?aHNmaEE2RzBRZDZBWkxETGMvaVQyblJ6YkEvY1UvSHcrSVlXR1A2YlZ2T0x3?=
 =?utf-8?B?RVc0SWhFdmovMHI3ekF2blZEbVY4TlhVRGt2Y1kyaDZETlhLZlE0UnA0OU40?=
 =?utf-8?B?RGttVWxWTkJ6WkZZZklsMERKQUdXZ1JHS01SVHowcm1QQ0tuREV1c0hvWi8r?=
 =?utf-8?B?ZmZwdHE2NWdIMThDckkzQlZaVk9iQU9sZTJja1hldSt2UWV6NTVKMy9UVWQv?=
 =?utf-8?B?NVZtZEo4QmUwaldYZ1JjdlZxRm9SLzl2NDhnTFNvZWxyRFAxZjJDS2xSNnho?=
 =?utf-8?B?Q3FUbUxsa0hUbWRlZkJJeUVKZFlIMVQva2NuVHBaUjB4VE5sRG9HdkxyYStD?=
 =?utf-8?B?ZTFNUjR4d1g3TjNYYlh3V3R3S1R5QTVqODhCMWFNQkNuemFieHQvM2d6QUlD?=
 =?utf-8?B?UU4rbWZ6bDF3VUZ0d1ZvaXRPSUh2NjZvNHFVQTRBUkNpcmtCaW5UbzNHTmF1?=
 =?utf-8?B?TXBFcUJUOWJvR3cxMzk4YlE4MzZvYVJsRXk1RUMvbXZzODhZRURhbmEzcmY3?=
 =?utf-8?B?SGdscGlwZks1M2JZUkJmdVVXUE9rT1MzZ1J1S3VPYS8vd3d2NkRwNnN5Zm8z?=
 =?utf-8?B?K2VrMFlaL2YwODh3N3pRb21YNlh4OHdETGhmRVI0T2t3RnMzNE9jTDZRaFdV?=
 =?utf-8?B?NGJuL2FvV1Nzc2VLaVJJQ2hQbE4vZjgxcVlMa1Z6QzU3SEZhOWdPa29RRlh4?=
 =?utf-8?B?RjRxb2FzTzBzSDIvZGY5RFlKSktCaUs5MU5YMGNUVDN3N28xMzBYNkxualVW?=
 =?utf-8?B?dzVoMW9tVm0zUTNNeHJ5b2ZGUXJuRFk4V0N0b1hjeGZtd1FiSlJRNGNmZXhH?=
 =?utf-8?B?SEtFc1ZITWhqTjZQWDhrNGhOZWFJYkx2L1B5RlRHVkNYQjgwWkxhYUhEcFZE?=
 =?utf-8?B?enhCdmhHVjBxU0t1dGFWTk5uSnFIV3dpV0R1cEIwbTlQSklLdGhFZHpKNWdv?=
 =?utf-8?B?RHBkN2xXQjRTSUNubVNtSUdRZE80WEE5MUNQZVlWeU5ZWHU4NjRpRklnZjhz?=
 =?utf-8?B?RlRzWDRRa21DWnJnMnB4SlVyU05QeDZERDJkU1dtYXRwenVTdFdPTW5zSVBY?=
 =?utf-8?B?TGlQZ2hhNHJ1VzAyS21sdFp4ZUdBYUF1dEdrRUs0MmN0OFoxVE1iTXVGUmFK?=
 =?utf-8?B?dFF6aXpXTkQxQUdXdE9MZHhDOVIxUXZicFN1VVJPU2M3ekVCUm1tbnB0SnhW?=
 =?utf-8?B?c0ZhN3NHUU1kdFlZblN1aFRqd09qV1ZCZWVxQTd4Yi9iVnpQSDFZRFp0MGIy?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CA566451F628E4892DAC1FAD145F309@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b53d840-76f9-44cf-1e5f-08daf7a908ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 10:04:19.7234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1s4PoloP2kCgyy1BK5lL0l7lFGFzmm0WvH06Gt5IxcqdBd9oXenKkoyZFqC7qquUJQ/NY9qF+O7U4H9Dgt4R2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5487
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICtzdHJ1Y3Qga3ZtX3RkeF9pbml0X3ZtIHsNCj4gKwlfX3U2NCBhdHRyaWJ1
dGVzOw0KPiArCV9fdTY0IG1yY29uZmlnaWRbNl07CS8qIHNoYTM4NCBkaWdlc3QgKi8NCj4gKwlf
X3U2NCBtcm93bmVyWzZdOwkvKiBzaGEzODQgZGlnZXN0ICovDQo+ICsJX191NjQgbXJvd25lcmNv
bmZpZ1s2XTsJLyogc2hhMzQ4IGRpZ2VzdCAqLw0KPiArCXVuaW9uIHsNCj4gKwkJLyoNCj4gKwkJ
ICogS1ZNX1REWF9JTklUX1ZNIGlzIGNhbGxlZCBiZWZvcmUgdmNwdSBjcmVhdGlvbiwgdGh1cyBi
ZWZvcmUNCj4gKwkJICogS1ZNX1NFVF9DUFVJRDIuwqAgQ1BVSUQgY29uZmlndXJhdGlvbnMgbmVl
ZHMgdG8gYmUgcGFzc2VkLg0KPiArCQkgKg0KPiArCQkgKiBUaGlzIGNvbmZpZ3VyYXRpb24gc3Vw
ZXJzZWRlcyBLVk1fU0VUX0NQVUlEeywyfS4NCg0KV2hhdCBkb2VzICJ7LDJ9IiBtZWFuPw0KDQo+
ICsJCSAqIFRoZSB1c2VyIHNwYWNlIFZNTSwgZS5nLiBxZW11LCBzaG91bGQgbWFrZSB0aGVtIGNv
bnNpc3RlbnQNCj4gKwkJICogd2l0aCB0aGlzIHZhbHVlcy4NCg0KWW91IGFyZSBhbHJlYWR5IHVz
aW5nICdzdHJ1Y3Qga3ZtX2NwdWlkMicgYmVsb3cuICBJc24ndCBpdCBlbm91Z2ggdG8gaW1wbHkg
dGhhdA0KdXNlcnNwYWNlIHNob3VsZCBvcmdhbml6ZSBkYXRhIGluIHRoZSBmb3JtYXQgb2YgJ3N0
cnVjdCBrdm1fY3B1aWQyJz8NCg0KPiArCQkgKiBzaXplb2Yoc3RydWN0IGt2bV9jcHVpZF9lbnRy
eTIpICogS1ZNX01BWF9DUFVJRF9FTlRSSUVTKDI1NikNCj4gKwkJICogPSA4S0IuDQo+ICsJCSAq
Lw0KDQpXaGF0IGRvZXMgdGhpcyBjb21tZW50IHRyeSB0byBpbXBseT8NCg0KPiArCQlzdHJ1Y3Qg
ew0KPiArCQkJc3RydWN0IGt2bV9jcHVpZDIgY3B1aWQ7DQo+ICsJCQkvKiA4S0Igd2l0aCBLVk1f
TUFYX0NQVUlEX0VOVFJJRVMuICovDQo+ICsJCQlzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiBlbnRy
aWVzW107DQoNCkkgZG9uJ3QgdW5kZXJzdGFuZCB3aGF0J3MgdGhlIHB1cnBvc2Ugb2YgdGhlIHNl
Y29uZCBmaWVsZD8NCg0KU2hvdWxkbid0IHRoZSAnc3RydWN0IGt2bV9jcHVpZDInIGFscmVhZHkg
aGF2ZSBhbGwgdGhlIENQVUlEIGVudHJpZXM/DQoNCj4gKwkJfTsNCj4gKwkJLyoNCj4gKwkJICog
Rm9yIGZ1dHVyZSBleHRlbnNpYmlsaXR5Lg0KPiArCQkgKiBUaGUgc2l6ZShzdHJ1Y3Qga3ZtX3Rk
eF9pbml0X3ZtKSA9IDE2S0IuDQo+ICsJCSAqIFRoaXMgc2hvdWxkIGJlIGVub3VnaCBnaXZlbiBz
aXplb2YoVERfUEFSQU1TKSA9IDEwMjQNCj4gKwkJICovDQo+ICsJCV9fdTY0IHJlc2VydmVkWzIw
MjldOw0KDQpJIHRoaW5rIHRoaXMgaXMganVzdCB3cm9uZy4gIEhvdyBjYW4geW91IGV4dGVuZCBz
b21ldGhpbmcgYWZ0ZXIgYSBkeW5hbWljIHNpemUNCkNQVUlEIGFycmF5Pw0KDQpJZiB5b3Ugd2Fu
dCBleHRlbnNpYmlsaXR5LCB5b3UgbmVlZCB0byBwdXQgdGhlIHNwYWNlIGJlZm9yZSB0aGUgZmxl
eGlibGUgYXJyYXkuDQoNCj4gKwl9Ow0KPiArfTsNCg0KDQo=
