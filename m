Return-Path: <kvm+bounces-45764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A274AAEE86
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 00:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9C674E28BE
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 22:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C45290DB5;
	Wed,  7 May 2025 22:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BBC85gst"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBB21ACEC8;
	Wed,  7 May 2025 22:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746655847; cv=fail; b=K+F0my4+QnwJ9rAfnDZeLCeF9cCuceBfKWicxz9vbIPh1Imze1vn/Y+PVP4+zJyYPhniI0roSE7hQ+AIFeR3S3LRqapkckE3kd1v3S17eXhoDBeJ67VrWIQq5lIViZWvhVYOogf8YRabsTCX5DqpVs7GwwpFHeahT5a2h4xzgVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746655847; c=relaxed/simple;
	bh=XXTMVDHY6qt+SXENvEL+uNgsPy5KbTNfSxac2/5iHM8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VOHNwEqsc0HIZ174j754XNRumkBR42VqlMP2bOSURCl6wjz3XuE9o3Fbw41NPWwgf/nGaP0Gycu5A4ndPbmLFrFF3C7lraywxI9M4DzppZi+rXdxZs94Uhw9C3SHxqyajfh/Yq3/xNTciTwgcMA6bAKWcAKvqkr5O7/LFhac0UY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BBC85gst; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746655845; x=1778191845;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XXTMVDHY6qt+SXENvEL+uNgsPy5KbTNfSxac2/5iHM8=;
  b=BBC85gst47loGZuzucOFDcufuIP2teoV11PkHVG1798Dn5G+QZriSFhw
   c0OYSfgdyd+l0f8Ss9bDCUYSaUWUf4w5cJ2BhzdK5nj/vtUt9C43Bsnfx
   jEgkl2suZh7oUNzPkrw7DJPKas+j7gLHrNGQUuKDJluRejo57ietOcDk6
   EES4EFlVIF8M1xcWQ110Nxmlj1EQbCPKS9ydyYD5kmO96YXd0qlUx4Fkw
   AY20muswfYfM7lNchFuXBJx/5eVeGeirIPislf2Pb7V7XdGnHl1fy6VqP
   TwEzKV+YqmNXGPaKid9A444+pm9iimM7Jo5/ypgE2tkrrG5PM14MFMOyA
   g==;
