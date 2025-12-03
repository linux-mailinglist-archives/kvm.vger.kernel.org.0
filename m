Return-Path: <kvm+bounces-65236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FE2CA131D
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 19:58:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3CAE131B5B35
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 18:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D9DB316185;
	Wed,  3 Dec 2025 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CcS/YYlc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A2F313E36;
	Wed,  3 Dec 2025 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764785729; cv=fail; b=J8BlUvvVF1fUiAHekmmks7iYHgSyUs/DRr9XfLcdlSiav4o6YSIzlJr2tlAHougI/AHkknBDIYimlJReNhGhqWvYgoGfWSqUuMQzM1S070tjwV4j9XqTTStymBI60/gWPIatLJ8LarCd5eDGh4v8F2lqcZ/Uf0YIz1bNvVh7S8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764785729; c=relaxed/simple;
	bh=i7TFMmiuN81cF0f3EUaTmna7MdfafxZF4gyaKqhm/Ek=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t/x1XqkA0IGFdSLEDM0OFjjJFBreHmVdlPPAwutvZ/jJKVX2RgTNQBHVoSy2QXWvTd6td6VHe3Es88MWMRyR0YfaPIKGPib5acxbSTjPsiPSgWhdJkFKW31YPl363PyI2QgKEdX1pHyZU3k/8pbLy2lIkp4JPZon20YZCiODm2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CcS/YYlc; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764785727; x=1796321727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i7TFMmiuN81cF0f3EUaTmna7MdfafxZF4gyaKqhm/Ek=;
  b=CcS/YYlcPabsqwyZaqPSY5q5Ap6ggjJL+UCYdLZrenftKNzu3PdzE91U
   +UGh9Ml7dPUcPN4B8kLoedHOnd2il3Kz2BbrrfVlkAN6ngNFJQzxUcw/i
   Jr0nB6meIFgQn3tnPzyMzzdApu+XNHRkJ0uSmItrQnne5zIUQRy0VRu0/
   NWoeiLJGqopvAh5o4h985BdHDsPm+df5frXJxyv5+E3zfy/ULr9e7dy7p
   oXGY3wOZeO+xjReECuEDy90WjlENRrvQncVkRAEYMhfaP7l3kROtuLgDq
   tYAVm0Y4ddlgm/iJQlI6wd2KHy0jDlEK2aOOA7CK6a1C2WguJSq8Gk39e
   w==;
