Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8473D631C82
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiKUJKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiKUJJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:09:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7308F8EB69;
        Mon, 21 Nov 2022 01:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669021778; x=1700557778;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=c059hkObP+EfeiSXFJ97i48pi+xj3+OiF6SrT1RePhc=;
  b=HdM8OvmncB44eUZTTYc//I+oUpAReImC3uhb3zAg1hGUxll3WUrcqUyR
   Qq9MRWeT6+5H0uZYu4qPHyow7DZbPHcm6UTml3S46PJCXA/CSKxdIxJh9
   3ugqm97M3+8mFP4UP8lxCaDAl9Z2M2MYo7KTifUvuJ+rA4ivm2lTJrLir
   gb1zcjao0BBu2gJ08Yfyk8f1Eno6+mWXM/Fbw0MubyhYnPAj83xDKgQP1
   DMIP7lZBK82305ZMHEKUBfZBpQITd6j19UtxswUaFz1td4JqTstFio557
   I1L2kBiutmhV1QbO0obFNMi/7inA9JNYA+hl+Ae7zyUqtYKBLjNprOofn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="301055276"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="301055276"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 01:09:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="618757641"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="618757641"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 21 Nov 2022 01:09:37 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 01:09:37 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 01:09:36 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 01:09:36 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 01:09:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NR7c2vurkoRWFs22emMBgSqWMxKe+8B3Z4uQKJXr9Pj34i2RP+vSMF7RIk7KMBlSK7+62AN7sm8ohGAaprKjBQTjhW0JH8NM2zuUvIfxDvrmj6pr1SOQeR3SGz5cbG/amapEc8IVZJAJ4rcD/4m8Gg2cVN6vPV8mH7iiyIdnyqUfLtoM//3VdzoGDiahNe5BxN7mAQo5VZp8NQqAw0JPog56tSSOCZNdWoiGPdHhMc3XLvVsM/NVYo0cSVDYAXn6xKJxpb2AGu2L+VQ0BsD3eJXFmwPsBmScN3AzjLqRRAR7LeCgQ32V9Dn3KNCvEnXfIO+wHM0osBv6DXLwKHvhhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c059hkObP+EfeiSXFJ97i48pi+xj3+OiF6SrT1RePhc=;
 b=lXzrx8G95QgXaqjkRyuHgZ4H1fdpCph0WyPsLkJnlL3ykAOu4kbyNpjeJBHtBtHGX2Np92jyvuiZOS/blVXJ6NcLJb+cxaxUqWnLupcwfOIgDS6ziJDc07GD+x7cLMsAmSxrePoRng5llmHLwa+Ncr1gy5dSL0sENEb9wMI/siSlv098crM+p2qTck2i5+jmW3x8n94JnYcwGB0iolj2FB51jr0Ch19UuJ0DHyP+rd4gTIyCXzPppggjDI/Qj4p1mg3t3vnQrq+QA4rYItMusz7vaH1ovbic/YFMZmzRMEWzmn0Dp7vFoCT56rRKg/5Rf5RpwD2gMTnUmEG4FBc9bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB6841.namprd11.prod.outlook.com (2603:10b6:930:62::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 09:09:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 09:09:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Huang, Ying" <ying.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65I3JTQgAA63oA=
Date:   Mon, 21 Nov 2022 09:09:33 +0000
Message-ID: <a6ecf5f1a1202f428961a5f8422d5fff61ce1d9a.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <87cz9gvpej.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <87cz9gvpej.fsf@yhuang6-desk2.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB6841:EE_
x-ms-office365-filtering-correlation-id: 9a8cc5a7-19b3-42ef-09c0-08dacba01b59
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G9InfP18caucCrWavdpCAgJWAvHgFyJPxXjPauB3MFXsize2KQBSahCff22ulgOB8GcqA9fzbnFGyX9KYcnt6rOb2+pb9HMCmA7gXEp8XiKwvRoQdOKpxEN2OKozA3R8WDk9Dx64FeFqkr0TNB96FRF4j8CBWbe0kQlyRV+OpdFwbRvZHNAM48W8oQPNCW5vfJvhHDYo8vnV+bBwL4ZJpAWuNSuUPoEai80bULE8v+Cr7YAxbQuKbYIa/keiGgB7x805XaiFOdVAPy6Wpr3PjIsO0KRTPXLoZAxsZiP9qwOga9D8MWfTEUwYNeJczGF4hL1xOLJHchvT+tjwDy5smnAF2cyNvBCQVymwef+123XPg6SU1XIIRDIxO7z+3KLZ+dGHIGSDkiZ/xMVbAQvq9BT9VMYzDb67JU05KoMrwzYS0osDoykz6Renv+Frl30oQ8C5duYO0LShGRQta+6NMjZCxZDnNahCen/Pn25o8ViCO1PS5Gbos1cQk6ZRq1PRNB0zFLUrprnymk5lceU21wbqvBlgAz+9ki4zRADO7mdCh1E7+sA0rWxwMxuNshlK3mBfRSxZtavAYyMMjmyPc99Ilwf8fTQDWawV2rhaCOcLHhe75f7fztLkNJguElsbaiEJynxTS28WakSPACTM7VG7H+AlT5hTlQekAsmOXrUkhbWVyiGeTmcx610Ir83xinh44BWDb4jhtZGPDDhJbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199015)(122000001)(83380400001)(86362001)(38100700002)(38070700005)(82960400001)(2906002)(41300700001)(7416002)(8936002)(5660300002)(478600001)(6862004)(2616005)(6506007)(6512007)(26005)(66446008)(8676002)(4326008)(66556008)(66476007)(91956017)(66946007)(76116006)(6486002)(316002)(54906003)(186003)(37006003)(71200400001)(6636002)(64756008)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUlZRHZGYzcySVVPcUFORytVcmNXMml0OUVEQ2JFbjE3azZZNURsZ0Z1WFkz?=
 =?utf-8?B?YXp2SlJhNDFROGlWZlg3Z0lMd09ManJoYUhZeTFWalVjQXU4WVBrVUJqWjJv?=
 =?utf-8?B?eU5jLzdlc1NkNzBqMDhtQU8rY0NUbGpnK3IwbUhWQ2dnZ1NlWHc5dU9la1pF?=
 =?utf-8?B?OXFsMlNGVjF2SWc3UUhkYnpxL3VudjBRblgzRSt0OTZOZE1UV0Z3LzdqdzRo?=
 =?utf-8?B?WmxOaGJzSGszMjZUd3pCVVRhT2ZMSmJtZGZyZ0krYkk5a0xFQlBoQ2hHZ3di?=
 =?utf-8?B?STlhZ0xVUWMyN2VqTzdJU3diU211SHNyUDNXcjA3MjBqemh5OWVKYVFRVDh3?=
 =?utf-8?B?a3hJZ1l6Sy9xWGVaaER6NEkrdTMzNXlzdmZVUVdWQUsrVmlObGlyRndzTEkv?=
 =?utf-8?B?TGM4cS9NWWJUU0NqckF1RXc5Q1MxNHg5eERpOUJkS2Zaa3JmcHR5WXB3dVVW?=
 =?utf-8?B?bUhWVVFsYmJIYTRMb3oxczZhMGduYjZiNlN4SkVlOWkrMFpyTzlkUzhqV1Bi?=
 =?utf-8?B?bVF3bWprc2hoRzFhcG53bWhzRDI0WWdZQ29seXJxVmxPY1M4d0JSWmg0c0lD?=
 =?utf-8?B?cGR6bEZHYVA2Z29EemdMMjNpRWhYM2RURzJDZTN0YnhVOTZHRzJ1V3lZMk50?=
 =?utf-8?B?ZmUwQzl3WVFWcDV2TFdlbXdiZkJpQ0E3MGhyR04rQjdPNWlHUGxkWW10MFNh?=
 =?utf-8?B?UmlZQmhBMDQ5T0xFdTFQUG0xYi9hWXVQOE5yak16M05YYm50UklVbFNaOHVM?=
 =?utf-8?B?bVA0VGprYUV4d1lPNEtRR1RnRWlPUkNTc3RVeEJ6c0s1N3dudE95Ykd5bmQ2?=
 =?utf-8?B?OVpScU5MK1FNMVBHRkxRV05HTmxlRVdpU1p2eEZQenhXUG5VSStOQkgyWUNL?=
 =?utf-8?B?TUtnMFZITDlaU2kwWXZ6L2toY2RSdkVIMXMxOXg1OS9DWlgxRzFRN1JrZHdS?=
 =?utf-8?B?SU1oT1d5ZGEvdXB0UGVzV0V1K0ZmMXErOUJBRVE5a09SMXpxNlRJRUdNV2tI?=
 =?utf-8?B?RlpHU254aDVBUElXU2JBQ2szTGFmR21kMEE0a3lQcDZ6RmtsUGdyd3lwWnZ2?=
 =?utf-8?B?WC9RcGVqZW1hb1l5VzB4aVJmdHVBQjF2QzRpRTdjNkd2Y1I3R3pVMWR4MEg2?=
 =?utf-8?B?K05wVHc4bWhtK0xWSC9FQ2lnMEtiMW9UVXZXQ1NBVDNpMWpJM1ozaGxIdDk0?=
 =?utf-8?B?cDRQWVJlaWpwaW1KK1ZIbE5WMG55ME96MUtDMFg5Skhab20ybU9Qa0VTZUw1?=
 =?utf-8?B?aDlsZkZRMXlwdGE4U1huK1NWQUYrbzcvU3FhazcrM2F5QzB0dXJnb1o4cFB3?=
 =?utf-8?B?NWhEUUR0aC9PMElsVld6bjNQUzVOcjdjMkx6ZjAyekFaVkFGS3ZlV2NHUjAy?=
 =?utf-8?B?YzlGcjI2dGphbFlvZzgvYStzYTNnZlpNSHRzSEkwVGRjU01uS3pYNEFXVlpv?=
 =?utf-8?B?eUl3RkNhZjg4aDZUTFF6MjBUY0xiaUw2d2dlcy96cU8wUDhicldxbHcxUmJy?=
 =?utf-8?B?TmdBNHpXa2pjTnFvZ1lTQ1BLVkdYMkVqemdERzYySklCY1dYbnRLTThuWk80?=
 =?utf-8?B?cWxvZGROWnN2T0hCaW04QkRoTTdsU2M0MDBJb2JGRnhzaXhVQ0k4ME9RdWtM?=
 =?utf-8?B?NmtxOVVqWnpITG9BZ1c0SWUvVCtDV1EzbERsOUZSWGpCSlJtSTVKdmhRbGt4?=
 =?utf-8?B?eXY4L0hLZjJ0NWFwYk5mTkl0bzBjQk81VW1PU3Fnc2NlTE9lazdtNDNPdEZN?=
 =?utf-8?B?V0tNWkt0bWVFVnYwK3VqdjJ2bWYrUW9QMTVlTUpnK1p5WmtYN0lBakI3aFZV?=
 =?utf-8?B?Zk5JclpEVW1sQVA3ZUFVT25UYnJzSVJkcU82dTdBS01SOHhoNk1rWVRrSWdt?=
 =?utf-8?B?aVFLMkRnQ0R4LzI0aDdEc1Q0NWdBVzdvTWZ2Vjl3WTM1czRSR0ZrMjZZMVJU?=
 =?utf-8?B?VHFxZ3ZFSXY3VEhmaTJ6bktkaXUvK00xdnJhSnJhUk83SXE5ajJwWkh4WmV4?=
 =?utf-8?B?c3VreVF4U3VRMENRS3pCak1GK0hmSmRXNGU1U1pCa05OekdYVFFnZDk0WjRR?=
 =?utf-8?B?dWY4NThkMGY3Z1h0QUt4RlBFL0pYQytIZW5DUzNFM3lQL3VhaTlHSG0ycVhm?=
 =?utf-8?B?cnVCV0JPNDFPMEZOUXo4SldLNi9SNVVnTjhGNXJuTjdWd2ltMVVUNno1cmha?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E7CB3C93F4FF941A3EF635D7B58C045@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8cc5a7-19b3-42ef-09c0-08dacba01b59
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 09:09:34.0059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vPk9amGMth4Gku6tOysH8J1kWKYy5ePIO4q22HEE8eByQISyTZChqxZieTS8cDZIqHk+xGSg6b2T+W+MhPiDFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6841
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

