Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CB17CD670
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 10:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344642AbjJRI3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 04:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234509AbjJRI3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 04:29:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB10B6;
        Wed, 18 Oct 2023 01:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697617772; x=1729153772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RB0InzgNUBYhOedKRG9HGsZkx6J7CimWROxPjNKkN1c=;
  b=dfoZnbxPS/w46wzArwykRviLbTP/dBkIrIPcrDsstfgysorGm6cV0ng1
   7s3LPKopvuaoX/sw4YBl1TgaUEu1U+AcasiGgvL7l/ocP4n/OKcrmFUET
   remKTpIWsdrdjTAiKEAYgR++6ddzG9rGu56PWQpYNmZ012mFJKKQNWaQG
   W/c45LQjIvdlRfzlcOgwefyCFPuQqIaIgTDmsnpkh+Dij9Qu59rBg+Mvr
   0/72FkeKqw3pMWnaQReYGfTP9yguRkM3vtqsHhV1QkP74YPdkbro8qJVf
   y1vwcivI07oOLVCQBZbMB1W0VHjR7Rt/8+qgM4UrOJxJXxDn9Y3T09Zcv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="388831031"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="388831031"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 01:29:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="930081880"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="930081880"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2023 01:29:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 01:29:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 01:29:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 18 Oct 2023 01:29:30 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 18 Oct 2023 01:29:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYG8m9fSCkultQLrIhYsQsA8Ep9OzEXKGmxCTiw8AUu+WqYL0udBKc+MzZWWRoRf98CjteU3n+j+e96s/lNzwek8UTPH2L0jNi5krWWIBaUgGbwpYXiyeahLlcM/oTuiU0DjxzpVKmmLOCHzsYx5n533wld2qY2ZVV09ejIFaw7n2iXKr1HcIdi2ot0qRNlL8uyC9iFoA/RHNusEtuHC25JcnL4B5OkH+9hyF0nlaqXF69qBNzezYI5S89+BuDYVTFXA8VlTPZp654yAI0bu8jbwHxzokr5zq02svWMP7yLxScdIrGQf3fQHpPnMRcWZ/bha9szYxNbHczavM/rcEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RB0InzgNUBYhOedKRG9HGsZkx6J7CimWROxPjNKkN1c=;
 b=nkCE2jgPJrBzxDPjEJWS4wuT1kL0n8k5ZzTX5JrpvONsbkhvhiG5yZDv9OPND6LAEOUsPme4w12RwFDj56V7GltuQcrwJfrWuBfUn67ALcbcPIE5N6UT41syobEfk07iRjEmM/nfK08zKo/JOhwZsxptxW0BzWh3giQ2APb3hGMr3zuTWQ+A2sCk54JQKarqM2afwPyAK+RwTFv83d+8wL3VA0EqBWszlZaocupSgyHDtAPWSx0sAV/wBThcdZAo9uqXSMrq6EDISSH0OAwGZoIjrNAF7Njz26t7giB3MXkp1q6ZG4Bhn7epFcMa7yVF+rXT9+yc46a41fOR46ThSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Wed, 18 Oct
 2023 08:29:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 08:29:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHaAN//ldkr1S527EC3GXo/nVXwQ7BPL8MAgAAI4wA=
Date:   Wed, 18 Oct 2023 08:29:27 +0000
Message-ID: <a0389bcb3fa4cd1f02bff94090f302b87d98a2e3.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
         <ea983252-0219-46a7-99be-5a8d22049fd6@suse.com>
