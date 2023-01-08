Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4B5661A72
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 23:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbjAHW0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 17:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbjAHW0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 17:26:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB66120;
        Sun,  8 Jan 2023 14:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673216795; x=1704752795;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=15k16tzidb2IcbySRd2AY7XLYEbv33AogqhOPh1NLXY=;
  b=PrGSsv0GzRG+y4VXsFXeHxANomP2txnQxGWUm/Wy97I5icrOglqu3Onq
   UMpnkI1b1BVmyiir591H7dAn9j3ICRd8UPEJByq9n3eeKShQhIAJ8yZgs
   6juqdj5oB2I4xV/gScCTouYTeyqzTZwMZxdHCn7AABDf4ss0O9uWD4VJM
   DEF+vhxHpoI2shmApnYU6Nb3D50QwID9gHEfsgS19WAJxYM32Icwp4DaM
   ppy+O3Lw17wKKrbFKeSnJahF0llbGNl/3nN3Hz2lTeUWiHeH/UjpessxP
   Xah29JM8sSG9YiH8gH3DAaonqysR9I3K7ZqKsht7H85JlBCabpFfqBLGg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="322832683"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="322832683"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 14:26:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="764109923"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="764109923"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jan 2023 14:26:35 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 14:26:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 14:26:34 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 14:26:34 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 14:26:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQfzMhZgniyk/r5UjtI8An4B34qjZWnePq+dyG081Ivi7v5ATu9STrEkn6p0OrtOQ/tXvvcygHoNqiJmj4iTh+/tJOTNyGLtN7sXB1GlNGFSNhzk7S5WkrnvUD7d/kRb2ls69dfdekvS+j1/XLoNnlQ1rYYVA2OFBsn2ndtsGapuJ6UblAuhY3u/8+n57CrmuyQBSTfnEp4Ab8pkmaw8DDuZ2qPtsvGunRSRdzJteNx308ni5tKnGfYy3ENgYzsa+oEqF6hUoXvuNYoTzL4Ubvr404rXyUX6VZXtsgO7RrLzg3A0XIyqifcmLXYnIqQekm4UpaxatQHGs4VMcGPV1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15k16tzidb2IcbySRd2AY7XLYEbv33AogqhOPh1NLXY=;
 b=Y87b7cc13q7FyXDR4wf0SSpxu7t2Jyc+a9GuHUMEDaX1x6Kw+CIPECZy9/2QveNr4TKJ623moj//eS8pCdmSra0YxxoBr7TdmSBfb19KPkBkSlHzwp6S3e5LAi0F1HWn49KgdeNDXAL74yWv7gXVON20JKiWohhOMa69L/KLLBeVE5UETD7Ch5k2mf3UxrBJgk3qCL2wa/hR4Xbe4qeHgiol2PRO08AfL3Wg+cN2Pw9Otvvx1ZZDtjR3dRTiMrw8+NDw/lveDw2szpd/M9rtAz3UVKYeRiOJyyfQtbiQWzHnSQsncI1DY7jUHXK9/GFV5ZEYsnb0FeMCfRxOwdf/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6183.namprd11.prod.outlook.com (2603:10b6:208:3c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 22:26:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 22:26:29 +0000
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
Subject: Re: [PATCH v8 04/16] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Topic: [PATCH v8 04/16] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Index: AQHZC5gA7tfEz97ZIEyLnOigH9xmQa6RzYmAgAN7xwA=
Date:   Sun, 8 Jan 2023 22:26:29 +0000
Message-ID: <145def74bc800a625d51f528c20c1be4da8c9e27.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <5ea3f199c0d6f9f3e1738fa5c211c52d4d618e84.1670566861.git.kai.huang@intel.com>
         <b6e72ab7-eb48-22bb-f7f7-6869408d1dda@intel.com>
