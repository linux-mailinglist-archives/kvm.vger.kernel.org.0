Return-Path: <kvm+bounces-16467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9178BA4B9
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55DFB1F211FA
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A67FD2FA;
	Fri,  3 May 2024 00:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W9l05hhT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675F3BA53;
	Fri,  3 May 2024 00:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714697558; cv=fail; b=lrrzXr9eVn/DOciXk1wbMzfDIYFgt0U5nlI51b0XWgZ0g5AloMIpP9W8SSlTfmWJiTIQ9nGhv2NYhWg7Fv9ojGy3BLyyJwMKvoVBU/S1Df130EAxhWHUEfmOVDf8dsTL9VIAx3tZN9IV2Ip8wr0b3MRGpLP/aa2BWXgYAQQk244=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714697558; c=relaxed/simple;
	bh=9dwUDiG+Yf161ejMNd86/4Cr5ED4SZTofM6ZJDRkx2o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cHFNDr3bnxm0lqil5ZfAVRelVMyP1axRWDgiaHWGzYOmH0vYEWJCx/Uj5exFk+phL+KVUDxOKCP63GTUIkagsaL3bDQG//EOji+pEOy2fW7EBNaGfYt1QCKMS6focBiIleMKPvzRTxCRbJYDt+KdPt6k1FKQ1Rzndt5ongtbzfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W9l05hhT; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714697556; x=1746233556;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9dwUDiG+Yf161ejMNd86/4Cr5ED4SZTofM6ZJDRkx2o=;
  b=W9l05hhTQxPuVF8UpPttm8rRsRB8XPtZmwaGpN782KMPrPV74xiSzCX/
   9qL18Swm9wHG77jEslfvp/3DIX4NqOiN/TLBlNbGruQVty3Xhx/A/MeW6
   rd85xXiZ/XSF1NmW7tL8eyhdPvmmfiz/upjUOM2hc+/RAb+j0shxyJLJR
   RouZ0U0mdLlfdwvsCcCsHgxagC1P0sy5uUDcP4CuwjPNsta9nIuATCy1q
   itDFNLgin/o4p5pQtAJjedHxM1F1Pb6YB1OFmVulh/jT7PdiDkYIsCt/e
   pjEFt076ERP29aL8HsvunHG9x4HV+E9E6peozirRek77mcV+Bk2vi5jGu
   A==;
