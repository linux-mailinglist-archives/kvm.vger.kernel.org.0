Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B48E741C5A
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 01:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjF1XVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 19:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjF1XVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 19:21:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A411FFB;
        Wed, 28 Jun 2023 16:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687994492; x=1719530492;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=24VLiy652PCvlh7jengHmRFmesITye54jFSo2+l9g3g=;
  b=NENEE3lI7or1Wwe9NVjdBtLemcdh67BjMtbcZNy0Wj4tDIQa1RGJq6Vd
   wBHpLFR7RUmcqQSmheYUnp3K3Ud/jHsbeXKaNemI5JqwT6oJrY74rnif1
   zSU1CEKvGjg1nYhmNXKNBmENAjP72KOLlq8V7hyMAG/uVxKJsNvPmvZAP
   4fITuJ4BYDrHg7YWyCi6lCKP1v3Fr0VJq6pTa9PQju6JvtJD5zu+rUOKF
   lT58tbLYMb/w0fuk/FbzZV8nRrJnupnvRFeWy1UAYnTdBQ6uhWD4dhiyr
   O/BY9I5RYLeulwOi3Iz4BCKIWUtFQ7xC/DZVOIl7p+2NYs4J5nUZqD72m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="359472639"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="359472639"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 16:21:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="667301656"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="667301656"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 28 Jun 2023 16:21:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 16:21:30 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 16:21:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 16:21:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 16:21:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZb9SUT+Z6Y8jhPHzro+WDcd8v1qU2UYkhCcsYH9w6DmEBu2O8NQTIGMWTT84jcNJHHVwBPErUc+2Bu06VT97mHYw625zTFlM2PWkMxTRsM44uGYNJ9RxtaSATlUtdW1SpYXtniVC1TP5SzXsxzqzBD+m4GMnF2agz6MwTRwPjcvUsBsedLC6DohKZCGJWqhqpB2j0Y0kt8xsHbe8697JdG9gXUUCnZqgDO5Aeifyp6XWU1Xu0uaY5f+kBCYTu8H5c6P/EOiciJY1PFgUn8hmTxW0ZgEXqt2oADovjsJu8FxoSS0ceOdT4epvrZb21YozhU+hPa87grWF2QN1vcpwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24VLiy652PCvlh7jengHmRFmesITye54jFSo2+l9g3g=;
 b=lAnqTLJKH2YE4Ln+tShh8O0GBEmDS8XzD6G+/VwAM7YQ5cboy+KJ66bg47AwDdzWy/6b/cUqNAG03LD/smu/AyET4Wis+kjSSJsI3jUIfOBR4dYdJS795xd0cnNNRI3OY16kDu44p2lwGBJb2Z9IBM06AAXJXTmIslxDEY5XLxXlZPDOcZHIPQWaSSlFT+by+jWcNmAndkgz7J4IiWm6HTsEsaN/ZvXem9gm//suoOwi8MJVsbN3f/Z5z4i7yUknGfXfcTZcgpQZJEUh0DDH+DK2eUiSfSbSdHp0sCKprQ3m5XPFDIlzt5vQZsaZ/qvywM58nLXIwbWIVOqI4H8iQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7760.namprd11.prod.outlook.com (2603:10b6:8:100::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 23:21:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 23:21:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZqDWtRkTpkzZfa0qfwqSEOzdd8q+gL/mAgACuGQA=
Date:   Wed, 28 Jun 2023 23:21:23 +0000
Message-ID: <84f0acd416aef0796317e76edcf0b63622583436.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
         <20230628125813.GA2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628125813.GA2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB7760:EE_
