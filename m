Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972CF631CF3
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiKUJhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiKUJhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:37:20 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243D978198;
        Mon, 21 Nov 2022 01:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669023439; x=1700559439;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lijQCV2JmROsTcKLzR4mJ3MmhEu/5zY31cx3jJJj2e0=;
  b=TRuAF5xio85jY69WT9wj7bdPy4rePo+9nKdNJtCMyn2LnqYXt+T4CGgt
   w2ogr9ciOXY3Nz3BbolT5IzQ0ktK85S1XYxBbicWlWiT2yzjCw+xh/ngC
   QB1UMj0+ho1jdLzz7dg63wDEaXFL56uUICFlp8RvyugGpKpdKvR2iAkIK
   rRRqqujqmFIKkJiLf7csh0UgXpqZBRoweJGzyWcJwWq2ZN/8TD3AsogGf
   gNYvaJttLK/ebWn340cggfSe4/zkJKnt4Q1AuyfNg+o/GjoI0JXUeMov0
   VjNfA8+4mabnHKmfwbhKRRRHaPSQcF5Oiel7Nw4BGkFZz9SP+nylroNum
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="313545841"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="313545841"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 01:37:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="591706698"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="591706698"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 21 Nov 2022 01:37:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 01:37:17 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 01:37:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 01:37:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 01:37:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRRLWD3LRdyrRuqECGWtXqpZziR15s8UYqq/67bwYDUG5f3D09PJS/DyOXanRFjNYlpKAQjYVhH3l4qxnXhZ70TZWpjZXSxKhIl77mDLVJrsKelKeoI1V8JjTswATrtWA6vMJVddNyxx1gnodNjzwnl2P8ivPjPzdYgyVkCkzK/TsZMQMwygNNKsAPIaNsGMbv2ickhEp/17uOcHW7L6bU/Z7CfRnYz17Cw7Q/cZi9CPEUQ22B3z5ATbzTrILNKeZaEjX8LeNSpCUMso+mDsIOgNUQbyOJKYH7fpPla83qOb9stkrY3qOPqxgO7xdkNVccdopYXkVL5tM1SYr2bKeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lijQCV2JmROsTcKLzR4mJ3MmhEu/5zY31cx3jJJj2e0=;
 b=CppTHLvDrmhEC5pTkYMO/mCUPriQnDMBqfQP0xq8j10dotVVI4NX4seBYogLbZU8vf08q8jnVVjwJ96ojzfn4YZB9CwTE4j/LGjFvhlimI8RvWM8OSUOqwbJM7HV4nHSL1DsZWg7Qt0TqwHwEarSH/yaYZnFX1noprXW9Yr0m+LqJpL5OWIodIJh+3hWxL77GdOLD4U8BVM64zpMZduQdutHD3YRycF10oWREPA7yLNz2Cp/i9GwE57l35ahTtNqNeNnCC7hY3cSuAhxt+c1lVAHdht/Su3YOnfcv+9Bq1R+MSFaOM861YWVr8E9KssBFqVl6Cm5C5r0TnYW9sEy/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4879.namprd11.prod.outlook.com (2603:10b6:a03:2da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 09:37:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 09:37:14 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 02/20] x86/virt/tdx: Detect TDX during kernel boot
Thread-Topic: [PATCH v7 02/20] x86/virt/tdx: Detect TDX during kernel boot
Thread-Index: AQHY/T294K8swb3sVUCgXbqBp7bt565IskoAgABs5YA=
Date:   Mon, 21 Nov 2022 09:37:14 +0000
Message-ID: <827adb3d1610f43ce71b1491db8c680dbe095035.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <aaee2d5332a97c840ad401ba935842a998a877ec.1668988357.git.kai.huang@intel.com>
         <3e4644e4-d939-7f15-02e1-a6be1ed7f932@linux.intel.com>
