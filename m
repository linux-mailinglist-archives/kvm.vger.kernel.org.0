Return-Path: <kvm+bounces-32031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F269D1AC5
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 22:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE924281918
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 21:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332FF1E7C16;
	Mon, 18 Nov 2024 21:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oaMOXl+d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF35199252;
	Mon, 18 Nov 2024 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731966330; cv=fail; b=k1l/1aXYlX0J+UckrnAgCDQbIie0Jx8uQVUmT7QEPqEPVULhIC/16EG0o3OLmQs/lD93G73ONNXSzaT3iXBgjWqpWxTALVy+WCcz2yKnE+kDGg5gO76Evu8dhMOWJ2zX1gyxZA+wzq4OYycEIUgpUkk2zlBQtKZAo4MqhJtMDgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731966330; c=relaxed/simple;
	bh=q1Dlb6+XXj3LB33TEXVJurkt1IKwHSO90rYGdXkWmfc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mSbO/uCdUQFesI2oGnC4H7SJpqDybiJSLaKTZlDH/r9MByrFgpnkIV6UXf6ez3GppChu9ilzaf7PrcJFRKv1Fs8DN/xQyFXV8JaK9v+6UZMeZbGY8Fbi1Acdcmsd3wv0ip32VW7FRpTaXucld3IxEE9x6mcmz278PpmDUeTW8Cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oaMOXl+d; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V/vf1fmgBdjeP4mYk2OVqYizePp15VQm8Wjp7jxs2kE+jA+TSAhJb7gt1zpiFhPoTlmLWW0aC95vbHrjZwd8DsSb3gGdO6n4HlTHq7P9lbDIDBA+CrVSzexViwdAzTFLh1VUtmoTYRoz+PkzkdIZ9HU4JAqqIJMAJ1liSiysDt+DE03aw10hutzdhiHeoNN3dlgtIF+oYLJImvXJZ7AOHswMSoVjSwtdYi3SrdvdxlvtGkuzZ2LJbbPFwECPnmKcjNAAK4h8dlglreCGpEMbAQ+pDT/5v7avfwxqNPhdBhS6Ey1eLaiWU9clMK3+U1z+SQPtuV2O0hKuwjyU/ZAE0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/XRQRDzpyBqrqYbQHd+pxl2/MgWlb/nLzuJ0LXKv1uo=;
 b=VVQ9SQUvYldPgmdWIgfcJdGjM59mhV6H4jgyuyY8nOQ5Czxscx/wGDOFeUxQyJv5eL+pgndeqzWIpoyG4NFL1XvJvtIaVPCBeBdQJnBE6ahU1KyjDEQeGuXbuFbIJZBhjwB6ODsnfEdD6+o+GEjoGTSVkmjtLANolkH9MhZXBdFtgvJtSCdxe0p58OBaExOzAosZvHY+xfAjoM5sS76r3WWw9KRiEtjiEjpcqe6Sgx3+pmrSvs6r45VP0juyPT7hAtQuSbmLeSVIK0egNc3EPoqS2LuOAVT1dsP0QvTgptl3kYHx726HHmBt2txg9NeQYLUhHfz8CoAla3dXW+xBYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.12) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XRQRDzpyBqrqYbQHd+pxl2/MgWlb/nLzuJ0LXKv1uo=;
 b=oaMOXl+dgXaDGWWmp+6W9uVIVDXb5sSGtMxLZSLWOFwpi8AIg4gY7TbpDZy3pZhpLz338NvT02uBd877bcvSL3dHYwD3eG7ePn6M5sVMzicuONlTFC3ez9p7W/ObHwG7rTQQwmkg1kr9Md2RTDvVzO82ViAYYiOWXPJOoIb1SxE=
Received: from BL1P222CA0019.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::24)
 by LV2PR12MB5728.namprd12.prod.outlook.com (2603:10b6:408:17c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Mon, 18 Nov
 2024 21:45:22 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:2c7:cafe::4f) by BL1P222CA0019.outlook.office365.com
 (2603:10b6:208:2c7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23 via Frontend
 Transport; Mon, 18 Nov 2024 21:45:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.12)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.12; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.12) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8158.14 via Frontend Transport; Mon, 18 Nov 2024 21:45:22 +0000
