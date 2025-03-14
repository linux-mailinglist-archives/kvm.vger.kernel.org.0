Return-Path: <kvm+bounces-41076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FB3A6153D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0977883890
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7213D20298D;
	Fri, 14 Mar 2025 15:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iU0iUlzf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A03A1519B0;
	Fri, 14 Mar 2025 15:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967282; cv=fail; b=rlAZ5aeg82PcMbN11D3Lll+onsEEfj/OSlWRVDkE2YM29pjYWHnjA02H08yrZ5X56uizd4JvS33ijhCJwil6DHph4s9bV0SzsA62H15eADPfV9mvrfqBWvw3iJ1SsP6Dl3llZa3GnJ0my1UjGjq5geMgFGddfAL+cdWDDeZyOCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967282; c=relaxed/simple;
	bh=f/4OUjZq3Phw5pZMgPelpPAR8iVd3Ezn4MypAcnw4kQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=itP2V6FigXVLLwvLK1aW9dl3M6jhCPkUz91Gh33ndx7/KYpPJPGfZgCq98JYVcTNP/s8weyadggZibFK/jvYzV8HQ9y3Arxnzzg0xofjAzeH7dbeUPFyCHUC427zyoX2qPpET13rgf0SmB0eWWi+wYC8Qu+WhSxjW6VSqngFTG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iU0iUlzf; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741967281; x=1773503281;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f/4OUjZq3Phw5pZMgPelpPAR8iVd3Ezn4MypAcnw4kQ=;
  b=iU0iUlzfAq12XdNeE1lh7m/2U1JGy3T2Ngl6N3+0ZyL4fxQKhn19yQbS
   4KR+Z2QyhTErmQlJfQNVTxnVpwJ1VfIB4aD8nnCL3Jvk1zU8Pf3fhRRpg
   0geQC1vVBcmpNWBHA0stEX+6Y1HKVSORarI/iuCoMI7NyCnhsXv6nSm5H
   8TZ5aiEn8BB1dK/SmVfkDhtLzkDZ0Qk1sFlfPcXV0KbIyz7Ek1zO+UmeE
   G3XaZCmxaO5+WBTrdAWAjYmZxhRV4wGoEHAHKyDErYKK2BXsOlLfQXpkq
   qEx2ZD/kPdeV5KWAWADRI6YgMeToq5wBMXJl/bQLIyc1Vwh4dS3vjpjpY
   Q==;
X-CSE-ConnectionGUID: iEQtlcygQrKDqCfq7GSyaA==
X-CSE-MsgGUID: M0e1pDdgRMmyKSoh8sjoDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="54119140"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="54119140"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 08:47:57 -0700
X-CSE-ConnectionGUID: pCoccY5BQHm0AW50A/B16A==
X-CSE-MsgGUID: ADbQbd2kSG+xsBAraFIvHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="152200861"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 08:47:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 14 Mar 2025 08:47:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Mar 2025 08:47:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 08:47:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YigL11isoBhjbVFixgbqCYOmCT0gWVMx8YZ3AqxQEgquQlxJ47M95KJAfysMFlVpI/XlshSIjatj+YRYa91Auo+/Jxv//JLIX61vW0mcPiQ2mwYeX7f3KH80qizu/3rOAZ06tlwk7jrp2X/thlTDDIF1jqQHjMGDHIHJcoUQPm3oMKX80/VslPAxzevZ4+3ylRfhot5iFp4V0Z3fzRb1T4AzcwwAAywGwIUttjCxNrulSV4LH2NuFysJShFNTHe47S/ftRGGDdD15yeE+WKi8joRfxrVkyYEYR5MuEesA1bpsLd7gm3d7Ch0/fSv/pvoirqsAgiWV6xndDUgTcMJxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/4OUjZq3Phw5pZMgPelpPAR8iVd3Ezn4MypAcnw4kQ=;
 b=CEWM6zSECFVwtORNi0uoEVk4KbmVNPYmtARDynQIRXGtlm5GbHpz9m5WYma7fIRWfG7o16sRvUHjrY8UPc8wzAjuuBfaO9fsNZYMKkyra927pQ/X4tbzSXk45Zz44hS6xDqcTDiqfrPikUxxQJ6+Hq6X0Ilalh8mrrHT+YNiHKC1X/UXFMQIyMDm1OWx2f+SULHdIvV6YRlTcR0e8rYNI0/4N6oBDXn5k9Et5wTdpfYu+qbIPdwju/Xt+fuXQGEM+6UC3aXzjCkOrzMBdsIPnrEL1KilGFLkmV0njRCj6obVbsy9sZZZ3KAk+EkOFvuNG3T9MrPhFsNgJZ34IIrAmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SJ0PR11MB5182.namprd11.prod.outlook.com (2603:10b6:a03:2ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Fri, 14 Mar
 2025 15:47:49 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%3]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 15:47:49 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 2/4] KVM: VMX: Move x86_ops wrappers under
 CONFIG_KVM_INTEL_TDX
