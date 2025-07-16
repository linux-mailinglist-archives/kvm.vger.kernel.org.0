Return-Path: <kvm+bounces-52584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE685B06F4C
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF56D58081C
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0F0248878;
	Wed, 16 Jul 2025 07:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0hzaFx2c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F88C2D052;
	Wed, 16 Jul 2025 07:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752651927; cv=fail; b=IqpfOZccoPOvRuExwhZfx8qOyKV461/jkpBqNC8w9GpqmUG7h+aFPQN4J+iWSAfbCRPYNdSGFkTFJpzJaOKAsHkL/F0Evt8uoupADRxMaGGR7FDE9zZ2Qvri6iGTpOCFGNFiyfyG+TOw2mB4jfLzPfek87S8bkte4wmPXeXmLNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752651927; c=relaxed/simple;
	bh=XbwI3QhOkh3UFwGT2uPzsZtriGfi6sMReI3u00sNEs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=p8gEL/VFsETf08gH8UJ3t28oSK6pfvIQKxje6AgLOjisM4hWHJ0Un8rCin4JSFfPUCHFgJwFWshK1Wb5iSIzJpXR4OQOzP7+9j52NWzgbn91r/QYOQcQwQXO7rY/7IRTGTU53iZ0yLhzy1/t5lVf6oYEwPYk/fCPeUsBjy2rouc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0hzaFx2c; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T8N7TV+bdBKTYZ2/EPV4vEb9zTA0ygUXTm0l/nvJ0MXUsAd2KdkW81dcNPk6o7XtWlbRPi+3BJUk6XCMwlHwJvxcD2MAhT2bToKA4K+/VEzNa2EsYPUMoU5FydVBQtMuCrTAHah8G30KzMTNwWJFujKrtH9TFRzl5xaVYD74oZNbUTkzWQTydwTaQpfNvzTILDb1VHTVapPq44ASc1ECrnCGcnRd9/5RFpIlbaveduntf78IQJY4Za47WApFi62vFs/sdCPkDcANwJKMETJVJtzUitw5iNlD+3Q+gTrqhpUgUeXCbsz8io/x5rNccn9229ame9g8e4gYPX5vA06ZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLNDY6MA4DzFzYtpl8Uik5Rups9gF1KNM6NtO+WfEcA=;
 b=MFsf+vyIFhQOxb0vPj6SmEaMKFKiy2XlSS1wzsffhT/9zQY+coSr5mFDLG9EimlD6c2vwZMfEgU9UcoKhW05ylJGvUDkaBaSGU5mdRheZ5YyX15nUsqUkY8KqKnWO4WPxd8sn1PlWmN7DuhRZCHdDoXyXPeuF3GVDmtw/YM8mAlnYepdZT1/grjVikd5p4FfS8O298Pjf7pxL9CdL7ueS/H3ZsvPMKfeDSs3tB2p8B9DKCDRh760wrQzN5Jbl07GblVUsdoY7T2T1M44I3PUEiy2yDhuITmfBmoGMjqWMBYhgS88m/nMVffngfWkxYRVMwl6XrWB04mjmQTRpxM3IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLNDY6MA4DzFzYtpl8Uik5Rups9gF1KNM6NtO+WfEcA=;
 b=0hzaFx2c1gALQyK9fd6L1ZDS/AQ30LNYlFMgDRDZgzsQN1Xvr9QtWJPy7JZ0ncB2KYWyKwUXpqswLhWA5Cg9k0/tVWs2LgMycsY4jHr5Ejscg2rmJ6Xu1KRk2rVN+e1KJa8cVYeymuqiygKH8NiwmFUSIKngcS78bXy2e/OEeSM=
