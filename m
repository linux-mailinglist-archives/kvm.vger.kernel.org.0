Return-Path: <kvm+bounces-59515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A89BBBD4BA
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 10:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 777D63B0BB6
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 08:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B223825A633;
	Mon,  6 Oct 2025 08:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HxtNDQ9g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8D41B4224;
	Mon,  6 Oct 2025 08:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759737809; cv=fail; b=oB2Lvi+N0gQtEnko+NdBsKDA2RfbRO8RKDB7fB6HksZMS9qDQtKWPpyGfq2qYoBoKbLxEGJwO414YHx9EktPHFTmmoh4geLds6hcRZc00BmBQHRtID+IIw3fMcrjBpJoqI7Jup7DxugELAquKr05RHKdU2wHlkYGUdCBHF9lVMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759737809; c=relaxed/simple;
	bh=bu3OwLQ52LEdGZwySUQtw4fkmbqhZAYgvo3T596nkUQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rEVr6n0rz9AweluaEYXmR2/uLJv0U0tJuBW2g6T4zE0+Lc9ZIYfR1nb/dsuuAFy3c4YMqUz6GosayyYPERwVRPdQ9YGLobx+6U7QHePeOT5ZODGtELqzUXgDPmrobxGpyqP/Znt2EGpoWjViB884RR/CpcJ5zVAoZkj1NnCMeVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HxtNDQ9g; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759737808; x=1791273808;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bu3OwLQ52LEdGZwySUQtw4fkmbqhZAYgvo3T596nkUQ=;
  b=HxtNDQ9gWi2oh3vw85D0hCSExCLEYd+xDzVZBe/xgWxpNgmuhT7UUPpa
   wYr1jNxDLfU1IbON/Sv5pKBVIcaIh2yf6d8pbYnDx83WrnkoDws5Kh3T7
   qxKSGATwP05sgoU6+vkmeqr4ZAJjSkM7IAxm1ThiA9Sbz2zVunArzIGg/
   bjDGfYwjL9PEJHAaRAZWxTXyZ1sdcFE8ycfAU9DaZItGQCDdPQECtwPIu
   S3ZiFuPUxCLcw7gFu9QQ2daBbzksh7Mt7YhRDnuGvaqO7o/FnEXO0WVu0
   hMk7lLT0c+fV2G5NqgdYE4oigANKSfPafernGsQjhh++2bOLFYIrNd0V1
   A==;
