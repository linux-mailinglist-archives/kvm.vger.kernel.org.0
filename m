Return-Path: <kvm+bounces-54754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6169B2748C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 03:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E6311CC57BB
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 01:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF821B042E;
	Fri, 15 Aug 2025 01:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a4TI97TK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7131D29D05;
	Fri, 15 Aug 2025 01:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755219811; cv=fail; b=Dwy1oQkpQ68thD3PQNxKqGQSodSDOoNyfyJX6BkUJrkBWZH6RDu4HbYBsC42Ft+BVlcOO2cSPeQDu7ASDSSd6eFwvCyJ5U3CEUx3zPWprioicTfE+DdJO9SFBJTDrVSZURhthVz0mCzA5Bi0a8hUySz7xZLuer5Ievj6ntyiMYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755219811; c=relaxed/simple;
	bh=Vc8D3HacFo0go5kGKnUdLOesRxDZReq8eo5CcWIJYuI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tMScS7hP54qC7PFSH8NAYiVdGMxz7OJ5vN8fRI5rwUZ7W6/BmNuHEP/23G0qOxb8TxubVoCKk8MjFC8XmMkLOq/Rl5OzoykBRGkRa7l4twFBZONvfAdm+YqWpi1QG5ikGgovlgpHRfi6f1/3giXgVwXcfxC9lc6hTMADhTXvrpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a4TI97TK; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755219809; x=1786755809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vc8D3HacFo0go5kGKnUdLOesRxDZReq8eo5CcWIJYuI=;
  b=a4TI97TKIpnEl51NXRHGVoXJBDVS9rXzfr0jOK8yQdFijSmobe/wvB1g
   8RjVm76uQ3CJVMqGZBZuCwqVH3MO7dawk6L8IktcrgQK/Aelhsbq31t2l
   vKaN4gdajwqkmbHAdLwKmATktUv6ym6ttKNPqDeVHfw9hWsyn/VvVcVOt
   H1OfOIIkdCj5kHPlsbzbMvkwYdNnyPfFDcNnlySQJk3Hkh7yHe/GQm2Yu
   lmF/eigQgUw+2pbkOjdkW9QLBSdDmubNvXETdDSsAPebFBqfZWozVf+cT
   24gTso6juVjafLxZNGlhz2QiBEza6S4o8nCG854PZeNDFMgB7Cvo2U9QY
   w==;
