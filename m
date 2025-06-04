Return-Path: <kvm+bounces-48358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53432ACD52D
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 03:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F08AD3A33C0
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 01:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279D886337;
	Wed,  4 Jun 2025 01:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aGonLAW6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F354683;
	Wed,  4 Jun 2025 01:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749002169; cv=fail; b=Nv7OSsVMtTegM66JpPw6iWFdaZHA0Gm/mDFbnMiAsOF0x5cOgCPxrGhRDevRQj4kXxwHHnsRE0tdTe+qmf5AqVeD+V9ZpRB8WGpWlhCOQEHwwyhdvCGdtXqTpBrSHio4QRyhBuZC4DONrLpGivW9BZ+jTH7peIhvVdO26L4LmSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749002169; c=relaxed/simple;
	bh=4V1j/1kkYdO5EBuoT1qvFUgwapt3XlfhFUQ2ul9OW5E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vAVusTVldjy+HG8rNu2N8Uq9TzB/F6QU/2IWtxx+4dbZVhRYTph8g/nyZJDMxHpePme5PAwxKKQTVgzwiarQUqXGSPKGdu54I8Osw9YKgUpuda2yxM3Kz3G6N/UlAlHrCQs/Il4wR2O7uTi7ahWquDMETGrineNW2fOmbuDRnVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aGonLAW6; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749002168; x=1780538168;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4V1j/1kkYdO5EBuoT1qvFUgwapt3XlfhFUQ2ul9OW5E=;
  b=aGonLAW6eq0vXV1oCrbLBk6q3BtpymyqSS8fzBWIMkGFwHMKee/+xlSx
   cPdGNdMTzPgO6swh+f0CbMDLS1S0a1FpKZIeYvZ8NfDPYQD/8WzTSXjO6
   KV9lj6mBGJLfiHaH4uDTt/zcTAwZwij8TqoWT01nTV+JPPdTv+XFNSxtT
   1VoxjExBufKs9+6hMojGo5dtsZ1aU8EW+hVugXJGffi2x+EG3ZJRgoyro
   Z+Zl4dNgDO9cwykrtCKKrB6qUshlTWQdK/sqXCyeLhYWP34ruIeTyo6uJ
   BlhCkJwVfns6A0IWTuk+lYwzXX5J7GWj6RU/IwihACGQ+zr6e0aop9Dsm
   w==;
X-CSE-ConnectionGUID: urNuKZYwTFKMx/RpoMMg0w==
X-CSE-MsgGUID: C2XhWjJ6QCKMjuT2AEEGPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="51161529"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="51161529"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 18:56:07 -0700
X-CSE-ConnectionGUID: disMcCqLS3K5xauwbEVq1A==
X-CSE-MsgGUID: w+4kmFyNRKiQvAhnQ2qzTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="148873865"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 18:56:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 18:56:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 18:56:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.59)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 18:56:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=reHwlm3tVbgCRSAoe6Cm6iq0HKF6y4yNewmVS6y2XlD38glWbaLnJ9BKh7mf+6WEy3a/2BJNviUCBwOpk7SwD/1nhITx6STGqx+WVLuxSZYtd36y/xsPRZY00NFOEVp2vUlXVwfitcYhcPGQvx0xbG0p/EjqpkI0Cmmrfs4kX1smMoYv6BQdzufghlckzNOrgUyaN5t3P/r6XSqy/3fAOegcW9Y1ohIlMBeL1QH+xysnxD1iwBK2H7HCcn5hLAEQnwLq0SmJF0Pp1js987t35J6AJRDDCtYroRIMOPDWtxnUtXv2SAW61SRD+Y8ExotSyzxVvWphBDk4UAOsqIMVZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DL/Fz3TJRpObRBxQNPlhrokd/ZmCNuF2278g7yEdRpA=;
 b=RAD/kLzZT3x1XUEyUUbXm9pJh7LkeK+JdS9zISPkv3dak4tASHNcXF59tTJzsGfUMDLk6La7ChOXsbRLWeNHFycb8bruQzwjAUN48jLOn9oWkpEQO2FR7mV0sZESZMm0JTPYaLt4tcLApMi5/qBNA3HvW8xk3i3WaZBbOFMDV6JvZELH8qZNXWNXn+rM5W1qnPQ3dXE1GF/+A3grCRM5A9H+SAUGoSENStutIEOBaeoxNzLaQLu6rPfyyCSOUOTSFGnNO1WTK9W/aTKFX6vhdg8gD1QHNAd92YT3PX+I9nb2SiFZZ1XfLho4E9toNz3CJ2cXG9mIf77Zu3HeVatEhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by PH0PR11MB7446.namprd11.prod.outlook.com (2603:10b6:510:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.25; Wed, 4 Jun
 2025 01:55:58 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 01:55:58 +0000
Message-ID: <fa948d41-3f95-4385-86c1-5c115561b939@intel.com>
Date: Tue, 3 Jun 2025 18:55:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 9/9] x86/nmi: Print source information with the unknown
 NMI console message
