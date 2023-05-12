Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3BA7005C8
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 12:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240738AbjELKlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 06:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240355AbjELKk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 06:40:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC605E53;
        Fri, 12 May 2023 03:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683888057; x=1715424057;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9KMsUsN7anxU1iaHL3qcQ5mzSa4Q1tNFBRazHnX7nX4=;
  b=M4xxWH8vUr7m/nXQsmm31LY0gDO/kXMDCcesr2M3NN8loSDBSo7MmGp5
   O5c6KjIUtH8+IsDRIazk0aKvbJ6iD+b9WKD0dws2BpQSqUi32APlMuuCX
   eiw+dwKDXsnKl7rP8ZhQmrY9S9YdnwfQt9U5LYxY2RL4kFmK7REg4bGW9
   vmWcxgzZDjp8Hg1nUollHEDCchSgMB9GaC4TNEQJAG43ClBlYDJJsWmRZ
   pseAxhFalkErMph4xPhsI633OZ3ghIGf3e8MgU57gJK3JknMpsJPvmSdy
   wtbpgC6OlgWmLukwddHcp3yYnNiTv54BmLCrfJW7p/OfPp/bIVQoMXwK4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335279883"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="335279883"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 03:40:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="765138758"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="765138758"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 12 May 2023 03:40:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:40:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:40:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 03:40:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 03:40:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLzpobDkh/Bn+2wSAJQAsfCV7itqiL5+p79Kp8cMvXGnqHzvqdh6go8tH4DhyTdT2w5n4HBvQT8iIgpbXkHih7hcccBuIGBRGOA/A/kwJJ137lzxyO8Yakxds/5ZesXvvjG8Fu5ziRovlYOkT7+C94h6/k8bHJq3RcOZrXXyCZlA2zba59oEOd21RAfO6YYIGN67DrLd8YNlP0BK1yw0sMl2kyXrjGIH/xeEXSxPJhMGiAK9f9TCOFBaBhp9ZUf1p04t6WI/NIReTYtBlJPYVGM1ftM6AI1kmTIn9ikJZsZZMRNJwKzQrFMpwe+nrH3pHnQZzLltWpy5wqh1CbjHxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9KMsUsN7anxU1iaHL3qcQ5mzSa4Q1tNFBRazHnX7nX4=;
 b=OfvflUzTod0VSsd+6xFLzOjPhIfRtxDAozKOTIp6GKkIggoJsLi6YP83ym0MR0JycGnfbrjsGHSz4YszcCrPIidJhM4FlfmnX38dMFgfz9VEURMEtN/OEa1h4LQNA+C2lgUwqMA/J7uopMgNkGyVPC1et50Um2unIc7NFuhMlPPYnCX8k8akmM3kuFaN+ugYyI2Z5P/IRA/x++gDNw0BWdWQewAFqgoaeFkE+LpEgQy+6mXTPAmsw2A5R2icc2d7daoRojuaMDi+nNUv++RB6uBXA+9geFwTv9GZkJ8Uu1+H/ZZ6z/gcuh2W6D8T4riMM5jWfkNP+pbBU1dtVLEvWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4902.namprd11.prod.outlook.com (2603:10b6:510:37::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 10:40:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 10:40:43 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH v2 6/8] KVM: x86: Move PAT MSR handling out of mtrr.c
Thread-Topic: [PATCH v2 6/8] KVM: x86: Move PAT MSR handling out of mtrr.c
Thread-Index: AQHZhGEgxTG1iNGab0C3lFd5JrwF969Wc6KA
Date:   Fri, 12 May 2023 10:40:43 +0000
Message-ID: <c6044256ee34a29f270fd76c5cae044b5ed28f0d.camel@intel.com>
References: <20230511233351.635053-1-seanjc@google.com>
         <20230511233351.635053-7-seanjc@google.com>
