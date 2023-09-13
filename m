Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D363779DE44
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 04:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbjIMC0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 22:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjIMC0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 22:26:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E76B1715;
        Tue, 12 Sep 2023 19:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694571957; x=1726107957;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xnWxuL/BqBxXcLFbrM8zSxOLk0b66pc6F9jkqlULa2o=;
  b=Y3OVUxPQIqBJrYklf2WmRDOaESxBnu6fdCujHGnOCKFkc3Umct7IPnhW
   uaAFjY/kSoeZXI/DXq6bmBl9e4XhK53bYfwh9B+kxWMJF0ckU50wkdPG3
   czEegRuuVZxPc+7IQNgtcZ09Hv0ZXrcafjueZgYIYJP4/JqY7ENlMFKIf
   pvSczDPURojTp3uA/5S5TMUmsh8ZRon3+TS+Lz1SoQ+UaXENPjzjkVg7j
   tnMxtXFFOldHgmNVZFgJeLrW70UFeo8wlY4k5x9rhSvIyDd+g64O2euhu
   DXwJ3e3+2U7lPOgBc9mgLCfwQvPsEgrL5OWpR/a7j/HilU0HLUUShOLLj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="358820648"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="358820648"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 19:25:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="1074779613"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="1074779613"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2023 19:25:57 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 19:25:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 19:25:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 12 Sep 2023 19:25:56 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 12 Sep 2023 19:25:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbjZQi279pvfX5y6jqRIjg0vV86lpGI72971hQYBTwjxAyqp+WZL+0pls1JShGJG02Ou0Coko+nWYZuvPR5DSQFWd+m5XAGMLSF7iY0IlR7TRLJUv1hfHl12lb9S2eNVziUmRD8BCsZsbcwO+ay8Yh3E9KwYwYhLxEXnirM+7RWClFayL/YqvOkf6JZRsgcIaIGCUburlbci088h6T69AP0POqn0185g16fjTiHEcH+fUusFw20pD3FQ+0qn1mB/2wHChCESXoRWlmRLPT6OBaPSgZQIXnC6ZpsddX7N4JfTRHSY2XaNLD+ikamjCKNzneDkenFcJeAQSPcuA9LdrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnWxuL/BqBxXcLFbrM8zSxOLk0b66pc6F9jkqlULa2o=;
 b=PV6dkfpwj2whj2y97WKt3bqAgTConGudwY1d7Ds1VYmIZpnfB5b2gRQz29UtUrCAOq82CgHjXbzlG+Am2i5+p3kBl43wT9nLDjRiqD2Jq+Rh74PE27hgwPljU0Jnd2NNEpBjwp65Kbul7TRmE0SaajDTZ6q+9s6Nn8GfJTz8Psmz8h/jX9g1tTjTfLmCtJgq5M7yNy7OivODNim5hBp17J2oBS8I8G754yke+f5o3FzTcgEyhRnljoWVnSo/G/TQtkhnlndIdL7S7l/03U4eR0HLc7TqqwvqXz1SYD2c8Uobfl+oWFovmvobvCCZEGoinNE8ZddOb1MOe66QF0GWhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5566.namprd11.prod.outlook.com (2603:10b6:5:39c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.38; Wed, 13 Sep
 2023 02:25:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.036; Wed, 13 Sep 2023
 02:25:54 +0000
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
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGRCACABkHzwIABseKAgAEiyiCABnOVAIAJgYCQgABjuQCAAnwtwA==
Date:   Wed, 13 Sep 2023 02:25:53 +0000
Message-ID: <BN9PR11MB5276CF3330478AFC4FD3C2768CF0A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <67aa00ae-01e6-0dd8-499f-279cb6df3ddd@linux.intel.com>
 <BN9PR11MB527610423B186F1C5E734A4B8CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <068e3e43-a5c9-596b-3d39-782b7893dbcc@linux.intel.com>
 <BN9PR11MB52768F9AEBC4BF39300E44478CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <926da2a0-6b3e-cb24-23d1-1d9bce93b997@linux.intel.com>
In-Reply-To: <926da2a0-6b3e-cb24-23d1-1d9bce93b997@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5566:EE_
x-ms-office365-filtering-correlation-id: 34598615-38fd-457b-6dab-08dbb400c15d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HAzI1NtFORwNxeh7GdsxcpYdNkPwbziesFp2M+g+0BXuFf4n5ii+og80Y4aqn+gxsWBAujm7KyufShQIiOvgH7Hs5EClulgYu+x+4lbpCTFurBdOqyuK3HI9AlougIzPb58crSz1WZtJiiTLi7N5uOD1USnngkMgZW5m8u5L2VHtYQ+UElMldga64VrB+ummFk4vrUURpXfo2ERq7XWWjddqoS09PluvoOjA4LoZBppeZBUgN6qTRvzltIjGF4oFD6fE0yMow8Ckd2myvYcZkLvr/vM/O7hNw7YrYfhPJ8P4D5kk7I9ZZevxmjJii95ZDKnlpBeDB7nPOe7O7YI57FLCcPbTlmksJAuvU6rMw03bZSD4euxsKuk0C16g7yRm7Zs4810KZSktjiv5/qC1D6kcURYjI5cEHzL+lVB4HNY+Psyc27OSe5/+oTZTMNNadeybNCZn6f0YvvI4LipfojbsLactw2C4YQAAGRIu7nxRZF1T8OF4a1mQ7K8dt0EM/1lv049a99Ybbbkqx24qhOkQX7+RqF0cg4wbCmW3mTWgfUGk2KMx3lE6ZsXJxUDIxJZREp6O07CjQIUe4I9HY1o8lXR1Mzx5mr1zYApPYiII3IA1z4bLy28qBVCHJ3Rq9dK//Fbh4KOza+hdRF6fcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(346002)(136003)(366004)(186009)(1800799009)(451199024)(38070700005)(9686003)(71200400001)(122000001)(7696005)(6506007)(38100700002)(82960400001)(83380400001)(41300700001)(478600001)(26005)(66476007)(64756008)(66556008)(54906003)(66446008)(66946007)(316002)(76116006)(110136005)(7416002)(5660300002)(4326008)(52536014)(8676002)(86362001)(8936002)(55016003)(33656002)(2906002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SE9JU3ZoM2NDdEFFdU5VdmJoeStZc2RwUVhndTh3NTdhNkJaN3EyS0lTTHcw?=
 =?utf-8?B?THFHbDlla0IvLzI5OVdpQ2xUd1BCbSs0b1duSGxFbittK211bi9KNG9rM0hD?=
 =?utf-8?B?MFlRcjJNYkFqVUg0MzF6dENkWTZhWm8ydGFYRnVjdURueGRjK1JtWTltY201?=
 =?utf-8?B?alV4UkhTc3laTW9zUEVIZlhJcFZxVkd4Z3ZlS2wzWThvSUVVTzYvSGFScE5L?=
 =?utf-8?B?dnR2YmI0enZRS3I1L0laRGllYTFGaXlTZzBKanBLNFNZcnVTZlVIUWllajM5?=
 =?utf-8?B?aTRiSGljQzZITVNvcFhlQVVlSHgwZVZiUnl0Z25VNHQ4YWNSNFU3anlEcHNw?=
 =?utf-8?B?dGZFL2pCc1RXRzRMZDI1NCtuaU9WZ3Boa014RFBSU2lzSmJRdDlETFIxOXdB?=
 =?utf-8?B?UWE3bGVLWXAxbTdwRStKcTBTbms1VWtlWVU2YUEvSnRhVzhOMk5sM292Z1VF?=
 =?utf-8?B?bUg5Z2FZbUtnSjVxczd5UFBWOUVVeDlFVjBSUXh1VlVnUk9yOTdGeXd3TnJH?=
 =?utf-8?B?NzFVMkVkazVFK3VmU0xGTzRtM1JvTXMrbDdjcW1COU9ZdUVtazhxamtGaWt0?=
 =?utf-8?B?WWhRK2d1T1RGOWxYMThGdFZWY2tiSmp5d09hUHFwbXJ4cG5tbVFUN0x0OE9o?=
 =?utf-8?B?bTRndHJQam8wbGZmU1VMaTI4MWo5ZDB6dGxaU3l1UVFqc2YxZ01zWWxvcWV2?=
 =?utf-8?B?ZENGMDdNRjNUMnNNak9JSXJXVGlVOGl4ZkFNcm15ZkVKenJLRlBnSUxnR1d2?=
 =?utf-8?B?eHBCeWZjdUlGS2dIVUtQU1dVS3Y4eGNxdEwzcnJrZTRLajdWVG5nUGdGU2pL?=
 =?utf-8?B?ZjlyRk1KQ25zZVB6WWJscnBiME9kNVFDWU9QM3h2amJXVHA5c09aRkVpNWdG?=
 =?utf-8?B?NkhNSHl6S3c2eG5wKzBrUGZnbWFzbWEwOEpyTHZ4ZC9VMlpNT2lBTzZRNk03?=
 =?utf-8?B?WVMwS01UaGRIWlRlZnZyYnBHcTFnR2lYb3VXOXN1V21LVVV1dklsUDErWWJ2?=
 =?utf-8?B?UmxOaUxKU1lMQm9Wc21vZEIrTDlwR0U5bGhscGJpQWQ4aUVlKzh0VDh4TURa?=
 =?utf-8?B?VHlreEFWNWk0V1V5T3g5cHpjbzJoYVlqQUkxWVJTVHhxM1k5cDZRbnphSmRq?=
 =?utf-8?B?c0dGYXZQN1FUbGN5NXMzNG9JMTNvNFpaZjhqT25iM3pRTkdOTFhBQy9tNVlw?=
 =?utf-8?B?QjVZUDNZc1hxMHpodFpPK0gvby9JaTJ2dXhRS2l0TkZwd0dqakFUTjV6ZlZw?=
 =?utf-8?B?dXBxOWx3ZTFIMmxxZDNJSWpuTFpjcHdTSS8rZStyc2RQZDNxbVlsNXdvM1dx?=
 =?utf-8?B?SmtLeE40YUFQQ0NxZUlKOEtBU1JyckJXK2haYnBhUzJ4YmZzZmJHcDVCVG0x?=
 =?utf-8?B?SWU3ZG4vVTZsbmwxT1MwTkNLQy9rblpyV0UyN0lwcy9IMmtUdGU2K1gvOVEy?=
 =?utf-8?B?RThUZUFzRTBmNWFLdEJQbUF0Q01ubnh5VWRqKzd2aHdQV3Y0bUdqN2JtMU13?=
 =?utf-8?B?Qy81V3BOME8xU1VzNXBmUVZWRC9Fc1NCOFNUZExlZ1JpSFQzdEQ4S1JCMjFO?=
 =?utf-8?B?ZXl1WENlNm1kbUszOHZaN0RqMGFmYk9uZ2t5UEdvYzF1MnA4S0VmUTVwU2t5?=
 =?utf-8?B?T3JMUGZ3L0RZeFJZMXNTNDU1aGtvMnlRVEswQ1ZyZWh6ZForbWpGd1NMUzJs?=
 =?utf-8?B?T0NudjAzWFdzZDRjbldhV29jZ3ZKRzF4ZlBpOTQ3ZXpIczRYN1pUNHEyanNQ?=
 =?utf-8?B?YzFkKzJ4TGN0SU8zT2xvSGtSNlluTGdZZkJBMHQ1bnBuZ0xGaTdDMnJ2R0I2?=
 =?utf-8?B?QnhKU0s0dllHOFBEQ2U1WTZXUmJhcFRjTW1zSk84ckNMK0FEQXJvSEEzS1F0?=
 =?utf-8?B?VS81SWhjelRBbHpiSUlpU3ZmcTZ4UFZGU3RYR0NlaXpZbGhuRE55MnE0K0t1?=
 =?utf-8?B?bml4dkhnTUV2YkhrcUVSYmJuNDZzeGJ3aEdQTFoxOTlzRUJWK2FIaDNGalhl?=
 =?utf-8?B?dmswbzBBU052eWczQnFNcEJLRGZUdFdoTmpPVHlqSitmMGlBZGZQVWFNbEJR?=
 =?utf-8?B?a3dncTg5VUtLaEpoc1BHSklWdnY1VmZibkpWdzljNklHNmtBb0NvTEJ5eFJG?=
 =?utf-8?Q?DZ/A/RlWqyfY1CkSiQ70mJLrm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34598615-38fd-457b-6dab-08dbb400c15d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2023 02:25:53.9688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ffDteodn9PsMi0UKYDtCwfaEd8veVatvmZugEliuNR5DGelbNqn5hXlF0mdjsGeoC3JtcbqAMTsymus9wcqNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5566
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBNb25k
YXksIFNlcHRlbWJlciAxMSwgMjAyMyA4OjI3IFBNDQo+IA0KPiA+DQo+ID4gT3V0IG9mIGN1cmlv
c2l0eS4gSXMgaXQgYSB2YWxpZCBjb25maWd1cmF0aW9uIHdoaWNoIGhhcw0KPiBSRVFVRVNUX1BB
U0lEX1ZBTElEDQo+ID4gc2V0IGJ1dCBSRVNQX1BBU0lEX1ZBTElEIGNsZWFyZWQ/IEknbSB1bmNs
ZWFyIHdoeSBhbm90aGVyIHJlc3BvbnNlDQo+ID4gZmxhZyBpcyByZXF1aXJlZCBiZXlvbmQgd2hh
dCB0aGUgcmVxdWVzdCBmbGFnIGhhcyB0b2xkLi4uDQo+IA0KPiBUaGlzIHNlZW1zIHRvIGhhdmUg
dW5jb3ZlcmVkIGEgYnVnIGluIFZULWQgZHJpdmVyLg0KPiANCj4gVGhlIFBDSWUgc3BlYyAoU2Vj
dGlvbiAxMC40LjIuMikgc3RhdGVzOg0KPiANCj4gIg0KPiBJZiBhIFBhZ2UgUmVxdWVzdCBoYXMg
YSBQQVNJRCwgdGhlIGNvcnJlc3BvbmRpbmcgUFJHIFJlc3BvbnNlIE1lc3NhZ2UNCj4gbWF5IG9w
dGlvbmFsbHkgY29udGFpbiBvbmUgYXMgd2VsbC4NCj4gDQo+IElmIHRoZSBQUkcgUmVzcG9uc2Ug
UEFTSUQgUmVxdWlyZWQgYml0IGlzIENsZWFyLCBQUkcgUmVzcG9uc2UgTWVzc2FnZXMNCj4gZG8g
bm90IGhhdmUgYSBQQVNJRC4gSWYgdGhlIFBSRyBSZXNwb25zZSBQQVNJRCBSZXF1aXJlZCBiaXQg
aXMgU2V0LCBQUkcNCj4gUmVzcG9uc2UgTWVzc2FnZXMgaGF2ZSBhIFBBU0lEIGlmIHRoZSBQYWdl
IFJlcXVlc3QgYWxzbyBoYWQgb25lLiBUaGUNCj4gRnVuY3Rpb24gaXMgcGVybWl0dGVkIHRvIHVz
ZSB0aGUgUEFTSUQgdmFsdWUgZnJvbSB0aGUgcHJlZml4IGluDQo+IGNvbmp1bmN0aW9uIHdpdGgg
dGhlIFBSRyBJbmRleCB0byBtYXRjaCByZXF1ZXN0cyBhbmQgcmVzcG9uc2VzLg0KPiAiDQo+IA0K
PiBUaGUgIlBSRyBSZXNwb25zZSBQQVNJRCBSZXF1aXJlZCBiaXQiIGlzIGEgcmVhZC1vbmx5IGZp
ZWxkIGluIHRoZSBQQ0kNCj4gcGFnZSByZXF1ZXN0IHN0YXR1cyByZWdpc3Rlci4gSXQgaXMgcmVw
cmVzZW50ZWQgYnkNCj4gInBkZXYtPnBhc2lkX3JlcXVpcmVkIi4NCj4gDQo+IFNvIGJlbG93IGNv
ZGUgaW4gVlQtZCBkcml2ZXIgaXMgbm90IGNvcnJlY3Q6DQo+IA0KPiA1NDIgc3RhdGljIGludCBp
bnRlbF9zdm1fcHJxX3JlcG9ydChzdHJ1Y3QgaW50ZWxfaW9tbXUgKmlvbW11LCBzdHJ1Y3QNCj4g
ZGV2aWNlICpkZXYsDQo+IDU0MyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVj
dCBwYWdlX3JlcV9kc2MgKmRlc2MpDQo+IDU0NCB7DQo+IA0KPiBbLi4uXQ0KPiANCj4gNTU2DQo+
IDU1NyAgICAgICAgIGlmIChkZXNjLT5scGlnKQ0KPiA1NTggICAgICAgICAgICAgICAgIGV2ZW50
LmZhdWx0LnBybS5mbGFncyB8PQ0KPiBJT01NVV9GQVVMVF9QQUdFX1JFUVVFU1RfTEFTVF9QQUdF
Ow0KPiA1NTkgICAgICAgICBpZiAoZGVzYy0+cGFzaWRfcHJlc2VudCkgew0KPiA1NjAgICAgICAg
ICAgICAgICAgIGV2ZW50LmZhdWx0LnBybS5mbGFncyB8PQ0KPiBJT01NVV9GQVVMVF9QQUdFX1JF
UVVFU1RfUEFTSURfVkFMSUQ7DQo+IDU2MSAgICAgICAgICAgICAgICAgZXZlbnQuZmF1bHQucHJt
LmZsYWdzIHw9DQo+IElPTU1VX0ZBVUxUX1BBR0VfUkVTUE9OU0VfTkVFRFNfUEFTSUQ7DQo+IDU2
MiAgICAgICAgIH0NCj4gWy4uLl0NCj4gDQo+IFRoZSByaWdodCBsb2dpYyBzaG91bGQgYmUNCj4g
DQo+IAlpZiAocGRldi0+cGFzaWRfcmVxdWlyZWQpDQo+IAkJZXZlbnQuZmF1bHQucHJtLmZsYWdz
IHw9DQo+IElPTU1VX0ZBVUxUX1BBR0VfUkVTUE9OU0VfTkVFRFNfUEFTSUQ7DQo+IA0KPiBUaG91
Z2h0cz8NCj4gDQoNCnllcywgaXQncyB0aGUgcmlnaHQgZml4LiBXZSBoYXZlbid0IHNlZW4gYW55
IGJ1ZyByZXBvcnQgcHJvYmFibHkgYmVjYXVzZQ0KYWxsIFNWTS1jYXBhYmxlIGRldmljZXMgaGF2
ZSBwYXNpZF9yZXF1aXJlZCBzZXQ/IPCfmIoNCg==
