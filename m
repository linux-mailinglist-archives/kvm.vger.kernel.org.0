Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0F36377DD
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 12:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiKXLqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 06:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKXLqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 06:46:46 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4319DB96;
        Thu, 24 Nov 2022 03:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669290405; x=1700826405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1eZnyjtGoClCZk85aH96e+lHV5X5jDOL+xLwl5OEBP8=;
  b=g+U57MduaA6aGXGIq3QweoutdG7OlIr7+t5FQqCXhuVfi+IuHJdJbXda
   NHG/GPdCcBaqNhqcD2fErX8/ACTagrwHLaaRLuU/oWAmgq47JM2+f1tQF
   jSNp0hAgxdWSrE4r824F4prHlKJKP/qsdTstdM8MrGQWdsSL7P85ALRw4
   r22ybX4NRzjFEQFFBsjThMe/TrMI4cpTRagtgyRtGePC3tD37lsZv788i
   NozSUFkVmicKWEnRRXxirGnDtON0KM+AOWWHyg41p447ljsCqHf0YEP12
   La1J5t/c2Fa1Z1uO/Wvhc4CppGn+HlegX1aW+TrmekfCWXxDI0/bKQ5wT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="316106492"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="316106492"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 03:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="673218271"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="673218271"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 24 Nov 2022 03:46:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 03:46:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 03:46:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 03:46:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 03:46:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWfqGwsQUi1l4vZtcFTXgJWky26w5y02khW1PHCFW5GSTArtqyr46EXM2MrHNUaHofUJxzWcUyXgmW/LwJ/XC8XwgoWnEGIm9eXwinDDi4CcW51Y/DjD7SK/85C5f2+hCIDdDvgXSuxDL61R7CPuHI1ISCq2oJrd4W0b8dzxrIHxX4Sp4iu8LfURbmy1A33ORL4u8D3f0TXz2kLFIcaGXA3K2SolEc7TylAD46EAyQ+7ZJtmyfq3gzqMfUVpEyDF75jo1OqmTF83czB9T6fZzv6EIGii/WYP77hDEzzXpNh+LshatWuwOFICZ3J3w1eWv6m5z2ajA6VUk6DAABvLKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1eZnyjtGoClCZk85aH96e+lHV5X5jDOL+xLwl5OEBP8=;
 b=O2SuXx6LALrL6Rkt+/GM5JyAK2FJ5oyPGIWInWcs1svedZlgq+YKxP8Ih6OY7xlT6iN+A/nTtFX4bahqtF34SUnPa2GoWBml92Kzt/2nUDr9vguHyEGXAqV8VYC0RPC8Mx7o0mqYS41O3X27p8Cmmh+u+tRxDnLFTnrNwLUTjIISIqnEEQwYJ2ew9dnMbMbyuG8ez/0TFurUAdYy4dJNbgNKiu11DDWsAOZ9VmLvWJvawN2w79jrqcihalyExm2+tlmVViezXTH/oXh3AQMqd+xOrqIFbB8xX/gXPQ3XsPR5/Gy38yY1po8SBaeJluDW/wDZG893ru+hVEJR0HOptQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Thu, 24 Nov 2022 11:46:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 11:46:40 +0000
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
Subject: Re: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHY/T3JgMaJHzs+pUuA6EdKq644U65NI28AgADW5wA=
Date:   Thu, 24 Nov 2022 11:46:40 +0000
Message-ID: <cceee7b0476437fb18f90a272e2852bdbb2636cc.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <ef6cdab2c371b9f068f2b4bf493b1dd0c9bb3c99.1668988357.git.kai.huang@intel.com>
         <74723e2b-3094-d04b-aed7-2789268b00ab@intel.com>
