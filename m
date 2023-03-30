Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B126D055B
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjC3Mxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 08:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjC3Mx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 08:53:28 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219EB1701;
        Thu, 30 Mar 2023 05:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680180808; x=1711716808;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T6mgfeChSW5pbYTrOQqa5bwIBX9UUG55aBavyuT75C4=;
  b=GU0BQRlMnhDoosBRpCHUW++2upZKSN3AOsgUIgzA1RXoPFXE6tQ7ll9a
   SfXB97LAhPLBDVBF7mtQ6vwMbqKIlvSehPPgwJEPG9LW21quTZslrAVi6
   iEOcEMPbdulKFZ347Cp37RKGs/BBqJ7TRf2TXn1Xihyq1f0XHduF6/1m5
   tVjhsMqee/TsGhWmVpbMKBKiaMFR1bWKEfROl6baohQycj8VleMhYetOo
   WcPifWRZc7sJMg0E9toONe6SGkejB4ha0K3pREx5SuTmwFqTgGPQPG0RI
   rj591lEq5tNSf+3GgAgcoGQKE9OueCh3Ui0Ou+gQ8kzG0r0Qro1lQ2LkM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="338657042"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="338657042"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 05:53:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="753986490"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="753986490"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2023 05:53:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 05:53:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 05:53:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 05:53:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 05:53:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBdgHCxAdiGY1h2xKNnhV7TThq0R9loaAPmdw/g+VH3gOowmIFzJccWO8FI95ukE0boVdkOoAje3nGF4PafLl2CS96/T/A+PxipAAIM4VrdeIDmerJ0noqgId3FuNraaKJkg6SPjcinxK8cJYqaU6uzLEB5JXYZnoTJ1kiB35euuuPkT4ylujz+xJn4eKCT4AdraxKJmmMn+ESpUyIftOmZCjztCcsztnautxnmPbEqpId7m7+gyCQbegcdNBGfmJGvNObO6fvOHFRzdCqf9IP3lZVKT6KuxaB59K0xk9Qo5GzwzB7g0pcIOlvNxBQImZnLp0tpo/NRfYsqwqWDJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6mgfeChSW5pbYTrOQqa5bwIBX9UUG55aBavyuT75C4=;
 b=Yzey3YNWKZxVeYfC00sLDVNN1/+5pc4BL88aBEnv9dsahHmY6mf4mzK2TVhXTm6noJS2fxdlFnbGIn9ZL7Yj6F4zRaXy2zNRH8Gv1Gabg7kblf9JbxU1UFmFz+9mcPH3A37Dw1I0C/SagRoyxEU+4sTz30vs2OxsmhcUaa4BvOFTp60QXihw9X8F6N1mbrBTWkFKWOkMmpJlsH61vj4EGP/al/mNRvaWJX77Xbrws44M8IEklJgcEegzhvcZqOiEJrwSktewkW+LQ0C17ynhAr5+jIxNX/1+S2g1OsEInEV8Im8Ai/PkPFKR6MiwUtwK4DV8cNwotvrM7KmyqKfmxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6803.namprd11.prod.outlook.com (2603:10b6:510:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 12:53:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%4]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 12:53:17 +0000
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v8 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v8 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZYJBFW/d43vElu0ifua7qv0EiF68SQfqAgAChOOCAAFfWgIAAEOiw
Date:   Thu, 30 Mar 2023 12:53:17 +0000
Message-ID: <DS0PR11MB75290F3A8C6B08258B06C63AC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-22-yi.l.liu@intel.com>
 <20230329150055.3dee2476.alex.williamson@redhat.com>
 <DS0PR11MB7529A19B0368DA4769444B84C38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZCV38yPbzSRQcsRl@nvidia.com>
