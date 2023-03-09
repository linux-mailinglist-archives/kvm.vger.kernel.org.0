Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D316B1915
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 03:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjCICMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 21:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCICMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 21:12:05 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C05BAD0D;
        Wed,  8 Mar 2023 18:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678327923; x=1709863923;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RwdrlnYNhXdOq6y+/905P9e8O0VqT0uNlUEH4e7wZ9w=;
  b=MG7z3gy90GeJ8Fmvm8QG/EeCLQXD27tlj2IXTjBL/8mtt9IvDRUbwjQE
   KEjKvmpQGGsH7RuSKg8HiU/2OGgxLCQC2Z6vVYz5FnOHQPjFSb0TtCynf
   u6sjs1v96rZzEk1LLTsQV2lvelPLLJgEXQ1gYOZj0U93To0LB+nhQrP6/
   JPIjWy/Y0ZVa6uipguASwyMoeauqQJvk1I77XNORmDHKk94LxM4lMWHRI
   L6ljzn3hYSu1Bxxm7wUruX4wGwJjAyAveslm8uKnhLLcrhqMEF0d86QIo
   JsdM8njaX2hJ23nNLQRuB597cFHMghRb6e4M3VJ7szJQvDhw0spkO0v7s
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="335037016"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="335037016"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 18:11:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="707416563"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="707416563"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 08 Mar 2023 18:11:16 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 18:11:16 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 18:11:15 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 18:11:15 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 18:11:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z98RbJhgWi+nsaMqAPZc/g2GLPV5FY2AAK7i7j/m1szJ1dd5fxPqKPXP2Tza+v1VD6TSgzJDguyqXUm18FCDV37y5T05Lh9KwWvHRrS9jREGN8rTmCr4WjmMtA5Z6f+SIEbPSHaRmOttI9AMOqD+9b+txwFFE/3HWJdkZod55lBTMHJXRJb0vz96e7+1E94c9tKQtATkgzFiB/tG7w+kZc6da3SZzHdgjRUTzVfUghMT4iPQIwFzYaeta91abFw3HUQzOc5VxeYOmvzWU+NmDfkR5nimv940TGjDXKzALxv0OHFnR7XlQ/G6oON5CzoDQFpmZuNfbKV0mDugEpk/Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwdrlnYNhXdOq6y+/905P9e8O0VqT0uNlUEH4e7wZ9w=;
 b=cPnG/5OiWXz8tqF0LRXBmTjMtUvtL8NbBQPYgV0SrsY2uuqSNkJ/CehlBatqPGgGqHwAPTUT03Wr5SXtbgIjNBXmOh+tRJ2t55vjNWo6bG6i/rJ4DRnXCRBvcUy+H5YhiYRhy490m+aKMgxFn9K4Q0sUR4c2SZkArMUdXkDS/3NyWNGsApwzfdHLg6pHt/YM32tVnO3xwDTi9h41Fbxzrzxm4R48XjO6aSm8urhgNQF+9TU/VxR33iwwOUnnCoq0p1Ltego+x4P8deY8TQqAEOBUrOtYv+obHfFtSnr3sPO2il7bpili5KqweJysEYTawPtP9hT4v177BliLCWkQ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8186.namprd11.prod.outlook.com (2603:10b6:610:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Thu, 9 Mar
 2023 02:11:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6156.029; Thu, 9 Mar 2023
 02:11:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
Thread-Topic: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
Thread-Index: AQHZTCxXkF4K+ZZqtEaRiCI/5s8D/a7m+acAgAAzBoCACGx9gIAAhtOAgAFKgoCAAFX8AA==
Date:   Thu, 9 Mar 2023 02:11:13 +0000
Message-ID: <f9f8765070fc08479cf48f649eeabf92277fdcc1.camel@intel.com>
References: <20230301105438.599196-1-kai.huang@intel.com>
         <ZAA1+EMTIkBJvdZF@gao-cwp>
         <3aec157afb6727e603d80c2232b3718033295f13.camel@intel.com>
         <ZAdxNgv0M6P63odE@google.com>
         <d1cdbb7aed99f325355a28dbed02346f4c4d7b16.camel@intel.com>
         <ZAj2gZY2tkXjJF6C@google.com>
In-Reply-To: <ZAj2gZY2tkXjJF6C@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8186:EE_
x-ms-office365-filtering-correlation-id: f7258b92-06b4-4daf-18c7-08db20438ebb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jBHdCzQR7oAyMd7zoTEpUkxiRDnAvkLDJ9L3YX7uZtyj4weTwmYPI3THkU/Gl5tuyN5oD8f3ofYATMMMK8hwppg2BOEwHE162npgp38Vi5j0ZHJeuT3aFTi3SAPbWYwyyJkxaQpQjO/Udf+Nw55lV67n9KDLXsrlVV+xx+19C29PV824G4l68HhOgAzSCwY86/poBfavXLqqrzHlY43YJnOIJmkMfJqOLQNnHotK7H8NbjvNYOgRU1fd3X7UQ6+jCrXa953o6pD0f8q/cdwplvf3kXsQlP/DfrSdMa0KPyH0L0to9TiLx8k69PDOZonegjfKuu/5PeAsf6J/Wo4zvPVZhFNhV2gI217V/CEucirS/RVGgG0nLIQ6+ishRWSXKHq+g3aSV4zSp4raX+Gdw5aVjXgWdposebqPtOyN2ppPvv9UexdtrNJZimkddg17GDxjBmSetbEck3/9c5uN5m6d1JTD1w1ORGssIcUTpp8dmnBzLlJbHq+DNaetsU4RH0nfaWSk3Qaz2iSc++XLGg2ayLkt35wuA/YkPoWPPuh/lDKWEZtMAFVBbtvi/krrGKrvAMAAFfvsTvX+emTl72QRx4ifH4RRpNXdZ3EKevG05z7e0iUfOirhEvHhcFZwGicjSoBHp/2Ul+xNNaClVLObO3YLNkIybOSxldjtRrwAeOAfGvrpYOzDsNsPAhA+wTX7VOrrAuba/7M1zJDKxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199018)(66446008)(5660300002)(478600001)(6486002)(8676002)(6506007)(54906003)(71200400001)(83380400001)(41300700001)(2906002)(107886003)(8936002)(91956017)(2616005)(66946007)(26005)(6512007)(4326008)(86362001)(66476007)(316002)(82960400001)(38100700002)(66556008)(76116006)(64756008)(6916009)(186003)(38070700005)(36756003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlNtVVRrVFBlV1JSc0o2Z1REZktocFFEQ1BJVURyYzdlRzZuS3BPQmFrMWtz?=
 =?utf-8?B?WmFnak5qQ2tJVmJlQk1SMzAvb2VRU2FuVFpGRlFMM3UwblhGSjBJZHAzWmM2?=
 =?utf-8?B?ZlhJcmVsUllCdmFYR1BUbjIwaUVzVmxOdSt3T0dxelpVMGY3WXU0RVRtNHh2?=
 =?utf-8?B?SlF1Q21STmg3UjBkR1JQTVVEQnlkOFBzbnErSVJiS2gzRU1Td1pKUURIbldl?=
 =?utf-8?B?VEduMlNJODNCby9jUTEvVFR3aW9tc0Mwa3ZabDlENlp2emRJRVorK1NsWVQw?=
 =?utf-8?B?bXNOblJnYW53NWUwL3dIb1pTV2JOd3JSODcxSktJL1pkRWZ0NDEyRUIraFcr?=
 =?utf-8?B?bnMzdHQ4WkhZTnpESnZERnN3b2RhOTNlUGt6aHhSNm1MRTBjSjRaczRPc0ts?=
 =?utf-8?B?M2N1YStMTURzcFlOMm04Q3pZV1VVVnRwMG83OFJQVDdrU1d4aGl6MjVqN3JW?=
 =?utf-8?B?clNvOUtiVTV3OTJUUHozS1o3UWlndW8vN2kxMEV2c1N1YitYT2xiS2VnbEFK?=
 =?utf-8?B?cFNCdHYzck5DUm1ScmRKbW00MEhCUzdIV3QxOURiZFRlbHJyVyszMEpSN2J2?=
 =?utf-8?B?M3dyR3JtWTlZeFJ6U25sUWhZVUN0dzh3YzNVQ1Q4N0FCcEVyRnErN2M2aEdS?=
 =?utf-8?B?Tnh1c2k3dnNuRWtla0lhVURwSldGQ0VNSXIyVEE5V3h5RGN2NlU5L2dzeW1m?=
 =?utf-8?B?WVl1UHFIblFqZWp0aENuYTFqaFdLRy8ySzE5WDg1SXduT0J4ODNoWnhHSFQ3?=
 =?utf-8?B?QkJucXYyaVlDZlIvNjFsMG5XZnk5aFpJMXVqUXVXVU8zbGRaMEZTTzhWQjNL?=
 =?utf-8?B?YnFDYy90eHV2RnViU2Q0ZjBqcnloMDFPRWV3R0Y0d3NkeE1kcTJGMlFYelE5?=
 =?utf-8?B?c3ZmYWREaTE0clc1L3plUnNBNmZScFAyNlJBaGpLSHBURy90UmJhM2ppbURa?=
 =?utf-8?B?MlpUd0hIc0xRMnJia3Y2enJjbWdLbmVHMkRvY1dUc01KSWY4bXJsdlBobkM0?=
 =?utf-8?B?QXRENWdHaHdPc2VNSTlwMmFDanEwNnNiQnQ4WFlzR0hUZ2NCUnpHY0hiSzFP?=
 =?utf-8?B?dDcyeUNoMTRPUDlRenJXbUVSYzRnekVGd1VnNUJxTXpKY1FlWnFsdkVmaDNa?=
 =?utf-8?B?bVBpTlY3ZjNqVUNKUGxWcjkrMVIzMXRMSU9GV1g1ang1S2d6OStpN1U1eEhN?=
 =?utf-8?B?NjltcVJsMk1GU2JRVllEaHlCbWNMdXRWa0NNa0FHQlowdWVSQjl4UjBWcHVY?=
 =?utf-8?B?WnJjYURvRWdvUHBKNHBTRHNEbEhzeFFiU0lqbHBtTFRCTXBNRndSRUY1ZzdG?=
 =?utf-8?B?UnA2WXJrZVl5Z1dhNEN3bEY1WXgyRU5CZm5JeGxCMDhDS3pZVFpuaGtxbDhj?=
 =?utf-8?B?MGxzRVFYRlJMUExlejJRQ1htQ0JyN2VRc0dqaGtHL0MyQjkxSFhad2tjcjJi?=
 =?utf-8?B?UnlIR2NOOTZORDBydExHWXRNU0l1bUlEWGdLUUVNWGZJM1BDUTNoY1BFNHo1?=
 =?utf-8?B?QVpUSForNDlaNWkydjM1UzBkaXF4WFdVN1dZczU3WkFWZnZxVXFGWEx6VDlS?=
 =?utf-8?B?aXJ1SHVWb2k3OW5mRCtFbFd2UHgwUjJvZnpyeHpiaVlqSE1tTm01ZHZpZWxP?=
 =?utf-8?B?ZEZ5eHNnejg1TCtxZFFadUVSRkJCSldvOEU5Q3QzaE9JdTNidWFjNWNIVUNL?=
 =?utf-8?B?QTZiaXJRZXRsbWhPQTBGZEJld1FRMkpwSjF3aTNONEx1ejQyZGVIT1pQT1h4?=
 =?utf-8?B?VUp3RmFZVXpSUzZZM1JuZHh5Tk5DUVllMUwxRTlKTkVENmR1eWpYN2ZiTk5G?=
 =?utf-8?B?MTlta0x3TngxdDF3YmV5YnRjK2NldWxvUHh3R2lGQWh2TzhUWWZkYnRnNUUv?=
 =?utf-8?B?bkoxTWxnSnJMS2F3VHBwY3VzdFpJQjdtZGpleUJQS0ZxbjVqRWtGbWJMeVRY?=
 =?utf-8?B?VGZKVFVqdmw4Ym5keUZlRGZRMGYrTUVJc1J4WUcrcUFWNkF1Rk96MVA4Zll0?=
 =?utf-8?B?KzZnZWdtWHc3MTh0MHZ1ME4vZmJJUmFSbkJzM0pVTjltc2JUTmFDVGVGZVgx?=
 =?utf-8?B?TENGQW5QUGN0SWIzazU1a3FpZUZENGRnakNuTnpVSTRaM20vV0hrRnBaT08z?=
 =?utf-8?B?bUphNDBKM29SYkd2V2E3eGpIUGllbXZDQVdRRC9USG9wN1VoTHc3OWQwVC9O?=
 =?utf-8?B?eUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72AC8785D1E81E438FDD696D2D80F12B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7258b92-06b4-4daf-18c7-08db20438ebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 02:11:13.1956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UDKqmW2lnMIxBghFACmMUW0YXFjiCeoWh7fJN+wGY4x+GgqlVki1SnPin7hHbZEPxY+ATQiqUIG4aweVW64elA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8186
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTA4IGF0IDEzOjAzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1hciAwOCwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
dWUsIDIwMjMtMDMtMDcgYXQgMDk6MTcgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBPbiBUaHUsIE1hciAwMiwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4g
T24gVGh1LCAyMDIzLTAzLTAyIGF0IDEzOjM2ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+ID4g
PiA+ID4gT24gV2VkLCBNYXIgMDEsIDIwMjMgYXQgMTE6NTQ6MzhQTSArMTMwMCwgS2FpIEh1YW5n
IHdyb3RlOg0KPiA+ID4gPiA+ID4gTWFrZSBzZXR1cF92bWNzX2NvbmZpZygpIHByZWVtcHRpb24g
ZGlzYWJsZWQgc28gaXQgYWx3YXlzIHBlcmZvcm1zIG9uDQo+ID4gPiA+ID4gPiB0aGUgc2FtZSBs
b2NhbCBjcHUuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IER1cmluZyBtb2R1bGUgbG9hZGlu
ZyB0aW1lLCBLVk0gaW50ZW5kcyB0byBjYWxsIHNldHVwX3ZtY3NfY29uZmlnKCkgdG8NCj4gPiA+
ID4gPiA+IHNldCB1cCB0aGUgZ2xvYmFsIFZNQ1MgY29uZmlndXJhdGlvbnMgb24gX29uZV8gY3B1
IGluIGhhcmR3YXJlX3NldHVwKCksDQo+ID4gPiANCj4gPiA+IFRoYXQgbWF5IGhhdmUgYmVlbiB0
aGUgdmVyeSBvcmlnaW5hbCBpbnRlbnRpb24sIGJ1dCBJIGRvbid0IHRoaW5rIGl0IGhhcyBiZWVu
IHRoZQ0KPiA+ID4gdHJ1ZSBpbnRlbnRpb24gZm9yIGEgdmVyeSBsb25nIHRpbWUuDQo+ID4gDQo+
ID4gV29uZGVyaW5nIHdoYXQncyB0aGUgY3VycmVudCBpbnRlbnRpb24/DQo+IA0KPiBJIGRvbid0
IHRoaW5rIHRoZXJlJ3MgYSBkZWxpYmVyYXRlICJpbnRlbnRpb24iIGJleW9uZCAiZG9lcyBpdCB3
b3JrPyIuICBMaWtlIG1hbnkNCj4gb2YgdGhlIGhpc3RvcmljYWwgYml0cyBvZiBLVk0geDg2LCBJ
IHRoaW5rIHRoaXMgaXMgYSBjYXNlIG9mIHRoZSBvcmlnaW5hbCBhdXRob3JzDQo+IF93YW50aW5n
XyB0byBwcm92aWRlIGNlcnRhaW4gYmVoYXZpb3IsIGJ1dCBub3QgYWN0dWFsbHkgZW5zdXJpbmcg
dGhhdCBiZWhhdmlvciBpbg0KPiBjb2RlLg0KDQpZZXAuDQoNCj4gDQo+ID4gPiA+ID4gPiBDaGFu
Z2UgdGhlIGV4aXN0aW5nIHNldHVwX3ZtY3NfY29uZmlnKCkgdG8gX19zZXR1cF92bWNzX2NvbmZp
ZygpIGFuZA0KPiA+ID4gPiA+ID4gY2FsbCB0aGUgbGF0dGVyIGRpcmVjdGx5IGluIHRoZSBjb21w
YXRpYmlsaXR5IGNoZWNrIGNvZGUgcGF0aC4gIENoYW5nZQ0KPiA+ID4gPiA+ID4gc2V0dXBfdm1j
c19jb25maWcoKSB0byBjYWxsIF9fc2V0dXBfdm1jc19jb25maWcoKSB3aXRoIHByZWVtcHRpb24N
Cj4gPiA+ID4gPiA+IGRpc2FibGVkIHNvIF9fc2V0dXBfdm1jc19jb25maWcoKSBpcyBhbHdheXMg
ZG9uZSBvbiB0aGUgc2FtZSBjcHUuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gTWF5YmUgeW91IGNh
biBzaW1wbHkgZGlzYWJsZSBwcmVlbXB0aW9uIGluIGhhcmR3YXJlX3NldHVwKCkgYWx0aG91Z2gg
SQ0KPiA+ID4gPiA+IGRvbid0IGhhdmUgYSBzdHJvbmcgcHJlZmVyZW5jZS4NCj4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiBuZXN0ZWRfdm14X3NldHVwX2N0bHNfbXNycygpIGFsc28gcmVhZHMgc29tZSBN
U1JzIGFuZCBzZXRzIHVwIHBhcnQgb2YNCj4gPiA+ID4gPiB2bWNzX2NvbmYsIHNob3VsZCBpdCBi
ZSBjYWxsZWQgb24gdGhlIHNhbWUgQ1BVIGFzIHNldHVwX3ZtY3NfY29uZmlnKCk/DQo+ID4gPiA+
IA0KPiA+ID4gPiBZZXMgSSB0aGluayBzby4gIEkgbWlzc2VkIHRoaXMgOikNCj4gPiA+ID4gDQo+
ID4gPiA+IE5vdCBzdXJlIHdoZXRoZXIgdGhlcmUgYXJlIG90aGVyIHNpbWlsYXIgcGxhY2VzIHRv
byBldmVuIG91dHNpZGUgb2YNCj4gPiA+ID4gaGFyZHdhcmVfc2V0dXAoKS4NCj4gPiA+ID4gDQo+
ID4gPiA+IEJ1dCBjb21wYXRpYmlsaXR5IGNoZWNrIG9ubHkgY2hlY2tzIHRoaW5ncyBjYWxjdWxh
dGVkIHZpYSBzZXR1cF92bWNzX2NvbmZpZygpDQo+ID4gPiA+IGFuZCBuZXN0ZWRfdm14X3NldHVw
X2N0bHNfbXNycygpLCBzbyBJIHRoaW5rIGl0J3MgZmFpciB0byBvbmx5IHB1dA0KPiA+ID4gPiBo
YXJkd2FyZV9zZXR1cCgpIGluc2lkZSBwcmVlbXB0aW9uIGRpc2FibGVkLg0KPiA+ID4gDQo+ID4g
PiBEaXNhYmxpbmcgcHJlZW1wdGlvbiBhY3Jvc3MgaGFyZHdhcmVfc2V0dXAoKSBpc24ndCBmZWFz
aWJsZSBhcyB0aGVyZSBhcmUgYSBudW1iZXINCj4gPiA+IG9mIGFsbG9jYXRpb25zIHRoYXQgbWln
aHQgc2xlZXAuICBCdXQgZGlzYWJsaW5nIHByZWVtcHRpb24gaXNuJ3QgbmVjZXNzYXJ5IHRvDQo+
ID4gPiBlbnN1cmUgc2V0dXAgcnVucyBvbiBvbmUgQ1BVLCB0aGF0IG9ubHkgcmVxdWlyZXMgZGlz
YWJsaW5nIF9taWdyYXRpb25fLiAgU28gX2lmXw0KPiA+ID4gd2Ugd2FudCB0byBoYW5kbGUgdGhp
cyBpbiB0aGUga2VybmVsLCB3ZSBjb3VsZCBzaW1wbHkgZG86DQo+ID4gPiANCj4gPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+IGlu
ZGV4IDU0MTk4MmRlNTc2Mi4uOTEyNmZkZjAyNjQ5IDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94
ODYva3ZtL3g4Ni5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+IEBAIC05
NDcwLDcgKzk0NzAsOSBAQCBpbnQga3ZtX3g4Nl92ZW5kb3JfaW5pdChzdHJ1Y3Qga3ZtX3g4Nl9p
bml0X29wcyAqb3BzKQ0KPiA+ID4gICAgICAgICBpbnQgcjsNCj4gPiA+ICANCj4gPiA+ICAgICAg
ICAgbXV0ZXhfbG9jaygmdmVuZG9yX21vZHVsZV9sb2NrKTsNCj4gPiA+ICsgICAgICAgbWlncmF0
ZV9kaXNhYmxlKCk7DQo+ID4gPiAgICAgICAgIHIgPSBfX2t2bV94ODZfdmVuZG9yX2luaXQob3Bz
KTsNCj4gPiA+ICsgICAgICAgbWlncmF0ZV9lbmFibGUoKTsNCj4gPiA+ICAgICAgICAgbXV0ZXhf
dW5sb2NrKCZ2ZW5kb3JfbW9kdWxlX2xvY2spOw0KPiA+ID4gIA0KPiA+ID4gICAgICAgICByZXR1
cm4gcjsNCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiBCdXQgSSdtIG5vdCBjb252aW5jZWQgd2Ugc2hv
dWxkIGhhbmRsZSB0aGlzIGluIHRoZSBrZXJuZWwuICBNYW55IG9mIHRoZSBjaGVja3MsDQo+ID4g
PiBlc3BlY2lhbGx5IGluIFNWTSwgcXVlcnkgYm9vdF9jcHVfaGFzKCksIG5vdCB0aGlzX2NwdV9o
YXMoKSwgaS5lLiB0byB0cnVseSBwZXJmb3JtDQo+ID4gPiBzZXR1cCBvbiBhIHNpbmdsZSBDUFUs
IGFsbCBvZiB0aG9zZSB3b3VsZCBuZWVkIHRvIGJlIGNvbnZlcnRlZCB0byB0aGlzX2NwdV9oYXMo
KS4NCj4gPiA+IA0KPiA+ID4gU29tZSBvZiB0aG9zZSBib290X2NwdV9oYXMoKSBjYWxscyBzaG91
bGQgYmUgY2hhbmdlZCByZWdhcmRsZXNzIG9mIHdoZXRoZXIgb3Igbm90DQo+ID4gPiBtaWdyYXRp
b24gaXMgZGlzYWJsZWQsIGUuZy4ga3ZtX2lzX3N2bV9zdXBwb3J0ZWQoKSBpcyBhcmd1YWJseSBz
dHJhaWdodCB1cCBidWdneQ0KPiA+ID4gZHVlIHRvIGNwdV9oYXNfc3ZtKCkgY2hlY2tpbmcgdGhl
IGJvb3QgQ1BVIChJJ2xsIGZpeCB0aGF0IGJ5IGFkZGluZyBhIHBhdGNoIGFmdGVyDQo+ID4gPiBv
cGVuIGNvZGluZyBjcHVfaGFzX3N2bSgpIGludG8ga3ZtX2lzX3N2bV9zdXBwb3J0ZWQoKVsqXSku
DQo+ID4gPiANCj4gPiA+IEJ1dCB0aGluZ3MgbGlrZSBrdm1fdGltZXJfaW5pdCgpIHNob3VsZCBO
T1QgYmUgYmxpbmRsZ2x5IGNvbnZlcnRlZCB0byB0aGlzX2NwdV9oYXMoKSwNCj4gPiA+IGJlY2F1
c2UgdGhlIHRlYXJkb3duIHBhdGggbmVlZHMgdG8gbWlycm9yIHRoZSBzZXR1cCBwYXRoLCBlLmcu
IGlmIEtWTSBlbmRlZCB1cA0KPiA+ID4gcnVubmluZyBvbiBmcmFua2Vuc3RlaW4gaGFyZHdhcmUg
d2hlcmUgbm90IGFsbCBDUFVzIGhhdmUgYSBjb25zdGFudCBUU0MsIEtWTSBjb3VsZA0KPiA+ID4g
bGVhdmUgYSBjYWxsYmFjayBkYW5nbGluZyBhbmQgaG9zZSB0aGUga2VybmVsLiAgT2J2aW91c2x5
IHN1Y2ggaGFyZHdhcmUgd291bGRuJ3QNCj4gPiA+IGNvcnJlY3RseSBydW4gVk1zLCBidXQgY3Jh
c2hpbmcgdGhlIGtlcm5lbCBpcyBhIHRvdWNoIHdvcnNlIHRoYW4gS1ZNIG5vdCB3b3JraW5nDQo+
ID4gPiBjb3JyZWN0bHkuDQo+ID4gPiANCj4gPiA+IEknbSBub3QgdG90YWxseSBhZ2FpbnN0IGNv
bnZlcnRpbmcgdG8gdGhpc19jcHVfaGFzKCkgZm9yIHRoZSBzZXR1cCwgYXMgaXQgd291bGQgYmUN
Cj4gPiA+IG1vcmUgaW50dWl0aXZlIGluIGEgbG90IG9mIHdheXMuICBCdXQsIEkgZG9uJ3QgdGhp
bmsgcGlubmluZyB0aGUgdGFzayBhY3R1YWxseQ0KPiA+ID4gaGFyZGVucyBLVk0gaW4gYSBtZWFu
aW5nZnVsIHdheS4gIElmIHRoZXJlIGFyZSBhbnkgZGl2ZXJnZW5jZXMgYmV0d2VlbiBDUFVzLCB0
aGVuDQo+ID4gPiBlaXRoZXIgS1ZNIHdpbGwgbm90aWNlIGJlZm9yZSBydW5uaW5nIFZNcywgZS5n
LiB0aGUgVk1DUyBzYW5pdHkgY2hlY2tzLCBvciBLVk0gd2lsbA0KPiA+ID4gbmV2ZXIgbm90aWNl
LCBlLmcuIHRoZSBteXJpYWQgcnVudGltZSBwYXRocyB0aGF0IGNoZWNrIGJvb3RfY3B1X2hhcygp
IChvciB2YXJpYW50cw0KPiA+ID4gdGhlcmVvZikgd2l0aG91dCBzYW5pdHkgY2hlY2tpbmcgYWNy
b3NzIENQVXMuICBBbmQgaWYgdXNlcnNwYWNlIF9yZWFsbHlfIHdhbnRzIHRvDQo+ID4gPiBoYXZl
IGd1YXJhbnRlZXMgYWJvdXQgaG93IHNldHVwIGlzIHBlcmZvcm1lZCwgZS5nLiBmb3IgcmVwZWF0
YWJsZSwgZGV0ZXJtaW5pc3RpYw0KPiA+ID4gYmVoYXZpb3IsIHRoZW4gdXNlcnNwYWNlIHNob3Vs
ZCBmb3JjZSBsb2FkaW5nIG9mIEtWTSB0byBiZSBkb25lIG9uIENQVTAuDQo+ID4gDQo+ID4gTXkg
aW50ZW50aW9uIGlzIG5ldmVyIGZvciB1c2Vyc3BhY2UsIGJ1dCBzaW1wbHkvcHVyZWx5IGZyb20g
Y29tcGF0aWJpbGl0eQ0KPiA+IGNoZWNrJ3MgcG9pbnQgb2YgdmlldyAoc2VlIGJlbG93KS4gIEFs
c28sIEkgZG9uJ3QgdGhpbmsgdXNlcnNwYWNlIHdhbnRzIHRvDQo+ID4gZ3VhcmFudGVlIGFueXRo
aW5nICAtLSBpdCBqdXN0IHdhbnRzIHRvIGxvYWQgdGhlIEtWTSBtb2R1bGUuDQo+IA0KPiBUaGF0
IHZlcnkgbXVjaCBkZXBlbmRzIG9uIHRoZSB1c2UgY2FzZS4gIEZvciBwZXJzb25hbCB1c2FnZSBv
ZiBLVk0sIGl0J3MgZXh0cmVtZWx5DQo+IHVubGlrZWx5IHRoYXQgdXNlcnNwYWNlIGlzIGRvaW5n
IGFueXRoaW5nIHJlbW90ZWx5IHNvcGhpc3RpY2F0ZWQuICBCdXQgZm9yIGEgbW9yZQ0KPiAiZm9y
bWFsIiBkZXBsb3ltZW50LCB1c2Vyc3BhY2UgYWJzb2x1dGVseSBoYXMgaXRzIGhhbmRzIGFsbCBv
dmVyIHRoZSBzeXN0ZW0sIGUuZy4NCj4gc2NoZWR1bGluZyBWTXMgYWNyb3NzIHN5c3RlbXMsIG1v
bml0b3JpbmcgdGhlIGhlYWx0aCBvZiB0aGUgc3lzdGVtLCBldGMuICBXaGV0aGVyDQo+IG9yIG5v
dCB1c2Vyc3BhY2VzIGFjdHVhbGx5IGRvIHRpZ2h0bHkgY29udHJvbCBsb2FkaW5nIEtWTSBpcyBh
bm90aGVyIG1hdHRlci4uLg0KDQpBZ3JlZWQuDQoNCj4gDQo+ID4gSXQncyBldmVuIGFyZ3VhYmxl
IHRoYXQgaXQgbWF5IGJlIGFuIGFjY2VwdGFibGUgYmVoYXZpb3VyIHRvIGZhaWwgdG8gcnVuIGFu
eQ0KPiA+IFZNIGV2ZW4gbG9hZGluZyBtb2R1bGUgd2FzIHN1Y2Nlc3NmdWwuDQo+ID4gDQo+ID4g
PiANCj4gPiA+IFNvIG15IHZvdGUgaXMgdG8gbGVhdmUgdGhpbmdzIGFzLWlzIChtb2R1bG8gdGhl
IGNwdV9oYXNfc3ZtKCkgbWVzcykuICBCdXQgbWF5YmUgYWRkDQo+ID4gPiBkb2N1bWVudGF0aW9u
IHRvIGV4cGxhaW4gdGhlIGNhdmVhdHMgYWJvdXQgbG9hZGluZyBLVk0sIGFuZCBob3cgdXNlcnNw
YWNlIGNhbg0KPiA+ID4gbWl0aWdhdGUgdGhvc2UgY2F2ZWF0cz8NCj4gPiANCj4gPiBJIG1hZGUg
dGhpcyBwYXRjaCBiZWNhdXNlIEkgaGF2ZSBzb21lIG90aGVyIHBhdGNoZXMgdG8gbW92ZSBWTVhP
TiBzdXBwb3J0IG91dCBvZg0KPiA+IEtWTSBpbiBvcmRlciB0byBzdXBwb3J0IFREWCwgYnV0IHNv
IGZhciB0aG9zZSBwYXRjaGVzIGFyZSBub3QgaW5jbHVkZWQgaW4gdGhhdA0KPiA+IHNlcmllcyAo
YW5kIEknZCBsaWtlIHRvIGxlYXZlIGl0IG91dCBpZiB3ZSByZWFsbHkgZG9uJ3QgbmVlZCBpdCku
DQo+IA0KPiBNZSB0b28uIDotKQ0KPiANCj4gPiBJbiB0aGUgcGF0Y2ggdG8gbW92ZSBWTVhPTiBv
dXQgb2YgS1ZNLCBJIGNoYW5nZWQgdG8gdXNlIHBlci1jcHUgdmFyaWFibGUgdG8NCj4gPiBjYWNo
ZSB0aGUgTVNSX0lBMzJfVk1YX0JBU0lDIHZhbHVlIGFuZCBzZXR1cCB0aGUgVk1YT04gcmVnaW9u
IHdoZW4gb25lIENQVSBpcw0KPiA+IGJlY29taW5nIG9ubGluZS4gIEFuZCBzZXR1cF92bWNzX2Nv
bmZpZygpIGlzIGNoYW5nZWQgdG8gdXNlIF9fdGhpc19jcHVfcmVhZCgpIHRvDQo+ID4gcmVhZCB0
aGUgcGVyLWNwdSBNU1IgdmFsdWUgaW5zdGVhZCBvZiByZWFkaW5nIGZyb20gaGFyZHdhcmUuICBP
YnZpb3VzbHkgdy9vDQo+ID4gcHJlZW1wdF9kaXNhYmxlKCkgb3Igc2ltaWxhciBfX3RoaXNfY3B1
X3JlYWQoKSBjYW4gcmVwb3J0IGtlcm5lbCBidWc6DQo+ID4gDQo+ID4gICAgICAgICBwcmludGso
S0VSTl9FUlIgIkJVRzogdXNpbmcgJXMlcygpIGluIHByZWVtcHRpYmxlIFslMDh4XSBjb2RlOiAl
cy8lZFxuIiwNCj4gPiAgICAgICAgICAgICAgICAgd2hhdDEsIHdoYXQyLCBwcmVlbXB0X2NvdW50
KCkgLSAxLCBjdXJyZW50LT5jb21tLCBjdXJyZW50LT5waWQpOw0KPiA+IA0KPiA+IFRoYXQgYmVp
bmcgc2FpZCwgSSBhbSBmaW5lIHRvIGtlZXAgZXhpc3RpbmcgY29kZSwgZXZlbiB3L28gZG9jdW1l
bnRpbmcuICBXZSBjYW4NCj4gPiBkaXNjdXNzIG1vcmUgaG93IHRvIGhhbmRsZSB3aGVuIHdlIHJl
YWxseSB3YW50IHRvIG1vdmUgVk1YT04gb3V0IG9mIEtWTSAoaS5lLg0KPiA+IHN1cHBvcnRpbmcg
VERYIElPPykuDQo+ID4gDQo+ID4gT3Igd2UgY2FuIGp1c3QgZml4IGNvbXBhdGliaWxpdHkgY2hl
Y2sgcGFydD8gIEZvciBpbnN0YW5jZSwgbW92ZQ0KPiA+IHNldHVwX3ZtY3NfY29uZmlnKCkgYW5k
IG5lc3RlZF92bXhfc2V0dXBfY3Rsc19tc3JzKCkgdG9nZXRoZXIgaW4NCj4gPiBoYXJkd2FyZV9z
ZXR1cCgpIGFuZCBjYWxsIHByZWVtcHRfZGlzYWJsZSgpIGFyb3VuZCB0aGVtPw0KPiANCj4gRWgs
IHRoZSBjb21wYXRpYmlsaXR5IGNoZWNrcyB3ZSByZWFsbHkgY2FyZSBhYm91dCBydW4gaW4gSVJR
IGNvbnRleHQsIGkuZS4gdGhleSdyZQ0KPiBndWFyYW50ZWVkIHRvIGhhdmUgYSBzdGFibGUgQ1BV
LiAgU3BsaXR0aW5nIHRoZSBfc2V0dXBfIGZvciB0aGUgY29tcGF0aWJpbGl0eQ0KPiBjaGVja3Mg
YWNyb3NzIG11bHRpcGxlIENQVXMgaXNuJ3QgYSBwcm9ibGVtIGJlY2F1c2UgS1ZNIHdpbGwgc3Rp
bGwgZ2V0IHRoZSByaWdodA0KPiAiYW5zd2VyIiwgaS5lLiBhbnkgZGl2ZXJnZW5jZSB3aWxsIGJl
IGRldGVjdGVkIChiYXJyaW5nIF92ZXJ5XyBmbGFreSBoYXJkd2FyZSB0aGF0DQo+IG1pZ2h0IGdl
dCBmYWxzZSBuZWdhdGl2ZXMgYW55d2F5cykuDQo+IA0KPiBEb24ndCBnZXQgbWUgd3JvbmcsIEkg
YWdyZWUgaXQncyB1Z2x5LCBidXQgSSBkb24ndCB3YW50IHRvIGdvIGhhbGZ3YXkuICBJIGVpdGhl
cg0KPiB3YW50IHRvIGd1YXJkIHRoZSB3aG9sZSB0aGluZywgb3Igbm90aGluZywgYW5kIEkgY2Fu
J3QgY29udmluY2UgbXlzZWxmIHRoYXQNCj4gZ3VhcmRpbmcgZXZlcnl0aGluZyBpcyB3b3J0aHdo
aWxlIHNpbmNlIHVzZXJzcGFjZSBjYW4gKGFuZCBJTU8gc2hvdWxkKSBkbyBhIGJldHRlcg0KPiBq
b2IuDQoNCkFncmVlZC4NCg0KTGV0J3MganVzdCBsZWF2ZSB0aGUgY3VycmVudCBjb2RlIGFzIGlz
Lg0KDQpUaGFua3MgZm9yIHlvdXIgdGltZSENCg0K
