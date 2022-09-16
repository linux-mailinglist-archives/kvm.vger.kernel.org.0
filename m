Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84545BA49F
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 04:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiIPCbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 22:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiIPCa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 22:30:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2147395AD5;
        Thu, 15 Sep 2022 19:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663295454; x=1694831454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BHgyJ0/ZATwAdkjlFUxeWZ1Ao+gTkLWPLhvFtdUeCdo=;
  b=izQOkhoFkRkkaVHg2rf94O0xCO8TDsg15VJmk7FWqsQy9i9ePVpYzRnW
   7OvslqMvHDt3OGgiERkyvGgLvEA9YQ48jc5trKxnGJy2Q6RfB3AHdHVtL
   AdtOCsl+QxabJ1kFB/T5ayy0SzYZQdZjCuO88bjAIRuL1Q/hFsvl47KxR
   EyNzLtWaRFh4f0wYshoHV80X4Ol0QX0t9OXTIoVNhN9vT9iC0ohlp7wc7
   DltRSt3pxkBZRl6OrL589lEqMPf3TLr7SE5T2ez9UI+r1BLcDtK0rbO5R
   NU7x4Hfjm2RIQm4K7JZPnWBfJoOJYWhgB7ISYqFBK9Hjlx9gONRTzbbIj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="278621685"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="278621685"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 19:30:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="946213751"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 15 Sep 2022 19:30:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 19:30:52 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 19:30:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 19:30:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 19:30:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEZjBHPRTIiHR9JBsvFjQnB0BJEhJsfoABqwd7voZfXEjNPKxa2bb5wICoyQ/WibowvID4bZj1CMxHQj5DZweF1EAdP0Kil0wjZX6m1mCRmDKE31N/HmB92uIc5NCarpfmLhsFWJ1HXjiJXqiDFdgmLojmCisRAGGEvl2PloqyBNrqpHD2vbeHXw2tXed3zbJFMDr+cXcYuXbqfCmueYv4CbEzAZCWKGwbvUxSLTk01gZ9PhyLTtdq8dY7PNmEupw0P+GzezMNdCqVRNESJ/on4Xj2BVJWcM6kqJzAq9P1PTOfs/bufru6hjkysZTG+xRcRt/GeGy7ISfY7Sqtfu6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHgyJ0/ZATwAdkjlFUxeWZ1Ao+gTkLWPLhvFtdUeCdo=;
 b=FOUE1MVFGhxiphCfX4w2IaPXdaflq/pTWGvZA54BugY15KLiAqeh4XG2YMEdC7xCn75RHPiFBR0jJecA/uCwtQeJa1CDUstBfzZUI+rRdOjjUgAy8oW2gDwz9ih45/ym91tX8XS2XclA7Bm1tpDAWejw0RY6jdSYEC6xa4yNEHvwvpTlV/6So2GiKBUlo9aymtEp6hcml3vX3wR3QAh18TPTS2YHdR87Cm6j6FVVQoNpWsC+MQh5JiormN2FtgzseAuiGhxDp8erT4Tkc/IU1gCZHqjPodahcWQngIcLFvB3RF5kgUGwRm9hTpl/B/ne5doZPdI3PkrgPyxPzPEqRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5)
 by SA2PR11MB5050.namprd11.prod.outlook.com (2603:10b6:806:fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Fri, 16 Sep
 2022 02:30:47 +0000
Received: from CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::990c:fb7c:d6ab:3b18]) by CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::990c:fb7c:d6ab:3b18%4]) with mapi id 15.20.5612.022; Fri, 16 Sep 2022
 02:30:47 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Topic: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Index: AQHYuGCfKwYxaXR4306din/WULaC4K3Fff5wgBjymACAABFugIAA/X4AgABj1pCAAMFbAIAABJpggAAZlICAAKvIEA==
