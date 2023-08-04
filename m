Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E368976F8A8
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbjHDD4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbjHDDzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:55:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15274693;
        Thu,  3 Aug 2023 20:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691121334; x=1722657334;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lqT1NWjWhQEmP4S/k2K5OdhSZwa3r8tiRjjBa8khQxk=;
  b=IyVXHRRkfSI2PsPUX+Yf5PfFNAzPWQapzx8JUu6eB+wjHUD84IGcgJPW
   JE2RFkvjU6s3BX049zu9gVOMQ0wqiQA5Y8LEKQrBGrjL1083EM5JfKnc7
   Sc4hePss4uJV7BBpYKd4JUzkIxTSe4ckbj0g4vwSpfJK3tDEKMwJndnxN
   yGXTZmjeKCtXhfSWmeGU0DvAmu40300zJyidXX7AylJ0RTHsi45+cc57e
   3PJLTAHf+O1rjrFFLMNI+H9PO9bWhUUmXksFQQz3m16l5roDj8puFV6HB
   xkKdASpw/VcjrlcYPOg/Gjz08ieeypsvzwi8JajJHZOTK7c4eX0SLJxZO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="373702338"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="373702338"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:55:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="764936345"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="764936345"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2023 20:55:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 20:55:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 20:55:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 20:55:32 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 20:55:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1kQA6e9exwOASSJsLh1xJ+OBmStDUoZ+KozmWEtenjysWHR8LJY4/BBb0qfzWpBULYzjKDuOM0FN4vWUb8YD6fOCYFwA0/eUNO7TAE1/S3yICo4jKR5m5oZ0DLtBbyQ46UbUtDtw/x/utbEt6owWYl0Qoby+83hyRrqnggGYivmHMhKniqmiZDsWOrkcrYuCMSGgr65PmHLh/2IVV+6OT6BN5hJCouEX3j9ew153IcLan27NREP+MTmyOgUOmU2o5gGV7SK0ZlnprZ3sZwdnabj0H4RR0ykRS2aIOshDXdye7YZ8gKOiC8mkCIe9aXLQ3ZoJdIIx7Xg47qt1WbITw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqT1NWjWhQEmP4S/k2K5OdhSZwa3r8tiRjjBa8khQxk=;
 b=J85n2VtkaLiNvi2XaK7cSJWNvFPjIJxrsWk/VcjZ9RCX74MtX0XLWlOfcBXTQqSK0vdRwr8pMHjpV3WInS/hJoUiJ2WXNqCzwHAFOarMmgtUwaaa2/UeZAz7DqIo39dPBFKFISIDKx3n+2Ax84ohXfZt6HxpolH1+ApPsM1DUxQIWqUifXA9pmywKmauciv/owVV5Krv3EH50l5eFZJ8wXqKlifJoWCScOHUDkl4JNgHV6r14GeRzHwjUbLl33IXcXOQ08tyXj76xu4fiIXDnbxC3a327mwy5+6TnDWR7x+Ut56KqawQJU5jQ5uu1jcxnPjuFzmnPeuIBDCN3gzlwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7726.namprd11.prod.outlook.com (2603:10b6:208:3f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 03:55:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Fri, 4 Aug 2023
 03:55:30 +0000
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
Subject: RE: [PATCH v2 05/12] iommu: Change the return value of
 dev_iommu_get()
Thread-Topic: [PATCH v2 05/12] iommu: Change the return value of
 dev_iommu_get()
Thread-Index: AQHZwE5aOEc+6ikxPE+EMdq5oUz2zq/YPxrQgAFCqACAAAuKsA==
Date:   Fri, 4 Aug 2023 03:55:30 +0000
Message-ID: <BN9PR11MB5276C53EE399D9C0AC05EAA78C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-6-baolu.lu@linux.intel.com>
 <BN9PR11MB52769A468F912B7D395878ED8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0866104f-b070-405c-da27-71a138a10e7c@linux.intel.com>
In-Reply-To: <0866104f-b070-405c-da27-71a138a10e7c@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7726:EE_
x-ms-office365-filtering-correlation-id: 4b5199f2-6269-422e-a421-08db949ea55e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 52e3GTMZ4DthngYyi4F9qlzlBVcghrnA2Loae6p75iH0r9eM8X0iXwfp8uXext96v+Va4y2Yik4VgGK0w8adb9X6leFoiyb2yImmKgMFjlLU+qR9WPDfmeNgG05JD/67WWA+4mbXHlil/oyMMUwNLxahIxDRAnUCcfDENaqgfRMUc9eupno+HW3h7ceKmP19u5Q8Iv9hGDQFTjZ1mXyXRAOZkircWX08fEI3itNQHFRbcKTMS0s6Gm+psHlB6nfOGaWi2q7mKMdU+KGzGFeLbE2nkg2ovL7lf+/baNDhjiPr3dpGR6GHMAJsfVT8PWhCGHHHn/tXB/A3hBAdGps5m4Vsa5QRWXtYaXjZq8qgT23oNWbD8ZB3nK7xqr8MDL3rK1w3sBciqpOoSyU5a6BJ0aaal2Yw8mTNpdV6SbGvGNnu32Sxmm1dXuJj6nCwOzfpceGj3uK7Jv1tw2/ZBpKlonj6KxuEwl+OrZ/veFNtkRyCC+PcN1lwvCwdy4Kn/Co3W9CyfSz2EwyVD2bVpBm8p87fo+U5fVqywKHO2IZOzVNclCfsjWyCq56Pciwa+xNOA4+Ta3DJjCVb7+ge1uyJaOWh70cokjGSP2hGmnzoKvfgRA2UwM7FS+mjSA+AhYPoeEy06iLGFfOqi788x3eu4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(39860400002)(376002)(346002)(1800799003)(451199021)(186006)(53546011)(8676002)(26005)(6506007)(83380400001)(66476007)(2906002)(316002)(76116006)(4326008)(66946007)(5660300002)(66446008)(64756008)(66556008)(8936002)(7416002)(41300700001)(966005)(7696005)(71200400001)(52536014)(9686003)(110136005)(478600001)(54906003)(55016003)(38100700002)(82960400001)(122000001)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzRNaVpzaHVZRHFxZTRxUzhTdG9JRGY2c0g4K2VZNFZTM0pGRWNQOG9kakYw?=
 =?utf-8?B?SG5zQ3pTdFBNVlpQVHcxWUpWYTJyNEMwMWUrUmhBNVVpMnNrREpINlFUeUFq?=
 =?utf-8?B?ZnZFSTYwRURvTGw3dXc5SFVySms1Q0NNMC9KcEtxd1B4cnYrbCs3OFQxd1lB?=
 =?utf-8?B?SnBoc0hhRUQzQ3dKeGcySzBuUVQzdVcrV0ZxNzJsempubTJRT2V4QWNIMEJE?=
 =?utf-8?B?dlRXSm9VVU4rcnF5SW9MQTZVWXYwbHFwU1FOQ3hrVDNxL3hSK3Y4bTIyYTA4?=
 =?utf-8?B?NUZ1bHBxOGdEZVJNUVFSaVBUL24rQ2VEYnZTNEUveWFPU3l0K3Zla3hsZjB5?=
 =?utf-8?B?THlLWU1TVUsyWnBHcks1SjRFRGZlOEZBNXRxNDFJVmNIZUZBMm9lLzZCdlA4?=
 =?utf-8?B?dC9NRHE4Z01OVEwrWkxyRzI5TWtmcFczWG5YVFBpcGl0b0pTNWVkOHZyS1lj?=
 =?utf-8?B?U0M0blI4cFVVeHFTOEJvZ1Q5V3RDNndjd3pQcCtwQzVFZWhXREdRZjk3OHZT?=
 =?utf-8?B?TUp3WWliVW83cUhBa2NENjZGMnJVM2Y2SGFSUFplVDBOc1Qvc0hPWmw3UzQ5?=
 =?utf-8?B?bVFhWHc5N0NoR0dyT3l3V2wrVEFFZFVCWUUyUlFncVFjcnlBTzNON0grS0Zm?=
 =?utf-8?B?QUs0L01OdEZ0dkUyQ1RhKzBhRlpqMkx1ekFoRFRLUy9JWllVMlhRNWkvazNh?=
 =?utf-8?B?UFF4OWNHUGtKSTZLMzYwNzZ1UkExYTdHRnpGamE5NGhhZzVsbGEvVmRKM01l?=
 =?utf-8?B?U2FhZEVBTVJ2REtkeVc0eFM2VEFwcVdDR1dxTVNKcnZlSDBXU0FEV1J6OUtG?=
 =?utf-8?B?NStiRjh3UCtsYlQ2NUZKV1RBUEdmd2hrSXNGMndLSkt2dXRJNGJ2K3RZd2Mz?=
 =?utf-8?B?eS9tRnVrMzJBNWJDU0s0TDBwUTgzdDFuUktwd0ltaXQvNDNxdGRPTldpbC9W?=
 =?utf-8?B?NTVJa2RuZ2ltaXZ1UW5lOWtRYUdVNW5iL0c0SjFJMHFSdm1kRHIwUCsrT1FD?=
 =?utf-8?B?UWR3Qzd6Z0NzdlM1VUQzTkNzVUYxdjZhK0NQQWdaL3dWVmtkWGhKVXl4S2hl?=
 =?utf-8?B?Q3NBMFVwMGZUTW9SSVowLzM3WlltUU9yOFo0ZUdqVUYwSW1FR3FVWEY4N2tv?=
 =?utf-8?B?ZElBdkFYdVZRRDkxL29xUm1IOGwzL1hZa21BYVBBVzBDMFpuMVA3Nnhzcm52?=
 =?utf-8?B?dXN2SStJN21uNCtLem0reXp4QmZ0NEpMQ3FRR1U1UCswbUFtMGdKODVybWNQ?=
 =?utf-8?B?QVZqVXdtbVdCbFFHOU1yRFlYeFdBclI2TUpqcEY3QjJ1Yjg3QnJqTUtndDVY?=
 =?utf-8?B?aDU3dUFoVnZiY3ZCazMzUHJLWERCSmdnOERNK2Z4Y0p0RDZHYi92R3JYSHZk?=
 =?utf-8?B?U1N4Z0NQVDBHQk45NnlrVllJNnhCajVacGhkMy9hWmVPU1BoNTl4NU0xUGIw?=
 =?utf-8?B?RkFRdUdUSU91VVVTM2NFWUwrQ25LbHhGenNFaS9qM3BnR0ErWDl1a2xCaGx5?=
 =?utf-8?B?RlhZVzhXcVFEL1hTd0djQlRXaStTY0hwNVd5NmVUa0xham82STBlRU1NYUR3?=
 =?utf-8?B?WlJEK1VLVVdBNjA5cDlWUDFLQzcycnJ4cHRtVU1Cd0FHN0VkQzNYSTExV3BZ?=
 =?utf-8?B?OWgvS3NiTGJhL3l4a2lZWm14VzhscXVDYWdidlN3SWtvQ1loUzR4Q0dGMnB0?=
 =?utf-8?B?U2lWM3VjZEU5Ui9qNzdaM1VpTTBuL3o1NlRJSHZQTllScVlGSzA3NGZsUDlr?=
 =?utf-8?B?SVF1YmQ3ckxJTklzMldWakRqYjNqV1FQZDFzVTR4MmM2QW9hS1FBbUFNUi9k?=
 =?utf-8?B?TXZDSEh3S1Y5NTVuaUdpMk5Icm9FWDJMTEkzNVowL3V3RmduQkF0dWQyWkNR?=
 =?utf-8?B?dFA1NHhJQUpLdUNlY1M5REZwSGxVUk4wejFxS2dobFB6OHR2ZzZ5U0ZnQnE3?=
 =?utf-8?B?clordVRaODlyTjJIclRzam5yTGVwb0FFdkNDb1JrZHhMQVdpWENzVno4ZW1n?=
 =?utf-8?B?S05iRzVORGNtTlJGMjBvWEQrRXVzZEJVNHJzNE8rMFNnZEtjenhEN3dpZURZ?=
 =?utf-8?B?YlpFektIMWx5bGhsd1cxbXVwNVQzWGVQSFBlMlFnK0RVd1dLbXl3WVpicVJk?=
 =?utf-8?Q?tbEuFeSpU+pWd/HL1DPVgofWp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5199f2-6269-422e-a421-08db949ea55e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 03:55:30.2811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +C6Ij7D55bPAWpel2Uq3v8enM+07eESJc1/wA6BrjanMht5PSG5qI6bdq3QcRuuZ70IK8dDuKR+WXOOuP90dog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7726
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBGcmlk
YXksIEF1Z3VzdCA0LCAyMDIzIDExOjEwIEFNDQo+IA0KPiBPbiAyMDIzLzgvMyAxNTo1OSwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRl
bC5jb20+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDI3LCAyMDIzIDE6NDkgUE0NCj4gPj4N
Cj4gPj4gTWFrZSBkZXZfaW9tbXVfZ2V0KCkgcmV0dXJuIDAgZm9yIHN1Y2Nlc3MgYW5kIGVycm9y
IG51bWJlcnMgZm9yIGZhaWx1cmUuDQo+ID4+IFRoaXMgd2lsbCBtYWtlIHRoZSBjb2RlIG5lYXQg
YW5kIHJlYWRhYmxlLiBObyBmdW5jdGlvbmFsaXR5IGNoYW5nZXMuDQo+ID4+DQo+ID4+IFJldmll
d2VkLWJ5OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+PiBT
aWduZWQtb2ZmLWJ5OiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiA+PiAt
LS0NCj4gPj4gICBkcml2ZXJzL2lvbW11L2lvbW11LmMgfCAxOSArKysrKysrKysrKy0tLS0tLS0t
DQo+ID4+ICAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0p
DQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2lvbW11LmMgYi9kcml2ZXJz
L2lvbW11L2lvbW11LmMNCj4gPj4gaW5kZXggMDAzMDlmNjYxNTNiLi40YmEzYmI2OTI5OTMgMTAw
NjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvaW9tbXUvaW9tbXUuYw0KPiA+PiArKysgYi9kcml2ZXJz
L2lvbW11L2lvbW11LmMNCj4gPj4gQEAgLTI5MCwyMCArMjkwLDIwIEBAIHZvaWQgaW9tbXVfZGV2
aWNlX3VucmVnaXN0ZXIoc3RydWN0DQo+ID4+IGlvbW11X2RldmljZSAqaW9tbXUpDQo+ID4+ICAg
fQ0KPiA+PiAgIEVYUE9SVF9TWU1CT0xfR1BMKGlvbW11X2RldmljZV91bnJlZ2lzdGVyKTsNCj4g
Pj4NCj4gPj4gLXN0YXRpYyBzdHJ1Y3QgZGV2X2lvbW11ICpkZXZfaW9tbXVfZ2V0KHN0cnVjdCBk
ZXZpY2UgKmRldikNCj4gPj4gK3N0YXRpYyBpbnQgZGV2X2lvbW11X2dldChzdHJ1Y3QgZGV2aWNl
ICpkZXYpDQo+ID4+ICAgew0KPiA+PiAgIAlzdHJ1Y3QgZGV2X2lvbW11ICpwYXJhbSA9IGRldi0+
aW9tbXU7DQo+ID4+DQo+ID4+ICAgCWlmIChwYXJhbSkNCj4gPj4gLQkJcmV0dXJuIHBhcmFtOw0K
PiA+PiArCQlyZXR1cm4gMDsNCj4gPj4NCj4gPj4gICAJcGFyYW0gPSBremFsbG9jKHNpemVvZigq
cGFyYW0pLCBHRlBfS0VSTkVMKTsNCj4gPj4gICAJaWYgKCFwYXJhbSkNCj4gPj4gLQkJcmV0dXJu
IE5VTEw7DQo+ID4+ICsJCXJldHVybiAtRU5PTUVNOw0KPiA+Pg0KPiA+PiAgIAltdXRleF9pbml0
KCZwYXJhbS0+bG9jayk7DQo+ID4+ICAgCWRldi0+aW9tbXUgPSBwYXJhbTsNCj4gPj4gLQlyZXR1
cm4gcGFyYW07DQo+ID4+ICsJcmV0dXJuIDA7DQo+ID4+ICAgfQ0KPiA+Pg0KPiA+DQo+ID4gSmFz
b24ncyBzZXJpZXMgWzFdIGhhcyBiZWVuIHF1ZXVlZC4gVGltZSB0byByZWZpbmUgYWNjb3JkaW5n
IHRvDQo+ID4gdGhlIGRpc2N1c3Npb24gaW4gWzJdLg0KPiA+DQo+ID4gWzFdIGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2xpbnV4LWlvbW11L1pMRllYbFNCWnJseEZwSE1AOGJ5dGVzLm9yZy8NCj4g
PiBbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtaW9tbXUvYzgxNWZhMmItMDBkZi05
MWUxLTgzNTMtDQo+IDgyNTg3NzM5NTdlNEBsaW51eC5pbnRlbC5jb20vDQo+IA0KPiBJJ20gbm90
IHN1cmUgSSB1bmRlcnN0YW5kIHlvdXIgcG9pbnQgaGVyZS4gVGhpcyBvbmx5IGNoYW5nZXMgdGhl
IHJldHVybg0KPiB2YWx1ZSBvZiBkZXZfaW9tbXVfZ2V0KCkgdG8gbWFrZSB0aGUgY29kZSBtb3Jl
IGNvbmNpc2UuDQo+IA0KDQpJIHRob3VnaHQgdGhlIHB1cnBvc2Ugb2YgdGhpcyBwYXRjaCB3YXMg
dG8gcHJlcGFyZSBmb3IgbmV4dCBwYXRjaCB3aGljaA0KbW92ZXMgZGV2LT5mYXVsdF9wYXJhbSBp
bml0aWFsaXphdGlvbiB0byBkZXZfaW9tbXVfZ2V0KCkuDQoNCndpdGggSmFzb24ncyByZXdvcmsg
SU1ITyB0aGF0IGluaXRpYWxpemF0aW9uIG1vcmUgZml0cyBpbiBpb21tdV9pbml0X2RldmljZSgp
Lg0KDQp0aGF0J3MgbXkgcmVhbCBwb2ludC4gSWYgeW91IHN0aWxsIHdhbnQgdG8gY2xlYW4gdXAg
ZGV2X2lvbW11X2dldCgpIGl0J3MgZmluZQ0KYnV0IHRoZW4gaXQgbWF5IG5vdCBiZWxvbmcgdG8g
dGhpcyBzZXJpZXMuIPCfmIoNCg==
