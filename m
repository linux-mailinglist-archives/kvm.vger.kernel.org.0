Return-Path: <kvm+bounces-55026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4B67B2CB8D
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 264CC3BA209
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B098830E0EF;
	Tue, 19 Aug 2025 17:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0RpCDw+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33264285C8D;
	Tue, 19 Aug 2025 17:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755626300; cv=fail; b=Q+bwyWM7S5XxnxC3B8lP5Sr3SHYewfRef0SbEfVD6jiE0S0ECri36BqpKj+mDZ/kYcT366vQ1yEF2gIpOzQrcjTtcPyplFZISph9uygt3CqEELdolBVW1N+0sYj9leW1yegfBKV6PcBceNyzoLdBD7oeBTNZFqCjdAEJwL67WeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755626300; c=relaxed/simple;
	bh=gzIXxJ+W+z0QBnGCQJD163M6fZiX1XrO/RYJjr6lw00=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rUP38c9sUEBLW3ZFxJnr5/5nexcAGW9971fNNkk7XcxhGay/kaUSA40PPVhDZPLaHzMw6+WAOccYi86J1FumXvq7a6hkyFyN5K/p1y9Lq/f1QpXKYevFZJbhBdKFx6Ye06CpCUAzZObmbhnYfDJzODNGnpdGd+7W56in8AaBmB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0RpCDw+; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755626299; x=1787162299;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gzIXxJ+W+z0QBnGCQJD163M6fZiX1XrO/RYJjr6lw00=;
  b=B0RpCDw+KwIgoz3R16dE9ohO1yMcBATBg+dFwtFK4RBh/UJc5iLnYNPO
   b6W1k96/31HdrHRwB83Jq5am2N94tUiigwrx7haAijPwlvkNvRBqzfqaE
   DnfhS4nMJs54VVd3oPgp3CxwV2EbSOsHT0qmiTkAR0jzx87v4loHOvZad
   3k4RnTPhKOh5FsJgkByEkKDjr2xVY6MhezDB9P5Oo0Ylf67drNIeHz7U/
   93hW+ZoiG/Nexgo/ZZuEdvp9FyPGjht5ky4MNAoI9gwojiCmLADNW5J2n
   XOzTqHwc3L9N31i615huB89GhdA9jM7OySOSFvuulXzrDP5MSYJwVZu9j
   w==;
