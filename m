Return-Path: <kvm+bounces-24116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB3095168F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7FC41F23288
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E9513D524;
	Wed, 14 Aug 2024 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2bzV/nG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F924D8A8
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723623968; cv=fail; b=fkEmF7i7INJhie9iOPZbeb59XJMGb1XgkMHqBmi6y7xSCVnGHxNurl2IQkKLTlBVR8slC+BnG/op7QRdESYL2GSVf766TuHN9R6v5nNlg/mU7i8P991CX9SQi/8n4QnRUMq6M1wM0AnPLxiLJ7E1UlMM/au/WqqvHvfrItGCaik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723623968; c=relaxed/simple;
	bh=BDNwPy82SEz1KY+2TxBO2FXB7sCaybJ6v6IGLLYU7u8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uRY3HKASFmYUNaX51wjl+yF8eZ9f+0EjIKMw+Lsgmdh6RVkf9vZqIzkuLCLWjf/lTAcpFxfhwfEYzVMjVH5k2wv+xrloieyoSCR6rVYKfXGuQYQSPNeCQJTM5Jqo5nAo3iCmurSzgRvPelpHRvD2tDYemDAbxKYGFnc/V+6PyLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2bzV/nG; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723623966; x=1755159966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BDNwPy82SEz1KY+2TxBO2FXB7sCaybJ6v6IGLLYU7u8=;
  b=j2bzV/nGPyl2SZio/vta/7SIYkvls3dFCvKyiKWhA+JTBg0sRzJzMTb7
   JqkzQrsA34r6hnQ+rzxcJcY02Ce2KWGqLq93oJHi6X4p/TH4BQ4Tl3Xe4
   eF49k2QtsCRIk+kDa1mriam9pAbF8Gtc1ZTuiMVnACoiDKHwkXcx5G+ix
   lcQ4RKpDJuPlV8y+hfbiNraRa72I23GcSuco5FU22GfMnZWBS6KlV/rfp
   sRQoE+wkKr4GxJIEVMQZa0UC3TCxV/f+aECJp0isBIexsu0l+6gNeMyK3
   lMZMEKzMM5vOot5BbYUKzzuIxk2+769xz33FypFJ5Dj4Tnu8Q1jaMbudK
   g==;
