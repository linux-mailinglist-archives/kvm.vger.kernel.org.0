Return-Path: <kvm+bounces-60931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E20C03B3C
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 00:48:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A97771AA4657
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 22:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EB92882B7;
	Thu, 23 Oct 2025 22:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bxAmZf9F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63C184;
	Thu, 23 Oct 2025 22:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761259698; cv=fail; b=TV48BH/0Bx0FmrYJh/PdZ1iEmH9FrE4uS/yeKH7klz8F0Qcy4GYeiXYaX+KRpgdSK9+z6gjASqoIswsBnw6VdbrAajPNht6dtekXtqzKtrjC3ZIxmsdYBK31RIy+IntlAsUdwlfYd+yjvVo+kPxaTYXpva/JIP23mpwxnnpbeDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761259698; c=relaxed/simple;
	bh=/avYROLyqweXbDC8Lb5fy7wQW3uuZI8eTbii/2y9ivA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HsCAfX/h5IDmVBp1pHMy63UBSs7w4tUAXfTb38RBWxvoLKs5gf2lnwsqDgS96OFvUz774p6ZJu03dmZysYDR2Iye7Dzwk2tU+BGB9zzrJ65sgyALxgiwbPjIOKuRubBfSjCGpbt0eAn0bbQ1UZHANljfvIuUYbJnttt4ZokkUz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bxAmZf9F; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761259696; x=1792795696;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/avYROLyqweXbDC8Lb5fy7wQW3uuZI8eTbii/2y9ivA=;
  b=bxAmZf9Fy5L14Ui7KfHpQPlepPfel3gzygIZYPbDjwXDMxK6Nb/zK0+I
   d9ozgC5xa1H8mwoj5gJVmbJNLGShMSHhTK1kKx8l0YH/VdFHWZ7fixbv0
   X881f4StR7rVNMizmhj3loHWUc1ZcDB6ZjATLGxAdDN+Q3uTuwqA6bGBS
   gAb6v50EZBVbSo8f+bjVaLzWchjzXQjzExlUL1vw+6vLOygcDmeLE3oIJ
   psxwFxIWOW/kP6fo/JinPeMK4RVGXApIulnPYLc7CQcfrQ6SEUZOseUxv
   5qhtG/KMneciXnXS95z/qJjQAPv/hPtR1Vm7fUqz5vxBKgnfaQu1vzvV0
   g==;
X-CSE-ConnectionGUID: RmZMRJh/QHKDG6qQPWXcNA==
X-CSE-MsgGUID: 7oWrYIAHSW+pHhlij44osg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74881793"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="74881793"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:48:16 -0700
X-CSE-ConnectionGUID: FpjFb2JBRYy5904iCG7lJw==
X-CSE-MsgGUID: Dp14wHN0QHqbSGvr4GrrMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="183886151"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:48:15 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 15:48:14 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 15:48:14 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.23) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 15:48:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I6RwV3U4vkq62eD1VM9gmnDH18MpY8+zMC6k30LeoTj1M2n5qKUa8oOqIZ9DX5lVShy+9tF62fIaaduYr3ix4NO0iYb/jMP1N45KoZe2I8Pl5g2Fx0oXpicpdxRl4IhwKn/Ua6qbDTO4V8jCsYBdzTGRk0WaVozza2IJo1KY2gx48CViKzThwmnjTIN223u9k81I2ilmu/ABE2MszXPJ4mTExh5eic6ox2CNqcpHI7j8LFsUkcLl6a4amuNV91p/lK4+VFEn0k2/YmSjpLGvRO6bO+1VAqqUN/jH9xJDzjoyib8dFrcryeyZchXLAd4F4Nhet/onPQgUP54CCQwPjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/avYROLyqweXbDC8Lb5fy7wQW3uuZI8eTbii/2y9ivA=;
 b=wRH/Fr837Ciats8KVich4QfGoeH8hlYtLvN3eF9bGbFZ7tw2aOTwKqUp7oUDt7SWd7K1FVLtpckd0laQPu+Xmo54Q4uBvymsLPO4kBrl5XJgV8j9vDuqylsI6NIU/Il3eTHMIWuOBtgAfStDKFMkFlHGdhv+5Poa4ww/rxyLnnqkBp8w0UYHsjQDLzfRNqABjrvHa+VU21JqoodFutMLoeHTzgPqiLLZz4vw9Re0BFvYVk04OOu2X3AhWAxBo+ph1P2IJPSp745wMbkmOIdgwIFyr5LL/x8n7MFZXtFyWxpEHj38wIfufE/WjqZ17RPZI/MBbLszNPA/hO5hbYEbBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB8594.namprd11.prod.outlook.com (2603:10b6:806:3b1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 22:48:11 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 22:48:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com"
	<frankja@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 14/25] KVM: TDX: Bug the VM if extended the initial
 measurement fails
