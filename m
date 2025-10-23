Return-Path: <kvm+bounces-60881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F6FC0094E
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 12:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1C1B634DB17
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 10:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9681D30B500;
	Thu, 23 Oct 2025 10:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ewOhuGqE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D049030ACF0;
	Thu, 23 Oct 2025 10:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761216790; cv=fail; b=IEPFFpoK4wAXQbkEnbwQ5eN06yRBb2ReMV/vc7r2XAS6y3nOuvPtKhH8JQn0OaTXKq4lMoL/sUO01XGuZqCKdo595nxdzMsr0HgFPU5ToDdsQNEG5kgxXh9i619fRvXZNtU64DwqLJ2jUgXojJzTukmlprv4FXpA+cZZ0JcxqhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761216790; c=relaxed/simple;
	bh=AQsxNT8qjrrWtk5sdRZxCUwgf7MYZ8rS8s5HtL7mAq8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iDhRSwFAS2FlmoQmwXSydTw8k3KPsK6u8fO3calZ6tWeE9I8TyDz3Hrmc3EgEhNLRagx92z+dQK4p2hvBalsc8/XwMm0xiCmwJqsbVSZ/fXzkwDGp9mROI+l7Ffum4hHOl7hZB60748qwA5qWenmVIo/doBzZlZ8mu18jgy2mBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ewOhuGqE; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761216787; x=1792752787;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AQsxNT8qjrrWtk5sdRZxCUwgf7MYZ8rS8s5HtL7mAq8=;
  b=ewOhuGqEnHa9BG62Z17cL3L92m7x3LW1WBWswV4p46pGdNDeRwEvTUEO
   VtA+ncdNKRAX4FqYOCkrN/v2UNO9d+gO4sFOwY1shDM64OmocKZLv+Pj5
   jr7AumzmMnnFX8rhac54PEmmGFu01lf5Gaax/H+dhQyVs5gehm9G4UmNN
   ewthG+qtrfMQhiQB7iqqsibyOlm30R7n5rU12Fp8+OvGlum9uGN9EJtxD
   eOs4Gdt678gXlmQiuqN3f0JC8n11EumuFxfsEucdgcYgWaTsAkr+4MYZn
   HqWXXRuXtbKcUQxeIBVtC6gA+iub46qYOWHECjVLxOchaFBwQWn8IF2Nj
   g==;
