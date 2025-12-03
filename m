Return-Path: <kvm+bounces-65247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A68CA1B04
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 22:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5A5D33003867
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 21:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEED2D8396;
	Wed,  3 Dec 2025 21:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i3YmMUfV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C707B2749D3;
	Wed,  3 Dec 2025 21:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764797952; cv=fail; b=OERR6NqsncT3qVNwdgcEmwfpSKDE+skDL+bfNphivHI33k7AExZwhjZUxcKHA4hO1G7+ULV+jsO+9Vv23Knqy/9SER96QHQbgV9ZLDkZrCWnYlGLKp+DKu/1ZB9NT9K56z3WPDO87BmzUil2ToLqpvvJR2t1Tnc3ijM5di3hfuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764797952; c=relaxed/simple;
	bh=4VGi78LLR5VRvoBUqo1aiU7t/xcpPzfTiHhcOc5hCN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AF1jLJLZ0KrqxSO6/GUZZTNYVtoGm6UnLb70aiE3QLvp8tSPUPlXaT/bEb26UI4AbLy0yGKpSWuezhRwgV20RBau6v1l72eMJfctjUwwcfQWiJbHsJkF92rDGIwZKJ7xywFnuLAEq7kaODJaRmf94qCj2+ehRERiFKRq7ggPOVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i3YmMUfV; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764797950; x=1796333950;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4VGi78LLR5VRvoBUqo1aiU7t/xcpPzfTiHhcOc5hCN4=;
  b=i3YmMUfVq6HVn+5TAxkmGwrBg16njsttv2bIuB99LZHfJi+qz2e5+nS3
   0nQFOAYgDI9sWC1VAn2EGgfOmitqhYZ6Tvhg6Ke4/dzs+6IcluyqTRJfr
   59b3gVTAQhwBoGT8Zt9HCPRS5FYrkbrjDfi5kyj/Fd/6tDuOWwG478g3c
   p8Coi4uTniZJrodiV2zAdghq9whZrm8JxLZ/TbFbVATIRcpB4XQR0c20X
   bwH7hR16L4XzVrQQnFxy3R4CQdwZn9LKt5hZf0XOkrw2U7QQVSYqQRsHL
   gRexpWKck9yXtUrh9Y5xp3CfUhho7EDDlliM/phc3Trzv24ERlMH7zemX
   g==;
X-CSE-ConnectionGUID: I35LDickS3+d5HT1jj0D8A==
X-CSE-MsgGUID: 74JCik2OR+axm2gIyGqdgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66769711"
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="66769711"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 13:39:10 -0800
X-CSE-ConnectionGUID: GARBNSoWQECF9JdMHmhfSg==
X-CSE-MsgGUID: MVRsQR6LQo+cG28bZeENdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="194845360"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 13:39:10 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 13:39:09 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 13:39:09 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.3) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 13:39:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YbV8xXMVaSQT91FKnHwI89W/FEEECfsC+RnxT3kaHdcjYDzZ9W/gxhUYDT5Unh9A/oYIgk0KYfdDY5n1uumt0uObg0oyyGgih/amKvfdaO3ogy2ebEXX3Wi72E8ePasTgXYy3ilQxbXoDOeFiEak56c+hE2DJvaDlpZhsktAaCCZhXxVuLPDcjVilf1E2LDMUwibSXCB6AZMiX2Ac0rOairalzvrIA/zMkdFTZk4WXtWv3AK0AGT3xGsYPKHx9IgjYtq1FKm1R+o3hsIoe4lljpuXJEhbeHJG4UuG0wFfoyITF/HG6+RZ1GxCKhsOtHy27eNX5jBSZe3HOLlwOjUtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4VGi78LLR5VRvoBUqo1aiU7t/xcpPzfTiHhcOc5hCN4=;
 b=dy663q1Cm3ynxuqT9aSL4U5YCAend68fm0YD7KEhSNq2Z8xUgtR2d+FdTUIEBdEFttyC9bnQaDQFTE7N5COkg8PiiiDo8j5fWvtTFDy+680wnqFXNJlvDXp+SJYXEcGftpPcWz57X0FzuYLpFJ57OLiA1CUiPaNo2pTPPCezoCoVkTQ/YdBA5fr6Oylf5Em3/8QPsI5G5ilqPQT2UGQMVUu9D5wiaqu7RbylfliBOVnilKFHosGMxRxhoJG5oZw1Et1me+8u6vG4gK1jAklKgYNSjC/VqgQ52r9CdQ/BnEg2bLeVYnZshcMWTwUDLEChQemUCtKE5uBTs9MR6Uy4Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PPFE94346F35.namprd11.prod.outlook.com (2603:10b6:f:fc00::f59) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 21:39:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 21:39:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "kas@kernel.org" <kas@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UGu/sAgAa1nwCAAJayAIAAz+YAgAEpIICAAADQgIAAH1uAgAArEgCAAAHBgIAAG3CAgAAD3wCAABfeAA==
