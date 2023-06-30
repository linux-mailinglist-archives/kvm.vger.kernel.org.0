Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717617438DF
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjF3KCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbjF3KCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:02:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA9E2681;
        Fri, 30 Jun 2023 03:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688119360; x=1719655360;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fAvrHRDy3RAnOnGf+akVXuck4HzmjjL4r09eSSdx4Qg=;
  b=PIuinnzzA1Wz5WAnvJh2iIZNMpqW493CUZUXKWE1rkXsRfl9lsPJkrFp
   615C0Cfx1xuawpIOF8syT52jnJ5KHw2796kRxc4mp+aWOa7IqQa/cQ5rZ
   ktecU8yYCiSl2A/4U1qWAwBvYIsErN6Kp9vAgDXqAZM5iXdTaskBtZyIf
   5JHlacSaQYk0PaTU81POjqRMQoYJlGzIeDcZb9rJzO27MSbal6GF6wGFk
   9xlXz1CpYuDiyqtqmDpdLz1S7JeCigy/CjsN1Cygd9/Bq9dWx/JZWS1WA
   be61o3rG8efXjaRu5Ivb34GGn99TSUWQKSmg82orotexNtNjRpSca4Mlb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="342699773"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="342699773"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 03:02:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="891706515"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="891706515"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 30 Jun 2023 03:02:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 03:02:37 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 03:02:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 03:02:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 03:02:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2N2jBALzoUuEaMbAVWOTjYN1cAj6VyuDGwMg80JuJsGMBVCL9CYgYiBTSTyKupAuX3LbVuCCpUOp8Bp86udrvF8CZJcOlj/Q/Xbc8zFlvE5VD8WkM7ZvDQX7on1C1y7Bc61pb0+SrSXSOPu+9AFbjv3mpiN/yQuxkcS8wKqzyIzrCiCZpNy8OO4WQAq4J/R9ePMAmW/JDP41FvHkVzPU1atrX0eTPOawuKgwwuiR0Xy04vAiQFd4CjdROS0opSCcXYsQTrr73SR7xTOdKkJglnqAWFn4FlonabDpBDXpg6OwveZRTMpG6fK2lQQDqStU9q6DXmtA75ESqN6OctJmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAvrHRDy3RAnOnGf+akVXuck4HzmjjL4r09eSSdx4Qg=;
 b=maZ0Hv+J9LGVUagVZHPguvXLeNAC6rRYSlVAWXWXofNzJryrbv+7C6i7bhQGqxuxRbHc8SNOfvnphR8G4lAbI/XGdrWuytcGXEMy+hzr62idBkbF4JuC0z1mIsRvMvW9wkXrWTFANgPYi60QBLxSrtZ9gzXsnHiUlYub2puSsndC8QYiEJonmklYGALnzQ6uyrDPIBueaCoWSRKSDZ/3flOidX65J6tVGqXwvo0lzPKroBw4d/uocbSn7CGZPhQuud3NksErYRL7FvxuzFZPHqz/Ns5fIZ9U3eVwhtSbsQUEze+Jh1JlYQlwGq2j1PxA3bdI9E5QDKy79dn9qxTArw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB7702.namprd11.prod.outlook.com (2603:10b6:a03:4e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 10:02:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 10:02:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAAlDAIAAAXCAgAJXt4CAABCVAA==
Date:   Fri, 30 Jun 2023 10:02:32 +0000
Message-ID: <84e13c5e32f001b8c79f0f18fe18f3225cf47dfb.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
         <20230628211132.GS38236@hirez.programming.kicks-ass.net>
         <20230628211641.GT38236@hirez.programming.kicks-ass.net>
         <20230630090309.6mnsvfhcptekmzfu@box.shutemov.name>
In-Reply-To: <20230630090309.6mnsvfhcptekmzfu@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB7702:EE_
x-ms-office365-filtering-correlation-id: 0fa34df7-7ff2-415e-ad71-08db79511f78
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IBanyBSoJPugJlt+nUI/j81j+rp0CIJRxeNgnL7l7WdgoZ2MY+KOHiZ3PZXVo+tou3vSLlBIjXDIdcvBErq114EJL6Ryw5IkiAATmchlrPe3awCI5wJcpTZmugmYxxng5YVoUAbdiTk4ORQRLKlMk8hLLRaSa0pfhOnt78f9dmFFr9XvHlFEHLXb0yrRYUH8vJAlCy8b8jH5LW6qiHuBCacUxt7lrAGORhcFskCZYI78Lp7NG4rP7Rxd6XXQrmAqJ421ZrEwBuQl7DQGv0359ztGsSZ4WKH7eYU4CZ0ao8WrXKvpIZsBKxB9ES+OHkmr+XEHYu5ry7rwJucI/HsevdmfJTqZ9ts+48MlLbXpyfl0irJcoUvfXaPnMKMpWR8TaPdEKHc0Bt3sXoHtb9crLawOERSS3pfaDeAInFuuNf2OhUrnUDjPy4GM9icCQANWylYALGqaEaOxTFZJAJ2a4m/M+vtr6RRgYqEzv3i9Ea5+J/jVc2nytOL7Edmg5mbDxBtcIOn6M+6EAOqpCljx9pZSLv4A4fZLBvlFgiJG3VimpeoWYKDloGcFlOIBiD0QAqkeG+XCm+5JmUSJZnd+3viWy/umo8GoxwTKTTCbVkH/aRZhep3vDJTeFVMgyw0q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199021)(66446008)(558084003)(36756003)(38070700005)(5660300002)(64756008)(7416002)(86362001)(91956017)(66476007)(66556008)(41300700001)(122000001)(8676002)(316002)(76116006)(4326008)(8936002)(38100700002)(82960400001)(66946007)(2906002)(478600001)(6506007)(186003)(6512007)(26005)(2616005)(6486002)(110136005)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejI4M2RQd05EdExJeUM0bkFnVEJXRHo2WVkvZmtFdzhFTFVybDhQbmxzQmdC?=
 =?utf-8?B?V0U0NDlKZEJFVWwzWHVlYzNRWThRTEZsWUJJMEV4dUpnYU93WXlsUEpFb3ZG?=
 =?utf-8?B?K2xJNGVaWGJWdEp5NStqZ0JtdVJzcWVDY0ZOZFc5LzFoTzRhQ084L2l2eXd6?=
 =?utf-8?B?MnlyZHo4cys0QXZaZk5MMHpOYzZ1NXlVQ1VKT2s4YWw5ZTBna1RnOFFBRW1B?=
 =?utf-8?B?dXUrWTN1WG52MlBNU0RWL21Ma3V2RDc0bHJPOVIzNmE4MW1oSjQ4QWtpYzJU?=
 =?utf-8?B?dUNhQjV1UmJQS3lvNXBTUXZQdTlFT3AxczJyRURMZmVGSU5NTERqa0VBK09X?=
 =?utf-8?B?WjJhOC9SWmtpU3hFc1c4NFYxRHRZNHZMSjlxN0tVQ3dZSWVsUXZUb2kzVmlD?=
 =?utf-8?B?THpTc3A2SFB1R29RK1lNZ3BZcjdsTE52QWhkMUhlNklPblQ0bUc1Q2hLZFdn?=
 =?utf-8?B?VlhmT2U2VjlaTHRlOG5vZXRZNWl1MXFjSlVsUEVvdlpvT3hicnJNNHpCNCtQ?=
 =?utf-8?B?NnJ5UFVMRHFTelJpWWpqU2cwMGMxd01RZUY0ZlVwbVpnWmFzVTVJNnAxSkda?=
 =?utf-8?B?WDhYS1JjNjBGYlRkRE1JV0RDQmQrMHN0WURrWU9keGUxL25mT00vY1lXN2xn?=
 =?utf-8?B?RVNKOGxkcDQ1VXE0RUtuOW5TMnVoTjRqa3lLQWxlOTlHcm9tYTJnaUpQcGFM?=
 =?utf-8?B?SU1RZ1V2ZkZHeTBvbEQ0c2FtNGFLV1hsVnlGcGUxWW8vN1dSZU55Qnh6eElH?=
 =?utf-8?B?Tk51QWhkT1NlUXdOUVdBTzlOMGdMV29VUkxTdE5iNlJNSUw4NjVJa2h2NEhu?=
 =?utf-8?B?YldyQ1hvZHF4TDZzSDFnTkpsZm1UL1RSVVJmR0ltMXNjVlJjdE96eGx3dnJh?=
 =?utf-8?B?MTZZcUUrOWptdXYrVFJVOGNwNXdSU0d6RVpFNTlUQ2tpKzBRU2g5ZVhWa2Zp?=
 =?utf-8?B?QnM5Z3Frbi9HVzgxeGkyZ0JaSXFiYTFzQ1hDVXQrU1owaTl2WjFSOVBBYTdK?=
 =?utf-8?B?NUVmc2VEUU8rVFAwaENQenhpYnZWK3FYL1VCTTZMZzRualg0QnJ3L2hvb04y?=
 =?utf-8?B?WDA3aHR3OHhaczhwVzlTRnhQZlgySHkxeEg3WWZlb2NLWGtpVkVzbndYSnBL?=
 =?utf-8?B?ZVR6ak45ejdwKzVpRzFSMmt4NlExdzZobE9lSjZ3dWp3ZW5DTGdaY2Ryem5j?=
 =?utf-8?B?UjdkZlV6ZTZHUXdCb2V6NjZwRjVxbW4wcFFTQkRPdFBsWTJQSDhpdEFNeXAy?=
 =?utf-8?B?UVhySW5ySFgzWmM0WjJRbU5kZ2REd1lxZnJ3UkJleExuT0ZWY3djQ2Q5Z2Zo?=
 =?utf-8?B?b0hZMWdlMnR5b05ZRTQzNGoyYUlvUUtVeWNZRXNqcTlpMWlFSkhzeWlhODNZ?=
 =?utf-8?B?Q1QzSjdtWDhaNHcycWZ1dkFRT2h0R1NqNlhqRE8wVmFFVU5oQis0R2JmTHY4?=
 =?utf-8?B?NFdBRmdsNTdWc21aeitEMFpPRTl2UE02WnVvVVF5UnNuRHgrMXRUMHEvdEdD?=
 =?utf-8?B?bURrMFIyTGR5MDJLT21XR2NiYTAxUndZRHJDNjVCanhsSHA5Y1Uva2drUHZZ?=
 =?utf-8?B?ZTV1ZnV0aDF6SnM4WUg2ZFhRNkcwUFB2cW1reGIyaXMxQU81ZnRKVi95T0R6?=
 =?utf-8?B?U0Z4R21QK1FIOU1Jb3V5L3hKaXlwQXdRZVA0OEZUSjZBY29CQzZUdHhWSXFF?=
 =?utf-8?B?a3duR293NzRTaWtsZXAxQklZSjlOaHdtQW1xUXFzT2tuencwRmM3MG1LcTR5?=
 =?utf-8?B?YTZmRTJlSDNSTU1FRmJtbmwxMUl1ZzB6WHBxamthY0gzWmpyZnhGQ1ZmbWpa?=
 =?utf-8?B?b0U2WVdLVms3MGxtbDk1cy9CZ0tkZnN5UytKd3o0QVExM3AvVFNOcDZjRDRo?=
 =?utf-8?B?OXpiaVJkSE03Qm5GTWNXVFBKaEJFUElSRWJ2WnhKa2x2QmNod0NVdEVIMHhY?=
 =?utf-8?B?cVRPS3FCamxYd0U1angyOURXbmtuZXc0ZjEyT2E4TzRDYU1aamVSRlVPL1VI?=
 =?utf-8?B?Rm1PNHJ1ajlzcjE2Tm5KSEJlcm1vbUwvT25rRVlzYWRCZVUxVGJrcmViZ2Iv?=
 =?utf-8?B?UlNqcE1ZRElHZ3FnbWh5SVliYXdIU0srTkQ0bTUxUnNUVkFqWDBjVTVVNXBv?=
 =?utf-8?Q?DLOJoqqaoVK3vapCeMNkcRKGU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A24A8B04141C447837E6306C16CE68C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa34df7-7ff2-415e-ad71-08db79511f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 10:02:32.9895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zB9E5XRa/bfKZgYossgHogyuhzmptAKaCZgx5eIitOvyAvLrW5pS6caOWBv1omcF/Ew6UoQsibuSBcqADhelLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7702
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IA0KPiBJJ20gb2theSBlaXRoZXIgd2F5Lg0KPiANCj4gT2J2aW91c2x5LCBhcmNoL3g4Ni9j
b2NvL3RkeC90ZGNhbGwuUyBoYXMgdG8gYmUgcGF0Y2hlZCB0byB1c2UgdGhlIG5ldw0KPiBURFhf
TU9EVUxFX0NBTEwgbWFjcm8uDQo+IA0KDQpDb29sIHRoZW4gd2UgaGF2ZSBjb25zZW5zdXMuDQoN
CktpcmlsbCB3aWxsIHlvdSBkbyB0aGUgcGF0Y2goZXMpLCBvciB5b3Ugd2FudCBtZSB0byBkbz8N
Cg0KVW5sZXNzIFBldGVyIGlzIGFscmVhZHkgaGF2aW5nIHRoaXMgb24gaGlzIGhhbmQgOikNCg==
