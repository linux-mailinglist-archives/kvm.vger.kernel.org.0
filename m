Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08B4751D57
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjGMJel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjGMJei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:34:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549A71FC7;
        Thu, 13 Jul 2023 02:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689240877; x=1720776877;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kLzEjpyquqMNKeDpuhitWtSjXWIkMe7Suda58JuH0yc=;
  b=D8aJ+bBPXa1kE8+ZTcUWANRUlopI8xgzXHH7OBWtA57y1FvhMTVFtWad
   2MLe9J4ihhDdVkrUJP+f3w6z+s1qwIF4ERiNbGi06boKW4NZoCvcroAzY
   cx/nbZ4efEsLkX3WPZcJOtm0Wnq1dIOcX6kitUSHoRjZlTT4MZWNKkf/j
   d50/0s29XmJAfYBzbiWDOOajzLSVf7K4U0nT89duP81s5JOcH4YZwLLT3
   AGuKTfp4F0Q86lOLuUc8IYwzRnwuvwyOUTmxpBk1LtqCL+9DOckgpXsBd
   P6hnJTi6bSGlhK2f3MNtK/GgZvwGrec37zSLw8VYYhlfzws5YOrVleBVn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="431291858"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="431291858"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 02:34:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="751553119"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="751553119"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 13 Jul 2023 02:34:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 02:34:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 02:34:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 02:34:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 02:34:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtquCo+I9Ti5xAw2q8R3GKOAAeLABu5l8NArUs1D5XGpSM2VLkjrXDodDs7+iKlKjpTXSSKGUJAs1gfB/zd4/cWSD7tw7LLv9Lu0rmZUVzpk8pL8CZulTVtBbSScNgh64u58v4eXMQOe8e7ydadHDYr6qgresOisWkte9uAMe1uuzfG5aGuv0OAntCysyyTGJDzyM570Ip3aCJYBx3y/lkR3trYhX+nYTWXoqe7GAa61i7oQkQpIz7NVYTOxlp82FPy/n3YQBkW1CM9gDbse8heywVhvmjACIpJ4p+mmPR5siQe7xeIEHYHe1cIDnRk+QP0XM+sOuTtshBEAJ/RaDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLzEjpyquqMNKeDpuhitWtSjXWIkMe7Suda58JuH0yc=;
 b=hAnyOZY2eVTwVry2IsQxBQPAsqAD+dJew1uyADKq47T1XtAnETCb3cpeozmWSEI8xNEjDPZftCVgBixRhzCFFwiYk1jN1LXHlF1fE5QyLAMdG9NzYaAhWKJtZYXuegwDvFEpzMOSMobNQqIjQmUIcGCGP0rvFlB/SXsiIlVfm1Pwo80cWB1b/hKbBVtX+wD1aEaCoXATr8KS9C/bXhRPk33qgVWCyZ8BumiP8kqJrT4Q6pzg6VAjhM0M7dVZL0lhnEWmphwHZsjlQ5XkehKdlqLtVDEWYlKzOH6UgSUAd32u3EoCm1EwkyUF3jGxLGWCD/YcV1gX6/p2WsWeZx9zsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7938.namprd11.prod.outlook.com (2603:10b6:610:12f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 09:34:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 09:34:24 +0000
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
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2WZEAgAD5+gCAABBPAIAADVEA
Date:   Thu, 13 Jul 2023 09:34:24 +0000
Message-ID: <c0861d54af50ef01983703cc24e41118867342b8.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
         <6489a835da0d21c7637d071b7ef40ae1cda87237.camel@intel.com>
         <20230713084640.GB3138667@hirez.programming.kicks-ass.net>
In-Reply-To: <20230713084640.GB3138667@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7938:EE_
x-ms-office365-filtering-correlation-id: f6f21044-7f94-4a40-f51a-08db83845843
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XBqlvpT3eWrPcNimg7+2HoqxuGcS9l/4GTe86jbwICNcwOvhi19ziJrJ+airwdq4Lztxlyqtz1RnRgbxulBRmvODhYU3HgBijYbCL2y/X1HPRR2f0Bb4ggEUjz1Of+fNYyKraOmWs7qkK5WRKRIpy5/kxDXdfjy1S2nhbwTzyJb9WBE9o47rKYktXkeP0Wnu0+fRs443qbCpJZPgpOHvkCiKk19NF30jKw1qncwFmSkiQRBG3Rqub6o8VL69Boa0Xq/NuViPsdXxRZjzQbbgoL/mncBkkZUHIvZrHQWTNrmoynSlCorXXvjPAi8Eskf/UDt//Fii+EZ5ONplQlVOEyVIJ3XzSXsPXTMoIpQiEZoNjGEvYIFxM+UvYL0frFaYQgQHwrXdoShB0HsA1gkrs6ej9Eex3IF+s8BxbRicXDcch5kGsD9en6xUpefIxfcUN0rce3BZGgjN7BADLg5EO2fXxCBGyfyDZiPzLiFwQbeCFYVazUccXULA3WyjvKoLEl08zdu0YZB7keRnFLAJtN8y8RSCd4QiDlAM/Xm9UzJQN2yKHGrR8F5BURm8wL6mQrkpHqZEuc5M5R0p9/jCbaP47wwR4WrTiJtEbwAoj8rjZ7t+xSsW6gGVGHchxoRJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(451199021)(6486002)(82960400001)(186003)(122000001)(54906003)(86362001)(71200400001)(2616005)(508600001)(4744005)(26005)(6506007)(7416002)(38070700005)(316002)(8936002)(8676002)(36756003)(5660300002)(83380400001)(6512007)(64756008)(6916009)(66556008)(66946007)(66476007)(66446008)(4326008)(38100700002)(2906002)(91956017)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHUya21lSDUwbjd5TU1lL1IwSGN0VXlNK1p4bTlwMXVyR0pqY0szOFZrazRN?=
 =?utf-8?B?amxiMFl4WHM3cVR6SmtzTmNhWXlFcDlWdWZidjAzNUkzUG1UOWF6UTdQMFUx?=
 =?utf-8?B?YldMLzNqcmVldWRVdlZuZWtPTDhxZnlGeUlEYmhEOEtsMFRFWFJLd1VGdnlE?=
 =?utf-8?B?SGx5cXNwZHZxWHFMWE1pSHY4V3p5bmpRREgrUXIxd1hobEN3L3Z4SkF1RVZl?=
 =?utf-8?B?ZzNxQllnZUlyVGdXU3lFS0lNd0czUTIvNTVPdlJPangrYitIa0ZjQXJEZHVi?=
 =?utf-8?B?WmpmV3lkdmdGNHdFaVU4RlpGVGYveE12VTZQOW5WTnFvZXp4QW1wNG5sZ2xj?=
 =?utf-8?B?MnVzZ0lOQ0RxQXdmSENtVVJPWEJ2d2RlNHg2TmM0UllYVGRZRmwyWjFmeVlx?=
 =?utf-8?B?ZUdCclI4VGMwclVXcnNXWVpwdzR3MlNMNCtHeFpoT0NWenFPYVJBMGlUTTNl?=
 =?utf-8?B?Vm90UXhVblhwUFB5THZlaldyL2ZXQzhoMFJNRUhuUEhOTzh6ZkRxRm5Xc1lH?=
 =?utf-8?B?N0lUZkwrMEgrMWlmQkpoNm5acXFWbStYL3ZkSWNzOEgyeWpwOTVqaGpBOVpG?=
 =?utf-8?B?N1JFeWRCbm5LTnFyUTJuSnZPakZQR3lUanRaVXBNd2l5ZncxNUtFZXpzNS9t?=
 =?utf-8?B?R3ZCS1o5YkVPcXRYalZXaEM5T0VHYTNNK3RPVFJrcG41dFptN3VNa2d4dVpJ?=
 =?utf-8?B?dXg1RjFleXRRb1BTMzVlbVlicWdIc2dPem9HSzlIbHJWOUw1L1VKUVR4UzZC?=
 =?utf-8?B?bGR5SERyM2VzWXl3NkhTMitZUDNyUHJMcjFzSWh2RHh4T1A5VW5XeG9Rdzk1?=
 =?utf-8?B?R3Z2V0ErcDFRcHQwRW04Njc5TTR5S0s5NCt1SnNBUXAwN1VrQ1RxRkFGdGtq?=
 =?utf-8?B?S295RlgxOGJRMWdaT2dDdmE5OU9Bd3lEQ01zbXZNREFrQzFCbnNCWHc2b2Iw?=
 =?utf-8?B?aytvamVQTGwyVUtMMzh5NW9VcUdjOVV1Smh4QzJCVHFNUnE4UnZ2SUgwVEhV?=
 =?utf-8?B?bFFGVlA1U3VadzUxMklvU1pvSWVySlEveWNVL053S0xsNGJBMGhacHY3ZGU0?=
 =?utf-8?B?SFd5TGZCOGlZbkJlZUhnWDRlV0NYc1FjejJJeHZ2MlVpdjlkMGZhSG50d1RC?=
 =?utf-8?B?ZEU1REJ2aVJxTEZQbDdSOGVmNzVPZUppVjl4Zm44cVorK1lMZjZWU1dwS29V?=
 =?utf-8?B?a210ZktHenpRblgyZWVNT3lpcWJiZjFRaFJJUmxra3JQMjR2ay85UTFRanF3?=
 =?utf-8?B?QXYrQTBGOXo5TE5yTVFWOGNUbDNWc2ljRU92dkRRSUlOWEw0OEozSHJMb3g1?=
 =?utf-8?B?dE94SjREeWlDMEJoNnBic1U0NjliNkxJZ2RkVzFnTXg2dnlQeVpwem9kVWts?=
 =?utf-8?B?Z3lyRUVud1ZzNjFiMkVqMGRWVmtJNEV2ZXpuUDNSeWJIb1d2ZzZQM3hVcmV5?=
 =?utf-8?B?akxQeEZ2clh2eUY5TUoyUUpSSy9pWHRSdVQ0N21vek1mVjQwV204SG13M1pB?=
 =?utf-8?B?RDYrZ1d0bEFBd3p0aEVzVE1LQjNKOU9Vb09LNUVaQkVuZ0EwQ2FRY21DanB1?=
 =?utf-8?B?MGx5MlpmblVGT0k4aklBdlhReVVQMVN6ZXQ3ZzVLUUxMa2lnWk84U0hHU01i?=
 =?utf-8?B?S0VkeGpzQjJSWWt0UjBTeGhxaTZUakZHNHFjRmdJcHE1eDJkSmphc1YrUmdw?=
 =?utf-8?B?aTU0ZmVQc0w3ZnU5ZDlna29YSFBadHI4T0V5N2JNYUQ4dkNqVGpiM1hsZXh0?=
 =?utf-8?B?V0Q4OC9mODFybEdQZnN2N3VzZnFKaXF1NWdOTUVFTitlQkZaeW1JWTFmQzkx?=
 =?utf-8?B?V0JJMkFzcnpNU2pUVDUwRFQ4WUZkSVN2aE81S2JpN2VhS3BoQjVEd3RnRG5z?=
 =?utf-8?B?cnV2OGxxanhVWkpXa0ZxUmxEbit5c1NhcTVTcDBiZk5SQS9DLzZHY25sUnpG?=
 =?utf-8?B?blpHZjJmWVhmN1FUWTN5MkVtZiszekdxdmZNZVZ5ZmVobW85RjgzNmNaaUNs?=
 =?utf-8?B?Rk93cnRVbTdKK0FnTFBzWVlxU1NJUUpyNVpHZDJCcDNiNE5URVhBNEk5WGM3?=
 =?utf-8?B?SUZCd250c1J2UTN1SGprL2dCZ3lYKzA0OVhBdmNoSWFoQ2NuaW9FRDJ5MDI3?=
 =?utf-8?B?ZSs2RkYzVElzRmVxeWNabzgrY25jeko0dkpOZVpHTVVFVE15Um45Tm1Wekcx?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05C2FC81ECCECF408FAF5941455E23EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f21044-7f94-4a40-f51a-08db83845843
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 09:34:24.2378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBH6YWP2dYOPil7yFaopK0wsZWdOPX8CQjOkDSSIEMAmA/8KtngMX1J5yZ0EKIe/HSitbNU/oxAhAzd3CXA2PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7938
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

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDEwOjQ2ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDc6NDg6MjBBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gDQo+ID4gSSBmb3VuZCBiZWxvdyBjb21tZW50IGluIEtWTSBjb2RlOg0KPiA+IA0K
PiA+ID4gKwkgKiBTZWUgYXJjaC94ODYva3ZtL3ZteC92bWVudGVyLlM6DQo+ID4gPiArCSAqDQo+
ID4gPiArCSAqIEluIHRoZW9yeSwgYSBMMSBjYWNoZSBtaXNzIHdoZW4gcmVzdG9yaW5nIHJlZ2lz
dGVyIGZyb20gc3RhY2sNCj4gPiA+ICsJICogY291bGQgbGVhZCB0byBzcGVjdWxhdGl2ZSBleGVj
dXRpb24gd2l0aCBndWVzdCdzIHZhbHVlcy4NCj4gPiANCj4gPiBBbmQgS1ZNIGV4cGxpY2l0bHkg
ZG9lcyBYT1IgZm9yIHRoZSByZWdpc3RlcnMgdGhhdCBnZXRzICJwb3AiZWQgYWxtb3N0DQo+ID4g
aW5zdGFudGx5LCBzbyBJIGZvbGxvd2VkLg0KPiA+IA0KPiA+IEJ1dCB0byBiZSBob25lc3QgSSBk
b24ndCBxdWl0ZSB1bmRlcnN0YW5kIHRoaXMuICA6LSkNCj4gDQo+IFVyZ2gsIEkgc3VwcG9zZSB0
aGF0IGFjdHVhbGx5IG1ha2VzIHNlbnNlLiBTaW5jZSBwb3AgaXMgYSBsb2FkIGl0IG1pZ2h0DQo+
IGNvbnRpbnVlIHNwZWN1bGF0aW9uIHdpdGggdGhlIHByZXZpb3VzIHZhbHVlLiBXaGVyZWFzIHRo
ZSB4b3ItY2xlYXINCj4gaWRpb20gaXMgaW1wb3NzaWJsZSB0byBzcGVjdWxhdGUgdGhyb3VnaC4N
Cj4gDQo+IE9oIHdlbGwuLi4NCg0KVGhlbiBzaG91bGQgSSBrZWVwIHRob3NlIHJlZ2lzdGVycyB0
aGF0IGFyZSAicG9wImVkIGltbWVkaWF0ZWx5IGFmdGVyd2FyZHM/DQo=
