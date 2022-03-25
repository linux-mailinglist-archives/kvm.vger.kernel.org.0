Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F6B4E6CC7
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 04:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358099AbiCYDMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 23:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiCYDMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 23:12:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6BD5AA4B
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 20:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648177827; x=1679713827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gui69/uJO6d95rX7PZu+7YZUQ87l593kfykLEWGwSRE=;
  b=LRnx1PYldoDMwrLcVPsJZW13xY76ItIjACfdmXElEAzNNyJz3cfLUcKs
   jUG53OoqmlRXusvBlNFLOWA8A4NbUVe5u14Wdw1nmDaFE9H7NphHirS75
   3SOZO0xTS2WPSP9mfwIzgs1Q9NP2PeO68EOGohgVcbUHAZbVPT8wAn3xA
   ZMfM96hMBJ6Cbat9wFlUJuaTdrhWPjzwLeavxcpowO3uJRZsDdU+wj83w
   xhm2rWVHT+i9MDuSFbtMv7ZS2izY21GdbWsEm9MOCOEXhv8dJuhNO6UH9
   fNdpouMOBLXCGs1o85nE1eUqxdyvUC5B6/mNOHoqVCppf638Hqzv2HpdU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="258508691"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="258508691"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 20:10:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="501635776"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 24 Mar 2022 20:10:26 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 24 Mar 2022 20:10:26 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 24 Mar 2022 20:10:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 24 Mar 2022 20:10:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 24 Mar 2022 20:10:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+l5GKc13DHV0PDzXD/9fcajvXsi57ukK2L9I5O9uqD3j3x7kMGtKggVprMifyyCCEvjC6lJbyhvYvDhqtrJ7lYr/CJoJhFSD8nYYPzfMf8wQZjGLqsPLPXAR+FF3TYAj1UaZKQOulZuVi4oUpAKNWBLyXAwpTIIjl5ztAvHiiDWoJ8++wIfgxu+tHmFidGbCN3leupQFGP5wPqMtpAFMzh+2ntZ1I1PH6Dsf4zZBl4bnQw316cNEfwe2t4Ei9ka1V6Tq0CjnZGO9Mj44mDbw84stA20gyFjR09HdC4habZlaus/uxiRSwSpC0EhpUEVgmbKu1OaSpaeD+vGoL+H9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gui69/uJO6d95rX7PZu+7YZUQ87l593kfykLEWGwSRE=;
 b=iA0jC9qr8KRMgkku50Eup1M94H2flfEs7vf5CgzdoWHba+LSsapKe5uQLT6kvLuix0BeNMR8Mvkrk8olb3SXMDLAvFgfjNd2B/f/fO9UXXb5YChUHH4VD5XqGW56pSthbCiXcvEjeydpiilKm5GpsPUxEOFKGdcfb8WXefAESmCPw8AIDNZJmbhMp8ytpYuS74FD5kn/6vKmt1EfUSTWcfUKg0gl6/cp4X/iBfpvEsh20wPkphnVdm7OmcWcmtmF/WfLaI3D9NNOeVxOOoLMHRZH6AhJS0K8ImfW30U5bdF5djMaUs9tXl4kLnY/329GAJ9sakAWsH9KLcGkXDh79Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4863.namprd11.prod.outlook.com (2603:10b6:a03:2ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Fri, 25 Mar
 2022 03:10:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.018; Fri, 25 Mar 2022
 03:10:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Thread-Topic: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Thread-Index: AQHYOu2EhhTTZTsn5EqajxaIjlC6M6zNmzGAgAAclACAAWiFgIAAEvuAgAA9iRA=
Date:   Fri, 25 Mar 2022 03:10:23 +0000
Message-ID: <BN9PR11MB5276158A447120208895D1E38C1A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <20220324231159.GA11336@nvidia.com>
In-Reply-To: <20220324231159.GA11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bb9a2d0-d40d-42fe-6445-08da0e0d00d1
x-ms-traffictypediagnostic: SJ0PR11MB4863:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR11MB48637098C05C3D37DF3D34F18C1A9@SJ0PR11MB4863.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bHBa9i4dveZBXZZ8SqoYzQy6VQrSxh7ZqMK8Reb69+/Cq9UODJB+8i6VpJbpQNeSq7QCgyAvXrrv6cAS/3cS45T5cR1jBIyf56wJhj8qat2KAdaP2tjwE2jJKROJXgHfKPwVERyScFO5dagjj0y0OPKriacg17YX4HSNOy56QoAN0oE55UtzHYj/bX9R2Fac8DR/QAdCN9cyAXUw0aH0XOfwroaYox9n1vZYgX0boH/A8zPyDLVELIVo0Gy5xCTWU3DAHVdHnyxbOofowMXI92HhpoXOJQbtMsdn7DgD3P8R/v2dxXJ4suxNptkP5efzfSYXLzCyniyuC4/r7oNosJrGz99beF1mPIc4XfORkZ78YTfxm0f5KaWoWIKLjhAbjN0hLK7CMLtqauWYHqwoWn5GFRuliZkCw+FlgbfPy4mMVeR5wiTsQKwUNUcDuY50Rmx+6A2P56QfUVFVKSXf7oe2OyXTiEXnnEH6Kp8ntEM4kVKRNdkGxIHG/cw88ItaXDy02Z7JckYsJIN3edH/LJ2+Oa8D8PnaNzf68GUY4SKTFGKOQhtgNXuF2/Mx/umq54+DDEPanfKjNKzXWLzFs6gjLpKyAd8CWhLs+F9YOV7GbhCfVNRvzW5/ZKOtMnhYuJr6AMPBIT20oACmYAIfd8c3NoGwrehamnEXXZ0m3Y5xWVfKlLz1ft5b/ND0GWsolx16YudXnECl5RfHl/4e9PgbhqCluKdDgfYSvJVWNF3dDcyLPlqe9YlcgXU4t4RUSM4Y/YoSFKX30ElfqDz0lSBaacjevJJDtRcLYyrWGS0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(86362001)(76116006)(316002)(82960400001)(54906003)(5660300002)(52536014)(122000001)(55016003)(38070700005)(110136005)(64756008)(8936002)(2906002)(7416002)(4326008)(38100700002)(66946007)(9686003)(6506007)(33656002)(71200400001)(66556008)(66446008)(8676002)(66476007)(7696005)(186003)(26005)(508600001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czFva29oVnpRWlJNejRFQ3RucGtjRUxQSWZCNHNKUzdvSUJ5ck1ITHhCNEhn?=
 =?utf-8?B?RGRNdHI2Q0p5Wk0zbkRDRUlZOWQ0YXQ0dXRLRFBkYTkzM0FUeUxReEl6Q3Zw?=
 =?utf-8?B?a3EzUDVFbjVUUkkxbGJ6RUVGTTZPanYxL2RVckQzN2FuKzVrbytOdFUzYVhk?=
 =?utf-8?B?QzhIR0tqVUFPQzFaS0hXN0d0RWFPOW51dUJ6dmY1WG1sakk1amRucXZVTFIv?=
 =?utf-8?B?L1NESGd5YzhRcllncVBmTFRHUkRqcDVocFdlMTIxNk5qSUtxT2hMaE9OMmR0?=
 =?utf-8?B?RHZBWHFWSitRWUlmRXZJWXJZcHRvZnpYRDRsT2JlcHhPMVU5Tkk4MEtRL3k1?=
 =?utf-8?B?T1dVQTA4RUEwN2tOWWszVEwvN011UkFid1NtSWJjYnVhSGh0QzBRZVlhdHhX?=
 =?utf-8?B?ODRuOHZPNVl2QUtWLzkwQnhKckx2bFBoWFZVR2xoclltMkNYSTVkS2tqVFhR?=
 =?utf-8?B?NU9kU05MeGdIWGZQc1dFUjhMbDl3ZHNqcjBUQ0E0RGs1OVJhK2hJT1l1Yklq?=
 =?utf-8?B?elVqVzJvV2dYSUhSQ1N1Q2dEenlleis3OEpyTG5DTDQyTjFIakJnNUlHQndw?=
 =?utf-8?B?NzJjYnpDYmdoRzlrMkdwRDIzNEZLYi81TU43UXhIanBHdTRqcFczMGRjTkg3?=
 =?utf-8?B?TEJydUl0UUZnSUdSTk9iS0NaQ3BCNy9iMFVtSGZMN2pQWnhob2xIMjE3REo5?=
 =?utf-8?B?MG8xczFhRUo2c2lPVGk0ZGVudFMyOVdsTGtZRHRubEw1eXhiM0NJbStWQ3JB?=
 =?utf-8?B?UFRQKzNwaTVOU0ZZMFZ0L3pJdWpXcjYxdHIyV0wvOVZPcjEydkhjaTUycHYv?=
 =?utf-8?B?c3F6VnJRSDNiejhVRXRWSm12Nmt0WC9ySStpVVoyMWhZZkNCbnkrQ1lPS1Vr?=
 =?utf-8?B?VEt6OHVHSUFrZlgvcnJwUzdyQTNvM3hXWWtGTnBiWEJxOEgrbEFNTHh4UCt4?=
 =?utf-8?B?OXRZOGtnU202OENPWVZ5SFZIdTA1TzJCOEZ2WXYrb2JTbUtLdE1QbmJKSnhN?=
 =?utf-8?B?K1FMM3NQMlM0QjkrVE51V3IrMnR3ZWw5QU5oWitJeWY0cytkRFR1cThBbGQ0?=
 =?utf-8?B?aldMbTB6bE8zOVdPR3g5VmxJYnIrdXdER2IzOXY5cmkzOVJJVWdSdVh1Z2hE?=
 =?utf-8?B?L0MwUTh5VW1lMm1jL0VzbEtVd3ZFNWZnUUhLVmlYRURhcHZDWWJUczc5Q3FK?=
 =?utf-8?B?dys5OCt4bTRUTUNhZUpUWFE4d0xEbnBHVElhRTc4b0lsaldqOVhDZmJDbjRT?=
 =?utf-8?B?OGxBQXpPREVkZGNJY2tHUXd2b0l0UzV6YWpoQWFXWm4xZkNZbERCQUR4U1ov?=
 =?utf-8?B?VlV5Nkc2aWF3SnI4US95T0Q1OUtWTVo0dTBqcGEzck9udXpnaXlZQkE4KzU4?=
 =?utf-8?B?TTJQbFRyR25oakFFc21XNDVjN0psQ1BKNkl4NzNxT0pMbEQ1WnE1NUV5UjNV?=
 =?utf-8?B?UXFLVHljd28rRjdGR0dob1FydGY4QnlCMFVPRFE0SHdFeDRsd0VnQXhoN0hW?=
 =?utf-8?B?SnZDYVZJa1A5SzJjTzVFbzQvay9nOUFXL2tEZlJ4R2NSYTFlL0ZjWGtuUFJv?=
 =?utf-8?B?WEhzU3UyK1EvRElMZ1lNbzhpd0JTQ1l5Znlrek9HWFdrN2Jra2U5VUxmNkg2?=
 =?utf-8?B?RExVWDQ5YUNZWDkzZ0FYa2I0SkdYSzg5dExPRU5FMUZGTWtKTFY4Y2t2SUNw?=
 =?utf-8?B?ZlVSUUMxcjNKaXBOY2JpRGRnaGM0cXFxcG8rb3Nac1h4TzZiZXJXMHNKWGtU?=
 =?utf-8?B?TDRWdmgxbmFnSVhiWWxlZFpOV3EwcnZaU055bm16ZHZMQVRuMVJtcEFZMWx4?=
 =?utf-8?B?NVBBRFU5YVRQTG1PMEZPeXM0TVFoM0xraXdSS05LaHRnVG5PVTRwR0FKd2sy?=
 =?utf-8?B?WmowVm1UT0Z3bGxEbnV1WTVSM2ZNcW44OEVXdlZoZk4yK0V6SjZLNlNWdjZw?=
 =?utf-8?Q?suMraJbrt5iNUs6GgqLKltfXG00LsmTF?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb9a2d0-d40d-42fe-6445-08da0e0d00d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 03:10:23.6495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51upcodOiEaL0M+Uh/cja+RgRxzkB0mgQzg532bxafWT7pl4DDLq56qSKd7n7KPgYX4NP2PhuQd0RYVNU64Gtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4863
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IE1hcmNoIDI1LCAyMDIyIDc6MTIgQU0NCj4gDQo+IE9uIFRodSwgTWFyIDI0LCAyMDIyIGF0IDA0
OjA0OjAzUE0gLTA2MDAsIEFsZXggV2lsbGlhbXNvbiB3cm90ZToNCj4gPiBUaGF0J3MgZXNzZW50
aWFsbHkgd2hhdCBJJ20gdHJ5aW5nIHRvIHJlY29uY2lsZSwgd2UncmUgcmFjaW5nIGJvdGgNCj4g
PiB0byByb3VuZCBvdXQgdGhlIGNvbXBhdGliaWxpdHkgaW50ZXJmYWNlIHRvIGZ1bGx5IHN1cHBv
cnQgUUVNVSwgd2hpbGUNCj4gPiBhbHNvIHVwZGF0aW5nIFFFTVUgdG8gdXNlIGlvbW11ZmQgZGly
ZWN0bHkgc28gaXQgd29uJ3QgbmVlZCB0aGF0IGZ1bGwNCj4gPiBzdXBwb3J0LiAgSXQncyBhIGNv
bmZ1c2luZyBtZXNzYWdlLiAgVGhhbmtzLA0KPiANCj4gVGhlIGxvbmcgdGVybSBwdXJwb3NlIG9m
IGNvbXBhdGliaWxpdHkgaXMgdG8gcHJvdmlkZSBhIGNvbmZpZyBvcHRpb24NCj4gdG8gYWxsb3cg
dHlwZSAxIHRvIGJlIHR1cm5lZCBvZmYgYW5kIGNvbnRpbnVlIHRvIHN1cHBvcnQgb2xkIHVzZXIN
Cj4gc3BhY2UgKGVnIGluIGNvbnRhaW5lcnMpIHRoYXQgaXMgcnVubmluZyBvbGQgcWVtdS9kcGRr
L3NwZGsvZXRjLg0KPiANCj4gVGhpcyBzaG93cyB0aGF0IHdlIGhhdmUgYSBwbGFuL3BhdGggdG8g
YWxsb3cgYSBkaXN0cm8gdG8gc3VwcG9ydCBvbmx5DQo+IG9uZSBpb21tdSBpbnRlcmZhY2UgaW4g
dGhlaXIga2VybmVsIHNob3VsZCB0aGV5IGNob29zZSB3aXRob3V0IGhhdmluZw0KPiB0byBzYWNy
aWZpY2UgdUFCSSBjb21wYXRpYmlsaXR5Lg0KPiANCj4gQXMgZm9yIHJhY2luZywgbXkgaW50ZW50
aW9uIGlzIHRvIGxlYXZlIHRoZSBjb21wYXQgaW50ZXJmYWNlIGFsb25lIGZvcg0KPiBhd2hpbGUg
LSB0aGUgbW9yZSB1cmdlbnQgdGhpbmdzIGluIG9uIG15IHBlcnNvbmFsIGxpc3QgYXJlIHRoZSBS
RkMNCj4gZm9yIGRpcnR5IHRyYWNraW5nLCBtbHg1IHN1cHBvcnQgZm9yIGRpcnR5IHRyYWNraW5n
LCBhbmQgVkZJTyBwcmVwYXJhdGlvbg0KPiBmb3IgaW9tbXVmZCBzdXBwb3J0Lg0KPiANCj4gRXJp
YyBhbmQgWWkgYXJlIGZvY3VzaW5nIG9uIHVzZXJzcGFjZSBwYWdlIHRhYmxlcyBhbmQgcWVtdSB1
cGRhdGVzLg0KPiANCj4gSm9hbyBpcyB3b3JraW5nIG9uIGltcGxlbWVudGluZyBpb21tdSBkcml2
ZXIgZGlydHkgdHJhY2tpbmcNCj4gDQo+IEx1IGFuZCBKYWNvYiBhcmUgd29ya2luZyBvbiBnZXR0
aW5nIFBBU0lEIHN1cHBvcnQgaW5mcmFzdHJ1Y3R1cmUNCj4gdG9nZXRoZXIuDQo+IA0KPiBUaGVy
ZSBpcyBhbG90IGdvaW5nIG9uIQ0KPiANCj4gQSBxdWVzdGlvbiB0byBjb25zaWRlciBpcyB3aGF0
IHdvdWxkIHlvdSBjb25zaWRlciB0aGUgbWluaW11bSBiYXIgZm9yDQo+IG1lcmdpbmc/DQo+IA0K
DQpNeSB0d28gY2VudHMuIPCfmIoNCg0KSU1ITyBtYWtpbmcgdGhlIGNvbXBhdCB3b3JrIGFzIGEg
dGFzayBpbiBwYXJhbGxlbCB3aXRoIG90aGVyIHdvcmtzDQpsaXN0ZWQgYWJvdmUgaXMgdGhlIG1v
c3QgZWZmaWNpZW50IGFwcHJvYWNoIHRvIG1vdmUgZm9yd2FyZC4gSW4gY29uY2VwdA0KdGhleSBh
cmUgbm90IG11dHVhbC1kZXBlbmRlbnQgYnkgdXNpbmcgZGlmZmVyZW50IHNldCBvZiB1QVBJcyAo
dmZpbw0KY29tcGF0IHZzLiBpb21tdWZkIG5hdGl2ZSkuIE90aGVyd2lzZSBjb25zaWRlcmluZyB0
aGUgbGlzdCBvZiBUT0RPcyANCnRoZSBjb21wYXQgd29yayB3aWxsIGJlY29tZSBhIHNpbmdsZSBi
aWcgdGFzayBnYXRpbmcgYWxsIG90aGVyIHdvcmtzLg0KDQpJZiBhZ3JlZWQgdGhpcyBzdWdnZXN0
cyB3ZSBtYXkgd2FudCB0byBwcmlvcml0aXplIFlpJ3MgdmZpbyBkZXZpY2UgdUFQSSBbMV0NCnRv
IGludGVncmF0ZSB2ZmlvIHdpdGggaW9tbXVmZCB0byBnZXQgdGhpcyBzZXJpZXMgbWVyZ2VkLiBp
aXJjIHRoZXJlIGFyZQ0KbGVzcyBvcGVucyByZW1haW5pbmcgZnJvbSB2MSBkaXNjdXNzaW9uIGNv
bXBhcmVkIHRvIHRoZSBsaXN0IGluIHRoZQ0KY29tcGF0IGludGVyZmFjZS4gT2YgY291cnNlIGl0
IG5lZWRzIHRoZSBRZW11IGNoYW5nZSByZWFkeSB0byB1c2UNCmlvbW11ZmQgZGlyZWN0bHksIGJ1
dCB0aGlzIGlzIG5lY2Vzc2FyeSB0byB1bmJsb2NrIG90aGVyIHRhc2tzIGFueXdheS4NCg0KWzFd
IGh0dHBzOi8vZ2l0aHViLmNvbS9sdXhpczE5OTkvaW9tbXVmZC9jb21taXQvMmQ5Mjc4ZDRlY2Fk
Nzk1M2IzNzg3Yzk4Y2RiNjUwNzY0YWY4YTFhMQ0KDQpUaGFua3MNCktldmluDQo=