X-CSE-ConnectionGUID: Mx2e/Y1WSNmQzQqWfAsR2w==
X-CSE-MsgGUID: 1RdUfwZNS8C/bFkC3V1D4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73673064"
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="73673064"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 03:53:07 -0700
X-CSE-ConnectionGUID: 99QVwrZgQ56NBbJKrsff9Q==
X-CSE-MsgGUID: kbU3PDkFSyOhuSM1XuB9Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="183301182"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 03:53:07 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 03:53:06 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 03:53:06 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.70) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 03:53:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b9HhMWoFqdtJ99kKBren0RrSnOmoWNsBlxMk+wjh1eISZzudaoF8rv33MIHVoyFO/NnFbuds9Iu59J3RB3rWnwX0+daX39Zvy4pQSQvhfFThmyF21zwOgo+w8jyTpj42OrCE/B8m4Gq3l6CZccsTi5Xl5nfeDzfWT8rpuhKV2jzVp0tE5GexdAR7laU2rH6Fwt4h314fi/uDbvFkBtQsN+edCe/3yrB+Y4NbTqZ/ZtcMcDFZj+3tSeKwFhusKFFYeh1kulms5tWfGSbil2P4VVwJJgjw974ySrfWvQ22mspKo5Dq2afFK0z/msc6tNu7B1aoQjFCoCo758Q1l/fbUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQsxNT8qjrrWtk5sdRZxCUwgf7MYZ8rS8s5HtL7mAq8=;
 b=no35cCiGHV/iRJRNBBSjxj6vf97Yloq77tjv9EwHENEQQ0UqBbpy0Zi2hIKbRzMY+KP8zfxx2KrvMP0czVsVY+gCSnWXgmCi3Ds2SlyMGyx+s3NMA7euDeKvZZEXSqDWKeQwy4gGOUx2maF9xRohoHPeVdaAUpQR+tNUuBd1kPSBgXvTvLOFgX35FepngoXQaXm6CEkR+SFKg67MWWkBd3uMTZh+3mdiWhOJRNElKUUeSPwlSdpqnZNq4yI5JIJSk83V2pbRBYVuf6avKR3PbLUM5VFio4UOkY+YwgxELi9bysf47KU8LdsvsLp3tGp3vIkNrKZaqN0HAMeKo59AyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB5212.namprd11.prod.outlook.com (2603:10b6:806:114::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 10:53:03 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 10:53:03 +0000
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
Subject: Re: [PATCH v3 09/25] KVM: TDX: Fold tdx_sept_drop_private_spte() into
 tdx_sept_remove_private_spte()
Thread-Topic: [PATCH v3 09/25] KVM: TDX: Fold tdx_sept_drop_private_spte()
 into tdx_sept_remove_private_spte()
Thread-Index: AQHcPv2gLm0PphD5f0WVfdqHF7sfHrTPmGoA
Date: Thu, 23 Oct 2025 10:53:03 +0000
Message-ID: <28136b62074550826efa3f57b1f7be07f571abdc.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-10-seanjc@google.com>
In-Reply-To: <20251017003244.186495-10-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB5212:EE_
x-ms-office365-filtering-correlation-id: edb0e119-d43e-468e-1542-08de12225744
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VEVlWk94dXk5Tm1kbjNmL0ZXcmY1cWJFQVlnWHZjVVhnb3hYUUhwZmtHcG42?=
 =?utf-8?B?cVRERDBKaXRSLzh5RU9qUHRnVXVlTHhySGhTV2JJRkN6MkhXYVYrSU9xS2gr?=
 =?utf-8?B?dWU0ZFlYQlFMdmVBWXdNd1BWK0RsUmt2YXdUUzJXWnFLRU9rY2tZM0FkR2Zk?=
 =?utf-8?B?K3RVZkV5R0p2QUR2YkF1MWsrSWZmZHZUSDdUZTFoVmd3anp0WHRCdVprQUN5?=
 =?utf-8?B?WjFGVG1ZZ3hIcUR3aDN6ekt4djUydXFUczhrTURtNHkrMm5IN0UxeTVVdzUy?=
 =?utf-8?B?ZWo5TEdKZ3NSODh4b0VHL3lOcCs0Y09TMHFOeWpYUzU4cUM3eWYwQkp0Wnk3?=
 =?utf-8?B?MG40KzJDemJ3dGQ1ME1PL2pLOFE4RVR6YWNwdW84aC9IbmE5dUJ3Wm5SSVl6?=
 =?utf-8?B?TWdWa0JRMWFTaVg2Nkk5SDdyVGtPSnFrc1VyYU14dWdSRHRCR0x4RlROZzRD?=
 =?utf-8?B?NmlOQnZOTFB4bEJRZklSbUxXVGVxdCtmWWpCWWl1UEhDOFRWcGtFNjNiTFhI?=
 =?utf-8?B?aXloVnp6dWpmRGd0c2c2M2Y1eDZkeVBRZGJKOURucXVsTVNEd3RQdVVSSWRH?=
 =?utf-8?B?ZWhwNXdrTEFJb29Kd1R4Vk5Fd2I4ZWk3azZFTnlBMzVleWIvQVNkVi9sL1ZO?=
 =?utf-8?B?eDRDL2FhSHdieURpeGdYczhtRFhVMnk3SlRFa3c2V0lITjd0RVF5cGNhSUtE?=
 =?utf-8?B?ei93dEVISWd2eldVYW1UVVRNdXRaWVU4amdTbmZQNTRBWXhTdUZJYW90MXE2?=
 =?utf-8?B?Qkh4alRmTW1RSDJWL011YnNOVEF5Wm9lbVlDUlZHMStTbnV5dldZaExOeGsv?=
 =?utf-8?B?MFVnemxSUTRKbnJGLzVnSS9NOVJGZTJTMjBvR2JSQ3RjTVZRYjFmODN2RGV3?=
 =?utf-8?B?b3p3UUFkSzN3cERtdW5SUmc4RCtHTTlON3A3bEFmN280VklyNzE4OVlnYXhy?=
 =?utf-8?B?QUR5TFdBcDJMV1dZWkppL0s5ejZsTVdILzRuQ0p3d0VpMGdHaUNaNkRla1ZS?=
 =?utf-8?B?S3JPMVpMa09haUlLZURCTzJlZ2Q5Z0tmeUEzWkwvd3NJM1BTcGFvTjlwUlBl?=
 =?utf-8?B?WXlxRjBkeTJzMWFqSTloeHdJWHB2eFFBd1cvZ0QzaERsdTB6Sno2amp3ZnM3?=
 =?utf-8?B?UFFtVkxQNGJBRSt5Y25PbGM3K2RtY0RuamI3VmFKV3ozV0FJNXE1K2tZQjBW?=
 =?utf-8?B?WXpTZHk3WUYzc0xndjJPcVF5MHZCaVAxMmF6azZSanQ0K2F1T2hLUWlRdkFi?=
 =?utf-8?B?eFFYcWtWREhHbDEwemhnNFhVaDBRTUJuTWdQTWliRzNqVktMdVprRm10aHpG?=
 =?utf-8?B?bzNxcEtLQnl4U21UNVFhUFphL1VialI1VVptRWxSUll6dEVPeTZxNmUwZkRy?=
 =?utf-8?B?cjRDTjBMWi9QQXVKZDVIbmhYZDBYdUlQVnYxMEpxMmNpRG1JdTFSb0xDRCtw?=
 =?utf-8?B?dkxrZWZ3a2x6VGFCTzVwcVMyck1CdW95NjVVQlRJZ0Z2YmVTOEhRbVRHN1hh?=
 =?utf-8?B?YkxYSms2VFJ6UTBGSTR1S2dXNDJ2cTdxczJYMndrTWRjZVRlaEdNLzNpK0k0?=
 =?utf-8?B?bFFycDlsZ0pOeTVxenJqb1Y3ZTd2WUk1RkpFYzY2L1AxOEcyb3hXeVZHWXY1?=
 =?utf-8?B?eFQwSG4vNzNwL3cveG1EZGFKeCtHN3R6c0N1RXkvc1F4bWdFQTdEYWpJZ3BB?=
 =?utf-8?B?bUwwZndiNHczemlPZzEwU081WGxqb3MweWpLeXgvTkhUdXVmYU1zWkViRmlV?=
 =?utf-8?B?KzM5NHBreTFzaWRkV2ptcGdtNWY2aTBKSDdUSkNMSmtUTDdOZkprdWFVSENL?=
 =?utf-8?B?U0hxbW1vdUhZUUZUTlhjeXBZSjdQMnVRbDU1ZTJkRDdKNUQ5VG1XcWdWOEFa?=
 =?utf-8?B?K0FTQkROYnZXQ0Q0aVdTcW5FbWJiVG4zekhYNUQzeS9vSUJJU0drWlFuMDlo?=
 =?utf-8?B?amxPaWVldi83aWNQY1cvS3BYQTV4ZU15cUZFdVZxRisvVUU5eDhGRjZkYmxk?=
 =?utf-8?B?Q096ckRjdVJmUUp0ZmhCaXM2WlFKdkRKYk1BSnVMenNTeXQ5dk0vS09BV0N3?=
 =?utf-8?B?U1JUVmpPTDZFcVpoMVdPeTNPZFZKRjcyU3FEUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2Q1UlpHRUlBaytsVGkzZmVScXRNdStPbFVkbU5INURzUDJyL2txS3ZUWUdZ?=
 =?utf-8?B?eGU4YUhxQ3RYT1JncTFRZFh4L3pQWWhHUDN6cDYyeWtBVzl0eFR5TlVIcVNM?=
 =?utf-8?B?TnlyemVsUFQxMmM0YUVOaUJYcU43b0IxM1Jpb2FYMEsyMVRZaTBnUHdNelho?=
 =?utf-8?B?N1lvV2EvWDlFbGlidEtxaXAzdGhWbWU1YUsrUGNuRm40WDdYVmx2VWxPWnJj?=
 =?utf-8?B?aDhpODF5Mlc5YXdDOTg1N2VBU2R6bU9jS1lRVXcvY0daTWJPalRpRkUvUFNw?=
 =?utf-8?B?dXJhWGJIbmJwdHZ2ZlYrNGZSNVlxMkFiVUZQNUo3ekV2UnFlSjdQczU4RXVP?=
 =?utf-8?B?K3UyZVNFeFJiVXNVNHAvcitZZ2dlS05KaUo4eXJIOHFGVTdkU3MxdWF4eCt1?=
 =?utf-8?B?R0YzWlNJaXJLYW9NUGdZOXI4WGx5aEFrN3lYeEFaY1B1VjhwekFkeEZvM1R3?=
 =?utf-8?B?TUd2Z3U0M3hCM3Azcm5JaUw1NlNtb3l6M0t2OEZmRllmSkpzTnNmZ1lBU0NP?=
 =?utf-8?B?RlFzbGlhUVMzM05MckZURG5IZmxHVGF1YVl1djhHR1BRUTNWRWhCQXczVnYr?=
 =?utf-8?B?YlZNNU5hZ1Q5N0NEcXBSaDlETTlocjZoSWRkQ25ocXhLbDNYNnVGYmR6S01C?=
 =?utf-8?B?T1dIV0w5cnRaV1dSNTcwV1Y3R2I3L1BRZDVRTkxmUWFRRFM4eU5UNWE4cFYw?=
 =?utf-8?B?aEs4VDB6b0JaVHcwczZSNW4wMStSeWpUVWcyM1dkV21IOGVNeUpZb2hIMDFm?=
 =?utf-8?B?ZkVWbmNSam4yT2JUY3orQVllNWdEM0JnSjNQcmJidVRmTFk2RS9UVSs1RzRD?=
 =?utf-8?B?ZldDWnc0VlNJWTBKSGNPeG12WHhwbUYxbmRRWWV4UFVJY2g1bDdRRzVWOUZr?=
 =?utf-8?B?V09DRDdLcFNhZkFaNkhOOXBYZTZDQ3ZabnJXUmE4ZFRhbzN2dGdhSFI0RUhy?=
 =?utf-8?B?My9iT1dRVzMwUkVtRzF4ckxaK1lycWFkcUlYZlpoUDVxeFZXclp1WldiSGhV?=
 =?utf-8?B?RmRVSThmbGtwZ0MwQWxUNmlmeVVLWFZPcXVsRTU3WlpQK1FraXVKZzdUT2NR?=
 =?utf-8?B?RUhFY3lpaitvbjIrNktEdEMvUDh1RUIvMUFGaUZORFNwczFoT3NVbkwwckZ1?=
 =?utf-8?B?L0ZFQ2h6Q2dJcG9qZWplbTJKVFpqbzNqOWJtSm4vS0x0WGJ3ckUxaTV5VVNC?=
 =?utf-8?B?L3FEemRRMkU4cWhyMWU2cTMxQjFpQ0ptRTl4bXMzbFY1VXFkZ0YvaDN6clNW?=
 =?utf-8?B?ZjlzRytHSWs2WGNOSmNHT2dxb3l3Wjlta0hGeU5CUFl3WDZrN1kvQno2Smhv?=
 =?utf-8?B?aVA1amtmVzBSVnJMb1hqTlpDc2I2VGxzOTlSSWJ1Z1FMWG5VVmljanpERWhq?=
 =?utf-8?B?VEVqamkySGhSb3Z6RmlsWW1jVGxSbHZlRXk4WWlSQzNydER6TEhMQ1lYcmNE?=
 =?utf-8?B?Q1hMZXZPK1gzNjdEdlo2b3NSVFp1SnNibkFKT2dmQmhsQWkzcXVJN20rMWZ2?=
 =?utf-8?B?aGZIYjFIRE5pS0V0TVhGSWFGSWlYSHIrR2ZlMG9zQmF2eHhZc2piV1hCUTRN?=
 =?utf-8?B?L2t1WHhMUURiVXcwZm5BTmZTMUJZU1FEN2RrM2E0NFBPQm9CaGJueWRUNGxQ?=
 =?utf-8?B?Q3hvbWNZT0hzanhmcEY5YmR0WDd5OUFOYXpVT000M05XWXF2SCtVU2VqTms0?=
 =?utf-8?B?eTlmd1pTa1hrMVVHbDJBa2hVSXdadHVDcit2cUtueDBpckVVVXpYNER5KzJE?=
 =?utf-8?B?dzNTZnVRbDlqbm9pazJCT1diV0t6QnB5R0xCSk1CcmQ3OGVOa3NVZzM5RW95?=
 =?utf-8?B?dDNENy9QTlZaNkRxV0RQVWhWc0FJN1VwdXhZbFl1TVhBdjE4QUhLU2xDdDB3?=
 =?utf-8?B?NDF5V0NzaWMvVjdMQVE5TFNjay9RVEJQZ2ZpMjJRS0piQ3VObW4yT3VidWZS?=
 =?utf-8?B?ZG1vUWdwUmxRWEYzcFVSTHJsVldrUjhucDM1em1RemQzazZxNFZwb1drb3Qv?=
 =?utf-8?B?UE1JenVsRzhCMEtKQS9leXhwVStvTDlPNDhMOGNmRSsrZUNNZWtzNUZsdy95?=
 =?utf-8?B?T0lyeUhSUUhFa1lYNDFFQVdjR2crVDFVbUVtaFdsZEZMZVdsM3NOTFNjTmNr?=
 =?utf-8?Q?DPTJFdKQF3SbNoccr7Liy9fHn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E15421E36ADD24CA5133917FFDA3995@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb0e119-d43e-468e-1542-08de12225744
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2025 10:53:03.5123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ASmAs+OADeHcNJS295X4jOriD8HIAmZTnOMsg8OkDilaoFmEN7mCypeiB2Ns2JATGmq1BOQjSm8zVoY7how0/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5212
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE3OjMyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGb2xkIHRkeF9zZXB0X2Ryb3BfcHJpdmF0ZV9zcHRlKCkgaW50byB0ZHhfc2VwdF9y
ZW1vdmVfcHJpdmF0ZV9zcHRlKCkgdG8NCj4gYXZvaWQgaGF2aW5nIHRvIGRpZmZlcm5hdGlhdGUg
YmV0d2VlbiAiemFwIiwgImRyb3AiLCBhbmQgInJlbW92ZSIsIGFuZCB0bw0KCQkgIF4NCgkJICBk
aWZmZXJlbnRpYXRlDQoNCk5pdDogaXQncyBhIHdlZSBiaXQgY29uZnVzaW5nIHRoYXQgeW91IG1l
bnRpb25lZCAiemFwIiwgYmVjYXVzZSBhZnRlciB0aGlzDQpwYXRjaCB0ZHhfc2VwdF96YXBfcHJp
dmF0ZV9zcHRlKCkgaXMgc3RpbGwgdGhlcmUuICBCdXQgaXQgbWF5IGJlIG9ubHkgbWUNCmZlZWxp
bmcgdGhhdCB3YXkuDQoNCj4gZWxpbWluYXRlIGRlYWQgY29kZSBkdWUgdG8gcmVkdW5kYW50IGNo
ZWNrcywgZS5nLiBvbiBhbiBIS0lEIGJlaW5nDQo+IGFzc2lnbmVkLg0KPiANCj4gTm8gZnVuY3Rp
b25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBSZXZpZXdlZC1ieTogQmluYmluIFd1IDxiaW5i
aW4ud3VAbGludXguaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVy
c29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCg==

