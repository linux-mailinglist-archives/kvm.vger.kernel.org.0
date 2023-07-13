Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB3751EE1
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbjGMKcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjGMKco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:32:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBAA170E;
        Thu, 13 Jul 2023 03:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689244361; x=1720780361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8l/h+8QUxlcL0UIVVjS+lEO75QPYUDsqMUDw92CkrvY=;
  b=Gun6Sc7IDxHHcn04YU+Eq+V4AQaAEXSPLAFrp8b/Ks5stZsNQtkH95Sc
   1Xk0y4/6LFDVCn/utnIGIjliL2Qlie6gUrVryBR5qmMJG9SGToF9Y+HUE
   Oifp1qv18zu7cIs7yxeLiFoL0iio3OconiYUz92UI48InBN+OHac6S99/
   hhkUxceXL9bQ71CQspF4iXTSsPtDEZVRg5b+Ycej4SHKp0X/Wu7vsp6vP
   zjTd/O03q+GHGDWXUwk4uuEJgQPSa703v8dcOPDF1U2IOlbkXoLvbqlA2
   5LDzI0uCoNC8DSJDMuaZR+GGxaOQ6IJtiwCOaATebxlcT/9UqdAinRO77
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="345462691"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="345462691"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 03:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="1052567174"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="1052567174"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jul 2023 03:32:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 03:32:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 03:32:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 03:32:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 03:32:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYgljPfkKdnqmpo0KFu1n5KvZRba6oPw+yOLP6OO00qGttgr+zXpYuo3i2YUl/sdYv8orJyjfmOb4WCN3HW8TbbdhbVitzivrnGcUihZbt/na7bqajdkRl66uu+EGiq+qN47a0KhVY18wMA5wkP0YMkwlVNrlcSS8cNvHyuuHaLCCzdDq10vAcsxC0fILw5FgAMivX8Lax30JKhQ6GyenfcLifoLocmRz7Gl56nDTYwg6RKfgzgC1kj/YFlXfri/CXtUEhbqqpgVqss/Dz4b8y7ha/Um3x1qXpfCKQazQcvNLgMbQK30roVzTAcLXWCplLmBYjOz7z+j2NTjoOMhqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8l/h+8QUxlcL0UIVVjS+lEO75QPYUDsqMUDw92CkrvY=;
 b=G2WNgk3CqxYv1spZULRYjPKnqGfkSzxMqXe8Z8zpVCe/3LZRMPUc9HEaG6zNCzrxT+rbWFNK71w/xYDLzEgmwlN5Y2/s8pFi5uSWcDUhiHx3n4FraEmPdzqAPvlgVg2Opr06SNkoH5DqltI7B4/LYY+qHdrPp1v8PXvwuZcqPgvb0dt+I/w9IBAefE4xoigJHOZHTzog4qv1z9yEUFT4IS3JTkEhBzjrcCAMslpEDy4OjDKqQP6s5IP0u+ejp8JDgCqhVCS8arAh3UmUzg0mHYYpYDOKp3WK2wXJDbNSRvhq8OaIQGd9oCIxrlcA7sUtbV7xmG0qOLpLWV0SDq6ugg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6823.namprd11.prod.outlook.com (2603:10b6:806:2b0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Thu, 13 Jul
 2023 10:32:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 10:32:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 02/10] x86/tdx: Use cmovc to save a label in
 TDX_MODULE_CALL asm
Thread-Topic: [PATCH 02/10] x86/tdx: Use cmovc to save a label in
 TDX_MODULE_CALL asm
Thread-Index: AQHZtJ1r9uVWTV35hEypuTvpevWvWa+2hIMAgAD86QA=
Date:   Thu, 13 Jul 2023 10:32:33 +0000
Message-ID: <5bfbb56bcff79c4a552e33121df0c55ad6388033.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <70784afc0a42d4dc1b1e743f90d89f7728496add.1689151537.git.kai.huang@intel.com>
         <400c0d11-fa14-cb1c-f6ed-02f850753e46@linux.intel.com>