In-Reply-To: <ZCV38yPbzSRQcsRl@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6803:EE_
x-ms-office365-filtering-correlation-id: 45de798c-2a4d-4e8c-3e30-08db311dbbd1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s7MA2MxmgW+5oEwCVfydTnTmMDwGpeT2A0rQ/fIWwJuPQPcnteUIVkBnWtFhMtyMWX6TUkcEceW1tPCkzCs9XWP2mVKX9SoFUnS1Su+ROjiMl5S8aHsSZ99R5IgNh0MWTzN+/EHtYpc4LH2obmOqOpk2G+pL9daBx1I7k1eQq5Yr41sS/eUISzPhXCGP0IAalFsUIDSwBWEZwm+14pzaYBaTWsJjA+W/iRSQwiWw8LM2Naj6N802iX4CzF1vl+wjzTV8SwUmnvxiWUx6bQDzUFiIPVsz5d3eeORLjcV/eSp7HOhG93DTQmj1ArwxThOQ7nUPp3Bm4qWznSh9P52nqzyL76Hhb/d6Xgdi5J5IdvDSGX+OObDq0siMbomPWQrG18aXGrC8IY8H1RZcW+REEXDsZ2bAJUImQlTVlH2qB5oCpHogtqYCDijD93jwZGinyMnF+EiWo/J5DSYBmweu3XeGAUBKC7PK+HkBoozLxUWizCguJCHKTGOBAfBEFHnof8Vw7fcA3TD6MGDEca06N00xtkyj7Iulf1w6xE+SgUyXW+RpUv6sb+bu6xDpRlC8zRbVSotXuM7Xqj5q2IYUwquk3yX6WXm7cJhDUuHc0PDKuDUgi1f+VCIRGPbayLTF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199021)(55016003)(7416002)(2906002)(478600001)(38070700005)(71200400001)(33656002)(86362001)(7696005)(41300700001)(66556008)(316002)(64756008)(82960400001)(66476007)(4326008)(66946007)(66446008)(38100700002)(6916009)(8676002)(52536014)(4744005)(5660300002)(8936002)(122000001)(76116006)(54906003)(6506007)(26005)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFJNcHdXSmFnTnNQMHI4bTZZVXpBalg4bElvMGJKelBrakh4ZTcvTVZaa2Q4?=
 =?utf-8?B?b1FuSkNUa3ZjeUh1c1hmeVorc1BXdVRJclVCTGc3eDVPT3lkbUs0QzZDZy84?=
 =?utf-8?B?SkZpL29LbFp2RldkQXZHQTF3RnpobXp3dmc5d3lCWGF6bE00WTBrTGhTVllD?=
 =?utf-8?B?SEc1NVhTRUtpSlB3YlBoZWpjMXAzVk5Cc3RxTDFFSmlDNlJRK2l2b1JqRnRs?=
 =?utf-8?B?b3JOMHVNRlUvNHllRjJsMmtuYm01bjU0YlVRZ2pxRHR1MGc0aUV0VGFJaVZt?=
 =?utf-8?B?c0NzdTYzN0hubU9DakVybzFJVGlSS2JETkt6S3NJbSt2bDI3bkc1UmxZdFp6?=
 =?utf-8?B?c3hXbk1wbUhQV1BVUUR4WnZkRDI3TUN0R2g1ZEQvRW1ETjZuQXZ6em54RzFv?=
 =?utf-8?B?ZGpYSE04bUlQVDBvUkw5dFQvaDc4NkZtaUVTZk1iano4bTZ0a2ljWndmNHRV?=
 =?utf-8?B?YllMRUdZOTk1ZFhVcGRGZHoxL3pzYXpsMjJIbHkyMGVzZ3hScDNNZUhpVWR3?=
 =?utf-8?B?ZFFwRm1ONVlSQk96VWF6WUxBNk9DVVc4TmloNXlUUlVSZ0dtQUtnb3FaRUdH?=
 =?utf-8?B?dEdic0hYVFhJb2xDdTRESmY4UHVUZ0EzT2ZPRlhueGpibGhnZ09wQWdkbzg2?=
 =?utf-8?B?N083cjRBbFp6T1VBWFhWVkQ4dFdoZGZpYUdseU5WRXpldTh5RHBaemVGMmsy?=
 =?utf-8?B?bnZTODZOdUtQWkRXcXluWEZ6TFBkcHBuN05QWTZseE1RajRFQnVEZmZ0Z3NL?=
 =?utf-8?B?bzhLN0puWjMxWkhuODhIamlsbWlSL0QyYVFMUENIOHIzQjE2dk96SjFIbkov?=
 =?utf-8?B?dXRhVHFmK1NtRUdiaC96UVVaRWdRMjE4Zys4aGVNUzloZkMvQ3NNazdwRFJQ?=
 =?utf-8?B?MDZiVVV4SnhWdE02MjBPcDFoVDhHTmtJM3N2UE1kOFg2R0l3SGgzUG5ZSk9k?=
 =?utf-8?B?MXpWWExsa1VsdTJyZ3AzL1VTRnVVVldQaUF4YVBQd0JhUFVocDBrQ3p4eXBj?=
 =?utf-8?B?RFhxZUNwYmppSVg1L3RjeTI0SUxsUVdFTmJDSjRueXlwL2tqY3RtMHlKTmFl?=
 =?utf-8?B?dFFqdm93bFR2TExDNkRvRDdteWEzM1NIbXAzVXhRMWFWREJGZy9DaW9yTVlu?=
 =?utf-8?B?NE9VcDhoUHpFcXQ0a1RLdUFkOEc3d2p6VFYvN0E2L21qamQyZVMwUUV3ZVNo?=
 =?utf-8?B?RGZHaEZ4T3cxcWpsQVF6T3hxNXBKZDZoSXVDRHJHYUladjFQSzRodjMxQU9p?=
 =?utf-8?B?VWhDR0NickQrRndJRU9nSlc2WHhyT1piSXJ0M3lJbU9qWURSVGdUVkczY0th?=
 =?utf-8?B?MmhyZHgzZk5rMzZiNzd4TG5JNHEvdGZFbjhxakc2cUFjSXk0K0ltTlJFb1pa?=
 =?utf-8?B?NWZrODZJTVRLUUtuSC9GY2l2QTh2T05pOHowdkduS3pPWTdMYnYxbVp0TEU4?=
 =?utf-8?B?TXB4d1pJeTNpUzk3QnZNMmRSNmVmZThPS3ZMZlVpM09hSTJkdnZaTjZxc004?=
 =?utf-8?B?aC9reitvL0tpZmIzYXFRVEV5T3AyUHd1WnJraGc2aVNtME5IK0xnSlZ1MVlx?=
 =?utf-8?B?eml6dzAvcHJPQk1ZYklPMUExMUxqRzdVekljTmRTUzlWSDUvSit0cjJ4OVVU?=
 =?utf-8?B?QUVxTjByWnRPK1c1Vis5VEc5ZTRvSzdBbFQ1aUlnTVAyRnpCanYrTW1xWUQy?=
 =?utf-8?B?UEw1aVVGUzVQK1pGdWEwWG5PQld6SU4wOGdHc2RKLzNiRDhqcllObGdkeXVL?=
 =?utf-8?B?TmF3OERUKy9rRnJybG9UV0hzYnhrWC9mcm9pK0RTeFA1dFAzdmFwZVBjUXhY?=
 =?utf-8?B?ejhkbEx0ODErRC9US1VjZGdVZi9BeWdOZ3E0TlBNTFhEeDQzQVdPYlhnVmlT?=
 =?utf-8?B?Q055eU9jRkhlUExkK2dPL21CZnJydWtubjU4VzFYQlNqSFl1akNzSnZ2Qkpq?=
 =?utf-8?B?WjljTlFJaWwrWE5aQ2dkK3ZibHZpemdBeGFnZlBiSG9DQ0F0cDhDMmlHak1K?=
 =?utf-8?B?TUpmU2RUai94NFZyT1R4R3RWZUhwb3RFQWdsZTZDZlBubS85cWRNUFlobUQ2?=
 =?utf-8?B?UFI5Qzd6YkFtQ1ByaVBJL1FlTmVnSjdndm9iWXZSbmZLS1o5ZEJJbi9JbThk?=
 =?utf-8?Q?HVN5WVKCuxDTuzPcc/ugLatlT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45de798c-2a4d-4e8c-3e30-08db311dbbd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 12:53:17.7538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ya6BdhMzxa2vTCpdlWdJPWY95mfo8d3GtkPxhesbMi2k0S/eFJsi9SQS5G2nN7SsmjvIBkemHbAJ61Kzhu1rAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6803
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgTWFyY2ggMzAsIDIwMjMgNzo1MiBQTQ0KPiANCj4gT24gVGh1LCBNYXIgMzAsIDIwMjMgYXQg
MDc6MDk6MzFBTSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiANCj4gPiA+ID4gK2xvbmcgdmZp
b19kZXZpY2VfaW9jdGxfYmluZF9pb21tdWZkKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZiwN
Cj4gPiA+ID4gKwkJCQkgICAgc3RydWN0IHZmaW9fZGV2aWNlX2JpbmRfaW9tbXVmZCBfX3VzZXIg
KmFyZykNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKwlzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSA9
IGRmLT5kZXZpY2U7DQo+ID4gPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlX2JpbmRfaW9tbXVmZCBi
aW5kOw0KPiA+ID4gPiArCXN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVmZCA9IE5VTEw7DQo+ID4g
PiA+ICsJdW5zaWduZWQgbG9uZyBtaW5zejsNCj4gPiA+ID4gKwlpbnQgcmV0Ow0KPiA+ID4gPiAr
DQo+ID4gPiA+ICsJc3RhdGljX2Fzc2VydChfX3NhbWVfdHlwZShhcmctPm91dF9kZXZpZCwgYmlu
ZC5vdXRfZGV2aWQpKTsNCj4gPiA+DQo+ID4gPiBUaGV5J3JlIHRoZSBzYW1lIGZpZWxkIGluIHRo
ZSBzYW1lIHN0cnVjdHVyZSwgaG93IGNvdWxkIHRoZXkgYmUNCj4gPiA+IG90aGVyd2lzZT8NCj4g
Pg0KPiA+IEBKYXNvbiwgc2hvdWxkIEkgcmVtb3ZlIHRoaXMgY2hlY2s/DQo+IA0KPiBZZXMsIGl0
IHdhcyBmcm9tIHNvbWV0aGluZyB0aGF0IGxvb2tlZCB2ZXJ5IGRpZmZlcmVudCBmcm9tIHRoaXMN
Cg0Kb2ssIEknbGwgcmVtb3ZlIGl0IGhlcmUgYW5kIG5leHQgcGF0Y2guIPCfmIoNCg==
