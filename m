Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB97516BE
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 05:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbjGMDZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 23:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjGMDZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 23:25:05 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE26810FC;
        Wed, 12 Jul 2023 20:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689218704; x=1720754704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ofASiTrwKEfXVPo4uJcBQlCJ8Iw6L7v5//6zhJmKGLQ=;
  b=gIkn4OyLvRBR/qQ5cwxUgnwwwfnWRFEAGSCIjXEpW7zqce9aESjobug9
   33IAz3J9RAbD9zHUQSpg4bnCWwz5Q1wBC33IxJV7vXhxwQG1/wAQK0hYT
   uUVUN3SUPb0HcPX0vwq3akeNCS/COwLm19o/vG0OUXoEIgdu18jIl3IRS
   8CSWfa/bBQYXI027q0mVFl+UzAXZ179BtbLILyEmPir13CJ+kMakELAym
   mdWwPcaupVFGBcQ++ux7iKjeihJmq0kTUwIclZYEE7DyD/ZN0eiwBvOXn
   9gfSsYIG7XSruZdcqZSz++tFflqAwmpMJTSaVODQKGvjK0+lzH/5TezaS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="345386370"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="345386370"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 20:25:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="751434457"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="751434457"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 12 Jul 2023 20:25:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 20:25:02 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 20:25:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 12 Jul 2023 20:25:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 12 Jul 2023 20:25:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDSwKtUrlf0v989zrcoR8ZVKcYrzODPDKmpj5aAAz5y2Y9pPFaBwbzpJqgewO9Yun+IEWuyeuYtEnLvB59VwxfJwlDUbIecnCS67J/04RXiLIuLPK6aA0D1YdaZX0gGqO1qnXWprUjkUilGQzHICVSj19AxlRNsKIVAhL3h0y0Q6hfqrG+iijpdzqU1H+KByikWygUMQ9MNCTR6W6O6JMrawce7WEPuVmY2F9SqVeEUqcargd/KOUXu4mrFrNn4Q0a2sTgaRzGRawOjO/POxik6EQpsxz+dwW52glOgoRbnJCCpPAlB8XTbA/7geV2jJkEXraigfwW4qUFZXIcocqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofASiTrwKEfXVPo4uJcBQlCJ8Iw6L7v5//6zhJmKGLQ=;
 b=oT3+8g1+9LNvtgotR4JZIdk1nCMpq2zEUbXBWEHd1XZhZpus/saYJ3YbUYwe6P+n7RtFL4uiemMUjrEewAPS92KzGcwxqMNJRK2MUBIpGYdZ5ZvYRQfvIjnpKxHQXKFjOVpo35FISU+I/IX0AUGw1/DbfWRp0wwmSPHO1NwpyIVy9KIW6jycajDE26QCalc8i9n0OfizYKEsCt3pJ11vVXReuyc+TtZARvjxpYUSyUTaOloVkHAx70aan/v2+seqFVXKNkM1fdXLly7HvyWSbSVC0EBz9koSJDKkrXgAg4ccjRuuiUpgH5MUUwsJ8+hKgCb80PxUV6wrA0209/qA/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5980.namprd11.prod.outlook.com (2603:10b6:208:387::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 03:24:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6588.024; Thu, 13 Jul 2023
 03:24:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 9/9] iommu: Use fault cookie to store iopf_param
Thread-Topic: [PATCH 9/9] iommu: Use fault cookie to store iopf_param
Thread-Index: AQHZs5ROZ0DTU24O6Ue9hKGIoQNDRq+1H7OAgABWtACAAZVBwA==
Date:   Thu, 13 Jul 2023 03:24:55 +0000
Message-ID: <BN9PR11MB527640E6FBD5271E8AF9D59B8C37A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-10-baolu.lu@linux.intel.com>
 <20230711150249.62917dad@jacob-builder>
 <e26db44c-ec72-085d-13ee-597237ba2134@linux.intel.com>
