Return-Path: <kvm+bounces-31354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2ABB9C2F71
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 21:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E29DB1C213F7
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 20:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7461A0711;
	Sat,  9 Nov 2024 20:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JUE4WqYS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB491990C9;
	Sat,  9 Nov 2024 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731183225; cv=fail; b=YN/danPnjZnCbyXRoE596IR1o0FPK9woiFY9JVb+G7OyEQMQXPAXZB3i9tns0ZOG55jPGMessrxHOw+HCXi7JOzwnHVYnM7ewmf3eVP/Y3Mq7bL5WBRrw2q2cQDMpWq80iZQxGNPlMwBN7W4r3XBTt7rCjrO2iQ5t1a3LEres1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731183225; c=relaxed/simple;
	bh=UvcbFPYtPW1m6yKHsKFGGNZlKZkTb1/Htfd9/nxfzX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=n2rvGCdiy513O+dKR74GDaISVMQ2HF4Rk5LDPcJyuVZPou+DzVFQOAmvgg6uVX8LGlGE6UcUP9T4vkXbFpk/ekKbm55/qxUHS/ih+PUZbc2tXM20Ep3012ka32DoxA4eVTwz0c8VDeaXPMt8sW4VLS53bwa5Z/jvb432C6rgJH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JUE4WqYS; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scEa/nCY8Q7txJ1FFXbTlc7ehnN9yzK8Vsl9nSU1cPBaPp8n8tMNposTXOK/xJK0JqiC4z1THvAmxmbZxtGsavKlj/tJ+553f1aHTlSGFEW7+/QBf18ZHcIa5RMVcHBSkaayVKoFUZz4yVgMcXLPnKpQ+mbq5+81gD4UR0A0L8OEhp2zxXGaM816AqizlhSUL0W85pcRUlGd0IOtTvgx0xWY4ElGe2OixKPnJAX+ZmITN+n7RVXyKDppy6W7uLsa+8AhWvkEYGA/42E0+diMb+WyXcOG0bcm1oTC1J/KLWhsE9ctJV82x3xrOBPpAgAvalrAo+wfttGO+lw5YvPyjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMMyW98D5dxEAIrT5sP8FTa24VUTlUfXGeTt7kh4ztQ=;
 b=NYDDJaBTVPz9zn//MOAr+kWgbY1bkgzTcf4NX9b/s5HYcMYGOAInFPyCe4rJiBVxgRUxkh+AajplCxWDgSa/KlSYI8kBXKpZkxLXCTwPTlEDnzB1v8VlxMxlE3wMbdtvdP8UKyiva3k6W0yb58G0h31NVHFcM4IZa89K1IQoPwmQqRUy6IXMAazKjGCqVMFVVnC7GLWIy7US1pLgxmBCjtiWr4aXFz6uUXBj0O+cJMCOgrBUSnMkRUcJMtcOYwKlkK5tM42kJHt/ITjGNnnjulz+wMZO5dFo8yKFh0ddPVKZ2SP/uKt7uUhiYyYJI7CTBrL4yz2TCqpSpetIeGIcqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMMyW98D5dxEAIrT5sP8FTa24VUTlUfXGeTt7kh4ztQ=;
 b=JUE4WqYSr2JhkhH4RWsCoCQcCAYbvlMMSOO+06v5sRBR3DgDwAX+jRK+r59FxhzNlkV93BlA3Q+qCxbq2HadtsDxzuliyWylN7BUFBy2gjxyPTAvn3iHK1BHnaxCMfKSJV4BsjfMZxh9tk1v0A574KTsSX34Ei/SJRiTTLb4udw=
