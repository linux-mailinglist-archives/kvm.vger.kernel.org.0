Return-Path: <kvm+bounces-62756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E28FC4CEE9
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:13:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 721E64FF08C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095F4329C45;
	Tue, 11 Nov 2025 10:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="46Tgatwx"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011022.outbound.protection.outlook.com [52.101.62.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229DE2E6CBB;
	Tue, 11 Nov 2025 10:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762855440; cv=fail; b=oT6lcBaK4BK4k1pAHEqaf8SuAZDaG8OCvjVkFO+7i4LJevwUusWThO6SI2UJv7XOSA5pNJyQSSQLuETAsJTylHvTkdctqN6OUk8WVufzR7+QQD67IHjl/1zlqllOwsKelpe5lFLOFoz7ZahEx6doCqowkMqP2XOSbJHYr45/XuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762855440; c=relaxed/simple;
	bh=8uaiNj6nbKr8+UOzta04c0GqvEX2/kW6zHt7wJjdG5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WBmY3FiZ0BMXhwIvLXNcsTrp36uImAXQ2uk8JutDEhhSoGcilVJSrayASx+McZC+/VinkVb8y/eGLNGxDIsTCUc9QaPsz+YLU+42mxa4Dzn/g5VL8qYDq6JBJWImxS6PWE+ARS+8gYUZIdJrqutGUH2dossT9KbEgUBjAn0qO18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=46Tgatwx; arc=fail smtp.client-ip=52.101.62.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BcMuU6pJZwwCn01ZMzzYXBbdZFT5ZOiM3WlibXphEnH8hcnF9AXJPk3PO6n1W8mQ9GEGCaaJdAGLAWWAtxDjZBVGQcaatLCJp4rzbA5bK0zCjdfTgPscN2mCb2NEWLJ4oy/2xAri0heQzgwTeQfHXKrOWXfwaUo1SST1l07A0zkextAjbum1XP6LXHVQGaDj4vuaK8bOUC/IIOwKasmKksqy7FI2+6Om42fnHIfry1P5i0UncNDFX7OMRFJThCPs1dgEhhR/LL4z3u+QQwu3eXbSuERai5iB77Izb0dkg3fO9WuxUgu7zLRfkO892MzOVI+G27y2QDcGMiKpIUmS4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nUph+PVVsC73QDO5uoEp9upJ7KPi9cXcTBaxIioXpVE=;
 b=mJLekEZeSgcU4u/mbk6zFIhMEplA+Z749nA9v5XB7o/pMnFbM0w1WyvEs0hUsMmQYCGEwoLdgQgoLIlIU/L7Op9uZht34mkdJm41w5ZEgzmdmGTzV2lX+MoYBsgSm5eFNj6NyqNa6/Dl9mHFnCigd+s/a9F0+hvHTVQkq1l02PZ6vbDjwt9O7DXPGH6AwXF3Yh19iJnL5dcbqgHdLWIRzgNoNZCTqA/VDp13cLcTYGmm85MKusCKiuTBHxLaClj4ZVHCQOK0RZ3c+rjmGNcIYlbgpTLRBTtsekMU8gFBNVEKPdWkGPr2o7l25hIM7UCny0e13qIq8blJKVKqH2/OMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUph+PVVsC73QDO5uoEp9upJ7KPi9cXcTBaxIioXpVE=;
 b=46TgatwxjjChBxyHjv21cFWuEZAfN+CLPeLn3FiV110FzTpMPtzWvS0wkJQcQi6r47T96yq/yBBPhVdnQRzBjKROic+3Hkml7/+A/oE+1/MBdR/z7LlsQ/NB2SPdBeWIEQvXMKmJYqF9FhlRK1376Xohk9rDeSuqbOLIs6WJxuk=
Received: from PH7P221CA0040.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::24)
 by IA1PR12MB6578.namprd12.prod.outlook.com (2603:10b6:208:3a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 10:03:51 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:510:33c:cafe::49) by PH7P221CA0040.outlook.office365.com
 (2603:10b6:510:33c::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Tue,
 11 Nov 2025 10:03:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 10:03:50 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 11 Nov
 2025 02:03:09 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 11 Nov
 2025 04:03:09 -0600
Received: from [10.136.45.190] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 11 Nov 2025 02:03:02 -0800
Message-ID: <a704b1f7-a550-4c38-b58d-9bc0783019f1@amd.com>
Date: Tue, 11 Nov 2025 15:33:01 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>, Ravi Bangoria
	<ravi.bangoria@amd.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <jmattson@google.com>, <hpa@zytor.com>,
	<rmk+kernel@armlinux.org.uk>, <peterz@infradead.org>, <james.morse@arm.com>,
	<lukas.bulwahn@gmail.com>, <arjan@linux.intel.com>, <j.granados@samsung.com>,
	<sibs@chinatelecom.cn>, <nik.borisov@suse.com>, <michael.roth@amd.com>,
	<nikunj.dadhania@amd.com>, <babu.moger@amd.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<santosh.shukla@amd.com>, <ananth.narayan@amd.com>, <sandipan.das@amd.com>,
	<manali.shukla@amd.com>, <yosry.ahmed@linux.dev>, Shivansh Dhiman
	<shivansh.dhiman@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
 <20240808062937.1149-5-ravi.bangoria@amd.com> <Zr_rIrJpWmuipInQ@google.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <Zr_rIrJpWmuipInQ@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: shivansh.dhiman@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|IA1PR12MB6578:EE_
X-MS-Office365-Filtering-Correlation-Id: f93f4743-0729-413f-a93e-08de21099d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3dpTG5iWUhwckZVWlhFaDUwRzlGek4vMTFSMDNtY1Q5dXhkQUM4NXJkU3Zq?=
 =?utf-8?B?STdlN3EwK0x2ZHU1N2Fuckh3ek1sT0RVSVFWSEN6UWdCWTk2RDlKTitMT0Zi?=
 =?utf-8?B?YnY0WGpxb0daeXd1QmFaM2xieWhHZ1lWYVlkQlNBa0dUVlN2QmpwTjZ6UWlU?=
 =?utf-8?B?OXZNcGt1MXR6MUlCTFRZMXhEUnhZQ0hCbEJ0NHZMR2F5K0tHekZoQ24vbmk2?=
 =?utf-8?B?a1JLZ1BqekpCaVJMekFWd0pVS0pRTFBkN2R3OWt1TXpvd2x2cXArNWhtTWw0?=
 =?utf-8?B?VExndzZ5Rkd4bUFiS0ZCUzN4UjlXN1YrMjVDMEdLaDdabXZjN0JMM2pBY3dG?=
 =?utf-8?B?WVZzRXFIMUViZGZKSFNxMDBoMUZzb05KRDd6WnJRZEJGcGFqcG85dDdXVDZp?=
 =?utf-8?B?MTRidURDNCszLzhsM3BxRnFYS2ovaU5tSUFheTB6RjJMQVVKdzRqbUV3QTZD?=
 =?utf-8?B?T1BJU0VmNHExYlJCdlUrYVFReUgzRWZycjlpc0Y5N1Y3WVNIZkdaemFxTU5O?=
 =?utf-8?B?Qlpub0p6bldJcTZreHgwemEwYTd6a2dkSWNvRjd3NkxQVXp1d2RXNDJZRnhE?=
 =?utf-8?B?K1JNOTJSK1ZiRTJFSjhjK2pkSVBRQUhrcTkyR3dDVm9MT2xHQ1NhemYzbVhZ?=
 =?utf-8?B?aWV1SzM0Vk91elUzL3picUlkUUExcmtMTStld0QwMVBvdk9xOVJpOVdPRWov?=
 =?utf-8?B?anI5U0hwdmswUWNucGwzdGtNTDRHYU5yL2dhcy9BV2tHOGp3RjBMb0MvdnZQ?=
 =?utf-8?B?YitIUzlRYlRGZ0dTd29hUmpieHY3VS9BeDZFckJLZW8rUUppMjN1eWRpVEVs?=
 =?utf-8?B?bkJBVU9yZXU2dlhjaHNOZnVQZlhnSlZEd0ZJNDZkUXdkNkJoS25SN0IxTTdk?=
 =?utf-8?B?dUV2bTNwK3Izc2lBOUN2NkN3eEpIRXRiYTVVbHZPVVBHcUZ0UWxzMHNVek5j?=
 =?utf-8?B?cHQ4RStDVEZ2U09wRUxWNDVJSmlGL290MVgzVUdrR2ovdmlCalh5Y3pITmg0?=
 =?utf-8?B?aU9RQjNwVDFYYU5Xdi83T0JUVzVsREZZUzlpV041bFo0bUJucWhpZHp0clN3?=
 =?utf-8?B?QjdJYVdsQVBaZW9qT2RYUUUwUU1EVDA5Zk9LNmlQeW0rcit3UDhKOVM4YXlp?=
 =?utf-8?B?OER6TjZkZVlCU3Z0RVZ2eXAwWW9PY3g0QjRDdlVVT01nSkFQQnNmWEtXWDll?=
 =?utf-8?B?bmtTT08vMktmcmNZT1dGMVdZcTR1eUNmV21KdlA5bklzZElaOG00bEJXOGF1?=
 =?utf-8?B?TmlqcUJJY2pYNGM5WG9FL1B6R2pxcDlBMkp4T25vWTkwODBGL3pRV1duYTls?=
 =?utf-8?B?enQrWi9pS2JQRlp1QzE0ZEhWUGJjN2JxMHAwNHF4SzJwa3dCUlB4VTU4R3dS?=
 =?utf-8?B?dnMxZUtoSFZQdUxoS3J1VlVrMmlINjRna1ZrWEExK0tNMG5Qb1BSalhaTFh3?=
 =?utf-8?B?NHJpSnJHRndxWEc4VzlSczQ5MFZYUURXR3p4QUNqWVkvQUhQVzF5WGJxZm1u?=
 =?utf-8?B?c2RLV1N0YTBwTzE0azZyR2grMm9WRWR1LzlKcSszdGtmdVZRem5VMERoejBG?=
 =?utf-8?B?TGhNMXhmMnBPQUdqdXVZanlqeGdCS3BXTVZ4MjI5MGNFUEFIMHNSb0tPR0hz?=
 =?utf-8?B?b24yNlNzaEh1UVNDdEdqNHcwelJ0MklBRG4xRHVocTdFYUM4VWdiU29wa2lT?=
 =?utf-8?B?anRjRWRJR1NGdVpmUG53R3kyZ3gzNmRaNU1zMG9MeDIvV1VjSi9OSS9kTGpk?=
 =?utf-8?B?TWJJRnVCWS83dWZmNUVEeUhLMExmL2VZSVZZbUw3NFV0V1VGTDBXeUw1WjlU?=
 =?utf-8?B?dW1uR3UyOUV2Vi9tS0pDenVPa0VwZXN6dHpmNFNsYjNBbko0aGRwZDlqRWdr?=
 =?utf-8?B?WGwwdDlFQXNYOWduN25ldjlrSjN6Y0ZNU1NMcWlUWlowRStYVlJxblN3aTMr?=
 =?utf-8?B?R3JCQ0ZjZnBsaWp2NVJva1Q0OU84K2UyTFZtcXYyVTJBbHQ3dVBob0pacENZ?=
 =?utf-8?B?aWkxTmZrQ2twNXdiZ3VGOXo3NXVETUFPY3krdkN3RFMxVWIxbEUxNWxvN2Ew?=
 =?utf-8?B?V2pEV1FrTE14RUUwdzhRMGhLTkw2M3hEazlYWXlDL0Q2T21qMm1BRlNRWEFZ?=
 =?utf-8?Q?esq4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 10:03:50.7024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f93f4743-0729-413f-a93e-08de21099d22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6578

Hi,

On 17-08-2024 05:43, Sean Christopherson wrote:
> On Thu, Aug 08, 2024, Ravi Bangoria wrote:
>> Add Bus Lock Detect support in AMD SVM. Bus Lock Detect is enabled through
>> MSR_IA32_DEBUGCTLMSR and MSR_IA32_DEBUGCTLMSR is virtualized only if LBR
>> Virtualization is enabled. Add this dependency in the SVM.
> 
> This doesn't depend on the x86 patches that have gone into tip-tree, correct?
> 
> In the future, unless there's an actual depenency in code or functionality,
> please send separate series for patches that obviously need to be routed through
> different trees.
> 
>> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/svm/nested.c |  3 ++-
>>  arch/x86/kvm/svm/svm.c    | 17 ++++++++++++++---
>>  2 files changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 6f704c1037e5..1df9158c72c1 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -586,7 +586,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>>  	/* These bits will be set properly on the first execution when new_vmc12 is true */
>>  	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
>>  		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
>> -		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
>> +		/* DR6_RTM is a reserved bit on AMD and as such must be set to 1 */
>> +		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_FIXED_1 | DR6_RTM;
>>  		vmcb_mark_dirty(vmcb02, VMCB_DR);
>>  	}
>>  
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e1b6a16e97c0..9f3d31a5d231 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1047,7 +1047,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
>> -	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
>> +	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
>> +	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
>>  			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
>>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
> 
> Out of sight, but this leads to calling svm_enable_lbrv() even when the guest
> just wants to enable BUS_LOCK_DETECT.  Ignoring SEV-ES guests, KVM will intercept
> writes to DEBUGCTL, so can't KVM defer mucking with the intercepts and
> svm_copy_lbrs() until the guest actually wants to use LBRs?
> 
> Hmm, and I think the existing code is broken.  If L1 passes DEBUGCTL through to
> L2, then KVM will handles writes to L1's effective value.  And if L1 also passes
> through the LBRs, then KVM will fail to update the MSR bitmaps for vmcb02.
> 
> Ah, it's just a performance issue though, because KVM will still emulate RDMSR.
> 
> Ugh, this code is silly.  The LBR MSRs are read-only, yet KVM passes them through
> for write.
> 
> Anyways, I'm thinking something like this?  Note, using msr_write_intercepted()
> is wrong, because that'll check L2's bitmap if is_guest_mode(), and the idea is
> to use L1's bitmap as the canary.
> 
> static void svm_update_passthrough_lbrs(struct kvm_vcpu *vcpu, bool passthrough)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 
> 	KVM_BUG_ON(!passthrough && sev_es_guest(vcpu->kvm), vcpu->kvm);
> 
> 	if (!msr_write_intercepted(vcpu, MSR_IA32_LASTBRANCHFROMIP) == passthrough)
> 		return;
> 
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, passthrough, 0);
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, passthrough, 0);
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, passthrough, 0);
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, passthrough, 0);
> 
> 	/*
> 	 * When enabling, move the LBR msrs to vmcb02 so that L2 can see them,
> 	 * and then move them back to vmcb01 when disabling to avoid copying
> 	 * them on nested guest entries.
> 	 */
> 	if (is_guest_mode(vcpu)) {
> 		if (passthrough)
> 			svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
> 		else
> 			svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
> 	}
> }
> 
> void svm_enable_lbrv(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 
> 	if (WARN_ON_ONCE(!sev_es_guest(vcpu->kvm)))
> 		return;
> 
> 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
> 	svm_update_passthrough_lbrs(vcpu, true);
> 
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
> }
> 
> static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
> {
> 	/*
> 	 * If LBR virtualization is disabled, the LBR MSRs are always kept in
> 	 * vmcb01.  If LBR virtualization is enabled and L1 is running VMs of
> 	 * its own, the MSRs are moved between vmcb01 and vmcb02 as needed.
> 	 */
> 	return svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK ? svm->vmcb :
> 								   svm->vmcb01.ptr;
> }
> 
> void svm_update_lbrv(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 	u64 guest_debugctl = svm_get_lbr_vmcb(svm)->save.dbgctl;
> 	bool enable_lbrv = (guest_debugctl & DEBUGCTLMSR_LBR) ||
> 			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
> 
> 	if (enable_lbrv || (guest_debugctl & DEBUGCTLMSR_BUS_LOCK_DETECT))
> 		svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
> 	else
> 		svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
> 
> 	svm_update_passthrough_lbrs(vcpu, enable_lbrv);
> }
> 
> 
>> @@ -3158,6 +3159,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>  		if (data & DEBUGCTL_RESERVED_BITS)
> 
> Not your code, but why does DEBUGCTL_RESERVED_BITS = ~0x3f!?!?  That means the
> introduction of the below check, which is architecturally correct, has the
> potential to break guests.  *sigh*
> 
> I doubt it will cause a problem, but it's something to look out for.
> 
>>  			return 1;
>>  
>> +		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
>> +		    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
>> +			return 1;
>> +
>>  		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
>>  		svm_update_lbrv(vcpu);
>>  		break;
>> @@ -5225,8 +5230,14 @@ static __init void svm_set_cpu_caps(void)
>>  	/* CPUID 0x8000001F (SME/SEV features) */
>>  	sev_set_cpu_caps();
>>  
>> -	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
>> -	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>> +	/*
>> +	 * LBR Virtualization must be enabled to support BusLockTrap inside the
>> +	 * guest, since BusLockTrap is enabled through MSR_IA32_DEBUGCTLMSR and
>> +	 * MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
>> +	 * enabled.
>> +	 */
>> +	if (!lbrv)
>> +		kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>>  }
>>  
>>  static __init int svm_hardware_setup(void)
>> -- 
>> 2.34.1
>>