X-CSE-ConnectionGUID: uNAu21lOS0WP2NDZkurSkQ==
X-CSE-MsgGUID: 0raBkRC3Qbikegebgi+yWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="45124446"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="45124446"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 18:03:29 -0700
X-CSE-ConnectionGUID: x0mA8Ah4STKfN0ADkHOyrg==
X-CSE-MsgGUID: OBGVPPWhSneHcR/oKWDZaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="204079717"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 18:03:28 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 18:03:27 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 18:03:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.57)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 18:03:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAFEIcat7fVLCKlr/Dj+43PkhYBcQy4Mxgew5ET3DYIWkk200GoHXBP8W3nLavOD5eTINJqdRRz1RZ/wCvVD0V9vJBFapcWZLxVt72oN9zkEEk5QxcGvxIoZqssypUeV1y8CA4rNS+L0DGzpuXrZ4CBkzCZFkJ6FZhOc1jYuFCvRItss1++jZLjB3atuqmf5hAlxWx6SxKI9S17H8itRaXEjQYXV5xl0soHmMqDtF8zTBspzHAAOdfIpmD1X1Kp+0m4YwOn9jklS9RY2GuRr/u7WSDNVzl6EiiEx7jhfhcvrYM4SFdZz/TPctA/D7nLQAJO3GRlCl4PSJCH9pUI9Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vc8D3HacFo0go5kGKnUdLOesRxDZReq8eo5CcWIJYuI=;
 b=bwLHJmFxi1Cs6Ef6n6SCe/NuVwIFNW4xOwtdcGAnWuZhvRMfFzMA8ueEnIvupZY2kkcTMmdbzJgJ4A9XHAMZiJf5REvFfIrjNNeA3Qk68+RgoiIW7hp1tlaQPtL4YwQbYx5FRVttEhhWjVgjX0JDuiVG2QL7LxVc79P/AHeG4b89a+XhmhiA0iWh2dQRWFsU+B/0f5oPF7vfwYTvtNsvuL4sCoX3QRHBZGRW5IRIjmcvFUGJ0pJFd4lJgK/egDoZfn6sHiGkiAKp7VLe0vpf7fia8PceKT1kngCeolAFZsDlWqleVmSsJ9M9TLfkHVau8UUdhGxF8YxjMrDTs9DLLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB8247.namprd11.prod.outlook.com (2603:10b6:208:449::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 15 Aug
 2025 01:03:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:03:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgIAAOwMAgALtSQCAAA1HgIAADA+AgACzLoCAAOzGAA==
Date: Fri, 15 Aug 2025 01:03:25 +0000
Message-ID: <dd58cf15476bac97b28997526faf9ff078d08b21.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
	 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
	 <aJqgosNUjrCfH_WN@google.com>
	 <f38f55de6f4d454d0288eb7f04c8c621fb7b9508.camel@intel.com>
	 <d21a66fe-d2ce-46cc-b89e-b60b03eae3da@intel.com>
	 <6bd46f35c7e9c027c8a4c713df7dc73e1d923f5b.camel@intel.com>
	 <rxtpzxy2junchgekpjxirkiuu7h4x4xwwrblzn4u5atf6yits3@artdh2hzqa34>
In-Reply-To: <rxtpzxy2junchgekpjxirkiuu7h4x4xwwrblzn4u5atf6yits3@artdh2hzqa34>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB8247:EE_
x-ms-office365-filtering-correlation-id: 1da6d674-89a7-479a-eaa7-08dddb9789ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MTRtYURzSTFPK3A4UFoxNjZpVm9Vazh0aEZweHlsbTlwSDhONEJ2OWQ4b0tk?=
 =?utf-8?B?bTBGa09jd2JvZUs4ZnI2MzBqL1lpRFd5UTh4ZWhQcVIrWklWQU5XUFhiRFZJ?=
 =?utf-8?B?NWNqdkIraG9OeUgrYmhOaldnZXNLNFVoQ3hiUzRaQStxRVhyVEYzTHVhdVZy?=
 =?utf-8?B?aDJYclROcXJHZjhZQXlNbnhVdmlyR29KTW1Wd1Q0MkgzaUlSZUU1a3VtU2I5?=
 =?utf-8?B?RUMyaHhBNHJRaFExRzhKMkhzaGkzZVNuNjdQNUwyckpUd0wzZWV2QzkxaGpt?=
 =?utf-8?B?UXNsOW5YZXU3SDVQOXhmc3FUaDUwM25EMnBPVWppbURKMVI5bWtaWDRhb3lH?=
 =?utf-8?B?ejI2eStUek1FNHlkY2I5VHBpeG5VZDRpSENBT3J5andubmVRQlFGeXRTOGVY?=
 =?utf-8?B?dUUzaElFZXI0Q3pNVktGRDRtcm1lSlc3aW1HNTQvWEZ1a1hjM1NpSVZOa1lq?=
 =?utf-8?B?T0pkcWlhbVZUMWJCOGtoQVQySlUrTTVMUkNOWGNtbmpKK0hCRDBIVnEwMURP?=
 =?utf-8?B?bTNrTVpWTnhJR0xvRVpBQWR0c3pFTGk3OTN1MTRKL1U1L0dmMmxWM0oreXJU?=
 =?utf-8?B?cnY5NDA1K25yaURzR1BGR05kZHFScXAzU21pVEFzWkdlNndGU1VtZGV4UlZ2?=
 =?utf-8?B?Y09TdDRnZmpNZXJjdEYvTWZYc2pTaFl2WTBNeDlXZDZHMnhEZG4vUVVCZjY1?=
 =?utf-8?B?d0FXWUc0Syt1YnlDb0ZRd2ZVcEcraS9jeWxrNllScHBNMTNDRUtGVFQ5UE9s?=
 =?utf-8?B?R3V4UnN4bFdPK25WT01QaDAzQms0Smh6azQ0WldQSDRNYWl0Mkd5dkV5U1pi?=
 =?utf-8?B?a0VkZmdxWVltY2tFdGtHTkRqNEh3c0ttakRNQ3VIK2xBZ0VmM0dYWkJZK3gx?=
 =?utf-8?B?dGltMkVGL0I0a0VPRWpMdE1OL3BpaFVxMWc2aDdpQ3R3T0Y2TGNLV1E2Qi84?=
 =?utf-8?B?bm1uL2JXbFdBbldpUDQ1U1Nucmcybmt0dW9zZkVMbGdia2swc2J3M2x6NXZB?=
 =?utf-8?B?NHhqd0czVExxZXROS1VNc09MZTlPbWFsNXV5K3RDRVErYzNGWm1XN0hUa1B1?=
 =?utf-8?B?M1hzemNLaFVSTXVpakNKdTlsa2g0VWJ6akIrZ3NmQkZPaCs0NTc4Q2o3WU5K?=
 =?utf-8?B?VDcvbDhQb1dNbnVWeVQ4RWZ1NjUwTDFwSmFOQUY0Q0tLcndxRUdlN1BoclYv?=
 =?utf-8?B?OUkyMnNkVjViTmhmVWd6eC9Fb204VzUzTEthMURDTThCWS9nVjM4bVVreG5o?=
 =?utf-8?B?QTV4eWJOcjV1TVdncXl6SnhRcldzUnFESEFkVzVxN1ZSeUpZV0pHVmVlamNZ?=
 =?utf-8?B?amw0T3lSM2s2Z3hTTE8rNlBlWS8xOTM4QTBqaU15Q2lSTElQM0J2OWNNa0Fs?=
 =?utf-8?B?NXFQc1RCWTRrSFJXZ01pSnBITVlNbXhxQ0lEYlZUSzMrcUs5MjdwSjJjMjhN?=
 =?utf-8?B?aFhZZ0JoY0s5MjM3dTk4S3JaMmJrM2NmaFhTZ1YyNnFhSk96VENXb3Z4R1NC?=
 =?utf-8?B?dXpwWDNFcVlaRkpmemZLbFhxZlZqaUsrQXFvSnZwa1RqcHJUYmllK1pmbFBj?=
 =?utf-8?B?bXNyYXptY3pRZ2l0eU5XaEJub29JM3RHaEhrRWhjeDA3VDV1dWNvclUyT2ZS?=
 =?utf-8?B?d0dwam82UDlDNXdIWGhUMjdSNE0yWXZsWVJGWVY2Z21Hdld4MkY1SUZmWTZW?=
 =?utf-8?B?OERqVE4xNTZ4SXU5bkZhTlN2ZG9ndm4vMlE4UForU1p4K0MrZmg3RTFaWStT?=
 =?utf-8?B?SmZUYXE5Zm9WNWJpWEFpS0YvQlBZSGV2cGhaTjBLVFpER1JDMDJKNHFrN2xV?=
 =?utf-8?B?cko2YWorTnJzQkxjNmlBOE4rWEt2anNaaDM3bjVVODdrQW02cG9qeGNUMTNO?=
 =?utf-8?B?bkp1a3ZmRHBKaDVaOHFqR1cwanNWdE80eWp0SUQvNmZFeTF5eW1LQnVlZEJE?=
 =?utf-8?B?dkRaRGRMajQwY3lYcm8va3NzSzVDOXpGZ2x5bTNTMmNaZUQrcE12RktDcEZm?=
 =?utf-8?B?TFVkRlVnZCt3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVNmazZBT1Frb2hTeHVyQTBBb3ZSTlRVY2tuUDJEeXcxYmtpaVNyTy9oeDI0?=
 =?utf-8?B?UjJjMHBXZ2tiZGVna1paekdpOWxHRStqSGtZeTZ5TGpHWFhNV0F6Q0FIOXFn?=
 =?utf-8?B?REpnOFpqajdMcHorWFd6L1ZyZlZqMVhVeVhHdDhKMWdjREdmKzdqbFlRYTBl?=
 =?utf-8?B?Vlhaa3FjVHRaSFdSNTR4c0pHNkZuMEUrK3lEVStDdWdPVWlEOGU1NWR2SGtv?=
 =?utf-8?B?VWRDK04vdzFqL2FaV0dUMnFKdms1VGdZWnhxd0RrUkNBeHZGMmNMWXloaFFx?=
 =?utf-8?B?a0ZBT3hLRmozaGZWSjQvbFh1allrOFgwOWgzMXh1SEh0YmRYY0JuWm9TMU9W?=
 =?utf-8?B?Vmt4ai9RYkF0N2Z0SjhHYWN3U1o4cmpwd2RpenhRVXhxSko1NjdMYmJ5VkVZ?=
 =?utf-8?B?Nm1mbkJVNk1SV0VXMDFOcWFRU1VxU0pJWWNxZ3hCZm4yT1R5dUI0RWZub01L?=
 =?utf-8?B?U1FRN0hMM0JJY0ZhaWprL3Qzczd3VSs5SkRtcjdtNHNSNTM5ZmxZeFFZWUZS?=
 =?utf-8?B?UFh5UDdkVTIxZStsS2VISWpQeUJTOWpYZkhTdStBOWtiRHRqd3pPWERqNlVo?=
 =?utf-8?B?OWh3OTdOdkNsaDVnN0oyVmx4cTM4T3ZWOHpMa2JuRldibjlUY3pSUi9uM0Zl?=
 =?utf-8?B?cDNjZ0VvVy9ocGRyQi8rd3FUWlR5eGdJQktuRm5JMGZXWHhqSDN5VzFzNU83?=
 =?utf-8?B?NTdZdkNGYnpYUVk4NTVqVXhnWC9ERmlocmNhOW15REpTWEErMEc0L2VVcDNL?=
 =?utf-8?B?bVJUMW1BUGs0V1VCamROQ0FpeEN3dmVCNjhSNFhDVFlRVFZjZE16UW0vaGFt?=
 =?utf-8?B?b1h0WjQ0SVhseVRNbTZrZU42b2JZWkxKTlRlM1ZaM0pMbSthQmNDbWJwZzhw?=
 =?utf-8?B?YnNzbWZmaWhMSTViTlRrMStoNzlpRkNRc3h0YWs5Vkd3R0dyTnU0QXRrQ1VQ?=
 =?utf-8?B?dEU1Mm1uK3dPOHIvQTNROFZWQkkwQmpFQU12NlVOVlJ1bHhVWllHb01ZRU1L?=
 =?utf-8?B?Z28zYzRPZFRlS3Z5SVdpdW45ekNjYXpNWjN2Zk96R2hITGZzWlRHTnB1ZCt2?=
 =?utf-8?B?ZnZnckYzOG11M1FmeldMalUzZE8rSnp2bXIrTS9wMmwwZ3puRVBraWd3a2hy?=
 =?utf-8?B?RUtmYytONVQ3VkExdldCTUo3YmllbERncjhHa0tJOVgvVi9sUXlCUTh0elVI?=
 =?utf-8?B?TmlRUFFFTkpFOWlLV09vN25aSmJRR3kyS3EzQTBxcTQ0VnpPUktLeFZxRjRw?=
 =?utf-8?B?aVhubEhBWXZ1eU9HcUk5V3M1OU9yZGVKblF0THQ0eGxjN1BxaGdSVFQxR25J?=
 =?utf-8?B?UFlMTlpNVk1KMExCUGNKK2hUZ1Z0dFBEdmxIczBQb25XWWQzZU5VaWRvODBT?=
 =?utf-8?B?bFNzbnlIVGQ5Kzh1c2JjR1duUEYxVk5YMkIzWWhGT3Y0ZWZUVTlYbEFQb1Uz?=
 =?utf-8?B?ejM1V2NXRkdnY05OandXK3p3dXpqemFBM0ZQbytKcFNZR2xubXR5MHg1cXc2?=
 =?utf-8?B?cW53WlhsdTNsTHVwbFdUQWVyamllSEpPWDY4NFdHOGxzSWNraGpFVDVDamRv?=
 =?utf-8?B?aEFkRitaN0FiYzMzejJITlB6d2NLaGRNbWpoaG5oZnZReGQ5V3dLSVUvL21o?=
 =?utf-8?B?WnZnQmRsZmdXa2ZiTGxRWXh1VTdQZ25oZmQ2MEhLd0EwQkwzMzJ0T0JwTENI?=
 =?utf-8?B?TGltci9UbGtEd3FmbTdwSEQ5ZGd2YklJcGVpNWtiQytPSlVzZVAwNXdwQ3pw?=
 =?utf-8?B?Y0dmUGlyNDFUcjUvbE1zbGN6Uy9PSjlibGdEM1dBZW1kQ1c0cDFMVXUwRlV0?=
 =?utf-8?B?L2lEd2t3Vm5iN2k0cDJQVGc3V1ZuNzlPMDZ4Y3g2ditNaElmY0wzWTU5ZnBm?=
 =?utf-8?B?Ty9oYXFidUlNWmRXZjhRcERJNXVUalJ0bm96OVNrYW96M21Eb21KczRQWVZS?=
 =?utf-8?B?R2k0TnNyNW1YZm1maDNvSEZoWk9Ha0k5N2tRdzdWYWo0Y3QwQkcvUk5DaW8z?=
 =?utf-8?B?RUdzL2M2RTVjWkFZK2ZidlRQQ2Zpb1NvTE5PTllrRExrOUlrS0VqNUpIVDZH?=
 =?utf-8?B?VmpqSTJTU2QrVjNCM3BTamdxL0lzQ0NubEF2d1JUcFVKbEJOZk0vYnNRZUM4?=
 =?utf-8?B?RWpBbnlMcGZpUVF6NDBwMy80U1d0YytyczBJNmkvRkRmMHd6V2k1QmJMdElv?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <318AD547BCC3A7428A72AD79ADC49082@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da6d674-89a7-479a-eaa7-08dddb9789ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 01:03:25.2496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7h7xJiOTWQpxPqbpDxNXog+RZtksRmH2vyYUe//+TwQpRsxnCeAnIRYhQZa+IFSmVnmn1M9deI9F8ijwQ5dd9GD6DYM5q7U1Rl71qgj1WZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8247
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDExOjU1ICswMTAwLCBLaXJ5bCBTaHV0c2VtYXUgd3JvdGU6
DQo+ID4gPiA+IChzaW1pbGFyIHBhdHRlcm4gb24gdGhlIHVubWFwcGluZykNCj4gPiA+ID4gDQo+
ID4gPiA+IFNvIGl0IHdpbGwgb25seSBiZSB2YWxpZCBjb250ZW50aW9uIGlmIHR3byB0aHJlYWRz
IHRyeSB0byBmYXVsdCBpbiB0aGUgPg0KPiA+ID4gPiA+ICpzYW1lKiAyTUINCj4gPiA+ID4gRFBB
TVQgcmVnaW9uICphbmQqIGxvc2UgdGhhdCByYWNlIGFyb3VuZCAxLTMsIGJ1dCBpbnZhbGlkIGNv
bnRlbnRpb24gaWYNCj4gPiA+ID4gPiA+IHRocmVhZHMgdHJ5DQo+ID4gPiA+IHRvIGV4ZWN1dGUg
Mi00IGF0IHRoZSBzYW1lIHRpbWUgZm9yIGFueSBkaWZmZXJlbnQgMk1CIHJlZ2lvbnMuDQo+ID4g
PiA+IA0KPiA+ID4gPiBMZXQgbWUgZ28gdmVyaWZ5Lg0KDQpJdCBsb3N0IHRoZSByYWNlIG9ubHkg
b25jZSBvdmVyIGEgY291cGxlIHJ1bnMuIFNvIGl0IHNlZW1zIG1vc3RseSBpbnZhbGlkDQpjb250
ZW50aW9uLg0KDQo+ID4gDQo+ID4gTm90ZSB0aGF0IGluIGFic2VuY2Ugb2YgdGhlIGdsb2JhbCBs
b2NrIGhlcmUsIGNvbmN1cnJlbnQgUEFNVC5BREQgd291bGQNCj4gPiBhbHNvIHRyaWdnZXIgc29t
ZSBjYWNoZSBib3VuY2luZyBkdXJpbmcgcGFtdF93YWxrKCkgb24gdGFraW5nIHNoYXJlZA0KPiA+
IGxvY2sgb24gMUcgUEFNVCBlbnRyeSBhbmQgZXhjbHVzaXZlIGxvY2sgb24gMk0gZW50cmllcyBp
biB0aGUgc2FtZQ0KPiA+IGNhY2hlICg0IFBBTVRfMk0gZW50cmllcyBwZXIgY2FjaGUgbGluZSku
IFRoaXMgaXMgaGlkZGVuIGJ5IHRoZSBnbG9iYWwNCj4gPiBsb2NrLg0KPiA+IA0KPiA+IFlvdSB3
b3VsZCBub3QgcmVjb3ZlciBmdWxsIGNvbnRlbnRpb24gdGltZSBieSByZW1vdmluZyB0aGUgZ2xv
YmFsIGxvY2suDQoNCkhtbSwgeWVhLiBBbm90aGVyIGNvbnNpZGVyYXRpb24gaXMgdGhhdCBwZXJm
b3JtYW5jZSBzZW5zaXRpdmUgdXNlcnMgd2lsbA0KcHJvYmFibHkgYmUgdXNpbmcgaHVnZSBwYWdl
cywgaW4gd2hpY2ggY2FzZSA0ayBQQU1UIHdpbGwgYmUgbW9zdGx5IHNraXBwZWQuDQoNCkJ1dCBt
YW4sIHRoZSBudW1iZXIgYW5kIGNvbXBsZXhpdHkgb2YgdGhlIGxvY2tzIGlzIGdldHRpbmcgYSBi
aXQgaGlnaCBhY3Jvc3MgdGhlDQp3aG9sZSBzdGFjay4gSSBkb24ndCBoYXZlIGFueSBlYXN5IGlk
ZWFzLg0K

