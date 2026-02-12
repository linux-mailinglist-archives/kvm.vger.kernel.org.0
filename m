Return-Path: <kvm+bounces-71007-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKJpIZEljmlrAAEAu9opvQ
	(envelope-from <kvm+bounces-71007-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 20:10:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1087513094B
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 20:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5ADBA304AD38
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CA9C29993E;
	Thu, 12 Feb 2026 19:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S+WheUHg"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD9A27453;
	Thu, 12 Feb 2026 19:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770923374; cv=fail; b=c6GgIPM0SZF6sjAlo8vIvjY9PtH47hAa2Dp989gZZlsc7diQjVT9mJBv2QCWbXfvTxspbb97Zedun6p0/fNAaRtJbrqKsTIzxGq3WQNyl5HUqekRY7nuxHCR3/qX6SGghxHeGa48AGVRpo6eMH8fCQhu5g31rXFRLGx31bSr4RQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770923374; c=relaxed/simple;
	bh=wZ41mFPTdC5vL8CbnFjR7ndVKD0OFg4tnEpYYvdT2b0=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sixeYXcMuHg1O9xbNyjLS/qaB+mOZfTVB5gMJx8xG34VBBvknSYwwgIAmt3+2+kb8DfpBc2hj53RoxUl/eQpZApdt+Bq/W2D15ehz+/UnwbNRSEGrTelcXe174E0+NDnP9MhtOpbKSWwWK5a2TccWeRVHsjUu212nH+9VfOq68I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S+WheUHg; arc=fail smtp.client-ip=40.93.195.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SZD9VPm/HaSKw8R1EYbYUmBAhpROEqdFRNE1MpCwXJ82NEMvcfBkMyq/zHWVoR25cGDcxdSrpie8KZODrc1vNilcFLJnjMkvNemVYzMW6CAuITjQZIvRu/F/y+ZCK0YCkzIZCcAoTkhXkETvDsvSPZ369JcOX0itcRiZVQWE39/sH2QQpHKpqcFEGZW/IyAYHodRHEGfwIPzVc1YvDZsAtWQ8vXXhYSGUDlNbzARAeTC1+3H6gKpwnvO9mIaRGnMZrvBPVWCp2HCdmXfJ+C4C1TBdq+aB9/IA4+bNcFfDYfHy+cPqTldnTSki9jiNsqScsxJxHOuqhyMeX7DsJH+sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuTjSkVABuR1QZdajHZ4xMXH3PN2lLkPmYNca6gAsCw=;
 b=JEa9FVSr+m2Cpc6A7PAZ5C8MivnDMYdo4RvmQwXwSLTXFNU48SOuEpu9r4HqGEwEjMX3H1Bg4k26lIOCgy+2JLYhwwGnJa0SkM6yAD09rZS4OTEzKm0ZoozHAEP2+rTTekQHZujb7Hpc1uQQwV1shlW4JvoxyncjV9sQSeK4szlcsUfZDOi4613BccvsGDUBBcrIGxyo3NaCweg072BnnwCMhD41FOUGEtgdqfHsRPzxOlkO6TXNHqKIQJZIZmrIrtLA5IaUok1dZS3BrD738dPzj/a2T4jAQG89ktLu8venZfjP2pNWMSEfOWwe62NnuVl7Hza0HaCIMM618xNNyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuTjSkVABuR1QZdajHZ4xMXH3PN2lLkPmYNca6gAsCw=;
 b=S+WheUHgDap4OWupJBLBBnmrxo+D7LGS8y7Bruvejn6OQDROoj+XLOkg0dLJjD3gOnOz5zFR4OlEtQ7ly/qWlY9ScJkdMj6u92IA2UTOVhjYsweCA9uZuokDCgg1e/IOzrOBzL+IOSnJzxKiUR0sUHGuD2xUz7dlyKJhXjuv2nc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by PH7PR12MB5976.namprd12.prod.outlook.com
 (2603:10b6:510:1db::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Thu, 12 Feb
 2026 19:09:26 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 19:09:26 +0000
Message-ID: <91d50431-41f3-49d7-a9e6-a3bee2de5162@amd.com>
Date: Thu, 12 Feb 2026 13:09:22 -0600
User-Agent: Mozilla Thunderbird
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
 <bmoger@amd.com>, corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com
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
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
Content-Language: en-US
In-Reply-To: <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0152.namprd04.prod.outlook.com
 (2603:10b6:806:125::7) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|PH7PR12MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: e8ad7b6a-90e3-446d-1c9d-08de6a6a3d9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkdqeHJWd2QvZmdaMU1vWmkxMXE0c2ZTeGZEdFlQMjZiNmp4Vkk1cW5hSCts?=
 =?utf-8?B?K3E3dVAvcWZDMGlzdkU1V25SNjJFTTYxdkgvTThQU3J6dUNDb2t3cEc0Kytq?=
 =?utf-8?B?c09KOVlWSVpKWnF6OGhhaEx5RmplcGlmcEtxSEVsdlNuYVRKZTVCUWJLWTdk?=
 =?utf-8?B?OE1NelljUEhrSEVPcW5iOS9oNXBaWmJTOHNIc29wTy93TlFKaEc1cTU3cm9E?=
 =?utf-8?B?QW93RGU2TTJ6cnltdUMwa2FRQ1Y2RTBaK0lHMDJoSS95RnlXcmMrYkhhRHpW?=
 =?utf-8?B?WkFRa1hrZGdhVjFZck1QY2xWNi84QXZMa1ZvYUVFOFRHampzWTZQbjUxZEtn?=
 =?utf-8?B?OVpRTUtTaDIyUjFLdnNhNlcybUJTWGVFN24zVGkvd0JyUmRtQ2FJcm5hdW9V?=
 =?utf-8?B?cllWN1Z1UU9MaTQrVFlxR2ZiS1VYYmdZTEQ1TjlzM3ExZ0FvQjBIc2JDVFlm?=
 =?utf-8?B?VHgySGJ3SXZ2eUkxSDdtclZKR0xteHV2dVhBVmxWclRhb004dWhtU3l2cyt0?=
 =?utf-8?B?cjZUY0Q3SDR0enpGK2phZFh6ZXo1aVRRdHFrK2QrcGNpRFRlR3hMZm1TVUh0?=
 =?utf-8?B?bEwrdU43VTZKN0lqZnJ4eGRJTk8xSWJ1OUlhVXZ5Mmg2VGJNMVhHczJwQndr?=
 =?utf-8?B?UEZtWDBCdWtldXJycDZuUXR6eDROTmw4RnB3TWV1T3RsWmRyS08yZ0dwUllT?=
 =?utf-8?B?dVVSQU5Pd2IvQ0R0VEJwenpyNWtCMlFrZktRSDF6VU5QcWNRTThJRXNSektQ?=
 =?utf-8?B?ZUwzc0VOUG9UeTJMRVAzUWJHc3BqTk1pRlJ2a3l1ZDdGaHlYak5XWXE1bmZK?=
 =?utf-8?B?dkxBeXlFUGp5ck9ORzBOeUJtenM0am4zZjlZVWFJaWI2Z0ZEdnJHOVRBNHpm?=
 =?utf-8?B?ZmdHUEg5QjZiTE5uaTRFanZFbEoxVGtIK3dBbWtaVHZkNjRNSGo5dnlxcDM0?=
 =?utf-8?B?dkZiN2V1a21Qd0RNeHQwZC9HN3N3eExKRUZsVzVaUTNtRlcwNkFYNWRYZUVN?=
 =?utf-8?B?T0gwTXhNUFhJMnRTa1dKNXZMZUdISDFYS0VhM2MxTlZaNXNORUxjdlV6cmVi?=
 =?utf-8?B?WVFiYWtIQVZqMUhBMTJsbUNIdlhNY2xTc296aG9DeHRNYVdSUkRhMWNIYlY5?=
 =?utf-8?B?Ri9Md1RPK0VLZ1Z6Q3FvVnFqU3UwTDJjbFhxS0lEQ1IvNS96RkdRaytlZ1VQ?=
 =?utf-8?B?WG9sMzZmQnB3SFhFQVRxOWJ1YlN3VmpyYWxwMTFQTzRTWHBlK29sc2dwVzVM?=
 =?utf-8?B?TGZCbTNDOCtiZ1RFV0pKTHZWNVMreVlHMzFnaVZTcEJRTGpkZyt4WUR3K2ls?=
 =?utf-8?B?aUlDV21hTmZsci9nUUc3dmZaUmJHM211ZkpJTzRmaFkyRzA3REU3Qk1UNit0?=
 =?utf-8?B?VlVFOW9CazB3Wk1NVW5SMkY2OGdJU1B6MWtvNE9FYy9WT0dxZkp1eE5jTHlI?=
 =?utf-8?B?TUVzelRHZG1OdlptalBEb1ZwbG92T3RHMFhMVTlEZ1Y1Y2VjWmdxUUp5c25N?=
 =?utf-8?B?aTMwMVk0dHFzYjliT096ZjRIbk1hNHJRcXoxeWhSRzZiVGJNdlVqZHlwZDNW?=
 =?utf-8?B?UjZBYytkNFcyS0Q1SmM0R1ZtV2lOSFFIRnpSakJLem5maDEwNUpkWXZ3YUd5?=
 =?utf-8?B?ZTg3bUwrTWZ4REQrZkpnYkF1VHlWRVlqOW01dlhEcDJKNnI3eEcvQ3N4YjhF?=
 =?utf-8?B?cnpBSXdtVVRiS1VJZWtZR2ltbzFhQ082UFNRWkQvR2QwN1BiNG4ydHhZZ1dE?=
 =?utf-8?B?c0RyT2plRnZ6eU03UUh6RS9hRHBWOEd2RXdpRmFZQ1FibExXd1FkdkNtbFhD?=
 =?utf-8?B?VitEOEVlanZlMmhqR0JLMy9zb3d1SlArOXZycmkyQW05dTVWSUlRdnhZOFVn?=
 =?utf-8?B?d1owd2R2OWEzdVdzWGF0UzBiemhzSlRkY2R0NHlMY0lHcFVMMkxOUWwyekJT?=
 =?utf-8?B?aVV2ZlhmWGFURmNJTG05RG1LTEhPRkhwcjgrVzhlZ0V6Umc2YWZuRDZSUTJo?=
 =?utf-8?B?Wm5aREtiTGRQZmdWb2JtODBwa3NmVnpUSEQrMk9Sak81SVJ5dUFlTksyNm5N?=
 =?utf-8?B?TncyaklVOGkxMWdKa3BLSnROTEFWcnJmR0pmUDE0RjBOSndIMHQ3VFU5MktO?=
 =?utf-8?B?YjRNY2ZYNXVOYzMyVloyT01xY0srU0tuNnJhMnFKamROQlhMTTh6SG9PRjh0?=
 =?utf-8?B?RFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTh0ZmVscHhqWUxJV2x6QmE2cUFaa202ZHMxT0w5aWgzbkkyb1hUanFZd1ZG?=
 =?utf-8?B?bDBSYXVGSkczcUhVNWZVNHVIdmhlNmFvR05EU1BKWld6Ty90RENVLzB5R3g0?=
 =?utf-8?B?WWlEbEJaeGpNR3hpOGtmcEdYZWZBWUFTYVA4UWgvYjhOQWtDY084NUZLTFF6?=
 =?utf-8?B?cFJoV0pObmF3NlkyY0Q4OS9MdzE0UEhDbGY4TnZkRTNOWGVwUU5YWW1tMjda?=
 =?utf-8?B?aXp6ZlczNVkvbjlXaFViS0VzV1BWYkxmbTBNclJETmQxOXNDbnFtalVaQkRF?=
 =?utf-8?B?ZEViT3l2WC9RcTBoNy81ckNSUWtuU3BhYWZXNUpmMmpobWNyK2pSdDVYS2tp?=
 =?utf-8?B?c1J3bjNENmYrSFpuRnZaKzFLTjBZdFhaN3JXNFg0ZUdrNXNISFNVWFc4ZXhx?=
 =?utf-8?B?d2NteGJNNlpOSnB4VnBNSWMxNkdBT1dabitEL0QyR3VxMzRDNGpVU3ErYUM5?=
 =?utf-8?B?aWJ6cEJGMWgzTkRFckNDMVBaNkVXWlpodmFjOEM5UEM0eVN2UFRTWnFXK2px?=
 =?utf-8?B?bmR3TTd6YmtoTjR4blFlM2hCYlo0MENTQlNEa0IvbE5TTUx3a1BwUmF4bDh4?=
 =?utf-8?B?NVFFeThrQkh6QThnY2hNWDVhbWdKdTkwbzIvazhWa0dxUlM3UHJBdzl3YjR4?=
 =?utf-8?B?NUNUY21pTXFWTnk0SS9SNjEyejVOWWhyZlFkdzBLRC96Si9mTFV0YzQ5bits?=
 =?utf-8?B?cGtOQWJ0NkNUUm5pbm5NeWltaERJMzBHSjNnb3RCdlVpT3RqQ21kdkFWVGtG?=
 =?utf-8?B?MmpLTmNBc0JOSjJrUXlrSXpjMitNVzNzWko2d1JkY3kweHp0S2VKN3paT0Ju?=
 =?utf-8?B?L1lDNjRXZjRYbytxZDBXQ09QUHFtSTdLVk9xa2hCWDNFYjNQdEJKZDNoUjRs?=
 =?utf-8?B?eis1bmpjeUMrWml4eUNEcG5RZjJrZHIwbUNwd1BaT2pyRE9tcFhiNm14N0ha?=
 =?utf-8?B?L0R2UmtCWXRxaWtYVTN5ZVo2SnIwZ1BYL2dVZ1J0WnMrUGN4R3VIY2FGRjBT?=
 =?utf-8?B?OEsxMXhCeXR1MW1jcy9xZkZVeVlsajdlRGpzWWVUOFBQOWpmNHFrbVJqSEgy?=
 =?utf-8?B?NGRhMjJHMnZsVHZza0hPTkJvZTRyT1dNQTFLUGlJMHZQZ2ZwR01sWFFKWURR?=
 =?utf-8?B?b21rY2JUdDBMcFhRdnJremQrYVVTUDNvK3JLT2o3aEc0eGtOTFpJOUkzOWUw?=
 =?utf-8?B?VHZ4ZXM3TFgvOGZWc0FRTE9nZ2tpa2dhV1VETk44RW5ZUkM4US9DcUFwNTVK?=
 =?utf-8?B?aEx4d2VoRDVLQm1vMUt6dE16ZHlJbENidnBMYU0zaXpvU2ZHN3h6azJhN09M?=
 =?utf-8?B?bzdIcWYzK3liQ3NFZXdia09nQXlTTmcyYUppU2RHS1ZHNjZpMldRMC96Ylg1?=
 =?utf-8?B?Vm1rM051M0RIV3IyOEFNUDQ5SEdIS3RITHdnakpXODc0cWl6NUd5WHo4MHRE?=
 =?utf-8?B?YlBUc3BzOXpkWXZIV0xLVnpQbTltb0hxNGlRYXRpTlFXeURiL25UQ2VIL3k4?=
 =?utf-8?B?cmUyYk9XYVd4TXVFRDREbjJ2aFdQRDdvci9EWXptQmt6Z1pZSGNCaWlFalVx?=
 =?utf-8?B?bzRGTTV3bzhidFN2REQwQm5Ta3ZERUFQL1FBZFVHSW9FVzh1cnlOdkdZSGZ4?=
 =?utf-8?B?OStUU0JoSUVlRFBrcTdIeXNiYndVTCtCbmQxdFRyUzRTdHl4bTB4NE94bmlj?=
 =?utf-8?B?aFAyd3hvRE92WGorNWJrbnBrakZ0SG4rako0RVJOZ2xVekZNR0d1SitMS2NI?=
 =?utf-8?B?eWlZeEl1WXpsMmpNTkhxRWtoRkZ5QjNvaUFDSmJreWEwQk14b1F0Nktjcnd5?=
 =?utf-8?B?ZEtRQy90S2hWT0w1OEIvZzRVRFdJNW5XK1NGSEVRbGtQMExHbGRGQlVMMjdk?=
 =?utf-8?B?N0hnYWJMN2kwc29zU2ZvVXdsdzJ6OFpMcG40cWdKK0w4UDFDNzJYcjNuZk0z?=
 =?utf-8?B?STBQZkR6K2x1ZXRqNTJ5KzFPVGkzWmhQaXJxTnUwUytnYi9DczlUSG1ndk1k?=
 =?utf-8?B?QURGQzJvbndDLzNmcW5YMXdVNTFGUGxNaXUwSmd1emJHV05tQTBnUEtyeEhR?=
 =?utf-8?B?eGdSOURINzkvK1dRV05tRWdaUmxJdXArK3JDbVk1clFVNyt0dWVVUWEweFZ1?=
 =?utf-8?B?L3AwTm5mc0RnbUFaMVBNbnRMOHR3SGk1byt3S2kwL0p4NnNyMnBsYmtKZUx0?=
 =?utf-8?B?VFVDQWo2bGhjQTJEMjVtWmIxa0w3d1M0Z1VxRUl6SlB1REgrblBHdFhGNzlO?=
 =?utf-8?B?RUZMMHJRblY1WU5MYjlnRGExTy9mYjNwelF0WmJOL1ZIZDBRWU5wZlgvc0R4?=
 =?utf-8?Q?6ECLph8otU6QsvdH+y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ad7b6a-90e3-446d-1c9d-08de6a6a3d9e
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 19:09:26.7981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kEN1C2ezKbcWqkaNOp9FuXGlAsbR66fs5URNvVvplsxWFuUGcd5MEVQaHDqhWgh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5976
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71007-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 1087513094B
X-Rspamd-Action: no action

Hi Reinette,

On 2/11/26 21:51, Reinette Chatre wrote:
> Hi Babu,
>
> On 2/11/26 1:18 PM, Babu Moger wrote:
>> On 2/11/26 10:54, Reinette Chatre wrote:
>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>>>>> On AMD systems, the existing MBA feature allows the user to set a bandwidth
>>>>>> limit for each QOS domain. However, multiple QOS domains share system
>>>>>> memory bandwidth as a resource. In order to ensure that system memory
>>>>>> bandwidth is not over-utilized, user must statically partition the
>>>>>> available system bandwidth between the active QOS domains. This typically
>>>>> How do you define "active" QoS Domain?
>>>> Some domains may not have any CPUs associated with that CLOSID. Active meant, I'm referring to domains that have CPUs assigned to the CLOSID.
>>> To confirm, is this then specific to assigning CPUs to resource groups via
>>> the cpus/cpus_list files? This refers to how a user needs to partition
>>> available bandwidth so I am still trying to understand the message here since
>>> users still need to do this even when CPUs are not assigned to resource
>>> groups.
>>>
>> It is not specific to CPU assignment. It applies to task assignment also.
>>   
>> For example:  We have 4 domains;
>>
>> # cat schemata
>>    MB:0=8192;1=8192;2=8192;3=8192
>>
>> If this group has the CPUs assigned to only first two domains. Then the group has only two active domains. Then we will only update the first two domains. The MB values in other domains does not matter.
> I see, thank you. As I understand an "active QoS domain" is something only user
> space can designate. It may be possible for resctrl to get a sense of which QoS domains
> are "active" when only CPUs are assigned to a resource group but when it comes to task
> assignment it is user space that controls where tasks belonging to a group can be
> scheduled and thus which QoS domains are "active" or not.

Yes. In case of task assignment, it depends on where the task is 
scheduled.  Users(admins) normally have a idea where  to run their 
workload.

>> #echo"MB:0=8;1=8" > schemata
>>
>> # cat schemata
>>    MB:0=8;1=8;2=8192;3=8192
>>
>> The combined bandwidth can go up to 16(8+8) units. Each unit is 1/8 GB.
>>
>> With GMBA, we can set the combined limit higher level and total bandwidth will not exceed GMBA limit.
> Thank you for the confirmation.
>
>>>>>> results in system memory being under-utilized since not all QOS domains are
>>>>>> using their full bandwidth Allocation.
>>>>>>
>>>>>> AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
>>>>>> for software to specify bandwidth limits for groups of threads that span
>>>>>> multiple QoS Domains. This collection of QOS domains is referred to as GLBE
>>>>>> control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
>>>>>> in GLBE control domain. Bandwidth is shared by all threads in a Class of
>>>>>> Service(COS) across every QoS domain managed by the GLBE control domain.
>>>>> How does this bandwidth allocation limit impact existing MBA? For example, if a
>>>>> system has two domains (A and B) that user space separately sets MBA
>>>>> allocations for while also placing both domains within a "GLBE control domain"
>>>>> with a different allocation, does the individual MBA allocations still matter?
>>>> Yes. Both ceilings are enforced at their respective levels.
>>>> The MBA ceiling is applied at the QoS domain level.
>>>> The GLBE ceiling is applied at the GLBE control  domain level.
>>>> If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit will be capped by the GLBE ceiling.
>>> It sounds as though MBA and GMBA/GLBE operates within the same parameters wrt
>>> the limits but in examples in this series they have different limits. For example,
>>> in the documentation patch [1] there is this:
>>>
>>>    # cat schemata
>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>       MB:0=4096;1=4096;2=4096;3=4096
>>>       L3:0=ffff;1=ffff;2=ffff;3=ffff
>>>
>>> followed up with what it will look like in new generation [2]:
>>>
>>>      GMB:0=4096;1=4096;2=4096;3=4096
>>>       MB:0=8192;1=8192;2=8192;3=8192
>>>        L3:0=ffff;1=ffff;2=ffff;3=ffff
>>>
>>> In both examples the per-domain MB ceiling is higher than the global GMB ceiling. With
>>> above showing defaults and you state "If the MBA ceiling exceeds the GLBE ceiling,
>>> the effective MBA limit will be capped by the GLBE ceiling." - does this mean that
>>> MB ceiling can never be higher than GMB ceiling as shown in the examples?
>> That is correct.  There is one more information here.   The MB unit is in 1/8 GB and GMB unit is 1GB.  I have added that in documentation in patch 4.
> ah - right. I did not take the different units into account.
>
>> The GMB limit defaults to max value 4096 (bit 12 set) when the new group is created.  Meaning GMB limit does not apply by default.
>>
>> When setting the limits, it should be set to same value in all the domains in GMB control domain.  Having different value in each domain results in unexpected behavior.
>>
>>> Another question, when setting aside possible differences between MB and GMB.
>>>
>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>
>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>> same:
>>>
>>>     # cat schemata
>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>     MB:0=2048;1=2048;2=2048;3=2048
>>>
>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>> MB limit:
>>>        # echo"GMB:0=8;2=8" > schemata
>>>     # cat schemata
>>>     GMB:0=8;1=2048;2=8;3=2048
>>>     MB:0=8;1=2048;2=8;3=2048
>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
> Thank you for confirming.
>
>>> ... and then when user space resets GMB the MB can reset like ...
>>>
>>>     # echo"GMB:0=2048;2=2048" > schemata
>>>     # cat schemata
>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>     MB:0=2048;1=2048;2=2048;3=2048
>>>
>>> if I understand correctly this will only apply if the MB limit was never set so
>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>
>>>     # cat schemata
>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>     MB:0=8;1=2048;2=8;3=2048
>>>
>>>     # echo"GMB:0=8;2=8" > schemata
>>>     # cat schemata
>>>     GMB:0=8;1=2048;2=8;3=2048
>>>     MB:0=8;1=2048;2=8;3=2048
>>>
>>>     # echo"GMB:0=2048;2=2048" > schemata
>>>     # cat schemata
>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>     MB:0=8;1=2048;2=8;3=2048
>>>
>>> What would be most intuitive way for user to interact with the interfaces?
>> I see that you are trying to display the effective behaviors above.
> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
> what would be a reasonable expectation from resctrl be during these interactions.
>
>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
> hmmm ... this may be subjective. Could you please elaborate how presenting the effective
> settings may cause confusion?

I mean in many cases, we cannot determine the effective settings 
correctly. It depends on benchmarks or applications running on the system.

Even with MB (without GMB support), even though we set the limit to 
10GB, it may not use the whole 10GB.  Memory is shared resource. So, the 
effective bandwidth usage depends on other applications running on the 
system.


>> We also need to track the previous settings so we can revert to the earlier value when needed. The best approach is to document this behavior clearly.
> Yes, this will require resctrl to maintain more state.
>
> Documenting behavior is an option but I think we should first consider if there are things
> resctrl can do to make the interface intuitive to use.
>
>>>>>>   From the description it sounds as though there is a new "memory bandwidth
>>>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>>>> GMBA allocations while the proposed user interface present them as independent.
>>>>>
>>>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>>>> enumerated separately, under which scenario will GMBA and MBA support different
>>>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>>>> I can see the following scenarios where MBA and GMBA can operate independently:
>>>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>>>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>>>> I hope this clarifies your question.
>>> No. When enumerating the features the number of CLOSID supported by each is
>>> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
>>> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
>> No. There is not such scenario.
>>> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
>>> scenarios where some resource groups can support global AND per-domain limits while other
>>> resource groups can just support global or just support per-domain limits. Is this correct?
>> System can support up to 16 CLOSIDs. All of them support all the features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  each feature.  Are you suggesting to change it ?
> It is not a concern to have different CLOSIDs between resources that are actually different,
> for example, having LLC or MB support different number of CLOSIDs. Having the possibility to
> allocate the *same* resource (memory bandwidth) with varying number of CLOSIDs does present a
> challenge though. Would it be possible to have a snippet in the spec that explicitly states
> that MB and GMB will always enumerate with the same number of CLOSIDs?

I have confirmed that is the case always.  All current and planned 
implementations, MB and GMB will have the same number of CLOSIDs.


> Please see below where I will try to support this request more clearly and you can decide if
> it is reasonable.
>    
>>>>> can be seen as a single "resource" that can be allocated differently based on
>>>>> the various schemata associated with that resource. This currently has a
>>>>> dependency on the various schemata supporting the same number of CLOSID which
>>>>> may be something that we can reconsider?
>>>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
>>> The new approach is not final so please provide feedback to help improve it so
>>> that the features you are enabling can be supported well.
>> Yes, I am trying. I noticed that the proposal appears to affect how the schemata information is displayed(in info directory). It seems to introduce additional resource information. I don't see any harm in displaying it if it benefits certain architecture.
> It benefits all architectures.
>
> There are two parts to the current proposals.
>
> Part 1: Generic schema description
> I believe there is consensus on this approach. This is actually something that is long
> overdue and something like this would have been a great to have with the initial AMD
> enabling. With the generic schema description forming part of resctrl the user can learn
> from resctrl how to interact with the schemata file instead of relying on external information
> and documentation.

ok.

> For example, on an Intel system that uses percentage based proportional allocation for memory
> bandwidth the new resctrl files will display:
> info/MB/resource_schemata/MB/type:scalar linear
> info/MB/resource_schemata/MB/unit:all
> info/MB/resource_schemata/MB/scale:1
> info/MB/resource_schemata/MB/resolution:100
> info/MB/resource_schemata/MB/tolerance:0
> info/MB/resource_schemata/MB/max:100
> info/MB/resource_schemata/MB/min:10
>
>
> On an AMD system that uses absolute allocation with 1/8 GBps steps the files will display:
> info/MB/resource_schemata/MB/type:scalar linear
> info/MB/resource_schemata/MB/unit:GBps
> info/MB/resource_schemata/MB/scale:1
> info/MB/resource_schemata/MB/resolution:8
> info/MB/resource_schemata/MB/tolerance:0
> info/MB/resource_schemata/MB/max:2048
> info/MB/resource_schemata/MB/min:1
>
> Having such interface will be helpful today. Users do not need to first figure out
> whether they are on an AMD or Intel system, and then read the docs to learn the AMD units,
> before interacting with resctrl. resctrl will be the generic interface it intends to be.

Yes. That is a good point.

> Part 2: Supporting multiple controls for a single resource
> This is a new feature on which there also appears to be consensus that is needed by MPAM and
> Intel RDT where it is possible to use different controls for the same resource. For example,
> there can be a minimum and maximum control associated with the memory bandwidth resource.
>
> For example,
> info/
>   └─ MB/
>       └─ resource_schemata/
>           ├─ MB/
>           ├─ MB_MIN/
>           ├─ MB_MAX/
>           ┆
>
>
> Here is where the big question comes in for GLBE - is this actually a new resource
> for which resctrl needs to add interfaces to manage its allocation, or is it instead
> an additional control associated with the existing memory bandwith resource?

It is not a new resource. It is new control mechanism to address 
limitation with memory bandwidth resource.

So, it is a new control for the existing memory bandwidth resource.

> For me things are actually pointing to GLBE not being a new resource but instead being
> a new control for the existing memory bandwidth resource.
>
> I understand that for a PoC it is simplest to add support for GLBE as a new resource as is
> done in this series but when considering it as an actual unique resource does not seem
> appropriate since resctrl already has a "memory bandwidth" resource. User space expects
> to find all the resources that it can allocate in info/ - I do not think it is correct
> to have two separate directories/resources for memory bandwidth here.
>
> What if, instead, it looks something like:
>
> info/
> └── MB/
>      └── resource_schemata/
>          ├── GMB/
>          │   ├──max:4096
>          │   ├──min:1
>          │   ├──resolution:1
>          │   ├──scale:1
>          │   ├──tolerance:0
>          │   ├──type:scalar linear
>          │   └──unit:GBps
>          └── MB/
>              ├──max:8192
>              ├──min:1
>              ├──resolution:8
>              ├──scale:1
>              ├──tolerance:0
>              ├──type:scalar linear
>              └──unit:GBps

Yes. It definitely looks very clean.

> With an interface like above GMB is just another control/schema used to allocate the
> existing memory bandwidth resource. With the planned files it is possible to express the
> different maximums and units used by the MB and GMB schema. Users no longer need to
> dig for the unit information in the docs, it is available in the interface.


Yes. That is reasonable.

Is the plan to just update the resource information in 
/sys/fs/resctrl/info/<resource_name>  ?

Also, will the display of /sys/fs/resctrl/schemata change ?

Current display:

  GMB:0=4096;1=4096;2=4096;3=4096
   MB:0=8192;1=8192;2=8192;3=8192


> Doing something like this does depend on GLBE supporting the same number of CLOSIDs
> as MB, which seems to be how this will be implemented. If there is indeed a confirmation
> of this from AMD architecture then we can do something like this in resctrl.

I don't see this being an issue. I will get consensus on it.

I am wondering about the time frame and who is leading this change. Not 
sure if that is been discussed already.
I can definitely help.

Thanks

Babu



