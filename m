Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2657A2504
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 19:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbjIORoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 13:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbjIORnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 13:43:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9A410C9;
        Fri, 15 Sep 2023 10:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694799814; x=1726335814;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9rYa5T+uXxG8Bk2pdqK9IaVnGVqZMnhK5f9q7DS0zfQ=;
  b=jnN+wpz0ycNeIumaWb9bSlC4QB179JDJh0SyKXjboWXGvnoDhrhEHSMZ
   8gs2OWBe3t9bRz5onlJCnRV2SrEwlKcRse3LNu31iAbUeXbBBgsBIrOG+
   gls3EK8JgWohZZrI55xf6Bkn++HjDgHrs+tjzs8iHOg11gIxVrbWAXVvU
   uXr10MBgHJ1hbIC8HqxAmCgHd0AccU0YsHl8bAFG0uTMhHg+aBD9NjD1l
   Du3/HO3oTc6/Nlt2Na8fmS85PFoJL22PshIhcaXgfp1cn9Nn4gjOi3XFu
   B7WObrO7yIE0rytx5f5IucvwGq+56kONRvDsUTV6gJ5meZI6Mhg3m7Nvw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="359559683"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="359559683"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 10:43:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="860252646"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="860252646"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Sep 2023 10:43:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 10:43:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 10:43:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 15 Sep 2023 10:43:32 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 15 Sep 2023 10:43:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJ8h5hR1fSIzGt/wwV8dXt3CLoyDEO4GPrBnuKUkKEdGZwlgm8IBx0wgAQbeurfYy1V/iD+EqDvhsuLDPSTDVQ5azx+382cisCws7VcnxlPXoqj+oRvCsATeEK4bse1+EauQT1D9hc1ImgzgdKnlHqCDGvlfgVkUM4OQiTTrr44iTF5hr9MAjjijGDJZ9WSDMfuDARhM7lZvx6lcy7EP104vkOVtXdKji4hVpXMM553eMuusHCa/vD925gPW2Kq7CYMV/ZA8w8ni8Lau5x+ric4FVSjnhNBsrbpGUcCigqZb1z/wkhbEOlfH43heLu5JjsgXPJoV9dPMs6msnM6+Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rYa5T+uXxG8Bk2pdqK9IaVnGVqZMnhK5f9q7DS0zfQ=;
 b=i+Z0pyZJKnsmBvn82KyacsY0uDUmqwMOVaTdRdgb4EvabvCE72BGwH0/pG9KMuuKYz6FfErvyYjUNFSTj2/14W93ulPhMZstn7B7jb78a3JWxHeRGE3Eyj8Uw68gT7el6uATLPVrOHlvMFKYWmltZQbAPEw43aBtrUfdMGXsgmcAPwHmrhxNB2+YwPBvX50zYx43ywf7Li9UTVxEWPhL3eY2TreD7imeiIoUVI9s4gygQgtEC2SS8Rbv5P07tl9sSk15iE0NJ6gClVz91bBRLPlpMrohmxQ/EHBZwJDuSvDKqYCiCu9wN4u+Oie2oI/V9MYX3wcHd0NLY2aIotveSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7753.namprd11.prod.outlook.com (2603:10b6:208:421::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Fri, 15 Sep
 2023 17:43:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 17:43:27 +0000
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
Subject: Re: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
Thread-Topic: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
Thread-Index: AQHZ51OF0q1+5rEcHU+I1nLwKEUGdrAcKZsA
Date:   Fri, 15 Sep 2023 17:43:27 +0000
Message-ID: <fb70d8c29ebc91dc63e524a5d5cdf1f64cdbec73.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <1fa1eb80238dc19b4c732706b40604169316eb34.1692962263.git.kai.huang@intel.com>
In-Reply-To: <1fa1eb80238dc19b4c732706b40604169316eb34.1692962263.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7753:EE_
x-ms-office365-filtering-correlation-id: eb980520-0e70-4e99-18a5-08dbb61344af
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +VW9KOaybTIJmKeMKYkWD3b82mpNhvfo5YBc0rNXE86bJN1s5hoOFpxMSm/5u0rs3h0Y2jU0O2pM/LO3IOG3+HztDwvbd0L/HdDp456PsvqbT8XBmlWCWkLXXk3lm4BfjiagPBA1MC0zx36pifi9IPjrdEdaolXRvbpiLPKBNpap88jbV4Zxu2CQJGM9C+0vjIvvzP1rY/SCV4BrK51htlpOsFruB4ZEVPcHkKduIXZGKbbfVVtTiF5+jLJQvrNFEdErD0TA4Tx4yS2CHUwmpgsaWH58afRrWWAmIqmlnPenDToXkNVd9GA3+SkV41bJG8MBPX0Zh2oRnw99HPTM5IK14hz5ttbM09oPk6etqrq02/NtdOXD7OXoCYBZ+JQ6r2vSRjizmdoYlX+AVsCi2R7FIExQadeIzim/Cr4gRN7BrNSGFn5AwAnCkW7087I7eBJRV1UigFF2zQXaHr9Oado1OjQddEGAyY9ergoiQd6d4erooRfDLRT2zHqrnctufz5QH8Ct1CsqM/m1wTsjZ7HSy3S686v5eimxXR9a2As03szDh9DprK6fKPk/MvBaxOODtiDkr2xkxUmDX18B+hAjjr6umx6C1SwkIRaifg4VZuSHmykPQTlOZ4R5fzqP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199024)(186009)(1800799009)(86362001)(6506007)(54906003)(6486002)(6512007)(4326008)(76116006)(110136005)(66476007)(7416002)(2906002)(66556008)(316002)(8676002)(41300700001)(8936002)(64756008)(66446008)(6636002)(66946007)(5660300002)(36756003)(71200400001)(478600001)(91956017)(83380400001)(38100700002)(2616005)(38070700005)(82960400001)(122000001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L25XUGozNHBMOUEzVm16OVJWUXR6OVpjVDlZLzlLMUxaUy9vaTUycmNXK3B0?=
 =?utf-8?B?bUdkYm4zNG00U3NkbXRQa1RRZUxqaU4zZUh4c09BdHJvLy9mNU9TMjdIejVB?=
 =?utf-8?B?Yzcrd25nMGNtc0lUTEczS1lZM0NnRVdVT0lQOUwxR0QrcENWTFlDc3MwM3Fy?=
 =?utf-8?B?UjBRbFU2bkhKbEkyQU1hQTNmcnlmOWFjRW1hM3prWmdSckRSeHpvUVNhK20y?=
 =?utf-8?B?Z1B1OExvT1RFWWg4RCtIS3hFTVZEa1FJbmkxenovWjJTVlUrMmQ0THBGNmND?=
 =?utf-8?B?Z25UMFNvSWR2RHZEdXlkZDRjU0JLNGtkQUpsSC9lRWo3ZjhQQ2swemdPZmlx?=
 =?utf-8?B?ZDFPcTNpMzg0ZkJOeXdQWUR0cE1VSnRwOE93bkNONU13OWJaM1VuS0ZKQnk1?=
 =?utf-8?B?YWNibTB1bWlMa2FzTlJXOVdHajBqRzcrT2JicnIvQUpqblEzRjhnbllVWlpG?=
 =?utf-8?B?d2pmVmpHSVJoWFhIV0dJVi81YjNZdnlhNXdlRFBpM0tBT20ybjllcmU0aTY3?=
 =?utf-8?B?M2E5TTVvQ1grZEFKUENqMGpHRmNQT2ZDSStzWU81cDZCMHUwY2dUTk5xU0Fl?=
 =?utf-8?B?UVp3Y29zU3pDZnFPNjVHcmNCbDY3bUM4dzlrUCtGRTRYcXNrTEo4dFJZS2ll?=
 =?utf-8?B?NXhhWFA3U3VtUEQvMFVwWWhkK2xTbmc3ZFc3d0k4dzM0TDI1NDJLcW52eGZj?=
 =?utf-8?B?R0JFNUZHYVFUM3F2SVBSVUQrT2hQVWF1MFU2QkR5YkNOWEU4bkg5TWxmRElB?=
 =?utf-8?B?SU9wQnFEMkpKRlU3TTJTdnV5YVc5VlZtajY1dTh3NHBRS1E3WWpZNWdXU2p3?=
 =?utf-8?B?QXE5S3Z4UVZlODdUTDQ1bkR0dFpYcC9TSWlEOTNxWlhMaXNBUFFuQ2t3RFpp?=
 =?utf-8?B?UzlWcTJlVHVHMnhGck5uYkZoOGhBSWZ2Qlg5Ymw0SzNZL1M3ZFVGQkJBbTJn?=
 =?utf-8?B?Q2JxbllTQ0RkV0ZteU43OTQxNXBlU0lvb1JoUUhrMmI2YW1DdENHWFZRTDJi?=
 =?utf-8?B?ZzlTZ1l6U3ZibW9qUjNrRE5mRDN0TzlmVWVBUEg3Y0h0Q1ZNamVTT2RIeE5L?=
 =?utf-8?B?VzVyS1l1d0pFT1RXUXhXOEZDVWNJT2IyWUZqb2xlR0FlbEFabk9SK1dRL0dH?=
 =?utf-8?B?OFY2ZGIvOHkvUE5tbmFGV1R0cDJBeFltbFBWb01OYU5PeHZGenprSGZyOWpZ?=
 =?utf-8?B?V3hlM1d4dWNxNjBaWllqNDdWYWRjV1lwY0xiUFZCbHNVR0U2RlJobW1IUEpV?=
 =?utf-8?B?YnowWS9JMGJXNVV5SFNTSVJuVVVkMnhFNG5rNnVLb29CVWVDSmNjR2I0ZlZk?=
 =?utf-8?B?a3NPTWZobm41UlBUWmkyV3NqMk1hWnUzR0NKVVROellQQ2duSDhvOHBuSWE3?=
 =?utf-8?B?VDl0dkJNWjVYWDd0bm5kYnNHK0JNOStMMHY1SXFMTWlDV0tlSGdLanVNN2dM?=
 =?utf-8?B?dDJDdW56YnNRY2hBQzFtMDlCTTBzWmZLRE85cHNEOFV1WUxLR1o3K090SmhO?=
 =?utf-8?B?Qk5kWE1qcmtVL1YzU0EvOGNVVElWNXhjTEU5RmFHOHZZREd4dGxVMk1JRkJX?=
 =?utf-8?B?WUtxdzJVT0R6UlVzazNYc1FWQnoxWkd2L1Z1Q1h3Vm1SNE9YallUZDB1SGg5?=
 =?utf-8?B?REhLMTRUcVFnQXFIV0NtMUJaOXcxTVJMVEtwVEJRNnZPOWdFWjJ0dkhCQk1o?=
 =?utf-8?B?end6M0tSS2trVmcrNXJGK2xUTXVXSEtvL0pPUU9pOU5sWFNtUTBINjRpdnB2?=
 =?utf-8?B?ckd3NzdOMmJFa20xdFlwWTJNbEJqTGtSYjlWaFVkYWRPdWxRMTdpRGtDY0VT?=
 =?utf-8?B?c2YwWlpVcVRQMnVUUDFtVTFpRzhZRGwweDE2QWpnOS84elo3aFhNRkdJUkor?=
 =?utf-8?B?MndBZ1dxMDAydndRUDVSbTVkcWZQWWN2a0o5TGpUUmFQcC9CZTBRUTl2SWt5?=
 =?utf-8?B?NjNKRTd6bUUxMHMyRjB6em8raFJJb2drdy8rVzdtdXBhL0tyWlo4V2k2clNI?=
 =?utf-8?B?VEJ1WC9wN1lpeFNMNCtoM3BONXVaMlZuWDg2VkIxOGFIdytYUENVYmNuTmgr?=
 =?utf-8?B?RjFIUVR3VU1TNkhjUlVLVlVUeHB1UnEwVmdMS1ErajEwM2FwVWRUZk5MQTR3?=
 =?utf-8?B?cXpoWFlQZjhsb2tDbWtzT3k4WUJyN3prN1NleHR3SjJtVFUwWnNmc2VJQUN4?=
 =?utf-8?Q?O25yt7hvWBL7pPNAIbsMLCA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67DE918E591A2F468DCF468D41780D7F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb980520-0e70-4e99-18a5-08dbb61344af
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 17:43:27.5916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A4oRV/Q2JkqUA84kvzski3CKlvBR0FnT+h3HjBvRIqun44wZ/kJAyB9XQpHhmAZ4NJj0UhxHxk9hd/8MbFL7wFgrZoFPxYfcqjEfsvKOVVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7753
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIzLTA4LTI2IGF0IDAwOjE0ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IFRo
ZXJlIGFyZSB0d28gcHJvYmxlbXMgaW4gdGVybXMgb2YgdXNpbmcga2V4ZWMoKSB0byBib290IHRv
IGEgbmV3DQo+IGtlcm5lbA0KPiB3aGVuIHRoZSBvbGQga2VybmVsIGhhcyBlbmFibGVkIFREWDog
MSkgUGFydCBvZiB0aGUgbWVtb3J5IHBhZ2VzIGFyZQ0KPiBzdGlsbCBURFggcHJpdmF0ZSBwYWdl
czsgMikgVGhlcmUgbWlnaHQgYmUgZGlydHkgY2FjaGVsaW5lcw0KPiBhc3NvY2lhdGVkDQo+IHdp
dGggVERYIHByaXZhdGUgcGFnZXMuDQoNCkRvZXMgVERYIHN1cHBvcnQgaGliZXJuYXRlPyBJJ20g
d29uZGVyaW5nIGFib3V0IHR3byBwb3RlbnRpYWwgcHJvYmxlbXM6DQoxLiBSZWFkaW5nL3dyaXRp
bmcgcHJpdmF0ZSBwYWdlcyBmcm9tIHRoZSBkaXJlY3QgbWFwIG9uIHNhdmUvcmVzdG9yZQ0KMi4g
VGhlIHNlYW0gbW9kdWxlIG5lZWRpbmcgdG8gYmUgcmUtaW5pdGVkICh0aGUgdGR4X2VuYWJsZSgp
IHN0dWZmKQ0KDQpJZiB0aGF0J3MgdGhlIGNhc2UgeW91IGNvdWxkIGhhdmUgc29tZXRoaW5nIGxp
a2UgdGhlIGJlbG93IHRvIGp1c3QNCmJsb2NrIGl0IHdoZW4gVERYIGNvdWxkIGJlIGluIHVzZToN
CmRpZmYgLS1naXQgYS9rZXJuZWwvcG93ZXIvaGliZXJuYXRlLmMgYi9rZXJuZWwvcG93ZXIvaGli
ZXJuYXRlLmMNCmluZGV4IDJiNGE5NDZhNmZmNS4uM2IxYjcyMDI0NTJkIDEwMDY0NA0KLS0tIGEv
a2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jDQorKysgYi9rZXJuZWwvcG93ZXIvaGliZXJuYXRlLmMN
CkBAIC04NCw3ICs4NCw4IEBAIGJvb2wgaGliZXJuYXRpb25fYXZhaWxhYmxlKHZvaWQpDQogew0K
ICAgICAgICByZXR1cm4gbm9oaWJlcm5hdGUgPT0gMCAmJg0KICAgICAgICAgICAgICAgICFzZWN1
cml0eV9sb2NrZWRfZG93bihMT0NLRE9XTl9ISUJFUk5BVElPTikgJiYNCi0gICAgICAgICAgICAg
ICAhc2VjcmV0bWVtX2FjdGl2ZSgpICYmICFjeGxfbWVtX2FjdGl2ZSgpOw0KKyAgICAgICAgICAg
ICAgICFzZWNyZXRtZW1fYWN0aXZlKCkgJiYgIWN4bF9tZW1fYWN0aXZlKCkgJiYNCisgICAgICAg
ICAgICAgICAhcGxhdGZvcm1fdGR4X2VuYWJsZWQoKTsNCiB9DQogDQogLyoqDQoNCk9yIG1heWJl
IGJldHRlciwgaXQgY291bGQgY2hlY2sgdGR4X21vZHVsZV9zdGF0dXM/IEJ1dCB0aGVyZSBpcyBu
byB3YXkNCnRvIHJlYWQgdGhhdCB2YXJpYWJsZSBmcm9tIGhpYmVybmF0ZS4NCg0K