Content-Language: en-US
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
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-10-sohil.mehta@intel.com>
 <31507dc8-b1dc-4df3-bc0c-6958b4218746@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <31507dc8-b1dc-4df3-bc0c-6958b4218746@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::6) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|PH0PR11MB7446:EE_
X-MS-Office365-Filtering-Correlation-Id: e1d616a0-fc0f-4047-dcc0-08dda30af344
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXBnYi9KRVNyWlFDOGFqZ2lHUy9iVzNwNmMxM051K0J4NkhFNTl0cmV4OE9o?=
 =?utf-8?B?UHZ6Z25RdDNaTnF6NzVPc1JTaVpXaTlVcFlvQ1lHUkRtSFdPbVlWVFg4NGh0?=
 =?utf-8?B?dmFsenZ3RkZnVjFNK0tPWkxXTHFHZXlIV2xWV0FQQ0EwMHBKQUZyNUVBNXQy?=
 =?utf-8?B?L2VRWHFtUFhpN012QjdzbEF0MUt1U0Y3SHJwVkJ3RVBPYnNMZWc0dlpMUExu?=
 =?utf-8?B?b2FBSmxpdHB1N2NWREh6U2tqY3pFcUxRUExEODJzeGNFV0N2OGk4L01QYnV4?=
 =?utf-8?B?QkloVTJwNk1qRHczYTBRVkl0NnI0ZDZEcVFHcGF2UFc4RW4vam5pNDBUQ3JR?=
 =?utf-8?B?UUV4Ym1QUGw4S2JiREZhL0RRa2E2blJ1TU5NN3dUaGZWVGNINUljRUJMK0RW?=
 =?utf-8?B?SnlIcGUxb3FoWGNxeXdTSkhPbmZsTWRJdXl4T0d0RDhjSDBKVVcwNkN6L091?=
 =?utf-8?B?bEExTUwvYytSUjZYOFE2U3BxUlgxQXdyWU5temZqTlJ5SmJkVlJzRU5kNEo1?=
 =?utf-8?B?L0htUDZNSGJ1b0ViNW50L040WFhMcWtHNFJzaTdjUXV1bVM3dWM1LzhxZ3Jw?=
 =?utf-8?B?R2xmNVB4R2E2RzRCV21FSVExQVIwS01mMlVzQzJZb1RrbFBpKzdJMU5Gdkox?=
 =?utf-8?B?eStKQUhiQ1FLQWxuOXJROVpoWWw3Y2RoS0VVUVVSK0p0cWxhWnUyZEtvVjZK?=
 =?utf-8?B?V0p2clAvbk0zeCs4QkIrZTZ4Nm5xOFYyUExRa2ZPNjc3VFF6by9jVTR3TG5V?=
 =?utf-8?B?VTRUa3FxWmN3NHJLTlRmc3QwTHRCUFFvUzRFK0xpVDlNMmU0WjFmMHF4Q05u?=
 =?utf-8?B?T0IvQ1dicVc0Qk9RZWRWclRKS2RmZE44YmNPQzYydHdjclFwMnJmeWZvM3gx?=
 =?utf-8?B?aXgrRENqbzBRNVFrWklzZ0R6QUU1M044M0RwUmYrU2s1a1hnekh0bUtRZVZP?=
 =?utf-8?B?ZC9mL29TK2t3SCtSQlVJTHlGK2x4WGJab3laQkdEOXhGVUF3UnRXQjVSMHdw?=
 =?utf-8?B?VE5kZVhKaGlqZVBLU1FiWkpzdDMyT2Y5ZmVTQ0gyZkZQVThaSDVNR3N3L3RB?=
 =?utf-8?B?dDRyYjNFUDFOeldGZzVuMS9FYmpWQTFVc1RpUHJ4dTZsSkZKWjI4bEN0NlJu?=
 =?utf-8?B?bVdnM2tUNCtSc0pLS1d2OXQ3VEZqZVdCaDZNbkx4dU11Tlp4YVpETkE1Ulh4?=
 =?utf-8?B?NFVEU0VlWHk1UHQ5NlM0dGszWlVlZWVKMWdBd0JWMWZTM241YVFwMDFTbnpF?=
 =?utf-8?B?ZStVbWdXaGdRa0VyNHdJem0vaTVsTWNoRk4vUU5xc3ZGK0hXODRmdTRVdW55?=
 =?utf-8?B?TUNJMVEvNXRrRC9UV3ZmNklZQ29RSkR6d2dkaHo3Y0wremlrUUM4YjhFTzEr?=
 =?utf-8?B?OVdsRklmWFZnSFVZblBjck1QTWtmWlMyaFdIYmZwQ3A1YksrSktLb1JhcWtt?=
 =?utf-8?B?WDNyaGRiWGhVYWZnRW9mRnhqS0QzV3RmbkZzbi9DVllyUktpTEppclVGRFUr?=
 =?utf-8?B?VkZhMm5vZWpGVExDM2N0cHpvWkRvc0ZBZTVxOVU0SjU1bGpKOHJzYm1sUmky?=
 =?utf-8?B?TjNYK3ZkRTdabW55RkpkbE1FNFhXVHBvSU0xZkNUWCt6L0h6RnVTSVV2alhT?=
 =?utf-8?B?eHhRSW1qQXRtaitYKzNNSkM1OFFaUi96Slg4SysxdUdCZnY0VGhHSEFzRmN2?=
 =?utf-8?B?bnU2bk4wZ25CbmVKaTBSZlBsNmxBNVlYRzBUMUhCbCtWU0RMaE16TDZBNFVC?=
 =?utf-8?B?Wlc0QXRETE00UkdCaW0zVURYVlptam9SLytSeG1yUVl6TDNVYzFrQmdBNWJs?=
 =?utf-8?B?RVZqdGtZckxwcnAvSjE3MVBvUXhqUjJRZWR6OFA3c21PS094MnRIU2lKQWZz?=
 =?utf-8?B?b0xJcThJVXRMKzRGcVA4SE9jcTAzVDBzbXByc2phOGY2Z0xmNE5xNlJBMEV6?=
 =?utf-8?Q?4cs1i7g6GgA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFR2M2lONWExaWl6eHdCWG10ZnExckJRTVBKM29OTWpOdGJhNzZoRGJ4Wisw?=
 =?utf-8?B?RnB3aUxVK1JicWVMUjZhcWlDWUM1UmFzOHJ4KzBueEFRNkM2WFhtMVQraGtn?=
 =?utf-8?B?cnFhVkFWa0Fmd3hOOVhVUGwyaG9XdUlGbDVDb0d1Qzlia0FKMXZhcG9ZTEV1?=
 =?utf-8?B?bWZnSVdyM3V3N3hIQzVCY2IzUEVXNDRTZytpWmJUdzY5aWRlY0MrOWhrcmRN?=
 =?utf-8?B?R3dqemhQUDAxZEN6alZpY1RWQzROWE16MmVLd3JTVnJYTXloandCSFRzUGNk?=
 =?utf-8?B?UXVyRzcxM3VJQ2N5eDJoL015N2dsLy8yZXFQenp3YkJJYWEyV2FNYTU0djdh?=
 =?utf-8?B?T2NnSHhRQUlqazl3dW9IMzZpQTVSd0ZYckFvRGJja1BwVW1YeHoyRU9VN21W?=
 =?utf-8?B?MS9KR2NaTW84T09lMU12cXNDc1NGUjQ2M3V6N25TeDE5MUMyT2xMZk5SMzhK?=
 =?utf-8?B?d1ZndWFwdnFQakFWekdDaVB2K3N3M25GRnFLMkVMZjE0SlJLeEVScExBVzNL?=
 =?utf-8?B?aHRZcTBYNzRQdXgxZ1pEQUNZMU9tTVhEcHhPMDc2RGo4RlM3OFAxZUM5NW1l?=
 =?utf-8?B?Qy9DcS9GcnovWjdEVUd5SElWRW9PMFBKenBRU2pTRzZDRXhIaEFGUmJHdHRs?=
 =?utf-8?B?M3hzaDJudFAxbTF6em4vNVZpclVGUzNFdTE3Rk90ZXhNYWM2VzVSWFBqRWJJ?=
 =?utf-8?B?UkwxRTMyckF2SFc5SEh6OVJRN3Q1WDR0WkFldUFLeG5xSnAzQnRKYmFXak9o?=
 =?utf-8?B?Q2dEdUo0bUlPRWZDTjZidWJ4bjJINzVWK0x1QjlEUW9sQmU2MCtZUUFSWDk4?=
 =?utf-8?B?eGYxeENyYisxUWJKRi9YcS9qdEtyd013eWt3VjFTcHVyMitGaWwyTHpJUExn?=
 =?utf-8?B?WE5OL0N2NHBCYTBYQVZmZEgraFFqa1I2cWs4cWFzaXluQnlCWFhSUS9VdWFP?=
 =?utf-8?B?SkRPUmRBaHpVS3ppYW1oekdiTlF0aHJZWUlCV0Joa1ZuMVAxdURRcXNobmJG?=
 =?utf-8?B?NENSeWlqSVUweWtsLzhxN1NSUkt1K0k3MWlsem90aE9XVW56eXZoQnU0Yk1N?=
 =?utf-8?B?alpseDNqRWtIVW5tYUdRVHFBSUY1K0dLN2c3NVNibHRmN25aS3pldzQwcjZI?=
 =?utf-8?B?UFBscTdVVjB3SzRHT2Q4Z0FVVjhjQ3BQV1ZzeFcvU3pEOVFvVGoxMjR6UlZu?=
 =?utf-8?B?WUJ0eVFsRWpaOE1ZbjR3Tm1zUWxoQktVTytNZng1SlpJUHhRcXZJeDk4dG55?=
 =?utf-8?B?dWVZYUhxRkZPVFNrQ01JaUV1OHk2QmFVZTBQdzUxelFSQzNURXhwRTBLZEQz?=
 =?utf-8?B?bkVlNExseS9LbmxhazlMemhRSVdYNnZXRDB1NU5OVFhRY1Z6OXRyVGV0eUlQ?=
 =?utf-8?B?UXdJUjQyR280d1Z0OTJYR1B2aGMvdG43WjA0YktFampvM1lQdW9QbjhhbXhM?=
 =?utf-8?B?RUVPRjluNE5ESkt0ZjRlYU1BZEdza3hSaWpXWWNPRUVSaFNHNENQWUU5QzdV?=
 =?utf-8?B?RFdyODZ6MCtPbmRFWG9ad1l2U0lEQVdLMFVoUmtaWHIzZnFBSlk5WlhDZ25q?=
 =?utf-8?B?Sk1lZHZSWXVSUWRab1RsdmlYRWYvOUloMnk2VFp5RHNwcm1xdW5QZE1ITWtm?=
 =?utf-8?B?YjFyaW1OVmRib3FvRFNyMFhMSEF4eXFwdnR4SkRaaW5CRzg3cUFRNE94MzhS?=
 =?utf-8?B?L1hPemErS3d1ZTJJak9zcUNUYmhZakxva0J6V2tiS3J4YW1PZ1I5TnNIeVN2?=
 =?utf-8?B?V0Y2dzVGdmdvdU5nMVlqVmw2bnczcVAvdmEvdzdyaGZOK0Y5UHRkNXFQM0tC?=
 =?utf-8?B?WWZYS09peWZiN3hGbkMxSHhLZi9qL3BhTjFwRHZTeUM5b3FDUDVCYXlXL1Ix?=
 =?utf-8?B?MFhjMFFPOUVxZHRwOUUvbjZqbkRzVk8zVGQ4aEdXdFdjbkVRYWdmejRlMzM2?=
 =?utf-8?B?RkU1SGJndnpINHQ2ODFQcExTT1NLbmdGYWNqU2MzZmVpbC9kMTJBRXM0ZENK?=
 =?utf-8?B?ZkZFSzlaVnlWc3J1V1BndThKT3A3akxwTHl4dm1zMUVKTTZTa29yQkszZWIy?=
 =?utf-8?B?Um0zeTE5TTQ4aTFJYm9vSWRQZDNRcFdlc1Y0MHJXZEtKQ1ZTVDBsZ3dzbUgw?=
 =?utf-8?Q?Ys9Q/AW0C50nnlwHHGsxavkm/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1d616a0-fc0f-4047-dcc0-08dda30af344
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 01:55:58.4229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63BqszYee4wYdX7n7oJjbesisGT1OHiEukzA35Lhpa78Xod4e+cNzlETz0Ef379wv9jJyczz+XKY5omhkF7a8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7446
X-OriginatorOrg: intel.com

On 6/3/2025 9:55 AM, Xin Li wrote:
> On 5/13/2025 1:38 PM, Sohil Mehta wrote:
>> +	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE))
>> +		pr_emerg_ratelimited("NMI-source bitmap is 0x%lx\n", fred_event_data(regs));
> 
> "0x%04lx"?

Yeah, this would be better. But, it might not matter now.

Based on the discussion in the other patch, I am considering printing
the source names rather than the raw bitmap.

