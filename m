Return-Path: <kvm+bounces-48331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A85AACCCA1
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 20:03:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D76A73A479B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 18:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746B41C860E;
	Tue,  3 Jun 2025 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gPt2HMJi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473711EFF81;
	Tue,  3 Jun 2025 18:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748973756; cv=fail; b=CtKVYwdFoYkHbPJv+1W+7uc0hENjzcT72sc45TkxQbq/fqrBwxoPhVzaxNJS+1MpRAwYpaUD0m52AonpDEm9DGvzDfbSl9gmitjfc2FpzftkU++ZxFbCll4mmvnUWLt68Gm/XWaAWWYoepEb5oQoBKMAut65dEMazrfm8UVonRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748973756; c=relaxed/simple;
	bh=6zcFn6IcCJjjSlSHC6L2VjGKbMs2w5fvi1dJovwG7sM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dDpFZPLFB/y+OTRYOxK1FY0JjK83WJqbuUD0AXmVf+iJSIBJHePzgH3oxmxXB1U3Jz9d6BVzRr3KdzUuZjIRMhGOn2EvAC1/lIesFboz/fdouFQoBMyy0dDqV6xoaRX7aCgQCkeR1WaEzymNNbtcZMEQj5fN4Amo8OVIkquJbcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gPt2HMJi; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748973754; x=1780509754;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6zcFn6IcCJjjSlSHC6L2VjGKbMs2w5fvi1dJovwG7sM=;
  b=gPt2HMJin42w4PxakJYeQWH7xcmqqe+kTS6UFr3J4UJC83+sJ01DBl0K
   jg4LdD5QKcRMtcFVCYh32SkaPX8XMzPrF30uDJKUV05fyWejDoAuA1YwX
   dgzoFGPQB5Hw55kpvJXrGY7fX04B9tYXhIs6DQG154dnVvfItG+ij8W8N
   T2byMiHugBKJmx9cuQRai4sliq9VeUa2Tt0kWfE0cfRHvc5NngZ2/wt2w
   ptCSaqhXmbfTpNsLX2G/O6gj6vjwrd0zNWSRhREyJb516vVsbV0IiPCy3
   IfKsci4pHwCMkdN2S/7dxd3IkjKmOx1jxO5XrE1koU+tj9cZbq6EufLGI
   A==;
X-CSE-ConnectionGUID: MZ3aJMioRSOXbmi9juWRkg==
X-CSE-MsgGUID: 385MNynUR3aCdQWcHWDndA==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50148660"
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="50148660"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 11:02:33 -0700
X-CSE-ConnectionGUID: dxfCD75SSGiCe9+rt8tXTQ==
X-CSE-MsgGUID: TQizaO8VSZiVCTJoTqPNAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="145905570"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 11:02:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 11:02:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 11:02:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.43)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 11:02:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cP2Kkdl23yqeHo2Q1+EUkVQxKMEYdNo5JZCGnIy8I5fRy81vdBy83iltnwMksCcPpr5o9gTBPx6DYWdJqKFhCf9qvSkB7qJUXdnHx7KweOBtvSw0XX0UJSdlJqdKGe6S21nPzETZG+Y0fHJm9alsXUDCyXQeVr0MwFDUT47TxMbZh0eA57flvfpU3NUG4jOKuRTyDOz4dlBVipKoHIrKtWMi3eJBy96T3qD+/IRNNjMUeu4SQFLWJ0VCVqfJkgg5Rs6cADs+Ekx/7MWaO5OETHqwvJpvamXq3FLKTr68Dx2dg18hyEcSJM8xHNj2HLmncUAkjf9dcAZAuPBM0onvOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvLkk3x1g7G7vApS/HQMr3IxriNmMe2zFw3E1qr4jz0=;
 b=HdA5hN/5xE972bhPVjmxLJPk4/bYufWU/HFpDY/M/ouC93P7eKfmgnIKv1rulhLCmilXOEkc4CHqyfk0YuiGy2Et4MBm69aJ3aeblnHBCMGfABwwHzWjXt9T6wpZ4LuHqttqtD5wUNRrucXhDQaVxU4oiuJfe2nZ40MbMOGGGFPzHX/UlzyL/IGQIu6rJYB52djfTTKyuizmEppyRGDjOGxf62T14uUCtgx4yEa/7YpfJ8FUWtXMuh+TQ+cPmVv38nZ49PD4PgmWDdmVUOuNQKCSfnX+Zj/9udZsB88ZolfsKmObOasS+dSKz6cfiyeeD0+XAVqw6myrToUP+hdp8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by LV2PR11MB6022.namprd11.prod.outlook.com (2603:10b6:408:17c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Tue, 3 Jun
 2025 18:02:29 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 18:02:29 +0000
Message-ID: <cd6e6d88-944c-40b2-a343-3d81415d9b64@intel.com>
Date: Tue, 3 Jun 2025 11:02:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] x86/nmi: Extend the registration interface to
 include the NMI-source vector
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
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
 <20250513203803.2636561-4-sohil.mehta@intel.com>
 <4e6d865c-597f-4281-a07b-94aeffe938d6@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <4e6d865c-597f-4281-a07b-94aeffe938d6@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY8PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:930:4d::17) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|LV2PR11MB6022:EE_
