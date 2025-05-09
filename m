Return-Path: <kvm+bounces-45999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F03AB0743
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 02:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3A3B9E3F7D
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 00:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20997208AD;
	Fri,  9 May 2025 00:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BK4LG7MV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9F82110;
	Fri,  9 May 2025 00:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746751637; cv=fail; b=oBv5ZinPUQjsbhe1Lz0+CQ1OLBSiMPwTLa8UZKooS0DdRvgSfPO8t+iP1H9VNDlXYeUlEqK/rVBwcetIyIH5VsQ2bkz2uMQ/SCAvWTHTWSN9uVaSYHvOnUoJx6of8yXqpibQqGYMEC2cbivJKa6pmzaq/qNhzTb0Q658Fdn5z4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746751637; c=relaxed/simple;
	bh=qYJI8WwLnsfhMAardFQkeGz4CC0It3T+c3cpxwWvzdk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T9yukCHCpncq0tv3lyX68rrN0n6tEu7rxU4kJFMEtX+vVe3AzrD8yxiK1lSoc4rLhQ2TNG8145quf+I5ssCRm0GMzTul3MvV0GphXOuCDK15pDty5YhCUA2CUW9ABrr5+zqGqtBlaCN8tK79+uFnDm62yLFSfn41n/jUIkzWmT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BK4LG7MV; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746751635; x=1778287635;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qYJI8WwLnsfhMAardFQkeGz4CC0It3T+c3cpxwWvzdk=;
  b=BK4LG7MV9Koa74LnfZ2Xq2RZ+BWpq4dsDnBDpR7fvj70tgE688ykSCN9
   RIlLrWSSzJw3FecBfWnEwFOKleA1HNZ6d946okfVdW10W/3+CLH02myMr
   0mft/GWiTEvQZtCFpWS63xCMF5j5lWmL2n8NwpFksKFNm6K3V2sGrpJJ5
   W4sBp8Uh2y8QSFMXaOTvqeS/qwyjsu4B1ntttx5BE9VFdGyqrs1SylxLl
   v15oBhAnfYu/viqi4GFwrqBrS8IeaUxCx/ljiPHl9eLPq7lvk6E+GcfLW
   uuRCnIfr/RpSqqFr2G6OsVmLr2VbMaFRXaN0fniGso2WkcSZO+vqLfBBH
   g==;
