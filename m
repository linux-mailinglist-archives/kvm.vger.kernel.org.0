Return-Path: <kvm+bounces-59867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C21CBD187F
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 07:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF9543A4F86
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 05:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A862DECB4;
	Mon, 13 Oct 2025 05:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jj/rN5Bf"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3171DDC07;
	Mon, 13 Oct 2025 05:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760334842; cv=fail; b=IULOfHc4Z8Cr4Hg2lKuI8WCvl6PDtfh7corzNaGSVYeKa1aahamx2DxNp0/rUSJJQWv8bxWTeIlZ+DGKCpkayIy+2l5x9cX6s6JIAbbVSzctUFBTE1lvUSm+GXJIoZy7LgFHdWJcvrrQZvOQD8AFoKSPNsHx+luxeRkUnE1EC9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760334842; c=relaxed/simple;
	bh=YlVlwygvOzBGB0+UtcJ0tf5JiNZV7jQn9WiRVKIiEeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=vGBzA+wlSbm4ShXg9U5Yny30iPgxfcTiHV48dCZajtlwlkWBV3Zi8JSUrXXMObPb8WM3LqZC9uUWNA8vuRtrZznPVoj4gfO6UX8lKS1ZZ5vrUqElE/Des22mH4AsdINQLutiDrdvQdL0EF3C7zwKPk/CXFGXLHZHH51QKN4pCR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jj/rN5Bf; arc=fail smtp.client-ip=52.101.53.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8oQoPQKHqZ2tv6xv9dnnNvGkKMcqqL/ALF0/REQS2z8K7qXuno8U6OQaEzNzX0i9u28JIzkIvrZaKq+g9uJwZ/X6KEB6ElchKA55po3YO0c30dR6KTumRYzaDX0Rd4I4733dXjAG4nkkHzHCHCIB3HNK/CjxDZoxoG8uhL44x+Ol6iYXzjCsdZrkfeGxoG5d08QKgIlKbUGGGb25gN+fp97asArCjc0Q84gMJukAvOgJVgcyUjZHOK+yyv/94Ws1BOkov63xQCTyxztZrTh1Xgm8UKmIbkBrwiBvNSkyv7pBH13tdwJ0wbxiDibBiA2pbItBCOrJp8n6PMiuPqQsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jt9FNqqVAx2DnZE4P2zX8+fxY20/JMuz7uePJJHHmjk=;
 b=MaE/Din5n5FMcmi/P8pzTznR5Rj3E2CEf7S0rtL3awKkn+QKGMfsCs2mS/yd0FlgDHAdn+9sO5SGgJ+8sJea2QFMJbSwd4Ssxh8ntb4xz0yxquiyrxH8nLZgfwLwvQbEH+/Alu/WTYrZ6RvZUy8e7z9JHLIDdJfctTNobouR9odScvmN+Ah7OnE+hMV5M/hb4tNwOeHP6j+KJ8pdI9beFgE+JI5eDTE3uCcWVEK3nrLNjCpMmE6vRAtWcY6Zn4PW0yHNbmA3wZey4hLtaEt4kxeRn9EfPHLkJF/fQf0O4OzgowqKnjWqrR3Uy4jIWXcjotaa2/XpwJMWTGQmRIjz2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jt9FNqqVAx2DnZE4P2zX8+fxY20/JMuz7uePJJHHmjk=;
 b=jj/rN5BfMM1WEpiifXr7Prl+LYHCdUP0Hp8nOkStMpolHsnrpbO7nn31dQAJeVxEQ8+N8s6bRhGINIM9+GdPho50uXWwDzHwRxegH/JEwzf26TmPTkcOa7qMBsQdWrmavDXUDnRKnBQ7Pm/95RHdMHqKkYslfvtX8dHZxG7z3VA=
Received: from BN9PR03CA0493.namprd03.prod.outlook.com (2603:10b6:408:130::18)
 by BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 05:53:55 +0000