X-MS-Office365-Filtering-Correlation-Id: 841c84da-3d23-4c0b-9cdc-08dda2c8ce4c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UnRoWXJRQTZ1SDZHS2tnU2REczZLUGNJdGpCZTIyRFJadTI4Z0RmWVkzZ0U2?=
 =?utf-8?B?UmZaZUlXOHBBSCtFbmVDbWFwSTE1TTZrQ0FsVVlXQzQ4YUhxQ01KSkdOV1ZZ?=
 =?utf-8?B?aVIxMUI2SzNkckd3VkM1TDFJbUVybTR2SUtjcUwrRUxrVmtuYXV6WFFlNXRX?=
 =?utf-8?B?VVZWWXVFUTByNU8zZklMNkFhS0gyall2c2d1ZkpwN3lwTzhPYnREWkMxQlA4?=
 =?utf-8?B?RmNPTG5GU0duMEMrOHVxYk5paUpKYTRmWHFUZW1oVU5ZRW1nb3JBMXBHMXo4?=
 =?utf-8?B?SFhNYUpNMHpmVGJnZVBtcklWS01MejBKTjRhdC9SeDFLeUl2RnZPdGg0TEZJ?=
 =?utf-8?B?dkMzRWNtL0FFTXJzaUxQL05ndDh6VkNCVmdramlsV09tVFBHR0h4T2ZhNDNR?=
 =?utf-8?B?YjB3NWhyNFpjM0gxd2JhbzM0bW5aUklZY3ArcUxiSlIzZkl4Z0cvaVhpTkRJ?=
 =?utf-8?B?R3djV3JlcjlwYW15TkVRUnJ1SHMxWmpGQjVpOTA0SnhzMi9HSHZqZllWdDBi?=
 =?utf-8?B?VEMyWTVCZ1EzcVZNZEVBK2Z5c3Z0NDd2NjlLYjF6aXhlWDZEbjVnbmFnM2Vn?=
 =?utf-8?B?ZzUyRDRFYWFNb2h6cW52UkE1bmxEUTJScHIwM2Y1NzhMRzBQeUQwY1piSTlj?=
 =?utf-8?B?WHM4REthb2xFWmRhckJvVjk0LzBBcnkwK2NWZUJUdkErTlUxcGdNNzVUdElL?=
 =?utf-8?B?Z2lEd0Jid25xZVMzZ25OQ3FadEx4TzIya2k2OWRJZHJvc3hvZUhJSE5sM1JM?=
 =?utf-8?B?TU1jRTRwYUdzWDgzMmR5d0FvdmpIdHpxd1c2SEdYUFFvYVpza2NMZXU1bnhi?=
 =?utf-8?B?Vzd6K0hqKzdZMW1hQWZ1QTJYeS9ZdE9RUjdnK1FLWElSRldZU0dXZ3djc0Nx?=
 =?utf-8?B?bHQxZDgvbmF5ZHd4NFMyeXNaYTZ3bDl2RjJFOUhlbWRVbmwvRVg3T21UVmFv?=
 =?utf-8?B?d1MzeHNDVk5yWmFFeG1vV3p3ZWQ0TWRCOEJ5RTdyY3hhNTdONmJTYURXTXVh?=
 =?utf-8?B?a3NQcmhLWkpNU042RzkveVZhUkJEZzBoTW14MEN6cmxtaVc5NVlZU3Frc21v?=
 =?utf-8?B?MlZzbENLRzFHS21WaDRNVytsMXJ4YUN4TWZYRERNcVV3V2g1K0NLMytZU21o?=
 =?utf-8?B?Qi9MZE5wcjBSNm9NS2VEcWF0bjNZeUJRdEdEdEErUXBOc3R1M1NiUE5HaUpa?=
 =?utf-8?B?VnlKL0Nzc0JIb3JIblJidmhMY3FMV09VQzB4MlNHRTUzWUp0RDhaZVVhUEV2?=
 =?utf-8?B?NDhsUVBnVHhaOWpaQ3BhZGdvMzB2TWdrWXpRWVVIdnNZbXFrVDY1WkFqMi8r?=
 =?utf-8?B?Mnk3VDd1S2NTbGQ4YnVOK0NJbXBnSG5wV05CalZqVFZvRGRTZzRaOTV3S1li?=
 =?utf-8?B?Zzd1NVUvRm5xYjUxNTN1ZkdGa1NPSy82MTFnY0F5N1ZaeDBWQWhIcDh2VW1C?=
 =?utf-8?B?Q0loTFgvMGg0Sk9wNzIrLzQ2QjVMR1RqZ1djYW9yTFVudStuTFdrMjQyaEVx?=
 =?utf-8?B?VkJRWnllK0cvRTVWWGw5eTk4NHRSVEJ2KzRPalI1OUZDaDZIdlNIQ2JZYXNH?=
 =?utf-8?B?dXRqcW1XaU1BakJnTXJmeGNpbTlGbEFTdE81L016YkluWTd5RnF2RDE4Zm12?=
 =?utf-8?B?U3k2bERGbWRrRHZBb0pxMys3R3NkQ05jcE81QzZOR3RpNzVhUlYwb0YyemNF?=
 =?utf-8?B?eGNRVnBDV01qMGRTNTY3U3BWNmZ6Wi8zZ0lSck9VOFg5Y3ZYeDVjdnRHVGVK?=
 =?utf-8?B?VUpZYUltOGZpR0dUUWthYkd0NlpCY0xwTUlybHhvaHdONm9SNjd1WnpQS1ZO?=
 =?utf-8?B?alI1U2FHa0xWRTNHLzlpYXZ6MU45UzA4UmhZOEkyVFZFYXJaQlo0aWF2OGh0?=
 =?utf-8?B?MkFoc05uV0VIaWZBREE0eVk3Sm1KYm81aWttdjk1d2Z0M3g1UnJOMXp1bktj?=
 =?utf-8?Q?JXQ5rT0hXz8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2JvZXpQN0RDUTdRd2l1NzdVakFjTkxDQWk3Y1VNaDN3TDIrazhoZEtzbFFG?=
 =?utf-8?B?QlYrTHkzZUFtMWJLL0FwL3c4aVl1amtIVS9FK1BpWVdScHhpVmUwMG9iZStq?=
 =?utf-8?B?Q1ZZbnl6MzlPU0lIa2J5V21wazF5eTh1Qy9kell6MmN0bGh6a2U0UmVLUHhu?=
 =?utf-8?B?NGJIMFRYZTRZREsvWC9CNC9zVnFsUTFPUFR3cEs3aUlPd0I3Q1ZNbkYxOEk1?=
 =?utf-8?B?Sk9JM0JGdmtNaEZGc2lrMVZTTDMwdlZNanQwWVNiZXRVWWRWVTFoSENQOEdZ?=
 =?utf-8?B?YlpyQkJVNXV1YllKREpNd28yNzhOZWZTcG0ySm8wT3NYM0tuSjRYZ1M3R3lt?=
 =?utf-8?B?Zjh6dnQyM0o5dlk3aVJqYTdEeTFLL3ltbXhCV3pVSHN1VEdsYmc4Z2RDbHVW?=
 =?utf-8?B?WC9FSThrc1dXbDl3UldINVExaVd1cjNHSkJaTVdtY3E5SS9lNDFXK3huT1pX?=
 =?utf-8?B?RzFrMUtXRmxxajc2SzFuc2pmOVdZMEZTU1BCNnRoY3pDWlJQcnFMU0V5M1VO?=
 =?utf-8?B?VC9xVlhHS3lWdnhLNmZtS2IxMGZmMnAxbmUzd1FpTXRxNlFqN1dXSWRRQmFv?=
 =?utf-8?B?Vm0rSzJmNDVJMy9SREhwS3pYM3pkTzU1QjVQS0VBNlRNNndXYVd3N1M3SmxS?=
 =?utf-8?B?UTdIRkRDTk94Y1MwejhxYWtxcGdWUWQ0WW9VY2w5azZodll4V0hObmNGUi9B?=
 =?utf-8?B?RTFKU3J6WldFanBWMkJ4U3J3ZGNGWUkyR2FMbXlvTzRmSDZDWFpvTmpMclp6?=
 =?utf-8?B?MlhKNmQwcU9CdFRTZ1J3SGJRSU1wS2Z1Y1R1NnJmMFgrSytpbmY0WFNVekZ4?=
 =?utf-8?B?YU5wRG02UkV6REM1Q0hMNTRZb3NFK3F3TmZBQk53U3dqSXRPKzZZTzNiNGs5?=
 =?utf-8?B?UFcrVC9acnI4eDlaOFVmRDdQamJBeTRRT1lBckdPTzhIUUYzcHBKV2tDRjBM?=
 =?utf-8?B?RUdYNDdCZERPV3YydmlrL3BrUDFWMXFqYlQ0eTZlRUYwSUl5Qmswc2YxYndG?=
 =?utf-8?B?WVlyWFp1UHhCSmRIM0I0NE0xQXkzbkoxNTFkZkdNeWQxdnl3aHNEbWdJNFNq?=
 =?utf-8?B?L1l5OEN6NzUzSVlxUjRMUmMrWWNsYk42VURZcUh3TElhTURpbjBKU1FDZDhw?=
 =?utf-8?B?WHRnRHlhRXJycjlvdU5wN1VtMGR0NitnWVB2WktNc2pzNkFzLzZDWFFIN3dv?=
 =?utf-8?B?cG5ERnBWQkI4Q0xkVTZYMDJSL1BBUkhyMHdRSDdMcFJLdHRNeHdHUjNLMVhm?=
 =?utf-8?B?U01BRDZlM3FLRjlVWGttUEpnbnhLbHdXemxsZ1NYbTNvQUJFMTF0bCtKK2RW?=
 =?utf-8?B?dW8ya0FQdVdSQWhWYkM1L2pwMEhVbDhxYnZFeUg4dWR0TzFjVTFLVkx0Qklq?=
 =?utf-8?B?U0xTNHFaUGhDYk1GV0Y1UzdJT29pVDdDOU1HY2hJbFI5M2RMSE5zUHFYM1VV?=
 =?utf-8?B?Tjc1c0lzUGRVNEpHdWpSSC9Ua21WSUFFMnlFa1o5by9DS2FIK3hXa0JKR0ZI?=
 =?utf-8?B?K2pRK3B6T2FmMUwzaHRWTkIvcVBEcFpsRGgyQmpkalk2SGhyNXN3dE9TMkgz?=
 =?utf-8?B?ZWtMVmFZSmJMeHd3V09Odk1BMCtHYWVvMTVPVmNyUmRNaFA0anZnbHdHQTR1?=
 =?utf-8?B?Sm9mQnBwSzdneXVzdGl0bVNmMFhlSWlTTWlibkgzQUxKRTlrRkJlUFd6UkF4?=
 =?utf-8?B?cndCWjlDYlBTOFZtUmR5L0pzSSt6MnRoalRpd3ZHdC9nQXI0YlBKQy8vRFFR?=
 =?utf-8?B?OU5VOVp1MFBWdTNHbzRXTlo3L29mbzVHVFRsTHAreDUzRVh1cmhZb0NKNzJi?=
 =?utf-8?B?SjI1SGRHR05qMmJlTldUMkd4Y2Vmd3RqRzlEeXFXcy9RUXorV252Wm0wRDVY?=
 =?utf-8?B?TUtGNEpMVkhKT0NEcVRQOW9qZHpOS1A1a1RvaVpYR1RNRkxIMmpSaTFaWEpI?=
 =?utf-8?B?K1lQQUNKeU9lVEpoa05YeDZkVENjZTd6c3g3TXp3WHlmVWRjRjVua1V3ZFBv?=
 =?utf-8?B?QkkrTTd0ZXZTTGJzZFRqNlZGTFVZRlN5UklaSUw1WHdTdnFsYXhXQ3hwWStR?=
 =?utf-8?B?djhZK0NOeFhpd2hjbUJQekM2WFc1ekxQNUdLUDJHUk1SZStDcXRVc0pMOHBZ?=
 =?utf-8?Q?JH/kMAkjQsH3655wgRMmOXGu+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 841c84da-3d23-4c0b-9cdc-08dda2c8ce4c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 18:02:29.6736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6vVmF+bx8bAk5PhT21Zvt3fCuSaFJLet8i9++GNA/nWsr0cp52mAz5c72NSMeFseOlYoPngRO1ZWi+/4tMWqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6022
