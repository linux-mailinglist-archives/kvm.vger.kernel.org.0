Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526E878F754
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 04:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348197AbjIACuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 22:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjIACuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 22:50:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583C2E77;
        Thu, 31 Aug 2023 19:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693536636; x=1725072636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3+8JPClrbkZUADfKepSAZY/KGQYAomV4/0vasN1MbT8=;
  b=kqJq5vBAADw4revQ/KvgxDeDpYy7jRvcGl1kCne2HK8oFNzxkaZozkZh
   LlUnycoP9iFa3326sclsmWyOlzJ7GaIUi85sMyKW6H1dyPlZzSxxX8ZC5
   rlSuCVKDQYI/CJQG+bxjkPqcC5BiJ/L9PmN6B5ba7BKHjsnusP3n9DchR
   RD0J8n057ztSu5Id/slnHAN0GbBsREx3z57cEiESZOVVRG/AFkrY4zAB+
   RIWnk2U5aLAQ6zTZLjCIgnXwSTDidF10Xs6xOXZxxaEYmx4598964lrTM
   ebNqfeYI3+v5e3gGhXBIJWzSB46MCh4mD4Z16LBmX7LY/7w9iLLfiIjsi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="407115413"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="407115413"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 19:50:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="854529321"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="854529321"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Aug 2023 19:50:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 31 Aug 2023 19:50:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 31 Aug 2023 19:50:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 31 Aug 2023 19:50:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 31 Aug 2023 19:50:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdtxAQWzUe/IbCUGD3enczehS0+bfvoNx/aZgMiwDkbe8L+zfxdlpsuQrpDFD4iGv19T6PAFRUOYoyT6uE1laCDBuMGowRqOM6QmZk0h1BBSLW84qvOzAarVDs/s7Ig2qC9Cbwcq+rB4hTqmNqNhHe6kKlWywGusV53vz0XshydX+OiS+uEX2yiI5PGlBSwuZxMceUg1xPNA0KkIpoYFa3XZMCOY8u+3Xs7qHMUOHL36n7kyglVD6AdJp7g5sCRf7PX8gQ6tipW+/YgcTVSK9FwGv7HIDI98sfLUMKdkZGwSAgsQ48iGxo3SVXWUsZaja2ope0/J84N7xgS/Pnw4gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+8JPClrbkZUADfKepSAZY/KGQYAomV4/0vasN1MbT8=;
 b=P5hbhYqOhMvV+rckpgabFX14PRdaC0YXUrXWnEiIT2ycTPXd4FNDuj7lbas/QtWPAAVZB9lCxgnqijovLbBDrtdNtA4F5YaeQREqC3MVnRxIvhVSBypjIo7zcNUwhj3Wne3PPT5WBZGQFT4LAO04XXvTLjYSW9d0em8PbXMW7N8uXmeSzp5JmhAG1pBqIBx1LR+mDFBFPkuc/0Z4iY9S4CVmFiF0C0dwi+09ciJ4sNIz2soA4D3smx83sJBXjU30/mSSV7I0DRdxDpB+AsEWs3bp6MqisAdmrnoOWB/b1qlUhcfDFFXCAG2zazdR9mlORSQVWxtlUKhR+63xllKzxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CYYPR11MB8360.namprd11.prod.outlook.com (2603:10b6:930:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.18; Fri, 1 Sep
 2023 02:50:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6745.022; Fri, 1 Sep 2023
 02:50:21 +0000
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
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGR2gCABkO3EIABz/QAgAECbfA=
Date:   Fri, 1 Sep 2023 02:50:21 +0000
Message-ID: <BN9PR11MB5276622C8271402487FA44708CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cfd9e0b8-167e-a79b-9ef1-b3bfa38c9199@linux.intel.com>
 <BN9PR11MB5276926066CC3A8FCCFD3DB08CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ed11a5c4-7256-e6ea-e94e-0dfceba6ddbf@linux.intel.com>
In-Reply-To: <ed11a5c4-7256-e6ea-e94e-0dfceba6ddbf@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CYYPR11MB8360:EE_
x-ms-office365-filtering-correlation-id: 573af87f-3693-463c-7417-08dbaa962f10
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fHcXq1ZKkZl7rUcW/fX7JtkSGSzDKTpLtzBrloR1lRMH0WN+nZxzXBiiSHuvP6/k5/4MmU9ON0p0AghRJ3I771y9VNCmcikMJRKyZ679ntsMECrLwZ/zGnir3rjCkIKWlGaNZtNI5idnk0IyEyim3DxwnEJtxN4XHpFB8dhl81BPxJUY9AHY1gLl7Ro0Cw7kUZ1nCMoJUBZCMiLBK330zr04LMRRKPA9KPIsV6U7lhMSKgivbKZEn0UB6Dl5Po2Bp8nn8WILjFq4Hur2ooAUuuBBn6EZ3sbtWD+8qXXxCWj+ZwbkxXK+yN//nKYnPrSx/HO4QKI6K1c5i0tRq4NyuZ04nQ3FgWXAJaASzlZeMypmd4a3smtdA5O7k228AHRtre1/AMjQH4E98nSiq/3FN8i87RMa4/4Tv2ebYd4goYRzlhPC1Biciq2xgCX3A+xm9EQPiR99x+G7CtkUnB+W0w2S8FtwL8CvRjrbzUZZuRmlU7l9wC9vlfggXS8vZUNyaFqEyT3ou2Q/kTcw3/hKO8Q8K0t778wssX5GBpdTo625w4/tVJ2oMlwMUaleMtkTRYktrdXlF7ZF9/ZTeP0hmRFiaROPgRGPnGZHv6N9tw6/2ChB9/flGB+9K6NoZ78KPMcgbzeTeNYZ89hr7697rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(346002)(366004)(39860400002)(1800799009)(186009)(451199024)(8936002)(76116006)(478600001)(110136005)(53546011)(122000001)(66946007)(7696005)(66556008)(6506007)(64756008)(71200400001)(66476007)(66446008)(54906003)(38070700005)(316002)(38100700002)(41300700001)(82960400001)(9686003)(26005)(83380400001)(5660300002)(55016003)(2906002)(86362001)(52536014)(8676002)(33656002)(4326008)(7416002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2RuQzM5bzhuVzlnblFrQXlqczZDRXZWM3BMWERaMXZGQlN0MzBMMlpwbXB2?=
 =?utf-8?B?ODk0QTlaZm1rYnNLRWt1MW5USUZkb05xNmVKcE1zZXN1bWV3bUx6Y0xQaHhs?=
 =?utf-8?B?VWRaU3ltYWE5Y1AwV082dEhEczJWNGk5NWMvUEJtRXBic3kxZXJkdEpZbFF5?=
 =?utf-8?B?MEZaMHpYQk9qNnJOK0dqVGV2b3VHWGJ0S3NBbHBna29DSXIzVXlybCt5UGpH?=
 =?utf-8?B?ZGIySGpDM0Ryb2RyN2dXVWpjUVlSbEZRM3dyMTJOajloN1ExYnRhd1ZGL1Fo?=
 =?utf-8?B?ZXVFaElCSHJSdkFLWlIrVGxCRklmN0FnZDZLY3J3ZU1CSUkvUG5DR1J1U1Bv?=
 =?utf-8?B?TUVTZm1Wd2hXd1V0a0J5REhVK2dTMm1RRWwydUs4WVJXcnRpYVN4dXFFWE1o?=
 =?utf-8?B?M0FvNEhiVzc1TEZaSnpLN1lTZGFweU9oUXY2MGEwYy81ZVdVcGxzLzlyUVJ3?=
 =?utf-8?B?cnpiNlVwTlNlTjBKWkpNc3laOGxMRjZOQitSQzVCMUNQNXViZm0rT1RxT1A5?=
 =?utf-8?B?VXBldEhNZlNHcUtyR3M5RkV3ZVg1cXVQQWlPUC8xSXhvRWEwd2NGTHlHbFYr?=
 =?utf-8?B?clMwNkU2V0xLQ2JsNGMzWUVPaW5TTzJGS3lCeVQ1SjQ2OGlzUk9sVitYTjhq?=
 =?utf-8?B?Z3pBcW8xVjEybWhjVy9xa2RsaThOSW1iMGJ1and4Zm1GTTlqSitGaStsS2I0?=
 =?utf-8?B?c0ZEUnFXZkdkTFdIejRqMVVPK25XZjlVL1EzOWlqbmdaT1pkTXBmWmhaOXZa?=
 =?utf-8?B?Q0tHQzFGWng3WUwxZk5EZlByQkJUMkozRjBVY0pIaFRlNjRJSm5JaEdQUm9l?=
 =?utf-8?B?bXFnQkhpNUFjNWp1U0ZXQnUyRWRnejNQeUxsdWNSWERFR2xwNlFUeWRsRU5M?=
 =?utf-8?B?YTRvLzY0Z3hiYkUzMVlYSnBWZDdqVXpXWDFkdzBRKzJGK1NQNVFKMXA5ak0x?=
 =?utf-8?B?Tk9LWmdGRlJVNlJTMDB2dm9vUWFmUzk5V1JtN3RWVWpza3V1MkdiRjhHNVNq?=
 =?utf-8?B?UFRHRmU0eGlnVmtUeWl4a1o2Ukd4cnBPTWxpY2ZXOVhlZkRsZ3JGZXc1dmk0?=
 =?utf-8?B?ZzFWY2RUS1c1K1NhalFKZjlUZ0pONk5VRzZTMEUyUG1HQ3pTUnpic29kZnNR?=
 =?utf-8?B?SDkyYTQ3THRldlFKSURrdUdKby9SRUZsdmdGRDNQa2hVOUVwNmhBTEVxMGN3?=
 =?utf-8?B?cHU1L0swUHBzQUttVlV0T2lQd3FRRURFaDgxMkk3TVJ4M1N1aTRuSVViRWRF?=
 =?utf-8?B?MFFDQjdxOXNqS0poaktNdzhIRXE2L21XcWIyQmN3RW1EUnFtalFJaTFIUVBw?=
 =?utf-8?B?dTdNWExOdjdHNUUxelNrUG1VRWN5ZGRMMFlONThGbXo2aE1FSHdvYmU2d1FC?=
 =?utf-8?B?MXdKZmFQVnR2ZUNJWlJKZFV0QnBjSHVnbFV6R2hBdGhBUDJXUmhTaitucHJa?=
 =?utf-8?B?Nm5DMTR4V0Vlem5PN3hjWmV2K1E0UUd1T2NCbmF4WEVuMjYvdHJrYUp6Ylph?=
 =?utf-8?B?VC9OL0thVTFlY0dNNUsvNVJ2UjVxcDNaODBPcjRndWk4elRwSlluLzk3blhK?=
 =?utf-8?B?N2lYM0VIbmlZRmR1Q2FIQmRHdTI4SVVQVFZtSzlqekxzREJRNjd4YWdlZ1NN?=
 =?utf-8?B?Y25ndUU1WTlJdDRsUmR2TkQ5ZWIzWEhYQjNCOVU3M2diazJVbG12REpyYUh5?=
 =?utf-8?B?bnB4NnVzZ2t5c21VakVNS2VISXdncThwblFOQXZxSXV4REFQL0JQRGhpKzU5?=
 =?utf-8?B?TDRGME1GUHYzb3pBWHc3M3dDeFRIbHV3MkxQaStid3Z1aHVRdGpqVGVhLzhv?=
 =?utf-8?B?cHl1K1liQVpaWURrMWdoaFI3QVIyb0YyVUxodUN6cngwS3dxeUhnVzdkV25q?=
 =?utf-8?B?OC96N1JzN3JkKzlTWjU2VkQ1eFV2d3JuRHJkUm4zQnR4amZ6WGs4eW5nVEYr?=
 =?utf-8?B?V3pDVDF2anlvVXVrQ3ZKVEc5cUJ5cDYwdFFhcmNoUTUyb1ViSnJFQUJqdjR5?=
 =?utf-8?B?eG12WXpEeTJtREhiQ05CZktodVlZY0U1MXQzNXBEUkFCTDhWbUp3VWpKVnox?=
 =?utf-8?B?YnI4NWlEZUhJSzdaS0FFRkZDRXcvdHZiaENNQmxkNXRBeHp5Z3E0TUQ3YWlu?=
 =?utf-8?Q?myeILCw19vjGRM9CAjAaX5vJ4?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 573af87f-3693-463c-7417-08dbaa962f10
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2023 02:50:21.4473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJSSvPE56EKoz6Ti84tsGYynUF0J49iEvvNBqUZbfpHRAUCcR+uuSLW0hlSLRvhVAZw/Bu0FUnwn30Pw3RnUpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8360
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgQXVndXN0IDMxLCAyMDIzIDc6MjUgUE0NCj4gDQo+IE9uIDIwMjMvOC8zMCAxNTo1NSwg
VGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEJhb2x1IEx1IDxiYW9sdS5sdUBsaW51eC5p
bnRlbC5jb20+DQo+ID4+IFNlbnQ6IFNhdHVyZGF5LCBBdWd1c3QgMjYsIDIwMjMgNDowNCBQTQ0K
PiA+Pg0KPiA+PiBPbiA4LzI1LzIzIDQ6MTcgUE0sIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+Pj4+
ICtzdGF0aWMgdm9pZCBhc3NlcnRfbm9fcGVuZGluZ19pb3BmKHN0cnVjdCBkZXZpY2UgKmRldiwg
aW9hc2lkX3QgcGFzaWQpDQo+ID4+Pj4gK3sNCj4gPj4+PiArCXN0cnVjdCBpb21tdV9mYXVsdF9w
YXJhbSAqaW9wZl9wYXJhbSA9IGRldi0+aW9tbXUtDQo+ID4+Pj4+IGZhdWx0X3BhcmFtOw0KPiA+
Pj4+ICsJc3RydWN0IGlvcGZfZmF1bHQgKmlvcGY7DQo+ID4+Pj4gKw0KPiA+Pj4+ICsJaWYgKCFp
b3BmX3BhcmFtKQ0KPiA+Pj4+ICsJCXJldHVybjsNCj4gPj4+PiArDQo+ID4+Pj4gKwltdXRleF9s
b2NrKCZpb3BmX3BhcmFtLT5sb2NrKTsNCj4gPj4+PiArCWxpc3RfZm9yX2VhY2hfZW50cnkoaW9w
ZiwgJmlvcGZfcGFyYW0tPnBhcnRpYWwsIGxpc3QpIHsNCj4gPj4+PiArCQlpZiAoV0FSTl9PTihp
b3BmLT5mYXVsdC5wcm0ucGFzaWQgPT0gcGFzaWQpKQ0KPiA+Pj4+ICsJCQlicmVhazsNCj4gPj4+
PiArCX0NCj4gPj4+IHBhcnRpYWwgbGlzdCBpcyBwcm90ZWN0ZWQgYnkgZGV2X2lvbW11IGxvY2su
DQo+ID4+Pg0KPiA+Pg0KPiA+PiBBaCwgZG8geW91IG1pbmQgZWxhYm9yYXRpbmcgYSBiaXQgbW9y
ZT8gSW4gbXkgbWluZCwgcGFydGlhbCBsaXN0IGlzDQo+ID4+IHByb3RlY3RlZCBieSBkZXZfaW9t
bXUtPmZhdWx0X3BhcmFtLT5sb2NrLg0KPiA+Pg0KPiA+DQo+ID4gd2VsbCwgaXQncyBub3QgaG93
IHRoZSBjb2RlIGlzIGN1cnJlbnRseSB3cml0dGVuLiBpb21tdV9xdWV1ZV9pb3BmKCkNCj4gPiBk
b2Vzbid0IGhvbGQgZGV2X2lvbW11LT5mYXVsdF9wYXJhbS0+bG9jayB0byB1cGRhdGUgdGhlIHBh
cnRpYWwNCj4gPiBsaXN0Lg0KPiA+DQo+ID4gd2hpbGUgYXQgaXQgbG9va3MgdGhlcmUgaXMgYWxz
byBhIG1pc2xvY2tpbmcgaW4gaW9wZl9xdWV1ZV9kaXNjYXJkX3BhcnRpYWwoKQ0KPiA+IHdoaWNo
IG9ubHkgYWNxdWlyZXMgcXVldWUtPmxvY2suDQo+ID4NCj4gPiBTbyB3ZSBoYXZlIHRocmVlIHBs
YWNlcyB0b3VjaGluZyB0aGUgcGFydGlhbCBsaXN0IGFsbCB3aXRoIGRpZmZlcmVudCBsb2NrczoN
Cj4gPg0KPiA+IC0gaW9tbXVfcXVldWVfaW9wZigpIHJlbGllcyBvbiBkZXZfaW9tbXUtPmxvY2sN
Cj4gPiAtIGlvcGZfcXVldWVfZGlzY2FyZF9wYXJ0aWFsKCkgcmVsaWVzIG9uIHF1ZXVlLT5sb2Nr
DQo+ID4gLSB0aGlzIG5ldyBhc3NlcnQgZnVuY3Rpb24gdXNlcyBkZXZfaW9tbXUtPmZhdWx0X3Bh
cmFtLT5sb2NrDQo+IA0KPiBZZWFoLCBJIHNlZSB5b3VyIHBvaW50IG5vdy4gVGhhbmtzIGZvciB0
aGUgZXhwbGFuYXRpb24uDQo+IA0KPiBTbywgbXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IGRldl9p
b21tdS0+bG9jayBwcm90ZWN0cyB0aGUgd2hvbGUNCj4gcG9pbnRlciBvZiBkZXZfaW9tbXUtPmZh
dWx0X3BhcmFtLCB3aGlsZSBkZXZfaW9tbXUtPmZhdWx0X3BhcmFtLT5sb2NrDQo+IHByb3RlY3Rz
IHRoZSBsaXN0cyBpbnNpZGUgaXQuDQo+IA0KDQp5ZXMuIGxldCdzIHVzZSBmYXVsdF9wYXJhbS0+
bG9jayBjb25zaXN0ZW50bHkgZm9yIHRob3NlIGxpc3RzIGluIGFsbCBwYXRocy4NCg==