In-Reply-To: <20230511233351.635053-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4902:EE_
x-ms-office365-filtering-correlation-id: 3ace5607-4bed-4644-ebe1-08db52d55670
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gSdzy/EwlvKKA6zVn/DLCfX6kwn7pXF9iSH885ltzBLp619rjVsHvi1/dB+ofj0RqdepefzYoftvXyTinq8kKQJxUQ96WMcnIyJm3qv8+45ea5l7a+kqvTJBXEVgStKkG2AySnCddNwQroTwmGXOvuPJpJB2pJhVx7DNmSzQD76VYxxV3NsjJMc1cJf+ovmAkBDQ4czYNelj9ErasbOVOqjL3+IAxpAuP3kJu3Jfu0cEfX9aetUpa5Z3C2u07bSBHaqbLtB4/b0bdXQ9MloFTd3iyomRzs6URq6HjowKYYZCydZa8q//4Ylxq6I+DOqZym7jSvmA9DNvbSs7XnubvZ3t7ojCqlCfPGwNlQaM6KDuWJwwoyLAp8mi9utGF6L8lYD4zS9v82nvCVm/8GS0pIX0753CgkDnpSg9mV7TOd6xV6PVNpPSzbt895T1k2f8NhoWhpjAawbkJENyUhRswptwqvufVks9PvsBdyEOkFMzIsfvCJn8rXY4EZOrk1PZkg3ywO2t22muigsXWaSLekoMfEXV8rookxeqAxJWRGKPIVH2RwNJSuJMYfz4KZkfXJrN+QGTC2kfrxZ1v2htNIm++xnvsOcpDA8ycjgIVkQF1GZitEs/dtyyp/woysEP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199021)(2616005)(86362001)(83380400001)(66946007)(76116006)(66476007)(478600001)(66446008)(110136005)(36756003)(8676002)(316002)(8936002)(5660300002)(2906002)(4326008)(91956017)(54906003)(66556008)(64756008)(41300700001)(6506007)(6512007)(71200400001)(26005)(6486002)(38100700002)(82960400001)(186003)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0lKakZ3SEVrWXVHZm5vTXp1dVNSWEo5UDJMUEFDYmU4ZEg3TG52YklCMWcr?=
 =?utf-8?B?bW80QWczdmkrL1NSRUlGOEoxOFdOZDVNaVQyRDIwdmJhdW9GZnpVY0FlOU9D?=
 =?utf-8?B?enhtdXdtTmJ6NDVvQ1VWa3ZzNHJqNE5ZeVMxeEdWUGxQenl1MFNaUFlscUN6?=
 =?utf-8?B?UFQwUDJkQnROVFh1L3FhZVBtdmRIVHEzK0pxYTUycE9mM0crZUxXakwwaitZ?=
 =?utf-8?B?eDk0M0hhUHJtaEtVb1JNeU5pNE9aRUxxdlR1aGpIZUgrWnlXWEVKb0hnbWpJ?=
 =?utf-8?B?bHJ6TlYzQmxTTzc1MHU2dGI3eVJvL0trbDI3RWJwN3o5WlNZWS83cUFwMGVF?=
 =?utf-8?B?c2R3Y0R0QnBDUmJuczRnOWNDZS9oTGdHRWVtNm52UWx1VjRqeXB4UmtGNHJy?=
 =?utf-8?B?VzBHSUFvKzFSVEtxZ0ZDcmhjN0lqSlQ5ZGlLNnc1ckEzN1ZaRVNYZENPL1M2?=
 =?utf-8?B?WVlTRDZkTnpnRVZUK2VZV0R5RVUwZTlSR1Nqdlh4VWI0cDR3UWxlUThab040?=
 =?utf-8?B?VG52eitWL2grR2RhejkxTVdScDNrMTR5TC9zbjJaYnNXOERHNmxVNmwxdjFw?=
 =?utf-8?B?ZEliclM0RkZpaEtxM2hYb0F2bVNSN2cvdTB5NjFKVW9TWFBTME1pa0lzVFlq?=
 =?utf-8?B?SytySWRwUEtJV0duY1FTeFBqckxLWnVOYVByV3pGTTVQR1NJZ1VTcVpnUnFQ?=
 =?utf-8?B?SDE5cDdaTWRGdkFoUDlLcHdQcUJZSTYvd1dGbU9qMVRmQlFBK1lRbXVXMlI0?=
 =?utf-8?B?WkhDWnJITFYvYjBKeUJUL1QycEplbkQyVG5rM20wdXg2WmxkZ3A5V2hXdWNs?=
 =?utf-8?B?bTZDY2RjNDR6OHFXbENXOWloUWRHMzdLVzdYR1pldlZuNWkxT01xVzRPREpu?=
 =?utf-8?B?NjUrOS9RL0NENVlGRUN3NkI0Y0xhWnh3TnhRZHZ2NzAxYVV0RE9GbDVsS3cx?=
 =?utf-8?B?UklPVVBlRm1HTTBMOElzQXRlYTNyS2RMM3lzZVBuVC9OWEhISE1SZFl4UFVS?=
 =?utf-8?B?RndNdDAwMjhjcW9Sall1MFVOZkZxZ3hHQkVmczdVTUZkRWRJaWRTUUNZaGhH?=
 =?utf-8?B?d0NQYTVuSFZSamVXbXFoLzV3b1VnNzYyWE9GSWVqQTdLQXl5U2MzcG1Rc2w3?=
 =?utf-8?B?UFRKUWh6cmk1SjkvM2lyeFR6QU9ORk1jNVpjTnlJQXg1QzBtcHpHTlJCY0ps?=
 =?utf-8?B?amgxa2p0Z2ZGVDQ3Q25tNEFHTWYxU3FRVllnbnZyVEUvQ0xqT1U0Z0k2UWMz?=
 =?utf-8?B?WXVENW1kSU9xRGRnRnZZaGZwVG1wSkxJeHFha3craHVUa0FJb1l0RXhSRlZY?=
 =?utf-8?B?dEtmbW51VXdiUFRSUSt1bnZFM3U2ZUg3UEhxMFVEV013MWUxUzVaTVNqRUxi?=
 =?utf-8?B?VjlPUVppaFIzN0JFaXkxckFrYUFCcTYwRndTN2pjT2lQZ1F3cXhmdzBwOTFN?=
 =?utf-8?B?alNuUEV1WFpqNllmclZzRHdoa1lhM1R0d05RN2g1UHNwb2gxQ1BYOVcxRFlj?=
 =?utf-8?B?dUhZS0JjQVdhbDZSV1FoeGozSTJCUUJJR0FpZmlpQmRXbno3ZnYrRTdONnNj?=
 =?utf-8?B?WWJCZnA2cWRmUXZqUmRHb0wxYlQwUjhMb09DQ2FkazBDd0phM2dZQXlJVmMv?=
 =?utf-8?B?NTU4K2ZPNmdqVVl2NFlzQ2FrKy9EWk1vZVF5S0xuUC9tS1dYUjFLZHlnTnRu?=
 =?utf-8?B?OHpYbms2N1JVeGpKTUxxb25DSllObSs3WTBKbmxOS1RpWXZWd0paWHB6NEp2?=
 =?utf-8?B?QjErM0VLdmM0ME4weXdadldpUjh6TE9TdWdGdUU3Ukdua3hScnczMTFnNDVn?=
 =?utf-8?B?UkI1VnVOTWxQQmh6QTAzNjA5NTcrNEpYbHBKOHptSkNieWFKSDhOZ24zREdN?=
 =?utf-8?B?Lyt1RGZWSFZuL0x3QTZUbDduOGVRUlRxTk82SWNoMnBMTUVRWXllaXFQeUNQ?=
 =?utf-8?B?UkJveUNBVjVDTmM2L2NPSzBoT3pNYXpqUE5XOGxMTTJKdVBmQmloWGJiSkZD?=
 =?utf-8?B?VzNTclErYk9CSzlkVUl0dmFsRjIxUVZlNTQyV2VCcE1LY0pNV2hTSTd0SCtL?=
 =?utf-8?B?T0hzdzJ4cFB5VWtRVXA3WW1tVnVwZmdLWUlYT2RqMjgyTm1BOGJUaWxwUkg1?=
 =?utf-8?Q?knZy7mQv/b0TiT6BM4rqYdooq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A85E06457886143A23618BDD133721A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ace5607-4bed-4644-ebe1-08db52d55670
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 10:40:43.4269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0xEOsPMWtLCE6VQKqVR/Qxy/g1MtKAkOOFpHO+ylS74YT4i6D4jvI8bJzE9kbTgQ/n0PWybQMWfx1DkGhpe1lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4902
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

