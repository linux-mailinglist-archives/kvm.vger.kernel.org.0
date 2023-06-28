Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D91740758
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjF1A4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjF1A4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:56:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D82C2975;
        Tue, 27 Jun 2023 17:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687913806; x=1719449806;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wFzLbiP2gj7X4dc2wSbm4jMhC1J04aEQXyb/E6/ZDdA=;
  b=mW35QS+aAiQ9LtkbzcmdcG8O1DXd2mCIeg0XKuvo0lEuTGdx++mKkwd1
   5+pIYYUqFijJHdjWPzQzGGFxFr/X/8LTF/W/i4nt5qJAGKHoWj8ay5LRg
   KOtVd7LzugeIaL9q7WcfQwdjC0t9vYYy2/b6XVMXOFETjKzZCR990RaTS
   BVLd+QdTHVLsqqUYlQ5ghZs0iIIoYCbSwk3+yopSJNcyyJL5BwQhQ+wJ6
   Sh5S1J9wEhm1HDLXHkcR5w4m1skm52c4mrndmqcIahrt3thDKX1lAmwNX
   T9x/43xdHlh4bmPel0rZGph/yGlURjmYh10aNEiu9olqVyPfQTeI5nchV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="365173880"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="365173880"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 17:56:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="861305485"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="861305485"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jun 2023 17:56:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 17:56:45 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 17:56:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 17:56:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 17:56:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W53i4QVpZzqb+lRBBr6pLNVjpT2BSCRgjs7Ci1LGqPqZzOiwuFaIHVD1bKwBxSMPJvkqLy3A/uKT3xAwslSLOHSsge6eJjSoaz8AWv930CnR0+0Wtjvx85RIl3i5MwG094C/pkrS/U0dCkpI6sxCWz6HUXMEgzHEfHLZg+4UP0jqyECSIeSyC/3LA+cMHHwA/ww0ZIsfOnt1/KJt0fNqUuPucYpBQ3PyZvlHtibS4MvKNqebL733L+ZKobmJmxrmRdcM7KPZ3qfh3q4fSOXfG3Q/PtxdiPndGN77zPkaJzcyCYVbW2mhFFKR2S7Hs7zJnLOwh5ysdCFQbmRZ/6fd1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFzLbiP2gj7X4dc2wSbm4jMhC1J04aEQXyb/E6/ZDdA=;
 b=hdxbkPunN/01p/7FK2mfmdz+p9O4F98VEFlfegdtYwblgBX7K8RTvnpTBeeGllnz1q7osJDnGNXFyoUAFbMaNSRvT1Q57M7OwhfaEum8Zcpz+BRlse0lXKwT9+x1QuFuwOFj3DeKwdsla3IThBOTpwKAuDQ9PvSUQpzxMeGBbgZ50in/RMsFKr85t1ZaJzmDL/IxQx824mjjv84JgaqXKRYaATTPO5KpvZGoZlQM3mlQI9V0mvoNvQ1MyvnlDXUPpG4QB2NP8AEsXX31e69quQF/6A0eEIV/0FXOQUcCecEzCucgpoWvgIta6LR5kBcy9DaUfRmLiZ4tZbmWmiT+eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV3PR11MB8601.namprd11.prod.outlook.com (2603:10b6:408:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 28 Jun
 2023 00:56:41 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d%3]) with mapi id 15.20.6521.023; Wed, 28 Jun 2023
 00:56:41 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Thread-Topic: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Thread-Index: AQHZoDaix48j/fAvNky2csY4DXj56K+V1V8AgAiMsLCAAIHJAIAAkUfw
Date:   Wed, 28 Jun 2023 00:56:40 +0000
Message-ID: <DS0PR11MB75290D023CF2AF3D046EE6F6C324A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
 <20230616093946.68711-23-yi.l.liu@intel.com>
 <20230621155406.437d3b4d.alex.williamson@redhat.com>
 <DS0PR11MB7529C5F9C31CE343AB66B0D4C327A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZJsKXoK7SF359Tb2@nvidia.com>
