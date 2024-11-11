Return-Path: <kvm+bounces-31540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE4929C493B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 23:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E45D1F23FCA
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 22:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558411BC9F4;
	Mon, 11 Nov 2024 22:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u0Ib67xe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC62E156C6F;
	Mon, 11 Nov 2024 22:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731365030; cv=fail; b=ndW6g3BGRlvHh9xGMlBoxKtsdR+277cW69oJzHIgnO5KpuiuPbjX4MX8IHmyWrga0X2At+TYMuHUuTSs/6FoVb0FdsHhkxNcegzN+fQ27Vh2vyZEYZww+Lrz441O7kNLOX5wdvhjeho21ot1OPwkDVZzQmScqu1kXv83GcmNDD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731365030; c=relaxed/simple;
	bh=khxo/atcI2K1iZnCazRtdPlut54pqUX51iBCsdu7sUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FMgH5HAuyywSOV1JyLM+Y5hSHKgjd0uhdlcq0b2bn+B3VIFoIuk7JR/xb3k1aOP8uRvBMJLUa6CDNN33m6XUhaIZ0sNAeSyzVTj6rexQC8NUEy3qsUs90FXinRwxUdD0D9OqQr8KevdJFMwBF14N8sciD47BUGyryOQQuVu3DFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u0Ib67xe; arc=fail smtp.client-ip=40.107.223.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oXHR41PdyxJWbwFLxrLY2IqegfhAwzqGcuMoQmxrMRU1hYp+DcbyC+qhl064UMxYfgs14khu+E4J72ZjnlhverWXP+2PD1bt0UFxWLubm17RF4DStkr3ybTvG8G19M7edAgqD7uFu2BUCJ7pR77hZkvR9cpkDA749TWKqCRFAnqW1iHlwJKtT2b2rDIG6dHgmkr5kcz/8NUqiIdWP7JAi3P/HjZ37rvCuQ7EYcsGWGMTueBIDlB+nWmPvGrZZczbFmiM0uO0cvuAsUzC5b12+vKcVtt6GixK+AiYZGRrqQTMrYkqzbXl/ir8EWyXSkY+yi7Juv8BrmxOfRaV3jtxwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wswjoFpf+eSCHWdoL7gfj5Nh9rdCso6asJ1p3rA5d44=;
 b=Yfxwo0kKFk9qn0fRzqgTJfeqq27n9s5sv1hP+trS40FemNtUgUOlpu0mhPKiMzBk9ohDyzETK0X5HHrBQbKvrREjERudQZBy2zNZK6Lsm2Bes8fMZ7ODbcI9KHrKV2KxaKLmtKKnw7h3R2vcp5UpHTIqr9kKEW9JBAEgeMXwPVZuDkirgw8kWwdrlWU3jY++M2kOD+K+1mR8N7cUBLWKP9Tx3Klw+2nrcAMXc2VIvx4QtZJKCIEFHPGjZhbXSbynVzpgLkAUBngiI/4hV326m5279CdyPOt3bPpk0MTnZu4NDGbwjjmS2RG3ZlTNGTcDooqNY+b3RiOG/05nDz4HbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wswjoFpf+eSCHWdoL7gfj5Nh9rdCso6asJ1p3rA5d44=;
 b=u0Ib67xejvHpLCr1Qpue0iddm6HmVjyfvPr9kBet2hyJKxCOWXGRrMED3haqjQ3wgBdyDebOxfHmnibpO3c0z1l9NCDMrI1HEyUdL1hTKcc6LHoU/JK2L98vm4WtBfSt25cTAHFI7r98hzKYUuXeCMy5t98Yah/BIFmat4lIySg=
