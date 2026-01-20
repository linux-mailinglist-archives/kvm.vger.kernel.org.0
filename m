Return-Path: <kvm+bounces-68591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E19AD3C2A6
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C5FCE660464
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BAA3A9D98;
	Tue, 20 Jan 2026 08:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="geAvZ+nR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEBE2FB622;
	Tue, 20 Jan 2026 08:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768898569; cv=fail; b=GVBLpS4pD2gIDSdG7lqQXg89sDvBcInl8xB1ZzQ57gZ17AaKq7LYJSZgNMsgAnlQRNnVqs2coiESS7iPOZWFTRouX/3g14pSCubB1U3Rs1NMnJQ04wKwI936EBR9QK+3ObU9iUYM6TC3GfZYPo4eGD7//dKPC4dmgC91tD6dfkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768898569; c=relaxed/simple;
	bh=oa3ZV0rF1fzf+9yby9KEZGl3fZgYS3X03mYyW4vhLIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rTl7uRQeow455AjAv08TE7Mb2P5MmkxPmiOXc8ahA3JNE+BVyvNiqkR3Jb6gbAkE2USR8xrDujHsLHKvy7KpB22w5RwafkTqJBwGu6TpqPB6cJWSdBZy/gLHLjHUa5Fuom1C5Z3vizOFKTpi6O+hrap1lVqOgex/YlRquQSNZzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=geAvZ+nR; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768898568; x=1800434568;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oa3ZV0rF1fzf+9yby9KEZGl3fZgYS3X03mYyW4vhLIk=;
  b=geAvZ+nRiRY31LFoTNp3cJjxyZlAgvhugk0LbyfCzx0K/Crunm1zIoEL
   KpBZyKsno8a2q+vIyIyY7iv3Mcvq7wm6xYbEKlofo2h4X9bXqzaAUdUJE
   lHPCwotdOgOBu1zwVLCL/b1XxQD6jLJTWlBi/PGou6h5mZsVyA53MMzwb
   Us//IA25ENzGILyS+sTEnGJe1J8FRtpodfBzi0fmYlxiXTz+39EgHcngt
   JFf/+DNGfGnglKWiWAD2pdNaO6YMnHb2q6IElHtYyN+yu9E0eCXyRZ8Mp
   oimsXziG4Aw6/rAyGsZyQFfJuh7SKU6NY8GZTk7Y93CYc8ta6C9tGbP0f
   A==;