In-Reply-To: <3e4644e4-d939-7f15-02e1-a6be1ed7f932@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4879:EE_
x-ms-office365-filtering-correlation-id: af95307b-218e-45a9-b81b-08dacba3f925
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cDx50mhCgnnIjLfsHEF2jwBnuRHXgYT0GgJLa2tiCVnFq6MTlKieALEbldW9u4ZuO5jejnxm3cuT77oMFoaXsGt8Dw9btkxHXIseyH0LOPuws84CRqOfIQvUe/5p0sGIZ5tGgeEulnnroqJmApetwAiJPqwGeSw2b1aCUHE8puCz/WrsD7xtdn9263rjEEfa59HfED2l21U1Y1A4UoJYIlFHCAAtRaC5TChdCsHbZaaCpVTWIqy97VHRjbmFlI8IFqWZhSnXRw2qGzgPWGpzda3ZMAbbo8L/d/P9maEDJInxxZGhGBjjqltxMXQPuiplWBC3kUaeP9v1zcM9JweN3U/n+kQox7qUFzG6WGZt4rqXhToQ69aCSKXaSxXIFDizIaRbadD5/UBwK6zKZ4qzKoj6ost4tc/0baeiFY4+T256TZHEAKJsFj6y7oqpaPtBP9NjKwOI/dglOGyO3ubKiMizkcVTatbhnKevJr393VBWbrnFRHfPRXsuHzk08X0uQRF1+VepNSOo7Rfo8ymB1kT32TVM/aopDclQrzyCKf6C9S4S4b68sI9YBdP3Hwy7AucwIIl50phmHhomeETez6Qf0WO7jPb0ntmM2tAoW0kDxgxDlDydVIREH1Y0txCJ+QssenvBU8AAvetJTbHp2FRPPY70NEI7tB3duZ6wKY9T/WCW8gc3UDkGd1l7DNI6Q3edHH6Or4mIg4OWk/8GdYz/w+PhTa+i96/bMzuDVHo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199015)(36756003)(38070700005)(86362001)(64756008)(76116006)(5660300002)(7416002)(2906002)(26005)(2616005)(186003)(6512007)(38100700002)(122000001)(83380400001)(82960400001)(91956017)(66556008)(54906003)(6486002)(71200400001)(8936002)(41300700001)(66446008)(110136005)(66476007)(66946007)(316002)(6506007)(478600001)(8676002)(4326008)(290074003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXBmNmdEdExCaHlmZnpjdThZNFdSODhrdVI5dUYvbUZ1WVUvbHREeGt4NktO?=
 =?utf-8?B?aWtidngvMGtNQ01pNzNmZHBIZXVGSlRpNzN4c2QrSnFPWHdDaW9Jb3dQZFRC?=
 =?utf-8?B?UzVRSUY3M09DR2NOR2ZuYkZsVUZ2NFhXeEpGZzNyYVVzd21ZdjRvNkRBRFU2?=
 =?utf-8?B?d3ZTSXRDWHZ1ZTU1NUR5RXkrekdxRVN4SXcxaEY1cklZa3FUNUZKTjExMW5J?=
 =?utf-8?B?Q0xwUnQ0bHdwMzVuZTZQS3prYU03V3JSUzkxOERxL1NONkw3RVRadXNwcWdZ?=
 =?utf-8?B?cEJVdk9LV3BRRGw1Z1dua3hxWWNOYU9wS0pOeTRxTSs2d2ZSMUh5d2h4QWhV?=
 =?utf-8?B?aTNPRTJiaXkrTFA1cTkvRVRhVFZBc0NDbEl4dkZGamsrY3ptd0Z0a0YrbUps?=
 =?utf-8?B?ZWpVYVRmek9oeTNxT0tjdVFVRkJINllieFgzcmNMWHd6YURLYzJKSSt6ajdn?=
 =?utf-8?B?Qk5nTEhwTm53UmE4Ry9FRWtMTG4rd0lzaEVQNEJwRWhXSDFvUC9KRnloeDVY?=
 =?utf-8?B?bENGdkkycy9JZmdwV2E1R0s1bWU5ajdhako1K2E4amxlZEsxWGNJcWp4a0lz?=
 =?utf-8?B?bUx1dnAzbGxibXZTb0JMOWUxTTUzcXZEWUNxeWZIdmFFT0k2UTVGTHRKRjUy?=
 =?utf-8?B?R25qTTU5YnF6WlJrb3ZuL05saWRIK3k5SklGamI1R1dWSG1sc0c4cGZZM2Nv?=
 =?utf-8?B?N056SE03Ni80aGkrWWYzQlRiYmpQdTlnd21ueXBDSVpRdXZrOWpNdWdGdmlR?=
 =?utf-8?B?L09jZUxsOG5nUHMyUisyVnA5cWx5ZWZHRlJwVzdlZEQ2ODZIelQwUjdHbVNL?=
 =?utf-8?B?ZmduNFFqY3ZyYTBWd2x6bWRkMHhBVUs4dHByeFYzRVZUdkRBT2dEZWE1c3lv?=
 =?utf-8?B?V1dLYjFpRzEyWUtPYlpiby9mMUFMQktISlZKbklNZTVnVDhWYmhrY2prSlg4?=
 =?utf-8?B?cVRTTnJkMUN4OSt4STBOQ0JSemMwODduaVQzRkRZd2E4MzVnanpWOWJaUjky?=
 =?utf-8?B?cEhOUzBiOEV2Sm00NVFUWDBjS2paSEJReURHYUpIR2JleVlJUTdFbko5ZW1a?=
 =?utf-8?B?anFIVmQ0VG5oaDBZN3VDL0RDWThKd3RHOXY5RDkwMlRraHVRRVJ5YVA4VGhH?=
 =?utf-8?B?UFRhUnRFYWd4YlkrV2VGVVNEQml4eFBrKzBWZkNUMzhCaHBNZmFRU0RpWmhp?=
 =?utf-8?B?dFRFNjNvTE1oMW1ob04xK3NSaFVIN3hleWx3MlNVcndHc29XVUpqdWJpZFUw?=
 =?utf-8?B?MWlXYmsrdGc4bU1aWEFWVmpPS1UzMXpSSkhtZTQrbWk2ZTlZL1IwOXpaZGZk?=
 =?utf-8?B?ZXRZYjVtcnQrdE9HVU9ZdzUxemMzRzZYSTgxR0JlYnNXT2x0RG9QcWxiVkdn?=
 =?utf-8?B?RGowdDMvNHBoTG1TajdzYTNiMk8xclZLeHV1SVZGaHZKblZFN0xoYnp6MFpj?=
 =?utf-8?B?Zlk4clVreUMyOVBETVdsTEpYNm5tZGFpeDU2MFZxSC9iTGNNWHFkd3V5S0No?=
 =?utf-8?B?N1RCbnpqSXJxK3NGakxwZTVmUUFBWit4S0Fzdkd3dk1wRkJpNXBqeDVjb0dY?=
 =?utf-8?B?WDZrTWMyQ09yUUdyaDBUaUUxY3NwK1V2Y25mM1BvS2IyMFV4UFU1S3pab25K?=
 =?utf-8?B?MVNwUUV1cmFPT3hyK3djcW1vM3ZOQk40TmxLTUxEUDZmbFVlai9PMjA1N2xM?=
 =?utf-8?B?MVJvbjRCTXNHSHBJMUYxckxLd1p4Vm9kVUxUNktLcU92VCtmdCsvWjE1bVZ0?=
 =?utf-8?B?cC9sMHJDQ3lyQm94UEFPUVROcXJmYVdjczNqSjdRYTNMTndSWk96aE4vcys0?=
 =?utf-8?B?VGwvS2FqWjBydGFQejJ4dlBtTzM0WjZIaVVkV0tIUjNab3BGcU1MbDlzWUlp?=
 =?utf-8?B?MlFJcmw3UEZ5YjRodmlHWEF2M1IwRjNHVDhnWW5xWXFSaG1DK3I5Rm1KYVEx?=
 =?utf-8?B?UjBDL1dpcmRUNUwvZk43Z3lEK0pxSkVLYWpPTW8yWlBMakRCdWhWQUVlZU53?=
 =?utf-8?B?bkErSWhoV2VRVzZqOUxma2lFdW10a1Z2WnU3SWJ5QXNPTjZKeVE5T2hwcVE1?=
 =?utf-8?B?Yk5UeXZLZFpTS2wybnlIaFJXWDM2VmJZVS9WT0NpeXpQUXowdFR5dzhCS0hC?=
 =?utf-8?B?K3lwT25TS0xxajB5UE9BSjRPUEh2clhYbGpEU2xVRy9ITVdGRStvL04wWFZ3?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B9B81C63D23EF438B84325A27FB92B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af95307b-218e-45a9-b81b-08dacba3f925
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 09:37:14.5816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbTgQK17g/cC2beiTZMUanrSpilcvd0EubOIJCP+Xd1gjKPiubf2Rmxc1QGKVets4Oo/PZN1idfn5ZzDc8l5hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4879
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gK3N0YXRpYyB1MzIgdGR4X2tleWlkX3N0YXJ0IF9fcm9fYWZ0ZXJfaW5pdDsNCj4gPiAr
c3RhdGljIHUzMiB0ZHhfa2V5aWRfbnVtIF9fcm9fYWZ0ZXJfaW5pdDsNCj4gPiArDQo+ID4gKy8q
DQo+ID4gKyAqIERldGVjdCBURFggcHJpdmF0ZSBLZXlJRHMgdG8gc2VlIHdoZXRoZXIgVERYIGhh
cyBiZWVuIGVuYWJsZWQgYnkgdGhlDQo+ID4gKyAqIEJJT1MuICBCb3RoIGluaXRpYWxpemluZyB0
aGUgVERYIG1vZHVsZSBhbmQgcnVubmluZyBURFggZ3Vlc3QgcmVxdWlyZQ0KPiA+ICsgKiBURFgg
cHJpdmF0ZSBLZXlJRC4NCj4gPiArICoNCj4gPiArICogVERYIGRvZXNuJ3QgdHJ1c3QgQklPUy4g
IFREWCB2ZXJpZmllcyBhbGwgY29uZmlndXJhdGlvbnMgZnJvbSBCSU9TDQo+ID4gKyAqIGFyZSBj
b3JyZWN0IGJlZm9yZSBlbmFibGluZyBURFggb24gYW55IGNvcmUuICBURFggcmVxdWlyZXMgdGhl
IEJJT1MNCj4gPiArICogdG8gY29ycmVjdGx5IGFuZCBjb25zaXN0ZW50bHkgcHJvZ3JhbSBURFgg
cHJpdmF0ZSBLZXlJRHMgb24gYWxsIENQVQ0KPiA+ICsgKiBwYWNrYWdlcy4gIFVubGVzcyB0aGVy
ZSBpcyBhIEJJT1MgYnVnLCBkZXRlY3RpbmcgYSB2YWxpZCBURFggcHJpdmF0ZQ0KPiA+ICsgKiBL
ZXlJRCByYW5nZSBvbiBCU1AgaW5kaWNhdGVzIFREWCBoYXMgYmVlbiBlbmFibGVkIGJ5IHRoZSBC
SU9TLiAgSWYNCj4gPiArICogdGhlcmUncyBzdWNoIEJJT1MgYnVnLCBpdCB3aWxsIGJlIGNhdWdo
dCBsYXRlciB3aGVuIGluaXRpYWxpemluZyB0aGUNCj4gPiArICogVERYIG1vZHVsZS4NCj4gPiAr
ICovDQo+ID4gK3N0YXRpYyBpbnQgX19pbml0IGRldGVjdF90ZHgodm9pZCkNCj4gPiArew0KPiA+
ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogSUEzMl9NS1RNRV9LRVlJRF9Q
QVJUSU9OSU5HOg0KPiA+ICsJICogICBCaXQgWzMxOjBdOglOdW1iZXIgb2YgTUtUTUUgS2V5SURz
Lg0KPiA+ICsJICogICBCaXQgWzYzOjMyXToJTnVtYmVyIG9mIFREWCBwcml2YXRlIEtleUlEcy4N
Cj4gPiArCSAqLw0KPiA+ICsJcmV0ID0gcmRtc3Jfc2FmZShNU1JfSUEzMl9NS1RNRV9LRVlJRF9Q
QVJUSVRJT05JTkcsICZ0ZHhfa2V5aWRfc3RhcnQsDQo+ID4gKwkJCSZ0ZHhfa2V5aWRfbnVtKTsN
Cj4gPiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIC1FTk9ERVY7DQo+ID4gKw0KPiA+ICsJaWYg
KCF0ZHhfa2V5aWRfbnVtKQ0KPiA+ICsJCXJldHVybiAtRU5PREVWOw0KPiA+ICsNCj4gPiArCS8q
DQo+ID4gKwkgKiBLZXlJRCAwIGlzIGZvciBUTUUuICBNS1RNRSBLZXlJRHMgc3RhcnQgZnJvbSAx
LiAgVERYIHByaXZhdGUNCj4gPiArCSAqIEtleUlEcyBzdGFydCBhZnRlciB0aGUgbGFzdCBNS1RN
RSBLZXlJRC4NCj4gPiArCSAqLw0KPiA+ICsJdGR4X2tleWlkX3N0YXJ0Kys7DQo+IA0KPiBJdCBp
cyBub3QgdmVyeSBjbGVhciB3aHkgeW91IGluY3JlbWVudCB0ZHhfa2V5aWRfc3RhcnQuwqANCj4g
DQoNClBsZWFzZSBzZWUgYWJvdmUgY29tbWVudCBhcm91bmQgcmRtc3Jfc2FmZSgpOg0KDQoJLyoN
CgkgKiBJQTMyX01LVE1FX0tFWUlEX1BBUlRJT05JTkc6DQoJICogICBCaXQgWzMxOjBdOglOdW1i
ZXIgb2YgTUtUTUUgS2V5SURzLg0KCSAqICAgQml0IFs2MzozMl06CU51bWJlciBvZiBURFggcHJp
dmF0ZSBLZXlJRHMuDQoJICovDQoNCkFuZCB0aGUgY29tbWVudCByaWdodCBhYm92ZSAndGR4X2tl
eWlkX3N0YXJ0KysnOg0KDQoJLyoNCgkgKiBLZXlJRCAwIGlzIGZvciBUTUUuICBNS1RNRSBLZXlJ
RHMgc3RhcnQgZnJvbSAxLiAgVERYIHByaXZhdGUNCgkgKiBLZXlJRHMgc3RhcnQgYWZ0ZXIgdGhl
IGxhc3QgTUtUTUUgS2V5SUQuDQoJICovDQoNCkRvIHRoZSBhYm92ZSB0d28gY29tbWVudHMgYW5z
d2VyIHRoZSBxdWVzdGlvbj8NCg0KT3IgSSBjYW4gYmUgbW9yZSBleHBsaWNpdCwgc3VjaCBhcyBi
ZWxvdz8NCg0KIg0KTm93IHRkeF9zdGFydF9rZXlpZCBpcyB0aGUgbGFzdCBNS1RNRSBLZXlJRC4g
IFREWCBwcml2YXRlIEtleUlEcyBzdGFydCBhZnRlciB0aGUNCmxhc3QgTUtUTUUgS2V5SUQuICBJ
bmNyZWFzZSB0ZHhfc3RhcnRfa2V5aWQgYnkgMSB0byBzZXQgaXQgdG8gdGhlIGZpcnN0IFREWA0K
cHJpdmF0ZSBLZXlJRC4NCiINCg0KDQo+IFdoYXQgd2UgcmVhZCBmcm9tDQo+IE1TUl9JQTMyX01L
VE1FX0tFWUlEX1BBUlRJVElPTklORyBpcyBub3QgdGhlIGNvcnJlY3Qgc3RhcnQga2V5aWQ/DQoN
Cg0KVERYIHZlcmlmaWVzIFREWCBwcml2YXRlIEtleUlEIHJhbmdlIGlzIGNvbmZpZ3VyZWQgY29u
c2lzdGVudGx5IGFjcm9zcyBhbGwNCnBhY2thZ2VzLiAgQW55IHdyb25nIEtleUlEIHJhbmdlIG1l
YW5zIEJJT1MgYnVnLCBhbmQgc3VjaCBidWcgd2lsbCBjYXVzZSBURFgNCmJlaW5nIG5vdCBlbmFi
bGVkIC0tIGxhdGVyIFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gd2lsbCBjYXRjaCB0aGlzLg0K
DQo+IA0KPiBBbHNvIHdoeSBpcyB0aGlzIGdsb2JhbCB2YXJpYWJsZT8gQXQgbGVhc3QgaW4gdGhp
cyBwYXRjaCwgdGhlcmUgc2VlbXMgdG8NCj4gYmUgbm8gdXNlIGNhc2UuDQoNClBsYXRmb3JtX3Rk
eF9lbmFibGVkKCkgdXNlcyB0ZHhfa2V5aWRfbnVtIHRvIGRldGVybWluZSB3aGV0aGVyIFREWCBp
cyBlbmFibGVkIGJ5DQpCSU9TLg0KDQpBbHNvLCBpbiB0aGUgY2hhbmdsb2cgSSBjYW4gYWRkICJi
b3RoIGluaXRpYWxpemluZyB0aGUgVERYIG1vZHVsZSBhbmQgY3JlYXRpbmcNClREWCBndWVzdCB3
aWxsIG5lZWQgdG8gdXNlIFREWCBwcml2YXRlIEtleUlEIi4NCg0KQnV0IEkgYWxzbyBoYXZlIGEg
Y29tbWVudCBzYXlpbmcgc29tZXRoaW5nIHNpbWlsYXIgYXJvdW5kIC4uLg0KDQo+IA0KPiA+ICsJ
LyoNCj4gPiArCSAqIEluaXRpYWxpemluZyB0aGUgVERYIG1vZHVsZSByZXF1aXJlcyBvbmUgVERY
IHByaXZhdGUgS2V5SUQuDQo+ID4gKwkgKiBJZiB0aGVyZSdzIG9ubHkgb25lIFREWCBLZXlJRCB0
aGVuIGFmdGVyIG1vZHVsZSBpbml0aWFsaXphdGlvbg0KPiA+ICsJICogS1ZNIHdvbid0IGJlIGFi
bGUgdG8gcnVuIGFueSBURFggZ3Vlc3QsIHdoaWNoIG1ha2VzIHRoZSB3aG9sZQ0KPiA+ICsJICog
dGhpbmcgd29ydGhsZXNzLiAgSnVzdCBkaXNhYmxlIFREWCBpbiB0aGlzIGNhc2UuDQo+ID4gKwkg
Ki8NCj4gPiArCWlmICh0ZHhfa2V5aWRfbnVtIDwgMikgew0KPiA+ICsJCXByX2luZm8oIkRpc2Fi
bGUgVERYIGFzIHRoZXJlJ3Mgb25seSBvbmUgVERYIHByaXZhdGUgS2V5SUQgYXZhaWxhYmxlLlxu
Iik7DQo+ID4gKwkJZ290byBub190ZHg7DQo+ID4gKwl9DQo+ID4gKw0KDQouLi4gaGVyZS4NCg==
