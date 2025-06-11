Return-Path: <kvm+bounces-49142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C475EAD61A6
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5FAC3AC301
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD0D24DCE7;
	Wed, 11 Jun 2025 21:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V5RmWnVh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEE024BD0C;
	Wed, 11 Jun 2025 21:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677952; cv=fail; b=FJNwueA5FvG5jny1bxFJqlHCmPfHAc0/pmIlfq8o2mIgB/0CTB6FiLIhKY3YJvrl+4ssQRnM+fsFYHDvo9OmJvDHTaiBD5IyPTy2kHpMvq0d/bKHXTrdsHVdPcm/E6iYf58E1NgpQCsUG6XXMw7DXzsjqJuuYI6ZQUxtdVa+EUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677952; c=relaxed/simple;
	bh=JCdLOf9c2jdrqvNT+a5/WzzcKxbO8RF5t+a3lcJiRcg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EIBeRu825lInjigNT9yZ+7b4rSgyRVbs4KS1hWfCVrXlVm9bwrRNFo27GLNECEntSyuPIGbPDYe/mWqqMdPyxe46Z1efCp3HPEjH6PljK+HUUniMVeRPcsconxSQHQk6pNkNnaudAkNfZjS8Eb/TusGTZcku7DnjYYCS+YMOGCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V5RmWnVh; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749677951; x=1781213951;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JCdLOf9c2jdrqvNT+a5/WzzcKxbO8RF5t+a3lcJiRcg=;
  b=V5RmWnVhVEAEOxwj+Vz45/IVcPzfqZfbVnpRaHEG1HAJRTZsGXtv/LlW
   K1v7ZSVkVQ6zF6KLXO19IRnPwUAUjf6Fvz0ERYCdn31um+ofLoXWRGgPY
   2OGhzL7Ak4/7Mey6fsZyOcA4skz/ZaxRsX2GCOYaJPUlkMErMpL5GaKYe
   xYW5PXLXwaEvpewOa5MhgNp3Mq+eXNkKfNJOWayUXDsGbHCuCY41f8qI4
   mTZr76KC/3Oh8aoQYFsIBeqEaxhAYcQoCu/bd+8Nck1PlByrlBkN5W9bc
   X4ZMVxYmDJ/iH7DTYXjgHrUi1lPuJ5EhektybiQ/9RHouPz11OVaGR4tN
   w==;
X-CSE-ConnectionGUID: oC30ZyPGTCWwUL35KWZpSw==
X-CSE-MsgGUID: UxfyAKUqSPKXpTh+eiXBug==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="63244369"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="63244369"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 14:39:10 -0700
X-CSE-ConnectionGUID: HSamITpwS56DKQI2tCrNGw==
X-CSE-MsgGUID: EjlzY4CaSd+U+SaoOgDQZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="152466550"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 14:39:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 14:39:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 14:39:07 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.77)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 14:39:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nhv2fEOIgoeGcRopsHsjhdpPOOUeowm4dpDjpI/i2aoMgcS3FN4bndIuZFZhMeSrJ+C6+EVCrm9sX0wQ3HmG3VGUyKp1sX1cE8SCV8DqxMDWNtc4LviJnH31GBP6olhs1wP3YoBaf50R5LoDLOYD/ni42hCTi+LN7hje9k0y16MvBwGBgVbDKSziiWw8dYku7d0vPX8GS7dMqBokW/ZUSJP9TK4Q6bz/SD9mUpliCm1RfVUgM2fNhEpgjrkqkeZ2tZF2fqTevdNMtdJKQPd/D3wnKEUFMehE/fWT9MdSqHj3NYnXgr/NrKFcAXbMK/w3BO0LzEhS2M/scW4A2Bw1ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCdLOf9c2jdrqvNT+a5/WzzcKxbO8RF5t+a3lcJiRcg=;
 b=QukFfdqOeQK6v4Crk1PQK1rBfN8S3kbV71cEqL8jIy5bxZRSetgPZwCn/I6Ax97kwkzNwAp3yX3Loz9ICMKiRrex0Q8K5JcmbXWN0+mJLiEqRPKHpK3S/YFqsHgkN5KM429LsBkzRUDdLKmRijfBpx3gad8ZEdmhgLXNB96fOfN+pPXHUeFZEtZw3hdBzBQLz6P1pvP9POKCYIYZd11CEkGBWvBiTKLzTg2BPFpNlxBp5w0/qyFNK0+Ut4UgsGy0MynDOvq3DYuq6J6AXzjZOT1rhTyU3TkWz43A34MFCh9XZsg6FUq60SLldnIGQw2k3o1yA1l5N4hIkuyeb/okHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SJ5PPF183C9380E.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::815) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 11 Jun
 2025 21:39:04 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 21:39:04 +0000