Received: from MN2PR02CA0015.namprd02.prod.outlook.com (2603:10b6:208:fc::28)
 by IA1PR12MB7736.namprd12.prod.outlook.com (2603:10b6:208:420::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.22; Sat, 9 Nov
 2024 20:13:40 +0000
Received: from BN2PEPF00004FBB.namprd04.prod.outlook.com
 (2603:10b6:208:fc:cafe::89) by MN2PR02CA0015.outlook.office365.com
 (2603:10b6:208:fc::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Sat, 9 Nov 2024 20:13:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBB.mail.protection.outlook.com (10.167.243.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8158.14 via Frontend Transport; Sat, 9 Nov 2024 20:13:40 +0000
Received: from [10.23.197.56] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sat, 9 Nov
 2024 14:13:37 -0600
Message-ID: <f4ce3668-28e7-4974-bfe9-2f81da41d19e@amd.com>
Date: Sat, 9 Nov 2024 12:13:22 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [sos-linux-ext-patches] [RFC 05/14] x86/apic: Initialize APIC ID
 for Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-6-Neeraj.Upadhyay@amd.com>
Content-Language: en-US
From: "Melody (Huibo) Wang" <huibo.wang@amd.com>
In-Reply-To: <20240913113705.419146-6-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBB:EE_|IA1PR12MB7736:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f92a072-03a7-41e7-ed17-08dd00fb00b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NnFpTGJPbW52em5KZHcvR09XakI3bytVYWUrV2ltOHppVWVxSGdKUWxVbkFa?=
 =?utf-8?B?Wkg1OHduMVNkVFVLNXdFNFlWa0F0MmVkbXhRYW42ZG1TVHdxNmVGN0FjOC9p?=
 =?utf-8?B?UzJXckR6RXFpMHllRG5DWlpIM2ZYRk43K0FMaWJFVG1ra3JnM0JZTlNYdGdy?=
 =?utf-8?B?cGNJRjErTjRpSFJPRzM2SndpNEZmSXNydFZVelZKTXhONmtVT214dHBHVHA4?=
 =?utf-8?B?R1ZvVGNVNTU1ekNVdGx6SUJ1WnZqcFA4QTgrc2h6OTFXeGNwTVp5V0FxaFg4?=
 =?utf-8?B?Nk9ycGV3azJQblVhY1AraVl6QmFrVDlxWGlTbVFUY1dFcUY5R3Q4NGMxVi85?=
 =?utf-8?B?SUh5Z094QUdWeVBKWlppSFhWR29XSkYyZlVHcDJVOE1VeWlhSmlpMS9DVWln?=
 =?utf-8?B?MURXSDJEa3ZZay9rb1VOUGVMYjdzTGpoL1NldzFsNThMcXNLdmNZY1BMMjVY?=
 =?utf-8?B?QTNDb01SK3JXbnJDRWlMMnlXUXl1ak9lZlNRMGpLNE1meVQ3cTVvUExxUG1V?=
 =?utf-8?B?Y0NUNU4zamg4WVV4eE82NHF2OXdwWG1DMzB4dHA3L0VtRjU0aE1kUVBFcTAz?=
 =?utf-8?B?N0JwbUhMS1lHbmh2THlhY01iZTliU01ydFVDK0htMVBsMmdlTlhvd3lJdVdE?=
 =?utf-8?B?RHViVktheFBuOTB4eUYrVlVuYzFpVjZjQnNBSVkrTUNGRE0va1poSHhRakZY?=
 =?utf-8?B?dFZROEIvcmJwZmx1TFRUQ2JrbXZVajhvRS9TbmtnLzVZSjMyNWlRS1JxVmdN?=
 =?utf-8?B?WElXUFo1a3g3aExJTC9LRlZFOGlobGFjcUFGWXVxWldRdjJLcDNzYkxnT1FR?=
 =?utf-8?B?TEFEN2x2OXkvckdlam5PbXdqc1RYTFlZUkUyT1NYNVFnMFJoa2d5OTIrY3U5?=
 =?utf-8?B?M3lPYmRGdWhMUC9mbi9UTEdZdnorUjgwNzIvUXdPNXRMcTFNV0FJYnhVM21t?=
 =?utf-8?B?TXBHQkIvbm1qdTVITVNxTU1yRjdSRjVvVGVNbVIxM2w2QktyRmZMd1N0RENK?=
 =?utf-8?B?ekM3eEZqZ1NxSW9FTTVBR0VYZUVSd2NCeVFJcVhwaU1NTTJNY0MzM01QYWJv?=
 =?utf-8?B?c0J3WG1WekI0K1pEZlpiWjRabHlCdHpNTnRNcUQyM29qNktuOEJURkpoVVBq?=
 =?utf-8?B?Si9kVmlVS0RGREpEMHNmVWpLb2FtNzJCMm5WY28zb3IralZHK01wekJtZU54?=
 =?utf-8?B?WmNGeGRoMXlmbVRJLytYcldzMldWR0xSbUw3K2N2UkVDVmN1YmNFdWRVUDZu?=
 =?utf-8?B?d3E0U3dlWlQ2U0p0K0F6b3lxMEdQQkpPVlJJajhnSmgyMElBa2FBSC9IUTVh?=
 =?utf-8?B?dEY3TXVQOGxMcnlFMi9nai8rVlFkMWpEWXdyTXQ5QWVjK0xpeDc0R2lkV2hL?=
 =?utf-8?B?dHlhNG43djZ5K3BLRzJrQ0lvaEE4WTQwdkd4Mno0Y0J6SncxYm5PR0RnWkJO?=
 =?utf-8?B?TngyekdFYlVNVnRkcndpVkJXeStLWG1MRm02M01kbEdtRWJpS3Vnb1gwN2JD?=
 =?utf-8?B?bkV6OHFFY1U2dnp0cTFlaG4rNjRJSXRCOXoyMjRmV3UvUHVZK3JFdHhjU0I2?=
 =?utf-8?B?MkwwZUVPT21IWVpmQzkvbngxYnVZMUEzU0V0em5FNnZmckVvMjlQV2tJVnZp?=
 =?utf-8?B?aUdrTktBSGx0L3RnVmMvVkU4SWV3d2MybXYwSFRocXNnajh3SzYyT1RROGZP?=
 =?utf-8?B?UTR0d1NKMmtJQjkzajdwRkpXRWNmUkZlNUFIMVVUMk9XMzU4ck96eFZWUDNW?=
 =?utf-8?B?Y0lNS2R0dDFSOTQvOFBPTHIyN3lwRFlJY0U3QVZiQ3VrUExOVDRQWjVDeTlQ?=
 =?utf-8?B?OHBPVk5JdFBBTkZHMXRkbUEySUNtbEJpMXVYRDErd2E5NXdSdzdTN0swalpW?=
 =?utf-8?B?NTh3VmlZZjVaVk9nakUyOWxLcFd6eUlqUGJpaFBtcWNxOHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 20:13:40.4239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f92a072-03a7-41e7-ed17-08dd00fb00b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7736

Hi Neeraj,

On 9/13/2024 4:36 AM, Neeraj Upadhyay wrote:
> Initialize the APIC ID in the APIC backing page with the
> CPUID function 0000_000bh_EDX (Extended Topology Enumeration),
> and ensure that APIC ID msr read from hypervisor is consistent
> with the value read from CPUID.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/kernel/apic/x2apic_savic.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
> index 99151be4e173..09fbc1857bf3 100644
> --- a/arch/x86/kernel/apic/x2apic_savic.c
> +++ b/arch/x86/kernel/apic/x2apic_savic.c
> @@ -14,6 +14,7 @@
>  #include <linux/sizes.h>
>  
>  #include <asm/apic.h>
> +#include <asm/cpuid.h>
>  #include <asm/sev.h>
>  
>  #include "local.h"
> @@ -200,6 +201,8 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
>  
>  static void init_backing_page(void *backing_page)
>  {
> +	u32 hv_apic_id;
> +	u32 apic_id;
>  	u32 val;
>  	int i;
>  
> @@ -220,6 +223,13 @@ static void init_backing_page(void *backing_page)
>  
>  	val = read_msr_from_hv(APIC_LDR);
>  	set_reg(backing_page, APIC_LDR, val);
> +
> +	/* Read APIC ID from Extended Topology Enumeration CPUID */
> +	apic_id = cpuid_edx(0x0000000b);
> +	hv_apic_id = read_msr_from_hv(APIC_ID);
> +	WARN_ONCE(hv_apic_id != apic_id, "Inconsistent APIC_ID values: %d (cpuid), %d (msr)",
> +			apic_id, hv_apic_id);
> +	set_reg(backing_page, APIC_ID, apic_id);
>  }
>  
With this warning that hv_apic_id and apic_id  is different, do you still want to set_reg after that? If so, wonder why we have this warning?

Thanks,
Melody
>  static void x2apic_savic_setup(void)

