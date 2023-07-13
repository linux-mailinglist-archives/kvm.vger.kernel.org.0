Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC71751EBD
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbjGMKT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjGMKT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:19:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13240136;
        Thu, 13 Jul 2023 03:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689243595; x=1720779595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iSrwYVxM/F2ZNpy1tSv2CO9eNe8L+5Hm22Y+KlY1ZqQ=;
  b=g6hS79A+lCyFOYT4lDL26DxsILL76WISjYaM6gGKBZDxF3Cru+1Xgf9v
   tncO65IPpkMnoVg8nRH35Jd5+Y6loslMjXXUH/82UvdMXuFAXynOhgWba
   CRBUfkIKAhkVy2v4nn0HQ6Tcs6ANEVPG6R35PpVnbwe3plMSAf5LB4efb
   6F6XTiM19+FzBKvRNz3UygLw5wBH6ROxXKkP/b2vTE/6nLUYRxfze+JEx
   C94t+NAMZ9MTajhkF2PT1cBb94nQyMb49cWgrPyvJWiVuAP9vAUuZTmjs
   Xx8ravPoaxmoB0mc5jnmXc5DuaJ0XfvVhWdQrY2oZZvXqKWm3nSu95k5z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="451511984"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="451511984"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 03:19:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="721865697"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="721865697"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2023 03:19:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 03:19:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 03:19:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 03:19:52 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 03:19:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NeYh0upL/xxNnBq0IIrEvq3vKRk4ZOGINfxQ4lrezOg2YpQWeZqD3E66F908bq0kT4xOCZUYbbwH3C2kJiNKBsIYumq4HKgOj9aSr7ypu/xvik5/KxsVIYzYzNhjQJsHo5FRthlmsz7TtU2aRyWFzkecejZhne3qTTzS6Zvo7iyGjW7xgnRw5s0a7SQXGEULeGyMwdqvqahkM9EA2ntaDmZgITOvLmq9plwaa6szWO1Ltat6w0dU35U7gXnSGqXzp9FDSNXBMw/2HnVnyhXbIqXSohfDeGYwhIuEyrEVMTFlMFGEs+Ru2pGM0tMaWt2aSzCh9DTJHxuWHPKNv69cHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSrwYVxM/F2ZNpy1tSv2CO9eNe8L+5Hm22Y+KlY1ZqQ=;
 b=ThDk5ZuexyDRUcNx9vr2az5Ze8CMGb9uObN3yVRZtEBTvHOGl/TeVRffPwjUHz9asQLWslzlzWIoWBJAaQq41kfVOf3QBoChWbIPvTTu4c5az+ZARqsZ0etHalVQbWgG0HQDD4zG3SPyCdQPYOSpjBULx8wPwkk4pCMFhDxOVd2ZS52TsQcHENV8yBT8B9PmL92qBXYyjGqYQi1jajfvpGw68A1MTbt8hR83KnCm3FVtQnE8n1f+tKemZrf3IzwVgR1L5g7Us5ixFIUgO6TkA5b95nqKdzksEJYRjESBS4NQdrtpoLqJnrBOu0agEosydFetlD/cjog/joe0kLyaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7145.namprd11.prod.outlook.com (2603:10b6:510:1ec::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 10:19:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 10:19:49 +0000
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
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2WZEAgAABkQCAAPx6gIAAC1QAgAAa7QA=
Date:   Thu, 13 Jul 2023 10:19:49 +0000
Message-ID: <5cc5ba09636647a076206fae932bbf88f233b8b2.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
         <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
         <cc5b4df23273b546225241fae2cbbea52ccb13d3.camel@intel.com>
         <20230713084324.GA3138667@hirez.programming.kicks-ass.net>
In-Reply-To: <20230713084324.GA3138667@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7145:EE_
x-ms-office365-filtering-correlation-id: a6a6a4e1-504e-46ec-430a-08db838ab0d2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OOziQQVRzJIF8DOC0RC1juaqVQC6HC15XNu8AXGZk1g7hA4FvpbXTWZNdT2MmXU6INn4JKOlKjsaC6rFG+MlkodBs9Bx5xgEXgQmVYu359QHJFmAnvRE2n4UI9TeCaMmArpJrMZU1Rc4ptP5xNkSMcKKRob9XDADeI8ZQQF/z97jaM59x6B4/ZRHLNhKAKPbCE2EBjuDliA6OF45/yudPSF3Pv9qn/ZIoIgRbieISqw4whbiLInA3uyjf5UnIHfHHX8RHxkTjizeziS8ezhAsDPDr/JH93ZMcLrqGl6lRug1R9EVWF+JLkgm45RvtID2Arb6+w3KLzUrX5SZn0l0SSr3bBCIEeoGINVL4gGhiiE5F8sWrcuahGvYI4ThwqlKQ+9wcH2oSqB66Sbxnvdv9ok0u1ueiC0v5jtK3YY8j+DPu+GGa9K3ulS3ij4KUJfZJ3j8J1I8Jouh1g0qciYJmHkqZ/JPtF/fKWtFUbJ4DoQ06aRdem06uhmO0tv2imDyOL1AVNn5+WUZxgUyzyep74W8WTsuILNQT+qtguGOlQKjQUkOVRkA/eqp7gHylryf2d0nkkyTRU6WIql8fo3C1D6YrwQFAyxsVd6ZWLz54e3uB6NZHy+W3SWZYOJrn3KP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199021)(316002)(41300700001)(8676002)(8936002)(6512007)(6506007)(7416002)(5660300002)(26005)(2616005)(2906002)(66946007)(6916009)(38100700002)(54906003)(122000001)(36756003)(86362001)(478600001)(6486002)(38070700005)(64756008)(66476007)(82960400001)(66556008)(71200400001)(66446008)(4326008)(76116006)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlpiK0h0WlZxSy9UcWVvRTRvaCtHTHFuRHRBb0JFRUI1NXNVZzZhR3h2THg0?=
 =?utf-8?B?M3hQRUlxQVFTZGsxSkxQUy80NFQzd0FkYU9kWXlhNnJ4RS9FSmJDOC9UbGt5?=
 =?utf-8?B?K3hLdzNUa1BNZ3VaSms1K2xBR0VCOFN2SUxOVXhaV1VxbjhYRTZYOXd3UlhY?=
 =?utf-8?B?ZGdwTG5pZExmWHlyTUVsZk9hL3JUMzNPcHB3TzRiOURzVVI2MW94WGhnelpL?=
 =?utf-8?B?ajI3enhuQWJKeXpFYUY4SnpqOE5IUTdUQVU4ZFRST0hwd1ZWSVYrdmRmZHQr?=
 =?utf-8?B?eDlrM3o4dWNHK1p3bklGZlRvWHZVRVcyMTZWdlNUZjJTZWxJWFd3MW0xMEdr?=
 =?utf-8?B?WFJ3WEdJcS9sQ3FKMXdMR0pUOGNFbWlibGRaRllvWTdBWjNsK243RkNQS0k3?=
 =?utf-8?B?VDMrUklsZ1ZtTjkzaGFlRC9lQ2ZmNk5RbHNTb0poTEZ0bEJDa1N1ckVOd0VF?=
 =?utf-8?B?UExTb0FIWDl1cVBrekg4Q3Q5QjAwdUtkY2szVTVNV0Vxd2hIRkNYUm5YbXg1?=
 =?utf-8?B?NU4veE5xSFlYTkZFKzdnTEg2R29CbW5VTTJiZERMZDdQMjh1QXBXRU5yODdt?=
 =?utf-8?B?WUVSZG5FTFR2bnVoVVYxOU5BWjMyL0hnZkVKZkNtNUhwOTNQL2tmbkVWY3RX?=
 =?utf-8?B?U2FHem0rZlJ1S0t1QzFpZGF3b2FvTEFNbzVuVVhPMXM0aUtQMnNETlRDYzdp?=
 =?utf-8?B?VlhGUjJ2NWJDU3cyL1BHdXVpMEQzUkc2RGFINGYrWjFwY3IrSDJKUi9yZ0I5?=
 =?utf-8?B?aVVzbTkxNFQ2cUdPZVpaelg0cFduYXhodWlxL2tqWHhBeGdrY1RFQ2NjMHAr?=
 =?utf-8?B?M2tVV0YvUTRtTXAxTlBkamNQVHFoTXdEcVRmVlZxdEZPNlU2MEZWTjVhZUFr?=
 =?utf-8?B?emw4THQydWtFTSs3NUZWL2hUSlRBak52d3RKOVlLZllrZlhnTW9pY0U3aitl?=
 =?utf-8?B?SHZTYnBiSXJ2N3oxemxIV2FaRG1VSStBNWJ4QjlNYThyRzNJN29FcU5MT3Jl?=
 =?utf-8?B?YUJBOFlPaDd0NzVWV3haRzJydEhmUjBzVnVSUHZtcFlDQ2pCU1RQMW5UL3I4?=
 =?utf-8?B?WE1yemIxeGRrQjhKMXBYNmFtTFBJSTBPOXJoRDNsUDNHd1dJT2VJT1lDUTZG?=
 =?utf-8?B?QjBNVTNYUHRCYkNzZnFFdFRkOUluZTNZUkxISTZGRFdTRnBaYm1ndU9OK0dE?=
 =?utf-8?B?M1g0TVVPOEJDc3YwQnY5alVwVjZLTXcyRndmU3FFQ3lhZmYwYmt6VUZXSHBp?=
 =?utf-8?B?ODZ0SG53Ylh3aTRaSjhrYW02WkY0b251cXFHMFdDTUdwV1J2eXRvdXJGMjBw?=
 =?utf-8?B?dk9zT3NKR2FsKzlPK2NqbFlwVVlxclVYU25iQkF2UU5ndG5CczZNUHlJNmVq?=
 =?utf-8?B?YjdrWDdUSWZubUM5ZURueHBNMUNBYjNCcE9lQUgrajUzcnp1emFsT3pjSVov?=
 =?utf-8?B?bE5kUTY4RUo5V2k4N2ZXVXhWV0c1YldBVHdnb3JPRkc1Mk1odFUzdnJaUU9r?=
 =?utf-8?B?THIwaENnOTc0MHowWktkWm42WDNJMDEweEpMSFNoV2pVMEJ5a0syQ2c1Wm5h?=
 =?utf-8?B?ek5qVjlqaFFISTQ3akVtWTB5K3lnMEJUUlZUU1M4WWJUMUNxZjROSis0ZHFU?=
 =?utf-8?B?WUQvS0k3QzB3NC9MK2xFb29iM0tRUDl1RDYyZlNjU2FMOVhMTW16WHhaK0Ez?=
 =?utf-8?B?amxVUjlKbzQ5OEtZNVZvSVRwWk0zamNxcXdVOW1MMlNWUkxEamhzZ1ZEUEMy?=
 =?utf-8?B?Q283bHNyQzdZVGV6YUFQdHBONnhrZWx2bDRwOGZJUmc1MmhtT0JZZzA4Zkho?=
 =?utf-8?B?c1h0QnRRa1RQaWhNZEcydkFXS1pMVFp6Uy9TYzRmbHZURU1Ed2J3RC9ENTNX?=
 =?utf-8?B?dEE3YnJ2R2JLQ1EzYU9SSjF1NmlZUG5XUS8xa0IwdytOOGpXcys3QnZxaGRL?=
 =?utf-8?B?U2xwRVpDdzFwSTdSa2s5alhtcFVOdHpjRzNISm1mUGtTd24rQmp1MlhHb1ZF?=
 =?utf-8?B?VHBTWWp3SXAwTWpVazRTUjNmWHA1N2lkREtvOTU4UmltZ3lGU1EraHBJNENi?=
 =?utf-8?B?ckR0R1o1T3IzQlUyT0toK3pPWHZXOS9wNlNWb2tJKzZIb2JGMUg3QTRmdWRY?=
 =?utf-8?B?ZEx2YWdBSEU5cXNVeGZ6UjZIM2NvYlRMWjI3U3lnQnAwdkRZV29LZmlRajEx?=
 =?utf-8?B?dlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65857F539D4ABF43BE9C3AA94CE8F521@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a6a4e1-504e-46ec-430a-08db838ab0d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 10:19:49.8201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yMyhAc4YQt2iOB4LIhQMS/eC+/z4ob8xZsXxVByzIRhVAsHQ7L2GMmPiQjL5kU5KC+Vch3SSBRtQ/JzLXEaZfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7145
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

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDEwOjQzICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDg6MDI6NTRBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gDQo+ID4gU29ycnkgSSBhbSBpZ25vcmFudCBoZXJlLiAgV29uJ3QgImNsZWFyaW5n
IEVDWCBvbmx5IiBsZWF2ZSBoaWdoIGJpdHMgb2YNCj4gPiByZWdpc3RlcnMgc3RpbGwgY29udGFp
bmluZyBndWVzdCdzIHZhbHVlPw0KPiANCj4gYXJjaGl0ZWN0dXJlIHplcm8tZXh0ZW5kcyAzMmJp
dCBzdG9yZXMNCg0KU29ycnksIHdoZXJlIGNhbiBJIGZpbmQgdGhpcyBpbmZvcm1hdGlvbj8gTG9v
a2luZyBhdCBTRE0gSSBjb3VsZG4ndCBmaW5kIDotKA0KDQo+IA0KPiA+IEkgc2VlIEtWTSBjb2Rl
IHVzZXM6DQo+ID4gDQo+ID4gICAgICAgICB4b3IgJWVheCwgJWVheA0KPiA+ICAgICAgICAgeG9y
ICVlY3gsICVlY3gNCj4gPiAgICAgICAgIHhvciAlZWR4LCAlZWR4DQo+ID4gICAgICAgICB4b3Ig
JWVicCwgJWVicA0KPiA+ICAgICAgICAgeG9yICVlc2ksICVlc2kNCj4gPiAgICAgICAgIHhvciAl
ZWRpLCAlZWRpDQo+ID4gI2lmZGVmIENPTkZJR19YODZfNjQNCj4gPiAgICAgICAgIHhvciAlcjhk
LCAgJXI4ZA0KPiA+ICAgICAgICAgeG9yICVyOWQsICAlcjlkDQo+ID4gICAgICAgICB4b3IgJXIx
MGQsICVyMTBkDQo+ID4gICAgICAgICB4b3IgJXIxMWQsICVyMTFkDQo+ID4gICAgICAgICB4b3Ig
JXIxMmQsICVyMTJkDQo+ID4gICAgICAgICB4b3IgJXIxM2QsICVyMTNkDQo+ID4gICAgICAgICB4
b3IgJXIxNGQsICVyMTRkDQo+ID4gICAgICAgICB4b3IgJXIxNWQsICVyMTVkDQo+ID4gI2VuZGlm
DQo+ID4gDQo+ID4gV2hpY2ggbWFrZXMgc2Vuc2UgYmVjYXVzZSBLVk0gd2FudHMgdG8gc3VwcG9y
dCAzMi1iaXQgdG9vLg0KPiANCj4gRW5jb2RpbmcgZm9yIHRoZSBmaXJzdCBsb3QgaXMgc2hvcnRl
ciwgdGhlIDY0Yml0IHJlZ3Mgb2J2aW91c2x5IG5lZWQgdGhlDQo+IFJBWCBieXRlIGFueXdheS4N
Cj4gDQo+ID4gSG93ZXZlciBmb3IgVERYIGlzIDY0LWJpdCBvbmx5Lg0KPiA+IA0KPiA+IEFuZCBJ
IGFsc28gc2VlIHRoZSBjdXJyZW50IFREVk1DQUxMIGNvZGUgaGFzOg0KPiA+IA0KPiA+ICAgICAg
ICAgeG9yICVyOGQsICAlcjhkDQo+ID4gICAgICAgICB4b3IgJXI5ZCwgICVyOWQNCj4gPiAgICAg
ICAgIHhvciAlcjEwZCwgJXIxMGQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgDQo+ID4gICAgICAgICB4b3IgJXIxMWQsICVyMTFkICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KPiA+ICAgICAg
ICAgeG9yICVyZGksICAlcmRpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICANCj4gPiAgICAgICAgIHhvciAlcmR4LCAgJXJkeA0KPiA+IA0KPiA+
IFdoeSBkb2VzIGl0IG5lZWQgdG8gdXNlICJkIiBwb3N0Zml4IGZvciBhbGwgciogcmVnaXN0ZXJz
Pw0KPiANCj4gVGhhdCdzIHRoZSBuYW1lIG9mIHRoZSAzMmJpdCBzdWJ3b3JkLCByI1tid2RdIGZv
ciBieXRlLCB3b3JkLA0KPiBkb3VibGUtd29yZC4gU0RNIHYxIDMuNy4yLjEgaGFzIHRoZSB3aG9s
ZSBsaXN0LCBJIGNvdWxkbid0IHF1aWNreSBmaW5kDQo+IG9uZSBmb3IgdGhlIHplcm8tZXh0ZW50
aW9uIHRoaW5nDQo+IA0KPiA+IFNvcnJ5IGZvciB0aG9zZSBxdWVzdGlvbnMgYnV0IEkgc3RydWdn
bGVkIHdoZW4gSSB3cm90ZSB0aG9zZSBhc3NlbWJseSBhbmQgYW0NCj4gPiBob3BpbmcgdG8gZ2V0
IG15IG1pbmQgY2xlYXJlZCBvbiB0aGlzLiA6LSkNCj4gDQo+IE5vIHByb2JsZW0uDQo+IA0KDQpJ
IF90aGlua18gSSB1bmRlcnN0YW5kIG5vdz8gSW4gNjQtYml0IG1vZGUNCg0KCXhvciAlZWF4LCAl
ZWF4DQoNCmVxdWFscyB0bw0KDQoJeG9yICVyYXgsICVyYXgNCg0KKGR1ZSB0byAiYXJjaGl0ZWN0
dXJlIHplcm8tZXh0ZW5kcyAzMmJpdCBzdG9yZXMiKQ0KDQpUaHVzIHVzaW5nIHRoZSBmb3JtZXIg
KHBsdXMgdXNpbmcgImQiIGZvciAlciopIGNhbiBzYXZlIHNvbWUgbWVtb3J5Pw0K
