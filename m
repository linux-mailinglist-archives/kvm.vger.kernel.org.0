Return-Path: <kvm+bounces-53817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80AD8B17A3C
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 01:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22B5A3A7209
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 23:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7340F28B514;
	Thu, 31 Jul 2025 23:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YxxTW2m0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2116F28AAE7;
	Thu, 31 Jul 2025 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754005616; cv=fail; b=r6VRpRsH4roldH/nYyeWG3O09W7BWcdnVSLYWbZxVqmqy5HvT0IOr+VdJNzJc/MOQDC5Ipu3nSbXqNVy17bFso3uDTDI3t2XvyEH5be+AG4f7zExJXF3ykRXYJi+v3SSAIb6XKqTslc3p660meDqmhYslBBJ5BejEK0DU+xeK2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754005616; c=relaxed/simple;
	bh=yN/O/DG0nvWuhTicdh2CL+KJTRd8b9srpLPRNUytnOw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BEIau6bqsnC+dmaIp3fZsbKGk0C5uJB/BKGh6pi8gg5Y2HyrKYyc1mAsakrIViynqfClIF8mevPv953w0fO0ixY4KLs+DEXl5q2EXhlDn4uqFuSrX2L6Ul8+hFYQFVTeI7qoDAKRCotDQwSJQ1dv4JinVTjMF0biCq2lRf/ZZuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YxxTW2m0; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754005615; x=1785541615;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yN/O/DG0nvWuhTicdh2CL+KJTRd8b9srpLPRNUytnOw=;
  b=YxxTW2m0CBRIt98wbF/fQbpuGHXWWQzrIyRzzOiKtchBdMUF1TW+sKr6
   0OBBbg5pp9jCY5+ONtFu7qmPlZxTNJr8yCAeYqSFoFYcvAQSHnhP5Il+c
   fkrTaac6gSJrkPQ4VNCSlFIxxrS5bHyWHNvhQX8ksEmmvGCzXzBp5DuI4
   hwMA4+GTouHQ/vwm75+aC6s/Me5aWKMiOlhijf1tH1IRK6Lzv8KEnBvLv
   8s5s8b1J0BkvUKTp1lvL0Z4+r7wKnjIUCQTVGyp3aycU5Fo6Lm2NXTJAr
   TXFNWHi1MAAKssBLplDS8BrzMQG2iR1t8Q24af39DQg/qQ4lMnmBee07N
   A==;
