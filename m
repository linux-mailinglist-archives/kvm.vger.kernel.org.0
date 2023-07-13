Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2257751B30
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbjGMIOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjGMINC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:13:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3473AA7;
        Thu, 13 Jul 2023 01:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689235804; x=1720771804;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Jufeu99JTlDhpTtqJ4ApWiU2y1DyVS/MvkWgjAWsPMw=;
  b=EmchQMRRnHdd4hQhtWHRQpkNsm1wMUd/8oDQiZEWpii1SuzT5hfEn1u6
   2tio8Btwo7IbE1O9vDuMAruClT2XWn+sLBHCb2nJdznGtnPu5nPEkplnT
   2ed7QYdVocrjwZslgpnJn1Ra5DuGA52LYs/aw9cXxNpBJSK807PAerBhu
   mqTi0thr7AKJJEWTsKrLZMhJdsa80RHNYl+vVywCOUCwbOxZoUNQVRJXV
   cpJ/nGiGSE+sH8qgaKKwaeELaEOuJ6d2oeK15SjZfAix08UYprZKKrBaB
   rLLHrk57hf0OqRVTNwsOg+FnetPstI5hf8g1Mjoc7N24LYozGyGdnucN7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="368656203"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="368656203"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 01:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="725212093"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="725212093"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2023 01:10:02 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 01:10:01 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 01:10:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 01:10:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 01:09:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAzGP8aj5KcEPUp7/lD9qE4spnCLygjjjuMSCbNP7mTjNknqShsZEbPFmO2/D5/tL8FkQKMzuy686G4KbBM+puUg64ZfZ2yiM/PKn/ayfqgY5Ylao9nddoAUMlWg6KIAGSHkK4SVHiRSo/jN5laFgEgJ1DeK9qHllqSJ4GvQ+zdQYSuaPABtXQNSNXt51bhwFwVqReYZNfgbL2vbCP90cC/AioZUirwvjaYpbFoBF4O3ZPtewRPhZBTrO7caYPkd1oY1iZTc6N4LS8MxWTuRoMenYw+DrsfibSj91dZQ2/I02RBgnfGJ353POtNszp0CEpe6n0vW4gxvs/mUEiWbOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jufeu99JTlDhpTtqJ4ApWiU2y1DyVS/MvkWgjAWsPMw=;
 b=Wipq1ap++BK1g2TFZHfDYcghIuVyGYBuKl9vJevOQ7w4JrAdDZbM+eO7y/Q3SUn/5jK3J0penbM/7Qr9WT9uvyGo+dDnqVn/cjHhEx+o9vSu9uKKGosNLuESjTSWZ4h/NTgoyFwMuCk0kROJVAgXB+wMPda0wIGHsRxl88Xmh3LsVFDKyJhxOgbetRWpiDwPs3eY38P4e153kN1IKeA9ZCBI22r4JgwoYmvjJKqlzkWwMKVmZPhrg82uzzSXcaGVqStS7NxRal5IxHnSbWVmu+nXx7A4CgmnLbYIaSdO2xuFKd6/U2QopZxhC8aaPzk9oz7b0VhcTPS+IxQRCZ1ORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB8353.namprd11.prod.outlook.com (2603:10b6:208:489::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 08:09:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 08:09:34 +0000
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
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2XpWAgAD65IA=
Date:   Thu, 13 Jul 2023 08:09:33 +0000
Message-ID: <a36d1f0068154a9acd3fdbed2586dc5b2476e140.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712171133.GB3115257@hirez.programming.kicks-ass.net>
In-Reply-To: <20230712171133.GB3115257@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB8353:EE_
x-ms-office365-filtering-correlation-id: 4074df99-cb32-4e71-22d9-08db83787e39
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WZPA2PY7QWjOEyUh5Anplr7g1u5KHG9PCdwuiMdZ9GoKQFWANETi8eDVLSElZRQEgTUy3WqS2SdQL+Hk2FXFsG9QnUAySXeT9Da317HZlrlcVcO6aMkpOcUTLIHeQ/0O2ZzWrxfmZCJmBQWYHJdvDW422zKCMZ5jw0hqEzI4FJTbz4SdaSQBEpKT1cXfdRotY7zUFOFFDiJcctYoTou8LcxGBNm4WdGVzk697zTvmGzNpKv5ulztATELKmaEDvKnl/GPMwsQxzoXcNQhVIVK4oXdsWAdOcNxYswVc9PD0aBUx38FvyKRv80UokcLPPdRvqVw1kmK8z7NLq0s8NzDlnvxZkGYD5w8iKvlP+MxKuYXloofh3fkh1pt9k8z0krsaUWxrstJ99hl+s+LpHmP7NHzNnURgLuhW3tSdugF4qHn8qw13AZtYWVI8vObtWXSI1j57sjh3F5ajg//VhOv6ktScrRY/aGJIlaVPgMvwrD1/Apo+s7EEjglPbwQJS/iqdc6Q1ObOTbBSEgFtvEhZR7Gvtfglllg86WBeRDoE5LWHSRUm8l+QikZ3e2L0ncG286s9C2VNa1QynOu/oIuINIlpLE4YNGhK7mzB9grqigtoIWkOfVbm7JNMtwD7YaT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199021)(54906003)(76116006)(6486002)(478600001)(91956017)(71200400001)(186003)(6506007)(6512007)(2906002)(66946007)(5660300002)(316002)(4326008)(66476007)(8936002)(66446008)(7416002)(66556008)(41300700001)(6916009)(64756008)(82960400001)(26005)(38100700002)(8676002)(122000001)(38070700005)(83380400001)(36756003)(2616005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1hlRkM2dzVOVEUwWWxGbnRaelo3WlJ5ekhEV3BpQ2tTUTZHS2hLYVgzSzh3?=
 =?utf-8?B?WWtPVWNXQk1rWE5MTnFTNGZIVHhrWFhmMUNZbHc3NEJrKzVPc0NXekNvejBu?=
 =?utf-8?B?SzUvcjJxKzNoZXZQVFdESTY4TFllb293MGF5K0hWeEwxbzNMeHhYVktlRGR0?=
 =?utf-8?B?R0wzZWJoTjZqSTN2SEZwQ3VmLytBeThtTlUwbjQ1YUpoYmtoZ1IzWnhlQ0Nn?=
 =?utf-8?B?WUE3Z1U5eFByWTM0NEZ5ZG9IREtRZXdWa2hzL0o0Zm9ES05UUE9xSC93YnpO?=
 =?utf-8?B?V3N1Ny9WaHRVbzQ3Q1JZTUVtV3M2MmdNU0xXWG5IM2s2ZjVZWlFaQ3EyTi9u?=
 =?utf-8?B?dE9CTmlKa3ViWWV4blZCa1l2QlBmSnVKTFpuK0FDbzd1K0VpamdKZWJSOGtP?=
 =?utf-8?B?eEh4MzlROVZudldIdjVZekxPMHZSeFh6WUZzdDhYSTQ5eitJWHlHYXpDd3Ix?=
 =?utf-8?B?bERjMFlLWlFzR043aUpoWUZqWk9CNjdHbC9OVVdGd3drRThQcXNkbVFDWnMw?=
 =?utf-8?B?KzFpZ3dyOWl3RlJNVXo5aEY4eVkwYWVKcUMyY1MvTEs2SlhlU0t3L0d2ZzRJ?=
 =?utf-8?B?eTR0S3ZFamVwWVhjVkpkeGdUWGZCeW91NktnTEFobTFyNEgzMlhISkk5VThV?=
 =?utf-8?B?WWZkVkhuemhyWDJBUmhaKzRkTXl1UlNjaDZYMUF6VXhxMkcyR2FCT2JhNml1?=
 =?utf-8?B?WnpIL1MzRG5sTVozQkFNK3luV2ZaSnRaNVRmQnR0a0p2ZUxybU82NGxMOU1U?=
 =?utf-8?B?TXhSNU1QUXhBeTR5cFMxeEdYaEp2NUIxL01LejRjRUNyV2tvWk9hZHcyTkpI?=
 =?utf-8?B?bEdJZXAvUmUvbVVhemV3VGlQN0dGK0haMDRwczEraytTRFhiejNkckljdS82?=
 =?utf-8?B?cmxSdnYrMmVvRGU0Y0poRFZlaTRidGRGQ3lhUUI0UG5VT1IrdnhaaXZlQXh3?=
 =?utf-8?B?TnBlb2ZDS3E2ZmpXamQ4OS9ja25TQjI0ai93Y3BlSlcxcXBRaXhZKzQzMnc4?=
 =?utf-8?B?WVFvbUREOXhOZlRjZ3dOMkhSbW9lVHlQYnJZVlZ5Q2N1Y2lZRTlSNHF6ZXor?=
 =?utf-8?B?dmJuLzBxcVJ3blZyVWp6eGdML1pZK1JUSnZZd0t0YUxXVEZPT1V6enBQQ0ZS?=
 =?utf-8?B?SXE2UWxZVHJhSC9NeC9kWlpqcE5vUUE5WFhoT1B6T3B0K2ttYWVVSklzWGFT?=
 =?utf-8?B?bzNDUDdmaTV2bkFYWUppRE4rc0kyaW5DelhaZ0FBaFRubHk4Um15NkR3enVZ?=
 =?utf-8?B?WlN0eWpmY2xqSjBjK1hOcTZxY2E3Z2JNYk5SZW9mOVZDR05Jb2M3Sk1hZnRP?=
 =?utf-8?B?VS9OWTF1eStUenp6ZjlzZTI2VGlhZ0dzY09mQnQxUlVicUthQ3ZOOWUrd3R5?=
 =?utf-8?B?aldDR1NXN1ZFM2NmeVVISTZhRjFuRTJyQitnYXZ4ekxaY1JBVnY0RjhoUUNP?=
 =?utf-8?B?ZFN4dU9RdWljUkprT0o3UGV0dEF4Ymg2anNhdUUxZElLN2U3dURpY3U4dUNM?=
 =?utf-8?B?WmFYczZwQUF6N2pHN0RzakxMZGJkQUpzekJza2hEejRVS0dOM25paFpUcDhU?=
 =?utf-8?B?akNmM1IxTG05TlliNTd4SXpON0VoUytIQzNmVko1bnlnMnJUR2RYbkVRN2dM?=
 =?utf-8?B?YlJYNDQrWElxeExmVXMzc0FvV01FaG1SYVJJQ0JocEVaR3Q4aGFXK3BrTUpL?=
 =?utf-8?B?RUdmdmt2dmJpdncrZkwrcXBIL3hBUHpyakJyWWlQRUc5aUNId0hZNlozTWNy?=
 =?utf-8?B?THVENzBMSFVxU3RZd1MrMGw5NmNZOEJRajN2ZnB6ZGZ2QzF3ZjU1QXhDb2ho?=
 =?utf-8?B?UHFNelBmWnA2ZnpSQlhOakh3bXB1cWEwMzBpaHFaRlBxS016SFdZKzB4cDhH?=
 =?utf-8?B?YkN3UzdYUFA5RVprT0JudnFyY0k0amQyOXRxdGx6b3k3V2JncEh0bDNtK0t4?=
 =?utf-8?B?a04wVFpWRGMzcmZNK1ZFTFpyRUJ4RTBFWEZKZXQwVjlaM0wvVGgwVENoT0lj?=
 =?utf-8?B?Y1pMT1dhdjFPcU43R1NyaytYTWxvbVpnazE5aXNDRDgrdkFsZFFFRExuMkl4?=
 =?utf-8?B?Wlk3VkNaNWl3VFgrcDFpKzNaS1BMNjBkQjJ0Y0ppWngvZWpYQnBnL0U4ZEM1?=
 =?utf-8?B?dDFHb0RpUlpvRUx0NVYwVXVhd0pjZkkyZWVGeCtsUXJ1U0E0b2hSeEtVWnVY?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <286E8F47FF5DAB43BFAC07A3C28BC6F0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4074df99-cb32-4e71-22d9-08db83787e39
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 08:09:33.9926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbFK4Kh+Vb/PwQl6FJhLhD6npG0NRHyu0eBN3J1C4RpSSWJfRbeL7VVTqnbbVxUSCqIN7TdvGN/YeNTF6LNCpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8353
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

T24gV2VkLCAyMDIzLTA3LTEyIGF0IDE5OjExICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdWwgMTIsIDIwMjMgYXQgMDg6NTU6MjFQTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiA+IEBAIC02NSw2ICsxMDQsMzcgQEANCj4gPiAgCS5lbmRpZg0KPiA+ICANCj4gPiAg
CS5pZiBccmV0DQo+ID4gKwkuaWYgXHNhdmVkDQo+ID4gKwkvKg0KPiA+ICsJICogUmVzdG9yZSB0
aGUgc3RydWN0dXJlIGZyb20gc3RhY2sgdG8gc2F2ZWQgdGhlIG91dHB1dCByZWdpc3RlcnMNCj4g
PiArCSAqDQo+ID4gKwkgKiBJbiBjYXNlIG9mIFZQLkVOVEVSIHJldHVybnMgZHVlIHRvIFREVk1D
QUxMLCBhbGwgcmVnaXN0ZXJzIGFyZQ0KPiA+ICsJICogdmFsaWQgdGh1cyBubyByZWdpc3RlciBj
YW4gYmUgdXNlZCBhcyBzcGFyZSB0byByZXN0b3JlIHRoZQ0KPiA+ICsJICogc3RydWN0dXJlIGZy
b20gdGhlIHN0YWNrIChzZWUgIlRESC5WUC5FTlRFUiBPdXRwdXQgT3BlcmFuZHMNCj4gPiArCSAq
IERlZmluaXRpb24gb24gVERDQUxMKFRERy5WUC5WTUNBTEwpIEZvbGxvd2luZyBhIFREIEVudHJ5
IikuDQo+ID4gKwkgKiBGb3IgdGhpcyBjYXNlLCBuZWVkIHRvIG1ha2Ugb25lIHJlZ2lzdGVyIGFz
IHNwYXJlIGJ5IHNhdmluZyBpdA0KPiA+ICsJICogdG8gdGhlIHN0YWNrIGFuZCB0aGVuIG1hbnVh
bGx5IGxvYWQgdGhlIHN0cnVjdHVyZSBwb2ludGVyIHRvDQo+ID4gKwkgKiB0aGUgc3BhcmUgcmVn
aXN0ZXIuDQo+ID4gKwkgKg0KPiA+ICsJICogTm90ZSBmb3Igb3RoZXIgVERDQUxMcy9TRUFNQ0FM
THMgdGhlcmUgYXJlIHNwYXJlIHJlZ2lzdGVycw0KPiA+ICsJICogdGh1cyBubyBuZWVkIGZvciBz
dWNoIGhhY2sgYnV0IGp1c3QgdXNlIHRoaXMgZm9yIGFsbCBmb3Igbm93Lg0KPiA+ICsJICovDQo+
ID4gKwlwdXNocQklcmF4CQkvKiBzYXZlIHRoZSBURENBTEwvU0VBTUNBTEwgcmV0dXJuIGNvZGUg
Ki8NCj4gPiArCW1vdnEJOCglcnNwKSwgJXJheAkvKiByZXN0b3JlIHRoZSBzdHJ1Y3R1cmUgcG9p
bnRlciAqLw0KPiA+ICsJbW92cQklcnNpLCBURFhfTU9EVUxFX3JzaSglcmF4KQkvKiBzYXZlICVy
c2kgKi8NCj4gPiArCW1vdnEJJXJheCwgJXJzaQkvKiB1c2UgJXJzaSBhcyBzdHJ1Y3R1cmUgcG9p
bnRlciAqLw0KPiA+ICsJcG9wcQklcmF4CQkvKiByZXN0b3JlIHRoZSByZXR1cm4gY29kZSAqLw0K
PiA+ICsJcG9wcQklcnNpCQkvKiBwb3AgdGhlIHN0cnVjdHVyZSBwb2ludGVyICovDQo+IA0KPiBV
cmdnaGguLi4gQXQgbGVhc3QgZm9yIHRoZSBcaG9zdCBjYXNlIHlvdSBjYW4gc2ltcGx5IHBvcCAl
cnNpLCBubz8NCj4gVlAuRU5URVIgcmV0dXJucyB3aXRoIDAgdGhlcmUgSUlSQy4NCg0KTm8gVlAu
RU5URVIgZG9lc24ndCByZXR1cm4gMCBmb3IgUkFYLiAgRmlyc3RseSwgVlAuRU5URVIgY2FuIHJl
dHVybiBmb3IgbWFueQ0KcmVhc29ucyBidXQgbm90IGxpbWl0ZWQgdG8gVERWTUNBTEwgKGUuZy4s
IGR1ZSB0byBpbnRlcnJ1cHQpLCBhbmQgZm9yIHRob3NlDQpjYXNlcyBSQVggY29udGFpbnMgdmFs
aWQgbm9uLXplcm8gdmFsdWUuICBTZWNvbmRseSwgZXZlbiBmb3IgVERWTUNBTEwsIHRoZSBSQVgN
Cmlzbid0IDA6DQoNClRhYmxlIDYuMjU2IFREWCAxLjUgQUJJIHNwZWM6DQoNClJBWAlTRUFNQ0FM
TCBpbnN0cnVjdGlvbiByZXR1cm4gY29kZQ0KCVRoZSBERVRBSUxTX0wyIGZpZWxkIGluIGJpdHMg
MzE6MCBjb250YWluIHRoZSBWTUNTIGV4aXQgcmVhc29uLMKgDQoJaW5kaWNhdGluZyBURENBTEwg
KDc3KS4NCg0K
