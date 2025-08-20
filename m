Return-Path: <kvm+bounces-55094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 355E3B2D37B
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 07:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 192EA567F08
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 05:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF0B287262;
	Wed, 20 Aug 2025 05:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0bD10QZo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14880257ACF
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 05:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755667751; cv=fail; b=gigSkYjWIg1P+lsfcHekgb+xisld11M67jAUNhoE5QXlamc6ZocZRNCr7J9lfXnoWFRt8WUIKXJwc6RhuA7HL71HN2lkmhgfu410mavHDFZUVq6zVs/F7Res4wfGUvJJssS7/0UBtayRFCZV0/TTIRyzBZmigjU0UKrgw540IYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755667751; c=relaxed/simple;
	bh=hNYFCCVxEGAf+KT+87aZrHG6nu9Te2sovKpNfamr6Ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oXQwO7JYsUb8hOJktlL1r0h3Mab5NaGgoZesUR/xJiu+f7pjeHUuD8euJlYKAMjm28wL3bYlFTZPojBBtmmwszGgAzahEgUbf5rlbeBPAV+QN5DFvTTGFIW++FpJxeOj+p4VehzwQSGT5nSARJHzvkTGFACJ/84lIHlC+nngk1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0bD10QZo; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UWY8iScSptY1+ameasY1NnM9vs37su5QJ/k+mvJO9974jcslXMMxrMoR6Z2cwXlQyMEOhVpPjIpUmVPhFiYBWZl1cPlvl3q/bfkUOZ669NIgxpYRqCKl7Jwd9fCBjc1/AasIhikBO480YZrcaPwbxGmZNkON+zvguV5Ce8Pi7NUnNGabejdqoZWHtoZffxIAZBxGPmR30ZzHumdfQjPM7o8YoCBGTNHE6MWuHspsby2bVWPR/dkQTZtr7Q0drw2rPFC3Yb9qiRytTOvhCs1InpD+iN2X9P3ANR5MRRszS5yFqm5/BtWm1vG+e3szDdtnZnwMb0pIyJUuV3IHYHTITg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlcBeVkPXh9p5XESoa9zFsuaI5eQiQP5ImgqypzV3ys=;
 b=bY69sbZixyQJuDPcTw90JDJInyQ8j6ZG3TpFpTNMWVoHj9WY11GlavGFLoYnIFoD+Bac7ICBwiKrRiZD6upa25Hj6WddK32Jj8H9pp3CbsAV5KUQ7QJaMNwClFkvvyWI0BCc6zoxrFCqYiZS0jq/+IQCg7pSz4uG6QCwf+HdaX1AEdzkKX9S/zvcZ82wbEAjHybOtbv9Y+fLBXpqLJwpTiAqgswFufk1M+lkas4mqxMAe9gpQ3g9DK1l7ApGpMKEmKwk1riic9TrxlguivzPUgARBR1DhYFZkxxrECeXX0rypJY3jNj/72/6fgjKirdyF9bBpEz2s/qpInrUHK9SMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlcBeVkPXh9p5XESoa9zFsuaI5eQiQP5ImgqypzV3ys=;
 b=0bD10QZomtHYuPZCcehiCwZKHvzBczhLrl0UP+rDjHhBi1KTWJr0XJ/LxnQYc6bYuPIhsLI982nOldzvfKpYMJ1WgIglTAz4fnJZsXJJaTeQK1xTf081Jnxrlvz5+HrdKv7Z3rpEOgYPeMWbFKEyEXCjNTWCt8ScdQJasalUBKU=
