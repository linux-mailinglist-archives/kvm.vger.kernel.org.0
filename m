Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7417B751CF9
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbjGMJQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjGMJPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:15:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681E61980;
        Thu, 13 Jul 2023 02:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689239754; x=1720775754;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qkQ7TuoTK4ThHmeSD0FD4xK40+a/92Of7fiDqaiByQQ=;
  b=HJSu5t5CgYB31VbuJXQMv7XxlUhXkE+CFE3KkT9387526ELpgdPygGxS
   I9VheD9terXSqNjpEFlLhHU9V57hXwbk2ZDUA4/aNfqsarklZarNrRFS9
   y6wKUlwTlIFmXDtL6uByzPGBbt7+mIWI2ZNbnRYHP7ke3i1+rXUNRPTIW
   7ZAAJQMGyzJLtn0KWlfIr06o34oFlDV43iPpzAEYkn6L9Tz6TIdkAvbKz
   03w3IO7Y9RCnPvFUlRgBl15POV4Z9xlmO/4vP9EIfKajqDMhvJwfvP3GH
   z0FbNHDrlqlv32ZQJ6siya+OwiJUB/+UNsmKgMt/JJPW5UcipGywbHEjD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="345448251"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="345448251"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 02:15:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="672201867"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="672201867"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 13 Jul 2023 02:15:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 02:15:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 02:15:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 02:15:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 02:15:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxRZnTlHbJIfXv7WMxLaB606G3Gpjw23qgsjJLwfagCUcgLMlQEzDTLcewYdG3SsG53mvpKnrlJILPioT5vs5uwRX78bBU6azfijq4HSejQ4/ipXU098b9t5S3+bCGjvThhF8M/R95cwcLUwIiCUqNKKQ2YI+mEToowoTMS22oTtK1mBDWOL0IlM60ZI+EuUhPeTEiXuX4gQTe0UYs8/Y+nHhiEsKfZNGSz2otdN8wVj/OZhu21PRYnJCYjKjSuw0zM2rIqRYyO/wjETULGWc2qWiWLqIYl5+T0rGvnxbAHhAKK5g72DhOlB8BwZ65xTK75ql8QaPO/vC4eVZqFajw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkQ7TuoTK4ThHmeSD0FD4xK40+a/92Of7fiDqaiByQQ=;
 b=nu6HSEaQtTLsWmcO1xuBYPbZqduhWlXLummIaCKpTR9x+kynxnCjw7EbJ2JuqxIf6pQ/X7kpKPNZMd0hWDusT4xu4ILh506sBBGWIF0BwYCwpbIxxvxDPz5uP1lDqqGNqNHJmcbuLjz6yBZJyjAmyEm8QGg/6VDRE4pcFhXnoM3TSgdac6MyS0IR6qXJjemb2TqeRTDFAcOOhSvEeLqawr03LyjxD6Tbpja9aAs8E8rZmcMO5KZSdQX6/ZTlfHzA3E9eYSGeJv2k8q/xFzf9lEI/bT5QDKkISpVarY52kLcmkQ2oi4Zi9opoViRX8jjmZfH+a/4bUQJuUh2Nr+g+fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6198.namprd11.prod.outlook.com (2603:10b6:8:9a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.22; Thu, 13 Jul
 2023 09:15:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 09:15:49 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Topic: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2XpWAgAD65ICAAA5uAIAABBWA
Date:   Thu, 13 Jul 2023 09:15:49 +0000
Message-ID: <4e542a29ba6083981c13c43d0c5e69d24f42f812.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712171133.GB3115257@hirez.programming.kicks-ass.net>
         <a36d1f0068154a9acd3fdbed2586dc5b2476e140.camel@intel.com>
         <20230713090110.GC3138667@hirez.programming.kicks-ass.net>
In-Reply-To: <20230713090110.GC3138667@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6198:EE_
x-ms-office365-filtering-correlation-id: 83eb31c4-e43d-4053-2d60-08db8381bfd6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BR3lQ5DxqZLQn/DH0Rqra223Dtx9cSl79LZXQpoj5BZAhgMbUrWyJSw8SfIJ8WBsO0z/KspCVDb8K1aimhyJD90n4rXMejfg0QmVPmUZRVyzZlb9EvuUH3G+ESQdSehz5102ftT5RpV3qeQiJ/9x8OHleuccWsVCUgFJjwIXx30xf+CB9TvarDLojfpwYtu+Wm4oRCysC/wfgZoYRMw6mWTHuhbsA3QubuQ6gxWCX+dhshYNvGmIM1F1AfrrfzG1TidXV/YumE7gNLbXcEbffkjNJTr2AtPKXrKCQnY4kZgW+9nx0Y1nA3BPSPDgCAlzhV1nZLxJKTnHdLR4IiBBj7RbQ6O+Pjnr3s6dPT7s/S/jhWwRBuEXbajPuUmanNr1apIBnNHJ/DwGKBhpDt8VsECkhlgTicRmxDD+DR91iZgQZC26c1o094tYj6GCDXdzt0q3JrhFWAjokCm/EPQCsaR7Y9sjPF4jSRdR1/aPRaoTvnhz19Ttk/SS8GEdkcPU9D0rvLnsK673kkN1QK6x8OByHqy6a/wI3sM34yhJsAYNvA41yKXmRfz037rYkD1Dkb79SFxS4y914bEfQT1OeD0dPcWibP88MK6qS4glDIv4Ytv8dbzPX4xnyCPHwWJ6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199021)(41300700001)(6486002)(122000001)(38100700002)(82960400001)(71200400001)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(86362001)(54906003)(478600001)(38070700005)(2906002)(316002)(91956017)(6916009)(76116006)(66556008)(36756003)(64756008)(66946007)(66446008)(4326008)(66476007)(5660300002)(7416002)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjMzR1duK1hWcnFPRk1rSWdRUFlDWHJEdHl0MVdyRncwQlhiYmdMRlpqWHgx?=
 =?utf-8?B?aGtIRDZYUm1Kb0JuUnZIbUFOVFBDbjg5cmxNV0xKZXhCMUpaU3RyMVJTZWhT?=
 =?utf-8?B?am0rbXpUeFZYc1FFTU8yTVZOT1BBRy9tUDNFc0ZuVFd3anJJWkI0bkpVYmtn?=
 =?utf-8?B?ZHkyekRVaXJOczBhU0kyV2s4Z2QrSk5RcXdPZW5qMGEyM0xFNUtKY2t3cEJq?=
 =?utf-8?B?UndVdnhjNFBjU0JMSUM2eUc3UmpJYVFoR3hiRFNmMnJPL2xkTHRETUhyRHhI?=
 =?utf-8?B?Wmhpc2w0ZEJDRGp0UmZIUHB0RGQvd3MrV2xOSCtreVJvNkhBZ2s5cExIcmJa?=
 =?utf-8?B?NWFmZTk4cFZ2NXpHdmlPU2RQZlZ4aGFpYjByUmw1Y1hXaWphaHB4eVR4Kzhh?=
 =?utf-8?B?d0ZsZVUya2dIZUZHc2lJaW5VUU54TVliUzRsUWtvMzMyOUNRMy9pbDVER3RO?=
 =?utf-8?B?dmhNSUhlOUU2blY2Y04vcFhUVDIzVUtINDNBNHlvS2tvVzZFOXJra25QU2dK?=
 =?utf-8?B?aEs4OGVZTS9aaS8wd0EzOEdTNDg2OTlhTVZkb0syK0wrRkhEeGttdjJPUDc2?=
 =?utf-8?B?cDRWMlQvR2FiSFJuY2l0RWVPZEZMYndveHFhTU82UVhGc1pUNHp4MkNLRERE?=
 =?utf-8?B?dnp1N3d4dU1wSVRNdDdPZm9JQ3Y2WGJacVFBMTVqVnNNN0ZsS0xZcnd3Vjhn?=
 =?utf-8?B?dXZOT2UybGRnOTJGV3prRXcrTU84QlNZSzJQcEViV1Vab2lFWFREYW5WbTF2?=
 =?utf-8?B?d3Q4UTRTazIrQVdUMk1jU0RlR0taZkhsV2N1cFhHdDRkY1NVUDBpS0YreVBr?=
 =?utf-8?B?MHdGVVBOdzNENmhONHJGRTFOSnhBYTJQV3JCNlVJQnNzMlBUOGZ6UHhHYUk2?=
 =?utf-8?B?VlFDK3NpMnExRm04N01SRHNEQStnNnhSajUyRG5JSFd4cldDOFEyVGdwVzhW?=
 =?utf-8?B?cnh3TlM5RGdvSDRhZEVGN0hKL0dpMnZJakFtKytNbGltQTk1eDFnZFA3eEVD?=
 =?utf-8?B?T2FUUWowNTc4bEZzVDZmYiszVVQyOVRmZlljWThyL0lqeXlldUt6eWZCSXZj?=
 =?utf-8?B?QzlqbzBFMG1EeXlJekNRSzQxbmtRRFAyMUMyMkc4Zk1Xc0F2amx0OEh0NFJs?=
 =?utf-8?B?SS9lSlB5SmNCcVVPQnIxVDFUV29RdTNRVDQxSFVBdmdkSmFQc0JFMkxnTTNT?=
 =?utf-8?B?RGphVW5zVXVtck9TL25WeURwSTdBMjlFZ3RkZjNIbGd5UkxtZ3dSUzZRR1FC?=
 =?utf-8?B?cTIwamdBc0t3MU9wejVOdW5BUXdmYlN2UGpKbEsrMC9hbzVvVlpycVZIcW5U?=
 =?utf-8?B?cXJnaWpEazNzTG1JMTU2QTdVMTVEME5RMWxkWkgrQys4Y3N0NEMzYjRzNjBj?=
 =?utf-8?B?RWxrZzBWQXBmUmFPTHNES3U5eDFicVFpa1NRSzlURDZKY1Job1ZxY3E3NGlq?=
 =?utf-8?B?ektEMVF3ZWRQc0pVL3VLeDlrTCt4M1NiZVg4a0I4TWJldGI5SzJhWnd4bGNU?=
 =?utf-8?B?a3BUc05TR29OVzFZRzI4Z3IyTUxHL055UDQxbHVGSnhkNC9Xd1lHSkFiZndH?=
 =?utf-8?B?NFAvT3BNNjU3aHkrQ2NDYVlxL001OTRQbUdFTWswWlNVSFg2UG9TVTlZSE5C?=
 =?utf-8?B?c0dCaDFWby9Hdm5CbUhCVjFsem9nSWxNNGIxa1hGUzFEYk0wVEdQZnJRU0FT?=
 =?utf-8?B?TUlQbFJLUFZWcGRQakpjSjNkK1EwUHplbU1venJkenlmMksvaWQrSlhxZWhN?=
 =?utf-8?B?b3FyZUI2cHF5S0tETlJBUXArdGt0OVNiaWl2eElPVFN2V2ppZVByelM3VVIx?=
 =?utf-8?B?Z0NhZmlVeWZmL0hhRHkyN3RmMTFKbDlPMnBIUWtROUFreWl1NmxpK21HY2Rn?=
 =?utf-8?B?TDRtS1lwWTRzOG1nV2ZmSU5TcXlvcXQ4MldneHRURXZSY3pWQVZpNHRYekYx?=
 =?utf-8?B?anhZNGNwWEVQSHlOKzN4TkZnZEM5ZGI1Zk1MenNlMXR5THhYY1JmNUJWUjJI?=
 =?utf-8?B?MTBUQXQ3RzEvUkhET0g4VWFORWZtaGIzM2Rha3AvSEJMbE9nSXFOTHNwOUdG?=
 =?utf-8?B?eXM4VHhiRmh2U0RGeUtNanpCeTc1aGNlMW4rdVMvdktmK2EvMlZVd21RL3Zr?=
 =?utf-8?B?azF4VisvdTlJOG1pYzFPZ1FhRXRjcmQ5L2dqajIvdEhlZjd6YmVDaGRENitQ?=
 =?utf-8?B?U2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BF2B2E6E3F53C47AA573567B1DC571B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83eb31c4-e43d-4053-2d60-08db8381bfd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 09:15:49.5010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sfp3otLcTWWT/e2IACqm4CNPNq+it3ELoD2riVOh2Yb+tAVjOwN5I4uuyTjLdiXg3NafO6THDchH30h+1xalwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6198
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDExOjAxICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDg6MDk6MzNBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBXZWQsIDIwMjMtMDctMTIgYXQgMTk6MTEgKzAyMDAsIFBldGVyIFppamxz
dHJhIHdyb3RlOg0KPiA+ID4gT24gV2VkLCBKdWwgMTIsIDIwMjMgYXQgMDg6NTU6MjFQTSArMTIw
MCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiBAQCAtNjUsNiArMTA0LDM3IEBADQo+ID4gPiA+
ICAJLmVuZGlmDQo+ID4gPiA+ICANCj4gPiA+ID4gIAkuaWYgXHJldA0KPiA+ID4gPiArCS5pZiBc
c2F2ZWQNCj4gPiA+ID4gKwkvKg0KPiA+ID4gPiArCSAqIFJlc3RvcmUgdGhlIHN0cnVjdHVyZSBm
cm9tIHN0YWNrIHRvIHNhdmVkIHRoZSBvdXRwdXQgcmVnaXN0ZXJzDQo+ID4gPiA+ICsJICoNCj4g
PiA+ID4gKwkgKiBJbiBjYXNlIG9mIFZQLkVOVEVSIHJldHVybnMgZHVlIHRvIFREVk1DQUxMLCBh
bGwgcmVnaXN0ZXJzIGFyZQ0KPiA+ID4gPiArCSAqIHZhbGlkIHRodXMgbm8gcmVnaXN0ZXIgY2Fu
IGJlIHVzZWQgYXMgc3BhcmUgdG8gcmVzdG9yZSB0aGUNCj4gPiA+ID4gKwkgKiBzdHJ1Y3R1cmUg
ZnJvbSB0aGUgc3RhY2sgKHNlZSAiVERILlZQLkVOVEVSIE91dHB1dCBPcGVyYW5kcw0KPiA+ID4g
PiArCSAqIERlZmluaXRpb24gb24gVERDQUxMKFRERy5WUC5WTUNBTEwpIEZvbGxvd2luZyBhIFRE
IEVudHJ5IikuDQo+ID4gPiA+ICsJICogRm9yIHRoaXMgY2FzZSwgbmVlZCB0byBtYWtlIG9uZSBy
ZWdpc3RlciBhcyBzcGFyZSBieSBzYXZpbmcgaXQNCj4gPiA+ID4gKwkgKiB0byB0aGUgc3RhY2sg
YW5kIHRoZW4gbWFudWFsbHkgbG9hZCB0aGUgc3RydWN0dXJlIHBvaW50ZXIgdG8NCj4gPiA+ID4g
KwkgKiB0aGUgc3BhcmUgcmVnaXN0ZXIuDQo+ID4gPiA+ICsJICoNCj4gPiA+ID4gKwkgKiBOb3Rl
IGZvciBvdGhlciBURENBTExzL1NFQU1DQUxMcyB0aGVyZSBhcmUgc3BhcmUgcmVnaXN0ZXJzDQo+
ID4gPiA+ICsJICogdGh1cyBubyBuZWVkIGZvciBzdWNoIGhhY2sgYnV0IGp1c3QgdXNlIHRoaXMg
Zm9yIGFsbCBmb3Igbm93Lg0KPiA+ID4gPiArCSAqLw0KPiA+ID4gPiArCXB1c2hxCSVyYXgJCS8q
IHNhdmUgdGhlIFREQ0FMTC9TRUFNQ0FMTCByZXR1cm4gY29kZSAqLw0KPiA+ID4gPiArCW1vdnEJ
OCglcnNwKSwgJXJheAkvKiByZXN0b3JlIHRoZSBzdHJ1Y3R1cmUgcG9pbnRlciAqLw0KPiA+ID4g
PiArCW1vdnEJJXJzaSwgVERYX01PRFVMRV9yc2koJXJheCkJLyogc2F2ZSAlcnNpICovDQo+ID4g
PiA+ICsJbW92cQklcmF4LCAlcnNpCS8qIHVzZSAlcnNpIGFzIHN0cnVjdHVyZSBwb2ludGVyICov
DQo+ID4gPiA+ICsJcG9wcQklcmF4CQkvKiByZXN0b3JlIHRoZSByZXR1cm4gY29kZSAqLw0KPiA+
ID4gPiArCXBvcHEJJXJzaQkJLyogcG9wIHRoZSBzdHJ1Y3R1cmUgcG9pbnRlciAqLw0KPiA+ID4g
DQo+ID4gPiBVcmdnaGguLi4gQXQgbGVhc3QgZm9yIHRoZSBcaG9zdCBjYXNlIHlvdSBjYW4gc2lt
cGx5IHBvcCAlcnNpLCBubz8NCj4gPiA+IFZQLkVOVEVSIHJldHVybnMgd2l0aCAwIHRoZXJlIElJ
UkMuDQo+ID4gDQo+ID4gTm8gVlAuRU5URVIgZG9lc24ndCByZXR1cm4gMCBmb3IgUkFYLiAgRmly
c3RseSwgVlAuRU5URVIgY2FuIHJldHVybiBmb3IgbWFueQ0KPiANCj4gTm8sIGJ1dCBpdCAqZG9l
cyogcmV0dXJuIDAgZm9yOiBSQlgsUlNJLFJESSxSMTAtUjE1Lg0KPiANCj4gU28gZm9yIFxob3N0
IHlvdSBjYW4gc2ltcGx5IGRvOg0KPiANCj4gCXBvcAklcnNpDQo+IAltb3YJJDAsIFREWF9NT0RV
TEVfcnNpKCVyc2kpDQo+IA0KPiBhbmQgY2FsbCBpdCBhIGRheS4NCg0KVGhpcyBpc24ndCB0cnVl
IGZvciB0aGUgY2FzZSB0aGF0IFZQLkVOVEVSIHJldHVybnMgZHVlIHRvIGEgVERWTUNBTEwuICBJ
biB0aGF0DQpjYXNlIFJDWCBjb250YWlucyB0aGUgYml0bWFwIG9mIHNoYXJlZCByZWdpc3RlcnMs
IGFuZCBSQlgvUkRYL1JESS9SU0kvUjgtUjE1DQpjb250YWlucyBndWVzdCB2YWx1ZSBpZiB0aGUg
Y29ycmVzcG9uZGluZyBiaXQgaXMgc2V0IGluIFJDWCAoUkJQIHdpbGwgYmUNCmV4Y2x1ZGVkIGJ5
IHVwZGF0aW5nIHRoZSBzcGVjIEkgYXNzdW1lKS4NCg0KT3IgYXJlIHlvdSBzdWdnZXN0aW5nIHdl
IG5lZWQgdG8gZGVjb2RlIFJBWCB0byBkZWNpZGUgd2hldGhlciB0aGUgVlAuRU5URVINCnJldHVy
biBpcyBkdWUgdG8gVERWTUNBTEwgdnMgb3RoZXIgcmVhc29ucywgYW5kIGFjdCBkaWZmZXJlbnRs
eT8NCg0K