Thanks Sean for the refactored code. I ported your implementation to the 6.16
kernel and did some testing with KVM unit tests. After instrumentation I found
couple of issues and potential fixes.

===========================================================
Issue 1: Interception still enabled after enabling LBRV
===========================================================
Using the 6.16 upstream kernel (unpatched) I ran the KUT tests and they passed
when run from both the bare metal and from inside a L1 guest. However for L2
guest, when looking at the logs I found that RDMSR interception of LBR MSRs is
still enabled despite the LBRV is enabled for the L2 guest. Effectively, the
reads are emulated instead of being virtualized, which is not the intended
behaviour. KUT cannot distinguish between emulated and virtualized RDMSR, and
hence the test passes regardless.


===========================================================
Issue 2: Basic LBR KUT fails with Sean's implementation
===========================================================
After using your implementation, all KUTs passed on the bare metal. With LBRV
enabled for L2, RDMSR interception of LBR MSRs is disabled as intended.
However, when running KUT tests inside an L1 guest, the tests fail.

After digging deeper, I figured that when L2 attempts to update the LBR using
DBGCTL, the L1's LBRs are copied to L2's LBR MSRs from
svm_update_passthrough_lbrs().

/*
 * When enabling, move the LBR msrs to vmcb02 so that L2 can see them,
 * and then move them back to vmcb01 when disabling to avoid copying
 * them on nested guest entries.
 */
