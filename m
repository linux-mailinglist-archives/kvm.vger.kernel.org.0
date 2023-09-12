Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDC079C373
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 04:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbjILC7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 22:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241079AbjILC7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 22:59:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDAD2D75
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 17:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694479674; x=1726015674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4DpadCgt9K2fz5M9kbK76Ypc/sBVv4F+qpdVA36afKo=;
  b=bQ3noo3V2wRtOW9QRpzdB3rV3su8Jvf+rQFeBcGDTEYmHLuhVUE8CqcC
   9VsELM68AQ/e9Ceg7BI4uGQUA/OCmnqfKQx+MjVjoUqeSs64C4L+ou8Sl
   5VYgr2Z/WdaqZs35ztmS60P8O8EuELRsOEMuQecIVXTft2gg0IIq4lxAX
   BIQ2fJAkoCBm/Yj09+xnh5mqd+LJdfWp+BVsfaTA1HYLtoAgOU6LUhZdT
   WA1PR59ZoTnAmDrgU0fYyLannQqVtdz6LuqbAGrCfD8oNHaVRnBWc+fSM
   +uMGVuqTlhyvaGh0vGWDpFdL+pre9uVYtKG8M+PsBPzl+0sXdSqF8Ydhh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="380945604"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="380945604"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 17:45:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="917234756"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="917234756"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 17:45:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 17:45:34 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 17:45:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 17:45:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 17:45:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUurMSQW9dztnUwJjL6X18xaJL7Ik6IMVzv7rfYSDlFsNJ17qNHWlXtBqzGP/p5fI7/8O02bEClPDhHuCd2wsek4LYeB47pbe8RGOjMEW8/iAefCkqiSEV7pfkBVEJKhDK3uJ+VJ2Y392gAfH2Cyz4sogSE6dAu8Hb6Je+A58dy5Towg/o9BjiuU4Vg3zjBTc6LqIZqCfkSYwfVNzzrWUTZXAfrrq6L2GTGonBlRKvru22gnOSZT+izqqtlVhX9ZPR/9PSLkTFVZhzNtnr6c4rJzec7mYmEPLQdkC64aZfh2QifnUWcqdHdSbAsi3h0A2Ps+vYP4bA41kHqLesXmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DpadCgt9K2fz5M9kbK76Ypc/sBVv4F+qpdVA36afKo=;
 b=XIIilyzmANyN2PO/NrlMOAHvx6R4gaMx7KPbtZB5t4vtt/vuxPR6XsJLyGWsVOiviZBLybTJ/0joXbhO0KqcALuQ9Re/4imwlj0ZrVAv/qyhMgsE+3hYYvYSoE31m4nKuDRWWLR+8VLGD3pkoB3iCd48vGOgVRBBWWxXZ2vAVYCUTgeWger1YIx0qO9B8hjjsQzmZ1hQKUQbUfO0Q7BIIqPH78/PQNC9r+es8zktV7DEaPNSoD11A4Cdym1uqh0IsxSiBODWwU2m83jeZWC6258e7W0fgQYDt5cJli09KgQp9yJJcWMKmLgAjJlb6FzloARn8RmnIoAwpTZtqWR0Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by BN9PR11MB5275.namprd11.prod.outlook.com (2603:10b6:408:134::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Tue, 12 Sep
 2023 00:45:31 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032%7]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 00:45:31 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: RE: [PATCH 5/9] KVM: x86/pmu: Check CPUID.0AH.ECX consistency
Thread-Topic: [PATCH 5/9] KVM: x86/pmu: Check CPUID.0AH.ECX consistency
Thread-Index: AQHZ3KYWq0UgcnuPOk+AuGokoy2lbLANlBMAgAjXD5A=
Date:   Tue, 12 Sep 2023 00:45:31 +0000
Message-ID: <MW4PR11MB5824D367E8363B671B5307CCBBF1A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-6-xiong.y.zhang@intel.com>
 <276c9031-8d1e-f86b-b5d4-bb9af47e7b88@linux.intel.com>