X-CSE-ConnectionGUID: t+ZBg8pdTu6cZnm3OkwFwg==
X-CSE-MsgGUID: 7Lzc7OFHS8uDVuPvQ0q8mA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="55548023"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="55548023"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 16:46:53 -0700
X-CSE-ConnectionGUID: ZvhycFEQRryE+LuXx6amvw==
X-CSE-MsgGUID: dbRcefrNRwGg2BAjguDl/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="200564766"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 16:46:53 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 16:46:52 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 16:46:52 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.62) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 16:46:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qq72vMIWXiSIEg+XnH1tKUMrg98kdd40UElpE23MEIoVyGNKjS72MPTmoaGxQ5kRRavafaaFXZhgqOl/MRtI5Yes30RtVCFk91BgZ2h1J8mxmToA1FKDRbKaPssPAm1m+CK8FQ6xniGS6ndfCyyIS/+OPA77nsiDH95X8cLK8WdAVx8O/xjAuJxMvZkDPCoiYqbGTDzoBEeEmPjKYrj6gZCZkJlf9d0pM5h/1zJ5evcUqS6KCEc3Kv/2xliIAuahNA5l9SoStEmaoBNS6YWGDXj/uLfhFyfKbbJKO35h/2zoTp/3Anw6ab64MIcVUVp5D5Uqseehek4i2bh/iSY6NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yN/O/DG0nvWuhTicdh2CL+KJTRd8b9srpLPRNUytnOw=;
 b=aC4GD5otcEMgq/FaWcJb33LCd736cYLuGYmrqbK41Ag/+mz84t9st/7dWQ80skwt/xLfxYsAHindIs48HwNek8PwA8gC7u6eZFeKRGQsLw7IwLY+34REQj0g7rr+PIl0UpaRwRj5sYs5ck7qXeniV/R6hWLuX4LoYil9cKK+WsWfZA6A0SE48Yhka/wBcboRGEG3gvwF5+TkpE+0iyB4LRuN4GDEjtKDzdN4lfknjuPIfMVZQuLbJY4jNUlWHtO+TQnuy4axLJe+mopIzHBxJTHYG3ainaTJ8IBog+z4hu6v6BHqsSqUVQiKPaDGwyHRv7CPB4Un0s2WQLYzN/upAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7200.namprd11.prod.outlook.com (2603:10b6:208:42f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 23:46:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 23:46:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Huang, Kai"
	<kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Topic: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Index: AQHb2XKrlmf/Zzss+E+nUDEbBxD0tLQUQqeAgAAyUwCAAAf/gIAAyKeAgABZzICAABIZgIAAEweAgDWJGwCAAeXbgIAABEuA
Date: Thu, 31 Jul 2025 23:46:36 +0000
Message-ID: <3f39e6f85341e141f61527b3192cefde0097edb8.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
	 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
	 <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
	 <aFxpuRLYA2L6Qfsi@google.com>
	 <vgk3ql5kcpmpsoxfw25hjcw4knyugszdaeqnzur6xl4qll73xy@xi7ttxlxot2r>
	 <3e55fd58-1d1c-437a-9e0a-72ac92facbb5@intel.com>
	 <aF1sjdV2UDEbAK2h@google.com>
	 <1fbdfffa-ac43-419c-8d96-c5bb1bdac73f@intel.com>
	 <70484aa1b553ca250d893f80b2687b5d915e5309.camel@intel.com>
	 <aIv8wZzs1oXDCXSU@google.com>
In-Reply-To: <aIv8wZzs1oXDCXSU@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7200:EE_
x-ms-office365-filtering-correlation-id: 2a614e18-10e4-49fd-8aba-08ddd08c7c9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cHErMTBNM2NjY0EzdVdvTTFxYVNJWTR5S3VKeFY2S0VCdGxQZGlxMTA3NGpq?=
 =?utf-8?B?d2xVa2V3emtaTXZLa2JWK0ZudUlpWXhneUN2cXByZlVmRzdQRlJIRGZUMTg5?=
 =?utf-8?B?clVrakJBSitBK0pGVHhiMjBkdkhMdUdvZlB2clM1TU90aWJjd3NqMHVOOVZD?=
 =?utf-8?B?SU4wWmtKaDJCNTg4aXUrTVhrK2JlRGhoUC9ZN1Nwd2FwTGJWTHd0SEMrMTQw?=
 =?utf-8?B?TGx6ZmxjTDdMZDBaT1JCcDhNUWdPRnlRTytZTnJYd0ZnZ29iK3RJalROY1Fv?=
 =?utf-8?B?bXE5L0MyeTZ1WkRabGFmSEFNamszZHRSVGp2QUFuYysyaUFNbXRYTGt2QVJD?=
 =?utf-8?B?NkcxMWtLUklxd2xIQ09UNkVXb2NBb29qY0dkN1VEc1dWUzlrL2hiTXV5REgy?=
 =?utf-8?B?T1FxNGxRbDJJc1Q2L0M1Smp3bjZWT0lKR1NjRnZJdElGaGo2WDE3QUxNQ0xm?=
 =?utf-8?B?djdwWk5TM3QxUy9DV1BmTkZoYjVzVEdXUUdDd01XOEdqQTMvSUVLZnp0K21O?=
 =?utf-8?B?ODR0M3FHRjMzY0hIdEVKK2FUaHhLY01Ic0kvY2x1OHVoNDRKZXQzeW1jVHdT?=
 =?utf-8?B?TTF6QkcyVWZkQ2hVaDkxanpXVy85SGcxSHF3UDZxeDVMcnFzbkFUSVp3RUVJ?=
 =?utf-8?B?K3pRblJLUTV6b3J0ZXZ2VkI2OUg0YUhWbDVHQURUL1hBOWlsekZhbzZycE93?=
 =?utf-8?B?a0RoYlZzbCtmQ0ZaZFBCamdEeUhYc3lVK3VVTmw4NXFuekZkZHhmMGUyZWcx?=
 =?utf-8?B?QzB5RTdGcEREdWd5bjBuL01URk5GTDQwNXJPR3N3VGwxRDE3VU4rYlBNWjV0?=
 =?utf-8?B?T0t6Y05oQmUxY3d2bjlwQU5vakJIaGg2cGhKd1BIaklJREpDcDNZNkQ2WFRj?=
 =?utf-8?B?eDhvRWZTOXRRdGg0b0ZxYnd0dnJVbEVuc3duZzJITnVsYkQ2MTh4WjhtN3h1?=
 =?utf-8?B?bFAzT21lV29maVltK2dRWnhOTWNFaVF6S21lVzRNY0g5SGg0bGVDdGFwWEVr?=
 =?utf-8?B?Q3RZWTRDeldjeGhLbVJYUWRVQ1JkNmdCbjNnbWZYVzFKV2RjRGJmWFUvejE1?=
 =?utf-8?B?MTZOb1ZpK1BDdEQ3SU5ReEt2MFE2S0NlUGtnV2xzM3gyaldYK0RPd2pPb05K?=
 =?utf-8?B?QzVXM1VWV0cwcUJUUEtDRzNsd09GRHlxdWs3SzVEbk5TZ2pETXpKU3RlY0I4?=
 =?utf-8?B?am9aRDlhSkRmdmFGZHIwamFFN3VBRk1sY3liMGFZcW1aYVBBb0J4U05WSnho?=
 =?utf-8?B?UEExd0M4eWlsamQzRWVqQjNPMWdISW1qTnlIUytFQnBtOEgvNmhlN0M3aE40?=
 =?utf-8?B?Qnp0TEFBVURQOUE3aGw2QlpsWTRlZzkvRWV6Mis1VXBCenFVUnNQWnVIMjRH?=
 =?utf-8?B?b3lOSFpiZ0JuY2w2cXNOQmgrOGU0aEgwQkZwT0J4OGdYMDVCZGl3cnpwY3V4?=
 =?utf-8?B?MnJ2OWVvY2NVekZtUmN6WFE0eS9MLy9YcElIc2NuL1VXOWQyQ1Z0WXg4MG1P?=
 =?utf-8?B?YlJRQW9iKzF5SFZnL3V6c2l5SGdlempGLzNTV2ZNdXpZSlZVMFN4MWNUS1BW?=
 =?utf-8?B?ZjB4NEJucGdJK2NJWVZOOHMyZ1NNWGt4dzltOE5nY1J3dVliZWVPWm1YcXNx?=
 =?utf-8?B?SFBKQmdmSUhxQ3dVSUZpSE10RW1iSGNNNVJ0ZFlzTldveWNjUVpvQ2dSanlv?=
 =?utf-8?B?MlhrS2I3ZG1pRDlYemNTSk0wSEhhNXJXT081RzhGY2dGYkRacmZMdjhaVGQx?=
 =?utf-8?B?Zis4Qmg5akN1OXN5N2ptVmllK2lCQStWd0kvMkkxblNIaFRRYUEydDZrR3h2?=
 =?utf-8?B?K3plLzQ2YUFiSGtGNEpMMjZaM1JwTVpNMXUyZUJ5QjJZd3NydGc5RWlYZjhO?=
 =?utf-8?B?Y21xRG1DanVScWN6WDNrSmlsZGhCMGpSZU5sTFpBMkp3QWF4a2N0VkFhdGJH?=
 =?utf-8?B?NVh1bTRhUW9kenRNM1pJWmJzMlNyKzVQTDVBNE9Vbm5RSXJxMWozZUNkTXR3?=
 =?utf-8?Q?xFkcYHfr0kWyQDtG0lAbEh6NAXYEt4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2pERjltcjYvUStndks1UTk3U21UeHlMRDdxdTl2bm55ZFZIaDNuREtLV2FG?=
 =?utf-8?B?TmRuSWRSWkNqUTJNRGxQdGlId3o4MGp2WVBHTjhoNWdyZ2pCbTBiSC9rb0Fa?=
 =?utf-8?B?WHlBTUdDNlhYT09HVkZVcmpQR1EyUWVuN3ZTOEtzWmRxYjFsV3BnY1laYUxI?=
 =?utf-8?B?Slp0cVpPVVJKN0ZEQjBoT2p1azIzSjNnbXhTZTZ3Z3ZsL1FUQUxjMmRxelFa?=
 =?utf-8?B?Y2pEclFvYUhWRGZkZ3FzRzlma3BDK0VvY3ZsQTZ1VVRMK0xUaERzSU1CSmov?=
 =?utf-8?B?KzhQek5JaElQYjNEVk5EMExET1BSbHFSMWNGdVNjMmdwclpIaFJKNVNialB0?=
 =?utf-8?B?NW5pV2RTTERWM0pRbHkzRVdOU1B6Q3VOQmJrVG5sWThWRnBKN1NNY2dHUCsr?=
 =?utf-8?B?aitCNVJrUHNFVWFyZUJjaXpGU0pJSFhSTnJ3R1NxeUwxZmZBTWtIcUU1L240?=
 =?utf-8?B?V2svSmVkRFUvdDg1M1d2MXMwdU1PKzY4V24zVm5NVWpmbG1PalZ4c3Y2SDFG?=
 =?utf-8?B?dXlTLzRMek9QakpOU24xUEs5cDZxR3pIUmthSDNoV3g0T1lKMk14NGgvd0ti?=
 =?utf-8?B?SVFFZVE0L1NrdU16aTJpQVp1R2VZL1VjU0JyNW5pNmphbUt1L2M2V0ZWYUxq?=
 =?utf-8?B?WVo3NitjUHVGZ1hhTWRxNHJpSzJTcXRKYXdBK2pFbjhWdEdLSElDZFI0UXVS?=
 =?utf-8?B?SEFCaWh5TVNkWnlXNHhYYk1tbUllSWJlRmUveTVkTGVnRStWV1FNaGpscGRC?=
 =?utf-8?B?cmZGRm5oTEVOeGcyVUl2MHVSRlcyUkRNMFhUQncwbTFBKzlDcWhpMDAxc1Vn?=
 =?utf-8?B?YVh1U3M3THJYb01MV3RLcTEwMzlwZkNDN0EvK3QySlU3aE40Sng0Z1pJNytn?=
 =?utf-8?B?ZXJ3ektnNmFPVmZXMkw2NE5XUktFN3B4UXNPWTBmclEwZEZ2SmRhWG4yVWor?=
 =?utf-8?B?L0tYQ0NmMExwMVRGVVdENXg5UWxjRWtDYWpwbWlTK3RpVTdZQVJUY25DcWVm?=
 =?utf-8?B?SEFiTTYrMDRnOWZYaHdFUGYxNTNCWkV6NlVta0lGWUZIclpvcytoMzNraVB6?=
 =?utf-8?B?WnQwdm9BbngyYU9QTHEzRDZSZ0xjQjhxS2VLdE5GV05nZzlzaExHMDFLSXR5?=
 =?utf-8?B?ZVFLVWhyZ2dDRFRyajlDK0ZSeFNmVGVySE9Lc2VkM0FMUStxTDdzNnBjU2Zn?=
 =?utf-8?B?cG40R3F0UlF2TWVxQTFVbGxIbmg0UmVNcThFRnVwMEhUcy9EQWcwOTlLTGx6?=
 =?utf-8?B?MFBMRityRlV6VnpINVRqVUZRZndsTDVyTERGSTMxS25PS21pcVdzM2FmVTN5?=
 =?utf-8?B?d2xJWlFzZzcrdHQyZFo1bnJYWWhnUTBtSndWY0dyNUNOb1hHdUhrSzEvVW85?=
 =?utf-8?B?QVpnV09QMHZQcGp0U3NqNmtWQzRSQlhpdGdNM0VhaUNFTktCc3AwRTVQTGVQ?=
 =?utf-8?B?R1NPdWM0SllpbUx0Y0xRUnM1RnR6aHNQU2QyUzJ6TEdvTTR3NHFOaFVuSElR?=
 =?utf-8?B?NlBNUmh1UXJCR2I1MlZvQXNPQ0tHcGdqUWxRWXp3aUhXVTRlOTd3bFRDQkgz?=
 =?utf-8?B?VmRtN2NtaWZ4MmhheXdqOTRJTkE2enN4WmZCamZUUUZneXdEcXVFSEhyelBu?=
 =?utf-8?B?YlBHWG1yYmY1SkxiRmNSV3FtaWxNVHJOd3dta2JVbm80OVhGNi9MQTlHdThq?=
 =?utf-8?B?L1E5SDNzV3c1bnJ1cm5pL1FnRTRLRDltWTdMamhwcDcwSXlVRGc5bUhyemdT?=
 =?utf-8?B?aDRxRGY2WTdtZTVoU1kzZ2FXeUtqUldWTURqREw0VllEeUJIVDllcERMaklR?=
 =?utf-8?B?dzk2b08rSlp5QmtHd2JXMzJQbU1vT0pUTndlL2RLaHJXQVdyUXBRNHNJWGlZ?=
 =?utf-8?B?STdneCt1MEFDSTE1YnZmOXlwRzhGSCtmOFBYcGNFNWJFbzE4ZU5ocXR3ejFG?=
 =?utf-8?B?VVFMbzYrUWdLdDBDaVpOVzg1UUYwZ2RjNzJaeURLWnB1Skh2aHJoVnN1M1Zn?=
 =?utf-8?B?RFVsM2NmeVhJVEZJOUxrY1NFL2dLZlkzdzBGc081RFQ4MG83dmVUa2ZhSkRD?=
 =?utf-8?B?MmptaElYeHE2YklTYnNzRUM4NDdYT3paclVyYXU1b2c4bE91dFhPUEpWL001?=
 =?utf-8?B?SGM4VG1YMHBOa2UxWmdudGdMRGsyOWR1bk1NRjNFcXNtcGNtN0d4dlQ2d2NM?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBADBFB5783DA644A7A52AAD57AA0EBB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a614e18-10e4-49fd-8aba-08ddd08c7c9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2025 23:46:36.0734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KAol+VBa98icfi/OtfGmQN+RI+rP3wzUQDGh72OIu3Yi31s1OQSdYnhvmxp17JVfP+EPXeEyDHWYTwIc859i8lUU7ZUPCSYYLYd3nMSBLPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7200
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTMxIGF0IDE2OjMxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEp1bCAzMCwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBTbyBTVEFUVVNfT1BFUkFORF9CVVNZKCkgc2VlbXMgbGlrZSBhbiBvayB0aGluZyB0byB0cnkg
bmV4dCBmb3IgdjMgb2YgdGhpcw0KPiA+IHNlcmllcyBhdCBsZWFzdC4gVW5sZXNzIGFueW9uZSBo
YXMgYW55IHN0cm9uZyBvYmplY3Rpb25zIGFoZWFkIG9mIHRpbWUuDQo+IA0KPiBDYW4geW91IG1h
a2UgaXQgSVNfVERYX1NUQVRVU19PUEVSQU5EX0JVU1koKSBzbyB0aGF0IGl0J3Mgb2J2aW91c2x5
IGEgY2hlY2sgYW5kDQo+IG5vdCBhIHN0YXRlbWVudC92YWx1ZSwgYW5kIHRvIHNjb3BlIGl0IHRv
IFREWD8NCg0KSXQncyBhIG1vdXRoZnVsLCBidXQgSSBjYW4gbGl2ZSB3aXRoIGl0LiBZZWEsIGl0
IGRlZiBzaG91bGQgaGF2ZSBURFggaW4gdGhlIG5hbWUuDQo=