if (is_guest_mode(vcpu)) {
	if (passthrough)
		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);  <---- copy happens here
	else
		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
}

This results in DBGCTL and other LBRs of L2 being overwritten by L1's value.
So if L1 has DBGCTL.LBR disabled, L2 won't be able to turn on LBR. This results
in failing KUT test.

L2>  wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
L2>  DO_BRANCH(host_branch0);
L2>  dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
L2>  wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
L2>  TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);  <---- This check fails since
                                                      dbgctl is still 0

Line-by-line code analysis
--------------------------

KVM>  # start L1 guest
<L1>  # start KUT test svm_lbrv_test0

<L2>  wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
KVM>  # inject wrmsr into L1
<L1>  vmcb01->control.virt_ext = 1;  <---- L1's vmcb01 is vmcb12 wrt KVM
<L1>  # turn off intercepts
<L1>  vmrun
KVM>  vmcb02->control.virt_ext = 1;
KVM>  svm_copy_lbrs(vmcb02, vmcb12);  <---- Correct value loaded here
KVM>  nested.ctl.virt_ext = 1;
KVM>  # turn off intercepts
KVM>  svm_copy_lbrs(vmcb02, vmcb01);  <---- This overwrites the value
KVM>  # start L2 guest

<L2>  DO_BRANCH(host_branch0);
<L2>  dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
...
<L2>  wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
...
<L2>  TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);  <---- This check fails


