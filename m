Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FC673AC7F
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 00:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjFVWbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 18:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjFVWbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 18:31:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F20195;
        Thu, 22 Jun 2023 15:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687473074; x=1719009074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QuT3nlgWRF276gcC51kRD10BziA9ICfbsw/+aaTeesU=;
  b=UWx9KTzbcCbtLoVS/3H8R+4QqW4Jls8+6mjybVpgp5HA+LxIbOQO5EsX
   m7Tp44Dw0Nwpasphq1oXXOnuKuL+RWWOjvUpl3+kGA6bD5Amy5jszE+ES
   GHCbhZQrxmXty+tWeyo/laGM43MZuErX2qAmrhG1n1yRstfypmzDo9rBD
   gqmJuMHGvEu+t6tkDiVyQE4ipMZTR0xnJY018bzMOkowap3UnBhZnK90Q
   6BWqXpQLtwqqIn8XyxNBAZSJchdJQtQLe/s3MrPOI+BxneVuaJ4NOEMVm
   7UdoyYf15hrZsJhfqmOrNsEwd3GGk3eozWaPT4sZN3IOTr7udRWBex247
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="426609075"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="426609075"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 15:31:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="859629388"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="859629388"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jun 2023 15:31:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 15:31:12 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 15:31:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 22 Jun 2023 15:31:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 22 Jun 2023 15:31:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3ImeqUv+neHGVNcrnMkGjfbwNAIVyQH58yJoG4reKcBHe4JtTPoG/de2XejMizW1VgIIT4obMiiR0ihtF7myxaVA3vFyAUCNb8hisXqTrm4VjFdVgsQGX9sAEotA5w7k1igmDJVhSAnWicu1+2PSL/acXXDQln2yvQs/bsiYWkPA/7lXyayIeHizjZIRaaxNnheI2rzf1CBoi8mGNVjTAvVYBf5M/eEVqnyJjoBpzB98OUfEdc8HkiQ8AV37wLaq66OFDi3OeuQmMmISEql6IxVi1yqQY3GZ614Uaxso6WLCrIt0ftmoMvH00rTrgKDpzeZNU/fKgtXP9cu7H/2NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuT3nlgWRF276gcC51kRD10BziA9ICfbsw/+aaTeesU=;
 b=IeA5E7bdaGRCTjnV5FZItL/+KZ03K6BX1KE/+SCDSkpouwYM7cVlxwE8INbs0ZDRGleruXRJrI9JaKf5uBWGCd5lO5GLRYk43DbmopNI0uG/+NmIrBRS0SHbgUJ6apV899Yp5xCvsFSc2Ha+h+4okQIDtCt8Da+w9w1WGQ9wrINXMQtZEZSsaEaVIJRqEdXQAsu99z97+cc1tfOJToDvIH4yWB2qjfSZQBcXxQq6E/02Sxep3zeJLHy7+M6NggFMw8FsmgiCbiEUXreGe2Q+fmMpVczCCog07mT+iLKWGNOmB4RqctZXkSHpeIr0FCphc1teUArfMsy4u9pfFleKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by MW4PR11MB7006.namprd11.prod.outlook.com (2603:10b6:303:22f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Thu, 22 Jun
 2023 22:31:08 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff%5]) with mapi id 15.20.6521.024; Thu, 22 Jun 2023
 22:31:08 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "michael.roth@amd.com" <michael.roth@amd.com>
CC:     "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "slp@redhat.com" <slp@redhat.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pgonda@google.com" <pgonda@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "Annapurve, Vishal" <vannapurve@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Thread-Topic: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Thread-Index: AQHZnOphA4hNJcIpGkeiRJNqOV8fuK+KheOAgAmr4oCAAA39gIABrsSAgAC28gCAAF41gIAAdPYA
Date:   Thu, 22 Jun 2023 22:31:08 +0000
Message-ID: <25037dfe969698dd109daee8c6dbe0d08a874a08.camel@intel.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
         <20230612042559.375660-5-michael.roth@amd.com>
         <20230614164709.GT2244082@ls.amr.corp.intel.com>
         <20230620202841.7qizls3u3kcck45g@amd.com>
         <20230620211845.GV2244082@ls.amr.corp.intel.com>
         <20230621230031.37hdnymbjzwjgbo2@amd.com>
         <c116b7ab8ca02116f2b8d19a8214161c3b30576c.camel@intel.com>
         <20230622153229.vjkrzi6rgiolstns@amd.com>