DQo+ID4gIA0KPiA+ICtzdHJ1Y3QgdGR4X21lbWJsb2NrIHsNCj4gPiArCXN0cnVjdCBsaXN0X2hl
YWQgbGlzdDsNCj4gPiArCXVuc2lnbmVkIGxvbmcgc3RhcnRfcGZuOw0KPiANCj4gV2h5IG5vdCB1
c2UgJ3BoeXNfYWRkcl90Jz8NCg0KVERYIG1lbW9yeSBtdXN0IGJlIHBhZ2UgYWxpZ25lZCwgc28g
c3RhcnRfcGZuL2VuZF9wZm4gd291bGQgYmUgZWFzaWVyLg0KDQo+IA0KPiA+ICsJdW5zaWduZWQg
bG9uZyBlbmRfcGZuOw0KPiA+ICsJaW50IG5pZDsNCj4gPiArfTsNCj4gPiArDQo+ID4gDQoNClsu
Li5dDQoNCj4gPiAgDQo+ID4gKy8qIENoZWNrIHdoZXRoZXIgdGhlIGdpdmVuIHBmbiByYW5nZSBp
cyBjb3ZlcmVkIGJ5IGFueSBDTVIgb3Igbm90LiAqLw0KPiA+ICtzdGF0aWMgYm9vbCBwZm5fcmFu
Z2VfY292ZXJlZF9ieV9jbXIodW5zaWduZWQgbG9uZyBzdGFydF9wZm4sDQo+ID4gKwkJCQkgICAg
IHVuc2lnbmVkIGxvbmcgZW5kX3BmbikNCj4gPiArew0KPiA+ICsJaW50IGk7DQo+ID4gKw0KPiA+
ICsJZm9yIChpID0gMDsgaSA8IHRkeF9jbXJfbnVtOyBpKyspIHsNCj4gPiArCQlzdHJ1Y3QgY21y
X2luZm8gKmNtciA9ICZ0ZHhfY21yX2FycmF5W2ldOw0KPiA+ICsJCXVuc2lnbmVkIGxvbmcgY21y
X3N0YXJ0X3BmbjsNCj4gPiArCQl1bnNpZ25lZCBsb25nIGNtcl9lbmRfcGZuOw0KPiA+ICsNCj4g
PiArCQljbXJfc3RhcnRfcGZuID0gY21yLT5iYXNlID4+IFBBR0VfU0hJRlQ7DQo+ID4gKwkJY21y
X2VuZF9wZm4gPSAoY21yLT5iYXNlICsgY21yLT5zaXplKSA+PiBQQUdFX1NISUZUOw0KPiANCj4g
V2h5IG5vdCB1c2UgUEhZU19QRk4oKSBvciBQRk5fRE9XTigpPyAgQW5kIFBGTl9QSFlTKCkgaW4g
cmV2ZXJzZSBkaXJlY3Rpb24/DQoNCkRpZG4ndCBrbm93IHRoZW0uICBXaWxsIHVzZSB0aGVtLg0K
DQoNClsuLi5dDQoNCj4gPiArDQo+ID4gKy8qDQo+ID4gKyAqIEFkZCBhbGwgbWVtYmxvY2sgbWVt
b3J5IHJlZ2lvbnMgdG8gdGhlIEB0ZHhfbWVtbGlzdCBhcyBURFggbWVtb3J5Lg0KPiA+ICsgKiBN
dXN0IGJlIGNhbGxlZCB3aGVuIGdldF9vbmxpbmVfbWVtcygpIGlzIGNhbGxlZCBieSB0aGUgY2Fs
bGVyLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIGludCBidWlsZF90ZHhfbWVtb3J5KHZvaWQpDQo+
ID4gK3sNCj4gPiArCXVuc2lnbmVkIGxvbmcgc3RhcnRfcGZuLCBlbmRfcGZuOw0KPiA+ICsJaW50
IGksIG5pZCwgcmV0Ow0KPiA+ICsNCj4gPiArCWZvcl9lYWNoX21lbV9wZm5fcmFuZ2UoaSwgTUFY
X05VTU5PREVTLCAmc3RhcnRfcGZuLCAmZW5kX3BmbiwgJm5pZCkgew0KPiA+ICsJCS8qDQo+ID4g
KwkJICogVGhlIGZpcnN0IDFNQiBtYXkgbm90IGJlIHJlcG9ydGVkIGFzIFREWCBjb252ZXJ0aWJs
ZQ0KPiA+ICsJCSAqIG1lbW9yeS4gIE1hbnVhbGx5IGV4Y2x1ZGUgdGhlbSBhcyBURFggbWVtb3J5
Lg0KPiA+ICsJCSAqDQo+ID4gKwkJICogVGhpcyBpcyBmaW5lIGFzIHRoZSBmaXJzdCAxTUIgaXMg
YWxyZWFkeSByZXNlcnZlZCBpbg0KPiA+ICsJCSAqIHJlc2VydmVfcmVhbF9tb2RlKCkgYW5kIHdv
bid0IGVuZCB1cCB0byBaT05FX0RNQSBhcw0KPiA+ICsJCSAqIGZyZWUgcGFnZSBhbnl3YXkuDQo+
ID4gKwkJICovDQo+ID4gKwkJc3RhcnRfcGZuID0gbWF4KHN0YXJ0X3BmbiwgKHVuc2lnbmVkIGxv
bmcpU1pfMU0gPj4gUEFHRV9TSElGVCk7DQo+ID4gKwkJaWYgKHN0YXJ0X3BmbiA+PSBlbmRfcGZu
KQ0KPiA+ICsJCQljb250aW51ZTsNCj4gDQo+IEhvdyBhYm91dCBjaGVjayB3aGV0aGVyIGZpcnN0
IDFNQiBpcyByZXNlcnZlZCBpbnN0ZWFkIG9mIGRlcGVuZGluZyBvbg0KPiB0aGUgY29ycmVzcG9u
ZGluZyBjb2RlIGlzbid0IGNoYW5nZWQ/ICBWaWEgZm9yX2VhY2hfcmVzZXJ2ZWRfbWVtX3Jhbmdl
KCk/DQoNCklJVUMsIHNvbWUgcmVzZXJ2ZWQgbWVtb3J5IGNhbiBiZSBmcmVlZCB0byBwYWdlIGFs
bG9jYXRvciBkaXJlY3RseSwgaS5lLiBrZXJuZWwNCmluaXQgY29kZS9kYXRhLiAgSSBmZWVsIGl0
J3Mgbm90IHNhZmUgdG8ganVzdCB0cmVhdCByZXNlcnZlZCBtZW1vcnkgd2lsbCBuZXZlcg0KYmUg
aW4gcGFnZSBhbGxvY2F0b3IuICBPdGhlcndpc2Ugd2UgaGF2ZSBmb3JfZWFjaF9mcmVlX21lbV9y
YW5nZSgpIGNhbiB1c2UuDQoNClsuLi5dDQoNCj4gDQo+ID4gKy8qDQo+ID4gKyAqIENoZWNrIHdo
ZXRoZXIgdGhlIGdpdmVuIHJhbmdlIGlzIFREWCBtZW1vcnkuICBNdXN0IGJlIGNhbGxlZCBiZXR3
ZWVuDQo+ID4gKyAqIG1lbV9ob3RwbHVnX2JlZ2luKCkvbWVtX2hvdHBsdWdfZG9uZSgpLg0KPiAN
Cj4gTXVzdCBiZSBjYWxsZWQgd2l0aCBtZW1faG90cGx1Z19sb2NrIHdyaXRlLWxvY2tlZC4NCj4g
DQoNCldpbGwgZG8uDQo=