Date: Wed, 3 Dec 2025 21:39:07 +0000
Message-ID: <e0eb7ab13b715c7509a310bbc043f78898002442.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
	 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
	 <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
	 <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>
	 <7xbqq2uplwkc36q6jyorxe6u3fboka3snwar6parado5ysz25o@qrstyzh3okgh>
	 <89d5876f-625b-43a6-bcad-d8caa4cbda2b@suse.com>
	 <04c51f1d-b79b-4ff8-b141-5888407a318e@intel.com>
	 <bb174006cbe969fc71fe71a3e12003ab9052213c.camel@intel.com>
	 <474f5ace-e237-4c01-b0bc-d3e68ecc937b@intel.com>
	 <8bd4850b0c74fbed531232a4a69603882a5562a1.camel@intel.com>
	 <408079db-c488-492e-b6e7-063dea3cb861@intel.com>
In-Reply-To: <408079db-c488-492e-b6e7-063dea3cb861@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PPFE94346F35:EE_
x-ms-office365-filtering-correlation-id: 41843246-84be-4fbc-5663-08de32b46312
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YnQrUDR4dkI5aUF3ek4rUjBJTGJYTzc1WE4rUkswT3ZFcFRjMCtGd3dCOWhs?=
 =?utf-8?B?SWx2QzYvTmp0OFlnWjlQQmNNOEIxbS9xbTJxMVd6TXhtNXN2L0JCekhBM3Z4?=
 =?utf-8?B?Z1ByemQxMDRKVmtySlJpWHZqMkpBc1NvZ1prcWpXdkRTbTlYdEtvLzhqd2hZ?=
 =?utf-8?B?TkVZL1kyZE5aZy81SlV4MmpuRmFhWDYzb2NYOG5qNkRtbkROZDhPN1orWHp3?=
 =?utf-8?B?NWJGRnVrOG5VUjZlZ09JZ2c2Zm5pWE4vTTF0WEM5MG1EVmZIeU8zNGdoSm5n?=
 =?utf-8?B?VnpCUUYxUGFuV0NTYUcyQ2pjV0JsUkY0ZmFrMHZuYSthUjlFMmc1RnhINXZO?=
 =?utf-8?B?dC93dTAyZ2p1NGZWVjJPQWZVYTJDT0FWSVRTQkpzOENJMGo5OWdzSFZlOTRK?=
 =?utf-8?B?RWFmNU1LL3M3TFZCUXNreHg2WVRTNmkwbEVYckVEazVKWVlXQUFOblNjL2dU?=
 =?utf-8?B?bzdOM0hzdDFDbVU4OFBaMHZISTQ2MWJvY2s0UXhyeDdieC8zZld4L2pZRWFX?=
 =?utf-8?B?ckNvU0w3a1pmWGFmaHVkdUJnR2h1S2RCWGhBR3lkZStlNkZuYlhaMUtuOXhw?=
 =?utf-8?B?Tnp5Q0pSaFBRd0FReTdjVENwT1dZUmIvYnQ4dG5ES2UrMmlqY2JCTTVZNmlr?=
 =?utf-8?B?UUN1V1AxSlMwR3MvMEtxY0cyNmkySmhDUnNQRU1aWUdtV00yZXhSbnNieERJ?=
 =?utf-8?B?ejdoSndldjFLVXVlR2g3a2xhSUU5aHZtMTViTWRZcTBNWDNxY3hieFF0T3lZ?=
 =?utf-8?B?WUZsdHFOemwwUW83SlJicFd5dkZUK1VFcVI1WUdsRGlDT1NvdXZ5dnFjM1lm?=
 =?utf-8?B?YlY0UDVkdjc3V1lpUWQxMlNwU3RHSUF4eDJyWC9CRXpObE80VWd1OWxKQm9r?=
 =?utf-8?B?d1lycW11YTFMSmNQWjgrMGkyVzY3WGl3ODBnb1d4emY4SURMOTRxUzRXOG1C?=
 =?utf-8?B?eVYrSXFvbWg3enN5K1g3MVlOREV3MmxXVlFnL2pVN1pVYjl3d2kxcFdBL3Fu?=
 =?utf-8?B?TElFbVBlSk1OcHB4NmVzZ1N2WDBCZHNLMWVxMjNuN3hkVU9PSWpJZThJeXc2?=
 =?utf-8?B?NFNUL3FGWFRZVFpKWG91Q29YeEd4ZGMyNzFlNXNkeS93UVNiQTVvVi9NOWZB?=
 =?utf-8?B?THR0cGdua3RSdnNIdGVWKys0STJITVRuRWxncytiSmN6K0VTdmxQakF0ZGRV?=
 =?utf-8?B?bmVsT2cyd1NYRlZDMFUra1lyZG5MakxGc1pBVW9YZDJad1ROQWpnbzh5czNi?=
 =?utf-8?B?NGlGNmszSmhYM3V0RjJUZ1hBQU5vd1JmbSsyMVBybFhZVHExVjhCbDdORTJK?=
 =?utf-8?B?bHVFRDUrZGlMTXkvdGx1KzNBdmtjTG91Y3UxajV3azVLVUs0TzRkRVQ5L0gr?=
 =?utf-8?B?QjZEcmordFRpMVNIU0RteU5wa1pUWXZuVS82QjMySU9rUW4xUjcrRmdGbFFM?=
 =?utf-8?B?NFR0aTBWdnY1cmRVVzh5WnU5d0pmNG00eVpHUm1uR21wNXFyTTdQY3crYlNk?=
 =?utf-8?B?dXZDdEUyZVI1YVRrajcrNUxxTnFtdk44d29CeUQ1MVJFVEpVdVo2bW9JUjBY?=
 =?utf-8?B?NWRhdWNVNTBFRkZxMTdKT0xyVmhFY0s5RFJNMld6YTRmdXZ3emw2Y0grblhk?=
 =?utf-8?B?ZXNvZHAybmNyZVluc2xHR0t1dENQNWd0UUs2UG1mbVdlMnhxVXREbGd2Tm9J?=
 =?utf-8?B?cWQzQm84REtKUjVodkR0L1p1NkF1SVB6MmhVdUdvd05aK1Vpd0NINmFoZ2ZS?=
 =?utf-8?B?VnphWnZmY05nSVNZWlhwM2lHY0YrS284ckI2UVIzUUxWcXQvdU54UjdPK1Nj?=
 =?utf-8?B?ajkvcGZOWmlGU1lnWTRkSnpQMHlpMEhIUUIwY2xhRU1aZUlNMi9nMFpZWUdh?=
 =?utf-8?B?NmZ2My9ZeDJJdTVteVpGdExTSTkrK3YrTTdqTzhTMkFMVDlmSlNWZHBBZGxk?=
 =?utf-8?B?WnArRkNBSkMyeEo4R2JGVVBtTFpxTGpER2NGSHdvcHllNG5qYXdxZmFtZjBN?=
 =?utf-8?B?Y3hpT1BCdlV2VXo5T3VoOVpRZUY5MjFoQUhYaVAzd05tSTdIbnYrK3QwRldZ?=
 =?utf-8?Q?fa9G3X?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnJOVUhWQzJqMkZGU2dyK1hWSHJwZXNXYzQ5aEJkV1kzUmFJZWxsS1lrRWNq?=
 =?utf-8?B?dnZUUTlPWjROZFZ4elNvUW5rakkzbDg1dXA4Y1lna0toQ05FOHphM3F0YzA3?=
 =?utf-8?B?QkxJNlNTdG9ZbVZkWHhBdWRNRnRick5LTm80cHQrT1J5VEltekpyZnE3bHhK?=
 =?utf-8?B?aTlpZldENW9PRFQ2aHdBQllXWStqQWVuMjZQMy84UndtWVZESEtLTzU2ZGhH?=
 =?utf-8?B?UEtEWjgzdEIwekMvM3RCMXN4Q1VYYnRXc3MvL0NySW1jMW9qVzk3Vi9VOUZi?=
 =?utf-8?B?RVRHelUvdTdNRWJ2NnVnYWR4cytjb3h2MjdyWCtMUWxhWDIvYjd5Tm9ENENx?=
 =?utf-8?B?QTVDZDlEbDZITzlqOTgwNVIvU1J3RjZpdFpJVmFHekM2bkd5QnVaUUE2VDVJ?=
 =?utf-8?B?cFcyY1RsT2VMZWlmSHM3dk9qanYyRE4xSUlyUjFneEtWSDJVNWVoYjBVVGZj?=
 =?utf-8?B?Z0toRklkMW12cE1tOWRudUdyY0ZXeVZDdFl0WkFtZXRQNHRnOFFEMmRwM1h2?=
 =?utf-8?B?bzhZc2xiSXZSM2dWQmtPaUZtRVhzeE5XMk9zaC9hSEp2dGhpSjlxMmNMZGU5?=
 =?utf-8?B?a0VaKzJkWTdIOGIwNEwzRExqRzFJOHN0QktJN1k4VDdZWXVrZkZ6ak5vMzVm?=
 =?utf-8?B?MXhCUkV5U1ovVVluVmZtY1JkeHRNUzJUUk0yQTVvdXdyZEZiVElMaENmem9C?=
 =?utf-8?B?bEZkS2hXa1JFR21KUHFRYnNaNUJ5WTVGcnFVQXhYcTgybG51Z0cxc1RSemlk?=
 =?utf-8?B?aGhUWDlqVkpTNG01VW9VaWU1SmtkOUhnOFJENkcwS25TYkVQVHcvVXJORjFE?=
 =?utf-8?B?YmVKQkdRSkxHazVDTXhhMys2N2RBNFpVNS9idHZiM08rWjNYYjJlNTVkOWZv?=
 =?utf-8?B?VG93T3NZcndTb3o5cldINU1pTG01V3Z5dWdzMWFkUEhOcWdxWkI4eU9NMW9G?=
 =?utf-8?B?ZitNOVFxb2l0aW9ndVhKOXJLdDYwWlM4VVNIang1dzFjWkJueWJhSjNnRzlh?=
 =?utf-8?B?dFJYQjlTSFFjTzVVM1JCaEJsMlM3OWc0L213aHNXWUJLTXJvOE1vTDIwYTIy?=
 =?utf-8?B?aXlIbFRIZUxXSE9od0RYTmZIWmNHQWhLblh0TnMzRjE4djhiUDI2ZDVnZmtY?=
 =?utf-8?B?Zm1yaWlXbnl4MGtTTDdKY1JrSzE4UXMyNXJjbHNkQlI4UDhVeDFvZzI0c3FT?=
 =?utf-8?B?a1h6Rm5LdURlQVREajNCbi9JaTZKbnFqZVJ4VFpDSU9MZTV1U2ZVdTZzYnY3?=
 =?utf-8?B?OFFpSDNMczM4bzZLd0t5WDJiTGpGb29YQjhWWHhwUUsyVU1wL3J6VG9EREpp?=
 =?utf-8?B?UG1rNDBrKzZvSXk3NkVNV2p0M0hkckJoNm5tNHlXNi9mRGxhQ01aYk9XYlJV?=
 =?utf-8?B?amJIWkJEd3poSW1UaWdNeDJXcUh5WmpIalVDTWlOZHJhU1BBWmtBWGRnbXRX?=
 =?utf-8?B?T1NHV2g4STg5WCttWlAvbitBMFpRMkticTIvbUlXRkI3NDNuYTFRUTZvb2RF?=
 =?utf-8?B?cm81THRiSjE3bU9Dd0xVYjJYS0RHTE02YlhMZmQzNmZNZ3UyaWlON1VxVUNs?=
 =?utf-8?B?b2dvZWtPM1NqWW9qV3FKM0hiME40V1Q3emVtUVh2dHRGUStwdlY5WnpEWkZx?=
 =?utf-8?B?R3M2cnRGNTh3U05aRHUvK2lkY0pzZ3hrQUUrY1cwY2dNa3Jyakp6SDdubDdZ?=
 =?utf-8?B?WTZiSGE2cUVHWWhpb0hIK3dDU2xWQzRSOHRrRURsYTQyZVg1eHYyaFRVZkVk?=
 =?utf-8?B?dzUwVDVEU3VmeS9PQmNLQVpkb0ZrZ0dSNmtqdlRCbHdJa09oTFBQSWF0bHdo?=
 =?utf-8?B?ZXprU043d1FMOTdXcWJMdmkxdGtqRjZrT1Yzcldia1ZrNVZsK1hZMi9qazB5?=
 =?utf-8?B?RnJJbzN1OEdZMEgzYlpuQTFWc016MmtQRUZSUXNXM0VTNkYzWXRvRkpSMFQ0?=
 =?utf-8?B?L0EwTVROeFNoa0lUMVRDSUdDN1B3d1hwSURIL1dPa1gzODY2dXpyaTV2Q0dY?=
 =?utf-8?B?NlRiRDk5RGorRVRubzh3SExSaFFZbllycEJHMzkwVDhoZHBsNlhPNXZaaVdh?=
 =?utf-8?B?TXRhVWUyakZOKzM4bjQxUVpicE51OEVRc1NjM0RhdVlnS20rUEpyUmdQdm8r?=
 =?utf-8?B?dEc2Y0xWdTJXdEpTb0hZUHdxMUpSem9nOGljc1NXRFM2QVBhamZMTG45UjRK?=
 =?utf-8?B?dGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C8DE6BA06A49C40BEE3BF25CAC71896@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41843246-84be-4fbc-5663-08de32b46312
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 21:39:07.0457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RJZG+Xl+a23FNZ9UYFOnjgHxd9VSJ2UHpQKHUy3kGx9jSIBLR4NGC3pu1IFSWe3+l5dw8lneOoE+wMan0bBr+RHzcB7FM3ixrxt+hZ28pjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFE94346F35
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEyLTAzIGF0IDEyOjEzIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
QlRXLCBJICpETyogZXhwZWN0IHRoZSBEUEFNVCBwYWdlcyB0byBiZSBtb3N0bHkgYWxsb2NhdGVk
IGZvcmV2ZXIuIE1heWJlDQo+IEknbSBqdXN0IGEgcGVzc2ltaXN0LCBidXQgeW91IGNhbid0IGdl
dCB0aGVtIGJhY2sgZm9yIGNvbXBhY3Rpb24gb3INCj4gcmVjbGFpbSwgc28gdGhleSdyZSBiYXNp
Y2FsbHkgdW50b3VjaGFibGUuIFN1cmUsIGlmIHlvdSBraWxsIGFsbCB0aGUgVERYDQo+IGd1ZXN0
cyB5b3UgZ2V0IHRoZW0gYmFjaywgYnV0IHRoYXQncyBhIHZlcnkgZGlmZmVyZW50IGtpbmQgb2Yg
a2VybmVsDQo+IG1lbW9yeSBmcm9tIHN0dWZmIHRoYXQncyB0cnVseSByZWNsYWltYWJsZSB1bmRl
ciBwcmVzc3VyZS4NCg0KSWYgd2Ugd2FudCB0byBpbXByb3ZlIGl0IChsYXRlcikgd2UgY291bGQg
dG9wdXAgdmlhIGEgc2luZ2xlIGhpZ2hlciBvcmRlcg0KYWxsb2NhdGlvbi4gU28gbGlrZSBpZiB3
ZSBuZWVkIDE1IHBhZ2VzIHdlIGNvdWxkIHJvdW5kIHVwIHRvIGFuIG9yZGVyLTQsIHRoZW4NCmhh
bmQgdGhlbSBvdXQgaW5kaXZpZHVhbGx5LiBCdXQgSSBzdXNwZWN0IHNvbWVvbmUgd291bGQgd2Fu
dCB0byBzZWUgc29tZSBwcm9vZg0KYmVmb3JlIHRoYXQga2luZCBvZiB0d2Vhay4NCg0KU28gSSB0
YWtlIGl0IHlvdSBhcmUgb2sgdG8gbGVhdmUgdGhlIGdlbmVyYWwgYXBwcm9hY2gsIGJ1dCB3b3J0
aCB0cnlpbmcgdG8NCnJlbW92ZSB0aGUgZHluYW1pYyBzaXppbmcuDQo=

