Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4286BDBDE
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCPWlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCPWlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:41:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF9BE486D;
        Thu, 16 Mar 2023 15:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679006501; x=1710542501;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FcIa8uwUpWfF6/Oizs4l1sYa1lpAFuHNoBHqcB9G2as=;
  b=eWTS8YvhPyEo+IDbiaQgLqYpjqqqyisTI0yKByKqRa+b3ir35P+GQ8IW
   F2790mdCLu57hqUe+Zx+k84mkTNiz332jDF8MDpbk/mf6J71aQqGD8zDD
   ZiawDE80at1xFh/vAFGqswOdgrdYX6UgmhPLBP4pwbnXrpBO7Yo06ey0z
   AaH6BFRUkzsD+0ywtDU1kyAAv2k82sqtEWqWU2rYiOxUnlyLfsFsHLArF
   a5e15tqqUyOt/w93vdBMwUH5hkYwO1Sbc+JgYSLdnVzNG9U+W8B2ie+ks
   B9gM1gPHM2HrJ22nR76cTaeLLKelRIuRKRwC7o2WR04PjKoGxvZLpfioP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="338144031"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="338144031"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 15:41:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="790492483"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="790492483"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 15:41:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 15:41:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 15:41:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 15:41:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 15:41:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=libA0uW8J+o/IeBMjvIUDacuXd0aW0H8GxoMjuU9JV2St8BQH5N+Yb6r4XtM7xmquWnAf4rBf85hc/57pYRsLSAzKdzVTC49H6nLEgys4emAUFg+DbhMDj8FYy9rqujR7NvFTSOtS5WQb0HdfmEX+wxb0KghSyBpiEqf9IMun4WXu/1msalKtw9HB39TIn97mLZmuZ8YAtUK6Z48Go6qZWNFkmNK+bemWodA121ME0mAcc3IhW1EEs0bwV5dWgk0kUxm3xI3n4WuhMCXi7pE0SXkDLoSbDIbWbtwvsrLy7hd+3/gMSGoNsbMAkkL9gEFlXctA69W2xoUZDK/lu2oVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcIa8uwUpWfF6/Oizs4l1sYa1lpAFuHNoBHqcB9G2as=;
 b=XrkpRAVVmgAtoxNEd3pPnEH8WQw8FrVtj5Cd2Ej3/h1q02tgfzxq8+hcqQOIILYQskAC/vA+8eYPaC82rs/HC+sjUNMGGv67E3qHJQluIq1ptoAmgzZanlztpXdDiL8LQiHsy6YaY+AnHwkE1FnYdyESXG1hxdzEM1iBtRokpVfGvLe10UoMMEYyYoNrcONKgbosH/8qOrEMBR4o1QGaqVZQ2mz7rZua4XpOw7oZVdrElZTxlIctMP9ziO8ugW7OhPVeHtivGzYc5BiUCtMaon4Mk+c3sFLe+3uB7nUgHjRbdNC+AIDfIwzbqAKzUEuGDQQ7KIzTG5T8KJM5w3txPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6726.namprd11.prod.outlook.com (2603:10b6:806:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 22:41:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 22:41:36 +0000
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
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 01/16] x86/tdx: Define TDX supported page sizes as
 macros
Thread-Topic: [PATCH v10 01/16] x86/tdx: Define TDX supported page sizes as
 macros
Thread-Index: AQHZUDU33ear0uwjqkW4D/r2d6boc679Z8yAgACos4A=
Date:   Thu, 16 Mar 2023 22:41:35 +0000
Message-ID: <6c9e400e1be993ea668b3a5e8cba06f7095415e3.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <ca5d11744de083812ba121f1b8cc0576a8691342.1678111292.git.kai.huang@intel.com>
         <d7a530a9-fa96-22fd-5dee-6951b923181b@redhat.com>
