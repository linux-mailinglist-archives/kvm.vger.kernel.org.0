Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8755976F884
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbjHDDw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjHDDv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:51:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2453C30;
        Thu,  3 Aug 2023 20:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691121118; x=1722657118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RjgGLudN3uvTA5WX8VHbpsUub314WKXlyFrp0LOWDU4=;
  b=hnyuVCQwpTTusn7NrLMDC9xeEfRNLV9ZVChZY/3yILTGRHOK8uGuM8cA
   yMvi4kM+SRXG35exuOzJ5+unb97GfwiOgQOsyHdubgq8UsQO7Cig2+RkD
   dZRtP6Jwz2YAL7QvH2G/FYI1cadfZpLVBpuWkZLYEs+Z9eM5D9simQA0M
   ympOJ/QTOMT0mD5yJqAx3mbwe6c7nE3hVAPcGHtZpEJSjQXrMktCdmjoN
   Q9mWzJh3KncQokO6obV+W1oRyxR32ssKZL/0UboHVcH6QsRJVaPLAv2JG
   grWRLKvnXEhoGj4pDl/hizj/oMCwuZWPdMF48lac8VE5G/6klVZVeD1Ip
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="373701733"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="373701733"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:51:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="819948490"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="819948490"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Aug 2023 20:51:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 20:51:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 20:51:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 20:51:37 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 20:51:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiWUacZdx+nPEzD4RhQkqk7G9+4QLgEqkqkSHcBeqlAbTxzDkRBVRbOeQIS3S0kZPTtI+SYtb4t4crKqpdeo61wMgkp2PkxVQl7P7cWc8+voNKtipYC2F7Qa4gqeQlW8NXX35ePKUGqtdlBpRrbeYBatfB7RHt6WAgRMhGdtOLYHvUhoGo8ukteR5p2H8j2geUnuQxEjnOU59fVx25wfranJVrLOtlGFTWwDI6WtbyYRsX88w8ZP6ON/T/ylDSs7wiFRR0owjuWl9e3mp08dT1U4D0YVC4Q11aoefChJHTth1LZO+aTm92SYh3TrU3e6SGnkiUqtC6atBKl4bm7iWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjgGLudN3uvTA5WX8VHbpsUub314WKXlyFrp0LOWDU4=;
 b=NaUwge91W7sIuN73Hb7ljchos24a4aAzTe7vGPYZoHoCVcriEX8efci1eutV5gvo+hVlRkXFqCF/7jPg1yVJbrC5P+aQeasurk8YAtndoEW/lxUCUp4e9T/JEW1xSG5OnkTnbWTTaCGdKxVj4kEmyL9IurKWG3woh1Oe7/PpKoA7U12I3Qir4zRY4CNIwxZcONG9O2xsb8WJALasANTbXG6yloTZMCSqT6QkMx6PbCMd+YT9uccvcAkJ9OWMgJ0zTMLsghA1y9tYLpnjdOK1zOKPzvZPobzovyU2Ov+vdtFhiXTZ/+m2VPOaHWG2Ro97QGcZ0PoQFtEQupoG/IXeGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7726.namprd11.prod.outlook.com (2603:10b6:208:3f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 03:51:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Fri, 4 Aug 2023
 03:51:30 +0000
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
Subject: RE: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Thread-Topic: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Thread-Index: AQHZwE5XwmTCizFL9kGoEloX5eLFx6/YPsPQgAE/24CAAA6WQA==
Date:   Fri, 4 Aug 2023 03:51:30 +0000
Message-ID: <BN9PR11MB527614E61BC257FE113EFE358C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-4-baolu.lu@linux.intel.com>
 <BN9PR11MB52767976314CC61A0F8BEFD08C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <faad1948-5096-c9d3-616a-cd0f0a4b5876@linux.intel.com>
In-Reply-To: <faad1948-5096-c9d3-616a-cd0f0a4b5876@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7726:EE_
x-ms-office365-filtering-correlation-id: 46344314-79b0-4bed-586b-08db949e165d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S9zj6ZrPhHvFle2bL3GM8eJjFdQ20C5aDPr0DWhkxP271T+IRX4qBOyGWbALRg6BKKssdBC5RScueJs39FOpOXSbRcwyOKggOVQrrNtHLlwYViSeGRbTU42VV7cKbFPGBpUWMb+YjRKoQ5H8CmvPvF7JbhZDfnWxqjD9K0ZgmfRQBgdd0a+gyGbjy4qA5VtsZLlVkpv1PH18GSqCAKZgs6dFX/K7d32R68vcQLJ/3TEGuuMKhileTo5gDCm5QkAADGIZ8NTCV/lo5+w9+VbCVMxSfP/CzMtJl3zPdxfOXY4smQSzxULbEPQZmecf2iRIQXWylb/vctNfZ4sCKgeSe1m0W03nhGf3yjVm6cK+FdyFOp+jcLCdKJo17z0SHJ4xmqlONcQtfRvEs2hQB1E9GSoHDmBp179CLyXNWmtr8ndHVuiq5NfM5rVTcY95WiymeWG1mckBrtycIE98OThyvxy4nf8AYyrTvPjc9z1dUs3nQ45nsavNSv/hvPLvoJDI7ZgzLbUWARRfnWxivkS3HzGk1V5iniJiXqgB49BWWP4PZJ8Sx8cig4T//gIVX4WuIkamFBcY+gjBnICcQN8JfNfXSnvCwnwiImS5tzl+b3h5UrTf5DpfzkCN0ksSu9GO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(39860400002)(376002)(346002)(1800799003)(451199021)(186006)(53546011)(8676002)(26005)(6506007)(66476007)(2906002)(316002)(76116006)(4326008)(4744005)(66946007)(5660300002)(66446008)(64756008)(66556008)(8936002)(7416002)(41300700001)(7696005)(71200400001)(52536014)(9686003)(110136005)(478600001)(54906003)(55016003)(38100700002)(82960400001)(122000001)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0V5L1RWekN6dDlVRjUydDVTOHpXdmtMUTc5UEsySkNVUTFBZkczcVJWMm5r?=
 =?utf-8?B?aWhXdjd2WmdCY0lMUEIxVkcxbktkZjJsK2ozY0RCZ0ZxcjM1NkVuRVJ1WDlw?=
 =?utf-8?B?SlR3L05xWDBqdlBUMlhZaVhWbFRCNVp2S1NGZW9xcXZ5UWtMUDBpdmlUY2tD?=
 =?utf-8?B?S2tJVEc0MGU3dUJ3azJCOE9wWUJVOUptWkIvakRvelVQRmovQXU2SDc5dm9S?=
 =?utf-8?B?aGNEK043YUpzcVpNYWpSUTJvaG5LQ29Wd0VYKzZRT3RYcllWNm9ydWZEbFRP?=
 =?utf-8?B?WkJPNEJqa0FvVTJ2angybkZDcDNHU1dFMlFtRWdYWnpJcHNNYkN6c29jeUhI?=
 =?utf-8?B?Y3JEeUNMaTV1Z2lsbWRsMnZYUFJ1VEVVd3Vudk9qZ2VLMTQ0cnIzRy9aRWMx?=
 =?utf-8?B?Y1RDdjZ1ejlBQU54WHFhcnhCaXB0US9zTWpJZ1l1L1htQ1M0aFpWTlI4RWFR?=
 =?utf-8?B?U0tBQmZIaHpVbEtqTWViSXFYQU1xU3pIR2dHN094cHdnWkxyVy9PTURsYldH?=
 =?utf-8?B?b2xDNk54VjFWK05xUmQrOWh2MVFwZE5zNE8zVCtjYmlnZjNiRWhzRXBRY3FU?=
 =?utf-8?B?UFR2K0Vka0JFKzQzK1ZvYW1JUjFnbGN6Y2J1Y1EvTk95Kzl3MzJtTW40MXpE?=
 =?utf-8?B?dEJGWHZ0OU92WkNsUkNRazhoYWNsOStxejlrUWRVUXJONnhjTUFYTlNtTUlp?=
 =?utf-8?B?TTB2RmE3U0E3Z0xzV2pOMjAxVXlJdyt5cUg5V0NGVTVBNmtGaVhra3V1emc0?=
 =?utf-8?B?b3ZPOW96eDVNOVp2Mm1zeWxOdnVJUU1yOGl3eFFvVjI2ZG9PMU9TVlkzVWdu?=
 =?utf-8?B?aS9rVDNFalhhMFFTVWtCc2FEb1FjVFhIamJ6NWNZTHRyUW9yUXFRVm5wZVRN?=
 =?utf-8?B?ZXNjamQvTjRpcllBUlI1dVVaNkxqSE5ObWJUcXpyVWgveEg4a3J4MG5PbXQr?=
 =?utf-8?B?aXh1bzRSckpobllEZURTcnVONitVTE5kcHplc3pveXFFckJGUExVQmlsays2?=
 =?utf-8?B?M01GUkdFSEZDUXdLZURKV2diMC9GSnFXRjhyekNmL2JRQTJIRXllcnEvTGkz?=
 =?utf-8?B?eXk3ZUp3YnpRdXNCTnZQOEUreS9sSFowaGZsOEZoNUw0QlVjSWtlTlBVOUFS?=
 =?utf-8?B?ODYvaDBnVjNDdi81cklzaTF2UXJYV29oVFBXaFpuYmRMTXJOSlZrMjdVRzcz?=
 =?utf-8?B?bjd3bVlaZXB6UndBRXVFM0l3cjdYRGMyaVJyRjVnSEp6LzZGNkgyYjN0MTRJ?=
 =?utf-8?B?NnFJdGwwTVpSUGlkZ1hKSElNSDJxVktraWhLUk13b0tPeStjdmR6c3FPZ21E?=
 =?utf-8?B?ZjBaUk5FcVd0eE1uY2dPZDNQaHhlVW5LY3pQMzkrdEhXTllKZ0o0UisyVUhy?=
 =?utf-8?B?cS9WK3RPc2s3VTVPb1czVU9CU2dOaFdyRklBZm1ReGZmRkYwSS92SjBITzZP?=
 =?utf-8?B?UTFWd0k1d0huN1E2ZVJTOEJPeHBQVGtzM09McVRvVHpNZXZBbEdObEJndlNs?=
 =?utf-8?B?aG5ZNHpqRmtVWi9Va0hNVW12US9DTlVkbUN0S1NmZzRhMko0KzNQSXg2c0FR?=
 =?utf-8?B?R2NZTHdPbEFQanVuN0pkOE94Y3JHdW9ON3ZSenRQKzZ4NEc1K1h5dGdxdlNu?=
 =?utf-8?B?NCtYL2hkR2VMbFQ5bDR6ODFZYjVvQk9xMUJBSlR6bTFGWDlZc3Z3Y0E3QzNV?=
 =?utf-8?B?MWVwY280RFRVM0xJSklhVWJXNmtDZU1sVVBjMGNCeWV5MVoxOU45L2t3RTBM?=
 =?utf-8?B?QXd3MnJlQmQ3d2JWakR4bEV1czdueGJEOThVaVdLTjNTejFYcUl6Z21sWkl3?=
 =?utf-8?B?V3FPMVFoNittSW5vdmN5MEdDUW5SdVo0RUNpc0FnYzF0Wlo1SThXS1dQV2pG?=
 =?utf-8?B?OFVwTkM4RUpla0NKckhQbm1MWlFSbG5sdW1ZZlZweW1TcUlJSkloZEoyeHlK?=
 =?utf-8?B?U1hYR25qd0RqSUlrNWpyazlnRXlPQm0wSXpkeHl5L1E3UXVObmlUMVNsNEN2?=
 =?utf-8?B?UDNjYWZyK3c1aXN1cDR5YnM1Q1pVY1FaL2tiRG94MUxKaGVvWlVQem9qa3Nv?=
 =?utf-8?B?bTh2dnVJWEg1eHloMTNSalJlQVY3TlAzSFNWMVlJdURzVGwyZEtqdk54SWxl?=
 =?utf-8?Q?S18X6XYTK0nNkUYiEHzGr3Mgl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46344314-79b0-4bed-586b-08db949e165d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 03:51:30.3402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oiVX+x3KUQQZVPY0VJ/iAa0V2gfUR6F0F7YWHXkcDe0Sg1S+4rwC5YO7SDvq8YsnCL8p94/89DJWoe9SI+QU7g==
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
YXksIEF1Z3VzdCA0LCAyMDIzIDEwOjU5IEFNDQo+IA0KPiBPbiAyMDIzLzgvMyAxNTo1NCwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEx1IEJhb2x1PGJhb2x1Lmx1QGxpbnV4LmludGVs
LmNvbT4NCj4gPj4gU2VudDogVGh1cnNkYXksIEp1bHkgMjcsIDIwMjMgMTo0OCBQTQ0KPiA+Pg0K
PiA+PiAgIHN0cnVjdCBpb21tdV9mYXVsdCB7DQo+ID4+ICAgCV9fdTMyCXR5cGU7DQo+ID4+IC0J
X191MzIJcGFkZGluZzsNCj4gPiB0aGlzIHBhZGRpbmcgc2hvdWxkIGJlIGtlcHQuDQo+ID4NCj4g
DQo+IFRvIGtlZXAgYWJvdmUgNjQtYml0IGFsaWduZWQsIHJpZ2h0Pw0KPiANCg0KeWVzDQo=
