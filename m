Return-Path: <kvm+bounces-70821-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICbWFYrWi2lCbwAAu9opvQ
	(envelope-from <kvm+bounces-70821-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 02:08:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AC06F1206B9
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 02:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D110302DA14
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCC52765F5;
	Wed, 11 Feb 2026 01:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vl3O2iyg"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011069.outbound.protection.outlook.com [52.101.52.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779171FDA61;
	Wed, 11 Feb 2026 01:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770772091; cv=fail; b=O1VOIKlc6y+QZtFKEBQwjqDWv1KkZekIZE4EI2LnQQvNOHvP46I91EIOb6jCgf+3cdrRNMeNa2aiphTUBK6R9O0WHMNOlBlHhFDQRlg6Oav9UoJOBFqXb0iaekhm5ZpF1cvdBxu2r9Agy0+YEEX2QmQCcId9ROv7qIwRj9oILnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770772091; c=relaxed/simple;
	bh=1+R3edJ7I4ypNdqm4RDXt1DhG4zQ3uEgC+e6KwdWf4A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y+VWAyMe8EhGxRnpP7D7ARhLUE5+RUb1oZW1bbrUKGhd0awVWKIS4t0JieqO3Rsk4T5LmYHhBRi5HW2+/u2GU+xT7Bxf+f+G+oacfCQGMtDBUnThOu5IfRvilG5vwLjNyz4Q5o0Rhy7n5eIyn/d25g8ZSQ6BRja6m8DIhszF51M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vl3O2iyg; arc=fail smtp.client-ip=52.101.52.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gdc9DH6tPzO+93Abowf4eKyHSDtwi4AJ1wOvNLVd/kNpsC/WFakV0rDM3hAV9IqBoDJDY3FbZceG+rIZi66oleZltmg50/ylRkjIXmlDCpFlCS9e7B8jaZ45EEKPpsVB/eETm86lkm4lTAKNKHGeH8bdwd+RCHYHrqdLTG7O0WFVxEJ6znjaDT7IwX6Tj8D+t4PAVbMVi0QI6+1OqrOFK3UHwukPmQZL0rehm92llYMegn4w3N3sbmJSTcxHpvMl/9clgJfXKAxkSta0Aq4GWU9dKNjq9UTYoY96HXbF31l+IWVczZKCohjR3KMmSIbswyEiJcF0OemAxiS+TT84nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTCHFP19c5Z8J2jonw7OSwe2Yas+VaNbBmPmbHA9Lo8=;
 b=y7ENNmB8QDRXxsLpXo+S9Ydn3ySR+mOOIwAvztWBjp09Ssc2qceFanpyjAQ4UU+FFs//SciJlZ9jHqNmz4q1OqimVJLKX03NY/53lGyFQ48qiBwxbwK4WKW/kmUj1hF1qeL6wUs0CkO0ou7YObGuyOPAwDDfwi9PM6THzExWZcnmC6EwYUKdtd9sAF9ONY71qq3g8zUskV5DBtYgW1Jfj3bDn6ZNL6zgnyemW5imsqBu4t9mklAHjWmVbdV12a8xFfkL7UndRFqZBdo2LOeb3P25ed/Eo8/632N+Hs82QUJfoDfHt+PxV4WnwryfilRpbUU4G5ujb+YMxoxiGI9KFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTCHFP19c5Z8J2jonw7OSwe2Yas+VaNbBmPmbHA9Lo8=;
 b=Vl3O2iygiCmDFbvacfzF8FHTzIRxVbkYW/6IZweVC1YBbvweHshBXjqy5CnUbgztn03qSxPsFBSSQlHblMFPt4IFXcBD9ARgINk8AgoZBb5YQoPQlZD7rgJWdXkz70/MZBz2j1Une6lnq85ectpYOoS87e3cUVs/FpOY1vzUp+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CYXPR12MB9317.namprd12.prod.outlook.com
 (2603:10b6:930:e2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Wed, 11 Feb
 2026 01:08:04 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 01:08:04 +0000
Message-ID: <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
Date: Tue, 10 Feb 2026 19:07:59 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:610:5b::27) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CYXPR12MB9317:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b155d93-b369-4c50-102c-08de690a0284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3RYb1hpOVM0amkvd2E5Qk91ckhNbmxZUmswMU5uMzJSbWpsTUJGN0Yzc09l?=
 =?utf-8?B?eHFrQkFzZWhVcEFxSEY0ZU1NSE9ubnE3d3JPZUNiOTAxQks5bDNncXEwVE96?=
 =?utf-8?B?VVdWcmZRNTdJQVdpWHNlMjU4QXFlT2p0NlZwR2toalNYcytLZUVLOEIyN1Av?=
 =?utf-8?B?L1lINkdMVFdxSFV4Y0dJelJKR285SkphS2ZSblBiMzRENHpTN1IyYnYzMVJv?=
 =?utf-8?B?U3ZGV0hxSENjWWdVbnJjeGJuT3hwdjZqQWhYMFJwUUlMSUhRVmFmeUttUzM4?=
 =?utf-8?B?SHhvMGx3ejVDczVoQ0VMbjY0S3RSZm1Sb1NTcXRxQU42YjlRcFpSd0M1RSt1?=
 =?utf-8?B?V3FhNDVWelUra1oyRTltZ1NmSnVkelM4ZUgzRFNFQzlTZTM0MTAwc1VpSmZ5?=
 =?utf-8?B?RVNLM2t0VDd3dThFWUpuWFgrZVRrVzBEenlMVTZyWjJ5bXJVR2lUenZFaWI4?=
 =?utf-8?B?WGRma1NCYTdJUnpIdU5mU2k3UlQ2QzlQYk1VYWsyWEtCL0x6TERVMWZRaTM4?=
 =?utf-8?B?eTNIRHdBQWdYWStaUDZuQytEZFhqaVhqTHVoT3dNVG1heitYdGpPNW5xSVJT?=
 =?utf-8?B?UzJncUd5dms3NncvcnVENHhzdUQ3azlRaFkvN0RUQlQ3dkxWSUZmakhqTlk0?=
 =?utf-8?B?TXVHU1JjNld0Y1V2Y1E2ODdWSCtnWWJkZVJqSnRPSEs2ZEtrTGhrRXI5aEpH?=
 =?utf-8?B?dzc4L0ovVXovbnp2S1NoRENrVVAxQWhGQUM5QXlncCtnYWQrK1lCcUttTG9p?=
 =?utf-8?B?R3RLZXp1R2JMWE9haTZ6b211cjJ6VlMxRVp1T3Roc2dRYnd4Ym45YSswOHJW?=
 =?utf-8?B?OWtJUFRBWC9ISys3dGw5YlV4MmtIS0VZZFF0V3I2M0N1OWVSWVpDQmhPTTJP?=
 =?utf-8?B?ZmxCZXBGaHNIbTdDRFdVYms2TlpiR2UxVUcvT1paa2N5Wm1jeldXdHp1RmUx?=
 =?utf-8?B?RUxGVnd0dmdaNHlHRE1tKzlUUW5OVHVFV3B5bDhtelNoT3FPeE9pazRRYmVD?=
 =?utf-8?B?aksvcFgzTEVra0N0VkJPZGEvSnRMLzBDY1g5bTJvL2VMSHh5V2FIOGMwU2VY?=
 =?utf-8?B?OXIyYURFRkM3QVQvVmxIZi9MdG55aFp2ZWFDbU4rb2NQMlJ6eXcxSGUvaVJr?=
 =?utf-8?B?bHdWamp4WFZRTHhkbmtSUGkzUHE2ZnlmcTdQVmxQVE93WlNpak5RZ0VQMFBS?=
 =?utf-8?B?dEFQMkRxYklnc2s4RzA4Z1ZwT2d4TWtoYUx5aTQxN211Z2Z4WkhnbldocDZH?=
 =?utf-8?B?K3JBQWNsYmlJSXgvZ3ZOM3FTZmhOWmVDSGNSYVFHc3ovMWRsWW4zZFFHSklB?=
 =?utf-8?B?MHp3UW80TVpNMFZ4SE9xSW9FSFBabThBZ0F1R0JlRit3Q3hKd2pZTk5ZUkFO?=
 =?utf-8?B?OEVlaytKQmhHcmVtcy94UFplUk1oS0p3NDZZd2tscFRWdmtmeUV0RFA5UXhR?=
 =?utf-8?B?RUF3NVl3RWxDckRnWGlnZnVHWFRQYmJDU2VtUTRWQ0VmdC9iSmlmMTYzSXEv?=
 =?utf-8?B?WHI1MW1yakY2TEVCYUFvRlcvVStHZk1oQTljdEZBa0xnYjA3QWhFc3lWTlpU?=
 =?utf-8?B?Vlo3aWRRUURWdzB3UmRUeldXb3RRTE1QM2EvbkgwblRBUW5FMHdQL0gzVCtn?=
 =?utf-8?B?Njc0blp3M2FsMHQ4QUNlZDBvODNhYmlNMFFzYXhWMTFVZ2dQclZuZ0ZBWFgw?=
 =?utf-8?B?RHVVMU1BWk5HYkt2TlVQbVpoSlcwUm1ySVRGM1R5OWtvc00rU1RyL04rS0Zw?=
 =?utf-8?B?blEwaytPb0dlQkVnZkdoQkU4Z01MV29pM29VZDYvbjFCRTkvWGg0STl6eHpo?=
 =?utf-8?B?Wm41SERISUJBalhleVp0TWxXamt0dCtxWUNJazhFK2JlYmdrMnNmbjkwSzVo?=
 =?utf-8?B?Qy8zMjlhVTFLQkp5bE9BVkkyenQ5RFU5TGNOWVdYTDc1NGxESzVKbzcvTGNa?=
 =?utf-8?B?MnJ1MWdmU08yVmZCOWRoeWQ4QW9KVEdQMGdVa3ozcHpWcmgzV3RyeTI2c3ZI?=
 =?utf-8?B?S2dRd2I1alhFcXFmZ043dy9OWWVpbHVmaVkzbVlmalVZQWw4Q1dCK2NXTVlS?=
 =?utf-8?B?RkdCbk4wWFQ3Q3d1NFR1QjJWcnBENzVMeGZmSVBPeW5Pd1BEOTNIeTlETkJW?=
 =?utf-8?B?UXVuWjBvczBQbXY5L0cyWXgwYUhkUG1HMFAxVWhuNTlaU3kxS2trRTVMcWVu?=
 =?utf-8?B?SlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUtMTUV5cUJoOE9oY2JzVkhnM0s1SHpvWURCSm9oa3lBaGtTOFE0NWFyRzZY?=
 =?utf-8?B?aDdFOHdyK2Z3cWhxenQ5bkw2eWhOY3BDOGFRbTREUjV0R1FjYnMzTVpmSmps?=
 =?utf-8?B?bjcyS0RhV01LVW0zbzMrZFU3Nm96MXBtQnVkclYzUitBd1pNR2g5QVFFdU54?=
 =?utf-8?B?b1pmM3pYRU42UUhVV2luRm0yRGM4YjdWVzRVMm5Wc3BQcG1ZMENGUjhnUjdU?=
 =?utf-8?B?YlVMNWp4K1MrVkE5OWNneHBuRDJXUjh6OEFPYjlVeXNjc29FZDlqZ1pIRFlt?=
 =?utf-8?B?cll3NEJnaEJWMlQrS0JGMDB4U3F2OThPQWJvNVRiaXVzZDc4SUhNL01kYTQv?=
 =?utf-8?B?dXpsaUhEVGh1SmtMbHh2OHJCZGVMVnlPWEtWV2dHKy9OT1VrVTJTSlFVU3FP?=
 =?utf-8?B?MFliZnd2Q3VIcWVXRExZK0dSekMxcHdBNXVHUDlkY1MwbWZwc2N3U2xMNUNE?=
 =?utf-8?B?TFQwODI2RFF3ekt6UksrNnZPNExSYmt0TzNQYU95eFZmaFZ0K0cxQUQxYXJO?=
 =?utf-8?B?SlFFVWtYNDY4cmVWZW5JTVJZNFZLQi9QZHg1VXRzNG5OYjdHNnJxTEE0RHFa?=
 =?utf-8?B?My9udFJ2RnVVK2kzOU53ai96clhLQWNuS2NOemNiOXFHbHYwbEVjZ0tSdzAr?=
 =?utf-8?B?Y3pCU3c0bk5GenUrQyt3cVNCT0VpamhScW1MTks1eVh4WC84QVNBcVpqV3pR?=
 =?utf-8?B?MWEwMXllNU9YRUFZQ0xuS29UZG1RUjFVT1NuVEEwODA5NUd3U0pJYkJZblN6?=
 =?utf-8?B?ZlQrQW42U2NEMGUyRExLSExhU3h0d3F2dmQ3MHArRjUvQzZ6cFhGOTY0U2NJ?=
 =?utf-8?B?N0V3NUxpanp2Ykh1Nm5xMjlTQnhzdjU0WVo2Ump4NGM4UzdNZlM5YlNhR01v?=
 =?utf-8?B?RURVOXBzUWpXSnM3UzJJb2JNc3QvaE1LWmJiYnRKNjYzZmFMaFpLNVZWYnpV?=
 =?utf-8?B?bGRNOXpCaUo5MmQ2SzdHWWR5eHV2dktpTHptV2NBcmFnakJIZDFUWWRNZlNz?=
 =?utf-8?B?MUk2MHQ2RFhjY05ZVzE1WTVweVBlVDl3dmFZZWRwbUFaOUR4NHVoTERFUk04?=
 =?utf-8?B?bkhscUpCeVd6VlNSSWwxM1NTbFZyMGFTRGxDcDJJWjlmMzhaK0RQWXFpcm1L?=
 =?utf-8?B?MkV4NTUzcjFrT1JiclJSMTRhSCtXRVhWM3U4djh2R1hlY3VGb0c0WXdXNjFS?=
 =?utf-8?B?WkVxV0g5SnVtNmdibW5zVlY2SzJwK0dMRFBtd3A4MWdwNTVjMm9QK2Y3anJQ?=
 =?utf-8?B?RG1XbVVQejIvbzRldkhQVThPbUw4cUY2c2tXUVRRanhSSnhxREpxSnE3RXQ3?=
 =?utf-8?B?emZ6YlljU3lEL25JTUVISjY3eG9Mc1JOcDE3VWZUUGpzOE10blZtdFRqR3hy?=
 =?utf-8?B?aFJyaTRlUi8zSldGVGJPS1k1MzhJaG9xZkZIZVE5WmJMWFNFUHl5eDdtQmN5?=
 =?utf-8?B?M2MyWkZMMzR0OGVTc3dvdkoxUGxuZ1hxcE9Pd1J5bGxIYkl6MVJaTHA5MFFD?=
 =?utf-8?B?Y1lBcEc5Zi9PNHJSVEczS0pSZ3VnSDNBWGhFWENXMURLY3JMOXFNT1NyVW9i?=
 =?utf-8?B?NVJGYmNieFVyUFFoZy9XaCtCRVRYeVdvbnQ5aDJSaElOdFFWZ2FFdG5XQUxE?=
 =?utf-8?B?NWI5ejhTcDkzM01FNVpaWkFvMVdmdnhTdS9XVnQxWFRPeWJUVC95V3IzZXd1?=
 =?utf-8?B?RjBTQlg3TjN2aVZwODZXTy9OUHRpSTdaM1I1OEtjZXlsSmtUNkR5RDhPL0Rm?=
 =?utf-8?B?Y2RwdmhTd2tYMVZxTDdFdUxOcHZ1OXlzNS9MU0I5cXNvaFZwcHlFL2ZnbVZW?=
 =?utf-8?B?RjFLdldJdUxaM3pTWVpIek1tZGdqdUhIMEw2Y2Q4WFNNK05qSzg3TElTN3ZE?=
 =?utf-8?B?cG0vWWdQaU16bVJ3VjF4TlBWVFpKNm9tZGR6SmVhcUsxZC9CSmQ5Y2tZWlYy?=
 =?utf-8?B?cVpXK0ZFcXRxUnFvL1pxOUVoc0VNWXB0VEphc1d4ckhiZEZQYlVhWUJUVUNN?=
 =?utf-8?B?MjgycTJoekVXV3o1UGkwVDhNclBxQTFmMk1yS0dhaFhPQm9qTE9DSnExc0ww?=
 =?utf-8?B?L2NKQUx4Vmo0K1lURXh1UjhELzRpdTlra0VVV3BUdE5WZDJFL056dzRpNHFB?=
 =?utf-8?B?U0hIRVJjT1p6S2FabSs1anBvazlQMXNRUm52ZzkvRDdET1kvVWNKSklRWlV1?=
 =?utf-8?B?cjh6SWFNbDYxL3JzNFZmL2pibU5jN0FLZmdycnFmdy8wL2FubEVpOUxMamVw?=
 =?utf-8?B?cXIza0tEM09xZHZrMzZ5VEpFVDZFdnpLQ1hZdis1TEx0WDQ3NmxxOFppSmJy?=
 =?utf-8?Q?OZWLjZ5JFX+2Wy2X3k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b155d93-b369-4c50-102c-08de690a0284
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 01:08:04.7258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OIZEwNSoNiXu36vZiwwUvvX7EA3BYshaltvwzraAPTDNo1H5Y8MMlJ442rXD9amX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9317
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-70821-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: AC06F1206B9
X-Rspamd-Action: no action

Hi Reinette,


On 2/9/2026 12:44 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 1/21/26 1:12 PM, Babu Moger wrote:
>> On AMD systems, the existing MBA feature allows the user to set a bandwidth
>> limit for each QOS domain. However, multiple QOS domains share system
>> memory bandwidth as a resource. In order to ensure that system memory
>> bandwidth is not over-utilized, user must statically partition the
>> available system bandwidth between the active QOS domains. This typically
> 
> How do you define "active" QoS Domain?

Some domains may not have any CPUs associated with that CLOSID. Active 
meant, I'm referring to domains that have CPUs assigned to the CLOSID.

> 
>> results in system memory being under-utilized since not all QOS domains are
>> using their full bandwidth Allocation.
>>
>> AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
>> for software to specify bandwidth limits for groups of threads that span
>> multiple QoS Domains. This collection of QOS domains is referred to as GLBE
>> control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
>> in GLBE control domain. Bandwidth is shared by all threads in a Class of
>> Service(COS) across every QoS domain managed by the GLBE control domain.
> 
> How does this bandwidth allocation limit impact existing MBA? For example, if a
> system has two domains (A and B) that user space separately sets MBA
> allocations for while also placing both domains within a "GLBE control domain"
> with a different allocation, does the individual MBA allocations still matter?

Yes. Both ceilings are enforced at their respective levels.
The MBA ceiling is applied at the QoS domain level.
The GLBE ceiling is applied at the GLBE control  domain level.
If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit 
will be capped by the GLBE ceiling.

>>From the description it sounds as though there is a new "memory bandwidth
> ceiling/limit" that seems to imply that MBA allocations are limited by
> GMBA allocations while the proposed user interface present them as independent.
> 
> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
> enumerated separately, under which scenario will GMBA and MBA support different
> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"

I can see the following scenarios where MBA and GMBA can operate 
independently:
1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an 
independent CLOS.
2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an 
independent CLOS.
I hope this clarifies your question.


> can be seen as a single "resource" that can be allocated differently based on
> the various schemata associated with that resource. This currently has a
> dependency on the various schemata supporting the same number of CLOSID which
> may be something that we can reconsider?

After reviewing the new proposal again, I’m still unsure how all the 
pieces will fit together. MBA and GMBA share the same scope and have 
inter-dependencies. Without the full implementation details, it’s 
difficult for me to provide meaningful feedback on new approach.

Thanks
Babu

