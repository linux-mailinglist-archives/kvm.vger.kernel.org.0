Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5A6DF49E
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 14:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjDLMDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 08:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjDLMC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 08:02:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E0383DC
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 05:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681300942; x=1712836942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MjpONgnex0uzXLd64Z72o+ncc8saRQhGvWmAVkdfrcg=;
  b=ZyaQOzMpr23bYR/yT5rh6/2Q7gH39mhTMQjSelKE0HvlnhnSGU9vqUsv
   iQJevafYVtAydafykZ6qZs2Z7LXadLBYXJLN2FuVpQtfzBhKtE1KWDdZW
   ivCD0x53yefZO3wwOiBl/wZgqKK+jhaT6/NZi2vMN5M2E97oWs98eB0f5
   iGgsjWbuqKUL/enMrHKZTUkud58FX0SRQ9LLGdxCf/L7jrJWLgh+NPDUc
   D3GFBYcnaUeVpBCrp3Sb1AmWwkSHVzh6ZMUqNti0jB/EaShtZaJuE0yvp
   O+UfGX/1jMny2c7I+QiHIWY+OLitHdUqzIbmHs86CI6AChPLQWZIOMwUu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="341364313"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="341364313"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:59:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="935089768"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="935089768"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 12 Apr 2023 04:59:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 04:59:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 04:59:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 04:59:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 04:58:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeJ3Icff3Gzk5EFqdXTbHj58VLfdJgkxlkdO5CgzkWCXbIydTqeynLjMk39qIO2itTMKoZ2H8++IQGOzdzXKaVpv62WKLxWvD1LdTPMztWgT0LoxpxI1/6Et3fPVto3+6lU8MzEZNSSGMcdQz/zptXkY/qZnaAkNMODKREy6UWzi/uUslX+6yvJdowojIEyE66swX9zHePCjblj3WRzaxua/7FnSqJN8YBRsqdEqq+C4q3iEPriFHThuodyAb5mooxc5j676lwJbd7JQHJ82jZM4yQWO/JX325K6x3W08N+g0GBkTtpi4vLA3GXCOPOkwyz175AYuevduEwoi7KpCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjpONgnex0uzXLd64Z72o+ncc8saRQhGvWmAVkdfrcg=;
 b=Nz+Kgt1L38de6LRwcJQnUfy6QC49cbBoGjHHESS0czvkKvxIF7J8l5lFM5/viVrZWbvhdtTpD9h3xuYGuoX+By+s6MPmexB9uZtE5j+YhXYmPGgRWDdT6axG6GHEsJwvtmbeJ2fhkyVgS1Pt8cya15pXaVgGFlZlr0WXBtMoDzmaN4ph4IfDLGxfCJQzZxPFEJUyRO/OHpLtE7QhEJu+LAEkADsWs0TspQSabwT77lM5bOHc2AttsHivgJeZPM+uQU1crd3C435xRJzrMOjZD1SWvXvRJWifg4sRdrG0d5emAXEvA65ryRwS5VwfpkVwsQ4AsJc2lNRK3msFf6tlmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6142.namprd11.prod.outlook.com (2603:10b6:8:b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 11:58:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 11:58:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluA
Date:   Wed, 12 Apr 2023 11:58:52 +0000
Message-ID: <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
         <20230404130923.27749-3-binbin.wu@linux.intel.com>
In-Reply-To: <20230404130923.27749-3-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6142:EE_
x-ms-office365-filtering-correlation-id: 81c6e75d-544c-4c80-7017-08db3b4d48bd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XcfygdQ1KG+Vw/Wo3uBSHf292d7gfEcMDPz/z6C+qzUwiO73NbQ2zDIx2HwksYweUM5iQh+/0u+HVnL4XhybPULKb25es6fAMRU97TBvYImOeYjnhcVWPiSC2UkJvJvuONu5r2wOyokwg3vQ9/+15TAR1500R9gEeJXlpAI+m41+fsBcR4HwW+Q98I/Io5RK30I5hwu05Ju+EcBftOY0TREuf4xZpHWwUGPFcdG03Ywa5Zg3ZTKkj9MVIrBtp+H2oprD30vF7OcFXuJNooASP1/3COGqOVOcvOx6NHWJCDblyasiAfD1fGANWvVX4D378a7tgcvIGaYXPu91SpXAK97USIfOg4ecbqcwjPe80hNWFBG7VFf+MB4D/wkJNF+TAvUHL7WXKLCh3KpmpdB5VaWYzFLALHMfdyO2WO82xLmNX2d4aK/xvkeGdkTS7MUMGw12JSrySjZmo8bpjiINnxvmbfbfxWC36PxlcXtMqEBITdEMUtdyGNjXV/HovfcOKwpLcPpa2TKxM60o5OvDM6DBnyHstOQ/+ZUEoQqNzCzBs1e11whuSUVT13hojBxM4ETGgW02mowkrIpIsq34+Qn4BGfLaMlDGnFs37WVrMs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199021)(316002)(83380400001)(110136005)(38070700005)(6512007)(26005)(6486002)(71200400001)(186003)(86362001)(6506007)(36756003)(54906003)(2906002)(478600001)(38100700002)(5660300002)(4326008)(8676002)(66476007)(76116006)(66446008)(64756008)(66946007)(91956017)(82960400001)(66556008)(8936002)(122000001)(41300700001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEQ0U3R6VVBGbnpSOXZSbVlldlRKT1RmZE9wYjhoTDVHTHpTc2k4RVExaW90?=
 =?utf-8?B?RVZGQ0xjTnZSUkFZaTYzcUlpRmh6SVEzQm1NM1AyS2JVMURkQUxaK1RYbnlw?=
 =?utf-8?B?RkVxM1pzeURna2tsK09kdERqUFRROU82M2FSUEQ3eXB6bmQ1Z29aOW92TnZk?=
 =?utf-8?B?a0ZRYW5OMDhibCtZb1NqSldjMmZDcGpSVzNBNFFJRk5JSkNWaE1BOHBPOG5S?=
 =?utf-8?B?YUhIQzlJYlpzZDdPY1FzWmFYd3lHaTQ3am96b2U0aFZETmRkOVlFeWUvbTVX?=
 =?utf-8?B?c3NaVHhWNGxJc2U4UlVMU3JTdEVvbS85OU9UTjJEZ1FZK0VhdW55OFZkQVZH?=
 =?utf-8?B?VFFiT0hwNjFML1FzdUdJTHV5OFo2RENEUEhCVG5GdkhHQmV4MlZPYzJnWVoz?=
 =?utf-8?B?ZXF0NWFmbkxORkw0MnBTa1lsanozanBaTVZmOGRkTVAyVzdkRVRKOUlOcVRs?=
 =?utf-8?B?elpHd29IcTZ4L3YzOEVnUkptZUszSWlUbzNpbXRraU5WWEM2NFdDMkh6SmpM?=
 =?utf-8?B?SnpQenNOejF3MzdBcWpnSis2L2RkaUwybFo1N2pzcis4NEtyam1wODBiT1Zq?=
 =?utf-8?B?WFpyVFRkbXllWHlCSG5NZHNtTDVNYlg5ME1YeUt0ZGVzL3BtTEVPcjFzaW5p?=
 =?utf-8?B?ODFYRTdHaHJYa3lzZkxISGhGbEhCUllPVThJMm9nL0NVL0JGQTE1RDZzbnEw?=
 =?utf-8?B?T0NyUFpKTTJ6NUFwTldrcmJpSHUxV3FZNU15TFVlVG1USlBjajQ2aFlHUXZh?=
 =?utf-8?B?NjBBd0tiN1Y1bzVRbjJROFhnS3V0SVlRTml0SnRFTjNMbkxyVzN1bzd3aGp1?=
 =?utf-8?B?b0d6YU9XQVhoeDJjMFU1Z0xKZ056dkRxanZMcllJa3pwT2dFeFlYMjBHOURX?=
 =?utf-8?B?bDVpVDZZRU9WSHFjb3lNN2s5T2FCVnptWm1rbHM2cVpoUXZUNHcvZzFOTER4?=
 =?utf-8?B?TVd3eEpLbnRheVVlTE1Kb1ZZeEloS0NxOEJaYXVHQm5BeWNUeThCWXZMSGdS?=
 =?utf-8?B?VjBFeCtSWW9VUW1OeVhFRktSZ0lMdG0zQ0c3b1l2YXltcUFiUFZBK1QyVm93?=
 =?utf-8?B?TnhIYWpoRTQwN3c1WXZ5Tll4aXdVR2czU2dRSEY3d3FneUFQVG9UWk1JZFBI?=
 =?utf-8?B?aWloVVg0T2ZHU09RMElpaHpHY2dmcXRwTFBFSnNUd1A4b3VsMVNUMGtBNFBQ?=
 =?utf-8?B?T0ZPbitrQVFoNkwvYlltL1hlbjBwWG9ENEtnVEFXMXZRTjFzWkJRdXhISkVr?=
 =?utf-8?B?QzBwT3g2Qm1YRXZLdkhvcFh3Uzc0VnpFSGpMb056anpwcXJtWTgySWx0S0s0?=
 =?utf-8?B?VUg3TXZSNVdRYlR1N2dKc0pSamhFNHpBd3BUM1lPZU52bW5pVVVOc0VHK1NY?=
 =?utf-8?B?SWZQekNOTUhjSDFiajNhYjVMeTlZYnlYMVJrZVJzNGNBU1BaRjFPc3BNY0Z0?=
 =?utf-8?B?cm1FWVRnZlFucEluZk1xVHpOeVNKSDZJZUNBS1ZSOGtUY3ZGdUVvNS9hOFdP?=
 =?utf-8?B?TVI1c3FramRVb2l4MTRhRHVYcU9lN1VhZndKYStHSDlvRHhLR3E5YStkUGIx?=
 =?utf-8?B?cW1PMFpUc2k2Tk5VaXp6VXk1OG8yOW9KVFBxQWlFcW4wVjN2aGtSRVRtZUVB?=
 =?utf-8?B?dG90L2ZseWw3T1JaWmYvZjdQT2pxVGd2Qnh2SlQ5WW4xaXFXa1FxVm9BMXh4?=
 =?utf-8?B?YzJOR2twTGJDdjhXWjlFZUFxSVpRcHJERWRtV0E0RkI5bWFPZmcrSGdtOVZS?=
 =?utf-8?B?ME5nUEI2UTErdFM4VDZVaVdGOWxpWitpN1R3bEV2djkyRm02c2U4blNYUmxP?=
 =?utf-8?B?dGQwOGQzUlpGTWNiejlqVTZHKzZZei81dmRsa2czNDlkSU1DV3lUT2Y4bXVN?=
 =?utf-8?B?UEswNHIvTlRNV3l4aGwreE1xR0JLT1JrcHNIVFhGbk1mZDdCRWtHY1VQYmRU?=
 =?utf-8?B?bFE2OUZseEVDWklETlViQnp5V1NEUXl3ZWI3K205Q0VHMUNYVTAxTTk3dWdj?=
 =?utf-8?B?OEw0MHBHcGZnS3U2UDh3V3BFQ0E0TUFuWHViRDR2OXdqNHNmZUR6QkUyeFVy?=
 =?utf-8?B?S0RrR0NwN3oyNDJmdEI3Z1FFRm00RTVpQmhwNVZMcHNoYkFqR1N2eUt5dEdF?=
 =?utf-8?Q?jfvyd9T7zbS6B5PFwfTikqmgY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9C79F773492F9479354FB3D99EE673E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c6e75d-544c-4c80-7017-08db3b4d48bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 11:58:52.1495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ICMKxYksyeiOlvWl9N50j3hD9piR6QzmJy9lilwBbDZww0GkixRxkaC3FLUjM794tEhQZOBNzUmPe/6mnZBjhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6142
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

PiANCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiArKysgYi9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+IEBAIC03MjksNiArNzI5LDEyIEBAIHN0cnVj
dCBrdm1fdmNwdV9hcmNoIHsNCj4gIAl1bnNpZ25lZCBsb25nIGNyMF9ndWVzdF9vd25lZF9iaXRz
Ow0KPiAgCXVuc2lnbmVkIGxvbmcgY3IyOw0KPiAgCXVuc2lnbmVkIGxvbmcgY3IzOw0KPiArCS8q
DQo+ICsJICogQml0cyBpbiBDUjMgdXNlZCB0byBlbmFibGUgY2VydGFpbiBmZWF0dXJlcy4gVGhl
c2UgYml0cyBhcmUgYWxsb3dlZA0KPiArCSAqIHRvIGJlIHNldCBpbiBDUjMgd2hlbiB2Q1BVIHN1
cHBvcnRzIHRoZSBmZWF0dXJlcy4gV2hlbiBzaGFkb3cgcGFnaW5nDQo+ICsJICogaXMgdXNlZCwg
dGhlc2UgYml0cyBzaG91bGQgYmUga2VwdCBhcyB0aGV5IGFyZSBpbiB0aGUgc2hhZG93IENSMy4N
Cj4gKwkgKi8NCg0KSSBkb24ndCBxdWl0ZSBmb2xsb3cgdGhlIHNlY29uZCBzZW50ZW5jZS4gIE5v
dCBzdXJlIHdoYXQgZG9lcyAidGhlc2UgYml0cyBzaG91bGQNCmJlIGtlcHQiIG1lYW4uIMKgDQoN
ClRob3NlIGNvbnRyb2wgYml0cyBhcmUgbm90IGFjdGl2ZSBiaXRzIGluIGd1ZXN0J3MgQ1IzIGJ1
dCBhbGwgY29udHJvbCBiaXRzIHRoYXQNCmd1ZXN0IGlzIGFsbG93ZWQgdG8gc2V0IHRvIENSMy4g
QW5kIHRob3NlIGJpdHMgZGVwZW5kcyBvbiBndWVzdCdzIENQVUlEIGJ1dCBub3QNCndoZXRoZXIg
Z3Vlc3QgaXMgdXNpbmcgc2hhZG93IHBhZ2luZyBvciBub3QuDQoNCkkgdGhpbmsgeW91IGNhbiBq
dXN0IHJlbW92ZSB0aGUgc2Vjb25kIHNlbnRlbmNlLg0KDQo+ICsJdTY0IGNyM19jdHJsX2JpdHM7
DQo+ICAJdW5zaWduZWQgbG9uZyBjcjQ7DQo+ICAJdW5zaWduZWQgbG9uZyBjcjRfZ3Vlc3Rfb3du
ZWRfYml0czsNCj4gIAl1bnNpZ25lZCBsb25nIGNyNF9ndWVzdF9yc3ZkX2JpdHM7DQo+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0vY3B1aWQuaCBiL2FyY2gveDg2L2t2bS9jcHVpZC5oDQo+IGlu
ZGV4IGIxNjU4YzBkZTg0Ny4uZWY4ZTFiOTEyZDdkIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9r
dm0vY3B1aWQuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vY3B1aWQuaA0KPiBAQCAtNDIsNiArNDIs
MTEgQEAgc3RhdGljIGlubGluZSBpbnQgY3B1aWRfbWF4cGh5YWRkcihzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpDQo+ICAJcmV0dXJuIHZjcHUtPmFyY2gubWF4cGh5YWRkcjsNCj4gIH0NCj4gIA0KPiAr
c3RhdGljIGlubGluZSBib29sIGt2bV92Y3B1X2lzX2xlZ2FsX2NyMyhzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHVuc2lnbmVkIGxvbmcgY3IzKQ0KPiArew0KPiArCXJldHVybiAhKChjcjMgJiB2Y3B1
LT5hcmNoLnJlc2VydmVkX2dwYV9iaXRzKSAmIH52Y3B1LT5hcmNoLmNyM19jdHJsX2JpdHMpOw0K
PiArfQ0KPiArDQo+ICBzdGF0aWMgaW5saW5lIGJvb2wga3ZtX3ZjcHVfaXNfbGVnYWxfZ3BhKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ3BhX3QgZ3BhKQ0KPiAgew0KPiAgCXJldHVybiAhKGdwYSAm
IHZjcHUtPmFyY2gucmVzZXJ2ZWRfZ3BhX2JpdHMpOw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL21tdS5oIGIvYXJjaC94ODYva3ZtL21tdS5oDQo+IGluZGV4IDE2OGM0NmZkOGRkMS4uMjk5
ODVlZWI4ZTEyIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11LmgNCj4gKysrIGIvYXJj
aC94ODYva3ZtL21tdS5oDQo+IEBAIC0xNDIsNiArMTQyLDExIEBAIHN0YXRpYyBpbmxpbmUgdW5z
aWduZWQgbG9uZyBrdm1fZ2V0X2FjdGl2ZV9wY2lkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4g
IAlyZXR1cm4ga3ZtX2dldF9wY2lkKHZjcHUsIGt2bV9yZWFkX2NyMyh2Y3B1KSk7DQo+ICB9DQo+
ICANCj4gK3N0YXRpYyBpbmxpbmUgdTY0IGt2bV9nZXRfYWN0aXZlX2NyM19jdHJsX2JpdHMoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArew0KPiArCXJldHVybiBrdm1fcmVhZF9jcjModmNwdSkg
JiB2Y3B1LT5hcmNoLmNyM19jdHJsX2JpdHM7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbmxpbmUg
dm9pZCBrdm1fbW11X2xvYWRfcGdkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gIHsNCj4gIAl1
NjQgcm9vdF9ocGEgPSB2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGE7DQo+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0vbW11L21tdS5jIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiBpbmRleCBj
OGViZTU0MmM1NjUuLmRlMmM1MWEwYjYxMSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL21t
dS9tbXUuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+IEBAIC0zNzMyLDcgKzM3
MzIsMTEgQEAgc3RhdGljIGludCBtbXVfYWxsb2Nfc2hhZG93X3Jvb3RzKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4gIAlocGFfdCByb290Ow0KPiAgDQo+ICAJcm9vdF9wZ2QgPSBtbXUtPmdldF9n
dWVzdF9wZ2QodmNwdSk7DQo+IC0Jcm9vdF9nZm4gPSByb290X3BnZCA+PiBQQUdFX1NISUZUOw0K
PiArCS8qDQo+ICsJKiBUaGUgZ3Vlc3QgUEdEIGhhcyBhbHJlYWR5IGJlZW4gY2hlY2tlZCBmb3Ig
dmFsaWRpdHksIHVuY29uZGl0aW9uYWxseQ0KPiArCSogc3RyaXAgbm9uLWFkZHJlc3MgYml0cyB3
aGVuIGNvbXB1dGluZyB0aGUgR0ZOLg0KPiArCSovDQoNCkRvbid0IHF1aXRlIGZvbGxvdyB0aGlz
IGNvbW1lbnQgZWl0aGVyLiAgQ2FuIHdlIGp1c3Qgc2F5Og0KDQoJLyoNCgkgKiBHdWVzdCdzIFBH
RCBtYXkgY29udGFpbiBhZGRpdGlvbmFsIGNvbnRyb2wgYml0cy4gIE1hc2sgdGhlbSBvZmYNCgkg
KiB0byBnZXQgdGhlIEdGTi4NCgkgKi8NCg0KV2hpY2ggZXhwbGFpbnMgd2h5IGl0IGhhcyAibm9u
LWFkZHJlc3MgYml0cyIgYW5kIG5lZWRzIG1hc2sgb2ZmPw0KDQo+ICsJcm9vdF9nZm4gPSAocm9v
dF9wZ2QgJiBfX1BUX0JBU0VfQUREUl9NQVNLKSA+PiBQQUdFX1NISUZUOw0KDQpPciwgc2hvdWxk
IHdlIGV4cGxpY2l0bHkgbWFzayB2Y3B1LT5hcmNoLmNyM19jdHJsX2JpdHM/ICBJbiB0aGlzIHdh
eSwgYmVsb3cNCm1tdV9jaGVja19yb290KCkgbWF5IHBvdGVudGlhbGx5IGNhdGNoIG90aGVyIGlu
dmFsaWQgYml0cywgYnV0IGluIHByYWN0aWNlIHRoZXJlDQpzaG91bGQgYmUgbm8gZGlmZmVyZW5j
ZSBJIGd1ZXNzLiANCg0KPiAgDQo+ICAJaWYgKG1tdV9jaGVja19yb290KHZjcHUsIHJvb3RfZ2Zu
KSkNCj4gIAkJcmV0dXJuIDE7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L21tdV9p
bnRlcm5hbC5oIGIvYXJjaC94ODYva3ZtL21tdS9tbXVfaW50ZXJuYWwuaA0KPiBpbmRleCBjYzU4
NjMxZTIzMzYuLmMwNDc5Y2JjMmNhMyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL21tdS9t
bXVfaW50ZXJuYWwuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L21tdV9pbnRlcm5hbC5oDQo+
IEBAIC0yMSw2ICsyMSw3IEBAIGV4dGVybiBib29sIGRiZzsNCj4gICNlbmRpZg0KPiAgDQo+ICAv
KiBQYWdlIHRhYmxlIGJ1aWxkZXIgbWFjcm9zIGNvbW1vbiB0byBzaGFkb3cgKGhvc3QpIFBURXMg
YW5kIGd1ZXN0IFBURXMuICovDQo+ICsjZGVmaW5lIF9fUFRfQkFTRV9BRERSX01BU0sgKCgoMVVM
TCA8PCA1MikgLSAxKSAmIH4odTY0KShQQUdFX1NJWkUtMSkpDQo+ICAjZGVmaW5lIF9fUFRfTEVW
RUxfU0hJRlQobGV2ZWwsIGJpdHNfcGVyX2xldmVsKQlcDQo+ICAJKFBBR0VfU0hJRlQgKyAoKGxl
dmVsKSAtIDEpICogKGJpdHNfcGVyX2xldmVsKSkNCj4gICNkZWZpbmUgX19QVF9JTkRFWChhZGRy
ZXNzLCBsZXZlbCwgYml0c19wZXJfbGV2ZWwpIFwNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2
bS9tbXUvcGFnaW5nX3RtcGwuaCBiL2FyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaA0KPiBp
bmRleCA1N2YwYjc1YzgwZjkuLjg4MzUxYmEwNDI0OSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYv
a3ZtL21tdS9wYWdpbmdfdG1wbC5oDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3Rt
cGwuaA0KPiBAQCAtNjIsNyArNjIsNyBAQA0KPiAgI2VuZGlmDQo+ICANCj4gIC8qIENvbW1vbiBs
b2dpYywgYnV0IHBlci10eXBlIHZhbHVlcy4gIFRoZXNlIGFsc28gbmVlZCB0byBiZSB1bmRlZmlu
ZWQuICovDQo+IC0jZGVmaW5lIFBUX0JBU0VfQUREUl9NQVNLCSgocHRfZWxlbWVudF90KSgoKDFV
TEwgPDwgNTIpIC0gMSkgJiB+KHU2NCkoUEFHRV9TSVpFLTEpKSkNCj4gKyNkZWZpbmUgUFRfQkFT
RV9BRERSX01BU0sJKChwdF9lbGVtZW50X3QpX19QVF9CQVNFX0FERFJfTUFTSykNCj4gICNkZWZp
bmUgUFRfTFZMX0FERFJfTUFTSyhsdmwpCV9fUFRfTFZMX0FERFJfTUFTSyhQVF9CQVNFX0FERFJf
TUFTSywgbHZsLCBQVF9MRVZFTF9CSVRTKQ0KPiAgI2RlZmluZSBQVF9MVkxfT0ZGU0VUX01BU0so
bHZsKQlfX1BUX0xWTF9PRkZTRVRfTUFTSyhQVF9CQVNFX0FERFJfTUFTSywgbHZsLCBQVF9MRVZF
TF9CSVRTKQ0KPiAgI2RlZmluZSBQVF9JTkRFWChhZGRyLCBsdmwpCV9fUFRfSU5ERVgoYWRkciwg
bHZsLCBQVF9MRVZFTF9CSVRTKQ0KPiBAQCAtMzI0LDYgKzMyNCwxMCBAQCBzdGF0aWMgaW50IEZO
QU1FKHdhbGtfYWRkcl9nZW5lcmljKShzdHJ1Y3QgZ3Vlc3Rfd2Fsa2VyICp3YWxrZXIsDQo+ICAJ
dHJhY2Vfa3ZtX21tdV9wYWdldGFibGVfd2FsayhhZGRyLCBhY2Nlc3MpOw0KPiAgcmV0cnlfd2Fs
azoNCj4gIAl3YWxrZXItPmxldmVsID0gbW11LT5jcHVfcm9sZS5iYXNlLmxldmVsOw0KPiArCS8q
DQo+ICsJICogTm8gbmVlZCB0byBtYXNrIGNyM19jdHJsX2JpdHMsIGdwdGVfdG9fZ2ZuKCkgd2ls
bCBzdHJpcA0KPiArCSAqIG5vbi1hZGRyZXNzIGJpdHMuDQo+ICsJICovDQoNCkkgZ3Vlc3MgaXQg
d2lsbCBiZSBoZWxwZnVsIGlmIHdlIGFjdHVhbGx5IGNhbGwgb3V0IHRoYXQgZ3Vlc3QncyBQR0Qg
bWF5IGNvbnRhaW4NCmNvbnRyb2wgYml0cyBoZXJlLg0KDQpBbHNvLCBJIGFtIG5vdCBzdXJlIHdo
ZXRoZXIgaXQncyBiZXR0ZXIgdG8ganVzdCBleHBsaWNpdGx5IG1hc2sgY29udHJvbCBiaXRzIG9m
Zg0KaGVyZS4NCg0KPiAgCXB0ZSAgICAgICAgICAgPSBtbXUtPmdldF9ndWVzdF9wZ2QodmNwdSk7
DQo+ICAJaGF2ZV9hZCAgICAgICA9IFBUX0hBVkVfQUNDRVNTRURfRElSVFkobW11KTsNCj4gIA0K
PiANCg0KWy4uLl0NCg==
