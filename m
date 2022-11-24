Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8526377AB
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 12:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiKXL3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 06:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKXL3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 06:29:44 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71714BF52;
        Thu, 24 Nov 2022 03:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669289383; x=1700825383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9CQBWZORcCWerU30XLWc6j/RDISvwfeJxuXGechJBWs=;
  b=T8CihzT0zUaSTCFHkamAqLxNXr9ZY071Jdir2V0pm075G9TdKd4+njzM
   rcJPEo3snJ4XuC6ONifVLjd7+MfonNVPqIG59VCt8NWpbZn8yL3dSkN9I
   lw80ajKInL+9szSTJgRkvnDfYn1Rz/JARxkpL3ofPekZn+r80k6tb9YJA
   arZ+r/A3JPjX3yficHGJ7JLWkhYwNJLa5ZRavavEzui7XncrLlDzVz8Xy
   byPUcL8BvmgduMJYqqzee5FPVwsX8tTzlpFBBXfeziG8n9Kr2H8ztseW/
   3jT2nVCqmKGV231QGiRynZTMx6RTIEPUvfXomRlLYBxxos74rlSvvuPtu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301844295"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="301844295"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 03:29:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887341976"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="887341976"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2022 03:29:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 03:29:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 03:29:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 03:29:41 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 03:29:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DI+tN+UweaOTbq9yfU6gtt2lXihBUVVBcyjZ6rL8HrQMgVhAuCZGR/aZJQttW2BBZd0/oQvR8LSS1aypuih2aKIgUoizWq13NMAto0l9YBwSD7S5lYJKa7JYKOHB16oLvxdfZjGNVd5iN12a/VIqZLIbXX8IMh0ryUlbS6bC6trxLyYYNIxdXbzFZObwgwH+ooipe7qteMmQxIHEVfmbYPsG8tVMY4I1VTUuoHPe1cL5uOpo/gm87k42mqJg5BeZ8QlOaTDYoVHzmjDyhTgNuymp8N0+TZotDxaBr13KngcJcnzt7U5fARuOVmnFg/76XjpX+RfJbj/dsIGS/o/x/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CQBWZORcCWerU30XLWc6j/RDISvwfeJxuXGechJBWs=;
 b=NbtsH4ao2UHFytiBn78PdyvwcBUKkxK5xonfgJBBEnD02sSX/YJpxx6NH2aJB6MkKlb5qGZmJBp1hvfjgSOsbdEALBCNLzFtCHDO2qNaAhKwLHvi2std80hrXckO+5EALKaUd/cfWKF8flr9pPMuba8gI2gSGk6QJxeqPE86ASQtB2HgtESC6gQHkH56ajfLiUDmymB+zc001zdmky7LODcvTEE4Lk1w8rNB9bySot47KfuM1F9bsVW+vK0ccU2aRiSGACsnlBCdczZfI6OfCP9yWjeIQfb0nyOid7Bb1PXQ4IVg/VzgZEfBEeJts/bljKRYaU5UWtLDmOVVFlC7Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6107.namprd11.prod.outlook.com (2603:10b6:a03:48a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Thu, 24 Nov
 2022 11:29:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 11:29:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 12/20] x86/virt/tdx: Create TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v7 12/20] x86/virt/tdx: Create TDMRs to cover all TDX
 memory regions
Thread-Index: AQHY/T3Ol00T/K+q7EGCwmf+srRgpa5NHxeAgADWewA=
Date:   Thu, 24 Nov 2022 11:29:35 +0000
Message-ID: <d2b0327fb2e26966162d435df2aaf281fe5c2737.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <4db59b4a87f0309c29e61a79892b9fa6645754a8.1668988357.git.kai.huang@intel.com>
         <d84ad1d2-83f9-dab5-5639-8d71f382e3ff@intel.com>
