Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A372337F
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 01:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjFEXEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 19:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjFEXEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 19:04:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE8AE8;
        Mon,  5 Jun 2023 16:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686006274; x=1717542274;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2eBizLnJHfogB3wcHTcC2lGAqLXJICZ2jF9KbQk6JsQ=;
  b=iEo1/iNsA7bqi1fizNnxDAW+L35joGlDbjt0Qzuk0DTNK5cBMi9yzxim
   ACMz6jaz3t+LM//gh8uxz1hhLkNpgpECT3OruNIgyq83i8gYagkYdgel/
   3EMa3fHGAwhMVaDtTGP2REeDZkKSeoMOwxtMnPyVlN0Xlh2LTHsiRbeRk
   Ns+Qa5UYAiiqgzmywlvTdOedUgTubj7shNjtKgUU5hlM2XcvBJ8LfwBKh
   BRyF6CY+bfmVbytbzW7TatX9KSyPWcKH//roNsjH8L2h08RREieZpCzy5
   L5j7HHyTdj07LGRhYNGNRpVqA7egM1Jn3dWna1JAJ10IT6t4Hku4SUTy2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359820553"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="359820553"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 16:04:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="711974041"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="711974041"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jun 2023 16:04:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 16:04:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 16:04:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 16:04:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 16:04:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIjWYUVkI0yzRLkCl9V5SKlwyvLIwXEfbXbdYABTanNhmFxHA9xtQLmEy0u8A024VoYgvAe/yhI1Coyjxwd9zHnrot3AQkNkyWlWjWjAufyezJPhyqR0rY957vuBZWJs37irn+BtR1CELhMpT/gOsv9/xMYEA2TYQidXBUfSEBkzJdPDhKHctHdI+h7VCV8zp/oahhuZRfLlTLxIbWWA/XKHH0V9oXtCNoIrhhosTrEdLdWnV5WSd7Cgd/LIk8XGKIZqmkXroKZhIyGj87952+4cREG9G1DOhswX3bq+Uy7oKtMoLvV9tdsjwSjCA3tNUiCMwUec588I3PgM949T8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eBizLnJHfogB3wcHTcC2lGAqLXJICZ2jF9KbQk6JsQ=;
 b=M1OA4JTDMsWOi4JlRMLW4002nybj/aFGQ+Ne/QJpInaP/yfXnkxmVD8Lu5wUPca3lEGDLSMI7LiBy/sqFDOm+R0T9EOy8rqEvXSOz1uGsQ1luXQbY+8r3iNSHowXoHg2SwKgt+STwQplIimnUhdhsgU6gK0YGIfh7YNrrv1cYEnx/2Knx1LvTj5meZZo7nRe9pRqj4HTIrwmg8T38Hf3vgSJnNY1rCsJMmIIqQSNMPa7NS9CK4ScbI/lny8tXk01De3Gr/oxQ6PJcZKRZZ3iSvOjwOfD6WbEM/zKc1Vnuccszorj2MwcndpMGqzVdDoF8UI0v0jrD70evjymmw0PYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DS0PR11MB7441.namprd11.prod.outlook.com (2603:10b6:8:141::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 23:04:31 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff%5]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 23:04:31 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZlu+wNwpF26yA2UWLC9EXmgAK/K98ufOAgAAcVQA=
Date:   Mon, 5 Jun 2023 23:04:30 +0000
Message-ID: <733d0d042f39f099caa35af9b517b6c50ebac12f.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
         <20230605212303.GA2244082@ls.amr.corp.intel.com>
