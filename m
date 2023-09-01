Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F2A78F752
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 04:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348190AbjIACtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 22:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjIACte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 22:49:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BDFE76;
        Thu, 31 Aug 2023 19:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693536570; x=1725072570;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tDSw30ohbTQHzDbvEcK3BLmQ6tPKNh74Zy99PjoIMWU=;
  b=hIzqIs9Ge5WqurJYIlcQLYiqw3pu5zeF4LTaF7cvjywnZgwgPFNXsell
   45GjTeX8q+/p92MD8v7IWcUxH4uv9yVF849iCVHEhYEejnbn/IC2YUTBT
   0810oboUh9HxISovvjXuI7Ovr0+OXeFKYl5VPyzV5CxG6dKLHSXS6uD4X
   amDuops1/joRwb0OQopxE5lkAt4YwMnlTgMIVv1BrTNq7MnSIag/CNjof
   wzVeOh0cmAKrq6jcsQe/czF6uVbmQjlq8ruvEXSEHRDeR5SvhKHW7obOC
   BDsw2AxaZFAD7b7wDeHCIqVIvihf52gsuEYmzz5MjBnEIMvfSkOTJBwuX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="356433498"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="356433498"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 19:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="829962695"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="829962695"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Aug 2023 19:49:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 31 Aug 2023 19:49:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 31 Aug 2023 19:49:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 31 Aug 2023 19:49:28 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 31 Aug 2023 19:49:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=net7rVdG1Hc01KI3g06JXe1eu9czinsYF/4cca3n9MxupsaEeyZ6PVy9Ydhldiu2tiFKMjvgKvRTZXUsPURUoVMOcKxe3sMookOfuDKTdDGQUdwxHxfPjdA6B7vk+4rC9hoDBvLnBeDCusQuZbiM63MAYTJlUvqJodyJhKBa7U5s7kTSwzHGrOKpIngofyIiHxeUuVgzGQSxX7WLfwWWoQgyVeJP0dCaYIemrP0WFLwvcaFmN/xuwrdeIV+ixUpqqaY3nyKTUjVJoqL9G5pzDOlgqxcGFcs7whCFrWkRxhQOrXYeTD2Jb13LfZBHzM21S0Jc9S9y0iY2EpRV2CHNeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDSw30ohbTQHzDbvEcK3BLmQ6tPKNh74Zy99PjoIMWU=;
 b=mnpf8BHd0ZAu8nqdW/Wr7WXCdtdSlK4n8f/RBmbkvHyUZ4thZ9oMV0kkaU9qRp1qtoGUmbyR9HetqxN0R5ARAS8ruta57NNKmpjSIHh8Z+o+wf0EPDWQCisbXstH2/UUuKPviWJtM6xXB+QEu05iAdaAlHBaEzqldgK8dZ9cSPNRdqgtdggKgthruiMMNppJiKAaKdXk93OehGaVdW3Ix6lSjzxkhesRQxAH3sHi6jWwXajisQaoT659zm4OsBwMjSsk+6r3+4x97equkBivvb+D0jRVMibSmDLz/qJnDtRNBedSv/YLpSSqvXQ8ZlWOjvstV2Non9cnjAwD6eHCUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CYYPR11MB8360.namprd11.prod.outlook.com (2603:10b6:930:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.18; Fri, 1 Sep
 2023 02:49:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6745.022; Fri, 1 Sep 2023
 02:49:16 +0000
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
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGRCACABkHzwIABseKAgAEiyiA=
Date:   Fri, 1 Sep 2023 02:49:16 +0000
Message-ID: <BN9PR11MB527610423B186F1C5E734A4B8CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <67aa00ae-01e6-0dd8-499f-279cb6df3ddd@linux.intel.com>
In-Reply-To: <67aa00ae-01e6-0dd8-499f-279cb6df3ddd@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CYYPR11MB8360:EE_
x-ms-office365-filtering-correlation-id: 52342678-1f26-49bf-12f7-08dbaa960841
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xut84w/UyiZlfi9BK+nR+kKo57XaRwnKP440m/qcjWtPyqtTWC0SvOce5f4MqVbP8FNPsVB5jl7Z20VBpnHHUa7IoH43JZy5QftalIQP1XeM7mIzu3IHkAXDsPX0x5ED1kBHjBRZ1n1hVcvpdX6wAMlOjwFpwAdv0z+0L4do5UbuSJJo2WS6MI7xkneQJsrzyqM1mZ7ReWSQJc36FcFApSBaLLBWaJsC2IsR/8tcva3Xa/fzhGMTL5kBfr2WhLGgYo9kaNWGkUpjxF/zCFNmil0IfGzd2N3bshNnWE6pSbWmWzJUSxJksoMgef0v8j8NBLYDh4/S7ko3u5V5X3jPIiwlG9crpcQAy9BTd+fdRrU1P9JfVyL7WI+sBhBsVpTw6SOdJe2D2ZSiGqDQtNzPXBAhDM+/dQ+dGKS58nHKXyx33IeIYLcGQqyDOweiffRfykM6M026fj8O4+mvqo8RgSLmk2/a/hj2Gr1rt0DkIRg51yvXvNvK+kANTz7VZ3FAmiWgUFV4OWBtnBHg6X60X2csw79QnLFismv7ymVBugM/DLIhQSvAO4bZEorUafyPbYkbWlddtJIBNwrel4ZDoh6B1XCbvXalU8qdccxC85GB+rVVDwKkCa+yIOeYE6vtFjtzJNdc9Rb+f01Wd7B3Fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(346002)(366004)(39860400002)(1800799009)(186009)(451199024)(8936002)(76116006)(478600001)(110136005)(53546011)(122000001)(66946007)(7696005)(66556008)(6506007)(64756008)(71200400001)(66476007)(66446008)(54906003)(38070700005)(316002)(38100700002)(41300700001)(82960400001)(9686003)(26005)(83380400001)(5660300002)(55016003)(2906002)(86362001)(52536014)(8676002)(33656002)(4326008)(7416002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0t3UlhnNldyUlA5UWYvVUUyRmRkZDBUUVM2WEs5YXFuQVE5c21YVDhhMWlr?=
 =?utf-8?B?VUVUTzl4N3BGTC9oU1p4czBjRmRXRmsydTllQTJLVVIvSDRTTGdDUUMyRm9y?=
 =?utf-8?B?cVdnQklrcXloaVluV2xnZHJ4UzUwTmdKSWZIdTNWVDZJU2RicUNYby9tSld1?=
 =?utf-8?B?NGxJOGZqTk9rczFRN3VzVis3c3JEUXk3OHFQd3BJOENmOTNLRktOM1hzS1FW?=
 =?utf-8?B?RE9TSnltOGE5VlhSTjh1TjFLb3A0UlpjemZBWlBRNVNzQUJwekRhU0VPeWFB?=
 =?utf-8?B?TVpEc2ZubXV6dXJYMVAvRnVlTkQvc2RJN0dINVRybldEWmZGNWlIdkNLSHI5?=
 =?utf-8?B?VnhQTHlrYXN6N2ZhNWxOVVFvS3dQcHg2WjRGc0ZQY1c2ZFA3K2lMU1lvMCsw?=
 =?utf-8?B?NGN6bFhrSGR4YStLQ2NvRnZyZkFDcms1YmVZQWhsQjh1SmkzZFRPY3B2V1VL?=
 =?utf-8?B?QmtGVmpySEtMR0ZpOVNWbkN0VHVZZG9kbGs1R2xEV2N2ODlOQ0ZxUmx6MGZT?=
 =?utf-8?B?K20zU3V2UTQzNlNxd0g2ZjBZR2UwMFlmVUZJdFpiWXlSL0NvOTdkR093aXNH?=
 =?utf-8?B?Qzl3L2p2N3AxOVdScTd2YzVIdC9jRy9LVjA2RUtTS0NldllidXY1b25pcUV3?=
 =?utf-8?B?Wm9lUlRnTEZIZ2JGRWlmVjVtdVlBWm9yMklna1B6cHc4Um1JcGlTdTVUWGIx?=
 =?utf-8?B?aElya0dyck5Yd3djVzZtczNuSVM4YnRrTGdrVFFXSDlFYmNoQWxCZUV6WnVm?=
 =?utf-8?B?WTZKQWVUVnMzbEMyRCs5RkRIaHZNcTU3a1dKMXAySms2NHFzM3BpTU5LaThv?=
 =?utf-8?B?MFNIYkhva2doeTlsRlNmWGg0RXlvMWwzU0VFcXRZVUVnemhLRGNLWTBaRGFi?=
 =?utf-8?B?MDNySXJtTGUwSzRqcnRPd3ZQNDk3akJ3SlZjZGtjQ3ArVkFFRjdjaVB1dEpw?=
 =?utf-8?B?YnNEeFdiNUpJNzA1bjlkaGNLcVlyTmNpK1ZQL1QvOWdiU0t3TnFPMjdhS3Bz?=
 =?utf-8?B?QjQ3RnhDdmwzZ3FEZUE0eWdpTlR0NlpNTzlGRVhFRW9NQ1FJaUJ5UEsybjdq?=
 =?utf-8?B?dy9vRmZHa1hoRnBveDloa3hpWDY2SWNoR0w4RmN3UExaZ3F5T2hxWFltcENC?=
 =?utf-8?B?U2hBeDFLaXFrTU5DdEhFcEppV1RtM1lWRDUzclU0enUzVm5HK3Z4OXJGakhV?=
 =?utf-8?B?YkY2SUYyL3pGZ3A4OG9MbUhMKy9XbEo0c1AwSG9sRzhZcXNrUDUzcW1DMW9V?=
 =?utf-8?B?eGtvaUhyRk9TYk9uaVcvNVdudzUrS1U2Z2ZDdzJ5bGtCZE4vVDhtUnFobkJI?=
 =?utf-8?B?TngyZGF0K2cyUzcxeGJTUXc0SzdhRk9JOU1nQ2FBOFVNRmhHZmFZWGQrc2VG?=
 =?utf-8?B?bFNUcEx1ZWhadFdISitBNUo5NXRTWjZlM2VNM3YyZDlkcFd0eGc5Z1poN0VK?=
 =?utf-8?B?MlVOTzNlMVk4MEg0aFdjY2pVZHJXZmN6dFNWKzhUK1dONzNmNnMyWFEvajRP?=
 =?utf-8?B?aFZTSEF1UzVWT05LUDhjUnVjdm5JU0E5d1pjUWZrSEhSaGxPV0gzSy9pamdT?=
 =?utf-8?B?WnJaRzdmakhNTG9STkllQWRSc2h1Wmp5Unkzc3pCK2Y0Z1d0ZVdYeTVEbDIx?=
 =?utf-8?B?MFpYSDNtQi9DQ2xvWWVaSldvclk2WklDTnJ0VVRmU2Z0SXdqMC85Zm1mRHpk?=
 =?utf-8?B?Y0Z1aExFOFBMNHE4cWdsOFNCbkJlYzUydXBqK3UzakRRK3RlenNGWDNLcHp2?=
 =?utf-8?B?QXNBK2toWW9ibGhjaEl4YXJKMVFVTFVOYkphQi9XYVJ6MFcxdEtTV2s5WkxO?=
 =?utf-8?B?VDdYMStnSWdTNjdZcGZyYjBkdmpYK3lsR1lGb0JQcXJ0QnJtdkNlRkVnQ3B2?=
 =?utf-8?B?UC9xNWROSjMyRkdqelhOSVhoVHlWRnBBMGd4MXhIV1VGNzZucFRVL0d3Ukth?=
 =?utf-8?B?WXVUOGVFdktWUExFamtsRXJxQTR5V3NhMDFKMVJiMFc5bWFJa2hXUkxERVZu?=
 =?utf-8?B?dS9IZnFFTDgxZjhFV1l2SXl4L05tR0h1QXp5SHlSQzJoRkgxQWF4ZTBLSVky?=
 =?utf-8?B?aGVpWHVzTElLTVhNNGU4dTJFR05wb2ZlbXppd3lSSkYvWHg3aitDYitLK1pp?=
 =?utf-8?Q?RJe/nJDsdH9KaOZSAKDBoHrya?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52342678-1f26-49bf-12f7-08dbaa960841
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2023 02:49:16.3150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kd/5ouIUiZYH3b8m5mmklCi9H1CcqxWSCa44S+1FJrEHjBvgwFevUxx/TFU9Ovrp9Dxnb8CIDa/jETeecjzIfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8360
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

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgQXVndXN0IDMxLCAyMDIzIDU6MjggUE0NCj4gDQo+IE9uIDIwMjMvOC8zMCAxNTo0Mywg
VGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEJhb2x1IEx1IDxiYW9sdS5sdUBsaW51eC5p
bnRlbC5jb20+DQo+ID4+IFNlbnQ6IFNhdHVyZGF5LCBBdWd1c3QgMjYsIDIwMjMgNDowMSBQTQ0K
PiA+Pg0KPiA+PiBPbiA4LzI1LzIzIDQ6MTcgUE0sIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+Pj4+
ICsNCj4gPj4+PiAgICAvKioNCj4gPj4+PiAgICAgKiBpb3BmX3F1ZXVlX2ZsdXNoX2RldiAtIEVu
c3VyZSB0aGF0IGFsbCBxdWV1ZWQgZmF1bHRzIGhhdmUgYmVlbg0KPiA+Pj4+IHByb2Nlc3NlZA0K
PiA+Pj4+ICAgICAqIEBkZXY6IHRoZSBlbmRwb2ludCB3aG9zZSBmYXVsdHMgbmVlZCB0byBiZSBm
bHVzaGVkLg0KPiA+Pj4gUHJlc3VtYWJseSB3ZSBhbHNvIG5lZWQgYSBmbHVzaCBjYWxsYmFjayBw
ZXIgZG9tYWluIGdpdmVuIG5vdw0KPiA+Pj4gdGhlIHVzZSBvZiB3b3JrcXVldWUgaXMgb3B0aW9u
YWwgdGhlbiBmbHVzaF93b3JrcXVldWUoKSBtaWdodA0KPiA+Pj4gbm90IGJlIHN1ZmZpY2llbnQu
DQo+ID4+Pg0KPiA+Pg0KPiA+PiBUaGUgaW9wZl9xdWV1ZV9mbHVzaF9kZXYoKSBmdW5jdGlvbiBm
bHVzaGVzIGFsbCBwZW5kaW5nIGZhdWx0cyBmcm9tIHRoZQ0KPiA+PiBJT01NVSBxdWV1ZSBmb3Ig
YSBzcGVjaWZpYyBkZXZpY2UuIEl0IGhhcyBubyBtZWFucyB0byBmbHVzaCBmYXVsdCBxdWV1ZXMN
Cj4gPj4gb3V0IG9mIGlvbW11IGNvcmUuDQo+ID4+DQo+ID4+IFRoZSBpb3BmX3F1ZXVlX2ZsdXNo
X2RldigpIGZ1bmN0aW9uIGlzIHR5cGljYWxseSBjYWxsZWQgd2hlbiBhIGRvbWFpbiBpcw0KPiA+
PiBkZXRhY2hpbmcgZnJvbSBhIFBBU0lELiBIZW5jZSBpdCdzIG5lY2Vzc2FyeSB0byBmbHVzaCB0
aGUgcGVuZGluZyBmYXVsdHMNCj4gPj4gZnJvbSB0b3AgdG8gYm90dG9tLiBGb3IgZXhhbXBsZSwg
aW9tbXVmZCBzaG91bGQgZmx1c2ggcGVuZGluZyBmYXVsdHMgaW4NCj4gPj4gaXRzIGZhdWx0IHF1
ZXVlcyBhZnRlciBkZXRhY2hpbmcgdGhlIGRvbWFpbiBmcm9tIHRoZSBwYXNpZC4NCj4gPj4NCj4g
Pg0KPiA+IElzIHRoZXJlIGFuIG9yZGVyaW5nIHByb2JsZW0/IFRoZSBsYXN0IHN0ZXAgb2YgaW50
ZWxfc3ZtX2RyYWluX3BycSgpDQo+ID4gaW4gdGhlIGRldGFjaGluZyBwYXRoIGlzc3VlcyBhIHNl
dCBvZiBkZXNjcmlwdG9ycyB0byBkcmFpbiBwYWdlIHJlcXVlc3RzDQo+ID4gYW5kIHJlc3BvbnNl
cyBpbiBoYXJkd2FyZS4gSXQgY2Fubm90IGNvbXBsZXRlIGlmIG5vdCBhbGwgc29mdHdhcmUgcXVl
dWVzDQo+ID4gYXJlIGRyYWluZWQgYW5kIGl0J3MgY291bnRlci1pbnR1aXRpdmUgdG8gZHJhaW4g
YSBzb2Z0d2FyZSBxdWV1ZSBhZnRlcg0KPiA+IHRoZSBoYXJkd2FyZSBkcmFpbmluZyBoYXMgYWxy
ZWFkeSBiZWVuIGNvbXBsZXRlZC4NCj4gPg0KPiA+IGJ0dyBqdXN0IGZsdXNoaW5nIHJlcXVlc3Rz
IGlzIHByb2JhYmx5IGluc3VmZmljaWVudCBpbiBpb21tdWZkIGNhc2Ugc2luY2UNCj4gPiB0aGUg
cmVzcG9uc2VzIGFyZSByZWNlaXZlZCBhc3luY2hyb25vdXNseS4gSXQgcmVxdWlyZXMgYW4gaW50
ZXJmYWNlIHRvDQo+ID4gZHJhaW4gYm90aCByZXF1ZXN0cyBhbmQgcmVzcG9uc2VzIChwcmVzdW1h
Ymx5IHdpdGggdGltZW91dHMgaW4gY2FzZQ0KPiA+IG9mIGEgbWFsaWNpb3VzIGd1ZXN0IHdoaWNo
IG5ldmVyIHJlc3BvbmRzKSBpbiB0aGUgZGV0YWNoIHBhdGguDQo+IA0KPiBZb3UgYXJlIHJpZ2h0
LiBHb29kIGNhdGNoLg0KPiANCj4gVG8gcHV0IGl0IHNpbXBseSwgaW9wZl9xdWV1ZV9mbHVzaF9k
ZXYoKSBpcyBpbnN1ZmZpY2llbnQgdG8gc3VwcG9ydCB0aGUNCj4gY2FzZSBvZiBmb3J3YXJkaW5n
IGlvcGYncyBvdmVyIGlvbW11ZmQuIERvIEkgdW5kZXJzdGFuZCBpdCByaWdodD8NCg0KeWVzDQoN
Cj4gDQo+IFBlcmhhcHMgd2Ugc2hvdWxkIGRyYWluIHRoZSBwYXJ0aWFsIGxpc3QgYW5kIHRoZSBy
ZXNwb25zZSBwZW5kaW5nIGxpc3Q/DQo+IFdpdGggdGhlc2UgdHdvIGxpc3RzIGRyYWluZWQsIG5v
IG1vcmUgaW9wZidzIGZvciB0aGUgc3BlY2lmaWMgcGFzaWQgd2lsbA0KPiBiZSBmb3J3YXJkZWQg
dXAsIGFuZCBwYWdlIHJlc3BvbnNlIGZyb20gdXBwZXIgbGF5ZXIgd2lsbCBiZSBkcm9wcGVkLg0K
PiANCg0KY29ycmVjdC4NCg==
