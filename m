Return-Path: <kvm+bounces-55341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C34B30304
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D89641CE2D3C
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 19:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3155035083E;
	Thu, 21 Aug 2025 19:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JZ28d0Xu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE00034AAFF;
	Thu, 21 Aug 2025 19:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755804852; cv=fail; b=sOglxVhM0tCNe+bj94APiN7+qOoId+OvDVcF91ZSN2bE30K6eLh8oTHAt4Lr5NmL6Z7RVXcFNWjD+J/JkS00LC5e2EvJaLU9MySGMHJcTTOrzHNSWcce+m/mJJlfilXu/lzWrVF2OhsGLeaw9L+yiKf1FCRlOrukKyYLc3l0j74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755804852; c=relaxed/simple;
	bh=yRg9LpYrjKZbM34HCtFrRl8J7IMCEwl6TBruPu1lvKA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JNUt6Kxiwyl1XnDAnyLG8HBg1YeYp7RaQHcU2QeRz6/NE1PabVFsvLGmU63MlOoem7MKQg7SM+tuEDMYXsYYC8AkDbTNdIa9puWdDARFBDfOeu1wesIAZRur0eEUd6kyWmVrIGzwkW3wnuHOwsGrUojYHe1vEZD8fKlnuvxO6bU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JZ28d0Xu; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755804851; x=1787340851;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yRg9LpYrjKZbM34HCtFrRl8J7IMCEwl6TBruPu1lvKA=;
  b=JZ28d0XuHop5n9ltgbf5dzE4oNEtUdfGI+jjsBZYIFsjjnihwRkvR5Oc
   ilKcsg/Ctm7Z2xTQvmSYoj+YjQ60mzWUFapVG/keIR1U7IMjVUhb++Ncm
   qw1ZsY2M08Ce314PDhqivhmFePkS1uqKylApZx2HuOVuFnJPe5QQs3OCW
   RdsfhOSk9B7ZX3rf0oVm8tczlH29MKEZvU31qFGu/4ovVCiHphPmES8nQ
   ht+AeAZScCEMutL94yEbmE67+7sPXOPfKYxM5qaLMs0bs+2ViWnphEQCJ
   EbrUk20iXw/RVVPbhIVIJ6mrD17dfMjMXczPBKxrpo2OjrAPtcC6wUIZ7
   A==;
X-CSE-ConnectionGUID: yXPt9O51QceryGIDYNLkow==
X-CSE-MsgGUID: uTusW9kVQUucnZQjskiSdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58032314"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58032314"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 12:34:10 -0700
X-CSE-ConnectionGUID: VOZOI1m1Q/aInIPsIkOjKQ==
X-CSE-MsgGUID: g8JEIWcRQGudHI3yvor55w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="172709187"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 12:34:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 12:34:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 21 Aug 2025 12:34:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.45) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 12:34:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ty8XmjKdBKpz+/GAsB0bJz+dg8b5GYuLMQo2+pDbk3+FyR81vwUV2OZZLmtFcGNIo4uDl62Qd6V1dXuX5PNC4yuth50UKge+DaHczjJ/BVUHJpUV6+kQgltKK5SsL+yeWAwPd4ab42WOHFE45G8immnHUPZwr+7S2U1WWp708C6lTofZVNxRfas2ieihUFKRvbR7U8dgkMEVUq1vaazpjkr61RS+d4eyy5HMr4DWuOTMHhcq3dyrEZpmbEaG8z1RMNofBMtxorUjUj3JDri+TXhaAidTl2ez4El2vUlXEh+rX24AKav6ocr/J7bOc9+dsH8vXV4DaDz9k1NHpq0Bjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4XN3AovvR0H2OmCvTRcqrch2e6ZTY9StMlmWKNg2J4=;
 b=sKD7SSwM1xJuFilu4isKKtt3+f1TBt1CssRg/vXL1svWbr9V9wni+3U18Cghb2NEGAVB1iaehnbHe015ueg8k/JBSECQItwJ1kMiR9d4CznCUhC+yj38j0IbRQlLIBLs08PZCGHcTTWD66YLd4d0OotwHPCx1VWHeOJ+ko4Pf972jMFxaCswfDuHyDwzNEZVStJFGEp5pHcarwkkE8vrmHbadk/04GGqr+HmxsZg9yKqoKJQSzeHJuqiMm8QF90vNiAHbraQc4e3PDoG5FXZhzs3tfHuAr1PfeKNXDS629hh9Oy59UMxqU3q+lMN7gl03HfyfWxcY86MgK/soHLmcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14)
 by SJ2PR11MB7575.namprd11.prod.outlook.com (2603:10b6:a03:4ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 19:34:05 +0000
Received: from DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::9105:2b7c:b256:7a6c]) by DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::9105:2b7c:b256:7a6c%6]) with mapi id 15.20.9052.012; Thu, 21 Aug 2025
 19:34:05 +0000