Received: from BL0PR02CA0094.namprd02.prod.outlook.com (2603:10b6:208:51::35)
 by CH8PR12MB9789.namprd12.prod.outlook.com (2603:10b6:610:260::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 05:29:04 +0000
Received: from BN1PEPF00004684.namprd03.prod.outlook.com
 (2603:10b6:208:51:cafe::db) by BL0PR02CA0094.outlook.office365.com
 (2603:10b6:208:51::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 05:29:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004684.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 05:29:04 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 00:29:03 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 00:29:02 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 00:29:00 -0500
Message-ID: <91fac75a-1a85-460d-b947-ec8b83a708ad@amd.com>
Date: Wed, 20 Aug 2025 10:59:00 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] KVM: SEV: Enforce minimum GHCB version requirement
 for SEV-SNP guests
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, Michael Roth <michael.roth@amd.com>
References: <20250804090945.267199-1-nikunj@amd.com>
 <20250804090945.267199-3-nikunj@amd.com> <aKTCMzVNwhlFNE0e@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aKTCMzVNwhlFNE0e@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004684:EE_|CH8PR12MB9789:EE_
X-MS-Office365-Filtering-Correlation-Id: 61522d82-98fd-406c-a0f4-08dddfaa7a4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0VpeUxJU0x0MkhuT0g4Q0NMNXRUZHd4UWEya3dJN3dVK3lIdVo4cDh6WG9x?=
 =?utf-8?B?QlBPSmRjRjNsUW8ydFI1UFRhU3JJdlI2VnliZzFpUGI5WWlPSXlQWFhrZEhj?=
 =?utf-8?B?VG12NSsrK2F6MTlHSXVOelZhU21zNkhuQzAxTUpZSHZQRlQ0RGpCVjJKOGha?=
 =?utf-8?B?SkY1UkJpT3dQNElRZUx1emYxcnRGNjlwZ2ViOG9YV2ozKy9TVDVuN2N3Mk0r?=
 =?utf-8?B?V3VBakhZUytwRGN1MSthZjZSOWhUbmNOZDNKa25ZRnZvbGZyK3UwRmhoeUVt?=
 =?utf-8?B?OW5RV0J3aENOT1hXSkJacER3bGJzYys1KzhFaExObTBjbzhLZk5oeEJoY2lT?=
 =?utf-8?B?L0kwTzgvL2J6QTF1eXl3TDY0RXFmM0I2Z3lXdUtHcE9oc0h3em9xc1NwTDFJ?=
 =?utf-8?B?cWNnc1QzdWxpUTBxOEYrK25UV1JVQXVsZTVWNWpTak1WZkcraTVsR2dRRGJu?=
 =?utf-8?B?d21RSWE5N2hYcDIwakRmNU1Sd3JrelJuSkpXMGUvY2EwRmdTalVmdVpIR3VL?=
 =?utf-8?B?b2JFSlByWXk1bS9IcnV1eE1FL2FzanRESGVLVXU5UkEwUUthTHpKcFErT1Va?=
 =?utf-8?B?UHcxYUhBQ08xbElRUHN1MG55YytlVXZhSWtkdEhVVk4zbkhWaE41RU5jU1h5?=
 =?utf-8?B?Qzl2SUJXa3E1Nnd5SjFBNEx3TWsrdmowc2IxSnZrQXQ2Z2pBMkpEek9xYWVF?=
 =?utf-8?B?ZVFFQjZoNzdqZnd2WU9ybVNrS3hxTHFKZFBkdmhnRTRpNWdBKzJIbnJwc1Mr?=
 =?utf-8?B?NW8zUTJlTUhxYmRtRHNFRWY5QlZJWUxhK1dFbVBJZndNWVozU01taFgzZU9N?=
 =?utf-8?B?ZnliblRUOW5pL0dMRXozQU5oYWVic3VPYjR2QzA4NGliK25OZnBJWFYwQ2hx?=
 =?utf-8?B?ckxLYkJpVDdSM1NVdWVrOHVoKzQrb2lKdVZ4ZVBzVC8zN1JIOW9XcU1rMEZs?=
 =?utf-8?B?aWZ4RGtoclFkZzdNVS92L3I0MzF1U1BYZUQ5dGRqa0MxdC9CcmphNDczZkpU?=
 =?utf-8?B?U1VyVlNBc3BhNlFjTDgvZGNOV1k1UlF5V0xaUldOM0hJZlBUbWRFTWk2WWVP?=
 =?utf-8?B?UU9WNjVMa3BGRHcwWXdwWEZpMXR1V0hYMExVQVZDL2hFc25tRXVTSWdrc0hH?=
 =?utf-8?B?UVh0YkNiOG8zdFpwZEtkblBhR3cyOUNETDQwNjA3UUFQRC9kMUhpOFdlYUhi?=
 =?utf-8?B?UkVwaWR0R2ttd0FQemk0bjAwamVXQW9MVzJWRlByUzk5U2cyS1pRMGNZQU5T?=
 =?utf-8?B?MDE5SDBHZngvRStqL2xjaDFodWdiU2pMdFBDYnA5aWNTWHVOTERQdVNDU3Zs?=
 =?utf-8?B?UGkzOUszUEJuOTBvMWNYUDhYWXJDQjJ5WE12NmxKVlhZV1dTYUxCWE80SGtL?=
 =?utf-8?B?Vy9uSUpFMXc2YXFDYjdRb1pSdzI5VEJ0c3lZYXdIRldVVjUrVTFWV09DeVM2?=
 =?utf-8?B?UWdlY0ozUHYza3dLUC9GQkc5eml3K0NVQlN0ZUhZTFpuL3RQa0diM2lRMXRV?=
 =?utf-8?B?aVIvc0FhSzBGQjR6UlFleVQxYTJQaTdhTi81K0xpdUZuZ3FjN0NXdjRTWUoy?=
 =?utf-8?B?TXo0WXZWUlFycURFektjTnRteFMzSmU4OFNFTis5cmYrUDFXdXBya1dtRE1F?=
 =?utf-8?B?SE1oNmNjV3p6czcxRzQ4K2RMMWRKRFVVZnBWNU84NHFRQ1ozdVhkaFlpVjBW?=
 =?utf-8?B?aVhMQXBRZm1uVTJNOW1ja3VtemtFdm5mbDU0TUlwejVqR3RJbE92WGNsckNN?=
 =?utf-8?B?cXJtK1hhZ29CTFBlVWdVRnJKV3N0RGRsOXNuTm9KTkVabFZpa0lEVTdvZHJh?=
 =?utf-8?B?ZFlZejQ1Qmx1N3kzdUlzY3h1b3RFdkFJbjNtYlZjOFFTUk1nNnRjRzZwVElJ?=
 =?utf-8?B?WTdhT1RCYmdLV1ZOU2o0b3gzQnJtRkdSY2lKNXdLSGUrNko3ZnREQWpTS0ZH?=
 =?utf-8?B?dzZoSTVqa0w3T1VuOVJXL2VyMWV2YUJGUmdpa2tPcDF0VTJUTGs0ZzVTWGRB?=
 =?utf-8?B?bGhpRklpU3FYWkdHd3krcnZ5QXVwT1prbTdBbnREdFVCRmQ3ZzdwMEJmMk5V?=
 =?utf-8?Q?6RCOob?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 05:29:04.5399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61522d82-98fd-406c-a0f4-08dddfaa7a4d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004684.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9789



On 8/19/2025 11:58 PM, Sean Christopherson wrote:
> On Mon, Aug 04, 2025, Nikunj A Dadhania wrote:
>> Require a minimum GHCB version of 2 when starting SEV-SNP guests through
>> KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
>> incompatible GHCB version (less than 2), reject the request early rather
>> than allowing the guest kernel to start with an incorrect protocol version
>> and fail later with GHCB_SNP_UNSUPPORTED guest termination.
>>
>> Hypervisor logs the guest termination with GHCB_SNP_UNSUPPORTED error code:
> 
> s/Hypervisor/KVM, though I don't see any point in saying that KVM is doing
> the logging, that's self-evident from the kvm_amd prefix.  Instead, I think
> what's important to is to say the guest _typically_ requests termination,
> because AFAICT nothing guarantees the guest will fail in this exact way.
> 
>   Not enforcing the minimum version typically causes the guest to request
>   termination with GHCB_SNP_UNSUPPORTED error code:
> 
>     kvm_amd: SEV-ES guest requested termination: 0x0:0x2

Looks good.

>> kvm_amd: SEV-ES guest requested termination: 0x0:0x2
>>
>> SNP guest fails with the below error message:
> 
> This is QEMU output, not guest output.  I don't see any reason to capture this.
> The fact that QEMU apparently doesn't handle KVM_EXIT_SYSTEM_EVENT isn't interesting.
> 
>> KVM: unknown exit reason 24
>> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00a00f11
>> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
>> EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> ES =0000 00000000 0000ffff 00009300
>> CS =f000 ffff0000 0000ffff 00009b00
>> SS =0000 00000000 0000ffff 00009300
>> DS =0000 00000000 0000ffff 00009300
>> FS =0000 00000000 0000ffff 00009300
>> GS =0000 00000000 0000ffff 00009300
>> LDT=0000 00000000 0000ffff 00008200
>> TR =0000 00000000 0000ffff 00008b00
>> GDT=     00000000 0000ffff
>> IDT=     00000000 0000ffff
>> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
>> DR6=00000000ffff0ff0 DR7=0000000000000400
>> EFER=0000000000000000
> 
> 
> No need for you to send a new version, I'm going to post a combined series for
> this and Secure TSC.

Thank you.

Regards
Nikunj