In-Reply-To: <400c0d11-fa14-cb1c-f6ed-02f850753e46@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6823:EE_
x-ms-office365-filtering-correlation-id: 6d270ad6-71f2-4d5b-4c36-08db838c781b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8k3WAWU9LqsG41yZ992aZmCtiF6cfCKrIkz4SF83lFXO5QgshQDOTaxXRci9pHa5YfNXVCYHfKyV2luhsMFYilkuKap50oBTj2UPv6obbaKaZ3aA8bX/uH2MNSkJ1CpFJ8igGUTShQYoOiXsMb/4Y66eNU4Jv0ejKaUau33USPBZBWxljr4eNq8WZieleExYmR74Jpg1HmgZjOsL0IQ21Vi14BG99cMbjd01ddwn7W5dfgOUrH0F1XgGneC9c7GqQy8Rjf3OtIZtClNnsJaf2IVK30f/nIlYsnC8w8n8o9lWRHOoN/Z4XrVl7IA30L+osns17nRn0CvnaaABGxhWwGffoytuMd5HMBWxdJAInFZR3PR43/koV/DFJeuk83CWbabKn4dmBG/Cfm6NjoFcaxDC6toPJJWuz2FviBeP8yOeLlHH/t20K3N61+N8p5OClvqNHAhR4N3HFt/g/JeWaNUFJCwJFfCN4kCTn9T+iA2ofHYf30BekOne/vGh5UKRdsmzSd8mEJ6+CBKszt3ijB1AIakYVE7dF3njzEqbdSsszkbdM2Z5PkgPQwZqbSIS2yViymY7YYqd/iawK0KQdX3Zh3IRYJdRucr1RVhTFoN3av5WD/fP9+ygtoAPmNIu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199021)(316002)(91956017)(122000001)(53546011)(26005)(6506007)(41300700001)(186003)(478600001)(38100700002)(66446008)(82960400001)(66556008)(4326008)(71200400001)(110136005)(54906003)(66946007)(64756008)(76116006)(66476007)(6512007)(6486002)(2616005)(86362001)(8936002)(5660300002)(38070700005)(4744005)(2906002)(36756003)(8676002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGlia0ZnMkF0ZXdPK3F4TFdlL3czbVRIYkpsUlZyd3dvb25VMWNhYnphQVhv?=
 =?utf-8?B?QmNxam1GTUFndkZvNkl3NHB3ZWlwQ1NkdmlWa1l4MnpiRG1lM0Q2YUo0dGdS?=
 =?utf-8?B?TXdTRDltTHFSZlNmVGV6Umh2a1doVStBMTI4VU9yV3RVbSszeG9kek1XSFVu?=
 =?utf-8?B?TUo3MkE3SXRiMFBFWDc5aWxDN1BZeXY0dSttTmNPeHE2S0VCTEVyMmwzTmdR?=
 =?utf-8?B?c1Z2dkhXSWYxSVNTcGNWZGNHaEdzRGZDaEZLbnJWU3BHMzRzVnpLaGpuNk1L?=
 =?utf-8?B?T2hoMGhmMkZXbDBoODBxMUVYOHppVC94SVd3MGtGd09FeEg2QXhsZisxSlh0?=
 =?utf-8?B?cTBFRWRHcDhxL3I4TUZkKzNwb1BjaE1RQkx4NkxudGlkakIxT1ZrbjVHRmFm?=
 =?utf-8?B?RS9LeW80YzVvTXMxU05zUE5MNWdnY3MzaEZKeGsrUDVSSHFDeG5ldG5wdGVM?=
 =?utf-8?B?WFlaT2V1UkczV3htbFZ1QTZqYjZxV1lBMVlsM2UrYlNKYjRWNENSWGtRWDMr?=
 =?utf-8?B?S1JZMVR3d3lkVHRKTmNmMll2RDA0SkhXOWNCblc1elMzZWlyeDY3UU84N0tu?=
 =?utf-8?B?eVlidU5Ia3hOeTE5clRlemxHbXdYTCtLOUdNWHNPQTBPdEJZNEo3TVd6RUVP?=
 =?utf-8?B?T2FGWVZmSFhzam95dVlpWHZsdkYyUUt5Q29lRWdkWjlrZURvWHc3Q2pTU1oy?=
 =?utf-8?B?czVES1Arc3JxYTdoNXlPR3VwR1MrRThRdUxyK3VhK09QVzBCekFkSjE0Z2Fv?=
 =?utf-8?B?N25GUGltTm1EQVlhVzJTblRmMFlHWnhQMEcwSWdPdmI2VjhnWlovVWs0VVNV?=
 =?utf-8?B?OUpkckFvK0RhUVhMTW9xWXQzMFJHdk5Cdmh5Q3czSFA0VDZ0UkJqa2ZQbzZX?=
 =?utf-8?B?dFpjb2U2WmtWSDFGVEFsRHYvSHRJdlRUelpGT2pzdG9HQ05CckZ5eHBFVnVQ?=
 =?utf-8?B?dUI3RHZjemVlVW1TbW5RZ3VTNnl5L1pFL3Iwa09Cc2RMejF3blRiSXMvVjFZ?=
 =?utf-8?B?QnRYT1lpbkhUcnpRM2x0UXROVlBXVUpkNmYyekZrTWFQQTBOSWJ2akJFbXhK?=
 =?utf-8?B?cEY0d0pScDV2SnhpVGFaaXZDK0hTYnZ0cVFVM2dLYnNjUnVmUmRYTW4rRy9F?=
 =?utf-8?B?eWFLK2VvL2N1amtiRDZoa0FhblBTellPekZOTmEzdU5qRTYyTTlUdVZ0SVBP?=
 =?utf-8?B?WWIxUmt0amZUN0h2ZS9PYzVlbjFERFRJSDdCUGpITkhrMzZPYmRZUC9iV1N1?=
 =?utf-8?B?RUhzRUgxTTQrVXRCSXUvRStCemFKK0lrOGZFZlBid3dsTTZ4YUVwbVFPNUFo?=
 =?utf-8?B?ZktzcjBZMXRLSkcxK21DL2REa1F4RExJY1lwdDUwcXY4OUdtdWVxSFlKY3I5?=
 =?utf-8?B?MUtKQlJtU1d4L2I2UVFsVXo1dkRCV2JuSXI3dS9YeE1mZ21WK21CZkJvT1dp?=
 =?utf-8?B?ZVZpOVduTmJpTm1wZ1ZnTStrQ05vVDcwb1BpVHNVN3k0N0JrMkFnelRPUUc5?=
 =?utf-8?B?T1JGUi9za3dubGlmemdtZ0ZadytUZTBYYnJMZlErRnFHUWo0SlJ5ektMMFFM?=
 =?utf-8?B?YTFDU1NMMHBmMitmOVA2eGc0SnNsNUZWd2xqbW51clNWcmZ4T1JmTGoxOTR0?=
 =?utf-8?B?UE9yWUY4YVR1dHlpVm9LUHFwWmI3dmVSYk9pVFVVNjViaUN1OVZRMzJmekN1?=
 =?utf-8?B?NHQycDRqMzh5OGhXRU5qL3ordXZKTjdicU05QVR6M0phbmRibGUrSm9ka2JO?=
 =?utf-8?B?Z1JoS1AwaVRXSXlRZ1d1dkl0cmoxUDVZUlFtNkg1ZTl4ZzFWaDZBRVYyVHlR?=
 =?utf-8?B?TVJRRVY0VEQ2QTg1TzZudjlQWW5kbmdlR1cxQWFwMTAvcUdBaWVma2dRd3Nr?=
 =?utf-8?B?aVd3aVM5RHdRMFk1VTBwSVJsekplVkpPSkErUExvdHRCbGhxRlBFSUlQcFpl?=
 =?utf-8?B?VnREaDlReERsQ2dwUjNlL2FmVWRaWjBjYmxDanFxSEJkRndGVGRRaGoxQnhp?=
 =?utf-8?B?elkwWXVudmJFTGdIdUZXMnh6UkJuMFpCUFZKVUE2ZnBKVG9FdjBiYzhOS3JQ?=
 =?utf-8?B?L0ZhNVoyMHc0K1ZIOVdlNGo0TEVHa05KUDBLR1BsWTlVVmZKMnRFRFNpL3lV?=
 =?utf-8?B?Sjk5UUlXRG5vQWIrU3M5VnM3Y1pCWjJlWnoxSnRXUUhPaDUya2VrRmg2ejZy?=
 =?utf-8?B?NGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7ACA289AEB810459EC9026CCD8B7319@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d270ad6-71f2-4d5b-4c36-08db838c781b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 10:32:33.6555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sElN6g8hDmCjWOY7laLirrzqhk7+UAD4RUieeIGpRoMD0/wvhMJj/8qRTvVGEFt8qtA/cH2Pot/XQbofj0QuPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6823
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

T24gV2VkLCAyMDIzLTA3LTEyIGF0IDEyOjI3IC0wNzAwLCBTYXRoeWFuYXJheWFuYW4gS3VwcHVz
d2FteSB3cm90ZToNCj4gDQo+IE9uIDcvMTIvMjMgMTo1NSBBTSwgS2FpIEh1YW5nIHdyb3RlOg0K
PiA+IENoYW5nZSAnam5jIC5Mbm9fdm1mYWlsaW52YWxpZCcgdG8gJ2Ntb3ZjICVyZGksICVyYXgn
IHRvIHNhdmUgdGhlDQo+ID4gLkxub192bWZhaWxpbnZhbGlkIGxhYmVsIGluIHRoZSBURFhfTU9E
VUxFX0NBTEwgYXNtIG1hY3JvLg0KPiANCj4gWW91IGFyZSByZW1vdmluZyB0aGUgbGFiZWwsIHJp
Z2h0PyBXaGF0IHVzZSAic2F2ZSI/DQogDQpQZXIgY29tbWVudHMgdG8gcGF0Y2ggMTAgSSdsbCBk
cm9wIHRoaXMgcGF0Y2gsIHNvIGRvZXNuJ3QgbWF0dGVyIGFueW1vcmUuDQoNCg==
