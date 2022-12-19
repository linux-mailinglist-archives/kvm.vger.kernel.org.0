Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308B3650C85
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiLSNPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 08:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiLSNPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 08:15:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B89C3B;
        Mon, 19 Dec 2022 05:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671455746; x=1702991746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=31Y8cjYkHc5P/oyzCmVV6AYWebODhVsImhTKLltT2hI=;
  b=Aaq7qmyKioQ5uwz9sQ6GcH9tDYXQaWDoI41MUGuQZUecn2jhyMWAZ4qV
   mlwDeB0k9jC72S+EmHX6NsQ+kiyCyPzR+50L4mKs2EJYKAT0zD02g+wrM
   jfD98/7Q8/5Gv1MTGBhTybemX6qx10gRrAjG71/k3ERh/H5hGBdTmZH7z
   F0PcA8ygYB80dXz8+sh30eYqETwmc5oylcnC0Yd53fUe06eLZnCZu+peM
   7CDpbt7fTcqEFjOaVrJ2JXEJNhKwN9Ped2pOZpvEZMC1i79PGPODv2Nll
   pmxGnWFwAMrFGvQ5GXdJ8jrphGNPBn0lDthb62h8ZoDVNBl97WMVkQzfL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="302770051"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="302770051"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 05:15:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="792879077"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="792879077"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 19 Dec 2022 05:15:44 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 05:15:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 05:15:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 05:15:43 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 05:15:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBxyWZcpFtFDWG19TexA84zeg81SSH9UZDexGbWObIIa43INtPJkWsdBajKNrtXERE03YrLadAWVAssXZSfl+LTLlmjG4gAXiJQ0mmQRtS3/qnW4WDc7ivQ3qWPAl7oAeR5HnKnFvyP4NBtdLehUtortWcLCzcwtKTAO0S/seTh8ap6lKst5seJaGF7Ep69CsZaQWpZ4pDJjQd6fwLvC3hV4NvAJsREZiIdwKvMo9nPSW6ZI3ETB65uakUn1Jl5C2I/gM1bbU6ansWiH5mtBwTyF0xGhub4bAae58T/upWqXpHc1ZpqXxc59hXV615xNmOh5aPUN/czDh60Cwlbs/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31Y8cjYkHc5P/oyzCmVV6AYWebODhVsImhTKLltT2hI=;
 b=epfIhjbV1Ve3eE44cSltWS6j5glb8XxnSNMr7+UcAqdWwYwwrmW3331A7zrs3N4fGAiQeGkXwj/fMtWWGpmWURPCvM1ff6q1lCf5acfvsqcjBxY3it3VodexG3oOgkI7y988hFafbLtuMdNikXhFZFffxYzl0z7nBmHEbf8QAVAioD3hQ4rDK0Is0A/S7w1JfEFpFc/YvHYlVF2fwsnDAF3BRDlCmmSD0zq6DC1uBYLZ1bBkdaPPy1W37GVm3gSDxHgu7ShyhYP9o1E4QtjUvmFXAWshsbWuMatJL+d5lw8ZpAc+Hdkv0a8y1615xCre5nI+ZYBX0bp1j7XyDxwN4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MN0PR11MB6229.namprd11.prod.outlook.com (2603:10b6:208:3c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 13:15:41 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4%5]) with mapi id 15.20.5924.012; Mon, 19 Dec 2022
 13:15:41 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: RE: [PATCH v10 052/108] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Thread-Topic: [PATCH v10 052/108] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Thread-Index: AQHY7CiJasKThqRaDEOPq0Yx+uNQTK5exgOwgBEZi4CABSWmcA==