x-ms-office365-filtering-correlation-id: bbcc8f74-e6b4-4a30-ae9d-08db782e635d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EfcRK2fFn5eowI2czPq3AE+0xj/E9jQZG9b3FozgyMRAt/uf/VlJVT1EIqdFXdKPMZA+LlykaS7yvbRJ3p7kSvFsQBPdqssYBODG9r8JBJle9o64YOplsEJ7tRjYfB2dq1O5XsmrPRXH/S/CHEdrNMCaCVtxPXXxGG1Wzegj515y/4wn8CR81xaLIVmnyzBUpRSyc8yz+JYtFbNZeFnfsquYJ/fX8Vp7JHMfck3x3WBUASy3rPEen2CnWibqZXhsLGAQHARowO7UyXTvY1yj13etewgGnxgDCmcOdAy16lsQVN7F6brPlm01xnwJ2aTLjtr8KH9c265i1gLD1LiWnj5v0PLXp10EO3HU6Z4mvS2KVc8Xr2pXorRYzMAKfqBkSDIe0bvDIuFZXxepjnSsk7itv3toLQQr2WT+I3fl7DOGxQUPipLaVfc/l6f/a1UeeLPxe5hiCguvFEv3NiD6fLow7ACqO7tQ9XMVMu4lNzadv+l85YUrIl4ogm+NdOirkc+vDqWAnk2Lcd7UjnQAM8pazYk8LNkjEOD/HdspEpYHjSBqNqPqYj5MeUwxxzMcza5hje617QyZG4xuV4xwDXkfKtsufpBwV38w7RW1VHIxKnyiCFeOIP7yL1DyCumy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199021)(83380400001)(54906003)(478600001)(6486002)(2906002)(66946007)(186003)(26005)(71200400001)(66476007)(64756008)(66446008)(6506007)(66556008)(6512007)(91956017)(7416002)(316002)(41300700001)(76116006)(38100700002)(5660300002)(8676002)(36756003)(6916009)(8936002)(4326008)(122000001)(86362001)(82960400001)(38070700005)(2616005)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEEwWC9vTDdaWkl6MElaSkFXcitRZ0lQZU5wT2IwemVSNDNXdkFVZVh4eEdD?=
 =?utf-8?B?VlFrclBSWG5EaExQWURPNmkvSWNtQkd0Ky9jWGROYlFzeTFGTnZTK2hSbEIv?=
 =?utf-8?B?MU80Q1RreE1ucGtqN2RBdHU2alk0ckp2SVpKSzFyam13cTZiNXJka1RuTmx3?=
 =?utf-8?B?MXdvTzlkbWxOMmlIQ1FHRG9DUGVVWFp1TGJ0blR2SXVsYTV3Szl0SHBGOU1s?=
 =?utf-8?B?SytTRXBGV2VYSkp2aXlCN2lPRzNDd0EzLzVxRVJTWlhuS1d6WTlWNnF1U2pM?=
 =?utf-8?B?ZEVGYkRFbHUxVm9FMXZ4dDc2TFVYbEFCWXlKeDkvVksrWEwySFVCTnRVT0tt?=
 =?utf-8?B?a2RjRHAzZjhDK2RPdlpJUjlKZ1ExNGpxSzUyakxmUzBaOFdyejNQREpjbits?=
 =?utf-8?B?V3VhdjhCRVIzTys1eUROMFRXb3d2OWNwSTQ0amUwY2RGK1h6V1h3QUNsTS9u?=
 =?utf-8?B?elE4blVHSVhNSTNmMjd3aGphakxyNmYrUkh2Mm5ydjcrWDhmVmU4VmpaSUlW?=
 =?utf-8?B?NXFoV2lGc1kyM0ZJVWtxaHZQTnVlSFlnRy9lQVVkVStIK2JmcXcvUWJSL09Q?=
 =?utf-8?B?ZksyaG0wMzg5MjVBaWxFTVp1K0F0bmQ5ek9pZEh3TFhJazQzeWpxMlRxY0d3?=
 =?utf-8?B?ZkxmWlloa2ZjQmIrRnh0bnBHS3YrUDlPK2tVbUNGVXlndlhaTFV3Yk9iUlpD?=
 =?utf-8?B?aGNWK2dKWkVMMmdCY1UxRld3b3FmYWFHYmpldzRxREpxSzJlSzV1MnZBL0dJ?=
 =?utf-8?B?SytxajAvallqRENQVjFOSW85VUZEQStPcGVGdkhXbnJncDk3MmN0L3NLQVMx?=
 =?utf-8?B?cGFGQTQ1WUpZbDhiM2dLd2RZT1JoekxwS24wNExYWSs4NzFpWUhodG5Eako4?=
 =?utf-8?B?aitYY2tSMDRJN0VIdmt2Rm1ueTllZmJWK28wZUYwZUxlb3kzK0xxdUZiV01Q?=
 =?utf-8?B?QnFRN2t3ZWxzeHFJSDBpRHBtQ2NTYVhQdzRRYTA0Y1BCa01qb1FxMnhnaW5a?=
 =?utf-8?B?UHlOMTErTzVnSUxiVG05V3Avb2tSWTkrNUpTY1JHdVR6d2lrOVMzWTZwRjFX?=
 =?utf-8?B?cXRseUhrelVTcFQxMDlCU2tOa25raXhrMzhQK2ZpbGEySVIrVGg5alAwTE80?=
 =?utf-8?B?ckc2REc4Nm5ieXg0QkI5N0J5dmhSeG9zZlM1WHNHVDNCbDlnaVBINVJFZ3Ro?=
 =?utf-8?B?NW1ZakRxUEVTMW81YjdHb2RqaGs3ZUJ4aXEwZEgra3F6dkhqVm1FYjZUOU9I?=
 =?utf-8?B?SlA5bUJXWnc0WFhYR3o5Q2tZc0tST0dyNVFvcVJvVHRvYjlRMTladUtTUHpJ?=
 =?utf-8?B?QVg4L2V2Z0VhV1VVOVhwSVJ2WE9Kc1VSZGZoN3Rjc3RqUUxIdE8ySkcrUHJx?=
 =?utf-8?B?N2JQN0dxUnh2eVcyYkFQNW5OZkJsVm83dkpRUGwrKzlVb3ZOT1hsbSs4SWlj?=
 =?utf-8?B?ZVZwUGs4M2FuVS83enBZWndHS3BxQWplMlhuQ3pCKzVXUWhmbkhES2dlaDJx?=
 =?utf-8?B?VVc0cTdDNkVCYXZEUExmOEEwNjA4MEl4ek1kQjdPMHdiaWxSWmVNenVRcVNk?=
 =?utf-8?B?MG5Sd3ovWjZmZmhrbHlRWlFVMmVOV1ZjSGwvSG9WdEIyZHUzNDVVbm40OXh5?=
 =?utf-8?B?VFFUd0QzcmNWWHdoSHVRbDdRSy9jK21zYzExK2FLQjVoNFhvcTUxb0ZsN2Vr?=
 =?utf-8?B?Y1ArNlE3SVZEY3JiSnpSTUJvc3QyTWd4WjNhYzZWZitLNDNLMUJFOGplckE0?=
 =?utf-8?B?WnprM0RUYytpZ3ZlUXhlSHRaeXY5bnBsbG9zRjNLYWFDZkd0L1J2TmFEZGZM?=
 =?utf-8?B?N0RaTUM2eVJQN3lPUW5ER1h5d0JzK3Fvc1M4NzQ5cVZUd09rMXdjTlFUUmZ4?=
 =?utf-8?B?Ty9wNFk5c2MrRU5PcGxGTzd1cjVyc1ZWZ2ZrMVhuY3FUQ3lXL2ErdEFPMWZ6?=
 =?utf-8?B?RlNSeUtlaWNoOHNSbkllcFAvWnZXbDBZeWR1dHh3N01pOFlISE9DOXY2MCt5?=
 =?utf-8?B?UXo3SURhS1NQTFY4cmNuaEtJMVRyekpwUnFCQjlPenB1NXNzYm5kWDNMKzdo?=
 =?utf-8?B?azlHY0MyS0V5TDFJamp4clNFSktydnVvbEE1cnRnZFp2M1BFZUdUQzZMWjdI?=
 =?utf-8?B?WU16RXZDS0NqMjE5UjZGWXJGVDFSMjg0dktBSlNWUlo1SzNhbVMxVnJNS3Vz?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5C0F09F6A0A364BAF59F48F540EC38C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbcc8f74-e6b4-4a30-ae9d-08db782e635d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 23:21:23.3513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKv8ByXXFgLY5Qkdw+p1gTjlqvBl5bYVjWRqguZKThigXWl2LidtBO70i7uSRZ5UMcxnvw+KbsPyztC4cpFLKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7760
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE0OjU4ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6MzVBTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiANCj4gPiArc3RhdGljIGludCBfX2Fsd2F5c191bnVzZWQgc2VhbWNhbGwodTY0IGZu
LCB1NjQgcmN4LCB1NjQgcmR4LCB1NjQgcjgsIHU2NCByOSwNCj4gDQo+IF9fYWx3YXlzX2lubGlu
ZSBwZXJoYXBzPyBfX2Fsd2F5c191bnVzZWQgc2VlbXMgd3JvbmcsIHdvcnNlIGl0J3Mgc3RpbGwN
Cj4gdGhlcmUgYXQgdGhlIGVuZCBvZiB0aGUgc2VyaWVzOg0KPiANCj4gJCBxdWlsdCBkaWZmIC0t
Y29tYmluZSAtIHwgZ3JlcCBzZWFtY2FsbA0KPiAuLi4NCj4gK3N0YXRpYyBpbnQgX19hbHdheXNf
dW51c2VkIHNlYW1jYWxsKHU2NCBmbiwgdTY0IHJjeCwgdTY0IHJkeCwgdTY0IHI4LCB1NjQgcjks
DQo+IC4uLg0KPiArICAgICAgIHJldCA9IHNlYW1jYWxsKFRESF9TWVNfSU5JVCwgMCwgMCwgMCwg
MCwgTlVMTCwgTlVMTCk7DQo+ICsgICAgICAgcmV0ID0gc2VhbWNhbGwoVERIX1NZU19MUF9JTklU
LCAwLCAwLCAwLCAwLCBOVUxMLCBOVUxMKTsNCj4gKyAgICAgICByZXQgPSBzZWFtY2FsbChUREhf
U1lTX0lORk8sIHN5c2luZm9fcGEsIFREU1lTSU5GT19TVFJVQ1RfU0laRSwNCj4gKyAgICAgICBy
ZXQgPSBzZWFtY2FsbChUREhfU1lTX0NPTkZJRywgX19wYSh0ZG1yX3BhX2FycmF5KSwNCj4gKyAg
ICAgICByZXR1cm4gc2VhbWNhbGwoVERIX1NZU19LRVlfQ09ORklHLCAwLCAwLCAwLCAwLCBOVUxM
LCBOVUxMKTsNCj4gKyAgICAgICAgICAgICAgIHJldCA9IHNlYW1jYWxsKFRESF9TWVNfVERNUl9J
TklULCB0ZG1yLT5iYXNlLCAwLCAwLCAwLCBOVUxMLA0KPiAuLi4NCj4gDQo+IERlZmluaXRlbHkg
bm90IHVudXNlZC4NCg0KVGhhbmtzIGZvciByZXZpZXdpbmchDQoNClNvcnJ5IG9idmlvdXNseSBJ
IGZvcmdvdCB0byByZW1vdmUgX19hbHdheXNfdW51c2VkIGluIHRoZSBwYXRjaCB0aGF0IGZpcnN0
bHkNCnVzZWQgc2VhbWNhbGwoKS4gIFNob3VsZCBiZSBtb3JlIGNhcmVmdWwuIDooDQoNCj4gDQo+
ID4gKwkJCQkgICAgdTY0ICpzZWFtY2FsbF9yZXQsDQo+ID4gKwkJCQkgICAgc3RydWN0IHRkeF9t
b2R1bGVfb3V0cHV0ICpvdXQpDQo+IA0KPiBUaGlzIGludGVyZmFjZSBpcyBhdHJvY2lvdXMgOi8g
V2h5IGhhdmUgdGhlc2UgdHdvIHJldCB2YWx1ZXM/IFdoeSBjYW4ndA0KPiB0aGF0IGxpdmUgaW4g
YSBzaW5nbGUgc3BhY2UgLS0gL21lIGxvb2tzIHRocm91Z2h0IHRoZSBjYWxsZXJzLCBhbmQgZmlu
ZHMNCj4gc2VhbWNhbGxfcmV0IGlzIHVudXNlZCA6LSgNCg0KSSdsbCBAc2VhbWNhbGxfcmV0IGFz
IGFsc28gc3VnZ2VzdGVkIGJ5IEtpcmlsbC4NCg0KPiANCj4gV29yc2UsIHRoZSBpbnB1dCAoYyxk
LDgsOSkgaXMgYSBzdHJpY3Qgc3Vic2V0IG9mIHRoZSBvdXRwdXQNCj4gKGMsZCw4LDksMTAsMTEp
IHNvIHdoeSBpc24ndCB0aGF0IGEgc2luZ2xlIHRoaW5nIHVzZWQgZm9yIGJvdGggaW5wdXQgYW5k
DQo+IG91dHB1dC4NCj4gDQo+IHN0cnVjdCB0ZHhfY2FsbCB7DQo+IAl1NjQgcmN4LCByZHgsIHI4
LCByOSwgcjEwLCByMTE7DQo+IH07DQo+IA0KPiBzdGF0aWMgaW50IF9fYWx3YXlzX2lubGluZSBz
ZWFtY2FsbCh1NjQgZm4sIHN0cnVjdCB0ZHhfY2FsbCAqcmVncykNCj4gew0KPiB9DQo+IA0KPiAN
Cj4gCXN0cnVjdCB0ZHhfcmVncyByZWdzID0geyB9Ow0KPiAJcmV0ID0gc2VhbWNhbGwoVEhEX1NZ
U19JTklULCAmcmVncyk7DQo+IA0KPiANCj4gDQo+IAlzdHJ1Y3QgdGR4X3JlZ3MgcmVncyA9IHsN
Cj4gCQkucmN4ID0gc3lzaW5mb19wYSwJLnJkeCA9IFREWFNZU0lORk9fU1RSVUNUX1NJWkUsDQo+
IAkJLnI4ICA9IGNtcl9hcnJheV9wYSwJLnI5ICA9IE1BWF9DTVJTLA0KPiAJfTsNCj4gCXJldCA9
IHNlYW1jYWxsKFRIRF9TWVNfSU5GTywgJnJlZ3MpOw0KPiAJaWYgKHJldCkNCj4gCQlyZXR1cm4g
cmV0Ow0KPiANCj4gCXByaW50X2NtcnMoY21yX2FycmF5LCByZWdzLnI5KTsNCj4gDQo+IA0KPiAv
bWUgbG9va3MgbW9yZSBhdCB0aGlzIHN0dWZmIGFuZCAuLi4gV1RGIT8hPw0KPiANCj4gQ2FuIHNv
bWVvbmUgZXhwbGFpbiB0byBtZSB3aHkgX190ZHhfaHlwZXJjYWxsKCkgaXMgc2FuZSAocGVyIHRo
ZSBhYm92ZSkNCj4gYnV0IHRoZW4gd2UgZ3JldyBfX3RkeF9tb2R1bGVfY2FsbCgpIGFzIGFuIGFi
c29sdXRlIGFib21pbmF0aW9uIGFuZCBhcmUNCj4gYXBwYXJlbnRseSB1c2luZyB0aGF0IGZvciBz
ZWFtIHRvbz8NCj4gDQo+IA0KDQpTb3JyeSBJIGRvbid0IGtub3cgdGhlIHN0b3J5IGJlaGluZCBf
X3RkeF9oeXBlcmNhbGwoKS4NCg0KRm9yIFREQ0FMTCBhbmQgU0VBTUNBTEwsIEkgYmVsaWV2ZSBv
bmUgcmVhc29uIGlzIHRoZXkgY2FuIGJlIHVzZWQgaW4gcGVyZm9ybWFuY2UNCmNyaXRpY2FsIHBh
dGguICBUaGUgQG91dCBpcyBub3QgYWx3YXlzIHVzZWQsIHNvIHB1dHRpbmcgYWxsIG91dHB1dHMg
dG8gYQ0Kc3RydWN0dXJlIGNhbiByZWR1Y2UgdGhlIG51bWJlciBvZiBmdW5jdGlvbiBwYXJhbWV0
ZXJzLiBJIG9uY2UgaGFkIHNlcGFyYXRlDQpzdHJ1Y3QgdGR4X3NlYW1jYWxsX2lucHV0IHt9IGFu
ZCBzdHJ1Y3QgdGR4X3NlYW1jYWxsX291dCB7fSBidXQgd2Fzbid0DQpwcmVmZXJyZWQuDQoNCktp
cmlsbCwgY291bGQgeW91IGhlbHAgdG8gZXhwbGFpbj8NCg0KPiANCj4gDQo+ID4gK3sNCj4gPiAr
CXU2NCBzcmV0Ow0KPiA+ICsJaW50IGNwdTsNCj4gPiArDQo+ID4gKwkvKiBOZWVkIGEgc3RhYmxl
IENQVSBpZCBmb3IgcHJpbnRpbmcgZXJyb3IgbWVzc2FnZSAqLw0KPiA+ICsJY3B1ID0gZ2V0X2Nw
dSgpOw0KPiANCj4gQW5kIHRoYXQncyBpbXBvcnRhbnQgYmVjYXVzZT/CoA0KPiANCg0KSSB3YW50
IHRvIGhhdmUgYSBzdGFibGUgY3B1IGZvciBlcnJvciBtZXNzYWdlIHByaW50aW5nLg0KDQo+IERv
ZXMgaGF2aW5nIHByZWVtcHRpb24gb2ZmIGFjcm9zcyB0aGUNCj4gc2VhbWNhbGwgbWFrZSBzZW5z
ZT8gRG9lcyBpdCBzdGlsbCBtYWtlIHNlbnNlIHdoZW4geW91IGFkZCBhIGxvb3AgbGF0ZXI/DQoN
ClNFQU1DQUxMIGl0c2VsZiBpc24ndCBpbnRlcnJ1cHRpYmxlLCBzbyBJIHRoaW5rIGhhdmluZyBw
cmVlbXB0aW9uIG9mZiBhcm91bmQNClNFQU1DQUxMIGlzIGZpbmUuICBCdXQgSSBhZ3JlZSBkaXNh
YmxpbmcgcHJlZW1wdGlvbiBhcm91bmQgbXVsdGlwbGUgU0VBTUNBTEwNCmlzbid0IGlkZWFsLiAg
SSdsbCBjaGFuZ2UgdGhhdCB0byBvbmx5IGRpc2FibGUgcHJlZW1wdGlvbiBhcm91bmQgb25lIFNF
QU1DQUxMIHRvDQpnZXQgYSBjb3JyZWN0IENQVSBpZCBmb3IgZXJyb3IgcHJpbnRpbmcuDQoNCj4g
DQo+ID4gKwlzcmV0ID0gX19zZWFtY2FsbChmbiwgcmN4LCByZHgsIHI4LCByOSwgb3V0KTsNCj4g
PiArCXB1dF9jcHUoKTsNCj4gPiArDQo+ID4gKwkvKiBTYXZlIFNFQU1DQUxMIHJldHVybiBjb2Rl
IGlmIHRoZSBjYWxsZXIgd2FudHMgaXQgKi8NCj4gPiArCWlmIChzZWFtY2FsbF9yZXQpDQo+ID4g
KwkJKnNlYW1jYWxsX3JldCA9IHNyZXQ7DQo+ID4gKw0KPiA+ICsJc3dpdGNoIChzcmV0KSB7DQo+
ID4gKwljYXNlIDA6DQo+ID4gKwkJLyogU0VBTUNBTEwgd2FzIHN1Y2Nlc3NmdWwgKi8NCj4gPiAr
CQlyZXR1cm4gMDsNCj4gPiArCWNhc2UgVERYX1NFQU1DQUxMX1ZNRkFJTElOVkFMSUQ6DQo+ID4g
KwkJcHJfZXJyX29uY2UoIm1vZHVsZSBpcyBub3QgbG9hZGVkLlxuIik7DQo+ID4gKwkJcmV0dXJu
IC1FTk9ERVY7DQo+ID4gKwlkZWZhdWx0Og0KPiA+ICsJCXByX2Vycl9vbmNlKCJTRUFNQ0FMTCBm
YWlsZWQ6IENQVSAlZDogbGVhZiAlbGx1LCBlcnJvciAweCVsbHguXG4iLA0KPiA+ICsJCQkJY3B1
LCBmbiwgc3JldCk7DQo+ID4gKwkJaWYgKG91dCkNCj4gPiArCQkJcHJfZXJyX29uY2UoImFkZGl0
aW9uYWwgb3V0cHV0OiByY3ggMHglbGx4LCByZHggMHglbGx4LCByOCAweCVsbHgsIHI5IDB4JWxs
eCwgcjEwIDB4JWxseCwgcjExIDB4JWxseC5cbiIsDQo+ID4gKwkJCQkJb3V0LT5yY3gsIG91dC0+
cmR4LCBvdXQtPnI4LA0KPiA+ICsJCQkJCW91dC0+cjksIG91dC0+cjEwLCBvdXQtPnIxMSk7DQo+
IA0KPiBBdCB0aGUgdmVyeSBsZWFzdCB0aGlzIGxhY2tzIHsgfSwgYnV0IGl0IGlzIHF1aXRlIGhv
cnJlbmRvdXMgY29kaW5nDQo+IHN0eWxlLg0KPiANCj4gV2h5IHN3aXRjaCgpIGF0IGFsbCwgd291
bGQgbm90Og0KPiANCj4gCWlmICghcnNldCkNCj4gCQlyZXR1cm4gMDsNCj4gDQo+IAlpZiAoc3Jl
dCA9PSBURFhfU0VBTUNBTExfVk1GQUlMSU5WQUxJRCkgew0KPiAJCXByX25vbnNlbnNlKCk7DQo+
IAkJcmV0dXJuIC1FTk9ERVY7DQo+IAl9DQo+IA0KPiAJaWYgKHNyZXQgPT0gVERYX1NFQU1DQUxM
X0dQKSB7DQo+IAkJcHJfbm9uc2Vuc2UoKTsNCj4gCQlyZXR1cm4gLUVOT0RFVjsNCj4gCX0NCj4g
DQo+IAlpZiAoc3JldCA9PSBURFhfU0VBTUNBTExfVUQpIHsNCj4gCQlwcl9ub25zZW5zZSgpOw0K
PiAJCXJldHVybiAtRUlOVkFMOw0KPiAJfQ0KPiANCj4gCXByX25vbnNlbnNlKCk7DQo+IAlyZXR1
cm4gLUVJTzsNCj4gDQo+IGJlIG11Y2ggY2xlYXJlciBhbmQgaGF2ZSBsZXNzIGhvcnJpZmljIGlu
ZGVudGluZyBpc3N1ZXM/DQoNCkkgY2FuIGNlcnRhaW5seSBjaGFuZ2UgdG8gdGhpcyBzdHlsZS4g
IFRoYW5rcy4NCg0K
