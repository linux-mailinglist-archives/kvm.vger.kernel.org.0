Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D416C2BB4
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 08:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjCUHuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 03:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCUHtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 03:49:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAA1A256;
        Tue, 21 Mar 2023 00:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679384988; x=1710920988;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3p3kmME3/mg0eF11RIdPNc1j1jZKerryRKJA3TzrFtw=;
  b=lzB7ub4FbO2zmImL21/lfJGVuWe917sEJ7acqctpS6qNwOJTMkc5kkHe
   Q/a9NGPK28SLvmlub+yHr8/AUHBJNU0hzjvvWIpsii5rY7JvqrRdRwxov
   no9efgNHjnRTD1uHEs6WBO+KiaA+XIVaqemrGHjkqgGWU2k+pQJsBYLnY
   kHJ2zwNHxHL/XQsSd8zoTt6RrWD/MK3e0qCBM31fd9SYCaNFXatM16/S+
   t8j6lAeARMw2XXim4wD471Aj63FQmV8s5E/+y6Rwv7/ewJEquH/u2L3fR
   ECAU6/cWmy3HT4T3WrKBUOIkKvKIhGMyBW5a6MaNL5s+Js9wgc7uwklXR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="401445375"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="401445375"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 00:49:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="658675490"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="658675490"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 21 Mar 2023 00:49:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 00:49:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 00:49:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 00:49:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 00:49:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtokdLfwUHP2CeLph9ba5vUFFGCB2HZTH+SNuGPY6Y5R1zP8HoxTZ4+y2ZYy4ZvdXBOy6BNdwm1TAyknEMzdnOedOqR308GGGdl7WKmCiM1+8/4/g92zFczy2c4ndZ2ozL40GipRZlUm2nuTz645HX5v1Z93icYgu1TFohYxbdXywei7DPFIzAurp8thYaDQRSS3IGpE1Qls84/tUjnL4pjaZYVlAsQ0b5rR3GkRkgkDnNAoVSOKo9/RRp0Fk1N+F3FzZv18FbmdL1Pv7SOrfbpa782zC1bQ3LeFoUQVyDriIRvSHdlX6lbu7qwmU9+OoRY5XXznprcLZHqW8/sWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3p3kmME3/mg0eF11RIdPNc1j1jZKerryRKJA3TzrFtw=;
 b=OZaZrzXKIegh5ZG8mDjXd6/Gm1w0Hr4xFGC0xYQ20AZ+x+roqYiF/tGzeIvmC/IPMDfHHsrJFsAYFFe0GsbA8Hjd5giNRr2aehtFAUpHplGVnT/ljavZmjdC6p5zXs5nL3f6KbuV1ju+uix95jN+ffGaK+CkhB351EYvTLe8PBH1VuSVh5Z4Zpzk2bhyQ7IxnRs+2uL7Kbxqyw4ZZbUxQgupq6vBG4KSUZCiDV0KHEj5HoQXPdoNQWZ3vgUAt+i5aUPBIEp78kUqsIbA3qWoyNDj7pAr5qFAz0NaHXJt/XUN/IrZ1WIZEqygUdMyO6G3Egp0DoIvupRN1AcSOLZX3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DM4PR11MB6118.namprd11.prod.outlook.com (2603:10b6:8:b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 07:49:37 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Tue, 21 Mar 2023
 07:49:37 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
CC:     "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 22/34] x86/fred: FRED initialization code
Thread-Topic: [PATCH v5 22/34] x86/fred: FRED initialization code
Thread-Index: AQHZUKIwUYB0dIbGLUidau1bSRiyL67/CYqAgACFIwCAAJcqAIAD0N0AgAB6oTCAAA7yAIAAbsmw
Date:   Tue, 21 Mar 2023 07:49:37 +0000
Message-ID: <SA1PR11MB673408E50152DFAB60800DA0A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
 <20230320164950.GR2194297@hirez.programming.kicks-ass.net>
 <SA1PR11MB67345D935A2368261E584085A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
 <5f81c066-d82f-b66f-9c6d-a9e6a0d5aa4f@citrix.com>
In-Reply-To: <5f81c066-d82f-b66f-9c6d-a9e6a0d5aa4f@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DM4PR11MB6118:EE_
x-ms-office365-filtering-correlation-id: 2d019c06-d11f-4b86-b77d-08db29e0d1c6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zbumLU2wjrnk0l7wQWm/PZ2loBDy5ozZntOGYCbjg+Gd8muFdjkc7MPQ6YPJH93HUv4LZrSI5OYtZJVJvl/rgs1BHf2adCr+vBKgQhNl+QKz10LAV1wo6VXgeshNf/ObO4/umKg39AYgN9z/HTDSsH6TmN1ZgueS/TWp7xbgGGuY6/B2lm74ZL7pTdiWG2cO9f/+TPoRi6/kPzOrD/17Zm3ptCInFUicIHL1qDrtSdaGsb9jHjta9rL4g+zMPr2ep5rdog4gEczzLtZPZRJTkjy+PsFdmjMLSzkATLvW2Wyv0r3PxGosaIACt7MkLZemHusPf1659lkWwigVE3yPF42zeo1aIFJ6NGcvvM/U9vuy/tWff/5RXwY6yc/x0s7hj/thOviqkeTtF3JQYLEvAvJzFmeY/xFdvDhKbrX5kSb9yKUQf8Yd5zpmw0pNAzKqMGpbwnpOmvsmVOXmkHQlICDD34Ks7uWNxK+RvAJV01Yl7aDmRAl/g1OYjQoOx9llamzoXJFoeCq7L0RL2RqMfLxQUu1/Zj93v/EG/r+J/s/r5yMYqgDNlPs7U0gagUGoUV/SaxMCoMP4gEvcxZSV1vSQKu54/gVI6Zj73H+TxRuvZvDqwfByOJ+DCOeE3iBDx2mURe4VOX5JQbDfEuVDVrr7MYDFhfMEH7PWQOSitVe+cc7J2/qEnQzSHSpk2qHdi6Kh4l/aKJnVDPf3ACqq7PWobSzZfkRFiYwtloDput8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199018)(8936002)(5660300002)(7416002)(41300700001)(52536014)(55016003)(86362001)(38070700005)(33656002)(38100700002)(82960400001)(2906002)(122000001)(4326008)(966005)(478600001)(83380400001)(71200400001)(7696005)(186003)(6506007)(26005)(9686003)(5930299012)(54906003)(110136005)(66476007)(316002)(8676002)(66556008)(66946007)(64756008)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zkt6SXlsQUpQbXkvQVMrMTREUWtsN2lmeStaVERQVU5Eb3QyaGZHZXZyeUd5?=
 =?utf-8?B?RFRKTGl0VklCNU55UVIvbnAzRFNKVUdYRWQwSXV4c1RqQWNZaDJPV29XemE1?=
 =?utf-8?B?am5NbDVOTU9oVVZzVmhrcDVWc2xHUWMxYjZRYTVFQWhxUXB3bUFPejljcVBC?=
 =?utf-8?B?cldsSGZnUE1iNXJWa1lVUmNxN1ZHTGFQcGFuNmtsUkZ2N25MVlUwTm5hcnpq?=
 =?utf-8?B?VHZscUJVRGFLZ3EyVWJiTWpmd0U1cXUycFBqTlpWa2Z4UE9CNVdlSUFLODY3?=
 =?utf-8?B?Q3l5Q0crSW9YUEFPUGMvUjNqN2lkYWRES0ZLbG1ET3FBVCsyNGtwRG1KcXJO?=
 =?utf-8?B?TWUrUFE2S3ZOa211a29YSmwxTXdpSWZZZGl1emdOa2I1NHpVdmRWcHN0eG9w?=
 =?utf-8?B?S2RlRGMzNkd1ZGZzYm5vR283b3dJRXBTcStlMWZ6OGIxbWlwVnNaMVZPNEVT?=
 =?utf-8?B?d1UxWWIwY3FjMHpmb3phaXYwaWIxWWZGQjBZaWdSRWlIVkFkYWwzcE9CZ3A4?=
 =?utf-8?B?RHFFUkxvMXMwRVlIb3poM3YxZVdzak9kR1kwejlGcHNLNllKdHF0Um5nbVgv?=
 =?utf-8?B?US8wVFJzU2pSY0NncmhyUDAydmtwcGlFZTV5K1gxUDhvc2Vuby92NmhIa3Vp?=
 =?utf-8?B?QjJFcVlKM0hlYVFpV1hURUhITTVlL2VwTUMxenZmTWg0MmhBSUVjMmhRclQ5?=
 =?utf-8?B?cWp0b2xNUzVqUGNyNUlvb08wd2pjblFndWtwdlFHTEYycFJZMFlrMkhYZXpm?=
 =?utf-8?B?Y2lSY1R3Q0tUU2dOSXkrbTNPbzBlVDZPaWxUYTdDUFVRbERhV09NaGlZaFlq?=
 =?utf-8?B?ZnJpVTBrT1ZQQTk2QUZWNW40RHBCa3BtdnFHWmw4UnNmWGtmWWJGNWordmEx?=
 =?utf-8?B?Mm5wY29yKzJLTk9YM2hvaXFxeXhQU0l3NzdRcnJvczdxNHdQa3pBNFNQUkoz?=
 =?utf-8?B?YWR4MHU5RC80UXBUbHM4RGMvYjVTampnZGswNFJNaFE2eGZhZU5iNkhDN1lF?=
 =?utf-8?B?RnJHYnowUVlYQVZ2ekhkRkt4SzIyMGF4TFZSaXRSOVI3UUJlRG9zeVRVc3Uy?=
 =?utf-8?B?VnhOZnNNQklyUGt2bTRmdlR1OGZ6V3NHa0UxRnZBdEs5aVRCdHpHei9zSXdz?=
 =?utf-8?B?M1FINm9qUmgxSXorYjVkMXFiUTlmVHg0QURQOFpWUVRwTHoyOHVLZGJSR0Rm?=
 =?utf-8?B?LzdSNUpIMksrR09KYVlJVjJwcUJsdzhoUVZWWWY5VWFFdXo4L2RyRnB5THo0?=
 =?utf-8?B?bHJ2enJ2Uyt0dHVGNFdlNTZmQUZBL3gvVllIc212K04xcytPS1RHQzZoMldt?=
 =?utf-8?B?TXJzY1A1dnQ1VnBXaDdEM2M0ak1tNjhvbnpLOHlrL1dLdzNlZnBWYzdrdEZK?=
 =?utf-8?B?Q2xiNjhRcGkwVjk4V0tSMm4wUCtNMWRBTWZVMzVHSmpDMmwzZUxTOW9TOUZw?=
 =?utf-8?B?VExzenB2Z3FXeVQvVE91TlVWeWNUTFlwa21PWUJKYVRkVjJEaTBWZU5SMFRz?=
 =?utf-8?B?a1FQUWh6NzRuVkhEZkdGeUNDaXgvK3pYRll4ZGZwU0FKc1NHVkNOZlRMU3dK?=
 =?utf-8?B?K0ZSWE9TSFFHNzI2Y2FxMEJBR2JuZHQ4OEpBeDVJc1plU0ducUpNUmRHUzhj?=
 =?utf-8?B?eWdPUEtkU1BaWnphU1lJQURManFicmEvdTVYTWVtVUVpVmIzTFJQM09rYkMx?=
 =?utf-8?B?eGswL3B6a29rQzRYZ2RhRGx3Q0ZLaU1KM3JVMGE4c3lnUExrT1JLbjVjQkQr?=
 =?utf-8?B?N3BwMmQzQ29oK0xQQVF3cHhpelNXUHJ6dnJ3Wm82MzgvTlhyTkg1Y29pRUlr?=
 =?utf-8?B?cFV2cXV3Zmc5a3hNVWtHL012Qk9ab3RCNnlYaFhPdVRWUSt6VGRkTWJWR1Zq?=
 =?utf-8?B?dERFZ1Fuak5uVGgrYURESXhrUXkxdlU5Nk4yK0VNa3dtbEo1MXRnQmpRZXJ4?=
 =?utf-8?B?NG9Mb0Z6SktxOXRWbUdiM21FNUtMd3QybFQ3K3M1dE9WUWRuREZBMm9kZGk4?=
 =?utf-8?B?MzcxN0xNWm5NaDJNNjhGb2dWWFdxRWRNMFRSYmN1eXBuWUVDSXpkeFZVVkFM?=
 =?utf-8?B?NDBJOUdOczQ3Tm9na3JsN3N4cnpQZkdKZjZUZkxYZnNXdzYrTFJvcUV4Yngw?=
 =?utf-8?Q?M3ZU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d019c06-d11f-4b86-b77d-08db29e0d1c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 07:49:37.1408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8m/a4Nj1dc17ug3F7t7fWqh2vOYvyx5HjW21k3DAUfrlKwauCL3ByOkB7YMbBsNGKZOCiT8TXGfTjOPJLD0ywg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6118
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+Pj4gSWYgdGhlcmUgaXMgbm8gb3RoZXIgY29uY3JldGUgcmVhc29uIG90aGVyIHRoYW4gb3Zl
cmZsb3dpbmcgZm9yDQo+ID4+PiBhc3NpZ25pbmcgTk1JIGFuZCAjREIgd2l0aCBhIHN0YWNrIGxl
dmVsID4gMCwgI1ZFIHNob3VsZCBhbHNvIGJlDQo+ID4+PiBhc3NpZ25lZCB3aXRoIGEgc3RhY2sg
bGV2ZWwgPiAwLCBhbmQgI0JQIHRvby4gI1ZFIGNhbiBoYXBwZW4gYW55dGltZQ0KPiA+Pj4gYW5k
IGFueXdoZXJlLCBzbyBpdCBpcyBzdWJqZWN0IHRvIG92ZXJmbG93aW5nIHRvby4NCj4gPj4gU28g
I0JQIG5lZWRzIHRoZSBzdGFjay1nYXAgKHJlZHpvbmUpIGZvciB0ZXh0X3Bva2VfYnAoKS4NCj4g
Pj4NCj4gPj4gI0JQIGNhbiBlbmQgdXAgaW4ga3Byb2JlcyB3aGljaCBjYW4gdGhlbiBlbmQgdXAg
aW4gZnRyYWNlL3BlcmYsIGRlcGVuZGluZw0KPiBvbg0KPiA+PiBob3cgaXQncyBhbGwgd2lyZWQg
dXAuDQo+ID4+DQo+ID4+ICNWRSBpcyBjdXJyZW50bHkgYSB0cmFpbndyZWNrIHZzIE5NSS9NQ0Us
IGJ1dCBJIHRoaW5rIEZSRUQgc29sdmVzIHRoZSB3b3JzdCBvZg0KPiA+PiB0aGF0LiBJJ20gbm90
IGV4YWN0bHkgc3VyZSBob3cgZGVlcCB0aGUgI1ZFIGhhbmRsZXIgZ29lcy4NCj4gPj4NCj4gPiBW
RSB1bmRlciBJRFQgaXMgKm5vdCogdXNpbmcgYW4gSVNULCB3ZSBuZWVkIHNvbWUgc29saWQgcmF0
aW9uYWxlcyBoZXJlLg0KPiANCj4gI1ZFLCBhbmQgI1ZDIG9uIEFNRCwgYXJlIGJvcmRlcmxpbmUg
dW51c2FibGUuwqAgQm90aCB1bmRlciBJRFQgYW5kIEZSRUQuDQoNCk9vcHMhDQoNCj4gVGhlIHJl
YXNvbiAjVkUgaXMgbm90IElTVCBpcyBiZWNhdXNlIHRoZXJlIGFyZSBwbGVudHkgb2YgcmVhbCBj
YXNlcw0KPiB3aGVyZSBhIG5vbi1tYWxpY2lvdXMgb3V0ZXIgaHlwZXJ2aXNvciBjb3VsZCBjcmVh
dGUgcmVlbnRyYW50IGZhdWx0cw0KPiB0aGF0IGxvc2UgcHJvZ3JhbSBzdGF0ZS7CoCBlLmcuIGhp
dHRpbmcgYW4gSU8gaW5zdHJ1Y3Rpb24sIHRoZW4gaGl0dGluZw0KPiBhbiBlbXVsYXRlZCBNU1Iu
DQo+DQo+IFRoZXJlIGFyZSBmZXdlciBjYXNlcyB3aGVyZSBhIG5vbi1JU1QgI1ZFIGVuZHMgdXAg
aW4gYSByZS1lbnRyYW50IGZhdWx0DQo+IChJSVJDLCB5b3UgY2FuIHN0aWxsIG1hbmFnZSBpdCBi
eSB1bm1hcHBpbmcgdGhlIGVudHJ5IHN0YWNrKSwgYnV0IHlvdSdyZQ0KPiBzdGlsbCB0cnVzdGlu
ZyB0aGUgb3V0ZXIgaHlwZXJ2aXNvciB0byBub3QgZS5nLiB1bm1hcCB0aGUgU1lTQ0FMTCBlbnRy
eQ0KPiBwb2ludC4NCj4gDQo+IEZSRUQgZ2V0cyByaWQgb2YgdGhlICJyZWVudHJhbnQgZmF1bHQg
b3ZlcndyaXRpbmcgaXQgb24gdGhlIHN0YWNrIiBjYXNlLA0KPiBhbmQgcmVtb3ZlcyB0aGUgc3lz
Y2FsbCBnYXAgY2FzZSwgcmVwbGFjaW5nIHRoZW0gaW5zdGVhZCB3aXRoIGEgc3RhY2sNCj4gb3Zl
cmZsb3cgaW4gdGhlIHdvcnN0IGNhc2UgYmVjYXVzZSB0aGVyZSBpcyBzdGlsbCBubyB1cHBlciBi
b3VuZCB0byBob3cNCj4gbWFueSB0aW1lcyAjVkUgY2FuIGFjdHVhbGx5IGJlIGRlbGl2ZXJlZCBp
biB0aGUgY291cnNlIG9mIHNlcnZpY2luZyBhDQo+IHNpbmdsZSAjVkUuDQoNCkV4YWN0bHksIEZS
RUQgc3RhY2sgbGV2ZWxzIGNhbiBtYWtlIHVzZSBvZiB0aGUgd2hvbGUgcmVndWxhciBzdGFjayBz
cGFjZS4NCg0KSSBndWVzcyB5b3UgZG9uJ3Qgc2VlbSB0byBzdXBwb3J0ICNWRSBvbiBhIGhpZ2hl
ciBzdGFjayBsZXZlbD8gDQoNCj4gfkFuZHJldw0KPiANCj4gUC5TLiBXaGlsZSBJIGhhdGUgdG8g
Y2l0ZSBteXNlbGYsIGlmIHlvdSBoYXZlbid0IHJlYWQNCj4gaHR0cHM6Ly9kb2NzLmdvb2dsZS5j
b20vZG9jdW1lbnQvZC8xaFdlam55RGtqUlJBVy0NCj4gSkVzUmpBNWM5Q0tMT1BjNlZLSlFzdXZP
RGxRRUkvZWRpdD91c3A9c2hhcmluZw0KPiB5ZXQsIGRvIHNvLsKgIEl0IGRpZCBmZWVkIGludG8g
c29tZSBvZiB0aGUgRlJFRCBkZXNpZ24uDQo=