X-CSE-ConnectionGUID: d+loLJk3QZ6IfwMsCg5Efg==
X-CSE-MsgGUID: yw40I+OaRdyEpoowrjpPLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11573"; a="72525038"
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="72525038"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 01:03:27 -0700
X-CSE-ConnectionGUID: KvRg+V8DSw21cAIbnW/D/w==
X-CSE-MsgGUID: YmnmQHuESPeQzLbNxTFCEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="184201992"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 01:03:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 01:03:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 01:03:26 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 01:03:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xebyNtGT0H6i18Nbsnsu0SVi2yAgLokfa0QpqS7Fh2Tjk5241MGevy4YZR+B19HBO117kHOZNuFCnw8sECw5t0MiVgxs/6yIQsLb2h6lhtc90YsOj8+EV2Cl5CToQi9/a5S/AbkE8rYvgucfG6T9DLj9n9fLFOlb5c/1wU7A7l5NOT1OsPPX0f+eWn3Cxxs5Y4/4ohgYKujfMKBChIwTZ6eY9ePg46FTbgcs9/JSHXFzO5RgdjzpBP8onHTqreP47qh28FyuKbuu68/iLMmr9SBChobfJxBm1GKHPOEZdbAPGZ92i0Fl1EWnYMb780xuanCWV/nMH6dOZi4wdM9u1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcQxpssyAqkIOJe3lEA9c++SQ/2bFmM7WPdJxWSkpIA=;
 b=ZUFuXZtRN+kRhOaZNBIQySLceDAXOqSGmN66BwF3qB1yrubZvx1fpMEqs1BNvGOrK0mn80nBgVYxrRboY2RztbriY8LQ9P0G87El3hlc5u/B4JnGiYhCETg5N8l9lD/4TQtl86gIwqUv3nUL39WZY+rHHyBvYf57yPedfTCRny56hCb/UT4vnR13XTGpfjYn0B10n2zpKTjDz633idWv0CsvPnYvDuaf5SCDJUabNDixW7yHmw5WV5tSOsB78EVpirkURWgIxDU6jQoTNDGiWIqV1lxwrCfMMaP2BwpAIrkl4EF+ZeUcYxrsSKdv1y872B0EC1tUjGoW6CL/X6ZBvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6129.namprd11.prod.outlook.com (2603:10b6:a03:488::12)
 by MN0PR11MB6159.namprd11.prod.outlook.com (2603:10b6:208:3c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 08:03:19 +0000
Received: from SJ1PR11MB6129.namprd11.prod.outlook.com
 ([fe80::21c3:4b36:8cc5:b525]) by SJ1PR11MB6129.namprd11.prod.outlook.com
 ([fe80::21c3:4b36:8cc5:b525%7]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 08:03:19 +0000
Message-ID: <3bbc4e6d-9f52-483c-a25d-166dca62fb25@intel.com>
Date: Mon, 6 Oct 2025 13:33:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: REGRESSION on linux-next (next-20250919)
To: Sean Christopherson <seanjc@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>
CC: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>, "Suresh
 Kumar Kurmi" <suresh.kumar.kurmi@intel.com>, Jani Saarinen
	<jani.saarinen@intel.com>, <lucas.demarchi@intel.com>,
	<linux-perf-users@vger.kernel.org>, <kvm@vger.kernel.org>
References: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com>
 <25af94f5-79e3-4005-964e-e77b1320a16e@linux.intel.com>
 <aNvyjkuDLOfxAANd@google.com>
Content-Language: en-GB
From: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
In-Reply-To: <aNvyjkuDLOfxAANd@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0123.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:11d::6) To SJ1PR11MB6129.namprd11.prod.outlook.com
 (2603:10b6:a03:488::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6129:EE_|MN0PR11MB6159:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a12f137-0f12-4d95-613f-08de04aecff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eDF0bDJRN3FpUlFyMStKc21ySG1TbXpPT1MxVEFXVGgzQmNWeU9XNllOQTRO?=
 =?utf-8?B?QUZjWnZSV0hrZDV2c1Vlcy9zam90QVdGdzlGdmY1amJmZWFxOTQ4NzNvcWZj?=
 =?utf-8?B?Sm0vMTZwejRKa3dDL2dPU0E4VDlkWnlORC84ZzIzVzlQQ3pPTWpDaE1oWlRW?=
 =?utf-8?B?a2c1bzdPdCtBSFBraEgvUHpReEhtOUVQNk13VlU0R3U4b1JSQTl6WXFTbTNO?=
 =?utf-8?B?dHBrUFFJeFVyaUROVEt3U0ZSYlVaUjBZYmV5c3MxT2lhVitEV3hNS3AyOW41?=
 =?utf-8?B?K0lIZ2crVEk1dHNHbTEzQzVKQ2ZlbEFscGp0cDk5ekVJTXpPTTk5TW4rejAx?=
 =?utf-8?B?b0tWcnJSUXg5QXlmSnBYL08rNUEvODlCbjB5VmFIdEtHdzhZUUpNUHVlK2g2?=
 =?utf-8?B?QzBwam1WdnJLbnN1WlJSQmhtcndPN2JoQysrYk85ZlJlZjFZaWt1WW5ocWRX?=
 =?utf-8?B?ZGZHUjNVcU8yeFQwMjM0eFVPUzJtWjZZS1J1VHl1VER1Uy9zVlJvRGhsQi9m?=
 =?utf-8?B?TzhURVJsZXl4QVNIRk1oamVKRm9PVW9iUUZzNWYreFdEZEY3dHFNektvZWhr?=
 =?utf-8?B?Um52MGxCcjI2S3pOWG9RWlROdFJQVStzb2QrOEw0TDY0SnFDVGNuckErOXNY?=
 =?utf-8?B?UWw0SjZDZ2RsYU1RMWU4c0NkNjcvVnE2cWZ6TGtXTUlqYlhBeHFMNzZLamEw?=
 =?utf-8?B?VXhvYm4rVllRa1JyN0xFbmRIRXpkeXBjY1I5OGwvUW5tV1paam1mMktiOVpW?=
 =?utf-8?B?VnlmSEEyQmZKV21HYVRPWm4xQzlHYVd4YnN5ZmRYWk5kWXRSUmMxbnExU3VT?=
 =?utf-8?B?Q0JBV00vb3ZZOEhLQ2x0OXE3QU9UckRJazNUWVZwWXQxZ3dwV08wS0NzQyt5?=
 =?utf-8?B?NXRWcUJ1V3dXbUtXN1hzV2VHOVFmNDR4aXcwR1BmRDhHaktGbjlrYkdaREwx?=
 =?utf-8?B?ZFZoTzlqR2tsY29NRzFMM1F6STB2d2dsdkFWajhxVlQyT0pqcXRpUjB4Q3dS?=
 =?utf-8?B?UHRRdVhBRWRBWW9PUWJDc2lJUG54WFFFTmdrM3NiVHhnRkwzdStoZVJJN0RJ?=
 =?utf-8?B?OUxDcE5vVWVXMWFjaTFHeFQxVVdlaHJOTnhaQlM3RnJQaFBPWkxiTXpDVTdN?=
 =?utf-8?B?aWY4NTY2K0piZHVhWnBXNmU3K0cvMXFpRnA2N2xKd0NXNk9iZGpDRk1Kdkhp?=
 =?utf-8?B?dWhxMEU5c3RHSU5XTkp2cWgySnlVbVVzdEowcSt5QklBNmpyMWk4cFdTSUxZ?=
 =?utf-8?B?REYxVU5mVU1qb25DMmJ6eEUyZDFLRHE0RjQ3OWNtMjlsZG9OOUx3RzZqWDVh?=
 =?utf-8?B?ZG05MnhWSUp6cG1oRU5uNnR4QW5kcmdEWVhJaytPWlpvTzJzRWxwcFpqQTlF?=
 =?utf-8?B?WlBOUk96WXUrU1FaNVRzRGJrUDdhSk1RQktlazI0Z1crUmMxbmZlcW8vNElr?=
 =?utf-8?B?dTdrTGpudEtPdlpFOVpNK0txWiswZm00NHFIdWNqalYwckIyb3BRLzVWRFlT?=
 =?utf-8?B?MnJqcm1rWEtaVnZlc2RZbE5TYmZ5L3ZIWFN4UzR3Qk50QkRTUUM3SjdyM3Bp?=
 =?utf-8?B?N05QdlRZcDRvb1VsSEwvUTFTRUtXZGxRSWJYcVllS0NZTXZadEs2UlZhcmFa?=
 =?utf-8?B?VmhVSU9lTjFVbVNEVnFFeTR4QlJ4ZFZ2N0xxQzlQVEFQaG51RFJjSE9hemtF?=
 =?utf-8?B?TGlpS215YmtPQmUrZnhXelJwWGVqb3Q4ZVRvQlNVem5UTHY5alRQT1V1UEhy?=
 =?utf-8?B?NkdjK2RzWUpDbkc3Mkk3bytaSlFBNlpicXR5UjJGRzRxUFhiclYwSEtHNzVy?=
 =?utf-8?B?cW9hOE9Qa285eSsyQ0FUQzNtY3RXWGRPZWRTVysxRHdPWTJpUjNHM2NISXpV?=
 =?utf-8?B?WU1DL3NpVENWK0pRSnpQVlZUK2R2K1JEb3ZBUVRoS3B5ak1FbXJVRXFGVXN2?=
 =?utf-8?Q?sw3KVw0kNLBfg4hS20vW1fx6dZULeyPD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6129.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3hHVzVvcWgwRjJkbXlLM0hkalMrV3U4SFBZY2p2d1cyQkwwZjBIenBDZXhP?=
 =?utf-8?B?NER3bnJBVHZ4V0RsSHVoV0tSdWlYRFpOZDlBcWZsWDFxOFRvSGlRbTErWjk3?=
 =?utf-8?B?NS8vMlA1a2E2bmc3UTQ2bWZ0dTdjS3BQQVNsTHBta3R1cFcrQ3dEbCtNUjFu?=
 =?utf-8?B?R1h0SmM0Q2NhVGJDaGxzbno4QVBDUE5Zd3k0Qktha0RRMmh1UmZTQVUrdjBC?=
 =?utf-8?B?MUk2b0xTNDFKSldxZk1pN3RlVWhpNi9FVnNGQy9Hd1pYWERrWGNXQ1J0Y1c5?=
 =?utf-8?B?VVIvckFTUUxBaVB0VVBXaE5WdWpRMmZVNlBIY3ZWbFpINDBOMC9oWUxIZzY5?=
 =?utf-8?B?WkVhdEZuT3VGWmJqZno1UTh2d0wrcXp5U3N1TUFCenU5R1NJb3FCWnRaS2o0?=
 =?utf-8?B?MWdtcTV4TURBMWU4aW13SDUzRGJtU24rT1F0K2JFR1dET2htdGl0dW1QOG9a?=
 =?utf-8?B?M0xHd1hFNUtPZWh0SGhGSk8zMmQzbWRtN1M3Tms0aVpONnpIY1FiOWpMSFd6?=
 =?utf-8?B?WW1sanoxeEpCNlArWGZrZDFxYVFJVzRoQkV5SmtUbnpXQjdlc1VzbEN6aU41?=
 =?utf-8?B?L3F1T0JMLzMvVUZIaWt5MEdBYkNWRS9PUEU1TDBtZWxyUTYyNUprU3lLRWNN?=
 =?utf-8?B?K2p2Yk4zSUNUWjd2OUdLL0RkYzlMdmRPUUNMTm9HWGhka3VyRWFscTVNOXVN?=
 =?utf-8?B?WVFBZnBzQzc3WERoSmxJbVR1Mm5LVzVPZ2VPUGdFdFdrMk54cUt3eGx4bHVL?=
 =?utf-8?B?V2JucnlCdHNibzduUmhUYXdYWDNxa3E3dG9ZOEF5SHdOaURZN0thSUZ4TTJI?=
 =?utf-8?B?VFhzd0VOcUh5MnN4c0dUY3hSSTFwM3RQMG9ZaUxTVzFrZysxMFdoYVJHQ2l1?=
 =?utf-8?B?elFyNEdZdWhiRnFhUWdhcmFzVHg4Rlh6OGRRbm94ZWluSHYvZG5jYWRWdGU4?=
 =?utf-8?B?REZiNWZqdkYzT2RGa0ZDaWQ5UVFMK0FGc29uVnFqUVdMWGlMWk1uZENwQjk0?=
 =?utf-8?B?clBRN0lKVnFqaTgxK0Q5Q0JwaFpNVTNuWGhkdmtvQ2NjTVdIVlVkcTlRbmtr?=
 =?utf-8?B?c29xTEZ3dDF4M1I5ZkRCNWRqc28rY2MrUTlzZVY3WUZtMmt6QWZYdWtlR2tp?=
 =?utf-8?B?LzkrMXBhQWRyZHRpZytYQUlSUTFwd0xnaHVBVThjekVEOEJwQit3S29IRTds?=
 =?utf-8?B?UTIrcWdkVFJUazg0RnJNY29pQzJlUllIdWRoUVBmLzRSMFB0VmRzY0lZNUNU?=
 =?utf-8?B?YUkzZDdYcnJNTjBtWkNGeW5rYjBMRjJndXlnN1lDV0x3c240YVpGeWhoVk03?=
 =?utf-8?B?ODFwbXNNYzdUaUFXVktRNy9oQ3hXWWE1MXpHNk12Z3MzUUwrbkk3TW8wdWd0?=
 =?utf-8?B?QkVncVFJRDd0WGVEMVZabDYxZnJlWWlUazl4eDllWmtTd0htUFdicTQ1djN2?=
 =?utf-8?B?TUZadTgrdWMxWTI2TERESHQwRko0SnJBeUJMZU1HcDV1Q0dlVUlOS3MxNmZO?=
 =?utf-8?B?T2RPN0VUdW9wZUFSWk50R0dTTTJ6N2UrMjdNUmN2cjRjbU9zcHVyQjhXNE94?=
 =?utf-8?B?Ri9iSWJoSHB5bVppTGlkbTBIeDZkdExiRHB3clR4OVQ3VGd6bWpwUnJuTjVK?=
 =?utf-8?B?VGYyVTVMSFF1MTZucHY4TTFISlZHL0ZiWFJ5SW9zQXNDUVpTU2FvalRNa0Rk?=
 =?utf-8?B?ck1KTmtQZU9sOWJMNEpvQlQ5UTNyd21RSys2WWN1T3ZCS3cwdWtHdVZIL2JX?=
 =?utf-8?B?ZExTc1l5OGtYK212VTFBbUJjSGd1VklJSHgyZW53Tlg3Rmd6eE9HQ3RPNEVr?=
 =?utf-8?B?ZFVPNUEwVXZBVGFZVGQrK0FBVnR0d2drc1ZuZzh5NXgwamdvamE3QlNIUHJ4?=
 =?utf-8?B?cVFaQlpDOXB5eXlTaFo5QVBrQnJoME9JNll3ci9scXF6bXRaeFBBajlxN3NQ?=
 =?utf-8?B?UUliTm4vVHFBd3FuWFZVVG5iVzc2eXlIM3Z5c3hpNWcyem5vcVFvc00xTUxl?=
 =?utf-8?B?OVhiemZiUko3RVhuUlJmeEFDZ044bFczcXM4SkZ3UWJlVTE1dWpXc2VReWlr?=
 =?utf-8?B?MHQ1N2w2S3c5OGJ2UFhjMXFUeDhvQXJtdWhwMmowQzVVNGpSWHhFeWljdXg3?=
 =?utf-8?B?QkkyS1FxMVNOL0R6NEVlTEVSOWI5dVQzTlFhWVNWQ1RWRzJQMFNkc0VRYnY0?=
 =?utf-8?Q?W69xu/37wep0pwSDt23UC0M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a12f137-0f12-4d95-613f-08de04aecff3
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6129.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 08:03:19.6619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zrcnFrq4Q+1ftQqFgMusbsroRS4U9IQ0UBElNWlQKaDQ+2H307rQqP4GMUsyH3AHU/2Wlm+5UXeHBthUPSRmL1lJN0r6tfLE+hW2F/zHHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6159
X-OriginatorOrg: intel.com



On 9/30/2025 8:39 PM, Sean Christopherson wrote:
> On Tue, Sep 30, 2025, Dapeng Mi wrote:
>>
>> On 9/30/2025 1:30 PM, Borah, Chaitanya Kumar wrote:
>>> Hello Sean,
>>>
>>> Hope you are doing well. I am Chaitanya from the linux graphics team in
>>> Intel.
>>>
>>> This mail is regarding a regression we are seeing in our CI runs[1] on
>>> linux-next repository.
>>>
>>> Since the version next-20250919 [2], we are seeing the following regression
>>>
>>> `````````````````````````````````````````````````````````````````````````````````
>>> <4>[   10.973827] ------------[ cut here ]------------
>>> <4>[   10.973841] WARNING: arch/x86/events/core.c:3089 at
>>> perf_get_x86_pmu_capability+0xd/0xc0, CPU#15: (udev-worker)/386
>>> ...
>>> <4>[   10.974028] Call Trace:
>>> <4>[   10.974030]  <TASK>
>>> <4>[   10.974033]  ? kvm_init_pmu_capability+0x2b/0x190 [kvm]
>>> <4>[   10.974154]  kvm_x86_vendor_init+0x1b0/0x1a40 [kvm]
>>> <4>[   10.974248]  vmx_init+0xdb/0x260 [kvm_intel]
>>> <4>[   10.974278]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
>>> <4>[   10.974296]  vt_init+0x12/0x9d0 [kvm_intel]
>>> <4>[   10.974309]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
>>> <4>[   10.974322]  do_one_initcall+0x60/0x3f0
>>> <4>[   10.974335]  do_init_module+0x97/0x2b0
>>> <4>[   10.974345]  load_module+0x2d08/0x2e30
>>> <4>[   10.974349]  ? __kernel_read+0x158/0x2f0
>>> <4>[   10.974370]  ? kernel_read_file+0x2b1/0x320
>>> <4>[   10.974381]  init_module_from_file+0x96/0xe0
>>> <4>[   10.974384]  ? init_module_from_file+0x96/0xe0
>>> <4>[   10.974399]  idempotent_init_module+0x117/0x330
>>> <4>[   10.974415]  __x64_sys_finit_module+0x73/0xe0
>>> ...
>>> `````````````````````````````````````````````````````````````````````````````````
>>> Details log can be found in [3].
>>>
>>> After bisecting the tree, the following patch [4] seems to be the first
>>> "bad" commit
>>>
>>> `````````````````````````````````````````````````````````````````````````````````````````````````````````
>>>   From 51f34b1e650fc5843530266cea4341750bd1ae37 Mon Sep 17 00:00:00 2001
>>>
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Date: Wed, 6 Aug 2025 12:56:39 -0700
>>>
>>> Subject: KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
>>>
>>> Take a snapshot of the unadulterated PMU capabilities provided by perf so
>>> that KVM can compare guest vPMU capabilities against hardware capabilities
>>> when determining whether or not to intercept PMU MSRs (and RDPMC).
>>> `````````````````````````````````````````````````````````````````````````````````````````````````````````
>>>
>>> We also verified that if we revert the patch the issue is not seen.
>>>
>>> Could you please check why the patch causes this regression and provide
>>> a fix if necessary?
>>
>> Hi Chaitanya,
>>
>> I suppose you found this warning on a hybrid client platform, right? It
>> looks the warning is triggered by the below WARN_ON_ONCE() in
>> perf_get_x86_pmu_capability() function.
>>
>>    if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
>>          !x86_pmu_initialized()) {
>>          memset(cap, 0, sizeof(*cap));
>>          return;
>>      }
>>
>> The below change should fix it (just building, not test it). I would run a
>> full scope vPMU test after I come back from China national day's holiday.
> 
> I have access to a hybrid system, I'll also double check there (though I'm 99.9%
> certain you've got it right).
> 
>> Thanks.
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index cebce7094de8..6d87c25226d8 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -108,8 +108,6 @@ void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_ops)
>>          bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
>>          int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
>>
>> -       perf_get_x86_pmu_capability(&kvm_host_pmu);
>> -
>>          /*
>>           * Hybrid PMUs don't play nice with virtualization without careful
>>           * configuration by userspace, and KVM's APIs for reporting supported
>> @@ -120,6 +118,8 @@ void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_ops)
>>                  enable_pmu = false;
>>
>>          if (enable_pmu) {
>> +               perf_get_x86_pmu_capability(&kvm_host_pmu);
>> +
>>                  /*
>>                   * WARN if perf did NOT disable hardware PMU if the number of
>>                   * architecturally required GP counters aren't present, i.e. if
> 
> If we go this route, then the !enable_pmu path should explicitly zero kvm_host_pmu
> so that the behavior is consistent userspace loads kvm.ko with enable_pmu=0,
> versus enable_pmu being cleared because of lack of support.
> 
> 	if (!enable_pmu) {
> 		memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
> 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> 		return;
> 	}
> 
> The alternative would be keep kvm_host_pmu valid at all times for !HYBRID, which
> is what I intended with the bad patch, but that too would lead to inconsistent
> behavior.  So I think it makes sense to go with Dapeng's approach; we can always
> revisit this if some future thing in KVM _needs_ kvm_host_pmu even with enable_pmu=0.
> 
> 	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
> 		enable_pmu = false;
> 		memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
> 	} else {
> 		perf_get_x86_pmu_capability(&kvm_host_pmu);
> 	}


Thank you for your responses.

Following change fixes the issue for us.


diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 40ac4cb44ed2..487ad19a236e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -108,16 +108,18 @@ void kvm_init_pmu_capability(const struct 
kvm_pmu_ops *pmu_ops)
         bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
         int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;

-       perf_get_x86_pmu_capability(&kvm_host_pmu);
-
         /*
          * Hybrid PMUs don't play nice with virtualization without careful
          * configuration by userspace, and KVM's APIs for reporting 
supported
          * vPMU features do not account for hybrid PMUs.  Disable vPMU 
support
          * for hybrid PMUs until KVM gains a way to let userspace opt-in.
          */
-       if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
+       if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
                 enable_pmu = false;
+               memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
+       } else {
+               perf_get_x86_pmu_capability(&kvm_host_pmu);
+       }

Regards

Chaitanya


