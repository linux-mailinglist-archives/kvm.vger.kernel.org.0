Return-Path: <kvm+bounces-58904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4EF3BA5349
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 23:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFBCB1C04388
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 21:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C6628C03E;
	Fri, 26 Sep 2025 21:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kVQABfpR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CF4233155;
	Fri, 26 Sep 2025 21:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758922059; cv=fail; b=RDOR399rKnYtdTNp3dAKyN7pPU2htvsjg0bIYcjKkIfzAiS/gdtXZWUa0Wn7WbrRBf7QlNxrBVBc0TB2N0xh2SDuyPH6fp3kM4Lk6nhFsBUeZ/wroaYnV927VeLkqgz1eNPsknI1WE8cG1ML8pakeAiB36FACej9ml2hplsFGwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758922059; c=relaxed/simple;
	bh=ckI3VdD2ApGUo9dX8LzDJw83WVrroCsenzcyKMjKoqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BjrdRyZAWaXlRVcMuX9HB4+cn4Rtbi1LuxeWY9WSi4WFtLyWBPKDdAKcuJpK12NHQ0jb4KvhgngkDQpi3tTtVKNTOnPKdDM7gteSec/ewg1m4axkyzU0Xk1djluzEvSUKdbw+JcXrd6ac2d7D39mu97SpZQjsVZRRpFFgvE/twM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kVQABfpR; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758922057; x=1790458057;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ckI3VdD2ApGUo9dX8LzDJw83WVrroCsenzcyKMjKoqA=;
  b=kVQABfpRJvEQYg4uMkaES9Z57hXXtnUYIAKFgDzaYaX30M3UAE9CawxZ
   RBXMqpXaK+8qPvCsQr0lzKUFvU3fETp90SN1/j2k5b6APcYAqSmbyCay/
   0qM5pYbaMp0y/I2hRTjzQl1T9dF7aUI+bVsasvK6gNjgO8hUjzaeR5VS5
   /+ISxwOABxVY/IHP2el5jgL23OWhAXbcb+T5z4vCg81wRGOmzD45SSNLM
   xCODj39PQXz1M30YvQjqUMgYXu+IMtMArAwn2OCt9UUTPHborOqc8Rsdz
   2l1khQIJYozOnlTmTgUvLEKhXtIEOjdnKG+f+8xMGmwpwzE7RoUQKbki5
   w==;