In-Reply-To: <ZJsKXoK7SF359Tb2@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|LV3PR11MB8601:EE_
x-ms-office365-filtering-correlation-id: 14f8ed87-4a9c-40d9-fd66-08db777288e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aabeelEL0fEzsNcrO9NLnchADHvggV9e8ZcwEWbtbrBso9fQwVaL+d7bgX8hlpQPGQmYrti/SPg3EamTTOdUVruSdjlzK8vwJYT1RqBDR5vmGrXkHQpv4ktJ0FrdPSsuQ+cXkn7odwTOWZLvo1fuuU3c57cOU8uft1smO2Xnoxze+jVGDPj4g+mUCrq/zpG2K1e/paXyssI60CahWHnD1R2hyKWPPBmXD1C8puCT6a+HTnGcweYNNeksACpFDdbZHIHSv5a1uuR6kVyO/Tdvi6APByyDEqJ846oGhH/8zqG+Y56nYcOtwMCMdNJnhPqvA5LAf+p4h+v1sGfIq9Q1vZNK1mbOgzIuqIcgc7cB+hCR1QrE1FJ1wnbxyjqIVpsyfD10qeuWltFEsGT48cztNTa0/XaKKHIdcKiSFhVaio0SrTgurM9Gu/9FawR89y/pjX1IjAbPu/G+w7mCYLGvPDyYhqBjK9SisCe6x+PSLfR0zsjb+79lytQBIHB2+cO1bs0y8gjjIoaP96RFqRemLvhtrQAg3GkK+eKKRYr8hyWeaR+OsuYkpVX+gPJivcogo/8S7ulAC+BBdbPH3jO8a+TyCTrHjmdE0guQhwo5FaDRf2+0huDXyPctAtFKgxMc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199021)(7696005)(54906003)(478600001)(9686003)(33656002)(66556008)(2906002)(66946007)(26005)(186003)(66476007)(64756008)(66446008)(71200400001)(6506007)(316002)(7416002)(76116006)(38100700002)(41300700001)(5660300002)(8676002)(52536014)(4326008)(6916009)(8936002)(122000001)(55016003)(86362001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHNTYnhDbkpHZ1FDOUJ0WTVmQzN1QWJUMUpoMnowM3BtTnY4Y1g4NlI2MjdQ?=
 =?utf-8?B?dCtwU0R2WEI3MWd5d01pRDRXSVJ4V3JxcmM0WDcwcE5IVFF1cWJzSW11Zkxq?=
 =?utf-8?B?dWlwSUt4UDRhanFIM0Z1eFVRRjlnb2ZLVGM1UE9xNnFqSExXZ1pra0lvc2E2?=
 =?utf-8?B?eFdFdHlXWFMxWjd0UzBGYi9QUUo0QzhlTS9kZmtqRTVOakNFY2JWc2ZqWFRT?=
 =?utf-8?B?NCtSU1lDVDhNRjJHZ3dZaUxXSEczMStPWUluM3JkeFZIWFBXbEowMGJ2cEVF?=
 =?utf-8?B?a2FKN1BBczk3RUkzY1RtZzNPSm1kQ3BGUVl6a3hzakJYTkc2bHZRSzlDa2Z2?=
 =?utf-8?B?YzM0SEl3MnhUb0E1MHg3OGlDTkozbFAxdWN0WXZTaHFZOGQzTXluVlNiYytk?=
 =?utf-8?B?eExYaEVYTHBMK1BGRTRBUFhJeElJSjBpTHA4WklPcExkRjFydFBXb2pJT3lX?=
 =?utf-8?B?eHBkeVFqWXpiRjdaQkhKRUF6QUlmU05lUEQ5MUt4cDU1bzRZZytJRkoxeXZl?=
 =?utf-8?B?S2VXZ2NiUktCdm1DT3Rpa0pkNmVQMml4bVYrK2IvRW9mb09Qemx3R0JMWW5l?=
 =?utf-8?B?NDZoeU9kaERkYmU3NXRaV2h2VEtLV0hYMmY5STNzR0NkMHpyVm9pOGlJU2Uv?=
 =?utf-8?B?ajdaV01ONWlTbk5hRkpsYnVybk10M0JYSTYrWFh1V0c1ZVFlRGVZVnhaM3Jv?=
 =?utf-8?B?ekcrQjlwNERZT3ZzU1dqdjd2WGpBTTg5OHoyQSsxQmVYVG5qYTFGdGIzZUNF?=
 =?utf-8?B?OW5hS2FLYjlUN2lNYUNyS2YrdTlkcndSK0FTemFGVGwrZ21jeEE5c0psWnZ1?=
 =?utf-8?B?WkNnbGpyRUpMazdiVjNEZ3RsakRqNGh2QXlhQkYyczUzeFdOdVB6UVRDSUVn?=
 =?utf-8?B?d0xUYkxIV3BoQ0tOSHltWnRGUWo2Nm9hNUZONzBmQmtxYnlRZDhDUDZ4eXdW?=
 =?utf-8?B?WDZMSnlWWmxyRWJ2N1cxTjFqT2xxbFUvQXZ6dUVqR2tOWmpuQkFsS2dWWllq?=
 =?utf-8?B?TnRyaDlJaW9BZWVmZmtMUjdRS0I2QWNCSVhGSHBad21VbnlpUDlvOXdlK244?=
 =?utf-8?B?ZTR3a3pYVnJmU1RXMDhPRzY2eFg1b2M0MWFjTW05bFNjLzQ5cysrWkVKelBx?=
 =?utf-8?B?V2pMNUh0Y2ErcHVjL2VJMUhNTHNFSjBRRFcvSDBJbkNjMElLRS9JVWM1VVhT?=
 =?utf-8?B?U0NGSkViYzQ1cEpJTFFsRUx1b05QdWpLSXBEb3ZMVmE2R0lvbHBFaFNXUmZX?=
 =?utf-8?B?c0RzcWFSTU04QXJBVWhxQVIxRmxkdk4ycmxGa2FNZmRtc1FDTTc1V1JZVk5S?=
 =?utf-8?B?YVdpalI2Zml5OXpEbmVueDQ1aHlwSkl3cHdSY0F6N3p4TEwxcmEwMjZFVjN0?=
 =?utf-8?B?c0x2OHJ1RE9YVCtZdDY0WHBTd3pleW93WjJuS05hT3lzYjdEMFZqalVid1B1?=
 =?utf-8?B?TFc1WmVyVkpQNTFWTE14YWVzWE54MGsrUm9oa09jVms3aE9mcTFzZGtBangx?=
 =?utf-8?B?bGZieGtGUllLSnNWekFIVkpidFhlTkZ5TS9heS8zT0wwK01SaytLNUxocWl3?=
 =?utf-8?B?Tm9xWGhwT05mU1FIY0cvVTZSbHVlMGtVb0pJcTRyNE1mSVNwOExkSENQMkpS?=
 =?utf-8?B?dlJXaHgvUmttblU0UlFWMTNOOWhla3dKOC9WemlaeVYzZWhoUFMrQi8zSURs?=
 =?utf-8?B?cGl0d3Y0WHdDNWRoTFNUT3RTTzVZOEFrVWd5dlpZV011eG1TNFJCelM1bXNI?=
 =?utf-8?B?SlRhRWlBWkNxRzh6Q0hyeDNiYnNVVVpqK0JOblkySGY1OXVlTEowck83Ujg2?=
 =?utf-8?B?QmhidXlEU0ZRbis3QlIyMWo3Q3cvemdML1hnaysrcmtOM2sxc2Y2a1h0ZUNn?=
 =?utf-8?B?UE85TWVWOGQvUHNQRlRTWHdnYmRWVkcyYlF1R29UTjNaZUhDQVR4ejZyVFNG?=
 =?utf-8?B?d3lHUCtkM01LMXgwVEI3Q1JWR0o1T1BTelFaRGdPTWRLUU1leEFiS294MzJW?=
 =?utf-8?B?dnBVUE1pQVExY1RuSjVjekhodTdNdWlNSkszYXpkc0taN2RySG9xVjhCdUdi?=
 =?utf-8?B?MVRneVlSTTZycGxKdkd0UGlaaU9KMG96QlgvbDY4Yi8vWnJMOVJ0Z0RGclp3?=
 =?utf-8?Q?6p6VW5U9fWIk+5Bq50ybIsXia?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f8ed87-4a9c-40d9-fd66-08db777288e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 00:56:40.9632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cz+tKRkkkws6Q0cgHpJSTyc9DGeRAt+pnPD3P6ImccbQcrBSRK6/L58xn+Jpuj/HOFtgXVTbc76COqscb5IGYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8601
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

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEp1bmUgMjgsIDIwMjMgMTI6MTIgQU0NCj4gDQo+IE9uIFR1ZSwgSnVuIDI3LCAyMDIzIGF0
IDA4OjU0OjMzQU0gKzAwMDAsIExpdSwgWWkgTCB3cm90ZToNCj4gPiA+IEZyb206IEFsZXggV2ls
bGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gPiBTZW50OiBUaHVyc2Rh
eSwgSnVuZSAyMiwgMjAyMyA1OjU0IEFNDQo+ID4gPg0KPiA+ID4gT24gRnJpLCAxNiBKdW4gMjAy
MyAwMjozOTo0NiAtMDcwMA0KPiA+ID4gWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdyb3Rl
Og0KPiA+DQo+ID4gPiA+ICtWRklPIGRldmljZSBjZGV2IGRvZXNuJ3QgcmVseSBvbiBWRklPIGdy
b3VwL2NvbnRhaW5lci9pb21tdSBkcml2ZXJzLg0KPiA+ID4gPiArSGVuY2UgdGhvc2UgbW9kdWxl
cyBjYW4gYmUgZnVsbHkgY29tcGlsZWQgb3V0IGluIGFuIGVudmlyb25tZW50DQo+ID4gPiA+ICt3
aGVyZSBubyBsZWdhY3kgVkZJTyBhcHBsaWNhdGlvbiBleGlzdHMuDQo+ID4gPiA+ICsNCj4gPiA+
ID4gK1NvIGZhciBTUEFQUiBkb2VzIG5vdCBzdXBwb3J0IElPTU1VRkQgeWV0LiAgU28gaXQgY2Fu
bm90IHN1cHBvcnQgZGV2aWNlDQo+ID4gPiA+ICtjZGV2IGVpdGhlci4NCj4gPiA+DQo+ID4gPiBX
aHkgaXNuwrR0IHRoaXMgZW5mb3JjZWQgdmlhIEtjb25maWc/ICBBdCB0aGUgdmZpbyBsZXZlbCB3
ZSBjb3VsZCBzaW1wbHkNCj4gPiA+IGFkZCB0aGUgZm9sbG93aW5nIGluIHBhdGNoIDE3LzoNCj4g
PiA+DQo+ID4gPiBjb25maWcgVkZJT19ERVZJQ0VfQ0RFVg0KPiA+ID4gICAgICAgICBib29sICJT
dXBwb3J0IGZvciB0aGUgVkZJTyBjZGV2IC9kZXYvdmZpby9kZXZpY2VzL3ZmaW9YIg0KPiA+ID4g
ICAgICAgICBkZXBlbmRzIG9uIElPTU1VRkQgJiYgIVNQQVBSX1RDRV9JT01NVQ0KPiA+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXl5eXl5eXl5eXl5eXl5eXl5eXg0KPiA+ID4NCg0KUHJv
cG9zYWwgQS4NCg0KPiA+ID4gT3IgaWYgSmFzb24gd2FudHMsIElPTU1VRkQgY291bGQgZGVwZW5k
IG9uICFTUEFQUl9UQ0VfSU9NTVUgZm9yIG5vdyBhbmQNCj4gPiA+IHRoZSBleGlzdGluZyBLY29u
ZmlnIG9wdGlvbnMgd291bGQgZXhjbHVkZSBpdC4gIElmIHdlIGtub3cgaXQgZG9lc24ndA0KPiA+
ID4gd29yaywgbGV0J3Mgbm90IHB1dCB0aGUgYnVyZGVuIG9uIHRoZSB1c2VyIHRvIGZpZ3VyZSB0
aGF0IG91dC4gIEENCj4gPiA+IGZvbGxvdy11cCBwYXRjaCBmb3IgdGhpcyB3b3VsZCBiZSBmaW5l
IGlmIHRoZXJlJ3Mgbm8gb3RoZXIgcmVhc29uIHRvDQo+ID4gPiByZXNwaW4gdGhlIHNlcmllcy4N
Cg0KUHJvcG9zYWwgQi4NCg0KPiA+DQo+ID4gQEphc29uLA0KPiA+IEhvdyBhYm91dCB5b3VyIG9w
aW5pb24/IFNlZW1zIHJlYXNvbmFibGUgdG8gbWFrZSBJT01NVUZEDQo+ID4gZGVwZW5kIG9uICFT
UEFQUl9UQ0VfSU9NTVUuIElzIGl0Pw0KPiANCj4gVGhlIHJpZ2h0IGtjb25maWcgd291bGQgYmUg
dG8gbGlzdCBhbGwgdGhlIGlvbW11IGRyaXZlcnMgdGhhdCBjYW4NCj4gc3VwcG9ydCBpb21tdWZk
IGFuZCBhbGxvdyBpdCB0byBiZSBzZWxlY3RlZCBpZiBhbnkgb2YgdGhlbSBhcmUNCj4gZW5hYmxl
ZC4NCj4gDQo+IFRoaXMgc2VlbXMgdG9vIGNvbXBsZXggdG8gYm90aGVyIHdpdGgsIHNvIEkgbGlr
ZSBBbGV4J3MgdmVyc2lvbiBhYm92ZS4uDQoNClNvcnJ5LCBJJ20gbm90IHF1aXRlIGNsZWFyLiBB
bGV4IGhhcyB0d28gcHJvcG9zYWxzIGFib3ZlIChBIGFuZCBCKS4gV2hpY2gNCm9uZSBkbyB5b3Ug
bWVhbj8gSXQgbG9va3MgbGlrZSB5b3UgcHJlZmVyIEEuIGlzIGl0PyA6LSkNCg0KUmVnYXJkcywN
CllpIExpdQ0K