X-CSE-ConnectionGUID: r1xuZy/WQmCwVKOLJhUAqg==
X-CSE-MsgGUID: BgPsW+YiTYuC+hp8SNhmUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="73800574"
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="73800574"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 15:10:44 -0700
X-CSE-ConnectionGUID: P75AfJTFQV6khkqFcZtl6g==
X-CSE-MsgGUID: gb8NwP4MQNGMZwbvJorc+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="167032528"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 15:10:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 15:10:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 15:10:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 15:10:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mYAwPStNBeB9EKO2U980Q1td3U+jM/80zZgKRpAJEDCHbc0AL7eImY3CLarrx1Gr8McawgLVHZgyIsqUEIGnoLmNfcV097EXylFp7ZcbGKTJl/yL/KbKo3igkHym5oc2K69WxpTiq8jnCPkMlG1YDcWsf+4Yt3R9o7+37KekgVKfe+Lf15WjFPz2iW9+1W37CYUPXplcEszGXbrASYR238de7Mv29jnjugaLEFkZm5Pvg/jxKHU12hbCPjx7UBdXxBkEFTBjzZRPGzRu3x8kRiW2MiqNAiaVDaQa68TDcOHdpwbsfSNYUO+G22EU4mcVH/K8Sjs6Bh3By2udkwxjUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5eQnffWw1+kEDgtm37II+ANN6iL8mr1WCgjHiGBagNU=;
 b=KRSHwy/CfeivMM9HxVXemGd9xMI9hzDiNu+yyl0Y8GXtroR/yRChfcqtb27QHX/mUJqWYeQRNEkV5jbu+fDzmOOFv8HRY9MQnk9o3EpS1hwuS2HFUklcquipUPZcgR8WTkBC+VOdPBXi+YtgBGsOsyZPIg/Y4VNLbWEftFxhMU8NA3EPRTCx/h6HDkXTSTSaDv2bgHx+kB5p2W0bY6ivQA5O68lRVFqwVsLr/iGr0azpX6foqHRhDku5S8sp6FK4eFT37vdANevIDyo0b5KZp8eeHnEaNYQUs0j0VnxOMUHNTy/mEElpvfwU+rtSnRs+6FX54+xg0hF9Xvu8YfxlBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by MW4PR11MB7030.namprd11.prod.outlook.com (2603:10b6:303:22f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Wed, 7 May
 2025 22:10:24 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8699.019; Wed, 7 May 2025
 22:10:23 +0000
Message-ID: <5e5c6eff-8ae1-4265-8bf7-0173ed9b0ae7@intel.com>
Date: Wed, 7 May 2025 15:10:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/9] x86/nmi: Prepare for the new NMI-source vector
 encoding
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Sean
 Christopherson" <seanjc@google.com>, Arnaldo Carvalho de Melo
	<acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, "Ian
 Rogers" <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, "Kan
 Liang" <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>, Daniel Lezcano
	<daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>, Lukasz Luba
	<lukasz.luba@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brian Gerst <brgerst@gmail.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan
	<jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>, Kai Huang
	<kai.huang@intel.com>, Nikolay Borisov <nik.borisov@suse.com>,
	<linux-perf-users@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-7-sohil.mehta@intel.com>
 <20250507091722.GC4439@noisy.programming.kicks-ass.net>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250507091722.GC4439@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:a03:80::22) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|MW4PR11MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 4142d14e-4c30-4fe7-6e0b-08dd8db3f69e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YjFvTDk4MSs0cTFkWWh5azRTdWxPVW43bjZCdDU1dDEzb0VvVUR4WXM4bDgx?=
 =?utf-8?B?WDgvaHNUZU9pNmFHZDkwNDc4Y1E3NGg5eXNBdXZiRko0NXo5cnJXL2xoaW01?=
 =?utf-8?B?Q2ExOWFDamh4V25qQjlHM0U4UUE0bkxzZ2VhZG9nUkpuQm1HTVJleGU5TnZi?=
 =?utf-8?B?MDdxalhDdWZteXNyeTREeU1xTEhNcVhCNDhSSTNKM1VrK3hCTW1TNlozU0U5?=
 =?utf-8?B?a1lJUlpjMVZwTU9ha2d5dGthb1FxZ2RmSmREd1hCV1lnYStsU2ZweUNFcVhP?=
 =?utf-8?B?ZUtsZE41NFBMMm9PVGJkZDcxa1Z4VXhHUUJwVzJBT1RIRkRHMkFtTkpHbVNx?=
 =?utf-8?B?ZHoxTU1yUWk0d1d1V1BvVlF1c1IwY0VmUjNSc1gvVVNwak1LejNZUk5rWGVQ?=
 =?utf-8?B?cEZDNWo2b2JrWFE1T1VQaVdVRWp1S0NpV2tFVnQzYnd4U2JVeHJld1pjNjkx?=
 =?utf-8?B?SkM1WmxPQ0twN3FYMXNSeVB2VDFLT1ZwTVV5ZVE1N2ttelhHVTBqUU80YlQ3?=
 =?utf-8?B?dnltR3NqSDQzQ2Q4VEdEREhuWHphM0IycG9QRFpJaHozMGlsam1ZdlVKTWxD?=
 =?utf-8?B?dDJncVRqNk4yT24yQXV2YXd6QU9mREpBVWliS3JSYko5dG9xTjhhMTBEUC8w?=
 =?utf-8?B?OUlnMnVNcXNoS09mdkExSjcxOTg5ZU1jS2F6SU8vaGswZkdQd1A2TnM4VTJS?=
 =?utf-8?B?WllVbW5yZVROL3lpZmhnRnpGc3p6VUt2ZE5UNEw5UjVqVXBvSjRHUys0UTFa?=
 =?utf-8?B?SkUvRURHSERHdGlRS241U2ZVZStFbnBjVDBJaGdrbmlINDJJQ2FUekRDTExU?=
 =?utf-8?B?RkxQWEJsVWg3anZKb3owSzVGQVlZWHRGamlScFBiTlRoWm9QcGs0RFVjSk5D?=
 =?utf-8?B?RUZqV1RkS29ZVjlTRFp1UGZaODZvSDRlTGtzV0ZwbmtuRElkRm1QUzQwS2c3?=
 =?utf-8?B?QmNaZnZiaWJVaUlYdkdDcmY5MVJBNHR5VkNSU2w0dU5CMGZreklhSXlJZDYv?=
 =?utf-8?B?eGw4eU0vZXJxcmJDMnJ6QXo2d3lZTnhVdDZibkdTVjVwOUxOWnhkckMrR0xa?=
 =?utf-8?B?MXEwNk9xbEdvNWpNMkFmUVJmUHM2bGFSRFUydmkwb2VDQ1FFdldkVTIzenpG?=
 =?utf-8?B?aW96NWZJT1pIQnQ1TUM5OGU5bmpyMHp1bzMyZlJmbkVaRjIrNTh1bU1lYUhL?=
 =?utf-8?B?ajlZaDk3R1pKb3lyOVlweEpOU2kzTDRWSkJ2OHY1RmMvajdseXB4bGhveitP?=
 =?utf-8?B?R25STExWRERSSFdKaWxpTWtUTzJ2d2R1TXNZUFN5WU02NzBjWHlOYkI3eHhV?=
 =?utf-8?B?SVQwTjBBRzNBUFBMQ28wRHpZZ1dyOGh4YkhRREdMMWlWOWtsbGhiU0x5U1RQ?=
 =?utf-8?B?b1dTOVcxa1k2SmdNR2xId0JONG9adE9HM2pvSE9YdW81WXhCQi9rZ1NScHVp?=
 =?utf-8?B?bVJSNk1sT1ZFQ3E0VTZVZnJQUzl4MnNDMUdiT2xMa1B1WHhKM1ErQy9YOFpx?=
 =?utf-8?B?eXY0ME05emRUZzJmZklSQllPSEdhRWZOSVBTbnExZVdVLzhvZlJkWlAreFB5?=
 =?utf-8?B?SXE4VCs3dElVSWIvVXBsbEI5d3l0V1ZKZzlacXZhQ0Rka2hXTzdhUjNzWEI2?=
 =?utf-8?B?L1E5ZUllVTF5eW10SU5palFKL2NIUWdwQjM3UVErRlhkWXk3UkFFL0JXMVhv?=
 =?utf-8?B?NGh3NzczQ0l6S2hlQ3ZnK3Y0bFNSY3o2ZGFqZjBwYkdiaUpVY0hIZzJJM2NC?=
 =?utf-8?B?NCsvUUNOSGd6VGJWTXVXekNzclpYc3lDOHpVVXNYTmw4NEFTRjVoTWxSSC82?=
 =?utf-8?B?bmlEcDZOekRhVDg2c1pGNWgrc3Z3cTNRU3djTE5CWFMrQ2ZLSHVnRzZHYThL?=
 =?utf-8?B?T1VxdXhOb2VTOTcwSk0ybTRLN29RS1U1dGVDR3lrK0I4dFc0azVNT3UyZEJD?=
 =?utf-8?Q?Qt7ib/g7Kvs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0k2U2ZoOHp3R0l0ZmNzZEFqV0Fpb3JnNFo0K0hzbzl4a0x3Y0VoOTVIYi9r?=
 =?utf-8?B?dVN5YXF5cmZGYjR0QVJ4SGZvT1JIOGQyNVpsV0VoVkJtMEc4RVI3bGFxK1ZJ?=
 =?utf-8?B?d2I2NllrMzBoWDMwZVl2Z2pLNVFHNUloNFd5TGtkR0ZDK2hmcThieTdHMEZK?=
 =?utf-8?B?V0lnTityVGcvdlEyYkxSb1dEV1ZwQy9LT1ZsMlRDT3JESFMyaGFyMXZsVXd2?=
 =?utf-8?B?K2prSmY1V0Q0SVMzQkpYTlN2ZVpwbHVNS2IrUmlEdEpCWHV1S0FuQzJ2RE1C?=
 =?utf-8?B?djIzRU5vU2xsTHFDV3BqN3lxZjI4Q2lVSml6ZGQzT2FpOVVHT0R1RHNPTmUr?=
 =?utf-8?B?UlVPdWN3MTV2WGRrQ0dwRjdhak4wRkU5MFJCOUZIOU50dVk5U0lSeFN0Z091?=
 =?utf-8?B?Q3hBMGFsaEplcStLTjhmUFJFY0FiSzhXU2kvaFduZjN4d2NoaUVBOGRjU2xl?=
 =?utf-8?B?T1Nsck44ODdKOWIzRkxGRUpjZ0F3R0tvQXBBVmxUVTNlOXVsWEdIUTRONzd6?=
 =?utf-8?B?d1I5SWhDSUhNemR1bXMzNmJ3bGQ3SXBITWVva1Nhb1VoTzBKTlNFVGVIdGdk?=
 =?utf-8?B?VkpOZXFFT2F2V3VFU2N4ZWYzeTEvWFdidklFcHlXOS9mTmUvSXN1SGZjTVg2?=
 =?utf-8?B?Q2xJZC9wUkk0eWhCZWsyNWtnejVoUEFqdkxGYlJTZWJaRml5VTlHMGtqUnlM?=
 =?utf-8?B?Q21OYklmWDhQNzdadHFEaDlraElibkkwbmYrTDlBUVI1WlAwbWFvMUNRWXhm?=
 =?utf-8?B?NEFnUk9ndWdmMnJJMy9OMjJwV2ZNa2ppUUs1WXd4STd6dFdpc0lpUm9CYmNE?=
 =?utf-8?B?L2dWc0FwNXFIbitlQ0VaS3JwZ1o4Z1YxYXo2WVJJU2ZycXVIY1ltWlJRM1ox?=
 =?utf-8?B?c0ZTTVc3WFd1UXVpL1RqV29yVzhrOUxGTGl4QWMxTko3S3NVVExCaUpUY01j?=
 =?utf-8?B?dnIweHUvYWV2cEZEdERZTGtTVHJCeUJwcFJmTURyc25KL3ZkRmdZNktUN1h2?=
 =?utf-8?B?RE5CY2ZOSXE5dHFGZU42NjFVeVNYMUNHait1cVZOMDJEdS9UZVJtUHhRMmI2?=
 =?utf-8?B?Nkw2SmFJQytadHVGclU4QmUzZEIzbGJidTQ5VXRWczM0dnE5U2t2UzQ5S0Vs?=
 =?utf-8?B?MDZvNEVTNWRFOTJCaVlMNkthdk9JNlgrVkg2T3BhSUtWSEpBWFRMYy9vczdP?=
 =?utf-8?B?ZzR5S3NQRVIrYTFvL2RhYW1GcDc0clg4K3pYbEdaUnFLSEp4cGpQL3M1R21F?=
 =?utf-8?B?anh4UjhzTDRxR21pY2FQYUhuWkFwczUzMFBYZzYzT2UzeTBjTkJrTnBHaHJ4?=
 =?utf-8?B?NWIxMDM5MUhwRFJYdzg3TkwvVC9IVnUyUTBKb2JyVjRWUTNnajhjb3ozcXFk?=
 =?utf-8?B?bWMwMHJ3RnNnU25lUkhhWjNVd01QZllqdTNtNEcvWVdHNGl1bjAyekJKaC8r?=
 =?utf-8?B?dGs1ekExbGRxT1NlQzlIRUtrK0RQZXZEaGFWQk1XbThGYStBalhCMWpycU1B?=
 =?utf-8?B?SUZhVHRWRmJGWTRBZFl2eWNRZWlpbThkKzdyNDdEVml6ZTQvVWdpYTBDYkQv?=
 =?utf-8?B?L2hCRkNzRDRZb1Vyc05YNUp5dXBmdnhtOVRucDZLWXRlTlNXUGtFcmNhdVd5?=
 =?utf-8?B?VzNmZGNCYWluZEpwZ3FMc05hVS9xbHFkVk1TRXZHZ090YkZsMWd6TWZzWjA0?=
 =?utf-8?B?YXlwTjFORWZoVm1CWVZNVCsvTjRBVFczV3d4WXYrZ0lVak03Y0lsT1NnbTJa?=
 =?utf-8?B?RDhpSDJoQy80RnExaWZUeEVjTGYxTVF6UzlhL1dieXhPL3ovNmloY1gyMjl0?=
 =?utf-8?B?ZE5jbEFqYjRCYVRFQ2NjQ0o5TGgzRWo1VjM5YkljNUxDUWFuL1NSMmlmbW5v?=
 =?utf-8?B?QVV5a0JTSVQwZWh1dExabVgvb0F4VDZiaHg4V0diZTArQ25XQWpKQlZNM2FL?=
 =?utf-8?B?RDR1bUwvR2phclA0RFlvSUpwY2lLTmxhckUvQmNFcUhDUUlHUERYNXp4dnM0?=
 =?utf-8?B?UGRZVmw5ZWMwSWd6c0drY1NBbVhjWXcvY0ZNRnZtV0RMODdCU1NlTnhnZ3pX?=
 =?utf-8?B?dUpKSzNkaUNpMFhqV1RJRUxrZmcvTHhBNzJHQks0ZHBsVDlpV0xQSVVQalFT?=
 =?utf-8?Q?IAWcHMGBrK+UbnVSJdc1na7nF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4142d14e-4c30-4fe7-6e0b-08dd8db3f69e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 22:10:23.4291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKdZHZphBGy5Wo2DCXlfYYL5ZGyBZABhaxlvpePwV9orVTe2kiw6rtzLSUV7qh6OzkeDYphiBevqvJbmpl3g3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7030
X-OriginatorOrg: intel.com

On 5/7/2025 2:17 AM, Peter Zijlstra wrote:
> On Tue, May 06, 2025 at 06:21:42PM -0700, Sohil Mehta wrote:

>> +	if (vector == NMI_VECTOR)
>> +		return APIC_DM_NMI;
>> +	else
> 
> Please drop that else, that's pointless.
> 

Will do.

>> +		return APIC_DM_FIXED | vector;
>> +}