Received: from BN1PEPF00004688.namprd05.prod.outlook.com
 (2603:10b6:408:130:cafe::f6) by BN9PR03CA0493.outlook.office365.com
 (2603:10b6:408:130::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Mon,
 13 Oct 2025 05:53:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00004688.mail.protection.outlook.com (10.167.243.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 05:53:55 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sun, 12 Oct
 2025 22:53:54 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 13 Oct
 2025 00:53:54 -0500
Received: from [10.252.198.192] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 12 Oct 2025 22:53:51 -0700
Message-ID: <8aa1c06d-bfb5-49ef-b452-3445481d8b8e@amd.com>
Date: Mon, 13 Oct 2025 11:23:50 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] KVM: x86: Refactor APIC register mask handling
 to support extended APIC registers
To: Naveen N Rao <naveen@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, <bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052118.209133-1-manali.shukla@amd.com>
 <koech6fbxpzzao3232pf4ozloanas4irecti2n3win2ow7aikj@3r72i5qyaxd4>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <koech6fbxpzzao3232pf4ozloanas4irecti2n3win2ow7aikj@3r72i5qyaxd4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: manali.shukla@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004688:EE_|BY5PR12MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 82dc8aee-ae3b-4234-a6cb-08de0a1ce518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dW90MTN2L0o0cDlCSWozZ1JnMU5DOE5oUnNSU0hNUS9qUlJZcmtvU2crZFFo?=
 =?utf-8?B?bTIyOHN4Ty9QRjNUYW13WStZUnRwT0tOcEJjY3lVenZleURxQTRxdW5yK1Vt?=
 =?utf-8?B?MXJuVVl3cEdOVEY1TjhEK3BwbEtiS21lRlJ6TGpCY2V3VXJhbldmeXpTNU9s?=
 =?utf-8?B?UmxBWmNxUzkzU3VKenRmeGhTcG1BN0djSSt6eHlkQk5DQVVTSHFxd2k1MDZF?=
 =?utf-8?B?WGdjT2U0dHNwV2crL1I3Qk1QQUhjcnEvR0ViTEZad2k4dUx0S0U4YTNrK3VB?=
 =?utf-8?B?OWVQUmxSdTZxZ2diOStxWm83WjZLNjVCMzFSeTlHQVRUemhHNzJ5WWUrUkdx?=
 =?utf-8?B?ckFFZ0FGbmNJbGo0TkFwcFNzdU9pZzZCSm5aUjZoWmdyakJNaG9YNDJ3dmFJ?=
 =?utf-8?B?c2QwZldoeVA2bjJOWlNJOWpVcVM3dEFudmhEelNPRjBWclozQkxyeHo1U2JG?=
 =?utf-8?B?SGE2ZExCemlTNmZwY01iM3AvM2NwTFRReldPY1dRRnVVakFSRERQeGI5NGZl?=
 =?utf-8?B?b2gyR3Q2aCtkdlpBMHBCZGs5ajcxRGNIUnZPUnBsb3N1NXhmTUdBVGlRakFE?=
 =?utf-8?B?WDg4TFhOeTlWYnRiQkNxYUtKMGhOV21kcktXakJ0ZVBFNEpRM3BObDVoNUox?=
 =?utf-8?B?cE9WUXFhM2ZJUFYyYyt2Vkl1NlFKaDR5djRPS29nQ094Z1NVR3pTTzlhYVV1?=
 =?utf-8?B?OHNsNnEwYklQMlNaaGNLQktkNXRaZVpOUEZ5OU12UDdEeFBCeXJCSzUyNEh5?=
 =?utf-8?B?RXFSNEhoVHZvZGloalh2dWY4R3hjTHp6ak1hWXNkWHEydUlqS2JFOXhqU1B5?=
 =?utf-8?B?MFM2SkdoZDd3cFBOdG0vTU9MZzBERjJnTWoxRmplY2RLRHdZOGE4RGw3eXpV?=
 =?utf-8?B?YnVPRmRTUDN5US9GNFdha3YwOVQyK0NsZzlQbVh2NDUyK0tKakRMUjFLeDFn?=
 =?utf-8?B?ZTkxSVBPMkNsaGVFV3ZVcjRPbGxTVTZvM0RRL3dySnJrc29aRjBuWWo1SldL?=
 =?utf-8?B?WTVDRnR3bWpWSWgyTjJPU2pXZFBic0lVcVR0K3JKT3daeTNJemsreDJ2RjlX?=
 =?utf-8?B?TjlWVXlta1pKUzJjS2d0QzQ4QkR6d3Qxbm1OaWQ5OTd6REhQbVlGaXlvV1Jt?=
 =?utf-8?B?U2gzVHlnelMwbGxJaGJnQ0VKY243VUhHVFRtVEVtbVFKQjVLVnZJU2k1S0pN?=
 =?utf-8?B?a3VLZEQyUnFHTkRCMzVHQmtkSE1hYVZMRXEzY0JMOGFpYzhJV21idlhQVm5K?=
 =?utf-8?B?TW1iTW85U0t3V0RmSnhWamhtd1N2amJGbGRVWE13VWUvcjJKY1FHQ1RXTFFm?=
 =?utf-8?B?SVlXT2pFaXlseXR3dWpjdDBrS0QyeFNqQTFhQ0VnQ055K1RJa2xCWklpM0hD?=
 =?utf-8?B?MU1WendvNXVTQ29NYlV3Q0ZOaUVGdHBCNTZZWFhVL2I5QWpwTXJyS0JLak1u?=
 =?utf-8?B?R1FldzdSOURGcFR6S0V0R0NqTGYzTlJ5MUpIbUFGaEJ4NklVNzBmWEhYSTZ2?=
 =?utf-8?B?eVo5cnRXT21jcEc0aVY2ZFhqSlNDUEZhT0RBZ2QwSVZwT251VkR6UkZCcFdx?=
 =?utf-8?B?WjlMYnM0WEVoazZISldFSTFWcDlxWE5PMGl1VkVTUmZnUVNReFRHcktlaWc1?=
 =?utf-8?B?bXlEUnlFUTFGZDJvdjFraVlPdUdsS1E1Z0dXUmZ1M1JSa2xPVzhIM1BsVHBQ?=
 =?utf-8?B?NjBsZnF1UXJ2K3ordVl3RXU2YVhwRmxONnlja29jM3R2czBseEc2MzRjMnFz?=
 =?utf-8?B?V08vbVcrb1phRUNLa1FzdnFLQ2NTTEIwOU9HSXR1Vm5XcERUQXAvZGMyditG?=
 =?utf-8?B?RWhLKzZqU05rVXVJTHRhMExUbkxRQnNhdzJMOXAwaW13WEhuZ044Nk9SMmVQ?=
 =?utf-8?B?aEl4YUtucCsrWnRrQWsxbVJxd0RYWTN0Y0ZyU2k0NnR2ZkcrV1RQZGh0UjNw?=
 =?utf-8?B?Z0RHeEd0TVhaUXV4QVpjNGQ3RHE5WkZaRkJiTStLTmljVEIvUDN0M0FyS1Vj?=
 =?utf-8?B?NFNBNnJ6bmZnUXpERnVINXNtbWpJUjZQbDRMV1dleDJHNUNxRm5aVkEvZnZJ?=
 =?utf-8?B?d2FHL2pjVnJVZUl5VFpHREZIOVBGMzNLcVdqQjExajZrNVhlL0RYOXRpU2lu?=
 =?utf-8?Q?Azq0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 05:53:55.1726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82dc8aee-ae3b-4234-a6cb-08de0a1ce518
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004688.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259

Hi Naveen,

On 10/6/2025 9:42 PM, Naveen N Rao wrote:
> On Mon, Sep 01, 2025 at 10:51:18AM +0530, Manali Shukla wrote:
>> Modify the APIC register mask infrastructure to support both standard
>> APIC registers (0x0-0x3f0) and extended APIC registers (0x400-0x530).
>>
>> This refactoring:
>> - Replaces the single u64 bitmask with a u64[2] array to accommodate
>>   the extended register range(128 bitmask)
>> - Updates the APIC_REG_MASK macro to handle both standard and extended
>>   register spaces
>> - Adapts kvm_lapic_readable_reg_mask() to use the new approach
>> - Adds APIC_REG_TEST macro to check register validity for standard
>>   APIC registers and Exended APIC registers
>> - Updates all callers to use the new interface
>>
>> This is purely an infrastructure change to support the upcoming
>> extended APIC register emulation.
>>
>> Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> ---
>>  arch/x86/kvm/lapic.c   | 99 ++++++++++++++++++++++++++----------------
>>  arch/x86/kvm/lapic.h   |  2 +-
>>  arch/x86/kvm/vmx/vmx.c | 10 +++--
>>  3 files changed, 70 insertions(+), 41 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index e19545b8cc98..f92e3f53ee75 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -1587,53 +1587,77 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
>>  	return container_of(dev, struct kvm_lapic, dev);
>>  }
>>  
>> -#define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
>> -#define APIC_REGS_MASK(first, count) \
>> -	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
>> -
>> -u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
>> -{
>> -	/* Leave bits '0' for reserved and write-only registers. */
>> -	u64 valid_reg_mask =
>> -		APIC_REG_MASK(APIC_ID) |
>> -		APIC_REG_MASK(APIC_LVR) |
>> -		APIC_REG_MASK(APIC_TASKPRI) |
>> -		APIC_REG_MASK(APIC_PROCPRI) |
>> -		APIC_REG_MASK(APIC_LDR) |
>> -		APIC_REG_MASK(APIC_SPIV) |
>> -		APIC_REGS_MASK(APIC_ISR, APIC_ISR_NR) |
>> -		APIC_REGS_MASK(APIC_TMR, APIC_ISR_NR) |
>> -		APIC_REGS_MASK(APIC_IRR, APIC_ISR_NR) |
>> -		APIC_REG_MASK(APIC_ESR) |
>> -		APIC_REG_MASK(APIC_ICR) |
>> -		APIC_REG_MASK(APIC_LVTT) |
>> -		APIC_REG_MASK(APIC_LVTTHMR) |
>> -		APIC_REG_MASK(APIC_LVTPC) |
>> -		APIC_REG_MASK(APIC_LVT0) |
>> -		APIC_REG_MASK(APIC_LVT1) |
>> -		APIC_REG_MASK(APIC_LVTERR) |
>> -		APIC_REG_MASK(APIC_TMICT) |
>> -		APIC_REG_MASK(APIC_TMCCT) |
>> -		APIC_REG_MASK(APIC_TDCR);
>> +/*
>> + * Helper macros for APIC register bitmask handling
>> + * 2 element array is being used to represent 128-bit mask, where:
>> + * - mask[0] tracks standard APIC registers (0x0-0x3f0)
>> + * - mask[1] tracks extended APIC registers (0x400-0x530)
>> + */
>> +
>> +#define APIC_REG_INDEX(reg)	(((reg) < 0x400) ? 0 : 1)
>> +#define APIC_REG_BIT(reg)	(((reg) < 0x400) ? ((reg) >> 4) : (((reg) - 0x400) >> 4))
>> +
>> +/* Set a bit in the mask for a single APIC register. */
>> +#define APIC_REG_MASK(reg, mask) do { \
>> +	(mask)[APIC_REG_INDEX(reg)] |= (1ULL << APIC_REG_BIT(reg)); \
>> +} while (0)
>> +
>> +/* Set bits in the mask for a range of consecutive APIC registers. */
>> +#define APIC_REGS_MASK(first, count, mask) do { \
>> +	(mask)[APIC_REG_INDEX(first)] |= ((1ULL << (count)) - 1) << APIC_REG_BIT(first); \
>> +} while (0)
>> +
>> +/* Macro to check whether the an APIC register bit is set in the mask. */
>> +#define APIC_REG_TEST(reg, mask) \
>> +	((mask)[APIC_REG_INDEX(reg)] & (1ULL << APIC_REG_BIT(reg)))
>> +
>> +#define APIC_LAST_REG_OFFSET		0x3f0
>> +#define APIC_EXT_LAST_REG_OFFSET	0x530
>> +
>> +void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2])
>> +{
>> +	mask[0] = 0;
>> +	mask[1] = 0;
> 
> Would it be simpler to use a bitmap for the mask?
> 
> 
> - Naveen
> 

Thanks for the suggestion. I'll revisit this code and explore using
the bitmap APIs from lib/bitmap.c and include/linux/bitmap.h. I'll
include any improvements in v3.

-Manali

