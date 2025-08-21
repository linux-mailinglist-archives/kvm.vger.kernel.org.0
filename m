Return-Path: <kvm+bounces-55265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 576A6B2F55E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 12:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C820B3BC22E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 10:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29D0304BDA;
	Thu, 21 Aug 2025 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2hX44oDb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EC517A2F6;
	Thu, 21 Aug 2025 10:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755772256; cv=fail; b=W646EPSIrm3k8LxpVluUobt58wlPDehYFHWx4HmS0QZ1GvcO3eIJkmaNfQqD09CNUfXTDsQSVgaBrGZcQ/vt3e25TcnKbXlC9/p0tPG9hiLRfucvxxQtLwlKX5p0RjWPd2zHrVq4uSIk8L+azToYAXTxrbXd/kBkBVEVnf1m2Jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755772256; c=relaxed/simple;
	bh=59+uE9LbnxRbHPOcJnxqrwFFLzbC/MmOOb3LCplrQJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ya7aXgSiWF9EcYlAoL/evn0XUgVqVcZY7eRQS1BVuytPmk4NaubJnvnlZfdCSKeT0M3C4X4nn9MOaBvUUxZvRuFyc6VkuFGw2ukLdsWXoxlBkMG0FL04BNnRukyrrcfhQWzxc0FJD2sc4mEaDxSgYILrt2vr5jeAUVfwHg1rHDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2hX44oDb; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kA0lTiQa4a+39aZPU9Xuo4ojDs5QRw5/Iw+7eBblrP1nAamH41Iu+2fZEJXSKWTBWRXrzLJPEiO1FWzyTh6/jhLOim0aFsQmhNM4HdKdKgoMNp5490J4qgChrFqbOAFhWzp01VpdJ943Fnxt3+yM+Vm9yuapJP1gIs8UbsJ0Bfsj4qvH10xG6QFS1E9gHFlHVDkY8tqsEXYj81ma73ltw7HRn/cJvLA/FD7k8QAsOevd75WfnvfWdONnNSfgtauefa4b3+bcgY5GeNRLQCknjT+rKocyyP02fQxCZtyiUz4DeDB9paBl8bVKKUSOuiR3GqSEx8aJF9ob9K3E/Lc60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpDzRj6Ok3bJUhOf2ZTh4l6Oy56Mv9CYzxBZieCO9aE=;
 b=sj1LnsbIC/NNah60YzmW9725TscX7/f24bWhOk3sjKZ7RMTw6fNy3n33KZNIn9816F1Ub+oeAJfHwp0ia5Y0GCfLcQlVTsc12v8MdOLu0PLmOO7Xts6xdcYIWNORbBdxVFlSQ1Qb37gEDmDKik9s58IiTVYZ/HqtwZ8J5vUPWKcr8V4xt7mkgJUenu+wHqOqMROTVLkMkOilOaMDX9ROZK9QV+imbI81b357Rc9bYB/iS/WKeWTntuEfQU9vh5QTL/1InDz6wkXP6isjnWKp0lGrv97oMZAfleb8058d/5MQEcJbNerIHGjHC6YwVHw+V5bhH8Skd7IlOQ/vyZzjaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpDzRj6Ok3bJUhOf2ZTh4l6Oy56Mv9CYzxBZieCO9aE=;
 b=2hX44oDbBtbJUVUiv/8ViuL1Ej5ds4dGRFy51zVhLxH/bSM6t+6tepjWbg72oXnLqkkFFp74jYTVDKsw0id0TdwMYaZ13m28olJ+LEBQNE8yguINnye2sMMYnsQm03qeeMbQma04w5yQKLf0H4jgLhWyj9wozYxMrdZb1k38ojg=
