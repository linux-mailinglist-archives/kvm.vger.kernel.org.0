Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7675B63706A
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 03:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiKXC1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 21:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKXC1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 21:27:33 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F144D5FD1;
        Wed, 23 Nov 2022 18:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669256851; x=1700792851;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HgKU4TPWog6A7IAUwuNnhWaV/Xn9SRpgwMNv1wl/Y3o=;
  b=NdnCzs/j0VdQBv5lnrQZ6Da8wk6u/aWYyMBozZB9+b+oy8baKSbwo5DE
   LvFnLxiD/ohpZMIndQuS0D/Ikkfoy5pHhb8k6FtGLKTgI8rz0mowqUAQI
   uSYnaHAKZO55XqAWWp6d9rw8CON45aJMjo2BW6JC7IUj0yZCJJuFDuTow
   NlgElliXRAr1lAjrhEflBepJ8/1QX46oepyZOyek4eU17jCe0yHOWeRsl
   pVuJg9rQeUmPOY7tCKnOlC+ZPuLkZrAYq3gPaGJuHKyOEACgaensNCDV3
   nW1g/HhoGEJcCmbgmiuls618o/abxc36XWFuJ0ih4NApLzbo/Ma1Gq/8x
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297559193"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="297559193"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 18:27:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="592736968"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="592736968"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2022 18:27:31 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 18:27:31 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 18:27:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 18:27:30 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 18:27:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTSsQNgKK2GKfW+efueE0AoN9WzmC0TN402eCCFXivbqpl2QCRXpJvekq+xZSML3xZJrhz7pP48ER7umzgHe4ejR6NJJt6kmTYR9Zds0RVUAPheK0/dc076+yV+TLTpqgzWN8xInXbBAj1TWrGGQ738Z6THcu21KQkPE4gS4o6swMXl9dwFNGRvEg0oKdw6u6ixqwRtuiib3xrmI0/RxhGgB41qtG8wxM1EMM/uBn5aS3D9OQhZOefUmSX2ijA91k4WIUTmP2d/yW8ZYzgGLzHQZoy+mLNGrTSJI9XGivN+YjOLcuBZcZByFZdu7i7r1fboYpL5QllZDtyDh5298wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgKU4TPWog6A7IAUwuNnhWaV/Xn9SRpgwMNv1wl/Y3o=;
 b=L6Q51jTmRAPJ1KmZG1sxCXai2T+kxaYbqt1FBCKiduBu3RmiWJmlibXmg5jvnnJaQKK1FWufjCd7LAF+/tb8JOifGNskYDVWqFHjjsgpF2lOdxVYCVONou8utRC7ASTy+GAbbq25yIiVPWkrZmeK4XsCW+fyQ0xT1QRGpcYiKRCWYvk872pbmVqF1sjr4n+aGjHRMI/J/CryfsiaNu3F5ncEkW6XMlBgILWZi5oJVhS6BnicruVfT7yH1eDttIjORQBPDot/SUKMLI/P2PAG6IIWaYxvGchwpsDNQHxUDqEaU9FOL5Llb0VeUPF7KyNF536T3PsBD9eGtWYKGh6l8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4524.namprd11.prod.outlook.com (2603:10b6:303:2c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Thu, 24 Nov
 2022 02:27:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 02:27:28 +0000
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65LqJ8AgAGeOICAAAUzAIAAEg6A
Date:   Thu, 24 Nov 2022 02:27:28 +0000
Message-ID: <8b317553b1ab9821fd570d146619f535f9f6cc2f.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <eb8d0f69-7ada-a358-46ea-da15a3aeac93@intel.com>
         <a937612630e149faea2552deab5ea81a836bbd4f.camel@intel.com>
         <8e6803f5-bec6-843d-f3c4-75006ffd0d2f@intel.com>
In-Reply-To: <8e6803f5-bec6-843d-f3c4-75006ffd0d2f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4524:EE_
x-ms-office365-filtering-correlation-id: 9c33c59c-ce6b-48a1-9aef-08dacdc36e66
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A9F6J1+AzpZpVAJx2aSO+t5MA+8X75S3mnZTAkKMVnAd+GKNtTYfml+2CkpCwPxLlL5HCLZj04cFXJagHysiu/vJ8kXjTTRh5zpbXDOhNF7NvEvS/LV9F3cCdSWR62xAmrJPEgymmkC6/ZcZ1KTTwcwSpf78qcE3pOm1Fch8FlIHWvgwvzsTv5MNTtuwFvxdn+NJN6OGEu9y93K0GdynfL3sHzJC+kecpfnr4VjbfMKvIyXzYpp6BYD7Kbc7sVZ03UJTcDPgbrUZJtjSrpkWG4Em8NHAzXGtguBVdxj/T5nFnCtJoDsWLx1Y2fPqvsmYfiWEj9mDM5F/APCCkXzpW7onPmK7CBKL8RLfSG+QtOynhV+PIwwWvKEDZUfvO2RIea/pFz4ej4ov9ikzO18C1GcobQOg5hdWzkVXwI6CfwxIzNQD5CRfbjzo6jahiqUbyKcxDSiSwZyV6fYYZPbFIHtEHXXKrru1UPLMjtcZIPz2Q+cn7TyQ4Je/YlsgMPp5enZXCghWt+eagL+dgXLsWosJobvq3wcgzTH0asHV1y/b3oiNzXGSCGDkqIp3uHXI4HQlbqogDSRWs3Qhdw2ufSGDNEmtor6rTzlPdtKv/Sxjt5RSz49u0KBh1r1jFAbl1sgVNYhTtQPzY8rqlxYa7zv+PXcasay4jfDcg7RSa21r2LBMYmqlcNrYwsS5952Wq54fdbwgyBZEHZV0HJ2/cg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199015)(82960400001)(38100700002)(122000001)(86362001)(64756008)(66446008)(66476007)(66556008)(38070700005)(91956017)(71200400001)(76116006)(8676002)(4326008)(66946007)(110136005)(186003)(316002)(54906003)(7416002)(5660300002)(4001150100001)(2906002)(41300700001)(8936002)(6512007)(83380400001)(6506007)(478600001)(6486002)(2616005)(26005)(53546011)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmRCeFdzazBBMit1dms4ekpTSWpFTGRwNHpMMlIvWktaR2FpeU1LakswMHF2?=
 =?utf-8?B?WTFPMFllRlJ1ZlBWWDByRkNTaDFZMXBaMHg1K2lsdjlLWWRHbmlNOVpEQ3p4?=
 =?utf-8?B?eVJSbXMwcUJyVUoxdmhCODh0clUwRlZ1aVR3d1lxcGxWTnR0MDYzUXZKcHF1?=
 =?utf-8?B?TmZKSk5Fa0NaUUxhWEtUK1FxakpZUkFBemcvNHc1V1FIM1NqNEFPQzVkMXFZ?=
 =?utf-8?B?TFVrOXVuSUdwb3IzbGtiOThVN29TM1FtZGU2MnBCbDRIUHA4YThtK3ZYUkdn?=
 =?utf-8?B?MmRScnZaUUk3THhxQ1U3c3lNYzNGU3JjemNJVVdEemZ2RGxBbU0wc1F0cDdY?=
 =?utf-8?B?aHc4MXhhYnBacm5TbVU0N3B1MGFVSldub0N6S21ZUThMc2lzNktlUHlBZm0w?=
 =?utf-8?B?U1BJakhNWTNxUDd0RzZnUTdvL1RCSThrMGxzcVN4T2wvcDhYY1J1a0FJZy9v?=
 =?utf-8?B?VWlwQWcxS1ZXR21pbGtsay8yTjdDQnZpZTlXT1BLRmU4REppL0p6aWhDSVBt?=
 =?utf-8?B?N043c1BYOENHYkZkSmZNTWNsMzFWTnM5U3VaaEcrU3JlalhJbUo4c3gzd2h0?=
 =?utf-8?B?N01RanEwdDQrR0JGL0h0bmNPNE5oa2hLZjQycGdGaXdCbmpTRlVtM05EWlJt?=
 =?utf-8?B?ZGZQNzZjNjFMTmVWM0JINWY5cU8zZ0JzNjQ4NkFHOEM2TElPQ2xmZFRKOE5y?=
 =?utf-8?B?dnl1VmZzcFVhYWVwV1g3SHdFQWo5ZWZQb1E2UVhOazVndjR0ZDhoZ2o2bmM4?=
 =?utf-8?B?eGVsZGFQYzdBSFZkS3EvOEJpbVllN1daZHdRdUo2R2NHaXZoM3ZCUmVEOHFo?=
 =?utf-8?B?S05HMXhFSUFjdTFDNDZsSTRiWFZ3QVk4cWwxRGRKYS83NUNrSjhQR2paZ0pI?=
 =?utf-8?B?TEtsREdremFOc01EcWIveGMwWDhGSSt6MC8yYm9jY1ZCa3krOURvK3I2SllV?=
 =?utf-8?B?NjZWbThiRVNpdzBqSFRqVXFGY2pCNWxNdmI4S1dlK1ZDalFzUG80NDFpeFpm?=
 =?utf-8?B?a1dKZkkzZU9QOGFmcHo3R29KcC9NbjJCR0p1TDBiU05XS3hjL3gwbjJEbElt?=
 =?utf-8?B?UGhSWU5OSXZUQ2E5RXFycUxmRTRoamg4Kys2MmtIN2dGQmF1MmdEL0MxczVt?=
 =?utf-8?B?S21nc1dLUmZxZ3BBYTQvNnluQUJ2bGI0V1pyekV5SWh3Tm5LdTViMmhiR3VY?=
 =?utf-8?B?SGduaXlETCsreVErT3YvOWducXBZNkxJOWNCUGlLMmo5VFNPZ1pKdGVvN3di?=
 =?utf-8?B?SVZoT1ZFKzZ5R250aTNtQ24ySmZ6d28vS2ovT2FmZEFpVEtSem9zeUcrcFR6?=
 =?utf-8?B?WUlyYkI2Q1JCWFNRYVprOWIvZktuVlNFeldKaHczV2IvMjNlbnB0TlUvRmM5?=
 =?utf-8?B?aC9YNHF3czFtOTF6a0xvMXRCdnJsT1ZQWWdJZnU4YVhXaFhJRXBORVBVZ0tV?=
 =?utf-8?B?N0JHQnRheHpiZ21nUGt2TkNaeHNjQ2xYRENxRG9oeDE2RWdjVHBSOUlEYkxY?=
 =?utf-8?B?OXlkL1NMOG84NGhoSUpGOFpGUkV1c2FkZi9Na1FNV3c4UU9CQmlDWmNKWW9V?=
 =?utf-8?B?MStpYWZMQTJ4TGdKQ0Qwc0o3SEZDeCtpR29wRHlpTk1xeXFITXJ2U2ZHWWp4?=
 =?utf-8?B?b2I4OS9WM3lieG4ySkhjTXhtb2s0L0NjOEVpYXJIYWpldlR6MzhWTGtaZms2?=
 =?utf-8?B?MVJlSlA2RFRaRGlWNDBNK1oxZEdBL2xYNjk5blRpTXc0NUZZWUtST0xpNVRz?=
 =?utf-8?B?WHJSbXJsSnZSZzgvTDA3YStZL1ZxaTB4OEd0VFV6VVRkRUhsSFB0RmZYRkVG?=
 =?utf-8?B?UEt5aWtISEFqdkwvN005RXNPU1R4Uyt5WkF5YjBNSjhTdnpMNnhzZE02blhM?=
 =?utf-8?B?c2FTQlN2Sm1OcVpmbmU2Zk1qNDRFN3JuWEdPc3JYcG9JbnhDQ09NYkRuNnpr?=
 =?utf-8?B?a1p3UENHbmhTNm85djlrbHA2WVdSMUNqVmt1S20xZzRrMVMyVVNqZ1B3dUJv?=
 =?utf-8?B?UFZWTzhSQmVLMTYrUHRJa2lVanRyWDFyUlRrTGVFY01PTHgzR25xclNyODZ0?=
 =?utf-8?B?bmZCYmZHVUdmL3NYNngvaXFtSGFYbzNJdkhZUzErRHBYSS9zZXk3TWI0MFM0?=
 =?utf-8?B?V2kzd1hPZWJMdjRYRUdSZjRLNFNFRVpIdHdkWU1KNXlGblNSVEl4c2M3YmVI?=
 =?utf-8?B?L3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <597DAB2BC1C7BD4D8C0DA524F1DDDDB5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c33c59c-ce6b-48a1-9aef-08dacdc36e66
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 02:27:28.0557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PQDIhSgQJm3OThasGM+llbNdMDMMuocgl6+2bKWU5iLMjQhLkTxWPuzuhmOELw8iwnKrKtlDR5IOnTVDQ6OEmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4524
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE3OjIyIC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDExLzIzLzIyIDE3OjA0LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMi0x
MS0yMiBhdCAxNjoyMSAtMDgwMCwgRGF2ZSBIYW5zZW4gd3JvdGU6DQo+ID4gPiA+ICtzdHJ1Y3Qg
dGR4X21lbWJsb2NrIHsNCj4gPiA+ID4gKyAgIHN0cnVjdCBsaXN0X2hlYWQgbGlzdDsNCj4gPiA+
ID4gKyAgIHVuc2lnbmVkIGxvbmcgc3RhcnRfcGZuOw0KPiA+ID4gPiArICAgdW5zaWduZWQgbG9u
ZyBlbmRfcGZuOw0KPiA+ID4gPiArICAgaW50IG5pZDsNCj4gPiA+ID4gK307DQo+ID4gPiANCj4g
PiA+IFdoeSBkb2VzIHRoZSBuaWQgbWF0dGVyPw0KPiA+IA0KPiA+IEl0IGlzIHVzZWQgdG8gZmlu
ZCB0aGUgbm9kZSBmb3IgdGhlIFBBTVQgYWxsb2NhdGlvbiBmb3IgYSBnaXZlbiBURE1SLg0KPiAN
Cj4gLi4uIHdoaWNoIGlzIGluIHRoaXMgcGF0Y2g/DQo+IA0KPiBZb3UgY2FuJ3QganVzdCBwbG9w
IHVudXNlZCBhbmQgdW5tZW50aW9uZWQgbnVnZ2V0cyBpbiB0aGUgY29kZS4gIFJlbW92ZQ0KPiBp
dCB1bnRpbCBpdCBpcyBuZWVkZWQuDQoNCk9LLiBJJ2xsIG1vdmUgdG8gdGhlIFBBTVQgYWxsb2Nh
dGlvbiBwYXRjaC4NCg0KPiANCj4gDQo+ID4gPiA+ICsvKiBDaGVjayB3aGV0aGVyIHRoZSBnaXZl
biBwZm4gcmFuZ2UgaXMgY292ZXJlZCBieSBhbnkgQ01SIG9yIG5vdC4gKi8NCj4gPiA+ID4gK3N0
YXRpYyBib29sIHBmbl9yYW5nZV9jb3ZlcmVkX2J5X2Ntcih1bnNpZ25lZCBsb25nIHN0YXJ0X3Bm
biwNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9u
ZyBlbmRfcGZuKQ0KPiA+ID4gPiArew0KPiA+ID4gPiArICAgaW50IGk7DQo+ID4gPiA+ICsNCj4g
PiA+ID4gKyAgIGZvciAoaSA9IDA7IGkgPCB0ZHhfY21yX251bTsgaSsrKSB7DQo+ID4gPiA+ICsg
ICAgICAgICAgIHN0cnVjdCBjbXJfaW5mbyAqY21yID0gJnRkeF9jbXJfYXJyYXlbaV07DQo+ID4g
PiA+ICsgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgY21yX3N0YXJ0X3BmbjsNCj4gPiA+ID4gKyAg
ICAgICAgICAgdW5zaWduZWQgbG9uZyBjbXJfZW5kX3BmbjsNCj4gPiA+ID4gKw0KPiA+ID4gPiAr
ICAgICAgICAgICBjbXJfc3RhcnRfcGZuID0gY21yLT5iYXNlID4+IFBBR0VfU0hJRlQ7DQo+ID4g
PiA+ICsgICAgICAgICAgIGNtcl9lbmRfcGZuID0gKGNtci0+YmFzZSArIGNtci0+c2l6ZSkgPj4g
UEFHRV9TSElGVDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgICAgICBpZiAoc3RhcnRfcGZu
ID49IGNtcl9zdGFydF9wZm4gJiYgZW5kX3BmbiA8PSBjbXJfZW5kX3BmbikNCj4gPiA+ID4gKyAg
ICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsNCj4gPiA+ID4gKyAgIH0NCj4gPiA+IA0KPiA+
ID4gV2hhdCBpZiB0aGUgcGZuIHJhbmdlIG92ZXJsYXBzIHR3byBDTVJzPyAgSXQgd2lsbCBuZXZl
ciBwYXNzIGFueQ0KPiA+ID4gaW5kaXZpZHVhbCBvdmVybGFwIHRlc3QgYW5kIHdpbGwgcmV0dXJu
IGZhbHNlLg0KPiA+IA0KPiA+IFdlIGNhbiBvbmx5IHJldHVybiB0cnVlIGlmIHRoZSB0d28gQ01S
cyBhcmUgY29udGlndW91cy4NCj4gPiANCj4gPiBJIGNhbm5vdCB0aGluayBvdXQgYSByZWFzb24g
dGhhdCBhIHJlYXNvbmFibGUgQklPUyBjb3VsZCBnZW5lcmF0ZSBjb250aWd1b3VzDQo+ID4gQ01S
cy4NCj4gDQo+IEJlY2F1c2UgaXQgY2FuPw0KPiANCj4gV2UgZG9uJ3QganVzdCB0cnkgYW5kIHJh
bmRvbWx5IGFzc2lnbiB3aGF0IHdlIHRoaW5rIGlzIHJlYXNvbmFibGUgb3INCj4gbm90LiAgRmly
c3QgYW5kIGZvcmVtb3N0LCB3ZSBuZWVkIHRvIGFzayB3aGV0aGVyIHRoZSBjb25maWd1cmF0aW9u
IGluDQo+IHF1ZXN0aW9uIGlzIGFsbG93ZWQgYnkgdGhlIHNwZWMuDQo+IA0KPiBXb3VsZCBpdCBi
ZSBhICp2YWxpZCogdGhpbmcgdG8gaGF2ZSB0d28gYWRqYWNlbnQgQ01Scz8gIERvZXMgdGhlIFRE
WA0KPiBtb2R1bGUgc3BlYyBkaXNhbGxvdyBpdD8NCg0KTm8gdGhlIFREWCBtb2R1bGUgZG9lc24n
dCBkaXNhbGxvdyBpdCwgSUlVQy4gIFRoZSBzcGVjIG9ubHkgc2F5cyB0aGV5IGRvbid0DQpvdmVy
bGFwLg0KDQo+IA0KPiA+IFBlcmhhcHMgb25lIHJlYXNvbiBpcyB0d28gY29udGlndW91cyBOVU1B
IG5vZGVzPyAgRm9yIHRoaXMgY2FzZSwgbWVtYmxvY2sNCj4gPiBoYXMgbWFkZSBzdXJlIG5vIG1l
bW9yeSByZWdpb24gY291bGQgY3Jvc3MgTlVNQSBub2Rlcywgc28gdGhlIHN0YXJ0X3Bmbi9lbmRf
cGZuDQo+ID4gaGVyZSBzaG91bGQgYWx3YXlzIGJlIHdpdGhpbiBvbmUgbm9kZS4gIFBlcmhhcHMg
d2UgY2FuIGFkZCBhIGNvbW1lbnQgZm9yIHRoaXMNCj4gPiBjYXNlPw0KPiANCj4gPGNvdWdoPiBu
dW1hPW9mZiA8Y291Z2g+DQo+IA0KPiA+IEFueXdheSBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgaXQg
aXMgd29ydGggdG8gY29uc2lkZXIgImNvbnRpZ3VvdXMgQ01ScyIgY2FzZS4NCj4gDQo+IEkgYW0g
c3VyZS4gIFlvdSBuZWVkIHRvIGNvbnNpZGVyIGl0Lg0KDQpPSy4NCg0KQWxzbywgYXMgbWVudGlv
bmVkIGluIGFub3RoZXIgcmVwbHkgdG8gcGF0Y2ggIkdldCBpbmZvcm1hdGlvbiBhYm91dCBURFgg
bW9kdWxlDQphbmQgVERYLWNhcGFibGUgbWVtb3J5Iiwgd2UgY2FuIGRlcGVuZCBvbiBUREguU1lT
LkNPTkZJRyB0byByZXR1cm4gZmFpbHVyZSBidXQNCmRvbid0IG5lY2Vzc2FyaWx5IG5lZWQgdG8g
c2FuaXR5IGNoZWNrIGFsbCBtZW1vcnkgcmVnaW9ucyBhcmUgQ01SIG1lbW9yeS4gIFRoaXMNCndh
eSB3ZSBjYW4ganVzdCByZW1vdmluZyBhYm92ZSBzYW5pdHkgY2hlY2sgY29kZSBoZXJlLg0KDQpX
aGF0IGRvIHlvdSB0aGluaz8NCg0KPiANCj4gPiA+ID4gKyAqIGFuZCBkb24ndCBvdmVybGFwLg0K
PiA+ID4gPiArICovDQo+ID4gPiA+ICtzdGF0aWMgaW50IGFkZF90ZHhfbWVtYmxvY2sodW5zaWdu
ZWQgbG9uZyBzdGFydF9wZm4sIHVuc2lnbmVkIGxvbmcgZW5kX3BmbiwNCj4gPiA+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgaW50IG5pZCkNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKyAgIHN0cnVj
dCB0ZHhfbWVtYmxvY2sgKnRtYjsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgdG1iID0ga21hbGxv
YyhzaXplb2YoKnRtYiksIEdGUF9LRVJORUwpOw0KPiA+ID4gPiArICAgaWYgKCF0bWIpDQo+ID4g
PiA+ICsgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICBJ
TklUX0xJU1RfSEVBRCgmdG1iLT5saXN0KTsNCj4gPiA+ID4gKyAgIHRtYi0+c3RhcnRfcGZuID0g
c3RhcnRfcGZuOw0KPiA+ID4gPiArICAgdG1iLT5lbmRfcGZuID0gZW5kX3BmbjsNCj4gPiA+ID4g
KyAgIHRtYi0+bmlkID0gbmlkOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICBsaXN0X2FkZF90YWls
KCZ0bWItPmxpc3QsICZ0ZHhfbWVtbGlzdCk7DQo+ID4gPiA+ICsgICByZXR1cm4gMDsNCj4gPiA+
ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiArc3RhdGljIHZvaWQgZnJlZV90ZHhfbWVtb3J5KHZv
aWQpDQo+ID4gPiANCj4gPiA+IFRoaXMgaXMgbmFtZWQgYSBiaXQgdG9vIGdlbmVyaWNhbGx5LiAg
SG93IGFib3V0IGZyZWVfdGR4X21lbWxpc3QoKSBvcg0KPiA+ID4gc29tZXRoaW5nPw0KPiA+IA0K
PiA+IFdpbGwgdXNlIGZyZWVfdGR4X21lbWxpc3QoKS4gIERvIHlvdSB3YW50IHRvIGFsc28gY2hh
bmdlIGJ1aWxkX3RkeF9tZW1vcnkoKSB0bw0KPiA+IGJ1aWxkX3RkeF9tZW1saXN0KCk/DQo+IA0K
PiBEb2VzIGl0IGJ1aWxkIGEgbWVtbGlzdD8NCg0KWWVzLg0KDQoNClsuLi5dDQoNCj4gDQo+IEkg
YWN0dWFsbHkgd2Fzbid0IGFza2luZyBhYm91dCB0aGUgZm9yX2VhY2hfbWVtX3Bmbl9yYW5nZSgp
IHVzZS4NCj4gDQo+ID4gQW5kIGhlcmUgYmVmb3JlIHNraXBwaW5nIGZpcnN0IDFNQiwgd2UgYWRk
IGJlbG93Og0KPiA+IA0KPiA+ICAgICAgICAgICAgICAgICAvKg0KPiA+ICAgICAgICAgICAgICAg
ICAgKiBUaGUgZmlyc3QgMU1CIGlzIG5vdCByZXBvcnRlZCBhcyBURFggY292ZXJ0aWJsZSBtZW1v
cnkuDQo+ID4gICAgICAgICAgICAgICAgICAqIEFsdGhvdWdoIHRoZSBmaXJzdCAxTUIgaXMgYWx3
YXlzIHJlc2VydmVkIGFuZCB3b24ndCBlbmQgdXANCj4gPiAgICAgICAgICAgICAgICAgICogdG8g
dGhlIHBhZ2UgYWxsb2NhdG9yLCBpdCBpcyBzdGlsbCBpbiBtZW1ibG9jaydzIG1lbW9yeQ0KPiA+
ICAgICAgICAgICAgICAgICAgKiByZWdpb25zLiAgU2tpcCB0aGVtIG1hbnVhbGx5IHRvIGV4Y2x1
ZGUgdGhlbSBhcyBURFggbWVtb3J5Lg0KPiA+ICAgICAgICAgICAgICAgICAgKi8NCj4gDQo+IFRo
YXQgbG9va3MgT0ssIHdpdGggdGhlIHNwZWxsaW5nIGZpeGVkLg0KDQpZZXMgImNvdmVydGlibGUi
IC0+ICJjb252ZXJ0aWJsZSIuDQoNCg0KWy4uLl0NCg0KPiA+ID4gPiAgb3V0Og0KPiA+ID4gPiAr
ICAgLyoNCj4gPiA+ID4gKyAgICAqIE1lbW9yeSBob3RwbHVnIGNoZWNrcyB0aGUgaG90LWFkZGVk
IG1lbW9yeSByZWdpb24gYWdhaW5zdCB0aGUNCj4gPiA+ID4gKyAgICAqIEB0ZHhfbWVtbGlzdCB0
byBzZWUgaWYgdGhlIHJlZ2lvbiBpcyBURFggbWVtb3J5Lg0KPiA+ID4gPiArICAgICoNCj4gPiA+
ID4gKyAgICAqIERvIHB1dF9vbmxpbmVfbWVtcygpIGhlcmUgdG8gbWFrZSBzdXJlIGFueSBtb2Rp
ZmljYXRpb24gdG8NCj4gPiA+ID4gKyAgICAqIEB0ZHhfbWVtbGlzdCBpcyBkb25lIHdoaWxlIGhv
bGRpbmcgdGhlIG1lbW9yeSBob3RwbHVnIHJlYWQNCj4gPiA+ID4gKyAgICAqIGxvY2ssIHNvIHRo
YXQgdGhlIG1lbW9yeSBob3RwbHVnIHBhdGggY2FuIGp1c3QgY2hlY2sgdGhlDQo+ID4gPiA+ICsg
ICAgKiBAdGR4X21lbWxpc3Qgdy9vIGhvbGRpbmcgdGhlIEB0ZHhfbW9kdWxlX2xvY2sgd2hpY2gg
bWF5IGNhdXNlDQo+ID4gPiA+ICsgICAgKiBkZWFkbG9jay4NCj4gPiA+ID4gKyAgICAqLw0KPiA+
ID4gDQo+ID4gPiBJJ20gaG9uZXN0bHkgbm90IGZvbGxvd2luZyBhbnkgb2YgdGhhdC4NCj4gPiAN
Cj4gPiBIb3cgYWJvdXQ6DQo+ID4gDQo+ID4gICAgICAgICAvKg0KPiA+ICAgICAgICAgICogTWFr
ZSBzdXJlIHRkeF9jY19tZW1vcnlfY29tcGF0aWJsZSgpIGVpdGhlciBzZWVzIGEgZml4ZWQgc2V0
IG9mDQo+ID4gICAgICAgICAgKiBtZW1vcnkgcmVnaW9ucyBpbiBAdGR4X21lbWxpc3QsIG9yIGFu
IGVtcHR5IGxpc3QuDQo+ID4gICAgICAgICAgKi8NCj4gDQo+IFRoYXQncyBhIGNvbW1lbnQgZm9y
IHRoZSBsb2NrIHNpZGUsIG5vdCB0aGUgdW5sb2NrIHNpZGUuICBJdCBzaG91bGQgYmU6DQo+IA0K
PiAJLyoNCj4gCSAqIEB0ZHhfbWVtbGlzdCBpcyB3cml0dGVuIGhlcmUgYW5kIHJlYWQgYXQgbWVt
b3J5IGhvdHBsdWcgdGltZS4NCj4gCSAqIExvY2sgb3V0IG1lbW9yeSBob3RwbHVnIGNvZGUgd2hp
bGUgYnVpbGRpbmcgaXQuDQo+IAkgKi8NCg0KVGhhbmtzLg0KDQo+IA0KPiA+ID4gPiArICAgcHV0
X29ubGluZV9tZW1zKCk7DQo+ID4gPiA+ICAgICByZXR1cm4gcmV0Ow0KPiA+ID4gPiAgfQ0KPiA+
ID4gPiANCj4gPiA+ID4gQEAgLTQ4NSwzICs2NDUsMjYgQEAgaW50IHRkeF9lbmFibGUodm9pZCkN
Cj4gPiA+ID4gICAgIHJldHVybiByZXQ7DQo+ID4gPiA+ICB9DQo+ID4gPiA+ICBFWFBPUlRfU1lN
Qk9MX0dQTCh0ZHhfZW5hYmxlKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArLyoNCj4gPiA+ID4gKyAq
IENoZWNrIHdoZXRoZXIgdGhlIGdpdmVuIHJhbmdlIGlzIFREWCBtZW1vcnkuICBNdXN0IGJlIGNh
bGxlZCBiZXR3ZWVuDQo+ID4gPiA+ICsgKiBtZW1faG90cGx1Z19iZWdpbigpL21lbV9ob3RwbHVn
X2RvbmUoKS4NCj4gPiA+ID4gKyAqLw0KPiA+ID4gPiArYm9vbCB0ZHhfY2NfbWVtb3J5X2NvbXBh
dGlibGUodW5zaWduZWQgbG9uZyBzdGFydF9wZm4sIHVuc2lnbmVkIGxvbmcgZW5kX3BmbikNCj4g
PiA+ID4gK3sNCj4gPiA+ID4gKyAgIHN0cnVjdCB0ZHhfbWVtYmxvY2sgKnRtYjsNCj4gPiA+ID4g
Kw0KPiA+ID4gPiArICAgLyogRW1wdHkgbGlzdCBtZWFucyBURFggaXNuJ3QgZW5hYmxlZCBzdWNj
ZXNzZnVsbHkgKi8NCj4gPiA+ID4gKyAgIGlmIChsaXN0X2VtcHR5KCZ0ZHhfbWVtbGlzdCkpDQo+
ID4gPiA+ICsgICAgICAgICAgIHJldHVybiB0cnVlOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICBs
aXN0X2Zvcl9lYWNoX2VudHJ5KHRtYiwgJnRkeF9tZW1saXN0LCBsaXN0KSB7DQo+ID4gPiA+ICsg
ICAgICAgICAgIC8qDQo+ID4gPiA+ICsgICAgICAgICAgICAqIFRoZSBuZXcgcmFuZ2UgaXMgVERY
IG1lbW9yeSBpZiBpdCBpcyBmdWxseSBjb3ZlcmVkDQo+ID4gPiA+ICsgICAgICAgICAgICAqIGJ5
IGFueSBURFggbWVtb3J5IGJsb2NrLg0KPiA+ID4gPiArICAgICAgICAgICAgKi8NCj4gPiA+ID4g
KyAgICAgICAgICAgaWYgKHN0YXJ0X3BmbiA+PSB0bWItPnN0YXJ0X3BmbiAmJiBlbmRfcGZuIDw9
IHRtYi0+ZW5kX3BmbikNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsN
Cj4gPiA+IA0KPiA+ID4gU2FtZSBidWcuICBXaGF0IGlmIHRoZSBzdGFydC9lbmRfcGZuIHJhbmdl
IGlzIGNvdmVyZWQgYnkgbW9yZSB0aGFuIG9uZQ0KPiA+ID4gdGR4X21lbWJsb2NrPw0KPiA+IA0K
PiA+IFdlIG1heSB3YW50IHRvIHJldHVybiB0cnVlIGlmIHRkeF9tZW1ibG9ja3MgYXJlIGNvbnRp
Z3VvdXMuDQo+ID4gDQo+ID4gSG93ZXZlciBJIGRvbid0IHRoaW5rIHRoaXMgd2lsbCBoYXBwZW4/
DQo+ID4gDQo+ID4gdGR4X21lbWJsb2NrIGlzIGZyb20gbWVtYmxvY2ssIGFuZCB3aGVuIHR3byBt
ZW1vcnkgcmVnaW9ucyBpbiBtZW1ibG9jayBhcmUNCj4gPiBjb250aWd1b3VzLCB0aGV5IG11c3Qg
aGF2ZSBkaWZmZXJlbnQgbm9kZSwgb3IgZmxhZ3MuDQo+ID4gDQo+ID4gTXkgdW5kZXJzdGFuZGlu
ZyBpcyB0aGUgaG90LWFkZGVkIG1lbW9yeSByZWdpb24gaGVyZSBjYW5ub3QgYWNyb3NzIE5VTUEg
bm9kZXMsDQo+ID4gbm9yIGhhdmUgZGlmZmVyZW50IGZsYWdzLCAgY29ycmVjdD8NCj4gDQo+IEkn
bSBub3Qgc3VyZSB3aGF0IGZsYWdzIGFyZSBpbiB0aGlzIGNvbnRleHQuDQo+IA0KDQpUaGUgZmxh
Z3MgaW4gJ3N0cnVjdCBtZW1ibG9ja19yZWdpb24nOg0KDQplbnVtIG1lbWJsb2NrX2ZsYWdzIHsg
ICAgICAgICAgIA0KICAgICAgICBNRU1CTE9DS19OT05FICAgICAgICAgICA9IDB4MCwgIC8qIE5v
IHNwZWNpYWwgcmVxdWVzdCAqLw0KICAgICAgICBNRU1CTE9DS19IT1RQTFVHICAgICAgICA9IDB4
MSwgIC8qIGhvdHBsdWdnYWJsZSByZWdpb24gKi8gICAgICAgICAgICAgIA0KICAgICAgICBNRU1C
TE9DS19NSVJST1IgICAgICAgICA9IDB4MiwgIC8qIG1pcnJvcmVkIHJlZ2lvbiAqLyAgICAgICAg
ICAgICAgICAgIA0KICAgICAgICBNRU1CTE9DS19OT01BUCAgICAgICAgICA9IDB4NCwgIC8qIGRv
bid0IGFkZCB0byBrZXJuZWwgZGlyZWN0IG1hcHBpbmcgKi8NCiAgICAgICAgTUVNQkxPQ0tfRFJJ
VkVSX01BTkFHRUQgPSAweDgsICAvKiBhbHdheXMgZGV0ZWN0ZWQgdmlhIGEgZHJpdmVyICovICAg
ICANCn07ICAgICAgDQogICAgICAgIA0KLyoqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICogc3RydWN0
IG1lbWJsb2NrX3JlZ2lvbiAtIHJlcHJlc2VudHMgYSBtZW1vcnkgcmVnaW9uICAgICAgICAgICAg
ICAgICAgICAgICAgIA0KICogQGJhc2U6IGJhc2UgYWRkcmVzcyBvZiB0aGUgcmVnaW9uICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICogQHNpemU6IHNpemUgb2Yg
dGhlIHJlZ2lvbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIA0KICogQGZsYWdzOiBtZW1vcnkgcmVnaW9uIGF0dHJpYnV0ZXMNCiAqIEBuaWQ6IE5VTUEg
bm9kZSBpZA0KICovICAgICAgICAgICAgIA0Kc3RydWN0IG1lbWJsb2NrX3JlZ2lvbiB7DQogICAg
ICAgIHBoeXNfYWRkcl90IGJhc2U7DQogICAgICAgIHBoeXNfYWRkcl90IHNpemU7DQogICAgICAg
IGVudW0gbWVtYmxvY2tfZmxhZ3MgZmxhZ3M7DQojaWZkZWYgQ09ORklHX05VTUENCiAgICAgICAg
aW50IG5pZDsNCiNlbmRpZiAgDQp9OyAgICAgIA0KDQoNCg==
