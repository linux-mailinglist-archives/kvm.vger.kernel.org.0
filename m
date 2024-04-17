Return-Path: <kvm+bounces-14943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0428A7EA6
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 10:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 156EA283227
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 08:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052B7129A7F;
	Wed, 17 Apr 2024 08:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ESW5Yh6c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE602744B
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 08:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713343762; cv=fail; b=ZKtUx6wLAFB8YapOwpp/PD1Ej77jwZlrdwWVtphsqd7Co9U8q1a80uMxlDXBjBjEbwL37jDvdkJtANNMcp7yxhWYt+wq3tP6C2EzXkyR9X3C/Pcde66D1oYuMxdLi7x6sypoIZchUGbJPDPvSAJ/ROYfoOlfnQz1kGathCwfWDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713343762; c=relaxed/simple;
	bh=PlFBMAg1+7iNO9vSY5BiX8c0Ljf4vYedx8PWpWlHNQ8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gg8iYcZD4qDHylGUOIWUF79Ux2xzMq5vlxuxepNXgfSMVyfGchFa7B+pvtzt2pFFyv4gj/jJlKwwyenjGGYGuAgPByu9Y5/KllpFDlRkN/7Fos3Kx6w3MOfKWOJW6+s+sQtCdAimgVho7XvSNseO+6tVvIxtoVAwIP1L0g1Eh/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ESW5Yh6c; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713343761; x=1744879761;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PlFBMAg1+7iNO9vSY5BiX8c0Ljf4vYedx8PWpWlHNQ8=;
  b=ESW5Yh6c5q0COG8SJNL4hyjp76ojE3IminwoVOnDifFpv/FxzHRfpi5c
   RMQLAC/VRdSLCxUunHPHrIxiYkouGaMKPDjuFFHtdbjLZ6+gad2VLEnxp
   WbQqsB6Zt8wS0bObsJTIv/lziVr9x+ZP7hdkEybykzqblEUvoS1XjPtRx
   SXhFIfHcXv8KHAGlDy9zY8+0Gd2WoGRF7GPwsEyHn2aJ7j+xuMiqe6t5m
   fMOnCKwD0hlgigAfRcfX9Zaztg0ggOprC1JP+MOXSCcVyN4spLDqHkn8P
   GKo1gM7RpHl6AIBqzMuu7v7pfGggk7gl4lfghDoM8aPUvhYp+ZIn8mBih
   w==;
X-CSE-ConnectionGUID: KJJPxQMHRqCSVffKtxE93Q==
X-CSE-MsgGUID: UPkDVOh8T6a4s40KET+wog==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9043450"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="9043450"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 01:49:20 -0700
X-CSE-ConnectionGUID: Bz9Ip+iZSl2tyOG+O1RWfQ==
X-CSE-MsgGUID: cjQFQ3MfQBGA9zv9QbSIRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="27200803"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 01:49:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 01:49:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 01:49:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 01:49:18 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 01:49:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/n5dJTnnUdXt4nIJmEJW9NsZEpjlyp+6wAv9VASoHBDISNZEQAbDA8iisy1FnxmSrzOzBZA+7+wMtn2Jp2sz1khhBpVUTm7kUV8nNl/w8dkqIsG2v/+A9Z/+LtZ4aeBLDm5r7Fp8iaaQyUCXE7OIQnG3yFLcOawm/KWbpWQcANHfaeTOG7OJud39sdZvcxpdSrPJ8lWHbjZ6+cDnuuvhJu2FtJ8NFVCMJe+SgP/TlVgyU1KE+PhoYtNexlXcYhE28Tddut3OHaANVwXipe0RVn18i9UpuyKbtuzcVPZ51p9eupfWkNpS9njhEYCofJdTJ8YasHhnqj8U/3jf3ycCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlFBMAg1+7iNO9vSY5BiX8c0Ljf4vYedx8PWpWlHNQ8=;
 b=HlGmtj6QXqjyItWbWsF0toNZMkiTWsaiYTRGJMDn8H5UznIInZyKwXcS5xhYBdTlWSXeFuDf33nyylnKcL/AeF2ZJJ6W2jGd7pkKY9LztYc5DkMZIhuacB4fmhWUG5UiN1gBmceVZAdDVfM3LbvmpxQ/xe6oRqycSP7tmYV2E4bhH/MEHHl6BM/itCa1uec90O2kotJniZFiTrIeDaBHB/EQ8ZCihKR8vtoVyTyerVY+zKMcUl+poNchJT4TeKgIIvxQdA7GlXEUuijOVLO8PhUCMa5rxo+kjaPqm6PV15KXUdz7IieinRyIpMcAC2ko/KP4/P/tJ04BtEHAk6+cdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8202.namprd11.prod.outlook.com (2603:10b6:8:18b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 08:49:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Wed, 17 Apr 2024
 08:49:11 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 05/12] iommu: Allow iommu driver to populate the
 max_pasids