Received: from BN0PR08CA0030.namprd08.prod.outlook.com (2603:10b6:408:142::9)
 by DS0PR12MB6464.namprd12.prod.outlook.com (2603:10b6:8:c4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.14; Thu, 21 Aug 2025 10:30:53 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:408:142:cafe::91) by BN0PR08CA0030.outlook.office365.com
 (2603:10b6:408:142::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.16 via Frontend Transport; Thu,
 21 Aug 2025 10:30:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 21 Aug 2025 10:30:52 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 21 Aug
 2025 05:30:51 -0500
Message-ID: <922eaff1-b2dc-447c-9b9c-ac1281ee000d@amd.com>
Date: Thu, 21 Aug 2025 05:30:45 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Randy Dunlap
	<rdunlap@infradead.org>, <corbet@lwn.net>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <herbert@gondor.apana.org>
CC: <akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>,
	<michael.roth@amd.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <cover.1755721927.git.ashish.kalra@amd.com>
 <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
 <5dff05c1-474e-4fff-a19b-7c17b4db6173@infradead.org>
 <7eed1970-4e7d-4b3a-a3c1-198b0a6521d5@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <7eed1970-4e7d-4b3a-a3c1-198b0a6521d5@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|DS0PR12MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: 16071f50-c6a5-4a29-9fd1-08dde09dcdf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWJBRkMxdlIvQ25pLzlyaFJyUjU1aEhDWGNyY0ZRWDE2Rk1JY0Z2VHhTZVR0?=
 =?utf-8?B?ZlZXVzlxdzF1a0o3cWVEZ2NLR3hRYkYyN2g3RVVueHV4UUlUeWJFYmowNCt6?=
 =?utf-8?B?VzZlZ1F0MHU1VmR4MEwzQzM0NC9uLzQ0dXRrTU5tNVJIanBWRmg3WHpvKzFs?=
 =?utf-8?B?cDZCTEtXNnQ1aGJld0t5dzgyaS9TOFBLUFQ2dHhtYnBOQmZqTXBLUTFxbU5K?=
 =?utf-8?B?VUZnWk5nNE1xTEwzNktiaG93U0NOUlRiSWczTndlSFFzb3I1MUpBK1EzNEZZ?=
 =?utf-8?B?bjRWZCtRejdRWUpvUDJSdGJ5Mm5KaDJJK1QxOEdYNURhZWdEQ2tPZGNsa3d6?=
 =?utf-8?B?aFdGbVpvWFRSWjRYTFU4TU1sZmptS0hjWVcrOFc2R3gvaXZMak5yUDN3UjlN?=
 =?utf-8?B?UEVhcnVtS3JSVDd3NnVGSlBqbC84M09vMUhkd1pyWEFWZFkraWhMTGxpVnRP?=
 =?utf-8?B?NWk3aWhNQmhwRXFnZFU5TXBaQnBQQVRxdFBkZW5IYXhERWtMWjh5a05EM3dk?=
 =?utf-8?B?a3FHV2JoUzhvRjhQRXBTYlRuVkx4WHNkQXhmWlErZkkwelEyRWsvRjJDWG82?=
 =?utf-8?B?L29EMSt3Z2pra3N2WHQyRjdzODk2L2t6d0FrS3Q2ZWFpTEtMbnM5SHk0YUUy?=
 =?utf-8?B?bnBSYmJYZUVrOWVUUi9vUjFEYll5VkdlU2g4aVppN1BGOWVnOVNoUjJONStY?=
 =?utf-8?B?V2dEV0dlaWdNM1MwQnVHeEpSVkx4czRBM0U3SWRJUHVFMUpMSU5RWjB1Yll6?=
 =?utf-8?B?Y25mOTByRUlwM0pGUVVMUjNDT3ZaSzNObFpWODNRVjZIeHRGQkQ2TTdUOFVE?=
 =?utf-8?B?cU1zcDB1ZGVPdEREcEVVVW9CZEpvOERBTEw4WVRCVWlDN05xRkR0bTZKald3?=
 =?utf-8?B?a2lxU2JoenZySGlXaXJKVEE3MUovcGkzQ3cva01QRm5lU0NncUxadHBkYW9B?=
 =?utf-8?B?VktTTXY3NW8ybk5rbnk4ZjBSTHNqMDVjTWxNb3VBdW5KNHN0YllpU3VsaDdQ?=
 =?utf-8?B?VnhlUDVqK3FFcUo1ZjFxSk9RcGxUWWpIc2tQOWRoT2hZVWlpc0hSREkyRXZm?=
 =?utf-8?B?V05DangvZHQ4Z1IvMy9YMWYyNEM4UGJDeHg3TU9QRFVoYW1ZTHRINTVzcjE0?=
 =?utf-8?B?eldrZExFSXFVVkc5WFBKdWhVZFQ2UTkxakxIcklmaERjNXYzaGhNdWg0STFj?=
 =?utf-8?B?b29KTFdkVzgvQjdZRUdpVUpWT2RweEZwYmRDMy91Z1o4THd2YnZFVU5zbDVz?=
 =?utf-8?B?bGJHTUZYRFN3QS96SmErRHk0M2VidFB6c3JCbWRUTUZETXhlNHBaU0F3MTVN?=
 =?utf-8?B?T2lJZW9wWXlTUTdRTEdUWTk2SE1yWFUxYjhNeHVheXVrK0VTYmRxTTBxUXBa?=
 =?utf-8?B?cy9TeUd5L1hPYnFKcFBlZWd6cHluNmlONVVDQ21qdHlzd1NxRUVlelBzNWZi?=
 =?utf-8?B?Wkd6S3BDMXVNSU1rbytGQzhkblNOaU0rTFhveWNXVk40VmJGMDVWUXBSSkln?=
 =?utf-8?B?N2VOWkRSb3kwYXRIVVhqM2J1RzA4cGNzT3oveFJuMWpreEtJaU52S2lWTG10?=
 =?utf-8?B?c3hYNUtaWDQ1eFZhT1dlVGFZR2crQUxaY1kxUlRLbEFMOHp6aUo3UlE2VE9p?=
 =?utf-8?B?cytUYmhwMVZsek1WRlhCV1VwRGdjc2hUcEJ4Z1J3ZUtvenRJcUYrcmd2ZWd0?=
 =?utf-8?B?MWcrUHRXenBLdzRmOFBpZHZtd212MDYrNGw3WUlSTjYrV2RpN29ESktpYko4?=
 =?utf-8?B?UmRwYzJqV0xtMlh0aHZZelJIZVl0UUF6MUhsM0xYOFM4NFhVMjZqQmlUaTR3?=
 =?utf-8?B?RkV1alY2RUJzeUF2T0JLK25sNmlpb3BjODZiY3dKM2YzSXd0MENxbVlVdzlG?=
 =?utf-8?B?WG9DaDQ5OEN5am9rWm9IcllJL1dFWThQZzhYTW1EWGRadTFaWWJ1Vm05L0JE?=
 =?utf-8?B?ZkxWcjZQR000emM0Skg0bEduOGlxRWFORm5xY0s3bjBrVW5NaytjZVhHNVYv?=
 =?utf-8?B?Rmhsa21XSXNnU2dIcXQrZGtSODFVbkVhNnl0c252M2MxWDFJQUE2OEZTVmdI?=
 =?utf-8?B?cHZMdXdUbmZ1enRENDlvaGlMNVhORHdnaXptZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 10:30:52.5967
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16071f50-c6a5-4a29-9fd1-08dde09dcdf5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6464

On 8/20/25 6:23 PM, Kalra, Ashish wrote:
> On 8/20/2025 5:45 PM, Randy Dunlap wrote:
>> On 8/20/25 1:50 PM, Ashish Kalra wrote:
>>> @@ -3064,10 +3070,32 @@ void __init sev_hardware_setup(void)
>>>   out:
>>>   	if (sev_enabled) {
>>>   		init_args.probe = true;
>>> +
>>> +		if (sev_is_snp_ciphertext_hiding_supported())
>>> +			init_args.max_snp_asid = min(nr_ciphertext_hiding_asids,
>>> +						     min_sev_asid - 1);
>>> +
>>>   		if (sev_platform_init(&init_args))
>>>   			sev_supported = sev_es_supported = sev_snp_supported = false;
>>>   		else if (sev_snp_supported)
>>>   			sev_snp_supported = is_sev_snp_initialized();
>>> +
>>> +		if (sev_snp_supported)
>>> +			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
>>> +
>>> +		/*
>>> +		 * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
>>> +		 * ASID range is partitioned into separate SEV-ES and SEV-SNP
>>> +		 * ASID ranges, with the SEV-SNP range being [1..max_snp_asid]
>>> +		 * and the SEV-ES range being [max_snp_asid..max_sev_es_asid].
>> 		                              [max_snp_asid + 1..max_sev_es_asid]
>> ?
> Yes.

So why wouldn't you have left Sean's original 
"(max_snp_asid..max_sev_es_asid]" as-is?

Kim


