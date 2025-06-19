Return-Path: <kvm+bounces-49995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C8EAE0F0D
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 23:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDAC91791E4
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 21:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1451425F995;
	Thu, 19 Jun 2025 21:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JShTggnl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CA230E852;
	Thu, 19 Jun 2025 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750368921; cv=fail; b=AqgDlx0YcYyBukaZj/c+3HrvaAVBxtiPOgqKu9x21erQHAgYnUVEYQoG5Wwsv2sRlU69BuO4vV7DS1bHlBL6CNyBT6W16MLClDP0YsALwvzYoB3BOCj9ZFLkDUFgmcwmM3TPh5oFeyQfjClYfKI9t6bQEeArpiSd83B30j9C6hE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750368921; c=relaxed/simple;
	bh=RTi/WKG9ljrfmsR+Ip6dvb8OU4mQeewvxs47v5YO3vU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XXULANOV1qF1KH3TIiLFCppVO4Q+tMGJrRsaWjGEsiPDneDlaG+YtPKWVTIePPKg1lcxHQElmDPlUTYrbn9o8xTgvpDE7twjJJ55ElgzvGNgWTHSYraflxBGxva34XvdJh5oWIaigrFEgo5Oh2HHiQMVP1UYg2DR1OiRqG4qDF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JShTggnl; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750368919; x=1781904919;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RTi/WKG9ljrfmsR+Ip6dvb8OU4mQeewvxs47v5YO3vU=;
  b=JShTggnlSg3IeUdYAXgo6LbL+IpWZgwHVgb7jKEENoxeDSqJf5sIOmu+
   ChyHHEninw+EL4qkLeyBtorMI69chcKmceLWqlXBGzJfnbldZKxdITAmp
   Kul+kyfbG3F1jMt2vAn+gEo21bHi+TOukcm/Sl348dHX7yGsV+tpEQgIj
   WRmJazMHHoAYq9PHqz8bDFka7USU2zRUf7u9XZXCZP8El8z2lNXeHethe
   w81/qMBo/1kEPGEufAtj8Ww358mkuuq11wLllhS9RqmM6D45m2cel5hku
   AlbexGa28o7iMcvakYBXQprTOlj/jgxsjnKpzx1FtkVuu+oA/W/vt7UUD
   g==;
X-CSE-ConnectionGUID: p1vUHhGAQF6WO3HRMliHqw==
X-CSE-MsgGUID: TLx/JE6LQvmr3BwG4YAUTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="55256030"
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="55256030"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 14:35:17 -0700
X-CSE-ConnectionGUID: ApWdRf8vSTCyvvWd5VeCmA==
X-CSE-MsgGUID: QZHYgceETfer9nih/MdyHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="150878218"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 14:35:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 14:35:15 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 14:35:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.42) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 14:35:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UaUxfETqUz9v7YjcxZId7bj8RgEV1d1DvxoKqAnV3GOXt8Aa0kyCRZeu+Yr0nXXp9Th10QV8b3aaE7ilqDYeLbQLIv4s6sXvs8+8VVmp9OzPOQHoRMN8dbEEg4L5NaLJByFihfxc+W0QidK3HoWd9ciEEnp7QisirIOaDUz1gtJ6QYZI9N46Q8654raHLMiw94MN3wwaksGQ5VxxzK5v3Bwla8n6O8M8U9yfNRAmR7hSyOPr0M2gf9rU1A2Ypb+EWviM78AcJGgnSn7pCpR8oYZJrkE/7MfrAowEftPNqQ2xkbAtI3cRjZwMdwvda0M/5Pjd0w1D86Fu/SkVLlhy7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5azNgcWCljVbJdSANLt9JW+SRWtS0n2U+eyfqIh25CU=;
 b=qoRINbTz69qf/53f6qISp18rGy7idxTpoOgBPce7jhMRe102JvSEXMHf5OrBc0vgJTHxaufuVyaEd9M+4pWJi408oUTgSyu1dTip/PMVtFQMkOps3rkwRwUaiFQp06dXbEuYXpeOT3CPtWtS6kwQW9b0PxNllaroyFefN9iHbwzVTTjjcGak9xoXAqDgJRS8UCgxAQ9zLiDqauzrhKgEqhEABPKabcu6Tjw4UT3juK7O1IR7mNneO8kESSh1Z4U5BVfsGHu36OAbgqklsFMN9bd4NM9xxbpw1MpjRyKBWOHeGwTeOjGyuGIxzf9IW2Sb8oxYohAz89P2Tlm4Ppp/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SA2PR11MB4796.namprd11.prod.outlook.com (2603:10b6:806:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Thu, 19 Jun
 2025 21:35:12 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 21:35:12 +0000
Message-ID: <f1d512b0-2a98-4224-a299-5dc1a3a56f5e@intel.com>
Date: Thu, 19 Jun 2025 14:35:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/10] x86/fred: Provide separate IRQ vs. NMI wrappers
 for entry from KVM
