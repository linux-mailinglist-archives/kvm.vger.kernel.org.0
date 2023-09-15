Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DCA7A23BE
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbjIOQnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 12:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjIOQnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 12:43:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901F4AC;
        Fri, 15 Sep 2023 09:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694796177; x=1726332177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VxMZOYqSbwJq+N9wEOJeS90bL/FmG/l4Bhrl05EYzk0=;
  b=ajNozXoxISORE3ftiOuk5Lvyi5mSaAX3Owq2t0IvgUXXiIAZYCuEHfC2
   xwGsRUVfZOgtND+++6o3/O1mr3TOFWxq3iM5/t4IOpvy8EkrB4hOktMGf
   GiZUQzcsrLeQ7hLW4Wx89ffq6+o2T3Zwc7KgS6SwEM3aIeFovQEgQbV9+
   QiaZvYPae0zmdLHZeKUVAb4/z2JdJHW6LG35limpd5eBgB10SM+664QYX
   JJHjEkUUIeieL1MF3sHleJ1yFXKFxPSYJBvWpWGkH9cc/FhQQWByIWukS
   oMXqdxB/zjTEeXgIlTTmtWqEgy//hhxQFC1t0bYtf6hfAfSlm8iPIMiRi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="359548603"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="359548603"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 09:42:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="738392864"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="738392864"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Sep 2023 09:42:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 09:42:56 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 09:42:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 15 Sep 2023 09:42:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 15 Sep 2023 09:42:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9fqiiHVbGukZUITPjII/Ur/13ugq3dhgqLj5lxK8tHQCOhM/UetAijORszVSquFhEc8LCLE6fY5SNk1l2oqICi+y7yo6VkVxfOXqwVvlmVSTG+e3cGlaVCPyOwi7Q9pzkfjSMlvqKwd8qphmXd4hONTflsy1enf2AaVhBehUWEtT0/7WHZyl3ABpncgth59HSGuTp/sALTPsxChVQ/ssejneyM/L3574er0oAMB4rhHrh2w9/r5oqeg2SKJ/7MncjELlpS4ktbfKMwA9ysx4lop/NzsMcCVnlLGprLVfCsDDbzJf1KUtuGCkCdzHSzg8zrjx8zzVVb5M/TRgZPEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxMZOYqSbwJq+N9wEOJeS90bL/FmG/l4Bhrl05EYzk0=;
 b=TlS21G31z7RjOeL3afacC5Q7D2wOG1EhqxqBbHXwrllpu/YlEWp7tB42C7Zh2qhP73xPf5bKUDL/nVNXWn9cHlT+BJyEni76THJGKPktjcaPxdL4phUDXEpasgWT7SxvxTp+AvnUzKztf3qSkPktguHLmEEo61Rxwp0YVpwbrugr0uVcEASE0bJXVCe+7kH5Tju4ckW7f1jwDjOyzh9avNbj6L5aLuaKpwk2sF6AfxlN+6ZjHgu2rVw7EVwdwYG8dk2w1mdzrxvdIU62cnk/6WmV0zQKt/6PLhhfHJtyKzy/2fM4D2PDWDlfb7hH/gM/Ti5nKC++YJOlCOyJuyLJqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6960.namprd11.prod.outlook.com (2603:10b6:303:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Fri, 15 Sep
 2023 16:42:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 16:42:52 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
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
Subject: Re: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Topic: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Index: AQHZ51Nu5rvrYdY8+Eu3RowU62VYUrAbxN0AgABT0YA=
Date:   Fri, 15 Sep 2023 16:42:52 +0000
Message-ID: <c1227134ab2430872824334d2e68e8f43d6d630f.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <12c249371edcbad8fbb15af558715fb8ea1f1e05.1692962263.git.kai.huang@intel.com>
         <87497f25d91c5f633939c1cb87001dde656bd220.camel@intel.com>
         <c33f7c61a1a24c283294075862cae4452d7dec3d.camel@intel.com>
In-Reply-To: <c33f7c61a1a24c283294075862cae4452d7dec3d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6960:EE_
x-ms-office365-filtering-correlation-id: e4cc9b0a-532a-4ee6-a897-08dbb60acdcb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DOhdYemfWuDXFeX5Gt4+Un38U93S6lsXpH5jxYf5B1ypjSfuSSIl2GX8pzdkywY08wd1PgLi085sG0nSqjERPNxB9V1Necu8VYLguJO1Js+hmmaxfHd573ucmUR2bs8nkq5JpoCGRJ1ExxQELyi0itQgVMi3FiccukNylX+VFI498/9IUhGNq+xj6AON3kw4CnSk73ZBfTu6Yq5KlMmPkxgmc02BwDh4Kow7BMRrjzTJcy6rWMXwF/aanWWEpuWQxyLVNKVaWDuiaW5D4VhyL4gB/bR+dgO5X3fglFo7q2R4I/hqdgtlM/ReNyzc1AQNU9iEdJ6eOdtb+Kr8YcQD3AExpsEMziZTQ3AuJDV+DUIiUja6EEPHYP2cDb4bqyHCp1r++oBF4fRrGUHCmyERNM85vTuol/qt0iCVJ011986JZvdMWttghFnCvtUE9lDLBTJ72UpSm/JNcQaLdnSQ6uowmOoFy5f7odsp8tBGgts5PccJK+ndCYKSQGZzkaFxCkcX8kMpwKynjAnNKhjGpWydNKIa9YbIqSiu1CMeL/YuENtd2cUPZWnHso4ca0LLyafZX2p06X60fWyj5nXSlEePdZFsc5ehrVJVAOVNx/xdUpo0qV1p75NvhmDNzD2X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199024)(1800799009)(186009)(6512007)(26005)(76116006)(64756008)(66946007)(66446008)(54906003)(66476007)(66556008)(110136005)(91956017)(316002)(36756003)(6636002)(41300700001)(2616005)(122000001)(478600001)(38100700002)(38070700005)(6486002)(6506007)(82960400001)(71200400001)(4326008)(2906002)(7416002)(8936002)(8676002)(86362001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVN6MDF2Zmd5U0NYejBtM05NQmJwV3J1TitWWW9MdkJKUDExdGNDY21nbU1C?=
 =?utf-8?B?MllZM2d0dm1zZ2tkcGZ4WUdhN0xvS25TYmxoZzdqUzhZMEhacnhad3lia0lP?=
 =?utf-8?B?SnBkL2xBN2xEdHRud1dmTTVYdUpKQy93K29PQlROU3Yvc3REdXIzU3U0OVMx?=
 =?utf-8?B?TFMwSjB4eWRWM2ZhQkY3QW5EV0tWY1UwQkw2ZS9wWU1mam9ZR005WC9YT29m?=
 =?utf-8?B?aTAyWHJYSWlnOHN5TW5wZUF0d0Fyak5RRTRMMlRNRnhRc1BvVk94OGlQeDJn?=
 =?utf-8?B?RFdRdTd5eEd4VUExWUlHS3htZ3lqUnpqVmZobkt0bDNuYWlYUFFrcVVDSlRu?=
 =?utf-8?B?WWpkaEYrZS81NW4xUys2WmRsbUk2M2F1bmZyUEZPa0c5WjBsYlQ2dWR2aE1p?=
 =?utf-8?B?Q2xyaW5LQnFaY3oyTkQraktsZm5sbE5vNFBxMFBqUGRQdzNZNFRRcVBKSkdC?=
 =?utf-8?B?MEJhTmJxK0hRTEpyaU5iRFFBRisyc3EvMUFyRlBwUEs2WkJTNHY4ZXc1U01q?=
 =?utf-8?B?WksyZXZSYjczZ1A5bTE2bWdJY2xVRSttT29XZWdRL2JxYWl2NkRWSkZDckFn?=
 =?utf-8?B?SUNDdjBBSGZsMFVvWVk0Q1JlY0I4UktUdHgzcUNwNERYTElic2NGNEVyRDUr?=
 =?utf-8?B?ZFl6Y01NSG50UTJ5T2hiVmRSaEc1OFhSczhTWWJKZTJKYU5DMWtVR0NxczQr?=
 =?utf-8?B?RjBUMjhWZ2lkQnZoNmtlSDJuSGNrMi9xemsyR1lpcnZ5bUVCU1RIbGxkUGkz?=
 =?utf-8?B?Q2tTRGM5U1BzamNXd21yYlJDV2gvQ3lWM3RsbXBOS05PRjVBRXhEc0lLNncw?=
 =?utf-8?B?OXkyOVJBS0E0M2JJS2M0dVdZaHFDdEZNS1pkNXlHcFFac1lpenJyTzkzdlVl?=
 =?utf-8?B?aEpadXFEbU1Ubk94UW1URm1vQkhJalU3QkdGTTM3QVcwU25TRDN6VEFzUW9a?=
 =?utf-8?B?R1M3OElVdWh4WDF3QUFoNnFLR0UveWN4aHJiRWRoS1RpSlJNSVNqSkNwdXVM?=
 =?utf-8?B?cXl5bmNWRmRPK3RNS2JPVm9XamxQa1R3K0xETmR1NXIyY2NqcThheW9waW1D?=
 =?utf-8?B?aDAvQ1FlenVqSERLd3hHWjdwTTRxQ2pCS1JRNnFBdnpockdQQ21ZbHYyK2NT?=
 =?utf-8?B?bkFnS1oxSlViTkRVWUptdlpRVFRPOXZSK2VRMm1veW9aRnNmTG9qbUdLR1Nw?=
 =?utf-8?B?RWhUaFRZZkNFbWp6ZkpmcnA0VHVKVHNBZ09xei9RWXhjS3BCaElzMlp3Z2VM?=
 =?utf-8?B?OFR0Qkp5NmlEakZJb3RSUXo1aW1UeE9iUkNJNVdVQVhWT2ZzbHMvTFFNU1h4?=
 =?utf-8?B?cnpOR1F6dVVmSlcrYnRFQ2FUbEpOZm8vWWNkTnUwd2N4dStPUFBSQkVmb3V5?=
 =?utf-8?B?WXQ5T3U5QytjbGhqTHEwQ1dvMjlLWlJrL0xYNlEzSmpJaFB1ZGd6RGt2MkFn?=
 =?utf-8?B?ZFdPS1BHM1lGTVdxSUVJVndtUzdPRmhwa0pKOTBia2xCb0dJM0ptall2Q1ZO?=
 =?utf-8?B?VjFaMU9od051ckV6VlUyOWxucll0OW1PYWwrZUNFSUtaemQ5K1ZNWHhmOERy?=
 =?utf-8?B?WkE3dDM2MzFKR0VsMFZwOEl3ZG9ySDh0b3A4bXRoNGlLanhRaVllWFhRdS8y?=
 =?utf-8?B?VEdlTlRtS3pBQUpaTXlFRUtUMmhVUW5yaU44dUxic1A5YTJTNFlxN29SZlZ0?=
 =?utf-8?B?Q1poV2x5V0tEb0txVW0vWnliZnBaVzBhQXV6dmRtSnJ5VFZqZTZDV2IydUFQ?=
 =?utf-8?B?VFoxUm5WWEZEMVljQTRkRTFmbDJJTHVNZDZPYkJLNHNlY0t0WU92cDZzSm9q?=
 =?utf-8?B?UHQ0bm5JSHd3Q3R1N1U3d3IyVVZ2VmplaGErbnRKcUNsOHUrRzhPOGZBYjZY?=
 =?utf-8?B?eGZrazltUk1ZVW03djQ5R200blhtTEE2L0Q4RGVIV1NqUEU0bjBDZGtOYkJ0?=
 =?utf-8?B?TkR6S2RSZjg1dGNzbTc0WVZ3ZG5nemQ3R0tTdTU1N0pXMWQrMUFVL3UwbERL?=
 =?utf-8?B?bTJmZXlKRWhmeGloV0tzL1JneDAvK0UxZlo2ejNtN2VNakxJZzAybmNiNW50?=
 =?utf-8?B?dkROUm9zTXdHQ0JxUUVNaDhUTlFEM2ZBRzNsbzNDVWl5SVZOMDV5emN2cFJ6?=
 =?utf-8?B?Q0wyRVk4V1k4REtDVnZYRmJsYUFHUkFCSWZSVFNVVVh5ZTVxOU0xYjdZbTBv?=
 =?utf-8?B?V2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED36263A0CC29446A68DF6BE122DE9B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4cc9b0a-532a-4ee6-a897-08dbb60acdcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 16:42:52.1495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KwW0jfwULvwE65jBiNkiXn+mu1tiDRu/5B6CaEi4MISsgsiZPr0mww1awcHe9XgzjareF15ygaT4Sc52tn/65KF8NS7zBub+DhcHre/6GIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6960
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA5LTE1IGF0IDExOjQyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjMtMDktMTQgYXQgMjE6MzYgKzAwMDAsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3Rl
Og0KPiA+IE9uIFNhdCwgMjAyMy0wOC0yNiBhdCAwMDoxNCArMTIwMCwgS2FpIEh1YW5nIHdyb3Rl
Og0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMN
Cj4gPiA+IGIvYXJjaC94ODYva2VybmVsL21hY2hpbmVfa2V4ZWNfNjQuYw0KPiA+ID4gaW5kZXgg
MWEzZTJjMDVhOGE1Li4wM2Q5Njg5ZWY4MDggMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9r
ZXJuZWwvbWFjaGluZV9rZXhlY182NC5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvbWFj
aGluZV9rZXhlY182NC5jDQo+ID4gPiBAQCAtMjgsNiArMjgsNyBAQA0KPiA+ID4gwqAjaW5jbHVk
ZSA8YXNtL3NldHVwLmg+DQo+ID4gPiDCoCNpbmNsdWRlIDxhc20vc2V0X21lbW9yeS5oPg0KPiA+
ID4gwqAjaW5jbHVkZSA8YXNtL2NwdS5oPg0KPiA+ID4gKyNpbmNsdWRlIDxhc20vdGR4Lmg+DQo+
ID4gPiDCoA0KPiA+ID4gwqAjaWZkZWYgQ09ORklHX0FDUEkNCj4gPiA+IMKgLyoNCj4gPiA+IEBA
IC0zMDEsNiArMzAyLDE0IEBAIHZvaWQgbWFjaGluZV9rZXhlYyhzdHJ1Y3Qga2ltYWdlICppbWFn
ZSkNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqB2b2lkICpjb250cm9sX3BhZ2U7DQo+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgaW50IHNhdmVfZnRyYWNlX2VuYWJsZWQ7DQo+ID4gPiDCoA0KPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgLyoNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCAqIEZvciBwbGF0Zm9ybXMgd2l0
aCBURFggInBhcnRpYWwgd3JpdGUgbWFjaGluZSBjaGVjayINCj4gPiA+IGVycmF0dW0sDQo+ID4g
PiArwqDCoMKgwqDCoMKgwqAgKiBhbGwgVERYIHByaXZhdGUgcGFnZXMgbmVlZCB0byBiZSBjb252
ZXJ0ZWQgYmFjayB0bw0KPiA+ID4gbm9ybWFsDQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgKiBiZWZv
cmUgYm9vdGluZyB0byB0aGUgbmV3IGtlcm5lbCwgb3RoZXJ3aXNlIHRoZSBuZXcNCj4gPiA+IGtl
cm5lbA0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgICogbWF5IGdldCB1bmV4cGVjdGVkIG1hY2hpbmUg
Y2hlY2suDQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgKi8NCj4gPiA+ICvCoMKgwqDCoMKgwqDCoHRk
eF9yZXNldF9tZW1vcnkoKTsNCj4gPiA+ICsNCj4gPiA+IMKgI2lmZGVmIENPTkZJR19LRVhFQ19K
VU1QDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGltYWdlLT5wcmVzZXJ2ZV9jb250ZXh0KQ0K
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzYXZlX3Byb2Nlc3Nvcl9zdGF0
ZSgpOw0KPiA+IA0KPiA+IFdpdGhvdXQgYSB0b24gb2Yga25vd2xlZGdlIG9uIFREWCBhcmNoIHN0
dWZmLCBJJ20gbW9zdGx5IGxvb2tlZCBhdA0KPiA+IHRoZQ0KPiA+IGtleGVjIGZsb3cgd2l0aCBy
ZXNwZWN0IHRvIGFueXRoaW5nIHRoYXQgbWlnaHQgYmUgdGlua2VyaW5nIHdpdGgNCj4gPiB0aGUN
Cj4gPiBQQU1ULiBFdmVyeXRoaW5nIHRoZXJlIGxvb2tlZCBnb29kIHRvIG1lLg0KPiA+IA0KPiA+
IEJ1dCBJJ20gd29uZGVyaW5nIGlmIHlvdSB3YW50IHRvIHNraXAgdGhlIHRkeF9yZXNldF9tZW1v
cnkoKSBpbiB0aGUNCj4gPiBLRVhFQ19KVU1QL3ByZXNlcnZlX2NvbnRleHQgY2FzZS4gU29tZWhv
dyAoSSdtIG5vdCBjbGVhciBvbiBhbGwgdGhlDQo+ID4gZGV0YWlscyksIGtleGVjIGNhbiBiZSBj
b25maWd1cmVkIHRvIGhhdmUgdGhlIG5ldyBrZXJuZWwganVtcCBiYWNrDQo+ID4gdG8NCj4gPiB0
aGUgb2xkIGtlcm5lbCBhbmQgcmVzdW1lIGV4ZWN1dGlvbiBhcyBpZiBub3RoaW5nIGhhcHBlbmVk
LiBUaGVuIEkNCj4gPiB0aGluayB5b3Ugd291bGQgd2FudCB0byBrZWVwIHRoZSBURFggZGF0YSBh
cm91bmQuIERvZXMgdGhhdCBtYWtlDQo+ID4gYW55DQo+ID4gc2Vuc2U/DQo+ID4gDQo+IA0KPiBH
b29kIHBvaW50LsKgIFRoYW5rcyENCj4gDQo+IEJhc2VkIG9uIG15IHVuZGVyc3RhbmRpbmcsIGl0
IHNob3VsZCBiZSBPSyB0byBza2lwIHRkeF9yZXNldF9tZW1vcnkoKQ0KPiAob3IgYmV0dGVyDQo+
IHRvKSB3aGVuIHByZXNlcnZlX2NvbnRleHQgaXMgb24uwqAgVGhlIHNlY29uZCBrZXJuZWwgc2hv
dWxkbid0IHRvdWNoDQo+IGZpcnN0DQo+IGtlcm5lbCdzIG1lbW9yeSBhbnl3YXkgb3RoZXJ3aXNl
IGl0IG1heSBjb3JydXB0IHRoZSBmaXJzdCBrZXJuZWwNCj4gc3RhdGUgKGlmIGl0DQo+IGRvZXMg
dGhpcyBtYWxpY2lvdXNseSBvciBhY2NpZGVudGFsbHksIHRoZW4gdGhlIGZpcnN0IGtlcm5lbCBp
c24ndA0KPiBndWFyYW50ZWVkIHRvDQo+IHdvcmsgYW55d2F5KS4gwqANCg0KSSB0aGluayBpdCBt
YXkgcmVhZCB0aGUgbWVtb3J5LCBpcyBpdCBvaz8NCg0KPiANCj4gSW4gZmFjdCwgaWYgd2UgZG8g
dGR4X3Jlc2V0X21lbW9yeSgpIHdoZW4gcHJlc2VydmVfbWVtb3J5IGlzIG9uLCB3ZQ0KPiB3aWxs
IG5lZWQgdG8NCj4gZG8gYWRkaXRpb25hbCB0aGluZ3MgdG8gbWFyayBURFggYXMgZGVhZCBvdGhl
cndpc2UgYWZ0ZXIganVtcGluZyBiYWNrDQo+IG90aGVyDQo+IGtlcm5lbCBjb2RlIHdpbGwgc3Rp
bGwgYmVsaWV2ZSBURFggaXMgYWxpdmUgYW5kIGNvbnRpbnVlIHRvIHVzZSBURFguDQo+IA0KPiBJ
J2xsIGRvIHRoaXMgaWYgSSBkb24ndCBoZWFyIG9iamVjdGlvbiBmcm9tIG90aGVyIHBlb3BsZS4g
wqANCj4gDQo+IFNvbWV0aGluZyBsaWtlIGJlbG93Pw0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCj4gYi9hcmNoL3g4Ni9rZXJuZWwvbWFjaGlu
ZV9rZXhlY182NC5jDQo+IGluZGV4IDAzZDk2ODllZjgwOC4uNzNlZDAxMzYwNDA4IDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbWFjaGluZV9rZXhlY182NC5jDQo+ICsrKyBiL2FyY2gv
eDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCj4gQEAgLTMwNywxMiArMzA3LDE4IEBAIHZv
aWQgbWFjaGluZV9rZXhlYyhzdHJ1Y3Qga2ltYWdlICppbWFnZSkNCj4gwqDCoMKgwqDCoMKgwqDC
oCAqIGFsbCBURFggcHJpdmF0ZSBwYWdlcyBuZWVkIHRvIGJlIGNvbnZlcnRlZCBiYWNrIHRvIG5v
cm1hbA0KPiDCoMKgwqDCoMKgwqDCoMKgICogYmVmb3JlIGJvb3RpbmcgdG8gdGhlIG5ldyBrZXJu
ZWwsIG90aGVyd2lzZSB0aGUgbmV3IGtlcm5lbA0KPiDCoMKgwqDCoMKgwqDCoMKgICogbWF5IGdl
dCB1bmV4cGVjdGVkIG1hY2hpbmUgY2hlY2suDQo+ICvCoMKgwqDCoMKgwqDCoCAqDQo+ICvCoMKg
wqDCoMKgwqDCoCAqIEJ1dCBza2lwIHRoaXMgd2hlbiBwcmVzZXJ2ZV9jb250ZXh0IGlzIG9uLsKg
IFRoZSBzZWNvbmQNCj4ga2VybmVsDQo+ICvCoMKgwqDCoMKgwqDCoCAqIHNob3VsZG4ndCB0b3Vj
aCB0aGUgZmlyc3Qga2VybmVsJ3MgbWVtb3J5IGFueXdheS7CoA0KPiBTa2lwcGluZw0KPiArwqDC
oMKgwqDCoMKgwqAgKiB0aGlzIGFsc28gYXZvaWRzIGtpbGxpbmcgVERYIGluIHRoZSBmaXJzdCBr
ZXJuZWwsIHdoaWNoDQo+IHdvdWxkDQo+ICvCoMKgwqDCoMKgwqDCoCAqIHJlcXVpcmUgbW9yZSBj
b21wbGljYXRlZCBoYW5kbGluZy4NCj4gwqDCoMKgwqDCoMKgwqDCoCAqLw0KPiAtwqDCoMKgwqDC
oMKgIHRkeF9yZXNldF9tZW1vcnkoKTsNCj4gLQ0KPiDCoCNpZmRlZiBDT05GSUdfS0VYRUNfSlVN
UA0KPiDCoMKgwqDCoMKgwqDCoCBpZiAoaW1hZ2UtPnByZXNlcnZlX2NvbnRleHQpDQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzYXZlX3Byb2Nlc3Nvcl9zdGF0ZSgpOw0KPiArwqDC
oMKgwqDCoMKgIGVsc2UNCj4gKyNlbHNlDQo+ICvCoMKgwqDCoMKgwqAgdGR4X3Jlc2V0X21lbW9y
eSgpOw0KPiDCoCNlbmRpZg0KPiANCj4gDQoNCk5vdCB0aGUgbW9zdCBiZWF1dGlmdWwgaWZkZWZm
ZXJ5LCBJJ2QganVzdCBkdXBsaWNhdGUgdGhlDQp0ZHhfcmVzZXRfbWVtb3J5KCkgY2FsbC4gQnV0
IG5vdCBhIHN0cm9uZyBvcGluaW9uLg0KDQo=
