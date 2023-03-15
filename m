Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0896BA6FC
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 06:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjCOFVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 01:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjCOFVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 01:21:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715251F5EA;
        Tue, 14 Mar 2023 22:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678857482; x=1710393482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NRo3u+uU3QjHa0v+mTi2FCyIrBugxAR7tXKhFU/Tz3o=;
  b=n73HjRxeo8ReHm7Co4duZqu+mK/liyzzNy2bVhCv7IjQgjQWHiaViMdd
   FyN0yNOLW8NY9GrmsqYrgltxpHhwKOGXdNm71yvJGu2E2hR9fBSZrIbgY
   sIzz+1Q12T0wAwMUB5hYXJJBKF5GHak/JkXhG6tvD1mryqPT8J1DPcR6B
   ngkHDkdYer4boxGGl70rwh0Awul+VxaVzGqOb/sAbXuMMklU60kpmMzRe
   uwaiffSjDfjuqv+HkBOHZgkCwukV5gZ/brLQzYT9EVxBfQm4XM8QThhTC
   fJi6FK6oWDQ8Pz/KE6Ir3UT/ew0IReMiKC4TQXwishSRsgM4DcqhuZUEY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="423889882"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="423889882"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 22:16:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="743557657"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="743557657"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 14 Mar 2023 22:16:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 22:16:39 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 22:16:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 22:16:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 22:16:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6akDQQvAK4kyhfk/5tF1iDWoV+Ly7oHFYxySLAIPNkB29nK5fdzEGjtElFFTDuI8+TaU2qT5F+nNECYmyOSXzl24ASLdWE7VMV9JdbK5BxB+XPHEj2Xj2fhZBcz9FuJy6kbQNP5oR4FYsyXrTX5VWDoE97Fk4t6PNPFnq0aTFlUBxT/m83LzCQKCrir9fa7gCJ4wByVfsiucmNrXiG84FBNZInTaXd3Ihe9R6Ff/kxptfEabN8OdDQgNPB3ZPi/lfTT9vPVcUosLA3HNzNaI9IkPmz0bwilnn2DG+nrkwO+x+yg2i0b2llbUaVBg9dRZZi5YhhRlMAh6riiynAXXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NRo3u+uU3QjHa0v+mTi2FCyIrBugxAR7tXKhFU/Tz3o=;
 b=FQKvdZ70m7q+PkVacJTf7UyrImVOc3z+lsRaZzothp06g8SReSQ3YORePPlMLYk1CmwjDDkiU5OK6a4JpnLbaSNIimtbRhzaf8SVBA1dooHxIKED0/izS9tLqv2j4XCBrxxFTe/6qJKrjF9m6WcyRXR61RenZiZ5KEP9WXg3QnHv+vhQAFPXd4SWD99ZysO8/w5hhhrK4O9Q+hNBbftFv1oBDo+UHJsHGIS0C1HOocjfMVjGzfYtEP8jrWPfIxobPSrgXErWLpV188vvKzk+toVllWL65ZvFfCEQycdMK1AAr86lkczVfDS8WAkf9ZhinGXcKfhh6BcgUKFoZOdjJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4936.namprd11.prod.outlook.com (2603:10b6:510:42::20)
 by CY8PR11MB7362.namprd11.prod.outlook.com (2603:10b6:930:85::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 05:16:36 +0000
Received: from PH0PR11MB4936.namprd11.prod.outlook.com
 ([fe80::113e:4c3d:a09d:70c0]) by PH0PR11MB4936.namprd11.prod.outlook.com
 ([fe80::113e:4c3d:a09d:70c0%5]) with mapi id 15.20.6178.022; Wed, 15 Mar 2023
 05:16:36 +0000
From:   "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
Subject: RE: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to
 user visible list.
Thread-Topic: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to
 user visible list.
Thread-Index: AQHZTZSu5hAXrgYnYUSiL3bx5ND0Lq7tzAoAgAELcACAASZ0gIAAjE6AgArQFjA=
Date:   Wed, 15 Mar 2023 05:16:36 +0000
Message-ID: <PH0PR11MB4936ED42716C7F092EE99A44F9BF9@PH0PR11MB4936.namprd11.prod.outlook.com>
References: <20230303055426.2299006-1-satyanarayana.k.v.p@intel.com>
        <ZAXxTiWU489dDssW@ziepe.ca>
        <BN9PR11MB52764ABF8381FCDB8CE0FFF78CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230307162839.2236640d.alex.williamson@redhat.com>
 <BN9PR11MB52769A0011C13309E759A3858CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52769A0011C13309E759A3858CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB4936:EE_|CY8PR11MB7362:EE_
x-ms-office365-filtering-correlation-id: d1333ce4-eeac-4014-619c-08db2514735e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xJUbDBLw/7V8ZOJN5TLXm9icoiR3ov14ZWCnN1jLJ2cChDaUbeu1G7AR78+MDEwk9hM6dt2w5nJ7NrN6cX93gbAhmVS9/BemI+Ew0zf3NY00anxBcWWYCIB9+wgAul+8e+iL/st897lCfUx4ac6ZbTXdT5s2Lwhkjklfr3q3ZjSp4lavIrYu0NemlJ+Cgf/zYnQpmLH0y+fVbtYVkugY7+vFKnpDvzpL64T/ONQNsRUsxRs2N4sgBftqzoSjp1ESCim7l3/qMBZoTp8UpMaD/iiqq08NxcZ+vfsSUOoKDGTGYyeSlithD39NH2PCKOdM/5G6m9wm/r4n8Ia4/H47O+yZEGi+cAYXHeQuFosbln4Qx8Mgn99OIPisK8vVw9adhJ0YbgYc1tlsZMH2JqheeuXXXW1AwVXZC80bzjtHeb+1iVGhMzU6r6Y5IZfGDGQAzs2VnKP47raDHVypQTxeqkGlH6NyDirM3RUM4AOOFJ7hosB+za5DfLKi0LkTqPEfXcjgVI2HYL7/xFG0AZOlzc3z42WHqtS4XFwr4DDAehHnwKcpzbVbOD7KPeTpaSBR/L218+mmNX7AiqjUlqOukZoEuQwpuzDLyIEbNOrYr1GbrdSS4007P8DiEtdFN4WaI7cQ+LEul61sjP47IPMiUxIMzqP/ouH+FmfwOA/LZPSWcW+c+lHd7KG4mCb3MdqTTJhR9gMxUVtBBPTWHs8Hxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199018)(2906002)(82960400001)(122000001)(83380400001)(5660300002)(55016003)(64756008)(66446008)(66476007)(66556008)(52536014)(66946007)(8676002)(41300700001)(33656002)(4326008)(8936002)(38070700005)(76116006)(38100700002)(54906003)(86362001)(316002)(110136005)(478600001)(7696005)(186003)(6506007)(26005)(71200400001)(9686003)(107886003)(55236004)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2ROOXFSblltcXpONDZHb1pmOVRUN0d4YjJ5b2d1UmhIVHFwdGloajZIUzlU?=
 =?utf-8?B?eGIxUk1rbG1HTi9RSmN4RW9veW5oMmtHeEVueWozY3U4c1ljci9kZUlHa3BF?=
 =?utf-8?B?Nzg4MEQzRnhBS0p4Sjl5dDI2KzM1eHhmUFpwZ2FxdGJiaUFCc0FNbjJBN2ph?=
 =?utf-8?B?QkF1QjFkaWExRmpyNGw0bGo5MkpTTVUyMmc2dGMrZ1d5eHRCWDZmeExDT3VY?=
 =?utf-8?B?YVFYUUdvc0ZBOG83MkZOWENWT2FXR0RIa0hNZ3A1SVorYkFGMUphVkY0ZFlR?=
 =?utf-8?B?TFU4WUg5ZHBTM09NQ0lvdTA5cWp1UnVZb3JHVndqWkxQd0x4eEw5K1Y4WkZk?=
 =?utf-8?B?V245cC9DTUN2U2Q5N1NydVBsM3NERFhrdU5xWVlQRHIxUjQyR0IwYjM2TTZK?=
 =?utf-8?B?T3lEV1FCZE8wK2cwamgwdXk3OTg2OUJtYXRCaHZpN09PVk50V2VzbklvckFS?=
 =?utf-8?B?Yjd1NmVIYTVMZGozZGZRRE9pWHI1V28zQ3YycTY0TzFHZHFVWFZOZURoN2Zy?=
 =?utf-8?B?OWdEWTI0NHV0UkJLMFNPUlZRUGV4Zm1IalRaNnhrNHlFZzJTazAyZS9HWVVG?=
 =?utf-8?B?SDNuZXdLaG5NQzRLNG9QMzhJMy9uZ1lVcW9HN0hnWk9xWFNUQkRYY1U0b3Vs?=
 =?utf-8?B?d3pzZXJoZ2VNV3JGQ3dCRWl6VkZwL3hMaVROM0psVmlxakdBN3VBMVNrY2tH?=
 =?utf-8?B?eWpteThTVUtPU1kxcWpNQWxsSEtPQkZHMWRSbk9kTHpMVzF0dWpXSnl0dmwz?=
 =?utf-8?B?L0dPRGJxVk53YXFyeEJ1RmU1TE15UlJ3T1Y5d0pLQ1FKOGdvL2V2NXBZUjRq?=
 =?utf-8?B?TFBqYlpnWFh1MDhrV0ppWjVvTW5DcE9UaXJxa1FTaGRzV0ZNc0ZnSWJvVVNh?=
 =?utf-8?B?RUQ5WjlkQ3Bxb2tzK1ZCdms1citYR2Z4QmhVaWNFQ1VEekVYRXd5QjB0aDBF?=
 =?utf-8?B?ZU9MM2gzWkM4Uzg5VnJ0eFpydUI1bmhXSkVvYTkrcmw4c1VsRmpBM1VTQW4w?=
 =?utf-8?B?Y1FCZjFEeUw4bmFxY2FjQlp3WklTUjZhTzl4Wm1sTExMeFowNmlXQjhaVmxO?=
 =?utf-8?B?dy94ODJ4bmcwU21UZTlFaEVTdDRibTVuL1BEOHJ1Z3JwQW1JSTNZdDRBblVa?=
 =?utf-8?B?WCtnWllsSS8xNTNZQ2QvQVdqTTdoK2d1NHhIL2dvWi9VTDJHUlNROElkTDBQ?=
 =?utf-8?B?cjhaU1lCUk4zaWtjS3lSRlR2cUdLaTR3MVVDQlBwdVVwOUs2OW1FN2g4KzVs?=
 =?utf-8?B?cWxRTWhxNlBCRzNHOGF0VHBML0twWjgzSGRHRGJhRU1LQzk1Q3o1N0JVczZH?=
 =?utf-8?B?Y2dHODRsOVBGQ1d0MGpMS0p4MzBRakg2Wmhrcm0yd2NuVjJnYTJlalFVbXpP?=
 =?utf-8?B?WXBzOEpWUTNaK1N6R1NXczNPK0FOajVyMjFyK0YybWRFS09TZGh6OHVaQXdh?=
 =?utf-8?B?VWowMkVubDJ5T0xDNCt4dGh5Sjh4R1laWXd1cG5OYU43ZWZranJ4MFJCZG02?=
 =?utf-8?B?VFZTY3ByVGl0ZVZ0ZDJPRG1Mcnhia0NMd2F0QUJUN3Uwak9DOXM4M3p5M1kv?=
 =?utf-8?B?QXVoTklCSnNGSkxWa0RMVWx0cXdBRWNtbDVKanMyMDNYbHp2L3VQOVJnaG9D?=
 =?utf-8?B?RHVwTHBqSTJHdWk3clBzVjNHTmtILzdUQ0RONXhqUTEvZ1JZZThVUVNpWnZS?=
 =?utf-8?B?UGtFNXM4Q1h3OGszRGYvQlZGdE9FVFlQd2pEZVNKSTBiRHhZdkJXTi9BbDF3?=
 =?utf-8?B?cnhDdjYvOUFRZXhBald3SExxeGFHdkNibVlNQ0pGaWV5a3oyRHUyWG1QcVNn?=
 =?utf-8?B?ZlJVNlcvVkdYaWN1c0h5TzNSeCt6ZERLQVhRc0t2ZmpkZ1ZsUUFRVXRxYVBG?=
 =?utf-8?B?VWkyQ0ZLcE1CT1FkWmg1UThyQjhHaFZINnZ0eWFaWTBnbTVkK3ppOVM5WUhq?=
 =?utf-8?B?VTYyYmo5NjIrV0pNS2o4VWN2eWRwanJLcm9HVG1sTk9tUWZ6M3R2OHFKdjVJ?=
 =?utf-8?B?LzJaTVFZMWI3R1pFdGlNZTlEUEhRS2RWY3ZkcHZJK21LWEVNQVJra3BLYWxv?=
 =?utf-8?B?VTBrWWgxWUxCSXdrdU51Q1JuZndYakZzU05SdnUraXFhM2hpempKcldlV2F3?=
 =?utf-8?B?ZW51MHpxOTZVTmdmL2VtTGdldnVlRS84MlI1b2lPT3BFTnRLTGVwQlpCdEhB?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1333ce4-eeac-4014-619c-08db2514735e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 05:16:36.7883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XO1nDFuuj1ROUtGvKqiX5D0wl/YsslHYUbjQ1GEbhM7w3U5VTFiLmnj/QMPjVdyUWKmChMORR/QzbaFGJAgP5YBnbw8PYBWwsKrgGBORxFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7362
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgTWFyY2ggOCwgMjAyMyAxOjIxIFBNDQo+IFRvOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgu
d2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBDYzogSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUu
Y2E+OyBLIFYgUCwgU2F0eWFuYXJheWFuYQ0KPiA8c2F0eWFuYXJheWFuYS5rLnYucEBpbnRlbC5j
b20+OyBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9y
ZzsgY29odWNrQHJlZGhhdC5jb20NCj4gU3ViamVjdDogUkU6IFtQQVRDSF0gdmZpby9wY2k6IEFk
ZCBEVlNFQyBQQ0kgRXh0ZW5kZWQgQ29uZmlnIENhcGFiaWxpdHkgdG8NCj4gdXNlciB2aXNpYmxl
IGxpc3QuDQo+IA0KPiA+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJl
ZGhhdC5jb20+DQo+ID4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCA4LCAyMDIzIDc6MjkgQU0NCj4g
Pg0KPiA+IE9uIFR1ZSwgNyBNYXIgMjAyMyAwNTo1NDo0NiArMDAwMA0KPiA+ICJUaWFuLCBLZXZp
biIgPGtldmluLnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4gPiBGcm9tOiBKYXNv
biBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4NCj4gPiA+ID4gU2VudDogTW9uZGF5LCBNYXJjaCA2
LCAyMDIzIDk6NTggUE0NCj4gPiA+ID4NCj4gPiA+ID4gT24gRnJpLCBNYXIgMDMsIDIwMjMgYXQg
MDU6NTQ6MjZBTSArMDAwMCwgSyBWIFAsIFNhdHlhbmFyYXlhbmEgd3JvdGU6DQo+ID4gPiA+ID4g
SW50ZWwgUGxhdGZvcm0gTW9uaXRvcmluZyBUZWNobm9sb2d5IChQTVQpIHN1cHBvcnQgaXMgaW5k
aWNhdGVkIGJ5DQo+ID4gPiA+IHByZXNlbmNlDQo+ID4gPiA+ID4gb2YgYW4gSW50ZWwgZGVmaW5l
ZCBQQ0llIERlc2lnbmF0ZWQgVmVuZG9yIFNwZWNpZmljIEV4dGVuZGVkDQo+ID4gQ2FwYWJpbGl0
aWVzDQo+ID4gPiA+ID4gKERWU0VDKSBzdHJ1Y3R1cmUgd2l0aCBhIFBNVCBzcGVjaWZpYyBJRC5I
b3dldmVyIERWU0VDIHN0cnVjdHVyZXMNCj4gPiBtYXkNCj4gPiA+ID4gYWxzbw0KPiA+ID4gPiA+
IGJlIHVzZWQgYnkgSW50ZWwgdG8gaW5kaWNhdGUgc3VwcG9ydCBmb3Igb3RoZXIgZmVhdHVyZXMu
IFRoZSBPdXQgT2YNCj4gQmFuZA0KPiA+ID4gPiBNYW5hZ2VtZW50DQo+ID4gPiA+ID4gU2Vydmlj
ZXMgTW9kdWxlIChPT0JNU00pIHVzZXMgRFZTRUMgdG8gZW51bWVyYXRlIHNldmVyYWwNCj4gZmVh
dHVyZXMsDQo+ID4gPiA+IGluY2x1ZGluZyBQTVQuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGUg
Y3VycmVudCBWRklPIGRyaXZlciBkb2VzIG5vdCBwYXNzIERWU0VDIGNhcGFiaWxpdGllcyB0byB2
aXJ0dWFsDQo+ID4gbWFjaGluZQ0KPiA+ID4gPiAoVk0pDQo+ID4gPiA+ID4gd2hpY2ggbWFrZXMg
aW50ZWxfdnNlYyBkcml2ZXIgbm90IHRvIHdvcmsgaW4gdGhlIFZNLiBUaGlzIHNlcmllcyBhZGRz
DQo+ID4gPiA+IERWU0VDDQo+ID4gPiA+ID4gY2FwYWJpbGl0eSB0byB1c2VyIHZpc2libGUgbGlz
dCB0byBhbGxvdyBpdHMgdXNlIHdpdGggVkZJTy4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFNpZ25l
ZC1vZmYtYnk6IEsgViBQIFNhdHlhbmFyYXlhbmEgPHNhdHlhbmFyYXlhbmEuay52LnBAaW50ZWwu
Y29tPg0KPiA+ID4gPiA+IC0tLQ0KPiA+ID4gPiA+ICBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNp
X2NvbmZpZy5jIHwgOCArKysrKysrKw0KPiA+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNl
cnRpb25zKCspDQo+ID4gPiA+DQo+ID4gPiA+IFdhc24ndCB0aGUgSURYRC9TSU9WIHRlYW0gcHJv
cG9zaW5nIHRvIHVzZSB0aGUgZmFjdCB0aGF0IERWU0VDDQo+IGRvZXNuJ3QNCj4gPiA+ID4gcHJv
cG9nYXRlIHRvIGluZGljYXRlIHRoYXQgSU1TIGRvZXNuJ3Qgd29yaz8NCj4gPiA+ID4NCj4gPiA+
ID4gRGlkIHRoaXMgcGxhbiBnZXQgYWJhbmRvbmVkPyBJdCBzZWVtcyBhdCBvZGRzIHdpdGggdGhp
cyBwYXRjaC4NCj4gPiA+DQo+ID4gPiBOby4gR3Vlc3QgSU1TIHdpbGwgYmUgaW5kaWNhdGVkIHZp
YSBoeXBlcmNhbGwvdklSIGFzIHBsYW5uZWQuDQo+ID4NCj4gPiBUaGFuayBnb29kbmVzcywgYmFz
aW5nIGEgZmVhdHVyZSBvbiB0aGUgYWJzZW5jZSBvZiBhIGNhcGFiaWxpdHkgdGhhdCdzDQo+ID4g
c3ViamVjdCB0byBjaGFuZ2Ugd291bGQgaGF2ZSByZWFsbHkgcHV0IHVzLCBvciBJTVMsIGluIGEg
Y29ybmVyLg0KPiA+DQo+ID4gPiA+IFdoeSB3b3VsZCB5b3UgdXNlIGEgIlBsYXRmb3JtIE1vbml0
b3JpbmcgVGVjaG5vbG9neSIgZGV2aWNlIHdpdGgNCj4gVkZJTw0KPiA+ID4gPiBhbnlob3c/DQo+
ID4gPg0KPiA+ID4gQWNrLiBJIGd1ZXNzIGl0J3MgYSBtb25pdG9yaW5nIGNhcGFiaWxpdHkgcGVy
IFBDSSBkZXZpY2UgdG8gZm9ybSBhDQo+ID4gPiBwbGF0Zm9ybS1sZXZlbCBtb25pdG9yaW5nIHRl
Y2hub2xvZ3kuIEJ1dCB3L28gYWxsIHRob3NlIGJhY2tncm91bmQNCj4gPiA+IGFuZCB1c2FnZSBk
ZXNjcmlwdGlvbiBpdCdzIHJlYWxseSBzdHJhbmdlIHRvIHBhc3MgYSAncGxhdGZvcm0nIGNhcGFi
aWxpdHkNCj4gPiA+IGludG8gYSBndWVzdC4NCj4gPg0KPiA+IElzIHRoaXMgcGVyaGFwcyBmb3Ig
dmFsaWRhdGlvbiBvZiB0aGUgZGV2aWNlLCBiZWNhdXNlIHllcywgYXNzaWduaW5nDQo+ID4gcGxh
dGZvcm0gZGV2aWNlcyB0byBhIFZNIGRvZXNuJ3Qgc2VlbSBsaWtlIHNvbWV0aGluZyBhIHN5c3Rl
bSB2ZW5kb3INCj4gPiB3b3VsZCB0ZW5kIHRvIHByb21vdGUuDQo+IA0KPiBmcm9tIHRoZSBkZXNj
cmlwdGlvbiBpbiB2MiBzb3VuZHMgbGlrZSBpdCdzIGEgdGVsZW1ldHJ5L2NyYXNobG9nL2V0Yy4N
Cj4gY2FwYWJpbGl0eSBvbiBhIFBDSSBkZXZpY2UsIHRob3VnaCBpdCdzIGNvbmZ1c2luZ2x5IGNh
bGxlZCAncGxhdGZvcm0nLg0KPiANCkZvciBJbnRlbCdzIG5ldyBNYXggc2VyaWVzIGRldmljZXMs
IHRlbGVtZXRyeS9jcmFzaGxvZy93YXRjaGVycyBhcmUgcmV0cmlldmVkIHVzaW5nIGEgUENJIGRl
dmljZQ0Kd2l0aCBEVlNFQyBjYXBhYmlsaXR5LiBJbiBjYXNlIG9mIFBhc3MtdGhyb3VnaCB2aXJ0
dWFsaXphdGlvbiwgY29tcGxldGUgR1BVIGlzIFBhc3NlZCB0byBWTSBhbmQgDQp1c2VyIGNhbiBn
ZXQgdGVsZW1ldHJ5IGRhdGEgaW5zaWRlIFZNIG9ubHkgaWYgUENJIGNhcmQgd2l0aCBEVlNFQyBj
YXBhYmlsaXR5IGlzIGF2YWlsYWJsZS4NCk90aGVyd2lzZSwgbm8gdGVsZW1ldHJ5IGRhdGEgY2Fu
IGJlIHJldHJpZXZlZCBpbnNpZGUgVk0uDQoNClRoZSBuYW1lICdwbGF0Zm9ybScgbWlnaHQgaGF2
ZSBjb21lIGZyb20gSW50ZWdyYXRlZCBncmFwaGljcyBhbmQgdGhlIHNhbWUgaXMgYmVpbmcgdXNl
ZCBmb3IgDQpkaXNjcmV0ZSBncmFwaGljcyBhcyB3ZWxsLg0KPiA+DQo+ID4gPiA+IEhvbmVzdGx5
IEknbSBhIGJpdCByZWx1Y3RhbnQgdG8gYWxsb3cgYXJiaXRhcnkgY29uZmlnIHNwYWNlLCBzb21l
IG9mDQo+ID4gPiA+IHRoZSBzdHVmZiBwZW9wbGUgcHV0IHRoZXJlIGNhbiBiZSBkYW5nZXJvdXMu
DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gUHJvYmFibHkgYW4gYWxsb3dlZCBsaXN0IHRvIG1hbmFn
ZSB3aGljaCBEVlNFQyBJRCBjYW4gYmUgZXhwb3NlZA0KPiA+ID4gdG8gdXNlcnNwYWNlIHZpYSB2
ZmlvLXBjaSwgZS5nLiBpZiB0aGUgUE1UIElEIGluIHRoaXMgcGF0Y2ggaXMgcHJvdmVkDQo+ID4g
PiB0byBiZSBzYWZlIGZvciBhIG1lYW5pbmdmdWwgdXNhZ2U/DQo+ID4NCj4gPiBXZWxsLCBsZXQg
bWUgdGFrZSB0aGlzIGEgZGlmZmVyZW50IGRpcmVjdGlvbiBiZWNhdXNlIHRoZSBzdXBwb3J0DQo+
ID4gcHJvcG9zZWQgaGVyZSBvbmx5IGFsbG93cyByZWFkLW9ubHkgYWNjZXNzIHRvIHRoZSBEVlNF
QyBjYXBhYmlsaXR5LiAgSXMNCj4gPiB0aGF0IGFjdHVhbGx5IHVzZWZ1bD8gIERyaXZlcnMgbWFr
aW5nIHVzZSBvZiB3cml0ZSBhY2Nlc3MgdG8gRFZTRUMgYXJlDQo+ID4gZ29pbmcgdG8gZmFpbCBp
biB1bnByZWRpY3RhYmxlIHdheXMgaWYgdGhlaXIgd3JpdGVzIGFyZSBkcm9wcGVkLiAgVGhhdA0K
PiA+IHNlZW1zIHdvcnNlIHRoYW4gb3VyIGN1cnJlbnQgc3RhdGUgb2YgaGlkaW5nIGl0Lg0KPiAN
Cj4gWWVwLCB0aGlzIGlzIHdlaXJkLiBFdmVuIHdoZW4gYSB0ZWxlbWV0cnkvY3Jhc2hsb2cgZmVh
dHVyZSBpcyBtb3JlIGZvcg0KPiByZWFkaW5nIGRhdGEgZnJvbSB0aGUgZGV2aWNlLCB0aGVyZSBz
aG91bGQgYmUgY2VydGFpbiBjb250cm9sIGtub2JzIHRvDQo+IGVuYWJsZS9kaXNhYmxlIGl0IHRo
ZW4gd3JpdGUgYWNjZXNzIGlzIGFsc28gcmVxdWlyZWQuDQpBY2tub3dsZWRnZWQuIFdpbGwgYmUg
YWRkaW5nIHJ3IHN1cHBvcnQgaW4gVjIgcGF0Y2guDQo+IA0KPiA+DQo+ID4gV2UgYWxyZWFkeSBw
cm92aWRlIHJhdyB3cml0ZSBhY2Nlc3MgdG8gYm90aCB0aGUgc3RhbmRhcmQgYW5kIGV4dGVuZGVk
DQo+ID4gdmVuZG9yIHNwZWNpZmljIGNhcGFiaWxpdGllcywgd2h5IHdvdWxkbid0IHdlIGJ5IGRl
ZmF1bHQgZG8gdGhlIHNhbWUNCj4gPiBmb3IgRFZTRUM/ICBEZXZpY2VzIGFyZW4ndCBsaW1pdGVk
IHRvIGNvbmZpZyBzcGFjZSBpZiB0aGV5IHdhbnQgdG8gZG8NCj4gDQo+IG9oLCBJIHdhcyB1bmF3
YXJlIG9mIGl0Lg0KPiANCkFja25vd2xlZGdlZC4gV2lsbCBiZSBhZGRpbmcgcncgc3VwcG9ydCBp
biBWMiBwYXRjaC4NCj4gPiBzb21ldGhpbmcgZGFuZ2Vyb3VzLCBhdCBzb21lIHBvaW50IHdlIG5l
ZWQgdG8gcmVseSBvbiBwbGF0Zm9ybQ0KPiA+IGlzb2xhdGlvbi4NCj4gDQo+IFByb2JhYmx5IGl0
J3MgZWFzaWVyIGZvciBIVyB2ZW5kb3JzIHRvIG1ha2Ugc2VjdXJpdHkgbWlzdGFrZSBpbiBjb25m
aWcNCj4gc3BhY2Ugb3RoZXIgdGhhbiBpbiBNTUlPIGJhci4g8J+YiiBidXQgSSBhZ3JlZSBpZiBu
b2JvZHkgY29tcGxhaW5zDQo+IG9uIGhvdyBWU0VDIGlzIGhhbmRsZSB0b2RheSB0aGVyZSBpcyBu
byByZWFzb24gd2h5IHdlIHNob3VsZCBub3QgZG8NCj4gdGhlIHNhbWUgdGhpbmcgZm9yIERWU0VD
Lg0KPg0KVGhhbmtzIGZvciBmZWVkYmFjay4gV2lsbCBzdWJtaXQgVjIgcGF0Y2ggd2hlcmUgRFZT
RUMgZm9sbG93cyBzYW1lIGFzIFZTRUMuIA0KPiA+DQo+ID4gSWYgdGhlcmUgYXJlIHVuZGVybHlp
bmcgY29uY2VybnMgaGVyZSwgdGhlbiB3ZSBwcm9iYWJseSBuZWVkIHNvbWUgc29ydA0KPiA+IG9m
IG9wdC1pbiBwb2xpY3kgd2hpY2ggcmVzdHJpY3RzIHZmaW8tcGNpIGZyb20gYmluZGluZyB0byBh
bnl0aGluZyBidXQNCj4gPiBWRnMuICBUaGFua3MsDQo+ID4NCj4gPiBBbGV4DQoNClNhdHlhDQoN
Cg==
