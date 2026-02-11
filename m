Return-Path: <kvm+bounces-70898-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGVWIJMMjWkCyQAAu9opvQ
	(envelope-from <kvm+bounces-70898-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 00:11:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AEED1283F0
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 00:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E184B30EAAFE
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 23:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E1B35772B;
	Wed, 11 Feb 2026 23:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NGsx/P2C"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010051.outbound.protection.outlook.com [52.101.46.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2809353ECE;
	Wed, 11 Feb 2026 23:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770851463; cv=fail; b=t27vD7/lKsVKevgz0vinXmyW/h+WmgfNy+IrlHe3JuWY9LwQeTsGJ1uDS5majjYXnf3A4FOklb57cgZZj6ndWzdRsWqeG4NQxmedUuEBFTWib0l0ZEplnvzfzA+P7VpxpWHZD7Qdm4okqvqMXyCRb4oIxdD5ZB+YXgd+Nxpl+Qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770851463; c=relaxed/simple;
	bh=83dukreWEsxOcfCbi57t6bFOg9LJG5Sk6ttr8mKb+HE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E0sfgOiPIHEjR2Dg0LhAn3xg/rFP8VJjUF11bmIlTu45EIiJ9KQkbg5mjO5fH7WUoPvzoYywUVzsSsbPFjG0b9RBbKs2WRzncbYlMGcnRy2NWxje+YjQnqe60g+/2Xzww9o5Xe2CtIj0a0OXvHLXsbgJ9wYiMo+DaCbH+JNdc/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NGsx/P2C; arc=fail smtp.client-ip=52.101.46.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hPh0856jEMRyZeY3BZRAlOGZXCdRV63Hk/rM2S4HzfWo93AAZBELJKsCMZqM3EXZcbQhxRkGTBHrngCq7IbGnZeuUURF3gij9twUt9MGP0PGosBaLvha/w4Y4unA1xuzl3ehItT86+m9QmYxyp+aSbTK2Nf7jvJRdGVJqc+SWG50KKPCYiNh543+yorEImSKBWLaBIIvfhyNhVJXEy8XdZMzPqVGwJOBCBqFdcmTOeH8uzfwVvnVlOotUgxWfyUsNZ/Rr8D0+t4X/DrGFchN5ND9/oN7XDpCYMffAw7rjxZcxX1pFqQTz1IGJq8wKH6YajpfilpWFpMVd9fF17Fyxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EYmDkrEHqFTkDJigGjC5NzXomWQwcISZSzbTEeTWnw=;
 b=rOreRLttMHvjZQksMGNInnbpqnG/Fqs8GcPg67pbi2SmEg9WVcc2ZCZPo/iyZnf+ZxfGWyT5vNjWQyFWLAMC9Q9Yp2q3cylMamR73Xaq5VaTAE5gQPDT2z0wiPZr8aFXm32M4iF6grJGSW2cI0XP0KqS3FSeE0Max3l6f1ayDbyb5TS5AJXRNvEhbjVyLLwjKc4txJfBHz3WH1PEcnGQ8WIZdIJfTcJAG3xXEUojtYp5aMJLAhtNFDpWDadNwxcGF9Sp5htcgocscbrSNbRCAK9vYUHHsXyLMSKgFR1z8EI5lQ3YYlheFuPvQ7xTINOOQigwMkvgXBS8m7sxzZNr3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EYmDkrEHqFTkDJigGjC5NzXomWQwcISZSzbTEeTWnw=;
 b=NGsx/P2CY0FZnJPYC2x+U2nIZ32wWnE9s2KEVhDpqEPwbfz1h3emMH9lGdebYpM8FFzeF5pbYaRF8CPPd58RjwZZu/RTiOFoy9N+endrtozxI/neYBVp8MqFm6j0SY/OAOoRdFL8Fj0z8XjfqG7yFQywuinZmAGgmvDCTNfoHyg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SJ2PR12MB7943.namprd12.prod.outlook.com
 (2603:10b6:a03:4c8::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.20; Wed, 11 Feb
 2026 23:10:57 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 23:10:57 +0000
Message-ID: <a6f9077a-0e0a-4bf3-9e1b-a29c29e74b6e@amd.com>
Date: Wed, 11 Feb 2026 17:10:51 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 16/19] fs/resctrl: Implement rdtgroup_plza_write() to
 configure PLZA in a group
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
 <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
 <6fe647ce-2e65-45dd-9c79-d1c2cb0991fe@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <6fe647ce-2e65-45dd-9c79-d1c2cb0991fe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0182.namprd03.prod.outlook.com
 (2603:10b6:610:e4::7) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SJ2PR12MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: e71757b3-7b69-4cb7-5e95-08de69c2d005
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnphMGxvaWNsNGg4Ym5sbEFZV0tyUU0vWHlYbndxQ2hYQzlhcDdZY3BiSjI3?=
 =?utf-8?B?aGVaQXFYMjE1bTVMY1lkWkRHeVAxMHErTmhQRlQrMkFOR0sxd3VtMFd6aFhK?=
 =?utf-8?B?Wkw3T05VeHJNdTBRYXpuYk41VnhBczhXNVZvS0lYcERhazQ4OVdQS0RLbFk5?=
 =?utf-8?B?UTNQZVdjOEhrZzIzWVJPNFJ1MkJ3c3B0UkFwTUpiSEJaamE3WmhXcWJjc1o3?=
 =?utf-8?B?NDFydGdkbDhBUGhhaFY0eTBhbWU4ekFOQ1ArTDlRd25rS2Ftc1BMd3ZkWEFB?=
 =?utf-8?B?d2c5ZGxRS0F4WVJWMkdjeHJhMUhJZk15blUvakNZck9OQ3lrV002RWZNWmlR?=
 =?utf-8?B?UUY3cWoyR2JRMlN2aDFjcGtBS1hPcXNGM3JLOXIxRllPSFU4SUR6YnpZSmsw?=
 =?utf-8?B?QkZ6Vzg0QUs1NHcvYjgzOThVRHFDVjljem83MDZCK0c0TE94aTRwNUNzUjlk?=
 =?utf-8?B?bTh4aDBrU0pna0wxY3VWL2FVQWNocm9HOWxGbkxwb3c2amNUL0RGR2Y4bm1F?=
 =?utf-8?B?YlJUKzNXMjhTS2ltYnJUR3BieG1IMFZJSXVCYXBKRnFKK2pjQnVpSnpEc1pM?=
 =?utf-8?B?VjZUU1Z5a01vZ1d0TTNBcjNMa2xocG1tN1JveFdMcXRhRTZNbGJqd0Y2T1VF?=
 =?utf-8?B?YU5ZSWtRVWVUYXNsanlHdzNoNU1GZVVUWGRnN1BiUlYwdnByS0VjRys4VXR2?=
 =?utf-8?B?emlVckhMYjRPQ09LS3NXMm0zREZrOTJ1Z1RTYnhQKzNZSThaVEJaaTZVdzlk?=
 =?utf-8?B?RXVOZVFpV3hoTUFXOFA1UlpLQ2tXekFuODBXbm9mUE1TL3dPSkc1UzVaTms3?=
 =?utf-8?B?SXk5S21jNGN2b0hBSzJvZ0Y1Zk15akVTUDB6Ukc0UVR5ZDdlUk9PMVNZR1VI?=
 =?utf-8?B?ckI5SStmOHpaZ2gxOGY2dmN0WlFWQVJxejcrUG10L0pkaGtIV3E1QUxZKzNa?=
 =?utf-8?B?RVZyQi9DTjNidDBDSzBPbHVjT05tNmtuNnRaKytjL2xxeDJKeERlOE1LWVpO?=
 =?utf-8?B?Rmk4ZDZnN1paYWFnN1Y0WCtNRlNROXp2dlg1Z2pmSE52NzE3L0JRNG03Q3Vq?=
 =?utf-8?B?dnhlS2F1aER2WTBLdzcrUjNMOUVNK3ppcEMrbCtIRTVDdEQ2TXF2eWFJMktP?=
 =?utf-8?B?MisyYkR2Wnl1T2VUVWIrU0RLUHRUVEUveU9PNHhuRzFiTDdwQUZtbVczN3Vs?=
 =?utf-8?B?bStPM1ZuS3gvZ0hiYzg2SjJJV3gyU3I4NEYyWjhlUWZTbkZrMmJ0UStvMzJG?=
 =?utf-8?B?ZU1BRU5hZVhFeU93SVptM3NkeWs3OWpqb1JRNDZvSGtDeFozNUxYb3B3WVhw?=
 =?utf-8?B?RGc3SUVOc1pEY29wRlRZMllOVTkzd2NWKytXNnpTUDV0RWRwMUJaaVAyZldF?=
 =?utf-8?B?NGJQMFFVZDZ2OTJjSlQ3TG5aNWhRZlA4WTkxVUZsTENIRjN4Sy8rNTI2dzBo?=
 =?utf-8?B?YnBZN1VQOE5idmNtek5tdk02WDMvaFFSSEFITzl2Rnd0dkdSTW5EWUhvMkR6?=
 =?utf-8?B?c1lHTHFJWDVvYkhUdzcxMEtiL0Y5ckxDUDdhYXFCNWNOU29UTFVQVENzSEZ4?=
 =?utf-8?B?YzRiMXY1aHo1Z25keENWb1pWaS9HT3ZleVk4eWwzeDc4cjkwMnN1dUJYS1hm?=
 =?utf-8?B?YmNoM0ZWQ1Z3eWNvVGZkakxoRmNjc1hlcUE4K2VyV1EzcW1aMHhvNTFsdXNr?=
 =?utf-8?B?aDU0dWFzU0FyeUt3NGhwenJtT0ZFM21LR1hqUmtOemcrazNvNktZOFAyWVEw?=
 =?utf-8?B?aldRUDU0cUdwdGljOGQ2TlVsaFJOUm4zUHZYQ05Jdm1aT3NmUEVFZy9PSmpH?=
 =?utf-8?B?cFN2aXkxUXBnc2RRcUJFRTNaMUVTREhxQTNBVzM1NFlnWUFya0dqS3RBNWNE?=
 =?utf-8?B?Z0psdGxFbUhIdjlveCtVcnVjYnpqMWFFTkRtdXFwbDZmZEhwOFhRcVVOMVQy?=
 =?utf-8?B?cjl6dmhNdC9LR01KdWsrV2k1SUpwNEZJK2QxR2JRVFh5dUZGdEZGUUFzWnNl?=
 =?utf-8?B?NVIwL2dNQ0ZEWU5EUzdNMGxrcVRrM0YzOWI0dEVTN0xHaHlMTkMvSlMvLzk2?=
 =?utf-8?B?M2R6SWdGd1h2NVN1R1M0WjF1MUNrZUoxZjY5NDF5QWtqVHJWYVFNbFBrMFlp?=
 =?utf-8?B?QUpaUlh6a29WSlNnVnVoU0hOWDg1SFdoN1RwYkxxbDlueU4vWWZtTnFzZDRU?=
 =?utf-8?B?dVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MU4xZmlYWUc4eHJhdkM0Kys3NURkOVdneTlZQURZL011cTU4UzNuRnBmUFV1?=
 =?utf-8?B?MnFJbEp4M1RNTFRxN1VUN0E1MHM1Snh3MlNzSHM3QkQwV25RZ2VPViswUFpD?=
 =?utf-8?B?NjhrcXJzenlBenY0SUsrMXN6dGpvVXVhT3hQZUhVTTBCRHJzUU1ZcjF5dFRi?=
 =?utf-8?B?aURGQ2Rra0JuRUZzYjZQS0liNlBvRXk5dFVLZldCSjF0cCtjWkl4M0ZhSnh3?=
 =?utf-8?B?Yng5WDRUL1FsaWlrOW1BRHVTc2xDcjEya3JVSmUrcm9MMEhjTUk4RW9aNHkw?=
 =?utf-8?B?N3dsUngya3RscHEvQjFCY1VTQVFuMmRRL0JwenRuWEJkUzZuU0JjUjMxZmR4?=
 =?utf-8?B?N3ZieFREeHBmUnNRdDVpa0h0dVAxaWtJYUFxZFB0dEV1cDdJSTloMURCbm12?=
 =?utf-8?B?OXkzblczYnRac2xVTjNya3Y4Q2dvaVNXY2Z5cWsyRXBndjZyT1VBR29JYXJt?=
 =?utf-8?B?Z3JLN245bklLTDkyU0xjcjJZbGV2dFhsbEp5eTkxYjBRbnJyUi9IQ0x3QXBH?=
 =?utf-8?B?MmRYMVV2eEs0a1R2QWJ4RGJwY01YeVpxeHJyaWQzanp6NDhyeWlhQ3pHdGc0?=
 =?utf-8?B?dUtySkp4YzQ4QzlWcExLUzZLY2VSMDFOcHVFZDhzVjNYdXlzNUdaTEJOaDJw?=
 =?utf-8?B?ZHRvaWNHeE1CVjMwbm4rSktleVQzUjVTcnlLOFFvUGFMMXNibCtrNVFlUkdB?=
 =?utf-8?B?OVdZZHdGSTRnRjMwWnVSUVRJeFBJOGY0dnA5MFhDUSsrS0JaUFFjbUtHKyt1?=
 =?utf-8?B?bll3M1JuNmJPK2N4WnV5eG1Zc25qNlhVL1IrWlR5UlZjZ3kwWGRVZzN1bisx?=
 =?utf-8?B?RFRPWllxK1hieDJJYmgwMEd0blhRQ1pmOHFtVFJKbzNLdVd4V0tIcnBsV0VL?=
 =?utf-8?B?VFI3VS9tRzhqamFKbWtVLzhlYlFuQnZscDVnOHJNR0RiaVRvVmFEdzhrVGkv?=
 =?utf-8?B?SkxQRFoxSVpCT1l3ZHFQZzdJeVF1eTlNY0h5aHl6WlB0NjQyVUxPNG9lcnIr?=
 =?utf-8?B?aUxyVzhBU1h4VjMyK1JMb0JxU015M29OT0IwZzR6TUkrSURjSFE0YzQzaldk?=
 =?utf-8?B?MWdhRVhRaGdPWkFFMldybDZNNExaQWVwSDFrYUFSa1JmaFByOThlOFFoNDlv?=
 =?utf-8?B?R1VaMDhqa0dHUWNPbThRZ3V3ZTAydXFCdnhpU25Wb3I3Q0RMaVdRM1VZemkz?=
 =?utf-8?B?aTBsTGo1M1FmVHFmRUNkWS9WM1FSYXdHaFNyaWtvb2wrQTl4NUVvUkxyNFIx?=
 =?utf-8?B?UmJTeFBFZndWUVMzeE5aclFhb29HN1hEcmJEbHJabHMyZVJQQWd6Y0U0UjNG?=
 =?utf-8?B?VGJKdGV6ejJISW5zS1dqdStMcDV6Mk9jYWZTMG92YnEyWVgrbUkxVnJmMHlz?=
 =?utf-8?B?NytKdzIxUW9XZWdmTFk2a1J4YUxkN1dtV1JrZ0FIYUhrZFc4aUtocUowSXdH?=
 =?utf-8?B?T3RXM0tQd0ZQNDZsdkQxZldYUXNmL0FoL0UyTkhxNlNGaitJNzNvTFJ1M1lQ?=
 =?utf-8?B?b1VmRFVHd093K0hKOEJrQkh6ZXFhRmZ0WkFhU0FmU1FBQVlUU09HUHlDOXQx?=
 =?utf-8?B?WDB1T1ZoMlRkVDhZYXlhWWhiWkZhMDFWY0EwWnEyazh5QUtLSUJwZ2ozelBU?=
 =?utf-8?B?SkUrR2x1M2c1bUoyZGlWOFR3eUcyYmE1U0FrUVMxOVNHY016RjVTdldIZ2xQ?=
 =?utf-8?B?YzZPODFFUzluUEUyVUJzKzBxQUlZY1R3eG5BUDc0bFRhb1ZhNzVRRXlxeXNz?=
 =?utf-8?B?cWdDdFlYTS90R1IvN3pQQUFoWnlKWndnQVJvTWh3OWg4MTdtbW9BZm9scGpT?=
 =?utf-8?B?bitJVjlkWWRpMm1aM0MwQks4K1Z6S0hHNG81MkwyekxkWEovYVEvTFhudW01?=
 =?utf-8?B?YzBxRXEzaDVrdHpFUU5qSUVkci9rWmpkT2UybURKZ1VVbFhxZDdKSXNNVUUx?=
 =?utf-8?B?cWY3UmptcnY3cTFJMHUrQkV2ZDZoaUxYWFpkQ2doTU1RQ055bjZSY21VRVdS?=
 =?utf-8?B?c2tvamhSRG9PRUJ2OGM3dmFwMFd1NGVicUlXYS9GYTFOZHQ3c21jV1k0L1Q0?=
 =?utf-8?B?Q2M0QnV3YVhEaDJWdVM3L1R6SFFYS0lMY1VJZmxaYy96MjBBVjRocmZLM094?=
 =?utf-8?B?RlYySklHK1FuZWhWL3Q2RnVONkgzejJ3YnlqSHhrKzBuZGwzNjA3WlVkbmRT?=
 =?utf-8?B?cUtvRjg2aFAyTEZEUXJFYkg0U3lYa3pkRVk2Vkp3aE91NHpJU25scXdxN3lq?=
 =?utf-8?B?RFMrTDBTdU1rVVU3Snl5U3NNU0p6eEFWZXFMdlVwQlo2Y3JYdXFmWjk3NG1o?=
 =?utf-8?Q?RWkc1/rOQO6YiGSNIM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e71757b3-7b69-4cb7-5e95-08de69c2d005
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 23:10:57.0136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zOqOl7bHhd2mYJXhafYWs4REEeWHu/ImC1O5h/tNW7SOjhU5xJmwdSd7PnAwjS4z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7943
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
	TAGGED_FROM(0.00)[bounces-70898-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 2AEED1283F0
X-Rspamd-Action: no action

Hi Reinette,

On 2/9/2026 6:05 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 1/21/26 1:12 PM, Babu Moger wrote:
>> +static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
>> +				   size_t nbytes, loff_t off)
>> +{
>> +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> 
> Hardcoding PLZA configuration to the L3 resource is unexpected, especially since
> PLZA's impact and configuration on MBA is mentioned a couple of times in this
> series and discussions that followed. There also does not seem to be any
> "per resource" PLZA capability but instead when system supports PLZA
> RDT_RESOURCE_L2, RDT_RESOURCE_L3, and RDT_RESOURCE_MBA are automatically (if
> resources are present) set to support it.

Yes. That is correct. If system supports PLZA, it applies to all the 
resources.
> 
>>From what I understand PLZA enables user space to configure CLOSID and RMID
> used in CPL=0 independent from resource. That is, when a user configures
> PLZA with this interface all allocation information for all resources in
> resource group's schemata applies.
> 
> Since this implementation makes "plza" a per-resource property it makes possible
> scenarios where some resources support plza while others do not. From what I
> can tell this is not reflected by the schemata file associated with a
> "plza" resource group that continues to enable user space to change
> allocations of all resources, whether they support plza or not.
> 
> Why was PLZA determined to be a per-resource property? It instead seems to

There is no specific reason. Seemed easy to access the property. Will 
change it.

> have larger scope? The cycle introduced in patch #9 where the arch sets
> a per-'resctrl fs' resource property and then forces resctrl fs to query
> the arch for its own property seems unnecessary. Could this support just
> be a global property that resctrl fs can query from the arch?

Yes. That seems like a better approach.

> 
>> +	struct rdtgroup *rdtgrp, *prgrp;
>> +	int cpu, ret = 0;
>> +	bool enable;
>> +
>> +	ret = kstrtobool(buf, &enable);
>> +	if (ret)
>> +		return ret;
>> +
>> +	rdtgrp = rdtgroup_kn_lock_live(of->kn);
>> +	if (!rdtgrp) {
>> +		rdtgroup_kn_unlock(of->kn);
>> +		return -ENOENT;
>> +	}
>> +
>> +	rdt_last_cmd_clear();
>> +
>> +	if (!r->plza_capable) {
>> +		rdt_last_cmd_puts("PLZA is not supported in the system\n");
>> +		ret = -EINVAL;
>> +		goto unlock;
>> +	}
>> +
>> +	if (rdtgrp == &rdtgroup_default) {
>> +		rdt_last_cmd_puts("Cannot set PLZA on a default group\n");
>> +		ret = -EINVAL;
>> +		goto unlock;
>> +	}
>> +
>> +	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
>> +		rdt_last_cmd_puts("Resource group is pseudo-locked\n");
>> +		ret = -EINVAL;
>> +		goto unlock;
>> +	}
>> +
>> +	if (!list_empty(&rdtgrp->mon.crdtgrp_list)) {
>> +		rdt_last_cmd_puts("Cannot change CTRL_MON group with sub monitor groups\n");
>> +		ret = -EINVAL;
>> +		goto unlock;
>> +	}
> 
>>From what I can tell it is still possible to add monitor groups after a 
> CTRL_MON group is designated "plza".
> 

Good point. I missed it.

> If repurposing a CTRL_MON group to operate with different constraints we should
> take care how user can still continue to interact with existing files/directories
> as a group transitions between plza and non-plza. One option could be to hide files
> as needed to prevent user from interacting with them, another option needs to add
> extra checks on all the paths that interact with these files and directories.

Yes. Adding extra checks seemed good idea. Will do.

Thanks
Babu