Received: from BYAPR02CA0012.namprd02.prod.outlook.com (2603:10b6:a02:ee::25)
 by CH3PR12MB8509.namprd12.prod.outlook.com (2603:10b6:610:157::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 07:45:21 +0000
Received: from CO1PEPF000042AA.namprd03.prod.outlook.com
 (2603:10b6:a02:ee:cafe::e7) by BYAPR02CA0012.outlook.office365.com
 (2603:10b6:a02:ee::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.20 via Frontend Transport; Wed,
 16 Jul 2025 07:45:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AA.mail.protection.outlook.com (10.167.243.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 07:45:20 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Jul
 2025 02:45:10 -0500
Received: from [10.252.203.104] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 16 Jul 2025 02:45:06 -0500
Message-ID: <e79bfe7c-1d42-4bbb-9c15-b43dd412e824@amd.com>
Date: Wed, 16 Jul 2025 13:15:05 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/11] KVM: Add KVM_GET_LAPIC_W_EXTAPIC and
 KVM_SET_LAPIC_W_EXTAPIC for extapic
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, <kvm@vger.kernel.org>,
	<linux-perf-users@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
 <20250627162550.14197-3-manali.shukla@amd.com>
 <03934334-a4b6-4c9f-ad99-5f8041836065@linux.intel.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <03934334-a4b6-4c9f-ad99-5f8041836065@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB04.amd.com: manali.shukla@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AA:EE_|CH3PR12MB8509:EE_
X-MS-Office365-Filtering-Correlation-Id: 658bfdc3-c3e2-4f8b-feb0-08ddc43cb738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TWNvbk03SnVzcTI4cmpiUUpNcGwwUE5DK053c2xGemxiUU1tSWhWWnVMWUI3?=
 =?utf-8?B?cUdhc1ZnMTROWEhxOWgzWTBGVGo2c25nVGFEYURpbTVoYUxkamhPNm9qUlJy?=
 =?utf-8?B?WThBek1TdmtJeVZJVk9jNFZDQlVOME53T0F6dUtTUWtFdy9xOURZVXJqK29q?=
 =?utf-8?B?cWdvZUFxMFJQYVZ5OVBKcjRaOEgxRG1EKzNGTUVLei9mV3RUblp0YThLVW90?=
 =?utf-8?B?VUtFdEtkUXlFak1taHNYK1VPT3k3MHpNZW8wRWxNS1lPa21jVEQyMXVrbEVN?=
 =?utf-8?B?Tlp1bnQ4NlpMcktyT3hTSWoyWDhvOENLNG1LZHBIUlh4NFQvbXFFdE5DcUt2?=
 =?utf-8?B?bW4wejRxMmpRdDN6SEtnNWNBOTRQWkVnaGZldk4wZTE4dXV3Vll2SWR2QlVw?=
 =?utf-8?B?SS9wRFRDVUxDNFZ0anlLZStYNk9YUjMrNXB3aTZ4SWErbG16M1lyOGxON1lO?=
 =?utf-8?B?c3hqdjVoSFduQU5OZVhIOVhqYitRbXRxamdUbmkwbStCeHNudGVPVG0wYnJL?=
 =?utf-8?B?alUwU3dmYm81Y1BWNHd2cDlQTDYvVzhFTURrWi9Rd3p5NytQK2xoajRzV3NF?=
 =?utf-8?B?UnI1VzZKdk9JMGhuS3hOblhXOEZCZ1J1TkwyMkpQbHhVN1BLZ2FGWWlFTDZy?=
 =?utf-8?B?b3VzbkRTYjdjM2puZVYxaW1zWHNuR2N5LzB6Y3FVU3Bud2NaaFMvaGkxNzdU?=
 =?utf-8?B?S1UzT0tKVlZSZXM1UkkwUEE0dzVCTzZLcEdTTnNMQXFSVm1Dai9UQWVwUFN6?=
 =?utf-8?B?TXplSlpxem4vYlVJQlJ5Q0RpWlBZQldSWUNNcVVCa2ZUUjNyNGR5cVltRzhu?=
 =?utf-8?B?S1k5aUp3cnhhWlhRS0hncStaQkVVVlZGZzMweHg3OTZ2dkZ5Y2pkYVFnNHlR?=
 =?utf-8?B?bENac0hsY1N6bE1Yb0JFSmFKUHZLMi9kcit0RUtIWktObExNZmZpUmdMaEF3?=
 =?utf-8?B?RStKNDRrbVZuL1A0WWJ6Tmk4M0tVK3IxaWVpOXlOMnF2bU8rSjY5akRFYUpj?=
 =?utf-8?B?UnZ5UUpOWWU2aUlwTFN5MEpQYXRLV3lFMWZBbkdJcFJ5a2U2REhCVzc2dlUz?=
 =?utf-8?B?N00wc0JOenhGRnFFYng1cUd2TlFMWGJ4OEIyR0FWZWRSSWRtRW41aVlWUDlW?=
 =?utf-8?B?bGYzKzJ6eEVZQStHenRUTVRCUFVOT0xlQWtHZ1I2c0pXaGtjb1k2NmpDRnQ5?=
 =?utf-8?B?MTlZSjZFOFlrdnBjN0ZmU2E0b0VzMWZJeXZnMEMwR1lXalhZcHVEZVZYY3ZK?=
 =?utf-8?B?MHlBRlBSd2QxeERJcGwyL3ZDazJhbmNSYitvN1RXTTcvOWVtZVAvVE1JQS9l?=
 =?utf-8?B?SjJoSk00b3RQTjFoTDBLMGhNRldzNkFJQ1BIdWVpTjErOHhSemtpekh0SWdF?=
 =?utf-8?B?RnZ1Q0F0bjRPT0twbDJuN0lIMUZpSGJJMFIxOTVvVUw4azNZQ2ZmVzg3SEht?=
 =?utf-8?B?OVJBZlRUSFpMZFhMSXFoY21BMXdwYXJLc0hTNmRPcHBSSDJsY2tvOWsrY1Nk?=
 =?utf-8?B?LzQ1ZWZDUWhZNmdiREtxOWNCQzYrU25IVFZNLzBoN2NxeklQQURYdmJaSkY3?=
 =?utf-8?B?dW1uaWNwUmZQYlZCaEppUC92aWsxNmVNZnNQbHhac2dCVmY1TWhVSWFhMTg3?=
 =?utf-8?B?Q1c5eGZmdDR4TzExV1k5MlJQaW5sUUhSVkE3M3YzTVBxaElvUmRhTGFPbmFs?=
 =?utf-8?B?ZTdxR2hTVk5nb2JmeXU5NzBmYXhZQ3FQc2lQYUNNMzNFV1dtek1wUjRYcE5r?=
 =?utf-8?B?cWQyWFk3V0RkT0t5UFIwdWM1dEF2eFIySkRjamFWaEUvNWd4bENzSC9nRUha?=
 =?utf-8?B?UGdmcnN2QTJ1RWM4VU0zK1ArZEt5VE9HbjMzYmRqd2ZRd0I1eW8vZnQ4WFZY?=
 =?utf-8?B?SWxQbUlnamhrSHlsUlo2UjhUNXJocmdLdXFpdDlVSjZTVzkyNzFzWUY2WFRh?=
 =?utf-8?B?NVZneVZubC9pUDZjQnVhOUVzaDI2dTFPSmprN0orcVkwWDhGT2lzb1hYalFh?=
 =?utf-8?B?ejRaclpzODZvamRmWEJ5M01VWUV6dnV1V05SNTkvU1RpNnNmQjhWek1oN0py?=
 =?utf-8?B?Wk1YRlhsR1hPOW5ydUlWWU9HVEZNMUt0TXk1UT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 07:45:20.6026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 658bfdc3-c3e2-4f8b-feb0-08ddc43cb738
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8509

Hi Dapeng Mi,

Thank you for reviewing my patches.

On 7/15/2025 7:51 AM, Mi, Dapeng wrote:
> 
> On 6/28/2025 12:25 AM, Manali Shukla wrote:
>> Modern AMD processors expose four additional extended LVT registers in
>> the extended APIC register space, which can be used for additional
>> interrupt sources such as instruction-based sampling and others.
>>
>> To support this, introduce two new vCPU-based IOCTLs:
>> KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC. These IOCTLs works
>> similarly to KVM_GET_LAPIC and KVM_SET_LAPIC, but operate on APIC page
>> with extended APIC register space located at APIC offsets 400h-530h.
>>
>> These IOCTLs are intended for use when extended APIC support is
>> enabled in the guest. They allow saving and restoring the full APIC
>> page, including the extended registers.
>>
>> To support this, the `struct kvm_lapic_state_w_extapic` has been made
>> extensible rather than hardcoding its size, improving forward
>> compatibility.
>>
>> Documentation for the new IOCTLs has also been added.
>>
>> For more details on the extended APIC space, refer to AMD Programmer’s
>> Manual Volume 2, Section 16.4.5: Extended Interrupts.
>> https://bugzilla.kernel.org/attachment.cgi?id=306250
>>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> ---
>>  Documentation/virt/kvm/api.rst  | 23 ++++++++++++++++++++
>>  arch/x86/include/uapi/asm/kvm.h |  5 +++++
>>  arch/x86/kvm/lapic.c            | 12 ++++++-----
>>  arch/x86/kvm/lapic.h            |  6 ++++--
>>  arch/x86/kvm/x86.c              | 37 ++++++++++++++++++++++++---------
>>  include/uapi/linux/kvm.h        | 10 +++++++++
>>  6 files changed, 76 insertions(+), 17 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 1bd2d42e6424..0ca11d43f833 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -2041,6 +2041,18 @@ error.
>>  Reads the Local APIC registers and copies them into the input argument.  The
>>  data format and layout are the same as documented in the architecture manual.
>>  
>> +::
>> +
>> +  #define KVM_APIC_EXT_REG_SIZE 0x540
>> +  struct kvm_lapic_state_w_extapic {
>> +	__DECLARE_FLEX_ARRAY(__u8, regs);
>> +  };
>> +
>> +Applications should use KVM_GET_LAPIC_W_EXTAPIC ioctl if extended APIC is
>> +enabled. KVM_GET_LAPIC_W_EXTAPIC reads Local APIC registers with extended
>> +APIC register space located at offsets 400h-530h and copies them into input
>> +argument.
>> +
>>  If KVM_X2APIC_API_USE_32BIT_IDS feature of KVM_CAP_X2APIC_API is
>>  enabled, then the format of APIC_ID register depends on the APIC mode
>>  (reported by MSR_IA32_APICBASE) of its VCPU.  x2APIC stores APIC ID in
>> @@ -2072,6 +2084,17 @@ always uses xAPIC format.
>>  Copies the input argument into the Local APIC registers.  The data format
>>  and layout are the same as documented in the architecture manual.
>>  
>> +::
>> +
>> +  #define KVM_APIC_EXT_REG_SIZE 0x540
>> +  struct kvm_lapic_state_w_extapic {
>> +	__DECLARE_FLEX_ARRAY(__u8, regs);
>> +  };
>> +
>> +Applications should use KVM_SET_LAPIC_W_EXTAPIC ioctl if extended APIC is enabled.
>> +KVM_SET_LAPIC_W_EXTAPIC copies input arguments with extended APIC register into
>> +Local APIC and extended APIC registers.
>> +
>>  The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
>>  regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
>>  See the note in KVM_GET_LAPIC.
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 6f3499507c5e..91c3c5b8cae3 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -124,6 +124,11 @@ struct kvm_lapic_state {
>>  	char regs[KVM_APIC_REG_SIZE];
>>  };
>>  
>> +#define KVM_APIC_EXT_REG_SIZE 0x540
>> +struct kvm_lapic_state_w_extapic {
>> +	__DECLARE_FLEX_ARRAY(__u8, regs);
>> +};
> 
> The name "kvm_lapic_state_w_extapic" seems a little bit too long, maybe
> "kvm_ext_lapic_state" is enough?

I also found the name to be quite long, but I couldn't come up with a
better alternative. I'm fine with keeping kvm_ext_lapic_state as it
appears concise and self-explanatory. I will change the name in V2.

-Manali



