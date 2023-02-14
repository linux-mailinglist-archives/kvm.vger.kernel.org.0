Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806ED696ED3
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 22:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjBNVCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 16:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbjBNVCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 16:02:30 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257802D14E;
        Tue, 14 Feb 2023 13:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676408545; x=1707944545;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XSrX/JmWMYjM8qC5CfX1GLb3q+jhv17+3ZBgOI9eR9A=;
  b=KlwlM64kIEVl311zcoIW+1fFWecljQPMSTrCNWdhtzVpBreKZ5+HwpxW
   NHY3uMlE1E67NnfIo1jKYq91ru0bIqpDnyn71NVOEHpynR2hQXiy45k5H
   Hw2Xc/+BXzJf0+vLkCWjQ28N7SkzSic8rVSTUjJpjSUaG20ViezypMqdV
   3mhRodHxTneIuwMtGywnTeQpdzc0oj4UK0dMw7BfU7psyBxY5SyR3E6Kr
   iGeaTBOwLR8se25hdzttQJV5hl549TYfTu32YTBEDLabbIPApVs70MWJ9
   rbRIo9YS6yjCeMAbrdeO771GoG4LDd1VguXG1exTGYcWYT/EUc/U0udqn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="319301806"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="319301806"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:02:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="812184521"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="812184521"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 14 Feb 2023 13:02:23 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 13:02:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 13:02:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 13:02:23 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 13:02:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScF/tjw191U08bNeltlxAytvnf1BB2edI0sqBbnGofPY3/NJvvnt1KzPfGcJUEOGd4KRWDC5vXhbA0T/D6c/+OuVUmNBV/Rvto/IfsTkmEKl7PREfFLrfvk0YxpY4tTgD6fpw1pFucU66pJ8/SubsCcgkWNhyKIOQn44Y6HO+HWXl00hNM/wG2ajb2+llGY4siY+HnSHcNx+iFKL2Xo5oL4z/33wna9H22GB9vtjDmefpdVxt59EZ/0ICzb5vkgOtPesjrrDoDnbbczd6jUVkLlSi127MqSThaaUroAfakjdnmfsJ4VcTzVyLiOsvYr3g/lhH9c9O+c2lIvSghR7Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSrX/JmWMYjM8qC5CfX1GLb3q+jhv17+3ZBgOI9eR9A=;
 b=mvSipvap/urGoHI1+JRul1jo6TUO8XZoh4S9Q5/KM9ufJmaiL65w918aAomiQzW83e6caaTTMhN867VithBTTpbSAmgxIkXlM+6s8caf0aO0TYpyfzSGtcakirWtkNd/iNLkuHOon3NkPFmdPGCE/Ni6QPwnAyKyPTp202drRz/oLBzfFfqQp3dBrDEH7h2Tvz7II+13CtvoXnOkcypMWqs6EVwwf20gCGriKukSRm3NIv6MDre6BBRRPE/z6RComODaAvJNlLMBy+xeTngMsNtwzCkIQfNsqSAaUSTG8lTkLXRgYc52+83AxhY4IEelTvmjXpwQm/1+EVOAMK5/Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4628.namprd11.prod.outlook.com (2603:10b6:5:28f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 21:02:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 21:02:18 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZP5usrWInYEMBIEu01+xNPQ5Ox67OZH6AgACLhYA=
Date:   Tue, 14 Feb 2023 21:02:18 +0000
Message-ID: <f3cb69d2b7558403f2798631ad67bea2e0d95a2f.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
         <Y+uBzZOUt95YTQ4J@hirez.programming.kicks-ass.net>
In-Reply-To: <Y+uBzZOUt95YTQ4J@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4628:EE_
x-ms-office365-filtering-correlation-id: 615ff03e-7235-4748-5aa5-08db0ecec23c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nwtoiw1iOyZgU8EvSI+pYdKf6ROTyjwSTLo6BPLXNUlhOyDmSG5zJ7lv57npJIOHcBUNH/30JxFc6BMSthiW5qfhlxLneZWWyIwTlICrvq1WMFiYfT+VIwa1TA+pps/jh7r0d/BwiiJ/x0xKSpRS9TAhM9bG+5rIy4rsN9k4zj61zEdc0TOGBu3nLC0KvO3w09o40DdYQyRzhXoHfowiQEU0BrRKJkj16Ft6wR24XYEtUxdCFOtR6lDqtCSXiMDUu3kVokRiVegdJrXv6TsV6S03uhAFyJYKdu/+W89HjNif2wpsZ0Qv2zSyQLoorQj6CKKt99DXdQQVZS/lclcYpdr6UDO1/a4QN7SJpWI5DT70PS9g7gVrY8iao+czypzV9o/9zZXdQcw1ws5gp/dRGrKbaboXWE1JNy4L6EUXmULMuA9SXWbF5tXRsgMAw1DaaxLywiPiIMuyX7ZpB7URaRLD4BVwY4OJKU5hsABv3qdBDoMQ9Gn9uj/IqAX+C3m1Vvewx2TyuWruNmaDnXC+PdLlb7zN/wu5nGLArTn4M0Y7geF0FV7LmTgIGR1DzE1ZHCF7dFGdgyQbEwb9PBisbpG4exVl2UhPMlMWrjRsf9p+my7YVvASvvuOnoQL1WOOVzk3JEkP90CcNFgotm/snhSBfqxmRDUxAGP8klBavWOEq2gA4kt2XCsyYogaE9igSeAuUWEjocMxPJi5ndrF3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199018)(54906003)(6916009)(41300700001)(38100700002)(38070700005)(36756003)(7416002)(186003)(6506007)(8936002)(2906002)(478600001)(71200400001)(6486002)(26005)(82960400001)(66556008)(5660300002)(86362001)(6512007)(2616005)(66476007)(64756008)(66446008)(76116006)(66946007)(8676002)(91956017)(4326008)(83380400001)(316002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZS8rZXBhRGtzOVNkSTRWNlpFOVdpV01QQUhiemVwMlF5UG96MWNicm5WeVo2?=
 =?utf-8?B?NmVyeVh6MC9uSXhKcnZpYlBnTGg2YkhYMlVXZHdBMnl2M0V2bitwNlkwdmhh?=
 =?utf-8?B?a01zWmlxd0pnTFF0cnZjdnFBNkRhNXM3RVNsYk1nRzVGb1JXWUZnbm03NElE?=
 =?utf-8?B?cmNyTllsRHAwQmU0T3RkblQzb1F5cGs5ZWdXYnk1TEVhRmVuZFhiYkFjSDRH?=
 =?utf-8?B?TkMwV2JQYVc5MFBFM3psT0NqQUxkcTlvbXdLTjN1aHBRUzZESlc3OXVyK3VD?=
 =?utf-8?B?WVd6Ty9BanByc0Nna2pKK2p4VmNFaTRZaFI2RDEzL3MrckdUM3NmUkMyVkpx?=
 =?utf-8?B?TVB6VEpwbzc5cHJkcnFBeTgvbmlpVld2V1BTZzZZMjlkK1RvUkxMUWFxTjlN?=
 =?utf-8?B?L3ZOY2VnOXZtbDNxTnlGWGc2TCtUWkY2R2x1RkszLzg0cHdZZ2dvWE40RDZW?=
 =?utf-8?B?aHVlNFhMODRBV1BPWXY3VVdEVUliQ1BYZFJ3Z2tOaTczbTVZVHVEVXE5S0tt?=
 =?utf-8?B?ejNlTXkyM1dxdnkrVXNQZFRtZjZwWW1CeHRmVE1OckVyYmphdGtmSzhMTXM3?=
 =?utf-8?B?b0ZpRFpmM09jS3IrWWtHQXV1UXVWekNVR0FCTFF3NTVmdFI0eXoweEk0aUE3?=
 =?utf-8?B?alMrZEJtRStRWlQyanhpZmFUdlhFVlNIWlYrTmZRM0hIVmhPTTI2UU1mdmdS?=
 =?utf-8?B?NmxlbEpwNm94MklQSks1QXpqVXROQWtMTDh3aVdJTjFQL09QMnduNXN2ditD?=
 =?utf-8?B?RkVGL2VYTHFPcTdDQllYekthRExYRXIyTksvNm5TMEtPUG5UaVplWERPQVV4?=
 =?utf-8?B?MHhxd0hpWG1rczEwNFBaY2wvWkpCeG52cG95d3Z5UDVVUTZud1hLMEZCdFhM?=
 =?utf-8?B?U3N0TjQ5RXE5WFB1ckdsZWZ2Uys0QUNtU3p0WWJYRzBmVDNlQzk0cFhld2lj?=
 =?utf-8?B?Mmp3UjI4Qjh6SDRHMW02UGhWUXc5T2toam1kN3pTVXpJbkExUFVTb1JFK1RZ?=
 =?utf-8?B?cmZYZ0hTeVprKzBDTkl4VGhhNFVWOW9Ld0RmNXhiR1drclFFU1FUNFd0R2p4?=
 =?utf-8?B?N2VaOUUxZURZdXQvMUpUamgyalltTWJNYmMvUm5sbkZzWHd2LzJPVVZYSE1o?=
 =?utf-8?B?Ly9nbldveFZqYTZZekNIcC9KVTFmOFBkU2RpU09SWC84aFplTHlxdGdkMWRP?=
 =?utf-8?B?MDkzaW14UVVtdUlxSk1pNDkvTW4rR1lrSlJ0VXJDMVFKc2RnYzNIcVd3WmZQ?=
 =?utf-8?B?L0NsREN2N0xnbFBUYW5FcXFOUlN1MnBjcGdVbEhkSkFEMzRYd3U4dFpXTlgv?=
 =?utf-8?B?Y1pqUjhBemxJbjFhai8xWVMzQ3BxZGFFek9WQ0d3dUluVGVHUC9OekpqdVZU?=
 =?utf-8?B?ZVZVZ0YrMUhFeW1nYTY0Qkx1SHhFK0JxNlpwUG9tekxnL2VPcWNmb3g3M1dz?=
 =?utf-8?B?ckNhRC9HTEJiNUovdW1DVGQ4OW84WFVyM2djcG5QQmkyT1ZGMndRMjVIaW43?=
 =?utf-8?B?cVFXRVBRUDlGUlMwNjJpSlpZWm1BdTdZRHZBSm1yUzFTNVVYN3pDVzdTZW5B?=
 =?utf-8?B?OGxTMFJFdmtmUjB0NHFKR1N0RVY1clRaMlZTMXRqUVVyVzRDNEk1YkdUN24v?=
 =?utf-8?B?NDV0c0lSQjZQSXhMZGR4S3VhS3Z3VkwxbFVlbUZobXV1WDdVc2ZXR2ZtYmxR?=
 =?utf-8?B?U0FaYTgvdTlTeGcwOUpyWUI2RFFINWJEREkvMUw5NzFFOGV2NytCWmdjYUh0?=
 =?utf-8?B?QjR3RVBpQXd2Y1hBYUwrckFualBlVjBvUFc2YlNTaHMxS1IyMHVJQzltMksy?=
 =?utf-8?B?bk5qb2hIT1lBekk4cnpsL0VxTlZiUTlKc0lidmllRE1WVkZHK3lZLzVIN21p?=
 =?utf-8?B?YUZENTFoQVFOZkswcHNxUGpvcGlXK0ZQdDJVRWpOZHdWbjQrUFIwRk5QTndV?=
 =?utf-8?B?WDhkWDlmTVJKVWRtVDFRQVBkTXBoQjcxRThKV3o2U2MrVVYzRmNaMGNQRHBV?=
 =?utf-8?B?ZStBUElNTUdtRzNERGR3NU9sNDhxNDVOQXZFMk83amhoTUZpYWUvQWtIUDdn?=
 =?utf-8?B?Q0JEelc3RUp0ODBnazBtWjZSR1B6MkR0bzUxTFUzbjhJR0NlaEVxQzhKenU3?=
 =?utf-8?B?bUhIaDVXTEhUWlV4TmVlN2x1Vis1WGRKbERiOVczR3JKT29qSWFhL1hSaXVo?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EB61D0F50027F4183265F1D8649AE60@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 615ff03e-7235-4748-5aa5-08db0ecec23c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 21:02:18.7688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PVAjkF8Bb1NzyWYRzbZmC/ecHoDpJKVNp9dh/4doKoRFjGGrPLuffOTavR803dYLhNKI+DeezishirtCO8UtPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4628
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTE0IGF0IDEzOjQyICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBGZWIgMTQsIDIwMjMgYXQgMTI6NTk6MTJBTSArMTMwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiA+ICsvKg0KPiA+ICsgKiBXcmFwcGVyIG9mIF9fc2VhbWNhbGwoKSB0byBjb252ZXJ0
IFNFQU1DQUxMIGxlYWYgZnVuY3Rpb24gZXJyb3IgY29kZQ0KPiA+ICsgKiB0byBrZXJuZWwgZXJy
b3IgY29kZS4gIEBzZWFtY2FsbF9yZXQgYW5kIEBvdXQgY29udGFpbiB0aGUgU0VBTUNBTEwNCj4g
PiArICogbGVhZiBmdW5jdGlvbiByZXR1cm4gY29kZSBhbmQgdGhlIGFkZGl0aW9uYWwgb3V0cHV0
IHJlc3BlY3RpdmVseSBpZg0KPiA+ICsgKiBub3QgTlVMTC4NCj4gPiArICovDQo+ID4gK3N0YXRp
YyBpbnQgX19hbHdheXNfdW51c2VkIHNlYW1jYWxsKHU2NCBmbiwgdTY0IHJjeCwgdTY0IHJkeCwg
dTY0IHI4LCB1NjQgcjksDQo+ID4gKwkJCQkgICAgdTY0ICpzZWFtY2FsbF9yZXQsDQo+ID4gKwkJ
CQkgICAgc3RydWN0IHRkeF9tb2R1bGVfb3V0cHV0ICpvdXQpDQo+ID4gK3sNCj4gPiArCWludCBj
cHUsIHJldCA9IDA7DQo+ID4gKwl1NjQgc3JldDsNCj4gPiArDQo+ID4gKwkvKiBOZWVkIGEgc3Rh
YmxlIENQVSBpZCBmb3IgcHJpbnRpbmcgZXJyb3IgbWVzc2FnZSAqLw0KPiA+ICsJY3B1ID0gZ2V0
X2NwdSgpOw0KPiA+ICsNCj4gPiArCXNyZXQgPSBfX3NlYW1jYWxsKGZuLCByY3gsIHJkeCwgcjgs
IHI5LCBvdXQpOw0KPiA+ICsNCj4gPiArCS8qIFNhdmUgU0VBTUNBTEwgcmV0dXJuIGNvZGUgaWYg
dGhlIGNhbGxlciB3YW50cyBpdCAqLw0KPiA+ICsJaWYgKHNlYW1jYWxsX3JldCkNCj4gPiArCQkq
c2VhbWNhbGxfcmV0ID0gc3JldDsNCj4gPiArDQo+ID4gKwkvKiBTRUFNQ0FMTCB3YXMgc3VjY2Vz
c2Z1bCAqLw0KPiA+ICsJaWYgKCFzcmV0KQ0KPiA+ICsJCWdvdG8gb3V0Ow0KPiANCj4gSSdtIHRo
aW5raW5nIHlvdSB3YW50IGlmIChsaWtlbHkoIXNyZXQpKSwgaGVyZS4gVGhhdCB3aG9sZSBzd2l0
Y2ggdGhpbmcNCj4gc2hvdWxkIGVuZCB1cCBpbiBjb2xkIHN0b3JhZ2UuDQo+IA0KDQpUaGFua3Mg
UGV0ZXIuICBXaWxsIGRvLg0KDQo+ID4gKw0KPiA+ICsJc3dpdGNoIChzcmV0KSB7DQo+ID4gKwlj
YXNlIFREWF9TRUFNQ0FMTF9HUDoNCj4gPiArCQkvKg0KPiA+ICsJCSAqIHRkeF9lbmFibGUoKSBo
YXMgYWxyZWFkeSBjaGVja2VkIHRoYXQgQklPUyBoYXMNCj4gPiArCQkgKiBlbmFibGVkIFREWCBh
dCB0aGUgdmVyeSBiZWdpbm5pbmcgYmVmb3JlIGdvaW5nDQo+ID4gKwkJICogZm9yd2FyZC4gIEl0
J3MgbGlrZWx5IGEgZmlybXdhcmUgYnVnIGlmIHRoZQ0KPiA+ICsJCSAqIFNFQU1DQUxMIHN0aWxs
IGNhdXNlZCAjR1AuDQo+ID4gKwkJICovDQo+ID4gKwkJcHJfZXJyX29uY2UoIltmaXJtd2FyZSBi
dWddOiBURFggaXMgbm90IGVuYWJsZWQgYnkgQklPUy5cbiIpOw0KPiA+ICsJCXJldCA9IC1FTk9E
RVY7DQo+ID4gKwkJYnJlYWs7DQo+ID4gKwljYXNlIFREWF9TRUFNQ0FMTF9WTUZBSUxJTlZBTElE
Og0KPiA+ICsJCXByX2Vycl9vbmNlKCJURFggbW9kdWxlIGlzIG5vdCBsb2FkZWQuXG4iKTsNCj4g
PiArCQlyZXQgPSAtRU5PREVWOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJY2FzZSBURFhfU0VBTUNB
TExfVUQ6DQo+ID4gKwkJcHJfZXJyX29uY2UoIlNFQU1DQUxMIGZhaWxlZDogQ1BVICVkIGlzIG5v
dCBpbiBWTVggb3BlcmF0aW9uLlxuIiwNCj4gPiArCQkJCWNwdSk7DQo+ID4gKwkJcmV0ID0gLUVJ
TlZBTDsNCj4gPiArCQlicmVhazsNCj4gPiArCWRlZmF1bHQ6DQo+ID4gKwkJcHJfZXJyX29uY2Uo
IlNFQU1DQUxMIGZhaWxlZDogQ1BVICVkOiBsZWFmICVsbHUsIGVycm9yIDB4JWxseC5cbiIsDQo+
ID4gKwkJCQljcHUsIGZuLCBzcmV0KTsNCj4gPiArCQlpZiAob3V0KQ0KPiA+ICsJCQlwcl9lcnJf
b25jZSgiYWRkaXRpb25hbCBvdXRwdXQ6IHJjeCAweCVsbHgsIHJkeCAweCVsbHgsIHI4IDB4JWxs
eCwgcjkgMHglbGx4LCByMTAgMHglbGx4LCByMTEgMHglbGx4LlxuIiwNCj4gPiArCQkJCQlvdXQt
PnJjeCwgb3V0LT5yZHgsIG91dC0+cjgsDQo+ID4gKwkJCQkJb3V0LT5yOSwgb3V0LT5yMTAsIG91
dC0+cjExKTsNCj4gPiArCQlyZXQgPSAtRUlPOw0KPiA+ICsJfQ0KPiA+ICtvdXQ6DQo+ID4gKwlw
dXRfY3B1KCk7DQo+ID4gKwlyZXR1cm4gcmV0Ow0KPiA+ICt9DQo+IA0KDQo=
