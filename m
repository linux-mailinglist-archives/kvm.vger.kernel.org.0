Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5CC736043
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 01:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjFSXvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 19:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjFSXve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 19:51:34 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EA0197;
        Mon, 19 Jun 2023 16:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687218693; x=1718754693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2z5jL5cc2aDVokVoIh5vgWjUCu4wWoGchubStIhJlRk=;
  b=BcNRMBpCNK3B4ls6zwaIPaDUTyloUBdq3DIOMAAtOaRgEcMORjsR5Zw1
   M4+mDDqVPRyPebgsj09nQ3MwZNs40NejzzGnlo5TnKn8gGFGBpfc+G1UA
   kNMxx03CbhGEfuPYtwBQEq1HLOpvgh5hHZAdy8a2iB5YiC9PY2vYjJPRp
   sJYRN3ah9M79sD6g7P97DwpDV/eILecl4Gksg9pnxwmpshO2b69jtSV32
   jr9cfCAmQmLLk9fQ67bEILONsezExGV+TtcKapgRSE2QELV2COsfoxu83
   K04scfJgSR49A9616p3qXk6HFFmkCJPezxsb7zoXpWQYOquBsey7UTcZv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="425683431"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="425683431"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 16:51:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="960565450"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="960565450"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jun 2023 16:51:08 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 16:51:07 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 16:51:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 16:51:07 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 16:51:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMGcF6GwmNpYGHUWf239XRzHUUJ3BRkTeA3ntRzU3CKJZLu3MKciSxBWCyXjznxG5rapvfvEfE11W9XlyZL591M3WTG43poMBDKIzRBJ+A0d3zaFGiyx0n3SuH9kGbzQvPJGqgMOiexKyj8fHhfRXNt6SydhAGpVC5qFHDmH1L/6aRRxukKE+L56MR2yvbH/2/mFw0onUIoUQahHQHHMgkA/5VNMgNKDrlWXi3tj532bd+C7m+vreGH0DhrJDgS4U5rcIAE4w57B9mq8EwwOp/iToICVmNqhMQL0d2cPkV4JuS50oJ9WBL5vBi23P5IqVNwcGu73raF/rqg46zsslw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2z5jL5cc2aDVokVoIh5vgWjUCu4wWoGchubStIhJlRk=;
 b=bW5oQsazcnCMfaExknHmeokTbjH/tfEgajiBvIV8sP7NP4FvfDdHnRbtuP7zCqoRVgDa0mlt29vKOlcozu181xrCMoRNaYQbgszsG4fzf/Hv+ABvZjNLcTGScnKNebW4oaEiUiT9y3kR8TNHt8K9T4T5rGx6pspwzpeyC30WZhiJr37aX70/LIxvyQnQq3QdRShZqZubGEFVvsHWmh95z5atFv9PkXYEjbyfhz56gWHRA5O1wE8DuCSY2g7/I4r7VNCKGyEIm0vOZKUANG97pAdt5FI1VrGrTK5xnNeIXVW2LDc302uF/XNGM2Jb7sC8x+FGhX9RDitJfx/3xeL7Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7301.namprd11.prod.outlook.com (2603:10b6:8:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 23:51:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 23:51:04 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZlu+wT+VnAmvfKka8EfWTldC51a+SNluAgACtk4A=
Date:   Mon, 19 Jun 2023 23:51:04 +0000
Message-ID: <7320df6f4a960c42f7f581a0b643585d0c6a939b.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
         <0d5d75ec-c7db-7546-80cb-e8755fc7cae0@redhat.com>
In-Reply-To: <0d5d75ec-c7db-7546-80cb-e8755fc7cae0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB7301:EE_
x-ms-office365-filtering-correlation-id: c96be033-76a6-4d13-2b66-08db71200b29
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oQf1vYawviRyTrN/jnq+DPr+RennoLBekh0j6JaBZs7MSGI63LK8V6y96ZyAIQIDpdAHjNe2riCvM/bRG7/UwAY9/uyW8OFZLIMFDRNQkNO98ulPAPZ6T0/Usm2ysKs2Afl8FkceAuGJZ/Hn9gyw+H6j186etBC9M6b8+Sbq/soKcXHuaLYh3OFoNAi22ib4/gfNCgmPnolzl73d5oPSp3dgQ8EJYZBO/bVIGWS+9h7Sh3aL6lXCQn3mzCE0ZWHtba8GEkc6j3VcrRYLNSGwdvcbCGQXr7ZZHHnXTN3cJD5a5HPdH9ktSC1A5+nO1HI58+ZvbMKMcYRET3fMCpDfmqswuRLMfVGTc/wEPOA605b8frOlRDxaf2HzcnJsljwlf9u4Xbr1i2CZrBEDzRfBjckpY4X8ArECk5FYYTKZgK29cjrLUjBfGREoyh6CzgO5jpA1qdZ39a5UPICvV7ijNW0/LYY7+KiDv+zx04H8YfNQRbitb8r/Lt0amt2DB515LMhekFoEDya4zOXnj7QgEFBB9lyDrtUKXDoVseL5bQVfGctBlUlPihWI9EtcyYLyiarvrZQV3hICn2tkeyrjcWziNEEYetu+eMwdFb/UboSIrQPuHMGb5HwFbwlJO+t5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199021)(186003)(110136005)(478600001)(71200400001)(6486002)(86362001)(6506007)(6512007)(54906003)(26005)(2616005)(316002)(82960400001)(38100700002)(76116006)(66946007)(66556008)(66446008)(64756008)(122000001)(91956017)(66476007)(4326008)(8676002)(8936002)(7416002)(5660300002)(2906002)(41300700001)(36756003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXNxcnNuZGtyTk5VYVpMdndQQ09JRlBSRnczYUdCZnM3cnBIdVFYYnNMZ1NH?=
 =?utf-8?B?SWZIWFN6YjJmd3ZKdklZbzVPQnJCNGIzWVc3djNEZFFzTERtTVU4eUJ2bzl3?=
 =?utf-8?B?WldjK3JHeWEwNUZqL2NwOUwvRzlxOHVOaVA2dVpVbkg2TXBERjUyVlU3RFdW?=
 =?utf-8?B?bWYxSGc5UGZLQWRma1ViVzF6cjY3WGlTbmE1a1hOeWxOSFcvMFRhci93dThW?=
 =?utf-8?B?NDdzejErMjd1OEZ5a3V0RjVjcmVGenJQYzRtYk5Qb2NKUTNIRlJ1cVYzdERp?=
 =?utf-8?B?TUd3TW14YWdYOXhHYWtwSzkwUk82NjdCT0pTNUVCaTU2ZU5MN2RUejJnd0Ni?=
 =?utf-8?B?K2doajFwK2FZeEN2ZWtUSm9ha3V6MjJzRVRCTFpUUlVVRmJrNkl5YS9mZFdX?=
 =?utf-8?B?Z2doRW5mSk9XUXlKUXIzZzJWcFJLVHpyNUpCTGQ2ZXZSbGdid1VqM1BUd1BS?=
 =?utf-8?B?VytqSmhNb2lpcFc1YUltbDAxSE93WUdmRVBWL1I0VmRtTERJenY1QmI0SWpU?=
 =?utf-8?B?R0NsZEtRdTRUS1lEb0hVdFl6SVl1SVdRTmhCaExGb2JMcXI5ZVhvUTVCWkVH?=
 =?utf-8?B?dzVyZWlrWUlqdFNEeGdtWXFzZDBoZjQ4allwUStNUDlmWGFScFBqNHlYbm9a?=
 =?utf-8?B?Y3BOcjZXTlVWK0p4K2YyaTRIbWY1cjllVk1vTksyZ1dRNHFMRUU0MW4rRFBM?=
 =?utf-8?B?SVdEZGZkc0dpS0lTeHJqa0QwWE8wVHNKY0hZVndNeHhydHFjeDFZYlNZZ1Ev?=
 =?utf-8?B?Q2JvQ0d4emdlNlJ0blpvUitsMkVyZisyazNqaVJYcllCbUczVWhvTEVXY0hj?=
 =?utf-8?B?OHFGdW1iMzdSamFBUFl5UmYxOGlUQzF1MTZhUWpaaDdSYzZYZkNPaFJiZ3o1?=
 =?utf-8?B?UFEwVWhrYkZPZmxUdFd1Yzk3ODdJUXJqVHhRczlUK0VhZzk5TEpKeTQ3VTFZ?=
 =?utf-8?B?Z0g5S0NybHcwUXozcjVNdjI2aUd1SFk1YXI5WWd5OGgySkF4dGNhL0dwN0do?=
 =?utf-8?B?NHVBUFRlUzBCQmYyL0ttRVp0ckpudWxvZngrV3l5T1ZBcFRpbWt3UVBaeUdt?=
 =?utf-8?B?Z21hNkVpdStMSUFJTnd4bVJwcFI1WGVScm02SHBsRFpjd0FISmNaOXlNK0FE?=
 =?utf-8?B?c2tGZ2dlbEpGYWJXc3lpQ2J5VXlMUHZna0hTam5sZS8rSG5NTVlGYm1VT1I3?=
 =?utf-8?B?M1Roa0ZJNVJMc3hHNDRuUG83Ui9WZEhlMmFMMGxsVUhUOThYN0lDQ2wxWFZn?=
 =?utf-8?B?Q25udXRWVDI5a2JsU0JvTU10d2xRUEJrKzNlNkg5WGkweTY5UlpyWTV0K0ls?=
 =?utf-8?B?eUYvWUMxSjM3QjF5cFQ2dFRQTVdXWWxSRDZORjZVb05sZ1dYdkhnR0ZPZnBV?=
 =?utf-8?B?NzE4YmlFemt4dlNiam93czBUZ3QzWU55aFdBSWhNUXR5MUlJNmpJSHBUNW9B?=
 =?utf-8?B?VXR5OGV5cndiMWxoUkxSWXl4cFFWZlYrYXY5bmlmRXBteC90V0RXdW5CU3lW?=
 =?utf-8?B?TkN2V1NUZ01DUVlvUzIvcnkvdXBkbndReFhFRldBNVYzMm1yanMyNjZnakJI?=
 =?utf-8?B?YVU4Vnp6TWtZWE16R3hCL2RVbHlCRmFKOHRPM2NDRXdaUHBUd3JhMXhhdGZl?=
 =?utf-8?B?R21majdiYm51bXZ0QU9MbktKNnd6UHI5WTZ2L2FNWTdXYXJyenArRXhCTW1o?=
 =?utf-8?B?NUMzTUhhZTFwZ1g2bk83bkVDVWFSa1NBaVFTNDl4U25SVDMvTlkvQzRXSUF3?=
 =?utf-8?B?QmtaVC9rS0txVlhaT0pIeHFldDA1VDlReGtYcXZKY2VCalkvOHBTMC9SdFp0?=
 =?utf-8?B?WlpHbG9MSEp0cFZrOWMra2NlYm81Z2k1VDltWWI3VHQwVWJjUWVwd3BUZFFM?=
 =?utf-8?B?K2pTMGkwMlhkSTNVMUVBSWd2RUYzZmUzQnRLS3VmRTU1Z1dFeEx5YnN2QWZX?=
 =?utf-8?B?MUkyYVNNbU5sV2pOanhYV2FkT2xORlVkMXFYUE1uYnBKcEJtc3Rrb3VDNWt6?=
 =?utf-8?B?ZVYwSkgyTHRmUGFEcmRpWWZyWEx0T0Jtd1QvU2k2N21xdEREL00vWlY0TktZ?=
 =?utf-8?B?TmE2YldMQnQ0Y3pIaGJLRjVQeFVaTHZJd0E5MGN0U1NKM1RTZjB0SzF3eWp0?=
 =?utf-8?Q?xngjyL+4ryuz1pwAOkBxaGF/r?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80AD4B29F8610640AC8287E782FD2BE0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c96be033-76a6-4d13-2b66-08db71200b29
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 23:51:04.2914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aSyyonkjuND1kP1ywnsNlLDJNj1MhsHVVji5mFYF8SoNr396d1ubYFphq/ztWTCm8xEi3ONmGc5KH9wNrT7ZPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7301
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

DQo+ID4gK3N0YXRpYyBpbmxpbmUgYm9vbCBpc19jbXJfZW1wdHkoc3RydWN0IGNtcl9pbmZvICpj
bXIpDQo+ID4gK3sNCj4gPiArCXJldHVybiAhY21yLT5zaXplOw0KPiA+ICt9DQo+ID4gKw0KPiAN
Cj4gTml0OiBtYXliZSBpdCdzIGp1c3QgbWUsIGJ1dCB0aGlzIGZ1bmN0aW9uIHNlZW1zIHVubmVj
ZXNzYXJ5Lg0KPiANCj4gSWYgIiFjbXItPnNpemUiIGlzIG5vdCBleHByZXNzaXZlLCB0aGVuIEkg
ZG9uJ3Qga25vdyB3aHkgImlzX2Ntcl9lbXB0eSIgDQo+IHNob3VsZCBiZS4gSnVzdCBpbmxpbmUg
dGhhdCBpbnRvIHRoZSBzaW5nbGUgdXNlci4NCj4gDQo+IC4uIGFmdGVyIGFsbCB0aGUgc2luZ2xl
IGNhbGxlciBhbHNvIHVzZXMvcHJpbnRzIGNtci0+c2l6ZSAuLi4NCg0KQWdyZWVkLiAgSSdsbCBy
ZW1vdmUgdGhpcyBmdW5jdGlvbi4gIFRoYW5rcyENCg0KPiANCj4gPiArc3RhdGljIHZvaWQgcHJp
bnRfY21ycyhzdHJ1Y3QgY21yX2luZm8gKmNtcl9hcnJheSwgaW50IG5yX2NtcnMpDQo+ID4gK3sN
Cj4gPiArCWludCBpOw0KPiA+ICsNCj4gPiArCWZvciAoaSA9IDA7IGkgPCBucl9jbXJzOyBpKysp
IHsNCj4gPiArCQlzdHJ1Y3QgY21yX2luZm8gKmNtciA9ICZjbXJfYXJyYXlbaV07DQo+ID4gKw0K
PiA+ICsJCS8qDQo+ID4gKwkJICogVGhlIGFycmF5IG9mIENNUnMgcmVwb3J0ZWQgdmlhIFRESC5T
WVMuSU5GTyBjYW4NCj4gPiArCQkgKiBjb250YWluIHRhaWwgZW1wdHkgQ01Scy4gIERvbid0IHBy
aW50IHRoZW0uDQo+ID4gKwkJICovDQo+ID4gKwkJaWYgKGlzX2Ntcl9lbXB0eShjbXIpKQ0KPiA+
ICsJCQlicmVhazsNCj4gPiArDQo+ID4gKwkJcHJfaW5mbygiQ01SOiBbMHglbGx4LCAweCVsbHgp
XG4iLCBjbXItPmJhc2UsDQo+ID4gKwkJCQljbXItPmJhc2UgKyBjbXItPnNpemUpOw0KPiA+ICsJ
fQ0KPiA+ICt9DQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBHZXQgdGhlIFREWCBtb2R1bGUgaW5m
b3JtYXRpb24gKFREU1lTSU5GT19TVFJVQ1QpIGFuZCB0aGUgYXJyYXkgb2YNCj4gPiArICogQ01S
cywgYW5kIHNhdmUgdGhlbSB0byBAc3lzaW5mbyBhbmQgQGNtcl9hcnJheS4gIEBzeXNpbmZvIG11
c3QgaGF2ZQ0KPiA+ICsgKiBiZWVuIHBhZGRlZCB0byBoYXZlIGVub3VnaCByb29tIHRvIHNhdmUg
dGhlIFREU1lTSU5GT19TVFJVQ1QuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IHRkeF9nZXRf
c3lzaW5mbyhzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCAqc3lzaW5mbywNCj4gPiArCQkJICAgc3Ry
dWN0IGNtcl9pbmZvICpjbXJfYXJyYXkpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhfbW9kdWxl
X291dHB1dCBvdXQ7DQo+ID4gKwl1NjQgc3lzaW5mb19wYSwgY21yX2FycmF5X3BhOw0KPiA+ICsJ
aW50IHJldDsNCj4gPiArDQo+ID4gKwlzeXNpbmZvX3BhID0gX19wYShzeXNpbmZvKTsNCj4gPiAr
CWNtcl9hcnJheV9wYSA9IF9fcGEoY21yX2FycmF5KTsNCj4gPiArCXJldCA9IHNlYW1jYWxsKFRE
SF9TWVNfSU5GTywgc3lzaW5mb19wYSwgVERTWVNJTkZPX1NUUlVDVF9TSVpFLA0KPiA+ICsJCQlj
bXJfYXJyYXlfcGEsIE1BWF9DTVJTLCBOVUxMLCAmb3V0KTsNCj4gPiArCWlmIChyZXQpDQo+ID4g
KwkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKwlwcl9pbmZvKCJURFggbW9kdWxlOiBhdHJpYnV0
ZXMgMHgleCwgdmVuZG9yX2lkIDB4JXgsIG1ham9yX3ZlcnNpb24gJXUsIG1pbm9yX3ZlcnNpb24g
JXUsIGJ1aWxkX2RhdGUgJXUsIGJ1aWxkX251bSAldSIsDQo+IA0KPiANCj4gImF0dHJpYnV0ZXMi
ID8NCg0KQXBwcmVjaWF0ZSEgOikNCg0KWy4uLl0NCg0KDQo+ID4gKyNkZWZpbmUgVERTWVNJTkZP
X1NUUlVDVF9TSVpFCQkxMDI0DQo+IA0KPiBTbywgaXQgY2FuIG5ldmVyIGJlIGxhcmdlciB0aGFu
IDEwMjQgYnl0ZXM/IE5vdCBldmVuIHdpdGggbWFueSBjcHVpZCANCj4gY29uZmlncz8NCg0KQ29y
cmVjdC4gIFRoZSBURFggbW9kdWxlIHNwZWMocykgc2F5czogDQoNCglURFNZU0lORk9fU1RSVUNU
4oCZcyBzaXplIGlzIDEwMjRCLg0KDQpXaGljaCBpcyBhbiBhcmNoaXRlY3R1cmFsIHNlbnRlbmNl
IHRvIG1lLg0KDQpXZSAoSW50ZWwpIGFscmVhZHkgcHVibGlzaGVkIFREWCBJTywgYW5kIFREU1lT
SU5GT19TVFJVQ1QgaXMgMTAyNEIgZm9yIGFsbCBURFgNCm1vZHVsZSB2ZXJzaW9ucy4NCj4gDQo=
