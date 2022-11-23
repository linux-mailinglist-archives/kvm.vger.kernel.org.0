Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A37635766
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 10:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbiKWJmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 04:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiKWJmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 04:42:01 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E94114BB8;
        Wed, 23 Nov 2022 01:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669196404; x=1700732404;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DFuspZ+LJQArl69V04JXnrL3F5Wu9uZSHFH/o52UcZI=;
  b=j1FRQrX0z9982lNWoyn6teBbKKgnmo1tl07qqY1mXxvNB+8p/URHVC3r
   VuIBkN5YGu+9Q78tqb3IjHKVyg+O9vcuabPOXkuw6R6G8lwouhQy2mt5B
   Qa3aBYCrglaSAbm/Fs/EW3kIE7nKPeEtYbMwa5TfzlbhRGcLBL6lB6FGe
   uFE74vsiAXOFeR4rlPVp1+rGuUJfZzQmFsQimxOiBDXsrK8k22Rc4MpzK
   Z1Rnl9QWsD3b4PBFgHT+FsPT9NiyuN88bqVa4XEkb01kWlXSXyF03+xiz
   brg03OUajdoQkkwRu5LVI8St4Hl0gl4S3klNbiBCmWNVydhNBEIiKoDWX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="314060677"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="314060677"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 01:40:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="592459340"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="592459340"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2022 01:40:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 01:40:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 01:40:02 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 01:40:02 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 01:40:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1eOWrdH6U7/JD2xQZcmySUxTn5q1NRR5pY72/v8S5yNvKWzF0SEMO+8P9CCL6OLl2KhurDg8fncd8je74thJhqUjswmtFgrGwnH3QYdFgtb860NpT47AS9tpKrQ/WrUWvv/sqxa7QEHLGmFxIAIfUhnm+LgkBFOuxqJwFdCPTQl0llJAVGe+1ztIXaCqywWgrwSyzRncoBaY8KvVmof8kx6QAAsu+v6MDTOdalh9RyNCdSaBU0/MwWSsEE7+VW86z04i9JOFwc14Bo+Me+tk64MhRW9Vhdoruck3FwhwRy6pImMs5gSvpdUC8GNE8WFUyXQUWj22MA3d+CjHXdFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFuspZ+LJQArl69V04JXnrL3F5Wu9uZSHFH/o52UcZI=;
 b=DAopVomg8Zm6izsH2I8n8snXj+lo/QoRcZluKCt8sDrjSk7aaHx8OEZV03X3wpvEbNETSvnYOnmhtVF1QfcwWdBFE8v6Yz3N9vXgPl8sEkqUMoBWDeruuJmh8vsfMI7Jxc3rr8SGmxS1MHPWub2YC1X7C0a7LNHPnNND7Az3/xQ8rUb+scN03JGQoTTS313RK+d5NmXBneg+UGNUsxpGSasTx5SLNF7jiMb+1hxUbbUaFmW5Qnjix3OkTFzV5hbVQtu2D/aejrieYofV0eJhWODofwGJvlOVSxucjNQzjAexoQYdM/ssRcRANt7NRagkiys3NKqeMy/r392LGtPh6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4531.namprd11.prod.outlook.com (2603:10b6:5:2a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 09:39:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 09:39:58 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Topic: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Index: AQHY/T2+AlEdwutNGkW7IAmyyjQDW65KrPSAgABgioCAAEMZAIAABv8AgADtBIA=
Date:   Wed, 23 Nov 2022 09:39:58 +0000
Message-ID: <9b4c8ecd3c26fc51d0c135aeb197f5bd58625365.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
         <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net> <87bkozgham.ffs@tglx>
         <Y30dujuXC8wlLwoQ@hirez.programming.kicks-ass.net>
         <Y30jmKOOsvtzt6UT@google.com>
In-Reply-To: <Y30jmKOOsvtzt6UT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4531:EE_
x-ms-office365-filtering-correlation-id: 5a557ff1-84a9-463a-23cf-08dacd36af9d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B3DJinwTIq49MyaXK/F5Gt7x/NHUjppNqd4kQ/UmW30+e0eehw+jZ184pcCP5IdNG8FFhdzErFvss1LosU/cat9z13XtBjJZX2i6b1/d+his/IbY8wY4BpCDwW43i8AQfiQ4wYJSAjQZre5dhuZvT4FW8P6IudhdLS8gQS5ATCKFpQhlhr9ut9te5uCqpVP3+PEdb6fSCU95+Oq/LnX7tC3fswLk79TLAVTrlIHpsvWAjcVlxaBMH5Wyt9HiB6vokKZuFH3J2YfpdVT2JHZwRAC89ODeXlQYr83flBSRp9yEiipSGD6YSNxs9daCQ3dx64kHJpNQeyUqDA0QNxwfMgwx/uO2LmmH+Lt07tf8DWqONe3nWykdxJRQjTUYv5maSeajpDBUUAvQDzb8unT01nl92yxzdy69X1wn4XPmv9XgYhIliMD+ZXrQjtSP+YZKsCQXcVDqHAa1CwllMY0wGDTSzb0vqjMOM3od4xrspsfx2zpZB7npfGGYw9Xt+q91r6wQ4LVPjv6KIWekHa1p562o6WrVSCkmo0Uc2aEdG9eypN9t258P19LgqqvfynTOSNWkKFIIMhMkjJTY0zrR6kcb6vd3yc70TEpDoQXHfDCYonuvxc/bMMW6kyQiJFq0V7XjYHi6c73eHbMEGbag3EV5bJN9BHaJnyprF7t/nJ6fHvHTjGxy2XRfCBSNBtfbRyReGP6RTeauD9Udgsy3iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199015)(36756003)(86362001)(38100700002)(64756008)(76116006)(7416002)(5660300002)(186003)(2906002)(4001150100001)(122000001)(2616005)(6512007)(26005)(38070700005)(82960400001)(83380400001)(91956017)(6486002)(66476007)(66556008)(71200400001)(6506007)(4326008)(66446008)(41300700001)(54906003)(110136005)(8936002)(66946007)(8676002)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXpZQnprQ3FWUDVqbGFOb21Wdm1mTVg5UGtvY2RPaGJHaU9CcHNlOUdCV3FC?=
 =?utf-8?B?QkZ2NmRQUkxXamVuTW1WclpMZVQxd2orR09yclQ0cld0eEhybUtrMzlqSzl4?=
 =?utf-8?B?U0lBR0NzL1B0N1RhR1VMSEZIbVk4UUFTZ2xNTU95elNia2MxZElMdEs3Tm55?=
 =?utf-8?B?UUI0dzk3UHJLM2hoNFdhQmZwdkZYWHNnbjM4NERTaWw2N2hxaVhscFIwTlNz?=
 =?utf-8?B?ZVNkS1RETEFwK3c0MFhrSlROQlgwaU1oOXpieEhwRnJhWkRLdUllWFEyai9I?=
 =?utf-8?B?TXZiM1NpclN4djYrV2Q3Q0xhbXFpbUdNMmpiTjcrSzhWbHd1b2RWYjBMMi81?=
 =?utf-8?B?NjNZV3R6ZDAzTUFkQm9PM1FVS0ovNlo5Z3FFa2NTS2R5MUVmTUpNQVdWcVA4?=
 =?utf-8?B?b2tKN0xqVWlxbitxbE9WZnc1Q21BcTd3MmRZVEs0MnNpbFU0QmIvN0Q3dlBH?=
 =?utf-8?B?bjg0QksyQnhyN0tUa29ES0ZZYnVQYkRsWHRONEZHSU02YzZ2aDNaQ0lNVWhR?=
 =?utf-8?B?OTZ1MkhtcGVCSFp6bHVydEE4cVN0V2FGQWlIUVhMcm8xM3JYSWErR2dOR2ZK?=
 =?utf-8?B?bGRpekMyS0h6OGtOZGVBRDg0WE9SUWE3TWNUSDN3alhpc0g4YWRhMCsrcGND?=
 =?utf-8?B?bVZzeVJLUnEzVk5FRkpLVWRlVzNWbklNRXpNR1Rrc0MvdmZzZ0JzZmlMZGNP?=
 =?utf-8?B?YlBYMlFkRTJML3JHSFdEcmFKUk5nem0wT01GdjcxMTQ0dll5aE9ERmVjNnRj?=
 =?utf-8?B?TFJXZ0VLd1JsR2QzRkxMajBHQlpaYWZKSE10WjFnTHo4dWVMeDZLUUhzbm5p?=
 =?utf-8?B?Y1RYQUhSc2RFWGlnMXFLRTg0bGIvblVKamJuSVJGcENGTmhoREY2VnlXbTlj?=
 =?utf-8?B?Q2tQVGRYaXFKZmcwODR6eE51ZEZKajk0akxZMFptYUpYeGJXdmxTOXptUGpx?=
 =?utf-8?B?SWRsZTkyKzVwTXo1SUM5Q2RodEZkYnFadkpXTU95Q3hxQUlNU3lYVUFyR1Jx?=
 =?utf-8?B?cTk3SkNydnpibCt6d0lXTkZnQXZUVzVtM083NFErT2tKTEg1UEhtSVlOTXNL?=
 =?utf-8?B?T2M5RkVmQm1JNklFUE0rQ3Y5RUhaQXhxYVVxWGhxSDRsb1lKNnUveEdtaXVr?=
 =?utf-8?B?QjlpOHZLMFlSSEJ2L29tdzYvWVMzUlNGdDBLWUlIQXRjN1J1a0ladzZBQmdi?=
 =?utf-8?B?QmY2NDZJL2hHY2lTKzFaT2hDdDRmUE1ieVZCbHZPZ1ZQNUE4S29iV1czV2h2?=
 =?utf-8?B?VFl4dTdlcE9OTHlkVnpRM0cvRFVXczlOQmhxUWZpTGRFYzFTeldIbWkvWTMv?=
 =?utf-8?B?VTAvRVI0VENYNVNLS1hqd1lscnRLRUJjaitDWkd1WjBWU0hER1QvSjBNQktx?=
 =?utf-8?B?c1VEK1luVXA5RWxZcW1UNGZkWkwyUWdCM2ptbGxvMHFmY2o3bzAralQrQ0hm?=
 =?utf-8?B?eUtVc2w3cGE4QVF5YXIxT21BL2RHRVh2aG81cE9selExUEw3a0paTFYyQjI3?=
 =?utf-8?B?SE5qU0VMRDlzcVpMaE1UejI2b3Byc1lSOFM1YXEzL1FPRjZiS2FaM3FiYkFX?=
 =?utf-8?B?SVJxc1laL0UrRlBKbHdxenM4Q2R2NTZQY05BZ0h4c0xpQmM0RmU5dkdiclgw?=
 =?utf-8?B?M1dOMTlpV09mSHljL0NPNmo2OUNXWFo0N000ck80K2EwRUtTRWkxTjlPVkpX?=
 =?utf-8?B?aHlTalJ5dzl6QkZHMU1KN09hS0hZRnJ4YWh5UVByb3ZzOGYvYUp3cG1xQ1Br?=
 =?utf-8?B?K21abHBaWUozWDdyamdkUjVFME55UDZsU0tBQkxxaUVIMWV3RFFydUwwTkgw?=
 =?utf-8?B?d3RwTW1Yc2ZkRHlQL0lCWUo0NG5MdjJBTVU5TForWm9adHZjYUJuc0trVlo1?=
 =?utf-8?B?d3Jwb2V1ZW8vMk1lZDBiNTlRWndNTzNBenA4ZGdsekRoRmhkb0lpRlFscndB?=
 =?utf-8?B?M3AxZXRmTmdwaThRK2FoMHFFTm40SERGcndSL2t4bzdNbDB0bDdTeFo2TStO?=
 =?utf-8?B?NlhIc3cxUkE4WHhvTVVLQUViYzJWSWlFNVpnYzBTL1dKdkgvTHdvb1grd2hT?=
 =?utf-8?B?dXBnQ0VLd1BNL01mUFZYY2dmbG5qWVE0OEE2cm45eVN0OGpURmNKbGFkZ0dh?=
 =?utf-8?B?TDdaeDcrLzVMbmYveERpM2VrSzFXR0N1RTFRdUs2dFlDZ21ic1g4NUZtQmR5?=
 =?utf-8?B?dkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA39312F1B1D574C9DC401600B1EE782@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a557ff1-84a9-463a-23cf-08dacd36af9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 09:39:58.3959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JPT4HiAmXHxP3sDfKpK7hlhhCl+EJOx6u6tFr1TA6ZzOY4lj8ScfwiphzfVbh3YM5EhrQFmvvxsMbH3PyvP5+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4531
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDE5OjMxICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE5vdiAyMiwgMjAyMiwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4g
T24gVHVlLCBOb3YgMjIsIDIwMjIgYXQgMDQ6MDY6MjVQTSArMDEwMCwgVGhvbWFzIEdsZWl4bmVy
IHdyb3RlOg0KPiA+ID4gT24gVHVlLCBOb3YgMjIgMjAyMiBhdCAxMDoyMCwgUGV0ZXIgWmlqbHN0
cmEgd3JvdGU6DQo+ID4gPiANCj4gPiA+ID4gT24gTW9uLCBOb3YgMjEsIDIwMjIgYXQgMDE6MjY6
MjhQTSArMTMwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gPiBTaHV0dGlu
ZyBkb3duIHRoZSBURFggbW9kdWxlIHJlcXVpcmVzIGNhbGxpbmcgVERILlNZUy5MUC5TSFVURE9X
TiBvbiBhbGwNCj4gPiA+ID4gPiBCSU9TLWVuYWJsZWQgQ1BVcywgYW5kIHRoZSBTRU1BQ0FMTCBj
YW4gcnVuIGNvbmN1cnJlbnRseSBvbiBkaWZmZXJlbnQNCj4gPiA+ID4gPiBDUFVzLiAgSW1wbGVt
ZW50IGEgbWVjaGFuaXNtIHRvIHJ1biBTRUFNQ0FMTCBjb25jdXJyZW50bHkgb24gYWxsIG9ubGlu
ZQ0KPiA+ID4gPiA+IENQVXMgYW5kIHVzZSBpdCB0byBzaHV0IGRvd24gdGhlIG1vZHVsZS4gIExh
dGVyIGxvZ2ljYWwtY3B1IHNjb3BlIG1vZHVsZQ0KPiA+ID4gPiA+IGluaXRpYWxpemF0aW9uIHdp
bGwgdXNlIGl0IHRvby4NCj4gPiA+ID4gDQo+ID4gPiA+IFVoaCwgdGhvc2UgcmVxdWlyZW1lbnRz
IF4gYXJlIG5vdCBtZXQgYnkgdGhpczoNCj4gPiA+IA0KPiA+ID4gICBDYW4gcnVuIGNvbmN1cnJl
bnRseSAhPSBNdXN0IHJ1biBjb25jdXJyZW50bHkNCj4gPiA+ICANCj4gPiA+IFRoZSBkb2N1bWVu
dGF0aW9uIGNsZWFybHkgc2F5cyAiY2FuIHJ1biBjb25jdXJyZW50bHkiIGFzIHF1b3RlZCBhYm92
ZS4NCj4gPiANCj4gPiBUaGUgbmV4dCBzZW50ZW5zZSBzYXlzOiAiSW1wbGVtZW50IGEgbWVjaGFu
aXNtIHRvIHJ1biBTRUFNQ0FMTA0KPiA+IGNvbmN1cnJlbnRseSIgLS0gaXQgZG9lcyBub3QuDQo+
ID4gDQo+ID4gQW55d2F5LCBzaW5jZSB3ZSdyZSBhbGwgaW4gYWdyZWVtZW50IHRoZXJlIGlzIG5v
IHN1Y2ggcmVxdWlyZW1lbnQgYXQNCj4gPiBhbGwsIGEgc2NoZWR1bGVfb25fZWFjaF9jcHUoKSBt
aWdodCBiZSBtb3JlIGFwcHJvcHJpYXRlLCB0aGVyZSBpcyBubw0KPiA+IHJlYXNvbiB0byB1c2Ug
SVBJcyBhbmQgc3Bpbi13YWl0aW5nIGZvciBhbnkgb2YgdGhpcy4NCj4gDQo+IEJhY2tpbmcgdXAg
YSBiaXQsIHdoYXQncyB0aGUgcmVhc29uIGZvciBfYW55XyBvZiB0aGlzPyAgVGhlIGNoYW5nZWxv
ZyBzYXlzDQo+IA0KPiAgIEl0J3MgcG9pbnRsZXNzIHRvIGxlYXZlIHRoZSBURFggbW9kdWxlIGlu
IHNvbWUgbWlkZGxlIHN0YXRlLg0KPiANCj4gYnV0IElNTyBpdCdzIGp1c3QgYXMgcG9pbnRsZXNz
IHRvIGRvIGEgc2h1dGRvd24gdW5sZXNzIHRoZSBrZXJuZWwgYmVuZWZpdHMgaW4NCj4gc29tZSBt
ZWFuaW5nZnVsIHdheS4gIEFuZCBJSVVDLCBUREguU1lTLkxQLlNIVVRET1dOIGRvZXMgbm90aGlu
ZyBtb3JlIHRoYW4gY2hhbmdlDQo+IHRoZSBTRUFNIFZNQ1MuSE9TVF9SSVAgdG8gcG9pbnQgdG8g
YW4gZXJyb3IgdHJhbXBvbGluZS4gIEUuZy4gaXQncyBub3QgbGlrZSBkb2luZw0KPiBhIHNodXRk
b3duIGxldHMgdGhlIGtlcm5lbCByZWNsYWltIG1lbW9yeSB0aGF0IHdhcyBnaWZ0ZWQgdG8gdGhl
IFREWCBtb2R1bGUuDQoNClRoZSBtZXRhZGF0YSBtZW1vcnkgaGFzIGJlZW4gZnJlZWQgYmFjayB0
byB0aGUga2VybmVsIGluIGNhc2Ugb2YgZXJyb3IgYmVmb3JlDQpzaHV0dGluZyBkb3duIHRoZSBt
b2R1bGUuDQoNCj4gDQo+IEluIG90aGVyIHdvcmRzLCB0aGlzIGlzIGp1c3QgYSByZWFsbHkgZXhw
ZW5zaXZlIHdheSBvZiBjaGFuZ2luZyBhIGZ1bmN0aW9uIHBvaW50ZXIsDQo+IGFuZCB0aGUgb25s
eSB3YXkgaXQgd291bGQgZXZlciBiZW5lZml0IHRoZSBrZXJuZWwgaXMgaWYgdGhlcmUgaXMgYSBr
ZXJuZWwgYnVnIHRoYXQNCj4gbGVhZHMgdG8gdHJ5aW5nIHRvIHVzZSBURFggYWZ0ZXIgYSBmYXRh
bCBlcnJvci4gIEFuZCBldmVuIHRoZW4sIHRoZSBvbmx5IGRpZmZlcmVuY2UNCj4gc2VlbXMgdG8g
YmUgdGhhdCBzdWJzZXF1ZW50IGJvZ3VzIFNFQU1DQUxMcyB3b3VsZCBnZXQgYSBtb3JlIHVuaXF1
ZSBlcnJvciBtZXNzYWdlLg0KDQpUaGUgb25seSBpc3N1ZSBvZiBsZWF2aW5nIG1vZHVsZSBvcGVu
IGlzIGxpa2UgeW91IHNhaWQgYm9ndXMgU0VBTUNBTExzIGNhbiBzdGlsbA0KYmUgbWFkZS4gIFRo
ZXJlJ3MgYSBzbGlnaHQgcmlzayB0aGF0IHRob3NlIFNFQU1DQUxMcyBtYXkgYWN0dWFsbHkgYmUg
YWJsZSB0byBkbw0Kc29tZXRoaW5nIHRoYXQgbWF5IGNyYXNoIHRoZSBrZXJuZWwgKGkuZS4gaWYg
dGhlIG1vZHVsZSBpcyBzaHV0IGRvd24gZHVlIHRvDQpUREguU1lTLklOSVQuVERNUiBlcnJvciwg
dGhlbiBmdXJ0aGVyIGJvZ3VzIFRESC5TWVMuSU5JVC5URE1SIGNhbiBzdGlsbCBjb3JydXB0DQp0
aGUgbWV0YWRhdGEpLg0KDQpCdXQsIHRoaXMgYmVsb25ncyB0byAia2VybmVsIGJ1ZyIgb3IgImtl
cm5lbCBpcyB1bmRlciBhdHRhY2siIGNhdGVnb3J5LiAgTmVpdGhlcg0Kb2YgdGhlbSBzaG91bGQg
YmUgYSBjb25jZXJuIG9mIFREWDogaG9zdCBrZXJuZWwgaXMgb3V0IG9mIFRDQiwgYW5kIHByZXZl
bnRpbmcNCkRvUyBhdHRhY2sgaXMgbm90IHBhcnQgb2YgVERYIGFueXdheS4NCg0KQWxzbywgaW4g
Y2FzZSBvZiBrZXhlYygpLCB3ZSBjYW5ub3Qgc2h1dCBkb3duIHRoZSBtb2R1bGUgZWl0aGVyIChp
biB0aGlzDQppbXBsZW1lbnRhdGlvbiwgZHVlIHRvIENQVSBtYXkgbm90IGJlIGluIFZNWCBvcGVy
YXRpb24gd2hlbiBrZXhlYygpKS4NCg0KU28gSSBhZ3JlZSB3aXRoIHlvdSwgaXQncyBmaW5lIHRv
IG5vdCBzaHV0IGRvd24gdGhlIG1vZHVsZS4NCg0KSGkgbWFpbnRhaW5lcnMsIGRvZXMgdGhpcyBs
b29rIGdvb2QgdG8geW91Pw0K