Thread-Topic: [PATCH v3 14/25] KVM: TDX: Bug the VM if extended the initial
 measurement fails
Thread-Index: AQHcPv2kFQRkmR6NlkOuPIThzOpsirTQYDeA
Date: Thu, 23 Oct 2025 22:48:10 +0000
Message-ID: <442f5488e4a66f6a1517082df3d2ae47316be010.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-15-seanjc@google.com>
In-Reply-To: <20251017003244.186495-15-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB8594:EE_
x-ms-office365-filtering-correlation-id: 3b34cdc5-3bb8-40b7-4cff-08de12863e08
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dkhabXVYdVBWcDQ1azZGSWRGK0RsT1lmcklpaFJvZm1XWXg1WTR6MzZCekdX?=
 =?utf-8?B?TXNCa2hVQXhTWE9Ua2pDVlBMU0FRTGh2L0pROVkvcVBmK3NoZE1xdDBBRVdx?=
 =?utf-8?B?TC92UmhDNFJhRWtEMXI2bG5VKzMxcXJhajZ4R3hoWS9TYTk4ZTNMNlhJUUlM?=
 =?utf-8?B?MUczNkNCSVFsdFMwaHZMb0dMd2Z1Vmk1SkJTTm1YRHVDcVFpUmF0Q3cyTWVJ?=
 =?utf-8?B?UVhIOUliVHJ4R2NraU0yWm9iaXU2MHdLc1FLUE5tdFJHcDFDeVhudFZBTXIv?=
 =?utf-8?B?ME9JeWFrcCtOeENHMzZ0ZU5IVWdBbklCK3pTdlBnWEczWkZHTC8yblhDMUhy?=
 =?utf-8?B?Z3NBOUtKYTc5QTdUM0RPanFJNUZscTFIbzNSVGFEK3ZuRnJtbit2MXRzanJS?=
 =?utf-8?B?MjdNc01TcWc0Q25PSWtWbDNmTVlMV2U3bnF1RWhlTzB2RkNEekx4NzhCMW55?=
 =?utf-8?B?dVYrbDVhUEZBNHVFZnBXTmtmMFNuS3J5ckdCY3Vxd2RqMWJHOGZ4TTgyUXdU?=
 =?utf-8?B?cGx3RFhKbXJtWkFITkRxRXlaRDAvWWEzb0ZZMnBpSWIvSkhZSTErREhBUlow?=
 =?utf-8?B?R1BuNWpURlRSV0ZRMGF5NFY3cG5OU1VjV0RDeHBMdk5hbFRaQm5kWitYZnlO?=
 =?utf-8?B?WURndElobVlEbkZkOEYwNy9EcUJXR2RoMEs0dTYyQktkNk9WZm41UjY4RzdZ?=
 =?utf-8?B?MHB3cUpoUGZ3ODR2NTB2WC9NeGxpSUxpSmw4M2JaR2hJVXFZaExrSWdEYktH?=
 =?utf-8?B?VVUvNDZSa2pQalJ6Um90NFp1VUp5bW02akp5dGpIUDg1TG45MzlDWXlPMUJj?=
 =?utf-8?B?NGtxNmdIUDN0M01LSVEyMjlDdC8zTXc1SkNjNzBVT0xMN1ZYMGJkN3RCaFZH?=
 =?utf-8?B?aDZXclRhdC9rQXNCcExoYUQ4eXBRckYwK0pDVDEzc1hvS3BENFR3cW1NOUxz?=
 =?utf-8?B?UExlOGlWcWxuOGlOODMzZ1FvY0RtWWlET0F5SzRxWWVSNWVLSCsyblZVZ2VC?=
 =?utf-8?B?QW1nMFhpRVBQa2wweEFscHZWVWllMmRNUW1jQTM4Q3BLaWZVNDlib1piZUNG?=
 =?utf-8?B?emJSdjI1S0FMQmZ1UEJwM3duTXh4M1Azd0dkYTRsRW1PbHlvV3lKOVoxU25O?=
 =?utf-8?B?QzlscFlaMnNzUFMydkFKa3dUQ3NqdlVJNlgvL2x2R3QvS1JIMkFlMEl5ZHFC?=
 =?utf-8?B?WXpYYldGVWt4MWticWp2cWEyVEJLTzN1ZHo4d3J2cTlnQ1FWNDFneFpwWlVx?=
 =?utf-8?B?eWJ1Sk9SNW4xMDlmd3dGeWJjOG5sQzk4UENIMGorZXA4dUgybXB1T2ZCUGls?=
 =?utf-8?B?RW9Va3JpWitleldOdXozZFhrTHEwSDhmNC92SGZPZWw5MEEzSzFvTmFnKzVa?=
 =?utf-8?B?a2NWd01BcWNJYVhvcUZ0RDJaL0Q1RU5WTWJTcjRxUkNOZEIyeWdSZjl6VTBj?=
 =?utf-8?B?YldGZ0pHNTExRkF6eTVOOGJqelcwTVF0RmI2TlB6TEgxRE1Vam8yb3UxRWV6?=
 =?utf-8?B?aGhWS1BsU3hybEFTZzhMREo0WnA0NHhiRUpHbnNRVVZuZTBRU2F1a3dCVU9k?=
 =?utf-8?B?ajFQS1d0Z2JxTUc2Q3ROelAvenBrcW1NTkROTFZ5Z0RiL2U5NEJzZGlzK3o2?=
 =?utf-8?B?S3JLcHlJV1NtcURVdElVOW5jc1FuU0NtemtYOUpLS2hGMmk2Q3dqZElHUHll?=
 =?utf-8?B?MXp1VVBoQVBQbEVsK0VIUEYwZEpaM0pmQVlsay9UNnBQZGxwakd6Z1NQLzI5?=
 =?utf-8?B?M2RKL1ZPYTFTbVlReVlGMEdvUGVyUEhUSkc2WXFTTHBaR0NWOGt3T0RoOTZW?=
 =?utf-8?B?bVZXVFFGNGVvVUFoUk02aDdHK0hOTEc3SkxLT2dYU0creDBhYUFuOHI4eFhK?=
 =?utf-8?B?dFozVEJpaS9mYUJTNXRSUkthZTBETitkM3dTeXRWcUU3cVpRVU4vRDZPM0JM?=
 =?utf-8?B?ZXRjbWUydWg5Rm45VHhiL0FUS3o3SGQzdGxOU3hoRmtzZysvdnZjSjhRNyt2?=
 =?utf-8?B?YUdMMXlUdEZFT09za1l1TGZpL3djWFJ3aDJCcTFhYnJvSUIwV0NHM2dxcVdm?=
 =?utf-8?B?V2pGUFBnQnl0SWRCRTA4KzVFbElsdUkyOWdGUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmZIZEc0a3dTMDliRjVLVExXUWxVUm84eHl3US9YL3o4YmdjSzBieEFzWXkw?=
 =?utf-8?B?MDk1MFIvUGQyU1Jsdm43U1ZKYWlIWTR4eEM3WXNNdzVOQXEzVUFaVUFPRTU2?=
 =?utf-8?B?TnNVLzZNVHQrSTRUbnJnMXVzZDJVajRhVnJxN3JDQUlKRUNGSjYzVkVaNUFI?=
 =?utf-8?B?bDEyWUNNZ3F4V0phaTVTRFhJaVZ5OWVyT015YWYxamVDTzlFbWNPWXYzaEZO?=
 =?utf-8?B?dkw1QmhzUEFRYmtBWjdpNG5xNEpka3VldUZvbjRGZmxReFRxZEVVVlVxNDJn?=
 =?utf-8?B?WkJZMldBK0dHSFVBTENXTlJwTzUwa0FTZHNqckgxWUMzdGM3cWQ5dkZBeE1D?=
 =?utf-8?B?OU42dEwwd3RKSHQzc3B5ZHhrUEQ1bDROZ0tGWDFxUlVSUjhCMFdvZ0lnSndr?=
 =?utf-8?B?UWt5YzUrZ2xieUtwMVZLcEJsMEtsRUNQeW81eDh5THBjZFkyNTZDcXJxRHI4?=
 =?utf-8?B?T0xmVTdPZkhPMGIrUE80VWpCZmIvNzRsSTZPUDd4RS9jZlpEeFBISzB4TTlB?=
 =?utf-8?B?OURISFNvM2lvNDl0RHVTQTBEN3lMelRDS0dReFhTWGJJWXJMYThQNTA5ajlu?=
 =?utf-8?B?RlpFSDd0UVJwenNGdkhFSVFETERCV21iUEM1NTMvR3pSRDBXVDd0R3FBclVX?=
 =?utf-8?B?SU5hQkFFdTIvMDBLdk1sdkVlc2NOSmh0MHQvdytxVExZK01nRFBHTkZSbkJ5?=
 =?utf-8?B?WmxzZzNwZ1YrMjVQUUlSRU96enBaeXowR3NYMzFYOXZlM1d0NVgwMFhQK3dp?=
 =?utf-8?B?eHFrNHoxSjJhbS96UzNyNzJnNHJkZG0wRHdpMXMzbEF4Q0dwYWl3QlVZdEph?=
 =?utf-8?B?QmRjZmtFRUd1QW1ScDh1c0pvTU9ic01YRGxJMUlrYXo3TEFMK0ttRmVia2to?=
 =?utf-8?B?b2JBVXpNWUlkbTN5VUgveHRTWjdNNGJYOFRDWVY0bTJMNVZrelZoWnExU1Vz?=
 =?utf-8?B?b0tJaUcwKzhsTzQyWW9OY0NqcjJEVE5wNFU4QWJiMTAzdUMreHpaRFRkakho?=
 =?utf-8?B?THFIa0REbzNqS0ZsY1hMRk9NMFlPS2FraFdobHNDZmFjQ0hpVFVudUpmZWV6?=
 =?utf-8?B?azd3Qm51TVp4bHRnWllDQkNnVERLYWlDdEVOdmIrdndCR2tGdlk5UStvdHhI?=
 =?utf-8?B?TFI0TDNkN3NYdEs3MHFhejgzUDMxdFM1eEMxZUFjSDFRbzhWbVlBaXRFVTBG?=
 =?utf-8?B?WVppN0pBUytRVmEzVWhjSEZxemtHZmc0THhWNVpsRTlXQlhXdVQ2N0srMCtR?=
 =?utf-8?B?dEx0WEUrTEg3VFVMTXFrdnlkK01KRHgwQXFRcTQ3Zy9ud1NFeGJReWkrRXJn?=
 =?utf-8?B?eXRoa1ZtRCtHcDlBYnBCejFPalBkYk1qU1dvNURPeTlQUURwc3JUSzd2NEo4?=
 =?utf-8?B?Y1JBcEluNGhObEE4eENvMytoZXNiaStxbEtlVjhTUXdMKzBuRVNBSkMwam9S?=
 =?utf-8?B?WGJxb2dlc0JXMHNkMkp4cmcvYUpiL1NvaktmeTJwcGtuZDNrTmpPS1BBQ0RK?=
 =?utf-8?B?NzhJckhtR0p0MnBuWU83SHp6cmZKcVMwZFZIeWZzRnBxSDVaaC9pQ0MxaStO?=
 =?utf-8?B?RjRYTzErN0x0QzhMekcxMlIra2grSGNjVW9DVlNmSVh0K1JrWlppcXl1d1Jn?=
 =?utf-8?B?SjZNNWhpQmlPWlJxSkxsYm54MEYrRUxNS1RZSnpId0ZRdDZuRlNQSURNTWNa?=
 =?utf-8?B?NGJ3VXFHelZaL0hjNVdiUVJFSE9OZy9HMUd6WmtyYjk3TGhHSDFiQTh1QUFC?=
 =?utf-8?B?WDEzdFBUUmsrZnFMWWNhMURIdzZyczhabHZQTVhWYUNXczYxbEtselcwcXRm?=
 =?utf-8?B?Nm5UdUJQNUNzblJuT3crVEViS25vWWNMbHlWckozTktzWmNORDJKYTlpSjh5?=
 =?utf-8?B?UlZSaWVORHI5alNmY1lJQnVkakNuZjh2c1ZTemF3bWdIRmpSUHpob0hTeWZn?=
 =?utf-8?B?eElBa1hPREZnYTNMd1ZGdGtCUWJTbUkybU5WWjdMQjJMK1RUSUI0TmpiWTNR?=
 =?utf-8?B?MkZNYnk1OFpHOWcxWTdqY29NVUdwaG9FUUFCelY3WEJENmo4V1h0RWRvbXlD?=
 =?utf-8?B?eEQ0UVc3T3Jja25BTHV5T1d0ZzYzQzBFSVNhZFNtdHVqR1d5RldaSkM0b09j?=
 =?utf-8?Q?qQ6v6XLqOgq3ADNYLpIZYlioL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ECD3108AD6331440B0A3F7B89ADF1E42@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b34cdc5-3bb8-40b7-4cff-08de12863e08
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2025 22:48:10.8731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dllTsczdz5HCLdQT3KrWhpHTalRRV0cBIqTGjGl6fmCxr0U+IlDCuyjplJnhe/9pGpv8DZN+MhebDJwnmmhl8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8594
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE3OjMyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXQVJOIGFuZCB0ZXJtaW5hdGUgdGhlIFZNIGlmIFRESF9NUl9FWFRFTkQgZmFpbHMs
IGFzIGV4dGVuZGluZyB0aGUNCj4gbWVhc3VyZW1lbnQgc2hvdWxkIGZhaWwgaWYgYW5kIG9ubHkg
aWYgdGhlcmUgaXMgYSBLVk0gYnVnLCBvciBpZiB0aGUgUy1FUFQNCj4gbWFwcGluZyBpcyBpbnZh
bGlkLCBhbmQgaXQgc2hvdWxkIGJlIGltcG9zc2libGUgZm9yIHRoZSBTLUVQVCBtYXBwaW5ncyB0
bw0KPiBiZSByZW1vdmVkIGJldHdlZW4ga3ZtX3RkcF9tbXVfbWFwX3ByaXZhdGVfcGZuKCkgYW5k
IHRkaF9tcl9leHRlbmQoKS4NCj4gDQo+IEhvbGRpbmcgc2xvdHNfbG9jayBwcmV2ZW50cyB6YXBz
IGR1ZSB0byBtZW1zbG90IHVwZGF0ZXMsDQo+IGZpbGVtYXBfaW52YWxpZGF0ZV9sb2NrKCkgcHJl
dmVudHMgemFwcyBkdWUgdG8gZ3Vlc3RfbWVtZmQgUFVOQ0hfSE9MRSwNCj4gYW5kIGFsbCB1c2Fn
ZSBvZiBrdm1femFwX2dmbl9yYW5nZSgpIGlzIG11dHVhbGx5IGV4Y2x1c2l2ZSB3aXRoIFMtRVBU
DQo+IGVudHJpZXMgdGhhdCBjYW4gYmUgdXNlZCBmb3IgdGhlIGluaXRpYWwgaW1hZ2UuICBUaGUg
Y2FsbCBmcm9tIHNldi5jIGlzDQo+IG9idmlvdXNseSBtdXR1YWxseSBleGNsdXNpdmUsIFREWCBk
aXNhbGxvd3MgS1ZNX1g4Nl9RVUlSS19JR05PUkVfR1VFU1RfUEFUDQo+IHNvIHNhbWUgZ29lcyBm
b3Iga3ZtX25vbmNvaGVyZW50X2RtYV9hc3NpZ25tZW50X3N0YXJ0X29yX3N0b3AsIGFuZCB3aGls
ZQ0KPiBfX2t2bV9zZXRfb3JfY2xlYXJfYXBpY3ZfaW5oaWJpdCgpIGNhbiBsaWtlbHkgYmUgdHJp
cHBlZCB3aGlsZSBidWlsZGluZyB0aGUNCj4gaW1hZ2UsIHRoZSBBUElDIHBhZ2UgaGFzIGl0cyBv
d24gbm9uLWd1ZXN0X21lbWZkIG1lbXNsb3QgYW5kIHNvIGNhbid0IGJlDQo+IHVzZWQgZm9yIHRo
ZSBpbml0aWFsIGltYWdlLCB3aGljaCBtZWFucyB0aGF0IHRvbyBpcyBtdXR1YWxseSBleGNsdXNp
dmUuDQo+IA0KPiBPcHBvcnR1bmlzdGljYWxseSBzd2l0Y2ggdG8gImdvdG8iIHRvIGp1bXAgYXJv
dW5kIHRoZSBtZWFzdXJlbWVudCBjb2RlLA0KPiBwYXJ0bHkgdG8gbWFrZSBpdCBjbGVhciB0aGF0
IEtWTSBuZWVkcyB0byBiYWlsIGVudGlyZWx5IGlmIGV4dGVuZGluZyB0aGUNCj4gbWVhc3VyZW1l
bnQgZmFpbHMsIHBhcnRseSBpbiBhbnRpY2lwYXRpb24gb2YgcmV3b3JraW5nIGhvdyBhbmQgd2hl
bg0KPiBUREhfTUVNX1BBR0VfQUREIGlzIGRvbmUuDQo+IA0KPiBGaXhlczogZDc4OWZhNmVmYWM5
ICgiS1ZNOiBURFg6IEhhbmRsZSB2Q1BVIGRpc3NvY2lhdGlvbiIpDQoNClNvIElJVUMgdGhpcyBw
YXRjaCBvbmx5IGFkZHMgYSBLVk1fQlVHX09OKCkgd2hlbiBUREguTVIuRVhURU5EIGZhaWxzLiAg
SG93DQpkb2VzIHRoaXMgZml4IGFueXRoaW5nPw0KDQpMb29raW5nIGF0IHYyLCB0aGV5IG1heSBo
YXZlIGEgcmVsYXRpb25zaGlwLCBidXQgaXQncyBxdWl0ZSBjb25mdXNpbmcgdy9vDQphbnkgZXhw
bGFuYXRpb24/DQoNCj4gU2lnbmVkLW9mZi1ieTogWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwu
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xl
LmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3RkeC5jIHwgMjQgKysrKysrKysrKysr
KysrKy0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgOCBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJj
aC94ODYva3ZtL3ZteC90ZHguYw0KPiBpbmRleCBjMzc1OTE3MzBjYzUuLmY0YmFiNzVkM2ZmYiAx
MDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni9r
dm0vdm14L3RkeC5jDQo+IEBAIC0zMTUxLDE0ICszMTUxLDIyIEBAIHN0YXRpYyBpbnQgdGR4X2dt
ZW1fcG9zdF9wb3B1bGF0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwga3ZtX3Bmbl90IHBm
biwNCj4gIA0KPiAgCUtWTV9CVUdfT04oYXRvbWljNjRfZGVjX3JldHVybigma3ZtX3RkeC0+bnJf
cHJlbWFwcGVkKSA8IDAsIGt2bSk7DQo+ICANCj4gLQlpZiAoYXJnLT5mbGFncyAmIEtWTV9URFhf
TUVBU1VSRV9NRU1PUllfUkVHSU9OKSB7DQo+IC0JCWZvciAoaSA9IDA7IGkgPCBQQUdFX1NJWkU7
IGkgKz0gVERYX0VYVEVORE1SX0NIVU5LU0laRSkgew0KPiAtCQkJZXJyID0gdGRoX21yX2V4dGVu
ZCgma3ZtX3RkeC0+dGQsIGdwYSArIGksICZlbnRyeSwNCj4gLQkJCQkJICAgICZsZXZlbF9zdGF0
ZSk7DQo+IC0JCQlpZiAoZXJyKSB7DQo+IC0JCQkJcmV0ID0gLUVJTzsNCj4gLQkJCQlicmVhazsN
Cj4gLQkJCX0NCj4gKwlpZiAoIShhcmctPmZsYWdzICYgS1ZNX1REWF9NRUFTVVJFX01FTU9SWV9S
RUdJT04pKQ0KPiArCQlnb3RvIG91dDsNCj4gKw0KPiArCS8qDQo+ICsJICogTm90ZSwgTVIuRVhU
RU5EIGNhbiBmYWlsIGlmIHRoZSBTLUVQVCBtYXBwaW5nIGlzIHNvbWVob3cgcmVtb3ZlZA0KPiAr
CSAqIGJldHdlZW4gbWFwcGluZyB0aGUgcGZuIGFuZCBub3csIGJ1dCBzbG90c19sb2NrIHByZXZl
bnRzIG1lbXNsb3QNCj4gKwkgKiB1cGRhdGVzLCBmaWxlbWFwX2ludmFsaWRhdGVfbG9jaygpIHBy
ZXZlbnRzIGd1ZXN0X21lbWZkIHVwZGF0ZXMsDQo+ICsJICogbW11X25vdGlmaWVyIGV2ZW50cyBj
YW4ndCByZWFjaCBTLUVQVCBlbnRyaWVzLCBhbmQgS1ZNJ3MgaW50ZXJuYWwNCj4gKwkgKiB6YXBw
aW5nIGZsb3dzIGFyZSBtdXR1YWxseSBleGNsdXNpdmUgd2l0aCBTLUVQVCBtYXBwaW5ncy4NCj4g
KwkgKi8NCj4gKwlmb3IgKGkgPSAwOyBpIDwgUEFHRV9TSVpFOyBpICs9IFREWF9FWFRFTkRNUl9D
SFVOS1NJWkUpIHsNCj4gKwkJZXJyID0gdGRoX21yX2V4dGVuZCgma3ZtX3RkeC0+dGQsIGdwYSAr
IGksICZlbnRyeSwgJmxldmVsX3N0YXRlKTsNCj4gKwkJaWYgKEtWTV9CVUdfT04oZXJyLCBrdm0p
KSB7DQo+ICsJCQlwcl90ZHhfZXJyb3JfMihUREhfTVJfRVhURU5ELCBlcnIsIGVudHJ5LCBsZXZl
bF9zdGF0ZSk7DQo+ICsJCQlyZXQgPSAtRUlPOw0KPiArCQkJZ290byBvdXQ7DQo+ICAJCX0NCj4g
IAl9DQo+ICANCj4gLS0gDQo+IDIuNTEuMC44NTguZ2Y5YzRhMDNhM2EtZ29vZw0K

