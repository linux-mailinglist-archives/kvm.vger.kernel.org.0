Return-Path: <kvm+bounces-3289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA7A802B5A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 06:37:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E71291C209C7
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 05:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B6553A4;
	Mon,  4 Dec 2023 05:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GyqmBdxC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886DED6;
	Sun,  3 Dec 2023 21:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701668236; x=1733204236;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ClVWZUbztYQ6RcbVxIVyT0oHC8WD1ZmeQWKfpCWuRE0=;
  b=GyqmBdxC6gufzauqGmqClNxqmGI9OVu0u6BCPcqWh65/KUVFSSnJemzK
   Zs3+y7mF3VXn3Cw456m/jceg23MxjXLdnk/YYzxWT75CCI6HE2ThBVMr7
   t+R8YVb5VVrh5uWUCw36y4xA29h48/apWLJLq+v1LpAmALIXSdP27XTk2
   t1Nt3eS2IZyzQIwJi9O9YpiTUUAAJVJH0rOzwHLXE/GVonG0cxJwGMWoX
   ZCg1yngnpPXHvh1rXYDt1LKgD3LG3Wx2ZhBAXh4fcgUX4HzzcW3vNenGo
   uYkK9PabVNA3+e5u7/z6z9J2sB0OtaVO2h6Y+3sKUd+amBrAv7ADnmDhM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="7006987"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="7006987"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 21:37:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="1101975248"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="1101975248"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2023 21:37:15 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 3 Dec 2023 21:37:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 3 Dec 2023 21:37:15 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Sun, 3 Dec 2023 21:37:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fs2NYjfhY19Dk7kTho/JMupRSY2ZYhmqQiuiq8EkBE1VagwXe0ijJcLi+EOUh3LMFjtRyoGoZRZJn/+sef3n26i73AzHnQEmkmS1s9GY8iFdm1QD99JvF7vIZX8/r3tl/BFhOI87nVPtT7X/s2clJyxKk0SdjHxJ79Tl2ZB600Y2Yvf+Zl8QQvfcLRuYijh1J2jzdFBPxt/kL+0QJNK5Bg4F95Kguip8VyxKBU2ZYeHiQOo34bkCEkdCD3G2kYVS/IFrVrl2eLNz0S6qqAVXL22HLtKLGF+T78hiji5mZPjMTuwmYsvns70n9ENmTsSbDwfwx97q8y+iLpL4nThKbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClVWZUbztYQ6RcbVxIVyT0oHC8WD1ZmeQWKfpCWuRE0=;
 b=boQGdgEyoWexNUBBbg/ccOkXshO2y5pDXTdln+Djgk1cFeQF+yUvHUlVvy4DsO0NFnb+gunfTNbCOLWIuCu88ihkWPjREwkK4WWp65I7R5Asrzqw5i4C9gG409QqulKQa3G8LmgufLn5YkIEX6ZDj8mOlWK8O8gqXKinc9XfL6XzcdF9SaP7dfhQECch2gm2+6H1ibPFcah9lptVBvwsgybXi3LZvMnvFV+yJjrN0EgznnZquQUROhwTr8i9wfrbkfvASIVGfwne4FKOVKkBx66XINdwJNXWPeed3QXfFALTvoD/yxaOHJYFffPCBLY6uUEKNVJTN3YO28TaxcgVtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7267.namprd11.prod.outlook.com (2603:10b6:930:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 05:37:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 05:37:13 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
CC: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Topic: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Index: AQHaF3Dgz31tJTFbWk6dNEVbu0BBIbCU/P4AgAJgZgCAAFm2AIAAvYqAgAA+r0A=
Date: Mon, 4 Dec 2023 05:37:13 +0000
Message-ID: <BN9PR11MB5276999D29A133F33C3C4FEA8C86A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>
 <20231203141414.GJ1489931@ziepe.ca>
 <2354dd69-0179-4689-bc35-f4bf4ea5a886@linux.intel.com>
In-Reply-To: <2354dd69-0179-4689-bc35-f4bf4ea5a886@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7267:EE_
x-ms-office365-filtering-correlation-id: 19f942eb-b7d8-4688-8c9f-08dbf48b1150
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WBVzugm/XmE81hB3A2fffIxedVad7B+EpeAiQ7R90v0PiPptI7vNoL92p8K1il2sfVKZDadiunV1XUYkkIMryk2HL/YhOw5T9nSCnklz2paz/DT/1IbWDWruOZjBmrbWHrs7N/b7lTshrO/gtdDu1Fb+UJh4utTmHrGPl6/myKJOf0tOLdr+JjKknsGOlgMfN+Y1ge44nlGaLXzUazXHy34jNBM6rDKH04/fR5tPRXPi9BSDdwhR7QPC8Ljy9ISysDkZlV0gvPbL8sZrEinvxqCTXNBXq4S4kyRJPfLGWu74CjwR3lxEoc636J1FOpvppAyrkkO4a/XKNqOClWfhI/Ut5TY3eS0juPSBWYzrwK/t2vnv1e6UxL6Xdm8VQD+V0qg9fsFNpF1OqNbKM20Koc4Tw9+P3x8V2wWLHLpnzdAAGYoXySyNFfIr1sPvl5O0OFf8EBW7i5rzvrNuR3AkjuI7ASbbk2xxPlFBLrxAKqPffrZIK7p/hdbsA/RMvXW/n+cCdFRdjhuXbxBLI320gm0j1+C1b8flhpzWTABMOpNHaZmJoumxu+13W5SumhaOJ5LNGCPHq3esjDjIADA50bMwUm/JDxGbRvLiThksac774qr8QJpLYJaRob+MTdWW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(366004)(346002)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(5660300002)(52536014)(7416002)(86362001)(4326008)(8676002)(8936002)(2906002)(38070700009)(41300700001)(33656002)(9686003)(6506007)(53546011)(82960400001)(83380400001)(26005)(478600001)(7696005)(71200400001)(38100700002)(55016003)(122000001)(110136005)(316002)(54906003)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlNSUDBTYzErd2Y1VHVKKzk1TDRkalI1NUE4ZUF3WWdvMmZCVS9NSzg2UlRY?=
 =?utf-8?B?TzMxVVduZC9BNTNYRlhvTWZ3aENIL0d0ZnQ2VmJOQk9ISjFyVGlFMEo3c2VO?=
 =?utf-8?B?ZS85YXpwcm5qU0g0QUxIMmIrTjA1NTBaWit3Q3pjd1FseTNBb0NkemFURGs1?=
 =?utf-8?B?UnRzQUd6M01yK1pCYk0yZUFUZEIveER1UFoxMnYrTUo5ZnkvbFQ0SjQyMzdo?=
 =?utf-8?B?eStHd3M2dGFXbFlDcDlISDUxcWxuamU1VmZQeW1yelZVbW9HSFpFQ1drSzF6?=
 =?utf-8?B?b0w5K09LWjIxVzcxdUMvRlJPSTBMQ1RnS2xFcUs5VDV5OFlWMDVnUzY3WUxs?=
 =?utf-8?B?bCt6czhFOWhGZ2JkYU5FaEtqaGlISUMraXA4MUpMUWlFZXhkQzlUY1VwTk9w?=
 =?utf-8?B?ZkhtUmxYdlZrVGdYUXZWa0xYVnpoMGYzcmJzdWxVWlU4UmVUTStiV3J3YkRi?=
 =?utf-8?B?YnpDeWtQQlRtV3cxME1CSW1qM0o2N0RkTlc5RW5xdkE2UlorSytSMGxSUE5U?=
 =?utf-8?B?bnJUa0JvMXBWN2swNUFtRlRqcGcrRGJ0QitzbFBYZmI5WGRNR01PeTlaZFEx?=
 =?utf-8?B?bGEzOVE2SmptbkRNMUlNTGdvSUhpOTJnYi9uNmJVZ0pYV1c0TWRQTFJrUk9C?=
 =?utf-8?B?L1p0V0VhOFlXdUxsOHV0ZzFWL2pjcjBXVXJwdEVvK2VGYi96VWR1Q3BaTTRq?=
 =?utf-8?B?VmoweERxN0svaGJhT0lDS2t6ZGEzKytLTFlELzBld3p0S204MDNJUFBCbEhn?=
 =?utf-8?B?dW5mYnlQbUxKbW12SWZjanpKNjhYOWxYdS9rRUhUdEhGRzZGNldXM3VmRms3?=
 =?utf-8?B?dnM3WUM3cDRkZzBBNTdzbk9OS3Z5MFMyVDV5aUo2Z2NUMVBrdzkyZmpUaFI3?=
 =?utf-8?B?MlpuZnVkNWh6SkR2SHZkZW9nUnovMzlEUjhxYTlGZXlCa0dOQVduMDhQVzd3?=
 =?utf-8?B?dm1yQjZzRXNGZmM0NUpkQkdMM1dFcU81L1hGQWhpeU9HTEpEcnVNY3FLUTdr?=
 =?utf-8?B?NmkzM1I1U3RjSlorbngyUXVMS2RUdWN1TEN2Si9HelhtSGg2VzdnNGs0eUdP?=
 =?utf-8?B?cTdtYXViMkZwZk4zeURzSU5zVU9EOVhTSkluK2w0R0hkcGswK0ZvTDI4emZX?=
 =?utf-8?B?dm5wSUcvMWFOYzRhcXZXSDdkcDFIaUNhckFTSFJuSG40b01NcW8xVjVTaGk0?=
 =?utf-8?B?R09UYTR6emwwb3FVQ0RoRUdUNk5HOVI1TVFHQVRMblI2SnpiZTQ2clZsREI5?=
 =?utf-8?B?SXZ5cDBvd1puSkJqcWl2QS9sWFpwSnVTQzFzbVBUNm5ySDFVbVVPS0JXVDcz?=
 =?utf-8?B?SGM2eHVGRHZyVjlBbmF1SWtuZ1FQdzlaRkRlTTZmSFR0b1BKOUNyNDZJZzVw?=
 =?utf-8?B?eG9qODB5WHJwSzZiWXhqY05zNysxUlRNcTJnalpERGYwaFhDQkdCdVFveGdL?=
 =?utf-8?B?NGVwTVB6cUNzcjM2bFBpd0hzZHdFcjU0Ti81TkJTRDBKMVpKM0MzVUdtUUkz?=
 =?utf-8?B?UnFrZ0M3UkF2bXZSTDFvRXVoQit6L0tuQ0lTcE9ib1FKdFl5WWtZeUlJSnVO?=
 =?utf-8?B?ejdqWHV3VUY4c3pnTWNHZVE3Z2hxa3FkQ25wTVhCRUw2MmZDRnBpSDlOeXJG?=
 =?utf-8?B?VGdtMVU1TitPR1gvczh2VmkyczVOc1NBcFJrSFVlbldKdFIzKyttd1VwcHUy?=
 =?utf-8?B?MjR2TVAxSTBCbFRoalNZUFJvMFBFaTUxYldYd1d0c0ZBWnU1OUw3VXNLbXpp?=
 =?utf-8?B?eTFyanJwZk9KYjc0bDVxaUJML0pybEtUckFkSHFCZHR5UnExalF4YUpjWCtO?=
 =?utf-8?B?OE9iWXFJMlNpcUhFSHVLTzU1RS9WSWNXeG56L0M5OXZVcmlwUzlQeFpCZXdM?=
 =?utf-8?B?ZGc3TmRJTXhPaEd1KzA5YnpWcUpwem96SVJJOXE3bnR4bHdRd0UyVGsrc0ox?=
 =?utf-8?B?Q0QzbGtWWldXN2pMOGpsRWczbngrNXNXbWJYblI5MWV5N0ZaQ0dnV09yRGNW?=
 =?utf-8?B?ZHNWb0FmNXBrQW0wUnl2QXpVdTRZM2p5N1hoZnBUdXd1bUp4VHNyS0QxMkIx?=
 =?utf-8?B?OUsrTDZzdWdGTitBaHp6RnB1d2kvL2tCcmd4TGRTWWYrOTY1eXk1SHZTbjh0?=
 =?utf-8?Q?TaWCF/zJL5G7h0YoPqSFki/24?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f942eb-b7d8-4688-8c9f-08dbf48b1150
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 05:37:13.0586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jpQnAXq4X/qyQpvTXq5yp4N2xaiOt1gJeavF4J0tTGPc8zncEand2CZuRAYiuY5nXhx8M6slBW8h0H3MKGE6gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7267
X-OriginatorOrg: intel.com

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBNb25k
YXksIERlY2VtYmVyIDQsIDIwMjMgOTozMyBBTQ0KPiANCj4gT24gMTIvMy8yMyAxMDoxNCBQTSwg
SmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+IE9uIFN1biwgRGVjIDAzLCAyMDIzIGF0IDA0OjUz
OjA4UE0gKzA4MDAsIEJhb2x1IEx1IHdyb3RlOg0KPiA+PiBFdmVuIGlmIGF0b21pYyByZXBsYWNl
bWVudCB3ZXJlIHRvIGJlIGltcGxlbWVudGVkLA0KPiA+PiBpdCB3b3VsZCBiZSBuZWNlc3Nhcnkg
dG8gZW5zdXJlIHRoYXQgYWxsIHRyYW5zbGF0aW9uIHJlcXVlc3RzLA0KPiA+PiB0cmFuc2xhdGVk
IHJlcXVlc3RzLCBwYWdlIHJlcXVlc3RzIGFuZCByZXNwb25zZXMgZm9yIHRoZSBvbGQgZG9tYWlu
IGFyZQ0KPiA+PiBkcmFpbmVkIGJlZm9yZSBzd2l0Y2hpbmcgdG8gdGhlIG5ldyBkb21haW4uDQo+
ID4NCj4gPiBBZ2Fpbiwgbm8gaXQgaXNuJ3QgcmVxdWlyZWQuDQo+ID4NCj4gPiBSZXF1ZXN0cyBz
aW1wbHkgaGF2ZSB0byBjb250aW51ZSB0byBiZSBhY2tlZCwgaXQgZG9lc24ndCBtYXR0ZXIgaWYN
Cj4gPiB0aGV5IGFyZSBhY2tlZCBhZ2FpbnN0IHRoZSB3cm9uZyBkb21haW4gYmVjYXVzZSB0aGUg
ZGV2aWNlIHdpbGwgc2ltcGx5DQo+ID4gcmUtaXNzdWUgdGhlbS4uDQo+IA0KPiBBaCEgSSBzdGFy
dCB0byBnZXQgeW91ciBwb2ludCBub3cuDQo+IA0KPiBFdmVuIGEgcGFnZSBmYXVsdCByZXNwb25z
ZSBpcyBwb3N0cG9uZWQgdG8gYSBuZXcgYWRkcmVzcyBzcGFjZSwgd2hpY2gNCj4gcG9zc2libHkg
YmUgYW5vdGhlciBhZGRyZXNzIHNwYWNlIG9yIGhhcmR3YXJlIGJsb2NraW5nIHN0YXRlLCB0aGUN
Cj4gaGFyZHdhcmUganVzdCByZXRyaWVzLg0KDQppZiBibG9ja2luZyB0aGVuIHRoZSBkZXZpY2Ug
c2hvdWxkbid0IHJldHJ5Lg0KDQpidHcgaWYgYSBzdGFsZSByZXF1ZXN0IHRhcmdldHMgYW4gdmly
dHVhbCBhZGRyZXNzIHdoaWNoIGlzIG91dHNpZGUgb2YgdGhlDQp2YWxpZCBWTUEncyBvZiB0aGUg
bmV3IGFkZHJlc3Mgc3BhY2UgdGhlbiB2aXNpYmxlIHNpZGUtZWZmZWN0IHdpbGwNCmJlIGluY3Vy
cmVkIGluIGhhbmRsZV9tbV9mYXVsdCgpIG9uIHRoZSBuZXcgc3BhY2UuIElzIGl0IGRlc2lyZWQ/
DQoNCk9yIGlmIGEgcGVuZGluZyByZXNwb25zZSBjYXJyaWVzIGFuIGVycm9yIGNvZGUgKEludmFs
aWQgUmVxdWVzdCkgZnJvbQ0KdGhlIG9sZCBhZGRyZXNzIHNwYWNlIGlzIHJlY2VpdmVkIGJ5IHRo
ZSBkZXZpY2Ugd2hlbiB0aGUgbmV3IGFkZHJlc3MNCnNwYWNlIGlzIGFscmVhZHkgYWN0aXZhdGVk
LCB0aGUgaGFyZHdhcmUgd2lsbCByZXBvcnQgYW4gZXJyb3IgZXZlbg0KdGhvdWdoIHRoZXJlIG1p
Z2h0IGJlIGEgdmFsaWQgbWFwcGluZyBpbiB0aGUgbmV3IHNwYWNlLg0KDQo+IA0KPiBBcyBsb25n
IGFzIHdlIGZsdXNoZXMgYWxsIGNhY2hlcyAoSU9UTEIgYW5kIGRldmljZSBUTEIpIGR1cmluZw0K
PiBzd2l0Y2hpbmcsIHRoZSBtYXBwaW5ncyBvZiB0aGUgb2xkIGRvbWFpbiB3b24ndCBsZWFrLiBT
byBpdCdzIHNhZmUgdG8NCj4ga2VlcCBwYWdlIHJlcXVlc3RzIHRoZXJlLg0KPiANCg0KSSBkb24n
dCB0aGluayBhdG9taWMgcmVwbGFjZSBpcyB0aGUgbWFpbiB1c2FnZSBmb3IgdGhpcyBkcmFpbmlu
ZyANCnJlcXVpcmVtZW50LiBJbnN0ZWFkIEknbSBtb3JlIGludGVyZXN0ZWQgaW4gdGhlIGJhc2lj
IHBvcHVsYXIgdXNhZ2U6IA0KYXR0YWNoLWRldGFjaC1hdHRhY2ggYW5kIG5vdCBjb252aW5jZWQg
dGhhdCBubyBkcmFpbmluZyBpcyByZXF1aXJlZA0KYmV0d2VlbiBpb21tdS9kZXZpY2UgdG8gYXZv
aWQgaW50ZXJmZXJlbmNlIGJldHdlZW4gYWN0aXZpdGllcw0KZnJvbSBvbGQvbmV3IGFkZHJlc3Mg
c3BhY2UuDQo=