Thread-Topic: [PATCH 2/4] KVM: VMX: Move x86_ops wrappers under
 CONFIG_KVM_INTEL_TDX
Thread-Index: AQHblE5vm9uREjrWNUysvtmADZQd+rNx7OaAgADbXAA=
Date: Fri, 14 Mar 2025 15:47:49 +0000
Message-ID: <2f0e07c5cb49a50757315f330e26a5c7517116fa.camel@intel.com>
References: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
	 <20250313-vverma7-cleanup_x86_ops-v1-2-0346c8211a0c@intel.com>
	 <d4c19589-baa4-47a8-8d3d-bff10ba6aa64@linux.intel.com>
In-Reply-To: <d4c19589-baa4-47a8-8d3d-bff10ba6aa64@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SJ0PR11MB5182:EE_
x-ms-office365-filtering-correlation-id: d7f4aa48-8902-458c-be67-08dd630f92c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S1VIWmliZFB3Rm5USzFQRE8zREYvYVVlZFVZWnl2QUIrQmJYZlkrSXBWSnpw?=
 =?utf-8?B?d0xCQWZWekpMUTBkOHFGdVNxeHhCUEdvaWRqYk9nVE0xaXRkaElqUWMxN3RM?=
 =?utf-8?B?dWUzVGJIbnFnN1NEMitXTk1BMHZuOTVNL2VYRmxoQ3BWNXJCM3VJaERqMzNU?=
 =?utf-8?B?TEgwYjJvWjRadEVmTm10YW12SVVMNWcrU3FCZC9oeHBsWGlEd3daRXZLdEMv?=
 =?utf-8?B?YWJiTFlaSXh1L2M4bkh5K0xCYTIxMWpHK3VDczRMT3R4eHQ5VmhzeXJiZ1Q1?=
 =?utf-8?B?NGtNaWxScEZIMUg4bHpsU1E0dzBVSnFkMkVFR0JHd1hHMEhyRGN2ZzROS3kw?=
 =?utf-8?B?VGZtREMvV2lScnlIMlZKNGRWZWZRVGUyZWVoTkN2bTRWWCtnRm1ZcXgwbkpj?=
 =?utf-8?B?RURkWGk2TC8wcFlGMXdhZkxJeTQvS0pwenh6SDZqZ3JiblpuenBIOFRxdHBV?=
 =?utf-8?B?OWQ1RjM3WllCTlJtS1pzdDBjTXEyNHRhVkY2UXZ3UDZvdnhNb2x0VGVvWStn?=
 =?utf-8?B?cUcyZVZianNBWU1rOEhGTUZuRmlPUS8xU2V5Rk9YZXdDeHhkWEFUemN6QUtC?=
 =?utf-8?B?NUJhY05KTkNLWmM5Z1dqVkU2OFF5NWtiZ3NUWDllbUlLTC9IWkFnUWxPVTVy?=
 =?utf-8?B?d1B2WUFvVGtHMDVYM1oyZkxhbS9QWGFFaXhueUViNElGeWJRRU1KMnNMZ05i?=
 =?utf-8?B?YTg3L1Erb2lsNmZKNGRZR2tPdDlCM1JtcGlNVGJpeC8zbkIzRlpzNUQxYjEz?=
 =?utf-8?B?dUM2VE5kSWdoQzNPaWpoNWRnNm9FdVJuOC9YOVNlV2c4RzhpU3RnNlRtSFUz?=
 =?utf-8?B?QkJKMFk3eW1VenAwczFOVG5SNnFURzRCdWZpdHZqcU1XbTBjc2VlZC9CTnh0?=
 =?utf-8?B?Ung0Z1ArZFhSRVNoVnRFQnVxZW1McGgxcmVuUDFVM3pKMzN3czUxMXRsTkRF?=
 =?utf-8?B?VnFpT0MwNUhIRlZoTWpNN2JOdTkvb29FdHptSTdVVUx6RGd3YUw0VjdZMEdC?=
 =?utf-8?B?dmsxY2F0eWpnQXpoVGI3bUlLYkpyeEhPekFrN0lGc0kyWWl0TmhMc2pGcSta?=
 =?utf-8?B?V1BudEE3MUlFYjI4eWpEOTVyR3BPT2tvdFpOeHVJdVZSWm8vcGFZMHZGVXQ3?=
 =?utf-8?B?OHl0NTRzRGJtZUw0VkFLdmdZRHVRVlZxMlZGREdOWGg3UXJhQUNIbVovdjho?=
 =?utf-8?B?emFVY3pMcFBWY0FvM2sya0xIWUZkS3NWMXRIYWczOUxwNmE0VTlXeE04Y25G?=
 =?utf-8?B?UDl5RXRuN29ROERxcURSTlExdHVsLzdWdjlFd0U5YWpqeTc5TVBFcksxOU5Q?=
 =?utf-8?B?bFpKMkJiZ1lwazA5bmR3QjQvb2hQSldjcHh0Rld6bDg2akVMQWQzdUNtalI0?=
 =?utf-8?B?VUpTS0RZWDNLN2RlcnlJTlIvNXQ2ZE9JbUJnbkJQZHloYk0wdGZlRGg0aWJo?=
 =?utf-8?B?M2d3ZDUxbW1lUDZSWnZWdTVJOFNPa1JVN0F5UmJuZ0JadlJXUWdaK0l0TXRs?=
 =?utf-8?B?bFBHV3V0MjdRR29saUwzTDk0ekpvUzUxRHNrUWRpVmlyWjV4cmxDR3hVMFpM?=
 =?utf-8?B?TjRRdmowYTZZaytVeU5Ib1N4Ym0rMXBNZWtRbFU5U05LODVoZTFTRmdiVVVk?=
 =?utf-8?B?UVN6R1kzcmh5UG9qZ2JaQWQvM2lOQ1lVUGdsTDFrNks0b0U0SlM4ZElRK3Zo?=
 =?utf-8?B?RDZQeWVDTWxEbEMzaFp6TTJZVWJRN01TV2c3djRGYzNYSkJZTi91Zk1CcEhZ?=
 =?utf-8?B?c2lha3lzQWlpeHkzL2tOVHdPWVhYZ2xCT2ZvMkk1bkVaeXg5dytOaEFzSEwv?=
 =?utf-8?B?TFArZk5xbGZBQ3FtRnBickQ2bzh1ZytTR0VIWkllbWpCOHRmdWNHekZKRDda?=
 =?utf-8?B?SlozMUllQjRjdVdPQmpkOVFsZFRIelUxRFIyWE5ZYXRKY092cGJuckRkNnBG?=
 =?utf-8?Q?Mae0lvWVydsYFRo3pYDPttHRmmugMS0l?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVJmYlE5bzMrWjFzUk10dUIxbzluY1M1TUdTZVlzNVhTMEI4QUZTYm5GeEFL?=
 =?utf-8?B?Zk5rRjFUVFN5emVRVXBUVjllUHRNbU01ckFKcHBvRGxDYml2SllIb2p1dVVY?=
 =?utf-8?B?UGJMcmhGSDZUbDZIQnRXc043ZXF0Y3RUdHoyZ2h1Qi85NDBBZGtSc1Ezd1h6?=
 =?utf-8?B?V1BZZHl3ZjNZdko5OWUyREZOZm1yQ1BOWWFFREFPajI5emh3N3NZaU0xSzNS?=
 =?utf-8?B?b0ViVnJXL0kzNTFVMTkvTGpCZzNJL0FJb2haQW03Y0pleE9nS1hzelNId3dy?=
 =?utf-8?B?WUhlOS81eG5MOTVrbHpnODRMRng1dzNrNmJpZGlEQ3BtcnBBL01tYzhiZU83?=
 =?utf-8?B?MWV5WGhFMmdSdlV6N3dKR2lVaEtJUm5SMDNCRjVSSm5Kb3dRMC81SDJjSkVT?=
 =?utf-8?B?L3FnaHhFTDg5Q1JCeldNdmFEcE5iNysrQXRFZEZKMGY4VjV6NHBFbkcvVXgv?=
 =?utf-8?B?elA0UVQ1QmZQM0MwYmZTUkJoOWxoSlk5ZEFJaHNvb3BIb2QxSUFuNmZtVkFF?=
 =?utf-8?B?MFRlMGN2dCtpVG4xQVhNSWIzL0Q3WjRSMndrdVk4M2ZVbkZmTDlUQ0s2K2do?=
 =?utf-8?B?RlVKZHk2cjZ4c2t6N1RFMGxsQWl0TFZFbmN5KzVRMWJCM1JWaU9jOVkxY1Qz?=
 =?utf-8?B?ejhKRUpudFU3bzQyU0xVbVFMWFlkQk1OTDc4eGhYNFlvSjRHQTE4NEdxVGhE?=
 =?utf-8?B?RTJlTjN6Y2tKN2xXdElhaG1iWGZ2NEhwdmxtNEtHMzJZZk5vRFgxd1kzbkJt?=
 =?utf-8?B?VjBkRktQSmtRSTdxRDY3bGJpcTlKNU1xYlJaVzdoUGZNWUxyMnVVdFlmVTk2?=
 =?utf-8?B?MGlyTVUvczJKU1NYOXJtMWtrS3g3ZUlNR2lMWWZkbFdIVzY3Q3ZkOTV6R3pr?=
 =?utf-8?B?U29TNEpSQXEyNEx6aW5TZ1VRQUFYVXEwbUJmYnRtTExYc2oxMG5LOWpkQi9p?=
 =?utf-8?B?dDhIQmRlNnRvRTZnZ21LcFRYYjRXejFEc09kTDZqUGs3YXBXa3QwOGovUzlP?=
 =?utf-8?B?WnFzRnhxUXA0SjJMam1YQkhyK3JiQk9rZXhNak5zQnB1akZJaldKQVhWMGM3?=
 =?utf-8?B?UU5vMHlFalBTVFUrZTdvMVU2Q2FvK3NwZ0dPaGdrWmlFM1lReFRjVzlDVWNF?=
 =?utf-8?B?TWIvb0p5WWFySEpHUTlYMk9IODdqYWpRTHR4cXhEQ0REc3dvNVA1NmNaU2NJ?=
 =?utf-8?B?NjhDY3pRdSt6MnlNZS9xUkxLMWNWSDJjUHhnY1lMdGlyWVZuUmpGVTJSTEtV?=
 =?utf-8?B?NFdRRkNxbkJ5SmZHaDdXVlhxa2ZBWnNYU3k4N3p2ZUNIZVBwUzRxRVpxWmhH?=
 =?utf-8?B?TEtnOEhBMUJBMjdYY3lDZ05SYlV5S0tISDVaNHJBRVN3ZFlPZjVBU2pMb1NL?=
 =?utf-8?B?Z1YwNjRXRGtRTnIrS3VaR3pyMjVQeXFYNE9MamdyRFJmVzlNQmI5K3A3VnRp?=
 =?utf-8?B?bjhMSVYwNDFoNTJDRWJ2aDN4REp0SVlyT1NBSlNSUVlTdWQzMTd1OFZZUjg1?=
 =?utf-8?B?czJWQ0hPTEdZR2FNa1ZFVjUweWxyVTBEZjJtaDZ1SmFldnlaMm9NcUhta2t3?=
 =?utf-8?B?dmZ4ZnNqdmlnK2NaRjA4U3VMRlphUWlxM3NqMHBmYnRPZDlHU3UrYkp4OU1C?=
 =?utf-8?B?MHRYZEU0WExEdklMVFNYYkNuZ0dYZWI4YVF5dGpEUDh3bm1tVnkrd3FKYXVv?=
 =?utf-8?B?Rkd3TEJ3T0FNY29XOGpPa0Mra1NQOFRJQ09wNXI4eEZPUlRlOWFqQjZmd0gr?=
 =?utf-8?B?dU5RSWRsZGNqWFVnUU1PRnlxc2p5V0RoQ29OQnB6bnZzOHFXeHRHUXRGaUVU?=
 =?utf-8?B?YzQzUEQzK00vN0hjVi9zOTlRK0xaVER2UjlsR1hDbDljNkUrc0h1K3gzM2k0?=
 =?utf-8?B?RjhnTVdOZEJKandwQXBZSlJIUGRxaFRQN0ZSZW5PK2VMcjMvS2dxcm14dzhv?=
 =?utf-8?B?QmlGWkVaTlRjdE12RjYrTFVJL1Q2VHdnM2ZFZE85Z0pPdDdZUWlBb0FFTlhj?=
 =?utf-8?B?R1ZDLzVuUm5hbDgzV3FpMjVoVE1KU3A2M1FPQ05wVlUzaXlNRGtpQkxtOEdC?=
 =?utf-8?B?NEJ6MWNRVE5qa3NSdUVRTld4bWU0cElBNFRva1QwRXgvTm54TW5TTUVpRUFn?=
 =?utf-8?B?TzllbTh4WEZzQTZXODdmYjgxNHBpRk43MHdIVW5aWUZyeklvZGd3TmYrc25G?=
 =?utf-8?B?T0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C61AB32CCCB7B54E93EAF8A167A1267E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f4aa48-8902-458c-be67-08dd630f92c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2025 15:47:49.4254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D0WmkoqV2G1I9LFF0yEHvA0IaaKD3/CH2M3UkOt1SzPdHejqwEatgIhXOcd/om3iJ26cs9W625jBDkpS7IkASa3iKR+Kamm1YnjUWV0aeSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5182
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTAzLTE0IGF0IDEwOjQyICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiAzLzE0LzIwMjUgMzozMCBBTSwgVmlzaGFsIFZlcm1hIHdyb3RlOg0KPiA+IFJhdGhlciB0
aGFuIGhhdmUgYSBsb3Qgb2Ygc3R1YnMgZm9yIHg4Nl9vcHMgaGVscGVycywgc2ltcGx5IG9taXQN
Cj4gPiB0aGUNCj4gPiB3cmFwcGVycyB3aGVuIENPTkZJR19LVk1fSU5URUxfVERYPW4uwqAgVGhp
cyBhbGxvd3MgbmVhcmx5IGFsbCBvZg0KPiA+IHZteC9tYWluLmMgdG8gZ28gdW5kZXIgYSBzaW5n
bGUgI2lmZGVmLsKgIFRoYXQgZWxpbWluYXRlcyBhbGwgdGhlDQo+ID4gdHJhbXBvbGluZXMgaW4g
dGhlIGdlbmVyYXRlZCBjb2RlLCBhbmQgYWxtb3N0IGFsbCBvZiB0aGUgc3R1YnMuDQo+IA0KPiBJ
biB0aGlzIHBhdGNoLCB0aGVzZSB2dF94eHgoKSBmdW5jdGlvbnMgc3RpbGwgYXJlIGNvbW1vbiBj
b2RlLg0KPiBNb3ZlIHRoZXNlIGZ1bmN0aW9ucyBpbnNpZGUgQ09ORklHX0tWTV9JTlRFTF9URFgg
d2lsbCBicmVhayB0aGUgYnVpbGQNCj4gZm9yDQo+IGt2bS1pbnRlbCB3aGVuIENPTkZJR19LVk1f
SU5URUxfVERYPW4uDQo+IA0KPiBNYXliZSBqdXN0IHNxdWFzaCB0aGlzIHBhdGNoIGludG8gNC80
Pw0KDQpZb3UncmUgcmlnaHQsIHllcyBJIGNhbiBzcXVhc2ggdGhpcyBpbnRvIFBhdGNoIDQuDQo=

