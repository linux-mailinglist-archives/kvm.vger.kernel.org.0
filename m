Return-Path: <kvm+bounces-71167-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHGCBrmZlGkoFwIAu9opvQ
	(envelope-from <kvm+bounces-71167-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:39:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5E414E513
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F3013039833
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBE436F400;
	Tue, 17 Feb 2026 16:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sIfScgfn"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC89E335BC0;
	Tue, 17 Feb 2026 16:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771346349; cv=fail; b=jf28S97kWHzIqG5oymYz6p80brJZzyrnB+8HpxZCybUP11t0gxW6qjN1qNmDH+Sq4zq4u3ewO+zGu96PotcWZqKpxvNejqkn7UpZtstz5bdqPxqvpDzLBoEhZfIPpoGFMBNG8vscejfjf24zl1oAFV0MVbx46vdSHntL5OsrSb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771346349; c=relaxed/simple;
	bh=xzrNd6KyxoMFviZiDMFNMQtCf1bhEHmSPxJAlOJ09T4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t4j7LqTJT4y6SzgdRueXvxoOShABi+klag9wtGHbBkwjqZwZvtF9IQo16A9tjIlj52J71dqAIyO9WBuEfUyJlEgD/nwNUx2E/ho8Xzf2Sf+bBJM/ft940aUTy3qLWmLBb2lHbq2aDq9KhsQIGduZ54DLV9by/dwZLoRWvgrH3UU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sIfScgfn; arc=fail smtp.client-ip=52.101.193.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dTDvDlLzKpmt9KUnBLiJ6bWdUBeYQLsom/v5eNFFSQH7fCQRuOOgWhyfqKYMGB4jmsaA/LU7FuXEXWEtvm45qTKW0Yi4q1rbzgiJfJMP4y5819qUF9ZFIgBUyfn/QbS6RxQ2NB+Dk7XExEfJXXe9PmJ5GlA+ukKPSCnGg9Q5ybQKPKw6kBSwGy+l45E61+RuEc1lV1qhRWBI/ZHzaj4VwHm9aW3SlRVuGePJrLiD6pnG680Ocqe4PQsnTCJv3B8Ots7q1KkWs/g58VJsaUlbk35vnzcDgDTZMPHwrzGMkRuW47m64TRbjgWTf7Go4bd0qCJ96SZopAzZWgVdJKolqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqX/L+nySKWDDY2opFCgHkdffPHTFRcwt13JayVOLDg=;
 b=wiyCeCnTomfTJZYhv52kdHsTVQ1cxgQWEOfunUUfK6WbI30q1r9YsyV2PFF6jOkVEJtme0iSDjnxjQaCbfKgKDR8q3qGk2nawou7putMxXmcRryek1ckrG4yFMBdbOpL4bPX1dy8Aym31fQBbmXKu5voR460CCAHshu2O4eRFceHOzNs1Ru7mAN/tLSv1hDvYppx/gQiQomg6f1cbdG91gTu3VnTwvuNWIKy76df/x4BKt+Ia0e+9FXT01Q/ZVkTIdqMEdHjp0ftdkXd3cHNJiZN8WZHCVG0P+Rw9v/qI3lG/DlKWeci0PCthu2MnRCpRnqeAkAf5X6Ve9HMZm6cGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqX/L+nySKWDDY2opFCgHkdffPHTFRcwt13JayVOLDg=;
 b=sIfScgfnFHpTltQeBTAMAkQzVET0pQwlIjL8GKfVeGfvx9mhuSO9SwywKuL8JlMJ/OFES58FJTzwoXB8I3g/nxi/7hwKRqpC/+jsmMm/cDtSaCvVxgCxxn7FL1u+CtXSs0XqDQEHKFS6OCM9e2NIuVUfMJJbDio3g+pLrdFhWpg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SA0PR12MB4365.namprd12.prod.outlook.com
 (2603:10b6:806:96::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 16:39:03 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Tue, 17 Feb 2026
 16:39:02 +0000
Message-ID: <1e91b8ed-b4b3-4d95-94e2-916b06511185@amd.com>
Date: Tue, 17 Feb 2026 10:38:58 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Ben Horgan <ben.horgan@arm.com>, "Moger, Babu" <bmoger@amd.com>,
 Reinette Chatre <reinette.chatre@intel.com>, "Luck, Tony"
 <tony.luck@intel.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
 <mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
 "kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
 "fvdl@google.com" <fvdl@google.com>,
 "lirongqing@baidu.com" <lirongqing@baidu.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "Shukla, Manali" <Manali.Shukla@amd.com>,
 "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
 "chang.seok.bae@intel.com" <chang.seok.bae@intel.com>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "naveen@kernel.org" <naveen@kernel.org>,
 "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "eranian@google.com" <eranian@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
 <1a0a7306-f833-45a8-8f2b-c6d2e8b98ff5@intel.com>
 <fd7e0779-7e29-461d-adb6-0568a81ec59e@arm.com>
 <fbaa21b3-d010-4b89-8e87-f13d3f176ea3@amd.com>
 <951b9a1f-a9d7-4834-b6b8-61417e984f2f@arm.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <951b9a1f-a9d7-4834-b6b8-61417e984f2f@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:806:6e::21) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SA0PR12MB4365:EE_
X-MS-Office365-Filtering-Correlation-Id: c1e16a38-3ea0-4c9d-3d1d-08de6e430eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWZWTTZFdmZORERKUnBRZ25yL0cwbG5CNTZmM1RrcE14QTI5dU94UzJJYy9Q?=
 =?utf-8?B?anVBUWZ3S0txL25XSHZKOVQxRVA0c1hJRlRKT0VCWGJFYVZOQVljTWVyejFB?=
 =?utf-8?B?K21xVDc0RmN2SGRvQTcvWXRpRWxYOVYyU2k5YWd3VzBzVTNUZytKTmI0Ymc1?=
 =?utf-8?B?LzVmaTBrdGQzY2VYU3diZTBiRzZxYUdFQ3BKNys3THhMOHZKUUx2QjJpUDRy?=
 =?utf-8?B?VjJSTHd2U3NQQlg2NDRiYmw4VFh3Tk41N1JkRlBxQkQ0S1ZFUjlodzR2dXFU?=
 =?utf-8?B?KzdqeTlqN0QxdHBUTmFwTFdTZWdLMWs1MFg4Rk94RzNpVXNtMmU0Z1MvS1Nq?=
 =?utf-8?B?eFNueWFISGNnYXFKNWNITU1oL2hLTFY1ajg3OUdKRUtEUlNQRXZ3U2NWU0I5?=
 =?utf-8?B?UFFQOFRYaHdTU2J1VUkyN0VzMU5mekJIc2tWd0g2cFRTWmxKUzFZd3ZzbWlQ?=
 =?utf-8?B?RlA2eGxOQVdUK05qMFpwYmV0OTcvcm95Mm9kcFVWQjl0RzgxazRNYVFCalJ4?=
 =?utf-8?B?STQwbEMvaVEweXR1QU5ZWUZ2cXQzdW0rbkNtWFZ3WUlrUnhlUmV6WGI2T09M?=
 =?utf-8?B?K3VhbDFPTXZXQlgwem5uK0tDVG1nR1FEdk96eThKOC9MS2V1YXl3NWdtblUx?=
 =?utf-8?B?ZmhQdEpIalYxR0g5TTlBU2RNS05rRlZFU1cvZzBvaFpFbW1PbWlRcEN2WHJJ?=
 =?utf-8?B?dmdDUW9TdTMzaDR4dHA4TEFLWmU3SGYzVzFBNk9QYTZ5a3p6UGJFb3JCelNu?=
 =?utf-8?B?VnFxK0ZhdDE1dUlzT0ppaGRMcUptQmRzaTFkUmhsV2kyeFA5TSs1YWZESkVU?=
 =?utf-8?B?Zm5LZ3pOM3VkK0hvVGl2ckd1Ujd0M1Fvbkh2SER5RTUrZC8wSDFOejFEdFZa?=
 =?utf-8?B?bGl2Y1FnVVAxT3oyTHJVaElNSE01YUMydTBudGtFeXMyMy9HNEpJSnFjUVlI?=
 =?utf-8?B?QlU5NStDWGYySzFZUi9RQ0luVmV4Y0NpQTNiQ3k2RTVVUWkxWHR0RXIwamRF?=
 =?utf-8?B?QUEyV3Z2UmpWenBrRktTMkxmdFZuc1RNL1pZK2dmekx1YVlCVXRzRGFwYURW?=
 =?utf-8?B?QXZldnQ0c01wNW50M1RIVVBYQ1g2aWZqNE8wTXI1amYyR29KSEZwQ3U0QW9V?=
 =?utf-8?B?RjNuT2M0S1NFMjFpU25IaldELzg0aGtFK1RERlptcGR3UHI2Q3VvSktSVy9w?=
 =?utf-8?B?UmovenlwbFMrMDFZbjloWE5YU1MyOTRxYkJKdDFuUjFRWWlmZUVDVkEyNUpY?=
 =?utf-8?B?OGdnbjlEcVNFeDZ0MGc0VWVLNVpQdkxDOXVDcnF5RVYyaGRaUVIvOGtnL0p3?=
 =?utf-8?B?VEE0ekltd0tvNDFFNWdwQ01GdFR2aCtISjBoZEEydmFvT1BjL2JMTWhCVUUx?=
 =?utf-8?B?ZEtSME1xYmQwcEdrV3hGWnovRWk5YWlmZnVxVlViOW0vaTFFZEhCSnlZamVT?=
 =?utf-8?B?NHBEMzJHREVUOXBYZjgycjF5NHVTVytHdmdEa05hVERObWh1MW1obVowejNl?=
 =?utf-8?B?dFR0cCtOK0V0a2FVUkpyTVdKeXl4Zk1wRFBJZ0plem5TQVZ3N0lUNXJocVhz?=
 =?utf-8?B?SVZWenYyK0hzMm00a1ZKaUU5aGxvYVlISTV2VlhERmI4dXFGSlh4THVJL3Ju?=
 =?utf-8?B?V2ZqS1R5NkF5eS9VVTBScEwrZi9qQ2tqNk5GcG5YY3YxR3p6YkJGUmNZSE1W?=
 =?utf-8?B?d3ROTytJckxhVUxQZGROcDMvUXlOd2s5OUFFTm8vMzd0eEYrV09LU2hmTk04?=
 =?utf-8?B?aW13aGQ2YlVGVm0xTVUxKytuVFdxNGY1aXN4azhUL09oWTFBUmh5cnZyeC9h?=
 =?utf-8?B?Unp5Rm02MTJRSHpXWW1KdmYxaGlqUy9Da0plc0VEcmI5ZVc5cFMxVnBpb3Vw?=
 =?utf-8?B?M3ErYkc4TDVlbHd5TStQNmhuMWh6dlh1ckp4amEzd1JmeWgvQmVEdFJKZ2dK?=
 =?utf-8?B?bzExME11dEhNeXNiQkh1ODZHdCtiWlJnemMybHZveE9sU2c5Tm5RSFhkdDds?=
 =?utf-8?B?Wm5zMDNiaEUwUEJ4SVBIVWZodEkzZmx0YjJ1TDZ4dXR6MlhabXRySWxjTEVp?=
 =?utf-8?B?NFVZaTllZnk1bEdGaE01R241eW9DNU5TNExpZzBJajVrb2NPWWEwcklld0Z4?=
 =?utf-8?Q?1Pmw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TThQZ3dpTGZaUEQ0QUtpMFhLaE5oVTZUVjE1Z3N4emN2R1VDZC9GUmV6WERK?=
 =?utf-8?B?RExqcThiOTZsTzUrUWxzVWxPZ0NzckZISk55aWo4SG15Zjl6eC9lT0ZmY1dO?=
 =?utf-8?B?QmcybkhCS3pVWXVSYWZvYWNHMEROdVp6bXd3cTh5eS84ZGtscW1HNVYvc2h3?=
 =?utf-8?B?a0ljS1JlekRUVm9BZ2szSzZWbUthb2wzTUJUcHBDQ3k3U0xJaFdFdWgveEgx?=
 =?utf-8?B?SmVPV0hqWUd3dkFiU08reXhqV05mc3FYdHptaW5YTldCT21ubXBRb2pjbkxn?=
 =?utf-8?B?MCtKRWloREU1ZldJNDVLYmMwZWc3SVRNYjErQk1kaFZuaVVaQ0J4U0R0NkxT?=
 =?utf-8?B?OGdicVdIWUYvL2F1NlFXQWFRNGVOQzVGMmEvYlRXVFhzT2tNdlVvMDJuSkV2?=
 =?utf-8?B?bFo2a0hIS2MyTEVtZUhvbFZiRVl0OXVOSzM5bVNkWTVkZmtRd2NoM3VheUZL?=
 =?utf-8?B?ZGQ2aGxXakF2Ny9Hb0hiRStFcWl4UEFUYU82K0tYK0N0VzN5NXZDOHF2d3Vn?=
 =?utf-8?B?UlQxa0lCM3ZES0ZiYXY2VGhpb3ovT0V5UGhROWlHdlpLYlN3SURYdEhlU203?=
 =?utf-8?B?emdBQTUvODlrSEZYS1BvbkVaNWlRMGxueXpNaVpmTzBidUk2WUwrZjZMaGM4?=
 =?utf-8?B?VytvRXhNeVNybW1Wd25TaDF5MXErQzFDckcrU0QxQklEZmxqMFBSTitCRnpn?=
 =?utf-8?B?YVZjazV4Y0lWVUpEN1FVOEQ3a0ZpWFFjZmRMdkNrc0VLV05ib3g5c2hzR01l?=
 =?utf-8?B?TkJ4SHRMZGpMRVlvMk9oN3c2dXNoUk1aSFJ5U0kycE9IMkdWcmV3dXU0SzBR?=
 =?utf-8?B?Y3Bieit3S0hYM2VDMCtLVHlWVUxnd25PVFZ2Wmh1c20wMndzWDhsZTFrUWV3?=
 =?utf-8?B?TTdBdjlBWlNodElmYXdYcWJNQ0N0VDdzRlprMVhDb3BSTGZCZzliaDNQYVhU?=
 =?utf-8?B?emY1R2l2QXFDQXM3S002VFl6RlYxc1VoVUxyZ3pIOWxscUpjTVFqb1RWMWxG?=
 =?utf-8?B?eWs2c0tjRnFSY0UwRjY1cUVsN0hiUGNRbXVEeUNteDI5SmdLcVdwbTlZaSsr?=
 =?utf-8?B?VkhUMVZKZEZCY093ZUltQ3BJY2JzaTB5RUFaMkw1UVpVc0IzZVpvT3NzOENR?=
 =?utf-8?B?L2tONng3eERsekZ1dyszYTgxM2pvSFdIYlptRWJ0R2pFdzJIWkc0N3NqNFVa?=
 =?utf-8?B?cHNDcnBuNTAwbS9IVURDdHJya2FQVkI4Tm9EY3VzQnZhR1BHQzdwRFNEemlo?=
 =?utf-8?B?dms4TXhHdlpDbDRsS2lUOHFXclR5WktqZFN6U1pzb3VnR25EU2M2Wmg0bERM?=
 =?utf-8?B?bHl4YzBGL3U4bXBoRXZuZnJ5S1ZWcUg2NXI4ZnVraW1lenNRTWRueGxBRDZy?=
 =?utf-8?B?YVQ1SUxFbEZJbVFISzgrOGVxRElvNHFFdUtmRG5abW1oK2xCTEZSUmhvb1lX?=
 =?utf-8?B?aU5nWnR4ZFpIa0k0bmQ0VUp3ekpaNjNiZy9PTnNwSGp1OWIwK0hVazk0cXdh?=
 =?utf-8?B?allYdldUbFlEY3B0cTJEckdIeERKcjJuTW1NdEQ3eWtFL2JMTEVaUWVtVVZN?=
 =?utf-8?B?STU2cFR2VzVvQmZrNVhlUnIzTmZ6eEFqL3lzdDJtbXdTSnAybmtaM0Rieitn?=
 =?utf-8?B?OERTYkZBQS9mRlpnS054aXBnbmN0Z0hMUTF5ODhnc0p3WlJvd3ExeFdZUlg0?=
 =?utf-8?B?VFAwRFU5SmwxWVl1VXhUejlFUWN6dnZhOGV1c1U2elFOMGVla2ZVWjVYb3Qx?=
 =?utf-8?B?VFUyTXpXWW03ZzVZYmJPWEhTMCtleEI3TDJUNTVPbXlXRHJhNHAxbkxidFB2?=
 =?utf-8?B?SVJOTXpSajVUVHhZMElpcmRXY01jQzRHMmhuTzR5Z1hUQUpSNHRia3ZLQ0Nn?=
 =?utf-8?B?aXZMSTc4NldDYzVrenFybWdlMmFvT2tFQzZXSU9lTkp5Tkd1bWhPN2pSV2Rp?=
 =?utf-8?B?OGxvZjdXN3ZZbS9Zd1JvWWRNWHNEVVNvMUVRL1JpQTBkc1VpbGtBQmh1ZVhY?=
 =?utf-8?B?dFRDQi82TnR2WE44bnNrRHB6c3phN3IzNTNpMWRNMXdwZVVJMUduaDRReUZw?=
 =?utf-8?B?UUFORUJkRURmbUVKeDJPbXFuZS9wQm0rSmEvVjhsSktpTHNxMDU4b2JqSldZ?=
 =?utf-8?B?dmhnTHNJSE9WVm1zRG5yZXg4UHFHd3VxdGpnSDlpOTh0MnRjaXF5Z1RuLzdO?=
 =?utf-8?B?SUFmeFlmVG5JSHgxT2h3VExvMktNNVA0M3kxbkR0RHVnUlZia3ZrY2g5NVlK?=
 =?utf-8?B?Wlc4SEt1MHFIMnllMGlKTmt1SkhHQ0l0aWdldHlISWt2dS9IOHo0QXoycXBk?=
 =?utf-8?Q?iUDcZmbEGD1nJnLs52?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e16a38-3ea0-4c9d-3d1d-08de6e430eff
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 16:39:02.8455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQk91H7gzfRm2/qeC7/UrxEHQEygGyLfxnpPgBlizsInO5SJUQR7X5D1GOVAkhr3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71167-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AA5E414E513
X-Rspamd-Action: no action

Hi Ben,

On 2/17/26 09:56, Ben Horgan wrote:
> Hi Babu,
>
> On 2/16/26 22:52, Moger, Babu wrote:
>> Hi Ben,
>>
>> On 2/16/2026 9:41 AM, Ben Horgan wrote:
>>> Hi Babu, Reinette,
>>>
>>> On 2/14/26 00:10, Reinette Chatre wrote:
>>>> Hi Babu,
>>>>
>>>> On 2/13/26 8:37 AM, Moger, Babu wrote:
>>>>> Hi Reinette,
>>>>>
>>>>> On 2/10/2026 10:17 AM, Reinette Chatre wrote:
>>>>>> Hi Babu,
>>>>>>
>>>>>> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>>>>>>
>>>>>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>>>>>> Babu,
>>>>>>>>>
>>>>>>>>> I've read a bit more of the code now and I think I understand more.
>>>>>>>>>
>>>>>>>>> Some useful additions to your explanation.
>>>>>>>>>
>>>>>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>>>>> Yes. Correct.
>>>>>> Why limit it to one CTRL_MON group and why not support it for MON
>>>>>> groups?
>>>>> There can be only one PLZA configuration in a system. The values in
>>>>> the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID,
>>>>> CLOSID_EN) must be identical across all logical processors. The only
>>>>> field that may differ is PLZA_EN.
>>> Does this have any effect on hypervisors?
>> Because hypervisor runs at CPL0, there could be some use case. I have
>> not completely understood that part.
>>
>>>> ah - this is a significant part that I missed. Since this is a per-
>>>> CPU register it seems
>>> I also missed that.
>>>
>>>> to have the ability for expanded use in the future where different
>>>> CLOSID and RMID may be
>>>> written to it? Is PLZA leaving room for such future enhancement or
>>>> does the spec contain
>>>> the text that state "The values in the MSR_IA32_PQR_PLZA_ASSOC
>>>> register (RMID, RMID_EN,
>>>> CLOSID, CLOSID_EN) must be identical across all logical processors."?
>>>> That is, "forever
>>>> and always"?
>>>>
>>>> If I understand correctly MPAM could have different PARTID and PMG
>>>> for kernel use so we
>>>> need to consider these different architectural behaviors.
>>> Yes, MPAM has a per-cpu register MPAM1_EL1.
>>>
>> oh ok.
>>
>>>>> I was initially unsure which RMID should be used when PLZA is
>>>>> enabled on MON groups.
>>>>>
>>>>> After re-evaluating, enabling PLZA on MON groups is still feasible:
>>>>>
>>>>> 1. Only one group in the system can have PLZA enabled.
>>>>> 2. If PLZA is enabled on CTRL_MON group then we cannot enable PLZA
>>>>> on MON group.
>>>>> 3. If PLZA is enabled on the CTRL_MON group, then the CLOSID and
>>>>> RMID of the CTRL_MON group can be written.
>>>>> 4. If PLZA is enabled on a MON group, then the CLOSID of the
>>>>> CTRL_MON group can be used, while the RMID of the MON group can be
>>>>> written.
>>> Given that CLOSID and RMID are fixed once in the PLZA configuration
>>> could this be simplified by just assuming they have the values of the
>>> default group, CLOSID=0 and RMID=0 and let the user base there
>>> configuration on that?
>>>
>> I didn't understand this question. There are 16 CLOSIDs and 1024 RMIDs.
>> We can use any one of these to enable PLZA.  It is not fixed in that sense.
> Sorry, I wasn't clear. What I'm trying to understand is what you gain by
> this flexibility. Given that the values CLOSID and the RMID are just
> identifiers within the hardware and have only the meaning they are given
> by the grouping and controls/monitors set up by resctrl (or any other
> software interface) would you lose anything by just saying the PLZA
> group has CLOSID=0 and RMID=0. Is there value in changing the PLZA
> CLOSID and RMID or can the same effect happen by just changing the
> resctrl configuration?
>
> I was also wondering if using the default group this way would mean that
> you wouldn't need to reserve the group for only kernel use.

Yes, that is an option, but it becomes too restrictive. Would this 
approach work for the ARM implementation?

If a user wants to keep a selective set of tasks running at different 
allocation levels, they would need to create another new group, move all 
tasks  from default group to new group, and leave only the selected 
tasks in the default group.

And if that group is later deleted, all tasks will automatically return 
to the default group.

Thanks,
Babu