T24gVGh1LCAyMDIzLTA1LTExIGF0IDE2OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEcm9wIGhhbmRsaW5nIG9mIE1TUl9JQTMyX0NSX1BBVCBmcm9tIG10cnIuYyBub3cg
dGhhdCBTVk0gYW5kIFZNWCBoYW5kbGUNCj4gd3JpdGVzIHdpdGhvdXQgYm91bmNpbmcgdGhyb3Vn
aCBrdm1fc2V0X21zcl9jb21tb24oKS4gIFBBVCBpc24ndCB0cnVseSBhbg0KPiBNVFJSIGV2ZW4g
dGhvdWdoIGl0IGFmZmVjdHMgbWVtb3J5IHR5cGVzLCBhbmQgbW9yZSBpbXBvcnRhbnRseSBLVk0g
ZW5hYmxlcw0KPiBoYXJkd2FyZSB2aXJ0dWFsaXphdGlvbiBvZiBndWVzdCBQQVQgKGJ5IE5PVCBz
ZXR0aW5nICJpZ25vcmUgZ3Vlc3QgUEFUIikNCj4gd2hlbiBhIGd1ZXN0IGhhcyBub24tY29oZXJl
bnQgRE1BLCBpLmUuIEtWTSBkb2Vzbid0IG5lZWQgdG8gemFwIFNQVEVzIHdoZW4NCj4gdGhlIGd1
ZXN0IFBBVCBjaGFuZ2VzLg0KPiANCj4gVGhlIHJlYWQgcGF0aCBpcyBhbmQgYWx3YXlzIGhhcyBi
ZWVuIHRyaXZpYWwsIGkuZS4gYnVyeWluZyBpdCBpbiB0aGUgTVRSUg0KPiBjb2RlIGRvZXMgbW9y
ZSBoYXJtIHRoYW4gZ29vZC4NCj4gDQo+IFdBUk4gYW5kIGNvbnRpbnVlIGZvciB0aGUgUEFUIGNh
c2UgaW4ga3ZtX3NldF9tc3JfY29tbW9uKCksIGFzIHRoYXQgY29kZQ0KPiBpcyBfY3VycmVudGx5
XyByZWFjaGVkIGlmIGFuZCBvbmx5IGlmIEtWTSBpcyBidWdneS4gIERlZmVyIGNsZWFuaW5nIHVw
IHRoZQ0KPiBsYWNrIG9mIHN5bW1ldHJ5IGJldHdlZW4gdGhlIHJlYWQgYW5kIHdyaXRlIHBhdGhz
IHRvIGEgZnV0dXJlIHBhdGNoLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhl
cnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQoNCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbXRyci5jIHwgMTkgKysr
KysrLS0tLS0tLS0tLS0tLQ0KPiAgYXJjaC94ODYva3ZtL3g4Ni5jICB8IDEzICsrKysrKysrKysr
KysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL210cnIuYyBiL2FyY2gveDg2L2t2bS9t
dHJyLmMNCj4gaW5kZXggZGMyMTNiOTQwMTQxLi5jZGJiYjUxMWY5NDAgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2t2bS9tdHJyLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL210cnIuYw0KPiBAQCAt
NTUsNyArNTUsNiBAQCBzdGF0aWMgYm9vbCBtc3JfbXRycl92YWxpZCh1bnNpZ25lZCBtc3IpDQo+
ICAJY2FzZSBNU1JfTVRSUmZpeDRLX0YwMDAwOg0KPiAgCWNhc2UgTVNSX01UUlJmaXg0S19GODAw
MDoNCj4gIAljYXNlIE1TUl9NVFJSZGVmVHlwZToNCj4gLQljYXNlIE1TUl9JQTMyX0NSX1BBVDoN
Cj4gIAkJcmV0dXJuIHRydWU7DQo+ICAJfQ0KPiAgCXJldHVybiBmYWxzZTsNCj4gQEAgLTc0LDkg
KzczLDcgQEAgYm9vbCBrdm1fbXRycl92YWxpZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiBt
c3IsIHU2NCBkYXRhKQ0KPiAgCWlmICghbXNyX210cnJfdmFsaWQobXNyKSkNCj4gIAkJcmV0dXJu
IGZhbHNlOw0KPiAgDQo+IC0JaWYgKG1zciA9PSBNU1JfSUEzMl9DUl9QQVQpIHsNCj4gLQkJcmV0
dXJuIGt2bV9wYXRfdmFsaWQoZGF0YSk7DQo+IC0JfSBlbHNlIGlmIChtc3IgPT0gTVNSX01UUlJk
ZWZUeXBlKSB7DQo+ICsJaWYgKG1zciA9PSBNU1JfTVRSUmRlZlR5cGUpIHsNCj4gIAkJaWYgKGRh
dGEgJiB+MHhjZmYpDQo+ICAJCQlyZXR1cm4gZmFsc2U7DQo+ICAJCXJldHVybiB2YWxpZF9tdHJy
X3R5cGUoZGF0YSAmIDB4ZmYpOw0KPiBAQCAtMzI0LDggKzMyMSw3IEBAIHN0YXRpYyB2b2lkIHVw
ZGF0ZV9tdHJyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIG1zcikNCj4gIAlzdHJ1Y3Qga3Zt
X210cnIgKm10cnJfc3RhdGUgPSAmdmNwdS0+YXJjaC5tdHJyX3N0YXRlOw0KPiAgCWdmbl90IHN0
YXJ0LCBlbmQ7DQo+ICANCj4gLQlpZiAobXNyID09IE1TUl9JQTMyX0NSX1BBVCB8fCAhdGRwX2Vu
YWJsZWQgfHwNCj4gLQkgICAgICAha3ZtX2FyY2hfaGFzX25vbmNvaGVyZW50X2RtYSh2Y3B1LT5r
dm0pKQ0KPiArCWlmICghdGRwX2VuYWJsZWQgfHwgIWt2bV9hcmNoX2hhc19ub25jb2hlcmVudF9k
bWEodmNwdS0+a3ZtKSkNCj4gIAkJcmV0dXJuOw0KPiAgDQo+ICAJaWYgKCFtdHJyX2lzX2VuYWJs
ZWQobXRycl9zdGF0ZSkgJiYgbXNyICE9IE1TUl9NVFJSZGVmVHlwZSkNCj4gQEAgLTM5Miw4ICsz
ODgsNiBAQCBpbnQga3ZtX210cnJfc2V0X21zcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiBt
c3IsIHU2NCBkYXRhKQ0KPiAgCQkqKHU2NCAqKSZ2Y3B1LT5hcmNoLm10cnJfc3RhdGUuZml4ZWRf
cmFuZ2VzW2luZGV4XSA9IGRhdGE7DQo+ICAJZWxzZSBpZiAobXNyID09IE1TUl9NVFJSZGVmVHlw
ZSkNCj4gIAkJdmNwdS0+YXJjaC5tdHJyX3N0YXRlLmRlZnR5cGUgPSBkYXRhOw0KPiAtCWVsc2Ug
aWYgKG1zciA9PSBNU1JfSUEzMl9DUl9QQVQpDQo+IC0JCXZjcHUtPmFyY2gucGF0ID0gZGF0YTsN
Cj4gIAllbHNlDQo+ICAJCXNldF92YXJfbXRycl9tc3IodmNwdSwgbXNyLCBkYXRhKTsNCj4gIA0K
PiBAQCAtNDIxLDEzICs0MTUsMTIgQEAgaW50IGt2bV9tdHJyX2dldF9tc3Ioc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LCB1MzIgbXNyLCB1NjQgKnBkYXRhKQ0KPiAgCQlyZXR1cm4gMTsNCj4gIA0KPiAg
CWluZGV4ID0gZml4ZWRfbXNyX3RvX3JhbmdlX2luZGV4KG1zcik7DQo+IC0JaWYgKGluZGV4ID49
IDApDQo+ICsJaWYgKGluZGV4ID49IDApIHsNCj4gIAkJKnBkYXRhID0gKih1NjQgKikmdmNwdS0+
YXJjaC5tdHJyX3N0YXRlLmZpeGVkX3Jhbmdlc1tpbmRleF07DQo+IC0JZWxzZSBpZiAobXNyID09
IE1TUl9NVFJSZGVmVHlwZSkNCj4gKwl9IGVsc2UgaWYgKG1zciA9PSBNU1JfTVRSUmRlZlR5cGUp
IHsNCj4gIAkJKnBkYXRhID0gdmNwdS0+YXJjaC5tdHJyX3N0YXRlLmRlZnR5cGU7DQo+IC0JZWxz
ZSBpZiAobXNyID09IE1TUl9JQTMyX0NSX1BBVCkNCj4gLQkJKnBkYXRhID0gdmNwdS0+YXJjaC5w
YXQ7DQo+IC0JZWxzZSB7CS8qIFZhcmlhYmxlIE1UUlJzICovDQo+ICsJfSBlbHNlIHsNCj4gKwkJ
LyogVmFyaWFibGUgTVRSUnMgKi8NCj4gIAkJaWYgKGlzX210cnJfYmFzZV9tc3IobXNyKSkNCj4g
IAkJCSpwZGF0YSA9IHZhcl9tdHJyX21zcl90b19yYW5nZSh2Y3B1LCBtc3IpLT5iYXNlOw0KPiAg
CQllbHNlDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0v
eDg2LmMNCj4gaW5kZXggOGIzNTZjOWQ4YTgxLi5kNzFjZjkyNGNkOGYgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2t2bS94ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gQEAgLTM3
MDEsNiArMzcwMSwxNyBAQCBpbnQga3ZtX3NldF9tc3JfY29tbW9uKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykNCj4gIAkJfQ0KPiAgCQlicmVhazsNCj4g
IAljYXNlIE1TUl9JQTMyX0NSX1BBVDoNCj4gKwkJLyoNCj4gKwkJICogV3JpdGVzIHRvIFBBVCBz
aG91bGQgYmUgaGFuZGxlZCBieSB2ZW5kb3IgY29kZSBhcyBib3RoIFNWTQ0KPiArCQkgKiBhbmQg
Vk1YIHRyYWNrIHRoZSBndWVzdCdzIFBBVCBpbiB0aGUgVk1DQi9WTUNTLg0KPiArCQkgKi8NCj4g
KwkJV0FSTl9PTl9PTkNFKDEpOw0KPiArDQo+ICsJCWlmICgha3ZtX3BhdF92YWxpZChkYXRhKSkN
Cj4gKwkJCXJldHVybiAxOw0KPiArDQo+ICsJCXZjcHUtPmFyY2gucGF0ID0gZGF0YTsNCj4gKwkJ
YnJlYWs7DQo+ICAJY2FzZSBNVFJScGh5c0Jhc2VfTVNSKDApIC4uLiBNU1JfTVRSUmZpeDRLX0Y4
MDAwOg0KPiAgCWNhc2UgTVNSX01UUlJkZWZUeXBlOg0KPiAgCQlyZXR1cm4ga3ZtX210cnJfc2V0
X21zcih2Y3B1LCBtc3IsIGRhdGEpOw0KPiBAQCAtNDExMCw2ICs0MTIxLDggQEAgaW50IGt2bV9n
ZXRfbXNyX2NvbW1vbihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBtc3JfZGF0YSAqbXNy
X2luZm8pDQo+ICAJCWJyZWFrOw0KPiAgCX0NCj4gIAljYXNlIE1TUl9JQTMyX0NSX1BBVDoNCj4g
KwkJbXNyX2luZm8tPmRhdGEgPSB2Y3B1LT5hcmNoLnBhdDsNCj4gKwkJYnJlYWs7DQo+ICAJY2Fz
ZSBNU1JfTVRSUmNhcDoNCj4gIAljYXNlIE1UUlJwaHlzQmFzZV9NU1IoMCkgLi4uIE1TUl9NVFJS
Zml4NEtfRjgwMDA6DQo+ICAJY2FzZSBNU1JfTVRSUmRlZlR5cGU6DQo+IC0tIA0KPiAyLjQwLjEu
NjA2LmdhNGIxYjEyOGQ2LWdvb2cNCj4gDQoNCg==