Thread-Topic: [PATCH v2 05/12] iommu: Allow iommu driver to populate the
 max_pasids
Thread-Index: AQHajLGnwYjBY/XPyUCjqVXKPoa3N7Fo1cAAgANYPuA=
Date: Wed, 17 Apr 2024 08:49:11 +0000
Message-ID: <BN9PR11MB52766AFD83D662181A4AE09E8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-6-yi.l.liu@intel.com>
 <ef76c9bc-cafb-43a8-9b1c-f832043b8330@linux.intel.com>
In-Reply-To: <ef76c9bc-cafb-43a8-9b1c-f832043b8330@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8202:EE_
x-ms-office365-filtering-correlation-id: 2e421335-510d-4873-70a9-08dc5ebb4098
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b41EkMXOGkaNYny0ZcuCo8RKYuly+eZtN1H2rIe/EN7xhsqLHOW1+4zzd0NXMuonvdDESBE6yYUaFwElFAtA0041uBvYYN2aAT9oKyTR7lBsKDG1R6m5DHqOg+sqHsXeUHLEWsDYE1h1ewmKM2rzPfm3WH7jU6rFFoWkTn1RGksMEnAzmq9banDQwyNZ0IqcS3IvnDWIBpKmHh6AUBXNO7NNec5ErgOKwfD1Y7IAImdFb6xv3SQmCCkKHSRtsYuPgNiG8AcxnkJe2Bx8H2RP1wfPLDA+XojCcxOGfKeA/9kWPtGffU6tI23npvc4GRzwfBHOFKpJpwZPEcHa1tjorfG8M5M9e8NtJ67R/WaVD7UJ/FoAueFUG5wTGUK2TOQasAUHUpCEz4AkvQ/pDrTcnxpv1ou2wYdOZPGtWbzsN1toe76qS8NwzOwEFTYn5m+ULt63EzpKkijXULz9oJ+MZuvXnJRiPDbp0L9l0mhnqsddECaqDd2SpqX6oZz4NuqqvaEq3yHBPsJBY6ww6gp+9GPQTQWhs1HcXk5b2VphsdkyAA6N/oAvVqocnK6giGC1FF8ON/APLMQnS+Iyxuc8BV+ffhkL1goM15TmtflbTQSbrzv3OPMcXGsIZrMZfiN2zNIlg6KARhzLxOJLT6p3cvAyOySWe4u7iqBiI7XpHQPMFwAKhiMtC8PsaFBGYqINlVm+m1vInSy9ttZIKyqkYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUtXRnFrNEl4WmhabWw5aStyVjBPYTU0RUgyVEcxZVF1WWlzZ0JmU2J5U09n?=
 =?utf-8?B?QTEzbU8xVmRDRnYraDVHU0tRNzlFeExIb1A4N0c2QTRGZDVKRTg5SHI1bEhN?=
 =?utf-8?B?UHdSRDZvWmlXS0hGUXZRYno3c0pHcTFTN0hFOUNpMGJ1TDQ2TmlOQm5RQktl?=
 =?utf-8?B?UTExL2EvZ2lNcFF5ZkswRGg0Zk55UHNWUEtyNWNiZVllekZhT25EZUVEYnJm?=
 =?utf-8?B?RTg3a1FROXdpbU11cjZVeWRFczVKd1pkbGNnTkozcVlUWk90Uyt2MURYUS9Z?=
 =?utf-8?B?UDM0VUYvRzFweUZkRnMyVnFYa2YxY1hJbCtBWHZGUnltcTluTm5aL1Vjb3Ju?=
 =?utf-8?B?c2ZKVFlrUENtOGU3aUpyR2cyQVhZeVVYbUNvUDM5QlJpT3RaZnVIUU0yZU13?=
 =?utf-8?B?N2N6c0NvUktQdGhzTWNVYWJkUzZ3aUNBNHM3UGUzVVlJQm5FMFkrOFdGdXZP?=
 =?utf-8?B?SmpUaE93T3NLeEtudkNyNnZmdCtqTDJ1MkdaWkNGVjg3YUJMaW1qdFBnZXVl?=
 =?utf-8?B?dHFwaUhQOS9td0NHQWQzL05OYU9Yay9tQ21vbGhEL2Q4K3ZLODA3Ri8yZHVk?=
 =?utf-8?B?a0VtT2lUODZMT0lUdDhrcEdWZW14eVhvalhRNWxhRFdIS3RKQWlkT1RDUTh6?=
 =?utf-8?B?eDdZMDlKdjJjQmgxU2hyU1JnN3lycEtHbEJRc3FZYzZjcXkvYUFiMVh1ZGR6?=
 =?utf-8?B?bmJrd1E1LzBWQzFHVUxFMXE0dm0vRk1tUVFsT0V3NG1YVHJFWFc5c25Xck1F?=
 =?utf-8?B?ajZNTmc5bzJxQUtvbjAzclY0djBoRkp1amNvYTBodnhQU1hGVmk3czRXTkJJ?=
 =?utf-8?B?SzZxZExLU0pmbzRucVZOQXB4VjE1NlVTQkJvdHMxOHduVmxybjdGcyttaWln?=
 =?utf-8?B?SkkxU1hNeTdEaVRvcUlVYmkvUmh3QWwzY1orNjZVYnd0V1lxS2puTUVMNjlP?=
 =?utf-8?B?RkNZYTNqa3IrcGpZWnRiZnpxWStyc2x2Z3JERlVKNW5Odll3OEJiWHpHWGtF?=
 =?utf-8?B?SnlET2phU3lWYWVJSWFFa0F2NytielNOL2hPQW94b3FuTnhOV1BScDdoYXhE?=
 =?utf-8?B?c0hyTDFRT2UybnVKRTRzUmFXQk42UDVheC8ydnBjWGJQTDcrRGwvK1FtdXlU?=
 =?utf-8?B?K1NOdDdwYmtxK3Y2enlZM3duejFSY1lLem9FOUtDVVFCaVplUEdLTmhvRWtG?=
 =?utf-8?B?KzB4aUhGcTlzM3VlUlVVcVZhNlFGcndFQ2VTU3BXNnpWRC9HZnMzMEthSXlG?=
 =?utf-8?B?WCtBa2lJbURzZ1NWaERTcjZjRUpXUXpRc0YwWXo1WU1ZcERLTHlxZVNvMUlJ?=
 =?utf-8?B?MzNvL2dUVFV2K2tsTmtJcWZDdXllREVGSXZtQk85SFdUbFA0WGV3U04yWiti?=
 =?utf-8?B?dVZTU0RsZTM4YlVqNUlWVDJsTFFIZWxHTC9BeG5LeHMxNXp1bDVhZXBZWk9j?=
 =?utf-8?B?TURzbko4eXh0RzFKRTdzUTJtR0ViM1kyL0ZHNllDT2dmK0czbWthc2lLd0ZX?=
 =?utf-8?B?MzFibnRxWmNpZmlCRTg0S0JkaUxXTGtLSHpsYkN6UFhvQVNHNHZyWlpOSUlM?=
 =?utf-8?B?aHZTMWtzbTF1dDhvWVhDWDVZL216a2JGQU14c1ZQWVc0eFd1VzRiN25od2pG?=
 =?utf-8?B?QklmcmtYL1RHTWxwU2R6MGZORXdKdFFnNW5WTHpxZ1hwQXMzVFJOYkV0Nmw2?=
 =?utf-8?B?Rk85aUp3UUFBT3lUYXF6cUxmdkg5YnZ0ZDdvL1l5TkZ3ci9Pd3RWUGk3U3dp?=
 =?utf-8?B?bEFwOS9MZ1pBSzF6cUFocEFwMEJsQmlwMlM3dFl5UWNKSlhuWk9Cckt3Mldt?=
 =?utf-8?B?VmFrK0txRDlKdEs5ZFBrSXhqNHU3V3hNWE5MUkwvaG9wTGJxZmdaVXRVbVZW?=
 =?utf-8?B?bUVmeEtZeE9jR2hZUmw5YjF0SXZad3NlTTZhVElUWVBpcXhnSG4waFhuTi96?=
 =?utf-8?B?bUhSeHdyMkJHbmJ6RFBUYXlUSmZQMnU0RUFxWTFjcG05OGV5UE9sVDgzdi9J?=
 =?utf-8?B?cmVWckFidm16ZEFlaU9TZVB5MlkyaDV6eXdyYzBweFArajJMRC81V1BHS3N0?=
 =?utf-8?B?TUw1YjVwdTlWSmJSeVpUNzB0WEpxRzJnU2hjRFBsL0RJSGNQMkU1RUNJZHVz?=
 =?utf-8?Q?DQi1pij2AojoXcpepiRP+1iwZ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e421335-510d-4873-70a9-08dc5ebb4098
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 08:49:11.5057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSEFalXKzqozqpL3DofUHynMqZvn1g8WVvntD0ETiAiqW5OD8U2Xwo1rqixXvE/myWzBU/vSS9W2L6tetsrQwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8202
X-OriginatorOrg: intel.com

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBNb25k
YXksIEFwcmlsIDE1LCAyMDI0IDE6NDIgUE0NCj4gDQo+IE9uIDQvMTIvMjQgNDoxNSBQTSwgWWkg
TGl1IHdyb3RlOg0KPiA+IFRvZGF5LCB0aGUgaW9tbXUgbGF5ZXIgZ2V0cyB0aGUgbWF4X3Bhc2lk
cyBieSBwY2lfbWF4X3Bhc2lkcygpIG9yDQo+IHJlYWRpbmcNCj4gPiB0aGUgInBhc2lkLW51bS1i
aXRzIiBwcm9wZXJ0eS4gVGhpcyByZXF1aXJlcyB0aGUgbm9uLVBDSSBkZXZpY2VzIHRvIGhhdmUg
YQ0KPiA+ICJwYXNpZC1udW0tYml0cyIgcHJvcGVydHkuIExpa2UgdGhlIG1vY2sgZGV2aWNlIHVz
ZWQgaW4gaW9tbXVmZCBzZWxmdGVzdCwNCj4gPiBvdGhlcndpc2UgdGhlIG1heF9wYXNpZHMgY2hl
Y2sgd291bGQgZmFpbCBpbiBpb21tdSBsYXllci4NCj4gPg0KPiA+IFdoaWxlIHRoZXJlIGlzIGFu
IGFsdGVybmF0aXZlLCB0aGUgaW9tbXUgbGF5ZXIgY2FuIGFsbG93IHRoZSBpb21tdSBkcml2ZXIN
Cj4gPiB0byBzZXQgdGhlIG1heF9wYXNpZHMgaW4gaXRzIHByb2JlX2RldmljZSgpIGNhbGxiYWNr
IGFuZCBwb3B1bGF0ZSBpdC4gVGhpcw0KPiA+IGlzIHNpbXBsZXIgYW5kIGhhcyBubyBpbXBhY3Qg
b24gdGhlIGV4aXN0aW5nIGNhc2VzLg0KPiA+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBKYXNvbiBHdW50
aG9ycGU8amdnQG52aWRpYS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogWWkgTGl1PHlpLmwubGl1
QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvaW9tbXUvaW9tbXUuYyB8IDkgKysr
KystLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQ0KPiANCj4gVGhlIGNvZGUgZG9lcyBub3QgYXBwZWFyIHRvIG1hdGNoIHRoZSBjb21taXQg
bWVzc2FnZSBoZXJlLg0KPiANCj4gVGhlIGNvZGUgaW4gY2hhbmdlIGlzIGEgcmVmYWN0b3Jpbmcg
YnkgZm9sZGluZyB0aGUgbWF4X3Bhc2lkIGFzc2lnbm1lbnQNCj4gaW50byBpdHMgaGVscGVyLiBI
b3dldmVyLCB0aGUgY29tbWl0IG1lc3NhZ2Ugc3VnZ2VzdHMgYSBkZXNpcmUgdG8gZXhwb3NlDQo+
IHNvbWUga2luZCBvZiBrQVBJIGZvciBkZXZpY2UgZHJpdmVycy4NCj4gDQoNCml0J3Mgbm90IGFi
b3V0IGV4cG9zaW5nIGEgbmV3IGtBUEkuIEluc3RlYWQgaXQgYWxsb3dzIHRoZSBkcml2ZXIgdG8N
Cm1hbnVhbGx5IHNldCBkZXYtPmlvbW11LT5tYXhfcGFzaWRzIGJlZm9yZSBjYWxsaW5nDQppb21t
dV9pbml0X2RldmljZSgpLiBraW5kIG9mIGFub3RoZXIgY29udHJhY3QgdG8gY29udmV5IHRoZQ0K
bWF4IHBhc2lkLg0KDQpCdXQgYXMgaG93IHlvdSBhcmUgY29uZnVzZWQsIEkgcHJlZmVyIHRvIGRl
ZmluaW5nIGEgInBhc2lkLW51bS1iaXRzIg0KcHJvcGVydHkgaW4gdGhlIG1vY2sgZHJpdmVyLiBJ
dCdzIGVhc2llciB0byB1bmRlcnN0YW5kLg0K