Message-ID: <7abb2bf8-be36-41b1-bb6e-e23a984a4ab6@intel.com>
Date: Wed, 11 Jun 2025 14:39:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 9/9] x86/nmi: Print source information with the unknown
 NMI console message
Content-Language: en-US
To: "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin@zytor.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	"Zhang Rui" <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
	"Andrew Cooper" <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-10-sohil.mehta@intel.com>
 <31507dc8-b1dc-4df3-bc0c-6958b4218746@zytor.com>
 <fa948d41-3f95-4385-86c1-5c115561b939@intel.com>
 <8035D788-0F60-48B8-8B98-DC352EC9AE62@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <8035D788-0F60-48B8-8B98-DC352EC9AE62@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SJ5PPF183C9380E:EE_
X-MS-Office365-Filtering-Correlation-Id: d07eb428-7ac0-45ee-9237-08dda93062fc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T2NQRGJER2JIYUQzOXRBRlhKRHlFYnJMaHBqc2RGOFI3NUF0Z25IWmlUY09G?=
 =?utf-8?B?b2RaaVIvUnlTYUVrbkVqV3VrZDFSR2ZiMlFYeWJlQjBsVWVoSk80bFViUXpS?=
 =?utf-8?B?RTVpNFhxdVpIUkdreGl2cW9wN3AwMVgvY0VoU1g2ZjFUelFFYUxqSHlUdVoy?=
 =?utf-8?B?QjRtUFFPcHE5bDZQWFROMkF4WElyS1hDUFNLeTFiVGYySFE4Y2lMalRkcVNB?=
 =?utf-8?B?UCs0YzNGQnFhVGVTLys1V3l6TWZqQlV5WFkwelpIV2F5dDBBSFdHLytTOUZ2?=
 =?utf-8?B?MUY5ekEwWVh4eFNlczF5ZXFHNTI2UFBmcS9JWDFGNDIrRmpmUGxVdXo0ci82?=
 =?utf-8?B?MGI4bXU1UW1JSEpFTGdYM0JzcUVOaDNaWThIOVlhSWJPZERBU2lrN09GZksv?=
 =?utf-8?B?ZGhodXZUV3VPT3lQOURrbThQcEVTOUQzdG1BT3RWb1d3eS9vQzNwN1g4Zm9n?=
 =?utf-8?B?c3ZDbGpha2ZvclBsUmZJbTJBS3R5QmlCQkFDcW40b05MK1I0clJ2MXVSUjd5?=
 =?utf-8?B?R3B6bk83RXpsalJ6ZDBzZWttR0tLVE84NGlQaUJLWlNWYUs5MEtOVkdLczkz?=
 =?utf-8?B?c2tFb0xxUzRBS3BERWVEQVgwYWlSSks4Zkw2ZDRzcmhCdjFEcFZhRlJxZ2NF?=
 =?utf-8?B?ZEs2L1RIaVdpeUlOZ3dQZnh4Vm9vUUV2RUpNMG53UXZabUJSYlhETmpZTWh5?=
 =?utf-8?B?UEVEdldPak1QZjE3TlkySGpycjc1eE5zdFdxa2hBM3NRQ3pOTEx2clBpS3NE?=
 =?utf-8?B?TU5WR2hibW50akh6T0JtZkpwbmJ4UllHc2txTFZaendmYWpEenlkQVV3M1dC?=
 =?utf-8?B?VHBjMGdzMGlPTWtyVlJObUI0MlZjTGxDL1h1aEhuV1Nmbjh3UVlmcDMvblEz?=
 =?utf-8?B?Q0JSSFJqQkJseGxMM3dTM1BVZmlocUZpa2tNamlvYk5aU3Vjak9LdjBmQzlC?=
 =?utf-8?B?NURWL29mbkFuS25EcEcwa2x0aUtvamVZRUtEOXdjRk1hNDNoZHpjTEF0WGFB?=
 =?utf-8?B?OUEvYTJ5ZmQ0aDZUTGk0aHJDYlU5cFcyMFN6clVyREpsb3RVQUFnRE1sRXVu?=
 =?utf-8?B?MmgzMWhuT3FyMys0ZzB5MW5VV2RoaGhuSWVNR3BWTS9SdzFhSFg0MmQ5Ynho?=
 =?utf-8?B?dzlvOE1HREU3SkNUOVBRV1lnTFcrcHMwcnhSQTQ4NnNZUlUveTRKVlVwTWhx?=
 =?utf-8?B?T2JhbFUxbkw0QkJuYUtrdnJoZXNvVWxxSzd0UC9Yc2JVUVNNTlUyMEtuN1lZ?=
 =?utf-8?B?Vldwdjgzc001ZUh2dUZXc2tXdWtoSE1QTG8wZnJiSmxseXk3ZG9pMHhmczR5?=
 =?utf-8?B?VVVKUWNLanBhbzFZTUlKT1F5cUxUeDVHNEQxRWFWRU9nSHZtNysrWmV2N0FM?=
 =?utf-8?B?Q2ZINU9tY1VJSTR3OU8zZzNmQWdacE5xWGRGSk5TWW8wb0NvZGVJTWJJdjVT?=
 =?utf-8?B?bVZrTEExaHNYVk05bENTVzJrd0ZvWXROQXJVR1JkSkF6UnJQbUdTN2NNeEwz?=
 =?utf-8?B?RXA2Z0Jmd2dSblVWY3Bid3Q1Q0w0UzRla2hoc2VweE5vYVJ6MXNuNmY0K2RC?=
 =?utf-8?B?clFnZzdHZWVpeXFLVXVGZDUraDNDYWNjamlScVgyQ2kvQ3QwVU5TZnRGNFFJ?=
 =?utf-8?B?WDIxN0JRT2lrbTJrOWRCL3dodEk4WU53V2R0c29CczVaRDE3L284dVpGZk8y?=
 =?utf-8?B?VHVCdjdMdzBRdGZDV2tSZWcvYUpnVi9xNUJmUlBYQmhzRmJ5eTc1cTB4aUlE?=
 =?utf-8?B?Z2JOTGhEcXU1dHZSOUlxbTVXTlV2NWxmUnZmQjgySnlJbXJzaXltSTgrVzRy?=
 =?utf-8?B?UThYaUsrRmsyUlkrcFdGUlV5aFBJNzdjSnNDNFFzOGtJaUtCaUdZRkl5aElm?=
 =?utf-8?B?RkRraW9QN1hzdnRHbERWUmRuR1JtYmxZdkJBOG5lNXViRGtxT1Yxb1JRclJE?=
 =?utf-8?Q?g8vRiQgtMrY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDA3bE0vdzRqMDV2aDBnQVFNdmxNanlBRDBuVVJNL0pHSVVIcC9kSTdxYmJx?=
 =?utf-8?B?emVKK2FzVXExRlJ2RWNIcmdYVkYydnQ2bEdhbTU2NkRqZTRnUVpLQkRCbVh0?=
 =?utf-8?B?UGJsbktFa0dDd1p1VWlJWFZsYTI3V0NXSHFtT0JjalFUWFlTVXQvQWUzMEZK?=
 =?utf-8?B?cE02TUNhd0lDQzAzY2IrU3V1Yk9sdVNLYUNGcTJJQXpPZ2JHbGVNZHlGV3FJ?=
 =?utf-8?B?cVFRMSs2bysvV3Jlam5DZFNnU0FvV3hDbW9WN2ZHTGVYSUxPd1dyMVJ2cWFs?=
 =?utf-8?B?ODBCMkVaNFhISEt1dWZnbC9mcWVtM3lZMGJxOTgvNll1NW8yazBqeWFMZUdk?=
 =?utf-8?B?eVJxWFlQbDJrVEVaS0dmSGhvblp2K0t4TXdBcFlqbjJCSy9TYnNiTklwVHdt?=
 =?utf-8?B?TVhNNzJHNVU5RE82TFNVOFV1MHZNc0ZBUkhNV3U5UDhxcEo0Nmlrc3lkckZR?=
 =?utf-8?B?cWFITVFraDZRdmRoNEFIUkUzbzQ4ODM0TFhiRTU1QnNsdVpDcW92MDJxTVRj?=
 =?utf-8?B?amgzYmVlUFpXdm1jWHEvTDdaaDdGL3c0a1dmNXdNSGRWMncxdjhUcDZoeW1Q?=
 =?utf-8?B?bHBLcE9oYnlMM0VCeEd5WExOM0NBR0pXc0JONS8wanJEQUN0empYbDhNNHdZ?=
 =?utf-8?B?bWVUYjlGNGZ4RkpmcVVHbm9TaDZaeWJVTDRPWmN3aXNmTzVqQVhtUzhwWktI?=
 =?utf-8?B?WE1kL0xFcW5oM3Z1QktGL2pxejJpTkdhVUhqSnpLMGdRWDdvc3BXakFzbkRa?=
 =?utf-8?B?bWNVVktTN3RUTllNZDZTKy9XNWJrVUdtRGgvSEdTWHZUc0FPTTRRdUlhU2ty?=
 =?utf-8?B?Y1hoMloyWjlEenhTMDBHZmI3QWkxMXRuUGg0Z0tra0puZGIwNjdzaHYxWVhF?=
 =?utf-8?B?Z1NBc1ZPck1WckZTNTFOdHRrbEpzZUpaWnZjMUdzdFljODRnakpLM0h0eFJC?=
 =?utf-8?B?bWFSU1Jrd01XdzhnT0EyMk8zdEYybUovT0ROaU9hWEtqZnlXMVE5cldIcC81?=
 =?utf-8?B?YllVQllmYyt3Vk1tbXgzczJ6TGtNQ0xwNWRiYjdLbGpJNFppS01rTE1UZXJ1?=
 =?utf-8?B?eDJwZ1M0WG5GMTNiajJReGZ5dHhuNGhIRWwvNm40ckN1WjFsWXBreU9zOSs0?=
 =?utf-8?B?QjVuNEEzV0ZMdG5NZEIxQlhhK3B6KzNoTUZ6djRNYWxEemRuM1BVTUNzaTBm?=
 =?utf-8?B?bzhjRFZydVo4cEt4U1drOFBXb1NoNWNQWlRmOFhUck9OSUlGemxuM3ZoMUhj?=
 =?utf-8?B?WGkycXNraXJVdEFkVXBXYlJXNUJ3WVZDM2RoUXg3M2k5a1l3MWVsa3FrSC9I?=
 =?utf-8?B?elZyNDRvRS9ONjBmRzR3dDcxWGhNY0ZrbnF4RGJmWjBtdzViRFR3SUV6RkQ5?=
 =?utf-8?B?U1JRVGhyR0E1b1k5OENScDkvV1o0dElZWitXQnNITlAvZWJNYWN6YmhRT2lq?=
 =?utf-8?B?YTZSUlhWOFpqeHNWWlVmKzJoN0lYdXlNKzY4LzcvTGJCMENuRVZ6aXFvcEZC?=
 =?utf-8?B?VDIzSWJWRFZOM1RqNjc0S09QMGlyZHpqUW9QaVZGTGJMbXROcDF5dkNYSkIy?=
 =?utf-8?B?cFNOYkZKZDV5TUZUQlk5d1drY1pPRU96emVNbDQyaHhGWnBPdHBCa0NucFBk?=
 =?utf-8?B?Y2JXQXhHWXF0aU52RHRNMVZuYm5wMU1FRHNrZ1lDUlU3TUl2YjkzVi9jZldv?=
 =?utf-8?B?dERvWUZzeU1nZmlJVC80NzJoaVZRak01bUNjb3JCbWNyR0xncE4yUDRJNlJM?=
 =?utf-8?B?ZlM0UGk2WUpzSFlqcUVhczlYeFZrY2hBeGhhdjlWRmQ2WlhZZ3lKSlpsYlNC?=
 =?utf-8?B?eksvdFRhNTNKRzc3MzNJdWdXdTdnTFRldjcrSGZqMjQwQmZ0NkRsTnA2TllT?=
 =?utf-8?B?MU1Ib2dOczVjSmNlRU1WUS81akU1eVViYW5BSW1WUkFiWVl3Yy9BT3dMd3FV?=
 =?utf-8?B?VlBDR3cxZE1XSU5vUitFbHZ3QTdxVzNXTjJhSUoxT2NsYklFdFMwbnQwUjhH?=
 =?utf-8?B?dkZBQ3BEelowcGx4VCtBT2t4MjZXNmZhbEdKMXNEVktKWCtwKzVuRXkvZGVw?=
 =?utf-8?B?UTM2V0JBcDFoMU0xKzdNWXZzUldsUWREdzEybXNDVCtKVmNkR2RYNTc3UU02?=
 =?utf-8?Q?i2WeAWDhFwYe9yHt9+0j0UnfX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d07eb428-7ac0-45ee-9237-08dda93062fc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 21:39:04.2146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BceAS6U6F9dwyGCIXD6WA/rqbQ+UuFlytG5+LP2YWbxCn2oEZKh0Y9XudnX1PKcmSpbi2P8CdSucVeKUeQK7PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF183C9380E
X-OriginatorOrg: intel.com

On 6/4/2025 8:41 AM, H. Peter Anvin wrote:
> I think printing the bitmap is fine for unknown bits set... after
> all, you might have surprise vectors. Maybe a list would be cleaner
> by some definition, but we already print bitmaps all over the place.
> It is not critical as long as the information necessary for
> debugging is there. In fact, it is often better for the information
> to be compact so users don't get tempted to abbreviate a bug report.
Sure, will print the full bitmap here. Since this is the unknown NMI
message, it may have unexpected bits set in the bitmap.