In-Reply-To: <d84ad1d2-83f9-dab5-5639-8d71f382e3ff@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6107:EE_
x-ms-office365-filtering-correlation-id: a0a19896-1335-4fdf-c562-08dace0f2a85
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rDdpXig6fdh/6wZt5WdrI5ANgCViDYy8/48Xc8FvYdSGe7wx99hS7ZXl44LaHZS7kzpWHBQiLIPurKlsE1POUJWkjNLo+GNojvJUdhKLMDsT3PzIfybReOsHK9JEjKRf7TT+sm9hySQIClx7cbM87Qiovc5JbK8cHsnJlDHJONszzze3bqzsEFOTQnvNZMZq0FlvjjN3khxef7SVTA4Vufl29vZR4aoxuVG203gszYfqAYWg0lVSCQXwzvJq/+ZkNVoyUO3LNybBjVTygodhq9lRQRkyQ8cNEMlUA7kzTFZREVY8kAe6Mq6mt/E55z46d/kjKtVzZKt7b3MPBx/rTNkp3rShT9pnQ2Ketxtq+TPBwEBRiqY93JfEykUx98M4iD/AN4f9T0MoBF/cNa5iBliuP5fCef/e+7RqQh7IodoB3+qgOnCXvyThbP08fvQ7L0cVsCZD3WboL05OBqi5qZ8Y4KSNI2/pqJvMbOzEvwlo1QP8s2r+nrlMvIS+dK9HTSDAAGil6PGaYysa4ZyItro5psKnx9lm7EZXDqXM/hMImr/nlnZ8B/wVGwBTvtb364vPx8+qoCcEoXQxg/Ee3wFiOf1vNbH9ZUrjwBCCMzQD0WvkdbiGTFx9YZEMV3VVB3p4ed9YjC8ZunRJBb4Df11+LZ70/M4MJyO88BduvqfEzlE55H/awtZJUgN58jTxfaOL7Glew7WCjy/VwY5SOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(64756008)(122000001)(83380400001)(66476007)(82960400001)(86362001)(76116006)(6512007)(38100700002)(316002)(66556008)(26005)(66446008)(7416002)(2906002)(36756003)(2616005)(186003)(41300700001)(5660300002)(4326008)(91956017)(8936002)(71200400001)(38070700005)(66946007)(8676002)(478600001)(6506007)(6486002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDB5VUNyQzhzV1E4TndVaHBWOTlHQW5tald1L09CanUyZXp1NGp4V3Bjdldq?=
 =?utf-8?B?RnphRDdPQnd6YUxGTVJYcTR5OGZ1ZTdhZ2tDQklmdEZQdC8rOFdBZ05JTEpi?=
 =?utf-8?B?eVV2ekYxazN6aDQ0cm1FVnlOWWc1L1lCaFNzRVBDaUpvbnAwNDlNNy9USFRV?=
 =?utf-8?B?dCtHd0FZZldNaHgyQXJXSnl1blpVcnhJVGhzYmpGZk5Yd1REbVQ1dlRvMFg0?=
 =?utf-8?B?U01STGQ3ME8xL0hjUk5mSWNGZkdtditxWkM2OTFHZEpyQ0hLWXhpNG5IOERV?=
 =?utf-8?B?dnE2SjBvR21NdXc2UVZ5ajZCMUtsMTNVSnZrd2ZCOUpUcXdTaTZtYy8zZ1Jo?=
 =?utf-8?B?Y3lPMUtRempwbVlER3dHa011U2tuZmN6MlB3U215clBPK3M0ZVByRmM4eXM0?=
 =?utf-8?B?cVdobGh4MGMxK1NvUFd1NjNiU3Y1cjRaWUV3SEhKWmw5MnN4N1B2a3ZDdFg4?=
 =?utf-8?B?Yk9mWkZNWWFHQUtubDZ5MGx2ZlpwbnlzRzBHZEw5WUplK2s4VkFVbzdia0t0?=
 =?utf-8?B?MzVHaHNlWGc3TkRhQVFGZXhZLzlEQ0JZZDNRVWd2YVVCZjE2NFVJMnArYUVo?=
 =?utf-8?B?VDdBVlVmWWZWb01MNDFxZzJubTVQMHF5UnQxczNlMXp2RExYUFJCMWtkcHVu?=
 =?utf-8?B?clBuNmQ5S3NPdXBDV2RCWlFjVHRlb0NFaUtlM0pncDc4S3JhRjFPRzNZMHBw?=
 =?utf-8?B?ZktqMG02bXVrZHU1cEUrbCtoQktMczRyVmI5eDd4ZzRBd2NzaTA4RjZZZ0lY?=
 =?utf-8?B?d3ZsN20zWTFuNlBzWEliME8vUDIycmZmVVZlTkxscW1SN3VOcGFXTVVZQkx2?=
 =?utf-8?B?MGN6aDNEYVJBVU4rRnFacVdOVUxMUERyQmc2bWx1blRhTGpab0ljOFU3bVla?=
 =?utf-8?B?OTJpN2tOQVRDNldjbW1UZ1VwY1Npc0cyeXU3UUZsUkJ2a2xMYWZjbWhQeUtr?=
 =?utf-8?B?VnhCNGZndktXRnVLelBBWXJjS2FEVFJjTjg2UnZnQmRjeTVNZ29Kam1ySXhn?=
 =?utf-8?B?Nll6dENWWVNkMFVCVDRNRWNCUFZTVlBGMU8rQnFvUFNPcXhhdTVXaFVMeGdF?=
 =?utf-8?B?b1V5aHdtUmhtMGc5eVkxdFhRcHNZbWpMcDZEak0rSVdsRUtmYWgyTnk1N25i?=
 =?utf-8?B?cFRuODU4V2hUYjQ0VGxnSjY5NWVuU2xpbEJWbzB2K2wzTFhxdjFOejBrbDdS?=
 =?utf-8?B?ZFhjemVlSGZWajRQMWxiVm9KNS9TU1MyT1d3S3hoS0F5RHJoNXFOYjQwWThI?=
 =?utf-8?B?blRKcFBrOFVWN2gyOU1NUnRFTExEK3B6TjBMc2p5blErQkxLT2FUNklYc1hT?=
 =?utf-8?B?TUFueXczZmxTOElNSHdHY0JvbWFQczJGalJ0bE8xRlhNSmdrK0hOL2RkYnFQ?=
 =?utf-8?B?enVMVXVVei80NVd4UGxjQllRREJWcUlzTTF6MGw2VjVlOFVDclBGUlFEZ0Nh?=
 =?utf-8?B?L2RWOEJYSGp3Z0RBZVR0WG8wd0ZhaDlMYU5tSHV0TDdXaE9Wd05pNkQ3ZEtk?=
 =?utf-8?B?MnNlM2xKc1lGU2hQMmIxYjN4d2c2SW0vdEMwUHBNeWY1M21qWnFUbVJQbC9k?=
 =?utf-8?B?M1BJeWxHNlcxRC9zQi9DYnlCYkl5RVd0MGw2WWdyMGtYVVJrdC9WazdDUk5x?=
 =?utf-8?B?cXVscUt1NklUZGI4cGl0MVIzUzRVWTZiNVBqYTRyU3BwclNvTHIyQUl0NXNJ?=
 =?utf-8?B?L2dLaXdWeGVIK2VPM2JaSzBsbXFUdnA2ZzR6Y21OdnVOY2lqUmNZOGpnVVlK?=
 =?utf-8?B?U25hRVNkZmU3OU1FMmNGalVoa2p2Nytkd25ZL3FTNlpuOWR5RTN6YWI3ZGgx?=
 =?utf-8?B?SnpGL0lvdmYxdlhaMTVYVnBhZllvSWh1SjhvdVV0emNLSHhSWWZ5TXhFUkZ0?=
 =?utf-8?B?SlpPZHhjK2pKWGIxaFpONE5Xc3hLM1h0S3QveTdRWVp4NmRhU01IYzlYSGVX?=
 =?utf-8?B?VUFQR1ZGb3pGWFQ0NXYvalhNNXVmK09nanIrNnNPL1VIODE2Q2JpdUQyUW9N?=
 =?utf-8?B?c2hRcmdnRFBRQlRHOEJURkFXWlVnY1dCb1JJd0k2MXMvN2hkTnY3MVNSTFBL?=
 =?utf-8?B?WVd0amJTZXhxM0FHdkpVSHoyT2tCbXAycUZvaERySnQxU1dGSTZ2b28rb1JD?=
 =?utf-8?B?V2F4ekJFZVljMkdWSmRNU0JCNEFSU1BZMTRNQ0JISzFIc1lnL3IranZVQlFT?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60E54E6A51DDF2469FCCEACD37319BCA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a19896-1335-4fdf-c562-08dace0f2a85
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 11:29:35.9431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gAj5CWSx8fB+HwGy386FiRmoLSBo925EXuHHU5dKNe1ICVReUn09JLjOwB7W7OQ5RU/Taw39Ik9iVsWKtSVYCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6107
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

DQo+ID4gK3N0YXRpYyBpbmxpbmUgdTY0IHRkbXJfc3RhcnQoc3RydWN0IHRkbXJfaW5mbyAqdGRt
cikNCj4gPiArew0KPiA+ICsJcmV0dXJuIHRkbXItPmJhc2U7DQo+ID4gK30NCj4gDQo+IEknbSBh
bHdheXMgc2tlcHRpY2FsIHRoYXQgaXQncyBhIGdvb2QgaWRlYSB0byB0YWtlIHRoaXMgaW4gY29k
ZToNCj4gDQo+IAl0ZG1yLT5iYXNlDQo+IA0KPiBhbmQgbWFrZSBpdCB0aGlzOg0KPiANCj4gCXRk
bXJfc3RhcnQodGRtcikNCj4gDQo+IGJlY2F1c2UgdGhlIGhlbHBlciBpcyAqTEVTUyogY29tcGFj
dCB0aGFuIHRoZSBvcGVuLWNvZGVkIGZvcm0hICBJIGhvcGUNCj4gSSdtIHByb3ZlbiB3cm9uZy4N
Cg0KSUlVQyB5b3UgcHJlZmVyIHVzaW5nIHRkbXItPmJhc2UgZGlyZWN0bHkuIFdpbGwgZG8uDQoN
Cj4gDQo+ID4gK3N0YXRpYyBpbmxpbmUgdTY0IHRkbXJfZW5kKHN0cnVjdCB0ZG1yX2luZm8gKnRk
bXIpDQo+ID4gK3sNCj4gPiArCXJldHVybiB0ZG1yLT5iYXNlICsgdGRtci0+c2l6ZTsNCj4gPiAr
fQ0KPiA+ICsNCj4gPiAgLyogQ2FsY3VsYXRlIHRoZSBhY3R1YWwgVERNUl9JTkZPIHNpemUgKi8N
Cj4gPiAgc3RhdGljIGlubGluZSBpbnQgY2FsX3RkbXJfc2l6ZSh2b2lkKQ0KPiA+ICB7DQo+ID4g
QEAgLTQ5MiwxNCArNTEwLDk4IEBAIHN0YXRpYyBzdHJ1Y3QgdGRtcl9pbmZvICphbGxvY190ZG1y
X2FycmF5KGludCAqYXJyYXlfc3opDQo+ID4gIAlyZXR1cm4gYWxsb2NfcGFnZXNfZXhhY3QoKmFy
cmF5X3N6LCBHRlBfS0VSTkVMIHwgX19HRlBfWkVSTyk7DQo+ID4gIH0NCj4gPiAgDQo+ID4gK3N0
YXRpYyBzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yX2FycmF5X2VudHJ5KHN0cnVjdCB0ZG1yX2luZm8g
KnRkbXJfYXJyYXksDQo+ID4gKwkJCQkJICBpbnQgaWR4KQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4g
KHN0cnVjdCB0ZG1yX2luZm8gKikoKHVuc2lnbmVkIGxvbmcpdGRtcl9hcnJheSArDQo+ID4gKwkJ
CWNhbF90ZG1yX3NpemUoKSAqIGlkeCk7DQo+ID4gK30NCj4gDQo+IEZXSVcsIEkgdGhpbmsgaXQn
cyBwcm9iYWJseSBhIGJhZCBpZGVhIHRvIGhhdmUgJ3N0cnVjdCB0ZG1yX2luZm8gKicNCj4gdHlw
ZXMgZmxvYXRpbmcgYXJvdW5kIHNpbmNlOg0KPiANCj4gCXRtZHJfaW5mb19hcnJheVswXQ0KPiAN
Cj4gd29ya3MsIGJ1dDoNCj4gDQo+IAl0bWRyX2luZm9fYXJyYXlbMV0NCj4gDQo+IHdpbGwgYmxv
dyB1cCBpbiB5b3VyIGZhY2UuICBJdCB3b3VsZCBhbG1vc3QgbWFrZSBzZW5zZSB0byBoYXZlDQo+
IA0KPiBzdHJ1Y3QgdGRtcl9pbmZvX2xpc3Qgew0KPiAJc3RydWN0IHRkbXJfaW5mbyAqZmlyc3Rf
dGRtcjsNCj4gfQ0KPiANCj4gYW5kIHRoZW4gcGFzcyBhcm91bmQgcG9pbnRlcnMgdG8gdGhlICdz
dHJ1Y3QgdGRtcl9pbmZvX2xpc3QnLiAgTWF5YmUNCj4gdGhhdCdzIG92ZXJraWxsLCBidXQgaXQg
aXMga2luZGEgc2lsbHkgdG8gY2FsbCBzb21ldGhpbmcgYW4gYXJyYXkgaWYgW10NCj4gZG9lc24n
dCB3b3JrIG9uIGl0Lg0KDQpUaGVuIHNob3VsZCBJIGludHJvZHVjZSAnc3RydWN0IHRkbXJfaW5m
b19saXN0JyBpbiB0aGUgcHJldmlvdXMgcGF0Y2ggKHdoaWNoDQphbGxvY2F0ZXMgZW5vdWdoIHNw
YWNlIGZvciB0aGUgdGRtcl9hcnJheSksIGFuZCBhZGQgZnVuY3Rpb25zIHRvIGFsbG9jYXRlL2Zy
ZWUNCnRoaXMgdGRtcl9pbmZvX2xpc3Q/DQoNCj4gDQo+ID4gKy8qDQo+ID4gKyAqIENyZWF0ZSBU
RE1ScyB0byBjb3ZlciBhbGwgVERYIG1lbW9yeSByZWdpb25zLiAgVGhlIGFjdHVhbCBudW1iZXIN
Cj4gPiArICogb2YgVERNUnMgaXMgc2V0IHRvIEB0ZG1yX251bS4NCj4gPiArICovDQo+ID4gK3N0
YXRpYyBpbnQgY3JlYXRlX3RkbXJzKHN0cnVjdCB0ZG1yX2luZm8gKnRkbXJfYXJyYXksIGludCAq
dGRtcl9udW0pDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhfbWVtYmxvY2sgKnRtYjsNCj4gPiAr
CWludCB0ZG1yX2lkeCA9IDA7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIExvb3Agb3ZlciBU
RFggbWVtb3J5IHJlZ2lvbnMgYW5kIGNyZWF0ZSBURE1ScyB0byBjb3ZlciB0aGVtLg0KPiA+ICsJ
ICogVG8ga2VlcCBpdCBzaW1wbGUsIGFsd2F5cyB0cnkgdG8gdXNlIG9uZSBURE1SIHRvIGNvdmVy
DQo+ID4gKwkgKiBvbmUgbWVtb3J5IHJlZ2lvbi4NCj4gPiArCSAqLw0KPiANCj4gVGhpcyBzZWVt
cyBsaWtlIGl0IG1pZ2h0IHRlbmQgdG8gdW5kZXItdXRpbGl6ZSBURE1Scy4gIEknbSBzdXJlIHRo
aXMgaXMNCj4gZG9uZSBmb3Igc2ltcGxpY2l0eSwgYnV0IGlzIGl0IE9LPyAgV2h5IGlzIGl0IE9L
PyAgSG93IGFyZSB5b3Ugc3VyZSB0aGlzDQo+IHdvbid0IGJpdGUgdXMgbGF0ZXI/DQoNCkluIHBy
YWN0aWNlIHRoZSBtYXhpbXVtIG51bWJlciBvZiBURE1ScyBpcyA2NC4gIEluIHJlYWxpdHkgd2Ug
bmV2ZXIgbWV0IGENCm1hY2hpbmUgdGhhdCBjb3VsZCByZXN1bHQgaW4gc28gbWFueSBtZW1vcnkg
cmVnaW9ucywgYW5kIHR5cGljYWxseSAyMCBURE1ScyBpcw0KYmlnIGVub3VnaCB0byBjb3ZlciB0
aGVtLg0KDQpCdXQgaWYgdXNlciB1c2VzICdtZW1tYXAnIHRvIGRlbGliZXJhdGVseSBjcmVhdGUg
YnVuY2ggb2YgZGlzY3JldGUgbWVtb3J5DQpyZWdpb25zLCB0aGVuIHdlIGNhbiBydW4gb3V0IG9m
IFRETVJzLiAgQnV0IEkgdGhpbmsgd2UgY2FuIGJsYW1lIHVzZXIgaW4gdGhpcw0KY2FzZS4NCg0K
SG93IGFib3V0IGFkZCBhIGNvbW1lbnQ/DQoNCgkvKg0KCSAqIEluIHByYWN0aWNlIFREWDEuMCBz
dXBwb3J0cyA2NCBURE1Scywgd2hpY2ggc2hvdWxkIGJlIGJpZyBlbm91Z2gNCgkgKiB0byBjb3Zl
ciBhbGwgbWVtb3J5IHJlZ2lvbnMgaW4gcmVhbGl0eSBpZiBhZG1pbiBkb2Vzbid0IHVzZSAnbWVt
bWFwJw0KCSAqIHRvIGNyZWF0ZSBidW5jaCBvZiBkaXNjcmV0ZSBtZW1vcnkgcmVnaW9ucy4NCgkg
Ki8NCg0KPiANCj4gPiArCWxpc3RfZm9yX2VhY2hfZW50cnkodG1iLCAmdGR4X21lbWxpc3QsIGxp
c3QpIHsNCj4gPiArCQlzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yOw0KPiA+ICsJCXU2NCBzdGFydCwg
ZW5kOw0KPiA+ICsNCj4gPiArCQl0ZG1yID0gdGRtcl9hcnJheV9lbnRyeSh0ZG1yX2FycmF5LCB0
ZG1yX2lkeCk7DQo+ID4gKwkJc3RhcnQgPSBURE1SX0FMSUdOX0RPV04odG1iLT5zdGFydF9wZm4g
PDwgUEFHRV9TSElGVCk7DQo+ID4gKwkJZW5kID0gVERNUl9BTElHTl9VUCh0bWItPmVuZF9wZm4g
PDwgUEFHRV9TSElGVCk7DQo+IA0KPiBOaXQ6IGEgbGl0dGxlIHZlcnRpY2FsIGFsaWdubWVudCBj
YW4gbWFrZSB0aGlzIG11Y2ggbW9yZSByZWFkYWJsZToNCj4gDQo+IAkJc3RhcnQgPSBURE1SX0FM
SUdOX0RPV04odG1iLT5zdGFydF9wZm4gPDwgUEFHRV9TSElGVCk7DQo+IAkJZW5kICAgPSBURE1S
X0FMSUdOX1VQICAodG1iLT5lbmRfcGZuICAgPDwgUEFHRV9TSElGVCk7DQoNClN1cmUuIA0KDQpC
dHcgWWluZyBzdWdnZXN0ZWQgd2UgY2FuIHVzZSBQSFlTX1BGTigpIGZvcsKgDQoJDQoJPHBoeXM+
ID4+IFBBR0VfU0hJRlQNCg0KYW5kIFBGTl9QSFlTKCkgZm9yDQoNCgk8cGZuPiA8PCBQQUdFX1NI
SUZUDQoNClNob3VsZCBJIGFwcGx5IHRoZW0gdG8gdGhpcyBlbnRpcmUgc2VyaWVzPw0KDQo+IA0K
PiA+ICsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIElmIHRoZSBjdXJyZW50IFRETVIncyBzaXplIGhh
c24ndCBiZWVuIGluaXRpYWxpemVkLA0KPiA+ICsJCSAqIGl0IGlzIGEgbmV3IFRETVIgdG8gY292
ZXIgdGhlIG5ldyBtZW1vcnkgcmVnaW9uLg0KPiA+ICsJCSAqIE90aGVyd2lzZSwgdGhlIGN1cnJl
bnQgVERNUiBoYXMgYWxyZWFkeSBjb3ZlcmVkIHRoZQ0KPiA+ICsJCSAqIHByZXZpb3VzIG1lbW9y
eSByZWdpb24uICBJbiB0aGUgbGF0dGVyIGNhc2UsIGNoZWNrDQo+ID4gKwkJICogd2hldGhlciB0
aGUgY3VycmVudCBtZW1vcnkgcmVnaW9uIGhhcyBiZWVuIGZ1bGx5IG9yDQo+ID4gKwkJICogcGFy
dGlhbGx5IGNvdmVyZWQgYnkgdGhlIGN1cnJlbnQgVERNUiwgc2luY2UgVERNUiBpcw0KPiA+ICsJ
CSAqIDFHIGFsaWduZWQuDQo+ID4gKwkJICovDQo+IA0KPiBBZ2Fpbiwgd2UgaGF2ZSBhIGNvbW1l
bnQgb3ZlciBhIGlmKCkgYmxvY2sgdGhhdCBkZXNjcmliZXMgd2hhdCB0aGUNCj4gaW5kaXZpZHVh
bCBzdGVwcyBpbiB0aGUgYmxvY2sgZG8uICAqUGx1cyogZWFjaCBpbmRpdmlkdWFsIHN0ZXAgaXMN
Cj4gKkFMUkVBRFkqIGNvbW1lbnRlZC4gIFdoYXQgcHVycG9zZSBkb2VzIHRoaXMgY29tbWVudCBz
ZXJ2ZT8NCg0KSSB0aGluayB0aGUgY2hlY2sgb2YgJ2lmICh0ZG1yLT5zaXplKScgaXMgc3RpbGwg
d29ydGggY29tbWVudGluZy4gIFRoZSBsYXN0DQpzZW50ZW5jZSBjYW4gYmUgcmVtb3ZlZCAtLSBh
cyB5b3Ugc2FpZCwgaXQgaXMga2luZGEgZHVwbGljYXRlZCB3aXRoIHRoZQ0KaW5kaXZpZHVhbCBj
b21tZW50cyB3aXRoaW4gdGhlIGlmKCkuDQoNCj4gDQo+ID4gKwkJaWYgKHRkbXItPnNpemUpIHsN
Cj4gPiArCQkJLyoNCj4gPiArCQkJICogTG9vcCB0byB0aGUgbmV4dCBtZW1vcnkgcmVnaW9uIGlm
IHRoZSBjdXJyZW50DQo+ID4gKwkJCSAqIGJsb2NrIGhhcyBhbHJlYWR5IGJlZW4gZnVsbHkgY292
ZXJlZCBieSB0aGUNCj4gPiArCQkJICogY3VycmVudCBURE1SLg0KPiA+ICsJCQkgKi8NCj4gPiAr
CQkJaWYgKGVuZCA8PSB0ZG1yX2VuZCh0ZG1yKSkNCj4gPiArCQkJCWNvbnRpbnVlOw0KPiA+ICsN
Cj4gPiArCQkJLyoNCj4gPiArCQkJICogSWYgcGFydCBvZiB0aGUgY3VycmVudCBtZW1vcnkgcmVn
aW9uIGhhcw0KPiA+ICsJCQkgKiBhbHJlYWR5IGJlZW4gY292ZXJlZCBieSB0aGUgY3VycmVudCBU
RE1SLA0KPiA+ICsJCQkgKiBza2lwIHRoZSBhbHJlYWR5IGNvdmVyZWQgcGFydC4NCj4gPiArCQkJ
ICovDQo+ID4gKwkJCWlmIChzdGFydCA8IHRkbXJfZW5kKHRkbXIpKQ0KPiA+ICsJCQkJc3RhcnQg
PSB0ZG1yX2VuZCh0ZG1yKTsNCj4gPiArDQo+ID4gKwkJCS8qDQo+ID4gKwkJCSAqIENyZWF0ZSBh
IG5ldyBURE1SIHRvIGNvdmVyIHRoZSBjdXJyZW50IG1lbW9yeQ0KPiA+ICsJCQkgKiByZWdpb24s
IG9yIHRoZSByZW1haW5pbmcgcGFydCBvZiBpdC4NCj4gPiArCQkJICovDQo+ID4gKwkJCXRkbXJf
aWR4Kys7DQo+ID4gKwkJCWlmICh0ZG1yX2lkeCA+PSB0ZHhfc3lzaW5mby5tYXhfdGRtcnMpDQo+
ID4gKwkJCQlyZXR1cm4gLUUyQklHOw0KPiA+ICsNCj4gPiArCQkJdGRtciA9IHRkbXJfYXJyYXlf
ZW50cnkodGRtcl9hcnJheSwgdGRtcl9pZHgpOw0KPiA+ICsJCX0NCj4gPiArDQo+ID4gKwkJdGRt
ci0+YmFzZSA9IHN0YXJ0Ow0KPiA+ICsJCXRkbXItPnNpemUgPSBlbmQgLSBzdGFydDsNCj4gPiAr
CX0NCj4gPiArDQo+ID4gKwkvKiBAdGRtcl9pZHggaXMgYWx3YXlzIHRoZSBpbmRleCBvZiBsYXN0
IHZhbGlkIFRETVIuICovDQo+ID4gKwkqdGRtcl9udW0gPSB0ZG1yX2lkeCArIDE7DQo+ID4gKw0K
PiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gDQo+IFNlZW1zIGxpa2UgYSBwb3NpdGl2ZSByZXR1
cm4gdmFsdWUgY291bGQgYmUgdGhlIG51bWJlciBvZiBwb3B1bGF0ZWQNCj4gVERNUnMuICBUaGF0
IHdvdWxkIGdldCByaWQgb2YgdGhlIGludCogYXJndW1lbnQuDQoNClllcyB3ZSBjYW4uICBJJ2xs
IG1ha2UgdGhlIGZ1bmN0aW9uIHJldHVybiAtRTJCSUcsIG9yIHRoZSBhY3R1YWwgbnVtYmVyIG9m
DQpURE1Scy4NCg0KQnR3LCBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvIHByaW50IG91dCBzb21lIGVy
cm9yIG1lc3NhZ2UgaW4gY2FzZSBvZiAtRTJCSUcgc28NCnVzZXIgY2FuIGVhc2lseSB0ZWxsIHRo
ZSByZWFzb24gb2YgZmFpbHVyZT8gIFNvbWV0aGluZyBsaWtlIHRoaXM6DQoNCglpZiAodGRtcl9p
ZHggPj0gdGR4X3N5c2luZm8ubWF4X3RkbXJzKSB7DQoJCXByX2luZm8oIm5vIGVub3VnaCBURE1S
cyB0byBjb3ZlciBhbGwgVERYIG1lbW9yeSByZWdpb25zXG4iKTsNCgkJcmV0dXJuIC1FMkJJRzsN
Cgl9DQoNCj4gDQo+ID4gIC8qDQo+ID4gICAqIENvbnN0cnVjdCBhbiBhcnJheSBvZiBURE1ScyB0
byBjb3ZlciBhbGwgVERYIG1lbW9yeSByYW5nZXMuDQo+ID4gICAqIFRoZSBhY3R1YWwgbnVtYmVy
IG9mIFRETVJzIGlzIGtlcHQgdG8gQHRkbXJfbnVtLg0KPiA+ICAgKi8NCj4gDQo+IE9LLCBzbyBz
b21ldGhpbmcgZWxzZSBhbGxvY2F0ZWQgdGhlICd0ZG1yX2FycmF5JyBhbmQgaXQncyBiZWluZyBw
YXNzZWQNCj4gaW4gaGVyZSB0byBmaWxsIGl0IG91dC4gICJjb25zdHJ1Y3QiIGFuZCAiY3JlYXRl
IiBhcmUgYm90aCBuZWFyIHN5bm9ueW1zDQo+IGZvciAiYWxsb2NhdGUiLCB3aGljaCBpc24ndCBl
dmVuIGJlaW5nIGRvbmUgaGVyZS4NCj4gDQo+IFdlIHdhbnQgc29tZXRoaW5nIGhlcmUgdGhhdCB3
aWxsIG1ha2UgaXQgY2xlYXIgdGhhdCB0aGlzIGZ1bmN0aW9uIGlzDQo+IHRha2luZyBhbiBhbHJl
YWR5IHBvcHVsYXRlZCBsaXN0IG9mIFRETVJzIGFuZCBmaWxsaW5nIGl0IG91dC4NCj4gImZpbGxf
dG1kcnMoKSIgc2VlbXMgbGlrZSBpdCBtaWdodCBiZSBhIGJldHRlciBjaG9pY2UuDQo+IA0KPiBU
aGlzIGlzIGFsc28gYSBwbGFjZSB3aGVyZSBiZXR0ZXIgd29yZHMgY2FuIGhlbHAuICBJZiB0aGUg
ZnVuY3Rpb24gaXMNCj4gY2FsbGVkICJjb25zdHJ1Y3QiLCB0aGVuIHRoZXJlJ3MgKlpFUk8qIHZh
bHVlIGluIHVzaW5nIHRoZSBzYW1lIHdvcmQgaW4NCj4gdGhlIGNvbW1lbnQuICBVc2luZyBhIHdv
cmQgdGhhdCBpcyBhIGNsb3NlIHN5bm9ueW0gYnV0IHRoYXQgY2FuIGNvbnRyYXN0DQo+IGl0IHdp
dGggc29tZXRoaW5nIGRpZmZlcmVudCB3b3VsZCBiZSByZWFsbHkgbmljZSwgc2F5Og0KDQpUaGFu
a3MgZm9yIHRoZSB0aXAhDQo+IA0KPiBUaGlzIGlzIGFsc28gYSBwbGFjZSB3aGVyZSB0aGUgY2Fs
bGluZyBjb252ZW50aW9uIGNhbiBiZSB1c2VkIHRvIGFkZA0KPiBjbGFyaXR5LiAgSWYgeW91IGlt
cGxpY2l0bHkgdXNlIGEgZ2xvYmFsIHZhcmlhYmxlLCB5b3UgaGF2ZSB0byBleHBsYWluDQo+IHRo
YXQuICBCdXQsIGlmIHlvdSBwYXNzICppbiogYSB2YXJpYWJsZSwgaXQncyBhIGxvdCBtb3JlIGNs
ZWFyLg0KPiANCj4gVGFrZSB0aGlzLCBmb3IgaW5zdGFuY2U6DQo+IA0KPiAvKg0KPiAgKiBUYWtl
IHRoZSBtZW1vcnkgcmVmZXJlbmNlZCBpbiBAdGR4X21lbWxpc3QgYW5kIHBvcHVsYXRlIHRoZQ0K
PiAgKiBwcmVhbGxvY2F0ZWQgQHRtZHJfYXJyYXksIGZvbGxvd2luZyBhbGwgdGhlIHNwZWNpYWwg
YWxpZ25tZW50DQo+ICAqIGFuZCBzaXplIHJ1bGVzIGZvciBURE1SLg0KPiAgKi8NCj4gc3RhdGlj
IGludCBmaWxsX291dF90ZG1ycyhzdHJ1Y3QgbGlzdF9oZWFkICp0ZHhfbWVtbGlzdCwNCj4gCQkJ
ICBzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yX2FycmF5KQ0KPiB7DQo+IC4uLg0KPiANCj4gVGhhdCdz
IDEwMCUgY3J5c3RhbCBjbGVhciBhYm91dCB3aGF0J3MgZ29pbmcgb24uICBZb3Uga25vdyB3aGF0
IHRoZQ0KPiBpbnB1dHMgYXJlIGFuZCB0aGUgb3V0cHV0cy4gIFlvdSBhbHNvIGtub3cgd2h5IHRo
aXMgaXMgZXZlbiBuZWNlc3NhcnkuDQo+IEl0J3MgaW1wbGllZCBhIGJpdCwgYnV0IGl0J3MgYmVj
YXVzZSBURE1ScyBoYXZlIHNwZWNpYWwgcnVsZXMgYWJvdXQNCj4gc2l6ZS9hbGlnbm1lbnQgYW5k
IHRkeF9tZW1saXN0cyBkbyBub3QuDQoNCkFncmVlZC4gIExldCBtZSB0cnkgdGhpcyBvdXQuDQoN
Cg==