Message-ID: <968a179f-3da7-4c69-b798-357ea8d759eb@intel.com>
Date: Thu, 21 Aug 2025 12:34:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/15] x86/cpu/intel: Bound the non-architectural
 constant_tsc model checks
To: David Woodhouse <dwmw2@infradead.org>, <x86@kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	=?UTF-8?Q?J=C3=BCrgen_Gross?= <jgross@suse.com>, Boris Ostrovsky
	<boris.ostrovsky@oracle.com>, xen-devel <xen-devel@lists.xenproject.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	"Kan Liang" <kan.liang@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin"
	<hpa@zytor.com>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<lenb@kernel.org>, Andy Lutomirski <luto@kernel.org>, Viresh Kumar
	<viresh.kumar@linaro.org>, Jean Delvare <jdelvare@suse.com>, Guenter Roeck
	<linux@roeck-us.net>, Zhang Rui <rui.zhang@intel.com>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "David Laight" <david.laight.linux@gmail.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, <linux-perf-users@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <kvm@vger.kernel.org>, <xiaoyao.li@intel.com>,
	Xin Li <xin@zytor.com>
References: <20250219184133.816753-1-sohil.mehta@intel.com>
 <20250219184133.816753-14-sohil.mehta@intel.com>
 <6f05a6849fb7b22db35216dcf12bf537f8a43a92.camel@infradead.org>