To: Xin Li <xin@zytor.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson
	<seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-2-sohil.mehta@intel.com>
 <0862970c-ab84-4b08-b9e6-e5d04bfd13e7@zytor.com>
Content-Language: en-US
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <0862970c-ab84-4b08-b9e6-e5d04bfd13e7@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:303:2a::21) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SA2PR11MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: aa7d91cd-b141-4938-f963-08ddaf792c13
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3A1U3NTeGhydk94QnJ5aG9ZOFZVM2h4ZkUrcWdrYkwzVFViQzY5bnpKREFW?=
 =?utf-8?B?Yzd6aW1kZUN0TFhCNlRoN1FIclNOYVp5L3dtOERvdEZtTzVkR01KcEdwejdF?=
 =?utf-8?B?NDA3cllYdTNlSlUrekxncjk5Nyt4bVEwOTZ3VXExOEM4VjlqVVlrNkFIV2FF?=
 =?utf-8?B?Sk5RbUZUSUc0R0RmWW11RU53Tld1WCt4Q1kvWmlkb0RmaEc1T2VwZlg3ZlZk?=
 =?utf-8?B?SWRCZXE5R2ZUYU5VQllodTdpU1U4ZVUxNDdJV3FlUmU5MzVRMnEvTi9vS1d3?=
 =?utf-8?B?bzRKMWVyZ0p1dVZuSVN6dFZFMTV5blpTZ21vdjBRNWFYbmRiemgrRFJ2VWlt?=
 =?utf-8?B?L1RQZkx2WGZXL2dUWTJRTzU3TWRnRmdBME9CZVJuRnR2RXphUkM5T29XS1RJ?=
 =?utf-8?B?TVBoQ3VBd0xTZEgwYU9FUXRZNzdUeFptZmJnS2h1SzdnWkhWY01kMmpFcXls?=
 =?utf-8?B?U1dTZGlHUDR5M3R5Mm8rbmo5S0R6QXMrcThBSnhhQ1RkMmN4M3NiVFA0UXRN?=
 =?utf-8?B?M1p0V3hpMmhXOVNSMGJQSG1FazlveXFNUkllR2xUNThzelVZWHJINVhLYzBK?=
 =?utf-8?B?Y1pjOGcvdVhrTzhpWkZseHFjaUZqYzZwcDR2S1krQ0RQM0RxZENCMTNxUU90?=
 =?utf-8?B?dlg3ODVrN2xnR3Qxelo1UE5lUndTcmdRUHByMlFpYTdCbHN1aytQUkJNV2d3?=
 =?utf-8?B?UWFYOHZSdE9qbE8vUFNZemxoY3ptSmtkY25xTUtKbmN4MEw0ZDJzS21iaEVi?=
 =?utf-8?B?azBXcUpNWEVSVCtjZjNsYmJ2QnhrLzlzRC9JZXVDTlVSdnFCeHRZSVZ4SUJK?=
 =?utf-8?B?MDMxS1hMRmRhWUQyQXpRbWo4Y3hXa2EwVTNFdFd0WGdZU3BIei9ORGZjV2Jl?=
 =?utf-8?B?NzNqZzF3eTNpcm1hYmRrT0ErY0NBQWhpVW9yMTdlSDQ0R3hrWURCY2JXTVZp?=
 =?utf-8?B?ZUNiaytjdzMwcXNZRUtDWDBTYTBFTTdXSm9JRmRKdlphMmh4NXB5QU9jSG51?=
 =?utf-8?B?VVJ2UWxxazVmbThxdVlVelo5aUNyZTFHaTdYNldBTFpUcm9TcGNUK0grVkx2?=
 =?utf-8?B?R2VpOXJQR1d0Q3p2aFpadUNhWDJ1RThwdEdSNU11KzRiWkVwbmtLbVh6MXBP?=
 =?utf-8?B?NW9nTWFyWS9TZ3plTzZLY3J3dU1JZFgwRVVhbEpuU3luTTY5a2s5TTZob056?=
 =?utf-8?B?RG5pd2NBdXVZU2JPNlhjSTBuc2dHOWtSNG5tbCt0a0M1bFVmcjNuY1FoMVJ3?=
 =?utf-8?B?WmFCd2RjVWY1WjJsTVRueGRGbjRmZGVNeVZXMEFldnc5Q2JqK0w2dlcwRExP?=
 =?utf-8?B?MWpiOEF4Y3dSZ0IvSXpJZTFzOVVnNG5MWXBEd1dyQVFSSTNqSkhVbzA1aVd6?=
 =?utf-8?B?YnF3eW84Qk14MC8xcUpOKzE4cDhQejljTFRRK0g2Y3JvclFESkV2WGZFUHY0?=
 =?utf-8?B?R3ZWdC9xbHBQRWpldGF3MEJKWEVFd0l1M0RMZFpMU2E2NTVrR0duajYyS2h3?=
 =?utf-8?B?bzg1WExDMzI3enZ5cUlNRFU5aithbnhhOGdEYjVTQ0lGWjFvcnBoQitOREdz?=
 =?utf-8?B?VkVwZ0hJbmVJUkVWQjRIak5aMzJ5cUZOczVhNnFKU3d0a1JRTzdnQUs1VXR6?=
 =?utf-8?B?aXlyVkF0bkdDbS9vMmFjTmE4Qk1tak92MmlnTWdBSlpXUkFZK3hibW1tTSs3?=
 =?utf-8?B?V2dGM1kxbXVwd2tNVFNhME4rWnZnaW90Y01iamxnOXpTOUR3b0FlazcvWllt?=
 =?utf-8?B?YjBzOUpJQmJEQVMxd3VqOTQzOWpBdHgwMmRZdy9FNmx6aE9ZV0VNQkxxS2s1?=
 =?utf-8?B?M25rRE5OMHZydVREZ1BqcnZnTkgwNGE3bWthWkhqU3ZtaHJJN3pXdWNjYmhq?=
 =?utf-8?B?Q0dlbTZISndxc0kyT2grTEVISWVSdWVUZ05meW8rL1JNb2lOWUpvejVVaGNa?=
 =?utf-8?Q?5mCmECkV4YI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YklPY1RmVTUzSTFhZThoZTZUS2xwbU5CaUJqaG8xNXFOYkVmc1VJa0E4VEF4?=
 =?utf-8?B?clhCQVVWOTNJZWROeGIxUFJ1UldoSHdNano0ZlV1cVdYR3dYSVVtQ0hudXRs?=
 =?utf-8?B?UUxHUnJ6YjNKcnJhek5KcDRSa0VDZVplSzBOT0xqOUFiZmZDT3pvdkZZV3cy?=
 =?utf-8?B?c3JTNGVENXRqWXlUVUxjRFdQSW9vY1hubGFCcDlxS2FqZXRodlNXdHdTTWJD?=
 =?utf-8?B?aXVMbWltNTJGUTZhVGw4UUVUTmtZZmJYdGtrdXVZaWg0NGlxWC9RZC9yTVFZ?=
 =?utf-8?B?SVVtR3JsVHFHUDJtemwyVGRFV3RjdUxGalh3cHN4WHlRdTB2QTBiWklQV2dC?=
 =?utf-8?B?OFM1NHdlSmJiZkd4SUNUUWgyNklpK2JMTVBHMDdZaFlIRmU1MDIwMXVNREVh?=
 =?utf-8?B?L1p5S2M2K04zVll4T21ndGdaREt2b280V1YycDJiOUp1SGpVY2FOS01GTVBT?=
 =?utf-8?B?OHIydHMrdDh2Z1Z5QzcwY3ZCaVIxVGZQa1hLM1pwNis3QVhnNTAvb0RHTzVi?=
 =?utf-8?B?bnIvQ2lqR2J0N3I5cXk5SzQ2QkNEZUhVbkFoM2hBY0oyN1hSRXpnN3c4Zit3?=
 =?utf-8?B?OXJmZnhFVU5YZTZXRllBdGdWY3hLOVhISDgxeVFNYWwvV0pMUnBpNTh4NGdw?=
 =?utf-8?B?SjBIUy9Hdk1JQkZFN3RKb3Z1L1NyRjdENFRocWhkQzFKbGpRTXMzc1JxaDha?=
 =?utf-8?B?eHNjanRpSUp6R0tnZ29HNFRwVG1hWGNXelAwNWgwWVh6N29JTDJqV0lXa3M4?=
 =?utf-8?B?QzRhQmFTcVNRTzRodGs0REI3alJ3elFHa0RUSC9jZWpJQWJOWHRNVGlSWDFw?=
 =?utf-8?B?ODhrTFY2OHpwMUtheHpJM3JSb2htZnVtZlp3dThkMnlRenJicDU1Z3h5SXBl?=
 =?utf-8?B?alJVMXBqK0IwQTFwZ2pxZ3BBUzZZQXhHM2xjK21zOGhtcjA5MnYwL2RDRDVK?=
 =?utf-8?B?bGVPYjZlRHVpWEZkRUNOWkJxeVB4b1dVQmZHZGlRSDhjdWVuWEdUaVhPd2JE?=
 =?utf-8?B?QzZMaTRsZGF4SXREOUh6RmJkVnJaY1BXVVIzblVBZUpwZVBOSVV3VXRxZGFX?=
 =?utf-8?B?NXllOVFuS0M0cXVvOXVDa2lpMG9oUHROcStrcnQ0Yk1rZGFUclc3MjZ2RnRq?=
 =?utf-8?B?RTJDeUpUenAxWGFqSVQwZDA2T2NkSEEwUlRhc0lVY1ZtNTV5a2hqWG9rWnJP?=
 =?utf-8?B?VE9qQ1dpYTROeUN2cCt1ZVFlNjQrNklObTFqT1k2YURPZTlrL09PWVJGNThW?=
 =?utf-8?B?dUJCVm1kTWh2S05rUjdYMG9RanBRWDQ4ZGZBd3JMdmxhMGc2bWZjYmViZlIx?=
 =?utf-8?B?MXlEeW1CNGt3b2k2YmtBWk1LbHpRT0FwNktybWlsUElDUmZzWDNQL1JaQmQ5?=
 =?utf-8?B?cktEQStEV1IyZVE2bm1rNDAzWjRrb1RPdVhUTE1xTTFadU00TFFVZkVXREhy?=
 =?utf-8?B?YzN6MjREUSsxK0J0bkd6RkZHRDkyd25ydFZuR3drMGxjVkw1UVovZHk3d0kz?=
 =?utf-8?B?YkFObDFTOW1mMGZ1L05XMUN1VXJJTlpKNE41dTNwYTNXbXZIUDJyZGZXZ29m?=
 =?utf-8?B?ZkdXK2FUWkVWQ3JrYnEySzE0eXVLUXprb055WFMra1ZUS0I2NG1HdGk2ODZV?=
 =?utf-8?B?VnM5N1c0ekQ0amJWS0JHbnloMlVQaEt4ajNRS1AxSGNJMUpDaHFxdDNHVWdO?=
 =?utf-8?B?NDJJczh1cXRvdXFuMll0ckZodWZ6WnBDM2cwT2ZhaVhkK2N6alRFdURnQ1Bn?=
 =?utf-8?B?WlQ1aE5kTWsvRjR1NWNCYnk0UXpnLzBNMnNvQlk1NUdIQ2xhQ0h5dnlqM09l?=
 =?utf-8?B?Ulp2VGs1TzZIVENiWmZXRDV3eDVWVko0VzBMWkE4a3VHUWVqUzdaVFJ5T1d1?=
 =?utf-8?B?VHZnOGRBdkhNdGpwT1oxK3p1NGhuNWMveFhsYTJRazlaVE5jelU0SHl4c3BL?=
 =?utf-8?B?TitxbkJDYnhhKzNTTzBxZzFMT2dUYjRNS0thdmd1Q1VuaHkrY20xZXRranM1?=
 =?utf-8?B?TWxnTmpoV2hJNHdtNEpRanNRSnBvZnBKSVhzQUpYeGlZSmw2Ulg5UVRoUUV2?=
 =?utf-8?B?L24renJCSE1oQzUxeHZKMG9LM2pOQVUyMmtNeGN0Z1hjdGVScUhtN0pmMGxK?=
 =?utf-8?Q?29Z/FszJlsVZ0nSnwTVQ3UYSz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7d91cd-b141-4938-f963-08ddaf792c13
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 21:35:12.4859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7TlrERF0gbTiAUBuh8Y6M8diC+uu3K4OCYWl8xoUIP50omyGpYL71OELa9apHAFJ0iEbKFVxcKTS93ZPlNAhvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4796
X-OriginatorOrg: intel.com

On 6/18/2025 8:53 PM, Xin Li wrote:
> On 6/12/2025 2:48 PM, Sohil Mehta wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Provide separate wrappers for forwarding IRQs vs NMIs from KVM in
>> anticipation of adding support for NMI source reporting, which will add
>> an NMI-only parameter, i.e. will further pollute the current API with a
>> param that is a hardcoded for one of the two call sites.
>>
>> Opportunistically tag the non-FRED NMI wrapper __always_inline, as the
>> compiler could theoretically generate a function call and trigger and a
>                                                                      ^
> Nit, looks to me that this is an extra "and".
> 

Ah! Will remove.

>> (completely benign) "leaving noinstr" warning.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
> 
> Reviewed-by: Xin Li (Intel) <xin@zytor.com>

Thanks