In-Reply-To: <20230605212303.GA2244082@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DS0PR11MB7441:EE_
x-ms-office365-filtering-correlation-id: bfdf95cd-6847-4c0c-4ebc-08db66193852
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UjEzS+cb0CIGX5bxs+lWSPJaqaIo/X1iYvab+KVbBRYctwXGw+QB9QSoM6hZOX0VSOmdJ4MEwoybae6vIwX0VZDka/wc+CP8Wul6OD2Sv6LIZ6vJsYhCb/eXurF0ObABzJ6qS8OS87Zfiq03QDgCh+XGinA5JDx1V2CrZXNdAO6FPL3AB3v9fBE6On3ZSkfRr2zmaz76jfmMbr9E1JHGGnR/qw+ApD+sBPR+xq0sfqeroL3AgSzlD9CLvLiLl8uorYH5/kAl3siBcr1qqV81MtmarNj7Yp22cPIDgYL3dcRQRMPD+cUt5UbzsC2pcg1ZJiojJohm2ED4e8/3Pioh1oPLzFhZqFp98gT+AOMPK5E+nnQBvHW5l3SSpk9sRyPvdrPUb0RctnO2VBhgtZk9kTS75g2+ghlmQ5Ysu4WFDlljgR9lz+nQq23JEDjuR8quSgiEsp7/3ugfxGLLM3WUV2AnyGH0Eql5K2r4XI6n53E45KtUMUfHC05zYU8Cq0rsJVIC3dk0T6HvRtEWuj3o3WXKNacHCKwYl2sLaqr6MaF5hq0FC/AK1RN+ZTCTmWBRpF+/EQE/Jxhh8O2ZSzNVrTszW+B69VJkMIIcXLai+FApNKDm7b87U4LxsiPJFY2d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199021)(478600001)(2906002)(36756003)(6486002)(71200400001)(2616005)(38070700005)(6512007)(6506007)(26005)(86362001)(122000001)(82960400001)(38100700002)(316002)(7416002)(186003)(8676002)(8936002)(66946007)(91956017)(76116006)(6916009)(4326008)(66556008)(66476007)(66446008)(64756008)(5660300002)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkFsUHp4WVRvSW9YMWhjOGxZa1Zxd2cyYmJpdFlUaHlQK1pWTHRnb2xtbDdz?=
 =?utf-8?B?aG5IdkNFTGxhdkdiRkdkb08zN0hTVysyanEwZ3NicE5RMERkTG1YVkZ2NGVk?=
 =?utf-8?B?a2ozZDg2eWRjbW96aWN1a09icFF6OFhwN2cySlFxMnZ0cmRBVThUa21EWEwz?=
 =?utf-8?B?Nnl0b1VTbUlUQ2ZPU1JlaDFPRGE3dkdQL0dEYlhGOGEwcno0Vnp1QmFlR05X?=
 =?utf-8?B?akJWaC9BU2lpSEhLeFFoRG1ab0sxaDY2RWtvcnl3Y3V6ODZOOHJGK2NjMVcv?=
 =?utf-8?B?SEU1NmtLREdaUVFMQjN5aFdlNDZUSlI3NmNoOEU2V3BUR2Q0VGUyQ1pwTjFU?=
 =?utf-8?B?MW82QTJ6RjRKWHdlMDBhakJMVmtWdlp6K01JaUxQOFByREZpeVlDNGw3cHhx?=
 =?utf-8?B?MXZUYkZrQ2p3N0Ywc2RlUGt2M0UyUG1MZmt6NkJPS0ZLRXZOaUY4QTJUUlA3?=
 =?utf-8?B?VGd2MTRJNGJsWFdPOGJYd2VnQldNdVQ4MnozQy9mMlNYYmczVzB0WnJMdVVX?=
 =?utf-8?B?cElva0V2TWtkczhka2QyWjB6WWVTWVZHS2J1ajFPdkdldXFxMExrMWl1MjBP?=
 =?utf-8?B?NFVGMjJ0T3pzQnNWem9LaUwvQmt0bWRsSW90blNVbnJLTEFPMnVIVEtyOW5C?=
 =?utf-8?B?L05TbUJpWG1ncWl0WFJONENUanFGdm9uSXBiTUIrNHlGaEhtQjEwNGd5MDI1?=
 =?utf-8?B?d1Yzanc5Y2J3cVdRb1B1dkxPRE1xV2hZVE9ZOG5NSkhBZnV2bGY1WVFiUmRr?=
 =?utf-8?B?ZFgyaGIzaUNjYnBmclpzZldieUVtRnE4azQvSGMwOEkzTnNjWFJYZEZxcXBX?=
 =?utf-8?B?TmJhRnVvMzdVWFY4T0x3TkE1UlZaS1g2cy9KeXg2S0YxNDkySThrTk1TMG5o?=
 =?utf-8?B?b0NRdWJMSTFNcjRMZ3dlc3FTVVh6UGtaYS9kNG9LYWFLMnpGT0JEYTh3UXMw?=
 =?utf-8?B?WVZaZFpac0w3bmFiRUdzNkhvTVExZzZIV01CdXZjWlRlWHFLbEZOSFRtZHpR?=
 =?utf-8?B?VE9lTDQxa1RXYk5VbGlZdDdOS0tyOE5rMDhpU0RpdHpSdVZHQW5oZEVpZTlG?=
 =?utf-8?B?UVlyOFNvL1MxS2VSM21XbjdOVVk3RlRJcXVqd1VNWTlpMCt3V0RnMGRmdkZL?=
 =?utf-8?B?ZGM4aEJVeWJGYmlKMWdoQzNpRklwRFRwaEpPalQ1Rm55R1g4QkNHRWRnK1Nj?=
 =?utf-8?B?SjRBNWFoMnVZQXY5SGtWRTQ3UGdCRTFBU2EyZXJsVTdvSlNKMlhnb2FXQVRC?=
 =?utf-8?B?Y3M4aHVhSnV5R2ZtNVh3N0plR090U09nbDBPZ1J0K1FVYUJ4VVg3RGVyVUg1?=
 =?utf-8?B?U0lMb01tRTNiWDNESkJ1aWxBWTZ6SW8rREQvc2wwMUI3VWduNXkrN0JhbXh1?=
 =?utf-8?B?R0NZd28weWtycWwwNHJLNGdrRzZnR2lQeVdHZDlaUllqZVVqOWVkbUJyak9V?=
 =?utf-8?B?TUhmalNPaHNmTUJOcW95ZUd4aHk1eHZiMS9zcjVvMW9SMit1M0F3UURsZEF6?=
 =?utf-8?B?d0toOHpDL3prZURxN0MxSGFEVzBoUzNmT3N2dmF5Q01STDdQYmJHNmJvZUda?=
 =?utf-8?B?SDJlSEIybkJtNm1qYUpBUkcyOXhxdSsyNkxWOHJUNnczRGtYeFlQQjlrNjVi?=
 =?utf-8?B?Vzk3WStaN1lzOHRQcWUramFXZFBpRFBjdFFrZHgzYXRmQU52enhZcUtQTDJ3?=
 =?utf-8?B?SllPYTVHdkE2YW5heUYrMlhNQTlvUEIrMFJBMWYwbWNKTEtZS21Mai9NUzB0?=
 =?utf-8?B?K3h4N293TmVGODMra1dweEc4UmJNM0hCbFMyd0dsMnNDODRQbnRKek9vNW5K?=
 =?utf-8?B?MUZaTXdzOURDNllhY2xQZlJYaHFmQ25mQUU5YURxMS9oYVRBVVM4L3dPQUxS?=
 =?utf-8?B?TDF5Zmd6TTNhWG0zMlNPQ3pIYXRWUmpaYU9LMk9XM2FZUW5XNVl4ZVhRMXlr?=
 =?utf-8?B?cmRpaTFweVNFQ0pPRDlHU1ZwVUw5eTd3NEpXV2EvOXp6WFdHaXlBdVRNOFUz?=
 =?utf-8?B?N2ZGRUI0NFIweVc0S3VZUGp0d2I3RWdVaU92N2RmUW4yN3ByNlVVVWJ3cHlk?=
 =?utf-8?B?SVIrT3NSaU9HSnc3dGMzNkVnN3JsZ0F4d2poMDhIbG1KTmpnQ2lsWnpOcmYz?=
 =?utf-8?Q?2PJj5uWiMsjfM1133FRYI0WZD?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA4D0FA8550C194D9580D291E5402C1A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfdf95cd-6847-4c0c-4ebc-08db66193852
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 23:04:30.8138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F8+qByQP8j/97aw71gpKD5lCIMUisvENS2TxZGlOts709DSUkRJoPVckSE8fVhAin2+TtzZjMtp4HHi14L2/oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7441
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