In-Reply-To: <ea983252-0219-46a7-99be-5a8d22049fd6@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6771:EE_
x-ms-office365-filtering-correlation-id: e3096902-afef-4523-096b-08dbcfb457c1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dFVtPej4qLc0WWoXv9igOdprcAl43HU33GpOyiOP3WwUmxEdF+I+lGRvAuXwZGuhsfQ/y71q6BQlMYAUqHwSeZ7bpSot1c2GxV32Jg1xEw6QRrqyfcZPm9QcPKFlGXZDFBd6rx8kRNLOcEzLQBb7JQiJ8/zo1IVeFXczGON0HOHYTqi4pbL05M5dw06OX8L9CWhRayqVApXbH1kMc5+fuxcxU0l4MbiqVsLPnSjHQOOxR2sbfBGfi++COidspkbsgBFha9efWupWJhTwpRufbY8HGwC5vmit1qNOkOE1003yH4bEEhLG/yVzsj4RkkyDv3a3bLIncvGp6fBJq1RvRijenmoShDevp9SO3xYICnUxDxmGOGpbj2wvHwKTTPiFD4/3M5nsd3AWySckwKb2qN6l7RnBTGBZfHOt2yV4cwNPJnLo/NJ1YK2RJ4Okyrc9mwHjSo5uPRCVW2Wk7ADChf9DaZa6IqlTuAZ1oB7XQiBvwhfMm85moB7uOrbqEBmuVp0t/tt8HAE9F8o/4ajY1GmNIubIcvLg+elo8E3vgYpC2CC7wHbbWw804nbchJWxXCMpKM8Lmd3ZxWrzlWfkeXuxD/KiFZHQ1ZxB3dOao75uqrl7nDon9WjgBOvK5ubb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(376002)(396003)(39860400002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(8676002)(110136005)(4744005)(8936002)(5660300002)(4326008)(7416002)(41300700001)(2906002)(86362001)(36756003)(26005)(38100700002)(6506007)(38070700005)(82960400001)(2616005)(122000001)(478600001)(83380400001)(6512007)(71200400001)(91956017)(66946007)(54906003)(66556008)(6486002)(66476007)(76116006)(64756008)(316002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1BMVElxMVhOQW9pM1ZFaDNkRXNJR3lPSk9JTEs0ZFZYMHl6OTYwdUlYaVpl?=
 =?utf-8?B?aStmM0JWNWR6MVJBVjZVYjlXd2FIa0VocS9zVlNVdnhnYjNRYnRIQWJPRUE3?=
 =?utf-8?B?NlFFRnFaVGIyd1hsRm9tVkFWOTF6NnNwY3Y2c0ZvRE44NmlZSFVieTBnYTRu?=
 =?utf-8?B?K1BtbGhoK3VsL2QycS9ONHBBWWVKN0tCUVplY2FQZm5mMHJ0VWlTNldVMnNi?=
 =?utf-8?B?Y2hqSFdya3JPdTB1MnlBYU9sODFnMWRPejdLMGx3THlrZnh2WXc2SzhGNnV6?=
 =?utf-8?B?ajkxV3hkQjg1aUhGUXBhRHZ0WmlVVklYeXR2SlAvYmdLaGx0SkVQS0pENFFt?=
 =?utf-8?B?a0c0NWtQWVZ1MlBabm02OEFYVklVa21NTVFmNFEycE1vZmlGV1d1QjIwS3BS?=
 =?utf-8?B?OFRTVkJybXFIYWVwV0JzUWtTM3ZSK2VVdlNqQUF3Zks2VW9oK1BpYUxJL3gz?=
 =?utf-8?B?Mzd2bTZyRWZUbTVvay92K2dXUGhBV2ZhdnE5TVZOU3dpTXIyTnlGWDlFWnVv?=
 =?utf-8?B?WHUvM0hlMmNQcG95K3VBbUZhVTBoa1E3RUxHZ0RTcHlwYTh1dDJwdGYvYlQx?=
 =?utf-8?B?RFQ4djFEVi9NQmlpdU8veXlucHozaTRvYVV5eXZVeHJiSlJBWmtJQlYwMGl0?=
 =?utf-8?B?a1dWejBzaWFhTk1pRnJYaFBoK1BaOTRndmNoMTRMdUtCTjF6MW5ObjZJdHBm?=
 =?utf-8?B?cDZrYVNnNXVuaWpON2lqVXhXVTRQR3E1TWtzQnp3TGVzWXJKT25XSm1sY0Vh?=
 =?utf-8?B?NUgxQ25NOW5ORjA0N0xaMWVSOGk2U2doaFZCbkVLc0J6Y21QVjFVUkptZ3ow?=
 =?utf-8?B?aXVjT2FDQ29FY2o5ZStkbHRCQlBhd3pMZDBJOHh5VzBzaUJUZkwwMEhMbmEy?=
 =?utf-8?B?clhDclcyVFZUMTFldkovWmw2SjlzTGlqeEFEV28rbE9Vb043Tzg4SC9QQWFo?=
 =?utf-8?B?UmhlRmFmZEJJWm56aG1LbkpFelc3MlpsSnVha3dwekd5djg3eEZuV25jR2g4?=
 =?utf-8?B?cTc3SkN0NzlZZnVZeXlQd3JtUnFlOHBrMFRhdFJIZExwdWdZTmE5VFlsRjdo?=
 =?utf-8?B?R1RKUUJsalZmR2lOTEhWYXY2SnZhemNsbHhNTXBic3FVcU5XeVNQVTBzalVZ?=
 =?utf-8?B?YnhTdEtjOEJ3MlZhZ3FtMHRrakFhaFdyZFpLMkhyY0hvcmdlZHpBaVYzWVN6?=
 =?utf-8?B?WnR0YUkralFFb1VablRTWjN0QTc0aFdQUFN0ZWNpSHprRjVGcjl0TFZHNVZI?=
 =?utf-8?B?QjNyQzl0S0tSRXVCYWU3Rm90dmFudjZ1ZENXdnFqbmM2WldUUkk0aFI0V0Mv?=
 =?utf-8?B?Q3MxNHNvWDRoRzhBWk5IL25FUzJadHVhZU9raHVJWUVhcmlwVlN2YnFuY1FT?=
 =?utf-8?B?bkVkNmkzUGlKa2ZPK1N4bUV3eThBeTFUVEp4S0NuMlViWk8xZ3BGajZnbmZ3?=
 =?utf-8?B?anFIaXJZa3V3TEJIMFExMENiSmYxcGg0RS9yMitENG5IWjhjamtUTk40SzZz?=
 =?utf-8?B?Yi9jbVF5NVh0Ym9QS3lnM2RjNUptWEV0WUkwVnNzdXdiTFRINmdiZnJNQy9J?=
 =?utf-8?B?NlJyWURLOXNZQ2FCSzUwekZnMm1zSXNkbjE3UTVFL3R4bWxkVE1CYUs0dzZH?=
 =?utf-8?B?eThjZGkzbm5hVzZ5WXVqWmF6VXpwMGxDaE8wK3dRcEh4cXNUTkxMTHphdWhS?=
 =?utf-8?B?cEpjQ0FKUFlhNk5CNnhXNkJaYkNFNnFFU1ZOWXkwUy9wMHp1Y3dpRFJsRTBK?=
 =?utf-8?B?SStmL2xlZTFra0FiRVNEUE5oSGFsdnZUeXVHVUpGM25GVVNqd1JUUzdYNTlS?=
 =?utf-8?B?QnRvUmo2M3BPZS9WRmhPeHdIZkV6VFl1YnJtekp0eGUyME5JdmM2N0R0TGhz?=
 =?utf-8?B?SjZaSVdETnBlRC8rVHZ0NjFyR2hVdWQwdGxTRTU0bno2b3ZjYXhxTDE2NzJn?=
 =?utf-8?B?ck1BY1FXNVM5TldZSE5lUU5YK3BzQ01SQ1ZlUWhzampqcGUyQjQ3RDlHclpV?=
 =?utf-8?B?bjBtekJMdGREZkh4c0l0Q1psa0NQS0tvSVcwV0M3NXlHK3pTRldmYlNHWm9S?=
 =?utf-8?B?amYrR28rQ285QlNSRmgvZUlhR09wcGIwRjhaMm42clRtNVNOM2ZRb29ib1Vm?=
 =?utf-8?B?UlpSWWxDSHpQRkozd3hkdklOYXFhQ1FlWnhLWFNLWmI5QXYyaTZSUWIyblF5?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76386DE830DEAF4396448D4E6D1073CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3096902-afef-4523-096b-08dbcfb457c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 08:29:27.5812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W5g8qglcv1hld+R9bhdEFnGwA6EeGMxjfQn9/tkiU5jlNcYaMEJojiUe1JF7j1Kl5vCkBDIM8BiMSWFO/ohIVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6771
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IA0KPiA+ICsvKg0KPiA+ICsgKiBEbyB0aGUgbW9kdWxlIGdsb2JhbCBpbml0aWFsaXphdGlvbiBv
bmNlIGFuZCByZXR1cm4gaXRzIHJlc3VsdC4NCj4gPiArICogSXQgY2FuIGJlIGRvbmUgb24gYW55
IGNwdS4gIEl0J3MgYWx3YXlzIGNhbGxlZCB3aXRoIGludGVycnVwdHMNCj4gPiArICogZGlzYWJs
ZWQuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IHRyeV9pbml0X21vZHVsZV9nbG9iYWwodm9p
ZCkNCj4gPiArew0KPiANCj4gQW55IHBhcnRpY3VsYXIgcmVhc29uIHdoeSB0aGlzIGZ1bmN0aW9u
IGlzIG5vdCBjYWxsZWQgZnJvbSB0aGUgdGR4IA0KPiBtb2R1bGUncyB0ZHhfaW5pdD/CoEl0J3Mg
Z2xvYmFsIGFuZCBtdXN0IGJlIGNhbGxlZCBvbmNlIHdoZW4gdGhlIG1vZHVsZSANCj4gaXMgaW5p
dGlhbGlzZWQuIFN1YnNlcXVlbnRseSBrdm0gd2hpY2ggaXMgc3VwcG9zZWQgdG8gY2FsbCANCj4g
dGR4X2NwdV9lbmFibGUoKSBtdXN0IGJlIHNlcXVlbmNlZCBfYWZ0ZXJfIHRkeCB3aGljaCBzaG91
bGRuJ3QgYmUgdGhhdCANCj4gaGFyZCwgbm8/IFRoaXMgd2lsbCBlbGltaW5hdGUgdGhlIHNwaW5s
b2NrIGFzIHdlbGwuDQo+IA0KDQpEbyB5b3UgbWVhbiBlYXJseV9pbml0Y2FsbCh0ZHhfaW5pdCk/
DQoNCkJlY2F1c2UgaXQgcmVxdWlyZXMgVk1YT04gYmVpbmcgZG9uZSB0byBkbyBTRUFNQ0FMTC4g
IEZvciBub3cgb25seSBLVk0gZG9lcw0KVk1YT04uDQoNCg==