X-CSE-ConnectionGUID: FonUpe7bTpyWF8+CR2fHBg==
X-CSE-MsgGUID: VVYl8C14SHiYvKNy2v9EQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="45454176"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="45454176"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 10:58:16 -0700
X-CSE-ConnectionGUID: yf645v4pRFuoHVbAcq8esg==
X-CSE-MsgGUID: 8YR0Gd4CQC6UraGn6fcPYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168327469"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 10:58:16 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 10:58:15 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 10:58:15 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.40)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 10:58:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZIE31/PCDDhOYke13EQDXx5uSoGDQeJVACbNrqA1V09+vtHF119WL2tFR6r3L2YjyOwLkO6RwWsnfDDuh1Ll1S5xJpTakqfTewwm/uSuObFwjtgyC4ucxJwoW1b9Uk8Chkn+FJ5UoFUjO4jamvzFM0nXnJU7XC9r3bp37ZHjnBpFseW5tYbTPdPWA6lbNGxF1apXxmH5PGYvfKjMTM/vjr6Fvvpa8KprGlU6dKgqBESPSj5oRnvL8tGoEWwrOmXSTN8nPlWvsXCffp+DjM2CkLCh2uoduHSRcNovpqRm8k8t7yDq10on7N+Fdd4+NIZD72cBQ71Y+H32EFi7dVTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvjNtLETlSrh1PMS53kt2dRPoGOetdM369hns5lHyw0=;
 b=FzRAjCIDAxPzbCz4mdq1n42n1oBRz3Qlpky/OQOsvBnVpEzp9BRXRPmwb0rp16px94aiIi5FOubmXT7JucUV2XOf9b6quFLd7kFJzJhjyOpED3Mnu5N2UjP6E69ssta2Vh2mDsT8uf/HOFxOTQzjyGq9O0ac3WQEsn8+DEp5LHzfl8e2vP9G3m4QhKyS89mr8cKEA/XjQrKYTySKeccF9R9Ek3/8toHNNVhiHcT2LKwxJGpXVzreAdZPkZ/F7Dnv+DUMxJ5YcBEVpkWnctbZW0qlnEqaEDykjdT8MIsuGnHVQfCrgTWYl/TEXMZJ2WBfyCR3yaZX7lB4bAmj7bj4xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by LV1PR11MB8818.namprd11.prod.outlook.com (2603:10b6:408:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 17:58:12 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 17:58:12 +0000
Message-ID: <4b8b5c89-e8b7-4eec-91eb-1fe43a68cf9c@intel.com>
Date: Tue, 19 Aug 2025 20:58:07 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
To: "Luck, Tony" <tony.luck@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <vannapurve@google.com>, Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	<x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, Fan Du <fan.du@intel.com>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819172846.GA578379@yaz-khff2.amd.com> <aKS5ixhgtCYIvErL@agluck-desk3>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <aKS5ixhgtCYIvErL@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB3PR06CA0002.eurprd06.prod.outlook.com (2603:10a6:8:1::15)
 To IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|LV1PR11MB8818:EE_
X-MS-Office365-Filtering-Correlation-Id: 7517307e-1fb3-426e-500a-08dddf49f6f8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZEJrNmJraEZSL0RGQ0FyWk1iOHh0dkNYRlIxY3BrNU9BSWNwS09vejdjRmtj?=
 =?utf-8?B?dk9XWlFhdmtaUUNnOS9JYmN1cHVuS1dHek93czlVd1BMQzJEb2c0QTUySTNX?=
 =?utf-8?B?ZnUwU3AwT2pvcFRLcVVLMEswQThOOXdVS0V6a1ozZUZNTGNnY2tnY2krRGhS?=
 =?utf-8?B?WWtFVEI3cUoxa2RPM2tHQjVOUjJORUxNcWZreWpka3M2V3QxaVl6WkJaNEJV?=
 =?utf-8?B?aW9uN3BNWElOZ3pDT2lHZVcrZlh2NzFoNk82NVhydHZ4UVlFYVVmdkRrUjlt?=
 =?utf-8?B?MjdWUmZ6a2dZU2NaOXJoeFJHUStuSm8xR0s3Y2ZLSFZ0dlBoNHlva2VMTU1o?=
 =?utf-8?B?VFZQbktzRHJKYnd4bGNrTFd1LzBLNjVTbVBja3RZWlhKREY2a0VucDNvenNy?=
 =?utf-8?B?eWNxYjFHak96ZTMwOWF1dFVKc3R1b25iNzQ3UjNRdlJUeTc2Vzl1TGdVN3VF?=
 =?utf-8?B?ZU9RWXovMC9VTWdLZTFWZDZPdkcrZGhVZmpaeTllRklVTUVmcTFtVUtOVDl5?=
 =?utf-8?B?YUtBcUNKZitvL1ZZODFVN3JsQk5SUEl4YVgwdWg4Z25CT2pmSnl2a1NJTVM1?=
 =?utf-8?B?UVNqMGpydEprSW5QV0R2QlRnQng0UzVIWEZocXNLWjdDZmlkOGZKRURRMkZy?=
 =?utf-8?B?bFM3Q2hoU0Z6ZDhwakFqTFByWTY2QUIxbjlnVEV6T0hiSzhFUzZlaS8zZEk1?=
 =?utf-8?B?MjVhV05xK1VFUUxqNDM2MWtPQ3hNL0VTK2xUbUk3bGwwc3Zwb0FrK1JVb2JT?=
 =?utf-8?B?b1pUMzF6a1YwTXVRUkZ6MWxOS2Y4c0NpMVo2d2FQcmtnOUFsNDRjZjdmY1Jn?=
 =?utf-8?B?ckJjWWtFV2M5RnNEMktBY1p4aFloZnEycU1BeGkzV3RyYjZrR1g5blRWa0FI?=
 =?utf-8?B?SGc0VXVWZzBFcVIvQUwvWHJBM0Y5UHhKd2tXWjV4S2pjQnpFTXlsUUZmNTd4?=
 =?utf-8?B?WFZad2hGdWRIblJ4U0M1Ykh5VUE3UGF0K2ZyV1QyQU8vTFpZbUVCZkF5MlpD?=
 =?utf-8?B?bWhmOS9EQkZFK3NTcStDdXZtM2tqTFVoTmZQaDQ1UnlMcGU3NXFQRmkwQWN6?=
 =?utf-8?B?UzBrMmxGcFY5WGhDZlR6WExqWSs3d09XZHl2TWYzNDd5ZXJibnRSQVJvL0lD?=
 =?utf-8?B?YWlra0dqNnRoalJSNk94YzlodktMNmxyRDQ3SVlxcHprdmpjK1lvYlhESEZq?=
 =?utf-8?B?ajRkYjByYXZDWjJLTndPcmY5N1Qwb1l3M25TSXozUHdRVFpXWWRWVkp6dXoz?=
 =?utf-8?B?bTdvNU5jVExROElaL1RQY3RRcklpZHpVUGJoT1B0aGYrWFlzZGpuSTZKYlFu?=
 =?utf-8?B?b2k4aGRGQ2hBNlZQY3phRXozUkNmck5icFFEM0Uzd0pSU3Q5M0pHbWpqVGJy?=
 =?utf-8?B?UUJ6WnhuMktWbkl3ZXN3OXVFb2YwazlJWVhxSDZiTU16NjZxY3hQejFKdGtR?=
 =?utf-8?B?TXdYSmtTZDdGV2NwSG9zcElncmwwVGxWVTZDcUppb3pXTnc0ZVIyRnVRMDVr?=
 =?utf-8?B?ckozZ2g2d0M3YkRrSloxZlBNTDNIN3JnbVdBaFJld1RLUDVKdnJCV01abkRk?=
 =?utf-8?B?dDl5aXBkMzFHMFpmWjZLQ21uZGFiR0FMQ2Rpc0wvNDhud3pob3MvNTBDTDN6?=
 =?utf-8?B?OGMySEpjemJmZHdsZWRvUnVwTUdsb3VWNTVNRFVpYWVIRmZjV0R0Q25BQy84?=
 =?utf-8?B?NGJJWFdLeHZJcTBTK1ZKZVdvUW5QU0JYUGp0NU8zdHJHTkFsaU5tekZsODI2?=
 =?utf-8?B?NTdIVlpydHJXdkN5TzZJYU14bWZjS1dJT2U4MFM3aE9OSkhKWmdtL2hCV1lS?=
 =?utf-8?Q?Qa5SH4H11gcZxSziz5UcjLY/95+nK3TFHe0OQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTdEOVVwUnFuTFhYMHVJNlpsZzZLaTNOTlBVcjFxalYzOXJwRVRyM0JjWmdH?=
 =?utf-8?B?MDNZbkFIVzd2UVZlVzZLcTZnbVpnQWlLck9tOFBGY1FhellSTEFJWHNvcVVp?=
 =?utf-8?B?N0dkMDN5M1lWejMrKzF3NGNDQk5Ia05FL3hZaVEvYlJLcVkxcjZPdkcwUWZy?=
 =?utf-8?B?OE56dGFVNmJoSTU3bkdRUmsway9ZRmlMay9OT3FBUXliVzN3WmhwNFBCOTIx?=
 =?utf-8?B?MmpoWXQvNkV5MDVUeFFIamtSSThWbTNCYjVxWkxaOFBmRkVzLzc2UFFQakkx?=
 =?utf-8?B?M1k4aTd4RzRQbWpGdmRORWxJdURmbmxhek4xRnR4bHVDeTY2V05CaWkvcitn?=
 =?utf-8?B?N2xCZXVzaC9FamMwVDg3ZGJZVHVGbVkrRlhwTE9lcHFSWGFOZnYvb2hrM0lo?=
 =?utf-8?B?eEJvejRMc3c5TXpDZW9SdUhNL3U3K1gyVzlxWXU3R21QTVF5T2wwTkxlTDBk?=
 =?utf-8?B?MDBpcGhlTmpEVVowYWYwZTBPSG9hSlIzWFhianNLTEk3dEJPRjA4NUc5L3Jl?=
 =?utf-8?B?c3I1eVlTNDRuMllhT1Zaa2pCOXZVVGxWS0UwaGRSL0RMcDlueGFZUFJFb0xM?=
 =?utf-8?B?WEFCT1F6bCtJTkRCN1ZUTFhtKytxL2FSL3RMV2VvTmY2K1JaZGlqaUhmNmdv?=
 =?utf-8?B?d2dMZTA0Tjl1T3FJTEt3eHJsMlRFQi85cmtGR3JGK2JJSzhGcThHMG5hOEph?=
 =?utf-8?B?aHJyQ3RpZzRndEVpakRrWnJuMWJNcjY1dVZ4QkpJa2l3TmNhSWhncEswYVdm?=
 =?utf-8?B?R2tEZTk0VkVaT3pmVWtiUVRXdURBUVlrY1h3VVBqVmRkaDcxZTQzWlRnVkxp?=
 =?utf-8?B?TVB4UWRpTy9vbFM4QkpaUjdDOUlmRVdhVWdwMThrOWNRVXhMZU9qYjJJVEVq?=
 =?utf-8?B?VDkyYWtuY1pMV2pxYkR0bGZKV0NLd3hMNzBjTjlRYUVSeHA4WjN6TE5rRDFj?=
 =?utf-8?B?cHdQOEN1YmRCazUrdUo0NW5HWkVNbFExWWRURS91Ull3d2ZiaXNhbEpsY2Nq?=
 =?utf-8?B?bktpcnFZN2dBejZSWGNXbFhxTFl2SDdkRGdZck56d1d5VmhEaktKQy9lZlNC?=
 =?utf-8?B?cllQVGRheStBVWhud2dGVksyYlBWams0d1FvQk1reU9vS0RodzVlZlMwOVFL?=
 =?utf-8?B?Y0V2VlpudTVobVBtV1lxZW83cmhwRWY5dXlmelBwSDN0amROL2JlM0htbXhM?=
 =?utf-8?B?MHRmMFpEZDRqdXQ5WnBJTTBFREx4U0FwSFBFd3ZZMVpVdXRFeXEyUEFlSWFE?=
 =?utf-8?B?SlZpQWJPNDVGQUJMKzl0Y0NKQWhDVDVrbnpvYytPQzJ0bkZtTzVDNEc4bkhr?=
 =?utf-8?B?SUZMUlkxLy9VbzdiV2Zrbkw2NGNkQW9qcEdhME1NK3lnamgybUxqMkRPZ0Jt?=
 =?utf-8?B?ZjhqK2NnZC9NNzg3Nlg3ME5JTG9yaEJGWEVCMC9XVEllRTJJZDJET1cwYUk0?=
 =?utf-8?B?dXdSekVuRVVtNks1NTlORy9HdUdKalRoaGxvZWFWaXliaXFqV3BObk8zbXRQ?=
 =?utf-8?B?Z1g5WDhjMGp3WlBkSGl1SFVkZXpBMFJ0TzF1Rkd5TnpKVkJFcUNHVHNkRXYw?=
 =?utf-8?B?SXEwdmN3VTJSWC9NVXVXa0tYOTRRSU9WQkFFbjNqRlBUK01YSVExMVgyNXZD?=
 =?utf-8?B?THRSVzl0QlJmYjVDcS9RRkpaZ2FQRzhBdkJOZW1qVXZXOWJJdGEwYnphUkJU?=
 =?utf-8?B?QjBIYWRVWC94b0p5QnNjSElnOHZyUG5xQldoRnFFNkFKQnpiUkI0VTZyYmUz?=
 =?utf-8?B?SE5WZ0RZWS9BQ1pTWk50cFFyNjYrdXFpYjZLM1c2eStoK0lnamFYNFdvZmJu?=
 =?utf-8?B?dUtXY3hodHRUVzdCY0grVFFpL0tmK09Ca2FRYWZrMFVnVm9pUFRsNjhETENi?=
 =?utf-8?B?MzVoQ1FHUDRrSExLRW9keXp6L2F1eHM2WU9uQ0VIbmVRcFNTd292d0YvUEJm?=
 =?utf-8?B?T0h5TU5Ta0ZvYW5FakZhYzBvRnBZS2pTanRUSTNrVGdzMjNqVm9rSzFmSGFZ?=
 =?utf-8?B?VnlUc0F5NEVwd3ROQ1RTSkVSODdWdVduQjJCa0xJQnFQYlB0ZS85dGY4WjVW?=
 =?utf-8?B?SmJmcm9iN3E1QkJZRVhha1dLb2kwc09VNjg3ektrSC84ZjRENFRkKzN1NVVC?=
 =?utf-8?B?Q0dFVkJvRXVzTm9JWWdxOHdFT1NqMXY0R1lWeVRicVNpVkJGcHhYeVdrUHVV?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7517307e-1fb3-426e-500a-08dddf49f6f8
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 17:58:12.7440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6ko3bQB8/CScvF6ulbbph+QqMK9EEFO1cg2if6ffC2Mtx7RMkHBwdAk7UsW7678DTaWJYzNkgEWpcNDZ/Jtgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8818
X-OriginatorOrg: intel.com

On 19/08/2025 20:51, Luck, Tony wrote:
> On Tue, Aug 19, 2025 at 01:28:46PM -0400, Yazen Ghannam wrote:
>> On Tue, Aug 19, 2025 at 07:24:34PM +0300, Adrian Hunter wrote:
>>> Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
>>> check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
>>> valid physical address bits within the machine check bank address register.
>>>
>>> This is particularly needed in the case of errors in TDX/SEAM non-root mode
>>> because the reported address contains the TDX KeyID.  Refer to TDX and
>>> TME-MK documentation for more information about KeyIDs.
>>>
>>> Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
>>> non-root mode") uses the address to mark the affected page as poisoned, but
>>> omits to use the aforementioned mask.
>>>
>>> Investigation of user space expectations has concluded it would be more
>>> correct for the address to contain only address bits in the first place.
>>> Refer https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com
>>>
>>> Mask the address when it is read from the machine check bank address
>>> register.  Do not use MCI_ADDR_PHYSADDR because that will be removed in a
>>> later patch.
>>>
>>> It is assumed __log_error() in arch/x86/kernel/cpu/mce/amd.c does not need
>>> similar treatment.
>>>
>>> Amend struct mce addr member description slightly to reflect that it is
>>> not, and never has been, an exact copy of the bank's MCi_ADDR MSR.
>>>
>>
>> I think it would be more accurate to say that the MCi_ADDR MSR is not,
>> and never has been, guaranteed to be a system physical address.
>>
>> We could introduce a new field that represents the system physical
>> address, if one exists for the error type. This way we can operate on a
>> value without assumption or additional checks. And we can keep the raw
>> MCi_ADDR MSR value in case it is of value to debug folks or hardware
>> designers. In my experience, they seem to appreciate having the full,
>> unfiltered data. We don't give them that today, but we can work towards
>> that goal.
> 
> Having and exact copy of MCi_ADDR might be useful. I recall some angst
> about this code masking off low order bits:
> 
> 		m->addr = mce_rdmsrq(mca_msr_reg(i, MCA_ADDR));
> 
> 		/*
> 		 * Mask the reported address by the reported granularity.
> 		 */
> 		if (mca_cfg.ser && (m->status & MCI_STATUS_MISCV)) {
> 			u8 shift = MCI_MISC_ADDR_LSB(m->misc);
> 			m->addr >>= shift;
> 			m->addr <<= shift;
> 		}
> 
> this proposal masks some high order bits too.
> 
> I second Yazen's suggestion of a new field. One for the raw value,
> another for the massaged phsical address derived from the MSR.

For struct mce?  Maybe that should be 2 new fields:

	__u64 addr;		/* Deprecated */
	...
	__u64 mci_addr;		/* Bank's MCi_ADDR MSR */
	__u64 phys_addr;	/* Physical address */