In-Reply-To: <276c9031-8d1e-f86b-b5d4-bb9af47e7b88@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|BN9PR11MB5275:EE_
x-ms-office365-filtering-correlation-id: 91eb2833-a5b7-4a05-62a0-08dbb3299103
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KLl0jNspRrGrCIOcF2BX2iEWkPZzhHLJjdQSNO4tAFQn1UNE0S7aQZ5v6u6LRmRl7YkIW9moyi6JWKJtE3aDiaMJEQjAMDMKvysZXpI/D8t/TBuGjq2ZQZdvCM8s+1ZTG3553hrbvTQFhnaOZ1IhkdEZ+WFNcAfSsZj5ZFpXEN+uBsZC8ihIJalfBckwmUGRDrPahzaB60fFPiLyqutA0qTgC8yHp/LouMzg+f1q3JjtmxVIIWfn00v3MxNpXy+/HhX3lBOwVNpQ2D+1tirFzc8VnPEi2VK9yaWAx3bNzg4w+ppWdFYEY/MJybKgH8iCs0LbA3pyfo2qsLH8Aj8jDaPCOw+DxoplGO5araelK0lAx3BHR4ksy1NgXuesZDdxT0sboMrOA4pW9gEr2ksDpObDk6SoiOHejbmKLMwu8ZqG3PotBKSp2nuqIeTHsLYvNaQ6amTSel5WRiv+7X77aZy2njft8VOm/nyKmFAqkp3l/OJaQwXkjaMQNqwYdWkYFjyCgH36OYN7P7oFhbu5WFuPiftEmq5l7Vp6SD/53ezuwUY8xH126TmF6ojVEyU1DcP52DZNoI39sVUEATXWMVotE9/lTO74MVvDNRy0mVEbJH98WOlX6tTN/yEleSpX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(396003)(366004)(1800799009)(186009)(451199024)(76116006)(110136005)(26005)(2906002)(7696005)(71200400001)(6506007)(53546011)(33656002)(9686003)(82960400001)(38100700002)(86362001)(122000001)(55016003)(478600001)(38070700005)(4326008)(5660300002)(52536014)(8676002)(8936002)(66476007)(66556008)(316002)(66446008)(54906003)(64756008)(66946007)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnlKaGlpYTByUThnRWY3V3ljS3FCMVFwY3o4T1RSbGR1TW16L0RHSTJxMGx0?=
 =?utf-8?B?TGVldlFDVUJDdnN4RDBhVEFZOE9CKzhTb0JJbit0OGpqU3lYNUxRdFc5V1Vv?=
 =?utf-8?B?ckxYd2tiR2ttZTBhb3Z1NGtqU0p0NjJNWm12UjBNUzdEUnVwd3B2UWt1K09Y?=
 =?utf-8?B?aldtYTllaGRWbSs3cHUzbEdmSUFEK1dEVG55QXVlbVQwcnlNYjIrUzUraEtL?=
 =?utf-8?B?UFZxQTFrMXJFaUk3bEFxZmpEa2w3blRUZzkyWTRNRVpZVElUY3dmbVVYM0gz?=
 =?utf-8?B?OHlmR1FKOFlhYkRtVGRWdS9PTG12aUZ0a093dlg1WEIvWVdBdHZiMkJHYXZC?=
 =?utf-8?B?QnNuUlk0anl3aDhxVnNwRzJld0dMVm1aMWZ2R3hVRVNVSWZVcDE2aGIrVmNy?=
 =?utf-8?B?WmdZVWpKSWdyb3kvNFhhYlhnVU1oMDFvMEFUZG5rMU8zMVh6KzdiQ21Eak1p?=
 =?utf-8?B?YmJWRVhxOHI5UkpyMGxQeTYrcXpJWW4xZTNmdjIwaFVMN3UxZUpHUVpRTFEr?=
 =?utf-8?B?QmkyWENIb2haRXpUZTd2ZHYvUUEzaGJNMGpRQlBCV1k1NnV5N0VFb1VHbVND?=
 =?utf-8?B?enI5ZTVYRHhZeC9oODhlSDUyVU1pSWtlWGM1MGZ5MDZyWnFaVlRETEp4TEtH?=
 =?utf-8?B?VUZUZ0svaEdsRzlEcXg0YkpBNnNscC91VkpIUHk1ZXJ2T3ZFT0k4RWN0YmVO?=
 =?utf-8?B?eWQvT2tNTXlQb3AvbjNtZGdIV1RzaXZvd3BKWlkyR2FwVmpCWnJjZWtBWVV6?=
 =?utf-8?B?Wnl5NUJ6TDJVeXRLQUg4bHl1RG1SMUdUOE83ZHErSGsrRUtrbitGS2NMcWdt?=
 =?utf-8?B?VytQSXhqZW1HWUd1aDRwWDg3ajNJMkRUVXVzQU1KQnUvZkxzaWJUNUtoRCsy?=
 =?utf-8?B?NXRrNGdTdm41NzdrVUtUZnNlOWg4b1laT3hCT3VoZitVM1dRTlE3WWI1Vllo?=
 =?utf-8?B?amVzR2JwSllkaU1ndVo0Ti94QndkdkZBRXpmdjBYc2ZYSzRWYnZ5TWFsSm8r?=
 =?utf-8?B?YTBkMitsL0Y4dkFrUnVwamhTTTFYWHVZTDlYVEFuR0k5dk0xV0ZSc0Z0Z2RU?=
 =?utf-8?B?TTJoWVBPdm53N0p1dktWZS90Z0pSS2k5Y2hHN0tybi8yNzV3eXQ1RDNqY1h4?=
 =?utf-8?B?KzQvSVpML0lxbGswNFkzSFN1K0hhTU1RUWNuUjBtY3lhVU80RHJzVm1lK2dD?=
 =?utf-8?B?ZlhnYThOVGZRRnFQKzhCUHlhOXpsUXp0dElMa09ZYmhEd25rUThYQzFnVjZy?=
 =?utf-8?B?UGh1NktXU0J6RjBUWHFGWHQ0NUtRbUJUZ1AyTnVMZkhsWkFDM3Aydk9lUGp2?=
 =?utf-8?B?Tzdhb1hyNFoxdVRLZHk3NDNpL0RMU2lqN25Rd09OVWlkUHk4MkhBY0lwZkVy?=
 =?utf-8?B?OFdFVnROVkY1TmZzVnVyR05kRVdORFJEVnlpRWptR3g1dUx0cVdmZUxHT01q?=
 =?utf-8?B?Z2NGdk1pUXBxM1dMdjRMVjJxc1FTWFlNaG9XU2M0R05IY0lkTHhFKzErY09p?=
 =?utf-8?B?QWVLWGhWOWswMHdCTUpsSENJVVlGQkFWQzJMcVhub1M3N0xoRUppaFkrS3o1?=
 =?utf-8?B?K2pweTRwZUs4V2lLdHdFMWJ6T0lYL05ZUUJuUHpxM0VzcXlLSGxkblc1cWN3?=
 =?utf-8?B?NkdVN2ZKU05zRUJFeisxZ0c1T3pMbmFnMFArYVNwYTI5OWxKRXhnUEFlMGhi?=
 =?utf-8?B?Um13dlJybG5mSm1GeWNpMi9iZ3cwYVppUmN4clFOSktMcVJWOCswdTlDVUxT?=
 =?utf-8?B?dlJvU2dDUW0ybU0zcDcrTHIwZlVDTjh2WitpcE1KZ1hyOTAvenpReWpKa3pw?=
 =?utf-8?B?cDRsRExpT1AyN2NhUG9DREw3S1NQK01NUGpFYWJDbGhoYjRrd1FjTkRPdWtn?=
 =?utf-8?B?dVVXbWp1cjRVbERKaFNQblIyYzhjeHAybmcrVm50dTRZRm5jMU9IdUw4UnV1?=
 =?utf-8?B?UGNZc3BpVmFnL0dVN1ZNdFFuR1hXYU95bnNZU1RPbmRmeExZK3luQ2toTWtw?=
 =?utf-8?B?SlFwZDJHM09uNFlRRnRPUVo3Um9MRFEvejVEVVY2SzNjVzdVaW1DMERJVXky?=
 =?utf-8?B?Nk1za1g3cmxhNC8vb3VaWGFhMjZ4eGtDaGJkZHF4Z1JWK3QrWG5LWlZaWnpE?=
 =?utf-8?Q?X+ptKcF3iX4j5TUuEWxqBSaRI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91eb2833-a5b7-4a05-62a0-08dbb3299103
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2023 00:45:31.0438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ITcNQQuWnhYMmt8PzMek2oSo2gz6TCNadNGq3RRYZ7M7WXE2i4XiuBvfliOMEgDVE0I48MFAQnZALqm/OIW5Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5275
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiA5LzEvMjAyMyAzOjI4IFBNLCBYaW9uZyBaaGFuZyB3cm90ZToNCj4gPiBXaXRoIEFyY2gg
UE1VIFY1LCByZWdpc3RlciBDUFVJRC4wQUguRUNYIGluZGljYXRlcyBGaXhlZCBDb3VudGVyDQo+
ID4gZW51bWVyYXRpb24uIEl0IGlzIGEgYml0IG1hc2sgd2hpY2ggZW51bWVyYXRlcyB0aGUgc3Vw
cG9ydGVkIEZpeGVkDQo+ID4gY291bnRlcnMuDQo+ID4gRnhDdHJsW2ldX2lzX3N1cHBvcnRlZCA6
PSBFQ1hbaV0gfHwgKEVEWFs0OjBdID4gaSkgd2hlcmUgRURYWzQ6MF0gaXMNCj4gPiBOdW1iZXIg
b2YgY29udGludW91cyBmaXhlZC1mdW5jdGlvbiBwZXJmb3JtYW5jZSBjb3VudGVycyBzdGFydGlu
ZyBmcm9tDQo+ID4gMCAoaWYgdmVyc2lvbiBJRCA+IDEpLg0KPiA+DQo+ID4gSGVyZSBFQ1ggYW5k
IEVEWFs0OjBdIHNob3VsZCBzYXRpc2Z5IHRoZSBmb2xsb3dpbmcgY29uc2lzdGVuY3k6DQo+ID4g
MS4gaWYgMSA8IHBtdV92ZXJzaW9uIDwgNSwgRUNYID09IDA7DQo+ID4gMi4gaWYgcG11X3ZlcnNp
b24gPT0gNSAmJiBlZHhbNDowXSA9PSAwLCBFQ1hbYml0IDBdID09IDAgMy4gaWYNCj4gPiBwbXVf
dmVyc2lvbiA9PSA1ICYmIGVkeFs0OjBdID4gMCwNCj4gPiAgICAgZWN4ICYgKCgxIDw8IGVkeFs0
OjBdKSAtIDEpID09ICgxIDw8IGVkeFs0OjBdKSAtMQ0KPiA+DQo+ID4gT3RoZXJ3aXNlIGl0IGlz
IG1lc3MgdG8gZGVjaWRlIHdoZXRoZXIgYSBmaXhlZCBjb3VudGVyIGlzIHN1cHBvcnRlZCBvcg0K
PiA+IG5vdC4gaS5lLiBwbXVfdmVyc2lvbiA9IDUsIGVkeFs0OjBdID0gMywgZWN4ID0gMHgxMCwg
aXQgaXMgaGFyZCB0bw0KPiA+IGRlY2lkZSB3aGV0aGVyIGZpeGVkIGNvdW50ZXJzIDAgfiAyIGFy
ZSBzdXBwb3J0ZWQgb3Igbm90Lg0KPiA+DQo+ID4gVXNlciBjYW4gY2FsbCBTRVRfQ1BVSUQyIGlv
Y3RsIHRvIHNldCBndWVzdCBDUFVJRC4wQUgsIHRoaXMgY29tbWl0DQo+ID4gYWRkcyBhIGNoZWNr
IHRvIGd1YXJhbnRlZSBlY3ggYW5kIGVkeCBjb25zaXN0ZW5jeSBzcGVjaWZpZWQgYnkgdXNlci4N
Cj4gPg0KPiA+IE9uY2UgdXNlciBzcGVjaWZpZXMgYW4gdW4tY29uc2lzdGVuY3kgdmFsdWUsIEtW
TSBjYW4gcmV0dXJuIGFuIGVycm9yDQo+ID4gdG8gdXNlciBhbmQgZHJvcCB1c2VyIHNldHRpbmcs
IG9yIGNvcnJlY3QgdGhlIHVuLWNvbnNpc3RlbmN5IGRhdGEgYW5kDQo+ID4gYWNjZXB0IHRoZSBj
b3JyZWN0ZWQgZGF0YSwgdGhpcyBjb21taXQgY2hvb3NlcyB0byByZXR1cm4gYW4gZXJyb3IgdG8N
Cj4gPiB1c2VyLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWGlvbmcgWmhhbmcgPHhpb25nLnku
emhhbmdAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYva3ZtL2NwdWlkLmMgfCAy
NyArKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAyNyBp
bnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2NwdWlkLmMg
Yi9hcmNoL3g4Ni9rdm0vY3B1aWQuYyBpbmRleA0KPiA+IGU5NjFlOWEwNTg0Ny4uOTVkYzVlODg0
N2UwIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS9jcHVpZC5jDQo+ID4gKysrIGIvYXJj
aC94ODYva3ZtL2NwdWlkLmMNCj4gPiBAQCAtMTUwLDYgKzE1MCwzMyBAQCBzdGF0aWMgaW50IGt2
bV9jaGVja19jcHVpZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gICAJCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gPiAgIAl9DQo+ID4NCj4gPiArCWJlc3QgPSBjcHVpZF9lbnRyeTJfZmluZChlbnRy
aWVzLCBuZW50LCAweGEsDQo+ID4gKwkJCQkgS1ZNX0NQVUlEX0lOREVYX05PVF9TSUdOSUZJQ0FO
VCk7DQo+ID4gKwlpZiAoYmVzdCAmJiB2Y3B1LT5rdm0tPmFyY2guZW5hYmxlX3BtdSkgew0KPiA+
ICsJCXVuaW9uIGNwdWlkMTBfZWF4IGVheDsNCj4gPiArCQl1bmlvbiBjcHVpZDEwX2VkeCAgIGVk
eDsNCj4gDQo+IA0KPiBSZW1vdmUgdGhlIHJlZHVuZGFudCBzcGFjZSBiZWZvcmUgZWR4Lg0KPiAN
Cj4gDQo+ID4gKw0KPiA+ICsJCWVheC5mdWxsID0gYmVzdC0+ZWF4Ow0KPiA+ICsJCWVkeC5mdWxs
ID0gYmVzdC0+ZWR4Ow0KPiA+ICsNCj4gDQo+IFdlIG1heSBhZGQgU0RNIHF1b3RlcyBhcyBjb21t
ZW50cyBoZXJlLiBUaGF0IG1ha2VzIHJlYWRlciB0byB1bmRlcnN0YW5kDQo+IHRoZSBsb2dpYyBl
YXNpbHkuDQpPaywgZG8gaXQgaW4gbmV4dCB2ZXJzaW9uLg0KdGhhbmtzDQo+IA0KPiANCj4gPiAr
CQlpZiAoZWF4LnNwbGl0LnZlcnNpb25faWQgPiAxICYmDQo+ID4gKwkJICAgIGVheC5zcGxpdC52
ZXJzaW9uX2lkIDwgNSAmJg0KPiA+ICsJCSAgICBiZXN0LT5lY3ggIT0gMCkgew0KPiA+ICsJCQly
ZXR1cm4gLUVJTlZBTDsNCj4gPiArCQl9IGVsc2UgaWYgKGVheC5zcGxpdC52ZXJzaW9uX2lkID49
IDUpIHsNCj4gPiArCQkJaW50IGZpeGVkX2NvdW50ID0gZWR4LnNwbGl0Lm51bV9jb3VudGVyc19m
aXhlZDsNCj4gPiArDQo+ID4gKwkJCWlmIChmaXhlZF9jb3VudCA9PSAwICYmIChiZXN0LT5lY3gg
JiAweDEpKSB7DQo+ID4gKwkJCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArCQkJfSBlbHNlIGlmIChm
aXhlZF9jb3VudCA+IDApIHsNCj4gPiArCQkJCWludCBsb3dfZml4ZWRfbWFzayA9ICgxIDw8IGZp
eGVkX2NvdW50KSAtIDE7DQo+ID4gKw0KPiA+ICsJCQkJaWYgKChiZXN0LT5lY3ggJiBsb3dfZml4
ZWRfbWFzaykgIT0NCj4gbG93X2ZpeGVkX21hc2spDQo+ID4gKwkJCQkJcmV0dXJuIC1FSU5WQUw7
DQo+ID4gKwkJCX0NCj4gPiArCQl9DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICAgCS8qDQo+ID4gICAJ
ICogRXhwb3NpbmcgZHluYW1pYyB4ZmVhdHVyZXMgdG8gdGhlIGd1ZXN0IHJlcXVpcmVzIGFkZGl0
aW9uYWwNCj4gPiAgIAkgKiBlbmFibGluZyBpbiB0aGUgRlBVLCBlLmcuIHRvIGV4cGFuZCB0aGUg
Z3Vlc3QgWFNBVkUgc3RhdGUgc2l6ZS4NCg==
