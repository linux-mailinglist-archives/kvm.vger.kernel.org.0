Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33BC6A61E5
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 22:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjB1V6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 16:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjB1V56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 16:57:58 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBE25B8C;
        Tue, 28 Feb 2023 13:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677621476; x=1709157476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=l+ISwAc0zw3rX63rBxDZwq3AmdmpySuprGh3k1jP5W4=;
  b=nZdjzGjU+L1C2kF9CkgCtPLHQQ3QEkjeoBg8uABZFhGJHeCi2R7KWbCB
   byQF01eIWW+sMdAzl9gEwbZ/ACwoGHnnClS1JQ8m4jGT0SOCVs3M7lTwi
   JzAlCVtapBQmhUhZ+6LKSq0MWkQlOmlRQvbIWqp+n6mEiER9+QBkmo37Q
   FwjqWVWe3MeQLjEOT7YPGeB9/wnMqBMJhx0BJIK/EVIDWIQzTYb1swdrw
   B0SGdCW+Svl3+ncZAbtS23HVJ2hT7QZ11AvurmujcQO8O7/Yo0NvnXcm0
   cnQJyRk0wkSZsSKRMc67NldjUvEgqORuHTrRF6lcmZL0yR3Nl9OhqeeJw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="334296878"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="334296878"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 13:57:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="624218327"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="624218327"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 28 Feb 2023 13:57:55 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 13:57:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 13:57:54 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 13:57:54 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 13:57:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnBmpGQ+vjwkE+9rio+OgVNV6KSA9UGUh1oIBbHY+TTSb730xcsL+Y3wnsrUQCYBFCKoK/2VAKV/LDRSfhYnbmzVkVm5LFc6i2Wt9zK1U9ESrtlsafHS4q6TGD+QMW7RTxNrPEZ0kxQdYKEhYkR7eM75Wd6utA0D4+GP4XjCEaYG9EO7eJJ8FJNAXsNFPefWQ00+mnrHnav+qYO5csTTmTuztMiFUM3sfV4h17EcGsxEzX/cHG+hcQqvU3Zc7NzHKr7jB0Vz4iJkQKovVwjFI8NZ02844piebwknkGHsqZGRWJxbzmrphL1QcGm+UW4p/28REblZg+pY8pffCK6AMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+ISwAc0zw3rX63rBxDZwq3AmdmpySuprGh3k1jP5W4=;
 b=Iy2abtYC9xEdBeF56Pu69ZIqMEmhKJau/UpWE9dMbj40pvmNGBCI2rfm4YpmikUo44qZ83upqhPmhesHUSMK0tgj9rcjz07ZVDV+L7XvlQJRO1zBJctEOYkOlwQzoOOc4p7/7z/EoPdbPdDHc7mzisc04nbQE/5w3xXwCnDFYOefUrmCiNy9gC5RCvefkuXOBXhzErbPhvsny60CtXmFTf96QTjjcprCRJayohCNFzdC56JRDSKLI3/uY6h3NJfamLrQB5U4mSssjZl2KLHgUgnbnAzJiY/Yxjp/fUjk2K73U2Eb94bQ8mllXUvTyornKn6lG6LZkjuXv/4rk9HyMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5924.namprd11.prod.outlook.com (2603:10b6:806:23b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Tue, 28 Feb
 2023 21:57:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 21:57:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Thread-Topic: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Thread-Index: AQHZJqToZY0zv6U9WUWWlCjhFfl4aa6gfRqAgEMZzoCAAZsyAA==
Date:   Tue, 28 Feb 2023 21:57:50 +0000
Message-ID: <bdf8b2e1aa52ae8f4d5e2a6c92e0f8e426b97234.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
         <5f9870acec07c47de5bab460c8c0d4a2c0db08fc.camel@intel.com>
         <20230227212605.GF4175971@ls.amr.corp.intel.com>
In-Reply-To: <20230227212605.GF4175971@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB5924:EE_
x-ms-office365-filtering-correlation-id: 120ab104-83e3-4d59-8106-08db19d6d5ae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BY8TNzKWROOx4v0UFtuop5wr+CSfEBBPSVIRIbLTwXngFcdJQsJ+U7/a9rM2ETLI2vEtifZuEVyOuYeEiMJxBv/+FVnIw9i0cLOnG0QW0uCfZvYlEixsnABLoKyPSUKsxqqsb/lGCV8sZjTEjkGcSV9+Gy3dhxLGXuurgiqg4FEs+lQuLaTcw7BOn9w3p/XUwsFrHNgXxSR8fFft5o/EN08/HwtlcQNEkBdEomQHSjx+MMHCzwuw5ke5yRBGb96/s4NwP62HEpr/wYHnWfIe9IStl6JhQPgj68OVFcSZg9dKPrC1yYzybtuwSSlha3obFxUU3AvCnPe2471j8RbbUmbQancd68HDD6shx2gAgxjBMa/KneSf3Mgeh2xcjgPYCj39pag2uguhxnDxKdTvtbFpVj24FkAhlNsLFaFob3RpHhFOGGj7qzP+NJzZYG+rX0qnqQvr3o+HhkKp0MwxcIQ7lNcwkM9wtIRn6r+yrMPo4GvoAMlFRd1a0z1GqrXjFSH+rue7ceLQHsZYU2yQTeRrySpbK4iE2biLPpbrPRAA1FnKGofWBsHJHlLtmSxluNoPKlSN9GuMaIkEd+vVJxQUkKVlZ+4tjKJFDKgfW/oa0OGT9/BxTQwSFQRtI+y4aErvBtbHBvYH7NcD6hyf85wGrvQiG0T/QN0mcTaPxrDqMqS/xQBVaZ3FO918XZQGFMioqTO0vvZRCfkgkYRl/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(346002)(376002)(396003)(451199018)(478600001)(6486002)(2616005)(71200400001)(54906003)(6506007)(186003)(26005)(316002)(6512007)(66446008)(6916009)(76116006)(8676002)(64756008)(66946007)(66556008)(66476007)(4326008)(41300700001)(91956017)(4744005)(8936002)(5660300002)(122000001)(38100700002)(82960400001)(36756003)(38070700005)(86362001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW5ZRW5HQlBJNFFKalY3MG1Qd1lWV2NoQ3NGdGgxK2NVSGNUcHVPSnFWY3Jn?=
 =?utf-8?B?clgxYkd0cE9DRmc1MWRlYlFNWnVJNFM2bVNxVllJSVV6UDRDN0dXZnkyNFI5?=
 =?utf-8?B?c3gxekxWakRVMmFOZm5hdzhUbFl6N3l4dzZrNXhuS0hBR2x3cm9xNS9XRkN0?=
 =?utf-8?B?c09kYTI0anU5NmIxcjdla1A4Y2xZaG9WU2JiR1VOcEErc3crWUxOQ3hSZEhY?=
 =?utf-8?B?dkJSK0loWjlWWVdoamlNWHllUmt5MXlGVktqTmxsUjJQTWpFS2tleE1nb3lj?=
 =?utf-8?B?c21PKzBYbS9iQ1o0R0tBek1INnlTNGg1M0JWdTRNUVJuVys5UEJLTzdINVNT?=
 =?utf-8?B?S25uRWh1RVFhNTE0SUxNV0ZrWFk0K3czd2R5cDMxZlAzS241QnVZamtsY09M?=
 =?utf-8?B?czNYeWt4MjducUZEOUpYN3lPM3kzRWJ5RHpXZGplakpDYVNxcHJMckNISUF4?=
 =?utf-8?B?WGlSbmFJREd5WHRXd2sxejhJMGdiekpqTzZneDVxTmR4MU8wNktJL1h3S013?=
 =?utf-8?B?bGVJZUJyU1VKYTdXT3R3elFXYkZBeloweFFJaHFRK3VGQWI4ZkFTNE9PanlH?=
 =?utf-8?B?YUtrVWlPaTdkM01ST013NkRuc1oyNzY5cTlZSGRvK2FwSVQ5cnhTRTJKRVMz?=
 =?utf-8?B?dkw5YytPRTliZVFiSnJ2d0tLYTVIcWNZL1N1eWY0RWNkRTlyTEtqbjJ3NkVE?=
 =?utf-8?B?TDdPVHNrc25iM3NMZ2tHUDBFUk52Zngvai9IYW54UXA0L09KUUNveDQ0TzBt?=
 =?utf-8?B?SzFHdWhwZ2VmUFBGYkM0dWdjVEY5bldXREZFVEt6dzl1ODlsTm8xc2NTdEts?=
 =?utf-8?B?WlNmRVhRM0dtUmdKRkVFV0JabzcvK0E1TzBacU41elhzL2xhNUlTUlVLMndF?=
 =?utf-8?B?QXhoUnR6WWJOUmM3ZFkwYklDQnBMOEdkU1RkTmIyWTdvUEx1Skw5cjdhU2xC?=
 =?utf-8?B?VXl3eThUeGxvMnBxMzIwVklJQUFjWmtablJDSjFzbzIzZklndEwxWU1OZG4r?=
 =?utf-8?B?SU9kaHdXTVNha29BdXFHVjlNYlFBSE1lKzl3Q29DNFZKdS95aGU0VTgrT2sy?=
 =?utf-8?B?VVptYmZkYzNFaGswWkpFU0owU1BUaFAyMDRYRE5kbVVYbTRmYUJJQlNySG93?=
 =?utf-8?B?QjZlaFBxWm5iWXFiVjliOGpZZERHYXY1ZTIySFZHV003R0xBaUJIeS9Md2kr?=
 =?utf-8?B?cXFyRzB5a3EzeWhrckJ3RUJUdHU4WUJDYXE0NEp6bGM3a01TUHFLbTFIVE5l?=
 =?utf-8?B?cmxzczZ0SVVNUGJuTHV1M0tsdWFJckNzM2NpaGlTSGVHUEFGSWNOT1FZZm0z?=
 =?utf-8?B?L0hSOUorQWJCWThnVFFTSUU4UzNRTWRqYWR4QnpENFRmZlA3d0FBS2FHcG1O?=
 =?utf-8?B?UnJUZEdYeHlVUHoxT3NvWGxaWThvTDlCeENIdDNJc1dwMnlXV1kvdHNtKzdM?=
 =?utf-8?B?M0xKa1VBeGRlbXBsYm5CSVZjRVNuelVWTkNzM3E3QnFtcExWajVrZ21qMmM5?=
 =?utf-8?B?cDlOUUlHSHc2NjF6VXFpRTdrazZmT1ZWWS9QaDJlMkNzRFAvdzc3d1ZOVElK?=
 =?utf-8?B?d2YzYXgycGZzMUNUQVFWekRGVTJVNDFFSjY3SDluWnBXUGlGV2JqR3ZaeVdC?=
 =?utf-8?B?Q1RjYVlYY0hhdUNtTHhZdzU1RnFmaFk2VlN0MkRKY0NyMFhWVjhuK2JhZmUx?=
 =?utf-8?B?WHo3TkFaVy9tSU1jWks1RFVQZ0VIK0xReGp3VCtHOFRqOGhUdGxINi94eUY1?=
 =?utf-8?B?TUE1MXN0OCtTMExKVmo1RkVRK0ZwMVBaWWFyUS91aEFBVUtVdnBXTWNhUUhi?=
 =?utf-8?B?UVV5YTRsVjdVMDNhOFNHekwyWFMyYzFrWDZUc3VQRDUvSHZQSngzbmkxb0l5?=
 =?utf-8?B?Q3c0TjN1L1R2RjBadWRHRElNbU82TGtrV3ZOd1hUd2RnQnVnenhhaldBa3Ny?=
 =?utf-8?B?Z25Ja3RyWGpMUkp4QUZCY1ZIRmMwYncvWXllZUhoSmxvZlV0bklGVTNldi91?=
 =?utf-8?B?dzAyQ1RlWklLaW9wNWhZWmtOb1ZHbGJ2aFVjY0lqU1E3SjBqNVdwV29hT0c3?=
 =?utf-8?B?dlFFNTNIL3BubEhXZ29NZUdWQVVvcnhoQytTOEZyMXJ6THVLeElUQ1hIeVl4?=
 =?utf-8?B?OG1TM1BSd0s2eSszVmU0QmE0SjdOVytBbm1RZTRNeUh5eHdIS2Y2bkg5WUFX?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <676396ABB62EA84D9593305FD0587FD0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 120ab104-83e3-4d59-8106-08db19d6d5ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 21:57:50.1736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDvO7HGa3W0Jo9ukK6UcmHTiwb+wrAD3/2WYffrkVGke0Kk+TMqSkI99AoHsBiuAG42HWr6n73ZEA4JTVc1/mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5924
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAyLTI3IGF0IDEzOjI2IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiA+IFREWCBhdHRlc3RhdGlvbiBpbmNsdWRlcyB0aGUgbWF4aW11bSBudW1iZXIgb2YgdmNw
dSB0aGF0IHRoZSBndWVzdCBjYW4NCj4gPiA+IGFjY29tbW9kYXRlLiDCoA0KPiA+ID4gDQo+ID4g
DQo+ID4gSSBkb24ndCB1bmRlcnN0YW5kIHdoeSAiYXR0ZXN0YXRpb24iIGlzIHRoZSByZWFzb24g
aGVyZS7CoCBMZXQncyBzYXkgVERYIGlzDQo+ID4gdXNlZA0KPiA+IHcvbyBhdHRlc3RhdGlvbiwg
SSBkb24ndCB0aGluayB0aGlzIHBhdGNoIGNhbiBiZSBkaXNjYXJkZWQ/DQo+ID4gDQo+ID4gSU1I
TyB0aGUgdHJ1ZSByZWFzb24gaXMgVERYIGhhcyBpdCdzIG93biBjb250cm9sIG9mIG1heGltdW0g
bnVtYmVyIG9mIHZjcHVzLA0KPiA+IGkuZS4gYXNraW5nIHlvdSB0byBzcGVjaWZ5IHRoZSB2YWx1
ZSB3aGVuIGNyZWF0aW5nIHRoZSBURC7CoCBUaGVyZWZvcmUsIHRoZQ0KPiA+IGNvbnN0YW50IEtW
TV9NQVhfVkNQVVMgZG9lc24ndCB3b3JrIGZvciBURFggZ3Vlc3QgYW55bW9yZS4NCj4gDQo+IFdp
dGhvdXQgVERYIGF0dGVzdGF0aW9uLCB0aGlzIGNhbiBiZSBkaXNjYXJkZWQuwqAgVGhlIFREIGlz
IGNyZWF0ZWQgd2l0aA0KPiBtYXhfdmNwdXM9S1ZNX01BWF9WQ1BVUyBieSBkZWZhdWx0Lg0KDQpU
aGlzIHBhcnNlcyBsaWtlOsKgDQoNCklmIHdlIGhhdmUgYXR0ZXN0YXRpb24sIHRoZSBURCBjYW4g
YmUgY3JlYXRlZCB3aXRoIGEgdXNlci1zcGVjaWZpZWQgbm9uLWRlZmF1bHQNCnZhbHVlLiAgT3Ro
ZXJ3aXNlLCB0aGUgVEQgaXMgYWx3YXlzIGNyZWF0ZWQgd2l0aCBkZWZhdWx0IHZhbHVlLg0KDQpJ
dCBkb2Vzbid0IG1ha2Ugc2Vuc2UsIHJpZ2h0Pw0KDQpCZWNhdXNlIGFyY2hpdGVjdHVyYWxseSB3
aGV0aGVyIFREIGNhbiBiZSBjcmVhdGVkIHdpdGggYSB1c2VyIHNwZWNpZmllZCB2YWx1ZQ0KZG9l
c24ndCBkZXBlbmQgb24gYXR0ZXN0YXRpb24gYXQgYWxsLg0K
