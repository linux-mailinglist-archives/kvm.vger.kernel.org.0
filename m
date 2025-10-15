Return-Path: <kvm+bounces-60069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE2EBDD9A3
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 11:06:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2534319243A0
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 09:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B793330AAD6;
	Wed, 15 Oct 2025 09:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wp13NorO"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5152226B2D2
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 09:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760519202; cv=fail; b=kih14w97e74H9kLZUUmAr50F3jgRcX3BNBn+S+ZVbvW0VdwKDj4D0URVATHVifhyiyGSexZz882yrpqV8Qd97Ocuq6N6XFDLpW2O/ooK/wKIR3fHBMJaTqTEBWM9GroVe9ZvYkiFTlE3ysAe7FXzVWPqrysA2DbDo7Jq+l4ROck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760519202; c=relaxed/simple;
	bh=c9ZUJlXY3jBY+PH1Nadv/kFVmRWEpbnqIh5TJIGj7ns=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jbSwgva8md80wEU2Pu7yEAShAvSj4aA+TMfdAOhaDLFpXOWfk42FU7uuaf/jcLETsgfW8xUQbFWB6eYqC2obu7v+h7G4i018gohy+R6VBMrHIFV9v6jtNZBIxsk21HQ/mh27mBXPyi+wOsPL9YRFHbIHyphrTFlxiyq7tEN6apY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wp13NorO; arc=fail smtp.client-ip=52.101.61.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YartxYyUPT0ywetLu16E5s1Yk2bK+frMW8WyhvgK2RLTB8nR+U00H4DlYNzz/rk7W0enktbJmmnWsFWqDAOwSyxZoVspKQiMv/OPUektJNeGKcp5nifn8TdlvaF3jxoNAAqv4yJod1wMsQ2CeZLnBvnVOM8Qpd+0hRli43rrp+TsZfhCjIGLg5Y3X3Cuuz1o60pReHLVThfpsUQc7JyLMyMJlGYycvh8WuF4S5G576aiWDtn419BKYHrE7p7FnxSx8EJtMxPJiRAiaNB8//Er3skOEax8v4tsoFA7smoBU2XUx+eu/Vd8y5qLyaRFYhj6sNxMfijHUmxPTnM0hoghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ftrt3zkc3gxlV8poAqJpH94kFWf7+y6niov8cK/zSeI=;
 b=xFKFvLirr82aKIiUb9RekFpDhS3FBSsiLGzNU+X9YtdHzdo2RoDkA3W5m3UxFFBMthMlmDolnd1npurBUtQAQ0vsdITWO8q2omzceADwpi9ID6tUfMV82K//2I6mOQ+BGEJM9MYEf9oscUquSYhZFjB+18HrpXW+Z3CezWmYRJ3jut4/s8TKQ51z2qKKJ00FDJvzlxZ99gzw/0epnRTNAZ5JEm7gH+aESjt8JuYkh2rCb2Ed4jPkCqSqSrS9vDFdSQP8hGSvNZsc+027NT533ndgUpwRQ4OvHLt1Q5VpfX7ATXzXdsivCwBC2fF8+z/ACsVnCAo1N/ucYDEaVEbLsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ftrt3zkc3gxlV8poAqJpH94kFWf7+y6niov8cK/zSeI=;
 b=wp13NorOfi4gPegxHaKQOOLUFHeLxF70VHhJErlOb+jlZKWO1X9Aky3FhtDIizLY/BQQxHKP+ZCMkeO3D+SGf2/VuFtVh9tyen75VcpM2QDgvKqfX0BlQPDpZqgQwRM+xKZ/WDvwq/mxExY6xxuIHHQjYVoZdBJBxZzGzS/LTlo=