X-CSE-ConnectionGUID: 6EjnNPKjQ9uNXsb8aDuTWA==
X-CSE-MsgGUID: hEwXKnB4Swez9xnAwPM3pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="78902901"
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="78902901"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 14:27:36 -0700
X-CSE-ConnectionGUID: bblr1gq7Qouv7J4qhkX9lw==
X-CSE-MsgGUID: mVHoQW95RuaA5zXSuD6Smw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="208647832"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 14:27:36 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 14:27:35 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 14:27:35 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.11) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 14:27:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqdjrxzrM4pioDv0rRfxm1TRpZYerMxr1ZCS7MHxKkqE/D4CwbyH1su5GFzpCluCnll0gHqSOx1IhD91JrZ5Lrg0FfjIQvY4/LbtT2vBwDF7/LS4STQ3dMz03uJ5HtClX5cZYLNRDrqa920MsYU+4avwDObIsyjktjbgewavjKH/dwUmvyBvag9i7fW5Zj8BM54zI9eKzTB/Uxk+B1Zya5B/fq+LMkGYrmo5L8p+59l4k4VT2up1yV32f0SWD6MO/1djPMj9V8S68f6Mu0o2bTRGuq6Go2U6KRZhT93xlOZedA/qsBc4xafhWF7kbk2jwf4/AaUGTOaR4xXxbERavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckI3VdD2ApGUo9dX8LzDJw83WVrroCsenzcyKMjKoqA=;
 b=aLw4+gJGXECUk86Z3i3U+58xZhb8E169VWHLxXsEnsLdi0zb5h8dq5IhheEApWZpK87HwhtgLjInRhwp6KgFS55RBxXnDWHmA51qsUFK1OEvb5ROhaUaattrPaOP+itB4Dl5Aj37aGuue7le4ecQuOcdEC45mtEOrAcdBE9Gk3+Do+p1NMSvbde0cDzwp3oLOXBDSbT0y48qs6ecNavx7yjFKrJMhxpEDV1hwjm1mozGTQAyKpBQVOQH/MLLjPAfyYVeeC+QVEMXU6Om59BNhLto8WCUYGlr0UvA8EDbekL7YFfamQq9bOBsg5wUo4xxY2FVqeXPtqu6jWOxnzvfxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4558.namprd11.prod.outlook.com (2603:10b6:806:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Fri, 26 Sep
 2025 21:27:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 21:27:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Topic: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Index: AQHcKPM0E+1js7qjUU+dZA1L0QEu+LSlDMkAgAD58YA=
Date: Fri, 26 Sep 2025 21:27:26 +0000
Message-ID: <b85d028e9f071be7d0f1d8ff510c621fc2019392.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
	 <24d2f165-f854-4996-89cf-28d644c592a3@intel.com>
In-Reply-To: <24d2f165-f854-4996-89cf-28d644c592a3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4558:EE_
x-ms-office365-filtering-correlation-id: 420c18e0-a354-47a8-4e39-08ddfd437d69
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Nm84eDFDSm1vOHZmRFN1dkxZdS9LanFzYlpZQlBnYkdpS0dhVTljN05JeTZJ?=
 =?utf-8?B?SHp4bVkzQXZqbXF4dXFucGNpcHc3VlBJdUtvcEVuSk5mdE5WNVduMVRIRG9Q?=
 =?utf-8?B?U0R2TlVQZUM1blpNZWc2NTRNV3pnd2NieVUxay9xYzQrSGFwU0VSZFlGeWpr?=
 =?utf-8?B?WHNVZElSem56WHZBVnJEYkpySVZaMkF4ZkVuWnVibUowbURIcDhtNVZ6Wk1p?=
 =?utf-8?B?TkI3eEduSi9yK0trZDRsUFplNkRtcnhmc1lJSG1rQ2lyYmluK1FmaVQydmtx?=
 =?utf-8?B?ZmNDNnBzZm00Mk1PbmdKMFk0dTNRZFlkL3JDaFFsZzdEQkVkMWVZaXVZT1cx?=
 =?utf-8?B?SmVUT3VQMUpaRlhieDhTZStEY0dLMTc0MWxyNlB5MW5sd0IvZ1JQUkRpallZ?=
 =?utf-8?B?WTFWQVg2cW5DMFdJQ2ZZbGYrS1Ric3FKVlh2OEJTVkY0TEF4bjBXMWQzL2E0?=
 =?utf-8?B?OVhHQlRjSXlxc21RTW5SM3l4YlJlTkJ1TVVhMDBaanR4S0hCR2hRZk82YjlV?=
 =?utf-8?B?YWx1S0pMTGhSbWYrS1VieXJBVGJ2ckxqL0lVQ3lpMWUxOVdpUDlLMGdwdVFZ?=
 =?utf-8?B?ZjZaRnBXV2o1Sm1vbWhrNi8xa3NUMTlnRGdqZnhTQU1WK3U3akh5OUtYRml3?=
 =?utf-8?B?Z2t6TzlEOFJNdGNnTnA0eFdzcEphdmJVMFM3VHZicW1vY1VyeXlPdXFQRkFQ?=
 =?utf-8?B?dTd4QzZkdC9yTHMyRDlLdm5uc1pDOEJRaGtURFZqTm45RWdKZzZIM240UVRO?=
 =?utf-8?B?aFJFbWVFcFJOYXl1VDV5cnhjU2RkSjF2T3NENzBCb2tTQjA2ZE1RYllXR3R2?=
 =?utf-8?B?SzJtY2hqbGp3cmU4dUhYeFdtcGRpeHdveFQzMFFmY0lEWjdHc25CQXNLZDY5?=
 =?utf-8?B?QThYWlY0dmVTT1lrdVBiOW9LTTVwZ0R1VTFiOXBncUxiMGRTc0xuK2pqakV5?=
 =?utf-8?B?L2FUNzZIYVZUMm90WU9NZXIzeUFoeWFieW1jQzZ5NEh2cXhpTFp2aXFkUnFX?=
 =?utf-8?B?Sk10VUxITGJOWEdrLzFPYkpqQVJhc2JUR3RCakdQUmFSTkFHdGkwV2t1TVZ6?=
 =?utf-8?B?bERabXdSMHUydXgzNGwxeE9JbE9DOE5xK3R2M1YxYjJLRy9nNGJ4YStIQktt?=
 =?utf-8?B?eHJmQjhlWHRib0J1bjd4QjF1Zjc1WlJSdVBMTFBrMjZWbGQyUG81dlpvWTFJ?=
 =?utf-8?B?Nm4yajhzaGo5SlpBWWViRHRncy9rY0I0UlczblFucGdmYTRMc0QwSXNZSzJD?=
 =?utf-8?B?c1N0SzVzb0QyTEt4UDE3U0dsRWtiOGRDWnBPRW93WlJXV2R2Qll1OFBYY2kr?=
 =?utf-8?B?SFhOY2xwR0hMZTN4YXM3bW1RRWNQZWZra2pYVlkrTWtoa0xySW1kcnduVjZi?=
 =?utf-8?B?Um1qbGcvTVgyL3poa3JFc0c1RG5Ja1FZZkNUWjhIbmNRRlZJemMrNU1Ed1JI?=
 =?utf-8?B?MkNrQjA0U2RMOEdsTjZ4SjZ1ZzBqRWxRZ241TVpJSUhaWitPU3NHYlRXOGdx?=
 =?utf-8?B?eXEwZ3NqYmp5eVVyQ3RnSjFud3o3amVCM1VjaXI1aUgyR1B1S2RFbzNlKzFX?=
 =?utf-8?B?YWJYbm5xTm1tQjFCYXlHcjliQXQrTVYrczN0T1Rxc05sQmlRTDc0UGtSM1JT?=
 =?utf-8?B?d0hoaWxPWHhnWlFSVHNOR1lqbXBJcjMyVGhSUTlnUmQrditWMkp0ZUd4ZUJ4?=
 =?utf-8?B?RWpuMUtoR01FR3ZmbXhiZ1lqQ3F4dzFncDh4bDFVa3VwbWFnaVZOM2srSXNP?=
 =?utf-8?B?TkVwR2dvT1ZRN0h5Q2xOaFNsK1BXd0FjTHRMT01pUDRCVGlrdlk3SUpHS282?=
 =?utf-8?B?UVJublR6MmwxdlJEYmU1ckJsdzVvR3g2b0NXRzY4clVIazV4WUFzV1RsK0hU?=
 =?utf-8?B?TDZnd2wwZUFsWFk2czJDeUNQUHhMdm1FQitLVmswd3BPOXZSOERXL0JyZnMx?=
 =?utf-8?B?L3FMTnEyRnVCWUdYajh3SXhFcE13bDAzamROd2xKaEpJTEh5M01TaDZsMUhk?=
 =?utf-8?B?MncrTGZqSERHcXZxYmJRYk9mZVJWaGdrY2xFMmRtZXZkR1dEMlBEeU9CYnBZ?=
 =?utf-8?B?b1NIVVdoU1QvNU9PYjBKOVN6TytyR3pQVjhuQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjJ4c1U3WEZXbHNIUS95ZmxTQUxLcmlyQXBwQ016MVZNdnVhV3BUSmtCYVhF?=
 =?utf-8?B?VmpNRlpvQXJ3ZHZTOGRZVThmOWVmSnM1RUprTkFuRFNMaElYSG9zNklaYlZo?=
 =?utf-8?B?T3pIcFNLeU9rQTdQSjhySFR4T0h6UnlQck1ueG5OZXVTMWZFZUptMUEvdFFD?=
 =?utf-8?B?eEQvc251YVhDdXBBRC84RHRNSzFhNzc0bGZrU0Q4Qm96czRqNmFwTXJ0eGp5?=
 =?utf-8?B?NFFwaXJFVnoxTGRwbEt4Z2daeXFYbEZZVkFCOWlBaHNwTW53TFlka1poK1Rp?=
 =?utf-8?B?cEttK3ZyelJ0NzhCazVoMGlRQkhaOGNIM3V4cXB2U3hUNjF3ZStXVUNBTWVk?=
 =?utf-8?B?SlAzOGxoaDhMc1Z3UUJ0bHJFQS9BNE9LamdBd1p1QVlvTzlHYWR1WVgvYXJW?=
 =?utf-8?B?L20zcWpHelZ4UDh2SjcxV3BlMXJvTWtraGNNMnNJSTRydkRSU0l5MTNOQUlx?=
 =?utf-8?B?bXNoUWpyaHhYcFJWaWVqVUxHMWNyRFdwTFIvTnAwMEx0TVMrMjFyajZKYlJl?=
 =?utf-8?B?dElJTEE3MU5uV0NhSUU2T2t5M1dIa1EySW9CUjVoZTBlTmdVV0VObXJWU29N?=
 =?utf-8?B?UGpDbHdnZUM4WVBkQ1lBYkF4Rjd1TE1xclczdFFNQmF6R2JKUnZram84Ujhu?=
 =?utf-8?B?YzNIVzJqcVZKb1RSMmRlemRFZUNMeENIQUFPVzRZeVM1T2VEMEdkdTB5RTV6?=
 =?utf-8?B?VC84WUh6a053WURVY3V4UTdYemF0YjlROEY3b29YTHRQTFVUZ0EzdEZOLzJh?=
 =?utf-8?B?blJ0VXpLR0h1d0haYXFiY0JDNWNneS9nOGVmeDlpaWFoVDhCMmpXUEppalk3?=
 =?utf-8?B?cGVvNVRoZGtDc2thNyt1Z2s5aWVZUklVUm9UbXl1WWlHbXQ0QnM5bEpmRUh5?=
 =?utf-8?B?MkRyYlVLTEVuS1FsZVBlWXpKbHNpVElqMzdtM1pyd2pYWittYzdBeUtlQnpI?=
 =?utf-8?B?amgwQ0F0eHpkMXhaYXdqOW5yQlFrMWd0TU53ODIyejUxVWphOXJJSlpwSkNP?=
 =?utf-8?B?bDhNeGI2TFNuTXQwN2ZCQWFPcUFMVTNWVVd0aVRTMWhRUU50QWJGU0p0SVBL?=
 =?utf-8?B?aW1kczgvYUZkc2tTMzVnSkdQN0tjR2Z4VTNqckU0MWNQYW1VUTFWWlR0NlMy?=
 =?utf-8?B?VjVZRC9kc1dmMW9iam5CYnBmUnhCa1haRWNTYlIwZGV3azViYnI5NjhlSHJX?=
 =?utf-8?B?U25wQk0rbWYzU3FMdkxmbENxV2syekh4Q0R2Z2ZTK3dDdFhUNnhSeG5yM0py?=
 =?utf-8?B?YXdsdTJRRE5pUjErOFh0d1FXNjdoQTU2bmZmbDlhUEhiRzEvbCtLNUlyZW9K?=
 =?utf-8?B?THZVMUtXQ2l2QVFrcmJOdG1kOElHWFQyWWI1UUZPdWFZYWtRYWx0ZTVPMWll?=
 =?utf-8?B?RXBlempBd3k5REZCenhNcnRiNTNUQmJLdGU2NjA0aHJYTTRZT1c5ZGdGVy84?=
 =?utf-8?B?ZjNVTnpPQnVuVFV2bUQ2VndickhraC9aSEJDaWU2WUpBN3poQ2UyN3hzTE9j?=
 =?utf-8?B?Z01MR0FqMmcwMGtTN1dnK0N4R21qL1RsM1ZTd1FEWEV4V0pJNi9WcUkrTUZp?=
 =?utf-8?B?dVVPUnZtdDE5WDBMZ09saGpsSHJHV2hKRStoQWVNVE91T2RnUGJ6Sk5YaUZP?=
 =?utf-8?B?eGxKcGJ3Q0h0amlHY0phMXVRMWI0RC85K0FiY3lYNXc4RzRxbjRhcEV1SDBp?=
 =?utf-8?B?YTJXUDkrZW9qTDZKTUZLOCttZEdwb1d3ckJjMHRqMzc4QWRCeTZzcEtjV0Ni?=
 =?utf-8?B?K28xN2hjdTRMRklVekljZnc3Z0RsRTgwOFI2L3ZsYk9NeVJ0RGcxMEw2ZSs5?=
 =?utf-8?B?UFpzUFh3dFFLZWwvSUc1MVZ0SjU5Q2hVK0RtVFM1L1Z4Umw4OWhWckRBMytp?=
 =?utf-8?B?T1BKK1VaSzJxd3hpMjBxblFCLzVmREhoWm5QUSsyNUpqbmFXakxPeEZGL28w?=
 =?utf-8?B?amZpUi95U3JRRDFGRU9uRnArcU1ET0lCaXJiUTNZU3JMbGhHOXZVWFJBcS9F?=
 =?utf-8?B?WTVENjI4ZkVid0tvQzBWY3dRWkNHK2treWE5U2lPcVZwRDBOZlBIMGpJaUhO?=
 =?utf-8?B?UUxtL1FVMkxRSDlFdXVlZWd0SFFnTFNNY3l0cENKMnFkVU1TWnA5VU5lUjgv?=
 =?utf-8?B?RXZFbDdHbCtzNkdaRDVkM1ZHWDhWbHJBNnNwSTFtWkw1TkRkd2pENTNjRHNl?=
 =?utf-8?Q?xce6IicRdLnSfEsuFyUmEz8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFC37FA09031F0439B1D8230F91B55F4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420c18e0-a354-47a8-4e39-08ddfd437d69
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 21:27:26.4997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ka/gHwx9A/fURyq9E3zbl0ua7P4LM/sHwYqunRe8fshiSiyuooLImUvcl5mcBI8F8sK1NtdZdry/bb1WxlbqaMcFzgRHHweEUEGMD5trV78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4558
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDE0OjMyICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBP
biA5LzE5LzIwMjUgNzoyMiBBTSwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gwqDCoAlyZXQg
PSBfX3RkY2FsbChUREdfTVJfUkVQT1JULCAmYXJncyk7DQo+ID4gwqDCoAlpZiAocmV0KSB7DQo+
ID4gLQkJaWYgKFREQ0FMTF9SRVRVUk5fQ09ERShyZXQpID09DQo+ID4gVERDQUxMX0lOVkFMSURf
T1BFUkFORCkNCj4gPiArCQlpZiAoSVNfVERYX09QRVJBTkRfSU5WQUxJRChyZXQpKQ0KPiA+IMKg
wqAJCQlyZXR1cm4gLUVOWElPOw0KPiA+IC0JCWVsc2UgaWYgKFREQ0FMTF9SRVRVUk5fQ09ERShy
ZXQpID09DQo+ID4gVERDQUxMX09QRVJBTkRfQlVTWSkNCj4gPiArCQllbHNlIGlmIChJU19URFhf
T1BFUkFORF9CVVNZKHJldCkpDQo+ID4gwqDCoAkJCXJldHVybiAtRUJVU1k7DQo+ID4gwqDCoAkJ
cmV0dXJuIC1FSU87DQo+ID4gwqDCoAl9DQo+IA0KPiBUaGVyZSBhcmUgVERDQUxMX1JFVFVSTl9D
T0RFKCkgdXNhZ2VzIGxlZnQgaW4NCj4gdGR4X21jYWxsX2V4dGVuZF9ydG1yKCkuDQo+IFBsZWFz
ZSBjbGVhbiB0aGVtIHVwIGFzIHdlbGwsIGFuZCB0aGUgZGVmaW5pdGlvbnMgb2YNCj4gVERDQUxM
X1JFVFVSTl9DT0RFIA0KPiBtYWNybyBhbmQgZnJpZW5kcyBjYW4gYmUgcmVtb3ZlZCB0b3RhbGx5
Og0KDQpPaCwgZ29vZCBjYWxsLg0KDQo+IA0KPiANCj4gwqDCoCAvKiBURFggTW9kdWxlIGNhbGwg
ZXJyb3IgY29kZXMgKi8NCj4gwqDCoCAjZGVmaW5lIFREQ0FMTF9SRVRVUk5fQ09ERShhKQkoKGEp
ID4+IDMyKQ0KPiDCoMKgICNkZWZpbmUgVERDQUxMX0lOVkFMSURfT1BFUkFORAkweGMwMDAwMTAw
DQo+IMKgwqAgI2RlZmluZSBURENBTExfT1BFUkFORF9CVVNZCTB4ODAwMDAyMDANCj4gDQo+ID4g
QEAgLTMxNiw3ICszMTYsNyBAQCBzdGF0aWMgdm9pZCByZWR1Y2VfdW5uZWNlc3NhcnlfdmUodm9p
ZCkNCj4gPiDCoCB7DQo+ID4gwqDCoAl1NjQgZXJyID0gdGRnX3ZtX3dyKFREQ1NfVERfQ1RMUywg
VERfQ1RMU19SRURVQ0VfVkUsDQo+ID4gVERfQ1RMU19SRURVQ0VfVkUpOw0KPiA+IMKgIA0KPiA+
IC0JaWYgKGVyciA9PSBURFhfU1VDQ0VTUykNCj4gPiArCWlmIChJU19URFhfU1VDQ0VTUyhlcnIp
KQ0KPiANCj4gSSB3b3VsZCBleHBlY3QgYSBzZXBhcmF0ZSBwYXRjaCB0byBjaGFuZ2UgaXQgZmly
c3QgdG8NCj4gDQo+IAlpZiAoKGVyciAmIFREWF9TVEFUVVNfTUFTSykgPT0gVERYX1NVQ0NFU1Mp
DQo+IA0KPiBiZWNhdXNlIGl0IGNlcnRhaW5seSBjaGFuZ2VzIHRoZSBzZW1hbnRpYyBvZiB0aGUg
Y2hlY2suDQoNCkknbSBub3Qgc3VyZS4gSSBzZWUgeW91ciBwb2ludCwgYnV0IEknbSBub3Qgc3Vy
ZSBpdCdzIHdvcnRoIHRoZSBleHRyYQ0KY2h1cm4uDQoNCj4gDQo+IEFuZCB0aGlzIGFwcGxpZXMg
dG8gc29tZSBvdGhlciBwbGFjZXMgYmVsb3csIGUuZy4sDQo+IA0KPiDCoD4gLQlpZiAoZXJyID09
IFREWF9GTFVTSFZQX05PVF9ET05FKQ0KPiDCoD4gKwlpZiAoSVNfVERYX0ZMVVNIVlBfTk9UX0RP
TkUoZXJyKSkNCj4gDQo+IMKgPiAtCWlmIChlcnIgPT0gVERYX1JORF9OT19FTlRST1BZKSB7DQo+
IMKgPiArCWlmIChJU19URFhfUk5EX05PX0VOVFJPUFkoZXJyKSkgew0KPiANCj4gDQo+ID4gwqDC
oAkJcmV0dXJuOw0KPiA+IMKgIA0KPiA+IMKgwqAJLyoNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYvaW5jbHVkZS9hc20vc2hhcmVkL3RkeF9lcnJuby5oDQo+ID4gYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9zaGFyZWQvdGR4X2Vycm5vLmgNCj4gPiBpbmRleCBmOTg5MjRmZTUxOTguLjQ5YWI3ZWNj
N2Q1NCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaGFyZWQvdGR4X2Vy
cm5vLmgNCj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaGFyZWQvdGR4X2Vycm5vLmgN
Cj4gPiBAQCAtMiw4ICsyLDEwIEBADQo+ID4gwqAgI2lmbmRlZiBfWDg2X1NIQVJFRF9URFhfRVJS
Tk9fSA0KPiA+IMKgICNkZWZpbmUgX1g4Nl9TSEFSRURfVERYX0VSUk5PX0gNCj4gPiDCoCANCj4g
PiArI2luY2x1ZGUgPGFzbS90cmFwbnIuaD4NCj4gPiArDQo+IA0KPiBUaGlzIGJlbG9uZ3MgdG8g
dGhlIHByZXZpb3VzIHBhdGNoLCBJIHRoaW5rLg0KPiANCj4gQW5kIGluIHRoYXQgcGF0Y2gsIHRo
ZSA8YXNtL3RyYXBuci5oPiBjYW4gYmUgcmVtb3ZlZCBmcm9tDQo+IGFyY2gveDg2L2luY2x1ZGUv
YXNtL3RkeC5oPw0KDQpZZXAsIG9uIGJvdGggYWNjb3VudHMuDQoNCj4gDQo+ID4gwqAgLyogVXBw
ZXIgMzIgYml0IG9mIHRoZSBURFggZXJyb3IgY29kZSBlbmNvZGVzIHRoZSBzdGF0dXMgKi8NCj4g
PiAtI2RlZmluZQ0KPiA+IFREWF9TRUFNQ0FMTF9TVEFUVVNfTUFTSwkJMHhGRkZGRkZGRjAwMDAw
MDAwVUxMDQo+ID4gKyNkZWZpbmUNCj4gPiBURFhfU1RBVFVTX01BU0sJCQkJMHhGRkZGRkZGRjAw
MDAwMDAwVUxMDQo+ID4gwqAgDQo+ID4gwqAgLyoNCj4gPiDCoMKgICogVERYIFNFQU1DQUxMIFN0
YXR1cyBDb2Rlcw0KPiA+IEBAIC01Miw0ICs1NCw1NCBAQA0KPiA+IMKgICNkZWZpbmUgVERYX09Q
RVJBTkRfSURfU0VQVAkJCTB4OTINCj4gPiDCoCAjZGVmaW5lIFREWF9PUEVSQU5EX0lEX1REX0VQ
T0NICQkJMHhhOQ0KPiA+IMKgIA0KPiA+ICsjaWZuZGVmIF9fQVNTRU1CTEVSX18NCj4gPiArI2lu
Y2x1ZGUgPGxpbnV4L2JpdHMuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+DQo+ID4g
Kw0KPiA+ICtzdGF0aWMgaW5saW5lIHU2NCBURFhfU1RBVFVTKHU2NCBlcnIpDQo+ID4gK3sNCj4g
PiArCXJldHVybiBlcnIgJiBURFhfU1RBVFVTX01BU0s7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0
YXRpYyBpbmxpbmUgYm9vbCBJU19URFhfTk9OX1JFQ09WRVJBQkxFKHU2NCBlcnIpDQo+ID4gK3sN
Cj4gPiArCXJldHVybiAoZXJyICYgVERYX05PTl9SRUNPVkVSQUJMRSkgPT0gVERYX05PTl9SRUNP
VkVSQUJMRTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSBib29sIElTX1REWF9T
V19FUlJPUih1NjQgZXJyKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gKGVyciAmIFREWF9TV19FUlJP
UikgPT0gVERYX1NXX0VSUk9SOw0KPiA+ICt9DQo+IA0KPiBLYWkgYWxyZWFkeSBjYXRjaGVkIHRo
YXQgaXQgY2FuIGJlIGRlZmluZWQgd2l0aA0KPiBERUZJTkVfVERYX0VSUk5PX0hFTFBFUigpDQo+
IA0KPiBUaGUgYmFja2dyb3VuZCBpcyB0aGF0IHdlIHdhbnRlZCB0byB1c2UgU0VBTUNBTEwgcmV0
dXJuIGNvZGUgdG8gY292ZXINCj4gdGhlICNHUC8jVUQvVk1GQUlMSU5WQUxJRCBjYXNlcyBnZW5l
cmFsbHkgc28gdGhhdCB3ZSBhc2tlZCBURFggDQo+IGFyY2hpdGVjdXRzIHRvIHJlc2VydmUgQ2xh
c3MgSUQgKDBYRkYpIGZvciBzb2Z0d2FyZSB1c2FnZS4NCg0KSW50ZXJlc3RpbmcgaGlzdG9yeS4g
VGhlIGNvbW1lbnQgcmVmZXJlbmNlcyB0aGlzIGluIGFuIHZhZ3VlIHdheSwgYnV0IEkNCmNhbid0
IGZpbmQgaXQgaW4gdGhlIG9mZmljaWFsIGRvY3MgYW55d2hlcmUuIERpZCBJIG1pc3MgaXQ/DQoN
Cj4gDQo+IFNXX0VSUk9SIGlzIGp1c3QgYSBMaW51eCBkZWZpbmVkIHN0YXR1cyBjb2RlIChpbiB0
aGUgdXBwZXIgMzIgYml0cyksDQo+IGFuZCBkZXRhaWxzIGluIHRoZSBsb3dlciAzMiBiaXRzIHRv
IGlkZW50aWZ5IGFtb25nDQo+ICNHUC8jVUQvVk1GQUlMSU5WQUxJRC4NCj4gDQo+IFNvIC4uLg0K
PiANCj4gPiArc3RhdGljIGlubGluZSBib29sIElTX1REWF9TRUFNQ0FMTF9WTUZBSUxJTlZBTElE
KHU2NCBlcnIpDQo+ID4gK3sNCj4gPiArCXJldHVybiAoZXJyICYgVERYX1NFQU1DQUxMX1ZNRkFJ
TElOVkFMSUQpID09DQo+ID4gKwkJVERYX1NFQU1DQUxMX1ZNRkFJTElOVkFMSUQ7DQo+ID4gK30N
Cj4gPiArDQo+ID4gK3N0YXRpYyBpbmxpbmUgYm9vbCBJU19URFhfU0VBTUNBTExfR1AodTY0IGVy
cikNCj4gPiArew0KPiA+ICsJcmV0dXJuIChlcnIgJiBURFhfU0VBTUNBTExfR1ApID09IFREWF9T
RUFNQ0FMTF9HUDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSBib29sIElTX1RE
WF9TRUFNQ0FMTF9VRCh1NjQgZXJyKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gKGVyciAmIFREWF9T
RUFNQ0FMTF9VRCkgPT0gVERYX1NFQU1DQUxMX1VEOw0KPiA+ICt9DQo+IA0KPiAuLi4gVERYX1NF
QU1DQUxMX3tWTUZBSUxJTlZBTElELEdQLFVEfSBhcmUgZnVsbCA2NC1iaXQgcmV0dXJuIGNvZGVz
LA0KPiBub3QgIHNvbWUgbWFza3MuIFRoZSBjaGVjayBvZg0KPiANCj4gCShlcnIgJiBURFhfU0VB
TUNBTExfKikgPT0gVERYX1NFQU1DQUxMXyoNCj4gDQo+IGlzbid0IGNvcnJlY3QgaGVyZSBhbmQg
d2UgbmVlZCB0byBjaGVjaw0KPiANCj4gCWVyciA9PSBURFhfU0VBTUNBTExfKjsNCj4gDQo+IGUu
Zy4sIFRoZSAjVUQgaXMgb2YgbnVtYmVyIDYsIHdoaWNoIGlzIDExMGIuIElmIFNFQU1DQUxMIGNv
dWxkIGNhdXNlIA0KPiBleGNlcHRpb24gb2YgdmVjdG9yIDExMWIsIDExMTBiLCAxMTExYiwgdGhl
eSBjYW4gcGFzcyB0aGUgY2hlY2sgb2YgDQo+IElTX1REWF9TRUFNQ0FMTF9VRCgpDQoNClJpZ2h0
LiBHb29kIGNhdGNoLg0K

