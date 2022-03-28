Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EC54E8FEE
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 10:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbiC1IRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 04:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239243AbiC1IRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 04:17:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C80435253;
        Mon, 28 Mar 2022 01:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648455368; x=1679991368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Clu6oQeSfzaoIx59KbaBMK0bnfXFtLbXj9zehfvYQs=;
  b=WTZsCwpdZKqRIT+KAVHD1BNGfG2nAl4+iOScvyIQPw/kFHUDFIXz/Gev
   hy4Ng1CaJEXRfoj4jOj5z9pT7zHcRHkWq0EQ4g5XNA1C2BZz+CtZWK2ts
   xJZ28SatZWQlW8V5RTM7YSEqJQjcA4IZF1rftvRaHXK0OoKyUB0uOEvZk
   zYb5lDxVfqMYULdw6/qzkcLMNUBXVlSG+BiAv5vy/gKY/j8A1dRZ+X2GG
   gzXFYamETKR/W8QJib4nRbJs2mTE5fT9DIDt6qOG/YX+tF5zNBvaB07pM
   brDZ87dvJpdYuH3BIVaFYvFpHvjWIWPGccdSwTGsIvBH8f3mdk/iHeOQE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="322128998"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="322128998"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 01:16:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="719018025"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 28 Mar 2022 01:16:07 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 01:16:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 01:16:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 28 Mar 2022 01:16:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 28 Mar 2022 01:16:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gkte27aIAATQmRwyRJFOesNzSEq3TEP2kiY9S0BO5diRN4ynRhl1petvV5mPd/drpML2TxTDAUXuwzwk/h3fxtG24mTQ8TdoqBHs8wHnCfdCfvstv+4NGavlwvk1gyzup8t8cLK1+bu/fQUWjmBMWorEeU3Osi5ITAx7TtWrwYGE6yAbsd8cG4hWP+3KSuyGwLtlahiJt3nadfKX7Zs8Jkm0bu4bYAD7BZg405z/xW5f9LFjD+UyRR0ytH9jaskYerRNIqzGVVGdFrewyT23DNE2aRJkS0Z+GyjOWluVDcKwJhbPsgQz3y6PO/6zk0G1Em+tmW6iHnaXbqwjdA+JSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Clu6oQeSfzaoIx59KbaBMK0bnfXFtLbXj9zehfvYQs=;
 b=LQsZ78sMzQm7MtHM3xraHPxwRs9CjxT7BKiXEMr5RkxvinN2PnxpaIndy2dIWeV0teP6Np6YqXS6OJDXifEF8nrsR/k2NRjuccqCngvdRL1ca1UtxE9DXcT8nIv1oFMN8czgyZAprj8XUqX2xL3QbGMDoe1fNoVEhsJhE60SEijjgRO8h5d1KZIxn1JcBRpx/sQjOMBEpBQJm0fufalbX9aau/+VvV+Lr3x/lz+qUoGZD6l+HOHZp5K6jMQKdEIv/sTK2SfB0J++tHgUTWmDNpEE2OwPjEw+v2yqsgM9/HcRsyVgusdpRLJ5g+BjbB1khpAu9S2kLmpjKWAOB3niZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB2055.namprd11.prod.outlook.com (2603:10b6:903:23::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 08:16:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 08:16:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: RE: [PATCH v2 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
Thread-Topic: [PATCH v2 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
Thread-Index: AQHYNsg4xFkq5zuN7EW7F8EKAI7kNKzMXTdAgAe/HwCAAGzJcA==
Date:   Mon, 28 Mar 2022 08:16:03 +0000
Message-ID: <BN9PR11MB5276D7C515C1F28300B0B3018C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <269a053607357eedd9a1e8ddf0e7240ae0c3985c.1647167475.git.kai.huang@intel.com>
         <BN9PR11MB5276B5986582F9AD11D993618C189@BN9PR11MB5276.namprd11.prod.outlook.com>
 <926af8966a2233574ee0e679d9fc3c8209477156.camel@intel.com>
In-Reply-To: <926af8966a2233574ee0e679d9fc3c8209477156.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dca27bd4-8240-483c-6f14-08da109333a2
x-ms-traffictypediagnostic: CY4PR11MB2055:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <CY4PR11MB2055225C7E8009FA22E064638C1D9@CY4PR11MB2055.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vj27egiUzATzAxjug8H1EHJj12rsWS7SpXgcRUWCi/y+cbRogPB3QJgbRpsJjjB0KvjVxGdwl9omJfNtnvYlgoygqscFpffVgcHrt7C+A2opgoK3z4CHFNZRdB4eAhijsPJp/XkMqRVxZTNXnQMjMRSPR+Uys5CzKfJYUDM7o2Fjp9Fm1CQmQT2dejKTZYziZ1jqY9mLRD/WsDh/FN0Y8iZCfoiCyFzsN18R2gTHDo20B98Z/Og2GoU/uY23T8jyUjq1AqT3BiSs0B6ntCDCOpu+AzBCahuecV4U3FZHJX8+psKWG3pYd9+7PwgAVMF3xjsDt7tBgOLLJ7pt14paluzLICQeZlP/hPH25tTcQUB+T9s+tW1kNre5KZMrzLiHyhALKAefVQcsCmsA+wZ0cEoQMjIuNCugsz6NhXHVpMElqqaKPbHq3R1ntGk/m6Bh9FM9PP5eF5VNavDGP8Sl/MtUcdlNKsLzF2HP1CIU8N93XmEaEInYQGX48qmYMlunVjqnPuQoFjKHJISZi1rJgU9E0EiQlvzZ6YCeAKUitGK8un4zgMWweuJdvHL84XmpvIHJ0vG26AWI33vsl4kla1J35dwpbDkeBPQ2bq5F7i9u/i8RJ905Oj1ofuP4JRrjlDg9jy5GxU02oHzycyDgSdw5FiX4+sYs5aXrxp02RqRV31gyspZuis4v+QdNyhtaT+IFpFmCmVGD2ZItSbL3HQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(54906003)(110136005)(8676002)(2906002)(508600001)(33656002)(4326008)(52536014)(8936002)(4744005)(186003)(83380400001)(26005)(5660300002)(38070700005)(82960400001)(38100700002)(76116006)(316002)(9686003)(6506007)(7696005)(66446008)(66476007)(64756008)(66556008)(66946007)(122000001)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkRGZjZjQkc2TWgxejQydFFvUXZNdncrWmFkdk9Db2o2MjNsYVR3QlpQZ2tG?=
 =?utf-8?B?MzFoSzBXSjdzYTdmTXBXQ2drbzQ1ajZKa3BxZ1hGSFZBQXczYSsrMnFRbmU3?=
 =?utf-8?B?VWc5MW5UR3ozVGFsSTBmazZodjR5SXE2VDloNEFJMXJTQ2NOdU1sbG1JaGd0?=
 =?utf-8?B?S3VPVWN0eklLU2c0TjltNjFKYTltTWZaemwzRHJWcmJIYk1QNk1VWFFUdGUz?=
 =?utf-8?B?bHV6eHdESlRyaGs3VlNsZnRocldIK01mZ1JXQkZNc1J2N0FwRGJDNW9FQ3g4?=
 =?utf-8?B?cmJUblVVaEE5R0pFOEdPaHJ3NXVsUENyeGZ4Z1NHeU9hUVZwenZLQ25QY3Fj?=
 =?utf-8?B?c0l5eVlFOFhPQUE5QVNZc3hjQWFlelduYS9zeUpCQ2Jtb245S0dGTGhzM1gy?=
 =?utf-8?B?c2lua3BydFBZVkZRMWhJb1BXNmduN3RMaG16ZFdTSFBrWFlsb1hEbzBNTnNt?=
 =?utf-8?B?Zld2bU1LdUxxVEFxMnRFZGswSzhXZUhuckNFSUFIV25lUndDSGFFL2RtSHN1?=
 =?utf-8?B?amhQL2Jpb1JUbFVDMGpkUlpyVzJPTEo2V0tGeHVoQkVrMUk2MmFjUThhTlE3?=
 =?utf-8?B?Q0U2Qzh1Q1pFZ2xZVmk2MVRoc2Fta29sMFlKNlF4RWphZmkrRlFFL21kR3Ux?=
 =?utf-8?B?UytOa0N3K05hYXJ2cnB5TW1HaW5xVEIzRlVndXZBamMvUzlDVjBzUWk4ODF3?=
 =?utf-8?B?Q05jellZR1U1WUhkWVpTVFA3NmlwVWcxV3Z5VTEwYVZuWHdnVmNhSVhzMGFO?=
 =?utf-8?B?ekl6UUZtTmUrTjladmU2SXJxNGJGTjN2b0plZWFNdlMzWGV0a29KQlRsSkg3?=
 =?utf-8?B?V0UzeDBRWk9oVXNublYrWGZuUllRc2YyTFEyck9rTWhKV05RVk40U1BVMFhj?=
 =?utf-8?B?RXUwNEZEMDZBenN5SVF6K0VORUJlUU5qdFBsTWlPSEM0NmdDWkxxVFlVZ1Vn?=
 =?utf-8?B?bVhKZncxMGxMSzJkL1BjTU1yRzVPSG9SYW9jamt5YzJ4YWN5ejNnc0dIQ2ZH?=
 =?utf-8?B?NzlSMGhPeE52czV0eFo1c0dMK2FoVU9MM0ZwaVl2WkZTQlNmWmp5WEhxZHor?=
 =?utf-8?B?ZHBtbjNhZjBXNVZhK28wWUh1QjZ4aGxMWEtRYnljbC9JNTNhWGNocDRQUVU2?=
 =?utf-8?B?SXRnM1ZXS3NLdFd4SUo2ZGVwZDNPalVJbXZMS3Z1RWd5T3ZvZHVUdDhOaElr?=
 =?utf-8?B?SVFzNmtNcWFUZkFhNUtHWUd4dGw0b2RHc2lWUHY0YWRJTFFLR1pYY0hnTk9q?=
 =?utf-8?B?bXl4UzZCSThwZnRQQUNPYjlCZldGS2krejR3aUR1by9ydkI0M1pIU3ZPUzFN?=
 =?utf-8?B?KzlEYlMrVmVRT2RpdFdhSHNKMU1xN0V2SWF0VUk1RjU4b2FXQ3l4eEVnbWdH?=
 =?utf-8?B?RHpXNVdJWFNNZGFLYytqU01MSWNCWUUvRjRGeXUrWFJXcnQ3VzFKMm5Gbjd1?=
 =?utf-8?B?S1V5WGNhNVByRlJsLzB0S214L1N2TFc4Yi9rSE1nYk1nL24rMG5OV0ZYVGRK?=
 =?utf-8?B?Zm9icG1WL2p5KzJrSFphZ3BDMFFmcnRES3NmZ040WDd0SC9ZaS9MajNhQUlt?=
 =?utf-8?B?bEM4ZUpKbzZhdXBtZkNsZkZ3TC9XaU9mUTRLbXdzVW5VR1BJcTZXNmdnRDBw?=
 =?utf-8?B?R3lMaTFkeU5HLzZaK1ZqS1E1NElycnpKVjdwOVJFbGx5OWJ4d1hxZGFhTkpz?=
 =?utf-8?B?amtlWklManZja2FwYzIwV3FCWCtOdTRDNWlLNTdUbXVUOCtMTFVrMzVBam9v?=
 =?utf-8?B?K2xCTnk2L1RnWGFsTFBwaEtjbjUyWlhod3pndlpXNGlQZ1BxZDlraDNjbURL?=
 =?utf-8?B?Z3JHK1dPVFZWUVE2UGxuWll3V0NYdXdONll4WEgvd3dmRktTNzJ3RnRGS3lo?=
 =?utf-8?B?c0pDczcxbGhzanV5c1BXSUxoNWgyTjBQakJJWVJEcDI4QW9SRXdCbHVxbWc4?=
 =?utf-8?B?SThNcnFkMGdML011cTFpdzNHd2pRdE5GcDJDc3RpWStZUGo1dTRqL0RkQi9Y?=
 =?utf-8?B?ajluK28zTS9BelhOb0huK1M3WG5iWWtYczlGcVRsMkFXMG9kM1FTUHFMQ09l?=
 =?utf-8?B?ak1SeUtMWXJwYUU2djR4blNHTFRFK2oyZ1FTckdXK0FYcUh2c3dWdU9KK2xi?=
 =?utf-8?B?ZkpaWjVjdk5OOWtxcmpXQTNranJIL0hFZ3dlYWwzY2w2QUJFdEtManRvaU9y?=
 =?utf-8?B?MExaVDZsR2l1VTZZTUFlM09wb1pDNWg2TytTSGJBRmc0OGhyZEk4bXhRamVw?=
 =?utf-8?B?ZzJjWE9TZUdTWXNuVkM3R0R6WC94UWFUMHV5bCsvSlRHYmJnaXpGL2IvdFR4?=
 =?utf-8?B?enpGUSthQTZuSE9pd3h4bTM5bjN5RFh4ZXRLNEdKSUtqeGZYaUQxUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca27bd4-8240-483c-6f14-08da109333a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 08:16:03.7149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LEuu0pKjh184jtp9MMYry9y72Cu0B/fQeWFF3RqwViXg3+Ye6kXE/WE4GXDxJ8IBiAffzrP3RyNbsW62ggQ5pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB2055
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTZW50OiBNb25kYXks
IE1hcmNoIDI4LCAyMDIyIDk6NDIgQU0NCj4gDQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4gQSBDUFUt
YXR0ZXN0ZWQgc29mdHdhcmUgbW9kdWxlIChjYWxsZWQgdGhlICdURFggbW9kdWxlJykgcnVucyBp
biBTRUFNDQo+ID4gPiBWTVggcm9vdCB0byBtYW5hZ2UgdGhlIGNyeXB0byBwcm90ZWN0ZWQgVk1z
IHJ1bm5pbmcgaW4gU0VBTSBWTVgNCj4gbm9uLQ0KPiA+ID4gcm9vdC4NCj4gPiA+IFNFQU0gVk1Y
IHJvb3QgaXMgYWxzbyB1c2VkIHRvIGhvc3QgYW5vdGhlciBDUFUtYXR0ZXN0ZWQgc29mdHdhcmUN
Cj4gbW9kdWxlDQo+ID4gPiAoY2FsbGVkIHRoZSAnUC1TRUFNTERSJykgdG8gbG9hZCBhbmQgdXBk
YXRlIHRoZSBURFggbW9kdWxlLg0KPiA+ID4NCj4gPiA+IEhvc3Qga2VybmVsIHRyYW5zaXRzIHRv
IGVpdGhlciB0aGUgUC1TRUFNTERSIG9yIHRoZSBURFggbW9kdWxlIHZpYSB0aGUNCj4gPiA+IG5l
dyBTRUFNQ0FMTCBpbnN0cnVjdGlvbi4gIFNFQU1DQUxMcyBhcmUgaG9zdC1zaWRlIGludGVyZmFj
ZSBmdW5jdGlvbnMNCj4gPiA+IGRlZmluZWQgYnkgdGhlIFAtU0VBTUxEUiBhbmQgdGhlIFREWCBt
b2R1bGUgYXJvdW5kIHRoZSBuZXcNCj4gU0VBTUNBTEwNCj4gPiA+IGluc3RydWN0aW9uLiAgVGhl
eSBhcmUgc2ltaWxhciB0byBhIGh5cGVyY2FsbCwgZXhjZXB0IHRoZXkgYXJlIG1hZGUgYnkNCj4g
Pg0KPiA+ICJTRUFNQ0FMTHMgYXJlIC4uLiBmdW5jdGlvbnMgLi4uIGFyb3VuZCB0aGUgbmV3IFNF
QU1DQUxMIGluc3RydWN0aW9uIg0KPiA+DQo+ID4gVGhpcyBpcyBjb25mdXNpbmcuIFByb2JhYmx5
IGp1c3Q6DQo+IA0KPiBNYXkgSSBhc2sgd2h5IGlzIGl0IGNvbmZ1c2luZz8NCg0KU0VBTUNBTEwg
aXMgYW4gaW5zdHJ1Y3Rpb24uIE9uZSBvZiBpdHMgYXJndW1lbnRzIGNhcnJpZXMgdGhlIGZ1bmN0
aW9uDQpudW1iZXIuDQoNCg==
