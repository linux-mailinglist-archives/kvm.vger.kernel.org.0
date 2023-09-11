Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D858A79A3F6
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 08:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbjIKG5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 02:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbjIKG5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 02:57:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8798610C;
        Sun, 10 Sep 2023 23:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694415459; x=1725951459;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S3p2rNgtuNSDk3BrxK6hJnd/wDxTFAK4bbFH3r9B3xY=;
  b=khwLkzVxHPUh0MIeemss9sJPHN6oROqOD+ppLSwf6iLl8TeJJLPe02sP
   GBFomW8wk7oEdSsPWDvmZeDpCpeYqGieF2AHCowrWLkFeA92aZcht6EQ7
   ZgNFLjkUQ4zjsvHyVvXztgBCJmSe7gB/0FRAOyB5IQzG4n+TyYLKPH/KT
   FnL/G6xNMYGvRCeAswjb6UtQwoItDgbKW44DJgwK0PNxpRB+02BjD//jZ
   Ra/96lhSxpGE3yYS+WGd9rSaxPC/S9J/iUGfmDHHD/1qC6O/NGP5iyj7p
   cFkbAMqUS8NSmlxaWk0f3BxCj66LVEhChxMsvStHpkbVIcrxfET/TF3vV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="363035173"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="363035173"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2023 23:57:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="1074028894"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="1074028894"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2023 23:57:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:57:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:57:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 10 Sep 2023 23:57:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 10 Sep 2023 23:57:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4cango6Z02G9//7sC31PV23rCRr3TeTjPlXIt//pQDbWkLUMCaEygZ4muVwlh6evEbyFuJzERkL4ypprbwFspmVMOE3pDky9wwErlnLRitJcMmGj1hlf0HqYLvFkGHcmHxhxuVuSLPsVhyefZkiRD04JSIvZXLCnpaXajVbVAUwek3X7n545hBgGP0BUbFksXZ7NU0BHbBtxOjlVvO57GzPGA5w9eUAOe/lh+1ndcufbDWtOnOnEofbJ+4RTipd6PJZdNjw7izJRukW8LqXUeEe9s9XCDvKbFnviK8iVp+XyGhcybf2Dixal9rqROl788IcoHd5UYqpnZWEIpipWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3p2rNgtuNSDk3BrxK6hJnd/wDxTFAK4bbFH3r9B3xY=;
 b=nTYqpyYNIB9Ilxx/P1hRBYfZ2B+fXVdAGyJDRCag32AsB/zCQLGlvPIErGK1BTTVkqr9bk4JuzFS4cn/gIAilDPbBzUawPvpNRLtybEbtZzOZAbKsxldnz3HAh3ER81DWkD6T8I1Yx2M4ltPbEOYHaGaG3qN6AJyjg1Z8GxUt4znvmV3cr4TGy5pB2GWCxUfSv6oC+pXNdkkDnUolIqEtDLqMHnKs2XmJDb5LXvFD/ocwqVtmpIELgyH/y+5QO1nwjHcOtMk10m/+m92NAE2KkUtCM7K09UXljeGQvGfAZ2oGoizR8j1jeURvovwTKhLW1TtjA1vtmiK30tp3Mk1mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5796.namprd11.prod.outlook.com (2603:10b6:510:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Mon, 11 Sep
 2023 06:57:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 06:57:32 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Topic: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGR2gCABkO3EIABz/QAgAECbfCABnSVAIAJh5mQ
Date:   Mon, 11 Sep 2023 06:57:31 +0000
Message-ID: <BN9PR11MB52764790D53DF8AB4ED417098CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cfd9e0b8-167e-a79b-9ef1-b3bfa38c9199@linux.intel.com>
 <BN9PR11MB5276926066CC3A8FCCFD3DB08CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ed11a5c4-7256-e6ea-e94e-0dfceba6ddbf@linux.intel.com>
 <BN9PR11MB5276622C8271402487FA44708CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c9228377-0a5c-adf8-d0ef-9a791226603d@linux.intel.com>
In-Reply-To: <c9228377-0a5c-adf8-d0ef-9a791226603d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB5796:EE_
x-ms-office365-filtering-correlation-id: 5fd2b8ae-33b5-4924-2fa3-08dbb2945ee3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b+/oZcA98rPhQesx5SVEJchUKw+Dc4gDXLvRqJshzuKUrPjIUzEa/10LK26nkXweIwa7ci0zglMVjMZVGOsliG3NW2tdIzgUE+Z/uA+tbb+dTYyB9amBgkcsgtWxThgxrUF7L37k/b3YuOGf2zN56C9HwxyavvZ31gU4RjPD9qjaloRlaJ2vhfRo5XsK2w4sga5da6MPU3c38s+ZZ3/axOYaJ2KEFVhjaXSd+PNQwBBqh1UbaW7TVGnAVKwBoWKWITdknnrAS35VjYzlWhPIp44EkKmGArIjz9gqks4l6P1anKxJn+agFQ9YPxUHMWnxLcY4pEC8v8MboujDdhWDDIgbtZ++3wsr2om1tyXtYRKHyP9/OR1f+n8qh41GmGHbwidb1GUZG3rO0iCJgft7BFFYc9jSrd/ykBPneE3hemMBiMAjdFmrQFgdd2hKrqlmRNzqEPzITJROk4Q8yn6h2g+la+nR5/U5QD0MUEHZxh3pNKQwgODRna+4jC5P8ycO4BIB/GIc2ekihkdd2JKLK5fRx4XWbU1pqDA2ukIrBjm9y2qU8e9YI6LrZHiA7rIEveaFBmjS5rOsCArA9CbOr8NyUTehmUKPe/TMEvlewqGG0loCFNRwOrCiERLnfS76u0eXZuctElFQ63o23uTpdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199024)(1800799009)(186009)(66476007)(54906003)(316002)(64756008)(66446008)(33656002)(122000001)(71200400001)(86362001)(110136005)(66946007)(66556008)(52536014)(41300700001)(8936002)(5660300002)(7416002)(2906002)(4326008)(8676002)(55016003)(38100700002)(76116006)(38070700005)(478600001)(7696005)(9686003)(6506007)(26005)(83380400001)(82960400001)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDV5MG9INUxsbytMRlVaaDJzRVJKb3ozb0dST3BMWWE3dnlNbzM1RVhvODc1?=
 =?utf-8?B?aGxZK0MwQmI1NnZJSWorNEFTclkzRUIxMnNaYWc5eTJsM2xRSkRzcUtzWC9l?=
 =?utf-8?B?TFJXcU5SQk9FTmlTS0VLZWRDVmwvSkk0R1N1bCtrRlVkNEpwQisydmNlYzhW?=
 =?utf-8?B?SVFwSjNIUWg3WExkUS9HTjVTUlBJL3FmdFB5S2tJT1FtQXNUZXR0WHRPRGx0?=
 =?utf-8?B?YVVqN1NMT2dtWURPck1zZVV4YVdGYVg5MDQ4d1QwWktkZ1ZhZGlpTy9BZElp?=
 =?utf-8?B?ekNlblhyL2NRWElpRWllenVNQjdPYlAweGFxdDRTQzB5dVBSWUUvbkk0UC9t?=
 =?utf-8?B?WW5LZHNxSUxBOVBGbG9zV3NDOW5QSEY3M051TERvSE1VeE1qSm1pS0tabVZZ?=
 =?utf-8?B?dGpTQ3J6eTFKSkNtUGtpL0MwRk5BSjM4ZE1MUmlrN1hiTU9lWWZEY3AxN21n?=
 =?utf-8?B?RjZpb3hzSWsrTktMN2QyeVFOR0hhekR5MTBjU0s2U1ZFWEJsQ1BsaTJRZzNo?=
 =?utf-8?B?Tm9GOUlFTEwyV2YxZy9CZFlpUDJZZGllcWpsZ2NoRVQrVlEyYjZyK0p6UTZN?=
 =?utf-8?B?bzRxQjBFUVl0bzVVa1JEM3FWbjFadExPaTRueW82elB6a0ZPOGU3MnZEVWRE?=
 =?utf-8?B?dW5MbG1uS0t4ekZVNUhqRU0xSUF4VDI4VGE5bStUZEhwZ0NEN09Xc1gxbEZV?=
 =?utf-8?B?elRaRjdZVUdHSVVDMmFpRUpiOE56Yzk5a0xUVXZMUitIZk52MG5mbDRPcUpS?=
 =?utf-8?B?L2dRc1NDKzdtMVdWQWh1RlBkVUNxcXJ0eC85dCsrTzBuUEtPNytMQjdtZlQv?=
 =?utf-8?B?cU56YnlSUVErcnBNNFNpSTZwQWhyc2p5VExGNGhxeVRkN1F2VDlhMjdWamkw?=
 =?utf-8?B?OVBXcGpKQmxERVNCQUZLVHo3YkJ5eTFaOHduRG54MlRaRVJwcDNId1F2TVVQ?=
 =?utf-8?B?UndESXZ4Yk54RjFCTnFObkcwSVNpWks2Mm5sVU8xWHR6Mm5iVGVMU2hBTFpt?=
 =?utf-8?B?L1ExNzMzTEI5WDlYNmZjVFZFczBUUFFjcXRKejJwcHVGMmhTRjVBN0VkWE95?=
 =?utf-8?B?WVhVRFhrUUo1bFRJeE42VVVISEpoSXRNZ2VDUVhMMkFJUUFuMUJDU2xXUC9C?=
 =?utf-8?B?Q0F3MU4vVnNWSU11TDNNWHdRS0pqSGJ4QU04YytkQ045UG9UOFJoUGFmK21h?=
 =?utf-8?B?cSsrelpnVHczQzZNcmZ3NVhzWTFKSkZFa2dyR2pnUjhBVG1LdDdSQ2xUQmZj?=
 =?utf-8?B?RVllVFlWV0VycWZicC9rbmZvbjdLcWhlWGVQb2VqMFFDRnloWjhOZGg4TXpV?=
 =?utf-8?B?TlAvTjhyMWxPUGtVVS9WV3RmRm05SEk3b01PcEZ6RS9GaGhsOGU4TUhibDIw?=
 =?utf-8?B?VmxVNUtFem9wZHMzZ3hiNkprYU51alZ3c2czQnk0d2NTZ1VrbUhnbDZYTWhj?=
 =?utf-8?B?U1lONjB6elpnaU9MOHlzSkRNbVFETUw3NkptbUpmUWtqRW51M2pVMnU3c0lm?=
 =?utf-8?B?TWRJOUdQQVVZMmpqVytwdUJKTDhYdGR6MEl2enlmbWwxZlV6bURmT0pCaFlW?=
 =?utf-8?B?NyttY0ZRcXhnZTh4NENkNVNBMnFpSkIyQWZyenl6aEV5b3V4Q1ZVckQybG85?=
 =?utf-8?B?NGk0NTg0TVZjOEN1TFFJQVYrVVdXVlQxUVJVMldvMHdaVEI2Q2NBL3ZlZUx5?=
 =?utf-8?B?c3Znb0ZYMHRmTXZ5SktFZnpRbTJLelJDTkN1clA4czhOSnJ3YzRsLzZ0bEdC?=
 =?utf-8?B?cWljUnUzWE1xTFBpRnNKbm1aQUg1U0xqeWZzS3BTSm1mcDN6Rlg0NzVzSDJ5?=
 =?utf-8?B?eHZnYTRRY1NQNS9qOFRLSVg3WEVWTUVkUjROa1pkTGtmRTlPamtmNTBBTFRk?=
 =?utf-8?B?V1dzUG5kbWNyYTg0Rk9qc0hEbFhXM0ZlRytldGd2TUM0QktMT1NoOUROdFRJ?=
 =?utf-8?B?ays1MHVsTFpGMnZHOXBrRGExQmZWbEdpaUtUYWhFZVVtbW9kYmR6NUIxKzg2?=
 =?utf-8?B?Tm9iVVFTU3YwMWF3cTJsU3ZZQjVOTFV1OHUwRE9xRTNLK09TZnlyYk8rUDFj?=
 =?utf-8?B?MGlBQ3RpRUZaa3gvQ2Q1TVJmMmVlTnFHUFFmOEU5MVhEdlF0TTF6MklhM01h?=
 =?utf-8?Q?gRETaRCr1redlTBC64Rz//pl/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd2b8ae-33b5-4924-2fa3-08dbb2945ee3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 06:57:31.9687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2lFg80t/JyzwmMCGqLWueVJOkgH/pnNW2XfrwF4TIjQhOEsfANyzJZBsRu2QLaJxlw0OlfGmuiy/SazqqVcMVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5796
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBTZXB0ZW1iZXIgNSwgMjAyMyAxOjI0IFBNDQo+IA0KPiBIaSBLZXZpbiwNCj4gDQo+IEkg
YW0gdHJ5aW5nIHRvIGFkZHJlc3MgdGhpcyBpc3N1ZSBpbiBiZWxvdyBwYXRjaC4gRG9lcyBpdCBs
b29rcyBzYW5lIHRvDQo+IHlvdT8NCj4gDQo+IGlvbW11OiBDb25zb2xpZGF0ZSBwZXItZGV2aWNl
IGZhdWx0IGRhdGEgbWFuYWdlbWVudA0KPiANCj4gVGhlIHBlci1kZXZpY2UgZmF1bHQgZGF0YSBp
cyBhIGRhdGEgc3RydWN0dXJlIHRoYXQgaXMgdXNlZCB0byBzdG9yZQ0KPiBpbmZvcm1hdGlvbiBh
Ym91dCBmYXVsdHMgdGhhdCBvY2N1ciBvbiBhIGRldmljZS4gVGhpcyBkYXRhIGlzIGFsbG9jYXRl
ZA0KPiB3aGVuIElPUEYgaXMgZW5hYmxlZCBvbiB0aGUgZGV2aWNlIGFuZCBmcmVlZCB3aGVuIElP
UEYgaXMgZGlzYWJsZWQuIFRoZQ0KPiBkYXRhIGlzIHVzZWQgaW4gdGhlIHBhdGhzIG9mIGlvcGYg
cmVwb3J0aW5nLCBoYW5kbGluZywgcmVzcG9uZGluZywgYW5kDQo+IGRyYWluaW5nLg0KPiANCj4g
VGhlIGZhdWx0IGRhdGEgaXMgcHJvdGVjdGVkIGJ5IHR3byBsb2NrczoNCj4gDQo+IC0gZGV2LT5p
b21tdS0+bG9jazogVGhpcyBsb2NrIGlzIHVzZWQgdG8gcHJvdGVjdCB0aGUgYWxsb2NhdGlvbiBh
bmQNCj4gICAgZnJlZWluZyBvZiB0aGUgZmF1bHQgZGF0YS4NCj4gLSBkZXYtPmlvbW11LT5mYXVs
dF9wYXJhbWV0ZXItPmxvY2s6IFRoaXMgbG9jayBpcyB1c2VkIHRvIHByb3RlY3QgdGhlDQo+ICAg
IGZhdWx0IGRhdGEgaXRzZWxmLg0KPiANCj4gSW1wcm92ZSB0aGUgaW9wZiBjb2RlIHRvIGVuZm9y
Y2UgdGhpcyBsb2NrIG1lY2hhbmlzbSBhbmQgYWRkIGEgcmVmZXJlbmNlDQo+IGNvdW50ZXIgaW4g
dGhlIGZhdWx0IGRhdGEgdG8gYXZvaWQgdXNlLWFmdGVyLWZyZWUgaXNzdWUuDQo+IA0KDQpDYW4g
eW91IGVsYWJvcmF0ZSB0aGUgdXNlLWFmdGVyLWZyZWUgaXNzdWUgYW5kIHdoeSBhIG5ldyB1c2Vy
IGNvdW50DQppcyByZXF1aXJlZD8NCg0KYnR3IGEgRml4IHRhZyBpcyByZXF1aXJlZCBnaXZlbiB0
aGlzIG1pc2xvY2tpbmcgaXNzdWUgaGFzIGJlZW4gdGhlcmUgZm9yDQpxdWl0ZSBzb21lIHRpbWUu
Li4NCg==