T24gTW9uLCAyMDIzLTA2LTA1IGF0IDE0OjIzIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gTW9uLCBKdW4gMDUsIDIwMjMgYXQgMDI6Mjc6MjBBTSArMTIwMCwNCj4gS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiBp
bmRleCBiNDg5YjViOWRlNWQuLjAzZjc0ODUxNjA4ZiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5o
DQo+ID4gQEAgLTEwMiw4ICsxMDIsMTIgQEAgc3RhdGljIGlubGluZSBsb25nIHRkeF9rdm1faHlw
ZXJjYWxsKHVuc2lnbmVkIGludCBuciwgdW5zaWduZWQgbG9uZyBwMSwNCj4gPiAgDQo+ID4gICNp
ZmRlZiBDT05GSUdfSU5URUxfVERYX0hPU1QNCj4gPiAgYm9vbCBwbGF0Zm9ybV90ZHhfZW5hYmxl
ZCh2b2lkKTsNCj4gPiAraW50IHRkeF9jcHVfZW5hYmxlKHZvaWQpOw0KPiA+ICtpbnQgdGR4X2Vu
YWJsZSh2b2lkKTsNCj4gPiAgI2Vsc2UJLyogIUNPTkZJR19JTlRFTF9URFhfSE9TVCAqLw0KPiA+
ICBzdGF0aWMgaW5saW5lIGJvb2wgcGxhdGZvcm1fdGR4X2VuYWJsZWQodm9pZCkgeyByZXR1cm4g
ZmFsc2U7IH0NCj4gPiArc3RhdGljIGlubGluZSBpbnQgdGR4X2NwdV9lbmFibGUodm9pZCkgeyBy
ZXR1cm4gLUVOT0RFVjsgfQ0KPiA+ICtzdGF0aWMgaW5saW5lIGludCB0ZHhfZW5hYmxlKHZvaWQp
ICB7IHJldHVybiAtRU5PREVWOyB9DQo+ID4gICNlbmRpZgkvKiBDT05GSUdfSU5URUxfVERYX0hP
U1QgKi8NCj4gPiAgDQo+ID4gICNlbmRpZiAvKiAhX19BU1NFTUJMWV9fICovDQo+IA0KPiBQbGVh
c2UgaW5jbHVkZSBlcnJuby5oLg0KPiBJbiB0aGUgY2FzZSBvZiAhSU5URUxfVERYX0hPU1QgJiYg
SU5URUxfVERYX0dVRVNULA0KPiBkcml2ZXJzL3ZpcnQvY29jby90ZHgtZ3Vlc3QvdGR4LWd1ZXN0
LmMgcmVzdWx0cyBpbiBjb21waWxlIGVycm9yLg0KPiANCj4gQWx0aG91Z2ggdGhlcmUgYXJlIG90
aGVyIGZpbGVzIHRoYXQgaW5jbHVkZSBhc20vdGR4LmgsIHRoZXkgc2VlbSB0byBsdWNraWx5DQo+
IGluY2x1ZGUgZXJybm8uaCBkaXJlY3RseSBvciBpbmRpcmVjdGx5Lg0KPiANCkkndmUgY2hhbmdl
ZCB0byAtRU5PREVWIHdoaWNoIGRvZXNuJ3QgY2F1c2UgYnVpbGQgZXJyb3IgaW4gbXkgdGVzdC4N
Cg0KSSBhZ3JlZSBpdCdzIGJldHRlciB0byBpbmNsdWRlIGVycm5vLmggZXhwbGljaXRseSBidXQg
SU1ITyBpdCdzIGEgcHJvYmxlbSBpbiB0aGUNCmV4aXN0aW5nIHVwc3RyZWFtIGNvZGUgKHRkeF9r
dm1faHlwZXJjYWxsKCkgcmV0dXJucyAtRU5PREVWIHdoZW4gSU5URUxfVERYX0dVRVNUDQppcyBv
ZmYpLCB0aHVzIHNob3VsZCBiZSBhZGRyZXNzZWQgaW4gYSBzZXBhcmF0ZSBwYXRjaCBidXQgbm90
IGZvbGRlZCBpbnRvIHRoaXMNCm9uZS4NCg0KU2luY2Ugbm93IHRoZXJlJ3Mgbm8gYnVpbGQgZXJy
b3IsIEkgaGVzaXRhdGVkIHRvIGFkZGVkIHN1Y2ggcGF0Y2guICBJIGNhbiBkbyBpdA0Kc2VwYXJh
dGVseSBpZiBpdCBzaG91bGQgYmUgYWRkcmVzc2VkLg0KDQoNCg==
