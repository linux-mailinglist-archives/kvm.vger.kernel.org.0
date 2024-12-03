Return-Path: <kvm+bounces-32961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1909E2E60
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 22:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECA11164A29
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F4520898C;
	Tue,  3 Dec 2024 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SN0A0j7i"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056C317ADE1;
	Tue,  3 Dec 2024 21:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733262409; cv=fail; b=brYspvLwr0BQwiYPfDP9OX2U785NyFXtzV6Stfct2Tl4gAo6J58IJVKLsvO93WS/NHplJGYbqGJp3107/pLmDwjFO7ArjA5rBqtUsq83AXbat6UnI6NlE13cFMAqtrzhw4bzy8JdAcZwPvhBbf0ZAk82unWPe6jhEhE1KCI3vrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733262409; c=relaxed/simple;
	bh=gPWWF56n/hgtrWPF7kDDP0YlC8p5NXDq6BF/w/ZO3qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fM1O/ALfSnU/tGn/VCMOnVbKQnbpaNIDO0CiNDofjIWMuTw3+KmxcDLp8XDZCD8TQ9kXNEAygv7UYuTeDJhvbxIIJIwzEJfUNKJUCcZRXdgG/ofKM2S2dOTiepOPyTEfXOD505BfsrHoRrqONIkFdn3TQBE7zWYQpIXWIi+Fgug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SN0A0j7i; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DpbVuwcX7FvZKrulWqGWctal8Ais3GA+URPrQ/s0x/UCyWj6rfvKW6e/mTehHQpww0R/zda5+A4wnqtHrmk+XLtkjIBhqyrmWewHtzVCc55aGDWtIQb3pve5XgVef8f6dsquU64pE+ItWNRhnyyyofFfRl0VKovx1fbciXKPOceuTs4+eLNZs/ZnaFqUBOA9iAFXng9z9g0E/9vWtWLz1QkpiLRPUT7BDkPGwqM49Xbu4o34LH3vTk1taR938OpQKzVojcLFzyQghmTT9XV3miCy+Um0SbUDOBvNNc0lh0fV8O/MS82F2rBxjQkr0LSvDHiExMcTfiEjtS1FZatQog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snmwSH0bVGsJ19kIjdDwEwLPlFgd6KfZt49K+Wf9ii4=;
 b=B1uoYCvVPIOZ3CdqVN1CtuYsltK1nhPh0b0EFU7D2rqAoA6MgUADaY7DmngEGgBvQAHn2GQ2nHZvCrJypI3oG9k4NSqWMPC97lBwaCVZ5tLDlw6JHduTEF9A6lGXfIiO186ddyqh53KyBMOMYhJ0z5GeYEtrO86fxtITdm7qZFM7l6hZQMEPl25xrY8a98+t2ChjO7TXoTDBfx0/nFjtLg8uCNaeNNgR0Gr3+kGfZS29up5LXZOsXdqVQOCyUiVZ/EhpiZh10+xv9grTJHmfkxrBqN64BgZIb3TjtrxlAMNiFv1Y5Tt7/X1/dRsQU4bcp7evXB7HE27OqUKd6Cj5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snmwSH0bVGsJ19kIjdDwEwLPlFgd6KfZt49K+Wf9ii4=;
 b=SN0A0j7iS2Os/Yja1ACRmfvrjS/ijniiKKcDbhyBVB6lLZ67lOiq3PJBqLvIinCo8dAnK1Zf7pYiaYo4UZUARpCT6jLy8zsO3QM5Ry67uTdBPTs8i0+JtRZx4OYcuVBWVpi1YROhKBE4qaM795K0mJx5rCA2Z1LLzaZ1xkuqwDE=