Received: from BL1P221CA0006.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::22)
 by DS4PR12MB9817.namprd12.prod.outlook.com (2603:10b6:8:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 09:06:39 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:208:2c5:cafe::f7) by BL1P221CA0006.outlook.office365.com
 (2603:10b6:208:2c5::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.11 via Frontend Transport; Wed,
 15 Oct 2025 09:06:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Wed, 15 Oct 2025 09:06:39 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 15 Oct
 2025 02:06:38 -0700
Received: from [10.252.207.152] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 15 Oct 2025 02:06:36 -0700
Message-ID: <c459768f-5f9d-4ce5-95ff-85678452da57@amd.com>
Date: Wed, 15 Oct 2025 14:36:35 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
 <20251013062515.3712430-5-nikunj@amd.com>
 <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
 <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
 <aO6_juzVYMdRaR5r@google.com>
 <431935458ca4b0bf078582d6045b0bd7f43abcea.camel@intel.com>
 <48e668bb-0b5e-4e47-9913-bc8e3ad30661@amd.com>
 <90621050a295d15ed97b82e2882cb98d3df554d5.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <90621050a295d15ed97b82e2882cb98d3df554d5.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|DS4PR12MB9817:EE_
X-MS-Office365-Filtering-Correlation-Id: a107ddb0-2e7f-4086-b69b-08de0bca2697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2hjcDlMQmRwWVlaNGpIdi95VVpVNVFqWndnYUo5MlZRb3kvTGQvMW1pZ1dL?=
 =?utf-8?B?amZKY2JuTmJaNytLRjgyVGJKOXVLaUk2aW1UVmE1Y0RreGhzK2JPUzJLL2VC?=
 =?utf-8?B?SXpvYXczQms1dTZMYW91UVFkZDhRb1QxbnpobXh3ZUYvSE1WKzZwZGd4cHRQ?=
 =?utf-8?B?MVpPaThNaVpoY0JRN2xBdHJTZHp5VURpMk1INU00TVJsL3dHbjBVbzVrMmpx?=
 =?utf-8?B?VHcwVHNBbXhtMkkwdjRJT043ZlFnSkxKTmpNZnBjSEVjSEhha1hIdlJmNmhL?=
 =?utf-8?B?blhhS2UwYWUzaEJlTVZJR041cFlKclQ4WWVaeXlFNCtMRVhra01abmROZmpW?=
 =?utf-8?B?Sng1ZFQ4ZVcxM2VBS0IraHBIT3VqbjhZRi8rVUZKN2tlU2NpNmNabmpERStN?=
 =?utf-8?B?T3gwVHVSWGN1Y2EwRCs3KzRzay9VeFg4Mmg1NFIzaDc1T2VPNS9MaVdXOGYw?=
 =?utf-8?B?Y3h4U0hqSk1seWNJMkN1Ynlzai9JN096WG9GVitnYmRxamdvMzgxajJ3ZnJ0?=
 =?utf-8?B?SXFGWkI3WE01MDFnU1B2alRTR0o0OVRuU1RrUXJ5MUIvUjErRGFoYm9EcEZh?=
 =?utf-8?B?ZWowVU01cEJZZTc4MTdZaXlKc3ZQK1BvUXB6NkIrcUVybDNNNHNpVzMxNmNG?=
 =?utf-8?B?cmsrVVJTTVVsLzJDamlqS2M3eTlwaE5TZVA1d2V0b2dsUDBIOW02cHJ1dWd2?=
 =?utf-8?B?OTlSMjQ4dVV0UHZxdGI5RjlrS0NpcTIyVjZvRkdqcGJkbVppMThkc0VOYTNT?=
 =?utf-8?B?bHM2MTF6OXp5RlpyaU5SZjRHK2lKZ08zNDhhRGhTUFZObG1YR2RZcFRSV1RD?=
 =?utf-8?B?QnRyTFpKWS9XdWVpaTVrL3EwREpOLy9UUTlKQjRtSDdsZUhBUWtLWFYya1lU?=
 =?utf-8?B?aUtBMmFlQm1aaDBTZlRHSTVLWi8wL0kvWHhhbk5LNjhiUTZLTFdsRnQxUDNq?=
 =?utf-8?B?eEN1cFNweVZFQTkzdTBIU0hhcnpKVW9PQnpCMHB1anZDbEZHSWN2TmV6STVM?=
 =?utf-8?B?Q3Z6MS9CZEZ5eTB4eldFd0ZwcFhncXJCN3Y0N1JjTFE1aHd6QTlrUWtXNVds?=
 =?utf-8?B?WlZOSlVWcGVndWFlVlA1Z0F2dlhRaVhlYVZEak93S01yOUdVZHUycU9Qd21Q?=
 =?utf-8?B?UlhjVGVUTko0KzhsZU9FaGxLVHNaOTFnY2lVN3VhRTlkWVJ2dXRUQ1V2Ujh6?=
 =?utf-8?B?T2ZjbjRGNHNIVnFpcHhiRUFiOW10WElCR3pBL0lGeWs4Y3VJTWIxbUE5L0hk?=
 =?utf-8?B?bnB0NWRWVyswZ00vTXhtakpLeXp1V3p6ZHdxRlk5YXhzUnhFWUlVRDN1T1lB?=
 =?utf-8?B?WUVNaWNrZGN3REc1QlYydURDMDhwM2xFZDdzQ1RydmR2MmpYT2k1M29GMW1J?=
 =?utf-8?B?bm03MVVMcFJtMGd1MXZrLzB5Rmt6aHkxUDRCYUYyc0hOMHpidW5CVlJTN3E0?=
 =?utf-8?B?M0lHeHNhUjhVV2VTQWhGWTVMT2NJUVh6aHpkWlNVYTV3ajgyNnUzRGlhbVh5?=
 =?utf-8?B?VmtGTFNiOUFsc3dlUFcrclo3enlWOW1iZVJmWWZpd1o5eGFVMkZkcTBWTWN2?=
 =?utf-8?B?UHc4ZEZOa2h6eHh1UTBIVll4RmZqeWNrWThVSWszWERwLzlLQTZNR1Vvd2tm?=
 =?utf-8?B?bHFVQ0RoWTZpa3EwZTNjZjBxQlBHVlhTVXFmRGJHMGVhSlBOYmxjcXZCM0tz?=
 =?utf-8?B?alVhU1ZYRXlTUEQ1SFdJSlJwdEdoVEVGUExicWx5dEV2SVZOdkZiNzZOUFBh?=
 =?utf-8?B?a3ZKeGdWWUdlWFI4ODVTSVcxaE9aUHhQSzJUZUVJMUdFM3VVZ3FjZnNFUU54?=
 =?utf-8?B?TjlDNVVmMWZDUEUwamdodUY4WVpBYXlFWlBpWUMyQlF3a0xzMHdNZVdOUnIz?=
 =?utf-8?B?akVYN2hZMHV4aEZpekJsVTVGUTlpSUdlUkc0VlNBdDkvSDBLQW91Q2JkeHBp?=
 =?utf-8?B?U3JiUGZnc1J4dGpsd3NWUTFsQ0k0SHdFd2xlVy9VaXlkM3hpcSs3VWY2SXZj?=
 =?utf-8?B?ZnVxMVpOYzdsVzhUdTZTVy93K2duQlB1eW1CSUdjVXlIWDlDR1ZPelNydUVq?=
 =?utf-8?B?bFRLVDdSOExBb2FDKzdRQys2UDdGUGpGd2xLVnorZWxWeTZ2OVJLSjQwaDZX?=
 =?utf-8?Q?Ju8k=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 09:06:39.1522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a107ddb0-2e7f-4086-b69b-08de0bca2697
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9817



On 10/15/2025 10:57 AM, Huang, Kai wrote:
> On Wed, 2025-10-15 at 10:13 +0530, Nikunj A. Dadhania wrote:
>>
>> On 10/15/2025 3:07 AM, Huang, Kai wrote:
>>> On Tue, 2025-10-14 at 14:24 -0700, Sean Christopherson wrote:
>>>> On Tue, Oct 14, 2025, Kai Huang wrote:
>>>>> On Tue, 2025-10-14 at 11:34 +0000, Huang, Kai wrote:
>>>>>>>   
>>>>>>> +static void kvm_vcpu_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>>>>>>> +{
>>>>>>> +	if (WARN_ON_ONCE(!enable_pml))
>>>>>>> +		return;
>>>>>>
>>>>>> Nit:  
>>>>>>
>>>>>> Since kvm_mmu_update_cpu_dirty_logging() checks kvm-
>>>>>>> arch.cpu_dirty_log_size to determine whether PML is enabled, maybe it's
>>>>>> better to check vcpu->kvm.arch.cpu_dirty_log_size here too to make them
>>>>>> consistent.
>>>>>
>>>>> After second thought, I think we should just change to checking the vcpu-
>>>>>> kvm.arch.cpu_dirty_log_size.
>>>>
>>>> +1
>>>>
>>>>>> Anyway, the intention of this patch is moving code out of VMX to x86, so
>>>>>> if needed, perhaps we can do the change in another patch.
>>
>> I will add this as a pre-patch, does it need a fixes tag ?
> 
> No I don't think there's any bug in the existing upstream code, since for
> VMX guests, checking 'enable_pml' and the per-VM 'cpu_dirty_log_size' is
> basically the same thing.
> 
> I won't stop you from doing this in a separate patch, but I think we can
> just change this patch to check cpu_dirty_log_size with some justification
> in changelog (e.g., below, a bit lengthy but not sure how to trim down):
> 
>   Note KVM common code has a per-VM kvm->arch.cpu_dirty_log_size to
>   indicate whether PML is enabled on VM basis.  It's for supporting
>   running both VMX guests and TDX guests with a KVM global 'enable_pml'
>   module parameter -- TDX doesn't (yet) support PML, and 'enable_pml' is
>   used to enable PML for VMX guests while supporting TDX guests.
> 
>   Currently vmx_update_cpu_dirty_logging() has a WARN() to check
>   '!enable_pml' to make sure it is not mistakenly called when PML is
>   not enabled in KVM.  It's correct for VMX guests.  However such check
>   is no longer correct in x86 common since it doesn't apply to TDX guests.
>  
>   Therefore change to check the per VM cpu_dirty_log_size while moving
>   vmx_update_cpu_dirty_logging() to x86 common.  And it's also more 
>   consistent with kvm_mmu_update_cpu_dirty_logging(), which checks the
>   cpu_dirty_log_size.

I have something like this as a separate patch in my stack:

From 21c3b91ad53dfc2682c01663fe65d60c9424318d Mon Sep 17 00:00:00 2001
From: Nikunj A Dadhania <nikunj@amd.com>
Date: Tue, 30 Sep 2025 05:10:15 +0000
Subject: [PATCH] KVM: VMX: Use cpu_dirty_log_size instead of enable_pml for
 PML checks

Replace the enable_pml check with cpu_dirty_log_size in VMX PML code
to determine whether PML is enabled on a per-VM basis. The enable_pml
module parameter is a global setting that doesn't reflect per-VM
capabilities, whereas cpu_dirty_log_size accurately indicates whether
a specific VM has PML enabled.

For example, TDX VMs don't yet support PML. Using cpu_dirty_log_size
ensures the check correctly reflects this, while enable_pml would
incorrectly indicate PML is available.

This also improves consistency with kvm_mmu_update_cpu_dirty_logging(),
which already uses cpu_dirty_log_size to determine PML enablement.

Suggested-by: Kai Huang <kai.huang@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa1ba8db6392..9e0c0e29d47e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8199,7 +8199,7 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (WARN_ON_ONCE(!enable_pml))
+	if (WARN_ON_ONCE(!vcpu->kvm->arch.cpu_dirty_log_size))
 		return;
 
 	if (is_guest_mode(vcpu)) {
-- 
2.48.1


> 
> Or perhaps Sean has some preference?