X-CSE-ConnectionGUID: fxRFtL7ASlO2zOIUVuv7Pw==
X-CSE-MsgGUID: 0O/XTSSrTzGcGO2IqDem5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25687429"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25687429"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:26:04 -0700
X-CSE-ConnectionGUID: /LkYr7RcSxiAId/qOyHOPw==
X-CSE-MsgGUID: H8sWuzzFQYiaLp9FlMsISw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59508005"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 01:26:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 01:26:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 01:26:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 01:26:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M51TXwCKd4tqhfgrDCCTBHHUxhUaGqd9+2lKJAqROC48CZ/VqjSHKtYLhJQsGFRaSsseI7r4lQZlJbIj6pKNxdc7pC0FWyBcDtC7R8MzyE7xqK4XelfEDLoVBXkkbQ/jzQXpTh04iH/F7aav8BAQ0duFJVqFH11hDtw+BKSva0bjq3mXRYR710NaFP+x8kJkTzl44Dgv416Pfst3VxHAd0KdaySwF5VQJiz6BmdXRsvkNKIVRGLLG5buH/+8YXC+8IJ7AFbL4Jop4glZpw71I4cBDw0C8w6mv7UHwAK33v4lSBgsoj8NOPX89LxvbuLtVOvUITGpYmM4fmoHQKX65w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDNwPy82SEz1KY+2TxBO2FXB7sCaybJ6v6IGLLYU7u8=;
 b=QY0zR+idvkh05wxx/TnneT+hPBZWp2lGydjsy4qwr1eSvMsP2ek1PDhllQiREq51E/15CcYTwqbkqkJw5l4DnbZhpcR/ohttXQBFSGetBSqqiyF3qd3L4dIcxAd0DtCty9JL++hrWOrseBhgg/ymMARG/lC5/cB+/a3UVX/EdrBGBtyQsmW7iEO6Vto4zGli2prEAo25G99nhQ7wczTvDQsOO5GQnlGCX2XEih2HDFHJoCphWUigGKoJuvZtXJaO2MqjtM3OBZT6EMWs3fvVoeudJmyuGVqcKZAwIw6bthwEsmBLfxduyz8TtaSWT/y1h7cwavqzG0QVoW7qBTF1uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB8084.namprd11.prod.outlook.com (2603:10b6:8:158::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Wed, 14 Aug
 2024 08:26:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7828.031; Wed, 14 Aug 2024
 08:26:00 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@redhat.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfAgAAM8ICAATEtgIAAA00AgAAbNoCAAr9fgIAAZVAAgASNTwCAhOTNIIALrw6AgACT05CAAPXvAIAA2q0AgAJglQCAA7rsIIACSgqAgAwRjgCAAAv6AIAAEBmAgAAAMZA=
Date: Wed, 14 Aug 2024 08:26:00 +0000
Message-ID: <BN9PR11MB5276EBDD8640DB98C9C737FE8C872@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
In-Reply-To: <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB8084:EE_
x-ms-office365-filtering-correlation-id: ba4d4f07-0803-45ba-0505-08dcbc3aba88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U3FsaGEyMThkK2RHZmZXOE5ZSVFoUlo2WmRRMzk4UE8vU21VNHZ3TUZaenIx?=
 =?utf-8?B?bENnbTVzMHhHY3Nua2ozaU9JWVN2YTFJOU5tTjJnUitlQ0tpT0tkcVlBK1J1?=
 =?utf-8?B?WHRjaTd5Y3R1VmVwUUVHelpwYVMxMGxiUDdUaDk3aG9oOXBEamZUU3dnOUxy?=
 =?utf-8?B?Qnk4akVJOXBKRFVFZWFHUlMwc0cvM2l3TlRIK1JlYTZjSG5wMjBLd3BBMzVW?=
 =?utf-8?B?YjRQRldpWWxQQ2NScWs2YVFlS2dmMEZPdlpUZEFMWHZRdVN1THJRZ2pMc1Ny?=
 =?utf-8?B?TEFtTVV4Qk1YSUpnYlJqdVRKMFpjM3dpZ2puamJYMWNYTjI0T1Jic011MGgx?=
 =?utf-8?B?eHBZdEc0NGdmbEVuZCtmdEx6bGFwSVN1UGYzSzJIOExjaEg3VE84MThZc0Zj?=
 =?utf-8?B?WDFKbE51aFBtTmcxOW5JekxFSFdLR1pzVDE0VWx5RkVwSFdQdW5ncFNMY2Z4?=
 =?utf-8?B?c1k3Vmp0WjQvblltN0dlSmFMRHRsc3RxaWJ4M2E4R05lZEFRbnpwQ0RKL0Q3?=
 =?utf-8?B?SWpydGtZSnJ3UEFpY0FXMkRRNWdtdlNRSDlyYmhUQlNmYlU4TVE2aE55Tmxq?=
 =?utf-8?B?eXhUUjVRMEFxY2lSU2NJZW1CSm5ZMkphblBxUmR1SktoelBEcUtjS0VEM1d6?=
 =?utf-8?B?LzdYRnJlNWRvblNLbjVpWDNvb3N2V0JUbU40VlFVcGlEQkxqb0lBTFEvd0hQ?=
 =?utf-8?B?c3dYa2lQNVVONm9tTTN3cXdjNVZPSGtTOU4zd2kvWmJOTnRSRkZzcTNoRkNl?=
 =?utf-8?B?MmpVV0xMMzhLSDY4QWxXZjZPdkFaSUJ2K1AwR2JpcFAxOWVkWHFIRGZQNnJZ?=
 =?utf-8?B?YWJxLzErT1QySm5mcE9kZ3lFODhudnhKOS85ektVUTkxUDBlM3F0M1FSQkNR?=
 =?utf-8?B?RDBiQnN5TXpXTUthemlZOVZoRDc2T1l4a0RzdXVUT25yK3BNbzAxTlF4OG1Y?=
 =?utf-8?B?dWJRRnY5dDh1NVhIdGVudFB4NjlteEV4YklMRzVxK0xSek1hcmxlWjE1WjV3?=
 =?utf-8?B?ZnpSOU1GdVYwQTFKTHhVRUpjYktuRmU0anRQNGxwODl6OUJsenZyN2JReVJr?=
 =?utf-8?B?L3RVUEZ1MnR4TW9qcXM5STZCZVJmcFo1bWRiWEw1THU5RWErRWg0S3NJQ3RE?=
 =?utf-8?B?ejd6NTlYOHdMQkw2MzRyQzYxVnNiZCtUaEZqTituVmZWQnIzeTM2TzBickhG?=
 =?utf-8?B?RnAwQ0krNFFkR0c3Z0cxOWpSeFlGbDRMa3k1VjdndlRlZ0U3emg3bHV2V3Av?=
 =?utf-8?B?c3EwMEdabk4xaHc5VUczNWZ5Q1VvaWd5NXdJR1hzc1c4N1VNTkZvRFpKT0s0?=
 =?utf-8?B?RlB3MXR6bGhPazFiZk1jQkJMNGpMOHBsU0RWcVEzOE9lL3FxZFoxT0lVMVdT?=
 =?utf-8?B?cjVHM05GQlhTTm5KYS9sUVlXZ1dtSFhSKzZIRFdMS3ZBSVl2dFVQSDlKLzcx?=
 =?utf-8?B?cHRGYm5UM1BEVU4wV0RzckFoMVRzV2RwRGFIUDdlZnRxcVRkSmgzdlZranNz?=
 =?utf-8?B?aVdjMUY5RmN4dkhsYlJObXIvR2d5WVpXNUl1WEwxRXBRay9VRHFTcEc3aUpN?=
 =?utf-8?B?K01ZWkYzTXFBaHV0eHd5MFNkeHBIU21IR1lCT1VMaTNvVm8vVDBpcmlUUk9C?=
 =?utf-8?B?Q1dJNkl2RGRTYnFQRTZaL3dOSWsvK250VUg0YjFuSElLTTYvdVJvTHpaajU0?=
 =?utf-8?B?RE0yemJydWlkU2RSemVNRENjU2VVQkh3WTdRQjBLSzVMV0ppUVl4WC90M2Nw?=
 =?utf-8?B?Ky8zU2M0b1g4ZGRLRVpMSW96M281QmhVY2ZyZjdlbVJGTlM5L1RHbnN1Rmls?=
 =?utf-8?B?UVpIN2ljRlBWcXBrdVN5ckhFZ1JadVhzNDlTbkc0T25icFNySldsTUg1R2or?=
 =?utf-8?B?Ris0azYzeWZqQUplQW1ZVXRMVXI2bStzdGlWaG9jR2tzdWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlRWM1htY0FkejdpM3RoQnBMVkowSFhlM2c2cUI0OW9Tc2NtejczNUhNVmpv?=
 =?utf-8?B?YlI0MzRXNnNpSEw3NzhjUjV1MW9GblBwb0V2UzFUdFRBa2FHd0dUVjZXU2xJ?=
 =?utf-8?B?NThYa1BIYzBlaFU5cDR6dStsTEtnWnBreENTWDY0Z0NnRGgyc28xSU5iRDNz?=
 =?utf-8?B?Wmc3TCtlOGNnQks1OXR1KzZsV09MQXgzS2MvWUx1RXN4MHU2Z2U3OFk2Q1lX?=
 =?utf-8?B?dy8yNVJKZWswa1VCRk9KU08yRUhHZWNlUWY3cWphdlU1SnZFcHpxWm14bllF?=
 =?utf-8?B?TFlGYmluVGwxSDQzV2pjLzh4TUp6a2F3aGptTjBpeHZXZWNMaktlODlkdGxu?=
 =?utf-8?B?cnh5U3RWZTFLeXNCcHNCT0dqSG53dE0ra0xjcDJkUWl4aXlvU2MreWdTdDRz?=
 =?utf-8?B?dFhiOW42TlBMTXl6Z3FheGxROUNhb050anRoVkpmS2pnVUJ4RnZIQUlIdnI3?=
 =?utf-8?B?TmRjTC9QV1Vnb0RGckRrOFlQMXQwRlUvTytTdVp2QWI4RCtuTGFxaWJYL1FD?=
 =?utf-8?B?aU5kWkcwSEIzcVQxd0hsYnBxMTJwWDBVdDYrbjVaV2ViUElZMklzbndETktO?=
 =?utf-8?B?MU9raUhOUXdIeHdkcUZRVGhPYkJWZDVHMXQ0R3loUUdyakdVRDFPQ3ZCL2NP?=
 =?utf-8?B?dDllZ2prTzBMRkJvNCtKak1yZDNjNnhUa21GcDR5YTEvckNhQk1zRXdWTXNp?=
 =?utf-8?B?bjVTVk9JWXR0dFhoNTVzc2pmb0tkclgzRjR0L2xwaDZkbFdNMWZTanRDMlhj?=
 =?utf-8?B?L1dLWlI2dzFJZTRuZnNyaHY5TVFsUTAzZzJtb2I1UUJIeStkMFBnZGgwcjhh?=
 =?utf-8?B?M3E1Q0hnTGcrME5RWjl5dzExakhrd1puTm1wZ3hUTGg0ZkJLNXQ1Yi9LSG14?=
 =?utf-8?B?OXQ5V1Y1T0RFb1RQRE1wY1hMUTV0L3g5bWlTeFI4bkdLM0dnMFU5eXQ0V1Nv?=
 =?utf-8?B?MTRlQ0V1ZVdxKzFzYituaDZmTjFXQnExVjgwK3FhcXdIM0toVTR1amRwZC9M?=
 =?utf-8?B?ZW9YWFRxblFvQ0krVUNJbjdjbDU2SzhEUEhKblpZOGo1cmQvRVdYUURQcG01?=
 =?utf-8?B?ZElkb3JHK1U5a3g3NDZnSFRxaWNBRTUwbi84bGlMN1Rudm5mbHFWRVh6MjZM?=
 =?utf-8?B?MnJ4bW1LQ1l0TjZmWllsUHoxYmc5b1ZvZGhKdVNkZGZNZnVjVS81SjF4WUY5?=
 =?utf-8?B?a2szV2NoSFIzYUcrRWMyZkVLOHA3TmhFb2FJdmwxelpPMTR3WTlrckNpa3h4?=
 =?utf-8?B?Q3QyOElFMnFFTWpCMXc2OEFoOGJQWk9xNFh1SFkrV2s0NndGWjlqdGcxclpI?=
 =?utf-8?B?NlRmbFZOckhXbm9qTEVNUjBRalpPWjMxWU1TTUd3blZORk9meWZWcFM1NDBo?=
 =?utf-8?B?MjA2Ukg4bmNXeDhOR245K1IxbTEzVmlzWDNGWUgzdUplazJRWVpsc21OaE9J?=
 =?utf-8?B?enVkOXJnNnMxdGhDL2MxL2dEeXYvV0dXU0RLSGovMTVWNHA1dnI0VW5Yc2s4?=
 =?utf-8?B?UUN0N1hkNHgyNWVKMUZyM2U0QzAwa1h4enIxLzRFemZzZ0o4dkNyc2txSHFX?=
 =?utf-8?B?WHhrTzZxNkNRdmQ4dURlMjVxczNYRXlzbFhLTmk0aWhzSmtpTWd2REhHSFJ2?=
 =?utf-8?B?RGs5eDJLNGtWVjJaTUxUcm5MTVdDKzhCZzREaDlHWUhSSFZlOGxRMU1FdjJz?=
 =?utf-8?B?THFDYzNTZUFmWHhVQ0hIa0dsV2NlSE9VMkovb1cyakdHTFkrb1BwaFBjU21I?=
 =?utf-8?B?OEprUEk3TzBlaU9uTit5OUQ5OHZRT2ZNaUN6bTBqcnFXdHR1T2xFT05CdVkz?=
 =?utf-8?B?Y0p2ZnkrL2xpendGNHZOdE1MWWVmRFRYNFhyM1RYK1BxYUlmaUNwYVpFMWNl?=
 =?utf-8?B?OFZMR0QvbmErQTlaMjNuZWU4blVNMFkxRzlNeWRBZkdweEUybHZ2V1FkTjZQ?=
 =?utf-8?B?dDlYTk9NdUJRaERKSGhnQ2hKSm5SSjV1cm51SHJPZjRPWXBOQmtiakU4N1NP?=
 =?utf-8?B?bjE1bjRPT0FzQUN4Y1QzSUMwM2l1c3dGazYyK1V4MkFNWnVEbWdpVGVOODFN?=
 =?utf-8?B?UjNQNUxVek5admNObk1TaW13K2VUTDN5dDc1MUxzTi9ja2tNYitYNHFqaEJM?=
 =?utf-8?Q?1cjtDGu5oPc/ci6MVvkBFKu+t?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4d4f07-0803-45ba-0505-08dcbc3aba88
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2024 08:26:00.3329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t1Jyu1yBs4TgN1q0/4y7QpUYnff5Cb6KSZt8p39/vZOzILygJxOBzvQ9ylL1V2YJbS8j1Uu0jw7F9khEVxkABw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8084
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBBdWd1c3QgMTQsIDIwMjQgNDoxOSBQTQ0KPiANCj4gT24gMjAyNC84LzE0IDE1OjM4LCBUaWFu
LCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+
DQo+ID4+IFNlbnQ6IFdlZG5lc2RheSwgQXVndXN0IDE0LCAyMDI0IDI6MzkgUE0NCj4gPj4NCj4g
Pj4gT24gMjAyNC84LzYgMjI6MjAsIEphc29uIEd1bnRob3JwZSB3cm90ZToNCj4gPj4+IE9uIE1v
biwgQXVnIDA1LCAyMDI0IGF0IDA1OjM1OjE3QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0K
PiA+Pj4NCj4gPj4+PiBPa2F5LiBXaXRoIHRoYXQgSSBlZGl0ZWQgbXkgZWFybGllciByZXBseSBh
IGJpdCBieSByZW1vdmluZyB0aGUgbm90ZQ0KPiA+Pj4+IG9mIGNtZGxpbmUgb3B0aW9uLCBhZGRp
bmcgRFZTRUMgcG9zc2liaWxpdHksIGFuZCBtYWtpbmcgaXQgY2xlYXIgdGhhdA0KPiA+Pj4+IHRo
ZSBQQVNJRCBvcHRpb24gaXMgaW4gdklPTU1VOg0KPiA+Pj4+DQo+ID4+Pj4gIg0KPiA+Pj4+IE92
ZXJhbGwgdGhpcyBzb3VuZHMgYSBmZWFzaWJsZSBwYXRoIHRvIG1vdmUgZm9yd2FyZCAtIHN0YXJ0
aW5nIHdpdGgNCj4gPj4+PiB0aGUgVk1NIHRvIGZpbmQgdGhlIGdhcCBhdXRvbWF0aWNhbGx5IGlm
IFBBU0lEIGlzIG9wdGVkIGluIHZJT01NVS4NCj4gPj4+PiBEZXZpY2VzIHdpdGggaGlkZGVuIHJl
Z2lzdGVycyBtYXkgZmFpbC4gRGV2aWNlcyB3aXRoIHZvbGF0aWxlDQo+ID4+Pj4gY29uZmlnIHNw
YWNlIGR1ZSB0byBGVyB1cGdyYWRlIG9yIGNyb3NzIHZlbmRvcnMgbWF5IGZhaWwgdG8gbWlncmF0
ZS4NCj4gPj4+PiBUaGVuIGV2b2x2aW5nIGl0IHRvIHRoZSBmaWxlLWJhc2VkIHNjaGVtZSwgYW5k
IHRoZXJlIGlzIHRpbWUgdG8gZGlzY3Vzcw0KPiA+Pj4+IGFueSBpbnRlcm1lZGlhdGUgaW1wcm92
ZW1lbnQgKGZpeGVkIHF1aXJrcywgRFZTRUMsIGV0Yy4pIGluIGJldHdlZW4uDQo+ID4+Pj4gIg0K
PiA+Pj4+DQo+ID4+Pj4gSmFzb24sIHlvdXIgdGhvdWdodHM/DQo+ID4+Pg0KPiA+Pj4gVGhpcyB0
aHJlYWQgaXMgYmlnIGFuZCBJJ3ZlIHJlYWQgaXQgcXVpY2tseSwgYnV0IEkgY291bGQgc3VwcG9y
dCB0aGUNCj4gPj4+IGFib3ZlIHN1bW1hcnkuDQo+ID4+Pg0KPiA+Pg0KPiA+PiB0aGFua3MgZm9y
IHRoZSBpZGVhcy4gSSB0aGluayB3ZSBzdGlsbCBuZWVkIGEgdWFwaSB0byByZXBvcnQgaWYgdGhl
IGRldmljZQ0KPiA+PiBzdXBwb3J0cyBQQVNJRCBvciBub3QuIERvIHdlIGhhdmUgYWdyZWVtZW50
IG9uIHdoZXJlIHNob3VsZCB0aGlzIHVhcGkNCj4gYmUNCj4gPj4gZGVmaW5lZD8gdmZpbyBvciBp
b21tdWZkLg0KPiA+DQo+ID4gSU9NTVVGRF9DTURfR0VUX0hXX0lORk8uDQo+IA0KPiBJIHNlZS4g
VEJILiBUaGUgZXhpc3RpbmcgR0VUX0hXX0lORk8gaXMgZm9yIGlvbW11IGh3IGluZm8uIEV4dGVu
ZGluZyBpdCB0bw0KPiByZXBvcnQgUEFTSUQgc3VwcG9ydGluZyBtYWtlcyBpdCBjb3ZlciBkZXZp
Y2UgY2FwYWJpbGl0eSBub3cuIEkgbWF5IG5lZWQgdG8NCj4gYWRkIG9uZSBtb3JlIGNhcGFiaWxp
dHkgZW51bSBpbiBzdHJ1Y3QgaW9tbXVfaHdfaW5mbyBqdXN0IGxpa2UgdGhlIGJlbG93DQo+IG9u
ZS4gUGVyaGFwcyBuYW1lIGl0IGFzIGlvbW11ZmRfZGV2aWNlX2NhcGFiaWxpdGllcy4gQW5kIG9u
bHkgc2V0IHRoZQ0KPiBQQVNJRA0KPiBjYXBhYmlsaXR5IGluIHRoZSBuZXcgZGV2aWNlIGNhcGFi
aWxpdHkgd2hlbiB0aGUgZGV2aWNlJ3Mgb3IgaXRzIFBGJ3MgcGFzaWQNCj4gY2FwIGlzIGVuYWJs
ZWQuIERvZXMgaXQgbG9vayBnb29kPw0KDQpKdXN0IGFkZCBhIG5ldyBiaXQgaW4gaW9tbXVmZF9o
d19jYXBhYmlsaXRpZXMuDQoNCkFueXdheSBQQVNJRCBpcyBtZWFuaW5nZnVsIG9ubHkgd2hlbiBi
b3RoIGRldmljZSBhbmQgSU9NTVUgc3VwcG9ydHMNCml0LiBIZXJlIHdlIGFyZSByZXBvcnRpbmcg
d2hhdCBJT01NVSBjYXBhYmlsaXRpZXMgbWVhbmluZ2Z1bCB0byBhIGdpdmVuDQpkZXZpY2Ugc28g
Y2hlY2tpbmcgYm90aCBkb2VzIG1ha2Ugc2Vuc2UuIA0KDQo+IA0KPiANCj4gLyoqDQo+ICAgKiBl
bnVtIGlvbW11ZmRfaHdfY2FwYWJpbGl0aWVzDQo+ICAgKiBASU9NTVVfSFdfQ0FQX0RJUlRZX1RS
QUNLSU5HOiBJT01NVSBoYXJkd2FyZSBzdXBwb3J0IGZvcg0KPiBkaXJ0eSB0cmFja2luZw0KPiAg
ICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgSWYgYXZhaWxhYmxlLCBpdCBtZWFucyB0
aGUgZm9sbG93aW5nIEFQSXMNCj4gICAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFy
ZSBzdXBwb3J0ZWQ6DQo+ICAgKg0KPiAgICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIElPTU1VX0hXUFRfR0VUX0RJUlRZX0JJVE1BUA0KPiAgICogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIElPTU1VX0hXUFRfU0VUX0RJUlRZX1RSQUNLSU5HDQo+ICAgKg0KPiAg
ICovDQo+IGVudW0gaW9tbXVmZF9od19jYXBhYmlsaXRpZXMgew0KPiAJSU9NTVVfSFdfQ0FQX0RJ
UlRZX1RSQUNLSU5HID0gMSA8PCAwLA0KPiB9Ow0KPiANCj4gPj4NCj4gPj4gQmVzaWRlcywgSSd2
ZSBhIHF1ZXN0aW9uIG9uIGhvdyB0aGUgdXNlcnNwYWNlIGtub3cgdGhlIGhpZGRlbiByZWdpc3Rl
cnMNCj4gPj4gd2hlbiB0cnlpbmcgdG8gZmluZCBhIGdhcCBmb3IgdGhlIHZQQVNJRCBjYXAuIEl0
IHNob3VsZCBvbmx5IGtub3cgdGhlDQo+ID4+IHN0YW5kYXJkIHBjaSBjYXBzLg0KPiA+Pg0KPiA+
DQo+ID4gZm9yIHRoZSBpbml0aWFsIGltcGxlbWVudGF0aW9uIFZNTSBkb2Vzbid0IGtub3cgYW55
IGhpZGRlbiByZWdpc3RlcnMuDQo+ID4gVGhlIHVzZXIgcGFzc2VzIGEgbmV3IHZJT01NVSBvcHRp
b24gdG8gdGhlIFZNTSBmb3IgZXhwb3NpbmcNCj4gPiB0aGUgUEFTSUQgY2FwYWJpbGl0eSBpbiB2
SU9NTVUgYW5kIGluIGRldmljZSwgYmFzZWQgb24gaW5mbyBpbg0KPiA+IElPTU1VRkRfQ01EX0dF
VF9IV19JTkZPLiBUaGUgVk1NIGlkZW50aWZpZXMgYSBob2xlIGJldHdlZW4NCj4gPiBleGlzdGlu
ZyBjYXBzIHRvIHB1dCB0aGUgdlBBU0lEIGNhcC4gSWYgYSBkZXZpY2Ugd2l0aCBoaWRkZW4gcmVn
aXN0ZXJzDQo+ID4gZG9lc27igJl0IHdvcmsgY29ycmVjdGx5IHRoZW4gdGhlbiBhIHF1aXJrIG1h
eSBiZSBhZGRlZCBmb3IgaXQuDQo+IA0KPiBJIHNlZS4gQnV0IHdlIGNhbm5vdCBrbm93IGl0IHVu
dGlsIGEgZ3Vlc3QgZGV2aWNlIGRyaXZlciBmYWlsZWQuIFRoaXMgaXMNCj4gYWNjZXB0YWJsZS4g
cmlnaHQ/IFBlcmhhcHMgdGhpcyBzaG91bGQgYmUgZG9jdW1lbnRlZCBzb21ld2hlcmUgdG8gbGV0
IHRoZQ0KPiB1c2VyL2RldmljZSB2ZW5kb3Iga25vdyBiZWZvcmUgc2FmZWx5IGV4cG9zaW5nIHZQ
QVNJRCBjYXAgb24gYSBkZXZpY2UuIDopDQo+IA0KDQpwcmVzdW1hYmx5IGluIFZNTS4NCg==