X-CSE-ConnectionGUID: 9gtdJx72QwKRCFwR28MqGw==
X-CSE-MsgGUID: lqBAx9WDRv6xNgasIkDoHA==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="27978506"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27978506"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:52:35 -0700
X-CSE-ConnectionGUID: 0VKR2EzlQRK4s/QgkrzVsw==
X-CSE-MsgGUID: oCqtvZRoSeqPFMGAyCaTbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="32096818"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:52:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:52:34 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:52:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:52:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:52:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQ3BV08S+Nz+QGLpTNKu85bBFL2XfWraLbSfEZGQCi67ueBGn8IAEfKXk1jEAqzZuWNJt+I44Eh1wZg/i5ogMEr0hd/XSLBsLTKuIhVAx1Nb5pro+93hdw8LesSxv6KUmwTJsYcHhrM8x1iM7e/e/vUIpxLr4FiINDjJeJP1YJCdfFOI6YKdhiYk6vnuLeu7kmkzxx8FHWq2QtNFctET/FP/hrwABkIqCe7Kk/8N1GJSqsu+/KbnzyXHORBWCw4e+hSe0uQqdxCiP6nFK0DvtiHbAE5en4i9tV4I3EV9xyRIzgmWPRLIAFBGH0xcTCuB4yLu7uWZ2KG8xzH73QFKkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNH4u+8xjTGri3Dj79IX4+ADSaCu+VIkAIWNE+GMUIE=;
 b=IBeGkmz17YLMxtjn50jLYdcSaU/SHzg/TE2pODr/oJXTIRajPdMMOk9YOhiDxxj/M1c0SHyE4dAfq0BgEF2nngGh2ZDxjrGN0c4vPq0OrgMYUppNvy9/VyINWMiz8yqSY1K08zvQ2WRsG35s+n6+cdFWYURaCVknxecolIJs6GLsXA72ZIEgEfUnH4dKIob4dbF41Huy8DyIMOv9H4sAduHN4hiuCLjyRCrId2tnmF4rNK+L9Y6UXHvE4FHlQvq1i2vzusKpWfzq/wZ/GsMEb8Ls/SJGDjW2JrYqDx1kYIVE/QG7ez6gxqhI8Diymx+ylkj6xOAalg7tz87NYdfZ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4808.namprd11.prod.outlook.com (2603:10b6:510:39::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 3 May
 2024 00:52:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 00:52:31 +0000
Message-ID: <6940c326-bfca-4c67-badf-ab5c086bf492@intel.com>
Date: Fri, 3 May 2024 12:52:07 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
 <393931ee1d8f0dfb199b3e81aa660f2af0351129.1709288433.git.kai.huang@intel.com>
 <ebc3ef050ce889980c46275dac9eb21ab7289b8a.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ebc3ef050ce889980c46275dac9eb21ab7289b8a.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR16CA0008.namprd16.prod.outlook.com (2603:10b6:907::21)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB4808:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b13a96a-25d0-47bd-450b-08dc6b0b5068
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NUFHM0Q3OXRyeDFGMGdmekFRVkF0a3J6cVZBMzJJSWJWeXJuVDFPLzZsWjBE?=
 =?utf-8?B?OHlrU2ptbkpoMTd4TnB5Ly9BTzJ5NnRQMFA4QXc1UDhJM1ZaSkRnSVFqZzhQ?=
 =?utf-8?B?UnVxbStTNGZRYWdYQmc2TTlRbDFKam1YYWdhVFhJQ1RMR3hPMnVVK2JkeGVp?=
 =?utf-8?B?RXRvamJiNjZ1NDJmaXdONGxBTkcraTM4aWNrb1JHa20waUN5QTJqZ3c3cWkv?=
 =?utf-8?B?bHBGWE84V1B6V2ZJb0hoTnZyd1NtK1VZcnI2c1BTV2xTTy9CbGtTS0Evb1do?=
 =?utf-8?B?WDN0T1M5alJUd2VvZytpSnNjL05sNHA3RHJCcVl0aDNNcStLNUZjR0JEYmJ0?=
 =?utf-8?B?OXAzMmRLOCtCK3hwMmhCT1BXSGk5dzczQVhUcnQyeEJEYTlqQ1cwVHEybGdl?=
 =?utf-8?B?OVpwTVM1azU1aG1ZaXdDeWF5WWh0RmtOYkVSSWZ5dGhlS2ZWVzdHb0FOQnVn?=
 =?utf-8?B?ZVArc2QySzlaRjdhVnMxVXo2UXhITnVDUVVzK21DWU1qeDZkK3lZTWRBN1hS?=
 =?utf-8?B?ejRaSCtRblltSHRBN1Y0OXBoVUwyMWlycUdmT2FkQTNwOGdrYTVQM01XaHRS?=
 =?utf-8?B?aUtrY3VrM1YxMFJpVDNQdGVoVCtxQnhmNWM2UkE5blNRKzRQaHdNY1RCVHhP?=
 =?utf-8?B?bXhhQjJad0ZLMm9Ga3hUMUJoWHJMQzJXbGMxTStZV1dMQW9JKzhSMGxoMXN2?=
 =?utf-8?B?dTd1UTN2bkVTckYrU1h4eHhCdEtvWUVkT2J0bmcvSXJXeWovZUdVNzRrNEt0?=
 =?utf-8?B?YWpHbjQxeVpXYmpyTkZSU05zSDVCeWwxOUgrL1RNSE9jbldvQ3hnaVZHSVpW?=
 =?utf-8?B?eUY2c2lGc2VrTjlBL0QwZm9tOXVhbW05MUExVFJnYVBqM0VsSEJDQm5IajJ6?=
 =?utf-8?B?NnVUS3lnT1ZUMGdSQ0xFRGlIcU54YWNtc1lDaUlzd0ZqekFReSsyVUNoK1FD?=
 =?utf-8?B?VHliZnd0UkhVT2t2L0xQNHV0eCs5SytnaFBwU20xUVYxNXovTzM4cS9oMVdI?=
 =?utf-8?B?WWV1Ty9oMlcwRHIrWkJKOE1mWm9FT2xDZktML0FRRmtQa1ZtK29YWXAvOE0y?=
 =?utf-8?B?bHFDbzJybzlLeTN2V05jVGQ5ajNHV1BNSUoxSVh3WXVhWEZtbjN3Snh5emVm?=
 =?utf-8?B?ejRHalNWZXl6SGJrK25JNGI0WkVmSGU2OVFzRWdqcTNaMjYzWUpqc0VNSmxL?=
 =?utf-8?B?NGphajcxMk9PR05STWVkZTRWcnl3NE5neXVYeFdJQ3BXbEloanlocFBTRXYx?=
 =?utf-8?B?OVNQVFRiZXMzQTcwOC9wK3Z5RkdUcVlrcjFBZk81bVFhTzJPTmN4WkVqbkIv?=
 =?utf-8?B?UUEzSkNnM2hXbVVxQVVDR1c3b2xvSXJuUThQTk5WaEJXakY1Tm5mSXVJZGVO?=
 =?utf-8?B?dHVBT21HVWNwZ1lzREVOVkV1SUY1c0I5RGNmVkVmaTY3azNIQ281dG9kVzQw?=
 =?utf-8?B?a3lqZ2xNemNjbldqS2YzVGxYRzRTS2o3d2xLWm1kVFIvem1ORnlFekJvMWgz?=
 =?utf-8?B?UERFL0JhUktseTVaTHdTSzkrNm9xYlc2aE9oTy9NZXBPb08zR1FKU0pGYWZk?=
 =?utf-8?B?cmJ6em9EK0lFcXBjd2tvRU0wQlRiZE1uZ3JaS090MmVYUVRIbE9HbS9OSjh6?=
 =?utf-8?B?UmJEa01PenYyVVhYcGpSZ29QSGNoNDU5ZXB2NG1pOU1aQUhHWjFUNVVSUjBu?=
 =?utf-8?B?TERRM2EwMkkvbjN5OWJlREZOdFczWXRBUEhPVkw4U1JlMExhOTNCR0FRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVhpeXhndGtBRVlick0wV3RVcUM2NnRjYUZmdUJsdE1OY2h3VUxhQ3hhN1FL?=
 =?utf-8?B?TzcwTDFiTXBXaytERTh4WVppdTJTdjgveVpoU1dmZmNOS2pOODhXTTBsLytB?=
 =?utf-8?B?MlFMYUM0UDJOMGpEVFVwNDkxZlRDblFLRytkRkZrdllLWjVnRE9TQkcvQjJv?=
 =?utf-8?B?dkpIZ0p0RFZwYzBESjlPcGk2V1ZGZDMzZjI4bGlJWUlUaURBdlZ1dVlmR1Yy?=
 =?utf-8?B?N2x2L04yWW9VS3ZvM04yWUN4SlVPalN2UjRMK0hhanM3TjZ6V0M2emJSaGF0?=
 =?utf-8?B?MXBrRGxsQWlHZ2phQ3ArNEpYUmk0NWpKd25Kc0x4eENadEhodWpkUVZqVEw5?=
 =?utf-8?B?MnBtcnNTamFJY1I0Z1N5TmxTOGtPdTcwMWJRaUl0RlRXLzJLMkxuMjd3eXFq?=
 =?utf-8?B?T0czUDRhYnNqbmNibkdVVWZYZGZTdTcrR2VYelZJK2JpQTltSDBCWUxvSW1C?=
 =?utf-8?B?WXpHQ3V4V2lFbVM1OFZPWGQrLy8yQmdaV2Y4QjRzbllDL1d6NnZINzl4bUNh?=
 =?utf-8?B?ZG9ndXZzZS81RmFQZEtBNHZ6eFRMa0N4eEpDcXpKS2lLb044ZWhyZVFuNVpp?=
 =?utf-8?B?VmVBdlY2ZFhkYXlqaUJoS1NqTlVycDhxZFlHNkNGR3hKZU8yd2ZrN3JQZjZ2?=
 =?utf-8?B?eXFXTUdNa2txbDJ6K2JkMzQrYmdIK0xwQ0UzdHhDeDdEL0ZtMTNRZlNCM3ZM?=
 =?utf-8?B?TURUS29XeWhLSUdibnJXTlUzWldnSm81Q0RiQm5GbnVBTlczWk9SOXc5dWZO?=
 =?utf-8?B?L3ViZXV5NkEzK3ZoK2dnS29scUdqaEpmdEU3NVJFWlh2QWRvV2llbEs1MFJV?=
 =?utf-8?B?OTNXdTZFTUtpOWlrazBDVVQzOVZENnEwcUs1cHI4OG80T3NkSW5iZGhCTmk1?=
 =?utf-8?B?MHpOQ1Q0ZFl4Q3hkS1ZWVTBCWDJmRnZoTzVmb1JpT281UE5YdDhKZWpLaVhs?=
 =?utf-8?B?b0p1c2swZlljbFZLWmM3d2Q3em9KVmd1czh1clViN254Rk5ZUko2cEtJUitZ?=
 =?utf-8?B?MzBBWXlsY2MrMXREa0ROQ25yeFI1Y0pmaU5qbU80N3Z3bFhXM0tvSW1RUUN2?=
 =?utf-8?B?N1JuTjk4bnR4RTZDZGl1eVYwTURGajByNzZYT1NHV0JtTERWQlYyQmwzVDdX?=
 =?utf-8?B?V1JPOTU4WER5ZmtWYm1DcHAxc0ZIMGlXTEhHb1JOQ3paUnZTSG1yRElhbVUv?=
 =?utf-8?B?dVEvUDN3akN3aEJGSTNmTFIrbTZEcnNEOTJFeENoTktCbExZZzVsbE84am0w?=
 =?utf-8?B?OFpZeC9GQ3J6RjBFbGpZUUIzTzFNZkRxQmFOdkJFVm03aTJEdGZGNlJYdlVz?=
 =?utf-8?B?blNPS2w2S0lzcmFxZ28xblAxNEF5aVlFSURNUmhxV1hwbUx3WFBYVElxK0J3?=
 =?utf-8?B?ekFycDBRK3lYRkIrQlhZTjJVWDVFK2tBMWd0VnlGTUo2dGRndW1TaFVIWXFE?=
 =?utf-8?B?RnBGQ2MzS3lncE4zaExXcHplMURCWHd4RlF4MWdYYTRQUmljRCtQOHZFRE4y?=
 =?utf-8?B?MDBWZkorYnZVR2FyQnZVTEczNlRueXFZMm0vME1HOWNISFlvc2VhYjIyaEli?=
 =?utf-8?B?Y2ZZWWI1NnJmdklDZUxHWUpUUWJtMXhnVnQ4elBkNStRMlRRSXJodDRyem14?=
 =?utf-8?B?UmQ4c0p1Rmt3ZU5hdGF1TXd4RGRwUWxONHdyY1dqNHBmcHVKY1NaS05nRzBH?=
 =?utf-8?B?MHZTbjd1NW50bjkyRzJHR3NXbnE2S0hZd1ZnQmtiOGZGamRQQ3cvK29kc1Nq?=
 =?utf-8?B?K0JxQmZIT1VQakppL3RMK2FQdnBUOUZsS09uNzQ2d3BqbzBTOURTdXRpb0dH?=
 =?utf-8?B?blFwdEhkTmxvZ2VQZXl3c2ViK1VBWmJlV05Fc1Zsd2JDNmZXcEZBMFdDR1Fk?=
 =?utf-8?B?M0ZoQTMyeDZhYWdzL3Z6K1hKY2dkOVNPWkl3MmFLalVrclNlSDZJdUFyL1lW?=
 =?utf-8?B?UnFCVktRYVpFUE0xUGFoSk1RcU5UTXUxVlZzTjdpYVdkMzZKcm92ZTJ5SXlP?=
 =?utf-8?B?NU9POXZhaGlxSEVLY0ZRYkk1WUFzQTJoNEdPMFJOVm81TkxyMWlFbTlWSDhy?=
 =?utf-8?B?L29NZk9YOUdiK1hRZDJ4azhVRFpXcHdyYm5hdmc0R1NnY3dXNEwrcUFuc0sr?=
 =?utf-8?Q?4nQxi59v9XxR8ZroEVcdg+RQL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b13a96a-25d0-47bd-450b-08dc6b0b5068
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 00:52:31.9252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gco3NSXv+NwM9lCWH2fzF/XItxXrFTFATNJJBHGYdJcNHz27WZpGwfJlSiIf5mZvcHr0GffWBmnNfLDyA/I5gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4808
X-OriginatorOrg: intel.com



On 3/05/2024 12:12 pm, Edgecombe, Rick P wrote:
> On Sat, 2024-03-02 at 00:20 +1300, Kai Huang wrote:
>> +#define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)   \
>> +       TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
>>   
>>   static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>>   {
>>          /* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
>>          const struct field_mapping fields[] = {
>> -               TD_SYSINFO_MAP(MAX_TDMRS,             max_tdmrs),
>> -               TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
>> -               TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,
>> pamt_entry_size[TDX_PS_4K]),
>> -               TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,
>> pamt_entry_size[TDX_PS_2M]),
>> -               TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,
>> pamt_entry_size[TDX_PS_1G]),
>> +               TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,             max_tdmrs),
>> +               TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR,
>> max_reserved_per_tdmr),
>> +               TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,
>> pamt_entry_size[TDX_PS_4K]),
>> +               TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,
>> pamt_entry_size[TDX_PS_2M]),
>> +               TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,
>> pamt_entry_size[TDX_PS_1G]),
> 
> The creation of TD_SYSINFO_MAP_TDMR_INFO part is not strictly needed, but makes
> sense in the context of the signature change in read_sys_metadata_field16(). It
> might be worth justifying it in the log.


I see your point.  How about adding below paragraph to the end of this 
changelog?

"
The metadata reading code uses the TD_SYSINFO_MAP() macro to describe 
the mapping between the metadata fields and the members of the 'struct 
tdx_tdmr_sysinfo'.  I.e., it hard-codes the 'struct tdx_tdmr_sysinfo' 
inside the macro.

As part of unbinding metadata read with 'struct tdx_tdmr_sysinfo', the 
TD_SYSINFO_MAP() macro needs to be changed to additionally take the 
structure as argument so it can accept any structure.  That would make 
the current code to read TDMR related metadata fields longer if using 
TD_SYSINFO_MAP() directly.

Define a wrapper macro for reading TDMR related metadata fields to make 
the code shorter.
"

By typing, it reminds me that I kinda need to learn how to separate the 
"high level design" vs "low level implementation details".  I think the 
latter can be seen easily in the code, and probably can be avoided in 
the changelog.

I am not sure whether adding the TD_SYSINFO_MAP_TDMR_INFO() macro belong 
to which category, especially when I needed a lot text to justify this 
change (thus I wonder whether it is worth to do).

Or any shorter version that you can suggest?

Thanks.
	