X-OriginatorOrg: intel.com

On 6/3/2025 10:07 AM, Dave Hansen wrote:
> On 5/13/25 13:37, Sohil Mehta wrote:

>> -	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt");
>> +	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt", 0);
>>  	if (retval)
> 
> Could we get rid of all these random 0's, please? (or at least try to
> keep them from proliferating).
> 

I had patches for avoiding both zeros, but I ended up not including
them. I wasn't sure if folks prefer '0' when not using a parameter or
explicitly prefer to deny.

> Either do a:
> 
> 	register_nmi_handler_source()
> 
> that takes a source and leave
> 
> 	register_nmi_handler()
> 
> in place and not take a source. Or, do this:

> 
> 	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout,
> 				      0, "hpwdt", NMI_NO_SOURCE);
> 

I prefer this approach. Since we are touching all these lines, maybe
it's a good time to get rid of the other 0 as well (in a separate patch).

The 3rd parameter pertains to handler "flags". The only flag in use
right now is NMI_FLAG_FIRST. Assuming that more flags might get added
later, the 0 should probably correspond to NMI_FLAG_NONE. Agree?

The other option would be NMI_FLAG_LAST, which would be the opposite of
NMI_FLAG_FIRST, but that seems shortsighted.


> where the 0 is at least given a symbolic name.


