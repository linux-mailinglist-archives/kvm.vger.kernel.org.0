Return-Path: <kvm+bounces-15040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CF38A8FF4
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:21:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A8B0282740
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5FF10F2;
	Thu, 18 Apr 2024 00:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3oS5gsv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BA5376
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 00:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713399701; cv=fail; b=vEl24Gb2h+J5sParWA9wgFIxLhGV8zwZfemjqntAHyVcUBlOWQG3ZsgDXjQO5R8S9Eo4jJW+Rps8TmUnv7atDE1NDV95T1wlnY8NO+b0fpQX2H401YlJk1bPnhiCLTCiU3Ulz4PMBOUli6ptiGict3F44QZ4aZXqIsb//sfeMXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713399701; c=relaxed/simple;
	bh=1MXKx2AAbshM/XxMjpxdpvWaEvIva4DiL+dzX+zshpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bsu01Wwb5x4qg0qU/q2Mi4dIZs4roiIFfBRc+XOW/QxQaImj3tNXuB3aDN1AtOvdCKlEZOf5L5ZTTXORfJkT4RY45cqU0gzHlvlZaoO1jffHFhWCQkF/KRGLlAKWNwPZ4qo7P0+xpfjCPs1Vqg8M+9r1QNFExqdFtbYIxTOYGho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3oS5gsv; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713399701; x=1744935701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1MXKx2AAbshM/XxMjpxdpvWaEvIva4DiL+dzX+zshpg=;
  b=h3oS5gsv7rzI2nzy+FjaguRQVz2GIuMC4YTQNFo+LryQfgQU++NNSWoW
   oW0vEIxHjLVxD2jG4m2/PZZhD8rQ5klVtwQ2MAPFm80Q6kUGlg+w9u/Dl
   gS54iuZcaAaLirvqtBOHMX7cQ1YDHLWLkinnXyDbz2762+7bpCODLaw7x
   1clVLxUMYPtjH2u7z3SvYwFBPLEM4dSmrFONesHPz4manNlj8mq2Iz73a
   gx+sh5FAne2Y+MX07516r76Ny8gxhXqbNOsmLFauSsFj4PuyGZ6tlxTOK
   hHJXVZVPaBGvWlSy+Ibeq6Jx5Y+DlMw8jjG36atUdlx6YdJHKJ9ywDJ0I
   Q==;