In-Reply-To: <74723e2b-3094-d04b-aed7-2789268b00ab@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6038:EE_
x-ms-office365-filtering-correlation-id: 267bb909-8a52-4312-990d-08dace118d2f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PmbvILTMuifz1l0mmMS2/jWqxdle7Np0htzl4VmY1HoRkuuCQhClYkuGvoVNORHjVvr0fCtq+j6RXqgeEV0kpKwQ+JphndDpxPZjUpWaNfed38gpA47BLNQlTOM/10tuTWZ9CqnzYwvj3XtvImGlPrQHC7e2pmZlvl1EeW02uL1TFu1rltEKHyI3bR8mKgSfNZGXpLOII2cnunuYLi1wn4YgLLzgvg9suv7kXfKgBle93wBEDfiFzpvMKot1i8YcdES/n5vksKWlnqsNJ9R7ah3C8WFJDCnbwtWy/c0JNXhGfcWu/Z4b0VDqw5f9XDYqbiLRJ+gXOHwEb/stScUKrdYrUdaU3ZX7ezrrUl+GOiS8PPZtOCCBzAYgaAlcDTbt3dsjU8h6CFf2x6jiE1CmhQVjDwqx8Fpr0EzExKEUnyGsrfdU39HGKj3XOXuHA+UL98XoNkypZF6MvMWh7HVu0C8nUTpiJroeGbC0VZ4BOCO/GWO3s10nqQJUflu4smgSkxNOYlcFDjfoT+sLl31W6SkHHVrq1z1314dRV3dsZts+p5QPUSYO3JG1/P8MGey/ArPmeCouSI/tCLF7XCsAIKcBcwZZroF2fU4R8ZCAoAlXSTkQaqfJoLhMmMO//addnDRFj0YkS7D+UtCSN8FAy+cRZJaqaiC9cN+wMhm9r6qoDP0PCKE/T1e1L87iOHEVT4AfmF8weeLrvBHC8KA6kb6ts8RrtrIE6QQZzvXA7vM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(76116006)(66946007)(2616005)(91956017)(86362001)(66556008)(64756008)(41300700001)(186003)(38100700002)(7416002)(4326008)(8936002)(478600001)(26005)(6512007)(71200400001)(8676002)(6486002)(82960400001)(54906003)(110136005)(38070700005)(122000001)(5660300002)(36756003)(316002)(6506007)(53546011)(2906002)(4001150100001)(66446008)(83380400001)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGFSTXQ2dmJkK09vOFFJa0pLNHpoNXVXU1o5Uy9ycFVwRGxrZ0dpdjJRcyt2?=
 =?utf-8?B?d21PZ0dUQ1c4QU1oZzRFRjMxSllGVWVuZnR5RXo5dXg2RWlMOEZVRm1GYThs?=
 =?utf-8?B?UVF0bzVJUm95QWNaaHJoaFRJZFhZWE9uUkdjRkppTVBRejJ4clpsNzM0ZkNT?=
 =?utf-8?B?ek81UGNzeStYVzNFY1hWSTkzcDlCTExEQkdrOU91T3ZiTDB1UDZJNjc3RTg1?=
 =?utf-8?B?NnR3WWhaVUtOVEh4bFl1ZHNzb1JnSm1iTCt6VVJZcGhyeldXM2dlNVAyck4x?=
 =?utf-8?B?UFRudTV1eXRpWXFIekFjYStYRk5KYlpLM1BCQzJzYWtEbzJtQWtNcFV0Nzda?=
 =?utf-8?B?WUNDVlM1M2pXL1JYY0YvUmlMZVVUcW5XMGJXbXU4VHRFdDFRQzVKUjZhSjIv?=
 =?utf-8?B?TWkyVUJrVG45YUlXM3U2SG43OU1MTVJMSVhBVHdJVGlwSk1tTlN1bkFlTXU4?=
 =?utf-8?B?TG52WFc3cDZKT3lBZTBOQ0IzQ0xHUmxNQmZBZldicng5emthbTdyUVVWMXBW?=
 =?utf-8?B?bVlsaCtPbVRTTlNQbmc1TmpoaUZiMGNQWHRDWVlHYTRDWXRmdjltUUpkc200?=
 =?utf-8?B?N2g5NUZ3RUZrUEZsTkcwUGlCUnMvRXBCR0IxT2U1STFZeVpIemJpdWpRZ2xm?=
 =?utf-8?B?Z0gzS1diYllqQnFkRFBQcG1Fd0pPZWNoZGtONnlqYllhVjZRNU9NdXB2all3?=
 =?utf-8?B?RW5rVUpyZTdGckM0OGRRZ3NLYUtDazhkMGFoUDZrc2tTRU1vSUFoQ3c0Ykxh?=
 =?utf-8?B?Q0JJMVFjVlBURitUY2RMa2YySjc0TWljY2NsSW1yd0VrWkF3LzdzT2FEdUtq?=
 =?utf-8?B?SE80ZXlGYnM1QnV4cENyL2o3UGNjZTFVSDVvRkFPRy9KUDRkUU5Jc1dDNkZi?=
 =?utf-8?B?dmdESWZqbFVZRndKQjhPYlRUSmY3WkNuTHN1bi82bjJJTlVEOG1UUld0NnVl?=
 =?utf-8?B?RWg0WGNKalcrOVhudHN4cU00bHAyako1L0hMRFVyTTgzMitoQVpGQldWZUJK?=
 =?utf-8?B?QURnVUl0U2t1R0NJYVpsbFZIWWdFeWprV0w4bjY5dUZsOUZsai9scjFNY0ZM?=
 =?utf-8?B?cU9rcy9VR1Irc0NIem5BRnVLS2lVRXJaMTBZT0pERmwvLzliZVhpSzVUUGpm?=
 =?utf-8?B?RDV4bi84ZVlYL1ZxODBjdmsvbGp5Y0x4YTZrQjdUZ21wQWsrdXRHa0tQZ2tl?=
 =?utf-8?B?STN0MmNUNWR1eWU5Ni9Uc3hhdDVtR0RPY2d5L2F4S2NnTU9PR2txUm5kbTdi?=
 =?utf-8?B?eHl4VDJoVVhvc010YVZxT0pmemNzcS93NHlIUnZJdjQrVjZtbEY1cGEra3hO?=
 =?utf-8?B?cllhbVZ4emlJc2FvRWFkaVY5bkZnVXd3U0gzSGNGeWRLSHlwbElSamo3QVlt?=
 =?utf-8?B?c2RzcnlTTERPcHMzOTBzeUdKQXJKbFYwZDh3S3R2TFpSQndZRXlKMzNhOXhZ?=
 =?utf-8?B?Q2psM3hqUHRsM0JaSXZQSnZCU2ZLeDY4NGtCbmpkb3IwaWdoQURVcExqWmZ4?=
 =?utf-8?B?SFhHcVpNaUpDcXlWRllvTk0vN2tiTUZzWlh4OHRKYlMrZEJTdVlQNTk2SG42?=
 =?utf-8?B?SWZXbWNUYzZ3WW5mdGVmeUhrOUlZY3Y5OE5JcUp5NjhPR2E2dXJaVi9oRUVp?=
 =?utf-8?B?ZGo0UFpYU0NDWmY1azN1cTVNd010L3ZPUFN1LzBKeFBtNXI4NDBEZjNySHhk?=
 =?utf-8?B?WVljby9oM0Y5QkN5SFBLUWRLQXZwZzdVdHZMdnBhWURXbllUVWFFcUluVFRG?=
 =?utf-8?B?QWc4bjZucSs2NkZKazBEUWYrcGd5S3VTQ0t5SjZPdmpQK29zaUpteHM3SWFE?=
 =?utf-8?B?Q0dnUFZkNlpqT2hTOUx4aGl6Rmk0Tis4UWFGVzJZVFpTRUlaUEh0RE0xRSs0?=
 =?utf-8?B?Wi94NytXWWVSMjRPa0xMYUdIbkRwQzdwQmtVakhUUG1XdWtuSllBRWVTSWpP?=
 =?utf-8?B?dU44TnZMNWswVmVnQWx1YTNGSkdFVmQxU0htRHh1UXFBWkYzS0VHakcvVGdi?=
 =?utf-8?B?Z243WlA4SWFMS3ZTUUhla1FmaW5PNHROaHR1UHB3SjFtTDYzUGpUZHZDQjh6?=
 =?utf-8?B?ei9MRFNWMnJyeExoVS84OXNpaTdmMmdLelRLRzYxVUFJZDhzWldTVDBlTURp?=
 =?utf-8?B?T2hzQ0xNZHliQVFNYkhmUHlKSTVwcWdlTEFiRmRHWTh5bDhwWVdtdlVWeFdP?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBD56A3262DFDB4DAECAB81992A8D81F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 267bb909-8a52-4312-990d-08dace118d2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 11:46:40.4350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8fX3t/eKc2UoCoD97d3+4U+aQ82+mzOQ8fdyhHcp0lkmg8Fn9Rfh5963U0rS0edrtcPSC6TmzBnhS3EN6vQ3Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6038
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE0OjU3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBUaGUgVERYIG1vZHVsZSB1
c2VzIGFkZGl0aW9uYWwgbWV0YWRhdGEgdG8gcmVjb3JkIHRoaW5ncyBsaWtlIHdoaWNoDQo+ID4g
Z3Vlc3QgIm93bnMiIGEgZ2l2ZW4gcGFnZSBvZiBtZW1vcnkuICBUaGlzIG1ldGFkYXRhLCByZWZl
cnJlZCBhcw0KPiA+IFBoeXNpY2FsIEFkZHJlc3MgTWV0YWRhdGEgVGFibGUgKFBBTVQpLCBlc3Nl
bnRpYWxseSBzZXJ2ZXMgYXMgdGhlDQo+ID4gJ3N0cnVjdCBwYWdlJyBmb3IgdGhlIFREWCBtb2R1
bGUuICBQQU1UcyBhcmUgbm90IHJlc2VydmVkIGJ5IGhhcmR3YXJlDQo+ID4gdXAgZnJvbnQuICBU
aGV5IG11c3QgYmUgYWxsb2NhdGVkIGJ5IHRoZSBrZXJuZWwgYW5kIHRoZW4gZ2l2ZW4gdG8gdGhl
DQo+ID4gVERYIG1vZHVsZS4NCj4gDQo+IC4uLiBkdXJpbmcgbW9kdWxlIGluaXRpYWxpemF0aW9u
Lg0KDQpUaGFua3MuDQoNCj4gDQo+ID4gVERYIHN1cHBvcnRzIDMgcGFnZSBzaXplczogNEssIDJN
LCBhbmQgMUcuICBFYWNoICJURCBNZW1vcnkgUmVnaW9uIg0KPiA+IChURE1SKSBoYXMgMyBQQU1U
cyB0byB0cmFjayB0aGUgMyBzdXBwb3J0ZWQgcGFnZSBzaXplcy4gIEVhY2ggUEFNVCBtdXN0DQo+
ID4gYmUgYSBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMgYXJlYSBmcm9tIGEgQ29udmVydGlibGUgTWVt
b3J5IFJlZ2lvbiAoQ01SKS4NCj4gPiBIb3dldmVyLCB0aGUgUEFNVHMgd2hpY2ggdHJhY2sgcGFn
ZXMgaW4gb25lIFRETVIgZG8gbm90IG5lZWQgdG8gcmVzaWRlDQo+ID4gd2l0aGluIHRoYXQgVERN
UiBidXQgY2FuIGJlIGFueXdoZXJlIGluIENNUnMuICBJZiBvbmUgUEFNVCBvdmVybGFwcyB3aXRo
DQo+ID4gYW55IFRETVIsIHRoZSBvdmVybGFwcGluZyBwYXJ0IG11c3QgYmUgcmVwb3J0ZWQgYXMg
YSByZXNlcnZlZCBhcmVhIGluDQo+ID4gdGhhdCBwYXJ0aWN1bGFyIFRETVIuDQo+ID4gDQo+ID4g
VXNlIGFsbG9jX2NvbnRpZ19wYWdlcygpIHNpbmNlIFBBTVQgbXVzdCBiZSBhIHBoeXNpY2FsbHkg
Y29udGlndW91cyBhcmVhDQo+ID4gYW5kIGl0IG1heSBiZSBwb3RlbnRpYWxseSBsYXJnZSAofjEv
MjU2dGggb2YgdGhlIHNpemUgb2YgdGhlIGdpdmVuIFRETVIpLg0KPiA+IFRoZSBkb3duc2lkZSBp
cyBhbGxvY19jb250aWdfcGFnZXMoKSBtYXkgZmFpbCBhdCBydW50aW1lLiAgT25lIChiYWQpDQo+
ID4gbWl0aWdhdGlvbiBpcyB0byBsYXVuY2ggYSBURCBndWVzdCBlYXJseSBkdXJpbmcgc3lzdGVt
IGJvb3QgdG8gZ2V0IHRob3NlDQo+ID4gUEFNVHMgYWxsb2NhdGVkIGF0IGVhcmx5IHRpbWUsIGJ1
dCB0aGUgb25seSB3YXkgdG8gZml4IGlzIHRvIGFkZCBhIGJvb3QNCj4gPiBvcHRpb24gdG8gYWxs
b2NhdGUgb3IgcmVzZXJ2ZSBQQU1UcyBkdXJpbmcga2VybmVsIGJvb3QuDQo+IA0KPiBGV0lXLCB3
ZSBhbGwgYWdyZWUgdGhhdCB0aGlzIGlzIGEgYmFkIHBlcm1hbmVudCB3YXkgdG8gbGVhdmUgdGhp
bmdzLg0KPiBZb3UgY2FuIGNhbGwgbWUgb3V0IGhlcmUgYXMgcHJvcG9zaW5nIHRoYXQgdGhpcyB3
YXJ0IGJlIGxlZnQgaW4gcGxhY2UNCj4gd2hpbGUgdGhpcyBzZXJpZXMgaXMgbWVyZ2VkIGFuZCBp
cyBhIGRldGFpbCB3ZSBjYW4gd29yayBvbiBhZnRlcndvcmQNCj4gd2l0aCBuZXcgbW9kdWxlIHBh
cmFtcywgYm9vdCBvcHRpb25zLCBLY29uZmlnIG9yIHdoYXRldmVyLg0KDQpTb3JyeSBkbyB5b3Ug
bWVhbiB0byBjYWxsIG91dCBpbiB0aGUgY292ZXIgbGV0dGVyLCBvciBpbiB0aGlzIGNoYW5nZWxv
Zz8NCg0KPiA+IFREWCBvbmx5IHN1cHBvcnRzIGEgbGltaXRlZCBudW1iZXIgb2YgcmVzZXJ2ZWQg
YXJlYXMgcGVyIFRETVIgdG8gY292ZXINCj4gPiBib3RoIFBBTVRzIGFuZCBtZW1vcnkgaG9sZXMg
d2l0aGluIHRoZSBnaXZlbiBURE1SLiAgSWYgbWFueSBQQU1UcyBhcmUNCj4gPiBhbGxvY2F0ZWQg
d2l0aGluIGEgc2luZ2xlIFRETVIsIHRoZSByZXNlcnZlZCBhcmVhcyBtYXkgbm90IGJlIHN1ZmZp
Y2llbnQNCj4gPiB0byBjb3ZlciBhbGwgb2YgdGhlbS4NCj4gPiANCj4gPiBBZG9wdCB0aGUgZm9s
bG93aW5nIHBvbGljaWVzIHdoZW4gYWxsb2NhdGluZyBQQU1UcyBmb3IgYSBnaXZlbiBURE1SOg0K
PiA+IA0KPiA+ICAgLSBBbGxvY2F0ZSB0aHJlZSBQQU1UcyBvZiB0aGUgVERNUiBpbiBvbmUgY29u
dGlndW91cyBjaHVuayB0byBtaW5pbWl6ZQ0KPiA+ICAgICB0aGUgdG90YWwgbnVtYmVyIG9mIHJl
c2VydmVkIGFyZWFzIGNvbnN1bWVkIGZvciBQQU1Ucy4NCj4gPiAgIC0gVHJ5IHRvIGZpcnN0IGFs
bG9jYXRlIFBBTVQgZnJvbSB0aGUgbG9jYWwgbm9kZSBvZiB0aGUgVERNUiBmb3IgYmV0dGVyDQo+
ID4gICAgIE5VTUEgbG9jYWxpdHkuDQo+ID4gDQo+ID4gQWxzbyBkdW1wIG91dCBob3cgbWFueSBw
YWdlcyBhcmUgYWxsb2NhdGVkIGZvciBQQU1UcyB3aGVuIHRoZSBURFggbW9kdWxlDQo+ID4gaXMg
aW5pdGlhbGl6ZWQgc3VjY2Vzc2Z1bGx5Lg0KPiANCj4gLi4uIHRoaXMgaGVscHMgYW5zd2VyIHRo
ZSBldGVybmFsICJ3aGVyZSBkaWQgYWxsIG15IG1lbW9yeSBnbz8iIHF1ZXN0aW9ucy4NCg0KV2ls
bCBhZGQgdG8gdGhlIGNvbW1lbnQuDQoNClsuLi5dDQoNCg0KPiA+ICsvKg0KPiA+ICsgKiBQaWNr
IGEgTlVNQSBub2RlIG9uIHdoaWNoIHRvIGFsbG9jYXRlIHRoaXMgVERNUidzIG1ldGFkYXRhLg0K
PiA+ICsgKg0KPiA+ICsgKiBUaGlzIGlzIGltcHJlY2lzZSBzaW5jZSBURE1ScyBhcmUgMUcgYWxp
Z25lZCBhbmQgTlVNQSBub2RlcyBtaWdodA0KPiA+ICsgKiBub3QgYmUuICBJZiB0aGUgVERNUiBj
b3ZlcnMgbW9yZSB0aGFuIG9uZSBub2RlLCBqdXN0IHVzZSB0aGUgX2ZpcnN0Xw0KPiA+ICsgKiBv
bmUuICBUaGlzIGNhbiBsZWFkIHRvIHNtYWxsIGFyZWFzIG9mIG9mZi1ub2RlIG1ldGFkYXRhIGZv
ciBzb21lDQo+ID4gKyAqIG1lbW9yeS4NCj4gPiArICovDQo+ID4gK3N0YXRpYyBpbnQgdGRtcl9n
ZXRfbmlkKHN0cnVjdCB0ZG1yX2luZm8gKnRkbXIpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhf
bWVtYmxvY2sgKnRtYjsNCj4gPiArDQo+ID4gKwkvKiBGaW5kIHRoZSBmaXJzdCBtZW1vcnkgcmVn
aW9uIGNvdmVyZWQgYnkgdGhlIFRETVIgKi8NCj4gPiArCWxpc3RfZm9yX2VhY2hfZW50cnkodG1i
LCAmdGR4X21lbWxpc3QsIGxpc3QpIHsNCj4gPiArCQlpZiAodG1iLT5lbmRfcGZuID4gKHRkbXJf
c3RhcnQodGRtcikgPj4gUEFHRV9TSElGVCkpDQo+ID4gKwkJCXJldHVybiB0bWItPm5pZDsNCj4g
PiArCX0NCj4gDQo+IEFoYSwgdGhlIGZpcnN0IHVzZSBvZiB0bWItPm5pZCEgIEkgd29uZGVyZWQg
d2h5IHRoYXQgd2FzIHRoZXJlLg0KDQpBcyB5b3Ugc3VnZ2VzdGVkIEknbGwgaW50cm9kdWNlIHRo
ZSBuaWQgbWVtYmVyIG9mICd0ZHhfbWVtYmxvY2snIGluIHRoaXMgcGF0Y2guIA0KDQo+IA0KPiA+
ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBGYWxsIGJhY2sgdG8gYWxsb2NhdGluZyB0aGUgVERNUidz
IG1ldGFkYXRhIGZyb20gbm9kZSAwIHdoZW4NCj4gPiArCSAqIG5vIFREWCBtZW1vcnkgYmxvY2sg
Y2FuIGJlIGZvdW5kLiAgVGhpcyBzaG91bGQgbmV2ZXIgaGFwcGVuDQo+ID4gKwkgKiBzaW5jZSBU
RE1ScyBvcmlnaW5hdGUgZnJvbSBURFggbWVtb3J5IGJsb2Nrcy4NCj4gPiArCSAqLw0KPiA+ICsJ
V0FSTl9PTl9PTkNFKDEpOw0KPiANCj4gVGhhdCdzIHByb2JhYmx5IGJldHRlciBhIHByX3dhcm4o
KSBvciBzb21ldGhpbmcuICBBIGJhY2t0cmFjZSBhbmQgYWxsDQo+IHRoYXQgamF6eiBzZWVtcyBh
IGJpdCBvdmVybHkgZHJhbWF0aWMgZm9yIHRoaXMuDQoNCkhvdyBhYm91dCBiZWxvdz8NCg0KcHJf
d2FybigiVERNUiBbMHglbGx4LCAweCVsbHgpOiB1bmFibGUgdG8gZmluZCBsb2NhbCBOVU1BIG5v
ZGUgZm9yIFBBTVQNCmFsbG9jYXRpb24sIGZhbGxiYWNrIHRvIHVzZSBub2RlIDAuXG4iKTsNCg0K
DQoNCg0K
