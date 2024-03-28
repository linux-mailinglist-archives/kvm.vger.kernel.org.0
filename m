Return-Path: <kvm+bounces-12923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E44A88F44C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE5231F221B9
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8801BDEB;
	Thu, 28 Mar 2024 01:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MC3EZsga"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C549E386;
	Thu, 28 Mar 2024 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711587978; cv=fail; b=rZF1E75VHR03FRvYsvMqBpNwn6WyEeXIVTyB3+jS8u3PLAQBNENTtubamgWZaFvkzJB1uokCzNGR9yr0ErKqvHD9YSCYwDr9vUAkw0oHfhJCDCPU9H2+NorAzVPEjHSogDJBeD+kQE5rNrg0324AbM0FZs0AXeRFO22caprMHH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711587978; c=relaxed/simple;
	bh=c5iGGxz9H9J3+8qyuk7/e7jx3fRTgAr7/ZzP20I+bzI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C4iz1MsqyEOdVugaSvzdsNo57DCthPJw7kZiqMtSUz8lwr1lSZpEYyyfCz8YppLZz2e1ho6Oie3HDy8NQtqsvJR43rR+GZqsankJ2RFgpjsuADzRmwwvS7BC9eSWRlmZ0Fwj78N/ofAVoi9KeV8ZICwFR1YTVimsNjGoWIeQKfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MC3EZsga; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711587977; x=1743123977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=c5iGGxz9H9J3+8qyuk7/e7jx3fRTgAr7/ZzP20I+bzI=;
  b=MC3EZsgaV4uv/fY2guSfa/nI//ZkKiw9mpYov4p/s0zgs3UGmnpfpx+H
   tpsiHmdlHaCoxcQPXOolaxHPhOTKDevI03QabX5eGj+Z8oUFEqy+sT6yc
   qiExqTQWiQecD59tCOIYM1VwS0ZxQoRX1d/7i5SbBsq6G+qdwDSetKzdD
   Wlj2+NilhkWFbwyHVGn6UAWhKSMcoPY6v9M0u5FA9bRfLHJKwlVGDnFgg
   bdDtkWyL7gpfdTTJaBIWfDGTImXk84RtTzhpT8BkuFXap2qiShQ2DXVMl
   as5lRXydzzh+spsoLwGS8W8TkQgQcAuGu/MBFER0a20yEXnD6MU8yISOn
   w==;