X-CSE-ConnectionGUID: Tx9n7C35Tj6qZtWOeHWoBA==
X-CSE-MsgGUID: rOkkyUQpQvqPNGBlsCz+Gg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58777612"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="58777612"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 17:47:14 -0700
X-CSE-ConnectionGUID: T7Uh0lkSTeqjKFkhBTLKFA==
X-CSE-MsgGUID: 7eXt6Mz3QKqmPGN7biixxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="141230860"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 17:47:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 17:47:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 17:47:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 17:47:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sw+eo+Pe9wQUMcXzgnvGIR1JQZkpSUP8jLk5O9sWSqxCGZ2xwfMMeo8Ji2BV+empa9bRZIx4xOk3Fo4QGknky4CafCz4WwTWLN+g2S6EUmaQ+yXvDgn02vbEpVw4sZuCwfpgx40gi41bv9ek7EU3bdaPPWFGCivQdRWmA/XILi4FNrGS9OvSev8jGkPjABgiYf2TthX/IoUTo+Hd7MsZZfdgnDZY+rew5IIeLCltAMVYNxLAUfWPAFzwPKxyBSQYoG0eHaDXafKZ/baG0RtPLfJzqix9nkVoSG1CKYbSy44bgPGYTXEtKNRSMhixN7jmnhVzJC3WFfzyw031kyazGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KIS0HZmAmuwHatQkuNcAfvJWZdt44XQOp1JobTlCjQ=;
 b=MNqmlcKAlq/VYBMRkbZ3LatRL+4S3t2fzKZQkPpXGL0DOc1FUjcGJycmK0UA2QJfHRm+DH8Q3W55xJq2RIZS/9GJCiicTZXhOgOdgvzlDCs3BSROC3jjHZESWWAtBPGrFT/4t9ij6qNWgtHvOVsRsKvFZBkdyZMLAu6PvILBEMdK5WLRq7oocpwv2XXWNbUyieBrt/8cJtWuwrMzacLIjvIJjjC7mhXOVfZ0vHABurH7tHgRrJJF/HHi/ncHeXWvp39BRrd30IyqQXzOKbuGuFXGlaMh6m3DxoUGD5UKnVl16qfiuogXCKauiSe9qu0cwT4r/9Rg+lgV8YJQTjZE1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SA1PR11MB6894.namprd11.prod.outlook.com (2603:10b6:806:2b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Fri, 9 May
 2025 00:46:34 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8699.019; Fri, 9 May 2025
 00:46:34 +0000
Message-ID: <5b82ef76-08ea-4c68-b300-8ab5bcd680a9@intel.com>
Date: Thu, 8 May 2025 17:46:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] perf/x86: Enable NMI-source reporting for perfmon
Content-Language: en-US
To: Sandipan Das <sandipan.das@amd.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
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
 <20250507012145.2998143-9-sohil.mehta@intel.com>
 <710bd9c4-efa4-444e-8699-5a6430e8d6be@amd.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <710bd9c4-efa4-444e-8699-5a6430e8d6be@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:217::14) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SA1PR11MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bf974ea-e707-410e-6c0b-08dd8e92f1ba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0xZY3NMYy8xck92S1k1aURRM1AyQVE5d0RSKzhWcllIRUZyK3ROUllsMks0?=
 =?utf-8?B?Nmc3M1UxRTBjNEZKRmp3R1V6VUV0eCtDMmtXQzU0VFhTQTNIUUkyakNSWFI5?=
 =?utf-8?B?ZnNnNEhDM1h5ODRyeEtNbVJwa0xlS01sOEJMaGVYL25DUVZJOFo3UEo0NVZ4?=
 =?utf-8?B?ZWdRdFR1Wng2SVljWTlWeEY4d1huKzMraStPUnZ0KzFVd3g1M0lreS92UkVF?=
 =?utf-8?B?SlVZSWUwSFQzRm8vajFuT0JOMDBZM0hUd09IQTByQnpQdS9qODFCeUhwdkY3?=
 =?utf-8?B?V3g3M1d0NzFlcERsWWl6M0dQZDdyNk5vc1pIanJiY0lEUWpOSE1oTXJyc0R6?=
 =?utf-8?B?L2s1L2hmMVJ2OWlHNmdXbjM5dmVEWlB6SkZCbVBOUGNkYmJ5d2ZVTHlQajY3?=
 =?utf-8?B?elhwK1pMVlhHWUJEYUhiVDFsRTZnejRTakdJUVlkQ0lCZkVnaStWUGExTUNq?=
 =?utf-8?B?RmN5MktscHJacm5Oazl5UUhSc3F1KzQ1YWdGSmFJWmZLNFFaeXJNUUNxd2x3?=
 =?utf-8?B?N3NQdTFpdC80OFBCRmU1dnZrMlFqN09NdW5ZWm44ZjlvWFZTZmdJYUt1c25l?=
 =?utf-8?B?cjBXaVI3NkthTjlLMFdqSWhvTnhVa1U3TTdCaExEUzBCNGZKc0Jld1V2S1k0?=
 =?utf-8?B?MjJpWU5KYkJ5SVZPcmwzYmhtQ0pRZVhhT3V6VlJpOHJuNkZ3bWhiM1BmNFJG?=
 =?utf-8?B?b00rMDZBZlk5elVTWVZ6T21yZ1A0Y28rbGVoNVZ1TWxJa3hML0IweFIrTnY3?=
 =?utf-8?B?eWM4MTJXZjhSVXFmQlg4dmpoVDhRQmFiUFhqdHY1SGg3YWhEVVdHaFZnUklG?=
 =?utf-8?B?bis4NmJTUVMyWjAzcFVBdTZuNGNDYnFGMmJtaVBGeVVmTzVuNDVhOUJOcjd6?=
 =?utf-8?B?N1M4THlDMWErQ0FFbnR6UkZhNVZoK3I1QkszZENSL1UwZzRzN1phZVJGMHJm?=
 =?utf-8?B?RGFRdmEzeVBHVnZrMldLcnBlci9GTHMwV1B0UkpWS05idTVTVW00bk1iaHRn?=
 =?utf-8?B?YUlpVU9VUDVwelBhWlg1SnMwQkg5aTdRY3dIcGVqTUM3ZWo0bmVsOEIzdklV?=
 =?utf-8?B?RlIrN1VFL0V6T3Q5cTE2OUFhYU1UaEtRV0plVW5qV3g5SVFMNDhabnVsbVJO?=
 =?utf-8?B?aGZQdkxudlpVeU11eWZmdjM0SXpHYkJsSHlrMWg3M3oyU3pUNmQ5NVk3aFow?=
 =?utf-8?B?UGJXWTdVcjVLQWdLNzZzdVVsNzNGK0c4MHBVMVhmREFDTFk2N3l3RG1OY0lH?=
 =?utf-8?B?Ynp6RzFzTGYzdjllZXgzVTFoZXozRlZzbXRPc1VsNXcvSWgzd095OHRma2dv?=
 =?utf-8?B?OU82cHJ2a2dYR25KcE1selV5TGdyQWFBcitEdG5ubG9tRms4S2poZUk3Tmw4?=
 =?utf-8?B?ak5COWN1aXFWZjVXZm52VG5lRWJMZGpYd1RudGNGTkRZUjlUQW9ZL2pNQVMy?=
 =?utf-8?B?dytyM1RSMUw3ditKUlIxTjVqMEdDQzYzUUNJR2tGb054eHN2dXRGRW9GQjFO?=
 =?utf-8?B?cEgzaUdyeXpyZzE5S3RUVk5zOGwwdWdTZUFEeTVnZElKdjE5TkN2dEpXbzUw?=
 =?utf-8?B?SkFLbzZIQ3hkZTZ6TDlOSWhMOG1LSjNtbDVmeklyaXRRSGJxeUUwaXVFRTBj?=
 =?utf-8?B?b0lxZ1p2UUpITHhYbEVFUERSZzBIUW12VVJHaTFJT3ZpWDMxM0N0bzVET3Bn?=
 =?utf-8?B?dEpEOFdrUWNNMHpxRjVaT01vWHhEaFFLVEt4cnVMeSszS0lxUVlNa2hIbm5R?=
 =?utf-8?B?b0pJY2l0eGV6OHZMcWk4NWpFeHlxQmplYnZiai9xY3BaTmg2aFRNclErSTRk?=
 =?utf-8?B?c1VkdTdJY3dBZHNwWndpdVI1VWpmRWdzNU54TWZhblRTRHEva0hta0VjcW0x?=
 =?utf-8?B?bHVQam5DUFQzRzhKMWUwUXpLTW0wWlF4RHpCOUJ2ajk3V1hFNjVUVU9vY2VD?=
 =?utf-8?Q?ZimJ0AR7byI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0k0R2JxYVUweEtvMWVweGd4Ullxb2tjTWNlbWR1OHo2NTgxTzZMNnNSdElt?=
 =?utf-8?B?MWhKYjhoR1hUY0RDZ242YVdjc29XUVp0YitmSEtJUFpxTFR5aDQ2Sjl6WFpD?=
 =?utf-8?B?WXhFdEY3azB3Q0dzNjJ2RHpXVm1NL1YyQ1l0Z2FlekFvdVhlY1F1bU8xVSty?=
 =?utf-8?B?Y1RseUs4VHVkU0k4dUQ4RFdKalREZXNXditVeG1PUGtnM0tCMHhjUzZQVjlD?=
 =?utf-8?B?QXBWQWwwMktLd2E5NWZYOXVyOUZCRVd2Qy95b3lTWkJZUEkzQ1cxaW5rbUd0?=
 =?utf-8?B?YnRFNmZRSmhiemxVdGhld055NUxKQTY3ZFNWU3EyLzJkV3kwUlpyb2xpd1ph?=
 =?utf-8?B?VHo1NXZpYUIzaVhZZTE2S2srTlBYRFAvV3VFTnlWVXZ0YlR4NUtSZ3B4KzVF?=
 =?utf-8?B?UUNKeUJDa3lBbk12dkpxdVpqN3BrV2pTUGs4dWVhcWJLeDkxRE9vMWNNenZH?=
 =?utf-8?B?ZmU3eFZmdW1NOGk3b1dIdWQxSVJ0WHQ0SEhlb2txYUNxRjNvYU9hUTByQ0pZ?=
 =?utf-8?B?YVpVUVF0TzNhMDdnSEM3cVdZNWtPRDlpMk9vUVZQYmRJdTZ4dkdlazR0UzJu?=
 =?utf-8?B?VksvZjlsNlVwMFh4SE0xelNNeGRMWjR6SVlPQmRVRDhHMFVMeDVGWmZNbzVr?=
 =?utf-8?B?Z0pTZG5VK3RFcFRFeTJpckFlWFU3eXpTRjQ4cFZudnBJajNYZ3RrR0hCZmZx?=
 =?utf-8?B?eDcyNW5hMVlGeG4wSHdDeTZwdC8rc0hPVkdtS1dnMXFZM2FBT3ROMURPNkpu?=
 =?utf-8?B?NUYzQm9uR0VGaVNIVkhZYnhZNDdXREFXRVY3R2VYLzNXYWIrZ2J6WUViajho?=
 =?utf-8?B?OWtIVHBwY2R1cnRBUmhCNFA4TldDd2dTVUVHL2w2dlR3OXgzckd1T1pzaHdV?=
 =?utf-8?B?bWZhUEFoc0R6Q25qd0FCK0pMVlUzSlBLb2h1amRPUWxSajI5emUwdXRUbVZt?=
 =?utf-8?B?SHgyRmswbzJyWWdmSUpQVnBSS0VMcDEyTm5MdUp4NzZhY0tWNGJnZ0EzRkpP?=
 =?utf-8?B?Z1hnS1B6QWRlamFlUlZ5a0NHVTNJWU92UlpyRmpJUUdOTUQvajA4S28zd09G?=
 =?utf-8?B?SFMzTHNTQWI4aUlRQUFUSHJEdEJpZGRZeEFvTmpOdHF3Tlk1aTVPWFZFdjNu?=
 =?utf-8?B?R080SHoyL2luNVphb2hUSkNuVU9pR3ZhWk5vL2xKRHJPWTRaUml0cUw3dkZr?=
 =?utf-8?B?ZmlRWjJtTGYyNFJBdlh3WDZOckhOd1g2YUNjRmI5b0RPYkM2YUtYR1dxTllj?=
 =?utf-8?B?UDNJZllMRUNSOXoxendNSGloTnpvNzQyQzNDZzRmdmdOT2g4RDdxdXFCUDRL?=
 =?utf-8?B?Y21Sak96eXVKZFVtT0piMXZxUW9XZmY3R01IOXhpS0ZBcXkyQ1EyUFZkSldq?=
 =?utf-8?B?N1VnWXI3Qm9rMGNTUGFONGQyQURjYjM3YklGdmVNbkFYOEhscjlPZVFMZ1lk?=
 =?utf-8?B?NUN3Y0MyS1Z5THFNdG81akdkWklzV1lIYnFMb3dUOXdhMTMvVC92cllLdG85?=
 =?utf-8?B?MnFjSU1ZMkVaMllrMXZKdkNLRlFTRG5tcVh0bi9KckN4b1ZSblZORTBSWW1r?=
 =?utf-8?B?djAvRTk5VGR5WWJYQVpjekJSSzBIbEFNbHMzbjBSTmduaDNXMFZLL2dsbU95?=
 =?utf-8?B?amRYV2EvcmFhbjAvVUdqRlVrTENORFBnQ3N2K2YvaVJMcnFvZFg4NjExeVlh?=
 =?utf-8?B?a21haktSVFdpNGs1cjlwbGhIcHc2ZkIvV2xsQy9uVkM0MGtiYlRoMFpreG1U?=
 =?utf-8?B?QldHb080MmxkZU83S085VFZLbmRyMjVNbkVLZDRaRHBkSjlraFZySFg0ZllN?=
 =?utf-8?B?NnVjTXVyeFV1TWlhM3ZWTkl5SnBHUCtCaThEbVh0alJpYlNYK0RSS3NPVnBn?=
 =?utf-8?B?TTJTbHZDVzFsWmFQSVJqak01UDh1WTBROStGVjRJZDM3T0VXOThxcFQ3QndH?=
 =?utf-8?B?aG9sMFZ1anJ2MzkvaFdqbFBjWVZ0V0NCQ3dDcDg2Tis2UVlwbS9ISElNaWJx?=
 =?utf-8?B?cjVHSklKQUVGUHVPcDFPQ296T3hFTEl2RnVFNk0rT2hsb1FYM3N1OTlzcDc4?=
 =?utf-8?B?Z1F1ME4wdWl2MWNRNzhaTWNSbk5sbkpPSGtDRW9nVGZiWVhTcHBPUjVVRGdW?=
 =?utf-8?Q?YJ4q1E3nQ26nNF+m32CqrbK4o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf974ea-e707-410e-6c0b-08dd8e92f1ba
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 00:46:34.0503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSJzUWqZeSX34UcBJV4HMJsbwPlHJLMaLvSp1Nek/c3LbhrzeIzCBYCbWuO9o5J19LMgIlOeLsWcGHkgAUcbig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6894
X-OriginatorOrg: intel.com

On 5/8/2025 4:20 AM, Sandipan Das wrote:

> For AMD processors that do not support NMI source reporting but use
> x86_pmu_handle_irq() and perf_events_lapic_init()
> 
> Tested-by: Sandipan Das <sandipan.das@amd.com>

Thank you for testing this.