Received: from CH2PR05CA0013.namprd05.prod.outlook.com (2603:10b6:610::26) by
 SJ2PR12MB8925.namprd12.prod.outlook.com (2603:10b6:a03:542::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.18; Tue, 3 Dec 2024 21:46:44 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:610:0:cafe::4) by CH2PR05CA0013.outlook.office365.com
 (2603:10b6:610::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.9 via Frontend Transport; Tue, 3
 Dec 2024 21:46:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.1 via Frontend Transport; Tue, 3 Dec 2024 21:46:43 +0000
Received: from [10.23.192.43] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 15:46:42 -0600
Message-ID: <c09a99e8-913f-4a86-ba0b-c64d5cdcfb2e@amd.com>
Date: Tue, 3 Dec 2024 13:46:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SVM: Convert plain error code numbers to defines
To: Sean Christopherson <seanjc@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, KVM
	<kvm@vger.kernel.org>, Pavan Kumar Paluri <papaluri@amd.com>
References: <20241202214032.350109-1-huibo.wang@amd.com>
 <Z05MrWbtZQXOY2qk@google.com>
Content-Language: en-US
From: "Melody (Huibo) Wang" <huibo.wang@amd.com>
In-Reply-To: <Z05MrWbtZQXOY2qk@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|SJ2PR12MB8925:EE_
X-MS-Office365-Filtering-Correlation-Id: 9558454f-db6b-4d72-aeaa-08dd13e3fa87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2E1ODcwaTRpVzFNcDBzMisramlnN0FZODhaYjVBb1RIQmhFdk11ZDVWREcr?=
 =?utf-8?B?ejZnRS9ndXhVcG5yYnVjeWVWTDkzMFNmNlpBZzVFRUkxLzkvUnhObjdOWTJS?=
 =?utf-8?B?SnBVeVVaSG5QVks2bFh3ZTE3bkR0MXFsL1FmOFRMbk84ellLRXhVa0sza01V?=
 =?utf-8?B?VGQ0VUp6RitiaFQ3TkpoRStuNFJISEFtMnZUcjAyQ2czMnVWRWhReHV2YTh0?=
 =?utf-8?B?M2NzcjdRWVlzczdZQzNkVUt1THpMZ1FTYlB5REM3V0pjQk8yNERIdXUvaTZD?=
 =?utf-8?B?bkdsM1VoektKWFVFWUhsZXI5bUh1SmZNQk9oakphN1B0UkYvQnVEVnpXMXVU?=
 =?utf-8?B?TTd5UTBvVm52a25GaG55a1ZzSDlkRnJIdEExeWFYNW13Y3R2R0grRU01REd4?=
 =?utf-8?B?MnpSUGZVY3hWM0N5elNJdTVaNTBpR1VWU1BwZ1NLVDkvYlpOeG91bUtBT1U2?=
 =?utf-8?B?QWxRcEN6QmhXTzlCOVNmdEJuL2lCMDQwZnZ3Q0V1S1VEYWdpUVlOSEo4cVVR?=
 =?utf-8?B?cHhFemNZVk5EV0RTc3NKQzcrV2V5TGQyNjRPbDZqV0VCalBSVms2RjBYajd5?=
 =?utf-8?B?QUZmekpNU05xQ3QzdTYrc096RkZaQmoxYWFsTnJISEFKVXB4YndKbDc3QnlS?=
 =?utf-8?B?UVlZbDJjTlFmdUdZUG0xZlFaM0JjeHE4VmE0TE5RZmtpZjEraUlKVDA2RzRt?=
 =?utf-8?B?Q0o0Y3F0WktSdS9rdTRqMTAwVXEybEdiQVNTNFErN2svcHJUUVVTdk5IWG5m?=
 =?utf-8?B?WkxqTkhtaFpVN2RTcUtmbjZEazJETHFWWWdHR1pUTFRCTjgzNU9QZlJlR1B3?=
 =?utf-8?B?YUxVSll3L2hWcGg2b3A1UFVXZVZzRTFpZVVQODUwQS8wdm1Bc0pGSllYZWxS?=
 =?utf-8?B?bEVOcXNHeWxydStqVUk2T0JvSG42RmRuSS9FNUNaQ0N5MmVJa1V2K0FHVGx1?=
 =?utf-8?B?S0EyaDBDK1Voald4ZmpFSEdCYk5oSTRhVzFzdUV0azlmM1ZmajRIaUd1cEVR?=
 =?utf-8?B?eTl6WWxmZUdWdjNBRjY0bktFYzJyZGw2S0lNNWpQODJPbkZNdlhKYTljQ1Vt?=
 =?utf-8?B?N1R5NVdzNUFLOHp6RGJUYmtEaERPOGpnUm9pQjZqbUNEdVpCalE1TGNsMDhs?=
 =?utf-8?B?aVR1TGxZTTZ0dHRWYzlxZVZPN0REU1RneG9lbVdXeXBuUlhIcXdsbFhkQ2w5?=
 =?utf-8?B?ZTAzUFBwbXl1RUJJVkp1bDVmVkhOaWRQRytHblp4MnUxeUd6UHlKaG1jVXJ0?=
 =?utf-8?B?UEE4MmFtOFRhdDlLSitMVlhzZDhhaHlxMlBSbU5iaXRjTVBscE1VV2lWdGR0?=
 =?utf-8?B?L3JIYmhDd1M1bS82WFd6cUpXL2l0U0tMYTFROVZTM1htc0IzNlFjSVNnWmhX?=
 =?utf-8?B?TEhLOUVVRlNpVmpHYk8waGFCUFJ4VXRPUXN0QTlNMm9sblVublhsdUhZWWtX?=
 =?utf-8?B?ZFV2RWtHVVlnZU5tcVo3NUdQRm5lZEZXSjkveFlrNnRxWkx2UjNHVzhOcEJE?=
 =?utf-8?B?VS8wSlFpaHcxdW5wUVlSdms3S280TUd0aEdxRWphRjlIWGhKaVoxVXcxWFA2?=
 =?utf-8?B?ejVEVjZzbGZEQlBEM0JINzkxb1d1Wm5QWEVEYWR0Q3kxTG9POHpOblpGOXZO?=
 =?utf-8?B?M0tRTzZ1UXJDbmVibjcxR25NOEgvUUNQUXNBVUtMTndwcWdCUUUvRUY0WGZP?=
 =?utf-8?B?czY4SGZOcUtXWHNtTjdzTlFKdmZOVEh0c2FhOTFIaks4MTdLT0l4dnNUck1W?=
 =?utf-8?B?UThrTEUvSWJETUgvM3RJcmw3dHdHUFhvK1BnMTU4amU0QVpFTHlDNE4rOG1k?=
 =?utf-8?B?UUMyZFdhVDZKOWN3RWVVOFllSzRjMHQ2aVdGUWxObHlPM1p6S0lTeEtydGtS?=
 =?utf-8?B?RFZsVGlqK25ySmxQblFaQlYzdTZHblhmZWVWQy9WS1RHTXlPelY0WGJVQ3Fq?=
 =?utf-8?Q?fghmatOohupwPvdIi8Q/Qfh4FL+5Keaj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 21:46:43.7240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9558454f-db6b-4d72-aeaa-08dd13e3fa87
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8925

Hi Sean,

On 12/2/2024 4:11 PM, Sean Christopherson wrote:

> 
> E.g. something like this?  Definitely feel free to suggest better names.
> 
> static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
> 					       u64 response, u64 data)
> {
> 	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
> 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
> }
> 
If I make this function more generic where the exit info is set for both KVM and the guest, then maybe I can write something like this:

void ghcb_set_exit_info(struct ghcb *ghcb,
                      u64 info1, u64 info2)
{
	ghcb_set_sw_exit_info_1(ghcb, info1);
	ghcb_set_sw_exit_info_2(ghcb, info2);

}
This way we can address every possible case that sets the exit info - not only KVM. 

And I am not sure about the wrappers for each specific case because we will have too many, too specific small functions, but if you want them I can add them.

Thanks,
Melody


