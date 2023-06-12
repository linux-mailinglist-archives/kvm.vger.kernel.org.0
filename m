Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3A972C2B4
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 13:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjFLLSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 07:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbjFLLQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 07:16:29 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2C08A78;
        Mon, 12 Jun 2023 04:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686567905; x=1718103905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iAzNJ+W9gW2csJUcJi5/bzlWvAPYFrge9kUi8D+kcRc=;
  b=E6CvGdo3FGKGr3fbRvFEBDCrI7vJQatVAFEOBjHdbl2WotSsCriAGJii
   /WM9d5v5Z9tH0kLJupPBNkFXzU4GmZzzoTaC3IcuyqCF6tapntdA6ZeOH
   aMDtN1oIranYeRWLMyyIw245M6I2avQZkqwwbrbPiDk4QKAOpW4syP3f+
   /LaDNZj0cEL8uHcJCgEuHKuNjze1T9vDd5tFfISTmJ6opYw8bcU8HBEGz
   iOLE7lrrPl6asJqZWejnVwYZxQxzY3ZrvB5A9QhaSDd/4KLhwyaMW7SEz
   liL3mbg2rBORYQ26oKbq1xtnHQRS7gUFzDPm3S+qqbvmpa2mcu9ONibVK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="423885828"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="423885828"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 04:04:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="711151443"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="711151443"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 12 Jun 2023 04:04:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 04:04:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 04:04:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 04:04:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 04:04:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCz613QTBFaDXN9GcfiJujNBkp1EFJQrA7zQvE1hP1c+0KNafyu3+X1DarOAgnCiYPL8lKrV5efGkybcQyiBCtu5bzx3N7BEOul70BxtiXeploG+Hk4G94OHUZVt3L/0XiI/YMVummhHikimSXIIC7Kb3SIjKFTe8r5Uxy1YYB66GP082uMhJ1pB0DkKHhMSXo+/TUkXGNyVBI8Pfut1TuzvEHLlWVR3eU8fH+6ATSJTkYBDYUq4PgPFyVGhfzu8onOGCsjeQzaJ3mG6UpTHT2dIIS7i8QDTv0YF43V3q6jBt68bA86O+9UZyubYsfIiliFqwi6OsH6pF0guj+QNbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAzNJ+W9gW2csJUcJi5/bzlWvAPYFrge9kUi8D+kcRc=;
 b=L1M/RhWiu5nTut41OLdqAXGi+dziemWTJsvDFhK+Z8uNl5la4bX0UZWEn/iZAAgnj6RxAjNUHjOTDvhtSvIgB5oBdqvlMs6OzCmrHNy40CbVVmtuxOOS2oViDbmlQqR+up2E6CEK7U7wQjr1EKoBzMQyCVyKHxZBHX6cJTTKk1bIhIjqUPr/jB0DZrHqRxC20I5j4POJp3+kuS3ntXJ04GgYy0dC4e7xnkttH7uRXjRhjK1GvMa6owlLCSxodljfkn8E+q9m76lJt/g+Urs61sjM+wavzoKviMQReK5K3ouU5gXa1gY43GVl+mFUEDcsGbejdyvCUgTetvLJjw17Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CYYPR11MB8305.namprd11.prod.outlook.com (2603:10b6:930:c1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 12 Jun
 2023 11:04:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 11:04:49 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "n.borisov.lkml@gmail.com" <n.borisov.lkml@gmail.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Thread-Topic: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Thread-Index: AQHZlu+v0XNcOtw04kG29tp3PFLJcq+Ck3qAgAR6DYA=
Date:   Mon, 12 Jun 2023 11:04:49 +0000
Message-ID: <b3414aedf5a8f2a854aae82a8ab7b2a6742801e3.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
         <51f4c068-7dbc-6f7d-fa49-b98807b74bee@gmail.com>
In-Reply-To: <51f4c068-7dbc-6f7d-fa49-b98807b74bee@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CYYPR11MB8305:EE_
x-ms-office365-filtering-correlation-id: 84ad1c92-99c3-455d-3d53-08db6b34d756
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b+xtxcLIiLeKUDVHAi74p1ppp6fHwSJ8v3h7unx5M9mEc2w6BTgZAgmdxRFUUlVN4TN2GaJmSTXJTmGMg58LEFbwKFKL3WidQzfedO2S6YSkFU3Bv9AETfeQTFlu8/Ji47Sb2zNIV/T+gFBBaYPnc9CVNsUAqL1gMaegIQTCjqmh1ywbSotrebpFSvShDCStLj63jZLMpGnRO3+932pYKtROz9hvxT7n9kIsNwOKl6hW1m5KjhijcDpk0e5xWH4oLeQY1vanvgASw4QT4nYBvfpqMocG1g60nlx/Bbq4H7+jnoujLmHcETLQKwQKPH+INLCr8M1ufd1eJuc2waUqQDHurKpFMeVHhcRjqnEt1CfhLwfe9fzhoMNdPiQbVaOyEcV9FFhoXU96ECY4T69qckEp5UGu/D0oXTCAgZO91HWCcz1F17oiG/wwWc7pe7T1z1gHpujjKr3tQEz1WrLKJ0l2HTBQu60t3hpU8KCtkAZEMNMWQIYIwUX4JjKmUrFd+Vm1iflbn1On4luhmY2VwuQ1JbV2MtRu0DZIT9S4iZkQkjcSTGMHVfLgZzT4hXigFxBEY4uOeJRhYyFRQ4A/TsP6hRui97r/SgoLQKY0GXI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199021)(83380400001)(86362001)(7416002)(8676002)(71200400001)(110136005)(64756008)(82960400001)(38070700005)(38100700002)(66556008)(76116006)(66946007)(66446008)(316002)(122000001)(478600001)(66476007)(5660300002)(4326008)(8936002)(41300700001)(6486002)(2906002)(36756003)(54906003)(6512007)(91956017)(186003)(26005)(6506007)(966005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEY2c0haKzhnaHZBVUhxT2VDc2FHWmYwdGsybnRGb3pkWTAya3BTK21qeTNI?=
 =?utf-8?B?L3pBanR4RWM0RWJ4dTNTNnEzT0J2aFR6b1Z2eGZWejVmL1hsQUprSVhlUFNW?=
 =?utf-8?B?NE1IY00yWUFvZnJ5T1hhQVlxOTA0NTg5TXlOVTlHZUhveTRvV2ZDSVVKeURY?=
 =?utf-8?B?Z3pwUUlBakpFS3V6VzBZeW5admt3UDc1RVpkcWEzbThqS3ZoVkNCQUZONTRh?=
 =?utf-8?B?TG9ERDFTVVVCR3FCdURHR1FmMDVkbnhxUFVqZm91OEg2Z1hMV3ZkUGEzTSt1?=
 =?utf-8?B?TVZsazVscnFvRUZ1SjVNa3owMUpqTUI1Q3ArNFFBWnZ4bGVVQUxESnk3cUc3?=
 =?utf-8?B?L3ZVQ3d3MEYvWkpLdmhCeWg0TzVOVWNKUmw0YkIyb2hSV3AwdWIvS1MxbmJB?=
 =?utf-8?B?QUpBU0lQWFdrMzIwQkJMZ3Z1aGJLQzRXcnNiSFdZYURtQWo1bmhFZUVsZmMr?=
 =?utf-8?B?YmI3VUhOemJINW1MTTcxTGd3OWROckJid3NSUUh5NU5aOWhOVjhvZ1MvNEdq?=
 =?utf-8?B?NGNLaDdwSGp3SWc2SFJUS2IyenhuWWU1M0pYL0t3UFYvMmJRMU5IdmRmUG0y?=
 =?utf-8?B?aUdKaEZUbVd5cVF5dW03Y0hHQUxtb1QxVFNsaXUrcFM4MnQ1WjZHOTIxbXFz?=
 =?utf-8?B?OUNRL3ZPRkxPZUlNM0Y2VGM2V21TdTc2SW9hK3pzaFQvemd2Vjl2OE9BVU1L?=
 =?utf-8?B?bVZDSXpBRWpjaGIvZlJDTzJpZC9yWVZvTjNZa1dRekZJN1BXbDlKcTI5a0FP?=
 =?utf-8?B?eVBOMnBTWjZVc0dVTVdLc0J3QlJWanl5Q2tpQ1p5d1pyNGdnVlVKYVZJS2R4?=
 =?utf-8?B?VkpDcG5saStSUW8zVVFDbkhweFZ0WDcyZllLSVFlRjhpY1RhM25ycFNhRzZn?=
 =?utf-8?B?cXZvQUlkSEZJZjlpcVdJR0RZbmoyaG55WW5GWE1UTDY1UXVuNGk5ZU5UTUxv?=
 =?utf-8?B?TDFxeTBMQ2hjRGN1UWdEb3VScExRazUyZ04zZGd0QnF4QjZPTmEwZHJZcUFL?=
 =?utf-8?B?Wi9ZblZ6aCtNMS9BTTVvTndNVzZ0Zjh1TmkwRzE4VUZ1M2F1Vnh1eUlYY1VW?=
 =?utf-8?B?WmtveUl3L1Axd0NtMXVXSzB4c0dieVFROEZVdnlRQngzckZDV3FTeS9KMWF0?=
 =?utf-8?B?cUwya0ZZM0lHc2RuV1hRakpvWW1ZRlpFWFJDT0tTaHlqZVgxTjhtdGg5SVV6?=
 =?utf-8?B?cDZWTWVkS2x3ejI5bW5oRWZCNWw4SkRFbjZ1TmRnY1RsS0RxVUNsV1h3OUMr?=
 =?utf-8?B?dE42bHZpQkxIb0YvL0QvTTB2MTc4ZHlMZTEyaFFQdEhzUTVSc1FtSkQwZkVD?=
 =?utf-8?B?NVcyTllJQUdYZzYvYTFYYmRyTGQ5NVFlN1MzR1pGU2ErMDJ3aUM3K2pCOEFt?=
 =?utf-8?B?b3hYbVhTaVJhUjJPdVlxK1NuZklFZGhlckFPT2RvL2xzU1dnN1poL3FyQVJS?=
 =?utf-8?B?enc4SEVXQzFRMWVQa0Zzdmx6SU1pc3dMQWxXQTAweXBjQXhldnRSSDVjZnN1?=
 =?utf-8?B?MEE0R3lSRnFNYk5iVVVBdEs4eDF1ZVA4MHVYSFFrbHVJMVJKZTdPZm9oMjVv?=
 =?utf-8?B?TW0ycU9mN1hjWTJ2U0E3YTQrbVVDbUFYNVo5SG44WEVQYk9wUkJWTC9SSGly?=
 =?utf-8?B?L2pRZ0lPbjhvWW9xTVFmUFk0R1gyc2pvQ1dndUE5ZzZwVFVBcFk3NHdOSk9L?=
 =?utf-8?B?SUZrUm1HSDFHYUFsdWsrQXFvU2t4NncyMXRKK29nQktndFdpbWNyYkR3dFVa?=
 =?utf-8?B?SG9BVU5KbmpwV3lEc1B6RHFpSWhVdytnU09zRzJnRHdJdFFDOTB3d09sdk9y?=
 =?utf-8?B?Z29mdEI0TGRzbllEZEVmY05nVGZjbkY4NmpiZnduY29FZ0g3L2NXYUg5OTRB?=
 =?utf-8?B?TXM5WkpBWERQcHNjWnVpOVo4amludTV2Lys3T3RhUlJXTHpVd3hobG82Y2gv?=
 =?utf-8?B?b3dUc1hIb09SVWVWKzF5OW40NXBaRng1RS9Xem1iYU85M0o1Sk1xTGEyZWJ0?=
 =?utf-8?B?N3FlMTJOZC80NjBGb0YySEhFeVo5TFprNnRkdVE0NVNnRkZHWW15N2lLTWhi?=
 =?utf-8?B?T0pIMDlidUxyLzZWaW04YXNWbkJ1dy95OGZjbXVXMHYzRmU5NlJqeGpIK05m?=
 =?utf-8?B?bXZOUkF2bk9uc3Nhcmd4TjNkWmRqYXpCdmNYRE9waXYrOEd1aFd2VVZYVmFJ?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D586AB16A37CD47A8AACC8D247E72E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ad1c92-99c3-455d-3d53-08db6b34d756
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 11:04:49.8001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XEFU/zRcN5qG8UyS+/QvaoFqNYh5pmC7zjpqnd/AFDsiUI/8vHll/p7y2adMdaAegS0diah0sBlIqJEWaC7Wgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8305
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

T24gRnJpLCAyMDIzLTA2LTA5IGF0IDE3OjQyICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiA0LjA2LjIzINCzLiAxNzoyNyDRhy4sIEthaSBIdWFuZyB3cm90ZToNCj4gPiBD
ZXJ0YWluIFNFQU1DQUxMIGxlYWYgZnVuY3Rpb25zIG1heSByZXR1cm4gZXJyb3IgZHVlIHRvIHJ1
bm5pbmcgb3V0IG9mDQo+ID4gZW50cm9weSwgaW4gd2hpY2ggY2FzZSB0aGUgU0VBTUNBTEwgc2hv
dWxkIGJlIHJldHJpZWQgYXMgc3VnZ2VzdGVkIGJ5DQo+ID4gdGhlIFREWCBzcGVjLg0KPiA+IA0K
PiA+IEhhbmRsZSB0aGlzIGNhc2UgaW4gU0VBTUNBTEwgY29tbW9uIGZ1bmN0aW9uLiAgTWltaWMg
dGhlIGV4aXN0aW5nDQo+ID4gcmRyYW5kX2xvbmcoKSB0byByZXRyeSBSRFJBTkRfUkVUUllfTE9P
UFMgdGltZXMuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdA
aW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IA0KPiA+IHYxMCAtPiB2MTE6DQo+ID4gICAtIE5ldyBw
YXRjaA0KPiA+IA0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIHwg
MTUgKysrKysrKysrKysrKystDQo+ID4gICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggfCAx
NyArKysrKysrKysrKysrKysrKw0KPiA+ICAgMiBmaWxlcyBjaGFuZ2VkLCAzMSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+IA0KPiA8c25pcD4NCj4gDQo+ID4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaCBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90
ZHguaA0KPiA+IGluZGV4IDQ4YWQxYTFiYTczNy4uNTVkYmIxYjhjOTcxIDEwMDY0NA0KPiA+IC0t
LSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguaA0KPiA+IEBAIC00LDYgKzQsMjMgQEANCj4gPiAgIA0KPiA+ICAgI2luY2x1
ZGUgPGxpbnV4L3R5cGVzLmg+DQo+ID4gICANCj4gPiArLyoNCj4gPiArICogVGhpcyBmaWxlIGNv
bnRhaW5zIGJvdGggbWFjcm9zIGFuZCBkYXRhIHN0cnVjdHVyZXMgZGVmaW5lZCBieSB0aGUgVERY
DQo+ID4gKyAqIGFyY2hpdGVjdHVyZSBhbmQgTGludXggZGVmaW5lZCBzb2Z0d2FyZSBkYXRhIHN0
cnVjdHVyZXMgYW5kIGZ1bmN0aW9ucy4NCj4gPiArICogVGhlIHR3byBzaG91bGQgbm90IGJlIG1p
eGVkIHRvZ2V0aGVyIGZvciBiZXR0ZXIgcmVhZGFiaWxpdHkuICBUaGUNCj4gPiArICogYXJjaGl0
ZWN0dXJhbCBkZWZpbml0aW9ucyBjb21lIGZpcnN0Lg0KPiA+ICsgKi8NCj4gPiArDQo+ID4gKy8q
DQo+ID4gKyAqIFREWCBTRUFNQ0FMTCBlcnJvciBjb2Rlcw0KPiA+ICsgKi8NCj4gPiArI2RlZmlu
ZSBURFhfUk5EX05PX0VOVFJPUFkJMHg4MDAwMDIwMzAwMDAwMDAwVUxMDQo+IA0KPiBXaGVyZSBp
cyB0aGlzIHJldHVybiB2YWx1ZSBkb2N1bWVudGVkLCBpbiBURFggbW9kdWxlIDEuMCBzcGVjIHRo
ZXJlIGFyZSANCj4gb25seTogODAwMDAyMFsxMjNdMDAwMDAwMDAgc3BlY2lmaWVkIGFuZCB0aGVy
ZSdzIDgwMDAwODAwIA0KPiAoVERYX0tFWV9HRU5FUkFUSU9OX0ZBSUxFRCkgYW5kIGl0cyBkZXNj
cmlwdGlvbiBtZW50aW9ucyB0aGUgcG9zc2libGUgDQo+IGZhaWx1cmUgZHVlIHRvIGxhY2sgb2Yg
ZW50cm9weT8NCj4gDQoNCkl0J3MgZG9jdW1lbnRlZCBpbiBURFggbW9kdWxlIFYxLjUgQUJJIFNw
ZWNpZmljYXRpb246DQoNCmh0dHBzOi8vY2RyZHYyLmludGVsLmNvbS92MS9kbC9nZXRDb250ZW50
LzczMzU3OQ0KDQpUaGUgbGF0ZXIgdmVyc2lvbnMgb2YgVERYIG1vZHVsZSB0cnkgdG8gdXNlIFRE
WF9STkRfTk9fRU5UUk9QWSB0byBjb3ZlciBhbGwNCmVycm9ycyBkdWUgdG8gcnVubmluZyBvdXQg
b2YgZW50cm9weSwgYnV0IFREWCBtb2R1bGUgMS4wIGZvciBub3cgZG9lc24ndC4NCg0KVGhpcyBw
YXRjaCBhaW1zIHRvIHJlc29sdmUgdGhpcyBlcnJvciBjb2RlIGluIHRoZSBjb21tb24gY29kZS4N
Cg==