In-Reply-To: <20230622153229.vjkrzi6rgiolstns@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|MW4PR11MB7006:EE_
x-ms-office365-filtering-correlation-id: 6c74670a-248a-4d3e-11d3-08db73705fc1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: //gMJwG77N1RxilX4NuQTTxTJr/VMTfmj9rK0DTAkc0ZDz0tZhWWxZZZu/+6rrEEmmGkg5jWKOLDsqb5tgGwBR+PKwzzMmtVXEWrZC1z3WISGcoYsIpcDhj9xbR/isNB6IYXpLcwsKseQpvaf9HlfbCI2KJZpukh5BSRB5VDk4CKjskOdlWJb7luYanaNoxBMJ3Gn/1o8DePH1vm9zceLmUUDQY5Rr6l96DwAcWx8wzxWuTMybY0U3zBzwRG3x0DGaiWvAeseeKOHp3xvS9lHho99iY6qc1SR2fEeOHVWopwEyih5Pzt8YtBVHOXGvtBfuuNm3eyM6rIvaaqc8FvoiEfOsxK4CnQDZZ5XuvIYa2VPHtvSlK+as229oNOAy7RbFDehtb3OWX8fZdN12jw6FtnPcTuoOSJnGFDBkr6gNh0pOChKLphm2CU0TSSk7WHKrJQBaoyxIO3JnoyiAWpIzt0JQxdO2uiT8FG+HRb79nOqHZ2FCCjMkk+FYYcfwJBZN+FsczfcOINRqkGqoaUv7VcbglyexibmQjJ7O7633IJL61T0GHqMILmjTKyogpBt7alKW5txYh1qXs+C0sPiKkoX0zaSMZuxluX7aQfg8Z1wNZiHSNv3zLAdQNwrvce6z4y0EN0NEcrjyougP7a/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199021)(38100700002)(82960400001)(122000001)(38070700005)(36756003)(86362001)(966005)(6486002)(186003)(6506007)(26005)(8936002)(8676002)(7406005)(5660300002)(7416002)(316002)(2906002)(6512007)(66946007)(6916009)(54906003)(66446008)(66556008)(91956017)(64756008)(41300700001)(76116006)(4326008)(66476007)(71200400001)(478600001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1hmZm9kUWk3Q0ZQQzlQT2VKQkF0azkxUXprSEVLSE91VFdGUjFJdDg5MUJI?=
 =?utf-8?B?L0FTYVZGZlA1bDhvRGZCcnU1cW9KaHpaUGxaUEk1WVZxRHVxK0pKd29ZdEJR?=
 =?utf-8?B?M29WcmZWaFJzWmw4VGFhYXRzWDE2RUZLT1JvYlhuNzd1Ujh2aVUzcWprNlVZ?=
 =?utf-8?B?Sk1pcUJDNEh1dlJjNXVlNTFDaFBiaG9yMW5tV2FFRTJlQ0F2dC9GdmtaR0tJ?=
 =?utf-8?B?VGc4alZrQTRCWW8xZzM5ZFh0Qm8ydVVxOGY1M1lKQVhqZlFkdUVIZHJ2STlE?=
 =?utf-8?B?bURlQy9DU0JVbzdTQ0xibzduZWdHcXprUXlLRzBxTjNmSEV4amVXejdVNjFR?=
 =?utf-8?B?M0lDa0YvWUYzS0U1cUcyV0xkTEFOOUtEeURCZTkzQ09wNmxnMDAxMUd3dkth?=
 =?utf-8?B?blNBR2ttdFZMTnRnLzJRaFM5d3Z0UUEvV1AwUksvcG42OUxrVEJ2bWpldnJr?=
 =?utf-8?B?TEJObDRmYk5mRmxtRlk0OU94WEVNUnU5OGZkaGJvQ1lUWjBTTml6SXFiZDRN?=
 =?utf-8?B?OVlsVTVKL0dXZzVUS2lkVWlSQmt2TWdhRjIzY1FxeE1NeFE4VzVCR1g2NSs1?=
 =?utf-8?B?cmFWK2ovU2JQVFFjNVhKMDNTaTBhL1NNQW5IejhDRTk3VUhjVE9ySE1Sakps?=
 =?utf-8?B?NmVwcU5GRzRYMjNDOGtCR25ZT3A5b2pCZFB1cFd3ZVdQU1VPVXV4Y3daVUx4?=
 =?utf-8?B?aFNIbUZGTHZxdlRtdmg1VG1DWHNZVUhYVTdWT3Q2L0pxSmJqOU1ReVpjZ1pE?=
 =?utf-8?B?ajhJZE4xYlpUeVRZbHFTbGJRSytxRERYOVo0dnJrSUs5bjY1T0U4ZDZHcld4?=
 =?utf-8?B?VVJhU1RWbmZDRVRYWGpTS0JnWk1Ya0lVcE9uQ2NyZjdBWlFHMlExaE1VVkl0?=
 =?utf-8?B?Wm9LQWZIQ1pYWlNVRTdNMU50NmFCTUJ2T0dvMEZCNHFJTHdXUVQyZGpYSVFD?=
 =?utf-8?B?c0sxUzhlK3dyUmpMRzJaNU94S1hDVTJQUGZqbkNRM2tDcExkZ2JyOFBrUlpT?=
 =?utf-8?B?cVZxZ2dvbHMwdFF0MlhkalhWRTk5L0cydDZJdm9CUTl4dXNTQkt3bDRnUjhC?=
 =?utf-8?B?MjZvQXAydGVsQTFCdFpiNndZOVVQaFl4TXRmWWJpUkVCMTRpcHMrWGtZL1dU?=
 =?utf-8?B?dHJCeG9hMnZTTm51SjRpdTBlUGtCeEZnNnBPZWhCOWNkMkVWQndKZEFRUDND?=
 =?utf-8?B?bXplNmpmMUxHNmN4a3Z4KzVuTkM3ZFJMTyt2NlY5Y3IvdEx2amNRK1JtQndI?=
 =?utf-8?B?cVE4a1pIVTVzMlFva1F3RWQzWC91UTNMNVdVdlo3NlVidDQrQmlvdmpSVk9W?=
 =?utf-8?B?d2c3elBlMDFud1ZYS3VCUUxSME1FWjI1Sy9NMFJQTDJWWHllb3pNbTVkOG40?=
 =?utf-8?B?NlZNQmh1VWdaZXhseUlUOUFiSlovOGpuYXE1bFFab1VDWEp5S0t6NThHdkZi?=
 =?utf-8?B?UVBzekI5eW9INDM0VzM5dEV3c1RYK0JOb3RNd1BhK3BOVVJUUVJSaElWZXVx?=
 =?utf-8?B?MnA3dk5KTzJ6M3oxcktTRyt3UVlVUFdCa3FnVXhWaXE1WWRVc2lNZ0piSkdr?=
 =?utf-8?B?LzlKZFcyYmtOb1JFZG5KRUE3N2NEK0JweUFVaytleXRyUC9qdnMxZDJEOVhr?=
 =?utf-8?B?T1RhaUhmME5ML1VvZGsxUGc0U0FSZkJPOHMvb1ZjaGx6L2x6clRIWkJ0STBl?=
 =?utf-8?B?SjFTWElLZDFoRXl0YXZCdCsyZlgwekIyWU0wclpBZ3dhZ2FCRnlBU2JWL0N1?=
 =?utf-8?B?eTV1REFabkdCYWoxSWhYWHNUR1RFWXdiV00rdXVUM3h6T2VQamhIdjdyRzVO?=
 =?utf-8?B?Q29OVUpYYjB4d3dNeWxPQUF0WW5hTzBDMlVFYndzc24vWExsM2RJRU9HUXhx?=
 =?utf-8?B?TGhHTHFvcEhxNGxMcTZSTUE2M1UzVWdUQ2lub2NlOElBNGowT2hHOThPZjlo?=
 =?utf-8?B?VFlRVWhkd1c1UHFCNzQzOFk0eFN4QXRoanNyRUppQXFzRXIydFZHNEM2SHdU?=
 =?utf-8?B?N3J0aWxHYVFncWxRZ2dHblM2dHRkZWNUaTBScHcrSXI5bU1YNEkySkxMcWpl?=
 =?utf-8?B?WTFHVjZWQUpZM1UzZXJROXl0ZUlmUjVtMlFFZTBsSUVvQ3ZrUDF6VmZkWDBW?=
 =?utf-8?B?bldlUEtoSGdXZTBvYWVmQWUxbnR0cS9Rb0QzWVJYdndZMStJeHlMSVozQi96?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <946BF4DC42287E45BC5A8355B6E735F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c74670a-248a-4d3e-11d3-08db73705fc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2023 22:31:08.2941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35gZJFQBPwslRNHIPmITbRjuryA1rCW9I5kecA1hgLo2JL8m341aS+ywtLukKvdFaZyNXbfvfEzSOjwruIXqrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7006
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