Received: from SJ0PR13CA0126.namprd13.prod.outlook.com (2603:10b6:a03:2c6::11)
 by CY8PR12MB7588.namprd12.prod.outlook.com (2603:10b6:930:9b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 22:43:46 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::bd) by SJ0PR13CA0126.outlook.office365.com
 (2603:10b6:a03:2c6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.15 via Frontend
 Transport; Mon, 11 Nov 2024 22:43:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 22:43:45 +0000
Received: from [10.23.197.56] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Nov
 2024 16:43:43 -0600
Message-ID: <e14060e6-ecd7-4933-b53e-e810d747c335@amd.com>
Date: Mon, 11 Nov 2024 14:43:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [sos-linux-ext-patches] [RFC 04/14] x86/apic: Initialize APIC
 backing page for Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>
Content-Language: en-US
From: "Melody (Huibo) Wang" <huibo.wang@amd.com>
In-Reply-To: <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|CY8PR12MB7588:EE_
X-MS-Office365-Filtering-Correlation-Id: 357f7c61-ef14-41bd-f645-08dd02a24d4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NC9ZeVFYY2h6MW9XK2orMkdGb2I4Zy83dXVtckp0ZFdOL1BneDZveWRJcHQy?=
 =?utf-8?B?dXBPMEo1RUNLbFF1dUowclhkV2VpUkU1SHBjdUkyTUxOQzhNdDl5M24zZjVr?=
 =?utf-8?B?Y0h6bUI0T0llNGpBbWUyemJlZFR3Mmd5ODQ4VjV2cnlQOG43N0xGWitmTXNr?=
 =?utf-8?B?VkVreWRKdy9tdGRJdGVWMkN0Q0VrU3p0N0JVSkVUMElLWTFPTHpQVHRzaFlT?=
 =?utf-8?B?M1ZsK3c5L2NRb0RXU1Zxc0d3T1lMN2trMnZwSXIvR2gyVXQvRjgyVEpGSTNX?=
 =?utf-8?B?ay9oYWRDOHFKRjF2OHlPTzBTNjVFY1N0WXcxci9XSDJtSC9mbWZOZjZHVWg1?=
 =?utf-8?B?SXlMSnFoT25FcEMvUkM5SERTSXM0Nzg0ZHB2eHphZGtrelhRbmNadElPM292?=
 =?utf-8?B?VkFOOHZHNnRha3IzYmF5U0ZBRUNlMFpuNk5GT0ZONnNjTnVCUVVGRzBUWVBI?=
 =?utf-8?B?c3k3SG1rRUhqa1ViTzQyUzU3dHF0dnFKYkNPZStsb084aGxUZGxqd0JhTVpn?=
 =?utf-8?B?NnFKZlVacXBZa0VmME5uRmlEaFpmYWJGUjhac0VRYlJIQ2VXYUhGVTJOcHNY?=
 =?utf-8?B?Q09PYlFydjZLOERkTDBxYlpYMzBKRUk3WGxLdVEzQjE2Q3YrV25saGtGZEdJ?=
 =?utf-8?B?MS9hNDFuWkJ4SG5uVndQcDBVZXdiYWxFa3Jna3dDcnlWbkhkSzZqV0JxUFN3?=
 =?utf-8?B?c2hNbTg1dFBESVZZc0ZxN3FYR2xtR0hFdCtHY09EemRuZG1UTW9LbGxMOEcx?=
 =?utf-8?B?QXBTK0lxQjE4c1gvQ2VqTUlvazdTN3E1ZEhFdEd1WFJMWjBManQvNjdFWDZn?=
 =?utf-8?B?V3c2ZTlzaUZ6RFdFd25YS0VKN3VTNnI2dFFRdlNsREZ1ZkZNV1RKUHBvS2pn?=
 =?utf-8?B?VVlVM0xvZkZDV29TeXpucVFCVThkTnZxek9Ja3N0Qm50ZUFTaXdaclBmS2xO?=
 =?utf-8?B?MldTT0x0VkgxaStnMzgrWk9QSDhha0w4RU1pSGN4ejhxei9FQ29pRk9HeXFp?=
 =?utf-8?B?UlUxaHdPeFNHVWh5Y0tyTHdrZkVqUWQxa3I3bWtTWERLWWNaalV5cjdCVGVs?=
 =?utf-8?B?bDdWTkZUVkg4aTYrQWJNNU5lNUp2aG5BS0hiWk81RjhZVnE1QkpDd3JMNS9s?=
 =?utf-8?B?eWpWTmdKdGdyQ3VUdnJUV3dhNWlNYlRUV1QwaUh4bnkwRGZtU3hNZVA4SXIy?=
 =?utf-8?B?cU9RYThsQjFZR2xSSDNneUMvMldXV0wyVWN4VWk1RjZoTFZIb3dheUdNeG5E?=
 =?utf-8?B?TjdPVDZTbXYxS2NuZ25wSXYvcllPWkx1TzNOZG1EcEw4VGw2MFhqbVhVNG56?=
 =?utf-8?B?U3RUOEpiRm1JNi82L0JoVGpRM1ErL25nVmROQURqTnVqQTBqelpQM3NPQ2hI?=
 =?utf-8?B?Y1ZLc2pIZHBOS1NyVGIxVmkvdFNEK2p3UktwU2puN1Z4QmFreGV3ajMzRE9N?=
 =?utf-8?B?cFhUQmhabTl2aTNqbHBYRld6emJiWXlqUFl4YW5xNjM1M2JLMkcxKzBncGox?=
 =?utf-8?B?Q1g5VWVZM2VTUFNkMS9xclN5bXhOL2lRQnI2RkszVGF0T2hMS3BNTnpQMnhn?=
 =?utf-8?B?ajRUeCs1VFMzL29kNE1uOVg1QnF4a3dNTnlQZEpORW5iN0h6azhaOXczOFJQ?=
 =?utf-8?B?ZXJacmNPK2ZlYVpRbVlESHBrbjNodHNaVmUrRnUrMk1qeG4xcDZWbkV4Ky9L?=
 =?utf-8?B?aDlIS1gwVndXQ0oyalJER1JjK2VBSFFiYjRPaDNTbWd2WkdONjA2MndqcUxy?=
 =?utf-8?B?MzB0MjVZcG96VThhcGNJMDJKVTNQTENIZ2tCcXVyVTg1d1ZnTDEvZ0wxM0RD?=
 =?utf-8?B?L0RQU3d5RHJlblorZlE2ZVdDVlZTL2g1bWFWM3BpdWhUaVJiM2dGczVEMU84?=
 =?utf-8?B?OS9OQmxHK3NEUGgvZjdjYjRLOFN4Wko1a1pnSVk2VFpHNHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 22:43:45.8265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 357f7c61-ef14-41bd-f645-08dd02a24d4d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7588

Hi Neeraj,

On 9/13/2024 4:36 AM, Neeraj Upadhyay wrote:

> +static void init_backing_page(void *backing_page)
> +{
> +	u32 val;
> +	int i;
> +
> +	val = read_msr_from_hv(APIC_LVR);
> +	set_reg(backing_page, APIC_LVR, val);
> +

When you read the register from hypervisor, there is certain value defined in APM Table 16-2. APIC Registers, says APIC_LVR has value 80??0010h out of reset.

More specifically, Bit 31 is set which means the presence of extended APIC registers, and Bit 4 is set which is part of version number: "The local APIC implementation is identified with a value=1Xh (20h-FFh are
reserved)".

I think you should verify those values instead of just reading from the hypervisor. Also, I think you probably should verify all of registers you read from the hypervisor before you use them in the guest. In other words, sanitize the inputs from the hypervisor. 

Thanks,
Melody