===========================================================
Potential Solution
===========================================================
A potential fix is to copy the LBRs only when L1 has DBGCTL.LBR is enabled.
This will prevent the overwrite. I successfully tested it by running KUT on
all levels, viz, bare metal, L1 and L2. Please share your thoughts on
this.

if (is_guest_mode(vcpu) && svm->vmcb01.ptr->save.dbgctl & DEBUGCTLMSR_LBR) {
	if (passthrough)
		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
	else
		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
}

If the patch below looks good, I'll split it and send it as a series.
Additionaly, I added a MSR read interception API similar to the one
implemented by Ravi.

---
 arch/x86/kvm/svm/svm.c | 66 ++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..f0f77199ec12 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -663,6 +663,11 @@ static void clr_dr_intercepts(struct vcpu_svm *svm)
 	recalc_intercepts(svm);
 }

+static bool msr_read_intercepted_msrpm(void *msrpm, u32 msr)
+{
+	return svm_test_msr_bitmap_read(msrpm, msr);
+}
+
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
 	/*
@@ -864,32 +869,49 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
 }

-void svm_enable_lbrv(struct kvm_vcpu *vcpu)
+static void svm_update_passthrough_lbrs(struct kvm_vcpu *vcpu, bool passthrough)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool to_intercept = !passthrough;

-	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	svm_recalc_lbr_msr_intercepts(vcpu);
+	KVM_BUG_ON(to_intercept && sev_es_guest(vcpu->kvm), vcpu->kvm);

-	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
-	if (is_guest_mode(vcpu))
-		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
+	if (msr_read_intercepted_msrpm(svm->msrpm, MSR_IA32_LASTBRANCHFROMIP) == to_intercept)
+		return;
+
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_R, to_intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_R, to_intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_R, to_intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_R, to_intercept);
+
+	/*
+	 * When enabling, move the LBR msrs to vmcb02 so that L2 can see them,
+	 * and then move them back to vmcb01 when disabling to avoid copying
+	 * them on nested guest entries.
+	 *
+	 * Perform this only when L1 has enabled LBR to prevent the overwrite.
+	 */
+	if (is_guest_mode(vcpu) && svm->vmcb01.ptr->save.dbgctl & DEBUGCTLMSR_LBR) {
+		if (passthrough)
+			svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
+		else
+			svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
+	}
 }

-static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
+void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);

-	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
-	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	svm_recalc_lbr_msr_intercepts(vcpu);
+	/* Allow the function call from SEV-ES guests only */
+	if (WARN_ON_ONCE(!sev_es_guest(vcpu->kvm)))
+		return;

-	/*
-	 * Move the LBR msrs back to the vmcb01 to avoid copying them
-	 * on nested guest entries.
-	 */
-	if (is_guest_mode(vcpu))
-		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
+	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
+
+	svm_update_passthrough_lbrs(vcpu, true);
+
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW, 0);
 }

 static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
@@ -906,18 +928,18 @@ static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
 void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
-	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
+	u64 guest_debugctl = svm_get_lbr_vmcb(svm)->save.dbgctl;
+	bool enable_lbrv = (guest_debugctl & DEBUGCTLMSR_LBR) ||
 			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));

-	if (enable_lbrv == current_enable_lbrv)
-		return;

 	if (enable_lbrv)
-		svm_enable_lbrv(vcpu);
+		svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
 	else
-		svm_disable_lbrv(vcpu);
+		svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+
+	svm_update_passthrough_lbrs(vcpu, enable_lbrv);
 }

 void disable_nmi_singlestep(struct vcpu_svm *svm)
-- 
2.43.0