Received: from [10.23.197.56] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Nov
 2024 15:45:20 -0600
Message-ID: <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
Date: Mon, 18 Nov 2024 13:45:13 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
Content-Language: en-US
From: "Melody (Huibo) Wang" <huibo.wang@amd.com>
In-Reply-To: <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|LV2PR12MB5728:EE_
X-MS-Office365-Filtering-Correlation-Id: fb19c698-8ddb-4832-d93d-08dd081a4dd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlZsZ0JYMXZaajJnTWVSaVpVUmM3VlhOenI5UW5tTm9YQTR0bTBHb3Vzb3Uz?=
 =?utf-8?B?T0FCalJqN1RpQkpaL3EvZDR5VXhpM0NLTWhaYTE3S0RTb3dNdldCSDNlZFdN?=
 =?utf-8?B?cFdWTC9HamU3UzQ3QVhRaVg3OG9JUlBEbUdRZmkvcXM0cW5sRmYvYVIya1BG?=
 =?utf-8?B?RXg0S25LOVhRYld1SVVDWjFsWkxvS3I0a2x5eGVwaExxTHVwY1haaDdYaU41?=
 =?utf-8?B?cW5GU0Z6cEZicjlaYkZGaGIySk9kZngyTFltV2lyR0xhUjQ0eURVZW1UMDZQ?=
 =?utf-8?B?aldHOEY0NHVjYTV3MTROYXJCekdOR2RITmJZTU1sdWtOVXJwSjlZRi9NQzFh?=
 =?utf-8?B?NWt1bWhSbzNzN2pXNUJybm43U3hacE1KNnVwUjk2a3ovcUZaY0VEbFk4Tnpy?=
 =?utf-8?B?QWYvdVAvcnZ4bEQ4M3VJU09RUXhGMXpJeWU2SkJhYVlNcnA2Tnpaai9XSzRu?=
 =?utf-8?B?Y2l5RytwN1NyOUlocThmSUorSVhjMHIyVlRCd1d6UmxNZG80UlRHV1E5NENB?=
 =?utf-8?B?K0FKUjVCdWNDcGRCcUIySmdJaDJFQUNaSlZyNEwyZXorR0JJRTZYU1JzRGF1?=
 =?utf-8?B?YjZzZCtsbXRkYk1YUGdOdmdRSmVPaDNjQTBsc0xmWkxyQmJOK3NlNHFLemdC?=
 =?utf-8?B?anRHLzd5QW1nZUZlWDBtSklRNEVJUWJ2R0FJSlc1TFdXVTVmSCtaOFo4ZldD?=
 =?utf-8?B?bGkyQ2F6MmVZK0xFOFZEVVVWbE9pMG5QbjdlMWQ1UUhPdEZqTWhtK1BRb3p1?=
 =?utf-8?B?NUxhOW9lQXBTZGRxeEx1NkFOYXlVRjkyY2ZqU2VqbzZoZFJibXl4QzFSQ0JB?=
 =?utf-8?B?bHdrUGcrWnZ6U0lVdE8zcU9ybnBtQlY1anYzRFlRUGJBSUlhY09JQ1RVSmpU?=
 =?utf-8?B?eVhQN1o2WWw2ZFVCTnU5OVlQRjZObGJDZzJ6cHNQd1lTMVVMTEYvdHlTOWt4?=
 =?utf-8?B?YzZFRTFvUTNFSG41ekpFTDFteXEzenFHaTVvV3NOV3R4R1JEN09IamdjWHR4?=
 =?utf-8?B?V2hPTzc4bWp3YTd3ZDI5MnJGRWMvL0xjVzQyVmlBZytMQXFhMklLWmplRjZk?=
 =?utf-8?B?WDRweXRMc0l4SEZUeE9rZVZtQWk4RmtLZnRTcG9aQzh0Q0xiM2YvNElGbnow?=
 =?utf-8?B?dU5zcC9JUzdpbEgyRlZJeUVqV1FKNk05aVZrT2tKVXlGNGdvVW5hcWlLZi9V?=
 =?utf-8?B?K3hvUDlBRVhTb1UrbVptbnJ5U29CbjVmTUNOaHFPcnZqK0JlTW9zTnlDcE9z?=
 =?utf-8?B?ZjBmbnBYYXVHamFUZTV0Y3p6SDBXNWc0eGxjOGx2dDVoTWJQS2ZiNURtaUgw?=
 =?utf-8?B?UDlSb1V5djc1N0c4dGtSTTdRaDVJLytPd1c4ZGYyOEYyNC9PZ1FKa1RJb1Vi?=
 =?utf-8?B?MnlDWHBNZ1ZhRXZWRlFiZ1hCbGxkQ3pjclBxNm5RVlFBZ1plZlY4RWxxTFpx?=
 =?utf-8?B?MGVMc2ROSFlVMElpZm8zT3ZPbWRtcDJva2pVRjQ2cG5CSmhZclFYSFBSemp6?=
 =?utf-8?B?MWZ2UHpvOE0xck9uSVNHdTJrWFhGNko0MEVXSDdzYy9BanZITkFrQm1UNEN1?=
 =?utf-8?B?UHZ4WVNoc1R5aDlZNS9kV2JFMml0Z3AvYzRVaXNWemtzOGtyZlpkYVVYUWdS?=
 =?utf-8?B?NnozLzZFY0I5NnhJeXlKVjVicFRYdjJFb2VEMlNCUXFodUVmZ0JpYkYwVDlZ?=
 =?utf-8?B?MENrbXovb29rOXBrd2IvaGMvOTB6ZVRqUmhUVFBwSUJRY25OSExTZXdTUGl4?=
 =?utf-8?B?bURURnErMTRsNURGeFhldlJQRHQ2QVk1a2l0S3hEVXF0NDVMRWhqZVRJQWQ1?=
 =?utf-8?B?MGRKVjZHdE5IbExJNHhrdEJuek1KOWdabnZjRXdETGNOMVhXaVJsbHJVOGxX?=
 =?utf-8?B?ZFFtZ1gzZjlmdGRnbURtRzdJTHBadzJMREgraGx2bTYxaEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.12;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:atlvpn-bp.amd.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 21:45:22.3558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb19c698-8ddb-4832-d93d-08dd081a4dd0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.12];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5728