In-Reply-To: <b6e72ab7-eb48-22bb-f7f7-6869408d1dda@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6183:EE_
x-ms-office365-filtering-correlation-id: 6fab6e14-6e1a-447c-224d-08daf1c76332
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KP8Xuhq5s+aSJZZVp+LN5yNDxk4b2XDK4SxT25mUQGMvsdia7lQkRt4cFFwkYAPE3q0xjyg7gSlH/29dmvV1hAHvfihQxdJK/SSPUn9cY1AuRARJgRXHX4OP9tcSkWow2HXIvXYkZGtQ+u2zh+/V8htF2YpOtpJkk5UiHPOQfMsbD0pIS3rZE7i1mp3WQJ4rZZxwnYsq0GVrSkTWxUbadMHWzeLB8wPQlHk0MYl5i547dgkzPhYyfm19WJr9Ntgh7nq1OAD8DsR1I8Ejbz4MYn48DFh216xhoP9TL5P0ephf0d93K3tNyopo7ztOA3J7o2FhRx2jRu7o5dWES/DNz3oEyKHT6VpV6bqWMkE42CXJxE4G+dxsuIsPg/PSmvixvROWc/4mNk6w5nf3r4bW50j8nLZlFnffoJ5CcYBukUTn7CC9O9wPdIA6T0oHk47Y3mEZsUYmlMBj6786DzL4ffROnINE6Rgx/SDbH3ylJLX5N58P6jN04MAcbjqQBjususwmZ4mCQ8QrgLIwNTpAuYlFBbtzffSJwWzaGl5WP2Rc1qQ4jsLDRuUUbfE2q2h+50PNlewtDQrw4UxdVsM4/sjoRgOd0sEfNiJFA5izWxDMAZOjKl4WxEpNmOcN1WmnLionhUVDRXPP2GWgttgUluhyuj0Drqikfd5cypMIF4/dO65FRPhSHBgiV4vqsr0OwP1bcrlrq8g5FlKbo2lyLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(41300700001)(8936002)(5660300002)(36756003)(7416002)(2906002)(8676002)(76116006)(66476007)(91956017)(64756008)(66556008)(66446008)(66946007)(316002)(71200400001)(110136005)(54906003)(6486002)(6506007)(53546011)(478600001)(6512007)(26005)(4326008)(186003)(2616005)(86362001)(38100700002)(82960400001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlJFVnVlRzdjQkFhVGVmNlliazU3UmVLd0Fod2FPVEgveVh0bCsveGp4Z3JU?=
 =?utf-8?B?TG5PNll0a2hiTm1sVnlneDJyei9KWEFpOEs3N0tkL0x1dXNMRndPMjhsbi9w?=
 =?utf-8?B?Y2NPZFZ2N2VQUXBudC92eEFiQkNoQmFEMzEzY01ZMUZnb1FadkNPakE3djkr?=
 =?utf-8?B?cC9oQjJzdVBQL2pTZXJScE9vRHF4eDVIMkV0NHBoVmQ5azQ1V0Fsd1B0UFJS?=
 =?utf-8?B?cXdQL0M0UWpVQm9KQ1JuNFlMTktOeU5PRjAyNzIra1lXQmx4aUF3R0RjdHVP?=
 =?utf-8?B?clV5bGEyUnhqNG11Q29mTk5xMjhYcW1aQ1dvM04zWG1nekZqenV4RTJjdVhi?=
 =?utf-8?B?cFM2cEkzamJlc2kvb0ErMlJaalFSRWFYTTNPeEJEcGFsQWFaUDNJMEd6UU9C?=
 =?utf-8?B?SGlneWI0R0VHN1R5ZU9JazBuRHB5N3FsK0ZMRFBKNHZMMUtCSFRIc0VSUlZ6?=
 =?utf-8?B?MUVkQktyZEF4M1dIMDBHK0s0S2xkUHYwV2Y4ZmJtdGdpMTZtQTZRZEtPNWNV?=
 =?utf-8?B?UDZZWHhZbDNkNk1kU3plSXRqT3QvbzM4Y0VKTVFuSHR6M21NODBhQmRUc1pX?=
 =?utf-8?B?UUJkQ0xhWS9YRkpYaXFybTlRUndhSW9sd05VRXlYL3MxZURXZXJuWjR3SWxa?=
 =?utf-8?B?RWNGSmxZWFdvaUd3eU1DNEp0TW1QejB3VnY4Z2svTUc4V21COEZFNjVJcjhr?=
 =?utf-8?B?RTdVUVBxK0tXTlZpTHFjbE11Uk0xSkV3UVo5eFlvdm1RZ3NOVjIzbzZoNGhN?=
 =?utf-8?B?a2lkUFVTbXJZV3dTV3lwN3FNbCtKU1FqczVHN3MyQXVWVE9iN1VFUjFHWTNt?=
 =?utf-8?B?ai9iNU1uczJRM0tSLzRXWWowemNseGJBeHliYk1qcm1HcFhERklhMTFmajh5?=
 =?utf-8?B?QWZBZmU1ZmhwbWkxcm12SEsxWGlhcFQ0RE9hbllsSFplSVNpN0ZhaTdZMUt3?=
 =?utf-8?B?a1NKR3VuZ2tsV2laVm10bjRQVkcxMTl3SjliczRmZEJyM0pUSll6TDdSaElq?=
 =?utf-8?B?Tys3aTdhNGJBcFVuTWxFTVg4VENUeXd3YkZGVFZqa1ZVSXorTG1tRXFDakx2?=
 =?utf-8?B?V1FtZzRVZmwra3VwR05SdEFYdXZYM0VBTVpoRFAvai85U1gveHVzNmRrcVp4?=
 =?utf-8?B?eHlLcTI1TmJ4TmowZTU2Tmx5VDZsbzFOWUV1SHhiTS9PaXVIaW9KajR4d0ho?=
 =?utf-8?B?TXllZDRpcWlsSmE2aUhUSHc5VVNyQ3ZZbUlWNWNIbmNocTVRc21MYzYwQzNZ?=
 =?utf-8?B?TGZDUm8vdDdmWHpnbzRTYThCekhxRk9INXZFQmJneEYxMHFaK3cvaTZIR1RI?=
 =?utf-8?B?RTVCaTBtTm5DREtIaWFqMUxmN0VReVVhM3lBTnJaUy9DTVhJL3BCNkQ0VzF3?=
 =?utf-8?B?ekl3bDNJYldhbkY4Qm5MZE1CZWZ5QThoVW4waW1oS3lOVUxNRDgrODRhZHVu?=
 =?utf-8?B?Vy9UY2xzNGhXZk9sNEZjblRWekM1SVpGcDBTVzlRQUNpOXFOOWtrRlppaVdr?=
 =?utf-8?B?TnFqNTMrdzBwTTJTdXduUU9uSFhhMmlhY0lnT2Y1WldQc08yZ3FBeWttcXpz?=
 =?utf-8?B?dWEvYmFXRVpBOThvMThuRURSVXdQckVmTUp5azVlNEhWa0x6MGVvQmtPRSt6?=
 =?utf-8?B?aTNMOCtoQmY1SkpGV1orTmdaR0dLeDg1RzhWZ3ZXaDJudmVHTGQ3d2NjaGRv?=
 =?utf-8?B?T09HbUNITTEvSitSUjg2V0hYU09CQ0o0eGFQZVIxdGE3NC9rYThhUDRVUVRQ?=
 =?utf-8?B?UmlBYVNoWXo5UG91RGZ4SmhRQSsyWUMwVjV0QTRjU3QyTytXaUlKTi9Cdkw5?=
 =?utf-8?B?cWE4TFBtYnk3aFBIMEJ0bklrRlRQV1NOQU04RWRiUlF1Yko2WFJvL2U5aGpY?=
 =?utf-8?B?OFp2K2RKSVUzZ1cvU2VzR1VSOTJWUUJJVGNVVXQyZWV0bm5vTjZHOXVHQjR1?=
 =?utf-8?B?L2dJZ1Bmb0FQeTkyS1dlN3NrQ2dLa0ZUTWZmZkJtUGp3TmZOdE41M2crcTdH?=
 =?utf-8?B?UXZwRHRWTks1WnNqSzVwK2U3TytreXl1THA2ZWpQaXdxR051QTExUk14Njhn?=
 =?utf-8?B?dDRlbW83UFpPOXhrdWV5eFdBVVJsZU5LZVRYaHQ2TEhNUURvUGNReWQyVFl5?=
 =?utf-8?B?dmQzWEMveFdHNXpJYmxCMldjNHpQUjVjNnkrUkM5UXJUNXY3UW5JZFlVbkln?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FF9AA1FB4B50149960DCA1E0900FDE4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fab6e14-6e1a-447c-224d-08daf1c76332
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2023 22:26:29.0893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0H+pIczWBG6lnB8o9OgW+NCHuU8LnSrJs8L9SPiEliffQeZDLxgt9vTMnOwxykTW7zlrim/Ue4wXUVjFJH/L+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6183
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDA5OjE0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+IFRoZSBURFggbW9k
dWxlIHdpbGwgYmUgaW5pdGlhbGl6ZWQgaW4gbXVsdGktc3RlcHMgZGVmaW5lZCBieSB0aGUgVERY
DQo+ID4gbW9kdWxlIGFuZCBtb3N0IG9mIHRob3NlIHN0ZXBzIGludm9sdmUgYSBzcGVjaWZpYyBT
RUFNQ0FMTDoNCj4gPiANCj4gPiAgMSkgR2V0IHRoZSBURFggbW9kdWxlIGluZm9ybWF0aW9uIGFu
ZCBURFgtY2FwYWJsZSBtZW1vcnkgcmVnaW9ucw0KPiA+ICAgICAoVERILlNZUy5JTkZPKS4NCj4g
PiAgMikgQnVpbGQgdGhlIGxpc3Qgb2YgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucy4NCj4gPiAg
MykgQ29uc3RydWN0IGEgbGlzdCBvZiAiVEQgTWVtb3J5IFJlZ2lvbnMiIChURE1ScykgdG8gY292
ZXIgYWxsDQo+ID4gICAgIFREWC11c2FibGUgbWVtb3J5IHJlZ2lvbnMuDQo+ID4gIDQpIFBpY2sg
dXAgb25lIFREWCBwcml2YXRlIEtleUlEIGFzIHRoZSBnbG9iYWwgS2V5SUQuDQo+ID4gIDUpIENv
bmZpZ3VyZSB0aGUgVERNUnMgYW5kIHRoZSBnbG9iYWwgS2V5SUQgdG8gdGhlIFREWCBtb2R1bGUN
Cj4gPiAgICAgKFRESC5TWVMuQ09ORklHKS4NCj4gPiAgNikgQ29uZmlndXJlIHRoZSBnbG9iYWwg
S2V5SUQgb24gYWxsIHBhY2thZ2VzIChUREguU1lTLktFWS5DT05GSUcpLg0KPiA+ICA3KSBJbml0
aWFsaXplIGFsbCBURE1ScyAoVERILlNZUy5URE1SLklOSVQpLg0KPiANCj4gSSBkb24ndCB0aGlu
ayB5b3UgcmVhbGx5IG5lZWQgdGhpcyAqQU5EKiB0aGUgIlRPRE8iIGNvbW1lbnRzIGluDQo+IGlu
aXRfdGR4X21vZHVsZSgpLiAgSnVzdCBzYXk6DQo+IA0KPiAJQWRkIGEgcGxhY2Vob2xkZXIgdGR4
X2VuYWJsZSgpIHRvIGluaXRpYWxpemUgdGhlIFREWCBtb2R1bGUgb24NCj4gCWRlbWFuZC4gIFRo
ZSBUT0RPIGxpc3Qgd2lsbCBiZSBwYXJlZCBkb3duIGFzIGZ1bmN0aW9uYWxpdHkgaXMNCj4gCWFk
ZGVkLg0KDQpZZXMgYWdyZWVkLiAgV2lsbCBkby4gIFRoYW5rcy4NCg==