X-CSE-ConnectionGUID: BGvS08xvQNGdslfpzuVT8A==
X-CSE-MsgGUID: LjkSahvbQfy7flq57Fnxqg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20345157"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="20345157"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:21:40 -0700
X-CSE-ConnectionGUID: zuyRUPqASumLHjNZ6sDK7g==
X-CSE-MsgGUID: UiH30QvHT3mdbQw/alXhDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="27425834"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 17:21:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:21:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 17:21:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 17:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDvyUKdfgT5EVb3Q9ef8PvFRbEYxiF8A9HSdyM7G5NunUjK8gQBaIKN1QtlmXmuKrlBXpRHG4UlzysGm3XXE2nzdO9XQuabucuelLz+qJ/JUpBy2AmbGuTIydIxd0tXtrbLgDJloEJnDdLj3wU1ZOkNstEL4QQe5/0NJyD1rpNZMZfhFJ36Qv8BEN/jWRBp5saXtSXwh+vSBKXMR83F4GEvAbYBnqg6cBufMzn5sIkMuWyZBfCjnefTlOKCSeHpL4QZGSQ0/qQKh5MYOSyetguqYEl5dx6miLJVa+tGIpMe6ASKrfbBG0kitvXqpjaVMbJcbB5wvieRhBbtAW4J0UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MXKx2AAbshM/XxMjpxdpvWaEvIva4DiL+dzX+zshpg=;
 b=VQbNc/eCFmfk9pvzQ/HK+zo4uYkxKqn4j2r2RIVqK7B8eojy3XBN+2oH5rTZ25nTNUcZMmGLJkQ5WcLK5kcZSoXr1yC1qT0hHdFQWxd7CROdZnnlvPAsMn+UAbZu2NFPC1rbf809CRDu3L1nBXejWZ3hU/hoOwE5gLNZ5Xy4JWV3CiWcntyqrGUlJ4osgPYcR/vW5B893KEx2LI+FetoMvZnuO8ms7TwIjEyjK/iDrQP6dqh5dE7N4NBkcQTpi5QIRaIDEswvjsGW38F+KPZ/0KdrYSQpF6OgEGwvuBanRy6VzCABw1C3OeRuBT3PE3Y7kaN4ZceDIfpZki/qDwB2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7212.namprd11.prod.outlook.com (2603:10b6:208:43e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 00:21:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Thu, 18 Apr 2024
 00:21:36 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Thread-Topic: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Thread-Index: AQHajLJzYiLjOoAxokK40c4Rfn6iJLFrNasAgADa8xCAAODfAIAAQE2A
Date: Thu, 18 Apr 2024 00:21:36 +0000
Message-ID: <BN9PR11MB527690902C6D7D479C16DB3C8C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<20240412082121.33382-5-yi.l.liu@intel.com>
	<20240416115722.78d4509f.alex.williamson@redhat.com>
	<BN9PR11MB5276D245515E81844B5EC1068C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417142552.44382198.alex.williamson@redhat.com>
In-Reply-To: <20240417142552.44382198.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7212:EE_
x-ms-office365-filtering-correlation-id: 5512f2e4-d1a2-45d8-5539-08dc5f3d8269
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2g5NGRqRB5mVu4YgczccnPeaJBFu2R+DE6tc+4FNFIU3n6kKyXxEvj+tnojVJcWgZXnT6K10midS2zKFMB9WeH/4XF/paHfr6LejkN4OpoQRzd5jcdKR3BJqikhQGkotsJKqY8PlnhGv/ETlxC6UaPflGDH1ZvPa0x6VrRpzuySW4FeMwqI/uW7NWTIKaPj5O1EywYQ2RTRKL8p51q10j8BU4rd0GvvSH3guqyIe2GSZXpT+67vWtovCs9fIRTfzUWPvq+CisFM9obLdSs1+rpvb2KKoUz1OpsGrXsjhePjbDMHuYPu2K5xnPwmbZURb+wKEhHOiwDj+V/4TyA0yfJh9inlagi4SjGiPsIu80kzWgOIQN9JyDyQmyco3cDS031OPziAMX26FQ8+P7D4Eij1+ASALAfTlLGnYAi1dAjxa17Pmo7qF4wBz2Q5pRfYfl3KNuz8b8AlZvQQUlOcYI8LiMOKPr8Uz6sMA7EzAb8SjgeVWF2jJf3vzGbmm7X8DjfOmfQXOtodBWFSihssGdrIYuQ5SPcRZlYEtih8v5jV5/NLH2vSGWABr4rfXzrOVuLCPgEuONh/z2y/mALYw7ckTTPWZKeGRED5wJNQa6bIvsc1ffQph3yxfIjxeG0ritog29sNQRLNzAOZw+XOecWMP15lphuyuyrVW77jnxtTvC+NlLEbd0pe42yiLCyvjlWJNzNTd1xN1wuim8OVpnsfvRTOrM9buD0PouG2eTFk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkRWYXRaQm9OMTdPOVdwbXVmMDhLOW9NdU9xdXBMWDFuMnQ1OXRodm9pSkNr?=
 =?utf-8?B?UWpvOERpTWhxbjRvcUhXSkdQd3ozUGIvc01OUzNnaDNPVmFIWk5kQUxyclBO?=
 =?utf-8?B?R3pvWnhRTFRtSVYvUjNDVFNpQThNano1TXZNWkZDWC9OS0ZSYWVIbWsybGRK?=
 =?utf-8?B?aDFWQk9sVDRzSENrT25QMDFHcVQvMkRiVHZVc3BxOVRJMUEvcFU1TVp0elMv?=
 =?utf-8?B?MmhZVTRjVE1hbHMwNjBlcG4vZ0Nwb1Z4ajBMTGtpSUltNnM1Q1g1Wm9laWlH?=
 =?utf-8?B?eEJiMVRKeG1oVFJSbXd0ZFZmZTZ4RzliZGxLL2dMYzlacFhwWlo4aWo4WUFj?=
 =?utf-8?B?aExDdllnbEN2STh1OHJxdER1MnZHeDFWT2l4MHZZZzN4NVFJcE4rZFNha1E3?=
 =?utf-8?B?VHRTMmxUTjh3YzZiR0E4bUxXSkxjcnVxSHU0eVU4Q0lWN1VFUm0ySkg3U3dE?=
 =?utf-8?B?ME05OFpnWk53cTJIYloveis2Zmx2QlhVRlJ4OWJyNU9kZ0UrbzBFMy9ZWmRy?=
 =?utf-8?B?Z2RDenpJSTAzRmJSeDFCcVJjK3h1NGptbUM5TUxPK08rQlA0SFNoYzhrVFJD?=
 =?utf-8?B?NXpoTllTbVhIbmprZkRIQnBFaHFxWlUvMThLU1UwUytBeTczWTMrNXAwbTY4?=
 =?utf-8?B?bHRvSXZmMUlwZnA1VzJ2LzA1UCt5eUpGWW9nQkVOclBJSVJqMHAvSFIwRVk4?=
 =?utf-8?B?aHBaN3Rlazg2cW4yL0pnMmVXZmx4dUJGM0t5SFlhWmhkbFZjdmJPd3prbGJR?=
 =?utf-8?B?ZGx5bjBSYjRhL1NlSnpGeDREK2VjT2pROGpDbDdZNnN4VGJsMkszUW1seSty?=
 =?utf-8?B?NDJITUV1MzZWdjZwNHlSRXVPUjJwTmh2ZXBzRGlnZWtEa0VHNzdNYys4bEJz?=
 =?utf-8?B?eU9SUERhUzhoSHZnemREalNaaUI0eWJ0OWhRVTJpdzJ2Yi9QSWMzQmwwWm5x?=
 =?utf-8?B?UXhNVG9XNE1INXllV09XVEx2bFdFdW5tYkZqak5Yc3JhN0lQRlplRnF4REpl?=
 =?utf-8?B?Y28zNnpFSFlhY1lSV0xFVExCNXJJdW5Uc3JiV2J4NnNsN21xVjhVcXdaZ2xh?=
 =?utf-8?B?RDVyb0JHKy9NR0lWVnRBWEtuS1Z0aVprb0xEbXV6b25wYU0yN1lyWXl1akV0?=
 =?utf-8?B?UVd3RytBWUg5cEttN2JIaHpSc1piS1lxSXB6MjdIdDEwVlpMWXE4WlhpdkpO?=
 =?utf-8?B?MStXQ0tsODV4cVlzck5jTjM1NDhQWkpWdE90b3FlUHJLUzI5NFBERCtFVlZI?=
 =?utf-8?B?RjJERGEvMi9rcUpBM0c0U1VONEFHdkNMU3BWR2IvQWFpbmFnenV0Z2RwaDIx?=
 =?utf-8?B?d0lLUjU2VGl0a0R6VlpDWWJROWV1QjBUcy9QRFAyVU9TeTVYVUJ4czZzdkxn?=
 =?utf-8?B?aXh3VFZQcEl4RzR6Vm1sMk9vRkJaVDNIaHhadFNJalB3YlduU0dIUm5QeWh0?=
 =?utf-8?B?UHFFVEF6VkNoSTdPQlNZanlURGhCTXJhVmtJQy9mQ0NHOCs0VWN4Y0RhSVV3?=
 =?utf-8?B?TStldmRFWHVnNkpFOTQxcGVBdDVtOEJXSXM3WGJCc2lJb0Q5U2Juc255VENY?=
 =?utf-8?B?ZHBKYThiMkQvS0hvOEV2RE0rYUtSVGZBTGdaczdBcHI1Q210OUdhY0lXQlBy?=
 =?utf-8?B?WFEydmlBc1Ivc1ZxM0JqTDNidFQzUW9CbzdnTVpFVENYTDUrS3BTcWNtQUdz?=
 =?utf-8?B?b0hZeWwrZ2R3Mm5hZnd5RXNlZHlaTUNFZk9NLzN2R3FtSWYwQmhGa2lTRVh5?=
 =?utf-8?B?d0JobnEyTk9KQ3BqOWowQkl5NGJlYnRKU25mRHNaZVEyVkgxQTIzOWU2QU9T?=
 =?utf-8?B?bFFIRUYyYm4rNnRTSkVTWkttTkpBL05Zai9VT2pqQy9yNlhsTE1IODNxWW54?=
 =?utf-8?B?WVhaWUxGWllGby8zWWRwcnJjbFZRRTBZaWd0NkJsVFBkUVh3UVJnUm9UOWlw?=
 =?utf-8?B?NGkwVnFWQUpSOVpNRExpcXNySFAyMHBJUFJzeXQ0aWk2ZXYwTlFMVmQzb3Vp?=
 =?utf-8?B?Rld2LzZTaGZEbHRpMEZuOW5TdTRlV0wvRVk1bUZyYlN3QmN5RkVrV1JyTHpI?=
 =?utf-8?B?R2JPdTZCSmtCckg1dVBlS3JzNkhzVm0yRHNsS0ZjZkFpbWhsclV0MkNCa1Nl?=
 =?utf-8?Q?r+ZyVD9wB5P/l9mO5kozkvHtX?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5512f2e4-d1a2-45d8-5539-08dc5f3d8269
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 00:21:36.4839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DSBJ69iE7tA5/hE/qBHBHqePVUTKp6WbjoldlOaqWWkY4EXd7KxJ0BBYzsSU154/Q+3j33S+Uy4El4yQCF+Tag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7212
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUaHVyc2RheSwgQXByaWwgMTgsIDIwMjQgNDoyNiBBTQ0KPiANCj4gT24gV2VkLCAxNyBB
cHIgMjAyNCAwNzowOTo1MiArMDAwMA0KPiAiVGlhbiwgS2V2aW4iIDxrZXZpbi50aWFuQGludGVs
LmNvbT4gd3JvdGU6DQo+IA0KPiA+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbT4NCj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMTcsIDIwMjQg
MTo1NyBBTQ0KPiA+ID4NCj4gPiA+IE9uIEZyaSwgMTIgQXByIDIwMjQgMDE6MjE6MjEgLTA3MDAN
Cj4gPiA+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiA+
ICsgKi8NCj4gPiA+ID4gK3N0cnVjdCB2ZmlvX2RldmljZV9mZWF0dXJlX3Bhc2lkIHsNCj4gPiA+
ID4gKwlfX3UxNiBjYXBhYmlsaXRpZXM7DQo+ID4gPiA+ICsjZGVmaW5lIFZGSU9fREVWSUNFX1BB
U0lEX0NBUF9FWEVDCSgxIDw8IDApDQo+ID4gPiA+ICsjZGVmaW5lIFZGSU9fREVWSUNFX1BBU0lE
X0NBUF9QUklWCSgxIDw8IDEpDQo+ID4gPiA+ICsJX191OCB3aWR0aDsNCj4gPiA+ID4gKwlfX3U4
IF9fcmVzZXJ2ZWQ7DQo+ID4gPiA+ICt9Ow0KPiA+ID4NCj4gPiA+IEJ1aWxkaW5nIG9uIEtldmlu
J3MgY29tbWVudCBvbiB0aGUgY292ZXIgbGV0dGVyLCBpZiB3ZSBjb3VsZCBkZXNjcmliZQ0KPiA+
ID4gYW4gb2Zmc2V0IGZvciBlbXVsYXRpbmcgYSBQQVNJRCBjYXBhYmlsaXR5LCB0aGlzIHNlZW1z
IGxpa2UgdGhlIHBsYWNlDQo+ID4gPiB3ZSdkIGRvIGl0LiAgSSB0aGluayB3ZSdyZSBub3QgZG9p
bmcgdGhhdCBiZWNhdXNlIHdlJ2QgbGlrZSBhbiBpbi1iYW5kDQo+ID4gPiBtZWNoYW5pc20gZm9y
IGEgZGV2aWNlIHRvIHJlcG9ydCB1bnVzZWQgY29uZmlnIHNwYWNlLCBzdWNoIGFzIGEgRFZTRUMN
Cj4gPiA+IGNhcGFiaWxpdHksIHNvIHRoYXQgaXQgY2FuIGJlIGltcGxlbWVudGVkIG9uIGEgcGh5
c2ljYWwgZGV2aWNlLiAgQXMNCj4gPiA+IG5vdGVkIGluIHRoZSBjb21taXQgbG9nIGhlcmUsIHdl
J2QgYWxzbyBwcmVmZXIgbm90IHRvIGJsb2F0IHRoZSBrZXJuZWwNCj4gPiA+IHdpdGggbW9yZSBk
ZXZpY2UgcXVpcmtzLg0KPiA+ID4NCj4gPiA+IEluIGFuIGlkZWFsIHdvcmxkIHdlIG1pZ2h0IGJl
IGFibGUgdG8ganVtcCBzdGFydCBzdXBwb3J0IG9mIHRoYXQgRFZTRUMNCj4gPiA+IG9wdGlvbiBi
eSBlbXVsYXRpbmcgdGhlIERWU0VDIGNhcGFiaWxpdHkgb24gdG9wIG9mIHRoZSBQQVNJRCBjYXBh
YmlsaXR5DQo+ID4gPiBmb3IgUEZzLCBidXQgdW5mb3J0dW5hdGVseSB0aGUgUEFTSUQgY2FwYWJp
bGl0eSBpcyA4IGJ5dGVzIHdoaWxlIHRoZQ0KPiA+ID4gRFZTRUMgY2FwYWJpbGl0eSBpcyBhdCBs
ZWFzdCAxMiBieXRlcywgc28gd2UgY2FuJ3QgaW1wbGVtZW50IHRoYXQNCj4gPiA+IGdlbmVyaWNh
bGx5IGVpdGhlci4NCj4gPg0KPiA+IFllYWgsIHRoYXQncyBhIHByb2JsZW0uDQo+ID4NCj4gPiA+
DQo+ID4gPiBJIGRvbid0IGtub3cgdGhlcmUncyBhbnkgZ29vZCBzb2x1dGlvbiBoZXJlIG9yIHdo
ZXRoZXIgdGhlcmUncyBhY3R1YWxseQ0KPiA+ID4gYW55IHZhbHVlIHRvIHRoZSBQQVNJRCBjYXBh
YmlsaXR5IG9uIGEgUEYsIGJ1dCBkbyB3ZSBuZWVkIHRvIGNvbnNpZGVyDQo+ID4gPiBsZWF2aW5n
IGEgZmllbGQrZmxhZyBoZXJlIHRvIGRlc2NyaWJlIHRoZSBvZmZzZXQgZm9yIHRoYXQgc2NlbmFy
aW8/DQo+ID4NCj4gPiBZZXMsIEkgcHJlZmVyIHRvIHRoaXMgd2F5Lg0KPiA+DQo+ID4gPiBXb3Vs
ZCB3ZSB0aGVuIGFsbG93IHZhcmlhbnQgZHJpdmVycyB0byB0YWtlIGFkdmFudGFnZSBvZiBpdD8g
IERvZXMgdGhpcw0KPiA+ID4gdGhlbiB0dXJuIGludG8gdGhlIHF1aXJrIHRoYXQgd2UncmUgdHJ5
aW5nIHRvIGF2b2lkIGluIHRoZSBrZXJuZWwNCj4gPiA+IHJhdGhlciB0aGFuIHVzZXJzcGFjZSBh
bmQgaXMgdGhhdCBhIHByb2JsZW0/ICBUaGFua3MsDQo+ID4gPg0KPiA+DQo+ID4gV2UgZG9uJ3Qg
d2FudCB0byBwcm9hY3RpdmVseSBwdXJzdWUgcXVpcmtzIGluIHRoZSBrZXJuZWwuDQo+ID4NCj4g
PiBCdXQgaWYgYSB2YXJpYW50IGRyaXZlciBleGlzdHMgZm9yIG90aGVyIHJlYXNvbnMsIEkgZG9u
J3Qgc2VlIHdoeSBpdA0KPiA+IHNob3VsZCBiZSBwcm9oaWJpdGVkIGZyb20gZGVjaWRpbmcgYW4g
b2Zmc2V0IHRvIGVhc2UgdGhlDQo+ID4gdXNlcnNwYWNlLiDwn5iKDQo+IA0KPiBBdCB0aGF0IHBv
aW50IHdlJ3ZlIHR1cm5lZCB0aGUgY29ybmVyIGludG8gYW4gYXJiaXRyYXJ5IHBvbGljeSBkZWNp
c2lvbg0KPiB0aGF0IEkgY2FuJ3QgZGVmZW5kLiAgQSAid29ydGh5IiB2YXJpYW50IGRyaXZlciBj
YW4gaW1wbGVtZW50IHNvbWV0aGluZw0KPiB0aHJvdWdoIGEgc2lkZSBjaGFubmVsIHZmaW8gQVBJ
LCBidXQgaW1wbGVtZW50aW5nIHRoYXQgc2lkZSBjaGFubmVsDQo+IGl0c2VsZiBpcyBub3QgZW5v
dWdoIHRvIGp1c3RpZnkgYSB2YXJpYW50IGRyaXZlcj8gIEl0IGRvZXNuJ3QgbWFrZQ0KPiBzZW5z
ZS4NCj4gDQo+IEZ1cnRoZXIsIGlmIHdlIGhhdmUgYSB2YXJpYW50IGRyaXZlciwgd2h5IGRvIHdl
IG5lZWQgYSBzaWRlIGNoYW5uZWwgZm9yDQo+IHRoZSBwdXJwb3NlIG9mIGRlc2NyaWJpbmcgYXZh
aWxhYmxlIGNvbmZpZyBzcGFjZSB3aGVuIHdlIGV4cGVjdCBkZXZpY2VzDQo+IHRoZW1zZWx2ZXMg
dG8gZXZlbnR1YWxseSBkZXNjcmliZSB0aGUgc2FtZSB0aHJvdWdoIGEgRFZTRUMgY2FwYWJpbGl0
eT8NCj4gVGhlIHB1cnBvc2Ugb2YgZW5hYmxpbmcgdmFyaWFudCBkcml2ZXJzIGlzIHRvIGVuaGFu
Y2UgdGhlIGZ1bmN0aW9uYWxpdHkNCj4gb2YgdGhlIGRldmljZS4gIEFkZGluZyBhbiBlbXVsYXRl
ZCBEVlNFQyBjYXBhYmlsaXR5IHNlZW1zIGxpa2UgYSB2YWxpZA0KPiBlbmhhbmNlbWVudCB0byBq
dXN0aWZ5IGEgdmFyaWFudCBkcml2ZXIgdG8gbWUuDQo+IA0KPiBTbyB0aGUgbW9yZSBJIHRoaW5r
IGFib3V0IGl0LCBpdCB3b3VsZCBiZSBlYXN5IHRvIGFkZCBzb21ldGhpbmcgaGVyZQ0KPiB0aGF0
IGhpbnRzIGEgbG9jYXRpb24gZm9yIGFuIGVtdWxhdGVkIFBBU0lEIGNhcGFiaWxpdHkgaW4gdGhl
IFZNTSwgYnV0DQo+IGl0IHdvdWxkIGFsc28gYmUgY291bnRlcnByb2R1Y3RpdmUgdG8gYW4gZW5k
IGdvYWwgb2YgaGF2aW5nIGEgRFZTRUMNCj4gY2FwYWJpbGl0eSB0aGF0IGRlc2NyaWJlcyB1bnVz
ZWQgY29uZmlnIHNwYWNlLiAgVGhlIHZlcnkgbmFycm93IHNjb3BlDQo+IHdoZXJlIHRoYXQgc2lk
ZS1iYW5kIGNoYW5uZWwgd291bGQgYmUgdXNlZnVsIGlzIGFuIHVua25vd24gUEYgZGV2aWNlDQo+
IHdoaWNoIGRvZXNuJ3QgaW1wbGVtZW50IGEgRFZTRUMgY2FwYWJpbGl0eSBhbmQgd2l0aG91dCBp
bnRlcnZlbnRpb24NCj4gc2ltcGx5IGJlaGF2ZXMgYXMgaXQgYWx3YXlzIGhhcywgd2l0aG91dCBQ
QVNJRCBzdXBwb3J0Lg0KPiANCj4gQSB2ZW5kb3IgZGVzaXJpbmcgc3VjaCBzdXBwb3J0IGNhbiBh
KSBpbXBsZW1lbnQgRFZTRUMgaW4gdGhlIGhhcmR3YXJlLA0KPiBiKSBpbXBsZW1lbnQgYSB2YXJp
YW50IGRyaXZlciBlbXVsYXRpbmcgYSBEVlNFQyBjYXBhYmlsaXR5LCBvciBjKQ0KPiBkaXJlY3Rs
eSBtb2RpZnkgdGhlIFZNTSB0byB0ZWxsIGl0IHdoZXJlIHRvIHBsYWNlIHRoZSBQQVNJRCBjYXBh
YmlsaXR5Lg0KPiBJIGFsc28gZG9uJ3QgdGhpbmsgd2Ugc2hvdWxkIGV4Y2x1ZGUgdGhlIHBvc3Np
YmlsaXR5IHRoYXQgYikgY291bGQgdHVybg0KPiBpbnRvIGEgc2hhcmVkIHZhcmlhbnQgZHJpdmVy
IHRoYXQga25vd3MgYWJvdXQgbXVsdGlwbGUgZGV2aWNlcyBhbmQgaGFzDQo+IGEgdGFibGUgb2Yg
ZnJlZSBjb25maWcgc3BhY2UgZm9yIGVhY2guICBPcHRpb24gYykgaXMgb25seSB0aGUgbGFzdA0K
PiByZXNvcnQgaWYgdGhlcmUncyBub3QgYWxyZWFkeSAxMiBieXRlcyBvZiBjb250aWd1b3VzLCBh
bGlnbmVkIGZyZWUNCj4gc3BhY2UgdG8gcGxhY2UgYSBEVlNFQyBjYXBhYmlsaXR5LiAgVGhhdCBz
ZWVtcyB1bmxpa2VseS4NCg0Kb3IgYikgY291bGQgYmUgYSB0YWJsZSBpbiB2ZmlvX3BjaV9jb25m
aWcuYyBpLmUuIGtpbmQgb2YgbWFraW5nIHZmaW8tcGNpDQphcyB0aGUgc2hhcmVkIHZhcmlhbnQg
ZHJpdmVyLg0KDQo+IA0KPiBBdCBzb21lIHBvaW50IHdlIG5lZWQgdG8gZGVmaW5lIHRoZSBmb3Jt
YXQgYW5kIHVzZSBvZiB0aGlzIERWU0VDLiAgRG8NCj4gd2UgYWxsb3cgKG5vdCByZXF1aXJlKSBv
bmUgYXQgZXZlcnkgZ2FwIGluIGNvbmZpZyBzcGFjZSB0aGF0J3MgYXQgbGVhc3QNCj4gMTItYnl0
ZXMgbG9uZyBhbmQgYWRqdXN0IHRoZSBEVlNFQyBMZW5ndGggdG8gZGVzY3JpYmUgbG9uZ2VyIGdh
cHMsIG9yIGRvDQoNCkRvZXMgUENJIHNwZWMgYWxsb3dzIG11bHRpcGxlIHNhbWUtdHlwZSBjYXBh
YmlsaXRpZXMgY28tZXhpc3Rpbmc/DQoNCj4gd2UgdXNlIGEgc2luZ2xlIERWU0VDIHRvIGRlc2Ny
aWJlIGEgdGFibGUgb2YgcmFuZ2VzIHRocm91Z2hvdXQgZXh0ZW5kZWQNCj4gKG1heWJlIGV2ZW4g
Y29udmVudGlvbmFsKSBjb25maWcgc3BhY2U/ICBUaGUgZm9ybWVyIHNlZW1zIGVhc2llciwNCg0K
dGhpcyBtaWdodCBiZSBjaGFsbGVuZ2luZyBhcyB0aGUgdGFibGUgaXRzZWxmIHJlcXVpcmVzIGEg
Y29udGlndW91cw0KbGFyZ2UgZnJlZSBibG9jay4NCg0KPiBlc3BlY2lhbGx5IGlmIHdlIGV4cGVj
dCBhIGRldmljZSBoYXMgYSBsYXJnZSBibG9jayBvZiBmcmVlIHNwYWNlLA0KPiBlbm91Z2ggZm9y
IG11bHRpcGxlIGVtdWxhdGVkIGNhcGFiaWxpdGllcyBhbmQgZGVzY3JpYmVkIGJ5IGEgc2luZ2xl
DQo+IERWU0VDLiAgVGhhbmtzLA0KPiANCg0KeWVzIHRoYXQgc291bmRzIHNpbXBsZXIuDQo=