Hi Neeraj,

On 9/13/2024 4:36 AM, Neeraj Upadhyay wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> The Secure AVIC feature provides SEV-SNP guests hardware acceleration
> for performance sensitive APIC accesses while securely managing the
> guest-owned APIC state through the use of a private APIC backing page.
> This helps prevent malicious hypervisor from generating unexpected
> interrupts for a vCPU or otherwise violate architectural assumptions
> around APIC behavior.
> 
> Add a new x2APIC driver that will serve as the base of the Secure AVIC
> support. It is initially the same as the x2APIC phys driver, but will be
> modified as features of Secure AVIC are implemented.
> 
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/Kconfig                    |  12 +++
>  arch/x86/boot/compressed/sev.c      |   1 +
>  arch/x86/coco/core.c                |   3 +
>  arch/x86/include/asm/msr-index.h    |   4 +-
>  arch/x86/kernel/apic/Makefile       |   1 +
>  arch/x86/kernel/apic/x2apic_savic.c | 112 ++++++++++++++++++++++++++++
>  include/linux/cc_platform.h         |   8 ++
>  7 files changed, 140 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kernel/apic/x2apic_savic.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 007bab9f2a0e..b05b4e9d2e49 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -469,6 +469,18 @@ config X86_X2APIC
>  
>  	  If you don't know what to do here, say N.
>  
> +config AMD_SECURE_AVIC
> +	bool "AMD Secure AVIC"
> +	depends on X86_X2APIC && AMD_MEM_ENCRYPT

If we remove the dependency on X2APIC, there are only 3 X2APIC functions which you call from this driver. Can we just expose them in the header, and then simply remove the dependency on X2APIC? 

Thanks
Melody


