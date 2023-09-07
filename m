Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC8F797EBA
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 00:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbjIGWe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 18:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjIGWe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 18:34:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFB81BC7;
        Thu,  7 Sep 2023 15:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694126094; x=1725662094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zivw7rCqcW0pgfkFC0128cbStSElLihQi77BDRwjU5A=;
  b=egWPXRedNs6K9gv14miy7EOtA7MbV0SfyhL5l4Oxsd8uTJTSMVqkimDp
   65Z5D+Necp0Lczv9sy+a+rLYmYpzmQdixjSL2QEs0fYDiKATlWCqtN5Vj
   w5zU/4V8Pliu227L0+7mlXd+1wU8+DoT+la+pZa9qGRuMYjZR1xS1gxuh
   ZOyhK3Buo9XUerMoN4U4mlBn35pnZRucmbSt4rY81TPGR0VxyVMRyIm76
   rqu4SVKUiXJfE+jzp98sCSPpYs15n/gHkImcjhUacBo0wsicf2ERLNa5D
   ppkOBpmqWK9xmJaP1isyX+OOWpoENpyP3zZ515eGmKYLKpWNjiGIMHvZd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="381302597"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="381302597"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2023 15:34:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="691967391"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="691967391"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Sep 2023 15:34:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 7 Sep 2023 15:34:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 7 Sep 2023 15:34:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 7 Sep 2023 15:34:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 7 Sep 2023 15:34:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F72kdtHKtapSNTPCJ70sw1DFFzoNwgXbOk3Kb6+xlQuT3BJxsk2Uu/BtnJy1N6o0zoBOLs/14vL+JClUxZDmxoJTPY699+sFScYMOVIxrO90I287GoEXDQtLXezTgp2qNY9hka8jb6QXGjKd20G5gueHHU5wNmHeNUiIHEeNa8LlbNlXDwxGIEsn6qbzCAwoQkmIfM/u1nCatVASOgt/G1d2+xb0Cf06/nwcaW0Jr26qSaHKj5bcFb11sRbmgrw4SsmioB89drJmgNd0BaIdKhNim3YvIms5cW+R8qe+NOB1FbOWsifNYS30BicyMqB+/d/Eh1ea8B/7agnsd+PNQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zivw7rCqcW0pgfkFC0128cbStSElLihQi77BDRwjU5A=;
 b=dW+SL2BXpCnFdpnEbTK7p8mPt0wgIOUVjIiGi3am3gGfsD7YT7m2jbz9qkYGN0V9eP6jKsNJWFxVoM1DSEZep9TXiLYmZ3XpJ2RU6O0mcakyPrTbJ4YRmZjE1xkaBiiQjmVERr8lmuGTjUyxSFOIBPCmlE0ZHoDX5UY6mfPGON3PWX0yAvu95FqlEqS3j1Ko+HtMeD9xaQZv28XP2d3vNGJq16YwS+IhyPMLeLzE2JWPxX50KbtGYRvxQqM17YfT27Tff+lxLH79htdXyJ51BYX3EzN6H634/oqLBD7eqTcb3HGiJjAEL+p2Srs/SL+PZDF3iSGxQRQHrNOOuexpuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7105.namprd11.prod.outlook.com (2603:10b6:930:53::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 22:34:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.029; Thu, 7 Sep 2023
 22:34:49 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Thread-Topic: [PATCH 2/2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Thread-Index: AQHZ1vmsASee+tbEkESGNccmLbK5BLAOfqCAgAEHUoCAAIMcAA==
Date:   Thu, 7 Sep 2023 22:34:49 +0000
Message-ID: <5801d8ea32a633abbfb8fb59380ec957caa03229.camel@intel.com>
References: <20230825020733.2849862-1-seanjc@google.com>
         <20230825020733.2849862-3-seanjc@google.com>
         <68859513bc0fb4eda4e3e62ec073dd2a58f7676b.camel@intel.com>
         <ZPniC2JCOPMK1JQb@google.com>
In-Reply-To: <ZPniC2JCOPMK1JQb@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7105:EE_
x-ms-office365-filtering-correlation-id: 5333e95a-a990-4bf0-985a-08dbaff2a56a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pggBdrVKL3UTADeeZDU7c6mrbSnNKsrq3/kY7DBho161sSDrDP/hl5oWmePLX9O0b/jkAoXs6th13bWW2EOOhOgdADM+NojRJdA5UQfdhkTMTG+LVj22IYkAQfj2XtIyYUf4I8zEcqCMzB36kj/vULIZRZESVXgIjQca57CGeL7YMA7fBNGhmPASAHLtDDVKLTIrQa07tb/xP08VtrPuUUx656W8mPgEf+B4jKkZNd+JoADp1SvhBDWovBARuTUGLxQt+3cmVIp496Tl9/y4ix6f+M51c4DZrLaoDYwLRYGto0PA6M+AYLSEXGWE9pwGd8BBCBQoxXFRdNFc8OTz1vn9sNkt5Vh9WIwrnMlnSETC/OQsaV1ziiwneXeba99LvrlfofL5bGSHULSc7aaLp7n78jiliCPtcjLG3YJ6lh4mkByd1NNYmFngdqbamr5Z2C5i/y6N9SayCrtvvL+8FlYr9xztCp44C9YZnmJTz+S4yh1CC3uLiXeinsthpKJ+0eCncnF14ilvmr/tTvmaj3ZcDAuVX0ONR70Xizg7kwFj+P4xymoRxnUpHTbfNOM2aNuO/nlMsQ3ZIyE7KppAIZz+bxUgWJotQbHErKpCAK98WVqvTA2NraFgPSlGzKV8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(39860400002)(136003)(396003)(186009)(451199024)(1800799009)(82960400001)(36756003)(86362001)(6512007)(6486002)(83380400001)(66476007)(2616005)(26005)(71200400001)(107886003)(5660300002)(41300700001)(6916009)(8676002)(8936002)(4326008)(316002)(2906002)(54906003)(66556008)(38100700002)(478600001)(66946007)(38070700005)(66446008)(122000001)(6506007)(91956017)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXVaS1plTE9JUTRweWd4RExRS3VOM2xsU3FidWhmNFd1bjhQVnFvUWIxTkVE?=
 =?utf-8?B?aStXOHZKSEoyVFhuMUR6T1AzQmdxQnBKZmFUTXFOeUNYUzNzT3N2Vll5NmFh?=
 =?utf-8?B?c3ZXS1dXcitsNGo3R1pjQlVXQnV2MldKS2dxaEsxS1FVZ3ptYlU2U1dqdG1w?=
 =?utf-8?B?bmRSdC8wbTIxR2JHTnNUaENzZFhXQzYzQ2wxNzZpWk5iL1VZNUw5a1BEQkQy?=
 =?utf-8?B?ME54MVBRMDBXajF4alduaG5SdFdoVG9qd0RPd1pPY2ppdEVvbEM3MzNVbkx0?=
 =?utf-8?B?RkxTRjNnK0dEWnNxTFJ0NHM2ZGJ0ZGtrMXAyc0F1YnJUTE9wOUpwMThrbUJ1?=
 =?utf-8?B?ZjZXL280c3dYbHNobU1WallvVGhacVN3aEhudTVNQ0d5UDk5d1dVSTJ5YkNz?=
 =?utf-8?B?WGQ1Q2YxWE8xeEhWK0ZBcTFMMWJLU3RlV085MCtWWHRCVklSVkR5ZWJIKzI0?=
 =?utf-8?B?NngrSXUvQ1VLRVBkMG9wSUhlT2hYRncxdit1MU1PdTJDbjhjWWN5TnlwYjVT?=
 =?utf-8?B?dVdLaHN4THBjdTk5YWlvK2ZLOGFDYzcyV2dHaEFCVDJkcGZOelY5eDNPSWcy?=
 =?utf-8?B?dzZVbzM0K3k0Z3E2Q0laVmI2eGFrOUJRbTJxd1ErRk96ODlwYXI5eUNWcHUw?=
 =?utf-8?B?NU1DUDJQaU1xZGs1MThRL1cySER3bVlKdEZyRlp0VzdHTG4rSHVNM2lRc2FF?=
 =?utf-8?B?WDdLQnlzRGZxNWpOWDNnVTk1dW5mR1dMU1ZTampySUgyTTVpeFhGNWR6RDFi?=
 =?utf-8?B?VlVHdmV0Y1JPenlTZ2pWNDdXeEVxRE1EUXJUYlV0aGhnZ1JhM1ZBa0hPT2pV?=
 =?utf-8?B?RHg2Q3E5ay90ZXVjMGhrRW1aNEdLeTdsZGZZc3NKQ21vUzUxcWluMUlQdGFl?=
 =?utf-8?B?dVpOY1dmTGltUVlxaC9GakpJZVo5NEcyKzRoemJWNTlJek92VngvMU5Lb0Jx?=
 =?utf-8?B?Q0tHMnl4ODNlclphTk5yU01qMFVicHBlTlhNZjAvZis1dXFwWWdwRS9KKzEz?=
 =?utf-8?B?KytVSWV2ODZ1eWovSE0vSGgvRWQvL2FsRzh1a2pHTksxMGhkRnE3MlN3OGoy?=
 =?utf-8?B?Qnl0cmdEUXpRWlk0Z2lyaWlFd3VGRnZuVXB3WHBvMzZBdVBQd292OTB2M3hM?=
 =?utf-8?B?dzRaelRwL281azNBcGVhQi95RDU4aURzNzBtbzExU3oybXhNSmY4Z1FHSjF6?=
 =?utf-8?B?Qm41Y3pWUEhtSnE0ZnBKQjdITEw0bytLTDF0UWc0c0Y5V2hNU3ZnMTN2SC81?=
 =?utf-8?B?bXBSRWZDUWZLZmpWNjV5VWxjUko0VTZFYWlKYVVYMVIraHZFWWF5UXZBeTBm?=
 =?utf-8?B?MXZjc1hhL2pwQkxOK1c3MVFqWi8vcU1wUGp5NTBBVUVreTdBcEQyTnVETVc5?=
 =?utf-8?B?am1SSXRERzIzaTFoczdEcm1WWnBkTkZUam1SYWlrRmIyWG1qQkZCSGlqVzRV?=
 =?utf-8?B?NDUwMG5BaXVYcFl1VWNVazNrUm9KL1ZRVFBkbnNMMzhtSEdmckJKamoyREZE?=
 =?utf-8?B?VEJuaEhCZyt4M0NnZkJGNzErZ0lHT2U2SmdkSDhiekk0VjZaZkV4WExtcHlk?=
 =?utf-8?B?NkxiRUo0S3BrUmEreCtEVVZhTzlRb0t6d05hK3BFa2t0RHFic1l3UldlekhT?=
 =?utf-8?B?YnJOOXJNcFFpaE1iSE5qTTY4OEJUZEx0Z1JEWnRFZ0ljano0NjhCUWF4UDU1?=
 =?utf-8?B?RkFQek9PNmNqU0VIWGNNWU1xVk1oUkhzb1ZiOGhQRm9mcDhpcHV1T204M3Jx?=
 =?utf-8?B?STkyay91NmtnajRUa3NKYzZBenB0aVY2NnEzZW1JMGwyUTlTTytkN0hZUnRD?=
 =?utf-8?B?TDNGMGlubm93TGtEcEhwU05QaFRubHBwcFl0VlEySFM3UFBrVVo0V2pId1V4?=
 =?utf-8?B?Qks5NGFpckJxaUV1eU5TWWJxT1FUWEQyRlRjUVdYbkU5aEdGZ0VMTFNHZHZN?=
 =?utf-8?B?ekp1eFI2ejZBcTYrRjlxYWRrR1lvS0xudjN5bHdOUm1rS3daenBrb2NMT2s4?=
 =?utf-8?B?Z2Vmai9IUWw0VWVJRlNiR0FJOEo0VW90ZS9wWlhhMzBYc0lGRGEwVS84NTQ1?=
 =?utf-8?B?UDF1QWl6ZGlWOUZwdTZJeG5pV0d1MEtZNUpjemd0SStPeW9zK21mU0Y2Wmcx?=
 =?utf-8?Q?V4LDCo1kj+WRzAhTFlbGHU1tA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC0BC6E708CBE943A2507E7AB91D30C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5333e95a-a990-4bf0-985a-08dbaff2a56a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2023 22:34:49.5205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n4JsiHfZZ0vP57brOhSDgCffRPTWCwbyzGUo8sYuVlAEdmZPgAhjebnONC4mB8CvtCG8xEGlfQoxWagACdqNKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7105
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA5LTA3IGF0IDA3OjQ1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIFNlcCAwNiwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyMy0wOC0yNCBhdCAxOTowNyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IC0tLQ0KPiA+ID4gIGFyY2gveDg2L2t2bS9tbXUvbW11LmMgfCAzICsrKw0KPiA+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ID4g
PiBpbmRleCAxYTVhMWU3ZDFlYjcuLjhlMmUwN2VkMWExYiAxMDA2NDQNCj4gPiA+IC0tLSBhL2Fy
Y2gveDg2L2t2bS9tbXUvbW11LmMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMN
Cj4gPiA+IEBAIC00MzM0LDYgKzQzMzQsOSBAQCBzdGF0aWMgaW50IGt2bV9mYXVsdGluX3Bmbihz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcGFnZV9mYXVsdCAqZmF1bHQsDQo+ID4g
PiAgCWlmICh1bmxpa2VseSghZmF1bHQtPnNsb3QpKQ0KPiA+ID4gIAkJcmV0dXJuIGt2bV9oYW5k
bGVfbm9zbG90X2ZhdWx0KHZjcHUsIGZhdWx0LCBhY2Nlc3MpOw0KPiA+ID4gIA0KPiA+ID4gKwlp
ZiAobW11X2ludmFsaWRhdGVfcmV0cnlfaHZhKHZjcHUtPmt2bSwgZmF1bHQtPm1tdV9zZXEsIGZh
dWx0LT5odmEpKQ0KPiA+ID4gKwkJcmV0dXJuIFJFVF9QRl9SRVRSWTsNCj4gPiA+ICsNCj4gPiAN
Cj4gPiAuLi4gUGVyaGFwcyBhIGNvbW1lbnQgc2F5aW5nIHRoaXMgaXMgdG8gYXZvaWQgdW5uZWNl
c3NhcnkgTU1VIGxvY2sgY29udGVudGlvbg0KPiA+IHdvdWxkIGJlIG5pY2UuICBPdGhlcndpc2Ug
d2UgaGF2ZSBpc19wYWdlX2ZhdWx0X3N0YWxlKCkgY2FsbGVkIGxhdGVyIHdpdGhpbiB0aGUNCj4g
PiBNTVUgbG9jay4gIEkgc3VwcG9zZSBwZW9wbGUgb25seSB0ZW5kIHRvIHVzZSBnaXQgYmxhbWVy
IHdoZW4gdGhleSBjYW5ub3QgZmluZA0KPiA+IGFuc3dlciBpbiB0aGUgY29kZSA6LSkNCj4gDQo+
IEFncmVlZCwgd2lsbCBhZGQuDQo+IA0KPiA+ID4gIAlyZXR1cm4gUkVUX1BGX0NPTlRJTlVFOw0K
PiA+ID4gIH0NCj4gPiA+ICANCj4gPiANCj4gPiBCdHcsIGN1cnJlbnRseSBmYXVsdC0+bW11X3Nl
cSBpcyBzZXQgaW4ga3ZtX2ZhdWx0aW5fcGZuKCksIHdoaWNoIGhhcHBlbnMgYWZ0ZXINCj4gPiBm
YXN0X3BhZ2VfZmF1bHQoKS4gIENvbmNlcHR1YWxseSwgc2hvdWxkIHdlIG1vdmUgdGhpcyB0byBl
dmVuIGJlZm9yZQ0KPiA+IGZhc3RfcGFnZV9mYXVsdCgpIGJlY2F1c2UgSSBhc3N1bWUgdGhlIHJh
bmdlIHphcHBpbmcgc2hvdWxkIGFsc28gYXBwbHkgdG8gdGhlDQo+ID4gY2FzZXMgdGhhdCBmYXN0
X3BhZ2VfZmF1bHQoKSBoYW5kbGVzPw0KPiANCj4gTm9wZSwgZmFzdF9wYWdlX2ZhdWx0KCkgZG9l
c24ndCBuZWVkIHRvICJtYW51YWxseSIgZGV0ZWN0IGludmFsaWRhdGVkIFNQVEVzIGJlY2F1c2UN
Cj4gaXQgb25seSBtb2RpZmllcyBzaGFkb3ctcHJlc2VudCBTUFRFcyBhbmQgZG9lcyBzbyB3aXRo
IGFuIGF0b21pYyBDTVBYQ0hHLiAgSWYgYQ0KPiBTUFRFIGlzIHphcHBlZCBieSBhbiBtbXVfbm90
aWZpZXIgZXZlbnQgKG9yIGFueXRoaW5nIGVsc2UpLCB0aGUgQ01QWENIRyB3aWxsIGZhaWwNCj4g
YW5kIGZhc3RfcGFnZV9mYXVsdCgpIHdpbGwgc2VlIHRoZSAhUFJFU0VOVCBTUFRFIG9uIHRoZSBu
ZXh0IHJldHJ5IGFuZCBiYWlsLg0KDQpBaCB5ZXMuICBUaGFua3MuDQoNCg==