Date:   Mon, 19 Dec 2022 13:15:40 +0000
Message-ID: <DS0PR11MB6373806C09D92197635FF46CDCE59@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <32e2f5f567e1af3858e2896d705b66f90a908ff0.1667110240.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373E6562F6F0CCC92CF8A22DC189@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20221215232119.GJ3632095@ls.amr.corp.intel.com>
In-Reply-To: <20221215232119.GJ3632095@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MN0PR11MB6229:EE_
x-ms-office365-filtering-correlation-id: dc3bfc2f-c6d8-4154-e55f-08dae1c320b4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vip/pCcEVD0Pk2j+t5rufopoGw/UO1esxk1M+tRRLyzjzbQP1SYN8GxNXAdJKFYAjMIoyFBYMiWV4ShlkHPW9zcBAGvajXYynXkoiEgOOJ0EhqLaLX1LgVNer+TNFnv4hSBByPsmL+8RZrZApMAoakS01IR9r8MR5m5k9PxS4q7wVDo4TKUqWOcdibru80kRpbAidFG64lOEmLH98cdbvJSDBth0vQeW2y86lxV8qGizbApxMTYmfn9I7eEmNbXtd9ZwZsrjMQHA+ShUxFlspCsDzKFmClalrofrF9t8SozycDJ9to3NFzx9CgnUXN2L+O42/7FhddmEB3DrBEIZZvXK4z2BP0OBlchcWTMf+cCgzh7Q8VDieZBMQfAQgucy/Up0CQjmmiptmh7EvTOXtqUNutAXBt/9uw6aRpb1H5uMM5C2xjA8GHZ+7HBrf8w8GGANxncPDLigKF6Gu3op2qCx8JMkyaC2v2FAdl6Yz5yoY43Pg4GLQYUsIfDVO+PpyrkHs5BcQ7vafIHULTtWaw4brrZavJRIj6eEN2eYS7aKVS3674do1ih8EgzYl5o8Xctvrx+GJOlKlUb3QcWpp1cAuWIHM6+o5BicOHgbwUcZPbZT8cnG19nBZ5o8xrDeI6GR88dE7qrLD1DhDAiMW33B5dmnjNOraxtdy2qrIC7FyRbsqybDEJdI6b5rh8z5Q7CiB5lfsEzxr//0iuoa6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(82960400001)(478600001)(66446008)(76116006)(66946007)(66476007)(186003)(9686003)(8676002)(8936002)(64756008)(4326008)(86362001)(52536014)(26005)(71200400001)(41300700001)(83380400001)(53546011)(5660300002)(7696005)(6506007)(66556008)(38070700005)(6916009)(316002)(54906003)(33656002)(122000001)(55016003)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXNEdlA5VEs5bVR6NjhVWHJKSEYvWDNXZlFSakVZOGFDemlBakltYk1nRVlH?=
 =?utf-8?B?QWFob0d3aFpQM0FEVkFYU1hIM29DVmp1UWhEcWNkaHpRUTdvNFNGZ2x6S3RF?=
 =?utf-8?B?WVd4Yi84d1Z6OTkxcVp1ZUhzd3N5MFFZRTF3YmJnNFVyZ3pEQXVURnAxbXYz?=
 =?utf-8?B?STU5RDhRN0lkcVdoYUxWY2NBbEJIdmQvOTVjc2s5Z1h4WHZ0VWRhZDlscjFY?=
 =?utf-8?B?Sm5DMnl5K2lWTU1UN2lRY2J0ekx1MU01RHM1czE2YWFFMGZBVUtIcUo0cEVS?=
 =?utf-8?B?TGhNeUI0aUVvT3UyOWVjcGJuZitqTSt6RXlCUHc1NVYrZGxqTi92dWV5clJY?=
 =?utf-8?B?ZjR3VCtaOXBSYzhMUmtKdXhHekcxaTFtb1M2Z2UyV3Q0L3pENFdRN3pMbmRM?=
 =?utf-8?B?dVlDS1U3alp1Q0J0aVFFcTdlY1hzZ29DM0dCaEhKdDMrSmFjM2dSa0ZuTGdl?=
 =?utf-8?B?OFFrZHNwSDNVRmJTeWNzNnp6Rmh2ZXVPS3FQZlZhemU5b3dEQVN5WlBJb3JQ?=
 =?utf-8?B?ODY2RXNqMDJhTDdVNmFmQUxJQll5ZWlLT2N0bkxHR0Ftcyt4S245MEhoMEwr?=
 =?utf-8?B?TUszb0dwSE9DUXViWlJ0Vko3NzUrWGZHRzk5bFhVVW5sa01CVDVZbHZqdWg0?=
 =?utf-8?B?bW02dWxEa3AxYk5CTE1kL3JydXJmOVorSkpjVENJVEdiNzYxYXZVK1AzWFNs?=
 =?utf-8?B?M2ZZdFJORmZQR3VZVnRjUmdQREdwbkQ5ZFJjM3NqUzl6TWVkKzdWQjFQMnMr?=
 =?utf-8?B?UisyeUZlN0hWc0lkOHJPN1NQSzlaY204emRjUEV1M0s0d25TQkpHdlN0cG1K?=
 =?utf-8?B?RkRSczA4d3krQ2VvN2k3T0RreDNUdmcxUXBScFBKc250eUVDRXFpQ0tsN1kv?=
 =?utf-8?B?ZHlaUkJVUFkzTDQrd3ZnUlNQdFUzaFhma3hJQkR5a2prVzBvTnJrell2NXBw?=
 =?utf-8?B?Z1ZyVXNxY0hjS0NteS9LbjlNYXZPVjdheHd3RzNkN3A5VU45S2dFOWxHY0lO?=
 =?utf-8?B?dHNJV25DSDcyOXBESU0yakdRTzNSYzBiYURDODZIci9XczlvK3M5cXUzd3Ja?=
 =?utf-8?B?WDNacElzdGJENWxwZ3V1bVpHUVdWdUhsQ3U4WFlSV3VNK0dhbW9acDZWcE10?=
 =?utf-8?B?QjRFVWRrVmhRZTNKSkdSRWV1TTNla1VXbzBBSTVndTlDSzNVN2pRVHlJbnk1?=
 =?utf-8?B?a2tLUWNENHh4Vmk4Q243dGlWQ25KK20xajl4d0pmVUhuUVp6MXJTNkF6K0du?=
 =?utf-8?B?VEl1SXhmaWF5TmdWTXBsMEgrS05MbXJoNDVqV2VZSHhqTTBMclVjVWdNd1BB?=
 =?utf-8?B?RGF6NWtoN0tPQjlIbzNEMm9YVHF4ZUNpeGF4cGVJR1ZiT0RORUVXcm04TjRq?=
 =?utf-8?B?VE5aYmpGdFR4eldSZEZlMDVIeTdXcjY4dWpmOVZJY21TWms1WjVnRmxPMXlk?=
 =?utf-8?B?eHpjcWZUM2c1L3FvdTdoYWhYbGhSaUdXekRnMTh2ellyWXBrSjBLb29CczdV?=
 =?utf-8?B?L29vc2tlY3lyaEhaTEpwcXhEcE9QVHVIOUJvTVBsTUNDeFNTN3lVREpNNkVl?=
 =?utf-8?B?R3MxaW1pQXNRNk5mVVEwMmg5MG14MkNYNVU4UnlKaFQyT3BreEFBQTg3TWFD?=
 =?utf-8?B?Tmwvcm1YNDdFUHpxbU5OaUNKL1dSSzhCci9Fc3J6YnZPYysrUks1YzVrUTlC?=
 =?utf-8?B?UmZrQ2pDVnpvRElBU2hQVU1xV0xjVWhoNU1RVVF2eWNoYkNrRVlNaks4Z3J1?=
 =?utf-8?B?eHphVVg4SGZzOVVTZ0ZwR2dLQUpocW1WWVFta1MvRkpUamdERGUxc3MyVmVU?=
 =?utf-8?B?MmJXeVh0cjdWOTUrSWxXUWVQa1p2dTRWQkVyNmZpcnpMTG9rL1VUWTVOK0t4?=
 =?utf-8?B?aE1qRXpPV3QrL2NlMGU3ME5HcmswUG8wVkNvWmhRQ2VJcVdkV3hIRm4xMXNr?=
 =?utf-8?B?Y1ZPRXZiSERYRnNVV2xaS0lab3F2Zk5id3A5YURLVUcreS9HajFmSnZ1UXU0?=
 =?utf-8?B?Y3J3SDhHL01SN2g5bWZ2SkVEQThiSlZNT0ltZkk4WFUvTTFwOWNqd2NBcm1J?=
 =?utf-8?B?dWE5NmJVMWtIVzh3Mnl4ZXhMemdwNkZrdHYyRFZXYWpwWWVRTEc1UEVFblBi?=
 =?utf-8?Q?imziHy9Pg89k4jaXO7+/inGus?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc3bfc2f-c6d8-4154-e55f-08dae1c320b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 13:15:40.9632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBhRxbs8kC28HrBtPGt9l4Qd7gSpQmvurh7ltC+x7hdQwiVJ1/mjQ2Ur4SS6bwVbwj0xJJL/GoxutF9fz3vJ4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6229
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpZGF5LCBEZWNlbWJlciAxNiwgMjAyMiA3OjIxIEFNLCBZYW1haGF0YSwgSXNha3Ugd3Jv
dGU6DQo+ID4gPiArCS8qDQo+ID4gPiArCSAqIEZpcnN0IFREWCBnZW5lcmF0aW9uIGRvZXNuJ3Qg
c3VwcG9ydCBjbGVhcmluZyBkaXJ0eSBiaXQsDQo+ID4gPiArCSAqIHNpbmNlIHRoZXJlJ3Mgbm8g
c2VjdXJlIEVQVCBBUEkgdG8gc3VwcG9ydCBpdC4gIEl0IGlzIGENCj4gPiA+ICsJICogYnVnIHRv
IHJlYWNoIGhlcmUgZm9yIFREWCBndWVzdC4NCj4gPiA+ICsJICovDQo+ID4gPiArCWlmIChXQVJO
X09OX09OQ0UoIWt2bV9hcmNoX2RpcnR5X2xvZ19zdXBwb3J0ZWQoa3ZtKSkpDQo+ID4gPiArCQly
ZXR1cm4gZmFsc2U7DQo+ID4gPiArDQo+ID4NCj4gPiBJdCBtaWdodCBub3QgYmUgYSBnb29kIGNo
b2ljZSB0byBpbnRlcmNlcHQgZXZlcnl3aGVyZSBpbiBrdm1fbW11IGp1c3QNCj4gPiBhcyB0ZHgg
ZG9lc24ndCBzdXBwb3J0IGl0LiBJJ20gdGhpbmtpbmcgbWF5YmUgd2UgY291bGQgZG8gdGhlIGNo
ZWNrIGluDQo+ID4gdGR4LmMsIHdoaWNoIGlzIG11Y2ggc2ltcGxlci4gRm9yIGV4YW1wbGU6DQo+
ID4NCj4gPiBAQCAtMjU5Miw2ICsyNjA1LDEyIEBAIHN0YXRpYyB2b2lkDQo+IHRkeF9oYW5kbGVf
Y2hhbmdlZF9wcml2YXRlX3NwdGUoc3RydWN0IGt2bSAqa3ZtLA0KPiA+ICAgICAgICAgbG9ja2Rl
cF9hc3NlcnRfaGVsZCgma3ZtLT5tbXVfbG9jayk7DQo+ID4NCj4gPiAgICAgICAgIGlmIChjaGFu
Z2UtPm5ldy5pc19wcmVzZW50KSB7DQo+ID4gKyAgICAgICAgICAgICAgIC8qIE9ubHkgZmxhZ3Mg
Y2hhbmdlLiBUaGlzIGlzbid0IHN1cHBvcnRlZCBjdXJyZW50bHkuICovDQo+ID4gKyAgICAgICAg
ICAgICAgIEtWTV9CVUdfT04oY2hhbmdlLT5vbGQuaXNfcHJlc2VudCwga3ZtKTsNCj4gPg0KPiA+
IFRoZW4gd2UgY2FuIGhhdmUga3ZtX2FyY2hfZGlydHlfbG9nX3N1cHBvcnRlZCBjb21wbGV0ZWx5
IHJlbW92ZWQuDQo+IA0KPiBEbyB5b3UgbWVhbiBXQVJOX09OX09OQ0UoKT8gSWYgc28sIHRoZXkg
Y2FuIGJlIHJlbW92ZWQgZnJvbSB0aGlzDQo+IHBhdGNoZXMgYmVjYXVzZSB0aGUgY29kZSBzaG91
bGQgYmUgYmxvY2tlZCBieSAiaWYNCj4gKCFrdm1fYXJjaF9kaXJ0eV9sb2dfc3VwcG9ydGVkKGt2
bSkpIiBhdCB0aGUgY2FsbGVyLg0KPiANCg0KQXMgeW91IGFsc28gbWVudGlvbmVkIGluIHRoZSBj
b21tZW50ICJJdCBpcyBhIGJ1ZyB0byByZWFjaCBoZXJlIiwgd2UgY291bGQga2VlcCB1c2luZyBL
Vk1fQlVHX09OLiBUaGUgc3VnZ2VzdGlvbiBpcyB0aGF0IHdlIGRvbid0IG5lZWQgdG8gYWRkIHN1
Y2ggY2hlY2tzIGluIGFsbCB0aGUgY2FsbGVycyBhcyBpdCBpcyBtb3JlIGNvbXBsaWNhdGVkIChh
bmQgZXJyb3ItcHJvbmUpIHRvIGNvbnNpZGVyIGFsbCBvZiB0aGVtLg0KV2h5IG5vdCBsZXQgY2Fs
bGVycyBydW4gaW50byB0ZHhfaGFuZGxlX2NoYW5nZWRfcHJpdmF0ZV9zcHRlIHRvIGRvIHRoZSBj
aGVjayAoYXQgdGhpcyBvbmx5IHBsYWNlKT8gRnJvbSB3aGF0IEkgdW5kZXJzdGFuZCwgd2UgZG9u
4oCZdCBzdXBwb3J0IGFuIHNwdGUgY2hhbmdlIHdpdGggZmxhZ3MgdXBkYXRlIG9ubHkgZm9yIHRo
aXMgdmVyc2lvbi4gVGhpcyB3b3VsZCBiZSBtdWNoIHNpbXBsZXIuDQo=