X-CSE-ConnectionGUID: hi4mpstWQam89ypnckOtCQ==
X-CSE-MsgGUID: /IH2lueyQAWXUVzkFOtD2A==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="9684086"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="9684086"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:06:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21127608"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 18:06:16 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 18:06:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 18:06:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 18:06:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASwZxARWC/rwj1qkB75GhXn2oY54OEl2LUWO4uHG6LNUDO9lmXGDn/cVwdGCHy5fk+7xPdeCjRlvi03RdrLuJoCxthFhzRNBWy+5t/s3r4VOZQe47RnF16opRWUEWqSqp1Oj/dOIjDPz2W1Tq1icfxkJyKaobP3BSy8gCOvoG2sz0o247A5aWmTgOJAHUL/eFFKvWYPJEoyISe2y3+ZZs/0iaV+AwvsmF6aYorkEGRddgzucbZHK7MtvW1D4b4l68vWJCKmLBi1VOj4cWxOCmXp0fVX5+OAyPdxym+Zw0fQY9AupE3lh5SEAW4EHQXfo7ewX82AT5wsbXCiILB1x2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5iGGxz9H9J3+8qyuk7/e7jx3fRTgAr7/ZzP20I+bzI=;
 b=B8acMGoQvb28gR+TuxkPU0R2ybSx09MJ+/p+wdjetpHz12Nk6D8lBpAq0VXBTtj+wULiNRahYWwAiiKFKj+QzYxt6TTuRg67j278YiiwccWSbR/0PaSGeNtoGeCoDhBe4sCWBvZvNzAuP3mwEXXaLGg/+fdgpqjL8pgyYFGGMxcGcD8ZqY6sEX5SV+1bb1gg6vZTgs4lFaQ9v6uApH1IjkGP7eWsKyMIibIOK92SFMfEMByr3nUTyQQScL3qNedbljQG42qVdK84F4S3B/MBHBv0i6KDY6Bdjx29Sk5sf5qd/Y6k2l2whAtVaKm7dUI4U/6mSBVTGi9z4qIEmqeiyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB8003.namprd11.prod.outlook.com (2603:10b6:806:2f7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Thu, 28 Mar
 2024 01:06:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 01:06:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yuan,
 Hang" <hang.yuan@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gIAF68uAgAAN3oCAACgcAIAADqEAgAAC4oCAAAP3AIAAMXQAgAAC04CAAI7TAIAAbmyAgACYeICAAPZDAIAAbS+AgAAKzwCAAAOVgIAAAigA
Date: Thu, 28 Mar 2024 01:06:07 +0000
Message-ID: <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
	 <20240325190525.GG2357401@ls.amr.corp.intel.com>
	 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
	 <20240325221836.GO2357401@ls.amr.corp.intel.com>
	 <20240325231058.GP2357401@ls.amr.corp.intel.com>
	 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
	 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
	 <ZgIzvHKobT2K8LZb@chao-email>
	 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
	 <ZgKt6ljcmnfSbqG/@chao-email>
	 <20240326174859.GB2444378@ls.amr.corp.intel.com>
	 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
	 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
	 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
	 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
	 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
In-Reply-To: <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB8003:EE_
x-ms-office365-filtering-correlation-id: 28a0c60d-7631-4be1-f373-08dc4ec33fd0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L1hihTOkztzqkfm/OY4Rmm0J8RbsTjTl/Y2knEALXikn+EE9OT1ZpNBGuSFjZqJGz050pGCDjcTwuwBQkPSx3A7aeZ2RBqMnk45U0f/3DvlQt8adq/EBOrA5afK5yXB+i5Ink14xBfbC0Kt8sca7JrEMHR5DHaU3pKQaLUxkEnMY7JNdQzDatQkkmeALHO1kZF52z/m14rIvvYOLmS/hjJdJaTtn1LNLC4JGe+GgWHcRDgmrdlQimfV9wX+9v4K39WZBYpNGcPgIYCGLQAOK9IEdI6xVAR0gA8lfmaoFShwQxHbDM2/l3YPNBKkycyYsJQhbA+9AXx2VB9WaY2kYZTDrM4mW3jROanc3aYRTDSWIf8UPrua8rjsOZoEWasEioDe2uOq+X9dTpoetwfWLCFBXoVC+FdehGLFvyHF+XTE8MYqp5C3kRMcRXimYej8MWR/XxkxBwwRPgz/1p5lFpkGn97/Vr5AJwrXHuLo1g/oJuaGkK0bmEt4ISRRD+YhfakMjTyYe0TDPcdVmGy1/4LLrIacZbNzAyOdvuVW/sr3zGYpIOcwKlpIuvoX7VayVUQK5AvRoRRdDn09nwncwZ9ehuZa+kJ42wPVLN1xHlLdYIzt3QE3Noj+llFU0ZJC0GBG/PAInYqDMSdGZMhxq5WfbF1Osn/dsFg1V4c0NJdbVOGD+zc3UXmjlcUcqF4ZXq2eoont/pvQk/eeRx3+Kp90x26qH+Jbe5JUwXx92M4E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3dKOERTOGkxR1dmRjZNSFg0T0RQdy8yL0IwaDJCS3BuQzhwZkoyL3IySWJD?=
 =?utf-8?B?ZXJVNTFCbFk2SjJTVHFUcmhZKzE4VnlubXY5K2RTTnQ4cG9QQ1hCVEpYYjdo?=
 =?utf-8?B?NXVWTlM1eWtESEo5dXMyTUdZeXBDRHd2ME9VOE5FcGowL01hS2xZbk5sNWtq?=
 =?utf-8?B?OTBXclNacEhtT3Q1UHkvYTJ2QlljaURHelNLUXhEelZmTlh6L2t4UnJrN2di?=
 =?utf-8?B?VDhNZ3RRMEdUcHFLSitLcUNqTUhqcUxyekx0MnR1WGpoMTlYY054WldsNGRl?=
 =?utf-8?B?RW9hV3dLVFBtQlB0TnE0bHpseEd1YUhFeVJKc0xMdkRENVlNbDlWaTM1bVA3?=
 =?utf-8?B?R0VjcExzL1REanh1TnVPd2dTelVGOGV6SVZkK3BQNENPc3c1TlgwQld3NmUr?=
 =?utf-8?B?YmphRktwWENaSTduNHhaVGpTaWx6T1gxY0NNUGFOODJMVXFOd2N4bTdIZ0ox?=
 =?utf-8?B?djE0b3BiL2Fza01pQ0lyTjVvTU1za3VUSCtPeFJzKzV6VmNCdnNrbWxlYndo?=
 =?utf-8?B?WkN6bzdHSkIwVU5wTFZISkNETmRicmN5ak4rT21idzZTMkcvbjdLWnR5Z0py?=
 =?utf-8?B?eTIyNkZNMkRGLzd2ZmozWnNZVGRVeVIxRUpMSlg2RFJDODNSNTFTNXhtaS8v?=
 =?utf-8?B?VU5MMVdKMlFRaGJvcXk1RTM3NFlmMTU2bVEyQjlKZXRqMXUwL3NlR3lVOEta?=
 =?utf-8?B?M3RyMyt6eTc4T2VPaUhmRzJmOG84VkdnSGQ2cDZSQldrRnVoR2RNL29WdERo?=
 =?utf-8?B?NFpETXlBaFJMSHEybVNNUGo3UXlPanFldkplZjc3R2JQaWpBUTMrNm5yWHd0?=
 =?utf-8?B?NVg3UGlZNms0U1lGYWJkNkZQWWpuRzVRU3hOUmQrOHZEVWpUa0FxNXBZMW54?=
 =?utf-8?B?TzNxYjkzWURBaVBPY3RmN1lndkUzMC9vaFpuV0hNSUVZWCtvZktadkpKWCtW?=
 =?utf-8?B?eXVrQ1lQc1B2TUlyNGczMHdhRThNUWJlQllrMUU5TmhJaUlqWXNMZzIxOVFQ?=
 =?utf-8?B?VW9MNzJIR0JBakZ6dnJTR2xTK2JHVkE4Rm1yeTdSbGxNUzdnZ0hyazk4SUdC?=
 =?utf-8?B?aVh0UHZ0TlpuY211OTYzTGxIdkxEUTdhUW1qaXh5bjF3V2ZwS0RRWi9Ma0R0?=
 =?utf-8?B?S3BodW9jb3FjWFh5L0d4aWl6R253RHZLNWdCcXBrdnlVZ1VuK1RHa2JYUDBs?=
 =?utf-8?B?bXZhcGtjR0llbnVpaHJNeE9oRFpKdW8xRDlML1N3LzE2bXBFVW13V3JONzhN?=
 =?utf-8?B?aUZrSHpJT1l2b2VyTmI3VkVCbXp3Z3ZMU2pObER2b2EwYjNBOU9SOC9nS3Jv?=
 =?utf-8?B?MzhQdTZoY2tiWjd3aFUzT25pTkFuZzVUeVhYZ2Zuc3RnNVhiNXYwUmF0SUVm?=
 =?utf-8?B?b1NOeHFacWM0Rm5wV2pXVTNLZDk4Qjcyd2JUZDE1R0pSbE5YanE4S2tlblBr?=
 =?utf-8?B?a3dEaTlWLzBtVnRpRXZ1Y0ZpM1I1NWxvS2Rla2xLdU0yNTdvWXRwTWJzU092?=
 =?utf-8?B?N2FRaVQyS01kVnM3RFZXWkN3dmkzSWI5akhtMUdKaHhlZnpoNFY3L01MUmRN?=
 =?utf-8?B?YTRVNzRiZkgyV1R1bmNRMXk3RGpwZmlTOHBoWFAwdDRzNHQvVDVwaEFQYUVR?=
 =?utf-8?B?YWxIYXhqVmdoWXpVc3A5bjBQR3VuMlB4RkRVSlZDaGx4d1lUTW1zUklPSXFC?=
 =?utf-8?B?NHdlaUJZTGFjdmQrWndaSXp2RU84dnZBTlF5aWR1ZTBXMlVqNUQvK2VDWklK?=
 =?utf-8?B?R0ppdG1WZkl2SVhkeEVVMytGbllheGUxN0M2Ump5REp1bGZYQ3dvbGhIQzNl?=
 =?utf-8?B?M3BDdVZiaGcxVUlIeTltSk9UQ2VMQ2lBdUlVWTFpbWhxT0xhb1A1c3R1OENQ?=
 =?utf-8?B?SHZ5WElicEU5cWdIa3dUcitvTTV3c0UwMEFwdVgvc2d6aWV3NUZVZXBGcTVn?=
 =?utf-8?B?b0dib3ptekVNSEVRVWIySXNWZXRPeFovMlcyU1c5UTJ6QkZHejZVOHIzZ2VQ?=
 =?utf-8?B?Z0lHTlFsM0lESWhTTHk2SGlnS1ZSaG9maSt1bTV5V3lmUmNrSi9KZTdtQ1VI?=
 =?utf-8?B?RVhpNUswUHpPV0lRdW1iNWJPcm9JanREVStMTVZJU0pVT0c2SUVGTDJIdjNi?=
 =?utf-8?B?N2lIWnp3Y2Z1enpXR0N4MFJKOVdmaWlHL3YwRUZYUlBGdWlWSVB5VVBIQ2dY?=
 =?utf-8?Q?xNBMJtE2xR5M5xufoSyQnCI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F69AC4FB1A4B84981BAD160D65B2718@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a0c60d-7631-4be1-f373-08dc4ec33fd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 01:06:07.5762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CwA8J+jOpfwL1/fh//jAMwY/el0Agyyu0yUwsEQbpDHzI0OFGt4v7G2VOLnhGM04bC1BEV2sR2P7pkhUmu8hxobUQ+ORVwZKeOgCd9TTdpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8003
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTI4IGF0IDA4OjU4ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IEhvdyBzbz8gVXNlcnNwYWNlIG5lZWRzIHRvIGxlYXJuIHRvIGNyZWF0ZSBhIFREIGZpcnN0Lg0K
PiANCj4gVGhlIGN1cnJlbnQgQUJJIG9mIEtWTV9FWElUX1g4Nl9SRE1TUi9XUk1TUiBpcyB0aGF0
IHVzZXJzcGFjZSBpdHNlbGYgDQo+IHNldHMgdXAgTVNSIGZpdGxlciBhdCBmaXJzdCwgdGhlbiBp
dCB3aWxsIGdldCBzdWNoIEVYSVRfUkVBU09OIHdoZW4gDQo+IGd1ZXN0IGFjY2Vzc2VzIHRoZSBN
U1JzIGJlaW5nIGZpbHRlcmVkLg0KPiANCj4gSWYgeW91IHdhbnQgdG8gdXNlIHRoaXMgRVhJVCBy
ZWFzb24sIHRoZW4geW91IG5lZWQgdG8gZW5mb3JjZSB1c2Vyc3BhY2UgDQo+IHNldHRpbmcgdXAg
dGhlIE1TUiBmaWx0ZXIuIEhvdyB0byBlbmZvcmNlPw0KDQpJIHRoaW5rIElzYWt1J3MgcHJvcG9z
YWwgd2FzIHRvIGxldCB1c2Vyc3BhY2UgY29uZmlndXJlIGl0Lg0KDQpGb3IgdGhlIHNha2Ugb2Yg
Y29udmVyc2F0aW9uLCB3aGF0IGlmIHdlIGRvbid0IGVuZm9yY2UgaXQ/IFRoZSBkb3duc2lkZSBv
ZiBub3QgZW5mb3JjaW5nIGl0IGlzIHRoYXQNCndlIHRoZW4gbmVlZCB0byB3b3JyeSBhYm91dCBj
b2RlIHBhdGhzIGluIEtWTSB0aGUgTVRSUnMgd291bGQgY2FsbC4gQnV0IHdoYXQgZ29lcyB3cm9u
Zw0KZnVuY3Rpb25hbGx5PyBJZiB1c2Vyc3BhY2UgZG9lc24ndCBmdWxseSBzZXR1cCBhIFREIHRo
aW5ncyBjYW4gZ28gd3JvbmcgZm9yIHRoZSBURC4NCg0KQSBwbHVzIHNpZGUgb2YgdXNpbmcgdGhl
IE1TUiBmaWx0ZXIgc3R1ZmYgaXMgaXQgcmV1c2VzIGV4aXN0aW5nIGZ1bmN0aW9uYWxpdHkuDQoN
Cj4gIElmIG5vdCBlbmZvcmNlLCBidXQgZXhpdCB3aXRoIA0KPiBLVk1fRVhJVF9YODZfUkRNU1Iv
V1JNU1Igbm8gbWF0dGVyIHVzZXJzYXBjZSBzZXRzIHVwIE1TUiBmaWx0ZXIgb3Igbm90LiANCj4g
VGhlbiB5b3UgYXJlIHRyeWluZyB0byBpbnRyb2R1Y2UgZGl2ZXJnZW50IGJlaGF2aW9yIGluIEtW
TS4NCg0KVGhlIGN1cnJlbnQgQUJJIG9mIEtWTV9FWElUX1g4Nl9SRE1TUiB3aGVuIFREcyBhcmUg
Y3JlYXRlZCBpcyBub3RoaW5nLiBTbyBJIGRvbid0IHNlZSBob3cgdGhpcyBpcw0KYW55IGtpbmQg
b2YgQUJJIGJyZWFrLiBJZiB5b3UgYWdyZWUgd2Ugc2hvdWxkbid0IHRyeSB0byBzdXBwb3J0IE1U
UlJzLCBkbyB5b3UgaGF2ZSBhIGRpZmZlcmVudCBleGl0DQpyZWFzb24gb3IgYmVoYXZpb3IgaW4g
bWluZD8NCg==