T24gVGh1LCAyMDIzLTA2LTIyIGF0IDEwOjMyIC0wNTAwLCBNaWNoYWVsIFJvdGggd3JvdGU6DQo+
IE9uIFRodSwgSnVuIDIyLCAyMDIzIGF0IDA5OjU1OjIyQU0gKzAwMDAsIEh1YW5nLCBLYWkgd3Jv
dGU6DQo+ID4gDQo+ID4gPiANCj4gPiA+IFNvIGlmIHdlIHdlcmUgdG8gc3RyYWlnaHQtZm9yd2Fy
ZGx5IGltcGxlbWVudCB0aGF0IGJhc2VkIG9uIGhvdyBURFgNCj4gPiA+IGN1cnJlbnRseSBoYW5k
bGVzIGNoZWNraW5nIGZvciB0aGUgc2hhcmVkIGJpdCBpbiBHUEEsIHBhaXJlZCB3aXRoIGhvdw0K
PiA+ID4gU0VWLVNOUCBoYW5kbGVzIGNoZWNraW5nIGZvciBwcml2YXRlIGJpdCBpbiBmYXVsdCBm
bGFncywgaXQgd291bGQgbG9vaw0KPiA+ID4gc29tZXRoaW5nIGxpa2U6DQo+ID4gPiANCj4gPiA+
ICAgYm9vbCBrdm1fZmF1bHRfaXNfcHJpdmF0ZShrdm0sIGdwYSwgZXJyKQ0KPiA+ID4gICB7DQo+
ID4gPiAgICAgLyogU0VWLVNOUCBoYW5kbGluZyAqLw0KPiA+ID4gICAgIGlmIChrdm0tPmFyY2gu
bW11X3ByaXZhdGVfZmF1bHRfbWFzaykNCj4gPiA+ICAgICAgIHJldHVybiAhIShlcnIgJiBhcmNo
Lm1tdV9wcml2YXRlX2ZhdWx0X21hc2spOw0KPiA+ID4gDQo+ID4gPiAgICAgLyogVERYIGhhbmRs
aW5nICovDQo+ID4gPiAgICAgaWYgKGt2bS0+YXJjaC5nZm5fc2hhcmVkX21hc2spDQo+ID4gPiAg
ICAgICByZXR1cm4gISEoZ3BhICYgYXJjaC5nZm5fc2hhcmVkX21hc2spOw0KPiA+IA0KPiA+IFRo
ZSBsb2dpYyBvZiB0aGUgdHdvIGFyZSBpZGVudGljYWwuICBJIHRoaW5rIHRoZXkgbmVlZCB0byBi
ZSBjb252ZXJnZWQuDQo+IA0KPiBJIHRoaW5rIHRoZXkncmUganVzdCBkaWZmZXJlbnQgZW5vdWdo
IHRoYXQgdHJ5aW5nIHRvbyBoYXJkIHRvIGNvbnZlcmdlDQo+IHRoZW0gbWlnaHQgb2JmdXNjYXRl
IHRoaW5ncy4gSWYgdGhlIGRldGVybWluYXRpb24gZGlkbid0IGNvbWUgZnJvbSAyDQo+IGNvbXBs
ZXRlbHkgZGlmZmVyZW50IGZpZWxkcyAoZ3BhIHZzLiBmYXVsdCBmbGFncykgbWF5YmUgaXQgY291
bGQgYmUNCj4gc2ltcGxpZmllZCBhIGJpdCBtb3JlLCBidXQgaGF2ZSB3ZWxsLWRlZmluZWQgb3Bl
bi1jb2RlZCBoYW5kbGVyIHRoYXQNCj4gZ2V0cyBjYWxsZWQgb25jZSB0byBzZXQgZmF1bHQtPmlz
X3ByaXZhdGUgZHVyaW5nIGluaXRpYWwgZmF1bHQgdGltZSBzbw0KPiB0aGF0IHRoYXQgdWdsaW5l
c3MgbmV2ZXIgbmVlZHMgdG8gYmUgbG9va2VkIGF0IGFnYWluIGJ5IEtWTSBNTVUgc2VlbXMNCj4g
bGlrZSBhIGdvb2Qgd2F5IHRvIGtlZXAgdGhpbmdzIHNpbXBsZSB0aHJvdWdoIHRoZSByZXN0IG9m
IHRoZSBoYW5kbGluZy4NCg0KSSBhY3R1YWxseSBhZ3JlZSB3aXRoIHRoZSBzZWNvbmQgaGFsZiB0
aGF0IGlzIGFmdGVyICJidXQgLi4uIiwgYnV0IElJVUMgaXQNCmRvZXNuJ3QgY29uZmxpY3Qgd2l0
aCBjb252ZXJnaW5nIGFyY2gubW11X3ByaXZhdGVfZmF1bHRfbWFzayBhbmQNCmFyY2guZ2ZuX3No
YXJlZF9tYXNrIGludG8gb25lLiAgTm8/DQoNCj4gDQo+ID4gDQo+ID4gRWl0aGVyIFNFVi1TTlAg
c2hvdWxkIGNvbnZlcnQgdGhlIGVycm9yIGNvZGUgcHJpdmF0ZSBiaXQgdG8gdGhlIGdmbl9zaGFy
ZWRfbWFzaywNCj4gPiBvciBURFgncyBzaGFyZWQgYml0IHNob3VsZCBiZSBjb252ZXJ0ZWQgdG8g
c29tZSBwcml2YXRlIGVycm9yIGJpdC4NCj4gDQo+IHN0cnVjdCBrdm1fcGFnZV9mYXVsdCBzZWVt
cyB0byBiZSB0aGUgcHJlZmVycmVkIHdheSB0byBwYXNzIGFkZGl0aW9uYWwNCj4gcGFyYW1zL21l
dGFkYXRhIGFyb3VuZCwgYW5kIC5pc19wcml2YXRlIGZpZWxkIHdhcyBpbnRyb2R1Y2VkIHRvIHRy
YWNrDQo+IHRoaXMgcHJpdmF0ZS9zaGFyZWQgc3RhdGUgYXMgcGFydCBvZiBVUE0gYmFzZSBzZXJp
ZXM6DQo+IA0KPiAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMjEyMDIwNjEzNDcu
MTA3MDI0Ni05LWNoYW8ucC5wZW5nQGxpbnV4LmludGVsLmNvbS8NCg0KU3VyZS4gIEFncmVlZC4N
Cg0KPiANCj4gU28gaXQgc2VlbXMgbGlrZSB1bmVjZXNzYXJ5IGNvbXBsZXhpdHkgdG8gdHJhY2sv
ZW5jb2RlIHRoYXQgc3RhdGUgaW50bw0KPiBvdGhlciBhZGRpdGlvbmFsIHBsYWNlcyByYXRoZXIg
dGhhbiBqdXN0IGVuY2Fwc3VsYXRpbmcgaXQgYWxsIGluDQo+IGZhdWx0LT5pc19wcml2YXRlIChv
ciBzb21lIHNpbWlsYXIgZmllbGQpLCBhbmQgc3ludGhlc2l6aW5nIGFsbCB0aGlzDQo+IHBsYXRm
b3JtLXNwZWNpZmljIGhhbmRsaW5nIGludG8gYSB3ZWxsLWRlZmluZWQgdmFsdWUgdGhhdCdzIGNv
bnZleWVkDQo+IGJ5IHNvbWV0aGluZyBsaWtlIGZhdWx0LT5pc19wcml2YXRlIGluIGEgd2F5IHdo
ZXJlIEtWTSBNTVUgZG9lc24ndCBuZWVkDQo+IHRvIHdvcnJ5IGFzIG11Y2ggYWJvdXQgcGxhdGZv
cm0tc3BlY2lmaWMgc3R1ZmYgc2VlbXMgbGlrZSBhIGdvb2QgdGhpbmcsDQo+IGFuZCBpbiBsaW5l
IHdpdGggd2hhdCB0aGUgVVBNIGJhc2Ugc2VyaWVzIHdhcyB0cnlpbmcgdG8gZG8gYnkgYWRkaW5n
IHRoZQ0KPiBmYXVsdC0+aXNfcHJpdmF0ZSBmaWVsZC4NCg0KWWVzIHdlIHNob3VsZCBqdXN0IHNl
dCBmYXVsdC0+aXNfcHJpdmF0ZSBhbmQgcGFzcyB0byB0aGUgcmVzdCBvZiB0aGUgY29tbW9uIEtW
TQ0KTU1VIGNvZGUuDQoNCj4gDQo+IFNvIGFsbCBJJ20gcmVhbGx5IHByb3Bvc2luZyBpcyB0aGF0
IHdoYXRldmVyIFNOUCBhbmQgVERYIGVuZCB1cCBkb2luZw0KPiBzaG91bGQgY2VudGVyIGFyb3Vu
ZCBzZXR0aW5nIHRoYXQgZmF1bHQtPmlzX3ByaXZhdGUgZmllbGQgYW5kIGtlZXBpbmcNCj4gZXZl
cnl0aGluZyBjb250YWluZWQgdGhlcmUuwqANCj4gDQoNCkkgYWdyZWUuDQoNCj4gSWYgdGhlcmUg
YXJlIGJldHRlciB3YXlzIHRvIGhhbmRsZSAqaG93Kg0KPiB0aGF0J3MgZG9uZSBJIGRvbid0IGhh
dmUgYW55IGNvbXBsYWludHMgdGhlcmUsIGJ1dCBtb3ZpbmcvYWRkaW5nIGJpdHMNCj4gdG8gR1BB
L2Vycm9yX2ZsYWdzIGFmdGVyIGZhdWx0IHRpbWUganVzdCBzZWVtcyB1bmVjZXNzYXJ5IHRvIG1l
IHdoZW4NCj4gZmF1bHQtPmlzX3ByaXZhdGUgZmllbGQgY2FuIHNlcnZlIHRoYXQgcHVycG9zZSBq
dXN0IGFzIHdlbGwuDQoNClBlcmhhcHMgeW91IG1pc3NlZCBteSBwb2ludC4gIE15IHBvaW50IGlz
IGFyY2gubW11X3ByaXZhdGVfZmF1bHRfbWFzayBhbmQNCmFyY2guZ2ZuX3NoYXJlZF9tYXNrIHNl
ZW0gcmVkdW5kYW50IGJlY2F1c2UgdGhlIGxvZ2ljIGFyb3VuZCB0aGVtIGFyZSBleGFjdGx5DQp0
aGUgc2FtZS4gIEkgZG8gYmVsaWV2ZSB3ZSBzaG91bGQgaGF2ZSBmYXVsdC0+aXNfcHJpdmF0ZSBw
YXNzaW5nIHRvIHRoZSBjb21tb24NCk1NVSBjb2RlLg0KDQpJbiBmYWN0LCBub3cgSSBhbSB3b25k
ZXJpbmcgd2h5IHdlIG5lZWQgdG8gaGF2ZSAibW11X3ByaXZhdGVfZmF1bHRfbWFzayIgYW5kDQoi
Z2ZuX3NoYXJlZF9tYXNrIiBpbiBfY29tbW9uXyBLVk0gTU1VIGNvZGUuICBXZSBhbHJlYWR5IGhh
dmUgZW5vdWdoIG1lY2hhbmlzbSBpbg0KS1ZNIGNvbW1vbiBjb2RlOg0KDQogIDEpIGZhdWx0LT5p
c19wcml2YXRlDQogIDIpIGt2bV9tbXVfcGFnZV9yb2xlLnByaXZhdGUNCiAgMykgYW4gWGFycmF5
IHRvIHRlbGwgd2hldGhlciBhIEdGTiBpcyBwcml2YXRlIG9yIHNoYXJlZA0KDQpJIGFtIG5vdCBj
b252aW5jZWQgdGhhdCB3ZSBuZWVkIHRvIGhhdmUgIm1tdV9wcml2YXRlX2ZhdWx0X21hc2siIGFu
ZA0KImdmbl9zaGFyZWRfbWFzayIgaW4gY29tbW9uIEtWTSBNTVUgY29kZS4gIEluc3RlYWQsIHRo
ZXkgY2FuIGJlIGluIEFNRCBhbmQNCkludGVsJ3MgdmVuZG9yIGNvZGUuDQoNCk1heWJlIGl0IG1h
a2VzIHNlbnNlIHRvIGhhdmUgImdmbl9zaGFyZWRfbWFzayIgaW4gdGhlIEtWTSBjb21tb24gY29k
ZSBzbyB0aGF0DQp0aGUgZmF1bHQgaGFuZGxlciBjYW4ganVzdCBzdHJpcCBhd2F5IHRoZSAic2hh
cmVkIGJpdCIgYXQgdGhlIHZlcnkgYmVnaW5uaW5nIChhdA0KbGVhc3QgZm9yIFREWCksIGJ1dCBm
b3IgdGhlIHJlc3Qgb2YgdGhlIHRpbWUgSSB0aGluayB3ZSBzaG91bGQgYWxyZWFkeSBoYXZlDQpl
bm91Z2ggaW5mcmFzdHJ1Y3R1cmUgdG8gaGFuZGxlIHByaXZhdGUvc2hhcmVkIG1hcHBpbmcuDQoN
CkJ0dywgb25lIG1pbm9yIGlzc3VlIGlzLCBpZiBJIHJlY2FsbCBjb3JyZWN0bHksIGZvciBURFgg
dGhlIHNoYXJlZCBiaXQgbXVzdCBiZQ0KYXBwbGllZCB0byB0aGUgR0ZOIGZvciBzaGFyZWQgbWFw
cGluZyBpbiBub3JtYWwgRVBULiAgSSBndWVzcyBBTUQgZG9lc24ndCBuZWVkDQp0aGF0IGZvciBz
aGFyZWQgbWFwcGluZy4gIFNvICJnZm5fc2hhcmVkX21hc2siIG1heWJlIHVzZWZ1bCBpbiB0aGlz
IGNhc2UsIGJ1dA0Kdy9vIGl0IEkgYmVsaWV2ZSB3ZSBjYW4gYWxzbyBhY2hpZXZlIGluIGFub3Ro
ZXIgd2F5IHZpYSB2ZW5kb3IgY2FsbGJhY2suDQoNCj4gDQo+ID4gDQo+ID4gUGVyaGFwcyBjb252
ZXJ0aW5nIFNFVi1TTlAgbWFrZXMgbW9yZSBzZW5zZSBiZWNhdXNlIGlmIEkgcmVjYWxsIGNvcnJl
Y3RseSBTRVYNCj4gPiBndWVzdCBhbHNvIGhhcyBhIEMtYml0LCBjb3JyZWN0Pw0KPiANCj4gVGhh
dCdzIGNvcnJlY3QsIGJ1dCB0aGUgQy1iaXQgZG9lc24ndCBzaG93IGluIHRoZSBHUEEgdGhhdCBn
ZXRzIHBhc3NlZA0KPiB1cCB0byBLVk0gZHVyaW5nIGFuICNOUEYsIGFuZCBpbnN0ZWFkIGdldHMg
ZW5jb2RlZCBpbnRvIHRoZSBmYXVsdCdzDQo+IGVycm9yX2ZsYWdzLg0KPiANCj4gPiANCj4gPiBP
ciwgLi4uDQo+ID4gDQo+ID4gPiANCj4gPiA+ICAgICByZXR1cm4gZmFsc2U7DQo+ID4gPiAgIH0N
Cj4gPiA+IA0KPiA+ID4gICBrdm1fbW11X2RvX3BhZ2VfZmF1bHQodmNwdSwgZ3BhLCBlcnIsIC4u
LikNCj4gPiA+ICAgew0KPiA+ID4gICAgIHN0cnVjdCBrdm1fcGFnZV9mYXVsdCBmYXVsdCA9IHsN
Cj4gPiA+ICAgICAgIC4uLg0KPiA+ID4gICAgICAgLmlzX3ByaXZhdGUgPSBrdm1fZmF1bHRfaXNf
cHJpdmF0ZSh2Y3B1LT5rdm0sIGdwYSwgZXJyKQ0KPiA+IA0KPiA+IC4uLiBzaG91bGQgd2UgZG8g
c29tZXRoaW5nIGxpa2U6DQo+ID4gDQo+ID4gCS5pc19wcml2YXRlID0gc3RhdGljX2NhbGwoa3Zt
X3g4Nl9mYXVsdF9pc19wcml2YXRlKSh2Y3B1LT5rdm0sIGdwYSzCoA0KPiA+IAkJCQkJCQkgICAg
ZXJyKTsNCj4gDQo+IFdlIGFjdHVhbGx5IGhhZCBleGFjdGx5IHRoaXMgaW4gdjcgb2YgU05QIGh5
cGVydmlzb3IgcGF0Y2hlczoNCj4gDQo+ICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
Y29jby8yMDIyMTIxNDE5NDA1Ni4xNjE0OTItNy1taWNoYWVsLnJvdGhAYW1kLmNvbS9ULyNtMTc4
NDFmNWJmZGZiODM1MGQ2OWQ3OGM2ODMxZGQ4ZjNhNDc0ODYzOA0KPiANCj4gYnV0IFNlYW4gd2Fz
IGhvcGluZyB0byBhdm9pZCBhIGNhbGxiYWNrLCB3aGljaCBpcyB3aHkgd2UgZW5kZWQgdXAgdXNp
bmcNCj4gYSBiaXRtYXNrIGluIHRoaXMgdmVyc2lvbiBzaW5jZSBpdCBiYXNpY2FsbHkgYWxsIHRo
YXQgY2FsbGJhY2sgd291bGQNCj4gbmVlZCB0byBkby4gSXQncyB1bmZvcnR1bmF0ZWx5IHRoYXQg
d2UgZG9uJ3QgaGF2ZSBhIGNvbW1vbiBzY2hlbWUNCj4gYmV0d2VlbiBTTlAvVERYLCBidXQgbWF5
YmUgdGhhdCdzIHN0aWxsIHBvc3NpYmxlLCBJIGp1c3QgdGhpbmsgdGhhdA0KPiB3aGF0ZXZlciB0
aGF0IGVuZHMgdXAgYmVpbmcsIGl0IHNob3VsZCBsaXZlIGFuZCBiZSBjb250YWluZWQgaW5zaWRl
DQo+IHdoYXRldmVyIGhlbHBlciBlbmRzIHVwIHNldHRpbmcgZmF1bHQtPmlzX3ByaXZhdGUuDQoN
ClN1cmUuICBJZiB0aGUgZnVuY3Rpb24gY2FsbCBjYW4gYmUgYXZvaWRlZCBpbiBmYXVsdCBoYW5k
bGVyIHRoZW4gd2Ugc2hvdWxkLg0KDQo+IA0KPiBUaGVyZSdzIHNvbWUgb3RoZXIgYXdrd2FyZG5l
c3Mgd2l0aCBhIGNhbGxiYWNrIGFwcHJvYWNoLiBJdCBzb3J0IG9mIHRpZXMNCj4gaW50byB5b3Vy
IHF1ZXN0aW9uIGFib3V0IHNlbGZ0ZXN0cyBzbyBJJ2xsIGFkZHJlc3MgaXQgYmVsb3cuLi4NCj4g
DQo+IA0KPiA+IA0KPiA+ID8NCj4gPiANCj4gPiA+ICAgICB9Ow0KPiA+ID4gDQo+ID4gPiAgICAg
Li4uDQo+ID4gPiAgIH0NCj4gPiA+IA0KPiA+ID4gQW5kIHRoZW4gYXJjaC5tbXVfcHJpdmF0ZV9m
YXVsdF9tYXNrIGFuZCBhcmNoLmdmbl9zaGFyZWRfbWFzayB3b3VsZCBiZQ0KPiA+ID4gc2V0IHBl
ci1LVk0taW5zdGFuY2UsIGp1c3QgbGlrZSB0aGV5IGFyZSBub3cgd2l0aCBjdXJyZW50IFNOUCBh
bmQgVERYDQo+ID4gPiBwYXRjaHNldHMsIHNpbmNlIHN0dWZmIGxpa2UgS1ZNIHNlbGYtdGVzdCB3
b3VsZG4ndCBiZSBzZXR0aW5nIHRob3NlDQo+ID4gPiBtYXNrcywgc28gaXQgbWFrZXMgc2Vuc2Ug
dG8gZG8gaXQgcGVyLWluc3RhbmNlIGluIHRoYXQgcmVnYXJkLg0KPiA+ID4gDQo+ID4gPiBCdXQg
dGhhdCBzdGlsbCBnZXRzIGEgbGl0dGxlIGF3a3dhcmQgZm9yIHRoZSBLVk0gc2VsZi10ZXN0IHVz
ZS1jYXNlIHdoZXJlDQo+ID4gPiAuaXNfcHJpdmF0ZSBzaG91bGQgc29ydCBvZiBiZSBpZ25vcmVk
IGluIGZhdm9yIG9mIHdoYXRldmVyIHRoZSB4YXJyYXkNCj4gPiA+IHJlcG9ydHMgdmlhIGt2bV9t
ZW1faXNfcHJpdmF0ZSgpLsKgDQo+ID4gPiANCj4gPiANCj4gPiBJIG11c3QgaGF2ZSBtaXNzZWQg
c29tZXRoaW5nLiAgV2h5IGRvZXMgS1ZNIHNlbGYtdGVzdCBoYXZlIGltcGFjdCB0byBob3cgZG9l
cw0KPiA+IEtWTSBoYW5kbGVzIHByaXZhdGUgZmF1bHQ/IA0KPiANCj4gVGhlIHNlbGYtdGVzdHMg
SSdtIHJlZmVycmluZyB0byBoZXJlIGFyZSB0aGUgb25lcyBmcm9tIFZpc2hhbCB0aGF0IHNoaXBw
ZWQgd2l0aA0KPiB2MTAgb2YgQ2hhbydzIFVQTS9mZC1iYXNlZCBwcml2YXRlIG1lbW9yeSBzZXJp
ZXMsIGFuZCBhbHNvIGFzIHBhcnQgb2YgU2VhbidzDQo+IGdtZW0gdHJlZToNCj4gDQo+ICAgaHR0
cHM6Ly9naXRodWIuY29tL3NlYW4tamMvbGludXgvY29tbWl0L2EwZjVmOGM5MTE4MDRmNTU5MzUw
OTRhZDNhMjc3MzAxNzA0MzMwYTYNCj4gDQo+IFRoZXNlIGV4ZXJjaXNlIGdtZW0vVVBNIGhhbmRs
aW5nIHdpdGhvdXQgdGhlIG5lZWQgZm9yIGFueSBTTlAvVERYDQo+IGhhcmR3YXJlIHN1cHBvcnQu
IFRoZXkgZG8gc28gYnkgInRydXN0aW5nIiB0aGUgc2hhcmVkL3ByaXZhdGUgc3RhdGUNCj4gdGhh
dCB0aGUgVk1NIHNldHMgdmlhIEtWTV9TRVRfTUVNT1JZX0FUVFJJQlVURVMuIFNvIGlmIFZNTSBz
YXlzIGl0DQo+IHNob3VsZCBiZSBwcml2YXRlLCBLVk0gTU1VIHdpbGwgdHJlYXQgaXQgYXMgcHJp
dmF0ZSwgc28gd2UnZCBuZXZlcg0KPiBnZXQgYSBtaXNtYXRjaCwgc28gS1ZNX0VYSVRfTUVNT1JZ
X0ZBVUxUIHdpbGwgbmV2ZXIgYmUgZ2VuZXJhdGVkLg0KDQpJZiBLVk0gc3VwcG9ydHMgYSB0ZXN0
IG1vZGUsIG9yIGJ5IHJlYWRpbmcgYW5vdGhlciB0aHJlYWQsIEtWTSB3YW50cyB0byBzdXBwb3J0
DQphIHNvZnR3YXJlLWJhc2VkIEtWTV9YODZfUFJPVEVDVEVEX1ZNIGFuZCBkaXN0aW5ndWlzaCBp
dCB3aXRoIGhhcmR3YXJlLWJhc2VkDQpjb25maWRlbnRpYWwgVk1zIHN1Y2ggYXMgVERYIGFuZCBT
RVYtU05QOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzllM2U5OWY3OGZjYmQ3ZGIy
MTM2OGI1ZmUxZDkzMWZlZWI0ZGI1NjcuMTY4Njg1ODg2MS5naXQuaXNha3UueWFtYWhhdGFAaW50
ZWwuY29tL1QvI21lNjI3YmVkM2Q5YWNmNzNlYTg4MmU4YmFhNzZkZmNiMjc3NTljNDQwDQoNCnRo
ZW4gaXQncyBmaW5lIHRvIGhhbmRsZSBpdCB3aGVuIHNldHRpbmcgdXAgZmF1bHQtPmlzX3ByaXZh
dGUuICBCdXQgbXkgcG9pbnQgaXMNCktWTSBzZWxmLXRlc3QgaXRzZWxmIHNob3VsZCBub3QgaW1w
YWN0IGhvdyBkb2VzIEtWTSBpbXBsZW1lbnQgZmF1bHQgaGFuZGxlciAtLQ0KaXQgaXMgS1ZNIGl0
c2VsZiB3YW50cyB0byBzdXBwb3J0IGFkZGl0aW9uYWwgc29mdHdhcmUtYmFzZWQgdGhpbmdzLg0K
DQpbLi4uXQ0KDQooVGhhbmtzIGZvciBleHBsYWluaW5nIGFkZGl0aW9uYWwgYmFja2dyb3VuZCku
DQo=