X-CSE-ConnectionGUID: Vi3PJUMOTF+Pgtpj0AaUYw==
X-CSE-MsgGUID: Qol3+QYmTuWJFlGEAXEr7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="95574748"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="95574748"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 00:42:47 -0800
X-CSE-ConnectionGUID: 6G48n+LaQGOSNEoz1Ruktw==
X-CSE-MsgGUID: OhEk7PDXSuWPrCXo04xbhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210909637"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 00:42:47 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 00:42:46 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 00:42:46 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 00:42:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYHPF4d+fqubgZdXmbK/0cxmv3qs6qnMUau3Z2trmc60W76JpEFzIzhEWL2yLPLPJDGoViibpp7P0273Bvl/QUijG6M4ViEaKMxCXjXAg+ATwCXEC1IasJi+SZ4JCreWm00F1/0zob88dHnUM4EqX3QOYdyZrDMdQ64YUb0qsnWqYAJ8ZCEbOcT4oQYH6ZKjYS6rBf1bQWg28E7mxDIu/SZFk4SfAmhz85CnCjY90jmQMlAF7+BfBTwge25YXzw++AMrtMIcit1XfkRSM9XEjqMdhQoHdD+A+fJ+U6ev/YRYPol2x+BuLwQ458rZGD6JlWGi1KxnL5LpwJ2ZRiqiIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oa3ZV0rF1fzf+9yby9KEZGl3fZgYS3X03mYyW4vhLIk=;
 b=w2vZ+Q/+0SwdUQDJRdaVJUp50dv2LUHCXAyrSAgER5eMHYSniOadBiMtrwB77z1j3ASG4doJ7O4a5xY+jOPrnW9nO5+k6uHALrVpI9MALXLchryPZt6UUFoWgZGMz03YuFCHhisV9qS0z5Vh+h/mIRjC0X/rHVH2VDBYcdZn5rzdW0vbL+awg1fL7QbGi1Mf27YenX82TY3Oqhi9KbwIQJ7YjCY6zro9oqQXAl7tXdtu4kOCmBli/xJRH8bPlG1OX7KUmxk+h+UopfmJ/mZwJhSDVwjkwI+LL9z6isnIBLuMXZ0mGnG9ukOhY154jRjnLv46S48I7uHCn/wwTkWNOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by PH8PR11MB6684.namprd11.prod.outlook.com (2603:10b6:510:1c7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 08:42:38 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 08:42:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Topic: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Index: AQHcWoEJZMe7fqktBUy9KVYPva8b2rVV4oKAgAM/5wCAAfoHgA==
Date: Tue, 20 Jan 2026 08:42:37 +0000
Message-ID: <ecf01cf908570ca0a7b2d2fc712dc96146f48571.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-12-rick.p.edgecombe@intel.com>
	 <aWrdpZCCDDAffZRM@google.com> <aW2XfpmV7FqO2HpA@yzhao56-desk.sh.intel.com>
In-Reply-To: <aW2XfpmV7FqO2HpA@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|PH8PR11MB6684:EE_
x-ms-office365-filtering-correlation-id: 18988ece-890d-4c6a-eccb-08de57ffdd8e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UVpNUm9NdEswSzE1ekRGNHRPL3VGYVRyRFhqVzN2UGRxekNRQlhwY2xaQUhJ?=
 =?utf-8?B?L2RMTjVGZVBpSklLV3RsaERaT1owdjBPbDhpcFArd2tGaXB6U1Q1REFDMmFs?=
 =?utf-8?B?ZmoxaHFKSnlGeFhOUEVHSmduaHNwM1pzUjcwRC9hdFVVY3JGcHcyR3VsV0FY?=
 =?utf-8?B?NVBXTGhJSzEwam5qZG0wOUEyU2xFeU5KUEowVFM4b3ByalAzRWI5K0l2NGZN?=
 =?utf-8?B?VDFKZVpDd290c0ZncDliRGVmeUtPclp3c1YzYlF5UWFYYkNkMC9ZbXYwdjMv?=
 =?utf-8?B?TGV6S2VONXd0QWIySEZUeEsrQ2JPNXp1WVNlWER4aXpUK3ltdStwdE1ocUp2?=
 =?utf-8?B?QnJxV3ljU2M5YURTL3ZFajFvb2dJUmtIL1RMZWJIN1BWcFFiWXJJY1hVR3o5?=
 =?utf-8?B?MHRxNmVhRThjVUg1TExpQVJqZVFIWVJUTFE5T054cFpqbGdvckQvaXQyOW50?=
 =?utf-8?B?Wk52Z1o5MU9WcER0RDNibE93RkpjNnVHVlY4YmZKdXFGWnZiQnNsRGlmL1ky?=
 =?utf-8?B?QUpBbEJETk9yd2dKUVZCWmVobU1SRGtlUG9Bdkk0NXIrNkNaR2JScTBrRTBI?=
 =?utf-8?B?MGhyMGNvV091ZnZRSGh6dUNBdzhHZlM2WGUramR4Q3MyQXhTZTBMRjl2M1hk?=
 =?utf-8?B?MW90REhBKzVuMERtZDJ0S01OMVlGZ0lFSU1hV0ErU21vM1h2b0NmcURxZlNu?=
 =?utf-8?B?Y3FDZnU5Mk9manhhRUZlN3VMZ1BWQmxzTUdSenRqZU95VW5DRFRnbi8rTTlz?=
 =?utf-8?B?Q0R6bHNBRnhQU2hZc3gwN2hpMmxEcnVkb3hhaVJQeEp3WWVMZ1M2a1V4MmI0?=
 =?utf-8?B?WGtpM0RIQTBMQnM5ZDBUbWVFWE5hMzBBdm5YWEZ6S0RxNXRBdEpUYVc5THlo?=
 =?utf-8?B?cDRFMnppME5vNERqWmk1ckY4WFFqQkczdVJEVWpRS3VINnQ5ODVrckJNOURz?=
 =?utf-8?B?MXhDT0IxZ0hRMkROcllLemt6QWRrK0tnYWFDRmE0ZFBiaWhRZGdRU29SN05n?=
 =?utf-8?B?TUVXY09jWkk0KzF4WnV6c3lOM1FDTk55bTJGQ2ZiOTFUeU5pSmw5MEVWd0pM?=
 =?utf-8?B?OEhvMXZFVkRSTjB4Z1Q3YnFaT2NHK3hsT1Vla0NjZ3lYcE0wMlRPZXd1TDA2?=
 =?utf-8?B?ZTVUN3JEUFhQaGo2L1ZSZ1Jta0h6TVBwbGZibHB2KzNIM2JYdENiQjV4TU5q?=
 =?utf-8?B?L3V3eWJuZUk3bWJ2eGUyZGJONkJyN0pVMXh0VnYvWnIzMHM5Zkx3clVHTTdi?=
 =?utf-8?B?WlNHT01XQ1BFdXFBdlRobURaQ01QcmNXQ2NMbmpnNlhQU29KbzMxTWdFenpR?=
 =?utf-8?B?T2MxdkVublorUUFWdDU4TlI2K1oybkRldjRsYjZUWmpuVmROQVIxa1JVSEFp?=
 =?utf-8?B?amx4bnEzSko4RkVuMjFXNlZUSGdxaGlzZTFPOWpEYVdPcm42TFVSQXUrZVFh?=
 =?utf-8?B?YzM0MnFic3lHSG9iTTdHc3d6bFVzMWd2eUd0V2swSEJpallNbVBDTkJXT1RW?=
 =?utf-8?B?YnFvSkZVM00wVHZKOHNMMFhzSEh5RjVSWDdSaWtkbmZiVDB3eVJEblJPVkFS?=
 =?utf-8?B?NHpxNHNkdlFzMEt4bm83dGZ1Y3dQaVJNcDArWjR3aWFhejhubzZCZENXQ282?=
 =?utf-8?B?Ti8za0dwVzNKMEJmZFpjNlRCYmdlUTFTNXBaQzBMRVBTc0pwMUFPNWg3czcz?=
 =?utf-8?B?MTRJSXpRRTRWMDJydlRUWi9EY1hXWnE5QTBjNnlhVWNMaFYvcHk1WDNTU2Jn?=
 =?utf-8?B?NFFLYmZWekh2bGVMTHhCdmhtbUg1WjR0cGdZcE0yVHlvcjcxTlVFUlhJZ3o5?=
 =?utf-8?B?eWZVRENlTUdXVVN3NEVVSC9DeStYeG05TEQvSHlwdFpLOTFYNnRoMll3bVRI?=
 =?utf-8?B?cjczeHJhSkQ2MldVdlB1QjJ0K0R1M3A1NFVrZEUrWHN3R2VvelFPYjJBQUJu?=
 =?utf-8?B?VVM1cE5xUlR6dUdPVjFWaTZXdm1QR2F3U0RoVGRNVERFWC9CL012aUNqWHVw?=
 =?utf-8?B?bVdScktMUU55R2lFSzhqNDhncGVHZENSUERHdlV5bUdzd0NPZC9lV2llSVJo?=
 =?utf-8?B?ZkYvMTdxWmpGSmFkQjFPSVZsMVJ0bVhNT2JLNHFkSmVpQUExVUxqd2pGeDY0?=
 =?utf-8?B?MDJHWEJhRXl5YWhwREl5eWcxL1h0T2c4ZXJWYlRrRDR3d1NOWUZlVEhDajgv?=
 =?utf-8?Q?okHM6W1wMbKokcuOlKmDLDQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0gvdHZpZDhKckg1NFF0dzBMR0dFV0hOaFk4Wm9YN2VYd1hqTGJZbHkyVEs2?=
 =?utf-8?B?UFlHcThkamZjWTRlZVA3WGhBRzliYTFNd0J4aTNtWm5jOVA5ZnZtSWxZMS9o?=
 =?utf-8?B?ZUpkU2l3WHFLaEZPT2F1Unc2UU1vWWNnenRhNWxCY1lpTG1SUDhIVlpKZUlJ?=
 =?utf-8?B?MU5iaXlac2dLVjVMQUFRck9WdHZVRnVqTWNpZFFrNkkzbnNSOFhuQmJFZ1Ru?=
 =?utf-8?B?bUZ1NFN1OUV0dlF1U0k1RHpaT3VJYmlkMkUyNVE0TEFTZGpFSjZ0WW9veEwz?=
 =?utf-8?B?V1JGbUF3R2F3aDlWR0Z4ZVc4WmRsOEFVR0lCZXlSUVB4NkN2a0lhR0tXbi90?=
 =?utf-8?B?OWQxOHY2YXNoZ3NGTG5Eb1VrREF1Q2lxV3dzbWhCWkdNSW9kc1F4R1hUTng5?=
 =?utf-8?B?eE50dDlrcEp0WUJlOERxajFKMjdMczZVaGJLMkN5UFF3SFlzQ0VKeUR3K0Vh?=
 =?utf-8?B?bGdnQXgwNVpnYnZkdHRZUEhRTmNYYTZIdjZDSldRczlZNkpXZ1lBSjF5NkVR?=
 =?utf-8?B?ZzZRcWFWR0Z3SFhFV1dTWWdNV1B6QWw5UDdOVHpjaHBRRzgwVDdYTW9qRHNl?=
 =?utf-8?B?akpNLzkzWnVCTEIxSVpPQzFxalJNbXkrQ0k4SmtVc3d4MnNZbVVBMTV3WWJ3?=
 =?utf-8?B?WnhYNGdOZjFTVVVKN1RtY21RU0xuL1lVTmNFTGRMaHdEdW5hcy9sYkpmN2pH?=
 =?utf-8?B?SC81aEhUK3kxRERiZEFJVXlwRkJjOUlsOXlxNjA1NVZzNzVRQlpDc01qQmVS?=
 =?utf-8?B?cFIybW9sN1JBWS9ZeVp4aXRjSG1ld3BYOXdFd0czdG44MnlCK3dQVW1VY3Vt?=
 =?utf-8?B?VFVhUzdOL2pUN0YyTUlnRTJ2dUNmcXlSbWlGTlo0UDdKYTIya2ZETDk5cXhw?=
 =?utf-8?B?R2RmZGpweko1ajNmNGhMeGkrV0VVSlV6a1ZvczFPNWNhTlRWQ0lnWGZLSTY4?=
 =?utf-8?B?Q3JmTjhxbGx5UEhqUm0rbzAwV0R4bWZlMzh3REJyV2YvbDllSkdGWk44MXpI?=
 =?utf-8?B?Sm1SaUZiRmlCTjFuYXpTVUQxUzFqYjZGT2hkNnRsMjgwYzdQZTRKUTVWOEI3?=
 =?utf-8?B?WXJXNklsM2YxTHlDNWp6NEY1ZXFWS1F3WnNhVURuVDg2NUZkekFBaEcyQmRL?=
 =?utf-8?B?clN4TUF0dFkrTFhvd2NPVDQ0K2NteWhITUJFV3BHQjIvb1drcTNuNXJzbyt6?=
 =?utf-8?B?VzRtcG5CNlhxaTRNS0wzQ05XSStneTdRczJCTlNzdHdpUS9CbXZSdEprd21n?=
 =?utf-8?B?TTJBTHpzaldwN21kVU5VbkdvNWFUbFA2Sll1WGtOcGtQdUhORm5YRFpMZFUv?=
 =?utf-8?B?MTI3bWc1Z0xVdTJPeGw1SmNtQ01xY0pYNE5zOWNiNUluVVMxb1RtLzVKRU00?=
 =?utf-8?B?M0p6TCs0Tkw4aFNRMmV3cW5peE8rVk9jNnprcTI1K3UyV1M2MkpiSlEvZUpD?=
 =?utf-8?B?NFgxYmxVbVVMMGsyTEFURzhmM3lMekhWeXZKbCt4WGJMY0dCWXBNbnBJaTA0?=
 =?utf-8?B?ZE5WV2RPYTd2Yitpa1lCODdBMzA0ck8zN2lkN2thZzRObk5iRW9CY1hHcWc0?=
 =?utf-8?B?WjQ3MVFCcFV2SDYwTEhsbi9lbnE5OVlBek9lZ2gzcVp1WnBvWUZUQ05id0ZU?=
 =?utf-8?B?UE5JT0piaHorazRYaXpFSFFyTEVIeTJORU9OcmxvZGNYUjBjeHJ0ZENQaU1W?=
 =?utf-8?B?Sm1EQ0Q3L3FZUlZ0YmlRMVpaaTNwaStjVHRZWDY4TTFrS3J0cEpDSWJ5dG5z?=
 =?utf-8?B?TE15YkJtZTdwd3lSOFg3dUlxc3g3bVR5Q0hSVGFwYzg2WjVGMGJuRGVFbXVm?=
 =?utf-8?B?YXNHakROVnJrYjFkejhVWndNOHdPRG45VmMxUnhBUVdURGgrZVkzcUpoOHVj?=
 =?utf-8?B?WVB5bTNGa1JJK0pSaDVqbEZhVmQxZktzSW5ONmpkL2cwVTRiN0tFOXpacTRD?=
 =?utf-8?B?ZGwyd20raXJmR1Nwa2thRUVkVk45M2dwQzY5SUxJcTI2OFBjNEhzNjRtRlJr?=
 =?utf-8?B?Sk5pc20zaXNGVmd1aEQzTnR1VzFub2NyZmJjbVhrVjFqVVVVSVM3RjR4VXFk?=
 =?utf-8?B?blJ0TkJObU94SDFQeFZpcVNnNXgxQ3c1WGt2bUNFU2dkSi91blJJaGFaSDRT?=
 =?utf-8?B?bmVMcm1EcXNQYU4yajRnVXZXdEtrUUI5YVhRRnBOcUt0azgzNU95L0RaL3RX?=
 =?utf-8?B?VVJ4ZmcvVWNQYWVxOFBvTlUwZEJ3OG41eEhBWE1KSXpmZGRTRHpPSVNBd2VK?=
 =?utf-8?B?RjBZcklRYy8veXBSS051TXdDSkhMRTJPcEVsY3lpSDlmdE03TGY3UHdQUktk?=
 =?utf-8?B?TVp1NnNxSmRLL1VEVkc4U3NwcHZpc1VtTklkdDhMODJMbW5rNnZSQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0C1503054A8964894CB357F0693B531@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18988ece-890d-4c6a-eccb-08de57ffdd8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2026 08:42:37.8329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8jknuQv9xI/dqNd0i0183+1TsGe+/W6dnosCPEYAr9UPGje9JXlzT2ebVcF2DXKcnQQDZq53mm7yZK8vpTCrvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6684
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTE5IGF0IDEwOjMxICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
RnJpLCBKYW4gMTYsIDIwMjYgYXQgMDQ6NTM6NTdQTSAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNv
biB3cm90ZToNCj4gPiBPbiBUaHUsIE5vdiAyMCwgMjAyNSwgUmljayBFZGdlY29tYmUgd3JvdGU6
DQo+ID4gPiBNb3ZlIG1tdV9leHRlcm5hbF9zcHRfY2FjaGUgYmVoaW5kIHg4NiBvcHMuDQo+ID4g
PiANCj4gPiA+IEluIHRoZSBtaXJyb3IvZXh0ZXJuYWwgTU1VIGNvbmNlcHQsIHRoZSBLVk0gTU1V
IG1hbmFnZXMgYSBub24tYWN0aXZlIEVQVA0KPiA+ID4gdHJlZSBmb3IgcHJpdmF0ZSBtZW1vcnkg
KHRoZSBtaXJyb3IpLiBUaGUgYWN0dWFsIGFjdGl2ZSBFUFQgdHJlZSB0aGUNCj4gPiA+IHByaXZh
dGUgbWVtb3J5IGlzIHByb3RlY3RlZCBpbnNpZGUgdGhlIFREWCBtb2R1bGUuIFdoZW5ldmVyIHRo
ZSBtaXJyb3IgRVBUDQo+ID4gPiBpcyBjaGFuZ2VkLCBpdCBuZWVkcyB0byBjYWxsIG91dCBpbnRv
IG9uZSBvZiBhIHNldCBvZiB4ODYgb3B0cyB0aGF0DQo+ID4gPiBpbXBsZW1lbnQgdmFyaW91cyB1
cGRhdGUgb3BlcmF0aW9uIHdpdGggVERYIHNwZWNpZmljIFNFQU1DQUxMcyBhbmQgb3RoZXINCj4g
PiA+IHRyaWNrcy4gVGhlc2UgaW1wbGVtZW50YXRpb25zIG9wZXJhdGUgb24gdGhlIFREWCBTLUVQ
VCAodGhlIGV4dGVybmFsKS4NCj4gPiA+IA0KPiA+ID4gSW4gcmVhbGl0eSB0aGVzZSBleHRlcm5h
bCBvcGVyYXRpb25zIGFyZSBkZXNpZ25lZCBuYXJyb3dseSB3aXRoIHJlc3BlY3QgdG8NCj4gPiA+
IFREWCBwYXJ0aWN1bGFycy4gT24gdGhlIHN1cmZhY2UsIHdoYXQgVERYIHNwZWNpZmljIHRoaW5n
cyBhcmUgaGFwcGVuaW5nIHRvDQo+ID4gPiBmdWxmaWxsIHRoZXNlIHVwZGF0ZSBvcGVyYXRpb25z
IGFyZSBtb3N0bHkgaGlkZGVuIGZyb20gdGhlIE1NVSwgYnV0IHRoZXJlDQo+ID4gPiBpcyBvbmUg
cGFydGljdWxhciBhcmVhIG9mIGludGVyZXN0IHdoZXJlIHNvbWUgZGV0YWlscyBsZWFrIHRocm91
Z2guDQo+ID4gPiANCj4gPiA+IFRoZSBTLUVQVCBuZWVkcyBwYWdlcyB0byB1c2UgZm9yIHRoZSBT
LUVQVCBwYWdlIHRhYmxlcy4gVGhlc2UgcGFnZSB0YWJsZXMNCj4gPiA+IG5lZWQgdG8gYmUgYWxs
b2NhdGVkIGJlZm9yZSB0YWtpbmcgdGhlIG1tdSBsb2NrLCBsaWtlIGFsbCB0aGUgcmVzdC4gU28g
dGhlDQo+ID4gPiBLVk0gTU1VIHByZS1hbGxvY2F0ZXMgcGFnZXMgZm9yIFREWCB0byB1c2UgZm9y
IHRoZSBTLUVQVCBpbiB0aGUgc2FtZSBwbGFjZQ0KPiA+ID4gd2hlcmUgaXQgcHJlLWFsbG9jYXRl
cyB0aGUgb3RoZXIgcGFnZSB0YWJsZXMuIEl04oCZcyBub3QgdG9vIGJhZCBhbmQgZml0cw0KPiA+
ID4gbmljZWx5IHdpdGggdGhlIG90aGVycy4NCj4gPiA+IA0KPiA+ID4gSG93ZXZlciwgRHluYW1p
YyBQQU1UIHdpbGwgbmVlZCBldmVuIG1vcmUgcGFnZXMgZm9yIHRoZSBzYW1lIG9wZXJhdGlvbnMu
DQo+ID4gPiBGdXJ0aGVyLCB0aGVzZSBwYWdlcyB3aWxsIG5lZWQgdG8gYmUgaGFuZGVkIHRvIHRo
ZSBhcmNoL3g4NiBzaWRlIHdoaWNoIHVzZWQNCj4gPiA+IHRoZW0gZm9yIERQQU1UIHVwZGF0ZXMs
IHdoaWNoIGlzIGhhcmQgZm9yIHRoZSBleGlzdGluZyBLVk0gYmFzZWQgY2FjaGUuDQo+ID4gPiBU
aGUgZGV0YWlscyBsaXZpbmcgaW4gY29yZSBNTVUgY29kZSBzdGFydCB0byBhZGQgdXAuDQo+ID4g
PiANCj4gPiA+IFNvIGluIHByZXBhcmF0aW9uIHRvIG1ha2UgaXQgbW9yZSBjb21wbGljYXRlZCwg
bW92ZSB0aGUgZXh0ZXJuYWwgcGFnZQ0KPiA+ID4gdGFibGUgY2FjaGUgaW50byBURFggY29kZSBi
eSBwdXR0aW5nIGl0IGJlaGluZCBzb21lIHg4NiBvcHMuIEhhdmUgb25lIGZvcg0KPiA+ID4gdG9w
cGluZyB1cCBhbmQgb25lIGZvciBhbGxvY2F0aW9uLiBEb27igJl0IGdvIHNvIGZhciB0byB0cnkg
dG8gaGlkZSB0aGUNCj4gPiA+IGV4aXN0ZW5jZSBvZiBleHRlcm5hbCBwYWdlIHRhYmxlcyBjb21w
bGV0ZWx5IGZyb20gdGhlIGdlbmVyaWMgTU1VLCBhcyB0aGV5DQo+ID4gPiBhcmUgY3VycmVudGx5
IHN0b3JlZCBpbiB0aGVpciBtaXJyb3Igc3RydWN0IGt2bV9tbXVfcGFnZSBhbmQgaXTigJlzIHF1
aXRlDQo+ID4gPiBoYW5keS4NCj4gPiA+IA0KPiA+ID4gVG8gcGx1bWIgdGhlIG1lbW9yeSBjYWNo
ZSBvcGVyYXRpb25zIHRocm91Z2ggdGR4LmMsIGV4cG9ydCBzb21lIG9mDQo+ID4gPiB0aGUgZnVu
Y3Rpb25zIHRlbXBvcmFyaWx5LiBUaGlzIHdpbGwgYmUgcmVtb3ZlZCBpbiBmdXR1cmUgY2hhbmdl
cy4NCj4gPiA+IA0KPiA+ID4gQWNrZWQtYnk6IEtpcnlsIFNodXRzZW1hdSA8a2FzQGtlcm5lbC5v
cmc+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21i
ZUBpbnRlbC5jb20+DQo+ID4gPiAtLS0NCj4gPiANCj4gPiBOQUsuICBJIGtpbmRhIHNvcnRhIGdl
dCB3aHkgeW91IGRpZCB0aGlzPyAgQnV0IHRoZSBwYWdlcyBLVk0gdXNlcyBmb3IgcGFnZSB0YWJs
ZXMNCj4gPiBhcmUgS1ZNJ3MsIG5vdCB0byBiZSBtaXhlZCB3aXRoIFBBTVQgcGFnZXMuDQo+ID4g
DQo+ID4gRXd3LiAgRGVmaW5pdGVseSBhIGhhcmQgIm5vIi4gIEluIHRkcF9tbXVfYWxsb2Nfc3Bf
Zm9yX3NwbGl0KCksIHRoZSBhbGxvY2F0aW9uDQo+ID4gY29tZXMgZnJvbSBLVk06DQo+ID4gDQo+
ID4gCWlmIChtaXJyb3IpIHsNCj4gPiAJCXNwLT5leHRlcm5hbF9zcHQgPSAodm9pZCAqKWdldF96
ZXJvZWRfcGFnZShHRlBfS0VSTkVMX0FDQ09VTlQpOw0KPiA+IAkJaWYgKCFzcC0+ZXh0ZXJuYWxf
c3B0KSB7DQo+ID4gCQkJZnJlZV9wYWdlKCh1bnNpZ25lZCBsb25nKXNwLT5zcHQpOw0KPiA+IAkJ
CWttZW1fY2FjaGVfZnJlZShtbXVfcGFnZV9oZWFkZXJfY2FjaGUsIHNwKTsNCj4gPiAJCQlyZXR1
cm4gTlVMTDsNCj4gPiAJCX0NCj4gPiAJfQ0KPiA+IA0KPiA+IEJ1dCB0aGVuIGluIGt2bV90ZHBf
bW11X21hcCgpLCB2aWEga3ZtX21tdV9hbGxvY19leHRlcm5hbF9zcHQoKSwgdGhlIGFsbG9jYXRp
b24NCj4gPiBjb21lcyBmcm9tIGdldF90ZHhfcHJlYWxsb2NfcGFnZSgpDQo+ID4gDQo+ID4gICBz
dGF0aWMgdm9pZCAqdGR4X2FsbG9jX2V4dGVybmFsX2ZhdWx0X2NhY2hlKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4gPiAgIHsNCj4gPiAJc3RydWN0IHBhZ2UgKnBhZ2UgPSBnZXRfdGR4X3ByZWFs
bG9jX3BhZ2UoJnRvX3RkeCh2Y3B1KS0+cHJlYWxsb2MpOw0KPiA+IA0KPiA+IAlpZiAoV0FSTl9P
Tl9PTkNFKCFwYWdlKSkNCj4gPiAJCXJldHVybiAodm9pZCAqKV9fZ2V0X2ZyZWVfcGFnZShHRlBf
QVRPTUlDIHwgX19HRlBfQUNDT1VOVCk7DQo+ID4gDQo+ID4gCXJldHVybiBwYWdlX2FkZHJlc3Mo
cGFnZSk7DQo+ID4gICB9DQo+ID4gDQo+ID4gQnV0IHRoZW4gcmVnYXJkbGVzIG9mIHdoZXJlIHRo
ZSBwYWdlIGNhbWUgZnJvbSwgS1ZNIGZyZWVzIGl0LiAgU2VyaW91c2x5Lg0KPiA+IA0KPiA+ICAg
c3RhdGljIHZvaWQgdGRwX21tdV9mcmVlX3NwKHN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwKQ0KPiA+
ICAgew0KPiA+IAlmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpc3AtPmV4dGVybmFsX3NwdCk7ICA8
PT09PT0NCj4gPiAJZnJlZV9wYWdlKCh1bnNpZ25lZCBsb25nKXNwLT5zcHQpOw0KPiA+IAlrbWVt
X2NhY2hlX2ZyZWUobW11X3BhZ2VfaGVhZGVyX2NhY2hlLCBzcCk7DQo+ID4gICB9DQo+IElNSE8s
IGl0J3MgYnkgZGVzaWduLiBJIGRvbid0IHNlZSBhIHByb2JsZW0gd2l0aCBLVk0gZnJlZWluZyB0
aGUgc3AtPmV4dGVybmFsX3NwdCwNCj4gcmVnYXJkbGVzcyBvZiB3aGV0aGVyIGl0J3MgZnJvbToN
Cj4gKDEpIEtWTSdzIG1tdSBjYWNoZSwNCj4gKDIpIHRkcF9tbXVfYWxsb2Nfc3BfZm9yX3NwbGl0
KCksIG9yDQo+ICgzKSB0ZHhfYWxsb2NfZXh0ZXJuYWxfZmF1bHRfY2FjaGUoKS4NCj4gUGxlYXNl
IGNvcnJlY3QgbWUgaWYgSSBtaXNzZWQgYW55dGhpbmcuDQo+IA0KPiBOb25lIG9mICgxKS0oMykg
a2VlcHMgdGhlIHBhZ2VzIGluIGxpc3QgYWZ0ZXIgS1ZNIG9idGFpbnMgdGhlIHBhZ2VzIGFuZCBt
YXBzDQo+IHRoZW0gaW50byBTUFRFcy4NCj4gDQo+IFNvLCB3aXRoIFNQVEVzIGFzIHRoZSBwYWdl
cycgc29sZSBjb25zdW1lciwgaXQncyBwZXJmZWN0bHkgZmluZSBmb3IgS1ZNIHRvIGZyZWUNCj4g
dGhlIHBhZ2VzIHdoZW4gZnJlZWluZyBTUFRFcy4gTm8/DQo+IA0KPiBBbHNvLCBpbiB0aGUgY3Vy
cmVudCB1cHN0cmVhbSBjb2RlLCBhZnRlciB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNfcm9vdCgp
IGlzDQo+IGludm9rZWQgZm9yIGRpcnR5IHRyYWNraW5nLCBzb21lIHNwLT5zcHQgYXJlIGFsbG9j
YXRlZCBmcm9tDQo+IHRkcF9tbXVfYWxsb2Nfc3BfZm9yX3NwbGl0KCksIHdoaWxlIG90aGVycyBh
cmUgZnJvbSBrdm1fbW11X21lbW9yeV9jYWNoZV9hbGxvYygpLg0KPiBIb3dldmVyLCB0ZHBfbW11
X2ZyZWVfc3AoKSBjYW4gc3RpbGwgZnJlZSB0aGVtIHdpdGhvdXQgYW55IHByb2JsZW0uDQo+IA0K
PiANCg0KV2VsbCBJIHRoaW5rIGl0J3MgZm9yIGNvbnNpc3RlbmN5LCBhbmQgSU1ITyB5b3UgY2Fu
IGV2ZW4gYXJndWUgdGhpcyBpcyBhDQpidWcgaW4gdGhlIGN1cnJlbnQgY29kZSwgYmVjYXVzZSBJ
SVVDIHRoZXJlJ3MgaW5kZWVkIG9uZSBpc3N1ZSBpbiB0aGUNCmN1cnJlbnQgY29kZS4NCg0KV2hl
biBzcC0+c3B0IGlzIGFsbG9jYXRlZCB2aWEgcGVyLXZDUFUgbW11X3NoYWRvd19wYWdlX2NhY2hl
LCBpdCBpcw0KYWN0dWFsbHkgaW5pdGlhbGl6ZWQgdG8gU0hBRE9XX05PTlBSRVNFTlRfVkFMVUU6
DQoNCiAgICAgICAgdmNwdS0+YXJjaC5tbXVfc2hhZG93X3BhZ2VfY2FjaGUuaW5pdF92YWx1ZSA9
ICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICBTSEFET1dfTk9OUFJFU0VOVF9W
QUxVRTsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCg0KU28gdGhlIHdheSBzcC0+
c3B0IGlzIGFsbG9jYXRlZCBpbiB0ZHBfbW11X2FsbG9jX3NwX2Zvcl9zcGxpdCgpIGlzDQphY3R1
YWxseSBicm9rZW4gSU1ITyBiZWNhdXNlIGVudHJpZXMgaW4gc3AtPnNwdCBpcyBuZXZlciBpbml0
aWFsaXplZC4NCg0KRm9ydHVuYXRlbHkgdGRwX21tdV9hbGxvY19zcF9mb3Jfc3BsaXQoKSBpc24n
dCByZWFjaGFibGUgZm9yIFREWCBndWVzdHMsDQpzbyB3ZSBhcmUgbHVja3kgc28gZmFyLg0KDQpB
IHBlci1WTSBjYWNoZSByZXF1aXJlcyBtb3JlIGNvZGUgdG8gaGFuZGxlLCBidXQgdG8gbWUgSSBz
dGlsbCB0aGluayB3ZQ0Kc2hvdWxkIGp1c3QgdXNlIHRoZSBzYW1lIHdheSB0byBhbGxvY2F0ZSBz
dGFmZiB3aGVuIHBvc3NpYmxlLCBhbmQgdGhhdA0KaW5jbHVkZXMgc3B0LT5leHRlcm5hbF9zcHQu
DQo=