X-CSE-ConnectionGUID: znS/ro21SM2LJc0HblgkRA==
X-CSE-MsgGUID: WIY3KYxoTOWJpHgjL9bmsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="84391075"
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="84391075"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 10:15:26 -0800
X-CSE-ConnectionGUID: hBoBXQOoSIOsPgoyLCMyOQ==
X-CSE-MsgGUID: SZaScqblSnyH2CSWLwetxg==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 10:15:26 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 10:15:25 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 10:15:25 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 10:15:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpvLRLr33lhti1Ey1z8jsHjBY9j7oDdKLNvf+KH5CM3KqSM0XNkGOWuTnWflC/aIVq/NJGjK15TML/oyAiqV+XrsWHPHKjLSAfyNc4PcPI4h9gv/9GwBNFX/lxSWViTBqv1snsXoFsMfMG8SkokjNQFXCCemkRn5AZr0SzuoNrtH3bBGTZ6iUXeVZwUj9pDd7jBqpnMZI+JpZZq8kywkKh55aeQgkCtNtAirtDyZC/XwWjWKY5CZpYQNGaFPvW4ahpHs8fdrTLBO9+vBo24+FfftjvFcp/uLzG//fXzYe5Ik5uQmFgYMGy05so34SiYCCcEfQTPOzXQWyuEPKxLYlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7TFMmiuN81cF0f3EUaTmna7MdfafxZF4gyaKqhm/Ek=;
 b=mtMSbwBevI/pntBCbpBcxhIkkbzeOtAvJ0s1/VHNfV2e1Lr1cw29UpzJmOqyaw6wCLOBOqblt4WBjEWTgsTvyY1GYkzmc5tGDg882hOxKuhwP1Lb0jT5TxpCLSiFofXm6+QOpWtMc8T7ZWVFSJWI3jx8uHlPNayzAiyQZPa8uIUyBg+/WM/ESgTw8LK9GQkvCH18z13frX5D/RC6IbqlTf9YrGlZP+P3BiIz2rKidEH0Oy0kf1xmIfuMILZKgFFth/KYJivF/klPije/SEvCMTIqRqHtQYYLQ2crCF0XQDfeRiXEBXtbFzfnrETZmglTbhLqqQgeh8GP107z/9q8Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH8PR11MB9481.namprd11.prod.outlook.com (2603:10b6:610:2bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 18:15:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 18:15:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "kas@kernel.org" <kas@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu,
 Binbin" <binbin.wu@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UGu/sAgAa1nwCAAJayAIAAz+YAgAEpIICAAADQgIAAH1uAgAArEgA=
Date: Wed, 3 Dec 2025 18:15:21 +0000
Message-ID: <bb174006cbe969fc71fe71a3e12003ab9052213c.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
	 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
	 <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
	 <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>
	 <7xbqq2uplwkc36q6jyorxe6u3fboka3snwar6parado5ysz25o@qrstyzh3okgh>
	 <89d5876f-625b-43a6-bcad-d8caa4cbda2b@suse.com>
	 <04c51f1d-b79b-4ff8-b141-5888407a318e@intel.com>
In-Reply-To: <04c51f1d-b79b-4ff8-b141-5888407a318e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH8PR11MB9481:EE_
x-ms-office365-filtering-correlation-id: 8f0bb72e-3ab7-4a23-cc67-08de3297ebec
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MEdXQlM2SVBBRkRvK2thOSsyajlJd0Y2dHZFVHA0Qk53WFJTWTNMaHU4aXFH?=
 =?utf-8?B?YnhKK0x3Zm1aWTYwUEhhTStmby9GZXRDbklMcW9vdk5iaXU2THBSVmh3emwx?=
 =?utf-8?B?QmQ4WkJqSjRwMVhOVk14Wnk3ZFgyTHBGYXhSZUdlTWZXdnNuOFZxUk5qYitX?=
 =?utf-8?B?dVQvbXM4VUR4eHBWcCtBM0VhWkExbWY3WVh6djJvOTB0K1V1T3pScGNQMy95?=
 =?utf-8?B?QmY2ekplUUlENlZTaUl4RWJ2a3pyRjYzWHQ1ZGVZcSs5cVljVFNHdko3MGJJ?=
 =?utf-8?B?NmwwQnlsTUIvcml6Zi96Q1BHbXkraDJMZUg2WkUxelFRWmVUUW5xclpPQSs4?=
 =?utf-8?B?WkFFelUrTytub1J4Rjd0QjQ1cllITTlJaEtXelpLMTUzUnNzSjRrNmhXTHpG?=
 =?utf-8?B?dlFsVFo0b0lVNHR2RmVlc2hPR3E4OXdEOVZpZmZaVDg4WDFKa0xhY0VKU1R5?=
 =?utf-8?B?MldUZ0JlWGVTeFZlSEU0Y1I1TWJpZDByKzdzR2oyV3pGQVZGOGJ2S3RjSDNs?=
 =?utf-8?B?Wmd4d0JlcExaS2RzNTg3TG5CNjFhb0x6Ynd4UERnYlB5dlJFclNYN1kvWCtw?=
 =?utf-8?B?VFZJZS9hajNNYlJodnp3SWJITGllMldscjNlRDNzdHpYbXR5ZzNETS81VS9L?=
 =?utf-8?B?YTNFVkdRS2w2emdWNCtxWmRieVN4akY2V0QzbzNnbmxMd1BXMkFxeTU0cjBM?=
 =?utf-8?B?cXd5ZHRzV3hNb3YzQmJIcmlUQ2tMZnZrcG5FbXB0M3FQSEMvb28zMVZQU0hL?=
 =?utf-8?B?dDBTUjJzR0xVRGY3M09MNnJxRmNqUmdzZ09BcjZhaGRjVU5vUm5ZdzVBb2E1?=
 =?utf-8?B?Z3ZZbTVac296bmtOQW5XV25sOE5lRzdpMGEvYTR1OXhHOE9zc0YycTdnMHNX?=
 =?utf-8?B?SUYxZ20zc1FiS2YxcXMrbWxFNm5tOUZ1RU5PQVVxR25qTVNFRysxOEl6dVFD?=
 =?utf-8?B?QjZwYlhPM0dpV3hWSmd0cU8xdG5zWTgwcC9mdll0WnZHZi93ZGhpeGxKK1ZU?=
 =?utf-8?B?MG4vVDlwSXd2akFwemlQMUcvNmlXMFByRjlZRllEaUZaZ0J3b2wyZ2hxRnRQ?=
 =?utf-8?B?MWVWZjJnZXFmM0JXdDIxZlB3eTlzSE5FbmFNOWl4a1RQc3VOQWd5YzhETXNP?=
 =?utf-8?B?SU9qTWZuOTJUNVdzUEV2REVJQm5BY3N5RjQwdStRenJseThrWnBxWTZhSGdX?=
 =?utf-8?B?RWJoa2RsdkpiUDRTQmRFM1lMZTdqalprRHhNaUZkRkt6RnJpK3VrWkV4bDIz?=
 =?utf-8?B?M1hncEgvTlRDelQwbjVFWFlEdmF3dENLMkIxUm0ybFBrcVpmVFJyTmpIMFNV?=
 =?utf-8?B?ZVlxb0NkemVwYVduMERxaVZNd29YUnZQbnJVZkprSmZXQ0p5NlRSQjkyY3VX?=
 =?utf-8?B?Z2hLR0ZYNTNMclIxOWtYY3MwajZibmlsZlZ6elRmaTJsMW03UWgwZlF3S2tX?=
 =?utf-8?B?QUppY2xRZ2V5UVZnRUlxb25HVE9TcitiL05uYXpseGhxRzlUdmtVVW1HNWpM?=
 =?utf-8?B?d0xFYjhGRTRiNlZaV2c3TW4yMnY0R3RKSWx6eDdJUzJZTXgzZm1LYnhLeFpT?=
 =?utf-8?B?ZHE1KzRQUytEN2UrQVB3YTdsaUJEZnE1cnkrbTk4TmpRY0NZTnJZTHJsa1JT?=
 =?utf-8?B?c2pjY0tZT0RlbDlpZEl0UDUxcm04SmxPUHMvQWJXZjlTZE0yMm40c3dQdDNY?=
 =?utf-8?B?a3d2VG5UZkhaZUd6SUtGTGFoMk15cnEyenBEUWQwZTJMQmJlY3V0azdQQ3lS?=
 =?utf-8?B?QXpxcXhjYlQ4QUJEUGJQLzBWVVVIQ2pUbENjaTcwVTVzaENCbzE1YlBSUk9D?=
 =?utf-8?B?Q3hRMlZMMlBvUEw4M0pzN21jeHM3NlBrSW1LenVYK2xiem9HOUlZam95RlY1?=
 =?utf-8?B?Z2VKeG5hMGxxNjRWdHNIOHNvZ2NaQStQeVRINFZ2MHdPVnpLL0kyQ3dtaTZR?=
 =?utf-8?B?T2dvbHI3Z2ZhaloxYkE0cUlzMmcxakY3T2ZaSnIzYnFJU3UxUDFCMXJSYzJm?=
 =?utf-8?B?SDZBd2J6dVhKVlVnSVllbUVCaVE4S3VXR3JhNktlbWpDOTdKV25JZWc5TnZP?=
 =?utf-8?Q?J2Sw34?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vk5zUW1EdEVjdnNCK252RDQ0Nit5OFFqdEdTWlI2WGlaR0RoVVEyeThqSkZx?=
 =?utf-8?B?VU5LdDJKQTNQRmJCNlBhV2Q3bWx5MjBSYzFWb1RvZXhFM09CUllnUnlSNk54?=
 =?utf-8?B?VnNBNGN5MUdqQ3YvWFZhOFFrRllCRnRSa3hUa1VEUG9EdXpmMUJoZExTNWVP?=
 =?utf-8?B?MHlqMGNpZHlzWVlQNXpFM0F5Um1Db0Q5WnR4UEZZWW53bUF0Nm5hVjMxTUk4?=
 =?utf-8?B?dGlwbWxmNEd4VXA4RVZrcWhjYmNReHl1TGFUQXAyZUEvYVJJK0RRdTY0SWpm?=
 =?utf-8?B?V1VwblgrWlNDZ01JZTBsd3dNUTBUMFZVTGN5Z3RLdkRITmltNVpOdTAvNEVW?=
 =?utf-8?B?Vkp2WmRER0FpRXZlUDNxK2l0OXJocHJxenR1RFoyM3VLalRScEZLSHo4MHEx?=
 =?utf-8?B?UGhVd0o1UzlTWUp5ODNBamhZelYyTndPMDlyWExYd1Q0UmdFSTRNazdBV285?=
 =?utf-8?B?d3Vjb00yZzRmekJlb1E5Sm5hdVVOYjhuRjJ6OXptT0dQbGdxUGQzV1R5V3ZK?=
 =?utf-8?B?eWJ2dDhCWkhIcG1DTzJRaGVEcTU0aFpNeVVoSVg0a3RxM3Jydy96QmpKVkxu?=
 =?utf-8?B?dHBQTVMxenNjdGtLMndqTS9lT04reWM1R2Rkem4vcXVaOHBOZEp5ekU2cFBh?=
 =?utf-8?B?K2M5U2dCVWlrcGdyMmk5QXR2Y21yNkNyVS9WOXZjVnFNbExhN3ZBcWxmd012?=
 =?utf-8?B?eWdZWFZmUGRWeXVIL0NRWjVDb2piN0lPSlg4clZRTUU5SVA5QTJuY0Q4NE82?=
 =?utf-8?B?eXdYR2ZQMTczTFJiYXUvSmoxS0JyME1WVCtmMHNXTURFa0VrQ2ExN2VnVjUv?=
 =?utf-8?B?disyR1BtWkI3L2tkbFNFZWd3amZ2WmpBSmdhc2FraEpQVlhudXVlZkhSQ0E2?=
 =?utf-8?B?Q3BvUUhYTkdSYnZjOW9ZaHduRDgvRy9BZUxCMTVDNFgyUUMwWDdVZHEzN29X?=
 =?utf-8?B?NVdyaXF0UTdpWHMzaFpGTTZ5bHNjVytGSExXbStyNnhQZElLeVR1MlhnRDZ3?=
 =?utf-8?B?TS9HdG9XanorQWV1SDFjSmVnRmhKdHdFOU5KZHR3S2RlOW1odFhhY0h0WmVO?=
 =?utf-8?B?WVp2RloxR2dPNWVla2RkRXNnRFhOd0F3dWdIRXJzSG4rRWNWWjN2QmRvUStS?=
 =?utf-8?B?dTZMU1RscW9JWmJsclM1RVE3cjVrY1krYk1DSUhLVlRZNnFrK2xUZS96YlFF?=
 =?utf-8?B?UTFRZWxwOTlWR0l4Ti9BbTRTQldkSExIenYrWmtGRzl0K1l1S3JBM3FJS3Yy?=
 =?utf-8?B?NUQvZUtYMllWdFJPS0RGMlJ6Z1JlSkVpclBaY2h4aGVkMUdiMFBpMjRZb2tU?=
 =?utf-8?B?UUM4WmQ3Z2o4U0xOWW9uYTVTMjhMMnkwWVVVRGhOUGhBVmpLUTgxbVpsZWRP?=
 =?utf-8?B?U0V4S1RiK0JlQzI3UUI0Mkw2UGpHTmNlUC9OSEhHdnlGMTlyYTdzK1g5MENH?=
 =?utf-8?B?K1ZTTFR2aHNRRURER3ZhZmQwSWZOYU5QQWtuZzZDQnhtUUxLVGFob2lLSFhW?=
 =?utf-8?B?SkcwUHFKWVYwK3F3bGovUUYvQUhwOEpmWnpQUWlHZzRlc2VVRG1jYUxaaENx?=
 =?utf-8?B?bGVBK3d2NURqd0V2VEdCMDlYNXczY0orc2FqQTVKOWZLdVJnVktpVEI1ajVL?=
 =?utf-8?B?Ukx5dlJ1WHVSUFNwVkpkaVZGeFRJTXdQNDhwd2lXOWRRS2JSK2NKRmNVcldW?=
 =?utf-8?B?ZWtuZ3FGcjE4YkJPQ3haWHYwb05MTVdmdThlNU9mTUViazI5YWVvWCtVdHB3?=
 =?utf-8?B?WDR6M0dSUEVFRGxremRoMjFvYm1Nb1E1ZGkwSWlqZC9YTllUTTI2RUp0UzBr?=
 =?utf-8?B?cWJHdU45SkozRlY4R3Y1bkt2bGN2VFlhSmlQS0J5bG9pSUw4N3lOaGlXdDdr?=
 =?utf-8?B?TVhhOWlVSU1mRW5wdldhWWtsQVFnRFRkT296T1phUHBFVy8zYVBvcWV3V2Uw?=
 =?utf-8?B?TjJvbDVvNUhHRmpTaTlkSm9objVPdG5sRFJUaXJNd083aW5IR1p5dlBickdQ?=
 =?utf-8?B?SjdyZkRkOE1PMlFEdVNSWDA4a0JNcCthdGFJek5SZVhLSjFEOHV1bGNzVUpu?=
 =?utf-8?B?eFNpM2k4T2o0RzIyTmwvelVnTXFHQ3lPUVNCVW42R2xVMHViN3dTaTl3TGtn?=
 =?utf-8?B?YmtVUEJHTGZ1QjR4eEF2VmF5ZzVSblVUc1JPdGowdExwb3RyOHpDQmtwWUVR?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEAE7DEF55C11E4189C31EB6879AC8F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0bb72e-3ab7-4a23-cc67-08de3297ebec
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 18:15:21.2259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qE4TGh9QYU0E7K767hRoIEOJCx5dzrQjoq2QcQqfgUJj5n3rdQvO22jVe7xvsd8ILYAgmIcJ9CdnJdUdBDQ25xaWvJcIe4gkdLzX0KESycw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR11MB9481
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEyLTAzIGF0IDA3OjQxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
SXQncyBmaXhlZCBhdCBhICJwYWdlIHBhaXIiIGluIHRoZSBBQkkgZG9jdW1lbnRhdGlvbiwgbm8/
DQo+IA0KPiBJZiBJbnRlbCB3YW50cyBhbnl0aGluZyBlbHNlLCBpdCBzaG91bGQgaGF2ZSBkb2N1
bWVudGVkIHRoYXQgYXMgdGhlIEFCSS4NCj4gU28sIGFzIGZhciBhcyB0aGUgY29kZSBnb2VzLCBp
dCdzIGEgInBhZ2UgcGFpciIgbm93IGFuZCBmb3JldmVyLiBMaW51eA0KPiBkb2VzIG5vdCBuZWVk
IHRvIGdvIG91dCBvZiBpdHMgd2F5IHRvIG1ha2UgaXQgaW5mbGV4aWJsZSwgYnV0IHRoZXJlJ3Mg
bm8NCj4gbmVlZCB0byBhZGQgY29tcGxleGl0eSBub3cgZm9yIHNvbWUgZnV0dXJlIHRoYXQgbWF5
IG5ldmVyIGNvbWUuDQo+IA0KPiBJIGFncmVlIHdpdGggTmlrb2xheTogS0lTUy4NCg0KVGhhbmtz
IERhdmUuIFllcywgbGV0J3Mgc3RpY2sgdG8gdGhlIHNwZWMuIEknbSBnb2luZyB0byB0cnkgdG8g
cHVsbCB0aGUgbG9vcHMNCm91dCB0b28gYmVjYXVzZSB3ZSBjYW4gZ2V0IHJpZCBvZiB0aGUgdW5p
b24gYXJyYXkgdGhpbmcgdG9vLg0KDQpUaGFua3MgZm9yIHRoZSBjYXRjaCBOaWtvbGF5Lg0K