In-Reply-To: <d7a530a9-fa96-22fd-5dee-6951b923181b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6726:EE_
x-ms-office365-filtering-correlation-id: 5dd72fde-cbed-448b-f948-08db266f9964
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GmtpzNvZRebnWPIAtAztd/lozel9a0oisiIKXWnwCRvD20HmY2coPQWiX0+LHd4BVB/KQelplvfm+ZJw2CcPPfjXKujQ8JwMKectAzbPwN33llIahAgqXndBjgTyzxxZjvYVL0aLaZF+uMxwVth5yuzHlfsFCQY0GGJt5ftg+1wOwFhbXg4ck7BssqGSD+w3gUeGJojTJ1E1w+kHdwl9fXdDsStVSSkrO6WnKq6cEMf+seaEk1rd2btb2QdR/pjaXbwNx/Xu55fgH/nAyVUit1xyZuarC5ZJtc2S6WzQC477an4jmF02IAQnqkLUiVKI2pZqHPt4hvnUtQxdoLLx0SZ7AVD3Qsw6vU90zgnKn+BHQMuP1ck97E96zetYe+bYyYCGa/FMZ4c/ehXWYC8E9mqW3GiGCyhqJqhroQoBdeN1Yag62w9QvuCKifET/ZTVciPcgrfaS5t6sGApyd6qAteonlVAJg59vYwBo5vcVifruPlzTQazYCrH+VKEnbwABL3heYHF0dK1752QNNJ9xs7QyEnWKl9t+iIsI8vEqieu6AwEAaVREEk17dwjxtnsTlAbS5qb3RPyms51g76h2rkcgmBlbplTxk8aRqsMEAlhnWzaXmFiQG2dlST9ItmDxIstGLLb1w8XD7yuCVED0ODbcFm9QW8ThnihwPQhnUDGbKz/y/KZ9ivegujn9NME+Z9VwgWYdN1WMixkSYwZtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199018)(38100700002)(86362001)(38070700005)(4744005)(122000001)(82960400001)(4326008)(5660300002)(7416002)(2906002)(41300700001)(8936002)(6506007)(64756008)(6512007)(2616005)(186003)(53546011)(26005)(316002)(54906003)(110136005)(66446008)(76116006)(66556008)(66476007)(71200400001)(91956017)(8676002)(6486002)(478600001)(36756003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjlmYXdUdFVCdm5VcDZJaXQzWUMxTzVLOWo0SU5sWTRybHZNNXNBcHpxWHZZ?=
 =?utf-8?B?aWlKV2ZqUzVMb1hEVWRNZTUrcGZvTVJrZEZEeS9KcEM4QWF4c0p1R1FSWWhn?=
 =?utf-8?B?WUpEbzBRT0owcVJuT2cxTkdqRVlnUEliaEkvUEFOWTFmRnV2T2ZhdTlPNC93?=
 =?utf-8?B?bWZlSEV0UjRMRjNZblBWc3h1RHE4Vmk5Y1NiUDVzaDMrUFpITjNzenoyWWpM?=
 =?utf-8?B?VTdIaUlPdjRHdlFxeG1KUHo0TFFRa2F1VmtBMGtISmtFQ25xYkVrRk1tbjVY?=
 =?utf-8?B?eGpibUdBckxUdU1HanpkYkhWSlQxNlhDdGdVcnFEOUN6MDBHdlFscWtxTmsz?=
 =?utf-8?B?R25yNmREakNzQXBJcXpSOXJhbS8yRTJ5a3dsUG9DZDlNU0RFSFhvb3lkMEZw?=
 =?utf-8?B?TkViUUpQemkxSDR1RndRQ0Y5a3RSUTNGenlGaW5DUzFCVm5ZYXlnQlJjUHVr?=
 =?utf-8?B?M3crMXJ6eUU0MStTc21maDNPTE9QYi9XaFduWWVwTkdHcUNROGUyT01JWVov?=
 =?utf-8?B?TVd2b2Z3Y3dhT2FyK2pGK1NKVTlMV21sL3hWckdQQzI2NXArRHRiRHFkTFk4?=
 =?utf-8?B?Zm9uUjlYTWZKekJlVkRzQjdqa1pUb2JDQktVRXhIa2dxVk5xQmNYekJTWUFZ?=
 =?utf-8?B?QUpNRUhaMGd1NEV5TTlXa09aVWU1ZXBQLzNDN0NMM2pVRjdlbXN4bENXYzIr?=
 =?utf-8?B?cmk1aU1KZ1llM2VVZXpNTTdHejExUkJUU29FMUt3SjNsL0RVQ3dSTGtWYkdJ?=
 =?utf-8?B?QUtHdUR1dHRJK0hJYzRoOGtUUGhJY1BIS1k5MnprOGlXZFh6VnZBVlRva2Vj?=
 =?utf-8?B?WFYwTWN3eDdGSzVJNnRDeWZONWJJWWdWN0dPS2JUTGFLNG5ERnBiOXRPdFYz?=
 =?utf-8?B?alF6alJ2bzlUYXA0Ly9LNThaY0RUSFZ1OU1ZU1BWWDNqTjJzUEErVTNUTXg1?=
 =?utf-8?B?b0kwT0xXMy9oL3NKazczVkNkMHkxaEcwa05tUy9NbjczOS9waTlPZlcrT0NW?=
 =?utf-8?B?T08vN2NBREd0MTFPYWVuN0RmbG1jV09nelV2d1c5c0RDU2hPeUpHZkduUEta?=
 =?utf-8?B?TnB0NHN6MDM2OXZIN3ZCQUc3RHdDYUlQOUJtVkFWMTB2ZndPMTR4U3BCNGh4?=
 =?utf-8?B?UTljL2kraXErU3lRRnVHN1UxV3ArTW14NDZBaHF6RWd3dEZmaTNML2UwbGFB?=
 =?utf-8?B?VEttSkR4TGN4YndkSFJjTURLQ2VtbXZnOC9RcWhlR2lCL25iNGVKMmtoVGNw?=
 =?utf-8?B?T2YrRlBQQTgrMUNrYktDeHZnRFNQWUpUZTU1c01SWFdRZFpTak4vbGtLL1A2?=
 =?utf-8?B?NVZZSFVaWEdBQ1B0aks1WG9YYmlrY3hUc0VjSzFnNlBOUU9EU0hqUVM2bDFJ?=
 =?utf-8?B?bW5uNFpwMEZ6SDFoTUY4Z3NIVU9SREhNQ1hVZnplRFVCa2Y1ckRveFpvYWc4?=
 =?utf-8?B?dU1UMVpWeUwrWkJlVFJFZjA1c01FNWRsZEJ4VTNZUU5PWG14dVpxUkJWeW44?=
 =?utf-8?B?SDNYbjE3WENzNFpKT3lLTi9BSXBCbTc2aHVYSldoZFNtdWEwc1ZaTFRqQzdC?=
 =?utf-8?B?WGpJZ2tlNWs2TXY1aUJPaURzU0tMdHlKNHUxVHBjSWNtMC9WYjQvRGJEU3B6?=
 =?utf-8?B?OUFvNEZsMnlXcVV2eGhxN3hGUEVDbzdzeWEyYUR1WURTQTc4ejFpUEZmZ3Jy?=
 =?utf-8?B?RDdkL3o1clhYbW43QnRlaFVUc3BpMEtxM3dJQmdCOEEwaGIvby9EWm9Ta3V2?=
 =?utf-8?B?T05GelpySWhEaU15OXBScEhWOTMwWldQN0s5aXRRSEw5VHZXcUFwTFY2WmlM?=
 =?utf-8?B?Rkw0SVVXQ0doKzI1a2hmL1d0U3ovTTRIQjN4Z1RKYnVNYUhGcS9rWjhrajY0?=
 =?utf-8?B?ek1ad3gxOGZYbVhjQ2ZKN3pCYnZVMGpaOUxxZFpkUWxkMWJUemNsR2RFNWE5?=
 =?utf-8?B?KzEvd1lMeHFnMUJ4NHN1RnNOcnRybHkzWHhPRWUxU2FWdm1oL3VyRWdWalIw?=
 =?utf-8?B?dmlTaFVkekFrMitIbkgwRjR5OEd1N2Q0Nk85V1BqWkMwR3ZqWm5vaG1ZRVRP?=
 =?utf-8?B?Sis2cGJzTHpPZjVXSVNrajJoaVZCam9RRWRFVldMOVh1V2VqZlNibHMvVm1l?=
 =?utf-8?B?UkdhWitIVzRoSkZIWXp2ajJqMUQ5KzRyNXpMSXk2N0lJMGdBR1lpRUd4Rnd6?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98AB939EF52FA942A7C69EC6D8CBC935@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd72fde-cbed-448b-f948-08db266f9964
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 22:41:35.9345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RxGd3zDVpxVzeL4FvKXqaAQTt2OdkgBrRE9qgZOgtbnpc4xP6vM6xtw9jO1TKA11sQrlGR+aNtcMY6jPW9v+Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6726
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTE2IGF0IDEzOjM3ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMDYuMDMuMjMgMTU6MTMsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBURFggc3VwcG9y
dHMgNEssIDJNIGFuZCAxRyBwYWdlIHNpemVzLiAgVGhlIGNvcnJlc3BvbmRpbmcgdmFsdWVzIGFy
ZQ0KPiA+IGRlZmluZWQgYnkgdGhlIFREWCBtb2R1bGUgc3BlYyBhbmQgdXNlZCBhcyBURFggbW9k
dWxlIEFCSS4gIEN1cnJlbnRseSwNCj4gPiB0aGV5IGFyZSB1c2VkIGluIHRyeV9hY2NlcHRfb25l
KCkgd2hlbiB0aGUgVERYIGd1ZXN0IHRyaWVzIHRvIGFjY2VwdCBhDQo+ID4gcGFnZS4gIEhvd2V2
ZXIgY3VycmVudGx5IHRyeV9hY2NlcHRfb25lKCkgdXNlcyBoYXJkLWNvZGVkIG1hZ2ljIHZhbHVl
cy4NCj4gPiANCj4gPiBEZWZpbmUgVERYIHN1cHBvcnRlZCBwYWdlIHNpemVzIGFzIG1hY3JvcyBh
bmQgZ2V0IHJpZCBvZiB0aGUgaGFyZC1jb2RlZA0KPiA+IHZhbHVlcyBpbiB0cnlfYWNjZXB0X29u
ZSgpLiAgVERYIGhvc3Qgc3VwcG9ydCB3aWxsIG5lZWQgdG8gdXNlIHRoZW0gdG9vLg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiBS
ZXZpZXdlZC1ieTogS2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZAbGludXguaW50
ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AbGludXgu
aW50ZWwuY29tPg0KPiA+IC0tLQ0KPiANCj4gUmV2aWV3ZWQtYnk6IERhdmlkIEhpbGRlbmJyYW5k
IDxkYXZpZEByZWRoYXQuY29tPg0KPiANCj4gDQoNClRoYW5rcyENCg==