Content-Language: en-US
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <6f05a6849fb7b22db35216dcf12bf537f8a43a92.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0340.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::15) To DS0PR11MB7997.namprd11.prod.outlook.com
 (2603:10b6:8:125::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7997:EE_|SJ2PR11MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8f1f03-90c9-4c2d-9b8d-08dde0e9b08d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bEpZNVNqRFlKelQ4ekRGNkFjclg4cThvaHV1Um9WaFhEWm1FWnpMaVU1YTNV?=
 =?utf-8?B?M0lKMUtXemhPY3V3MVlOaTFEbjhNTzFHaEc0eUxJSFo5c0Rqdzc4YnB3aEM5?=
 =?utf-8?B?Y05lc3JZZE5tWktSVXZFVFF5a0ZEdGtBYXhhUVNUL0FITDZrdHV4ay95SGlH?=
 =?utf-8?B?aWJUZGQrSkM4VmtHVkVMN09MSkpvbEF6Rkxjc2QrYit6T0k4N25jNkkyTFl0?=
 =?utf-8?B?MkNJWTdUWTlYTlNOYUFEUUM4UUhUZGRQRkNFVlRpMXBHM2VidVBLL0pySDhn?=
 =?utf-8?B?em05L0lldjduVHdzNnB0dFh6ek53ODVKbTRwK1I4dHJLVFZZK1RSYUxVRkN5?=
 =?utf-8?B?QjlKN2NtTUp2OGF1dmtGVVpEUnljTk0xQzQ3dzcwSnBiaVoxQzJFcVZwOC9L?=
 =?utf-8?B?WGVCbE4xLzV5Q2VhRGxNR2FvOEtHL0oxRWdWMytSZjNWQjdYWFhtSXd2QVpz?=
 =?utf-8?B?K1I4ZitJV0c0V1pnd3BFeDM1K3lDbE5IVnpyQmYvam56dDI1MmNNYm1qUU5m?=
 =?utf-8?B?UHJoRXM4RXpZeWFkZDlQc3MvS0gxa2tIQlVhOStsRFJyZTJTaURRcXNHNjky?=
 =?utf-8?B?QVN3aWpWWkd2YVdibklIQ1NOSTFEUG9kZkNvT3VlMjBDRHlxOUI5ZU9wd3h2?=
 =?utf-8?B?emxuQlYvNVk4OXc2Q1E3dDU5TVIxUElod05TeGJUYlUwV0txQkpmZktKNUxJ?=
 =?utf-8?B?NDZEU1Z5bUFTaXk0UWp5VHlWcVVTanNpZlZjZXJ1ZCtOdVN2OUVyWG9YTXFC?=
 =?utf-8?B?T21LMjJ4cUlZSi96bVpTd2FBNm9WVUNZWlA5RnQ1SjBtOVlWV1liL0t2MFQ4?=
 =?utf-8?B?dXNCeFVqbTE4Nk92SDkyNGRvTEg5WU1IVS9idTVmYlQzVFM3RS8rUDQ1TThS?=
 =?utf-8?B?Q0tWbXkrQjZLcDZhK2NaZkJSSWU3TFJmSVRVb0tvVk45Uy9MZmJKUVAreENI?=
 =?utf-8?B?bXR5OWlOSWN1Tzk4ZXZON25lbURMZW8yaVBGQW9Bc3R0UitkUDYxRnNaaUJ3?=
 =?utf-8?B?SEtEMHZRUXFDVGNpeUljaTIyQ2p3WGZ4ZmlSd2ZQbzRsdHo3cXJ6UEhBQzIz?=
 =?utf-8?B?Lzh4dG9CNXM4VzR5SXA3STVqRUtrQnJlTkxoWEJ0cnVsUzFzMXpVRTh4MEVE?=
 =?utf-8?B?RUlxZUN4WnJMZGpjK28xZXBGanVYWE9CdHdGZnQrb3NZUnBPZmhZQ3ZRRW1k?=
 =?utf-8?B?WXVvNFRjWGJMZThrYWNmbGZzMGlMUElycUVNTDJ1WVJEWG12OFBkMjZMRks3?=
 =?utf-8?B?aFA3ZDB5L0s0QU9ZUjJpcEtPVFk3VjVBZUZGN2tseWtRYy9FOHJzVk5HR1dx?=
 =?utf-8?B?Z1hBSUkyKzVld1gwWC9wYzdyeklTUFlaaFc3SzdWdml2L2V0VmFBWGp2ZmF5?=
 =?utf-8?B?YkFoRUVhNVo2TFpWV0VjQW9SaFFUb0daODR0dGZSRzdrbko3MTJoMnFvRGtG?=
 =?utf-8?B?SzNhWkFVckhBTzdXcndjQ1ZXUEJPSW5rSlBST0lHMldiNWRyRzRtQXpnajND?=
 =?utf-8?B?RGhUQk02RlhzM0NseE95UHZ1VjFkeCtYWUdFSVYrbEZtbVA1UDlseEcxbW8y?=
 =?utf-8?B?NndnbDZrczl5MVNlYm9BVURPaENhUTBaWmJmbytpRFBZUXJsZUpHVEhUN01j?=
 =?utf-8?B?Sm5MS08zMW9XMnBBRWU0dE9aUk1OalViV2pzSTdOcmsvU0tJRUlubjNuZjZa?=
 =?utf-8?B?VGZUSHhXVmpRUDJrdW93Ylh5aXpKUExKbC83a1NRYVpHdVcxWVVTYWZ0cEZz?=
 =?utf-8?B?bXkrL2JSaktMd0Q0eHlGMmJYMG5MaEpBNnBDamhHWEJMeEQyNzBGWHRGbEpm?=
 =?utf-8?B?MFpYRE1WbnpldU5wNGtZZGxkN0J4bER5T0hHSldsL1NQazdWTlFJbzYzUTlO?=
 =?utf-8?B?dzdlSjU1bVFWY0x4VTJ0RXVvWWFMWmxSbWgyTkVBLzVoREE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXo4NmJYZ3h1dEkzc3Fpd1JlRXVGaWMvV1FTRmlySXBxWjhyOVlEMGFqZzJq?=
 =?utf-8?B?SXdMUFl5U3VJVFpTamZNY0RrVER5MTRaTmRqRG9TYWozVmlBWjhlN1ZQR2dO?=
 =?utf-8?B?ZGVGQkFsVEFrRkdwWnM5cWNQZXVSaUxhdzRNZXVuTEhISVVsV2lQSXdHR0Za?=
 =?utf-8?B?TWg1Y0drWDVmZG5oelVDVngzZTdMbEwvbzlyaHZuMWRuSHEzdm5VWCsrRzht?=
 =?utf-8?B?U0RJKzRWRGtma0tCOE51RkFxME0wNDZzMnZqTGRONHp6dklCdGhPdEhMQ2Qz?=
 =?utf-8?B?WU1ZUldGd2l5c2NkQWwxKysrRFFhanBjTTZkbXczZGF6NE51ZlFJT0QvdCtJ?=
 =?utf-8?B?YUh4enFwVDZFM2RLNUhHVHBHaHIyemRtTkNLRW9BMUVqT092MUZ0aEQ5VjJC?=
 =?utf-8?B?VEwwZC9UNElOMGdqekxrUjBXeWMyV09yS3BFb1ducm5tNWlxUXpzbFhLTXFq?=
 =?utf-8?B?OFlIOW9RS043c2tCdkxzNU4wejZyY0E0TXVoV3RtZVJ3TldVcGZqTTlBRVFm?=
 =?utf-8?B?bXRrZjUzZnBoREpHNkk0RHRlcm9KWUVCNXlKVFpsZWg1RllINVBOVERvSTBn?=
 =?utf-8?B?SGNkNEkyODVZYnpFMkpvdTM4aVBLZ3Y1MStXaFZDcm1XRjRpcTZBRlVrOGhr?=
 =?utf-8?B?Y2ZtUnFudm9GeWhJdE1FMTVFR1FKZllsKzVnTEkvcWx6OERmQWU1N0VNb2x6?=
 =?utf-8?B?MHFqMXBaV3FLQlhhT1h2RkhuamdrUWxiRlJwZHVoK29CSWRwWmdFeDJwd0VS?=
 =?utf-8?B?OFNBS0laTkFEOW9UTS81Q3kzSDE4c1orRlQ2Q1NrVEZMVHFqTlBXMmx3eWFo?=
 =?utf-8?B?bzVQUTVrMC9Pc3V6U2twWlIxTnNNOGtCU3NGQldkdWpKNUFHZkhrcC9ucStU?=
 =?utf-8?B?Vy96OCtiSXpnVXFxeUZlRTZUWmZFY29HZWdVdE02c0ZUWktFbndTUGhiajRr?=
 =?utf-8?B?d1hMVU1rZXZhZE5ZVHA2eXY3MHdTTVpiMGlxZEk2VXdVQ1h1elZ2N0J1WVNO?=
 =?utf-8?B?L3hVNFhFS3diOFdZanRmWWY5VFdZREluZXBTVnN5WGU4eXgwRHNGazg4OXgx?=
 =?utf-8?B?THZHZXhzNFExVTh5V001S0FUQmNmclBCZUdKU3JOU0ZmeGpTQzVVU2ZNTkRy?=
 =?utf-8?B?RmYxUFFZWFFsSk1JSGtZRDdKQ01BSUhkN0NnVkhHTFBTU2lHOWV1cGhWRUpW?=
 =?utf-8?B?cnZMaVd3bFY4R0NtSXRUK0tqVE9aOWJPbUJjdFBYNEZOZjBhV0FvbDY4VElN?=
 =?utf-8?B?ZzNzM3RPN1plS0x1OEJUQU1NcUxlQWR3YzBvOUtjSmd1aUQvVmhYWUlpL2F3?=
 =?utf-8?B?dlUvakFuMTg3NE82THJDTUR4THRMSXcwam1ZdTlkaDErZVdud2F1c21UUVlV?=
 =?utf-8?B?cTI4TTJWMC9Xbk5IN0lra3NDbFA4R21BVG1zbzBNeUE5U0ZhQ1pFaUErZVFp?=
 =?utf-8?B?UWY2b2lPL29SZ01PSm9uSklKNWdpb3R0R2NGRkFTMjFsVlR2SVV1TTFNWkhu?=
 =?utf-8?B?WmlnWi9uQnUvdjhINTFDSEJCN2pMMk9Rbng3RjZ4RkRZNVJTN25mMjFTL2Zt?=
 =?utf-8?B?KzFxcnNwYlV4M2UxNlRCU1RlK0FDdjdNUEtHdjBKd1k5MWRkWk85S1JsUWdX?=
 =?utf-8?B?RTZCV09NaU1OS2JVRE4vSVpXaktLcVlKbnRWYVZCSEJNMkxodWoxUTVBSU43?=
 =?utf-8?B?N3F5dmhCWHBTZUhjV0M1Qys1Q0hJZHZKWkdXWTRwRDRLVnVsUVFuYkpxMUEv?=
 =?utf-8?B?eldpNndZZXUxdk1Ob2luMUpkNTdqNHBQMkZxa0VWUkY5VElQZ3NoZFd5bDFo?=
 =?utf-8?B?QU85c0JLOFVaRjRweXp3MHRnbi9qc0ZUdDloaTZBYzdIVHljVVM1VzB0SkIz?=
 =?utf-8?B?NnpwYzJ6cTU2UHVNRE1ER2Jxbi8xNnM4VXJ6cGVaWmZqdmRnRit1ZnhwWWc5?=
 =?utf-8?B?azZPejBWR3BSWHdtMDQrU3E2SDByb0ZsZzJhOU5OVzltZjlwV05lRTcvVStB?=
 =?utf-8?B?NGxUcDdMaXBxb0Vmc2R2ZXQ2SEVpT254U0lGZFJXYzRDRGRTb0ROdWl0RkxX?=
 =?utf-8?B?NUp1T01HSHhmRUNRRUtiNXlZOUFudUJVWFNSVkkvc016VVdYMWVya1Z4WTIr?=
 =?utf-8?Q?qhL6myZcjpZBot35jop5r7LSH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8f1f03-90c9-4c2d-9b8d-08dde0e9b08d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7997.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 19:34:05.2696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H59O1WMrs/4YHel4d2gIFWipF2XGi3Eo8YVCelDNPdjdQwL1aUmr/ucaZnN7/bsBzxWAMgnf4adJ24FVDrkQLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7575
X-OriginatorOrg: intel.com

On 8/21/2025 6:15 AM, David Woodhouse wrote:

> Hm. My test host is INTEL_HASWELL_X (0x63f). For reasons which are
> unclear to me, QEMU doesn't set bit 8 of 0x80000007 EDX unless I
> explicitly append ',+invtsc' to the existing '-cpu host' on its command
> line. So now my guest doesn't think it has X86_FEATURE_CONSTANT_TSC.
> 

Haswell should have X86_FEATURE_CONSTANT_TSC, so I would have expected
the guest bit to be set. Until now, X86_FEATURE_CONSTANT_TSC was set
based on the Family-model instead of the CPUID enumeration which may
have hid the issue.

From my initial look at the QEMU implementation, this seems intentional.

QEMU considers Invariant TSC as un-migratable which prevents it from
being exposed to migratable guests (default).
target/i386/cpu.c:
[FEAT_8000_0007_EDX]
         .unmigratable_flags = CPUID_APM_INVTSC,

Can you please try '-cpu host,migratable=off'?