Date:   Fri, 16 Sep 2022 02:30:47 +0000
Message-ID: <CY5PR11MB6365EE3B1C4BCED02A1E40D8DC489@CY5PR11MB6365.namprd11.prod.outlook.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
 <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
 <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <ef391316-cde5-3cda-ff0d-980e8ecc9aef@linux.intel.com>
 <CY5PR11MB636535BE57F8CC07B1B2770DDC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <4c6a5663-778e-a509-638c-92cfd5315274@linux.intel.com>
In-Reply-To: <4c6a5663-778e-a509-638c-92cfd5315274@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR11MB6365:EE_|SA2PR11MB5050:EE_
x-ms-office365-filtering-correlation-id: 6c684611-00e6-4031-6b10-08da978b768e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OmN85imWhIL3NDhr9TigXe4HPj3IoseK8HR9lNb/SXw8jrgTYU+fItAzjJsR7aLc8JHOE7tWT5OXxtZheN4rUpF47nXR/huKGghVYanTQ5kgGEB/m/Ka4zPa0JpvLHO8ilSUnCMjJjyaVA4cGIAiuiVpKtPFeStTGW5B2tDMqrjwQDomMx3kVFBoh9mDlShoiROr0Jz+CSVeTEcdej/YVSDpkxqKSID23/ZvKt8AN1jQZmDYoRyYcom79Dv3o4IgPFlmjvPJtYgTR1exiSfQPI6Jg8Kz2J8chWxsIonEeem8Cv7e7M78JD7PHBvLpfja0JixGBaF9VfuhgiFd5KJqOBOgmnx+uuHxPEExe9TJf7vrAVyTgXLeP3Uk/dmygUCbpzajv6kuRXoPxN3/H5CIQbvLmftr0P6Jjj3zxguh2G8U3vSS1hZfQWE2Z/afnuMu0XkQlV876KiXlDR8Ax2xQUg3F709qOLP091qhK9MmbUIghFr/Ri9BZq83a/745HQeNkNQPA0jFwJ8liikVQzoQij8G/4JuPHZv9/IdCClR+z9Lu7MAVcsUfmK/Q8aIH4fVeEjH6WCM+yOQavmHtAqHnoIVPPKH6SiW0w0fyCgJ8VfuzbNcmNyJHN09p46FS5urLZDqtJ06b4Yr3KaP4z5znLAvk/hUvVFLGHkgJDppKihp+OAuxeRjeZv6Zwvh82VDkKpN2gzDNVInwtUaM5c92/UdupnXgfFtP1j9T8wgyCAbRnHCM1PRXfCZhAH6A7tOxyOldbhkhpusRd39+vWnkSU8uwTGmvbnCJXjZQ98=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6365.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(346002)(366004)(396003)(451199015)(55016003)(478600001)(33656002)(66899012)(52536014)(38100700002)(86362001)(8676002)(4326008)(76116006)(64756008)(66446008)(66476007)(66556008)(316002)(5660300002)(8936002)(7416002)(38070700005)(66946007)(921005)(110136005)(6636002)(54906003)(122000001)(82960400001)(71200400001)(9686003)(186003)(2906002)(41300700001)(26005)(6506007)(7696005)(53546011)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cE9YazBkTlpYZ01jbkRNNnJIdi9FZ29yaWVKUUVkaHNFWktVREtjSzB0dzl4?=
 =?utf-8?B?b3JJQTlzM2dSZnQ4bjkrRWZJOGo3OHlTZ0s5N25jOHBsY0orMURrby8wbndh?=
 =?utf-8?B?YUZhQ2RtN2NWeERNOW1EUWlqa1pBRnpxclR0WVEwV0ZTRDR2Ulo0ckRKUzFn?=
 =?utf-8?B?TWdpSzRTeUpsbnhtVy9pM0ZydFpRRnNPQnhWTUZoam1mZTBzVTdrYTBaWjZz?=
 =?utf-8?B?eWdUSWFWcmdydjd2SWs1RktSN0U0WkpHS09ONk5nRXFwaTdTQ3FVY2h3cWli?=
 =?utf-8?B?N3pOL3RVWFJSSXUyOXd2V08zUVhQS2MxNkJLL2Vwbk1ZUUVDdytqaXN6eVhD?=
 =?utf-8?B?dFFqT3JBdW1QMnJjWlBWSFdIRjRvSlFUdENkYS8rdGkxRldRRDMvdjZUL1JX?=
 =?utf-8?B?M1NHUnYrRHVGSk5zWWN3ZVZvNzExMUp3eFV4dVQ1WFpJZWwzQTZZNFhyNzAy?=
 =?utf-8?B?OGZ4RGZDVXN0Q3UyZHFpNkJmY1E2aFJhbWViblN6THQrWkd1aVhGTXgzb29U?=
 =?utf-8?B?RE1HeDdRcmRhOFo4dXpLZVN6NFlhbmVJT0VyNXAxaUwyL2FrUEtmL0oyYWpo?=
 =?utf-8?B?VTF0RmNLWTdCaWlnYjR5Y0RHTUdoWGdaM1Zla3pEZWxNNkRsL0hMOU9HU3Nv?=
 =?utf-8?B?UW1DaEU1Nzl3dzA4U0NpMEtJYTdaL1R2VUJXYTdyUVlrQ2lMRWpWcXloTUhh?=
 =?utf-8?B?cDN6c0R1SlhhVTA2aXNYazgwbTBla0lMSVhnNW1QNXY3cFMvM0xKZTNlMEdV?=
 =?utf-8?B?U0t6T2JYaDdINzZCdG1mWlZBL0dDaWU2dWtoK1BxY0FHT1dlZGRvT29xVHly?=
 =?utf-8?B?TnRMYWVsZkFadXhqRldBNXNkUXFiM29WSmlPd3dwV3cweWtZRzVnR2dKWUxO?=
 =?utf-8?B?V1pvUmd0czZrcWF2UU92d0dqc3p0WEF3RitjcTBKVW9Vb1RwZU5mV0VKc3lh?=
 =?utf-8?B?OGFZbFcrZWw1NFY2VWdyR0JPNGZkZURoY1RZZ2NCQkhoUSswZER2UGZWcnli?=
 =?utf-8?B?VG4ycC9SSHc3NHVuSGo2bGJMTnFyd3VBbFdkR1M2WGNvTnJvZ3hJYi9TbFpD?=
 =?utf-8?B?WHgrVWdzVndJL3o4V0RiS1pCQXNyb3prcStpZlZOTjVBVHBWbFJLT1dnRmpp?=
 =?utf-8?B?b0YzWWtnelYxSXVUekI2SFdlcmN1dkhOMklnbWpRZ1FjUjhGS3VjaElBSjcz?=
 =?utf-8?B?OFRBQkVjRXQxT1BqSjU3SDZGdFpibUN3YitKREF5MDBHN1lTS2djOHpNaXV4?=
 =?utf-8?B?V20rWTdWcFhmbjd0eHBmVHJsVXNMVEVKbWVJV3p5aUhMQi9UeGh5RlRkTXM5?=
 =?utf-8?B?cXFxU1RFTnpxTExrMnVoTUQ0MEV4UTBLaEJ3VUZtUHB5WXZwb0tJdzFhc3BO?=
 =?utf-8?B?SnZCVzFqM3gxZ2JEd0J4djZYaUpRckhFRkpSRVpWVVRFVExUNEZ4UEJPUmts?=
 =?utf-8?B?cEl4N1FhMkhIYk1HQThkNGJFczA5RVVMZkEzODhpQ0ZhMjNmTll3MlNGd3I4?=
 =?utf-8?B?YkZBcHVSek9hcEl1eXFZK01KMmxsbE1OL1B5WVRlVDlsMVlCSzhkOVpYakha?=
 =?utf-8?B?M2o0YU9UUnBkd05qcEpJZEI2ajh6VEFPdVB4dmdYYWxHRW5POWNxdVhQKzVN?=
 =?utf-8?B?Q2tCQnlJY2VRRFhoRzhkeVdXNnMxUTNYREVPZS9QYXNQQTJhbGJwWURlSXBK?=
 =?utf-8?B?UGdGNHh0SWcyYmgyUlVFZGszbE5lUW1QdHhGRmxwVkw3VTBsd3lTV1FFSzYy?=
 =?utf-8?B?ZEpTd0ZMSW5TU1kxdUJJUFRWY1poRkxsZ0pHQUM5VERyTmF2eDlNZlByeElr?=
 =?utf-8?B?dDF0ZHBYWVM2VXR1VGtUZlJOZDJSbzU5RDJ6Znh2dS9kN1FPMlFPdGpLVDQ1?=
 =?utf-8?B?ZTNVUi9aV1EvelJ5T0UwcnFlWkRrQVZxRURHRElrYnZBY095Tjh3MVVIOTc1?=
 =?utf-8?B?SFUzZUFaSDZIaUFhbEc3dUZ0eFIzNUdLZ3hLbFFXdjJ2UHhxaG9IendDUWo0?=
 =?utf-8?B?TmVmNTJzL0FwZGdSTklPbjhvcjJRcmpRaVgydjFLNE5aQ1ZRUFJYK2M1RFpS?=
 =?utf-8?B?VWhCVVg1T3pYNWo0alhSQm11azE0bnlKWXdJeGhsMDJISkJvMzNRdDJBTFM4?=
 =?utf-8?Q?7StFsUnSZQjup9pBHXmwRAxT7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6365.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c684611-00e6-4031-6b10-08da978b768e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 02:30:47.1171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4oZqg6jFKLmgnplcBkwzrq5ieQc0rz2IZTPfUfFpZHp8/mR8V9hnIA7rL3BnCmB+xfFkBFu4WmFIn+mq0NNljw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5050
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1cnNkYXksIFNlcHRlbWJlciAxNSwgMjAyMiAxMTo0MyBQTSwgTGlhbmcsIEthbiB3cm90
ZToNCj4gT24gMjAyMi0wOS0xNSAxMDozOSBhLm0uLCBXYW5nLCBXZWkgVyB3cm90ZToNCj4gPiBP
biBUaHVyc2RheSwgU2VwdGVtYmVyIDE1LCAyMDIyIDk6NTUgUE0gTGlhbmcsIEthbiB3cm90ZToN
Cj4gPj4gT24gMjAyMi0wOS0xNCAxMDo0NiBwLm0uLCBXYW5nLCBXZWkgVyB3cm90ZToNCj4gPj4+
IE9uIFRodXJzZGF5LCBTZXB0ZW1iZXIgMTUsIDIwMjIgNDoyNiBBTSwgTGlhbmcsIEthbiB3cm90
ZToNCj4gPj4+PiBUaGUgcGVyZl9ldmVudF9kaXNhYmxlKCkgZXZlbnR1YWxseSBpbnZva2VzIHRo
ZSBpbnRlbF9wdF9zdG9wKCkuDQo+ID4+Pj4gV2UgYWxyZWFkeSBleHBvc2UgdGhlIGludGVsX3B0
X3N0b3AoKS9jcHVfZW1lcmdlbmN5X3N0b3BfcHQoKSB0bw0KPiA+Pj4+IG90aGVyIG1vZHVsZXMu
IEkgZG9uJ3QgdGhpbmsgd2UgaGF2ZSB0byB1c2UgdGhlIHBlcmZfZXZlbnRfZGlzYWJsZSgpLg0K
PiA+Pj4+IEFsc28sIHRoZQ0KPiA+Pj4+IHBlcmZfZXZlbnRfZGlzYWJsZSgpIHJlcXVpcmVzIGV4
dHJhIGNvZGVzLg0KPiA+Pj4+DQo+ID4+Pj4gSSB3ZW50IHRocm91Z2ggdGhlIGRpc2N1c3Npb25z
LiBJIGFncmVlIHdpdGggU2VhbidzIHN1Z2dlc3Rpb24uDQo+ID4+Pj4gV2Ugc2hvdWxkIG9ubHkg
cHV0IHRoZSBsb2dpYyBpbiB0aGUgS1ZNIGJ1dCBhbGwgdGhlIE1TUiBhY2Nlc3MNCj4gPj4+PiBk
ZXRhaWxzIGludG8gdGhlIFBUIGRyaXZlci4NCj4gPj4+DQo+ID4+PiBFdmVuIHRoZSBkcml2ZXIg
aXRzZWxmIGRvZXNu4oCZdCBkcml2ZSB0aGUgc2F2ZS9yZXN0b3JlIG9mIHRoZSBNU1JzLA0KPiA+
Pj4gaXQgaXMgZHJpdmVkDQo+ID4+IGJ5IHBlcmYuDQo+ID4+DQo+ID4+IEl0IHRocm91Z2ggcGVy
Zl9ldmVudCwgbm90IGRyaXZlbiBieSBwZXJmX2V2ZW50LiBUaGUgcGVyZl9ldmVudA0KPiA+PiBn
ZW5lcmljIGNvZGUgbmV2ZXIga25vd3Mgd2hlbiBzaG91bGQgaW52b2tlcyBlYWNoIGRyaXZlciB0
bw0KPiA+PiBzYXZlL3Jlc3RvcmUgaW5mb3JtYXRpb24uIEl0IHNob3VsZCBiZSBkcml2ZW4gYnkg
dGhlIG90aGVyIHN1YnN5c3RlbSBlLmcuLA0KPiBzY2hlZHVsZXIuDQo+ID4NCj4gPiBZZXMuIFRo
ZSBjcHUgc2NoZWR1bGVyIGRvZXMgdGhpcyB2aWEgdGhlIHBlcmYgc3Vic3lzdGVtLCB0aG91Z2gu
DQo+ID4NCj4gPj4NCj4gPj4gRm9yIHRoaXMgY2FzZSwgS1ZNIHNob3VsZCBkcml2ZSB0aGUgc2F2
ZS9yZXN0b3JlLCBhbmQgdGhlIFBUIGRyaXZlcg0KPiA+PiBldmVudHVhbGx5IGRvZXMgYWxsIHRo
ZSBNU1IgYWNjZXNzIGRldGFpbHMuDQo+ID4+DQo+ID4+PiAxLiBJZiB3ZSBtYWtlIEtWTSBhIHVz
ZXIgb2YgcGVyZiwgd2Ugc2hvdWxkIGRvIHRoaXMgdmlhDQo+ID4+IHBlcmZfZXZlbnRfZGlzYWJs
ZS9lbmFibGVfKi4NCj4gPj4+IDIuIElmIHdlIG1ha2UgS1ZNIGFuIGFsdGVybmF0aXZlIHRvIHBl
cmYgKGkuZS4gaGF2ZSBkaXJlY3QgY29udHJvbA0KPiA+Pj4gb3ZlciBQTVUgSFcpLCB3ZSBjYW4g
ZG8gdGhpcyB2aWEgZHJpdmVyIGludGVyZmFjZXMgbGlrZSBwZXJmLg0KPiA+Pj4gUGVyIG15IGV4
cGVyaWVuY2UsIHdlIHNob3VsZCBnbyBmb3IgMS4gUHJvYmFibHkgbmVlZCBQZXRlcidzDQo+ID4+
PiBvcGluaW9ucyBvbg0KPiA+PiB0aGlzLg0KPiA+Pj4NCj4gPj4NCj4gPj4gRm9yIDEsIHRoZSBw
ZXJmX2V2ZW50X2Rpc2FibGUvZW5hYmxlXyogYXJlIG5vdCBlbm91Z2guIFRoZXkgZG9uJ3QNCj4g
Pj4gc2F2ZS9yZXN0b3JlIE1TUnMuDQo+ID4NCj4gPiBwZXJmX2V2ZW50X2Rpc2FibGUgd2lsbCBn
byB0aHJvdWdoIHBlcmYgdG8gY2FsbCBwdF9ldmVudF9zdG9wIHdoaWNoIHNhdmVzDQo+IHRoZSBy
ZWxhdGVkIE1TUnMsIHJpZ2h0Pw0KPiANCj4gSSBkb24ndCB0aGluayBzby4gVGhlIHB0X2V2ZW50
X3N0b3AoKSBkb2Vzbid0IHNhdmUgYWxsIHRoZQ0KPiBNU1JfSUEzMl9SVElUXyogTVNScy4NCg0K
Tm90IGFsbCB0aGUgTVNScyBhcmUgcmVxdWlyZWQgdG8gYmUgc2F2ZWQuIEluIGdlbmVyYWwsIHB0
X2V2ZW50X3N0b3Agc2hvdWxkIGhhdmUNCnNhdmVkIGFsbCB0aGUgTVNScyByZXF1aXJlZCBmb3Ig
YW4gZXZlbnQgc3dpdGNoaW5nLiBPdGhlcndpc2UgdGhlIGdlbmVyYWwgdXNhZ2VzDQpvZiBQVCBo
YXZlIGJlZW4gYnJva2VuLiBUbyBiZSBtb3JlIHByZWNpc2UsIHRoZSBmb2xsb3dpbmcgTVNScyBh
cmUgbm90IHNhdmVkIGJ5DQpwdF9ldmVudF9zdG9wLCBidXQgSSBkb27igJl0IHNlZSB0aGV5IGFy
ZSByZXF1aXJlZCB0byBiZSBzYXZlZDoNCg0KLSBNU1JfSUEzMl9SVElUX0NSM19NQVRDSDogSSBk
b27igJl0IHNlZSBpdCBpcyB1c2VkIGJ5IHBlcmYuIA0KU2VlbXMgbGlrZSBLVk0gc2F2ZWQgYW4g
TVNSIHRoYXQncyBub3QgZXZlbiB1c2VkIGJ5IHRoZSBob3N0Lg0KDQotIEFkZHJlc3MgcmFuZ2Ug
TVNScyAoTVNSX0lBMzJfUlRJVF9BRERSMF9BIGV0Yy4pOiBUaG9zZSBhcmUgcHJvdmlkZWQgYnkg
cy93IGFuZCBub3QgdXBkYXRlZCBieSBoL3cuDQpTbyB0aGV5J3JlIGp1c3Qgc2V0IHRvIE1TUnMg
d2hlbiBldmVudCBnZXRzIHNjaGVkdWxlZCBpbi4gVGhlcmUgaXMgbm8gbmVlZCB0byBzYXZlLiAN
Cg0KPiANCj4gPiAoaWYgc28sIHdoYXQgbGFyZ2UgY2hhbmdlcyBkaWQgeW91IG1lYW4/KQ0KPiA+
DQo+ID4+IElmIHdlIGdvIHRvIHRoaXMgd2F5LCB3ZSBoYXZlIHRvIGludHJvZHVjZSBhIG5ldyBn
ZW5lcmljIGludGVyZmFjZSB0bw0KPiA+PiBhc2sgZWFjaCBkcml2ZXIgdG8gc2F2ZS9yZXN0b3Jl
IHRoZWlyIE1TUnMgd2hlbiB0aGUgZ3Vlc3QgaXMNCj4gPj4gZW50ZXJpbmcvZXhpdGluZy4gV2Un
ZCBiZXR0ZXIgY29tYmluZSB0aGUgbmV3IGludGVyZmFjZSB3aXRoIHRoZQ0KPiA+PiBleGlzdGlu
Zw0KPiA+PiBwZXJmX2d1ZXN0X2dldF9tc3JzKCkgb2YgdGhlIGNvcmUgZHJpdmVyLg0KPiA+PiBJ
IHRoaW5rIHRoYXQncyBhbiBpZGVhbCBzb2x1dGlvbiwgYnV0IHJlcXVpcmVzIGJpZyBjaGFuZ2Vz
IGluIHRoZSBjb2RlLg0KPiA+Pg0KPiA+PiAyIGlzIHRoZSBjdXJyZW50IEtWTSBpbXBsZW1lbnRh
dGlvbi4gU2VlIHB0X3NhdmVfbXNyKCkvcHRfbG9hZF9tc3IoKS4NCj4gPj4gSSBkb24ndCB0aGlu
ayBpdCdzIGEgcmlnaHQgd2F5LiBXZSdkIGJldHRlciBmaXggaXQuDQo+ID4+DQo+ID4+IFRoZSBz
dWdnZXN0aW9uIHNob3VsZCBiZSAzLiBUaGUgS1ZNIG5vdGlmeSB0aGUgUFQgZHJpdmVyIHZpYSB0
aGUNCj4gPj4gaW50ZXJmYWNlIHByb3ZpZGVkIGJ5IFBULiBUaGUgUFQgZHJpdmVyIHNhdmUvcmVz
dG9yZSBhbGwgdGhlIHJlZ2lzdGVycy4NCj4gPj4gSSB0aGluayBpdCdzIGFuIGFjY2VwdGFibGUg
c29sdXRpb24gd2l0aCBzbWFsbCBjb2RlIGNoYW5nZXMuDQo+ID4NCj4gPiBUaGlzIGxvb2tzIGxp
a2Ugd2UganVzdCByZWxvY2F0ZSB0aGUgc2F2ZS9yZXN0b3JlIGZ1bmN0aW9ucyB0byB0aGUgUFQg
ZHJpdmVyDQo+IGFuZCBLVk0gc3RpbGwgZGlyZWN0bHkgY2FsbCB0aGVtIC0gc3RpbGwgbm90IGdv
aW5nIHRocm91Z2ggcGVyZidzIG1hbmFnZW1lbnQuDQo+IEltYWdpbmUgZXZlcnkgdXNlciBvcGVy
YXRlcyBvbiB0aGUgcG11IGgvdyBkaXJlY3RseSBsaWtlIHRoaXMsIHRoaW5ncyB3b3VsZCBiZQ0K
PiBhIG1lc3MuDQo+ID4NCj4gDQo+IA0KPiBUaGUgcHRfZXZlbnRfc3RvcCgpIGFuZCB0aGUgcHJv
cG9zZWQgaW50ZXJmYWNlIHN0aWxsIG1hbmlwdWxhdGUgdGhlIFBUIGV2ZW50DQo+IHB0LT5oYW5k
bGUuZXZlbnQuIFRoZSBldmVudCBzdGF0dXMgaXMgdXBkYXRlZCBhcyB3ZWxsLiBJdCdzIHN0aWxs
IHVuZGVyIGNvbnRyb2wgb2YNCj4gdGhlIHBlcmZfZXZlbnQuDQoNCkRpZCB5b3UgbWVhbiB0byBo
YW5kbGUgdGhlIFBUIGV2ZW50IGluIHRoZSBwcm9wb3NlZCBkcml2ZXIgQVBJPyBFdmVudCBzdGF0
dXMgaXMganVzdA0Kb25lIG9mIHRoZSB0aGluZ3MuIFRoZXJlIGFyZSBvdGhlciB0aGluZ3MgaWYg
d2Ugd2FudCB0byBtYWtlIGl0IGNvbXBsZXRlIGZvciB0aGlzLA0KZS5nLiBldmVudC0+b25jcHUg
PSAtMSwgYW5kIGV2ZW50dWFsbHkgc2VlbXMgd2Ugd2lsbCByZS1pbXBsZW1lbnQgcGVyZl9ldmVu
dF9kaXNhYmxlXyouDQoNCkJ0dywgWGlhb3lhbyBoYXMgbWFkZSBpdCB3b3JrIHdpdGggcGVyZl9l
dmVudF9kaXNhYmxlX2xvY2FsLCBhbmQgZG9u4oCZdCBoYXZlIHRoYXQgbWFueSBjaGFuZ2VzLg0K
SWYgbmVjZXNzYXJ5LCB3ZSBjYW4gcG9zdCB0aGUgMm5kIHZlcnNpb24gb3V0IHRvIGRvdWJsZSBj
aGVjay4NCg0KVGhhbmtzLA0KV2VpDQo=