In-Reply-To: <e26db44c-ec72-085d-13ee-597237ba2134@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5980:EE_
x-ms-office365-filtering-correlation-id: a12e9c09-b0e1-47c3-f547-08db8350baa4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s+fort7YUBWnxnimHWgRe4l/TXgEsX6hx0QoAc7pmsgpXH7aJJWAQyR8kBSFN17HqT7A+zMP+lKKz6F9SZm7Xj17UThDB+b61HzHVQ1DC+hLn/Bbj+vSQmgZhr8/rDQOcT3okK7G3joWdgcX4ZX45FBd41qH0jPTf1jyZVmC2zBbksjGlW3z5m7XlihmfnPCSszGNS8G939uxEL47SJxbwPKIq60trCBnXz6wSGqC3pQHRuc/N6j6OeQHJztzVihDsT8d4bF3ggFVw1mMXkF0i9yRo5V6kK1aYTCwpsjliB43mBxhowm5qfYUcTYAstMF9IeROBPEYtcuUpeosI8RB0FibH3dJ8a+FkRN+D9yL+ph1Q5rcRNgZWrxdQAKY19kPMYkFcSHuyWq3ilavj1uBNWx2wofhWSxq8K4VC+KiQdAzOF07053x1vLA/lh0t+p4aSzk3x3pPthyokGuCujmGVkBvPrX7LF9bVk7f1ygHX2ncVrCn7KGBczGVjTpEoC39gQ7wPKgXnTEmKqnZiyOBbSdnDFkrIwR1w/P2bS+/5qmTOzBFbfnkGJFRB2Es1BA3c3WqWlseFMATRYp4QLfILKb5Kcfchjlbqh/e9jf+rOkpsk48NhWOK7cH2Ju3f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199021)(186003)(86362001)(53546011)(76116006)(66446008)(64756008)(66946007)(66556008)(66476007)(316002)(83380400001)(4326008)(9686003)(26005)(33656002)(6506007)(478600001)(82960400001)(2906002)(7696005)(122000001)(4744005)(54906003)(110136005)(71200400001)(55016003)(38070700005)(38100700002)(41300700001)(7416002)(52536014)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q25JZ3lHM2dpNUhFQm9pblBvdjNMYWh3elFZTEdvNG9tQlIyajJSeXdTNHIv?=
 =?utf-8?B?UEpoWkdVM3pFbCtPNHJCajkvL2ZnTFBTeHVJQkFlZnhVbGlaTVhtTmtwc3h0?=
 =?utf-8?B?Zml0R3B4aWU4QitCWnh6TEl6UExpdTBHc3RQUHpybDcxOFVBRWhld2lBOG5V?=
 =?utf-8?B?QWUvZEZDR01yeWdmbnhpd1VyRlorRFY2WUplQkx2VXcxSXJFSzd0WWlwdWE1?=
 =?utf-8?B?ODBJbzV0SGZWS1BTYXZhenVjaGxoMldkeklqRXR5WC9XS0NNNUJ1Q2gvWG1V?=
 =?utf-8?B?WHNiN2VPUTVxckpadVR6LzRPRWRUbVhqQm1MYnduUEQybFA5V1VBRnJza21L?=
 =?utf-8?B?MG9kN0kwbzdCYXFOTU9BZktLV2V5cXVRVVhmV1JMeWFvSGlZZ3BCeVlhTy9u?=
 =?utf-8?B?K0ltcndiVVRDSEIwWE5xM1RDTzRJNjNnZld0MzFjT1BVWWtuamNxN1JqRnBN?=
 =?utf-8?B?bjBtVjkxRkFJQmJBOUlhTTlJckdPS1BTUTVEWmhHOWo1cTZ2RWc0cEFUekJz?=
 =?utf-8?B?a3VoVnFlYmxKL1hKcm15dkJnZVI0ays2SXNsSkFHcXBRdVFTOEQwT2xRNXp6?=
 =?utf-8?B?alZLS0pNN2N1cENNT0kvVzRKQzV0WmVNRy9zSmpQRXRUbUxKamRsbnFFN3A0?=
 =?utf-8?B?YU5Ba09UNmZDeHQ5ZWxKVkNBOUtmNUdhMTROcmFWNzRzZ1c4SVhGL20yUU1t?=
 =?utf-8?B?MkM1WCs5bnd2aktWbHQ2OTNOZmZyb3c2c1o0cTEwM2wzeUNac3ZnNms3THRr?=
 =?utf-8?B?VXJTNFU4K3VGKzMzdEpvNytlWWZVSG1iTHlqSWdUS2hvcjhUaHo1L1pUMG1U?=
 =?utf-8?B?YlB2MHdxS0FVdXNRcURlNXp1cElSTjd4ZlY1R2ZQa1FBcWR6cURwREg5cUVr?=
 =?utf-8?B?TUpWeHdXbVhaZjNzUitPSklCWWNGdmEzZ0RTYlRBT2hFcytxa0ptaEk3bVpv?=
 =?utf-8?B?MHlwdWJ6ZERLUUd1YnJBZm9RdjlkT0Y0OGF2WFI3bStITWhSMG1rekJYNWc5?=
 =?utf-8?B?TjcxeE8wMm5SNWJES1Y3NUNRM2dweDc3WWlmZHVwTzhGZi9vVHhOV1h0WHVL?=
 =?utf-8?B?Q2pFeW5ZREJRaFZSajFadCsyZUJ0NHBlZzl1dHVIdlhDYmN4QS9welNjZjBP?=
 =?utf-8?B?VjlmRkIrYVVDaHlKTmEyZzV1bWc3RmZWWXMrdjQ4L1VGSnd2MG1jalhnYUx0?=
 =?utf-8?B?eEk2RlhGU1JvK2tWQ016SkwrVUZZOUt6L0pXd0pPNFc3WDQ5aXRwbG4zNXh4?=
 =?utf-8?B?Z0VCVGJsdU5wdExBRElqVDAyUHpiQ0Z4UlpsYSt3SGV3eWtXek14MDYxR24r?=
 =?utf-8?B?UUZyMFUyRi9tdm9uMUI3UjI0WG9IRzFMaWZTb1hxZWwvbW9ycXp0TTB6Snor?=
 =?utf-8?B?Y0J6RzJkSmgxcFd2bG05emtLYkNuSmtHZFY4b2JMdzlrWjViSHVNcERzLzlF?=
 =?utf-8?B?QTgxdzFRZjI3aXowZDJ5Sll4ZDdNVzY3dlhrN1pYdG5ROXdKNEQzQ1V2OFZ4?=
 =?utf-8?B?Y3NpbkVCY3pRWUhTMjNaWFNIWFo0cmprRnlxUW1tT1VOUXErQ21qOWNaU2E5?=
 =?utf-8?B?Ym5rb2tyR1FCRUZmTjdwQ091OTBNaythcFp2N1k1RUVXMUZSNnkzL0d4L3FB?=
 =?utf-8?B?bTlIcldPTDZ3WGNodGRqYWZlN1JFZUpmQjh1Q1dQMVNsbkwxSm1RUm1Ybmhx?=
 =?utf-8?B?cmxJb0kvZTg5Nk9MOWplTFhhYVY2WEZKTXNOWm1YeU4wNUQwRHlvdWdKa04x?=
 =?utf-8?B?ZWtRSlZ2YUd1aE5SVzdXUEo3RG5yckNFNTZpK1Q3U3BEaHJvVTZoVTVBVGkx?=
 =?utf-8?B?dzh6VkxBcytMOE9oRUVPRGtEQktPSzVrMDNMaTVZazEzSFZ4MFZlM2cwV3Vz?=
 =?utf-8?B?V2ozVGVONElqU1hOVndGMEZlRFdZNlpHcklUOXpFLzY2bWRXQTcxVkErcW5D?=
 =?utf-8?B?VUVvUFJTRi8vOEVDQWlsQ25HWlJWa2pyV2RRMjhOdXNCT21CZWNuMzVIREN3?=
 =?utf-8?B?dFcrRkF1YnJwdTJHdjhuQWhsckhHVllPaVNhdWNUZXducFBQeUkzMzNmZVBn?=
 =?utf-8?B?T1hlWG5SUjVlRzB4bkZoTUxqbDhoejlsRWx2dWk3VFliVVk0SDJ2UU9UaXV2?=
 =?utf-8?Q?IvN9nySI8mFvyMrXmwgcNUn4E?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12e9c09-b0e1-47c3-f547-08db8350baa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 03:24:55.4639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dSNfYNNASVm50vEWa2D9AWTmiGglRQ9J3qtkK/b2e+H3k7C1FiKv8uLpmWMB/o3Bd0tbHt6954B8L9XyTfURKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5980
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEp1bHkgMTIsIDIwMjMgMTE6MTMgQU0NCj4gDQo+IE9uIDIwMjMvNy8xMiA2OjAyLCBK
YWNvYiBQYW4gd3JvdGU6DQo+ID4gT24gVHVlLCAxMSBKdWwgMjAyMyAwOTowNjo0MiArMDgwMCwg
THUgQmFvbHU8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiA+IHdyb3RlOg0KPiA+DQo+ID4+
IEBAIC0xNTgsNyArMTU4LDcgQEAgaW50IGlvbW11X3F1ZXVlX2lvcGYoc3RydWN0IGlvbW11X2Zh
dWx0ICpmYXVsdCwNCj4gPj4gc3RydWN0IGRldmljZSAqZGV2KQ0KPiA+PiAgIAkgKiBBcyBsb25n
IGFzIHdlJ3JlIGhvbGRpbmcgcGFyYW0tPmxvY2ssIHRoZSBxdWV1ZSBjYW4ndCBiZQ0KPiA+PiB1
bmxpbmtlZA0KPiA+PiAgIAkgKiBmcm9tIHRoZSBkZXZpY2UgYW5kIHRoZXJlZm9yZSBjYW5ub3Qg
ZGlzYXBwZWFyLg0KPiA+PiAgIAkgKi8NCj4gPj4gLQlpb3BmX3BhcmFtID0gcGFyYW0tPmlvcGZf
cGFyYW07DQo+ID4+ICsJaW9wZl9wYXJhbSA9IGlvbW11X2dldF9kZXZpY2VfZmF1bHRfY29va2ll
KGRldiwgMCk7DQo+ID4gSSBhbSBub3Qgc3VyZSBJIHVuZGVyc3RhbmQgaG93IGRvZXMgaXQga25v
dyB0aGUgY29va2llIHR5cGUgaXMgaW9wZl9wYXJhbQ0KPiA+IGZvciBQQVNJRCAwPw0KPiA+DQo+
ID4gQmV0d2VlbiBJT1BGIGFuZCBJT01NVUZEIHVzZSBvZiB0aGUgY29va2llLCBjb29raWUgdHlw
ZXMgYXJlIGRpZmZlcmVudCwNCj4gPiByaWdodD8NCj4gPg0KPiANCj4gVGhlIGZhdWx0IGNvb2tp
ZSBpcyBtYW5hZ2VkIGJ5IHRoZSBjb2RlIHRoYXQgZGVsaXZlcnMgb3IgaGFuZGxlcyB0aGUNCj4g
ZmF1bHRzLiBUaGUgc3ZhIGFuZCBJT01NVUZEIHBhdGhzIGFyZSBleGNsdXNpdmUuDQo+IA0KDQp3
aGF0IGFib3V0IHNpb3Y/IEEgc2lvdi1jYXBhYmxlIGRldmljZSBjYW4gc3VwcG9ydCBzdmEgYW5k
IGlvbW11ZmQNCnNpbXVsdGFuZW91c2x5Lg0K
