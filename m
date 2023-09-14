Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D47A0FEE
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 23:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjINVgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 17:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjINVgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 17:36:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070852705;
        Thu, 14 Sep 2023 14:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694727369; x=1726263369;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sgKgIBrGj1/Xn6TbbU0vatkjnfH9JOPMMgMy/0RfBrQ=;
  b=JXWH19ANOFZ3YPTg0PwuScGIxatOiUiQtMbNUzn+MhF41nbQdm2VD+fk
   102oWl1394OxqwHAXC7UW1o3kBpIKC++8W9XDI68hAW7VYSAKJkm27aM9
   tX8FrBzqXZmcSp9KorezDgYrIRGWXVpvPm8Ss3YKeWcNsBJ1uVCr04uaj
   //qJSUe+Pk2jmwtwBGkSIhut0c+srNVlDy3itLnv6GDjWK0BmAgPpOvqg
   5P+7ZK5nzFn3cG/8bSL0LbYXJUKqXfr18lDpfHuMsGt4n58FHVAnTD5P8
   h3HWf2xAQVYWJwqTQpMnW5uOL/D83W/ZsHMoPhf8izvOaXabNig0nvu0Z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="358497073"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="358497073"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 14:36:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="738054950"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="738054950"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 14:36:07 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 14:36:05 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 14:36:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 14:36:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 14:36:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAwp25exiSnJUX+X+7P8DFrviRY3t3T3Z3mvnbiQ8e0z8VBqUcwsEazk8uF5MQXF1VNz04pCeKaDdJ+/XDW5Wcyg0MNGFb5rji7b8yFTmzMg5AR5s3RVKB4ew4hz0dECKR8YNb8DeimEUMQOvLErjRR5BoWfFH16BF2+2UiYngz4RSno4UWKYLkUWeKzIJV0wRQgVJxLTfpfzczE3FVZkfAjsPWWaH7sMNCZN3Z/KOlyPluB5lTaNYZEShNqpPnVzduYOdtcY+ZUPjgUXqFoqcvxZNWnwbw+T4ITM8ez5mrwSztK14oKsD0qkYCeNgZgDbPh4e5OYeMfpK40F36liA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sgKgIBrGj1/Xn6TbbU0vatkjnfH9JOPMMgMy/0RfBrQ=;
 b=IrmJoJ+JE/xUBHaBfrRVPzjxea+x0F2wA1KoVxIU6zDoTS4s/g1RmCUNpdj+KLJlJx3GkRYGll1mS81R03CSJuNgFujJIpGICpBdOz5705768Un5vSO3OCg3gmFBU2uz+rh2CbxWD1MAC+eAg7j+5dTux0mhJecFBYKMDBJaPc5747FuMpHcOl/UXAhP3DV1NktQZ67wlSPC5wwVUEw+0Qn9LG/aaUbkdx1jHVI9G+uqVevZ+2oFlhlNhoPAZfAkSLST2g5WcEI4ysUw6OD21jt4XWSNhuN19hsHPAw0I14/8IJazcNGVuDGbKAgwQ8ya+bwi9f0PS/zpSebXW8rkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB6961.namprd11.prod.outlook.com (2603:10b6:930:5a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.41; Thu, 14 Sep
 2023 21:36:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Thu, 14 Sep 2023
 21:36:00 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Topic: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Index: AQHZ51Nu5rvrYdY8+Eu3RowU62VYUg==
Date:   Thu, 14 Sep 2023 21:36:00 +0000
Message-ID: <87497f25d91c5f633939c1cb87001dde656bd220.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <12c249371edcbad8fbb15af558715fb8ea1f1e05.1692962263.git.kai.huang@intel.com>
In-Reply-To: <12c249371edcbad8fbb15af558715fb8ea1f1e05.1692962263.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB6961:EE_
x-ms-office365-filtering-correlation-id: 5b324a42-b20f-4000-4f97-08dbb56a96f4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PeI91db3d6zxqarPYIIJsPihM7jC1BYjk7pWR6sJB4nspy3KRt8+7cCenaV6mVcFvCiGZTDMBfB5cw3aqVqCkHjN2u/i2PNYsK2E5FbTnajX3rGhuvb4T80hA9/SgIlCZxx7EXR65j0hGicFD1mdiGByod3+FrV5GNpmzlR5gF+6RN21Pc0znSQL3afM+Gi63P8ulWzUCc0Hj8370ZwPQ1ex5TrqsAi9le7Y/vsLDAM0JnnEHh7TxEvfemOAbwkTXbq2MBC/+x4J/msCCh5F3eOUAGc8l5/Y3MXwJkZr9XVoGiWG7xADSGu335e+lkVraABTRmh02OQ2uadwp4f1tEKQdg1JmssHyWbb6jKUo69YCQuS5HLM7K8dCldTGQBQnVCds/emkpajxwBuogbgoITPRsJxFoQAM1i3V+pn6Sv4rKPBbKrvDNt19SPpHJdoAz3rGhG0Xqh0sonkvqOmG1y6tIFHoTYI1SvLx1e0Demb/9lO/VMt4TQZSi+2k4OHrAVK5ymq9XdxBtayv5ilPh2f6OJEaxZuIs3i9ET2x0ELItVD0CuvAcxpX/kwDOZmPZxkWYDWxrX0Nyq3PcVsHomUo34uY2nrDqipgqnsiO4qSoHBuVLeCYH+3k5mmjPR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(376002)(366004)(136003)(1800799009)(186009)(451199024)(6512007)(2906002)(91956017)(66446008)(66476007)(66556008)(64756008)(54906003)(316002)(6636002)(7416002)(4326008)(36756003)(8676002)(8936002)(41300700001)(5660300002)(76116006)(110136005)(66946007)(6486002)(6506007)(2616005)(71200400001)(38070700005)(38100700002)(122000001)(26005)(82960400001)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDd0a2tpS25nVXkvMVp4TXM3WTJPREJDRVl6T21nQ05PNmVhTm1MdTBodjIz?=
 =?utf-8?B?SHBFb01FeElDUzFOOEZNK2ErdWZxOWQ1R2N0TDdjSmFnSkM3ak0ya2t2dVJW?=
 =?utf-8?B?QWFWMjRUMkw1WVZYaWcxbm5sTWpVbGsxeHlNUGFPNWp1TDAvY1RNRy9jcnFw?=
 =?utf-8?B?V1V6dHRUQkFVbDIzaXJiL3I4Z3kvOGMzNmxKREhpWkZvSU5yY3lmajMyMm8v?=
 =?utf-8?B?M0t0UkdBN0QzL1JKeUk2dnI1N3N2L3NOSFlzWEVmMmZEOXpYU2VSaXAxYTFz?=
 =?utf-8?B?Z2RhdDFYWTR5VndMWERVUnhkTEgrb0UxSFN6TWFHbXJMWGpwVDUwS0d1YU4w?=
 =?utf-8?B?akZUck4xYWgyN056ZkJ6bWlGdlhRSkRrSWFLaWlodFVIb3pScTFFRVdXNnZL?=
 =?utf-8?B?RDUyY2pVVVQ1cDV4Q2pZeEEzaTJGMGxBbExwOERhTnNYOGVaYlBCbmpBZU0v?=
 =?utf-8?B?SnNJcTVNbEN0dlVhVE0xUUtOOENlM2tmeS9ET2packZqRmNIT0FwNno1WEZU?=
 =?utf-8?B?Z0srTHErajRFSk9LQVgwa3RrTUpPZFVDZ2ljQnVPQVJGQXkzN3BueFk3ZFNk?=
 =?utf-8?B?NWlHSE1iczlGemU1Y3pzaGZ3aHZ6Q3VNamRrOFc4R3lGWmxCaFh2Tk92WXVu?=
 =?utf-8?B?OUp3TXF4NXpRWHdLaWxicnBoWFQxNXQ2S0ZNazg1V2xQTFgyVkZBbm03eDl6?=
 =?utf-8?B?NjhIZUsvbGxCYmc2a3AvSWhCS3B5bWtyLzZpTUw3QWJUMFlCQ2k4R2E4Z1JR?=
 =?utf-8?B?K1prTE5nYThGWThwV2tndkIrZ2Z5SDF0MVRFaFpDckZDaEQ0bFJVbnNoSEdG?=
 =?utf-8?B?cTdzWUdvNTllejBLMEdPM1FDL0ZZRnhXWWFJRlh3UTRwejE0SENHTnZEcWIz?=
 =?utf-8?B?Sm9jMmtDQjJCOEtuVGZycEp6ZFJ4QWdvTVhJU2ozV0pWRXliR0dWVVFkcndp?=
 =?utf-8?B?YjZsOTlQUklQd2ZPUm9sNUlXWms4QnkxZDJlMEg4Tm5LM0RJTlM1KzhtVmpa?=
 =?utf-8?B?N3p0WnBUVzZFRGhSb25SS1RuM3BlaE1XNHlKOWVIVVYrUEovUzA1NDI2cGVE?=
 =?utf-8?B?U0FWUnhtZkgwMVNzbTIydXpSdThKaGxSV0dyTDNJMmFMYUtQcThzaHFhdGRo?=
 =?utf-8?B?ckxsUG9UNW9TTFpWL3FRdXo4c2NQNXkrWEZ0RVI5YUNBbGoxeGd6akI5eVZN?=
 =?utf-8?B?QXlBTG85MG44ZmNjMnFxSE90aGhWUEUySE1FRW9qWFVWeUdJSkYvN0E0dUlt?=
 =?utf-8?B?cmNPTWxPZHBLSjdRclZhS3ZNK0hjUm1yTnA1TEJiK1o1Y3BlUkdiVXNLdG1G?=
 =?utf-8?B?MlE1dVkwUU9jejBnTk84MEo5R2JUWXI2L3Z3L0ppZHF4L05Hckx2dlRTdHQy?=
 =?utf-8?B?MXBuTVlkOU5BQ1IrMmkyLytwRCs3SVBSbkVnbEU0Z0pueUpNL1V1SmhLSjNF?=
 =?utf-8?B?Y2NvdDR0cXYwSzZWK1JIVUdFKzFLaHllTVc0SjgvYXhNbEluUWZQNGlDWWdq?=
 =?utf-8?B?QzF0UWZycUF2c2xobjd5RkVySkE3Y1dDMEU2OUNDcTBWZHBQSzd1Z01ueTBC?=
 =?utf-8?B?VEFRQWlhWGJzSGtlSHFab1FMSjl3REVlV1lkV0xKUjhQczM3VFd2UlNKd2Jh?=
 =?utf-8?B?aXR4Z2FtWVgvZXA0a2x3S3FqUi9XYTNkdWxPVUxacVF4cUtMS1k4VFAzV1dS?=
 =?utf-8?B?OWhXMERqM091d1JsNTdTeWFrYjlWZUxJMzV2SlFXZjF5WUZaNTJic0FnVTRF?=
 =?utf-8?B?S1JKQWdJYTJvajZZS3JIcEZBMmVEMW03N045QTRKVGJsNXFlYXJWajJhWEdo?=
 =?utf-8?B?eU1FRVZxRDRlN2d1YUFVTkNIUytzWHVmS0V1TUh1VHdNVGRKSjY1UTFocjVm?=
 =?utf-8?B?R3pVYkNVdlhMdjVVaWJyZTlTSkhFN0tJc2tPdS9UTm1KVnlIN082ZDQxS2dW?=
 =?utf-8?B?S3VqSzlMenRnTjMrUm5jdGhDRk54RXBSdEpNNHZ2YytFWW9RaThjcnI5MC9W?=
 =?utf-8?B?MXJSVHkyeHd0Qi9ncE5kcEpLYnh5WkpFMHlXWU9namVLQVVIVGF1bE43VDZj?=
 =?utf-8?B?STFQTlFrL0M0QzAxRFY5eWNvaGk0bnc1T1dzVHgxa0ovMTZIUUF2b0lrVVdw?=
 =?utf-8?B?N2tBQlFRUzNCWGVvcjA3NUdDY3BmMDdUNnRxTnRnYisvQkZPVjlyYVF2RGJQ?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0AB7468081174F40A7FF45561BBB03E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b324a42-b20f-4000-4f97-08dbb56a96f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2023 21:36:00.6534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yDV2E7gmeWkvO4t7bf1eB8X8x+culZUR1p2U1GtfB/NgdRbwFzNIKBgQtz4TyoQAoLIx1SqgzA9BCQj8wIlicowM+GECF4pl2bSMU1Iz/Qs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6961
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIzLTA4LTI2IGF0IDAwOjE0ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvbWFjaGluZV9rZXhlY182NC5jDQo+IGIvYXJjaC94
ODYva2VybmVsL21hY2hpbmVfa2V4ZWNfNjQuYw0KPiBpbmRleCAxYTNlMmMwNWE4YTUuLjAzZDk2
ODllZjgwOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL21hY2hpbmVfa2V4ZWNfNjQu
Yw0KPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvbWFjaGluZV9rZXhlY182NC5jDQo+IEBAIC0yOCw2
ICsyOCw3IEBADQo+IMKgI2luY2x1ZGUgPGFzbS9zZXR1cC5oPg0KPiDCoCNpbmNsdWRlIDxhc20v
c2V0X21lbW9yeS5oPg0KPiDCoCNpbmNsdWRlIDxhc20vY3B1Lmg+DQo+ICsjaW5jbHVkZSA8YXNt
L3RkeC5oPg0KPiDCoA0KPiDCoCNpZmRlZiBDT05GSUdfQUNQSQ0KPiDCoC8qDQo+IEBAIC0zMDEs
NiArMzAyLDE0IEBAIHZvaWQgbWFjaGluZV9rZXhlYyhzdHJ1Y3Qga2ltYWdlICppbWFnZSkNCj4g
wqDCoMKgwqDCoMKgwqDCoHZvaWQgKmNvbnRyb2xfcGFnZTsNCj4gwqDCoMKgwqDCoMKgwqDCoGlu
dCBzYXZlX2Z0cmFjZV9lbmFibGVkOw0KPiDCoA0KPiArwqDCoMKgwqDCoMKgwqAvKg0KPiArwqDC
oMKgwqDCoMKgwqAgKiBGb3IgcGxhdGZvcm1zIHdpdGggVERYICJwYXJ0aWFsIHdyaXRlIG1hY2hp
bmUgY2hlY2siDQo+IGVycmF0dW0sDQo+ICvCoMKgwqDCoMKgwqDCoCAqIGFsbCBURFggcHJpdmF0
ZSBwYWdlcyBuZWVkIHRvIGJlIGNvbnZlcnRlZCBiYWNrIHRvIG5vcm1hbA0KPiArwqDCoMKgwqDC
oMKgwqAgKiBiZWZvcmUgYm9vdGluZyB0byB0aGUgbmV3IGtlcm5lbCwgb3RoZXJ3aXNlIHRoZSBu
ZXcga2VybmVsDQo+ICvCoMKgwqDCoMKgwqDCoCAqIG1heSBnZXQgdW5leHBlY3RlZCBtYWNoaW5l
IGNoZWNrLg0KPiArwqDCoMKgwqDCoMKgwqAgKi8NCj4gK8KgwqDCoMKgwqDCoMKgdGR4X3Jlc2V0
X21lbW9yeSgpOw0KPiArDQo+IMKgI2lmZGVmIENPTkZJR19LRVhFQ19KVU1QDQo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAoaW1hZ2UtPnByZXNlcnZlX2NvbnRleHQpDQo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgc2F2ZV9wcm9jZXNzb3Jfc3RhdGUoKTsNCg0KV2l0aG91dCBhIHRvbiBv
ZiBrbm93bGVkZ2Ugb24gVERYIGFyY2ggc3R1ZmYsIEknbSBtb3N0bHkgbG9va2VkIGF0IHRoZQ0K
a2V4ZWMgZmxvdyB3aXRoIHJlc3BlY3QgdG8gYW55dGhpbmcgdGhhdCBtaWdodCBiZSB0aW5rZXJp
bmcgd2l0aCB0aGUNClBBTVQuIEV2ZXJ5dGhpbmcgdGhlcmUgbG9va2VkIGdvb2QgdG8gbWUuDQoN
CkJ1dCBJJ20gd29uZGVyaW5nIGlmIHlvdSB3YW50IHRvIHNraXAgdGhlIHRkeF9yZXNldF9tZW1v
cnkoKSBpbiB0aGUNCktFWEVDX0pVTVAvcHJlc2VydmVfY29udGV4dCBjYXNlLiBTb21laG93IChJ
J20gbm90IGNsZWFyIG9uIGFsbCB0aGUNCmRldGFpbHMpLCBrZXhlYyBjYW4gYmUgY29uZmlndXJl
ZCB0byBoYXZlIHRoZSBuZXcga2VybmVsIGp1bXAgYmFjayB0bw0KdGhlIG9sZCBrZXJuZWwgYW5k
IHJlc3VtZSBleGVjdXRpb24gYXMgaWYgbm90aGluZyBoYXBwZW5lZC4gVGhlbiBJDQp0aGluayB5
b3Ugd291bGQgd2FudCB0byBrZWVwIHRoZSBURFggZGF0YSBhcm91bmQuIERvZXMgdGhhdCBtYWtl
IGFueQ0Kc2Vuc2U/DQoNCg==
